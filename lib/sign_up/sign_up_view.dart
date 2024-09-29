import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:peakflow/home/home.dart';
import 'package:peakflow/login/login_view.dart';
import 'package:peakflow/services/database.dart';
import 'package:peakflow/widgets/custom_text_field_widget.dart';
import 'package:peakflow/widgets/image_picker_widget.dart';
import 'package:peakflow/widgets/multi_selector_widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "",
      password = "",
      name = "",
      surname = "",
      location = "",
      avatarUrl = "";
  int age = 0;
  List<String> selectedInterests = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  File? _image;

  DatabaseMethods databaseMethods = DatabaseMethods();

  final List<String> _interests = [
    "Running",
    "Cycling",
    "Swimming",
    "Tennis",
    "Gym Workouts",
    "Yoga",
    "Rock Climbing",
    "Hiking",
    "Martial Arts",
    "Dance Classes",
    "Pilates",
    "Group Fitness Classes",
    "Rowing",
    "Skateboarding",
    "Surfing",
    "Triathlon Training",
    "Mountain Biking",
    "CrossFit",
    "Outdoor Boot Camps",
    "Adventure Racing"
  ];

  double _minAge = 18;
  double _maxAge = 60;

  Future<String> uploadImage(File image) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child("avatars/${DateTime.now().toString()}.png");
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      print(e);
      return "";
    }
  }

  bool validatePassword(String password) {
    String pattern = r'^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>])(?=.{4,})';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }

  registration() async {
    if (!validatePassword(password)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.orangeAccent,
        content: Text(
          "Password must contain at least 1 uppercase letter, 1 special character, and be at least 4 characters long.",
          style: TextStyle(fontSize: 20.0),
        ),
      ));
      return;
    }

    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.orangeAccent,
        content: Text(
          "Invalid email address, it must contain '@'",
          style: TextStyle(fontSize: 20.0),
        ),
      ));
      return;
    }

    try {
      age = int.parse(ageController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.orangeAccent,
        content: Text(
          "Age must be a valid number",
          style: TextStyle(fontSize: 20.0),
        ),
      ));
      return;
    }

    if (password.isNotEmpty &&
        email.isNotEmpty &&
        name.isNotEmpty &&
        surname.isNotEmpty &&
        location.isNotEmpty &&
        selectedInterests.isNotEmpty) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        String userId = userCredential.user!.uid;

        if (_image != null) {
          avatarUrl = await uploadImage(_image!);
        }

        Map<String, dynamic> userInfoMap = {
          "name": name,
          "surname": surname,
          "location": location,
          "email": email,
          "password": password,
          "userId": userId,
          "avatarUrl": avatarUrl,
          "interests": selectedInterests,
          "ageRange": {
            "min": _minAge,
            "max": _maxAge,
          },
          "age": age,
          "createdAt": DateTime.now().millisecondsSinceEpoch,
        };

        await databaseMethods.addUser(userId, userInfoMap);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Home()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Password Provided is too weak",
                style: TextStyle(fontSize: 20.0),
              )));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Account Already exists",
                style: TextStyle(fontSize: 20.0),
              )));
        }
      }
    }
  }

  Widget rangeAgeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select age range of people you meet:",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        RangeSlider(
          values: RangeValues(_minAge, _maxAge),
          min: 16,
          max: 100,
          divisions: 100,
          activeColor: Colors.orange,
          inactiveColor: Colors.white,
          labels: RangeLabels(
            _minAge.round().toString(),
            _maxAge.round().toString(),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _minAge = values.start;
              _maxAge = values.end;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 20),
          child: Text(
            "Age Range: ${_minAge.round()} - ${_maxAge.round()}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget signUpButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            backgroundColor: const Color.fromARGB(255, 184, 70, 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60),
            ),
            elevation: 5.0,
          ),
          onPressed: () {
            setState(() {
              name = nameController.text;
              surname = surnameController.text;
              location = locationController.text;
              email = emailController.text;
              password = passwordController.text;
              if (ageController.text.isNotEmpty) {
                try {
                  age = int.parse(ageController.text);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.redAccent,
                      content: Text(
                        "Please enter a valid number for age",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  );
                  return;
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: Text(
                      "Age field cannot be empty",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                );
                return;
              }
            });
            registration();
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget alreadyHaveAccount() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Already have an account? ",
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SignIn()));
            },
            child: const Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
              child: Text(
                "Sign In",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(240, 255, 219, 164),
              Color.fromARGB(255, 220, 158, 88),
              Color.fromARGB(255, 227, 138, 37),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ImagePickerWidget(),
                CustomTextField(controller: nameController, hintText: "Name"),
                CustomTextField(
                    controller: surnameController, hintText: "Surname"),
                CustomTextField(controller: ageController, hintText: "Age"),
                CustomTextField(
                    controller: locationController, hintText: "Location"),
                MultiSelectorWidget(
                    interests: _interests,
                    selectedInterests: selectedInterests),
                CustomTextField(controller: emailController, hintText: "Email"),
                CustomTextField(
                    controller: passwordController, hintText: "Password"),
                rangeAgeSelector(),
                signUpButton(),
                alreadyHaveAccount(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

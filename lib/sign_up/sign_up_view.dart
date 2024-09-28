import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:peakflow/home/home.dart';
import 'package:peakflow/login/login_view.dart';
import 'package:peakflow/services/database.dart';

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
      avatarUrl = "",
      age = "";
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

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

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

  registration() async {
    if (password.isNotEmpty &&
        email.isNotEmpty &&
        name.isNotEmpty &&
        surname.isNotEmpty &&
        location.isNotEmpty &&
        age.isNotEmpty &&
        selectedInterests.isNotEmpty) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        String userId = userCredential.user!.uid;

        // Upload avatar and get the download URL if an image was picked
        if (_image != null) {
          avatarUrl = await uploadImage(_image!);
        }

        // Creating a map of user data
        Map<String, dynamic> userInfoMap = {
          "name": name,
          "surname": surname,
          "location": location,
          "email": email,
          "password": password,
          "userId": userId,
          "avatarUrl": avatarUrl, // Optional avatar URL
          "interests": selectedInterests,
          "ageRange": {
            "min": _minAge,
            "max": _maxAge,
          },
          "age": age,
          "createdAt": DateTime.now().millisecondsSinceEpoch,
        };

        // Adding user data to the database
        await databaseMethods.addUser(userId, userInfoMap);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Registered Successfully",
              style: TextStyle(fontSize: 20.0),
            )));

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
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    margin:
                        const EdgeInsetsDirectional.only(top: 80, bottom: 30),
                    width: 150.0,
                    height: 150.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: ClipOval(
                      child: _image != null
                          ? Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              "images/add_avatar.png",
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                TextField(
                  cursorColor: const Color.fromARGB(255, 227, 138, 37),
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: "Name",
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 227, 138, 37), width: 1.5),
                    ),
                  ),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30.0),
                TextField(
                  cursorColor: const Color.fromARGB(255, 227, 138, 37),
                  controller: surnameController,
                  decoration: const InputDecoration(
                    hintText: "Surname",
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 227, 138, 37), width: 1.5),
                    ),
                  ),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30.0),
                TextField(
                  cursorColor: const Color.fromARGB(255, 227, 138, 37),
                  controller: ageController,
                  decoration: const InputDecoration(
                    hintText: "Age",
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 227, 138, 37), width: 1.5),
                    ),
                  ),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30.0),
                TextField(
                  cursorColor: const Color.fromARGB(255, 227, 138, 37),
                  controller: locationController,
                  decoration: const InputDecoration(
                    hintText: "Location",
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 227, 138, 37), width: 1.5),
                    ),
                  ),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30.0),
                // Widget do wielokrotnego wyboru zainteresowań
                MultiSelectDialogField(
                  items: _interests
                      .map((interest) => MultiSelectItem(interest, interest))
                      .toList(),
                  title: const Text("Select Interests"),
                  selectedColor: Colors.orange,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  buttonIcon: const Icon(
                    Icons.arrow_circle_down_sharp,
                    color: Colors.white,
                  ),
                  buttonText: const Text(
                    "Choose Interests",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  onConfirm: (values) {
                    setState(() {
                      selectedInterests = List<String>.from(values);
                    });
                  },
                ),
                const SizedBox(height: 30.0),
                TextField(
                  cursorColor: const Color.fromARGB(255, 227, 138, 37),
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 227, 138, 37), width: 1.5),
                    ),
                  ),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                ),
                const SizedBox(height: 30.0),
                TextField(
                  cursorColor: const Color.fromARGB(255, 227, 138, 37),
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 227, 138, 37), width: 1.5),
                    ),
                  ),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  obscureText: true,
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                ),
                const SizedBox(height: 30.0),
                Column(
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
                      min: 16, // Ustaw min na 0
                      max: 100,
                      divisions: 100, // Zwiększ liczbę podziałów
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
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 20.0),
                        backgroundColor: const Color.fromARGB(
                            255, 184, 70, 4), // Button color
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
                          age = ageController.text;
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
                ),
                const SizedBox(height: 20.0),
                Padding(
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignIn()));
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

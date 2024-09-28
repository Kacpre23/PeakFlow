import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:peakflow/home/home.dart';
import 'package:peakflow/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:peakflow/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "", password = "", name = "", avatarUrl = "";
  TextEditingController namecontroller = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  File? _image;

  DatabaseMethods databaseMethods = DatabaseMethods();

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
        _image != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        String userId = userCredential.user!.uid;

        // Upload avatar and get the download URL
        avatarUrl = await uploadImage(_image!);

        Map<String, dynamic> userInfoMap = {
          "name": name,
          "email": email,
          "password": password,
          "userId": userId,
          "avatarUrl": avatarUrl, // Add avatar URL
          "createdAt": DateTime.now().millisecondsSinceEpoch,
        };

        await databaseMethods.addUser(userId, userInfoMap);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Registered Successfully",
              style: TextStyle(fontSize: 20.0),
            )));

        Navigator.push(
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
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(240, 255, 219, 164),
              Color.fromARGB(255, 220, 158, 88),
              Color.fromARGB(255, 227, 138, 37),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  margin: const EdgeInsetsDirectional.only(top: 80, bottom: 30),
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
                controller: namecontroller,
                decoration: const InputDecoration(
                  hintText: "Name",
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 227, 138, 37),
                      width: 1.5,
                    ),
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30.0),
              TextField(
                cursorColor: const Color.fromARGB(255, 227, 138, 37),
                controller: mailcontroller,
                decoration: const InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 227, 138, 37),
                      width: 1.5,
                    ),
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30.0),
              TextField(
                cursorColor: const Color.fromARGB(255, 227, 138, 37),
                controller: passwordcontroller,
                decoration: const InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 227, 138, 37),
                      width: 1.5,
                    ),
                  ),
                ),
                obscureText: true,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (namecontroller.text.isNotEmpty &&
                      mailcontroller.text.isNotEmpty &&
                      passwordcontroller.text.isNotEmpty &&
                      _image != null) {
                    setState(() {
                      email = mailcontroller.text;
                      name = namecontroller.text;
                      password = passwordcontroller.text;
                    });
                    registration();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 20.0),
                  backgroundColor:
                      const Color.fromARGB(255, 184, 70, 4), // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  elevation: 5.0,
                ),
                child: const Text(
                  "Sign up",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
    );
  }
}

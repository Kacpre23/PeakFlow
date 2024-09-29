import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peakflow/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class PersonalDetails extends StatefulWidget {
  final String userId;

  const PersonalDetails({super.key, required this.userId});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final DatabaseMethods databaseMethods = DatabaseMethods();
  String name = "";
  String surname = "";
  String email = "";
  String location = "";
  String avatarUrl = "";
  String age = "";
  File? _image;

  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.userId)
        .get();

    if (userDoc.exists) {
      setState(() {
        name = userDoc['name'];
        surname = userDoc['surname'];
        email = userDoc['email'];
        location = userDoc['location'];
        age = userDoc['age'];
        avatarUrl = userDoc['avatarUrl'] ?? '';

        nameController.text = name;
        surnameController.text = surname;
        emailController.text = email;
        locationController.text = location;
        ageController.text = age;
      });
    }
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await uploadImage(_image!);
    }
  }

  Future<String> uploadImage(File image) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child("avatars/${DateTime.now().toString()}.png");
      await ref.putFile(image);
      String downloadUrl = await ref.getDownloadURL();
      await _updateUserAvatar(downloadUrl);
      return downloadUrl;
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<void> _updateUserAvatar(String url) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.userId)
        .update({"avatarUrl": url});
  }

  Future<void> _updateUserDetails() async {
    Map<String, dynamic> updatedInfoMap = {
      "name": nameController.text,
      "surname": surnameController.text,
      "email": emailController.text,
      "location": locationController.text,
      "age": ageController.text,
    };

    await databaseMethods.updateUser(widget.userId, updatedInfoMap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          width: MediaQuery.of(context).size.width,
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
                        : (avatarUrl.isNotEmpty
                            ? Image.network(
                                avatarUrl,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "images/add_avatar.png",
                                fit: BoxFit.cover,
                              )),
                  ),
                ),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: "Name",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 227, 138, 37), width: 1.5),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: surnameController,
                decoration: const InputDecoration(
                  hintText: "Surname",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 227, 138, 37), width: 1.5),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "Email",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 227, 138, 37), width: 1.5),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  hintText: "Location",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 227, 138, 37), width: 1.5),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(
                  hintText: "Age",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 227, 138, 37), width: 1.5),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 40.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 20.0),
                  backgroundColor: const Color.fromARGB(255, 184, 70, 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  elevation: 5.0,
                ),
                onPressed: () {
                  _updateUserDetails();
                },
                child: const Text(
                  "Update Details",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }
}

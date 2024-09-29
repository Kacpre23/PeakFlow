import 'package:firebase_auth/firebase_auth.dart';
import 'package:peakflow/home/home.dart';
import 'package:peakflow/sign_up/sign_up_view.dart';
import 'package:flutter/material.dart';
import 'package:peakflow/widgets/custom_text_field_widget.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String email = "", password = "";

  TextEditingController mailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();

  userlogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Home()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "No User Found for that Email",
              style: TextStyle(fontSize: 20.0),
            )));
      } else if (e.code == "wrong-password") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Wrong password Provided by User",
              style: TextStyle(fontSize: 20.0),
            )));
      }
    }
  }

  Widget loginButton() {
    return ElevatedButton(
      onPressed: () {
        if (mailcontroller.text.isNotEmpty &&
            passwordcontroller.text.isNotEmpty) {
          setState(() {
            email = mailcontroller.text;
            password = passwordcontroller.text;
          });
        }
        userlogin();
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        backgroundColor: const Color.fromARGB(255, 184, 70, 4), // Button color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60), // Rounded corners
        ),
        elevation: 5.0, // Button elevation
      ),
      child: const Text(
        "Log in",
        style: TextStyle(
          color: Colors.white,
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget dontHaveAccount() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account? ",
            style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 18.0,
                fontWeight: FontWeight.w500),
          ),
          GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SignUp()));
              },
              child: const Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Image.asset("images/peakflow_image.jpg"),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Color.fromARGB(240, 255, 219, 164),
                    Color.fromARGB(255, 220, 158, 88),
                    Color.fromARGB(255, 227, 138, 37),
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30.0,
                        ),
                        CustomTextField(
                            controller: mailcontroller, hintText: "Email"),
                        CustomTextField(
                          controller: passwordcontroller,
                          hintText: "Password", obscureText: true
                        ),
                        const Spacer(),
                        loginButton(),
                        const Spacer(),
                        dontHaveAccount(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

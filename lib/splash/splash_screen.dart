import 'package:flutter/material.dart';
import 'package:peakflow/home/home.dart';
import 'package:peakflow/login/login_view.dart'; // Ensure this is your SignIn page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // SplashScreen is the starting page
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToSignIn();
  }

  // Function to delay the splash screen for 3 seconds and navigate to SignIn
  _navigateToSignIn() async {
    await Future.delayed(Duration(seconds: 8), () {}); // Delay for 3 seconds
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignIn()), // Navigate to SignIn screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Background color for splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
              children: [Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 255, 219, 164),
                    Color.fromARGB(255, 220, 158, 88),
                    Color.fromARGB(255, 227, 138, 37),
                  ]
                      ))), 
            // Display the GIF here
            Image.asset(
              'images/cat_walking.gif', // Ensure the path to your local GIF is correct
              width: 150, // Adjust width as needed
              height: 150, // Adjust height as needed
            ),
            //SizedBox(height: 20),
            // Icon(
            //   Icons.ac_unit, // Placeholder for a logo or other icon
            //   size: 100.0,
            //   color: const Color.fromARGB(255, 212, 165, 114), // Change color to match your theme
            // ),
            // SizedBox(height: 20),
            // Text(
            //   'Welcome to PeakFlow!',
            //   style: TextStyle(
            //     fontSize: 28,
            //     color: const Color.fromARGB(255, 253, 130, 23), // Match the text color to your app theme
            //     fontWeight: FontWeight.bold, // Make the text bold

            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
import 'package:firebase_core/firebase_core.dart';
import 'package:peakflow/login/login_view.dart';
//import 'package:peakflow/sign_up/sign_up_view.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          appId: '1:770970331880:android:4b05ff9969e106bca5b75d',
          apiKey: 'AIzaSyAqN23SLJWEmthpXzPm1LQnY75ohp671Cw',
          projectId: 'peakflow-dc8eb',
          storageBucket: 'peakflow-dc8eb.appspot.com',
          messagingSenderId: '770970331880'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SignIn());
  }
}

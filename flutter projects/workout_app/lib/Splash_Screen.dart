import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/BottomNagivationBar.dart';
import 'package:workout_app/signIO.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  //function to check if user is logged in or not
  void checkLogIn(BuildContext context) async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        print('User is signed in!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Nav()),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState(); //

    Timer(const Duration(seconds: 3), () {
      checkLogIn(
          context); //initializes after checking if the user is logged in or not, if yes home page is opened else log in screen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: const Center(
          child: Text(
            'Welcome To Grind',
            style: TextStyle(
                fontSize: 34,
                fontFamily: 'FontName',
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}

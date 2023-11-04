
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:workout_app/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3),(){
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context)=>MyHomePage(title: 'Grind')
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(child: Text('Welcome To Grind',style: TextStyle(
          fontSize: 34,
          fontFamily: 'FontName',
          fontWeight: FontWeight.w700,
          color: Colors.white
        ),),) ,
      ),
    );
  }
}

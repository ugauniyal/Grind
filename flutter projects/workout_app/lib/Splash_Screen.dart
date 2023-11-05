
import 'dart:async';
import 'package:flutter/material.dart';
import 'BottomNagivationBar.dart';
import 'Home_Page.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3),(){
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context)=> BottomNavBarLayout(key: UniqueKey(),)
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: const Center(child: Text('Welcome To Grind',style: TextStyle(
          fontSize: 34,
          fontFamily: 'FontName',
          fontWeight: FontWeight.w700,
          color: Colors.white
        ),),) ,
      ),
    );
  }
}

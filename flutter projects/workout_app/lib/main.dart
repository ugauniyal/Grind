// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:workout_app/Splash_Screen.dart';

import 'BottomNagivationBar.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grind',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
              fontFamily: 'FontName',
              color: Colors.black
          )
        )
      ),
      home: SplashScreen()

    );
  }
}


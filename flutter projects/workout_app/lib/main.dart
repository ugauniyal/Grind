import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:workout_app/Splash_Screen.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grind',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        cardTheme: CardTheme(
          color: Colors.white,
        ),
        colorScheme: ColorScheme.light(
          primary: Colors.white,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.red,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          titleTextStyle:
              TextStyle(fontFamily: 'FontName', color: Colors.black),
          backgroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          displayLarge: TextStyle(color: Colors.black),
          displayMedium: TextStyle(color: Colors.black),
          displaySmall: TextStyle(color: Colors.black),
        ),
      ),
      home: SplashScreen(),
    );
  }
}

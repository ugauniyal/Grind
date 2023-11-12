import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:workout_app/Splash_Screen.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool enableDarkMode = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grind',
      debugShowCheckedModeBanner: false,
      theme: buildThemeData(),
      home: SplashScreen(),
    );
  }

  ThemeData buildThemeData() {
    return ThemeData(
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
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(fontFamily: 'FontName', color: Colors.black),
        backgroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        displayLarge: TextStyle(color: Colors.black),
        displayMedium: TextStyle(color: Colors.black),
        displaySmall: TextStyle(color: Colors.black),
      ),
      brightness: enableDarkMode ? Brightness.dark : Brightness.light,
    );
  }
}

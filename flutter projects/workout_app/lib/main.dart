// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:workout_app/IntroPage.dart';
import 'package:workout_app/Splash_Screen.dart';
import 'package:workout_app/sideBar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      home: SplashScreen(),
      // MyHomePage(title: 'Grind'),

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  List<Widget> gymPhotos = [
    Image.asset('assets/images/gym1.jpg'),
    Image.asset('assets/images/gym2.jpg'),
    Image.asset('assets/images/gym3.jpg')
  ];






  @override
  Widget build(BuildContext context) {


    return Scaffold(

      drawer: const NavBar(),
      appBar: AppBar(

        backgroundColor: Colors.white,
        elevation: 0.0,

        title: const Text('Grind',style: TextStyle(fontSize: 30)),

        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.notifications),
          onPressed: (){

          },)
        ],
      // leading: IconButton(
      //   onPressed: (){},
      //   icon: IconButton(
      //     icon: const Icon(Icons.menu),
      //     onPressed: (){
      //
      //     },
      //   ),
      // ),
      //   shape: const RoundedRectangleBorder(
      //     borderRadius: BorderRadius.only(
      //       bottomLeft: Radius.circular(20),
      //       bottomRight: Radius.circular(20)
      //     )
      //   ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                width: double.infinity,
                color: Colors.pinkAccent,
                child: Center(
                  child: Text(
                    'think about this box',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: Text("Explore nearby gyms",style: TextStyle(
                fontSize: 20
              ),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: gymPhotos.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: gymPhotos[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),





      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        unselectedLabelStyle: TextStyle(color: Colors.black),
        selectedLabelStyle: TextStyle(color: Colors.black),
        type: BottomNavigationBarType.fixed,
        onTap: (int newIndex){
          setState(() {
            _currentIndex = newIndex;
          });
        },
      items: const [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home, color: Colors.black),
        ),
        BottomNavigationBarItem(
          label: 'Explore',
          icon: Icon(Icons.search, color: Colors.black),
        ),
        BottomNavigationBarItem(
          label: 'Gym Buddy',
          icon: Icon(Icons.handshake, color: Colors.black,),
        ),
        BottomNavigationBarItem(
          label: 'Chat',
          icon: Icon(Icons.chat, color: Colors.black),
        ),
      ],
    ),


    );


  }
}

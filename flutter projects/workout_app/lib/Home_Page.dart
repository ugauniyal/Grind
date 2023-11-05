

import 'package:flutter/material.dart';
import 'package:workout_app/Chat_Page.dart';
import 'package:workout_app/Explore_Page.dart';
import 'package:workout_app/Gym_Buddy_Page.dart';
import 'package:workout_app/sideBar.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, this.title});

  String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  int currentIndex1 = 0;




  List<Widget> gymPhotos = [
    Image.asset('assets/images/gym1.jpg'),
    Image.asset('assets/images/gym2.jpg'),
    Image.asset('assets/images/gym3.jpg')
  ];






  @override
  Widget build(BuildContext context) {


    return Scaffold(
      extendBodyBehindAppBar: false,

      drawer: const NavBar(),
      appBar: AppBar(

        backgroundColor: Colors.white,
        elevation: 0.0,

          title: Container(
            padding: EdgeInsets.zero,
            child: Text('Grind', style: TextStyle(fontSize: 30)),
          ),

        centerTitle: true,
        primary: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: (){

            },)
        ],

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
                child: const Center(
                  child: Text(
                    'think about this box',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(9.0),
              child: Text("Explore nearby gyms",style: TextStyle(
                  fontSize: 20
              ),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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


    );


  }
}

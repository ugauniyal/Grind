import 'package:flutter/material.dart';
import 'package:workout_app/GymBuddyPage.dart';
import 'package:workout_app/Home_Page.dart';

import 'Explore_Page.dart';

class Nav extends StatefulWidget {
  Nav({Key? key}) : super(key: key);

  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.0),
          child: AppBar(
            elevation: 0.0,
          )),
      body: _buildPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        unselectedLabelStyle: TextStyle(color: Colors.black),
        selectedLabelStyle: TextStyle(color: Colors.red),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
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
            label: 'Gym Buddy',
            icon: Icon(Icons.handshake, color: Colors.black),
          ),
          BottomNavigationBarItem(
            label: 'Explore',
            icon: Icon(Icons.search, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return MyHomePage(); // Replace with your home page content.
      case 1:
        return SwipeCard();
      case 2:
        return ExplorePage();
      // Replace with your Explore page.
      // Add cases for Gym Buddy and Chat pages, similarly.
      default:
        return Container(); // Return an empty container by default.
    }
  }
}

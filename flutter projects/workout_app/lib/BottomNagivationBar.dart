import 'package:flutter/material.dart';
import 'package:workout_app/Home_Page.dart';

import 'Explore_Page.dart';
import 'GymBuddyPage.dart';

class Nav extends StatefulWidget {
  const Nav({super.key});

  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: AppBar(
            elevation: 0.0,
          )),
      body: _buildPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        unselectedLabelStyle: const TextStyle(color: Colors.black),
        selectedLabelStyle: const TextStyle(color: Colors.red),
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
        return const MyHomePage(); // Replace with your home page content.
      case 1:
        return const GymBuddy();
      case 2:
        return const ExplorePage();
      // Replace with your Explore page.
      // Add cases for Gym Buddy and Chat pages, similarly.
      default:
        return Container(); // Return an empty container by default.
    }
  }
}

import 'package:flutter/material.dart';
import 'package:workout_app/Chat_Page.dart';
import 'package:workout_app/Explore_Page.dart';
import 'package:workout_app/Gym_Buddy_Page.dart';
import 'package:workout_app/Home_Page.dart';
import 'package:workout_app/Splash_Screen.dart';
import 'package:workout_app/main.dart';

void main(){
  runApp(MyApp());
}

class BottomNavBarLayout extends StatefulWidget {
  BottomNavBarLayout({required Key key}) : super(key: key);
  // final String title;
  // final Widget initialPage;

  @override
  _BottomNavBarLayoutState createState() => _BottomNavBarLayoutState();
}

class _BottomNavBarLayoutState extends State<BottomNavBarLayout> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        // Add any other app-specific app bar configurations here
      ),
      body: _buildPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        unselectedLabelStyle: TextStyle(color: Colors.black),
        selectedLabelStyle: TextStyle(color: Colors.black),
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home,color: Colors.black),
          ),
          BottomNavigationBarItem(
            label: 'Explore',
            icon: Icon(Icons.search,color: Colors.black),
          ),
          BottomNavigationBarItem(
            label: 'Gym Buddy',
            icon: Icon(Icons.handshake,color: Colors.black),
          ),
          BottomNavigationBarItem(
            label: 'Chat',
            icon: Icon(Icons.chat,color: Colors.black,),

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
        return ExplorePage();
      case 2:
        return GymBuddyPage();
      case 3:
        return ChatPage();// Replace with your Explore page.
    // Add cases for Gym Buddy and Chat pages, similarly.
      default:
        return Container(); // Return an empty container by default.
    }
  }
}
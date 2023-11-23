import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/Gym_Buddies_List.dart';
import 'package:workout_app/Need_Help.dart';
import 'package:workout_app/SettingPage.dart';
import 'package:workout_app/signIO.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  void LogOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              user?.displayName ?? 'Default Name',
              style: TextStyle(color: Colors.black),
            ),
            accountEmail: Text(
              user?.email ?? 'Default Email',
              style: TextStyle(color: Colors.black),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  user?.photoURL ??
                      'https://m.media-amazon.com/images/S/pv-target-images/eac8b2236c3ad14773975e921a285f1b622de5f3673b36626b0a24e3dfccce37.jpg',
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Gym Buddies'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GymBuddies()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsOnePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Need help?'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NeedHelp()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: Text(
                'No',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Yes', style: TextStyle(color: Colors.black)),
              onPressed: () {
                LogOut();
                // Perform logout actions here
                // For example, you can call a function to handle logout
                // logout();
                // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}

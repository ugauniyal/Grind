import 'package:cloud_firestore/cloud_firestore.dart';
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
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  String bio = '';

  User? user = FirebaseAuth.instance.currentUser;

  void fetchBio() async {
    String uid = user?.uid ?? '';
    if (uid.isNotEmpty) {
      try {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        setState(() {
          bio = snapshot.data()?['bio'] ?? '';
        });
      } catch (e) {
        print('Error fetching bio: $e');
      }
    }
  }

  void initState() {
    super.initState();
    fetchBio(); // Call the function to fetch bio when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              user?.displayName ?? '',
              style: TextStyle(color: Colors.black),
            ),
            accountEmail: Text(
              bio.isNotEmpty ? bio : '', // Display bio instead of email
              style: TextStyle(color: Colors.black),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  user?.photoURL ??
                      'https://moorepediatricnc.com/wp-content/uploads/2022/08/default_avatar.jpg',
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

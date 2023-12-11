import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_app/Gym_Buddies_List.dart';
import 'package:workout_app/Need_Help.dart';
import 'package:workout_app/SettingPage.dart';
import 'package:workout_app/signIO.dart';

import 'components/friendRequestService.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int friendRequestsCount = 0;
  //when the user clicks on sign out
  void logOut() async {
    // Sign out from Google if the user is signed in with Google
    await GoogleSignIn().signOut();

    // Sign out using FirebaseAuth
    await FirebaseAuth.instance.signOut();

    // Navigate to the login screen
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  User? user = FirebaseAuth.instance.currentUser;

  String cachedBio = '';
  String cachedProfilePictureUrl = '';

  @override
  void initState() {
    super.initState();
    // Load cached bio data when the widget is created
    loadCachedBio();
    fetchBio();
  }

  Future<void> loadCachedBio() async {
    try {
      print('Loading cached bio...');
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Check if the key 'bio' exists
      bool bioKeyExists = prefs.containsKey('bio');
      print('Key "bio" exists: $bioKeyExists');

      // Fetch the bio value
      cachedBio = prefs.getString('bio') ?? '';
      print('Cached Bio: $cachedBio');

      setState(() {});
    } catch (e) {
      print('Error loading cached bio: $e');
    }
  }

  Future<void> fetchBio() async {
    String uid = user?.uid ?? '';
    if (uid.isNotEmpty) {
      try {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        String bio = snapshot.data()?['bio'] ?? '';

        // Cache the bio data in shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('bio', bio);

        setState(() {
          cachedBio = bio;
        });
      } catch (e) {
        print('Error fetching bio: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data?.data() as Map<String, dynamic>;

                  // Access the 'name' field from Firestore
                  String displayName = data['username'] ?? '';

                  return Text(
                    displayName,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                } else {
                  // Return a placeholder while waiting for data
                  return Text(
                    'Loading...',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }
              },
            ),
            accountEmail: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data?.data() as Map<String, dynamic>;

                  // Access the 'bio' field from Firestore
                  String bio = data['bio'] ?? '';

                  return Text(
                    bio,
                    style: TextStyle(color: Colors.black),
                    maxLines: null, // Set maxLines to null for unlimited lines
                    overflow: TextOverflow
                        .visible, // Set overflow to visible to show all lines
                  );
                } else {
                  // Return a placeholder while waiting for data
                  return Text(
                    'Loading...',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }
              },
            ),
            currentAccountPicture: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data?.data() as Map<String, dynamic>;

                  // Access the 'photoURL' field from Firestore
                  String photoURL = data['downloadUrl'] ??
                      'https://moorepediatricnc.com/wp-content/uploads/2022/08/default_avatar.jpg';

                  return CircleAvatar(
                    child: ClipOval(
                      child: Image.network(
                        photoURL,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                } else {
                  // Return a placeholder while waiting for data
                  return CircleAvatar(
                    child: ClipOval(
                      child: Image.network(
                        'https://moorepediatricnc.com/wp-content/uploads/2022/08/default_avatar.jpg',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
              },
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),

          // Your ListTile code
          ListTile(
            leading: Icon(Icons.people),
            title: Row(
              children: [
                Text('Gym Buddies'),
                Spacer(),
                FutureBuilder<int>(
                  future:
                      FriendRequestService.getFriendRequestsCount(user!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    int friendRequestsCount = snapshot.data ?? 0;

                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CircleAvatar(
                        backgroundColor: friendRequestsCount > 0
                            ? Colors.red
                            : Colors.transparent,
                        radius: 10,
                        child: Text(
                          friendRequestsCount > 0
                              ? friendRequestsCount.toString()
                              : '',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes', style: TextStyle(color: Colors.black)),
              onPressed: () {
                logOut();
              },
            ),
          ],
        );
      },
    );
  }
}

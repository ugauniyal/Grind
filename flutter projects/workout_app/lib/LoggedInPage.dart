import 'package:flutter/material.dart';
import 'package:workout_app/EditProfilePage.dart';

class LoggedInPage extends StatefulWidget {
  const LoggedInPage({Key? key});

  @override
  State<LoggedInPage> createState() => _LoggedInPage();
}

class _LoggedInPage extends State<LoggedInPage> {
  String name = "Tun Tun";
  String email = "tuntun@gmail.com";

  void handleProfileUpdate(String newName, String newEmail) {
    setState(() {
      name = newName;
      email = newEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Profile"),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://m.media-amazon.com/images/S/pv-target-images/eac8b2236c3ad14773975e921a285f1b622de5f3673b36626b0a24e3dfccce37.jpg',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                name,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(height: 5),
              Text(
                email,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfilePage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Set button color to black
                ),
                child: Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                leading: Icon(Icons.save),
                title: Text('Saved'),
                onTap: () => Null,
              ),
              SizedBox(height: 10),
            ],
          ),
        ));
  }
}

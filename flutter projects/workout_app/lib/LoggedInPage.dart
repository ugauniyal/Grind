
import 'package:flutter/material.dart';

class LoggedInPage  extends StatefulWidget {
  const LoggedInPage ({super.key});

  @override
  State<LoggedInPage> createState() => _LoggedInPage();
}

class _LoggedInPage extends State<LoggedInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text("My Profile"),
    ),
    body:
    Center(
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
            "Tun Tun",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 5),
          Text(
            "tuntun@gmail.com",
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              primary: Colors.black, // Set button color to black
            ),
            child: Text(
              "Edit Profile",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          SizedBox(height: 20,),
          Text(
            "Saved Content",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300, color: Colors.black),
          ),

          SizedBox(height: 10),
        ],
        
      ),
      
    )




    );
  }
}

import 'package:flutter/material.dart';
import 'package:workout_app/LoggedInPage.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  var nameController = TextEditingController(text: "Tun Tun");
  var emailController = TextEditingController(text: "tuntun@gmail.com");

  String name = "Tun Tun";
  String email = "tuntun@gmail.com";

  void saveChanges() {
    setState(() {
      name = nameController.text;
      email = emailController.text;
    });

    // Implement the logic to save changes here
    // You can use the updated 'name' and 'email' variables to update your user data

    // Navigate back to the LoggedInPage
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Your Profile"),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveChanges,
              child: Text(
                "Save Changes",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Saved Content",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

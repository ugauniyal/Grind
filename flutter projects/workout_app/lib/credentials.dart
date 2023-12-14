import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/upload_profilePic.dart';

class Credentials extends StatefulWidget {
  const Credentials({Key? key}) : super(key: key);

  @override
  State<Credentials> createState() => _CredentialsState();
}

class _CredentialsState extends State<Credentials> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  String? _genderValue = "Select";

  void dropdownCallback(String? selectedValue) {}

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.black,
            hintColor: Colors.black,
            colorScheme: ColorScheme.light(primary: Colors.black),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dobController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  String? _validateDOB(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date of Birth is required';
    }
    // Add additional validation logic if needed
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Credentials'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name TextField
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16.0),

            // Date of Birth TextField
            TextFormField(
              controller: _dobController,
              readOnly: true,
              onTap: () => _selectDate(context),
              validator: _validateDOB,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                labelText: 'Date of Birth',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                focusColor: Colors.black,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.all(12.0),
              ),
            ),
            SizedBox(height: 16.0),

            // Bio TextField
            TextField(
              controller: _bioController,
              decoration: InputDecoration(labelText: 'Bio'),
              maxLines: 3, // Allowing multiple lines for bio
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField(
              value: _genderValue,
              items: const [
                DropdownMenuItem(
                    child: Text("Select"), value: "Select", enabled: false),
                DropdownMenuItem(child: Text("Male"), value: "Male"),
                DropdownMenuItem(child: Text("Female"), value: "Female"),
              ],
              isExpanded: true,
              decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: 'Sex',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  focusColor: Colors.black,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.all(12.0)),
              onChanged: (Object? value) {
                setState(() {
                  _genderValue = value as String?;
                });
              },
            ),

            // Button to submit the form
            ElevatedButton(
              onPressed: () {
                createAccount(); // Call the createAccount function here
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void createAccount() async {
    String name = _nameController.text.trim();
    String age = _dobController.text.trim();
    String bio = _bioController.text.trim();
    String? gender = _genderValue;

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String? email = currentUser.email;
        String uid = currentUser.uid;
        String? username = currentUser.displayName;

        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'name': name,
          'age': age,
          'bio': bio,
          'gender': gender,
          'email': email,
          'uid': uid,
          'username': username,
          'downloadUrl': '',
          'preference': 'Both',
        }, SetOptions(merge: true));
        _showSnackbar("User Created");

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UploadProfilePic()),
        );
      }
    } on FirebaseAuthException catch (ex) {
      _showSnackbar(ex.code.toString());
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Credentials(),
  ));
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/upload_profilePic.dart';

class userInfo extends StatefulWidget {
  const userInfo({super.key});

  @override
  State<userInfo> createState() => _userInfoState();
}

class _userInfoState extends State<userInfo> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  String? _genderValue = "Select";

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
            colorScheme: const ColorScheme.light(primary: Colors.black),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
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
        title: const Text('User Credentials'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Name TextField
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),

            // Date of Birth TextFormField
            TextFormField(
              controller: _dobController,
              readOnly: true,
              onTap: () => _selectDate(context),
              validator: _validateDOB,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                labelText: 'Date of Birth',
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),

            // Bio TextField
            TextField(
              controller: _bioController,
              decoration: const InputDecoration(
                labelText: 'Bio',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),

            // Gender DropdownButtonFormField
            DropdownButtonFormField(
              value: _genderValue,
              items: const [
                DropdownMenuItem(
                  value: "Select",
                  enabled: false,
                  child: Text("Select"),
                ),
                DropdownMenuItem(value: "Male", child: Text("Male")),
                DropdownMenuItem(value: "Female", child: Text("Female")),
              ],
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Sex',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.all(12.0),
              ),
              onChanged: (Object? value) {
                setState(() {
                  _genderValue = value as String?;
                });
              },
            ),
            const SizedBox(height: 24.0),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                if (_validateDOB(_dobController.text) == null) {
                  createAccount();
                } else {
                  _showSnackbar("Please enter a valid Date of Birth");
                }
              },
              child: const Text('Submit'),
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

        await FirebaseFirestore.instance.collection('users').doc(uid).set(
          {
            'name': name,
            'age': age,
            'bio': bio,
            'gender': gender,
            'email': email,
            'uid': uid,
            'username': username,
            'downloadUrl': '',
            'latitude': '',
            'longitude': '',
            'preference': 'Both',
          },
          SetOptions(merge: true),
        );
        _showSnackbar("User Created");

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UploadProfilePic()),
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
  runApp(const MaterialApp(
    home: userInfo(),
  ));
}

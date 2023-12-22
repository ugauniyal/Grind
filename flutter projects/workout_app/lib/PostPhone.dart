import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/upload_profilePic.dart';

class postPhone extends StatefulWidget {
  const postPhone({super.key});

  @override
  State<postPhone> createState() => _postPhoneState();
}

class _postPhoneState extends State<postPhone> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? _genderValue = "Select";
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final bool _showPassword = false;
  bool _isUsernameAvailable = false;

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

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

  void _checkUsernameAvailability(String username) async {
    // Check if the username exists in the Firestore database
    username = username.trim();
    if (username == "") {
      setState(() {
        _isUsernameAvailable = false;
      });
      return;
    }
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    bool isAvailable = querySnapshot.docs.isEmpty;
    setState(() {
      _isUsernameAvailable = isAvailable;
    });
  }

  void createUser() async {
    try {
      // Get the current user
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Access Firestore and update user data
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .set({
          'uid': currentUser.uid,
          'name': _nameController.text.trim(),
          'username': _userController.text.trim(),
          'age': _dobController.text.trim(),
          'gender': _genderValue,
          'preference': 'Both',
          // Add more fields as needed
        }, SetOptions(merge: true));

        // Navigate to the desired screen after user creation
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UploadProfilePic()),
        );
      } else {
        _showSnackbar('User not logged in');
      }
    } catch (e) {
      _showSnackbar('Error creating user: $e');
    }
  }

  Future<bool> isUsernameAvailable(String username) async {
    // Check if the username exists in the Firestore database
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    return querySnapshot
        .docs.isEmpty; // If the list is empty, the username is available
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Your Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(color: Colors.black),
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  focusColor: Colors.black,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.all(12.0),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _userController,
                cursorColor: Colors.black,
                onChanged: (username) {
                  if (username.isNotEmpty) {
                    _checkUsernameAvailability(username);
                  } else {
                    setState(() {
                      _isUsernameAvailable = true;
                    });
                  }
                },
                decoration: InputDecoration(
                  labelStyle: const TextStyle(color: Colors.black),
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  focusColor: Colors.black,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.all(12.0),
                  suffixIcon: _isUsernameAvailable
                      ? null
                      : const Icon(
                          Icons.warning,
                          color: Colors.red,
                        ),
                  suffixText:
                      _isUsernameAvailable ? 'Available' : 'Not Available',
                  suffixStyle: TextStyle(
                      color: _isUsernameAvailable ? Colors.green : Colors.red),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dobController,
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: _validateDOB,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(color: Colors.black),
                  labelText: 'Date of Birth',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  focusColor: Colors.black,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.all(12.0),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                value: _genderValue,
                items: const [
                  DropdownMenuItem(
                      value: "Select", enabled: false,
                      child: Text("Select")),
                  DropdownMenuItem(value: "Male", child: Text("Male")),
                  DropdownMenuItem(value: "Female", child: Text("Female")),
                ],
                isExpanded: true,
                decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.black),
                    labelText: 'Sex',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    focusColor: Colors.black,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.all(12.0)),
                onChanged: (Object? value) {
                  setState(() {
                    _genderValue = value as String;
                  });
                },
              ),
              const SizedBox(height: 24),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 160, vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    createUser();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    textStyle: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: const Text('lESSGo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/EditProfilePage.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final user = FirebaseAuth.instance.currentUser;

  var passwordController = TextEditingController();
  var CpasswordController = TextEditingController();

  bool _showPassword = false;

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  //changes are saved when new password is updated and also password is changed in database
  void saveChanges() async {
    String newPassword = passwordController.text.trim();
    String confirmPassword = CpasswordController.text.trim();

    if (newPassword == "" || confirmPassword == "") {
      _showSnackbar('Please enter New Password details');
    } else if (newPassword != confirmPassword) {
      _showSnackbar('Password does not match');
    } else {
      try {
        if (user != null) {
          await user?.updatePassword(newPassword);
          _showSnackbar('Changes Done');
        }
      } on FirebaseAuthException catch (ex) {
        _showSnackbar(ex.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditProfilePage()),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white54,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Update Your Password",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              cursorColor: Colors.black,
              controller: passwordController,
              obscureText: !_showPassword,
              decoration: InputDecoration(
                labelStyle: const TextStyle(color: Colors.black),
                labelText: 'New Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                filled: true,
                focusColor: Colors.black,
                contentPadding: const EdgeInsets.all(12.0),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  icon: Icon(
                    _showPassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              cursorColor: Colors.black,
              controller: CpasswordController,
              obscureText: !_showPassword,
              decoration: InputDecoration(
                labelStyle: const TextStyle(color: Colors.black),
                labelText: 'Confirm Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                filled: true,
                focusColor: Colors.black,
                contentPadding: const EdgeInsets.all(12.0),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  icon: Icon(
                    _showPassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          ElevatedButton(
            onPressed: saveChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              "Save new password",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

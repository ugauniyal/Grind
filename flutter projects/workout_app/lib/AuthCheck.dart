import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/EditProfilePage.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void Login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email == "" || password == "") {
      _showSnackbar('Please enter all the details');
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        if (userCredential.user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditProfilePage()),
          );
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
        automaticallyImplyLeading: true,
        title: null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Sign In",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  focusColor: Colors.black,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.all(12.0)),
            ),
            SizedBox(height: 16.0),
            TextField(
              cursorColor: Colors.black,
              controller: _passwordController,
              obscureText: !_showPassword,
              decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.all(12.0),
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
                  )),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: () {
                  Login();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Text color
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 20), // Button padding
                  textStyle: const TextStyle(
                    fontSize: 24.0, // Text size
                    fontWeight: FontWeight.w500, // Text weight
                  ),
                ),
                child: Text('Authenticate'),
              ),
            ),
            const SizedBox(width: 16.0),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Or Sign In With",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  // onTap: _signInWithGoogle,
                  child: CircleAvatar(
                    child: ClipOval(
                      child: Image.network(
                        'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                InkWell(
                  // onTap: _signInWithFacebook,
                  child: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/6/6c/Facebook_Logo_2023.png',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

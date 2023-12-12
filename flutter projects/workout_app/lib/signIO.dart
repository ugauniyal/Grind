import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:workout_app/PostGoogle.dart';
import 'package:workout_app/sign-in-with-phone.dart';

import 'BottomNagivationBar.dart';
import 'ForgotPasswordPage.dart';
import 'SignUpPage.dart';
import 'components/my_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;
  late final String hintText;

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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Nav()),
          );
        }
      } on FirebaseAuthException catch (ex) {
        _showSnackbar(ex.code.toString());
      }
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      // Sign out from Google if the user is signed in with Google
      await GoogleSignIn().signOut();

      // Initiate Google Sign-In
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        _showSnackbar('Google Sign-In canceled');
        return Future.error('Google Sign-In canceled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase using the obtained credentials
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final user = userCredential.user;
      if (user != null) {
        // Get the user's UID
        String uid = user.uid;

        // Check if the user exists in Firestore
        bool userExists = await doesUserExist(uid);

        // If the user doesn't exist, update Firestore
        if (!userExists) {
          await FirebaseFirestore.instance.collection('users').doc(uid).set({
            'uid': uid,
            'name': googleUser.displayName,
            'downloadUrl': user.photoURL,
            'email': googleUser.email,
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PostGoogle()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Nav()),
          );
        }
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      _showSnackbar('Failed to sign in with Google: ${e.message}');
      throw e;
    }
  }

  Future<bool> doesUserExist(String uid) async {
    // Check if the user exists in Firestore
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return snapshot.exists;
  }

  void _signInWithFacebook() {
    // Add Facebook sign-in logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30.0),
                const Text(
                  "Grind",
                  style: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30.0),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Login to your account",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: _emailController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.grey[500]),
                      labelText: 'Email',
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      filled: true,
                      focusColor: Colors.black,
                      fillColor: Colors.grey.shade200,
                      contentPadding: EdgeInsets.all(12.0)),
                ),
                SizedBox(height: 16.0),
                TextField(
                  cursorColor: Colors.black,
                  controller: _passwordController,
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.grey[500]),
                      labelText: 'Password',
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding: EdgeInsets.all(12.0),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      )),
                ),
                SizedBox(height: 12.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => forgotPassword())),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Mybutton(
                  onTap: Login,
                ),
                // Padding(
                //   padding: const EdgeInsets.all(15.0),
                //   child: ElevatedButton(
                //     onPressed: () {
                //       Login();
                //     },
                //     style: ElevatedButton.styleFrom(
                //       foregroundColor: Colors.white,
                //       backgroundColor: Colors.blue, // Text color
                //       padding: const EdgeInsets.symmetric(
                //           horizontal: 40, vertical: 20), // Button padding
                //       textStyle: const TextStyle(
                //         fontSize: 24.0, // Text size
                //         fontWeight: FontWeight.w500, // Text weight
                //       ),
                //     ),
                //     child: Text('Sign In'),
                //   ),
                // ),
                const SizedBox(
                  height: 50,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "Or continue with",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Button color
                  ),
                  child: Text('Sign Up'),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: signInWithGoogle,
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
                      onTap: _signInWithFacebook,
                      child: Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/6/6c/Facebook_Logo_2023.png',
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    CupertinoButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => signInWithPhone()),
                          );
                        },
                        child: Text("Log in with Phone")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

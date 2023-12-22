import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/PostPhone.dart';

import 'BottomNagivationBar.dart';

class verifyOtpScreen extends StatefulWidget {
  final String verificationId;

  const verifyOtpScreen({super.key, required this.verificationId});

  @override
  State<verifyOtpScreen> createState() => _verifyOtpScreenState();
}

class _verifyOtpScreenState extends State<verifyOtpScreen> {
  TextEditingController otpController = TextEditingController();

  void verifyOTp() async {
    String otp = otpController.text.trim();

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: otp);
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      String? uid = userCredential.user?.uid;

      // Check if the user exists in Firestore
      bool userExists = await doesUserExist(uid!);

      if (userExists) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Nav()));
      } else if (userCredential.user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const postPhone()));
      }
    } on FirebaseAuthException catch (ex) {
      print(ex.code.toString());
      _showSnackbar(ex.code.toString());
    }
  }

  Future<bool> doesUserExist(String uid) async {
    // Check if the user exists in Firestore
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return snapshot.exists;
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Verify Otp"),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: otpController,
                    maxLength: 6,
                    decoration: const InputDecoration(
                        labelText: "6-Digits Otp", counterText: ""),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        verifyOTp();
                      },
                      child: const Text("Verify")),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

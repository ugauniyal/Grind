import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/verifyOtpScreen.dart';

class signInWithPhone extends StatefulWidget {
  const signInWithPhone({super.key});

  @override
  State<signInWithPhone> createState() => _signInWithPhoneState();
}

class _signInWithPhoneState extends State<signInWithPhone> {
  TextEditingController phoneController = TextEditingController();

  void sendOtp() async {
    String phone = "+91${phoneController.text.trim()}";
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        codeSent: (verificationId, resendToken) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => verifyOtpScreen(
                        verificationId: verificationId,
                      )));
        },
        verificationCompleted: (credential) {},
        verificationFailed: (ex) {
          print(ex.code.toString());
        },
        codeAutoRetrievalTimeout: (verificationId) {},
        timeout: const Duration(seconds: 30));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Sign In with Phone"),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: "Phone Number"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      child: const Text("Sign In"),
                      onPressed: () {
                        sendOtp();
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/verifyOtpScreen.dart';

class signInWithPhone extends StatefulWidget {
  const signInWithPhone({Key? key}) : super(key: key);

  @override
  State<signInWithPhone> createState() => _signInWithPhoneState();
}

class _signInWithPhoneState extends State<signInWithPhone> {
  TextEditingController phoneController = TextEditingController();

  void sendOtp() async {
    String phone = "+91" + phoneController.text.trim();
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
        timeout: Duration(seconds: 30));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Sign In with Phone"),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: "Phone Number"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      child: Text("Sign In"),
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

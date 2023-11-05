

import 'dart:convert';
import 'package:emailjs/emailjs.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;




import 'package:flutter/material.dart';

class NeedHelp extends StatefulWidget {
  @override
  State<NeedHelp> createState() => _NeedHelpState();
}

class _NeedHelpState extends State<NeedHelp> {
  final TextEditingController nameInputController = TextEditingController();

  final TextEditingController emailInputController = TextEditingController();

  final TextEditingController messageInputController = TextEditingController();

  void clearFields() {
    nameInputController.clear();
    emailInputController.clear();
    messageInputController.clear();
  }

  void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Give Us Your Query'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameInputController,
              decoration: InputDecoration(labelText: 'Name'),

            ),
            SizedBox(height: 16.0),
            TextField(
                controller: emailInputController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,

            ),
            SizedBox(height: 16.0),
            TextField(
              controller: messageInputController,
              decoration: InputDecoration(labelText: 'Your Query'),
              maxLines: 3,

            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed:
                () {

                if(nameInputController.text.isNotEmpty &&
                    emailInputController.text.isNotEmpty &&
                    messageInputController.text.isNotEmpty){





                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Thank you!'),
                        content: Text('Your Query has been sent.'),
                        actions: [
                          TextButton(
                            onPressed: () {

                              Navigator.pop(context);

                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                  // sendEmail();
                  clearFields();
                  hideKeyboard(context);
                } else{
                  showDialog(context: context,
                    builder: (BuildContext context){
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Please fill all the details'),
                      actions: [
                        TextButton(onPressed: (){
                          Navigator.pop(context);
                        }, child: Text('Okay')
                        )
                      ],
                    );
                  },
                  );
                }


                },

              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}



final nameController = TextEditingController();
final subjectController = TextEditingController();
final emailController = TextEditingController();
final messageController = TextEditingController();


Future sendEmail() async{
  const serviceId = "";
  const templateId = "";
  const publicKey = "";
  const privateKey = "";


  print("Sent");
  print(emailController);

  Map<String, dynamic> templateParams = {
          "name" : nameController.text,
          "subject": subjectController.text,
          "message": messageController.text,
          "user_email": emailController.text,
  };

  try {
    await EmailJS.send(
      serviceId,
      templateId,
      templateParams,

      const Options(
        publicKey: publicKey,
        privateKey: privateKey,
      ),
    );
    print('SUCCESS!');
  } catch (error) {
    print(error.toString());
  }

}
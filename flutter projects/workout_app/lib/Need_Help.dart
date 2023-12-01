import 'package:emailjs/emailjs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NeedHelp extends StatefulWidget {
  const NeedHelp({super.key});

  @override
  State<NeedHelp> createState() => _NeedHelpState();
}

final TextEditingController nameInputController = TextEditingController();
final TextEditingController emailInputController = TextEditingController();
final TextEditingController messageInputController = TextEditingController();
final TextEditingController subjectInputController = TextEditingController();

class _NeedHelpState extends State<NeedHelp> {
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
        title: const Text('Give Us Your Query'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameInputController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: emailInputController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: subjectInputController,
              decoration: const InputDecoration(labelText: 'Subject'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: messageInputController,
              decoration: const InputDecoration(labelText: 'Your Query'),
              maxLines: 3,
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                if (nameInputController.text.isNotEmpty &&
                    emailInputController.text.isNotEmpty &&
                    messageInputController.text.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Thank you!'),
                        content: const Text('Your Query has been sent.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                  sendEmail();
                  clearFields();
                  hideKeyboard(context);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Please fill all the details'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Okay'))
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

//Sending email through emailjs functionality
Future sendEmail() async {
  String serviceId = dotenv.get("SERVICE_ID", fallback: "");
  String templateId = dotenv.get("TEMPLATE_ID", fallback: "");
  String publicKey = dotenv.get("PUBLIC_KEY", fallback: "");
  String privateKey = dotenv.get("PRIVATE_KEY", fallback: "");

  print("Sent");

  //User details are here

  Map<String, dynamic> templateParams = {
    "name": nameInputController.text,
    "subject": subjectInputController.text,
    "message": messageInputController.text,
    "user_email": emailInputController.text,
  };

  try {
    await EmailJS.send(
      serviceId,
      templateId,
      templateParams,
      Options(
        publicKey: publicKey,
        privateKey: privateKey,
      ),
    );
    print('SUCCESS!');
  } catch (error) {
    print(error.toString());
  }
}

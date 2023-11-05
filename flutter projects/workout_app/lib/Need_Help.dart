

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;




class NeedHelp extends StatefulWidget {
  const NeedHelp({super.key});

  @override
  State<NeedHelp> createState() => _NeedHelpState();
}

class _NeedHelpState extends State<NeedHelp> {

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
    body: Text("this is a need help page"),
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


  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  final response = await http.post(url,
  headers: {'Content-type':'application/json'},
    body: json.encode({
      "service_id": serviceId,
      "template_id": templateId,
      "public_Key": publicKey,
      "template_param": {
        "name" : nameController.text,
        "subject": subjectController.text,
        "message": messageController.text,
        "user_email": emailController.text,

      }

    })
  );
  return response.statusCode;
}
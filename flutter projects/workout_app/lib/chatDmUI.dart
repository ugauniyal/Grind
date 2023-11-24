

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:workout_app/components/chat_bubble.dart';

import 'chatService.dart';


class ChatDmUI extends StatefulWidget {
  final String receiverUserUsername;
  final String receiverUserID;

  const ChatDmUI({super.key, required this.receiverUserUsername, required this.receiverUserID});



  @override
  State<ChatDmUI> createState() => _ChatDmUIState();
}

class _ChatDmUIState extends State<ChatDmUI> {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverUserID, _messageController.text);

      //   clear the text controller after sending the message.
      _messageController.clear();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.receiverUserUsername),
        ),
        body: Column(
          children: [

            // messages
            Expanded(
              child: _buildMessageList(),
            ),

            // user input
            _buildMessageInput(),
          ],
        )

    );
  }


//   build message list
  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(widget.receiverUserID, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading..");
          }

          return ListView(
            children: snapshot.data!.docs.map((document) => _buildMessageItem(document))
                .toList(),
          );
        });
  }


//   build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        children: [
          ChatBubble(message: data['message']),
        ],
      ),
    );
  }


//   build message input
  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200], // Set the background color to grey
                borderRadius: BorderRadius.circular(8.0), // Optional: Adds rounded corners
              ),
              child: TextField(
                controller: _messageController,
                obscureText: false,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  border: InputBorder.none, // Remove the border of the TextField
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0), // Optional: Adjust content padding
                ),
              ),
            )),

        IconButton(
            onPressed: sendMessage,
            icon: const Icon(Icons.arrow_upward, size: 40,)),
      ],
    );
  }

}
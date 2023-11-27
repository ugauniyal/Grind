import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_app/components/chat_bubble.dart';

import 'chatService.dart';

class ChatDmUI extends StatefulWidget {
  final String receiverUserUsername;
  final String receiverUserID;

  const ChatDmUI({
    Key? key,
    required this.receiverUserUsername,
    required this.receiverUserID,
  }) : super(key: key);

  @override
  State<ChatDmUI> createState() => _ChatDmUIState();
}

class _ChatDmUIState extends State<ChatDmUI> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  late ScrollController _scrollController;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverUserID,
        _messageController.text,
      );

      // Clear the text controller after sending the message.
      _messageController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Build date and day
  Widget _buildDateAndDay(Timestamp lastMessageTimestamp) {
    // Format timestamp to show date and day
    var dateAndDay = DateFormat('MMM d, EEEE')
        .format(lastMessageTimestamp.toDate())
        .toUpperCase();
    print(dateAndDay);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      alignment: Alignment.center,
      child: Text(
        dateAndDay,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserUsername),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _chatService.getMessages(
                widget.receiverUserID,
                _firebaseAuth.currentUser!.uid,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading..");
                }

                var messages = snapshot.data!.docs;

                // Group messages by date
                var groupedMessages = groupMessagesByDate(messages);

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: groupedMessages.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    var messageGroup = groupedMessages[index];
                    var messageTimestamp =
                        messageGroup.first['timestamp'] as Timestamp;

                    return Column(
                      children: [
                        // Display date header
                        _buildDateAndDay(messageTimestamp),
                        // Display messages for the date
                        ...messageGroup
                            .map((message) => _buildMessageItem(message)),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          // User input
          _buildMessageInput(),
        ],
      ),
    );
  }

  List<List<DocumentSnapshot>> groupMessagesByDate(
      List<DocumentSnapshot> messages) {
    var groupedMessages = <List<DocumentSnapshot>>[];
    for (var message in messages) {
      var messageTimestamp = message['timestamp'] as Timestamp;
      if (groupedMessages.isEmpty ||
          !_isSameDay(
              messageTimestamp, groupedMessages.last.first['timestamp'])) {
        // Create a new group for a new date
        groupedMessages.add([message]);
      } else {
        // Add to the existing group
        groupedMessages.last.add(message);
      }
    }
    return groupedMessages;
  }

  // Check if two timestamps are on the same day
  bool _isSameDay(Timestamp timestamp1, Timestamp timestamp2) {
    var date1 =
        DateTime.fromMillisecondsSinceEpoch(timestamp1.millisecondsSinceEpoch);
    var date2 =
        DateTime.fromMillisecondsSinceEpoch(timestamp2.millisecondsSinceEpoch);

    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    // Format timestamp
    var timestamp = data['timestamp'];
    if (timestamp is! int) {
      // If it's not an int, assume it's a Timestamp from Firestore
      timestamp = (timestamp as Timestamp).millisecondsSinceEpoch;
    }

    var messageTime =
        DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(timestamp));

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: alignment,
            child: ChatBubble(
              message: data['message'],
              messageTime: messageTime,
              Sender: data["senderId"],
              alignment: alignment,
            ),
          ),
        ],
      ),
    );
  }

  // Build message input
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: _messageController,
                obscureText: false,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              sendMessage();
              // Scroll to the bottom when a new message is sent
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

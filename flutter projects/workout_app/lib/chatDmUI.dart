import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_app/components/chat_bubble.dart';

import 'chatService.dart';

class ChatDmUI extends StatefulWidget {
  final String receiverUserUsername;
  final String receiverUserID;
  final String? profilePicUrl;

  const ChatDmUI({
    Key? key,
    required this.receiverUserUsername,
    required this.receiverUserID,
    required this.profilePicUrl,
  }) : super(key: key);

  @override
  State<ChatDmUI> createState() => _ChatDmUIState();
}

class ReadIndicator extends StatelessWidget {
  final bool isRead;

  const ReadIndicator({Key? key, required this.isRead}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isRead
        ? Icon(Icons.check, color: Colors.blue) // Display checkmark if read
        : Icon(Icons.access_time,
            color: Colors.grey); // Display clock if unread
  }
}

class _ChatDmUIState extends State<ChatDmUI> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  late ScrollController _scrollController;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      // Clear the text controller before sending the message.
      var messageText = _messageController.text;
      _messageController.clear();

      // Update the UI immediately
      // setState(() {});

      await _chatService.sendMessage(
        widget.receiverUserID,
        messageText,
      );

      // Optional: Scroll to the bottom after sending the message
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Set initial scroll position to the bottom
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
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
        title: Row(
          children: [
            CircleAvatar(
              radius: 17,
              backgroundImage: NetworkImage(
                widget.profilePicUrl ??
                    'https://moorepediatricnc.com/wp-content/uploads/2022/08/default_avatar.jpg',
              ),
            ),
            SizedBox(width: 8),
            Text(
              widget.receiverUserUsername,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          //here
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
                        // Display messages for the date in reverse order
                        ListView.builder(
                          controller:
                              _scrollController, // Use the same controller
                          shrinkWrap: true,
                          itemCount: messageGroup.length,
                          reverse: true, // Set this to false for regular order
                          itemBuilder: (context, messageIndex) {
                            var message = messageGroup[messageIndex];
                            return _buildMessageItem(message);
                          },
                        ),
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

//grouping messages date wise by storing same timestamp messages in a list
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

  // Build message item showing sender messages in right side and receiver in left side
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
          // Display read indicator
          if (alignment == Alignment.centerLeft && (data['read'] ?? false))
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Seen',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12.0,
                ),
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
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

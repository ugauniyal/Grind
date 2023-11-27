import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String messageTime;
  final String Sender;
  final bool isReceiver;
  final dynamic alignment;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.messageTime,
    required this.Sender,
    required this.alignment,
    this.isReceiver = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CrossAxisAlignment crossAxisAlignmentValue;

    // Map Alignment values to CrossAxisAlignment
    if (alignment == Alignment.centerRight) {
      crossAxisAlignmentValue = CrossAxisAlignment.end;
    } else if (alignment == Alignment.centerLeft) {
      crossAxisAlignmentValue = CrossAxisAlignment.start;
    } else {
      // Default value if needed
      crossAxisAlignmentValue = CrossAxisAlignment.center;
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: crossAxisAlignmentValue,
        children: [
          Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            messageTime,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}

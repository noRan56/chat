import 'package:chat/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Import the message model

class ChatBubble extends StatelessWidget {
  final Message message;

  ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          message.isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!message.isSentByMe)
          CircleAvatar(
            backgroundImage: NetworkImage(message.profilePicUrl),
            radius: 15.0,
          ),
        SizedBox(width: 10.0),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5.0),
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: message.isSentByMe ? Colors.yellow[700] : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
              bottomLeft:
                  message.isSentByMe ? Radius.circular(20.0) : Radius.zero,
              bottomRight:
                  message.isSentByMe ? Radius.zero : Radius.circular(20.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: message.isSentByMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                message.text,
                style: TextStyle(
                  color: message.isSentByMe ? Colors.white : Colors.black,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                DateFormat('hh:mm a').format(message.timestamp),
                style: TextStyle(
                  color: message.isSentByMe ? Colors.white70 : Colors.black54,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
        if (message.isSentByMe) SizedBox(width: 10.0),
        if (message.isSentByMe)
          CircleAvatar(
            backgroundImage: NetworkImage(message.profilePicUrl),
            radius: 15.0,
          ),
      ],
    );
  }
}

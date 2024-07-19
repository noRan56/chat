import 'package:chat/models/chat_model.dart';
import 'package:chat/widgets/chat_widgets.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  final String userId;
  final String userProfilePicUrl;

  ChatScreen({required this.userId, required this.userProfilePicUrl});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> messages = [];
  late IO.Socket socket;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    connectToServer();
    fetchMessages();
  }

  void connectToServer() {
    socket = IO.io('http://localhost:5000', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('receiveMessage', (data) {
      setState(() {
        messages.add(Message(
          senderId: data['senderId'],
          text: data['text'],
          timestamp: DateTime.parse(data['timestamp']),
          isSentByMe: data['senderId'] == widget.userId,
          profilePicUrl: data['profilePicUrl'],
        ));
      });
    });
  }

  void fetchMessages() async {
    final response =
        await http.get(Uri.parse('http://localhost:5000/messages'));
    if (response.statusCode == 200) {
      List<dynamic> fetchedMessages = json.decode(response.body);
      setState(() {
        messages = fetchedMessages.map((message) {
          return Message(
            senderId: message['senderId'],
            text: message['text'],
            timestamp: DateTime.parse(message['timestamp']),
            isSentByMe: message['senderId'] == widget.userId,
            profilePicUrl: message['profilePicUrl'],
          );
        }).toList();
      });
    }
  }

  void sendMessage(String text) {
    final message = {
      'senderId': widget.userId,
      'text': text,
      'timestamp': DateTime.now().toIso8601String(),
      'profilePicUrl': widget.userProfilePicUrl,
    };

    setState(() {
      messages.add(Message(
        senderId: widget.userId,
        text: text,
        timestamp: DateTime.now(),
        isSentByMe: true,
        profilePicUrl: widget.userProfilePicUrl,
      ));
    });

    socket.emit('sendMessage', message);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Noran'),
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
             
            },
          ),
          CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/userAvater.png') 
              ),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.yellow[700],
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      sendMessage(_controller.text);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }
}

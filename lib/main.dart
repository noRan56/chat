// import 'package:chat/screens/chat.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ChatScreen(
//         userId: '',
//         userProfilePicUrl: '',
//       ),
//     );
//   }
// }

import 'package:chat/screens/chat.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp(userId: 'user1', userProfilePicUrl: 'assets/userAvater.png'));
  runApp(MyApp(userId: 'user2', userProfilePicUrl: 'assets/userAvater.png'));
}

class MyApp extends StatelessWidget {
  final String userId;
  final String userProfilePicUrl;

  MyApp({required this.userId, required this.userProfilePicUrl});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(userId: userId, userProfilePicUrl: userProfilePicUrl),
    );
  }
}

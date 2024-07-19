import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  final response = await http.post(
    Uri.parse('http://localhost:5000/sendMessage'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'senderId': 'user2',
      'text': 'Hello from user2',
      'timestamp': DateTime.now().toIso8601String(),
      'profilePicUrl': 'https://example.com/user2.png',
    }),
  );

  if (response.statusCode == 200) {
    print('Message sent successfully');
  } else {
    print('Failed to send message');
  }
}

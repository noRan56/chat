class Message {
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isSentByMe;
  final String profilePicUrl;

  Message({
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isSentByMe,
    required this.profilePicUrl,
  });
}

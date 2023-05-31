

class Message {
  Message({
    required this.id,
    required this.senderUsername,
    required this.receiverUsername,
    required this.content,
  });

  /// ID of the message
  final int id;

  /// ID of the sender
  final String senderUsername;

  /// ID of the receiver
  final String receiverUsername;

  /// Text content of the message
  final String content;
}

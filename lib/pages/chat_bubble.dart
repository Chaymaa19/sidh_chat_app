import 'package:flutter/material.dart';
import 'package:sidh_chat_app/models/models.dart';

class ChatBubble extends StatefulWidget {
  final Message message;
  final String receiverUsername;

  const ChatBubble(
      {super.key, required this.message, required this.receiverUsername});

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble>{
  @override
  Widget build(BuildContext context) {
    final isSentByCurrentUser = widget.message.senderUsername != widget.receiverUsername;
    final bubbleAlignment = isSentByCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor = isSentByCurrentUser ? Color.fromARGB(255, 188, 173, 212) : Color.fromARGB(255, 177, 176, 176);
    final bubbleTextColor = isSentByCurrentUser ? Colors.black : Colors.black;

    return Align(
        alignment: bubbleAlignment,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            widget.message.content,
            style: TextStyle(color: bubbleTextColor),
          ),
        ),
    );
  }

}

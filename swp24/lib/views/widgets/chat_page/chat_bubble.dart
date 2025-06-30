import 'package:flutter/material.dart';
import '../../../models/chatModel/chat_message.dart';
/// ChatBubble
/// Author: Sergi Koniashvili
/// This widget represents a single chat message bubble in the chat interface.
/// It adapts its alignment, color, and text style based on the sender of the message.
class ChatBubble extends StatelessWidget {
  final ChatMessage message; // The chat message to display

  const ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == 'user'; // Check if the message is from the user

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

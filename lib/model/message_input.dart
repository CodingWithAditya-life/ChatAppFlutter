import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/theme.dart';
import '../features/chat/providers/chat_provider.dart';

class MessageInput extends StatelessWidget{
  final TextEditingController controller;
  final VoidCallback onSend;

  const MessageInput({super.key, required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DefaultColors.sentMessageInput,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          GestureDetector(
            child: Icon(Icons.camera_alt_outlined, color: Colors.grey),
            onTap: () {},
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: Provider.of<ChatProvider>(context, listen: false)
                  .messageController,
              decoration: InputDecoration(
                  hintText: 'Message...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none),
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.send, color: Colors.grey),
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}
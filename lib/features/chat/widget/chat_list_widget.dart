import 'package:chat_app/features/chat/widget/receive_chat_widget.dart';
import 'package:chat_app/features/chat/widget/send_chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';

class ChatListWidget extends StatelessWidget {
  const ChatListWidget({
    super.key,
    required ScrollController scrollController,
    required this.uid,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final String? uid;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, value, child) {
        return ListView.builder(
          controller: _scrollController,
          padding: EdgeInsets.all(8),
          itemCount: value.chatList.length,
          itemBuilder: (context, index) {
            var message = value.chatList[index];
            if (message.message_type == "image") {
              return Align(
                alignment: message.senderId == uid
                    ? Alignment.topRight
                    : Alignment.topLeft,
                child: Image.network(
                  message.photo_url ?? "",
                  height: 100,
                  width: 100,
                ),
              );
            } else {
              return message.senderId == uid
                  ? SendChatWidget(
                message: message.message ?? "",
                time: message.dateTime ?? DateTime.now(),
              )
                  : ReceiveChatWidget(
                message: message.message ?? "",
                time: message.dateTime ?? DateTime.now(),
              );
            }
          },
        );
      },
    );
  }
}
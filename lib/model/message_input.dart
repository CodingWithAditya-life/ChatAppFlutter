import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../core/theme/theme.dart';
import '../features/chat/providers/chat_provider.dart';
import '../services/user_status_service.dart';

class MessageInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final String otherUid;
  final VoidCallback onTyping;

  const MessageInput(
      {super.key,
      required this.controller,
      required this.onSend,
      required this.otherUid,
      required this.onTyping});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  final UserStatusService _statusService = UserStatusService();
  Timer? _typingTimer;
  final ChatProvider messageController = ChatProvider();

  void _handleTyping() {
    widget.onTyping();

    _typingTimer?.cancel();
    _typingTimer = Timer(Duration(seconds: 0), () {
      widget.onTyping();
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (Provider.of<ChatProvider>(context, listen: false)
          .messageController.text.isNotEmpty) {
        _statusService.startTyping();
      } else {
        _statusService.stopTyping();
      }
    });
  }

  Future<File?> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var chatProvider = Provider.of<ChatProvider>(context, listen: false);
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
            onTap: () async {},
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
              onChanged: (text){
                if(text.isNotEmpty){
                  _handleTyping();
                }
              },
            ),
          ),
          IconButton(
              onPressed: () async {
                File? image = await pickImage();
                if (image != null) {
                  await chatProvider.sendImage(otherUid: widget.otherUid,imageFile: image);
                }
              },
              icon: Image.asset('assets/icon/gallery.png',
                  width: 22, color: Colors.grey)),
          SizedBox(
              width: 18,
              child: IconButton(
                  icon: Icon(Icons.send, color: Colors.grey),
                  onPressed: widget.onSend)),
          SizedBox(width: 10)
        ],
      ),
    );
  }
}

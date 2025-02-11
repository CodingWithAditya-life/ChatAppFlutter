import 'dart:async';
import 'package:chat_app/features/authentication/call/service/call_request_services.dart';
import 'package:chat_app/features/authentication/call/service/generate_call_ID.dart';
import 'package:chat_app/features/chat/widget/chat_list_widget.dart';
import 'package:chat_app/services/user_status_service.dart';
import 'package:chat_app/features/chat/providers/chat_provider.dart';
import 'package:chat_app/features/chat/widget/chat_app_bar_widget.dart';
import 'package:chat_app/model/message_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/features/authentication/call/service/video_call_services.dart';

class ChatScreen extends StatefulWidget {
  final String otherUid;
  final String userName;

  const ChatScreen({super.key, required this.otherUid, required this.userName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final String? uid = FirebaseAuth.instance.currentUser!.uid;
  final ScrollController _scrollController = ScrollController();
  final UserStatusService _statusService = UserStatusService();
  final CallRequestServices _callService = CallRequestServices();
  Timer? _seenUpdateTimer;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      var chatProvider = Provider.of<ChatProvider>(context, listen: false);
      await chatProvider.getChatList(
          currentUserId: uid ?? "", otherId: widget.otherUid);

      await chatProvider.markMessagesAsSeen(otherUid: widget.otherUid);

      _seenUpdateTimer = Timer.periodic(Duration(seconds: 2), (timer){
        chatProvider.markMessagesAsSeen(otherUid: widget.otherUid);
      });
    });

    _statusService.updateUserStatus(isOnline: true);
    _statusService.setUserOfflineOnDisconnect();
  }

  void _onTypingStart(){
    _statusService.updateUserStatus(isOnline: true, isTyping: true);

    _seenUpdateTimer?.cancel();
    _seenUpdateTimer = Timer(Duration(seconds: 2), (){
      _statusService.updateUserStatus(isOnline: true,isTyping: false);
    });
  }

  void _scrollToBottom(){
    Future.delayed(Duration(milliseconds: 200),(){
      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 200), curve: Curves.easeOut);
    });
  }

  void _listenForIncomingCalls() {
    _callService.listenForIncomingCalls(uid!).listen((event) {
      if (event.snapshot.exists) {
        Map callData = event.snapshot.value as Map;
        String callID = callData['call_id'];
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VideoCallService(
                callID: callID, userID: uid!, userName: widget.userName),
          ),
        );
      }
    });
  }

  void _startCall() {
    String callID = GenerateCallID.generateCallId(widget.otherUid, uid!);
    _callService.sendCallRequest(widget.otherUid, callID);
    _listenForIncomingCalls();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoCallService(
            callID: callID, userID: uid!, userName: widget.userName),
      ),
    );
  }

  @override
  void dispose() {
    _statusService.updateUserStatus(isOnline: true,isTyping: false);
    _seenUpdateTimer?.cancel();
    super.dispose();
  }

  @override
  void deactivate() {
    _statusService.updateUserStatus(isOnline: false, isTyping: false);
    super.deactivate();
  }

  @override
  void activate() {
    _statusService.updateUserStatus(isOnline: true, isTyping: true);
    super.activate();
  }

  @override
  Widget build(BuildContext context) {
    var chatProvider = Provider.of<ChatProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      appBar: ChatAppBar(
          userName: widget.userName,
          otherUid: widget.otherUid,
          onCallPress: () {},
          onVideoCallPress: _startCall),
      body: Column(
        children: [
          Expanded(
            child:
                ChatListWidget(scrollController: _scrollController, uid: uid),
          ),
          MessageInput(
            otherUid: widget.otherUid,
            onTyping: _onTypingStart,
            controller: chatProvider.messageController,
            onSend: () async {
              if(chatProvider.messageController.text.trim().isNotEmpty){
                await chatProvider.sendChat(otherUid: widget.otherUid);
                _scrollToBottom();
              }else{
                print('Please enter a valid message');
              }
            },
          ),
        ],
      ),
    );
  }
}

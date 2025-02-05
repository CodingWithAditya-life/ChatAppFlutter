import 'package:chat_app/features/authentication/call/service/call_request_services.dart';
import 'package:chat_app/features/authentication/call/service/generate_call_ID.dart';
import 'package:chat_app/features/chat/widget/chat_list_widget.dart';
import 'package:chat_app/services/user_status_service.dart';
import 'package:chat_app/features/chat/providers/chat_provider.dart';
import 'package:chat_app/features/chat/widget/chat_app_bar_widget.dart';
import 'package:chat_app/model/message_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      var viewModel = Provider.of<ChatProvider>(context, listen: false);
      await viewModel.getChatList(
          currentUserId: uid ?? "", otherId: widget.otherUid);
    });

    _statusService.updateUserStatus(true);
    _statusService.setUserOfflineOnDisconnect();
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
    _statusService.updateUserStatus(true);
    super.dispose();
  }

  @override
  void deactivate() {
    _statusService.updateUserStatus(false);
    super.deactivate();
  }

  @override
  void activate() {
    _statusService.updateUserStatus(true);
    super.activate();
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<ChatProvider>(context, listen: false);
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
            controller: viewModel.messageController,
            onSend: () async {
              if(viewModel.messageController.text.trim().isNotEmpty){
                await viewModel.sendChat(otherUid: widget.otherUid);
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

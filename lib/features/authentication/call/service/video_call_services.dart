import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import '../../../../core/constants/const.dart';

class VideoCallService extends StatelessWidget {
  final String callID;
  final String userID;
  final String userName;

  const VideoCallService({
    super.key,
    required this.callID,
    required this.userID,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZegoUIKitPrebuiltCall(
        appID: AppInfo.appId,
        appSign: AppInfo.appSign,
        callID: callID,
        userID: userID,
        userName: userName,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

import '../../../../core/constants/const.dart';

class VideoChatScreen extends StatelessWidget {
  final String conferenceID;
  final String userID;
  final String userName;

  const VideoChatScreen({
    super.key,
    required this.conferenceID,
    required this.userID,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video Call")),
      body: ZegoUIKitPrebuiltVideoConference(
        appID: AppInfo.appId,
        appSign: AppInfo.appSign,
        conferenceID: conferenceID,
        userID: userID,
        userName: userName,
        config: ZegoUIKitPrebuiltVideoConferenceConfig(
          turnOnMicrophoneWhenJoining: true,
          turnOnCameraWhenJoining: true,
          useFrontFacingCamera: true,
          useSpeakerWhenJoining: true,
        ),
      ),
    );
  }
}

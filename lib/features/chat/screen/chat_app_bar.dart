import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../services/user_status_service.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String userName;
  final String otherUid;
  final VoidCallback onCallPress;
  final VoidCallback onVideoCallPress;

  const ChatAppBar({
    super.key,
    required this.userName,
    required this.otherUid,
    required this.onCallPress,
    required this.onVideoCallPress,
  });

  String _getInitials(String name) {
    List<String> nameParts = name.trim().split(' ');
    String initials = '';

    for (var part in nameParts) {
      if (part.isNotEmpty) {
        initials += part[0].toUpperCase();
      }
    }

    return initials.length > 2 ? initials.substring(0, 2) : initials;
  }

  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 25,
      elevation: 10,
      toolbarHeight: 60,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              userName.isNotEmpty ? _getInitials(userName) : "?",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              UserStatusService().userStatusWidget(otherUid),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      actions: [
        SizedBox(
          child: IconButton(
            onPressed: onVideoCallPress,
            icon: Image.asset(
              'assets/images/video-record.png',
              width: 27,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          width: 10,
          child: IconButton(
            onPressed: onCallPress,
            icon: SizedBox(
                child:
                Icon(Icons.call_outlined, color: Colors.white, size: 20)),
          ),
        ),
        SizedBox(width: 12),
        SizedBox(
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: Colors.white),
          ),
        ),
      ],
    );
  }
}


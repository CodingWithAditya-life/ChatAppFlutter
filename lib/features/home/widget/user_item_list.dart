import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../chat/screen/chat_screen.dart';

class UserItemList extends StatelessWidget {
  final String userId;
  final String userName;
  final String photoUrl;

  const UserItemList(
      {super.key,
      required this.userId,
      required this.userName,
      required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              otherUid: userId,
              userName: userName,
            ),
          ),
        );
      },
      child: SizedBox(
        height: 85,
        child: Card(
          shadowColor: Colors.transparent,
          color: Colors.transparent,
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 5),
              _buildUserAvatar(photoUrl),
              SizedBox(width: 13),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 19),
                  ),
                  Text('Message_type'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar(String photoUrl) {
    return CircleAvatar(
      maxRadius: 30,
      backgroundColor: Colors.transparent,
      child: photoUrl != null && photoUrl != ""
          ? CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(photoUrl),
            )
          : Icon(CupertinoIcons.person),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../chat/screen/chat_screen.dart';

class UserItemList extends StatefulWidget {
  final String userId;
  final String userName;
  final String photoUrl;

  const UserItemList(
      {super.key,
      required this.userId,
      required this.userName,
      required this.photoUrl});

  @override
  State<UserItemList> createState() => _UserItemListState();
}

class _UserItemListState extends State<UserItemList> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    Future.delayed(Duration(seconds: 2), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(seconds: 200), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        _scrollToBottom();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              otherUid: widget.userId,
              userName: widget.userName,
            ),
          ),
        );
      },
      child: SizedBox(
        height: 77,
        child: Card(
          shadowColor: Colors.transparent,
          color: Colors.transparent,
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 5),
              _buildUserAvatar(widget.photoUrl),
              SizedBox(width: 13),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userName,
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
      maxRadius: 27,
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

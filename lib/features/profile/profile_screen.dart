import 'dart:io';
import 'package:chat_app/core/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  String? _userName;
  String? _email;
  File? _userProfileImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    var user = _auth.currentUser;
    if (user != null) {
      DatabaseEvent event = await _databaseReference.child("user/${user.uid}").once();
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data = event.snapshot.value as Map<
            dynamic,
            dynamic>;

        setState(() {
          _userName = data['name'];
          _email = data['email'];
          _userProfileImage = data['photo_url'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1B202D),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                // onTap: _pickImage,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(75),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 5),
                        color: Colors.lightBlue.withOpacity(.2),
                        spreadRadius: 2,
                        blurRadius: 11,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.transparent,
                    backgroundImage: _userProfileImage != null ? NetworkImage(_userProfileImage.toString()) : AssetImage('') as ImageProvider,
                  ),
                ),
              ),
              SizedBox(height: 15),
              userProfileScreen(_userName.toString(), CupertinoIcons.person),
              SizedBox(height: 15),
              userProfileScreen(_email.toString(), CupertinoIcons.mail),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                },
                style:
                ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
                child:
                Text("Save Profile", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget userProfileScreen(String title, IconData icons) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            color: Colors.lightBlue.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 11,
          ),
        ],
      ),
      child: Center(
        child: SizedBox(
          height: 75,
          child: Center(
            child: ListTile(
              title: Text(title),
              leading: Icon(icons),
              trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
              tileColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

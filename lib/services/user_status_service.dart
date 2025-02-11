import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserStatusService {
  final DatabaseReference _userReference =
      FirebaseDatabase.instance.ref('users');
  Timer? _typingTimer;

  Future<void> updateUserStatus({required bool isOnline, bool isTyping = false}) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    DatabaseReference statusReference =
        _userReference.child(uid).child('status');

    if (isOnline) {
      await statusReference.set({
        "online": true,
        "typing": isTyping,
        "lastSeen": DateTime.now().toIso8601String(),
      });
    }
  }

  void setUserOfflineOnDisconnect() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference statusReference =
        _userReference.child(uid).child('status');

    statusReference.onDisconnect().update({
      "online": false,
      "typing": false,
      "lastSeen": DateTime.now().toIso8601String(),
    });
  }

  void startTyping() {
    updateUserStatus(isOnline: true, isTyping: true);
    _typingTimer?.cancel();
    _typingTimer = Timer(Duration(seconds: 0), () {
      stopTyping();
    });
  }

  void stopTyping() {
    updateUserStatus(isOnline: true, isTyping: false);
  }

  Widget userStatusWidget(String userId) {
    return StreamBuilder(
      stream: FirebaseDatabase.instance.ref('users/$userId/status').onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
          Map<String, dynamic> status =
          Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
          bool isOnline = status['online'] ?? false;
          bool isTyping = status['typing'] ?? false;
          String lastSeen = status['lastSeen'] ?? '';

          if(isTyping){
            return Text(
              "typing...",
              style: TextStyle(color: Colors.grey.shade50,fontSize: 14),
            );
          }
          if (isOnline) {
            return Text(
              "Online",
              style: TextStyle(color: Colors.grey.shade50, fontSize: 14),
            );
          } else {
            DateTime lastSeenTime = DateTime.parse(lastSeen);
            DateTime yesterday = DateTime.now().subtract(Duration(days: 1));

            String formattedTime =
            DateFormat('h:mm a').format(lastSeenTime).toLowerCase();
            String formattedDate;

            if (lastSeenTime.day == DateTime.now().day &&
                lastSeenTime.month == DateTime.now().month &&
                lastSeenTime.year == DateTime.now().year) {
              formattedDate = "today at  $formattedTime";
            } else if (lastSeenTime.day == yesterday.day &&
                lastSeenTime.month == yesterday.month &&
                lastSeenTime.year == yesterday.year) {
              formattedDate = "yesterday at  $formattedTime";
            } else {
              // formattedDate =  "${DateFormat('MMM d').format(lastSeenTime)} at $formattedTime";
              formattedDate = "last week";
            }

            return Text(
              "last seen $formattedDate",
              style: TextStyle(color: Colors.grey.shade50, fontSize: 13),
            );
          }
        }
        return Text("");
      },
    );
  }
}

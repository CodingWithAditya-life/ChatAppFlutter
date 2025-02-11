import 'dart:math';
import 'dart:io';
import 'package:chat_app/notifications/device_token_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import '../../../model/user_model.dart';
import '../../../notifications/get_server_key.dart';
import '../../../notifications/push_notification_services.dart';
import '../model/chat_model.dart';

class ChatProvider with ChangeNotifier {
  final TextEditingController messageController = TextEditingController();
  var chatList = <ChatModel>[];
  var userList = <UserModel>[];
  var uid = FirebaseAuth.instance.currentUser?.uid ?? "";
  String otherUId = "";
  final DeviceTokenServices tokenServices = DeviceTokenServices();
  final GetServerKey serverKey = GetServerKey();

  getChatList({required String currentUserId, required String otherId}) {
    var chatId = getChatId(currentUserId: currentUserId, otherId: otherId);
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('chatMessages/$chatId');
    starCountRef.orderByChild("dateTime").onValue.listen((DatabaseEvent event) {
      chatList.clear();
      var data = event.snapshot.children;
      for (var element in data) {
        var chat = ChatModel(
            senderId: element.child("sender_id").value.toString(),
            receiverId: element.child("receiver_id").value.toString(),
            message: element.child("message").value.toString(),
            status: element.child("status").value.toString(),
            message_type: element.child("message_type").value.toString(),
            photo_url: element.child("photo_url").value.toString(),
            dateTime: element.child('dateTime').value != null
                ? DateTime.parse(element.child('dateTime').value.toString())
                : null);
        chatList.add(chat);
        // notifyListeners();
      }
      notifyListeners();
    });
  }

  sendChat({required String otherUid}) async {
    if (messageController.text.trim().isEmpty) return;

    var currentUserId = uid.toString();
    var chatId = getChatId(otherId: otherUid, currentUserId: currentUserId);
    var randomId = generateRandomString(40);

    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('chatMessages/$chatId');

    DatabaseReference userRef =
        FirebaseDatabase.instance.ref('user/$currentUserId');
    var userSnapshot = await userRef.get();

    String senderName = "Unknown";

    if (userSnapshot.exists) {
      senderName =
          userSnapshot.child("name").value?.toString() ?? 'Unknown Person';
      print("Sender Name: $senderName");
    } else {
      print("User data not found in Firebase.");
    }

    await starCountRef.child(randomId).set(ChatModel(
            message: messageController.text.toString(),
            senderId: "$uid",
            receiverId: otherUid,
            message_type: "text",
            status: "sent",
            dateTime: DateTime.now())
        .toJson());

    String? deviceToken = await tokenServices.getDeviceToken(otherUid);
    if (deviceToken != null && deviceToken.isNotEmpty) {
      await PushNotificationService.sendNotificationToUser(
          token: deviceToken,
          title: senderName,
          message: messageController.text,
          otherUid: otherUid);
    } else {
      Fluttertoast.showToast(msg: "Failed to get recipient's device token");
    }

    messageController.clear();
    notifyListeners();
  }

  Future<void> sendImage(
      {required String otherUid, required File imageFile}) async {
    String? imageUrl = await uploadImageToFirebase(imageFile);

    if (imageUrl != null) {
      var chatId = getChatId(currentUserId: uid, otherId: otherUid);
      var randomId = generateRandomString(20);
      DatabaseReference reference =
          FirebaseDatabase.instance.ref("chatMessages/$chatId");

      await reference.child(randomId).set(ChatModel(
              senderId: uid,
              receiverId: otherUid,
              message_type: "image",
              photo_url: imageUrl,
              message: '',
              dateTime: DateTime.now())
          .toJson());
    }
  }

  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      String fileName = "chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg";
      Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print("Image Upload Error: $e");
      return null;
    }
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  getUserList() {
    DatabaseReference starCountRef = FirebaseDatabase.instance.ref("chatUser");
    starCountRef.onValue.listen((DatabaseEvent event) {
      var data = event.snapshot.children;
      userList.clear();
      data.forEach(
        (element) {
          var user = UserModel(
              name: element.child("name").value.toString(),
              email: element.child("email").value.toString(),
              id: element.child("id").value.toString());
          userList.add(user);
        },
      );
      notifyListeners();
    });
  }

  String getChatId({required String currentUserId, required String otherId}) {
    var id = "";
    if (currentUserId.compareTo(otherId) > 0) {
      id = "${currentUserId}_$otherId";
    } else {
      id = "${otherId}_$currentUserId";
    }

    FirebaseDatabase.instance.ref('chatMessages').child(id).get().then((value) {
      if (value.exists) {
      } else {
        var chatId = FirebaseDatabase.instance
            .ref()
            .child("chatMessages")
            .child(id)
            .set(id);
        print(chatId);
      }
    });
    return id;
  }

  Future<void> markMessagesAsSeen({required String otherUid})async{
    var chatId = getChatId(currentUserId:uid,otherId:otherUid);
    DatabaseReference reference = FirebaseDatabase.instance.ref("chatMessages/$chatId");

    var snapshot = await reference.get();
    bool anyUpdate = false;

    for (var child in snapshot.children) {
      if (child.child("receiver_id").value.toString() == uid) {
        await reference.child(child.key!).update({"status": "seen"});
        anyUpdate = true;
      }
    }

    if(anyUpdate){
      notifyListeners();
    }
  }
}

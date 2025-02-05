import 'dart:convert';
import 'package:chat_app/notifications/get_server_key.dart';
import 'package:chat_app/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class PushNotificationService {

  static Future<void> sendNotificationToUser({required String token, required String title, required String message, required String otherUid}) async {

    String accessToken = await GetServerKey().getServerKey();

    final UserProvider userProvider = UserProvider();
    final user = userProvider.currentUserName;

    var headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    Map<String, dynamic> body = {
      "message": {
        "token": token,
        "notification": {
          "title": user,
          "body": message,
        },
        "data": {
          "sender_id": otherUid,
          "name": title,
        }
      }
    };

    try {
      http.Response response = await http.post(
        Uri.parse("https://fcm.googleapis.com/v1/projects/aimit-151/messages:send"),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Notification sent successfully");
      } else {
        Fluttertoast.showToast(msg: "Failed to send notification. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  static Future<void> sendCallNotification({required String token, required String callerName, required String callID}) async{
    String serverKey = await GetServerKey().getServerKey();
    Uri uri = Uri.parse("https://fcm.googleapis.com/v1/projects/aimit-151/messages:send");

    Map<String, dynamic> body =
    {
      "message": {
        "token": token,
        "notification": {
          "title": "$callerName is calling you...",
          "body": "Tap to answer the call.",
        },
        "data": {
          "call_id": callID
        }
      }
    };

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKey',
      },
      body: json.encode(body),
    );
  }

}

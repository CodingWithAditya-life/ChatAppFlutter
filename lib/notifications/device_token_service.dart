import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DeviceTokenServices {
  Future<void> storeDeviceToken() async {
    await FirebaseMessaging.instance.requestPermission();
    String? token = await FirebaseMessaging.instance.getToken();

    print("Generated Token: $token");

    if (token == null) {
      print("FCM Token is null");
      return;
    }

    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (uid.isEmpty) {
      print("User id is Empty");
      return;
    }

    await FirebaseDatabase.instance.ref('user/$uid').update({
      'deviceToken': token,
    });

    print("Device token stored successfully");
  }

  Future<String?> getDeviceToken(String uid) async {
    final snapshot = await FirebaseDatabase.instance
        .ref('user/$uid/deviceToken')
        .get();

    if (snapshot.exists) {
      return snapshot.value.toString();
    }

    print("No DeviceToken found for UID: $uid");
    return null;
  }
}

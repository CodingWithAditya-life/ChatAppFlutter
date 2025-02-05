import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DeviceTokenServices{

  Future<void> storeDeviceToken() async {
    String? token = await FirebaseMessaging.instance.getToken();

    if (token != null) {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

      if (uid.isNotEmpty) {
        DatabaseReference userRef = FirebaseDatabase.instance.ref('user/$uid');
        await userRef.update({'deviceToken': token});

        print('Device token stored: $token');
      }
    } else {
      print('Failed to get device token');
    }
  }

  Future<String?> getDeviceToken(String userId) async {
    DatabaseReference userRef = FirebaseDatabase.instance.ref('user/$userId');
    DataSnapshot snapshot = await userRef.get();

    if (snapshot.exists) {
      Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.value as Map);
      return data['deviceToken'];
    }
    return null;
  }
}


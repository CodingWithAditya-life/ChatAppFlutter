import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../../notifications/device_token_service.dart';
import '../../../../notifications/push_notification_services.dart';

class CallRequestServices {
  final DeviceTokenServices tokenServices = DeviceTokenServices();
  final DatabaseReference reference = FirebaseDatabase.instance.ref("callRequests");

  Future<void> sendCallRequest(String receiverID, String callID) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    String? senderName = FirebaseAuth.instance.currentUser?.displayName;

    if (uid == null || senderName == null) return;

    await reference.child(receiverID).set({
      "callerId": uid,
      "call_id": callID,
      "callerName": senderName,
      "dateTime": DateTime.now().toIso8601String()
    });

    DatabaseReference userRef = FirebaseDatabase.instance.ref("callRequests/$receiverID");
    DatabaseEvent event = await userRef.once();
    if (event.snapshot.exists) {
      Map userData = event.snapshot.value as Map;
      String? receiverToken = tokenServices.storeDeviceToken().toString();
      if (receiverToken != null) {
        await PushNotificationService.sendCallNotification(
          token: receiverToken,
          callerName: senderName,
          callID: callID,
        );
      }
    }
  }

  Stream<DatabaseEvent> listenForIncomingCalls(String userID) {
    return reference
        .child(userID)
        .onValue;
  }

  Future<void> removeCallRequest(String userID) async {
    await reference.child(userID).remove();
  }

}
import 'package:chat_app/features/home/widget/home_screen_AppBar_widget.dart';
import 'package:chat_app/providers/user_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widget/user_item_list.dart';
import '../../notifications/device_token_service.dart';
import '../../notifications/get_server_key.dart';
import '../../notifications/notification_service.dart';

class HomeScreen extends StatefulWidget {
  final String uid;

  const HomeScreen({super.key, required this.uid});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationService _notificationService = NotificationService();
  final DeviceTokenServices tokenServices = DeviceTokenServices();
  final GetServerKey serverKey = GetServerKey();

  final DatabaseReference _userRef = FirebaseDatabase.instance.ref("user");

  String? userName;
  String? userProfilePhoto;

  @override
  void initState() {
    super.initState();
    tokenServices.getDeviceToken(widget.uid);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false)
          .fetchUserData(widget.uid);
    });
    _initializeNotification();
    getUserData();

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {}
    });
  }

  Future<void> _initializeNotification() async {
    await _notificationService.initNotification(context);
    await _notificationService.requestPermission();
  }

  void getUserData() async {
    if (widget.uid.isNotEmpty) {
      final snapshot = await _userRef.child(widget.uid).get();
      if (snapshot.exists) {
        Map<String, dynamic> userData =
        Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          userName = userData['name'];
          userProfilePhoto = userData['photo_url'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _notificationService.initNotification(context);
      await tokenServices.storeDeviceToken();
      await serverKey.getServerKey();
    });

    return Scaffold(
      appBar: HomeScreenAppBar(),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.userData.isEmpty) {
            return Center(child: Text("No users found"));
          } else {
            return ListView.builder(
              itemCount: userProvider.userData.length,
              itemBuilder: (context, index) {
                var user = userProvider.userData[index];
                return UserItemList(
                  userId: user.id ?? "",
                  userName: user.name ?? "",
                  photoUrl: user.photo_url ?? "",
                );
              },
            );
          }
        },
      ),
    );
  }
}


import 'package:chat_app/features/chat/widget/users_search_list_widget.dart';
import 'package:chat_app/features/home/widget/home_screen_AppBar_widget.dart';
import 'package:chat_app/model/user_model.dart';
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
  TextEditingController searchUsersController = TextEditingController();

  final DatabaseReference _userRef = FirebaseDatabase.instance.ref("user");

  String? userName;
  String? userProfilePhoto;
  String searchQuery = '';

  Future<void> refreshUser() async {
    await Provider.of<UserProvider>(context, listen: false)
        .fetchUserData(widget.uid);
    await getUserData();
  }

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

    searchUsersController.addListener(() {
      setState(() {
        searchQuery = searchUsersController.text;
      });
    });
  }

  @override
  void dispose() {
    searchUsersController.dispose();
    super.dispose();
  }

  Future<void> _initializeNotification() async {
    await _notificationService.initNotification(context);
    await _notificationService.requestPermission();
  }

  Future<void> getUserData() async {
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

  List<UserModel> filterUsers(List<UserModel> users) {
    if (searchQuery.trim().isEmpty) {
      return users;
    }

    return users.where((user) {
      final userName = user.name?.toLowerCase() ?? '';
      return userName.contains(searchQuery.toLowerCase());
    }).toList();
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
      body: RefreshIndicator(
        onRefresh: refreshUser,
        backgroundColor: Color(0xFF292F3F),
        color: Colors.white,
        child: Column(
          children: [
            CustomSearchBar(
              searchController: searchUsersController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            Expanded(
              child: Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  if (userProvider.userData.isEmpty) {
                    return Center(child: Text("No users found"));
                  }
                  final filteredUsers = filterUsers(userProvider.userData);

                  if (filteredUsers.isEmpty) {
                    return Center(
                      child: Text(
                        "No users found matching '${searchQuery.trim()}'",
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:chat_app/providers/user_provider.dart';
import 'package:chat_app/features/chat/providers/chat_provider.dart';
import 'package:chat_app/notifications/notification_service.dart';
import 'package:chat_app/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme.dart';
import 'features/authentication/call/service/video_call_services.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(message.notification!.title);
  print(message.notification!.body);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  NotificationService.initialize();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => ChatProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context, listen: false).fetchCurrentUserName();

    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    NotificationService notificationService = NotificationService();
    notificationService.initNotification(context);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data.containsKey("call_id")) {
        String callID = message.data["call_id"];

        navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (context) => VideoCallService(
            callID: callID,
            userID: FirebaseAuth.instance.currentUser!.uid,
            userName: 'name',
          ),
        ));
      }
    });

    return MaterialApp(
      title: 'Chat App',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: SplashScreen()
    );
  }
}



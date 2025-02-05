import 'dart:async';
import 'package:chat_app/core/constants/const.dart';
import 'package:chat_app/core/theme/theme.dart';
import 'package:chat_app/features/home/home_screen.dart';
import 'package:chat_app/features/authentication/screens/signUp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), (){
      final auth = FirebaseAuth.instance.currentUser;
      if(auth != null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(uid: '${auth.uid}')));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultColors.messageListPage,
      body: Center(
        child: Image(image: AssetImage(AppInfo.appIcon), width: 95, height: 95),
      ),
    );
  }
}

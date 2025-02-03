import 'dart:core';
import 'package:chat_app/features/authentication/screens/signIn_screen.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/features/chat/screen/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserProvider with ChangeNotifier{
  final _auth = FirebaseAuth.instance;
  var nameController= TextEditingController();
  var emailController= TextEditingController();
  var passwordController= TextEditingController();

  bool isLoading = false;
  List<UserModel> _userData= [];

  bool get loading => isLoading;
  List<UserModel> get userData=> _userData;

  String? _currentUserName;

  String? get currentUserName => _currentUserName;

  void userSignUp(BuildContext context) async{
    var name =  nameController.text.toString();
    var email = emailController.text.toString();
    var password= passwordController.text.toString();

    if(name.isNotEmpty && email.isNotEmpty && password.isNotEmpty){
      isLoading = false;
      notifyListeners();
      try{
        var result = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        if(result.user!= null){
          var uid = result.user?.uid;
          DatabaseReference ref= FirebaseDatabase.instance.ref("user/$uid");
          await ref.set({
            "id":uid,
            "name":name,
            "email":email,
            "photo_url": ""
          });
          nameController.clear();
          emailController.clear();
          passwordController.clear();
          Fluttertoast.showToast(msg: "SignUp is successful");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatScreen(otherUid: "",userName: name,),));
        }
        notifyListeners();
      }
      catch(e){
        Fluttertoast.showToast(msg: "$e SignUp is Failed");
      }finally{
        isLoading = false;
        notifyListeners();
      }
    }
    else{
      Fluttertoast.showToast(msg: "Please fill the all field");
    }
  }

  void userSignIn(BuildContext context) async{
    var email= emailController.text;
    var password= passwordController.text;

    if(email.isNotEmpty && password.isNotEmpty){
      isLoading = true;
      notifyListeners();
      var result = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      if(result.user!=null){
        Fluttertoast.showToast(msg: "SignIn is Successfully");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatScreen(otherUid: '',userName: nameController.text.toString(),)));

        emailController.clear();
        passwordController.clear();
      }
    }
    else{
      Fluttertoast.showToast(msg: "Please fill the all filed");
    }
  }

  void logoutUser(BuildContext context) async{
    await _auth.signOut();
    Fluttertoast.showToast(msg: "logOut User");
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen(),));
  }

  Future<void> fetchUserData(String uid) async {
    isLoading = true;
    notifyListeners();

    DatabaseReference ref = FirebaseDatabase.instance.ref("user");
    try {
      final dataSnapshot = await ref.get();
      if (dataSnapshot.exists) {
        final dataMap = Map<String, dynamic>.from(dataSnapshot.value as Map);
        final List<UserModel> tempList = dataMap.entries.map((e) {
          return UserModel.fromJson(Map<String, dynamic>.from(e.value));
        }).toList();

        _userData = tempList;
        notifyListeners();
      } else {
        _userData = [];
      }
    } catch (e) {
      print("Error fetching user data: $e");
      _userData = [];
    }finally{
      isLoading = true;
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> fetchCurrentUserName() async {
    String? uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('user').doc(uid).get();
      if (snapshot.exists) {
        _currentUserName = snapshot['name'];
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching current user name: $e");
    }
  }
}

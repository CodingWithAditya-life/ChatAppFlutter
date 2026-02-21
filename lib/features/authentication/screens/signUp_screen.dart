import 'dart:io';
import 'package:chat_app/core/theme/theme.dart';
import 'package:chat_app/features/home/home_screen.dart';
import 'package:chat_app/features/authentication/screens/signIn_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show Supabase, FileOptions;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> pickImageFromGallery() async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      if (await Permission.photos.isGranted) {
        status = PermissionStatus.granted;
      } else {
        status = await Permission.photos.request();
      }
    } else {
      status = await Permission.photos.request();
    }

    if (status.isGranted) {
      final XFile? pickFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickFile != null) {
        setState(() {
          _profileImage = File(pickFile.path);
          _isLoading = true;
        });

        await uploadImage();

        setState(() {
          _isLoading = false;
        });
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else {
      Fluttertoast.showToast(msg: "Gallery permission denied");
    }
  }

  Future uploadImage() async {
    if (_profileImage == null) return;
    try {
      // Reference storageReference = FirebaseStorage.instance.ref().child('profile_images/$uid.jpg');
      // await storageReference.putFile(_profileImage!);
      // return await storageReference.getDownloadURL();

      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final path = 'uploads/$fileName';

      await Supabase.instance.client.storage
          .from('avatars')
          .upload(path, _profileImage!)
          .then(
            (value) => ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Image upload successful"))),
          );

      Fluttertoast.showToast(msg: "Image upload successful");

      final publicUrl = Supabase.instance.client.storage
          .from('avatars')
          .getPublicUrl(path);

      print("Uploaded URL: $publicUrl");

      return publicUrl;
    } catch (e) {
      Fluttertoast.showToast(msg: "Image upload failed:$e");
      print("Image upload failed:$e");
      return null;
    }
  }

  void userSignUp(BuildContext context) async {
    var name = _fullNameController.text.trim();
    var email = _emailController.text.trim();
    var password = _passwordController.text.trim();

    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      try {
        var result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (result.user != null) {
          var uid = result.user!.uid;
          String? imageUrl = await uploadImage();

          DatabaseReference ref = FirebaseDatabase.instance.ref("user/$uid");
          await ref.set({
            "id": uid,
            "name": name,
            "email": email,
            "photo_url": imageUrl ?? '',
          });
          Fluttertoast.showToast(msg: "SignUp successful");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen(uid: uid)),
          );
        }
      } catch (e) {
        Fluttertoast.showToast(msg: "SignUp failed: $e");
      }
    } else {
      Fluttertoast.showToast(msg: "Please fill all fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Hello, Welcome Back",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Happy to see you again, to use your account please login first.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: pickImageFromGallery,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(75),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(.2),
                          spreadRadius: 10,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 75,
                          backgroundColor: Colors.transparent,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : null,
                          child: _profileImage == null
                              ? Icon(
                                  Icons.camera_alt,
                                  size: 40,
                                  color: Colors.grey,
                                )
                              : null,
                        ),

                        if (_isLoading)
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextInput('Full Name', Icons.person, _fullNameController),
                const SizedBox(height: 20),
                _buildTextInput(
                  'Email',
                  Icons.email_outlined,
                  _emailController,
                ),
                const SizedBox(height: 20),
                _buildTextInput(
                  'Password',
                  Icons.password_outlined,
                  _passwordController,
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                _buildSignUpButton(),
                const SizedBox(height: 20),
                buildSignInPrompt(),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSocialLoginButton('assets/logos/google.png', () {}),
                    _buildSocialLoginButton('assets/logos/apple.png', () {}),
                    _buildSocialLoginButton('assets/logos/facebook.png', () {}),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput(
    String hint,
    IconData icon,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: DefaultColors.sentMessageInput,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => userSignUp(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF771F98),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget buildSignInPrompt() {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignInScreen()),
          );
        },
        child: RichText(
          text: const TextSpan(
            text: 'Already have an account? ',
            style: TextStyle(color: Colors.grey),
            children: [
              TextSpan(
                text: 'Sign In',
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButton(String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.grey[300],
        child: Image.asset(assetPath, width: 35, height: 35, fit: BoxFit.cover),
      ),
    );
  }
}

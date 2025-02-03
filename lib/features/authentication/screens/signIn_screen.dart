import 'package:chat_app/features/home/home_screen.dart';
import 'package:chat_app/features/authentication/screens/signUp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../core/theme/theme.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void userSignIn(BuildContext context) async {
    var email = _emailController.text.trim();
    var password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        var result = await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        if (result.user != null) {
          Fluttertoast.showToast(msg: "SignIn successful");
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => HomeScreen(
                        uid: _auth.currentUser!.uid.toString(),
                      )));
        }
      } catch (e) {
        Fluttertoast.showToast(msg: "SignIn failed: $e");
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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
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
                const SizedBox(height: 10),
                const Text(
                  "Happy to see you again, to use your account please login first.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                _buildTextInput(
                    'Email Address', Icons.email_outlined, _emailController),
                const SizedBox(height: 20),
                _buildTextInput(
                    'Password', Icons.password_outlined, _passwordController,
                    isPassword: true),
                const SizedBox(height: 10),
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: TextButton(
                //     onPressed: () {},
                //     child: const Text(
                //       "Forgot Password",
                //       style: TextStyle(color: Color(0xFF771F98)),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => userSignIn(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF771F98),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                  },
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(color: Colors.grey),
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
      String hint, IconData icon, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: DefaultColors.sentMessageInput,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          SizedBox(width: 10),
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                border: InputBorder.none,
              ),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLoginButton(String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.grey[300],
        child: Image.asset(
          assetPath,
          width: 35,
          height: 35,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

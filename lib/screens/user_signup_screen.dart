import 'package:flutter/material.dart';
import '../widgets/animated_widgets.dart';
import 'user_home_screen.dart'; // استيراد شاشة UserHomeScreen

class UserSignupScreen extends StatefulWidget {
  const UserSignupScreen({super.key});

  @override
  _UserSignupScreenState createState() => _UserSignupScreenState();
}

class _UserSignupScreenState extends State<UserSignupScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _acceptTerms = false;
  bool _isHovering = false;

  void _onSignupPressed() {
    if (_acceptTerms) {
      print("Signing Up...");

      // الانتقال إلى الشاشة الرئيسية بعد التسجيل
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  UserHomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth > 1200 ? 500 : screenWidth * 0.9;

    return Scaffold(
      backgroundColor: const Color(0xFFDBFFE6),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: containerWidth,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 3,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "User Signup",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF2E7D32),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedTextField(controller: fullNameController, label: "Full Name"),
                  const SizedBox(height: 15),
                  AnimatedTextField(controller: emailController, label: "Email"),
                  const SizedBox(height: 15),
                  AnimatedTextField(controller: passwordController, label: "Password", isPassword: true),
                  const SizedBox(height: 15),
                  AnimatedTextField(controller: confirmPasswordController, label: "Confirm Password", isPassword: true),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: _acceptTerms,
                        onChanged: (value) {
                          setState(() {
                            _acceptTerms = value!;
                          });
                        },
                        activeColor: const Color(0xFF2E7D32),
                      ),
                      Expanded(
                        child: MouseRegion(
                          onEnter: (_) => setState(() => _isHovering = true),
                          onExit: (_) => setState(() => _isHovering = false),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _acceptTerms = !_acceptTerms;
                              });
                            },
                            child: RichText(
                              text: TextSpan(
                                text: "I accept the ",
                                style: const TextStyle(color: Colors.black, fontSize: 14),
                                children: [
                                  TextSpan(
                                    text: "Terms & Conditions",
                                    style: TextStyle(
                                      color: const Color(0xFF2E7D32),
                                      fontWeight: FontWeight.bold,
                                      decoration: _isHovering ? TextDecoration.underline : TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  AnimatedButton(
                    text: "Sign Up",
                    onPressed: _acceptTerms ? _onSignupPressed : () {},
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Back to Selection",
                      style: TextStyle(color: Color(0xFF2E7D32), fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

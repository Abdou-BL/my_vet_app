import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'signup_type_screen.dart';
import '../widgets/animated_widgets.dart';
import 'doctor_home_screen.dart';
import '../widgets/colors.dart'; // ✅ Import custom colors

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth * 0.4;
    containerWidth = containerWidth.clamp(320.0, 500.0);

    return Scaffold(
      backgroundColor: AppColors.primaryLight, // ✅ Using custom color
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: containerWidth,
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 8,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      color: AppColors.primaryColor, // ✅ Using custom color
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedTextField(
                    controller: _emailController,
                    label: 'Email',
                  ),
                  const SizedBox(height: 15),
                  AnimatedTextField(
                    controller: _passwordController,
                    label: 'Password',
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: AnimatedButton(
                      text: 'Login',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          print('Login successful for: ${_emailController.text}');
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorHomeScreen(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black54,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign up',
                          style: const TextStyle(
                            color: AppColors.primaryColor, // ✅ Using custom color
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignupTypeScreen(),
                                ),
                              );
                            },
                        ),
                      ],
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

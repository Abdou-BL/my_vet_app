import 'package:flutter/material.dart';
import '../widgets/colors.dart'; // Import your color file
import 'user_signup_screen.dart'; // Import the user sign-up screen
import 'doctor_signup_screen.dart'; // Import the doctor sign-up screen
import 'login_screen.dart'; // Import the login screen

class SignupTypeScreen extends StatefulWidget {
  const SignupTypeScreen({super.key});

  @override
  _SignupTypeScreenState createState() => _SignupTypeScreenState();
}

class _SignupTypeScreenState extends State<SignupTypeScreen> {
  double _scaleUser = 1.0;
  double _scaleDoctor = 1.0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth > 1200 ? 600 : screenWidth * 0.85;
    double iconSize = screenWidth > 1200 ? 100 : 70;

    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),
      ),
      body: Center(
        child: Container(
          width: containerWidth,
          padding: EdgeInsets.all(screenWidth > 1200 ? 30 : 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 16,
                spreadRadius: 4,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Account Type",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _buildUserTypeOption(
                      "User",
                      "assets/images/person.png",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserSignupScreen(),
                          ),
                        );
                      },
                      scale: _scaleUser,
                      iconSize: iconSize,
                      onHover: (hovering) {
                        setState(() {
                          _scaleUser = hovering ? 1.02 : 1.0;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildUserTypeOption(
                      "Doctor",
                      "assets/images/doctor.png",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DoctorSignupScreen(),
                          ),
                        );
                      },
                      scale: _scaleDoctor,
                      iconSize: iconSize,
                      onHover: (hovering) {
                        setState(() {
                          _scaleDoctor = hovering ? 1.02 : 1.0;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeOption(
    String title,
    String imagePath,
    VoidCallback onTap, {
    required double scale,
    required double iconSize,
    required Function(bool) onHover,
  }) {
    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(scale),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Image.asset(imagePath, height: iconSize),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

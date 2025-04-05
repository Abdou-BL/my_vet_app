import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/animated_widgets.dart';
import 'doctor_home_screen.dart'; // استيراد شاشة DoctorHomeScreen

class DoctorSignupScreen extends StatefulWidget {
  const DoctorSignupScreen({super.key});

  @override
  _DoctorSignupScreenState createState() => _DoctorSignupScreenState();
}

class _DoctorSignupScreenState extends State<DoctorSignupScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController clinicNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String? selectedFileName;
  bool _acceptTerms = false;
  bool _isHovering = false;

  void _onSignupPressed() {
    if (_acceptTerms) {
      // الانتقال إلى DoctorHomeScreen بعد التسجيل
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DoctorHomeScreen()),
      );
    }
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      String fileName = result.files.single.name;
      setState(() {
        selectedFileName = fileName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth > 1200
        ? 450
        : screenWidth > 600
            ? screenWidth * 0.7
            : screenWidth * 0.9; // Adjust for mobile screens

    return Scaffold(
      backgroundColor: const Color(0xFFDBFFE6),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Center(
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
                            "Doctor Signup",
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
                          AnimatedTextField(controller: clinicNameController, label: "Name of Clinic/Cabinet"),
                          const SizedBox(height: 15),
                          AnimatedTextField(controller: emailController, label: "Email"),
                          const SizedBox(height: 15),
                          AnimatedTextField(controller: passwordController, label: "Password", isPassword: true),
                          const SizedBox(height: 15),
                          AnimatedTextField(controller: confirmPasswordController, label: "Confirm Password", isPassword: true),
                          const SizedBox(height: 20),

                          const Text(
                            "Certification Verification",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: _pickFile,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFF81C784), width: 2),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2E7D32),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      "Choose File",
                                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      selectedFileName ?? "No file chosen (PDF/IMAGE)",
                                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
          },
        ),
      ),
    );
  }
}

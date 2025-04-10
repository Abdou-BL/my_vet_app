import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../../../widgets/colors.dart';

class EditableProfileScreen extends StatefulWidget {
  const EditableProfileScreen({super.key});

  @override
  State<EditableProfileScreen> createState() => _EditableProfileScreenState();
}

class _EditableProfileScreenState extends State<EditableProfileScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  final TextEditingController nameController =
      TextEditingController(text: 'Jordan Mendez');
  final TextEditingController emailController =
      TextEditingController(text: 'jordan.mendez@example.com');
  final TextEditingController phoneController =
      TextEditingController(text: '+1 234 567 8900');
  final TextEditingController birthController =
      TextEditingController(text: '1990-01-01');
  final TextEditingController countryController =
      TextEditingController(text: 'Algérie');
  final TextEditingController wilayaController =
      TextEditingController(text: 'Alger');

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    birthController.dispose();
    countryController.dispose();
    wilayaController.dispose();
    super.dispose();
  }

  /// Builds a nicely styled editable field with a rounded outline.
  Widget _buildEditableField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: AppColors.primaryColor),
          const SizedBox(width: 15),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                filled: true,
                fillColor: AppColors.primaryLight,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.primaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.primaryColor),
                ),
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(width: 10),
          const Icon(FeatherIcons.edit, size: 18, color: Colors.grey),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FCF3),
      appBar: AppBar(
        title: const Text('Profil',
            style: TextStyle(color: AppColors.primaryColor)),
        leading: const BackButton(color: AppColors.primaryColor),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Hero(
                  tag: 'profile_avatar',
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primaryColor,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  nameController.text,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                Divider(
                  color: AppColors.customColor1,
                  thickness: 2,
                  indent: 40,
                  endIndent: 40,
                ),
                _buildEditableField(
                  icon: FeatherIcons.user,
                  label: 'Nom',
                  controller: nameController,
                ),
                _buildEditableField(
                  icon: FeatherIcons.mail,
                  label: 'Email',
                  controller: emailController,
                ),
                _buildEditableField(
                  icon: FeatherIcons.phone,
                  label: 'Téléphone',
                  controller: phoneController,
                ),
                _buildEditableField(
                  icon: FeatherIcons.calendar,
                  label: 'Date de naissance',
                  controller: birthController,
                ),
                _buildEditableField(
                  icon: FeatherIcons.mapPin,
                  label: 'Pays',
                  controller: countryController,
                ),
                _buildEditableField(
                  icon: FeatherIcons.map,
                  label: 'Wilaya',
                  controller: wilayaController,
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 20),
                      backgroundColor: AppColors.termineeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Profil mis à jour"),
                          backgroundColor: AppColors.customColor1,
                        ),
                      );
                    },
                    icon: const Icon(Icons.save, size: 24),
                    label: const Text(
                      "Sauvegarder",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

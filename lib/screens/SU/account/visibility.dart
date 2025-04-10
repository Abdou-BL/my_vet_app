import 'package:flutter/material.dart';
import '../../../widgets/colors.dart';


class VisibilitySettingsScreen extends StatefulWidget {
  @override
  _VisibilitySettingsScreenState createState() => _VisibilitySettingsScreenState();
}

class _VisibilitySettingsScreenState extends State<VisibilitySettingsScreen>
    with SingleTickerProviderStateMixin {
  bool isEmailVisible = false;
  bool isPhoneVisible = false;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // Animation for the whole screen content to slide in from bottom
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Reusable widget for visibility toggle items with smooth background and switch animations.
  Widget visibilityItem({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: value ? AppColors.customColor1.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: ListTile(
          leading: Icon(icon, color: AppColors.miniAppointmentColor, size: 28),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(child: child, scale: animation);
            },
            child: Switch(
              key: ValueKey<bool>(value),
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.termineeColor,
              inactiveTrackColor: Colors.grey[300],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable widget for navigation items like sharing the profile.
  Widget navigationItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: ListTile(
          leading: Icon(icon, color: AppColors.primaryColor, size: 28),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Icon(Icons.chevron_right, color: Colors.grey[600]),
          onTap: onTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black87),
        title: Text('Visibilité'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          children: [
            visibilityItem(
              icon: Icons.mail_outline,
              title: "Visibilité de l'email",
              value: isEmailVisible,
              onChanged: (val) => setState(() => isEmailVisible = val),
            ),
            visibilityItem(
              icon: Icons.phone_outlined,
              title: "Visibilité numéro de téléphone",
              value: isPhoneVisible,
              onChanged: (val) => setState(() => isPhoneVisible = val),
            ),
            navigationItem(
              icon: Icons.share_outlined,
              title: "Partager mon profil",
              onTap: () {
                // You can navigate to another screen or display a dialog here.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Fonctionnalité à venir'),
                    backgroundColor: AppColors.avertisColor,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

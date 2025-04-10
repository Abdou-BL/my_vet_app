import 'package:flutter/material.dart';
import '../../../widgets/colors.dart';
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen>
    with SingleTickerProviderStateMixin {
  bool pushNotifications = true;
  bool emailNotifications = true;
  bool messageNotifications = true;
  bool newsUpdates = false;

  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // AnimationController for the screen entrance.
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildNotificationTile(
                title: 'Push Notifications',
                subtitle: 'Receive notifications on your device',
                value: pushNotifications,
                onChanged: (val) {
                  setState(() {
                    pushNotifications = val;
                  });
                },
              ),
              _buildNotificationTile(
                title: 'Email Notifications',
                subtitle: 'Receive notifications via email',
                value: emailNotifications,
                onChanged: (val) {
                  setState(() {
                    emailNotifications = val;
                  });
                },
              ),
              _buildNotificationTile(
                title: 'Message Notifications',
                subtitle: 'Get notified when you receive messages',
                value: messageNotifications,
                onChanged: (val) {
                  setState(() {
                    messageNotifications = val;
                  });
                },
              ),
              _buildNotificationTile(
                title: 'News & Updates',
                subtitle: 'Stay informed about platform updates',
                value: newsUpdates,
                onChanged: (val) {
                  setState(() {
                    newsUpdates = val;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a notification tile with an animated elevation change.
  Widget _buildNotificationTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 8),
      // Elevation increases slightly when the switch is on.
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: value ? 6 : 2,
        child: SwitchListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(subtitle),
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primaryColor,
          inactiveThumbColor: AppColors.primaryLight,
          inactiveTrackColor: Colors.grey.shade300,
        ),
      ),
    );
  }
}

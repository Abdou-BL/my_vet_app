import 'package:flutter/material.dart';
import '../../widgets/colors.dart';

// Import external screen files – adjust the paths to match your project structure.
import './account/Privacy policy_screen.dart';
import './account/compte.dart';
import './account/data_screen.dart';
import './account/favoris.dart';
import './account/notification_screen.dart';
import './account/securite_screen.dart';
import './account/visibility.dart';

// Make sure to import or define your LoginScreen widget.
import '../login_screen.dart'; 

/// The UserScreen acts as the initial screen and routes to the various settings screens.
class UserScreen extends StatelessWidget {
  const UserScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // You can adjust the background color, elevation, and icon color according to your design.
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: AppColors.primaryColor),
            onPressed: () {
              // When the logout button is pressed, the user is navigated to the LoginScreen.
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          color: Colors.white,
          child: Column(
            children: const [
              SizedBox(height: 60),
              ProfileHeader(),
              // Updated divider with a green color from AppColors.
              Divider(height: 1, color: AppColors.primaryColor),
              Expanded(child: SettingsList()),
            ],
          ),
        ),
      ),
    );
  }
}

/// Displays the user profile header with the profile image and name,
/// using a Hero widget for a smooth transition if needed.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      child: Column(
        children: [
          Hero(
            tag: 'profile_image',
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryColor, width: 2.5),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/person.png', // Ensure the correct image path.
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: AnimatedOpacity(
                    opacity: 1,
                    duration: const Duration(seconds: 2),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryColor.withOpacity(0.3),
                          width: 2.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Abdou',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

/// A list of setting items. Each item routes to one of the external screens,
/// with a fade transition on navigation.
class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        SettingItem(
          icon: Icons.person_outline,
          label: 'Account',
          onTap: () {
            Navigator.push(
              context,
              _createFadeRoute(const EditableProfileScreen()),
            );
          },
        ),
        SettingItem(
          icon: Icons.lock_outline,
          label: 'Security',
          onTap: () {
            Navigator.push(
              context,
              _createFadeRoute(const SecurityScreen()),
            );
          },
        ),
        SettingItem(
          icon: Icons.data_usage,
          label: 'Data',
          onTap: () {
            Navigator.push(
              context,
              _createFadeRoute(const DataPrivacyScreen()),
            );
          },
        ),

        SettingItem(
          icon: Icons.visibility_outlined,
          label: 'Visibility',
          onTap: () {
            Navigator.push(
              context,
              _createFadeRoute(VisibilitySettingsScreen()),
            );
          },
        ),
        SettingItem(
          icon: Icons.notifications_none,
          label: 'Notifications',
          onTap: () {
            Navigator.push(
              context,
              _createFadeRoute(const NotificationSettingsScreen()),
            );
          },
        ),
        SettingItem(
          icon: Icons.favorite_border,
          label: 'Favorites',
          onTap: () {
            Navigator.push(
              context,
              _createFadeRoute(const FavoritesScreen()),
            );
          },
        ),
                SettingItem(
          icon: Icons.privacy_tip_outlined,
          label: 'Privacy',
          onTap: () {
            Navigator.push(
              context,
              _createFadeRoute(const PrivacyPolicyScreen()),
            );
          },
        ),
      ],
    );
  }
}

/// A helper method to create a fade transition route.
PageRouteBuilder _createFadeRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

/// A reusable widget for a single setting item in the list,
/// enhanced with a card design and a scale animation on tap.
class SettingItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  
  const SettingItem({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });
  
  @override
  State<SettingItem> createState() => _SettingItemState();
}

class _SettingItemState extends State<SettingItem> with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.97;
    });
  }

  void _onTapUp(TapUpDetails details) {
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _scale = 1.0;
      });
    });
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: widget.onTap,
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          splashColor: AppColors.primaryColor.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Icon(widget.icon, color: AppColors.primaryColor, size: 28),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    widget.label,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

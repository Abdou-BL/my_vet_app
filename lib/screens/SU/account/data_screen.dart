import 'package:flutter/material.dart';
import '../../../widgets/colors.dart';
class DataPrivacyScreen extends StatelessWidget {
  const DataPrivacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use white appBar with primaryColor for title and icons.
      appBar: AppBar(
        leading: const BackButton(color: AppColors.primaryColor),
        title: const Text(
          "Data Privacy",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Organized in a Column with spacing.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            AccountActionCard(
              title: "Deactivate Account",
              subtitle: "Temporarily disable your account. You can reactivate it anytime.",
              icon: Icons.pause_circle_filled,
              backgroundColor: AppColors.primaryLight,
              textColor: AppColors.primaryColor,
              onTap: _onDeactivate,
            ),
            SizedBox(height: 20),
            AccountActionCard(
              title: "Delete Account",
              subtitle: "Permanently delete your account and all associated data.",
              icon: Icons.delete_forever,
              backgroundColor: Color(0xFFFDEAEA),
              textColor: AppColors.annuleColor,
              borderColor: Colors.redAccent,
              onTap: _onDelete,
            ),
          ],
        ),
      ),
    );
  }

  static void _onDeactivate() {
    debugPrint("Deactivate tapped");
  }

  static void _onDelete() {
    debugPrint("Delete tapped");
  }
}

/// A card widget for account actions with added hover/tap animations.
class AccountActionCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback onTap;

  const AccountActionCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
    this.borderColor,
  }) : super(key: key);

  @override
  State<AccountActionCard> createState() => _AccountActionCardState();
}

class _AccountActionCardState extends State<AccountActionCard> {
  bool _isHovered = false;

  void _onHover(bool hover) {
    setState(() {
      _isHovered = hover;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Wrap card with AnimatedScale for a subtle scale effect.
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.borderColor ?? Colors.transparent,
                width: 1.5,
              ),
              // Add soft shadow on hover.
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              children: [
                Icon(widget.icon, color: widget.textColor, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: widget.textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          color: widget.textColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

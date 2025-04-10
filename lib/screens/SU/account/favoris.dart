import 'package:flutter/material.dart';
import '../../../widgets/colors.dart';
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar uses a white background with dark text and icons.
      appBar: AppBar(
        title: const Text(
          'Favoris',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Clinics Favorites Section Title
          const Text(
            'Cliniques favorites',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          // Clinic A Card
          _buildFavoriteCard(
            icon: Icons.local_hospital,
            title: 'Clinique A',
            subtitle: 'Description de la clinique A',
            iconColor: AppColors.primaryColor,
          ),
          const SizedBox(height: 12),
          // Clinic B Card
          _buildFavoriteCard(
            icon: Icons.local_hospital,
            title: 'Clinique B',
            subtitle: 'Description de la clinique B',
            iconColor: AppColors.primaryColor,
          ),
          const SizedBox(height: 24),
          // Publications Favorites Section Title
          const Text(
            'Publications favorites',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          // Publication 1 Card
          _buildFavoriteCard(
            icon: Icons.article_outlined,
            title: 'Publication 1',
            subtitle: 'Résumé de la publication 1',
            iconColor: AppColors.primaryColor,
          ),
          const SizedBox(height: 12),
          // Publication 2 Card
          _buildFavoriteCard(
            icon: Icons.article_outlined,
            title: 'Publication 2',
            subtitle: 'Résumé de la publication 2',
            iconColor: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }

  /// Returns a styled card for favorite items with a subtle InkWell tap effect.
  Widget _buildFavoriteCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // You can add a navigation or tap action here.
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

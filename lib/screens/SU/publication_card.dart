import 'package:flutter/material.dart';

class PublicationCard extends StatelessWidget {
  final String username;
  final String content;
  final String imageUrl;

  const PublicationCard({
    super.key,
    required this.username,
    required this.content,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white, // 👈 Set the card background color to white
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/Failed.png'),
            ),
            title: Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text("Just now"),
            trailing: const Icon(Icons.more_vert),
          ),
          if (imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(imageUrl, fit: BoxFit.cover, width: double.infinity),
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(content),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Icon(Icons.favorite_border),
                Icon(Icons.comment),
                Icon(Icons.share),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // Controller for the entrance animation.
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

  /// Helper method to build a section title with refined styling.
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  /// Helper method to build a paragraph with comfortable line spacing.
  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        height: 1.5,
        color: Colors.black87,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Top app bar with a 'Back' button
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      /// Animated body
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 1. Objet
                _buildSectionTitle('1. Objet'),
                const SizedBox(height: 8),
                _buildParagraph(
                  "Les présentes Conditions Générales régissent l’utilisation de l’application vétérinaire "
                  "[Nom de l'app], accessible sur mobile (iOS/Android).",
                ),
                const SizedBox(height: 24),

                /// 2. Inscription
                _buildSectionTitle('2. Inscription'),
                const SizedBox(height: 8),
                _buildParagraph(
                  "Pour accéder à certaines fonctionnalités, vous devez créer un compte. "
                  "Vous vous engagez à fournir des informations exactes et à jour.",
                ),
                const SizedBox(height: 24),

                /// 3. Services proposés
                _buildSectionTitle('3. Services proposés'),
                const SizedBox(height: 8),
                _buildParagraph(
                  "L'application permet :\n"
                  "• La gestion du carnet de santé de vos animaux.\n"
                  "• La recherche et la prise de rendez-vous avec des vétérinaires.\n"
                  "• L’accès à des conseils et informations vétérinaires.",
                ),
                const SizedBox(height: 24),

                /// 4. Responsabilité
                _buildSectionTitle('4. Responsabilité'),
                const SizedBox(height: 8),
                _buildParagraph(
                  "Nous mettons tout en œuvre pour assurer la fiabilité des services, mais :\n"
                  "• Nous ne sommes pas responsables en cas d’erreurs médicales commises par des vétérinaires partenaires.\n"
                  "• L’utilisateur reste responsable de l’usage de l’application et des décisions prises à partir des informations fournies.",
                ),
                const SizedBox(height: 24),

                /// 5. Résiliation
                _buildSectionTitle('5. Résiliation'),
                const SizedBox(height: 8),
                _buildParagraph(
                  "Vous pouvez supprimer votre compte à tout moment depuis les paramètres de l’application. "
                  "En cas d’abus ou de non-respect des CGU, nous nous réservons le droit de suspendre ou supprimer votre compte.",
                ),
                const SizedBox(height: 24),

                /// 6. Modifications
                _buildSectionTitle('6. Modifications'),
                const SizedBox(height: 8),
                _buildParagraph(
                  "Nous pouvons modifier à tout moment la présente politique. Vous serez informé via l’application ou par e-mail en cas de changements majeurs.",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

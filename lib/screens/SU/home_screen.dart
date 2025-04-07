import 'dart:async';
import 'package:flutter/material.dart';
import 'publication_card.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final GlobalKey _menuKey = GlobalKey();
  late Timer _timer;
  double _imageOpacity = 0.0;
  bool _showWelcome = false;
  bool _showThanks = false;

  final Color primaryColor = const Color(0xFF00796B);

  @override
  void initState() {
    super.initState();
    _startAutoSlide();

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _imageOpacity = 1.0;
      });
    });

    Future.delayed(const Duration(milliseconds: 2300), () {
      setState(() {
        _showWelcome = true;
      });

      Future.delayed(const Duration(milliseconds: 1500), () {
        setState(() {
          _showThanks = true;
        });
      });
    });
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 9), (timer) {
      if (_pageController.hasClients) {
        int nextPage = _currentPage + 1;
        if (nextPage > 4) nextPage = 0;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // Updated function to open the menu on the right side.
  void _openMenu(BuildContext context) {
    final RenderBox button = _menuKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset buttonPosition = button.localToGlobal(Offset.zero, ancestor: overlay);
    final double overlayWidth = overlay.size.width;
    // Calculate left so that the menu appears anchored to the right.
    final double left = overlayWidth - button.size.width - 16.0; // 16 px margin from right edge

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        left,
        buttonPosition.dy + button.size.height,
        16.0,
        0,
      ),
      items: [
        _buildMenuItem(Icons.article, 'My Announcements'),
        _buildMenuItem(Icons.history, 'History'),
        _buildMenuItem(Icons.notifications, 'Notifications'),
      ],
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFE0F2F1),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add your action for "+" button
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 80),
          children: [
            // ─── Title Bar (VETONCALL) with Menu Button ──────────────────────────
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: primaryColor, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                key: _menuKey, // Attach the key here for menu positioning.
                children: [
                  Expanded(
                    child: Text(
                      "VETONCALL",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: screenWidth > 600 ? 32 : 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _openMenu(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          )
                        ],
                      ),
                      child: Icon(Icons.menu, color: primaryColor),
                    ),
                  ),
                ],
              ),
            ),
            // ─── Image Box with Welcome Text and Animated Thanks Message ─────────────
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: primaryColor, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  Transform.translate(
                    offset: const Offset(-60, 16),
                    child: AnimatedOpacity(
                      opacity: _imageOpacity,
                      duration: const Duration(seconds: 2),
                      curve: Curves.easeInOut,
                      child: Image.asset(
                        'assets/images/welcome.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  if (_showWelcome)
                    const Positioned(
                      top: 0,
                      left: 0,
                      child: WelcomeTextAnimator(text: "Hi there !"),
                    ),
                  if (_showThanks)
                    Positioned(
                      top: screenWidth > 600 ? 50 : 140,
                      left: screenWidth > 600 ? 500 : null,
                      right: screenWidth > 600 ? null : 0,
                      child: screenWidth > 600
                          ? SizedBox(
                              width: 700,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Transform.translate(
                                    offset: const Offset(-20, 0),
                                    child: WelcomeTextAnimator(
                                      text: "Thanks for joining",
                                      fontSize: 70,
                                      delay: Duration(milliseconds: 0),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Transform.translate(
                                    offset: const Offset(70, 0),
                                    child: WelcomeTextAnimator(
                                      text: "Your pet's health",
                                      fontSize: 40,
                                      delay: Duration(milliseconds: 2000),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Transform.translate(
                                    offset: const Offset(140, 0),
                                    child: WelcomeTextAnimator(
                                      text: "is our propriety",
                                      fontSize: 40,
                                      delay: Duration(milliseconds: 4000),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(
                              width: 160,
                              child: WelcomeTextAnimator(
                                text: "Thanks for joining! Your pet’s health is our top priority",
                                fontSize: 14,
                                textAlign: TextAlign.center,
                              ),
                            ),
                    ),
                ],
              ),
            ),
            // ─── Slider ──────────────────────────────────────────────────────────────
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: primaryColor, width: 2),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: 5,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/slide_$index.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black87,
                                Colors.black54,
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                "Slide ${index + 1}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black45,
                                      offset: Offset(1, 1),
                                      blurRadius: 2,
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
                  Positioned(
                    left: 8,
                    top: 80,
                    child: _navButton(Icons.chevron_left, () {
                      if (_currentPage > 0) {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    }),
                  ),
                  Positioned(
                    right: 8,
                    top: 80,
                    child: _navButton(Icons.chevron_right, () {
                      if (_currentPage < 4) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),
            // ─── Publication Cards ──────────────────────────────────────────────────
            PublicationCard(
              username: "Dr. Emily",
              content: "Don’t forget to vaccinate your pets this season!",
              imageUrl: 'assets/images/welcome.png',
            ),
            PublicationCard(
              username: "Vet Clinic",
              content: "New pet grooming services now available 🐾",
              imageUrl: 'assets/images/person.png',
            ),
            PublicationCard(
              username: "Pet Rescue Org",
              content: "Adopt, don’t shop! 🐶❤️",
              imageUrl: 'assets/images/doctor.png',
            ),
          ],
        ),
      ),
    );
  }

  Widget _navButton(IconData icon, VoidCallback onPressed) {
    return Material(
      color: primaryColor.withOpacity(0.9),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(25),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  PopupMenuItem _buildMenuItem(IconData icon, String title) {
    return PopupMenuItem(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFE0F2F1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: primaryColor),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Reusable Welcome Text Animation Widget ───────────────────────────────
class WelcomeTextAnimator extends StatefulWidget {
  final String text;
  final double fontSize;
  final Duration delay;
  final TextAlign textAlign;

  const WelcomeTextAnimator({
    super.key,
    required this.text,
    this.fontSize = 24,
    this.delay = Duration.zero,
    this.textAlign = TextAlign.start,
  });

  @override
  State<WelcomeTextAnimator> createState() => _WelcomeTextAnimatorState();
}

class _WelcomeTextAnimatorState extends State<WelcomeTextAnimator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _charCount;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _charCount = StepTween(begin: 0, end: widget.text.length).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addListener(() {
        setState(() {});
      });

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text.substring(0, _charCount.value),
      textAlign: widget.textAlign,
      style: TextStyle(
        fontSize: widget.fontSize,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF00796B),
        shadows: const [
          Shadow(
            offset: Offset(1, 1),
            blurRadius: 2,
            color: Colors.black26,
          )
        ],
      ),
    );
  }
}

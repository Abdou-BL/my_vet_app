import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

// استيراد الشاشات
import 'SU/home_screen.dart';

import 'SU/rdv_screen.dart';
import 'SU/user_screen.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  _DoctorHomeScreenState createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isBarVisible = true;
  Timer? _hideTimer;
  bool _isTransitioning = false;
  late PageController _pageController;

  final List<Widget> _screens = [
    const AnnouncementScreen(),
    RDVScreen(),
    UserScreen(),
  ];

  final List<NavItem> _items = [
    NavItem(icon: "assets/icons/home.svg", label: 'Home'),
    NavItem(icon: "assets/icons/ai.svg", label: 'AI'),
    NavItem(icon: "assets/icons/rdv.svg", label: 'RDV'),
    NavItem(icon: "assets/icons/user.svg", label: 'Profile'),
  ];

  @override
  void initState() {
    super.initState();
    _isBarVisible = true;
    _pageController = PageController(
      initialPage: _selectedIndex,
      viewportFraction: 1.0,
      keepPage: true,
    );
    _startHideTimer();
    _precacheIcons();
    _precachePages();
  }

  void _precacheIcons() async {
    for (var item in _items) {
      final loader = SvgAssetLoader(item.icon);
      await svg.cache.putIfAbsent(
        loader.cacheKey(null),
        () => loader.loadBytes(null),
      );
    }
  }

  void _precachePages() {
    // Precaching all pages
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var i = 0; i < _screens.length; i++) {
        _pageController.position.correctPixels(i.toDouble());
      }
      _pageController.position.correctPixels(_selectedIndex.toDouble());
    });
  }

  void _onItemTapped(int index) {
    if (_isTransitioning || _selectedIndex == index) return;

    setState(() {
      _isTransitioning = true;
      _selectedIndex = index;
      if (!_isPhone(context)) _isBarVisible = true;
    });

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutQuart,
    ).then((_) {
      if (mounted) {
        setState(() => _isTransitioning = false);
      }
    });

    if (!_isPhone(context)) {
      _hideTimer?.cancel();
      _startHideTimer();
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && !_isTransitioning) {
        setState(() => _isBarVisible = false);
      }
    });
  }

  void _resetHideTimer() {
    if (mounted) {
      setState(() => _isBarVisible = true);
    }
    _startHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  bool _isPhone(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  @override
  Widget build(BuildContext context) {
    final bool isPhone = _isPhone(context);
    final double navBarWidth = isPhone ? 0 : MediaQuery.of(context).size.width * 0.8;
    final double itemWidth = navBarWidth / _items.length;
    final double navBarHeight = 70;
    final double iconSize = 22;
    final double labelFontSize = 11;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          // Main content with swipe support
          PageView(
            controller: _pageController,
            physics: isPhone 
                ? const ClampingScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() => _selectedIndex = index);
            },
            children: _screens.map((screen) {
              return KeepAliveWrapper(
                child: screen,
              );
            }).toList(),
          ),

          // Navigation Bar (only for non-phone devices)
          if (!isPhone)
            Positioned(
              bottom: 25,
              left: (MediaQuery.of(context).size.width - navBarWidth) / 2,
              child: MouseRegion(
                onEnter: (_) => _resetHideTimer(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: navBarHeight,
                  transform: Matrix4.translationValues(
                      0, _isBarVisible ? 0 : 100, 0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 14, 194, 35),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Animated background for selected item
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.elasticOut,
                        left: (_selectedIndex * itemWidth) + 10,
                        child: Container(
                          width: itemWidth - 20,
                          height: 45,
                          margin: const EdgeInsets.symmetric(vertical: 11),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 3),)
                            ],
                          ),
                        ),
                      ),

                      // Icons and labels
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(_items.length, (index) {
                            return InkWell(
                              onTap: () => _onItemTapped(index),
                              borderRadius: BorderRadius.circular(20),
                              splashColor: Colors.white.withOpacity(0.2),
                              child: SizedBox(
                                width: itemWidth,
                                height: navBarHeight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      _items[index].icon,
                                      width: iconSize,
                                      height: iconSize,
                                      colorFilter: ColorFilter.mode(
                                        _selectedIndex == index
                                            ? const Color.fromARGB(
                                                255, 13, 173, 40)
                                            : Colors.white.withOpacity(0.8),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    AnimatedOpacity(
                                      duration:
                                          const Duration(milliseconds: 400),
                                      opacity:
                                          _selectedIndex == index ? 1.0 : 0.0,
                                      child: AnimatedSlide(
                                        duration:
                                            const Duration(milliseconds: 400),
                                        offset: _selectedIndex == index
                                            ? Offset.zero
                                            : const Offset(1, 0),
                                        child: Text(
                                          _items[index].label,
                                          style: TextStyle(
                                            color: _selectedIndex == index
                                                ? const Color.fromARGB(
                                                    255, 13, 173, 40)
                                                : Colors.white
                                                    .withOpacity(0.8),
                                            fontSize: labelFontSize,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Swipe detector area for non-phone to show nav bar
          if (!isPhone && !_isBarVisible)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 100,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.primaryDelta! < -5) _resetHideTimer();
                },
                child: MouseRegion(
                  onHover: (_) => _resetHideTimer(),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const KeepAliveWrapper({Key? key, required this.child}) : super(key: key);

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}

class NavItem {
  final String icon;
  final String label;

  NavItem({required this.icon, required this.label});
}

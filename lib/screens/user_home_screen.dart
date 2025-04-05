import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

// استيراد الشاشات
import 'SU/home_screen.dart';
import 'SU/ai_screen.dart';
import 'SU/map_screen.dart';
import 'SU/user_screen.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  int _selectedIndex = 0;
  bool _isBarVisible = true;
  Timer? _hideTimer;

  final List<Widget> _screens = [
    AnnouncementScreen(),
    AIScreen(),
    MapScreen(),
    UserScreen(),
  ];

  final List<NavItem> _items = [
    NavItem(icon: "assets/icons/home.svg", label: 'Home'),
    NavItem(icon: "assets/icons/ai.svg", label: 'AI'),
    NavItem(icon: "assets/icons/map.svg", label: 'Map'),
    NavItem(icon: "assets/icons/user.svg", label: 'Profile'),
  ];

  @override
  void initState() {
    super.initState();
    _isBarVisible = true;
    Future.delayed(Duration(seconds: 5), () => _startHideTimer());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _resetHideTimer();
    });
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(Duration(seconds: 3), () {
      setState(() {
        _isBarVisible = false;
      });
    });
  }

  void _resetHideTimer() {
    setState(() {
      _isBarVisible = true;
    });
    _startHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double navBarWidth = MediaQuery.of(context).size.width * 0.8;
    double itemWidth = navBarWidth / _items.length;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.primaryDelta! < -10) {
            setState(() {
              _isBarVisible = true;
            });
            _resetHideTimer();
          }
        },
        child: Stack(
          children: [
            _screens[_selectedIndex],

            // شريط التنقل الجديد
            Positioned(
              bottom: 25,
              left: (MediaQuery.of(context).size.width - navBarWidth) / 2,
              child: MouseRegion(
                onEnter: (event) {
                  setState(() {
                    _isBarVisible = true;
                  });
                  _resetHideTimer();
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  height: 70,
                  transform: Matrix4.translationValues(0, _isBarVisible ? 0 : 100, 0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 14, 194, 35),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // الخلفية المتحركة للعناصر
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 800),
                        curve: Curves.elasticOut,
                        left: (_selectedIndex * itemWidth) + 10,
                        child: Container(
                          width: itemWidth - 20,
                          height: 45,
                          margin: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // الأيقونات مع زيادة مساحة النقر
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
                                height: 70, // تكبير مساحة النقر
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      _items[index].icon,
                                      width: 22,
                                      height: 22,
                                      colorFilter: ColorFilter.mode(
                                        _selectedIndex == index
                                            ? Color.fromARGB(255, 13, 173, 40)
                                            : Colors.white.withOpacity(0.8),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    AnimatedOpacity(
                                      duration: Duration(milliseconds: 400),
                                      opacity: _selectedIndex == index ? 1.0 : 0.0,
                                      child: AnimatedSlide(
                                        duration: Duration(milliseconds: 400),
                                        offset: _selectedIndex == index
                                            ? Offset.zero
                                            : Offset(1, 0),
                                        child: Text(
                                          _items[index].label,
                                          style: TextStyle(
                                            color: _selectedIndex == index
                                             ? Color.fromARGB(255, 13, 173, 40)
                                             : Colors.white.withOpacity(0.8),
                                            fontSize: 11,
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
          ],
        ),
      ),
    );
  }
}

class NavItem {
  final String icon;
  final String label;

  NavItem({required this.icon, required this.label});
}

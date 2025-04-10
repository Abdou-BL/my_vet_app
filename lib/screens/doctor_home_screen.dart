import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/nav_bar.dart';

// استيراد الشاشات
import 'SU/home_screen.dart';
import 'SU/ai_screen.dart';
import 'SU/rdv_screen.dart';
import 'SU/user_screen.dart';
 

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  _DoctorHomeScreenState createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isTransitioning = false;
  late PageController _pageController;

  final List<Widget> _screens = [
    AnnouncementScreen(isDoctor: true), // تمرير true للطبيب
    AIScreen(),
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
    _pageController = PageController(
      initialPage: _selectedIndex,
      viewportFraction: 1.0,
      keepPage: true,
    );
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
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double navBarWidth = MediaQuery.of(context).size.width;
    final double navBarHeight = 70;
    final bool isPhone = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: isPhone ? navBarHeight - 15 : navBarHeight,
            ),
            child: PageView(
              controller: _pageController,
              physics: const ClampingScrollPhysics(),
              onPageChanged: (index) {
                setState(() => _selectedIndex = index);
              },
              children: _screens.map((screen) {
                return KeepAliveWrapper(child: screen);
              }).toList(),
            ),
          ),
          CustomNavBar(
            selectedIndex: _selectedIndex,
            items: _items,
            onItemTapped: _onItemTapped,
            navBarWidth: navBarWidth,
            navBarHeight: navBarHeight,
          ),
        ],
      ),
    );
  }
}

class KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const KeepAliveWrapper({super.key, required this.child});

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

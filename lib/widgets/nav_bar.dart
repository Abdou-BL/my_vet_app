import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'colors.dart';
class NavItem {
  final String icon;
  final String label;

  NavItem({required this.icon, required this.label});
}

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final List<NavItem> items;
  final Function(int) onItemTapped;
  final double navBarWidth;
  final double navBarHeight;
  final double iconSize;
  final double labelFontSize;

  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.onItemTapped,
    required this.navBarWidth,
    this.navBarHeight = 60,
    this.iconSize = 22,
    this.labelFontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if we're on a phone (narrow screen)
    final bool isPhone = MediaQuery.of(context).size.width < 600;

    // Adjust values based on device type
    final double effectiveNavBarHeight = isPhone ? navBarHeight * 0.8 : navBarHeight;
    final double effectiveIconSize = isPhone ? iconSize * 0.8 : iconSize;
    final double effectiveLabelFontSize = isPhone ? labelFontSize * 0.8 : labelFontSize;
    final double itemWidth = navBarWidth / items.length;

    return Positioned(
      // Nearly flush with the bottom edge
      bottom: -1,
      left: (MediaQuery.of(context).size.width - navBarWidth) / 2,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 0),
        height: effectiveNavBarHeight,
        width: navBarWidth,
        decoration: BoxDecoration(
          color: AppColors.customColor1,
          borderRadius: BorderRadius.circular(25), // refined radius
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
              left: (selectedIndex * itemWidth) + 10,
              child: Container(
                width: itemWidth - 20,
                height: effectiveNavBarHeight * 0.6,
                margin: EdgeInsets.symmetric(vertical: effectiveNavBarHeight * 0.2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
              ),
            ),
            // Icons and labels
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(items.length, (index) {
                  return InkWell(
                    onTap: () => onItemTapped(index),
                    borderRadius: BorderRadius.circular(20),
                    splashColor: Colors.white.withOpacity(0.2),
                    child: SizedBox(
                      width: itemWidth,
                      height: effectiveNavBarHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            items[index].icon,
                            width: effectiveIconSize,
                            height: effectiveIconSize,
                            colorFilter: ColorFilter.mode(
                              selectedIndex == index
                                  ? AppColors.primaryColor
                                  : Colors.white.withOpacity(0.8),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 6),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 400),
                            opacity: selectedIndex == index ? 1.0 : 0.0,
                            child: AnimatedSlide(
                              duration: const Duration(milliseconds: 400),
                              offset: selectedIndex == index
                                  ? Offset.zero
                                  : const Offset(1, 0),
                              child: Text(
                                items[index].label,
                                style: TextStyle(
                                  color: selectedIndex == index
                                      ? AppColors.primaryColor
                                      : Colors.white.withOpacity(0.8),
                                  fontSize: effectiveLabelFontSize,
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
    );
  }
}

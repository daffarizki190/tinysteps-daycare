import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Custom Bottom Navigation Bar untuk HomePage.
///
/// [selectedIndex]   : tab yang sedang aktif
/// [onTabSelected]   : callback ketika tab ditekan
class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  // Daftar item tab
  static const List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.home_rounded, 'label': 'Home'},
    {'icon': Icons.analytics_rounded, 'label': 'Tracker'},
    {'icon': Icons.camera_alt_rounded, 'label': 'Photos'},
    {'icon': Icons.chat_bubble_outline_rounded, 'label': 'Messages'},
    {'icon': Icons.person_outline_rounded, 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(
              _navItems.length,
              (index) => _NavBarItem(
                icon: _navItems[index]['icon'] as IconData,
                label: _navItems[index]['label'] as String,
                isSelected: selectedIndex == index,
                onTap: () => onTabSelected(index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Private: satu item di nav bar ──
class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const Color activeColor = AppColors.primaryGreenDark;
    const Color inactiveColor = AppColors.textHint;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon dengan background pill jika aktif
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.bounceOut,
              padding: EdgeInsets.all(isSelected ? 8 : 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryGreenLight
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: isSelected ? 22 : 20,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
            const SizedBox(height: 2),
            // Label
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? activeColor : inactiveColor,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

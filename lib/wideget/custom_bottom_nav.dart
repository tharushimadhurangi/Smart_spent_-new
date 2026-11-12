
import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  // Dark theme colors
  static const Color darkNavy = Color(0xFF101D35);
  static const Color darkSelectedBg = Color(0xFFD9B8FF);
  static const Color darkPurple = Color(0xFF702BFF);
  static const Color darkInactive = Color(0xFFB9C9E8);

  // Light theme colors
  static const Color lightBackground = Colors.white;
  static const Color lightSelectedBg = Color(0xFFEDE3FF);
  static const Color lightPurple = Color(0xFF702BFF);
  static const Color lightInactive = Color(0xFF8993A8);

  static const Color borderColor = Color(0xFF6550A5);

  static const List<IconData> icons = [
    Icons.home_rounded,
    Icons.bar_chart_rounded,
    Icons.remove_circle_outline_rounded,
    Icons.receipt_long_rounded,
    Icons.track_changes_rounded,
    Icons.verified_user_outlined,
  ];

  static const List<String> labels = [
    'Dashboard',
    'Income',
    'Expense',
    'Bills',
    'Goals',
    'Warranty',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final Color navColor =
        isDark ? darkNavy : lightBackground;

    final Color selectedBg =
        isDark ? darkSelectedBg : lightSelectedBg;

    final Color activeColor =
        isDark ? darkPurple : lightPurple;

    final Color inactiveColor =
        isDark ? darkInactive : lightInactive;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 5, 10, 12),
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: navColor,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isDark
                ? borderColor
                : const Color(0xFFE0D5F5),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: isDark ? 0.15 : 0.06,
              ),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: List.generate(labels.length, (index) {
            final isSelected = selectedIndex == index;

            return Expanded(
              flex: isSelected ? 2 : 1,
              child: GestureDetector(
                onTap: () => onItemSelected(index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? selectedBg
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(45),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icons[index],
                        size: 25,
                        color: isSelected
                            ? activeColor
                            : inactiveColor,
                      ),

                      const SizedBox(height: 5),

                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          labels[index],
                          style: TextStyle(
                            color: isSelected
                                ? activeColor
                                : inactiveColor,
                            fontSize: 11,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 5),

                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: 4,
                        width: isSelected ? 35 : 0,
                        decoration: BoxDecoration(
                          color: const Color(0xFFB52CFA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

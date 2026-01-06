import 'package:flutter/material.dart';

Widget buildBottomBar({
  required int currentIndex,
  required ValueChanged<int> onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: Row(
      children: [
        _buildNavItem(
          index: 0,
          text: 'RGB灯',
          normalIcon: 'assets/icons/new_Halo_up.png',
          selectedIcon: 'assets/icons/new_Halo_d_5.png',
          currentIndex: currentIndex,
          onTap: onChanged,
        ),
        const SizedBox(width: 8), //横向间隔
        _buildNavItem(
          index: 1,
          text: '柴暖',
          normalIcon: 'assets/icons/new_heater_up_5.png',
          selectedIcon: 'assets/icons/new_heater_d_5.png',
          currentIndex: currentIndex,
          onTap: onChanged,
        ),
        const SizedBox(width: 8),
        _buildNavItem(
          index: 2,
          text: '灯光',
          normalIcon: 'assets/icons/new_Light_up.png',
          selectedIcon: 'assets/icons/new_Light_d_5.png',
          currentIndex: currentIndex,
          onTap: onChanged,
        ),
        const SizedBox(width: 8),
        _buildNavItem(
          index: 3,
          text: '设置',
          normalIcon: 'assets/icons/new_Setup_up.png',
          selectedIcon: 'assets/icons/new_Setup_d__5.png',
          currentIndex: currentIndex,
          onTap: onChanged,
        ),
      ],
    ),
  );
}

Widget _buildNavItem({
  required int index,
  required int currentIndex,
  required String text,
  required String normalIcon,
  required String selectedIcon,
  required ValueChanged<int> onTap,
}) {
  final bool selected = currentIndex == index;

  return Expanded(
    child: GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: selected
              ? const Color.fromARGB(255, 0, 0, 0)
              : const Color.fromARGB(255, 10, 10, 10),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              selected ? selectedIcon : normalIcon,
              width: 134,
              height: 86,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 6),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

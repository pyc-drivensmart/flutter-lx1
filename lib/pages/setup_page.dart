import 'package:flutter/material.dart';
import 'dart:ui'; // ImageFilter.blur

class SetupItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  SetupItem({required this.title, required this.icon, required this.onTap});
}

class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    //  在这里定义 items
    final List<SetupItem> items = [
      SetupItem(
        title: '网络设置',
        icon: Icons.wifi,
        onTap: () => debugPrint('网络设置'),
      ),
      SetupItem(
        title: '设备管理',
        icon: Icons.devices,
        onTap: () => debugPrint('设备管理'),
      ),
      SetupItem(
        title: '系统参数',
        icon: Icons.settings,
        onTap: () => debugPrint('系统参数'),
      ),
      SetupItem(
        title: '显示设置',
        icon: Icons.display_settings,
        onTap: () => debugPrint('显示设置'),
      ),
      SetupItem(
        title: '声音设置',
        icon: Icons.volume_up,
        onTap: () => debugPrint('声音设置'),
      ),
      SetupItem(
        title: '关于设备',
        icon: Icons.info,
        onTap: () => debugPrint('关于设备'),
      ),
    ];

    return Scaffold(
      // 设置页面背景图片
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icons/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return _buildSetupItem(items[index]);
          },
        ),
      ),
    );
  }
}

Widget _buildSetupItem(SetupItem item) {
  return InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: item.onTap,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10, // 模糊强度
          sigmaY: 10,
        ),
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            // ✅ 非透明色，而是“玻璃遮罩色”
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.25), // 玻璃边缘高光
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(item.icon, size: 28, color: Colors.white),
              const SizedBox(width: 16),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

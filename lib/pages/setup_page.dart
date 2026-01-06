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
        onTap: () {
          debugPrint('网络设置');

          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NetworkSetupPage()),
          );
        },
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

class NetworkSetupPage extends StatelessWidget {
  const NetworkSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icons/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // ✅ 顶部返回栏
            const GlassBackBar(title: '网络设置'),

            // 内容区
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  _buildSubItem('WiFi', Icons.wifi),
                  _buildSubItem('以太网', Icons.settings_ethernet),
                  _buildSubItem('热点', Icons.wifi_tethering),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ 放在类里面
  Widget _buildSubItem(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24),
            ),
            child: ListTile(
              leading: Icon(icon, color: Colors.white),
              title: Text(title, style: const TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            ),
          ),
        ),
      ),
    );
  }
}

class GlassBackBar extends StatelessWidget {
  final String title;

  const GlassBackBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          // ✅ 整条栏都可点
          onTap: () => Navigator.pop(context),
          child: Container(
            height: 64, // 和选项栏同级手感
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              border: const Border(bottom: BorderSide(color: Colors.white24)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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
}

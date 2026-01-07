import 'dart:ui';
import 'package:flutter/material.dart';

bool isOn = false; // 开关状态

class HeaterPage extends StatelessWidget {
  const HeaterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 页面背景图
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icons/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // ================= 左侧毛玻璃（比例 2） =================
            Expanded(
              flex: 2,
              child: _glassContainer(
                child: const Center(child: MainDialControl()),
              ),
            ),

            const SizedBox(width: 16),

            // ================= 右侧毛玻璃（比例 1） =================
            Expanded(
              flex: 1,
              child: _glassContainer(
                child: const Center(
                  child: Text(
                    '状态 / 参数',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 通用毛玻璃容器（复用）
  Widget _glassContainer({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12), // 玻璃遮罩色
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.25), // 高光边框
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class MainDialControl extends StatefulWidget {
  const MainDialControl({super.key});

  @override
  State<MainDialControl> createState() => _MainDialControlState();
}

class _MainDialControlState extends State<MainDialControl> {
  int level = 3; // 当前档位 1~6
  bool isOn = false; // 开关状态

  void _increase() {
    if (!isOn) return; // 关机时不允许调档
    setState(() {
      if (level < 6) level++;
    });
  }

  void _decrease() {
    if (!isOn) return;
    setState(() {
      if (level > 1) level--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 700,
      height: 400,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ===== 外围扇形档位 =====
          CustomPaint(
            size: const Size(260, 260),
            painter: DialPainter(activeLevel: level),
          ),

          // ===== 左侧减 =====
          Positioned(left: 60, child: _circleButton(Icons.remove, _decrease)),

          // ===== 右侧加 =====
          Positioned(right: 60, child: _circleButton(Icons.add, _increase)),

          // ===== 中心开关 =====
          GestureDetector(
            onTap: () {
              setState(() {
                isOn = !isOn; // 切换开关
              });
              debugPrint('主开关点击: ${isOn ? "开" : "关"}');
            },
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOn
                    ? const Color.fromARGB(255, 55, 113, 240).withOpacity(0.8)
                    : Colors.white.withOpacity(0.18), // 开关颜色区分
                border: Border.all(color: Colors.white30),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.power_settings_new, // 开关图标
                size: 48,
                color: isOn ? Colors.white : Colors.grey[400],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.15),
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

class DialPainter extends CustomPainter {
  final int activeLevel;

  DialPainter({required this.activeLevel});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    const int total = 6;

    // final double sweep = 2 * 3.1415926 / total;
    // final double startBase = -3.1415926 / 2; // 从正上方开始

    const double totalAngle = 310 * 3.1415926 / 180; // ✅ 只画 310°
    final double sweep = totalAngle / total;
    final double startBase = -3.1415926 / 2 - totalAngle / 2;

    for (int i = 0; i < total; i++) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18
        ..color = i < activeLevel
            ? const Color.fromARGB(255, 236, 90, 22).withOpacity(0.9)
            : Colors.white24;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 20),
        startBase + i * sweep,
        sweep - 0.05,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant DialPainter oldDelegate) {
    return oldDelegate.activeLevel != activeLevel;
  }
}

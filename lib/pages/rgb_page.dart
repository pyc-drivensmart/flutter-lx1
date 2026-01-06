import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui';

class RgbPage extends StatefulWidget {
  const RgbPage({super.key});

  @override
  State<RgbPage> createState() => _RgbPageState();
}

class _RgbPageState extends State<RgbPage> {
  Offset? touchPoint;
  Color currentColor = Colors.white;

  static const double pickerSize = 260;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icons/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ 毛玻璃容器开始
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 1, // 横向模糊强度
                    sigmaY: 1, // 纵向模糊强度
                  ),
                  child: Container(
                    width: pickerSize + 100,
                    height: pickerSize + 100,
                    padding: const EdgeInsets.all(50),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15), // 半透明叠加色
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: GestureDetector(
                      onPanDown: _handlePanDown,
                      onPanUpdate: _handlePanUpdate,
                      child: CustomPaint(
                        size: const Size(pickerSize, pickerSize),
                        painter: _HsvColorPainter(
                          touchPoint: touchPoint,
                          currentColor: currentColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //  毛玻璃容器结束
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// 手指按下
  void _handlePanDown(DragDownDetails details) {
    _updateColor(details.localPosition);
  }

  /// 手指拖动
  void _handlePanUpdate(DragUpdateDetails details) {
    _updateColor(details.localPosition);
  }

  /// 根据触控位置计算 HSV 颜色
  void _updateColor(Offset position) {
    final center = const Offset(pickerSize / 2, pickerSize / 2);

    double dx = position.dx - center.dx;
    double dy = position.dy - center.dy;

    final double distance = sqrt(dx * dx + dy * dy);
    final double radius = pickerSize / 2;

    // ---------- 核心修复：拖出圆外也继续 ----------
    if (distance > radius) {
      // 归一化方向向量
      final double scale = radius / distance;
      dx *= scale;
      dy *= scale;
    }

    final double clampedDistance = sqrt(dx * dx + dy * dy);

    final double saturation = (clampedDistance / radius).clamp(0.0, 1.0);

    final double hue = (atan2(dy, dx) * 180 / pi + 360) % 360;

    setState(() {
      touchPoint = Offset(center.dx + dx, center.dy + dy);
      currentColor = HSVColor.fromAHSV(1, hue, saturation, 1).toColor();
    });
  }

  String _colorToHex(Color c) {
    return '#${c.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }
}

class HsvColorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..shader = SweepGradient(
        colors: const [
          Colors.red,
          Colors.yellow,
          Colors.green,
          Colors.cyan,
          Colors.blue,
          Colors.purple,
          Colors.red,
        ],
      ).createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HsvColorPainter extends CustomPainter {
  final Offset? touchPoint;
  final Color currentColor;

  _HsvColorPainter({required this.touchPoint, required this.currentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    // 绘制 HSV 色盘
    for (double angle = 0; angle < 360; angle += 1) {
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [Colors.white, HSVColor.fromAHSV(1, angle, 1, 1).toColor()],
        ).createShader(Rect.fromCircle(center: center, radius: radius));

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        angle * pi / 180,
        pi / 180,
        true,
        paint,
      );
    }

    // 取色指示小球
    // 取色指示小球（填充当前颜色）
    if (touchPoint != null) {
      // 内部填充
      canvas.drawCircle(
        touchPoint!,
        18,
        Paint()
          ..color = currentColor
          ..style = PaintingStyle.fill,
      );

      // 外部白色描边
      canvas.drawCircle(
        touchPoint!,
        18,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HsvColorPainter oldDelegate) {
    return oldDelegate.touchPoint != touchPoint;
  }
}

import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class AcPage extends StatefulWidget {
  const AcPage({super.key});

  @override
  State<AcPage> createState() => _AcPageState();
}

class _AcPageState extends State<AcPage> {
  double tempPercent = 0.5; // 0~1，表示百分比

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
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 左侧毛玻璃 + 圆形百分比控件
            Expanded(
              flex: 2,
              child: _glassContainer(
                child: Center(
                  child: TemperatureDial(
                    value: tempPercent,
                    onChanged: (v) {
                      setState(() {
                        tempPercent = v;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // 右侧状态区域
            Expanded(
              flex: 3,
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

  Widget _glassContainer({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}

class TemperatureDial extends StatefulWidget {
  final double value; // 0~1 百分比
  final ValueChanged<double> onChanged;

  const TemperatureDial({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<TemperatureDial> createState() => _TemperatureDialState();
}

class _TemperatureDialState extends State<TemperatureDial> {
  // 用户拖动更新百分比
  void _updateValue(Offset localPos, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final dx = localPos.dx - center.dx;
    final dy = localPos.dy - center.dy;

    double angle = atan2(dy, dx); // -π ~ π

    const totalAngle = 310 * pi / 180; // 310°
    final startAngle = -pi / 2 - totalAngle / 2; // 左端

    // 标准化角度到 0~2π
    double normalizedAngle = angle;
    if (normalizedAngle < 0) normalizedAngle += 2 * pi;

    double normalizedStart = startAngle;
    if (normalizedStart < 0) normalizedStart += 2 * pi;

    // 计算相对角度差
    double relativeAngle = normalizedAngle - normalizedStart;
    if (relativeAngle < 0) relativeAngle += 2 * pi;

    // 映射到百分比
    double percent = relativeAngle / totalAngle;

    // 限制在 0~1 范围
    percent = percent.clamp(0.0, 1.0);

    widget.onChanged(percent);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = min(constraints.maxWidth, constraints.maxHeight) * 0.8;

        return GestureDetector(
          onPanUpdate: (details) =>
              _updateValue(details.localPosition, Size(size, size)),
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // ===== 310° 连续环 =====
                CustomPaint(
                  size: Size(size, size),
                  painter: ContinuousDialPainter(percent: widget.value),
                ),
                // 中心圆显示百分比
                Container(
                  width: size * 0.6,
                  height: size * 0.6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.18),
                    border: Border.all(color: Colors.white30),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${(widget.value * 100).round()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ContinuousDialPainter extends CustomPainter {
  final double percent;

  ContinuousDialPainter({required this.percent});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    const double totalAngle = 310 * pi / 180; // 310° 可视环
    final startAngle = -pi / 2 - totalAngle / 2; // 左偏移

    // 背景环
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..color = Colors.white24
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 20),
      startAngle,
      totalAngle,
      false,
      bgPaint,
    );

    // 高亮环
    final fgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..color = const Color.fromARGB(255, 6, 42, 245).withOpacity(0.9)
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 20),
      startAngle,
      totalAngle * percent,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ContinuousDialPainter oldDelegate) {
    return oldDelegate.percent != percent;
  }
}


//蓝牙按键面板：实现1待机uA功耗，利用内部基准电压推算 VDD，节省IO检测电路，降低成本，研发过程多种解决方案对比，最终选择此方案，成本最低，性能稳定可靠，还有PVD检测，双重保险保障系统稳定运行。
//C++/C#上位机,根据协议文档编写测试工具，实现对产品的调试和测试功能，提升研发效率，缩短研发周期。
//开发5.1寸车载嵌入式屏幕，基于公司底层UI框架，完成UI界面设计和功能开发，需要实现多设备通信和数据交互，设备间状态同步
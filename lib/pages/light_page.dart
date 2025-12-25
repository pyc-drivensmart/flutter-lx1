import 'package:flutter/material.dart';

class LightPage extends StatefulWidget {
  const LightPage({super.key});

  @override
  State<LightPage> createState() => _LightPageState();
}

class _LightPageState extends State<LightPage> {
  final List<LightChannel> _lights = List.generate(6, (_) => LightChannel());

  @override
  /// 构建UI界面的方法
  ///
  /// @param context 构建上下文，提供组件树的位置信息
  /// @return 返回一个填充了内边距的GridView组件
  Widget build(BuildContext context) {
    return Container(
      // 设置页面背景图片
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/icons/background.png'), // 本地图片路径
          fit: BoxFit.cover, // 图片填充方式
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: 6,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.8,
          ),
          itemBuilder: (context, index) {
            return _buildLightItem(index);
          },
        ),
      ),
    );
  }

  Widget _buildLightItem(int index) {
    final light = _lights[index];

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        setState(() {
          light.isOn = !light.isOn;

          // 可选：关灯时 PWM 归零
          if (!light.isOn) {
            //   light.pwm = 0;
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          // 将原来的 Color.fromARGB 后面加上 .withOpacity
          // 0.0 是完全透明，1.0 是完全不透明
          color: const Color.fromARGB(255, 70, 80, 82).withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(
            //   Icons.lightbulb,
            //   size: 40,
            //   color: light.isOn ? Colors.yellow : Colors.grey,
            // ),// 图片切换逻辑
            Image.asset(
              light.isOn
                  ? 'assets/icons/light_on.png'
                  : 'assets/icons/light_off.png',
              width: 60, // 稍微调大一点
              height: 60,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            Text(
              'PWM: ${light.pwm.toInt()}%',
              style: const TextStyle(color: Colors.white),
            ),
            Slider(
              value: light.pwm,
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: light.isOn
                  ? (value) {
                      setState(() {
                        light.pwm = value;
                      });
                    }
                  : null, // 关灯时禁用
            ),
          ],
        ),
      ),
    );
  }
}

class LightChannel {
  bool isOn;
  double pwm;

  LightChannel({this.isOn = false, this.pwm = 0});
}

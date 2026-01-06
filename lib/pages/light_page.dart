import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class LightPage extends StatefulWidget {
  const LightPage({super.key});

  @override
  State<LightPage> createState() => _LightPageState();
}

class _LightPageState extends State<LightPage> {
  final logger = Logger(); //

  final List<LightChannel> _lights = List.generate(
    6,
    (index) => LightChannel(name: '灯光 ${index + 1}'),
  );
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
          logger.i('灯光 ${index + 1} 状态切换: ${light.isOn ? "开启" : "关闭"}');
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 70, 80, 82).withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // 左侧：灯光图标
            Image.asset(
              light.isOn
                  ? 'assets/icons/light_on.png'
                  : 'assets/icons/light_off.png',
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),

            // 右侧：灯名称和PWM控制
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 灯名称
                  Text(
                    light.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // PWM值显示
                  Text(
                    'PWM: ${light.pwm.toInt()}%',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),

                  // PWM滑块
                  Transform.translate(
                    offset: const Offset(-12, 0), // 向左偏移12像素
                    child: Slider(
                      value: light.pwm,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      activeColor: const Color.fromARGB(255, 47, 162, 215),
                      inactiveColor: Colors.white24,
                      onChanged: light.isOn
                          ? (value) {
                              setState(() {
                                light.pwm = value;
                                logger.i(
                                  '灯光 ${index + 1} PWM: ${light.pwm.toInt()}%',
                                );
                              });
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//结构体，保存变量
class LightChannel {
  String name;
  bool isOn;
  double pwm;

  LightChannel({required this.name, this.isOn = false, this.pwm = 0});
}

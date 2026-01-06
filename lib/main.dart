import 'package:flutter/material.dart';
import 'pages/light_page.dart';
import 'pages/rgb_page.dart';
import 'pages/setup_page.dart';
import 'pages/heater_page.dart';
import 'top.dart';
import 'bottom.dart';

//MyApp->HomePage
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  bool _wifiOn = true;
  bool _bluetoothOn = true;
  final List<Widget> _pages = const [
    RgbPage(),
    HeaterPage(),
    LightPage(),
    SetupPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 49, 58, 60),
      body: Column(
        children: [
          // ===== 顶部状态栏 =====
          TopStatusBar(
            timeText: '10:36',
            dateText: '2026-01-06',
            wifiOn: _wifiOn,
            bluetoothOn: _bluetoothOn,
            onPowerTap: () {
              // 这里可以弹确认框 / 关机逻辑
              debugPrint('Power button tapped');
            },
          ),

          // ===== 内容区 =====
          Expanded(
            child: IndexedStack(index: _currentIndex, children: _pages),
          ),

          // ===== 底部导航 =====
          buildBottomBar(
            currentIndex: _currentIndex,
            onChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }

  /// 内容区
  Widget _buildPage() {
    return Center(
      child: Text(
        '当前页面 ${_currentIndex + 1}',
        style: const TextStyle(fontSize: 28, color: Colors.white),
      ),
    );
  }
}

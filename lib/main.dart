import 'package:flutter/material.dart';
import 'pages/light_page.dart';

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

class RgbPage extends StatelessWidget {
  const RgbPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'RGB 灯页面',
        style: TextStyle(fontSize: 28, color: Colors.white),
      ),
    );
  }
}

class HeaterPage extends StatelessWidget {
  const HeaterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('柴暖页面', style: TextStyle(fontSize: 28, color: Colors.white)),
    );
  }
}

class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('设置页面', style: TextStyle(fontSize: 28, color: Colors.white)),
    );
  }
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
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
          // ===== 内容区 =====
          Expanded(
            child: IndexedStack(index: _currentIndex, children: _pages),
          ),

          // ===== 底部导航 =====
          _buildBottomBar(),
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

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _buildNavItem(
            0,
            'RGB灯',
            'assets/icons/new_Halo_up.png',
            'assets/icons/new_Halo_d_5.png',
          ),
          const SizedBox(width: 8),
          _buildNavItem(
            1,
            '柴暖',
            'assets/icons/new_heater_up_5.png',
            'assets/icons/new_heater_d_5.png',
          ),
          const SizedBox(width: 8),
          _buildNavItem(
            2,
            '灯光',
            'assets/icons/new_Light_up.png',
            'assets/icons/new_Light_d_5.png',
          ),
          const SizedBox(width: 8),
          _buildNavItem(
            3,
            '设置',
            'assets/icons/new_Setup_up.png',
            'assets/icons/new_Setup_d__5.png',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    String text,
    String normalIcon,
    String selectedIcon,
  ) {
    final bool selected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
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
}

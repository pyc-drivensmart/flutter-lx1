import 'package:flutter/material.dart'; //引入 Material Design 风格的 UI 组件库

class HeaterPage extends StatelessWidget {
  const HeaterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('柴暖 页面', style: TextStyle(fontSize: 28, color: Colors.white)),
    );
  }
}

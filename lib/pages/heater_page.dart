import 'dart:ui';
import 'package:flutter/material.dart';

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
                child: const Center(
                  child: Text(
                    '主控制区',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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

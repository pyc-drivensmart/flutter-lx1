// import 'dart:ui';
// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class TopStatusBar extends StatelessWidget {
  final String timeText;
  final String dateText;
  final bool wifiOn;
  final bool bluetoothOn;
  final VoidCallback onPowerTap;

  const TopStatusBar({
    super.key,
    required this.timeText,
    required this.dateText,
    required this.wifiOn,
    required this.bluetoothOn,
    required this.onPowerTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: const Color.fromARGB(
        10,
        0,
        0,
        0,
      ), //Color.fromARGB(A, R, G, B)A = 0 → 完全透明,A = 255 → 完全不透明

      child: Row(
        children: [
          // ===== 左侧：时间 & 日期 =====
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                timeText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                dateText,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),

          const Spacer(),

          // ===== 中间：WiFi / 蓝牙 =====
          Icon(
            wifiOn ? Icons.wifi : Icons.wifi_off,
            color: wifiOn ? Colors.white : Colors.grey,
          ),
          const SizedBox(width: 12),
          Icon(
            bluetoothOn ? Icons.bluetooth : Icons.bluetooth_disabled,
            color: bluetoothOn ? Colors.white : Colors.grey,
          ),

          const SizedBox(width: 20),

          // ===== 右侧：电源键 =====
          GestureDetector(
            onTap: onPowerTap,
            child: const Icon(
              Icons.power_settings_new,
              color: Colors.redAccent,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

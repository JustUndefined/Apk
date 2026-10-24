import 'package:flutter/material.dart';

// Toggle switch untuk setiap fitur cheat
class CheatToggle extends StatelessWidget {
  final String label;
  final String sublabel;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData icon;

  const CheatToggle({
    super.key,
    required this.label,
    required this.sublabel,
    required this.value,
    required this.onChanged,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF12121A),
        borderRadius: BorderRadius.circular(10),
        // Border hijau kalau aktif, abu kalau nonaktif
        border: Border.all(
          color: value ? const Color(0xFF00FF8844) : const Color(0xFF1A1A2E),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icon fitur
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value
                  ? const Color(0xFF00FF8820)
                  : const Color(0xFF1A1A2E),
            ),
            child: Icon(
              icon,
              size: 18,
              color: value
                  ? const Color(0xFF00FF88)
                  : const Color(0xFF333344),
            ),
          ),
          const SizedBox(width: 12),

          // Label + sublabel
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: value ? Colors.white : const Color(0xFF555566),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sublabel,
                  style: const TextStyle(
                    color: Color(0xFF444455),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Switch toggle
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF00FF88),
            activeTrackColor: const Color(0xFF00FF8830),
            inactiveThumbColor: const Color(0xFF333344),
            inactiveTrackColor: const Color(0xFF1A1A2E),
          ),
        ],
      ),
    );
  }
}

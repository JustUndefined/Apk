import 'package:flutter/material.dart';

class SensitivitySlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const SensitivitySlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  String get _label {
    if (value < 0.4) return 'Rendah';
    if (value < 0.7) return 'Sedang';
    return 'Tinggi';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF12121A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1A1A2E)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Akurasi Aim',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              Row(
                children: [
                  Text(
                    '${(value * 100).toInt()}%',
                    style: const TextStyle(
                      color: Color(0xFF00FF88),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '($_label)',
                    style: const TextStyle(
                      color: Color(0xFF444455),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF00FF88),
              inactiveTrackColor: const Color(0xFF1A1A2E),
              thumbColor: const Color(0xFF00FF88),
              overlayColor: const Color(0xFF00FF8820),
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: value,
              min: 0.1,
              max: 1.0,
              divisions: 18,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

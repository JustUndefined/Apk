import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

// OverlayApp — dipanggil oleh overlayMain() di main.dart
class OverlayApp extends StatelessWidget {
  const OverlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OverlayPanel(),
    );
  }
}

class OverlayPanel extends StatefulWidget {
  const OverlayPanel({super.key});

  @override
  State<OverlayPanel> createState() => _OverlayPanelState();
}

class _OverlayPanelState extends State<OverlayPanel> {
  bool _espOn    = true;
  bool _aimOn    = true;
  bool _expanded = true;
  double _angle  = 0;
  double _power  = 0;

  @override
  void initState() {
    super.initState();
    // Terima config dari home_screen via shareData()
    FlutterOverlayWindow.overlayListener.listen((data) {
      if (data == null || !mounted) return;
      setState(() {
        _espOn = data['esp']    ?? true;
        _aimOn = data['aimbot'] ?? true;
      });
    });
  }

  Future<void> _close() async {
    await FlutterOverlayWindow.closeOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xDD0A0A0F),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF00FF88), width: 1),
            ),
            child: _expanded ? _expandedView() : _collapsedView(),
          ),
        ),
      ),
    );
  }

  Widget _collapsedView() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8, height: 8,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF00FF88),
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          'PM',
          style: TextStyle(
            color: Color(0xFF00FF88),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _expandedView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header + close
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '⚡ POOL MASTER',
              style: TextStyle(
                color: Color(0xFF00FF88),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            GestureDetector(
              onTap: _close,
              child: const Text(
                '✕',
                style: TextStyle(color: Color(0xFF555566), fontSize: 10),
              ),
            ),
          ],
        ),
        const Divider(color: Color(0xFF1A1A2E), height: 8),

        // Info angle + power
        _InfoRow(label: 'ANGLE', value: '${_angle.toStringAsFixed(1)}°'),
        _InfoRow(label: 'POWER', value: '${_power.toStringAsFixed(0)}%'),

        const SizedBox(height: 6),

        // Toggle ESP
        _OverlayToggle(
          label: 'ESP',
          value: _espOn,
          onTap: () => setState(() => _espOn = !_espOn),
        ),

        // Toggle Aim
        _OverlayToggle(
          label: 'AIM',
          value: _aimOn,
          onTap: () => setState(() => _aimOn = !_aimOn),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF444455), fontSize: 10)),
        Text(value, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _OverlayToggle extends StatelessWidget {
  final String label;
  final bool value;
  final VoidCallback onTap;
  const _OverlayToggle({required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: value ? const Color(0xFF00FF8820) : const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value ? 'ON' : 'OFF',
              style: TextStyle(
                color: value ? const Color(0xFF00FF88) : const Color(0xFF444455),
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

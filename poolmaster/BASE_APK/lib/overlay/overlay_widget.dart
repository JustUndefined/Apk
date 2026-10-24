import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OverlayWidget extends StatefulWidget {
  const OverlayWidget({super.key});

  @override
  State<OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget> {
  bool _espEnabled    = true;
  bool _aimbotEnabled = true;
  bool _expanded      = true;

  @override
  void initState() {
    super.initState();
    // Dengarkan data yang dikirim via shareData() dari home_screen
    FlutterOverlayWindow.overlayListener.listen((data) {
      if (data != null && mounted) {
        setState(() {
          _espEnabled    = data['esp']      ?? true;
          _aimbotEnabled = data['aimbot']   ?? true;
        });
      }
    });
  }

  // Tutup overlay dari dalam panel
  Future<void> _closeOverlay() async {
    await FlutterOverlayWindow.closeOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: GestureDetector(
        onTap: () => setState(() => _expanded = !_expanded),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xEE0A0A0F),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF00FF88), width: 1),
          ),
          child: _expanded ? _buildExpanded() : _buildCollapsed(),
        ),
      ),
    );
  }

  Widget _buildCollapsed() {
    return const Text(
      'PM',
      style: TextStyle(
        color: Color(0xFF00FF88),
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildExpanded() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header + tombol close
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'POOL MASTER',
              style: TextStyle(
                color: Color(0xFF00FF88),
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _closeOverlay,
              child: const Text(
                '✕',
                style: TextStyle(
                  color: Color(0xFF555566),
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Status ESP
        _StatusRow(label: 'ESP', active: _espEnabled),
        const SizedBox(height: 4),

        // Status Aimbot
        _StatusRow(label: 'AIM', active: _aimbotEnabled),
      ],
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String label;
  final bool active;

  const _StatusRow({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? const Color(0xFF00FF88)
                : const Color(0xFFFF4455),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: active
                ? const Color(0xFF00FF88)
                : const Color(0xFF555566),
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
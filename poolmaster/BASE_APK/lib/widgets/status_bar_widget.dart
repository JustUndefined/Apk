import 'package:flutter/material.dart';
import '../core/app_state.dart';

class StatusBarWidget extends StatelessWidget {
  final ServerStatus serverStatus;
  final bool overlayGranted;
  final VoidCallback onRequestOverlay;

  const StatusBarWidget({
    super.key,
    required this.serverStatus,
    required this.overlayGranted,
    required this.onRequestOverlay,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Status server
        _Badge(
          label: 'SERVER',
          value: serverStatus == ServerStatus.online
              ? 'ONLINE'
              : serverStatus == ServerStatus.checking
                  ? 'CEK...'
                  : 'OFFLINE',
          color: serverStatus == ServerStatus.online
              ? const Color(0xFF00FF88)
              : serverStatus == ServerStatus.checking
                  ? const Color(0xFFFFAA00)
                  : const Color(0xFFFF4455),
        ),

        const SizedBox(width: 10),

        // Status overlay permission
        GestureDetector(
          onTap: overlayGranted ? null : onRequestOverlay,
          child: _Badge(
            label: 'OVERLAY',
            value: overlayGranted ? 'SIAP' : 'TAP IZINKAN',
            color: overlayGranted
                ? const Color(0xFF00C8FF)
                : const Color(0xFFFFAA00),
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _Badge({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dot indicator
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: color.withOpacity(0.6),
                  fontSize: 9,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

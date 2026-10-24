import 'package:flutter/material.dart';

class NeonButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool loading;

  const NeonButton({
    super.key,
    required this.label,
    this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: onTap != null
              ? const LinearGradient(
                  colors: [Color(0xFF00FF88), Color(0xFF00C8FF)],
                )
              : null,
          color: onTap == null ? const Color(0xFF1A1A2E) : null,
        ),
        child: Center(
          child: loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF0A0A0F),
                  ),
                )
              : Text(
                  label,
                  style: TextStyle(
                    color: onTap != null
                        ? const Color(0xFF0A0A0F)
                        : const Color(0xFF333344),
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 2,
                  ),
                ),
        ),
      ),
    );
  }
}

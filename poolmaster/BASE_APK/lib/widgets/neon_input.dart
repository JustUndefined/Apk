import 'package:flutter/material.dart';

class NeonInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscure;

  const NeonInput({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscure = false,
  });

  @override
  State<NeonInput> createState() => _NeonInputState();
}

class _NeonInputState extends State<NeonInput> {
  bool _obscure = true;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label di atas input
        Text(
          widget.label,
          style: const TextStyle(
            color: Color(0xFF444455),
            fontSize: 10,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),

        Focus(
          onFocusChange: (f) => setState(() => _focused = f),
          child: TextField(
            controller: widget.controller,
            obscureText: widget.obscure && _obscure,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(color: Color(0xFF333344), fontSize: 13),
              filled: true,
              fillColor: const Color(0xFF12121A),
              prefixIcon: Icon(
                widget.icon,
                color: _focused
                    ? const Color(0xFF00FF88)
                    : const Color(0xFF333344),
                size: 18,
              ),
              suffixIcon: widget.obscure
                  ? GestureDetector(
                      onTap: () => setState(() => _obscure = !_obscure),
                      child: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFF333344),
                        size: 18,
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF1A1A2E)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF1A1A2E)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF00FF88), width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

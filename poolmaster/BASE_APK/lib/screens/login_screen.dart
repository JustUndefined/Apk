import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_state.dart';
import '../api/api_service.dart';
import '../widgets/neon_button.dart';
import '../widgets/neon_input.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userCtrl = TextEditingController();
  final _keyCtrl  = TextEditingController();
  bool _loading   = false;
  String? _error;

  Future<void> _login() async {
    final username = _userCtrl.text.trim();
    final key      = _keyCtrl.text.trim();

    if (username.isEmpty || key.isEmpty) {
      setState(() => _error = 'Username dan license key wajib diisi');
      return;
    }

    setState(() { _loading = true; _error = null; });

    final state  = context.read<AppState>();
    final api    = ApiService(state.serverUrl);

    // Kirim request login ke API
    final result = await api.login(username, key);

    if (!mounted) return;
    setState(() => _loading = false);

    if (result['success'] == true) {
      // Simpan state login
      await state.setLoggedIn(username, key);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      setState(() => _error = result['message'] ?? 'Login gagal');
    }
  }

  @override
  void dispose() {
    _userCtrl.dispose();
    _keyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = context.watch<AppState>().serverStatus;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              // Header
              ShaderMask(
                shaderCallback: (b) => const LinearGradient(
                  colors: [Color(0xFF00FF88), Color(0xFF00C8FF)],
                ).createShader(b),
                child: const Text(
                  'POOL MASTER',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Masuk dengan license key',
                style: TextStyle(color: Color(0xFF555566), fontSize: 13),
              ),

              const SizedBox(height: 40),

              // Status server badge
              _ServerBadge(status: status),

              const SizedBox(height: 32),

              // Form input
              NeonInput(
                controller: _userCtrl,
                label: 'USERNAME',
                hint: 'Masukkan username',
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 16),

              NeonInput(
                controller: _keyCtrl,
                label: 'LICENSE KEY',
                hint: 'XXXX-XXXX-XXXX-XXXX',
                icon: Icons.vpn_key_outlined,
                obscure: true,
              ),

              // Error message
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: const TextStyle(
                    color: Color(0xFFFF4455),
                    fontSize: 12,
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Login button
              NeonButton(
                label: _loading ? 'MEMPROSES...' : 'MASUK',
                onTap: _loading ? null : _login,
                loading: _loading,
              ),

              const Spacer(),

              // Footer
              const Center(
                child: Text(
                  'Pool Master © 2024',
                  style: TextStyle(color: Color(0xFF333344), fontSize: 11),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// Badge status server kecil di bawah header
class _ServerBadge extends StatelessWidget {
  final ServerStatus status;
  const _ServerBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isOnline = status == ServerStatus.online;
    final isCheck  = status == ServerStatus.checking;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Dot indikator
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCheck
                ? const Color(0xFFFFAA00)
                : isOnline
                    ? const Color(0xFF00FF88)
                    : const Color(0xFFFF4455),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          isCheck
              ? 'Memeriksa server...'
              : isOnline
                  ? 'Server Online'
                  : 'Server Offline',
          style: TextStyle(
            color: isCheck
                ? const Color(0xFFFFAA00)
                : isOnline
                    ? const Color(0xFF00FF88)
                    : const Color(0xFFFF4455),
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

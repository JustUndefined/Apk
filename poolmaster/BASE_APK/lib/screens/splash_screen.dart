import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_state.dart';
import '../api/api_service.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  String _statusText = 'Menghubungkan ke server...';

  @override
  void initState() {
    super.initState();

    // Animasi fade + scale logo saat splash
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnim  = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeIn),
    );
    _scaleAnim = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );

    _ctrl.forward();
    _init();
  }

  Future<void> _init() async {
    final state   = context.read<AppState>();
    final api     = ApiService(state.serverUrl);

    await Future.delayed(const Duration(milliseconds: 1500));

    // Cek koneksi server
    final online = await api.checkServer();

    if (!mounted) return;

    if (online) {
      state.setServerStatus(ServerStatus.online);
      setState(() => _statusText = 'Server online ✓');
    } else {
      state.setServerStatus(ServerStatus.offline);
      setState(() => _statusText = 'SERVER OFFLINE — Mode terbatas');
    }

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    // Navigasi ke home jika sudah login, login jika belum
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => state.isLoggedIn
            ? const HomeScreen()
            : const LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo teks dengan aksen neon
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF00FF88), Color(0xFF00C8FF)],
                  ).createShader(bounds),
                  child: const Text(
                    'POOL\nMASTER',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      height: 0.95,
                      letterSpacing: 4,
                      color: Colors.white, // shader override warna
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Versi
                const Text(
                  'v1.0.0',
                  style: TextStyle(
                    color: Color(0xFF444455),
                    fontSize: 12,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 48),

                // Loading indicator minimalis
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF00FF88),
                  ),
                ),

                const SizedBox(height: 16),

                // Status teks
                Text(
                  _statusText,
                  style: const TextStyle(
                    color: Color(0xFF555566),
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

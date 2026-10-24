import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import '../core/app_state.dart';
import '../api/api_service.dart';
import '../widgets/cheat_toggle.dart';
import '../widgets/sensitivity_slider.dart';
import '../widgets/status_bar_widget.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _overlayGranted = false;

  @override
  void initState() {
    super.initState();
    _checkOverlayPermission();
  }

  // Cek permission overlay Android (wajib untuk tampil di atas game)
  Future<void> _checkOverlayPermission() async {
    final granted = await FlutterOverlayWindow.isPermissionGranted();
    setState(() => _overlayGranted = granted ?? false);
  }

  // Minta permission overlay jika belum ada
  Future<void> _requestOverlay() async {
    await FlutterOverlayWindow.requestPermission();
    await _checkOverlayPermission();
  }

  // Aktifkan overlay ESP di atas game
  Future<void> _launchOverlay(AppState state) async {
    if (!_overlayGranted) {
      _showOverlayDialog();
      return;
    }

    // Tampilkan overlay window, tunggu fully mounted
    await FlutterOverlayWindow.showOverlay(
      enableDrag: true,
      overlayTitle: 'Pool Master ESP',
      overlayContent: 'Aktif',
      flag: OverlayFlag.defaultFlag,
      visibility: NotificationVisibility.visibilityPublic,
      positionGravity: PositionGravity.auto,
      width: -1, // match parent untuk overlay window
      height: 180,
    );

    // Delay agar overlay window fully mounted sebelum shareData
    await Future.delayed(const Duration(milliseconds: 300));

    // Kirim config ke overlay via channel
    await FlutterOverlayWindow.shareData({
      'esp': state.espEnabled,
      'aimbot': state.aimbotEnabled,
      'sensitivity': state.aimSensitivity,
    });

    // Log aktivasi ke server
    final api = ApiService(state.serverUrl);
    await api.sendLog(state.licenseKey, 'overlay_activated');

    // Minimize app ke background tanpa kill activity
    await _minimizeApp();
  }

  // Minimize ke background tanpa destroy activity
  // SystemNavigator.pop() membunuh activity sehingga overlay ikut mati
  Future<void> _minimizeApp() async {
    const platform = MethodChannel('com.poolmaster/app');
    try {
      await platform.invokeMethod('moveToBackground');
    } catch (_) {
      // Fallback: overlay tetap jalan walau app tidak minimize
    }
  }

  void _showOverlayDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF12121A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF00FF88), width: 1),
        ),
        title: const Text(
          'Permission Diperlukan',
          style: TextStyle(color: Color(0xFF00FF88), fontSize: 16),
        ),
        content: const Text(
          'Pool Master butuh izin "Tampil di atas aplikasi lain" agar overlay bisa muncul saat bermain.',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Color(0xFF555566))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _requestOverlay();
            },
            child: const Text('Izinkan', style: TextStyle(color: Color(0xFF00FF88))),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(AppState state) async {
    await state.logout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            _TopBar(
              username: state.username,
              onLogout: () => _logout(state),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Status bar server + overlay
                    StatusBarWidget(
                      serverStatus: state.serverStatus,
                      overlayGranted: _overlayGranted,
                      onRequestOverlay: _requestOverlay,
                    ),

                    const SizedBox(height: 24),

                    // Section: Fitur Cheat
                    const _SectionLabel(label: 'FITUR CHEAT'),
                    const SizedBox(height: 12),

                    // Toggle ESP garis tembak
                    CheatToggle(
                      label: 'ESP — Garis Tembak',
                      sublabel: 'Tampilkan jalur bola ke pocket',
                      value: state.espEnabled,
                      onChanged: state.toggleESP,
                      icon: Icons.remove_red_eye_outlined,
                    ),

                    const SizedBox(height: 10),

                    // Toggle aimbot
                    CheatToggle(
                      label: 'Auto-Aim',
                      sublabel: 'Hitung sudut tembak optimal otomatis',
                      value: state.aimbotEnabled,
                      onChanged: state.toggleAimbot,
                      icon: Icons.gps_fixed,
                    ),

                    const SizedBox(height: 10),

                    // Toggle bypass anti-cheat
                    CheatToggle(
                      label: 'Bypass Anti-Cheat',
                      sublabel: 'SSL pinning + root detection bypass',
                      value: state.bypassEnabled,
                      onChanged: state.toggleBypass,
                      icon: Icons.shield_outlined,
                    ),

                    const SizedBox(height: 24),

                    // Section: Sensitivitas
                    const _SectionLabel(label: 'SENSITIVITAS AIM'),
                    const SizedBox(height: 12),

                    SensitivitySlider(
                      value: state.aimSensitivity,
                      onChanged: state.setSensitivity,
                    ),

                    const SizedBox(height: 32),

                    // Tombol launch overlay
                    _LaunchButton(
                      granted: _overlayGranted,
                      onTap: () => _launchOverlay(state),
                    ),

                    const SizedBox(height: 16),

                    // Info cara pakai
                    const _InfoCard(),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== WIDGET LOKAL =====

class _TopBar extends StatelessWidget {
  final String username;
  final VoidCallback onLogout;

  const _TopBar({required this.username, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF1A1A2E), width: 1),
        ),
      ),
      child: Row(
        children: [
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [Color(0xFF00FF88), Color(0xFF00C8FF)],
            ).createShader(b),
            child: const Text(
              'POOL MASTER',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          // Info user
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                username,
                style: const TextStyle(
                  color: Color(0xFF00FF88),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: onLogout,
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Color(0xFF444455), fontSize: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF444455),
        fontSize: 11,
        letterSpacing: 2,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _LaunchButton extends StatelessWidget {
  final bool granted;
  final VoidCallback onTap;

  const _LaunchButton({required this.granted, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [Color(0xFF00FF88), Color(0xFF00C8FF)],
          ),
        ),
        child: Center(
          child: Text(
            granted ? '▶  AKTIFKAN OVERLAY' : '⚠  IZINKAN OVERLAY DULU',
            style: const TextStyle(
              color: Color(0xFF0A0A0F),
              fontWeight: FontWeight.w900,
              fontSize: 14,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF12121A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1A1A2E)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CARA PAKAI',
            style: TextStyle(
              color: Color(0xFF00FF88),
              fontSize: 11,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          _InfoStep(n: '1', text: 'Aktifkan fitur yang diinginkan'),
          _InfoStep(n: '2', text: 'Tap "Aktifkan Overlay"'),
          _InfoStep(n: '3', text: 'Buka 8Ball Pool'),
          _InfoStep(n: '4', text: 'Overlay ESP muncul otomatis di atas game'),
          _InfoStep(n: '5', text: 'Panel kecil akan tampil — tap untuk toggle'),
        ],
      ),
    );
  }
}

class _InfoStep extends StatelessWidget {
  final String n;
  final String text;

  const _InfoStep({required this.n, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF1A1A2E),
            ),
            child: Center(
              child: Text(
                n,
                style: const TextStyle(
                  color: Color(0xFF00FF88),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
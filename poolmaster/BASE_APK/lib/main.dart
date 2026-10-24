import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/app_state.dart';
import 'screens/splash_screen.dart';
import 'screens/overlay_screen.dart';

// Entry point utama app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const PoolMasterApp(),
    ),
  );
}

// Entry point overlay — WAJIB @pragma, WAJIB di file ini
// flutter_overlay_window lookup fungsi ini saat showOverlay() dipanggil
@pragma('vm:entry-point')
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OverlayApp());
}

class PoolMasterApp extends StatelessWidget {
  const PoolMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pool Master',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0F),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FF88),
          secondary: Color(0xFF00C8FF),
          surface: Color(0xFF12121A),
          background: Color(0xFF0A0A0F),
          error: Color(0xFFFF4455),
        ),
        fontFamily: 'Rajdhani',
      ),
      home: const SplashScreen(),
    );
  }
}

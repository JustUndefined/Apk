import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Status koneksi ke API server
enum ServerStatus { checking, online, offline }

class AppState extends ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.checking;
  bool _cheatActive      = false;
  bool _espEnabled       = true;
  bool _aimbotEnabled    = true;
  bool _bypassEnabled    = true;
  double _aimSensitivity = 0.85;  // 0.0 - 1.0
  String _serverUrl      = 'http://104.234.180.146:3001'; // ganti saat deploy
  String _licenseKey     = '';
  bool _isLoggedIn       = false;
  String _username       = '';

  // Getter
  ServerStatus get serverStatus   => _serverStatus;
  bool get cheatActive            => _cheatActive;
  bool get espEnabled             => _espEnabled;
  bool get aimbotEnabled          => _aimbotEnabled;
  bool get bypassEnabled          => _bypassEnabled;
  double get aimSensitivity       => _aimSensitivity;
  String get serverUrl            => _serverUrl;
  String get licenseKey           => _licenseKey;
  bool get isLoggedIn             => _isLoggedIn;
  String get username             => _username;

  AppState() {
    _loadPrefs();
  }

  // Load config tersimpan dari SharedPreferences
  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _serverUrl      = prefs.getString('server_url')    ?? _serverUrl;
    _licenseKey     = prefs.getString('license_key')   ?? '';
    _espEnabled     = prefs.getBool('esp_enabled')     ?? true;
    _aimbotEnabled  = prefs.getBool('aimbot_enabled')  ?? true;
    _bypassEnabled  = prefs.getBool('bypass_enabled')  ?? true;
    _aimSensitivity = prefs.getDouble('sensitivity')   ?? 0.85;
    _isLoggedIn     = prefs.getBool('is_logged_in')    ?? false;
    _username       = prefs.getString('username')      ?? '';
    notifyListeners();
  }

  // Toggle cheat master switch
  void toggleCheat(bool val) {
    _cheatActive = val;
    notifyListeners();
  }

  void toggleESP(bool val) async {
    _espEnabled = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('esp_enabled', val);
    notifyListeners();
  }

  void toggleAimbot(bool val) async {
    _aimbotEnabled = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('aimbot_enabled', val);
    notifyListeners();
  }

  void toggleBypass(bool val) async {
    _bypassEnabled = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('bypass_enabled', val);
    notifyListeners();
  }

  void setSensitivity(double val) async {
    _aimSensitivity = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('sensitivity', val);
    notifyListeners();
  }

  void setServerStatus(ServerStatus status) {
    _serverStatus = status;
    notifyListeners();
  }

  // Set login state setelah auth berhasil
  Future<void> setLoggedIn(String user, String key) async {
    _isLoggedIn = true;
    _username   = user;
    _licenseKey = key;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('username', user);
    await prefs.setString('license_key', key);
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _username   = '';
    _licenseKey = '';
    _cheatActive = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
}

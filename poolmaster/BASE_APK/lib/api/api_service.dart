import 'dart:convert';
import 'package:http/http.dart' as http;

// Semua request ke API server lewat sini
class ApiService {
  static const Duration _timeout = Duration(seconds: 10);

  final String baseUrl;

  ApiService(this.baseUrl);

  // Header standar setiap request
  Map<String, String> _headers({String? token}) => {
    'Content-Type': 'application/json',
    'X-App-Key': 'poolmaster-v1',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  // === AUTH ===
  // Login dengan license key
  Future<Map<String, dynamic>> login(String username, String licenseKey) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _headers(),
        body: jsonEncode({
          'username': username,
          'license_key': licenseKey,
        }),
      ).timeout(_timeout);

      return jsonDecode(res.body) as Map<String, dynamic>;
    } catch (e) {
      // Return error agar UI bisa handle
      return {'success': false, 'message': 'Koneksi gagal: $e'};
    }
  }

  // Cek status server
  Future<bool> checkServer() async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/ping'),
        headers: _headers(),
      ).timeout(_timeout);
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // === CHEAT CONFIG ===
  // Ambil config cheat dari server (angle offset, power multiplier, dll)
  Future<Map<String, dynamic>> getCheatConfig(String token) async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/cheat/config'),
        headers: _headers(token: token),
      ).timeout(_timeout);

      if (res.statusCode == 200) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
      return {};
    } catch (_) {
      return {};
    }
  }

  // === INJECT OVERLAY ===
  // Kirim perintah ke overlay service
  Future<bool> sendOverlayCommand(String token, Map<String, dynamic> cmd) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/overlay/command'),
        headers: _headers(token: token),
        body: jsonEncode(cmd),
      ).timeout(_timeout);

      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // === BYPASS STATUS ===
  // Cek apakah bypass masih valid
  Future<Map<String, dynamic>> checkBypassStatus(String token) async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/bypass/status'),
        headers: _headers(token: token),
      ).timeout(_timeout);

      if (res.statusCode == 200) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
      return {'valid': false};
    } catch (_) {
      return {'valid': false};
    }
  }

  // === LOG ===
  // Kirim log aktivasi ke server untuk tracking
  Future<void> sendLog(String token, String event) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/log/event'),
        headers: _headers(token: token),
        body: jsonEncode({
          'event': event,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      ).timeout(_timeout);
    } catch (_) {
      // Silent fail, log tidak kritis
    }
  }
}

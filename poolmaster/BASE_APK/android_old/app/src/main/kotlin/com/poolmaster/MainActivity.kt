package com.poolmaster

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.poolmaster/overlay"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Method channel untuk komunikasi Flutter <-> Native Android
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    // Cek apakah SYSTEM_ALERT_WINDOW sudah diizinkan
                    "checkOverlayPermission" -> {
                        val granted = android.provider.Settings.canDrawOverlays(this)
                        result.success(granted)
                    }
                    // Buka settings untuk minta permission overlay
                    "requestOverlayPermission" -> {
                        val intent = android.content.Intent(
                            android.provider.Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                            android.net.Uri.parse("package:$packageName")
                        )
                        startActivity(intent)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}

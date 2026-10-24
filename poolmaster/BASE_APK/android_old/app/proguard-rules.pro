# Jaga Flutter classes
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }

# Jaga class overlay plugin
-keep class com.example.flutter_overlay_window.** { *; }

# Jaga class model data
-keep class com.poolmaster.app.** { *; }

# Obfuscate sisanya agar susah di-reverse
-obfuscationdictionary proguard-dict.txt
-classobfuscationdictionary proguard-dict.txt
-packageobfuscationdictionary proguard-dict.txt

# Hapus logging di release
-assumenosideeffects class android.util.Log {
    public static int v(...);
    public static int d(...);
    public static int i(...);
    public static int w(...);
    public static int e(...);
}

# device_apps paketi için ProGuard kuralları
-keep class android.content.pm.** { *; }
-keep class android.content.pm.PackageManager { *; }
-keep class android.content.pm.ApplicationInfo { *; }
-keep class android.content.pm.PackageInfo { *; }

# Flutter embedding için genel kurallar
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }

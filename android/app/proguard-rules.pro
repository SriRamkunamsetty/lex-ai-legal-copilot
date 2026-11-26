# Flutter core & SQLite3 Multiple Ciphers / ML Kit keep rules for Play Store R8 builds.
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }

-keep class org.sqlite.** { *; }
-keep class net.zetetic.** { *; }
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**

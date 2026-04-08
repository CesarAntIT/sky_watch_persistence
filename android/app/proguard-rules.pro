# Keep Flutter internal utilities that path_provider needs
-keep class io.flutter.util.PathUtils { *; }
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.runtime.** { *; }

# Also keep ObjectBox classes if they are being stripped
-keep class io.objectbox.** { *; }
-dontwarn io.objectbox.**

# Fix for Google Play Core missing classes
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# If you still get Task or OnFailureListener errors, add these:
-dontwarn com.google.android.gms.tasks.**
-keep class com.google.android.gms.tasks.** { *; }
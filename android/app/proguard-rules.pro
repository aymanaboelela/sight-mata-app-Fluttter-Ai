# Keep Play Core classes
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }

# Keep TensorFlow Lite classes
-keep class org.tensorflow.lite.** { *; }
-keep class org.tensorflow.lite.gpu.** { *; }

# Flutter rules
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }

# Please add these rules to your existing keep rules in order to suppress warnings.
# This is generated automatically by the Android Gradle plugin.
-dontwarn android.window.BackEvent
# https://github.com/flutter/flutter/issues/78625#issuecomment-804164524
#-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
#-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
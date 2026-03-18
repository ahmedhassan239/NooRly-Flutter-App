# Keep generic signatures so Gson TypeToken works in release (R8/ProGuard).
# Prevents: "TypeToken must be created with a type argument" in
# flutter_local_notifications loadScheduledNotifications / pendingNotificationRequests.
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken { *; }

-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

# Plugin and its native code (scheduling, Gson parsing).
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-dontwarn com.dexterous.flutterlocalnotifications.**

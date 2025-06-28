package com.example.sight_mate_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.os.SystemClock
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.example.sight_mate_app/power_button"
    private var lastPressTime: Long = 0
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        val filter = IntentFilter(Intent.ACTION_SCREEN_OFF)

        registerReceiver(object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                val currentTime = SystemClock.elapsedRealtime()
                if (currentTime - lastPressTime < 1000) {
                    Log.d("PowerButton", "✅ Double Power Button Press Detected")
                    methodChannel?.invokeMethod("powerButtonDoublePressed", null)
                }
                lastPressTime = currentTime
            }
        }, filter)
    }
}

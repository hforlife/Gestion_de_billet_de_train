package com.sopafer.dev

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.sopafer.dev/datawedge"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getScanResult") {
                result.success(null)
            } else {
                result.notImplemented()
            }
        }

        // Register broadcast receiver for DataWedge scans
        val filter = IntentFilter()
        filter.addAction("com.sopafer.dev.SCAN")
        filter.addCategory("android.intent.category.DEFAULT")
        registerReceiver(dataWedgeReceiver, filter)
    }

    private val dataWedgeReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action == "com.sopafer.dev.SCAN") {
                val scanData = intent.getStringExtra("com.symbol.datawedge.data_string")
                if (scanData != null && flutterEngine != null) {
                    MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                        .invokeMethod("onScanResult", scanData)
                }
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(dataWedgeReceiver)
    }
}
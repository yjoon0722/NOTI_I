package com.notii.cashnote

import android.content.Intent
import android.net.Uri
import com.google.androidbrowserhelper.trusted.LauncherActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterFragmentActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            when (call.method)
            {
                "openTWA" -> {
                    val initUrl = call.argument<String>("initUrl")
                    if (initUrl != null) {
                        launchTWA(initUrl)
                    }
                }
            }

        }

        super.configureFlutterEngine(flutterEngine)
    }

    companion object{
        private const val CHANNEL = "method_channel/twa"
    }

    private fun launchTWA(initUrl : String){
        var intent = Intent(this, NativeWebView2::class.java)
        intent.data = Uri.parse(initUrl)
        startActivity(intent)
        if(initUrl.contains("https://front.cashnote.notii.net/m/login")) {
            finish()
        }
    }

}
package com.nyayozangu.labs.mycar

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import android.view.ViewTreeObserver;
import android.view.WindowManager;



class MainActivity() : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        //Remove full screen flag after load
        val vto = getFlutterView().getViewTreeObserver()
        vto.addOnGlobalLayoutListener(object : ViewTreeObserver.OnGlobalLayoutListener {
            override fun onGlobalLayout() {
                getFlutterView().getViewTreeObserver().removeOnGlobalLayoutListener(this)
                getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
            }
        })
    }
}

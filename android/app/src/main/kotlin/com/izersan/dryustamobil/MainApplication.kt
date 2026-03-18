package com.izersan.dryustaapp

import io.flutter.app.FlutterApplication
import android.content.Context
import androidx.multidex.MultiDex

class MainApplication : FlutterApplication() {
    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }
}

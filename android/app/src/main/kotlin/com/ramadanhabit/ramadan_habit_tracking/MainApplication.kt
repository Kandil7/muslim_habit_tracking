package com.ramadanhabit.ramadan_habit_tracking

import io.flutter.app.FlutterApplication
import android.util.Log

class MainApplication : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        
        // Suppress specific warnings by filtering LogCat
        val warningFilter = { tag: String, _: Int, message: String ->
            when {
                tag == "MirrorManager" && message.contains("this model don't Support") -> false
                tag == "libc" && message.contains("Access denied finding property") -> false
                else -> true
            }
        }
        
        try {
            val logClass = Class.forName("android.util.Log")
            val setFilterMethod = logClass.getDeclaredMethod("setFilter", Class.forName("android.util.Log\$TerribleFailureHandler"))
            setFilterMethod.isAccessible = true
            setFilterMethod.invoke(null, warningFilter)
        } catch (e: Exception) {
            // If we can't set the filter, just log it and continue
            Log.d("MainApplication", "Could not set log filter: ${e.message}")
        }
    }
}

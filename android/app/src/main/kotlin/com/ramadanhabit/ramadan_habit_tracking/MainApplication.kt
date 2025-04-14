package com.ramadanhabit.ramadan_habit_tracking

import android.util.Log
import androidx.multidex.MultiDexApplication
import androidx.work.Configuration
import dev.fluttercommunity.workmanager.WorkmanagerPlugin
import io.flutter.app.FlutterApplication
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.GeneratedPluginRegistrant

class MainApplication : MultiDexApplication(), Configuration.Provider, PluginRegistry.PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()

        // Initialize WorkManager with the plugin registrant callback
        WorkmanagerPlugin.setPluginRegistrantCallback(this)

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

    // Implementation of Configuration.Provider for WorkManager
    override fun getWorkManagerConfiguration(): Configuration {
        return Configuration.Builder()
            .setMinimumLoggingLevel(android.util.Log.INFO)
            .build()
    }

    // Implementation of PluginRegistry.PluginRegistrantCallback for WorkManager
    override fun registerWith(registry: PluginRegistry) {
        // Create a FlutterEngine to register plugins
        val flutterEngine = FlutterEngine(this)

        // Register plugins using the generated registrant
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        // Create a ShimPluginRegistry to bridge between the old and new plugin systems
        val shimPluginRegistry = ShimPluginRegistry(flutterEngine, null)

        // Register the workmanager plugin with the shim registry
        WorkmanagerPlugin.registerWith(shimPluginRegistry.registrarFor("dev.fluttercommunity.workmanager.WorkmanagerPlugin"))
    }
}

package io.flutter.embedding.engine.plugins.shim

import android.app.Activity
import android.content.Context
import android.view.View
import androidx.annotation.Keep
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.PluginRegistry

/**
 * Compatibility shim for the old plugin registry.
 * This provides compatibility for plugins that use the old plugin registration method.
 */
@Keep
class ShimPluginRegistry(private val flutterEngine: FlutterEngine, private val activity: Activity?) : PluginRegistry {
    
    private val registrars = mutableMapOf<String, PluginRegistry.Registrar>()
    
    override fun registrarFor(pluginKey: String): PluginRegistry.Registrar {
        if (!registrars.containsKey(pluginKey)) {
            registrars[pluginKey] = ShimRegistrar(flutterEngine, activity, pluginKey)
        }
        return registrars[pluginKey]!!
    }
    
    override fun hasPlugin(pluginKey: String): Boolean {
        return registrars.containsKey(pluginKey)
    }
    
    override fun valuePublishedByPlugin(pluginKey: String): Any? {
        return null
    }
    
    private class ShimRegistrar(
        private val flutterEngine: FlutterEngine,
        private val activity: Activity?,
        private val pluginKey: String
    ) : PluginRegistry.Registrar {
        
        override fun messenger(): BinaryMessenger {
            return flutterEngine.dartExecutor
        }
        
        override fun context(): Context {
            return flutterEngine.applicationContext
        }
        
        override fun activity(): Activity? {
            return activity
        }
        
        override fun activeContext(): Context {
            return activity ?: flutterEngine.applicationContext
        }
        
        override fun binding(): View? {
            return null
        }
        
        override fun lookupKeyForAsset(asset: String): String {
            return flutterEngine.flutterJNI.lookupKeyForAsset(asset)
        }
        
        override fun lookupKeyForAsset(asset: String, packageName: String): String {
            return flutterEngine.flutterJNI.lookupKeyForAsset(asset, packageName)
        }
    }
}

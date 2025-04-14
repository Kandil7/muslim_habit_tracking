package io.flutter.plugin.common

import androidx.annotation.Keep

/**
 * Compatibility shim for the old plugin registry.
 * This is needed for plugins that still use the old plugin registration method.
 */
@Keep
interface PluginRegistry {
    interface Registrar {
        fun messenger(): BinaryMessenger
        fun context(): android.content.Context
        fun activity(): android.app.Activity?
        fun activeContext(): android.content.Context
        fun binding(): android.view.View?
        fun lookupKeyForAsset(asset: String): String
        fun lookupKeyForAsset(asset: String, packageName: String): String
    }

    interface PluginRegistrantCallback {
        fun registerWith(registry: PluginRegistry)
    }

    fun registrarFor(pluginKey: String): Registrar
    fun hasPlugin(pluginKey: String): Boolean
    fun valuePublishedByPlugin(pluginKey: String): Any?
}

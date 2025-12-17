package com.example.meditrack.data
import android.content.Context
class PreferencesManager(context: Context) {
    private val prefs = context.getSharedPreferences("MediTrackPrefs", Context.MODE_PRIVATE)
    fun saveTheme(isDark: Boolean) = prefs.edit().putBoolean("dark_mode", isDark).apply()
    fun isDarkMode() = prefs.getBoolean("dark_mode", false)
}
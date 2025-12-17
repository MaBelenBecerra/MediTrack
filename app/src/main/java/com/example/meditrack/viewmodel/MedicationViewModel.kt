package com.example.meditrack.viewmodel
import android.app.Application
import androidx.compose.runtime.*
import androidx.lifecycle.AndroidViewModel
import com.example.meditrack.data.PreferencesManager
import com.example.meditrack.model.Medication
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow

class MedicationViewModel(app: Application) : AndroidViewModel(app) {
    private val prefs = PreferencesManager(app)
    private val _medications = MutableStateFlow<List<Medication>>(emptyList())
    val medications = _medications.asStateFlow()
    var isDarkMode by mutableStateOf(prefs.isDarkMode()); private set
    var userName by mutableStateOf("Invitado")

    init {
        _medications.value = listOf(Medication("1", "Omeprazol", "20mg", "8h", "10:00 AM", false, 0xFF2196F3))
    }
    fun toggleTheme() { isDarkMode = !isDarkMode; prefs.saveTheme(isDarkMode) }
    fun addMedication(med: Medication) { _medications.value += med }
    fun registerUser(name: String, email: String) { userName = name }
}
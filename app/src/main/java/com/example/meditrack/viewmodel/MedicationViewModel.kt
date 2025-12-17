package com.example.meditrack.viewmodel

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.compose.runtime.*
import com.example.meditrack.data.PreferencesManager
import com.example.meditrack.model.Medication
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow

class MedicationViewModel(application: Application) : AndroidViewModel(application) {

    private val prefs = PreferencesManager(application)

    private val _medications = MutableStateFlow<List<Medication>>(emptyList())
    val medications = _medications.asStateFlow()

    var isDarkMode by mutableStateOf(prefs.isDarkMode()); private set
    var userName by mutableStateOf("Invitado")

    init {
        _medications.value = listOf(
            Medication("1", "Omeprazol", "20mg", "Cada 8h", "10:00 AM", false, 0xFF2196F3),
            Medication("2", "Aspirina", "100mg", "Cada 12h", "08:00 AM", true, 0xFF66BB6A),
            Medication("3", "Metformina", "500mg", "Cada 24h", "2:00 PM", false, 0xFFAB47BC)
        )
    }

    fun toggleTheme() {
        isDarkMode = !isDarkMode
        prefs.saveTheme(isDarkMode)
    }

    fun addMedication(med: Medication) {
        _medications.value = _medications.value + med
    }

    fun updateUserName(name: String) {
        userName = name
    }

    fun toggleMedicationTaken(id: String) {
        _medications.value = _medications.value.map { med ->
            if (med.id == id) med.copy(isTaken = !med.isTaken) else med
        }
    }
}
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
            Medication("1", "Omeprazol", "20mg", "Cada 8h", "10:00 AM", false, 0xFF42A5F5), // Azul
            Medication("2", "Aspirina", "100mg", "Cada 12h", "08:00 AM", true, 0xFF66BB6A), // Verde
            Medication("3", "Metformina", "500mg", "Cada 24h", "2:00 PM", false, 0xFFAB47BC) // Morado
        )
    }

    fun toggleTheme() {
        isDarkMode = !isDarkMode
        prefs.saveTheme(isDarkMode)
    }

    fun addMedication(med: Medication) {
        _medications.value = _medications.value + med
    }

    fun setUserName(name: String) {
        userName = name
    }

    fun toggleMedicationTaken(id: String) {
        _medications.value = _medications.value.map { med ->
            if (med.id == id) med.copy(isTaken = !med.isTaken) else med
        }
    }
}
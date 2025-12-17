package com.example.meditrack.model
import androidx.compose.ui.graphics.Color
data class Medication(val id: String = "", val name: String = "", val dose: String = "", val frequency: String = "", val time: String = "", val isTaken: Boolean = false, val colorHex: Long = 0xFF2196F3) { fun getColor(): Color = Color(colorHex) }
package com.example.meditrack.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Medication
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.example.meditrack.model.Medication
import com.example.meditrack.ui.components.MediButton
import com.example.meditrack.ui.components.MediTextField
import com.example.meditrack.viewmodel.MedicationViewModel
import kotlin.random.Random

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AddMedicationScreen(navController: NavController, viewModel: MedicationViewModel) {
    var name by remember { mutableStateOf("") }
    var dose by remember { mutableStateOf("") }

    var selectedFreq by remember { mutableStateOf("8h") }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp)
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            modifier = Modifier.padding(bottom = 24.dp)
        ) {
            IconButton(onClick = { navController.popBackStack() }) {
                Icon(Icons.AutoMirrored.Filled.ArrowBack, "Atrás")
            }
            Text("Agregar Medicamento", fontSize = 20.sp, fontWeight = FontWeight.Bold)
        }

        MediTextField(name, { name = it }, "Nombre (ej: Paracetamol)", Icons.Default.Medication)
        Spacer(modifier = Modifier.height(16.dp))

        MediTextField(dose, { dose = it }, "Dosis (ej: 500mg)", Icons.Default.Medication)
        Spacer(modifier = Modifier.height(24.dp))

        Text("Frecuencia", fontSize = 14.sp, color = Color.Gray)
        Spacer(modifier = Modifier.height(8.dp))

        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            val frequencies = listOf("4h", "8h", "12h")
            frequencies.forEach { freq ->
                FilterChip(
                    selected = selectedFreq == freq,
                    onClick = { selectedFreq = freq },
                    label = { Text("Cada $freq") },
                    colors = FilterChipDefaults.filterChipColors(
                        selectedContainerColor = Color(0xFF2196F3),
                        selectedLabelColor = Color.White
                    )
                )
            }
        }

        Spacer(modifier = Modifier.weight(1f))

        MediButton(
            text = "Guardar Medicamento",
            onClick = {
                if (name.isNotEmpty() && dose.isNotEmpty()) {
                    val randomColor = listOf(0xFF2196F3, 0xFF00C853, 0xFFAA00FF, 0xFFFFC107).random()

                    val simulTime = when(selectedFreq) {
                        "4h" -> "2:00 PM"
                        "8h" -> "10:00 AM"
                        "12h" -> "8:00 PM"
                        else -> "8:00 AM"
                    }

                    val newMed = Medication(
                        id = Random.nextLong().toString(),
                        name = name,
                        dose = dose,
                        frequency = "Cada $selectedFreq",
                        time = simulTime,
                        colorHex = randomColor
                    )

                    viewModel.addMedication(newMed)

                    navController.popBackStack()
                }
            }
        )
    }
}
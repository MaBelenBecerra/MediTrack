package com.example.meditrack.ui.screens

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.example.meditrack.viewmodel.MedicationViewModel

@Composable
fun HistoryScreen(navController: NavController, viewModel: MedicationViewModel) {
    val allMeds by viewModel.medications.collectAsState()
    val historyList = allMeds.filter { it.isTaken }

    val total = allMeds.size
    val taken = historyList.size
    val percentage = if (total > 0) (taken * 100 / total) else 0

    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text("Historial", fontSize = 24.sp, fontWeight = FontWeight.Bold, color = MaterialTheme.colorScheme.onBackground)
        Spacer(modifier = Modifier.height(16.dp))

        Card(
            colors = CardDefaults.cardColors(containerColor = Color(0xFF00C853)),
            shape = RoundedCornerShape(20.dp),
            modifier = Modifier.fillMaxWidth().height(120.dp)
        ) {
            Row(
                modifier = Modifier.padding(20.dp).fillMaxSize(),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Column {
                    Text("Adherencia hoy", color = Color.White.copy(alpha = 0.8f), fontSize = 14.sp)
                    Text("$percentage%", color = Color.White, fontSize = 40.sp, fontWeight = FontWeight.Bold)
                }
                Box(
                    modifier = Modifier
                        .size(60.dp)
                        .background(Color.White.copy(alpha = 0.2f), RoundedCornerShape(10.dp))
                )
            }
        }

        Spacer(modifier = Modifier.height(24.dp))
        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
            Text("Esta Semana", fontWeight = FontWeight.Bold, fontSize = 18.sp, color = MaterialTheme.colorScheme.onBackground)
            Text("${historyList.size} dosis", color = Color.Gray, fontSize = 14.sp)
        }
        Spacer(modifier = Modifier.height(8.dp))

        if (historyList.isEmpty()) {
            Text("No has tomado medicamentos aún.", color = Color.Gray, modifier = Modifier.padding(top=20.dp))
        }

        LazyColumn(verticalArrangement = Arrangement.spacedBy(10.dp)) {
            items(historyList) { med ->
                Card(
                    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
                    border = BorderStroke(1.dp, Color(0xFFEEEEEE)),
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Row(
                        modifier = Modifier.padding(16.dp).fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Column {
                            Text(med.name, fontWeight = FontWeight.Bold, color = MaterialTheme.colorScheme.onSurface)
                            Text("${med.dose} • Tomado - ${med.time}", fontSize = 12.sp, color = Color.Gray)
                            Text("Hoy", fontSize = 12.sp, color = Color.Gray)
                        }
                        Surface(
                            color = Color(0xFFE8F5E9),
                            shape = RoundedCornerShape(6.dp)
                        ) {
                            Text("Finalizado", color = Color(0xFF2E7D32), fontSize = 10.sp, modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp))
                        }
                    }
                }
            }
        }
    }
}
package com.example.meditrack.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Notifications
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
fun RemindersScreen(navController: NavController, viewModel: MedicationViewModel) {
    val reminders = listOf(
        Triple("Omeprazol", "20mg • 10:00 AM", true),
        Triple("Aspirina", "100mg • 8:00 AM", true),
        Triple("Metformina", "500mg • 2:00 PM", false)
    )

    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text("Recordatorios", fontSize = 24.sp, fontWeight = FontWeight.Bold, color = MaterialTheme.colorScheme.onBackground)
        Spacer(modifier = Modifier.height(16.dp))

        LazyColumn(verticalArrangement = Arrangement.spacedBy(12.dp)) {
            items(reminders.size) { index ->
                val (name, details, isActive) = reminders[index]
                var checked by remember { mutableStateOf(isActive) }

                Card(
                    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
                    elevation = CardDefaults.cardElevation(2.dp),
                    shape = RoundedCornerShape(16.dp)
                ) {
                    Row(
                        modifier = Modifier.padding(16.dp).fillMaxWidth(),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Surface(
                                shape = RoundedCornerShape(8.dp),
                                color = if(checked) Color(0xFFE3F2FD) else Color(0xFFFFEBEE),
                                modifier = Modifier.size(40.dp)
                            ) {
                                Box(contentAlignment = Alignment.Center) {
                                    Icon(
                                        Icons.Default.Notifications,
                                        null,
                                        tint = if(checked) Color(0xFF2196F3) else Color(0xFFE53935)
                                    )
                                }
                            }
                            Spacer(modifier = Modifier.width(12.dp))
                            Column {
                                Text(name, fontWeight = FontWeight.Bold, fontSize = 16.sp)
                                Text(details, fontSize = 12.sp, color = Color.Gray)
                                if(checked) {
                                    Text("Pendiente", fontSize = 10.sp, color = Color(0xFFFFC107), fontWeight = FontWeight.Bold)
                                } else {
                                    Text("Saltado", fontSize = 10.sp, color = Color(0xFFE53935), fontWeight = FontWeight.Bold)
                                }
                            }
                        }
                        Switch(
                            checked = checked,
                            onCheckedChange = { checked = it },
                            colors = SwitchDefaults.colors(
                                checkedThumbColor = Color.White,
                                checkedTrackColor = Color(0xFF00C853)
                            )
                        )
                    }
                }
            }
        }
    }
}
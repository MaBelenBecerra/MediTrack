package com.example.meditrack.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.LocalPharmacy
import androidx.compose.material.icons.outlined.Email
import androidx.compose.material.icons.outlined.Lock
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import com.example.meditrack.ui.components.MediButton
import com.example.meditrack.ui.components.MediTextField
import com.example.meditrack.viewmodel.MedicationViewModel

@Composable
fun LoginScreen(navController: NavController, viewModel: MedicationViewModel) {
    var email by remember { mutableStateOf("") }
    var password by remember { mutableStateOf("") }

    Column(
        modifier = Modifier.fillMaxSize().padding(24.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Surface(shape = CircleShape, color = Color(0xFF2196F3), modifier = Modifier.size(80.dp)) {
            Icon(Icons.Default.LocalPharmacy, null, tint = Color.White, modifier = Modifier.padding(16.dp))
        }

        Spacer(modifier = Modifier.height(16.dp))
        Text("\"Cuida tu salud\"", color = Color.Gray, fontStyle = FontStyle.Italic)
        Spacer(modifier = Modifier.height(40.dp))

        MediTextField(email, { email = it }, "Correo electrónico", Icons.Outlined.Email)
        Spacer(modifier = Modifier.height(16.dp))
        MediTextField(password, { password = it }, "Contraseña", Icons.Outlined.Lock, PasswordVisualTransformation())
        Spacer(modifier = Modifier.height(32.dp))

        MediButton(text = "Iniciar Sesión", onClick = {
            val nameToSave = if (email.isNotEmpty() && email.contains("@")) {
                email.substringBefore("@").replaceFirstChar { it.uppercase() }
            } else {
                "Maria"
            }

            viewModel.updateUserName(nameToSave)

            navController.navigate("dashboard")
        })

        Spacer(modifier = Modifier.height(16.dp))

        TextButton(onClick = { navController.navigate("register") }) {
            Text("¿Crear cuenta?", color = Color(0xFF2196F3))
        }
    }
}
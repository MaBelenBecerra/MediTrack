package com.example.meditrack.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.outlined.Email
import androidx.compose.material.icons.outlined.Lock
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.example.meditrack.ui.components.MediButton
import com.example.meditrack.ui.components.MediTextField
import com.example.meditrack.viewmodel.MedicationViewModel

@Composable
fun RegisterScreen(navController: NavController, viewModel: MedicationViewModel) {
    var name by remember { mutableStateOf("") }
    var email by remember { mutableStateOf("") }
    var password by remember { mutableStateOf("") }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(24.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text("Crear Cuenta", fontSize = 24.sp, fontWeight = FontWeight.Bold)
        Spacer(modifier = Modifier.height(8.dp))
        Text("Ingresa tus datos para comenzar", color = Color.Gray)
        Spacer(modifier = Modifier.height(32.dp))

        MediTextField(name, { name = it }, "Nombre completo", Icons.Default.Person)
        Spacer(modifier = Modifier.height(16.dp))
        MediTextField(email, { email = it }, "Correo electrónico", Icons.Outlined.Email)
        Spacer(modifier = Modifier.height(16.dp))
        MediTextField(password, { password = it }, "Contraseña", Icons.Outlined.Lock, PasswordVisualTransformation())

        Spacer(modifier = Modifier.height(32.dp))

        MediButton(text = "Registrarse", onClick = {
            viewModel.registerUser(name, email)
            navController.navigate("dashboard") {
                popUpTo("login") { inclusive = true }
            }
        })

        Spacer(modifier = Modifier.height(16.dp))

        TextButton(onClick = { navController.popBackStack() }) {
            Text("Ya tengo cuenta, Iniciar sesión", color = Color.Gray)
        }
    }
}
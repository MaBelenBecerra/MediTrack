package com.example.meditrack

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.compose.*
import com.example.meditrack.ui.screens.*
import com.example.meditrack.viewmodel.MedicationViewModel

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            val viewModel: MedicationViewModel = viewModel()
            val navController = rememberNavController()
            MaterialTheme(colorScheme = if(viewModel.isDarkMode) darkColorScheme() else lightColorScheme()) {
                NavHost(navController = navController, startDestination = "login") {
                    composable("login") { LoginScreen(navController) }
                    composable("register") { RegisterScreen(navController, viewModel) }
                    composable("dashboard") { DashboardScreen(navController, viewModel) }
                    composable("add_medication") { AddMedicationScreen(navController, viewModel) }
                }
            }
        }
    }
}
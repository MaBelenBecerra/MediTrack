package com.example.meditrack

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.compose.*
import com.example.meditrack.ui.screens.*
import com.example.meditrack.ui.components.BottomNavBar
import com.example.meditrack.viewmodel.MedicationViewModel

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            val viewModel: MedicationViewModel = viewModel()
            val navController = rememberNavController()
            val navBackStackEntry by navController.currentBackStackEntryAsState()
            val currentRoute = navBackStackEntry?.destination?.route
            val showBottomBar = currentRoute in listOf("dashboard", "reminders", "history")

            val misColoresClaros = lightColorScheme(
                primary = Color(0xFF2196F3),
                background = Color(0xFFF5F5F5),
                surface = Color.White,
                onSurface = Color.Black
            )

            val misColoresOscuros = darkColorScheme(
                primary = Color(0xFF64B5F6),
                background = Color(0xFF121212),
                surface = Color(0xFF1E1E1E),
                onSurface = Color(0xFFE0E0E0),
                onBackground = Color(0xFFE0E0E0)
            )

            MaterialTheme(
                colorScheme = if(viewModel.isDarkMode) misColoresOscuros else misColoresClaros
            ) {
                Scaffold(
                    bottomBar = {
                        if (showBottomBar) {
                            BottomNavBar(navController)
                        }
                    }
                ) { padding ->
                    NavHost(
                        navController = navController,
                        startDestination = "login",
                        modifier = Modifier.padding(padding)
                    ) {
                        composable("login") {
                            LoginScreen(navController, viewModel)
                        }

                        composable("register") {
                            RegisterScreen(navController, viewModel)
                        }

                        composable("dashboard") {
                            DashboardScreen(navController, viewModel)
                        }

                        composable("reminders") {
                            RemindersScreen(navController, viewModel)
                        }

                        composable("history") {
                            HistoryScreen(navController, viewModel)
                        }

                        composable("add_medication") {
                            AddMedicationScreen(navController, viewModel)
                        }
                    }
                }
            }
        }
    }
}
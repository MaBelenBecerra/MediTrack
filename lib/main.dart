import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:meditrack/core/network/dio_client.dart';
import 'package:meditrack/data/models/medication_model.dart';
import 'package:meditrack/repositories/medication_repository.dart';
import 'package:meditrack/viewmodels/dashboard_viewmodel.dart';
import 'package:meditrack/views/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar variables de entorno desde .env
  await dotenv.load(fileName: '.env');

  // Inicializar Hive
  await Hive.initFlutter();

  // Registrar adaptadores de Hive ANTES de abrir las cajas
  // NOTA: Descomenta después de ejecutar: flutter pub run build_runner build --delete-conflicting-outputs
  // Hive.registerAdapter(MedicationModelAdapter());

  // Abrir la Box para medicamentos con tipo genérico
  await Hive.openBox<MedicationModel>('medications_box');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Singleton del cliente Dio
        Provider<DioClient>(
          create: (_) => DioClient(),
        ),

        // Provider de la Box de Hive tipada
        Provider<Box<MedicationModel>>(
          create: (_) => Hive.box<MedicationModel>('medications_box'),
        ),

        // Repositorio
        ProxyProvider2<DioClient, Box<MedicationModel>, MedicationRepository>(
          create: (context) => MedicationRepository(
            dioClient: context.read<DioClient>(),
            medicationBox: context.read<Box<MedicationModel>>(),
          ),
          update: (context, dioClient, medicationBox, previous) =>
              previous ?? MedicationRepository(
            dioClient: dioClient,
            medicationBox: medicationBox,
          ),
        ),

        // ViewModel
        ChangeNotifierProxyProvider<MedicationRepository, DashboardViewModel>(
          create: (context) => DashboardViewModel(
            repository: context.read<MedicationRepository>(),
          ),
          update: (context, repository, previous) =>
              previous ?? DashboardViewModel(repository: repository),
        ),
      ],
      child: MaterialApp(
        title: 'MediTrack',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 2,
          ),
        ),
        home: const DashboardScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

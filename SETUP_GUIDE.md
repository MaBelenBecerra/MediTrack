# MediTrack - Aplicación Médica

## Descripción

MediTrack es una aplicación Flutter diseñada para la gestión de medicamentos. Implementa arquitectura MVVM con gestión de estado usando Provider, persistencia local con Hive, y cliente HTTP robusto con Dio.

## Arquitectura

```
MVVM (Model-View-ViewModel)
├── Models: Datos con anotaciones Hive
├── Views: UI con Consumer de Provider
├── ViewModels: Lógica con ChangeNotifier
├── Repositories: Acceso a datos (API + Caché)
└── Core: Configuración, errores y utilidades
```

## Requisitos Previos

- Flutter SDK 3.0.0 o superior
- Dart 3.0.0 o superior
- Android SDK / Xcode (para desarrollo nativo)

## Instalación

### 1. Clonar/Descargar el proyecto
```bash
cd MediTrack
```

### 2. Instalar dependencias
```bash
flutter pub get
```

### 3. Generar código de Hive
Es **CRÍTICO** ejecutar build_runner para generar los adaptadores de Hive:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

O para modo watch (regenera automáticamente durante desarrollo):
```bash
flutter pub run build_runner watch
```

**Esto generará el archivo `medication_model.g.dart`** necesario para que Hive funcione correctamente.

### 4. Configurar variables de entorno
Crea un archivo `.env` en la raíz del proyecto:

```env
API_BASE_URL=https://api.meditrack.com/v1
CONNECT_TIMEOUT=10
RECEIVE_TIMEOUT=10
SEND_TIMEOUT=10
```

Se proporciona un `.env` de ejemplo.

### 5. Ejecutar la aplicación
```bash
flutter run
```

## Estructura del Proyecto

```
lib/
├── core/
│   ├── errors/
│   │   └── failures.dart          # Excepciones personalizadas
│   ├── network/
│   │   └── dio_client.dart        # Cliente HTTP con Dio
│   └── utils/
│       └── validators.dart        # Funciones utilitarias
├── data/
│   └── models/
│       └── medication_model.dart  # Modelo con @HiveType
├── repositories/
│   └── medication_repository.dart # Acceso a datos
├── viewmodels/
│   └── dashboard_viewmodel.dart   # Lógica de negocio
├── views/
│   └── dashboard_screen.dart      # UI
└── main.dart                      # Punto de entrada
```

## Configuración Importante

### Adaptadores de Hive
Después de modificar `medication_model.dart`, ejecuta:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Token de Autenticación
Actualizar el token en tiempo de ejecución:
```dart
DioClient().setAuthToken('tu_token_aqui');
```

### Base URL
Cambiar la URL de la API:
```dart
DioClient().setBaseUrl('https://tu.api.com/v1');
```

## Características

**MVVM Architecture** - Separación clara de responsabilidades  
**Provider State Management** - Gestión eficiente del estado  
**Dio HTTP Client** - Cliente robusto con interceptores  
**Hive Cache** - Persistencia local con fallback automático  
**Error Handling** - Excepciones personalizadas (ServerException, CacheException)  
**Strong Typing** - Todo fuertemente tipado en Dart  
**Pretty Logger** - Depuración mejorada de requests HTTP  

## Manejo de Errores

La aplicación implementa 3 tipos de excepciones personalizadas:

1. **ServerException** - Errores de API/red
2. **CacheException** - Errores de persistencia local
3. **UnknownException** - Errores no clasificados

Todas extienden de `Failure` y se capturan en el ViewModel.

## Dependencias Principales

| Paquete | Versión | Propósito |
|---------|---------|-----------|
| provider | ^6.4.0 | Gestión de estado |
| dio | ^5.3.0 | Cliente HTTP |
| hive | ^2.2.3 | Base de datos local |
| hive_flutter | ^1.1.0 | Inicialización Hive |
| flutter_dotenv | ^5.1.0 | Variables de entorno |
| pretty_dio_logger | ^1.3.1 | Logger HTTP |
| equatable | ^2.0.5 | Comparación de objetos |

**Dev Dependencies:**
- build_runner: ^2.4.0
- hive_generator: ^2.0.0

## Flujo de Datos

```
DashboardScreen (UI)
    ↓ (Consumer)
DashboardViewModel (ChangeNotifier)
    ↓ (llamada)
MedicationRepository
    ├─ DioClient (API con Dio)
    └─ Hive Box (Cache local)
        ↓
MedicationModel
```

## Testing

Para ejecutar tests (si existen):
```bash
flutter test
```

## Compilar APK

Para Android:
```bash
flutter build apk
```

Para iOS:
```bash
flutter build ios
```

## Desarrollo

### Hot Reload
```bash
r - Hot reload
R - Hot restart
```

### Ver logs
```bash
flutter logs
```

### Limpiar proyecto
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## Documentación Adicional

- [Flutter Documentation](https://flutter.dev/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [Dio Package](https://pub.dev/packages/dio)
- [Hive Database](https://docs.hivedb.dev/)

## Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama (`git checkout -b feature/AmazingFeature`)
3. Commit cambios (`git commit -m 'Add AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo LICENSE para detalles.


**Nota:** Recuerda ejecutar `flutter pub run build_runner build` después de modificar los modelos con anotaciones Hive.

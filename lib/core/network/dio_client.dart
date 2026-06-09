import 'package:dio/dio.dart';

class DioClient {
  // Patrón Singleton para usar siempre la misma instancia en toda la app
  static final DioClient _instance = DioClient._internal();
  late final Dio _dio;
  String? _authToken;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        // 10.0.2.2 es el localhost para el emulador de Android
        baseUrl: 'http://10.0.2.2:3000/api/v1', 
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Interceptor: Atrapa TODAS las peticiones antes de salir e inyecta el token JWT
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_authToken != null) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }
          return handler.next(options); // Continúa con la petición
        },
        onError: (DioException e, handler) {
          // Aquí registraMOS errores globales en el futuro
          return handler.next(e);
        },
      ),
    );
  }

  // Getter para acceder al cliente
  Dio get dio => _dio;

  // guardar el token cuando el usuario haga Login
  void setAuthToken(String token) {
    _authToken = token;
  }
  
  // cerrar sesión
  void clearAuthToken() {
    _authToken = null;
  }
}
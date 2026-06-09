import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();

  late Dio _dio;
  String _authToken = '';

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    _initializeDio();
  }

  void _initializeDio() {
    final baseUrl = dotenv.env['API_BASE_URL'] ?? 'https://api.meditrack.com/v1';
    final connectTimeout = int.tryParse(dotenv.env['CONNECT_TIMEOUT'] ?? '10') ?? 10;
    final receiveTimeout = int.tryParse(dotenv.env['RECEIVE_TIMEOUT'] ?? '10') ?? 10;
    final sendTimeout = int.tryParse(dotenv.env['SEND_TIMEOUT'] ?? '10') ?? 10;

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(seconds: connectTimeout),
        receiveTimeout: Duration(seconds: receiveTimeout),
        sendTimeout: Duration(seconds: sendTimeout),
        contentType: 'application/json',
        responseType: ResponseType.json,
      ),
    );

    // Agregar interceptor de autorización
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_authToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          print('❌ Dio Error: ${error.message}');
          print('   Status Code: ${error.response?.statusCode}');
          print('   Response: ${error.response?.data}');
          return handler.next(error);
        },
      ),
    );

    // Agregar logger para desarrollo
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  Dio get dio => _dio;

  /// Método para actualizar el token dinámicamente
  void setAuthToken(String token) {
    _authToken = token;
  }

  /// Obtiene el token actual
  String getAuthToken() => _authToken;

  /// Método para limpiar el token (logout)
  void clearAuthToken() {
    _authToken = '';
  }

  /// Cambia la base URL dinámicamente
  void setBaseUrl(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
  }
}

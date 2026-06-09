import 'package:flutter/material.dart';
import '../core/network/dio_client.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Aquí harías tu _dio.post('/auth/login') hacia NestJS
      // Simulamos la respuesta exitosa con un token falso por ahora:
      await Future.delayed(const Duration(seconds: 2)); 
      final fakeToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...";
      
      // Guardamos el token en nuestro cliente Dio
      DioClient().setAuthToken(fakeToken);
      
      _isLoading = false;
      notifyListeners();
      return true; // Login exitoso
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false; // Falló el login
    }
  }
}
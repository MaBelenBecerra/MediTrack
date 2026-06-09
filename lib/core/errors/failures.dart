import 'package:equatable/equatable.dart';

/// Clase base para todas las excepciones de la aplicación
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Excepción cuando falla una llamada a la API
class ServerException extends Failure {
  final int? statusCode;
  final String? response;

  const ServerException({
    required String message,
    this.statusCode,
    this.response,
  }) : super(message: message);

  @override
  List<Object?> get props => [message, statusCode, response];
}

/// Excepción cuando falla la operación con Hive (caché local)
class CacheException extends Failure {
  final String? errorCode;

  const CacheException({
    required String message,
    this.errorCode,
  }) : super(message: message);

  @override
  List<Object?> get props => [message, errorCode];
}

/// Excepción genérica no clasificada
class UnknownException extends Failure {
  final Exception? exception;

  const UnknownException({
    required String message,
    this.exception,
  }) : super(message: message);

  @override
  List<Object?> get props => [message, exception];
}

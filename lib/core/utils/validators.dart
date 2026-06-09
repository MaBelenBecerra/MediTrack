/// Funciones utilitarias reutilizables en toda la aplicación

/// Formatea una fecha en formato HH:mm
String formatTime(String? time) {
  if (time == null || time.isEmpty) return '--:--';
  
  try {
    final parts = time.split(':');
    if (parts.length >= 2) {
      final hour = int.parse(parts[0]).toString().padLeft(2, '0');
      final minute = int.parse(parts[1]).toString().padLeft(2, '0');
      return '$hour:$minute';
    }
  } catch (_) {}
  
  return time;
}

/// Valida si un string es una hora válida (HH:mm)
bool isValidTime(String? time) {
  if (time == null || time.isEmpty) return false;
  
  final timeRegex = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$');
  return timeRegex.hasMatch(time);
}

/// Trunca un string a una longitud máxima con elipsis
String truncate(String? text, int maxLength) {
  if (text == null || text.isEmpty) return '';
  if (text.length <= maxLength) return text;
  return '${text.substring(0, maxLength - 3)}...';
}

/// Valida si una cadena contiene solo letras y espacios
bool isOnlyLetters(String? text) {
  if (text == null || text.isEmpty) return false;
  return RegExp(r'^[a-zA-Z\s]+$').hasMatch(text);
}

/// Obtiene un mensaje de error amigable basado en la excepción
String getErrorMessage(dynamic error) {
  if (error == null) {
    return 'Error desconocido';
  }
  return error.toString();
}

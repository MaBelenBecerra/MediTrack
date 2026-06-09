import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static Future<void> requestAppPermissions() async {
    // Solicitamos cámara y notificaciones de golpe
    await [
      Permission.camera,
      Permission.notification,
    ].request();
  }
}
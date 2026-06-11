# MediTrack

MediTrack es una aplicación móvil multiplataforma desarrollada en **Flutter** diseñada para la gestión y control de la ingesta de medicamentos. El proyecto implementa una arquitectura robusta **Offline-First**, permitiendo al usuario registrar y visualizar sus medicamentos incluso sin conexión a internet, sincronizando posteriormente con un backend en NestJS.

## Características Principales

* **Arquitectura MVVM:** Separación limpia de responsabilidades (Model - View - ViewModel).
* **Offline-First:** Almacenamiento ultrarrápido en caché local utilizando **Hive**.
* **Gestión de Estado:** Reactividad eficiente implementada con **Provider**.
* **Cliente de Red Avanzado:** Configuración de **Dio** con interceptores para inyección automática de tokens JWT.
* **Diseño Responsivo:** UI adaptable a múltiples tamaños de pantalla utilizando `flutter_screenutil`.
* **Permisos Nativos:** Gestión de permisos de cámara y notificaciones en tiempo de ejecución.
* **Flujo de Trabajo:** Historial de versiones gestionado estrictamente bajo el estándar **GitFlow**.

## Stack Tecnológico

* **Framework:** Flutter (Dart 3+)
* **Gestor de Estado:** `provider`
* **Base de Datos Local:** `hive` & `hive_flutter`
* **Cliente HTTP:** `dio`
* **Diseño Responsivo:** `flutter_screenutil`
* **Permisos:** `permission_handler`

## Estructura del Proyecto

El proyecto sigue una estructura de carpetas modular y escalable:

```text
lib/
├── core/             # Configuraciones globales (Design System, Red, Utilidades)
├── data/             # Modelos de datos y adaptadores (Hive)
├── repositories/     # Capa de acceso a datos (Lógica híbrida API/Caché)
├── viewmodels/       # Lógica de negocio y gestión de estado
└── views/            # Interfaz de usuario (Pantallas y Widgets)
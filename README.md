# EcoHome App

Aplicación móvil desarrollada en Flutter para la gestión de productos y comunicación en tiempo real.

## Características Principales

* **Gestión de Productos**: 
  * Listado de productos detallando nombre, precio, stock y el usuario creador.
  * Formulario para la creación de nuevos productos.
* **Chat Global**: 
  * Sala de chat en tiempo real utilizando `Socket.IO`.
  * Recuperación automática del historial de los últimos mensajes.
* **Navegación Intuitiva**: Menú inferior (BottomNavigationBar) para cambiar fácilmente entre el listado, la creación de productos y el chat.

## Requisitos del Backend (Entorno de Desarrollo)

La aplicación está configurada para conectarse a un backend local (usando `10.0.2.2` en emuladores de Android y `localhost` en web/iOS):
* **API REST**: Se espera que corra en el puerto `8080` (Maneja endpoints como `/api/v1/products` y `/api/v1/chats/latest`).
* **WebSockets**: Servidor de Socket.IO corriendo en el puerto `8095`.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

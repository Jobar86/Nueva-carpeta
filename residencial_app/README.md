# Mi Residencial - App de Gestión Residencial

Aplicación móvil multiplataforma (iOS/Android) para la gestión integral de comunidades residenciales cerradas.

## 🚀 Características

### 🔐 Seguridad
- **Registro de Visitas (QR)**: Genera códigos QR temporales para tus invitados
- **Ábrete Sésamo**: Control remoto de la puerta principal vía IoT
- **Botón de Pánico**: Alerta de emergencia a vecinos y caseta
- **Recorridos de Guardia**: Tracking GPS en tiempo real

### 💬 Comunicación
- **Chat con Caseta**: Mensajes directos con seguridad
- **Comunicados**: Anuncios de administración
- **Alerta de Basura**: Notificación cuando llega el camión

### 📊 Administración
- **Dashboard de Transparencia**: Gastos y recibos
- **Control de Morosidad**: Estado de pagos
- **Encuestas**: Votaciones comunitarias

### 🏊 Servicios
- **Reserva de Amenidades**: Gym, alberca, salón de eventos
- **Reporte de Incidencias**: Mantenimiento, seguridad, ruido

## 📂 Estructura del Proyecto

```
lib/
├── config/           # Tema y constantes
├── models/           # Modelos de datos (Firestore)
├── services/         # Servicios (Auth, Firestore, Notificaciones)
├── screens/          # Pantallas de la app
│   ├── auth/         # Login
│   ├── home/         # Dashboard
│   ├── security/     # Módulo de seguridad
│   ├── communication/# Chat y comunicados
│   ├── profile/      # Perfil de usuario
│   └── amenities/    # Reservas e incidencias
└── widgets/          # Componentes reutilizables
```

## 🛠️ Tecnologías

- **Frontend**: Flutter 3.x (Dart)
- **Backend**: Firebase (Auth, Firestore, Storage, FCM)
- **Mapas**: Google Maps Flutter
- **QR**: qr_flutter + mobile_scanner

## 🚀 Instalación

1. Asegúrate de tener Flutter instalado:
```bash
flutter --version
```

2. Instala las dependencias:
```bash
cd residencial_app
flutter pub get
```

3. Configura Firebase:
   - Crea un proyecto en [Firebase Console](https://console.firebase.google.com)
   - Descarga `google-services.json` (Android) y `GoogleService-Info.plist` (iOS)
   - Colócalos en las carpetas correspondientes

4. Ejecuta la app:
```bash
flutter run
```

## 📱 Roles de Usuario

| Rol | Descripción |
|-----|-------------|
| **Residente** | Genera QR, reserva amenidades, reporta incidencias |
| **Guardia** | Escanea QR, realiza recorridos, responde chat |
| **Admin** | Gestiona comunicados, encuestas, usuarios |

## 🔧 Configuración Firebase

Colecciones necesarias en Firestore:
- `users`
- `properties`
- `access_invitations`
- `amenity_bookings`
- `emergencies`
- `guard_patrols`
- `chats` (+ subcollection `messages`)
- `community_posts`
- `incidents`

## 📄 Licencia

Este proyecto es privado para uso del residencial.

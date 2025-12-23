# Poder Stereo · Hub oficial

Single screen app for **Poder Stereo**: premium UI estilo Apple con glassmorphism, CTA principal “Escuchar en vivo” (abre el stream HTTPS) y accesos directos a sitio web, WhatsApp, Instagram y correo.

## Stack

- Flutter 3.38 · Dart 3.10
- `google_fonts`, `flutter_svg`, `glassmorphism_ui`, `animations`, `url_launcher`

## Ejecución

```bash
flutter pub get
flutter run
```

URLs (stream, web, redes) están centralizadas en `lib/core/constants/app_constants.dart`.

## Estructura

```
lib/
 ├─ core/
 │   ├─ constants/app_constants.dart
 │   └─ theme/app_theme.dart
 ├─ screens/home_screen.dart   # Única pantalla con CTA + links
 └─ widgets/                   # Componentes reutilizables (glass cards, etc.)
```

## Personalización

- Cambia logos en `assets/branding/`.
- Ajusta colores/tipografías en `lib/core/theme/app_theme.dart`.
- Actualiza/añade enlaces en `AppConstants`.
# poderstereoAPP

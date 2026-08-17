# Plan de Implementación - Agenda de Infusiones (Yerba Mate & Café)

Aplicación móvil en **Dart & Flutter** para el registro, agenda y ranking de **Yerba Mate** y **Café**, con soporte de fotos (cámara y galería), calendario interactivo para seguimiento diario/horario, parámetros de extracción (peso y temperatura) y paleta de diseño **Catppuccin**.

---

## 🎨 Paleta y Diseño Visual (Catppuccin)
La aplicación implementará el sistema de diseño oficial de **Catppuccin** (con soporte para tema oscuro **Catppuccin Mocha** y tema claro **Catppuccin Latte**):
- **Base / Fondos**: `#1E1E2E` (Mocha Base) / `#EFF1F5` (Latte Base)
- **Superficies & Tarjetas**: `#313244` (Surface0) / `#45475A` (Surface1) / `#CCD0DA` (Latte Surface)
- **Acentos**:
  - 🌿 **Verde Mate / Herbal**: `#A6E3A1` (Green) & `#94E2D5` (Teal)
  - ☕ **Café / Tostado / Cálido**: `#FAB387` (Peach) & `#F9E2AF` (Yellow)
  - 💜 **Detalles & Selección**: `#B4BEFE` (Lavender) & `#CBA6F7` (Mauve)
  - 🌸 **Resaltados**: `#F5E0DC` (Rosewater) & `#F38BA8` (Red / Coral)

---

## 🚀 Módulos y Funcionalidades Principales

### 1. 🏆 Ranking y Catálogo de Productos (Yerba Mate & Café)
- **Filtros por categoría**: Pestañas para *Yerba Mate*, *Café*, o *Todos*.
- **Sistema de Calificación**: Puntuación de 1.0 a 5.0 estrellas, notas de cata (ej. Ahumado, Cítrico, Frutal, Chocolate, Tostado, etc.) y reseña personal.
- **Gestión de Imágenes**:
  - Captura directa con la **Cámara** (`image_picker`).
  - Carga desde la **Galería local** del dispositivo.
  - Almacenamiento local persistente en el sandbox de la app (`path_provider`).
- **Ordenamiento Inteligente**: Por mejor puntuación (Ranking), más consumido, o recientemente agregado.
- **Detalle de Producto**: Historial de preparaciones asociadas a esa yerba o café específico.

### 2. 📅 Calendario & Agenda de Infusiones
- **Calendario Interactivo**: Visualización mensual y semanal con marcadores distintivos (íconos de mate y café en los días con registros).
- **Fecha y Hora Modificable**: Selector completo de día y hora para registrar infusiones pasadas, presentes o agendadas.
- **Tipos de Infusión Específicos Requeridos**:
  - **Yerba Mate**:
    - 🧉 *Mate Tradicional*
    - 🥛 *Mate de Leche*
  - **Café**:
    - ☕ *Café V60*
    - 🫖 *French Press* (Prensa Francesa)
    - 🏺 *Moka Pot* (Cafetera Italiana)
    - ❄️ *Cold Brew*
- **Parámetros de Preparación**:
  - ⚖️ **Peso**: Gramos de yerba o molienda de café + volumen/peso de agua o leche.
  - 🌡️ **Temperatura**: Selector en °C con accesos rápidos según el tipo (ej: 75°-80°C para mate, 90°-95°C para V60/French Press, fría/ambiente para Cold Brew).
  - 📝 **Notas de sesión**: Calificación de la taza/cebada y comentarios.

### 3. 📊 Estadísticas y Resumen
- Contador total de mates y cafés preparados.
- Infusión más frecuente, promedio de temperatura y peso utilizado.

---

## 🛠️ Arquitectura y Tecnologías
- **Framework**: Flutter 3.47+ / Dart 3.13+
- **Gestión de Estado**: `ChangeNotifier` / `Provider` estructurado y reactivo.
- **Persistencia**: Base de datos local SQLite (`sqflite` + `path` + `path_provider`) para almacenamiento offline y robusto de productos y sesiones.
- **Imágenes**: `image_picker` con copia y almacenamiento local.
- **Calendario**: `table_calendar` con personalización Catppuccin.
- **Iconografía**: `font_awesome_flutter` / Material Symbols adaptados a mate y café.

---

## 📁 Estructura del Proyecto Propuesta

```
agenda_de_infusiones/
├── lib/
│   ├── main.dart
│   ├── theme/
│   │   ├── catppuccin_colors.dart
│   │   └── app_theme.dart
│   ├── models/
│   │   ├── product.dart
│   │   ├── infusion_log.dart
│   │   └── infusion_type.dart
│   ├── services/
│   │   ├── database_service.dart
│   │   └── image_service.dart
│   ├── providers/
│   │   ├── product_provider.dart
│   │   ├── infusion_provider.dart
│   │   └── theme_provider.dart
│   ├── views/
│   │   ├── home_navigation_view.dart
│   │   ├── calendar/
│   │   │   ├── calendar_view.dart
│   │   │   └── infusion_form_dialog.dart
│   │   ├── ranking/
│   │   │   ├── ranking_view.dart
│   │   │   ├── product_detail_view.dart
│   │   │   └── product_form_dialog.dart
│   │   ├── stats/
│   │   │   └── stats_view.dart
│   │   └── widgets/
│   │       ├── catppuccin_card.dart
│   │       ├── rating_stars.dart
│   │       ├── temperature_selector.dart
│   │       └── infusion_badge.dart
├── test/
│   ├── models_test.dart
│   └── provider_test.dart
└── pubspec.yaml
```

---

## 🧪 Plan de Verificación y Compilación

1. **Pruebas Automatizadas**:
   - Tests unitarios en Dart (`flutter test`) para validar los modelos, cálculos de ranking, validaciones de temperatura/peso y persistencia.
2. **Análisis Estático**:
   - `flutter analyze` para asegurar cero errores y warnings de linter.
3. **Compilación de APK Android**:
   - Configuración de `AndroidManifest.xml` con permisos de cámara y almacenamiento para fotos.
   - Ejecutar `flutter build apk --release` para generar el instalador APK funcional en `build/app/outputs/flutter-apk/app-release.apk`.

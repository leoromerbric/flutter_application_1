# Flutter Application 1

**Aplicación Flutter de ejemplo con múltiples vistas y navegación Material 3**

Esta aplicación Flutter demuestra las mejores prácticas de desarrollo móvil con Material Design 3, incluyendo autenticación, navegación entre pantallas, y gestión de productos.

## 🚀 Características

### 📱 Pantallas Implementadas

1. **Pantalla de Login (`LoginScreen`)**
   - Formulario de autenticación con validación
   - Campos de email y contraseña
   - Manejo de estados de carga y error
   - Diseño Material 3 con validaciones en tiempo real

2. **Dashboard/Home (`HomeScreen`)**
   - Página principal con bienvenida personalizada
   - Productos destacados en grilla
   - Acceso rápido a diferentes secciones
   - SliverAppBar expandible con gradientes

3. **Lista de Productos (`ProductListScreen`)**
   - Vista completa de todos los productos
   - Búsqueda en tiempo real por nombre y descripción
   - Filtros por categoría con chips interactivos
   - Alternancia entre vista de grilla y lista
   - Pull-to-refresh para actualizar datos

4. **Catálogo de Productos (`ProductCatalogScreen`)**
   - Productos organizados por categorías en tabs
   - Navegación por pestañas con iconos temáticos
   - SliverAppBar con diseño atractivo
   - Vista de grilla optimizada para exploración

5. **Detalles de Producto (`ProductDetailScreen`)**
   - Información completa del producto
   - Galería de imágenes con Hero animations
   - Especificaciones técnicas detalladas
   - Sistema de reseñas y calificaciones
   - Selector de cantidad y botón de agregar al carrito

### 🎨 Diseño y UX

- **Material Design 3**: Implementación completa del sistema de diseño más reciente
- **Temas claro y oscuro**: Soporte automático basado en preferencias del sistema
- **Navegación intuitiva**: Bottom navigation bar con indicadores visuales
- **Transiciones fluidas**: Animaciones y transiciones entre pantallas
- **Componentes reutilizables**: Widgets personalizados para consistencia visual

### 🏗️ Arquitectura del Proyecto

```
lib/
├── constants/          # Constantes de la aplicación
│   ├── app_constants.dart    # Espaciados, colores, textos
│   └── app_theme.dart        # Configuración de temas Material 3
├── models/            # Modelos de datos
│   ├── product.dart         # Modelo de producto
│   └── user.dart           # Modelo de usuario
├── screens/           # Pantallas de la aplicación
│   ├── home_screen.dart           # Dashboard principal
│   ├── login_screen.dart          # Pantalla de autenticación
│   ├── product_catalog_screen.dart # Catálogo por categorías
│   ├── product_detail_screen.dart  # Detalles de producto
│   └── product_list_screen.dart    # Lista de productos
├── services/          # Lógica de negocio y servicios
│   ├── auth_service.dart      # Servicio de autenticación
│   └── product_service.dart   # Servicio de productos
├── widgets/           # Componentes reutilizables
│   ├── custom_text_field.dart # Campo de texto personalizado
│   ├── loading_button.dart    # Botón con estado de carga
│   ├── product_card.dart      # Tarjeta de producto
│   └── section_header.dart    # Encabezado de sección
└── main.dart          # Punto de entrada y navegación
```

## 🛠️ Tecnologías Utilizadas

- **Flutter 3.x**: Framework de desarrollo multiplataforma
- **Dart 3.x**: Lenguaje de programación
- **Material Design 3**: Sistema de diseño de Google
- **Arquitectura limpia**: Separación de responsabilidades
- **Patrón Singleton**: Para servicios compartidos

## 📋 Funcionalidades Principales

### Autenticación
- Login simulado con validación de formularios
- Manejo de sesión de usuario
- Validación de email y contraseña
- Estados de carga y error

### Gestión de Productos
- Catálogo con 8 productos de ejemplo
- Búsqueda y filtrado avanzado
- Categorización automática
- Productos destacados basados en calificación

### Navegación
- Bottom navigation bar con 3 secciones principales
- Navegación fluida entre pantallas
- Botón de retroceso en pantalla de detalles
- Estado preservado en navegación

### Interfaz de Usuario
- Componentes Material 3 (Cards, Chips, Navigation)
- Esquemas de color adaptativos
- Tipografía consistente
- Espaciados y márgenes estandarizados

## 🚦 Cómo Ejecutar

### Prerrequisitos
- Flutter SDK 3.8.1 o superior
- Dart SDK 3.x
- Editor de código (VS Code, Android Studio)

### Instalación

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/leoromerbric/flutter_application_1.git
   cd flutter_application_1
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

### Dispositivos Soportados
- 📱 Android (API 21+)
- 🍎 iOS (iOS 12+)
- 🖥️ Web
- 💻 Desktop (Windows, macOS, Linux)

## 🔑 Credenciales de Prueba

Para probar la aplicación, usa cualquier email válido y contraseña:

- **Email**: `test@example.com` (o cualquier email válido)
- **Contraseña**: `123456` (o cualquier texto de 6+ caracteres)

## 📱 Capturas de Pantalla

### Pantalla de Login
- Formulario con validación en tiempo real
- Diseño Material 3 con campos flotantes
- Botón con estado de carga

### Dashboard
- Bienvenida personalizada
- Productos destacados
- Acceso rápido a secciones

### Lista de Productos
- Vista de grilla y lista
- Búsqueda instantánea
- Filtros por categoría

### Catálogo
- Organización por pestañas
- Iconos temáticos por categoría
- Diseño visual atractivo

### Detalles de Producto
- Información completa
- Especificaciones técnicas
- Sistema de calificaciones
- Funcionalidad de carrito

## 🎯 Características Técnicas

### Rendimiento
- **Lazy loading**: Carga eficiente de listas
- **Optimización de imágenes**: Manejo de errores de red
- **Estado preservado**: Navegación sin pérdida de datos
- **Animaciones fluidas**: 60 FPS en transiciones

### Accesibilidad
- **Etiquetas semánticas**: Para lectores de pantalla
- **Contraste adecuado**: Cumple estándares WCAG
- **Navegación por teclado**: Soporte completo
- **Tamaños de toque**: Áreas mínimas de 44x44

### Responsividad
- **Diseño adaptativo**: Se ajusta a diferentes tamaños
- **Orientación**: Soporte horizontal y vertical
- **Densidad de píxeles**: Optimizado para todas las densidades

## 🔧 Personalización

### Temas
Los temas se pueden personalizar en `lib/constants/app_theme.dart`:

```dart
// Modificar colores primarios
static const ColorScheme _lightColorScheme = ColorScheme(
  primary: Color(0xFF6750A4), // Cambiar color primario
  // ... otros colores
);
```

### Textos
Los textos se centralizan en `lib/constants/app_constants.dart`:

```dart
class AppStrings {
  static const String loginTitle = 'Iniciar Sesión';
  // ... otros textos
}
```

### Productos
Los productos de ejemplo están en `lib/services/product_service.dart` y se pueden modificar fácilmente.

## 🤝 Contribución

Este proyecto está diseñado como base para desarrollo de aplicaciones Flutter. Las mejoras son bienvenidas:

1. Fork del proyecto
2. Crear rama para nueva funcionalidad
3. Commit de cambios
4. Push a la rama
5. Crear Pull Request

## 📄 Licencia

Este proyecto es de código abierto y está disponible bajo la [Licencia MIT](LICENSE).

## 👨‍💻 Autor

Desarrollado como proyecto de ejemplo para demostrar mejores prácticas en Flutter con Material Design 3.

---

**Versión**: 1.0.0  
**Última actualización**: 2024  
**Flutter**: 3.8.1+  
**Material Design**: 3.0

// Importación principal del framework de Flutter para usar los Widgets y el Material Design.
import 'package:flutter/material.dart';

// Importación de la pantalla principal donde ocurre toda la lógica y animaciones de tu portfolio.
import 'estacion_principal.dart'; 

/// Función principal [main]. 
/// Es el punto de entrada absoluto de la aplicación. Es lo primero que lee y ejecuta Flutter.
void main() {
  // runApp toma el widget raíz y lo "infla" para mostrarlo en la pantalla.
  runApp(const AplicacionPortfolio());
}

/// [AplicacionPortfolio] es el Widget raíz de todo el proyecto.
/// Su única responsabilidad es configurar la estructura base de la app (el MaterialApp).
class AplicacionPortfolio extends StatelessWidget {
  
  // Constructor constante (const). Al usar 'const', le decimos a Flutter que este widget 
  // nunca cambia por sí solo, lo que ahorra memoria y mejora el rendimiento general.
  const AplicacionPortfolio({super.key});

  /// El método [build] es el que dibuja la interfaz (UI) de este widget en la pantalla.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Desactiva la etiqueta roja o banner de "DEBUG" que aparece arriba a la derecha en desarrollo.
      debugShowCheckedModeBanner: false,
      
      // Establece el tema global de la aplicación. 
      // Al usar ThemeData.dark(), le decimos a Flutter que los colores por defecto 
      // de fondos y textos sean oscuros, ideal para tu estética Cyberpunk/Terminal.
      theme: ThemeData.dark(),
      
      // La propiedad [home] define cuál es la primera pantalla que verá el usuario.
      // Aquí llamamos a tu clase EstacionPrincipal para iniciar el sistema del metro.
      home: const EstacionPrincipal(),
    );
  }
}
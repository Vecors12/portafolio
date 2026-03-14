// Importación principal de Flutter
import 'package:flutter/material.dart';

/// [VisorTren] es el panel digital holográfico que aparece en el centro del tren.
/// Muestra el destino actual ("LOREN", "CV", "PROYECTOS", etc.).
class VisorTren extends StatelessWidget {
  // ==========================================
  // PROPIEDADES INMUTABLES
  // ==========================================

  /// El texto gigante que se mostrará en el centro del visor.
  final String titulo;

  /// Constructor estricto.
  const VisorTren({super.key, required this.titulo});

  // ==========================================
  // CONSTRUCCIÓN VISUAL
  // ==========================================

  @override
  Widget build(BuildContext context) {
    // 1. DETECCIÓN DE PANTALLA: Calculamos el ancho disponible
    double anchoPantalla = MediaQuery.of(context).size.width;
    bool esMovil = anchoPantalla < 600;

    return Container(
      // 2. TAMAÑO DINÁMICO: 440px en PC, 85% del ancho en móvil
      width: esMovil ? anchoPantalla * 0.85 : 440,
      height: esMovil ? 160 : 210, // Más bajito en móvil
      // Decoración del panel: Fondo azul muy oscuro con borde de neón cyan
      decoration: BoxDecoration(
        color: const Color(0xFF051122).withOpacity(0.95),
        border: Border.all(color: Colors.cyan.withOpacity(0.8), width: 2),
        // Brillo exterior para dar el efecto de luz holográfica
        boxShadow: [
          BoxShadow(color: Colors.cyan.withOpacity(0.2), blurRadius: 40)
        ],
      ),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // 1. Texto principal holográfico adaptable
          _construirTextoPrincipal(titulo, esMovil),

          const SizedBox(height: 15),

          // 2. Línea divisoria decorativa
          Container(
              width: esMovil ? 80 : 120,
              height: 1.5,
              color: Colors.cyan.withOpacity(0.4)),

          const SizedBox(height: 15),

          // 3. Subtítulo de estado del sistema adaptable
          _construirSubtituloEstado(
              "NEXT STOP: $titulo // SYSTEM_STABLE", esMovil),
        ]),
      ),
    );
  }

  // ==========================================
  // WIDGETS PRIVADOS DE DIBUJO
  // ==========================================

  /// Dibuja el texto gigante con sombras para crear un efecto brillante.
  Widget _construirTextoPrincipal(String texto, bool esMovil) {
    return Text(
      texto,
      textAlign: TextAlign.center, // Vital para móviles
      style: TextStyle(
        color: const Color(0xFF00FFFF), // Cyan puro
        fontSize: esMovil ? 28 : 42, // Se encoge en móvil
        fontWeight: FontWeight.w900,
        letterSpacing: esMovil ? 6 : 10,
        // Sombra doble para el efecto neón intenso
        shadows: const [Shadow(color: Colors.cyan, blurRadius: 15)],
      ),
    );
  }

  /// Dibuja el texto pequeño estilo terminal debajo de la línea.
  Widget _construirSubtituloEstado(String texto, bool esMovil) {
    return Text(
      texto,
      textAlign: TextAlign.center, // Vital para móviles
      style: TextStyle(
        color: Colors.cyan.withOpacity(0.5),
        fontSize: esMovil ? 7 : 9,
        letterSpacing: esMovil ? 1.5 : 3,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}

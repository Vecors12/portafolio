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
  const VisorTren({
    super.key, 
    required this.titulo
  });

  // ==========================================
  // CONSTRUCCIÓN VISUAL
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 440,
      height: 210,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            // 1. Texto principal holográfico
            _construirTextoPrincipal(titulo),
            
            const SizedBox(height: 15),
            
            // 2. Línea divisoria decorativa
            Container(
              width: 120, 
              height: 1.5, 
              color: Colors.cyan.withOpacity(0.4)
            ),
            
            const SizedBox(height: 15),
            
            // 3. Subtítulo de estado del sistema
            _construirSubtituloEstado("NEXT STOP: $titulo // SYSTEM_STABLE"),
          ]
        ),
      ),
    );
  }

  // ==========================================
  // WIDGETS PRIVADOS DE DIBUJO
  // ==========================================

  /// Dibuja el texto gigante con sombras para crear un efecto brillante.
  Widget _construirTextoPrincipal(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        color: Color(0xFF00FFFF), // Cyan puro
        fontSize: 42,
        fontWeight: FontWeight.w900,
        letterSpacing: 10,
        // Sombra doble para el efecto neón intenso
        shadows: [Shadow(color: Colors.cyan, blurRadius: 15)],
      ),
    );
  }

  /// Dibuja el texto pequeño estilo terminal debajo de la línea.
  Widget _construirSubtituloEstado(String texto) {
    return Text(
      texto,
      style: TextStyle(
        color: Colors.cyan.withOpacity(0.5),
        fontSize: 9,
        letterSpacing: 3,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}
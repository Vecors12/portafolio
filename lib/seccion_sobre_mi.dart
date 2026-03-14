import 'package:flutter/material.dart';

class SeccionSobreMi extends StatelessWidget {
  const SeccionSobreMi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05080A), // Fondo oscuro profundo
      body: Stack(
        children: [
          // Fondo con la imagen de la ciudad oscurecida para darle profundidad
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                'assets/image_0.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
          ),

          // Efecto de cuadrícula de fondo (Grid)
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(),
            ),
          ),

          // CONTENIDO DESPLAZABLE (Scroll)
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BOTÓN DE VOLVER (Para subir al tren de vuelta)
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_back_ios,
                          color: Colors.cyanAccent, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        "VOLVER AL ANDÉN",
                        style: TextStyle(
                          color: Colors.cyanAccent.withValues(alpha: 0.8),
                          fontSize: 12,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // TÍTULO DE LA SECCIÓN
                const Text(
                  "REGISTRO DE USUARIO // LOREN",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 5,
                    shadows: [Shadow(color: Colors.cyan, blurRadius: 20)],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 40),
                  height: 2,
                  width: 150,
                  color: Colors.cyanAccent,
                ),

                // BLOQUE 1: EVOLUCIÓN PROFESIONAL
                _construirBloqueInfo(
                  "01 // UPGRADE PROFESIONAL",
                  "Mi cambio de sector hacia el mundo IT. De trabajar duro en otros sectores a sumergirme en el código, el diseño de arquitecturas y el desarrollo de software. Un camino de aprendizaje continuo y evolución constante.",
                  Colors.lightGreenAccent,
                ),

                const SizedBox(height: 40),

                // BLOQUE 2: EXPERIENCIA INTERNACIONAL
                _construirBloqueInfo(
                  "02 // RUTAS TRAZADAS",
                  "Experiencia internacional. Mi etapa viviendo y trabajando en Alemania. Adaptabilidad a nuevas culturas, aprendizaje de idiomas (Deutsch, English) y capacidad para resolver problemas fuera de la zona de confort.",
                  Colors.orangeAccent,
                ),

                const SizedBox(height: 40),

                // BLOQUE 3: EL FUTURO
                _construirBloqueInfo(
                  "03 // DESTINO FIJADO",
                  "Hacia dónde quiero llegar. Mis metas en el desarrollo de aplicaciones móviles multiplataforma, seguridad IT y la creación de soluciones digitales que marquen la diferencia.",
                  Colors.pinkAccent,
                ),

                const SizedBox(
                    height:
                        80), // Espacio al final para poder hacer scroll cómodo
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget reutilizable para crear los bloques de texto con estilo Cyberpunk
  Widget _construirBloqueInfo(String titulo, String texto, Color colorAcento) {
    return Container(
      width:
          800, // Ancho máximo para que no se estire demasiado en pantallas grandes
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0F16).withValues(alpha: 0.8),
        border: Border.all(color: colorAcento.withValues(alpha: 0.3), width: 1),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: colorAcento.withValues(alpha: 0.05),
            blurRadius: 20,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: TextStyle(
              color: colorAcento,
              fontSize: 18,
              letterSpacing: 3,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 15),
          Text(
            texto,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.6, // Interlineado para que se lea genial
            ),
          ),
        ],
      ),
    );
  }
}

// Pintor para hacer una cuadrícula de fondo sutil (estilo plano arquitectónico)
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    // Líneas verticales
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    // Líneas horizontales
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

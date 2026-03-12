// Importación principal de Flutter
import 'package:flutter/material.dart';

// Importaciones para temporizadores (Timer) y matemáticas complejas (Point, pow, Random)
import 'dart:async';
import 'dart:math';

/// [SueloEstacionRealista] genera un fondo con efecto de perspectiva 3D (estilo Synthwave/Cyberpunk).
/// Es un [StatefulWidget] porque genera "glitches" (parpadeos visuales) en posiciones aleatorias cada pocos milisegundos.
class SueloEstacionRealista extends StatefulWidget {
  const SueloEstacionRealista({super.key});
  
  @override
  State<SueloEstacionRealista> createState() => _SueloEstacionRealistaState();
}

class _SueloEstacionRealistaState extends State<SueloEstacionRealista> {
  
  // ==========================================
  // ESTADO PRIVADO
  // ==========================================

  /// Lista de coordenadas (X, Y) donde aparecerá un cuadro brillante de fallo visual (Glitch).
  List<Point<int>> _puntosGlitch = [];
  
  /// Temporizador que controla la frecuencia de aparición de los glitches.
  Timer? _temporizadorGlitch;

  @override
  void initState() {
    super.initState();
    // Inicia un bucle: Cada 180 milisegundos decide si dibuja un glitch o no.
    _temporizadorGlitch = Timer.periodic(const Duration(milliseconds: 180), (t) {
      if (mounted) {
        setState(() {
          // 30% de probabilidad de que aparezca un glitch nuevo (random > 6 sobre 10)
          _puntosGlitch = Random().nextInt(10) > 6
              ? [Point(Random().nextInt(8), Random().nextInt(18))] // Crea un punto aleatorio en la rejilla
              : []; // Borra el glitch
        });
      }
    });
  }

  @override
  void dispose() {
    // BLINDAJE: Es obligatorio cancelar el temporizador al salir de la app para evitar fugas de memoria.
    _temporizadorGlitch?.cancel();
    super.dispose();
  }

  // ==========================================
  // CONSTRUCCIÓN VISUAL
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: const BoxDecoration(
        // Línea amarilla de seguridad al borde del andén
        border: Border(top: BorderSide(color: Colors.yellow, width: 3)),
        // Gradiente oscuro que da profundidad hacia el horizonte
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D1B2A), Colors.black]
        )
      ),
      // Inyectamos nuestro CustomPainter pasándole los puntos actuales de glitch
      child: CustomPaint(painter: _PintorRejilla3D(_puntosGlitch)),
    );
  }
}

// =========================================================================
// PINTOR GPU: DIBUJO DE LA REJILLA EN PERSPECTIVA
// =========================================================================

class _PintorRejilla3D extends CustomPainter {
  final List<Point<int>> puntosGlitchActivos;
  
  _PintorRejilla3D(this.puntosGlitchActivos);

  @override
  void paint(Canvas lienzo, Size tamanoLienzo) {
    final ancho = tamanoLienzo.width;
    final alto = tamanoLienzo.height;
    
    // Configuración del pincel para las líneas de neón
    final pincelLinea = Paint()
      ..color = Colors.cyan.withOpacity(0.15)
      ..strokeWidth = 1;
      
    List<double> coordenadasY = [];

    // 1. DIBUJAR LÍNEAS HORIZONTALES (Con curva de perspectiva)
    for (int i = 0; i <= 10; i++) {
      // Uso de la función 'pow' (potencia) para que las líneas estén más juntas en el horizonte
      // y más separadas cerca de la cámara.
      double posY = pow(i / 10, 1.8) * alto;
      coordenadasY.add(posY);
      lienzo.drawLine(Offset(0, posY), Offset(ancho, posY), pincelLinea);
    }

    // 2. DIBUJAR LÍNEAS VERTICALES (Fugando hacia el centro)
    for (int i = 0; i <= 20; i++) {
      lienzo.drawLine(
          Offset((ancho / 20) * i, 0), // Punto de origen arriba
          Offset((ancho * 1.6 / 20) * (i - 4), alto), // Punto de destino abajo expandido
          pincelLinea);
    }

    // 3. DIBUJAR LOS EFECTOS DE GLITCH
    for (var celda in puntosGlitchActivos) {
      // Calculamos las 4 esquinas del trapecio que forma la celda en perspectiva
      double ySuperior = coordenadasY[celda.x];
      double yInferior = coordenadasY[celda.x + 1];
      
      // Función matemática para calcular la posición X en perspectiva basada en la Y
      double calcularPerspectivaX(double fraccionX, double posY) =>
          (ancho * fraccionX) + ((ancho * 1.6 * (fraccionX - 0.2)) - (ancho * fraccionX)) * (posY / alto);

      // Creamos el polígono de la celda afectada
      var rutaGlitch = Path()
        ..moveTo(calcularPerspectivaX(celda.y / 20, ySuperior), ySuperior)
        ..lineTo(calcularPerspectivaX((celda.y + 1) / 20, ySuperior), ySuperior)
        ..lineTo(calcularPerspectivaX((celda.y + 1) / 20, yInferior), yInferior)
        ..lineTo(calcularPerspectivaX(celda.y / 20, yInferior), yInferior)
        ..close();

      // Lo pintamos con un filtro de desenfoque (MaskFilter.blur) para que brille como luz de neón
      lienzo.drawPath(
          rutaGlitch,
          Paint()
            ..color = Colors.cyan.withOpacity(0.4)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
    }
  }

  /// Al devolver true, le decimos a Flutter que repinte la pantalla siempre que cambien los glitches
  @override
  bool shouldRepaint(_PintorRejilla3D viejoPintor) => true;
}
// Importación principal de Flutter
import 'package:flutter/material.dart';

// Importaciones para controlar el tiempo y el azar
import 'dart:async';
import 'dart:math';

/// [GlitchEfecto] es un widget "Envoltorio" (Wrapper).
/// Cualquier widget que coloques dentro de él (texto, imagen) sufrirá
/// un efecto de parpadeo estroboscópico aleatorio, simulando un fallo electrónico.
class GlitchEfecto extends StatefulWidget {
  /// El widget que queremos hacer parpadear.
  final Widget hijo;

  const GlitchEfecto({super.key, required this.hijo});

  @override
  State<GlitchEfecto> createState() => _GlitchEfectoState();
}

class _GlitchEfectoState extends State<GlitchEfecto> {
  // ==========================================
  // ESTADO PRIVADO
  // ==========================================

  /// Temporizador que ejecuta la evaluación del parpadeo cada fracción de segundo.
  Timer? _temporizadorParpadeo;

  /// Estado que define si el widget interior debe verse totalmente sólido (true) o tenue (false).
  bool _esVisibleFull = true;

  @override
  void initState() {
    super.initState();
    // Bucle continuo: Cada 200 milisegundos tira una moneda al aire (Random().nextBool())
    // para decidir si el widget brillará al 100% o se oscurecerá al 30%.
    _temporizadorParpadeo =
        Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (mounted) {
        setState(() => _esVisibleFull = Random().nextBool());
      }
    });
  }

  @override
  void dispose() {
    // BLINDAJE: Fundamental destruir el timer al salir de la pantalla
    // para que no siga calculando de fondo y agote la batería del móvil.
    _temporizadorParpadeo?.cancel();
    super.dispose();
  }

  // ==========================================
  // CONSTRUCCIÓN VISUAL
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Opacity(
      // Si el azar dijo true, opacidad 1.0 (sólido). Si dijo false, opacidad 0.3 (casi invisible)
      opacity: _esVisibleFull ? 1.0 : 0.3,
      child: widget.hijo, // Renderiza el widget que le hemos pasado
    );
  }
}

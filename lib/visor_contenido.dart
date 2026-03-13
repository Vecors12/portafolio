import 'package:flutter/material.dart';

class VisorTren extends StatelessWidget {
  final String titulo;

  const VisorTren({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double escala = w < 800 ? w / 800 : 1.0;

    return Container(
      width: 440 * escala,
      height: 210 * (escala < 1.0 ? escala * 1.2 : 1.0), // Que no se aplaste demasiado
      decoration: BoxDecoration(
        color: const Color(0xFF051122).withOpacity(0.95),
        border: Border.all(color: Colors.cyan.withOpacity(0.8), width: 2 * escala),
        boxShadow: [BoxShadow(color: Colors.cyan.withOpacity(0.2), blurRadius: 40 * escala)],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            _construirTextoPrincipal(titulo, escala),
            SizedBox(height: 15 * escala),
            Container(width: 120 * escala, height: 1.5 * escala, color: Colors.cyan.withOpacity(0.4)),
            SizedBox(height: 15 * escala),
            _construirSubtituloEstado("NEXT STOP: $titulo // SYSTEM_STABLE", escala),
          ]
        ),
      ),
    );
  }

  Widget _construirTextoPrincipal(String texto, double escala) {
    return Text(
      texto,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: const Color(0xFF00FFFF),
        fontSize: 42 * escala,
        fontWeight: FontWeight.w900,
        letterSpacing: 10 * escala,
        shadows: [Shadow(color: Colors.cyan, blurRadius: 15 * escala)],
      ),
    );
  }

  Widget _construirSubtituloEstado(String texto, double escala) {
    return Text(
      texto,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.cyan.withOpacity(0.5),
        fontSize: 9 * escala,
        letterSpacing: 3 * escala,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}
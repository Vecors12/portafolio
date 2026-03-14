import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

/// El suelo ya NO calcula su propia altura.
/// Recibe [altura] desde _MedidasEscenario para estar siempre sincronizado.
class SueloEstacionRealista extends StatefulWidget {
  final double altura;
  const SueloEstacionRealista({super.key, required this.altura});

  @override
  State<SueloEstacionRealista> createState() => _SueloEstacionRealistaState();
}

class _SueloEstacionRealistaState extends State<SueloEstacionRealista> {
  List<Point<int>> glitches = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 180), (t) {
      if (mounted) {
        setState(() => glitches = Random().nextInt(10) > 6
            ? [Point(Random().nextInt(8), Random().nextInt(18))]
            : []);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.altura,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.yellow, width: 3)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0D1B2A), Colors.black],
        ),
      ),
      child: CustomPaint(painter: _RejillaPainter(glitches)),
    );
  }
}

class _RejillaPainter extends CustomPainter {
  final List<Point<int>> glitches;
  _RejillaPainter(this.glitches);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final pL = Paint()
      ..color = Colors.cyan.withOpacity(0.15)
      ..strokeWidth = 1;
    List<double> yC = [];
    for (int i = 0; i <= 10; i++) {
      double y = pow(i / 10, 1.8) * h;
      yC.add(y);
      canvas.drawLine(Offset(0, y), Offset(w, y), pL);
    }
    for (int i = 0; i <= 20; i++) {
      canvas.drawLine(
          Offset((w / 20) * i, 0), Offset((w * 1.6 / 20) * (i - 4), h), pL);
    }
    for (var cell in glitches) {
      double y1 = yC[cell.x];
      double y2 = yC[cell.x + 1];
      double cX(double f, double y) =>
          (w * f) + ((w * 1.6 * (f - 0.2)) - (w * f)) * (y / h);
      var path = Path()
        ..moveTo(cX(cell.y / 20, y1), y1)
        ..lineTo(cX((cell.y + 1) / 20, y1), y1)
        ..lineTo(cX((cell.y + 1) / 20, y2), y2)
        ..lineTo(cX(cell.y / 20, y2), y2)
        ..close();
      canvas.drawPath(
          path,
          Paint()
            ..color = Colors.cyan.withOpacity(0.4)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
    }
  }

  @override
  bool shouldRepaint(_RejillaPainter old) => true;
}
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

// =========================================================================
// WIDGET 1: PERSONAJE NPC
// =========================================================================
class PersonajeNPC extends StatefulWidget {
  final bool vaAlTren;
  const PersonajeNPC({super.key, required this.vaAlTren});

  @override
  State<PersonajeNPC> createState() => _PersonajeNPCState();
}

class _PersonajeNPCState extends State<PersonajeNPC>
    with TickerProviderStateMixin {
  double _posicionXRelativa = 0.5;
  double _objetivoX = 0.5;
  bool _estaCaminando = false;
  int _duracionViajeMs = 0;
  double _anguloInclinacion = 0.0;

  String _imagenAnterior = 'assets/avatar_frente.png';
  String _imagenActual = 'assets/avatar_frente.png';

  late Timer _temporizadorIA;
  final Random _generadorAzar = Random();
  late AnimationController _controladorPasos;
  late AnimationController _controladorTransicionImagen;

  @override
  void initState() {
    super.initState();
    _imagenActual = widget.vaAlTren
        ? 'assets/avatar_espalda.png'
        : 'assets/avatar_frente.png';
    _imagenAnterior = _imagenActual;

    _controladorPasos = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));

    _controladorTransicionImagen = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250))
      ..value = 1.0;

    _temporizadorIA = Timer.periodic(const Duration(milliseconds: 3500), (t) {
      if (mounted && !widget.vaAlTren && !_estaCaminando)
        _tomarDecisionCaminar();
    });
  }

  @override
  void didUpdateWidget(PersonajeNPC oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.vaAlTren && !widget.vaAlTren) {
      _reiniciarEstadoCaminata();
      _cambiarSprite('assets/avatar_frente.png');
    } else if (!oldWidget.vaAlTren && widget.vaAlTren) {
      _reiniciarEstadoCaminata();
      _cambiarSprite('assets/avatar_espalda.png');
    }
  }

  void _reiniciarEstadoCaminata() {
    setState(() {
      _posicionXRelativa = 0.5;
      _objetivoX = 0.5;
      _estaCaminando = false;
      _anguloInclinacion = 0.0;
      _duracionViajeMs = 0;
      _controladorPasos.stop();
      _controladorPasos.reset();
    });
  }

  @override
  void dispose() {
    _temporizadorIA.cancel();
    _controladorPasos.dispose();
    _controladorTransicionImagen.dispose();
    super.dispose();
  }

  void _cambiarSprite(String nuevaRuta) {
    if (_imagenActual == nuevaRuta) return;
    setState(() {
      _imagenAnterior = _imagenActual;
      _imagenActual = nuevaRuta;
    });
    _controladorTransicionImagen.forward(from: 0.0);
  }

  void _tomarDecisionCaminar() {
    int probabilidad = _generadorAzar.nextInt(100);
    if (probabilidad < 30) {
      _cambiarSprite('assets/avatar_frente.png');
    } else if (probabilidad < 50) {
      _cambiarSprite('assets/avatar_espalda.png');
    } else {
      _objetivoX = 0.1 + _generadorAzar.nextDouble() * 0.8;
      _iniciarCaminata();
    }
  }

  void _iniciarCaminata() {
    bool vaHaciaIzquierda = _objetivoX < _posicionXRelativa;
    setState(() {
      _estaCaminando = true;
      _anguloInclinacion = vaHaciaIzquierda ? -0.05 : 0.05;
    });
    _cambiarSprite(vaHaciaIzquierda
        ? 'assets/avatar_perfilizquierdo.png'
        : 'assets/avatar_perfilderecho.png');
    _controladorPasos.repeat(reverse: true);

    int msCalculados = ((_objetivoX - _posicionXRelativa).abs() * 8000)
        .toInt()
        .clamp(2500, 8000);

    setState(() {
      _posicionXRelativa = _objetivoX;
      _duracionViajeMs = msCalculados;
    });

    Future.delayed(Duration(milliseconds: msCalculados), () {
      if (mounted && !widget.vaAlTren && _estaCaminando) {
        setState(() {
          _estaCaminando = false;
          _anguloInclinacion = 0.0;
          _controladorPasos.stop();
          _controladorPasos.reset();
        });
        _cambiarSprite(_generadorAzar.nextBool()
            ? 'assets/avatar_frente.png'
            : 'assets/avatar_espalda.png');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double anchoPantalla = MediaQuery.of(context).size.width;
    final bool esMovil = anchoPantalla < 600;
    // Móvil: 60% del ancho para que sea bien visible. PC: 35% original.
    final double anchoAvatar = anchoPantalla * (esMovil ? 0.60 : 0.35);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedPositioned(
          duration: _estaCaminando
              ? Duration(milliseconds: _duracionViajeMs)
              : Duration.zero,
          curve: Curves.easeInOutCubic,
          left: _posicionXRelativa * (anchoPantalla - anchoAvatar),
          top: 0,
          bottom: 0,
          width: anchoAvatar,
          child: AnimatedBuilder(
            animation: Listenable.merge(
                [_controladorPasos, _controladorTransicionImagen]),
            builder: (context, child) {
              double reboteY = _estaCaminando
                  ? sin(_controladorPasos.value * pi) * 10.0
                  : 0.0;
              double inclinacion = _estaCaminando ? _anguloInclinacion : 0.0;
              return Transform(
                alignment: Alignment.bottomCenter,
                transform: Matrix4.identity()
                  ..translate(0.0, -reboteY, 0.0)
                  ..rotateZ(inclinacion),
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Opacity(
                          opacity: 1.0 - _controladorTransicionImagen.value,
                          child: _construirImagenAvatar(_imagenAnterior)),
                      Opacity(
                          opacity: _controladorTransicionImagen.value,
                          child: _construirImagenAvatar(_imagenActual)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _construirImagenAvatar(String ruta) => Image.asset(
        ruta,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        errorBuilder: (context, error, stackTrace) => const SizedBox(),
      );
}

// =========================================================================
// WIDGET 2: MURO DE VÍAS Y GRAFITIS
// =========================================================================
class ForegroundMuroVias extends StatelessWidget {
  const ForegroundMuroVias({super.key});

  @override
  Widget build(BuildContext context) =>
      const CustomPaint(painter: _MuroViasPainter(), size: Size.infinite);
}

class _MuroViasPainter extends CustomPainter {
  const _MuroViasPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Base de diseño: h=320px (PC). Todo escala desde aquí.
    final double factorY = h / 320.0;
    final double factorEscala = factorY.clamp(0.45, 1.2);
    final bool esMovil = w < 600;

    // 1. Muro oscuro — 75% superior del widget
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h * 0.75),
        Paint()..color = const Color(0xFF0D0D15));

    // 2. Líneas horizontales tenues
    final pincelLineas = Paint()
      ..color = Colors.orange.withOpacity(0.12)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < 6; i++) {
      final double y = (h * 0.75 / 5) * i;
      canvas.drawLine(Offset(0, y), Offset(w, y), pincelLineas);
    }

    // 3. Grafitis — posiciones X adaptadas en móvil para no amontonarse
    _g(canvas, "FLUTTER",     Offset(w * 0.05, 30  * factorY), Colors.cyanAccent,       32 * factorEscala, -0.05);
    _g(canvas, "SQL",         Offset(w * 0.08, 190 * factorY), Colors.cyan,              24 * factorEscala,  0.04);
    _g(canvas, "LUCHADOR",    Offset(w * 0.02, 110 * factorY), Colors.red,               20 * factorEscala,  0.10);
    _g(canvas, "IT SECURITY", Offset(w * 0.18, 140 * factorY), Colors.lightGreenAccent,  22 * factorEscala,  0.02);
    _g(canvas, "RAP",         Offset(w * 0.28, 195 * factorY), Colors.redAccent,         28 * factorEscala, -0.10);
    _g(canvas, "CREATIVO",    Offset(w * 0.35,  40 * factorY), Colors.yellowAccent,      22 * factorEscala, -0.08);
    _g(canvas, "VIAJES",      Offset(w * 0.55,  20 * factorY), Colors.orange,            20 * factorEscala,  0.02);
    _g(canvas, "JAVA",        Offset(w * 0.68,  30 * factorY), Colors.orangeAccent,      26 * factorEscala, -0.02);
    _g(canvas, "SOÑADOR",     Offset(w * 0.42, 210 * factorY), Colors.blueAccent,        20 * factorEscala, -0.04);
    _g(canvas, "UNDERGROUND", Offset(w * 0.45, 140 * factorY), Colors.purpleAccent,      16 * factorEscala,  0.00);
    _g(canvas, "ARTISTA",     Offset(w * 0.60, 185 * factorY), Colors.pinkAccent,        22 * factorEscala,  0.05);
    // En móvil estas tres se reparten bien para no chocar
    _g(canvas, "PYTHON",  Offset(w * (esMovil ? 0.60 : 0.88),  60 * factorY), const Color(0xFF3776AB), 26 * factorEscala,  0.05);
    _g(canvas, "DEUTSCH", Offset(w * (esMovil ? 0.42 : 0.83), 205 * factorY), Colors.white70,          18 * factorEscala, -0.05);
    _g(canvas, "ENGLISH", Offset(w * (esMovil ? 0.75 : 0.91), 165 * factorY), Colors.white70,          18 * factorEscala,  0.08);

    // 4. Plataforma y andén
    canvas.drawRect(Rect.fromLTWH(0, h * 0.750, w, h * 0.063),
        Paint()..color = const Color(0xFF0A0C10));
    canvas.drawRect(Rect.fromLTWH(0, h * 0.813, w, h * 0.187),
        Paint()..color = Colors.black);

    // 5. Marcas de textura
    for (double x = 0; x < w; x += 45) {
      canvas.drawRect(Rect.fromLTWH(x, h * 0.844, 25, h * 0.125),
          Paint()..color = const Color(0xFF1E2228));
    }

    // 6. Raíles
    final pincelRailes = Paint()
      ..color = Colors.cyan.withOpacity(0.3)
      ..strokeWidth = 3;
    canvas.drawLine(Offset(0, h * 0.859), Offset(w, h * 0.859), pincelRailes);
    canvas.drawLine(Offset(0, h * 0.953), Offset(w, h * 0.953), pincelRailes);
  }

  void _g(Canvas lienzo, String texto, Offset pos, Color color,
      double size, double angulo) {
    final tp = TextPainter(
        text: TextSpan(
            text: texto,
            style: TextStyle(
                color: color.withOpacity(0.6),
                fontSize: size,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
                shadows: [Shadow(color: color.withOpacity(0.8), blurRadius: 10)])),
        textDirection: TextDirection.ltr)
      ..layout();
    lienzo.save();
    lienzo.translate(pos.dx, pos.dy);
    lienzo.rotate(angulo);
    tp.paint(lienzo, Offset.zero);
    lienzo.restore();
  }

  @override
  bool shouldRepaint(_MuroViasPainter old) => false;
}
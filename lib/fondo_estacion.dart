import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

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
    double anchoPantalla = MediaQuery.of(context).size.width;
    double anchoAvatar = anchoPantalla * 0.35;
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

class ForegroundMuroVias extends StatelessWidget {
  const ForegroundMuroVias({super.key});
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _MuroViasPainter(MediaQuery.of(context).size.width));
}

class _MuroViasPainter extends CustomPainter {
  final double widthPantalla;
  const _MuroViasPainter(this.widthPantalla);

  @override
  void paint(Canvas canvas, Size size) {
    final anchoLienzo = size.width;

    // Calculamos el factor de escala en la pintura directamente
    double escala = widthPantalla < 800 ? widthPantalla / 800 : 1.0;

    canvas.drawRect(Rect.fromLTWH(0, 0, anchoLienzo, 240),
        Paint()..color = const Color(0xFF0D0D15));

    final pincelLineas = Paint()
      ..color = Colors.orange.withOpacity(0.12)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < 6; i++) {
      canvas.drawLine(Offset(0, (i * 45).toDouble()),
          Offset(anchoLienzo, (i * 45).toDouble()), pincelLineas);
    }

    _dibujarTextoGraffiti(canvas, "FLUTTER", Offset(anchoLienzo * 0.05, 30),
        Colors.cyanAccent, 32 * escala, -0.05);
    _dibujarTextoGraffiti(canvas, "SQL", Offset(anchoLienzo * 0.08, 190),
        Colors.cyan, 24 * escala, 0.04);
    _dibujarTextoGraffiti(canvas, "LUCHADOR", Offset(anchoLienzo * 0.02, 110),
        Colors.red, 20 * escala, 0.1);
    _dibujarTextoGraffiti(
        canvas,
        "IT SECURITY",
        Offset(anchoLienzo * 0.18, 140),
        Colors.lightGreenAccent,
        24 * escala,
        0.02);
    _dibujarTextoGraffiti(canvas, "RAP", Offset(anchoLienzo * 0.28, 195),
        Colors.redAccent, 28 * escala, -0.1);
    _dibujarTextoGraffiti(canvas, "CREATIVO", Offset(anchoLienzo * 0.35, 40),
        Colors.yellowAccent, 22 * escala, -0.08);
    _dibujarTextoGraffiti(canvas, "VIAJES", Offset(anchoLienzo * 0.55, 20),
        Colors.orange, 20 * escala, 0.02);
    _dibujarTextoGraffiti(canvas, "JAVA", Offset(anchoLienzo * 0.72, 30),
        Colors.orangeAccent, 26 * escala, -0.02);
    _dibujarTextoGraffiti(canvas, "PYTHON", Offset(anchoLienzo * 0.90, 40),
        const Color(0xFF3776AB), 28 * escala, 0.05);
    _dibujarTextoGraffiti(canvas, "ARTISTA", Offset(anchoLienzo * 0.60, 185),
        Colors.pinkAccent, 22 * escala, 0.05);
    _dibujarTextoGraffiti(canvas, "DEUTSCH", Offset(anchoLienzo * 0.85, 200),
        Colors.white70, 18 * escala, -0.05);
    _dibujarTextoGraffiti(canvas, "ENGLISH", Offset(anchoLienzo * 0.93, 165),
        Colors.white70, 18 * escala, 0.08);
    _dibujarTextoGraffiti(canvas, "SOÑADOR", Offset(anchoLienzo * 0.42, 210),
        Colors.blueAccent, 20 * escala, -0.04);
    _dibujarTextoGraffiti(canvas, "UNDERGROUND",
        Offset(anchoLienzo * 0.45, 140), Colors.purpleAccent, 16 * escala, 0.0);

    canvas.drawRect(Rect.fromLTWH(0, 240, anchoLienzo, 20),
        Paint()..color = const Color(0xFF0A0C10));
    canvas.drawRect(
        Rect.fromLTWH(0, 260, anchoLienzo, 60), Paint()..color = Colors.black);

    for (double x = 0; x < anchoLienzo; x += 45) {
      canvas.drawRect(Rect.fromLTWH(x, 270, 25, 40),
          Paint()..color = const Color(0xFF1E2228));
    }

    final pincelRaies = Paint()
      ..color = Colors.cyan.withOpacity(0.3)
      ..strokeWidth = 3;
    canvas.drawLine(
        const Offset(0, 275), Offset(anchoLienzo, 275), pincelRaies);
    canvas.drawLine(
        const Offset(0, 305), Offset(anchoLienzo, 305), pincelRaies);
  }

  void _dibujarTextoGraffiti(Canvas lienzo, String texto, Offset posicion,
      Color colorNeom, double tamanoTexto, double anguloRotacion) {
    final dibujanteTexto = TextPainter(
        text: TextSpan(
            text: texto,
            style: TextStyle(
                color: colorNeom.withOpacity(0.6),
                fontSize: tamanoTexto,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
                shadows: [
                  Shadow(color: colorNeom.withOpacity(0.8), blurRadius: 10)
                ])),
        textDirection: TextDirection.ltr)
      ..layout();

    lienzo.save();
    lienzo.translate(posicion.dx, posicion.dy);
    lienzo.rotate(anguloRotacion);
    dibujanteTexto.paint(lienzo, Offset.zero);
    lienzo.restore();
  }

  @override
  bool shouldRepaint(_MuroViasPainter old) =>
      old.widthPantalla != widthPantalla;
}

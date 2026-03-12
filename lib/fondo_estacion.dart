// Importaciones principales del framework
import 'package:flutter/material.dart';

// Importaciones para las matemáticas (seno, pi) y los temporizadores de IA
import 'dart:async';
import 'dart:math';

// =========================================================================
// WIDGET 1: PERSONAJE NPC (Inteligencia Artificial Básica y Animación)
// =========================================================================

/// [PersonajeNPC] dibuja al avatar en el andén. Contiene lógica para caminar 
/// aleatoriamente o subir al tren cuando el sistema navega a otra pantalla.
class PersonajeNPC extends StatefulWidget {
  
  /// Indica si el personaje debe iniciar la animación de subirse al tren (dar la espalda y achicarse).
  final bool vaAlTren;
  
  const PersonajeNPC({super.key, required this.vaAlTren});
  
  @override
  State<PersonajeNPC> createState() => _PersonajeNPCState();
}

class _PersonajeNPCState extends State<PersonajeNPC> with TickerProviderStateMixin {
  
  // VARIABLES DE ESTADO Y MOVIMIENTO
  double _posicionXRelativa = 0.5; // De 0.0 (Izquierda) a 1.0 (Derecha)
  double _objetivoX = 0.5;         // A dónde se dirige el NPC
  bool _estaCaminando = false;
  int _duracionViajeMs = 0;        // Cuánto tarda en llegar al objetivo
  double _anguloInclinacion = 0.0; // Balanceo al caminar

  // VARIABLES DE SPRITES (Imágenes)
  String _imagenAnterior = 'assets/avatar_frente.png';
  String _imagenActual = 'assets/avatar_frente.png';
  
  // MOTORES DE INTELIGENCIA Y ANIMACIÓN
  late Timer _temporizadorIA;
  final Random _generadorAzar = Random();
  late AnimationController _controladorPasos;
  late AnimationController _controladorTransicionImagen;

  @override
  void initState() {
    super.initState();
    
    // Configura la imagen inicial dependiendo de si empieza subiendo al tren o no
    _imagenActual = widget.vaAlTren ? 'assets/avatar_espalda.png' : 'assets/avatar_frente.png';
    _imagenAnterior = _imagenActual;
    
    // Controlador del "rebote" al caminar (simula los pasos)
    _controladorPasos = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
        
    // Controlador para fundir suavemente una imagen con otra (ej: de frente a perfil)
    _controladorTransicionImagen = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250))..value = 1.0;
        
    // El "Cerebro" del NPC: Cada 3.5 segundos toma una decisión si está quieto
    _temporizadorIA = Timer.periodic(const Duration(milliseconds: 3500), (t) {
      if (mounted && !widget.vaAlTren && !_estaCaminando) _tomarDecisionCaminar();
    });
  }

  /// Reacciona cuando EstacionPrincipal cambia la propiedad 'vaAlTren'
  @override
  void didUpdateWidget(PersonajeNPC oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.vaAlTren && !widget.vaAlTren) {
      // Bajar al andén: se reinician sus valores y mira al frente
      _reiniciarEstadoCaminata();
      _cambiarSprite('assets/avatar_frente.png');
    } else if (!oldWidget.vaAlTren && widget.vaAlTren) {
      // Subir al tren: aborta la caminata y da la espalda
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

  /// Transiciona suavemente (Fade-in/out) entre dos poses del avatar
  void _cambiarSprite(String nuevaRuta) {
    if (_imagenActual == nuevaRuta) return; // Evita redibujar si es la misma
    setState(() {
      _imagenAnterior = _imagenActual;
      _imagenActual = nuevaRuta;
    });
    _controladorTransicionImagen.forward(from: 0.0);
  }

  /// Lógica de probabilidad del personaje cuando está en reposo
  void _tomarDecisionCaminar() {
    int probabilidad = _generadorAzar.nextInt(100);
    if (probabilidad < 30) {
      _cambiarSprite('assets/avatar_frente.png');
    } else if (probabilidad < 50) {
      _cambiarSprite('assets/avatar_espalda.png');
    } else {
      // 50% de probabilidad de moverse a un nuevo punto (entre 0.1 y 0.9 de la pantalla)
      _objetivoX = 0.1 + _generadorAzar.nextDouble() * 0.8;
      _iniciarCaminata();
    }
  }

  /// Ejecuta los cálculos de tiempo y rotación para mover al NPC al _objetivoX
  void _iniciarCaminata() {
    bool vaHaciaIzquierda = _objetivoX < _posicionXRelativa;
    
    setState(() {
      _estaCaminando = true;
      _anguloInclinacion = vaHaciaIzquierda ? -0.05 : 0.05; // Lo inclina hacia donde anda
    });
    
    _cambiarSprite(vaHaciaIzquierda
        ? 'assets/avatar_perfilizquierdo.png'
        : 'assets/avatar_perfilderecho.png');
        
    _controladorPasos.repeat(reverse: true); // Activa el rebote de pasos
    
    // Calcula el tiempo que tardará basado en la distancia (Velocidad constante)
    int msCalculados = ((_objetivoX - _posicionXRelativa).abs() * 8000).toInt().clamp(2500, 8000);
    
    setState(() {
      _posicionXRelativa = _objetivoX;
      _duracionViajeMs = msCalculados;
    });

    // Temporizador que se dispara justo cuando el avatar llega a su destino
    Future.delayed(Duration(milliseconds: msCalculados), () {
      if (mounted && !widget.vaAlTren && _estaCaminando) {
        setState(() {
          _estaCaminando = false;
          _anguloInclinacion = 0.0;
          _controladorPasos.stop();
          _controladorPasos.reset();
        });
        // Al llegar, decide aleatoriamente si se queda de frente o de espaldas
        _cambiarSprite(_generadorAzar.nextBool()
            ? 'assets/avatar_frente.png'
            : 'assets/avatar_espalda.png');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double anchoPantalla = MediaQuery.of(context).size.width;
    double anchoAvatar = anchoPantalla * 0.35; // Ocupa un 35% de la pantalla para mantener proporción
    
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedPositioned(
          duration: _estaCaminando ? Duration(milliseconds: _duracionViajeMs) : Duration.zero,
          curve: Curves.easeInOutCubic,
          left: _posicionXRelativa * (anchoPantalla - anchoAvatar),
          top: 0,
          bottom: 0,
          width: anchoAvatar,
          // AnimatedBuilder escucha el controlador de pasos y de fade al mismo tiempo
          child: AnimatedBuilder(
            animation: Listenable.merge([_controladorPasos, _controladorTransicionImagen]),
            builder: (context, child) {
              
              // Matemáticas de animación: Usa el SENO (sin) para hacer un arco perfecto en cada paso
              double reboteY = _estaCaminando ? sin(_controladorPasos.value * pi) * 10.0 : 0.0;
              double inclinacion = _estaCaminando ? _anguloInclinacion : 0.0;
              
              return Transform(
                alignment: Alignment.bottomCenter,
                transform: Matrix4.identity()
                  ..translate(0.0, -reboteY, 0.0) // Lo sube y baja
                  ..rotateZ(inclinacion),         // Lo inclina
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      // Imagen que desaparece
                      Opacity(
                          opacity: 1.0 - _controladorTransicionImagen.value,
                          child: _construirImagenAvatar(_imagenAnterior)),
                      // Imagen que aparece
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

  /// Dibuja la imagen concreta evitando que la app rompa si falta algún asset
  Widget _construirImagenAvatar(String ruta) => Image.asset(
    ruta,
    fit: BoxFit.contain,
    filterQuality: FilterQuality.high,
    errorBuilder: (context, error, stackTrace) => const SizedBox(),
  );
}

// =========================================================================
// WIDGET 2: MURO DE VÍAS Y GRAFITIS (Renderizado por GPU)
// =========================================================================

/// [ForegroundMuroVias] gestiona el lienzo sobre el que dibujamos las vías
/// y los nombres de las tecnologías usando pintura digital de alta eficiencia.
class ForegroundMuroVias extends StatelessWidget {
  const ForegroundMuroVias({super.key});
  
  @override
  Widget build(BuildContext context) => const CustomPaint(painter: _MuroViasPainter());
}

class _MuroViasPainter extends CustomPainter {
  const _MuroViasPainter();
  
  @override
  void paint(Canvas canvas, Size size) {
    final anchoLienzo = size.width;
    
    // 1. Dibuja el muro oscuro del fondo
    canvas.drawRect(
        Rect.fromLTWH(0, 0, anchoLienzo, 240), Paint()..color = const Color(0xFF0D0D15));
        
    // 2. Dibuja las líneas horizontales tenues (Diseño Cyberpunk/Vector)
    final pincelLineas = Paint()
      ..color = Colors.orange.withOpacity(0.12)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
      
    for (int i = 0; i < 6; i++) {
      canvas.drawLine(
        Offset(0, (i * 45).toDouble()), 
        Offset(anchoLienzo, (i * 45).toDouble()), 
        pincelLineas);
    }
    
    // 3. PINTADO DE GRAFITIS (Skills y Palabras Clave)
    _dibujarTextoGraffiti(canvas, "FLUTTER", Offset(anchoLienzo * 0.05, 30), Colors.cyanAccent, 32, -0.05);
    _dibujarTextoGraffiti(canvas, "SQL", Offset(anchoLienzo * 0.08, 190), Colors.cyan, 24, 0.04);
    _dibujarTextoGraffiti(canvas, "LUCHADOR", Offset(anchoLienzo * 0.02, 110), Colors.red, 20, 0.1);
    _dibujarTextoGraffiti(canvas, "IT SECURITY", Offset(anchoLienzo * 0.18, 140), Colors.lightGreenAccent, 24, 0.02);
    _dibujarTextoGraffiti(canvas, "RAP", Offset(anchoLienzo * 0.28, 195), Colors.redAccent, 28, -0.1);
    _dibujarTextoGraffiti(canvas, "CREATIVO", Offset(anchoLienzo * 0.35, 40), Colors.yellowAccent, 22, -0.08);
    _dibujarTextoGraffiti(canvas, "VIAJES", Offset(anchoLienzo * 0.55, 20), Colors.orange, 20, 0.02);
    _dibujarTextoGraffiti(canvas, "JAVA", Offset(anchoLienzo * 0.72, 30), Colors.orangeAccent, 26, -0.02);
    _dibujarTextoGraffiti(canvas, "PYTHON", Offset(anchoLienzo * 0.90, 40), const Color(0xFF3776AB), 28, 0.05);
    _dibujarTextoGraffiti(canvas, "ARTISTA", Offset(anchoLienzo * 0.60, 185), Colors.pinkAccent, 22, 0.05);
    _dibujarTextoGraffiti(canvas, "DEUTSCH", Offset(anchoLienzo * 0.85, 200), Colors.white70, 18, -0.05);
    _dibujarTextoGraffiti(canvas, "ENGLISH", Offset(anchoLienzo * 0.93, 165), Colors.white70, 18, 0.08);
    _dibujarTextoGraffiti(canvas, "SOÑADOR", Offset(anchoLienzo * 0.42, 210), Colors.blueAccent, 20, -0.04);
    _dibujarTextoGraffiti(canvas, "UNDERGROUND", Offset(anchoLienzo * 0.45, 140), Colors.purpleAccent, 16, 0.0);
    
    // 4. Dibuja el borde superior de la plataforma
    canvas.drawRect(
        Rect.fromLTWH(0, 240, anchoLienzo, 20), Paint()..color = const Color(0xFF0A0C10));
    canvas.drawRect(
        Rect.fromLTWH(0, 260, anchoLienzo, 60), Paint()..color = Colors.black);
        
    // 5. Dibuja las marcas en el andén (línea de seguridad amarilla o texturas)
    for (double x = 0; x < anchoLienzo; x += 45) {
      canvas.drawRect(
        Rect.fromLTWH(x, 270, 25, 40), Paint()..color = const Color(0xFF1E2228));
    }
    
    // 6. Dibuja los raíles brillantes de la vía
    final pincelRaies = Paint()
      ..color = Colors.cyan.withOpacity(0.3)
      ..strokeWidth = 3;
    canvas.drawLine(const Offset(0, 275), Offset(anchoLienzo, 275), pincelRaies);
    canvas.drawLine(const Offset(0, 305), Offset(anchoLienzo, 305), pincelRaies);
  }

  /// Método auxiliar encapsulado para dibujar textos en el canvas con rotación y sombras.
  void _dibujarTextoGraffiti(Canvas lienzo, String texto, Offset posicion, Color colorNeom, double tamanoTexto, double anguloRotacion) {
    // Configurador de texto de Flutter para el Canvas
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
      
    lienzo.save(); // Guarda el estado actual del lienzo (recto)
    lienzo.translate(posicion.dx, posicion.dy); // Se mueve a la posición X,Y
    lienzo.rotate(anguloRotacion);              // Rota el lienzo para pintar torcido
    dibujanteTexto.paint(lienzo, Offset.zero);  // Estampa el texto
    lienzo.restore(); // Devuelve el lienzo a su estado original (recto) para el próximo
  }

  @override
  bool shouldRepaint(_MuroViasPainter old) => false; // Falso por eficiencia (es un muro estático)
}
// Importaciones principales del framework
import 'package:flutter/material.dart';
import 'dart:async';

// Importaciones de los componentes que forman el escenario
import 'suelo_estacion.dart';
import 'fondo_estacion.dart';
import 'visor_contenido.dart';
import 'menu_metro.dart';

// Importaciones de las vistas de contenido (Las distintas "estaciones")
import 'seccion_cv.dart';
import 'seccion_contacto.dart';
import 'seccion_proyectos.dart';
import 'seccion_idiomas.dart';
import 'traducciones.dart';

// =========================================================================
// MODELO DE MEDIDAS DEL ESCENARIO (Responsivo)
// Todas las medidas del escenario se calculan UNA SOLA VEZ aquí.
// Así si cambias una cosa, todo lo demás se adapta solo.
// =========================================================================
class _MedidasEscenario {
  final double alturaSuelo;
  final double alturaMuro;
  final double bottomMuro;
  final double alturaAvatar;
  final double bottomLogo;
  final double leftLogo;
  final double anchoLogo;
  final double alineacionVerticalTren;
  final bool esMovil;

  const _MedidasEscenario({
    required this.alturaSuelo,
    required this.alturaMuro,
    required this.bottomMuro,
    required this.alturaAvatar,
    required this.bottomLogo,
    required this.leftLogo,
    required this.anchoLogo,
    required this.alineacionVerticalTren,
    required this.esMovil,
  });

  /// Fábrica que calcula todas las medidas a partir del tamaño real de pantalla.
  /// PC: valores EXACTOS del original. Movil: proporcionales al alto real.
  factory _MedidasEscenario.calcular(Size pantalla) {
    final bool esMovil = pantalla.width < 600;
    final double h = pantalla.height;
    final double w = pantalla.width;

    if (!esMovil) {
      // PC: mismos valores que tenia el original y que se veian perfectos
      return _MedidasEscenario(
        alturaSuelo: 280,
        alturaMuro: 320,
        bottomMuro: 280,
        alturaAvatar: 550,
        bottomLogo: 380,
        leftLogo: w * 0.71,
        anchoLogo: 125,
        alineacionVerticalTren: 0.40,
        esMovil: false,
      );
    }

    // MOVIL: suelo+muro = 38% del alto (PC era 77%).
    // El 62% restante queda para ver la ciudad y el avatar con claridad.
    final double alturaSuelo = h * 0.18;
    // Muro: 160px tren + ~80px encima (mitad del espacio anterior)
    final double alturaMuro = h * 0.28;
    final double alturaAvatar = h * 0.68;
    // Tren pegado a la vía: centro = alturaSuelo + mitad del tren (80px)
    final double centroTrenDesdeAbajo = alturaSuelo + 80.0;
    final double alineacionVerticalTren =
        1.0 - (2.0 * centroTrenDesdeAbajo / h);

    return _MedidasEscenario(
      alturaSuelo: alturaSuelo,
      alturaMuro: alturaMuro,
      bottomMuro: alturaSuelo,
      alturaAvatar: alturaAvatar,
      bottomLogo: alturaSuelo + alturaMuro * 0.55,
      leftLogo: w * 0.68,
      anchoLogo: w * 0.14,
      alineacionVerticalTren: alineacionVerticalTren,
      esMovil: true,
    );
  }
}

/// [EstacionPrincipal] es el núcleo de la aplicación.
class EstacionPrincipal extends StatefulWidget {
  const EstacionPrincipal({super.key});

  @override
  State<EstacionPrincipal> createState() => _EstacionPrincipalState();
}

class _EstacionPrincipalState extends State<EstacionPrincipal>
    with TickerProviderStateMixin {
  // ==========================================
  // 1. ESTADO GLOBAL DEL SISTEMA
  // ==========================================
  String _idSeccionActiva = "HOME";
  String _idiomaSistema = "ES";
  bool _transicionEnCurso = false;
  bool _mostrarInterfazSeccion = false;

  // ==========================================
  // 2. MOTORES DE ANIMACIÓN
  // ==========================================
  late AnimationController _controladorAnimacionTren;
  late Animation<Offset> _animacionDesplazamientoTren;
  late AnimationController _controladorEmbarquePasajero;

  @override
  void initState() {
    super.initState();
    _inicializarAnimaciones();
  }

  void _inicializarAnimaciones() {
    _controladorAnimacionTren = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));

    _animacionDesplazamientoTren =
        Tween<Offset>(begin: const Offset(2.0, 0.0), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _controladorAnimacionTren,
                curve: Curves.easeInOutCubic));

    _controladorEmbarquePasajero = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));

    _controladorAnimacionTren.forward();
  }

  @override
  void dispose() {
    _controladorAnimacionTren.dispose();
    _controladorEmbarquePasajero.dispose();
    super.dispose();
  }

  // ==========================================
  // 3. LÓGICA DE NAVEGACIÓN
  // ==========================================
  void _ejecutarViajeHaciaSeccion(String idNuevaSeccion) async {
    if (_idSeccionActiva == idNuevaSeccion || _transicionEnCurso) return;

    if (_mostrarInterfazSeccion) {
      setState(() => _mostrarInterfazSeccion = false);
      await Future.delayed(const Duration(milliseconds: 400));
    }

    setState(() => _transicionEnCurso = true);
    await _controladorEmbarquePasajero.forward();
    await _animarSalidaDelTren();
    setState(() => _idSeccionActiva = idNuevaSeccion);
    await _animarEntradaDelTren();
    setState(() => _transicionEnCurso = false);
    await _controladorEmbarquePasajero.reverse();

    if (idNuevaSeccion != "HOME") {
      setState(() => _mostrarInterfazSeccion = true);
    }
  }

  Future<void> _animarSalidaDelTren() async {
    setState(() {
      _animacionDesplazamientoTren =
          Tween<Offset>(begin: Offset.zero, end: const Offset(-2.5, 0.0))
              .animate(CurvedAnimation(
                  parent: _controladorAnimacionTren,
                  curve: Curves.easeInCubic));
    });
    await _controladorAnimacionTren.forward(from: 0.0);
  }

  Future<void> _animarEntradaDelTren() async {
    setState(() {
      _animacionDesplazamientoTren =
          Tween<Offset>(begin: const Offset(2.5, 0.0), end: Offset.zero)
              .animate(CurvedAnimation(
                  parent: _controladorAnimacionTren,
                  curve: Curves.easeOutCubic));
    });
    await _controladorAnimacionTren.forward(from: 0.0);
  }

  // ==========================================
  // 4. DIBUJO DE LA INTERFAZ
  // ==========================================
  @override
  Widget build(BuildContext context) {
    // Calculamos las medidas del escenario UNA VEZ aquí y las pasamos a todo.
    final medidas = _MedidasEscenario.calcular(MediaQuery.of(context).size);
    String t(String key) => Traductor.obtener(key, _idiomaSistema);

    return Scaffold(
      backgroundColor: const Color(0xFF020205),
      body: Stack(
        children: [
          _construirImagenFondo(),
          _construirEscenarioVias(medidas),
          _construirTrenAnimado(t, medidas),
          _construirPasajeroNPC(medidas),
          _construirPanelDeContenidoOscuro(),
          _construirHUDyMenu(t, medidas),
        ],
      ),
    );
  }

  Widget _construirImagenFondo() {
    return Positioned.fill(
      child: Image.asset('assets/image_0.png',
          fit: BoxFit.cover, alignment: Alignment.topCenter),
    );
  }

  Widget _construirEscenarioVias(_MedidasEscenario m) {
    return Stack(
      children: [
        // Muro trasero con las tecnologías — usa medidas relativas
        Positioned(
          bottom: m.bottomMuro,
          left: 0,
          right: 0,
          height: m.alturaMuro,
          child: const ForegroundMuroVias(),
        ),
        // Suelo realista con efecto de rejilla / glitch
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SueloEstacionRealista(altura: m.alturaSuelo),
        ),
        // Logo: posición proporcional calculada en _MedidasEscenario
        Positioned(
          left: m.leftLogo,
          bottom: m.bottomLogo,
          child: Image.asset(
            'assets/logo.png',
            width: m.anchoLogo,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const SizedBox(),
          ),
        ),
      ],
    );
  }

  /// El tren se posiciona justo encima del muro de vías.
  Widget _construirTrenAnimado(String Function(String) t, _MedidasEscenario m) {
    return Align(
      alignment: Alignment(0, m.alineacionVerticalTren),
      child: SlideTransition(
        position: _animacionDesplazamientoTren,
        child: VisorTren(
          titulo: _idSeccionActiva == "HOME"
              ? "LOREN"
              : t(_obtenerLlaveDiccionario(_idSeccionActiva)),
        ),
      ),
    );
  }

  /// El avatar se posiciona encima del suelo, centrado, con tamaño proporcional.
  Widget _construirPasajeroNPC(_MedidasEscenario m) {
    return AnimatedBuilder(
      animation: _controladorEmbarquePasajero,
      builder: (context, child) {
        final double b = _controladorEmbarquePasajero.value;
        // El avatar arranca apoyado en el suelo (bottom = alturaSuelo)
        // Al subir al tren sube hacia arriba y se encoge
        final double subirY = b * m.alturaSuelo * 1.2;
        // Avatar con margen suficiente para que no se corte por abajo
        final double bottomBase =
            m.esMovil ? m.alturaSuelo * 0.30 : m.alturaSuelo * 0.05;
        return Positioned(
          bottom: bottomBase + subirY,
          left: 0,
          right: 0,
          height: m.alturaAvatar * (1 - b * 0.45),
          child: Opacity(
            opacity: (1.0 - b * 0.95).clamp(0.0, 1.0),
            child: PersonajeNPC(vaAlTren: _transicionEnCurso),
          ),
        );
      },
    );
  }

  Widget _construirPanelDeContenidoOscuro() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      top: _mostrarInterfazSeccion
          ? (MediaQuery.of(context).size.width < 600 ? 110 : 0)
          : MediaQuery.of(context).size.height,
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.black.withOpacity(0.85),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _inyectarWidgetDeSeccion(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirHUDyMenu(String Function(String) t, _MedidasEscenario m) {
    return SafeArea(
      child: Stack(
        children: [
          // ── MÓVIL: título arriba del todo ──────────────────────────────
          if (m.esMovil)
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Center(
                child: const Text(
                  "LOREN // PORTFOLIO 2026",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.cyan,
                    letterSpacing: 3,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // ── MÓVIL: caja naranja debajo del título ──────────────────────
          if (m.esMovil)
            Positioned(
              top: 42,
              left: 16,
              child: _construirCajaTerminalInfo(
                "DESTINO: PORTFOLIO\nESTADO: CONECTADO\nVÍA: 01",
                true,
              ),
            ),

          // ── MÓVIL: menú hamburguesa alineado con la caja naranja ───────
          if (m.esMovil)
            Positioned(
              top: 42,
              right: 16,
              child: _MenuMovil(
                seccionActual: _idSeccionActiva,
                idioma: _idiomaSistema,
                alSeleccionar: _ejecutarViajeHaciaSeccion,
              ),
            ),

          // ── PC: layout original ────────────────────────────────────────
          if (!m.esMovil)
            Positioned(
              top: 40,
              left: 40,
              child: _construirCajaTerminalInfo(
                "DESTINO: PORTFOLIO\nESTADO: CONECTADO\nVÍA: 01",
                false,
              ),
            ),
          if (!m.esMovil)
            Positioned(
              top: 40,
              right: 40,
              child: MenuMetro(
                seccionActual: _idSeccionActiva,
                idioma: _idiomaSistema,
                alSeleccionar: _ejecutarViajeHaciaSeccion,
              ),
            ),
          if (!m.esMovil)
            Positioned(
              top: 20,
              left: 80,
              right: 80,
              child: Center(
                child: const Text(
                  "LOREN // PORTFOLIO 2026",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.cyan,
                    letterSpacing: 8,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ==========================================
  // 5. MÉTODOS AUXILIARES
  // ==========================================
  String _obtenerLlaveDiccionario(String id) {
    switch (id) {
      case "CV":
        return "m_cv";
      case "SOBRE MÍ":
        return "m_sobre";
      case "PROYECTOS":
        return "m_proy";
      case "IDIOMAS":
        return "m_idioma";
      case "CONTACTO":
        return "m_cont";
      default:
        return "m_home";
    }
  }

  Widget _inyectarWidgetDeSeccion() {
    if (_idSeccionActiva == "CV") {
      return SeccionCV(
          onVolver: () => _ejecutarViajeHaciaSeccion("HOME"),
          idiomaGlobal: _idiomaSistema);
    }
    if (_idSeccionActiva == "CONTACTO") {
      return SeccionContacto(
          onVolver: () => _ejecutarViajeHaciaSeccion("HOME"),
          idiomaGlobal: _idiomaSistema);
    }
    if (_idSeccionActiva == "PROYECTOS") {
      return SeccionProyectos(
          onVolver: () => _ejecutarViajeHaciaSeccion("HOME"),
          idiomaGlobal: _idiomaSistema);
    }
    if (_idSeccionActiva == "IDIOMAS") {
      return SeccionIdiomas(
        idiomaActual: _idiomaSistema,
        alCambiarIdioma: (nuevoIdioma) =>
            setState(() => _idiomaSistema = nuevoIdioma),
        onVolver: () => _ejecutarViajeHaciaSeccion("HOME"),
      );
    }
    if (_idSeccionActiva == "SOBRE MÍ") {
      return _construirSeccionSobreMiInterna();
    }
    return const SizedBox();
  }

  Widget _construirSeccionSobreMiInterna() {
    String t(String key) => Traductor.obtener(key, _idiomaSistema);
    return ListView(
      children: [
        const SizedBox(height: 20),
        _construirBotonVolver(t('btn_volver')),
        const SizedBox(height: 30),
        Text(
          t('s_titulo'),
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width < 600 ? 18 : 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(height: 40),
        _construirTarjetaInfoSobreMi(
            t('s_01_t'), t('s_01_d'), Colors.cyanAccent),
        const SizedBox(height: 20),
        _construirTarjetaInfoSobreMi(
            t('s_02_t'), t('s_02_d'), Colors.lightGreenAccent),
        const SizedBox(height: 20),
        _construirTarjetaInfoSobreMi(
            t('s_03_t'), t('s_03_d'), Colors.orangeAccent),
        const SizedBox(height: 20),
        _construirTarjetaInfoSobreMi(
            t('s_04_t'), t('s_04_d'), Colors.pinkAccent),
      ],
    );
  }

  Widget _construirBotonVolver(String texto) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: () => _ejecutarViajeHaciaSeccion("HOME"),
        icon: const Icon(Icons.arrow_back_ios, size: 12, color: Colors.cyan),
        label: Text(texto, style: const TextStyle(color: Colors.cyan)),
      ),
    );
  }

  Widget _construirTarjetaInfoSobreMi(
      String titulo, String texto, Color colorAcento) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        border: Border.all(color: colorAcento.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo,
              style: TextStyle(
                  color: colorAcento,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace')),
          const SizedBox(height: 10),
          Text(texto,
              style: const TextStyle(color: Colors.white70, height: 1.6)),
        ],
      ),
    );
  }

  Widget _construirCajaTerminalInfo(String texto, bool esMovil) {
    return Container(
      padding: EdgeInsets.all(esMovil ? 6 : 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        border: Border.all(color: Colors.orange, width: 1.5),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: Colors.orange,
          fontSize: esMovil ? 7 : 10,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

// =========================================================================
// MENÚ MÓVIL: Versión compacta con icono hamburguesa para pantallas pequeñas
// =========================================================================
class _MenuMovil extends StatefulWidget {
  final String seccionActual;
  final String idioma;
  final Function(String) alSeleccionar;

  const _MenuMovil({
    required this.seccionActual,
    required this.idioma,
    required this.alSeleccionar,
  });

  @override
  State<_MenuMovil> createState() => _MenuMovilState();
}

class _MenuMovilState extends State<_MenuMovil> {
  bool _abierto = false;

  // IDs y colores en listas paralelas — compatible con Dart 2 y Dart 3
  static const List<String> _ids = [
    "HOME",
    "CV",
    "SOBRE MÍ",
    "PROYECTOS",
    "IDIOMAS",
    "CONTACTO"
  ];
  static const List<Color> _colores = [
    Colors.white,
    Colors.orangeAccent,
    Colors.cyanAccent,
    Colors.lightGreenAccent,
    Colors.purpleAccent,
    Colors.redAccent,
  ];

  @override
  Widget build(BuildContext context) {
    String t(String llave) => Traductor.obtener(llave, widget.idioma);

    final Map<String, String> etiquetas = {
      "HOME": t('m_home'),
      "CV": t('m_cv'),
      "SOBRE MÍ": t('m_sobre'),
      "PROYECTOS": t('m_proy'),
      "IDIOMAS": t('m_idioma'),
      "CONTACTO": t('m_cont'),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Botón hamburguesa
        GestureDetector(
          onTap: () => setState(() => _abierto = !_abierto),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              border: Border.all(color: Colors.cyan.withOpacity(0.5)),
            ),
            child: Icon(
              _abierto ? Icons.close : Icons.menu,
              color: Colors.cyan,
              size: 20,
            ),
          ),
        ),
        // Panel desplegable
        if (_abierto)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.92),
              border: Border.all(color: Colors.cyan.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_ids.length, (i) {
                final String id = _ids[i];
                final Color color = _colores[i];
                final bool activa = widget.seccionActual == id;

                return GestureDetector(
                  onTap: () {
                    setState(() => _abierto = false);
                    widget.alSeleccionar(id);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color:
                          activa ? color.withOpacity(0.12) : Colors.transparent,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          etiquetas[id] ?? id,
                          style: TextStyle(
                            color: activa ? color : Colors.white70,
                            fontWeight:
                                activa ? FontWeight.bold : FontWeight.normal,
                            fontFamily: 'monospace',
                            fontSize: 11,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: activa ? color : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: color, width: activa ? 0 : 1.5),
                            boxShadow: activa
                                ? [BoxShadow(color: color, blurRadius: 6)]
                                : [],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}

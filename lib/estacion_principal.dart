// Importaciones principales del framework
import 'package:flutter/material.dart';
import 'dart:async';

// Importaciones de los componentes que forman el escenario
import 'suelo_estacion.dart';
import 'fondo_estacion.dart';
import 'visor_contenido.dart';
import 'menu_metro.dart';

// Importaciones de las vistas de contenido
import 'seccion_cv.dart';
import 'seccion_contacto.dart';
import 'seccion_proyectos.dart';
import 'seccion_idiomas.dart';
import 'traducciones.dart';

class EstacionPrincipal extends StatefulWidget {
  const EstacionPrincipal({super.key});

  @override
  State<EstacionPrincipal> createState() => _EstacionPrincipalState();
}

class _EstacionPrincipalState extends State<EstacionPrincipal>
    with TickerProviderStateMixin {
  String _idSeccionActiva = "HOME";
  String _idiomaSistema = "ES";
  bool _transicionEnCurso = false;
  bool _mostrarInterfazSeccion = false;

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

  @override
  Widget build(BuildContext context) {
    String t(String key) => Traductor.obtener(key, _idiomaSistema);

    return Scaffold(
      backgroundColor: const Color(0xFF020205),
      body: Center(
        // AQUÍ ESTÁ LA MAGIA QUE PEDÍAS: Envuelve tu código de PC y lo encoge
        child: FittedBox(
          fit: BoxFit.contain,
          alignment: Alignment.center,
          child: SizedBox(
            // Le forzamos un tamaño estático de monitor de PC (1280x720)
            width: 1280,
            height: 720,
            child: Stack(
              children: [
                _construirImagenFondo(),
                _construirEscenarioVias(1280),
                _construirTrenAnimado(t),
                _construirPasajeroNPC(),
                _construirPanelDeContenidoOscuro(),
                _construirHUDyMenu(t),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirImagenFondo() {
    return Positioned.fill(
      child: Image.asset('assets/image_0.png',
          fit: BoxFit.cover, alignment: Alignment.topCenter),
    );
  }

  Widget _construirEscenarioVias(double screenWidth) {
    return Stack(
      children: [
        const Positioned(
            bottom: 280,
            left: 0,
            right: 0,
            height: 320,
            child: ForegroundMuroVias()),
        const Positioned(
            bottom: 0, left: 0, right: 0, child: SueloEstacionRealista()),
        Positioned(
            left: screenWidth * 0.71,
            bottom: 380,
            child: Image.asset('assets/logo.png',
                width: 125, fit: BoxFit.contain)),
      ],
    );
  }

  Widget _construirTrenAnimado(String Function(String) t) {
    return Align(
        alignment: const Alignment(0, 0.40),
        child: SlideTransition(
            position: _animacionDesplazamientoTren,
            child: VisorTren(
                titulo: _idSeccionActiva == "HOME"
                    ? "LOREN"
                    : t(_obtenerLlaveDiccionario(_idSeccionActiva)))));
  }

  Widget _construirPasajeroNPC() {
    return AnimatedBuilder(
      animation: _controladorEmbarquePasajero,
      builder: (context, child) {
        double b = _controladorEmbarquePasajero.value;
        return Positioned(
          bottom: 10 + (b * 200),
          left: 0,
          right: 0,
          height: 550 * (1 - (b * 0.5)),
          child: Opacity(
              opacity: (1.0 - (b * 0.95)).clamp(0.0, 1.0),
              child: PersonajeNPC(vaAlTren: _transicionEnCurso)),
        );
      },
    );
  }

  Widget _construirPanelDeContenidoOscuro() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      top: _mostrarInterfazSeccion ? 0 : 720,
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
                child: _inyectarWidgetDeSeccion()),
          ),
        ),
      ),
    );
  }

  Widget _construirHUDyMenu(String Function(String) t) {
    return Stack(
      children: [
        Positioned(
            top: 40,
            left: 40,
            child: _construirCajaTerminalInfo(
                "DESTINO: PORTFOLIO\nESTADO: CONECTADO\nVÍA: 01")),
        Positioned(
            top: 40,
            right: 40,
            child: MenuMetro(
                seccionActual: _idSeccionActiva,
                idioma: _idiomaSistema,
                alSeleccionar: (id) => _ejecutarViajeHaciaSeccion(id))),
        const Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
                child: Text("LOREN // PORTFOLIO 2026",
                    style: TextStyle(
                        color: Colors.cyan, letterSpacing: 8, fontSize: 10)))),
      ],
    );
  }

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
        const SizedBox(height: 120),
        Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
                onPressed: () => _ejecutarViajeHaciaSeccion("HOME"),
                icon: const Icon(Icons.arrow_back_ios,
                    size: 12, color: Colors.cyan),
                label: Text(t('btn_volver'),
                    style: const TextStyle(color: Colors.cyan)))),
        const SizedBox(height: 30),
        Text(t('s_titulo'),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace')),
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

  Widget _construirTarjetaInfoSobreMi(
      String titulo, String texto, Color colorAcento) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          border: Border.all(color: colorAcento.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(8)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(titulo,
            style: TextStyle(
                color: colorAcento,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace')),
        const SizedBox(height: 10),
        Text(texto, style: const TextStyle(color: Colors.white70, height: 1.6)),
      ]),
    );
  }

  Widget _construirCajaTerminalInfo(String texto) {
    return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            border: Border.all(color: Colors.orange, width: 1.5)),
        child: Text(texto,
            style: const TextStyle(
                color: Colors.orange, fontSize: 10, fontFamily: 'monospace')));
  }
}

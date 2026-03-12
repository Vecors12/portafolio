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

/// [EstacionPrincipal] es el núcleo de la aplicación.
/// Funciona como un orquestador que gestiona los viajes entre secciones y el idioma global.
class EstacionPrincipal extends StatefulWidget {
  const EstacionPrincipal({super.key});

  @override
  State<EstacionPrincipal> createState() => _EstacionPrincipalState();
}

/// Usamos [TickerProviderStateMixin] para que Flutter pueda sincronizar las animaciones
/// con la tasa de refresco de la pantalla (60fps/120fps).
class _EstacionPrincipalState extends State<EstacionPrincipal>
    with TickerProviderStateMixin {
  // ==========================================
  // 1. ESTADO GLOBAL DEL SISTEMA (Privado)
  // ==========================================

  /// Identificador de la sección que se está mostrando actualmente.
  String _idSeccionActiva = "HOME";

  /// Idioma actual de la interfaz (ES, EN, DE).
  String _idiomaSistema = "ES";

  /// Bloqueo de seguridad: Evita que el usuario haga múltiples clics en el menú
  /// mientras el tren ya está realizando un viaje.
  bool _transicionEnCurso = false;

  /// Controla la aparición/desaparición del panel de contenido oscuro.
  bool _mostrarInterfazSeccion = false;

  // ==========================================
  // 2. MOTORES DE ANIMACIÓN (Privados)
  // ==========================================

  /// Controlador principal para el movimiento lateral del tren.
  late AnimationController _controladorAnimacionTren;

  /// Define de dónde a dónde se mueve el tren en la pantalla (Eje X).
  late Animation<Offset> _animacionDesplazamientoTren;

  /// Controlador para la animación del NPC (Personaje) subiendo al andén/tren.
  late AnimationController _controladorEmbarquePasajero;

  @override
  void initState() {
    super.initState();
    _inicializarAnimaciones();
  }

  /// Configura las duraciones y curvas de movimiento antes de que la pantalla se dibuje.
  void _inicializarAnimaciones() {
    // 1. Setup del Tren
    _controladorAnimacionTren = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));

    _animacionDesplazamientoTren =
        Tween<Offset>(begin: const Offset(2.0, 0.0), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _controladorAnimacionTren,
                curve: Curves.easeInOutCubic));

    // 2. Setup del Pasajero (NPC)
    _controladorEmbarquePasajero = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));

    // Inicia la primera animación (El tren entrando al iniciar la web)
    _controladorAnimacionTren.forward();
  }

  @override
  void dispose() {
    // Es vital destruir los controladores de animación para liberar memoria al cerrar la app.
    _controladorAnimacionTren.dispose();
    _controladorEmbarquePasajero.dispose();
    super.dispose();
  }

  // ==========================================
  // 3. LÓGICA DE NAVEGACIÓN (La Máquina de Estados)
  // ==========================================

  /// Se ejecuta al pulsar un botón del [MenuMetro].
  /// Orquesta la salida del tren, el cambio de datos y la entrada de nuevo.
  void _ejecutarViajeHaciaSeccion(String idNuevaSeccion) async {
    // Si ya estamos en esa sección o el tren se está moviendo, abortamos la acción por seguridad.
    if (_idSeccionActiva == idNuevaSeccion || _transicionEnCurso) return;

    // FASE 1: Ocultar el contenido de texto si hay alguno abierto.
    if (_mostrarInterfazSeccion) {
      setState(() => _mostrarInterfazSeccion = false);
      // Damos 400ms para que termine el efecto fade-out/slide-down del panel negro.
      await Future.delayed(const Duration(milliseconds: 400));
    }

    // Activamos el bloqueo de interacciones.
    setState(() => _transicionEnCurso = true);

    // FASE 2: Animación del pasajero entrando al tren.
    await _controladorEmbarquePasajero.forward();

    // FASE 3: El tren arranca y sale de la pantalla.
    await _animarSalidaDelTren();

    // FASE 4: Cambiamos silenciosamente los datos (Sección e Idioma).
    setState(() => _idSeccionActiva = idNuevaSeccion);

    // FASE 5: El tren llega a la nueva estación (Vuelve a entrar a pantalla).
    await _animarEntradaDelTren();

    // Desactivamos el bloqueo y el pasajero baja al andén.
    setState(() => _transicionEnCurso = false);
    await _controladorEmbarquePasajero.reverse();

    // FASE 6: Si el destino no es el inicio, desplegamos el panel de contenido negro.
    if (idNuevaSeccion != "HOME") {
      setState(() => _mostrarInterfazSeccion = true);
    }
  }

  /// Efecto del tren saliendo hacia la izquierda.
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

  /// Efecto del tren entrando desde la derecha.
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
  // 4. DIBUJO DE LA INTERFAZ (UI)
  // ==========================================

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    // Función ayudante (helper) rápida para invocar traducciones en este widget.
    String t(String key) => Traductor.obtener(key, _idiomaSistema);

    return Scaffold(
      backgroundColor: const Color(0xFF020205),
      body: Stack(
        children: [
          _construirImagenFondo(),
          _construirEscenarioVias(w),
          _construirTrenAnimado(t),
          _construirPasajeroNPC(),
          _construirPanelDeContenidoOscuro(),
          _construirHUDyMenu(t), // Las capas superiores de interacción
        ],
      ),
    );
  }

  // --- SUB-WIDGETS PARA MANTENER EL BUILD LIMPIO ---

  Widget _construirImagenFondo() {
    return Positioned.fill(
      child: Image.asset('assets/image_0.png',
          fit: BoxFit.cover, alignment: Alignment.topCenter),
    );
  }

  Widget _construirEscenarioVias(double screenWidth) {
    return Stack(
      children: [
        // Muro trasero con las tecnologías dibujadas
        const Positioned(
            bottom: 280,
            left: 0,
            right: 0,
            height: 320,
            child: ForegroundMuroVias()),
        // Suelo realista con efecto de rejilla / glitch
        const Positioned(
            bottom: 0, left: 0, right: 0, child: SueloEstacionRealista()),
        // Logo estático posicionado en la escena
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
          bottom: 10 + (b * 200), // Sube en el eje Y
          left: 0, right: 0,
          height: 550 * (1 - (b * 0.5)), // Se encoge para dar profundidad
          child: Opacity(
              opacity: (1.0 - (b * 0.95)).clamp(0.0, 1.0), // Se difumina
              child: PersonajeNPC(vaAlTren: _transicionEnCurso)),
        );
      },
    );
  }

  Widget _construirPanelDeContenidoOscuro() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      // Baja la pantalla completa cuando no se debe mostrar
      top: _mostrarInterfazSeccion ? 0 : MediaQuery.of(context).size.height,
      bottom: 0, left: 0, right: 0,
      child: Container(
        color: Colors.black.withOpacity(0.85),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _inyectarWidgetDeSeccion()), // Inyecta la vista correcta
          ),
        ),
      ),
    );
  }

  Widget _construirHUDyMenu(String Function(String) t) {
    return Stack(
      children: [
        // Información arriba a la izquierda
        Positioned(
            top: 40,
            left: 40,
            child: _construirCajaTerminalInfo(
                "DESTINO: PORTFOLIO\nESTADO: CONECTADO\nVÍA: 01")),
        // Menú de navegación a la derecha
        Positioned(
            top: 40,
            right: 40,
            child: MenuMetro(
                seccionActual: _idSeccionActiva,
                idioma: _idiomaSistema,
                alSeleccionar: (id) => _ejecutarViajeHaciaSeccion(id))),
        // Texto superior central
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

  // ==========================================
  // 5. MÉTODOS AUXILIARES DE CONTENIDO
  // ==========================================

  /// Relaciona el ID de la sección actual con la llave de traducción correcta.
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

  /// Este es el "Router" interno. Devuelve el widget correspondiente a la sección elegida.
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
      // Mantenemos la estructura interna de "Sobre Mí" para asegurar armonía
      // visual sin tocar otros archivos prematuramente.
      return _construirSeccionSobreMiInterna();
    }
    // Retorno por defecto (Pantalla vacía transparente)
    return const SizedBox();
  }

  // --- WIDGETS INTERNOS DE LA SECCIÓN "SOBRE MÍ" Y HUD ---

  Widget _construirSeccionSobreMiInterna() {
    String t(String key) => Traductor.obtener(key, _idiomaSistema);
    return ListView(
      children: [
        const SizedBox(height: 120),
        _construirBotonVolver(t('btn_volver')),
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

  Widget _construirBotonVolver(String texto) {
    return Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
            onPressed: () => _ejecutarViajeHaciaSeccion("HOME"),
            icon:
                const Icon(Icons.arrow_back_ios, size: 12, color: Colors.cyan),
            label: Text(texto, style: const TextStyle(color: Colors.cyan))));
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

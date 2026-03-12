// Importación principal del framework de Flutter
import 'package:flutter/material.dart';

// Importación del diccionario para los textos en distintos idiomas
import 'traducciones.dart';

/// [SeccionSobreMi] es un widget inyectable que se muestra dentro del panel oscuro
/// de la estación principal. Al no tener "Scaffold" propio, respeta el fondo y
/// las animaciones que ocurren detrás.
class SeccionSobreMi extends StatelessWidget {
  // ==========================================
  // PROPIEDADES INMUTABLES (Seguridad)
  // ==========================================

  /// Función callback que avisa a la estación que debe hacer volver el tren.
  final VoidCallback onVolver;

  /// Idioma actual de la aplicación para solicitar los textos correctos.
  final String idiomaGlobal;

  /// Constructor estricto. Obliga a recibir la función de retorno y el idioma.
  const SeccionSobreMi(
      {super.key, required this.onVolver, required this.idiomaGlobal});

  // ==========================================
  // CONSTRUCCIÓN VISUAL PRINCIPAL
  // ==========================================

  @override
  Widget build(BuildContext context) {
    // Función ayudante (helper) para extraer textos rápidamente del Traductor.
    String t(String key) => Traductor.obtener(key, idiomaGlobal);

    return ListView(
      // BouncingScrollPhysics da ese efecto de "rebote" al llegar al final de la lista,
      // ideal para la experiencia en pantallas táctiles (móviles).
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(
            height:
                120), // Espaciado superior para no tapar información de la estación

        // 1. Botón superior de retroceso
        _construirBotonVolver(t('btn_volver')),
        const SizedBox(height: 30),

        // 2. Título principal de la sección
        _construirTituloSeccion(t('s_titulo')),

        // Línea divisoria decorativa (Cyberpunk style)
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 40),
          height: 2,
          width: 150,
          color: Colors.cyanAccent,
          alignment: Alignment.centerLeft,
        ),

        // 3. Bloques de información (Textos íntegros desde el traductor)
        // Adaptable al 100% del ancho para no dar error en móviles
        _construirBloqueInfo(t('s_01_t'), t('s_01_d'), Colors.cyanAccent),
        const SizedBox(height: 20),

        _construirBloqueInfo(t('s_02_t'), t('s_02_d'), Colors.lightGreenAccent),
        const SizedBox(height: 20),

        _construirBloqueInfo(t('s_03_t'), t('s_03_d'), Colors.orangeAccent),
        const SizedBox(height: 20),

        _construirBloqueInfo(t('s_04_t'), t('s_04_d'), Colors.pinkAccent),

        const SizedBox(
            height: 80), // Espacio al final para poder hacer scroll cómodo
      ],
    );
  }

  // ==========================================
  // WIDGETS PRIVADOS DE DIBUJO (Encapsulamiento)
  // ==========================================

  /// Dibuja el botón de "VOLVER AL ANDÉN".
  Widget _construirBotonVolver(String texto) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed:
            onVolver, // Ejecuta la acción inyectada desde EstacionPrincipal
        icon: const Icon(Icons.arrow_back_ios, size: 12, color: Colors.cyan),
        label: Text(texto, style: const TextStyle(color: Colors.cyan)),
      ),
    );
  }

  /// Dibuja el título principal con efecto de sombra neón.
  Widget _construirTituloSeccion(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        color: Colors.white,
        fontSize:
            24, // Ajustado para que encaje perfecto en móviles sin desbordar
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
        shadows: [Shadow(color: Colors.cyan, blurRadius: 15)],
        fontFamily: 'monospace',
      ),
    );
  }

  /// Dibuja las cajas de texto de la biografía.
  /// Es 100% responsivo: Se estira en web y se encoge en móvil automáticamente.
  Widget _construirBloqueInfo(
      String titulo, String textoCuerpo, Color colorAcento) {
    return Container(
      width: double
          .infinity, // Ocupa todo el ancho posible, evitando errores en móvil
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6), // Fondo oscuro translúcido
        border: Border.all(color: colorAcento.withOpacity(0.5), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: TextStyle(
              color: colorAcento,
              fontSize: 16,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 15),
          Text(
            textoCuerpo,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.6, // Interlineado amplio para facilitar lectura
            ),
          ),
        ],
      ),
    );
  }
}

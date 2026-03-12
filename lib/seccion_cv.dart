// Importación principal de Flutter
import 'package:flutter/material.dart';

// Importación para poder abrir enlaces externos o archivos (como el PDF)
import 'package:url_launcher/url_launcher.dart';

// Importación de nuestro sistema de idiomas
import 'traducciones.dart';

/// [SeccionCV] es la vista que muestra las habilidades y permite descargar el currículum.
/// Es un [StatefulWidget] porque necesita recordar qué idioma de PDF ha seleccionado
/// el usuario antes de pulsar el botón de abrir.
class SeccionCV extends StatefulWidget {
  // ==========================================
  // PROPIEDADES INMUTABLES (Recibidas de la estación)
  // ==========================================

  /// Función que se ejecuta para avisar a la estación de que queremos volver.
  final VoidCallback onVolver;

  /// Idioma actual de la interfaz para traducir los textos al vuelo.
  final String idiomaGlobal;

  /// Constructor obligatorio. Nombres exactos para no romper la conexión con EstacionPrincipal.
  const SeccionCV(
      {super.key, required this.onVolver, required this.idiomaGlobal});

  @override
  State<SeccionCV> createState() => _SeccionCVState();
}

class _SeccionCVState extends State<SeccionCV> {
  // ==========================================
  // ESTADO INTERNO (Privado)
  // ==========================================

  /// Idioma del archivo PDF seleccionado por el usuario.
  /// Por defecto, inicia en Alemán ("DE"). Es independiente del idiomaGlobal de la web.
  String _idiomaSeleccionadoPDF = "DE";

  // ==========================================
  // LÓGICA DE NEGOCIO
  // ==========================================

  /// Intenta abrir el archivo PDF correspondiente al idioma seleccionado.
  Future<void> _abrirArchivoPDF() async {
    // Construye la ruta al archivo.
    // NOTA: Tienes "assets/assets/...", lo mantengo intacto para no romper tu lógica actual.
    final String rutaArchivo =
        "assets/assets/cv_${_idiomaSeleccionadoPDF.toLowerCase()}.pdf";

    try {
      final Uri url = Uri.parse(rutaArchivo);
      // LaunchMode.externalApplication fuerza a que se abra con el visor de PDF del sistema
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'No se pudo lanzar $rutaArchivo';
      }
    } catch (error) {
      // Si el widget sigue visible en pantalla (mounted), mostramos el mensaje de error Cyberpunk
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("SYSTEM_ERROR // No se encuentra el archivo PDF"),
          backgroundColor: Colors.redAccent,
        ));
      }
    }
  }

  // ==========================================
  // CONSTRUCCIÓN VISUAL PRINCIPAL
  // ==========================================

  @override
  Widget build(BuildContext context) {
    // Función rápida para traducir los textos de esta sección
    String t(String key) => Traductor.obtener(key, widget.idiomaGlobal);

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 120),

        // 1. Botón superior de retroceso
        _construirBotonVolver(t('btn_volver')),
        const SizedBox(height: 30),

        // 2. Título de la sección
        _construirTitulo(t('cv_titulo')),
        const SizedBox(height: 40),

        // 3. Selector de idiomas para el PDF (ES, EN, DE)
        _construirSelectorDeIdioma(t),
        const SizedBox(height: 60),

        // 4. Panel de insignias (Skills) - Fila Superior
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            _construirInsigniaHabilidad("FLUTTER", Colors.cyanAccent),
            _construirInsigniaHabilidad("JAVA", Colors.cyanAccent),
            _construirInsigniaHabilidad("PYTHON", Colors.cyanAccent),
            _construirInsigniaHabilidad("SQL", Colors.cyanAccent),
          ],
        ),

        const SizedBox(height: 12),

        // 5. Panel de insignias (Skills) - Fila Inferior
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            _construirInsigniaHabilidad("HTML / CSS", Colors.orangeAccent),
            _construirInsigniaHabilidad("IT SECURITY", Colors.orangeAccent),
            _construirInsigniaHabilidad("HARDWARE", Colors.orangeAccent),
            _construirInsigniaHabilidad("WINDOWS OS", Colors.orangeAccent),
          ],
        ),

        const SizedBox(height: 70),

        // 6. Botón grande de acción para abrir PDF
        _construirBotonAbrirPDF(t),
        const SizedBox(height: 80), // Espacio inferior para scroll cómodo
      ],
    );
  }

  // ==========================================
  // WIDGETS PRIVADOS DE DIBUJO (Limpieza de código)
  // ==========================================

  /// Dibuja el botón de volver atrás ("Volver al andén").
  Widget _construirBotonVolver(String texto) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: widget.onVolver,
        icon: const Icon(Icons.arrow_back_ios, size: 12, color: Colors.cyan),
        label: Text(texto, style: const TextStyle(color: Colors.cyan)),
      ),
    );
  }

  /// Dibuja el título principal de la sección.
  Widget _construirTitulo(String texto) {
    return Text(
      texto,
      style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace'),
    );
  }

  /// Dibuja los tres botones para elegir el idioma del PDF.
  Widget _construirSelectorDeIdioma(String Function(String) t) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 15,
      runSpacing: 15,
      // Recorremos la lista para no escribir el contenedor 3 veces
      children: ["ES", "EN", "DE"].map((lenguaje) {
        bool estaActivo = (_idiomaSeleccionadoPDF == lenguaje);

        // Resolvemos el texto traducido según el idioma del ciclo
        String etiqueta;
        if (lenguaje == "ES") {
          etiqueta = t('cv_lang_es');
        } else if (lenguaje == "EN") {
          etiqueta = t('cv_lang_en');
        } else {
          etiqueta = t('cv_lang_de');
        }

        return InkWell(
          // Al pulsar, actualizamos el estado privado
          onTap: () => setState(() => _idiomaSeleccionadoPDF = lenguaje),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              // Fondo anaranjado translúcido si está seleccionado
              color: estaActivo
                  ? Colors.orangeAccent.withOpacity(0.2)
                  : Colors.transparent,
              border: Border.all(
                  color: estaActivo ? Colors.orangeAccent : Colors.white30),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              etiqueta,
              style: TextStyle(
                  color: estaActivo ? Colors.orangeAccent : Colors.white54,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontFamily: 'monospace'),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Dibuja cada "pastilla" de habilidades técnicas.
  Widget _construirInsigniaHabilidad(String texto, Color colorNeon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: colorNeon.withOpacity(0.1),
        border: Border.all(color: colorNeon.withOpacity(0.8), width: 1.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        texto,
        style: TextStyle(
            color: colorNeon,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
            letterSpacing: 1),
      ),
    );
  }

  /// Dibuja el botón principal que ejecuta la descarga/apertura.
  Widget _construirBotonAbrirPDF(String Function(String) t) {
    return Center(
      child: InkWell(
        onTap: _abrirArchivoPDF,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.cyanAccent, width: 2),
            // Sombra tipo brillo neón exterior
            boxShadow: [
              BoxShadow(
                  color: Colors.cyanAccent.withOpacity(0.3), blurRadius: 20)
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.picture_as_pdf_rounded,
                  color: Colors.cyanAccent, size: 28),
              const SizedBox(width: 15),
              Text(
                "${t('cv_abrir')} CV_$_idiomaSeleccionadoPDF.PDF",
                style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    fontFamily: 'monospace'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

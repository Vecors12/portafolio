// Importación principal de Flutter para la interfaz visual
import 'package:flutter/material.dart';

// Importación para abrir enlaces externos (GitHub, webs, etc.)
import 'package:url_launcher/url_launcher.dart';

// Importación del sistema de traducciones
import 'traducciones.dart';

/// [SeccionProyectos] es un widget inyectable que muestra tus trabajos.
/// Diseñado para ser 100% responsivo, adaptándose a pantallas de PC y móviles.
class SeccionProyectos extends StatelessWidget {
  // ==========================================
  // PROPIEDADES INMUTABLES (Seguridad)
  // ==========================================

  /// Función callback que devuelve al usuario al andén principal.
  final VoidCallback onVolver;

  /// Idioma global de la app para cargar los textos correctos.
  final String idiomaGlobal;

  /// Constructor estricto.
  const SeccionProyectos(
      {super.key, required this.onVolver, required this.idiomaGlobal});

  // ==========================================
  // LÓGICA DE NEGOCIO
  // ==========================================

  /// Intenta abrir una URL externa de forma segura.
  /// Si falla (ej: el navegador móvil bloquea pop-ups), muestra un error visual.
  Future<void> _abrirEnlaceWeb(BuildContext context, String urlStr) async {
    // Si la URL está vacía (como en proyectos privados), no hacemos nada
    if (urlStr.isEmpty) return;

    try {
      final Uri url = Uri.parse(urlStr);
      // LaunchMode.externalApplication asegura que en móviles se abra el navegador
      // por defecto (Chrome/Safari) y no un visor interno de la app.
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('No se pudo lanzar $urlStr');
      }
    } catch (e) {
      // Verificamos si el widget sigue en pantalla antes de mostrar el error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("SYSTEM_ERROR // No se pudo abrir el enlace."),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  // ==========================================
  // CONSTRUCCIÓN VISUAL PRINCIPAL
  // ==========================================

  @override
  Widget build(BuildContext context) {
    // Función rápida para traducir los textos en base al idioma seleccionado
    String t(String llave) => Traductor.obtener(llave, idiomaGlobal);

    return ListView(
      // BouncingScrollPhysics para que el scroll sea fluido y rebotante en móviles
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(
            height: 120), // Espacio superior libre para la info de la estación

        // 1. Botón de retroceso
        _construirBotonVolver(t('btn_volver')),
        const SizedBox(height: 30),

        // 2. Título de la sección
        _construirTituloSeccion(t('p_titulo')),
        const SizedBox(height: 40),

        // 3. Tarjeta de Proyecto 1 (Portfolio)
        _construirTarjetaProyecto(
          context: context,
          titulo: t('p_1_t'),
          descripcion: t('p_1_d'),
          stackTecnologico: "FLUTTER / DART / ANIMATIONS",
          colorAcento: Colors.cyanAccent,
          urlDestino: "https://github.com/Vecors12",
          textoBoton: t('p_btn_ver'),
        ),
        const SizedBox(height: 25),

        // 4. Tarjeta de Proyecto 2 (Calculadora Python)
        _construirTarjetaProyecto(
          context: context,
          titulo: t('p_2_t'),
          descripcion: t('p_2_d'),
          stackTecnologico: "PYTHON / LOGIC / UI",
          colorAcento: Colors.orangeAccent,
          urlDestino: "https://github.com/Vecors12",
          textoBoton: t('p_btn_ver'),
        ),
        const SizedBox(height: 25),

        // 5. Tarjeta de Proyecto 3 (Proyecto Clasificado - Privado)
        _construirTarjetaProyecto(
          context: context,
          titulo: t('p_3_t'),
          descripcion: t('p_3_d'),
          stackTecnologico: "PRIVATE / ENCRYPTED",
          colorAcento: Colors.redAccent,
          urlDestino: "", // Sin URL por ser privado
          textoBoton: t('p_btn_ver'),
          esPrivado: true,
          textoEstadoPrivado: t('p_status_enc'),
        ),

        const SizedBox(height: 80), // Espaciado final inferior
      ],
    );
  }

  // ==========================================
  // WIDGETS PRIVADOS DE DIBUJO (Limpieza)
  // ==========================================

  /// Dibuja el botón de volver atrás ("Volver al andén").
  Widget _construirBotonVolver(String texto) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: onVolver,
        icon: const Icon(Icons.arrow_back_ios, size: 12, color: Colors.cyan),
        label: Text(texto, style: const TextStyle(color: Colors.cyan)),
      ),
    );
  }

  /// Dibuja el título de la sección ("CORE_SYSTEM // PROYECTOS").
  Widget _construirTituloSeccion(String texto) {
    return Text(
      texto,
      style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace'),
    );
  }

  /// Construye de forma dinámica una tarjeta de proyecto.
  /// Se ajusta automáticamente al ancho de web o móvil.
  Widget _construirTarjetaProyecto({
    required BuildContext context,
    required String titulo,
    required String descripcion,
    required String stackTecnologico,
    required Color colorAcento,
    required String urlDestino,
    required String textoBoton,
    bool esPrivado = false,
    String? textoEstadoPrivado,
  }) {
    return Container(
      width: double
          .infinity, // Ocupa todo el ancho, vital para adaptabilidad móvil
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5), // Fondo oscuro translúcido
        border: Border.all(color: colorAcento.withOpacity(0.5), width: 1.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila Superior: Título y el Icono de la carpeta/candado
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titulo,
                style: TextStyle(
                    color: colorAcento,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'monospace'),
              ),
              // Cambia el icono dependiendo de si el proyecto es público o privado
              Icon(esPrivado ? Icons.lock_outline : Icons.folder_open,
                  color: colorAcento, size: 20),
            ],
          ),
          const SizedBox(height: 15),

          // Centro: Descripción del proyecto
          Text(
            descripcion,
            style: const TextStyle(
                color: Colors.white70,
                height: 1.5, // Interlineado cómodo para leer en móvil
                fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Fila Inferior: Tecnologías usadas y Botón de enlace
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Texto de la tecnología usada (Ej: FLUTTER / DART)
              Text(
                stackTecnologico,
                style: TextStyle(
                    color: colorAcento.withOpacity(0.7),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1),
              ),

              // Lógica condicional: Si es público muestra el botón, si no, texto rojo.
              if (!esPrivado)
                TextButton(
                  onPressed: () => _abrirEnlaceWeb(context, urlDestino),
                  child: Text(
                    textoBoton,
                    style: TextStyle(
                        color: colorAcento,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                )
              else
                Text(
                  textoEstadoPrivado ?? "",
                  style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

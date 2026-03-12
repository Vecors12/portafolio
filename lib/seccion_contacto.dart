// Importación principal de Flutter
import 'package:flutter/material.dart';

// Importación para abrir la app de correo, LinkedIn o GitHub nativamente
import 'package:url_launcher/url_launcher.dart';

// Importación de nuestro sistema de idiomas
import 'traducciones.dart';

/// [SeccionContacto] es la vista donde el usuario puede encontrar tus enlaces.
/// Es 100% responsiva, limitando su ancho máximo en web y expandiéndose en móvil.
class SeccionContacto extends StatelessWidget {
  
  // ==========================================
  // PROPIEDADES INMUTABLES (Seguridad)
  // ==========================================

  /// Función que ejecuta la salida de esta sección hacia la estación principal.
  final VoidCallback onVolver;
  
  /// Idioma activo para cargar los textos correctos del traductor.
  final String idiomaGlobal;

  /// Constructor estricto. Obliga a recibir la función y el idioma exactos.
  const SeccionContacto({
    super.key, 
    required this.onVolver, 
    required this.idiomaGlobal
  });

  // ==========================================
  // LÓGICA DE NEGOCIO
  // ==========================================

  /// Intenta abrir una URL (web o protocolo mailto) de forma segura.
  Future<void> _abrirEnlaceSeguro(BuildContext context, String urlStr) async {
    try {
      final Uri url = Uri.parse(urlStr);
      // LaunchMode.externalApplication es vital para móviles: asegura que se abra
      // la app nativa (ej: app de Gmail o de LinkedIn) en lugar de un navegador interno.
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('No se pudo lanzar $urlStr');
      }
    } catch (error) {
      debugPrint("Error al abrir enlace: $error");
      // Si falla, mostramos el mensaje de error de sistema sin romper la app.
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("SYSTEM_ERROR // Permite las ventanas emergentes en tu navegador."),
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
    // Función rápida para traducir textos
    String t(String llave) => Traductor.obtener(llave, idiomaGlobal);

    return ListView(
      // Scroll suave y con rebote para la mejor experiencia en móviles
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 120),

        // 1. Botón superior de retroceso
        _construirBotonVolver(t('btn_volver')),
        const SizedBox(height: 30),

        // 2. Título de la sección
        _construirTituloSeccion(t('c_titulo')),
        const SizedBox(height: 20),

        // 3. Panel de estado del sistema (Online, Localización...)
        _construirCajaEstado(t('c_estado')),
        const SizedBox(height: 50),

        // 4. Lista de botones de contacto
        // Usamos un Center y un ConstrainedBox para que en pantallas de PC gigantes
        // los botones no se deformen, pero en móvil ocupen el 100% sin problemas.
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 550),
            child: Column(
              children: [
                // Botón 1: Email
                _construirBotonContacto(
                  context: context,
                  titulo: t('c_email_t'),
                  subtitulo: "loren.mdl_03@hotmail.com",
                  icono: Icons.email_outlined,
                  colorAcento: Colors.orangeAccent,
                  urlDestino: "mailto:loren.mdl_03@hotmail.com",
                ),
                const SizedBox(height: 20),
                
                // Botón 2: LinkedIn
                _construirBotonContacto(
                  context: context,
                  titulo: t('c_link_t'),
                  subtitulo: "LinkedIn // Lorenzo Camacho Garcia",
                  icono: Icons.work_outline,
                  colorAcento: Colors.cyanAccent,
                  urlDestino: "https://www.linkedin.com/in/lorenzo-camacho-garcia",
                ),
                const SizedBox(height: 20),
                
                // Botón 3: GitHub
                _construirBotonContacto(
                  context: context,
                  titulo: t('c_git_t'),
                  subtitulo: "GitHub // Vecors12",
                  icono: Icons.code,
                  colorAcento: Colors.white70,
                  urlDestino: "https://github.com/Vecors12",
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 80), // Espacio extra al final para permitir scroll completo
      ],
    );
  }

  // ==========================================
  // WIDGETS PRIVADOS DE DIBUJO (Limpieza)
  // ==========================================

  /// Dibuja el botón para regresar al andén.
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

  /// Dibuja el título con la tipografía monospace.
  Widget _construirTituloSeccion(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'monospace',
      ),
    );
  }

  /// Dibuja la caja de información verde de estado.
  Widget _construirCajaEstado(String textoEstado) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.greenAccent.withOpacity(0.05),
        border: Border.all(color: Colors.greenAccent.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        textoEstado,
        style: const TextStyle(
          color: Colors.greenAccent,
          fontFamily: 'monospace',
          fontSize: 13,
          height: 1.6, // Interlineado para mejor lectura
          letterSpacing: 1,
        ),
      ),
    );
  }

  /// Construye un botón de contacto grande e interactivo.
  Widget _construirBotonContacto({
    required BuildContext context,
    required String titulo,
    required String subtitulo,
    required IconData icono,
    required Color colorAcento,
    required String urlDestino,
  }) {
    return InkWell(
      onTap: () => _abrirEnlaceSeguro(context, urlDestino),
      child: Container(
        width: double.infinity, // Se adapta al ConstrainedBox o a la pantalla del móvil
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: colorAcento.withOpacity(0.6), width: 1.5),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
                color: colorAcento.withOpacity(0.08), 
                blurRadius: 15, 
                spreadRadius: 1)
          ],
        ),
        child: Row(
          children: [
            // Icono a la izquierda
            Icon(icono, color: colorAcento, size: 32),
            const SizedBox(width: 20),
            
            // Expanded es VITAL aquí: evita errores en móviles si el subtitulo
            // es muy largo, forzándolo a bajar a la línea de abajo suavemente.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      color: colorAcento,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitulo,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
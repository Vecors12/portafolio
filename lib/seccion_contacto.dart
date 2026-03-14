import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'traducciones.dart'; // Importamos el diccionario

class SeccionContacto extends StatelessWidget {
  final VoidCallback onVolver;
  final String idiomaGlobal; // Recibimos el idioma de la estación

  const SeccionContacto(
      {super.key, required this.onVolver, required this.idiomaGlobal});

  // Función para abrir enlaces
  Future<void> _abrirEnlace(BuildContext context, String urlStr) async {
    try {
      final Uri url = Uri.parse(urlStr);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('No se pudo lanzar $urlStr');
      }
    } catch (e) {
      debugPrint("Error al abrir enlace: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "SYSTEM_ERROR // Permite las ventanas emergentes en tu navegador."),
          backgroundColor: Colors.redAccent,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Función de ayuda para traducir
    String t(String llave) => Traductor.obtener(llave, idiomaGlobal);

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 20),

        // BOTÓN VOLVER
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: onVolver,
            icon:
                const Icon(Icons.arrow_back_ios, size: 12, color: Colors.cyan),
            label: Text(
              t('btn_volver'),
              style: const TextStyle(color: Colors.cyan),
            ),
          ),
        ),

        const SizedBox(height: 30),

        // TÍTULO DE SECCIÓN
        // RESPONSIVE: fontSize más pequeño en móvil para que no se parta en dos líneas
        Text(
          t('c_titulo'),
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width < 600 ? 18 : 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),

        const SizedBox(height: 20),

        // CAJA DE ESTADO
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.greenAccent.withOpacity(0.05),
            border: Border.all(color: Colors.greenAccent.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            t('c_estado'),
            style: const TextStyle(
              color: Colors.greenAccent,
              fontFamily: 'monospace',
              fontSize: 13,
              height: 1.6,
              letterSpacing: 1,
            ),
          ),
        ),

        const SizedBox(height: 50),

        // BOTONES DE CONTACTO
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 550),
            child: Column(
              children: [
                _buildContactoBoton(
                  context: context,
                  titulo: t('c_email_t'),
                  subtitulo: "loren.mdl_03@hotmail.com",
                  icono: Icons.email_outlined,
                  color: Colors.orangeAccent,
                  urlDestino: "mailto:loren.mdl_03@hotmail.com",
                ),
                const SizedBox(height: 20),
                _buildContactoBoton(
                  context: context,
                  titulo: t('c_link_t'),
                  subtitulo: "LinkedIn // Lorenzo Camacho Garcia",
                  icono: Icons.work_outline,
                  color: Colors.cyanAccent,
                  urlDestino:
                      "https://www.linkedin.com/in/lorenzo-camacho-garcia",
                ),
                const SizedBox(height: 20),
                _buildContactoBoton(
                  context: context,
                  titulo: t('c_git_t'),
                  subtitulo: "GitHub // Vecors12",
                  icono: Icons.code,
                  color: Colors.white70,
                  urlDestino: "https://github.com/Vecors12",
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildContactoBoton({
    required BuildContext context,
    required String titulo,
    required String subtitulo,
    required IconData icono,
    required Color color,
    required String urlDestino,
  }) {
    return InkWell(
      onTap: () => _abrirEnlace(context, urlDestino),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: color.withOpacity(0.6), width: 1.5),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.08), blurRadius: 15, spreadRadius: 1)
          ],
        ),
        child: Row(
          children: [
            Icon(icono, color: color, size: 32),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      color: color,
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
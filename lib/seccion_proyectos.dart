import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'traducciones.dart';

class SeccionProyectos extends StatelessWidget {
  final VoidCallback onVolver;
  final String idiomaGlobal;

  const SeccionProyectos(
      {super.key, required this.onVolver, required this.idiomaGlobal});

  Future<void> _abrirEnlace(BuildContext context, String urlStr) async {
    try {
      final Uri url = Uri.parse(urlStr);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('No se pudo lanzar $urlStr');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("SYSTEM_ERROR // No se pudo abrir el enlace."),
          backgroundColor: Colors.redAccent,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String t(String llave) => Traductor.obtener(llave, idiomaGlobal);

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: onVolver,
            icon:
                const Icon(Icons.arrow_back_ios, size: 12, color: Colors.cyan),
            label: Text(t('btn_volver'),
                style: const TextStyle(color: Colors.cyan)),
          ),
        ),
        const SizedBox(height: 30),
        // RESPONSIVE: fontSize reducido en móvil para que no se parta
        Text(t('p_titulo'),
            style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width < 600 ? 18 : 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace')),
        const SizedBox(height: 40),
        _buildProyectoCard(
          context: context,
          titulo: t('p_1_t'),
          descripcion: t('p_1_d'),
          techStack: "FLUTTER / DART / ANIMATIONS",
          color: Colors.cyanAccent,
          url: "https://github.com/Vecors12",
          btnTexto: t('p_btn_ver'),
        ),
        const SizedBox(height: 25),
        _buildProyectoCard(
          context: context,
          titulo: t('p_2_t'),
          descripcion: t('p_2_d'),
          techStack: "PYTHON / LOGIC / UI", // <--- CORREGIDO A PYTHON
          color: Colors.orangeAccent,
          url: "https://github.com/Vecors12",
          btnTexto: t('p_btn_ver'),
        ),
        const SizedBox(height: 25),
        _buildProyectoCard(
          context: context,
          titulo: t('p_3_t'),
          descripcion: t('p_3_d'),
          techStack: "PRIVATE / ENCRYPTED",
          color: Colors.redAccent,
          url: "",
          esPrivado: true,
          btnTexto: t('p_btn_ver'), // <--- ESTO ES LO QUE FALTABA Y DABA ERROR
          statusTexto: t('p_status_enc'),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildProyectoCard({
    required BuildContext context,
    required String titulo,
    required String descripcion,
    required String techStack,
    required Color color,
    required String url,
    required String btnTexto,
    bool esPrivado = false,
    String? statusTexto,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        border: Border.all(color: color.withOpacity(0.5), width: 1.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // RESPONSIVE: Flexible evita que el título largo desborde por la derecha
              Flexible(
                child: Text(
                  titulo,
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'monospace'),
                ),
              ),
              Icon(esPrivado ? Icons.lock_outline : Icons.folder_open,
                  color: color, size: 20),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            descripcion,
            style: const TextStyle(
                color: Colors.white70, height: 1.5, fontSize: 13),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                techStack,
                style: TextStyle(
                    color: color.withOpacity(0.7),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1),
              ),
              if (!esPrivado)
                TextButton(
                  onPressed: () => _abrirEnlace(context, url),
                  child: Text(btnTexto,
                      style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                )
              else
                Text(statusTexto ?? "",
                    style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
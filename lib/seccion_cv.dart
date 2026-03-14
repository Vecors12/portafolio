import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'traducciones.dart';

class SeccionCV extends StatefulWidget {
  final VoidCallback onVolver;
  final String idiomaGlobal; // Recibimos el idioma de la estación

  const SeccionCV(
      {super.key, required this.onVolver, required this.idiomaGlobal});

  @override
  State<SeccionCV> createState() => _SeccionCVState();
}

class _SeccionCVState extends State<SeccionCV> {
  // Idioma del archivo PDF que se va a abrir (Independiente del idioma de la web)
  String idiomaSeleccionadoPDF = "DE";

  Future<void> _abrirPDF() async {
    final String ruta =
        "assets/assets/cv_${idiomaSeleccionadoPDF.toLowerCase()}.pdf";
    try {
      final Uri url = Uri.parse(ruta);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $ruta';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Error: No se encuentra el archivo PDF")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usamos el traductor con el idioma que viene por parámetro
    String t(String key) => Traductor.obtener(key, widget.idiomaGlobal);

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: widget.onVolver,
            icon:
                const Icon(Icons.arrow_back_ios, size: 12, color: Colors.cyan),
            label: Text(t('btn_volver'),
                style: const TextStyle(color: Colors.cyan)),
          ),
        ),
        const SizedBox(height: 30),
        // RESPONSIVE: fontSize más pequeño en móvil para que el título no se parta
        Text(t('cv_titulo'),
            style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width < 600 ? 18 : 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace')),
        const SizedBox(height: 40),

        // Botones para elegir el idioma del PDF (Traducidos según idiomaGlobal)
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 15,
          runSpacing: 15,
          children: ["ES", "EN", "DE"].map((lang) {
            bool activo = idiomaSeleccionadoPDF == lang;

            String etiqueta;
            if (lang == "ES")
              etiqueta = t('cv_lang_es');
            else if (lang == "EN")
              etiqueta = t('cv_lang_en');
            else
              etiqueta = t('cv_lang_de');

            return InkWell(
              onTap: () => setState(() => idiomaSeleccionadoPDF = lang),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: activo
                      ? Colors.orangeAccent.withOpacity(0.2)
                      : Colors.transparent,
                  border: Border.all(
                      color: activo ? Colors.orangeAccent : Colors.white30),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  etiqueta,
                  style: TextStyle(
                      color: activo ? Colors.orangeAccent : Colors.white54,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontFamily: 'monospace'),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 60),

        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildSkillBadge("FLUTTER", Colors.cyanAccent),
            _buildSkillBadge("JAVA", Colors.cyanAccent),
            _buildSkillBadge("PYTHON", Colors.cyanAccent),
            _buildSkillBadge("SQL", Colors.cyanAccent),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildSkillBadge("HTML / CSS", Colors.orangeAccent),
            _buildSkillBadge("IT SECURITY", Colors.orangeAccent),
            _buildSkillBadge("HARDWARE", Colors.orangeAccent),
            _buildSkillBadge("WINDOWS OS", Colors.orangeAccent),
          ],
        ),

        const SizedBox(height: 70),

        Center(
          child: InkWell(
            onTap: _abrirPDF,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.cyanAccent, width: 2),
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
                    "${t('cv_abrir')} CV_$idiomaSeleccionadoPDF.PDF",
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
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildSkillBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.8), width: 1.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
            letterSpacing: 1),
      ),
    );
  }
}
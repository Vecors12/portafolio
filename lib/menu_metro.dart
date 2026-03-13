import 'package:flutter/material.dart';
import 'traducciones.dart';

class MenuMetro extends StatelessWidget {
  final String seccionActual;
  final String idioma;
  final Function(String) alSeleccionar;

  const MenuMetro(
      {super.key,
      required this.seccionActual,
      required this.idioma,
      required this.alSeleccionar});

  @override
  Widget build(BuildContext context) {
    String t(String llave) => Traductor.obtener(llave, idioma);
    
    // Escala matemática
    double w = MediaQuery.of(context).size.width;
    double escala = w < 800 ? w / 800 : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _construirNodo("HOME", Colors.white, t('m_home'), escala),
        _construirLinea(Colors.white, Colors.orangeAccent, escala),
        _construirNodo("CV", Colors.orangeAccent, t('m_cv'), escala),
        _construirLinea(Colors.orangeAccent, Colors.cyanAccent, escala),
        _construirNodo("SOBRE MÍ", Colors.cyanAccent, t('m_sobre'), escala),
        _construirLinea(Colors.cyanAccent, Colors.lightGreenAccent, escala),
        _construirNodo("PROYECTOS", Colors.lightGreenAccent, t('m_proy'), escala),
        _construirLinea(Colors.lightGreenAccent, Colors.purpleAccent, escala),
        _construirNodo("IDIOMAS", Colors.purpleAccent, t('m_idioma'), escala),
        _construirLinea(Colors.purpleAccent, Colors.redAccent, escala),
        _construirNodo("CONTACTO", Colors.redAccent, t('m_cont'), escala),
      ],
    );
  }

  Widget _construirNodo(String idSeccion, Color colorNodo, String textoVisible, double escala) {
    bool estaActiva = (seccionActual == idSeccion);

    return InkWell(
      onTap: () => alSeleccionar(idSeccion),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            textoVisible,
            style: TextStyle(
                color: estaActiva ? colorNodo : Colors.white.withOpacity(0.7),
                fontWeight: estaActiva ? FontWeight.bold : FontWeight.normal,
                letterSpacing: 2 * escala,
                fontSize: 10 * (escala < 1.0 ? escala * 1.2 : 1.0), // Ajuste ligero para que no quede ilegible en móvil
                fontFamily: 'monospace'),
          ),
          SizedBox(width: 12 * escala),
          SizedBox(
            width: 50 * escala,
            child: Center(
              child: Container(
                width: 14 * escala,
                height: 14 * escala,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: colorNodo, width: estaActiva ? (3 * escala) : (1.5 * escala)),
                  shape: BoxShape.circle,
                  boxShadow: estaActiva ? [BoxShadow(color: colorNodo, blurRadius: 10 * escala)] : [],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirLinea(Color colorArriba, Color colorAbajo, double escala) {
    return SizedBox(
      width: 50 * escala,
      height: 15 * escala,
      child: Center(
        child: Container(
          width: 2 * escala,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [colorArriba.withOpacity(0.5), colorAbajo.withOpacity(0.5)])),
        ),
      ),
    );
  }
}
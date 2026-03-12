// Importación principal de Flutter para los widgets visuales
import 'package:flutter/material.dart';

// Importación del diccionario de traducciones
import 'traducciones.dart';

/// [MenuMetro] es el componente visual que dibuja el menú derecho.
/// Es "Stateless" porque no guarda memoria, solo dibuja lo que la estación le ordena.
class MenuMetro extends StatelessWidget {
  // ==========================================
  // PROPIEDADES INMUTABLES
  // ==========================================
  // IMPORTANTE: Mantenemos los nombres originales para NO romper estacion_principal.dart

  /// Indica qué sección está activa actualmente.
  final String seccionActual;

  /// El idioma activo para traducir los botones.
  final String idioma;

  /// Función que se dispara cuando el usuario hace clic en una sección.
  final Function(String) alSeleccionar;

  /// Constructor obligatorio.
  const MenuMetro(
      {super.key,
      required this.seccionActual,
      required this.idioma,
      required this.alSeleccionar});

  // ==========================================
  // CONSTRUCCIÓN VISUAL
  // ==========================================

  @override
  Widget build(BuildContext context) {
    // Función rápida para traducir usando la propiedad 'idioma'
    String t(String llave) => Traductor.obtener(llave, idioma);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Nodo 1: HOME
        _construirNodo("HOME", Colors.white, t('m_home')),
        _construirLinea(Colors.white, Colors.orangeAccent),

        // Nodo 2: CV
        _construirNodo("CV", Colors.orangeAccent, t('m_cv')),
        _construirLinea(Colors.orangeAccent, Colors.cyanAccent),

        // Nodo 3: SOBRE MÍ
        _construirNodo("SOBRE MÍ", Colors.cyanAccent, t('m_sobre')),
        _construirLinea(Colors.cyanAccent, Colors.lightGreenAccent),

        // Nodo 4: PROYECTOS
        _construirNodo("PROYECTOS", Colors.lightGreenAccent, t('m_proy')),
        _construirLinea(Colors.lightGreenAccent, Colors.purpleAccent),

        // Nodo 5: IDIOMAS
        _construirNodo("IDIOMAS", Colors.purpleAccent, t('m_idioma')),
        _construirLinea(Colors.purpleAccent, Colors.redAccent),

        // Nodo 6: CONTACTO (Sin línea debajo)
        _construirNodo("CONTACTO", Colors.redAccent, t('m_cont')),
      ],
    );
  }

  // ==========================================
  // WIDGETS PRIVADOS DE DIBUJO
  // ==========================================

  /// Dibuja el texto y el círculo iluminado de una sección.
  Widget _construirNodo(
      String idSeccion, Color colorNodo, String textoVisible) {
    // Comprueba si este botón es el que debe estar encendido
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
                letterSpacing: 2,
                fontSize: 10,
                fontFamily: 'monospace'),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 50,
            child: Center(
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.black,
                  // El borde engorda si está activo
                  border:
                      Border.all(color: colorNodo, width: estaActiva ? 3 : 1.5),
                  shape: BoxShape.circle,
                  // Proyecta luz si está activo
                  boxShadow: estaActiva
                      ? [BoxShadow(color: colorNodo, blurRadius: 10)]
                      : [],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Dibuja la línea con gradiente que une dos secciones.
  Widget _construirLinea(Color colorArriba, Color colorAbajo) {
    return SizedBox(
      width: 50,
      height: 15,
      child: Center(
        child: Container(
          width: 2,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                colorArriba.withOpacity(0.5),
                colorAbajo.withOpacity(0.5)
              ])),
        ),
      ),
    );
  }
}

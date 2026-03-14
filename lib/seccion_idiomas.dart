// Importación principal de Flutter
import 'package:flutter/material.dart';

// Importación de nuestro sistema central de traducciones
import 'traducciones.dart';

/// [SeccionIdiomas] es la vista que permite al usuario cambiar el idioma global de la app.
/// Es un [StatelessWidget] porque el estado real (el idioma activo) vive en la Estación Principal.
class SeccionIdiomas extends StatelessWidget {
  // ==========================================
  // PROPIEDADES INMUTABLES (Seguridad)
  // ==========================================
  // ATENCIÓN: Nombres exactos para no romper el enchufe con EstacionPrincipal.

  /// Idioma que está seleccionado actualmente en todo el sistema.
  final String idiomaActual;

  /// Función que avisa a la estación principal de que el usuario quiere cambiar de idioma.
  final Function(String) alCambiarIdioma;

  /// Función callback para regresar al andén (menú principal).
  final VoidCallback onVolver;

  /// Constructor estricto.
  const SeccionIdiomas({
    super.key,
    required this.idiomaActual,
    required this.alCambiarIdioma,
    required this.onVolver,
  });

  // ==========================================
  // CONSTRUCCIÓN VISUAL PRINCIPAL
  // ==========================================

  @override
  Widget build(BuildContext context) {
    // Función rápida para traducir textos dinámicos
    String t(String llave) => Traductor.obtener(llave, idiomaActual);

    return ListView(
      // Scroll suave y rebotante para una experiencia perfecta en pantallas táctiles
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 20), // Espacio tras el HUD

        // 1. Botón superior de retroceso
        _construirBotonVolver(t('btn_volver')),
        const SizedBox(height: 30),

        // 2. Título principal de la sección de ajustes
        _construirTituloSeccion("SYSTEM_SETTINGS // ${t('m_idioma')}"),
        const SizedBox(height: 50),

        // 3. Lista de botones de selección de idioma
        // Los nombres de los idiomas se dejan fijos en su idioma nativo (como tenías previsto)
        // para que cualquier usuario pueda reconocerlos sin importar el idioma activo actual.
        _construirBotonIdioma(
          nombre: "ESPAÑOL",
          codigo: "ES",
          icono: Icons.language,
        ),
        const SizedBox(height: 20),

        _construirBotonIdioma(
          nombre: "ENGLISH",
          codigo: "EN",
          icono: Icons.translate,
        ),
        const SizedBox(height: 20),

        _construirBotonIdioma(
          nombre: "DEUTSCH",
          codigo: "DE",
          icono: Icons.location_city,
        ),

        const SizedBox(
            height:
                80), // Margen inferior para que el último botón no quede pegado abajo
      ],
    );
  }

  // ==========================================
  // WIDGETS PRIVADOS DE DIBUJO (Limpieza)
  // ==========================================

  /// Dibuja el botón de "VOLVER AL ANDÉN".
  Widget _construirBotonVolver(String texto) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: onVolver,
        icon: const Icon(Icons.arrow_back_ios, size: 12, color: Colors.cyan),
        label: Text(
          texto,
          style: const TextStyle(color: Colors.cyan),
        ),
      ),
    );
  }

  /// Dibuja el título de la sección simulando la interfaz de una terminal.
  Widget _construirTituloSeccion(String texto) {
    // RESPONSIVE: En móvil reducimos a 18px para que el título largo no se parta
    // El comentario original decía "Tamaño seguro" pero 24 se parte en monospace en móvil
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool esMovil = MediaQuery.of(context).size.width < 600;
        return Text(
          texto,
          style: TextStyle(
            color: Colors.white,
            fontSize: esMovil ? 16 : 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        );
      },
    );
  }

  /// Construye cada botón individual interactivo para seleccionar un idioma.
  /// Es 100% responsivo (se adapta al ancho disponible).
  Widget _construirBotonIdioma({
    required String nombre,
    required String codigo,
    required IconData icono,
  }) {
    // Comprobamos si este botón corresponde al idioma que está activo ahora mismo
    bool estaActivo = (idiomaActual == codigo);

    return InkWell(
      // Al tocar, lanzamos la orden de cambio hacia la EstacionPrincipal
      onTap: () => alCambiarIdioma(codigo),
      child: Container(
        width: double
            .infinity, // Se estira a todo lo ancho sin importar la pantalla
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // Si está activo, tiene un fondo sutil cyan, si no, es negro opaco
          color: estaActivo ? Colors.cyanAccent.withOpacity(0.1) : Colors.black,
          border: Border.all(
            color: estaActivo ? Colors.cyanAccent : Colors.white24,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            // Icono decorativo a la izquierda
            Icon(
              icono,
              color: estaActivo ? Colors.cyanAccent : Colors.white54,
            ),
            const SizedBox(width: 20),

            // Nombre del idioma
            Text(
              nombre,
              style: TextStyle(
                color: estaActivo ? Colors.cyanAccent : Colors.white,
                fontWeight: estaActivo ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'monospace',
              ),
            ),

            const Spacer(), // Empuja el check hacia la derecha del todo

            // Si está seleccionado, mostramos un 'check' indicativo a la derecha
            if (estaActivo)
              const Icon(
                Icons.check_circle,
                color: Colors.cyanAccent,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

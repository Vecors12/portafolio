class Traductor {
  static String obtener(String llave, String lang) {
    Map<String, Map<String, String>> textos = {
      'ES': {
        // Menú
        'm_home': 'EL ANDÉN', 'm_cv': 'CURRICULUM', 'm_sobre': 'SOBRE MÍ',
        'm_proy': 'PROYECTOS', 'm_idioma': 'IDIOMAS', 'm_cont': 'CONTACTO',
        'btn_volver': 'VOLVER AL ANDÉN',

        // Sobre Mí
        's_titulo': 'REGISTRO DE USUARIO // LOREN',
        's_01_t': '01 // SOBRE MÍ',
        's_01_d':
            'Mi perfil se define por la resiliencia; he cambiado de país y sector buscando retos a mi altura técnica y humana. Soy leal a los proyectos en los que creo, pero me niego a ser un pájaro enjaulado sin reciprocidad. Mi regla es simple: un profesional con una ruta clara y sin ruidos externos es el doble de productivo.',
        's_02_t': '02 // ESTUDIOS',
        's_02_d':
            'Mi trayectoria arranca como monitor de ocio y avanza hacia el Grado Medio de Electrónica. Tras realizar un Ausbildung de panadería en Alemania, regresé a España para titularme en el Grado Superior de DAM e iniciar mi especialización en seguridad informática. Actualmente, de vuelta en Alemania, consolido mi perfil técnico cursando un Bootcamp de un año en IT Security.',
        's_03_t': '03 // EXPERIENCIA LABORAL',
        's_03_d':
            'Empecé trabajando 4 años como monitor de parque multiaventura y realizando prácticas de informática. Durante mi Ausbildung en Alemania trabajé en una panadería, y sumé experiencia como mozo de almacén en diversos sectores de logística y producción. Tras aplicar mi grado DAM desarrollando la web de una empresa, regresé a Alemania, donde llevo año y medio como mozo de almacén en Amazon, rotando por varios departamentos para ampliar mis conocimientos operativos.',
        's_04_t': '04 // RUMBO FIJADO',
        's_04_d':
            'Mi meta para este 2026 es dar el salto definitivo de la logística física al sector tecnológico, consolidando mi perfil con el Bootcamp de IT Security. Busco integrarme en un equipo serio y con una ruta clara, donde pueda aplicar al código y a la protección de sistemas la misma disciplina todoterreno que he forjado en los almacenes. Quiero demostrar que la lealtad y el trabajo duro aportan el mismo valor real frente a una pantalla.',

        // Proyectos
        'p_titulo': 'CORE_SYSTEM // PROYECTOS',
        'p_1_t': 'PORTFOLIO 2026',
        'p_1_d':
            'SPA interactiva desarrollada en Flutter Web. Sistema de navegación basado en estados y animaciones de alto rendimiento con estética Cyberpunk.',
        'p_2_t': 'CALCULADORA PYTHON',
        'p_2_d':
            'Primer desarrollo lógico funcional. Gestión de operaciones matemáticas y manejo de interfaz de usuario dinámica con Python.',
        'p_3_t': 'PROYECTO CLASIFICADO // APP MÓVIL',
        'p_3_d':
            'Desarrollo de aplicación móvil de alto rendimiento. Actualmente en fase beta privada. Foco en optimización y arquitectura limpia.',
        'p_btn_ver': 'VER_CODIGO >',
        'p_status_enc': 'ESTADO: ENCRIPTADO',

        // CV
        'cv_titulo': 'CURRICULUM // SKILLS',
        'cv_lang_es': 'ESPAÑOL', 'cv_lang_en': 'INGLÉS', 'cv_lang_de': 'ALEMÁN',
        'cv_abrir': 'ABRIR PDF',

        // Contacto
        'c_titulo': 'SECURE_COMMS // CONTACTO',
        'c_estado':
            'ESTADO_SISTEMA: ONLINE\nLOCALIZACIÓN: ROSTOCK, DE\nDISPONIBILIDAD: ABIERTO a NUEVOS PROYECTOS',
        'c_email_t': '[ INICIAR PROTOCOLO DE EMAIL ]',
        'c_link_t': '[ ACCEDER A RED PROFESIONAL ]',
        'c_git_t': '[ ENTRAR AL REPOSITORIO ]',
      },
      'EN': {
        'm_home': 'THE PLATFORM',
        'm_cv': 'RESUME',
        'm_sobre': 'ABOUT ME',
        'm_proy': 'PROJECTS',
        'm_idioma': 'LANGUAGES',
        'm_cont': 'CONTACT',
        'btn_volver': 'BACK TO PLATFORM',
        's_titulo': 'USER LOG // LOREN',
        's_01_t': '01 // ABOUT ME',
        's_01_d':
            'My profile is defined by resilience; I have changed countries and sectors seeking challenges at my technical and human level. I am loyal to the projects I believe in, but I refuse to be a caged bird without reciprocity. My rule is simple: a professional with a clear path and no external noise is twice as productive.',
        's_02_t': '02 // EDUCATION',
        's_02_d':
            'My career started as a leisure monitor and moved towards a vocational degree in Electronics. After completing a bakery apprenticeship in Germany, I returned to Spain to get my Higher Degree in Web App Development (DAM) and start my specialization in computer security. Currently, back in Germany, I am consolidating my technical profile by taking a one-year Bootcamp in IT Security.',
        's_03_t': '03 // EXPERIENCE',
        's_03_d':
            'I started working for 4 years as a multi-adventure park monitor and doing IT internships. During my apprenticeship in Germany, I worked in a bakery and gained experience as a warehouse worker in various logistics and production sectors. After applying my DAM degree by developing a company website, I returned to Germany, where I have been working as a warehouse worker at Amazon for a year and a half, rotating through several departments to expand my operational knowledge.',
        's_04_t': '04 // TARGET',
        's_04_d':
            'My goal for 2026 is to make the definitive leap from physical logistics to the technology sector, consolidating my profile with the IT Security Bootcamp. I seek to join a serious team with a clear path, where I can apply the same all-terrain discipline I forged in warehouses to code and system protection. I want to prove that loyalty and hard work bring the same real value in front of a screen.',
        'p_titulo': 'CORE_SYSTEM // PROJECTS',
        'p_1_t': 'PORTFOLIO 2026',
        'p_1_d':
            'Interactive SPA developed in Flutter Web. State-based navigation system and high-performance animations with Cyberpunk aesthetics.',
        'p_2_t': 'PYTHON CALCULATOR',
        'p_2_d':
            'First functional logical development. Management of mathematical operations and dynamic user interface handling with Python.',
        'p_3_t': 'CLASSIFIED PROJECT // MOBILE APP',
        'p_3_d':
            'High-performance mobile application development. Currently in private beta phase. Focus on optimization and clean architecture.',
        'p_btn_ver': 'VIEW_CODE >',
        'p_status_enc': 'STATUS: ENCRYPTED',
        'cv_titulo': 'RESUME // SKILLS',
        'cv_lang_es': 'SPANISH',
        'cv_lang_en': 'ENGLISH',
        'cv_lang_de': 'GERMAN',
        'cv_abrir': 'OPEN PDF',
        'c_titulo': 'SECURE_COMMS // CONTACT',
        'c_estado':
            'SYSTEM_STATUS: ONLINE\nLOCATION: ROSTOCK, DE\nAVAILABILITY: OPEN TO NEW PROJECTS',
        'c_email_t': '[ INITIALIZE EMAIL PROTOCOL ]',
        'c_link_t': '[ ACCESS PROFESSIONAL NETWORK ]',
        'c_git_t': '[ ENTER REPOSITORY ]',
      },
      'DE': {
        'm_home': 'DER BAHNSTEIG',
        'm_cv': 'LEBENSLAUF',
        'm_sobre': 'ÜBER MICH',
        'm_proy': 'PROJEKTE',
        'm_idioma': 'SPRACHEN',
        'm_cont': 'KONTAKT',
        'btn_volver': 'ZURÜCK ZUM BAHNSTEIG',
        's_titulo': 'BENUTZERPROTOKOLL // LOREN',
        's_01_t': '01 // ÜBER MICH',
        's_01_d':
            'Mein Profil ist von Resilienz geprägt; ich habe Länder und Branchen gewechselt, um Herausforderungen auf meinem technischen und menschlichen Niveau zu finden. Ich bin den Projekten, an die ich glaube, treu, weigere mich aber, ein Vogel im Käfig ohne Gegenseitigkeit zu sein. Meine Regel ist einfach: Ein Profi mit einem klaren Weg und ohne äußere Störgeräusche ist doppelt so produktiv.',
        's_02_t': '02 // AUSBILDUNG',
        's_02_d':
            'Meine Laufbahn begann als Freizeitbetreuer und entwickelte sich zum Abschluss als Elektroniker. Nach einer Ausbildung zum Bäcker in Deutschland kehrte ich nach Spanien zurück, um meinen Abschluss als Fachinformatiker für Anwendungsentwicklung (DAM) zu machen und meine Spezialisierung auf IT-Sicherheit zu beginnen. Derzeit festige ich in Deutschland mein technisches Profil durch die Teilnahme an einem einjährigen IT-Security-Bootcamp.',
        's_03_t': '03 // ERFAHRUNG',
        's_03_d':
            'Ich habe 4 Jahre als Betreuer in einem Kletterpark gearbeitet und IT-Praktika absolviert. Während meiner Ausbildung in Deutschland arbeitete ich in einer Bäckerei und sammelte Erfahrung als Lagerhelfer in verschiedenen Bereichen der Logistik und Produktion. Nachdem ich meinen DAM-Abschluss für die Website-Entwicklung eines Unternehmens genutzt hatte, kehrte ich nach Deutschland zurück, wo ich seit anderthalb Jahren als Lagerhelfer bei Amazon arbeite und in verschiedenen Abteilungen rotiere, um meine operativen Kenntnisse zu erweitern.',
        's_04_t': '04 // ZIELSETZUNG',
        's_04_d':
            'Mein Ziel für 2026 ist der endgültige Wechsel von der physischen Logistik in den Technologiesektor durch den Abschluss des IT-Security-Bootcamps. Ich suche den Einstieg in ein seriöses Team con un claro camino, en el que pueda aplicar la disciplina forjada en el almacén a la programación y protección de sistemas. Quiero demostrar que la lealtad y el trabajo duro ante la pantalla tienen el mismo valor real.',
        'p_titulo': 'KERNSYSTEM // PROJEKTE',
        'p_1_t': 'PORTFOLIO 2026',
        'p_1_d':
            'Interaktive SPA, entwickelt mit Flutter Web. Zustandsbasiertes Navigationssystem und Hochleistungsanimationen mit Cyberpunk-Ästhetik.',
        'p_2_t': 'PYTHON RECHNER',
        'p_2_d':
            'Erste funktionale logische Entwicklung. Verwaltung mathematischer Operationen und dynamische Benutzeroberfläche mit Python.',
        'p_3_t': 'KLASSIFIZIERTES PROJEKT // MOBILE APP',
        'p_3_d':
            'Entwicklung einer Hochleistungs-Mobil-App. Derzeit in privater Beta-Phase. Fokus auf Optimierung und saubere Architektur.',
        'p_btn_ver': 'CODE_ANZEIGEN >',
        'p_status_enc': 'STATUS: VERSCHLÜSSELT',
        'cv_titulo': 'LEBENSLAUF // SKILLS',
        'cv_lang_es': 'SPANISCH',
        'cv_lang_en': 'ENGLISCH',
        'cv_lang_de': 'DEUTSCH',
        'cv_abrir': 'PDF ÖFFNEN',
        'c_titulo': 'SECURE_COMMS // KONTAKT',
        'c_estado':
            'SYSTEMSTATUS: ONLINE\nSTANDORT: ROSTOCK, DE\nVERFÜGBARKEIT: OFFEN FÜR NEUE PROJEKTE',
        'c_email_t': '[ E-MAIL-PROTOKOLL STARTEN ]',
        'c_link_t': '[ BERUFLICHES NETZWERK AUFRUFEN ]',
        'c_git_t': '[ REPOSITORY BETRETEN ]',
      }
    };
    return textos[lang]?[llave] ?? llave;
  }
}

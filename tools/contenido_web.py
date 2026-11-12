#!/usr/bin/env python3
"""EL CONTENIDO de la web de esta ROM: lo unico que es de este cartucho.

jekyll.py y make_web.py son la maquinaria y no llevan dentro el nombre de
ningun juego: lo leen de aqui.

Todas las cifras de aqui estan medidas sobre esta ROM, con las herramientas
de tools/: CODIGO y DATOS los imprime tools/presupuesto.py (make sanity),
INSTRUCCIONES, COMENTARIOS y RUTINAS los da tools/densidad.py (make densidad:
"de N" rutinas, "N instrucciones, M comentarios").
"""

NOMBRE = "Game Land"
EDITOR = "Casio"
ANIO = 1984
REPOSITORIO = "https://github.com/antxiko/GameLand-disassembly"
SHA1 = "39ffaacd0c2875018e7673a887a921fe9d31d6dc"

CODIGO = 26084
DATOS = 6684
RUTINAS = 1904
INSTRUCCIONES = 13827
COMENTARIOS = 6365


def densidad(idioma):
    """El porcentaje comentado, con la coma o el punto de cada idioma."""
    d = "%.1f" % (100.0 * COMENTARIOS / INSTRUCCIONES)
    return d.replace(".", ",") if idioma == "es" else d


PIE_LEGAL = {
    "es": "<em>Game Land</em> (ゲームランド) es un programa de Casio para MSX, de 1984, en un cartucho de 32 KB. Todos "
          "los derechos sobre el programa siguen siendo de sus titulares. Este trabajo es de preservaci&oacute;n, "
          "estudio y documentaci&oacute;n, y la imagen de la ROM no se distribuye.",
    "en": "<em>Game Land</em> (ゲームランド) is a 1984 Casio program for the MSX, on a 32 KB cartridge. All rights in "
          "the program remain with their holders. This is preservation, study and documentation work, and the ROM "
          "image is not distributed.",
}

PORTADA = {
    "es": dict(
        titulo="Game Land - desensamblado comentado",
        claim="Game Land no es un juego: es un cartucho para <b>hacer juegos</b> sin programar. Se elige la clase "
              "(de combate o de laberinto) y el fondo, se dibuja con LINE, BOX, CIRCLE y PAINT, se hacen los "
              "personajes punto a punto o con sus 20 muestras, se componen las m&uacute;sicas en un pentagrama, se "
              "decide c&oacute;mo se mueve cada uno y se juega; despu&eacute;s se guarda en cinta. Aqu&iacute; "
              "est&aacute; entero por dentro: 26.084 bytes de c&oacute;digo, con un motor que juega lo que se hace "
              "y una biblioteca de dibujo propia.",
        ficha=["Casio - <b>(c) 1984</b>",
               "Cartucho de <b>32 KB</b> (cabecera en 0x4000)",
               "<b>MSX</b> (la fuente japonesa: Casio PV-16)", "Volcado <b>39ffaacd...</b>"],
        aviso="<b>Aqu&iacute; no hay capturas.</b> Los GIF son la ROM <b>funcionando en openMSX</b> (un Casio PV-16) "
              "con un guion sacado del listado: en cada cuadro se apuntan la VRAM, la RAM y los registros del VDP, y "
              "<b>c&oacute;digo nuestro los pinta</b>. Las muestras salen de los bytes de la ROM.",
    ),
    "en": dict(
        titulo="Game Land - commented disassembly",
        claim="Game Land is not a game: it is a cartridge for <b>making games</b> without programming. You pick the "
              "kind (a shooting game or a maze) and the background, draw it with LINE, BOX, CIRCLE and PAINT, make "
              "the characters dot by dot or from its 20 samples, compose the tunes on a staff, decide how each one "
              "moves and play it; then you save it to tape. Here it is, all of it, from the inside: 26,084 bytes of "
              "code, with an engine that plays what you make and its own drawing library.",
        ficha=["Casio - <b>(c) 1984</b>",
               "<b>32 KB</b> cartridge (header at 0x4000)",
               "<b>MSX</b> (the Japanese font: Casio PV-16)", "Dump <b>39ffaacd...</b>"],
        aviso="<b>There are no screenshots here.</b> The GIFs are the ROM <b>running in openMSX</b> (a Casio PV-16) "
              "with a script taken from the listing: on every frame the VRAM, the RAM and the VDP registers are "
              "logged, and <b>our own code paints them</b>. The samples come from the bytes of the ROM.",
    ),
}

PAGINAS = [
    [("THE-PROGRAM.html", "EL-PROGRAMA.html", "The program", "El programa",
      "the intro, the menus (in Japanese and translated), the keys and the kinds of game",
      "la presentaci&oacute;n, los men&uacute;s (en japon&eacute;s y traducidos), las teclas y las clases de "
      "juego"),
     ("THE-EDITORS.html", "LOS-EDITORES.html", "The editors", "Los editores",
      "a background drawn with its tools, characters from the samples, the sounds, the story and the movements",
      "un fondo dibujado con sus herramientas, personajes con las muestras, los sonidos, la historia y los "
      "movimientos"),
     ("THE-MUSIC.html", "LA-MUSICA.html", "The music", "La m&uacute;sica",
      "the four sample tunes, from its own sound engine",
      "las cuatro m&uacute;sicas de muestra, de su propio motor de sonido"),
     ("THE-SPRITES.html", "LOS-SPRITES.html", "The sprites", "Los sprites",
      "the program's own sprites, its cursors and the clefs, drawn by running its own routine",
      "los sprites del propio programa, sus cursores y las claves, pintados ejecutando su propia rutina")],
    [("CURIOSITIES.html", "CURIOSIDADES.html", "Curiosities", "Curiosidades",
      "a second cartridge, a tablet, code that writes code, randomness read from the ROM, dead code",
      "un segundo cartucho, una tableta, c&oacute;digo que escribe c&oacute;digo, el azar le&iacute;do de la "
      "ROM, c&oacute;digo muerto")],
    [("UNDER-THE-HOOD.html", "POR-DENTRO.html", "Under the hood", "Por dentro",
      "rebuilding the ROM, the cartridge, the game it stores, the engine that plays it, the drawing library, the "
      "tape and the RAM",
      "rehacer la ROM, el cartucho, el juego que guarda, el motor que lo juega, la biblioteca de dibujo, la cinta "
      "y la RAM")],
]

# Repositorio nuevo: no hay paginas viejas que redirigir.
VIEJAS = {}

LOGOTIPO = "logotipo.png"

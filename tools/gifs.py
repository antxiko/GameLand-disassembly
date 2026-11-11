"""Los GIF de la web: tramos de la grabacion de openMSX work/juego.bin (tools/guiones/juego.tcl, grabado una vez con
tools/lanza_graba.ps1 en el Casio PV-16, la maquina de la fuente japonesa), pintados con tools/vdp.py; cada imagen
dura el tiempo emulado que dura en la grabacion.

Los tramos salen de la RAM grabada (0xFA1A el menu, 0xFE6D el modo del editor, 0xF420 los personajes):

  presentacion   la carretera de la presentacion con la nave y su musica, hasta la barra (cuadro 480)
  menus          el menu principal, hacer un juego, de combate, con un fondo, el fondo, dibujar (480-1150)
  fondo          el fondo dibujado con las herramientas: el cielo, el suelo, el sol, la casa y el arbol (1150-4720)
  personajes     dos personajes con las muestras: HERO (el que corre) y KANI (el cangrejo) (4990-7620)

Uso: gifs.py docs/imagenes
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import vdp          # noqa: E402

GRABACION = "juego"
# (fichero, desde, hasta, cada)
TRAMOS = [
    ("presentacion.gif", 40, 470, 2),
    ("menus.gif", 470, 1150, 3),
    ("fondo.gif", 1120, 4720, 4),
    ("personajes.gif", 4990, 7620, 3),
]


def main(salida):
    raiz = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    gifs = {t[0]: vdp.Gif() for t in TRAMOS}
    tope = max(t[2] for t in TRAMOS) + max(t[3] for t in TRAMOS)
    espera = {}
    for n, c in enumerate(vdp.cuadros(os.path.join(raiz, "work", GRABACION + ".bin"))):
        if n > tope:
            break
        for fichero, desde, hasta, cada in TRAMOS:
            if desde <= n <= hasta + cada and (n - desde) % cada == 0:
                if fichero in espera:
                    im, t = espera.pop(fichero)
                    gifs[fichero].pon(im, (c["t"] - t) * 1000.0 / gifs[fichero].ms)
                if n <= hasta:
                    espera[fichero] = (vdp.imagen(c["vram"], c["regs"], 1), c["t"])
    for fichero, desde, hasta, cada in TRAMOS:
        if fichero in espera:
            im, _t = espera.pop(fichero)
            gifs[fichero].pon(im, cada)
        ruta = os.path.join(salida, fichero)
        gifs[fichero].guarda(ruta, 4000)
        print("%-20s %4d imagenes, %8d bytes" % (fichero, len(gifs[fichero]), os.path.getsize(ruta)))


if __name__ == "__main__":
    main(sys.argv[1])

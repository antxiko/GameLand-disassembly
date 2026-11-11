"""Las imagenes que salen de los datos de la ROM, sin emulador:

  muestras.png   las 20 muestras de sprite (0xA541, 32 bytes cada una: un sprite de 16 x 16, la mitad izquierda y
                 la derecha de 16 bytes) en la rejilla de 5 x 4 en que las ensena el editor de personajes (0x69E3)
  logotipo.png   el titulo: la carretera de la presentacion tal como la arma la ROM (0x95DC) en la RAM 0xE000 con las
                 marcas de 0x97A0, los muros, los textos y la nave, pintada con la fuente de la BIOS del PV-16 desde la
                 VRAM grabada (es un cuadro de work/juego.bin: la ROM funcionando en openMSX)

Uso: pantallas.py docs/imagenes
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import vdp          # noqa: E402
from PIL import Image  # noqa: E402

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def muestras(rom):
    W = Image.new("RGB", (5 * 24 + 8, 4 * 24 + 8), vdp.PALETA[4])
    for k in range(20):
        d = rom[0xA541 - 0x4000 + 32 * k:0xA541 - 0x4000 + 32 * k + 32]
        im = Image.new("RGB", (16, 16), vdp.PALETA[1])
        for y in range(16):
            for x in range(16):
                b = d[y + (16 if x >= 8 else 0)]
                if (b >> (7 - (x & 7))) & 1:
                    im.putpixel((x, y), vdp.PALETA[15])
        W.paste(im, (8 + (k % 5) * 24, 8 + (k // 5) * 24))
    return W.resize((W.width * 4, W.height * 4), Image.NEAREST)


def main(salida):
    rom = open(os.path.join(RAIZ, "gameland.rom"), "rb").read()
    muestras(rom).save(os.path.join(salida, "muestras.png"))
    for n, c in enumerate(vdp.cuadros(os.path.join(RAIZ, "work", "juego.bin"))):
        if n == 440:
            vdp.imagen(c["vram"], c["regs"], 2).save(os.path.join(salida, "logotipo.png"))
            break
    for f in ("muestras.png", "logotipo.png"):
        print(f, os.path.getsize(os.path.join(salida, f)))


if __name__ == "__main__":
    main(sys.argv[1])

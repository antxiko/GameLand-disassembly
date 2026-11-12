#!/usr/bin/env python3
"""Los sprites fijos de Game Land MONTADOS DESDE LA ROM (ninguna imagen es una captura).

Game Land es un programa para hacer juegos: los personajes los dibuja quien juega. Los unicos dibujos de sprites que
trae la ROM son los del propio programa (los cursores de los editores, la trama y las claves de la musica), y los pone
`vram_prepara` (0x40D2) en la tabla de dibujos de los sprites (0x1800, el registro 6 = 3). Aqui se EJECUTA esa rutina
con el Z80 de tools/bios.py (la cinta, TAPOOF y STMOTR, y RDVDP no pintan nada y se saltan) y se pintan los dibujos que
deja, de 16 x 16 (el registro 1, 0xE2).

  sprites_fijos.png  los dibujos 0x90-0xE8 que deja vram_prepara: recuadros, esquinas y cruces de los cursores, una
                     trama a cuadros y tres signos de musica (las claves de sol y de fa)

Uso: hojas.py docs/imagenes | hojas.py cotejo
"""
import os
import sys

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(RAIZ, "tools"))
import vdp          # noqa: E402
from bios import Msx        # noqa: E402

ORG = 0x4000
ROM = open(os.path.join(RAIZ, "gameland.rom"), "rb").read()
FONDO = (56, 56, 88)
_VRAM = None


class GameLand(Msx):
    def _bios(self):
        if self.pc == 0x013E:                     # RDVDP: el registro de estado
            self.a = 0
            self.pc = self._pop()
            return
        if self.pc in (0x00E7, 0x00F3):           # TAPOOF, STMOTR: la cinta
            self.pc = self._pop()
            return
        super()._bios()


def vram():
    """La VRAM que deja vram_prepara (0x40D2) ejecutada."""
    global _VRAM
    if _VRAM is None:
        m = GameLand(ROM, ORG)
        m.llama(0x40D2)
        _VRAM = bytes(m.vdp.vram)
    return _VRAM


def dibujos():
    v = vram()
    return [n for n in range(0x80, 0x100, 4) if any(v[0x1800 + 8 * n:0x1800 + 8 * n + 32])]


def pinta(im, v, n, x, y, color, escala=1):
    d = v[0x1800 + n * 8:0x1800 + n * 8 + 32]
    c = vdp.PALETA[color]
    for fila in range(16):
        for col in range(16):
            if (d[fila + (16 if col >= 8 else 0)] >> (7 - (col & 7))) & 1:
                for ey in range(escala):
                    for ex in range(escala):
                        im.putpixel(((x + col) * escala + ex, (y + fila) * escala + ey), c)


def hoja(Image):
    v, E = vram(), 4
    ns = dibujos()
    im = Image.new("RGB", (8 * 20 * E, ((len(ns) + 7) // 8) * 20 * E), FONDO)
    for k, n in enumerate(ns):
        pinta(im, v, n, 2 + 20 * (k % 8), 2 + 20 * (k // 8), 15, E)
    return im


def cotejo():
    """Contra las grabaciones de openMSX (work/*.bin): los dibujos que deja vram_prepara (0x1800 + 8 x 0x90 hasta el
    final de la tabla) contra la VRAM grabada; aparte, los cuadros en que el programa ya ha pisado alguno (los del
    usuario van desde 0x1800)."""
    v = vram()
    a, b = 0x1800 + 8 * 0x90, 0x2000
    tot = dict(iguales=0, muestra=0, distintos=0)
    for grab in ("juego", "explora", "mira", "explora_pv16"):
        ruta = os.path.join(RAIZ, "work", grab + ".bin")
        if not os.path.exists(ruta):
            continue
        try:
            cuadros = list(vdp.cuadros(ruta))
        except AssertionError:
            continue
        for c in cuadros:
            w = c["vram"]
            if not any(w[a:b]):
                continue
            if w[a:b] == v[a:b]:
                tot["iguales"] += 1
            elif w[a:0x1E80] == v[a:0x1E80] and w[0x1F00:b] == v[0x1F00:b]:
                tot["muestra"] += 1         # 0xD0-0xDC: la ventana de muestra del editor (`personaje_muestra`, 0x61BA)
            else:
                tot["distintos"] += 1
    return tot


def main(argv):
    if argv and argv[0] == "cotejo":
        print(cotejo())
        return 0
    from PIL import Image
    salida = argv[0]
    os.makedirs(salida, exist_ok=True)
    hoja(Image).save(os.path.join(salida, "sprites_fijos.png"))
    print("sprites_fijos.png", os.path.getsize(os.path.join(salida, "sprites_fijos.png")), [hex(n) for n in dibujos()])
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

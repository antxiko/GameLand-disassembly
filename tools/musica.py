#!/usr/bin/env python3
"""Las cuatro musicas de muestra de Game Land, EJECUTANDO su propio motor de sonido (ver motor_musica.py).

El motor es `sonido_interrupcion` (0xA20C), una vez por cuadro desde la interrupcion. Un sonido se pide por su
numero en 0xFA9B y tiene que estar en la lista de sonidos del juego (registros de 13 bytes desde 0xF423: el numero,
el nombre y, en +0x0A, el puntero a sus notas). Las cuatro musicas de muestra estan en la ROM (los punteros de
0xA325); la presentacion monta la cuarta asi (0x96AD-0x96BB): 0xF423 = 1, 0xF422 = 1, 0xF42D = 0xA399 y
0xFA9B = 1. Aqui se monta igual, con la pila de sonidos y la cola vacias como las deja `sonido_vacia` (0x9F34), y
se corre 0xA20C cuadro a cuadro; el motor llega al PSG por la BIOS (WRTPSG), que se atrapa.

Las notas: el tempo (+0, cuadros por nota - 1), las marcas (+1: bit 6 REPEAT, bit 4 CHORD), el ruido (+2) y 32
notas (0 acaba, 1 silencio; las demas, el periodo del PSG con los 2 bits de abajo como parte alta).

Uso:  musica.py registros N [cuadros] | mp3 N f.mp3 | todas docs/audio | cotejo
"""
import hashlib
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import motor_musica  # noqa: E402

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# (numero, puntero, fichero, nombre en el menu 0x8D)
MUSICAS = [
    (1, 0xA32D, "musica_boda.mp3", "けっこん (la boda)"),
    (2, 0xA351, "musica_kankan.mp3", "カンカン (cancan)"),
    (3, 0xA375, "musica_carga.mp3", "とつげき (a la carga)"),
    (4, 0xA399, "musica_titulo.mp3", "タイトル (el titulo: la de la presentacion)"),
]
SONIDO = (0xFA71, 0xFAC1)          # la RAM del motor


def cfg(numero):
    ptr = dict((n, p) for n, p, _, _ in MUSICAS)[numero]
    pide = [("b", 0xF423, 1), ("b", 0xF422, 1), ("w", 0xF42D, ptr), ("w", 0xFAA6, 0xFABF),
            ("w", 0xFA2D, 0xFA7B), ("b", 0xFA9B, 1)]
    return dict(rom="gameland.rom", org=0x4000, sp=0xF000, frame=0xA20C,
                pistas={numero: pide}, psg0={7: 0xB8}, ram=SONIDO, hz=60, max_s=120, cuadros_previos=0)


def rom():
    return open(os.path.join(RAIZ, "gameland.rom"), "rb").read()


def ejecuta(numero, maximo=None):
    c = cfg(numero)
    maximo = maximo or c["hz"] * c["max_s"]
    z = motor_musica.arranca(c, rom(), numero)
    a, b = c["ram"]
    cuadros, vistos = [], {}
    for k in range(maximo):
        cuadros.append(motor_musica.cuadro(z))
        h = hashlib.sha1(bytes(z.mem[a:b])).digest()
        if h in vistos:
            return cuadros, (None if vistos[h] == k else vistos[h])
        vistos[h] = k + 1
        if k > 2 and not (z.mem[0xFA78] or z.mem[0xFA9B]):
            return cuadros, None
    return cuadros, None


def mp3(numero, ruta):
    hz = 60
    cuadros, vuelta = ejecuta(numero)
    todo, fundido = motor_musica.desarrolla(cuadros, vuelta, hz)
    motor_musica.a_mp3(motor_musica.sintetiza(todo, hz), ruta, fundido, hz)
    print("%-22s %d cuadros (%.1f s), vuelve al %s" % (os.path.basename(ruta), len(cuadros),
                                                      len(cuadros) / hz, vuelta))


def registros_por_cuadro(numero, maximo):
    """Los 16 registros del PSG tras cada cuadro del motor ejecutado."""
    z = motor_musica.arranca(cfg(numero), rom(), numero)
    regs = [0] * 16
    regs[7] = 0xB8
    out = []
    for _ in range(maximo):
        for r, v in motor_musica.cuadro(z):
            if r < 16:
                regs[r] = v
        out.append(tuple(regs))
    return out


def cotejo():
    """La musica de la presentacion (la 4) del motor ejecutado contra el PSG que grabo openMSX en work/juego.bin
    (Casio PV-16, la RAM 0xF000-0xFFFF): desde el cuadro en que el juego pide el sonido (0xFA9B = 1), cuadro a
    cuadro, el tono (registros 0 y 1) y el volumen (8) del canal A y, con CHORD, los de B (2, 3, 9) y C (4, 5, 10),
    mientras suena (0xFA78)."""
    import vdp
    ruta = os.path.join(RAIZ, "work", "juego.bin")
    cs = []
    for k, c in enumerate(vdp.cuadros(ruta, 0x1000)):
        cs.append((c["ram"][0xA9B], c["ram"][0xA78], c["psg"]))
        if k > 3000:
            break
    k0 = next(k for k in range(len(cs)) if cs[k][0] == 1)
    emu = registros_por_cuadro(4, 3000)
    malos, mirados = [], 0
    for j in range(k0 + 1, len(cs)):
        if cs[j][1] != 1:
            break
        p, r = cs[j][2], emu[j - k0 - 1]
        mirados += 1
        if any(p[i] != r[i] for i in (0, 1, 8, 2, 3, 9, 4, 5, 10)):
            malos.append(j - k0)
    return [("musica_titulo.mp3", "juego", k0, mirados, malos)]


def main(argv):
    if argv and argv[0] == "cotejo":
        for fichero, grab, k0, mirados, malos in cotejo():
            print("%-22s %s, pedida en el cuadro %d: %d cuadros mirados, %d distintos %s"
                  % (fichero, grab, k0, mirados, len(malos), malos[:8]))
        return 0
    if argv and argv[0] == "todas":
        os.makedirs(argv[1], exist_ok=True)
        for numero, _, fichero, _ in MUSICAS:
            mp3(numero, os.path.join(argv[1], fichero))
        return 0
    if argv and argv[0] == "mp3":
        mp3(int(argv[1]), argv[2])
        return 0
    if argv and argv[0] == "registros":
        cuadros, vuelta = ejecuta(int(argv[1]), int(argv[2]) if len(argv) > 2 else None)
        for i, escr in enumerate(cuadros):
            print("%5d %s" % (i, " ".join("%X=%02X" % rv for rv in escr)))
        print("cuadros: %d, vuelve al %s" % (len(cuadros), vuelta))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

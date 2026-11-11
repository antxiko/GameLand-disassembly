"""Lo que se afirma de la ROM, comprobado contra sus bytes.

Corre con la ROM delante y sin ella: cuando no esta, la imagen se rehace desde
las filas defb/defw del listado, que si viaja con el repositorio. Sin la ROM
solo se comprueba lo que cae en datos.
"""

import os
import re
import subprocess
import sys
import unittest

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(RAIZ, "tools"))

ROM = os.path.join(RAIZ, "gameland.rom")
ASM = os.path.join(RAIZ, "src", "gameland.asm")
NOTAS = os.path.join(RAIZ, "src", "gameland.notes")
ORG = 0x4000
TAM = 32768

FILA = re.compile(r"^\s+def(b|w)\s+([0-9a-fA-F,h ]+)\s*;\s*([0-9a-f]{4})")


def imagen_desde_el_listado():
    img = bytearray(TAM)
    with open(ASM, encoding="utf-8") as f:
        for ln in f:
            m = FILA.match(ln)
            if not m:
                continue
            ancho, cuerpo, dirr = m.group(1), m.group(2), int(m.group(3), 16)
            p = dirr - ORG
            for tok in cuerpo.split(","):
                tok = tok.strip().rstrip("h")
                if not tok:
                    continue
                v = int(tok, 16)
                if ancho == "b":
                    img[p] = v
                    p += 1
                else:
                    img[p] = v & 0xFF
                    img[p + 1] = v >> 8
                    p += 2
    return bytes(img)


_ROM = None


def lee():
    global _ROM
    if _ROM is None:
        if os.path.exists(ROM):
            with open(ROM, "rb") as f:
                _ROM = f.read()
        else:
            _ROM = imagen_desde_el_listado()
    return _ROM


def b(a):
    return lee()[a - ORG]


def w(a):
    rom = lee()
    return rom[a - ORG] | (rom[a - ORG + 1] << 8)


def instruccion(dirr):
    """La instruccion del listado en esa direccion (sin el comentario)."""
    with open(ASM, encoding="utf-8") as f:
        for ln in f:
            m = re.match(r"^\t(\S.*?)\s*;([0-9a-f]{4})", ln)
            if m and int(m.group(2), 16) == dirr:
                return re.sub(r"\s+", " ", m.group(1)).strip()


def ascii(a, n):
    return lee()[a - ORG:a - ORG + n].decode("ascii")


def registro(base, n):
    """El registro n (desde 1) de una tabla de registros con su longitud delante."""
    a = base
    for _ in range(n - 1):
        a += 1 + b(a)
    return a + 1, b(a)


class Cabecera(unittest.TestCase):
    def test_ab_init_y_px(self):
        self.assertEqual(lee()[:2], b"AB")
        self.assertEqual(w(0x4002), 0x402F)
        self.assertEqual(ascii(0x4010, 2), "PX")

    def test_son_32_kb(self):
        self.assertEqual(len(lee()), TAM)

    def test_nueve_saltos_para_las_cintas(self):
        self.assertTrue(all(b(0x4012 + 3 * k) == 0xC3 for k in range(9)))

    def test_init_busca_ab_init_y_px(self):
        self.assertEqual(instruccion(0x404C), "ld hl,init")


class LaInterrupcion(unittest.TestCase):
    def test_h_timi_salta_a_la_interrupcion(self):
        self.assertEqual([instruccion(a) for a in (0x40B7, 0x40B9, 0x40BC, 0x40BF)],
                         ["ld a,0c3h", "ld hl,0422eh", "ld (0fd9fh),a", "ld (0fda0h),hl"])


class LosMenus(unittest.TestCase):
    def test_el_menu_principal_tiene_cinco_opciones(self):
        a, n = registro(0xB304, 1)
        self.assertEqual(n, 10)
        self.assertEqual([w(a + 2 * k) for k in range(5)], [0x70EC, 0x7045, 0x70CC, 0x7061, 0x70CC])

    def test_el_menu_de_arreglar(self):
        a, n = registro(0xB304, 0x0C)
        self.assertEqual([w(a + 2 * k) for k in range(5)], [0x4C6A, 0x7908, 0x983C, 0x71D1, 0x7031])

    def test_los_textos_de_las_herramientas(self):
        t = lee()[0x5131 - ORG:0x5170 - ORG].split(b"\0")
        self.assertEqual([x.decode().strip() for x in t[:7]],
                         ["LINE", "BOX", "BOXFILL", "CIRCLE", "PAINT", "H-LINE", "V-LINE"])

    def test_las_herramientas_y_sus_rutinas(self):
        self.assertEqual([w(0x5813 + 2 * k) for k in range(7)],
                         [0xA959, 0xA96C, 0xA98C, 0xAFC8, 0xAB2A, 0xA959, 0xA959])

    def test_la_presentacion(self):
        t = lee()[0x97DE - ORG:0x9807 - ORG].split(b"\0")
        self.assertEqual([x.decode() for x in t[:3]], ["PUSH  SPACE  KEY", "COPYRIGHT 1984", "BY CASIO"])


class LaPartida(unittest.TestCase):
    def test_los_rotulos(self):
        t = lee()[0x8A6A - ORG:0x8A8F - ORG].replace(b"\r", b"").split(b"\0")
        self.assertEqual([x.decode() for x in t[:3]], ["GAME START", "GAME OVER", "HIT SPACE KEY"])

    def test_el_marcador(self):
        t = lee()[0x4B2E - ORG:0x4B4C - ORG].split(b"\0")
        self.assertEqual([x.decode() for x in t[:5]], ["HISCORE", "SCORE", "STAGE", "LEFT", "TIME"])

    def test_las_rutinas_de_las_fichas(self):
        self.assertEqual([w(0xB142 + 2 * k) for k in range(1, 10)],
                         [0x83FF, 0x7A32, 0x8BBF, 0x8CDB, 0x8E49, 0x8469, 0x84CB, 0x812C, 0x8BFB])

    def test_los_movimientos(self):
        m = [w(0xB1A4 + 2 * k) for k in range(32)]
        self.assertEqual(m[5], 0x9258)       # el recorrido
        self.assertEqual(m[12], 0x93E3)      # se acerca al protagonista
        self.assertEqual(m[13], 0x93F0)      # se aleja
        self.assertEqual(m[31], 0x9247)      # quieto (la primera palabra de 0xB1E2)

    def test_casillas_de_puntos_del_laberinto(self):
        self.assertEqual([instruccion(a) for a in (0x4217, 0x421B)], ["sub 071h", "sub 003h"])

    def test_cinco_cifras_de_puntos(self):
        self.assertEqual(w(0xB13C), 10000)
        self.assertEqual(instruccion(0x8C5D), "ld bc,02710h")


class LaCinta(unittest.TestCase):
    def test_cabeceras_h_y_d(self):
        self.assertEqual(instruccion(0x6C35), "ld a,048h")
        self.assertEqual(instruccion(0x6C03), "ld a,044h")

    def test_textos_found_y_skip(self):
        self.assertEqual(lee()[0x6EBD - ORG:0x6ECA - ORG], b"FOUND \0SKIP \0")

    def test_cinco_bloques(self):
        self.assertEqual([instruccion(a) for a in (0x6D63, 0x6D66)], ["ld de,00800h", "ld bc,03380h"])


class ElSonido(unittest.TestCase):
    def test_cuatro_musicas_de_muestra(self):
        ps = [w(0xA325 + 2 * k) for k in range(4)]
        self.assertEqual(ps, [0xA32D, 0xA351, 0xA375, 0xA399])
        for p in ps:
            self.assertEqual(b(p + 0x23), 0)    # 32 notas y el 0 del final

    def test_la_presentacion_usa_la_cuarta(self):
        self.assertEqual(instruccion(0x96B5), "ld hl,0a399h")

    def test_diez_tempos(self):
        self.assertEqual(list(lee()[0xA314 - ORG:0xA31F - ORG]),
                         [0x11, 0x10, 0x29, 0x21, 0x19, 0x13, 0x0D, 0x09, 0x05, 0x03, 0x01])


class ElListado(unittest.TestCase):
    def test_densidad_y_flojas(self):
        salida = subprocess.run(
            [sys.executable, os.path.join(RAIZ, "tools", "densidad.py"), ASM],
            capture_output=True, text=True, check=True).stdout
        m = re.search(r"(\d+) instrucciones, (\d+) comentarios", salida)
        self.assertGreaterEqual(int(m.group(2)) * 100, 40 * int(m.group(1)))
        self.assertIn("---- 0 rutinas por debajo del 10 %", salida)

    def test_ningun_call_sin_nombre(self):
        salida = subprocess.run(
            [sys.executable, os.path.join(RAIZ, "tools", "sin_bautizar.py"), ASM],
            capture_output=True, text=True, check=True).stdout
        self.assertTrue(salida.startswith("0 rutinas sin bautizar"), salida[:200])

    def test_cada_comentario_en_su_instruccion(self):
        salida = subprocess.run(
            [sys.executable, os.path.join(RAIZ, "tools", "valida_c.py"), ASM, NOTAS],
            capture_output=True, text=True, check=True).stdout
        self.assertIn("0 fuera de sitio, 0 repetidos", salida)


if __name__ == "__main__":
    unittest.main()

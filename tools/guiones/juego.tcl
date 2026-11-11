# juego.tcl: la presentacion, el menu (hacer un juego: de combate, con un fondo) y un fondo dibujado con las
# herramientas: el cielo con PAINT, el suelo con BOXFILL, el sol con CIRCLE y PAINT, una casa (BOXFILL, el tejado con
# LINE y PAINT, puerta y ventanas) y un arbol; despues (F5 al menu 0x0C) dos personajes con las muestras de la ROM:
# HERO (clase protagonista, 16x16, la muestra 1, el que corre) y KANI (otro, la muestra 7, el cangrejo).
# Teclas y menus sacados del listado: tabla del teclado 0x4474, listas de teclas por modo 0x52B9, 0x7964.
set ::acc {
 {e 480} {t 8 0x01} {e 100}
 {t 8 0x40} {t 7 0x80} {e 60} {t 7 0x80} {e 60} {t 7 0x80} {e 60} {t 7 0x80} {e 60} {t 7 0x80} {e 120}
 {t 5 0x40} {t 0 0x40} {ir 80 60} {t 8 0x01} {e 90}
 {t 3 0x04} {t 0 0x10} {ir 0 136} {t 8 0x01} {ir 175 191} {t 8 0x01} {e 60}
 {t 3 0x08} {t 0 0x20} {ir 136 32} {t 8 0x01} {ir 152 32} {t 8 0x01} {e 40} {t 0 0x40} {ir 136 32} {t 8 0x01} {e 60}
 {t 5 0x01} {t 0 0x10} {ir 40 104} {t 8 0x01} {ir 88 135} {t 8 0x01} {e 40}
 {t 3 0x02} {t 0 0x04} {ir 32 104} {t 8 0x01} {ir 64 80} {t 8 0x01} {ir 96 104} {t 8 0x01} {ir 32 104} {t 8 0x01}
 {t 0 0x40} {ir 64 96} {t 8 0x01} {e 60}
 {t 4 0x40} {t 0 0x10} {ir 58 116} {t 8 0x01} {ir 70 135} {t 8 0x01} {e 30}
 {t 4 0x01} {t 0 0x10} {ir 44 110} {t 8 0x01} {ir 52 118} {t 8 0x01} {e 20}
 {t 0 0x10} {ir 76 110} {t 8 0x01} {ir 84 118} {t 8 0x01} {e 30}
 {t 4 0x80} {t 0 0x20} {ir 130 104} {t 8 0x01} {ir 144 104} {t 8 0x01} {e 30} {t 0 0x40} {ir 130 104} {t 8 0x01} {e 40}
 {t 3 0x10} {t 0 0x10} {ir 128 118} {t 8 0x01} {ir 132 135} {t 8 0x01} {e 60}
 {e 120}
 {t 7 0x80} {e 120}
 {t 7 0x02} {e 90} {t 8 0x40} {t 7 0x80} {e 90} {t 7 0x80} {e 90} {t 7 0x80} {e 60}
 {escribe HERO} {t 7 0x80} {e 60} {t 7 0x80} {e 60} {t 7 0x80} {e 90} {t 8 0x40} {t 7 0x80} {e 120}
 {t 8 0x80} {e 30} {t 8 0x01} {e 90} {t 7 0x80} {e 90} {t 7 0x02} {e 90}
 {t 7 0x80} {e 90} {t 8 0x40} {t 7 0x80} {e 60}
 {escribe KANI} {t 7 0x80} {e 60} {t 7 0x80} {e 60} {t 7 0x80} {e 90} {t 8 0x40} {t 7 0x80} {e 120}
 {t 8 0x40} {e 20} {t 8 0x80} {e 20} {t 8 0x80} {e 30} {t 8 0x01} {e 90} {t 7 0x80} {e 90} {t 7 0x02} {e 150} {fin}
}
source tools/guiones/acciones.tcl

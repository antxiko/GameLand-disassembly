# Secretos y fallos

Lo que se ha buscado en el c&oacute;digo y lo que se ha encontrado. Un fallo solo entra aqu&iacute; si est&aacute;
comprobado: ejecutando la propia rutina del programa (`tools/bios.py`) o contra las grabaciones de openMSX.

## Secretos

Contados en [Curiosidades](CURIOSIDADES.html):

- **HOME en el men&uacute; principal** busca un segundo cartucho con la marca "CP" y lo llama (`cartucho_cp`, 0x4587).
  Qu&eacute; cartucho es, no se sabe.
- **Una tableta** en el puerto 2: el editor de dibujo la lee (GTPAD) y toma GRAPH como su bot&oacute;n.
- **Nueve saltos fijos** en 0x4012 para los programas de cinta de Game Land Special.

Fuera de eso, el teclado se lee entero, fila a fila, por los puertos del PPI (0x4340), junto con las tres palancas y
seis botones; STOP solo cuenta si se lee sola cuatro veces seguidas (`stop_mira`, 0x42E4). Jugando, la palanca es la
**primera** que se mueve de los cursores, el mando 1 y el mando 2 (0x4269): aqu&iacute; no se mezclan.

## Fallo: los puntos de los juegos vuelven a cero

En los juegos hechos con Game Land, los puntos son una cifra alta (0xF9F7, de 0 a 9) y un n&uacute;mero de 0 a 9.999
(0xF9F5); en pantalla, las cinco cifras y un 0 fijo detr&aacute;s. `puntos_suma` (0x8C58) sube la cifra alta en
decimal y se queda solo con la de abajo (`and 0Fh`, 0x8C6D): pasados los 999.990 en pantalla, los puntos vuelven a
empezar. Ejecutando aqu&iacute; la suma del programa:

| puntos (en pantalla) | + | despu&eacute;s (en pantalla) |
|---|---|---|
| 123.450 | 1.000 | 124.450 |
| 99.900 | 100 | 100.000 |
| 999.900 | 100 | **0** |
| 990.000 | 25.000 | **15.000** |

El r&eacute;cord (0xF9F2) no se toca al dar la vuelta: se queda con lo que ten&iacute;a.

## Comprobado y correcto

- **Las vidas de m&aacute;s**: cada tantos puntos como diga el juego (0xF41B). Ejecutando la suma con una vida cada
  10.000 en pantalla, llevando 9.000 y sumando 25.000, da **tres** vidas y guarda los 4.000 que sobran: no se pierde
  ninguna aunque la suma sea grande.
- **La comparaci&oacute;n del teclado** mira 15 bytes y solo hay 11 filas: los otros cuatro son las tres palancas y
  los botones (0xFE30-0xFE33), que van detr&aacute;s a prop&oacute;sito (`teclado_lee`, 0x4312).

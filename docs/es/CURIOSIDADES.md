# Curiosidades

## Un segundo cartucho

Con HOME (el c&oacute;digo 5) en el men&uacute; principal, Game Land busca **otro cartucho** en los slots: uno con
"AB" en 0x4000 o 0x8000, la marca "CP" y 0xED00 detr&aacute;s, y una direcci&oacute;n que llama en su slot
(`cartucho_cp`, 0x4587). No se sabe qu&eacute; cartucho es; est&aacute; en las dudas.

## Programas de cinta que usan el cartucho

En 0x4012 hay nueve saltos seguidos (`api`): la pantalla gr&aacute;fica y la de texto, copiar una casilla, la
interrupci&oacute;n, los ganchos, STOP, limpiar la pantalla y escribir una letra. Est&aacute;n en un sitio fijo para
que los usen programas que se cargan de cinta (los de **Game Land Special**), y por eso INIT, para encontrarse,
busca en cada slot no solo "AB" sino tambi&eacute;n su direcci&oacute;n de INIT (0x402F) y la marca "PX" de 0x4010.

## Una tableta

El editor de dibujo lee una **tableta** en el puerto 2 (GTPAD 4, 5 y 6) y toma GRAPH como su bot&oacute;n
(`tableta_lee`, 0x5827): si se toca, la cruz va a ese punto y, con el bot&oacute;n, pinta.

## C&oacute;digo que escribe c&oacute;digo

Para poner o quitar un punto en el dibujo de un personaje, el programa escribe en la RAM (0xFAC2) una rutina de dos
bytes, "or c" y "ret" o "and c" y "ret", y la llama (`punto_pon`, 0x65F7). PAINT hace lo mismo para mirar un bit:
escribe "bit n,a" y "ret" en 0xFE93 con el n&uacute;mero del bit que toca (`bit_mira_arma`, 0xACCD).

## El azar sale de la propia ROM

Los n&uacute;meros al azar de la partida son un byte de la ROM, recorrida de 0x8100 a 0x81FA, m&aacute;s el registro
R dividido por dos (`azar`, 0x95C1).

## Instrucciones escondidas en otras

Muchas rutinas tienen varias entradas metidas dentro de un "ld bc,..." o un "ld hl,...": el men&uacute; principal
(0x7031) es "ld a,1" seguido de dos "ld bc" que, entrando uno o dos bytes m&aacute;s adelante, son "ld a,5" y "ld
a,6" (los men&uacute;s del fondo). Igual se eligen las rutinas de las fichas (0x83B9: nueve entradas), los campos de
cada personaje (0x7A7E: once) o los dibujos de las casillas fijas (0x4F4A).

## El cohete de la presentaci&oacute;n

La nave que sube por la carretera es el sprite de 0xA581, que es la muestra n&uacute;mero 3, el cohete: el mismo dibujo
que se ofrece al hacer personajes.

## C&oacute;digo muerto

Doce trozos que nadie llama, salta ni lee: algunos con pinta de c&oacute;digo (0x4145, 0x5ED4, 0x7170, 0x7361) y
los dem&aacute;s, unos bytes sueltos entre rutinas. Est&aacute;n nombrados en el listado como `sin_uso_`.

## Cu&aacute;nta memoria hay

Al arrancar, el programa busca d&oacute;nde empieza la RAM escribiendo y leyendo de 0xE000 hacia abajo, de 2 KB en 2
KB (`programa`, 0x6FDA): todo lo que encuentra es sitio para el juego. Con 16 KB, como el PV-16, hay poco; con
m&aacute;s, se pueden hacer fondos m&aacute;s largos y m&aacute;s m&uacute;sicas.

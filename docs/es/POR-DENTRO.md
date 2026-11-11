# Por dentro

## Rehacer la ROM

`make verify` ensambla `src/gameland.asm` con pasmo y sale la ROM de 32 KB **byte a byte**. `make sanity` comprueba
lo que el reensamblado no cubre: que ning&uacute;n byte declarado como datos se lea como c&oacute;digo, que
ning&uacute;n punto de entrada caiga en datos y que los 32.768 bytes est&eacute;n explicados. `make test` pasa los
tests. La ROM no est&aacute; en el repositorio: hay que ponerla en la ra&iacute;z como `gameland.rom` (el volcado de
GoodMSX, `[!]`, sha1 `39ffaacd...`).

| | bytes |
|---|---|
| c&oacute;digo trazado | 26.084 |
| datos con nombre | 6.684 |
| sin explicar | 0 |

El listado tiene 6.365 comentarios en 13.827 instrucciones (46,0 %), 1904 rutinas y etiquetas, ninguna por debajo
del 10 % comentado, y ninguna rutina llamada sin nombre.

## El cartucho

32 KB en 0x4000-0xBFFF, con la cabecera en 0x4000 y "PX" en 0x4010. Casi todo es c&oacute;digo: el arranque, el
teclado y la interrupci&oacute;n (0x402F-0x4560), los cursores y los sprites, el editor de fondos (0x4C6A-0x5FFF), el
de personajes (0x6000-0x6BFF), la cinta (0x6C03-0x6ECA), el programa y los men&uacute;s (0x6FDA-0x8343), el motor de
la partida (0x8344-0x95DB), la presentaci&oacute;n, el editor de sonidos y el motor de sonido (0x95DC-0xA2CE) y la
biblioteca de dibujo (0xA959-0xB13B). Los datos: las notas y las m&uacute;sicas, las muestras y las letras
(0xA2CF-0xA958), las tablas de rutinas (0xB142) y los men&uacute;s y sus textos (0xB304-0xBFF0).

El trazado se hizo **leyendo las tablas**, sin jugar: las rutinas de las opciones de cada men&uacute; (0xB304), la
entrada de cada men&uacute; (0xB1E2), las de cada tecla (0xB48F, 0x4474, 0x52B9), las de las fichas (0xB142) y de los
movimientos (0xB1A4), las herramientas (0x5813) y la cinta (0x6DCB).

## La BIOS que usa

RDSLT, CALSLT y la tabla de slots para encontrarse y llamar al otro cartucho; WRTVDP, SETRD, SETWRT, FILVRM, LDIRVM,
LDIRMV, RDVRM y WRTVRM; SNSMAT, GTTRIG y GTPAD (la tableta); TAPOON, TAPOUT, TAPOOF, TAPION, TAPIN y TAPIOF para la
cinta; WRTPSG para el sonido; DCOMPR. El teclado lo lee por los puertos (0xAA, 0xA9) y lo convierte con sus propias
tablas. Las letras son las de la BIOS: por eso los kana.

## El juego que se hace

Todo lo que se hace vive en la RAM, entre el principio que se encontr&oacute; al arrancar y 0xFFFF:

| | |
|---|---|
| 0xF417-0xF422 | la clase, el fondo, las vidas, los puntos por vida, las m&uacute;sicas del principio y del final, cu&aacute;ntas fases, personajes y sonidos |
| 0xF423 | los sonidos: registros de 13 bytes (n&uacute;mero, nombre, puntero a sus notas) |
| 0xF512 + n x 21 | los personajes: clase, forma, nombre y los ocho dibujos (0xF527 el protagonista) |
| 0xF7C7 | 17 punteros: las ocho fases y los l&iacute;mites de la memoria |
| 0xF7ED / 0xF7EF | el principio del mapa del fondo / el de las notas |
| 0xFBFE | qu&eacute; dibujo de qu&eacute; personaje ocupa cada sprite |
| VRAM 0x800-0x3B7F | los dibujos y colores del fondo y de los sprites |

Cada **fase** es una cabecera de 0x3A bytes (el fondo, el tiempo, los sonidos, la zona) y una **ficha** de 0x2F bytes
por personaje (`ficha_busca`, 0x8556): qui&eacute;n es, su papel, su movimiento, su velocidad y su paso, su zona, sus
puntos, sus sonidos, sus vidas y su recorrido. Al meter o quitar algo, todo lo que va detr&aacute;s se mueve y los 17
punteros se corrigen (`ram_pide`, 0x805F; `punteros_suma`, 0x8182).

## El motor que lo juega

`partida` (0x880C) busca la primera fase con datos, ense&ntilde;a STAGE y GAME START y entra en el bucle: cada dos
cuadros recorre las fichas y cada una hace lo suyo (`ficha_mueve`, 0x8E49): el protagonista con la palanca y su arma
con su bot&oacute;n, los enemigos salen cuando les toca (con su reloj) y tantas veces como se dijo, y cada uno se
mueve con su rutina de la tabla de 0xB1A4. Los choques se miran por rect&aacute;ngulos (`rectangulos_tocan`,
0x8DF8) cuando el VDP avisa de que dos sprites se tocan. Cuando no quedan enemigos (o casillas de puntos, en el
laberinto) la fase acaba; cuando se acaba el tiempo o cae el protagonista, una vida menos; sin vidas, GAME OVER.

## La biblioteca de dibujo

Siete herramientas que pintan en la VRAM de SCREEN 2 sin la BIOS: el punto (`punto`, 0xAB04) calcula su byte y su bit
y respeta los dos colores de cada fila de 8 puntos; LINE es Bresenham con la pendiente en 16 bits; BOX son cuatro
l&iacute;neas y BOXFILL l&iacute;neas horizontales; CIRCLE calcula el radio con una ra&iacute;z cuadrada y pinta los
ocho octantes a la vez; PAINT rellena por tramos horizontales con una pila en la memoria libre.

## La cinta

Un juego se graba con una cabecera "H" de 0x38 bytes (el nombre, los punteros, los tama&ntilde;os) y cinco bloques
"D", cada uno con su suma: la VRAM (0x800-0x3B7F), los datos (0xF417, 0x3B0 bytes), la tabla de sprites, lo de la
memoria baja y el mapa (`juego_bloques`, 0x6D62). Al cargar, si la memoria empieza en otro sitio, los punteros se
mueven. Con ",F" al final del nombre, la cabecera de la cinta es la corta. Despu&eacute;s de grabar se puede comprobar
leyendo y comparando.

## C&oacute;mo se ha hecho

Los comentarios se escribieron leyendo el listado por tramos; los que dicen el nombre de una variable de la RAM, una
llamada a la BIOS o un campo de una ficha se pusieron por regla (`work/reglas.py`), solo donde el significado
estaba ya le&iacute;do. Las grabaciones (`tools/guiones/juego.tcl` con `tools/guiones/acciones.tcl`, grabadas con
`tools/lanza_graba.ps1` en el Casio PV-16) siguen un guion sacado de las tablas del listado -qu&eacute; tecla da
qu&eacute; c&oacute;digo, qu&eacute; men&uacute; sigue a cada opci&oacute;n- y apuntan, en cada cuadro, los registros
del VDP, la RAM desde 0xF000, el PSG y la VRAM que cambi&oacute;. `tools/gifs.py` hace los GIF,
`tools/pantallas.py` pinta las muestras desde la ROM y `tools/musica.py` ejecuta el motor de sonido.

## La RAM del programa

| | |
|---|---|
| 0xF8A8 | la pila de men&uacute;s |
| 0xF9F2 / 0xF9F5 | el r&eacute;cord / los puntos |
| 0xF9FB / 0xF9FC / 0xF9FD | la palanca / el bot&oacute;n 1 / el 2 |
| 0xFA04 | jugando |
| 0xFA08 / 0xFA12 | la fase / el personaje |
| 0xFA1A | el men&uacute; |
| 0xFA31 | el reloj de la partida |
| 0xFA38 | el color del borde, que es el de dibujar |
| 0xFA39 | d&oacute;nde empieza la RAM |
| 0xFA71-0xFAC0 | el sonido |
| 0xFBC3 / 0xFBC5 | el cursor de puntos / el de casillas |
| 0xFBD2 | la herramienta |
| 0xFBE8 / 0xFBEF | el mapa que se ve / la casilla elegida |
| 0xFC40 / 0xFC43 | los sprites libres / la forma del personaje |
| 0xFE37-0xFE5A | el buffer del teclado |
| 0xFE6C / 0xFE6D | la clase de editor / el modo |
| 0xFE74-0xFEA3 | el dibujo (LINE, CIRCLE y PAINT) |

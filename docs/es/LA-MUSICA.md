# La m&uacute;sica

Las cuatro m&uacute;sicas de muestra que trae el cartucho (los punteros de 0xA325). No son grabaciones hechas a mano:
`tools/musica.py` **ejecuta el motor de sonido de la propia ROM** con `tools/z80run.py` -la rutina de cada cuadro,
`sonido_interrupcion` (0xA20C)- con el sonido puesto en la lista como lo pone la presentaci&oacute;n, y apunta lo que
escribe en el PSG por la BIOS (WRTPSG).

**Cotejada con openMSX la del t&iacute;tulo**, que suena en la presentaci&oacute;n de la grabaci&oacute;n
(`work/juego.bin`, en un Casio PV-16): **471 cuadros mirados, 0 distintos** en el tono y el volumen de los tres
canales. Las otras tres no suenan en la grabaci&oacute;n: salen del mismo motor, sin cotejar.

## El motor

Cada nota dura el **tempo** + 1 cuadros (el byte 0 de la m&uacute;sica; el pentagrama ofrece diez); el byte 1 son las
marcas: el bit 6 **REPEAT** (al acabar, desde el principio) y el bit 4 **CHORD** (cada nota lleva otras dos por debajo
en los canales B y C, las de tres y dos puestos antes en la tabla de notas de 0xA2D3). Despu&eacute;s, 32 notas: 0
acaba, 1 es un silencio y las dem&aacute;s son el periodo del PSG con los dos bits de abajo como la parte alta
(`nota_psg`, 0xA187). Volumen fijo, 15.

Si suena un sonido y se pide otro, el que sonaba se guarda en una pila (0xFAA8, hasta ocho) y sigue cuando acaba el
nuevo.

| | en el men&uacute; | tempo | marcas | dura |
|---|---|---:|---|---:|
| la boda | けっこん | 13 | - | 7,5 s |
| canc&aacute;n | カンカン | 9 | REPEAT, CHORD | 5,3 s y vuelve a empezar |
| a la carga | とつげき | 5 | - | 3,2 s |
| el t&iacute;tulo | タイトル | 9 | REPEAT, CHORD | 5,3 s y vuelve a empezar |

## La boda

<audio controls src="../audio/musica_boda.mp3"></audio>

## Canc&aacute;n

<audio controls src="../audio/musica_kankan.mp3"></audio>

## A la carga

<audio controls src="../audio/musica_carga.mp3"></audio>

## El t&iacute;tulo

La de la presentaci&oacute;n.

<audio controls src="../audio/musica_titulo.mp3"></audio>

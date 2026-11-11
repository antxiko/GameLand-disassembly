# Game Land - desensamblado comentado

*(Also [in English](README.md).)*

El desensamblado comentado de **Game Land** (ゲームランド; Casio, 1984) para MSX: un cartucho de 32 KB con la cabecera en 0x4000. No es un juego sino un cartucho para **hacer juegos** sin programar: fondos dibujados con LINE, BOX, CIRCLE y PAINT, personajes punto a punto o con 20 muestras, músicas en un pentagrama, una historia de hasta ocho fases, un motor que la juega y la grabación en cinta.

- **100 %** del binario explicado: 26.084 bytes de código y 6.684 de datos con nombre, ni un byte sin asignar.
- **46,0 %** del listado comentado, 1904 rutinas y etiquetas, ninguna por debajo del 10 % de comentarios.
- El listado vuelve a dar la ROM original **byte a byte**.
- La presentación, los menús, un fondo dibujado con sus herramientas y dos personajes con sus muestras, grabados en openMSX en un Casio PV-16 con un guion sacado del listado; los menús en japonés y traducidos; las cuatro músicas de muestra de su propio motor de sonido, la del título idéntica a openMSX cuadro a cuadro.

La web: <https://antxiko.github.io/GameLand-disassembly/es/>
(en inglés: <https://antxiko.github.io/GameLand-disassembly/>).

## Reproducirlo

La imagen de la ROM no se distribuye. Pon la tuya en la raíz como `gameland.rom` (el volcado `[!]` de GoodMSX, sha1 `39ffaacd...`) y ejecuta `make`. Los detalles, en [POR DENTRO](docs/es/POR-DENTRO.md).

## Legal

El programa es de Casio y de sus titulares. La licencia de `LICENSE` cubre solo las herramientas, los comentarios, el análisis y la documentación de aquí. Ver [AVISO-LEGAL.md](AVISO-LEGAL.md).

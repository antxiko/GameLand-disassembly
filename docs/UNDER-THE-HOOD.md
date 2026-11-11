# Under the hood

## Rebuilding the ROM

`make verify` assembles `src/gameland.asm` with pasmo and the 32 KB ROM comes out **byte for byte**. `make sanity`
checks what reassembly does not cover: that no byte declared as data is read as code, that no entry point falls in
data and that all 32,768 bytes are accounted for. `make test` runs the tests. The ROM is not in the repository: put it
in the root as `gameland.rom` (the GoodMSX `[!]` dump, sha1 `39ffaacd...`).

| | bytes |
|---|---|
| traced code | 26,084 |
| named data | 6,684 |
| unexplained | 0 |

The listing has 6,365 comments over 13,827 instructions (46.0%), 1904 routines and labels, none below 10% commented,
and no called routine without a name.

## The cartridge

32 KB at 0x4000-0xBFFF, with the header at 0x4000 and "PX" at 0x4010. Almost all of it is code: start-up, keyboard and
interrupt (0x402F-0x4560), cursors and sprites, the background editor (0x4C6A-0x5FFF), the character editor
(0x6000-0x6BFF), the tape (0x6C03-0x6ECA), the program and its menus (0x6FDA-0x8343), the game engine
(0x8344-0x95DB), the intro, the sound editor and the sound engine (0x95DC-0xA2CE) and the drawing library
(0xA959-0xB13B). The data: the notes and tunes, the samples and the letters (0xA2CF-0xA958), the routine tables
(0xB142) and the menus and their texts (0xB304-0xBFF0).

The trace was made **by reading the tables**, without playing: the routines of each menu's options (0xB304), each
menu's entry (0xB1E2), each key's (0xB48F, 0x4474, 0x52B9), the records' (0xB142) and the movements' (0xB1A4), the
tools (0x5813) and the tape (0x6DCB).

## The BIOS it uses

RDSLT, CALSLT and the slot table to find itself and call the other cartridge; WRTVDP, SETRD, SETWRT, FILVRM, LDIRVM,
LDIRMV, RDVRM and WRTVRM; SNSMAT, GTTRIG and GTPAD (the tablet); TAPOON, TAPOUT, TAPOOF, TAPION, TAPIN and TAPIOF for
the tape; WRTPSG for sound; DCOMPR. It reads the keyboard through the ports (0xAA, 0xA9) and converts it with its own
tables. The letters are the BIOS ones: hence the kana.

## The game being made

Everything that is made lives in RAM, between the start found at boot and 0xFFFF:

| | |
|---|---|
| 0xF417-0xF422 | the kind, the background, the lives, the points per life, the start and end tunes, how many stages, characters and sounds |
| 0xF423 | the sounds: records of 13 bytes (number, name, pointer to its notes) |
| 0xF512 + n x 21 | the characters: role, shape, name and the eight drawings (0xF527 the hero) |
| 0xF7C7 | 17 pointers: the eight stages and the memory limits |
| 0xF7ED / 0xF7EF | the start of the background map / of the notes |
| 0xFBFE | which drawing of which character takes each sprite |
| VRAM 0x800-0x3B7F | the drawings and colours of the background and of the sprites |

Each **stage** is a 0x3A byte header (the background, the timer, the sounds, the area) and a 0x2F byte **record** per
character (`ficha_busca`, 0x8556): who it is, its role, its movement, its speed and step, its area, its points, its
sounds, its lives and its route. When something is added or removed, everything after it is moved and the 17 pointers
are fixed (`ram_pide`, 0x805F; `punteros_suma`, 0x8182).

## The engine that plays it

`partida` (0x880C) looks for the first stage with data, shows STAGE and GAME START and enters the loop: every two frames
it walks the records and each does its part (`ficha_mueve`, 0x8E49): the hero with the joystick and his weapon with its
button, the enemies come out when their clock says so (and as many times as set), and each one moves with its routine
from the table at 0xB1A4. Collisions are checked with rectangles (`rectangulos_tocan`, 0x8DF8) when the VDP reports
two sprites touching. When no enemies are left (or no point tiles, in the maze) the stage ends; when time runs out or
the hero falls, one life less; with no lives, GAME OVER.

## The drawing library

Seven tools that paint in SCREEN 2 VRAM without the BIOS: the dot (`punto`, 0xAB04) works out its byte and its bit and
keeps the two colours of each 8-dot row; LINE is Bresenham with a 16-bit slope; BOX is four lines and BOXFILL
horizontal lines; CIRCLE works out the radius with a square root and paints the eight octants at once; PAINT fills by
horizontal spans with a stack in free memory.

## The tape

A game is saved with an "H" header of 0x38 bytes (the name, the pointers, the sizes) and five "D" blocks, each with its
checksum: the VRAM (0x800-0x3B7F), the data (0xF417, 0x3B0 bytes), the sprite table, the low memory and the map
(`juego_bloques`, 0x6D62). On loading, if memory starts somewhere else, the pointers are moved. With ",F" at the end of
the name, the tape header is the short one. After saving it can be verified by reading and comparing.

## How it was done

The comments were written by reading the listing in stretches; the ones that state the name of a RAM variable, a BIOS
call or a record field were added by rule (`work/reglas.py`), only where the meaning had already been read. The
recordings (`tools/guiones/juego.tcl` with `tools/guiones/acciones.tcl`, recorded with `tools/lanza_graba.ps1` on the
Casio PV-16) follow a script taken from the listing's tables -which key gives which code, which menu follows each
option- and log, on every frame, the VDP registers, the RAM from 0xF000, the PSG and the VRAM that changed.
`tools/gifs.py` makes the GIFs, `tools/pantallas.py` paints the samples from the ROM and `tools/musica.py` runs the
sound engine.

## The program's RAM

| | |
|---|---|
| 0xF8A8 | the menu stack |
| 0xF9F2 / 0xF9F5 | the high score / the points |
| 0xF9FB / 0xF9FC / 0xF9FD | the joystick / button 1 / button 2 |
| 0xFA04 | playing |
| 0xFA08 / 0xFA12 | the stage / the character |
| 0xFA1A | the menu |
| 0xFA31 | the game clock |
| 0xFA38 | the border colour, which is the drawing one |
| 0xFA39 | where RAM starts |
| 0xFA71-0xFAC0 | the sound |
| 0xFBC3 / 0xFBC5 | the dot cursor / the tile cursor |
| 0xFBD2 | the tool |
| 0xFBE8 / 0xFBEF | the map on screen / the chosen tile |
| 0xFC40 / 0xFC43 | free sprites / the character's shape |
| 0xFE37-0xFE5A | the keyboard buffer |
| 0xFE6C / 0xFE6D | the editor kind / the mode |
| 0xFE74-0xFEA3 | drawing (LINE, CIRCLE and PAINT) |

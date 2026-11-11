# The music

The four sample tunes on the cartridge (the pointers at 0xA325). They are not hand-made recordings:
`tools/musica.py` **runs the ROM's own sound engine** with `tools/z80run.py` -the per-frame routine,
`sonido_interrupcion` (0xA20C)- with the sound put on the list the way the intro does it, and logs what it writes to
the PSG through the BIOS (WRTPSG).

**The title tune is checked against openMSX**, as it plays in the intro of the recording (`work/juego.bin`, on a
Casio PV-16): **471 frames compared, 0 different** in the tone and volume of the three channels. The other three do
not play in the recording: they come from the same engine, unchecked.

## The engine

Each note lasts the **tempo** + 1 frames (byte 0 of the tune; the staff offers ten); byte 1 holds the flags: bit 6
**REPEAT** (from the start again when it ends) and bit 4 **CHORD** (each note gets two more below it on channels B and
C, the ones three and two places earlier in the note table at 0xA2D3). Then 32 notes: 0 ends, 1 is a rest and the
rest are the PSG period with the bottom two bits as the high part (`nota_psg`, 0xA187). Fixed volume, 15.

If a sound is playing and another one is asked for, the one playing is kept on a stack (0xFAA8, up to eight) and
carries on when the new one ends.

| | in the menu | tempo | flags | length |
|---|---|---:|---|---:|
| the wedding | けっこん | 13 | - | 7.5 s |
| cancan | カンカン | 9 | REPEAT, CHORD | 5.3 s and starts over |
| charge | とつげき | 5 | - | 3.2 s |
| the title | タイトル | 9 | REPEAT, CHORD | 5.3 s and starts over |

## The wedding

<audio controls src="audio/musica_boda.mp3"></audio>

## Cancan

<audio controls src="audio/musica_kankan.mp3"></audio>

## Charge

<audio controls src="audio/musica_carga.mp3"></audio>

## The title

The one in the intro.

<audio controls src="audio/musica_titulo.mp3"></audio>

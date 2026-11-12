# Secrets and bugs

What was searched for in the code and what was found. A bug only goes here if it has been checked: by running the
program's own routine (`tools/bios.py`) or against the openMSX recordings.

## Secrets

Told in [Curiosities](CURIOSITIES.html):

- **HOME on the main menu** looks for a second cartridge with the "CP" mark and calls it (`cartucho_cp`, 0x4587). Which
  cartridge that is, is not known.
- **A tablet** on port 2: the drawing editor reads it (GTPAD) and takes GRAPH as its button.
- **Nine fixed jumps** at 0x4012 for the Game Land Special tape programs.

Apart from that, the keyboard is read whole, row by row, through the PPI ports (0x4340), together with the three sticks
and six buttons; STOP only counts if it is read alone four times in a row (`stop_mira`, 0x42E4). While playing, the
stick is the **first** one that moves among the cursor keys, joystick 1 and joystick 2 (0x4269): here they are not
mixed.

## Bug: the score of the games goes back to zero

In the games made with Game Land, the score is a top digit (0xF9F7, 0 to 9) and a number from 0 to 9,999 (0xF9F5); on
screen, the five digits and a fixed 0 after them. `puntos_suma` (0x8C58) raises the top digit in decimal and keeps only
the lower one (`and 0Fh`, 0x8C6D): past 999,990 on screen, the score starts again. Running the program's addition here:

| score (on screen) | + | after (on screen) |
|---|---|---|
| 123,450 | 1,000 | 124,450 |
| 99,900 | 100 | 100,000 |
| 999,900 | 100 | **0** |
| 990,000 | 25,000 | **15,000** |

The high score (0xF9F2) is not touched when it wraps: it keeps what it had.

## Checked and correct

- **The extra lives**: every so many points as the game says (0xF41B). Running the addition with a life every 10,000
  on screen, holding 9,000 and adding 25,000, gives **three** lives and keeps the 4,000 left over: none is lost even
  when the addition is large.
- **The keyboard comparison** checks 15 bytes and there are only 11 rows: the other four are the three sticks and the
  buttons (0xFE30-0xFE33), which come after them on purpose (`teclado_lee`, 0x4312).

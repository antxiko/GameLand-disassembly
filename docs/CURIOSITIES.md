# Curiosities

## A second cartridge

With HOME (code 5) on the main menu, Game Land looks for **another cartridge** in the slots: one with "AB" at 0x4000
or 0x8000, the mark "CP" and 0xED00 after it, and an address that it calls in its slot (`cartucho_cp`, 0x4587). Which
cartridge that is, is not known; it is in the open questions.

## Tape programs that use the cartridge

At 0x4012 there are nine jumps in a row (`api`): the graphics screen and the text screen, copying a tile, the
interrupt, the hooks, STOP, clearing the screen and writing a letter. They sit at a fixed place so that programs loaded
from tape can use them (the **Game Land Special** ones), and that is why INIT, to find itself, looks in each slot not
only for "AB" but also for its INIT address (0x402F) and the "PX" mark at 0x4010.

## A tablet

The drawing editor reads a **tablet** on port 2 (GTPAD 4, 5 and 6) and takes GRAPH as its button (`tableta_lee`,
0x5827): when it is touched, the cross goes to that point and, with the button, it paints.

## Code that writes code

To set or clear a dot in a character's drawing, the program writes a two-byte routine into RAM (0xFAC2), "or c" and
"ret" or "and c" and "ret", and calls it (`punto_pon`, 0x65F7). PAINT does the same to test a bit: it writes "bit n,a"
and "ret" at 0xFE93 with the number of the bit it needs (`bit_mira_arma`, 0xACCD).

## Randomness comes from the ROM itself

The random numbers of the game are a byte of the ROM, walked from 0x8100 to 0x81FA, plus the R register divided by two
(`azar`, 0x95C1).

## Instructions hidden inside others

Many routines have several entries tucked inside an "ld bc,..." or "ld hl,...": the main menu (0x7031) is "ld a,1"
followed by two "ld bc" that, entered one or two bytes later, are "ld a,5" and "ld a,6" (the background menus). The
routines of the records (0x83B9: nine entries), the fields of each character (0x7A7E: eleven) and the drawings of the
fixed tiles (0x4F4A) are chosen the same way.

## The rocket in the intro

The ship going up the road is the sprite at 0xA581, which is sample number 3, the rocket: the same drawing offered
when making characters.

## Dead code

Twelve pieces that nobody calls, jumps to or reads: some look like code (0x4145, 0x5ED4, 0x7170, 0x7361) and the rest
are a few loose bytes between routines. They are named `sin_uso_` in the listing.

## How much memory there is

At start-up, the program finds where RAM begins by writing and reading from 0xE000 downwards, 2 KB at a time
(`programa`, 0x6FDA): everything it finds is room for the game. With 16 KB, like the PV-16, there is little; with
more, longer backgrounds and more tunes can be made.

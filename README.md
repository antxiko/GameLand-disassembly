# Game Land - commented disassembly

*(También [en castellano](README.es.md).)*

The commented disassembly of **Game Land** (ゲームランド; Casio, 1984) for the MSX: a 32 KB cartridge with its header at 0x4000. It is not a game but a kit for **making games** without programming: backgrounds drawn with LINE, BOX, CIRCLE and PAINT, characters dot by dot or from 20 samples, tunes on a staff, a story of up to eight stages, an engine that plays it and tape saving.

- **100%** of the binary explained: 26,084 bytes of code and 6,684 of named data, not one byte unassigned.
- **46.0%** of the listing commented, 1904 routines and labels, none below 10% of comments.
- The listing reassembles into the original ROM **byte for byte**.
- The intro, the menus, a background drawn with its tools and two characters from its samples, recorded in openMSX on a Casio PV-16 with a script taken from the listing; the menus in Japanese and translated; the four sample tunes from its own sound engine, the title one identical to openMSX frame by frame.

The site: <https://antxiko.github.io/GameLand-disassembly/>
(in Spanish: <https://antxiko.github.io/GameLand-disassembly/es/>).

## Reproducing it

The ROM image is not distributed. Put yours in the root as `gameland.rom` (the GoodMSX `[!]` dump, sha1 `39ffaacd...`) and run `make`. The details, in [UNDER THE HOOD](docs/UNDER-THE-HOOD.md).

## Legal

The program belongs to Casio and its rights holders. The licence in `LICENSE` covers only the tools, the comments, the analysis and the documentation here. See [LEGAL-NOTICE.md](LEGAL-NOTICE.md).

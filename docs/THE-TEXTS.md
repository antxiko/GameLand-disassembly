# The texts

Every text in the ROM, taken from it by `tools/textos.py`. The menus (0xB5D3) and the messages (0xB755) are lists of string numbers (0xB806), and the strings pull in repeated pieces (0xB4E0). The letters are the kana of the BIOS font; the arrows ↑ → ↓ ← are the cartridge's own drawings (codes 0x09-0x0C, which `dibujos_menu`, 0x50C5, copies from 0xA7C1).

## The menus

The menu title first, then its options.

| menu | in the ROM | translation |
|---|---|---|
| 0x01 | ゲームランドでなにをしますか / ゲームであそぶ / ゲームをつくる / ゲームをなおす / ゲームをよみこむ / ゲームをほぞんする | What shall we do in Game Land? / play a game / make a game / fix a game / load a game / save the game |
| 0x04 | ゲームのしゅるいはどれにしますか / せんとうしきゲーム / めいろしきゲーム | What kind of game? / combat type / maze type |
| 0x05 | はいけいはどれにしますか / 1しゅるい / 3しゅるい / スクロールする | Which background? / one kind / three kinds / scrolling |
| 0x06 | はいけいはどれにしますか / 3しゅるい / スクロールする | Which background? / three kinds / scrolling |
| 0x07 | スクロールはどれにしますか / じぶんのうごきでスクロールする↑↓ / じどうてきにスクロールする↓ / じどうてきにスクロールする↑ | How does it scroll? / with the player's moves, ↑↓ / automatically, ↓ / automatically, ↑ |
| 0x0A | かくにんしますか / はい / いいえ | Confirm? / yes / no |
| 0x0C | なにをしますか / はいけいをつくる / キャラクタをつくる / おとをつくる / ストーリーをきめる / おわり | What now? / make the background / make the characters / make the sounds / set the story / end |
| 0x15 | でてくるかいすうはふえますか / いいえ / ____0てんごと | Do they come out more often? / no / every ____0 points |
| 0x16 | ステージのストーリーをきめましょう / あたらしくつくる / なおす / けす / おわり | Let's set the stages' story / make a new one / fix / delete / end |
| 0x17 | どれにしますか / ステージ / ステージ / ステージ / ステージ / ステージ / ステージ / ステージ / ステージ | Which one? / stage / stage / stage / stage / stage / stage / stage / stage |
| 0x1A | はいけいはどれにしますか / だい1めん / だい2めん / だい3めん | Which background? / screen 1 / screen 2 / screen 3 |
| 0x1B | はいけいをつくる / ドットたんいでつくる / 8X8たんいでコピーする / はいけいをぬりつぶす | make the background / dot by dot / copy 8x8 at a time / fill the background |
| 0x1C | はいけいをつくる / タイルパターンをはいちする / タイルパターンをなおす / はいけいをぬりつぶす / スクロールするはんいをこていする | make the background / place tiles / fix the tiles / fill the background / fix the scrolling area |
| 0x1D | はいけいをつくる / はいけいをえらぶ / タイルパターンをはいちする / タイルパターンをなおす / はいけいをぬりつぶす | make the background / choose the background / place tiles / fix the tiles / fill the background |
| 0x1E | はいけいをつくる / かべをはいちする / つうろをはいちする / 10てんのタイルパターンをはいちする / 20てんのタイルパターンをはいちする / 30てんのタイルパターンをはいちする / タイルパターンをなおす / スクロールするはんいをこていする | make the background / place walls / place corridors / place 10-point tiles / place 20-point tiles / place 30-point tiles / fix the tiles / fix the scrolling area |
| 0x1F | はいけいをつくる / はいけいをえらぶ / かべをはいちする / つうろをはいちする / 10てんのタイルパターンをはいちする / 20てんのタイルパターンをはいちする / 30てんのタイルパターンをはいちする / タイルパターンをなおす | make the background / choose the background / place walls / place corridors / place 10-point tiles / place 20-point tiles / place 30-point tiles / fix the tiles |
| 0x22 | キャラクタをつくる / ドットたんいでつくる / サンプル / さゆうをはんてんする / じょうげをはんてんする / パターンをずらす / けす / コピーする | make the characters / dot by dot / samples / flip left-right / flip upside down / shift the drawing / delete / copy |
| 0x2B | なにをしますか / キャラクタのうごきかたをきめる / タイマーをきめる / ゲームちゅうのおとをきめる / おわり | What now? / set how the characters move / set the timer / set the in-game sounds / end |
| 0x30 | うごきはどうしますか / あたらしくつくる / ほかのキャラクタとおなじ | What about the movement? / make a new one / same as another character |
| 0x32 | どんなぶきですか / すべてのあいてをやっつける / じぶんよりよわいあいてをやっつける | What kind of weapon? / beats every enemy / beats enemies weaker than you |
| 0x33 | どんなあいてですか / じぶんよりつよい / じぶんよりよわい | What kind of enemy? / stronger than you / weaker than you |
| 0x36 | うごきかたはどれにしますか / ↑↓ / ←→ / ↑↓←→ / 8つのほうこう | How does it move? / ↑↓ / ←→ / ↑↓←→ / eight directions |
| 0x37 | がめんのはしではどうしますか / とまる / はんたいがわにでる | What does it do at the screen edge? / stops / comes out on the other side |
| 0x3F | うごくおとをだしますか / いいえ / はい | Sound when moving? / no / yes |
| 0x40 | やられたときのおとをだしますか / いいえ / はい | Sound when hit? / no / yes |
| 0x41 | やられたときのキャラクタをだしますか / いいえ / はい | Show a character when hit? / no / yes |
| 0x44 | うごきかたはどれにしますか / きどうのうえをうごく / 8ほうこうのいずれかへうごく / ふきそくにうごく / ↑ / ↓ / ← / → / じぶんにちかずく / じぶんからとおざかる | How does it move? / moves along a track / moves in one of eight directions / moves at random / ↑ / ↓ / ← / → / comes towards you / moves away from you |
| 0x45 | とおざかりかたはどれにしますか / すばやく / てきどに / ゆっくり | How does it move away? / fast / moderately / slowly |
| 0x46 | ちかずきかたはどれにしますか / すばやく / てきどに / ゆっくり | How does it come closer? / fast / moderately / slowly |
| 0x47 | どのキャラクタについてきめますか / じぶん / じぶんのぶき / あいて / あいてのぶき / おわり | Which character? / the player / the player's weapon / the enemy / the enemy's weapon / end |
| 0x49 | うごきかたはどれにしますか / ふきそくにうごく / じぶんにちかずく / じぶんからとおざかる / うごかない | How does it move? / moves at random / comes towards you / moves away from you / does not move |
| 0x4C | きえるまでのじかんをきめますか / いいえ / __びょう | Set the time until it disappears? / no / __ seconds |
| 0x4D | がめんのはしではどうしますか / とまる / はんたいがわにでる / きえる | What does it do at the screen edge? / stops / comes out on the other side / disappears |
| 0x52 | うごきかたはどれにしますか / (en blanco) / (en blanco) / ふきそくにうごく / じぶんにちかずく / じぶんからとおざかる / うごかない / もくてきちにむかってうごく | How does it move? /  /  / moves at random / comes towards you / moves away from you / does not move / heads for its destination |
| 0x55 | うごきかたはどれにしますか / もくてきちにむかってうごく / ↑ / ↓ / ← / → / じぶんのむいているほうこうにうごく / うごかない | How does it move? / heads for its destination / ↑ / ↓ / ← / → / moves the way the player faces / does not move |
| 0x5B | ぶきはどのキーででますか / TR1またはスペースキー / TR2またはリターンキー | Which key fires the weapon? / button 1 or the space bar / button 2 or RETURN |
| 0x5D | きえるまでのじかんをきめますか / いいえ / __びょう | Set the time until it disappears? / no / __ seconds |
| 0x62 | うごきかたはどれにしますか / ↑ / ↓ / ← / → / じぶんにむかってうつ / じぶんにちかずく / うごかない | How does it move? / ↑ / ↓ / ← / → / shoots at the player / comes towards you / does not move |
| 0x65 | きえるまでのじかんをきめますか / いいえ / __びょう | Set the time until it disappears? / no / __ seconds |
| 0x6D | (en blanco) / いいえ / (en blanco) |  / no /  |
| 0x7B | なにをしますか / あたらしくつくる / なおす / コピーする / けす / おわり | What now? / make a new one / fix / copy / delete / end |
| 0x82 | むきによってかたちをかえますか / いいえ / はい | Does its drawing change with direction? / no / yes |
| 0x83 | おおきさをきめてください{ヨコXタテ} / 16X16 / 32X16 / 16X32 / 32X32 | Set the size (width x height) / 16x16 / 32x16 / 16x32 / 32x32 |
| 0x85 | つぎのどれをつくりますか / じぶん / そのた | Which of these will you make? / the player / other |
| 0x87 | なにをしますか / あたらしくおとをつくる / おとをなおす / おとをけす / おわり | What now? / make a new sound / fix a sound / delete a sound / end |
| 0x8A | どんなおとをつくりますか / メロディ / こうかおん | What kind of sound? / a melody / a sound effect |
| 0x8B | どのようにつくりますか / サンプル / さっきょく | How will you make it? / samples / compose |
| 0x8C | なにをしますか / ふめん / おとをきく / テンポ / リピート / コード / おわり | What now? / the score / listen / tempo / repeat / chords / end |
| 0x8D | どれにしますか / けっこん / カンカン / とつげき / タイトル | Which one? / wedding / can-can / charge / title |
| 0x8E | どれにしますか / ばん / ばん / ばん / ばん / ばん | Which one? / "ban" (unclear) / "ban" (unclear) / "ban" (unclear) / "ban" (unclear) / "ban" (unclear) |
| 0x8F | どれにしますか / うごきのおと / メカニック / ばくはつ / SF / けいほう | Which one? / movement sound / mechanical / explosion / sci-fi / alarm |

## The messages

| message | in the ROM | translation |
|---|---|---|
| 0x01 | あたらしくつくる | make a new one |
| 0x02 | じぶんはなんかいでてきますか / __かい | How many lives does the player have? / __ times |
| 0x03 | タイマーはなんびょうにしますか / ___びょう | How many seconds on the timer? / ___ seconds |
| 0x04 | なまえをいれてください / ________ | Type the name / ________ |
| 0x05 | メモリーがたりません / スペースキーをおしてください | Not enough memory / Press the space bar |
| 0x06 | このステージはすでにあります / スペースキーをおしてください | That stage already exists / Press the space bar |
| 0x07 | このキャラクタはすでにつかわれています / スペースキーをおしてください | That character is already in use / Press the space bar |
| 0x08 | ゲームがあります / けさないならば おわりキーを / けしてもよければ / スペースキーをおしてください | There is a game already / if not deleting, the end key / if it may be deleted / Press the space bar |
| 0x09 | ゲームがありません / スペースキーをおしてください | There is no game / Press the space bar |
| 0x0A | スピードをきめてください / スペースキーでがめんがかわります | Set the speed / The space bar changes the screen |
| 0x0C | おとがありません / スペースキーをおしてください | There are no sounds / Press the space bar |
| 0x0D | キャラクタがありません / スペースキーをおしてください | There are no characters / Press the space bar |
| 0x0F | スタートのおとをしていしてください | Choose the start sound |
| 0x11 | なまえをしていしてください | Choose the name |
| 0x13 | キャラクタがでるばしょをきめてください / スペースキーでがめんがかわります | Set where the character appears / The space bar changes the screen |
| 0x14 | うまくよみこめません / スペースキーをおしてください | Could not load it / Press the space bar |
| 0x15 | ほぞんがうまくできていません / スペースキーをおしてください | It was not saved properly / Press the space bar |
| 0x17 | きどうをきめてください / スペースキーでがめんがかわります | Set the track / The space bar changes the screen |
| 0x18 | ばしょをきめてください / スペースキーでがめんがかわります | Set the place / The space bar changes the screen |
| 0x19 | なんかいでてきますか / __かい | How many times does it appear? / __ times |
| 0x1A | このキャラクタはなんてんですか / ___0てん | How many points is this character worth? / ___0 points |
| 0x1B | キャラクタがでるのはいつですか / __びょうごと | When does the character appear? / every __ seconds |
| 0x1D | おなじなまえがすでにあります / スペースキーをおしてください | That name already exists / Press the space bar |
| 0x1E | もうとうろくできません / スペースキーをおしてください | No more can be registered / Press the space bar |
| 0x21 | ゲームオーバーのときのおとをきめてください | Set the GAME OVER sound |
| 0x22 | どのキャラクタからでてきますか | Which character does it come from? |
| 0x23 | どのキャラクタからコピーしますか | Which character is it copied from? |
| 0x2B | キャラクタがでるばしょは「」のなかです / ↑↓←→キーで「と」をうごかします / スペースキーでそれぞれのばしょをきめます / リターンキーでメニューにもどります | The character appears inside 「」 / The arrow keys move 「 and 」 / The space bar sets each place / RETURN goes back to the menu |
| 0x2C | ↑↓キーでスピードがかわります / ←→キーできざみがかわります / リターンキーでメニューにもどります | ↑↓ change the speed / ←→ change the step / RETURN goes back to the menu |
| 0x2F | ↑↓←→キーで+がうごきます / スペースキーでつうかてんがきまります / とりけしキーで1つまえにもどります / リターンキーでメニューにもどります | The arrow keys move the + / The space bar sets the points it passes / The undo key goes back one step / RETURN goes back to the menu |
| 0x31 | ↑↓←→キーで+をうごかします / リターンキーでメニューにもどります | The arrow keys move the + / RETURN goes back to the menu |
| 0x32 | スペースキーでおとがきけます | The space bar plays the sound |
| 0x33 | ふめんは↑↓キーでおんていをきめます / スペースキーでおんがくきごうをえらびます / リターンキーでメニューにもどります | On the score, ↑↓ set the pitch / The space bar picks the musical sign / RETURN goes back to the menu |
| 0x34 | いろをしていします / スペースキーでじっこうします / リターンキーでメニューにもどります | Choose the colour / The space bar does it / RETURN goes back to the menu |
| 0x35 | コピーシフトキーと↑↓←→キーでタイルパターンをコピーします / リターンキーでメニューにもどります | Copy: SHIFT and the arrows copy tiles / RETURN goes back to the menu |
| 0x36 | スペースキーと↑↓←→キーでかきます / シフトキーと↑↓←→キーで+をはやくうごかします / リターンキーでメニューにもどります | Space and the arrows draw / SHIFT and the arrows move the + fast / RETURN goes back to the menu |
| 0x39 | ↑↓キーでぜんごのはいけいをひょうじします / リターンキーでメニューにもどります | ↑↓ show the previous and next background / RETURN goes back to the menu |
| 0x3A | スペースキーと↑↓←→キーでタイルパターンをはいちします / シフトキーと↑↓←→キーでタイルパターンをえらびます / スクロールINSキーで1ぎょうついかします / スクロールDELキーで1ぎょうとります / リターンキーでメニューにもどります | Space and the arrows place tiles / SHIFT and the arrows choose the tile / Scroll: INS adds a row / Scroll: DEL removes a row / RETURN goes back to the menu |
| 0x3B | スペースキーと↑↓←→キーでタイルパターンをはいちします / スクロールINSキーで1ぎょうついかします / スクロールDELキーで1ぎょうとります / リターンキーでメニューにもどります | Space and the arrows place tiles / Scroll: INS adds a row / Scroll: DEL removes a row / RETURN goes back to the menu |
| 0x3C | シフトキーと↑↓←→キーでなおすタイルパターンをえらびます / スペースキーと↑↓←→キーでなおします / リターンキーでメニューにもどります | SHIFT and the arrows choose the tile to fix / Space and the arrows fix it / RETURN goes back to the menu |
| 0x3D | スペースキーと↑↓←→キーでタイルパターンをはいちします / シフトキーと↑↓←→キーでタイルパターンをえらびます / リターンキーでメニューにもどります | Space and the arrows place tiles / SHIFT and the arrows choose the tile / RETURN goes back to the menu |
| 0x3E | スペースキーと↑↓←→キーでタイルパターンをはいちします / リターンキーでメニューにもどります | Space and the arrows place tiles / RETURN goes back to the menu |
| 0x3F | シフトキーと↑↓←→キーでほうこうをえらびます / スペースキーと↑↓←→キーでかきます / リターンキーでメニューにもどります | SHIFT and the arrows choose the direction / Space and the arrows draw / RETURN goes back to the menu |
| 0x40 | シフトキーと↑↓←→キーでほうこうをえらびます / スペースキーでじっこうします / リターンキーでメニューにもどります | SHIFT and the arrows choose the direction / The space bar does it / RETURN goes back to the menu |
| 0x41 | ↑↓←→キーでもとのほうこうをえらびます / スペースキーでじっこうします / リターンキーでメニューにもどります | The arrows choose the original direction / The space bar does it / RETURN goes back to the menu |
| 0x42 | ↑↓←→キーでパターンをえらびます / シフトキーと↑↓←→キーでほうこうをえらびます / スペースキーでじっこうします / リターンキーでメニューにもどります | The arrows choose the drawing / SHIFT and the arrows choose the direction / The space bar does it / RETURN goes back to the menu |
| 0x43 | シフトキーと↑↓←→キーでほうこうをえらびます / スペースキーと↑↓←→キーで1ドットパターンをずらします / リターンキーでメニューにもどります | SHIFT and the arrows choose the direction / Space and the arrows shift the drawing one dot / RETURN goes back to the menu |

## The labels

| address | text | where | translation |
|---|---|---|---|
| 0x4B2E | HISCORE / SCORE / STAGE / LEFT / TIME | the in-game scoreboard (`marcador_pinta`) | high score, score, stage, lives and time |
| 0x5131 | LINE / BOX / BOXFILL / CIRCLE / PAINT / H-LINE / V-LINE | the drawing editor's palette (`paleta_pinta`, 0x50F5) | the tools: line, box, filled box, circle, paint, horizontal and vertical line |
| 0x6EBD | FOUND / SKIP | loading from tape | found / skipped |
| 0x7589 | SPEED / STEP | the track speed | speed / step |
| 0x8A6A | GAME START / GAME OVER / HIT SPACE KEY | the game | start / game over / press space |

The underscored gaps (__, ___0, ________) are where a number or a name is typed. "ばん", one of the sound samples, could not be made out.

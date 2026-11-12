# Los textos

Todos los textos de la ROM, sacados de ella por `tools/textos.py`. Los menús (0xB5D3) y los avisos (0xB755) son listas de números de cadenas (0xB806), y las cadenas meten trozos que se repiten (0xB4E0). Las letras son los kana de la fuente de la BIOS; las flechas ↑ → ↓ ← son dibujos del propio cartucho (los códigos 0x09-0x0C, que `dibujos_menu`, 0x50C5, copia de 0xA7C1).

## Los menús

Primero el título del menú y después sus opciones.

| menú | en la ROM | traducción |
|---|---|---|
| 0x01 | ゲームランドでなにをしますか / ゲームであそぶ / ゲームをつくる / ゲームをなおす / ゲームをよみこむ / ゲームをほぞんする | ¿Qué hacemos en Game Land? / jugar / hacer un juego / arreglar un juego / cargar un juego / guardar el juego |
| 0x04 | ゲームのしゅるいはどれにしますか / せんとうしきゲーム / めいろしきゲーム | ¿Qué clase de juego? / de combate / de laberinto |
| 0x05 | はいけいはどれにしますか / 1しゅるい / 3しゅるい / スクロールする | ¿Qué fondo? / uno / tres / que se desplace |
| 0x06 | はいけいはどれにしますか / 3しゅるい / スクロールする | ¿Qué fondo? / tres / que se desplace |
| 0x07 | スクロールはどれにしますか / じぶんのうごきでスクロールする↑↓ / じどうてきにスクロールする↓ / じどうてきにスクロールする↑ | ¿Cómo se desplaza? / con el protagonista, ↑↓ / solo, ↓ / solo, ↑ |
| 0x0A | かくにんしますか / はい / いいえ | ¿Lo confirmas? / sí / no |
| 0x0C | なにをしますか / はいけいをつくる / キャラクタをつくる / おとをつくる / ストーリーをきめる / おわり | ¿Qué se hace? / hacer el fondo / hacer los personajes / hacer los sonidos / decidir la historia / acabar |
| 0x15 | でてくるかいすうはふえますか / いいえ / ____0てんごと | ¿Salen más veces? / no / cada ____0 puntos |
| 0x16 | ステージのストーリーをきめましょう / あたらしくつくる / なおす / けす / おわり | Decidamos la historia de las fases / hacer uno nuevo / arreglar / borrar / acabar |
| 0x17 | どれにしますか / ステージ / ステージ / ステージ / ステージ / ステージ / ステージ / ステージ / ステージ | ¿Cuál? / fase / fase / fase / fase / fase / fase / fase / fase |
| 0x1A | はいけいはどれにしますか / だい1めん / だい2めん / だい3めん | ¿Qué fondo? / pantalla 1 / pantalla 2 / pantalla 3 |
| 0x1B | はいけいをつくる / ドットたんいでつくる / 8X8たんいでコピーする / はいけいをぬりつぶす | hacer el fondo / punto a punto / copiar de 8x8 en 8x8 / rellenar el fondo |
| 0x1C | はいけいをつくる / タイルパターンをはいちする / タイルパターンをなおす / はいけいをぬりつぶす / スクロールするはんいをこていする | hacer el fondo / poner casillas / arreglar las casillas / rellenar el fondo / fijar lo que se desplaza |
| 0x1D | はいけいをつくる / はいけいをえらぶ / タイルパターンをはいちする / タイルパターンをなおす / はいけいをぬりつぶす | hacer el fondo / elegir el fondo / poner casillas / arreglar las casillas / rellenar el fondo |
| 0x1E | はいけいをつくる / かべをはいちする / つうろをはいちする / 10てんのタイルパターンをはいちする / 20てんのタイルパターンをはいちする / 30てんのタイルパターンをはいちする / タイルパターンをなおす / スクロールするはんいをこていする | hacer el fondo / poner paredes / poner pasillos / poner casillas de 10 puntos / poner casillas de 20 puntos / poner casillas de 30 puntos / arreglar las casillas / fijar lo que se desplaza |
| 0x1F | はいけいをつくる / はいけいをえらぶ / かべをはいちする / つうろをはいちする / 10てんのタイルパターンをはいちする / 20てんのタイルパターンをはいちする / 30てんのタイルパターンをはいちする / タイルパターンをなおす | hacer el fondo / elegir el fondo / poner paredes / poner pasillos / poner casillas de 10 puntos / poner casillas de 20 puntos / poner casillas de 30 puntos / arreglar las casillas |
| 0x22 | キャラクタをつくる / ドットたんいでつくる / サンプル / さゆうをはんてんする / じょうげをはんてんする / パターンをずらす / けす / コピーする | hacer los personajes / punto a punto / muestras / darle la vuelta de lado / darle la vuelta de arriba abajo / correr el dibujo / borrar / copiar |
| 0x2B | なにをしますか / キャラクタのうごきかたをきめる / タイマーをきめる / ゲームちゅうのおとをきめる / おわり | ¿Qué se hace? / decidir cómo se mueven los personajes / poner el tiempo / decidir los sonidos de la partida / acabar |
| 0x30 | うごきはどうしますか / あたらしくつくる / ほかのキャラクタとおなじ | ¿Y el movimiento? / hacer uno nuevo / igual que otro personaje |
| 0x32 | どんなぶきですか / すべてのあいてをやっつける / じぶんよりよわいあいてをやっつける | ¿Qué arma es? / acaba con todos los rivales / acaba con los más débiles que él |
| 0x33 | どんなあいてですか / じぶんよりつよい / じぶんよりよわい | ¿Qué rival es? / más fuerte que el protagonista / más débil que el protagonista |
| 0x36 | うごきかたはどれにしますか / ↑↓ / ←→ / ↑↓←→ / 8つのほうこう | ¿Cómo se mueve? / ↑↓ / ←→ / ↑↓←→ / ocho direcciones |
| 0x37 | がめんのはしではどうしますか / とまる / はんたいがわにでる | ¿Qué hace en el borde de la pantalla? / se para / sale por el otro lado |
| 0x3F | うごくおとをだしますか / いいえ / はい | ¿Suena al moverse? / no / sí |
| 0x40 | やられたときのおとをだしますか / いいえ / はい | ¿Suena al caer? / no / sí |
| 0x41 | やられたときのキャラクタをだしますか / いいえ / はい | ¿Sale otro personaje al caer? / no / sí |
| 0x44 | うごきかたはどれにしますか / きどうのうえをうごく / 8ほうこうのいずれかへうごく / ふきそくにうごく / ↑ / ↓ / ← / → / じぶんにちかずく / じぶんからとおざかる | ¿Cómo se mueve? / va por un recorrido / va en una de ocho direcciones / se mueve al azar / ↑ / ↓ / ← / → / se acerca al protagonista / se aleja del protagonista |
| 0x45 | とおざかりかたはどれにしますか / すばやく / てきどに / ゆっくり | ¿Cómo se aleja? / deprisa / normal / despacio |
| 0x46 | ちかずきかたはどれにしますか / すばやく / てきどに / ゆっくり | ¿Cómo se acerca? / deprisa / normal / despacio |
| 0x47 | どのキャラクタについてきめますか / じぶん / じぶんのぶき / あいて / あいてのぶき / おわり | ¿De qué personaje? / el protagonista / el arma del protagonista / el rival / el arma del rival / acabar |
| 0x49 | うごきかたはどれにしますか / ふきそくにうごく / じぶんにちかずく / じぶんからとおざかる / うごかない | ¿Cómo se mueve? / se mueve al azar / se acerca al protagonista / se aleja del protagonista / no se mueve |
| 0x4C | きえるまでのじかんをきめますか / いいえ / __びょう | ¿Cuánto tarda en desaparecer? / no / __ segundos |
| 0x4D | がめんのはしではどうしますか / とまる / はんたいがわにでる / きえる | ¿Qué hace en el borde de la pantalla? / se para / sale por el otro lado / desaparece |
| 0x52 | うごきかたはどれにしますか / (en blanco) / (en blanco) / ふきそくにうごく / じぶんにちかずく / じぶんからとおざかる / うごかない / もくてきちにむかってうごく | ¿Cómo se mueve? /  /  / se mueve al azar / se acerca al protagonista / se aleja del protagonista / no se mueve / va hacia su destino |
| 0x55 | うごきかたはどれにしますか / もくてきちにむかってうごく / ↑ / ↓ / ← / → / じぶんのむいているほうこうにうごく / うごかない | ¿Cómo se mueve? / va hacia su destino / ↑ / ↓ / ← / → / va hacia donde mira el protagonista / no se mueve |
| 0x5B | ぶきはどのキーででますか / TR1またはスペースキー / TR2またはリターンキー | ¿Con qué tecla sale el arma? / botón 1 o la barra / botón 2 o RETURN |
| 0x5D | きえるまでのじかんをきめますか / いいえ / __びょう | ¿Cuánto tarda en desaparecer? / no / __ segundos |
| 0x62 | うごきかたはどれにしますか / ↑ / ↓ / ← / → / じぶんにむかってうつ / じぶんにちかずく / うごかない | ¿Cómo se mueve? / ↑ / ↓ / ← / → / dispara al protagonista / se acerca al protagonista / no se mueve |
| 0x65 | きえるまでのじかんをきめますか / いいえ / __びょう | ¿Cuánto tarda en desaparecer? / no / __ segundos |
| 0x6D | (en blanco) / いいえ / (en blanco) |  / no /  |
| 0x7B | なにをしますか / あたらしくつくる / なおす / コピーする / けす / おわり | ¿Qué se hace? / hacer uno nuevo / arreglar / copiar / borrar / acabar |
| 0x82 | むきによってかたちをかえますか / いいえ / はい | ¿Cambia de dibujo según hacia dónde mira? / no / sí |
| 0x83 | おおきさをきめてください{ヨコXタテ} / 16X16 / 32X16 / 16X32 / 32X32 | Decide el tamaño (ancho x alto) / 16x16 / 32x16 / 16x32 / 32x32 |
| 0x85 | つぎのどれをつくりますか / じぶん / そのた | ¿Cuál de estos se hace? / el protagonista / otro |
| 0x87 | なにをしますか / あたらしくおとをつくる / おとをなおす / おとをけす / おわり | ¿Qué se hace? / hacer un sonido nuevo / arreglar un sonido / borrar un sonido / acabar |
| 0x8A | どんなおとをつくりますか / メロディ / こうかおん | ¿Qué sonido se hace? / una melodía / un efecto |
| 0x8B | どのようにつくりますか / サンプル / さっきょく | ¿Cómo se hace? / muestras / componer |
| 0x8C | なにをしますか / ふめん / おとをきく / テンポ / リピート / コード / おわり | ¿Qué se hace? / la partitura / escucharlo / el tempo / repetir / los acordes / acabar |
| 0x8D | どれにしますか / けっこん / カンカン / とつげき / タイトル | ¿Cuál? / boda / cancán / al ataque / título |
| 0x8E | どれにしますか / ばん / ばん / ばん / ばん / ばん | ¿Cuál? / «ban» (sin aclarar) / «ban» (sin aclarar) / «ban» (sin aclarar) / «ban» (sin aclarar) / «ban» (sin aclarar) |
| 0x8F | どれにしますか / うごきのおと / メカニック / ばくはつ / SF / けいほう | ¿Cuál? / el sonido del movimiento / mecánico / explosión / ciencia ficción / alarma |

## Los avisos

| aviso | en la ROM | traducción |
|---|---|---|
| 0x01 | あたらしくつくる | hacer uno nuevo |
| 0x02 | じぶんはなんかいでてきますか / __かい | ¿Cuántas veces sale el protagonista? / __ veces |
| 0x03 | タイマーはなんびょうにしますか / ___びょう | ¿Cuántos segundos de tiempo? / ___ segundos |
| 0x04 | なまえをいれてください / ________ | Escribe el nombre / ________ |
| 0x05 | メモリーがたりません / スペースキーをおしてください | No hay memoria bastante / Pulsa la barra |
| 0x06 | このステージはすでにあります / スペースキーをおしてください | Esa fase ya existe / Pulsa la barra |
| 0x07 | このキャラクタはすでにつかわれています / スペースキーをおしてください | Ese personaje ya se usa / Pulsa la barra |
| 0x08 | ゲームがあります / けさないならば おわりキーを / けしてもよければ / スペースキーをおしてください | Ya hay un juego / si no se borra, la tecla de acabar / si se puede borrar / Pulsa la barra |
| 0x09 | ゲームがありません / スペースキーをおしてください | No hay ningún juego / Pulsa la barra |
| 0x0A | スピードをきめてください / スペースキーでがめんがかわります | Decide la velocidad / La barra cambia de pantalla |
| 0x0C | おとがありません / スペースキーをおしてください | No hay sonidos / Pulsa la barra |
| 0x0D | キャラクタがありません / スペースキーをおしてください | No hay personajes / Pulsa la barra |
| 0x0F | スタートのおとをしていしてください | Elige el sonido de la salida |
| 0x11 | なまえをしていしてください | Elige el nombre |
| 0x13 | キャラクタがでるばしょをきめてください / スペースキーでがめんがかわります | Decide dónde sale el personaje / La barra cambia de pantalla |
| 0x14 | うまくよみこめません / スペースキーをおしてください | No se ha podido cargar / Pulsa la barra |
| 0x15 | ほぞんがうまくできていません / スペースキーをおしてください | No se ha guardado bien / Pulsa la barra |
| 0x17 | きどうをきめてください / スペースキーでがめんがかわります | Decide el recorrido / La barra cambia de pantalla |
| 0x18 | ばしょをきめてください / スペースキーでがめんがかわります | Decide el sitio / La barra cambia de pantalla |
| 0x19 | なんかいでてきますか / __かい | ¿Cuántas veces sale? / __ veces |
| 0x1A | このキャラクタはなんてんですか / ___0てん | ¿Cuántos puntos vale este personaje? / ___0 puntos |
| 0x1B | キャラクタがでるのはいつですか / __びょうごと | ¿Cuándo sale el personaje? / cada __ segundos |
| 0x1D | おなじなまえがすでにあります / スペースキーをおしてください | Ya hay otro con ese nombre / Pulsa la barra |
| 0x1E | もうとうろくできません / スペースキーをおしてください | No caben más / Pulsa la barra |
| 0x21 | ゲームオーバーのときのおとをきめてください | Decide el sonido de GAME OVER |
| 0x22 | どのキャラクタからでてきますか | ¿De qué personaje sale? |
| 0x23 | どのキャラクタからコピーしますか | ¿De qué personaje se copia? |
| 0x2B | キャラクタがでるばしょは「」のなかです / ↑↓←→キーで「と」をうごかします / スペースキーでそれぞれのばしょをきめます / リターンキーでメニューにもどります | El personaje sale dentro de 「」 / Las flechas mueven 「 y 」 / La barra fija cada sitio / RETURN vuelve al menú |
| 0x2C | ↑↓キーでスピードがかわります / ←→キーできざみがかわります / リターンキーでメニューにもどります | ↑↓ cambian la velocidad / ←→ cambian el paso / RETURN vuelve al menú |
| 0x2F | ↑↓←→キーで+がうごきます / スペースキーでつうかてんがきまります / とりけしキーで1つまえにもどります / リターンキーでメニューにもどります | Las flechas mueven la + / La barra fija los puntos por los que pasa / La tecla de deshacer vuelve un paso / RETURN vuelve al menú |
| 0x31 | ↑↓←→キーで+をうごかします / リターンキーでメニューにもどります | Las flechas mueven la + / RETURN vuelve al menú |
| 0x32 | スペースキーでおとがきけます | La barra deja oír el sonido |
| 0x33 | ふめんは↑↓キーでおんていをきめます / スペースキーでおんがくきごうをえらびます / リターンキーでメニューにもどります | En la partitura, ↑↓ eligen la nota / La barra elige el signo musical / RETURN vuelve al menú |
| 0x34 | いろをしていします / スペースキーでじっこうします / リターンキーでメニューにもどります | Elige el color / La barra lo hace / RETURN vuelve al menú |
| 0x35 | コピーシフトキーと↑↓←→キーでタイルパターンをコピーします / リターンキーでメニューにもどります | Copiar: SHIFT y las flechas copian casillas / RETURN vuelve al menú |
| 0x36 | スペースキーと↑↓←→キーでかきます / シフトキーと↑↓←→キーで+をはやくうごかします / リターンキーでメニューにもどります | La barra y las flechas dibujan / SHIFT y las flechas mueven la + deprisa / RETURN vuelve al menú |
| 0x39 | ↑↓キーでぜんごのはいけいをひょうじします / リターンキーでメニューにもどります | ↑↓ enseñan el fondo de antes y el de después / RETURN vuelve al menú |
| 0x3A | スペースキーと↑↓←→キーでタイルパターンをはいちします / シフトキーと↑↓←→キーでタイルパターンをえらびます / スクロールINSキーで1ぎょうついかします / スクロールDELキーで1ぎょうとります / リターンキーでメニューにもどります | La barra y las flechas ponen casillas / SHIFT y las flechas eligen la casilla / Desplazar: INS añade una fila / Desplazar: DEL quita una fila / RETURN vuelve al menú |
| 0x3B | スペースキーと↑↓←→キーでタイルパターンをはいちします / スクロールINSキーで1ぎょうついかします / スクロールDELキーで1ぎょうとります / リターンキーでメニューにもどります | La barra y las flechas ponen casillas / Desplazar: INS añade una fila / Desplazar: DEL quita una fila / RETURN vuelve al menú |
| 0x3C | シフトキーと↑↓←→キーでなおすタイルパターンをえらびます / スペースキーと↑↓←→キーでなおします / リターンキーでメニューにもどります | SHIFT y las flechas eligen la casilla que se arregla / La barra y las flechas la arreglan / RETURN vuelve al menú |
| 0x3D | スペースキーと↑↓←→キーでタイルパターンをはいちします / シフトキーと↑↓←→キーでタイルパターンをえらびます / リターンキーでメニューにもどります | La barra y las flechas ponen casillas / SHIFT y las flechas eligen la casilla / RETURN vuelve al menú |
| 0x3E | スペースキーと↑↓←→キーでタイルパターンをはいちします / リターンキーでメニューにもどります | La barra y las flechas ponen casillas / RETURN vuelve al menú |
| 0x3F | シフトキーと↑↓←→キーでほうこうをえらびます / スペースキーと↑↓←→キーでかきます / リターンキーでメニューにもどります | SHIFT y las flechas eligen la dirección / La barra y las flechas dibujan / RETURN vuelve al menú |
| 0x40 | シフトキーと↑↓←→キーでほうこうをえらびます / スペースキーでじっこうします / リターンキーでメニューにもどります | SHIFT y las flechas eligen la dirección / La barra lo hace / RETURN vuelve al menú |
| 0x41 | ↑↓←→キーでもとのほうこうをえらびます / スペースキーでじっこうします / リターンキーでメニューにもどります | Las flechas eligen la dirección de partida / La barra lo hace / RETURN vuelve al menú |
| 0x42 | ↑↓←→キーでパターンをえらびます / シフトキーと↑↓←→キーでほうこうをえらびます / スペースキーでじっこうします / リターンキーでメニューにもどります | Las flechas eligen el dibujo / SHIFT y las flechas eligen la dirección / La barra lo hace / RETURN vuelve al menú |
| 0x43 | シフトキーと↑↓←→キーでほうこうをえらびます / スペースキーと↑↓←→キーで1ドットパターンをずらします / リターンキーでメニューにもどります | SHIFT y las flechas eligen la dirección / La barra y las flechas corren el dibujo un punto / RETURN vuelve al menú |

## Los rótulos

| dirección | texto | dónde sale | traducción |
|---|---|---|---|
| 0x4B2E | HISCORE / SCORE / STAGE / LEFT / TIME | el marcador de la partida (`marcador_pinta`) | el récord, los puntos, la fase, las vidas y el tiempo |
| 0x5131 | LINE / BOX / BOXFILL / CIRCLE / PAINT / H-LINE / V-LINE | la paleta del editor de dibujo (`paleta_pinta`, 0x50F5) | las herramientas: línea, caja, caja llena, círculo, rellenar, línea horizontal y vertical |
| 0x6EBD | FOUND / SKIP | la carga de la cinta | encontrado / saltado |
| 0x7589 | SPEED / STEP | la velocidad de los recorridos | velocidad / paso |
| 0x8A6A | GAME START / GAME OVER / HIT SPACE KEY | la partida | empieza / fin de la partida / pulsa la barra |

Los huecos con rayas (__, ___0, ________) son donde se escribe un número o un nombre. «ばん», una de las muestras de sonido, no se ha podido aclarar.

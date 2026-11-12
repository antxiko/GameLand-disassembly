"""Los textos de Game Land, sacados de la ROM: los menus (0xB5D3: titulo y opciones, cada una un indice de las
cadenas de 0xB806), los avisos (0xB755, igual) y los rotulos fijos. Las cadenas meten trozos que se repiten
(0xB4E0) con el codigo 0x04. Los kana son los de la fuente de la BIOS; 0x09-0x0C son dibujos propios del cartucho
(`dibujos_menu`, 0x50C5: 0xA7C1 a la VRAM de las letras 0x08-0x1F): flechas arriba, derecha, abajo e izquierda;
0xA2 y 0xA3 son las comillas 「 」 de la fuente. Escribe docs/es/LOS-TEXTOS.md y docs/THE-TEXTS.md.

Uso: textos.py docs
"""
import os
import sys
import unicodedata

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
R = open(os.path.join(RAIZ, "gameland.rom"), "rb").read()


def B(a):
    return R[a - 0x4000]


HIRA = "をぁぃぅぇぉゃゅょっ あいうえおかきくけこさしすせそ"
KATA = "ヲァィゥェォャュョッーアイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワン゛゜"
HIRA2 = "たちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわん"
FLECHAS = {0x09: "↑", 0x0A: "→", 0x0B: "↓", 0x0C: "←", 0xA2: "「", 0xA3: "」"}


def ch(b):
    if b in FLECHAS:
        return FLECHAS[b]
    if b == ord("-"):
        return "ー"
    if 0x20 <= b < 0x7F:
        return chr(b)
    if 0x86 <= b <= 0x9F:
        return HIRA[b - 0x86]
    if 0xA6 <= b <= 0xDF:
        return KATA[b - 0xA6]
    if 0xE0 <= b <= 0xFD:
        return HIRA2[b - 0xE0]
    raise ValueError("codigo 0x%02X sin letra" % b)


def junta(s):
    """El dakuten y el handakuten van en su casilla aparte: se juntan con la letra de antes."""
    return unicodedata.normalize("NFC", s.replace("゛", "゙").replace("゜", "゚"))


def registro(base, n):
    a = base
    for _ in range(n - 1):
        a += 1 + B(a)
    return a + 1, B(a)


def trozo(n):
    a, n_ = registro(0xB4E0, n)
    return "".join(ch(B(a + i)) for i in range(n_))


def cadena(n):
    a, n_ = registro(0xB806, n)
    s, i = "", 0
    while i < n_:
        b = B(a + i)
        if b == 4:
            s += trozo(B(a + i + 1))
            i += 2
        else:
            s += ch(b)
            i += 1
    return junta(s)


def tabla(base, fin):
    n, out = 1, []
    while True:
        a, n_ = registro(base, n)
        if a - 1 >= fin:
            return out
        textos = [cadena(B(a + i)) for i in range(n_) if B(a + i)]
        if any(textos):
            out.append((n, a - 1, textos))
        n += 1


# (japones, castellano, ingles)
T = [
    ("ゲームランドでなにをしますか", "¿Qué hacemos en Game Land?", "What shall we do in Game Land?"),
    ("ゲームであそぶ", "jugar", "play a game"),
    ("ゲームをつくる", "hacer un juego", "make a game"),
    ("ゲームをなおす", "arreglar un juego", "fix a game"),
    ("ゲームをよみこむ", "cargar un juego", "load a game"),
    ("ゲームをほぞんする", "guardar el juego", "save the game"),
    ("ゲームのしゅるいはどれにしますか", "¿Qué clase de juego?", "What kind of game?"),
    ("せんとうしきゲーム", "de combate", "combat type"),
    ("めいろしきゲーム", "de laberinto", "maze type"),
    ("はいけいはどれにしますか", "¿Qué fondo?", "Which background?"),
    ("1しゅるい", "uno", "one kind"),
    ("3しゅるい", "tres", "three kinds"),
    ("スクロールする", "que se desplace", "scrolling"),
    ("スクロールはどれにしますか", "¿Cómo se desplaza?", "How does it scroll?"),
    ("じぶんのうごきでスクロールする↑↓", "con el protagonista, ↑↓", "with the player's moves, ↑↓"),
    ("じどうてきにスクロールする↓", "solo, ↓", "automatically, ↓"),
    ("じどうてきにスクロールする↑", "solo, ↑", "automatically, ↑"),
    ("かくにんしますか", "¿Lo confirmas?", "Confirm?"),
    ("はい", "sí", "yes"),
    ("いいえ", "no", "no"),
    ("なにをしますか", "¿Qué se hace?", "What now?"),
    ("はいけいをつくる", "hacer el fondo", "make the background"),
    ("キャラクタをつくる", "hacer los personajes", "make the characters"),
    ("おとをつくる", "hacer los sonidos", "make the sounds"),
    ("ストーリーをきめる", "decidir la historia", "set the story"),
    ("おわり", "acabar", "end"),
    ("でてくるかいすうはふえますか", "¿Salen más veces?", "Do they come out more often?"),
    ("____0てんごと", "cada ____0 puntos", "every ____0 points"),
    ("ステージのストーリーをきめましょう", "Decidamos la historia de las fases", "Let's set the stages' story"),
    ("あたらしくつくる", "hacer uno nuevo", "make a new one"),
    ("なおす", "arreglar", "fix"),
    ("けす", "borrar", "delete"),
    ("どれにしますか", "¿Cuál?", "Which one?"),
    ("ステージ", "fase", "stage"),
    ("だい1めん", "pantalla 1", "screen 1"),
    ("だい2めん", "pantalla 2", "screen 2"),
    ("だい3めん", "pantalla 3", "screen 3"),
    ("ドットたんいでつくる", "punto a punto", "dot by dot"),
    ("8X8たんいでコピーする", "copiar de 8x8 en 8x8", "copy 8x8 at a time"),
    ("はいけいをぬりつぶす", "rellenar el fondo", "fill the background"),
    ("タイルパターンをはいちする", "poner casillas", "place tiles"),
    ("タイルパターンをなおす", "arreglar las casillas", "fix the tiles"),
    ("スクロールするはんいをこていする", "fijar lo que se desplaza", "fix the scrolling area"),
    ("はいけいをえらぶ", "elegir el fondo", "choose the background"),
    ("かべをはいちする", "poner paredes", "place walls"),
    ("つうろをはいちする", "poner pasillos", "place corridors"),
    ("10てんのタイルパターンをはいちする", "poner casillas de 10 puntos", "place 10-point tiles"),
    ("20てんのタイルパターンをはいちする", "poner casillas de 20 puntos", "place 20-point tiles"),
    ("30てんのタイルパターンをはいちする", "poner casillas de 30 puntos", "place 30-point tiles"),
    ("サンプル", "muestras", "samples"),
    ("さゆうをはんてんする", "darle la vuelta de lado", "flip left-right"),
    ("じょうげをはんてんする", "darle la vuelta de arriba abajo", "flip upside down"),
    ("パターンをずらす", "correr el dibujo", "shift the drawing"),
    ("コピーする", "copiar", "copy"),
    ("キャラクタのうごきかたをきめる", "decidir cómo se mueven los personajes", "set how the characters move"),
    ("タイマーをきめる", "poner el tiempo", "set the timer"),
    ("ゲームちゅうのおとをきめる", "decidir los sonidos de la partida", "set the in-game sounds"),
    ("うごきはどうしますか", "¿Y el movimiento?", "What about the movement?"),
    ("ほかのキャラクタとおなじ", "igual que otro personaje", "same as another character"),
    ("どんなぶきですか", "¿Qué arma es?", "What kind of weapon?"),
    ("すべてのあいてをやっつける", "acaba con todos los rivales", "beats every enemy"),
    ("じぶんよりよわいあいてをやっつける", "acaba con los más débiles que él", "beats enemies weaker than you"),
    ("どんなあいてですか", "¿Qué rival es?", "What kind of enemy?"),
    ("じぶんよりつよい", "más fuerte que el protagonista", "stronger than you"),
    ("じぶんよりよわい", "más débil que el protagonista", "weaker than you"),
    ("うごきかたはどれにしますか", "¿Cómo se mueve?", "How does it move?"),
    ("↑↓", "↑↓", "↑↓"),
    ("←→", "←→", "←→"),
    ("↑↓←→", "↑↓←→", "↑↓←→"),
    ("8つのほうこう", "ocho direcciones", "eight directions"),
    ("がめんのはしではどうしますか", "¿Qué hace en el borde de la pantalla?", "What does it do at the screen edge?"),
    ("とまる", "se para", "stops"),
    ("はんたいがわにでる", "sale por el otro lado", "comes out on the other side"),
    ("うごくおとをだしますか", "¿Suena al moverse?", "Sound when moving?"),
    ("やられたときのおとをだしますか", "¿Suena al caer?", "Sound when hit?"),
    ("やられたときのキャラクタをだしますか", "¿Sale otro personaje al caer?", "Show a character when hit?"),
    ("きどうのうえをうごく", "va por un recorrido", "moves along a track"),
    ("8ほうこうのいずれかへうごく", "va en una de ocho direcciones", "moves in one of eight directions"),
    ("ふきそくにうごく", "se mueve al azar", "moves at random"),
    ("↑", "↑", "↑"),
    ("↓", "↓", "↓"),
    ("←", "←", "←"),
    ("→", "→", "→"),
    ("じぶんにちかずく", "se acerca al protagonista", "comes towards you"),
    ("じぶんからとおざかる", "se aleja del protagonista", "moves away from you"),
    ("とおざかりかたはどれにしますか", "¿Cómo se aleja?", "How does it move away?"),
    ("すばやく", "deprisa", "fast"),
    ("てきどに", "normal", "moderately"),
    ("ゆっくり", "despacio", "slowly"),
    ("ちかずきかたはどれにしますか", "¿Cómo se acerca?", "How does it come closer?"),
    ("どのキャラクタについてきめますか", "¿De qué personaje?", "Which character?"),
    ("じぶん", "el protagonista", "the player"),
    ("じぶんのぶき", "el arma del protagonista", "the player's weapon"),
    ("あいて", "el rival", "the enemy"),
    ("あいてのぶき", "el arma del rival", "the enemy's weapon"),
    ("うごかない", "no se mueve", "does not move"),
    ("きえるまでのじかんをきめますか", "¿Cuánto tarda en desaparecer?", "Set the time until it disappears?"),
    ("__びょう", "__ segundos", "__ seconds"),
    ("きえる", "desaparece", "disappears"),
    ("もくてきちにむかってうごく", "va hacia su destino", "heads for its destination"),
    ("じぶんのむいているほうこうにうごく", "va hacia donde mira el protagonista", "moves the way the player faces"),
    ("ぶきはどのキーででますか", "¿Con qué tecla sale el arma?", "Which key fires the weapon?"),
    ("TR1またはスペースキー", "botón 1 o la barra", "button 1 or the space bar"),
    ("TR2またはリターンキー", "botón 2 o RETURN", "button 2 or RETURN"),
    ("じぶんにむかってうつ", "dispara al protagonista", "shoots at the player"),
    ("むきによってかたちをかえますか", "¿Cambia de dibujo según hacia dónde mira?", "Does its drawing change with direction?"),
    ("おおきさをきめてください{ヨコXタテ}", "Decide el tamaño (ancho x alto)", "Set the size (width x height)"),
    ("16X16", "16x16", "16x16"),
    ("32X16", "32x16", "32x16"),
    ("16X32", "16x32", "16x32"),
    ("32X32", "32x32", "32x32"),
    ("つぎのどれをつくりますか", "¿Cuál de estos se hace?", "Which of these will you make?"),
    ("そのた", "otro", "other"),
    ("あたらしくおとをつくる", "hacer un sonido nuevo", "make a new sound"),
    ("おとをなおす", "arreglar un sonido", "fix a sound"),
    ("おとをけす", "borrar un sonido", "delete a sound"),
    ("どんなおとをつくりますか", "¿Qué sonido se hace?", "What kind of sound?"),
    ("メロディ", "una melodía", "a melody"),
    ("こうかおん", "un efecto", "a sound effect"),
    ("どのようにつくりますか", "¿Cómo se hace?", "How will you make it?"),
    ("さっきょく", "componer", "compose"),
    ("ふめん", "la partitura", "the score"),
    ("おとをきく", "escucharlo", "listen"),
    ("テンポ", "el tempo", "tempo"),
    ("リピート", "repetir", "repeat"),
    ("コード", "los acordes", "chords"),
    ("けっこん", "boda", "wedding"),
    ("カンカン", "cancán", "can-can"),
    ("とつげき", "al ataque", "charge"),
    ("タイトル", "título", "title"),
    ("ばん", "«ban» (sin aclarar)", "\"ban\" (unclear)"),
    ("うごきのおと", "el sonido del movimiento", "movement sound"),
    ("メカニック", "mecánico", "mechanical"),
    ("ばくはつ", "explosión", "explosion"),
    ("SF", "ciencia ficción", "sci-fi"),
    ("けいほう", "alarma", "alarm"),
    ("じぶんはなんかいでてきますか", "¿Cuántas veces sale el protagonista?", "How many lives does the player have?"),
    ("__かい", "__ veces", "__ times"),
    ("タイマーはなんびょうにしますか", "¿Cuántos segundos de tiempo?", "How many seconds on the timer?"),
    ("___びょう", "___ segundos", "___ seconds"),
    ("なまえをいれてください", "Escribe el nombre", "Type the name"),
    ("________", "________", "________"),
    ("メモリーがたりません", "No hay memoria bastante", "Not enough memory"),
    ("スペースキーをおしてください", "Pulsa la barra", "Press the space bar"),
    ("このステージはすでにあります", "Esa fase ya existe", "That stage already exists"),
    ("このキャラクタはすでにつかわれています", "Ese personaje ya se usa", "That character is already in use"),
    ("ゲームがあります", "Ya hay un juego", "There is a game already"),
    ("けさないならば おわりキーを", "si no se borra, la tecla de acabar", "if not deleting, the end key"),
    ("けしてもよければ", "si se puede borrar", "if it may be deleted"),
    ("ゲームがありません", "No hay ningún juego", "There is no game"),
    ("スピードをきめてください", "Decide la velocidad", "Set the speed"),
    ("スペースキーでがめんがかわります", "La barra cambia de pantalla", "The space bar changes the screen"),
    ("おとがありません", "No hay sonidos", "There are no sounds"),
    ("キャラクタがありません", "No hay personajes", "There are no characters"),
    ("スタートのおとをしていしてください", "Elige el sonido de la salida", "Choose the start sound"),
    ("なまえをしていしてください", "Elige el nombre", "Choose the name"),
    ("キャラクタがでるばしょをきめてください", "Decide dónde sale el personaje", "Set where the character appears"),
    ("うまくよみこめません", "No se ha podido cargar", "Could not load it"),
    ("ほぞんがうまくできていません", "No se ha guardado bien", "It was not saved properly"),
    ("きどうをきめてください", "Decide el recorrido", "Set the track"),
    ("ばしょをきめてください", "Decide el sitio", "Set the place"),
    ("なんかいでてきますか", "¿Cuántas veces sale?", "How many times does it appear?"),
    ("このキャラクタはなんてんですか", "¿Cuántos puntos vale este personaje?", "How many points is this character worth?"),
    ("___0てん", "___0 puntos", "___0 points"),
    ("キャラクタがでるのはいつですか", "¿Cuándo sale el personaje?", "When does the character appear?"),
    ("__びょうごと", "cada __ segundos", "every __ seconds"),
    ("おなじなまえがすでにあります", "Ya hay otro con ese nombre", "That name already exists"),
    ("もうとうろくできません", "No caben más", "No more can be registered"),
    ("ゲームオーバーのときのおとをきめてください", "Decide el sonido de GAME OVER", "Set the GAME OVER sound"),
    ("どのキャラクタからでてきますか", "¿De qué personaje sale?", "Which character does it come from?"),
    ("どのキャラクタからコピーしますか", "¿De qué personaje se copia?", "Which character is it copied from?"),
    ("キャラクタがでるばしょは「」のなかです", "El personaje sale dentro de 「」", "The character appears inside 「」"),
    ("↑↓←→キーで「と」をうごかします", "Las flechas mueven 「 y 」", "The arrow keys move 「 and 」"),
    ("スペースキーでそれぞれのばしょをきめます", "La barra fija cada sitio", "The space bar sets each place"),
    ("リターンキーでメニューにもどります", "RETURN vuelve al menú", "RETURN goes back to the menu"),
    ("↑↓キーでスピードがかわります", "↑↓ cambian la velocidad", "↑↓ change the speed"),
    ("←→キーできざみがかわります", "←→ cambian el paso", "←→ change the step"),
    ("↑↓←→キーで+がうごきます", "Las flechas mueven la +", "The arrow keys move the +"),
    ("スペースキーでつうかてんがきまります", "La barra fija los puntos por los que pasa", "The space bar sets the points it passes"),
    ("とりけしキーで1つまえにもどります", "La tecla de deshacer vuelve un paso", "The undo key goes back one step"),
    ("↑↓←→キーで+をうごかします", "Las flechas mueven la +", "The arrow keys move the +"),
    ("スペースキーでおとがきけます", "La barra deja oír el sonido", "The space bar plays the sound"),
    ("ふめんは↑↓キーでおんていをきめます", "En la partitura, ↑↓ eligen la nota", "On the score, ↑↓ set the pitch"),
    ("スペースキーでおんがくきごうをえらびます", "La barra elige el signo musical", "The space bar picks the musical sign"),
    ("いろをしていします", "Elige el color", "Choose the colour"),
    ("スペースキーでじっこうします", "La barra lo hace", "The space bar does it"),
    ("コピーシフトキーと↑↓←→キーでタイルパターンをコピーします", "Copiar: SHIFT y las flechas copian casillas", "Copy: SHIFT and the arrows copy tiles"),
    ("スペースキーと↑↓←→キーでかきます", "La barra y las flechas dibujan", "Space and the arrows draw"),
    ("シフトキーと↑↓←→キーで+をはやくうごかします", "SHIFT y las flechas mueven la + deprisa", "SHIFT and the arrows move the + fast"),
    ("↑↓キーでぜんごのはいけいをひょうじします", "↑↓ enseñan el fondo de antes y el de después", "↑↓ show the previous and next background"),
    ("スペースキーと↑↓←→キーでタイルパターンをはいちします", "La barra y las flechas ponen casillas", "Space and the arrows place tiles"),
    ("シフトキーと↑↓←→キーでタイルパターンをえらびます", "SHIFT y las flechas eligen la casilla", "SHIFT and the arrows choose the tile"),
    ("スクロールINSキーで1ぎょうついかします", "Desplazar: INS añade una fila", "Scroll: INS adds a row"),
    ("スクロールDELキーで1ぎょうとります", "Desplazar: DEL quita una fila", "Scroll: DEL removes a row"),
    ("シフトキーと↑↓←→キーでなおすタイルパターンをえらびます", "SHIFT y las flechas eligen la casilla que se arregla", "SHIFT and the arrows choose the tile to fix"),
    ("スペースキーと↑↓←→キーでなおします", "La barra y las flechas la arreglan", "Space and the arrows fix it"),
    ("シフトキーと↑↓←→キーでほうこうをえらびます", "SHIFT y las flechas eligen la dirección", "SHIFT and the arrows choose the direction"),
    ("↑↓←→キーでもとのほうこうをえらびます", "Las flechas eligen la dirección de partida", "The arrows choose the original direction"),
    ("↑↓←→キーでパターンをえらびます", "Las flechas eligen el dibujo", "The arrows choose the drawing"),
    ("スペースキーと↑↓←→キーで1ドットパターンをずらします", "La barra y las flechas corren el dibujo un punto", "Space and the arrows shift the drawing one dot"),
]
TRAD = {j: (e, i) for j, e, i in T}

FIJOS = [
    # (direccion, texto, donde sale, castellano, ingles)
    (0x4B2E, "HISCORE / SCORE / STAGE / LEFT / TIME", "el marcador de la partida (`marcador_pinta`)",
     "el récord, los puntos, la fase, las vidas y el tiempo", "high score, score, stage, lives and time"),
    (0x5131, "LINE / BOX / BOXFILL / CIRCLE / PAINT / H-LINE / V-LINE", "la paleta del editor de dibujo (`paleta_pinta`, 0x50F5)",
     "las herramientas: línea, caja, caja llena, círculo, rellenar, línea horizontal y vertical",
     "the tools: line, box, filled box, circle, paint, horizontal and vertical line"),
    (0x6EBD, "FOUND / SKIP", "la carga de la cinta", "encontrado / saltado", "found / skipped"),
    (0x7589, "SPEED / STEP", "la velocidad de los recorridos", "velocidad / paso", "speed / step"),
    (0x8A6A, "GAME START / GAME OVER / HIT SPACE KEY", "la partida", "empieza / fin de la partida / pulsa la barra",
     "start / game over / press space"),
]


def fila(textos, idioma):
    k = 0 if idioma == "es" else 1
    jp = " / ".join(t if t else "(en blanco)" for t in textos)
    tr = " / ".join((TRAD[t][k] if t else "") for t in textos)
    return jp, tr


def escribe(docs):
    menus = tabla(0xB5D3, 0xB755)
    avisos = tabla(0xB755, 0xB806)
    faltan = sorted({t for _, _, ts in menus + avisos for t in ts if t and t not in TRAD})
    if faltan:
        raise SystemExit("sin traduccion: %s" % faltan)
    for idioma, ruta in (("es", os.path.join(docs, "es", "LOS-TEXTOS.md")), ("en", os.path.join(docs, "THE-TEXTS.md"))):
        es = idioma == "es"
        L = ["# Los textos" if es else "# The texts", ""]
        L.append(
            "Todos los textos de la ROM, sacados de ella por `tools/textos.py`. Los menús (0xB5D3) y los avisos "
            "(0xB755) son listas de números de cadenas (0xB806), y las cadenas meten trozos que se repiten (0xB4E0). "
            "Las letras son los kana de la fuente de la BIOS; las flechas ↑ → ↓ ← son dibujos del propio cartucho "
            "(los códigos 0x09-0x0C, que `dibujos_menu`, 0x50C5, copia de 0xA7C1)." if es else
            "Every text in the ROM, taken from it by `tools/textos.py`. The menus (0xB5D3) and the messages (0xB755) "
            "are lists of string numbers (0xB806), and the strings pull in repeated pieces (0xB4E0). The letters are "
            "the kana of the BIOS font; the arrows ↑ → ↓ ← are the cartridge's own drawings (codes 0x09-0x0C, which "
            "`dibujos_menu`, 0x50C5, copies from 0xA7C1).")
        L += ["", "## Los menús" if es else "## The menus", "",
              "Primero el título del menú y después sus opciones." if es else "The menu title first, then its options.", "",
              "| menú | en la ROM | traducción |" if es else "| menu | in the ROM | translation |", "|---|---|---|"]
        for n, a, ts in menus:
            jp, tr = fila(ts, idioma)
            L.append("| 0x%02X | %s | %s |" % (n, jp, tr))
        L += ["", "## Los avisos" if es else "## The messages", "",
              "| aviso | en la ROM | traducción |" if es else "| message | in the ROM | translation |", "|---|---|---|"]
        for n, a, ts in avisos:
            jp, tr = fila(ts, idioma)
            L.append("| 0x%02X | %s | %s |" % (n, jp, tr))
        L += ["", "## Los rótulos" if es else "## The labels", "",
              "| dirección | texto | dónde sale | traducción |" if es else "| address | text | where | translation |",
              "|---|---|---|---|"]
        for a, t, donde, tes, ten in FIJOS:
            L.append("| 0x%04X | %s | %s | %s |" % (a, t, donde if es else donde.replace("el marcador de la partida", "the in-game scoreboard").replace("la paleta del editor de dibujo", "the drawing editor's palette").replace("la carga de la cinta", "loading from tape").replace("la velocidad de los recorridos", "the track speed").replace("la partida", "the game"), tes if es else ten))
        L += ["", ("Los huecos con rayas (__, ___0, ________) son donde se escribe un número o un nombre. "
                   "«ばん», una de las muestras de sonido, no se ha podido aclarar." if es else
                   "The underscored gaps (__, ___0, ________) are where a number or a name is typed. \"ばん\", one of "
                   "the sound samples, could not be made out."), ""]
        open(ruta, "w", encoding="utf-8", newline="\n").write("\n".join(L))
        print(ruta, len(menus), "menus,", len(avisos), "avisos")


if __name__ == "__main__":
    escribe(sys.argv[1])

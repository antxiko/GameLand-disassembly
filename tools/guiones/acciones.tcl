# acciones.tcl: un jugador de listas de acciones para Game Land (lo cargan los guiones que definen ::acc).
#   {t fila bit}        pulsa una tecla 6 cuadros y espera 18
#   {s fila bit}        lo mismo con SHIFT
#   {e N}               espera N cuadros
#   {ir X Y}            lleva el cursor del editor (0xFBC3 X, 0xFBC4 Y, en puntos) a X, Y: con SHIFT de 8 en 8
#                       mientras falten 8 o mas, despues de uno en uno; una pulsacion cada 6 cuadros
#   {escribe TEXTO}     teclea el texto (letras y cifras), una tecla cada 24 cuadros

#   {fin}               acaba la grabacion
# Las teclas: la barra 8 0x01, RETURN 7 0x80, cursores 8 0x10 izq, 0x20 arriba, 0x40 abajo, 0x80 der; SHIFT 6 0x01.
set ::i 0
set ::espera 0
set ::suelta {}
proc pulsa {fila bit} { keymatrixdown $fila $bit; lappend ::suelta [list $fila $bit] }
proc suelta_todo {} { foreach k $::suelta { keymatrixup {*}$k }; set ::suelta {} }
set ::letras {A {2 0x40} B {2 0x80} C {3 0x01} D {3 0x02} E {3 0x04} F {3 0x08} G {3 0x10} H {3 0x20} I {3 0x40}
 J {3 0x80} K {4 0x01} L {4 0x02} M {4 0x04} N {4 0x08} O {4 0x10} P {4 0x20} Q {4 0x40} R {4 0x80} S {5 0x01}
 T {5 0x02} U {5 0x04} V {5 0x08} W {5 0x10} X {5 0x20} Y {5 0x40} Z {5 0x80} 0 {0 0x01} 1 {0 0x02} 2 {0 0x04}
 3 {0 0x08} 4 {0 0x10} 5 {0 0x20} 6 {0 0x40} 7 {0 0x80} 8 {1 0x01} 9 {1 0x02} { } {8 0x01}}
proc guion {n} {
    if {$::espera > 0} {
        incr ::espera -1
        if {$::espera == $::suelta_en} { suelta_todo }
        return 0
    }
    if {$::i >= [llength $::acc]} { return 1 }
    set a [lindex $::acc $::i]
    set ::suelta_en -1
    switch [lindex $a 0] {
        t { pulsa [lindex $a 1] [lindex $a 2]; set ::espera 24; set ::suelta_en 18; incr ::i }
        s { pulsa 6 0x01; pulsa [lindex $a 1] [lindex $a 2]; set ::espera 24; set ::suelta_en 18; incr ::i }
        e { set ::espera [lindex $a 1]; incr ::i }
        escribe {
            if {![info exists ::k]} { set ::k 0 }
            set txt [lindex $a 1]
            if {$::k >= [string length $txt]} { unset ::k; incr ::i; return 0 }
            set c [string index $txt $::k]
            pulsa {*}[dict get $::letras $c]
            set ::espera 24; set ::suelta_en 18; incr ::k
        }
        ir {
            set x [debug read memory 0xFBC3]; set y [debug read memory 0xFBC4]
            set tx [lindex $a 1]; set ty [lindex $a 2]
            set dx [expr {$tx - $x}]; set dy [expr {$ty - $y}]
            if {$dx == 0 && $dy == 0} { incr ::i; return 0 }
            set lejos [expr {abs($dx) >= 8 || abs($dy) >= 8}]
            if {$lejos} { pulsa 6 0x01 }
            if {$dx > 0 && (!$lejos || $dx >= 8)} { pulsa 8 0x80 } elseif {$dx < 0 && (!$lejos || $dx <= -8)} { pulsa 8 0x10 }
            if {$dy > 0 && (!$lejos || $dy >= 8)} { pulsa 8 0x40 } elseif {$dy < 0 && (!$lejos || $dy <= -8)} { pulsa 8 0x20 }
            set ::espera 6; set ::suelta_en 3
        }

        fin { return 1 }
    }
    return 0
}

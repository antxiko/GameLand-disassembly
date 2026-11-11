# Para mirar el editor: la barra en el titulo (600), abajo (800) y la barra (850): la opcion 2; despues, cada 120
# cuadros una tecla de la lista (cursores, la barra, RETURN, numeros) pulsada 6 cuadros. Hasta el 7000.
proc toca {fila bit} {
    keymatrixdown $fila $bit
    after time 0.1 "keymatrixup $fila $bit"
}
set ::teclas {{8 0x80} {8 0x40} {8 0x01} {7 0x80} {0 0x02} {8 0x10} {8 0x20} {8 0x01} {0 0x04} {7 0x80} {8 0x80} {8 0x01} {0 0x08} {7 0x04} {8 0x40} {8 0x01}}
proc guion {n} {
    if {$n == 600} { toca 8 0x01 }
    if {$n == 800} { toca 8 0x40 }
    if {$n == 850} { toca 8 0x01 }
    if {$n > 1000 && $n % 120 == 0} {
        set k [lindex $::teclas [expr {($n / 120) % [llength $::teclas]}]]
        toca {*}$k
    }
    return [expr {$n >= 7000}]
}

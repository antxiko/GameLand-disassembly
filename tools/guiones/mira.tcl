# Para mirar: 1500 cuadros sin tocar; despues la barra y los cursores cada poco, hasta el 6000.
proc toca {fila bit} {
    keymatrixdown $fila $bit
    after time 0.08 "keymatrixup $fila $bit"
}
proc guion {n} {
    if {$n > 1500 && $n % 300 == 0} { toca 8 0x01 }
    if {$n > 1500 && $n % 300 == 150} { toca 8 0x80 }
    if {$n > 1500 && $n % 300 == 200} { toca 8 0x40 }
    return [expr {$n >= 6000}]
}

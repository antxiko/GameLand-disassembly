; ==========================================================================
; Game Land - ROM de 32 KB en 0x4000
; ==========================================================================
; Generado por tools/mkasm.py a partir del trazado de flujo real.
; Los comentarios provienen de tools/../src/*.notes y estan anclados a
; direccion, de modo que sobreviven a un retrazado.
; ==========================================================================

	org 0x04000


; ----------------------------------------------------------------------
; Etiquetas que no caen en ninguna posicion emitida del listado
; (destinos fuera del binario o dentro de una instruccion).
; ----------------------------------------------------------------------
cursor_otro_va:	equ 0x046bd
parpadeo_y_cp:	equ 0x047c3
sprite_x:	equ 0x047e2
sprite_dibujo:	equ 0x047e5
sprite_color:	equ 0x047e8
dibujos_a_ram:	equ 0x04c35
modo_puntos_cp:	equ 0x04eba
modo_fondo_70:	equ 0x04f4d
modo_fondo_71:	equ 0x04f50
modo_fondo_72:	equ 0x04f53
modo_fondo_73:	equ 0x04f56
atributos_mueve_z:	equ 0x06083
dibujo_al_editor_cp:	equ 0x06266
dibujo_del_editor_cp:	equ 0x062b1
copia_marca_borra:	equ 0x06747
cuadrante_cp1:	equ 0x068e5
cuadrante_cp2:	equ 0x068e7
cuadrante_cp3:	equ 0x068e9
rejilla_cursor_quita:	equ 0x06bd0
cinta_compara_z:	equ 0x06c76
cinta_lee_vram_z:	equ 0x06ce3
menu_5:	equ 0x07034
menu_6:	equ 0x07037
menu_sonido_vencido:	equ 0x07332
sonido_numero_b:	equ 0x07344
menu_32:	equ 0x073e8
menu_aviso_43:	equ 0x07492
rapidez_aviso_50:	equ 0x074b0
rapidez_aviso_5c:	equ 0x074b3
rapidez_aviso_64:	equ 0x074b6
rapidez_menu_46:	equ 0x0766e
tiempo_menu_5d:	equ 0x0775e
tiempo_menu_65:	equ 0x07761
personaje_borra_menu:	equ 0x078de
campo_lee_07:	equ 0x07a4a
campo_lee_04:	equ 0x07a4d
campo_lee_0a:	equ 0x07a50
campo_lee_03:	equ 0x07a53
campo_resta_0d:	equ 0x07a6a
campo_resta_11:	equ 0x07a6d
campo_resta_18:	equ 0x07a70
campo_c_19:	equ 0x07a81
campo_c_05:	equ 0x07a84
campo_c_1f:	equ 0x07a87
campo_c_19b:	equ 0x07a8a
campo_c_11:	equ 0x07a90
campo_c_17:	equ 0x07a93
campo_c_12:	equ 0x07a96
campo_c_14:	equ 0x07a99
campo_fase_13:	equ 0x07aa7
cursor_cuadro:	equ 0x0836b
punto_sprite_5:	equ 0x08377
punto_sprite_6:	equ 0x0837a
punto_sprite_7:	equ 0x0837d
punto_sprite_8:	equ 0x08380
punto_sprite_9:	equ 0x08383
fichas_rutina_2:	equ 0x083bc
fichas_rutina_3:	equ 0x083bf
fichas_rutina_4:	equ 0x083c2
fichas_rutina_5:	equ 0x083c5
fichas_rutina_6:	equ 0x083c8
fichas_rutina_7:	equ 0x083cb
fichas_rutina_8:	equ 0x083ce
fichas_rutina_9:	equ 0x083d1
mov_abajo:	equ 0x09317
mov_derecha:	equ 0x0931a
mov_izquierda:	equ 0x0931d
ram_pide_mapa:	equ 0x0a242
mascara_hace_cp:	equ 0x0aa1d

; ----------------------------------------------------------------------
; DATOS cabecera: La cabecera: "AB", INIT 0x402F, sin STATEMENT, DEVICE ni
;   TEXT; en 0x4010, "PX": la marca que busca INIT (y los programas de cinta)
;   0x4000..0x4012  (18 bytes)
DATA_cabecera:
	defb 041h,042h,02fh,040h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 4000  AB/@............
	defb 050h,058h	; 4010

; ======================================================================
; CODIGO 0x4012..0x402d  (27 bytes)
; ======================================================================


api:		; Nueve "jp" para los programas que se cargan de cinta (Game Land Special): las rutinas del cartucho en sitio fijo
	jp graficos_entra		;4012
api_texto:
	jp texto_entra		;4015
api_casilla:
	jp casilla_a_ram		;4018
api_int_on:
	jp vdp_int_on		;401b
api_int_off:
	jp vdp_int_off		;401e
api_ganchos:
	jp ganchos		;4021
api_stop:
	jp stop_mira		;4024
api_limpia:
	jp pantalla_texto_limpia		;4027
api_letra:
	jp letra_pon		;402a

; ----------------------------------------------------------------------
; DATOS api_fin: Dos bytes detras de la tabla (0xC7 0x42)
;   0x402d..0x402f  (2 bytes)
DATA_api_fin:
	defb 0c7h,042h	; 402d

; ======================================================================
; CODIGO 0x402f..0x4145  (278 bytes)
; ======================================================================


init:		; INIT: busca su propio slot (en cada slot y subslot, "AB" en 0x4000, INIT 0x402F y "PX" en 0x4010), lo pone tambien en la pagina 2, apaga la interrupcion del VDP, borra las zonas de trabajo del BASIC, pone sus ganchos y va al programa (0x6FDA); si no se encuentra, vuelve al BASIC
	di			;402f   ; sin interrupciones
	im 1		;4030   ; modo 1
	ld de,0fcc1h		;4032   ; EXPTBL: si cada slot esta expandido
	ld c,000h		;4035   ; el slot 0
init_slot:
	ld a,(de)			;4037   ; el bit de expandido...
	or c			;4038   ; ...en el slot
	ld c,a			;4039
	push de			;403a   ; guardado
init_mira:
	ld hl,04000h		;403b   ; en 0x4000...
	call slot_lee2		;403e   ; ...los dos primeros bytes (RDSLT)
	push hl			;4041
	ld hl,04241h		;4042   ; "AB"?
	rst 20h			;4045   ; DCOMPR
	pop hl			;4046
	jr nz,init_siguiente		;4047   ; no
	call slot_lee2		;4049   ; en 0x4002: INIT
	ld hl,init		;404c   ; 0x402F?
	rst 20h			;404f   ; DCOMPR
	jr nz,init_siguiente		;4050   ; no
	ld hl,04010h		;4052   ; en 0x4010...
	call slot_lee2		;4055
	ld hl,05850h		;4058   ; ..."PX"?
	rst 20h			;405b   ; DCOMPR
	jr z,init_hallado		;405c   ; si: es este
init_siguiente:
	ld a,c			;405e   ; expandido?
	and a			;405f
	jp p,init_slot_sig		;4060   ; no: el slot siguiente
	add a,004h		;4063   ; el subslot siguiente...
	ld c,a			;4065
	cp 090h		;4066   ; ...hasta el 3
	jr c,init_mira		;4068
	and 003h		;406a
	ld c,a			;406c
init_slot_sig:
	pop de			;406d   ; el siguiente
	inc de			;406e
	inc c			;406f
	ld a,c			;4070
	cp 004h		;4071   ; los cuatro?
	jr c,init_slot		;4073   ; no
	ret			;4075   ; no esta: al BASIC
init_hallado:
	ld a,c			;4076   ; el slot...
	ld (0fe6bh),a		;4077   ; ...guardado en 0xFE6B
	ld hl,08000h		;407a   ; en la pagina 2
	call 00024h		;407d   ; ENASLT
	pop de			;4080
	call vdp_int_off		;4081   ; la interrupcion del VDP apagada
	ld hl,0f417h		;4084   ; 0xF417-0xF91E a cero
	ld de,0f418h		;4087
	ld bc,00507h		;408a
	xor a			;408d
	ld (hl),a			;408e
	ldir		;408f
	ld hl,0f92ah		;4091   ; 0xF92A-0xFBD9 a cero
	ld de,0f92bh		;4094
	ld bc,002afh		;4097
	ld (hl),a			;409a
	ldir		;409b
	ld hl,0fdefh		;409d   ; 0xFDEF-0xFEAC a cero
	ld de,0fdf0h		;40a0
	ld bc,000bdh		;40a3
	ld (hl),a			;40a6
	ldir		;40a7
	call ganchos		;40a9   ; los ganchos
	jp programa		;40ac   ; al programa
ganchos:		; H.KEYI y 0xFE68 con "ret"; H.TIMI salta a la interrupcion (0x422E)
	ld a,0c9h		;40af   ; "ret"...
	ld (0fe68h),a		;40b1   ; ...en 0xFE68...
	ld (0fd9ah),a		;40b4   ; ...y en H.KEYI
	ld a,0c3h		;40b7   ; "jp"...
	ld hl,0422eh		;40b9   ; ...0x422E...
	ld (0fd9fh),a		;40bc   ; ...en H.TIMI
	ld (0fda0h),hl		;40bf
	ret			;40c2
slot_lee2:		; Dos bytes del slot C desde HL (RDSLT): en DE (el primero en E)
	call slot_lee		;40c3
	ld e,d			;40c6
slot_lee:		; Un byte del slot C desde HL (RDSLT), en D; HL + 1
	ld a,c			;40c7   ; el slot
	push bc			;40c8
	push de			;40c9
	call 0000ch		;40ca   ; RDSLT
	pop de			;40cd
	pop bc			;40ce
	ld d,a			;40cf
	inc hl			;40d0   ; el siguiente
	ret			;40d1
vram_prepara:		; La VRAM entera a cero, las letras y los dibujos fijos, el modo de pantalla, los sprites y el sonido; el teclado (0xFE14 = 3, 0xFE15 = 0x10) y la interrupcion del VDP encendida
	xor a			;40d2   ; desde 0...
	ld h,a			;40d3
	ld l,a			;40d4
	ld bc,04000h		;40d5   ; ...16 KB...
	call 00056h		;40d8   ; ...a cero (FILVRM)
	call letras_pon		;40db
	call cinta_para		;40de
	call pantalla_texto		;40e1
	call sprites_todos_fuera		;40e4
	call sprites_vacia		;40e7
	ld hl,0fe14h		;40ea
	ld (hl),003h		;40ed
	inc hl			;40ef
	ld (hl),010h		;40f0
	jp vdp_int_on		;40f2
letras_pon:		; Las casillas de 0x1C00 a cero, dos bytes 0xFF (0x1D49), 13 dibujos de 8 bytes desde 0xA881 cada 32 (desde 0x1C80), cuatro y cuatro mas y 0x60 bytes en 0x1F00
	ld hl,01c00h		;40f5
	ld bc,00400h		;40f8
	xor a			;40fb
	call 00056h		;40fc   ; FILVRM
	ld hl,01d49h		;40ff
	ld a,0ffh		;4102
	call 0004dh		;4104   ; WRTVRM
	ld a,0ffh		;4107
	inc hl			;4109
	call 0004dh		;410a   ; WRTVRM
	ld de,01c80h		;410d
	ld hl,0a881h		;4110
	ld b,00dh		;4113
letras_pon_uno:
	push bc			;4115
	ld bc,00008h		;4116   ; 8 bytes
	call ldirvm_mas		;4119   ; LDIRVM
	ex de,hl			;411c
	ld c,020h		;411d   ; cada 32
	add hl,bc			;411f
	ex de,hl			;4120
	pop bc			;4121
	djnz letras_pon_uno		;4122   ; los 13
	call cuatro_dibujos		;4124   ; cuatro mas
	call cuatro_dibujos		;4127   ; y cuatro
	ld bc,00060h		;412a   ; 0x60 bytes
	ld de,01f00h		;412d   ; en 0x1F00
	jp ldirvm_mas		;4130
cuatro_dibujos:		; Cuatro veces 8 bytes de HL a DE (DE + 8 cada vez); HL, 8 mas
	ld bc,00008h		;4133
	ld a,004h		;4136
cuatro_dibujos_uno:
	push af			;4138
	call ldirvm		;4139   ; LDIRVM
	ex de,hl			;413c
	add hl,bc			;413d   ; el siguiente
	ex de,hl			;413e
	pop af			;413f
	dec a			;4140   ; cuatro
	jr nz,cuatro_dibujos_uno		;4141
	add hl,bc			;4143   ; + 8
	ret			;4144

; ----------------------------------------------------------------------
; DATOS sin_uso_4145: 20 bytes con pinta de codigo (call 0x4177, ld
;   (0xFE0F),a, halt, call 0x0047, call 0x4A4D, jp 0x4B84) que nadie llama ni
;   salta: se buscaron sus direcciones en toda la ROM y los saltos relativos;
;   codigo muerto
;   0x4145..0x4159  (20 bytes)
DATA_sin_uso_4145:
	defb 0cdh,077h,041h,03eh,001h,032h,00fh,0feh,001h,005h,076h,0cdh,047h,000h,0cdh,04dh	; 4145  .wA>.2....v.G..M
	defb 04ah,0c3h,084h,04bh	; 4155

; ======================================================================
; CODIGO 0x4159..0x4474  (795 bytes)
; ======================================================================


todo_para:		; Los cursores fuera, la pantalla de texto y la cinta parada
	call cursores_quita		;4159
	call pantalla_texto		;415c
	jr cinta_para		;415f
pantalla_texto:		; Lo de 0x4BB6 (y, si da C, 0x4BC4), 0xFA1B y 0xFE0F a cero, la pantalla de texto y el registro 7 del VDP
	call texto_entra		;4161
	call c,texto_entra_va		;4164
	xor a			;4167
	ld (0fa1bh),a		;4168   ; en SCREEN 2?
	ld (0fe0fh),a		;416b
	call sprites_fuera_todos		;416e
	ld bc,07705h		;4171
	jp 0004dh		;4174   ; WRTVRM
cinta_para:		; TAPIOF: la cinta, parada
	call 000e7h		;4177   ; TAPIOF
	jr psg_cero		;417a
vdp_7:		; El registro 7 del VDP (el color del borde) = A
	push bc			;417c
	ld b,a			;417d
	ld c,007h		;417e   ; el registro 7
	call 00047h		;4180   ; WRTVDP
	pop bc			;4183
	ret			;4184
vdp_int_on:		; La interrupcion del VDP encendida (registro 1, bit 5)
	push bc			;4185
	ld bc,0ff20h		;4186   ; bit 5 a 1
	jr vdp_reg1		;4189
vdp_int_off:		; La interrupcion del VDP apagada (registro 1, bit 5 a 0)
	di			;418b   ; sin interrupciones
	push bc			;418c
	ld bc,0df00h		;418d   ; bit 5 a 0
vdp_reg1:
	push af			;4190
	ld a,(0f3e0h)		;4191   ; RG1SAV...
	and b			;4194   ; ...con B...
	or c			;4195   ; ...y C
	ld b,a			;4196
	ld c,001h		;4197   ; el registro 1
	call 00047h		;4199   ; WRTVDP
	call 0013eh		;419c   ; RDVDP: el estado leido
	pop af			;419f
	pop bc			;41a0
	ret			;41a1
ldirvm:		; LDIRVM guardando BC, DE y HL
	push bc			;41a2
	push de			;41a3
	push hl			;41a4
	call 0005ch		;41a5   ; LDIRVM
pops3:
	pop hl			;41a8
	pop de			;41a9
	pop bc			;41aa
	ret			;41ab
ldirmv:		; LDIRMV guardando BC, DE y HL
	push bc			;41ac
	push de			;41ad
	push hl			;41ae
	call 00059h		;41af   ; LDIRMV
	jr pops3		;41b2
ldirmv_mas:		; LDIRMV y DE + BC
	call ldirmv		;41b4
	ex de,hl			;41b7
	add hl,bc			;41b8
	ex de,hl			;41b9
	ret			;41ba
ldirvm_mas:		; LDIRVM y HL + BC
	call ldirvm		;41bb
	add hl,bc			;41be
	ret			;41bf
boton:		; GTTRIG A (0-4); 5 o mas: la tecla de la fila 7, bit 7 (RETURN): 0xFF pulsada
	cp 005h		;41c0   ; 0-4?
	jp c,000d8h		;41c2   ; GTTRIG
	push bc			;41c5
	ld a,007h		;41c6   ; la fila 7
	call 00141h		;41c8   ; SNSMAT
	pop bc			;41cb
	rlca			;41cc   ; el bit 7 (RETURN)
	ld a,0ffh		;41cd   ; 0: pulsada, 0xFF...
	adc a,000h		;41cf
	ret			;41d1
psg_callar:		; Los volumenes del PSG (registros 8-10) a 0
	ld a,008h		;41d2   ; el registro 8
	ld e,000h		;41d4
psg_callar_uno:
	call 00093h		;41d6   ; WRTPSG
	inc a			;41d9
	cp 00bh		;41da   ; hasta el 10
	jr nz,psg_callar_uno		;41dc
	ret			;41de
psg_cero:		; Los volumenes a 0 y el mezclador (registro 7) a 0xB8
	call psg_callar		;41df
	ld a,007h		;41e2
	ld e,0b8h		;41e4   ; 0xB8: tonos, sin ruido
	jp 00093h		;41e6   ; WRTPSG
fac2_cero:		; 0xFAC2 en adelante, 256 bytes a 0
	ld hl,0fac2h		;41e9
	ld b,000h		;41ec
	jp cero_b		;41ee
sprites_dibujos_cero:		; 0x80 bytes de la VRAM 0x1E80 a 0 (cuatro dibujos de sprite)
	ld hl,01e80h		;41f1
	ld bc,00080h		;41f4
	xor a			;41f7
	jp 00056h		;41f8   ; FILVRM
casillas_puntos:		; BC = cuantas casillas de puntos (0x71-0x73) hay en el mapa (0x210 bytes desde 0xF7ED; con tres fondos, el A; si no, desde 0xFBEC - 0x210)
	ld bc,00000h		;41fb   ; la cuenta a 0
	ld de,00210h		;41fe   ; un fondo
	ld hl,(0f7edh)		;4201   ; el principio del mapa
	and a			;4204   ; cual?
	jr nz,casillas_puntos_fondo		;4205
	ld a,(0f421h)		;4207   ; la clase de juego
	bit 3,a		;420a   ; tres fondos?
	jr nz,casillas_puntos_uno		;420c
	ex de,hl			;420e
	ld hl,(0fbech)		;420f   ; el final del mapa
	and a			;4212
	sbc hl,de		;4213
	ex de,hl			;4215
casillas_puntos_uno:
	ld a,(hl)			;4216
	sub 071h		;4217   ; 0x71...
	jr c,casillas_puntos_sig		;4219
	sub 003h		;421b   ; ...a 0x73?
	jr nc,casillas_puntos_sig		;421d
	inc bc			;421f   ; una mas
casillas_puntos_sig:
	inc hl			;4220   ; el siguiente
	dec de			;4221   ; uno menos
	ld a,d			;4222
	or e			;4223
	jr nz,casillas_puntos_uno		;4224   ; quedan
	ret			;4226
casillas_puntos_fondo:
	add hl,de			;4227
	dec a			;4228
	jr z,casillas_puntos_uno		;4229
	add hl,de			;422b
	jr casillas_puntos_uno		;422c
interrupcion:		; La interrupcion (H.TIMI): no vuelve a la BIOS; guarda el estado del VDP (0xF9FE), cuenta hacia atras 0xFA31, el sonido (0xA20C), 0xFE6F y 0xFE70; jugando (0xFA04), cada 3 cuadros la palanca (0xF9FB) y los botones; si no, el teclado; despues 0xFE68 y saca de la pila todo lo que guardo la BIOS
	di			;422e   ; sin interrupciones
	pop hl			;422f   ; fuera la vuelta a la BIOS
	and 020h		;4230   ; el estado del VDP: el bit 5 (choque de sprites)?
	jr z,interrupcion_reloj		;4232
	ld (0f9feh),a		;4234   ; guardado
interrupcion_reloj:
	ld hl,(0fa31h)		;4237   ; la cuenta de 0xFA31...
	dec hl			;423a   ; ...uno menos
	ld (0fa31h),hl		;423b   ; el reloj
	call sonido_interrupcion		;423e   ; el sonido
	ld hl,0fe6fh		;4241   ; 0xFE6F...
	ld a,(hl)			;4244
	and a			;4245
	jr z,interrupcion_cuenta		;4246
	dec (hl)			;4248   ; ...uno menos, si no es 0
interrupcion_cuenta:
	ld hl,0fe70h		;4249   ; 0xFE70 + 0x20...
	ld a,(hl)			;424c
	add a,020h		;424d
	ld (hl),a			;424f
	jr nc,interrupcion_mandos		;4250   ; sin acarreo: nada
	inc (hl)			;4252   ; + 1 abajo
	and 00fh		;4253
	cp 005h		;4255   ; 5?
	jr nz,interrupcion_mandos		;4257
	ld (hl),001h		;4259   ; vuelve a 1
interrupcion_mandos:
	ld a,(0fa04h)		;425b   ; jugando?
	and a			;425e
	jr z,interrupcion_teclado		;425f   ; no: el teclado
	ld hl,0fe14h		;4261   ; cada 3 cuadros
	dec (hl)			;4264
	jr nz,interrupcion_fin		;4265
	ld (hl),003h		;4267   ; otra vez 3
	xor a			;4269   ; GTSTCK 0: los cursores...
	call 000d5h		;426a   ; GTSTCK
	and a			;426d
	jr nz,interrupcion_palanca		;426e   ; ...o...
	ld a,001h		;4270   ; ...el mando 1...
	call 000d5h		;4272   ; GTSTCK
	and a			;4275
	jr nz,interrupcion_palanca		;4276
	ld a,002h		;4278   ; ...o el 2
	call 000d5h		;427a   ; GTSTCK
	and a			;427d
interrupcion_palanca:
	ld (0f9fbh),a		;427e   ; la palanca
	ld bc,00300h		;4281   ; tres botones
	ld hl,0fe15h		;4284   ; la cuenta de 0xFE15
	dec (hl)			;4287
	jr nz,interrupcion_tecla		;4288
	ld (hl),001h		;428a
	ld hl,0f9fch		;428c   ; los botones de 0, 1, 2 en 0xF9FC
interrupcion_boton:
	ld a,c			;428f
	push bc			;4290
	call boton		;4291   ; pulsado?
	pop bc			;4294
	and a			;4295
	jr z,interrupcion_boton_sig		;4296   ; no
	ld a,003h		;4298   ; si: 3 cuadros...
	ld (0fe15h),a		;429a   ; la espera del teclado
	set 0,(hl)		;429d   ; ...y apuntado
interrupcion_boton_sig:
	inc c			;429f
	djnz interrupcion_boton		;42a0
	ld b,c			;42a2
	ld hl,0f9fdh		;42a3   ; los de 3, 4, 5 en 0xF9FD
interrupcion_boton2:
	ld a,c			;42a6
	push bc			;42a7
	call boton		;42a8
	pop bc			;42ab
	and a			;42ac
	jr z,interrupcion_boton2_sig		;42ad
	ld a,003h		;42af
	ld (0fe15h),a		;42b1   ; la espera del teclado
	set 0,(hl)		;42b4
interrupcion_boton2_sig:
	inc c			;42b6
	djnz interrupcion_boton2		;42b7
interrupcion_tecla:
	call stop_mira		;42b9   ; STOP?
	jr interrupcion_fin		;42bc
interrupcion_teclado:
	call teclado_cada3		;42be   ; el teclado
	call parpadeo		;42c1
interrupcion_fin:
	call 0fe68h		;42c4   ; el gancho 0xFE68
	pop ix		;42c7   ; lo que guardo la BIOS, fuera
	pop iy		;42c9
	pop af			;42cb
	pop bc			;42cc
	pop de			;42cd
	pop hl			;42ce
	ex af,af'			;42cf
	exx			;42d0
	pop af			;42d1
	pop bc			;42d2
	pop de			;42d3
	pop hl			;42d4
	ei			;42d5   ; con interrupciones
	ret			;42d6   ; de vuelta al programa
teclado_cada3:		; Cada 3 cuadros (0xFE14): STOP y el teclado
	ld hl,0fe14h		;42d7   ; la cuenta
	dec (hl)			;42da   ; uno menos
	ret nz			;42db   ; todavia no
	ld (hl),003h		;42dc   ; otra vez 3
	call stop_mira		;42de   ; STOP?
	jr nz,teclado		;42e1   ; no: el teclado
	ret			;42e3
stop_mira:		; STOP solo (la fila 7 = 0xEF) en cuatro lecturas seguidas: 0xFA06 = 0xFF
	ld b,004h		;42e4   ; cuatro veces
stop_mira_uno:
	ld a,007h		;42e6   ; la fila 7
	call 00141h		;42e8   ; SNSMAT
	add a,011h		;42eb   ; solo STOP? (0xEF + 0x11 = 0)
	ret nz			;42ed   ; no
	djnz stop_mira_uno		;42ee
	ld a,0ffh		;42f0   ; si: 0xFA06 = 0xFF
	ld (0fa06h),a		;42f2   ; STOP
	ret			;42f5
teclado:		; El teclado: si cambia (0x4312), cada tanto (0xFE15) las teclas pulsadas pasan a codigos (0x436B)
	call teclado_lee		;42f6   ; las filas y palancas
	ret nz			;42f9   ; cambian
	ld hl,0fe15h		;42fa
	dec (hl)			;42fd   ; la espera
	ret nz			;42fe
	ld (hl),001h		;42ff   ; otra vez 1
	ld hl,0fe16h		;4301   ; las filas de antes
	ld b,00bh		;4304   ; 11
	ld a,0ffh		;4306   ; sin pulsar
	call llena_b		;4308
	ld b,004h		;430b   ; 4 mas
	call cero_b		;430d   ; a 0
	jr teclado_codigos		;4310   ; los codigos
teclado_lee:		; Las palancas 0-2 (0xFE30), los botones 0-5 (bits de 0xFE33) y las 11 filas del teclado (0xFE25, por los puertos 0xAA y 0xA9); si alguna cambia, 0xFE15 = 16
	xor a			;4312
	ld hl,0fe30h		;4313   ; las palancas
teclado_palanca:
	push af			;4316
	push hl			;4317
	call 000d5h		;4318   ; GTSTCK
	pop hl			;431b
	ld (hl),a			;431c
	pop af			;431d
	inc hl			;431e
	inc a			;431f
	cp 003h		;4320
	jr nz,teclado_palanca		;4322
	push hl			;4324
	ld bc,00600h		;4325   ; seis botones
teclado_boton:
	push bc			;4328
	ld a,b			;4329
	dec a			;432a
	call boton		;432b   ; pulsado?
	pop bc			;432e
	add a,a			;432f
	rr c		;4330   ; su bit
	djnz teclado_boton		;4332
	pop hl			;4334
	ld (hl),c			;4335   ; apuntados
	ld a,(0fa04h)		;4336   ; jugando?
	and a			;4339
	jr nz,teclado_filas		;433a
	xor a			;433c   ; no: sin el mando 2
	ld (0fe32h),a		;433d
teclado_filas:
	in a,(0aah)		;4340   ; el puerto C del PPI...
	and 0f0h		;4342   ; ...sin la fila
	ld c,a			;4344
	ld b,00bh		;4345   ; 11 filas
	ld hl,0fe25h		;4347   ; a 0xFE25
teclado_fila:
	ld a,c			;434a
	out (0aah),a		;434b   ; la fila
	in a,(0a9h)		;434d   ; sus teclas
	ld (hl),a			;434f   ; apuntadas
	inc c			;4350
	inc hl			;4351
	djnz teclado_fila		;4352
	ld hl,0fe25h		;4354   ; contra las de antes (0xFE16)
	ld de,0fe16h		;4357
	ld b,00fh		;435a
teclado_compara:
	ld a,(de)			;435c   ; la de antes...
	cp (hl)			;435d   ; ...igual?
	jr nz,teclado_cambia		;435e
	inc de			;4360
	inc hl			;4361
	djnz teclado_compara		;4362   ; las 15
	jr teclado_codigos		;4364   ; iguales
teclado_cambia:
	ld a,010h		;4366   ; distinta: 16 cuadros
	ld (0fe15h),a		;4368   ; la espera del teclado
teclado_codigos:		; Las teclas pulsadas, a sus codigos (las tablas de 0x44C6 o 0x4474, la segunda con 0xFA1C distinto de 0x10); con CODE (0xFE13) y SHIFT o GRAPH otra columna; los cambios de las palancas a codigos de cursor (0x450E)
	ld e,002h		;436b
	ld c,008h		;436d
	ld a,003h		;436f
	ld hl,0fe25h		;4371
teclado_codigos_va:
	ld b,008h		;4374
teclado_codigos_code:
	ld d,(hl)			;4376
teclado_codigos_mira:
	rr d		;4377
	ccf			;4379
	sbc a,000h		;437a
	ret z			;437c
	djnz teclado_codigos_mira		;437d
	inc hl			;437f
	dec c			;4380
	jr nz,teclado_codigos_va		;4381
	dec e			;4383
	ld bc,00401h		;4384
	jr nz,teclado_codigos_code		;4387
	ld hl,044c6h		;4389   ; la tabla con 0xFA1C = 0x10
	ld a,(0fe2dh)		;438c
	push af			;438f
	ld a,(0fa1ch)		;4390   ; la clase de eleccion
	cp 010h		;4393
	jr z,teclado_codigos_fin		;4395
	ld hl,04474h		;4397   ; si no, la otra
teclado_codigos_fin:
	ld (0fe11h),hl		;439a   ; apuntada
	ld a,(0fe13h)		;439d   ; con escritura
	and a			;43a0
	ld a,(0fe33h)		;43a1   ; la tecla CODE...
	jr z,teclado_columna		;43a4
	ld c,020h		;43a6   ; con CODE: la columna 0x20...
	bit 6,a		;43a8   ; ...SHIFT?
	jr nz,teclado_palancas		;43aa
	ld c,028h		;43ac   ; ...0x28 con GRAPH
	rlca			;43ae
	jr c,teclado_palancas		;43af
	ld hl,0fe2dh		;43b1   ; sin las dos: 0xFE2D bit 0
	set 0,(hl)		;43b4
teclado_columna:
	ld c,018h		;43b6   ; la columna 0x18...
	ld a,(0fe2bh)		;43b8   ; ...SHIFT (0xFE2B bit 0)?
	rrca			;43bb
	jr nc,teclado_palancas		;43bc
	ld c,030h		;43be   ; ...0x30
	rrca			;43c0
	jr nc,teclado_palancas		;43c1
	ld c,010h		;43c3   ; ...0x10
teclado_palancas:		; Las palancas que cambian (0xFE31/0xFE22, 0xFE30/0xFE21, 0xFE32/0xFE23): su direccion - 1 con la columna, al buffer (0x450E)
	ld hl,0fe22h		;43c5   ; la palanca de antes...
	ld de,0fe31h		;43c8   ; ...y la de ahora
	ld a,(de)			;43cb
	cp (hl)			;43cc   ; cambia?
	ld (hl),a			;43cd   ; guardada
	jr z,teclado_palanca0		;43ce
	and a			;43d0   ; suelta?
	jr z,teclado_palanca0		;43d1
	dec a			;43d3   ; la direccion - 1...
	or c			;43d4   ; ...con la columna...
	or 080h		;43d5   ; ...y el bit 7
	call buffer_pon		;43d7   ; al buffer
teclado_palanca0:
	dec hl			;43da
	dec de			;43db
	ld a,(de)			;43dc   ; la palanca 0
	cp (hl)			;43dd
	ld (hl),a			;43de
	jr z,teclado_palanca2		;43df
	and a			;43e1
	jr z,teclado_palanca2		;43e2
	dec a			;43e4
	or c			;43e5
	call buffer_pon		;43e6   ; al buffer
teclado_palanca2:
	inc hl			;43e9
	inc hl			;43ea
	inc de			;43eb
	inc de			;43ec
	ld a,(de)			;43ed   ; la palanca 2
	cp (hl)			;43ee
	ld (hl),a			;43ef
	jr z,teclado_botones		;43f0
	sub 001h		;43f2
	jr c,teclado_botones		;43f4
	or 0d0h		;43f6   ; 0xD0 + direccion
	call buffer_pon		;43f8   ; al buffer
teclado_botones:		; Los botones que cambian (0xFE33 contra 0xFE24): 0x8E, 0xCE, 0x8F y 0xCF al buffer
	ld hl,0fe24h		;43fb   ; los de antes
	ld a,(0fe33h)		;43fe   ; los de ahora
	cp (hl)			;4401   ; iguales?
	ld (hl),a			;4402   ; guardados
	jr z,teclado_filas_nuevas		;4403
	add a,a			;4405
	and 0f0h		;4406
	add a,a			;4408
	ld b,a			;4409
	ld a,08eh		;440a   ; el boton 1: 0x8E
	call c,buffer_pon		;440c
	sla b		;440f
	ld a,0ceh		;4411   ; el 2: 0xCE
	call c,buffer_pon		;4413
	sla b		;4416
	ld a,08fh		;4418   ; el 3: 0x8F
	call c,buffer_pon		;441a
	sla b		;441d
	ld a,0cfh		;441f   ; el 4: 0xCF
	call c,buffer_pon		;4421
teclado_filas_nuevas:		; Las 11 filas: las teclas recien pulsadas de cada una (bit a 0 ahora y a 1 antes) a codigos (0x4448)
	ld b,00bh		;4424   ; 11 filas
	ld hl,0fe16h		;4426   ; las de antes
	ld de,0fe25h		;4429   ; las de ahora
teclado_fila_nueva:
	ld a,(de)			;442c   ; la de ahora...
	ld c,a			;442d
	xor (hl)			;442e   ; ...las que cambian...
	and (hl)			;442f   ; ...y estaban sueltas: recien pulsadas
	ld (hl),c			;4430   ; guardada
	call nz,tecla_fila		;4431   ; alguna: a codigos
	inc de			;4434
	inc hl			;4435
	djnz teclado_fila_nueva		;4436
	pop af			;4438   ; las teclas de antes...
	ld (0fe1eh),a		;4439   ; ...guardadas
	ld (0fe2dh),a		;443c
	ld hl,(0fe37h)		;443f   ; el buffer: donde se escribe...
	ld de,(0fe39h)		;4442   ; ...y donde se lee
	rst 20h			;4446   ; iguales: Z (vacio)
	ret			;4447
tecla_fila:		; Las 8 teclas de una fila (A, sus bits recien pulsados): su numero (fila x 8 + bit) a la tabla del teclado (0x4465)
	push bc			;4448
	push de			;4449
	push hl			;444a
	push af			;444b
	ld a,00bh		;444c   ; 11 - las que quedan: la fila
	sub b			;444e
	add a,a			;444f   ; x 8
	add a,a			;4450
	add a,a			;4451
	ld c,a			;4452
	ld b,008h		;4453   ; 8 bits
	pop af			;4455
tecla_bit:
	rra			;4456   ; el bit siguiente
	push bc			;4457
	push af			;4458
	call c,tecla_codigo		;4459   ; pulsada: su codigo
	pop af			;445c
	pop bc			;445d
	inc c			;445e   ; la tecla siguiente
	djnz tecla_bit		;445f
	pop hl			;4461
	pop de			;4462
	pop bc			;4463
tecla_codigo_fin:
	ret			;4464
tecla_codigo:		; La tecla C en la tabla del teclado (0xFE11): pares de umbral y rutina; la primera con el umbral mayor que C (salta con "ret")
	ld hl,(0fe11h)		;4465   ; la tabla
	ld a,c			;4468
tecla_codigo_mira:
	cp (hl)			;4469   ; por debajo del umbral?
	inc hl			;446a
	ld e,(hl)			;446b   ; la rutina...
	inc hl			;446c
	ld d,(hl)			;446d
	inc hl			;446e
	push de			;446f   ; ...a la pila
	ret c			;4470   ; si: a ella (ret)
	pop de			;4471   ; no: la siguiente
	jr tecla_codigo_mira		;4472

; ----------------------------------------------------------------------
; DATOS teclado_tabla_a: La tabla del teclado con 0xFA1C distinto de 0x10:
;   umbral (el numero de tecla) y rutina, hasta 0xFF
;   0x4474..0x448f  (27 bytes)
DATA_teclado_tabla_a:
	defb 001h,08fh,044h,009h,097h,044h,00ah,093h,044h,016h,064h,044h,035h,0deh,044h,036h	; 4474  ..D..D..D.dD5.D6
	defb 061h,045h,041h,0deh,044h,042h,006h,045h,0ffh,064h,044h	; 4484  aEA.DB.E.dD

; ======================================================================
; CODIGO 0x448f..0x449b  (12 bytes)
; ======================================================================


tecla_fila0:		; Las teclas 0-7 (los numeros): + 0x30
	ld a,00ch		;448f
	jr tecla_letra_va		;4491
tecla_numero_va:
	ld a,00bh		;4493
	jr tecla_letra_va		;4495
tecla_letra:
	add a,037h		;4497   ; + 0x37
tecla_letra_va:
	jr $+117		;4499

; ----------------------------------------------------------------------
; DATOS teclado_numeros: Los codigos de las teclas, por su numero (0x4485 + n
;   y 0x44C5 + n), y la tabla del teclado con 0xFA1C = 0x10 (0x44C6)
;   0x449b..0x44de  (67 bytes)
DATA_teclado_numeros:
	defb 069h,000h,000h,066h,062h,06bh,06ah,06dh,060h,06eh,06fh,000h,000h,000h,000h,000h	; 449b  i..fbkjm`no.....
	defb 061h,06ch,068h,067h,064h,000h,063h,000h,065h,000h,000h,000h,000h,000h,000h,000h	; 44ab  alhgd.c.e.......
	defb 008h,009h,00ah,00dh,000h,000h,000h,006h,000h,00fh,00eh,00ah,0f2h,044h,012h,064h	; 44bb  .............D.d
	defb 044h,013h,0f6h,044h,016h,064h,044h,030h,0eeh,044h,035h,064h,044h,041h,0e3h,044h	; 44cb  D..D.dD0.D5dDA.D
	defb 0ffh,064h,044h	; 44db

; ======================================================================
; CODIGO 0x44de..0x44fa  (28 bytes)
; ======================================================================


tecla_tabla1:		; El codigo de la tecla en la tabla de 0x4485 + n
	ld hl,04485h		;44de
	jr tecla_tabla		;44e1
tecla_tabla2:		; El codigo de la tecla en la tabla de 0x44C5 + n
	ld hl,044c5h		;44e3
tecla_tabla:
	call hl_mas_a		;44e6   ; + la tecla
	ld a,(hl)			;44e9   ; su codigo
	and a			;44ea   ; ninguno?
	ret z			;44eb   ; nada
	jr $+34		;44ec   ; al buffer
tecla_mas2b:
	add a,02bh		;44ee   ; + 0x2B
	jr $+30		;44f0
tecla_mas30:
	add a,030h		;44f2   ; + 0x30
tecla_al_buffer:
	jr $+26		;44f4
tecla_2c:
	ld a,02ch		;44f6   ; 0x2C
	jr tecla_al_buffer		;44f8

; ----------------------------------------------------------------------
; DATOS teclado_codigos2: Mas codigos de tecla
;   0x44fa..0x4506  (12 bytes)
DATA_teclado_codigos2:
	defb 007h,008h,009h,00ah,00dh,000h,000h,000h,006h,000h,00fh,020h	; 44fa  ........... 

; ======================================================================
; CODIGO 0x4506..0x4644  (318 bytes)
; ======================================================================


tecla_stop:		; La tecla de la pausa: si 0xFE2B bit 1 no esta, el codigo 5
	ld a,(0fe2bh)		;4506   ; CTRL?
	bit 1,a		;4509
	ret nz			;450b
	ld a,005h		;450c   ; el codigo 5
buffer_pon:		; Un codigo (A) al buffer del teclado (0xFE3B-0xFE5A, 0xFE37 donde se escribe): con CODE, el 0x0E solo si 0xFBD1; pasa por 0x9AF7 antes
	push hl			;450e
	ld h,a			;450f
	ld a,(0fe13h)		;4510   ; CODE?
	and a			;4513
	ld a,h			;4514
	pop hl			;4515
	jr z,buffer_pon_va		;4516   ; no
	cp 00eh		;4518   ; 0x0E?
	jr nz,buffer_pon_va		;451a
	ld a,(0fbd1h)		;451c   ; 0xFBD1?
	and a			;451f
	ret z			;4520   ; no: nada
	ld a,00eh		;4521
buffer_pon_va:
	call tecla_clic		;4523   ; el codigo, por 0x9AF7
buffer_pon_mira:
	push de			;4526
	push hl			;4527
	ld hl,(0fe37h)		;4528   ; donde se escribe
	ld (hl),a			;452b   ; el codigo
	inc hl			;452c
	ld de,0fe5bh		;452d   ; el final del buffer?
	rst 20h			;4530   ; DCOMPR
	jr nz,buffer_pon_lleno		;4531
	ld hl,0fe3bh		;4533   ; si: al principio
buffer_pon_lleno:
	ld de,(0fe39h)		;4536   ; donde se lee
	rst 20h			;453a   ; lleno?
	jr z,buffer_fin		;453b   ; si: se pierde
	ld (0fe37h),hl		;453d   ; si no, apuntado
	jr buffer_fin		;4540
buffer_saca:		; El codigo siguiente del buffer del teclado (Z si esta vacio)
	push de			;4542
	push hl			;4543
	ld hl,(0fe39h)		;4544   ; donde se lee...
	ld de,(0fe37h)		;4547   ; ...y donde se escribe
	rst 20h			;454b   ; vacio?
	jr z,buffer_fin		;454c   ; si: Z
	ld a,(hl)			;454e   ; el codigo
	push af			;454f
	inc hl			;4550   ; el siguiente
	ld de,0fe5bh		;4551
	rst 20h			;4554   ; el final?
	jr nz,buffer_saca_va		;4555
	ld hl,0fe3bh		;4557   ; si: al principio
buffer_saca_va:
	ld (0fe39h),hl		;455a   ; apuntado
	pop af			;455d
buffer_fin:
	pop hl			;455e
	pop de			;455f
	ret			;4560
buffer_vacia:		; El buffer vacio; con 0xFE10, el codigo 0x0F (dos si 0xFE6D = 0x0404) y despues el 7
	ld hl,0fe3bh		;4561   ; el principio...
	ld (0fe39h),hl		;4564   ; ...donde se lee...
	ld (0fe37h),hl		;4567   ; ...y donde se escribe
	ld a,(0fe10h)		;456a   ; 0xFE10?
	and a			;456d
	jr z,buffer_vacia_7		;456e   ; no
	ld hl,(0fe6dh)		;4570   ; 0xFE6D y 0xFE6E...
	ld de,00404h		;4573   ; ...4 y 4?
	rst 20h			;4576   ; DCOMPR
	ld a,00fh		;4577
	jr nz,buffer_vacia_0f		;4579
	call buffer_pon_mira		;457b   ; si: un 0x0F mas
	ld a,00fh		;457e
buffer_vacia_0f:
	call buffer_pon_mira		;4580   ; el 0x0F
buffer_vacia_7:
	ld a,007h		;4583   ; el 7
	jr buffer_pon		;4585
cartucho_cp:		; Busca otro cartucho con "AB" en 0x4000 o 0x8000 y "CP", 0xED00 y una direccion en +0x10: si esta, llama a esa direccion en su slot (CALSLT) y vuelve con NC; si no, C
	di			;4587   ; sin interrupciones
	ld de,0fcc1h		;4588   ; EXPTBL
	ld c,000h		;458b   ; el slot 0
cartucho_cp_slot:
	ld a,(de)			;458d   ; con su bit de expandido
	or c			;458e
	ld c,a			;458f
cartucho_cp_mira:
	push de			;4590
	ld hl,04000h		;4591   ; en 0x4000...
	call slot_lee2		;4594   ; ...dos bytes
	push hl			;4597
	ld hl,04241h		;4598   ; "AB"?
	rst 20h			;459b   ; DCOMPR
	pop hl			;459c
	call z,cartucho_cp_cabecera		;459d   ; si: mira el resto
	pop de			;45a0
	ret z			;45a1   ; hallado
	push de			;45a2
	ld hl,08000h		;45a3   ; en 0x8000
	call slot_lee2		;45a6
	push hl			;45a9
	ld hl,04241h		;45aa   ; "AB"?
	rst 20h			;45ad   ; DCOMPR
	pop hl			;45ae
	call z,cartucho_cp_cabecera		;45af
	pop de			;45b2
	ret z			;45b3   ; hallado
	ld a,c			;45b4   ; expandido?
	and a			;45b5
	jp p,cartucho_cp_sig		;45b6   ; no
	add a,004h		;45b9   ; el subslot siguiente
	ld c,a			;45bb
	cp 090h		;45bc
	jr c,cartucho_cp_mira		;45be
cartucho_cp_sig:
	inc de			;45c0   ; el slot siguiente
	inc c			;45c1
	ld a,c			;45c2
	cp 004h		;45c3   ; los cuatro?
	jr c,cartucho_cp_slot		;45c5
	scf			;45c7   ; ninguno: C
	ei			;45c8
	ret			;45c9
cartucho_cp_cabecera:
	ld l,010h		;45ca   ; en +0x10...
	call slot_lee2		;45cc
	push hl			;45cf
	ld hl,05043h		;45d0   ; ..."CP"?
	rst 20h			;45d3   ; DCOMPR
	pop hl			;45d4
	ret nz			;45d5   ; no
	call slot_lee2		;45d6
	push hl			;45d9
	ld hl,0ed00h		;45da   ; 0xED00?
	rst 20h			;45dd   ; DCOMPR
	pop hl			;45de
	ret nz			;45df   ; no
	call slot_lee2		;45e0   ; la direccion
	ld a,c			;45e3   ; IY: el slot
	push af			;45e4
	pop iy		;45e5
	push de			;45e7   ; IX: la direccion
	pop ix		;45e8
	call vdp_int_off		;45ea   ; sin la interrupcion del VDP
	call 0001ch		;45ed   ; CALSLT
	call vdp_int_on		;45f0   ; con ella otra vez
	xor a			;45f3   ; NC: hecho
	ei			;45f4
	ret			;45f5
cursores_pon:		; Los cursores del editor otra vez en pantalla: sin parpadeo (0xFE5D), lo de 0x6746, la cuenta del parpadeo a 10; con 0xFE5E, las Y de los cuatro sprites del objeto (desde 0x61F1) a 0xFE64; despues los cursores que pide 0xFE5F (bits 7-3, la tabla de 0x4644) y el parpadeo encendido (0xFE5B)
	di			;45f6   ; sin interrupciones
	xor a			;45f7   ; el paso del parpadeo a 0
	ld (0fe5dh),a		;45f8   ; el parpadeo
	call copia_marca		;45fb
	ld a,00ah		;45fe   ; 10 cuadros...
	ld (0fe5ch),a		;4600   ; ...la cuenta del parpadeo
	ld a,(0fe5eh)		;4603   ; 0xFE5E?
	and a			;4606
	jr z,cursores_cuales		;4607   ; no
	push af			;4609
	call muestra_color		;460a   ; su sitio en la VRAM
	ld b,004h		;460d   ; cuatro sprites
	ld de,0fe64h		;460f   ; a 0xFE64
cursores_y:
	call 0004ah		;4612   ; RDVRM: su Y
	ld (de),a			;4615   ; guardada
	inc de			;4616
	inc hl			;4617   ; el siguiente (+4)
	inc hl			;4618
	inc hl			;4619
	inc hl			;461a
	djnz cursores_y		;461b
	call parpadeo_reinicia		;461d   ; el parpadeo, desde el principio
	pop af			;4620
	ld (0fe5eh),a		;4621   ; el parpadeo del personaje
cursores_cuales:
	ld a,(0fe5fh)		;4624   ; los cursores pedidos (bits 7-3)
	and 0f8h		;4627
	jr z,cursores_fin		;4629   ; ninguno
	ld hl,04644h		;462b   ; la tabla de 0x4644
cursores_bit:
	add a,a			;462e   ; el bit siguiente
	jr nc,cursores_sig		;462f   ; a 0: el siguiente
	push af			;4631
	push hl			;4632
	xor a			;4633   ; su rutina
	call salta_tabla		;4634
	pop hl			;4637
	pop af			;4638
cursores_sig:
	inc hl			;4639   ; la rutina siguiente
	inc hl			;463a
	jr nz,cursores_bit		;463b   ; quedan bits
cursores_fin:
	ld a,0ffh		;463d   ; el parpadeo encendido
	ld (0fe5bh),a		;463f
	ei			;4642   ; con interrupciones
	ret			;4643

; ----------------------------------------------------------------------
; DATOS cursores_tabla: Las rutinas de los cursores por los bits 7-3 de
;   0xFE5F: 0x464E, 0x46BA, 0x46AE, 0x468C y 0x4664
;   0x4644..0x464e  (10 bytes)
DATA_cursores_tabla:
	defb 04eh,046h,0bah,046h,0aeh,046h,08ch,046h,064h,046h	; 4644  NF.F.F.FdF

; ======================================================================
; CODIGO 0x464e..0x4707  (185 bytes)
; ======================================================================


cursor_linea:		; El sprite 0x2B en la fila de 0xFBC5 (x 8, + 8) y de color 15
	ld c,02bh		;464e   ; el sprite 0x2B
	ld hl,(0fbc5h)		;4650   ; la fila (0xFBC5)...
	push bc			;4653
	add hl,hl			;4654   ; ...x 8...
	add hl,hl			;4655
	add hl,hl			;4656
	ld de,00008h		;4657   ; ...+ 8
	add hl,de			;465a
	pop bc			;465b
cursor_pon_15:
	call sprite_xy		;465c   ; en su sitio
	ld a,00fh		;465f   ; color 15
	jp sprite_color		;4661
cursor_casilla:		; El sprite 0x2C en la casilla de 0xFBC3 (columna y fila dentro de su cuadro de 8 x 8, desde la 0x17 y la 0x10); con 0xFE6C 3 o mas, el de 0x6BCF
	ld a,(0fe6ch)		;4664   ; 0xFE6C...
	cp 003h		;4667   ; ...menos de 3?
	jr c,cursor_casilla_va		;4669
	jp rejilla_cursor		;466b   ; si no, el otro
cursor_casilla_va:
	ld hl,(0fbc3h)		;466e   ; la casilla (0xFBC3)
	ld a,007h		;4671   ; la fila (0-7)...
	and h			;4673
	add a,010h		;4674   ; ...+ 0x10
	ld h,a			;4676
	ld a,007h		;4677   ; la columna (0-7)...
	and l			;4679
	add a,017h		;467a   ; ...+ 0x17
	ld l,a			;467c
	ld c,02ch		;467d   ; el sprite 0x2C
cursor_por8:
	add hl,hl			;467f   ; x 8: en pixeles
	add hl,hl			;4680
	add hl,hl			;4681
	jr cursor_pon_15		;4682
cursor_dos_b:		; Los sprites 0x2F y 0x30 en la posicion de 0xFBCB
	ld hl,(0fbcbh)		;4684   ; la posicion
	ld bc,0302fh		;4687   ; los sprites 0x30 y 0x2F
	jr cursor_dos_va		;468a
cursor_dos:		; Los sprites 0x2D y 0x2E en la posicion de 0xFBC3 (+8 - 4 en X e Y): el primero de color 15, el segundo de color 1
	ld hl,(0fbc3h)		;468c   ; la posicion
	ld bc,02e2dh		;468f   ; los sprites 0x2E y 0x2D
cursor_dos_va:
	push bc			;4692
	ld de,00008h		;4693   ; + 8...
	add hl,de			;4696
	ld de,00404h		;4697   ; ...- 4 en las dos
	and a			;469a
	sbc hl,de		;469b
	pop bc			;469d
	push bc			;469e
	push hl			;469f
	call cursor_pon_15		;46a0   ; el primero, color 15
	pop hl			;46a3
	pop bc			;46a4
	ld c,b			;46a5   ; el segundo
	call sprite_xy		;46a6   ; en su sitio
	ld a,001h		;46a9   ; color 1
	jp sprite_color		;46ab
cursor_lista:		; El sprite 0x2A en la fila de 0xFBF8 (x 2 + 0x17, x 8)
	ld hl,(0fbf8h)		;46ae   ; la fila
	ld de,00017h		;46b1
	add hl,hl			;46b4
	add hl,de			;46b5
	ld c,02ah		;46b6   ; el sprite 0x2A
	jr cursor_por8		;46b8
cursor_otro:		; Lo de 0x6A9D con A = 0xFF
	ld a,0ffh		;46ba   ; 0xFF
	or 0afh		;46bc
	jp muestra_marca		;46be
cursores_fuera:		; Los sprites 0x2F y 0x30 fuera (Y 0xC1)
	ld c,02fh		;46c1   ; el 0x2F
	ld a,0c1h		;46c3   ; fuera
	call sprite_y		;46c5
	ld c,030h		;46c8   ; el 0x30
sprite_fuera:		; El sprite C fuera (Y 0xC1)
	ld a,0c1h		;46ca   ; Y 0xC1
	jp sprite_y		;46cc
cursores_quita:		; Los cursores fuera: sin parpadeo, lo de 0x6747; con 0xFE5E, sus Y de vuelta (0x470C) y, con el bit 3 de 0xFE5F, 0x6BD0; si no, los sprites 0x2B-0x2E y 0x2A fuera (0x4707); con el bit 6, 0x46BD
	di			;46cf   ; sin interrupciones
	xor a			;46d0   ; el parpadeo apagado
	ld (0fe5bh),a		;46d1
	ld (0fe5dh),a		;46d4   ; el parpadeo
	call copia_marca_borra		;46d7
	ld a,(0fe5eh)		;46da   ; 0xFE5E?
	and a			;46dd
	jr z,cursores_quita_lista		;46de   ; no
	call parpadeo_reinicia		;46e0   ; las Y de vuelta
	ld a,(0fe5fh)		;46e3   ; el bit 3 de 0xFE5F?
	bit 3,a		;46e6
	call nz,rejilla_cursor_quita		;46e8
	jr cursores_quita_fin		;46eb
cursores_quita_lista:
	ld hl,04707h		;46ed   ; los sprites de 0x4707...
	ld b,005h		;46f0   ; ...cinco
cursores_quita_uno:
	push hl			;46f2
	push bc			;46f3
	ld c,(hl)			;46f4   ; su numero
	call sprite_fuera		;46f5   ; fuera
	pop bc			;46f8
	pop hl			;46f9
	inc hl			;46fa
	djnz cursores_quita_uno		;46fb
cursores_quita_fin:
	ld a,(0fe5fh)		;46fd   ; el bit 6 de 0xFE5F?
	bit 6,a		;4700
	call nz,cursor_otro_va		;4702
	ei			;4705   ; con interrupciones
	ret			;4706

; ----------------------------------------------------------------------
; DATOS cursores_sprites: Los cinco sprites de los cursores: 0x2B, 0x2C, 0x2D,
;   0x2E y 0x2A
;   0x4707..0x470c  (5 bytes)
DATA_cursores_sprites:
	defb 02bh,02ch,02dh,02eh,02ah	; 4707

; ======================================================================
; CODIGO 0x470c..0x47c8  (188 bytes)
; ======================================================================


parpadeo_reinicia:		; El paso del parpadeo a 0 y a pintar
	xor a			;470c   ; el paso a 0
	ld (0fe5dh),a		;470d   ; el parpadeo
	jr parpadeo_objeto		;4710
parpadeo:		; Cada cuadro, desde la interrupcion: con el parpadeo encendido, cada 10 cuadros (0xFE5C) un paso: los sprites del objeto (0xFE5E) se alternan con sus colores (los cuatro de la paleta de 0xFC49 en 0xFDEF) o, sin objeto, los cursores cambian de color (15 y 1)
	ld a,(0fe5bh)		;4712   ; encendido?
	and a			;4715
	ret z			;4716   ; no
	ld hl,0fe5ch		;4717   ; la cuenta...
	dec (hl)			;471a   ; ...uno menos
	ret nz			;471b
	ld (hl),00ah		;471c   ; otra vez 10
	ld a,(0fe5eh)		;471e   ; 0xFE5E?
	sub 001h		;4721
	jp c,parpadeo_cursores		;4723   ; no: los cursores
parpadeo_objeto:
	ld a,0c4h		;4726   ; el sprite 0xC4 (el primero del objeto)
	push af			;4728
	ld a,(0fc49h)		;4729   ; el color de fondo (0xFC49)...
	and 007h		;472c   ; ...0-7...
	add a,a			;472e   ; ...x 4
	add a,a			;472f
	ld b,a			;4730
	add a,020h		;4731   ; + 0x20
	ld c,a			;4733
	ld a,b			;4734
	ld hl,0fdefh		;4735   ; los colores de 0xFDEF
	push bc			;4738
	call hl_mas_a		;4739   ; + el de fondo x 4
	ld de,0fe60h		;473c   ; a 0xFE60
	ld bc,00004h		;473f   ; cuatro
	ldir		;4742
	pop bc			;4744
	ld de,0fe64h		;4745   ; sus Y guardadas
	ld hl,0fe5dh		;4748   ; el paso
	ld a,(hl)			;474b
	inc (hl)			;474c
	and 003h		;474d   ; 0 o 2: pintados
	jr z,parpadeo_pinta		;474f
	cp 002h		;4751   ; 2?
	jr nz,parpadeo_fuera		;4753   ; 1 o 3: fuera
parpadeo_pinta:
	pop af			;4755
	push de			;4756
parpadeo_cuatro:
	ld hl,0fe60h		;4757   ; los cuatro colores
	ld b,004h		;475a   ; cuatro sprites
	pop de			;475c
parpadeo_uno:
	push bc			;475d
	push hl			;475e
	ld a,(hl)			;475f   ; su color
	call sprite_dibujo		;4760   ; al sprite
	ld a,(de)			;4763   ; su Y
	call sprite_color		;4764   ; al sprite
	pop hl			;4767
	pop bc			;4768
	inc hl			;4769
	inc de			;476a
	inc c			;476b   ; el siguiente
	djnz parpadeo_uno		;476c
	ret			;476e
parpadeo_fuera:
	ld de,047c8h		;476f   ; Y fuera (0x47C8)...
	jr c,parpadeo_colores		;4772
	pop af			;4774
	ld a,0c8h		;4775   ; ...o 0xC8
	push af			;4777
	ld de,047cch		;4778
parpadeo_colores:
	pop af			;477b
	push de			;477c
	ld hl,0fe60h		;477d
	jr z,parpadeo_sitio		;4780
	ld d,a			;4782
	ld a,(0fc43h)		;4783   ; el modo de pantalla (0xFC43)...
	inc a			;4786
	cp 003h		;4787   ; ...2?
	jr nz,parpadeo_sitio_va		;4789
	ld (hl),d			;478b   ; solo el primero...
	inc hl			;478c
	inc hl			;478d
	ld a,001h		;478e
parpadeo_sitio_va:
	ld b,a			;4790
	ld a,d			;4791
	call llena_b		;4792   ; los colores
	jr parpadeo_cuatro		;4795
parpadeo_sitio:
	ld de,(0fbc3h)		;4797   ; la posicion (0xFBC3)
	bit 4,d		;479b   ; la fila, bit 4?
	jr z,parpadeo_cursores_va		;479d
	inc hl			;479f
	inc hl			;47a0
parpadeo_cursores_va:
	bit 4,e		;47a1   ; la columna, bit 4?
	jr z,parpadeo_cursores_b		;47a3
	inc hl			;47a5
parpadeo_cursores_b:
	ld (hl),a			;47a6   ; el color
	jp parpadeo_cuatro		;47a7
parpadeo_cursores:
	ld a,(0fe5fh)		;47aa   ; el bit 7 de 0xFE5F?
	add a,a			;47ad
	ret nc			;47ae   ; no: nada
	ld hl,0fe5dh		;47af   ; el paso
	ld a,(hl)			;47b2
	inc (hl)			;47b3
	and 003h		;47b4
	jr z,$+13		;47b6
	cp 002h		;47b8
	jr z,$+9		;47ba
	ld a,00fh		;47bc   ; color 15...
	jr c,parpadeo_y_elige		;47be
	ld a,001h		;47c0   ; ...o 1
parpadeo_y_elige:
	cp 0afh		;47c2
	ld c,02bh		;47c4
	jr $+34		;47c6

; ----------------------------------------------------------------------
; DATOS parpadeo_y: Las Y de los cuatro sprites cuando se apagan (1) y cuando
;   se encienden (15)
;   0x47c8..0x47d0  (8 bytes)
DATA_parpadeo_y:
	defb 001h,001h,001h,001h,00fh,00fh,00fh,00fh	; 47c8  ........

; ======================================================================
; CODIGO 0x47d0..0x4b2e  (862 bytes)
; ======================================================================


sprite_xy:		; El sprite C en X = L e Y = H
	push bc			;47d0
	push hl			;47d1
	ld a,l			;47d2   ; la X
	call sprite_x		;47d3   ; al sprite
	pop af			;47d6   ; A = la Y
	pop bc			;47d7
sprite_y:		; La Y del sprite C (A - 1; 0xD0, que acabaria la tabla, pasa a ser 0xC1)
	dec a			;47d8   ; una menos
	cp 0d0h		;47d9   ; 0xD0?
	jr nz,sprite_byte0		;47db
	ld a,0c1h		;47dd   ; si: 0xC1
sprite_byte0:
	ld b,000h		;47df   ; el byte 0 (la Y)
	ld hl,00106h		;47e1   ; (el "ld hl" esconde las entradas de 0x47E2, 0x47E5 y 0x47E8)
	ld hl,00206h		;47e4
	ld hl,00306h		;47e7
	ld hl,03b00h		;47ea   ; la tabla de atributos (0x3B00)...
	push af			;47ed
	ld a,c			;47ee   ; ...+ el sprite x 4...
	add a,a			;47ef
	add a,a			;47f0
	add a,b			;47f1   ; ...+ el byte
	call hl_mas_a		;47f2
	pop af			;47f5
	jp 0004dh		;47f6   ; WRTVRM
sprites_fuera_todos:		; Los 32 sprites: Y 0xC1 (fuera), X 0xC1, dibujo de 0x7C hacia abajo, color 15; a la VRAM (0x3B80, 0x80 bytes)
	ld hl,0fb41h		;47f9   ; desde el ultimo
	ld bc,020c1h		;47fc   ; 32 sprites; Y y X 0xC1
	ld a,0fch		;47ff   ; el dibujo 0xFC...
sprites_fuera_uno:
	ld (hl),00fh		;4801   ; color 15
	dec hl			;4803
	ld (hl),a			;4804   ; el dibujo
	dec hl			;4805
	ld (hl),c			;4806   ; la X
	dec hl			;4807
	ld (hl),c			;4808   ; la Y
	dec hl			;4809
	sub 004h		;480a   ; el dibujo de antes (de 4 en 4)
	djnz sprites_fuera_uno		;480c
	inc hl			;480e
	ld de,03b80h		;480f   ; a 0x3B80
	ld c,080h		;4812   ; 0x80 bytes
	jp ldirvm_mas		;4814
sprites_tabla_76:		; El registro 5 del VDP = 0x76 (la tabla de atributos en 0x3B00)
	ld b,076h		;4817
	jr vdp_reg5		;4819
sprites_fuera_vdp:		; Los sprites fuera y el registro 5 del VDP = 0x77 (la tabla de atributos en 0x3B80)
	call sprites_fuera_todos		;481b
	ld b,077h		;481e   ; 0x77...
vdp_reg5:
	ld c,005h		;4820   ; ...al registro 5
	jp 00047h		;4822   ; WRTVDP
casillas_cambia:		; Con 0xF421 0x20 o mas: los bytes de 0xF7ED a 0xFBEC entre 0x74 y 0x76 pasan a 0x74 + 0x71 + ... (B + n)
	ld a,(0f421h)		;4825   ; 0xF421...
	cp 020h		;4828   ; ...menos de 0x20?
	ret c			;482a
	ld bc,07103h		;482b   ; B = 0x71, C = 3
	ld hl,(0f7edh)		;482e   ; desde
	ld de,(0fbech)		;4831   ; hasta
casillas_cambia_uno:
	rst 20h			;4835   ; el final?
	ret z			;4836
	ld a,(hl)			;4837   ; el byte...
	sub 074h		;4838   ; ...- 0x74
	jr c,casillas_cambia_sig		;483a   ; por debajo: nada
	cp c			;483c   ; 3 o mas: nada
	jr nc,casillas_cambia_sig		;483d
	add a,b			;483f   ; + 0x71
	ld (hl),a			;4840
casillas_cambia_sig:
	inc hl			;4841
	jr casillas_cambia_uno		;4842
mapa_elige:		; El mapa con que se trabaja (0xFBE8): 0xF7ED o, con 0xFA09, 0xFBEA; 0xFBFB y 0xFBEE a 0; la primera vez (0xFBD4 = 0) 0x5044 y 0xFBD4 = 0xFF; despues, con el bit 6 de 0xF421, 0x5FC0
	ld a,(0fa09h)		;4844   ; 0xFA09?
	ld hl,(0f7edh)		;4847   ; el mapa de 0xF7ED
	and a			;484a
	jr z,mapa_elige_pon		;484b   ; 0: ese
	ld hl,(0fbeah)		;484d   ; si no, el de 0xFBEA
	xor a			;4850
mapa_elige_pon:
	ld (0fbe8h),hl		;4851   ; apuntado
	ld (0fbfbh),a		;4854   ; 0xFBFB = A
	xor a			;4857
	ld (0fbeeh),a		;4858   ; 0xFBEE a 0
	ld a,(0fbd4h)		;485b   ; la primera vez?
	and a			;485e
	ld a,(0f421h)		;485f   ; 0xF421
	jp z,mapa_primera		;4862   ; si: a prepararlo
	and 040h		;4865   ; el bit 6?
	ret z			;4867   ; no: nada
	jp laberinto_pinta		;4868
mapa_primera:
	call editor_clase_tipo		;486b   ; 0x5044
	xor a			;486e
	ld (0fbe6h),a		;486f   ; 0xFBE6 a 0
	dec a			;4872   ; 0xFF...
	ld (0fbd4h),a		;4873   ; ...ya no es la primera
	ret			;4876
mapa_tercio:		; El mapa de 0xF7ED + A x 0x210 (A = 0, 1 o 2)
	ld hl,(0f7edh)		;4877   ; desde 0xF7ED
	ld de,00210h		;487a   ; 0x210 por cada uno
	cp 001h		;487d   ; 0?
	jr c,mapa_elige_pon		;487f
	jr z,mapa_tercio_suma		;4881   ; 1?
	add hl,de			;4883
mapa_tercio_suma:
	add hl,de			;4884
	jr mapa_elige_pon		;4885
mapa_casilla:		; La casilla A en la columna E y la fila D: a la VRAM (0x3801 + ...) y al mapa de 0xFBE8 (filas de 22)
	push af			;4887
	ex de,hl			;4888
	ld a,d			;4889
	call por32_a		;488a   ; la fila...
	ld hl,03801h		;488d   ; la tabla de nombres (0x3800) + 1...
	add hl,bc			;4890   ; ...+ la fila...
	ld b,000h		;4891
	ld c,e			;4893
	add hl,bc			;4894   ; ...+ la columna
	pop af			;4895
	push af			;4896
	call 0004dh		;4897   ; WRTVRM
	ld a,016h		;489a   ; 22 por fila
	ld c,d			;489c
	ld b,000h		;489d
	ld h,b			;489f
	ld l,b			;48a0
	and a			;48a1
	jr z,mapa_casilla_pon		;48a2
mapa_casilla_fila:
	add hl,bc			;48a4   ; + 22 por fila
	dec a			;48a5
	jr nz,mapa_casilla_fila		;48a6
mapa_casilla_pon:
	ld d,b			;48a8
	add hl,de			;48a9   ; + la columna
	ld de,(0fbe8h)		;48aa   ; + el mapa
	add hl,de			;48ae
	pop af			;48af
	ld (hl),a			;48b0   ; la casilla
	ret			;48b1
buffer_inicio:		; El buffer del teclado vacio (0xFE37 y 0xFE39 a 0xFE3B)
	di			;48b2   ; sin interrupciones
	ld hl,0fe3bh		;48b3   ; el principio...
	ld (0fe37h),hl		;48b6   ; ...donde se escribe...
	ld (0fe39h),hl		;48b9   ; ...y donde se lee
	ei			;48bc   ; con interrupciones
	ret			;48bd
objeto_cambia:		; Mueve un objeto de la lista (C) a otro sitio (B) de 0xF512 (21 bytes cada uno): si caben sus sprites (0xFC40), sus cuatro Y de la VRAM a 0xFBD6, lo de 0x62C1 y otra vez a la VRAM, para los 8 sprites de cada uno
	dec a			;48be
	dec c			;48bf
	ld b,a			;48c0
	ld d,a			;48c1
	call objeto_sprites		;48c2   ; los sprites del primero
	ld h,e			;48c5
	ld d,c			;48c6
	call objeto_sprites		;48c7   ; los del segundo
	ld a,(0fc40h)		;48ca   ; los que quedan libres (0xFC40)...
	add a,e			;48cd   ; ...+ los del primero
	cp h			;48ce   ; caben?
	ret c			;48cf   ; no: C
	ld a,c			;48d0
	inc a			;48d1
	push bc			;48d2
	call objeto_hueco		;48d3   ; hueco
	pop bc			;48d6
	push bc			;48d7
	ld a,c			;48d8
	ld (0fc41h),a		;48d9   ; 0xFC41
	inc a			;48dc
	call personaje_ficha_a		;48dd   ; su ficha
	ld a,(hl)			;48e0
	ld (0fc44h),a		;48e1   ; 0xFC44
	ld a,b			;48e4
	inc a			;48e5
	call personaje_forma_a		;48e6   ; el byte 1 de la ficha
	ld (0fc43h),a		;48e9   ; 0xFC43
	pop bc			;48ec
	ld a,080h		;48ed   ; desde el sprite 0x80
objeto_cambia_uno:
	push af			;48ef
	push bc			;48f0
	ld d,b			;48f1
	ld e,a			;48f2
	call dibujo_al_editor		;48f3   ; esta en la tabla (0xFBFE)?
	jr c,objeto_cambia_sig		;48f6   ; no
	push de			;48f8
	call sprite_atributo		;48f9   ; su sitio en la tabla de atributos
	ld a,c			;48fc   ; cuantos
	ld (de),a			;48fd
	inc de			;48fe
objeto_cambia_y:
	call 0004ah		;48ff   ; RDVRM: la Y
	ld (de),a			;4902   ; guardada
	inc de			;4903
	inc hl			;4904   ; el siguiente (+4)
	inc hl			;4905
	inc hl			;4906
	inc hl			;4907
	dec c			;4908
	jr nz,objeto_cambia_y		;4909
	pop de			;490b
	pop bc			;490c
	push bc			;490d
	ld d,c			;490e
	push de			;490f
	call dibujo_sitio		;4910
	pop de			;4913
	push de			;4914
	call sprite_atributo		;4915
	ld a,(de)			;4918   ; cuantos
	ld b,a			;4919
objeto_cambia_pon:
	inc de			;491a
	ld a,(de)			;491b   ; la Y guardada...
	call 0004dh		;491c   ; ...a la VRAM
	inc hl			;491f
	inc hl			;4920
	inc hl			;4921
	inc hl			;4922
	djnz objeto_cambia_pon		;4923
	pop de			;4925
	call dibujo_del_editor		;4926
objeto_cambia_sig:
	pop bc			;4929
	pop af			;492a
	inc a			;492b
	cp 088h		;492c   ; los ocho?
	jr nz,objeto_cambia_uno		;492e
	ld a,c			;4930
	inc a			;4931
	call objeto_sprites_pon		;4932
	and a			;4935
	ret			;4936
objeto_sprites:		; E = cuantos sprites usa el objeto D (los 8 que puede tener: 0x6120)
	push af			;4937
	push bc			;4938
	push hl			;4939
	ld bc,00800h		;493a   ; 8 sprites; C cuenta
	ld e,080h		;493d   ; desde 0x80
objeto_sprites_uno:
	push bc			;493f
	call sprite_busca		;4940   ; en la tabla?
	jr c,objeto_sprites_sig		;4943   ; no
	ld a,c			;4945   ; cuantos...
	pop bc			;4946
	add a,c			;4947   ; ...se suman
	ld c,a			;4948
	push bc			;4949
objeto_sprites_sig:
	pop bc			;494a
	inc e			;494b
	djnz objeto_sprites_uno		;494c
	ld e,c			;494e   ; E: el total
	pop hl			;494f
	pop bc			;4950
	pop af			;4951
	ret			;4952
sprite_atributo:		; HL = el byte 3 del sprite B en la tabla de atributos (0x3B03 + B); DE = 0xFBD6
	call sprite_busca		;4953   ; el sprite
	ld d,000h		;4956   ; su posicion
	ld e,b			;4958
	ld hl,03b03h		;4959   ; la tabla de atributos, byte 3
	add hl,de			;495c
	ld de,0fbd6h		;495d   ; la RAM
	ret			;4960
objeto_hueco:		; Quita el objeto A - 1 de la tabla de 0xFBFE (sus 8 sprites) y los de numero mayor bajan uno; y sus sprites de nuevo (0x4985)
	push af			;4961
	dec a			;4962
	ld d,a			;4963
	ld e,080h		;4964   ; desde 0x80
	ld b,008h		;4966   ; ocho
objeto_hueco_uno:
	push bc			;4968
	push de			;4969
	call dibujo_quita_va		;496a   ; fuera de la tabla
	pop de			;496d
	inc e			;496e
	pop bc			;496f
	djnz objeto_hueco_uno		;4970
	ld hl,0fbfeh		;4972   ; la tabla (0xFBFE)...
	ld b,020h		;4975   ; ...32 pares
objeto_hueco_baja:
	ld a,(hl)			;4977
	cp 020h		;4978   ; 0x20 o mas?
	jr nc,objeto_hueco_sig		;497a
	cp d			;497c   ; menor que el quitado?
	jr c,objeto_hueco_sig		;497d
	dec (hl)			;497f   ; uno menos
objeto_hueco_sig:
	inc hl			;4980
	inc hl			;4981
	djnz objeto_hueco_baja		;4982
	pop af			;4984
objeto_sprites_pon:		; Los 8 numeros de sprite del objeto A en su ficha (+0x0A), 0xFF los que no tiene, con los bits de su clase (byte 1)
	call personaje_forma_lee		;4985   ; el byte 1 de su ficha
	and 003h		;4988   ; sus dos bits bajos
	ld c,a			;498a
	ld de,0000ah		;498b   ; + 10
	add hl,de			;498e
	ld de,(0fa11h)		;498f   ; el objeto (0xFA11)
	dec d			;4993
	ld e,080h		;4994   ; desde 0x80
	ld b,008h		;4996   ; ocho
objeto_sprites_pon_uno:
	push bc			;4998
	push hl			;4999
	call sprite_busca		;499a   ; en la tabla?
	ld a,b			;499d
	pop hl			;499e
	pop bc			;499f
	ld (hl),0ffh		;49a0   ; 0xFF: no tiene
	jr c,objeto_sprites_pon_sig		;49a2   ; no
	or c			;49a4   ; su numero y la clase
	ld (hl),a			;49a5
objeto_sprites_pon_sig:
	inc hl			;49a6
	inc e			;49a7
	djnz objeto_sprites_pon_uno		;49a8
	ret			;49aa
objeto_dibuja:		; El objeto A en L: sus colores (de 4 en 4) a 0xFDEF y sus sprites a la tabla de atributos (1, 2 o 4 sprites de 16 x 16 en cuadro: +0, +0x10, +0x1000 y +0x1010)
	push bc			;49ab
	ld e,l			;49ac
	ld d,a			;49ad
	dec d			;49ae
	push af			;49af
	call sprite_busca		;49b0   ; en la tabla?
	jr nc,L_49B8		;49b3   ; si
	pop af			;49b5
	pop bc			;49b6
	ret			;49b7
L_49B8:
	push bc			;49b8
	srl b		;49b9   ; entre 4
	srl b		;49bb
	ld c,b			;49bd
	ld b,000h		;49be
	ld hl,0fdefh		;49c0   ; los colores (0xFDEF)
	add hl,bc			;49c3
	pop bc			;49c4
	pop af			;49c5
objeto_dibuja_color:
	ld (hl),a			;49c6   ; su color
	inc hl			;49c7
	ld d,a			;49c8
	dec c			;49c9
	jr nz,objeto_dibuja_color		;49ca
	call personaje_forma_a		;49cc   ; el byte 1 de su ficha
	inc a			;49cf
	pop hl			;49d0
	push de			;49d1
	ld de,00008h		;49d2   ; + 8 en X e Y
	add hl,de			;49d5
	ld c,b			;49d6
	ld b,a			;49d7
	ld de,00000h		;49d8   ; el primero: sin desplazar
	pop af			;49db
	call sprite_atributos		;49dc   ; puesto
	dec b			;49df   ; uno solo?
	ret z			;49e0
	srl b		;49e1   ; la mitad
	jr nc,objeto_dibuja_abajo		;49e3
	ld de,00010h		;49e5   ; el de la derecha: +16 en X
	call sprite_atributos		;49e8
	ret z			;49eb
	inc b			;49ec
objeto_dibuja_abajo:
	dec b			;49ed
	ld de,01000h		;49ee   ; el de abajo: +16 en Y
	call sprite_atributos		;49f1
	ret z			;49f4
	ld de,01010h		;49f5   ; el de abajo a la derecha
sprite_atributos:		; El sprite C: Y (D - 1; 0xD0 pasa a 0xC1), X (E) y dibujo (C) en la tabla de atributos (0x3B00); C + 4
	push af			;49f8
	push hl			;49f9
	add hl,de			;49fa   ; + el desplazamiento
	push bc			;49fb
	ex de,hl			;49fc
	ld hl,03b00h		;49fd   ; la tabla de atributos
	ld b,000h		;4a00   ; + C
	add hl,bc			;4a02
	ld a,d			;4a03   ; la Y - 1
	dec a			;4a04
	cp 0d0h		;4a05   ; 0xD0?
	jr nz,sprite_atributos_y		;4a07
	ld a,0c1h		;4a09   ; si: 0xC1
sprite_atributos_y:
	call 0004dh		;4a0b   ; WRTVRM
	inc hl			;4a0e
	ld a,e			;4a0f   ; la X
	call 0004dh		;4a10   ; WRTVRM
	pop bc			;4a13
	inc hl			;4a14
	ld a,c			;4a15   ; el dibujo
	call 0004dh		;4a16   ; WRTVRM
	ld a,004h		;4a19   ; el siguiente: + 4
	add a,c			;4a1b
	ld c,a			;4a1c
	pop hl			;4a1d
	pop af			;4a1e
	ret			;4a1f
sprite_quita:		; Busca A en los 32 numeros de 0xFDEF-0xFE0E (hacia atras): si esta, a 0 y su sprite fuera (Y 0xC1), y los iguales que lo siguen
	ld hl,0fe0eh		;4a20   ; desde el final
	ld bc,00020h		;4a23   ; 32
	cpdr		;4a26   ; buscar A
	ret nz			;4a28   ; no esta
	push hl			;4a29
	push af			;4a2a
	inc hl			;4a2b
	ld (hl),000h		;4a2c   ; a 0
	ld l,c			;4a2e   ; el numero...
	ld h,000h		;4a2f
	add hl,hl			;4a31   ; ...x 4
	add hl,hl			;4a32
	ld de,03b00h		;4a33   ; + la tabla de atributos
sprite_quita_uno:
	add hl,de			;4a36
	ld a,0c1h		;4a37   ; Y 0xC1: fuera
	call 0004dh		;4a39   ; WRTVRM
	pop af			;4a3c
	ex (sp),hl			;4a3d
	cp (hl)			;4a3e   ; el siguiente tambien?
	jr nz,sprite_quita_fin		;4a3f
	ld (hl),000h		;4a41   ; a 0
	dec hl			;4a43
	ex (sp),hl			;4a44
	ld de,0fffch		;4a45   ; el sprite anterior (-4)
	push af			;4a48
	jr sprite_quita_uno		;4a49
sprite_quita_fin:
	pop af			;4a4b
	ret			;4a4c
sprites_todos_fuera:		; Los 32 sprites fuera (Y 0xC1) y 0xFDEF-0xFE0E a 0
	ld de,00004h		;4a4d   ; de 4 en 4
	ld hl,03b00h		;4a50   ; la tabla de atributos
	ld bc,020c1h		;4a53   ; 32; Y 0xC1
sprites_todos_fuera_uno:
	ld a,c			;4a56
	call 0004dh		;4a57   ; WRTVRM
	add hl,de			;4a5a
	djnz sprites_todos_fuera_uno		;4a5b
	ld hl,0fdefh		;4a5d   ; 0xFDEF...
	ld b,020h		;4a60   ; ...32 bytes a 0
	jp cero_b		;4a62
letra_pon:		; La letra E en la columna C, fila B: en modo texto (0xFA1B = 0), a la tabla de nombres de 0x3C00; si no, en SCREEN 2, su dibujo (de la fuente de la BIOS, 0x0004) y el color de 0xFA35/0xFA36
	ld e,a			;4a65
	ld a,(0fa36h)		;4a66   ; el color de la letra (0xFA36)...
	and 00fh		;4a69
	rrca			;4a6b   ; ...en la mitad alta
	rrca			;4a6c
	rrca			;4a6d
	rrca			;4a6e
	ld d,a			;4a6f
	ld a,(0fa35h)		;4a70   ; el de fondo (0xFA35)
	and 00fh		;4a73
	or d			;4a75   ; los dos
	ld d,a			;4a76
	ld a,(0fa1bh)		;4a77   ; 0xFA1B?
	and a			;4a7a
	jr nz,letra_pon_screen2		;4a7b   ; en SCREEN 2
	ld a,e			;4a7d
	ld hl,0ffe1h		;4a7e   ; fila B: -0x1F...
	ld de,00020h		;4a81   ; ...+ 32 por fila
	inc b			;4a84
letra_pon_fila:
	add hl,de			;4a85
	djnz letra_pon_fila		;4a86
	add hl,bc			;4a88   ; + la columna
	ld bc,03c00h		;4a89   ; + 0x3C00
	add hl,bc			;4a8c
	jp 0004dh		;4a8d   ; WRTVRM
letra_pon_screen2:
	call tipo_11		;4a90
	jr nz,letra_pon_casilla		;4a93   ; no
	push de			;4a95
	ld a,c			;4a96   ; la columna x 8
	add a,a			;4a97
	add a,a			;4a98
	add a,a			;4a99
	ld c,a			;4a9a
	ld hl,00008h		;4a9b
	add hl,bc			;4a9e
	ld d,000h		;4a9f
	ex de,hl			;4aa1
	add hl,hl			;4aa2
	add hl,hl			;4aa3
	add hl,hl			;4aa4
	ld bc,(00004h)		;4aa5   ; la fuente de la BIOS (0x0004)
	add hl,bc			;4aa9
	ld bc,00008h		;4aaa   ; 8 bytes
	call ldirvm_mas		;4aad   ; a la VRAM
	ex de,hl			;4ab0
	set 5,h		;4ab1   ; sus colores (+0x2000)
	pop af			;4ab3
	jp 00056h		;4ab4   ; FILVRM
letra_pon_casilla:
	ld a,e			;4ab7
	cp 020h		;4ab8   ; el espacio?
	jr nz,letra_pon_casilla_va		;4aba
	ld a,05bh		;4abc   ; si: la casilla 0x5B
letra_pon_casilla_va:
	sub 010h		;4abe   ; - 0x10: la casilla
	push af			;4ac0
	ld h,000h		;4ac1
	ld l,a			;4ac3
	add hl,hl			;4ac4   ; x 8
	add hl,hl			;4ac5
	add hl,hl			;4ac6
	push bc			;4ac7
	ld bc,02000h		;4ac8   ; + 0x2000: sus colores
	add hl,bc			;4acb
	ld e,003h		;4acc   ; en los tres tercios
letra_pon_color:
	ld bc,00008h		;4ace   ; 8 bytes
	ld a,d			;4ad1   ; el color
	call 00056h		;4ad2   ; FILVRM
	ld bc,00800h		;4ad5   ; el tercio siguiente
	add hl,bc			;4ad8
	dec e			;4ad9
	jr nz,letra_pon_color		;4ada
	pop bc			;4adc
	inc b			;4add
	ld hl,0ffe0h		;4ade   ; fila B
	ld de,00020h		;4ae1
letra_pon_fila2:
	add hl,de			;4ae4
	djnz letra_pon_fila2		;4ae5
	add hl,bc			;4ae7
	ld bc,03801h		;4ae8   ; + 0x3801
	add hl,bc			;4aeb
	pop af			;4aec
	jp 0004dh		;4aed   ; WRTVRM
marcador_pinta:		; El marcador de la partida a la derecha: 24 filas de 8 espacios desde la columna 22 con letras blancas (0xFA36 = 15) y los cinco rotulos (0x4B2E: HISCORE, SCORE, STAGE, LEFT y TIME) en sus sitios (0x8B87)
	call vdp_int_off		;4af0   ; sin la interrupcion del VDP
	ld a,00fh		;4af3   ; letras blancas
	ld (0fa36h),a		;4af5   ; el color de las letras
	ld c,018h		;4af8   ; 24 filas
	ld hl,00016h		;4afa   ; desde la columna 22, fila 0
marcador_fila:
	ld (0fa1dh),hl		;4afd   ; el cursor
	ld b,008h		;4b00   ; 8 espacios
marcador_espacio:
	ld a,020h		;4b02
	call letra_escribe		;4b04   ; a la pantalla
	djnz marcador_espacio		;4b07
	inc h			;4b09   ; la fila siguiente
	dec c			;4b0a
	jr nz,marcador_fila		;4b0b
	ld de,04b2eh		;4b0d   ; los rotulos (0x4B2E)
	ld hl,08b87h		;4b10   ; sus sitios (0x8B87)
	ld b,005h		;4b13   ; cinco
marcador_rotulo:
	push bc			;4b15
	push hl			;4b16
	call palabra_lee		;4b17   ; su sitio...
	ld (0fa1dh),hl		;4b1a   ; ...al cursor
	ex de,hl			;4b1d
	call texto_pinta_hl		;4b1e   ; escrito
	ex de,hl			;4b21
	inc de			;4b22   ; detras de su 0
	pop hl			;4b23
	inc hl			;4b24   ; el sitio siguiente
	inc hl			;4b25
	pop bc			;4b26
	djnz marcador_rotulo		;4b27
	call vdp_int_on		;4b29   ; con la interrupcion del VDP
	ei			;4b2c
	ret			;4b2d

; ----------------------------------------------------------------------
; DATOS marcador_textos: HISCORE, SCORE, STAGE, LEFT y TIME, cada uno con su 0
;   0x4b2e..0x4b4c  (30 bytes)
DATA_marcador_textos:
	defb 048h,049h,053h,043h,04fh,052h,045h,000h,053h,043h,04fh,052h,045h,000h,053h,054h	; 4b2e  HISCORE.SCORE.ST
	defb 041h,047h,045h,000h,04ch,045h,046h,054h,000h,054h,049h,04dh,045h,000h	; 4b3e  AGE.LEFT.TIME.

; ======================================================================
; CODIGO 0x4b4c..0x4c26  (218 bytes)
; ======================================================================


marcador_algo:		; 9 - A y a 0x4B55
	neg		;4b4c
	add a,009h		;4b4e
	jr marcador_f418_va		;4b50
marcador_f418:		; 0xF418 - 9: por debajo, 0x5E51; si no, 0x5E94; y 0x5EEE
	ld a,(0f418h)		;4b52   ; 0xF418
marcador_f418_va:
	sub 009h		;4b55   ; - 9
	jr c,marcador_f418_menos		;4b57   ; por debajo
	call mapa_baja		;4b59   ; 9 o mas
	jr marcador_f418_fin		;4b5c
marcador_f418_menos:
	call mapa_sube		;4b5e
marcador_f418_fin:
	ret c			;4b61
	call mapa_pinta		;4b62
	and a			;4b65
	ret			;4b66
colores_cero:		; Los colores de SCREEN 2 (0x2000-0x37FF) a 0, de 8 en 8 bytes por cada 0x800
	push bc			;4b67
	push hl			;4b68
	ld hl,02000h		;4b69   ; desde 0x2000
colores_cero_uno:
	xor a			;4b6c
	ld bc,00008h		;4b6d   ; 8 bytes
	call 00056h		;4b70   ; FILVRM
	ld a,008h		;4b73   ; + 0x800
	add a,h			;4b75
	ld h,a			;4b76
	cp 038h		;4b77   ; hasta 0x3800
	jr nz,colores_cero_uno		;4b79
	pop hl			;4b7b
	pop bc			;4b7c
	ret			;4b7d
pantalla_texto_limpia:		; La tabla de nombres de la pantalla de texto (0x3C00) a 0 y sus colores
	xor a			;4b7e   ; la casilla 0
	call texto_llena		;4b7f
	jr texto_colores		;4b82
graficos_entra:		; Pasa a SCREEN 2 (0xFA1B = 1; si ya estaba, C): colores de la pantalla de texto a 0, 0x5479; en el juego de tipo 0x11 (0x4C46), 0x5015 y los dibujos de 0xF7EB; si no, la tabla de nombres a 0, 0x58B7 y 0x5EEE; despues colores a 0, 0x5648 y los registros del VDP de SCREEN 2 (0x4C2D)
	ld hl,0fa1bh		;4b84   ; 0xFA1B...
	ld a,(hl)			;4b87   ; ...ya en SCREEN 2?
	and a			;4b88
	scf			;4b89   ; si: C
	ret nz			;4b8a
	inc (hl)			;4b8b   ; a SCREEN 2
	call texto_colores_a		;4b8c   ; los colores de la pantalla de texto a 0
	call lienzo_nombres		;4b8f
	call tipo_11		;4b92   ; el juego de tipo 0x11?
	jr nz,graficos_entra_otro		;4b95   ; no
	call fondo_unico_prepara		;4b97
	call dibujos_a_vram		;4b9a   ; los dibujos de 0xF7EB a la VRAM
graficos_entra_vdp:
	call colores_cero		;4b9d   ; los colores a 0
	call colores_paleta		;4ba0
	call vdp_graficos		;4ba3   ; los registros de SCREEN 2
	and a			;4ba6
	ret			;4ba7
graficos_entra_otro:
	call graficos_cero		;4ba8   ; la tabla de nombres a 0
	ld hl,00201h		;4bab   ; 0x0201
	call casillas_copia		;4bae
	call mapa_pinta		;4bb1
	jr graficos_entra_vdp		;4bb4
texto_entra:		; Vuelve a la pantalla de texto (0xFA1B a 0; si no estaba en SCREEN 2, C): en el juego de tipo 0x11, los dibujos a 0xF7EB (0x4C35); despues los registros de la pantalla de texto (0x4C26), las letras (0x4C4C), 0x50C5, colores a 0 y la tabla de nombres en blanco
	ld hl,0fa1bh		;4bb6   ; 0xFA1B...
	ld a,(hl)			;4bb9   ; ...1?
	dec a			;4bba
	scf			;4bbb   ; si no: C
	ret nz			;4bbc
	ld (hl),a			;4bbd   ; a 0
	call tipo_11		;4bbe   ; el juego de tipo 0x11?
	call z,dibujos_a_ram		;4bc1   ; si: los dibujos a la RAM
texto_entra_va:
	xor a			;4bc4   ; los colores de la pantalla de texto a 0
	call texto_colores_a		;4bc5
	call vdp_texto		;4bc8   ; los registros de la pantalla de texto
	call letras_texto		;4bcb   ; las letras
	call dibujos_menu		;4bce
	call colores_cero		;4bd1   ; los colores a 0
	call texto_blanco		;4bd4   ; la tabla de nombres en blanco
texto_colores:		; Los colores de la pantalla de texto (0x3F00): los dos primeros grupos y los 28 de 0x3F04 con el color de las letras (0xFA36) y el de fondo (0xFA35)
	ld a,(0fa36h)		;4bd7   ; el color de las letras...
	and 00fh		;4bda
	rrca			;4bdc   ; ...arriba
	rrca			;4bdd
	rrca			;4bde
	rrca			;4bdf
	ld b,a			;4be0
	ld a,(0fa35h)		;4be1   ; el de fondo
	and 00fh		;4be4
	or b			;4be6   ; los dos
	push bc			;4be7
	push de			;4be8
	push hl			;4be9
	ld hl,03f00h		;4bea   ; los dos primeros grupos
	ld bc,00002h		;4bed
	call 00056h		;4bf0   ; FILVRM
	ld hl,03f04h		;4bf3   ; desde el grupo 4...
	ld bc,0001ch		;4bf6   ; ...28
	jr texto_colores_fill		;4bf9
texto_colores_a:		; Los 32 colores de la pantalla de texto (0x3F00) = A
	push bc			;4bfb
	push de			;4bfc
	push hl			;4bfd
	ld bc,00020h		;4bfe   ; 32
	ld hl,03f00h		;4c01   ; desde 0x3F00
texto_colores_fill:
	call 00056h		;4c04   ; FILVRM
	pop hl			;4c07
	pop de			;4c08
	pop bc			;4c09
	and a			;4c0a
	ret			;4c0b
vdp_texto:		; Los registros 0-6 del VDP de la pantalla de texto (0x4C26: SCREEN 1, nombres en 0x3C00, colores en 0x3F00, atributos en 0x3B80, sprites de 16 x 16)
	ld hl,04c26h		;4c0c   ; los de 0x4C26
	jr vdp_registros		;4c0f
vdp_graficos:		; Los registros 0-6 del VDP de SCREEN 2 (0x4C2D: nombres en 0x3800, colores en 0x2000)
	ld hl,04c2dh		;4c11   ; los de 0x4C2D
vdp_registros:
	call 00041h		;4c14   ; DISSCR
	ld d,007h		;4c17   ; del 6 al 0
vdp_registro:
	ld b,(hl)			;4c19   ; el valor
	ld c,d			;4c1a   ; el registro
	dec c			;4c1b
	call 00047h		;4c1c   ; WRTVDP
	inc hl			;4c1f   ; el siguiente
	dec d			;4c20   ; uno menos
	jr nz,vdp_registro		;4c21
	jp 00044h		;4c23   ; ENASCR

; ----------------------------------------------------------------------
; DATOS vdp_tablas: Los registros 6 a 0 del VDP: la pantalla de texto (SCREEN
;   1; 0x4C26) y SCREEN 2 (0x4C2D)
;   0x4c26..0x4c34  (14 bytes)
DATA_vdp_tablas:
	defb 003h,077h,000h,0fch,00fh,0e2h,000h,003h,077h,003h,0ffh,00eh,0e2h,002h	; 4c26  .w......w.....

; ======================================================================
; CODIGO 0x4c34..0x4ce6  (178 bytes)
; ======================================================================


dibujos_a_vram:		; 0x800 bytes de dibujos de casillas entre 0xF7EB y la VRAM 0: a la VRAM (aqui, NZ); a la RAM (0x4C35, con Z)
	or 0afh		;4c34   ; (0x4C35: "xor a", al reves)
	ld hl,(0f7ebh)		;4c36   ; los dibujos de la RAM
	ld de,00000h		;4c39   ; en la VRAM 0
	ld bc,00800h		;4c3c   ; 0x800 bytes
	jp nz,ldirvm_mas		;4c3f   ; NZ: a la VRAM
	ex de,hl			;4c42
	jp ldirmv_mas		;4c43   ; Z: a la RAM
tipo_11:		; Z si el juego es del tipo 0x11 (0xF421); A = 0xF421
	ld a,(0f421h)		;4c46   ; el tipo
	cp 011h		;4c49   ; 0x11?
	ret			;4c4b
letras_texto:		; Las letras de la fuente de la BIOS (desde la 0x20: 0x0004 + 0x100) en la VRAM 0x100, 0x700 bytes
	ld de,00100h		;4c4c   ; a 0x100
	ld hl,(00004h)		;4c4f   ; la fuente de la BIOS...
	inc h			;4c52   ; ...desde la letra 0x20
	ld bc,00700h		;4c53   ; 0x700 bytes
	jp ldirvm		;4c56
texto_blanco:		; La tabla de nombres de la pantalla de texto (0x3C00) llena de espacios
	ld a,020h		;4c59   ; el espacio
texto_llena:
	ld hl,03c00h		;4c5b   ; 0x3C00
	jr nombres_llena		;4c5e
graficos_cero:		; La tabla de nombres de SCREEN 2 (0x3800) a 0
	xor a			;4c60
	ld hl,03800h		;4c61   ; 0x3800
nombres_llena:
	ld bc,00300h		;4c64   ; 0x300 casillas
	jp 00056h		;4c67   ; FILVRM
editor:		; El editor de una pantalla del juego: lo prepara (0x50D1 y, segun el tipo, 0x5015, 0x504C o 0x5053) y, en un bucle, el menu del modo (0x1B + segun el tipo), SCREEN 2, la tabla de cursores del modo (0x4CE6 por 0xFE6C) y las teclas del modo (0xFE6D)
	call editor_prepara		;4c6a   ; preparar
	call tipo_11		;4c6d   ; el tipo 0x11?
	jr nz,editor_tipo		;4c70   ; no
	call fondo_unico_prepara		;4c72
	jr editor_listo		;4c75
editor_tipo:
	rlca			;4c77   ; el bit 6 del tipo?
	rlca			;4c78
	jr nc,editor_tipo_b		;4c79   ; no
	call editor_laberinto		;4c7b
	jr editor_listo		;4c7e
editor_tipo_b:
	call editor_casillas		;4c80
editor_listo:
	ld a,0ffh		;4c83   ; ya preparado
	ld (0fbd4h),a		;4c85   ; 0xFBD4 = 0xFF
editor_bucle:
	call colores_paleta		;4c88
	xor a			;4c8b   ; todo a 0:
	ld (0fbd3h),a		;4c8c   ; copiando
	ld (0fe5fh),a		;4c8f   ; los cursores
	ld (0fe5eh),a		;4c92   ; el parpadeo del personaje
	ld (0fe71h),a		;4c95   ; con tableta
	ld (0fbf5h),a		;4c98   ; copiando el fondo
	ld (0fe13h),a		;4c9b   ; con escritura
	ld l,01bh		;4c9e   ; el menu 0x1B...
	call tipo_11		;4ca0   ; ...el tipo 0x11?
	jr z,editor_menu_va		;4ca3   ; si: ese
	inc l			;4ca5   ; 0x1C
	bit 3,a		;4ca6   ; el bit 3 del tipo?
	jr z,editor_menu		;4ca8
	inc l			;4caa   ; 0x1D
editor_menu:
	and 060h		;4cab   ; los bits 5 y 6?
	jr z,editor_menu_va		;4cad
	inc l			;4caf   ; dos mas
	inc l			;4cb0
editor_menu_va:
	ld a,l			;4cb1
	call menu		;4cb2   ; el menu: la opcion en C
	call tipo_11		;4cb5   ; el tipo 0x11?
	jr z,editor_opcion		;4cb8
	and 002h		;4cba   ; el bit 1?
	jr nz,editor_opcion		;4cbc
	dec c			;4cbe   ; una opcion menos
editor_opcion:
	xor a			;4cbf
	ld (0fa1ch),a		;4cc0   ; 0xFA1C a 0
	ld b,c			;4cc3
	push bc			;4cc4
	push bc			;4cc5
	call graficos_entra		;4cc6   ; a SCREEN 2
	ld hl,04ce6h		;4cc9   ; la tabla de 0x4CE6...
	ld a,(0fe6ch)		;4ccc   ; ...por 0xFE6C
	call tabla_puntero		;4ccf
	pop af			;4cd2   ; la opcion
	ld de,0fe5fh		;4cd3   ; los cursores (0xFE5F)
	call salta_tabla		;4cd6   ; a su rutina
	pop bc			;4cd9
	add hl,bc			;4cda   ; el modo (0xFE6D y 0xFE6E)
	ld (0fe6dh),hl		;4cdb   ; el modo del editor
	call editor_teclas		;4cde   ; el modo, en marcha
	call texto_entra		;4ce1   ; a la pantalla de texto
	jr editor_bucle		;4ce4   ; otra vez

; ----------------------------------------------------------------------
; DATOS editor_tablas: Las tablas de rutinas de cada clase de editor (por
;   0xFE6C): 0x5287, 0x5299 y 0x528F
;   0x4ce6..0x4cec  (6 bytes)
DATA_editor_tablas:
	defb 087h,052h,099h,052h,08fh,052h	; 4ce6

; ======================================================================
; CODIGO 0x4cec..0x5131  (1093 bytes)
; ======================================================================


menu_y_resta:		; El menu A y la opcion - 1
	call menu		;4cec
	dec c			;4cef
	ret			;4cf0
sprites_vacia:		; La tabla de nombres de 0x1800 (0x400 bytes) a 0 y la tabla de los sprites de los personajes (0xFBFE, 0x42 bytes) a 0xFF
	ld hl,01800h		;4cf1   ; 0x1800...
	ld bc,00400h		;4cf4   ; ...0x400 bytes...
	xor a			;4cf7   ; ...a 0
	call 00056h		;4cf8   ; FILVRM
	ld a,0ffh		;4cfb   ; libres: 0xFF
	ld b,042h		;4cfd   ; 0x42 bytes
	ld hl,0fbfeh		;4cff   ; la tabla de sprites
	jp llena_b		;4d02
personaje_editor:		; El editor de personajes (menu 0x7D): sin sprites; los personajes en el editor (0xFA13 -> 0xFC44, 0xFC41), sus dibujos (0x86DD: 0xFC43 y 0xFC42), los cursores de cada modo y el bucle: menu 0x22 (0x7DBC), modo elegido (0x52A9) y sus teclas (0x4DED); al acabar, el personaje se guarda (0x6276, 0x6161, 0x64D3)
	call sprites_fuera_vdp		;4d05   ; los sprites fuera
	ld a,(0fa13h)		;4d08   ; cuantos personajes
	ld (0fc44h),a		;4d0b   ; cuantos personajes en el editor
	dec a			;4d0e   ; uno?
	ld de,0fa12h		;4d0f   ; el numero de personaje
	ld a,(de)			;4d12
	jr nz,personaje_editor_va		;4d13   ; no: tal cual
	dec a			;4d15
	ld a,(de)			;4d16
	jr z,personaje_editor_va		;4d17   ; el primero
	ld hl,0fbfeh		;4d19   ; la tabla de sprites...
	ld bc,02020h		;4d1c   ; ...32 pares
personaje_editor_sube:
	ld a,(hl)			;4d1f   ; el sprite
	cp c			;4d20   ; por debajo de 0x20...
	jr nc,personaje_editor_sig		;4d21
	inc (hl)			;4d23   ; ...uno mas
personaje_editor_sig:
	inc hl			;4d24
	inc hl			;4d25
	djnz personaje_editor_sube		;4d26   ; el siguiente
	ld a,001h		;4d28   ; el personaje 1
	ld (de),a			;4d2a
personaje_editor_va:
	dec a			;4d2b
	ld (0fc41h),a		;4d2c   ; el personaje (desde 0)
	call personaje_ficha		;4d2f   ; su ficha
	inc hl			;4d32
	ld a,(hl)			;4d33
	ld (0fc43h),a		;4d34   ; su primer dibujo
	ld bc,00009h		;4d37
	add hl,bc			;4d3a
	ld a,(hl)			;4d3b
	ld (0fc42h),a		;4d3c   ; el otro
	xor a			;4d3f   ; a 0...
	ld (0fc45h),a		;4d40   ; cambiado?
	ld (0fbd0h),a		;4d43   ; la rejilla
	ld (0fc49h),a		;4d46   ; el dibujo mostrado
	ld (0fc4ah),a		;4d49   ; el de antes
	ld (0fe71h),a		;4d4c   ; con tableta
	call cursores_cero		;4d4f   ; los cursores a 0
	ld a,003h		;4d52   ; la clase de editor: 3
	ld (0fe6ch),a		;4d54   ; la clase de editor
	call pantalla_texto_limpia		;4d57   ; la pantalla de texto limpia
	call personaje_cuadro		;4d5a
	call sprite_libre		;4d5d
	adc a,000h		;4d60   ; C a 0 o 1
	ld (0fc40h),a		;4d62   ; 0xFC40
	ld a,0ffh		;4d65   ; 0xFF: nada
	ld (0fc46h),a		;4d67   ; el dibujo en el editor
	xor a			;4d6a
	call dibujo_cambia		;4d6b
personaje_editor_menu:
	call sprites_dibujos_cero		;4d6e   ; los dibujos de sprite 0x1E80 a 0
	call personaje_numeros		;4d71
	xor a			;4d74   ; 0xFBD3 a 0
	ld (0fbd3h),a		;4d75   ; copiando
	ld (0fe5fh),a		;4d78   ; sin cursores
	ld (0fe13h),a		;4d7b   ; con escritura
	ld a,002h		;4d7e   ; 0xFE5E = 2
	ld (0fe5eh),a		;4d80   ; el parpadeo del personaje
	call letras_texto		;4d83   ; las letras de la BIOS
	call dibujos_menu		;4d86
	ld a,022h		;4d89   ; el menu 0x22
	ld (0fa1ah),a		;4d8b   ; el menu
	call menu		;4d8e   ; el menu: C = la opcion
	xor a			;4d91   ; 0xFA1C a 0
	ld (0fa1ch),a		;4d92   ; la clase de eleccion
	ld b,c			;4d95
	push bc			;4d96
	push bc			;4d97
	call rejilla_numeros		;4d98   ; los numeros de las filas
	call cursores_cero		;4d9b   ; los cursores a 0
	ld de,(0fc49h)		;4d9e   ; el dibujo mostrado
	ld a,(0fc46h)		;4da2   ; 0xFC46...
	inc a			;4da5   ; ...0xFF?
	jr z,personaje_editor_modo		;4da6
	ld a,(0fc41h)		;4da8   ; el personaje del editor
	ld d,a			;4dab
	call dibujo_al_editor		;4dac   ; el personaje, a los sprites
	ld a,e			;4daf
	call personaje_muestra		;4db0
personaje_editor_modo:
	xor a			;4db3
	call dibujo_cambia		;4db4
	call personaje_numeros		;4db7   ; los sprites del personaje
	pop af			;4dba   ; la opcion
	ld hl,052a9h		;4dbb   ; la tabla de los modos
	call salta_tabla		;4dbe   ; a su rutina: HL = sus cursores
	pop bc			;4dc1
	add hl,bc			;4dc2
	ld (0fe6dh),hl		;4dc3   ; el modo del editor
	call editor_teclas		;4dc6   ; sus teclas
	xor a			;4dc9
	ld (0fbd0h),a		;4dca   ; la rejilla
	ld a,(0fc46h)		;4dcd   ; el dibujo en el editor
	inc a			;4dd0
	jr z,personaje_editor_menu		;4dd1   ; sin personaje: otra vez el menu
	ld de,(0fc49h)		;4dd3   ; el dibujo mostrado
	ld a,(0fc41h)		;4dd7   ; el personaje del editor
	ld d,a			;4dda
	call dibujo_del_editor		;4ddb   ; lo hecho, a la ficha
	call personaje_sprites		;4dde
	call personaje_guarda		;4de1
	call objeto_sprites_pon		;4de4
	jr personaje_editor_menu		;4de7   ; otra vez el menu
tabla_salta:		; Salta a la rutina A (x 2) de la tabla HL (jp 0x7AB8)
	add a,a			;4de9
	jp hl_mas_a		;4dea
editor_teclas:		; Las teclas de un modo del editor (0xFE6D): con el buffer vacio, cada vez la lista de teclas del modo (0x52B9); los cursores encendidos mientras se espera (0x7B34); con 0xFE71, el cursor del raton/palanca se mueve a la posicion nueva (0x586C) si se ha ido 2 o mas; despues la rutina de la tecla en la lista (0x4E55); 0x0F (volver) acaba (0x4E6F)
	ld a,0ffh		;4ded   ; 0xFE10 a 0xFF
	ld (0fe10h),a		;4def   ; volver con 0x0F
	call buffer_inicio		;4df2   ; el buffer vacio
editor_teclas_bucle:
	ld a,(0fe6dh)		;4df5   ; el modo
	ld hl,052b9h		;4df8   ; las teclas de cada modo
	call tabla_salta		;4dfb   ; su lista
	call palabra_lee		;4dfe
	push hl			;4e01
	call cursores_pon		;4e02   ; los cursores
	call tecla_espera		;4e05   ; una tecla
	push af			;4e08
	push bc			;4e09
	push hl			;4e0a
	call cursores_quita		;4e0b   ; los cursores fuera
	pop hl			;4e0e
	pop bc			;4e0f
	ld a,(0fe71h)		;4e10   ; 0xFE71?
	and a			;4e13
	jr z,editor_teclas_codigo		;4e14
	inc h			;4e16
	jr z,editor_teclas_codigo		;4e17
	dec h			;4e19
	ld de,(0fe34h)		;4e1a   ; la posicion de antes
	ld (0fe34h),hl		;4e1e   ; la nueva
	inc b			;4e21
	dec b			;4e22
	jr z,editor_teclas_x		;4e23
	ld de,0ffffh		;4e25   ; 0xFFFF: ninguna
	ld (0fe34h),de		;4e28   ; la posicion de la tableta
	jr editor_teclas_mueve		;4e2c
editor_teclas_x:
	ld a,d			;4e2e   ; Y de antes - Y nueva
	sub h			;4e2f
	jr z,editor_teclas_y		;4e30
	jp p,editor_teclas_x2		;4e32
	neg		;4e35   ; sin signo
editor_teclas_x2:
	cp 002h		;4e37   ; 2 o mas?
	jr nc,editor_teclas_mueve		;4e39
editor_teclas_y:
	ld a,e			;4e3b   ; X de antes - X nueva
	sub l			;4e3c
	jr z,editor_teclas_codigo		;4e3d
	jp p,editor_teclas_y2		;4e3f
	neg		;4e42
editor_teclas_y2:
	cp 002h		;4e44
	jr c,editor_teclas_codigo		;4e46
editor_teclas_mueve:
	call tableta_mueve		;4e48   ; a la posicion nueva
editor_teclas_codigo:
	pop af			;4e4b
	pop hl			;4e4c
	jr z,editor_teclas_bucle		;4e4d   ; sin tecla: otra vez
	res 7,a		;4e4f   ; sin el bit 7
	cp 00fh		;4e51   ; 0x0F: volver?
	jr z,editor_teclas_fin		;4e53
editor_teclas_busca:
	cp (hl)			;4e55   ; su umbral
	inc hl			;4e56
	jr c,editor_teclas_rutina		;4e57   ; por debajo: esta
	inc hl			;4e59   ; la siguiente
	inc hl			;4e5a
	jr editor_teclas_busca		;4e5b
editor_teclas_rutina:
	push af			;4e5d
	call palabra_lee		;4e5e   ; su rutina
	pop af			;4e61
	call salta_hl		;4e62   ; a ella
	ld a,(0fe6ch)		;4e65   ; el editor de personajes?
	cp 003h		;4e68
	call z,personaje_numeros		;4e6a   ; sus sprites otra vez
	jr editor_teclas_bucle		;4e6d
editor_teclas_fin:
	ld a,(0fe6ch)		;4e6f   ; la clase de editor
	cp 001h		;4e72   ; 1?
	call z,laberinto_dibujos		;4e74
	ld a,(0fe6eh)		;4e77   ; el modo
	cp 014h		;4e7a   ; 0x14?
	jr z,editor_fin_fondo		;4e7c
	cp 004h		;4e7e   ; 4?
	jr nz,editor_fin		;4e80
	ld a,038h		;4e82   ; la tecla 0x38
	jr editor_teclas_busca		;4e84
editor_fin_fondo:		; Al acabar el modo 0x14: el fondo elegido (0xFBD5 -> 0xFBE6), sin desplazar y el mapa del principio
	ld a,(0fbd5h)		;4e86   ; el fondo
	ld (0fbe6h),a		;4e89   ; el fondo
	xor a			;4e8c   ; sin desplazar
	ld (0fbeeh),a		;4e8d   ; la fila partida
	ld hl,(0f7edh)		;4e90   ; el mapa de 0xF7ED
	ld (0fbe8h),hl		;4e93   ; el mapa de trabajo
editor_fin:
	xor a			;4e96   ; 0xFE10 a 0
	ld (0fe10h),a		;4e97   ; volver con 0x0F
	ret			;4e9a
modo_puntos:		; Modo del editor (bits 3 y 4 de su byte): el cursor a 0, sin posicion, 0xFE36 = 1, la paleta (0x50F5) y 0x54AA, con escritura (0xFE13 = 1, 0xFE71 = 1); HL = 0
	ex de,hl			;4e9b
	set 3,(hl)		;4e9c   ; la marca...
	set 4,(hl)		;4e9e
	call cursores_cero		;4ea0   ; los cursores a 0
	ld hl,0ffffh		;4ea3   ; sin posicion
	ld (0fe34h),hl		;4ea6   ; la posicion de la tableta
	ld a,001h		;4ea9
	ld (0fe36h),a		;4eab
	call paleta_pinta		;4eae   ; la paleta
	call editor_pinta		;4eb1
	ld a,001h		;4eb4   ; con escritura
	ld (0fe13h),a		;4eb6   ; con escritura
	cp 0afh		;4eb9
	ld (0fe71h),a		;4ebb   ; con tableta
	ld hl,00000h		;4ebe
	ret			;4ec1
modo_otro:		; Modo del editor (bit 7): los cursores a 0, 0xFBD3 = 0xFF, con escritura y 0x5545 con A = 0
	ex de,hl			;4ec2
	set 7,(hl)		;4ec3
	call cursores_cero		;4ec5
	ld a,0ffh		;4ec8
	ld (0fbd3h),a		;4eca   ; copiando
	ld (0fe13h),a		;4ecd   ; con escritura
	xor a			;4ed0
	call cursor_casilla_paso		;4ed1
	jr $-26		;4ed4
modo_0404:		; El modo del editor 0x0404 (0xFE6D)
	ld hl,00404h		;4ed6
	ld (0fe6dh),hl		;4ed9   ; el modo del editor
	ret			;4edc
cursores_cero:		; Los 8 bytes de los cursores (0xFBC3-0xFBCA) a 0
	ld hl,0fbc3h		;4edd
	ld b,008h		;4ee0
	jp cero_b		;4ee2
cursores_inicio:		; Los cursores: el de casilla en 8,8 (0xFBC3) y el de punto en 1,1 (0xFBC5)
	ld hl,00808h		;4ee5
	ld (0fbc3h),hl		;4ee8   ; el cursor de dentro
	ld hl,00101h		;4eeb
	ld (0fbc5h),hl		;4eee   ; el cursor de casilla
	ret			;4ef1
fondo_nada:		; 0xFBE6 = 0xFF (sin fondo)
	ld a,0ffh		;4ef2
	ld (0fbe6h),a		;4ef4   ; el fondo
	jr modo_cursores_fondo		;4ef7
modo_fondo_dibuja:		; Modo del editor de fondos (bits 7 y 5): 0xFBF5 = 0, el dibujo preparado (0x4F35)
	ex de,hl			;4ef9
	set 7,(hl)		;4efa
	set 5,(hl)		;4efc
	xor a			;4efe
	ld (0fbf5h),a		;4eff   ; copiando el fondo
	call modo_fondo_prepara		;4f02
modo_fondo_casilla:
	ld a,(0fbf4h)		;4f05   ; la casilla elegida
	call pantalla_pon		;4f08
	ld a,001h		;4f0b   ; con escritura
	ld (0fe13h),a		;4f0d   ; con escritura
modo_cursores_fondo:		; HL = 0x0A05 (los cursores) o, con el fondo de 5 o mas (0xF418), 0x0505
	ld hl,00a05h		;4f10
	ld a,(0f418h)		;4f13   ; el fondo
	cp 005h		;4f16
	ret c			;4f18
	ld h,l			;4f19
	ret			;4f1a
modo_fondo_sigue:
	call fondo_rotulo		;4f1b
	jr modo_cursores_fondo		;4f1e
modo_fondo_copia:		; Modo del editor de fondos (bits 3 y 5): 0xFBF5 = 1, lo de 0x4F35 y la casilla de 0xFBEE (0x5A5B)
	ex de,hl			;4f20
	set 3,(hl)		;4f21
	set 5,(hl)		;4f23
	ld a,001h		;4f25
	ld (0fbf5h),a		;4f27   ; copiando el fondo
	call modo_fondo_prepara		;4f2a
	ld hl,(0fbeeh)		;4f2d   ; la fila partida
	call casilla_dibujo		;4f30
	jr modo_fondo_casilla		;4f33
modo_fondo_prepara:		; Los cursores al principio, 0x5A21, 0x54AA, 0x5CE0 y 0x5545 con A = 0
	call cursores_inicio		;4f35   ; los cursores
	call casilla_cursor		;4f38   ; la casilla
	call editor_pinta		;4f3b   ; la pantalla
	call paleta_casillas		;4f3e   ; la paleta
	xor a			;4f41
	jp cursor_casilla_paso		;4f42   ; el cursor
modo_fondo_nada:
	call fondo_nada		;4f45
	jr modo_cursores_mapa		;4f48
modo_fondo_pared:		; Los modos de colocar casillas: con los bytes que siguen, el 0x6F (0x4F4A), 0x70 (0x4F4D), 0x71 (0x4F50), 0x72 (0x4F53) o 0x73 (0x4F56) a 0xFBEF; los cursores al principio, 0x5A9D, los colores (0x5648), 0x54AA y 0x5545
	ld a,06fh		;4f4a   ; la casilla 0x6F; desde 0x4F4D, la 0x70; desde 0x4F50, la 0x71...
	ld hl,0703eh		;4f4c
	ld hl,0713eh		;4f4f
	ld hl,0723eh		;4f52
	ld hl,0733eh		;4f55
	ex de,hl			;4f58
	set 7,(hl)		;4f59   ; la marca del modo
	ld (0fbefh),a		;4f5b   ; la casilla
	call cursores_inicio		;4f5e
	call mapa_posicion		;4f61
	call colores_paleta		;4f64
	call editor_pinta		;4f67
	xor a			;4f6a
	call cursor_casilla_paso		;4f6b
modo_fondo_escribe:
	ld a,001h		;4f6e
	ld (0fe13h),a		;4f70   ; con escritura
modo_cursores_mapa:		; 0x5FC0 y HL = 0x160A (los cursores) o, con el fondo de 5 o mas, 0x0E0A
	call laberinto_pinta		;4f73
	ld hl,0160ah		;4f76
	ld a,(0f418h)		;4f79   ; el fondo (1 uno, 4 tres, 5-9 se desplaza)
	cp 005h		;4f7c
	ret c			;4f7e
	ld h,00eh		;4f7f
	ret			;4f81
modo_fondo_arregla:		; Modo del editor de fondos (bits 7 y 3): los cursores al principio, 0x5A21, el fondo de 0xFBE6 a 0xFBD5, sin fondo, 0xFBF5 = 0, la casilla 0xFBF4 a 0xFBEF, 0x5A97, los colores, 0x5545 y 0x54AA
	ex de,hl			;4f82
	set 7,(hl)		;4f83
	set 3,(hl)		;4f85
	call cursores_inicio		;4f87
	call casilla_cursor		;4f8a
	ld a,(0fbe6h)		;4f8d   ; el fondo
	ld (0fbd5h),a		;4f90   ; el fondo elegido
	call fondo_nada		;4f93
	xor a			;4f96
	ld (0fbf5h),a		;4f97   ; copiando el fondo
	ld a,(0fbf4h)		;4f9a   ; la casilla de debajo
	ld (0fbefh),a		;4f9d   ; la casilla elegida
	call pantalla_pon		;4fa0
	call colores_paleta		;4fa3
	xor a			;4fa6
	call cursor_casilla_paso		;4fa7
	call editor_pinta		;4faa
	jr modo_fondo_escribe		;4fad
modo_mapa_sigue:
	call fondo_rotulo		;4faf
	jr modo_cursores_mapa		;4fb2
modo_personaje_dibuja:		; Modo del editor de personajes: la pantalla limpia, la rejilla (0x51AC), 0x6AFA, 0xFBD0 = 0xF0, el cursor de casilla (0xFE5F = 8), con escritura y sin posicion
	call pantalla_texto_limpia		;4fb4
	call rejilla_pinta		;4fb7
	call rejilla_dibujo		;4fba
	ld a,0f0h		;4fbd
	ld (0fbd0h),a		;4fbf   ; la rejilla
	ld a,008h		;4fc2
	ld (0fe5fh),a		;4fc4   ; los cursores
	ld a,001h		;4fc7
	ld (0fe5eh),a		;4fc9   ; el parpadeo del personaje
	ld (0fe36h),a		;4fcc
	ld (0fe13h),a		;4fcf   ; con escritura
	ld hl,0ffffh		;4fd2
	ld (0fe34h),hl		;4fd5   ; la posicion de la tableta
modo_cursores_pers:		; HL = 0x3712 (los cursores)
	ld hl,03712h		;4fd8
	ret			;4fdb
modo_personaje_ver:		; Modo del editor de personajes: la pantalla limpia, el bit 6 de 0xFE5F, 0xFC4C a 0, los colores (0x69E3) y los numeros (0x5266)
	call pantalla_texto_limpia		;4fdc
	ld hl,0fe5fh		;4fdf
	set 6,(hl)		;4fe2
	ld hl,00000h		;4fe4
	ld (0fc4ch),hl		;4fe7   ; el cursor de las muestras
	call muestras_pinta		;4fea
	call rejilla_numeros		;4fed
	jr modo_cursores_pers		;4ff0
modo_personaje_otro:		; Modo del editor de personajes: la pantalla limpia, la rejilla, 0x6AFA, 0xFBD0 = 0xF0, con escritura
	call pantalla_texto_limpia		;4ff2
	call rejilla_pinta		;4ff5
	call rejilla_dibujo		;4ff8
	ld a,0f0h		;4ffb
	ld (0fbd0h),a		;4ffd   ; la rejilla
	ld a,001h		;5000
	ld (0fe5eh),a		;5002   ; el parpadeo del personaje
	ld (0fe13h),a		;5005   ; con escritura
	jr modo_cursores_pers		;5008
modo_personaje_cero:		; 0xFBCB y 0xFC4B a 0
	xor a			;500a
	ld h,a			;500b
	ld l,a			;500c
	ld (0fbcbh),hl		;500d   ; el primer punto
	ld (0fc4bh),a		;5010   ; el dibujo de origen
	jr modo_cursores_pers		;5013
fondo_unico_prepara:		; El fondo de un juego de tipo 0x11 (un fondo): la primera vez (0xFBD4 = 0), los colores de SCREEN 2 (0x2000, 0x1800 bytes) con el color de 0x5821, los dibujos 0x800-0x17FF a 0 y los 8 de 0xF7EB a 0; la clase de editor 0
	ld a,(0fbd4h)		;5015   ; la primera vez?
	and a			;5018
	ld a,000h		;5019
	jr nz,editor_clase		;501b
	ld hl,02000h		;501d   ; los colores...
	ld bc,01800h		;5020   ; ...0x1800 bytes...
	call color_borde		;5023   ; ...el color
	call 00056h		;5026   ; FILVRM
	ld hl,00800h		;5029   ; los dibujos...
	ld bc,01000h		;502c   ; ...0x1000 bytes...
	xor a			;502f   ; ...a 0
	call 00056h		;5030   ; FILVRM
	ld hl,(0f7ebh)		;5033   ; los dibujos de las casillas (RAM)
	ld bc,00008h		;5036
fondo_unico_cero:
	call cero_b		;5039
	dec c			;503c
	jr nz,fondo_unico_cero		;503d
	xor a			;503f
editor_clase:		; La clase de editor (0xFE6C) = A
	ld (0fe6ch),a		;5040   ; la clase de editor
	ret			;5043
editor_clase_tipo:		; Prepara el editor segun la clase de juego A: 0x11, 0x5015; 0x20 o mas (laberinto), 0x504C; si no, 0x5053
	cp 011h		;5044   ; un fondo?
	jr z,fondo_unico_prepara		;5046
	cp 020h		;5048   ; laberinto?
	jr c,editor_casillas		;504a
editor_laberinto:		; El editor del laberinto: el mapa (0x5091) y la clase de editor 1
	call mapa_laberinto		;504c
	ld a,001h		;504f
	jr editor_clase		;5051
editor_casillas:		; El editor de casillas (combate con 3 fondos o con desplazamiento): 0xFBF8-0xFBFA a 0, la casilla 0x58, el mapa (0x5095), 32 bytes de dibujo 0x848 a 0 y (la primera vez) sus colores; con la clase 0x18, 0x5E02; las casillas de 0x0203 (0x58B7) y la clase de editor 2
	xor a			;5053
	ld h,a			;5054
	ld l,a			;5055
	ld (0fbf8h),hl		;5056   ; el cursor de la paleta
	ld (0fbfah),a		;5059   ; el desplazamiento de la paleta
	ld a,058h		;505c   ; la casilla 0x58
	ld (0fbefh),a		;505e   ; la casilla elegida
	call mapa_casillas		;5061
	ld hl,00848h		;5064   ; los dibujos de 0x848...
	ld bc,00020h		;5067
	xor a			;506a
	call 00056h		;506b   ; FILVRM
	ld a,(0fbd4h)		;506e   ; la primera vez?
	and a			;5071
	jr nz,editor_casillas_clase		;5072
	ld hl,02848h		;5074   ; sus colores a 0
	ld a,000h		;5077
	ld bc,00020h		;5079
	call 00056h		;507c   ; FILVRM
editor_casillas_clase:
	ld a,(0f421h)		;507f   ; la clase de juego
	cp 018h		;5082   ; 0x18: tres fondos?
	call z,fondo3_color		;5084
	ld hl,00203h		;5087
	call casillas_copia		;508a
	ld a,002h		;508d
	jr editor_clase		;508f
mapa_laberinto:		; El mapa lleno de 0x70 (0x5097)
	ld b,070h		;5091
	jr mapa_llena		;5093
mapa_casillas:		; El mapa lleno de 0x0C
	ld b,00ch		;5095
mapa_llena:		; La primera vez (0xFBD4 = 0): 0x50E7, hace sitio a 0x210 bytes (0xA242), baja el principio del mapa (0xF7ED, 0xFBEA, 0xFBE8) y lo llena con B; 0x5170 y 0x6ECA
	ld a,(0fbd4h)		;5097   ; la primera vez?
	and a			;509a
	ret nz			;509b
	push bc			;509c
	call casillas_prepara		;509d
	ld bc,00210h		;50a0   ; 0x210 bytes
	push bc			;50a3
	call ram_pide_mapa		;50a4   ; sitio en la RAM
	pop bc			;50a7
	ld hl,(0f7edh)		;50a8   ; el mapa...
	and a			;50ab
	sbc hl,bc		;50ac   ; ...baja 0x210
	ld (0f7edh),hl		;50ae   ; el principio del mapa
	ld (0fbeah),hl		;50b1   ; el ultimo trozo del mapa
	ld (0fbe8h),hl		;50b4   ; el mapa de trabajo
	pop de			;50b7
mapa_llena_uno:
	ld (hl),d			;50b8   ; la casilla
	dec bc			;50b9   ; uno menos
	ld a,b			;50ba
	or c			;50bb
	inc hl			;50bc
	jr nz,mapa_llena_uno		;50bd
	call letras_graficos		;50bf
	jp casillas_fijas		;50c2
dibujos_menu:		; Los 0xC0 bytes de 0xA7C1 (dibujos de las letras del menu) en la VRAM 0x40
	ld hl,0a7c1h		;50c5
	ld de,00040h		;50c8
	ld bc,000c0h		;50cb
	jp ldirvm_mas		;50ce
editor_prepara:		; El mapa de trabajo (0xFBE8 = 0xF7ED); la primera vez, tambien 0xFBEA y 0xFBE6, 0xFBFC a 0; despues 0x50E7
	ld hl,(0f7edh)		;50d1   ; el principio del mapa
	ld (0fbe8h),hl		;50d4   ; el mapa de trabajo
	ld a,(0fbd4h)		;50d7   ; ya preparado
	and a			;50da
	jr nz,casillas_prepara		;50db
	ld (0fbeah),hl		;50dd   ; el ultimo trozo del mapa
	xor a			;50e0
	ld (0fbe6h),a		;50e1   ; el fondo
	ld (0fbfch),a		;50e4   ; cuantos fondos
casillas_prepara:		; 0xFBEC = 0xF7EB (los dibujos de las casillas) y 0xFBEE, 0xFBFB a 0
	ld hl,(0f7ebh)		;50e7   ; los dibujos de las casillas (RAM)
	ld (0fbech),hl		;50ea   ; el final del mapa
	xor a			;50ed
	ld (0fbeeh),a		;50ee   ; la fila partida
	ld (0fbfbh),a		;50f1   ; el fondo de ahora
	ret			;50f4
paleta_pinta:		; La paleta del editor de dibujo: los colores (0x5648), dos filas de sprites de color 1 (0x10B8, 0x11B8; 0x56BB), otra de 0xF1 (0x10C0) y los 7 textos de 0x5131 (LINE, BOX, PAINT...) desde la fila 8, columna 0x16, en SCREEN 2
	call colores_paleta		;50f5
	ld a,001h		;50f8
	ld de,010b8h		;50fa
	call dibujos_colores_8		;50fd
	ld de,011b8h		;5100
	call dibujos_colores_8		;5103
	ld a,0f1h		;5106
	ld de,010c0h		;5108
	call dibujo_fila_color		;510b
	ld hl,05131h		;510e   ; los textos
	ld a,007h		;5111   ; siete
	ld bc,00816h		;5113   ; fila 8, columna 0x16
paleta_texto:
	push af			;5116
	push bc			;5117
paleta_letra:
	ld a,(hl)			;5118
	inc hl			;5119
	and a			;511a
	jr z,paleta_texto_fin		;511b   ; el 0: acaba
	ld e,a			;511d
	ld d,0f1h		;511e   ; blanco sobre negro
	push bc			;5120
	push hl			;5121
	call letra_pon_screen2		;5122
	pop hl			;5125
	pop bc			;5126
	inc c			;5127
	jr paleta_letra		;5128
paleta_texto_fin:
	pop bc			;512a
	inc b			;512b   ; la fila siguiente
	pop af			;512c
	dec a			;512d
	jr nz,paleta_texto		;512e
	ret			;5130

; ----------------------------------------------------------------------
; DATOS paleta_textos: Los siete rotulos de las herramientas del editor de
;   dibujo, cada uno con su 0: LINE, BOX, BOXFILL, CIRCLE, PAINT, H-LINE y
;   V-LINE (los pinta paleta_pinta, 0x510E)
;   0x5131..0x5170  (63 bytes)
DATA_paleta_textos:
	defb 020h,04ch,049h,04eh,045h,020h,020h,020h,000h,020h,042h,04fh,058h,020h,020h,020h	; 5131   LINE   . BOX   
	defb 020h,000h,020h,042h,04fh,058h,046h,049h,04ch,04ch,000h,020h,043h,049h,052h,043h	; 5141   . BOXFILL. CIRC
	defb 04ch,045h,020h,000h,020h,050h,041h,049h,04eh,054h,020h,020h,000h,020h,048h,02dh	; 5151  LE . PAINT  . H-
	defb 04ch,049h,04eh,045h,020h,000h,020h,056h,02dh,04ch,049h,04eh,045h,020h,000h	; 5161  LINE . V-LINE .

; ======================================================================
; CODIGO 0x5170..0x5287  (279 bytes)
; ======================================================================


letras_graficos:		; Las letras de la BIOS (0x0004 + 0x180, 0x158 bytes) en la VRAM 0x900 y sus colores 0xF1 (0x2900); 16 bytes en 0x880 y 0x888 y las casillas 0x0203 (0x58B7)
	ld hl,(00004h)		;5170   ; la fuente de la BIOS...
	ld de,00180h		;5173   ; ...desde la letra 0x30
	add hl,de			;5176
	ld de,00900h		;5177
	ld bc,00158h		;517a
	call ldirvm		;517d   ; LDIRVM
	ex de,hl			;5180
	add hl,bc			;5181
	ld bc,00008h		;5182
	xor a			;5185
	call 00056h		;5186   ; FILVRM
	ld a,0f1h		;5189   ; blanco sobre negro
	ld hl,02900h		;518b
	ld bc,00160h		;518e
	call 00056h		;5191   ; FILVRM
	ld a,001h		;5194
	ld de,00880h		;5196
	ld b,010h		;5199
	call dibujos_colores		;519b
	ld de,00888h		;519e
	ld a,0f1h		;51a1
	call dibujo_fila_color		;51a3
	ld hl,00203h		;51a6
	jp casillas_copia		;51a9
rejilla_pinta:		; La rejilla del editor de personajes en la pantalla de texto: los dibujos 0-0x0F, 0x40, 0x68 y 0x80 de la VRAM, los colores (0x2090), las 24 filas de 30 casillas 0x0D desde 0x3C01, el marco (0x08 y 0x10) y los numeros (0x5266)
	ld hl,00000h		;51ac
	ld bc,00008h		;51af
	xor a			;51b2
	call 00056h		;51b3   ; FILVRM
	ld bc,00008h		;51b6
	add hl,bc			;51b9
	dec a			;51ba
	call 00056h		;51bb   ; FILVRM
	ld hl,00040h		;51be
	ld bc,00008h		;51c1
	ld a,0ffh		;51c4
	call 00056h		;51c6   ; FILVRM
	ld hl,00068h		;51c9
	ld bc,00008h		;51cc
	xor a			;51cf
	call 00056h		;51d0   ; FILVRM
	ld hl,00080h		;51d3
	ld bc,00040h		;51d6
	xor a			;51d9
	call 00056h		;51da   ; FILVRM
	ld hl,02090h		;51dd
	ld de,0fbb1h		;51e0
	ld bc,00010h		;51e3
	push bc			;51e6
	push de			;51e7
	push hl			;51e8
	call ldirmv_mas		;51e9   ; a la RAM
	ld de,00090h		;51ec
	ld b,002h		;51ef
	call dibujos_colores		;51f1
	ld de,000c8h		;51f4
	ld b,002h		;51f7
	call dibujos_colores		;51f9
	pop de			;51fc
	pop hl			;51fd
	pop bc			;51fe
	call ldirvm_mas		;51ff   ; y de vuelta
	ld hl,000c0h		;5202
	ld de,056fbh		;5205
	ld b,008h		;5208
	call dibujo_invertido		;520a
	ld hl,00088h		;520d
	call dibujo_invertido_8		;5210
	ld hl,000d8h		;5213
	call dibujo_invertido_8		;5216
	ld hl,03f00h		;5219
	ld a,040h		;521c
	call 0004dh		;521e   ; WRTVRM
	inc hl			;5221
	ld a,0f1h		;5222
	call 0004dh		;5224   ; WRTVRM
	ld de,00020h		;5227
	ld hl,03c01h		;522a   ; desde 0x3C01
	ld b,018h		;522d   ; 24 filas
	ld a,00dh		;522f   ; la casilla 0x0D
rejilla_fila:
	push bc			;5231
	ld bc,0001eh		;5232   ; 30
	call 00056h		;5235   ; FILVRM
	add hl,de			;5238   ; la fila siguiente
	pop bc			;5239
	djnz rejilla_fila		;523a
	ld hl,03c62h		;523c
	ld bc,00012h		;523f
	ld a,008h		;5242   ; la casilla 8: el borde de arriba
	call 00056h		;5244   ; FILVRM
	ld bc,01008h		;5247   ; 16 filas, la casilla 0x10
rejilla_borde:
	ld de,00020h		;524a
	add hl,de			;524d
	ld e,011h		;524e
	push hl			;5250
	ld a,c			;5251
	call 0004dh		;5252   ; WRTVRM: a la izquierda
	add hl,de			;5255
	ld a,c			;5256
	call 0004dh		;5257   ; WRTVRM: a la derecha
	pop hl			;525a
	djnz rejilla_borde		;525b
	ld e,020h		;525d
	add hl,de			;525f
	ld bc,00012h		;5260
	call 00056h		;5263   ; FILVRM: el borde de abajo
rejilla_numeros:		; Los numeros 9-0x0C en la columna 0x14 de las filas 4, 9, 14 y 19 (0x3C94, cada 0xA0)
	ld bc,00409h		;5266
	ld de,000a0h		;5269
	ld hl,03c94h		;526c
rejilla_numero:
	ld a,c			;526f
	call 0004dh		;5270   ; WRTVRM
	add hl,de			;5273
	inc c			;5274
	djnz rejilla_numero		;5275
	ret			;5277
dibujo_invertido_8:		; 8 bytes de 0x56F3 dados la vuelta a la VRAM de HL
	ld b,008h		;5278
	ld de,056f3h		;527a
dibujo_invertido:
	ld a,(de)			;527d
	cpl			;527e   ; dado la vuelta
	call 0004dh		;527f   ; WRTVRM
	inc hl			;5282
	inc de			;5283
	djnz dibujo_invertido		;5284
	ret			;5286

; ----------------------------------------------------------------------
; DATOS editor_tablas2: Las tablas del editor: las rutinas de cada modo por
;   clase de editor (0x5287, 0x5299 y 0x528F, por 0x4CE6), las del editor de
;   personajes (0x52A9, por la opcion del menu 0x22) y, desde 0x52B9, los
;   punteros de las listas de teclas de cada modo (0xFE6D) y las listas
;   (umbral de tecla y rutina, hasta 0xFF) que lee editor_teclas (0x4DF8)
;   0x5287..0x5400  (377 bytes)
DATA_editor_tablas2:
	defb 000h,000h,09bh,04eh,0c2h,04eh,0bah,04eh,01bh,04fh,0f9h,04eh,020h,04fh,010h,04fh	; 5287  ...N.N.N.O.N O.O
	defb 0f2h,04eh,0afh,04fh,04ah,04fh,04dh,04fh,050h,04fh,053h,04fh,056h,04fh,082h,04fh	; 5297  .N.OJOMOPOSOVO.O
	defb 045h,04fh,000h,000h,0b4h,04fh,0dch,04fh,0d8h,04fh,0d8h,04fh,0f2h,04fh,0d8h,04fh	; 52a7  EO...O.O.O.O.O.O
	defb 00ah,050h,000h,000h,0edh,052h,002h,053h,011h,053h,01ah,053h,032h,053h,03bh,053h	; 52b7  .P...R.S.S.S2S;S
	defb 053h,053h,062h,053h,032h,053h,032h,053h,06bh,053h,06bh,053h,06bh,053h,06bh,053h	; 52c7  SSbS2S2SkSkSkSkS
	defb 06bh,053h,083h,053h,032h,053h,000h,000h,092h,053h,0a1h,053h,0b3h,053h,0c2h,053h	; 52d7  kS.S2S...S.S.S.S
	defb 0d1h,053h,0dfh,053h,0eeh,053h,010h,064h,044h,018h,0d0h,055h,020h,0d7h,055h,030h	; 52e7  .S.S.S.dD..U .U0
	defb 0a2h,054h,038h,064h,044h,040h,041h,057h,0ffh,064h,044h,010h,064h,044h,018h,0d7h	; 52f7  .T8dD@AW.dD.dD..
	defb 055h,030h,064h,044h,038h,003h,057h,0ffh,064h,044h,00eh,064h,044h,00fh,000h,054h	; 5307  U0dD8.W.dD.dD..T
	defb 0ffh,064h,044h,00eh,064h,044h,00fh,0a0h,057h,010h,064h,044h,018h,0d0h,055h,020h	; 5317  .dD.dD..W.dD..U 
	defb 0d7h,055h,038h,064h,044h,040h,041h,057h,0ffh,064h,044h,010h,064h,044h,018h,051h	; 5327  .U8dD@AW.dD.dD.Q
	defb 05dh,0ffh,064h,044h,00bh,064h,044h,00ch,00eh,05bh,00dh,084h,05bh,010h,064h,044h	; 5337  ].dD.dD..[..[.dD
	defb 018h,0adh,059h,020h,060h,05ch,030h,0a5h,059h,0ffh,064h,044h,010h,064h,044h,018h	; 5347  ..Y `\0.Y.dD.dD.
	defb 08eh,059h,020h,060h,05ch,030h,059h,059h,0ffh,064h,044h,00eh,064h,044h,00fh,0eeh	; 5357  .Y `\0YY.dD.dD..
	defb 058h,0ffh,064h,044h,00bh,064h,044h,00ch,00eh,05bh,00dh,084h,05bh,010h,064h,044h	; 5367  X.dD.dD..[..[.dD
	defb 018h,048h,05fh,020h,064h,044h,030h,040h,05fh,0ffh,064h,044h,010h,064h,044h,018h	; 5377  .H_ dD0@_.dD.dD.
	defb 08eh,059h,020h,055h,05fh,030h,059h,059h,0ffh,064h,044h,010h,064h,044h,018h,061h	; 5387  .Y U_0YY.dD.dD.a
	defb 066h,020h,023h,065h,030h,0f7h,065h,0ffh,064h,044h,00eh,064h,044h,00fh,0bdh,06ah	; 5397  f #e0.e.dD.dD..j
	defb 010h,064h,044h,018h,048h,06ah,020h,023h,065h,0ffh,064h,044h,00eh,064h,044h,00fh	; 53a7  .dD.Hj #e.dD.dD.
	defb 010h,068h,018h,064h,044h,020h,023h,065h,0ffh,064h,044h,00eh,064h,044h,00fh,0a9h	; 53b7  .h.dD #e.dD.dD..
	defb 067h,018h,064h,044h,020h,023h,065h,0ffh,064h,044h,010h,064h,044h,018h,0d0h,068h	; 53c7  g.dD #e.dD.dD..h
	defb 020h,023h,065h,030h,0f0h,068h,0ffh,064h,00eh,064h,044h,00fh,07ch,067h,018h,064h	; 53d7   #e0.h.d.dD.|g.d
	defb 044h,020h,023h,065h,0ffh,064h,044h,00eh,064h,044h,00fh,0bfh,066h,010h,064h,044h	; 53e7  D #e.dD.dD..f.dD
	defb 018h,013h,067h,020h,023h,065h,0ffh,064h,044h	; 53f7  ..g #e.dD

; ======================================================================
; CODIGO 0x5400..0x56f3  (755 bytes)
; ======================================================================


lienzo_pinta:		; El lienzo del editor de dibujo en SCREEN 2: los colores de las casillas 1 (0x2008, 0x2808, 0x3008) con el borde (0xFA38) de fondo y 15 de tinta; las 24 filas de la tabla de nombres (0x3800) con un 0, 30 casillas 1 y otro 0; los dibujos y colores de las tres partes con 0xB0 bytes cada 0x100 (0x5821); y la tabla de 0xFBC1 hacia atras (31 bytes) a la tabla de nombres de las tres partes (0x5495)
	ld a,(0fa38h)		;5400   ; el color del borde
	ld d,a			;5403
	add a,a			;5404   ; x 16: el fondo
	add a,a			;5405
	add a,a			;5406
	add a,a			;5407
	ld e,a			;5408
	ld a,00fh		;5409   ; tinta 15
	and a			;540b
	or e			;540c
	ld hl,02008h		;540d   ; la casilla 1, en la primera parte
	ld bc,00008h		;5410
	call 00056h		;5413   ; FILVRM
	ld h,028h		;5416   ; en la segunda
	ld bc,00008h		;5418
	push bc			;541b
	call 00056h		;541c   ; FILVRM
	ld h,030h		;541f   ; en la tercera
	pop bc			;5421
	call 00056h		;5422   ; FILVRM
	ld hl,03800h		;5425   ; la tabla de nombres
	ld b,018h		;5428   ; 24 filas
	ld de,0001eh		;542a   ; 30 casillas
lienzo_fila:
	push bc			;542d
	xor a			;542e
	call 0004dh		;542f   ; WRTVRM: la casilla 0 a la izquierda
	ld a,001h		;5432   ; las 30 del lienzo: la casilla 1
	inc hl			;5434
	ld b,d			;5435
	ld c,e			;5436
	call 00056h		;5437   ; FILVRM
	add hl,de			;543a
	xor a			;543b
	call 0004dh		;543c   ; WRTVRM: la casilla 0 a la derecha
	inc hl			;543f
	pop bc			;5440
	djnz lienzo_fila		;5441   ; la fila siguiente
	ld hl,00008h		;5443
	ld de,000b0h		;5446
	ld bc,01800h		;5449
	xor a			;544c
lienzo_tercio:
	push hl			;544d
	push de			;544e
	push bc			;544f
lienzo_franja:
	push bc			;5450
	push af			;5451
	ld b,d			;5452
	ld c,e			;5453
	call 00056h		;5454   ; FILVRM
	inc h			;5457   ; la fila de dibujos siguiente
	pop af			;5458
	pop bc			;5459
	djnz lienzo_franja		;545a
	call color_borde		;545c   ; el color de la parte (0x5821)
	pop bc			;545f
	pop de			;5460
	pop hl			;5461
	bit 5,h		;5462   ; ya en los colores?
	jr nz,lienzo_otro		;5464
	set 5,h		;5466   ; a los colores (0x2000 mas)
	jr lienzo_tercio		;5468
lienzo_otro:
	dec c			;546a   ; la parte siguiente
	jr z,lienzo_nombres		;546b
	xor a			;546d
	ld hl,020b8h		;546e   ; los colores de la columna 0x17
	ld de,00040h		;5471   ; cada 0x40
	ld bc,01801h		;5474   ; 0x18 filas
	jr lienzo_tercio		;5477
lienzo_nombres:		; La lista de casillas de la paleta (0xFBC1 hacia atras): los valores de B (0xFF hacia abajo) que no caen en los bordes de 32 (los multiplos de 32 y los que van detras pasan a 0), y a la tabla de nombres de las tres partes (0x3800, 0x3900, 0x3A00), una casilla
	ld hl,0fbc1h		;5479
	xor a			;547c
	ld bc,0ff1fh		;547d   ; desde 0xFF, 31 = 0x1F
lienzo_nombres_uno:
	ld a,b			;5480
	and c			;5481   ; un multiplo de 32?
	jr z,lienzo_nombres_pon		;5482
	ld a,b			;5484
	inc a			;5485   ; o el siguiente?
	and c			;5486
	jr z,lienzo_nombres_pon		;5487
	ld a,b			;5489   ; la casilla
lienzo_nombres_pon:
	ld (hl),a			;548a
	dec hl			;548b
	djnz lienzo_nombres_uno		;548c
	ld (hl),b			;548e
	ld c,b			;548f
	ld de,03800h		;5490   ; la tabla de nombres
	ld b,003h		;5493   ; tres partes
lienzo_nombres_parte:
	push bc			;5495
	ld b,001h		;5496
	call ldirvm		;5498   ; LDIRVM
	pop bc			;549b
	inc d			;549c   ; la parte siguiente
	djnz lienzo_nombres_parte		;549d
	jp colores_paleta		;549f   ; los colores
cursor_mueve_pinta:		; 0x5723, el cursor un paso (0x54C2) y la pantalla (0x54AA)
	push af			;54a2
	call punto_pinta		;54a3
	pop af			;54a6
	call cursor_paso		;54a7
editor_pinta:		; Lo que se ve del editor: un fondo (tipo 0x11), el punto ampliado (0x55E2); si no, la casilla ampliada (0x55EE), la paleta de casillas (0x5CE0) en el combate y el mapa (0x5D17)
	call tipo_11		;54aa   ; un fondo?
	jr nz,editor_pinta_casilla		;54ad
	jp punto_ampliado		;54af
editor_pinta_casilla:
	call casilla_ampliada		;54b2
	ld a,(0f421h)		;54b5   ; la clase de juego
	cp 020h		;54b8   ; laberinto?
	jr nc,editor_pinta_mapa		;54ba
	call paleta_casillas		;54bc   ; la paleta de casillas
editor_pinta_mapa:
	jp fondo_rotulo		;54bf
cursor_paso:		; Mueve el cursor de punto (0xFBC5, columna C y fila B, 0x15 x 0x17 como maximo) un paso en la direccion A (bits 0-1: si se mueve en horizontal y vertical, bit 2: hacia atras), el de dentro de la casilla (0xFBC3, 0-7) a la vez; 0xFBC2 dice si cambia de casilla (bits 0-1 a la derecha/izquierda, 2-3 abajo/arriba); NZ si se mueve
	ld hl,0fbc2h		;54c2   ; sin cambio de casilla
	ld (hl),000h		;54c5
	call cursores_guarda		;54c7   ; las posiciones de antes
	and a			;54ca   ; ninguna direccion?
	ret z			;54cb
	push bc			;54cc
	ld b,d			;54cd
	ld c,e			;54ce
	ex de,hl			;54cf
	ld hl,0fbc2h		;54d0
	push bc			;54d3
	push af			;54d4
	and 003h		;54d5   ; se mueve en horizontal?
	jr z,cursor_paso_v		;54d7
	pop af			;54d9
	push af			;54da
	bit 2,a		;54db   ; hacia atras?
	ld a,e			;54dd
	jr nz,cursor_paso_izq		;54de
	or 0f8h		;54e0   ; la columna 7...
	inc a			;54e2   ; ...dentro de la casilla?
	jr nz,cursor_paso_der		;54e3
	ld a,015h		;54e5   ; la ultima columna?
	cp c			;54e7
	jr z,cursor_paso_v		;54e8
	inc c			;54ea   ; la casilla siguiente
	ld (hl),003h		;54eb   ; a la derecha
cursor_paso_der:
	inc e			;54ed   ; una columna mas
	jr cursor_paso_v		;54ee
cursor_paso_izq:
	and 007h		;54f0   ; la columna 0?
	jr nz,cursor_paso_izq_va		;54f2
	inc c			;54f4   ; la primera casilla?
	dec c			;54f5
	jr z,cursor_paso_v		;54f6
	dec c			;54f8   ; la de antes
	inc (hl)			;54f9   ; a la izquierda
cursor_paso_izq_va:
	dec e			;54fa   ; una columna menos
cursor_paso_v:
	pop af			;54fb
	push af			;54fc
	and 003h		;54fd   ; se mueve en vertical?
	cp 002h		;54ff
	jr z,cursor_paso_guarda		;5501
	pop af			;5503
	inc a			;5504
	bit 2,a		;5505   ; hacia arriba?
	ld a,d			;5507
	jr z,cursor_paso_arriba		;5508
	or 0f8h		;550a   ; la fila 7?
	inc a			;550c
	jr nz,cursor_paso_abajo		;550d
	ld a,017h		;550f   ; la ultima fila?
	cp b			;5511
	jr z,cursor_paso_fin		;5512
	inc b			;5514   ; la casilla de abajo
	ld a,(hl)			;5515
	or 00ch		;5516   ; abajo
	ld (hl),a			;5518
cursor_paso_abajo:
	inc d			;5519   ; una fila mas
	jr cursor_paso_fin		;551a
cursor_paso_arriba:
	and 007h		;551c   ; la fila 0?
	jr nz,cursor_paso_arriba_va		;551e
	inc b			;5520   ; la primera casilla?
	dec b			;5521
	jr z,cursor_paso_fin		;5522
	dec b			;5524
	set 2,(hl)		;5525   ; arriba
cursor_paso_arriba_va:
	dec d			;5527   ; una fila menos
cursor_paso_fin:
	push af			;5528
cursor_paso_guarda:
	pop af			;5529
	ld a,(hl)			;552a   ; el cambio de casilla
	ex de,hl			;552b
	ld (0fbc3h),hl		;552c   ; el cursor de dentro
	ld (0fbc5h),bc		;552f   ; el de casilla
	pop de			;5533
	pop bc			;5534
	and a			;5535
	ret			;5536
cursores_guarda:		; Los cursores de ahora a los de antes (0xFBC5 -> 0xFBC9, 0xFBC3 -> 0xFBC7): BC el de casilla, DE el de punto
	ld hl,(0fbc5h)		;5537   ; el cursor de casilla
	ld (0fbc9h),hl		;553a   ; el de casilla de antes
	ex de,hl			;553d
	ld hl,(0fbc3h)		;553e   ; el cursor de dentro
	ld (0fbc7h),hl		;5541   ; el cursor de dentro de antes
	ret			;5544
cursor_casilla_paso:		; Mueve el cursor de casilla (0xFBC5) un paso en la direccion A y el de dentro (0xFBC3) 8 puntos; con 0xFBD3 (copiando), antes guarda la casilla de debajo (dibujo y colores, 8 + 8 bytes) en 0xFBD6
	push af			;5545
	ld a,(0fbd3h)		;5546   ; copiando?
	and a			;5549
	jr z,cursor_casilla_paso_va		;554a
	ld hl,(0fbc5h)		;554c   ; la casilla...
	ld de,00008h		;554f
	ld a,l			;5552   ; ...x 8...
	add a,a			;5553
	add a,a			;5554
	add a,a			;5555
	ld l,a			;5556
	add hl,de			;5557   ; ...+ 8: su dibujo
	ld de,0fbd6h		;5558
	ld bc,00008h		;555b
	call ldirmv_mas		;555e   ; a la RAM
	set 5,h		;5561   ; sus colores
	call ldirmv_mas		;5563   ; a la RAM
cursor_casilla_paso_va:
	pop af			;5566
	ld hl,0fbc2h		;5567   ; sin cambio
	ld (hl),000h		;556a
	call cursores_guarda		;556c
	and a			;556f
	ret z			;5570
	push bc			;5571   ; ninguna direccion?
	ld b,d			;5572
	ld c,e			;5573
	ex de,hl			;5574
	ld hl,0fbc2h		;5575
	push bc			;5578
	push af			;5579
	and 003h		;557a   ; en horizontal?
	jr z,cursor_casilla_v		;557c
	pop af			;557e
	push af			;557f
	bit 2,a		;5580   ; hacia atras?
	jr nz,cursor_casilla_izq		;5582
	ld a,015h		;5584   ; la ultima columna?
	cp c			;5586
	jr z,cursor_casilla_v		;5587
	inc c			;5589   ; la siguiente
	ld (hl),003h		;558a
	ld a,008h		;558c   ; 8 puntos
	jr cursor_casilla_x		;558e
cursor_casilla_izq:
	inc c			;5590
	dec c			;5591
	jr z,cursor_casilla_v		;5592
	dec c			;5594   ; la de antes
	inc (hl)			;5595
	ld a,0f8h		;5596   ; 8 puntos menos
cursor_casilla_x:
	add a,e			;5598
	ld e,a			;5599
cursor_casilla_v:
	pop af			;559a
	push af			;559b
	and 003h		;559c
	cp 002h		;559e
	jr z,cursor_casilla_guarda		;55a0
	pop af			;55a2
	inc a			;55a3
	bit 2,a		;55a4
	jr z,cursor_casilla_arriba		;55a6
	ld a,017h		;55a8   ; la ultima fila?
	cp b			;55aa
	jr z,cursor_casilla_fin		;55ab
	inc b			;55ad   ; la de abajo
	ld a,0c0h		;55ae
	or (hl)			;55b0
	ld (hl),a			;55b1
	ld a,008h		;55b2
	jr cursor_casilla_y		;55b4
cursor_casilla_arriba:
	inc b			;55b6
	dec b			;55b7
	jr z,cursor_casilla_fin		;55b8
	dec b			;55ba   ; la de arriba
	set 2,(hl)		;55bb
	ld a,0f8h		;55bd
cursor_casilla_y:
	add a,d			;55bf
	ld d,a			;55c0
cursor_casilla_fin:
	push af			;55c1
cursor_casilla_guarda:
	pop af			;55c2
	ld a,(hl)			;55c3
	ex de,hl			;55c4
	ld (0fbc3h),hl		;55c5   ; el de dentro
	ld (0fbc5h),bc		;55c8   ; el de casilla
	pop de			;55cc
	pop bc			;55cd
	and a			;55ce
	ret			;55cf
cursor_paso_pinta:		; El cursor un paso (0x54C2); si se mueve, la pantalla del editor
	call cursor_paso		;55d0
	ret z			;55d3
	jp editor_pinta		;55d4
cursor_casilla_pinta:		; El cursor de casilla un paso (0x5545); sin copiar (0xFBD3), la pantalla del editor
	call cursor_casilla_paso		;55d7
	ld a,(0fbd3h)		;55da   ; copiando
	and a			;55dd
	ret nz			;55de
	jp editor_pinta		;55df
punto_ampliado:		; Con un fondo (tipo 0x11): la casilla del cursor (0xFBC5, columna x 8) ampliada (0x55EE)
	ld hl,(0fbc5h)		;55e2   ; el cursor de casilla
	push hl			;55e5
	ld h,000h		;55e6
	add hl,hl			;55e8
	add hl,hl			;55e9
	add hl,hl			;55ea
	pop af			;55eb
	ld h,a			;55ec
	push hl			;55ed
casilla_ampliada:		; La casilla ampliada a la derecha de la pantalla: 0xFAC2 a 0; su dibujo y sus colores (8 + 8 bytes de la VRAM; con varios fondos, la casilla 0xFBEF) a 0xFB22; cada uno de sus 64 puntos es una casilla de color (0x5688, 0x567F) en un cuadro de 8 x 8 desde 0x3A17
	call fac2_cero		;55ee   ; 0xFAC2 a 0
	call tipo_11		;55f1   ; un fondo?
	push af			;55f4
	ex af,af'			;55f5
	pop af			;55f6
	jr z,casilla_ampliada_lee		;55f7
	ld hl,(0fbefh)		;55f9   ; la casilla elegida...
	ld h,000h		;55fc
	dec l			;55fe   ; ...desde 0...
	add hl,hl			;55ff   ; ...x 8
	add hl,hl			;5600
	add hl,hl			;5601
	push hl			;5602
casilla_ampliada_lee:
	pop hl			;5603
	ld de,00008h		;5604   ; + 8
	add hl,de			;5607
	ld bc,00008h		;5608   ; 8 bytes
	ld de,0fb22h		;560b   ; a 0xFB22
	push de			;560e
	call ldirmv_mas		;560f   ; su dibujo
	set 5,h		;5612   ; sus colores
	call ldirmv_mas		;5614   ; a 0xFB2A
	pop ix		;5617
	ld hl,0fac2h		;5619   ; el cuadro, en 0xFAC2
	ld c,008h		;561c   ; 8 filas
	push hl			;561e
casilla_ampliada_fila:
	ld a,(ix+008h)		;561f   ; los colores de la fila
	call colores_casillas		;5622   ; a casillas (D tinta, E fondo)
	ld a,(ix+000h)		;5625   ; los puntos de la fila
	ld b,008h		;5628   ; 8 puntos
	call punto_colores		;562a
	inc ix		;562d   ; la fila siguiente
	dec c			;562f
	jr nz,casilla_ampliada_fila		;5630
	ld de,03a17h		;5632   ; a la tabla de nombres: fila 0x10, columna 0x17
	pop hl			;5635
	ld bc,00808h		;5636   ; 8 filas de 8
casilla_ampliada_pinta:
	push bc			;5639
	ld b,000h		;563a
	call ldirvm_mas		;563c   ; LDIRVM
	ex de,hl			;563f
	ld c,020h		;5640   ; la fila de abajo
	add hl,bc			;5642
	ex de,hl			;5643
	pop bc			;5644
	djnz casilla_ampliada_pinta		;5645
	ret			;5647
colores_paleta:		; Los colores de la paleta: con un fondo (0x11), la columna de las casillas 0x20B8 (0x18 filas de 0x40) con 0x11 o, con NZ, desde 0x3000; si no, la tabla de nombres de 0x3817 (0x18 filas de 8 casillas 0x4B); con Z de entrada (0x5648, "or 0xAF") solo la primera parte
	or 0afh		;5648   ; NZ; desde 0x5649 "xor a": Z
	push af			;564a
	call tipo_11		;564b   ; un fondo?
	jr nz,colores_paleta_casillas		;564e
	pop af			;5650
	ld a,011h		;5651   ; tinta 1, fondo 1
	ld hl,020b8h		;5653   ; los colores desde 0x20B8
	ld de,00100h		;5656
	ld bc,01840h		;5659
	jr nz,colores_paleta_uno		;565c
	ld h,030h		;565e
colores_paleta_ocho:
	ld b,008h		;5660
colores_paleta_uno:
	push bc			;5662
	ld b,000h		;5663
	call 00056h		;5665   ; FILVRM
	add hl,de			;5668   ; la siguiente
	pop bc			;5669
	djnz colores_paleta_uno		;566a
	ret			;566c
colores_paleta_casillas:
	pop af			;566d
	ld a,04bh		;566e   ; la casilla 0x4B
	ld hl,03817h		;5670   ; la tabla de nombres, columna 0x17
	ld bc,01808h		;5673
	ld de,00020h		;5676   ; cada 32
	jr nz,colores_paleta_uno		;5679
	inc h			;567b
	inc h			;567c
	jr colores_paleta_ocho		;567d
punto_colores:		; Los 8 puntos de A (bit 7 primero): D (tinta) con el bit a 1, E (fondo) con 0
	ld (hl),d			;567f
	rlca			;5680
	jr nc,punto_colores_sig		;5681
	ld (hl),e			;5683
punto_colores_sig:
	inc hl			;5684
	djnz punto_colores		;5685
	ret			;5687
colores_casillas:		; Los dos colores de A (tinta y fondo) a casillas: con un fondo (Z en el AF de reserva), 0x17 + color (0x2F + color - 8 de 8 en adelante); si no, 0x10 + color; D la tinta, E el fondo
	ex af,af'			;5688
	jr nz,colores_casillas_b		;5689   ; con varios fondos?
	ex af,af'			;568b
	push af			;568c
	call colores_casilla_uno		;568d   ; el fondo
	ld d,e			;5690
	pop af			;5691
	rrca			;5692   ; la tinta
	rrca			;5693
	rrca			;5694
	rrca			;5695
colores_casilla_uno:
	and 00fh		;5696
	cp 008h		;5698
	ld e,017h		;569a
	jr c,colores_casilla_fin		;569c
	ld e,02fh		;569e
colores_casilla_fin:
	add a,e			;56a0
	ld e,a			;56a1
	ret			;56a2
colores_casillas_b:
	ex af,af'			;56a3
	push af			;56a4   ; el fondo
	call colores_casilla_b		;56a5
	ld d,e			;56a8   ; la tinta
	pop af			;56a9
	rrca			;56aa
	rrca			;56ab
	rrca			;56ac
	rrca			;56ad
colores_casilla_b:
	and 00fh		;56ae
	add a,010h		;56b0
	ld e,a			;56b2
	ret			;56b3
dibujo_fila_color:		; Un dibujo (0x56F3) en DE y sus colores A
	ld b,001h		;56b4
	ld hl,056f3h		;56b6
	jr dibujos_colores_va		;56b9
dibujos_colores_8:		; 8 dibujos (0x56FB) en DE y sus colores
	ld b,008h		;56bb
dibujos_colores:		; B dibujos de 0x56FB a la VRAM DE (los mismos 8 bytes) y sus colores en DE + 0x2000: A, A + 0x10, ... (uno por dibujo)
	ld hl,056fbh		;56bd
dibujos_colores_va:
	push de			;56c0
	push bc			;56c1
	push af			;56c2
dibujos_colores_uno:
	push bc			;56c3
	ld bc,00008h		;56c4   ; 8 bytes
	call ldirvm		;56c7   ; LDIRVM
	ex de,hl			;56ca   ; el siguiente
	add hl,bc			;56cb
	ex de,hl			;56cc
	pop bc			;56cd
	djnz dibujos_colores_uno		;56ce
	pop af			;56d0
	pop bc			;56d1
	push bc			;56d2
	ld hl,0fac2h		;56d3   ; los colores
	push hl			;56d6
dibujos_colores_c:
	ld c,008h		;56d7
dibujos_colores_b:
	ld (hl),a			;56d9
	inc hl			;56da
	dec c			;56db
	jr nz,dibujos_colores_b		;56dc
	add a,010h		;56de   ; el color siguiente
	djnz dibujos_colores_c		;56e0
	ex af,af'			;56e2
	pop hl			;56e3
	pop af			;56e4
	add a,a			;56e5
	add a,a			;56e6
	add a,a			;56e7
	ld b,000h		;56e8
	ld c,a			;56ea
	pop de			;56eb
	set 5,d		;56ec   ; a los colores
	call ldirvm_mas		;56ee   ; LDIRVM
	ex af,af'			;56f1
	ret			;56f2

; ----------------------------------------------------------------------
; DATOS dibujos_cuadro: Dos dibujos de casilla de 8 bytes: 0x56F3 y 0x56FB (el
;   cuadro de la paleta y de la rejilla)
;   0x56f3..0x5703  (16 bytes)
DATA_dibujos_cuadro:
	defb 038h,044h,082h,082h,082h,044h,038h,000h,000h,038h,07ch,0feh,0feh,07ch,038h,000h	; 56f3  8D...D8..8|..|8.

; ======================================================================
; CODIGO 0x5703..0x5813  (272 bytes)
; ======================================================================


casilla_suelta:		; Devuelve a la VRAM la casilla guardada en 0xFBD6 (dibujo y colores) en la posicion del cursor (0xFBC5) y mueve el cursor de casilla (0x5545)
	push af			;5703
	ld hl,(0fbc5h)		;5704   ; la casilla...
	ld de,00008h		;5707
	ld a,l			;570a   ; ...x 8...
	add a,a			;570b
	add a,a			;570c
	add a,a			;570d
	ld l,a			;570e
	add hl,de			;570f   ; ...+ 8
	ex de,hl			;5710
	ld hl,0fbd6h		;5711   ; lo guardado
	ld bc,00008h		;5714
	call ldirvm_mas		;5717   ; LDIRVM: el dibujo
	set 5,d		;571a   ; los colores
	call ldirvm_mas		;571c   ; LDIRVM
	pop af			;571f
	jp cursor_casilla_paso		;5720
punto_pinta:		; El punto del cursor (0xFBC3, X + 8) con el color del borde (0x5821) a la VRAM (0xAAFF)
	ld hl,(0fbc3h)		;5723   ; el cursor de dentro
	ld a,008h		;5726   ; X + 8
	add a,l			;5728
	ld l,a			;5729
punto_pinta_color:
	call color_borde		;572a   ; el color
	jp punto_color		;572d   ; a la VRAM
punto_paleta:		; El punto del cursor dentro del cuadro de la casilla ampliada (columna 0x68 + X, fila 0x40 + Y) con el color del borde
	ld hl,(0fbc3h)		;5730   ; el cursor de dentro
	ld a,007h		;5733
	and l			;5735
	or 068h		;5736
	ld l,a			;5738
	ld a,007h		;5739
	and h			;573b
	or 040h		;573c
	ld h,a			;573e
	jr punto_pinta_color		;573f
herramienta_elige:		; Elige la herramienta del editor de dibujo (A - 0x38: 0 ninguna; 1-7 LINE, BOX, BOXFILL, CIRCLE, PAINT, H-LINE y V-LINE en 0xFBD2): modo 0x0404, sin posicion, cursores fuera; 0xFBD1 = 1 (espera el primer punto) o 2 con PAINT; la paleta y la herramienta elegida en otro color
	push af			;5741
	call modo_0404		;5742   ; el modo 0x0404
	ld hl,0ffffh		;5745   ; sin posicion
	ld (0fe34h),hl		;5748   ; la posicion de la tableta
	call cursores_fuera		;574b
	pop af			;574e
	sub 038h		;574f   ; 0x38: ninguna?
	jr nz,herramienta_pon		;5751
herramienta_nada:		; Sin herramienta: cursores fuera, 0xFE5F = 0x18, 0xFBD1 = 0, el modo 0x0101
	call cursores_fuera		;5753
	ld a,018h		;5756   ; los cursores de punto
	ld (0fe5fh),a		;5758   ; los cursores
	xor a			;575b   ; sin herramienta
	ld (0fbd1h),a		;575c   ; lo que espera la herramienta
	ld hl,00101h		;575f   ; el modo 0x0101
	ld (0fe6dh),hl		;5762   ; el modo del editor
herramienta_pinta:		; La pantalla del editor y los rotulos de las herramientas (7 filas desde 0x28B8, 0x40 bytes) en blanco sobre negro; la elegida (0xFBD2), en 0xF4
	call editor_pinta		;5765
	ld hl,028b8h		;5768   ; los colores de los rotulos
	ld a,0f1h		;576b   ; blanco sobre negro
	ld d,007h		;576d   ; siete
	push hl			;576f
herramienta_pinta_uno:
	ld bc,00040h		;5770
	call 00056h		;5773   ; FILVRM
	inc h			;5776   ; la fila siguiente
	dec d			;5777
	jr nz,herramienta_pinta_uno		;5778
	pop hl			;577a
	ld a,(0fbd1h)		;577b   ; con herramienta?
	and a			;577e
	ret z			;577f
	ld a,(0fbd2h)		;5780   ; cual
herramienta_fila:
	dec a			;5783
	jr z,herramienta_marca		;5784
	inc h			;5786
	jr herramienta_fila		;5787
herramienta_marca:
	ld bc,00040h		;5789
	ld a,0f4h		;578c   ; blanco sobre azul
	jp 00056h		;578e   ; FILVRM
herramienta_pon:
	ld (0fbd2h),a		;5791   ; la herramienta
	cp 005h		;5794   ; PAINT?
	ld a,001h		;5796   ; espera el primer punto
	jr nz,herramienta_espera		;5798
	inc a			;579a   ; PAINT: uno solo
herramienta_espera:
	ld (0fbd1h),a		;579b   ; lo que espera la herramienta
	jr herramienta_pinta		;579e
herramienta_punto:		; La barra con una herramienta: con 0xFBD1 = 1, el primer punto (0xFBC3 -> 0xFBCB, la cruz 0x2F/0x30) y 0xFBD1 = 2; con 2, la herramienta se hace (0x57D2) y, salvo LINE, se vuelve a elegir
	ld a,(0fbd1h)		;57a0   ; que punto espera
	sub 001h		;57a3   ; ninguno: C
	ret c			;57a5
	jr nz,herramienta_segundo		;57a6   ; el segundo
herramienta_primero:
	ld hl,(0fbc3h)		;57a8   ; el cursor...
	ld (0fbcbh),hl		;57ab   ; ...es el primer punto
	call cursor_dos_b		;57ae   ; la cruz en el
	ld a,002h		;57b1   ; espera el segundo
	ld (0fbd1h),a		;57b3   ; lo que espera la herramienta
	jp editor_pinta		;57b6
herramienta_segundo:
	call herramienta_hace		;57b9   ; se dibuja
	call cursores_fuera		;57bc
	ld hl,0ffffh		;57bf   ; sin posicion
	ld a,001h		;57c2
	ld (0fe34h),hl		;57c4   ; la posicion de la tableta
	ld (0fe36h),a		;57c7
	ld a,(0fbd2h)		;57ca   ; LINE?
	dec a			;57cd
	jr z,herramienta_primero		;57ce   ; si: sigue desde aqui
	jr herramienta_nada		;57d0
herramienta_hace:		; Dibuja con la herramienta 0xFBD2 (su rutina en 0x5813) desde el primer punto (0xFBCB + 8) hasta el cursor (0xFBC3 + 8), con el color del borde; 0xFE75 = 0xF7E7, 0xFE77 y 0xFE79 = 0xF7EF - 1 (el sitio libre para PAINT); H-LINE usa la Y del primero (0x580A) y V-LINE la X (0x580D)
	ld hl,(0f7e7h)		;57d2   ; los limites de la RAM libre
	ld (0fe75h),hl		;57d5   ; el final de lo usado (PAINT)
	ld hl,(0f7efh)		;57d8   ; el principio de las notas
	dec hl			;57db
	ld (0fe77h),hl		;57dc   ; el fondo de la pila de PAINT
	ld (0fe79h),hl		;57df   ; la pila de PAINT
	ld hl,herramienta_salta		;57e2   ; la tabla de las herramientas
	ld a,(0fbd2h)		;57e5   ; la herramienta
	push af			;57e8
	call tabla_salta		;57e9   ; su rutina
	call palabra_lee		;57ec
	push hl			;57ef   ; a IX
	pop ix		;57f0
	pop af			;57f2
	ld bc,00008h		;57f3   ; + 8
	ld hl,(0fbcbh)		;57f6   ; el primer punto
	add hl,bc			;57f9
	ex de,hl			;57fa
	ld hl,(0fbc3h)		;57fb   ; el cursor
	add hl,bc			;57fe
	cp 005h		;57ff   ; PAINT?
	jr z,herramienta_va		;5801
	ex de,hl			;5803
	cp 006h		;5804   ; LINE, BOX, BOXFILL o CIRCLE?
	jr c,herramienta_va		;5806
	jr nz,herramienta_hline		;5808   ; V-LINE: la misma X
	ld d,h			;580a   ; H-LINE: la misma Y
	jr herramienta_va		;580b
herramienta_hline:
	ld e,l			;580d
herramienta_va:
	call color_borde		;580e   ; el color
herramienta_salta:
	jp (ix)		;5811

; ----------------------------------------------------------------------
; DATOS herramientas: Las rutinas de las herramientas por 0xFBD2: LINE 0xA959,
;   BOX 0xA96C, BOXFILL 0xA98C, CIRCLE 0xAFC8, PAINT 0xAB2A, H-LINE y V-LINE
;   0xA959
;   0x5813..0x5821  (14 bytes)
DATA_herramientas:
	defb 059h,0a9h,06ch,0a9h,08ch,0a9h,0c8h,0afh,02ah,0abh,059h,0a9h,059h,0a9h	; 5813  Y.l.....*.Y.Y.

; ======================================================================
; CODIGO 0x5821..0x5a5f  (574 bytes)
; ======================================================================


color_borde:		; A = el color del borde (0xFA38, 4 bits): el color con que se dibuja
	ld a,(0fa38h)		;5821   ; el color del borde (el de dibujar)
	and 00fh		;5824
	ret			;5826
tableta_lee:		; La tableta del puerto 2 (GTPAD 4: tocada?; 5: X - 8; 6: Y - 3): H = Y (0xFF si no se toca o se sale), L = X; B = 0xFF si GRAPH (fila 6, bit 2) no esta pulsada
	push de			;5827
	ld a,004h		;5828   ; GTPAD 4: tocada?
	call 000dbh		;582a   ; GTPAD
	ld h,0ffh		;582d   ; sin posicion
	and a			;582f
	jr z,tableta_boton		;5830
	ld a,005h		;5832   ; GTPAD 5: la X
	call 000dbh		;5834   ; GTPAD
	sub 008h		;5837   ; - 8
	jr nc,tableta_x		;5839
tableta_fuera:
	ld h,0ffh		;583b
	jr tableta_boton		;583d
tableta_x:
	cp 0f0h		;583f   ; 0xF0 o mas: fuera
	jr nc,tableta_fuera		;5841
	ld l,a			;5843
	push hl			;5844
	ld a,006h		;5845   ; GTPAD 6: la Y
	call 000dbh		;5847   ; GTPAD
	pop hl			;584a
	sub 003h		;584b   ; - 3
	jr nc,tableta_y		;584d
	xor a			;584f
tableta_y:
	cp 0c0h		;5850   ; hasta 0xBF
	jr c,tableta_y_pon		;5852
	ld a,0bfh		;5854
tableta_y_pon:
	ld h,a			;5856
tableta_boton:
	push hl			;5857
	ld a,006h		;5858   ; la fila 6 del teclado
	call 00141h		;585a   ; SNSMAT
	bit 2,a		;585d   ; GRAPH
	ld a,0ffh		;585f
	jr z,tableta_fin		;5861
	xor a			;5863
tableta_fin:
	push af			;5864
	xor a			;5865   ; 0
	pop bc			;5866
	or b			;5867   ; + el boton
	ld b,a			;5868
	pop hl			;5869   ; la posicion
	pop de			;586a
	ret			;586b
tableta_mueve:		; El cursor a la posicion de la tableta (HL): si esta dentro (0x5889), el cursor de dentro (0xFBC3) y el de casilla (0xFBC5, / 8), la pantalla y, con el boton (B), el punto (0x5723); con una herramienta, el punto de la herramienta (0x57A0)
	ld a,(0fbd1h)		;586c   ; con herramienta?
	and a			;586f
	jr nz,tableta_mueve_herr		;5870
	call tableta_dentro		;5872   ; dentro?
	ret c			;5875
	push bc			;5876
	ld (0fbc3h),hl		;5877   ; el cursor de dentro
	call por8		;587a
	ld (0fbc5h),hl		;587d   ; el de casilla
	call editor_pinta		;5880
	pop bc			;5883
	inc b			;5884   ; el boton?
	ret z			;5885
	jp punto_pinta		;5886   ; el punto
tableta_dentro:		; C si HL se sale del lienzo (Y > 0xBF o X > 0xAF)
	ld de,0bfafh		;5889   ; Y hasta 0xBF, X hasta 0xAF
	ld a,d			;588c
	cp h			;588d   ; la Y?
	ret c			;588e
	ld a,e			;588f
	cp l			;5890   ; la X?
	ret			;5891
por8:		; H y L / 8 (la casilla del punto)
	ld a,h			;5892   ; la Y
	and 0f8h		;5893   ; de 8 en 8
	rrca			;5895   ; / 8
	rrca			;5896
	rrca			;5897
	ld h,a			;5898
	ld a,l			;5899   ; la X
	and 0f8h		;589a
	rrca			;589c   ; / 8
	rrca			;589d
	rrca			;589e
	ld l,a			;589f
	ret			;58a0
tableta_mueve_herr:
	call tableta_dentro		;58a1
	ret c			;58a4
	push bc			;58a5
	ld (0fbc3h),hl		;58a6   ; el cursor de dentro
	call por8		;58a9
	ld (0fbc5h),hl		;58ac   ; el cursor de casilla
	pop bc			;58af
	inc b			;58b0
	jp nz,herramienta_punto		;58b1
	jp editor_pinta		;58b4
casillas_copia:		; Copia las casillas H a L (dibujos de 8 bytes) de la parte 0 a las otras dos partes de la VRAM (0x800 y 0x1000) y lo mismo con sus colores (0x2000)
	ex af,af'			;58b7
	push af			;58b8
	dec h			;58b9   ; desde 0
	dec l			;58ba
	add hl,hl			;58bb   ; x 8
	add hl,hl			;58bc
	add hl,hl			;58bd
	ld d,l			;58be
	ld l,000h		;58bf
	ld e,l			;58c1
	push hl			;58c2
	push de			;58c3
	push de			;58c4
casillas_copia_vuelta:
	ld de,0fac2h		;58c5   ; por 0xFAC2
	ld bc,00100h		;58c8   ; 0x100 bytes
	ld a,008h		;58cb   ; 8 veces
casillas_copia_uno:
	ex af,af'			;58cd
	call ldirmv		;58ce   ; LDIRMV
	inc h			;58d1
	ex (sp),hl			;58d2
	ex de,hl			;58d3
	call ldirvm		;58d4   ; LDIRVM
	inc d			;58d7
	ex de,hl			;58d8
	ex (sp),hl			;58d9
	ex af,af'			;58da
	dec a			;58db
	jr nz,casillas_copia_uno		;58dc
	pop hl			;58de
	bit 5,h		;58df   ; ya en los colores?
	jr nz,casillas_copia_fin		;58e1
	pop hl			;58e3
	set 5,h		;58e4   ; a los colores
	ex (sp),hl			;58e6
	set 5,h		;58e7
	jr casillas_copia_vuelta		;58e9
casillas_copia_fin:
	pop af			;58eb
	ex af,af'			;58ec
	ret			;58ed
mapa_nuevo:		; Llena el mapa (A filas de 22, 0x5F0E) con la casilla 0x0C (o, en el combate que se desplaza con el borde de color, 0x68 + color en 0xFBFD); entonces el dibujo de la casilla 0x0C y su color; despues las casillas 0x0201 y 0x0203 en las tres partes, 0x5EEE y los colores de la paleta
	call mapa_cuentas		;58ee
	push af			;58f1
	ld de,00c00h		;58f2   ; la casilla 0x0C
	ld a,(0f421h)		;58f5   ; la clase de juego
	cp 012h		;58f8   ; combate con desplazamiento?
	jr nz,mapa_nuevo_va		;58fa
	call color_borde		;58fc   ; con color?
	jr z,mapa_nuevo_va		;58ff
	add a,068h		;5901   ; la casilla 0x68 + color
	ld d,a			;5903
	ld (0fbfdh),a		;5904   ; la casilla del borde
	inc e			;5907
mapa_nuevo_va:
	pop af			;5908
mapa_nuevo_fila:
	ld b,016h		;5909   ; 22 casillas
mapa_nuevo_casilla:
	ld (hl),d			;590b   ; la casilla
	inc hl			;590c
	djnz mapa_nuevo_casilla		;590d   ; 22
	dec a			;590f
	jr nz,mapa_nuevo_fila		;5910   ; la fila siguiente
	ex af,af'			;5912   ; la otra parte?
	jr z,mapa_nuevo_dibujo		;5913
	push de			;5915
	exx			;5916   ; la otra parte
	pop de			;5917
	jr mapa_nuevo_fila		;5918
mapa_nuevo_dibujo:
	dec e			;591a
	jr z,mapa_nuevo_fin		;591b
	ld hl,00860h		;591d   ; el dibujo de 0x860
	ld bc,00008h		;5920
	push bc			;5923
	push hl			;5924
	xor a			;5925
	call 00056h		;5926   ; FILVRM: a 0
	pop hl			;5929
	set 5,h		;592a
	pop bc			;592c
	call color_borde		;592d   ; el color
	push af			;5930
	call 00056h		;5931   ; FILVRM
	ld a,(0fbfbh)		;5934   ; la casilla...
	add a,a			;5937
	add a,a			;5938
	add a,a			;5939
	ld hl,02848h		;593a   ; ...en 0x2848
	call hl_mas_a		;593d
	pop af			;5940
	ld bc,00008h		;5941
	call 00056h		;5944   ; FILVRM
mapa_nuevo_fin:
	ld hl,00201h		;5947   ; las casillas 1 y 2...
	call casillas_copia		;594a
	ld hl,00203h		;594d   ; ...y 3
	call casillas_copia		;5950
	call mapa_pinta		;5953   ; el mapa
	jp colores_paleta		;5956   ; los colores
casilla_ampliada_punto:		; Pinta un punto en la casilla ampliada (0x5730), la casilla 0xFBEF desde 0xFAC2 a las tres partes (dibujo y colores, 0x5AF1), la casilla ampliada otra vez y el cursor un paso (0x54C2): si cambia de casilla, el cursor vuelve donde estaba
	push af			;5959
	call punto_paleta		;595a   ; el punto
	ld a,00dh		;595d   ; las casillas 0x0D
	ld de,0fac2h		;595f
	call casilla_a_ram		;5962   ; a 0xFAC2
	ld hl,(0fbefh)		;5965   ; la casilla elegida
	ld h,000h		;5968
	add hl,hl			;596a   ; x 8
	add hl,hl			;596b
	add hl,hl			;596c
	ex de,hl			;596d
	ld hl,0fac2h		;596e
	ld a,003h		;5971   ; tres partes
	ld bc,00008h		;5973
casilla_ampliada_parte:
	push af			;5976
	push hl			;5977
	call ldirvm_mas		;5978   ; LDIRVM: el dibujo
	set 5,d		;597b
	call ldirvm_mas		;597d   ; LDIRVM: los colores
	res 5,d		;5980
	ld a,c			;5982   ; la parte siguiente
	add a,d			;5983
	ld d,a			;5984
	pop hl			;5985
	pop af			;5986
	dec a			;5987
	jr nz,casilla_ampliada_parte		;5988
	call casilla_ampliada		;598a   ; la casilla ampliada otra vez
	pop af			;598d
casilla_ampliada_mueve:
	call cursor_paso		;598e
	jr z,casilla_ampliada_fin		;5991   ; sin cambio de casilla
	ld hl,(0fbc7h)		;5993   ; vuelve
	ld (0fbc3h),hl		;5996   ; el cursor de dentro
	ld hl,(0fbc9h)		;5999   ; el de casilla de antes
	ld (0fbc5h),hl		;599c   ; el cursor de casilla
casilla_ampliada_fin:
	ld hl,(0fbc5h)		;599f   ; el cursor de casilla
	jp mapa_posicion		;59a2
mapa_cursor_paso:		; Pone la casilla elegida (0xFBEF) bajo el cursor, mueve el cursor de casilla (0x5545) y, si se ha movido: si se ha salido del mapa, se desplaza (0x59BD); la casilla de debajo (0xFBF4) a la paleta (0x5A97) y la pantalla
	push af			;59a5
	ld a,(0fbefh)		;59a6   ; la casilla elegida
	call mapa_pon_pinta		;59a9
	pop af			;59ac
mapa_cursor_paso_va:
	call cursor_casilla_paso		;59ad
	ret z			;59b0
	call mapa_borde		;59b1
	ld a,(0fbf4h)		;59b4   ; la casilla de debajo
	call pantalla_pon		;59b7
	jp editor_pinta		;59ba
mapa_borde:		; El cursor en el borde del mapa (0x5A2F): con desplazamiento hacia arriba (A = 1) o abajo (2)... el mapa sube o baja una fila (0x5E51, 0x5E94); en el primero o el ultimo trozo, 0x5B0E y se intercambian las filas (0x5A15); despues 0x5EEE y la casilla del cursor (0x5A21)
	call mapa_sale		;59bd   ; se sale?
	jp z,casilla_cursor		;59c0   ; no
	ld b,a			;59c3
	ld a,(0fbc8h)		;59c4   ; el cursor...
	ld (0fbc4h),a		;59c7   ; la Y del cursor de dentro
	ld a,(0fbcah)		;59ca   ; ...donde estaba
	ld (0fbc6h),a		;59cd   ; la fila del cursor de casilla
	ld a,(0fbe6h)		;59d0   ; el fondo
	and a			;59d3
	ld hl,(0fbe8h)		;59d4   ; el mapa de trabajo
	djnz mapa_borde_baja		;59d7
	jr nz,mapa_borde_sube		;59d9
	ld de,(0f7edh)		;59db   ; el principio del mapa?
	rst 20h			;59df   ; DCOMPR
	jr nz,mapa_borde_sube		;59e0
	call fila_mete		;59e2
	ld hl,(0fbe8h)		;59e5   ; el mapa de trabajo
	push hl			;59e8
	ld de,00016h		;59e9
	add hl,de			;59ec
	push hl			;59ed
	ld de,(0f7edh)		;59ee   ; intercambia dos filas
	call filas_cambia		;59f2
	pop hl			;59f5
	pop de			;59f6
	call filas_cambia		;59f7
mapa_borde_sube:
	call mapa_sube		;59fa
	jr mapa_borde_fin		;59fd
mapa_borde_baja:
	jr nz,mapa_borde_baja2		;59ff
	ld de,(0fbeah)		;5a01   ; el ultimo trozo del mapa
	rst 20h			;5a05   ; DCOMPR
	jr nz,mapa_borde_baja2		;5a06
	call fila_mete		;5a08
	jr mapa_borde_fin		;5a0b
mapa_borde_baja2:
	call mapa_baja		;5a0d
mapa_borde_fin:
	call mapa_pinta		;5a10
	jr casilla_cursor		;5a13
filas_cambia:		; Intercambia las filas de 22 bytes de HL y DE
	ld b,016h		;5a15
filas_cambia_uno:
	ld c,(hl)			;5a17   ; el de HL
	ld a,(de)			;5a18   ; el de DE
	ex de,hl			;5a19
	ld (hl),c			;5a1a   ; cambiados
	ld (de),a			;5a1b
	inc hl			;5a1c
	inc de			;5a1d
	djnz filas_cambia_uno		;5a1e   ; 22
	ret			;5a20
casilla_cursor:		; La casilla del mapa bajo el cursor (0x5A9D, 0xFBC5) y su dibujo (0x5A5B) en la casilla ampliada
	ld hl,(0fbc5h)		;5a21   ; el cursor de casilla
	call mapa_posicion		;5a24
	ld h,a			;5a27
	call casilla_dibujo		;5a28
	ld a,00dh		;5a2b
	jr $+106		;5a2d
mapa_sale:		; Con desplazamiento (bit 3 de la clase de juego a 0) y sin copiar (0xFBF5): 1 si el cursor esta en la fila 0 y antes no, 4 si en la 0x17 y antes no; si no, 0 (Z)
	ld hl,(0f421h)		;5a2f   ; la clase de juego
	bit 3,l		;5a32   ; sin desplazamiento?
	jr nz,mapa_sale_no		;5a34
	ld a,(0fbf5h)		;5a36   ; copiando?
	dec a			;5a39
	jr z,mapa_sale_no		;5a3a
	ld hl,(0fbc5h)		;5a3c   ; el cursor
	ld de,(0fbc9h)		;5a3f   ; el de antes
	ld a,h			;5a43   ; la fila 0?
	and a			;5a44
	jr nz,mapa_sale_abajo		;5a45
	cp d			;5a47   ; y antes?
	jr z,mapa_sale_no		;5a48
	inc a			;5a4a
	jr mapa_sale_fin		;5a4b
mapa_sale_abajo:
	cp 017h		;5a4d   ; la ultima?
	jr nz,mapa_sale_no		;5a4f
	cp d			;5a51
	jr z,mapa_sale_no		;5a52
	ld a,004h		;5a54
	jr mapa_sale_fin		;5a56
mapa_sale_no:
	xor a			;5a58
mapa_sale_fin:
	and a			;5a59
	ret			;5a5a
casilla_dibujo:		; El dibujo de la casilla A en la casilla 0x0D (0x5A97 con L = 0x0D)
	ld l,00dh		;5a5b
	jr $+4		;5a5d

; ----------------------------------------------------------------------
; DATOS sin_uso_5a5f: Dos bytes que nadie salta ni lee (el final de
;   casilla_dibujo salta por encima: "jr $+4")
;   0x5a5f..0x5a61  (2 bytes)
DATA_sin_uso_5a5f:
	defb 026h,00dh	; 5a5f

; ======================================================================
; CODIGO 0x5a61..0x5a91  (48 bytes)
; ======================================================================


casilla_copia:		; Copia la casilla H en la L (dibujo y colores, por 0xFAC2)
	push hl			;5a61
	call casilla_vram		;5a62   ; la casilla L
	ex (sp),hl			;5a65
	ld l,h			;5a66
	call casilla_vram		;5a67   ; la H
	ld b,e			;5a6a
	ld c,d			;5a6b
	ld de,0fac2h		;5a6c
	push de			;5a6f
	call ldirmv_mas		;5a70   ; LDIRMV: su dibujo
	set 5,h		;5a73
	call ldirmv_mas		;5a75   ; LDIRMV: sus colores
	pop hl			;5a78
	pop de			;5a79
	call ldirvm_mas		;5a7a   ; LDIRVM: el dibujo a la otra
	set 5,d		;5a7d
	jp ldirvm_mas		;5a7f   ; LDIRVM: los colores
casilla_vram:		; HL = la direccion del dibujo de la casilla L en la parte central de la VRAM (0x800 + L x 8)
	ld h,000h		;5a82   ; la casilla...
	add hl,hl			;5a84   ; ...x 8
	add hl,hl			;5a85
	add hl,hl			;5a86
	ld de,00800h		;5a87   ; + 0x800
	add hl,de			;5a8a
	ret			;5a8b
mapa_pon:		; La casilla A al mapa, en la posicion del cursor (0xFBF2)
	ld hl,(0fbf2h)		;5a8c   ; la posicion en el mapa
	ld (hl),a			;5a8f
	ret			;5a90

; ----------------------------------------------------------------------
; DATOS sin_uso_5a91: Tres bytes que nadie salta ni lee
;   0x5a91..0x5a94  (3 bytes)
DATA_sin_uso_5a91:
	defb 03ah,0f4h,0fbh	; 5a91

; ======================================================================
; CODIGO 0x5a94..0x5d4a  (694 bytes)
; ======================================================================


mapa_pon_pinta:		; La casilla A al mapa y a la pantalla (0x5A97)
	call mapa_pon		;5a94
pantalla_pon:		; La casilla A a la tabla de nombres, en la posicion del cursor (0xFBF0; WRTVRM)
	ld hl,(0fbf0h)		;5a97   ; la posicion en pantalla
	jp 0004dh		;5a9a   ; WRTVRM
mapa_posicion:		; La posicion de la casilla H (fila), L (columna): en la tabla de nombres (0x3801 + fila x 32 + columna, a 0xFBF0) y en el mapa (fila x 22 + columna desde 0xFBE8; con el fondo partido, 0xFBEE, la parte de abajo sigue desde 0xF7ED) a 0xFBF2; y la casilla que hay, a 0xFBF4
	push hl			;5a9d
	ld e,l			;5a9e
	ld l,h			;5a9f
	ld h,000h		;5aa0
	ld d,h			;5aa2
	ld a,005h		;5aa3   ; x 32
mapa_posicion_x32:
	add hl,hl			;5aa5
	dec a			;5aa6
	jr nz,mapa_posicion_x32		;5aa7
	add hl,de			;5aa9
	ld de,03801h		;5aaa   ; la tabla de nombres, columna 1
	add hl,de			;5aad
	ld (0fbf0h),hl		;5aae   ; la posicion en pantalla
	pop de			;5ab1
	ld bc,00016h		;5ab2   ; 22 casillas por fila
	ld a,(0fbeeh)		;5ab5   ; la fila partida
	and a			;5ab8
	jr nz,mapa_posicion_partida		;5ab9   ; partido
	ld hl,00000h		;5abb
	inc d			;5abe
mapa_posicion_fila:
	dec d			;5abf
	jr z,mapa_posicion_suma		;5ac0
	add hl,bc			;5ac2   ; + 22
	jr mapa_posicion_fila		;5ac3
mapa_posicion_suma:
	add hl,de			;5ac5
	ld de,(0fbe8h)		;5ac6   ; el mapa de trabajo
mapa_posicion_fin:
	add hl,de			;5aca
	ld (0fbf2h),hl		;5acb   ; la posicion en el mapa
	ld a,(hl)			;5ace   ; la casilla que hay
	ld (0fbf4h),a		;5acf   ; la casilla de debajo
	ret			;5ad2
mapa_posicion_partida:
	ld hl,(0f7edh)		;5ad3   ; el principio del mapa
	push hl			;5ad6
	add a,d			;5ad7
	sub 018h		;5ad8   ; por encima de la fila 24?
	jr c,mapa_posicion_arriba		;5ada
	ld d,a			;5adc
mapa_posicion_filas:
	ld hl,00000h		;5add
	inc d			;5ae0
mapa_posicion_fila2:
	dec d			;5ae1
	jr z,mapa_posicion_suma2		;5ae2
	add hl,bc			;5ae4
	jr mapa_posicion_fila2		;5ae5
mapa_posicion_suma2:
	add hl,de			;5ae7
	pop de			;5ae8
	jr mapa_posicion_fin		;5ae9
mapa_posicion_arriba:
	ld hl,(0fbe8h)		;5aeb   ; el mapa de trabajo
	ex (sp),hl			;5aee
	jr mapa_posicion_filas		;5aef
casilla_a_ram:		; El dibujo y los colores de la casilla A (VRAM 0x800 + A x 8 y 0x2800 + ...) a DE (8 + 8 bytes)
	ld l,a			;5af1
	ld h,000h		;5af2
	add hl,hl			;5af4
	add hl,hl			;5af5
	add hl,hl			;5af6
	ld bc,00800h		;5af7
	add hl,bc			;5afa
	ld bc,00008h		;5afb
	call ldirmv_mas		;5afe   ; LDIRMV: el dibujo
	set 5,h		;5b01
	jp ldirmv_mas		;5b03   ; LDIRMV: los colores
compara_b:		; Z si los B bytes de DE y HL son iguales
	ld a,(de)			;5b06   ; el de DE
	cp (hl)			;5b07   ; igual?
	ret nz			;5b08   ; no
	inc hl			;5b09
	inc de			;5b0a
	djnz compara_b		;5b0b   ; los B
	ret			;5b0d
fila_mete:		; Mete una fila de 22 casillas en el mapa en la posicion del cursor (con desplazamiento; con la clase de juego de bit 3 no): si no hay sitio (0xF7E7 + 22 por encima de 0xF7EF), "no hay memoria" (0x81BA); hace sitio (0xA242), baja lo de antes, la llena con el borde (0xFBFD) o, en el laberinto, con 0x70; si la fila partida (0xFBEE) queda por debajo, sube una
	ld a,(0f421h)		;5b0e   ; la clase de juego
	and 008h		;5b11   ; sin desplazamiento?
	ret nz			;5b13
	ld bc,00016h		;5b14   ; 22 bytes
	ld hl,(0f7e7h)		;5b17   ; el final de lo usado...
	add hl,bc			;5b1a
	ld de,(0f7efh)		;5b1b   ; ...contra el limite
	and a			;5b1f
	sbc hl,de		;5b20
	jp nc,sin_memoria		;5b22   ; no cabe
	call ram_pide_mapa		;5b25   ; sitio
	call fila_posicion		;5b28   ; la posicion de la fila
	push hl			;5b2b
	push bc			;5b2c
	and a			;5b2d
	sbc hl,de		;5b2e
	add hl,bc			;5b30
	ld b,h			;5b31
	ld c,l			;5b32
	ex de,hl			;5b33
	pop de			;5b34
	push de			;5b35
	push hl			;5b36
	and a			;5b37
	sbc hl,de		;5b38
	ld (0f7edh),hl		;5b3a   ; el principio, mas abajo
	pop de			;5b3d
	ex de,hl			;5b3e
	ldir		;5b3f   ; lo de antes baja
	pop bc			;5b41
	ld b,c			;5b42
	pop hl			;5b43
	ld a,(0f421h)		;5b44   ; laberinto?
	cp 020h		;5b47
	ld a,(0fbfdh)		;5b49   ; la casilla del borde
	jr c,fila_mete_llena		;5b4c
	ld a,070h		;5b4e   ; laberinto: el camino 0x70
fila_mete_llena:
	call llena_b		;5b50   ; la fila nueva
	ld a,(0fbeeh)		;5b53   ; partido?
	and a			;5b56
	jr z,fila_mete_fin		;5b57
	ld b,a			;5b59
	ld a,018h		;5b5a   ; 24 - partida...
	ld hl,(0fbc6h)		;5b5c   ; ...contra la fila del cursor
	sub b			;5b5f
	cp l			;5b60
	jr z,fila_mete_parte		;5b61
	jr nc,fila_mete_fin		;5b63
fila_mete_parte:
	ld hl,0fbeeh		;5b65
	inc (hl)			;5b68   ; una mas
	ld hl,(0fbe8h)		;5b69   ; el mapa de trabajo
	ld de,00016h		;5b6c
	add hl,de			;5b6f
	ld de,(0fbech)		;5b70   ; el final del mapa
	rst 20h			;5b74   ; al final?
	jr nz,fila_mete_trabajo		;5b75
	xor a			;5b77   ; vuelve al principio
	ld (0fbeeh),a		;5b78   ; la fila partida
	ld hl,(0f7edh)		;5b7b   ; el principio del mapa
fila_mete_trabajo:
	ld (0fbe8h),hl		;5b7e   ; el mapa de trabajo
fila_mete_fin:
	jp mapa_pinta		;5b81
fila_quita:		; Quita la fila del cursor del mapa (con desplazamiento, si queda mas de una pantalla): sube lo de antes 22 bytes (lddr), devuelve el sitio (0xA241), el principio del mapa 22 mas arriba; ajusta el mapa de trabajo y la fila partida
	ld a,(0f421h)		;5b84   ; la clase de juego
	and 008h		;5b87   ; sin desplazamiento?
	ret nz			;5b89
	ld hl,(0f7edh)		;5b8a   ; el principio del mapa...
	ld de,(0fbeah)		;5b8d   ; ...contra el del primer trozo
	rst 20h			;5b91   ; DCOMPR
	ret z			;5b92   ; una sola pantalla: no
	ld bc,(0fbe8h)		;5b93   ; el mapa de trabajo
	and a			;5b97
	sbc hl,bc		;5b98
	ld a,002h		;5b9a
	jr z,fila_quita_cero		;5b9c
	ld h,b			;5b9e
	ld l,c			;5b9f
	ex de,hl			;5ba0   ; delante o detras?
	rst 20h			;5ba1   ; DCOMPR
	ld a,001h		;5ba2
	jr nc,fila_quita_va		;5ba4
	ld a,003h		;5ba6
fila_quita_va:
	push af			;5ba8
	call fila_posicion		;5ba9   ; la posicion de la fila
	push hl			;5bac
	jr z,fila_quita_primera		;5bad
	push hl			;5baf
	and a			;5bb0
	sbc hl,de		;5bb1
	ex (sp),hl			;5bb3
	dec hl			;5bb4
	ld d,h			;5bb5
	ld e,l			;5bb6
	add hl,bc			;5bb7
	ex de,hl			;5bb8
	pop bc			;5bb9
	lddr		;5bba   ; sube lo de antes
	inc de			;5bbc
	push de			;5bbd
fila_quita_sitio:
	ld bc,00016h		;5bbe   ; 22 bytes
	call ram_devuelve		;5bc1   ; devueltos
	pop de			;5bc4
	ld (0f7edh),de		;5bc5   ; el principio del mapa
	pop de			;5bc9
	pop af			;5bca
	sub 002h		;5bcb
	jr c,fila_quita_fin		;5bcd
	jr z,fila_quita_final		;5bcf
	ld hl,(0fbe8h)		;5bd1   ; el mapa de trabajo
	rst 20h			;5bd4   ; DCOMPR
	jr c,fila_quita_fin		;5bd5
	ld de,00016h		;5bd7
	and a			;5bda
	sbc hl,de		;5bdb
	ld (0fbe8h),hl		;5bdd   ; el mapa de trabajo
	ld hl,0fbeeh		;5be0
	dec (hl)			;5be3
	jr fila_quita_fin		;5be4
fila_quita_final:
	ld hl,(0fbech)		;5be6   ; el final del mapa
	ld de,00016h		;5be9
	and a			;5bec
	sbc hl,de		;5bed
	ld (0fbe8h),hl		;5bef   ; el mapa de trabajo
	ld a,017h		;5bf2
	ld (0fbeeh),a		;5bf4   ; la fila partida
fila_quita_fin:
	jp mapa_pinta		;5bf7
fila_quita_primera:
	add hl,bc			;5bfa
	push hl			;5bfb
	jr fila_quita_sitio		;5bfc
fila_quita_cero:
	ld a,(0fbe6h)		;5bfe   ; el fondo
	and a			;5c01   ; sin fondo?
	ld a,002h		;5c02
	jr nz,fila_quita_va		;5c04
	call fila_posicion		;5c06   ; la posicion de la fila
	jr z,fila_quita_cero_va		;5c09   ; la primera
	push bc			;5c0b
	push hl			;5c0c
	and a			;5c0d
	sbc hl,de		;5c0e   ; lo de antes
	ex (sp),hl			;5c10
	dec hl			;5c11
	ld d,h			;5c12
	ld e,l			;5c13
	add hl,bc			;5c14
	ex de,hl			;5c15
	pop bc			;5c16
	lddr		;5c17   ; baja
	pop bc			;5c19
fila_quita_cero_va:
	push bc			;5c1a
	call ram_devuelve		;5c1b
	pop bc			;5c1e
	ld hl,(0fbe8h)		;5c1f   ; el mapa de trabajo
	add hl,bc			;5c22
	ld (0fbe8h),hl		;5c23   ; el mapa de trabajo
	ld hl,(0f7edh)		;5c26   ; el principio del mapa
	add hl,bc			;5c29
	ld (0f7edh),hl		;5c2a   ; el principio del mapa
	jp mapa_pinta		;5c2d
fila_posicion:		; HL = la posicion en el mapa de la fila del cursor (0xFBC6 x 22 desde el mapa de trabajo; partido, la parte de abajo desde 0xF7ED); DE = el principio del mapa; C = 22; Z si es el principio
	ld b,016h		;5c30
	ld hl,(0fbe8h)		;5c32   ; el mapa de trabajo
	push hl			;5c35
	ld de,(0fbc6h)		;5c36   ; la fila del cursor de casilla
	ld d,000h		;5c3a
	ld h,d			;5c3c
	ld l,d			;5c3d
	ld a,(0fbeeh)		;5c3e   ; la fila partida
	and a			;5c41
	jr z,fila_posicion_x22		;5c42
	ld c,a			;5c44
	ld a,018h		;5c45
	sub c			;5c47
	ld c,a			;5c48
	ld a,e			;5c49
	sub c			;5c4a
	jr c,fila_posicion_x22		;5c4b
	ld e,a			;5c4d
	ex (sp),hl			;5c4e
	ld hl,(0f7edh)		;5c4f   ; el principio del mapa
	ex (sp),hl			;5c52
fila_posicion_x22:
	add hl,de			;5c53
	djnz fila_posicion_x22		;5c54
	pop de			;5c56
	add hl,de			;5c57
	ld de,(0f7edh)		;5c58   ; el principio del mapa
	ld c,016h		;5c5c
	rst 20h			;5c5e   ; DCOMPR
	ret			;5c5f
paleta_cursor:		; Mueve el cursor de la paleta de casillas (0xFBF8 columna 0-3, 0xFBF9 fila, 0xFBFA desplazamiento de la paleta, hasta 0x22) en la direccion A; la casilla elegida (0xFBEF) va con el: +-1 en la fila, +-4 al cambiar de fila; si se pasa de la ventana de 6 filas, la paleta se desplaza (0x5CE0); la casilla elegida, ampliada
	and a			;5c60   ; sin direccion
	ret z			;5c61
	push af			;5c62
	ld hl,0fbf8h		;5c63   ; la columna
	ld de,0fbfah		;5c66   ; el desplazamiento
	ld bc,(0fbefh)		;5c69   ; la casilla elegida
	ld b,001h		;5c6d
	and 003h		;5c6f   ; en horizontal?
	jr z,paleta_cursor_v		;5c71
	dec b			;5c73
	pop af			;5c74
	push af			;5c75
	bit 2,a		;5c76   ; hacia atras?
	jr nz,paleta_cursor_izq		;5c78
	ld a,(hl)			;5c7a
	cp 003h		;5c7b   ; la columna 3?
	jr z,paleta_cursor_v		;5c7d
	inc c			;5c7f   ; la casilla siguiente
	inc (hl)			;5c80
	jr paleta_cursor_v		;5c81
paleta_cursor_izq:
	ld a,(hl)			;5c83
	and a			;5c84   ; la columna 0?
	jr z,paleta_cursor_v		;5c85
	dec c			;5c87   ; la de antes
	dec (hl)			;5c88
paleta_cursor_v:
	inc hl			;5c89
	ld a,c			;5c8a
	ld (0fbefh),a		;5c8b   ; la casilla elegida
	pop af			;5c8e
	push af			;5c8f
	and 003h		;5c90
	cp 002h		;5c92
	jr z,paleta_cursor_h		;5c94
	pop af			;5c96
	push af			;5c97
	inc a			;5c98
	bit 2,a		;5c99   ; hacia abajo?
	ld a,(hl)			;5c9b
	jr nz,paleta_cursor_abajo		;5c9c
	cp 001h		;5c9e   ; la fila 0?
	jr c,paleta_cursor_vuelve		;5ca0
	push af			;5ca2
	ld a,c			;5ca3   ; 4 casillas menos
	sub 004h		;5ca4
	ld (0fbefh),a		;5ca6   ; la casilla elegida
	dec (hl)			;5ca9
	pop af			;5caa
	jr nz,paleta_cursor_fin		;5cab
	ld a,(de)			;5cad   ; desplazada?
	and a			;5cae
	jr z,paleta_cursor_fin		;5caf
	inc (hl)			;5cb1
	dec a			;5cb2   ; la paleta baja una fila
	ld (de),a			;5cb3
paleta_cursor_pinta:
	call paleta_casillas		;5cb4   ; la paleta
paleta_cursor_fin:
	ld hl,(0fbeeh)		;5cb7   ; la fila partida
	call casilla_dibujo		;5cba   ; su dibujo
	call casilla_ampliada		;5cbd   ; ampliada
paleta_cursor_vuelve:
	pop af			;5cc0
	ret			;5cc1
paleta_cursor_h:
	djnz paleta_cursor_fin		;5cc2
	jr paleta_cursor_vuelve		;5cc4
paleta_cursor_abajo:
	sub 006h		;5cc6   ; la fila 6?
	jr z,paleta_cursor_vuelve		;5cc8
	ld a,c			;5cca
	add a,004h		;5ccb   ; 4 casillas mas
	ld (0fbefh),a		;5ccd   ; la casilla elegida
	ld a,(hl)			;5cd0
	inc (hl)			;5cd1
	cp 005h		;5cd2   ; la ultima de la ventana?
	jr nz,paleta_cursor_fin		;5cd4
	ld a,(de)			;5cd6
	cp 022h		;5cd7   ; la paleta ya al final?
	jr z,paleta_cursor_fin		;5cd9
	dec (hl)			;5cdb
	inc a			;5cdc   ; la paleta sube una fila
	ld (de),a			;5cdd
	jr paleta_cursor_pinta		;5cde
paleta_casillas:		; La paleta de casillas en la columna 0x17 de la tabla de nombres (0x3817): 7 filas de 4 casillas (desde 0x58 + 4 x 0xFBFA) separadas por la casilla 0x4B, por los puertos del VDP (despues de un "halt")
	ld hl,03817h		;5ce0   ; fila 0, columna 0x17
	ld a,(0fbfah)		;5ce3   ; el desplazamiento...
	add a,a			;5ce6   ; ...x 4...
	add a,a			;5ce7
	add a,057h		;5ce8   ; ...+ 0x58 (- 1)
	ld c,007h		;5cea   ; 7 filas
	ld de,00020h		;5cec   ; cada 32
	halt			;5cef   ; espera la interrupcion
paleta_fila:
	push af			;5cf0
	call 00053h		;5cf1   ; SETWRT
	ld b,004h		;5cf4   ; 4 casillas
paleta_casilla:
	pop af			;5cf6
	inc a			;5cf7   ; la siguiente
	push af			;5cf8
	out (098h),a		;5cf9   ; al VDP
	ld a,04bh		;5cfb   ; la casilla 0x4B entre medias
	ex (sp),hl			;5cfd   ; espera
	ex (sp),hl			;5cfe
	out (098h),a		;5cff   ; al VDP
	djnz paleta_casilla		;5d01
	add hl,de			;5d03   ; la fila de abajo
	ld b,008h		;5d04   ; 8 casillas 0x4B
	call 00053h		;5d06   ; SETWRT
paleta_separa:
	ld a,04bh		;5d09
	ex (sp),hl			;5d0b
	ex (sp),hl			;5d0c
	out (098h),a		;5d0d   ; al VDP
	djnz paleta_separa		;5d0f
	pop af			;5d11
	add hl,de			;5d12   ; la fila de abajo
	dec c			;5d13
	jr nz,paleta_fila		;5d14
	ret			;5d16
fondo_rotulo:		; El hueco del rotulo (0x39D7, dos filas de 8 casillas 0x4B); con tres fondos (bit 3 de la clase), el texto de 0x5D4A y el numero de fondo (0xFBFB + 0x21: "1", "2" o "3")
	ld hl,039d7h		;5d17
	ld a,04bh		;5d1a   ; la casilla 0x4B
	ld bc,00008h		;5d1c
	call 00056h		;5d1f   ; FILVRM
	ld bc,00020h		;5d22
	add hl,bc			;5d25
	ld bc,00008h		;5d26
	call 00056h		;5d29   ; FILVRM
	ld a,(0f421h)		;5d2c   ; la clase de juego
	bit 3,a		;5d2f   ; tres fondos?
	ret z			;5d31
	ld hl,05d4ah		;5d32   ; el texto
	ld de,039d7h		;5d35
	ld bc,00007h		;5d38
	call ldirvm_mas		;5d3b   ; LDIRVM
	ld c,007h		;5d3e
	ex de,hl			;5d40
	add hl,bc			;5d41
	ld a,(0fbfbh)		;5d42   ; el fondo...
	add a,021h		;5d45   ; ...en cifra
	jp 0004dh		;5d47   ; WRTVRM

; ----------------------------------------------------------------------
; DATOS fondo_texto: Las 7 casillas del rotulo del fondo (con 0x5D17)
;   0x5d4a..0x5d51  (7 bytes)
DATA_fondo_texto:
	defb 043h,033h,042h,035h,035h,03eh,04bh	; 5d4a

; ======================================================================
; CODIGO 0x5d51..0x5ed4  (387 bytes)
; ======================================================================


fondo_cambia:		; Las teclas de cambiar de pantalla (A: bit 0 a 1 no hace nada): en el laberinto, antes 0x5F61; con desplazamiento, el mapa sube o baja una fila (0x5E51 o 0x5E94); con tres fondos, A & 3 = 0 el anterior (0x5E2B), 2 el siguiente: si no existe, se crea (0xA242) copiando el de antes (o los dos) o lleno de casillas (0x58EE) o de 0x70 en el laberinto
	and 007h		;5d51
	rrca			;5d53
	ret c			;5d54
	ld hl,(0f421h)		;5d55   ; la clase de juego
	push hl			;5d58
	bit 6,l		;5d59   ; laberinto?
	push af			;5d5b
	call nz,laberinto_dibujos		;5d5c
	pop af			;5d5f
	pop hl			;5d60
	bit 3,l		;5d61   ; tres fondos?
	jr nz,fondo_cambia_tres		;5d63
	inc a			;5d65
	bit 1,a		;5d66
	push af			;5d68
	call z,mapa_sube		;5d69   ; sube
	pop af			;5d6c
	call nz,mapa_baja		;5d6d   ; baja
	jp mapa_pinta		;5d70
fondo_cambia_tres:
	and 003h		;5d73   ; el anterior?
	jp z,fondo_anterior		;5d75
	cp 002h		;5d78   ; el siguiente?
	ret nz			;5d7a
	call tipo_11		;5d7b   ; un fondo?
	ret z			;5d7e
	ld bc,00210h		;5d7f   ; 0x210 bytes por fondo
	ld hl,(0fbe8h)		;5d82   ; el mapa de trabajo
	ld de,(0fbeah)		;5d85   ; el ultimo?
	rst 20h			;5d89   ; DCOMPR
	jr z,fondo_nuevo		;5d8a
	ld a,(0fbfbh)		;5d8c   ; el fondo...
	inc a			;5d8f   ; ...uno mas
	ld (0fbfbh),a		;5d90   ; el fondo de ahora
	add hl,bc			;5d93   ; el siguiente
fondo_cambia_pon:
	ld (0fbe8h),hl		;5d94   ; el mapa de trabajo
	ld a,(0f421h)		;5d97   ; laberinto?
	cp 020h		;5d9a
	call nc,laberinto_pinta		;5d9c
fondo_cambia_pinta:
	ld a,(0f421h)		;5d9f   ; el tipo de juego
	cp 018h		;5da2   ; combate de tres fondos?
	push hl			;5da4
	call z,fondo3_color		;5da5
	pop hl			;5da8
	call fondo_rotulo		;5da9   ; el rotulo
	jp mapa_pinta		;5dac
fondo_nuevo:
	ld a,(0fbfch)		;5daf   ; cuantos hay
	cp 002h		;5db2   ; los tres?
	jr nz,fondo_nuevo_crea		;5db4
	ld hl,(0f7edh)		;5db6   ; vuelve al primero
	xor a			;5db9
	ld (0fbfbh),a		;5dba   ; el fondo de ahora
	jr fondo_cambia_pon		;5dbd
fondo_nuevo_crea:
	push bc			;5dbf
	call ram_pide_mapa		;5dc0   ; sitio en la RAM
	pop bc			;5dc3
	push bc			;5dc4
	ld hl,(0f7edh)		;5dc5   ; el principio del mapa
	push hl			;5dc8
	and a			;5dc9   ; el principio baja 0x210
	sbc hl,bc		;5dca
	ld (0f7edh),hl		;5dcc   ; el principio del mapa
	ex de,hl			;5dcf
	ld a,(0fbfch)		;5dd0   ; hay dos?
	cp 001h		;5dd3
	jr nz,fondo_nuevo_copia		;5dd5
	ld h,b			;5dd7   ; copia los dos
	ld l,c			;5dd8
	add hl,hl			;5dd9
	ld b,h			;5dda
	ld c,l			;5ddb
fondo_nuevo_copia:
	pop hl			;5ddc
	ldir		;5ddd   ; lo de antes, abajo
	pop bc			;5ddf
	ld a,(0f421h)		;5de0   ; laberinto?
	cp 020h		;5de3
	jr nc,fondo_nuevo_laberinto		;5de5
	call mapa_nuevo		;5de7   ; el combate: casillas
	jr fondo_nuevo_fin		;5dea
fondo_nuevo_laberinto:
	ld hl,(0fbe8h)		;5dec   ; el mapa de trabajo
	ld d,070h		;5def   ; el camino 0x70
fondo_nuevo_llena:
	ld (hl),d			;5df1   ; la casilla
	inc hl			;5df2
	dec bc			;5df3   ; uno menos
	ld a,b			;5df4
	or c			;5df5
	jr nz,fondo_nuevo_llena		;5df6
fondo_nuevo_fin:
	ld hl,(0fbfbh)		;5df8   ; el fondo de ahora
	inc h			;5dfb   ; uno mas en los dos
	inc l			;5dfc
	ld (0fbfbh),hl		;5dfd   ; el fondo de ahora
	jr fondo_cambia_pinta		;5e00
fondo3_color:		; Con tres fondos: el color del fondo de este (0x2848 + 0xFBFB x 8, RDVRM) en los colores de la casilla 0x0C de las tres partes (0x2060, 0x2860, 0x3060)
	ld hl,02848h		;5e02
	ld a,(0fbfbh)		;5e05   ; el fondo
	add a,a			;5e08
	add a,a			;5e09
	add a,a			;5e0a
	call hl_mas_a		;5e0b   ; su casilla de color
	call 0004ah		;5e0e   ; RDVRM
	ld hl,02060h		;5e11   ; los colores de la casilla 0x0C
	ld bc,00008h		;5e14
	ld de,00800h		;5e17
	call 00056h		;5e1a   ; FILVRM
	add hl,de			;5e1d
	ld bc,00008h		;5e1e
	call 00056h		;5e21   ; FILVRM
	add hl,de			;5e24
	ld bc,00008h		;5e25
	jp 00056h		;5e28   ; FILVRM
fondo_anterior:		; El fondo anterior (0x210 bytes mas abajo); desde el primero, el ultimo (0xFBFC, 0xFBEA)
	ld hl,(0fbe8h)		;5e2b   ; el mapa de trabajo
	ld de,(0f7edh)		;5e2e   ; el principio
	ld bc,00210h		;5e32
	rst 20h			;5e35   ; el primero?
	jr nz,fondo_anterior_va		;5e36
	ld a,(0fbfch)		;5e38   ; al ultimo
	ld (0fbfbh),a		;5e3b   ; el fondo de ahora
	ld hl,(0fbeah)		;5e3e   ; el ultimo trozo del mapa
	jp fondo_cambia_pon		;5e41
fondo_anterior_va:
	and a			;5e44
	sbc hl,bc		;5e45
	ld a,(0fbfbh)		;5e47   ; uno menos
	dec a			;5e4a
	ld (0fbfbh),a		;5e4b   ; el fondo de ahora
	jp fondo_cambia_pon		;5e4e
mapa_sube:		; El mapa de trabajo una fila hacia el principio (22 bytes); desde el principio, al final (0xFBEC - 22, partido en la fila 0x17), salvo jugando con el desplazamiento de menos de 7 (0xF418); 0xFBE7 = 1 si se ha movido
	xor a			;5e51   ; sin mover
	ld (0fbe7h),a		;5e52   ; el mapa se ha movido
	ld hl,(0f7edh)		;5e55   ; el principio...
	ld de,(0fbe8h)		;5e58   ; ...es el de trabajo?
	sbc hl,de		;5e5c
	ld hl,00016h		;5e5e   ; una fila
	jr nz,mapa_sube_fila		;5e61
	ld a,(0fa04h)		;5e63   ; jugando?
	and a			;5e66
	jr z,mapa_sube_vuelta		;5e67
	ld a,(0f418h)		;5e69   ; el desplazamiento
	cp 007h		;5e6c   ; de menos de 7: no da la vuelta
	ret c			;5e6e
mapa_sube_vuelta:
	ex de,hl			;5e6f
	ld hl,(0fbech)		;5e70   ; el final
	and a			;5e73
	sbc hl,de		;5e74
	ld (0fbe8h),hl		;5e76   ; el mapa de trabajo
	ld a,017h		;5e79   ; partido en la 0x17
	ld (0fbeeh),a		;5e7b   ; la fila partida
mapa_sube_fin:
	xor a			;5e7e
	inc a			;5e7f
	ld (0fbe7h),a		;5e80   ; se ha movido
	ret			;5e83
mapa_sube_fila:
	ex de,hl			;5e84
	xor a			;5e85
	sbc hl,de		;5e86   ; una fila mas arriba
	ld (0fbe8h),hl		;5e88   ; el mapa de trabajo
	ld hl,0fbeeh		;5e8b   ; la fila partida
	or (hl)			;5e8e
	jr z,mapa_sube_fin		;5e8f
	dec (hl)			;5e91   ; una menos
	jr mapa_sube_fin		;5e92
mapa_baja:		; El mapa de trabajo una fila hacia el final; en el ultimo trozo, se parte (0xFBEE) y sigue por el principio (al dar la vuelta entera, de nuevo desde 0xF7ED); 0xFBE7 = 2
	xor a			;5e94   ; sin mover
	ld (0fbe7h),a		;5e95   ; el mapa se ha movido
	ld hl,(0fbeah)		;5e98   ; el ultimo trozo...
	ld de,(0fbe8h)		;5e9b   ; ...es el de trabajo?
	sbc hl,de		;5e9f
	ld hl,0fbeeh		;5ea1   ; la fila partida
	jr nz,mapa_baja_mira		;5ea4
	ld a,(0fa04h)		;5ea6   ; jugando?
	and a			;5ea9
	jr z,mapa_baja_parte		;5eaa
	ld a,(0f418h)		;5eac   ; el desplazamiento
	cp 007h		;5eaf
	ret c			;5eb1
mapa_baja_parte:
	ld (hl),001h		;5eb2   ; partido en la 1
	jr mapa_baja_fila		;5eb4
mapa_baja_mira:
	ld a,(hl)			;5eb6   ; partido?
	and a			;5eb7
	jr nz,mapa_baja_partido		;5eb8
mapa_baja_fila:
	ld hl,00016h		;5eba   ; una fila mas abajo
	add hl,de			;5ebd
mapa_baja_pon:
	ld (0fbe8h),hl		;5ebe   ; el mapa de trabajo
	ld a,002h		;5ec1   ; se ha movido hacia abajo
	ld (0fbe7h),a		;5ec3   ; el mapa se ha movido
	and a			;5ec6
	ret			;5ec7
mapa_baja_partido:
	inc a			;5ec8   ; una mas
	ld (hl),a			;5ec9
	sub 018h		;5eca   ; la 24?
	jr nz,mapa_baja_fila		;5ecc
	ld (hl),a			;5ece   ; ya no esta partido
	ld hl,(0f7edh)		;5ecf   ; desde el principio
	jr mapa_baja_pon		;5ed2

; ----------------------------------------------------------------------
; DATOS sin_uso_5ed4: 26 bytes con pinta de codigo que nadie llama ni salta
;   (codigo muerto)
;   0x5ed4..0x5eee  (26 bytes)
DATA_sin_uso_5ed4:
	defb 0cdh,00eh,05fh,0ebh,0d9h,0ebh,076h,0d9h,0f5h,0cdh,0bbh,041h,0d5h,011h,020h,000h	; 5ed4  .._...v....A.. .
	defb 019h,0d1h,0f1h,03dh,020h,0f2h,008h,0c8h,018h,0edh	; 5ee4  ...= .....

; ======================================================================
; CODIGO 0x5eee..0x5f30  (66 bytes)
; ======================================================================


mapa_pinta:		; Las 24 filas del mapa a la pantalla (columna 1, 22 casillas): desde el mapa de trabajo y, si esta partido, el resto desde el principio (0xF7ED); fuera de la partida espera la interrupcion
	call mapa_cuentas		;5eee   ; las cuentas
	push af			;5ef1
	ld a,(0fa04h)		;5ef2   ; jugando?
	and a			;5ef5
	jr nz,mapa_pinta_va		;5ef6
	halt			;5ef8   ; espera la interrupcion
mapa_pinta_va:
	pop af			;5ef9
mapa_pinta_fila:
	push af			;5efa
	call ldirvm_mas		;5efb   ; LDIRVM: 22 casillas
	push hl			;5efe
	ld hl,00020h		;5eff   ; la fila de abajo
	add hl,de			;5f02
	ex de,hl			;5f03
	pop hl			;5f04
	pop af			;5f05
	dec a			;5f06   ; la siguiente
	jr nz,mapa_pinta_fila		;5f07
	ex af,af'			;5f09   ; partido?
	ret z			;5f0a
	exx			;5f0b   ; la parte de arriba, del principio
	jr mapa_pinta_fila		;5f0c
mapa_cuentas:		; Prepara mapa_pinta: A = las filas hasta la partida (24 - 0xFBEE) y en los registros de reserva las de la otra parte (desde 0xF7ED, a la pantalla debajo); HL = el mapa de trabajo, DE = 0x3801, BC = 22
	ld a,(0fbeeh)		;5f0e   ; la fila partida
	and a			;5f11
	ld b,a			;5f12
	ex af,af'			;5f13
	ld a,018h		;5f14   ; 24 - partida
	sub b			;5f16
	push af			;5f17
	call por32_a		;5f18   ; x 32
	ld hl,03801h		;5f1b   ; la tabla de nombres, columna 1
	push hl			;5f1e
	add hl,bc			;5f1f
	ex de,hl			;5f20
	ld bc,00016h		;5f21   ; 22 casillas
	push bc			;5f24
	ld hl,(0f7edh)		;5f25   ; el principio
	exx			;5f28
	pop bc			;5f29
	pop de			;5f2a
	pop af			;5f2b
	ld hl,(0fbe8h)		;5f2c   ; el mapa de trabajo
	ret			;5f2f

; ----------------------------------------------------------------------
; DATOS sin_uso_5f30: 16 bytes que nadie lee
;   0x5f30..0x5f40  (16 bytes)
DATA_sin_uso_5f30:
	defb 0b0h,000h,016h,010h,000h,000h,016h,010h,096h,000h,01eh,010h,000h,000h,01eh,00dh	; 5f30  ................

; ======================================================================
; CODIGO 0x5f40..0x6119  (473 bytes)
; ======================================================================


mapa_casilla_elegida:		; La casilla elegida (0xFBEF) al mapa y a la pantalla, y el cursor un paso
	push af			;5f40
	ld a,(0fbefh)		;5f41   ; la casilla elegida
	call mapa_pon_pinta		;5f44
	pop af			;5f47
mapa_cursor_mueve:		; El cursor de casilla un paso; si se mueve, el borde del mapa (0x59BD) y la casilla de debajo a la pantalla
	call cursor_casilla_paso		;5f48
	ret z			;5f4b
	call mapa_borde		;5f4c
	ld a,(0fbf4h)		;5f4f   ; la casilla de debajo
	jp pantalla_pon		;5f52
mapa_casilla_coge:		; El cursor un paso y la casilla de debajo pasa a ser la elegida (0xFBEF)
	call mapa_cursor_paso_va		;5f55
	ld a,(0fbf4h)		;5f58   ; la casilla de debajo
	ld (0fbefh),a		;5f5b   ; la casilla elegida
	jp editor_pinta		;5f5e
laberinto_dibujos:		; En el laberinto: los dibujos de las casillas 0x6F-0x76 (0x40 bytes) se copian a las otras partes de la VRAM (0x5F82)
	call casillas_6f		;5f61
laberinto_dibujos_uno:
	call ldirmv		;5f64   ; LDIRMV
	bit 5,h		;5f67   ; ya los colores?
	jr nz,laberinto_dibujos_c		;5f69
	push hl			;5f6b
	call casillas_fondo		;5f6c
	jr laberinto_dibujos_va		;5f6f
laberinto_dibujos_c:
	ex (sp),hl			;5f71
laberinto_dibujos_va:
	push hl			;5f72
	call tres_partes		;5f73
	pop hl			;5f76
	set 5,h		;5f77   ; a los colores
	ex (sp),hl			;5f79
	bit 5,h		;5f7a
	set 5,h		;5f7c
	jr z,laberinto_dibujos_uno		;5f7e
	pop hl			;5f80
	ret			;5f81
tres_partes:		; Lo de 0xFAC2 a las tres partes de la VRAM (desde HL - 0x800, cada 0x800)
	ld a,h			;5f82
	sub 008h		;5f83
	ld h,a			;5f85
	ex de,hl			;5f86
	ld a,003h		;5f87
tres_partes_uno:
	push af			;5f89
	call ldirvm		;5f8a   ; LDIRVM
	ld a,008h		;5f8d   ; la parte siguiente
	add a,d			;5f8f
	ld d,a			;5f90
	pop af			;5f91
	dec a			;5f92
	jr nz,tres_partes_uno		;5f93
	ex de,hl			;5f95
	ret			;5f96
casillas_fondo:		; HL = los dibujos de las casillas del fondo de ahora (0x77 + 8 x fondo con tres fondos; si no, 0x77), BC = 0x40 y DE = 0xFAC2
	ld bc,00040h		;5f97
	ld hl,00077h		;5f9a
	ld de,00008h		;5f9d
	ld a,(0f421h)		;5fa0   ; la clase de juego
	bit 3,a		;5fa3   ; tres fondos?
	jr z,casillas_fondo_va		;5fa5
	ld a,(0fbfbh)		;5fa7   ; el fondo
	sub 001h		;5faa
	jr c,casillas_fondo_va		;5fac
	jr z,casillas_fondo_8		;5fae
	add hl,de			;5fb0
casillas_fondo_8:
	add hl,de			;5fb1
casillas_fondo_va:
	call casilla_vram		;5fb2
	ld de,0fac2h		;5fb5
	ret			;5fb8
casillas_6f:		; HL = los dibujos de las casillas desde la 0x6F, BC = 0x40
	ld l,06fh		;5fb9
	ld bc,00040h		;5fbb
	jr casillas_fondo_va		;5fbe
laberinto_pinta:		; En el laberinto: los dibujos de las 8 casillas del fondo (0x5F97) se copian en las casillas 0x6F... repitiendo las de pared (tres veces 8 bytes, 0xFACA -> 0xFAEA) y a las tres partes
	call casillas_fondo		;5fc0
laberinto_pinta_uno:
	call ldirmv		;5fc3   ; LDIRMV
	exx			;5fc6
	ld hl,0facah		;5fc7
	ld de,0faeah		;5fca
	ld a,003h		;5fcd
laberinto_pinta_copia:
	push hl			;5fcf
	ld bc,00008h		;5fd0   ; 8 bytes
	ldir		;5fd3   ; copiados
	pop hl			;5fd5
	dec a			;5fd6   ; tres veces
	jr nz,laberinto_pinta_copia		;5fd7
	exx			;5fd9
	bit 5,h		;5fda   ; ya los colores?
	jr nz,laberinto_pinta_c		;5fdc
	push hl			;5fde
	call casillas_6f		;5fdf   ; desde la 0x6F
	jr laberinto_pinta_va		;5fe2
laberinto_pinta_c:
	ex (sp),hl			;5fe4
laberinto_pinta_va:
	push hl			;5fe5
	call tres_partes		;5fe6   ; a las tres partes
	pop hl			;5fe9
	set 5,h		;5fea   ; los colores
	ex (sp),hl			;5fec
	bit 5,h		;5fed   ; ya los colores?
	set 5,h		;5fef
	jr z,laberinto_pinta_uno		;5ff1
	pop hl			;5ff3
	ret			;5ff4
sprites_dibujos_mueve:		; Mueve los dibujos de los sprites (de 32 bytes) del hueco C a B... dentro de la VRAM 0x1800 (por 0xFAC2, de 8 en 8) y borra lo que queda; C si no cabe
	push bc			;5ff5
	push bc			;5ff6
	ld c,b			;5ff7   ; el hueco de destino...
	call por32		;5ff8   ; ...x 32
	ld de,01800h		;5ffb   ; los dibujos de sprite
	ld h,b			;5ffe
	ld l,c			;5fff
	add hl,de			;6000   ; el destino en la VRAM
	pop bc			;6001
	ld a,b			;6002   ; el de origen...
	add a,c			;6003   ; ...+ los que se mueven
	call por32_a		;6004   ; x 32
	ex de,hl			;6007
	add hl,bc			;6008   ; el origen en la VRAM
	scf			;6009   ; C: hacia arriba
	jr sprites_dibujos_va		;600a
sprites_dibujos_baja:		; Lo mismo hacia abajo desde 0x1C00
	push bc			;600c
	call por32		;600d   ; x 32
	ld de,01c00h		;6010   ; desde el final (0x1C00)
	xor a			;6013
	ld h,a			;6014
	ld l,a			;6015
	sbc hl,bc		;6016   ; hacia atras
	add hl,de			;6018
	and a			;6019   ; NC: hacia abajo
sprites_dibujos_va:
	pop bc			;601a
	push bc			;601b
	push af			;601c
	ld a,020h		;601d   ; 32 sprites...
	sub b			;601f   ; ...menos el principio...
	sub c			;6020   ; ...menos los que se mueven
	jr z,sprites_dibujos_fin		;6021   ; nada que mover
	jr nc,sprites_dibujos_trozo		;6023   ; hay
	pop af			;6025
	pop bc			;6026
	scf			;6027   ; no caben
	ret			;6028
sprites_dibujos_trozo:
	ld c,008h		;6029   ; 8 de cada vez
	sub 008h		;602b   ; quedan mas?
	jr z,sprites_dibujos_ultimo		;602d
	jr nc,sprites_dibujos_copia		;602f
	add a,008h		;6031   ; los que quedan
	ld c,a			;6033
sprites_dibujos_ultimo:
	scf			;6034
sprites_dibujos_copia:
	ex af,af'			;6035
	call por32		;6036   ; x 32: los bytes
	pop af			;6039
	push de			;603a
	push af			;603b
	ld de,0fac2h		;603c   ; por 0xFAC2
	jr nc,sprites_dibujos_atras		;603f   ; hacia abajo?
	call ldirmv		;6041   ; LDIRMV
	add hl,bc			;6044   ; el siguiente trozo
	jr sprites_dibujos_pon		;6045
sprites_dibujos_atras:
	sbc hl,bc		;6047   ; el trozo anterior
	call ldirmv		;6049   ; LDIRMV
sprites_dibujos_pon:
	pop af			;604c
	ex (sp),hl			;604d
	push af			;604e
	jr nc,sprites_dibujos_pon2		;604f
	ex de,hl			;6051   ; al destino
	call ldirvm		;6052   ; LDIRVM
	ex de,hl			;6055
	add hl,bc			;6056   ; el siguiente
	ex de,hl			;6057
	jr sprites_dibujos_sig		;6058
sprites_dibujos_pon2:
	sbc hl,bc		;605a   ; el anterior
	ex de,hl			;605c
	call ldirvm		;605d   ; LDIRVM
sprites_dibujos_sig:
	pop af			;6060
	pop hl			;6061
	push af			;6062
	ex af,af'			;6063
	jr nc,sprites_dibujos_trozo		;6064   ; quedan?
sprites_dibujos_fin:
	pop af			;6066
	jr nc,sprites_dibujos_borra		;6067   ; hacia abajo?
	ex de,hl			;6069
sprites_dibujos_borra:
	pop bc			;606a
	push bc			;606b
	call por32		;606c   ; los que quedan libres...
	xor a			;606f   ; ...a 0
	call 00056h		;6070   ; FILVRM: a 0
	pop bc			;6073
	and a			;6074   ; NC: hecho
	ret			;6075
por32_a:		; BC = A x 32 (A en C)
	ld c,a			;6076
por32:		; BC = C x 32
	xor a			;6077   ; los 3 bits de abajo de C...
	ld b,003h		;6078
por32_uno:
	sra c		;607a   ; x 2 (C > 1)...
	rra			;607c   ; ...entran en A
	djnz por32_uno		;607d
	ld b,c			;607f   ; B = C / 8
	ld c,a			;6080   ; C = el resto x 32
	ret			;6081
atributos_mueve:		; Mueve los bytes 3 (el color) de B sprites de la tabla de atributos (0x3B03) de C a la posicion nueva (con Z de entrada, desde 0x6083, al reves)
	or 0afh		;6082   ; NZ; desde 0x6083 "xor a": Z
	ex af,af'			;6084
	ld a,020h		;6085   ; 32 sprites...
	sub b			;6087   ; ...menos el principio...
	sub c			;6088   ; ...menos los que se mueven
	ret z			;6089   ; ninguno
	push bc			;608a
	ld h,a			;608b   ; los que quedan
	ld a,c			;608c   ; el principio...
	ld c,h			;608d
	add a,b			;608e   ; ...+ los que se mueven
	ld h,000h		;608f
	ld l,a			;6091
	add hl,hl			;6092   ; x 4
	add hl,hl			;6093
	ld de,03b03h		;6094   ; la tabla de atributos, byte 3
	add hl,de			;6097
	push hl			;6098   ; el origen
	ld h,000h		;6099
	ld l,b			;609b   ; el principio
	add hl,hl			;609c   ; x 4
	add hl,hl			;609d
	add hl,de			;609e   ; el destino
	ex af,af'			;609f
	jr nz,atributos_mueve_va		;60a0   ; NZ: hacia delante
	ex (sp),hl			;60a2   ; Z: al reves
atributos_mueve_va:
	ld de,0fac2h		;60a3   ; por 0xFAC2
	ld a,c			;60a6
	ld bc,00004h		;60a7   ; de 4 en 4 bytes
	push de			;60aa
	push af			;60ab
atributos_lee:
	push af			;60ac
	call 0004ah		;60ad   ; RDVRM
	ld (de),a			;60b0   ; a la RAM
	inc de			;60b1
	add hl,bc			;60b2   ; el siguiente sprite
	pop af			;60b3
	dec a			;60b4   ; uno menos
	jr nz,atributos_lee		;60b5
	pop af			;60b7
	pop de			;60b8
	pop hl			;60b9
atributos_escribe:
	push af			;60ba
	ld a,(de)			;60bb   ; de la RAM
	call 0004dh		;60bc   ; WRTVRM
	inc de			;60bf
	add hl,bc			;60c0   ; el siguiente sprite
	pop af			;60c1
	dec a			;60c2
	jr nz,atributos_escribe		;60c3
	pop bc			;60c5
	ret			;60c6
sprites_tabla_abre:		; Abre C huecos en la tabla de sprites de los personajes (0xFBFE-0xFC3D, 2 bytes cada uno) desde B: lo de detras baja (lddr) y los huecos a 0xFF; C si no caben
	ld h,000h		;60c7
	ld l,c			;60c9   ; los huecos...
	add hl,hl			;60ca   ; ...x 2
	ld de,0fc3dh		;60cb   ; el final de la tabla
	push de			;60ce
	ex de,hl			;60cf
	and a			;60d0
	sbc hl,de		;60d1   ; menos los huecos: lo que baja
	pop de			;60d3
	ld a,020h		;60d4   ; 32 pares...
	sub b			;60d6   ; ...menos el principio...
	sub c			;60d7   ; ...menos los huecos
	ret c			;60d8   ; no caben
	jr z,sprites_tabla_abre_va		;60d9   ; nada que bajar
	add a,a			;60db   ; x 2 bytes
	push bc			;60dc
	ld b,000h		;60dd
	ld c,a			;60df
	lddr		;60e0   ; baja
	pop bc			;60e2
sprites_tabla_abre_va:
	push bc			;60e3
	sla c		;60e4   ; x 2
	ld a,0ffh		;60e6   ; libres: 0xFF
sprites_tabla_abre_uno:
	ld (de),a			;60e8
	dec de			;60e9   ; el anterior
	dec c			;60ea
	jr nz,sprites_tabla_abre_uno		;60eb
	and a			;60ed   ; NC: hecho
	pop bc			;60ee
	ret			;60ef
sprites_tabla_cierra:		; Cierra C huecos de la tabla de sprites desde B: lo de detras sube (ldir) y el final a 0xFF
	ld h,000h		;60f0
	ld l,b			;60f2
	add hl,hl			;60f3   ; el principio x 2
	ld de,0fbfeh		;60f4   ; la tabla de sprites
	add hl,de			;60f7   ; el sitio
	ex de,hl			;60f8
	ld l,c			;60f9
	ld h,000h		;60fa
	add hl,hl			;60fc   ; los huecos x 2
	add hl,de			;60fd   ; lo que sube empieza ahi
	ld a,020h		;60fe   ; 32 pares...
	sub b			;6100
	sub c			;6101   ; ...menos los huecos
	ret c			;6102   ; no
	jr z,sprites_tabla_cierra_va		;6103   ; nada que subir
	add a,a			;6105   ; x 2 bytes
	push bc			;6106
	ld b,000h		;6107
	ld c,a			;6109
	ldir		;610a   ; sube
	pop bc			;610c
sprites_tabla_cierra_va:
	ex de,hl			;610d
	ld a,c			;610e   ; los huecos...
	sla a		;610f   ; ...x 2
sprites_tabla_cierra_uno:
	ld (hl),0ffh		;6111   ; al final: libres
	inc hl			;6113
	dec a			;6114
	jr nz,sprites_tabla_cierra_uno		;6115
	and a			;6117   ; NC: hecho
	ret			;6118

; ----------------------------------------------------------------------
; DATOS sin_uso_6119: 7 bytes que nadie lee
;   0x6119..0x6120  (7 bytes)
DATA_sin_uso_6119:
	defb 023h,023h,018h,01ah,011h,0ffh,0ffh	; 6119

; ======================================================================
; CODIGO 0x6120..0x64bb  (923 bytes)
; ======================================================================


sprite_busca:		; Busca el par D, E (bit 7 puesto) en la tabla de sprites (0xFBFE, 64 bytes): B = su posicion x 2, C = 1; si el byte siguiente es un dibujo (por debajo de 0xFF y de 0x20 o mas, NC), C = sus 3 bits de abajo; C si no esta
	set 7,e		;6120   ; marca de personaje
	ld hl,0fbfeh		;6122   ; la tabla de sprites
	ld bc,00040h		;6125   ; 64 bytes
sprite_busca_uno:
	ld a,d			;6128
	cpir		;6129   ; busca D
	scf			;612b
	ret po			;612c   ; no esta
	ld a,e			;612d
	cp (hl)			;612e   ; y E detras?
	jr nz,sprite_busca_uno		;612f
	inc hl			;6131   ; detras, el dibujo
	ld a,03fh		;6132   ; 63 - lo que queda...
	sub c			;6134
	add a,a			;6135   ; ...x 2: la posicion
	ld b,a			;6136
	ld c,001h		;6137   ; un sprite
	ld a,(hl)			;6139   ; el dibujo
	dec hl			;613a
	dec hl			;613b
	cp 0ffh		;613c   ; 0xFF: libre
	ret nc			;613e
	cp 020h		;613f   ; por debajo de 0x20: NC
	ccf			;6141
	ret nc			;6142
	and 007h		;6143   ; los 3 bits de abajo
	ld c,a			;6145
	ret			;6146
sprite_libre:		; Busca el primer hueco (0xFF) de la tabla de sprites: B = posicion x 2; A = cuantos quedan / 2; C si no hay
	ld a,0ffh		;6147
sprite_busca_a:
	ld hl,0fbfeh		;6149
	ld bc,00040h		;614c
sprite_busca_a_va:
	ld b,000h		;614f   ; A, en la tabla
	cpir		;6151   ; busca
	scf			;6153   ; no esta: C
	ret po			;6154
	dec hl			;6155   ; su posicion
	ld a,03fh		;6156
	sub c			;6158
	add a,a			;6159
	ld b,a			;615a
	ld a,c			;615b   ; lo que queda...
	inc a			;615c
	srl a		;615d   ; .../ 2
	and a			;615f
	ret			;6160
personaje_sprites:		; Los sprites del personaje 0xFC46 a la tabla de atributos: busca cada uno en la tabla de sprites (0x6120), los colores de 0x62C1 y sus dibujos (de 4 en 4: 0xCC los que no se usan, segun la forma 0xFC43) por 0xFAC2
	ld a,(0fc46h)		;6161   ; el personaje
	inc a			;6164   ; ninguno?
	scf			;6165
	ret z			;6166
	dec a			;6167   ; el dibujo
	push af			;6168
	ld de,(0fc40h)		;6169   ; los sprites libres
	ld e,a			;616d   ; el personaje en D, el dibujo en E
	set 7,e		;616e   ; marca
personaje_sprites_busca:
	call sprite_busca		;6170   ; en la tabla?
	jr nc,personaje_sprites_pon		;6173
	call dibujo_sitio		;6175   ; se le hace sitio
	jr nc,personaje_sprites_busca		;6178
	pop af			;617a   ; no cabe
	scf			;617b
	ret			;617c
personaje_sprites_pon:
	pop af			;617d
	push bc			;617e
	call atributos_grupo		;617f   ; los 4 sprites del grupo
	ld de,0fac2h		;6182   ; a 0xFAC2
	ld bc,00010h		;6185
	call ldirmv		;6188   ; LDIRMV
	ex (sp),hl			;618b
	push bc			;618c
	push de			;618d
	ex de,hl			;618e
	inc hl			;618f   ; el byte 2: el dibujo
	inc hl			;6190
	ld a,(0fc43h)		;6191   ; la forma
	cp 003h		;6194   ; 3?
	jr nz,personaje_sprites_forma		;6196
	set 2,a		;6198   ; la forma 3: los cuatro
personaje_sprites_forma:
	scf			;619a   ; los bits de los sprites que se usan
	adc a,a			;619b
	ld e,a			;619c
	ld a,d			;619d   ; el primer dibujo
	ld bc,00404h		;619e   ; 4 sprites, 4 dibujos cada uno
personaje_sprites_uno:
	push bc			;61a1
	ld (hl),a			;61a2   ; el dibujo
	rr e		;61a3   ; se usa?
	jr c,personaje_sprites_dib		;61a5
	ld (hl),0cch		;61a7   ; sin usar: 0xCC
	jr personaje_sprites_sig		;61a9
personaje_sprites_dib:
	add a,c			;61ab
personaje_sprites_sig:
	ld b,000h		;61ac
	add hl,bc			;61ae   ; el siguiente sprite
	pop bc			;61af
	djnz personaje_sprites_uno		;61b0
	pop hl			;61b2   ; a la VRAM
	pop bc			;61b3
	pop de			;61b4
	call ldirvm_mas		;61b5   ; LDIRVM
	xor a			;61b8   ; NC: hecho
	ret			;61b9
personaje_muestra:		; El personaje A (0xFC46) en la ventana de muestra: sus cuatro sprites (de los 16 de la tabla 0x3B80 + A x 16) con los dibujos 0xD0, 0xD4, 0xD8 y 0xDC
	ld (0fc46h),a		;61ba   ; el dibujo en el editor
	call atributos_grupo		;61bd   ; los 4 sprites del grupo
	ld de,0fac2h		;61c0   ; a 0xFAC2
	ld bc,00010h		;61c3
	call ldirmv		;61c6   ; LDIRMV
	ex de,hl			;61c9
	push hl			;61ca
	inc hl			;61cb   ; el byte 2
	inc hl			;61cc
	push de			;61cd
	push bc			;61ce
	ld de,00004h		;61cf   ; de 4 en 4
	ld b,e			;61d2   ; cuatro
	ld a,0d0h		;61d3   ; el dibujo 0xD0
personaje_muestra_uno:
	ld (hl),a			;61d5   ; el dibujo
	add hl,de			;61d6
	add a,e			;61d7   ; el siguiente: + 4
	djnz personaje_muestra_uno		;61d8
	pop bc			;61da
	pop de			;61db
	pop hl			;61dc
	jp ldirvm_mas		;61dd   ; LDIRVM
atributos_grupo:		; HL = la tabla de atributos 0x3B80 + (A & 7) x 16 (cuatro sprites)
	and 007h		;61e0   ; el grupo...
	add a,a			;61e2   ; ...x 16
	add a,a			;61e3
	add a,a			;61e4
	add a,a			;61e5
	ld hl,03b80h		;61e6   ; desde 0x3B80
	push af			;61e9
	add a,l			;61ea
	jr nc,atributos_grupo_va		;61eb
	inc h			;61ed
atributos_grupo_va:
	ld l,a			;61ee
	pop af			;61ef
	ret			;61f0
muestra_color:		; HL = el byte 3 (el color) del primer sprite de la muestra (0xFC46)
	ld a,(0fc46h)		;61f1   ; el dibujo en el editor
atributos_color:
	call atributos_grupo		;61f4
	inc hl			;61f7   ; el byte 3: el color
	inc hl			;61f8
	inc hl			;61f9
	ret			;61fa
cuadrante:		; El color del sprite de la muestra (0xFC46) en el cuarto del cursor (0xFBC3: X y Y de 16 o mas, + 4 / + 8) y DE = su dibujo en 0x1E80 (+ 0x20 a la derecha, + 0x40 abajo)
	push af			;61fb
	push bc			;61fc
	ld a,(0fc46h)		;61fd   ; el dibujo en el editor
	call muestra_color		;6200   ; el color del primer sprite
	ld bc,00004h		;6203   ; de 4 en 4
	ld d,b			;6206   ; DE = 0
	ld e,b			;6207
	ld a,(0fbc3h)		;6208   ; la X del cursor
	and 010h		;620b   ; la mitad derecha?
	jr z,cuadrante_y		;620d
	ld e,020h		;620f   ; 32 bytes mas
	add hl,bc			;6211   ; el sprite de la derecha
cuadrante_y:
	ld a,(0fbc4h)		;6212   ; la Y
	and 010h		;6215   ; la mitad de abajo?
	jr z,cuadrante_fin		;6217
	add hl,bc			;6219   ; los de abajo
	add hl,bc			;621a
	ld c,040h		;621b   ; 64 bytes mas
	ex de,hl			;621d   ; el dibujo...
	add hl,bc			;621e
	ex de,hl			;621f
cuadrante_fin:
	push hl			;6220
	ld hl,01e80h		;6221   ; los dibujos del editor
	add hl,de			;6224   ; ...desde 0x1E80
	ex de,hl			;6225
	pop hl			;6226
	pop bc			;6227
	pop af			;6228
	ret			;6229
dibujo_al_editor:		; El dibujo E del personaje D (de la tabla de sprites, 0x6120): sus dibujos de sprite (desde 0x1800 + posicion x 8) a los cuatro del editor (0x1E80), segun la forma (0xFC43: 0 uno de 16 x 16, 1 dos, 2 dos de alto, 3 cuatro); los demas a 0
	push de			;622a
	call sprites_dibujos_cero		;622b   ; el editor a 0
	pop de			;622e
	push de			;622f
	set 7,e		;6230
	call sprite_busca		;6232   ; en la tabla
	pop de			;6235
	ret c			;6236   ; no esta
	push de			;6237
	push bc			;6238
	ld l,b			;6239   ; la posicion
	ld h,000h		;623a
	add hl,hl			;623c
	add hl,hl			;623d
	add hl,hl			;623e
	ld bc,01800h		;623f   ; desde 0x1800
	add hl,bc			;6242
	pop bc			;6243
	call por32		;6244   ; x 32
	ld de,0fac2h		;6247   ; a 0xFAC2
	push de			;624a
	call ldirmv_mas		;624b   ; LDIRMV
	pop hl			;624e
	ld de,01e80h		;624f   ; al editor (0x1E80)
	ld a,(0fc43h)		;6252   ; la forma
	cp 003h		;6255   ; cuatro sprites?
	jr z,$+15		;6257   ; cuatro: todos
	ld c,020h		;6259   ; 32 bytes
	sub 001h		;625b   ; uno solo?
	jr c,$+9		;625d
	jr nz,dibujo_al_editor_va		;625f   ; dos de alto?
	ld c,040h		;6261   ; dos de ancho: 64
	jr $+3		;6263
dibujo_al_editor_va:
	ld a,0afh		;6265
	push af			;6267
	call ldirvm_mas		;6268   ; LDIRVM
	pop af			;626b
	jr z,dibujo_al_editor_fin		;626c
	ex de,hl			;626e   ; el siguiente hueco
	add hl,bc			;626f
	add hl,bc			;6270
	ex de,hl			;6271
	jr $-12		;6272   ; otra vez
dibujo_al_editor_fin:
	pop de			;6274
	ret			;6275
dibujo_del_editor:		; Lo dibujado en el editor (0x1E80, 0x80 bytes) vuelve a los dibujos de sprite del dibujo E del personaje D; si no tiene sitio, se le hace (0x62C1); 0xFC45 = 0 (guardado)
	push de			;6276
	set 7,e		;6277
	call sprite_busca		;6279   ; en la tabla
	jr nc,dibujo_del_editor_va		;627c
	call dibujo_sitio		;627e   ; se le hace sitio
	pop de			;6281   ; no hay sitio
	ret c			;6282
	jr dibujo_del_editor		;6283   ; otra vez
dibujo_del_editor_va:
	ld hl,01e80h		;6285   ; el editor
	ld de,0fac2h		;6288   ; a 0xFAC2
	push de			;628b
	push bc			;628c
	ld bc,00080h		;628d
	call ldirmv_mas		;6290   ; LDIRMV
	pop bc			;6293
	ld h,000h		;6294
	ld l,b			;6296   ; la posicion...
	add hl,hl			;6297   ; ...x 8
	add hl,hl			;6298
	add hl,hl			;6299
	ld de,01800h		;629a   ; desde 0x1800
	add hl,de			;629d
	call por32		;629e   ; x 32
	ex de,hl			;62a1
	pop hl			;62a2
	xor a			;62a3   ; guardado
	ld (0fc45h),a		;62a4   ; guardado
	ld a,(0fc43h)		;62a7   ; la forma
	cp 002h		;62aa   ; dos de alto?
	jr nz,$+5		;62ac
	ld c,020h		;62ae   ; 32 bytes
	or 0afh		;62b0   ; NZ; desde 0x62B1 "xor a": Z
	push af			;62b2
	call ldirvm_mas		;62b3   ; LDIRVM
	pop af			;62b6
	jr z,dibujo_del_editor_fin		;62b7   ; hecho
	add hl,bc			;62b9   ; el siguiente hueco
	ex de,hl			;62ba
	add hl,bc			;62bb
	ex de,hl			;62bc
	jr $-12		;62bd   ; otra vez
dibujo_del_editor_fin:
	pop de			;62bf
	ret			;62c0
dibujo_sitio:		; Hace sitio para un dibujo nuevo del personaje D: con un solo personaje (0xFC44 = 1), abre huecos en la tabla y mueve atributos y dibujos; busca un hueco libre (0x6147) del tamano de la forma, apunta D, E y los numeros de sprite (0xFA o 0xFC con la forma 3), y los numeros de sprite de los cuatro de 0xFDEF; 0xFC40 (sprites libres) baja; C si no cabe
	ld a,(0fc44h)		;62c1   ; cuantos personajes
	dec a			;62c4   ; uno solo?
	jr nz,dibujo_sitio_busca		;62c5
	push de			;62c7
	ld a,(0fc43h)		;62c8   ; la forma...
	inc a			;62cb   ; ...+ 1 (3 -> 2)
	cp 003h		;62cc   ; la forma 3...
	jr nz,dibujo_sitio_abre		;62ce
	dec a			;62d0   ; ...ocupa 2
dibujo_sitio_abre:
	ld b,000h		;62d1
	ld c,a			;62d3   ; cuantos huecos
	call sprites_tabla_abre		;62d4   ; los huecos
	pop de			;62d7
	ret c			;62d8   ; no caben
	push de			;62d9
	call atributos_mueve		;62da   ; los atributos
	call sprites_dibujos_baja		;62dd   ; los dibujos
	pop de			;62e0
dibujo_sitio_busca:
	push de			;62e1
	set 7,e		;62e2   ; marca de personaje
	call sprite_libre		;62e4   ; un hueco
	jr c,dibujo_sitio_sale		;62e7   ; no hay
	inc a			;62e9   ; los libres...
	ld b,a			;62ea
	ld a,(0fc43h)		;62eb   ; la forma
	inc a			;62ee   ; la forma + 1...
	cp 003h		;62ef
	jr nz,dibujo_sitio_cabe		;62f1
	dec a			;62f3   ; ...(la 3, 2)
dibujo_sitio_cabe:
	cp b			;62f4   ; caben?
	ccf			;62f5   ; C si no caben
	jr c,dibujo_sitio_sale		;62f6
	ld (hl),d			;62f8   ; el personaje...
	inc hl			;62f9   ; el siguiente par
	ld (hl),e			;62fa   ; ...y el dibujo
	inc hl			;62fb
	ld b,000h		;62fc   ; ninguno mas
	ld a,(0fc43h)		;62fe   ; la forma
	and a			;6301   ; la forma 0?
	jr z,dibujo_sitio_numeros		;6302
	inc b			;6304   ; uno mas
	ld c,0fah		;6305   ; la marca 0xFA
	cp 003h		;6307
	jr nz,dibujo_sitio_marca		;6309
	ld bc,003fch		;630b   ; tres mas, 0xFC
dibujo_sitio_marca:
	push bc			;630e
	or 0f0h		;630f   ; con 0xF0
dibujo_sitio_marca_uno:
	ld (hl),c			;6311   ; la marca...
	inc hl			;6312
	ld (hl),a			;6313   ; ...y la forma
	inc hl			;6314
	djnz dibujo_sitio_marca_uno		;6315
	pop bc			;6317
dibujo_sitio_numeros:
	pop de			;6318
	push de			;6319
	push bc			;631a
	ld a,e			;631b   ; el dibujo
	and 007h		;631c   ; de 0 a 7
	ld (0fc46h),a		;631e   ; el dibujo de la muestra
	xor a			;6321   ; 0xFC48 a 0
	ld (0fc48h),a		;6322
	call sprite_busca		;6325   ; su sitio en la tabla
	ld a,e			;6328   ; el dibujo...
	add a,a			;6329   ; ...x 4
	add a,a			;632a
	ld hl,0fdefh		;632b   ; los numeros de los sprites
	call hl_mas_a		;632e
	ld a,(0fc43h)		;6331   ; la forma
	cp 003h		;6334   ; 3?
	jr nz,dibujo_sitio_forma		;6336
	set 2,a		;6338
dibujo_sitio_forma:
	scf			;633a
	adc a,a			;633b
	ld e,a			;633c
	ld a,b			;633d   ; el primer sprite
dibujo_sitio_numero:
	rr e		;633e   ; se usa?
	jr nc,dibujo_sitio_sig		;6340
	ld (hl),a			;6342   ; su numero
	jr z,dibujo_sitio_fin		;6343
	add a,004h		;6345   ; el siguiente: + 4
dibujo_sitio_sig:
	inc hl			;6347
	jr nz,dibujo_sitio_numero		;6348   ; los cuatro
dibujo_sitio_fin:
	pop bc			;634a
	inc b			;634b   ; los que usa
	ld hl,0fc40h		;634c   ; los sprites libres
	ld a,(hl)			;634f   ; los libres...
	sub b			;6350   ; menos los usados
	ld (hl),a			;6351   ; ...menos
	and a			;6352   ; NC
dibujo_sitio_sale:
	pop de			;6353
	ret			;6354
dibujo_quita:		; Quita el dibujo E del personaje D (si existe y no es el unico): cierra sus huecos en la tabla de sprites, devuelve los sprites (0xFC40) y mueve atributos (0x6083) y dibujos (0x5FF5); C si no se puede
	push de			;6355
	ld a,d			;6356   ; el personaje
	push af			;6357
	call sprite_busca_a		;6358   ; su primer dibujo
	jr c,dibujo_quita_no		;635b   ; no tiene
	pop af			;635d
	inc hl			;635e   ; despues del primero
	call sprite_busca_a_va		;635f   ; otro dibujo suyo?
	push af			;6362
	jr nc,dibujo_quita_si		;6363   ; si: se puede quitar
dibujo_quita_no:
	pop af			;6365
dibujo_quita_c:
	pop de			;6366   ; no: el unico
	scf			;6367
	ret			;6368
dibujo_quita_si:
	pop af			;6369
	pop de			;636a
dibujo_quita_va:
	push de			;636b
	set 7,e		;636c   ; marca
	call sprite_busca		;636e   ; en la tabla
	jr c,dibujo_quita_c		;6371
	srl b		;6373   ; la posicion / 4
	srl b		;6375
	call sprites_tabla_cierra		;6377   ; cierra los huecos
	jr c,dibujo_quita_c		;637a   ; no
	ld hl,0fc40h		;637c   ; los sprites libres...
	ld a,(hl)			;637f   ; los libres...
	add a,c			;6380   ; ...mas los devueltos
	ld (hl),a			;6381   ; ...mas los suyos
	call atributos_mueve_z		;6382   ; los atributos
	call sprites_dibujos_mueve		;6385   ; los dibujos
	pop de			;6388
	xor a			;6389   ; hecho
	ret			;638a
personaje_numeros:		; Los numeros de dibujo de los 32 sprites (0xFDEF, 0xCC sin usar) de los 8 dibujos del personaje 0xFA11, segun la forma; a la tabla de atributos (byte 2 de cada uno, 0x3B82), sin interrupciones
	di			;638b   ; sin interrupciones
	ld de,(0fa11h)		;638c   ; el personaje
	dec d			;6390   ; el personaje desde 0
	ld e,080h		;6391   ; marca
	ld hl,0fdefh		;6393   ; 32 sprites
	push hl			;6396   ; los numeros de los sprites
	ld b,020h		;6397   ; 32
	ld a,0cch		;6399   ; sin usar
	call llena_b		;639b   ; a 0xCC
	pop hl			;639e
	ld b,008h		;639f   ; 8 dibujos
personaje_numeros_uno:
	push bc			;63a1
	push hl			;63a2
	call sprite_busca		;63a3   ; el dibujo E del personaje D
	ld a,b			;63a6   ; su sitio
	pop hl			;63a7
	push hl			;63a8
	ld b,004h		;63a9   ; de 4 en 4
	jr nc,personaje_numeros_forma		;63ab   ; esta
	ld a,0cch		;63ad   ; no: 0xCC
	ld bc,00004h		;63af   ; uno, 4 veces
personaje_numeros_forma:
	push af			;63b2
	ld a,(0fc43h)		;63b3   ; la forma
	cp 002h		;63b6   ; dos de alto?
	ex (sp),hl			;63b8
	ld a,h			;63b9
	pop hl			;63ba
personaje_numeros_pon:
	ld (hl),a			;63bb   ; el numero
	inc hl			;63bc
	jr nz,personaje_numeros_sig		;63bd   ; salvo con dos de alto...
	inc hl			;63bf   ; ...uno se salta
personaje_numeros_sig:
	add a,b			;63c0   ; el siguiente
	dec c			;63c1
	jr nz,personaje_numeros_pon		;63c2
	pop hl			;63c4
	ld bc,00004h		;63c5   ; el siguiente dibujo
	add hl,bc			;63c8
	inc e			;63c9   ; su numero
	pop bc			;63ca
	djnz personaje_numeros_uno		;63cb   ; los 8
	ld hl,03b82h		;63cd   ; la tabla de atributos, byte 2
	ld de,0fdefh		;63d0   ; los numeros
	ld b,020h		;63d3   ; 32 sprites
personaje_numeros_vram:
	ld a,(de)			;63d5   ; el numero
	call 0004dh		;63d6   ; WRTVRM
	inc hl			;63d9   ; el siguiente sprite (4 bytes)
	inc hl			;63da
	inc hl			;63db
	inc hl			;63dc
	inc de			;63dd
	djnz personaje_numeros_vram		;63de
	ei			;63e0   ; con interrupciones
	ret			;63e1
personaje_cuadro:		; El cuadro de los 8 dibujos del personaje en la pantalla de sprites: arma en 0xFAC2 los atributos de 0x64BB (posiciones), con los colores de la tabla de atributos (0x3B00 -> 0xFB42) de cada dibujo del personaje; a la VRAM (0x3B80); despues el dibujo mostrado (0x622A) y la muestra
	call fac2_cero		;63e2   ; 0xFAC2 a 0
	ld hl,064bbh		;63e5   ; las posiciones
	ld de,0fac2h		;63e8   ; a 0xFAC2
	ld bc,010ffh		;63eb   ; 16 pares
	ld a,0cch		;63ee   ; sin dibujo
	push de			;63f0
personaje_cuadro_pos:
	ldi		;63f1   ; la Y
	dec hl			;63f3
	inc de			;63f4
	ld (de),a			;63f5   ; sin dibujo
	inc de			;63f6
	inc de			;63f7
	ldi		;63f8   ; la otra Y
	inc de			;63fa
	ld (de),a			;63fb   ; sin dibujo
	inc de			;63fc
	inc de			;63fd
	djnz personaje_cuadro_pos		;63fe
	pop de			;6400
	inc de			;6401   ; el byte 1: la X
	ld a,00fh		;6402   ; color 15
	ld c,004h		;6404   ; cuatro filas
personaje_cuadro_fila:
	push hl			;6406
	ld b,008h		;6407   ; de 8
personaje_cuadro_uno:
	ldi		;6409   ; la X
	inc bc			;640b
	inc de			;640c
	ld (de),a			;640d   ; el color
	inc de			;640e
	inc de			;640f
	djnz personaje_cuadro_uno		;6410   ; el siguiente
	pop hl			;6412
	dec c			;6413   ; la fila siguiente
	jr nz,personaje_cuadro_fila		;6414
	ld hl,03b00h		;6416   ; la tabla de atributos...
	ld de,0fb42h		;6419   ; ...a 0xFB42
	ld bc,00080h		;641c   ; 0x80 bytes
	call ldirmv_mas		;641f   ; LDIRMV
	ld a,0ffh		;6422   ; el primer dibujo: ninguno
	push af			;6424
	ld de,(0fc40h)		;6425   ; el personaje
	ld e,000h		;6429   ; desde el dibujo 0
personaje_cuadro_dibujo:
	call sprite_busca		;642b   ; en la tabla
	push af			;642e
	ld a,07fh		;642f   ; sin la marca
	and e			;6431
	ld e,a			;6432
	pop af			;6433
	jr c,personaje_cuadro_sig		;6434   ; no tiene
	push de			;6436
	ld hl,0fb44h		;6437   ; los colores
	ld c,b			;643a   ; su posicion
	ld b,000h		;643b
	add hl,bc			;643d
	push hl			;643e
	ld h,000h		;643f   ; el dibujo...
	ld l,e			;6441
	add hl,hl			;6442   ; ...x 16
	add hl,hl			;6443
	add hl,hl			;6444
	add hl,hl			;6445
	ld de,0fac4h		;6446   ; su sitio en el cuadro
	add hl,de			;6449
	ex de,hl			;644a
	pop hl			;644b
	ld a,(0fc43h)		;644c   ; la forma
	ldi		;644f   ; el color...
	ldi		;6451   ; ...del primer sprite
	and a			;6453   ; la forma 0: uno
	jr z,personaje_cuadro_menor		;6454
personaje_cuadro_mas:
	ld bc,00002h		;6456
	add hl,bc			;6459
	ex de,hl			;645a
	add hl,bc			;645b
	cp 002h		;645c   ; dos de alto?
	jr nz,personaje_cuadro_copia		;645e
	add hl,bc			;6460   ; la otra fila
	add hl,bc			;6461
personaje_cuadro_copia:
	ex de,hl			;6462
	ldi		;6463   ; el color...
	ldi		;6465   ; ...del siguiente
	cp 003h		;6467   ; la forma 3?
	jr c,personaje_cuadro_menor		;6469
	inc a			;646b   ; los cuatro
	cp 006h		;646c
	jr nz,personaje_cuadro_mas		;646e
personaje_cuadro_menor:
	pop de			;6470
	pop bc			;6471
	ld a,e			;6472   ; el primero que hay
	cp b			;6473
	jr nc,personaje_cuadro_guarda		;6474
	ld b,e			;6476   ; el menor
personaje_cuadro_guarda:
	push bc			;6477
personaje_cuadro_sig:
	inc e			;6478   ; el siguiente dibujo
	ld a,e			;6479
	cp 002h		;647a   ; el 2?
	jr nz,personaje_cuadro_ocho		;647c
	ld a,(0fc42h)		;647e   ; con animacion?
	and a			;6481
	jr z,personaje_cuadro_vram		;6482   ; no: solo los dos primeros
	ld a,e			;6484
personaje_cuadro_ocho:
	cp 008h		;6485   ; los 8?
	jr nz,personaje_cuadro_dibujo		;6487
personaje_cuadro_vram:
	push de			;6489
	ld hl,0fac4h		;648a   ; los colores...
	ld de,0fdefh		;648d   ; ...a 0xFDEF
	ld b,020h		;6490   ; 32
personaje_cuadro_copia2:
	ldi		;6492
	inc bc			;6494
	inc hl			;6495   ; cada 4
	inc hl			;6496
	inc hl			;6497
	djnz personaje_cuadro_copia2		;6498
	ld hl,0fac2h		;649a   ; a la VRAM
	ld de,03b80h		;649d   ; la tabla de los sprites de abajo
	ld bc,00080h		;64a0   ; 0x80 bytes
	call ldirvm_mas		;64a3   ; LDIRVM
	pop de			;64a6
	pop af			;64a7
	inc a			;64a8   ; ninguno?
	jr z,personaje_cuadro_muestra		;64a9
	dec a			;64ab
personaje_cuadro_muestra:
	ld e,a			;64ac   ; el primero
	call dibujo_al_editor		;64ad   ; al editor
	ld a,e			;64b0
	call personaje_muestra		;64b1   ; la muestra
	xor a			;64b4   ; el dibujo mostrado: 0
	ld (0fc49h),a		;64b5   ; el dibujo mostrado: 0
	jp cursores_cero		;64b8   ; los cursores a 0

; ----------------------------------------------------------------------
; DATOS cuadro_posiciones: Las Y y X de los dibujos del cuadro del personaje
;   (pares)
;   0x64bb..0x64d3  (24 bytes)
DATA_cuadro_posiciones:
	defb 020h,030h,020h,030h,048h,058h,048h,058h,070h,080h,070h,080h,098h,0a8h,098h,0a8h	; 64bb   0 0HXHXp.p.....
	defb 0b0h,0c0h,0b0h,0c0h,0d8h,0e8h,0d8h,0e8h	; 64cb  ........

; ======================================================================
; CODIGO 0x64d3..0x688f  (956 bytes)
; ======================================================================


personaje_guarda:		; Lo dibujado se guarda: los sprites (0x6161), el dibujo del editor (0x6276) y los colores de la tabla de atributos de la muestra a los sprites del personaje (0x3B03 + numero)
	call personaje_sprites		;64d3
	ld de,(0fc40h)		;64d6   ; los sprites libres...
	ld a,(0fc46h)		;64da   ; ...el dibujo
	ld e,a			;64dd
	call dibujo_del_editor		;64de   ; lo dibujado
	ld hl,03b80h		;64e1   ; la muestra...
	ld de,0fac2h		;64e4   ; a 0xFAC2
	ld bc,00080h		;64e7   ; 0x80 bytes
	call ldirmv_mas		;64ea   ; ...a 0xFAC2
	ld bc,02000h		;64ed   ; 32 sprites
	ld de,0fac4h		;64f0   ; los numeros de dibujo
personaje_guarda_color:
	ld a,(de)			;64f3   ; el numero
	inc de			;64f4
	cp 080h		;64f5   ; sin usar?
	jr nc,personaje_guarda_sig		;64f7
	push bc			;64f9
	ld hl,03b03h		;64fa   ; el color del sprite
	ld c,a			;64fd   ; su sitio
	ld b,000h		;64fe
	add hl,bc			;6500
	ld a,(de)			;6501   ; su color
	and 00fh		;6502   ; 4 bits
	call 0004dh		;6504   ; WRTVRM
	pop bc			;6507
personaje_guarda_sig:
	inc de			;6508   ; el siguiente (4 bytes)
	inc de			;6509
	inc de			;650a
	djnz personaje_guarda_color		;650b
	ret			;650d
muestra_pon:		; Sin dibujo en el editor (0xFC46 = 0xFF): la muestra con el dibujo mostrado (0xFC49)
	push af			;650e
	ld a,(0fc46h)		;650f   ; el dibujo
	inc a			;6512   ; ninguno?
	jr nz,muestra_pon_fin		;6513
	push bc			;6515
	push de			;6516
	push hl			;6517
	ld a,(0fc49h)		;6518   ; el mostrado
	call personaje_muestra		;651b
	pop hl			;651e
	pop de			;651f
	pop bc			;6520
muestra_pon_fin:
	pop af			;6521
	ret			;6522
dibujo_cambia:		; Cambia el dibujo del personaje que se edita (A: 0 ninguno, bit 0 nada; los bits 1-2 la direccion): guarda el de ahora si ha cambiado (0xFC45) y pasa al siguiente o al anterior en el cuadro de 0xFC4A
	push af			;6523
	ld a,(0fc46h)		;6524   ; el dibujo
	inc a			;6527   ; ninguno?
	call nz,personaje_sprites		;6528   ; los sprites
	pop af			;652b
	and a			;652c   ; ninguna direccion?
	jr z,dibujo_elige		;652d
	rrca			;652f   ; bit 0: nada
	ret c			;6530
	push af			;6531
	ld a,(0fc49h)		;6532   ; el mostrado...
	ld (0fc4ah),a		;6535   ; ...pasa a ser el de antes
	ld de,(0fc40h)		;6538   ; los sprites libres
	ld e,a			;653c   ; el dibujo
	ld a,(0fc45h)		;653d   ; cambiado?
	and a			;6540
	call nz,dibujo_del_editor		;6541   ; se guarda
	xor a			;6544   ; ya no
	ld (0fc45h),a		;6545   ; cambiado?
	pop af			;6548
	ld hl,(0fc4ah)		;6549   ; la columna y la fila del cuadro
	rrca			;654c   ; hacia la derecha?
	jr nc,dibujo_cambia_v		;654d
	set 0,l		;654f   ; la columna 1
	rrca			;6551   ; a la izquierda?
	jr nc,dibujo_cambia_pon		;6552
	res 0,l		;6554   ; la columna 0
	jr dibujo_cambia_pon		;6556
dibujo_cambia_v:
	ld h,a			;6558   ; hacia arriba o abajo
	ld a,(0fc42h)		;6559   ; con animacion?
	and a			;655c
	jr z,dibujo_elige_fin		;655d   ; no: solo 0 y 1
	rr h		;655f   ; abajo?
	jr c,dibujo_cambia_abajo		;6561   ; si
	ld a,001h		;6563   ; la fila de arriba...
	sub l			;6565   ; ...si no es la primera
	jr nc,dibujo_elige_fin		;6566
	ld a,0feh		;6568   ; dos menos
	jr dibujo_cambia_suma		;656a
dibujo_cambia_abajo:
	ld a,l			;656c   ; la fila
	cp 006h		;656d   ; la ultima?
	jr nc,dibujo_elige_fin		;656f
	ld a,002h		;6571   ; dos mas
dibujo_cambia_suma:
	add a,l			;6573
	ld l,a			;6574   ; el dibujo nuevo
dibujo_cambia_pon:
	ld a,l			;6575   ; el dibujo nuevo
	ld (0fc49h),a		;6576   ; el dibujo mostrado
	ld a,(0fc4ah)		;6579   ; el de antes
	cp l			;657c   ; el mismo?
	jr z,dibujo_elige_fin		;657d   ; el mismo: nada
dibujo_elige:		; Elige el dibujo 0xFC49: si existe, al editor (0x622A) y a la muestra; si no, 0xFC46 = 0xFF y, si no quedan sprites para el (0xFC40), 0xFC47 = 0xFF ("no hay memoria")
	xor a			;657f   ; hay sitio
	ld (0fc47h),a		;6580   ; sin sitio?
	ld (0fc48h),a		;6583   ; 0xFC48 a 0
	ld de,(0fc40h)		;6586   ; los sprites libres
	ld a,(0fc49h)		;658a   ; el dibujo mostrado
	ld e,a			;658d   ; el dibujo
	set 7,e		;658e   ; marca
	call sprite_busca		;6590   ; en la tabla?
	jr nc,dibujo_elige_esta		;6593   ; si
	ld a,0ffh		;6595   ; sin dibujo
	ld (0fc48h),a		;6597   ; sin dibujo
	ld (0fc46h),a		;659a   ; el dibujo en el editor
	ld a,(0fc43h)		;659d   ; la forma...
	inc a			;65a0   ; la forma + 1...
	cp 003h		;65a1
	jr nz,dibujo_elige_cabe		;65a3
	dec a			;65a5   ; ...(la 3, 2)
dibujo_elige_cabe:
	ld bc,(0fc40h)		;65a6   ; ...contra los libres
	inc c			;65aa   ; los libres + 1
	cp c			;65ab   ; caben?
	jr c,dibujo_elige_vacio		;65ac
	ld a,0ffh		;65ae   ; no cabe
	ld (0fc47h),a		;65b0   ; sin sitio?
	call sprites_dibujos_cero		;65b3   ; el editor a 0
dibujo_elige_fin:
	ld a,(0fbd0h)		;65b6   ; con rejilla?
	and a			;65b9   ; con rejilla?
	ret z			;65ba
	jp rejilla_dibujo		;65bb   ; la rejilla otra vez
dibujo_elige_esta:
	call dibujo_al_editor		;65be   ; sus dibujos al editor
	jr dibujo_elige_muestra		;65c1
dibujo_elige_vacio:
	call sprites_dibujos_cero		;65c3   ; el editor a 0
	ld a,(0fc46h)		;65c6   ; el dibujo en el editor
	inc a			;65c9   ; sin dibujo?
	jr z,dibujo_elige_fin		;65ca
dibujo_elige_muestra:
	ld a,(0fc49h)		;65cc   ; el dibujo mostrado
	call personaje_muestra		;65cf   ; la muestra
	jr dibujo_elige_fin		;65d2
memoria_mira:		; Sin sitio (0xFC47): las letras, el aviso 5 ("no hay memoria") y vuelve al menu (el codigo 0x0F al buffer); C
	push bc			;65d4
	ld b,a			;65d5
	ld a,(0fc47h)		;65d6   ; sin sitio?
	and a			;65d9   ; sin sitio?
	ld a,b			;65da
	pop bc			;65db
	ret z			;65dc   ; no: Z
	call letras_texto		;65dd   ; las letras
	call dibujos_menu		;65e0   ; las del menu
	xor a			;65e3   ; sin escritura
	ld (0fe13h),a		;65e4   ; con escritura
	ld b,005h		;65e7   ; "no hay memoria"
	call aviso		;65e9   ; "no hay memoria"
	halt			;65ec   ; un cuadro
	call buffer_inicio		;65ed   ; el buffer vacio
	ld a,00fh		;65f0   ; volver
	call buffer_pon		;65f2   ; al buffer
	scf			;65f5   ; C: no se dibuja
	ret			;65f6
punto_pon:		; Pinta (o borra, con el color 0) el punto del cursor en el dibujo del editor: el byte del dibujo (0x61FB) con el bit del punto puesto ("or c") o quitado ("and c"), por una rutina de dos bytes escrita en 0xFAC2; con color, tambien el color del sprite; se guarda en el personaje y el cursor un paso
	call memoria_mira		;65f7   ; hay sitio?
	ret c			;65fa   ; sin sitio
	ld b,a			;65fb   ; la direccion
	call muestra_pon		;65fc   ; la muestra
	push bc			;65ff
	ld de,(0fbc3h)		;6600   ; el cursor
	ld hl,00000h		;6604   ; desde 0
	bit 3,e		;6607   ; la mitad derecha?
	jr z,punto_pon_x		;6609   ; la izquierda
	ld l,010h		;660b   ; 16 bytes mas
punto_pon_x:
	ld a,d			;660d   ; la fila...
	and 00fh		;660e   ; ...dentro de los 16...
	add a,l			;6610   ; ...+ 16 a la derecha
	ld l,a			;6611
	push de			;6612
	push hl			;6613
	call cuadrante		;6614   ; el sprite y su dibujo
	pop hl			;6617   ; el byte del dibujo
	add hl,de			;6618
	pop de			;6619
	ld a,e			;661a   ; la columna del punto
	and 007h		;661b   ; la columna dentro del byte
	push hl			;661d
	ld b,a			;661e
	inc b			;661f   ; + 1
	ld a,001h		;6620   ; su bit
punto_pon_bit:
	rrca			;6622   ; el bit: 0x80 >> columna
	djnz punto_pon_bit		;6623
	ld c,a			;6625   ; la mascara
	call color_borde		;6626   ; el color
	jr z,punto_pon_borra		;6629   ; 0: borra
	ex af,af'			;662b   ; el color a la reserva
	ld hl,0c9b1h		;662c   ; "or c" y "ret"
	jr punto_pon_va		;662f   ; a dibujar
punto_pon_borra:
	ex af,af'			;6631
	ld a,c			;6632   ; la mascara...
	cpl			;6633   ; el bit a 0...
	ld c,a			;6634   ; ...dada la vuelta
	ld hl,0c9a1h		;6635   ; "and c" y "ret"
punto_pon_va:
	ex (sp),hl			;6638   ; la direccion del byte
	call 0004ah		;6639   ; RDVRM: el byte del dibujo
	ex (sp),hl			;663c   ; la rutina
	ld (0fac2h),hl		;663d   ; la rutina en 0xFAC2
	call 0fac2h		;6640   ; hecha
	pop hl			;6643   ; el byte
	call 0004dh		;6644   ; WRTVRM
	ex af,af'			;6647   ; el color
	jr z,punto_pon_guarda		;6648   ; sin color: no
	call cuadrante		;664a   ; el color del sprite
	call 0004dh		;664d   ; WRTVRM
punto_pon_guarda:
	ld de,(0fc40h)		;6650   ; los sprites libres
	ld a,(0fc46h)		;6654   ; el dibujo en el editor
	ld e,a			;6657   ; el dibujo
	call dibujo_del_editor		;6658   ; al personaje
	ld a,0ffh		;665b   ; cambiado
	ld (0fc45h),a		;665d   ; cambiado
	pop af			;6660   ; la direccion
punto_cursor:		; El cursor un paso, sin salir del tamano del personaje (16 o 32 puntos segun la forma)
	call cursor_paso		;6661
	jr z,punto_cursor_quieto		;6664   ; no se mueve
	push af			;6666
	ld hl,01010h		;6667   ; 16 x 16
	ld a,(0fc43h)		;666a   ; la forma
	srl a		;666d   ; dos de ancho?
	jr nc,punto_cursor_alto		;666f   ; la forma de ancho
	ld l,020h		;6671   ; 32
punto_cursor_alto:
	and a			;6673   ; de alto?
	jr z,punto_cursor_mira		;6674
	ld h,020h		;6676   ; dos de alto: 32
punto_cursor_mira:
	pop af			;6678
	rrca			;6679   ; en horizontal?
	jr nc,punto_cursor_y		;667a
	rrca			;667c   ; hacia la derecha?
	jr nc,punto_cursor_y2		;667d
	push af			;667f
	ld a,(0fbc3h)		;6680   ; el cursor de dentro
	cp l			;6683   ; se sale?
	jr c,punto_cursor_x		;6684
	ld a,(0fbc7h)		;6686   ; el cursor de dentro de antes
	ld (0fbc3h),a		;6689   ; el cursor de dentro
	ld a,(0fbc9h)		;668c   ; el de casilla de antes
	ld (0fbc5h),a		;668f   ; el cursor de casilla
punto_cursor_x:
	pop af			;6692   ; no
	jr punto_cursor_y2		;6693
punto_cursor_y:
	rrca			;6695
punto_cursor_y2:
	rrca			;6696
	jr nc,punto_cursor_fin		;6697   ; en vertical?
	rrca			;6699
	jr nc,punto_cursor_fin		;669a   ; hacia abajo?
	ld a,(0fbc4h)		;669c   ; la Y del cursor de dentro
	cp h			;669f   ; se sale?
	jr c,punto_cursor_fin		;66a0
	ld a,(0fbc8h)		;66a2   ; vuelve...
	ld (0fbc4h),a		;66a5   ; la Y del cursor de dentro
	ld a,(0fbcah)		;66a8   ; ...donde estaba
	ld (0fbc6h),a		;66ab   ; la fila del cursor de casilla
	jr punto_cursor_fin		;66ae
punto_cursor_quieto:
	ld hl,0fc45h		;66b0   ; cambiado?
	ld a,(hl)			;66b3
	inc a			;66b4
	ret nz			;66b5   ; no: nada
	ld (hl),a			;66b6   ; a 0
punto_cursor_fin:
	ld a,(0fbd0h)		;66b7   ; la rejilla
	and a			;66ba   ; con rejilla?
	ret z			;66bb
	jp rejilla_dibujo		;66bc   ; la rejilla
dibujo_copia:		; COPIA (menu 0x22): el dibujo de 0xFC4B del personaje 0xFC41 se copia en el dibujo de ahora: sus dibujos al editor, sus 4 colores a los de la muestra; se guarda (0x6276, 0x6161, 0x638B, 0x64D3)
	call memoria_mira		;66bf
	ret c			;66c2   ; sin sitio
	ld de,(0fc4bh)		;66c3   ; el dibujo de origen
	ld a,(0fc41h)		;66c7   ; el personaje
	ld d,a			;66ca   ; el personaje
	call sprite_busca		;66cb   ; existe?
	ret c			;66ce   ; no existe
	call muestra_pon		;66cf   ; la muestra
	call dibujo_al_editor		;66d2   ; sus dibujos al editor
	ld a,e			;66d5
	and 007h		;66d6   ; el dibujo
	push de			;66d8
	call personaje_muestra		;66d9   ; a la muestra
	ld a,(0fc49h)		;66dc   ; el dibujo mostrado
	call atributos_color		;66df   ; sus colores
	push hl			;66e2
	ld a,(0fc4bh)		;66e3   ; el dibujo de origen
	call atributos_color		;66e6   ; los del de origen
	ld de,00004h		;66e9   ; 4 colores
	ld b,e			;66ec   ; 4
dibujo_copia_color:
	call 0004ah		;66ed   ; RDVRM
	add hl,de			;66f0   ; el siguiente
	ex (sp),hl			;66f1
	call 0004dh		;66f2   ; WRTVRM
	add hl,de			;66f5   ; el siguiente
	ex (sp),hl			;66f6
	djnz dibujo_copia_color		;66f7
	pop hl			;66f9
	pop de			;66fa
	ld a,(0fc49h)		;66fb   ; el dibujo mostrado
	push af			;66fe   ; el mostrado
	ld (0fc46h),a		;66ff   ; el dibujo en el editor
	ld e,a			;6702   ; el dibujo
	call dibujo_del_editor		;6703   ; guardado
	call personaje_sprites		;6706   ; los sprites
	pop af			;6709
	call personaje_muestra		;670a   ; la muestra
	call personaje_numeros		;670d   ; los numeros
	jp personaje_guarda		;6710   ; guardado
copia_cursor:		; Mueve el cursor de la copia (0xFBCB: columna 0-1, fila 0-3) por los dibujos del cuadro y 0xFC4B = fila x 2 + columna
	and 007h		;6713   ; la direccion
	rrca			;6715
	ret c			;6716   ; bit 0: nada
	ld hl,(0fbcbh)		;6717   ; el cursor de la copia
	rra			;671a   ; en horizontal?
	jr nc,copia_cursor_v		;671b
	ld l,001h		;671d   ; la derecha
	rrca			;671f   ; a la izquierda?
	jr nc,copia_cursor_fin		;6720
	dec l			;6722   ; la izquierda
	jr copia_cursor_fin		;6723
copia_cursor_v:
	ld b,a			;6725   ; hacia abajo o arriba
	ld a,(0fc42h)		;6726   ; con animacion?
	and a			;6729
	jr z,copia_cursor_fin		;672a   ; no: solo la primera fila
	djnz copia_cursor_arriba		;672c   ; abajo?
	inc h			;672e   ; la fila de abajo
	ld a,h			;672f
	cp 004h		;6730   ; hasta la 3
	jr c,copia_cursor_fin		;6732
	dec h			;6734   ; no
	jr copia_cursor_fin		;6735
copia_cursor_arriba:
	dec h			;6737   ; la fila 0?
	inc h			;6738
	jr z,copia_cursor_fin		;6739
	dec h			;673b   ; la de arriba
copia_cursor_fin:
	ld (0fbcbh),hl		;673c   ; el cursor
	ld a,h			;673f   ; la fila x 2...
	add a,a			;6740
	or l			;6741   ; ...+ la columna
	ld (0fc4bh),a		;6742   ; el dibujo de origen
	ret			;6745
copia_marca:		; En el modo de copia (0xFE6D = 0x19), la marca del dibujo de 0xFBCB en la pantalla de texto: la casilla 0x0B (NZ, 0x6746) o un espacio (Z, desde 0x6747)
	or 0afh		;6746   ; NZ; desde 0x6747 "xor a": Z
	ld b,a			;6748   ; la marca
	ld a,(0fe6dh)		;6749   ; el modo
	cp 019h		;674c   ; el de copiar?
	ret nz			;674e
	ld a,b			;674f
	and a			;6750
	ld a,00bh		;6751   ; la casilla 0x0B
	jr nz,copia_marca_va		;6753
	ld a,020h		;6755   ; un espacio
copia_marca_va:
	push af			;6757
	ld bc,(0fbcbh)		;6758   ; el cursor
	push bc			;675c
	ld hl,0ff60h		;675d   ; -0xA0...
	ld de,000a0h		;6760   ; ...+ 0xA0 por fila
	inc b			;6763
copia_marca_fila:
	add hl,de			;6764
	djnz copia_marca_fila		;6765
	ex de,hl			;6767
	pop bc			;6768
	ld a,c			;6769   ; la columna
	ld c,005h		;676a   ; la derecha: 5
	and a			;676c
	jr nz,copia_marca_pon		;676d
	ld c,000h		;676f   ; la izquierda: 0
copia_marca_pon:
	ld hl,03c77h		;6771   ; la pantalla de texto
	ld b,000h		;6774
	add hl,bc			;6776
	add hl,de			;6777
	pop af			;6778   ; la marca
	jp 0004dh		;6779   ; WRTVRM
dibujo_borra:		; BORRA (menu 0x22): el dibujo de ahora se guarda y se quita (0x6355); el editor a 0, los numeros, sin dibujo y el cuadro (0x6523, 0x4985)
	ld a,(0fc48h)		;677c   ; sin sitio?
	and a			;677f
	ret nz			;6780
	ld de,(0fc40h)		;6781   ; los sprites libres
	ld a,(0fc46h)		;6785   ; el dibujo
	ld e,a			;6788   ; el dibujo
	push de			;6789
	push de			;678a
	call dibujo_del_editor		;678b   ; lo dibujado
	call personaje_sprites		;678e   ; los sprites
	pop de			;6791
	call dibujo_quita		;6792   ; se quita
	pop de			;6795
	ret c			;6796   ; no se puede
	call sprites_dibujos_cero		;6797   ; el editor a 0
	call personaje_numeros		;679a   ; los numeros
	ld a,0ffh		;679d   ; sin dibujo
	ld (0fc46h),a		;679f   ; el dibujo en el editor
	xor a			;67a2   ; a ningun dibujo
	call dibujo_cambia		;67a3
	jp objeto_sprites_pon		;67a6   ; los sprites del personaje
dibujo_volteo_v:		; ARRIBA-ABAJO (menu 0x22): el dibujo del editor (0x68B1, a 0xFAC2) da la vuelta de arriba abajo: cada sprite fila a fila (0x67F3) y, con dos de alto, los de arriba con los de abajo (y sus colores); a la VRAM y al personaje
	ld a,(0fc48h)		;67a9   ; sin sitio?
	and a			;67ac
	ret nz			;67ad
	call editor_a_ram		;67ae   ; el editor a la RAM
	ld hl,0fac2h		;67b1   ; los dibujos
	push hl			;67b4
	ld b,004h		;67b5   ; cuatro sprites
dibujo_volteo_v_uno:
	push bc			;67b7
	call sprite_volteo_v		;67b8   ; un sprite
	add hl,bc			;67bb   ; el siguiente
	pop bc			;67bc
	djnz dibujo_volteo_v_uno		;67bd
	pop de			;67bf
	ld a,(0fc43h)		;67c0   ; la forma
	cp 002h		;67c3   ; dos de alto?
	jr c,dibujo_volteo_v_fin		;67c5   ; no
	push hl			;67c7
	ld hl,00040h		;67c8   ; los de arriba con los de abajo
	ld b,l			;67cb   ; 64 bytes
	add hl,de			;67cc
dibujo_volteo_v_cambia:
	ld a,(de)			;67cd   ; cambiados
	ldi		;67ce
	dec hl			;67d0
	ld (hl),a			;67d1
	inc hl			;67d2
	inc bc			;67d3
	djnz dibujo_volteo_v_cambia		;67d4
	pop de			;67d6
	ld hl,0fb44h		;67d7   ; los colores
	ld b,002h		;67da   ; dos
dibujo_volteo_v_color:
	ld a,(de)			;67dc   ; el de arriba...
	ld c,(hl)			;67dd
	ld (hl),a			;67de   ; ...y el de abajo cambiados
	ld a,c			;67df
	ld (de),a			;67e0
	inc hl			;67e1
	inc de			;67e2
	djnz dibujo_volteo_v_color		;67e3
dibujo_volteo_v_fin:
	call editor_a_vram		;67e5   ; a la VRAM
	ld de,(0fc46h)		;67e8   ; el dibujo
	ld a,(0fc41h)		;67ec   ; el personaje
	ld d,a			;67ef
	jp dibujo_del_editor		;67f0   ; guardado
sprite_volteo_v:		; Un sprite de 16 x 16 (32 bytes) de arriba abajo: las dos columnas de 16 bytes, cambiando cada fila con la de enfrente
	push hl			;67f3
	ex de,hl			;67f4
	ld c,002h		;67f5   ; las dos columnas del sprite
sprite_volteo_v_col:
	ld hl,0000fh		;67f7   ; el ultimo byte de la columna
	add hl,de			;67fa
	push hl			;67fb
	ld b,008h		;67fc   ; 8 parejas
sprite_volteo_v_fila:
	ld a,(de)			;67fe   ; el de arriba...
	ldi		;67ff   ; ...baja...
	dec hl			;6801
	ld (hl),a			;6802   ; ...y el de abajo sube
	dec hl			;6803   ; el siguiente de abajo
	inc c			;6804
	djnz sprite_volteo_v_fila		;6805
	pop de			;6807   ; la otra columna
	inc de			;6808
	dec c			;6809
	jr nz,sprite_volteo_v_col		;680a
	pop hl			;680c   ; 32 bytes
	ld c,020h		;680d
	ret			;680f
dibujo_volteo_h:		; IZQUIERDA-DERECHA (menu 0x22): cada byte del dibujo al reves (0x6863) y las columnas cambiadas; con dos de ancho, los sprites y sus colores cambiados de lado
	ld a,(0fc48h)		;6810   ; sin sitio?
	and a			;6813
	ret nz			;6814
	call editor_a_ram		;6815   ; el editor a la RAM
	ld hl,0fac2h		;6818   ; los dibujos
	push hl			;681b
	ld b,004h		;681c   ; cuatro sprites
dibujo_volteo_h_uno:
	push bc			;681e
	call sprite_volteo_h		;681f   ; un sprite
	add hl,bc			;6822   ; el siguiente
	pop bc			;6823
	djnz dibujo_volteo_h_uno		;6824
	pop de			;6826
	ld a,(0fc43h)		;6827   ; la forma
	rrca			;682a   ; dos de ancho?
	jr nc,dibujo_volteo_h_fin		;682b   ; no
	ld hl,(0fb42h)		;682d   ; los colores de arriba
	ld a,l			;6830   ; cambiados
	ld l,h			;6831
	ld h,a			;6832
	ld (0fb42h),hl		;6833
	ld hl,(0fb44h)		;6836   ; los de abajo
	ld a,l			;6839   ; cambiados
	ld l,h			;683a
	ld h,a			;683b
	ld (0fb44h),hl		;683c
	ld c,002h		;683f   ; dos parejas
dibujo_volteo_h_par:
	ld hl,00020h		;6841   ; el de la derecha
	ld b,l			;6844
	add hl,de			;6845
dibujo_volteo_h_cambia:
	ld a,(de)			;6846   ; cambiados
	ldi		;6847
	dec hl			;6849
	ld (hl),a			;684a
	inc hl			;684b
	inc bc			;684c
	djnz dibujo_volteo_h_cambia		;684d
	ld de,0fb02h		;684f   ; la otra pareja
	dec c			;6852
	jr nz,dibujo_volteo_h_par		;6853
dibujo_volteo_h_fin:
	call editor_a_vram		;6855   ; a la VRAM
	ld de,(0fc46h)		;6858   ; el dibujo
	ld a,(0fc41h)		;685c   ; el personaje
	ld d,a			;685f
	jp dibujo_del_editor		;6860   ; guardado
sprite_volteo_h:		; Un sprite de 16 x 16 de izquierda a derecha: los 32 bytes al reves bit a bit y las dos columnas de 16 bytes cambiadas (por 0xFBC1)
	push hl			;6863
	ld c,020h		;6864   ; 32 bytes
sprite_volteo_h_byte:
	ld b,008h		;6866   ; 8 bits
sprite_volteo_h_bit:
	rr (hl)		;6868   ; sale por la derecha...
	rla			;686a   ; ...entra por la izquierda
	djnz sprite_volteo_h_bit		;686b
	ld (hl),a			;686d   ; al reves
	inc hl			;686e
	dec c			;686f
	jr nz,sprite_volteo_h_byte		;6870
	dec hl			;6872
	push hl			;6873
	ld de,0fbc1h		;6874   ; por 0xFBC1
	ld bc,00010h		;6877   ; la columna de la derecha...
	lddr		;687a   ; ...guardada
	ex de,hl			;687c
	ex (sp),hl			;687d
	ex de,hl			;687e
	ld c,010h		;687f   ; la de la izquierda...
	lddr		;6881   ; ...a la derecha
	inc hl			;6883
	ex de,hl			;6884
	pop hl			;6885
	inc hl			;6886
	ld c,010h		;6887   ; la guardada...
	ldir		;6889   ; ...a la izquierda
	pop hl			;688b
	ld c,020h		;688c   ; 32 bytes
	ret			;688e

; ----------------------------------------------------------------------
; DATOS sin_uso_688f: Tres bytes que nadie lee
;   0x688f..0x6892  (3 bytes)
DATA_sin_uso_688f:
	defb 0e5h,018h,0e1h	; 688f

; ======================================================================
; CODIGO 0x6892..0x6dc1  (1327 bytes)
; ======================================================================


editor_a_vram:		; Los 4 colores de 0xFB42 a la muestra y el dibujo de 0xFAC2 al editor (0x1E80, 0x80 bytes)
	call muestra_color		;6892
	ld de,0fb42h		;6895   ; los colores
	ld b,004h		;6898   ; cuatro
editor_a_vram_color:
	ld a,(de)			;689a   ; el color
	call 0004dh		;689b   ; WRTVRM
	inc de			;689e
	inc hl			;689f   ; el siguiente sprite
	inc hl			;68a0
	inc hl			;68a1
	inc hl			;68a2
	djnz editor_a_vram_color		;68a3
editor_dibujo_vram:
	ld hl,0fac2h		;68a5   ; el dibujo
	ld de,01e80h		;68a8   ; al editor
	ld bc,00080h		;68ab   ; 0x80 bytes
	jp ldirvm		;68ae   ; LDIRVM
editor_a_ram:		; Los 4 colores de la muestra a 0xFB42 y el dibujo del editor (0x1E80) a 0xFAC2
	call muestra_color		;68b1
	ld de,0fb42h		;68b4   ; a 0xFB42
	ld b,004h		;68b7   ; cuatro
editor_a_ram_color:
	call 0004ah		;68b9   ; RDVRM
	ld (de),a			;68bc   ; el color
	inc hl			;68bd   ; el siguiente sprite
	inc hl			;68be
	inc hl			;68bf
	inc hl			;68c0
	inc de			;68c1
	djnz editor_a_ram_color		;68c2
editor_dibujo_ram:
	ld hl,01e80h		;68c4   ; el editor
	ld de,0fac2h		;68c7   ; a 0xFAC2
	ld bc,00080h		;68ca   ; 0x80 bytes
	jp ldirmv		;68cd   ; LDIRMV
cuadrante_elige:		; Lleva el cursor al cuarto del dibujo de la direccion A (0x10 en X o en Y; con los bytes que siguen a cada "jr", las cuatro esquinas) y la rejilla
	and 007h		;68d0   ; la direccion
	rrca			;68d2
	ret c			;68d3   ; bit 0: nada
	ld bc,00010h		;68d4   ; 16 puntos
	ld hl,(0fbc3h)		;68d7   ; el cursor
	and a			;68da
	jr z,$+14		;68db   ; arriba
	dec a			;68dd
	jr z,$+9		;68de   ; derecha
	dec a			;68e0
	jr z,$+4		;68e1   ; abajo
	ld l,b			;68e3   ; izquierda: X 16...
	cp 061h		;68e4   ; (0x68E5: Y 16; 0x68E7: X 0; 0x68E9: Y 0)
	cp 069h		;68e6
	cp 060h		;68e8
	ld (0fbc3h),hl		;68ea   ; el cursor
	jp rejilla_dibujo		;68ed   ; la rejilla
dibujo_desplaza:		; DESPLAZAR (menu 0x22): el dibujo del editor se mueve un punto en la direccion A (bit 0 a 1 no hace nada), dando la vuelta
	ld b,a			;68f0
	ld a,(0fc48h)		;68f1   ; sin sitio?
	and a			;68f4
	ret nz			;68f5
	ld a,b			;68f6
	and a			;68f7   ; sin direccion?
	ret z			;68f8
	bit 0,a		;68f9   ; bit 0: nada
	ret nz			;68fb
	push af			;68fc
	call editor_dibujo_ram		;68fd   ; el dibujo a 0xFAC2
	pop af			;6900   ; la direccion
	and 007h		;6901   ; la direccion
	jr nz,dibujo_desplaza_abajo		;6903   ; arriba?
	call desplaza_arriba		;6905   ; arriba
	jr dibujo_desplaza_fin		;6908
dibujo_desplaza_abajo:
	sub 004h		;690a   ; abajo?
	jr nz,dibujo_desplaza_lado		;690c
	call desplaza_abajo		;690e   ; abajo
	jr dibujo_desplaza_fin		;6911
dibujo_desplaza_lado:
	push af			;6913
	call c,desplaza_derecha		;6914   ; a la derecha
	pop af			;6917   ; derecha o izquierda
	call nc,desplaza_izquierda		;6918   ; a la izquierda
dibujo_desplaza_fin:
	call forma_recorta		;691b   ; lo que no se usa, a 0
	call editor_dibujo_vram		;691e   ; al editor
	ld de,(0fc46h)		;6921   ; el dibujo en el editor
	ld a,(0fc41h)		;6925   ; el personaje del editor
	ld d,a			;6928   ; el personaje
	call dibujo_del_editor		;6929   ; al personaje
	jp rejilla_dibujo		;692c   ; la rejilla
desplaza_arriba:		; Las 4 columnas de 16 bytes del dibujo (0xFAC3) suben un byte; el de arriba de cada columna pasa a la de debajo... (32 x 32: el de la parte de abajo) y el ultimo a 0
	ld b,004h		;692f   ; cuatro columnas
	ld hl,0fac3h		;6931   ; desde el segundo byte
desplaza_arriba_col:
	push bc			;6934
	ld d,h			;6935   ; uno antes
	ld e,l			;6936
	dec de			;6937
	ld bc,0000fh		;6938   ; 15 bytes
	ldir		;693b   ; 15 bytes arriba
	ld c,030h		;693d   ; la otra parte
	add hl,bc			;693f
	ld a,(hl)			;6940   ; su primer byte...
	ld (de),a			;6941   ; el de la otra parte
	ld d,h			;6942   ; ...sube
	ld e,l			;6943
	inc hl			;6944
	ld c,00fh		;6945   ; 15 bytes
	ldir		;6947   ; 15 mas
	xor a			;6949   ; el ultimo, a 0
	ld (de),a			;694a   ; el ultimo a 0
	ld bc,0ffc1h		;694b   ; la columna siguiente
	add hl,bc			;694e
	pop bc			;694f
	djnz desplaza_arriba_col		;6950
	ret			;6952
desplaza_abajo:		; Lo mismo hacia abajo, desde 0xFB10 (lddr)
	ld b,004h		;6953   ; cuatro columnas
	ld hl,0fb10h		;6955   ; desde el penultimo
desplaza_abajo_col:
	push bc			;6958
	ld d,h			;6959
	ld e,l			;695a
	inc de			;695b   ; uno despues
	ld bc,0000fh		;695c   ; 15 bytes
	lddr		;695f
	ld bc,0ffd0h		;6961   ; la otra parte
	add hl,bc			;6964
	ld a,(hl)			;6965   ; su ultimo byte...
	ld (de),a			;6966   ; ...baja
	ld d,h			;6967
	ld e,l			;6968
	dec hl			;6969
	ld bc,0000fh		;696a   ; 15 bytes
	lddr		;696d
	xor a			;696f
	ld (de),a			;6970   ; el primero a 0
	ld c,05fh		;6971   ; la columna anterior
	add hl,bc			;6973
	pop bc			;6974
	djnz desplaza_abajo_col		;6975
	ret			;6977
desplaza_derecha:		; Cada fila del dibujo (las 16 de las dos mitades) un punto a la derecha: srl en el primer byte y rr en los otros tres de la fila
	ld hl,0fac2h		;6978   ; el dibujo
	ld a,002h		;697b   ; dos mitades
desplaza_derecha_mitad:
	ld de,00010h		;697d   ; de 16 en 16
	ld c,e			;6980   ; 16 filas
desplaza_derecha_fila:
	push hl			;6981
	srl (hl)		;6982   ; el primero: entra un 0
	ld b,003h		;6984   ; los otros tres
desplaza_derecha_byte:
	push af			;6986
	add hl,de			;6987   ; el siguiente de la fila
	pop af			;6988
	rr (hl)		;6989   ; el bit de la izquierda entra
	djnz desplaza_derecha_byte		;698b   ; ...
	pop hl			;698d
	inc hl			;698e   ; la fila siguiente
	dec c			;698f
	jr nz,desplaza_derecha_fila		;6990
	ld e,030h		;6992   ; la mitad de abajo
	add hl,de			;6994
	dec a			;6995   ; la otra mitad
	jr nz,desplaza_derecha_mitad		;6996
	ret			;6998
desplaza_izquierda:		; Cada fila un punto a la izquierda: sla en el ultimo byte y rl en los otros, desde 0xFB41 hacia atras
	ld hl,0fb41h		;6999   ; desde el final
	ld a,002h		;699c   ; dos mitades
desplaza_izquierda_mitad:
	ld de,0fff0h		;699e   ; de 16 en 16 hacia atras
	ld c,010h		;69a1   ; 16 filas
desplaza_izquierda_fila:
	push hl			;69a3
	sla (hl)		;69a4   ; el ultimo: entra un 0
	ld b,003h		;69a6   ; los otros tres
desplaza_izquierda_byte:
	push af			;69a8
	add hl,de			;69a9   ; el anterior de la fila
	pop af			;69aa
	rl (hl)		;69ab   ; el bit de la derecha entra
	djnz desplaza_izquierda_byte		;69ad
	pop hl			;69af
	dec hl			;69b0   ; la fila anterior
	dec c			;69b1
	jr nz,desplaza_izquierda_fila		;69b2
	ld de,0ffd0h		;69b4   ; la mitad de arriba
	add hl,de			;69b7
	dec a			;69b8   ; la otra mitad
	jr nz,desplaza_izquierda_mitad		;69b9
	ret			;69bb
forma_recorta:		; A 0 lo que la forma (0xFC43) no usa del dibujo de 0xFAC2: con dos de alto, 0xFB22 y 0xFAE2 (32 + 32); con uno, 0xFB02 (64) o, con 0, 0xFAE2 (96)
	ld a,(0fc43h)		;69bc   ; la forma
	cp 002h		;69bf   ; dos de alto?
	jr nz,forma_recorta_ancho		;69c1   ; no
	ld hl,0fb22h		;69c3   ; la mitad de abajo de la derecha...
	ld b,020h		;69c6   ; ...32
	call cero_b		;69c8
	ld b,020h		;69cb   ; la de abajo de la izquierda: 32
	jr fae2_cero		;69cd
forma_recorta_ancho:
	ret nc			;69cf   ; dos de ancho: nada
	ld hl,0fb02h		;69d0   ; los tres de mas
	ld b,040h		;69d3
	dec a			;69d5   ; la forma 1?
	jr z,cero_b		;69d6
	ld b,060h		;69d8   ; la forma 0: 96
fae2_cero:		; 0xFAE2 en adelante, B bytes a 0
	ld hl,0fae2h		;69da
cero_b:		; B bytes desde HL a 0
	xor a			;69dd
llena_b:		; B bytes desde HL = A
	ld (hl),a			;69de
	inc hl			;69df   ; el siguiente
	djnz llena_b		;69e0
	ret			;69e2
muestras_pinta:		; SUMUESTRA (menu 0x22, opcion 2): el color 0xF1 en 16 grupos de 0x3F10, las 20 muestras de sprite de la ROM (0xA541, 0x280 bytes) en la VRAM 0x400 y un dibujo de 0xA7C9 en 0x7F8; la tabla de 2 x 5 casillas de cada muestra (0x80 en adelante) en 0xFAC2 y en la pantalla desde 0x3C83 (8 filas de 15)
	ld a,0f1h		;69e3   ; blanco sobre negro
	ld bc,00010h		;69e5   ; 16 grupos
	ld hl,03f10h		;69e8   ; desde el grupo 0x10
	call 00056h		;69eb   ; FILVRM
	ld hl,0a541h		;69ee   ; las muestras
	ld de,00400h		;69f1   ; en la letra 0x80
	ld bc,00280h		;69f4   ; 20 de 32 bytes
	call ldirvm_mas		;69f7   ; LDIRVM
	ld hl,0a7c9h		;69fa   ; el cursor
	ld de,007f8h		;69fd   ; en la letra 0xFF
	ld bc,00008h		;6a00   ; 8 bytes
	call ldirvm_mas		;6a03   ; LDIRVM
	ld hl,0fac2h		;6a06   ; la tabla
	push hl			;6a09
	ld c,000h		;6a0a   ; el espacio
	ld a,080h		;6a0c   ; desde la casilla 0x80
	ld de,00205h		;6a0e   ; 5 por fila, + 2
muestras_fila:
	ld b,e			;6a11   ; 5
	push af			;6a12
muestras_uno:
	ld (hl),a			;6a13   ; la de arriba
	inc hl			;6a14   ; el siguiente
	add a,d			;6a15   ; + 2
	ld (hl),a			;6a16   ; la de abajo
	add a,d			;6a17   ; + 2
	inc hl			;6a18
	ld (hl),c			;6a19   ; un espacio
	inc hl			;6a1a
	djnz muestras_uno		;6a1b   ; la siguiente muestra
	pop af			;6a1d
	inc a			;6a1e   ; la fila de abajo de la muestra
	bit 0,a		;6a1f   ; las dos filas?
	jr nz,muestras_fila		;6a21
	add a,012h		;6a23   ; la fila de muestras siguiente
	cp 0d0h		;6a25   ; hasta 0xD0
	jr c,muestras_fila		;6a27   ; las 4 filas de muestras
	pop hl			;6a29
	ld de,03c83h		;6a2a   ; a la pantalla, desde 0x3C83
	ld a,008h		;6a2d   ; 8 filas
muestras_pinta_fila:
	push af			;6a2f
	ld c,00fh		;6a30   ; 15 casillas
	call ldirvm_mas		;6a32   ; LDIRVM: 15 casillas
	ld c,020h		;6a35   ; la fila de abajo
	ex de,hl			;6a37
	add hl,bc			;6a38
	ex de,hl			;6a39
	pop af			;6a3a
	dec a			;6a3b   ; una fila menos
	bit 0,a		;6a3c   ; la de abajo de la muestra?
	jr nz,muestras_pinta_fila		;6a3e
	ex de,hl			;6a40   ; una fila en blanco entre medias
	add hl,bc			;6a41
	add hl,bc			;6a42
	ex de,hl			;6a43
	and a			;6a44   ; todas?
	jr nz,muestras_pinta_fila		;6a45
	ret			;6a47
muestra_cursor:		; Mueve el cursor de las muestras (0xFC4C: columna en los bits 0-4 de 3 en 3, fila de 0x20 en 0x20 y H el numero de muestra) en la direccion A y lo pinta (0x6A9D con 0xFF; antes lo borra con 0)
	and a			;6a48   ; sin direccion?
	ret z			;6a49
	push af			;6a4a
	xor a			;6a4b   ; la marca, borrada
	call muestra_marca		;6a4c   ; borra la marca
	ld hl,(0fc4ch)		;6a4f   ; el cursor
	pop af			;6a52
	push af			;6a53
	and 003h		;6a54   ; en horizontal?
	jr z,muestra_cursor_v		;6a56   ; no
	pop af			;6a58
	push af			;6a59
	bit 2,a		;6a5a   ; a la izquierda?
	ld a,01fh		;6a5c   ; los bits de la columna
	jr nz,muestra_cursor_izq		;6a5e   ; izquierda
	and l			;6a60   ; la columna...
	cp 00ch		;6a61   ; la ultima columna?
	jr nc,muestra_cursor_v		;6a63   ; ...ya la ultima?
	ld a,003h		;6a65   ; 3 casillas a la derecha
	add a,l			;6a67   ; 3 a la derecha
	ld l,a			;6a68
	inc h			;6a69   ; la siguiente muestra
	jr muestra_cursor_v		;6a6a   ; ya
muestra_cursor_izq:
	and l			;6a6c   ; la columna 0?
	jr z,muestra_cursor_v		;6a6d   ; la primera?
	ld a,l			;6a6f
	sub 003h		;6a70   ; 3 a la izquierda
	ld l,a			;6a72
	dec h			;6a73   ; la anterior
	jr muestra_cursor_v		;6a74
muestra_cursor_v:
	pop af			;6a76
	push af			;6a77
	and 003h		;6a78   ; en vertical?
	cp 002h		;6a7a
	jr z,muestra_cursor_pon		;6a7c   ; no
	pop af			;6a7e
	inc a			;6a7f
	bit 2,a		;6a80   ; abajo?
	ld a,0a0h		;6a82   ; la ultima fila?
	ld de,00520h		;6a84   ; 5 muestras y una fila (0x20) de pantalla
	jr z,muestra_cursor_arriba		;6a87   ; arriba
	add a,l			;6a89   ; la ultima fila?
	jr c,muestra_cursor_fin		;6a8a
	add hl,de			;6a8c   ; abajo
	jr muestra_cursor_fin		;6a8d   ; ya
muestra_cursor_arriba:
	ld a,0e0h		;6a8f   ; la fila
	and l			;6a91
	jr z,muestra_cursor_fin		;6a92   ; la primera?
	sbc hl,de		;6a94   ; arriba
muestra_cursor_fin:
	push af			;6a96
muestra_cursor_pon:
	pop af			;6a97
	ld (0fc4ch),hl		;6a98   ; el cursor
	ld a,0ffh		;6a9b   ; la marca
muestra_marca:		; La marca A (0 la borra, 0xFF la pone) delante de la muestra del cursor (0x3CC3 + fila x 0x80 + columna), dos casillas
	ld de,03cc3h		;6a9d   ; la pantalla de las muestras
	push af			;6aa0
	ld a,(0fc4ch)		;6aa1   ; el cursor
	push af			;6aa4
	and 0e0h		;6aa5   ; la fila...
	ld h,000h		;6aa7
	ld l,a			;6aa9
	add hl,hl			;6aaa   ; ...x 4 (0x80 por fila)
	add hl,hl			;6aab
	pop af			;6aac
	and 00fh		;6aad   ; la columna
	call hl_mas_a		;6aaf
	pop af			;6ab2
	add hl,de			;6ab3   ; en la pantalla
	push af			;6ab4
	call 0004dh		;6ab5   ; WRTVRM
	pop af			;6ab8
	inc hl			;6ab9   ; la de al lado
	jp 0004dh		;6aba   ; WRTVRM
muestra_coge:		; La muestra elegida (0xFC4D) se copia en el dibujo de ahora: sus 32 bytes de 0xA541 al editor (0x1E80), los otros 0x60 a 0, color 15; se guarda en el personaje
	call memoria_mira		;6abd   ; hay sitio?
	ret c			;6ac0   ; sin sitio
	call muestra_pon		;6ac1   ; la muestra en el editor
	ld a,(0fc4dh)		;6ac4   ; la muestra...
	call por32_a		;6ac7   ; ...x 32
	ld hl,0a541h		;6aca   ; de la ROM
	add hl,bc			;6acd   ; la muestra en la ROM
	ld de,01e80h		;6ace   ; al editor
	ld bc,00020h		;6ad1   ; 32 bytes
	call ldirvm_mas		;6ad4   ; LDIRVM
	ex de,hl			;6ad7
	add hl,bc			;6ad8
	ld c,060h		;6ad9   ; los otros 0x60...
	xor a			;6adb   ; ...a 0
	call 00056h		;6adc   ; FILVRM: el resto a 0
	ld de,(0fc46h)		;6adf   ; el dibujo en el editor
	ld a,(0fc41h)		;6ae3   ; el personaje del editor
	ld d,a			;6ae6   ; el personaje
	push de			;6ae7
	call dibujo_del_editor		;6ae8   ; al personaje
	call muestra_color		;6aeb   ; el color
	ld a,00fh		;6aee   ; color 15
	call 0004dh		;6af0   ; WRTVRM
	pop de			;6af3
	call personaje_sprites		;6af4   ; los sprites
	jp personaje_guarda		;6af7   ; guardado
rejilla_dibujo:		; La rejilla ampliada del editor de personajes (16 x 16 casillas desde 0x3C83): los puntos del cuarto del cursor (0x6B53, cuatro trozos de 8 x 8) de 0x10 (vacio) o 0x11-0x13 segun el color, y la muestra del color (0x6B8C)
	call rejilla_casilla		;6afa   ; la casilla del color
	ex af,af'			;6afd   ; la casilla, en reserva
	push af			;6afe
	push hl			;6aff
	ld hl,0fac2h		;6b00   ; 0xFAC2...
	ld b,000h		;6b03   ; 256 bytes
	ld a,010h		;6b05   ; ...con 0x10
	call llena_b		;6b07   ; vacia
	ld de,0fac2h		;6b0a   ; la rejilla
	pop hl			;6b0d
	xor a			;6b0e   ; desde el primer trozo
rejilla_dibujo_trozo:
	call rejilla_trozo		;6b0f   ; un trozo
	add a,008h		;6b12   ; el siguiente
	cp 020h		;6b14   ; los cuatro?
	jr nz,rejilla_dibujo_trozo		;6b16
	call rejilla_color		;6b18   ; el color
	pop af			;6b1b
	ex af,af'			;6b1c
	ld de,03c83h		;6b1d   ; a la pantalla
	ld hl,0fac2h		;6b20   ; la rejilla
	ld bc,00010h		;6b23   ; 16 filas de 16
	ld a,c			;6b26   ; 16 filas
rejilla_dibujo_fila:
	push af			;6b27
	call ldirvm_mas		;6b28   ; LDIRVM
	pop af			;6b2b
	dec a			;6b2c
	ret z			;6b2d   ; acabado
	ex de,hl			;6b2e   ; la fila de abajo
	ld c,020h		;6b2f
	add hl,bc			;6b31
	ex de,hl			;6b32
	ld c,010h		;6b33   ; 16 casillas
	jr rejilla_dibujo_fila		;6b35
rejilla_casilla:		; D = la casilla de los puntos pintados: 0x10, 0x11 (color 0), 0x12 (1) o 0x13 (0x0E); HL el dibujo del cuarto
	push de			;6b37
	call cuadrante		;6b38   ; el cuarto del cursor
	push de			;6b3b
	call 0004ah		;6b3c   ; RDVRM: el color
	ld d,010h		;6b3f   ; vacia: 0x10
	and 00fh		;6b41   ; el color
	jr z,rejilla_casilla_fin		;6b43   ; 0: 0x10
	inc d			;6b45   ; 0x11...
	dec a			;6b46
	jr z,rejilla_casilla_fin		;6b47   ; ...con el color 1
	inc d			;6b49   ; 0x12
	cp 00eh		;6b4a   ; el color 0x0E?
	jr nz,rejilla_casilla_fin		;6b4c
	inc d			;6b4e   ; 0x13
rejilla_casilla_fin:
	ld a,d			;6b4f
	pop hl			;6b50
	pop de			;6b51
	ret			;6b52
rejilla_trozo:		; Un trozo de 8 x 8 del dibujo (desde HL, 0x6B7A) a la rejilla de 0xFAC2: los bits a 1, la casilla D
	push af			;6b53
	push hl			;6b54
	push de			;6b55
	push hl			;6b56
	call rejilla_trozo_sitio		;6b57   ; su sitio en la rejilla
	ex (sp),hl			;6b5a
	ld c,a			;6b5b
	add hl,bc			;6b5c   ; el dibujo
	ex af,af'			;6b5d
	ld d,a			;6b5e   ; la casilla de los puntos
	ex af,af'			;6b5f
	ld c,008h		;6b60   ; 8 filas
	ld e,c			;6b62
rejilla_trozo_fila:
	call 0004ah		;6b63   ; RDVRM
	inc hl			;6b66   ; RDVRM: la fila
	ex (sp),hl			;6b67
	ld b,c			;6b68   ; 8 bits
rejilla_trozo_bit:
	rlca			;6b69   ; el siguiente
	jr nc,rejilla_trozo_sig		;6b6a
	ld (hl),d			;6b6c   ; pintado
rejilla_trozo_sig:
	inc hl			;6b6d   ; la casilla siguiente
	djnz rejilla_trozo_bit		;6b6e
	add hl,bc			;6b70   ; la fila de abajo de la rejilla
	ex (sp),hl			;6b71
	dec e			;6b72   ; una fila menos
	jr nz,rejilla_trozo_fila		;6b73
	pop de			;6b75
	pop de			;6b76
	pop hl			;6b77
	pop af			;6b78
	ret			;6b79
rejilla_trozo_sitio:		; El sitio del trozo A (0, 8, 0x10 o 0x18) en la rejilla: + 0x80 si es de abajo, + 8 si es de la derecha
	ld bc,00008h		;6b7a   ; 8 casillas
	ld h,b			;6b7d   ; desde 0
	ld l,b			;6b7e
	bit 3,a		;6b7f   ; de abajo?
	jr z,rejilla_trozo_x		;6b81
	ld l,080h		;6b83   ; 8 filas de 16
rejilla_trozo_x:
	cp 010h		;6b85   ; de la derecha?
	jr c,rejilla_trozo_fin		;6b87
	add hl,bc			;6b89
rejilla_trozo_fin:
	add hl,de			;6b8a
	ret			;6b8b
rejilla_color:		; El color del sprite del cuarto en la rejilla: la casilla 0x10 (8 bytes en 0x80) de 0xF1 o 0xFFF4..., y los colores de los grupos 1-3 de la pantalla de texto (0x3F01-0x3F03) con el color del sprite
	call cuadrante		;6b8c   ; el cuarto
	call 0004ah		;6b8f   ; RDVRM
	and 00fh		;6b92   ; el color
	ld bc,0010fh		;6b94   ; 0x0F y 1
	ld de,000f1h		;6b97   ; el dibujo lleno y blanco sobre negro
	cp 001h		;6b9a   ; el 1?
	jr nz,rejilla_color_b		;6b9c
	ld de,0fff4h		;6b9e   ; otros
	ld b,c			;6ba1
rejilla_color_b:
	cp c			;6ba2   ; el 15?
	jr nz,rejilla_color_va		;6ba3
	ld c,b			;6ba5
rejilla_color_va:
	rrca			;6ba6   ; a la tinta
	rrca			;6ba7
	rrca			;6ba8
	rrca			;6ba9
	push af			;6baa
	push af			;6bab
	push bc			;6bac
	ld hl,00080h		;6bad   ; la casilla 0x10
	ld bc,00008h		;6bb0   ; 8 bytes
	ld a,d			;6bb3   ; el dibujo
	call 00056h		;6bb4   ; FILVRM
	ld a,e			;6bb7   ; los colores
	ld hl,03f01h		;6bb8   ; del grupo 1
	call 0004dh		;6bbb   ; WRTVRM
	pop bc			;6bbe
	pop af			;6bbf   ; el color...
	or c			;6bc0   ; ...con el fondo
	ld c,a			;6bc1
	pop af			;6bc2
	or b			;6bc3
	ld hl,03f02h		;6bc4   ; del grupo 2
	call 0004dh		;6bc7   ; WRTVRM
	ld a,c			;6bca   ; el del grupo 3
	inc hl			;6bcb
	jp 0004dh		;6bcc   ; WRTVRM
rejilla_cursor:		; La casilla del cursor en la rejilla (0x3C83 + fila x 32 + columna) con el bit 3 puesto (NZ, el cursor) o quitado (Z, desde 0x6BD0)
	ld a,0afh		;6bcf   ; NZ; desde 0x6BD0 "xor a": Z
	push bc			;6bd1
	push hl			;6bd2
	push af			;6bd3
	ld hl,(0fbc2h)		;6bd4   ; el cursor de dentro
	ld a,(0fbc4h)		;6bd7   ; la Y
	ld l,a			;6bda
	ld a,00fh		;6bdb   ; de 0 a 15
	and l			;6bdd
	ld l,a			;6bde
	ld a,00fh		;6bdf
	and h			;6be1
	ld bc,00300h		;6be2   ; x 32
rejilla_cursor_fila:
	srl l		;6be5   ; la fila...
	rr c		;6be7   ; ...a C
	djnz rejilla_cursor_fila		;6be9
	add a,c			;6beb   ; + la columna
	ld c,a			;6bec
	ld b,l			;6bed
	ld hl,03c83h		;6bee   ; la rejilla
	add hl,bc			;6bf1
	call 0004ah		;6bf2   ; RDVRM
	pop bc			;6bf5
	inc b			;6bf6   ; encender?
	set 3,a		;6bf7   ; encendido
	djnz rejilla_cursor_pon		;6bf9
	res 3,a		;6bfb   ; apagado
rejilla_cursor_pon:
	call 0004dh		;6bfd   ; WRTVRM
	pop hl			;6c00
	pop bc			;6c01
	ret			;6c02
cinta_graba_d:		; TAPOON con el byte de cabecera 0x44 ("D", datos): la cinta en marcha con la cabecera larga o corta (0xFE72) y el byte; C si se interrumpe (STOP: 0xFA06 = 0xFF y TAPIOF)
	ld a,044h		;6c03   ; "D": datos
cinta_graba_cabecera:
	exx			;6c05
	push af			;6c06   ; el byte de cabecera
	ld a,(0fe72h)		;6c07   ; larga o corta
	call 000eah		;6c0a   ; TAPOON
	jr c,cinta_corta		;6c0d   ; cortada
	pop af			;6c0f
	call 000edh		;6c10   ; TAPOUT: el byte
	exx			;6c13
	ret nc			;6c14   ; bien
	push af			;6c15
cinta_corta:
	pop af			;6c16
cinta_corta_va:
	ld a,0ffh		;6c17   ; como STOP
	ld (0fa06h),a		;6c19   ; como STOP
	scf			;6c1c   ; C: mal
	jp 000e7h		;6c1d   ; TAPIOF
cinta_lee_d:		; TAPION y espera el byte de cabecera 0x44 (los demas se saltan)
	ld a,044h		;6c20   ; "D"
cinta_lee_cabecera:
	exx			;6c22
cinta_lee_espera:
	push af			;6c23   ; el que se espera
	call 000e1h		;6c24   ; TAPION
	jr c,cinta_corta		;6c27   ; cortada
	call 000e4h		;6c29   ; TAPIN
	jr c,cinta_corta		;6c2c   ; cortada
	pop bc			;6c2e   ; el que se espera
	cp b			;6c2f   ; el que se espera?
	ld a,b			;6c30   ; otro?
	jr nz,cinta_lee_espera		;6c31
	exx			;6c33
	ret			;6c34
cinta_graba_nombre:		; Graba la cabecera "H" y los 0x38 bytes de 0xFAC2 (el nombre y los datos del juego) con su suma
	ld a,048h		;6c35   ; "H": el nombre
	call cinta_graba_cabecera		;6c37   ; la cabecera
	ret c			;6c3a   ; cortada
	ld hl,0fac2h		;6c3b   ; la cabecera del juego
	ld bc,00038h		;6c3e   ; 0x38 bytes
	jr cinta_graba_va		;6c41
cinta_lee_nombre:		; Lee la cabecera "H" y los 0x38 bytes a 0xFAC2 (0x6C70)
	ld a,048h		;6c43   ; "H"
	call cinta_lee_cabecera		;6c45   ; la cabecera
	ret c			;6c48   ; cortada
	ld hl,0fac2h		;6c49   ; a 0xFAC2
	ld bc,00038h		;6c4c   ; 0x38 bytes
	jr cinta_lee_sin		;6c4f
cinta_graba:		; Graba un bloque "D": BC bytes desde HL y su suma (la resta de todos) al final; TAPOOF
	call cinta_graba_d		;6c51   ; la cabecera "D"
	ret c			;6c54   ; cortada
cinta_graba_va:
	ld d,000h		;6c55   ; la suma a 0
cinta_graba_byte:
	ld a,(hl)			;6c57   ; el byte
	add a,d			;6c58   ; la suma
	ld d,a			;6c59
	ld a,(hl)			;6c5a   ; el byte
	inc hl			;6c5b
	exx			;6c5c
	call 000edh		;6c5d   ; TAPOUT
	jr c,cinta_corta_va		;6c60   ; cortada
	exx			;6c62
	dec bc			;6c63   ; uno menos
	ld a,b			;6c64   ; acabado?
	or c			;6c65
	jr nz,cinta_graba_byte		;6c66
	sub d			;6c68   ; la comprobacion
	call 000edh		;6c69   ; TAPOUT
	and a			;6c6c   ; NC: bien
	jp 000f0h		;6c6d   ; TAPOOF
cinta_lee_sin:		; Lee BC bytes a HL sin la cabecera (NZ: los guarda)
	or 0ffh		;6c70   ; NZ: guarda
	ex af,af'			;6c72
	jr cinta_lee_va		;6c73
cinta_compara:		; Con Z (desde 0x6C76: "xor a") compara lo leido con lo que hay en HL; desde 0x6C75 los guarda
	or 0afh		;6c75   ; NZ: guarda; desde 0x6C76 "xor a": compara
	ex af,af'			;6c77   ; Z: compara
	call cinta_lee_d		;6c78   ; la cabecera "D"
	ret c			;6c7b   ; cortada
cinta_lee_va:
	ld d,000h		;6c7c   ; la suma a 0
cinta_lee_byte:
	exx			;6c7e
	call 000e4h		;6c7f   ; TAPIN
	exx			;6c82
	jr c,cinta_corta_va		;6c83   ; cortada
	ex af,af'			;6c85   ; compara?
	jr z,cinta_lee_compara		;6c86   ; comparando?
	ex af,af'			;6c88   ; no
	ld (hl),a			;6c89   ; guardado
	jr cinta_lee_suma		;6c8a   ; guardado
cinta_lee_compara:
	ex af,af'			;6c8c   ; compara
	xor (hl)			;6c8d   ; igual?
	jr nz,cinta_lee_fin		;6c8e   ; no
cinta_lee_suma:
	ld a,(hl)			;6c90   ; el byte
	add a,d			;6c91   ; la suma
	ld d,a			;6c92   ; sumado
	inc hl			;6c93
	dec bc			;6c94   ; uno menos
	ld a,b			;6c95   ; acabado?
	or c			;6c96
	jr nz,cinta_lee_byte		;6c97
	exx			;6c99
	call 000e4h		;6c9a   ; TAPIN: la comprobacion
	exx			;6c9d
	jp c,cinta_corta_va		;6c9e   ; cortada
	add a,d			;6ca1   ; suma + comprobacion = 0?
	and a			;6ca2   ; Z: bien
cinta_lee_fin:
	jp 000e7h		;6ca3   ; TAPIOF
cinta_graba_vram:		; Graba un bloque "D" de BC bytes de la VRAM desde HL (SETRD y el puerto 0x98) con su suma; sin la interrupcion del VDP
	call vdp_int_off		;6ca6   ; sin interrupcion del VDP
	call 00050h		;6ca9   ; SETRD
	call cinta_graba_d		;6cac   ; la cabecera "D"
	jr c,cinta_fin		;6caf   ; cortada
	ld d,000h		;6cb1   ; la suma a 0
cinta_graba_vram_byte:
	in a,(098h)		;6cb3   ; de la VRAM
	ld e,a			;6cb5   ; el byte
	add a,d			;6cb6   ; la suma
	ld d,a			;6cb7
	ld a,e			;6cb8
	exx			;6cb9
	call 000edh		;6cba   ; TAPOUT
	jr c,cinta_fin		;6cbd   ; cortada
	exx			;6cbf
	dec bc			;6cc0   ; uno menos
	ld a,b			;6cc1
	or c			;6cc2
	jr nz,cinta_graba_vram_byte		;6cc3
	sub d			;6cc5   ; la comprobacion
	call 000edh		;6cc6   ; TAPOUT: la comprobacion
	call 000f0h		;6cc9   ; TAPOOF
cinta_bien:
	and a			;6ccc   ; NC: bien
cinta_fin:
	call vdp_int_on		;6ccd   ; la interrupcion del VDP otra vez
	ret nc			;6cd0   ; bien
	jp cinta_corta_va		;6cd1   ; cortada
cinta_compara_vram:		; Lee un bloque "D" y lo compara con la VRAM (SETRD)
	call vdp_int_off		;6cd4   ; sin interrupcion del VDP
	call 00050h		;6cd7   ; SETRD
	jr $+9		;6cda   ; a comparar
cinta_lee_vram:		; Lee un bloque "D" a la VRAM (SETWRT)
	call vdp_int_off		;6cdc   ; sin interrupcion del VDP
	call 00053h		;6cdf   ; SETWRT
	or 0afh		;6ce2   ; NZ: a la VRAM; desde 0x6CE3 "xor a": compara
	ex af,af'			;6ce4
	call cinta_lee_d		;6ce5   ; la cabecera "D"
	jr c,cinta_fin		;6ce8   ; cortada
	ld d,000h		;6cea   ; la suma a 0
cinta_lee_vram_byte:
	exx			;6cec
	call 000e4h		;6ced   ; TAPIN
	jr c,cinta_fin		;6cf0   ; cortada
	exx			;6cf2
	ld e,a			;6cf3   ; el byte
	ex af,af'			;6cf4
	jr z,cinta_lee_vram_compara		;6cf5   ; compara?
	ex af,af'			;6cf7
	out (098h),a		;6cf8   ; a la VRAM
	jr cinta_lee_vram_suma		;6cfa
cinta_lee_vram_compara:
	ex af,af'			;6cfc
	in a,(098h)		;6cfd   ; lo que hay
	xor e			;6cff
	jr nz,cinta_lee_vram_fin		;6d00   ; distinto
cinta_lee_vram_suma:
	ld a,e			;6d02   ; el byte...
	add a,d			;6d03   ; ...sumado
	ld d,a			;6d04
	dec bc			;6d05   ; uno menos
	ld a,b			;6d06
	or c			;6d07
	jr nz,cinta_lee_vram_byte		;6d08
	exx			;6d0a
	call 000e4h		;6d0b   ; TAPIN: la comprobacion
	jr c,cinta_fin		;6d0e   ; cortada
	exx			;6d10
	add a,d			;6d11   ; suma + comprobacion
cinta_lee_vram_fin:
	call 000e7h		;6d12   ; TAPIOF
	jr cinta_bien		;6d15   ; bien
juego_graba:		; GUARDAR: la cabecera (los 8 del nombre, los 0x2A bytes de punteros del juego de 0xF7C7, el tamano de lo de arriba y de lo de abajo y 5 bytes de 0x6DC1 o 0x6DC6, a 0xFAC2; 0xFE73 = 0, grabar) y los bloques (0x6D62)
	xor a			;6d17   ; grabar
	ld (0fe73h),a		;6d18   ; grabar, cargar o comparar
	ld bc,00008h		;6d1b   ; el nombre
	ld de,0fac2h		;6d1e
	ldir		;6d21
	ld hl,0f7c7h		;6d23   ; los punteros del juego
	ld bc,0002ah		;6d26
	ldir		;6d29
	push de			;6d2b
	ld hl,(0f7e9h)		;6d2c   ; el tamano de lo de arriba
	ld de,(0f7efh)		;6d2f   ; el principio de las notas
	and a			;6d33
	sbc hl,de		;6d34
	ex (sp),hl			;6d36
	push hl			;6d37
	ld hl,(0f7e7h)		;6d38   ; el de lo de abajo
	ld de,(0f7c7h)		;6d3b
	and a			;6d3f
	sbc hl,de		;6d40
	ld b,h			;6d42
	ld c,l			;6d43
	pop hl			;6d44
	call bc_escribe		;6d45
	pop bc			;6d48
	call bc_escribe		;6d49
	ld hl,06dc1h		;6d4c   ; 5 bytes: con o sin...
	ld bc,00005h		;6d4f
	ld de,0f406h		;6d52
	ld a,(0fe72h)		;6d55   ; ...cabecera larga
	and a			;6d58
	jr nz,juego_graba_cabecera		;6d59
	add hl,bc			;6d5b
juego_graba_cabecera:
	ldir		;6d5c
	call cinta_graba_nombre		;6d5e   ; la cabecera "H"
	ret c			;6d61
juego_bloques:		; Los cinco bloques del juego por la tabla de 0x6DCB (grabar, cargar o comparar segun 0xFE73): la VRAM 0x800-0x3B7F (dibujos, colores y sprites), 0xF417 (0x3B0 bytes: los datos del juego), 0xFBFC (0x46: los sprites de los personajes), lo de abajo de la RAM (0xF7C7, 0xFAF4 bytes) y el mapa (0xF7EF, 0xFAF6 bytes)
	xor a			;6d62   ; de la VRAM
	ld de,00800h		;6d63   ; desde 0x800
	ld bc,03380h		;6d66   ; 0x3380 bytes
	call bloque_va		;6d69
	ret c			;6d6c
	ld de,0f417h		;6d6d   ; los datos
	ld bc,003b0h		;6d70
	call bloque_ram		;6d73
	ret c			;6d76
	ld de,0fbfch		;6d77   ; la tabla de sprites
	ld bc,00046h		;6d7a
	call bloque_ram		;6d7d
	ret c			;6d80
	ld de,(0f7c7h)		;6d81   ; lo de abajo
	ld bc,(0faf4h)		;6d85
	call bloque_ram		;6d89
	ret c			;6d8c
	ld de,(0f7efh)		;6d8d   ; el mapa
	ld bc,(0faf6h)		;6d91
bloque_ram:		; Un bloque de la RAM (la mitad de la tabla de 0x6DCB)
	ld a,006h		;6d95
bloque_va:		; El bloque de BC bytes desde DE con la rutina de 0x6DCB + A + 0xFE73 x 2 (si BC = 0, nada)
	ld h,a			;6d97
	ld a,b			;6d98   ; vacio?
	or c			;6d99
	ret z			;6d9a
	ld a,h			;6d9b
	ld hl,06dcbh		;6d9c   ; la tabla
	call hl_mas_a		;6d9f
	ld a,(0fe73h)		;6da2   ; grabar, cargar o comparar
	call tabla_puntero		;6da5
	push hl			;6da8   ; vuelve a la que llamo despues
	ex de,hl			;6da9
	ret			;6daa
bloque_compara_vram:
	call cinta_compara_vram		;6dab
	jr bloque_mira		;6dae
bloque_lee_ram:
	call cinta_compara+1		;6db0
	jr bloque_mira		;6db3
bloque_lee_vram:
	call cinta_lee_vram		;6db5
	jr bloque_mira		;6db8
bloque_compara_ram:
	call cinta_compara		;6dba
bloque_mira:		; Despues de leer: con C (cortado) o NZ (mal), vuelve a quien llamo a juego_bloques; si no, sigue
	pop hl			;6dbd
	ret c			;6dbe
	ret nz			;6dbf
	jp (hl)			;6dc0

; ----------------------------------------------------------------------
; DATOS cinta_largos: Los 5 bytes de 0xF406 con cabecera larga (0x6DC1) o
;   corta (0x6DC6)
;   0x6dc1..0x6dcb  (10 bytes)
DATA_cinta_largos:
	defb 053h,05ch,026h,02dh,00fh,025h,02dh,00eh,016h,01fh	; 6dc1  S\&-.%-...

; ----------------------------------------------------------------------
; DATOS cinta_tabla: Las rutinas de los bloques: de la VRAM (grabar 0x6CA6,
;   cargar 0x6DB5, comparar 0x6DAB) y de la RAM (0x6C51, 0x6DBA, 0x6DB0)
;   0x6dcb..0x6dd7  (12 bytes)
DATA_cinta_tabla:
	defb 0a6h,06ch,0b5h,06dh,0abh,06dh,051h,06ch,0bah,06dh,0b0h,06dh	; 6dcb  .l.m.mQl.m.m

; ======================================================================
; CODIGO 0x6dd7..0x6ebd  (230 bytes)
; ======================================================================


juego_carga:		; CARGAR: los sprites vacios, 0xFBD4 = 0, 0xFE73 = 1; busca en la cinta el juego del nombre (0x6E68); si se grabo con otro principio de la RAM, los 17 punteros de la cabecera se mueven (y si no cabe, "no hay memoria", 0x81BA); los punteros a 0xF7C7, los bloques (0x6D62) y el mapa de trabajo al principio
	push hl			;6dd7
	call sprites_vacia		;6dd8
	xor a			;6ddb   ; sin preparar
	ld (0fbd4h),a		;6ddc   ; ya preparado
	pop hl			;6ddf
	ld a,001h		;6de0   ; cargar
	ld (0fe73h),a		;6de2   ; grabar, cargar o comparar
	call cinta_busca		;6de5   ; el nombre
	ret c			;6de8
	ld bc,(0f7e9h)		;6de9   ; la RAM de ahora...
	ld hl,(0f7c7h)		;6ded
	ld de,(0facah)		;6df0   ; ...y la del juego
	rst 20h			;6df4   ; la misma?
	jr z,juego_carga_va		;6df5
	and a			;6df7
	push bc			;6df8
	ex (sp),hl			;6df9
	pop de			;6dfa
	sbc hl,de		;6dfb
	ex de,hl			;6dfd
	ld hl,(0faf4h)		;6dfe   ; lo que ocupa
	ld bc,(0faf6h)		;6e01
	add hl,bc			;6e05
	rst 20h			;6e06   ; cabe?
	jr z,juego_carga_va		;6e07
	jp nc,sin_memoria		;6e09   ; no
	ld hl,(0f7c7h)		;6e0c   ; la diferencia
	ld de,(0facah)		;6e0f
	and a			;6e13
	sbc hl,de		;6e14
	ex de,hl			;6e16
	ld b,011h		;6e17   ; 17 punteros
	ld hl,0facah		;6e19
juego_carga_mueve:
	push bc			;6e1c
	push hl			;6e1d
	call palabra_lee		;6e1e   ; el puntero
	add hl,de			;6e21   ; + la diferencia
	ld b,h			;6e22
	ld c,l			;6e23
	pop hl			;6e24
	call bc_escribe		;6e25   ; movido
	pop bc			;6e28
	djnz juego_carga_mueve		;6e29   ; los 17
juego_carga_va:
	ld hl,0facah		;6e2b
	ld de,0f7c7h		;6e2e   ; los punteros del juego
	ld bc,0002ah		;6e31
	ldir		;6e34
	ld hl,(0f7ebh)		;6e36   ; los dibujos
	ld (0fbech),hl		;6e39   ; el final del mapa
	ld de,00210h		;6e3c
	and a			;6e3f
	sbc hl,de		;6e40
	ld (0fbeah),hl		;6e42   ; el ultimo trozo del mapa
	call juego_bloques		;6e45   ; los bloques
	ret c			;6e48
	ld hl,(0f7edh)		;6e49   ; el mapa de trabajo
	ld (0fbe8h),hl		;6e4c   ; el mapa de trabajo
	xor a			;6e4f   ; sin partir
	ld (0fbeeh),a		;6e50   ; la fila partida
	ld a,0ffh		;6e53   ; sin fondo y preparado
	ld (0fbe6h),a		;6e55   ; el fondo
	ld (0fbd4h),a		;6e58   ; ya preparado
	ret			;6e5b
juego_compara:		; COMPROBAR: 0xFE73 = 2; el nombre y los bloques comparados
	ld a,002h		;6e5c
	ld (0fe73h),a		;6e5e   ; grabar, cargar o comparar
	call cinta_busca		;6e61
	ret c			;6e64
	jp juego_bloques		;6e65
cinta_busca:		; Lee cabeceras de la cinta hasta la del nombre de HL (8 letras; en blanco, la primera): escribe "FOUND" con su nombre en la fila 3 y, si no es, "SKIP"
	push hl			;6e68
cinta_busca_uno:
	call cinta_lee_nombre		;6e69   ; una cabecera
	jr c,cinta_busca_fin		;6e6c
	ld hl,00f03h		;6e6e   ; fila 3, columna 0x0F
	ld (0fa1dh),hl		;6e71   ; la posicion del cursor
	push hl			;6e74
	ld b,00eh		;6e75   ; 14 espacios
cinta_busca_borra:
	ld a,020h		;6e77
	call letra_escribe		;6e79
	djnz cinta_busca_borra		;6e7c
	pop hl			;6e7e
	ld (0fa1dh),hl		;6e7f   ; la posicion del cursor
	ld hl,06ebdh		;6e82   ; "FOUND"
	call texto_pinta_hl		;6e85
	ld hl,0fac2h		;6e88   ; su nombre
	ld b,008h		;6e8b
cinta_busca_nombre:
	ld a,(hl)			;6e8d
	call letra_escribe		;6e8e
	inc hl			;6e91
	djnz cinta_busca_nombre		;6e92
	pop hl			;6e94
	push hl			;6e95
	ld a,020h		;6e96   ; el nombre pedido...
	ld b,008h		;6e98
cinta_busca_blanco:
	cp (hl)			;6e9a   ; ...en blanco?
	jr nz,cinta_busca_mira		;6e9b
	inc hl			;6e9d
	djnz cinta_busca_blanco		;6e9e
cinta_busca_si:
	xor a			;6ea0
cinta_busca_fin:
	pop hl			;6ea1
	ret			;6ea2
cinta_busca_mira:
	ld hl,0fac2h		;6ea3
	pop de			;6ea6
	push de			;6ea7
	ld b,008h		;6ea8
	call compara_b		;6eaa   ; el mismo?
	jr z,cinta_busca_si		;6ead
	ld hl,00f03h		;6eaf
	ld (0fa1dh),hl		;6eb2   ; la posicion del cursor
	ld hl,06ec4h		;6eb5   ; "SKIP"
	call texto_pinta_hl		;6eb8
	jr cinta_busca_uno		;6ebb

; ----------------------------------------------------------------------
; DATOS cinta_textos: "FOUND" y "SKIP", cada uno con su 0
;   0x6ebd..0x6eca  (13 bytes)
DATA_cinta_textos:
	defb 046h,04fh,055h,04eh,044h,020h,000h,053h,04bh,049h,050h,020h,000h	; 6ebd  FOUND .SKIP .

; ======================================================================
; CODIGO 0x6eca..0x6f32  (104 bytes)
; ======================================================================


casillas_fijas:		; Las casillas fijas del editor de fondos (salvo con un fondo): en el combate, los 0x88 bytes de 0x6F32 en los dibujos 0xAC0, lo que sigue a 0 (0x4B8), sus colores 0xF4 y los colores de las casillas 0x69-0x78 (1 a 15 de fondo); en el laberinto, los 0x40 bytes de 0x6FB2 cuatro veces desde 0xB78 y sus colores; a las tres partes (0x58B7)
	call tipo_11		;6eca   ; un fondo?
	ret z			;6ecd
	cp 020h		;6ece   ; laberinto?
	jr nc,casillas_fijas_lab		;6ed0
	ld hl,06f32h		;6ed2   ; los dibujos
	ld bc,00088h		;6ed5
	ld de,00ac0h		;6ed8
	push de			;6edb
	call ldirvm_mas		;6edc   ; LDIRVM
	ex de,hl			;6edf
	add hl,bc			;6ee0
	xor a			;6ee1
	ld bc,004b8h		;6ee2
	call 00056h		;6ee5   ; FILVRM
	pop hl			;6ee8
	set 5,h		;6ee9
	ld bc,00540h		;6eeb   ; sus colores
	ld a,0f4h		;6eee
	call 00056h		;6ef0   ; FILVRM
	ld hl,02b48h		;6ef3   ; los colores de las casillas de color
	ld a,001h		;6ef6   ; desde el 1
	ld de,00008h		;6ef8
casillas_fijas_color:
	push af			;6efb
	ld b,d			;6efc
	ld c,e			;6efd
	call 00056h		;6efe   ; FILVRM
	add hl,de			;6f01
	pop af			;6f02
	inc a			;6f03   ; el siguiente
	cp 010h		;6f04
	jr nz,casillas_fijas_color		;6f06
casillas_fijas_fin:
	ld hl,00203h		;6f08   ; a las tres partes
	jp casillas_copia		;6f0b
casillas_fijas_lab:
	ld de,00b78h		;6f0e   ; desde 0xB78
	ld bc,00040h		;6f11
	ld hl,06fb2h		;6f14   ; los dibujos del laberinto
	push de			;6f17
	ld a,004h		;6f18   ; cuatro veces
casillas_fijas_lab_uno:
	push af			;6f1a
	call ldirvm		;6f1b   ; LDIRVM
	ex de,hl			;6f1e
	add hl,bc			;6f1f
	ex de,hl			;6f20
	pop af			;6f21
	dec a			;6f22
	jr nz,casillas_fijas_lab_uno		;6f23
	pop hl			;6f25
	set 5,h		;6f26
	ld bc,00100h		;6f28   ; sus colores
	ld a,0f4h		;6f2b
	call 00056h		;6f2d   ; FILVRM
	jr casillas_fijas_fin		;6f30

; ----------------------------------------------------------------------
; DATOS casillas_dibujos: Los dibujos de las casillas fijas: el combate
;   (0x6F32, 0x88 bytes) y el laberinto (0x6FB2, 0x40)
;   0x6f32..0x6fda  (168 bytes)
DATA_casillas_dibujos:
	defb 027h,077h,0ffh,07fh,03fh,0fbh,0feh,0fch,0e4h,0eeh,0ffh,0feh,0fch,0dfh,07fh,03fh	; 6f32  'w..?..........?
	defb 0fch,0feh,0fbh,03fh,07fh,0ffh,077h,027h,03fh,07fh,0dfh,0fch,0feh,0ffh,0eeh,0e4h	; 6f42  ...?..w'?.......
	defb 0ffh,0dfh,0ffh,0ffh,0bfh,0ffh,0fbh,0ffh,0afh,096h,071h,06fh,09fh,0f6h,068h,08fh	; 6f52  ..........qo..h.
	defb 0ffh,0afh,0ffh,0fdh,0ffh,0efh,0fbh,0ffh,03ch,07eh,067h,0dah,05bh,0e6h,07eh,03ch	; 6f62  ........<~g.[.~<
	defb 001h,023h,007h,00fh,01fh,03fh,07fh,0ffh,080h,0c0h,0e0h,0b0h,0f8h,0ech,0feh,0dbh	; 6f72  .#...?..........
	defb 0ffh,06fh,03eh,01bh,04fh,006h,003h,001h,049h,092h,024h,048h,090h,020h,044h,080h	; 6f82  .o>.O...I.$H. D.
	defb 0cch,0cch,0cch,0cch,0cch,0cch,0cch,0cch,0aah,0aah,0aah,0aah,0aah,0aah,0aah,0aah	; 6f92  ................
	defb 0aah,055h,0aah,055h,0aah,055h,0aah,055h,0cch,033h,0cch,033h,0cch,033h,0cch,033h	; 6fa2  .U.U.U.U.3.3.3.3
	defb 0fbh,0fbh,0fbh,000h,0dfh,0dfh,0dfh,000h,000h,000h,000h,008h,008h,000h,000h,000h	; 6fb2  ................
	defb 06eh,0eeh,0eah,06ah,06ah,06eh,06eh,000h,0eeh,0eeh,0aah,02ah,04ah,0eeh,0eeh,000h	; 6fc2  n..jjnn....*J...
	defb 0eeh,02eh,02ah,0eah,02ah,02eh,0eeh,000h	; 6fd2  ..*.*...

; ======================================================================
; CODIGO 0x6fda..0x7170  (406 bytes)
; ======================================================================


programa:		; El programa: la pila en 0xF9F1, la VRAM preparada, 0xFA3B = 0x8100; busca el principio de la RAM (de 0xE000 hacia abajo, de 0x800 en 0x800, la primera que no se puede escribir) en 0xFA39 e IY; borde de color 4; 0x95DC; borra la partida (0x7117, 0x714C) y va al menu principal
	ld sp,0f9f1h		;6fda   ; la pila
	call vram_prepara		;6fdd
	ld hl,08100h		;6fe0   ; 0x8100
	ld (0fa3bh),hl		;6fe3   ; el puntero del azar
	ld hl,0e000h		;6fe6   ; desde 0xE000
programa_ram:
	ld a,(hl)			;6fe9   ; el byte...
	cpl			;6fea   ; ...dado la vuelta...
	ld (hl),a			;6feb   ; ...se escribe...
	cp (hl)			;6fec   ; ...y se lee: queda?
	ld a,h			;6fed
	jr nz,programa_ram_fin		;6fee   ; no: ahi no hay RAM
	sub 008h		;6ff0   ; 0x800 mas abajo
	ld h,a			;6ff2
	jr nc,programa_ram		;6ff3
programa_ram_fin:
	add a,008h		;6ff5   ; la ultima que si
	ld h,a			;6ff7
	ld (0fa39h),hl		;6ff8   ; el principio de la RAM
	push hl			;6ffb
	pop iy		;6ffc   ; tambien en IY
	ld a,004h		;6ffe   ; borde de color 4
	call borde_pon		;7000
	call presentacion		;7003
programa_nuevo:		; Borra la partida que hubiera (0x7117, 0x714C)
	call juego_borra		;7006   ; la partida a 0
	call juego_punteros		;7009
menu_principal_entra:		; Todo parado (0x4159), el buffer vacio, sin jugar (0xFA04), sin STOP, la pila de menus vacia (0xF8A8 en 0xFA27, 0xFA7B en 0xFA2D), los colores del texto, 0x9833 y el menu principal
	call todo_para		;700c   ; cursores, pantalla y cinta
	call buffer_inicio		;700f
	xor a			;7012   ; sin jugar...
	ld (0fa04h),a		;7013   ; jugando?
	ld (0fa06h),a		;7016   ; ...sin STOP...
	ld (0fa19h),a		;7019   ; la lista en pantalla
	ld hl,0f8a8h		;701c   ; la pila de menus vacia
	ld (0fa27h),hl		;701f   ; la pila de menus
	ld hl,0fa7bh		;7022
	ld (0fa2dh),hl		;7025   ; la cola de sonidos
	call texto_colores		;7028   ; los colores del texto
	call sonido_cero		;702b
	ld sp,0f9f1h		;702e   ; la pila otra vez
menu_principal:		; El menu 1 (jugar, hacer, arreglar, cargar o guardar el juego); con los bytes que siguen, el 5 (0x7034) y el 6 (0x7037): el fondo
	ld a,001h		;7031   ; el menu 1; desde 0x7034, el 5 y desde 0x7037, el 6
	ld bc,0053eh		;7033
	ld bc,0063eh		;7036
menu_y_opcion:		; El menu A y, despues, la rutina de la opcion elegida (0x7109)
	call menu		;7039
	jp menu_opcion		;703c
borde_pon:		; El color del borde (0xFA38) = A y al VDP
	ld (0fa38h),a		;703f   ; el color del borde (el de dibujar)
	jp vdp_7		;7042
menu_hacer:		; Hacer un juego: si ya hay uno, el aviso 8 (se borra con la barra; END vuelve); se borra todo y el menu 4 (de combate o de laberinto, a 0xF417) y el de su fondo (5 o 6)
	call juego_hay		;7045   ; hay juego?
	ld b,008h		;7048   ; el aviso 8
	call nz,aviso		;704a
menu_hacer_va:
	call juego_borra		;704d   ; la partida a 0
	call juego_punteros		;7050
	ld a,004h		;7053   ; el menu 4: que clase de juego
	call menu		;7055
	ld a,c			;7058
	ld (0f417h),a		;7059   ; 1 de combate, 2 de laberinto
	dec a			;705c
	jr nz,$-38		;705d   ; el menu 6 (0x7037)
	jr $-43		;705f   ; el menu 5 (0x7034)
menu_cargar:		; Cargar un juego de la cinta: si ya hay uno, el aviso 8; el nombre (menu 2, 8 letras en 0xF868) y la carga (0x6DD7): con C, se borra todo; con Z, al menu principal; si no, el aviso 0x14 (no se ha podido cargar) y otra vez
	call juego_hay		;7061
	ld b,008h		;7064
	call nz,aviso		;7066
menu_cargar_nombre:
	call juego_borra		;7069
	call juego_punteros		;706c
	ld a,002h		;706f   ; el menu 2: el nombre
	call nombre_pide		;7071
	ld hl,0f868h		;7074   ; el nombre escrito
	call juego_carga		;7077   ; de la cinta
	jp c,programa_nuevo		;707a   ; interrumpida: todo a 0
	jr z,menu_principal		;707d   ; cargado
	ld b,014h		;707f   ; "no se ha podido cargar"
	call aviso		;7081
	jr menu_cargar_nombre		;7084
menu_guardar:		; Guardar el juego en la cinta: el nombre (menu 8, 10 letras), a 0xFA49; si acaba en ",F", 0xFE72 = 0 (si no, 1); se graba (0x6D17) y despues el menu 0x0A (comprobar?): con "si", lo lee y lo compara (0x6E5C); si falla, el aviso 0x15
	ld a,008h		;7086
	ld c,00ah		;7088
	call nombre_pide_c		;708a   ; el nombre
	ld hl,0f868h		;708d
	push hl			;7090
	ld de,0fa49h		;7091
	ld bc,00008h		;7094   ; 8 letras...
	ldir		;7097   ; ...a 0xFA49
	ld b,001h		;7099
	ld a,(hl)			;709b
	cp 02ch		;709c   ; ","?
	jr nz,menu_guardar_graba		;709e
	inc hl			;70a0
	ld a,(hl)			;70a1
	cp 046h		;70a2   ; "F"?
	jr nz,menu_guardar_graba		;70a4
	dec b			;70a6
menu_guardar_graba:
	ld hl,0fe72h		;70a7   ; 0xFE72 = 1, o 0 con ",F"
	ld (hl),b			;70aa
	pop hl			;70ab
	call juego_graba		;70ac   ; a la cinta
	jr c,menu_guardar		;70af   ; interrumpido: otra vez
menu_comprueba:
	ld a,00ah		;70b1   ; el menu 0x0A: comprobar?
	call menu		;70b3
	dec c			;70b6   ; no: al menu principal
	jp nz,menu_principal		;70b7
	ld hl,0fa49h		;70ba
	call juego_compara		;70bd   ; lo que hay en la cinta, comparado
	jr c,menu_comprueba		;70c0   ; interrumpido: otra vez
	jp z,menu_principal		;70c2   ; igual
	ld b,015h		;70c5   ; "no se ha guardado bien"
	call aviso		;70c7
	jr menu_comprueba		;70ca
menu_arregla:		; Arreglar (opcion 3) o guardar (opcion 5) el juego: si no hay ninguno, el aviso 9; con la 3, 0xF9F2-0xF9F4 a 0 y el menu 0x0C (fondo, personajes, sonido o historia)
	call juego_hay		;70cc
	jr z,sin_juego		;70cf   ; no hay juego
	dec c			;70d1   ; la opcion 3?
	dec c			;70d2
	dec c			;70d3
	jr nz,menu_guardar		;70d4   ; no, la 5: guardar
	ld hl,0f9f2h		;70d6
	ld b,003h		;70d9
	call cero_b		;70db
	jp menu_arreglar		;70de   ; el menu 0x0C
sin_juego:		; El aviso 9 ("no hay juego") y al menu principal
	call cursor_apaga		;70e1
	ld b,009h		;70e4
	call aviso		;70e6
	jp menu_principal		;70e9
menu_jugar:		; Jugar: si no hay juego, el aviso 9; si no, la partida (0x880C)
	call juego_hay		;70ec
	jr z,sin_juego		;70ef
	jp partida		;70f1   ; a jugar
juego_hay:		; NZ si hay un juego hecho: el fondo (0xF418), 0xF420, 0xFA5D o 0xF41F
	ld a,(0f418h)		;70f4   ; el fondo (1 uno, 4 tres, 5-9 se desplaza)
	and a			;70f7
	ret nz			;70f8
	call historia_hay		;70f9
	ret nz			;70fc
	ld a,(0fa5dh)		;70fd   ; el registro del sonido
	and a			;7100
	ret nz			;7101
	ld a,(0f41fh)		;7102   ; cuantas fases hay
	and a			;7105
	ret			;7106
menu_opcion_1:		; La rutina de la primera opcion del menu (0xFA1A)
	ld c,001h		;7107
menu_opcion:		; La rutina de la opcion C del menu 0xFA1A (sus punteros en la tabla de registros de 0xB304)
	ld a,(0fa1ah)		;7109   ; el menu
	ld hl,0b304h		;710c   ; la tabla de los menus
	call registro		;710f   ; el registro del menu
	ld a,c			;7112
	dec a			;7113
	jp salta_tabla		;7114   ; a su rutina
juego_borra:		; Borra el juego: la RAM de abajo (desde 0xFA39 hasta 0xF380), 0xF417-0xF863, 0xF868-0xF91F y 0xF9F2-0xFA18; 0xFBD4 = 0, 0xFC40 = 32 sprites libres y 0x4CF1
	ld hl,(0fa39h)		;7117   ; el principio de la RAM
	push hl			;711a
	ld de,0f380h		;711b
	call cero_hasta		;711e
	ld hl,0f417h		;7121
	ld de,0f863h		;7124
	call cero_hasta		;7127
	ld hl,0f868h		;712a
	ld de,0f91fh		;712d
	call cero_hasta		;7130
	ld hl,0f9f2h		;7133
	ld de,0fa18h		;7136
	call cero_hasta		;7139
	ld (0fbd4h),a		;713c   ; ya preparado
	ld a,020h		;713f
	ld (0fc40h),a		;7141   ; los sprites libres
	call sprites_vacia		;7144
	pop hl			;7147
	ld (0fa39h),hl		;7148   ; el principio de la RAM
	ret			;714b
juego_punteros:		; Los punteros del juego: 0xF7C7-0xF7E8 con el principio de la RAM (0xFA39) y 0xF7F1-0xF37F... con 0xF37F
	ld bc,(0fa39h)		;714c   ; el principio de la RAM
	ld de,0f7e9h		;7150
	ld hl,0f7c7h		;7153
juego_punteros_uno:
	call bc_escribe		;7156
	rst 20h			;7159   ; DCOMPR
	jr c,juego_punteros_uno		;715a
	ld bc,0f37fh		;715c
	ld de,0f7f1h		;715f
juego_punteros_dos:
	call bc_escribe		;7162
	rst 20h			;7165   ; DCOMPR
	jr c,juego_punteros_dos		;7166
	ret			;7168
cero_hasta:		; Desde HL hasta DE (DCOMPR) a 0
	xor a			;7169
	ld (hl),a			;716a
	inc hl			;716b
	rst 20h			;716c   ; DCOMPR
	jr c,cero_hasta		;716d
	ret			;716f

; ----------------------------------------------------------------------
; DATOS sin_uso_7170: 14 bytes con pinta de codigo (ld a,(0xF418); ld c,1; dec
;   a; ret z; ...) que nadie llama ni salta: codigo muerto
;   0x7170..0x717e  (14 bytes)
DATA_sin_uso_7170:
	defb 03ah,018h,0f4h,00eh,001h,03dh,0c8h,04fh,0feh,004h,0d0h,00eh,004h,0c9h	; 7170  :....=.O......

; ======================================================================
; CODIGO 0x717e..0x7361  (483 bytes)
; ======================================================================


fondo_uno:		; El menu 5, opcion 1 (un fondo): con el juego de combate, 0xF418 = 1
	ld a,(0f417h)		;717e   ; la clase de juego (1 combate, 2 laberinto)
	dec a			;7181
	jr z,fondo_pon		;7182
fondo_tres:		; Tres fondos: 0xF418 = 4
	ld c,004h		;7184
fondo_pon:
	ld a,c			;7186
	jr fondo_tipo		;7187
fondo_scroll:		; El fondo que se desplaza: en el juego de combate, el menu 7 (con el protagonista o solo, en que sentido): 0xF418 = 5, 7 o 9; en el de laberinto, 5
	ld a,(0f417h)		;7189   ; la clase de juego (1 combate, 2 laberinto)
	dec a			;718c
	ld a,005h		;718d
	jr nz,fondo_tipo		;718f
fondo_scroll_menu:
	ld a,007h		;7191   ; el menu 7
	call menu		;7193
	ld a,c			;7196
	add a,a			;7197   ; x 2 + 3
	add a,003h		;7198
fondo_tipo:		; 0xF418 = A y la clase de juego en 0xF421: 0x11 (un fondo), 0x08 (tres) o 0x02 (que se desplaza), + 0x10 el de combate o + 0x40 el de laberinto; con 0x11, la RAM del fondo empieza en 0xEB7F
	ld (0f418h),a		;719a   ; el fondo (1 uno, 4 tres, 5-9 se desplaza)
	ld b,011h		;719d   ; 0x11: un fondo
	dec a			;719f
	jr z,fondo_tipo_pon		;71a0
	ld b,008h		;71a2   ; tres fondos: 8
	cp 003h		;71a4
	jr z,fondo_tipo_clase		;71a6
	ld b,002h		;71a8   ; desplazamiento: 2
	jr nc,fondo_tipo_clase		;71aa
fondo_tipo_clase:
	ld a,(0f417h)		;71ac   ; la clase de juego (1 combate, 2 laberinto)
	ld c,010h		;71af   ; + 0x10 el de combate...
	cp 002h		;71b1
	jr c,fondo_tipo_suma		;71b3
	ld c,040h		;71b5   ; ...o 0x40 el de laberinto
fondo_tipo_suma:
	ld a,c			;71b7
fondo_tipo_pon:
	add a,b			;71b8
	ld (0f421h),a		;71b9   ; la clase de juego
	cp 011h		;71bc   ; un fondo?
	jr nz,menu_arreglar		;71be
	ld hl,0eb7fh		;71c0   ; el fondo en 0xEB7F
	ld (0f7edh),hl		;71c3   ; el principio del mapa
	ld (0f7efh),hl		;71c6   ; el principio de las notas
	ld (0f7ebh),hl		;71c9   ; los dibujos de las casillas (RAM)
menu_arreglar:		; El menu 0x0C: que se hace (fondo, personajes, sonido, historia o acabar)
	ld a,00ch		;71cc
	jp menu_y_opcion		;71ce
historia_veces:		; El numero de 0xF41D (menu 0x0E): cuantas veces sale el protagonista (0x7F05, hasta 15)
	ld hl,0f41dh		;71d1
	ld a,00eh		;71d4
	ld b,00fh		;71d6
numero_pide:
	ld c,(hl)			;71d8   ; el de antes
	push hl			;71d9
	call numero_menu		;71da   ; el menu y su numero
	jr z,numero_pide_va		;71dd   ; 0
	call sonido_registro		;71df   ; el sonido
	ld c,001h		;71e2
numero_pide_va:
	pop hl			;71e4
	ld (hl),a			;71e5
	inc c			;71e6
	jp menu_opcion		;71e7
numero_otro:
	push hl			;71ea
	call nombre_nuevo		;71eb
	pop hl			;71ee
	ld (hl),a			;71ef
	jp menu_opcion_1		;71f0
historia_veces_b:
	ld a,00fh		;71f3
	ld hl,0f41dh		;71f5
	jr numero_otro		;71f8
historia_hay:		; 0xF420 (Z si no hay historia)
	ld a,(0f420h)		;71fa   ; cuantos personajes hay
	and a			;71fd
	ret			;71fe
historia_tiempo:		; El numero de 0xF41E (menu 0x11, hasta 0x21)
	ld hl,0f41eh		;71ff
	ld a,011h		;7202
	ld b,021h		;7204
	jr numero_pide		;7206
historia_tiempo_b:
	ld a,012h		;7208
	ld hl,0f41eh		;720a
	jr numero_otro		;720d
menu_texto:		; El menu A con un texto que se escribe (0x7D7F, 0x7F50) y su edicion (0x7F7D)
	ld (0fa1ah),a		;720f   ; el menu
	push bc			;7212
	push de			;7213
	push hl			;7214
	ld de,00004h		;7215   ; en la fila 4
	push bc			;7218
	call aviso_pinta		;7219   ; el aviso
	pop bc			;721c
	call hueco_pon		;721d   ; el hueco
	pop hl			;7220
	ld a,h			;7221   ; sin valor?
	or l			;7222
	jr z,menu_texto_va		;7223
	pop de			;7225
	pop bc			;7226
	push bc			;7227
	push de			;7228
	call texto_pinta_en		;7229   ; el valor
menu_texto_va:
	pop hl			;722c
	pop bc			;722d
texto_edita:		; Edita el texto de 0xF868 (0xFA0A a 0xFF mientras) y lo deja (0x7FDF)
	ld a,0ffh		;722e
	ld (0fa0ah),a		;7230   ; solo cifras
	call hueco_edita		;7233
	xor a			;7236
	ld (0fa0ah),a		;7237   ; solo cifras
	jp hueco_numero		;723a
texto_pinta_en:		; El texto de 0xF868 en la posicion DE (0x8015, 0x8054)
	ld (0fa1dh),de		;723d   ; la posicion del cursor
texto_pinta:
	push bc			;7241
	call numero_texto		;7242   ; a texto
	pop bc			;7245
	ld hl,0f868h		;7246   ; el texto
	ld b,c			;7249
	jp texto_pinta_b		;724a   ; pintado
vidas_menu:		; El numero de vidas (menu 0x14) en 0xF419 (0x7828)
	ld a,014h		;724d
	ld b,002h		;724f
	ld ix,0f419h		;7251
	jp numero_dos		;7255
vida_mas_menu:		; Los puntos para una vida mas (0xF41B, 4 cifras): si es 0, nada
	ld hl,(0f41bh)		;7258   ; los puntos de cada vida mas
	ld ix,0f41bh		;725b
	ld c,004h		;725f
	call hueco_pon		;7261
	ld c,001h		;7264
	ld a,l			;7266
	or h			;7267
	ret z			;7268
	ld c,004h		;7269
	jp nombre_pinta_hl		;726b
vida_mas_cero:
	ld (ix+000h),c		;726e
	ld (ix+001h),c		;7271
	jr historia_menu		;7274
vida_mas_pide:		; El menu 0x15 (una vida mas cada tantos puntos?): "no", 0; si no, el numero (0x761E)
	ld a,015h		;7276   ; el menu 0x15
	call menu		;7278
	dec c			;727b   ; "no"?
	jr z,vida_mas_cero		;727c
	ld c,004h		;727e   ; 4 cifras
	call tiempo_escribe		;7280   ; el numero
	ld (ix+001h),b		;7283   ; la parte alta
historia_menu:		; El menu 0x16 (la historia de las fases: nueva, arreglar, borrar o acabar) a 0xFA0C; la fase (menu 0x17) a 0xFA08: nueva (0x8592, 0x80EA con 0x5A bytes), borrar (0x814C) o arreglar
	ld a,016h		;7286   ; el menu 0x16
	call menu		;7288
	ld a,c			;728b   ; la opcion
	cp 004h		;728c   ; acabar?
	jp z,menu_arreglar		;728e
	ld (0fa0ch),a		;7291   ; guardada
historia_fase_menu:
	ld a,017h		;7294   ; el menu 0x17
	call menu		;7296
	ld a,(0fa0ch)		;7299   ; la opcion
	cp 002h		;729c   ; nueva, arreglar o borrar?
	ld a,c			;729e
	ld (0fa08h),a		;729f   ; la fase
	jr z,historia_arregla		;72a2
	jr nc,historia_borra		;72a4
	call fase_hay		;72a6   ; tiene datos?
	ld b,006h		;72a9   ; "ya existe"
	jr nz,historia_aviso		;72ab
	ld bc,0005ah		;72ad   ; 0x5A bytes
	call fase_nueva		;72b0   ; la fase nueva
	jr historia_fase		;72b3
historia_aviso:
	call aviso		;72b5
	jr historia_menu		;72b8
historia_borra:
	call fase_borra		;72ba
	jr historia_menu		;72bd
historia_arregla:
	call fase_hay		;72bf
	jr z,historia_menu		;72c2
	jr historia_fase		;72c4
marca_pon:		; La marca 0x2A delante de la opcion C (fila C x 2 + 1, columna 3)
	push bc			;72c6
	ld a,c			;72c7   ; la opcion...
	add a,a			;72c8   ; ...x 2 + 1: la fila
	inc a			;72c9
	ld b,a			;72ca
	ld c,003h		;72cb   ; la columna 3
	ld a,02ah		;72cd   ; la marca
	call letra_en_bc		;72cf   ; pintada
	pop bc			;72d2
	ret			;72d3
fases_marca:		; Marca las fases que tienen datos (de las 8 de 0xF7C7) y C = la primera (o 1)
	ld hl,0f7c7h		;72d4
	ld bc,00801h		;72d7
	ld e,000h		;72da
fases_marca_uno:
	push bc			;72dc
	call bc_lee		;72dd   ; el puntero
	inc hl			;72e0
	inc hl			;72e1
	push hl			;72e2
	call palabra_lee		;72e3   ; el siguiente
	call hl_igual_bc		;72e6   ; iguales: vacia
	pop hl			;72e9
	pop bc			;72ea
	jr z,fases_marca_sig		;72eb
	inc e			;72ed   ; la primera?
	dec e			;72ee
	jr nz,fases_marca_pon		;72ef
	ld e,c			;72f1   ; la primera con datos
fases_marca_pon:
	call marca_pon		;72f2
fases_marca_sig:
	inc c			;72f5   ; la siguiente
	djnz fases_marca_uno		;72f6
	ld c,e			;72f8   ; la primera
	ld a,c			;72f9
	and a			;72fa   ; ninguna?
	ret nz			;72fb
	inc c			;72fc   ; la 1
	ret			;72fd
campo_c:		; C = el byte +0x0C de la ficha de IY
	ld c,(iy+00ch)		;72fe
	ret			;7301
historia_fase:		; Despues de elegir la fase de la historia (0x857E): con tres fondos (0xF418 = 4), el menu 0x1A (que fondo, hasta los hechos en 0xFBFC) a +0x0C de IY; y el menu 0x2B
	call fase_iy		;7302   ; IY = la fase
	ld a,(0f418h)		;7305   ; el fondo
	cp 004h		;7308   ; tres?
	jr nz,menu_comportamiento		;730a   ; no: los comportamientos
historia_fondo:
	ld a,01ah		;730c   ; el menu 0x1A: que fondo
	call menu		;730e   ; el menu 0x1A
	ld a,(0fbfch)		;7311   ; los que hay
	inc a			;7314   ; + 1
	cp c			;7315   ; de los que hay?
	jr c,historia_fondo		;7316
	ld (iy+00ch),c		;7318   ; el elegido
menu_comportamiento:		; El menu 0x2B (movimientos, tiempo, sonidos o acabar)
	ld a,02bh		;731b   ; el menu 0x2B
	jp menu_y_opcion		;731d   ; y su opcion
movimiento_borde:		; Con menos de 5 en el fondo: el menu 0x37 (en el borde de la pantalla: pararse o salir por el otro lado) a +0 de IX; despues el menu 0x3F (sonido al moverse) y, con "no", +0 a 0
	ld a,(0f418h)		;7320   ; el fondo
	cp 005h		;7323   ; se desplaza?
	jr nc,menu_sonido_mueve		;7325
	ld a,037h		;7327   ; el menu 0x37
	call menu		;7329   ; el menu 0x37
	ld (ix+000h),c		;732c   ; pararse o salir por el otro lado
menu_sonido_mueve:		; El menu 0x3F (desde 0x7332, el 0x40: sonido al ser alcanzado); con "no", +0 de IX a 0; despues la rutina de la opcion
	ld a,03fh		;732f   ; el menu 0x3F; desde 0x7332, el 0x40
	ld bc,0403eh		;7331
	call menu		;7334   ; el menu
	ld a,c			;7337   ; "no"?
	dec a			;7338   ; "no"?
	jr nz,menu_sonido_va		;7339
	ld (ix+000h),a		;733b   ; a 0
menu_sonido_va:
	jp menu_opcion		;733e   ; la opcion
sonido_numero:		; El numero del sonido (menu 0x3A; desde 0x7344, el 0x3D) en +0 de IX, hasta 0x11
	ld a,03ah		;7341   ; el menu 0x3A; desde 0x7344, el 0x3D
	ld bc,03d3eh		;7343
numero_en_ix:
	push ix		;7346   ; el campo
	pop hl			;7348
	ld b,011h		;7349   ; hasta 17
	jp numero_pide		;734b   ; el numero
veces_numero:		; El numero de +0x24 de la ficha (0x7AA4, menu 0x24)
	call campo_fase		;734e   ; el campo de la fase
	ld a,024h		;7351   ; el menu 0x24
	jr numero_en_ix		;7353
veces_iy:		; El numero de +0x24 de IY con el menu 0x27
	ld a,027h		;7355   ; el menu 0x27
	ld de,00024h		;7357   ; +0x24 de la fase
	push iy		;735a
	pop hl			;735c
	add hl,de			;735d
	jp numero_otro		;735e   ; el numero

; ----------------------------------------------------------------------
; DATOS sin_uso_7361: 22 bytes que nadie lee
;   0x7361..0x7377  (22 bytes)
DATA_sin_uso_7361:
	defb 0cdh,04dh,07ah,00eh,001h,0ddh,07eh,000h,0a7h,0c8h,00ch,0c9h,0cdh,050h,07ah,018h	; 7361  .Mz...~......Pz.
	defb 0f2h,0cdh,053h,07ah,018h,0edh	; 7371

; ======================================================================
; CODIGO 0x7377..0x7478  (257 bytes)
; ======================================================================


personaje_lista:		; La lista de personajes (menu 0x31, 0x86F8): el de 0xF527 o el siguiente; y lo de 0x73F4
	ld a,(0f527h)		;7377   ; el protagonista
	ld c,001h		;737a   ; el primero
	dec a			;737c   ; el protagonista es el 1?
	jr z,personaje_lista_va		;737d
	inc c			;737f   ; si no, el 2
personaje_lista_va:
	ld a,031h		;7380   ; el menu 0x31
	ld b,011h		;7382   ; hasta 17
	call personaje_elige		;7384   ; de que personaje
	call personaje_igual		;7387   ; copiado
menu_quien:		; El menu 0x47: de que personaje se decide (el protagonista, su arma, el enemigo, su arma o acabar, en 0xFA13); el personaje (menu 0x2F, 0x86FB) en 0xFA12, su ficha (0x8102) y los menus de su clase: el protagonista, 0x748F; los demas, el menu 0x30 (nuevo o igual que otro) y, del enemigo, el 0x33 (mas fuerte o mas debil)
	ld a,047h		;738a   ; el menu 0x47
	call menu		;738c   ; el menu 0x47
	ld a,c			;738f   ; la opcion
	cp 005h		;7390   ; acabar?
	jp z,menu_comportamiento		;7392   ; acabar
	ld (0fa13h),a		;7395   ; cual
	dec a			;7398   ; el protagonista?
	jr nz,menu_quien_personaje		;7399   ; no
	ld a,(0f527h)		;739b   ; el protagonista
	dec a			;739e   ; el protagonista?
	jp nz,sin_personajes		;739f   ; no hay
menu_quien_personaje:
	ld a,02fh		;73a2   ; el menu 0x2F
	ld b,011h		;73a4   ; hasta 17
	ld (0fa1ah),a		;73a6   ; el menu
	ld a,(0fa13h)		;73a9   ; la clase de personaje
	ld c,001h		;73ac   ; el primero
	dec a			;73ae   ; el protagonista?
	jr z,menu_quien_ficha		;73af
	call personaje_elige_va		;73b1   ; elegir
	ld a,c			;73b4   ; el elegido
	dec a			;73b5   ; el 1?
	jr nz,menu_quien_ficha		;73b6
	ld a,(0f527h)		;73b8   ; el protagonista
	dec a			;73bb   ; el protagonista es el 1?
	jp z,ficha_usada		;73bc   ; si: "ya se usa"
menu_quien_ficha:
	ld a,c			;73bf
	ld (0fa12h),a		;73c0   ; el personaje
	call ficha_nueva		;73c3   ; su ficha
	ld a,(0fa13h)		;73c6   ; la clase de personaje
	dec a			;73c9   ; el protagonista?
	jp z,protagonista_sitio		;73ca   ; el protagonista: donde sale
	ld a,(iy+038h)		;73cd   ; ya hecho?
	dec a			;73d0   ; 1?
	jr z,menu_quien_clase		;73d1
	ld a,030h		;73d3   ; el menu 0x30
	call menu		;73d5   ; el menu 0x30
	dec c			;73d8   ; igual que otro?
	jr nz,personaje_lista		;73d9   ; igual que otro
menu_quien_clase:
	ld a,(0fa13h)		;73db   ; la clase de personaje
	cp 003h		;73de   ; el enemigo?
	jr c,$+8		;73e0   ; menos de 3: el arma
	jp nz,arma_puntos		;73e2   ; el arma del enemigo
	ld a,033h		;73e5   ; el menu 0x33; desde 0x73E8, el 0x32
	ld bc,0323eh		;73e7   ; el 0x32 (desde 0x73E8)
	call menu		;73ea   ; el menu
	dec c			;73ed   ; desde 0
	ld (ix+000h),c		;73ee   ; el elegido
	jp menu_opcion_1		;73f1   ; la primera opcion
personaje_igual:		; IGUAL QUE OTRO: copia los movimientos y los datos (0x2D bytes) de la ficha del personaje C en la de ahora, si es de la misma clase (0xFA13)
	push bc			;73f4
	ld a,c			;73f5
	call ficha_busca_a		;73f6   ; la ficha del otro
	pop bc			;73f9
	jr nc,personaje_igual_va		;73fa   ; esta
personaje_igual_no:
	pop hl			;73fc   ; fuera la vuelta
	jr menu_quien_clase		;73fd
personaje_igual_va:
	inc hl			;73ff   ; su clase
	ld a,(0fa13h)		;7400   ; la clase de personaje
	cp (hl)			;7403   ; de la misma clase?
	jr nz,personaje_igual_no		;7404   ; otra clase
	inc hl			;7406   ; sus datos
	push hl			;7407
	push bc			;7408
	call recorrido_quita		;7409   ; el recorrido de ahora, fuera
	pop bc			;740c
	ld hl,(0fa0eh)		;740d   ; el recorrido
	push hl			;7410   ; los datos del otro
	call recorrido_c		;7411   ; su recorrido
	pop hl			;7414
	ld a,(de)			;7415   ; cuantos puntos
	and a			;7416
	jr z,personaje_igual_datos		;7417   ; ninguno
	push af			;7419
	push hl			;741a
	inc de			;741b   ; los puntos
	inc hl			;741c
	push de			;741d
	push hl			;741e
	add a,a			;741f   ; x 8
	add a,a			;7420
	add a,a			;7421
	ld c,a			;7422
	ld b,000h		;7423
	call fase_pide		;7425   ; sitio en la fase
	pop de			;7428
	pop hl			;7429
	rst 20h			;742a   ; DCOMPR
	jr c,personaje_igual_copia		;742b   ; por delante?
	add hl,bc			;742d   ; se ha movido
personaje_igual_copia:
	ldir		;742e   ; copiados
	pop hl			;7430
	pop af			;7431
	ld (hl),a			;7432   ; cuantos
personaje_igual_datos:
	call ficha_busca		;7433   ; la ficha nueva
	inc hl			;7436   ; sus datos
	inc hl			;7437
	pop de			;7438
	ex de,hl			;7439
	ld bc,0002dh		;743a   ; 0x2D bytes
	ldir		;743d   ; copiados
	ret			;743f
tecla_numero:		; Espera una tecla (0xFA37 = A): la barra (0x0E) vuelve con Z, la de volver (0x0F) con C; los cursores (0x10-0x17) mueven el punto 0xFA1F (0x745A)
	ld (0fa37h),a		;7440   ; la clase de cursor
tecla_numero_bucle:
	call tecla_espera_texto		;7443   ; una tecla
	and 07fh		;7446   ; sin el bit 7
	cp 00eh		;7448   ; por debajo de la barra: nada
	jr c,tecla_numero_bucle		;744a
	ret z			;744c   ; la barra: Z
	cp 00fh		;744d   ; volver?
	scf			;744f
	ret z			;7450   ; C
	cp 018h		;7451   ; los cursores?
	jr nc,tecla_numero_bucle		;7453
	call punto_mueve		;7455   ; el punto se mueve
	jr tecla_numero_bucle		;7458
punto_mueve:		; El punto 0xFA1F se mueve en la direccion de la tecla (0xB156) dentro de los limites de 0xFA51 (0x95B2)
	ld bc,(0fa1fh)		;745a   ; el punto
	ld hl,0b156h		;745e   ; los pasos de cada direccion
	sub 010h		;7461   ; la direccion
	call tabla_puntero		;7463   ; el paso
	ld a,l			;7466   ; + X
	add a,c			;7467
	ld c,a			;7468
	ld a,h			;7469   ; + Y
	add a,b			;746a
	ld b,a			;746b
	ld hl,0fa51h		;746c   ; los limites
	call zona_dentro		;746f   ; dentro?
	ret c			;7472   ; no
	ld (0fa1fh),bc		;7473   ; el punto
	ret			;7477   ; hecho

; ----------------------------------------------------------------------
; DATOS sin_uso_7478: Tres bytes (0x3E 0x09 0x01) que nadie lee ni salta
;   0x7478..0x747b  (3 bytes)
DATA_sin_uso_7478:
	defb 03eh,009h,001h	; 7478

; ======================================================================
; CODIGO 0x747b..0x7589  (270 bytes)
; ======================================================================


sonido_uno:		; 0x8388 con A = 6
	ld a,006h		;747b   ; el sprite 6
	jp sprite_en		;747d
aviso_y_pantalla:		; El aviso B en el menu A, la pantalla limpia, 0x8967 (el fondo), SCREEN 2 y la ficha (0x8553)
	call aviso_menu		;7480   ; el aviso
	call pantalla_texto_limpia		;7483   ; la pantalla limpia
	call fondo_pinta		;7486   ; el fondo
	call graficos_entra_guarda		;7489   ; SCREEN 2
	jp ficha_busca		;748c   ; la ficha
protagonista_sitio:		; El aviso 0x13 (donde sale el personaje), 0x85A1 y la primera opcion
	ld a,034h		;748f
	ld bc,0433eh		;7491   ; desde 0x7492, el 0x43
	ld b,013h		;7494   ; el aviso 0x13
	call aviso_y_pantalla		;7496
	call sitio_elige		;7499   ; la zona
	jp menu_opcion_1		;749c   ; la primera opcion
movimiento_tres:		; +1 de IX = 3 y sigue en 0x74AD
	ld (ix+001h),003h		;749f   ; la clase 3
	jr $+13		;74a3   ; al aviso
movimiento_rapidez:		; El menu 0x36 (como se mueve) a +0 de IX; despues, con los bytes que siguen, el aviso 0x0A (0x74B0: velocidad), y desde 0x74B3 o 0x74B6 otros menus; la pantalla de la velocidad: el personaje se mueve en un recorrido y las teclas cambian la velocidad (+0x1B, 1-0x40) y el paso (+0x21)
	ld a,036h		;74a5   ; el menu 0x36
	call menu		;74a7
	ld (ix+000h),c		;74aa   ; como se mueve
	ld a,039h		;74ad   ; el menu 0x39; desde 0x74B0, 0x50; desde 0x74B3, 0x5C; desde 0x74B6, 0x64
	ld bc,0503eh		;74af
	ld bc,05c3eh		;74b2
	ld bc,0643eh		;74b5
	ld b,00ah		;74b8   ; el aviso 0x0A
	call aviso_y_pantalla		;74ba   ; el aviso, la pantalla y la ficha
	call recorrido_busca		;74bd   ; el recorrido
	call sprites_tabla_76		;74c0   ; los sprites de abajo
	call sprites_fuera_guarda		;74c3   ; fuera
	ld a,001h		;74c6   ; fondo de color 1
	ld (0fa35h),a		;74c8   ; el color de fondo de las letras
	call texto_colores		;74cb   ; los colores
	ld de,00c16h		;74ce   ; "SPEED"
	ld hl,07589h		;74d1   ; "SPEED"
	call texto_en		;74d4
	ld de,00e16h		;74d7   ; "STEP"
	ld hl,0758fh		;74da   ; "STEP"
	call texto_en		;74dd
	ld bc,06408h		;74e0   ; en Y 0x64, X 8
	ld a,003h		;74e3   ; el dibujo 3
	call dibujo_pon		;74e5   ; el personaje
	ld hl,(0fa31h)		;74e8   ; el reloj
	ld (ix+01ch),l		;74eb   ; su reloj
	ld (ix+01dh),h		;74ee
	ld a,0feh		;74f1   ; sonando
	ld (0fa16h),a		;74f3   ; la muestra en marcha
rapidez_bucle:
	ld l,(ix+01bh)		;74f6   ; la velocidad
	ld h,000h		;74f9   ; la velocidad
	ld de,00c1ch		;74fb   ; fila 0x0C, columna 0x1C
	ld c,002h		;74fe   ; 2 cifras
	call texto_pinta_en		;7500
	ld l,(ix+021h)		;7503   ; el paso
	ld h,000h		;7506   ; el paso
	ld de,00e1ch		;7508   ; fila 0x0E
	ld c,002h		;750b   ; 2 cifras
	call texto_pinta_en		;750d
	call tecla_espera		;7510   ; una tecla
	and 03fh		;7513   ; sin los bits de arriba
	cp 00fh		;7515   ; volver?
	jr c,rapidez_bucle		;7517   ; por debajo: otra vez
	jr z,rapidez_fin		;7519
	cp 010h		;751b   ; arriba?
	jr z,rapidez_menos		;751d
	cp 014h		;751f   ; abajo?
	jr z,rapidez_mas		;7521
	cp 012h		;7523   ; izquierda?
	jr z,paso_sube		;7525
	cp 016h		;7527   ; derecha?
	jr nz,rapidez_bucle		;7529
	jr paso_menos		;752b
rapidez_fin:
	call sprites_fuera_guarda		;752d   ; los sprites fuera
	call muestra_para		;7530   ; sin la muestra
	jp menu_opcion_1		;7533   ; la primera opcion
rapidez_menos:
	ld b,0ffh		;7536   ; uno menos
	jr rapidez_cambia		;7538
rapidez_mas:
	ld b,001h		;753a   ; uno mas
rapidez_cambia:
	ld a,(ix+01bh)		;753c   ; la velocidad
	add a,b			;753f
	jr z,rapidez_bucle		;7540   ; 0: no
	jp m,rapidez_bucle		;7542   ; negativa: no
	cp 041h		;7545   ; hasta 0x40
	jr nc,rapidez_bucle		;7547   ; 0x41 o mas: no
	ld (ix+01bh),a		;7549   ; la nueva
	jr rapidez_bucle		;754c
paso_menos:
	ld b,000h		;754e   ; la mitad
	jr paso_cambia		;7550
paso_sube:
	ld b,001h		;7552   ; el doble
paso_cambia:
	ld a,(ix+021h)		;7554   ; el paso
	dec b			;7557   ; doble?
	jr z,paso_dobla		;7558
	and a			;755a   ; 0?
	jr z,paso_pon		;755b
	srl a		;755d   ; la mitad
paso_pon:
	ld (ix+021h),a		;755f   ; el nuevo
	ld hl,(0fa0eh)		;7562   ; el recorrido
	ld a,(hl)			;7565   ; cuantos puntos
	inc hl			;7566   ; el primero
paso_recorrido:
	cp 002h		;7567   ; dos o mas?
	jr c,rapidez_bucle		;7569
	push af			;756b
	push hl			;756c
	call tramo_calcula		;756d   ; el tramo, con el paso nuevo
	pop hl			;7570
	ld a,008h		;7571   ; el siguiente punto
	call hl_mas_a		;7573
	pop af			;7576
	dec a			;7577   ; uno menos
	jr paso_recorrido		;7578
paso_dobla:
	and a			;757a   ; 0?
	jr z,paso_uno		;757b
	add a,a			;757d   ; el doble
	cp 011h		;757e   ; mas de 16?
	jr c,paso_pon		;7580
	ld a,010h		;7582   ; 16
	jr paso_pon		;7584
paso_uno:
	inc a			;7586   ; 1
	jr paso_pon		;7587

; ----------------------------------------------------------------------
; DATOS rapidez_textos: "SPEED" y "STEP" con su 0
;   0x7589..0x7594  (11 bytes)
DATA_rapidez_textos:
	defb 053h,050h,045h,045h,044h,000h,053h,054h,045h,050h,000h	; 7589  SPEED.STEP.

; ======================================================================
; CODIGO 0x7594..0x78fc  (872 bytes)
; ======================================================================


texto_en:		; El texto de HL en la posicion DE (0xFA1D)
	ld (0fa1dh),de		;7594   ; la posicion del cursor
	jp texto_pinta_hl		;7598   ; el texto
sonando_no:		; 0xFA03 a 0 (guardando AF)
	push af			;759b
	xor a			;759c   ; 0
	ld (0fa03h),a		;759d   ; lo que pasa al moverse
	pop af			;75a0
	ret			;75a1
sonido_elige_a:		; 0x7A4D y el numero (menu 0x3B) en IX
	call campo_lee_04		;75a2   ; +4 de la ficha
	ld a,03bh		;75a5   ; el menu 0x3B
	jr numero_ix		;75a7
sonido_elige_b:		; 0x7A50 y el numero (menu 0x3E) en IX
	call campo_lee_0a		;75a9   ; +0x0A
	ld a,03eh		;75ac   ; el menu 0x3E
numero_ix:
	push ix		;75ae
	pop hl			;75b0
	jp numero_otro		;75b1   ; el numero
vencido_dibujo:		; El menu 0x41 (sale un dibujo al ser alcanzado?): "no", +0 de IX a 0 (y el personaje que se usaba se suelta); "si", el personaje (menu 0x3C) se crea con la clase 5 y sus datos de partida
	ld a,041h		;75b4   ; el menu 0x41
	call menu		;75b6   ; el menu 0x41
	dec c			;75b9   ; "si"?
	jr nz,vencido_nuevo		;75ba   ; "si"
	ld a,(ix+000h)		;75bc   ; el de antes
	ld (ix+000h),c		;75bf   ; a 0
	and a			;75c2
	jr z,vencido_fin		;75c3   ; ninguno
	ld (0fa12h),a		;75c5   ; el personaje
	call ficha_busca_a		;75c8   ; su ficha
	call ficha_quita		;75cb   ; fuera
vencido_fin:
	jp menu_quien		;75ce   ; el menu de quien
vencido_nuevo:
	ld a,03ch		;75d1   ; el menu 0x3C
	ld b,011h		;75d3
	ld c,(ix+000h)		;75d5   ; el de antes
	inc c			;75d8
	dec c			;75d9
	jr nz,vencido_crea		;75da   ; tenia
	inc c			;75dc   ; si no, el 1
vencido_crea:
	call personaje_elige		;75dd   ; cual
	push ix		;75e0
	push bc			;75e2
	ld a,005h		;75e3   ; la clase 5
	ld (0fa13h),a		;75e5   ; la clase de personaje
	ld a,c			;75e8   ; el personaje
	call ficha_nueva		;75e9   ; su ficha
	pop bc			;75ec
	pop hl			;75ed
	ld (hl),c			;75ee   ; apuntado
	ld (ix+001h),005h		;75ef   ; la clase 5
	ld (ix+000h),c		;75f3   ; el personaje
	ld (ix+007h),002h		;75f6   ; +7 = 2
	ld (ix+01bh),004h		;75fa   ; la velocidad 4
	ld (ix+01eh),011h		;75fe   ; el movimiento 0x11 (quieto)
	jp menu_quien		;7602   ; el menu de quien
nombre_pinta_a:		; El texto A (H = 0) en la fila 5, columna 4
	ld l,a			;7605   ; el numero
	ld h,000h		;7606
nombre_pinta_hl:
	push hl			;7608
	ld de,00504h		;7609   ; fila 5, columna 4
	and a			;760c   ; 0?
	jr z,nombre_pinta_fin		;760d
	call texto_pinta_en		;760f   ; escrito
	ld c,002h		;7612   ; 2 cifras
nombre_pinta_fin:
	pop hl			;7614
	ret			;7615
tiempo_ix:		; +0 de IX = C - 1; si no es 0, el numero (0x761E)
	ld a,c			;7616   ; la opcion
	dec a			;7617   ; - 1
	ld (ix+000h),a		;7618   ; al campo
	ret z			;761b   ; "no": 0
	ld c,002h		;761c   ; 2 cifras
tiempo_escribe:		; Escribe un numero de 2 cifras en la fila 5, columna 4, a +0 de IX
	ld hl,00504h		;761e   ; fila 5, columna 4
	call texto_edita		;7621   ; se escribe
	ld (ix+000h),c		;7624   ; al campo
	ret			;7627
movimiento_menu:		; El menu de los movimientos: 0x44 (el de combate) o 0x49 (laberinto) y lo elegido + 4 o + 0x0D a +0 de IX (0x764E); con el 7, +1 = 5
	ld a,(0f417h)		;7628   ; la clase de juego
	dec a			;762b   ; combate?
	jr z,movimiento_menu_44		;762c
	ld a,049h		;762e   ; el menu 0x49
	call menu		;7630   ; el menu 0x49
	ld b,00dh		;7633   ; + 0x0D
	jr movimiento_menu_va		;7635
movimiento_menu_44:
	ld a,044h		;7637   ; el menu 0x44
	call menu		;7639   ; el menu 0x44
	ld b,004h		;763c   ; + 4
movimiento_menu_va:
	ld e,005h		;763e   ; el recorrido: el 5
	call campo_cambia		;7640   ; al campo
	cp 007h		;7643   ; la opcion 7?
	jr nz,movimiento_menu_fin		;7645
	ld (ix+001h),005h		;7647   ; +1 = 5
movimiento_menu_fin:
	jp menu_opcion		;764b   ; la opcion
campo_cambia:		; +0 de IX = C + B; si cambia y era E, 0x86A7 (se borra el recorrido); +1 y +2 a 0
	ld a,c			;764e   ; la opcion...
	add a,b			;764f   ; ...+ B
	ld b,a			;7650
	ld a,(ix+000h)		;7651   ; el de antes
	ld (ix+000h),b		;7654   ; el nuevo
	cp b			;7657   ; igual?
	ret z			;7658
	cp e			;7659   ; era el recorrido?
	jr nz,campo_cambia_va		;765a
	push bc			;765c
	call recorrido_quita		;765d   ; se borra
	pop bc			;7660
campo_cambia_va:
	ld (ix+001h),000h		;7661   ; +1 a 0
	ld (ix+002h),000h		;7665   ; +2 a 0
	ld a,b			;7669   ; el nuevo
	ret			;766a
rapidez_menu:		; El menu 0x45 (desde 0x766E el 0x46, desde 0x7671 el 0x63): la rapidez a +0 de IX
	ld a,045h		;766b
	ld bc,0463eh		;766d   ; desde 0x766E, el 0x46; desde 0x7671, el 0x63
	ld bc,0633eh		;7670
	call menu		;7673   ; el menu
	ld (ix+000h),c		;7676   ; la rapidez
	jp menu_opcion_1		;7679   ; la primera opcion
recorrido_pinta:		; El recorrido del personaje (0x86BB): sus puntos (de 8 en 8) desde la posicion de la casilla 0x860
	call recorrido_busca		;767c   ; el recorrido
	ld (ix+01fh),e		;767f   ; a la ficha
	ld (ix+020h),d		;7682
	ld (0fa29h),hl		;7685   ; donde se escribe
	ld hl,00860h		;7688   ; desde la casilla 0x860
	ld a,(de)			;768b   ; cuantos puntos
	and a			;768c
	ret z			;768d   ; ninguno
	ex de,hl			;768e
	inc hl			;768f   ; el primero
	push af			;7690
	push hl			;7691
	call muestra_mueve_otra		;7692   ; la marca
	pop hl			;7695
	pop af			;7696
	dec a			;7697   ; el ultimo...
	add a,a			;7698   ; ...x 8
	add a,a			;7699
	call tabla_salta		;769a   ; su sitio
	jp palabra_lee		;769d   ; HL = el ultimo
limites_pon:		; Los limites del punto (0xFA51): 0, 0 y 0x9D8D...; con el fondo de menos de 2, 0x10 mas
	ld de,09d8dh		;76a0   ; los limites: 0, 0 a 0x8D, 0x9D
	ld hl,0fa51h		;76a3   ; 0xFA51
	xor a			;76a6   ; 0...
	ld (hl),a			;76a7
	inc hl			;76a8
	ld (hl),a			;76a9   ; ...0
	inc hl			;76aa
	ld (hl),e			;76ab   ; ...0x8D...
	inc hl			;76ac
	ld (hl),d			;76ad   ; ...0x9D
	push hl			;76ae
	call personaje_forma_lee		;76af   ; la forma
	ld b,a			;76b2
	cp 002h		;76b3   ; dos de alto?
	pop hl			;76b5
	jr nc,limites_fin		;76b6
	call limites_suma		;76b8   ; 16 mas
limites_fin:
	dec hl			;76bb   ; el otro
	bit 0,b		;76bc   ; dos de ancho?
	ret nz			;76be
limites_suma:
	ld a,010h		;76bf   ; 16 mas
	add a,(hl)			;76c1
	ld (hl),a			;76c2
	ret			;76c3
recorrido_edita:		; EL RECORRIDO (movimiento por la ruta, menu 0x44 opcion 1): el aviso 0x17, los limites, el recorrido, el personaje en el punto de partida con sus colores; las teclas: cursores mueven el +, la barra apunta un punto (0x776C), la tecla de borrar quita el ultimo (0x77AA); volver
	ld a,048h		;76c4   ; el aviso 0x17
	ld b,017h		;76c6   ; el aviso 0x17
	call aviso_y_pantalla		;76c8   ; la pantalla
	call limites_pon		;76cb   ; los limites
	call recorrido_pinta		;76ce   ; el recorrido
	ld bc,00303h		;76d1   ; el ultimo punto - 3
	and a			;76d4
	sbc hl,bc		;76d5
	ld (0fa1fh),hl		;76d7   ; el punto
	ld a,009h		;76da   ; la clase de cursor 9
	ld (0fa37h),a		;76dc   ; la clase de cursor
	call sprites_tabla_76		;76df   ; los sprites de abajo
	call personaje_ficha		;76e2   ; el personaje
	ld de,0000bh		;76e5   ; +0x0B
	add hl,de			;76e8
	ld a,(hl)			;76e9   ; su dibujo
	and 0fch		;76ea   ; sin los 2 bits de abajo
	ld hl,03b02h		;76ec   ; en la tabla de atributos
	ld e,000h		;76ef   ; desde el sprite 0
	ld d,a			;76f1
recorrido_sprite_busca:
	call 0004ah		;76f2   ; RDVRM: su dibujo
	cp d			;76f5   ; este?
	jr z,recorrido_sprite		;76f6
	inc e			;76f8   ; el siguiente
	inc hl			;76f9
	inc hl			;76fa
	inc hl			;76fb
	inc hl			;76fc
	ld a,e			;76fd
	cp 020h		;76fe   ; 32?
	jr c,recorrido_sprite_busca		;7700   ; los 32?
recorrido_sprite:
	ld hl,03b00h		;7702   ; la tabla de atributos
	inc e			;7705   ; encontrado?
	dec e			;7706
	jr nz,recorrido_sprite_va		;7707
	ld hl,03b10h		;7709   ; si no, el sprite 4
recorrido_sprite_va:
	push hl			;770c
	ld (0fa41h),hl		;770d   ; apuntado
	push bc			;7710
	ld bc,00004h		;7711   ; 4 bytes
	ld de,0fa43h		;7714   ; guardados en 0xFA43
	call ldirmv_mas		;7717   ; LDIRMV
	pop bc			;771a
	pop hl			;771b
	ld hl,(0fa31h)		;771c   ; el reloj
	ld (ix+01ch),l		;771f   ; el reloj de la ficha
	ld (ix+01dh),h		;7722
	ld a,0ffh		;7725   ; sonando
	ld (0fa16h),a		;7727   ; la muestra en marcha
recorrido_bucle:
	call tecla_espera_texto		;772a   ; una tecla
	and 03fh		;772d   ; sin los bits de arriba
	cp 006h		;772f   ; la de borrar?
	jr c,recorrido_bucle		;7731   ; por debajo de 6: nada
	jr z,recorrido_borra		;7733   ; 6: borrar
	cp 00eh		;7735   ; la barra?
	jr c,recorrido_bucle		;7737   ; por debajo de la barra: nada
	jr z,recorrido_apunta		;7739   ; la barra
	cp 00fh		;773b   ; volver?
	jr z,recorrido_fin		;773d   ; volver
	cp 018h		;773f   ; un cursor?
	jr nc,recorrido_bucle		;7741   ; no es un cursor
	call punto_mueve		;7743   ; el punto se mueve
	jr recorrido_bucle		;7746
recorrido_borra:
	call punto_quita		;7748   ; el ultimo fuera
	jr recorrido_bucle		;774b
recorrido_apunta:
	call punto_apunta		;774d   ; uno mas
	jr recorrido_bucle		;7750
recorrido_fin:
	call sprites_fuera_guarda		;7752   ; los sprites fuera
	call muestra_para		;7755   ; sin la muestra
	jp rapidez_aviso_50		;7758   ; el aviso de la velocidad
tiempo_menu:		; El menu 0x4C (desde 0x775E el 0x5D, desde 0x7761 el 0x65: cuanto tarda en desaparecer) y el tiempo (0x7616)
	ld a,04ch		;775b
	ld bc,05d3eh		;775d   ; desde 0x775E el 0x5D; desde 0x7761 el 0x65
	ld bc,0653eh		;7760
	call menu		;7763   ; el menu
	call tiempo_ix		;7766   ; el tiempo
	jp menu_opcion_1		;7769   ; la primera opcion
punto_apunta:		; Apunta el punto 0xFA1F en el recorrido (hasta 31): uno mas en la cuenta, su sitio (0x8682) y la marca; la linea desde el anterior (0x945D)
	ld hl,(0fa0eh)		;776c   ; el recorrido
	ld a,(hl)			;776f   ; cuantos puntos
	cp 01fh		;7770   ; 31 como mucho
	ret nc			;7772   ; 31: no caben
	inc (hl)			;7773   ; uno mas
	call fase_siguiente		;7774   ; el puntero de la siguiente fase
	ld hl,(0fa29h)		;7777   ; donde se escribe
	push hl			;777a   ; donde va
	ld bc,00008h		;777b   ; 8 bytes
	call ram_pide		;777e   ; sitio
	push hl			;7781
	push bc			;7782
	call punteros_suma		;7783   ; los punteros movidos
	pop bc			;7786
	pop hl			;7787
	add hl,bc			;7788   ; el siguiente
	ld (0fa29h),hl		;7789   ; donde se escribe
	pop hl			;778c
	ld bc,(0fa1fh)		;778d   ; el punto
	inc b			;7791   ; la Y + 3
	inc b			;7792
	inc b			;7793
	inc c			;7794   ; la X + 3
	inc c			;7795
	inc c			;7796
	call bc_escribe		;7797   ; el punto
	ld (hl),0ffh		;779a   ; el final
	ld bc,(0fa0eh)		;779c   ; el recorrido
	ld a,(bc)			;77a0   ; cuantos
	dec a			;77a1
	ret z			;77a2   ; el primero: nada mas
	ld bc,0fff6h		;77a3   ; el anterior
	add hl,bc			;77a6
	jp tramo_calcula		;77a7   ; el tramo
punto_quita:		; Quita el ultimo punto del recorrido
	ld hl,(0fa0eh)		;77aa   ; el recorrido
	ld a,(hl)			;77ad   ; cuantos
	and a			;77ae   ; ninguno?
	ret z			;77af   ; ninguno
	dec (hl)			;77b0   ; uno menos
	push af			;77b1
	call fase_siguiente		;77b2   ; el puntero de la siguiente
	ld hl,(0fa29h)		;77b5   ; donde se escribe
	ld bc,00008h		;77b8   ; 8 bytes
	and a			;77bb
	sbc hl,bc		;77bc   ; el anterior
	ld (0fa29h),hl		;77be   ; donde se escribe
	push hl			;77c1
	call ram_quita		;77c2   ; fuera
	call punteros_resta		;77c5   ; los punteros movidos
	pop hl			;77c8
	dec hl			;77c9   ; 6 atras: el final del anterior
	dec hl			;77ca
	dec hl			;77cb
	dec hl			;77cc
	dec hl			;77cd
	dec hl			;77ce
	pop af			;77cf
	ret z			;77d0   ; no quedan
	ld (hl),0ffh		;77d1   ; el final
	ret			;77d3
dibujo_direccion:		; El dibujo de la direccion C del personaje (+0x0B de su ficha): si no tiene, el de al lado
	ld de,0000bh		;77d4   ; +0x0B: los dibujos de cada direccion
	push bc			;77d7
	ld a,(ix+000h)		;77d8   ; el personaje
	push hl			;77db
	call personaje_ficha_a		;77dc   ; su registro
	add hl,de			;77df   ; sus dibujos
	pop bc			;77e0
	push hl			;77e1
	ld a,c			;77e2   ; la direccion
	call hl_mas_a		;77e3   ; su dibujo
	ld a,(hl)			;77e6   ; tiene?
	inc a			;77e7
	jr nz,dibujo_direccion_fin		;77e8   ; si
	ld a,c			;77ea   ; la direccion
	inc hl			;77eb   ; la siguiente...
	inc c			;77ec
	rrca			;77ed   ; ...si es par...
	jr nc,dibujo_direccion_va		;77ee
	dec hl			;77f0   ; ...si no, la anterior
	dec hl			;77f1
	dec c			;77f2
	dec c			;77f3
dibujo_direccion_va:
	ld a,(hl)			;77f4   ; su dibujo
	inc a			;77f5   ; Z si no tiene
dibujo_direccion_fin:
	ld l,c			;77f6   ; L = la direccion
	pop de			;77f7
	pop bc			;77f8
	ret			;77f9
arma_tecla:		; El menu 0x5B (con que boton se dispara: 1 o barra, 2 o RETURN) a +0 de IX y 0x7855
	ld a,05bh		;77fa   ; el menu 0x5B
	call menu		;77fc
	ld (ix+000h),c		;77ff   ; el boton
	jr arma_movimiento		;7802   ; como se mueve
borde_menu:		; Con menos de 5 en el fondo, el menu 0x4D (en el borde: pararse, salir por el otro lado o desaparecer) a +0 de IX (salvo los movimientos 5 y 0x11); despues 0x7A93 y el numero del menu 0x53
	ld a,(0f418h)		;7804   ; el fondo (1 uno, 4 tres, 5-9 se desplaza)
	cp 005h		;7807   ; se desplaza?
	jr nc,borde_menu_va		;7809
	call campo_c_lee		;780b   ; +0x1E
	ld a,(ix+000h)		;780e   ; el movimiento
	cp 005h		;7811   ; el recorrido?
	jr z,borde_menu_va		;7813
	cp 011h		;7815   ; quieto?
	jr z,borde_menu_va		;7817
	ld a,04dh		;7819   ; el menu 0x4D
	call menu		;781b
	ld (ix+000h),c		;781e   ; pararse, salir por el otro lado o desaparecer
borde_menu_va:
	call campo_c_17		;7821   ; +0x17
	ld a,053h		;7824   ; el menu 0x53
	ld b,019h		;7826   ; el aviso 0x19
numero_dos:		; Un numero de C cifras (menu A, aviso B) en la fila 2, columna 4, a +0 y +1 de IX
	ld c,002h		;7828   ; 2 cifras
	ld h,000h		;782a
numero_dos_va:
	ld l,(ix+000h)		;782c   ; el valor de antes
	ld de,00204h		;782f   ; fila 2, columna 4
	call menu_texto		;7832   ; se escribe
	ld (ix+000h),c		;7835   ; el numero
	ld (ix+001h),b		;7838
	jp menu_opcion_1		;783b   ; la primera opcion
puntos_menu:		; Los puntos del personaje (menu 0x6C, aviso 3)
	call campo_fase_13		;783e   ; +0x13 de la fase
	ld a,06ch		;7841   ; el menu 0x6C
	ld b,003h		;7843   ; el aviso 3
	jr numero_tres		;7845
salida_menu:		; Cada cuantos segundos sale (menu 0x67, aviso 0x1A)
	call campo_c_05		;7847   ; +5
	ld a,067h		;784a   ; el menu 0x67
	ld b,01ah		;784c   ; el aviso 0x1A
numero_tres:
	ld c,003h		;784e   ; 3 cifras
	ld h,(ix+001h)		;7850   ; la parte alta
	jr numero_dos_va		;7853
arma_movimiento:		; El menu 0x55 (como se mueve el arma) a +0 de IX (0x764E); con el recorrido (opcion 1), el aviso 0x18 y el punto de destino
	ld a,055h		;7855   ; el menu 0x55
	call menu		;7857
	ld e,012h		;785a   ; el recorrido: el 0x12
	ld b,011h		;785c   ; + 0x11
	call campo_cambia		;785e   ; al campo
	dec c			;7861   ; hacia un sitio?
	jr z,arma_destino		;7862
	jp rapidez_aviso_5c		;7864   ; el aviso de la velocidad
arma_destino:
	ld a,056h		;7867   ; el menu 0x56
	ld b,018h		;7869   ; el aviso 0x18
	call aviso_y_pantalla		;786b   ; la pantalla
	call limites_pon		;786e   ; los limites
	call recorrido_pinta		;7871   ; el recorrido
	ld (0fa1fh),hl		;7874   ; el punto
arma_destino_espera:
	ld a,009h		;7877   ; la clase de cursor 9
	call tecla_numero		;7879   ; mueve el punto
	jr nc,arma_destino_espera		;787c   ; hasta la barra
arma_destino_pon:
	call recorrido_nuevo		;787e   ; un recorrido nuevo
	ld hl,(0fa0eh)		;7881   ; el recorrido
	ld a,009h		;7884   ; +9: el destino
	call hl_mas_a		;7886
	ld bc,(0fa1fh)		;7889   ; el punto
	call bc_escribe		;788d   ; el punto
	jp rapidez_aviso_5c		;7890   ; el aviso de la velocidad
enemigo_arma:		; El arma del enemigo: el personaje (menu 0x61) y el menu 0x62 (como se mueve) con + 0x18
	call campo_c_11		;7893   ; +0x11
	and a			;7896   ; sin arma?
	jr z,enemigo_arma_va		;7897
	ld a,(0f527h)		;7899   ; el protagonista
	and a			;789c   ; sin protagonista?
	jr nz,enemigo_arma_va		;789d
	dec c			;789f   ; uno menos
enemigo_arma_va:
	ld b,022h		;78a0   ; hasta 0x22
	ld a,061h		;78a2   ; el menu 0x61
	call personaje_elige		;78a4   ; que personaje
	ld (ix+000h),c		;78a7   ; apuntado
	ld a,062h		;78aa   ; el menu 0x62
	call menu		;78ac
	ld e,01dh		;78af   ; el recorrido: el 0x1D
	ld b,018h		;78b1   ; + 0x18
	call campo_cambia		;78b3   ; al campo
	ld a,c			;78b6
	cp 005h		;78b7   ; hacia el protagonista?
	call z,recorrido_nuevo		;78b9   ; un recorrido nuevo
	jp rapidez_aviso_64		;78bc   ; el aviso de la velocidad
enemigo_puntos:		; 0x7A99 y el numero del menu 0x51 (desde 0x78C6, el 0x66)
	call campo_c_14		;78bf   ; +0x14
	ld a,051h		;78c2   ; el menu 0x51
	jr numero_tres_b		;78c4
arma_puntos:
	call campo_c_14		;78c6   ; +0x14
	ld a,066h		;78c9   ; el menu 0x66
numero_tres_b:
	ld b,01bh		;78cb   ; el aviso 0x1B
	jp numero_dos		;78cd
nombre_borra:		; El hueco de 2 y el nombre (0x7A4A, 0x7605)
	ld c,002h		;78d0   ; 2 letras
	call hueco_pon		;78d2   ; el hueco
	call campo_lee_07		;78d5   ; +7
	jp nombre_pinta_a		;78d8   ; escrito
personaje_arregla:		; ARREGLAR un personaje (menu 0x7D, desde 0x78DE el 0x7E): cual (0x86F8) a 0xFA12 y 0xFA13 = 2 (o 1 si es el unico)
	ld a,07dh		;78db   ; el menu 0x7D (desde 0x78DE, el 0x7E)
	ld bc,07e3eh		;78dd
	ld b,011h		;78e0   ; hasta 17
	ld c,001h		;78e2   ; el primero
	call personaje_elige		;78e4   ; cual
	ld hl,0fa12h		;78e7   ; el personaje
	ld (hl),c			;78ea
	inc hl			;78eb
	ld (hl),002h		;78ec   ; la clase 2
	dec c			;78ee   ; el 1?
	jr nz,personaje_arregla_fin		;78ef
	ld a,(0f527h)		;78f1   ; el protagonista
	dec a			;78f4   ; es el 1?
	jr nz,personaje_arregla_fin		;78f5
	ld (hl),001h		;78f7   ; la clase 1
personaje_arregla_fin:
	jp menu_opcion_1		;78f9   ; la primera opcion

; ----------------------------------------------------------------------
; DATOS sin_uso_78fc: Un byte que nadie lee
;   0x78fc..0x78fd  (1 bytes)
DATA_sin_uso_78fc:
	defb 0f1h	; 78fc

; ======================================================================
; CODIGO 0x78fd..0x7d3e  (1089 bytes)
; ======================================================================


sin_personajes:		; El aviso 0x0D ("no hay personajes")
	ld b,00dh		;78fd   ; "no hay personajes"
	jp aviso_y_atras		;78ff   ; y al menu de antes
personaje_borra:		; BORRAR el personaje 0xFA12 (0x8433) y al menu de los personajes
	ld a,(0fa12h)		;7902   ; el personaje
	call personaje_quita		;7905   ; fuera
menu_personajes:		; El menu 0x7B: nuevo, arreglar, copiar, borrar o acabar
	ld a,07bh		;7908   ; el menu 0x7B
	jp menu_y_opcion		;790a   ; y su opcion
personaje_copia:		; COPIAR un personaje: si no quedan sprites, el aviso 0x1E; de cual (menu 0x80) y el nombre del nuevo (menu 0x81); sus datos y dibujos se copian (0x79E8, 9 bytes, 0x48BE)
	ld a,(0fc40h)		;790d   ; sprites libres
	and a			;7910   ; ninguno?
	jp z,sin_sitio		;7911
	ld a,080h		;7914   ; el menu 0x80
	ld b,023h		;7916   ; hasta 0x23
	ld c,001h		;7918   ; el primero
	call personaje_elige		;791a   ; cual
	ld a,c			;791d   ; el de origen
	ld (0fa15h),a		;791e   ; el personaje de origen
	ld a,002h		;7921   ; la clase 2
	ld (0fa13h),a		;7923   ; la clase de personaje
	ld a,081h		;7926   ; el menu 0x81
	call personaje_alta		;7928   ; el alta
	ld a,(0fa15h)		;792b   ; el de origen
	call personaje_forma_a		;792e   ; su forma
	push hl			;7931
	inc a			;7932   ; + 1
	ld c,a			;7933
	call personaje_forma		;7934   ; la forma del nuevo
	pop hl			;7937
	ld a,009h		;7938   ; +9
	call hl_mas_a		;793a
	ld bc,00009h		;793d   ; 9 bytes copiados
	ldir		;7940
personaje_copia_va:
	ld a,(0fa13h)		;7942   ; la clase
	ld c,a			;7945   ; C = la clase
	dec a			;7946   ; el protagonista?
	jr z,personaje_copia_mueve		;7947
	ld a,(0f420h)		;7949   ; si no, el ultimo
	ld c,a			;794c   ; C = el sitio
personaje_copia_mueve:
	ld a,(0fa15h)		;794d   ; el de origen
	call objeto_cambia		;7950   ; sus sprites copiados
	jr nc,menu_personajes		;7953   ; cabe
personaje_menos:
	ld hl,0f420h		;7955   ; uno menos
	dec (hl)			;7958   ; uno menos
	jr sin_sitio		;7959   ; "no se pueden registrar mas"
personaje_uno:		; C = 2 si el protagonista (0xF527) es 1; si no, 1
	ld a,(0f527h)		;795b   ; el protagonista
	ld c,001h		;795e   ; el 1
	dec a			;7960
	ret nz			;7961   ; no es el 1
	inc c			;7962   ; el 2
	ret			;7963
personaje_nuevo:		; NUEVO personaje: si no quedan sprites, el aviso 0x1E; la clase (menu 0x85, a 0xFA13: protagonista u otro), el nombre (menu 0x7C), la forma (menu 0x83) y la animacion (menu 0x82, a +0x0A de la ficha); y al editor de personajes
	ld a,(0fc40h)		;7964   ; sprites libres
	and a			;7967   ; ninguno?
	jr z,sin_sitio		;7968
	ld a,085h		;796a   ; el menu 0x85
	call menu		;796c   ; el menu 0x85
	ld a,c			;796f   ; la clase
	ld (0fa13h),a		;7970   ; a 0xFA13
	ld a,07ch		;7973   ; el menu 0x7C
	call personaje_alta		;7975   ; el alta
	ld a,083h		;7978   ; el menu 0x83
	call menu		;797a   ; la forma
	call personaje_forma		;797d   ; a su registro
	ld a,082h		;7980   ; el menu 0x82
	call menu		;7982   ; animado?
	push bc			;7985
	ld hl,0f527h		;7986   ; el protagonista
	ld a,(0fa13h)		;7989   ; la clase
	dec a			;798c   ; el protagonista?
	call nz,personaje_ficha		;798d   ; si no, el suyo
	ld a,00ah		;7990   ; +0x0A
	call hl_mas_a		;7992
	pop bc			;7995
	dec c			;7996   ; 0 o 1
	ld (hl),c			;7997   ; la animacion
	jp personaje_editor		;7998   ; al editor
sin_sitio:		; El aviso 0x1E ("no se pueden registrar mas") y al menu de los personajes
	ld b,01eh		;799b   ; "no se pueden registrar mas"
aviso_y_personajes:		; El aviso B (la pila en 0xF9F1) y el menu de los personajes
	ld sp,0f9f1h		;799d   ; la pila
	call aviso		;79a0   ; el aviso
	jp menu_personajes		;79a3   ; el menu de los personajes
personaje_alta:		; El nombre (0x7EDC) y el alta del personaje: hasta 32 (0xF420); el protagonista va en 0xF527 (el que hubiera se mueve, 0x81C9); los demas al final; la clase y el nombre de 0xF868 en su ficha; 0xF420 + 1 y 0xFA12
	call nombre_pide_o		;79a6   ; el nombre
	ld a,(0fa13h)		;79a9   ; la clase
	push af			;79ac
	ld b,a			;79ad   ; la clase
	ld a,(0f420h)		;79ae   ; cuantos hay
	cp 020h		;79b1   ; 32?
	jr z,sin_sitio		;79b3   ; 32: no caben
	dec b			;79b5   ; el protagonista?
	jr nz,personaje_alta_otro		;79b6   ; no
	ld hl,0f527h		;79b8   ; su sitio
	and a			;79bb   ; el primero?
	jr z,personaje_alta_pon		;79bc   ; no hace falta mover
	push hl			;79be
	inc a			;79bf   ; detras del ultimo
	call personaje_ficha_a		;79c0   ; su registro
	ld bc,00015h		;79c3   ; 21 bytes
	pop de			;79c6
	call ram_abre		;79c7   ; los de detras bajan
	inc hl			;79ca   ; el sitio
personaje_alta_pon:
	pop af			;79cb   ; la clase
	ld (hl),a			;79cc   ; a su registro
	inc hl			;79cd
	inc hl			;79ce   ; el nombre (+2)
	ld de,0f868h		;79cf   ; el texto
	ex de,hl			;79d2
	ld bc,00008h		;79d3   ; 8 letras
	ldir		;79d6   ; copiado
	ld hl,0f420h		;79d8   ; cuantos
	ld a,(hl)			;79db
	inc a			;79dc
	ld (hl),a			;79dd   ; uno mas
	ld (0fa12h),a		;79de   ; el personaje nuevo
	ret			;79e1
personaje_alta_otro:
	inc a			;79e2   ; detras del ultimo
	call personaje_ficha_a		;79e3   ; su registro
	jr personaje_alta_pon		;79e6
personaje_forma:		; La forma del personaje (C; la 3 ocupa 2): si no quedan sprites, uno menos (0x7955); a +1 de la ficha; con el protagonista, los recorridos de la historia (0xF41F) se borran
	ld a,c			;79e8   ; la forma
	push bc			;79e9
	cp 003h		;79ea   ; la 3?
	jr nz,personaje_forma_va		;79ec
	ld c,002h		;79ee   ; ocupa 2
personaje_forma_va:
	ld a,(0fc40h)		;79f0   ; los sprites libres
	cp c			;79f3   ; caben?
	pop bc			;79f4
	jp c,personaje_menos		;79f5   ; no
	ld hl,0f528h		;79f8   ; la forma del protagonista
	ld a,(0fa13h)		;79fb   ; la clase
	dec a			;79fe   ; el protagonista?
	push af			;79ff
	call nz,personaje_forma_lee		;7a00   ; si no, la suya
	dec c			;7a03   ; desde 0
	ld (hl),c			;7a04   ; la forma
	pop af			;7a05
	ret nz			;7a06   ; no es el protagonista
	ld a,(0f41fh)		;7a07   ; cuantas fases
	and a			;7a0a
	ret z			;7a0b   ; ninguna
	ld b,a			;7a0c
	xor a			;7a0d   ; desde la 1
personaje_forma_fase:
	inc a			;7a0e   ; la siguiente
	ld (0fa08h),a		;7a0f   ; la fase
	push af			;7a12
	push bc			;7a13
	call fase_hay		;7a14   ; tiene datos?
	jr z,personaje_forma_sig		;7a17   ; no
	ex de,hl			;7a19
	inc hl			;7a1a   ; +2
	inc hl			;7a1b
	call palabra_lee		;7a1c   ; el recorrido
	push hl			;7a1f
	ld bc,00001h		;7a20   ; un byte
	call fase_pide		;7a23   ; sitio
	pop hl			;7a26
	ld (hl),000h		;7a27   ; sin recorrido
	call fichas_rutina_2		;7a29   ; los numeros de personaje suben
personaje_forma_sig:
	pop bc			;7a2c
	pop af			;7a2d
	djnz personaje_forma_fase		;7a2e   ; las 8
	and a			;7a30   ; NC
	ret			;7a31
ficha_mas:		; +0, +3 (si no es 0) y +0x11 (si no es 0) de IX, uno mas
	push ix		;7a32
	pop hl			;7a34
	inc (hl)			;7a35   ; +0, uno mas
	inc hl			;7a36
	inc hl			;7a37
	inc hl			;7a38
	ld a,(hl)			;7a39   ; +3
	and a			;7a3a
	jr z,ficha_mas_va		;7a3b   ; 0: nada
	inc (hl)			;7a3d   ; uno mas
ficha_mas_va:
	ld de,0000eh		;7a3e   ; +0x11
	add hl,de			;7a41
	ld a,(hl)			;7a42   ; el campo
	and a			;7a43
	ret z			;7a44   ; 0: nada
	inc (hl)			;7a45   ; uno mas
	ret			;7a46
campo_lee_13:		; Los campos de la ficha (0x7A55): con los bytes que siguen, E = 0x13 (0x7A47), 0x07 (0x7A4A), 0x04 (0x7A4D), 0x0A (0x7A50) o 0x03 (0x7A53)
	ld e,013h		;7a47   ; 0x13; desde 0x7A4A, 0x07; desde 0x7A4D, 0x04; desde 0x7A50, 0x0A; desde 0x7A53, 0x03
	ld bc,0071eh		;7a49
	ld bc,0041eh		;7a4c
	ld bc,00a1eh		;7a4f
	ld bc,0031eh		;7a52
campo_lee:		; IX = la ficha (0x8553) + E; C = 1 si el campo es 0, 2 si no
	ld d,000h		;7a55   ; E = el campo
	push de			;7a57
	call ficha_busca		;7a58   ; la ficha
	pop de			;7a5b
	add ix,de		;7a5c   ; + el campo
	ld a,(ix+000h)		;7a5e   ; el valor
	ld c,001h		;7a61   ; 1...
	and a			;7a63   ; ...si es 0
	ret z			;7a64
	inc c			;7a65   ; 2 si no
	ret			;7a66
campo_resta:		; 0x7A7E con A = 4 (desde 0x7A6A, 0x0D; 0x7A6D, 0x11; 0x7A70, 0x18) y, si no es 0, C - A
	ld a,004h		;7a67   ; 4; desde 0x7A6A, 0x0D; desde 0x7A6D, 0x11; desde 0x7A70, 0x18
	ld bc,00d3eh		;7a69
	ld bc,0113eh		;7a6c
	ld bc,0183eh		;7a6f
	ld b,a			;7a72   ; B = A
	push af			;7a73
	call campo_c_lee		;7a74   ; el campo
	pop de			;7a77
	and a			;7a78   ; 0?
	ret z			;7a79
	ld a,c			;7a7a   ; C...
	sub d			;7a7b   ; ...- A
	ld c,a			;7a7c
	ret			;7a7d
campo_c_lee:		; El campo de la ficha (0x7A55; E = 0x1E, y desde cada "ld bc" siguiente, 0x19, 0x05, 0x1F, 0x19, 0x22, 0x11, 0x17, 0x12, 0x14 o 0x0C): si no es 0, C = el campo
	ld e,01eh		;7a7e   ; 0x1E; desde 0x7A81, 0x19; 0x7A84, 0x05; 0x7A87, 0x1F; 0x7A8A, 0x19; 0x7A8D, 0x22; 0x7A90, 0x11; 0x7A93, 0x17; 0x7A96, 0x12; 0x7A99, 0x14; 0x7A9C, 0x0C
	ld bc,0191eh		;7a80
	ld bc,0051eh		;7a83
	ld bc,01f1eh		;7a86
	ld bc,0191eh		;7a89
	ld bc,0221eh		;7a8c
	ld bc,0111eh		;7a8f
	ld bc,0171eh		;7a92
	ld bc,0121eh		;7a95
	ld bc,0141eh		;7a98
	ld bc,00c1eh		;7a9b
	call campo_lee		;7a9e   ; el campo
	ret z			;7aa1   ; 0: nada
	ld c,a			;7aa2   ; C = el valor
	ret			;7aa3
campo_fase:		; El campo de la fase de la historia (0x857E; E = 0x24, desde 0x7AA7 0x13, desde 0x7AAA 0x15): IX = la ficha + E
	ld e,024h		;7aa4
	ld bc,0131eh		;7aa6
	ld bc,0151eh		;7aa9
	ld d,000h		;7aac   ; el campo
	push de			;7aae
	call fase_iy		;7aaf   ; la fase
	pop de			;7ab2   ; la ficha
	add hl,de			;7ab3   ; + el campo
	push hl			;7ab4
	pop ix		;7ab5   ; a IX
	ret			;7ab7
hl_mas_a:		; HL = HL + A
	add a,l			;7ab8   ; + A...
	ld l,a			;7ab9
	ret nc			;7aba   ; ...con acarreo
	inc h			;7abb
	ret			;7abc
salta_tabla:		; Salta a la rutina A (0, 1, ...) de la tabla de punteros de HL
	push af			;7abd   ; el indice
	call tabla_puntero		;7abe   ; el puntero
	pop af			;7ac1
salta_hl:		; jp (hl)
	jp (hl)			;7ac2
tabla_puntero:		; HL = la palabra A de la tabla de HL
	add a,a			;7ac3   ; dos bytes cada una
	call hl_mas_a		;7ac4   ; + A x 2
palabra_lee:		; HL = la palabra que hay en HL
	ld a,(hl)			;7ac7   ; el byte de abajo
	inc hl			;7ac8
	ld h,(hl)			;7ac9   ; el de arriba
	ld l,a			;7aca
	ret			;7acb
bc_lee:		; BC = la palabra de HL; HL + 2
	ld c,(hl)			;7acc   ; el de abajo
	inc hl			;7acd
	ld b,(hl)			;7ace   ; el de arriba
	inc hl			;7acf
	ret			;7ad0
bc_escribe:		; La palabra BC a HL; HL + 2
	ld (hl),c			;7ad1   ; el de abajo
	inc hl			;7ad2
	ld (hl),b			;7ad3   ; el de arriba
	inc hl			;7ad4
	ret			;7ad5
hl_igual_bc:		; Z si HL = BC
	ld a,h			;7ad6   ; la parte alta
	cp b			;7ad7
	ret nz			;7ad8
	ld a,l			;7ad9   ; la baja
	cp c			;7ada
	ret			;7adb
bc_cero:		; BC bytes desde HL a 0
	ld a,b			;7adc   ; quedan?
	or c			;7add
	ret z			;7ade
	ld (hl),000h		;7adf   ; a 0
	inc hl			;7ae1
	dec bc			;7ae2   ; uno menos
	jr bc_cero		;7ae3
menu_caracter_vuelve:		; En los menus 0x82 y 0x83 (el editor de personajes), deja el personaje en uso (0xFA12, 0x7AFC) y vuelve al menu 0x7B
	ld a,(0fa1ah)		;7ae5   ; el menu
	push af			;7ae8   ; el menu
	sub 082h		;7ae9   ; 0x82 o 0x83?
	cp 002h		;7aeb
	jr nc,menu_caracter_fin		;7aed   ; no
	ld a,(0fa12h)		;7aef   ; el personaje
	call personaje_suelta		;7af2   ; se deja
	ld a,07bh		;7af5   ; el menu de los personajes
	ld (0fa1ah),a		;7af7   ; el menu
menu_caracter_fin:
	pop af			;7afa
	ret			;7afb
personaje_suelta:		; Con un solo personaje en el editor (0xFA13 = 1), 0xFA12 = 1; despues 0x8436
	ld hl,0fa13h		;7afc   ; cuantos en el editor
	ld a,(hl)			;7aff
	dec hl			;7b00
	cp 001h		;7b01   ; 0xFA12
	jr nz,personaje_suelta_va		;7b03   ; mas de uno?
	ld (hl),a			;7b05   ; el 1
personaje_suelta_va:
	jp personaje_quita_va		;7b06   ; sus sprites
stop_mira_menu:		; Si se ha pulsado STOP (0xFA06 = 0xFF, de la interrupcion): una sola vez (0xFA07), deja el editor como esta y vuelve a empezar desde el menu principal (0x700C); jugando (0xFA04 1 o 2) con un solo fondo, antes 0x89D0
	ld hl,0fa06h		;7b09   ; STOP
	ld a,(hl)			;7b0c   ; pulsado?
	ld (hl),000h		;7b0d   ; se borra
	inc a			;7b0f   ; STOP?
	ret nz			;7b10
	inc hl			;7b11   ; 0xFA07
	ld a,(hl)			;7b12   ; ya visto?
	and a			;7b13
	ret nz			;7b14
	dec (hl)			;7b15   ; una vez
	ld a,(0fa04h)		;7b16   ; jugando?
	dec a			;7b19   ; jugando (1 o 2)?
	cp 002h		;7b1a
	jr nc,stop_mira_va		;7b1c
	ld a,(0f418h)		;7b1e   ; un solo fondo (0xF418 = 1)?
	dec a			;7b21   ; un fondo?
	call z,rotulo_restaura		;7b22   ; lo tapado por el rotulo
stop_mira_va:
	call menu_caracter_vuelve		;7b25   ; el editor de personajes
	call menu_limpia		;7b28   ; la pantalla de menu
	call casillas_cambia		;7b2b   ; las casillas
	jp menu_principal_entra		;7b2e   ; al menu principal
tecla_espera_texto:		; 0x835B y espera una tecla (0x7B34)
	call cursor_cuenta		;7b31   ; el cursor
tecla_espera:		; Espera un codigo del buffer del teclado: mientras, la muestra del movimiento (0x7BC4), STOP (0x7B09) y el parpadeo del cursor (0x82BB); los codigos 0x60-0x6F cambian el color (0x7BB5); 7-0x0A van a la tabla 0xB19E (ayuda y listas); con 0xFA1C 0 o 1, vuelve con el codigo en A
	ei			;7b34   ; con interrupciones
tecla_espera_bucle:
	call muestra_mueve		;7b35   ; la muestra
	call stop_mira_menu		;7b38   ; STOP
	call cursor_parpadea		;7b3b   ; el cursor parpadea
	call buffer_saca		;7b3e   ; el codigo siguiente
	push af			;7b41   ; el codigo
	call tableta_lee		;7b42   ; el cursor del raton/palanca
	pop af			;7b45
	jr nz,tecla_espera_hay		;7b46   ; hay codigo
	inc h			;7b48   ; la tableta: tocada?
	jr z,tecla_espera_bucle		;7b49   ; no: otra vez
	dec h			;7b4b
tecla_espera_hay:
	push bc			;7b4c
	push hl			;7b4d
	push af			;7b4e
	xor a			;7b4f   ; 0xFA07 a 0
	ld (0fa07h),a		;7b50
	ld a,(0fa05h)		;7b53   ; el parpadeo
	and a			;7b56
	call nz,cursor_apaga		;7b57   ; apagado
	pop af			;7b5a
	pop hl			;7b5b
	pop bc			;7b5c
	cp 007h		;7b5d   ; el 7?
	jr z,tecla_espera_cursores		;7b5f   ; el 7: la ayuda
	cp 060h		;7b61   ; 0x60-0x6F: un color
	jr c,tecla_espera_otro		;7b63   ; por debajo de 0x60
	cp 070h		;7b65   ; 0x70 o mas
	jr nc,tecla_espera_otro		;7b67
	call color_cambia		;7b69   ; el color
tecla_espera_sigue:
	ld a,(0fa1ch)		;7b6c   ; la clase de eleccion
	cp 002h		;7b6f   ; 2 o mas: otra
	jr nc,tecla_espera_texto		;7b71
	and a			;7b73   ; 1: otra
	jr nz,tecla_espera		;7b74
	inc h			;7b76   ; la tableta?
	jr z,tecla_espera		;7b77
	dec h			;7b79
	ret			;7b7a   ; el codigo
tecla_espera_1:
	ld a,001h		;7b7b   ; la clase 1
	ld (0fa1ch),a		;7b7d   ; la clase de eleccion
	jr tecla_espera		;7b80
tecla_espera_otro:
	ld e,a			;7b82   ; el codigo
	ld a,(0fa19h)		;7b83   ; una lista?
	and a			;7b86
	ld a,e			;7b87
	jr z,tecla_espera_menu		;7b88   ; no
	cp 006h		;7b8a   ; 6?
	jr z,tecla_espera_sigue		;7b8c
tecla_espera_cursor:
	ld e,a			;7b8e
	ld a,(0fa1ch)		;7b8f   ; la clase de eleccion
	and a			;7b92
	jr z,tecla_espera_sigue		;7b93   ; 0: nada
	ld a,(0fa0bh)		;7b95   ; con aviso?
	inc a			;7b98   ; 0xFF: nada
	jr z,tecla_espera_sigue		;7b99
	ld a,e			;7b9b   ; el codigo
tecla_espera_cursores:
	sub 007h		;7b9c   ; 7-0x0A...
	cp 004h		;7b9e
	ld hl,0b19eh		;7ba0   ; ...a la tabla 0xB19E
	call c,salta_tabla		;7ba3   ; a la rutina
	jr tecla_espera_sigue		;7ba6
tecla_espera_menu:
	cp 007h		;7ba8   ; por debajo de 7: vuelve
	ret c			;7baa
	cp 00bh		;7bab   ; 7-0x0A: los de la tabla
	jr c,tecla_espera_cursor		;7bad
	cp 00dh		;7baf   ; 0x0D: volver?
	ret nz			;7bb1
	jp tecla_vuelve		;7bb2   ; al menu de antes
color_cambia:		; El color A: en el menu (0xFA1C = 0), el del borde (0x703F); si no, el de fondo de las letras (0xFA35) y los colores de la pantalla de texto
	ld b,a			;7bb5   ; el color
	ld a,(0fa1ch)		;7bb6   ; la clase de eleccion
	and a			;7bb9   ; en un menu?
	ld a,b			;7bba
	jp z,borde_pon		;7bbb   ; el borde
	ld (0fa35h),a		;7bbe   ; el fondo de las letras
	jp texto_colores		;7bc1   ; los colores
muestra_mueve:		; La muestra del movimiento (0xFA16, en las pantallas de la velocidad y del recorrido): cuando le toca (0x8EC3), el personaje da un paso; en la de la velocidad (no 0x48) va hacia la derecha (0x931A) y al llegar al borde vuelve a empezar en Y 0x64, X 8; en la del recorrido, lo sigue (0x9258) y al acabar empieza otra vez
	ld a,(0fa16h)		;7bc4   ; la muestra en marcha?
	and a			;7bc7   ; parada?
	ret z			;7bc8
	call ficha_busca		;7bc9   ; la ficha
	call ficha_le_toca		;7bcc   ; le toca?
	ret c			;7bcf   ; no
	ld (ix+01ch),e		;7bd0   ; su reloj
	ld (ix+01dh),d		;7bd3
	call sonando_no		;7bd6   ; 0xFA03 a 0
	ld a,(0fa1ah)		;7bd9   ; el menu
	cp 048h		;7bdc   ; el del recorrido?
	jr z,muestra_mueve_recorrido		;7bde
	call mov_derecha		;7be0   ; un paso a la derecha
	ld a,(0fa03h)		;7be3   ; lo que pasa
	bit 1,a		;7be6   ; en el borde?
	jp z,ficha_dibujo_mueve		;7be8   ; no: el dibujo
	call ficha_sprites_fuera		;7beb   ; fuera
	ld bc,06408h		;7bee   ; otra vez en Y 0x64, X 8
	ld a,003h		;7bf1   ; el dibujo 3
	jp dibujo_pon		;7bf3
muestra_mueve_recorrido:
	ld hl,(0fa0eh)		;7bf6   ; el recorrido
	ld a,(hl)			;7bf9   ; cuantos puntos
	cp 002h		;7bfa   ; menos de 2?
	jr c,muestra_mueve_otra		;7bfc
	call mov_recorrido		;7bfe   ; un paso
	ld a,(0fa03h)		;7c01   ; lo que pasa
	rrca			;7c04   ; acabado?
	jp nc,ficha_dibujo_otra		;7c05   ; no
muestra_mueve_otra:
	ld hl,(0fa0eh)		;7c08   ; el recorrido
	inc hl			;7c0b   ; el primer punto
	call bc_lee		;7c0c
	ld e,005h		;7c0f   ; el movimiento 5
	jp movimiento_va		;7c11   ; desde el principio
menu_caracter_va:		; Fuera del menu 0x22, 0x7AFC; y al menu de los personajes (0x7908)
	ld a,(0fa1ah)		;7c14   ; el menu
	cp 022h		;7c17   ; el 0x22?
	call nz,personaje_suelta		;7c19   ; si no, el personaje se deja
	jp menu_personajes		;7c1c   ; el menu de los personajes
tecla_vuelve:		; La tecla de volver (0x0D) en un menu: de los menus 0x82/0x83 al de los personajes; si no, al menu de antes (la pila de menus de 0xF8A8)
	ld a,(0fa1ch)		;7c1f   ; la clase de eleccion
	and a			;7c22   ; 0: nada
	ret z			;7c23
	ld a,(0fa1ah)		;7c24   ; el menu
	sub 082h		;7c27   ; 0x82 o 0x83?
	cp 002h		;7c29
	jp c,menu_caracter_va		;7c2b
menu_atras:		; El menu de antes: baja en la pila de menus (0xFA27); por debajo de 0x0C, al principio (0x700C)
	ld hl,(0fa27h)		;7c2e   ; la pila de menus
	dec hl			;7c31   ; el de ahora
menu_atras_uno:
	dec hl			;7c32   ; el de antes
	ld a,(hl)			;7c33   ; cual
	cp 00ch		;7c34   ; por debajo de 0x0C
	jp c,menu_principal_entra		;7c36
	cp 083h		;7c39   ; el 0x83?
	jp z,menu_caracter_va		;7c3b
	cp 082h		;7c3e   ; el 0x82?
	jp z,menu_caracter_va		;7c40   ; al de los personajes
menu_salta:		; Va al menu A desde cualquier sitio: fuera de los menus del fondo (0x1B-0x22), 0xFA19 = 0; la pantalla de menu, sin la muestra (0xFA16), la pila y la rutina del menu en la tabla 0xB1E2
	push af			;7c43
	ld a,(0fa1ah)		;7c44   ; el menu de ahora
	sub 01bh		;7c47   ; los del fondo?
	cp 008h		;7c49
	jr c,menu_salta_va		;7c4b
	xor a			;7c4d
	ld (0fa19h),a		;7c4e   ; la lista en pantalla
menu_salta_va:
	call menu_limpia		;7c51
	xor a			;7c54
	ld (0fa16h),a		;7c55   ; sin la muestra
	pop af			;7c58
	ld hl,0b1e2h		;7c59   ; la tabla de entrada de los menus
	add a,a			;7c5c
	jr nc,menu_salta_pon		;7c5d
	inc h			;7c5f
menu_salta_pon:
	call hl_mas_a		;7c60
	ld sp,0f9f1h		;7c63   ; la pila
	call palabra_lee		;7c66
	jp salta_hl		;7c69
tecla_personajes:		; F3 (el codigo 9, tabla 0xB19E): la lista de personajes; la primera vez (0xFA19 = 0), la pantalla y la lista desde el 1 (si no hay historia, el aviso 0x0D); otra vez, la pagina siguiente o el menu de antes
	ld a,(0fa19h)		;7c6c   ; ya en la lista?
	cp 020h		;7c6f
	jr z,tecla_personajes_sig		;7c71
	and a			;7c73
	ret nz			;7c74
	call texto_entra_guarda		;7c75
	call muestra_para		;7c78
	call menu_caracter_vuelve		;7c7b
	call historia_hay		;7c7e   ; hay historia?
	ld b,00dh		;7c81
	jr z,tecla_aviso		;7c83
	ld a,020h		;7c85   ; la lista
	ld (0fa19h),a		;7c87   ; la lista en pantalla
	call sprites_tabla_76		;7c8a
	ld c,001h		;7c8d
tecla_personajes_va:
	call personajes_lista_otra		;7c8f
	jr tecla_espera_va		;7c92
tecla_personajes_sig:
	ld a,(0fa14h)		;7c94   ; el ultimo?
	cp d			;7c97
	jr z,tecla_ayuda_vuelve		;7c98
	inc a			;7c9a
	ld c,a			;7c9b
	jr tecla_personajes_va		;7c9c
tecla_sonidos:		; F2 (el codigo 8): la lista de los sonidos (si no hay, el aviso 0x0C); otra vez, el menu de antes
	ld a,(0fa19h)		;7c9e   ; la lista en pantalla
	and a			;7ca1
	jr z,tecla_sonidos_va		;7ca2
	cp 021h		;7ca4
	jr tecla_ayuda_fin		;7ca6
tecla_sonidos_va:
	call texto_entra_guarda		;7ca8
	call muestra_para		;7cab
	ld a,(0f422h)		;7cae   ; hay sonidos?
	and a			;7cb1
	jr nz,tecla_sonidos_lista		;7cb2
	ld b,00ch		;7cb4
tecla_aviso:
	ld sp,0f9f1h		;7cb6
	call aviso		;7cb9
	jr tecla_ayuda_vuelve		;7cbc
tecla_sonidos_lista:
	ld a,021h		;7cbe
	ld (0fa19h),a		;7cc0   ; la lista en pantalla
	call menu_limpia		;7cc3
	ld c,001h		;7cc6
	call sonidos_lista_limpia		;7cc8
tecla_espera_va:
	jp tecla_espera_1		;7ccb
tecla_ayuda:		; F4 (el codigo 0x0A): el aviso de ayuda del menu de ahora (las tablas 0xB423 y, en los del fondo, 0xB43A con la opcion): el aviso 0x24 + n en la fila 4; otra vez, el menu
	ld a,(0fa19h)		;7cce   ; ya en la ayuda?
	and a			;7cd1
	jr z,tecla_ayuda_busca		;7cd2
	cp 004h		;7cd4
tecla_ayuda_fin:
	ret nz			;7cd6
tecla_ayuda_vuelve:
	ld a,(0fa1ah)		;7cd7   ; el menu
	jp menu_salta		;7cda
tecla_ayuda_busca:
	ld hl,0b423h		;7cdd   ; la tabla de ayudas
	ld de,00006h		;7ce0
	ld a,(0fa1ah)		;7ce3   ; el menu de ahora
	sub 01bh		;7ce6   ; los del fondo?
	cp 008h		;7ce8
	jr nc,tecla_ayuda_grupo		;7cea
	ld hl,0b43ah		;7cec   ; la otra tabla
	ld a,(0fa5bh)		;7cef   ; la opcion del menu
	ld c,a			;7cf2
	inc d			;7cf3
	ld e,00eh		;7cf4
tecla_ayuda_grupo:
	ld a,(hl)			;7cf6
	push af			;7cf7
	inc hl			;7cf8
	ld b,(hl)			;7cf9
tecla_ayuda_mira:
	ld a,(0fa1ah)		;7cfa   ; el menu
	inc hl			;7cfd
	cp (hl)			;7cfe
	jr z,tecla_ayuda_hallada		;7cff
	inc d			;7d01
	dec d			;7d02
	jr z,tecla_ayuda_sig		;7d03
	inc hl			;7d05
tecla_ayuda_sig:
	djnz tecla_ayuda_mira		;7d06   ; el siguiente
	inc hl			;7d08
	pop af			;7d09
	dec e			;7d0a   ; uno menos
	jr nz,tecla_ayuda_grupo		;7d0b
	ret			;7d0d
tecla_ayuda_hallada:
	inc d			;7d0e   ; sin opcion?
	dec d			;7d0f
	jr z,tecla_ayuda_pon		;7d10
	inc hl			;7d12
	ld a,(hl)			;7d13   ; la opcion
	cp c			;7d14   ; la de ahora?
	jr nz,tecla_ayuda_sig		;7d15
tecla_ayuda_pon:
	pop af			;7d17
	add a,024h		;7d18   ; el aviso 0x24 + n
	ld b,a			;7d1a
	ld a,004h		;7d1b
	ld (0fa19h),a		;7d1d   ; la lista en pantalla
	call aviso_fila4		;7d20
	jr tecla_espera_va		;7d23
tecla_menu_directo:		; El codigo 7 (B19E): el sonido de la tecla, fuera de las listas y al menu que le toca en la tabla 0xB179 (pares de umbral y menu)
	call sonido_cola_a		;7d25
	xor a			;7d28
	ld (0fa19h),a		;7d29   ; la lista en pantalla
	call menu_caracter_vuelve		;7d2c
	ld hl,0b179h		;7d2f   ; la tabla
tecla_menu_busca:
	cp (hl)			;7d32
	jr c,tecla_menu_hallado		;7d33
	inc hl			;7d35
	inc hl			;7d36
	jr tecla_menu_busca		;7d37
tecla_menu_hallado:
	dec hl			;7d39
	ld a,(hl)			;7d3a
	jp menu_salta		;7d3b

; ----------------------------------------------------------------------
; DATOS sin_uso_7d3e: Tres bytes que nadie lee
;   0x7d3e..0x7d41  (3 bytes)
DATA_sin_uso_7d3e:
	defb 023h,018h,0f9h	; 7d3e

; ======================================================================
; CODIGO 0x7d41..0x8a6a  (3369 bytes)
; ======================================================================


muestra_para:		; Si estaba la muestra del movimiento (0xFA16 = 0xFF): se para y los 4 atributos guardados (0xFA43) vuelven a la VRAM (0xFA41)
	ld hl,0fa16h		;7d41
	ld a,(hl)			;7d44   ; en marcha?
	ld (hl),000h		;7d45   ; se para
	inc a			;7d47
	ret nz			;7d48
	ld de,(0fa41h)		;7d49   ; los atributos
	ld hl,0fa43h		;7d4d   ; guardados
	ld bc,00004h		;7d50   ; 4 bytes
	jp ldirvm_mas		;7d53
aviso:		; El aviso B (0xFA0B = 0xFF) en pantalla (0x7D64) y espera la barra (el codigo 0x0E)
	ld a,0ffh		;7d56   ; con aviso
	ld (0fa0bh),a		;7d58   ; con aviso
	inc a			;7d5b   ; 0
	ld (0fa19h),a		;7d5c   ; la lista en pantalla
	jr aviso_pon		;7d5f   ; a pintarlo
aviso_menu:		; El aviso B en el menu A
	ld (0fa1ah),a		;7d61   ; el menu
aviso_pon:
	ld de,00004h		;7d64   ; en la fila 4
	call aviso_pinta		;7d67   ; el aviso
	ld a,001h		;7d6a   ; la clase de eleccion 1
	ld (0fa1ch),a		;7d6c   ; la clase de eleccion
aviso_espera:
	call tecla_espera		;7d6f   ; una tecla
	and 07fh		;7d72   ; sin el bit 7
	cp 00eh		;7d74   ; la barra?
	jr nz,aviso_espera		;7d76   ; hasta la barra
	ret			;7d78
aviso_en_menu:		; 0xFA1A = A y el aviso (0x7D7C)
	ld (0fa1ah),a		;7d79   ; el menu
aviso_fila4:
	ld de,00004h		;7d7c   ; en la fila 4
aviso_pinta:		; La pantalla limpia y el aviso B (sus textos de la tabla 0xB755, de 0xB806) desde la fila de DE
	push bc			;7d7f
	call pantalla_texto_limpia		;7d80   ; la pantalla limpia
	pop bc			;7d83
aviso_pinta_va:
	push af			;7d84
	call menu_limpia		;7d85   ; la pantalla de menu
	call texto_entra_guarda		;7d88   ; la de texto
	ld a,(0fa0bh)		;7d8b   ; con aviso?
	inc a			;7d8e
	call nz,menu_apunta		;7d8f   ; si no, a la pila de menus
	xor a			;7d92   ; ya no
	ld (0fa0bh),a		;7d93   ; con aviso
	pop af			;7d96
	ld a,b			;7d97   ; el aviso
	ld hl,0b755h		;7d98   ; la tabla de los avisos
	push de			;7d9b
	call registro		;7d9c   ; el registro B
	pop bc			;7d9f
	ld de,0b806h		;7da0   ; los textos
	jp textos_pinta		;7da3   ; sus textos
menu_limpia:		; Antes de un menu: 0x7D41, 0x9F47 y 0x807A; fuera del menu 0x22, los sprites fuera
	push bc			;7da6
	push de			;7da7
	call muestra_para		;7da8   ; sin la muestra
	call sonido_para		;7dab   ; sin sonido
	call sprites_fuera_guarda		;7dae   ; los sprites fuera
	ld a,(0fa1ah)		;7db1   ; el menu
	cp 022h		;7db4   ; el 0x22?
	call nz,sprites_fuera_vdp		;7db6   ; los de abajo
	pop de			;7db9
	pop bc			;7dba
	ret			;7dbb
menu:		; El menu A: la pantalla de texto, sus opciones (0x7E0E), apuntado en la pila de menus (0x7DD8) y la eleccion (0x8240, vuelve con C)
	push af			;7dbc
	call menu_limpia		;7dbd   ; la pantalla de menu
	call texto_entra_guarda		;7dc0   ; la de texto
	call pantalla_texto_limpia		;7dc3   ; limpia
	pop af			;7dc6
menu_va:
	ld (0fa1ah),a		;7dc7   ; el menu
	call menu_pinta		;7dca   ; el titulo y las opciones
	ld a,080h		;7dcd   ; la clase de eleccion 0x80
	ld (0fa1ch),a		;7dcf   ; la clase de eleccion
	call menu_apunta		;7dd2   ; a la pila de menus
	jp menu_elige		;7dd5   ; la eleccion
menu_apunta:		; Mete el menu 0xFA1A en la pila de menus (0xF8A8-, puntero 0xFA27) si no estaba ya; si estaba, la pila se corta ahi
	push bc			;7dd8
	push de			;7dd9
	xor a			;7dda   ; sin escritura
	ld (0fe13h),a		;7ddb   ; con escritura
	ld a,(0fa1ah)		;7dde   ; el menu
	ld hl,(0fa27h)		;7de1   ; la cima de la pila
	ld b,a			;7de4   ; el menu
	ld de,0f8a8h		;7de5   ; el fondo de la pila
menu_apunta_busca:
	rst 20h			;7de8   ; DCOMPR: en el fondo?
	jr z,menu_apunta_nuevo		;7de9   ; si: es nuevo
	dec hl			;7deb   ; el de abajo
	ld a,b			;7dec
	cp (hl)			;7ded   ; ya esta?
	jr z,menu_apunta_fin		;7dee   ; si: la pila se corta ahi
	jr menu_apunta_busca		;7df0
menu_apunta_nuevo:
	ld hl,(0fa27h)		;7df2   ; la cima
	ld (hl),b			;7df5   ; el nuevo
menu_apunta_fin:
	inc hl			;7df6   ; la cima, uno mas
	ld (0fa27h),hl		;7df7   ; apuntada
	jr pops_de		;7dfa
texto_entra_guarda:		; La pantalla de texto (texto_entra) guardando BC, DE y HL
	push bc			;7dfc
	push de			;7dfd
	push hl			;7dfe
	call texto_entra		;7dff   ; la pantalla de texto
pops_hl:
	pop hl			;7e02
pops_de:
	pop de			;7e03
	pop bc			;7e04
	ret			;7e05
graficos_entra_guarda:		; SCREEN 2 (graficos_entra) guardando BC, DE y HL
	push bc			;7e06
	push de			;7e07
	push hl			;7e08
	call graficos_entra		;7e09   ; SCREEN 2
	jr pops_hl		;7e0c
menu_pinta:		; Pinta el menu A (su registro de 0xB5D3): el titulo (texto de 0xB806) en la fila 4, las opciones desde la fila 3 con su numero (1, 2, ...) delante y el cursor en la opcion de antes (0xFA5B con 0xFA19) o en la de la tecla
	push af			;7e0e
	ld hl,0b5d3h		;7e0f   ; los menus
	call registro		;7e12   ; el registro del menu
	dec a			;7e15   ; cuantas opciones
	push af			;7e16
	push af			;7e17
	ld a,(hl)			;7e18   ; el titulo
	inc hl			;7e19
	push hl			;7e1a
	ld hl,0b806h		;7e1b   ; la tabla de textos
	ld bc,00004h		;7e1e   ; fila 0, columna 4
	call texto_pinta_n		;7e21   ; el titulo
	pop hl			;7e24
	ld b,003h		;7e25   ; desde la fila 3
	pop af			;7e27   ; cuantas
	ld de,0b806h		;7e28
	call textos_pinta		;7e2b   ; las opciones
	pop de			;7e2e
	pop af			;7e2f
	push af			;7e30
	push de			;7e31   ; cuantas
	dec c			;7e32   ; la columna 2
	dec c			;7e33
	ld b,003h		;7e34   ; desde la fila 3
	push bc			;7e36
	push af			;7e37
	ld a,031h		;7e38   ; el numero "1"
menu_numeros:
	call letra_en_bc		;7e3a   ; el numero
	dec d			;7e3d   ; el ultimo?
	jr z,menu_cursor		;7e3e
	inc b			;7e40   ; dos filas mas abajo
	inc b			;7e41
	inc a			;7e42   ; el numero siguiente
	jr menu_numeros		;7e43
menu_cursor:
	pop af			;7e45
	pop bc			;7e46
	dec c			;7e47   ; la columna 1
	push bc			;7e48
	ld hl,0b48fh		;7e49   ; la tabla de las teclas
menu_tecla:
	ld bc,00301h		;7e4c   ; la primera opcion
	inc hl			;7e4f   ; el siguiente registro
	inc hl			;7e50
	inc hl			;7e51
	cp (hl)			;7e52   ; el menu
	jr c,menu_cursor_pon		;7e53   ; pasado: la primera
	jr nz,menu_tecla		;7e55   ; otro: el siguiente
	inc hl			;7e57   ; la rutina
	call palabra_lee		;7e58
	call salta_hl		;7e5b   ; la opcion por defecto
	ld a,c			;7e5e   ; la opcion...
	add a,a			;7e5f   ; ...x 2 + 1: la fila
	inc a			;7e60
	ld b,a			;7e61
menu_cursor_pon:
	pop hl			;7e62
	ld h,b			;7e63   ; la fila
	ld a,(0fa19h)		;7e64   ; la de antes?
	and a			;7e67
	jr z,menu_cursor_fin		;7e68   ; no
	xor a			;7e6a   ; ya no
	ld (0fa19h),a		;7e6b   ; la lista en pantalla
	ld a,(0fa5bh)		;7e6e   ; la opcion de antes
	ld c,a			;7e71
	add a,a			;7e72   ; x 2 + 1: la fila
	inc a			;7e73
	ld h,a			;7e74
menu_cursor_fin:
	ld (0fa1dh),hl		;7e75   ; el cursor
	pop de			;7e78
	pop af			;7e79
	ret			;7e7a
textos_pinta:		; A textos seguidos (sus numeros en HL, de la tabla DE) uno en cada fila
	and a			;7e7b   ; ninguno?
	ret z			;7e7c
	push af			;7e7d
	ld a,(hl)			;7e7e   ; el numero de texto
	inc hl			;7e7f
	ex de,hl			;7e80
	push hl			;7e81
	call texto_pinta_n		;7e82   ; pintado en BC
	ex de,hl			;7e85
	pop de			;7e86
	pop af			;7e87
	dec a			;7e88   ; uno menos
	jr textos_pinta		;7e89
registro:		; HL = el registro A (desde 1) de la tabla de registros con su longitud delante de HL; A = su longitud
	push bc			;7e8b
	ld b,a			;7e8c
registro_salta:
	ld a,(hl)			;7e8d   ; la longitud
	inc hl			;7e8e
	dec b			;7e8f   ; el que se busca?
	jr z,registro_fin		;7e90
	call hl_mas_a		;7e92   ; el siguiente
	jr registro_salta		;7e95
registro_fin:
	pop bc			;7e97
	ret			;7e98
texto_pinta_n:		; El texto A de la tabla HL a 0xF868 (0x7EB5) y a la pantalla en BC (0x8048); BC, a la fila siguiente
	push de			;7e99
	push bc			;7e9a
	ld (0fa1dh),bc		;7e9b   ; la posicion
	call registro		;7e9f   ; el registro
	call texto_arma		;7ea2   ; a 0xF868
	call texto_pinta_f868		;7ea5   ; a la pantalla
	pop bc			;7ea8
	pop de			;7ea9
	ld a,(0fa1eh)		;7eaa   ; la fila
	inc a			;7ead   ; dos mas abajo
	inc a			;7eae
	ld b,a			;7eaf
	ld (0fa1dh),bc		;7eb0   ; la posicion
	ret			;7eb4
texto_arma:		; Arma en 0xF868 el texto de HL (A bytes): un 4 y un numero meten el trozo de 0xB4E0 de ese numero; acaba en 0
	ld de,0f868h		;7eb5   ; a 0xF868
	push bc			;7eb8
	ld b,a			;7eb9   ; la longitud
texto_arma_uno:
	ld a,(hl)			;7eba
	cp 004h		;7ebb   ; 4: un trozo?
	jr nz,texto_arma_letra		;7ebd
	inc hl			;7ebf
	ld a,(hl)			;7ec0   ; el numero del trozo
	push hl			;7ec1
	ld hl,0b4e0h		;7ec2   ; los trozos
	call registro		;7ec5   ; su registro
	dec b			;7ec8   ; uno menos
	push bc			;7ec9
	ld c,a			;7eca   ; su longitud
	ld b,000h		;7ecb
	ldir		;7ecd   ; copiado
	pop bc			;7ecf
	pop hl			;7ed0
texto_arma_sig:
	inc hl			;7ed1
	djnz texto_arma_uno		;7ed2
	xor a			;7ed4   ; el final
	ld (de),a			;7ed5
	pop bc			;7ed6
	ret			;7ed7
texto_arma_letra:
	ld (de),a			;7ed8
	inc de			;7ed9
	jr texto_arma_sig		;7eda
nombre_pide_o:		; Con un solo personaje y 0xF527 = 1, el aviso 7 por 0x799D; si no, 0x7EEF
	ld b,a			;7edc   ; el menu
	ld a,(0fa13h)		;7edd   ; cuantos en el editor
	dec a			;7ee0
	jr nz,nombre_pide_a		;7ee1   ; mas de uno
	ld a,(0f527h)		;7ee3   ; el protagonista
	dec a			;7ee6   ; el 1?
	jr nz,nombre_pide_a		;7ee7
	ld b,007h		;7ee9   ; "ya se usa"
	jp aviso_y_personajes		;7eeb
nombre_pide_a:
	ld a,b			;7eee
nombre_pide:		; El menu A con un hueco de 8 letras (C) en la fila 2, columna 4, para escribir (0x7F7D)
	ld c,008h		;7eef   ; 8 letras
nombre_pide_c:
	ld b,004h		;7ef1   ; en la fila 4
	push bc			;7ef3
	call aviso_en_menu		;7ef4   ; el aviso
	pop bc			;7ef7
	call hueco_pon		;7ef8   ; el hueco
	ld hl,00204h		;7efb   ; fila 2, columna 4
	xor a			;7efe   ; letras y cifras
	ld (0fa0ah),a		;7eff   ; solo cifras
	jp hueco_edita		;7f02   ; se escribe
numero_menu:		; El menu A y su numero (0x872D); C = el valor de antes (0xA1F7); lo deja en la casilla (0x8717)
	push bc			;7f05
	call aviso_en_menu		;7f06   ; el aviso
	call sonidos_lista_aviso		;7f09   ; la lista de los sonidos
	dec b			;7f0c
	ld d,b			;7f0d   ; cuantos
	pop bc			;7f0e
	push de			;7f0f
	ld a,c			;7f10
	call sonido_busca_lista		;7f11   ; en la lista?
	pop de			;7f14
	jr c,numero_menu_pinta		;7f15   ; si
numero_menu_0:
	ld b,000h		;7f17   ; el primero
numero_menu_pinta:
	ld a,b			;7f19   ; la posicion
	ld l,002h		;7f1a   ; la columna 2
	cp 00ah		;7f1c   ; del 10 en adelante...
	jr c,numero_menu_va		;7f1e
	sub 00ah		;7f20
	ld l,00fh		;7f22   ; ...la columna 0x0F
numero_menu_va:
	add a,a			;7f24   ; x 2 + 3: la fila
	add a,003h		;7f25
	ld h,a			;7f27
	ld c,b			;7f28
	ld a,021h		;7f29   ; la clase 0x21
	call menu_elige_en		;7f2b   ; la eleccion
	ld a,c			;7f2e
	and a			;7f2f   ; Z si es 0
	ret			;7f30
numero_menu_b:
	call aviso_en_menu		;7f31
	call sonidos_lista		;7f34   ; la lista
	dec b			;7f37
	ld d,b			;7f38
	jr numero_menu_0		;7f39
nombre_nuevo:		; El nombre (0x7EEF) y si ya esta (0x9939): repetido, el aviso 0x1D; sin sitio, el 0x1E
	call nombre_pide		;7f3b
	call sonido_nombre		;7f3e   ; dado de alta
	jr c,nombre_lleno		;7f41   ; 18 ya
	ret nz			;7f43   ; bien
	ld b,01dh		;7f44   ; "ya hay uno con ese nombre"
	jr nombre_aviso		;7f46
nombre_lleno:
	ld b,01eh		;7f48   ; "no se pueden registrar mas"
nombre_aviso:
	call aviso		;7f4a
	jp menu_atras		;7f4d   ; el menu de antes
hueco_pon:		; El hueco de C letras (0xF868 lleno de espacios; 0xFA29 el principio y 0xFA2B el final)
	push hl			;7f50
	ld hl,0f868h		;7f51   ; el hueco
	ld (0fa29h),hl		;7f54   ; el principio
	push hl			;7f57
	ld a,c			;7f58   ; la longitud...
	dec a			;7f59
	call hl_mas_a		;7f5a
	ld (0fa2bh),hl		;7f5d   ; ...el final
	pop hl			;7f60
	ld a,020h		;7f61   ; espacios
	ld b,c			;7f63
	call llena_b		;7f64   ; lleno
	pop hl			;7f67
	ret			;7f68
hueco_vacio:		; Desde el menu 0x0A: Z si los 8 primeros de 0xF868 son espacios
	ld a,(0fa1ah)		;7f69   ; el menu
	cp 00ah		;7f6c   ; desde el menu 0x0A
	ret c			;7f6e
	ld b,008h		;7f6f   ; 8 letras
	ld hl,0f868h		;7f71
	ld a,020h		;7f74   ; espacios?
hueco_vacio_mira:
	cp (hl)			;7f76
	ret nz			;7f77
	inc hl			;7f78
	djnz hueco_vacio_mira		;7f79
	jr hueco_edita_va		;7f7b   ; si: otra vez
hueco_edita:		; Escribe en el hueco desde HL (0xFA1D): 0xFA1C = 0x10, 0xFA37 = 2
	ld (0fa1dh),hl		;7f7d   ; la posicion del cursor
	ld a,010h		;7f80   ; la clase 0x10
	ld (0fa1ch),a		;7f82   ; la clase de eleccion
	ld a,002h		;7f85   ; el cursor 2
	ld (0fa37h),a		;7f87   ; la clase de cursor
hueco_edita_va:
	call tecla_espera_texto		;7f8a   ; una tecla
	ld hl,(0fa29h)		;7f8d   ; donde se escribe
	and 07fh		;7f90   ; sin el bit 7
	cp 00fh		;7f92   ; volver?
	jr z,hueco_vacio		;7f94
	cp 070h		;7f96   ; 0x70 o mas: nada
	jr nc,hueco_edita_va		;7f98
	cp 012h		;7f9a   ; a la derecha?
	jr z,hueco_derecha		;7f9c
	cp 016h		;7f9e   ; a la izquierda?
	jr z,hueco_izquierda		;7fa0
	jr c,hueco_edita_va		;7fa2
	cp 020h		;7fa4   ; por debajo del espacio: nada
	jr c,hueco_edita_va		;7fa6
	ld b,a			;7fa8
	ld a,(0fa0ah)		;7fa9   ; solo cifras?
	and a			;7fac
	ld a,b			;7fad
	jr z,hueco_letra		;7fae
	cp 030h		;7fb0   ; "0"...
	jr c,hueco_edita_va		;7fb2
	cp 03ah		;7fb4   ; ..."9"
	jr nc,hueco_edita_va		;7fb6
hueco_letra:
	ld (hl),a			;7fb8   ; la letra
	call letra_aqui		;7fb9   ; a la pantalla
hueco_derecha:
	ld de,(0fa2bh)		;7fbc   ; el final
hueco_derecha_va:
	rst 20h			;7fc0   ; DCOMPR
	jr z,hueco_edita_va		;7fc1   ; al final: nada
	inc hl			;7fc3
	ld (0fa29h),hl		;7fc4   ; una mas
	ld hl,0fa1dh		;7fc7
	inc (hl)			;7fca   ; la columna
	jr hueco_edita_va		;7fcb
hueco_izquierda:
	ld bc,0f868h		;7fcd
	call hl_igual_bc		;7fd0   ; al principio?
	jr z,hueco_edita_va		;7fd3
	dec hl			;7fd5   ; una menos
	ld (0fa29h),hl		;7fd6   ; donde se escribe
	ld hl,0fa1dh		;7fd9
	dec (hl)			;7fdc
	jr hueco_edita_va		;7fdd
hueco_numero:		; El numero escrito en el hueco (0xF868 hasta 0xFA2B, cifras; los espacios de delante no cuentan, el primero de detras acaba) en BC
	ld de,0f868h		;7fdf
	ld hl,(0fa2bh)		;7fe2   ; el final...
	inc hl			;7fe5
	sbc hl,de		;7fe6   ; ...menos el principio
	ld c,l			;7fe8
	ld b,000h		;7fe9
	ld h,b			;7feb
	ld l,b			;7fec
	dec de			;7fed
	inc c			;7fee
hueco_numero_cifra:
	dec c			;7fef
	jr z,hueco_numero_fin		;7ff0
	inc de			;7ff2
	ld a,(de)			;7ff3   ; la cifra
	cp 020h		;7ff4   ; un espacio?
	jr z,hueco_numero_espacio		;7ff6
	ld b,0ffh		;7ff8   ; ya hay cifras
	push de			;7ffa
	push af			;7ffb
	push bc			;7ffc
	add hl,hl			;7ffd   ; x 2...
	ld b,h			;7ffe
hueco_numero_x10:
	ld c,l			;7fff
	add hl,hl			;8000   ; ...x 4...
	add hl,hl			;8001   ; x 8
	add hl,bc			;8002   ; ...+ 1: x 10
	pop bc			;8003   ; la cuenta
	pop af			;8004   ; la cifra
	sub 030h		;8005   ; "0" = 0
	call hl_mas_a		;8007   ; + la cifra
	pop de			;800a
	jr hueco_numero_cifra		;800b   ; la siguiente
hueco_numero_fin:
	ld b,h			;800d   ; el numero
	ld c,l			;800e
	ret			;800f
hueco_numero_espacio:
	inc b			;8010   ; ya habia cifras?
	jr z,hueco_numero_fin		;8011   ; si: acaba
	jr hueco_numero_cifra		;8013   ; si no, sigue
numero_texto:		; El numero HL en C cifras (con ceros delante) a 0xF868, por las potencias de diez de 0xB13C
	ld de,0f868h		;8015   ; a 0xF868
	push bc			;8018
	push de			;8019
	ld a,005h		;801a   ; 5 - C
	sub c			;801c   ; 5 - las cifras
	push hl			;801d
	ld hl,0b13ch		;801e   ; las potencias de diez
	call tabla_salta		;8021   ; la potencia de diez de empezar
	ex (sp),hl			;8024   ; HL = el numero, la potencia en BC
	pop bc			;8025
numero_texto_cifra:
	ld a,(bc)			;8026   ; la potencia
	ld e,a			;8027   ; la potencia (palabra)
	inc bc			;8028
	ld a,(bc)			;8029
	ld d,a			;802a
	inc bc			;802b
	xor a			;802c   ; la cifra a 0
numero_texto_resta:
	sbc hl,de		;802d   ; se resta...
	jr c,numero_texto_pon		;802f   ; por debajo
	inc a			;8031   ; ...y se cuenta
	jr numero_texto_resta		;8032   ; otra vez
numero_texto_pon:
	add hl,de			;8034   ; la que sobra
	or 030h		;8035   ; en cifra
	ex (sp),hl			;8037   ; donde se escribe
	ld (hl),a			;8038   ; la cifra
	inc hl			;8039
	ex (sp),hl			;803a
	ld a,e			;803b   ; hasta 10
	cp 00ah		;803c   ; la ultima (10)?
	jr nz,numero_texto_cifra		;803e
	ld a,l			;8040   ; la ultima
	or 030h		;8041   ; las unidades
	pop de			;8043
	ld (de),a			;8044   ; escritas
	inc de			;8045
	pop bc			;8046
	ret			;8047
texto_pinta_f868:		; El texto de 0xF868 a la pantalla
	ld hl,0f868h		;8048   ; el texto
texto_pinta_hl:		; El texto de HL (hasta el 0) a la pantalla, letra a letra (0x8083)
	ld a,(hl)			;804b   ; la letra
	and a			;804c   ; el 0?
	ret z			;804d
	call letra_escribe		;804e   ; escrita
	inc hl			;8051
	jr texto_pinta_hl		;8052   ; la siguiente
texto_pinta_b:		; B letras de HL a la pantalla
	ld a,b			;8054   ; quedan?
	and a			;8055
	ret z			;8056
	ld a,(hl)			;8057   ; la letra
	call letra_escribe		;8058   ; escrita
	inc hl			;805b
	dec b			;805c   ; una menos
	jr texto_pinta_b		;805d
ram_pide:		; Pide BC bytes en DE de la zona de datos del juego (0x80B5): si no caben, "no hay memoria" (0x81BA); lo de detras se mueve (0x81C9), lo nuevo a 0 (0x80DD)
	call ram_cabe		;805f   ; caben?
	jp c,sin_memoria		;8062   ; no
	push bc			;8065
	push de			;8066
	push hl			;8067
	push af			;8068
	ex de,hl			;8069   ; el sitio
	ld hl,(0f7e7h)		;806a   ; el final de lo usado
	rst 20h			;806d   ; DCOMPR
	jr z,pops_af		;806e   ; al final: nada que mover
	push de			;8070   ; el sitio
	call ram_abre		;8071   ; lo de detras se mueve
	pop hl			;8074   ; el sitio
	call ram_cero		;8075   ; lo nuevo a 0
	jr pops_af		;8078   ; hecho
sprites_fuera_guarda:		; Los sprites fuera (sprites_todos_fuera) guardando BC, DE, HL y AF
	push bc			;807a
	push de			;807b
	push hl			;807c
	push af			;807d
	call sprites_todos_fuera		;807e   ; todos los sprites fuera
	jr pops_af		;8081
letra_escribe:		; La letra A en la posicion 0xFA1D y la columna siguiente (hasta la 0x1D); 0x0D salta a la fila siguiente, columna 4
	push bc			;8083
	push de			;8084
	push hl			;8085
	push af			;8086
	cp 00dh		;8087   ; 0x0D: fila nueva?
	jr z,letra_fila_nueva		;8089   ; fila nueva
	call letra_aqui		;808b   ; la letra
	ld a,(0fa1dh)		;808e   ; la columna
	cp 01dh		;8091   ; la ultima?
	jr z,letra_fila_nueva		;8093   ; la ultima columna: fila nueva
	inc a			;8095   ; la siguiente
	ld (0fa1dh),a		;8096   ; la posicion del cursor
pops_af:
	pop af			;8099
pops3_b:
	pop hl			;809a
	pop de			;809b
	pop bc			;809c
	ret			;809d
letra_fila_nueva:
	ld hl,(0fa1dh)		;809e   ; la posicion
	inc h			;80a1   ; la fila de abajo
	ld l,004h		;80a2   ; columna 4
	ld (0fa1dh),hl		;80a4   ; la posicion del cursor
	jr pops_af		;80a7   ; hecho
letra_aqui:		; La letra A en la posicion 0xFA1D (sin moverla)
	ld bc,(0fa1dh)		;80a9   ; la posicion
letra_en_bc:		; La letra A en la posicion BC (letra_pon guardando BC, DE y HL)
	push bc			;80ad
	push de			;80ae
	push hl			;80af
	call letra_pon		;80b0   ; la letra
	jr pops3_b		;80b3
ram_cabe:		; C si no caben BC bytes entre 0xF7E7 (el final de lo usado) y 0xF7EF (el mapa)
	push de			;80b5
	push hl			;80b6
	ld hl,(0f7efh)		;80b7   ; el principio del mapa...
	ld de,(0f7e7h)		;80ba   ; ...menos el final de lo usado
	sbc hl,de		;80be   ; lo libre
	ld d,a			;80c0   ; guardado
	call hl_igual_bc		;80c1   ; C si BC es mayor
	ld a,d			;80c4
	jr pops_de_hl		;80c5
fase_tamano:		; BC = lo que ocupa la fase de la historia (0x8581): la distancia entre su puntero (+4) y DE
	push af			;80c7
	call fase_iy_a		;80c8   ; IY = la fase
	pop af			;80cb
	push de			;80cc
	push hl			;80cd
	ex de,hl			;80ce   ; el puntero
	inc hl			;80cf   ; +4: el siguiente
	inc hl			;80d0
	inc hl			;80d1
	inc hl			;80d2
	call palabra_lee		;80d3   ; el puntero del siguiente
	sbc hl,de		;80d6   ; menos el de esta
	ld c,l			;80d8   ; BC = lo que ocupa
	ld b,h			;80d9
pops_de_hl:
	pop hl			;80da
	pop de			;80db
	ret			;80dc
ram_cero:		; BC bytes desde HL a 0
	push bc			;80dd
	push hl			;80de
ram_cero_uno:
	xor a			;80df   ; a 0
	ld (hl),a			;80e0
	inc hl			;80e1
	dec bc			;80e2   ; uno menos
	ld a,b			;80e3
	or c			;80e4
	jr nz,ram_cero_uno		;80e5
	pop hl			;80e7
	pop bc			;80e8
	ret			;80e9
fase_nueva:		; Una fase mas en la historia (0xF41F + 1): 0x5A bytes (0x805F), los punteros de la fase (0x8549, 0x819B) y los 17 punteros del juego (0x8182)
	push hl			;80ea
	ld hl,0f41fh		;80eb   ; el numero de fases
	inc (hl)			;80ee   ; una mas
	pop hl			;80ef
	call ram_pide		;80f0   ; sitio
	push hl			;80f3
	push de			;80f4
	push bc			;80f5
	call fase_cero		;80f6   ; a 0 y su zona
punteros_mueve:
	pop bc			;80f9
	pop de			;80fa
	pop hl			;80fb
	call fase_punteros		;80fc   ; los punteros de la fase
	jp punteros_suma		;80ff   ; y los del juego
ficha_nueva:		; La ficha del personaje A en la fase (0x8556): si no tiene, 0x2F bytes nuevos (+0x38 de IY, uno mas) y sus datos (0x84E0); si tiene, de otra clase (0xFA13 contra +1 de IX): el aviso 7 ("el personaje ya se usa") y al menu 0x47
	push af			;8102
	call ficha_busca_a		;8103   ; su ficha
	pop bc			;8106
	jr nc,ficha_clase		;8107   ; tiene
	ld bc,0002fh		;8109   ; 0x2F bytes
	call ram_pide		;810c   ; sitio
	inc (iy+038h)		;810f   ; una ficha mas en la fase
	push hl			;8112
	push de			;8113
	push bc			;8114
	call ficha_datos		;8115   ; sus datos
	jr punteros_mueve		;8118   ; los punteros
ficha_clase:
	ld a,(0fa13h)		;811a   ; la clase de personaje
	cp (ix+001h)		;811d   ; la misma clase?
	ret z			;8120   ; la misma: bien
ficha_usada:
	ld b,007h		;8121   ; el aviso 7
	call aviso		;8123   ; "el personaje ya se usa"
	ld sp,0f9f1h		;8126   ; la pila
	jp menu_quien		;8129   ; el menu 0x47
ficha_quita:		; Quita de la fase la ficha del personaje 0xFA12 (si es el de +0 de IX): su recorrido (0x869E), los 0x2F bytes (0x8165), +0x38 de IY uno menos y los punteros (0x819B, 0x815C)
	ld a,(0fa12h)		;812c   ; el personaje
	cp (ix+000h)		;812f   ; esta ficha?
	ret nz			;8132   ; no
	push ix		;8133
	call recorrido_busca		;8135   ; su recorrido
	ex de,hl			;8138
	ld a,(hl)			;8139   ; cuantos puntos
	call fase_devuelve_va		;813a   ; fuera
	pop hl			;813d
	ld bc,0002fh		;813e   ; 0x2F bytes
	call ram_quita		;8141   ; la ficha fuera
	dec (iy+038h)		;8144   ; una ficha menos
	call fase_punteros		;8147   ; los punteros de la fase
	jr punteros_resta		;814a   ; y los del juego, hacia atras
fase_borra:		; Borra los datos de la fase (0x80C7): si ocupa algo, lo quita (0x8165) y mueve los punteros hacia atras (0x815C)
	call fase_tamano		;814c   ; lo que ocupa
	ld a,c			;814f
	or b			;8150
	ret z			;8151   ; nada
	call ram_quita		;8152   ; fuera
	ex de,hl			;8155
	inc hl			;8156   ; +2
	inc hl			;8157
	call de_escribe		;8158   ; el puntero
	ex de,hl			;815b
punteros_resta:		; Los punteros del juego (0x8182) - BC
	ld a,b			;815c
	cpl			;815d
	ld b,a			;815e
	ld a,c			;815f
	cpl			;8160
	ld c,a			;8161
	inc bc			;8162   ; BC = -BC
	jr punteros_suma		;8163   ; los punteros
ram_quita:		; Quita BC bytes en HL de la zona de datos: lo de detras (hasta 0xF7E7) sube (0x8173)
	push bc			;8165
	push hl			;8166
	push de			;8167
	ld de,(0f7e7h)		;8168   ; el final de lo usado
	call ram_quita_va		;816c   ; sube
	pop de			;816f
	pop hl			;8170
ram_quita_fin:
	pop bc			;8171
	ret			;8172
ram_quita_va:
	push hl			;8173
	add hl,bc			;8174   ; lo que hay detras
	rst 20h			;8175   ; DCOMPR
	jr z,ram_quita_fin		;8176   ; al final: nada
	ex de,hl			;8178
	sbc hl,de		;8179   ; cuanto
	ld c,l			;817b
	ld b,h			;817c
	ex de,hl			;817d
	pop de			;817e
	ldir		;817f   ; sube
	ret			;8181
punteros_suma:		; Suma BC a los punteros del juego de DE en adelante hasta 0xF7E7
	ex de,hl			;8182
punteros_suma_uno:
	call puntero_suma		;8183   ; el puntero
	ld de,0f7e7h		;8186   ; hasta 0xF7E7
	ex de,hl			;8189   ; el siguiente
	rst 20h			;818a   ; DCOMPR
	ex de,hl			;818b
	jr nc,punteros_suma_uno		;818c   ; quedan?
	ret			;818e
puntero_suma:		; La palabra de HL + BC, escrita otra vez; HL + 2
	push hl			;818f
	call palabra_lee		;8190   ; el puntero
	add hl,bc			;8193   ; + BC
	ex de,hl			;8194
	pop hl			;8195
de_escribe:		; DE a (HL); HL + 2
	ld (hl),e			;8196   ; la parte baja
	inc hl			;8197
	ld (hl),d			;8198   ; la alta
	inc hl			;8199
	ret			;819a
fase_punteros:		; Los punteros de la fase de ahora (0x857E): + 0x3A y + 0x2F por cada ficha (+0x38 de IY), al puntero de la fase
	push bc			;819b
	call fase_iy		;819c   ; IY = la fase
	ld bc,0003ah		;819f   ; la primera ficha
	push hl			;81a2
	ld a,(iy+038h)		;81a3   ; cuantas
fase_punteros_uno:
	add hl,bc			;81a6   ; la siguiente
	and a			;81a7
	jr z,fase_punteros_pon		;81a8   ; la ultima?
	dec a			;81aa
	ld bc,0002fh		;81ab   ; 0x2F por ficha
	jr fase_punteros_uno		;81ae
fase_punteros_pon:
	ex de,hl			;81b0
	inc hl			;81b1   ; +2 del puntero de la fase
	inc hl			;81b2
	call de_escribe		;81b3   ; el final de las fichas
	pop de			;81b6
	pop bc			;81b7
	ex de,hl			;81b8
	ret			;81b9
sin_memoria:		; El aviso 5 ("no hay memoria"), sin escritura, y el menu de antes
	ld b,005h		;81ba   ; "no hay memoria"
aviso_y_atras:		; El aviso B y al menu de antes
	xor a			;81bc   ; sin escritura
	ld (0fe13h),a		;81bd   ; con escritura
	call aviso		;81c0   ; el aviso
	ld hl,(0fa27h)		;81c3   ; la pila de menus
	jp menu_atras_uno		;81c6   ; al menu de antes
ram_abre:		; Abre BC bytes en HL: lo que hay desde HL hasta DE baja (lddr)
	push bc			;81c9
	push hl			;81ca
	add hl,bc			;81cb   ; el final del sitio nuevo
	push hl			;81cc
	sbc hl,de		;81cd   ; lo que baja
	sbc hl,bc		;81cf
	ld c,l			;81d1
	ld b,h			;81d2
	pop de			;81d3
	pop hl			;81d4
	dec hl			;81d5
	dec de			;81d6
	lddr		;81d7   ; baja
	pop bc			;81d9
	ret			;81da
cursor_menu_baja:		; El cursor del menu una opcion abajo (B = 0) o arriba (0x81E0, B = 0xFF): de 2 en 2 filas (o 1 en el menu 0x21), y al pasar de la columna, a la otra (0x876B)
	push bc			;81db
	ld b,000h		;81dc   ; hacia abajo
	jr cursor_menu_va		;81de
cursor_menu_sube:
	push bc			;81e0
	ld b,0ffh		;81e1   ; hacia arriba
cursor_menu_va:
	ld a,c			;81e3
	ld (0fa41h),a		;81e4   ; la opcion
	ld c,0feh		;81e7   ; 2 filas hacia atras
	push de			;81e9
	ld hl,0150fh		;81ea   ; el limite: fila 0x15, columna 0x0F
	ld de,00302h		;81ed   ; y la otra: 3, 2
	ld a,(0fa1ch)		;81f0   ; la clase de eleccion
	cp 021h		;81f3   ; la lista de los sonidos?
	jr z,cursor_menu_dir		;81f5
	ld hl,01414h		;81f7   ; los personajes: 0x14, 0x14
	ld de,00505h		;81fa   ; 5, 5
	ld c,0fbh		;81fd   ; 5 filas
cursor_menu_dir:
	dec b			;81ff
	inc b			;8200   ; hacia abajo?
	jr nz,cursor_menu_mira		;8201
	ex de,hl			;8203   ; los limites al reves
	ld a,c			;8204
	neg		;8205   ; hacia abajo
	ld c,a			;8207
cursor_menu_mira:
	ld a,(0fa1eh)		;8208   ; la fila
	cp d			;820b   ; en el limite?
	jr nz,cursor_menu_fila		;820c   ; no: la fila siguiente
	ld d,h			;820e   ; la otra fila
	ld (0fa1eh),a		;820f   ; la fila del cursor
	ld a,(0fa1dh)		;8212   ; la columna
	cp e			;8215   ; en el limite?
	jr nz,cursor_menu_pon		;8216
	ld a,(0fa41h)		;8218   ; la opcion
	push hl			;821b
	inc b			;821c   ; hacia abajo?
	dec b			;821d
	jr z,cursor_menu_col		;821e
	sub 007h		;8220   ; 8 menos
cursor_menu_col:
	ld c,a			;8222   ; la de empezar
	call personajes_lista_otra		;8223   ; la otra pagina
	pop de			;8226
cursor_menu_pon:
	ld (0fa1dh),de		;8227   ; la posicion nueva
cursor_menu_fin:
	pop de			;822b
	pop bc			;822c
	ret			;822d
cursor_menu_fila:
	add a,c			;822e   ; la fila siguiente
	ld (0fa1eh),a		;822f   ; la fila del cursor
	jr cursor_menu_fin		;8232
menu_tecla5:		; La tecla 5 en el menu principal: busca un cartucho "CP" (0x4587) y vuelve al menu principal
	ld a,(0fa1ah)		;8234   ; el menu
	dec a			;8237   ; el principal?
	jr nz,menu_elige		;8238
	call cartucho_cp		;823a   ; el otro cartucho
	jp menu_principal_entra		;823d   ; al menu principal
menu_elige:		; La eleccion de un menu: el cursor (0x9B51), una tecla y lo de 0x9ACC: arriba (0x10) y abajo (0x14) mueven el cursor (C la opcion); 0x0F vuelve; la barra (0x0E) en los menus 0x8D y 0x8E, 0x9A91; 5 en el menu 1, el cartucho
	push bc			;8240
	push de			;8241
	call menu_opcion_guarda		;8242   ; la opcion
	ld a,001h		;8245   ; el cursor de flecha
	ld (0fa37h),a		;8247   ; la clase de cursor
	call tecla_espera_texto		;824a   ; una tecla
	and 03fh		;824d   ; sin los bits de arriba
	push af			;824f
	call sonido_tecla_para		;8250   ; el sonido se para
	pop af			;8253
	pop de			;8254
	pop bc			;8255
	cp 005h		;8256   ; la 5?
	jr z,menu_tecla5		;8258   ; la tecla 5
	cp 00fh		;825a   ; volver: la opcion
	ret z			;825c   ; volver: la opcion
	cp 010h		;825d   ; arriba?
	jr z,menu_elige_sube		;825f   ; arriba
	cp 014h		;8261   ; abajo?
	jr z,menu_elige_baja		;8263   ; abajo
	cp 00eh		;8265   ; la barra?
	jr nz,menu_elige		;8267   ; no es la barra
	ld a,(0fa1ah)		;8269   ; el menu
	cp 08fh		;826c   ; el 0x8F: no
	jr z,menu_elige		;826e
	cp 08dh		;8270   ; el 0x8D o el 0x8E?
	jr c,menu_elige		;8272
	push bc			;8274
	push de			;8275
	call sonido_prueba		;8276   ; que suene la muestra
	pop de			;8279
	pop bc			;827a
	jr menu_elige		;827b
menu_elige_sube:
	ld a,(0fa1ch)		;827d   ; la clase de eleccion
	cp 080h		;8280   ; 0x80 o mas: un menu
	ld a,c			;8282
	jr nc,menu_elige_sube2		;8283
	and a			;8285   ; 0?
	jr z,menu_elige		;8286
	dec a			;8288   ; la primera?
	jr z,menu_elige_sube3		;8289
	dec c			;828b   ; una menos
	call cursor_menu_sube		;828c   ; el cursor
	jr menu_elige		;828f
menu_elige_sube2:
	dec a			;8291   ; la primera?
	jr z,menu_elige		;8292
menu_elige_sube3:
	ld a,(0fa1ch)		;8294   ; la clase
	cp 020h		;8297   ; 0x20?
	jr z,menu_elige		;8299
	dec c			;829b   ; una menos
	ld hl,0fa1eh		;829c   ; la fila...
	dec (hl)			;829f   ; ...2 menos
	dec (hl)			;82a0
	jr menu_elige		;82a1
menu_elige_baja:
	ld a,c			;82a3   ; la opcion
	cp d			;82a4   ; la ultima?
	jr z,menu_elige		;82a5
	inc c			;82a7   ; una mas
	ld a,(0fa1ch)		;82a8   ; la clase
	cp 080h		;82ab   ; un menu?
	jr c,menu_elige_baja2		;82ad
	ld hl,0fa1eh		;82af   ; la fila...
	inc (hl)			;82b2   ; ...2 mas
	inc (hl)			;82b3
	jr menu_elige		;82b4
menu_elige_baja2:
	call cursor_menu_baja		;82b6   ; el cursor
	jr menu_elige		;82b9
cursor_parpadea:		; El parpadeo del cursor (por 0xFE70, de 16 en 16 cuadros, con 0xFA05): en las pantallas con sprite (0xFA37 de 4 o mas), su color 15, 1 o 0 en la tabla de atributos; si no, la letra del cursor
	ld a,(0fe70h)		;82bb   ; la cuenta del parpadeo
	cp 010h		;82be   ; 16 o mas: nada
	ret nc			;82c0
	ld b,a			;82c1   ; la cuenta
	ld a,(0fa05h)		;82c2   ; el parpadeo
	and a			;82c5   ; apagado?
	ret z			;82c6
	ld a,(0fa37h)		;82c7   ; la clase de cursor
	cp 004h		;82ca   ; un sprite?
	jr c,cursor_parpadea_letra		;82cc
	ld c,a			;82ce
	ld a,b			;82cf   ; la cuenta
	sub 003h		;82d0   ; antes de la 3?
	ld a,00fh		;82d2   ; color 15
	jr c,cursor_parpadea_sprite		;82d4
	ld a,001h		;82d6   ; en la 3: color 1
	jr z,cursor_parpadea_sprite		;82d8
	xor a			;82da   ; despues: 0
cursor_parpadea_sprite:
	ld b,a			;82db
	ld hl,(0fa41h)		;82dc   ; el sprite guardado
	ld a,(0fa1ah)		;82df   ; el menu
	cp 048h		;82e2   ; el del recorrido?
	ld a,000h		;82e4
	jr z,cursor_parpadea_pon		;82e6
	ld hl,03b80h		;82e8   ; la tabla de atributos
	ld a,c			;82eb   ; el sprite...
	add a,a			;82ec   ; ...x 4
	add a,a			;82ed
cursor_parpadea_pon:
	add a,003h		;82ee   ; el byte 3: el color
	call hl_mas_a		;82f0
	ld a,b			;82f3   ; el color
	jp 0004dh		;82f4   ; WRTVRM
cursor_parpadea_letra:
	ld a,b			;82f7   ; la cuenta
	sub 003h		;82f8   ; antes de la 3?
	ld a,(0fa18h)		;82fa   ; la letra de debajo
	jr nc,cursor_letra		;82fd   ; si
	ld bc,(0fa1dh)		;82ff   ; la posicion del cursor
	ld hl,(0fa23h)		;8303   ; la de antes
	ex af,af'			;8306   ; guardado
	call hl_igual_bc		;8307   ; la misma?
	jr z,cursor_letra_pon		;830a   ; la misma
	ex af,af'			;830c   ; la cuenta
	ld c,l			;830d   ; la de antes
	ld b,h			;830e
	call letra_pon		;830f   ; la letra de antes, otra vez
	call cursor_debajo		;8312   ; la de debajo del cursor
cursor_letra_pon:
	ld a,(0fa37h)		;8315   ; la clase de cursor
	dec a			;8318   ; la flecha?
	ld a,03eh		;8319   ; la flecha (0x3E)...
	jr z,cursor_letra		;831b   ; si
	ld a,008h		;831d   ; ...o el cuadro (8)
cursor_letra:
	ld bc,(0fa1dh)		;831f   ; la posicion del cursor
	ld (0fa23h),bc		;8323   ; apuntada
	jp letra_pon		;8327   ; la letra
cursor_debajo:		; La letra que hay en la pantalla de texto bajo el cursor (0xFA1D) a 0xFA18
	ld bc,(0fa1dh)		;832a   ; la posicion del cursor
	ld hl,03be0h		;832e   ; la pantalla de texto, una fila antes
	inc b			;8331   ; la fila + 1
	ld de,00020h		;8332   ; 32 por fila
cursor_debajo_fila:
	add hl,de			;8335   ; + 32
	djnz cursor_debajo_fila		;8336
	ld a,c			;8338   ; la columna...
	inc a			;8339   ; ...+ 1
	call hl_mas_a		;833a   ; la posicion
	call 0004ah		;833d   ; RDVRM
	ld (0fa18h),a		;8340   ; la letra bajo el cursor
nada:
	ret			;8343
cursor_apaga:		; Sin parpadeo (0xFA05 = 0): en las pantallas con sprite, fuera (0xC1); si no, la letra de debajo otra vez
	ld bc,(0fa1dh)		;8344   ; la posicion del cursor
	xor a			;8348   ; 0
	ld (0fa05h),a		;8349   ; el parpadeo del cursor
	ld a,(0fa37h)		;834c   ; la clase de cursor
	cp 004h		;834f   ; un sprite?
	ld h,0c1h		;8351   ; Y 0xC1: fuera
	jr nc,sprite_en		;8353   ; el sprite fuera
	ld a,(0fa18h)		;8355   ; la letra bajo el cursor
	jp letra_pon		;8358   ; la letra
cursor_cuenta:		; 0xFA05 uno menos y la rutina de 0xFA37 en la tabla 0xB164
	ld hl,0fa05h		;835b   ; el parpadeo
	ld a,(0fa37h)		;835e   ; la clase de cursor
	dec (hl)			;8361   ; uno menos
	ld hl,0b164h		;8362   ; la tabla de cursores
	jp salta_tabla		;8365   ; la rutina de la clase
cursor_flecha:		; La flecha (0x3E; desde 0x836B, el cuadro 8) en el cursor
	ld a,03eh		;8368
	ld bc,0083eh		;836a   ; desde 0x836B, el cuadro 8
	push af			;836d
	call cursor_debajo		;836e   ; la letra de debajo
	pop af			;8371
	jr cursor_letra		;8372   ; la nueva
punto_sprite:		; El sprite A (4; desde cada "ld bc" siguiente, 5, 6, 7, 8 o 9) en la posicion 0xFA1F (0x8388)
	ld a,004h		;8374   ; 4; desde 0x8377, 5; 0x837A, 6; 0x837D, 7; 0x8380, 8; 0x8383, 9
	ld bc,0053eh		;8376
	ld bc,0063eh		;8379
	ld bc,0073eh		;837c
	ld bc,0083eh		;837f
	ld bc,0093eh		;8382
	ld hl,(0fa1fh)		;8385   ; el punto
sprite_en:		; El sprite A en la posicion HL + 8 (Y - 1, X), con el dibujo 0x80 + A x 4 y color 15; en la tabla de atributos (o en 0xFA41 en el menu 0x48)
	ld bc,00008h		;8388   ; + 8
	add hl,bc			;838b   ; la posicion
	add a,a			;838c   ; el sprite...
	add a,a			;838d   ; ...x 4
	ld e,a			;838e
	ld c,l			;838f   ; la posicion
	ld b,h			;8390
	ld hl,(0fa41h)		;8391   ; en el menu 0x48...
	ld a,(0fa1ah)		;8394   ; el menu
	cp 048h		;8397   ; el menu del recorrido?
	jr z,sprite_en_va		;8399
	ld hl,03b80h		;839b   ; ...si no, la tabla de atributos
	ld a,e			;839e   ; el sprite
	call hl_mas_a		;839f
sprite_en_va:
	ld a,b			;83a2   ; la Y...
	dec a			;83a3   ; ...- 1
	call 0004dh		;83a4   ; WRTVRM: la Y
	inc hl			;83a7   ; el byte 1
	ld a,c			;83a8   ; la X
	call 0004dh		;83a9   ; WRTVRM: la X
	inc hl			;83ac   ; el byte 2
	ld a,e			;83ad   ; el sprite...
	add a,080h		;83ae   ; ...+ 0x80: el dibujo
	call 0004dh		;83b0   ; WRTVRM: el dibujo
	inc hl			;83b3   ; el byte 3
	ld a,00fh		;83b4   ; color 15
	jp 0004dh		;83b6   ; WRTVRM
fichas_recorre:		; Para cada ficha de la fase (IY + 0x3A, de 0x2F en 0x2F, +0x38 de IY cuantas), la rutina C (1; desde cada "ld bc" siguiente, 2 a 9) de la tabla 0xB142, con IX en la ficha
	ld a,001h		;83b9   ; 1; desde 0x83BC, 2; 0x83BF, 3; ... 0x83D1, 9
	ld bc,0023eh		;83bb
	ld bc,0033eh		;83be
	ld bc,0043eh		;83c1
	ld bc,0053eh		;83c4
	ld bc,0063eh		;83c7
	ld bc,0073eh		;83ca
	ld bc,0083eh		;83cd
	ld bc,0093eh		;83d0
	ld c,a			;83d3   ; la rutina
	push ix		;83d4   ; IX guardado
	push iy		;83d6   ; la fase...
	pop ix		;83d8   ; IX = la fase
	ld b,(iy+038h)		;83da   ; cuantas fichas
	ld de,0003ah		;83dd   ; la primera
	inc b			;83e0   ; + 1
fichas_recorre_uno:
	add ix,de		;83e1   ; la ficha siguiente
	dec b			;83e3   ; una menos
	jr z,fichas_recorre_fin		;83e4   ; todas
	call ficha_rutina		;83e6   ; la rutina
	ld de,0002fh		;83e9   ; 0x2F
	jr fichas_recorre_uno		;83ec
fichas_recorre_fin:
	pop ix		;83ee   ; IX
	ret			;83f0
ficha_rutina:		; La rutina C de la tabla 0xB142 para la ficha IX
	push ix		;83f1
	push bc			;83f3
	ld hl,0b142h		;83f4   ; la tabla de las rutinas de las fichas
	ld a,c			;83f7   ; la rutina C
	call salta_tabla		;83f8   ; a ella
	pop bc			;83fb
	pop ix		;83fc
	ret			;83fe
ficha_cero2:		; +2 de IX a 0
	xor a			;83ff   ; parada
	ld (ix+002h),a		;8400   ; parada
	ret			;8403
ficha_posicion:		; La posicion DE a +0x1C de la ficha; / 64 (0x841A) a +0x15 y +8
	ld (ix+01ch),e		;8404   ; el reloj
	ld (ix+01dh),d		;8407
	call entre64		;840a   ; / 64
	ld (ix+015h),e		;840d   ; a +0x15
	ld (ix+016h),d		;8410
	ld (ix+008h),e		;8413   ; y a +8
	ld (ix+009h),d		;8416
	ret			;8419
entre64:		; DE / 64
	srl d		;841a   ; / 2
	rr e		;841c
	srl d		;841e   ; / 4
	rr e		;8420
	srl d		;8422   ; / 8
	rr e		;8424
	srl d		;8426   ; / 16
	rr e		;8428
	srl d		;842a   ; / 32
	rr e		;842c
	srl d		;842e   ; / 64
	rr e		;8430
	ret			;8432
personaje_quita:		; Quita el personaje: sus sprites (0x4961), su registro de 21 bytes de 0xF512 (los de detras suben); si era el protagonista, 0xF419 = 0; 0xF420 uno menos; en las 8 fases, las fichas que lo usan se arreglan (0x83CE, 0x83C8)
	call objeto_hueco		;8433   ; sus sprites
personaje_quita_va:
	call personaje_ficha		;8436   ; su registro
	ld a,(hl)			;8439   ; su clase
	ld (0fa13h),a		;843a   ; la clase de personaje
	dec a			;843d   ; el protagonista?
	jr nz,personaje_quita_ficha		;843e
	ld (0f419h),a		;8440   ; sin protagonista
personaje_quita_ficha:
	ld bc,00015h		;8443   ; 21 bytes
	ld de,0f7c7h		;8446   ; desde 0xF7C7
	call ram_quita_va		;8449   ; los de detras suben
	ld hl,0f420h		;844c   ; uno menos
	dec (hl)			;844f   ; uno menos
	ld b,008h		;8450   ; 8 fases
	xor a			;8452   ; desde la fase 1
personaje_quita_fase:
	inc a			;8453   ; la siguiente
	ld (0fa08h),a		;8454   ; la fase
	push af			;8457
	push bc			;8458
	call fase_hay		;8459   ; tiene datos?
	jr z,personaje_quita_sig		;845c   ; sin datos
	call fichas_rutina_8		;845e   ; la ficha se quita (rutina 8)
	call fichas_rutina_6		;8461   ; los numeros bajan (rutina 6)
personaje_quita_sig:
	pop bc			;8464
	pop af			;8465
	djnz personaje_quita_fase		;8466   ; las 8
	ret			;8468
ficha_baja:		; En la ficha IX: los numeros de personaje por encima del quitado (0xFA12) bajan uno (+0, +3 y +0x11); los iguales, a 0
	ld a,(0fa12h)		;8469   ; el personaje
	push ix		;846c   ; el registro de la ficha
	pop hl			;846e
	cp (hl)			;846f   ; el personaje: por encima del quitado?
	jr nc,ficha_baja_3		;8470
	dec (hl)			;8472   ; uno menos
ficha_baja_3:
	ld de,00003h		;8473   ; +3: el dibujo de vencido
	add hl,de			;8476
	cp (hl)			;8477   ; el quitado?
	jr nz,ficha_baja_3b		;8478
	ld (hl),000h		;847a   ; a 0
ficha_baja_11:
	ld de,0000eh		;847c   ; +0x11: el arma
	add hl,de			;847f
	cp (hl)			;8480   ; el quitado?
	jr nz,ficha_baja_fin		;8481
	ld (hl),000h		;8483   ; a 0
	ret			;8485
ficha_baja_fin:
	ret nc			;8486   ; por debajo: nada
	dec (hl)			;8487   ; uno menos
	ret			;8488
ficha_baja_3b:
	jr nc,ficha_baja_11		;8489   ; por debajo: nada
	dec (hl)			;848b   ; uno menos
	jr ficha_baja_11		;848c
sonido_quita:		; Quita el sonido A: en 0xF41D y 0xF41E (los de la historia) y en +0x23 y +0x24 de cada fase, a 0; y en las fichas (0x83CB)
	ld (0fa41h),a		;848e   ; el sonido
	ld hl,0f41dh		;8491   ; la musica del principio
	cp (hl)			;8494   ; es este?
	jr nz,sonido_quita_va		;8495
	ld (hl),000h		;8497   ; a 0
sonido_quita_va:
	inc hl			;8499   ; la del final
	cp (hl)			;849a
	jr nz,sonido_quita_fases		;849b
	ld (hl),000h		;849d   ; a 0
sonido_quita_fases:
	ld a,(0f41fh)		;849f   ; cuantas fases hay
	and a			;84a2   ; ninguna fase
	ret z			;84a3
	ld b,a			;84a4   ; cuantas
	xor a			;84a5   ; desde la 1
sonido_quita_fase:
	inc a			;84a6   ; la siguiente
	push af			;84a7
	push bc			;84a8
	call fase_hay		;84a9   ; tiene datos?
	jr z,sonido_quita_sig		;84ac   ; no
	ld a,(0fa41h)		;84ae   ; el sonido
	cp (iy+023h)		;84b1   ; el de la fase?
	jr nz,sonido_quita_24		;84b4
	ld (iy+023h),000h		;84b6   ; a 0
sonido_quita_24:
	cp (iy+024h)		;84ba   ; el otro?
	jr nz,sonido_quita_fichas		;84bd
	ld (iy+024h),000h		;84bf   ; a 0
sonido_quita_fichas:
	call fichas_rutina_7		;84c3   ; el sonido se quita (rutina 7)
sonido_quita_sig:
	pop bc			;84c6
	pop af			;84c7
	djnz sonido_quita_fase		;84c8   ; las fases
	ret			;84ca
ficha_sonido_quita:		; En la ficha IX, el sonido 0xFA41 en +9 (y +4) y en +0x0A, a 0
	ld a,(0fa41h)		;84cb   ; el sonido
	cp (ix+009h)		;84ce   ; +9?
	jr nz,ficha_sonido_quita_b		;84d1
	ld (ix+004h),000h		;84d3   ; +4 a 0
ficha_sonido_quita_b:
	cp (ix+00ah)		;84d7   ; +0x0A?
	ret nz			;84da
	ld (ix+00ah),000h		;84db   ; a 0
	ret			;84df
ficha_datos:		; Los datos de una ficha nueva: el personaje (0xFA12) y su clase (0xFA13), +0x0B = 5, los limites (0x853A, 0x853F), la vida +0x19 (1 el protagonista, 3 los demas), +0x21 = 2 y la velocidad +0x1B = 2
	ld a,(0fa12h)		;84e0   ; el personaje
	ld (hl),a			;84e3   ; el personaje
	ld a,(0fa13h)		;84e4   ; la clase de personaje
	push af			;84e7   ; la clase
	inc hl			;84e8   ; +1
	ld (hl),a			;84e9   ; su clase
	ld (ix+00bh),005h		;84ea   ; 5
	call ficha_zona_c		;84ee   ; la zona +0x0C
	call ficha_zona_22		;84f1   ; la zona +0x22
	ld b,001h		;84f4   ; 1 el protagonista
	pop af			;84f6
	cp b			;84f7   ; el protagonista?
	jr z,ficha_datos_va		;84f8
	ld b,003h		;84fa   ; los demas: 3
ficha_datos_va:
	ld (ix+019h),b		;84fc   ; +0x19
	ld (ix+021h),002h		;84ff   ; el paso
	ld (ix+01bh),002h		;8503   ; la velocidad
	ret			;8507
zona_pon:		; Una zona en la ficha (HL + BC de IX): el principio BC y el final DE, recortado (0xF0) con dos de ancho o de alto segun la forma
	push hl			;8508
	push ix		;8509   ; la ficha...
	pop hl			;850b
	add hl,bc			;850c   ; ...+ el campo
	pop bc			;850d
zona_pon_va:
	call bc_escribe		;850e   ; el principio
	push hl			;8511
	call personaje_forma_lee		;8512   ; la forma
	pop hl			;8515
	push af			;8516
	rrca			;8517   ; dos de ancho?
	jr nc,zona_pon_alto		;8518
	ld a,0f0h		;851a   ; 16 menos en X
	add a,e			;851c
	ld e,a			;851d
zona_pon_alto:
	pop af			;851e
	cp 002h		;851f   ; dos de alto?
	jr c,zona_pon_fin		;8521
	ld a,0f0h		;8523   ; 16 menos en Y
	add a,d			;8525
	ld d,a			;8526
zona_pon_fin:
	ld (hl),e			;8527   ; el final
	inc hl			;8528
	ld (hl),d			;8529
	ret			;852a
fase_zona:		; La zona de la fase (+0x34 de IY): de 0x6000 a 0x50A0
	ld bc,00034h		;852b   ; +0x34 de la fase
	push iy		;852e
	pop hl			;8530
	add hl,bc			;8531
	ld bc,06000h		;8532   ; de 0x00, 0x60...
	ld de,050a0h		;8535   ; ...a 0xA0, 0x50
	jr zona_pon_va		;8538
ficha_zona_c:		; La zona +0x0C de la ficha: 0, 0 a 0xB0A0
	ld bc,0000ch		;853a   ; +0x0C
	jr ficha_zona_va		;853d
ficha_zona_22:		; La zona +0x22 de la ficha: 0, 0 a 0xB0A0
	ld bc,00022h		;853f   ; +0x22
ficha_zona_va:
	ld h,b			;8542   ; desde 0, 0
	ld l,b			;8543
	ld de,0b0a0h		;8544   ; hasta 0xA0, 0xB0
	jr zona_pon		;8547
fase_cero:		; C bytes de la fase a 0, +0x0C = 1 y su zona (0x852B)
	ld b,c			;8549   ; C bytes
	call cero_b		;854a   ; a 0
	ld (iy+00ch),001h		;854d   ; el fondo 1
	jr fase_zona		;8551   ; la zona
ficha_busca:		; IX = la ficha del personaje 0xFA12 en la fase 0xFA08 (C si no esta)
	ld a,(0fa12h)		;8553   ; el personaje
ficha_busca_a:		; IX = la ficha del personaje A en la fase (las fichas de IY + 0x3A, de 0x2F en 0x2F, ordenadas: C si no esta)
	ld b,a			;8556   ; el personaje
	call fase_iy		;8557   ; IY = la fase
	ld a,(iy+038h)		;855a   ; cuantas fichas
	inc a			;855d
	ex af,af'			;855e
	push de			;855f
	ld de,0003ah		;8560   ; la primera
	ld c,000h		;8563   ; la posicion
ficha_busca_uno:
	add hl,de			;8565   ; la siguiente
	inc c			;8566
	ex af,af'			;8567
	dec a			;8568   ; quedan?
	pop de			;8569
	scf			;856a   ; C: no esta
	jr z,ficha_busca_fin		;856b
	ex af,af'			;856d
	ld a,b			;856e   ; el personaje
	cp (hl)			;856f   ; por debajo: no esta
	jr c,ficha_busca_fin		;8570
	jr z,ficha_busca_fin		;8572   ; este
	push de			;8574
	ld de,0002fh		;8575   ; 0x2F por ficha
	jr ficha_busca_uno		;8578
ficha_busca_fin:
	push hl			;857a   ; IX = la ficha
	pop ix		;857b
	ret			;857d
fase_iy:		; IY = los datos de la fase 0xFA08 (su puntero en 0xF7C7 + (fase - 1) x 2); DE = donde esta el puntero
	ld a,(0fa08h)		;857e   ; la fase
fase_iy_a:
	ld hl,0f7c7h		;8581   ; los punteros de las fases
	dec a			;8584   ; desde 0
	add a,a			;8585   ; x 2
	call tabla_salta		;8586   ; su sitio
	push hl			;8589
	call palabra_lee		;858a   ; el puntero
	pop de			;858d
	push hl			;858e   ; IY = la fase
	pop iy		;858f
	ret			;8591
fase_hay:		; Z si la fase A no tiene datos (su puntero igual que el de la siguiente)
	call fase_iy_a		;8592   ; la fase
	push hl			;8595
	push de			;8596
	ex de,hl			;8597   ; el siguiente puntero
	inc hl			;8598
	inc hl			;8599
	call palabra_lee		;859a   ; su valor
	rst 20h			;859d   ; DCOMPR
	pop de			;859e
	pop hl			;859f
	ret			;85a0
sitio_elige:		; DONDE SALE (aviso 0x13): dos cruces que marcan la zona (de 0xFA1F a 0xFA21, dentro de los limites 0xFA49-0xFA50 segun la forma): se mueven con los cursores y se dejan con la barra; a +0x0C/+0x0E de la ficha
	ld hl,00000h		;85a1
	ld (0fa49h),hl		;85a4   ; los limites: de 0, 0...
	ld hl,00808h		;85a7   ; limites de la primera
	ld (0fa4dh),hl		;85aa   ; ...a 8, 8
	ld hl,0b0a0h		;85ad   ; 0xB0A0
	ld (0fa4bh),hl		;85b0   ; la segunda: de 0xA0, 0xB0...
	ld hl,0b8a8h		;85b3   ; 0xB8A8
	ld (0fa4fh),hl		;85b6   ; ...a 0xA8, 0xB8
	ld l,(ix+00ch)		;85b9   ; la primera cruz
	ld h,(ix+00dh)		;85bc   ; la cruz de arriba
	ld (0fa1fh),hl		;85bf   ; el punto
	call personaje_forma_lee		;85c2   ; la forma
	push af			;85c5   ; la forma
	ld b,a			;85c6
	ld l,(ix+00eh)		;85c7   ; la segunda cruz
	ld h,(ix+00fh)		;85ca   ; la de abajo
	cp 002h		;85cd   ; dos de alto?
	ld a,008h		;85cf   ; 8
	jr c,sitio_elige_y		;85d1
	ld a,0a0h		;85d3   ; 0xA0
	ld (0fa4ch),a		;85d5
	ld a,018h		;85d8   ; 0x18
sitio_elige_y:
	ld (0fa4eh),a		;85da   ; el limite
	add a,h			;85dd   ; + la Y
	ld h,a			;85de
	bit 0,b		;85df   ; dos de ancho?
	ld a,008h		;85e1   ; 8
	jr z,sitio_elige_x		;85e3
	ld a,090h		;85e5   ; 0x90
	ld (0fa4bh),a		;85e7
	ld a,018h		;85ea   ; 0x18
sitio_elige_x:
	ld (0fa4dh),a		;85ec   ; el limite
	add a,l			;85ef   ; + la X
	ld l,a			;85f0
	ld (0fa21h),hl		;85f1   ; la segunda cruz
sitio_elige_bucle:
	call cruces_pinta		;85f4   ; las cruces
	ld bc,00004h		;85f7   ; 4 bytes
	ld de,0fa51h		;85fa   ; los limites
	ld hl,0fa49h		;85fd   ; los limites de la primera
	ldir		;8600   ; de la primera
	ld a,005h		;8602   ; el sprite 5
	call tecla_numero		;8604   ; la mueve
	jr c,sitio_elige_mira		;8607   ; volver
	call cruces_pinta		;8609   ; las cruces
	ld bc,00004h		;860c   ; 4 bytes
	ld de,0fa51h		;860f
	ld hl,0fa4dh		;8612   ; los de la segunda
	ldir		;8615
	ld hl,(0fa1fh)		;8617   ; el punto
	push hl			;861a   ; guardado
	ld hl,(0fa21h)		;861b   ; la segunda
	ld (0fa1fh),hl		;861e   ; el punto
	ld a,006h		;8621   ; el sprite 6
	call tecla_numero		;8623   ; la mueve
	ld hl,(0fa1fh)		;8626   ; la segunda
	ld (0fa21h),hl		;8629   ; la segunda cruz
	pop hl			;862c   ; la primera
	ld (0fa1fh),hl		;862d   ; el punto
	jr nc,sitio_elige_bucle		;8630   ; otra vez
sitio_elige_mira:
	ld hl,(0fa21h)		;8632   ; la segunda
	pop af			;8635
	push af			;8636
	cp 002h		;8637   ; dos de alto?
	ld a,0f8h		;8639   ; - 8
	jr c,sitio_elige_x2		;863b
	ld a,0e8h		;863d   ; - 0x18
sitio_elige_x2:
	add a,h			;863f
	ld h,a			;8640
	pop af			;8641
	push af			;8642
	bit 0,a		;8643   ; dos de ancho?
	ld a,0f8h		;8645   ; - 8
	jr z,sitio_elige_fin		;8647
	ld a,0e8h		;8649   ; - 0x18
sitio_elige_fin:
	add a,l			;864b
	ld l,a			;864c
	ld bc,(0fa1fh)		;864d   ; la primera
	ld a,h			;8651
	cp b			;8652   ; por debajo?
	jr c,sitio_elige_bucle		;8653   ; la segunda antes que la primera?
	ld a,l			;8655
	cp c			;8656   ; por debajo?
	jr c,sitio_elige_bucle		;8657   ; otra vez
	pop af			;8659
	ld (ix+00ch),c		;865a   ; guardadas
	ld (ix+00dh),b		;865d   ; guardadas
	ld (ix+00eh),l		;8660
	ld (ix+00fh),h		;8663
	ret			;8666
cruces_pinta:		; Las dos cruces: la de 0xFA1F (sprite 5) y la de 0xFA21 (sprite 6)
	call punto_sprite_5		;8667   ; la cruz 5
	ld hl,(0fa21h)		;866a   ; la segunda
	jp sonido_uno		;866d   ; la cruz 6
recorrido_nuevo:		; Un recorrido nuevo: el viejo se quita (0x86A7), 2 y 16 bytes (0x8679)
	call recorrido_quita		;8670
	ld (hl),002h		;8673   ; 2 puntos
	inc hl			;8675
	ld bc,00010h		;8676   ; 16 bytes
fase_pide:		; BC bytes mas en la fase (desde el puntero de la siguiente, 0x8682), los punteros movidos
	call fase_siguiente		;8679   ; el puntero de la siguiente
	call ram_pide		;867c   ; sitio
	jp punteros_suma		;867f   ; los punteros
fase_siguiente:		; DE = el puntero de la fase siguiente (0xF7C7 + fase x 2)
	push af			;8682
	push hl			;8683
	ld hl,0f7c7h		;8684
	ld a,(0fa08h)		;8687   ; la fase
	add a,a			;868a   ; x 2
	call tabla_salta		;868b   ; su sitio
	ex de,hl			;868e
	pop hl			;868f
	pop af			;8690
	ret			;8691
fase_devuelve:		; A x 8 bytes menos en HL y los punteros movidos
	add a,a			;8692   ; x 8
	add a,a			;8693
	add a,a			;8694
	ld c,a			;8695
	ld b,000h		;8696
	call ram_quita		;8698   ; fuera
	jp punteros_resta		;869b   ; los punteros
fase_devuelve_va:
	call fase_siguiente		;869e
	push de			;86a1
	call fase_devuelve		;86a2
	pop de			;86a5
	ret			;86a6
recorrido_quita:		; Quita el recorrido de la ficha (0x86BB): su cuenta a 0 y sus puntos (0x869E)
	call recorrido_busca		;86a7   ; el recorrido
	ex de,hl			;86aa
	ld a,(hl)			;86ab   ; cuantos
	and a			;86ac
	ret z			;86ad   ; ninguno
	ld (hl),000h		;86ae   ; a 0
	push hl			;86b0
	inc hl			;86b1
	call fase_devuelve_va		;86b2   ; fuera
	pop hl			;86b5
	ret			;86b6
recorrido_c:		; El recorrido C de la fase
	push bc			;86b7
	push af			;86b8
	jr recorrido_busca_va		;86b9
recorrido_busca:		; El recorrido del personaje 0xFA12 en la fase (desde +2 de los datos, saltando los de antes: cuenta x 8 + 1): DE y 0xFA0E
	push bc			;86bb
	push af			;86bc
	ld a,(0fa12h)		;86bd   ; el personaje
	ld c,a			;86c0   ; cual
recorrido_busca_va:
	call fase_iy		;86c1   ; IY = la fase
	ex de,hl			;86c4
	inc hl			;86c5   ; +2
	inc hl			;86c6
	call palabra_lee		;86c7   ; el principio de los recorridos
recorrido_busca_uno:
	push hl			;86ca
	ld a,(hl)			;86cb   ; cuantos puntos
	inc hl			;86cc
	add a,a			;86cd   ; x 4...
	add a,a			;86ce
	call tabla_salta		;86cf   ; ...x 2 + 1: el siguiente
	pop de			;86d2
	dec c			;86d3   ; hasta el C
	jr nz,recorrido_busca_uno		;86d4
	pop af			;86d6
	pop bc			;86d7
	ld (0fa0eh),de		;86d8   ; apuntado
	ret			;86dc
personaje_ficha:		; HL = el registro del personaje 0xFA12 (0xF512 + n x 21)
	ld a,(0fa12h)		;86dd   ; el personaje
personaje_ficha_a:		; HL = el registro del personaje A
	ld hl,0f512h		;86e0   ; los registros (desde 1)
	push de			;86e3
	ld de,00015h		;86e4   ; 21 bytes
	push bc			;86e7
	ld b,a			;86e8   ; el personaje
personaje_ficha_uno:
	add hl,de			;86e9   ; el siguiente
	djnz personaje_ficha_uno		;86ea
	pop bc			;86ec
	pop de			;86ed
	ret			;86ee
personaje_forma_lee:		; A = la forma del personaje 0xFA12 (+1 de su registro)
	ld a,(0fa12h)		;86ef   ; el personaje
personaje_forma_a:
	call personaje_ficha_a		;86f2
	inc hl			;86f5   ; +1
	ld a,(hl)			;86f6   ; la forma
	ret			;86f7
personaje_elige:		; Elegir un personaje en el menu A (0x8774: la lista con sus dibujos, de 8 en 8 en dos columnas); el cursor en el C
	ld (0fa1ah),a		;86f8   ; el menu
personaje_elige_va:
	call personajes_lista		;86fb   ; la lista
	ld a,c			;86fe   ; el elegido
	and a			;86ff
	jr z,personaje_elige_col		;8700
	dec a			;8702   ; desde 0
personaje_elige_col:
	and 007h		;8703   ; dentro de la pagina
	ld l,005h		;8705   ; la columna 5
	cp 004h		;8707   ; la segunda columna?
	jr c,personaje_elige_pon		;8709
	sub 004h		;870b
	ld l,014h		;870d   ; la columna 0x14
personaje_elige_pon:
	inc a			;870f   ; + 1
	ld h,a			;8710
	add a,a			;8711   ; x 5: la fila
	add a,a			;8712
	add a,h			;8713
	ld h,a			;8714
	ld a,020h		;8715   ; la clase 0x20
menu_elige_en:		; 0xFA1C = A, el cursor en HL y la eleccion (0x8240)
	ld (0fa1ch),a		;8717   ; la clase de eleccion
	ld (0fa1dh),hl		;871a   ; la posicion del cursor
	jp menu_elige		;871d   ; la eleccion
sonidos_lista_limpia:		; La pantalla limpia y la lista de los sonidos (0x8723)
	call pantalla_texto_limpia		;8720
sonidos_lista:		; Los nombres de los sonidos (registros de 13 bytes desde 0xF423, hasta 18) en dos columnas desde la fila 3
	ld hl,00304h		;8723   ; fila 3, columna 4
	ld (0fa1dh),hl		;8726   ; la posicion del cursor
	ld b,000h		;8729   ; desde el 0
	jr sonidos_lista_va		;872b
sonidos_lista_aviso:		; El aviso 1 y la lista de los sonidos
	ld a,0ffh		;872d   ; con aviso
	ld (0fa0bh),a		;872f   ; con aviso
	ld b,001h		;8732   ; el aviso 1
	ld de,00304h		;8734   ; fila 3, columna 4
	call aviso_pinta_va		;8737   ; el aviso
	ld b,001h		;873a   ; desde el 1
sonidos_lista_va:
	ld hl,0f416h		;873c   ; los registros de los sonidos
sonidos_lista_uno:
	ld a,b			;873f   ; el numero
	cp 013h		;8740   ; 18?
	ret z			;8742   ; 18: acabado
	ld de,0000dh		;8743   ; 13 bytes
	add hl,de			;8746   ; el siguiente
	ld a,(hl)			;8747   ; vacio?
	and a			;8748   ; vacio: acabado
	ret z			;8749
	inc b			;874a   ; uno mas
	push bc			;874b
	ld de,(0fa1dh)		;874c   ; la posicion
	push de			;8750
	push hl			;8751
	ld b,008h		;8752   ; 8 letras
	inc hl			;8754   ; el nombre
	call texto_pinta_b		;8755   ; escrito
	pop hl			;8758
	pop de			;8759
	inc d			;875a   ; dos filas mas abajo
	inc d			;875b
	pop bc			;875c
	ld a,b			;875d   ; el 10?
	cp 00ah		;875e   ; la columna de la derecha
	jr nz,sonidos_lista_sig		;8760
	ld de,00311h		;8762   ; la columna de la derecha
sonidos_lista_sig:
	ld (0fa1dh),de		;8765   ; la posicion
	jr sonidos_lista_uno		;8769
personajes_lista_otra:		; La otra pagina de la lista de personajes
	push bc			;876b
	call pantalla_texto_limpia		;876c   ; la pantalla limpia
	call sprites_fuera_guarda		;876f   ; sin sprites
	jr personajes_lista_va		;8772
personajes_lista:		; La lista de los personajes (si no hay, el aviso 0x0D): desde el C, 8 (de 5 en 5 filas, dos columnas), cada uno con su dibujo (0x90EB, 0x49AB) y su nombre
	push af			;8774
	ld a,(0f420h)		;8775   ; cuantos
	and a			;8778   ; ninguno?
	jp z,sin_personajes		;8779   ; "no hay personajes"
	pop af			;877c
	push bc			;877d
	call texto_entra_guarda		;877e   ; la pantalla de texto
	call aviso_fila4		;8781   ; el aviso
	call sprites_tabla_76		;8784   ; los sprites de abajo
personajes_lista_va:
	pop bc			;8787
	ld a,c			;8788   ; desde el C
	push bc			;8789
	dec a			;878a   ; desde 0
	and 0f8h		;878b   ; el primero de la pagina
	ld b,a			;878d
	ld hl,00506h		;878e   ; fila 5, columna 6
	ld (0fa1dh),hl		;8791   ; la posicion
	ld a,(0f420h)		;8794   ; cuantos
	ld c,a			;8797
	ld a,b			;8798   ; el primero de la pagina
	ld hl,0f527h		;8799   ; el protagonista
	and a			;879c   ; el 0?
	jr z,personajes_lista_pon		;879d
	ld de,00015h		;879f   ; 21 bytes
personajes_lista_salta:
	add hl,de			;87a2   ; el siguiente
	djnz personajes_lista_salta		;87a3
personajes_lista_pon:
	inc a			;87a5
	ld b,008h		;87a6   ; 8 por pagina
personajes_lista_uno:
	ld (0fa14h),a		;87a8   ; el numero
	push bc			;87ab
	ld de,(0fa1dh)		;87ac   ; la posicion
	push de			;87b0
	push hl			;87b1
	push af			;87b2
	ld a,e			;87b3   ; la columna...
	sub 005h		;87b4
	add a,a			;87b6   ; ...x 8: la X
	add a,a			;87b7
	add a,a			;87b8
	ld c,a			;87b9
	ld a,d			;87ba   ; la fila...
	dec a			;87bb
	add a,a			;87bc   ; ...x 8: la Y
	add a,a			;87bd
	add a,a			;87be
	ld b,a			;87bf
	ld de,0000bh		;87c0   ; +0x0B: sus dibujos
	add hl,de			;87c3
	ex de,hl			;87c4
	call dibujo_primero		;87c5   ; su dibujo
	pop af			;87c8
	call objeto_dibuja		;87c9   ; sus sprites
	pop hl			;87cc
	push hl			;87cd
	inc hl			;87ce   ; el nombre (+2)
	inc hl			;87cf
	ld b,008h		;87d0   ; 8 letras
	call texto_pinta_b		;87d2   ; su nombre
	pop hl			;87d5
	pop de			;87d6
	inc d			;87d7   ; 5 filas mas abajo
	inc d			;87d8
	inc d			;87d9
	inc d			;87da
	inc d			;87db
	pop bc			;87dc
	ld a,b			;87dd
	cp 005h		;87de   ; el 5?
	jr nz,personajes_lista_sig		;87e0
	ld de,00515h		;87e2   ; la segunda columna
personajes_lista_sig:
	ld (0fa1dh),de		;87e5   ; la posicion
	ld a,(0fa14h)		;87e9   ; el numero
	cp c			;87ec   ; el ultimo?
	jr z,personajes_lista_fin		;87ed
	inc a			;87ef   ; el siguiente
	ld de,00015h		;87f0   ; 21 bytes
	add hl,de			;87f3
	dec b			;87f4   ; uno menos
	jr nz,personajes_lista_uno		;87f5
personajes_lista_fin:
	ld d,c			;87f7   ; D = el ultimo
	pop bc			;87f8
	ret			;87f9
vida_menos:		; Una vida menos (0xF41A): si quedan, 0x88DC; si no, 0xFA04 = 2 (acabada), 0x9F47, 0x89B3 y otra partida (0x880C)
	ld hl,0f41ah		;87fa   ; las vidas
	dec (hl)			;87fd   ; una menos
	jp p,partida_vida		;87fe   ; quedan
	ld a,002h		;8801   ; la partida acabada
	ld (0fa04h),a		;8803   ; jugando?
	call sonido_para		;8806   ; sin sonido
	call partida_fin		;8809   ; GAME OVER
partida:		; JUGAR: la pila, la pantalla limpia, las casillas (0x4825), las vidas (0xF419 -> 0xF41A) y la partida (0x898C...)
	ld sp,0f9f1h		;880c   ; la pila
	call menu_limpia		;880f   ; la pantalla de menu
	call texto_entra_guarda		;8812   ; la de texto
	call casillas_cambia		;8815   ; las casillas
	ld a,(0f419h)		;8818   ; las vidas del juego
	ld (0f41ah),a		;881b   ; las vidas que quedan
	call tiempo_pon		;881e   ; el tiempo
	ld b,00fh		;8821   ; 15 bytes...
	ld hl,0f9f5h		;8823   ; ...de los puntos y la fase a 0
	call cero_b		;8826
	inc a			;8829   ; 1
	push af			;882a
	ld (0fa04h),a		;882b   ; jugando: 1
	ld (0fa35h),a		;882e   ; fondo de color 1
	call fondo_pinta		;8831   ; el fondo
	call graficos_entra_guarda		;8834
	call texto_colores		;8837   ; los colores del texto
	call marcador_todo		;883a   ; el marcador
	call partida_inicio		;883d   ; GAME START y la musica del principio
	ld a,(0f41fh)		;8840   ; hay historia?
	and a			;8843
	jr z,partida_sin_historia		;8844
	ld hl,0f41ah		;8846   ; vidas?
	dec (hl)			;8849
	inc (hl)			;884a
	jr nz,partida_empieza		;884b
partida_sin_historia:
	call stop_mira_menu		;884d   ; sin historia: hasta STOP
	jr partida_sin_historia		;8850
partida_empieza:
	dec (hl)			;8852
	pop af			;8853
partida_fase:		; Busca la fase A con datos (desde la 1; pasada la 8, otra vez la 1): a 0xFA08; la vuelta (0xF9F8, hasta 99) uno mas; los datos de la fase (0xFA10, IX)
	cp 009h		;8854   ; pasada la 8?
	jr nc,partida_fase_1		;8856
	push af			;8858
	call fase_iy_a		;8859   ; sus datos...
	ex de,hl			;885c
	inc hl			;885d
	inc hl			;885e
	call palabra_lee		;885f
	rst 20h			;8862   ; ...vacios?
	pop bc			;8863
	ld a,b			;8864
	jr nz,partida_fase_pon		;8865
	inc a			;8867   ; la siguiente
	jr partida_fase		;8868
partida_fase_1:
	ld a,001h		;886a
partida_fase_pon:
	ld (0fa08h),a		;886c   ; la fase
	ld hl,0f9f8h		;886f   ; la vuelta
	push af			;8872
	ld a,(hl)			;8873
	cp 063h		;8874   ; 99?
	jr c,partida_vuelta		;8876
	ld (hl),000h		;8878
partida_vuelta:
	pop af			;887a
	inc (hl)			;887b   ; una mas
	call fase_iy_a		;887c
	ld (0fa10h),hl		;887f   ; sus datos
	push hl			;8882
	pop ix		;8883
	call texto_entra_guarda		;8885
	ld a,001h		;8888
	ld (0fa35h),a		;888a   ; el color de fondo de las letras
	call pantalla_texto_limpia		;888d
	ld de,00b0ah		;8890   ; fila 0x0B, columna 0x0A
	ld hl,04b3ch		;8893   ; "STAGE"
	call texto_en		;8896
	ld hl,(0f9f8h)		;8899   ; el numero
	ld h,000h		;889c
	ld de,00b10h		;889e
	ld c,002h		;88a1
	call texto_pinta_en		;88a3
	call reloj_pon		;88a6   ; el reloj del tiempo
	call casillas_cambia		;88a9
	ld a,(iy+00ch)		;88ac   ; el fondo de la fase
	and a			;88af
	jr z,partida_casillas		;88b0
	dec a			;88b2
partida_casillas:
	call casillas_puntos		;88b3   ; las casillas de puntos que hay (0x41FB)
	ld a,c			;88b6
	or b			;88b7
	jr nz,partida_quedan		;88b8
	dec bc			;88ba
partida_quedan:
	ld (0fa3fh),bc		;88bb   ; las que quedan
	ld hl,00000h		;88bf   ; los enemigos que quedan, a 0
	ld (0fa3dh),hl		;88c2   ; los enemigos que quedan
	call fichas_rutina_3		;88c5   ; las fichas, a sus datos de partida (rutina 3: ficha_empieza)
	ld de,hueco_derecha_va		;88c8   ; una espera: 0x7FBC...
partida_espera:
	ld hl,(0fa31h)		;88cb   ; ...cuadros del reloj
	rst 20h			;88ce   ; DCOMPR
	jr nc,partida_espera		;88cf
	ld hl,(0fa3dh)		;88d1   ; los enemigos que quedan
	ld a,l			;88d4
	or h			;88d5
	jr nz,partida_vida		;88d6
	dec hl			;88d8
	ld (0fa3dh),hl		;88d9   ; los enemigos que quedan
partida_vida:		; Empieza (o sigue tras perder una vida): el fondo, SCREEN 2, sin sprites, las fichas en su sitio (rutina 1 de 0xB142), el tiempo, el marcador; jugando = 0xFF; el protagonista (ficha 1) espera la tecla (0x91F1) y despues el bucle: cada 2 cuadros, las fichas (0x8C9D, 0x83C5) y cada 2 o 6 cuadros (0xFA0D) el desplazamiento (0x8CAB) y el fondo (0x8CB9)
	call fondo_pinta		;88dc
	call texto_entra_guarda		;88df
	call graficos_entra_guarda		;88e2
	call sprites_fuera_guarda		;88e5
	call fichas_recorre		;88e8   ; todas paradas (rutina 1)
	call tiempo_pon		;88eb
	call sonido_para		;88ee   ; el sonido apagado
	call marcador_todo		;88f1   ; el marcador
	ld a,0ffh		;88f4   ; jugando
	ld (0fa04h),a		;88f6   ; jugando?
	inc a			;88f9
	ld (0fa0ch),a		;88fa   ; 0xFA0C a 0
	ld a,001h		;88fd   ; el protagonista
	call ficha_busca_a		;88ff
	jr c,partida_bucle		;8902   ; no hay
	ld (ix+014h),002h		;8904   ; +0x14 = 2
	ld a,(iy+024h)		;8908   ; el sonido de la fase
	ld (0fa9bh),a		;890b   ; el sonido pedido
	ld (0fa9ch),a		;890e   ; delante?
	call sprites_tabla_76		;8911   ; los sprites fuera
partida_espera_tecla:
	call stop_mira_menu		;8914   ; STOP?
	call sonando_no		;8917
	call sitio_al_azar		;891a   ; una tecla?
	jr nz,partida_espera_tecla		;891d
	ld a,(ix+00bh)		;891f   ; su dibujo
	ld e,001h		;8922
	call movimiento_va		;8924
partida_bucle:
	ld a,(0f418h)		;8927   ; el fondo
	cp 005h		;892a   ; desplazamiento con el protagonista?
	ld a,002h		;892c   ; cada 2 cuadros
	jr z,partida_bucle_pon		;892e
	ld a,006h		;8930   ; cada 6
partida_bucle_pon:
	ld (0fa0dh),a		;8932
partida_cuadro:
	ld sp,0f9f1h		;8935
	halt			;8938   ; espera la interrupcion
	call partida_cuadro_va		;8939   ; lo de cada cuadro
	call fichas_rutina_5		;893c   ; las fichas se mueven (rutina 5: ficha_mueve)
	ld sp,0f9f1h		;893f
	halt			;8942   ; espera
	call partida_cuadro_va		;8943
	ld hl,0fa0dh		;8946   ; la cuenta
	dec (hl)			;8949
	jr z,partida_fondo		;894a
	call choques_mira		;894c
	jr partida_cuadro		;894f
partida_fondo:
	call fondo_mueve		;8951   ; el fondo se mueve
	ld hl,0f9fch		;8954   ; 0xF9FC y 0xF9FD a 0
	xor a			;8957
	ld (hl),a			;8958
	inc hl			;8959
	ld (hl),a			;895a
	jr partida_bucle		;895b
reloj_pon:		; El reloj de la fase (0xFA31) y 0xFA33 a 0x7FFF
	ld hl,hueco_numero_x10		;895d
	ld (0fa31h),hl		;8960   ; el reloj
	ld (0fa33h),hl		;8963   ; el reloj del ultimo disparo
	ret			;8966
fondo_pinta:		; El fondo de la fase: con un fondo, nada; con tres, el de +0x0C de IY (o el primero sin historia, 0x4877); con desplazamiento (salvo jugando en el laberinto), el mapa (0x4844)
	ld a,(0f418h)		;8967   ; el fondo
	dec a			;896a
	ret z			;896b
	cp 004h		;896c   ; tres?
	jr nc,fondo_pinta_scroll		;896e
	ld a,(0f41fh)		;8970   ; hay historia?
	and a			;8973
	jr z,fondo_pinta_tres		;8974
	ld a,(iy+00ch)		;8976   ; el de la fase
	dec a			;8979
fondo_pinta_tres:
	jp mapa_tercio		;897a
fondo_pinta_scroll:
	ld a,(0f417h)		;897d   ; la clase de juego (1 combate, 2 laberinto)
	dec a			;8980
	jr nz,fondo_pinta_mapa		;8981
	ld a,(0fa04h)		;8983   ; jugando?
	cp 002h		;8986
	ret nc			;8988
fondo_pinta_mapa:
	jp mapa_elige		;8989
tiempo_pon:		; El tiempo de la fase (+0x13 de IY) x 64 a 0xFA2F
	ld l,(iy+013h)		;898c   ; el tiempo de la fase
	ld h,(iy+014h)		;898f
	sla l		;8992   ; x 64
	rl h		;8994
	sla l		;8996
	rl h		;8998
	sla l		;899a
	rl h		;899c
	sla l		;899e
	rl h		;89a0
	sla l		;89a2
	rl h		;89a4
	sla l		;89a6
	rl h		;89a8
	ld (0fa2fh),hl		;89aa   ; el tiempo
	ret			;89ad
partida_inicio:		; GAME START (0xF41D, la musica del principio) en el cuadro de 0x8A19 y espera; despues 0x923C
	ld a,(0f41dh)		;89ae   ; la musica del principio
	jr partida_rotulo		;89b1
partida_fin:		; GAME OVER (0xF41E, la musica del final)
	ld a,(0f41eh)		;89b3   ; la musica del final
partida_rotulo:
	push af			;89b6
	ld (0fa9bh),a		;89b7   ; la musica
	call rotulo_guarda		;89ba   ; guarda lo que tapa el rotulo
	call rotulo_pinta		;89bd   ; el rotulo
partida_rotulo_espera:
	call stop_mira_menu		;89c0   ; STOP?
	ld hl,0f9fch		;89c3   ; la barra?
	ld a,(hl)			;89c6
	ld (hl),000h		;89c7
	and a			;89c9
	jr z,partida_rotulo_espera		;89ca
	pop af			;89cc
	call sonido_cola_a		;89cd   ; la musica
rotulo_restaura:		; Con un fondo: lo que tapaba el rotulo vuelve a la VRAM (0x89E0, B = 1)
	ld a,(0f418h)		;89d0   ; el fondo (1 uno, 4 tres, 5-9 se desplaza)
	dec a			;89d3
	ret nz			;89d4
	ld b,001h		;89d5
	jr rotulo_copia		;89d7
rotulo_guarda:		; Con un fondo: lo que tapa el rotulo (0x78 bytes de dibujos y colores de las tres filas desde 0xA20, 0x2A20) a la RAM de 0xF7EB
	ld a,(0f418h)		;89d9   ; el fondo (1 uno, 4 tres, 5-9 se desplaza)
	dec a			;89dc
	ret nz			;89dd
	ld b,000h		;89de
rotulo_copia:
	ld de,(0f7ebh)		;89e0   ; los dibujos de las casillas (RAM)
	ld c,002h		;89e4
rotulo_copia_parte:
	ld hl,00a20h		;89e6
	ld a,c			;89e9
	dec a			;89ea
	jr nz,rotulo_copia_va		;89eb
	set 5,h		;89ed
rotulo_copia_va:
	push bc			;89ef
	bit 0,b		;89f0
	ld b,003h		;89f2
	jr nz,rotulo_copia_vram		;89f4
rotulo_copia_ram:
	push hl			;89f6
	push bc			;89f7
	ld bc,00078h		;89f8
	call ldirmv_mas		;89fb   ; LDIRMV
	pop bc			;89fe
	pop hl			;89ff
	inc h			;8a00
	djnz rotulo_copia_ram		;8a01
	jr rotulo_copia_sig		;8a03
rotulo_copia_vram:
	ex de,hl			;8a05
rotulo_copia_vram_uno:
	push de			;8a06
	push bc			;8a07
	ld bc,00078h		;8a08
	call ldirvm_mas		;8a0b   ; LDIRVM
	pop bc			;8a0e
	pop de			;8a0f
	inc d			;8a10
	djnz rotulo_copia_vram_uno		;8a11
	ex de,hl			;8a13
rotulo_copia_sig:
	pop bc			;8a14
	dec c			;8a15
	jr nz,rotulo_copia_parte		;8a16
	ret			;8a18
rotulo_pinta:		; El rotulo: tres filas de 15 espacios desde la fila 0x0A, columna 3; "GAME START" (jugando) o "GAME OVER" y "HIT SPACE KEY"
	ld a,020h		;8a19
	ld hl,00a03h		;8a1b
	ld c,003h		;8a1e
rotulo_fila:
	ld b,00fh		;8a20
	push hl			;8a22
	ld (0fa1dh),hl		;8a23   ; la posicion del cursor
rotulo_espacio:
	call letra_escribe		;8a26   ; un espacio
	djnz rotulo_espacio		;8a29
	pop hl			;8a2b
	inc h			;8a2c   ; la fila de abajo
	dec c			;8a2d
	jr nz,rotulo_fila		;8a2e
	ld c,002h		;8a30   ; dos textos
	ld hl,08a6ah		;8a32   ; "GAME START"
	ld a,(0fa04h)		;8a35   ; jugando?
	dec a			;8a38
	jr z,rotulo_texto		;8a39
	ld hl,08a76h		;8a3b   ; "GAME OVER"
rotulo_texto:
	push hl			;8a3e
	ld hl,00a06h		;8a3f   ; fila 0x0A, columna 6
	ld a,c			;8a42
	dec a			;8a43   ; el primero?
	jr nz,rotulo_texto_va		;8a44
	inc h			;8a46   ; dos filas mas abajo...
	inc h			;8a47
	dec l			;8a48   ; ...y dos columnas antes
	dec l			;8a49
rotulo_texto_va:
	ld (0fa1dh),hl		;8a4a   ; la posicion del cursor
	pop hl			;8a4d
	call texto_pinta_hl		;8a4e
	dec c			;8a51
	ret z			;8a52
	ld hl,08a81h		;8a53
	jr rotulo_texto		;8a56
marcador_todo:		; El marcador entero: los rotulos, los puntos, el record, las vidas, la vuelta y el tiempo
	call marcador_pinta		;8a58   ; los rotulos
	call marcador_puntos		;8a5b   ; los puntos
	call marcador_record		;8a5e   ; el record
	call marcador_vidas		;8a61   ; las vidas
	call marcador_vuelta		;8a64   ; la vuelta
	jp marcador_tiempo		;8a67   ; el tiempo

; ----------------------------------------------------------------------
; DATOS partida_textos: "GAME START", "GAME OVER" y "HIT SPACE KEY"
;   0x8a6a..0x8a8f  (37 bytes)
DATA_partida_textos:
	defb 047h,041h,04dh,045h,020h,053h,054h,041h,052h,054h,00dh,000h,047h,041h,04dh,045h	; 8a6a  GAME START..GAME
	defb 020h,04fh,056h,045h,052h,00dh,000h,048h,049h,054h,020h,053h,050h,041h,043h,045h	; 8a7a   OVER..HIT SPACE
	defb 020h,04bh,045h,059h,000h	; 8a8a

; ======================================================================
; CODIGO 0x8a8f..0x8b87  (248 bytes)
; ======================================================================


fase_acabada:		; La fase acabada: el reloj a 0x7FFF la primera vez (0xFA0C); cuando pasa de 0x7FC0, sonido apagado y la fase siguiente
	ld a,(0fa0ch)		;8a8f
	and a			;8a92
	call z,reloj_pon		;8a93
	ld a,0ffh		;8a96
	ld (0fa0ch),a		;8a98
	ld hl,(0fa31h)		;8a9b   ; el reloj
	ld de,07fc0h		;8a9e
	rst 20h			;8aa1   ; DCOMPR
	ret nc			;8aa2
	call sonido_para		;8aa3
	ld a,(0fa08h)		;8aa6   ; la fase...
	inc a			;8aa9   ; ...siguiente
	jp partida_fase		;8aaa
partida_mira:		; Lo de cada cuadro de la partida: el reloj (si pasa de 0x8000, otra vuelta, rutina 9); sin protagonista vivo (+0x3C de IY; 0x8B93), una vida menos; sin enemigos (0xFA3D) o sin casillas de puntos (0xFA3F), la fase acabada; el record (0xF9F2 con los puntos 0xF9F5); el tiempo (cada 32, el marcador; al acabarse, una vida menos)
	ld hl,(0fa31h)		;8aad   ; el reloj
	bit 7,h		;8ab0   ; negativo?
	jr z,partida_mira_prota		;8ab2
	call reloj_pon		;8ab4
	call fichas_rutina_9		;8ab7   ; las fichas a su sitio (rutina 9)
partida_mira_prota:
	ld a,(iy+03ch)		;8aba   ; hay protagonista?
	and a			;8abd
	jr nz,partida_mira_fase		;8abe
	ld a,001h		;8ac0
	call ficha_busca_a		;8ac2
	call ficha_dentro		;8ac5
	jp nc,vida_menos		;8ac8
partida_mira_fase:
	ld hl,(0fa3dh)		;8acb   ; enemigos?
	ld a,h			;8ace
	or l			;8acf
	jr z,fase_acabada		;8ad0
	ld hl,(0fa3fh)		;8ad2   ; casillas de puntos?
	ld a,h			;8ad5
	or l			;8ad6
	jr z,fase_acabada		;8ad7
	ld hl,0f9f4h		;8ad9   ; el record
	ld a,(0f9f7h)		;8adc   ; los puntos (las decenas de millar)
	ld bc,(0f9f5h)		;8adf   ; los puntos
	cp (hl)			;8ae3   ; mas?
	jr c,partida_tiempo		;8ae4
	ld (hl),a			;8ae6
	jr nz,record_nuevo		;8ae7
	ld hl,(0f9f2h)		;8ae9   ; el record
	sbc hl,bc		;8aec
	jr nc,partida_tiempo		;8aee
record_nuevo:
	ld (0f9f2h),bc		;8af0   ; el record
	call marcador_record		;8af4   ; al marcador
partida_tiempo:
	ld a,(iy+013h)		;8af7   ; hay tiempo?
	or (iy+014h)		;8afa
	ret z			;8afd
	ld hl,(0fa2fh)		;8afe   ; el tiempo
	ld de,0000ah		;8b01
	rst 20h			;8b04   ; acabado?
	jp c,vida_menos		;8b05
	dec hl			;8b08   ; uno menos
	ld (0fa2fh),hl		;8b09   ; el tiempo
	ld a,l			;8b0c   ; cada 32
	and 01fh		;8b0d
	ret nz			;8b0f
marcador_tiempo:		; El tiempo en el marcador (0xFA2F / 64, 3 cifras); sin tiempo, espacios
	ld a,(iy+013h)		;8b10   ; el tiempo de la fase
	or (iy+014h)		;8b13
	ld b,004h		;8b16   ; 3 cifras
	jr nz,marcador_tiempo_pon		;8b18
	call marcador_sitio		;8b1a   ; su sitio
	ld hl,0fa1eh		;8b1d   ; una columna antes
	dec (hl)			;8b20
	ld b,006h		;8b21   ; 6 espacios
marcador_tiempo_borra:
	ld a,020h		;8b23
	call letra_escribe		;8b25
	djnz marcador_tiempo_borra		;8b28
	ret			;8b2a
marcador_tiempo_pon:
	ld hl,(0fa2fh)		;8b2b   ; el tiempo
	ex de,hl			;8b2e
	call entre64		;8b2f
	ex de,hl			;8b32
	ld bc,00403h		;8b33
	jr marcador_numero_va		;8b36
marcador_numero:		; El numero A de C cifras en el sitio B del marcador
	ld l,a			;8b38
	ld h,000h		;8b39
	ld c,002h		;8b3b
marcador_numero_va:
	call marcador_sitio		;8b3d
	jr marcador_cifras_va		;8b40
marcador_vuelta:		; La vuelta (0xF9F8) en el marcador
	ld a,(0f9f8h)		;8b42   ; la vuelta
	ld b,002h		;8b45
	jr marcador_numero		;8b47
marcador_vidas:		; Las vidas (0xF41A)
	ld a,(0f41ah)		;8b49   ; las vidas que quedan
	ld b,003h		;8b4c
	jr marcador_numero		;8b4e
marcador_puntos:		; Los puntos (0xF9F7 la cifra de las decenas de millar y 0xF9F5, 4 cifras, y un 0 fijo)
	ld b,001h		;8b50
	ld hl,0f9f7h		;8b52
	jr marcador_cifras		;8b55
marcador_record:		; El record (0xF9F4 y 0xF9F2)
	ld b,000h		;8b57
	ld hl,0f9f4h		;8b59
marcador_cifras:
	call marcador_sitio		;8b5c
	ld a,(hl)			;8b5f   ; la cifra de delante
	add a,030h		;8b60
	call letra_escribe		;8b62
	dec hl			;8b65
	dec hl			;8b66
	call palabra_lee		;8b67
	ld c,004h		;8b6a
marcador_cifras_va:
	push bc			;8b6c
	call texto_pinta		;8b6d
	pop af			;8b70
	cp 002h		;8b71
	ret nc			;8b73
	ld a,030h		;8b74   ; el 0 de detras
	jp letra_escribe		;8b76
marcador_sitio:		; La posicion del dato B del marcador (0x8B87) en 0xFA1D
	push hl			;8b79
	ld hl,08b87h		;8b7a
	ld a,b			;8b7d
	call tabla_puntero		;8b7e
	inc h			;8b81
	ld (0fa1dh),hl		;8b82   ; la posicion del cursor
	pop hl			;8b85
	ret			;8b86

; ----------------------------------------------------------------------
; DATOS marcador_sitios: La fila y columna de cada dato del marcador: el
;   record, los puntos, la fase, las vidas, el tiempo...
;   0x8b87..0x8b93  (12 bytes)
DATA_marcador_sitios:
	defb 017h,001h,017h,005h,017h,009h,017h,00dh,017h,011h,017h,015h	; 8b87  ............

; ======================================================================
; CODIGO 0x8b93..0x97a0  (3085 bytes)
; ======================================================================


ficha_dentro:		; NC si la ficha (IX + 0x14: Y, X) esta dentro de la pantalla segun el reloj... (resta la posicion del desplazamiento)
	push de			;8b93
	ld de,00014h		;8b94
ficha_dentro_va:
	push ix		;8b97
	add ix,de		;8b99   ; + DE
	ld de,(0fa31h)		;8b9b   ; el reloj
	call entre64		;8b9f   ; / 64
	push bc			;8ba2
	ld l,(ix+001h)		;8ba3   ; el reloj de la ficha
	ld h,(ix+002h)		;8ba6
	ld c,(ix+000h)		;8ba9   ; cuando sale
	ld b,000h		;8bac
	sbc hl,bc		;8bae   ; ya?
	jr c,ficha_dentro_fin		;8bb0
	sbc hl,de		;8bb2   ; y hasta cuando
ficha_dentro_fin:
	pop bc			;8bb4
	pop ix		;8bb5
	pop de			;8bb7
	ret			;8bb8
ficha_dentro_7:
	push de			;8bb9
	ld de,00007h		;8bba
	jr ficha_dentro_va		;8bbd
ficha_empieza:		; Una ficha al empezar: +0x1A a 0, el registro del personaje apunta a ella (0x8C02); un enemigo (clase 3) suma a los que quedan (0xFA3D) sus veces (+0x17, minimo 1, a +0x18); con los movimientos 5, 0x12 y 0x1D, su recorrido (+0x1F); su posicion (0x8404)
	ld (ix+01ah),000h		;8bbf   ; ya salido
	call personaje_apunta		;8bc3
	ld a,(ix+001h)		;8bc6   ; la clase
	cp 003h		;8bc9   ; un enemigo?
	jr nz,ficha_empieza_mov		;8bcb
	ld hl,(0fa3dh)		;8bcd   ; los que quedan
	ld a,(ix+017h)		;8bd0   ; cuantas veces sale
	and a			;8bd3
	jr nz,ficha_empieza_veces		;8bd4
	inc a			;8bd6
ficha_empieza_veces:
	ld (ix+018h),a		;8bd7   ; las que le quedan
	call hl_mas_a		;8bda
	ld (0fa3dh),hl		;8bdd   ; los enemigos que quedan
ficha_empieza_mov:
	ld a,(ix+01eh)		;8be0   ; el movimiento
	cp 005h		;8be3
	jr z,ficha_empieza_recorrido		;8be5
	cp 012h		;8be7
	jr z,ficha_empieza_recorrido		;8be9
	cp 01dh		;8beb
	jr nz,ficha_empieza_sitio		;8bed
ficha_empieza_recorrido:
	ld c,(ix+000h)		;8bef   ; el personaje
	call recorrido_c		;8bf2
	ld (ix+01fh),e		;8bf5   ; su recorrido
	ld (ix+020h),d		;8bf8   ; su recorrido (alto)
ficha_empieza_sitio:
	ld de,(0fa31h)		;8bfb   ; el reloj
	jp ficha_posicion		;8bff
personaje_apunta:		; El registro del personaje de la ficha IX apunta a ella (los dos bytes antes del siguiente)
	ld a,(ix+000h)		;8c02   ; el personaje
	ld (0fa12h),a		;8c05   ; el personaje
	inc a			;8c08   ; desde 1
	call personaje_ficha_a		;8c09   ; el registro del siguiente
	dec hl			;8c0c   ; los dos bytes de antes
	push ix		;8c0d
	pop bc			;8c0f   ; la ficha
	ld (hl),b			;8c10   ; apuntada
	dec hl			;8c11
	ld (hl),c			;8c12
	ret			;8c13
ficha_alcanzada_ix:		; La ficha de 0xFA49 alcanzada (0x8C18)
	ld ix,(0fa49h)		;8c14   ; la ficha alcanzada
ficha_alcanzada:		; Una ficha alcanzada: su sonido (0x8F73, 0x9232), su dibujo de vencido (+3) si tiene; si es enemigo, uno menos (+0x18 y 0xFA3D); sus puntos (+5) a los del jugador (0xF9F5, la cifra 0xF9F7 al pasar de 10000) y a 0xF9F9
	call ficha_acaba		;8c18   ; acaba
	call sonido_vencido		;8c1b   ; su sonido
	ld a,(ix+003h)		;8c1e   ; dibujo de vencido?
	and a			;8c21   ; tiene?
	jr z,ficha_alcanzada_clase		;8c22
	call personaje_ficha_de		;8c24   ; la ficha del dibujo
	ld a,(hl)			;8c27   ; su personaje
	inc hl			;8c28   ; +2
	inc hl			;8c29
	ld (hl),008h		;8c2a   ; en marcha: 8
	ld bc,00028h		;8c2c   ; +0x2A
	add hl,bc			;8c2f
	ld c,(ix+02ah)		;8c30   ; su X
	ld b,(ix+02bh)		;8c33   ; su Y
	call bc_escribe		;8c36   ; la posicion
	ld l,000h		;8c39   ; el dibujo 0
	call objeto_dibuja		;8c3b   ; en pantalla
ficha_alcanzada_clase:
	ld a,(ix+001h)		;8c3e   ; la clase
	dec a			;8c41   ; el protagonista?
	ret z			;8c42   ; el protagonista: nada
	cp 002h		;8c43   ; su arma?
	ret c			;8c45   ; su arma: nada
	jr nz,ficha_puntos		;8c46   ; no enemigo
	dec (ix+018h)		;8c48   ; una vez menos
	ld hl,(0fa3dh)		;8c4b   ; uno menos que queda
	dec hl			;8c4e   ; uno menos
	ld (0fa3dh),hl		;8c4f   ; los enemigos que quedan
ficha_puntos:
	ld c,(ix+005h)		;8c52   ; sus puntos
	ld b,(ix+006h)		;8c55   ; (la parte alta)
puntos_suma:		; Suma BC a los puntos (0xF9F5; al pasar de 10000, se restan y la cifra de 0xF9F7 sube uno en decimal) y al marcador; y a 0xF9F9
	ld hl,(0f9f5h)		;8c58   ; los puntos
	add hl,bc			;8c5b   ; los puntos + BC
	push bc			;8c5c
	ld bc,02710h		;8c5d   ; 10000
	call hl_igual_bc		;8c60   ; 10000 o mas?
	jr c,puntos_suma_pon		;8c63   ; no
	sbc hl,bc		;8c65   ; - 10000
	ld a,(0f9f7h)		;8c67   ; la cifra de delante...
	add a,001h		;8c6a   ; ...uno mas
	daa			;8c6c   ; en decimal
	and 00fh		;8c6d   ; una cifra
	ld (0f9f7h),a		;8c6f   ; la cifra alta de los puntos
puntos_suma_pon:
	ld (0f9f5h),hl		;8c72   ; los puntos
	call marcador_puntos		;8c75   ; al marcador
	pop bc			;8c78
puntos_vida:
	ld hl,(0f9f9h)		;8c79   ; los puntos de la vida mas
	add hl,bc			;8c7c   ; + BC
	ld (0f9f9h),hl		;8c7d   ; los puntos de la vida mas
	ld bc,(0f41bh)		;8c80   ; los puntos de cada vida mas (0xF41B)
	ld a,b			;8c84   ; ninguna?
	or c			;8c85
	ret z			;8c86   ; ninguna
	sbc hl,bc		;8c87   ; no llega
	ret c			;8c89   ; no llega
	ld (0f9f9h),hl		;8c8a   ; los puntos de la vida mas
	ld hl,0f41ah		;8c8d   ; las vidas
	ld a,(hl)			;8c90   ; cuantas
	cp 063h		;8c91   ; 99?
	ret nc			;8c93   ; 99: no
	inc (hl)			;8c94   ; una mas
	call marcador_vidas		;8c95   ; al marcador
	ld bc,00000h		;8c98   ; nada mas que sumar
	jr puntos_vida		;8c9b   ; otra vez
partida_cuadro_va:		; IY e IX = los datos de la fase (0xFA10); STOP y lo de cada cuadro (0x8AAD)
	ld iy,(0fa10h)		;8c9d   ; los datos de la fase
	ld ix,(0fa10h)		;8ca1   ; los datos de la fase
	call stop_mira_menu		;8ca5   ; STOP
	jp partida_mira		;8ca8   ; lo de cada cuadro
choques_mira:		; Con el aviso de la interrupcion (0xF9FE, se borra): los choques del protagonista (0x8CFB) y de sus armas (0x8D53)
	ld hl,0f9feh		;8cab
	ld a,(hl)			;8cae   ; el choque
	ld (hl),000h		;8caf   ; se borra
	and a			;8cb1   ; ninguno?
	ret z			;8cb2
	call prota_choca		;8cb3   ; el protagonista
	jp arma_choca		;8cb6   ; sus armas
fondo_mueve:		; Con el fondo que se desplaza solo (0xF418 de 7 en adelante, 0x4B52) o con el protagonista (5 y 6): cuando la interrupcion avisa (0xFA01), el sentido (0xFA56) y el mapa una fila (0x4B4C); si se ha movido, las fichas (rutina 6)
	ld a,(0f418h)		;8cb9   ; el fondo
	cp 005h		;8cbc   ; sin desplazamiento?
	ret c			;8cbe   ; no se desplaza
	cp 007h		;8cbf   ; solo?
	jp nc,marcador_f418		;8cc1   ; solo: el mapa
	ld hl,0fa01h		;8cc4   ; la interrupcion avisa?
	ld a,(hl)			;8cc7   ; aviso?
	ld (hl),000h		;8cc8   ; se borra
	and a			;8cca
	ret z			;8ccb   ; no
	ld hl,0fa56h		;8ccc   ; el sentido
	ld a,(hl)			;8ccf
	rlca			;8cd0   ; el bit 7...
	and 001h		;8cd1   ; ...a 0 o 1
	ld (hl),a			;8cd3
	call marcador_algo		;8cd4   ; el mapa una fila
	ret c			;8cd7   ; no se ha movido
	jp fichas_rutina_4		;8cd8   ; las armas contra el fondo (rutina 4)
arma_choca_fondo:		; Un arma en marcha (+2): su posicion +-8 en Y segun el sentido; si da en una pared (0x9586), se acaba (0x8F73); si no, 0x9193
	ld a,(ix+002h)		;8cdb   ; en marcha (su dibujo)
	and a			;8cde   ; en marcha?
	ret z			;8cdf
	ld a,(0fa56h)		;8ce0   ; el sentido del desplazamiento
	ld b,0f8h		;8ce3   ; 8 arriba
	rrca			;8ce5   ; el sentido
	jr nc,arma_choca_fondo_va		;8ce6
	ld b,008h		;8ce8   ; 8 abajo
arma_choca_fondo_va:
	ld a,(ix+02bh)		;8cea   ; su Y
	add a,b			;8ced   ; la Y nueva
	ld b,a			;8cee
	ld c,(ix+02ah)		;8cef   ; su X
	call fuera_zona		;8cf2   ; dentro de la zona?
	jp c,ficha_acaba		;8cf5   ; no: acaba
	jp ficha_dibujo_otra		;8cf8   ; si: el dibujo
prota_choca:		; El protagonista (la primera ficha) contra las demas en marcha: los enemigos y sus armas (clases 3 y 4, sin la 5); si se tocan (0x8DF8), alcanzado; si el enemigo tiene solo una vida (+0x13), los dos
	call fichas_primera		;8cfb   ; el protagonista
	ld a,(ix+002h)		;8cfe   ; en marcha?
	and a			;8d01   ; parado?
	ret z			;8d02
	push bc			;8d03   ; cuantas
	call rectangulo_a		;8d04   ; su rectangulo
	pop af			;8d07
prota_choca_uno:
	dec a			;8d08   ; una menos
	ret z			;8d09   ; todas
	push af			;8d0a
	ld de,0002fh		;8d0b   ; la ficha siguiente
	add ix,de		;8d0e   ; la siguiente
	ld a,(ix+001h)		;8d10   ; la clase
	cp 005h		;8d13   ; vencido?
	jr z,prota_choca_sig		;8d15   ; vencido
	cp 003h		;8d17   ; el protagonista o su arma?
	jr c,prota_choca_sig		;8d19   ; del jugador
	ex af,af'			;8d1b   ; la clase, en reserva
	ld a,(ix+002h)		;8d1c   ; en marcha?
	and a			;8d1f   ; en marcha?
	jr z,prota_choca_sig		;8d20
	call rectangulo_b		;8d22   ; su rectangulo
	call rectangulos_tocan		;8d25   ; se tocan?
	jr c,prota_choca_sig		;8d28   ; no se tocan
	ex af,af'			;8d2a   ; la clase
	jr nz,prota_choca_si		;8d2b   ; el arma enemiga: el protagonista
	ld b,(ix+013h)		;8d2d   ; sus vidas
	dec b			;8d30   ; una vida?
	jr nz,prota_choca_si		;8d31
	call ficha_alcanzada		;8d33   ; el enemigo, alcanzado
prota_choca_sig:
	pop af			;8d36
	jr prota_choca_uno		;8d37
prota_choca_si:
	ld a,(ix+001h)		;8d39   ; la clase
	cp 004h		;8d3c   ; un arma enemiga?
	call z,ficha_alcanzada		;8d3e   ; el arma tambien
	call ficha_alcanzada_ix		;8d41   ; el protagonista, alcanzado
	pop af			;8d44
	ret			;8d45
fichas_primera:		; IX = la primera ficha de la fase (IY + 0x3A); B = cuantas (+0x38)
	push iy		;8d46   ; la fase
	pop ix		;8d48
	ld b,(iy+038h)		;8d4a   ; cuantas
	ld de,0003ah		;8d4d   ; la primera
	add ix,de		;8d50
	ret			;8d52
arma_choca:		; Las armas del protagonista (clase 2) en marcha contra los enemigos y sus armas (clases 3 y 4): si se tocan, el enemigo alcanzado (los que no tienen +0x13 y el arma +0x13... solo el arma) y el arma acaba
	call fichas_primera		;8d53   ; la primera
arma_choca_uno:
	ld a,(ix+001h)		;8d56   ; la clase
	cp 002h		;8d59   ; un arma del protagonista?
	push bc			;8d5b   ; cuantas quedan
	jr nz,arma_choca_sig3		;8d5c   ; no es un arma suya
	ld a,(ix+002h)		;8d5e   ; en marcha?
	and a			;8d61   ; en marcha?
	jr z,arma_choca_sig3		;8d62
	ld a,(ix+013h)		;8d64   ; que puede vencer
	ld (0fa4bh),a		;8d67   ; guardado
	call rectangulo_a		;8d6a   ; su rectangulo
	push ix		;8d6d   ; el arma
	call fichas_primera		;8d6f   ; las fichas
arma_choca_enemigo:
	push bc			;8d72   ; cuantas quedan
	ld a,(ix+001h)		;8d73   ; la clase
	sub 003h		;8d76   ; enemigo o su arma?
	cp 002h		;8d78   ; enemigo o su arma?
	jr nc,arma_choca_otro		;8d7a
	ld a,(ix+002h)		;8d7c   ; en marcha?
	and a			;8d7f   ; en marcha?
	jr z,arma_choca_otro		;8d80
	call rectangulo_b		;8d82   ; su rectangulo
	call rectangulos_tocan		;8d85   ; se tocan?
	jr c,arma_choca_otro		;8d88   ; no se tocan
	ld a,(ix+001h)		;8d8a   ; la clase
	cp 003h		;8d8d   ; un enemigo?
	jr nz,arma_choca_los_dos		;8d8f
	ld a,(0fa4bh)		;8d91   ; el arma vence?
	and a			;8d94
	jr z,arma_choca_los_dos		;8d95
	ld a,(ix+013h)		;8d97   ; sus vidas
	and a			;8d9a   ; una vida?
	jr nz,arma_choca_los_dos		;8d9b
	call ficha_alcanzada_ix		;8d9d   ; el arma acaba
arma_choca_sig:
	pop bc			;8da0
arma_choca_sig2:
	pop ix		;8da1
arma_choca_sig3:
	pop bc			;8da3
	dec b			;8da4   ; una menos
	ret z			;8da5
	ld de,0002fh		;8da6   ; la siguiente
	add ix,de		;8da9
	jr arma_choca_uno		;8dab
arma_choca_los_dos:
	call ficha_alcanzada		;8dad   ; el enemigo
	call ficha_alcanzada_ix		;8db0   ; y el arma
	jr arma_choca_sig		;8db3
arma_choca_otro:
	pop bc			;8db5
	dec b			;8db6   ; una menos
	jr z,arma_choca_sig2		;8db7
	ld de,0002fh		;8db9   ; la siguiente
	add ix,de		;8dbc
	jr arma_choca_enemigo		;8dbe
rectangulo_b:		; El rectangulo de la ficha IX a 0xFA45 (0x8DCC)
	ld de,0fa45h		;8dc0   ; el segundo
	jr rectangulo		;8dc3
rectangulo_a:		; El rectangulo de la ficha IX a 0xFA41 (y la ficha en 0xFA49)
	ld de,0fa41h		;8dc5   ; el primero
	ld (0fa49h),ix		;8dc8
rectangulo:		; Y, X (+0x2A) y el alto y el ancho (16 o 32 segun la forma del personaje) a DE
	push ix		;8dcc
	pop hl			;8dce
	ld a,(hl)			;8dcf   ; el personaje
	ld bc,0002ah		;8dd0   ; +0x2A: la posicion
	add hl,bc			;8dd3
	ld bc,00002h		;8dd4   ; 2 bytes
	ldir		;8dd7
	call personaje_forma_a		;8dd9   ; la forma
	ex de,hl			;8ddc
	ld (hl),001h		;8ddd   ; 1 de ancho
	rrca			;8ddf   ; dos?
	jr nc,rectangulo_alto		;8de0
	inc (hl)			;8de2
rectangulo_alto:
	inc hl			;8de3
	ld (hl),001h		;8de4   ; 1 de alto
	rrca			;8de6   ; dos?
	jr nc,rectangulo_fin		;8de7
	inc (hl)			;8de9
rectangulo_fin:
	ld a,(hl)			;8dea   ; el alto...
	add a,a			;8deb   ; ...x 16
	add a,a			;8dec
	add a,a			;8ded
	add a,a			;8dee
	ld (hl),a			;8def
	dec hl			;8df0
	ld a,(hl)			;8df1   ; el ancho...
	add a,a			;8df2   ; ...x 16
	add a,a			;8df3
	add a,a			;8df4
	add a,a			;8df5
	ld (hl),a			;8df6
	ret			;8df7
rectangulos_tocan:		; NC si los rectangulos de 0xFA41 y 0xFA45 se tocan (en Y y en X, 0x8E0B)
	push ix		;8df8
	ld ix,0fa41h		;8dfa   ; los rectangulos
	call tocan_eje		;8dfe   ; en Y
	jr c,rectangulos_tocan_fin		;8e01   ; no
	inc ix		;8e03   ; en X
	call tocan_eje		;8e05
rectangulos_tocan_fin:
	pop ix		;8e08
	ret			;8e0a
tocan_eje:		; En un eje: la distancia entre los dos principios contra el tamano del de delante (- 2): C si no se tocan
	ld a,(ix+004h)		;8e0b   ; el otro...
	sub (ix+000h)		;8e0e   ; ...menos este
	ret z			;8e11   ; el mismo: se tocan
	ld b,(ix+002h)		;8e12   ; el tamano de este
	jr nc,tocan_eje_va		;8e15   ; por delante
	neg		;8e17   ; sin signo
	ld b,(ix+006h)		;8e19   ; el tamano del otro
tocan_eje_va:
	ld c,a			;8e1c   ; la distancia
	ld a,b			;8e1d   ; el tamano...
	dec a			;8e1e   ; ...- 2...
	dec a			;8e1f
	sub c			;8e20   ; ...menos la distancia
	ret			;8e21
personaje_ficha_de:		; HL = la ficha a la que apunta el registro del personaje A
	inc a			;8e22   ; desde 1
	call personaje_ficha_a		;8e23   ; el registro del siguiente
	dec hl			;8e26   ; los dos bytes de antes
	dec hl			;8e27
	call palabra_lee		;8e28   ; la ficha
	ret			;8e2b
personaje_datos:		; De la ficha del personaje A: A = +2 (en marcha) y B = +0x10
	call personaje_ficha_de		;8e2c   ; la ficha
	inc hl			;8e2f   ; +2
	inc hl			;8e30
	ld a,(hl)			;8e31   ; en marcha
	ld de,0000eh		;8e32   ; +0x10
	add hl,de			;8e35
	ld b,(hl)			;8e36   ; su direccion
	and a			;8e37
	ret			;8e38
boton_mira:		; El boton A (1: 0xF9FC; 2: 0xF9FD) pulsado desde la ultima vez (se borra); Z si no
	and a			;8e39   ; ninguno?
	ret z			;8e3a
	push hl			;8e3b
	ld hl,0f9fch		;8e3c   ; el boton 1
	dec a			;8e3f   ; el 1?
	jr z,boton_mira_va		;8e40
	inc hl			;8e42   ; el 2
boton_mira_va:
	ld a,(hl)			;8e43   ; pulsado?
	ld (hl),000h		;8e44   ; se borra
	and a			;8e46
	pop hl			;8e47
	ret			;8e48
ficha_mueve:		; Mueve una ficha (rutina 3 de 0xB142): el protagonista y sus armas con su boton (0x9076); los enemigos aparecen cuando les toca (0x8B93) y cuantas veces (+0x18; 0x9140); las demas, si estan en marcha, se mueven (0x8EE0) o, fuera de la pantalla, acaban
	call sonando_no		;8e49   ; 0xFA03 a 0
	push bc			;8e4c   ; la clase
	ld a,(ix+001h)		;8e4d   ; la clase
	cp 003h		;8e50   ; un enemigo?
	ld d,a			;8e52   ; la clase
	jr z,ficha_mueve_enemigo		;8e53
	jr nc,ficha_mueve_otro		;8e55   ; su arma o vencido?
	ld a,(ix+002h)		;8e57   ; en marcha?
	and a			;8e5a   ; en marcha?
	ld a,d			;8e5b   ; la clase
	jr z,ficha_mueve_prota		;8e5c   ; no
ficha_mueve_marcha:
	ld a,(ix+007h)		;8e5e   ; se sale?
	and a			;8e61   ; sale cuando le toca?
	jr z,ficha_mueve_va		;8e62   ; no
	call ficha_dentro_7		;8e64   ; dentro?
	jr c,ficha_mueve_va		;8e67   ; no
	call ficha_acaba		;8e69   ; acaba
ficha_mueve_fin:
	pop bc			;8e6c
	ret			;8e6d
ficha_mueve_va:
	call ficha_paso		;8e6e   ; un paso
	jr ficha_mueve_fin		;8e71
ficha_mueve_prota:
	dec a			;8e73   ; el protagonista?
	call nc,arma_dispara		;8e74   ; un arma: el boton
ficha_mueve_sale:
	call sonido_mueve		;8e77   ; su sonido
ficha_mueve_reloj:
	ld de,(0fa31h)		;8e7a   ; el reloj / 64
	call entre64		;8e7e   ; / 64
	ld (ix+008h),e		;8e81   ; su reloj
	ld (ix+009h),d		;8e84
	jr ficha_mueve_fin		;8e87
ficha_mueve_enemigo:
	call ficha_dentro		;8e89   ; le toca?
	jr c,ficha_mueve_enemigo_b		;8e8c   ; no
	call ficha_reloj		;8e8e   ; su reloj
	ld a,(ix+002h)		;8e91   ; en marcha?
	and a			;8e94   ; en marcha?
	ld a,000h		;8e95   ; 0...
	jr nz,ficha_mueve_enemigo_va		;8e97
	dec a			;8e99   ; ...o 0xFF
ficha_mueve_enemigo_va:
	ld (ix+01ah),a		;8e9a   ; ya salido
ficha_mueve_enemigo_b:
	ld a,(ix+002h)		;8e9d   ; en marcha (su dibujo)
	and a			;8ea0   ; en marcha?
	jr nz,ficha_mueve_marcha		;8ea1   ; si
	ld a,(ix+01ah)		;8ea3   ; ya salido
	and a			;8ea6   ; salido?
	jr z,ficha_mueve_fin		;8ea7
	ld b,(ix+018h)		;8ea9   ; las veces que le quedan
	inc b			;8eac   ; quedan?
	dec b			;8ead
	jr z,ficha_mueve_reloj		;8eae   ; no
	call enemigo_sale		;8eb0   ; sale otra vez
	jr ficha_mueve_sale		;8eb3   ; sale
ficha_mueve_otro:
	ld a,(ix+002h)		;8eb5   ; en marcha (su dibujo)
	and a			;8eb8   ; en marcha?
	jp nz,ficha_mueve_marcha		;8eb9
	bit 0,d		;8ebc   ; su arma?
	call z,enemigo_arma_sale		;8ebe   ; sale
	jr ficha_mueve_sale		;8ec1
ficha_le_toca:		; C si a la ficha no le toca moverse: su reloj (+0x1C) menos la velocidad (+0x1B) todavia por encima del de la partida (0xFA31)
	ld l,(ix+01ch)		;8ec3   ; su reloj
	ld h,(ix+01dh)		;8ec6   ; su reloj (alto)
	ld c,(ix+01bh)		;8ec9   ; su velocidad
reloj_toca:
	ld b,000h		;8ecc   ; su velocidad
	sbc hl,bc		;8ece   ; el reloj - la velocidad
	ld de,(0fa31h)		;8ed0   ; el de la partida
	jr c,reloj_toca_c		;8ed4   ; por debajo
	jr z,reloj_toca_c		;8ed6   ; 0
	rst 20h			;8ed8   ; DCOMPR
	ret			;8ed9
reloj_toca_c:
	scf			;8eda   ; C
	bit 6,d		;8edb   ; el reloj alto?
	ret z			;8edd
	ccf			;8ede   ; NC
	ret			;8edf
ficha_paso:		; Un paso de la ficha si le toca: su reloj nuevo (+0x1C), la rutina de su movimiento (+0x1E en la tabla 0xB1A4); despues, segun 0xFA03 y 0xFA02: se acaba (bit 0), choca (bit 1: el borde, +0x19: pararse 1, la otra punta 2 o desaparecer) o se mueve (bit 3: 0x91C9)
	call ficha_le_toca		;8ee0   ; le toca?
	ret c			;8ee3   ; no
	ld (ix+01ch),e		;8ee4   ; su reloj
	ld (ix+01dh),d		;8ee7   ; su reloj (alto)
	ld c,(ix+01eh)		;8eea   ; el movimiento
	xor a			;8eed   ; 0
	ld (0fa02h),a		;8eee   ; la direccion del paso
	ld a,c			;8ef1   ; el movimiento
	and a			;8ef2   ; ninguno?
	ret z			;8ef3
	ld hl,0b1a4h		;8ef4   ; la tabla de los movimientos
	push iy		;8ef7   ; IY guardado
	call salta_tabla		;8ef9   ; la rutina
	pop iy		;8efc
	ld a,(0fa03h)		;8efe   ; el resultado
	bit 0,a		;8f01   ; acabar?
	jp nz,ficha_acaba		;8f03   ; acaba
	ld d,a			;8f06   ; lo que pasa
	ld a,(0fa02h)		;8f07   ; la direccion
	and a			;8f0a   ; se mueve?
	ret z			;8f0b   ; no
	bit 1,d		;8f0c   ; en el borde?
	jr nz,ficha_paso_borde		;8f0e   ; en el borde
ficha_paso_mueve:
	bit 3,d		;8f10   ; moverse?
	jp z,ficha_dibujo_mueve		;8f12   ; sin pared: el dibujo
	ld a,(ix+001h)		;8f15   ; la clase
	bit 0,a		;8f18   ; del jugador?
	jp z,ficha_acaba		;8f1a   ; el enemigo acaba
	ld a,(ix+01eh)		;8f1d   ; el movimiento 0x0E?
	cp 00eh		;8f20   ; el 0x0E (laberinto, sin orden)?
	jr nz,ficha_paso_quieto		;8f22
ficha_paso_vuelve:		; Da la vuelta (bit 2 de 0xFA02) y la apunta en +0x27
	ld a,(0fa02h)		;8f24   ; la direccion del paso
	xor 004h		;8f27   ; la direccion contraria
	ld (0fa02h),a		;8f29   ; la direccion del paso
	ld (ix+027h),a		;8f2c   ; la X del tramo
	ret			;8f2f   ; hecho
ficha_paso_quieto:
	ld c,(ix+02ah)		;8f30   ; su X
	ld b,(ix+02bh)		;8f33   ; su Y
	jp ficha_dibujo_mueve		;8f36   ; el dibujo
ficha_paso_borde:
	ld a,(ix+019h)		;8f39   ; en el borde
	cp 002h		;8f3c   ; pararse?
	jr c,ficha_paso_quieto		;8f3e   ; pararse
	jr nz,ficha_acaba		;8f40   ; desaparecer
	push ix		;8f42   ; la ficha
	pop hl			;8f44
	ld de,00024h		;8f45   ; +0x24: la zona
	add hl,de			;8f48   ; su sitio
	ld d,b			;8f49   ; Y, X
	ld b,c			;8f4a
	call zona_recorta		;8f4b   ; la X dentro
	ld c,b			;8f4e
	ld b,d			;8f4f
	inc hl			;8f50   ; la Y
	call zona_recorta		;8f51   ; dentro
	call laberinto_casillas		;8f54   ; las casillas
	ld a,(0fa03h)		;8f57   ; lo que pasa al moverse
	ld d,a			;8f5a   ; lo que pasa
	jr ficha_paso_mueve		;8f5b   ; a moverse
zona_recorta:		; B dentro de la zona de HL: por debajo, el limite; por encima de 0xEE, el otro
	push hl			;8f5d
	ld a,(hl)			;8f5e   ; el limite
	cp b			;8f5f   ; por debajo?
	jr c,zona_recorta_mas		;8f60
zona_recorta_max:
	ld a,0eeh		;8f62   ; 0xEE
	cp b			;8f64   ; por encima?
	jr nc,zona_recorta_fin		;8f65
zona_recorta_pon:
	ld b,(hl)			;8f67   ; el limite
zona_recorta_fin:
	pop hl			;8f68
	ret			;8f69
zona_recorta_mas:
	add a,012h		;8f6a   ; el limite + 0x12
	cp b			;8f6c   ; por encima?
	jr c,zona_recorta_max		;8f6d
	dec hl			;8f6f   ; el otro
	dec hl			;8f70
	jr zona_recorta_pon		;8f71
ficha_acaba:		; La ficha acaba: sus sprites fuera (0x9188), su sonido (0x9237), +2 y +0x27 a 0; si no es enemigo, su reloj (0x8F86)
	call ficha_sprites_fuera		;8f73   ; sus sprites fuera
	call sonido_cola		;8f76   ; su sonido
	xor a			;8f79   ; 0
	ld (ix+002h),a		;8f7a   ; fuera de marcha
	ld (ix+027h),a		;8f7d   ; la X del tramo
	ld a,(ix+001h)		;8f80   ; la clase
	cp 003h		;8f83   ; un enemigo?
	ret z			;8f85   ; si: nada mas
ficha_reloj:		; El reloj de la partida / 64 a +0x15 de la ficha
	ld de,(0fa31h)		;8f86   ; el reloj
	call entre64		;8f8a   ; / 64
	ld (ix+015h),e		;8f8d   ; su reloj
	ld (ix+016h),d		;8f90   ; (la parte alta)
	ret			;8f93
laberinto_casillas:		; En el laberinto jugando: las casillas que pisa la ficha (0x9019): las paredes (0x60-0x6F) avisan en 0xFA03 (bit 3); las de puntos (0x71-0x73), con el protagonista moviendose, se borran del mapa (0x70), una casilla de puntos menos (0xFA3F) y 10, 20 o 30 puntos
	ld a,(0f421h)		;8f94   ; la clase de juego
	and 0f0h		;8f97   ; la clase de juego
	cp 020h		;8f99   ; el laberinto?
	ret c			;8f9b   ; no es el laberinto
	ld a,(0fa04h)		;8f9c   ; jugando?
	and a			;8f9f   ; no jugando
	ret z			;8fa0
	push bc			;8fa1
	call ficha_casillas		;8fa2   ; la casilla de la esquina
laberinto_fila:
	push hl			;8fa5   ; la fila
laberinto_casilla:
	push bc			;8fa6   ; las casillas que quedan
	call 0004ah		;8fa7   ; RDVRM
	cp 060h		;8faa   ; por debajo de 0x60: nada
	jr c,laberinto_sig		;8fac   ; por debajo de 0x60
	cp 070h		;8fae   ; 0x60-0x6F: pared
	ld b,008h		;8fb0   ; la pared
	jr c,laberinto_pared		;8fb2   ; 0x60-0x6F
	jr z,laberinto_sig		;8fb4   ; 0x70: camino
	cp 074h		;8fb6   ; 0x74 o mas: nada
	jr nc,laberinto_sig		;8fb8   ; 0x74 o mas
	ld b,a			;8fba   ; la casilla
	ld a,(ix+001h)		;8fbb   ; la clase
	dec a			;8fbe   ; el protagonista?
	jr nz,laberinto_sig		;8fbf   ; no es el protagonista
	ld a,(0fa02h)		;8fc1   ; moviendose?
	and a			;8fc4   ; quieto?
	jr z,laberinto_sig		;8fc5   ; no cuenta
	push hl			;8fc7
	ld a,b			;8fc8   ; la casilla
	push af			;8fc9
	add a,003h		;8fca   ; la casilla + 3
	ld de,03800h		;8fcc   ; la tabla de nombres
	sbc hl,de		;8fcf   ; la fila
	push af			;8fd1
	ld b,000h		;8fd2   ; la fila a 0
	ld de,00020h		;8fd4   ; cada 32
laberinto_fila_cuenta:
	rst 20h			;8fd7   ; DCOMPR
	jr c,laberinto_borra		;8fd8   ; por debajo: la fila
	sbc hl,de		;8fda   ; una fila menos
	inc b			;8fdc   ; la fila + 1
	jr laberinto_fila_cuenta		;8fdd
laberinto_borra:
	ld h,b			;8fdf   ; H = la fila
	dec l			;8fe0   ; L = la columna
	pop af			;8fe1
	call mapa_casilla		;8fe2   ; al mapa
	ld hl,(0fa3fh)		;8fe5   ; una casilla menos
	dec hl			;8fe8   ; una menos
	ld (0fa3fh),hl		;8fe9   ; las casillas de puntos que quedan
	pop af			;8fec   ; la casilla
	sub 070h		;8fed   ; 1, 2 o 3
	ld b,a			;8fef   ; 1, 2 o 3
	xor a			;8ff0   ; desde 0
laberinto_puntos:
	inc a			;8ff1   ; + 1
	djnz laberinto_puntos		;8ff2
	ld c,a			;8ff4   ; 10, 20 o 30 (con el 0 fijo)
	ld b,000h		;8ff5
	call puntos_suma		;8ff7   ; los puntos
	pop hl			;8ffa   ; la posicion
laberinto_sig:
	pop bc			;8ffb
	dec c			;8ffc   ; una menos
	jr z,laberinto_fila_sig		;8ffd   ; la fila acabada
	inc l			;8fff   ; la siguiente
	jr laberinto_casilla		;9000
laberinto_pared:
	ld a,(0fa03h)		;9002   ; lo que pasa al moverse
	or b			;9005   ; la pared
	ld (0fa03h),a		;9006   ; lo que pasa al moverse
	jr laberinto_sig		;9009   ; la siguiente
laberinto_fila_sig:
	ld a,(0fa41h)		;900b   ; el ancho
	ld c,a			;900e
	pop hl			;900f
	ld de,00020h		;9010   ; la fila de abajo
	add hl,de			;9013
	dec b			;9014   ; una menos
	jr nz,laberinto_fila		;9015
	pop bc			;9017
	ret			;9018
ficha_casillas:		; Las casillas que ocupa la ficha (2 o 4 segun la forma: 0xFA41 y 0xFA42) y HL = la de la esquina en la tabla de nombres (0x3800 + fila x 32 + columna + 1); el protagonista se ajusta a la casilla si le falta poco (0x9065)
	ld a,(ix+000h)		;9019   ; el personaje
	call personaje_forma_a		;901c   ; la forma
	ld hl,0fa41h		;901f   ; el ancho
	ld (hl),002h		;9022   ; 2 casillas
	rrca			;9024
	jr nc,ficha_casillas_x		;9025   ; dos de ancho?
	ld (hl),004h		;9027   ; 4
ficha_casillas_x:
	inc hl			;9029   ; el alto
	ld (hl),002h		;902a   ; 2
	rrca			;902c
	jr nc,ficha_casillas_va		;902d   ; dos de alto?
	ld (hl),004h		;902f   ; 4
ficha_casillas_va:
	push bc			;9031
	ld c,b			;9032   ; la Y
	call ficha_casilla_eje		;9033   ; la fila
	inc a			;9036
	pop bc			;9037
	ld b,a			;9038   ; la fila + 1
	dec hl			;9039
	call ficha_casilla_eje		;903a   ; la columna
	ld de,00020h		;903d   ; cada 32
	ld hl,037e0h		;9040   ; la tabla de nombres - 32
ficha_casillas_fila:
	add hl,de			;9043   ; + 32 por fila
	djnz ficha_casillas_fila		;9044
	call hl_mas_a		;9046   ; + la columna
	inc hl			;9049   ; + 1
	ld bc,(0fa41h)		;904a   ; el tamano
	ret			;904e
ficha_casilla_eje:		; La casilla de una posicion (C / 8); si no cae justo, una mas en el tamano (0xFA41...); el protagonista se redondea
	ld a,c			;904f   ; la posicion...
	and 0f8h		;9050   ; ...de 8 en 8
	cp c			;9052   ; justo?
	ld d,a			;9053
	jr z,ficha_casilla_pon		;9054   ; si
	ld a,(ix+000h)		;9056   ; el personaje
	dec a			;9059   ; el protagonista?
	jr z,ficha_casilla_prota		;905a
ficha_casilla_mas:
	inc (hl)			;905c   ; una casilla mas
ficha_casilla_pon:
	ld a,d			;905d   ; la posicion
ficha_casilla_entre8:
	srl a		;905e   ; / 8
	srl a		;9060
	srl a		;9062
	ret			;9064
ficha_casilla_prota:
	ld a,d			;9065   ; lo que falta
	sub c			;9066
	neg		;9067
	cp 003h		;9069   ; menos de 3: la de arriba
	jr c,ficha_casilla_pon		;906b
	cp 006h		;906d   ; menos de 6: una mas
	jr c,ficha_casilla_mas		;906f
	ld a,d			;9071   ; si no, la siguiente
	add a,008h		;9072
	jr ficha_casilla_entre8		;9074
arma_dispara:		; Un arma del protagonista: con su boton (+0x12) pulsado y pasados 16 del reloj desde la ultima (0xFA33), si hay una libre (0x915A), sale (0x9094 con E = 0x12)
	ld a,(ix+012h)		;9076   ; el boton
	call boton_mira		;9079   ; el boton
	ret z			;907c   ; no
	ld hl,(0fa33h)		;907d   ; la ultima
	ld c,010h		;9080   ; 16
	call reloj_toca		;9082   ; 16?
	ret c			;9085   ; no
	ld a,001h		;9086   ; un arma libre
	call arma_libre		;9088   ; libre?
	ret c			;908b   ; no
	ld hl,(0fa31h)		;908c   ; ahora
	ld (0fa33h),hl		;908f   ; el reloj del ultimo disparo
	ld e,012h		;9092   ; el movimiento 0x12
movimiento_es:		; Si el movimiento de la ficha (+0x1E) es E: con 0x12 o mas, el recorrido (su principio en BC, con 0x12 el destino de 0xF9FF), la linea (0x945D) y la marcha (0x90F8); si no, la posicion BC a +0x2A y +0x26/+0x27 a 0; el dibujo de su direccion (0x919E, 0x90EB, 0x91A4)
	ld a,(ix+01eh)		;9094   ; su movimiento
	cp e			;9097   ; el de la ficha?
	jr nz,movimiento_pon		;9098
movimiento_va:
	push bc			;909a
	ld a,e			;909b   ; el movimiento
	cp 012h		;909c   ; un recorrido?
	jr c,movimiento_marcha		;909e
	push af			;90a0   ; el personaje
	ld a,(ix+000h)		;90a1   ; el personaje
	ld (0fa12h),a		;90a4   ; el personaje
	call recorrido_busca		;90a7   ; el recorrido
	ex de,hl			;90aa   ; el recorrido
	inc hl			;90ab
	ld (hl),c			;90ac   ; la posicion de partida
	inc hl			;90ad
	ld (hl),b			;90ae
	pop af			;90af
	jr z,movimiento_linea		;90b0   ; el 0x12?
	push hl			;90b2
	ld de,00007h		;90b3   ; +9: el destino
	add hl,de			;90b6
	ld a,(0f9ffh)		;90b7   ; la Y del protagonista
	ld (hl),a			;90ba
	inc hl			;90bb
	ld a,(0fa00h)		;90bc   ; la X
	ld (hl),a			;90bf
	pop hl			;90c0
movimiento_linea:
	dec hl			;90c1
	call tramo_calcula		;90c2   ; el tramo
movimiento_marcha:
	call recorrido_sigue		;90c5   ; en marcha
	pop bc			;90c8
	ret nc			;90c9   ; bien
	jr movimiento_dibujo		;90ca
movimiento_pon:
	ld (ix+02ah),c		;90cc   ; su X
	ld (ix+02bh),b		;90cf   ; su Y
	ld (ix+026h),000h		;90d2   ; la Y del tramo
	ld (ix+027h),000h		;90d6   ; la X del tramo
movimiento_dibujo:
	ld a,(ix+00bh)		;90da   ; su dibujo
dibujo_pon:
	push bc			;90dd
	call ficha_dibujo		;90de   ; el dibujo
	pop bc			;90e1
	ret nz			;90e2   ; bien
	call dibujo_primero		;90e3   ; el primero que tiene
	ld a,000h		;90e6   ; parado
	jp ficha_dibujo_pon		;90e8   ; pintado
dibujo_primero:		; L = el primer dibujo del personaje que tiene (desde DE, los 0xFF no; hasta 8)
	ld l,000h		;90eb
dibujo_primero_uno:
	ld a,(de)			;90ed   ; el dibujo
	inc a			;90ee   ; tiene (no 0xFF)?
	ret nz			;90ef
	ld a,l			;90f0   ; el siguiente
	cp 008h		;90f1   ; los 8?
	ret z			;90f3
	inc de			;90f4
	inc l			;90f5
	jr dibujo_primero_uno		;90f6
recorrido_sigue:		; La ficha sigue su recorrido (+0x1F): la posicion BC a +0x2A
	ld (ix+02bh),b		;90f8   ; su Y
	ld (ix+02ah),c		;90fb   ; su X
	ld l,(ix+01fh)		;90fe   ; el recorrido
	ld h,(ix+020h)		;9101   ; su recorrido (alto)
	ld a,(hl)			;9104   ; cuantos puntos
	and a			;9105   ; sin puntos?
	ret z			;9106   ; ninguno
	ld (ix+02ch),001h		;9107   ; el primer tramo
	inc hl			;910b   ; el primero
	ld a,(hl)			;910c   ; la Y del primer punto
	ld e,a			;910d   ; la Y
	ld (ix+026h),a		;910e   ; la Y del tramo
	sub c			;9111   ; la distancia en Y
	neg		;9112   ; la distancia
	ld (ix+028h),a		;9114
	inc hl			;9117   ; la X
	ld a,(hl)			;9118   ; la X
	ld d,a			;9119   ; la X
	ld (ix+027h),a		;911a   ; la X del tramo
	sub b			;911d   ; la distancia en X
	neg		;911e   ; la distancia
	ld (ix+029h),a		;9120
	inc hl			;9123   ; el eje
	ld a,(hl)			;9124   ; vertical?
	and a			;9125
	jr z,recorrido_sigue_va		;9126
	ld d,e			;9128   ; la Y
recorrido_sigue_va:
	inc hl			;9129
	inc hl			;912a
	inc hl			;912b
	inc hl			;912c
	ld (hl),000h		;912d   ; la cuenta a 0
	inc hl			;912f
	ld (hl),d			;9130   ; el principio
	scf			;9131   ; en marcha
	ret			;9132   ; C: en marcha
enemigo_arma_sale:		; El arma del enemigo sale (0x9154) con el movimiento 0x1D
	call arma_libre_mira		;9133   ; el arma libre?
	ret c			;9136   ; no
	ld e,01dh		;9137   ; el movimiento 0x1D
ficha_sale:		; +0x1A a 0 y la salida con el movimiento E (0x9094)
	ld (ix+01ah),000h		;9139   ; ya salido
	jp movimiento_es		;913d   ; sale
enemigo_sale:		; Un enemigo sale: si tiene dibujo de vencido en marcha, todavia no; si el protagonista... (0x91F1) en una pared, tampoco; si no, con el movimiento 5
	ld a,(ix+003h)		;9140   ; el dibujo de vencido
	and a			;9143   ; dibujo de vencido?
	jr z,enemigo_sale_va		;9144
	call personaje_datos		;9146   ; en marcha?
	scf			;9149
	ret nz			;914a   ; si: todavia no
enemigo_sale_va:
	call sitio_al_azar		;914b   ; un sitio al azar
	scf			;914e
	ret nz			;914f   ; en una pared
	ld e,005h		;9150   ; el movimiento 5
	jr ficha_sale		;9152
arma_libre_mira:		; Con arma (+0x11): 0x915A
	ld a,(ix+011h)		;9154   ; su arma
	and a			;9157   ; tiene?
	jr z,arma_libre_no		;9158
arma_libre:		; El arma del personaje A: si no esta en marcha (+2, sin el bit 7), +0x10 = su direccion, la primera vez su reloj; NC y BC = su posicion (+0x1A de su ficha) si esta dentro de la pantalla
	call personaje_datos		;915a   ; su ficha
	and 07fh		;915d   ; en marcha?
	jr z,arma_libre_no		;915f   ; en marcha
	ld (ix+010h),b		;9161   ; su direccion
	push hl			;9164   ; su ficha
	ld a,(ix+01ah)		;9165   ; ya salido
	and a			;9168   ; ya salido?
	jr nz,arma_libre_va		;9169
	call ficha_empieza_sitio		;916b   ; el reloj
	ld (ix+01ah),0ffh		;916e   ; ya salido
arma_libre_va:
	pop hl			;9172
	ex de,hl			;9173   ; la ficha
	call ficha_dentro		;9174   ; dentro?
	ex de,hl			;9177
	ret c			;9178   ; no
	ld de,0001ah		;9179   ; +0x1A
	add hl,de			;917c
	call bc_lee		;917d   ; BC = la posicion
	and a			;9180   ; NC
	ret			;9181
arma_libre_no:
	ld (ix+01ah),000h		;9182   ; ya salido
	scf			;9186   ; C
	ret			;9187
ficha_sprites_fuera:		; Los sprites del personaje de la ficha fuera (0x4A20)
	push bc			;9188
	push hl			;9189
	ld a,(ix+000h)		;918a   ; el personaje
	call sprite_quita		;918d   ; sus sprites fuera
	pop hl			;9190
	pop bc			;9191
	ret			;9192
ficha_dibujo_otra:		; El dibujo de la ficha otra vez (0x919E con +2); NZ si el bit 4 de B
	push af			;9193
	ld a,(ix+002h)		;9194   ; en marcha (su dibujo)
	call ficha_dibujo		;9197   ; el dibujo
	pop af			;919a
	bit 4,b		;919b   ; NZ si hay que moverse
	ret			;919d
ficha_dibujo:		; El dibujo de la direccion A del personaje (0x77D4) en la posicion BC (0x91A4)
	and 007h		;919e   ; la direccion
	ld l,a			;91a0
	call dibujo_direccion		;91a1   ; su dibujo
ficha_dibujo_pon:		; Pinta la ficha (0x49AB) en BC; del protagonista, la posicion a 0xF9FF; +2 = 8 + el dibujo (en marcha) y la posicion a +0x2A
	push af			;91a4
	jr z,ficha_dibujo_fin		;91a5   ; no tiene
ficha_dibujo_va:
	push hl			;91a7
	push bc			;91a8
	ld a,(ix+000h)		;91a9   ; el personaje
	call objeto_dibuja		;91ac   ; los sprites
	pop bc			;91af   ; la posicion
	pop hl			;91b0
	ld a,(ix+001h)		;91b1   ; la clase
	dec a			;91b4   ; el protagonista?
	jr nz,ficha_dibujo_marcha		;91b5   ; el protagonista?
	ld (0f9ffh),bc		;91b7   ; su posicion, para los demas
ficha_dibujo_marcha:
	ld a,008h		;91bb
	add a,l			;91bd   ; + el dibujo
ficha_dibujo_fin:
	ld (ix+002h),a		;91be   ; en marcha (su dibujo)
	ld (ix+02ah),c		;91c1   ; su X
	ld (ix+02bh),b		;91c4   ; su Y
	pop af			;91c7
	ret			;91c8
ficha_dibujo_mueve:		; Al moverse: el dibujo de la nueva direccion (0xFA02), alternando los dos de cada direccion
	call ficha_sprites_fuera		;91c9   ; los sprites fuera
	ld a,(ix+002h)		;91cc   ; en marcha (su dibujo)
	and 007h		;91cf   ; la direccion de antes
	push af			;91d1
	srl a		;91d2   ; / 2
	ld d,a			;91d4
	ld a,(0fa02h)		;91d5   ; la direccion del paso
	dec a			;91d8   ; la nueva - 1...
	srl a		;91d9   ; .../ 2
	cp d			;91db   ; la misma?
	jr nz,ficha_dibujo_dir		;91dc
ficha_dibujo_alterna:
	pop af			;91de
	xor 001h		;91df   ; el otro de la pareja
	ld l,a			;91e1
	call dibujo_direccion		;91e2   ; su dibujo
	push af			;91e5
	jr ficha_dibujo_va		;91e6
ficha_dibujo_dir:
	rlca			;91e8   ; x 2
	ld l,a			;91e9
	call dibujo_direccion		;91ea   ; su dibujo
	jr nz,ficha_dibujo_va		;91ed   ; tiene
	jr ficha_dibujo_alterna		;91ef
sitio_al_azar:		; Una posicion al azar en la zona de la ficha (+0x0C, 0x9204) y si cae en una pared del laberinto (NZ: bit 3 de 0xFA03)
	ld de,0000ch		;91f1   ; +0x0C: la zona
	push ix		;91f4
	pop hl			;91f6
	add hl,de			;91f7
	call zona_azar		;91f8   ; al azar
	call laberinto_casillas		;91fb   ; las casillas
	ld a,(0fa03h)		;91fe   ; lo que pasa al moverse
	bit 3,a		;9201   ; pared?
	ret			;9203
zona_azar:		; C y B al azar dentro de la zona de HL (0x9210)
	call eje_azar		;9204   ; X al azar
	add a,(hl)			;9207   ; + el principio
	ld c,a			;9208
	inc hl			;9209
	call eje_azar		;920a   ; Y al azar
	add a,(hl)			;920d   ; + el principio
	ld b,a			;920e
	ret			;920f
eje_azar:		; Un numero al azar (0x95C1) por debajo del tamano de la zona (de 8 en 8)
	ld b,(hl)			;9210   ; el principio
	inc hl			;9211
	inc hl			;9212
	ld a,(hl)			;9213   ; el final
	dec hl			;9214
	dec hl			;9215
	sub b			;9216   ; el tamano
	inc a			;9217
	ld b,a			;9218
	call azar		;9219   ; al azar
eje_azar_mitad:
	and 0f8h		;921c   ; de 8 en 8
	cp b			;921e   ; cabe?
	ret c			;921f
	srl a		;9220   ; la mitad
	jr eje_azar_mitad		;9222
sonido_mueve:		; Con la ficha en marcha, su sonido de moverse (+4) a 0xFA9B
	ld a,(ix+002h)		;9224   ; en marcha (su dibujo)
	and a			;9227   ; en marcha?
	ret z			;9228
	ld a,(ix+004h)		;9229   ; el sonido al moverse
sonido_pide:
	and a			;922c   ; ninguno?
	ret z			;922d
	ld (0fa9bh),a		;922e   ; el sonido pedido
	ret			;9231   ; hecho
sonido_vencido:		; El sonido de ser alcanzado (+0x0A)
	ld a,(ix+00ah)		;9232   ; el sonido al ser alcanzado
	jr sonido_pide		;9235   ; pedido
sonido_cola:		; El sonido +4 de la ficha a la cola de sonidos (0xFA2D)
	ld a,(ix+004h)		;9237   ; el sonido al moverse
	and a			;923a   ; ninguno?
	ret z			;923b
sonido_cola_a:		; El sonido A a la cola (0xFA2D)
	push hl			;923c
	ld hl,(0fa2dh)		;923d   ; la cola de sonidos
	ld (hl),a			;9240   ; a la cola
	inc hl			;9241   ; la siguiente
	ld (0fa2dh),hl		;9242   ; la cola de sonidos
	pop hl			;9245
	ret			;9246
mov_quieto:		; MOVIMIENTO "no se mueve" (17, 24 y 31): la direccion de su dibujo, quieto
	ld c,(ix+02ah)		;9247   ; su X
	ld b,(ix+02bh)		;924a   ; su Y
	ld a,(ix+002h)		;924d   ; en marcha (su dibujo)
	and 007h		;9250   ; la direccion
	or 001h		;9252   ; recta
	ld (0fa02h),a		;9254   ; la direccion del paso
	ret			;9257   ; hecho
mov_recorrido:		; MOVIMIENTO por el recorrido (5, 18 y 29: la ruta, hacia el destino o hacia el protagonista): tramo a tramo (+0x2C), hasta el ultimo (fin: 0xFA03 = 1); cada tramo avanza con el paso de su pendiente
	push iy		;9258   ; IY guardado
	ld l,(ix+01fh)		;925a   ; el recorrido
	ld h,(ix+020h)		;925d
	ld a,(ix+02ch)		;9260   ; el tramo
	cp (hl)			;9263   ; quedan?
	jr c,mov_recorrido_tramo		;9264
mov_fin:
	ld a,001h		;9266   ; acaba
	ld (0fa03h),a		;9268   ; lo que pasa al moverse
	pop iy		;926b
	ret			;926d
mov_recorrido_tramo:
	ld b,(hl)			;926e   ; cuantos puntos
	dec a			;926f   ; el tramo desde 0
	add a,a			;9270   ; x 8
	add a,a			;9271
	add a,a			;9272
	ld e,a			;9273
	ld d,000h		;9274
	inc hl			;9276
	add hl,de			;9277   ; el punto
	push hl			;9278
	pop iy		;9279   ; IY = el punto
	ld a,(ix+026h)		;927b   ; llegado al punto?
	cp (iy+008h)		;927e   ; llegado en Y?
	jr nz,mov_recorrido_paso		;9281
	ld a,(ix+027h)		;9283   ; la X
	cp (iy+009h)		;9286   ; llegado en X?
	jr nz,mov_recorrido_paso		;9289
	inc (ix+02ch)		;928b   ; el tramo siguiente
	ld a,(ix+02ch)		;928e   ; el tramo
	cp b			;9291   ; el ultimo?
	jr nc,mov_fin		;9292   ; acabado
	ld bc,00008h		;9294
	add iy,bc		;9297   ; el punto siguiente
	ld b,(iy+001h)		;9299
	ld a,(iy+002h)		;929c   ; el eje mayor
	and a			;929f
	jr z,mov_recorrido_nuevo		;92a0
	ld b,(iy+000h)		;92a2   ; el otro
mov_recorrido_nuevo:
	ld (iy+006h),000h		;92a5
	ld (iy+007h),b		;92a9
mov_recorrido_paso:
	ld h,(ix+026h)		;92ac   ; la Y
	ld d,(ix+027h)		;92af   ; la X
	ld l,(iy+008h)		;92b2   ; la Y del punto
	ld e,(iy+009h)		;92b5   ; la X
	ld a,(iy+002h)		;92b8   ; el eje
	and a			;92bb
	jr z,mov_recorrido_eje		;92bc
	ex de,hl			;92be   ; cambiadas
mov_recorrido_eje:
	ld a,(iy+003h)		;92bf   ; el paso
	add a,h			;92c2   ; + la posicion
	cp h			;92c3   ; acarreo?
	ld h,a			;92c4
	jr c,mov_recorrido_mira		;92c5
	cp l			;92c7   ; llegado?
	jr c,mov_recorrido_avanza		;92c8
mov_recorrido_llega:
	ld b,l			;92ca
	ld c,e			;92cb
	jr mov_recorrido_pon		;92cc
mov_recorrido_mira:
	cp l			;92ce
	jr z,mov_recorrido_llega		;92cf
	jr c,mov_recorrido_llega		;92d1
mov_recorrido_avanza:
	push hl			;92d3
	ld e,(iy+004h)		;92d4   ; el paso del eje menor
	ld d,(iy+005h)		;92d7
	ld l,(iy+006h)		;92da   ; la suma
	ld h,(iy+007h)		;92dd
	add hl,de			;92e0   ; + el paso
	ld (iy+006h),l		;92e1
	ld (iy+007h),h		;92e4
	pop bc			;92e7
	ld c,h			;92e8   ; la parte entera
mov_recorrido_pon:
	bit 0,(iy+002h)		;92e9   ; el eje
	ld e,(iy+003h)		;92ed   ; el paso del eje mayor
	ld d,(iy+005h)		;92f0
	jr z,mov_recorrido_fin		;92f3   ; X mayor?
	ld a,b			;92f5   ; Y y X cambiadas
	ld b,c			;92f6
	ld c,a			;92f7
	ld a,d			;92f8
	ld d,e			;92f9
	ld e,a			;92fa
mov_recorrido_fin:
	call direccion_de		;92fb   ; la direccion
	ld (ix+026h),b		;92fe   ; la Y del tramo
	ld (ix+027h),c		;9301   ; la X
	ld a,(ix+028h)		;9304   ; + la distancia
	add a,b			;9307
	ld b,a			;9308
	ld a,(ix+029h)		;9309
	add a,c			;930c
	ld c,b			;930d
	ld b,a			;930e
	pop iy		;930f   ; IY
	jp paso_mira		;9311   ; dentro?
mov_fijo:		; MOVIMIENTO fijo en una direccion (8-11, 19-22, 25-28): A = 1 arriba (desde 0x9317, 5 abajo; 0x931A, 3 derecha; 0x931D, 7 izquierda) y un paso (0x94F0)
	ld a,001h		;9314   ; 1; desde 0x9317, 5; desde 0x931A, 3; desde 0x931D, 7
	ld bc,0053eh		;9316
	ld bc,0033eh		;9319
	ld bc,0073eh		;931c
paso_direccion:		; Un paso en la direccion A (0x94F0: BC) desde +0x2A
	call direccion_paso		;931f
paso_mas:		; La posicion + BC; si se sale de su zona (0x9586), C; si no, las casillas del laberinto (0x8F94)
	ld a,(ix+02ah)		;9322   ; su X
	add a,c			;9325
	ld c,a			;9326
	ld a,(ix+02bh)		;9327   ; su Y
	add a,b			;932a
	ld b,a			;932b
paso_mira:
	call fuera_zona		;932c
	ret c			;932f
	call laberinto_casillas		;9330
	and a			;9333
	ret			;9334
mov_ocho:		; MOVIMIENTO "en una de las 8 direcciones" (6): la primera vez una al azar (+0x26), despues siempre esa
	ld a,(ix+026h)		;9335   ; la Y del tramo
	and a			;9338
	jr nz,mov_azar_va		;9339
	call azar		;933b
	and 007h		;933e
	inc a			;9340
	ld (ix+026h),a		;9341   ; la Y del tramo
	jr mov_azar_va		;9344
mov_azar:		; MOVIMIENTO "sin orden" (7): una direccion al azar (+0x27) durante +0x1F pasos (+0x26 la cuenta)
	ld a,(ix+026h)		;9346   ; la Y del tramo
	and a			;9349
	jr nz,mov_azar_paso		;934a
	ld a,(ix+01fh)		;934c   ; su recorrido
	ld (ix+026h),a		;934f   ; la Y del tramo
	call azar		;9352
	and 007h		;9355
	inc a			;9357
	ld (ix+027h),a		;9358   ; la X del tramo
mov_azar_paso:
	dec (ix+026h)		;935b   ; la Y del tramo, uno menos
	ld a,(ix+027h)		;935e   ; la X del tramo
mov_azar_va:
	jp paso_direccion		;9361
mov_aleja_lab:		; MOVIMIENTO en el laberinto "se aleja" (16): la direccion contraria al protagonista
	call hacia_prota		;9364
	ld b,d			;9367
	ld c,e			;9368
	jr mov_acerca_lab_va		;9369
mov_acerca_lab:		; MOVIMIENTO en el laberinto "se acerca" (15): hacia el protagonista (0x952C) cuando le toca (0x9577), eligiendo un eje al azar si hacen falta los dos; si da en pared, la de antes
	call hacia_prota		;936b
mov_acerca_lab_va:
	push bc			;936e
	call le_toca_azar		;936f   ; le toca?
	pop bc			;9372
	jr nc,mov_acerca_lab_otra		;9373   ; no
	ld a,b			;9375
	and a			;9376   ; en Y?
	jr z,mov_acerca_lab_paso		;9377
	ld a,c			;9379
	and a			;937a   ; en X?
	jr z,mov_acerca_lab_paso		;937b
	call azar		;937d   ; los dos: al azar
	bit 1,a		;9380
	ld a,000h		;9382   ; uno a 0
	jr z,mov_acerca_lab_eje		;9384
	ld b,a			;9386
	ld a,c			;9387
mov_acerca_lab_eje:
	ld c,a			;9388
mov_acerca_lab_paso:
	ld d,b			;9389
	ld e,c			;938a
	call paso_dx_dy		;938b
	jr c,mov_acerca_lab_otra		;938e
	ld a,(0fa03h)		;9390   ; lo que pasa al moverse
	and 01ch		;9393
	ret z			;9395
mov_acerca_lab_otra:
	call direccion_impar		;9396
	jp paso_direccion		;9399
mov_azar_lab:		; MOVIMIENTO en el laberinto "sin orden" (14): sigue su direccion; en un cruce o en una pared, otra al azar (de las 4) o la vuelta
	call direccion_impar		;939c
	ld a,001h		;939f
	jr nz,mov_azar_lab_va		;93a1
	ld a,003h		;93a3
mov_azar_lab_va:
	push af			;93a5
	call paso_y_pared		;93a6   ; un paso
	pop bc			;93a9
	jr z,mov_azar_lab_otra		;93aa   ; en pared: otra
	ld a,b			;93ac
	add a,004h		;93ad   ; la vuelta
	call paso_y_pared		;93af   ; un paso
	jr nz,mov_azar_lab_vuelta		;93b2   ; tambien pared
mov_azar_lab_otra:
	call azar		;93b4
	and 003h		;93b7
	add a,a			;93b9
	inc a			;93ba
mov_azar_lab_pon:
	ld (ix+027h),a		;93bb   ; la X del tramo
	jp paso_y_pared		;93be
mov_azar_lab_vuelta:
	ld a,(ix+027h)		;93c1   ; la X del tramo
	call paso_y_pared		;93c4
	ret z			;93c7
	call ficha_paso_vuelve		;93c8
	jr mov_azar_lab_pon		;93cb
paso_y_pared:		; Un paso en la direccion A y NZ si da en pared
	call sonando_no		;93cd
	call paso_direccion		;93d0
	ld a,(0fa03h)		;93d3   ; lo que pasa al moverse
	bit 3,a		;93d6
	ret			;93d8
direccion_impar:		; A = la direccion de +0x27 hecha impar (las 4 rectas); NZ si es horizontal
	ld a,(ix+027h)		;93d9   ; la X del tramo
	and 007h		;93dc
	or 001h		;93de
	bit 1,a		;93e0
	ret			;93e2
mov_acerca:		; MOVIMIENTO "se acerca al protagonista" (12): hacia el (0x952C) cuando le toca (0x9577); si no, al azar
	call hacia_prota		;93e3
	ld d,b			;93e6
	ld e,c			;93e7
	jr mov_aleja_va		;93e8
mov_arma_frente:		; MOVIMIENTO del arma "en la direccion en que mira" (23): un paso en la direccion +0x10
	ld a,(ix+010h)		;93ea   ; su direccion
	jp paso_direccion		;93ed
mov_aleja:		; MOVIMIENTO "se aleja del protagonista" (13)
	call hacia_prota		;93f0
mov_aleja_va:
	call le_toca_azar		;93f3
	jr nc,mov_aleja_azar		;93f6
	ld b,d			;93f8
	ld c,e			;93f9
paso_dx_dy:		; La direccion de DE (0x955B) y un paso de BC
	call direccion_de		;93fa
	jp paso_mas		;93fd
mov_aleja_azar:
	ld a,b			;9400
	and 007h		;9401
	inc a			;9403
	jp paso_direccion		;9404
mov_arma_acerca:		; MOVIMIENTO del arma enemiga "se acerca al protagonista" (30)
	call hacia_prota		;9407
	ld d,b			;940a
	ld e,c			;940b
	jr paso_dx_dy		;940c
mov_prota_4:		; MOVIMIENTO del protagonista con la palanca (0xF9FB), segun lo elegido: 4 direcciones (0x940E: mascara 3, 3), arriba y abajo (0x9413), izquierda y derecha (0x9418) u 8 direcciones (0x941D); si cambia entre quieto y en marcha (0xFAC1), el sonido; se mueve (0x9322) y el fondo con el (0x9596)
	ld bc,00303h		;940e
	jr mov_prota		;9411
mov_prota_v:
	ld bc,00301h		;9413
	jr mov_prota		;9416
mov_prota_h:
	ld bc,00101h		;9418
	jr mov_prota		;941b
mov_prota_8:
	ld bc,00000h		;941d
mov_prota:
	ld a,(0f9fbh)		;9420   ; la palanca
	ld e,000h		;9423
	and a			;9425
	jr z,mov_prota_mira		;9426   ; suelta?
	and b			;9428   ; una direccion que no vale?
	xor c			;9429
	ld e,000h		;942a
	jr nz,mov_prota_mira		;942c
	inc e			;942e
mov_prota_mira:
	ld a,(0fac1h)		;942f   ; antes
	cp e			;9432   ; igual
	ret z			;9433
	and a			;9434
	ld a,0ffh		;9435
	jr z,mov_prota_arranca		;9437
	inc e			;9439
	dec e			;943a
	jr nz,mov_prota_paso		;943b
	xor a			;943d
	ld (0fac1h),a		;943e   ; el protagonista en marcha
	jp sonido_cola		;9441
mov_prota_paso:
	ld a,(0f9fbh)		;9444   ; la palanca
	call direccion_paso		;9447   ; un paso
	ld (0fa55h),bc		;944a   ; guardado
	call paso_mas		;944e
	ret c			;9451
	jp fondo_con_prota		;9452   ; el fondo
mov_prota_arranca:
	ld (0fac1h),a		;9455   ; el protagonista en marcha
	call sonido_mueve		;9458
	jr mov_prota_paso		;945b
tramo_calcula:		; Prepara un tramo del recorrido (HL: el punto de ahora y el siguiente, 8 bytes despues): la diferencia en Y y en X, cual es mayor (+1 de cada punto), la pendiente (division de 8 bits, 0x94A6) y el paso (+0x21 de la ficha, x B)
	push iy		;945d   ; IY guardado
	push hl			;945f
	pop iy		;9460   ; IY = el punto
	push bc			;9462
	push de			;9463
	ld (iy+006h),000h		;9464   ; la cuenta a 0
	ld a,(iy+001h)		;9468
	ld (iy+007h),a		;946b   ; el principio
	ld de,00008h		;946e   ; el punto siguiente: + 8
	ld c,(hl)			;9471   ; su Y
	add hl,de			;9472
	ld a,(hl)			;9473
	sub c			;9474   ; la diferencia
	ld c,a			;9475
	ld b,d			;9476   ; hacia abajo
	jr nc,tramo_calcula_x		;9477
	dec b			;9479   ; hacia arriba
	neg		;947a   ; sin signo
tramo_calcula_x:
	push bc			;947c
	ld c,a			;947d   ; la diferencia en Y
	inc hl			;947e
	ld a,(hl)			;947f   ; la X del siguiente
	and a			;9480
	sbc hl,de		;9481
	sub (hl)			;9483   ; menos la de este
	ld e,a			;9484
	jr nc,tramo_calcula_mayor		;9485   ; hacia la derecha
	dec d			;9487   ; hacia la izquierda
	neg		;9488   ; sin signo
tramo_calcula_mayor:
	push de			;948a
	inc hl			;948b
	ld (hl),000h		;948c   ; el eje: 0
	cp c			;948e   ; cual es mayor?
	ld de,00100h		;948f   ; 1.0
	jr z,tramo_signo		;9492   ; iguales: 45 grados
	jr c,tramo_divide		;9494   ; el vertical
	ld (hl),001h		;9496   ; el eje: 1
	ex de,hl			;9498
	pop hl			;9499
	ex (sp),hl			;949a
	push hl			;949b
	ex de,hl			;949c
	ld b,(iy+000h)		;949d
	ld (iy+007h),b		;94a0   ; el principio en X
	ld b,c			;94a3
	ld c,a			;94a4
	ld a,b			;94a5
tramo_divide:
	push hl			;94a6
	ld l,a			;94a7   ; el mayor
	ld h,000h		;94a8
	ld e,c			;94aa   ; el menor
	ld d,h			;94ab
	ld bc,00000h		;94ac   ; el cociente a 0
	push bc			;94af
	inc c			;94b0   ; el bit 1
tramo_divide_bit:
	add hl,hl			;94b1
	rrc c		;94b2
	rst 20h			;94b4   ; DCOMPR
	jr c,tramo_divide_sig		;94b5
	sbc hl,de		;94b7
	ex (sp),hl			;94b9
	add hl,bc			;94ba
	ex (sp),hl			;94bb
tramo_divide_sig:
	ld a,c			;94bc
	dec a			;94bd
	jr nz,tramo_divide_bit		;94be
	pop de			;94c0
	pop hl			;94c1
tramo_signo:
	pop bc			;94c2
	ex (sp),hl			;94c3   ; el eje
	bit 7,b		;94c4   ; hacia atras?
	jr z,tramo_paso		;94c6
	push hl			;94c8
	ld hl,00000h		;94c9   ; se le da la vuelta
	sbc hl,de		;94cc
	ex de,hl			;94ce
	pop hl			;94cf
tramo_paso:
	ld b,(ix+021h)		;94d0   ; el paso
	ld a,h			;94d3   ; la pendiente 0?
	or l			;94d4
	ld c,h			;94d5   ; la parte entera
	ld h,000h		;94d6
	ld l,h			;94d8
	jr z,tramo_paso_suma		;94d9
	scf			;94db   ; con el bit de arriba
	rl c		;94dc
tramo_paso_suma:
	xor a			;94de
tramo_paso_uno:
	add a,c			;94df   ; + el paso
	add hl,de			;94e0
	djnz tramo_paso_uno		;94e1   ; x la velocidad
	ex de,hl			;94e3
	pop hl			;94e4
	inc hl			;94e5
	ld (hl),a			;94e6   ; el paso
	inc hl			;94e7
	ld (hl),e			;94e8   ; la pendiente
	inc hl			;94e9
	ld (hl),d			;94ea
	pop de			;94eb
	pop bc			;94ec
	pop iy		;94ed   ; IY
	ret			;94ef
direccion_paso:		; La direccion A (1-8, en 0xFA02 y +0x10; 1 arriba, 3 derecha, 5 abajo, 7 izquierda y las de en medio) al paso BC (B en Y, C en X, de +-el paso +0x21)
	push de			;94f0
	push af			;94f1
	cp 001h		;94f2   ; arriba?
	jr z,direccion_paso_va		;94f4
	cp 005h		;94f6   ; abajo?
	jr z,direccion_paso_va		;94f8
	ld a,003h		;94fa   ; derecha
	jr c,direccion_paso_va		;94fc
	ld a,007h		;94fe   ; izquierda
direccion_paso_va:
	ld (0fa02h),a		;9500   ; la direccion del paso
	ld (ix+010h),a		;9503   ; su direccion
	ld a,(ix+021h)		;9506   ; su paso
	ld d,a			;9509
	neg		;950a
	ld e,a			;950c
	ld b,e			;950d
	ld c,000h		;950e
	pop af			;9510
	cp 001h		;9511
	jr z,direccion_paso_fin		;9513
	ld b,d			;9515
	cp 005h		;9516
	jr z,direccion_paso_fin		;9518
	ld c,d			;951a
	jr c,direccion_paso_y		;951b
	ld c,e			;951d
direccion_paso_y:
	and 005h		;951e
	cp 004h		;9520   ; izquierda o derecha?
	jr z,direccion_paso_fin		;9522
	and a			;9524   ; arriba?
	ld b,e			;9525   ; -paso
	jr z,direccion_paso_fin		;9526
	ld b,000h		;9528   ; 0
direccion_paso_fin:
	pop de			;952a
	ret			;952b
hacia_prota:		; BC = el paso hacia el protagonista (0xF9FF) desde la ficha (+0x2A): +-el paso en cada eje o 0; DE = al reves
	ld bc,(0f9ffh)		;952c   ; la posicion del protagonista
	ld a,(ix+021h)		;9530   ; su paso
	ld d,a			;9533
	neg		;9534
	ld e,a			;9536
	ld a,c			;9537
	ld c,(ix+02ah)		;9538   ; su X
	sub c			;953b
	ld a,b			;953c
	ld c,000h		;953d
	jr z,hacia_prota_y		;953f
	ld c,d			;9541
	jr nc,hacia_prota_y		;9542
	ld c,e			;9544
hacia_prota_y:
	ld b,(ix+02bh)		;9545   ; su Y
	sub b			;9548
	ld b,000h		;9549
	jr z,hacia_prota_fin		;954b
	ld b,d			;954d
	jr nc,hacia_prota_fin		;954e
	ld b,e			;9550
hacia_prota_fin:
	ld a,b			;9551   ; -B
	neg		;9552
	ld d,a			;9554
	ld a,c			;9555   ; -C
	neg		;9556
	ld e,a			;9558
	scf			;9559   ; C
	ret			;955a
direccion_de:		; La direccion (1, 3, 5 o 7, a 0xFA02) del paso DE
	ld a,e			;955b   ; la X
	and a			;955c
	jr z,direccion_de_y		;955d   ; 0?
	ld a,003h		;955f   ; derecha
	jp p,direccion_de_pon		;9561   ; positiva
	ld a,007h		;9564   ; izquierda
	jr direccion_de_pon		;9566
direccion_de_y:
	ld a,d			;9568   ; la Y
	and a			;9569
	jr z,direccion_de_pon		;956a   ; 0?
	ld a,005h		;956c   ; abajo
	jp p,direccion_de_pon		;956e
	ld a,001h		;9571   ; arriba
direccion_de_pon:
	ld (0fa02h),a		;9573   ; la direccion del paso
	ret			;9576
le_toca_azar:		; Al azar (0-31) contra +0x1F de la ficha x 4: C si sigue al protagonista esta vez (la rapidez de acercarse)
	call azar		;9577
	and 01fh		;957a
	ld b,a			;957c
	ld a,(ix+01fh)		;957d   ; su recorrido
	rlca			;9580
	rlca			;9581
	add a,000h		;9582
	cp b			;9584
	ret			;9585
fuera_zona:		; C si BC se sale de la zona de la ficha (+0x22); entonces 0xFA03 bit 1 (el borde)
	push ix		;9586
	pop hl			;9588
	ld de,00022h		;9589   ; +0x22: la zona
	call zona_dentro_de		;958c   ; dentro?
	ret nc			;958f   ; si
	ld hl,0fa03h		;9590
	set 1,(hl)		;9593   ; el borde
	ret			;9595
fondo_con_prota:		; Con el desplazamiento del protagonista (0xFA56): si pasa de la Y de +0x37 (o baja de +0x35), 0xFA01 = 0xFF (el fondo se mueve)
	ld hl,0fa01h		;9596
	ld a,(0fa56h)		;9599   ; el sentido del desplazamiento
	and a			;959c
	jr z,fondo_con_prota_va		;959d
	rlca			;959f
	jr c,fondo_con_prota_baja		;95a0
	ld a,(iy+037h)		;95a2
	cp b			;95a5
fondo_con_prota_va:
	ld (hl),000h		;95a6
	ret nc			;95a8
	dec (hl)			;95a9
	ret			;95aa
fondo_con_prota_baja:
	ld a,b			;95ab
	cp (iy+035h)		;95ac
	jr fondo_con_prota_va		;95af
zona_dentro_de:		; HL + DE
	add hl,de			;95b1
zona_dentro:		; NC si BC (X en C, Y en B) esta dentro de la zona de HL (X0, Y0, X1, Y1)
	ld a,c			;95b2   ; la X...
	cp (hl)			;95b3   ; ...por debajo?
	ret c			;95b4
	inc hl			;95b5
	ld a,b			;95b6   ; la Y...
	cp (hl)			;95b7   ; ...por debajo?
	ret c			;95b8
	inc hl			;95b9
	ld a,(hl)			;95ba   ; el final en X...
	cp c			;95bb   ; ...por debajo?
	ret c			;95bc
	inc hl			;95bd
	ld a,(hl)			;95be   ; el final en Y
	cp b			;95bf   ; NC si dentro
	ret			;95c0
azar:		; Un numero al azar: un byte de la ROM (desde 0x8100 hasta 0x81FA, 0xFA3B) + R / 2
	push hl			;95c1
	push bc			;95c2
	ld hl,(0fa3bh)		;95c3   ; donde va
	ld bc,081fah		;95c6
	ld a,l			;95c9   ; al final?
	cp c			;95ca
	jr nz,azar_va		;95cb
	ld hl,08100h		;95cd   ; otra vez desde 0x8100
azar_va:
	ld b,(hl)			;95d0
	ld a,r		;95d1   ; el registro R
	rrca			;95d3
	add a,b			;95d4
	inc hl			;95d5
	ld (0fa3bh),hl		;95d6   ; el puntero del azar
	pop bc			;95d9
	pop hl			;95da
	ret			;95db
presentacion:		; La presentacion: letras blancas, pantalla de texto, borde de color 1, dos dibujos de casilla (0x6F92: el ladrillo, en la 0x88; 0x6FB2 en la 0x80) y tres colores (0x9830); arma en la RAM (0xE000, 0x900 espacios: tres pantallas de alto) una carretera: las marcas del centro con el dibujo de bits de 0x97A0 (cada bit a 1, la casilla 0x90), los tres textos de 0x97DE en sus sitios (0x97D8: PUSH SPACE KEY, COPYRIGHT 1984, BY CASIO) y los muros de ladrillo de los lados (0x971B, 0x9730); la nave (un sprite de 0xA581, el cohete de las muestras), la musica de la presentacion (0xA399) y el gancho de la interrupcion (0xFE68 = "jp 0x9747") que hace correr la carretera hacia abajo; espera la barra
	ld a,00fh		;95dc   ; letras blancas
	ld (0fa36h),a		;95de   ; el color de las letras
	ld a,001h		;95e1
	ld (0fa1bh),a		;95e3   ; en SCREEN 2?
	call texto_entra		;95e6   ; la pantalla de texto
	xor a			;95e9
	ld (0fa1bh),a		;95ea   ; en SCREEN 2?
	call buffer_inicio		;95ed
	ld a,001h		;95f0   ; borde 1
	call borde_pon		;95f2
	ld hl,06f92h		;95f5   ; un dibujo...
	ld de,00440h		;95f8   ; ...en la letra 0x88
	ld bc,00008h		;95fb
	push bc			;95fe
	call 0005ch		;95ff   ; LDIRVM
	ld hl,06fb2h		;9602   ; otro
	ld de,00400h		;9605   ; en la letra 0x80
	pop bc			;9608
	call 0005ch		;9609   ; LDIRVM
	ld b,003h		;960c   ; tres colores
	ld hl,03f10h		;960e   ; desde el grupo 0x10
	ld de,09830h		;9611
presentacion_color:
	ld a,(de)			;9614
	call 0004dh		;9615   ; WRTVRM
	inc hl			;9618
	inc de			;9619
	djnz presentacion_color		;961a
	ld bc,008ffh		;961c   ; 0x900 bytes...
	ld a,020h		;961f   ; ...de espacios...
	ld hl,0e000h		;9621   ; ...en 0xE000
	ld (hl),a			;9624
	ld de,0e001h		;9625
	ldir		;9628
	ld hl,0e020h		;962a   ; la fila 1
	ld de,097a0h		;962d   ; las marcas de la carretera
	ld bc,03890h		;9630   ; 0x38 bytes, la casilla 0x90
presentacion_byte:
	push bc			;9633
	ld a,(de)			;9634
	ld b,008h		;9635   ; 8 bits
presentacion_bit:
	rlca			;9637
	jr nc,presentacion_bit_sig		;9638
	ld (hl),c			;963a   ; la casilla
presentacion_bit_sig:
	inc hl			;963b
	djnz presentacion_bit		;963c
	inc de			;963e
	pop bc			;963f
	djnz presentacion_byte		;9640
	ld de,097deh		;9642   ; los textos
	ld hl,097d8h		;9645   ; sus sitios
	ld b,003h		;9648   ; tres
presentacion_texto:
	push bc			;964a
	ld c,(hl)			;964b   ; el sitio
	inc hl			;964c
	ld b,(hl)			;964d
	inc hl			;964e
presentacion_letra:
	ld a,(de)			;964f
	inc de			;9650
	and a			;9651
	jr z,presentacion_texto_sig		;9652   ; el 0: acaba
	ld (bc),a			;9654
	inc bc			;9655
	jr presentacion_letra		;9656
presentacion_texto_sig:
	pop bc			;9658
	djnz presentacion_texto		;9659
	ld b,002h		;965b   ; dos columnas de casillas 0x80
	ld a,080h		;965d
	ld hl,0e200h		;965f
presentacion_columnas:
	push bc			;9662
	ld b,003h		;9663
	call columnas_pon		;9665
	ld hl,0e21dh		;9668
	pop bc			;966b
	djnz presentacion_columnas		;966c
	ld b,002h		;966e   ; dos bloques de 0x80
	ld a,080h		;9670
	ld hl,0e2c3h		;9672
presentacion_bloques:
	push bc			;9675
	ld b,002h		;9676
	call bloques_pon		;9678
	ld hl,0e2dbh		;967b
	pop bc			;967e
	djnz presentacion_bloques		;967f
	ld b,002h		;9681   ; dos de 0x88
	ld a,088h		;9683
	ld hl,0e38bh		;9685
presentacion_bloques2:
	push bc			;9688
	ld b,002h		;9689
	call bloques_pon		;968b
	ld hl,0e393h		;968e
	pop bc			;9691
	djnz presentacion_bloques2		;9692
	ld hl,0a581h		;9694   ; la nave (el cohete)...
	ld de,01c00h		;9697   ; ...en 0x1C00
	ld bc,00020h		;969a
	call 0005ch		;969d   ; LDIRVM
	ld c,020h		;96a0
	ld a,007h		;96a2   ; color 7
	call sprite_color		;96a4
	ld hl,0b078h		;96a7   ; ...en Y 0xB0, X 0x78
	call sprite_xy		;96aa
	ld a,001h		;96ad   ; un sonido...
	ld (0f423h),a		;96af
	ld (0f422h),a		;96b2   ; cuantos sonidos hay
	ld hl,0a399h		;96b5   ; ...la musica de la presentacion
	ld (0f42dh),hl		;96b8
	ld (0fa9bh),a		;96bb   ; que suene
	ld hl,presentacion_cuadro		;96be   ; la rutina de la interrupcion
	ld (0fe69h),hl		;96c1
presentacion_sube:		; La subida: 0x50 cuadros (0xFA57), desde 0xE600 (0xFA59), 0xFA58 = 0; 8 casillas de la VRAM 0x480 a 0 (0xFC6E) y el texto de 0x9807 (0xFC70); el gancho encendido ("jp")
	ld a,050h		;96c4   ; 0x50 cuadros
	ld (0fa57h),a		;96c6
	ld hl,0e600h		;96c9   ; desde 0xE600
	ld (0fa59h),hl		;96cc
	xor a			;96cf   ; subiendo
	ld (0fa58h),a		;96d0
	ld b,008h		;96d3   ; 8 casillas
	ld hl,0047fh		;96d5   ; desde 0x480
presentacion_borra:
	xor a			;96d8
	inc hl			;96d9
	call 0004dh		;96da   ; WRTVRM
	djnz presentacion_borra		;96dd
	ld (0fc6eh),hl		;96df
	ld hl,09807h		;96e2
	ld (0fc70h),hl		;96e5
	ld a,0c3h		;96e8   ; "jp"
	ld (0fe68h),a		;96ea
presentacion_espera:
	call buffer_saca		;96ed   ; una tecla
	and 07fh		;96f0
	cp 00eh		;96f2   ; la barra?
	jr z,presentacion_fin		;96f4
	ld a,(0fa58h)		;96f6   ; la subida acabada?
	cp 002h		;96f9
	jr c,presentacion_espera		;96fb
	jr presentacion_sube		;96fd   ; otra vez
presentacion_fin:
	ld a,0c9h		;96ff   ; el gancho apagado ("ret")
	ld (0fe68h),a		;9701
	xor a			;9704
	call sonido_pon		;9705   ; el sonido apagado
	ld a,003h		;9708   ; borde 3
	ld (0fa38h),a		;970a   ; el color del borde (el de dibujar)
	call vdp_7		;970d
	ld a,004h		;9710   ; fondo 4
	ld (0fa35h),a		;9712   ; el color de fondo de las letras
	call texto_colores		;9715
	jp sonido_cero		;9718   ; a 0 lo del sonido
columnas_pon:		; B columnas de 0x38 filas... de la casilla A desde HL (0x9728)
	push bc			;971b
	push hl			;971c
	ld b,038h		;971d   ; 0x38 casillas
	call columna_pon		;971f   ; en columna
	pop hl			;9722
	inc hl			;9723   ; la columna siguiente
	pop bc			;9724
	djnz columnas_pon		;9725
	ret			;9727
columna_pon:		; B casillas A en columna (cada 32) desde HL
	ld de,00020h		;9728
	ld (hl),a			;972b
	add hl,de			;972c
	djnz columna_pon		;972d
	ret			;972f
bloques_pon:		; B bloques de 7 x 6 casillas A
	push bc			;9730
	push hl			;9731
	ld b,007h		;9732
bloques_pon_fila:
	push bc			;9734
	ld b,006h		;9735   ; 6 casillas
	call columna_pon		;9737   ; en columna
	ld de,000c0h		;973a   ; la siguiente
	add hl,de			;973d
	pop bc			;973e
	djnz bloques_pon_fila		;973f   ; 7
	pop hl			;9741
	inc hl			;9742   ; la columna siguiente
	pop bc			;9743
	djnz bloques_pon		;9744
	ret			;9746
presentacion_cuadro:		; El gancho de cada cuadro de la presentacion: primero (0xFA58 = 0) la pantalla de texto (0x3C00) se copia desde la RAM 0xFA59, 32 bytes mas arriba cada vez (la carretera corre hacia abajo bajo la nave), hasta 0xE000; despues, letra a letra, el texto de 0xFC70 en la VRAM de 0xFC6E (hacia atras), y 0x50 cuadros de espera
	ld a,(0fa58h)		;9747
	and a			;974a   ; subiendo?
	ld a,(0fa72h)		;974b   ; el sonido...
	jr nz,presentacion_letra_sig		;974e
	and a			;9750   ; ...sonando?
	ret nz			;9751
	ld hl,(0fa59h)		;9752   ; desde donde
	push hl			;9755
	ld bc,00300h		;9756   ; una pantalla
	ld de,03c00h		;9759
	call 0005ch		;975c   ; LDIRVM
	pop hl			;975f
	ld bc,00020h		;9760   ; una fila mas arriba
	and a			;9763
	sbc hl,bc		;9764
	ld (0fa59h),hl		;9766
	ld bc,0e000h		;9769
	sbc hl,bc		;976c   ; arriba del todo?
	ret nc			;976e
	ld a,001h		;976f   ; subida acabada
	ld (0fa58h),a		;9771
	ret			;9774
presentacion_letra_sig:
	and a			;9775
	ret nz			;9776
	ld de,(0fc70h)		;9777   ; el texto
	ld a,(de)			;977b
	and a			;977c
	jr z,presentacion_cuenta		;977d   ; acabado?
	inc de			;977f
	ld (0fc70h),de		;9780
	ld hl,(0fc6eh)		;9784   ; donde va
	bit 3,l		;9787
	jr z,presentacion_letra_pon		;9789
	ld hl,00487h		;978b
presentacion_letra_pon:
	call 0004dh		;978e   ; WRTVRM
	dec hl			;9791
	ld (0fc6eh),hl		;9792
presentacion_cuenta:
	ld hl,0fa57h		;9795
	dec (hl)			;9798   ; un cuadro menos
	ret nz			;9799
	ld a,0ffh		;979a
	ld (0fa58h),a		;979c   ; acabado
	ret			;979f

; ----------------------------------------------------------------------
; DATOS presentacion_datos: Las marcas del centro de la carretera de la
;   presentacion (0x97A0: 0x38 bytes de bits, 4 por fila de 32 casillas), los
;   sitios en la RAM de los tres textos (0x97D8) y los textos (0x97DE: PUSH
;   SPACE KEY, COPYRIGHT 1984 y BY CASIO), el texto de 0x9807 y los tres
;   colores (0x9830)
;   0x97a0..0x9833  (147 bytes)
DATA_presentacion_datos:
	defb 01eh,060h,0c7h,07ch,023h,070h,06fh,060h,020h,068h,053h,078h,027h,064h,043h,060h	; 97a0  .`.|#po` hSx'dC`
	defb 033h,07ah,043h,060h,01fh,061h,043h,03ch,000h,000h,000h,000h,000h,000h,000h,000h	; 97b0  3zC`.aC<........
	defb 030h,060h,062h,0f0h,030h,070h,072h,0c8h,030h,068h,05ah,0c4h,030h,064h,04eh,0c4h	; 97c0  0`b.0pr.0hZ.0dN.
	defb 030h,07ah,046h,0c4h,01fh,061h,042h,07ch,028h,0e2h,069h,0e2h,0ach,0e2h,050h,055h	; 97d0  0zF..aB|(.i...PU
	defb 053h,048h,020h,020h,053h,050h,041h,043h,045h,020h,020h,04bh,045h,059h,000h,043h	; 97e0  SH  SPACE  KEY.C
	defb 04fh,050h,059h,052h,049h,047h,048h,054h,020h,031h,039h,038h,034h,000h,042h,059h	; 97f0  OPYRIGHT 1984.BY
	defb 020h,043h,041h,053h,049h,04fh,000h,001h,002h,004h,008h,010h,020h,040h,080h,003h	; 9800   CASIO...... @..
	defb 007h,00eh,01ch,038h,070h,0e0h,0c0h,007h,00fh,01fh,03eh,07ch,0f8h,0f0h,0e0h,01fh	; 9810  ...8p.....>|....
	defb 03fh,07fh,0ffh,0ffh,0feh,0fch,0f8h,01eh,03ch,001h,0fah,0f9h,0fah,0f8h,0f8h,000h	; 9820  ?.......<.......
	defb 090h,04fh,050h	; 9830

; ======================================================================
; CODIGO 0x9833..0xa2cf  (2716 bytes)
; ======================================================================


sonido_cero:		; 0xFA5C-0xFAC0 (lo del editor de sonido) a 0
	ld hl,0fa5ch		;9833
	ld bc,00065h		;9836
	jp bc_cero		;9839
sonido_editor:		; EL SONIDO (menu 0x0C, 3): el menu 0x87 (nuevo, arreglar, borrar o acabar); nuevo: el nombre (menu 0x88, 0x9939), la clase (menu 0x8A: 0x99C6) y, si es musica, el pentagrama (0x9918); si no, los efectos (menu 0x8F, a 0xFA5C) y el menu 0x8E (0x9A9B)
	xor a			;983c
	ld (0fe13h),a		;983d   ; sin escritura
	call sonido_vacia		;9840   ; la pantalla
	ld a,087h		;9843   ; el menu 0x87
	call menu_y_resta		;9845
	ld a,c			;9848
	cp 001h		;9849   ; nuevo?
	jr z,sonido_arregla		;984b   ; arreglar
	jr nc,sonido_borra		;984d   ; borrar o acabar
	ld a,088h		;984f   ; el nombre
	call nombre_nuevo		;9851
	ld hl,(0fa27h)		;9854   ; la pila de menus...
	dec hl			;9857   ; ...uno menos
	ld (0fa27h),hl		;9858   ; la pila de menus
sonido_clase:
	call sonido_clase_elige		;985b   ; la clase
	cp 001h		;985e   ; musica?
	jp z,sonido_musica		;9860
sonido_efecto:
	ld a,08fh		;9863   ; el menu 0x8F
	call menu_y_resta		;9865
	ld a,c			;9868
	ld (0fa5ch),a		;9869   ; el efecto
	xor a			;986c
	ld (0fa6ah),a		;986d   ; sonando en el editor
	ld a,08eh		;9870   ; el menu 0x8E
	call menu_y_resta		;9872
	call muestra_elige		;9875   ; a probarlo
	jr sonido_editor		;9878
sonido_arregla:		; ARREGLAR un sonido: si no hay (0x992D), el aviso 0x0C; cual (menu 0x89, 0x9A7C); su registro de 13 bytes a 0xFA5D; segun su clase, el pentagrama (0x9A30) o los efectos
	call sonidos_hay		;987a
	jr z,sonido_editor		;987d   ; no hay
	ld a,089h		;987f
	call sonido_elige		;9881
	ld de,0fa5dh		;9884   ; su registro...
	ld bc,0000dh		;9887   ; ...13 bytes
	ldir		;988a
	ld a,(0fa68h)		;988c   ; con notas?
	and a			;988f
	jr z,sonido_arregla_va		;9890
	ld a,(0fa66h)		;9892   ; la clase
	ld c,a			;9895
	cp 001h		;9896
	call z,musica_notas_pide		;9898
sonido_arregla_va:
	cp 001h		;989b
	jr c,sonido_clase		;989d
	jr nz,sonido_efecto		;989f
sonido_guarda_y_menu:
	call pentagrama		;98a1
	jr sonido_editor		;98a4
sonido_borra:		; BORRAR un sonido (opcion 3: acabar vuelve al menu 0x0C): cual (menu 0x86), se quita de la historia y las fichas (0x848E), sus notas fuera de la RAM (0x99F7) y los punteros de los demas movidos (de 0x24 en 0x24), su registro fuera (los de detras suben) y 0xF422 uno menos
	pop de			;98a6
	cp 003h		;98a7   ; acabar?
	jp z,menu_arreglar		;98a9
	push de			;98ac
	call sonidos_hay		;98ad   ; no hay
	jr z,sonido_editor		;98b0
	ld a,086h		;98b2   ; el menu 0x86
	call sonido_elige		;98b4
	push af			;98b7
	call sonido_quita		;98b8   ; se quita de todo
	pop af			;98bb
	call sonido_busca_lista		;98bc   ; su registro
	ld a,(0f422h)		;98bf   ; el ultimo?
	sub b			;98c2
	jr z,sonido_borra_va		;98c3
	call por13		;98c5
sonido_borra_va:
	ld c,a			;98c8
	inc c			;98c9
	ld b,000h		;98ca
	push hl			;98cc
	ld de,0000ah		;98cd   ; sus notas
	add hl,de			;98d0
	ld e,(hl)			;98d1
	inc hl			;98d2
	ld d,(hl)			;98d3
	inc hl			;98d4
	ex de,hl			;98d5
	ld a,(de)			;98d6
	inc de			;98d7
	and a			;98d8
	jr z,sonido_borra_registro		;98d9   ; sin notas
	push de			;98db
	push bc			;98dc
	call notas_quita		;98dd   ; fuera
	ld a,(0f422h)		;98e0   ; los demas
	ld b,a			;98e3
	ld ix,0f423h		;98e4
sonido_borra_mueve:
	xor a			;98e8
	or (ix+00ch)		;98e9   ; con notas?
	jr z,sonido_borra_sig		;98ec
	ld e,(ix+00ah)		;98ee   ; su puntero
	ld d,(ix+00bh)		;98f1
	push hl			;98f4
	sbc hl,de		;98f5   ; por encima?
	jr c,sonido_borra_mueve_va		;98f7
	ld hl,00024h		;98f9   ; baja
	add hl,de			;98fc
	ld (ix+00ah),l		;98fd
	ld (ix+00bh),h		;9900
sonido_borra_mueve_va:
	pop hl			;9903
sonido_borra_sig:
	ld de,0000dh		;9904
	add ix,de		;9907
	djnz sonido_borra_mueve		;9909
	pop bc			;990b
	pop de			;990c
sonido_borra_registro:
	pop hl			;990d
	ex de,hl			;990e
	ldir		;990f   ; los de detras suben
	ld hl,0f422h		;9911
	dec (hl)			;9914   ; uno menos
	jp sonido_editor		;9915
sonido_musica:		; Una musica: el pentagrama (0x9A28); si ya tiene, guardar (0x9B58); si no, el menu 0x8D (los compases?) y a probarla (0x9A9B)
	call musica_menu		;9918
	and a			;991b
	jr nz,sonido_guarda_y_menu		;991c
	xor a			;991e
	ld (0fa6ah),a		;991f   ; sonando en el editor
	ld a,08dh		;9922
	call menu_y_resta		;9924
	call muestra_elige		;9927
	jp sonido_editor		;992a
sonidos_hay:		; Z si no hay sonidos (0xF422): entonces el aviso 0x0C
	ld a,(0f422h)		;992d   ; cuantos sonidos hay
	and a			;9930
	ret nz			;9931
	ld b,00ch		;9932
	call aviso		;9934
	xor a			;9937
	ret			;9938
sonido_nombre:		; El alta del nombre de 0xF868 en un registro nuevo (0xFA5D a 0, el nombre en 0xFA5E): C si ya hay 18 (0x13) o NC/Z si el nombre ya esta; si no, el primer numero libre, el registro en su sitio (ordenado, los de detras bajan) y 0xF422 uno mas
	ld hl,0fa5dh		;9939
	ld bc,0000dh		;993c
	call bc_cero		;993f
	ld hl,0f868h		;9942
	ld de,0fa5eh		;9945
	ld bc,00008h		;9948   ; 8 letras
	ldir		;994b
	ld a,(0f422h)		;994d   ; cuantos
	and a			;9950
	jr z,sonido_nombre_libre		;9951
	cp 013h		;9953   ; 18 ya?
	scf			;9955
	ret z			;9956
	ld hl,0f424h		;9957   ; los nombres
	ld b,a			;995a
sonido_nombre_mira:
	push bc			;995b
	ld de,0fa5eh		;995c   ; el nombre nuevo
	ld b,008h		;995f   ; 8 letras
	push hl			;9961
	call compara_b		;9962   ; el mismo?
	pop hl			;9965
	pop bc			;9966
	scf			;9967
	ccf			;9968
	ret z			;9969   ; el mismo: Z, NC
	push bc			;996a
	ld bc,0000dh		;996b   ; 13 bytes
	add hl,bc			;996e   ; el siguiente
	pop bc			;996f
	djnz sonido_nombre_mira		;9970
sonido_nombre_libre:
	ld hl,0f423h		;9972
	ld a,001h		;9975   ; el primer numero
	ld de,0000dh		;9977
sonido_nombre_busca:
	cp (hl)			;997a
	jr nz,sonido_nombre_pon		;997b
	inc a			;997d
	add hl,de			;997e
	jr sonido_nombre_busca		;997f
sonido_nombre_pon:
	push af			;9981
	ld c,a			;9982
	ld a,(0f422h)		;9983   ; cuantos sonidos hay
	inc a			;9986
	sub c			;9987
	ld c,a			;9988
	jr z,sonido_nombre_abre		;9989
	call por13		;998b
	ld c,a			;998e
	call sonido_ultimo		;998f
sonido_nombre_abre:
	inc c			;9992
	ld b,000h		;9993
	push hl			;9995
	ld de,0000dh		;9996
	add hl,de			;9999
	ex de,hl			;999a
	pop hl			;999b
	lddr		;999c   ; los de detras bajan
	pop af			;999e
	ex de,hl			;999f
	inc de			;99a0
	ld hl,0fa5dh		;99a1   ; el registro nuevo
	ld (hl),a			;99a4
	ld c,00dh		;99a5
	ldir		;99a7
	ld hl,0f422h		;99a9   ; uno mas
	inc (hl)			;99ac
	and a			;99ad
	ret			;99ae
por13:		; A = A x 13
	ld b,a			;99af
	xor a			;99b0
por13_uno:
	add a,00dh		;99b1
	djnz por13_uno		;99b3
	ret			;99b5
sonido_ultimo:		; HL = el registro de detras del ultimo sonido (0xF423 + 0xF422 x 13)
	ld a,(0f422h)		;99b6   ; cuantos sonidos hay
	and a			;99b9
	ld hl,0f423h		;99ba
	ret z			;99bd
	ld b,a			;99be
	ld de,0000dh		;99bf
sonido_ultimo_uno:
	add hl,de			;99c2
	djnz sonido_ultimo_uno		;99c3
	ret			;99c5
sonido_clase_elige:		; El menu 0x8A (que clase de sonido); si cambia (0xFA66), las notas de antes fuera (0x99E5) y 0x9A18
	ld a,08ah		;99c6
	call menu		;99c8
	ld a,(0fa66h)		;99cb   ; la clase de sonido
	cp c			;99ce
	ld a,c			;99cf
	ret z			;99d0
	ld hl,0fa66h		;99d1
	ld (hl),a			;99d4
	call notas_suelta		;99d5
	ld hl,00000h		;99d8
	ld (0fa67h),hl		;99db   ; las notas
	push bc			;99de
	call sonido_registro_guarda		;99df
	pop bc			;99e2
	ld a,c			;99e3
	ret			;99e4
notas_suelta:		; Si hay notas en la RAM (0xFA69), fuera (0x99F7)
	ld a,(0fa69h)		;99e5   ; notas propias en la RAM
	and a			;99e8
	ret z			;99e9
	ld hl,(0fa67h)		;99ea   ; las notas
	push bc			;99ed
	call notas_quita		;99ee
	pop bc			;99f1
	xor a			;99f2
	ld (0fa69h),a		;99f3   ; notas propias en la RAM
	ret			;99f6
notas_quita:		; Quita de la RAM las notas de HL (hasta el mapa, 0xF7EF): lo de detras sube y los punteros cambian
	push hl			;99f7
	push hl			;99f8
	ld de,(0f7efh)		;99f9   ; el principio de las notas
	and a			;99fd
	sbc hl,de		;99fe
	ld c,l			;9a00
	ld b,h			;9a01
	pop hl			;9a02
	push af			;9a03
	dec hl			;9a04
	push hl			;9a05
	ld de,00024h		;9a06
	add hl,de			;9a09
	pop de			;9a0a
	ex de,hl			;9a0b
	pop af			;9a0c
	jr z,notas_quita_fin		;9a0d   ; nada detras?
	lddr		;9a0f   ; lo de detras sube
notas_quita_fin:
	inc de			;9a11
	ex de,hl			;9a12
	ld (0f7efh),hl		;9a13   ; el mapa empieza mas abajo
	pop hl			;9a16
	ret			;9a17
sonido_registro_guarda:		; El registro de 0xFA5D (13 bytes) vuelve a su sitio en la lista (0xA1F7)
	ld a,(0fa5dh)		;9a18   ; el registro del sonido
	call sonido_busca_lista		;9a1b
	ex de,hl			;9a1e
	ld hl,0fa5dh		;9a1f
	ld bc,0000dh		;9a22
	ldir		;9a25
	ret			;9a27
musica_menu:		; El menu 0x8B (de donde salen las notas: nuevas o de muestra); con 0, nada
	ld a,08bh		;9a28
	call menu_y_resta		;9a2a
	ld a,c			;9a2d
	and a			;9a2e
	ret z			;9a2f
musica_notas_pide:		; Las notas de la musica en la RAM (si no estan ya, 0xFA69): 0x24 bytes debajo del mapa (si no caben, "no hay memoria"); nuevas (tempo 0x0D, 0x0F y 32 silencios 0xFC) o copiadas de 0xFA67 (la muestra); el registro, a su sitio
	ld a,(0fa69h)		;9a30   ; notas propias en la RAM
	and a			;9a33
	ld a,c			;9a34
	ret nz			;9a35
	ld hl,(0f7efh)		;9a36   ; el mapa...
	ld de,00024h		;9a39   ; ...0x24 bytes mas abajo
	and a			;9a3c
	sbc hl,de		;9a3d
	ld e,l			;9a3f
	ld d,h			;9a40
	ld bc,(0f7e7h)		;9a41   ; el final de lo usado
	sbc hl,bc		;9a45
	jp c,sin_memoria		;9a47   ; no cabe
	ex de,hl			;9a4a
	ld (0f7efh),hl		;9a4b   ; el mapa, mas abajo
	push af			;9a4e
	ld de,(0fa67h)		;9a4f   ; de donde
	ld (0fa67h),hl		;9a53   ; las notas
	ld a,d			;9a56   ; de la ROM?
	and a			;9a57
	jr nz,musica_notas_copia		;9a58
	ld (hl),00dh		;9a5a   ; el tempo
	inc hl			;9a5c
	ld (hl),00fh		;9a5d   ; las marcas
	inc hl			;9a5f
	inc hl			;9a60
	ld b,020h		;9a61   ; 32 notas
musica_notas_vacias:
	ld (hl),0fch		;9a63   ; silencio
	inc hl			;9a65
	djnz musica_notas_vacias		;9a66
	ld (hl),000h		;9a68   ; el final
musica_notas_fin:
	ld a,024h		;9a6a   ; en la RAM
	ld (0fa69h),a		;9a6c   ; notas propias en la RAM
	call sonido_registro_guarda		;9a6f
	pop af			;9a72
	ret			;9a73
musica_notas_copia:
	ex de,hl			;9a74
	ld bc,00024h		;9a75   ; 0x24 bytes
	ldir		;9a78
	jr musica_notas_fin		;9a7a
sonido_elige:		; Elegir un sonido en el menu A (la lista, 0x7F31): A = su numero (+0 del registro de 0xF416 + C x 13)
	ld (0fa1ah),a		;9a7c   ; el menu
	ld b,011h		;9a7f
	call numero_menu_b		;9a81
	inc c			;9a84
sonido_registro:		; HL = el registro del sonido C (0xF416 + C x 13), A = su numero
	ld b,c			;9a85
	ld hl,0f416h		;9a86
	ld de,0000dh		;9a89
sonido_registro_uno:
	add hl,de			;9a8c
	djnz sonido_registro_uno		;9a8d
	ld a,(hl)			;9a8f
	ret			;9a90
sonido_prueba:		; La barra en los menus 0x8D/0x8E: suena o calla (0x9AE7) la muestra de la opcion (0x9A9B, 0x9ABF)
	call sonido_alterna		;9a91
	ret nc			;9a94
	dec c			;9a95
	call muestra_elige		;9a96
	jr sonido_suena		;9a99
muestra_elige:		; La muestra C del menu: las musicas de 0xA325 o, en el menu 0x8E, los efectos de 0xA3BD de la clase 0xFA5C: su puntero a 0xFA67, sin notas propias, al registro
	call notas_suelta		;9a9b
	ld a,(0fa1ah)		;9a9e   ; el menu
	ld hl,0a325h		;9aa1   ; las musicas de muestra
	cp 08eh		;9aa4   ; el menu de los efectos?
	jr nz,muestra_elige_va		;9aa6
	ld hl,0a3bdh		;9aa8   ; los efectos
	ld a,(0fa5ch)		;9aab   ; de la clase elegida
	call tabla_puntero		;9aae
muestra_elige_va:
	ld a,c			;9ab1
	call tabla_puntero		;9ab2
	ld (0fa67h),hl		;9ab5   ; las notas
	xor a			;9ab8
	ld (0fa69h),a		;9ab9   ; notas propias en la RAM
	jp sonido_registro_guarda		;9abc
sonido_suena:		; Suena el sonido de 0xFA5D (0x9F34, 0xFA9B y 0xFA9D = 0xFF)
	call sonido_vacia		;9abf
	ld a,(0fa5dh)		;9ac2   ; el registro del sonido
	ld (0fa9bh),a		;9ac5   ; el sonido pedido
	ld a,0ffh		;9ac8
	jr sonido_pon		;9aca
sonido_tecla_para:		; Una tecla en un menu de sonido: en el 0x8C, salvo 0x0F; en los demas salvo 0x0E: el sonido para (0xFA6A)
	ld c,a			;9acc
	ld a,(0fa1ah)		;9acd   ; el menu
	cp 08ch		;9ad0
	ld a,00fh		;9ad2
	jr z,sonido_tecla_para_va		;9ad4
	dec a			;9ad6
sonido_tecla_para_va:
	cp c			;9ad7
	ld a,000h		;9ad8
	jr z,sonido_pon		;9ada
	ld (0fa6ah),a		;9adc   ; sonando en el editor
sonido_pon:		; 0xFA9D = A; con 0, todo callado (0xA02B)
	ld (0fa9dh),a		;9adf   ; sonando
	and a			;9ae2
	ret nz			;9ae3
	jp sonido_calla		;9ae4
sonido_alterna:		; Cambia 0xFA6A (sonando o no): C si ahora suena
	ld a,(0fa6ah)		;9ae7   ; sonando en el editor
	and a			;9aea
	ld a,000h		;9aeb
	ld (0fa6ah),a		;9aed   ; sonando en el editor
	ret nz			;9af0
	cpl			;9af1
	ld (0fa6ah),a		;9af2   ; sonando en el editor
	scf			;9af5
	ret			;9af6
tecla_clic:		; El clic de cada tecla (desde buffer_pon): salvo con sonido (0xFA78), la barra en los menus 0x8D y 0x8E y la de volver en el 0x8C con la opcion 2; un tono corto en el canal A (registros 7, 0, 1 y 8 del PSG), una espera y el PSG callado (0xA032)
	push bc			;9af7
	ld c,a			;9af8
	ld a,(0fa78h)		;9af9   ; sonando?
	and a			;9afc
	ld a,c			;9afd
	pop bc			;9afe
	ret nz			;9aff
	push af			;9b00
	push de			;9b01
	push bc			;9b02
	and 07fh		;9b03   ; sin el bit 7
	cp 00eh		;9b05   ; la barra?
	ld c,a			;9b07
	ld a,(0fa1ah)		;9b08   ; el menu
	jr nz,tecla_clic_otra		;9b0b
	cp 08dh		;9b0d
	jr z,tecla_clic_fin		;9b0f
	cp 08eh		;9b11
	jr z,tecla_clic_fin		;9b13
	jr tecla_clic_suena		;9b15
tecla_clic_otra:
	cp 08ch		;9b17
	jr nz,tecla_clic_suena		;9b19
	ld a,c			;9b1b
	cp 00fh		;9b1c
	jr nz,tecla_clic_suena		;9b1e
	ld a,(0fa5bh)		;9b20   ; la opcion del menu
	cp 002h		;9b23
	jr z,tecla_clic_fin		;9b25
tecla_clic_suena:
	ld e,0beh		;9b27   ; solo el tono A
	ld a,007h		;9b29
	call 00093h		;9b2b   ; WRTPSG: el mezclador
	ld e,07eh		;9b2e   ; el tono...
	xor a			;9b30
	call 00093h		;9b31   ; WRTPSG: registro 0
	ld e,000h		;9b34
	ld a,001h		;9b36
	call 00093h		;9b38   ; WRTPSG: registro 1
	ld e,00fh		;9b3b   ; volumen 15
	ld a,008h		;9b3d
	call 00093h		;9b3f   ; WRTPSG: registro 8
	ld bc,00a00h		;9b42   ; una espera
tecla_clic_espera:
	dec bc			;9b45
	ld a,b			;9b46
	or c			;9b47
	jr nz,tecla_clic_espera		;9b48
	call psg_calla		;9b4a   ; callado
tecla_clic_fin:
	pop bc			;9b4d
	pop de			;9b4e
	pop af			;9b4f
	ret			;9b50
menu_opcion_guarda:		; La opcion C a 0xFA5B (guardando AF)
	push af			;9b51
	ld a,c			;9b52
	ld (0fa5bh),a		;9b53   ; la opcion del menu
	pop af			;9b56
	ret			;9b57
pentagrama:		; EL PENTAGRAMA (la musica): la pantalla limpia, dos colores 0x1C (0x3F02), los textos de 0xA509 (* ふめん *, TEMPO, REPEAT, CHORD y しょうせつめ) cada dos filas, el tempo, REPEAT y CHORD (ON/OFF), las tres flechas de sprite (0x38-0x3A), las lineas (0x9C8B), la pagina 0 (0x9D76, 0x9CBE), la barra de compas; y el menu 0x8C: 1 escribir notas (0x9DB0), 2 que suene, 3 el tempo siguiente (de 0xA31E), 4 REPEAT, 5 CHORD, 6 acabar
	xor a			;9b58
	ld (0fa6ah),a		;9b59   ; sonando en el editor
	inc a			;9b5c
	ld (0fa5bh),a		;9b5d   ; la opcion del menu
	call pantalla_texto_limpia		;9b60
	ld hl,03f02h		;9b63
	ld a,01ch		;9b66   ; color 0x1C
	call 0004dh		;9b68   ; WRTVRM
	inc hl			;9b6b
	ld a,01ch		;9b6c
	call 0004dh		;9b6e   ; WRTVRM
	ld b,005h		;9b71   ; cinco textos
	ld de,0010ch		;9b73   ; desde la fila 1, columna 0x0C
	ld hl,0a509h		;9b76   ; los textos
pentagrama_texto:
	push bc			;9b79
	ld (0fa1dh),de		;9b7a   ; la posicion del cursor
	call texto_pinta_hl		;9b7e
	inc hl			;9b81
	ld bc,00200h		;9b82   ; dos filas mas abajo
	ex de,hl			;9b85
	add hl,bc			;9b86
	ex de,hl			;9b87
	pop bc			;9b88
	djnz pentagrama_texto		;9b89
	ld ix,(0fa67h)		;9b8b   ; las notas
	call tempo_pinta		;9b8f   ; el tempo
	call repeat_pinta		;9b92   ; REPEAT
	call chord_pinta		;9b95   ; CHORD
	ld c,037h		;9b98   ; los sprites 0x38...
	ld hl,05060h		;9b9a   ; ...en Y 0x50, X 0x60
	ld d,003h		;9b9d   ; tres
pentagrama_flecha:
	push hl			;9b9f
	inc c			;9ba0
	ld a,001h		;9ba1   ; color 1
	call sprite_color		;9ba3
	pop hl			;9ba6
	push hl			;9ba7
	call sprite_xy		;9ba8
	pop hl			;9bab
	ld a,010h		;9bac   ; 16 puntos mas abajo
	add a,h			;9bae
	ld h,a			;9baf
	ld b,d			;9bb0
	dec d			;9bb1
	djnz pentagrama_flecha		;9bb2
	call pentagrama_lineas		;9bb4   ; las lineas
	ld de,00000h		;9bb7   ; la pagina 0
	ld (0fa6eh),de		;9bba   ; la nota y la pagina
	call pagina_pinta		;9bbe
	call pentagrama_pagina		;9bc1
	ld hl,(0fa67h)		;9bc4   ; las notas...
	inc hl			;9bc7   ; ...desde +3
	inc hl			;9bc8
	inc hl			;9bc9
	ld (0fa6bh),hl		;9bca   ; la nota del cursor
	ld de,0000ah		;9bcd   ; columna 0x0A
	ld b,018h		;9bd0   ; 24 filas
pentagrama_barra:
	push bc			;9bd2
	ld a,083h		;9bd3   ; la casilla 0x83
	ld c,e			;9bd5
	ld b,d			;9bd6
	call letra_en_bc		;9bd7
	inc d			;9bda
	pop bc			;9bdb
	djnz pentagrama_barra		;9bdc
pentagrama_menu:
	ld a,08ch		;9bde   ; el menu 0x8C
	call menu_va		;9be0
	ld a,c			;9be3
	ld (0fa5bh),a		;9be4   ; la opcion
	cp 002h		;9be7   ; escribir?
	jr c,pentagrama_escribe		;9be9   ; que suene?
	jr z,pentagrama_suena		;9beb
	cp 004h		;9bed   ; el tempo?
	jr c,pentagrama_tempo		;9bef
	jr z,pentagrama_repeat		;9bf1   ; REPEAT?
	cp 006h		;9bf3   ; acabar?
	ret z			;9bf5
	ld ix,(0fa67h)		;9bf6   ; CHORD: el bit 4 de +1...
	bit 4,(ix+001h)		;9bfa
	set 4,(ix+001h)		;9bfe   ; ...cambia
	jr z,pentagrama_chord		;9c02
	res 4,(ix+001h)		;9c04
pentagrama_chord:
	call chord_pinta		;9c08
	jr pentagrama_menu		;9c0b
pentagrama_escribe:
	call notas_escribe		;9c0d
	jr pentagrama_menu		;9c10
pentagrama_suena:
	call sonido_alterna		;9c12
	jr nc,pentagrama_menu		;9c15
	call sonido_suena		;9c17
	jr pentagrama_menu		;9c1a
pentagrama_tempo:		; El tempo siguiente de la tabla de 0xA314 (despues del ultimo, 0x29) a +0 de las notas
	ld ix,(0fa67h)		;9c1c   ; las notas
	call tempo_numero		;9c20
	cp 009h		;9c23   ; el ultimo?
	jr z,pentagrama_tempo_1		;9c25
	inc hl			;9c27   ; el siguiente
	inc hl			;9c28
	ld a,(hl)			;9c29
pentagrama_tempo_pon:
	ld (ix+000h),a		;9c2a
	call tempo_pinta		;9c2d
	jr pentagrama_menu		;9c30
pentagrama_tempo_1:
	ld a,029h		;9c32
	jr pentagrama_tempo_pon		;9c34
pentagrama_repeat:		; REPEAT: el bit 6 de +1 cambia
	ld ix,(0fa67h)		;9c36   ; las notas
	bit 6,(ix+001h)		;9c3a
	set 6,(ix+001h)		;9c3e
	jr z,pentagrama_repeat_va		;9c42
	res 6,(ix+001h)		;9c44
pentagrama_repeat_va:
	call repeat_pinta		;9c48
	jr pentagrama_menu		;9c4b
menu_opcion_lee:		; C = la opcion guardada (0xFA5B)
	ld a,(0fa5bh)		;9c4d   ; la opcion del menu
	ld c,a			;9c50
	ret			;9c51
tempo_numero:		; A = el numero del tempo de +0 (su sitio en la tabla de 0xA314, de 0 a 9); BC = su sitio en la pantalla
	ld a,(ix+000h)		;9c52
	ld hl,0a31eh		;9c55   ; la tabla de los tempos
	ld bc,0000ah		;9c58
	cpdr		;9c5b   ; busca hacia atras
	ld a,c			;9c5d
	ld bc,00313h		;9c5e
	ret			;9c61
tempo_pinta:		; El numero del tempo en la pantalla
	call tempo_numero		;9c62
	add a,030h		;9c65
	jp letra_en_bc		;9c67
chord_pinta:		; ON u OFF de CHORD (bit 4 de +1) en la fila 7
	ld a,(ix+001h)		;9c6a
	ld bc,00713h		;9c6d
	bit 4,a		;9c70
	jr on_off_pinta		;9c72
repeat_pinta:		; ON u OFF de REPEAT (bit 6 de +1) en la fila 5
	ld a,(ix+001h)		;9c74
	ld bc,00513h		;9c77
	bit 6,a		;9c7a
on_off_pinta:
	ld hl,0a539h		;9c7c   ; "ON"
	jr nz,on_off_pinta_va		;9c7f
	ld hl,0a53dh		;9c81   ; "OFF"
on_off_pinta_va:
	ld (0fa1dh),bc		;9c84   ; la posicion del cursor
	jp texto_pinta_hl		;9c88
pentagrama_lineas:		; Las 18 columnas del pentagrama (desde la 0x0B): cada una con sus lineas (0x9C9B)
	ld a,00bh		;9c8b
	ld b,012h		;9c8d
pentagrama_lineas_uno:
	push af			;9c8f
	call pentagrama_columna		;9c90   ; una columna
	pop af			;9c93
	inc a			;9c94   ; la siguiente
	djnz pentagrama_lineas_uno		;9c95
	ret			;9c97
nota_borra:		; Borra la nota de la columna (0x9D92) con las lineas
	call nota_col		;9c98
pentagrama_columna:		; Una columna del pentagrama desde la fila 0x0A: dos veces la casilla 0x1A y dos 0x19
	push bc			;9c9b
	ld l,a			;9c9c
	ld a,00ah		;9c9d
	ld h,a			;9c9f
	ld b,002h		;9ca0
pentagrama_columna_dos:
	push bc			;9ca2
	ld a,01ah		;9ca3   ; la casilla 0x1A
	ld c,l			;9ca5
	ld b,h			;9ca6
	call letra_en_bc		;9ca7   ; pintada
	inc h			;9caa   ; la fila de abajo
	ld b,002h		;9cab   ; dos
	ld a,019h		;9cad   ; la casilla 0x19
pentagrama_columna_uno:
	push bc			;9caf
	ld c,l			;9cb0
	ld b,h			;9cb1
	call letra_en_bc		;9cb2   ; la linea
	inc h			;9cb5   ; la fila de abajo
	pop bc			;9cb6
	djnz pentagrama_columna_uno		;9cb7
	pop bc			;9cb9
	djnz pentagrama_columna_dos		;9cba
	pop bc			;9cbc
	ret			;9cbd
pentagrama_pagina:		; Las 8 notas de la pagina D (desde +3 + D x 8): 0 la barra de compas (0x9CF5), 1 el silencio (0x9D10), las demas, su cabeza (0x9D41) y, si sale del pentagrama, la linea (0x9D23)
	ld e,000h		;9cbe   ; la nota 0
	ld a,d			;9cc0   ; la pagina...
	rlca			;9cc1   ; ...x 8
	rlca			;9cc2
	rlca			;9cc3
	ld hl,(0fa67h)		;9cc4   ; las notas
	inc hl			;9cc7   ; +3: las notas
	inc hl			;9cc8
	inc hl			;9cc9
	ld c,a			;9cca
	ld b,000h		;9ccb
	add hl,bc			;9ccd   ; la primera de la pagina
	ld b,008h		;9cce   ; 8
pentagrama_nota:
	push bc			;9cd0
	ld a,(hl)			;9cd1   ; la nota
	push hl			;9cd2
	cp 001h		;9cd3   ; 0?
	jr c,pentagrama_compas		;9cd5
	jr z,pentagrama_silencio		;9cd7   ; 1: silencio
	call nota_numero		;9cd9   ; su altura
	jr c,pentagrama_nota_cabeza		;9cdc
	call nota_linea		;9cde   ; la linea de mas
pentagrama_nota_cabeza:
	call nota_cabeza		;9ce1
pentagrama_nota_sig:
	inc e			;9ce4   ; la siguiente
	pop hl			;9ce5
	inc hl			;9ce6   ; la nota siguiente
	pop bc			;9ce7
	djnz pentagrama_nota		;9ce8
	ret			;9cea
pentagrama_compas:
	call compas_pinta		;9ceb
	jr pentagrama_nota_sig		;9cee
pentagrama_silencio:
	call silencio_pinta		;9cf0
	jr pentagrama_nota_sig		;9cf3
compas_pinta:		; La barra de compas (la casilla 0x1D en cuatro filas de la columna de la nota)
	call nota_col		;9cf5   ; la columna
	push bc			;9cf8
	ld c,a			;9cf9
	ld b,00bh		;9cfa   ; la fila 0x0B
	ld a,01dh		;9cfc   ; la casilla 0x1D
	call letra_en_bc		;9cfe
	inc b			;9d01
	call letra_en_bc		;9d02   ; la fila de abajo
	inc b			;9d05
	inc b			;9d06
	call letra_en_bc		;9d07   ; dos mas abajo
	inc b			;9d0a
	call letra_en_bc		;9d0b   ; la ultima
	pop bc			;9d0e
	ret			;9d0f
silencio_pinta:		; El silencio (las casillas 0x1E y 0x1F)
	call nota_col		;9d10
	push bc			;9d13   ; la columna
	ld c,a			;9d14
	ld b,00bh		;9d15   ; la fila 0x0B
	ld a,01eh		;9d17   ; la casilla 0x1E
	call letra_en_bc		;9d19
	inc b			;9d1c
	inc a			;9d1d   ; y la 0x1F
	call letra_en_bc		;9d1e
	pop bc			;9d21
	ret			;9d22
nota_linea:		; La linea de fuera del pentagrama de una nota (0x1B; en las filas 0x0A y 0x0D, 0x1C)
	call nota_col		;9d23   ; la columna
	dec a			;9d26
	ld l,a			;9d27
	call nota_fila		;9d28   ; la fila
	push bc			;9d2b
	ld b,a			;9d2c
	ld c,l			;9d2d
	cp 00ah		;9d2e   ; la 0x0A?
	jr z,nota_linea_otra		;9d30
	cp 00dh		;9d32   ; la 0x0D?
	jr z,nota_linea_otra		;9d34
	ld a,01bh		;9d36   ; la linea 0x1B
nota_linea_pon:
	call letra_en_bc		;9d38
	pop bc			;9d3b
	ret			;9d3c
nota_linea_otra:
	ld a,01ch		;9d3d
	jr nota_linea_pon		;9d3f
nota_cabeza:		; La cabeza de la nota (la casilla de 0xA301 + nota) en su fila (0x9D83) y columna (0x9D92); en las de sostenido (L & 3 = 1), el signo debajo (0x13; 0x18 en la 9)
	push bc			;9d41
	call nota_fila		;9d42   ; su fila
	ld b,a			;9d45
	call nota_col		;9d46   ; su columna
	ld c,a			;9d49
	pop hl			;9d4a
	push hl			;9d4b
	ld h,000h		;9d4c
	push bc			;9d4e
	ld bc,0a301h		;9d4f   ; las casillas de las cabezas
	add hl,bc			;9d52
	ld a,(hl)			;9d53   ; la de esta nota
	pop bc			;9d54
	call letra_en_bc		;9d55   ; pintada
	pop hl			;9d58
	ld a,l			;9d59
	and 003h		;9d5a   ; sostenido?
	cp 001h		;9d5c
	jr nz,nota_cabeza_fin		;9d5e
	inc b			;9d60   ; la fila de abajo
	ld a,l			;9d61
	cp 009h		;9d62   ; la 9?
	ld a,018h		;9d64   ; el signo 0x18
	jr z,nota_cabeza_signo		;9d66
	ld a,013h		;9d68   ; el signo 0x13
nota_cabeza_signo:
	call letra_en_bc		;9d6a
nota_cabeza_fin:
	ld c,l			;9d6d
	ret			;9d6e
nota_columna_borra:		; La columna de la nota, con sus lineas otra vez
	call nota_col		;9d6f
	dec a			;9d72
	jp pentagrama_columna		;9d73
pagina_pinta:		; El numero de la pagina (D + 1) en la fila 9, columna 0x10
	ld a,d			;9d76   ; la pagina...
	inc a			;9d77   ; ...desde 1...
	add a,030h		;9d78   ; ...en cifra
	push bc			;9d7a
	ld bc,00910h		;9d7b   ; fila 9, columna 0x10
	call letra_en_bc		;9d7e   ; pintada
	pop bc			;9d81
	ret			;9d82
nota_fila:		; La fila de la nota C: 0x0A + (C + 2) / 4 (0x0A con 0)
	ld a,c			;9d83
	and a			;9d84   ; 0?
	ld a,00ah		;9d85   ; la fila 0x0A
	ret z			;9d87
	ld a,c			;9d88
	inc a			;9d89   ; + 2
	inc a			;9d8a
	srl a		;9d8b   ; / 4
	srl a		;9d8d
	add a,00ah		;9d8f   ; + 0x0A
	ret			;9d91
nota_col:		; La columna de la nota E: 0x0E + E x 2
	ld a,e			;9d92
	add a,a			;9d93
	add a,00eh		;9d94
	ret			;9d96
nota_numero:		; La nota A en la tabla de 0xA2D3 (0x2E notas): C = su numero; de la 0x19 en adelante, la octava de arriba (0xFA6D = 1)
	ld bc,0002eh		;9d97
	ld hl,0a2d3h		;9d9a   ; la tabla de las notas
	cpir		;9d9d   ; la busca
	ld a,02dh		;9d9f   ; 0x2D - lo que queda
	sub c			;9da1
	ld c,a			;9da2
	cp 019h		;9da3   ; la octava de abajo?
	ret c			;9da5
	sub 019h		;9da6   ; la de arriba
	ld c,a			;9da8
	ld a,001h		;9da9
	ld (0fa6dh),a		;9dab   ; la marca de la nota
	and a			;9dae
	ret			;9daf
notas_escribe:		; Escribir notas: el cursor en el pentagrama (0x9E21): la barra pone la nota (0x9E07), arriba y abajo la suben o bajan (0x10/0x14), izquierda y derecha cambian de nota (0x12/0x16), volver acaba
	ld hl,(0fa1dh)		;9db0   ; la posicion del cursor
	ld (0fa25h),hl		;9db3
	ld a,004h		;9db6   ; el cursor
	ld (0fa37h),a		;9db8   ; la clase de cursor
	ld de,(0fa6eh)		;9dbb   ; la nota y la pagina
notas_escribe_bucle:
	call nota_cursor		;9dbf
notas_escribe_tecla:
	ld (0fa6eh),de		;9dc2   ; la nota y la pagina
	push de			;9dc6
	push bc			;9dc7
	call tecla_espera_texto		;9dc8   ; una tecla
	pop bc			;9dcb
	pop de			;9dcc
	cp 00fh		;9dcd   ; volver?
	ret z			;9dcf
	cp 00eh		;9dd0   ; la barra?
	jr z,notas_escribe_pon		;9dd2
	and 07fh		;9dd4
	cp 012h		;9dd6   ; izquierda?
	jr z,notas_escribe_izq		;9dd8
	cp 016h		;9dda   ; derecha?
	jr z,notas_escribe_der		;9ddc
	ld b,000h		;9dde
	cp 010h		;9de0   ; arriba?
	jr z,notas_escribe_altura		;9de2
	inc b			;9de4
	cp 014h		;9de5   ; abajo?
	jr nz,notas_escribe_tecla		;9de7
notas_escribe_altura:
	ld a,(0fa6dh)		;9de9   ; la marca de la nota
	cp 001h		;9dec
	jr c,notas_escribe_sube		;9dee
	jr nz,notas_escribe_tecla		;9df0
	xor a			;9df2
	ld (0fa6dh),a		;9df3   ; la marca de la nota
	call nota_columna_borra		;9df6
	push bc			;9df9
	call nota_de_tabla		;9dfa
	pop bc			;9dfd
	inc b			;9dfe
	dec b			;9dff
	jr nz,notas_escribe_tecla		;9e00
notas_escribe_baja:
	call nota_baja		;9e02
	jr notas_escribe_tecla		;9e05
notas_escribe_pon:
	call nota_alterna		;9e07
	jr c,notas_escribe_altura		;9e0a
	jr notas_escribe_tecla		;9e0c
notas_escribe_izq:
	call nota_siguiente		;9e0e
	jr notas_escribe_bucle		;9e11
notas_escribe_der:
	call nota_anterior		;9e13
	jr notas_escribe_bucle		;9e16
notas_escribe_sube:
	inc b			;9e18
	dec b			;9e19
	jr z,notas_escribe_baja		;9e1a
	call nota_sube		;9e1c
	jr notas_escribe_tecla		;9e1f
nota_cursor:		; El cursor del pentagrama (los sprites de 0xFA1F) en la nota de 0xFA6B: con 0 (compas) o 1 (silencio), 0xFA6D = 3 o 2 y la fila 5; si no, su altura (0x9D97); X = la columna x 8, Y = 0x52 + fila x 2
	xor a			;9e21
	ld (0fa6dh),a		;9e22   ; la marca de la nota
	ld (0fa70h),a		;9e25   ; la nota de antes
	ld hl,(0fa6bh)		;9e28   ; la nota
	ld a,(hl)			;9e2b   ; 0?
	cp 001h		;9e2c
	jr c,nota_cursor_compas		;9e2e
	jr z,nota_cursor_silencio		;9e30   ; 1?
	call nota_numero		;9e32   ; su numero
	jr nota_cursor_pon		;9e35
nota_cursor_compas:
	ld a,003h		;9e37
nota_cursor_marca:
	ld (0fa6dh),a		;9e39   ; la marca de la nota
	ld c,005h		;9e3c
	jr nota_cursor_pon		;9e3e
nota_cursor_silencio:
	ld a,002h		;9e40
	jr nota_cursor_marca		;9e42
nota_cursor_pon:
	call nota_col		;9e44
	rlca			;9e47
	rlca			;9e48
	rlca			;9e49
	ld (0fa1fh),a		;9e4a   ; la X
	ld a,c			;9e4d
	add a,a			;9e4e
	add a,052h		;9e4f
	ld (0fa20h),a		;9e51   ; la Y
	and a			;9e54
	ret			;9e55
nota_de_tabla2:		; La nota C de la tabla de 0xA2EC (la octava de arriba) a la posicion 0xFA6B
	ld hl,0a2ech		;9e56
	jr nota_de_tabla_va		;9e59
nota_de_tabla:		; La nota C de la tabla de 0xA2D3 a la posicion 0xFA6B
	ld hl,0a2d3h		;9e5b
nota_de_tabla_va:
	ld b,000h		;9e5e
	add hl,bc			;9e60
	ld a,(hl)			;9e61
	ld hl,(0fa6bh)		;9e62   ; la nota del cursor
	ld (hl),a			;9e65
	and a			;9e66
	ret			;9e67
nota_baja:		; La nota un semitono mas abajo (C - 1, hasta 0): borrada y pintada otra vez, el cursor 2 filas
	ld a,c			;9e68
	and a			;9e69   ; la mas baja?
	ret z			;9e6a
	dec c			;9e6b   ; un semitono menos
	call nota_de_tabla		;9e6c   ; a la posicion
	call nota_borra		;9e6f   ; borrada
	call nota_cabeza		;9e72   ; la nueva
	ld hl,0fa20h		;9e75   ; el cursor...
	dec (hl)			;9e78   ; ...dos filas
	dec (hl)			;9e79
	ret			;9e7a
nota_sube:		; Un semitono mas arriba (hasta 0x14)
	ld a,c			;9e7b
	cp 014h		;9e7c   ; la mas alta?
	ret z			;9e7e
	inc c			;9e7f   ; un semitono mas
	call nota_de_tabla		;9e80   ; a la posicion
	call nota_borra		;9e83   ; borrada
	call nota_cabeza		;9e86   ; la nueva
	ld hl,0fa20h		;9e89   ; el cursor...
	inc (hl)			;9e8c   ; ...dos filas
	inc (hl)			;9e8d
	ret			;9e8e
nota_anterior:		; La nota de antes (en la primera de la pagina, la pagina anterior)
	ld a,d			;9e8f
	or e			;9e90   ; la primera de todas?
	ret z			;9e91
	ld hl,(0fa6bh)		;9e92   ; la nota del cursor
	dec hl			;9e95
	ld (0fa6bh),hl		;9e96   ; la nota del cursor
	ld a,e			;9e99
	dec e			;9e9a   ; la primera de la pagina?
	and a			;9e9b
	ret nz			;9e9c
	call pentagrama_lineas		;9e9d
	dec d			;9ea0
	call pagina_pinta		;9ea1
	call pentagrama_pagina		;9ea4
	ld e,007h		;9ea7
	ret			;9ea9
nota_siguiente:		; La nota siguiente (en la ultima de la pagina, la siguiente; hasta la pagina 3, nota 7)
	ld a,d			;9eaa
	cp 003h		;9eab   ; la ultima pagina?
	jr nz,nota_siguiente_va		;9ead
	ld a,e			;9eaf   ; y la ultima nota?
	cp 007h		;9eb0
	ret z			;9eb2
nota_siguiente_va:
	ld hl,(0fa6bh)		;9eb3   ; la nota del cursor
	inc hl			;9eb6
	ld (0fa6bh),hl		;9eb7   ; la nota del cursor
	inc e			;9eba
	bit 3,e		;9ebb
	ret z			;9ebd
	call pentagrama_lineas		;9ebe
	inc d			;9ec1
	call pagina_pinta		;9ec2
	call pentagrama_pagina		;9ec5
	ld e,000h		;9ec8
	ret			;9eca
nota_alterna:		; La barra en una nota: va pasando nota -> silencio -> barra de compas -> nota (0xFA6D); las notas de la tabla 0xA31F (6) no; la nota de antes se guarda (0xFA70) para volver a ella
	ld hl,(0fa6bh)		;9ecb   ; la nota del cursor
	ld a,(0fa6dh)		;9ece   ; que hay
	and a			;9ed1
	jr nz,nota_alterna_va		;9ed2
	push hl			;9ed4
	push bc			;9ed5
	ld a,c			;9ed6
	ld hl,0a31fh		;9ed7   ; las que no
	ld bc,00006h		;9eda
	cpir		;9edd
	pop bc			;9edf
	pop hl			;9ee0
	ld b,000h		;9ee1
	scf			;9ee3
	ret z			;9ee4
	ld a,001h		;9ee5
	ld (0fa6dh),a		;9ee7   ; la marca de la nota
	push hl			;9eea
	call nota_linea		;9eeb
	pop hl			;9eee
	ld a,(hl)			;9eef
	ld (0fa70h),a		;9ef0   ; la nota de antes
	jp nota_de_tabla2		;9ef3
nota_alterna_va:
	cp 002h		;9ef6
	jr z,nota_alterna_compas		;9ef8
	jr c,nota_alterna_silencio		;9efa
	xor a			;9efc
	ld (0fa6dh),a		;9efd   ; la marca de la nota
	ld a,(0fa70h)		;9f00   ; la nota de antes
	and a			;9f03
	jr nz,nota_alterna_nota		;9f04
	ld a,0e0h		;9f06
nota_alterna_nota:
	ld (hl),a			;9f08
	call nota_numero		;9f09
	call nota_borra		;9f0c
	call nota_cabeza		;9f0f
	jp nota_cursor_pon		;9f12
nota_alterna_silencio:
	inc a			;9f15
	ld (0fa6dh),a		;9f16   ; la marca de la nota
	dec a			;9f19
	ld (hl),a			;9f1a
	call nota_columna_borra		;9f1b
	call nota_borra		;9f1e
	call silencio_pinta		;9f21
nota_alterna_fin:
	ld c,005h		;9f24
	jp nota_cursor_pon		;9f26
nota_alterna_compas:
	inc a			;9f29
	ld (0fa6dh),a		;9f2a   ; la marca de la nota
	xor a			;9f2d
	ld (hl),a			;9f2e
	call compas_pinta		;9f2f
	jr nota_alterna_fin		;9f32
sonido_vacia:		; Lo del sonido a 0 (0xFA71, 0x51 bytes), la pila de sonidos vacia (0xFAA6 = 0xFABF) y la cola (0xA232)
	ld hl,0fa71h		;9f34
	ld bc,00051h		;9f37
	call bc_cero		;9f3a
	ld hl,0fabfh		;9f3d
	ld (0faa6h),hl		;9f40   ; la pila de sonidos
	call sonido_cola_vacia		;9f43
	ret			;9f46
sonido_para:		; Todo callado (0x9ADF con 0) y vacio
	xor a			;9f47
	call sonido_pon		;9f48
	call sonido_vacia		;9f4b
	ret			;9f4e
sonido_empieza:		; El sonido pedido (0xFA9B) si esta en la lista y tiene notas (0xA0EB): su principio; si ya suena otro (0xFA78): con 0xFA9C, ese pasa delante; si no, el que suena se guarda en la pila (0xFAA8-0xFABF, 3 bytes, 0xFAC0 cuantos; llena, se tira el de abajo) si es de repetir o aun no ha acabado; y empieza (0xA0F9)
	ld a,(0fa9bh)		;9f4f   ; pedido?
	and a			;9f52
	jr z,sonido_cuadro		;9f53
	call sonido_busca		;9f55   ; esta?
	ret nc			;9f58
	call sonido_notas		;9f59   ; sus notas
	inc hl			;9f5c
	inc hl			;9f5d
	inc hl			;9f5e
	ld (0faa1h),hl		;9f5f
	ld a,(0fa9ch)		;9f62   ; delante?
	and a			;9f65
	jr z,sonido_empieza_va		;9f66
	ld (0fa79h),a		;9f68   ; el de delante
sonido_empieza_va:
	ld a,(0fa78h)		;9f6b   ; sonando otro?
	and a			;9f6e
	jr z,sonido_empieza_ya		;9f6f
	ld a,(0fa79h)		;9f71   ; el de delante
	and a			;9f74
	jr nz,sonido_delante		;9f75
	ld hl,(0faa6h)		;9f77   ; la pila
	ld bc,0faa8h		;9f7a
	sbc hl,bc		;9f7d   ; llena?
	jr nc,sonido_empieza_guarda		;9f7f
	ld hl,0fabch		;9f81
	ld de,0fabfh		;9f84
	ld bc,00015h		;9f87   ; se tira el de abajo
	lddr		;9f8a
	ld (0faa6h),de		;9f8c   ; la pila de sonidos
	ld hl,0fac0h		;9f90
	dec (hl)			;9f93
sonido_empieza_guarda:
	ld a,(0fa73h)		;9f94   ; las marcas
	bit 7,a		;9f97   ; un efecto?
	jr nz,sonido_guarda_efecto		;9f99
	bit 6,a		;9f9b   ; de repetir?
	ret z			;9f9d
sonido_guarda:		; El que suena (0xFA76-0xFA78) a la pila de sonidos
	ld hl,0fa78h		;9f9e
	ld de,(0faa6h)		;9fa1   ; la pila de sonidos
	ld bc,00003h		;9fa5
	lddr		;9fa8
	ld (0faa6h),de		;9faa   ; la pila de sonidos
	ld hl,0fac0h		;9fae   ; uno mas
	inc (hl)			;9fb1
sonido_empieza_ya:
	jp sonido_arranca		;9fb2
sonido_guarda_efecto:
	ld a,(0fa71h)		;9fb5   ; el tempo
	and a			;9fb8
	ret nz			;9fb9
	jr sonido_guarda		;9fba
sonido_cuadro:		; Sin sonido pedido: el que suena sigue (0x9FED); si no suena ninguno, el de la pila (0xA0B3) o el de 0xFAA5; si no, el sonido acaba (0x9ACC)
	ld a,(0fa78h)		;9fbc   ; el sonido que suena
	and a			;9fbf
	jr z,sonido_pila_saca		;9fc0
	jr sonido_sigue		;9fc2
sonido_pila_saca:
	call sonido_pila_sigue		;9fc4
	ret c			;9fc7
	call sonido_delante_sigue		;9fc8
	ret c			;9fcb
	jp sonido_tecla_para		;9fcc
sonido_delante:		; El de delante (0xFA79) se guarda en 0xFAA3-0xFAA5 y empieza
	ld hl,0fa78h		;9fcf
	ld de,0faa5h		;9fd2
	ld bc,00003h		;9fd5
	lddr		;9fd8
	xor a			;9fda
	ld (0fa79h),a		;9fdb   ; el de delante
	jr sonido_empieza_ya		;9fde
sonido_notas:		; IX = el registro del sonido (HL); HL = sus notas (+0x0A) a 0xFA9F
	push hl			;9fe0
	pop ix		;9fe1
	ld l,(ix+00ah)		;9fe3
	ld h,(ix+00bh)		;9fe6
	ld (0fa9fh),hl		;9fe9   ; las notas
	ret			;9fec
sonido_sigue:		; El sonido sigue: la musica, nota a nota (0xA003); un efecto (bit 7), hasta que acaba su tiempo (0xA047)
	ld a,(0fa73h)		;9fed   ; las marcas del sonido
	bit 7,a		;9ff0
	jr nz,sonido_efecto_sigue		;9ff2
	call nota_siguiente_suena		;9ff4
	ret			;9ff7
sonido_efecto_sigue:
	ld a,(0fa71h)		;9ff8   ; el tempo
	and a			;9ffb
	ret z			;9ffc
	call nota_cuenta		;9ffd
	ret c			;a000
	jr sonido_calla		;a001
nota_siguiente_suena:		; Cuando acaba la nota (0xA047): la siguiente (0xFA76): 0, el final (con REPEAT, desde el principio; si no, callado); 1, silencio; las demas, suena (0xA05A)
	call nota_cuenta		;a003
	ret c			;a006
	ld hl,(0fa76h)		;a007   ; la nota que suena
	inc hl			;a00a   ; la siguiente
nota_suena_va:
	ld (0fa76h),hl		;a00b   ; la nota que suena
	ld a,(hl)			;a00e   ; la nota
	cp 001h		;a00f   ; 0: el final?
	jr c,nota_final		;a011
	jr z,nota_silencio		;a013   ; 1: silencio
	jr nota_suena		;a015
nota_final:
	ld a,(0fa73h)		;a017   ; las marcas
	bit 6,a		;a01a   ; REPEAT?
	jr z,sonido_calla		;a01c
	ld hl,(0fa74h)		;a01e   ; desde el principio
	ld a,(0fa71h)		;a021   ; el tempo
	ld (0fa72h),a		;a024   ; la cuenta de la nota
	jr nota_suena_va		;a027
nota_silencio:
	jr psg_calla		;a029
sonido_calla:		; Nada sonando (0xFA78, 0xFA79) y el PSG callado
	xor a			;a02b
	ld (0fa78h),a		;a02c   ; el sonido que suena
	ld (0fa79h),a		;a02f   ; el de delante
psg_calla:		; Los volumenes del PSG (registros 8-10) a 0; 0xFA7A a 0
	xor a			;a032
	ld (0fa7ah),a		;a033   ; el volumen puesto
	ld b,003h		;a036
	ld a,007h		;a038
psg_calla_uno:
	push bc			;a03a
	inc a			;a03b
	push af			;a03c
	ld e,000h		;a03d
	call 00093h		;a03f   ; WRTPSG
	pop af			;a042
	pop bc			;a043
	djnz psg_calla_uno		;a044
	ret			;a046
nota_cuenta:		; La cuenta de la nota (0xFA72): si no ha acabado, uno menos y C; si si, otra vez el tempo (0xFA71)
	ld a,(0fa72h)		;a047   ; la cuenta de la nota
	and a			;a04a
	jr nz,nota_cuenta_menos		;a04b
	ld a,(0fa71h)		;a04d   ; el tempo
	ld (0fa72h),a		;a050   ; la cuenta de la nota
	ret			;a053
nota_cuenta_menos:
	dec a			;a054
	ld (0fa72h),a		;a055   ; la cuenta de la nota
	scf			;a058
	ret			;a059
nota_suena:		; La nota A en el canal A (0xA187: los registros 0 y 1) y, la primera vez, el volumen 15 (registro 8); con CHORD (bit 4 de las marcas), dos notas mas por debajo (las de 3 y 2 puestos antes en la tabla de 0xA2D3) en los canales B y C (registros 2-5) con volumen 15
	ld d,001h		;a05a
	call nota_psg		;a05c
	ld c,a			;a05f
	ld a,(0fa7ah)		;a060   ; el volumen puesto
	and a			;a063
	ld a,c			;a064
	push af			;a065
	jr nz,nota_suena_chord		;a066
	ld e,00fh		;a068
	ld a,008h		;a06a
	call 00093h		;a06c   ; WRTPSG: el volumen
nota_suena_chord:
	pop de			;a06f
	ld a,(0fa73h)		;a070   ; las marcas del sonido
	bit 4,a		;a073   ; CHORD?
	jr z,volumen_puesto		;a075
	ld a,d			;a077
	ld hl,0a2d3h		;a078   ; las notas
	cpir		;a07b
	ld de,00003h		;a07d   ; 3 antes
	and a			;a080
	sbc hl,de		;a081
	ld a,(hl)			;a083
	ld d,003h		;a084   ; al canal B
	push hl			;a086
	call nota_psg		;a087
	pop hl			;a08a
	ld de,00002h		;a08b   ; 2 antes
	and a			;a08e
	sbc hl,de		;a08f
	ld a,(hl)			;a091
	ld d,005h		;a092   ; al canal C
	call nota_psg		;a094
	ld e,00fh		;a097
	call volumen_puesto		;a099
	ret nz			;a09c
	ld a,009h		;a09d   ; volumen del canal B
	push de			;a09f
	call 00093h		;a0a0   ; WRTPSG
	pop de			;a0a3
	ld a,00ah		;a0a4
	jp 00093h		;a0a6   ; WRTPSG: el del C
volumen_puesto:		; 0xFA7A = 0xFF la primera vez (NZ si ya estaba)
	ld a,(0fa7ah)		;a0a9   ; el volumen puesto
	and a			;a0ac
	ret nz			;a0ad
	cpl			;a0ae
	ld (0fa7ah),a		;a0af   ; el volumen puesto
	ret			;a0b2
sonido_pila_sigue:		; Saca de la pila el ultimo guardado y lo hace seguir donde estaba (0xA0D0)
	ld a,(0fac0h)		;a0b3   ; cuantos en la pila
	and a			;a0b6
	ret z			;a0b7
	dec a			;a0b8
	ld (0fac0h),a		;a0b9   ; cuantos en la pila
	ld hl,(0faa6h)		;a0bc   ; la pila de sonidos
	inc hl			;a0bf
	inc hl			;a0c0
	inc hl			;a0c1
	ld (0faa6h),hl		;a0c2   ; la pila de sonidos
	jr sonido_sigue_desde		;a0c5
sonido_delante_sigue:
	ld hl,0faa5h		;a0c7
	ld a,(hl)			;a0ca
	and a			;a0cb
	ret z			;a0cc
	ld (0fa79h),a		;a0cd   ; el de delante
sonido_sigue_desde:
	ld a,(hl)			;a0d0   ; el sonido
	ld c,000h		;a0d1
	ld (hl),c			;a0d3   ; se borra
	dec hl			;a0d4
	ld d,(hl)			;a0d5   ; donde iba
	dec hl			;a0d6
	ld e,(hl)			;a0d7
	ld (0fa9bh),a		;a0d8   ; el sonido pedido
	ld (0faa1h),de		;a0db   ; la nota
	call sonido_busca		;a0df   ; esta?
	ret nc			;a0e2
	call sonido_notas		;a0e3   ; sus notas
	call sonido_arranca		;a0e6   ; sigue
	scf			;a0e9
	ret			;a0ea
sonido_busca:		; C si el sonido A esta en la lista (0xA1F7) y tiene notas (+0x0B); IX su registro
	call sonido_busca_lista		;a0eb
	ret nc			;a0ee   ; no esta
	push hl			;a0ef
	pop ix		;a0f0   ; IX = su registro
	ld a,(ix+00bh)		;a0f2   ; sus notas
	and a			;a0f5   ; ninguna?
	ret z			;a0f6
	scf			;a0f7   ; C: bien
	ret			;a0f8
sonido_arranca:		; Empieza el sonido 0xFA9B (0xFA78): el tempo (+0, a 0xFA71 y 0xFA72) y las marcas (+1, 0xFA73); una musica: CHORD (0xFA9E), el registro 6 con el bit 5 (0xA142), el principio y la nota (0xFA74, 0xFA76) y el mezclador (0xA14E); un efecto (bit 7): los 13 registros del PSG seguidos (0xA17D) y el 13
	ld a,(0fa9bh)		;a0f9   ; el sonido pedido
	ld (0fa78h),a		;a0fc   ; el que suena
	ld hl,(0fa9fh)		;a0ff   ; las notas
	ld a,(hl)			;a102   ; el tempo
	ld (0fa71h),a		;a103   ; el tempo
	ld (0fa72h),a		;a106   ; la cuenta de la nota
	inc hl			;a109
	ld a,(hl)			;a10a   ; las marcas
	ld (0fa73h),a		;a10b   ; las marcas del sonido
	bit 7,a		;a10e   ; un efecto?
	jr nz,sonido_arranca_efecto		;a110
	ld c,a			;a112
	bit 4,a		;a113   ; CHORD?
	ld a,000h		;a115
	ld (0fa9eh),a		;a117   ; CHORD
	ld (0fa7ah),a		;a11a   ; el volumen puesto
	jr z,sonido_arranca_notas		;a11d
	cpl			;a11f
	ld (0fa9eh),a		;a120   ; CHORD
sonido_arranca_notas:
	inc hl			;a123
	call ruido_pon		;a124
	inc hl			;a127
	ld (0fa74h),hl		;a128   ; el principio de las notas
	ld hl,(0faa1h)		;a12b
	ld (0fa76h),hl		;a12e   ; la nota que suena
	jr mezclador_pon		;a131
sonido_arranca_efecto:
	push hl			;a133
	ld b,00dh		;a134   ; 13 registros
	ld c,0ffh		;a136
	call psg_seguidos		;a138
	pop hl			;a13b
	ld e,(hl)			;a13c
	ld a,00dh		;a13d   ; la envolvente
	jp 00093h		;a13f   ; WRTPSG
ruido_pon:		; Con el bit 5 de las marcas, el registro 6 (el ruido) = E
	ld e,(hl)			;a142
	bit 5,c		;a143
	ret z			;a145
	ld a,006h		;a146
	push hl			;a148
	call 00093h		;a149   ; WRTPSG
	pop hl			;a14c
	ret			;a14d
mezclador_pon:		; El mezclador (registro 7): el tono A; con CHORD, tambien B y C; con el bit 5, el ruido; y la primera nota (0xA05A)
	ld a,(hl)			;a14e   ; la primera nota
	cp 001h		;a14f
	push af			;a151
	jr c,sonido_vacio		;a152
	ld a,(0fa73h)		;a154   ; las marcas del sonido
	ld c,a			;a157
	ld a,0beh		;a158   ; solo el tono A
	bit 4,c		;a15a   ; CHORD?
	jr z,mezclador_ruido		;a15c
	and 0b9h		;a15e   ; mas B y C
mezclador_ruido:
	bit 5,c		;a160
	jr z,mezclador_va		;a162
	and 0b7h		;a164
mezclador_va:
	cp 0b0h		;a166
	jr nz,mezclador_escribe		;a168
	ld a,080h		;a16a
mezclador_escribe:
	ld e,a			;a16c
	ld a,007h		;a16d
	call 00093h		;a16f   ; WRTPSG
	pop af			;a172
	ret z			;a173
	jp nota_suena		;a174
sonido_vacio:
	pop af			;a177
	xor a			;a178
	ld (0fa78h),a		;a179   ; el sonido que suena
	ret			;a17c
psg_seguidos:		; B registros del PSG seguidos (desde C + 1) con los bytes de HL + 1...
	inc hl			;a17d
	ld e,(hl)			;a17e
	inc c			;a17f
	ld a,c			;a180
	call 00093h		;a181   ; WRTPSG
	djnz psg_seguidos		;a184
	ret			;a186
nota_psg:		; La nota A en el canal de los registros D - 1 y D: los 2 bits de abajo al registro D (el periodo alto), los otros 6 al D - 1 (el bajo)
	push af			;a187
	and 003h		;a188
	ld e,a			;a18a
	ld a,d			;a18b
	push de			;a18c
	call 00093h		;a18d   ; WRTPSG
	pop de			;a190
	pop af			;a191
	push af			;a192
	and 0fch		;a193
	ld e,a			;a195
	ld a,d			;a196
	dec a			;a197
	call 00093h		;a198   ; WRTPSG
	pop af			;a19b
	ret			;a19c
sonido_pila_quita:		; Quita de la pila de sonidos el C: los de encima bajan; uno menos
	ld a,(0fac0h)		;a19d   ; cuantos en la pila
	and a			;a1a0
	ret z			;a1a1
	ld b,a			;a1a2
	ld a,c			;a1a3
	ld hl,0fabfh		;a1a4
	ld de,00003h		;a1a7
	and a			;a1aa
sonido_pila_quita_busca:
	cp (hl)			;a1ab
	sbc hl,de		;a1ac
	jr z,sonido_pila_quita_va		;a1ae
	djnz sonido_pila_quita_busca		;a1b0
sonido_pila_quita_fin:
	ld hl,(0faa6h)		;a1b2   ; la pila de sonidos
	ld de,00003h		;a1b5
	add hl,de			;a1b8
	ld (0faa6h),hl		;a1b9   ; la pila de sonidos
	ld hl,0fac0h		;a1bc
	dec (hl)			;a1bf
	ret			;a1c0
sonido_pila_quita_va:
	dec b			;a1c1
	jr z,sonido_pila_quita_fin		;a1c2
	xor a			;a1c4
	ld c,003h		;a1c5
sonido_pila_quita_x3:
	add a,c			;a1c7   ; x 3
	djnz sonido_pila_quita_x3		;a1c8
	ld e,l			;a1ca
	ld d,h			;a1cb
	add hl,bc			;a1cc
	ex de,hl			;a1cd
	ld c,a			;a1ce
	lddr		;a1cf   ; los de encima bajan
	jr sonido_pila_quita_fin		;a1d1
sonido_cola_mira:		; Los sonidos de la cola (0xFA7B, hasta 32): cada uno, si suena, se para (0xA1E7)
	ld b,020h		;a1d3
	ld hl,0fa7bh		;a1d5
sonido_cola_uno:
	ld a,(hl)			;a1d8   ; el sonido
	and a			;a1d9
	ret z			;a1da   ; el final
	push hl			;a1db
	push bc			;a1dc
	call sonido_cola_para		;a1dd   ; si suena, se para
	pop bc			;a1e0
	pop hl			;a1e1
	inc hl			;a1e2   ; el siguiente
	djnz sonido_cola_uno		;a1e3
	and a			;a1e5   ; NC
	ret			;a1e6
sonido_cola_para:
	ld c,a			;a1e7
	ld a,(0fa78h)		;a1e8   ; el sonido que suena
	ret z			;a1eb
	cp c			;a1ec
	jr nz,sonido_pila_quita		;a1ed
	xor a			;a1ef
	ld (0fa78h),a		;a1f0   ; el sonido que suena
	call psg_calla		;a1f3
	ret			;a1f6
sonido_busca_lista:		; Busca el sonido A en la lista (registros de 13 desde 0xF423): C si esta (HL su registro, B su posicion)
	ld c,a			;a1f7
	ld hl,0f423h		;a1f8
	ld de,0000dh		;a1fb
	ld b,001h		;a1fe
sonido_busca_lista_uno:
	ld a,(hl)			;a200   ; el numero
	and a			;a201
	ret z			;a202   ; el final: no esta
	cp c			;a203   ; este?
	jr z,sonido_busca_lista_si		;a204
	add hl,de			;a206   ; el siguiente
	inc b			;a207   ; su posicion
	jr sonido_busca_lista_uno		;a208
sonido_busca_lista_si:
	scf			;a20a
	ret			;a20b
sonido_interrupcion:		; El sonido de cada cuadro (desde la interrupcion): el pedido (0xFA9B) a 0xFA9D; si suena algo, la cola (0xA1D3), lo que sobra a 0 y el cuadro (0xA239 al acabar)
	ld a,(0fa9bh)		;a20c   ; el sonido pedido
	and a			;a20f   ; pedido?
	jr z,sonido_interrupcion_va		;a210
	ld (0fa9dh),a		;a212   ; sonando
sonido_interrupcion_va:
	ld a,(0fa9dh)		;a215   ; sonando
	and a			;a218
	ret z			;a219
	call sonido_cola_mira		;a21a
	call sonido_cola_limpia		;a21d
	call sonido_empieza		;a220
	jr sonido_pedido_cero		;a223
sonido_cola_limpia:		; Lo que queda de la cola (32 - B) a 0 y la cola vacia (0xFA2D = 0xFA7B)
	ld a,020h		;a225   ; 32...
	sub b			;a227   ; ...menos los usados
	ret z			;a228
	ld b,a			;a229
	ld hl,0fa7ah		;a22a   ; la cola
	xor a			;a22d
sonido_cola_limpia_uno:
	inc hl			;a22e
	ld (hl),a			;a22f
	djnz sonido_cola_limpia_uno		;a230
sonido_cola_vacia:
	ld hl,0fa7bh		;a232
	ld (0fa2dh),hl		;a235   ; la cola de sonidos
	ret			;a238
sonido_pedido_cero:		; 0xFA9B y 0xFA9C a 0
	xor a			;a239
	ld (0fa9bh),a		;a23a   ; el sonido pedido
	ld (0fa9ch),a		;a23d   ; delante?
	ret			;a240
ram_devuelve:		; Devuelve BC bytes al mapa (desde 0xA242 "xor a": pide; si no caben, "no hay memoria") y mueve las notas de los sonidos que esten por debajo
	or 0afh		;a241   ; NZ: devolver; desde 0xA242 "xor a": pedir
	jr nz,ram_mueve_va		;a243
	ld hl,(0f7efh)		;a245   ; el mapa...
	sbc hl,bc		;a248
	ld de,(0f7e7h)		;a24a   ; ...contra el final de lo usado
	sbc hl,de		;a24e
	jp c,sin_memoria		;a250   ; no cabe
ram_mueve_va:
	ex af,af'			;a253
	push bc			;a254
	call notas_tamano		;a255
	ld a,b			;a258
	or c			;a259
	pop bc			;a25a
	ld a,(0f422h)		;a25b   ; cuantos sonidos hay
	jr z,ram_mueve_mapa		;a25e   ; sin sonidos
	ld hl,0f42fh		;a260   ; los registros de los sonidos (+0x0C)
	ld e,c			;a263
	ld d,b			;a264
	ld b,a			;a265
	ex af,af'			;a266
ram_mueve_sonido:
	push bc			;a267
	ld c,e			;a268
	ld b,d			;a269
	bit 5,(hl)		;a26a   ; con notas en la RAM?
	jr z,ram_mueve_sig		;a26c
	dec hl			;a26e   ; su puntero
	ld d,(hl)			;a26f
	dec hl			;a270
	ld e,(hl)			;a271
	ex de,hl			;a272
	and a			;a273
	jr z,ram_mueve_resta		;a274
	add hl,bc			;a276
ram_mueve_pon:
	ex de,hl			;a277
	ld (hl),e			;a278
	inc hl			;a279
	ld (hl),d			;a27a
	inc hl			;a27b
ram_mueve_sig:
	ld de,0000dh		;a27c   ; el siguiente
	add hl,de			;a27f
	ld e,c			;a280
	ld d,b			;a281
	pop bc			;a282
	djnz ram_mueve_sonido		;a283
	and a			;a285
	jr z,ram_mueve_sube		;a286
	ld hl,(0f7edh)		;a288   ; el principio del mapa
	dec hl			;a28b
	push hl			;a28c
	add hl,de			;a28d
	ld c,e			;a28e
	ld b,d			;a28f
	pop de			;a290
	ex de,hl			;a291
	push bc			;a292
	call notas_tamano		;a293
	lddr		;a296   ; lo de arriba baja
ram_mueve_fin:
	pop bc			;a298
	ex af,af'			;a299
ram_mueve_mapa:
	ex af,af'			;a29a
	ld hl,(0f7efh)		;a29b   ; el principio de las notas
	and a			;a29e
	jr z,ram_mueve_mapa_resta		;a29f
	add hl,bc			;a2a1
ram_mueve_pon_mapa:
	ld (0f7efh),hl		;a2a2   ; el principio de las notas
	ret			;a2a5
ram_mueve_resta:
	sbc hl,bc		;a2a6
	jr ram_mueve_pon		;a2a8
ram_mueve_sube:
	ld hl,(0f7efh)		;a2aa   ; el principio de las notas
	push hl			;a2ad
	sbc hl,de		;a2ae
	ld c,e			;a2b0
	ld b,d			;a2b1
	pop de			;a2b2
	ex de,hl			;a2b3
	push bc			;a2b4
	call notas_tamano		;a2b5
	ldir		;a2b8   ; lo de abajo sube
	jr ram_mueve_fin		;a2ba
ram_mueve_mapa_resta:
	sbc hl,bc		;a2bc
	jr ram_mueve_pon_mapa		;a2be
notas_tamano:		; BC = lo que ocupan las notas de los sonidos (de 0xF7EF a 0xF7ED)
	push hl			;a2c0
	ld hl,(0f7edh)		;a2c1   ; el principio del mapa
	ld bc,(0f7efh)		;a2c4   ; el principio de las notas
	and a			;a2c8
	sbc hl,bc		;a2c9
	ld c,l			;a2cb
	ld b,h			;a2cc
	pop hl			;a2cd
	ret			;a2ce

; ----------------------------------------------------------------------
; DATOS graficos_datos: Los datos: las notas del pentagrama (0xA2D3, 0x2E:
;   periodos del PSG, los 2 bits de abajo el alto), las casillas de las
;   cabezas (0xA301), los tempos (0xA314), las 4 musicas de muestra (0xA325:
;   punteros y notas; la ultima, 0xA399, la de la presentacion), los efectos
;   de muestra (0xA3BD), los textos del pentagrama (0xA509), los 20 dibujos de
;   muestra de los personajes (0xA541), las letras del menu (0xA7C1) y los
;   dibujos de las casillas (0xA881)
;   0xa2cf..0xa959  (1674 bytes)
DATA_graficos_datos:
	defb 060h,06ch,070h,080h,08ch,0a0h,0a8h,0bch,0d4h,0e0h,0fch,01dh,041h,055h,07dh,0adh	; a2cf  `lp.........AU}.
	defb 0c5h,0fdh,03eh,082h,0aah,0feh,05bh,08fh,0fbh,05ch,064h,06ch,078h,084h,094h,0a0h	; a2df  ..>...[..\dlx...
	defb 0b4h,0c8h,0d4h,0f0h,00dh,02dh,041h,069h,095h,0adh,0e1h,01eh,05eh,082h,0d2h,02bh	; a2ef  .....-Ai....^..+
	defb 05bh,0c3h,016h,015h,012h,011h,010h,014h,012h,011h,010h,014h,017h,011h,016h,015h	; a2ff  [...............
	defb 012h,011h,010h,014h,012h,011h,010h,029h,021h,019h,013h,00dh,009h,005h,003h,001h	; a30f  .......)!.......
	defb 002h,005h,009h,00ch,010h,013h,02dh,0a3h,051h,0a3h,075h,0a3h,099h,0a3h,00dh,00fh	; a31f  ......-.Q.u.....
	defb 000h,0d4h,0d4h,0d4h,0d4h,0e0h,0e0h,001h,055h,0fch,0fch,01dh,01dh,041h,041h,07dh	; a32f  ........U....AA}
	defb 07dh,0adh,0adh,0c5h,0adh,055h,055h,07dh,055h,07dh,07dh,07dh,07dh,0adh,0adh,0adh	; a33f  }....UU}U}}}}...
	defb 001h,000h,009h,05fh,000h,0adh,0adh,0adh,0adh,07dh,041h,055h,07dh,01dh,01dh,01dh	; a34f  ..._.....}AU}...
	defb 001h,01dh,0fch,055h,041h,07dh,07dh,07dh,07dh,07dh,041h,055h,07dh,0adh,0d4h,0e0h	; a35f  ...UA}}}}}AU}...
	defb 0fch,01dh,041h,055h,07dh,000h,005h,00fh,000h,0d4h,001h,0d4h,001h,01dh,001h,01dh	; a36f  ..AU}...........
	defb 001h,0d4h,001h,0d4h,001h,0d4h,001h,0d4h,001h,0a8h,0a8h,001h,0d4h,0a8h,0a8h,001h	; a37f  ................
	defb 0d4h,01dh,001h,01dh,001h,0d4h,0d4h,0d4h,0d4h,000h,009h,05fh,000h,055h,0adh,055h	; a38f  ..........._.U.U
	defb 0adh,041h,0adh,041h,0adh,01dh,0adh,01dh,0adh,041h,01dh,041h,01dh,055h,0adh,055h	; a39f  .A.A.....A.A.U.U
	defb 0adh,041h,0adh,041h,0adh,01dh,0adh,01dh,0adh,01dh,041h,055h,07dh,000h,0c7h,0a3h	; a3af  .A.A......AU}...
	defb 0d1h,0a3h,0dbh,0a3h,0e5h,0a3h,0efh,0a3h,0f9h,0a3h,0ffh,0a3h,009h,0a4h,014h,0a4h	; a3bf  ................
	defb 08eh,0a4h,028h,0a4h,037h,0a4h,046h,0a4h,055h,0a4h,01eh,0b4h,062h,0a4h,071h,0a4h	; a3cf  ..(.7.F.U...b.q.
	defb 080h,0a4h,09ah,0b3h,01bh,0b5h,097h,0a4h,0a6h,0a4h,0b5h,0a4h,0c9h,0a4h,096h,0b2h	; a3df  ................
	defb 0d2h,0a4h,0deh,0a4h,0eeh,0a4h,0f6h,0a4h,038h,0b3h,003h,04fh,000h,041h,0d4h,000h	; a3ef  ........8..O.A..
	defb 001h,04fh,000h,0fbh,001h,05bh,0fbh,05bh,001h,000h,001h,04fh,000h,0a8h,0bch,0d4h	; a3ff  .O...[.[...O....
	defb 0e0h,0d4h,001h,001h,000h,001h,01fh,000h,08ch,094h,0a8h,0bch,0d4h,0e0h,0f0h,01dh	; a40f  ................
	defb 02dh,055h,069h,0adh,0c5h,0fdh,03eh,05eh,000h,000h,08ch,0eah,002h,0deh,000h,0c5h	; a41f  -Ui...>^........
	defb 001h,01dh,080h,010h,010h,010h,05ch,002h,000h,080h,007h,006h,00eh,003h,0ddh,008h	; a42f  ......\.........
	defb 004h,080h,00fh,002h,00ch,091h,00eh,000h,08dh,0a5h,008h,052h,000h,01eh,007h,01fh	; a43f  ...........R....
	defb 0b8h,010h,000h,000h,088h,00fh,001h,06fh,019h,0fbh,0fbh,001h,0fbh,0fbh,001h,0fbh	; a44f  .......o........
	defb 0fbh,001h,000h,01ah,080h,000h,00eh,0ffh,00fh,070h,005h,00ah,0a0h,010h,010h,010h	; a45f  .........p......
	defb 061h,00dh,03ah,089h,000h,000h,000h,000h,000h,000h,00ah,0b7h,010h,000h,000h,004h	; a46f  a.:.............
	defb 022h,005h,02fh,01fh,03eh,001h,082h,001h,0aah,001h,0feh,001h,05bh,001h,000h,001h	; a47f  "./.>.......[...
	defb 00fh,000h,0adh,001h,0adh,001h,0adh,000h,000h,08ah,0c8h,000h,05dh,000h,021h,000h	; a48f  ............].!.
	defb 09fh,0b8h,010h,010h,010h,059h,002h,000h,08ch,0b0h,001h,017h,000h,024h,000h,01fh	; a49f  .....Y.......$..
	defb 0b8h,010h,010h,010h,020h,017h,001h,04fh,000h,0fbh,0fbh,001h,001h,05bh,05bh,001h	; a4af  .... ..O.....[[.
	defb 001h,0fbh,0fbh,001h,001h,05bh,05bh,001h,001h,000h,001h,00fh,000h,0a8h,08ch,0a0h	; a4bf  .....[[.........
	defb 0a8h,0a0h,000h,001h,04fh,000h,08ch,001h,08ch,001h,08ch,001h,08ch,001h,000h,004h	; a4cf  ....O...........
	defb 04fh,000h,08ch,084h,08ch,084h,08ch,084h,08ch,084h,08ch,001h,001h,001h,000h,001h	; a4df  O...............
	defb 04fh,000h,0fbh,001h,05bh,001h,000h,001h,04fh,000h,08ch,0a0h,0a8h,0a0h,0a8h,0bch	; a4ef  O...[...O.......
	defb 0a8h,0bch,0d4h,0e0h,0d4h,0bch,0d4h,0bch,0a8h,000h,020h,020h,020h,020h,02ah,020h	; a4ff  ..........    * 
	defb 0ech,0f2h,0fdh,020h,02ah,000h,054h,045h,04dh,050h,04fh,020h,03dh,000h,052h,045h	; a50f  ... *.TEMPO =.RE
	defb 050h,045h,041h,054h,03dh,000h,043h,048h,04fh,052h,044h,020h,03dh,000h,020h,020h	; a51f  PEAT=.CHORD =.  
	defb 020h,020h,020h,09ch,08eh,093h,09eh,0e2h,0f2h,000h,04fh,04eh,020h,000h,04fh,046h	; a52f     .......ON .OF
	defb 046h,000h,000h,001h,001h,001h,001h,000h,000h,001h,003h,003h,003h,001h,001h,001h	; a53f  F...............
	defb 003h,003h,0e0h,0f0h,0d0h,0f0h,0f0h,0c0h,0e0h,0e0h,0f0h,0f8h,0f8h,0e0h,0e0h,0e0h	; a54f  ................
	defb 0e0h,070h,001h,003h,003h,003h,001h,000h,00fh,01fh,019h,019h,001h,001h,00fh,00fh	; a55f  .p..............
	defb 00ch,000h,0c0h,060h,0e0h,0c0h,0e2h,0c6h,0f6h,0feh,0fch,0e0h,0e0h,0f8h,0fch,08ch	; a56f  ...`............
	defb 00eh,000h,001h,003h,003h,003h,006h,004h,007h,004h,007h,08eh,09eh,0beh,0feh,0eeh	; a57f  ................
	defb 0c2h,086h,000h,080h,080h,080h,0c0h,040h,0c0h,040h,0c0h,0e2h,0f2h,0fah,0feh,0eeh	; a58f  .......@.@......
	defb 086h,0c2h,000h,000h,000h,000h,001h,007h,00fh,01fh,01fh,03fh,03fh,03fh,01fh,01fh	; a59f  ...........???..
	defb 00fh,003h,090h,000h,040h,090h,000h,0c0h,0e0h,0f0h,0f0h,0f8h,0d8h,0d8h,0b0h,0f0h	; a5af  ....@...........
	defb 0e0h,080h,043h,064h,004h,019h,022h,021h,026h,035h,045h,048h,02dh,011h,010h,02eh	; a5bf  ..Cd.."!&5EH-...
	defb 040h,000h,0c0h,02ch,02ch,0c0h,020h,024h,0a0h,008h,084h,0a4h,024h,068h,080h,010h	; a5cf  @..,,. $....$h..
	defb 002h,002h,007h,01fh,03fh,07fh,081h,0b9h,0abh,083h,046h,03dh,01fh,00fh,00ah,00ah	; a5df  ....?.....F=....
	defb 00ah,000h,0c0h,0f0h,0f8h,0fch,002h,03ah,0aah,082h,0c4h,078h,0f0h,0e0h,0a0h,0a0h	; a5ef  .......:...x....
	defb 0a0h,000h,004h,004h,002h,003h,007h,0c4h,0e7h,03bh,00fh,063h,023h,023h,033h,01fh	; a5ff  .........;.c##3.
	defb 00fh,004h,010h,030h,050h,0d0h,0f3h,093h,0e6h,0dch,0f8h,0e0h,0c0h,0c0h,0e0h,020h	; a60f  ...0P.......... 
	defb 020h,030h,050h,098h,0c8h,098h,050h,020h,016h,00ah,03fh,07fh,07eh,03ch,058h,0afh	; a61f   0P...P ..?.~<X.
	defb 054h,054h,00ah,019h,013h,019h,00ah,004h,068h,050h,0fch,0feh,07eh,03ch,01ah,0f5h	; a62f  TT......hP..~<..
	defb 02ah,02ah,000h,000h,000h,000h,000h,000h,00fh,01ah,037h,0aah,0bdh,0aah,0f7h,07fh	; a63f  **........7.....
	defb 038h,03ch,000h,000h,000h,000h,00ch,01ah,09dh,0d9h,07fh,0b8h,0feh,0bch,078h,0f8h	; a64f  8<............x.
	defb 070h,078h,080h,060h,070h,03ch,01ch,00eh,00fh,087h,0e3h,0ffh,077h,001h,001h,003h	; a65f  px.`p<......w...
	defb 000h,000h,000h,002h,006h,00ch,008h,018h,0b8h,0feh,0fah,0ffh,0fch,0f8h,040h,0f0h	; a66f  ..............@.
	defb 0c0h,000h,030h,048h,007h,007h,00fh,07fh,043h,063h,035h,039h,01fh,00fh,006h,00ch	; a67f  ..0H....Cc59....
	defb 018h,030h,00ch,012h,0e0h,0e0h,0f0h,0feh,0c2h,0c6h,0ach,09ch,0f8h,0f0h,060h,030h	; a68f  .0............`0
	defb 018h,00ch,000h,000h,000h,000h,000h,001h,007h,01fh,00fh,00ah,00ah,03fh,07fh,0ffh	; a69f  .............?..
	defb 073h,021h,000h,000h,000h,000h,000h,000h,0c0h,0f0h,0e0h,0a0h,0a0h,0f8h,0fch,0feh	; a6af  s!..............
	defb 09ch,008h,07fh,000h,000h,000h,002h,004h,009h,012h,03eh,05eh,087h,003h,001h,000h	; a6bf  ..........>^....
	defb 000h,003h,000h,0ffh,080h,080h,0b0h,0cch,002h,002h,001h,001h,001h,0c2h,0feh,0fch	; a6cf  ................
	defb 031h,0feh,000h,000h,000h,001h,081h,0c1h,0e2h,0ffh,07fh,0ffh,003h,001h,001h,000h	; a6df  1...............
	defb 000h,000h,040h,0e0h,0e0h,0e0h,0e0h,021h,001h,0f9h,0fbh,0fah,0e2h,0e2h,0e0h,0e0h	; a6ef  ..@....!........
	defb 0e0h,040h,000h,000h,000h,000h,000h,001h,003h,003h,003h,0dfh,0b5h,07fh,0bfh,0dfh	; a6ff  .@..............
	defb 00fh,003h,000h,0e0h,0e0h,0c0h,0c0h,0f0h,088h,088h,0f8h,0ffh,07fh,0ffh,0ffh,0feh	; a70f  ................
	defb 0f8h,0f0h,008h,005h,031h,007h,00ch,014h,024h,024h,07fh,07fh,07fh,0e7h,0dbh,0bdh	; a71f  ....1...$$......
	defb 0bdh,018h,010h,0a0h,080h,0d8h,040h,040h,020h,020h,0f8h,0fch,0feh,0c3h,099h,0bdh	; a72f  ......@@  ......
	defb 0bdh,018h,019h,005h,003h,001h,00fh,01fh,037h,037h,03fh,01dh,01dh,00fh,00fh,007h	; a73f  ........77?.....
	defb 003h,001h,098h,0a0h,0c0h,080h,0f0h,0f8h,06ch,06ch,0fch,0d8h,0d8h,0f0h,070h,060h	; a74f  ........ll....p`
	defb 0c0h,080h,000h,000h,001h,000h,000h,005h,00ah,015h,02ah,055h,02ah,055h,02ah,055h	; a75f  ..........*U*U*U
	defb 02ah,015h,000h,021h,092h,054h,038h,05eh,0a9h,054h,0a2h,052h,0a0h,050h,0a0h,040h	; a76f  *..!.T8^.T.R.P.@
	defb 080h,000h,03fh,07fh,0ffh,000h,0ffh,0ffh,09fh,06fh,06fh,09fh,0bfh,0bfh,0bfh,0ffh	; a77f  ..?......oo.....
	defb 0ffh,0ffh,0e0h,0d0h,0b0h,070h,070h,070h,070h,070h,070h,070h,070h,070h,070h,060h	; a78f  .....pppppppppp`
	defb 040h,000h,00ah,015h,02ah,01fh,00fh,007h,008h,010h,010h,020h,020h,020h,010h,010h	; a79f  @...*......   ..
	defb 00ch,003h,0a0h,050h,0a8h,0f0h,0e0h,0c0h,020h,010h,010h,008h,008h,008h,010h,010h	; a7af  ...P.... .......
	defb 060h,080h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,000h,010h,038h,054h,092h,010h	; a7bf  `...........8T..
	defb 010h,010h,010h,008h,004h,0feh,004h,008h,010h,000h,010h,010h,010h,092h,054h,038h	; a7cf  ..............T8
	defb 010h,000h,010h,020h,040h,0feh,040h,020h,010h,000h,000h,000h,000h,000h,000h,000h	; a7df  ... @.@ ........
	defb 000h,000h,0f8h,080h,0b8h,0a0h,0a0h,000h,000h,000h,000h,000h,000h,005h,005h,01dh	; a7ef  ................
	defb 001h,01fh,000h,000h,000h,0ffh,03ch,07ch,078h,0ffh,000h,01ch,03ch,0ffh,078h,070h	; a7ff  ......<|x...<.xp
	defb 000h,0ffh,03ch,07ch,078h,0ffh,000h,000h,000h,0ffh,078h,070h,000h,0ffh,000h,000h	; a80f  ..<|x.....xp....
	defb 000h,0ffh,000h,000h,000h,0ffh,000h,01ch,03ch,0ffh,000h,000h,000h,000h,000h,01ch	; a81f  ........<.......
	defb 03ch,0ffh,000h,000h,000h,01ch,03ch,07ch,078h,0ffh,01ch,03ch,07ch,078h,070h,000h	; a82f  <.....<|x..<|xp.
	defb 000h,0ffh,078h,070h,000h,000h,000h,000h,000h,0ffh,000h,000h,000h,0ffh,000h,000h	; a83f  ..xp............
	defb 000h,0ffh,000h,000h,000h,000h,000h,000h,000h,0ffh,013h,01eh,032h,0ffh,013h,01eh	; a84f  ............2...
	defb 032h,0ffh,013h,01eh,032h,012h,013h,01eh,032h,0ffh,00bh,00bh,00bh,0ffh,00bh,00bh	; a85f  2...2...2.......
	defb 00bh,0ffh,000h,000h,000h,0ffh,0e1h,0e2h,024h,0ffh,018h,020h,040h,0ffh,000h,000h	; a86f  ........$.. @...
	defb 000h,0ffh,0ffh,081h,081h,081h,081h,081h,0ffh,000h,0feh,080h,080h,080h,080h,080h	; a87f  ................
	defb 080h,000h,000h,001h,001h,001h,001h,001h,001h,07fh,0f8h,080h,0b8h,0a0h,0a0h,000h	; a88f  ................
	defb 000h,000h,000h,000h,000h,005h,005h,01dh,001h,01fh,010h,010h,010h,0feh,010h,010h	; a89f  ................
	defb 010h,000h,0ffh,081h,081h,081h,081h,081h,081h,0ffh,0ffh,081h,081h,081h,081h,081h	; a8af  ................
	defb 081h,0ffh,0ffh,0e7h,0c3h,081h,081h,0c3h,0e7h,0ffh,000h,010h,010h,06ch,010h,010h	; a8bf  .............l..
	defb 000h,000h,038h,038h,0feh,0eeh,0feh,038h,038h,000h,000h,000h,010h,038h,010h,000h	; a8cf  ..88...88....8..
	defb 000h,000h,000h,000h,038h,028h,038h,000h,000h,000h,0cch,0cch,033h,033h,0cch,0cch	; a8df  ....8(8.....33..
	defb 033h,033h,033h,033h,0cch,0cch,033h,033h,0cch,0cch,000h,000h,000h,000h,001h,001h	; a8ef  3333..33........
	defb 001h,001h,001h,001h,001h,003h,007h,00eh,01ch,018h,000h,040h,0e0h,0a0h,020h,020h	; a8ff  ...........@..  
	defb 020h,060h,060h,0c0h,0c0h,080h,080h,080h,080h,080h,030h,020h,020h,020h,020h,020h	; a90f   ``.......0     
	defb 010h,00fh,000h,000h,007h,007h,004h,003h,000h,000h,0f0h,0f8h,08ch,0c4h,044h,044h	; a91f  ..............DD
	defb 058h,0f0h,020h,020h,020h,020h,040h,080h,000h,000h,007h,00ch,01eh,01eh,00ch,000h	; a92f  X.    @.........
	defb 000h,000h,000h,000h,000h,000h,001h,002h,000h,000h,0e0h,033h,018h,018h,018h,01bh	; a93f  ...........3....
	defb 018h,010h,030h,020h,040h,080h,000h,000h,000h,000h	; a94f  ..0 @.....

; ======================================================================
; CODIGO 0xa959..0xb13c  (2019 bytes)
; ======================================================================


linea_hace:		; LINE (0x5813): el color A (0xFE74) y la linea de HL a DE (0xAA38; si es un punto, 0xAB04)
	and 00fh		;a959
	ld (0fe74h),a		;a95b   ; el color de dibujar
linea:		; La linea de HL a DE con el color de 0xFE74
	ld a,l			;a95e   ; la X
	cp e			;a95f   ; igual?
	jr nz,linea_va		;a960
	ld a,h			;a962   ; la Y
	cp d			;a963   ; igual?
	jp z,punto		;a964   ; un punto
linea_va:
	ld c,e			;a967
	ld b,d			;a968
	jp linea_bresenham		;a969
caja_hace:		; BOX: los cuatro lados (cuatro lineas) de HL a DE
	and 00fh		;a96c   ; el color
	ld (0fe74h),a		;a96e   ; el color de dibujar
	push de			;a971
	push hl			;a972
	push de			;a973
	ld d,h			;a974   ; arriba
	call linea		;a975
	pop de			;a978
	pop hl			;a979
	push hl			;a97a
	push de			;a97b
	ld l,e			;a97c   ; la izquierda
	call linea		;a97d
	pop hl			;a980
	pop de			;a981
	push de			;a982
	ld d,h			;a983   ; abajo
	call linea		;a984
	pop de			;a987
	pop hl			;a988
	ld l,e			;a989   ; la derecha
	jr linea		;a98a
caja_llena_hace:		; BOXFILL: lineas horizontales de la Y de HL a la de DE
	and 00fh		;a98c
	ld (0fe74h),a		;a98e   ; el color de dibujar
	ld a,h			;a991
	sub d			;a992
	ld c,0ffh		;a993
	jr nc,caja_llena_va		;a995
	ld c,001h		;a997
	neg		;a999
caja_llena_va:
	inc a			;a99b
	ld b,a			;a99c
caja_llena_linea:
	push de			;a99d   ; la linea
	push bc			;a99e
	push hl			;a99f
	ld d,h			;a9a0
	call linea		;a9a1   ; una linea
	pop hl			;a9a4
	pop bc			;a9a5
	ld a,h			;a9a6   ; la Y
	add a,c			;a9a7   ; la siguiente
	ld h,a			;a9a8
	pop de			;a9a9
	djnz caja_llena_linea		;a9aa   ; las demas
	ret			;a9ac
punto_byte_pon:		; Pone los puntos de la mascara de un byte (0xAF88: el byte de la VRAM y si el color cambia): segun 0xFE8B (todo o nada) y los colores de 0xFE8E/0xFE8F, con "or" o con "and" (0xAA05, 0xAA0A) y lo escribe (0xAF6A)
	ld c,a			;a9ad
	call color_compara		;a9ae
	jr c,punto_byte_mira		;a9b1
	push bc			;a9b3
	ld a,(0fe8bh)		;a9b4   ; el dibujo leido
	and a			;a9b7
	jr z,punto_byte_or2		;a9b8
	cp 0ffh		;a9ba
	jr z,punto_byte_and		;a9bc
	ld a,(0fe8eh)		;a9be   ; la tinta
	ld c,a			;a9c1
	ld a,(0fe8fh)		;a9c2   ; el fondo
	xor c			;a9c5
	jr z,punto_byte_and		;a9c6
	call bit_mira		;a9c8
	jr z,punto_byte_and2		;a9cb
	call color_tinta_pon		;a9cd
	pop bc			;a9d0
punto_byte_or:
	call mascara_unos		;a9d1
	ld c,a			;a9d4
	ld a,(0fe8bh)		;a9d5   ; el dibujo leido
	or c			;a9d8
punto_byte_escribe:
	jp dibujo_escribe		;a9d9
punto_byte_or2:
	call color_tinta_pon		;a9dc
	pop bc			;a9df
	call mascara_unos		;a9e0
	jr punto_byte_escribe		;a9e3
punto_byte_and:
	call color_fondo_pon		;a9e5
	pop bc			;a9e8
	call mascara_ceros		;a9e9
	jr punto_byte_escribe		;a9ec
punto_byte_and2:
	call color_fondo_pon		;a9ee
	pop bc			;a9f1
punto_byte_and3:
	call mascara_ceros		;a9f2
	ld c,a			;a9f5
	ld a,(0fe8bh)		;a9f6   ; el dibujo leido
	and c			;a9f9
	jr punto_byte_escribe		;a9fa
punto_byte_mira:
	and a			;a9fc   ; nada?
	ret z			;a9fd
	cp 002h		;a9fe   ; con unos?
	jr z,punto_byte_or		;aa00
	ret nc			;aa02   ; nada
	jr punto_byte_and3		;aa03
mascara_ceros:		; La mascara de los bits de C a B con ceros (0xAA1A)
	call mascara_orden		;aa05
	jr mascara_hace		;aa08
mascara_unos:		; La mascara con unos
	call mascara_orden		;aa0a
	jr $+16		;aa0d
mascara_orden:		; B el mayor y C el menor de C y 0xFE8D
	ld a,(0fe8dh)		;aa0f   ; el bit
	cp c			;aa12
	jr c,mascara_orden_cambia		;aa13
	ld b,a			;aa15
	ret			;aa16
mascara_orden_cambia:
	ld b,c			;aa17
	ld c,a			;aa18
	ret			;aa19
mascara_hace:
	ld a,0ffh		;aa1a   ; NZ; desde 0xAA1D "xor a": Z
	cp 0afh		;aa1c
	push af			;aa1e
	ld a,b			;aa1f   ; el bit de arriba...
	sub c			;aa20   ; ...menos el de abajo
	inc a			;aa21   ; + 1: cuantos
	ld b,a			;aa22
	pop af			;aa23
	jr z,mascara_hace_unos		;aa24   ; Z: con unos
mascara_hace_uno:
	and a			;aa26
	rla			;aa27
	djnz mascara_hace_uno		;aa28
mascara_gira:
	inc c			;aa2a
	dec c			;aa2b
	ret z			;aa2c
	ld b,c			;aa2d
mascara_gira_uno:
	rlca			;aa2e
	djnz mascara_gira_uno		;aa2f
	ret			;aa31
mascara_hace_unos:
	scf			;aa32
	rla			;aa33
	djnz mascara_hace_unos		;aa34
	jr mascara_gira		;aa36
linea_bresenham:		; Una linea de HL (0xFE85) a BC (0xFE7C): los pasos en X y en Y (0xFE7F, 0xFE80, +-1 o 0, 0xAAF4), el eje mayor (bit 7 de 0xFE7E si es el vertical), la pendiente en 16 bits (0xFE83, por division) y, punto a punto, se suma (0xFE81) y se pinta (0xAB04)
	ld (0fe85h),hl		;aa38   ; el principio de la linea
	ld (0fe7ch),bc		;aa3b   ; el final de la linea
	push hl			;aa3f
	push bc			;aa40
	ld hl,0fe7eh		;aa41   ; eje mayor: X
	res 7,(hl)		;aa44
	ld hl,00000h		;aa46   ; la suma a 0
	ld (0fe81h),hl		;aa49   ; la suma
	ld hl,(0fe85h)		;aa4c   ; el principio de la linea
	ld de,(0fe7ch)		;aa4f   ; el final de la linea
	ld a,e			;aa53
	ld b,l			;aa54
	call paso_signo		;aa55   ; el paso en X
	push af			;aa58
	ld a,b			;aa59
	ld (0fe7fh),a		;aa5a   ; el paso en X
	ld a,d			;aa5d
	ld b,h			;aa5e
	call paso_signo		;aa5f   ; el paso en Y
	ld c,a			;aa62
	ld a,b			;aa63
	ld (0fe80h),a		;aa64   ; el paso en Y
	pop af			;aa67
	cp c			;aa68   ; iguales: 45 grados
	ld hl,0ffffh		;aa69
	jr z,linea_pendiente		;aa6c
	inc h			;aa6e
	ld l,c			;aa6f
	ld d,h			;aa70
	ld e,a			;aa71
	jr nc,linea_divide		;aa72
	ex de,hl			;aa74
	push hl			;aa75
	ld hl,0fe7eh		;aa76
	set 7,(hl)		;aa79   ; el vertical
	pop hl			;aa7b
linea_divide:
	ld bc,00000h		;aa7c
	push bc			;aa7f
	inc c			;aa80
linea_divide_bit:
	add hl,hl			;aa81   ; el resto x 2
	ld a,b			;aa82
	srl a		;aa83   ; el bit...
	rr c		;aa85
	rr b		;aa87   ; ...siguiente
	call 00020h		;aa89   ; DCOMPR
	jr c,linea_divide_sig		;aa8c   ; no cabe
	sbc hl,de		;aa8e   ; se resta
	ex (sp),hl			;aa90
	add hl,bc			;aa91   ; el bit al cociente
	ex (sp),hl			;aa92
linea_divide_sig:
	ld a,c			;aa93
	dec a			;aa94
	jr nz,linea_divide_bit		;aa95
	pop hl			;aa97
linea_pendiente:
	ld (0fe83h),hl		;aa98   ; la pendiente
	pop hl			;aa9b
	pop de			;aa9c
	ld a,(0fe7eh)		;aa9d   ; el eje mayor
	ld bc,(0fe7fh)		;aaa0   ; el paso en X
	bit 7,a		;aaa4
	jr z,linea_puntos		;aaa6
	ld a,l			;aaa8
	ld l,h			;aaa9
	ld h,a			;aaaa
	ld a,e			;aaab
	ld e,d			;aaac
	ld d,a			;aaad
	ld a,c			;aaae
	ld c,b			;aaaf
	ld b,a			;aab0
linea_puntos:
	ld (0fe7fh),bc		;aab1   ; el paso en X
	ld a,l			;aab5
	sub e			;aab6
	jr nc,linea_cuenta		;aab7
	neg		;aab9
linea_cuenta:
	push af			;aabb
	push de			;aabc
linea_punto:
	ex de,hl			;aabd
	ld a,(0fe7eh)		;aabe   ; el eje mayor
	bit 7,a		;aac1
	jr z,linea_punto_pon		;aac3
	ld a,l			;aac5
	ld l,h			;aac6
	ld h,a			;aac7
linea_punto_pon:
	call punto		;aac8   ; el punto
	pop de			;aacb
	pop bc			;aacc
	ld a,b			;aacd
	dec b			;aace
	and a			;aacf
	ret z			;aad0
	ld hl,(0fe81h)		;aad1   ; la suma
	push bc			;aad4
	ld bc,(0fe83h)		;aad5   ; la pendiente
	add hl,bc			;aad9
	ld (0fe81h),hl		;aada   ; la suma
	ld a,(0fe80h)		;aadd   ; el paso en Y
	ld c,a			;aae0
	jr nc,linea_x		;aae1
	add a,d			;aae3
	ld d,a			;aae4
linea_x:
	ld a,(0fe7fh)		;aae5   ; el paso en X
	add a,e			;aae8
	ld e,a			;aae9
	push de			;aaea
	bit 7,h		;aaeb
	jr z,linea_sig		;aaed
	ld a,c			;aaef
	add a,d			;aaf0
	ld d,a			;aaf1
linea_sig:
	jr linea_punto		;aaf2
paso_signo:		; B = el signo de A - B (0, 1 o -1); A = la distancia sin signo
	sub b			;aaf4   ; la diferencia
	ld b,000h		;aaf5   ; sin paso
	ret z			;aaf7   ; 0
	inc b			;aaf8   ; +1
	ret nc			;aaf9
	ld b,0ffh		;aafa   ; -1
	neg		;aafc   ; sin signo
	ret			;aafe
punto_color:		; El punto HL del color A (0xFE74)
	and 00fh		;aaff
	ld (0fe74h),a		;ab01   ; el color de dibujar
punto:		; El punto (H = Y, L = X): su byte de la VRAM (0xAF21, 0xAF4D, 0xAF12) y el bit (0xFE8D, 0xA9AD)
	call punto_direccion		;ab04
	call byte_lee		;ab07
	call colores_lee		;ab0a
	ld a,(0fe8dh)		;ab0d   ; el bit
	call punto_byte_pon		;ab10
	and a			;ab13
	ret			;ab14
punto_dentro:		; El punto, si cae dentro del lienzo (Y hasta 0xBF, X de 8 a 0xB7)
	inc h			;ab15   ; la Y por encima de 255?
	dec h			;ab16
	ret nz			;ab17
	inc d			;ab18   ; la X?
	dec d			;ab19
	ret nz			;ab1a
	ld a,0bfh		;ab1b   ; Y hasta 0xBF
	cp e			;ab1d
	ret c			;ab1e
	ld a,0b7h		;ab1f   ; X hasta 0xB7
	cp l			;ab21
	ret c			;ab22
	ld a,l			;ab23
	cp 008h		;ab24   ; desde 8
	ret c			;ab26
	ld h,e			;ab27   ; la Y
	jr punto		;ab28   ; el punto
pintar:		; PAINT: rellena desde el punto HL con el color A (0xFE74; color y fondo en 0xFE98) por filas: busca los bordes a la izquierda (0xABE9) y a la derecha (0xACE5) de cada tramo, mira la fila de arriba y la de abajo (0xAD74) y guarda en la pila de la RAM libre (0xAE89, 0xAE98, 0xAEA3) los tramos por rellenar; acaba con la pila vacia (0xAE66)
	and 00fh		;ab2a
	ld (0fe74h),a		;ab2c   ; el color de dibujar
	push af			;ab2f   ; el color...
	ld a,(0fe74h)		;ab30   ; el color de dibujar
	rlca			;ab33
	rlca			;ab34
	rlca			;ab35
	rlca			;ab36
	ld c,a			;ab37   ; ...y el fondo de antes
	ld a,(0fe7bh)		;ab38
	and 00fh		;ab3b
	or c			;ab3d
	ld (0fe98h),a		;ab3e   ; el color de PAINT
	pop af			;ab41
	call punto_direccion		;ab42
pintar_tramo:
	ld (0fe90h),hl		;ab45   ; el punto
	ld (0fe92h),a		;ab48   ; su bit
	call pintar_marca		;ab4b
pintar_izquierda:
	call pintar_byte_izq		;ab4e   ; hacia la izquierda
	jr c,pintar_izquierda_fin		;ab51
	ld a,00fh		;ab53
	cp l			;ab55
	ccf			;ab56
	jr nc,pintar_izquierda_byte		;ab57
	jr pintar_borde		;ab59
pintar_izquierda_byte:
	call byte_izquierda		;ab5b
	ex de,hl			;ab5e
	ld bc,00008h		;ab5f
	and a			;ab62
	sbc hl,bc		;ab63
	ld (0fe89h),hl		;ab65   ; el byte de colores
	ex de,hl			;ab68
	xor a			;ab69
	ld (0fea2h),a		;ab6a   ; la marca
	jr pintar_izquierda		;ab6d
pintar_izquierda_fin:
	cp 0f0h		;ab6f
	jr c,pintar_borde_pon		;ab71
	jr nz,pintar_siguiente		;ab73
	call byte_derecha		;ab75
pintar_borde:
	ld a,007h		;ab78
pintar_borde_pon:
	ld (0fe9bh),hl		;ab7a   ; el principio del tramo
	ld (0fe9fh),a		;ab7d
	call pintar_punto_vuelve		;ab80
pintar_derecha:
	call pintar_byte_der		;ab83   ; hacia la derecha
	jr c,pintar_derecha_fin		;ab86
	call borde_derecho		;ab88
	jr c,pintar_derecha_cero		;ab8b
	call byte_derecha		;ab8d
	call color_derecha		;ab90
	ld a,007h		;ab93
	jr pintar_derecha		;ab95
pintar_derecha_fin:
	cp 0f0h		;ab97
	jr c,pintar_tramo_fin		;ab99
	ld a,(0fe8dh)		;ab9b   ; el bit
	and a			;ab9e
	jr nz,pintar_derecha_byte		;ab9f
	ld a,(0fe92h)		;aba1   ; su bit
	and a			;aba4
	jr z,pintar_tramo_fin		;aba5
pintar_derecha_byte:
	call byte_izquierda		;aba7
pintar_derecha_cero:
	xor a			;abaa
pintar_tramo_fin:
	ld (0fe9dh),hl		;abab   ; el final del tramo
	ld (0fea0h),a		;abae
	call tramo_pintado		;abb1
	ld hl,(0fe9dh)		;abb4
	ld a,h			;abb7   ; la ultima fila?
	cp 017h		;abb8
	jr nz,pintar_abajo		;abba
	ld a,l			;abbc
	and 007h		;abbd
	cp 007h		;abbf
	jr z,pintar_arriba_mira		;abc1
pintar_abajo:
	call pintar_fila_abajo		;abc3   ; la fila de abajo
	call pintar_fila		;abc6
pintar_arriba_mira:
	call tramo_pintado		;abc9
	ld hl,(0fe9dh)		;abcc
	ld a,h			;abcf
	and a			;abd0   ; la primera fila?
	jr nz,pintar_arriba		;abd1
	ld a,l			;abd3
	and 007h		;abd4
	jr z,pintar_siguiente		;abd6
pintar_arriba:
	call pintar_fila_arriba		;abd8   ; la fila de arriba
	call pintar_fila		;abdb
pintar_siguiente:
	call pila_pinta_saca		;abde   ; de la pila
	ccf			;abe1
	ret nc			;abe2
	call colores_direccion		;abe3
	jp pintar_tramo		;abe6
pintar_byte_izq:		; Un byte hacia la izquierda: si el punto ya es del color, se para; si no, el byte se pinta hasta el borde (0xAC22)
	call byte_lee		;abe9
	call colores_lee		;abec
	call color_compara		;abef
	jr c,pintar_byte_izq_mira		;abf2
	ld hl,(0fe87h)		;abf4   ; el byte de dibujo
	ld de,(0fe89h)		;abf7   ; el byte de colores
	call byte_lleno		;abfb
	call pintar_marca_mira		;abfe
	ret z			;ac01
	call borde_derecho		;ac02
	jr c,pintar_byte_izq_borde		;ac05
	call byte_derecha		;ac07
	ld a,007h		;ac0a
	ld (0fe90h),hl		;ac0c   ; el punto de PAINT
	ld (0fe92h),a		;ac0f   ; su bit
	call byte_izquierda		;ac12
	xor a			;ac15
	ret			;ac16
pintar_byte_izq_borde:
	xor a			;ac17
	ld (0fe92h),a		;ac18   ; su bit
	ret			;ac1b
pintar_byte_izq_mira:
	call pintar_byte_izq_va		;ac1c
	ret c			;ac1f
	xor a			;ac20
	ret			;ac21
pintar_byte_izq_va:
	cp 002h		;ac22
	jr c,pintar_byte_izq_otro		;ac24
	call pintar_bits_izq		;ac26
pintar_byte_izq_pon:
	push af			;ac29
	ld a,(0fea1h)		;ac2a   ; el borde
	and a			;ac2d
	call z,pintar_byte_escribe		;ac2e
	xor a			;ac31
	ld (0fea2h),a		;ac32   ; la marca
	pop af			;ac35
	ret			;ac36
pintar_byte_escribe:
	ld a,c			;ac37
	jp dibujo_escribe		;ac38
pintar_byte_izq_otro:
	cpl			;ac3b   ; dado la vuelta
	push af			;ac3c
	ld a,(hl)			;ac3d   ; el byte...
	cpl			;ac3e   ; ...dado la vuelta
	ld (hl),a			;ac3f
	pop af			;ac40
	call pintar_bits_izq		;ac41   ; los bits
	push af			;ac44
	ld a,c			;ac45   ; la mascara...
	cpl			;ac46   ; ...dada la vuelta
	ld c,a			;ac47
	pop af			;ac48
	jr pintar_byte_izq_pon		;ac49
pintar_marca:		; 0xFEA2 = 0xFF
	push af			;ac4b
	ld a,0ffh		;ac4c
	ld (0fea2h),a		;ac4e   ; la marca
	pop af			;ac51
	ret			;ac52
pintar_marca_mira:		; A = 0xFEA2 (Z si esta a 0)
	ld a,(0fea2h)		;ac53   ; la marca
	and a			;ac56
	ret			;ac57
pintar_bits_izq:		; Los bits del byte hacia la izquierda desde 0xFE8D hasta el primero de borde (0xACC6): C la mascara; con borde, C y A = el bit
	cp 0ffh		;ac58
	ld a,000h		;ac5a
	ld (0fea1h),a		;ac5c   ; el borde
	jr z,pintar_bits_izq_todo		;ac5f
	ld a,(hl)			;ac61
	ld hl,0fe99h		;ac62
	ld (hl),a			;ac65
	call bit_mira		;ac66
	ld a,0f0h		;ac69
	jr nz,pintar_bits_izq_fin		;ac6b
	ld a,(0fe8dh)		;ac6d   ; el bit
	cp 007h		;ac70
	ld c,(hl)			;ac72
	jr nc,pintar_bits_izq_fin		;ac73
	sub 007h		;ac75
	neg		;ac77
	ld b,a			;ac79
pintar_bits_izq_gira:
	rlc c		;ac7a
	djnz pintar_bits_izq_gira		;ac7c
pintar_bits_izq_uno:
	rrc c		;ac7e   ; el bit siguiente
	set 7,c		;ac80   ; a 1
	jr c,pintar_bits_izq_borde		;ac82   ; un borde
	inc b			;ac84   ; uno mas
	cp b			;ac85
	jr nz,pintar_bits_izq_uno		;ac86
pintar_bits_izq_fin:
	ld hl,(0fe87h)		;ac88   ; el byte de dibujo
	ld de,(0fe89h)		;ac8b   ; el byte de colores
	jr pintar_bits_izq_sale		;ac8f
pintar_bits_izq_borde:
	ld e,b			;ac91
pintar_bits_izq_borde2:
	inc e			;ac92
	cp e			;ac93
	jr z,pintar_bits_izq_borde3		;ac94
	rrc c		;ac96
	jr pintar_bits_izq_borde2		;ac98
pintar_bits_izq_borde3:
	call pintar_marca_mira		;ac9a
	jr nz,pintar_bits_izq_pon		;ac9d
	set 0,c		;ac9f
pintar_bits_izq_pon:
	ld a,(0fe8dh)		;aca1   ; el bit
	add a,b			;aca4
	scf			;aca5
	jr pintar_bits_izq_fin		;aca6
pintar_bits_izq_sale:
	bit 7,a		;aca8
	jr nz,pintar_bits_izq_todo		;acaa
	ret c			;acac
	xor a			;acad
	ret			;acae
pintar_bits_izq_todo:
	call pintar_marca_mira		;acaf
	jr nz,pintar_bits_izq_ff		;acb2
	ld a,0f0h		;acb4
pintar_bits_izq_todo2:
	ld (0fea1h),a		;acb6   ; el borde
	ld hl,(0fe87h)		;acb9   ; el byte de dibujo
	ld de,(0fe89h)		;acbc   ; el byte de colores
	scf			;acc0
	ret			;acc1
pintar_bits_izq_ff:
	ld a,0ffh		;acc2
	jr pintar_bits_izq_todo2		;acc4
bit_mira:		; El bit 0xFE8D del byte de HL (con la instruccion "bit n,a" escrita en 0xFE93, 0xACCD)
	call bit_mira_arma		;acc6
	ld a,(hl)			;acc9
	jp 0fe93h		;acca
bit_mira_arma:		; Escribe en 0xFE93 "bit n,a" (0xCB, 0x47 + n x 8) y "ret"
	push hl			;accd
	ld a,(0fe8dh)		;acce   ; el bit
	ld b,a			;acd1
	inc b			;acd2
	ld hl,0fe93h		;acd3
	ld (hl),0cbh		;acd6
	inc hl			;acd8
	ld a,03fh		;acd9
bit_mira_arma_uno:
	add a,008h		;acdb   ; + 8 por bit
	djnz bit_mira_arma_uno		;acdd
	ld (hl),a			;acdf   ; "bit n,a"
	inc hl			;ace0
	ld (hl),0c9h		;ace1   ; "ret"
	pop hl			;ace3
	ret			;ace4
pintar_byte_der:		; Un byte hacia la derecha (como 0xABE9)
	call byte_lee		;ace5
	call colores_lee		;ace8
	call color_compara		;aceb
	jr c,pintar_byte_der_mira		;acee
	ld hl,(0fe87h)		;acf0   ; el byte de dibujo
	ld de,(0fe89h)		;acf3   ; el byte de colores
	call byte_lleno		;acf7
	and a			;acfa
	ret			;acfb
pintar_byte_der_mira:
	cp 002h		;acfc
	jr c,pintar_byte_der_otro		;acfe
	call pintar_bits_der		;ad00
	push af			;ad03
pintar_byte_der_pon:
	ld a,(0fea1h)		;ad04   ; el borde
	and a			;ad07
	jr z,pintar_byte_der_escribe		;ad08
	pop af			;ad0a
	ret			;ad0b
pintar_byte_der_escribe:
	ld a,c			;ad0c
	call dibujo_escribe		;ad0d
	pop af			;ad10
	ret			;ad11
pintar_byte_der_otro:
	cpl			;ad12   ; dado la vuelta
	push af			;ad13
	ld a,(hl)			;ad14   ; el byte...
	cpl			;ad15   ; ...dado la vuelta
	ld (hl),a			;ad16
	pop af			;ad17
	call pintar_bits_der		;ad18   ; los bits
	push af			;ad1b
	ld a,c			;ad1c   ; la mascara...
	cpl			;ad1d   ; ...dada la vuelta
	ld c,a			;ad1e
	jr pintar_byte_der_pon		;ad1f
pintar_bits_der:		; Los bits hacia la derecha hasta el borde
	cp 0ffh		;ad21
	jr z,pintar_bits_der_todo		;ad23
	xor a			;ad25
	ld (0fea1h),a		;ad26   ; el borde
	ld a,(hl)			;ad29
	ld hl,0fe99h		;ad2a
	ld (hl),a			;ad2d
	call bit_mira		;ad2e
	ld a,0ffh		;ad31
	jr nz,pintar_bits_der_fin		;ad33
	ld c,(hl)			;ad35
	ld a,(0fe8dh)		;ad36   ; el bit
	and a			;ad39
	jr z,pintar_bits_der_cero		;ad3a
	ld b,a			;ad3c
pintar_bits_der_gira:
	rrc c		;ad3d
	djnz pintar_bits_der_gira		;ad3f
	set 0,c		;ad41
pintar_bits_der_uno:
	rlc c		;ad43   ; el bit siguiente
	jr c,pintar_bits_der_borde		;ad45   ; un borde
	set 0,c		;ad47   ; a 1
	inc b			;ad49   ; uno mas
	cp b			;ad4a
	jr nz,pintar_bits_der_uno		;ad4b
pintar_bits_der_fin:
	ld hl,(0fe87h)		;ad4d   ; el byte de dibujo
	ld de,(0fe89h)		;ad50   ; el byte de colores
	jr pintar_bits_der_sale		;ad54
pintar_bits_der_borde:
	ld e,b			;ad56
pintar_bits_der_borde2:
	inc e			;ad57
	cp e			;ad58
	jr z,pintar_bits_der_borde3		;ad59
	rlc c		;ad5b
	jr pintar_bits_der_borde2		;ad5d
pintar_bits_der_borde3:
	sub b			;ad5f
	scf			;ad60
	jr pintar_bits_der_fin		;ad61
pintar_bits_der_cero:
	set 0,c		;ad63
	jr pintar_bits_der_fin		;ad65
pintar_bits_der_sale:
	bit 7,a		;ad67
	jr nz,pintar_bits_der_todo		;ad69
	ret			;ad6b
pintar_bits_der_todo:
	ld (0fea1h),a		;ad6c   ; el borde
	scf			;ad6f
	ld hl,(0fe87h)		;ad70   ; el byte de dibujo
	ret			;ad73
pintar_fila:		; Recorre la fila de arriba o de abajo del tramo (de 0xFE9B a 0xFE96) buscando los tramos sin pintar y los apunta en la pila (0xAE26, 0xADE7)
	call colores_direccion		;ad74
	ld a,(0fe9fh)		;ad77
pintar_fila_byte:
	call byte_lee		;ad7a
	call colores_lee		;ad7d
	push hl			;ad80
	ld hl,(0fe87h)		;ad81   ; el byte de dibujo
	ld bc,(0fe96h)		;ad84   ; el final del tramo
	and a			;ad88
	sbc hl,bc		;ad89
	pop hl			;ad8b
	jr z,pintar_fila_ultimo		;ad8c
	call color_compara		;ad8e
	ld c,000h		;ad91
	jr nc,pintar_fila_mira		;ad93
	ld c,0ffh		;ad95
pintar_fila_mira:
	and a			;ad97
	jr z,pintar_fila_todo		;ad98
	cp 003h		;ad9a
	jr nc,pintar_fila_todo		;ad9c
	push af			;ad9e
	ld a,(0fe8dh)		;ad9f   ; el bit
	inc a			;ada2
	ld b,a			;ada3
	pop af			;ada4
	call pintar_fila_bits		;ada5
pintar_fila_sig:
	ld hl,(0fe87h)		;ada8   ; el byte de dibujo
	call byte_derecha		;adab
	ld de,(0fe89h)		;adae   ; el byte de colores
	call color_derecha		;adb2
	ld a,007h		;adb5
	jr pintar_fila_byte		;adb7
pintar_fila_todo:
	call pintar_fila_cambia		;adb9
	jr nc,pintar_fila_sig		;adbc
	call pila_pinta_mete		;adbe
	jr pintar_fila_sig		;adc1
pintar_fila_ultimo:
	call color_compara		;adc3
	ld c,000h		;adc6
	jr nc,pintar_fila_ultimo_va		;adc8
	ld c,0ffh		;adca
pintar_fila_ultimo_va:
	and a			;adcc   ; nada?
	jr z,pintar_fila_ultimo_todo		;adcd
	cp 003h		;adcf   ; 3 o mas?
	jr nc,pintar_fila_ultimo_todo		;add1
	push af			;add3
	ld a,(0fea0h)		;add4   ; donde empezo
	ld b,a			;add7
	ld a,(0fe8dh)		;add8   ; el bit
	inc a			;addb   ; los bits que quedan
	sub b			;addc
	ld b,a			;addd
	pop af			;adde
	jr pintar_fila_bits		;addf   ; a la pila
pintar_fila_ultimo_todo:
	call pintar_fila_cambia		;ade1
	ret nc			;ade4
	jr pila_pinta_mete		;ade5
pintar_fila_cambia:		; Si cambia de pintado a sin pintar (0xFEA3), el tramo nuevo a la pila (0xAE89/0xAE90)
	ld a,(0fea3h)		;ade7   ; pintado o sin pintar
	and a			;adea
	jr z,pintar_fila_cambia_b		;adeb
	inc c			;aded
	dec c			;adee
	call nz,tramo_pintado		;adef
pintar_fila_cambia_va:
	and a			;adf2
	jr pintar_fila_cambia_fin		;adf3
pintar_fila_cambia_b:
	inc c			;adf5
	dec c			;adf6
	jr nz,pintar_fila_cambia_va		;adf7
	call tramo_sin		;adf9
	scf			;adfc
pintar_fila_cambia_fin:
	ld b,007h		;adfd
	ret			;adff
pila_pinta_mete:		; Mete el punto HL (con B en los bits de arriba de H) en la pila de PAINT (0xFE79, hacia abajo); si llega al final de lo usado (0xFE75), "no hay memoria"
	ld hl,(0fe87h)		;ae00   ; el byte de dibujo
	ld a,b			;ae03
	ld b,005h		;ae04
pila_pinta_mete_bits:
	rlca			;ae06
	djnz pila_pinta_mete_bits		;ae07
	add a,h			;ae09
	ld h,a			;ae0a
	push hl			;ae0b
	ld hl,(0fe79h)		;ae0c   ; la pila
	ld bc,(0fe75h)		;ae0f   ; el limite
	inc bc			;ae13
	inc bc			;ae14
	and a			;ae15
	push hl			;ae16
	sbc hl,bc		;ae17
	pop hl			;ae19
	pop bc			;ae1a
	jp c,sin_memoria		;ae1b   ; no cabe
	dec hl			;ae1e
	ld (hl),b			;ae1f
	dec hl			;ae20
	ld (hl),c			;ae21
	ld (0fe79h),hl		;ae22   ; la pila de PAINT
	ret			;ae25
pintar_fila_bits:		; Los bits del byte de la fila vecina: cada cambio entre pintado y sin pintar (0xFEA3) apunta un tramo (0xAE00)
	call bits_desde		;ae26
	dec c			;ae29
	call z,dale_vuelta		;ae2a
	ld c,a			;ae2d
pintar_fila_bit:
	ld a,(0fea3h)		;ae2e   ; pintado o sin pintar
	and a			;ae31
	ld a,c			;ae32
	jr z,pintar_fila_bit_sin		;ae33
	rla			;ae35
	ld c,a			;ae36
	jr nc,pintar_fila_bit_sig		;ae37
	call tramo_pintado		;ae39
	jr pintar_fila_bit_sig		;ae3c
pintar_fila_bit_sin:
	rla			;ae3e   ; el bit siguiente
	ld c,a			;ae3f
	jr c,pintar_fila_bit_sig		;ae40
	call tramo_sin		;ae42   ; sin pintar
	push bc			;ae45
	ld b,e			;ae46
	call pila_pinta_mete		;ae47   ; a la pila
	pop bc			;ae4a
pintar_fila_bit_sig:
	dec e			;ae4b
	djnz pintar_fila_bit		;ae4c
	ret			;ae4e
dale_vuelta:		; A = A dado la vuelta
	cpl			;ae4f
	ret			;ae50
bits_desde:		; Los bits del byte de HL desde el punto 0xFE8D (girado hasta el)
	ld c,a			;ae51
	ld a,(0fe8dh)		;ae52   ; el bit
	ld e,a			;ae55
	sub 007h		;ae56
	jr z,bits_desde_fin		;ae58
	neg		;ae5a
	push bc			;ae5c
	ld b,a			;ae5d
	ld a,(hl)			;ae5e
bits_desde_gira:
	rla			;ae5f
	djnz bits_desde_gira		;ae60
	pop bc			;ae62
	ret			;ae63
bits_desde_fin:
	ld a,(hl)			;ae64
	ret			;ae65
pila_pinta_saca:		; Saca un punto de la pila de PAINT: C si esta vacia (0xFE79 = 0xFE77); HL el byte y A el bit (los 3 de arriba de H)
	ld hl,(0fe79h)		;ae66   ; la pila de PAINT
	ld bc,(0fe77h)		;ae69   ; el fondo de la pila de PAINT
	push hl			;ae6d
	and a			;ae6e
	sbc hl,bc		;ae6f
	pop hl			;ae71
	ccf			;ae72
	ret c			;ae73
	ld e,(hl)			;ae74
	inc hl			;ae75
	ld d,(hl)			;ae76
	inc hl			;ae77
	ld (0fe79h),hl		;ae78   ; la pila de PAINT
	ex de,hl			;ae7b
	ld c,h			;ae7c
	ld a,h			;ae7d
	and 01fh		;ae7e
	ld h,a			;ae80
	ld a,c			;ae81
	rla			;ae82
	rla			;ae83
	rla			;ae84
	rla			;ae85
	and 007h		;ae86
	ret			;ae88
tramo_pintado:		; 0xFEA3 = 0
	push af			;ae89
	xor a			;ae8a
	ld (0fea3h),a		;ae8b   ; pintado o sin pintar
	pop af			;ae8e
	ret			;ae8f
tramo_sin:		; 0xFEA3 = 0xFF
	push af			;ae90
	ld a,0ffh		;ae91
	ld (0fea3h),a		;ae93   ; pintado o sin pintar
	pop af			;ae96
	ret			;ae97
pintar_fila_abajo:		; El principio (0xFE96) y el final de la fila de abajo (un byte mas abajo, 0xAEAE)
	call byte_abajo		;ae98
	ld (0fe96h),hl		;ae9b   ; el final del tramo
	ld hl,(0fe9bh)		;ae9e   ; el principio del tramo
	jr byte_abajo		;aea1
pintar_fila_arriba:		; Los de la fila de arriba (0xAEBF)
	call byte_arriba		;aea3
	ld (0fe96h),hl		;aea6   ; el final del tramo
	ld hl,(0fe9bh)		;aea9   ; el principio del tramo
	jr byte_arriba		;aeac
byte_abajo:		; HL, la fila de puntos de abajo (+1; en la ultima de la casilla, + 0xF9: la casilla de abajo)
	push af			;aeae
	ld a,l			;aeaf   ; la fila
	and 007h		;aeb0
	cp 007h		;aeb2   ; la ultima de la casilla?
	jr z,byte_abajo_casilla		;aeb4
	inc hl			;aeb6   ; la siguiente
	pop af			;aeb7
	ret			;aeb8
byte_abajo_casilla:
	ld bc,000f9h		;aeb9
	add hl,bc			;aebc
	pop af			;aebd
	ret			;aebe
byte_arriba:		; HL, la fila de arriba
	push af			;aebf
	ld a,l			;aec0   ; la fila
	and 007h		;aec1
	jr z,byte_arriba_casilla		;aec3   ; la primera de la casilla?
	dec hl			;aec5   ; la anterior
	pop af			;aec6
	ret			;aec7
byte_arriba_casilla:
	ld bc,000f9h		;aec8
	sbc hl,bc		;aecb
	pop af			;aecd
	ret			;aece
borde_derecho:		; C si L pasa de 0xAF (el borde derecho del lienzo)
	ld a,0afh		;aecf
	cp l			;aed1
	ret			;aed2
color_fondo_pon:		; El color (0xFE74) en el fondo del byte de colores (rrd) y a la VRAM (0xFE89)
	ld a,(0fe74h)		;aed3   ; el color de dibujar
	ld (0fe99h),a		;aed6
	ld a,(de)			;aed9
	push hl			;aeda
	ld hl,0fe99h		;aedb
	rrd		;aede
	pop hl			;aee0
	jp color_escribe		;aee1
color_tinta_pon:		; El color en la tinta (rld) y a la VRAM
	ld a,(0fe74h)		;aee4   ; el color de dibujar
	ld (0fe99h),a		;aee7
	ld a,(de)			;aeea
	push hl			;aeeb
	ld hl,0fe99h		;aeec
	rld		;aeef
	ld a,(hl)			;aef1
	pop hl			;aef2
	jp color_escribe		;aef3
byte_derecha:		; HL + 8 (el byte de la derecha) a 0xFE87
	ld bc,00008h		;aef6
	add hl,bc			;aef9
	ld (0fe87h),hl		;aefa   ; el byte de dibujo
	ret			;aefd
byte_izquierda:		; HL - 8 a 0xFE87
	ld bc,00008h		;aefe
	and a			;af01
	sbc hl,bc		;af02
	ld (0fe87h),hl		;af04   ; el byte de dibujo
	ret			;af07
color_derecha:		; DE + 8 a 0xFE89
	ex de,hl			;af08
	ld bc,00008h		;af09
	add hl,bc			;af0c
	ld (0fe89h),hl		;af0d   ; el byte de colores
	ex de,hl			;af10
	ret			;af11
colores_lee:		; Los dos colores del byte de colores (DE): tinta a 0xFE8E y fondo a 0xFE8F
	ex de,hl			;af12
	ld a,(hl)			;af13   ; el byte de colores
	push hl			;af14
	ld hl,0fe8fh		;af15   ; el fondo
	ld (hl),a			;af18
	xor a			;af19
	rrd		;af1a   ; la tinta a A
	dec hl			;af1c
	ld (hl),a			;af1d   ; la tinta
	pop hl			;af1e
	ex de,hl			;af1f
	ret			;af20
punto_direccion:		; La direccion en la VRAM del punto (H = Y, L = X): (Y / 8) x 256 + Y & 7 + X & 0xF8; A = el bit (7 - X & 7); DE = la de sus colores (+ 0x2000)
	ld a,h			;af21   ; la Y
	push af			;af22
	srl a		;af23   ; / 8: la fila de casillas
	srl a		;af25
	srl a		;af27
	ld b,a			;af29
	pop af			;af2a
	and 007h		;af2b   ; la fila dentro de la casilla
	ld c,a			;af2d
	ld a,l			;af2e   ; la X
	push af			;af2f
	and 0f8h		;af30   ; de 8 en 8
	ld l,a			;af32
	ld h,000h		;af33
	add hl,bc			;af35   ; la direccion
	pop af			;af36
	cpl			;af37   ; el bit: 7 - X & 7
	and 007h		;af38
colores_direccion:		; DE = HL + 0x2000 (los colores)
	ld e,l			;af3a
	ld d,h			;af3b
	ld bc,02000h		;af3c   ; + 0x2000
	add hl,bc			;af3f
	ex de,hl			;af40
	ret			;af41
pintar_punto_vuelve:		; 0xFEA2 = 0xFF y el punto de 0xFE90 y su bit 0xFE92
	call pintar_marca		;af42
	ld hl,(0fe90h)		;af45   ; el punto de PAINT
	ld a,(0fe92h)		;af48   ; su bit
	jr colores_direccion		;af4b
byte_lee:		; El bit A (0xFE8D), el byte de dibujo (HL, 0xFE87, RDVRM, a 0xFE8B) y el de colores (DE, 0xFE89, a 0xFE8C)
	ld (0fe8dh),a		;af4d   ; el bit
	ld (0fe87h),hl		;af50   ; el byte de dibujo
	call 0004ah		;af53   ; RDVRM
	ld (0fe8bh),a		;af56   ; el dibujo leido
	ex de,hl			;af59
	ld (0fe89h),hl		;af5a   ; el byte de colores
	call 0004ah		;af5d   ; RDVRM
	ld (0fe8ch),a		;af60   ; los colores leidos
	ld hl,0fe8bh		;af63
	ld de,0fe8ch		;af66
	ret			;af69
dibujo_escribe:		; A al byte de dibujo (0xFE87; WRTVRM)
	ld hl,(0fe87h)		;af6a   ; el byte de dibujo
	jp 0004dh		;af6d   ; WRTVRM
color_escribe:		; A al byte de colores (0xFE89; WRTVRM)
	ld hl,(0fe89h)		;af70   ; el byte de colores
	jp 0004dh		;af73   ; WRTVRM
byte_lleno:		; El byte de dibujo a 0xFF y el de colores al de PAINT (0xFE98)
	push de			;af76
	push hl			;af77
	ld a,(0fe98h)		;af78   ; el color de PAINT
	ex de,hl			;af7b
	call 0004dh		;af7c   ; WRTVRM
	ex de,hl			;af7f
	ld a,0ffh		;af80
	call 0004dh		;af82   ; WRTVRM
	pop hl			;af85
	pop de			;af86
	ret			;af87
color_compara:		; Compara el color de dibujo (0xFE74) con la tinta y el fondo del byte: C y A = 0xFF si es los dos; si es la tinta, segun el dibujo (0xFF: NC; 0: C; otro, bit 0); si es el fondo, igual al reves (bit 1); si no es ninguno, bit 2 y NC
	push hl			;af88
	ld a,(0fe74h)		;af89   ; el color de dibujar
	ld hl,0fe8eh		;af8c   ; la tinta
	cp (hl)			;af8f   ; la misma?
	jr nz,color_compara_fondo		;af90
	inc hl			;af92
	cp (hl)			;af93   ; y el fondo?
	pop hl			;af94
	jr z,color_compara_los_dos		;af95   ; los dos
	ld a,(hl)			;af97   ; el dibujo
	cp 0ffh		;af98   ; todo tinta?
	jr z,color_compara_nc		;af9a
	and a			;af9c   ; todo fondo?
	jr z,color_compara_c		;af9d
	xor a			;af9f   ; mezcla: bit 0
	set 0,a		;afa0
	scf			;afa2
	ret			;afa3
color_compara_los_dos:
	ld a,0ffh		;afa4
	scf			;afa6
	ret			;afa7
color_compara_c:
	scf			;afa8
	ret			;afa9
color_compara_nc:
	xor a			;afaa
	ret			;afab
color_compara_fondo:
	inc hl			;afac
	cp (hl)			;afad   ; el fondo?
	pop hl			;afae
	jr nz,color_compara_otro		;afaf   ; ninguno
	ld a,(hl)			;afb1   ; el dibujo
	and a			;afb2   ; todo fondo?
	jr z,color_compara_fondo_ff		;afb3
	cp 0ffh		;afb5   ; todo tinta?
	jr z,color_compara_fondo_c		;afb7
	xor a			;afb9   ; mezcla: bit 1
	set 1,a		;afba
	scf			;afbc
	ret			;afbd
color_compara_fondo_ff:
	ld a,0ffh		;afbe
	ret			;afc0
color_compara_fondo_c:
	scf			;afc1
	ret			;afc2
color_compara_otro:
	xor a			;afc3
	set 2,a		;afc4
	and a			;afc6
	ret			;afc7
circulo:		; CIRCLE (0x5813): el radio = raiz de (dx2 + dy2) (0xB0B0, 0xB0CB) con centro en el primer punto; los 8 puntos simetricos (0xFC4E-0xFC6D) parten de los cuatro extremos y, paso a paso (el algoritmo del punto medio) hasta 0.7071 del radio (0xB505), se pintan los ocho (0xB0E4)
	ld (0fe74h),a		;afc8   ; el color
	push hl			;afcb
	push hl			;afcc
	push de			;afcd
	ld a,l			;afce
	sub e			;afcf   ; dx
	call cuadrado		;afd0   ; al cuadrado
	pop bc			;afd3
	pop de			;afd4
	push hl			;afd5
	ld a,b			;afd6
	sub d			;afd7   ; dy
	call cuadrado		;afd8   ; al cuadrado
	pop de			;afdb
	add hl,de			;afdc   ; la suma
	ld a,000h		;afdd
	jr nc,circulo_radio		;afdf
	inc a			;afe1
circulo_radio:
	call raiz		;afe2   ; la raiz: el radio
	pop de			;afe5   ; el centro
	ld h,000h		;afe6   ; Y del centro
	ld l,d			;afe8
	ld (0fc50h),hl		;afe9   ; los 8 puntos
	ld (0fc6ch),hl		;afec   ; el punto de abajo
	ld (0fc5ch),hl		;afef
	ld (0fc60h),hl		;aff2
	ld l,e			;aff5   ; X + radio
	add hl,bc			;aff6
	ld (0fc4eh),hl		;aff7   ; el de la derecha
	ld (0fc6ah),hl		;affa
	ld l,e			;affd   ; X - radio
	xor a			;affe
	ld h,a			;afff
	sbc hl,bc		;b000
	ld (0fc5ah),hl		;b002   ; el de la izquierda
	ld (0fc5eh),hl		;b005
	ld h,a			;b008
	ld l,e			;b009   ; la X del centro
	ld (0fc52h),hl		;b00a
	ld (0fc56h),hl		;b00d
	ld (0fc62h),hl		;b010
	ld (0fc66h),hl		;b013
	ld l,d			;b016   ; Y + radio
	add hl,bc			;b017
	ld (0fc64h),hl		;b018
	ld (0fc68h),hl		;b01b
	ld h,a			;b01e   ; Y - radio
	ld l,d			;b01f
	xor a			;b020
	sbc hl,bc		;b021
	ld (0fc54h),hl		;b023
	ld (0fc58h),hl		;b026
	push bc			;b029   ; los 8 puntos de los extremos
	call circulo_ocho		;b02a   ; pintados
	pop bc			;b02d
	ld a,b			;b02e   ; radio 0?
	or c			;b02f
	ret z			;b030
	ld de,0b505h		;b031   ; 0.7071
	push bc			;b034
	call multiplica		;b035   ; radio x 0.7071: los pasos
	pop bc			;b038
	ld h,b			;b039
	ld l,c			;b03a
	add hl,hl			;b03b   ; 2 x radio - 2: el error
	dec hl			;b03c
	dec hl			;b03d
	ld d,h			;b03e
	ld e,l			;b03f
	ld h,b			;b040
	ld l,c			;b041
	dec hl			;b042   ; radio - 1
	ld bc,0ffffh		;b043   ; BC = -1
circulo_paso:
	and a			;b046   ; el error...
	adc hl,bc		;b047   ; ...+ BC
	dec bc			;b049   ; BC - 2
	dec bc			;b04a
	jp p,circulo_paso_y		;b04b   ; el error todavia positivo?
	dec de			;b04e   ; DE - 2
	dec de			;b04f
	add hl,de			;b050   ; el error + DE
	exx			;b051
	ex af,af'			;b052
	ld hl,0fc4eh		;b053   ; los puntos de la derecha hacia dentro
	ld de,0fc6ah		;b056
	call dos_menos		;b059
	ld hl,0fc54h		;b05c   ; los de abajo
	ld de,0fc58h		;b05f
	call dos_mas		;b062
	ld hl,0fc5ah		;b065   ; los de arriba
	ld de,0fc5eh		;b068
	call dos_mas		;b06b
	ld hl,0fc64h		;b06e   ; los de la izquierda
	ld de,0fc68h		;b071
	call dos_menos		;b074
	exx			;b077
	ex af,af'			;b078
circulo_paso_y:
	exx			;b079   ; la Y de cada octante
	ex af,af'			;b07a
	ld hl,0fc50h		;b07b
	ld de,0fc5ch		;b07e
	call dos_menos		;b081
	ld hl,0fc52h		;b084
	ld de,0fc66h		;b087
	call dos_mas		;b08a
	ld hl,0fc56h		;b08d
	ld de,0fc62h		;b090
	call dos_menos		;b093
	ld hl,0fc60h		;b096
	ld de,0fc6ch		;b099
	call dos_mas		;b09c
	exx			;b09f
	ex af,af'			;b0a0
	push af			;b0a1
	push bc			;b0a2
	push de			;b0a3
	push hl			;b0a4
	call circulo_ocho		;b0a5   ; los ocho
	pop hl			;b0a8
	pop de			;b0a9
	pop bc			;b0aa
	pop af			;b0ab
	dec a			;b0ac   ; un paso menos
	jr nz,circulo_paso		;b0ad
	ret			;b0af   ; acabado
cuadrado:		; HL = A x A (sin signo)
	jr nc,cuadrado_va		;b0b0
	neg		;b0b2
cuadrado_va:
	ld c,a			;b0b4
	ld e,a			;b0b5
	ld b,007h		;b0b6
	ld d,000h		;b0b8
	ld hl,00000h		;b0ba
cuadrado_bit:
	sla c		;b0bd
	jr nc,cuadrado_sig		;b0bf
	add hl,de			;b0c1
cuadrado_sig:
	add hl,hl			;b0c2
	djnz cuadrado_bit		;b0c3
	sla c		;b0c5
	jr nc,cuadrado_fin		;b0c7
	add hl,de			;b0c9
cuadrado_fin:
	ret			;b0ca
raiz:		; BC = la raiz cuadrada de AHL (restando los impares 1, 3, 5...)
	ld bc,00000h		;b0cb
	scf			;b0ce
raiz_resta:
	sbc hl,bc		;b0cf
	jr c,raiz_fin		;b0d1
raiz_resta2:
	sbc hl,bc		;b0d3
	jr c,raiz_fin2		;b0d5
raiz_mas:
	inc bc			;b0d7
	jr raiz_resta		;b0d8
raiz_fin:
	sub 001h		;b0da
	jr z,raiz_resta2		;b0dc
	ret			;b0de
raiz_fin2:
	sub 001h		;b0df
	jr z,raiz_mas		;b0e1
	ret			;b0e3
circulo_ocho:		; Los 8 puntos de 0xFC4E (pares de X, Y) pintados si caen dentro (0xAB15)
	ld a,008h		;b0e4
	ld ix,0fc4eh		;b0e6
circulo_ocho_uno:
	ld bc,00004h		;b0ea
	ld l,(ix+000h)		;b0ed   ; la X
	ld h,(ix+001h)		;b0f0
	ld e,(ix+002h)		;b0f3   ; la Y
	ld d,(ix+003h)		;b0f6
	add ix,bc		;b0f9   ; el siguiente
	push ix		;b0fb
	push af			;b0fd
	call punto_dentro		;b0fe   ; pintado si cae dentro
	pop af			;b101
	pop ix		;b102
	dec a			;b104   ; los 8
	jr nz,circulo_ocho_uno		;b105
	ret			;b107
multiplica:		; A.HL = BC x DE / 256 (para el 0.7071 del radio)
	ld hl,00000h		;b108   ; a 0
	ld a,b			;b10b   ; BC > 255?
	or b			;b10c
	jr z,multiplica_va		;b10d
	add hl,de			;b10f   ; + DE
	add hl,hl			;b110
multiplica_va:
	ld b,008h		;b111
multiplica_bit:
	sla c		;b113
	jr nc,multiplica_sig		;b115
	add hl,de			;b117
	jr nc,multiplica_sig		;b118
	inc a			;b11a
multiplica_sig:
	add hl,hl			;b11b   ; x 2
	rla			;b11c   ; el acarreo
	djnz multiplica_bit		;b11d
	rra			;b11f   ; redondeo
	jr nc,multiplica_fin		;b120
	inc a			;b122
multiplica_fin:
	ret			;b123
dos_mas:		; Las palabras de HL y DE, uno mas
	inc (hl)			;b124   ; el bajo
	ex de,hl			;b125
	inc (hl)			;b126
	jr nz,dos_mas_fin		;b127   ; sin acarreo
	inc de			;b129
	inc hl			;b12a
	inc (hl)			;b12b   ; el alto
	ex de,hl			;b12c
	inc (hl)			;b12d
dos_mas_fin:
	ret			;b12e
dos_menos:		; Las palabras de HL y DE, uno menos
	ld a,(hl)			;b12f   ; el byte bajo
	sub 001h		;b130   ; - 1
	ld (hl),a			;b132
	ld (de),a			;b133   ; en los dos
	jr nc,dos_menos_fin		;b134   ; sin acarreo
	inc de			;b136
	inc hl			;b137
	dec (hl)			;b138   ; el alto
	ex de,hl			;b139
	dec (hl)			;b13a
dos_menos_fin:
	ret			;b13b

; ----------------------------------------------------------------------
; DATOS potencias: Las potencias de diez de numero_texto (0x801E): 10000, 1000
;   y 100 (y la siguiente, 10, es la primera palabra de 0xB142)
;   0xb13c..0xb142  (6 bytes)
DATA_potencias:
	defb 010h,027h,0e8h,003h,064h,000h	; b13c

; ----------------------------------------------------------------------
; DATOS tablas_rutinas: Las tablas de rutinas: 0xB142 (las rutinas de las
;   fichas, por fichas_recorre: 1 parada, 2 numeros suben, 3 empieza, 4 armas
;   contra el fondo, 5 se mueve, 6 numeros bajan, 7 sonido fuera, 8 ficha
;   fuera, 9 a su sitio), 0xB156 (los pasos de las 7 direcciones del punto, Y
;   y X), 0xB164 (las clases de cursor, por 0xFA37), 0xB179 (la tecla de menu
;   directo: pares de umbral y menu), 0xB19E (las teclas 7-0x0A: ayuda, lista
;   de sonidos y de personajes), 0xB1A4 (los 31 movimientos, por +0x1E de la
;   ficha) y 0xB1E2 (la rutina de entrada de cada menu, por su numero, hasta
;   0xB304)
;   0xb142..0xb304  (450 bytes)
DATA_tablas_rutinas:
	defb 00ah,000h,0ffh,083h,032h,07ah,0bfh,08bh,0dbh,08ch,049h,08eh,069h,084h,0cbh,084h	; b142  ....2z....I.i...
	defb 02ch,081h,0fbh,08bh,000h,0f8h,008h,0f8h,008h,000h,008h,008h,000h,008h,0f8h,008h	; b152  ,...............
	defb 0f8h,000h,0f8h,0f8h,068h,083h,06bh,083h,043h,083h,074h,083h,077h,083h,07ah,083h	; b162  ....h.k.C.t.w.z.
	defb 07dh,083h,080h,083h,083h,083h,001h,00dh,00ch,017h,016h,01bh,00ch,022h,07bh,023h	; b172  }............"{#
	defb 02bh,029h,016h,02ch,047h,046h,02bh,048h,047h,06bh,02bh,06eh,00ch,07ch,07bh,086h	; b182  +).,GF+HGk+n.|{.
	defb 00ch,088h,087h,096h,058h,0a0h,058h,028h,018h,068h,0a0h,068h,025h,07dh,09eh,07ch	; b192  ....X.X(.h.h%}.|
	defb 06ch,07ch,0ceh,07ch,013h,094h,00eh,094h,018h,094h,01dh,094h,058h,092h,035h,093h	; b1a2  l|.|........X.5.
	defb 046h,093h,014h,093h,017h,093h,01dh,093h,01ah,093h,0e3h,093h,0f0h,093h,09ch,093h	; b1b2  F...............
	defb 06bh,093h,064h,093h,047h,092h,058h,092h,014h,093h,017h,093h,01dh,093h,01ah,093h	; b1c2  k.d.G.X.........
	defb 0eah,093h,047h,092h,014h,093h,017h,093h,01dh,093h,01ah,093h,058h,092h,007h,094h	; b1d2  ..G.........X...
	defb 047h,092h,031h,070h,069h,070h,000h,000h,04dh,070h,034h,070h,037h,070h,091h,071h	; b1e2  G.1pip..Mp4p7p.q
	defb 086h,070h,000h,000h,0b1h,070h,000h,000h,0cch,071h,000h,000h,0d1h,071h,0f3h,071h	; b1f2  .p...p...q...q.q
	defb 000h,000h,0ffh,071h,008h,072h,000h,000h,04dh,072h,076h,072h,086h,072h,094h,072h	; b202  ...q.r..Mrvr.r.r
	defb 000h,000h,000h,000h,00ch,073h,06ah,04ch,06ah,04ch,06ah,04ch,06ah,04ch,06ah,04ch	; b212  .....sjLjLjLjLjL
	defb 000h,000h,000h,000h,005h,04dh,000h,000h,04eh,073h,000h,000h,000h,000h,055h,073h	; b222  .....M..Ns....Us
	defb 000h,000h,000h,000h,000h,000h,01bh,073h,000h,000h,000h,000h,000h,000h,0a2h,073h	; b232  .......s.......s
	defb 0d3h,073h,077h,073h,0e8h,073h,0e5h,073h,08fh,074h,000h,000h,0a5h,074h,020h,073h	; b242  .sws.s.s.t...t s
	defb 000h,000h,0adh,074h,041h,073h,0a2h,075h,0d1h,075h,044h,073h,044h,073h,02fh,073h	; b252  ...tAs.u.uDsDs/s
	defb 032h,073h,0b4h,075h,000h,000h,092h,074h,037h,076h,06bh,076h,06eh,076h,08ah,073h	; b262  2s.u...t7vkvnv.s
	defb 0c4h,076h,02eh,076h,000h,000h,000h,000h,05bh,077h,019h,078h,000h,000h,000h,000h	; b272  .v.v....[w.x....
	defb 0b0h,074h,0bfh,078h,000h,000h,021h,078h,000h,000h,055h,078h,067h,078h,000h,000h	; b282  .t.x..!x..Uxgx..
	defb 000h,000h,000h,000h,000h,000h,0fah,077h,0b3h,074h,05eh,077h,000h,000h,000h,000h	; b292  .......w.t^w....
	defb 000h,000h,093h,078h,0aah,078h,000h,000h,0b6h,074h,061h,077h,0c6h,078h,047h,078h	; b2a2  ...x.x...taw.xGx
	defb 000h,000h,000h,000h,000h,000h,000h,000h,03eh,078h,000h,000h,000h,000h,000h,000h	; b2b2  ........>x......
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; b2c2  ................
	defb 000h,000h,000h,000h,000h,000h,008h,079h,073h,079h,0dbh,078h,0deh,078h,000h,000h	; b2d2  .......ysy.x.x..
	defb 00dh,079h,026h,079h,080h,079h,078h,079h,000h,000h,064h,079h,000h,000h,03ch,098h	; b2e2  .y&y.yxy..dy..<.
	defb 04fh,098h,07fh,098h,05bh,098h,018h,099h,0a1h,098h,01eh,099h,06ch,098h,063h,098h	; b2f2  O...[.......l.c.
	defb 0b2h,098h	; b302

; ----------------------------------------------------------------------
; DATOS menus_tablas: Los menus: las rutinas de las opciones de cada menu
;   (0xB304: registros con su longitud delante, 129 menus por 0xFA1A), las
;   ayudas de cada menu (0xB423 y 0xB43A, por tecla_ayuda: menu, cuantos y
;   avisos) y las teclas con rutina de algunos menus (0xB48F: menu, tecla y
;   rutina, 3 bytes, hasta 0xB4E0)
;   0xb304..0xb4e0  (476 bytes)
DATA_menus_tablas:
	defb 00ah,0ech,070h,045h,070h,0cch,070h,061h,070h,0cch,070h,000h,000h,000h,006h,07eh	; b304  ..pEp.pap.p....~
	defb 071h,084h,071h,089h,071h,004h,084h,071h,089h,071h,000h,000h,000h,000h,000h,00ah	; b314  q.q.q..q.q......
	defb 06ah,04ch,008h,079h,03ch,098h,0d1h,071h,031h,070h,000h,004h,0f3h,071h,0ffh,071h	; b324  jL.y<..q1p...q.q
	defb 002h,0ffh,071h,000h,004h,008h,072h,04dh,072h,002h,04dh,072h,000h,002h,076h,072h	; b334  ..q...rMr.Mr..vr
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,004h	; b344  ................
	defb 055h,073h,01bh,073h,000h,000h,002h,01bh,073h,000h,000h,000h,008h,08ah,073h,03eh	; b354  Us.s....s.....s>
	defb 078h,04eh,073h,086h,072h,000h,000h,000h,000h,000h,000h,002h,0fah,077h,002h,0bfh	; b364  xNs.r........w..
	defb 078h,002h,0a5h,074h,000h,000h,000h,000h,002h,020h,073h,004h,0a2h,075h,032h,073h	; b374  x..t..... s..u2s
	defb 002h,032h,073h,000h,004h,0a9h,075h,0b4h,075h,002h,0b4h,075h,004h,032h,073h,041h	; b384  .2s...u.u..u.2sA
	defb 073h,004h,0b4h,075h,044h,073h,000h,000h,002h,028h,076h,012h,0c4h,076h,0b0h,074h	; b394  s..uDs...(v..v.t
	defb 09fh,074h,0b0h,074h,0b0h,074h,0b0h,074h,0b0h,074h,06eh,076h,06bh,076h,002h,0b0h	; b3a4  .t.t.t.t.tnvkv..
	defb 074h,002h,0b0h,074h,000h,000h,008h,0b0h,074h,06eh,076h,06bh,076h,0b0h,074h,000h	; b3b4  t..t....tnvkv.t.
	defb 000h,002h,004h,078h,000h,000h,000h,002h,05bh,077h,002h,092h,074h,000h,002h,047h	; b3c4  ...x....[w..t..G
	defb 078h,000h,000h,002h,07eh,078h,000h,000h,000h,000h,000h,002h,05eh,077h,002h,02fh	; b3d4  x...~x......^w./
	defb 073h,000h,000h,000h,000h,000h,000h,002h,061h,077h,002h,047h,078h,002h,093h,078h	; b3e4  s.......aw.Gx..x
	defb 002h,02fh,073h,000h,000h,000h,000h,002h,01bh,073h,000h,000h,000h,000h,000h,000h	; b3f4  ./s......s......
	defb 000h,000h,000h,000h,000h,000h,000h,000h,00ah,064h,079h,0dbh,078h,00dh,079h,0deh	; b404  .........dy.x.y.
	defb 078h,0cch,071h,000h,002h,005h,04dh,002h,002h,079h,000h,000h,002h,042h,079h,007h	; b414  x.q...M..y...By.
	defb 002h,034h,043h,008h,004h,039h,050h,05ch,064h,00bh,001h,048h,00dh,001h,056h,00eh	; b424  .4C..9P\d..H..V.
	defb 002h,08dh,08eh,00fh,001h,08ch,010h,003h,01bh,003h,01ch,003h,01dh,004h,011h,001h	; b434  ................
	defb 01bh,002h,012h,001h,01bh,001h,015h,002h,01dh,001h,01fh,001h,016h,001h,01ch,001h	; b444  ................
	defb 017h,005h,01eh,001h,01eh,002h,01eh,003h,01eh,004h,01eh,005h,018h,004h,01ch,002h	; b454  ................
	defb 01dh,003h,01eh,006h,01fh,007h,019h,001h,01dh,002h,01ah,005h,01fh,002h,01fh,003h	; b464  ................
	defb 01fh,004h,01fh,005h,01fh,006h,01bh,001h,022h,001h,01ch,003h,022h,003h,022h,004h	; b474  ........"...".".
	defb 022h,006h,01dh,001h,022h,007h,01eh,001h,022h,002h,01fh,001h,022h,005h,015h,058h	; b484  "..."..."..."..X
	defb 072h,017h,0d4h,072h,01ah,0feh,072h,032h,047h,07ah,033h,047h,07ah,036h,07eh,07ah	; b494  r..r..r2Gz3Gz6~z
	defb 037h,081h,07ah,03fh,04dh,07ah,040h,050h,07ah,041h,053h,07ah,044h,067h,07ah,045h	; b4a4  7.z?Mz@PzASzDgzE
	defb 087h,07ah,046h,087h,07ah,049h,06ah,07ah,04ch,0d0h,078h,04dh,08ah,07ah,051h,099h	; b4b4  .zF.zIjzL.xM.zQ.
	defb 07ah,053h,093h,07ah,055h,06dh,07ah,05bh,096h,07ah,05dh,0d0h,078h,062h,070h,07ah	; b4c4  zS.zUmz[.z].xbpz
	defb 063h,087h,07ah,065h,0d0h,078h,085h,05bh,079h,08ch,04dh,09ch	; b4d4  c.ze.x.[y.M.

; ----------------------------------------------------------------------
; DATOS textos_trozos: Los trozos de texto que se repiten (registros con su
;   longitud delante: ゲーム, をつくる, しゅるい, スクロール...), metidos en los textos con un
;   4 y su numero (texto_arma, 0x7EBB)
;   0xb4e0..0xb5d3  (243 bytes)
DATA_textos_trozos:
	defb 004h,0b9h,0deh,02dh,0d1h,004h,086h,0e2h,098h,0f9h,004h,09ch,08dh,0f9h,092h,005h	; b4e0  ...-............
	defb 0bdh,0b8h,0dbh,02dh,0d9h,005h,0bdh,0c3h,02dh,0bch,0deh,005h,09ch,0deh,0ech,0deh	; b4f0  ...-....-.......
	defb 0fdh,008h,09ch,0deh,0e4h,0deh,093h,0e3h,097h,0e6h,004h,0eah,092h,099h,092h,005h	; b500  ................
	defb 0b7h,0ach,0d7h,0b8h,0c0h,009h,091h,092h,0e3h,086h,0f4h,08fh,0e2h,099h,0f9h,005h	; b510  ................
	defb 0e6h,093h,09ah,0deh,098h,000h,007h,0bdh,0cdh,0dfh,02dh,0bdh,0b7h,02dh,006h,0d8h	; b520  ..........-..-..
	defb 0c0h,02dh,0ddh,0b7h,02dh,008h,0c0h,0b2h,0d9h,0cah,0dfh,0c0h,02dh,0ddh,006h,086h	; b530  .-..-.......-...
	defb 0eah,092h,0e1h,09dh,0f9h,007h,086h,0eah,0fdh,0e3h,0fdh,09dh,0f9h,007h,0e5h,0e6h	; b540  ................
	defb 086h,09ch,0efh,09dh,096h,008h,0e4h,0deh,0fah,0e6h,09ch,0efh,09dh,096h,007h,0e4h	; b550  ................
	defb 0deh,093h,09ch,0efh,09dh,096h,009h,095h,0e4h,086h,0e0h,0deh,09ch,0efh,09dh,096h	; b560  ................
	defb 009h,086h,097h,0f2h,0e3h,098h,0e0h,0deh,09bh,092h,009h,086h,092h,0fah,0e3h,098h	; b570  ................
	defb 0e0h,0deh,09bh,092h,000h,008h,092h,0fah,0e3h,098h,0e0h,0deh,09bh,092h,006h,009h	; b580  ................
	defb 00bh,00ch,00ah,0b7h,02dh,007h,086h,094h,0f7h,0ebh,0deh,0efh,09dh,005h,0bch,0cch	; b590  ....-...........
	defb 0c4h,0b7h,02dh,006h,094h,0f7h,0ebh,0deh,0efh,09dh,009h,0b7h,02dh,0e3h,0deh,031h	; b5a0  ..-.........-..1
	defb 097h,0deh,08eh,093h,00bh,086h,09ch,0e3h,092h,09ch,0e3h,098h,0e0h,0deh,09bh,092h	; b5b0  ................
	defb 006h,05fh,05fh,0ebh,0deh,08eh,093h,00bh,0e5h,0fdh,096h,092h,0e3h,0deh,0e3h,097h	; b5c0  .__.............
	defb 0efh,09dh,096h	; b5d0

; ----------------------------------------------------------------------
; DATOS menus_textos: Los menus: titulo y opciones de cada uno (registros con
;   su longitud delante, numeros de texto de 0xB806), por menu_pinta (0x7E0F)
;   0xb5d3..0xb755  (386 bytes)
DATA_menus_textos:
	defb 006h,083h,001h,002h,003h,004h,005h,000h,000h,003h,084h,006h,007h,004h,085h,008h	; b5d3  ................
	defb 009h,00ah,003h,085h,009h,00ah,004h,08ah,01eh,01fh,020h,000h,000h,003h,08bh,00ch	; b5e3  .......... .....
	defb 00bh,000h,006h,08ch,021h,022h,023h,024h,010h,000h,000h,000h,000h,000h,000h,000h	; b5f3  ....!"#$........
	defb 000h,003h,0a3h,00bh,0a6h,005h,087h,00dh,00eh,00fh,010h,009h,088h,011h,011h,011h	; b603  ................
	defb 011h,011h,011h,011h,011h,000h,000h,004h,085h,019h,01ah,01bh,004h,021h,071h,072h	; b613  .............!qr
	defb 073h,005h,021h,074h,075h,073h,076h,005h,021h,077h,074h,075h,073h,008h,021h,078h	; b623  s.!tusv.!wtus.!x
	defb 079h,07ah,07bh,07ch,075h,076h,008h,021h,077h,078h,079h,07ah,07bh,07ch,07dh,000h	; b633  yz{|uv.!wxyz{|}.
	defb 000h,008h,022h,071h,05bh,080h,081h,082h,00fh,050h,000h,000h,000h,000h,000h,000h	; b643  .."q[....P......
	defb 000h,000h,005h,08ch,025h,026h,027h,010h,000h,000h,000h,000h,003h,090h,00dh,030h	; b653  ....%&'........0
	defb 000h,003h,08eh,02ch,02dh,003h,08fh,02eh,02fh,000h,000h,005h,091h,031h,032h,033h	; b663  ...,-.../....123
	defb 034h,003h,092h,035h,036h,000h,000h,000h,000h,000h,000h,000h,003h,093h,00bh,00ch	; b673  4..56...........
	defb 003h,094h,00bh,00ch,003h,095h,00bh,00ch,000h,000h,00ah,091h,037h,038h,039h,03ah	; b683  ............789:
	defb 03bh,03ch,03dh,03eh,03fh,004h,097h,041h,042h,043h,004h,098h,041h,042h,043h,006h	; b693  ;<=>?..ABC..ABC.
	defb 08dh,028h,029h,02ah,02bh,010h,000h,005h,091h,039h,03eh,03fh,046h,000h,000h,003h	; b6a3  .()*+....9>?F...
	defb 096h,00bh,040h,004h,092h,035h,036h,049h,000h,000h,000h,000h,008h,091h,044h,045h	; b6b3  ..@..56I......DE
	defb 039h,03eh,03fh,046h,047h,000h,000h,008h,091h,047h,03ah,03bh,03ch,03dh,04ah,046h	; b6c3  9>?FG....G:;<=JF
	defb 000h,000h,000h,000h,000h,003h,099h,04bh,04ch,000h,003h,096h,00bh,040h,000h,000h	; b6d3  .......KL....@..
	defb 000h,000h,008h,091h,03ah,03bh,03ch,03dh,04eh,03eh,046h,000h,000h,003h,096h,00bh	; b6e3  ....:;<=N>F.....
	defb 040h,000h,000h,000h,000h,000h,000h,000h,003h,09bh,00bh,04fh,000h,000h,000h,000h	; b6f3  @..........O....
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,006h,08ch,00dh,00eh,050h,00fh,010h	; b703  .............P..
	defb 000h,000h,000h,000h,000h,000h,003h,09fh,00bh,00ch,005h,0a0h,052h,053h,054h,055h	; b713  ............RSTU
	defb 000h,003h,09eh,028h,051h,000h,005h,08ch,056h,057h,058h,010h,000h,000h,003h,0a1h	; b723  ...(Q...VWX.....
	defb 059h,05ah,003h,0a2h,05bh,05ch,007h,08ch,05dh,05eh,05fh,060h,061h,010h,005h,088h	; b733  YZ..[\..]^_`a...
	defb 062h,063h,064h,065h,006h,088h,066h,066h,066h,066h,066h,006h,088h,06bh,06ch,06dh	; b743  bcde..fffff..klm
	defb 06eh,06fh	; b753

; ----------------------------------------------------------------------
; DATOS avisos_textos: Los avisos: sus lineas (registros con su longitud
;   delante, numeros de texto de 0xB806), por aviso_pinta (0x7D98)
;   0xb755..0xb806  (177 bytes)
DATA_avisos_textos:
	defb 001h,00dh,002h,086h,0b1h,002h,09ah,048h,002h,0a7h,0a8h,002h,0a9h,0aah,002h,0a5h	; b755  .......H........
	defb 0aah,002h,0afh,0aah,004h,067h,068h,069h,0aah,002h,0bah,0aah,002h,0b6h,0ach,000h	; b765  .....ghi........
	defb 002h,0dfh,0aah,002h,06ah,0aah,000h,001h,0a4h,000h,001h,0e8h,000h,002h,0abh,0ach	; b775  ....j...........
	defb 002h,0bbh,0aah,002h,0bch,0aah,000h,002h,0adh,0ach,002h,0aeh,0ach,002h,0b0h,0b1h	; b785  ................
	defb 002h,0b2h,0b3h,002h,089h,01dh,000h,002h,0b4h,0aah,002h,0b5h,0aah,000h,000h,001h	; b795  ................
	defb 0b7h,001h,0b8h,001h,0b9h,000h,000h,000h,000h,000h,000h,000h,004h,0c1h,0c2h,0c3h	; b7a5  ................
	defb 0c4h,003h,0c5h,0c6h,0c4h,000h,000h,004h,0c7h,0c8h,0c9h,0c4h,000h,002h,0cbh,0c4h	; b7b5  ................
	defb 001h,0cch,003h,0ceh,0cfh,0c4h,003h,0d2h,0d3h,0c4h,002h,0d5h,0c4h,003h,0d6h,0d7h	; b7c5  ................
	defb 0c4h,000h,000h,002h,0dah,0c4h,005h,0dch,0ddh,0deh,0e0h,0c4h,004h,0dch,0deh,0e0h	; b7d5  ................
	defb 0c4h,003h,0e1h,0e2h,0c4h,003h,0dch,0ddh,0c4h,002h,0dch,0c4h,003h,0e3h,0d6h,0c4h	; b7e5  ................
	defb 003h,0e4h,0d3h,0c4h,003h,0e5h,0d3h,0c4h,004h,0e6h,0e4h,0d3h,0c4h,003h,0e4h,0e7h	; b7f5  ................
	defb 0c4h	; b805

; ----------------------------------------------------------------------
; DATOS textos: Los textos de los menus y avisos (registros con su longitud
;   delante, en kana de la fuente japonesa del MSX; un 4 y un numero meten un
;   trozo de 0xB4E0)
;   0xb806..0xbff1  (2027 bytes)
DATA_textos:
	defb 008h,004h,001h,0e3h,0deh,091h,09fh,0ech,0deh,004h,004h,001h,004h,002h,006h,004h	; b806  ................
	defb 001h,086h,0e5h,095h,09dh,007h,004h,001h,086h,0f6h,0f0h,09ah,0f1h,009h,004h,001h	; b816  ................
	defb 086h,0eeh,09fh,0deh,0fdh,09dh,0f9h,008h,09eh,0fdh,0e4h,093h,09ch,097h,004h,001h	; b826  ................
	defb 007h,0f2h,092h,0fbh,09ch,097h,004h,001h,003h,031h,004h,003h,003h,033h,004h,003h	; b836  .........1...3..
	defb 004h,004h,004h,09dh,0f9h,003h,092h,092h,094h,002h,0eah,092h,008h,091h,0e0h,0f7h	; b846  ................
	defb 09ch,098h,0e2h,098h,0f9h,003h,0e5h,095h,09dh,002h,099h,09dh,003h,095h,0fch,0f8h	; b856  ................
	defb 002h,004h,005h,000h,000h,000h,000h,000h,000h,000h,006h,0e0h,0deh,092h,031h,0f2h	; b866  ..............1.
	defb 0fdh,006h,0e0h,0deh,092h,032h,0f2h,0fdh,006h,0e0h,0deh,092h,033h,0f2h,0fdh,007h	; b876  .....2......3...
	defb 0bdh,0c0h,02dh,0c4h,0e9h,0e4h,097h,005h,004h,020h,09ah,0deh,0e4h,00fh,004h,006h	; b886  ..-...... ......
	defb 0e9h,093h,09ah,0deh,097h,0e3h,0deh,004h,004h,09dh,0f9h,009h,00bh,007h,004h,007h	; b896  ................
	defb 004h,004h,09dh,0f9h,00bh,007h,004h,007h,004h,004h,09dh,0f9h,009h,004h,004h,008h	; b8a6  ................
	defb 004h,002h,004h,004h,009h,004h,002h,004h,095h,0e4h,004h,002h,009h,0bdh,0c4h,02dh	; b8b6  ...............-
	defb 0d8h,02dh,086h,097h,0f2h,0f9h,00dh,004h,009h,0e9h,093h,09ah,0deh,097h,096h,0e0h	; b8c6  .-..............
	defb 086h,097h,0f2h,0f9h,008h,0c0h,0b2h,0cfh,02dh,086h,097h,0f2h,0f9h,00ch,004h,001h	; b8d6  ........-.......
	defb 0e1h,08dh,093h,0e9h,095h,0e4h,086h,097h,0f2h,0f9h,002h,004h,006h,006h,004h,006h	; b8e6  ................
	defb 0e9h,0ech,0deh,097h,003h,091h,092h,0e3h,007h,091h,092h,0e3h,0e9h,0ech,0deh,097h	; b8f6  ................
	defb 007h,09dh,0edh,0deh,0e3h,0e9h,004h,00ah,009h,004h,006h,0f6h,0f8h,0f6h,0fch,092h	; b906  ................
	defb 004h,00ah,007h,004h,006h,0f6h,0f8h,0e2h,0f6h,092h,007h,004h,006h,0f6h,0f8h,0f6h	; b916  ................
	defb 0fch,092h,00ah,0eeh,096h,0e9h,004h,009h,0e4h,095h,0e5h,09ch,0deh,002h,009h,00bh	; b926  ................
	defb 002h,00ch,00ah,004h,009h,00bh,00ch,00ah,007h,038h,0e2h,0e9h,0eeh,093h,09ah,093h	; b936  .........8......
	defb 003h,0e4h,0efh,0f9h,00bh,0eah,0fdh,0e0h,092h,096h,0deh,0fch,0e6h,0e3h,0deh,0f9h	; b946  ................
	defb 00ch,097h,0e4h,0deh,093h,0e9h,093h,094h,086h,093h,09ah,0deh,098h,010h,038h,0eeh	; b956  ..............8.
	defb 093h,09ah,093h,0e9h,092h,09dh,0deh,0fah,096h,0edh,093h,09ah,0deh,098h,006h,0ech	; b966  ................
	defb 097h,09fh,098h,004h,00bh,001h,009h,001h,00bh,001h,00ch,001h,00ah,008h,004h,006h	; b976  ................
	defb 0e6h,0e1h,096h,09dh,0deh,098h,00ah,004h,006h,096h,0f7h,0e4h,095h,09bh,0deh,096h	; b986  ................
	defb 0f9h,002h,004h,020h,005h,09dh,0eah,0deh,0f4h,098h,005h,0e3h,097h,0e4h,0deh,0e6h	; b996  ... ............
	defb 004h,0f5h,08fh,098h,0f8h,000h,000h,006h,093h,09ah,0deh,096h,0e5h,092h,00eh,0f3h	; b9a6  ................
	defb 098h,0e3h,097h,0e1h,0e6h,0f1h,096h,08fh,0e3h,093h,09ah,0deh,098h,003h,05fh,004h	; b9b6  .............._.
	defb 020h,003h,097h,094h,0f9h,00eh,004h,006h,0e9h,0f1h,092h,0e3h,092h,0f9h,0eeh,093h	; b9c6   ...............
	defb 09ah,093h,004h,00bh,008h,054h,052h,031h,0efh,0e0h,0eah,004h,00dh,008h,054h,052h	; b9d6  .....TR1......TR
	defb 032h,0efh,0e0h,0eah,004h,00eh,000h,009h,004h,006h,0e6h,0f1h,096h,08fh,0e3h,093h	; b9e6  2...............
	defb 0e2h,000h,006h,0bah,0cbh,0dfh,02dh,09dh,0f9h,003h,09fh,0e9h,0e0h,005h,031h,036h	; b9f6  ......-.......16
	defb 058h,031h,036h,005h,033h,032h,058h,031h,036h,005h,031h,036h,058h,033h,032h,005h	; ba06  X16.32X16.16X32.
	defb 033h,032h,058h,033h,032h,009h,091h,0e0h,0f7h,09ch,098h,095h,0e4h,004h,002h,006h	; ba16  32X32...........
	defb 095h,0e4h,086h,0e5h,095h,09dh,005h,095h,0e4h,086h,099h,09dh,005h,0d2h,0dbh,0c3h	; ba26  ................
	defb 0deh,0a8h,005h,09ah,093h,096h,095h,0fdh,005h,0bbh,0ddh,0cch,0dfh,0d9h,005h,09bh	; ba36  ................
	defb 08fh,097h,08eh,098h,003h,0ech,0f2h,0fdh,005h,095h,0e4h,086h,097h,098h,004h,0c3h	; ba46  ................
	defb 0ddh,0ceh,0dfh,005h,0d8h,0cbh,0dfh,02dh,0c4h,004h,0bah,02dh,0c4h,0deh,004h,099h	; ba56  .......-...-....
	defb 08fh,09ah,0fdh,004h,0b6h,0ddh,0b6h,0ddh,005h,0e4h,0e2h,099h,0deh,097h,004h,0c0h	; ba66  ................
	defb 0b2h,0c4h,0d9h,003h,0eah,0deh,0fdh,008h,004h,001h,096h,0deh,091h,0f8h,0efh,09dh	; ba76  ................
	defb 00fh,099h,09bh,0e5h,092h,0e5h,0f7h,0eah,0deh,020h,095h,0fch,0f8h,0b7h,02dh,086h	; ba86  ......... ....-.
	defb 009h,099h,09ch,0e3h,0f3h,0f6h,099h,0fah,0eah,0deh,009h,004h,009h,096h,0deh,091h	; ba96  ................
	defb 0f8h,0efh,09eh,0fdh,007h,093h,09ah,0deh,097h,0e9h,095h,0e4h,005h,0d2h,0b6h,0c6h	; baa6  ................
	defb 0afh,0b8h,005h,0eah,0deh,098h,0eah,0e2h,002h,053h,046h,004h,099h,092h,0eeh,093h	; bab6  .........SF.....
	defb 000h,00ch,0c4h,0deh,0afh,0c4h,0e0h,0fdh,092h,0e3h,0deh,0e2h,098h,0f9h,00eh,038h	; bac6  ...............8
	defb 058h,038h,0e0h,0fdh,092h,0e3h,0deh,0bah,0cbh,0dfh,0b0h,09dh,0f9h,009h,004h,008h	; bad6  X8..............
	defb 086h,0e7h,0f8h,0e2h,0ech,0deh,09dh,004h,004h,00fh,004h,010h,006h,004h,00fh,086h	; bae6  ................
	defb 0e5h,095h,09dh,00dh,004h,004h,09dh,0f9h,0eah,0fdh,092h,086h,09ah,0e3h,092h,09dh	; baf6  ................
	defb 0f9h,007h,004h,008h,086h,094h,0f7h,0ech,0deh,005h,096h,0edh,0deh,004h,010h,005h	; bb06  ................
	defb 0e2h,093h,0fbh,004h,010h,009h,031h,030h,0e3h,0fdh,0e9h,004h,00fh,004h,010h,009h	; bb16  ......10........
	defb 032h,030h,0e3h,0fdh,0e9h,004h,00fh,004h,010h,009h,033h,030h,0e3h,0fdh,0e9h,004h	; bb26  20........30....
	defb 00fh,004h,010h,006h,004h,00fh,086h,0e5h,095h,09dh,000h,000h,005h,09bh,0f5h,093h	; bb36  ................
	defb 004h,011h,008h,09ch,0deh,08eh,093h,099h,0deh,004h,011h,00ah,0cah,0dfh,0c0h,02dh	; bb46  ...............-
	defb 0ddh,086h,09dh,0deh,0f7h,09dh,00ah,004h,001h,0d7h,0ddh,0c4h,0deh,0e3h,0deh,004h	; bb56  ................
	defb 012h,008h,004h,001h,0e9h,004h,003h,0eah,004h,013h,005h,004h,008h,0eah,004h,013h	; bb66  ................
	defb 005h,004h,006h,0eah,004h,021h,00fh,004h,005h,0e9h,0bdh,0c4h,02dh,0d8h,02dh,086h	; bb76  .....!......-.-.
	defb 097h,0f2h,0efh,09ch,08eh,093h,002h,004h,013h,00fh,004h,009h,096h,0deh,0e3h,0deh	; bb86  ................
	defb 0f9h,0e9h,0eah,092h,0e2h,0e3h,0deh,09dh,096h,005h,004h,004h,0eah,004h,013h,008h	; bb96  ................
	defb 096h,098h,0e6h,0fdh,09ch,0efh,09dh,096h,002h,004h,012h,00eh,0e4h,0deh,0e9h,004h	; bba6  ................
	defb 009h,0e6h,0e2h,092h,0e3h,097h,0f2h,0efh,09dh,096h,00bh,0e4h,0deh,0fdh,0e5h,0ech	; bbb6  ................
	defb 0deh,097h,0e3h,0deh,09dh,096h,00bh,0e4h,0deh,0fdh,0e5h,091h,092h,0e3h,0e3h,0deh	; bbc6  ................
	defb 09dh,096h,007h,093h,09ah,0deh,097h,0eah,004h,014h,009h,093h,09ah,0deh,097h,096h	; bbd6  ................
	defb 0e0h,0eah,004h,013h,00ch,096h,0deh,0f2h,0fdh,0e9h,0eah,09ch,0e3h,0deh,0eah,004h	; bbe6  ................
	defb 014h,006h,093h,09ah,0deh,098h,004h,015h,009h,0f4h,0f7h,0fah,0e0h,0e4h,097h,0e9h	; bbf6  ................
	defb 004h,015h,010h,0f4h,0f7h,0fah,0e0h,0e4h,097h,0e9h,004h,009h,086h,0e0h,0deh,09ch	; bc06  ................
	defb 0efh,09dh,096h,011h,097h,094h,0f9h,0efh,0e3h,0deh,0e9h,09ch,0deh,096h,0fdh,086h	; bc16  ................
	defb 097h,0f2h,0efh,09dh,096h,00bh,0e4h,095h,09bh,0deh,096h,0f8h,096h,0e0h,0eah,004h	; bc26  ................
	defb 013h,00ah,0e1h,096h,09dh,0deh,097h,096h,0e0h,0eah,004h,013h,010h,0ech,0deh,097h	; bc36  ................
	defb 0eah,0e4h,0deh,0e9h,0b7h,02dh,0e3h,0deh,0e3h,0deh,0efh,09dh,096h,010h,0c0h,0b2h	; bc46  .....-..........
	defb 0cfh,02dh,0eah,0e5h,0fdh,0ebh,0deh,08eh,093h,0e6h,09ch,0efh,09dh,096h,000h,000h	; bc56  .-..............
	defb 000h,00eh,0e2h,097h,0deh,0e9h,0e4h,0deh,0fah,086h,0e2h,098h,0f8h,0efh,09dh,096h	; bc66  ................
	defb 00fh,0f1h,097h,0e6h,0f6h,08fh,0e3h,096h,0e0h,0e1h,086h,096h,094h,0efh,09dh,096h	; bc76  ................
	defb 014h,095h,095h,097h,09bh,086h,097h,0f2h,0e3h,098h,0e0h,0deh,09bh,092h,07bh,0d6h	; bc86  ..............{.
	defb 0bah,058h,0c0h,0c3h,07dh,00dh,0e4h,0deh,0fdh,0e5h,095h,0e4h,086h,0e2h,098h,0f8h	; bc96  .X..}...........
	defb 0efh,09dh,096h,00ch,0e4h,0deh,0e9h,0f6h,093h,0e6h,0e2h,098h,0f8h,0efh,09dh,096h	; bca6  ................
	defb 00fh,0e3h,0deh,0e3h,098h,0f9h,096h,092h,09dh,093h,0eah,0ech,094h,0efh,09dh,096h	; bcb6  ................
	defb 009h,0bdh,0c0h,02dh,0c4h,0e9h,095h,0e4h,004h,01fh,00dh,09ah,0e9h,004h,005h,0eah	; bcc6  ...-............
	defb 09dh,0e3h,0deh,0e6h,091h,0f8h,0efh,09dh,00ah,05fh,05fh,05fh,05fh,030h,0e3h,0fdh	; bcd6  .........____0..
	defb 09ah,0deh,0e4h,005h,0e5h,0efh,094h,004h,017h,008h,05fh,05fh,05fh,05fh,05fh,05fh	; bce6  ..........______
	defb 05fh,05fh,00bh,0d2h,0d3h,0d8h,02dh,096h,0deh,0e0h,0f8h,0efh,09eh,0fdh,00bh,004h	; bcf6  __....-.........
	defb 00dh,086h,095h,09ch,0e3h,098h,0e0h,0deh,09bh,092h,00dh,004h,009h,096h,0deh,0e3h	; bd06  ................
	defb 0deh,0f9h,0eah,0deh,09ch,08eh,004h,016h,00fh,004h,00dh,0e3h,0deh,096h,0deh,0f2h	; bd16  ................
	defb 0fdh,096h,0deh,096h,0fch,0f8h,0efh,09dh,006h,097h,0e4h,0deh,093h,004h,016h,006h	; bd26  ................
	defb 0eah,0deh,09ch,08eh,004h,016h,011h,09ah,0e9h,004h,009h,0eah,09dh,0e3h,0deh,0e6h	; bd36  ................
	defb 0e2h,096h,0fch,0fah,0e3h,092h,0efh,09dh,002h,004h,021h,004h,05fh,05fh,096h,092h	; bd46  ..........!.__..
	defb 00dh,09ah,0e9h,004h,009h,0eah,0e5h,0fdh,0e3h,0fdh,0e3h,0deh,09dh,096h,006h,05fh	; bd56  ..............._
	defb 05fh,05fh,030h,0e3h,0fdh,011h,095h,0e5h,09ch,0deh,0e5h,0efh,094h,096h,0deh,09dh	; bd66  __0.............
	defb 0e3h,0deh,0e6h,091h,0f8h,0efh,09dh,00ch,0f3h,093h,0e4h,093h,0fbh,098h,0e3h,0deh	; bd76  ................
	defb 097h,0efh,09eh,0fdh,008h,0bdh,0cbh,0dfh,02dh,0c4h,0deh,004h,016h,00fh,004h,001h	; bd86  ........-.......
	defb 0b5h,02dh,0cah,0deh,02dh,0e9h,0e4h,097h,0e9h,095h,0e4h,004h,016h,00eh,0e4h,0deh	; bd96  .-..-...........
	defb 0e9h,004h,009h,096h,0f7h,0e3h,0deh,0e3h,097h,0efh,09dh,096h,00fh,0e4h,0deh,0e9h	; bda6  ................
	defb 004h,009h,096h,0f7h,0bah,0cbh,0dfh,02dh,09ch,0efh,09dh,096h,009h,004h,001h,096h	; bdb6  .......-........
	defb 0deh,091h,0f8h,0efh,09eh,0fdh,00ah,093h,0efh,098h,0f6h,0f0h,09ah,0f2h,0efh,09eh	; bdc6  ................
	defb 0fdh,011h,0eeh,09fh,0deh,0fdh,096h,0deh,093h,0efh,098h,0e3h,0deh,097h,0e3h,092h	; bdd6  ................
	defb 0efh,09eh,0fdh,000h,000h,000h,000h,014h,004h,009h,096h,0deh,0e3h,0deh,0f9h,0eah	; bde6  ................
	defb 0deh,09ch,08eh,0eah,0a2h,0a3h,0e9h,0e5h,096h,0e3h,0deh,09dh,00fh,004h,01ah,0e3h	; bdf6  ................
	defb 0deh,0a2h,0e4h,0a3h,086h,093h,09ah,0deh,096h,09ch,0efh,09dh,013h,004h,00dh,0e3h	; be06  ................
	defb 0deh,09fh,0fah,09fh,0deh,0fah,0e9h,0eah,0deh,09ch,08eh,086h,097h,0f2h,0efh,09dh	; be16  ................
	defb 00fh,004h,00eh,0e3h,0deh,0d2h,0c6h,0adh,02dh,0e6h,0f3h,0e4h,0deh,0f8h,0efh,09dh	; be26  ........-.......
	defb 013h,009h,00bh,0b7h,02dh,0e3h,0deh,0bdh,0cbh,0dfh,02dh,0c4h,0deh,096h,0deh,096h	; be36  ....-.....-.....
	defb 0fch,0f8h,0efh,09dh,011h,00ch,00ah,0b7h,02dh,0e3h,0deh,097h,09bh,0deh,0f0h,096h	; be46  ........-.......
	defb 0deh,096h,0fch,0f8h,0efh,09dh,00dh,004h,01ah,0e3h,0deh,02bh,096h,0deh,093h,09ah	; be56  ...........+....
	defb 0deh,097h,0efh,09dh,010h,004h,00dh,0e3h,0deh,0e2h,093h,096h,0e3h,0fdh,096h,0deh	; be66  ................
	defb 097h,0efh,0f8h,0efh,09dh,013h,0e4h,0f8h,099h,09ch,0b7h,02dh,0e3h,0deh,031h,0e2h	; be76  ...........-..1.
	defb 0efh,094h,0e6h,0f3h,0e4h,0deh,0f8h,0efh,09dh,000h,00dh,004h,01ah,0e3h,0deh,02bh	; be86  ...............+
	defb 086h,093h,09ah,0deh,096h,09ch,0efh,09dh,00ch,004h,00dh,0e3h,0deh,095h,0e4h,096h	; be96  ................
	defb 0deh,097h,099h,0efh,09dh,000h,013h,0ech,0f2h,0fdh,0eah,009h,00bh,0b7h,02dh,0e3h	; bea6  ..............-.
	defb 0deh,095h,0fdh,0e3h,092h,086h,097h,0f2h,0efh,09dh,00fh,004h,00dh,0e3h,0deh,095h	; beb6  ................
	defb 0fdh,096h,0deh,098h,097h,09ah,0deh,093h,004h,01bh,000h,000h,009h,092h,0fbh,086h	; bec6  ................
	defb 09ch,0e3h,092h,09ch,0efh,09dh,00ch,004h,00dh,0e3h,0deh,09ch,0deh,08fh,09ah,093h	; bed6  ................
	defb 09ch,0efh,09dh,000h,015h,0bah,0cbh,0dfh,02dh,004h,01ch,0e4h,004h,01ah,0e3h,0deh	; bee6  ........-.......
	defb 004h,00fh,086h,0bah,0cbh,0dfh,02dh,09ch,0efh,09dh,00bh,004h,00dh,0e4h,004h,01ah	; bef6  ......-.........
	defb 0e3h,0deh,096h,097h,0efh,09dh,013h,004h,01ch,0e4h,004h,01ah,0e3h,0deh,02bh,086h	; bf06  ..............+.
	defb 0eah,0f4h,098h,093h,09ah,0deh,096h,09ch,0efh,09dh,000h,000h,017h,009h,00bh,0b7h	; bf16  ................
	defb 02dh,0e3h,0deh,09eh,0deh,0fdh,09ah,0deh,0e9h,004h,008h,086h,0ebh,08eh,093h,09ch	; bf26  -...............
	defb 0deh,09ch,0efh,09dh,000h,010h,004h,00dh,0e4h,004h,01ah,0e3h,0deh,004h,00fh,086h	; bf36  ................
	defb 0eah,092h,0e1h,09ch,0efh,09dh,00ch,004h,01ch,0e4h,004h,01ah,0e3h,0deh,004h,00fh	; bf46  ................
	defb 086h,004h,01dh,00dh,004h,004h,049h,04eh,053h,004h,01eh,0e2h,092h,096h,09ch,0efh	; bf56  ......INS.......
	defb 09dh,009h,095h,0e4h,096h,0deh,091h,0f8h,0efh,09eh,0fdh,00bh,004h,004h,044h,045h	; bf66  ..............DE
	defb 04ch,004h,01eh,0e4h,0f8h,0efh,09dh,00fh,004h,01ch,0e4h,004h,01ah,0e3h,0deh,0e5h	; bf76  L...............
	defb 095h,09dh,004h,00fh,086h,004h,01dh,00ch,004h,00dh,0e4h,004h,01ah,0e3h,0deh,0e5h	; bf86  ................
	defb 095h,09ch,0efh,09dh,00dh,004h,01ch,0e4h,004h,01ah,0e3h,0deh,0eeh,093h,09ah,093h	; bf96  ................
	defb 004h,01bh,00eh,004h,01ch,0e4h,004h,01ah,0e3h,0deh,0eeh,093h,09ah,093h,086h,004h	; bfa6  ................
	defb 01dh,00dh,004h,01ah,0e3h,0deh,0f3h,0e4h,0e9h,0eeh,093h,09ah,093h,004h,01bh,00ch	; bfb6  ................
	defb 004h,01ah,0e3h,0deh,0cah,0dfh,0c0h,02dh,0ddh,086h,004h,01dh,018h,004h,00dh,0e4h	; bfc6  .......-........
	defb 004h,01ah,0e3h,0deh,031h,0c4h,0deh,0afh,0c4h,0cah,0dfh,0c0h,02dh,0ddh,086h,09dh	; bfd6  ....1.......-...
	defb 0deh,0f7h,09ch,0efh,09dh,005h,0e5h,0efh,094h,004h,01fh	; bfe6  ...........

; ----------------------------------------------------------------------
; DATOS relleno: 15 bytes 0xFF hasta el final del cartucho: nadie los lee
;   0xbff1..0xc000  (15 bytes)
DATA_relleno:
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; bff1  ...............

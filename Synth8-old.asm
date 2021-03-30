; SYNTH8 SOUNDS CODE - 16 Mar 2021
; hack for Heathkit ET-3400 Audio Setup
; user RAM = 196 + 255 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; using PIA addr 8000 (not 0400)
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second
; using edited subroutines IRQ, PARAM7, SYNTH8, CALCOS
; PARAM7 normally plays SYNTH8 then IRQ2->SYNTH4
; as well as other subroutines: SYNTH8 partial output for other SYNTHs
; source of ORGAN (expecting pitch/length vars ?)
; working, constant buzz saw with pitch change via PIA B (low frequencies)
; PIA1 refactor, PIA2, messy
;
; SW demo :
; [1110 0101][1100 0011]
;
;*************************************;
; Main loop scratch memory reserves, ** PIA2 init/bra, org 0016 **
;*************************************;
0000 : nn                             ; set to 00 by ?
0002 : 00                             ;not used
; ./cont not used
0007 : 00                             ;not used
0008 : nn 00                          ; set to 00 by PARAM7 clr
;
000A : 00 00                          ;not used
000C : 00 00                          ;not used
000E : nn                             ; X changing [A7,9A,9B]
000F : nn                             ; X, <-- write?
0010 : 9B                             ; X
0011 : nn                             ; A changing, PIA1 B pitch
0012 : nn                             ; B count up 00-FF
0013 : 0F FB                          ; X
0015 : 7F                             ; A
; 0016 was write flood start for 13 addrs
0016 : 7F 40 02   clr X4002           ; clear(00) 4002h (set PIA2 PR/DDR port B in)
0019 : 86 04      ldaa  #$04          ; set CR bit 2 high for PIA2
001B : B7 40 03   staa X4003          ; store A in addr 4003 (PIA2 CR port B)
001E : 20 08      bra L0028           ; branch always to 0028
;
0020 : 00 00                          ;not used
0022 : nn                             ;end flood, PIA2 B store, adds an inner loop rhythm
;
0023 : 91 00                          ; B
0025 : FA 00                          ; B
0027 : DD                             ; B
;*************************************;
;INIT (POWER-ON) org 0016 for PIA2 init then bra to here
;*************************************;
0028 : 8E 01 FF   lds #$01FF          ; load SP with 01FFh
002B : CE 80 00	  ldx #$8000          ; load X with 8000h, PIA1 (DAC) addr
002E : 6F 02      clr $02,x           ; clear(00) addr X + 02h (set 8002 PIA1 PR/DDR port B in)
0030 : 86 FF		  ldaa	#$FF          ; load A with FFh (1111 1111)
0032 : A7 00		  staa	$00,x         ; store A in addr X + 00h (set 8000 PIA1 PR/DDR port A out)
0034 : 86 3C		  ldaa	#$3C          ; load A with 3Ch(0011 1100)
0036 : A7 01		  staa	$01,x         ; store A in addr X + 01h (8001 PIA1 CR port A)
0038 : 86 37      ldaa  #$37          ; load A with 37h(0011 0111)
003A : A7 03      staa  $03,x         ; store A in addr X + 03h (8003 PIA1 CR port B) 
003C : 01         nop                 ;
;*************************************;
;IRQ - reset, MAIN LOOP                
;*************************************;
003D : F6 40 02   ldab  #$4002        ;load B with PIA2 B
0040 : B6 80 02		ldaa	#$8002        ;load A with value from PIA1 B
0043 : D7 22      stab  $22           ;store B in addr 22 - WIP
;*************************************;
;PARAM7 - modified: 
; rem'd beq & jmp to IRQ2/SYNTH4
;*************************************;
0045 : 7F 00 08   clr $0008           ;clear addr 0008
0048 : 97 11      staa  $11           ;store A in addr 11
004A : CE 00 9A   ldx #$009A          ;load X with 009A (orig FDAA)
;LOOP1
004D : A6 00      ldaa  $00,x         ;load A with X + 00
004F : 7A 00 11   dec $0011           ;decr addr 0011
0052 : 27 06      beq $005A           ;branch =0 GOTO1
0054 : 4C         inca                ;incr A
0055 : BD 00 80   jsr $0080           ;jump sub CALCOS
0058 : 20 F3      bra $004D           ;branch always LOOP1
;GOTO1
005A : 08         inx                 ;incr X
005B : DF 0F      stx $0F             ;store X in addr 0F
005D : BD 00 80   jsr $0080           ;jump sub CALCOS
0060 : DF 0D      stx $0D             ;store X in addr 0D
0062 : DE 0F      ldx $0F             ;load X with addr 0F
;LOOP2
0064 : A6 00      ldaa  $00,x         ;load A with addr X + 00h
0066 : 97 15      staa  $15           ;store A in addr 15
0068 : A6 01      ldaa  $01,x         ;load A with addr X + 01h
006A : EE 02      ldx $02,x           ;load X with addr X + 02h
006C : DF 13      stx $13             ;store X in addr 13
006E : BD 01 19   jsr $0119           ;jump sub SYNTH8-GOTO3
0071 : DE 0F      ldx $0F             ;load X with addr 0F
0073 : 08         inx                 ;incr X
0074 : 08         inx                 ;incr X
0075 : 08         inx                 ;incr X
0076 : 08         inx                 ;incr X
0077 : DF 0F      stx $0F             ;store X in addr 0F
0079 : 9C 0D      cpx $0D             ;compare X with addr 0D
007B : 26 E7      bne $0064           ;branch !=0 LOOP2
007D : 7E 00 3D   jmp $003D           ;jump to IRQ (orig IRQ2/SYNTH4)
;*************************************;
;CALCOS (calculate offset) - 0080
;*************************************;
0080 : DF 0D		  stx $0D             ; store X in 0D
0082 : 9B 0E		  adda	$0E           ; add A with value in 0E
0084 : 97 0E		  staa	$0E           ; store A in 0E
0086 : 24 05		  bcc	$00A2           ; branch Carry clear (+05) GOTO7
0088 : 7C 00 0D		inc	$000D           ; increment value in 000D
008B : DE 0D		  ldx	$0D             ; load X with addr 0D
;GOTO7
008D : 39		      rts                 ; return from subroutine
;*************************************;
;PARAM SYNTH FDB TABLE
;*************************************;
008E : 47 3f 37 30 29 23              ; load for SYNTH8
0094 : 1d 17 12 0d 08 04              ; 
009A : 0c 7f 1d 0f fb 7f 23 0f        ; load for PARAM7 (0f fb 7f)
00A2 : 15 fe 08 50 8b 88 3e 3f        ; 
;00AA :                               ;
; ~ not used
;00C4 :                               ;
;*************************************;
;SYNTH8 - modified org 0100
;*************************************;
0100 : 4A         deca                ;decr A
0101 : 81 0B      cmpa  #$0B          ;compare A to value 0Bh (0000 1011)
0103 : 23 01      bls $0106           ;branch if lower or same GOTO2
0105 : 4F         clra                ;
;GOTO2
0106 : CE 00 8E   ldx #$008E          ;load X with 008Eh (orig FE41)
0109 : BD 00 80   jsr $0080           ;jump sub to CALCOS
010C : A6 00      ldaa $00,x          ;load A with addr X + 00h
010E : CE FF FF   ldx #$FFFF          ;load X with FFFFh (1111 1111 1111 1111)
0111 : DF 13      stx $13             ;store X in addr 13
0113 : 8D 04      bsr $0119           ;branch to sub (+4) GOTO3
;LOOP3
0115 : 8D 2A      bsr $0141           ;branch to sub (+42) GOTO6
0117 : 20 FC      bra $0115           ;branch always LOOP3
;GOTO3 - entry point from PARAM7
0119 : CE 00 16   ldx #$0016          ;load X with 0016h <-- write flood origin here
;LOOP4
011C : 81 00      cmpa  #$00          ;compare A with value 00h (0000 0000)
011E : 27 15      beq $0135           ;branch =0 (+21) GOTO5
0120 : 81 03      cmpa  #$03          ;compare A with value 03h (0000 0011)
0122 : 27 09      beq $012D           ;branch =0 (+9) GOTO4
0124 : 01 01      nop nop             ;
0126 : 01 01      nop nop             ;
0128 : 08         inx                 ;incr X
0129 : 80 02      suba  #$02          ;subtract A - 02h into A
012B : 20 EF      bra $011C           ;branch always (-17) LOOP4
;GOTO4
012D : C6 91      ldab  #$91          ;load B with 91h (1001 0001)
012F : E7 00      stab $00,x          ;store B in addr X + 00h
0131 : 6F 01      clr $01,x           ;clear addr X + 01h
0133 : 08         inx                 ;incr X
0134 : 08         inx                 ;incr X
;GOTO5
0135 : C6 7E      ldab  #$7E          ;load B with 7Eh (0111 1110)
0137 : E7 00      stab  $00,x         ;store B in addr X + 00h
0139 : C6 FA      ldab  #$FA          ;load B with FAh (1111 1010)
013B : E7 00      stab  $00,x         ;store B in addr X + 00h <-- overwrites previous stab addr?
013D : C6 DD      ldab  #$DD          ;load B with DDh (1101 1101)
013F : E7 02      stab  $02,x         ;store B in addr X + 02h
;GOTO6
0141 : DE 13      ldx $13             ;load X with addr 13
0143 : 4F         clra                ;clear A
0144 : F6 00 12   ldab  $0012         ;load B with addr 0012
0147 : 5C         incb                ;incr B
0148 : D7 12      stab  $12           ;store B in addr 12
014A : D4 15      andb  $15           ;and B with addr 15 into B
014C : 54         lsrb                ;logical shift right B (0 -> b7 - b0 -> C)
014D : 89 00      adca #$00           ;add A + 00h + C into A (89 00) 99 22
014F : 54         lsrb                ;lsr B
0150 : 89 00      adca #$00           ;adc A
0152 : 54         lsrb                ;lsr B
0153 : 89 00      adca #$00           ;adc A
0155 : 54         lsrb                ;lsr B
0156 : 89 00      adca #$00           ;adc A
0158 : 54         lsrb                ;lsr B
0159 : 89 00      adca #$00           ;adc A
015B : 54         lsrb                ;lsr B
015C : 89 00      adca #$00           ;adc A
015E : 54         lsrb                ;lsr B (7th)
015F : 89 00      adca #$00           ;adc A (7th)
0161 : 1B         aba                 ;add A + B into A
0162 : 48         asla                ;arithmetric shift left A(C <- b7 - b0 <- 0)
0163 : 48         asla                ;asl A
0164 : 48         asla                ;asl A
0165 : 48         asla                ;asl A
0166 : B7 80 00   staa $8000          ;SOUND store A in DAC output
0169 : 09         dex                 ;decr X
016A : 27 03      beq $016F           ;branch =0 GOTO7
016C : 7E 00 16   jmp $0016           ;jump to PIA2 INIT (crash if set IRQ 003D with rewrites at 0167)
;GOTO7
016F : 39         rts                 ;return from sub
;*************************************;
;0170 end
;*************************************;

; SYNTH9 CODE - 16 Mar 2021
; hack for Heathkit ET-3400 Audio Setup
; user RAM = 197 + 256 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; using PIA addr 8000 (not 0400)
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second
; working, constant 2 tone buzz, phasing at start, pitch param
; refactor
;
; SW demo :
; [1110 0101][---- ----]
;
;*************************************;
; Main loop scratch memory reserves
;*************************************;
0000 : --                             ;not used
; ~ not used
0006 : --                             ;not used
0007 : 01                             ; B, PIA1 B param changes pitch (00=hi FF=lo)
0008 : --                             ;not used
; ~ not used
000A : --                             ;not used
000B : 01 56                          ; X
000D : 01 77                          ; X, 01 nn changes
000F : 00 2C                          ; X, nn 2C changes
0011 : 03 02                          ; ?, nn 02 changes
0013 : 08                             ; B
0014 : 01                             ; A
0015 : 02                             ; B
0016 : 00                             ; A
0017 : 00                             ; A 
0018 : 01 66                          ; X
001A : 00                             ; A
001B : 01 76                          ; X
001D : 01 76                          ; X
001F : 00 2C                          ; X
0021 : A0                             ; A
0022 : 08                             ; A
0023 : 00                             ; clr
0024 : 7F D9                          ; ldx at 007C 
0026 : FF D9                          ; writes 0166
0028 : 7F 24                          ; ...
002A : 00 24                          ; to here
;*************************************;
;RESET INIT (POWER-ON) org 002C
;*************************************; NOTE : restarts require 00 from 0024 - 002B
002C : 8E 01 FF   lds #$01FF          ; load SP with 01FFh
002F : CE 80 00	  ldx #$8000          ; load X with 8000h, PIA1 (DAC) addr
0032 : 6F 02      clr $02,x           ; clear(00) addr X + 02h (set 8002 PIA1 PR/DDR port B in)
0034 : 86 FF		  ldaa	#$FF          ; load A with FFh (1111 1111)
0036 : A7 00		  staa	$00,x         ; store A in addr X + 00h (set 8000 PIA1 PR/DDR port A out)
0038 : 86 3C		  ldaa	#$3C          ; load A with 3Ch(0011 1100)
003A : A7 01		  staa	$01,x         ; store A in addr X + 01h (8001 PIA1 CR port A)
003C : 86 37      ldaa  #$37          ; load A with 37h(0011 0111)
003E : A7 03      staa  $03,x         ; store A in addr X + 03h (8003 PIA1 CR port B) 
0040 : 01 01      nop nop             ;
0042 : 01 01      nop nop             ;
;*************************************;
;IRQ / PARAM5 main loop start
;*************************************;
0044 : F6 80 02   ldab $8002          ;load B with PIA B
0047 : 86 10      ldaa #$10           ;load A with 10h (0001 0000)
0049 : CE 00 80   ldx #$0080          ;load X with 0080h <- not used?
004C : D7 07      stab  $07           ;store B in addr 07
;*************************************;
;PARAM13 - modified lots:
; rem bne to PARAM14, bsr and more
;*************************************;
004E : 96 07      ldaa  $07           ;load A with addr 07
0050 : 7C 00 07   inc $0007           ;incr addr 0007
0053 : 86 0D      ldaa  #$0D          ;load A with value 0Dh (0000 1101)
0055 : 16         tab                 ;transfer A to B
0056 : 58         aslb                ;arithmetric shift left B(C <- b7 - b0 <- 0)
0057 : 1B         aba                 ;add A + B into A
0058 : 1B         aba                 ;add A + B into A
0059 : 1B         aba                 ;add A + B into A
005A : CE 01 56   ldx #$0156          ;load X with value 0156h (orig FEEC)
005D : BD 00 B0   jsr $00B0           ;jump sub CALCOS
0060 : A6 00      ldaa  $00,x         ;load A with addr X + 00h
0062 : 16         tab                 ;transfer A to B
0063 : 84 0F      anda  #$0F          ;and A with 0Fh (0000 1111) into A
0065 : 97 14      staa  $14           ;store A in addr 14
0067 : 54         lsrb                ;logical shift right B (0 -> b7 - b0 -> C)
0068 : 54         lsrb                ;lsr B
0069 : 54         lsrb                ;lsr B
006A : 54         lsrb                ;lsr B
006B : D7 13      stab  $13           ;store B in addr 13
006D : A6 01      ldaa  $01,x         ;load A with addr X + 00h
006F : 16         tab                 ;transfer A to B
0070 : 54         lsrb                ;logical shift right B (0 -> b7 - b0 -> C)
0071 : 54         lsrb                ;lsr B
0072 : 54         lsrb                ;lsr B
0073 : 54         lsrb                ;lsr B
0074 : D7 15      stab  $15           ;store B in addr 15
0076 : 84 0F      anda  #$0F          ;and A with 0Fh (0000 1111) into A
0078 : 97 11      staa  $11           ;store A in addr 11
007A : DF 0B      stx $0B             ;store X in addr 0B 
007C : CE 01 66   ldx #$0166          ;load X with value 0166h (orig FE4D)
007F : 7A 00 11   dec $0011           ;$FBAB, decr addr 0011
0082 : DF 18      stx $18             ;store X in addr 18
0084 : BD 01 34   jsr $0134           ;jump sub PARAM18
0087 : DE 0B      ldx $0B             ;load X with addr 0B
0089 : A6 02      ldaa  $02,x         ;load A with addr X + 02h
008B : 97 1A      staa  $1A           ;store A in addr 1A
008D : DE 0B      ldx $0B             ;load X with addr 0B
008F : A6 03      ldaa  $03,x         ;load A with addr X + 03h
0091 : 97 16      staa  $16           ;store A in addr 16
0093 : A6 04      ldaa  $04,x         ;load A with addr X + 04h
0095 : 97 17      staa  $17           ;store A in addr 17
0097 : A6 05      ldaa  $05,x         ;load A with addr X + 05h
0099 : 16         tab                 ;transfer A to B
009A : A6 06      ldaa  $06,x         ;load A with addr X + 06h
009C : CE 01 76   ldx #$0176          ;load X with value 0176h (orig FF55)
009F : BD 00 B0   jsr $00B0           ;jump sub CALCOS
00A2 : 17         tba                 ;transfer B to A
00A3 : DF 1B      stx $1B             ;store X in addr 1B
00A5 : 7F 00 23   clr $0023           ;clear addr 0023
00A8 : BD 00 B0   jsr $00B0           ;jump sub CALCOS
00AB : DF 1D      stx $1D             ;store X in addr 1D
00AD : 7E 01 00   jmp $0100           ;jump to SYNTH9
;*************************************;
;CALCOS (calculate offset) - 00B0
;*************************************;
00B0 : DF 0D		  stx $0D             ; store X in 0D
00B2 : 9B 0E		  adda	$0E           ; add A + value addr 0E into A
00B4 : 97 0E		  staa	$0E           ; store A in 0E
00B6 : 24 05		  bcc	$00BD           ; branch Carry clear (+05) GOTO7
00B8 : 7C 00 0D		inc	$000D           ; incr in addr 000D
00BB : DE 0D		  ldx	$0D             ; load X with addr 0D
;GOTO7
00BD : 39		      rts                 ; return sub
;*************************************;00C4
;SYNTH9 - modified:
; rem beq PARAM14
;*************************************;
0100 : 96 13      ldaa  $13           ;load A with addr 13
0102 : 97 22      staa  $22           ;store A in addr 22
0104 : DE 1B      ldx $1B             ;$FBEB, load X with addr 1B
0106 : DF 0D      stx $0D             ;store X in 0D
0108 : DE 0D      ldx $0D             ;$FBEF load X from addr 0D
010A : A6 00      ldaa  $00,x         ;load A with addr X + 00h
010C : 9B 23      adda  $23           ;add A + addr 23 into A
010E : 97 21      staa  $21           ;store A in addr 21
0110 : D6 14      ldab  $14           ;load B with addr 14
0112 : 08         inx                 ;incr X
0113 : DF 0D      stx $0D             ;store X in addr 0D
;LOOP1
0115 : CE 00 24   ldx #$0024          ;$FC00, load X with 0024h
;LOOP2
0118 : 96 07      ldaa  $07           ;$FC03, load A with addr 07 (PIA B)
;LOOP3
011A : 4A         deca                ;$FC05, decr A
011B : 26 FD      bne $011A           ;branch !=0 LOOP3
011D : A6 00      ldaa  $00,x         ;load A with addr X + 00h
011F : B7 80 00   staa  $8000         ;SOUND store A in addr DAC output
0122 : 08         inx                 ;incr X
0123 : 9C 1F      cpx $1F             ;compare X with addr 1F
0125 : 26 F1      bne $0118           ;branch !=0 LOOP2
0127 : 5A         decb                ;decr B
0128 : 08         inx                 ;incr X
0129 : 09         dex                 ;decr X
012A : 08         inx                 ;incr X
012B : 09         dex                 ;decr X
012C : 08         inx                 ;incr X
012D : 09         dex                 ;decr X
012E : 08         inx                 ;incr X
012F : 09         dex                 ;decr X
0130 : 01         nop                 ;no op
0131 : 7E 00 44   jmp $0044           ;jump to IRQ
;*************************************;
;PARAM18
;*************************************;
0134 : CE 00 24   ldx #$0024          ;load X value 0024h
0137 : DF 0F      stx $0F             ;store X in addr 0F
0139 : DE 18      ldx $18             ;load X from addr 18
013B : E6 00      ldab  $00,x         ;load B with X + 00h
013D : 08         inx                 ;incr X
;UTIL1 merge here
013E : 36         psha                ;push A onto SP
;LOOP5
013F : A6 00      ldaa  $00,x         ;load A from addr X + 00h
0141 : DF 0D      stx $0D             ;store X in addr 0D
0143 : DE 0F      ldx $0F             ;load X from addr 0F
0145 : A7 00      staa  $00,x         ;store A in addr X + 00h
0147 : 08         inx                 ;incr X
0148 : DF 0F      stx $0F             ;store X in addr 0F
014A : DE 0D      ldx $0D             ;load X from addr 0D
014C : 08         inx                 ;incr X
014D : 5A         decb                ;decr B
014E : 26 EF      bne $013F           ;branch !=0 LOOP5
0150 : 32         pula                ;pull SP into A
;UTIL1 merge end
0151 : DE 0F      ldx $0F             ;store X in addr 0F
0153 : DF 1F      stx $1F             ;store X in addr 1F
0155 : 39         rts                 ;return sub (to PARAM13)
;*************************************;
;PARAM13 FDB TABLE
;*************************************;
0156 : 81 24 00 00 00 16 31 12        ;FEEC
015E : 05 1a ff 00 27 6d 11 05        ;
0166 : 08 7f d9 ff d9 7f 24 00        ;FE4D
016E : 24 08 00 40 80 00 ff 00        ;
0176 : a0 98 90 88 80 78 70 68        ;FF55 
017E : 60 58 50 44 40 01 01 02        ;
;*************************************;
;0186 end
;*************************************;01FF


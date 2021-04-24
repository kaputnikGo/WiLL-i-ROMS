; SOUND ROM 1 (Flash) Three Oscillator Sound Generator (PARAM1) CODE - 23 Apr 2021
; hack for Heathkit ET-3400 Audio Setup
; user RAM = 196 + 255 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; addr 00C5 to 00FF is Monitor RAM
; using PIA addr 8000, 4000 (DAC 8000 not 8400)
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second
; using edited subroutines PARAM1, SYNTH0, PARAM2, TRANS, VEC01-VEC05
; functioning, some sounds are a bit odd...
;
; SW demo :
; [---- ---- ---- ----]
;
;changes to orig ROM RAM addrs:
; 1: CYCL4$(1B),DELTA4(7),RANDOM(1D)
; 2: XPTR(22),XPLAY(24),XDECAY(26)
;
;*************************************;
; Scratch RAM (0000-0013)
;*************************************;
0000 : FF nn                          ;FREQ1,FREQ2
0002 : FF 90                          ;FREQ3,FREQ4
0004 : nn nn                          ;CYCL4$,DELTA4
0006 : nn FF                          ;RANDOM,CYCLE4
0008 : nn nn                          ;FREQ1$,FREQ2$
000A : nn nn                          ;FREQ3$,FREQ4$
000C : nn 1C                          ;XPTR,XPTR+1
000E : FF 1D                          ;XPLAY,XPLAY+1
0010 : nn nn                          ;XDECAY,XDECAY+1
0012 : nn nn                          ;mem writes
0014 : nn nn                          ;
;
001A : nn 01                          ;last mem write
001C : nn nn                          ;PIA reads
;*************************************;
;INIT - org 001E
;*************************************;
001E : 8E 01 FF   lds #$01FF          ; load SP with 01FFh
0021 : CE 80 00   ldx #$8000          ; load X with 8000h, PIA1 (DAC) addr
0024 : 6F 02      clr $02,x           ; clear(00) addr X + 02h (set 8002 PIA1 PR/DDR port B in)
0026 : 86 FF      ldaa  #$FF          ; load A with FFh (1111 1111)
0028 : A7 00      staa  $00,x         ; store A in addr X + 00h (set 8000 PIA1 PR/DDR port A out)
002A : 86 3C      ldaa  #$3C          ; load A with 3Ch(0011 1100)
002C : A7 01      staa  $01,x         ; store A in addr X + 01h (8001 PIA1 CR port A)
002E : 86 37      ldaa  #$37          ; load A with 37h(0011 0111)
0030 : A7 03      staa  $03,x         ; store A in addr X + 03h (8003 PIA1 CR port B) 
0032 : 7F 40 02   clr $4002           ; clear(00) 4002h (set PIA2 PR/DDR port B in)
0035 : 86 04      ldaa  #$04          ; set CR bit 2 high for PIA2
0037 : B7 40 03   staa $4003          ; store A in addr 4003 (PIA2 CR port B)
;*************************************;
;MEMCLR (RAM overwrites to 001B) - 003A 
;*************************************;
003A : CE 00 1D   ldx #$001D          ;load X with value 001D (don't write over INIT)
;CLR1:
003D : 6F 00      clr $00,x           ;clear addr X + 00h
003F : 09         dex                 ;decr X
0040 : 26 FB      bne L0019           ;branch if Z=0 CLR1 (loop clears mem addr 001D down to 0000)
;*************************************;
;PIA reads - 0042
;*************************************;
;PIA
0042 : B6 80 02   ldaa  $8002         ;load A with PIA1 B
0045 : 97 1C      staa  $1C           ;store A in addr 1C
0047 : B6 40 02   ldaa  $4002         ;load A with PIA2 B
004A : 97 1D      staa  $1D           ;store A in addr 1D
;*************************************;
;3 Oscillator Calling Routines (PARAM2) - 004C
;*************************************;
;THNDR
004C : CE 00 83   ldx #$0083          ;load X with value 0083 (#VEC01)(THUNDER SOUND)
; alts for loading other FDB tables
;004C : CE 00 9F   ldx #$009F          ;load X with value 009Fh (#VEC02)(SOUND 2)
;004C : CE 01 9D   ldx #$019D          ;load X with value 019Dh (#VEC03)(SOUND 3)
;004C : CE 01 B9   ldx #$01B9          ;load X with value 01B9h (#VEC04)(SOUND 4)
;004C : CE 01 D5   ldx #$01D5          ;load X with value 01D5h (#VEC05)(SOUND 5)
;THNDR1:
004F : C6 1C      ldab #$1C           ;load B with value 1Ch (NEED TO TRANSFER)(#28)
0051 : BD 00 59   jsr L0059           ;jump sub TRANS (28 BYTES FOR PLAY) <- bsr this
0054 : BD 01 00   jsr L0100           ;jump sub PLAY(NOW PLAY IT)
0057 : 20 E1      bra L003A           ;branch always MEMCLR - RAM writes cause havoc on loop 
;*************************************;
;Parameter Transfer - 0059
;*************************************;
;TRANS:
0059 : 36         psha                ;push A into stack then SP - 1
;TRNS1:
005A : A6 00      ldaa $00,x          ;load A with X
005C : DF 0E      stx $0E             ;store X in addr 0E (XPLAY)
005E : DE 0C      ldx $0C             ;load X with value in addr 0C (XPTR)
0060 : A7 00      staa $00,x          ;store A in addr X
0062 : 08         inx                 ;incr X
0063 : DF 0C      stx $0C             ;store X in addr 0C (XPTR)
0065 : DE 0E      ldx $0E             ;load X with value in addr 0E (XPLAY)
0067 : 08         inx                 ;incr X
0068 : 5A         decb                ;decr B
0069 : 26 EF      bne L005A           ;branch Z=0 TRNS1
006B : 32         pula                ;SP + 1 pull stack into A
006C : 39         rts                 ;return subroutine
;*************************************;
;Echo And Decay Routine (SYNTH0) - 006D
;*************************************;
;RDECAY
006D : 54         lsrb                ;logical shift right B (0nnn nnnn)
;#RDECAY+1
006E : 54         lsrb                ;logical shift right B (0nnn nnnn) note fall through above:add one lsrb
006F : 54         lsrb                ;logical shift right B (00nn nnnn)
0070 : 54         lsrb                ;logical shift right B (000n nnnn)
0071 : 54         lsrb                ;logical shift right B (0000 nnnn)
0072 : 54         lsrb                ;logical shift right B (0000 0nnn)
0073 : 54         lsrb                ;logical shift right B (0000 00nn)
0074 : 54         lsrb                ;logical shift right B (0000 000n)
;DECAYZ
0075 : F7 80 00   stab $8000          ;store B in DAC output SOUND 
0078 : 39         rts                 ;return subroutine
;0079 : end
;*************************************;
;FDB tables - 28 bytes each - 0083
;*************************************;
;VEC01 -THUNDER SOUND
0083 : FFFF FF90 FFFF FFFF FFFF
008D : FF90 FFFF FFFF FFFF FFFF 
0097 : 0000 0000 0000 0000
;VEC02 SOUND2
009F : 4801 0000 3F3F 0000 4801
00A9 : 0000 0108 0000 8101 0000
00B3 : 01FF 0000 0108 0000
;00BB : end
;*************************************;
;Three Oscillator Sound Generator (PARAM1) - 0100
;*************************************;
;PLAY:
0100 : DF 0E      stx $0E             ;store X in addr 0E (XPLAY)(SAVE CURRENT INDEX)
0102 : CE 00 75   ldx #$0075          ;load X with 0075h (#DECAYZ)(SET TO MAXIMUM AMPLITUDE)
0105 : DF 10      stx $10             ;store X in addr 10 (XDECAY)(AND SAVE)
0107 : 86 80      ldaa #$80           ;load A with value 80h (LOAD ZERO AMPLITUDE)
;PLAY1:
0109 : D6 03      ldab $03            ;load B with value in addr 03 (FREQ4)(CHECK WHITE NOISE COUNTER)
010B : 2A 09      bpl L0116           ;branch N=0 (PLAY3)(NOT IN WHITE MODE)
010D : D6 06      ldab $06            ;load B with value in addr 06 (RANDOM)(GET RANDOM NUMBER)
010F : 54         lsrb                ;logic shift right B (REDUCE IT)
0110 : 54         lsrb                ;logic shift right B
0111 : 54         lsrb                ;logic shift right B
0112 : 5C         incb                ;incr B (NOW NON-ZERO)
;PLAY2:
0113 : 5A         decb                ;decr B (TIME OUT COUNT)
0114 : 26 FD      bne L0113           ;branch Z=0 (PLAY2)
;PLAY3:
0116 : 7A 00 08   dec $0008           ;decr addr 0008 (FREQ1$)(COUNT DOWN OSC. 1)
0119 : 27 4C      beq L0167           ;branch Z=1 (PLAY7)(DO AN UPDATE)
011B : 7A 00 09   dec $0009           ;decr addr 0009 (FREQ2$)(COUNT DOWN OSC. 2)
011E : 27 4C      beq L016C           ;branch Z=1 (PLAY8)(DO AN UPDATE)
0120 : 7A 00 0A   dec $000A           ;decr addr 000A (FREQ3$)(COUNT DOWN OSC. 3)
0123 : 27 4C      beq L0171           ;branch Z=1 (PLAY9)(DO AN UPDATE)
0125 : 7A 00 0B   dec $000B           ;decr addr 000B (FREQ4$)(COUNT DOWN WHITE NOISE)
0128 : 26 DF      bne L0109           ;branch Z=0 (PLAY1)(DO THEM AGAIN)
012A : D6 03      ldab $03            ;load B with value in addr 03 (FREQ4)(CHECK WHOTE NOISE CONSTANT)
012C : 27 DB      beq L0109           ;branch Z=1 (PLAY1)(FORGET IT)
012E : C4 7F      andb #$7F           ;And B with value 7Fh (STRIP FLAG BIT)
0130 : D7 0B      stab $0B            ;store B in addr 0B (FREQ4$)(SAVE WHITE NOISE COUNT)
0132 : D6 06      ldab $06            ;load B with value in addr 06 (RANDOM)(GET CURRENT RANDOM)
0134 : 58         aslb                ;arith shift left B (DOUBLE)
0135 : DB 06      addb $06            ;add B with value in addr 06 (RANDOM)(TRIPLE)
0137 : CB 0B      addb #$0B           ;add B with value 0Bh (ADD IN 11)
0139 : D7 06      stab $06            ;store B in addr 06 (RANDOM)(VOILA...NEW RANDOM NUMBER)
013B : 7A 00 04   dec $0004           ;decr addr 0004 (CYCL4$)(COUNT DOWN DECAY)
013E : 26 0E      bne L014E           ;branch Z=0 (PLAY6)(DON'T DECAY)
0140 : D6 07      ldab $07            ;load B with value in addr 07 (CYCLE4)(RELOAD COUNT)
0142 : D7 04      stab $04            ;store B in addr 04 (CYCL4$)(AND SAVE)
0144 : DE 10      ldx $10             ;load X with value in addr 10 (XDECAY)(GET DECAY JUMP POINTER)
0146 : 09         dex                 ;decr X (MOVE TO LESS AMPLITUDE)
0147 : 8C 00 6D   cpx #$006E          ;compare X with value 006Eh (#RDECAY+1)(DONE?)
014A : 27 4E      beq L019A           ;branch Z=1 (PLAY12)(YUP...BYE BYE)
014C : DF 10      stx $10             ;store X in addr 10 (XDECAY)(SAVE NEW POINTER)
;PLAY6:
014E : D6 06      ldab $06            ;load B with value in addr 06 (RANDOM)(GET RANDOM AMPLITUDE)
0150 : 2B 06      bmi L0158           ;branch N=1 (PLAY6A)(SKIP IF NEGATIVE)
0152 : D4 05      andb $05            ;And B with value in addr 05 (DELTA4)(REDUCE AMPLITUDE)
0154 : C4 7F      andb #$7F           ;And B with value 7Fh (REMOVE SIGN BIT)
0156 : 20 05      bra L015D           ;branch always (PLAY6B)
;PLAY6A:
0158 : D4 05      andb $05            ;And B with value in addr 05 (DELTA4)(REDUCE AMPLITUDE)
015A : C4 7F      andb #$7F           ;And B with value 7Fh (REMOVE SIGN BIT)
015C : 50         negb                ;complement 2s B (NEGATE)
;PLAY6B:
015D : 36         psha                ;push A into stack then SP - 1
015E : 1B         aba                 ;A = A + B (ADD WHITE NOISE)
015F : 16         tab                 ;transfer A to B
0160 : 32         pula                ;SP + 1 pull stack into A
0161 : DE 10      ldx $10             ;load X with value in addr 10 (XDECAY)(GET DECAY POINTER)
0163 : AD 00      jsr $00,x           ;jump sub addr X (OUTPUT NOISE)
0165 : 20 A2      bra L0109           ;branch always (PLAY1)(DO SOME MORE)
;PLAY7:
0167 : CE 00 00   ldx #$0000          ;load X with value 0000h (#FREQ1)(INDEX SET 1)
016A : 20 08      bra L0174           ;branch always (PLAY10)
;PLAY8:
016C : CE 00 01   ldx #$0001          ;load X with value 0001h (#FREQ2)(INDEX SET 2)
016F : 20 03      bra L0174           ;branch always (PLAY10)
;PLAY9:
0171 : CE 00 02   ldx #$0002          ;load X with value 0002h (#FREQ3)(INDEX SET 3)
;PLAY10:
0174 : 6D 18      tst $18,x           ;test value in X+18h (24,X)(CHECK CYCLES AT FREQUENCY)
0176 : 27 12      beq L018A           ;branch Z=1 (PLAY11)(ZERO, DON'T CHANGE)
0178 : 6A 18      dec $18,x           ;decr addr X+18h (24,X)(COUNT DOWN)
017A : 26 0E      bne L018A           ;branch Z=0 (PLAY11)(NOT TIME TO CHANGE...)
017C : E6 0C      ldab $0C,x          ;load B with value in addr X+0Ch (12,X)(LOAD CYCLES AT FREQUENCY)
017E : E7 18      stab $18,x          ;store B in addr X+18h (24,X)(SAVE IN COUNTER)
0180 : E6 00      ldab $00,x          ;load B with value in X (GET CURRENT FREQUENCY)
0182 : EB 10      addb $10,x          ;add B with value in addr X+10h (16,X)(ADD DELTA)
0184 : E1 14      cmpb $14,x          ;compare B with value in addr X+14h (20,X)(COMPARE TO END)
0186 : 27 12      beq L019A           ;branch Z=1 (PLAY12)(DONE...)
0188 : E7 00      stab $00,x          ;store B in addr X (SAVE NEW CURRENT FREQUENCY)
;PLAY11:
018A : E6 00      ldab $00,x          ;load B with value in addr X (GET CURRENT FREQUENCY)
018C : E7 08      stab $08,x          ;store B in addr X+08h (SAVE IN FREQUENCY COUNTER)
018E : AB 04      adda $04,x          ;add A with value in addr X+04h (ADD IN AMPLITUDE)
0190 : 60 04      neg $04,x           ;complement 2s in X+04h (NEGATE AMPLITUDE)
0192 : 16         tab                 ;transfer A to B (SAVE DATA)
0193 : DE 10      ldx $10             ;load X with value in addr 10 (XDECAY)(INDEX TO DECAY)
0195 : AD 00      jsr $00,x           ;jump sub addr X (OUTPUT SOUND)
0197 : 7E 01 09   jmp L0109           ;jump (PLAY1)(REPEAT)
;PLAY12:
019A : DE 0E      ldx $0E             ;load X with value in addr 0E (XPLAY)(RESTORE INDEX)
019C : 39         rts                 ;return subroutine
;*************************************;
;FDB tables - 28 bytes each -019D
;*************************************;
;VEC03 SOUND3
019D : 0110 0000 3F3F 0000 0110
01A7 : 0000 0505 0000 0101 0000
01B1 : 31FF 0000 0505 0000
;VEC04 SOUND4
01B9 : 3000 0000 7F00 0000 3000
01C3 : 0000 0100 0000 7F00 0000
01CD : 0200 0000 0100 0000 
;VEC05 SOUND5
01D5 : 0400 0004 7F00 007F 0400
01DF : 0004 FF00 00A0 0000 0000
01E9 : 0000 0000 FF00 00A0 
;01F1 : end
;
;01FC : Stack Pointer - top
;01FF : Stack Pointer - bottom

;possible inclusion of :
7901 : CE 7C 9E   ldx #$7C9E     ;load X with value 7C9Eh (#VEC06)(FDBTBL9)
;VEC06 FDBTBL9 
7C9E : 0C68 6800 071F 0F00 0C80 
7CA8 : 8000 FFFF FF00 0000 0000 
7CB2 : 0000 0000 FFFF FF00
;from Joust
;VEC016
F344 : 0104 0000 3F7F 0000 0104       ;FDB
F34E : 0000 05FF 0000 0100 0000       ;
F358 : 4800 0000 05FF 0000            ;
;VEC017
F360 : 0280 0030 0A7F 007F 0280       ;FDB
F36A : 0030 C080 0020 0110 0015       ;
F374 : C010 0000 C080 0000            ;

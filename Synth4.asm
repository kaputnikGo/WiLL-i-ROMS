; SYNTH4 CODE - 11 Nov 2019
; hack for Heathkit ET-3400 Audio Setup - PIA B input var parameter, tested, working
; user RAM = 197 + 256 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; using PIA addr 8000 (not 0400)
; not using actual NMI, IRQ , SWI etc
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second
; working, def blaster and ship static sounds

;*************************************;
; Main loop scratch memory reserves
;*************************************;
0000 : 00                             ; not used
; ~       RESERVED
0008 : 00                             ;
0009 : xx                             ; changes
000A : xx                             ; changes
0012 : 00                             ;
0013 : 01                             ; B, p3-inner oscil frequency (low 0x01, fast 0x80)
0014 : 01                             ; 
0015 : 00                             ; 
0016 : 80 00                          ; IX, p1-main loop length & frequency
0018 : xx                             ; A, p2-pitch ramp down control ON (0xnn) or OFF (0x00)
0019 : xx                             ; 
001A : 00                             ; 
001C : 00                             ; end main loop mem
;*************************************;
;RESET INIT (POWER-ON) org 001D
;*************************************;
001D : 8E 01 FF   lds #$01FF          ; load SP with 01FFh
0020 : CE 80 00	  ldx #$8000          ; load X with 8000h, PIA (DAC) addr
0023 : 6F 01		  clr	$01,x           ; clear(00) addr X + 01h (8001, PIA DDR port A) 
0025 : 6F 03      clr $03,x           ; clear(00) addr X + 03h (8003, PIA DDR port B)
0027 : 6F 02      clr $02,x           ; clear(00) addr X + 02h (8002, port B input)
0029 : 86 FF		  ldaa	#$FF          ; load A with FFh (1111 1111)
002B : A7 00		  staa	$00,x         ; store A in addr X + 00h (8000, port A output)
002D : 86 3C		  ldaa	#$3C          ; load A with 3Ch(0011 1100)
002F : A7 01		  staa	$01,x         ; store A in addr X + 01h (8001)
0031 : 86 37      ldaa  #$37          ; load A with 37h(0011 0111)(28h 0010 1000)
0033 : A7 03      staa  $03,x         ; store A in addr X + 03h (8003) 
;*************************************;
;IRQ / PARAM5 main loop start
;*************************************;
0035 : F6 80 02   ldab $8002          ;load B with PIA B
0038 : C6 10      ldaa #$10           ;load A with 10h (0001 0000)
003A : CE 00 80   ldx #$0080          ;load X with 0080h
;*************************************;
;SYNTH4
;*************************************;
003D 97 18        staa  $18           ;store A in addr 18
003F D7 13        stab  $13           ;store B in addr 13
0041 DF 16        stx $16             ;store X in addr 16
0043 7F 00 15     clr $0015           ;clear addr 0015
;LF939: LOOP1
0046 DE 16        ldx $16             ;load X from addr $16
0048 B6 80 00     ldaa  $8000         ;load A with SOUND
;LF93E: LOOP2
004B 16           tab                 ;transfer accum A to B
004C 54           lsrb                ;logical shift right B
004D 54           lsrb                ;
004E 54           lsrb                ;
004F D8 0A        eorb  $0A           ;exclusive OR $0A into B
0051 54           lsrb                ;
0052 76 00 09     ror $0009           ;rotate right addr 0009 (C -> b7 - b0 -> C )
0055 76 00 0A     ror $000A           ;ror addr 000A
0058 D6 13        ldab  $13           ;load B from addr 13
005A 7D 00 19     tst $0019           ;test addr 0019 for 0 or negative
005D 27 02        beq L005E           ;branch equal 0 GOTO1
005F D4 09        andb  $09           ;and B with addr 09 into B
;LF954: GOTO1
0061 D7 14        stab  $14           ;store B in addr 14
0063 D6 15        ldab  $15           ;load B with addr 15
0065 91 0A        cmpa  $0A           ;compare A with addr 0A
0067 22 12        bhi L0078           ;branch higher LOOP4
;LF95C: LOOP3
0069 09           dex                 ;decr index reg
006A 27 26        beq L008F           ;branch equal 0 GOTO3
006C B7 80 00     staa  $8000         ;SOUND store A to addr 8000
006F DB 15        addb  $15           ;add B + addr 15 into B
0071 99 14        adca  $14           ;add A + addr 14 + C into A
0073 25 16        bcs L0088           ;branch Carry set GOTO2
0075 91 0A        cmpa  $0A           ;compare A with addr 0A
0077 23 F0        bls L0066           ;branch lower or same LOOP3
0079 20 10        bra L0088           ;branch always GOTO2
;LF96E: LOOP4
007B 09           dex                 ;decrement IX
007C 27 14        beq L008F           ;branch equal 0 GOTO3 
007E B7 80 00     staa  $8000         ;SOUND store A in addr 8000
0081 D0 15        subb  $15           ;subtract B - addr 15 into B
0083 92 14        sbca  $14           ;subtract A - addr 14 - C into A
0085 25 04        bcs L0088           ;branch Carry set GOTO2
0087 91 0A        cmpa  $0A           ;compare A with 0A
0089 22 F0        bhi L0078           ;branch higher LOOP4
;LF97E: GOTO2
008B 96 0A        ldaa  $0A           ;load A with addr 0A
008D B7 80 00     staa  $8000         ;SOUND store A in addr 8000
0090 20 B9        bra L0048           ;branch always LOOP2
;LF985: GOTO3
0092 D6 18        ldab  $18           ;load B with addr 18
0094 27 B5        beq L0048           ;branch equal zero LOOP2
0096 96 13        ldaa  $13           ;load A with addr 13
0098 D6 15        ldab  $15           ;load B with addr 15
009A 44           lsra                ;logical shift right (0 into b7, b0 into C)
009B 56           rorb                ;rotate right B
009C 44           lsra                ;
009D 56           rorb                ;
009E 44           lsra                ;
009F 56           rorb                ;
00A0 43           coma                ;complement 1s in A
00A1 50           negb                ;negate (complement 2s) in B
00A2 82 FF        sbca  #$FF          ;subtract A - FFh - C into A
00A4 DB 15        addb  $15           ;add B + addr 15 into B
00A6 99 13        adca  $13           ;add A + addr 13 + C into A
00A8 D7 15        stab  $15           ;store B into addr 15
00AA 97 13        staa  $13           ;store A into addr 13
00AC 26 98        bne L0043           ;branch !=0 LOOP1
00AE C1 07        cmpb  #$07          ;compare B with 07h
00B0 26 94        bne L0043           ;branch !=0 LOOP1
00B2 7E 00 35     jmp L0035           ;jump to IRQ loop start
;*************************************;
;end
;*************************************;


; SYNTH4 CODE - 14 Mar 2021
; hack for Heathkit ET-3400 Audio Setup - PIA B input var parameter, tested, working
; user RAM = 197 + 256 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; using PIA addr 8000 (not 0400)
; not using actual NMI, IRQ , SWI etc
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second
; working, def blaster and ship static sounds
; added PIA2 addrs and refactoring
;
; SW demo:
; [0000 1111][0001 0000]
;
;*************************************;
; Main loop scratch memory reserves
;*************************************;
0000 : 00 00                          ; not used
0002 : nn 00                          ; A, ror - A6 00
0004 : nn 00                          ; A,B, ror - 21 00
0006 : nn 00                          ; B, p3-inner oscil frequency (low 0x01, fast 0x80) - 10 00
0008 : nn 00                          ; A,B - 00 48
000A : nn nn                          ; IX, p1-main loop length & frequency (80h) - 00 80
000C : nn 00                          ; A, p2-pitch ramp down control ON (0xnn) or OFF (0x00) - 00 00
000E : nn 00                          ; TST var - start new init here - 8A 00
0010 : nn 00                          ; B - 00 9E
;*************************************;
;RESET INIT (POWER-ON) org 0012
;*************************************;
0012 : 8E 01 FF   lds #$01FF          ; load SP with 01FFh
0015 : CE 80 00	  ldx #$8000          ; load X with 8000h, PIA1 (DAC) addr
0018 : 6F 02      clr $02,x           ; clear(00) addr X + 02h (set 8002 PIA1 PR/DDR port B in)
001A : 86 FF		  ldaa	#$FF          ; load A with FFh (1111 1111)
001C : A7 00		  staa	$00,x         ; store A in addr X + 00h (set 8000 PIA1 PR/DDR port A out)
001E : 86 3C		  ldaa	#$3C          ; load A with 3Ch(0011 1100)
0020 : A7 01		  staa	$01,x         ; store A in addr X + 01h (8001 PIA1 CR port A)
0022 : 86 37      ldaa  #$37          ; load A with 37h(0011 0111)
0024 : A7 03      staa  $03,x         ; store A in addr X + 03h (8003 PIA1 CR port B) 
0026 : 7F 40 02   clr X4002           ; clear(00) 4002h (set PIA2 PR/DDR port B in)
0029 : 86 04      ldaa  #$04          ; set CR bit 2 high for PIA2
002B : B7 40 03   staa X4003          ; store A in addr 4003 (PIA2 CR port B)
002E : 01         nop                 ;
; ~ 01 nops ./cont
0034 : 01         nop                 ; reserved for adding PIA2 B ldaa/ldab
;*************************************;
;IRQ / PARAM5 main loop start
;*************************************;
0035 : F6 80 02   ldab $8002          ;load B with PIA B
;0038 : C6 10      ldaa #$10           ;load A with 10h (0001 0000)
0038 : 01 01      nop nop             ;
003A : CE 00 80   ldx #$0080          ;load X with 0080h
;*************************************;
;SYNTH4
;*************************************;
003D : 97 0C      staa  $0C           ;store A in addr 0C
003F : D7 06      stab  $06           ;store B in addr 06
0041 : DF 0A      stx $0A             ;store X in addr 0A
0043 : 7F 00 10   clr $0010           ;clear addr 0010
;LF939: LOOP1
0046 : DE 0A      ldx $0A             ;load X from addr $0A
0048 : B6 80 00   ldaa  $8000         ;load A with SOUND
;LF93E: LOOP2
004B : 16         tab                 ;transfer accum A to B
004C : 54         lsrb                ;logical shift right B
004D : 54         lsrb                ;
004E : 54         lsrb                ;
004F : D8 04      eorb  $04           ;exclusive OR $04 into B
0051 : 54         lsrb                ;
0052 : 76 00 02   ror $0002           ;rotate right addr 0002 (C -> b7 - b0 -> C )
0055 : 76 00 04   ror $0004           ;ror addr 0004 (possibly 0003)
0058 : D6 06      ldab  $06           ;load B from addr 06
005A : 7D 00 0E   tst $000E           ;test addr 000E for 0 or negative
005D : 27 02      beq L0061           ;branch equal 0 GOTO1
005F : D4 02      andb  $02           ;and B with addr 02 into B
;LF954: GOTO1
0061 : D7 08      stab  $08           ;store B in addr 08
0063 : D6 10      ldab  $10           ;load B with addr 10
0065 : 91 04      cmpa  $04           ;compare A with addr 04
0067 : 22 12      bhi L007B           ;branch higher LOOP4
;LF95C: LOOP3
0069 : 09         dex                 ;decr index reg
006A : 27 26      beq L0092           ;branch equal 0 GOTO3
006C : B7 80 00   staa  $8000         ;SOUND store A to addr 8000
006F : DB 10      addb  $10           ;add B + addr 10 into B
0071 : 99 08      adca  $08           ;add A + addr 08 + C into A
0073 : 25 16      bcs L008B           ;branch Carry set GOTO2
0075 : 91 04      cmpa  $04           ;compare A with addr 04
0077 : 23 F0      bls L0069           ;branch lower or same LOOP3
0079 : 20 10      bra L008B           ;branch always GOTO2
;LF96E: LOOP4
007B : 09         dex                 ;decrement IX
007C : 27 14      beq L0092           ;branch equal 0 GOTO3 
007E : B7 80 00   staa  $8000         ;SOUND store A in addr 8000
0081 : D0 10      subb  $10           ;subtract B - addr 10 into B
0083 : 92 08      sbca  $08           ;subtract A - addr 08 - C into A
0085 : 25 04      bcs L008B           ;branch Carry set GOTO2
0087 : 91 04      cmpa  $04           ;compare A with 04
0089 : 22 F0      bhi L007B           ;branch higher LOOP4
;LF97E: GOTO2
008B : 96 04      ldaa  $04           ;load A with addr 04
008D : B7 80 00   staa  $8000         ;SOUND store A in addr 8000
0090 : 20 B9      bra L004B           ;branch always LOOP2
;LF985: GOTO3
0092 : D6 0C      ldab  $0C           ;load B with addr 0C
0094 : 27 B5      beq L004B           ;branch equal zero LOOP2
0096 : 96 06      ldaa  $06           ;load A with addr 06
0098 : D6 10      ldab  $10           ;load B with addr 10
009A : 44         lsra                ;logical shift right (0 into b7, b0 into C)
009B : 56         rorb                ;rotate right B
009C : 44         lsra                ;
009D : 56         rorb                ;
009E : 44         lsra                ;
009F : 56         rorb                ;
00A0 : 43         coma                ;complement 1s in A
00A1 : 50         negb                ;negate (complement 2s) in B
00A2 : 82 FF      sbca  #$FF          ;subtract A - FFh - C into A
00A4 : DB 10      addb  $10           ;add B + addr 10 into B
00A6 : 99 06      adca  $06           ;add A + addr 06 + C into A
00A8 : D7 10      stab  $10           ;store B into addr 10
00AA : 97 06      staa  $06           ;store A into addr 06
00AC : 26 98      bne L0046           ;branch !=0 LOOP1
00AE : C1 07      cmpb  #$07          ;compare B with 07h
00B0 : 26 94      bne L0046           ;branch !=0 LOOP1
00B2 : B6 40 02   ldaa  $4002         ;load A with PIA2 B
00B5 : 7E 00 35   jmp L0035           ;jump to IRQ loop start
;*************************************;
;00B8 : end
;*************************************;


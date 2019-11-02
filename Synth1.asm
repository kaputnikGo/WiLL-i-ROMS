; PARAM1/SYNTH1 assembly code - 02 Nov 2019
; for Heathkit ET-3400 Audio Setup - PIA B input var parameter, tested, working
; user RAM = 197 + 256 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; using PIA addr 8000 (not 0400)
; not using actual NMI, IRQ , SWI etc
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second

; using edited subroutines RESET, NMI, PARAM1, CALCOS, UTIL1, SYNTH1
; (0000-00BF) + (0100-0108) = (192) + (9) = 201
; 
;*************************************;
; PIA B read subroutine
;*************************************;
0000 : 4F         clra                ; clear A
0001 : B6 80 02   ldaa X8002          ; load A with PIA B
0004 : 43         coma                ; complement A (flip bits)
0005 : B7 01 00   staa X0100          ; store A in 0100 (parameter 1 of waveform)
0008 : 39         rts                 ; return from subroutine
;*************************************;
0009 :                                ; used by main loop
; ~       RESERVED                    ;
0019 :                                ; end main loop mem (19 bytes)
;*************************************;
;RESET INIT (POWER-ON) org 001A
;*************************************;
001A : 8E 01 FF   lds #$01FF          ; load SP with 01FFh
001D : CE 80 00   ldx #$8000          ; load X with 8000h, PIA (DAC) addr
0020 : 6F 01      clr	$01,x          ; clear(00) addr X + 01h (8001, PIA DDR port A) 
0022 : 6F 03      clr $03,x           ; clear(00) addr X + 03h (8003, PIA DDR port B)
0024 : 6F 02      clr $02,x           ; clear(00) addr X + 02h (8002, port B input)
0026 : 86 FF      ldaa	#$FF           ; load A with FFh (1111 1111)
0028 : A7 00      staa	$00,x          ; store A in addr X + 00h (8000, port A output)
002A : 86 3C      ldaa	#$3C           ; load A with 3Ch(0011 1100)
002C : A7 01      staa	$01,x          ; store A in addr X + 01h (8001)
002E : 86 37      ldaa  #$37          ; load A with 37h(0011 0111)(28h 0010 1000)
0030 : A7 03      staa  $03,x         ; store A in addr X + 03h (8003) 
;*************************************;
;NMI - MAIN LOOP start
;*************************************;
0032 : CE FF FF   ldx	#$FFFF         ; load X with value FFFFh ( or 78h )
0035 : 5F         clrb                ; clear (00) B
0036 : E9 00      adcb	$00,x          ; add B + X + 00h with Carry into B
0038 : 86 01      ldaa	#$01           ; load A with value 01h (0000 0001)
;*************************************;
;PARAM1
;*************************************;
003A : 16         tab                 ; transfer A to B
003B : 48         asla                ; shift left in A
003C : 48         asla                ; shift left in A
003D : 48         asla                ; shift left in A
003E : 1B         aba                 ; add A + B into A
003F : CE 00 0F   ldx	#$000F         ; load X with value 000F
0042 : DF 0B      stx	X000B          ; store X in addr 000B ( & 000C)
0044 : CE 01 00   ldx	#$0100         ; load X with value 0100 (SAW) <- add switch? 
0047 : 8D 69      bsr L00B2           ; branch CALCOS PC + 69h(+105) to 00B2
0049 : C6 09      ldab	#$09           ; load B with 09h (0000 1001)
;*************************************;
;UTIL1 - (loop till ACCUM B is zero, while inc X value of VVECT)
;*************************************;
004B : 36         psha                ; push A into stack(A into SP) 
;L004C: LOOP28
004C : A6 00      ldaa	$00,x          ; load A with value in X + 00h
004E : DF 09      stx	X0009          ; store X in 0009
0050 : DE 0B      ldx	X000B          ; load X with value in 000B
0052 : A7 00      staa	$00,x          ; store A in X + 00h
0054 : 08         inx                 ; increment X
0055 : DF 0B      stx	X000B          ; store X in 000B
0057 : DE 09      ldx	X0009          ; load X with value in 0009
0059 : 08         inx                 ; increment X
005A : 5A         decb                ; decrement B
005B : 26 EF      bne	L004C          ; branch != zero PC - EFh (LOOP28)(-17)
005D : 32         pula                ; pull into A from stack (SP into A)
;*************************************;
;SYNTH1
;*************************************;
005E : 96 17      ldaa	X0017          ; load A with value in addr 0017
0060 : B7 80 00   staa	X8000          ; store A in addr 8000 (SOUND)
;L0063: LOOP1
0063 : 96 0F      ldaa	X000F          ; load A with value in addr 000F
0065 : 97 18      staa	X0018          ; store A in addr 0018
0067 : 96 10      ldaa	X0010          ; load A with value in addr 0010
0069 : 97 19      staa	X0019          ; store A in addr 0019
;L006B: LOOP2
006B : DE 14      ldx	X0014          ; load X with value in 0014
;L006D: LOOP3
006D : 96 18      ldaa	X0018          ; load A with value in addr 0018
006F : 73 80 00   com	X8000          ; complement 1s in addr 8000 (invert)(SOUND)
;L0072: LOOP4
0072 : 09         dex                 ; decrement X (X = X - 1)
0073 : 27 10      beq	L0085          ; branch if zero (Z = 1) to PC + 10h (GOTO1)
0075 : 4A         deca                ; decrement A (A = A - 1)
0076 : 26 FA      bne	L0072          ; branch != zero PC - FAh (LOOP4)(-6)
0078 : 73 80 00   com	X8000          ; complements 1s in addr 8000 (SOUND)
007B : 96 19      ldaa	X0019          ; load A with value in 0019
;L007D: LOOP5
007D : 09         dex                 ; decrement X
007E : 27 05      beq	L0085          ; branch if zero to PC + 05h (GOTO1)(+5)
0080 : 4A         deca                ; decrement A
0081 : 26 FA      bne	L007D          ; branch if not equal zero to PC - FAh (LOOP5)(-6)
0083 : 20 E8      bra	L006D          ; branch always to addr PC - E8h (LOOP3)(-24) 
;L0085: GOTO1
0085 : B6 80 00   ldaa	X8000          ; load A with value in addr 8000 (SOUND)
0088 : 2B 01      bmi	L008B          ; branch if minus (N = 1) to PC + 01h (GOTO2)
008A : 43         coma                ; complements 1s in A
;L008B: GOTO2
008B : 8B 00      adda	#$00           ; add A with 00h (A = A + 00h)
008D : B7 80 00   staa	X8000          ; store A in addr 8000 (SOUND)
0090 : 96 18      ldaa	X0018          ; load A with value in 0018
0092 : 9B 11      adda	X0011          ; add A with value in addr 0011
0094 : 97 18      staa	X0018          ; store A in addr 0018
0096 : 96 19      ldaa	X0019          ; load A with value in 0019
0098 : 9B 12      adda	X0012          ; add A with value in addr 0012
009A : 97 19      staa	X0019          ; store A in addr 0019
009C : 91 13      cmpa	X0013          ; compare A with value in addr 0013
009E : 26 CB      bne	L006B          ; branch != zero to PC - CBh (LOOP2)(-53)
00A0 : 96 16      ldaa	X0016          ; load A with value in 0016
00A2 : 27 06      beq	L00AA          ; branch if zero to PC + 06h (GOTO3)
00A4 : 9B 0F      adda	X000F          ; add A with value in addr 000F
00A6 : 97 0F      staa	X000F          ; store A in addr 000F
00A8 : 26 B9      bne	L0063          ; branch != zero to PC - B9h (LOOP1)(-71)
;L00AA: GOTO3
00AA : BD 00 00   jsr L0000           ; jump sub to PIA B read
00AD : 86 02      ldaa	#$02           ; load A with value 02h (0000 0010)
00AF : 7E 00 32   jmp L0032           ; jump to start L0032
;*************************************;
;CALCOS (calculate offset)
;*************************************;
00B2 : DF 09      stx	X0009          ; store X in 0009
00B4 : 9B 0A      adda	X000A          ; add A with value in 000A
00B6 : 97 0A      staa	X000A          ; store A in 000A
00B8 : 24 05      bcc	L00BF          ; branch if Carry clear to PC + 05 (GOTO46)
00BA : 7C 00 09   inc	X0009          ; increment value in 0009
00BD : DE 09      ldx	X0009          ; load X with value in 0009
;L00BF: GOTO46
00BF : 39         rts                 ; return from subroutine
; 00BF allocated
;*************************************;
; must end before 00C4, org 0100 for IC16,IC17
;*************************************;
;PARAM WAVEFORM FDB (all are endless loops)
;*************************************;
0100 : 28 01 00 08 81 02 00 FF FF     ; FOSHIT, Williams Boot
;*************************************; 
;KNOWN PARAM WAVEFORMS (tested for PARAM1/SYNTH1)
;*************************************;
;     :|p1|p2|p3|p4|p5|p6|p7|count    ; 
;0109 : 40 01 00 10 E1 00 80 FF FF    ; SAW <- 4x arpeg pulses rising
;0112 : 28 01 00 08 81 02 00 FF FF    ; FOSHIT <- Williams Boot, rising pulses, loop at high
;011B : 28 81 00 FC 01 02 00 FC FF    ; QUASAR <- Boot Carpet
;0124 : FF 01 00 18 41 04 80 00 FF    ; CABSHK <- low heavy pulses
;012D : 00 FF 08 FF 68 04 80 00 FF    ; CSCADE <- 5x ramp down saws
;0136 : 60 01 57 08 E1 02 00 FE 80    ; VARBG1 <- 2 tone heavy pulses oscils up !!
;*************************************;
; Stack Pointer RAM addrs reserve
;*************************************;
01E8 :                                ; last SP
; ~                                   ; 23 bytes
01FF :                                ; initial SP
;*************************************;

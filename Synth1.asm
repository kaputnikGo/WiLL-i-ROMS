; SYNTH1/PARAM1 CODE - 12 Mar 2021
; hack for Heathkit ET-3400 Audio Setup - 2x PIA input params
; user RAM = 197 + 256 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; using PIA1 addr 8000-8003 (DAC, param1)
; and PIA2 addr 4000-4003 (param2)
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second
; using edited subroutines RESET, NMI, PARAM1, CALCOS, UTIL1, SYNTH1
;
; PIA Addressing changes for breakout board
; 
;*************************************;
; USED RAM ADDR LOCATIONS (moved to 0000+)
;*************************************;
0000 : 00 24                          ; CALCOS, UTIL1
0002 : 01 08                          ; X, UTIL1
0004 : 00 18                          ; X
0006 : nn 01                          ; X, nn countdown, SAW params 000F to 0017
0008 : 00 08                          ; A, A
000A : 81 02                          ; A, X
000C : 00 FF                          ; X, A
000E : FF nn                          ; nn countdown
0010 : nn                             ; nn rapid
;*************************************;
;RESET INIT (POWER-ON) org 0011
;*************************************;
0011 : 8E 01 FF   lds #$01FF          ; load SP with 01FFh
0014 : CE 80 00	  ldx #$8000          ; load X with 8000h, PIA1 (DAC) addr
0017 : 6F 01		  clr	$01,x           ; clear(00) addr X + 01h (8001 PIA1 DDR port A) 
0019 : 6F 03      clr $03,x           ; clear(00) addr X + 03h (8003 PIA1 DDR port B)
001B : 6F 02      clr $02,x           ; clear(00) addr X + 02h (8002 PIA1 port B in)
001D : 86 FF		  ldaa	#$FF          ; load A with FFh (1111 1111)
001F : A7 00		  staa	$00,x         ; store A in addr X + 00h (8000 PIA1 port A out)
0021 : 86 3C		  ldaa	#$3C          ; load A with 3Ch(0011 1100)
0023 : A7 01		  staa	$01,x         ; store A in addr X + 01h (8001 PIA1 port A)
0025 : 86 37      ldaa  #$37          ; load A with 37h(0011 0111)
0027 : A7 03      staa  $03,x         ; store A in addr X + 03h (8003 PIA1 port B) 
0029 : CE 40 00   ldx #$4000          ; load X with 4000h, PIA2 addr
002C : 6F 03      clr $03,x           ; clear(00) addr X + 03h (4003 PIA2 DDR port B)
002E : 6F 02      clr $02,x           ; clear(00) addr X + 02h (4002 PIA2 port B in)
0030 : A7 03      staa  $03,x         ; store A in addr X + 03h (4004 PIA2 port B)
;*************************************;
;NMI - MAIN LOOP start 0032
;*************************************;
0032 : CE FF FF		ldx	#$FFFF          ; load X with value FFFFh ( or 78h )
0035 : 5F		      clrb                ; clear (00) B
0036 : E9 00		  adcb	$00,x         ; add B + X + 00h with Carry into B
0038 : 86 01		  ldaa	#$01          ; load A with value 01h (0000 0001)
;*************************************;
;PARAM1
;*************************************;
003A : 16		      tab                 ; transfer A to B
003B : 48		      asla                ; shift left in A
003C : 48		      asla                ; shift left in A
003D : 48		      asla                ; shift left in A
003E : 1B		      aba                 ; add A + B into A
003F : CE 00 06		ldx	#$0006          ; load X with value 0006
0042 : DF 02		  stx	X0002           ; store X in addr 0002
0044 : CE 01 0E		ldx	#$010E          ; load X with value 010E (SAW)
0047 : BD	01 00   jsr L0100           ; jump sub CALCOS
004A : C6 09		  ldab	#$09          ; load B with 09h (0000 1001)
;*************************************;
;UTIL1 - (loop till ACCUM B is zero, while inc X value of VVECT)
;**************************************;
004C : 36		      psha                ; push A into stack(A into SP) 
;LOOP1
004D : A6 00		  ldaa	$00,x         ; load A with value in X + 00h
004F : DF 00		  stx	X0000           ; store X in 0000
0051 : DE 02		  ldx	X0002           ; load X with value in 0002
0053 : A7 00		  staa	$00,x         ; store A in X + 00h
0055 : 08		      inx                 ; increment X
0056 : DF 02		  stx	X0002           ; store X in 0002
0058 : DE 00		  ldx	X0000           ; load X with value in 0000
005A : 08		      inx                 ; increment X
005B : 5A		      decb                ; decrement B
005C : 26 EF		  bne	L004C           ; branch != zero PC - EFh (LOOP1)(-17)
005E : 32		      pula                ; pull into A from stack (SP into A)
;*************************************;
;SYNTH1
;*************************************;
005F : 96 0E		  ldaa	X000E         ; load A with value in addr 000E
0061 : B7 80 00		staa	X8000         ; store A in addr 8000 (SOUND)
;LOOP2
0064 : 96 06		  ldaa	X0006         ; load A with value in addr 000F
0066 : 97 0F		  staa	X000F         ; store A in addr 000F
0068 : 96 07		  ldaa	X0007         ; load A with value in addr 0007
006A : 97 10		  staa	X0010         ; store A in addr 0010
;LOOP3
006C : DE 0B		  ldx	X000B           ; load X with value in 000B
;LOOP4
006E : 96 0F		  ldaa	X000F         ; load A with value in addr 000F
0070 : 73 80 00		com	X8000           ; complement 1s in addr 8000 (invert)(SOUND)
;LOOP5
0073 : 09		      dex                 ; decrement X (X = X - 1)
0074 : 27 10		  beq	L0085           ; branch if zero (Z = 1) to PC + 10h (GOTO1)
0076 : 4A		      deca                ; decrement A (A = A - 1)
0077 : 26 FA		  bne	L0072           ; branch != zero PC - FAh (LOOP5)(-6)
0079 : 73 80 00		com	X8000           ; complements 1s in addr 8000 (SOUND)
007C : 96 10		  ldaa	X0010         ; load A with value in 0010
;LOOP6
007E : 09		      dex                 ; decrement X
007F : 27 05		  beq	L0085           ; branch if zero to PC + 05h (GOTO1)(+5)
0081 : 4A		      deca                ; decrement A
0082 : 26 FA		  bne	L007D           ; branch if not equal zero to PC - FAh (LOOP5)(-6)
0084 : 20 E8		  bra	L006D           ; branch always to addr PC - E8h (LOOP4)(-24) 
;GOTO1
0086 : B6 80 00		ldaa	X8000         ; load A with value in addr 8000 (SOUND)
0089 : 2B 01		  bmi	L008B           ; branch if minus (N = 1) to PC + 01h (GOTO2)
008B : 43		      coma                ; complements 1s in A
;GOTO2
008C : 8B 00		  adda	#$00          ; add A with 00h (A = A + 00h)
008E : B7 80 00		staa	X8000         ; store A in addr 8000 (SOUND)
0091 : 96 0F		  ldaa	X000F         ; load A with value in 000F
0093 : 9B 08		  adda	X0008         ; add A with value in addr 0008
0095 : 97 0F		  staa	X000F         ; store A in addr 000F
0097 : 96 10		  ldaa	X0010         ; load A with value in 0010
0099 : 9B 09		  adda	X0009         ; add A with value in addr 0009
009B : 97 10		  staa	X0010         ; store A in addr 0010
009D : 91 0A		  cmpa	X000A         ; compare A with value in addr 000A
009F : 26 CB	  	bne	L006B           ; branch != zero to PC - CBh (LOOP3)(-53)
00A1 : 96 0D		  ldaa	X000D         ; load A with value in 000D
00A3 : 27 06		  beq	L00AA           ; branch if zero to PC + 06h (GOTO3)
00A5 : 9B 06			adda	X0006         ; add A with value in addr 0006
00A7 : 97 06		  staa	X0006         ; store A in addr 0006
00A9 : 26 B9		  bne	L0063           ; branch != zero to PC - B9h (LOOP2)(-71)
;GOTO3
00AB : 8D 05      bsr L00B1           ; branch sub to PIA read PC + 05h
00AD : 86 02		  ldaa	#$02          ; load A with value 02h (0000 0010)
00AF : 7E 00 32		jmp L0032           ; jump to start L0032
;*************************************;
; PIA B read subroutine, need 43 coma?
;*************************************;
00B2 : 4F         clra                ; clear A
00B3 : B6 80 02   ldaa X8002          ; load A with PIA1 B
00B6 : 43         coma                ; complement A 
00B7 : B7 01 0E   staa X010E          ; store A in 010E (param1 waveform)
00BA : B6 40 02   ldaa X4002          ; load A with PIA2 B
00BD : 43         coma                ; complement A
00BE : B7 01 10   staa X0110          ; store A in 0110 (p3) (00 - 0F, 0001 1111, rev on board)
00C1 : 39         rts                 ; return from subroutine
;*************************************;
; must end before 00C4, org 0100 for IC16,IC17
;*************************************;
;CALCOS (calculate offset)
;*************************************;
0100 : DF 00		  stx	X0000           ; store X in 0000
0102 : 9B 01		  adda	X0001         ; add A with value in 0001
0104 : 97 01		  staa	X0001         ; store A in 0001
0106 : 24 05		  bcc	L00BF           ; branch if Carry clear to PC + 05 (GOTO4)
0108 : 7C 00 00		inc	X0000           ; increment value in 0000
010B : DE 00		  ldx	X0000           ; load X with value in 0000
;GOTO4
010D : 39		      rts                 ; return from subroutine
;PARAM WAVEFORM FDB (all are endless loops)
;*************************************;
010E : 28 01 00 08 81 02 00 FF FF     ; FOSHIT, Williams Boot
;*************************************; 

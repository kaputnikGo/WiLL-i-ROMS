; SYNTH1/PARAM1 CODE - 14 Mar 2021
; hack for Heathkit ET-3400 Audio Setup - 2x PIA input params
; user RAM = 197 + 256 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; using PIA1 addr 8000-8003 (DAC, param1)
; and PIA2 addr 8004-8007 (param3)
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second
; using edited subroutines RESET, NMI, PARAM1, CALCOS, UTIL1, SYNTH1
; 
; PIA Addressing changes for breakout board
; fix for PIA2 DDR/CR set using extended addressing
; PIA init code refactoring
;
;*************************************;
; USED RAM ADDR LOCATIONS (typical values)
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
0017 : 6F 02      clr $02,x           ; clear(00) addr X + 02h (set 8002 PIA1 PR/DDR port B in)
0019 : 86 FF		  ldaa	#$FF          ; load A with FFh (1111 1111)
001B : A7 00		  staa	$00,x         ; store A in addr X + 00h (set 8000 PIA1 PR/DDR port A out)
001D : 86 3C		  ldaa	#$3C          ; load A with 3Ch(0011 1100)
001F : A7 01		  staa	$01,x         ; store A in addr X + 01h (8001 PIA1 CR port A)
0021 : 86 37      ldaa  #$37          ; load A with 37h(0011 0111)
0023 : A7 03      staa  $03,x         ; store A in addr X + 03h (8003 PIA1 CR port B) 
0025 : 7F 40 02   clr X4002           ; clear(00) 4002h (set PIA2 PR/DDR port B in)
0028 : 86 04      ldaa  #$04          ; set CR bit 2 high for PIA2
002A : B7 40 03   staa X4003          ; store A in addr 4003 (PIA2 CR port B)
002D : 01         nop                 ;
; ~ all nops here - SPARE
0030 : 01         nop                 ; 
;*************************************;
;NMI - MAIN LOOP start 0031
;*************************************;
0031 : CE FF FF		ldx	#$FFFF          ; load X with value FFFFh ( or 78h )
0034 : 5F		      clrb                ; clear (00) B
0035 : E9 00		  adcb	$00,x         ; add B + X + 00h with Carry into B
0037 : 86 01		  ldaa	#$01          ; load A with value 01h (0000 0001)
;*************************************;
;PARAM1
;*************************************;
0039 : 16		      tab                 ; transfer A to B
003A : 48		      asla                ; shift left in A
003B : 48		      asla                ; shift left in A
003C : 48		      asla                ; shift left in A
003D : 1B		      aba                 ; add A + B into A
003E : CE 00 06		ldx	#$0006          ; load X with value 0006
0041 : DF 02		  stx	X0002           ; store X in addr 0002
0043 : CE 01 0E		ldx	#$010E          ; load X with value 010E (SAW)
0046 : BD	01 00   jsr L0100           ; jump sub CALCOS
0049 : C6 09		  ldab	#$09          ; load B with 09h (0000 1001)
;*************************************;
;UTIL1 - (loop till ACCUM B is zero, while inc X value of VVECT)
;**************************************;
004B : 36		      psha                ; push A into stack(A into SP) 
;LOOP1
004C : A6 00		  ldaa	$00,x         ; load A with value in X + 00h
004E : DF 00		  stx	X0000           ; store X in 0000
0050 : DE 02		  ldx	X0002           ; load X with value in 0002
0052 : A7 00		  staa	$00,x         ; store A in X + 00h
0054 : 08		      inx                 ; increment X
0055 : DF 02		  stx	X0002           ; store X in 0002
0057 : DE 00		  ldx	X0000           ; load X with value in 0000
0059 : 08		      inx                 ; increment X
005A : 5A		      decb                ; decrement B
005B : 26 EF		  bne	L004C           ; branch != zero PC - EFh (LOOP1)(-17)
005D : 32		      pula                ; pull into A from stack (SP into A)
;*************************************;
;SYNTH1
;*************************************;
005E : 96 0E		  ldaa	X000E         ; load A with value in addr 000E
0060 : B7 80 00		staa	X8000         ; store A in addr 8000 (SOUND)
;LOOP2
0063 : 96 06		  ldaa	X0006         ; load A with value in addr 000F
0065 : 97 0F		  staa	X000F         ; store A in addr 000F
0067 : 96 07		  ldaa	X0007         ; load A with value in addr 0007
0069 : 97 10		  staa	X0010         ; store A in addr 0010
;LOOP3
006B : DE 0B		  ldx	X000B           ; load X with value in 000B
;LOOP4
006D : 96 0F		  ldaa	X000F         ; load A with value in addr 000F
006F : 73 80 00		com	X8000           ; complement 1s in addr 8000 (invert)(SOUND)
;LOOP5
0072 : 09		      dex                 ; decrement X (X = X - 1)
0073 : 27 10		  beq	L0085           ; branch if zero (Z = 1) to PC + 10h (GOTO1)
0075 : 4A		      deca                ; decrement A (A = A - 1)
0076 : 26 FA		  bne	L0072           ; branch != zero PC - FAh (LOOP5)(-6)
0078 : 73 80 00		com	X8000           ; complements 1s in addr 8000 (SOUND)
007B : 96 10		  ldaa	X0010         ; load A with value in 0010
;LOOP6
007D : 09		      dex                 ; decrement X
007E : 27 05		  beq	L0085           ; branch if zero to PC + 05h (GOTO1)(+5)
0080 : 4A		      deca                ; decrement A
0081 : 26 FA		  bne	L007D           ; branch if not equal zero to PC - FAh (LOOP5)(-6)
0083 : 20 E8		  bra	L006D           ; branch always to addr PC - E8h (LOOP4)(-24) 
;GOTO1
0085 : B6 80 00		ldaa	X8000         ; load A with value in addr 8000 (SOUND)
0088 : 2B 01		  bmi	L008B           ; branch if minus (N = 1) to PC + 01h (GOTO2)
008A : 43		      coma                ; complements 1s in A
;GOTO2
008B : 8B 00		  adda	#$00          ; add A with 00h (A = A + 00h)
008D : B7 80 00		staa	X8000         ; store A in addr 8000 (SOUND)
0090 : 96 0F		  ldaa	X000F         ; load A with value in 000F
0092 : 9B 08		  adda	X0008         ; add A with value in addr 0008
0094 : 97 0F		  staa	X000F         ; store A in addr 000F
0096 : 96 10		  ldaa	X0010         ; load A with value in 0010
0098 : 9B 09		  adda	X0009         ; add A with value in addr 0009
009A : 97 10		  staa	X0010         ; store A in addr 0010
009C : 91 0A		  cmpa	X000A         ; compare A with value in addr 000A
009E : 26 CB	  	bne	L006B           ; branch != zero to PC - CBh (LOOP3)(-53)
00A0 : 96 0D		  ldaa	X000D         ; load A with value in 000D
00A2 : 27 06		  beq	L00AA           ; branch if zero to PC + 06h (GOTO3)
00A4 : 9B 06			adda	X0006         ; add A with value in addr 0006
00A6 : 97 06		  staa	X0006         ; store A in addr 0006
00A8 : 26 B9		  bne	L0063           ; branch != zero to PC - B9h (LOOP2)(-71)
;GOTO3
00AA : 8D 05      bsr L00B1           ; branch sub to PIA read PC + 05h
00AC : 86 02		  ldaa	#$02          ; load A with value 02h (0000 0010)
00AE : 7E 00 31		jmp L0031           ; jump to start L0031
;*************************************;
; PIA B read subroutine
;*************************************;
00B1 : 4F         clra                ; clear A
00B2 : B6 80 02   ldaa X8002          ; load A with PIA1 B
00B5 : 43         coma                ; complement A 
00B6 : B7 01 0E   staa X010E          ; store A in 010E (p1)
00B9 : B6 40 02   ldaa X4002          ; load A with PIA2 B
00BC : 43         coma                ; complement A
00BD : B7 01 10   staa X0110          ; store A in 0110 (p3)
00C0 : 39         rts                 ; return from subroutine
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
;*************************************;
;PARAM WAVEFORM FDB
;*************************************;
;    :|p1|p2|p3|p4|p5|p6|p7|count     ;
010E : 28 01 00 08 81 02 00 FF FF     ; FOSHIT, Williams Boot
;*************************************; 

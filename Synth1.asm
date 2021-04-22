; SYNTH1/PARAM1 CODE - 22 Mar 2021
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
; Defender ROM source code annotations as (note) in comments
;
;*
;*TEMPORARIES
;*
TMPRAM   EQU  *        ;TEMPORARY RAM
TEMPX    RMB  2        ;X TEMPS
XPLAY    RMB  2
XPTR     RMB  2
TEMPA    RMB  1        ;ACCA TEMP
TEMPB    RMB  1
LOCRAM   EQU  *
;*
;*VARIWAVE PARAMETERS
;*
         ORG  LOCRAM
LOPER    RMB  1        ;LO PERIOD
HIPER    RMB  1        ;HIPERIOD
LODT     RMB  1        ;PERIOD DELTAS
HIDT     RMB  1
HIEN     RMB  1        ;END PERIOD
SWPDT    RMB  2        ;SWEEP PERIOD
LOMOD    RMB  1        ;BASE FREQ MOD
VAMP     RMB  1        ;AMPLITUDE
LOCNT    RMB  1        ;PERIOD COUNTERS
HICNT    RMB  1
;
;*************************************;
; USED RAM ADDR LOCATIONS (typical values)
;*************************************;
0000 : 00 24                          ; XPLAY, XPLAY+1
0002 : 01 08                          ; XPTR, XPTR+1
0004 : 00 18                          ; X
0006 : nn 01                          ; LOPER, HIPER
0008 : 00 08                          ; LODT, HIDT
000A : 81 02                          ; HIEN, SWDPT
000C : 00 FF                          ; -, LOMOD
000E : FF nn                          ; VAMP, LOCNT
0010 : nn                             ; HICNT
;*************************************;
;RESET INIT (POWER-ON) org 0011
;*************************************;
0011 : 8E 01 FF   lds #$01FF          ; load SP with 01FFh
0014 : CE 80 00   ldx #$8000          ; load X with 8000h, PIA1 (DAC) addr
0017 : 6F 02      clr $02,x           ; clear(00) addr X + 02h (set 8002 PIA1 PR/DDR port B in)
0019 : 86 FF      ldaa #$FF           ; load A with FFh (1111 1111)
001B : A7 00      staa $00,x          ; store A in addr X + 00h (set 8000 PIA1 PR/DDR port A out)
001D : 86 3C      ldaa #$3C           ; load A with 3Ch(0011 1100)
001F : A7 01      staa $01,x          ; store A in addr X + 01h (8001 PIA1 CR port A)
0021 : 86 37      ldaa  #$37          ; load A with 37h(0011 0111)
0023 : A7 03      staa  $03,x         ; store A in addr X + 03h (8003 PIA1 CR port B) 
0025 : 7F 40 02   clr $4002           ; clear(00) 4002h (set PIA2 PR/DDR port B in)
0028 : 86 04      ldaa  #$04          ; set CR bit 2 high for PIA2
002A : B7 40 03   staa $4003          ; store A in addr 4003 (PIA2 CR port B)
002D : 01         nop                 ;
; ~ all nops here - SPARE
0030 : 01         nop                 ; 
;*************************************;
;NMI - MAIN LOOP start 0031
;*************************************;
0031 : CE FF FF  ldx #$FFFF           ; load X with value FFFFh ( or 78h )
0034 : 5F        clrb                 ; clear (00) B
0035 : E9 00     adcb $00,x           ; add B + X + 00h with Carry into B
0037 : 86 01     ldaa #$01            ; load A with value 01h (0000 0001)
;*************************************;
;PARAM1 - Vari Loader
;*************************************;
;VARILD
0039 : 16        tab                  ; transfer A to B
003A : 48        asla                 ; shift left in A (X2)
003B : 48        asla                 ; shift left in A (X4)
003C : 48        asla                 ; shift left in A (X8)
003D : 1B        aba                  ; add A + B into A (X9)
003E : CE 00 06  ldx #$0006           ; load X with value 0006 (#LOCRAM)
0041 : DF 02     stx $02              ; store X in addr 02 (XPTR)(SET XSFER)
0043 : CE 01 0E  ldx #$010E           ; load X with value 010E (VVECT FOSHIT)
0046 : BD 01 00  jsr L0100            ; jump sub CALCOS (ADDX)
0049 : C6 09     ldab #$09            ; load B with 09h (COUNT)
;*************************************;
;UTIL1 - Parameter Transfer
;**************************************;
;TRANS
004B : 36        psha                 ; push A into stack(A into SP) 
;TRANS1
004C : A6 00     ldaa $00,x           ; load A with value in X + 00h
004E : DF 00     stx $00              ; store X in 00 (XPLAY)
0050 : DE 02     ldx $02              ; load X with value in 02 (XPTR)
0052 : A7 00     staa $00,x           ; store A in X + 00h
0054 : 08        inx                  ; increment X
0055 : DF 02     stx $02              ; store X in 02 (XPTR)
0057 : DE 00     ldx $00              ; load X with value in 00 (XPLAY)
0059 : 08        inx                  ; increment X
005A : 5A        decb                 ; decrement B
005B : 26 EF     bne L004C            ; branch if Z=0 PC - EFh (TRANS1)(-17)
005D : 32        pula                 ; pull into A from stack (SP into A)
;*************************************;
;SYNTH1 - Variable Duty Cycle Square Wave Routine
;*************************************;
;VARI
005E : 96 0E     ldaa $0E             ; load A with value in addr 0E (VAMP)
0060 : B7 80 00  staa $8000           ; store A in addr 8000 (SOUND)
;VAR0
0063 : 96 06     ldaa $06             ; load A with value in addr 06 (LOPER)
0065 : 97 0F     staa $0F             ; store A in addr 0F (LOCNT)
0067 : 96 07     ldaa $07             ; load A with value in addr 07 (HIPER)
0069 : 97 10     staa $10             ; store A in addr 10 (HICNT)
;V0
006B : DE 0B     ldx $0B              ; load X with value in 0B (SWDPT)
;V0LP
006D : 96 0F     ldaa $0F             ; load A with value in addr 0F (LOCNT)(LO CYCLE)
006F : 73 80 00  com $8000            ; complement 1s in addr 8000 (invert)(SOUND)
;V1
0072 : 09        dex                  ; decrement X
0073 : 27 10     beq L0085            ; branch if Z=1 to PC + 10h (VSWEEP)
0075 : 4A        deca                 ; decrement A (A = A - 1)
0076 : 26 FA     bne L0072            ; branch if Z=0 PC - FAh (V1)(-6)
0078 : 73 80 00  com $8000            ; complements 1s in addr 8000 (SOUND)
007B : 96 10     ldaa $10             ; load A with value in 10 (HICNT)(HI CYCLE)
;V2
007D : 09        dex                  ; decrement X
007E : 27 05     beq L0085            ; branch if Z=1 to PC + 05h (VSWEEP)(+5)
0080 : 4A        deca                 ; decrement A
0081 : 26 FA     bne L007D            ; branch if Z=0 to PC - FAh (V2)(-6)
0083 : 20 E8     bra L006D            ; branch always to addr PC - E8h (V0LP)(LOOP BACK)(-24) 
;VSWEEP
0085 : B6 80 00  ldaa $8000           ; load A with value in addr 8000 (SOUND)
0088 : 2B 01     bmi L008B            ; branch if N=1 to PC + 01h (VS1)
008A : 43        coma                 ; complements 1s in A
;VS1
008B : 8B 00     adda #$00            ; add A with 00h
008D : B7 80 00  staa $8000           ; store A in addr 8000 (SOUND)
0090 : 96 0F     ldaa $0F             ; load A with value in 0F (LOCNT)
0092 : 9B 08     adda $08             ; add A with value in addr 08 (LODT)
0094 : 97 0F     staa $0F             ; store A in addr 0F (LOCNT)
0096 : 96 10     ldaa $10             ; load A with value in 10 (HICNT)
0098 : 9B 09     adda $09             ; add A with value in addr 09 (HIDT)
009A : 97 10     staa $10             ; store A in addr 10 (HICNT)
009C : 91 0A     cmpa $0A             ; compare A with value in addr 0A (HIEN)
009E : 26 CB     bne L006B            ; branch if Z=0 to PC - CBh (V0)(-53)
00A0 : 96 0D     ldaa $0D             ; load A with value in 0D (LOMOD)
00A2 : 27 06     beq L00AA            ; branch if Z=1 to PC + 06h (VARX)
00A4 : 9B 06     adda $06             ; add A with value in addr 06 (LOPER)
00A6 : 97 06     staa $06             ; store A in addr 06 (LOPER)
00A8 : 26 B9     bne L0063            ; branch if Z=0 to PC - B9h (VAR0)(-71)
;VARX
00AA : 8D 05     bsr L00B1            ; branch sub to PIA read PC + 05h <--not in original
00AC : 86 02     ldaa #$02            ; load A with value 02h (0000 0010) <--not in original
00AE : 7E 00 31  jmp L0031            ; jump to start L0031
;*************************************;
; PIA B read subroutine
;*************************************;
00B1 : 4F        clra                 ; clear A
00B2 : B6 80 02  ldaa $8002           ; load A with PIA1 B
00B5 : 43        coma                 ; complement A 
00B6 : B7 01 0E  staa $010E           ; store A in 010E (p1)
00B9 : B6 40 02  ldaa $4002           ; load A with PIA2 B
00BC : 43        coma                 ; complement A
00BD : B7 01 10  staa $0110           ; store A in 0110 (p3)
00C0 : 39        rts                  ; return from subroutine
;*************************************;
; must end before 00C4, org 0100 for IC16,IC17
;*************************************;
;CALCOS - Add A to Index Register
;*************************************;
;ADDX
0100 : DF 00     stx $00              ; store X in 00 (XPLAY)
0102 : 9B 01     adda $01             ; add A with value in 01 (XPLAY+1)
0104 : 97 01     staa $01             ; store A in 01 (XPLAY+1)
0106 : 24 05     bcc L00BF            ; branch if Carry clear to PC + 05 (ADDX1)
0108 : 7C 00 00  inc $0000            ; increment value in 0000 (XPLAY)
010B : DE 00     ldx $00              ; load X with value in 00 (XPLAY)
;ADDX1
010D : 39        rts                  ; return from subroutine
;*************************************;
;PARAM WAVEFORM FDB - Vari Vector
;*************************************;
;    :|p1|p2|p3|p4|p5|p6|p7|count     ;
010E : 28 01 00 08 81 02 00 FF FF     ; FOSHIT, Williams Boot
;*************************************; 


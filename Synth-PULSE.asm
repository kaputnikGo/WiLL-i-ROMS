; PULSE (CHIMES) SOUNDS CODE - 05 June 2021
; hack for Heathkit ET-3400 Audio Setup
; user RAM = 196 + 255 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; addr 00C5 to 00FF is Monitor RAM
; using PIA addr 8000, 4000 (DAC 8000 not 0400)
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second
; using edited subroutines IRQ, PULSE, ADDX, TRANS
;
; IRQ BIT40 test (0100 0000) Chimes or Electronic sounds switch  DS1-1 -> byte6
;
; SW demo :
; [---- ---- ---- ----]
;
;LOCRAM:
;CYCL1$  RMB  1       ;CYCLE COUNTER 1          : 0018
;CYCL2$  RMB  1       ;CYCLE COUNTER 2          : 0019
;CYCL3$  RMB  1       ;CYCLE COUNTER 3          : 001A
;XPTR    RMB  2       ;                         : 0022-0023
;XPLAY   RMB  2       ;                         : 0024-0025

;*************************************;
; Scratch RAM 
;*************************************;
0000 : 00 00                          ; start SNDTBL
0002 : 00 00                          ;
0004 : 00 00                          ;
0006 : 00 00                          ;
0008 : 00 00                          ;
000A : 00 00                          ; 
000C : 00 00                          ;
000E : 00 00                          ; end SNDTBL
0010 : 00 00                          ;
;*************************************;
;INIT 0010 - org 0010
;*************************************;
0010 : 8E 01 FF   lds #$01FF          ; load SP with 01FFh
0013 : CE 80 00   ldx #$8000          ; load X with 8000h, PIA1 (DAC) addr
0016 : 6F 02      clr $02,x           ; clear(00) addr X + 02h (set 8002 PIA1 PR/DDR port B in)
0018 : 86 FF      ldaa  #$FF          ; load A with FFh (1111 1111)
001A : A7 00      staa  $00,x         ; store A in addr X + 00h (set 8000 PIA1 PR/DDR port A out)
001C : 86 3C      ldaa  #$3C          ; load A with 3Ch(0011 1100)
001E : A7 01      staa  $01,x         ; store A in addr X + 01h (8001 PIA1 CR port A)
0020 : 86 37      ldaa  #$37          ; load A with 37h(0011 0111)
0022 : A7 03      staa  $03,x         ; store A in addr X + 03h (8003 PIA1 CR port B) 
0024 : 7F 40 02   clr $4002           ; clear(00) 4002h (set PIA2 PR/DDR port B in)
0027 : 86 04      ldaa  #$04          ; set CR bit 2 high for PIA2
0029 : B7 40 03   staa $4003          ; store A in addr 4003 (PIA2 CR port B)
;*************************************;
;PIA reads - 002C
;*************************************;
002C : B6 80 02   ldaa  $8002         ;load A with PIA1 B
002F : 97 0C      staa  $0C           ;store A in addr 0C
0031 : B6 40 02   ldaa  $4002         ;load A with PIA2 B
0034 : 97 0D      staa  $0D           ;store A in addr 0D
;*************************************;
;IRQ - need A to equal valid 0Fh or below
;*************************************;
7B7F : 85 40      bita #$40           ;bit test A with value 40h
7B81 : 26 83      bne L7B06           ;branch Z=0 PULSE <-- changed addr 7B12 PLDR
;*************************************;
;Pulse synth - Chimes replacement
;*************************************;
;- mask garb
7B06 : 84 1F      anda #$1F           ;and A with value 1Fh (may change Sign,Zero status bits)
7B08 : 27 FE      beq L7B08           ;branch Z=1 PULSE1
;- check != 11h (0001 0001)
7B0A : 81 11      cmpa #$11           ;compare A with value 11h
7B0C : 27 FE      beq L7B0C           ;branch Z=1 (*)
;- check != 12h (0001 0010)
7B0E : 81 12      cmpa #$12           ;compare A with value 12h
7B10 : 27 FE      beq L7B10           ;branch Z=1 (*)
;
;PLDR - loader
7B12 : 84 0F      anda #$0F           ;and A with value 0Fh
7B14 : CE 7B F4   ldx #$7BF4          ;load X with value 7BF4h (NOTTBL)
7B17 : BD 7B B4   jsr L7BB4           ;jump sub ADDX
7B1A : A6 00      ldaa $00,x          ;load A with addr X+00h
7B1C : 97 18      staa $18            ;store A in addr 18 (CYCL1$)
7B1E : CE 7B E4   ldx #$7BE4          ;load X with value 7BE4h (SNDTBL)
7B21 : C6 10      ldab #$10           ;load B with value 10h
7B23 : BD 7A 13   jsr L7A13           ;jump sub TRANS
7B26 : CE 7C 04   ldx #$7C04          ;load X with value 7C04h (WAVFRM)
7B29 : E6 00      ldab $00,x          ;load B with addr X+00h
;PMLP - main loop
7B2B : D7 1A      stab $1A            ;store B in addr 1A (CYCL3$)
7B2D : DF 22      stx $22             ;store X in addr 22
;PLP3 - CYCL3$ loop
7B2F : CE 00 00   ldx #$0000          ;load X with value 0000h
7B32 : C6 08      ldab #$08           ;load B with value 08h
7B34 : D7 19      stab $19            ;store B in addr 19 (CYCL2$)
;PLP2 - CYCL2$ loop
7B36 : A6 00      ldaa $00,x          ;load A with value in addr X
7B38 : D6 18      ldab $18            ;load B with value in addr 18 (CYCL1$)
7B3A : 7D 00 1A   tst $001A           ;test value in addr 001A (CYCL3$)
7B3D : 26 06      bne L7B45           ;branch Z=0 POUT1
7B3F : A0 08      suba $08,x          ;subtract B with value in X,08h
7B41 : A7 00      staa $00,x          ;store A in addr X
7B43 : C0 03      subb #$03           ;subtract B with value 03h
;POUT1 - adv X and output A
7B45 : 08         inx                 ;increment X
7B46 : B7 84 00   staa $8400          ;store A in DAC output SOUND 
;PLP1 - CYCL1$ loop
7B49 : 5A         decb                ;decr B
7B4A : 26 FD      bne L7B49           ;branch Z=0 PLP1
;
7B4C : 7A 00 19   dec $0019           ;decr value in addr 0019 (CYCL2$)
7B4F : 26 E5      bne L7B36           ;branch Z=0 PLP2
;
7B51 : 7A 00 1A   dec $001A           ;decr value in addr 001A (CYCL3$)
7B54 : 2A D9      bpl L7B2F           ;branch N=0 PLP3
;
7B56 : DE 22      ldx $22             ;load X with value in addr 22
7B58 : 08         inx                 ;incr X
7B59 : E6 00      ldab $00,x          ;load B with value in addr X
7B5B : 26 CE      bne L7B2B           ;branch Z=0 PMLP
;
;POUT2 - load amp and output
7B5D : 86 80      ldaa #$80           ;load A with value 80h
7B5F : B7 84 00   staa $8400          ;store A in DAC output SOUND 
;PEXIT 
7B62 : 3E         wai                 ;wait for interrupt, PC+1
7B63 : 20 A1      bra L7B06           ;branch always PULSE <-- changed addr 7B12 PLDR
;*************************************;
;ADD A TO INDEX REGISTER
;*************************************;
;ADDX 
7BB4 : DF 24      stx $24             ;store X in addr 24 (XPLAY)
7BB6 : 9B 25      adda $25            ;add A with value in addr 25 (XPLAY+1)
7BB8 : 97 25      staa $25            ;store A in addr 25 (XPLAY+1)
7BBA : 96 24      ldaa $24            ;load A with value in addr 24 (XPLAY)
7BBC : 89 00      adca #$00           ;A = C + A + 00h
7BBE : 97 24      staa $24            ;store A in addr 24 (XPLAY)
7BC0 : DE 24      ldx $24             ;load X with value at addr 09 (XPLAY)
7BC2 : 39         rts                 ;return subroutine
;*************************************;
;Parameter Transfer
;*************************************;
;TRANS:
7A13 : 36         psha                ;push A into stack then SP - 1
;TRANS1
7A14 : A6 00      ldaa $00,x          ;load A with X
7A16 : DF 24      stx $24             ;store X in addr 24 (XPLAY)
7A18 : DE 22      ldx $22             ;load X with value in addr 22 (XPTR)
7A1A : A7 00      staa $00,x          ;store A in addr X
7A1C : 08         inx                 ;incr X
7A1D : DF 22      stx $22             ;store X in addr 22 (XPTR)
7A1F : DE 24      ldx $24             ;load X with value in addr 24 (XPLAY)
7A21 : 08         inx                 ;incr X
7A22 : 5A         decb                ;decr B
7A23 : 26 EF      bne L7A14           ;branch Z=0 TRANS1
7A25 : 32         pula                ;SP + 1 pull stack into A
7A26 : 39         rts                 ;return subroutine
;*************************************;
;data tables for PULSE
;*************************************;
;SNDTBL : TRANS (store 10h (#16) vars)
7BE4 : DA FF DA 80 26 01 26 80
7BEC : 07 0A 07 00 F9 F6 F9 00 
;NOTTBL : #NOTTBL = (ADDX (A <=0F + X(#NOTTBL)) )
7BF4 : 3A 3E 50 46 33 2C 27 20 
7BFC : 25 1C 1A 17 14 11 10 33
;WAVFRM
7C04 : 08 03 02 01 02 03 04 05
7C0C : 06 0A 1E 32 70 00 

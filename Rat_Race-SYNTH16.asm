; SOUND ROM ?? (Rat Race) Synth16 CODE - 27 Apr 2021
; hack for Heathkit ET-3400 Audio Setup
; user RAM = 196 + 255 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; addr 00C5 to 00FF is Monitor RAM
; using PIA addr 8000, 4000 (DAC 8000 not 8400)
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second
; using edited subroutines SYNTH16
; working, a bit random with PIAs
;
; SW demo (inverted + reversed):
; [1001 1100 | 0101 0101]
;
;*************************************;
; Scratch RAM (0000-0009)
;*************************************;
0000 : 00 00                          ;-, -
0002 : nn nn                          ;A(05), B(06)
0004 : nn nn                          ;B(90), A(91)
0006 : nn 00                          ;B(AC), -
0008 : 00 00                          ;PIA reads
;*************************************;
;INIT - org 000A
;*************************************;
000A : 8E 01 FF   lds #$01FF          ; load SP with 01FFh
000D : CE 80 00   ldx #$8000          ; load X with 8000h, PIA1 (DAC) addr
0010 : 6F 02      clr $02,x           ; clear(00) addr X + 02h (set 8002 PIA1 PR/DDR port B in)
0012 : 86 FF      ldaa  #$FF          ; load A with FFh (1111 1111)
0014 : A7 00      staa  $00,x         ; store A in addr X + 00h (set 8000 PIA1 PR/DDR port A out)
0016 : 86 3C      ldaa  #$3C          ; load A with 3Ch(0011 1100)
0018 : A7 01      staa  $01,x         ; store A in addr X + 01h (8001 PIA1 CR port A)
001A : 86 37      ldaa  #$37          ; load A with 37h(0011 0111)
001C : A7 03      staa  $03,x         ; store A in addr X + 03h (8003 PIA1 CR port B) 
001E : 7F 40 02   clr $4002           ; clear(00) 4002h (set PIA2 PR/DDR port B in)
0021 : 86 04      ldaa  #$04          ; set CR bit 2 high for PIA2
0023 : B7 40 03   staa $4003          ; store A in addr 4003 (PIA2 CR port B)
;*************************************;
;PIA reads - 0026
;*************************************;
;PIA
0026 : B6 80 02   ldaa  $8002         ;load A with PIA1 B
0029 : 97 08      staa  $08           ;store A in addr 08
002B : B6 40 02   ldaa  $4002         ;load A with PIA2 B
002E : 97 09      staa  $09           ;store A in addr 09
;*************************************;
;SYNTH16 - 0030
;*************************************;
0030 : C6 11      ldab #$11           ;load B with value 11h <--
0032 : D7 03      stab $03            ;store B in addr 03
;0034 : 86 FE      ldaa #$FE           ;load A with value FEh <-- good param (7F tremolo like)
0034 : 96 08      ldaa $08            ;load A with value in addr 08 (PIA1)
0036 : 97 02      staa $02            ;store A in addr 02
0038 : 86 9F      ldaa #$9F           ;load A with value 9Fh
;003A : D6 03      ldab $03            ;load B with value in addr 03
003A : D6 09      ldab $09            ;load B with valu ein addr 09 (PIA2)
;SYN161
003C : CE 01 C0   ldx #$01C0          ;load X with value 01C0h <-- change (01FF) pitch, frequency
;003C : DE 08      ldx $08             ;load X with value in addr 08 (both PIA reads) (start freq)
;003E : 01         nop                 ;
;SYN162
003F : 09         dex                 ;decr X
0040 : 27 20      beq L0062           ;branch Z=1 SYN165
0042 : F7 00 04   stab $0004          ;store B in addr 0004
0045 : B7 80 00   staa $8000          ;store A in SOUND
;SYN163
0048 : 09         dex                 ;decr X
0049 : 27 17      beq L0062           ;branch Z=1 SYN165
004B : 7A 00 04   dec $0004           ;decr value in addr 0004
004E : 26 F8      bne L0048           ;branch Z=0 SYN163
0050 : 09         dex                 ;decr X
0051 : 27 0F      beq L0062           ;branch Z=1 SYN165
0053 : D7 04      stab $04            ;store B in addr 04
0055 : 73 80 00   com $8000           ;complement 1s in SOUND
;SYN164
0058 : 09         dex                 ;decr X
0059 : 27 07      beq L0062           ;branch Z=1 SYN165
005B : 7A 00 04   dec $0004           ;decr value in addr 0004
005E : 26 F8      bne L0058           ;branch Z=0 SYN164
0060 : 20 DD      bra L003F           ;branch always SYN162
;SYN165
0062 : D0 02      subb $02            ;subtract B with value in addr 02
0064 : C1 10      cmpb #$10           ;compare B with value 10h
0066 : 22 D4      bhi L003C           ;branch C+Z=0 SYN161
0068 : 20 BC      bra L0026           ;branch always PIA
;006A : end





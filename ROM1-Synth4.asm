; SOUND ROM 1 (Flash) Funny "Electric Sound" (PARAM8) CODE - 22 Apr 2021
; hack for Heathkit ET-3400 Audio Setup
; user RAM = 196 + 255 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; addr 00C5 to 00FF is Monitor RAM
; using PIA addr 8000, 4000 (DAC 8000 not 8400)
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second
; using edited subroutines PARAM8, SYNTH4, PARAM9
;
;
; SW demo :
; [---- ---- ---- ----]
;
;*************************************;
; Scratch RAM (0000-0025)
;*************************************;
0000 : nn nn                          ;FREQ1, FREQ2
0002 : 00 00                          ;-, -
0004 : nn nn                          ;PIA1, PIA2
0006 : nn 00                          ;SNDX1, -
0008 : 00 00                          ; 
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
0026 : B6 80 02   ldaa  $8002         ;load A with PIA1 B
0029 : 97 04      staa  $04           ;store A in addr 04
002B : B6 40 02   ldaa  $4002         ;load A with PIA2 B
002E : 97 05      staa  $05           ;store A in addr 05
;*************************************;
;Funny "Electric Sound" (PARAM8) - 0030 (sweep up fast)
;*************************************;
;note from source:
;* SUPPOSED TO GENERATE A PHASED OUTPUT AT
;* A CHANGING FREQUENCY. IT DOESN'T, AND
;* I'M NOT SURE EXACTLY WHAT IT DOES DO.
;* BEST LEAVE THIS ALONE.
;
;BONUS
0030 : 7A 00 06   dec $0006           ;decr addr 0006 (SNDX1)
0033 : 20 04      bra L79D4           ;branch always (SND1$)
;SND1
0035 : C6 A0      ldab #$A0           ;load B with value A0h (alt 11h) <-- poss param 7F, max FF, min 20
0037 : D7 06      stab $06            ;store B in addr 06 (SNDX1)
;SND1$
0039 : 86 04      ldaa #$04           ;load A with value 04h (alt FEh) speed <-- poss param 10, max 6E, min 02
003B : 97 01      staa $01            ;store A in addr 01 (FREQ2)
;SND1$$
003D : 86 9F      ldaa #$9F           ;load A with value 9Fh
003F : D6 06      ldab $06            ;load B with value in addr 06 (SNDX1)
;SND1A
0041 : CE 01 C0   ldx #$01C0          ;load X with value 01C0h <-- poss param
;SND1B
0044 : 09         dex                 ;decr X
0045 : 27 20      beq L7A02           ;branch Z=1 (SND1E)
;79E2 : F7 00 00   stab $0000         ;<- disasm/source confusion (FCB $F7 "STAB")
0047 : F7                             ;$F7 "STAB"
0048 : 00 00                          ;FDB FREQ1
004A : B7 80 00   staa $8000          ;store A in DAC output SOUND 
;SND1C
004D : 09         dex                 ;decr X
004E : 27 17      beq L7A02           ;branch Z=1 (SND1E)
0050 : 7A 00 00   dec $0000           ;decr addr 0000h (FREQ1)
0053 : 26 F8      bne L79E8           ;branch Z=0 (SND1C)
0055 : 09         dex                 ;decr X
0056 : 27 0F      beq L7A02           ;branch Z=1 (SND1E)
0058 : D7 00      stab $00            ;store B in addr 00 (FREQ1)
005A : 73 80 00   com $8000           ;complement 1s DAC output SOUND 
;SND1D
005D : 09         dex                 ;decr X
005E : 27 07      beq L7A02           ;branch Z=1 (SND1E)
0060 : 7A 00 00   dec $0000           ;decr addr 0000 (FREQ1)
0063 : 26 F8      bne L79F8           ;branch Z=0 (SND1D)
0065 : 20 DD      bra L79DF           ;branch always (SND1B)
;SND1E
0067 : D0 01      subb $01            ;subtract B with value in addr 01 (FREQ2)
0069 : C1 10      cmpb #$10           ;compare B with value 10h
006B : 22 D4      bhi L79DC           ;branch C+Z=0 (SND1A)
006D : 20 C6      bra L0035           ;branch always (SND1)
;*************************************;
;START (PARAM9) - alternate entry point, SNDX1, FREQ2 values only (sweep down slow)
;*************************************;
006F : C6 11      ldab #$11           ;load B with value 11h
0071 : D7 06      stab $06            ;store B in addr 06 (SNDX1)
0073 : 86 FE      ldaa #$FE           ;load A with value FEh
0075 : 97 01      staa $01            ;store A in addr 01 (FREQ2)
0077 : 20 C5      bra L79D8           ;branch always (SND1$$)
;*************************************;
;0079 : end




; FLASH SOUND ROM 1 SYNTH1 + SYNTH2 CODE - 24 Apr 2021
; hack for Heathkit ET-3400 Audio Setup
; user RAM = 196 + 255 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; addr 00C5 to 00FF is Monitor RAM
; using PIA addr 8000, 4000 (DAC 8000 not 8400)
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second
; using edited subroutines SYNTH1, SYNTH2, CALCOS 
;
; combine 2 small synth routines into one Heathkit routine
;
; SW demo :
; [---- ---- ---- ----]
;
;*************************************;
; Scratch RAM (0000-000F)
;*************************************;
0000 : 00 00                          ;FREQ1,FREQ2
0002 : 00 00                          ;FREQ3,FREQ4
0004 : 00 00                          ;XPTR,XPTR+1
0006 : 00 00                          ;XPLAY,XPLAY+1
0008 : 00 00                          ;
000A : 00 00                          ;
000C : 00 00                          ;
000E : 00 00                          ;PIA reads
;*************************************;
;INIT - org 0010
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
;PIA
002C : B6 80 02   ldaa  $8002         ;load A with PIA1 B
002F : 97 0E      staa  $0E           ;store A in addr 0E
0031 : B6 40 02   ldaa  $4002         ;load A with PIA2 B
0034 : 97 0F      staa  $0F           ;store A in addr 0F
0036 : 8D 23      bsr L005B           ;branch sub SYNTH2
0038 : 8D 02      bsr L003C           ;branch sub PLANE (endless loop)
003A : 20 F0      bra L002C           ;branch always PIA
;*************************************;
;Diving Plane Sound (SYNTH1) - 003C (Sound 20 in Sound ROM 1)
;*************************************;
;PLANE
003C : CE 00 01   ldx #$0001          ;load X with value 0001h (SET FOR SHORT HALF CYCLE)(alt #448 = 1C0h)
003F : DF 00      stx $00             ;store X in addr 00 (FREQ1)(SAVE VALUE)
;below is start pitch: (#448 = 1C0h)(#1344 = 540h)
0041 : CE 03 80   ldx #$0380          ;load X with value 0380h (SET FOR LONG HALF CYCLE)(#896)
0044 : DF 02      stx $02             ;store X in addr 02 (FREQ3)(SAVE VALUE)
;L795B PLANE1:
0046 : 7F 80 00   clr $8000           ;clear DAC output SOUND  (SEND OUT ZEROES)
0049 : DE 00      ldx $00             ;load X with value in addr 00 (FREQ1)(GET LOW HALF CYCLE DATA)
004B : 08         inx                 ;incr X (INCREASE HALF CYCLE)
004C : DF 00      stx $00             ;store X in addr 00 (FREQ1)(SAVE NEW VALUE)
;L7963 PLANE2:
004E : 09         dex                 ;decr X (COUNT DOWN)
004F : 26 FD      bne L004E           ;branch Z=0 (PLANE2)
0051 : 73 80 00   com $8000           ;complement 1s DAC output SOUND (SEND OUT ONES)
0054 : DE 02      ldx $02             ;load X with value in addr 02 (FREQ3)(GET HIGH HALF CYCLE DATA)
;L796B PLANE3:
0056 : 09         dex                 ;decr X (COUNT DOWN)
0057 : 26 FD      bne L0056           ;branch Z=0 (PLANE3)
0059 : 20 EB      bra L0046           ;branch always (PLANE1) <-- need a break from this loop
;*************************************;
;SYNTH2 - 005B (Sound 09 in Sound ROM 1)
;*************************************;
;SYNTH2
005B : 5F         clrb                ;clear B
005C : F7 80 00   stab $8000          ;store B in DAC output SOUND 
005F : CE 00 DF   ldx #$00DF          ;load X with value 00DFh
;SYN21 L7977:
0062 : 86 20      ldaa #$20           ;load A with value 20h <-- param? (10 long, 80 short)
0064 : BD 00 7C   jsr L007C           ;jump sub CALCOS
;SYN22 L797C:
0067 : 09         dex                 ;decr X
0068 : 26 FD      bne L0067           ;branch Z=0 SYN22
006A : 73 80 00   com $8000           ;complement 1s DAC output SOUND 
;SYN23 L7982:
006D : 5A         decb                ;decr B
006E : 26 FD      bne L006D           ;branch Z=0 SYN23
0070 : 73 80 00   com $8000           ;complement 1s DAC output SOUND 
0073 : 96 06      ldaa $06            ;load A with value in addr 06(XPLAY) 
0075 : DE 06      ldx $06             ;load X with value in addr 06(XPLAY)
0077 : 85 10      bita #$10           ;bit test A with value 10h <-- param? (20 check till lower amp?)
0079 : 27 E7      beq L0062           ;branch Z=1 SYN21
007B : 39         rts                 ;return subroutine
;*************************************;
;CALCOS - ADDX - ADD A TO INDEX REGISTER - 007C
;*************************************;
;ADDX L7BB4:
007C : DF 06      stx $06             ;store X in addr 06 (XPLAY)
007E : 9B 07      adda $07            ;add A with value in addr 07(XPLAY+1) 
0080 : 97 07      staa $07            ;store A in addr 07 (XPLAY+1)
0082 : 96 06      ldaa $06            ;load A with value in addr 06 (XPLAY)
0084 : 89 00      adca #$00           ;A = C + A + 00h
0086 : 97 06      staa $06            ;store A in addr 06 (XPLAY)
0088 : DE 06      ldx $06             ;load X with value at addr 06 (XPLAY)
008A : 39         rts                 ;return subroutine
;008B : end


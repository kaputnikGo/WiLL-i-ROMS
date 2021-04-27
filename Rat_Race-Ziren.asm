; SOUND ROM ?? (Rat Race) Ziren CODE - 27 Apr 2021
; hack for Heathkit ET-3400 Audio Setup
; user RAM = 196 + 255 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; addr 00C5 to 00FF is Monitor RAM
; using PIA addr 8000, 4000 (DAC 8000 not 8400)
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second
; using edited subroutines PARAM11 (Ziren), SYNTH9
; source from Robotron
;
; SW demo (inverted + reversed):
; [---- ---- | ---- ----]
;
;* SIREN RAM
;  ORG  LOCRAM
;TOP    RMB  2
;SWEEP  RMB  2
;SLOPE  RMB  1
;END2   RMB  2
;
;*************************************;
; Scratch RAM (0000-0009)
;*************************************;
0000 : nn 00                          ;SLOPE, -
0002 : nn nn                          ;END2 (95), END2+1 (96)
0004 : nn nn                          ;SWEEP (92), SWEEP+1(93)
0006 : nn nn                          ;TOP (90), TOP+1 (91)
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
;Siren Air Raid (PARAM11) - 0030
;*************************************;
;ZIREN:
0030 : 86 FF      ldaa #$FF           ;load A with value FFh <-- param 7Fh, 40h
0032 : 97 06      staa $06            ;store A in addr 06 (TOP)
0034 : CE FE C0   ldx #$FEC0          ;load X with value FEC0h
0037 : DF 04      stx $04             ;store X in addr 04 (SWEEP)
0039 : 86 20      ldaa #$20           ;load A with value 20h <-- param : woah! 80h, 66h
003B : CE FF E0   ldx #$FFE0          ;load X with value FFE0h
003E : 8D 05      bsr L0045           ;branch sub ZIREN0
0040 : 86 01      ldaa #$01           ;load A with value 01h
0042 : CE 00 44   ldx #$0044          ;load X with value 0044h 
;ZIREN0:
0045 : 97 00      staa $00            ;store A in addr 00 (SLOPE)
0047 : DF 95      stx $02             ;store X in addr 02 (END2)
;ZIREN1:
0049 : CE 00 10   ldx #$0010          ;load X with value 0010h <-- 7Fh (length of 3rd + loop)
;ZIREN2:
004C : 8D 21      bsr L0070           ;branch sub SYNTH9 (ZIRLOP)
004E : 96 07      ldaa $07            ;load A with value in addr 07 (TOP+1)
0050 : 9B 05      adda $05            ;and A with value in addr 05 (SWEEP+1)
0052 : 97 91      staa $91            ;store A in addr 91 (TOP+1)
0054 : 96 06      ldaa $06            ;load A with value in addr 06 (TOP)
0056 : 99 04      adca $04            ;add C+A + value in addr 04 (SWEEP)
0058 : 97 06      staa $06            ;store A in addr 06 (TOP)
005A : 09         dex                 ;decr X
005B : 26 EF      bne L004C           ;branch Z=0 ZIREN2
005D : 96 05      ldaa $05            ;load A with value in addr 05 (SWEEP+1)
005F : 9B 00      adda $00            ;add A with value in addr 00 (SLOPE)
0061 : 97 05      staa $05            ;store A in addr 05 (SWEEP+1)
0063 : 24 03      bcc L0068           ;branch C=0 ZIREN5
0065 : 7C 00 04   inc $0004           ;incr addr 0004 (SWEEP)
;ZIREN5:
0068 : DE 04      ldx $04             ;load X with value in addr 04 (SWEEP)
006A : 9C 02      cpx $02             ;compare X with value in addr 02 (END2)
006C : 26 DB      bne L0049           ;branch Z=0 ZIREN1
006E : 20 B6      bra L0026           ;branch always PIA
;* Flat Triangle Loop (SYNTH9)
;ZIRLOP
0070 : 4F         clra                ;clear A
;ZIRLP1:
0071 : B7 80 00   staa $8000          ;store A in DAC output SOUND
0074 : 8B 20      adda #$20           ;add A with value 20h <-- 7Fh
0076 : 24 F9      bcc L0070           ;branch C=0 ZIRLP1
0078 : 8D 09      bsr L0082           ;branch sub ZIRT
007A : 86 E0      ldaa #$E0           ;load A with value E0h
;ZIRLP4:
007C : B7 80 00   staa $8000          ;store A in DAC output SOUND
007F : 80 20      suba #$20           ;subtract A with value 20h
0081 : 24 F9      bcc L007B           ;branch C=0 ZIRLP4
;ZIRT:
0083 : D6 06      ldab $06            ;load B with value in addr 06 (TOP)
;ZIRLP2:
0085 : 86 02      ldaa #$02           ;load A with value 02h
;ZIRLP3:
0087 : 4A         deca                ;decr A
0088 : 26 FD      bne L0086           ;branch Z=0 ZIRLP3
008A : 5A         decb                ;decr B
008B : 26 F8      bne L0084           ;branch Z=0  ZIRLP2
008D : 39         rts                 ;return subroutine
;008E : end
;



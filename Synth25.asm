; Sinistar (Video ROM 9/10) SYNTH25 CODE - 22 May 2021
; hack for Heathkit ET-3400 Audio Setup - PIA B input var parameter, tested, working
; user RAM = 197 + 256 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; using PIA addr 8000 (not 0400)
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second
;
;pitched tone (based on addr $05 value), endless
;
;
; SW demo:
; [---- ----][---- ----]
;
;*************************************;
; LOCRAM
;*************************************;
0000 : 00 00                          ; 
0002 : 00 00                          ; 
0004 : 00 0A                          ; -, LOOP needs init, pitch
0006 : 00 00                          ; PIA reads
;*************************************;
;RESET INIT (POWER-ON) org 0008
;*************************************;
0008 : 8E 01 FF   lds #$01FF          ; load SP with 01FFh
000B : CE 80 00   ldx #$8000          ; load X with 8000h, PIA1 (DAC) addr
000E : 6F 02      clr $02,x           ; clear(00) addr X + 02h (set 8002 PIA1 PR/DDR port B in)
0010 : 86 FF      ldaa  #$FF          ; load A with FFh 
0012 : A7 00      staa  $00,x         ; store A in addr X + 00h (set 8000 PIA1 PR/DDR port A out)
0014 : 86 3C      ldaa  #$3C          ; load A with 3Ch(0011 1100)
0016 : A7 01      staa  $01,x         ; store A in addr X + 01h (8001 PIA1 CR port A)
0018 : 86 37      ldaa  #$37          ; load A with 37h(0011 0111)
001A : A7 03      staa  $03,x         ; store A in addr X + 03h (8003 PIA1 CR port B) 
001C : 7F 40 02   clr $4002           ; clear(00) 4002h (set PIA2 PR/DDR port B in)
001F : 86 04      ldaa  #$04          ; set CR bit 2 high for PIA2
0021 : B7 40 03   staa $4003          ; store A in addr 4003 (PIA2 CR port B)
;*************************************;
;PIA reads - 0024
;*************************************;
;PIA
0024 : B6 80 02   ldaa  $8002         ;load A with PIA1 B
0027 : 97 06      staa  $06           ;store A in addr 06
0029 : B6 40 02   ldaa  $4002         ;load A with PIA2 B
002C : 97 07      staa  $07           ;store A in addr 07
;*************************************;
;synth 25 - 002E
;*************************************;
;SYNTH25 
002E : 86 60      ldaa  #$60          ;load A with 60h
0030 : B7 80 00   staa  $8000         ;store A in DAC output SOUND
;SYN251
0033 : 96 05      ldaa  $05           ;load A with addr 05
;SYN252
0035 : C6 13      ldab  #$13          ;load B with 13h
;SYN253
0037 : 5A         decb                ;decr B
0038 : 26 FD      bne  L0037          ;branch Z=0 SYN253
003A : 4A         deca                ;decr A
003B : 26 F8      bne  L0035          ;branch Z=0 SYN252
003D : 73 80 00   com  $8000          ;complement 1s DAC output SOUND
0040 : 96 05      ldaa  $05           ;load A with addr 05
;SYN254
0042 : C6 13      ldab  #$13          ;load B with 13h
;SYN255
0044 : 5A         decb                ;decr B
0045 : 26 FD      bne  L0044          ;branch Z=0 SYN255
0047 : 4A         deca                ;decr A
0048 : 26 F8      bne  L0042          ;branch Z=0 SYN254
004A : 73 80 00   com  $8000          ;complement 1s DAC output SOUND
004D : 7C 80 00   inc  $8000          ;incr addr DAC
0050 : 86 7F      ldaa  #$7F          ;load A with 7Fh
0052 : B1 80 00   cmpa  $8000         ;compare A with addr DAC
0055 : 26 DC      bne  L0033          ;branch Z=0 SYN251
;end loop 1
;SYN256
0057 : 96 05      ldaa  $05           ;load A with addr 05
;SYN257
0059 : C6 13      ldab  #$13          ;load B with 13h
;SYN258
005B : 5A         decb                ;decr B
005C : 26 FD      bne  L005B          ;branch Z=0 SYN258
005E : 4A         deca                ;decr A
005F : 26 F8      bne  L0059          ;branch Z=0 SYN257
0061 : 73 80 00   com  $8000          ;complement 1s DAC output SOUND
0064 : 96 05      ldaa  $05           ;load A with addr 05
;SYN259
0066 : C6 13      ldab  #$13          ;load B with 13h
;SYN25A
0068 : 5A         decb                ;decr B
0069 : 26 FD      bne  L0068          ;branch Z=0 SYN25A
006B : 4A         deca                ;decr A
006C : 26 F8      bne  L0066          ;branch Z=0 SYN259
006E : 73 80 00   com  $8000          ;complement 1s DAC output SOUND
0071 : 7A 80 00   dec  $8000          ;decr addr DAC
0074 : 86 60      ldaa  #$60          ;load A with 60h
0076 : B1 80 00   cmpa  $8000         ;compare A with addr DAC
0079 : 26 DC      bne  L0057          ;branch Z=0 SYN256
;read PIA2
007B : B6 40 02   ldaa  $4002         ;load A with PIA2 B
007E : 97 05      staa  $05           ;store A in addr 05 
0080 : 20 B1      bra  L0033          ;branch always SYN251
;0082 : end
;*************************************;






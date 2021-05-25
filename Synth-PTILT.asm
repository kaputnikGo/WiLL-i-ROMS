; World Cup (PROM 1) PTILT CODE - 25 May 2021
; hack for Heathkit ET-3400 Audio Setup - PIA B input var parameter, tested, working
; user RAM = 197 + 256 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; using PIA addr 8000 (not 0400)
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second
;
; first electronics sounds PROM (512 byte) from World Cup, March 1978
; -
; 
; -
;
; SW demo:
; [---- ----][---- ----]
;
;*************************************;
; LOCRAM
;*************************************;
0000 : nn 00                          ; 
0002 : nn 00                          ; 
0004 : 00 00                          ; 
0006 : 00 nn                          ; 
0008 : nn 00                          ; 
000A : nn 00                          ; 
000C : 00 00                          ; 
; ...
001A : 00 00                          ; 
;*************************************; 
;RESET INIT (POWER-ON) org 001C
;*************************************;
001C : 8E 01 FF   lds #$01FF          ; load SP with 01FFh
001F : CE 80 00   ldx #$8000          ; load X with 8000h, PIA1 (DAC) addr
0022 : 6F 02      clr $02,x           ; clear(00) addr X + 02h (set 8002 PIA1 PR/DDR port B in)
0024 : 86 FF      ldaa  #$FF          ; load A with FFh 
0026 : A7 00      staa  $00,x         ; store A in addr X + 00h (set 8000 PIA1 PR/DDR port A out)
0028 : 86 3C      ldaa  #$3C          ; load A with 3Ch(0011 1100)
002A : A7 01      staa  $01,x         ; store A in addr X + 01h (8001 PIA1 CR port A)
002C : 86 37      ldaa  #$37          ; load A with 37h(0011 0111)
002E : A7 03      staa  $03,x         ; store A in addr X + 03h (8003 PIA1 CR port B) 
0030 : 7F 40 02   clr $4002           ; clear(00) 4002h (set PIA2 PR/DDR port B in)
0033 : 86 04      ldaa  #$04          ; set CR bit 2 high for PIA2
0035 : B7 40 03   staa $4003          ; store A in addr 4003 (PIA2 CR port B)
;*************************************;
;PIA reads - 0038
;*************************************;
;PIA
0038 : B6 80 02   ldaa  $8002         ;load A with PIA1 B
003B : 97 0A      staa  $0A           ;store A in addr 06
003D : B6 40 02   ldaa  $4002         ;load A with PIA2 B
0040 : 97 0B      staa  $0B           ;store A in addr 07
;*************************************;
;early version (pre) of Tilt sound - 0042
;*************************************;
;PTILT
0042 : 4F         clra                ;clear A
0043 : B7 80 00   staa  $8000         ;store A in DAC output SOUND
0046 : CE 00 DF   ldx  #$00DF         ;load X with 00DFh
;PTILT1
0049 : C6 20      ldab  #$20          ;load B with 20h
004B : 8D 57      bsr  L0062          ;branch sub ADDBX
;PTILT2
004D : 09         dex                 ;decr X
004E : 26 FD      bne  L004D          ;branch Z=0 PTILT2
0050 : 73 80 00   com  $8000          ;complement 1s DAC output SOUND
;PTILT3
0053 : 4A         deca                ;decr A
0054 : 26 FD      bne  L0053          ;branch Z=0 PTILT3
0056 : 73 80 00   com  $8000          ;complement 1s DAC output SOUND
0059 : D6 03      ldab  $03           ;load B with addr 03
005B : DE 03      ldx  $03            ;load X with addr 03
005D : C5 10      bitb  #$10          ;bit test B with 10h
005F : 27 E8      beq  L0049          ;branch Z=1 PTILT1
0061 : 3E         wai                 ;wait interrupts, PC+1
;*************************************;
;Add B to Index Register - 0062
;*************************************;
;ADDBX 
0062 : DF 03      stx  $03            ;store X in addr 03
0064 : DB 04      addb  $04           ;add B with addr 04
0066 : D7 04      stab  $04           ;store B in addr 04
0068 : D6 03      ldab  $03           ;load B with addr 03
006A : C9 00      adcb  #$00          ;add C+B + 00h
006C : D7 03      stab  $03           ;store B in addr 03
006E : DE 03      ldx  $03            ;load X with addr 03
0070 : E6 00      ldab  $00,x         ;load B with X+00h
0072 : 39         rts                 ;return subroutine
;0073 : end







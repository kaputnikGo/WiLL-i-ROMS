; World Cup (PROM 1) SYNTHA CODE - 25 May 2021
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
;manual jump to given loader - 0042
;*************************************;
;JUMP
0042 : 7E 00 7F   jmp  L007F          ;jump SNALD1
;0042 : 7E 00 86   jmp  L0086          ;jump SNALD2
;0042 : 7E 00 98   jmp  L0098          ;jump SNALD3
;0042 : 7E 00 AB   jmp  L00AB          ;jump SNALD4
;0042 : 7E 00 BD   jmp  L00BD          ;jump SNALD5
;0042 : 7E 00 9D   jmp  L009D          ;jump PARAMB
;*************************************;
;synth A - 0045
;*************************************;
;SYNTHA
0045 : DF 01      stx  $01            ;store X in addr 01
0047 : 36         psha                ;push A into stack then SP - 1
;SYNA1
0048 : CE 01 14   ldx  #$0114         ;load X with 0114h (SNDTBL2)
;SYNA2
004B : A6 00      ldaa  $00,x         ;load A with X+00h
004D : 27 0B      beq  L005A          ;branch Z=1 SYNA4
004F : B7 80 00   staa  $8000         ;store A in DAC output SOUND
0052 : 96 00      ldaa  $00           ;load A with addr 00
;SYNA3
0054 : 4A         deca                ;decr A
0055 : 26 FD      bne  L0054          ;branch Z=0 SYNA3
0057 : 08         inx                 ;incr X
0058 : 20 F1      bra  L004B          ;branch always SYNA2
;SYNA4
005A : 5A         decb                ;decr B
005B : 26 EB      bne  L0048          ;branch Z=0 SYNA1
005D : DE 01      ldx  $01            ;load X with addr 01
005F : 32         pula                ;SP + 1 pull stack into A
0060 : 39         rts                 ;return subroutine
;*************************************;
;param A for SYNTHA
;*************************************;
;PARAMA
0061 : 96 08      ldaa  $08           ;load A with addr 08
;PRMA1
0063 : 97 00      staa  $00           ;store A in addr 00
0065 : D6 09      ldab  $09           ;load B with addr 09
0067 : 8D DC      bsr  L0045          ;branch sub SYNTHA
0069 : 4A         deca                ;decr A
006A : 91 07      cmpa  $07           ;compare A with addr 07
006C : 26 F5      bne  L0063          ;branch Z=0 PRMA1
;PRMA2
006E : 97 00      staa  $00           ;store A in addr 00
0070 : D6 09      ldab  $09           ;load B with addr 09
0072 : 8D D1      bsr  L0045          ;branch sub SYNTHA
0074 : 4C         inca                ;incr A
0075 : 91 08      cmpa  $08           ;compare A with addr 08
0077 : 26 F5      bne  L006E          ;branch Z=0 PRMA2
0079 : 7A 00 0A   dec  $000A          ;decr addr 000A
007C : 26 E3      bne  L0061          ;branch Z=0 PARAMA
007E : 3E         wai                 ;wait interrupts, PC+1
;*************************************;
;param A table loader #1 - 007F
;*************************************;
;SNALD1
007F : CE 01 00   ldx  #$0100         ;load X with 0100h (TBL1)
;SNALDX
0082 : 8D 07      bsr  L008B          ;branch sub PMOVE
0084 : 20 DB      bra  L0061          ;branch always PARAMA
;SNALD2
0086 : CE 01 04   ldx  #$0104         ;load X with 0104h (TBL2)
0089 : 20 F7      bra  L0082          ;branch always SNALDX
;*************************************;
;PMOVE - 008B
;*************************************;
;PMOVE 
008B : A6 00      ldaa  $00,x         ;load A with X+00h
008D : 97 07      staa  $07           ;store A in addr 07
008F : E6 01      ldab  $01,x         ;load B with X+01h
0091 : D7 08      stab  $08           ;store B in addr 08
0093 : EE 02      ldx  $02,x          ;load X with X+02h
0095 : DF 09      stx  $09            ;store X in addr 09
0097 : 39         rts                 ;return subroutine
;*************************************;
;param A table loader #3 - 0098
;*************************************;
;SNALD3
0098 : CE 01 08   ldx  #$0108         ;load X with 0108h (TBL3)
009B : 20 E5      bra  L0082          ;branch always SNALDX
;*************************************;
;param B for SYNTHA (no loaders)- 009D
;*************************************;
;PARAMB
009D : 4F         clra                ;clear A
;PARAMB1
009E : 4C         inca                ;incr A
009F : 81 2A      cmpa  #$2A          ;compare A with 2Ah
00A1 : 27 19      beq  L00BC          ;branch Z=1 SNALDW
00A3 : 97 00      staa  $00           ;store A in addr 00
00A5 : C6 03      ldab  #$03          ;load B with 03h
00A7 : 8D 9C      bsr  L0045          ;branch sub SYNTHA
00A9 : 20 F3      bra  L009E          ;branch always PARAMB1
;*************************************;
;data loader A for SYNTHA #4 - 00AB
;*************************************;
;SNALD4
00AB : CE 01 0C   ldx  #$010C         ;load X with 010Ch (TBL4)
;SNALD41
00AE : 8D DB      bsr  L008B          ;branch sub PMOVE
;SNALD42
00B0 : 97 00      staa  $00           ;store A in addr 00
00B2 : D6 08      ldab  $08           ;load B with addr 08
00B4 : 8D 8F      bsr  L0045          ;branch sub SYNTHA
00B6 : 90 09      suba  $09           ;sub A with addr 09
00B8 : 91 0A      cmpa  $0A           ;compare A with addr 0A
00BA : 2E F4      bgt  L00B0          ;branch Z+(N(+)V)=0 SNALD42
;SNALDW
00BC : 3E         wai                 ;wait interrupts, PC+1
;*************************************;
;data loader A for SYNTHA #5
;*************************************;
;SNALD5
00BD : CE 01 10   ldx  #$0110         ;load X with 0110h (TBL5)
00C0 : 20 EC      bra  L00AE          ;branch always SNALD41
;00C2 : end
;
;*************************************;
;SYNTHA tables - 0100
;*************************************; 
0100 : 14 20 02 04                    ;TBL1
0104 : 0A 12 05 04                    ;TBL2
0108 : 01 2C 03 01                    ;TBL3
010C : 2C 08 03 00                    ;TBL4
0110 : 7F 02 01 10                    ;TBL5
;
0114 : AD BF AD 80 53 41 53 80        ;SNDTBL2
011C : 00                             ;
;011D : end
;
;*************************************;




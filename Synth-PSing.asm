; World Cup (PROM 1) PSING CODE - 25 May 2021
; hack for Heathkit ET-3400 Audio Setup - PIA B input var parameter, tested, working
; user RAM = 197 + 256 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; using PIA addr 8000 (not 0400)
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second
;
; first electronics sounds PROM (512 byte) from World Cup, March 1978
; assumed to be early version of Delta F, Delta A Routine
; 
; 2-tone buzz sound, resonant at start.
;
; SW demo:
; [---- ----][---- ----]
;
;*************************************;
; LOCRAM
;*************************************;
0000 : B9 09                          ; B , 
0002 : 00 nn                          ; - , Xh
0004 : 1C nn                          ; Xl, Xh
0006 : A9 00                          ; Xl, -
0008 : 00 nn                          ; - , B (count)
000A : 00 00                          ; PIA reads
000C : nn nn                          ; start of SNDTBL1 write
; ...
001A : nn nn                          ; end write
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
;Interrupt Processing - 0042
;*************************************;
;IRQ
0042 : C6 B9      ldab  #$B9          ;load B with B9h
;*************************************;
;pre-Single Osc Routine - 0044
;*************************************; 
;PSING
0044 : D7 00      stab  $00           ;store B in addr 00
0046 : CE 00 0C   ldx  #$000C         ;load X with addr 000C
0049 : DF 03      stx  $03            ;store X in addr 03
004B : CE 00 9B  ldx  #$009B         ;load X with 009Bh (SNDTBL1)
004E : C6 10      ldab  #$10          ;load B with 10h
;PSING1
0050 : A6 00      ldaa  $00,x         ;load A with X+00h
0052 : 08         inx                 ;incr X
0053 : DF 05      stx  $05            ;store X in addr 05
0055 : DE 03      ldx  $03            ;load X with addr 03
0057 : A7 00      staa  $00,x         ;store A in X+00h
0059 : 08         inx                 ;incr X
005A : DF 03      stx  $03            ;store X in addr 03
005C : DE 05      ldx  $05            ;load X with addr 05
005E : 5A         decb                ;decr B
005F : 26 EF      bne  L0040          ;branch Z=0 PSING1
0061 : CE 00 AB   ldx  #$00AB         ;load X with 00ABh(WAVFRM)
0064 : E6 00      ldab  $00,x         ;load B with X+00h
;PSING2
0066 : D7 09      stab  $09           ;store B in addr 09
0068 : DF 05      stx  $05            ;store X in addr 05
;PSING3
006A : CE 00 0C   ldx  #$000C         ;load X with 000Ch
006D : C6 08      ldab  #$08          ;load B with 08h
006F : D7 07      stab  $07           ;store B in addr 07
;SING2
0071 : A6 00      ldaa  $00,x         ;load A with X+00h
0073 : D6 00      ldab  $00           ;load B with addr 00
0075 : 7D 00 09   tst  $0009          ;test addr 0009
0078 : 26 06      bne  L0070          ;branch Z=0 PSING4
007A : A0 08      suba  $08,x         ;sub A with X+08h
007C : A7 00      staa  $00,x         ;store A in X+00h
007E : C0 03      subb  #$03          ;sub B with 03h
;PSING4
0080 : 08         inx                 ;incr X
0081 : B7 80 00   staa  $8000         ;store A in DAC output SOUND
;SING3
0084 : 5A         decb                ;decr B
0085 : 26 FD      bne  L0074          ;branch Z=0 SING3
0087 : 7A 00 07   dec  $0007          ;decr addr 0007
008A : 26 E5      bne  L0061          ;branch Z=0 SING2
008C : 7A 00 09   dec  $0009          ;decr addr 0009
008F : 2A D9      bpl  L005A          ;branch N=0 PSING3
0091 : DE 05      ldx  $05            ;load X with addr 05
0093 : 08         inx                 ;incr X
0094 : E6 00      ldab  $00,x         ;load B with X+00h
0096 : 26 CE      bne  L0056          ;branch Z=0 PSING2
;PSINGX
0098 : 3E         wai                 ;wait interrupts, PC+1
0099 : 01         nop                 ;reserved
009A : 01         nop                 ;reserved (jmp to IRQ)
;*************************************;
;PSING tables - 009B
;*************************************;
009B : DA FF DA 80 26 01 26 80        ;SNDTBL1
00A3 : 07 0A 07 00 F9 F6 F9 00        ;
;
00AB : 08 03 02 01 02 03 04 05        ;WAVFRM
00B3 : 06 0A 1E 32 70 00              ;
;00B9 : end




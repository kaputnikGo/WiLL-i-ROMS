; 14 May 2021
; hack for Heathkit ET-3400 Audio Setup
; user RAM = 196 + 255 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; addr 00C5 to 00FF is Monitor RAM
; using PIA addr 8000, 4000 (DAC 8000 not 0400)
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second
; using edited subroutines TILT, IRQ, ADDX
;
; Tilt sound, low, fuzz, single saw down type - sound 8 in ROM 15 dump 
;(disasm name SYNTH10)
;first appeared in ROM 2 Gorgar, 1979
; 
;
; SW demo (flipped):
; [0000 1101][0000 0000]
;
;*************************************;
; LOCRAM (0000-0007F) (with typical values)
;*************************************;
0000 : 00 00                          ; PIA reads 
0008 : 00 nn                          ; --,addx 
000A : nn 00                          ; addx, --
000C : 00 00                          ;
000E : 00 00                          ; 
;*************************************;
;INIT (POWER-ON) org 0010 
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
0024 : 7F 40 02   clr X4002           ; clear(00) 4002h (set PIA2 PR/DDR port B in)
0027 : 86 04      ldaa  #$04          ; set CR bit 2 high for PIA2
0029 : B7 40 03   staa X4003          ; store A in addr 4003 (PIA2 CR port B)
;*************************************;
;PIA reads 002C
;*************************************;
002C : B6 80 02   ldaa  $8002         ;load A with PIA1 B
002F : 97 00      staa  $00           ;store A in addr 00
0031 : F6 40 02   ldab  $4002         ;load B with PIA2 B
0034 : D7 01      stab  $01           ;store B in addr 01
;*************************************;
;IRQ 0036
;*************************************;
;0036 : 5F        clrb                ;clear B (00) <-- B is decr later
0036 : 01         nop                 ;B is now set via PIA2
0037 : BD 00 3C   jsr L003C           ;jump sub TILT <-- bsr
003A : 20 F0      bra L002C           ;branch always PIA read
;*************************************;
;TILT 003C - only 00s and com 1s (0s to 1s, 1s to 0s) in DAC 
;*************************************;
003C : CE 00 E0   ldx  #$00E0         ;load X with 00E0h <-- X counter
;SYN101
;003F : 86 20      ldaa  #$20          ;load A with value 20h (0010 0000) <-- start freq/pitch
003F : 96 00      ldaa $00            ;load A with value in addr 00 (set by PIA1)
0041 : 8D 14      bsr  L0057          ;branch sub ADDX
;SYN102
0043 : 09         dex                 ;decr X
0044 : 26 FD      bne  L0043          ;branch Z=0 SYN102 <-- silent start loop length
0046 : 7F 80 00   clr  $8000          ;clear (00) in DAC output SOUND
;SYN103
0049 : 5A         decb                ;decr B <-- B not set, so negative num (N=1)?
004A : 26 FD      bne  L0049          ;branch Z=0 SYN103
004C : 73 80 00   com  $8000          ;complement 1s in DAC output SOUND
004F : DE 09      ldx  $09            ;load X with value in addr 09
0051 : 8C 10 00   cpx  #$1000         ;compare X with value 1000h <-- sets the lfo for ramp dwn speed/length
0054 : 26 E9      bne  L004D          ;branch Z=0 SYN101
0056 : 39         rts                 ;return subroutine
;*************************************;
;ADDX 0057
;*************************************;
0057 : DF 09      stx  $09            ;store X in addr 09
0059 : 9B 0A      adda  $0A           ;add A with value in addr 0A
005B : 97 0A      staa  $0A           ;store A in addr 0A
005D : 24 03      bcc  L0070          ;branch if C=0 CAL1
005F : 7C 00 09   inc  X0009          ;incr value in addr 0009
;CAL1
0062 : DE 09      ldx  $09            ;load X with value at addr 09
0064 : 39          rts                ;return subroutine
;0065 end
;*************************************;
;00C5 monitor RAM
;*************************************;

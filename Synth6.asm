; SYNTH6 CODE - 12 Nov 2019
; hack for Heathkit ET-3400 Audio Setup - PIA B input var parameter, tested, working
; user RAM = 197 + 256 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; using PIA addr 8000 (not 0400)
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second
; working ramp down loop, DEF coin drop, PIA B param makes 15 bass notes

;*************************************;
; Main loop scratch memory reserves
;*************************************;
0000 : 00                             ;not used
; ~       RESERVED 
0010 : 00                             ;not used
0011 : nn                             ; A
0012 : 00                             ;not used
; ~       RESERVED
001C : 00                             ; end main loop mem
;*************************************;
;RESET INIT (POWER-ON) org 001D
;*************************************;
001D : 8E 01 FF   lds #$01FF          ; load SP with 01FFh
0020 : CE 80 00	  ldx #$8000          ; load X with 8000h, PIA (DAC) addr
0023 : 6F 01		  clr	$01,x           ; clear(00) addr X + 01h (8001, PIA DDR port A) 
0025 : 6F 03      clr $03,x           ; clear(00) addr X + 03h (8003, PIA DDR port B)
0027 : 6F 02      clr $02,x           ; clear(00) addr X + 02h (8002, port B input)
0029 : 86 FF		  ldaa	#$FF          ; load A with FFh (1111 1111)
002B : A7 00		  staa	$00,x         ; store A in addr X + 00h (8000, port A output)
002D : 86 3C		  ldaa	#$3C          ; load A with 3Ch(0011 1100)
002F : A7 01		  staa	$01,x         ; store A in addr X + 01h (8001)
0031 : 86 37      ldaa  #$37          ; load A with 37h(0011 0111)(28h 0010 1000)
0033 : A7 03      staa  $03,x         ; store A in addr X + 03h (8003)
;*************************************;
;SYNTH6 - modified add PIA B into B
;*************************************;
0035 : 4F         clra                ;clear (00) A
0036 : B7 80 00   staa  $8000         ;SOUND, store A in addr DAC output
0039 : 97 11      staa  $11           ;store A in addr 11
;LOOP1
003B : 4F         clra                ;$F9DA, clear (00) A
;LOOP2
003C : 91 11      cmpa  $11           ;$F9DB, compare A with value 11h (0001 0001)
003E : 26 03      bne L0043           ;branch !=0 GOTO1
0040 : 73 80 00   com $8000           ;SOUND, DAC invert, complement 1s
;GOTO1
0043 : F6 80 02   ldab $8002          ;load B with PIA B, def.12h, pitched, use nnnn 0000
;LOOP3
0046 : 5A         decb                ;$F9E4, decr B
0047 : 26 FD      bne L0046           ;branch !=0 LOOP3
0049 : 4C         inca                ;incr A
004A : 2A F0      bpl L003C           ;branch if plus LOOP2
004C : 73 80 00   com $8000           ;SOUND, DAC invert, complement 1s
004F : 7C 00 11   inc $0011           ;incr addr 0011
0052 : 2A E7      bpl L003B           ;branch if plus LOOP1
0054 : 7E 00 35   jmp L0035           ;jump to IRQ loop start
;*************************************;
;end
;*************************************;
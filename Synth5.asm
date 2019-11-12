; SYNTH5 CODE - 12 Nov 2019
; hack for Heathkit ET-3400 Audio Setup - PIA B input var parameter, tested, working
; user RAM = 197 + 256 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; using PIA addr 8000 (not 0400)
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second
; working , multi oscil ramps, 2 tone, speed up, Sound ROM 15 sound20

;*************************************;
; Main loop scratch memory reserves
;*************************************;
0000 : 00                             ;not used
; ~       RESERVED
000A : 00                             ;not used
000B : 00 nn                          ; X, pitch, PIA B read value (20 lo, FF hi)
000D : 00 00                          ;not used
000F : FD                             ; A, X
0010 : nn                             ; A, changes
0011 : nn                             ; A, changes
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
;SYNTH5 - modified to read PIA B into X
;*************************************;
0035 : 86 FD      ldaa  #$FD          ;load A with FDh (1111 1101),(80 = lo) p2
0037 : 97 0F      staa  $0F           ;store A in addr 0F
0039 : B6 80 02   ldaa $8002          ;load A with PIA B (orig 0064h)
003C : 97 0C      staa $0C            ;store A in addr 0C, p1
003E : 4F         clra                ;clear A
003F : 97 0B      staa $0B            ;store A in addr 0B
;LOOP1
0041 : DB 0C      addb  $0C           ;add B + addr 0C into B
0043 : 96 11      ldaa  $11           ;load A with addr 11
0045 : 99 0B      adca  $0B           ;add A + addr 0B + C into A
0047 : 97 11      staa  $11           ;store A in addr 11
0049 : DE 0B      ldx $0B             ;load X with addr 0B
004B : 25 03      bcs L0050           ;branch Carry set GOTO2
004D : 01         nop                 ;nop
;GOTO1
004E : 20 03      bra L0053           ;branch always GOT03
;GOTO2
0050 : 08         inx                 ;incr X
0051 : 27 11      beq L0064           ;branch = 0 GOTO4
;GOTO3
0053 : DF 0B      stx $0B             ;store X in addr 0B
0055 : 84 0F      anda  #$0F          ;and A with 0Fh into A
0057 : 8B 9A      adda  #$9A          ;add A + 9Ah into A
0059 : 97 10      staa  $10           ;store A in addr 10
005B : DE 0F      ldx $0F             ;load X with addr 0F
005D : A6 00      ldaa  $00,x         ;load A with addr X + 00
005F : B7 80 00   staa  $8000         ;SOUND, store A in addr DAC output
0062 : 20 DD      bra L0041           ;branch always LOOP1
;GOTO4
0064 : 7E 00 35   jmp L0035           ;jump to IRQ loop start
;*************************************;
;end
;*************************************;
; SYNTH2 CODE - 08 Nov 2019
; hack for Heathkit ET-3400 Audio Setup
; user RAM = 197 + 256 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; using PIA addr 8000 (not 0400)
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second
; working, looping one shot with ramp up/down, pitch/frequency and duration params

;*************************************;
; Main loop scratch memory reserves
;*************************************;
0000 : 00                             ; not used
; ~       RESERVED
0014 : 00                             ;
0015 : 10                             ; loop duration
0016 : 00 00 00                       ; not used
0019 : C0                             ; pitch/frequency start (add 1A into A)
001A : FE                             ; LFO to env, also change ramp down
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
;IRQ main loop start
;*************************************;
0035 : B6 80 02   ldaa  $8002         ;load A with PIA B
;*************************************;
;SYNTH2, org 0043 - modified
; rem'd a bcc prior to com DAC
; rem'd an ldaa  #$FE to store in 1A
;*************************************;
0038 : 97 1A      staa  $1A           ;store A in addr 1A - def:0xFE LFO to env
003A : 86 C0      ldaa  #$C0          ;load A immed 0xC0 (1100 0000) - pitch/frequency start
003C : C6 10      ldab  #$10          ;load B immed 0x10 (0001 0000) - loop duration/cycles
003E : 20 00      bra   $004D         ;branch next (+00)
0040 : 97 19      staa  $19           ;store A in addr 19
0042 : 86 FF      ldaa  #$FF          ;load A immed 0xFF (1111 1111)
0044 : B7 80 00   staa  $8000         ;store A to DAC (SOUND)
0047 : D7 15      stab  $15           ;store B in addr 15
; LOOP1
0049 : D6 15      ldab  $15           ;load B with addr 15
; LOOP2
004B : 96 0A      ldaa  $0A           ;load A with addr 0A
004D : 44         lsra                ;logical shift right (0 into b7, b0 into C)
004E : 44         lsra                ;logical shift right
004F : 44         lsra                ;logical shift right
0050 : 98 0A      eora  $0A           ;exclusive OR A with addr 0A into A 
0052 : 44         lsra                ;logical shift right
0053 : 76 00 09   ror $0009           ;rotate right addr 0009 (C into b7, b0 into C)
0056 : 76 00 0A   ror $000A           ;ror addr 000A
0059 : 73 80 00   com $8000           ;DAC invert (SOUND) complement 1s
; GOTO1
005C : 96 19      ldaa  $19           ;load A with addr 19
; LOOP3
005E : 4A         deca                ;decrement A
005F : 26 FD      bne $005E           ;branch != 0 to LOOP3
0061 : 5A         decb                ;decrement B
0062 : 26 E7      bne $004B           ;branch != 0 to LOOP2
0064 : 96 19      ldaa  $19           ;load A with addr 19
0066 : 9B 1A      adda  $1A           ;add A + addr 1A into A
0068 : 97 19      staa  $19           ;store A into addr 19
006A : 26 DD      bne $0049           ;branch !=0 to LOOP1
006C : 20 C7      bra $0035           ;branch always to IRQ
;*************************************;
;end
;*************************************;


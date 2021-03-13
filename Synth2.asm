; SYNTH2 CODE - 13 Mar 2021
; hack for Heathkit ET-3400 Audio Setup
; user RAM = 197 + 256 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; using PIA1 addr 8000
; added PIA2 addr 4000
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second
; working, looping one shot with ramp up/down, pitch/frequency and duration params
; still in progress
;*************************************;
; Main loop scratch memory reserves
;*************************************;
0000 : 00 00                          ;
0002 : 10 00                          ; loop duration (10)
0004 : C0 00                          ; pitch/frequency start (add 1A into A) (C0)
0006 : FE 00                          ; LFO to env, also change ramp down (PIA B) (FE)
0008 : 00 3C                          ; ldaa, ror ? (orig ROM inits 09 with 3C)
000A : nn 00                          ; ror ?
000C : 00 00                          ; 
000E : 00 00                          ; 
0010 : 00                             ; 
;*************************************;
;RESET INIT (POWER-ON) org 0011
;*************************************;
0011 : 8E 01 FF   lds #$01FF          ; load SP with 01FFh
0014 : CE 80 00	  ldx #$8000          ; load X with 8000h, PIA1 (DAC) addr
0017 : 6F 01		  clr	$01,x           ; clear(00) addr X + 01h (8001 PIA1 DDR port A) 
0019 : 6F 03      clr $03,x           ; clear(00) addr X + 03h (8003 PIA1 DDR port B)
001B : 6F 02      clr $02,x           ; clear(00) addr X + 02h (8002 PIA1 port B in)
001D : 86 FF		  ldaa	#$FF          ; load A with FFh (1111 1111)
001F : A7 00		  staa	$00,x         ; store A in addr X + 00h (8000 PIA1 port A out)
0021 : 86 3C		  ldaa	#$3C          ; load A with 3Ch(0011 1100)
0023 : A7 01		  staa	$01,x         ; store A in addr X + 01h (8001 PIA1 port A)
0025 : 86 37      ldaa  #$37          ; load A with 37h(0011 0111)
0027 : A7 03      staa  $03,x         ; store A in addr X + 03h (8003 PIA1 port B) 
0029 : CE 40 00   ldx #$4000          ; load X with 4000h, PIA2 addr
002C : 6F 03      clr $03,x           ; clear(00) addr X + 03h (4003 PIA2 DDR port B)
002E : 6F 02      clr $02,x           ; clear(00) addr X + 02h (4002 PIA2 port B in)
0030 : 01 01      nop nop             ; (staa  $03,x) store A in addr X + 03h (4003 PIA2 port B)
;*************************************;
;IRQ main loop start
;*************************************;
0032 : B6 80 02   ldaa  $8002         ;load A with PIA1 B
;*************************************;
;SYNTH2 - modified
; rem'd a bcc prior to com DAC
; rem'd an ldaa  #$FE to store in 06
;*************************************;
0035 : 97 06      staa  $06           ;store A in addr 06 - def:0xFE LFO to env
0037 : 86 C0      ldaa  #$C0          ;load A immed 0xC0 (1100 0000) - pitch/frequency start
;0039 : C6 10      ldab  #$10         ;load B immed 0x10 (0001 0000) - loop duration/cycles - good for param2 (24)
0039 : 01 01      nop nop             ;nop for test
003B : 20 00      bra   $003D         ;branch next (+00) ?? nop ?
003D : 97 04      staa  $04           ;store A in addr 04
003F : 86 FF      ldaa  #$FF          ;load A immed 0xFF (1111 1111)
0041 : B7 80 00   staa  $8000         ;store A to DAC (SOUND)
0044 : D7 02      stab  $02           ;store B in addr 02
; LOOP1
0046 : D6 02      ldab  $02           ;load B with addr 02
; LOOP2
0048 : 96 0A      ldaa  $0A           ;load A with addr 0A <- what value at 0A?
004A : 44         lsra                ;logical shift right (0 into b7, b0 into C)
004B : 44         lsra                ;logical shift right
004C : 44         lsra                ;logical shift right
004D : 98 0A      eora  $0A           ;exclusive OR A with addr 0A into A 
004F : 44         lsra                ;logical shift right
0050 : 76 00 09   ror $0009           ;rotate right addr 0009 (C into b7, b0 into C)
0053 : 76 00 0A   ror $000A           ;ror addr 000A
0056 : 73 80 00   com $8000           ;DAC invert (SOUND) complement 1s
; GOTO1
0059 : 96 04      ldaa  $04           ;load A with addr 04
; LOOP3
005B : 4A         deca                ;decrement A
005C : 26 FD      bne $005B           ;branch != 0 to LOOP3
005E : 5A         decb                ;decrement B
005F : 26 E7      bne $0048           ;branch != 0 to LOOP2
0061 : 96 04      ldaa  $04           ;load A with addr 04
0063 : 9B 06      adda  $06           ;add A + addr 06 into A
0065 : 97 04      staa  $04           ;store A into addr 04
0067 : 26 DD      bne $0046           ;branch !=0 to LOOP1
0069 : F6 40 02   ldab  $4002         ;load B with PIA2 B
006C : 20 C4      bra $0032           ;branch always to IRQ
;*************************************;
;006B end
;*************************************;


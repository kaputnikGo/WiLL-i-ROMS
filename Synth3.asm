; SYNTH3 CODE - 12 Nov 2019
; hack for Heathkit ET-3400 Audio Setup - PIA B input var parameter, tested, working
; user RAM = 197 + 256 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; using PIA addr 8000 (not 0400)
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second
; working, def blaster to explosion, ramp down

;*************************************;
; Main loop scratch memory reserves
;*************************************;
0000 : 00                             ; not used
; ~       RESERVED
0008 : 00                             ;
0009 : nn                             ; changes
000A : nn                             ; changes
0012 : 00                             ;
0013 : nn                             ; A inner loop length and divisor from PIA B
0014 : 80                             ; B inner loop LFO-like, counts down FF to 00 fast to slow
0015 : 20                             ; A loop speed
0016 : 00 FF                          ; IX ,16 = 00 and 17 counts down from FF
0018 : 20                             ; A loop speed
0019 : 00                             ; 
001A : 00                             ; 
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
;SYNTH3 - mod for PIA B into addr 13
;*************************************;
0035 : 86 20      ldaa  #$20          ;load A with 20h (0010 0000)
0037 : 97 15      staa  $15           ;store A in addr 15
0039 : 97 18      staa  $18           ;store A in addr 18
003B : B6 80 02   ldaa $8002          ;load A with PIA B
003E : CE 00 01   ldx #$0001          ;load X with 0001h
0041 : C6 80      ldab  #$80          ;load B with 80h, 1 ramp (orig FFh 2 ramps)
0043 : 01         nop                 ;nop, retain in case of ldab 8002
0044 : 97 13      staa  $13           ;store A in addr 13
;LOOP1
0046 : DF 16      stx $16             ;store X in addr 16
;LOOP2
0048 : D7 14      stab  $14           ;store B in addr 14
004A : D6 15      ldab  $15           ;load B with addr 15
;LOOP3
004C : 96 0A      ldaa  $0A           ;load A with addr 0A
004E : 44         lsra                ;logical shift right A(0 into b7, b0 into C)
004F : 44         lsra                ;
0050 : 44         lsra                ;
0051 : 98 0A      eora  $0A           ;exclusive OR $0A into A
0053 : 44         lsra                ;
0054 : 76 00 09   ror $0009           ;rotate right addr 0009 (C -> b7 - b0 -> C )
0057 : 76 00 0A   ror $000A           ;ror addr 000A
005A : 86 00      ldaa  #$00          ;load A with 00h (0000 0000)
005C : 24 02      bcc $F8F8           ;branch if Carry clear GOTO2
005E : 96 14      ldaa  $14           ;load with addr 14
;GOTO2
0060 : B7 80 00   staa  $8000         ;SOUND store A in PIA A DAC output
0063 : DE 16      ldx $16             ;load X with addr 16
;LOOP4
0065 : 09         dex                 ;decr X
0066 : 26 FD      bne $F8FD           ;branch != 0 LOOP4
0068 : 5A         decb                ;decr B
0069 : 26 E1      bne $F8E4           ;branch != 0 LOOP3
006B : D6 14      ldab  $14           ;load B with addr 14
006D : D0 13      subb  $13           ;subtract B - addr 13 into B
006F : 27 09      beq $F912           ;branch if = 0 to GOTO3
0071 : DE 16      ldx $16             ;load X with addr 16
0073 : 08         inx                 ;incr X
0074 : 96 18      ldaa  $18           ;load A with addr 18
0076 : 27 D0      beq $F8E0           ;branch = 0 LOOP2
0078 : 20 CC      bra $F8DE           ;branch always LOOP1
;GOTO3
007A : 7E 00 35   jmp L0035           ;jump to IRQ loop start
;*************************************;
;end
;*************************************; 
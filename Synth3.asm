; SYNTH3 CODE - 14 Mar 2021
; hack for Heathkit ET-3400 Audio Setup - PIA B input var parameter, tested, working
; user RAM = 197 + 256 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; using PIA addr 8000 (not 0400)
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second
; working, def blaster to explosion, ramp down, has quiet echo effect
; PIA 2 addrs and INIT fix
;
; SW demo:
; [1111 1110][0000 0010]
;
;*************************************;
; Main loop scratch memory reserves
;*************************************;
0000 : 00                             ; not used
; ~       RESERVED
0008 : 00                             ;
0009 : nn                             ; var: ! program to FF before run !
000A : nn                             ; var: ! program to FF before run !
000B : 00                             ; not used
; ~ not used
0011 : 00                             ; not used
0012 : 00                             ;
0013 : nn                             ; A inner loop length and divisor from PIA B
0014 : nn                             ; B inner loop LFO-like, counts down FF to 00 fast to slow
0015 : 20                             ; A loop speed
0016 : 00 nn                          ; IX ,16 = 00 and 17 counts down from FF
0018 : 20                             ; A loop speed
;*************************************;
;RESET INIT (POWER-ON) org 0019
;*************************************;
0019 : 8E 01 FF   lds #$01FF          ; load SP with 01FFh
001C : CE 80 00	  ldx #$8000          ; load X with 8000h, PIA1 (DAC) addr
001F : 6F 02      clr $02,x           ; clear(00) addr X + 02h (set 8002 PIA1 PR/DDR port B in)
0021 : 86 FF		  ldaa	#$FF          ; load A with FFh (1111 1111)
0023 : A7 00		  staa	$00,x         ; store A in addr X + 00h (set 8000 PIA1 PR/DDR port A out)
0025 : 86 3C		  ldaa	#$3C          ; load A with 3Ch(0011 1100)
0027 : A7 01		  staa	$01,x         ; store A in addr X + 01h (8001 PIA1 CR port A)
0029 : 86 37      ldaa  #$37          ; load A with 37h(0011 0111)
002B : A7 03      staa  $03,x         ; store A in addr X + 03h (8003 PIA1 CR port B) 
002D : 7F 40 02   clr X4002           ; clear(00) 4002h (set PIA2 PR/DDR port B in)
0030 : 86 04      ldaa  #$04          ; set CR bit 2 high for PIA2
0032 : B7 40 03   staa X4003          ; store A in addr 4003 (PIA2 CR port B)
;*************************************;
;SYNTH3 - mod for PIA B into addr 13
;*************************************;
0035 : B6 40 02   ldaa  $4002         ;load A with PIA2 B - need to init 20h (0010 0000) up to 80)?
0038 : 97 15      staa  $15           ;store A in addr 15
003A : 97 18      staa  $18           ;store A in addr 18
003C : B6 80 02   ldaa $8002          ;load A with PIA B
003F : CE 00 01   ldx #$0001          ;load X with 0001h
0042 : C6 80      ldab  #$80          ;load B with 80h, 1 ramp (orig FFh 2 ramps) - can be param2 ?
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
0066 : 26 FD      bne L0065           ;branch != 0 LOOP4
0068 : 5A         decb                ;decr B
0069 : 26 E1      bne L004C           ;branch != 0 LOOP3
006B : D6 14      ldab  $14           ;load B with addr 14
006D : D0 13      subb  $13           ;subtract B - addr 13 into B
006F : 27 09      beq L007A           ;branch if = 0 to GOTO3
0071 : DE 16      ldx $16             ;load X with addr 16
0073 : 08         inx                 ;incr X
0074 : 96 18      ldaa  $18           ;load A with addr 18
0076 : 27 D0      beq L0048           ;branch = 0 LOOP2
0078 : 20 CC      bra L0046           ;branch always LOOP1
;GOTO3
007D : 7E 00 35   jmp L0035           ;jump to SYNTH3 loop start
;*************************************;
;end
;*************************************; 

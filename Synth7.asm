; SYNTH7 CODE - 12 Nov 2019
; hack for Heathkit ET-3400 Audio Setup - PIA B input var parameter, tested, working
; user RAM = 197 + 256 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; using PIA addr 8000 (not 0400)
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second
; working, multiple oscil ramp down, Def. Falling mutant

;*************************************;
; Main loop scratch memory reserves
;*************************************;
0000 : 00                             ;not used
; ~       RESERVED 
0010 : 00                             ;not used
0011 : 80                             ; A, changes, PIA B read, low values affect amplitude
0012 : 00                             ;changes
0013 : 40 nn                          ; A, count down
0015 : 41                             ; B, count down
0016 : nn 
0017 : nn                             ; count down
0018 : nn                             ;
0019 : nn                             ; count down
001A : nn 41                          ;
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
;SYNTH7 - modified add PIA B to A, addr 11
;*************************************;
0035 : CE 00 13   ldx #$0013          ;load X with 0013h (0000 0000 0001 0011)
;LOOP1
0038 : 6F 00      clr $00,x           ;clear addr X + 00h (0013)
003A : 08         inx                 ;incr X
003B : 8C 00 1B   cpx #$001B          ;compare X with value 001Bh (0000 0000 0001 1011)
003E : 26 F8      bne L0038           ;branch != 0 LOOP1
0040 : 86 40      ldaa  #$40          ;load A with value 40h (0100 0000)
0042 : 97 13      staa  $13           ;store A in addr 13
;LOOP2
0044 : CE 00 13   ldx #$0013          ;load X with 0013h (0000 0000 0001 0011)
0047 : B6 80 02   ldaa $8002          ;load A with PIA B (def.80h,1000 0000)
004A : 97 11      staa  $11           ;store A in addr 11
004C : 5F         clrb                ;clear B
;LOOP3
004D : A6 01      ldaa  $01,x         ;load A with addr X + 01h
004F : AB 00      adda  $00,x         ;add A + (X + 00h) into A
0051 : A7 01      staa  $01,x         ;store A in addr X + 01h
0053 : 2A 02      bpl L0057           ;branch if plus GOTO1
0055 : DB 11      addb  $11           ;add B + addr 11 into B
;GOTO1
0057 : 74 00 11   lsr $0011           ;logical shift right addr 0011 (0 -> b7 - b0 -> C)
005A : 08         inx                 ;incr X
005B : 08         inx                 ;incr X
005C : 8C 00 1B   cpx #$001B          ;compare X with value 001Bh (0000 0000 0001 1011)
005F : 26 EC      bne L004D           ;branch !=0 LOOP3 
0061 : F7 80 00   stab  $8000         ;SOUND, store B to addr DAC output
0064 : 7C 00 12   inc $0012           ;incr addr 0012
0067 : 26 DB      bne L0044           ;branch !=0 LOOP2
0069 : CE 00 13   ldx #$0013          ;load X with 0013h (0000 0000 0001 0011)
006C : 5F         clrb                ;clear B
;LOOP4
006D : A6 00      ldaa  $00,x         ;load A with addr X + 00h
006F : 27 0B      beq L007C           ;branch =0 GOTO2
0071 : 81 37      cmpa  #$37          ;compare A with value 37h (0011 0111)
0073 : 26 04      bne L0079           ;branch !=0 GOTO3
0075 : C6 41      ldab  #$41          ;load B with value 41h (0100 0001)
0077 : E7 02      stab  $02,x         ;store B in addr X + 02h
;GOTO3
0079 : 6A 00      dec $00,x           ;decr X + 00h
007B : 5C         incb                ;incr B
;GOTO2
007C : 08         inx                 ;incr X
007D : 08         inx                 ;incr X
007E : 8C 00 1B   cpx #$001B          ;compare X with value 001Bh (0000 0000 0001 1011)
0081 : 26 EA      bne L006D           ;branch !=0 LOOP4
0083 : 5D         tstb                ;test B 0 or minus
0084 : 26 BE      bne L0044           ;branch !=0 LOOP2
0086 : 7E 00 35   jmp L0035           ;jump to IRQ loop start
;*************************************;
;end
;*************************************;
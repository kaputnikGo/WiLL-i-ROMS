; SYNTH5 CODE - 14 Mar 2021
; hack for Heathkit ET-3400 Audio Setup - PIA B input var parameter, tested, working
; user RAM = 197 + 256 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; using PIA addr 8000 (not 0400)
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second
; working , multi oscil ramps, 2 tone, speed up, Sound ROM 15 sound20 (radio osc noise thing)
; added PIA2 addrs and refactoring
;
; SW demo:
; [0010 0000][1111 1101]
;
;*************************************;
; Main loop scratch memory reserves
;*************************************;
0000 : 00                             ; not used
; ~       RESERVED
000A : 00                             ; not used
000B : 00 nn                          ; X, pitch, PIA1 B read value (20 lo, FF hi)
000D : 00 00                          ; not used - 00 8A
000F : FD                             ; A, X, PIA2 B read
0010 : nn                             ; A, changes
0011 : nn                             ; A, changes
;*************************************;
;RESET INIT (POWER-ON) org 0012
;*************************************;
0012 : 8E 01 FF   lds #$01FF          ; load SP with 01FFh
0015 : CE 80 00	  ldx #$8000          ; load X with 8000h, PIA1 (DAC) addr
0018 : 6F 02      clr $02,x           ; clear(00) addr X + 02h (set 8002 PIA1 PR/DDR port B in)
001A : 86 FF		  ldaa	#$FF          ; load A with FFh (1111 1111)
001C : A7 00		  staa	$00,x         ; store A in addr X + 00h (set 8000 PIA1 PR/DDR port A out)
001E : 86 3C		  ldaa	#$3C          ; load A with 3Ch(0011 1100)
0020 : A7 01		  staa	$01,x         ; store A in addr X + 01h (8001 PIA1 CR port A)
0022 : 86 37      ldaa  #$37          ; load A with 37h(0011 0111)
0024 : A7 03      staa  $03,x         ; store A in addr X + 03h (8003 PIA1 CR port B) 
0026 : 7F 40 02   clr X4002           ; clear(00) 4002h (set PIA2 PR/DDR port B in)
0029 : 86 04      ldaa  #$04          ; set CR bit 2 high for PIA2
002B : B7 40 03   staa X4003          ; store A in addr 4003 (PIA2 CR port B)
002E : 01         nop                 ;
; ~ 01 nops ./cont 
0033 : 01         nop                 ; reserved
;*************************************;
;SYNTH5 - modified to read PIA Bs into A,X
;*************************************;
0034 : B6 40 02   ldaa $4002          ;load A with PIA2 B - FDh (1111 1101),(80 = lo) p2
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
0064 : 7E 00 34   jmp L0034           ;jump to IRQ loop start
;*************************************;
;0067 : end
;*************************************;

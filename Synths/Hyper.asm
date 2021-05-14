; 14 May 2021
; hack for Heathkit ET-3400 Audio Setup - PIA B input var parameter, tested, working
; user RAM = 197 + 256 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; using PIA addr 8000 (not 0400)
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second
; PIA B param makes 15 bass notes
; added PIA2 addrs and refactoring, WIP
;
; source name: HYPER
; (disasm name Synth6)
; first appears in Sound ROM 8 Hyperball, 1981
; Defender coin drop sound, Sound 22
;
; SW demo:
; [0011 1111][0011 1001]
;
;*************************************;
; Main loop scratch memory reserves
;*************************************;
0000 : 00                             ;not used
; ~       RESERVED 
0010 : nn                             ; PIA2 b read
0011 : nn                             ; A, counter from 00
;*************************************;
;RESET INIT (POWER-ON) org 0012
;*************************************;
0012 : 8E 01 FF   lds #$01FF          ; load SP with 01FFh
0015 : CE 80 00   ldx #$8000          ; load X with 8000h, PIA1 (DAC) addr
0018 : 6F 02      clr $02,x           ; clear(00) addr X + 02h (set 8002 PIA1 PR/DDR port B in)
001A : 86 FF      ldaa  #$FF          ; load A with FFh (1111 1111)
001C : A7 00      staa  $00,x         ; store A in addr X + 00h (set 8000 PIA1 PR/DDR port A out)
001E : 86 3C      ldaa  #$3C          ; load A with 3Ch(0011 1100)
0020 : A7 01      staa  $01,x         ; store A in addr X + 01h (8001 PIA1 CR port A)
0022 : 86 37      ldaa  #$37          ; load A with 37h(0011 0111)
0024 : A7 03      staa  $03,x         ; store A in addr X + 03h (8003 PIA1 CR port B) 
0026 : 7F 40 02   clr X4002           ; clear(00) 4002h (set PIA2 PR/DDR port B in)
0029 : 86 04      ldaa  #$04          ; set CR bit 2 high for PIA2
002B : B7 40 03   staa X4003          ; store A in addr 4003 (PIA2 CR port B)
;*************************************;
;IRQ - modified, load PIA2 B into A, $10
;*************************************;
002E : B6 40 02   ldaa $4002          ;load A with PIA2 B
0031 : 97 10      staa  $10           ; store A in addr 10
;*************************************;
;SYNTH6 - modified add PIA B into B
;*************************************;
;HYPER
;0033 : 4F         clra                ;clear (00) A, 01
0033 : 01         nop                 ; 
0034 : B7 80 00   staa  $8000         ;SOUND, store A in addr DAC output
0037 : 97 11      staa  $11           ;store A in addr 11(TEMPA)(ZERO PHASE)
;HYPER1 LOOP1
0039 : 4F         clra                ;$F9DA, clear (00) A(ZERO TIME COUNTER)
003A : 01 01      nop nop             ;nops
;HYPER2 LOOP2
003C : 91 11      cmpa  $11           ;$F9DB, compare A with addr 11, phaser(TEMPA)
003E : 26 03      bne L0043           ;branch !=0 GOTO1
0040 : 73 80 00   com $8000           ;SOUND, DAC invert, complement 1s(PHASE EDGE?)
;HYPER3 GOTO1
0043 : F6 80 02   ldab $8002          ;load B with PIA B, def.12h, pitched, use nnnn 0000(DELAY)
;HYPER4 LOOP3
0046 : 5A         decb                ;$F9E4, decr B
0047 : 26 FD      bne L0046           ;branch !=0 LOOP3
0049 : 4C         inca                ;incr A(ADVANCE TIME COUNTER)
004A : 2A F0      bpl L003C           ;branch if plus LOOP2
004C : 73 80 00   com $8000           ;SOUND, DAC invert, complement 1s(CYCLE DONE?, CYCLE EDGE)
004F : 7C 00 11   inc $0011           ;incr addr 0011(TEMPA)(NEXT PHASE)
0052 : 2A E5      bpl L0039           ;branch if plus LOOP1
0054 : 7E 00 2E   jmp L002E           ;jump to IRQ loop start
;*************************************;
;0057 : end
;*************************************;

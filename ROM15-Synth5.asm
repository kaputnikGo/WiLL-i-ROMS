; Sound ROM 15 RADIO (SYNTH5) CODE - 29 Mar 2021
; hack for Heathkit ET-3400 Audio Setup - PIA B input var parameter, tested, working
; user RAM = 197 + 256 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; using PIA addr 8000 (not 0400)
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second
; working , multi oscil ramps, 2 tone, speed up, Sound ROM 15 sound20 (radio osc noise thing)
; added PIA2 addrs and refactoring
;
 ;merge with Radio source and RADSND
;
; SW demo:
; [0010 0000][1111 1101]
; [0001 1111][1111 1101] -not scratchy, pulsing
;*************************************;
; Main loop scratch memory reserves
;*************************************;
0000 : nn nn                          ; XPTR(0B), XPTR+1(0C)
0002 : nn nn                          ; TEMPX(07), TEMPX+1(08)
0004 : nn 00                          ; TEMPA(0D), -
0006 : 00 00                          ; PIA reads
;*************************************;
;RESET INIT (POWER-ON) org 0008
;*************************************;
0008 : 8E 01 FF   lds #$01FF          ; load SP with 01FFh
000B : CE 80 00   ldx #$8000          ; load X with 8000h, PIA1 (DAC) addr
000E : 6F 02      clr $02,x           ; clear(00) addr X + 02h (set 8002 PIA1 PR/DDR port B in)
0010 : 86 FF      ldaa  #$FF          ; load A with FFh 
0012 : A7 00      staa  $00,x         ; store A in addr X + 00h (set 8000 PIA1 PR/DDR port A out)
0014 : 86 3C      ldaa  #$3C          ; load A with 3Ch(0011 1100)
0016 : A7 01      staa  $01,x         ; store A in addr X + 01h (8001 PIA1 CR port A)
0018 : 86 37      ldaa  #$37          ; load A with 37h(0011 0111)
001A : A7 03      staa  $03,x         ; store A in addr X + 03h (8003 PIA1 CR port B) 
001C : 7F 40 02   clr $4002           ; clear(00) 4002h (set PIA2 PR/DDR port B in)
001F : 86 04      ldaa  #$04          ; set CR bit 2 high for PIA2
0021 : B7 40 03   staa $4003          ; store A in addr 4003 (PIA2 CR port B)
;*************************************;
;PIA reads - 0024
;*************************************;
;PIA
0024 : B6 80 02   ldaa  $8002         ;load A with PIA1 B
0027 : 97 06      staa  $06           ;store A in addr 06
0029 : B6 40 02   ldaa  $4002         ;load A with PIA2 B
002C : 97 07      staa  $07           ;store A in addr 07
;*************************************;
;SYNTH5 - 002E
;*************************************;
;RADIO
002E : 86 00      ldaa  #$00          ;load A with value 00h (#RADSND/$100 SOUND TABLE)(1st byte of addr RADSND)
0030 : 97 00      staa  $00           ;store B in addr 00 (XPTR)
0032 : CE 00 64   ldx  #$0064         ;load X with value 0064h (#100)(STARTING FREQ)
0035 : DF 02      stx  $02            ;store X in addr 07 (TEMPX)
;RADIO1:
0037 : DB 03      addb  $03           ;add B with value in addr 08 (TEMPX+1)(ADD FREQ TO TIMER)
0039 : 96 04      ldaa  $04           ;load A with value in addr 0D (TEMPA)
003B : 99 02      adca  $02           ;A = A + C + value in addr 07 (TEMPX)
003D : 97 04      staa  $04           ;store A in addr 0D (TEMPA)
003F : DE 02      ldx  $02            ;load X with value in addr 07 (TEMPX)
0041 : 25 04      bcs  L0047          ;branch if C=1 (RADIO2)
0043 : 20 00      bra  L0045          ;branch always (*+2)(EQUALIZE TIME)
0045 : 20 03      bra  L004A          ;branch always (RADIO3)
;RADIO2:
0047 : 08         inx                 ;incr X (CARRY?, RAISE FREQ)
0048 : 27 11      beq  L005B          ;branch if Z=1 (RADIO4)(DONE?)
;RADIO3:
004A : DF 02      stx  $02            ;store X in addr 07 (TEMPX)
004C : 84 0F      anda  #$0F          ;and A with value 0Fh (SET POINTER)
004E : 8B 5D      adda  #$5D          ;add A with value 5Dh (RADSND!.$FF)(2nd byte of addr RADSND)
0050 : 97 01      staa  $01           ;store A in addr 01 (XPTR+1)
0052 : DE 00      ldx  $00            ;load X with value in addr 00 (XPTR)
0054 : A6 00      ldaa  $00,x         ;load A with value in addr X + 00h
0056 : B7 80 00   staa  $8000         ;store A in DAC output SOUND
0059 : 20 DC      bra  L0037          ;branch always (RADIO1)
;RADIO4:
005B : 20 C7      bra  L0024          ;branch always PIA
;*************************************;
;Radio Sound Waveform - 005D (FD84)
;*************************************;
005D : 8C 5B B6 40 BF 49 A4 73        ;RADSND
0065 : 73 A4 49 BF 40 B6 5B 8C 
;006D : end






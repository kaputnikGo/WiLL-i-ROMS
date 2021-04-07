; SYNTH NMI-ORGAN SOUNDS CODE - 7 Apr 2021
; hack for Heathkit ET-3400 Audio Setup
; user RAM = 196 + 255 bytes = 453
; addr 0000 - 00C4 and 0100 - 01FF
; addr 00C5 to 00FF is Monitor RAM
; using PIA addr 8000, 4000 (DAC 8000 not 0400)
; mpu clock speed is default/low (quoted as 0.5 MHz), expecting ~894750 cycles per second
; using edited subroutines NMI, PARAM7, CALCOS, SYNTH8 - revert mem locations.
;
; Full NMI reset is 1st 2 bars JS Bach's Toccata and Fugue in D Minor + Williams Boot Carpet
; duration (X count) + pitch (NOP) values
; added SoundROM6 melody FDB for testing
; Audacity playback wav speed x2.25 to get approx
; FDB table CALCOS offset change to 02h allows 10 bytes recovered mem
; SoundROM6 (Pharaoh) melody FDB tables identified
;
;
; SW demo :
; [---- ---- ---- ----]
; note from older SYNTH8.asm file: if write flood starts at $0016, PIA2 write to $0022 (001E here) adds inner loop, and
; PIA1 writes to $0011 (000D here) changes pitch
;
;*************************************;
; Scratch RAM (0000-0007F) (with typical values) (clear 00 at start)
;*************************************;
0000 : 00 00                          ; PIAs
0002 : 00 00                          ;not used <-- not used?
0004 : 00 00                          ; PRM71
0006 : 00 00                          ;not used
0008 : 00 01                          ; -,PRM71 X
000A : 29 01                          ; X CAL A (vals 29,A0), PRM71 X ()
000C : FC 00                          ; X,A (counter)
000E : A8 3C                          ; SYN8, PRM71 X, 000E rapid counter up
0010 : 00 00                          ; X SYN8, A
0012 : 00 00                          ; write flood, should contain several 7E 01 65 writes for PC jmps
; ~
0077 : 7E 01 65                       ; nop writer jmp
;*************************************;
;MEM CLR (POWER-ON) org 0078 (first run - nop writer will overwrite to 0079)
;*************************************;
0078 : CE 00 77   ldx #$0077          ;load X with value 0077 (don't write over self...)
;CLR1:
007B : 6F 00      clr $00,x           ;clear addr X + 00h
007D : 09         dex                 ;decr X
007E : 26 FB      bne L007B           ;branch if Z=0 CLR1 (loop clears mem addr 0077 down to 0000)
;*************************************;
;INIT 0080 (2nd run org 0080)
;*************************************;
0080 : 8E 01 FF   lds #$01FF          ; load SP with 01FFh
0083 : CE 80 00   ldx #$8000          ; load X with 8000h, PIA1 (DAC) addr
0086 : 6F 02      clr $02,x           ; clear(00) addr X + 02h (set 8002 PIA1 PR/DDR port B in)
0088 : 86 FF      ldaa  #$FF          ; load A with FFh (1111 1111)
008A : A7 00      staa  $00,x         ; store A in addr X + 00h (set 8000 PIA1 PR/DDR port A out)
008C : 86 3C      ldaa  #$3C          ; load A with 3Ch(0011 1100)
008E : A7 01      staa  $01,x         ; store A in addr X + 01h (8001 PIA1 CR port A)
0090 : 86 37      ldaa  #$37          ; load A with 37h(0011 0111)
0092 : A7 03      staa  $03,x         ; store A in addr X + 03h (8003 PIA1 CR port B) 
0094 : 7F 40 02   clr $4002           ; clear(00) 4002h (set PIA2 PR/DDR port B in)
0097 : 86 04      ldaa  #$04          ; set CR bit 2 high for PIA2
0099 : B7 40 03   staa $4003          ; store A in addr 4003 (PIA2 CR port B)
;*************************************;
;PIA reads
;*************************************;
009C : B6 80 02   ldaa  $8002         ;load A with PIA1 B
009F : 97 00      staa  $00           ;store A in addr 00
00A1 : B6 40 02   ldaa  $4002         ;load A with PIA2 B
00A4 : 97 01      staa  $01           ;store A in addr 01
;*************************************;
;NMI
;*************************************;
00A6 : 86 02      ldaa  #$02          ;load A with 02h (0000 0010)
00A8 : BD 01 00   jsr L0100           ;jump sub PRM71
00AB : 86 01      ldaa  #$01          ;load A with 01h (0000 0001)
00AD : BD 01 00   jsr L0100           ;jump sub PRM71
00B0 : 20 F4      bra L003E           ;branch always NMI <-- for endless loop
;*************************************;
;CALCOS 00B2
;*************************************;
00B2 : DF 09      stx $09             ;store X in addr 09
00B4 : 9B 0A      adda  $0A           ;add A with addr 0A
00B6 : 97 0A      staa  $0A           ;store A in addr 0A
00B8 : 24 03      bcc L008F           ;branch Carry clear CAL1
00BA : 7C 00 09   inc $0009           ;incr addr 09
;CAL1:
00BD : DE 09      ldx $09             ;load X from addr 09
00BF : 39         rts                 ;return subroutine 
;00C0 : end
;00C4 
;*************************************;
;PRM71 0100
;*************************************;
0100 : 97 0D      staa  $0D           ;store A in addr 0D
0102 : CE 01 90   ldx #$0190          ;load X with 0190 (addr of melody data) 
;PRM72
0105 : A6 00      ldaa  $00,x         ;load A with value at addr X + 00h
0107 : 27 2E      beq L0083           ;branch if Z=1(in accum all bits are 0) to PRM75
0109 : 7A 00 0D   dec $000D           ;decr value in addr 0D
010C : 27 06      beq L0061           ;branch if Z=1 PRM73
010E : 4C         inca                ;incr A
010F : BD 00 B2   jsr L00B2           ;jump sub CALCOS (shifts X start addr 0190 to 019D)
0112 : 20 F1      bra L0052           ;branch always PRM72
;PRM73
0114 : 08         inx                 ;incr X
0115 : DF 0B      stx $0B             ;store X in addr 0B
0117 : BD 00 B2   jsr L00B2           ;jump sub CALCOS
011A : DF 09      stx $09             ;store X in addr 09
011C : DE 0B      ldx $0B             ;load X in addr 0B
;PRM74 - store melody location into mem 11, sets X with melody addr and A with X(lo)
011E : A6 00      ldaa  $00,x         ;load A with addr X + 00h
0120 : 97 11      staa  X0011         ;store A in addr 11
0122 : A6 01      ldaa  $01,x         ;load A with addr X + 01h
0124 : EE 02      ldx $02,x           ;load X with addr X + 02h
0126 : DF 0F      stx $0F             ;store X in addr 0F
0128 : BD 01 38   jsr L0138           ;jump sub SYNTH8 0138
012B : DE 0B      ldx $0B             ;load X with addr 0B
012D : 08         inx                 ;incr X
012E : 08         inx                 ;incr X
012F : 08         inx                 ;incr X
0130 : 08         inx                 ;incr X
0131 : DF 0B      stx $0B             ;store X in addr 0B
0133 : 9C 09      cpx $09             ;comp X with addr 09
0135 : 26 E7      bne L0121           ;branch Z=0 PRM74
;PRM75
0137 : 39         rts                 ;return subroutine
;*************************************;
;SYNTH8 0138
;*************************************;
0138 : CE 00 12   ldx #$0012          ;load X with 0012h flood start
013B : 80 02      suba  #$02          ;A = A - 02h (0000 0010)
;SYN81 - 01 nop length writer for freq/pitch
013D : 23 15      bls L0154           ;branch if lower or same(C and Z = 1) SYN83 <-- write loop from 0012
013F : 81 03      cmpa  #$03          ;compare A with 03h (0000 0011) (needs 3 more bytes space for jmp write)
0141 : 27 09      beq L014C           ;branch Z=1 SYN82 <-- loop countdown =0
0143 : C6 01      ldab  #$01          ;load B with 01h (0000 0001)
0145 : E7 00      stab  $00,x         ;store B in addr X + 00h <-- 01 nop writer
0147 : 08         inx                 ;incr X
0148 : 80 02      suba  #$02          ;A = A - 02h (0000 0010)
014A : 20 F1      bra L013D           ;branch always SYN81
;SYN82 - writes 91 00 (cmpa $00) gate for freq/pitch end jmp
014C : C6 91      ldab  #$91          ;load B with 91h (1001 0001)
014E : E7 00      stab  $00,x         ;store B in addr X + 00h
0150 : 6F 01      clr $01,x           ;clear addr X + 01h
0152 : 08         inx                 ;incr X       
0153 : 08         inx                 ;incr X
;SYN83 - writes 7E 01 62 (jmp 0162) end freq/pitch
0154 : C6 7E      ldab  #$7E          ;load B with 7Eh (1111 1110)
0156 : E7 00      stab  $00,x         ;store B in addr X + 00h
0158 : C6 01      ldab  #$01          ;load B with 01h (0000 0001)
015A : E7 01      stab  $01,x         ;store B in addr X + 01h
015C : C6 62      ldab  #$62          ;load B with 62h (0110 0010) 
015E : E7 02      stab  $02,x         ;store B in addr X + 02h
0160 : DE 0F      ldx $0F             ;load X with addr 0F
;0162 - synth output writer and loop reader
0162 : 4F         clra                ;clear A
0163 : F6 00 0E   ldab  $000E         ;load B with addr 0E
0166 : 5C         incb                ;incr B
0167 : D7 0E      stab  $0E           ;store B in addr 0E <-- counter up
0169 : D4 11      andb  $11           ;and B with value in addr 11 (3E in 1st run)
016B : 54         lsrb                ;logic shift right B (bit7=0)
016C : 89 00      adca  #$00          ;A = Carry + A + 00h 
016E : 54         lsrb                ;logic shift right B (bit7=0)
016F : 89 00      adca  #$00          ;A = Carry + A + 00h 
0171 : 54         lsrb                ;logic shift right B (bit7=0)
0172 : 89 00      adca  #$00          ;A = Carry + A + 00h 
0174 : 54         lsrb                ;logic shift right B (bit7=0)
0175 : 89 00      adca  #$00          ;A = Carry + A + 00h 
0177 : 54         lsrb                ;logic shift right B (bit7=0)
0178 : 89 00      adca  #$00          ;A = Carry + A + 00h 
017A : 54         lsrb                ;logic shift right B (bit7=0)
017B : 89 00      adca  #$00          ;A = Carry + A + 00h 
017D : 54         lsrb                ;logic shift right B (bit7=0) (shift down till C set for adca to count up, A to DAC)
017E : 89 00      adca  #$00          ;A = Carry + A + 00h 
0180 : 1B         aba                 ;A = A + B 
0181 : 48         asla                ;arith shift left A (bit0 is 0)
0182 : 48         asla                ;arith shift left A (bit0 is 0)
0183 : 48         asla                ;arith shift left A (bit0 is 0)
0184 : 48         asla                ;arith shift left A (bit0 is 0)
0185 : 48         asla                ;arith shift left A (bit0 is 0) (increases value in A)
0186 : B7 80 00   staa  $8000         ;store A in DAC output SOUND
0189 : 09         dex                 ;decr X
018A : 27 03      beq  L018F          ;branch Z=1 SYN84
018C : 7E 00 12   jmp  L0012          ;jump to timer location 0012 (to jmp writes that set freq/pitch duration)
;SYN84
018F : 39         rts                 ;return subroutine
;*************************************;
;ORGAN INIT 0190 (incl. offset)
;*************************************;
0190 : 02 7F 8A 88                    ; PRM72/CALCOS offset calc +2, move 12 bytes for last 3 notes to part 4
;*************************************;
;ORGAN 0194 melody tables, SoundROM1 NMI
;*************************************;
;[pitch:nop length:X]                 ;note values
0194 : [3E 3F 02 3E][7C 04 03 FF]     ;PART 1
019C : [3E 3F 2C E2][7C 12 0D 74]
01A4 : [7C 0D 0E 41][7C 23 0B 50]
01AC : [7C 1D 29 F2][7C 3F 02 3E]
01B4 : [F8 04 03 FF][7C 3F 2C E2]
01BC : [F8 12 0D 74][F8 0D 0E 41]
;01C4 : end
[F8 23 0B 50][F8 1D 2F F2]            ;PART 2
[F8 23 05 A8][F8 12 06 BA]
[F8 04 07 FF][7C 37 04 C1]
[7C 23 05 A8][7C 12 06 BA]
[3E 04 07 FF][3E 37 04 C1]
[3E 23 05 A8][1F 12 06 BA]
;
[1F 04 07 FF][1F 37 04 C1]            ;PART 3  
[1F 23 16 A0][FE 1D 17 F9] 
[7F 37 13 06][7F 3F 08 FA]
[FE 04 0F FF][FE 0D 0E 41] 
[FE 23 0B 50][FE 1D 5F E4]
[00 47 3F 37][30 29 23 1D]        
;
[17 12 0D 08][7F 1D 0F FB]            ;PART 4 (taken from start of FDB table)
[7F 23 0F 15][FE 08 50 8A]
;*************************************;
; FDB table from Pharaoh ROM Sound7
;*************************************;
0194 : [7C 29 05 56][7C 1D 05 FE]     ;PART 1
019C : [7C 17 0C B2][7C 1D 0B FC]
01A4 : [7C 29 05 56][F8 04 07 FF]
01AC : [7C 29 05 56][7C 1D 05 FE]
01B4 : [7C 17 06 59][7C 04 07 FF]
01BC : [7C 1D 05 FE][7C 17 06 59]
;01C4 end
[7C 29 2A B6]                         ;PART 2
;*************************************;
; melody from Pharaoh ROM Sound24
;*************************************;
0194 : [7C 1D 05 FE][F8 04 1F FF]     ;PART 1
019C : [7C 04 1F FF][7C 1D 11 FA]   
01A4 : [00 1D 02 FF][7C 1D 02 FF] 
01AC : [7C 17 0C B2][7C 1D 0B FC]
01B4 : [7C 23 0A AD][7C 37 09 83] 
01BC : [7C 3F 11 F5][3E 3F 11 F5]
;01C4 end
[7C 17 16 34][7C 1D 02 FF]            ;PART 2
[7C 17 0C B2][7C 1D 0B FC]
[7C 29 0A AD][7C 3F 04 7D]
[7C 37 04 C1][7C 3F 14 36]
[F8 1D 14 FF][F8 04 03 FF]
[00 04 03 F8][F8 04 3F FF]            ;end Sound24
;*************************************;
; melody from Pharaoh ROM Sound22
;*************************************;
;18                                   ; ? 
0194 : [F8 04 02 FF][00 23 06 01]     ;notes
019C : [F8 04 03 FF][00 23 02 AB] 
01A4 : [F8 04 07 FF][7C 29 15 5B]
;60                                   ; ?
;*************************************;

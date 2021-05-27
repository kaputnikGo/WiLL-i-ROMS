        ;
        ;  Disassembled by:
        ;    DASMx object code disassembler
        ;    (c) Copyright 1996-2003   Conquest Consultants
        ;    Version 1.40 (Oct 18 2003)
        ;
        ;  File:    Algar.716
        ;
        ;  Size:    2048 bytes
        ;  Checksum:  C440
        ;  CRC-32:    67EA12E7
        ;
        ;  Date:    Thu May 13 16:54:41 2021
        ;
        ;  CPU:    Motorola 6800 (6800/6802/6808 family)
        ;
        ;Sound ROM 4 Algar, Sept 1980, System 6A (system 6 without 7-seg displays and some MPU ICs)
        ;
        ;updated 15 May 2021
        ;
        ;
org  $F800
;
;
F800 : 03                             ;checksum byte
;*************************************;
;RESET power on
;*************************************;
;SETUP
F801 : 0F         sei                 ;set interrupt mask
F802 : 8E 00 7F   lds  #$007F         ;load stack pointer with 007Fh(#ENDRAM)
F805 : CE 04 00   ldx  #$0400         ;load X with 0400h (PIA addr)(#SOUND)
F808 : 6F 01      clr  $01,x          ;clear addr X+01h (0401 PIA1 CR port A)ACCESS DDRA
F80A : 6F 03      clr  $03,x          ;clear addr X+03h (0403 PIA1 CR port B)ACCESS DDRB
F80C : 86 FF      ldaa  #$FF          ;load A with FFh
F80E : A7 00      staa  $00,x         ;store A in addr X+00h (0400 PIA1 PR/DDR port A set out)
F810 : C6 80      ldab  #$80          ;load B with 80h
F812 : E7 02      stab  $02,x         ;store B in addr X+02h (0402 PIA1 PR/DDR port B set in)
F814 : 86 37      ldaa  #$37          ;load A with 37h (CB2 LOW, IRQ ALLOWED)
F816 : A7 03      staa  $03,x         ;store A in addr X+03h (0403 PIA1 CR port B)
F818 : 86 3C      ldaa  #$3C          ;load A with 3Ch (CA2 SET INIT HIGH, NO IRQS)
F81A : A7 01      staa  $01,x         ;store A in addr X+01h (0401 PIA1 CR port A)
F81C : E7 02      stab  $02,x         ;store B in addr X+02h (0402 PIA1 PR/DDR port B set in)
F81E : CE 00 7F   ldx  #$007F         ;load X with 007Fh(#ENDRAM)
;SETLP:
F821 : 6F 00      clr  $00,x          ;clear addr X+00h
F823 : 09         dex                 ;decr X
F824 : 26 FB      bne  LF821          ;branch Z=0 SETLP
;
F826 : 86 3C      ldaa  #$3C          ;load A with 3Ch
F828 : 97 16      staa  $16           ;store A in addr 16
F82A : 0E         cli                 ;clear interrupts I=0
;STDBY LF82B:
F82B : 20 FE      bra  LF82B          ;branch always STDBY
;*************************************;
;Vari Loader
;*************************************;
;VARILD
F82D : 16         tab                 ;transfer A to B
F82E : 48         asla                ;arith shift left A (bit0 is 0) x2
F82F : 48         asla                ;arith shift left A (bit0 is 0) x4
F830 : 48         asla                ;arith shift left A (bit0 is 0) x8
F831 : 1B         aba                 ;A=A+B (x9)
F832 : CE 00 20   ldx  #$0020         ;load X with 0020h (#LOCRAM)
F835 : DF 1C      stx  $1C            ;store X in addr 1C
F837 : CE FC D5   ldx  #$FCD5         ;load X with FCD5h (VVECT SAW)
F83A : BD FC 12   jsr  LFC12          ;jump sub ADDX
F83D : C6 09      ldab  #$09          ;load B with 09h
F83F : 7E F9 09   jmp  LF909          ;jump TRANS
;*************************************;
;Variable Duty Cycle Square Wave Routine
;*************************************;
;VARI
F842 : 96 28      ldaa  $28           ;load A with addr 28
F844 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
;VAR0
F847 : DE 20      ldx  $20            ;load X with addr 20
F849 : DF 29      stx  $29            ;store X in addr 29
;V0
F84B : DE 25      ldx  $25            ;load X with addr 25
;V0LP
F84D : 96 29      ldaa  $29           ;load A with addr 29
F84F : 73 04 00   com  $0400          ;complement 1s in DAC output SOUND
;V1
F852 : 09         dex                 ;decr X
F853 : 27 10      beq  LF865          ;branch Z=1 VSWEEP
F855 : 4A         deca                ;decr A
F856 : 26 FA      bne  LF852          ;branch Z=0 V1
F858 : 96 2A      ldaa  $2A           ;load A with addr 2A
F85A : 73 04 00   com  $0400          ;complement 1s in DAC output SOUND
;V2
F85D : 09         dex                 ;decr X
F85E : 27 05      beq  LF865          ;branch Z=1 VSWEEP
F860 : 4A         deca                ;decr A
F861 : 26 FA      bne  LF85D          ;branch Z=0 V2
F863 : 20 E8      bra  LF84D          ;branch always V0LP
;VSWEEP
F865 : B6 04 00   ldaa  $0400         ;load A with addr 0400 SOUND
F868 : 2B 01      bmi  LF86B          ;branch N=1 VS1
F86A : 43         coma                ;complement 1s A
;VS1
F86B : 8B 00      adda  #$00          ;add A with 00h
F86D : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F870 : 96 29      ldaa  $29           ;load A with addr 29
F872 : 9B 22      adda  $22           ;add A with addr 22
F874 : 97 29      staa  $29           ;store A in addr 29
F876 : 96 2A      ldaa  $2A           ;load A with addr 2A
F878 : 9B 23      adda  $23           ;add A with addr 23
F87A : 97 2A      staa  $2A           ;store A in addr 2A
F87C : 91 24      cmpa  $24           ;compare A with addr 24
F87E : 26 CB      bne  LF84B          ;branch Z=0 V0
F880 : 96 27      ldaa  $27           ;load A with addr 27
F882 : 27 06      beq  LF88A          ;branch Z=1 VARX
F884 : 9B 20      adda  $20           ;add A with addr 20
F886 : 97 20      staa  $20           ;store A in addr 20
F888 : 26 BD      bne  LF847          ;branch Z=0 VAR0
;VARX
F88A : 39         rts                 ;return subroutine
;*************************************;
;Lightning - Liten routine params
;*************************************;
;LITE
F88B : 86 01      ldaa  #$01          ;load A with 01h
F88D : 97 27      staa  $27           ;store A in addr 27
F88F : C6 03      ldab  #$03          ;load B with 03h
F891 : 20 0A      bra  LF89D          ;branch always LITEN
;*************************************;
;Appear - Liten routine params
;*************************************;
;APPEAR
F893 : 86 FF      ldaa  #$FF          ;load A with FFh
F895 : 97 27      staa  $27           ;store A in addr 27
F897 : 86 60      ldaa  #$60          ;load A with 60h
F899 : C6 FF      ldab  #$FF          ;load B with FFh
F89B : 20 00      bra  LF89D          ;branch always LITEN
;*************************************;
;Lightning+Appear Noise Routine
;*************************************;
;LITEN:
F89D : 97 26      staa  $26           ;store A in addr 26
F89F : 86 FF      ldaa  #$FF          ;load A with FFh
F8A1 : B7 04 00   staa  $0400         ;store A in addr DAC output SOUND
F8A4 : D7 22      stab  $22           ;store B in addr 22
;LITE0
F8A6 : D6 22      ldab  $22           ;load B with addr 22
;LITE1
F8A8 : 8D 16      bsr  LF8C0          ;branch sub NSLTR
F8AA : 24 03      bcc  LF8AF          ;branch C=0 LITE2
F8AC : 73 04 00   com  $0400          ;complement 1s DAC output SOUND
;LITE2
F8AF : 96 26      ldaa  $26           ;load A with addr 26
;LITE3
F8B1 : 4A         deca                ;decr A
F8B2 : 26 FD      bne  LF8B1          ;branch Z=0 LITE3
F8B4 : 5A         decb                ;decr B
F8B5 : 26 F1      bne  LF8A8          ;branch Z=0 LITE1
F8B7 : 96 26      ldaa  $26           ;load A with addr 26
F8B9 : 9B 27      adda  $27           ;add A with addr 27
F8BB : 97 26      staa  $26           ;store A in addr 26
F8BD : 26 E7      bne  LF8A6          ;branch Z=0 LITE0
F8BF : 39         rts                 ;return subroutine
;*************************************;
;noise1 and lite1 routines combined
;*************************************;
;NSLTR
F8C0 : 96 17      ldaa  $17           ;load A with addr 17 (LO)
F8C2 : 44         lsra                ;logic shift right A 
F8C3 : 44         lsra                ;logic shift right A 
F8C4 : 44         lsra                ;logic shift right A 
F8C5 : 98 17      eora  $17           ;exclusive or A with addr 17 (LO)
F8C7 : 44         lsra                ;logic shift right A 
F8C8 : 76 00 16   ror  $0016          ;rotate right addr 0016 (bit0->C->bit7) (HI)
F8CB : 76 00 17   ror  $0017          ;rotate right addr 0017 (bit0->C->bit7) (LO)
F8CE : 39         rts                 ;return subroutine
;*************************************;
;Turbo - Noise routine params
;*************************************;
;TURBO
F8CF : 86 20      ldaa  #$20          ;load A with 20h
F8D1 : 97 22      staa  $22           ;store A in addr 22
F8D3 : 97 25      staa  $25           ;store A in addr 25
F8D5 : 86 01      ldaa  #$01          ;load A with 01h
F8D7 : CE 00 01   ldx  #$0001         ;load X with 0001h
F8DA : C6 FF      ldab  #$FF          ;load B with FFh
F8DC : 20 00      bra  LF8DE          ;branch always *+0
;*************************************;
;White Noise Routine
;*************************************;
;NOISE
F8DE : 97 20      staa  $20           ;store A in addr 20
;NOISE0
F8E0 : DF 23      stx  $23            ;store X in addr 23
;NOIS00
F8E2 : D7 21      stab  $21           ;store B in addr 21
F8E4 : D6 22      ldab  $22           ;load B with addr 22
;NOISE1
F8E6 : 8D D8      bsr  LF8C0          ;branch sub NSLTR
F8E8 : 86 00      ldaa  #$00          ;load A with 00h
F8EA : 24 02      bcc  LF8EE          ;branch C=0 NOISE2
F8EC : 96 21      ldaa  $21           ;load A with addr 21
;NOISE2
F8EE : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F8F1 : DE 23      ldx  $23            ;load X with addr 23
;NOISE3
F8F3 : 09         dex                 ;decr X
F8F4 : 26 FD      bne  LF8F3          ;branch Z=0 NOISE3
F8F6 : 5A         decb                ;decr B
F8F7 : 26 ED      bne  LF8E6          ;branch Z=0 NOISE1
F8F9 : D6 21      ldab  $21           ;load B with addr 21
F8FB : D0 20      subb  $20           ;sub B with addr 20
F8FD : 27 09      beq  LF908          ;branch Z=1 NSEND
F8FF : DE 23      ldx  $23            ;load X with addr 23
F901 : 08         inx                 ;incr X
F902 : 96 25      ldaa  $25           ;load A with addr 25
F904 : 27 DC      beq  LF8E2          ;branch Z=1 NOIS00
F906 : 20 D8      bra  LF8E0          ;branch always NOISE0
;NSEND
F908 : 39         rts                 ;return subroutine
;*************************************;
;Parameter Transfer
;*************************************;
;TRANS
F909 : 36         psha                ;push A into stack then SP-1
;TRANS1
F90A : A6 00      ldaa  $00,x         ;load A with X+00h
F90C : DF 1A      stx  $1A            ;store X in addr 1A
F90E : DE 1C      ldx  $1C            ;load X with addr 1C
F910 : A7 00      staa  $00,x         ;store A in X+00h
F912 : 08         inx                 ;incr X)
F913 : DF 1C      stx  $1C            ;store X in addr 1C
F915 : DE 1A      ldx  $1A            ;load X from addr 1A
F917 : 08         inx                 ;incr X
F918 : 5A         decb                ;decr B
F919 : 26 EF      bne  LF90A          ;branch Z=0 TRANS1
;
F91B : 32         pula                ;SP+1 pull stack into A
F91C : 39         rts                 ;return subroutine
;*************************************;
;Pulse synth uses NOTTBL,SNDTBL,WAVFRM tables
;*************************************;
;PULSE
F91D : 84 1F      anda  #$1F          ;and A with 1Fh (000x xxxx)
;PULSE3
F91F : 27 FE      beq  LF91F          ;branch Z=1 PULSE3
F921 : 84 0F      anda  #$0F          ;and A with 0Fh (0000 xxxx)
F923 : CE 00 20   ldx  #$0020         ;load X with 0020h (start locram addr value)
F926 : DF 1C      stx  $1C            ;store X in addr 1C (WVPTR)
F928 : CE FC B7   ldx  #$FCB7         ;load X with FCB7h (NOTTBL)(length)
F92B : BD FC 12   jsr  LFC12          ;jump sub ADDX 
F92E : A6 00      ldaa  $00,x         ;load A X+00h 
F930 : 97 30      staa  $30           ;store A in addr 30
F932 : CE FC A7   ldx  #$FCA7         ;load X with FCA7h (SNDTBL)
F935 : C6 10      ldab  #$10          ;load B with 10h (counter for SNDTBL - 16d, sizeof SNDTBL)
F937 : BD F9 09   jsr  LF909          ;jump sub TRANS (all 16 SNDTBL params to LOCRAM 0020-002F)
F93A : CE FC C7   ldx  #$FCC7         ;load X with FCC7h (WAVFRM)
F93D : E6 00      ldab  $00,x         ;load B with X+00h
;PULSE4
F93F : D7 32      stab  $32           ;store B in addr 32 (#WVFM)
F941 : DF 1C      stx  $1C            ;store X in addr 1C (WVPTR)
;PULSE5
F943 : CE 00 20   ldx  #$0020         ;load X with 0020h (SNDPTR in locram)
F946 : C6 08      ldab  #$08          ;load B with 08h (counter value)
F948 : D7 31      stab  $31           ;store B in addr 31 (COUNT)
;PULSE6
F94A : A6 00      ldaa  $00,x         ;load A with X+00h (#SND)
F94C : D6 30      ldab  $30           ;load B with addr 30 (#ENDNOT)
F94E : 7D 00 32   tst  $0032          ;test addr 0032 (#WVFM)
F951 : 26 06      bne  LF959          ;branch Z=0 PULSE7 (14th var in WAVTBL is 00)(non-zero or not identical)
F953 : A0 08      suba  $08,x         ;sub A with X+08h (#SND-SNDPTR+08)
F955 : A7 00      staa  $00,x         ;store A in X+00h
F957 : C0 03      subb  #$03          ;sub A with 03h 
;PULSE7
F959 : 08         inx                 ;incr X (SNDPTR+1 next locram addr)
F95A : B7 04 00   staa  $0400         ;store A in DAC output SOUND
;PULSE8
F95D : 5A         decb                ;decr B (#ENDNOT-1)
F95E : 26 FD      bne  LF95D          ;branch Z=0 PULSE8
F960 : 7A 00 31   dec  $0031          ;decr addr 0031 (COUNT)
F963 : 26 E5      bne  LF94A          ;branch Z=0 PULSE6
F965 : 7A 00 32   dec  $0032          ;decr addr 0032 (#WVFM-1)
F968 : 2A D9      bpl  LF943          ;branch N=0 PULSE5
F96A : DE 1C      ldx  $1C            ;load X with addr 1C (WVPTR)
F96C : 08         inx                 ;incr X (WVPTR+1)
F96D : E6 00      ldab  $00,x         ;load B with X+00h
F96F : 26 CE      bne  LF93F          ;branch Z=0 PULSE4
;PULSEX 
F971 : 20 FE      bra  LF971          ;branch always PULSEX
;*************************************;
;Knocker Routine
;*************************************;
;KNOCK:
F973 : CE FD 2F   ldx  #$FD2F         ;load X with FD2Fh KNKTAB
F976 : DF 22      stx  $22            ;store X in addr 22
;SQLP
F978 : DE 22      ldx  $22            ;load X with addr 22
F97A : A6 00      ldaa  $00,x         ;load A with X+00h
F97C : 27 33      beq  LF9B1          ;branch Z=1 END
F97E : E6 01      ldab  $01,x         ;load B with X+01h
F980 : C4 F0      andb  #$F0          ;and B with F0h
F982 : D7 21      stab  $21           ;store B with addr 21
F984 : E6 01      ldab  $01,x         ;load B with X+01h
F986 : 08         inx                 ;incr X
F987 : 08         inx                 ;incr X
F988 : DF 22      stx  $22            ;store X in addr 22
F98A : 97 20      staa  $20           ;store A in addr 20
F98C : C4 0F      andb  #$0F          ;and B with 0Fh
;LP0
F98E : 96 21      ldaa  $21           ;load A with addr 21
F990 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F993 : 96 20      ldaa  $20           ;load A with addr 20
;LP1
F995 : CE 00 05   ldx  #$0005         ;load X with 0005h (DELAY)
;LP11
F998 : 09         dex                 ;decr X
F999 : 26 FD      bne  LF998          ;branch Z=0 LP11
F99B : 4A         deca                ;decr A
F99C : 26 F7      bne  LF995          ;branch Z=0 LP1
F99E : 7F 04 00   clr  $0400          ;clear DAC output SOUND
F9A1 : 96 20      ldaa  $20           ;load A with addr 20
;LP2
F9A3 : CE 00 05   ldx  #$0005         ;load X with 0005h (DELAY)
;LP22
F9A6 : 09         dex                 ;decr X
F9A7 : 26 FD      bne  LF9A6          ;branch Z=0 LP22
F9A9 : 4A         deca                ;decr A
F9AA : 26 F7      bne  LF9A3          ;branch Z=0 LP2
F9AC : 5A         decb                ;decr B
F9AD : 26 DF      bne  LF98E          ;branch Z=0 LP0
F9AF : 20 C7      bra  LF978          ;branch always SQLP
;END
F9B1 : 39         rts                 ;return subroutine
;*************************************;
;Background Sound #1 increment (assumed)
;*************************************;
;BG1INC
F9B2 : 96 11      ldaa  $11           ;load A with addr 11
F9B4 : 8A 80      oraa  #$80          ;or A with 80h
F9B6 : 97 11      staa  $11           ;store A in addr 11
F9B8 : D6 10      ldab  $10           ;load B with addr 10
F9BA : C4 7F      andb  #$7F          ;and B with 7Fh
F9BC : C1 24      cmpb  #$24          ;compare B with 24h
F9BE : 26 01      bne  LF9C1          ;branch Z=0 BG1IO
F9C0 : 5F         clrb                ;clear B
;BG1IO LF9C1:
F9C1 : 5C         incb                ;incr B
F9C2 : D7 10      stab  $10           ;store B in addr 10
F9C4 : 39         rts                 ;return subroutine
;*************************************;
; vari/varild params
;*************************************;
;VARPRM
F9C5 : 86 07      ldaa  #$07          ;load A with 07h
F9C7 : BD F8 2D   jsr  LF82D          ;jump sub VARILD
F9CA : D6 10      ldab  $10           ;load B with addr 10
F9CC : C1 20      cmpb  #$20          ;compare B with 20h
F9CE : 23 02      bls  LF9D2          ;branch C+Z=1 VP1
F9D0 : C6 20      ldab  #$20          ;load B with 20h
;VP1
F9D2 : CE 01 F0   ldx  #$01F0         ;load X with 01F0h
F9D5 : 86 20      ldaa  #$20          ;load A with 20h
F9D7 : 10         sba                 ;A=A-B
F9D8 : 16         tab                 ;transfer A to B
;VP1LP1
F9D9 : C1 0F      cmpb  #$0F          ;compare B with 0Fh
F9DB : 23 08      bls  LF9E5          ;branch C+Z=1 VP1LP2
F9DD : 86 10      ldaa  #$10          ;load A with 10h
F9DF : BD FC 12   jsr  LFC12          ;jump sub ADDX
F9E2 : 5A         decb                ;decr B
F9E3 : 20 F4      bra  LF9D9          ;branch always VP1LP1
;VP1LP2
F9E5 : 86 08      ldaa  #$08          ;load A with 08h
F9E7 : BD FC 12   jsr  LFC12          ;jump sub ADDX
F9EA : 5A         decb                ;decr B
F9EB : 26 F8      bne  LF9E5          ;branch Z=0 VP1LP2
F9ED : DF 25      stx  $25            ;store X in addr 25
F9EF : 96 16      ldaa  $16           ;load A with addr 16
F9F1 : 48         asla                ;arith shift left A
F9F2 : 9B 16      adda  $16           ;add A with addr 16
F9F4 : 8B 0B      adda  #$0B          ;add A with 0Bh
F9F6 : 97 16      staa  $16           ;store A in addr 16
F9F8 : 97 20      staa  $20           ;store A in addr 20
;VP1X 
F9FA : BD F8 42   jsr  LF842          ;jump sub VARI
F9FD : 20 FB      bra  LF9FA          ;branch always VP1X
;*************************************;
;Background End Routine
;*************************************;
;BGEND
F9FF : 7F 00 10   clr  $0010          ;clear addr 0010
FA02 : 7F 00 11   clr  $0011          ;clear addr 0011
FA05 : 39         rts                 ;return subroutine
;*************************************;
;Background Sound #2 increment
;*************************************;
;BG2INC
FA06 : 96 10      ldaa  $10           ;load A with addr 10
FA08 : 8A 80      oraa  #$80          ;or A with 80h
FA0A : 97 10      staa  $10           ;store A in addr 10
FA0C : 96 11      ldaa  $11           ;load A with addr 11
FA0E : 84 3F      anda  #$3F          ;and A with 3Fh
FA10 : 81 1D      cmpa  #$1D          ;compare A with 1Dh
FA12 : 2E 02      bgt  LFA16          ;Z+(N or V)=0 BG2IO
FA14 : 86 1F      ldaa  #$1F          ;load A with 1Fh
;BG2IO LFA16:
FA16 : 4C         inca                ;incr A
FA17 : 97 11      staa  $11           ;store A in addr 11
FA19 : 39         rts                 ;return subroutine
;*************************************;
;Background 2 Routine
;*************************************;
;BG2
FA1A : 86 04      ldaa  #$04          ;load A with 04h
FA1C : BD FA 2F   jsr  LFA2F          ;jump sub GWLD
FA1F : 96 11      ldaa  $11           ;load A with addr 11
FA21 : 48         asla                ;arith shift left A
FA22 : 48         asla                ;arith shift left A
FA23 : 43         coma                ;complement 1s A
FA24 : BD FA E9   jsr  LFAE9          ;jump sub GEND60
;BG2LP LFA27: 
FA27 : 7C 00 24   inc  $0024          ;incr addr 0024
FA2A : BD FA EB   jsr  LFAEB          ;jump sub GEND61
FA2D : 20 F8      bra  LFA27          ;branch always BG2LP
;*************************************;
;GWAVE Loader
;*************************************;
;GWLD:
FA2F : 16         tab                 ;transfer A to B (MULKT BY 7)(sound select x7)
FA30 : 58         aslb                ;arith shift left B
FA31 : 1B         aba                 ;A=A+B 
FA32 : 1B         aba                 ;A=A+B
FA33 : 1B         aba                 ;A=A+B 
FA34 : CE FE 44   ldx  #$FE44         ;load X with FE44h (SVTAB)(SOUND VECTOR TABLE)
FA37 : BD FC 12   jsr  LFC12          ;jump sub ADDX
FA3A : A6 00      ldaa  $00,x         ;load A with X+00h 
FA3C : 16         tab                 ;transfer A to B 
FA3D : 84 0F      anda  #$0F          ;and A with 0Fh
FA3F : 97 21      staa  $21           ;store A in addr 21(GCCNT)(GET CYCLE COUNT)
FA41 : 54         lsrb                ;logic shift right B (B/2)
FA42 : 54         lsrb                ;logic shift right B
FA43 : 54         lsrb                ;logic shift right B
FA44 : 54         lsrb                ;logic shift right B
FA45 : D7 20      stab  $20           ;store B in addr 20(GECHO)(GET #ECHOS)
FA47 : A6 01      ldaa  $01,x         ;load A with X+01h
FA49 : 16         tab                 ;transfer A to B
FA4A : 54         lsrb                ;logic shift right B (B/2)
FA4B : 54         lsrb                ;logic shift right B 
FA4C : 54         lsrb                ;logic shift right B 
FA4D : 54         lsrb                ;logic shift right B 
FA4E : D7 22      stab  $22           ;store B in addr 22(GECDEC)
FA50 : 84 0F      anda  #$0F          ;and A with 0Fh 
FA52 : 97 1E      staa  $1E           ;store A in addr 1E
FA54 : DF 18      stx  $18            ;store X in addr 18
FA56 : CE FD 4D   ldx  #$FD4D         ;load X with FD4Dh (GWVTAB)(CALC WAVEFORM ADDR)
;GWLD2
FA59 : 7A 00 1E   dec  $001E          ;decr addr 001E
FA5C : 2B 08      bmi  LFA66          ;branch N=1 (GWLD3)
FA5E : A6 00      ldaa  $00,x         ;load A with X+00h
FA60 : 4C         inca                ;incr A
FA61 : BD FC 12   jsr  LFC12          ;jump sub ADDX
FA64 : 20 F3      bra  LFA59          ;branch always GWLD2
;GWLD3
FA66 : DF 25      stx  $25            ;store X in addr 25
FA68 : BD FB 25   jsr  LFB25          ;jump sub WVTRAN
FA6B : DE 18      ldx  $18            ;load X with addr 18
FA6D : A6 02      ldaa  $02,x         ;load A with X+02h
FA6F : 97 27      staa  $27           ;store A in addr 27
FA71 : BD FB 37   jsr  LFB37          ;jump sub WVDECA
FA74 : DE 18      ldx  $18            ;load X with addr 18
FA76 : A6 03      ldaa  $03,x         ;load A with X+03h
FA78 : 97 23      staa  $23           ;store A in addr 23
FA7A : A6 04      ldaa  $04,x         ;load A with X+04h
FA7C : 97 24      staa  $24           ;store A in addr 24
FA7E : A6 05      ldaa  $05,x         ;load A with X+05h
FA80 : 16         tab                 ;transfer A to B
FA81 : A6 06      ldaa  $06,x         ;load A with X+06h
FA83 : CE FF 00   ldx  #$FF00         ;load X with FF00h (#GFRTAB)
FA86 : BD FC 12   jsr  LFC12          ;jump sub ADDX
FA89 : 17         tba                 ;transfer B to A
FA8A : DF 28      stx  $28            ;store X in addr 28
FA8C : 7F 00 30   clr  $0030          ;clear addr 0030
FA8F : BD FC 12   jsr  LFC12          ;jump sub ADDX
FA92 : DF 2A      stx  $2A            ;store X in addr 2A
FA94 : 39         rts                 ;return subroutine
;*************************************;
;GWAVE routine
;*************************************;
;ACCA=Freq Pattern Length, X=Freq Pattern Addr
;GWAVE
FA95 : 96 20      ldaa  X0020
FA97 : 97 2F      staa  X002F
;GWT4
FA99 : DE 28      ldx  X0028
FA9B : DF 1A      stx  X001A
;GPLAY 
FA9D : DE 1A      ldx  X001A
FA9F : A6 00      ldaa  $00,x
FAA1 : 9B 30      adda  X0030
FAA3 : 97 2E      staa  X002E
FAA5 : 9C 2A      cpx  X002A
FAA7 : 27 26      beq  LFACF
FAA9 : D6 21      ldab  X0021
FAAB : 08         inx
FAAC : DF 1A      stx  X001A
;GOUT
FAAE : CE 00 31   ldx  #$0031
;GOUTLP 
FAB1 : 96 2E      ldaa  X002E
;GPRLP
FAB3 : 4A         deca
FAB4 : 26 FD      bne  LFAB3
FAB6 : A6 00      ldaa  $00,x
FAB8 : B7 04 00   staa  X0400
FABB : 08         inx
FABC : 9C 2C      cpx  X002C
FABE : 26 F1      bne  LFAB1
FAC0 : 5A         decb
FAC1 : 27 DA      beq  LFA9D
FAC3 : 08         inx
FAC4 : 09         dex
FAC5 : 08         inx
FAC6 : 09         dex
FAC7 : 08         inx
FAC8 : 09         dex
FAC9 : 08         inx
FACA : 09         dex
FACB : 01         nop
FACC : 01         nop
FACD : 20 DF      bra  LFAAE
;GEND 
FACF : 96 22      ldaa  X0022
FAD1 : 8D 64      bsr  LFB37
;GEND40
FAD3 : 7A 00 2F   dec  X002F
FAD6 : 26 C1      bne  LFA99
FAD8 : 96 13      ldaa  X0013
FADA : 9A 14      oraa  X0014
FADC : 26 46      bne  LFB24
;GEND50
FADE : 96 23      ldaa  X0023
FAE0 : 27 42      beq  LFB24
FAE2 : 7A 00 24   dec  X0024
FAE5 : 27 3D      beq  LFB24
FAE7 : 9B 30      adda  X0030
;GEND60
FAE9 : 97 30      staa  X0030
;GEND61
FAEB : DE 28      ldx  X0028
FAED : 5F         clrb
;GW0
FAEE : 96 30      ldaa  X0030
FAF0 : 7D 00 23   tst  X0023
FAF3 : 2B 06      bmi  LFAFB
FAF5 : AB 00      adda  $00,x
FAF7 : 25 08      bcs  LFB01
FAF9 : 20 0B      bra  LFB06
;GW1
FAFB : AB 00      adda  $00,x
FAFD : 27 02      beq  LFB01
FAFF : 25 05      bcs  LFB06
;GW2 
FB01 : 5D         tstb
FB02 : 27 08      beq  LFB0C
FB04 : 20 0F      bra  LFB15
;GW2A
FB06 : 5D         tstb
FB07 : 26 03      bne  LFB0C
FB09 : DF 28      stx  X0028
FB0B : 5C         incb
;GW2B 
FB0C : 08         inx
FB0D : 9C 2A      cpx  X002A
FB0F : 26 DD      bne  LFAEE
FB11 : 5D         tstb
FB12 : 26 01      bne  LFB15
FB14 : 39         rts
;GW3
FB15 : DF 2A      stx  X002A
FB17 : 96 22      ldaa  X0022
FB19 : 27 06      beq  LFB21
FB1B : 8D 08      bsr  LFB25
FB1D : 96 27      ldaa  X0027
FB1F : 8D 16      bsr  LFB37
;GEND0
FB21 : 7E FA 95   jmp  LFA95
;GEND1
FB24 : 39         rts
;*************************************;
;Wave Transfer Routine
;*************************************;
;WVTRAN
FB25 : CE 00 31   ldx  #$0031
FB28 : DF 1C      stx  X001C
FB2A : DE 25      ldx  X0025
FB2C : E6 00      ldab  $00,x
FB2E : 08         inx
FB2F : BD F9 09   jsr  LF909
FB32 : DE 1C      ldx  X001C
FB34 : DF 2C      stx  X002C
FB36 : 39         rts
;*************************************;
;Wave Decay Routinue 
;*************************************;
;decay amount in ACCA 1/16 per decay
;WVDECA
FB37 : 4D         tsta
FB38 : 27 2B      beq  LFB65
FB3A : DE 25      ldx  X0025
FB3C : DF 1A      stx  X001A
FB3E : CE 00 31   ldx  #$0031
FB41 : 97 1F      staa  X001F
;WVDLP
FB43 : DF 1C      stx  X001C
FB45 : DE 1A      ldx  X001A
FB47 : D6 1F      ldab  X001F
FB49 : D7 1E      stab  X001E
FB4B : E6 01      ldab  $01,x
FB4D : 54         lsrb
FB4E : 54         lsrb
FB4F : 54         lsrb
FB50 : 54         lsrb
FB51 : 08         inx
FB52 : DF 1A      stx  X001A
FB54 : DE 1C      ldx  X001C
FB56 : A6 00      ldaa  $00,x
;WVDLP1
FB58 : 10         sba
FB59 : 7A 00 1E   dec  X001E
FB5C : 26 FA      bne  LFB58
FB5E : A7 00      staa  $00,x
FB60 : 08         inx
FB61 : 9C 2C      cpx  X002C
FB63 : 26 DE      bne  LFB43
;WVDCX
FB65 : 39         rts
;*************************************;
;Interrupt Processing
;*************************************;
;IRQ
FB66 : 8E 00 7F   lds  #$007F         ;load SP with value 007Fh (#ENDRAM)
FB69 : 7F 00 00   clr  $0000          ;clear addr 0000
FB6C : B6 04 02   ldaa  $0402         ;load A with PIA sound select
FB6F : C6 80      ldab  #$80          ;load B with 80h
FB71 : F7 04 02   stab  $0402         ;store B in PIA
FB74 : 7C 00 15   inc  $0015          ;incr addr 0015 (IRQ counter for speech?)
FB77 : 43         coma                ;complement 1s A
FB78 : 84 7F      anda  #$7F          ;and A with 7Fh
FB7A : 36         psha                ;push A into stack then SP-1
FB7B : 84 5F      anda  #$5F          ;and A with 5Fh
FB7D : 81 16      cmpa  #$16          ;compare A with 16h
FB7F : 27 03      beq  LFB84          ;branch Z=1 IRQ1
FB81 : 7F 00 13   clr  $0013          ;clear addr 0013
;IRQ1
FB84 : 81 18      cmpa  #$18          ;compare A with 18h
FB86 : 27 03      beq  LFB8B          ;branch Z=1 IRQ2
FB88 : 7F 00 14   clr  $0014          ;clear addr 0014
;IRQ2
FB8B : 32         pula                ;SP+1 pull stack into A
FB8C : 85 20      bita  #$20          ;bit test A with 20h
FB8E : 27 18      beq  LFBA8          ;branch Z=1 IRQ6
;IRQ3 Speech ROM 4 check
FB90 : C6 7E      ldab  #$7E          ;load B with 7Eh
FB92 : F1 EF FD   cmpb  $EFFD         ;compare B with addr EFFD - Speech ROM IC4
FB95 : 26 05      bne  LFB9C          ;branch Z=0 IRQ4
FB97 : BD EF FD   jsr  LEFFD          ;jump sub EFFD - Speech ROM IC4
FB9A : 20 08      bra  LFBA4          ;branch always IRQ5
;IRQ4 Speech ROM 6 check
FB9C : F1 DF FD   cmpb  $DFFD         ;compare B with addr DFFD - Speech ROM IC6
FB9F : 26 07      bne  LFBA8          ;branch Z=0 IRQ6
FBA1 : BD DF FD   jsr  LDFFD          ;jump sub DFFD - Speech ROM IC6
;IRQ5
FBA4 : 96 00      ldaa  $00           ;load A with addr 00
FBA6 : 20 04      bra  LFBAC          ;branch always IRQ7
;IRQ6 
FBA8 : 0E         cli                 ;clear interrupts I=0
FBA9 : F6 04 02   ldab  $0402         ;load B with PIA sound select
;IRQ7
FBAC : 8D 20      bsr  LFBCE          ;branch sub IRQ10
FBAE : 7D 00 00   tst  $0000          ;test addr 0000
FBB1 : 26 DD      bne  LFB90          ;branch Z=0 IRQ3
FBB3 : 0E         cli                 ;clear interrupts I=0
FBB4 : F6 04 02   ldab  $0402         ;load B with PIA sound select
FBB7 : 96 10      ldaa  $10           ;load A with addr 10
FBB9 : 9A 11      oraa  $11           ;or A with addr 11
;IRQ8
FBBB : 27 FE      beq  LFBBB          ;branch Z=1 IRQ8
FBBD : 4F         clra                ;clear A
FBBE : 97 13      staa  $13           ;store A in addr 13
FBC0 : 97 14      staa  $14           ;store A in addr 14
FBC2 : 96 10      ldaa  $10           ;load A with addr 10
FBC4 : 27 05      beq  LFBCB          ;branch Z=1 IRQ9
FBC6 : 2B 03      bmi  LFBCB          ;branch N=1 IRQ9
FBC8 : 7E F9 C5   jmp  LF9C5          ;jump VARIPRM
;IRQ9 
FBCB : 7E FA 1A   jmp  LFA1A          ;jump BG2
;IRQ10
FBCE : 85 40      bita  #$40          ;bit test A with 40h
FBD0 : 27 09      beq  LFBDB          ;branch Z=1 IRQ11
FBD2 : 84 1F      anda  #$1F          ;and A with 1Fh
FBD4 : 81 01      cmpa  #$01          ;compare A with 01h
FBD6 : 27 03      beq  LFBDB          ;branch Z=1 IRQ11
FBD8 : 7E F9 1D   jmp  LF91D          ;jump PULSE
;IRQ11 
FBDB : 84 1F      anda  #$1F          ;and A with 1Fh
FBDD : 26 01      bne  LFBE0          ;branch Z=0 IRQ12
FBDF : 39         rts                 ;return subroutine
;IRQ12
FBE0 : 4A         deca                ;decr A
FBE1 : 27 3E      beq  LFC21          ;branch Z=1 TILT
FBE3 : 81 0F      cmpa  #$0F          ;compare A with 0Fh
FBE5 : 22 0B      bhi  LFBF2          ;branch IRQ13
;IRQLP1
FBE7 : 4A         deca                ;decr A
FBE8 : BD FA 2F   jsr  LFA2F          ;jump sub GWLD
FBEB : 7E FA 95   jmp  LFA95          ;jump GWAVE
;IRQLP2 
FBEE : 80 06      suba  #$06          ;sub A with 06h
FBF0 : 20 F5      bra  LFBE7          ;branch always IRQLP1
;IRQ13
FBF2 : 81 16      cmpa  #$16          ;compare A with 16h
FBF4 : 27 F8      beq  LFBEE          ;branch Z=1 IRQLP2
FBF6 : 81 17      cmpa  #$17          ;compare A with 17h
FBF8 : 27 F4      beq  LFBEE          ;branch Z=1 IRQLP2
FBFA : 81 17      cmpa  #$17          ;compare A with 17h
FBFC : 22 0C      bhi  LFC0A          ;branch C+Z=0 IRQ14
FBFE : 80 10      suba  #$10          ;sub A with 10h
FC00 : 48         asla                ;arith shift left A
FC01 : CE FC 9B   ldx  #$FC9B         ;load X with FC9Bh JMPTBL
FC04 : 8D 0C      bsr  LFC12          ;branch sub ADDX
FC06 : EE 00      ldx  $00,x          ;load X with X+00h
FC08 : 6E 00      jmp  $00,x          ;jump X+00h (jmptbl derived)
;IRQ14
FC0A : 80 18      suba  #$18          ;sub A with 18h
FC0C : BD F8 2D   jsr  LF82D          ;jump sub VARILD
FC0F : 7E F8 42   jmp  LF842          ;jump VARI
;*************************************;
;Add A to Index Register
;*************************************;
;ADDX
FC12 : DF 1A      stx  $1A            ;
FC14 : 9B 1B      adda  $1B           ;
FC16 : 97 1B      staa  $1B           ;
FC18 : 96 1A      ldaa  $1A           ;
FC1A : 89 00      adca  #$00          ;
FC1C : 97 1A      staa  $1A           ;
FC1E : DE 1A      ldx  $1A            ;
FC20 : 39         rts                 ;
;*************************************;
;Tilt sound, buzz saw down
;*************************************;
;TILT
FC21 : CE 00 E0   ldx  #$00E0         ;load X with 00E0h
;TILT1
FC24 : 86 20      ldaa  #$20          ;
FC26 : 8D EA      bsr  LFC12          ;
;TILT2
FC28 : 09         dex                 ;
FC29 : 26 FD      bne  LFC28          ;
FC2B : 7F 04 00   clr  X0400          ;
;TILT3
FC2E : 5A         decb                ;
FC2F : 26 FD      bne  LFC2E          ;
FC31 : 73 04 00   com  X0400          ;
FC34 : DE 1A      ldx  X001A          ;
FC36 : 8C 10 00   cpx  #$1000         ;
FC39 : 26 E9      bne  LFC24          ;
FC3B : 39         rts                 ;
;*************************************;
;Diagnostic Processing Here (NMI)
;*************************************;
;NMI
FC3C : 0F         sei                 ;set interrupt mask
FC3D : 8E 00 7F   lds  #$007F         ;load SP with 007Fh (ENDRAM)
FC40 : CE FF FF   ldx  #$FFFF         ;load X with FFFFh 
FC43 : 5F         clrb                ;clear B
;NMI1 
FC44 : E9 00      adcb  $00,x         ;B = C + B + X+00h
FC46 : 09         dex                 ;decr X
FC47 : 8C F8 00   cpx  #$F800         ;compare X with F800h
FC4A : 26 F8      bne  LFC44          ;branch Z=0 NMI1
FC4C : E1 00      cmpb  $00,x         ;compare B with X+00h
FC4E : 27 01      beq  LFC51          ;branch Z=1 NMI2
FC50 : 3E         wai                 ;wait interrupt, CCodes to Stack, PC+1 and halt
;NMI2 :
FC51 : 7F 04 02   clr  $0402          ;clear PIA sound select
FC54 : CE 2E E0   ldx  #$2EE0         ;load X with 2EE0h
;NMILP timer loop
FC57 : 09         dex                 ;decr X
FC58 : 26 FD      bne  LFC57          ;branch Z=0 NMILP
;
FC5A : BD F9 73   jsr  LF973          ;jump sub KNOCK
FC5D : BD F9 73   jsr  LF973          ;jump sub KNOCK
FC60 : BD F9 73   jsr  LF973          ;jump sub KNOCK
FC63 : 86 80      ldaa  #$80          ;load A with 80h
FC65 : B7 04 02   staa  $0402         ;store A in PIA sound select
FC68 : 86 01      ldaa  #$01          ;load A with 01
FC6A : BD FA 2F   jsr  LFA2F          ;jump sub GWLD
FC6D : BD FA 95   jsr  LFA95          ;jump sub GWAVE
FC70 : 86 0B      ldaa  #$0B          ;load A with 0Bh
FC72 : BD FA 2F   jsr  LFA2F          ;jump sub GWLD
FC75 : BD FA 95   jsr  LFA95          ;jump sub GWAVE
FC78 : BD F8 8B   jsr  LF88B          ;jump sub LITE
FC7B : 86 02      ldaa  #$02          ;load A with 02h
FC7D : BD F8 2D   jsr  LF82D          ;jump sub VARILD
FC80 : BD F8 42   jsr  LF842          ;jump sub VARI
FC83 : F6 DF FA   ldab  $DFFA         ;load B with addr DFFA - Speech ROM IC6
FC86 : C1 7E      cmpb  #$7E          ;compare B with 7Eh (looking for a jmp opcode)
FC88 : 26 05      bne  LFC8F          ;branch Z=0 NMI3 (no, check for other Speech ROM)
FC8A : BD DF FA   jsr  LDFFA          ;jump sub addr DFFA - Speech ROM IC6
FC8D : 20 AD      bra  LFC3C          ;branch always NMI
;NMI3 
FC8F : F6 EF FA   ldab  $EFFA         ;load B with EFFAh - Speech ROM IC4
FC92 : C1 7E      cmpb  #$7E          ;compare B with 7Eh  (looking for a jmp opcode)
FC94 : 26 A6      bne  LFC3C          ;branch Z=0 NMI (no)
FC96 : BD EF FA   jsr  LEFFA          ;jump sub addr EFFA - Speech ROM IC4
FC99 : 20 A1      bra  LFC3C          ;branch always NMI
;*************************************;
;Special Routine Jump Table
;*************************************;
;JMPTBL
FC9B : F9B2                           ;BG1INC
FC9D : FA06                           ;BG2INC
FC9F : F9FF                           ;BGEND
FCA0 : F893                           ;APPEAR
FCA3 : F88B                           ;LITE
FCA5 : F973                           ;KNOCK
;*************************************;
;SNDTBL
FCA7 : DA FF DA 80 26 01 26 80        ;
FCAF : 07 0A 07 00 F9 F6 F9 00        ;
;NOTTBL
FCB7 : 3A 3E 50 46 33 2C 27 20        ;
FCBF : 25 1C 1A 17 14 11 10 33        ;
;WAVFRM
FCC7 : 08 03 02 01 02 03 04 05        ;
FCCF : 06 0A 1E 32 70 00              ;
;*************************************;
;VARI VECTORS
;*************************************;
;VVECT EQU *
FCD5 : 40 0F 00 99 09 02 00 F8 FF     ;
FCDE : F0 0F 02 21 26 02 80 00 FF     ;
FCE7 : 05 01 01 01 20 01 08 FF FF     ;
FCF0 : FF 01 01 0F 02 01 80 00 FF     ;
FCF9 : 01 20 01 23 00 03 20 00 FF     ;
FD02 : 0E E7 35 33 79 03 80 F2 FF     ;
FD0B : 36 21 09 06 EF 03 C0 00 FF     ;
FD14 : 20 11 07 07 04 00 D0 00 BB     ;
FD1D : 01 08 00 47 01 01 22 00 DD     ;
FD26 : 17 0B 0D 44 01 02 03 00 CC     ;
;*************************************;
;* Knocker Pattern
;*************************************;
;KNKTAB
FD2F : 01 FC 02 FC 03 F8 04 F8        ;
FD37 : 06 F8 08 F4 0C F4 10 F4        ;
FD3F : 20 F2 40 F1 60 F1 80 F1        ;
FD47 : A0 F1 C0 F1 00 00              ;
;*************************************;
;GWave table, 1st byte wavelength
;*************************************;
;GWVTAB
FD4D : 04                             ;
FD4E : FF FF 00 00                    ;
;
FD52 : 08                             ;
FD53 : 7F D9 FF D9 7F 24 00 24        ;
;
FD5B : 08                             ;
FD5C : FF FF FF FF 00 00 00 00        ;
;
FD64 : 08                             ;
FD65 : 00 40 80 00 FF 00 80 40        ;
;
FD6D : 10                             ;
FD6E : 7F B0 D9 F5 FF F5 D9 B0        ;
FD76 : 7F 4E 24 09 00 09 24 4E        ;
;
FD7E : 10                             ;
FD7F : FF FF FF FF FF FF FF FF        ;
FD87 : 00 00 00 00 00 00 00 00        ;
;
FD8F : 10                             ;
FD90 : 00 F4 00 E8 00 DC 00 E2        ;
FD98 : 00 DC 00 E8 00 F4 00 00        ;
;
FDA0 : 10                             ;
FDA1 : 59 7B 98 AC B3 AC 98 7B        ;
FDA9 : 59 37 19 06 00 06 19 37        ;
;
FDB1 : 18                             ;(24)
FDB2 : FF FF FF BF FF FF FF 7F        ;
FDBA : FF FF FF 3F FF FF FF 00        ;
FDC2 : FF FF FF 3F FF FF FF BF        ;
;
FDCA : 30                             ;(48)
FDCB : 83 78 69 5B 4E 42 37 2D        ;
FDD3 : 24 1C 15 0F 0A 06 03 01        ;
FDDB : 00 01 03 06 0A 0F 15 1C        ;
FDE3 : 24 2D 37 42 4E 5B 69 78        ;
FDEB : 88 99 AB BE D2 E7 FD E7        ;
FDF3 : D2 BE AB 99 95 90 8C 88        ;
;
FDFB : 47                             ;(71), umm 72
FDFC : 8A 95 A0 AB B5 BF C8 D1        ;
FE04 : DA E1 E8 EE F3 F7 FB FD        ;
FE0C : FE FF FE FD FB F7 F3 EE        ;
FE14 : E8 E1 DA D1 C8 BF B5 AB        ;
FE1C : A0 95 8A 7F 75 6A 5F 54        ;
FE24 : 4A 40 37 2E 25 1E 17 11        ;
FE2C : 0C 08 04 02 01 00 01 02        ;
FE34 : 04 08 0C 11 17 1E 25 2E        ;
FE3C : 37 40 4A 54 5F 6A 75 7F        ;
;*************************************;
;GWAVE SOUND VECTOR TABLE
;*************************************;
;b0 GECHO,GCCNT
;b1 GECDEC,WAVE#
;b2 PREDECAY FACTOR
;b3 GDFINC
;b4 VARIABLE FREQ COUNTER
;b5 FREQ PATTERN LENGTH
;b6 FREQ PATTERN OFFSET
;SVTAB
FE44 : 52 37 00 00 00 10 54           ;
;
FE4B : 73 26 03 00 00 10 A1           ;
;
FE52 : 11 41 03 ED 09 09 4B           ;
;
FE59 : 01 1A 01 01 01 01 6A           ;
;
FE60 : F2 24 02 00 00 10 36           ;
;
FE67 : 26 A0 00 00 00 16 54           ;
;
FE6E : 57 31 00 00 00 20 91           ;
;
FE75 : 46 41 02 0E 01 0E 27           ;
;
FE7C : 51 36 00 00 00 0C 00           ;
;
FE83 : 33 60 01 01 01 20 36           ;
;
FE8A : 16 84 03 0E 01 0E 27           ;
;
FE91 : 11 26 00 F0 05 08 B1           ;
;
FE98 : 51 32 01 00 00 10 00           ;(FF00)(16)
;
FE9F : 46 56 00 00 00 08 6A           ;
;
FEA6 : 14 27 01 FE 10 10 54           ;
;
FEAD : 63 27 06 00 00 10 A1           ;
;
FEB4 : 52 32 04 00 00 20 84           ;
;*************************************;
;zero padding
FEBB : 00 00 00 00 00 00 00 00
FEC3 : 00 00 00 00 00 00 00 00
FECB : 00 00 00 00 00 00 00 00
FED3 : 00 00 00 00 00 00 00 00
FEDB : 00 00 00 00 00 00 00 00
FEE3 : 00 00 00 00 00 00 00 00
FEEB : 00 00 00 00 00 00 00 00
FEF3 : 00 00 00 00 00 00 00 00
FEFB : 00 00 00 00 00
;*************************************;
;GWAVE FREQ PATTERN TABLE
;*************************************;
;GFRTAB
FF00 : 10 90 91 A2 3A B4 5B C6        ;
FF08 : 7C D8 9D EA BE FC DF 0E        ;
;
FF10 : 01 01 02 02 04                 ;
;
FF15 : 88 40 08 08 40 88              ;
;
FF1B : 01 01 02 02 03 04 05 06        ;
;Ed's Sound 10
FF23 : 07 08 09 0A 0C 08              ;ED10FP
;
FF29 : 80 10 78 18 70 20 60 28        ;
FF31 : 58 30 50 40 48                 ;
;
FF36 : 01 02 02 03 03 03 06 06        ;
FF3E : 06 06 0F 1F 36 55 74 91        ;
FF46 : A8 B9 CA DB EC                 ;
;
FF4B : 80 7C 78 74 70 74 78 7C 80     ;
;Heartbeat Distorto 
FF54 : 01 01 02 02 04 04 08 08        ;HBDSND
FF5C : 10 20 28 30 38 40 48 50        ;
FF64 : 60 70 80 A0 B0 C0              ;
;
;BigBen Sounds variation
FF6A : 08 40 06 44 06 44 06 44 06 44  ;BBSND
FF74 : 06 44 06 44 06 44 06 44 06 44  ;

FF7E : 01 02 04 08 09 0A              ;
;
FF84 : 3F 4F 5F 6F 7F 68 58 48        ;
FF8C : 38 28 18 1F 2F                 ;
;
FF91 : 01 01 01 01 02 02 03 03        ;
FF99 : 04 04 05 06 08 0A 0C 10        ;
FFA1 : 14 18 20 30 40 50 40 30        ;
FFA9 : 20 10 0C 0A 08 07 06 05        ;
;
FFB1 : CC BB 60 10 EE AA 50 00        ;
FFB9 : 93 8E 82 7C 71 6A 5F 42        ;
;*************************************;
;zero padding
FFC1 : 00 00 00 00 00 00 00 
FFC8 : 00 00 00 00 00 00 00 00
FFD0 : 00 00 00 00 00 00 00 00
FFD8 : 00 00 00 00 00 00 00 00
FFE0 : 00 00 00 00 00 00 00 00
FFE8 : 00 00 00 00 00 00 00 00
;*************************************;
;jumps and FDB from non-existent Speech ROM
;*************************************;
FFF0 : 7E FB CE    jmp  LFBCE         ;jump IRQ10
FFF3 : 7E FC 12    jmp  LFC12         ;jump ADDX
;
FFF6 : F9FF                           ;BGEND
;*************************************;
;Motorola vector table
;*************************************;
FFF8 : FB 66                          ;IRQ 
FFFA : F8 01                          ;RESET SWI (software) 
FFFC : FC 3C                          ;NMI 
FFFE : F8 01                          ;RESET (hardware) 

;--------------------------------------------------------------






;--------------------------------------------------------------

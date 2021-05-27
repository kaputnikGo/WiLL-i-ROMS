        ;
        ;  Disassembled by:
        ;    DASMx object code disassembler
        ;    (c) Copyright 1996-2003   Conquest Consultants
        ;    Version 1.40 (Oct 18 2003)
        ;
        ;  File:    BlackKnight.716
        ;
        ;  Size:    2048 bytes
        ;  Checksum:  DD2F
        ;  CRC-32:    6D454C0E
        ;
        ;  Date:    Sat May 15 15:19:28 2021
        ;
        ;  CPU:    Motorola 6800 (6800/6802/6808 family)
        ;
        ;Pinball Sound ROM 5 Black Knight, with Speech ROMS
        ;
        ;updated 17 May 2021
        ;
        ;
;
org  $F800
;
F800 : 87                             ;checksum byte
;*************************************;
;RESET power on
;*************************************;
;SETUP
F801 : 0F         sei                 ;set interrupt mask
F802 : 8E 00 7F   lds  #$007F         ;load stack pointer with 007Fh (ENDRAM)
F805 : CE 04 00   ldx  #$0400         ;load X with 0400h  PIA addr
F808 : 6F 01      clr  $01,x          ;clear X+01h (0401) PIA CR port A
F80A : 6F 03      clr  $03,x          ;clear X+03h (0403) PIA CR port B
F80C : 86 FF      ldaa  #$FF          ;load A with FFh 
F80E : A7 00      staa  $00,x         ;store A in addr X+00h (0400) PIA port A out (DAC sound)
F810 : C6 80      ldab  #$80          ;load B with 80h 
F812 : E7 02      stab  $02,x         ;store B in addr X+00h (0402) PIA port B in (sound select)
F814 : 86 37      ldaa  #$37          ;load A with 37h (CB2 LOW, IRQ ALLOWED)
F816 : A7 03      staa  $03,x         ;store A in addr X+03h (0403) PIA CR port B
F818 : 86 3C      ldaa  #$3C          ;load A with 3Ch (CA2 SET INIT HIGH, NO IRQS)
F81A : A7 01      staa  $01,x         ;store A in addr X+01h (0401) PIA1 CR port A
F81C : 97 13      staa  $13           ;store A in addr 13
F81E : E7 02      stab  $02,x         ;store A in addr X + 02h (0402) PIA port B
F820 : 97 00      staa  $00           ;store A in addr X + 00h (0400) PIA port A
F822 : 4F         clra                ;clear A
F823 : 97 10      staa  $10           ;store A in addr 10
F825 : 97 11      staa  $11           ;store A in addr 11
F827 : 97 0D      staa  $0D           ;store A in addr 0D
F829 : 97 0E      staa  $0E           ;store A in addr 0E
F82B : 97 0F      staa  $0F           ;store A in addr 0F
F82D : 97 01      staa  $01           ;store A in addr 01
F82F : 0E         cli                 ;clear interrupts I=0
;STDBY
F830 : 20 FE      bra  LF830          ;branch always STDBY
;*************************************;
;Vari Loader
;*************************************;
;VARILD
F832 : 16         tab                 ;transfer A to B
F833 : 48         asla                ;arith shift left A (x2)
F834 : 48         asla                ;arith shift left A (x4)
F835 : 48         asla                ;arith shift left A (x8)
F836 : 1B         aba                 ;A=A+B (x9)
F837 : CE 00 1E   ldx  #$001E         ;load X with 001E (#LOCRAM)
F83A : DF 1A      stx  $1A            ;store X in addr 1A(XPTR)(SET XSFER)
F83C : CE FD A7   ldx  #$FDA7         ;load X with FDA7h(VVECT SAW)
F83F : BD FD 1B   jsr  LFD1B          ;jump sub ADDX
F842 : C6 09      ldab  #$09          ;load B with 09h(COUNT)
F844 : 7E FA 79   jmp  LFA79          ;jump TRANS
;*************************************;
;Variable Duty Cycle Square Wave Routine
;*************************************;
;VARI
F847 : 96 26      ldaa  $26           ;load A with addr 26
F849 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
;VAR0
F84C : 96 1E      ldaa  $1E           ;load A with addr 1E
F84E : 97 27      staa  $27           ;store A in addr 27
F850 : 96 1F      ldaa  $1F           ;load A with addr 1F
F852 : 97 28      staa  $28           ;store A in addr 28
;V0
F854 : DE 23      ldx  $23            ;load X with addr 23
;V0LP
F856 : 96 27      ldaa  $27           ;load a with addr 27
F858 : 73 04 00   com  $0400          ;complement 1s in DAC output SOUND
;V1
F85B : 09         dex                 ;decr X
F85C : 27 10      beq  LF86E          ;branch Z=1 VSWEEP
F85E : 4A         deca                ;decr A
F85F : 26 FA      bne  LF85B          ;branch Z=0 V1
F861 : 73 04 00   com  $0400          ;complement 1s DAC output SOUND
F864 : 96 28      ldaa  $28           ;load A with addr 28
;V2
F866 : 09         dex                 ;decr X
F867 : 27 05      beq  LF86E          ;branch Z=1 VSWEEP
F869 : 4A         deca                ;decr A
F86A : 26 FA      bne  LF866          ;branch Z=0 V2
F86C : 20 E8      bra  LF856          ;branch always V0LP
;VSWEEP
F86E : B6 04 00   ldaa  $0400         ;load a with DAC SOUND
F871 : 2B 01      bmi  LF874          ;branch N=1 VS1
F873 : 43         coma                ;complement 1s A
;VS1
F874 : 8B 00      adda  #$00          ;add A with 00h
F876 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F879 : 96 27      ldaa  $27           ;load A with addr 27
F87B : 9B 20      adda  $20           ;add A with addr 20
F87D : 97 27      staa  $27           ;store A in addr 27
F87F : 96 28      ldaa  $28           ;load A with addr 28
F881 : 9B 21      adda  $21           ;add A with addr 21
F883 : 97 28      staa  $28           ;store A in addr 28
F885 : 91 22      cmpa  $22           ;compare A with addr 22
F887 : 26 CB      bne  LF854          ;branch Z=0 V0
F889 : 96 25      ldaa  $25           ;load A with addr 25
F88B : 27 06      beq  LF893          ;branch Z=1 VARX
F88D : 9B 1E      adda  $1E           ;add A with addr 1E
F88F : 97 1E      staa  $1E           ;store A in addr 1E
F891 : 26 B9      bne  LF84C          ;branch Z=0 VAR0
;VARX
F893 : 39         rts                 ;return subroutine
;*************************************;
;Noise Call routines
;*************************************;
;NSCLL1
F894 : CE F8 9A   ldx  #$F89A         ;load X with F89Ah
F897 : 7E F9 4F   jmp  LF94F          ;jump NOISLG
;
F89A : 10 FF 01 01 01                 ;
;
;NSCLL2
F89F : CE F8 A5   ldx  #$F8A5         ;load X with F8A5h
F8A2 : 7E F9 4F   jmp  LF94F          ;jump NOISLG
;
F8A5 : C0 FF 01 01 01                 ;
;*************************************;
;Whistle Call routine
;*************************************;
;WSCLL
F8AA : CE F8 C9   ldx  #$F8C9         ;load X with F8C9h
F8AD : DF 2F      stx  X002F
F8AF : BD FA 31   jsr  LFA31          ;jump sub WISLD
F8B2 : CE A5 00   ldx  #$A500         ;load X with A500h (SEED)
F8B5 : DF 13      stx  X0013
F8B7 : CE F8 F2   ldx  #$F8F2         ;load X with F8F2h (CR1)
F8BA : BD F9 3A   jsr  LF93A          ;jump sub NOISLD
F8BD : BD F9 D5   jsr  LF9D5          ;jump sub NINIT
F8C0 : CE F8 F7   ldx  #$F8F7         ;load X with F8F7h (CR2)
F8C3 : BD F9 3A   jsr  LF93A          ;jump sub NOISLD
F8C6 : 7E F9 E2   jmp  LF9E2          ;jump NINIT
;*************************************;
;Whistle Tables
;*************************************;
F8C9 : 90 10 02 14 40                 ;
F8CE : B4 40 FF 14 30                 ;
F8D3 : D0 32 02 10 60                 ;
F8D8 : EE 20 02 08 54                 ;
F8DD : E9 54 FF 20 28                 ;
F8E2 : C0 30 02 14 58                 ;
F8E7 : AC 20 02 08 58                 ;
F8EC : A6 58 FF 18 22                 ;
F8F1 : 00                             ;
;
F8F2 : 30 10 FC 00 01                 ;CR1
F8F7 : 30 FC 01 00 01                 ;CR2
;*************************************;
;White Noise Calling routine
;*************************************;
;
F8FC : 10 F0 F0 01 30                 ;
;WNCLL
F901 : CE F8 FC   ldx  #$F8FC         ;load X with F8FCh
F904 : 8D 34      bsr  LF93A          ;branch sub NOISLD
;WNCLP1
F906 : 8D 14      bsr  LF91C          ;branch sub WNCLL2
F908 : 8D 12      bsr  LF91C          ;branch sub WNCLL2
F90A : 86 28      ldaa  #$28          ;load A with 28h
F90C : 97 3B      staa  $3B           ;store A in addr 38
F90E : 73 00 23   com  $0023          ;complement 1s in addr 23
F911 : 8D 3E      bsr  LF951          ;branch sub NOIN
F913 : 73 00 23   com  $0023          ;complement 1s in addr 23
F916 : 86 1E      ldaa  #$1E          ;load A with 1Eh
F918 : 8D 0D      bsr  LF927          ;branch sub WNCLL3
F91A : 20 EA      bra  LF906          ;branch always WNCLP1
;WNCLL2
F91C : 86 30      ldaa  #$30          ;load A with 30h
F91E : 97 3B      staa  $3B           ;store A in addr 3B
F920 : 8D 2F      bsr  LF951          ;branch sub NOIN
F922 : 86 02      ldaa  #$02          ;load A with 02h
F924 : 8D 01      bsr  LF927          ;branch sub WNCLL3
F926 : 39         rts                 ;return subroutine
;WNCLL3
F927 : 16         tab                 ;transfer A to B
F928 : CE 04 00   ldx  #$0400         ;load X with 0400h (DAC addr)
;WNCLL4
F92B : 17         tba                 ;transfer B to A
;WNCLP2
F92C : 4A         deca                ;decr A
F92D : 26 FD      bne  LF92C          ;branch Z=0 WNCLP2
F92F : 09         dex                 ;decr X
F930 : 8C 00 00   cpx  #$0000         ;compare X with 1000h
F933 : 26 F6      bne  LF92B          ;branch Z=0 WNCLL4
F935 : 86 F0      ldaa  #$F0          ;load A with F0h
F937 : 97 1F      staa  $1F           ;store A in addr 1F
F939 : 39         rts                 ;return subroutine
;*************************************;
;*Noise with Whistle Routine
;*************************************;
;*NFRQ=INIT PERIOD, NAMP=INIT AMP, DECAY AMPLITUDE RATE
;*CYCNT=CYCLE COUNT, NFFLG= FREQ DECAY FLAG
;*NFFLG=0 NO FREQ CHANGE;=POS DECAY;=MINUS INC FREQ
;*NOISE LOAD PROG-ENTER WITH XREG POINTING TO DATA
;NOISLD 
F93A : A6 00      ldaa  $00,x         ;load A with addr X+00h
F93C : 97 36      staa  $36           ;store A in addr 36
F93E : A6 01      ldaa  $01,x         ;load A with addr X+01h
F940 : 97 1F      staa  $1F           ;store A in addr 1F
F942 : A6 02      ldaa  $02,x         ;load A with addr X+02h
F944 : 97 1E      staa  $1E           ;store A in addr 1E
F946 : A6 03      ldaa  $03,x         ;load A with addr X+03h
F948 : 97 23      staa  $23           ;store A in addr 23
F94A : A6 04      ldaa  $04,x         ;load A with addr X+04h
F94C : 97 3B      staa  $3B           ;store A in addr 3B
;NEND
F94E : 39         rts                 ;return subroutine
;
;LOAD NOISE AND GO
;NOISLG
F94F : 8D E9      bsr  LF93A          ;branch sub NOISLD
;
;NOISE INIT
;NOIN
F951 : 8D 30      bsr  LF983          ;branch sub NSUB
;
;NOISE LOOP
;NO1
F953 : 8D 58      bsr  LF9AD          ;branch sub RNT
F955 : 96 3A      ldaa  $3A           ;load a with addr 3A
F957 : 91 3B      cmpa  $3B           ;compare B with addr 3B
F959 : 26 F8      bne  LF953          ;branch Z=0 NO1
F95B : 59         rolb                ;rotate left B
F95C : F7 04 00   stab  $0400         ;store B in DAC output SOUND
F95F : 8D 2D      bsr  LF98E          ;branch sub NOISE1
F961 : 8D 38      bsr  LF99B          ;branch sub NOISE2
F963 : 8D 5C      bsr  LF9C1          ;branch sub RNA
F965 : 7D 00 1F   tst  $001F          ;test addr 001F
F968 : 27 E4      beq  LF94E          ;branch Z=1 NEND
F96A : 7D 00 20   tst  $0020          ;test addr 0020
F96D : 26 E4      bne  LF953          ;branch Z=0 NO1
F96F : 7D 00 23   tst  $0023          ;test addr 0023
F972 : 27 DF      beq  LF953          ;branch Z=1 NO1
F974 : 2B 05      bmi  LF97B          ;branch N=1 NO3
F976 : 7C 00 3B   inc  $003B          ;incr addr 003B
F979 : 20 D8      bra  LF953          ;branch always NO1
;
;NO3
F97B : 7A 00 3B   dec  $003B          ;decr addr 003B
F97E : 7A 00 3A   dec  $003A          ;decr addr 003A
F981 : 20 D0      bra  LF953          ;branch always NO1
;NSUB
F983 : 7F 00 20   clr  $0020          ;clear addr 0020
F986 : 96 3B      ldaa  $3B           ;load A with addr 3B
F988 : 97 3A      staa  $3A           ;store A in addr 3A
F98A : 7F 00 39   clr  $0039          ;clear addr 0039
F98D : 39         rts                 ;return subroutine
;*
;* 23 CYCLES FOR EACH SUBROUTINE PLUS CALLING OVERHEAD
;*
;NOISE1
F98E : 96 14      ldaa  $14           ;load a with addr 14
F990 : 44         lsra                ;logic shift right A
F991 : 44         lsra                ;logic shift right A
F992 : 44         lsra                ;logic shift right A
F993 : 98 14      eora  $14           ;exclusive or A with addr 14
F995 : 97 34      staa  $34           ;store A in addr 34
F997 : 08         inx                 ;incr X
F998 : 84 07      anda  #$07          ;and A with 07h
F99A : 39         rts                 ;return subroutine
;
;NOISE2
F99B : 96 34      ldaa  $34           ;load A with addr 34
F99D : 44         lsra                ;logic shift right A
F99E : 76 00 13   ror  $0013          ;rotate right addr 0013
F9A1 : 76 00 14   ror  $0014          ;rotate right addr 0014
F9A4 : 86 00      ldaa  #$00          ;load A with 00h
F9A6 : 24 02      bcc  LF9AA          ;branch C=0 NOISE3
F9A8 : 96 1F      ldaa  $1F           ;load A with 1Fh
;NOISE3
F9AA : 97 39      staa  $39           ;store A in addr 39
F9AC : 39         rts                 ;return subroutine
;
;RNT
F9AD : 96 3B      ldaa  $3B           ;load A with addr 3B
F9AF : 7A 00 3A   dec  $003A          ;decr addr 003A
F9B2 : 27 04      beq  LF9B8          ;branch Z=1 NW0
F9B4 : 08         inx                 ;incr X
F9B5 : 09         dex                 ;decr X
F9B6 : 20 08      bra  LF9C0          ;branch always NNW1
;
;NW0
F9B8 : 97 3A      staa  $3A           ;store A in addr 3A
F9BA : D6 39      ldab  $39           ;load B with addr 39
F9BC : 54         lsrb                ;logic shift right B
F9BD : 7C 00 20   inc  $0020          ;incr addr 0020
;NNW1
F9C0 : 39         rts                 ;return subroutine
;
;RNA:
F9C1 : 96 36      ldaa  $36           ;load A with addr 36
F9C3 : 91 20      cmpa  $20           ;compare A with addr 20
F9C5 : 27 04      beq  LF9CB          ;branch Z=1 NW2
F9C7 : 08         inx                 ;incr X
F9C8 : 09         dex                 ;decr X
F9C9 : 20 09      bra  LF9D4          ;branch always NW3
;
;NW2
F9CB : 7F 00 20   clr  $0020          ;clear addr 0020
F9CE : 96 1F      ldaa  $1F           ;load A with addr 1F
F9D0 : 90 1E      suba  $1E           ;sub A with addr 1E
F9D2 : 97 1F      staa  $1F           ;store A in addr 1F
;NW3:
F9D4 : 39         rts                 ;return subroutine
;*
;* NOISE WITH WHISTLE MAIN LOOP
;NINIT
F9D5 : 7F 00 2D   clr  $002D          ;clear addr 002D
F9D8 : 7F 00 37   clr  $0037          ;clear addr 0037
F9DB : 86 0E      ldaa  #$0E          ;load A with 0Eh
F9DD : 97 2E      staa  $2E           ;store A in addr 2E
F9DF : 7F 00 33   clr  $0033          ;clear addr 0033
;NINIT2
F9E2 : 8D 9F      bsr  LF983          ;branch sub NSUB
;WIN:
F9E4 : 8D A8      bsr  LF98E          ;branch sub NOISE1
F9E6 : BD FA 6B   jsr  LFA6B          ;jump sub TRIDR
F9E9 : 8D B0      bsr  LF99B          ;branch sub NOISE2
F9EB : BD FA 6B   jsr  LFA6B          ;jump sub TRIDR
F9EE : 8D BD      bsr  LF9AD          ;branch sub RNT
F9F0 : 8D 79      bsr  LFA6B          ;branch sub TRIDR
F9F2 : 8D CD      bsr  LF9C1          ;branch sub RNA
F9F4 : 8D 75      bsr  LFA6B          ;branch sub TRIDR
F9F6 : 8D 0A      bsr  LFA02          ;branch sub TRICNT
F9F8 : 8D 71      bsr  LFA6B          ;branch sub TRIDR
F9FA : 8D 1D      bsr  LFA19          ;branch sub TRIFRQ
F9FC : 8D 6D      bsr  LFA6B          ;branch sub TRIDR
F9FE : 8D 52      bsr  LFA52          ;branch sub NNW
FA00 : 20 E2      bra  LF9E4          ;branch always WIN
;
;TRICNT:
FA02 : 96 32      ldaa  $032          ;load A with addr 32
FA04 : 7A 00 2E   dec  $002E          ;decr addr 002E
FA07 : 27 07      beq  LFA10          ;branch Z=1 NW4
FA09 : B6 00 1F   ldaa  $001F         ;load A with addr 001F
FA0C : 26 0A      bne  LFA18          ;branch Z=0 NW5
FA0E : 20 68      bra  LFA78          ;branch always NSEND
;
;NW4:
FA10 : 97 2E      staa  $2E           ;store A in addr 2E
FA12 : 96 2D      ldaa  $2D           ;load A with addr 2D
FA14 : 9B 37      adda  $37           ;add A with addr 37
FA16 : 97 2D      staa  $2D           ;store A in addr 2D
;NW5:
FA18 : 39         rts                 ;return subroutine
;
;TRIFRQ:
FA19 : 96 2D      ldaa  $2D           ;load A with addr 2D
FA1B : 91 35      cmpa  $35           ;compare A with addr 35
FA1D : 27 07      beq  LFA26          ;branch Z=1 NW6
FA1F : 08         inx                 ;incr X
FA20 : 96 1F      ldaa  $1F           ;load A with addr 1F
FA22 : 26 2A      bne  LFA4E          ;branch Z=0 NW7
FA24 : 20 29      bra  LFA4F          ;branch always PEND
;
;NW6:
FA26 : 7F 00 2D   clr  $002D          ;clear addr 002D
FA29 : 7F 00 37   clr  $0037          ;clear addr 0037
FA2C : 7F 00 33   clr  $0033          ;clear addr 0033
FA2F : DE 2F      ldx  $2F            ;load X with addr 2F
;WISLD
FA31 : A6 00      ldaa  $00,x         ;load A with addr X+00h
FA33 : 97 2C      staa  $2C           ;store A in addr 2C
FA35 : 27 17      beq  LFA4E          ;branch Z=1 NW7
FA37 : A6 01      ldaa  $01,x         ;load A with addr X+01h
FA39 : 97 31      staa  $31           ;store A in addr 31
FA3B : A6 02      ldaa  $02,x         ;load A with addr X+02h
FA3D : 97 38      staa  $38           ;store A in addr 38
FA3F : A6 03      ldaa  $03,x         ;load A with addr X+03h
FA41 : 97 32      staa  $32           ;store A in addr 32
FA43 : A6 04      ldaa  $04,x         ;load A with addr X+04h
FA45 : 97 35      staa  $35           ;store A in addr 35
FA47 : 86 05      ldaa  #$05          ;load A with 05h
FA49 : BD FD 1B   jsr  LFD1B          ;jump sub ADDX
FA4C : DF 2F      stx  $2F            ;store A in addr 2F
;NW7:
FA4E : 39         rts                 ;return subroutine
;
;PEND:
FA4F : 32         pula                ;SP+1 pull stack into A
FA50 : 32         pula                ;SP+1 pull stack into A
FA51 : 39         rts                 ;return subroutine
;
;NNW:
FA52 : 96 2C      ldaa  $2C           ;load A with addr 2C
FA54 : 27 06      beq  LFA5C          ;branch Z=1 NW8
FA56 : 91 1F      cmpa  $1F           ;compare A with addr 1F
FA58 : 26 04      bne  LFA5E          ;branch Z=0 NW9
FA5A : 20 03      bra  LFA5F          ;branch always WINIT
;
;NW8:
FA5C : 08         inx                 ;incr X
FA5D : 09         dex                 ;decr X
;NW9:
FA5E : 39         rts                 ;return subroutine
;
;WINIT:
FA5F : 7F 00 2C   clr  $002C          ;clear addr 002C
FA62 : 96 31      ldaa  $31           ;load A with addr 31
FA64 : 97 2D      staa  $2D           ;store A in addr 2D
FA66 : 96 38      ldaa  $38           ;load A with addr 38
FA68 : 97 37      staa  $37           ;store A in addr 37
FA6A : 39         rts                 ;return subroutine
;
;TRIDR:
FA6B : 96 33      ldaa  $33           ;load A with addr 33
FA6D : 9B 2D      adda  $2D           ;add A with addr 2D
FA6F : 97 33      staa  $33           ;store A in addr 33
FA71 : 2A 01      bpl  LFA74          ;branch N=0 GO
FA73 : 43         coma                ;complement 1s A
;GO:
FA74 : 1B         aba                 ;add B to A
FA75 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
;NSEND
FA78 : 39         rts                 ;return subroutine
;*************************************;
;Parameter Transfer
;*************************************;
;TRANS
FA79 : 36         psha                ;push A into stack then SP-1
;TRANS1
FA7A : A6 00      ldaa  $00,x         ;load A with X+00h
FA7C : DF 18      stx  $18            ;store X in addr 18
FA7E : DE 1A      ldx  $1A            ;load X wit haddr 1A
FA80 : A7 00      staa  $00,x         ;store A in X+00h
FA82 : 08         inx                 ;incr X
FA83 : DF 1A      stx  $1A            ;store X in addr 1A
FA85 : DE 18      ldx  $18            ;load X with addr 18
FA87 : 08         inx                 ;incr X
FA88 : 5A         decb                ;decr B
FA89 : 26 EF      bne  LFA7A          ;branch Z=0 TRANS1
FA8B : 32         pula                ;SP+1 pull stack into A
FA8C : 39         rts                 ;return subrotuine
;*************************************;
;Knocker Routine
;*************************************;
;KNOCK:
FA8D : CE FD D5   ldx  #$FDD5         ;load X with FDD5h(KNKTAB)
FA90 : DF 20      stx  $20            ;store X in addr 20
;SQLP
FA92 : DE 20      ldx  $20            ;load X with addr 20
FA94 : A6 00      ldaa  $00,x         ;load A with X+00h
FA96 : 27 33      beq  LFACB          ;branch Z=1 END
FA98 : E6 01      ldab  $01,x         ;load B with X+01h
FA9A : C4 F0      andb  #$F0          ;and B with F0h
FA9C : D7 1F      stab  $1F           ;store B in addr 1F
FA9E : E6 01      ldab  $01,x         ;load B with X+01h
FAA0 : 08         inx                 ;incr X
FAA1 : 08         inx                 ;incr X
FAA2 : DF 20      stx  $20            ;store X in addr 20
FAA4 : 97 1E      staa  $1E           ;store A in addr 1E
FAA6 : C4 0F      andb  #$0F          ;and B with 0Fh
;LP0
FAA8 : 96 1F      ldaa  $1F           ;load A with addr 1F
FAAA : B7 04 00   staa  $0400         ;store A in DAC output SOUND
FAAD : 96 1E      ldaa  $1E           ;load A with addr 1E
;LP1
FAAF : CE 00 05   ldx  #$0005         ;load X with 0005h
;LP11
FAB2 : 09         dex                 ;decr X
FAB3 : 26 FD      bne  LFAB2          ;branch Z=0 LP11
FAB5 : 4A         deca                ;decr A
FAB6 : 26 F7      bne  LFAAF          ;branch Z=0 LP1
FAB8 : 7F 04 00   clr  $0400          ;clear DAC output SOUND
FABB : 96 1E      ldaa  $1E           ;load A with addr 1E
;LP2
FABD : CE 00 05   ldx  #$0005         ;load X with 0005h
;LP22
FAC0 : 09         dex                 ;decr X
FAC1 : 26 FD      bne  LFAC0          ;branch Z=0 LP22
FAC3 : 4A         deca                ;decr A
FAC4 : 26 F7      bne  LFABD          ;branch Z=0 LP2
FAC6 : 5A         decb                ;decr B
FAC7 : 26 DF      bne  LFAA8          ;branch Z=0 LP0
FAC9 : 20 C7      bra  LFA92          ;branch always SQLP
;END
FACB : 39         rts                 ;return subroutine
;*************************************;
;Background End Routine
;*************************************;
;BGEND
FACC : 7F 00 0D   clr  $000D          ;clear addr 000D
FACF : 7F 00 0E   clr  $000E          ;clear addr 000E
FAD2 : 39         rts                 ;return subroutine
;*************************************;
;Background Sound #2 increment
;*************************************;
;BG2INC
FAD3 : 96 0D      ldaa  $0D           ;load A with addr 0D
FAD5 : 8A 80      oraa  #$80          ;or A with 80h
FAD7 : 97 0D      staa  $0D           ;store A in addr 0D
FAD9 : 96 0E      ldaa  $0E           ;load A with addr 0E
FADB : 84 7F      anda  #$7F          ;and A with 7Fh
FADD : 81 1D      cmpa  #$1D          ;compare A with 1Dh
FADF : 26 01      bne  LFAE2          ;branch Z=0 BG2IO
FAE1 : 4F         clra                ;clear A
;BG2IO 
FAE2 : 4C         inca                ;incr A
FAE3 : 97 0E      staa  $0E           ;store A in addr 0E
FAE5 : 39         rts                 ;return subroutine
;*************************************;
;Background 2 Routine
;*************************************;
;BG2
FAE6 : 86 07      ldaa  #$07          ;load A with 07h
FAE8 : BD FB 3D   jsr  LFB3D          ;jump sub GWLD
FAEB : 96 0E      ldaa  $0E           ;load A with addr 0E
FAED : 48         asla                ;arith shift left A
FAEE : 43         coma                ;complement 1s A
FAEF : BD FB F7   jsr  LFBF7          ;jump sub GEND60
;BG2LP
FAF2 : 7C 00 22   inc  $0022          ;incr addr 0022
FAF5 : BD FB F9   jsr  LFBF9          ;jump sub GEND61
FAF8 : 20 F8      bra  LFAF2          ;branch always BG2LP
;*************************************;
;Spinner #1 Sound
;*************************************;
;SP1
FAFA : 86 02      ldaa  #$02          ;load A with 02h
FAFC : BD F8 32   jsr  LF832          ;jump sub VARILD
FAFF : D6 0F      ldab  $0F           ;load B with addr 0F
FB01 : C1 1F      cmpb  #$1F          ;compare B with 1Fh
FB03 : 26 01      bne  LFB06          ;branch Z=0 SP1A
FB05 : 5F         clrb                ;clear B 
;SP1A
FB06 : 5C         incb                ;incr B
FB07 : D7 0F      stab  $0F           ;store B in addr 0F
FB09 : 86 20      ldaa  #$20          ;load A with 20h
FB0B : 10         sba                 ;sub B from A
FB0C : 5F         clrb                ;clear B
;SP11
FB0D : 81 14      cmpa  #$14          ;compare A with 14h
FB0F : 23 05      bls  LFB16          ;branch C+Z=1 SP12
FB11 : CB 0E      addb  #$0E          ;add B with 0Eh
FB13 : 4A         deca                ;decr A
FB14 : 20 F7      bra  LFB0D          ;branch always SP11
;SP12
FB16 : CB 05      addb  #$05          ;add B with 05h
FB18 : 4A         deca                ;decr A
FB19 : 26 FB      bne  LFB16          ;branch Z=0 SP12
FB1B : D7 1E      stab  $1E           ;store B in addr 1E
;SP1LP
FB1D : BD F8 47   jsr  LF847          ;jump sub VARI
FB20 : 20 FB      bra  LFB1D          ;branch always SP1LP
;*************************************;
;Laser Ball Bonus #1 (assumed name)
;*************************************;
;BON1
FB22 : 96 10      ldaa  $10           ;load A with addr 10
FB24 : 26 0E      bne  LFB34          ;branch Z=0 BON12
FB26 : 7C 00 10   inc  $0010          ;incr addr 0010
;BON11
FB29 : 86 08      ldaa  #$08          ;load A with 08h
FB2B : BD FB 3D   jsr  LFB3D          ;jump sub GWLD
FB2E : 7E FB A3   jmp  LFBA3          ;jump GWAVE
FB31 : 7E FB EC   jmp  LFBEC          ;jump GEND50
;BON12
FB34 : 96 22      ldaa  $22           ;load A with addr 22
FB36 : 81 41      cmpa  #$41          ;compare A with 41h
FB38 : 27 EF      beq  LFB29          ;branch Z=1 BON11
FB3A : 7E FB EC   jmp  LFBEC          ;jump GEND50
;*************************************;
;GWAVE Loader
;*************************************;
;GWLD:
FB3D : 16         tab                 ;transfer A to B (MULKT BY 7)
FB3E : 58         aslb                ;arith shift left B
FB3F : 1B         aba                 ;add B to A
FB40 : 1B         aba                 ;add B to A
FB41 : 1B         aba                 ;add B to A
FB42 : CE FE CE   ldx  #$FECE         ;load X with FECEh (SVTAB)(SOUND VECTOR TABLE)
FB45 : BD FD 1B   jsr  LFD1B          ;jump sub ADDX
FB48 : A6 00      ldaa  $00,x         ;load A with X+00h
FB4A : 16         tab                 ;transfer A to B
FB4B : 84 0F      anda  #$0F          ;and A with 0Fh
FB4D : 97 1F      staa  $1F           ;store A in addr 1F
FB4F : 54         lsrb                ;logic shift right B
FB50 : 54         lsrb                ;logic shift right B
FB51 : 54         lsrb                ;logic shift right B
FB52 : 54         lsrb                ;logic shift right B
FB53 : D7 1E      stab  $1E           ;store B in addr 1E
FB55 : A6 01      ldaa  $01,x         ;load A with X+01h
FB57 : 16         tab                 ;transfer A to B
FB58 : 54         lsrb                ;logic shift right B
FB59 : 54         lsrb                ;logic shift right B
FB5A : 54         lsrb                ;logic shift right B
FB5B : 54         lsrb                ;logic shift right B
FB5C : D7 20      stab  $20           ;store B in addr 20
FB5E : 84 0F      anda  #$0F          ;and A with 0Fh
FB60 : 97 1C      staa  $1C           ;store A in addr 1C
FB62 : DF 16      stx  $16            ;store X in addr 16
FB64 : CE FD F3   ldx  #$FDF3         ;load X with FDF3h (GWVTAB)(CALC WAVEFORM ADDR)
;GWLD2
FB67 : 7A 00 1C   dec  $001C          ;decr addr 001C
FB6A : 2B 08      bmi  LFB74          ;branch N=1 GWLD3
FB6C : A6 00      ldaa  $00,x         ;load A with X+00h
FB6E : 4C         inca                ;incr A
FB6F : BD FD 1B   jsr  LFD1B          ;jump sub ADDX
FB72 : 20 F3      bra  LFB67          ;branch always GWLD2
;GWLD3 
FB74 : DF 23      stx  $23            ;store X in addr 23
FB76 : BD FC 33   jsr  LFC33          ;jump sub WVTRAN
FB79 : DE 16      ldx  $16            ;load X with addr 16
FB7B : A6 02      ldaa  $02,x         ;load A with X+02h
FB7D : 97 25      staa  $25           ;store A in addr 25
FB7F : BD FC 45   jsr  LFC45          ;jump sub WVDECA
FB82 : DE 16      ldx  $16            ;load X with addr 16
FB84 : A6 03      ldaa  $03,x         ;load A with X+03h
FB86 : 97 21      staa  $21           ;store A in addr 21
FB88 : A6 04      ldaa  $04,x         ;load A with X+04h
FB8A : 97 22      staa  $22           ;store A in addr 22
FB8C : A6 05      ldaa  $05,x         ;load A with X+05h
FB8E : 16         tab                 ;transfer A to B
FB8F : A6 06      ldaa  $06,x         ;load A with X+06h
FB91 : CE FF 0D   ldx  #$FF0D         ;load X with FF0Dh(#GFRTAB)
FB94 : BD FD 1B   jsr  LFD1B          ;jump sub ADDX
FB97 : 17         tba                 ;transfer B to A
FB98 : DF 26      stx  $26            ;store X in addr 26
FB9A : 7F 00 2E   clr  $002E          ;clear addr 002E
FB9D : BD FD 1B   jsr  LFD1B          ;jump sub ADDX
FBA0 : DF 28      stx  $28            ;store X in addr 28
FBA2 : 39         rts                 ;return subroutine
;*************************************;
;GWAVE routine
;*************************************;
;ACCA=Freq Pattern Length, X=Freq Pattern Addr
;GWAVE
FBA3 : 96 1E      ldaa  $1E           ;load A with addr 1E
FBA5 : 97 2D      staa  $2D           ;store A in addr 2D
;GWT4
FBA7 : DE 26      ldx  $26            ;load X with addr 26
FBA9 : DF 18      stx  $18            ;store X in addr 18
;GPLAY
FBAB : DE 18      ldx  $18            ;load X with addr 18
FBAD : A6 00      ldaa  $00,x         ;load A with X+00h
FBAF : 9B 2E      adda  $2E           ;add A with addr 2E
FBB1 : 97 2C      staa  $2C           ;store A in addr 2C
FBB3 : 9C 28      cpx  $28            ;compare X with addr 28
FBB5 : 27 26      beq  LFBDD          ;branch Z=1 GEND
FBB7 : D6 1F      ldab  $1F           ;load B with addr 1F
FBB9 : 08         inx                 ;incr X
FBBA : DF 18      stx  $18            ;store X in addr 18
;GOUT
FBBC : CE 00 2F   ldx  #$002F         ;load X with 002Fh
;GOUTLP
FBBF : 96 2C      ldaa  $2C           ;load A with addr 2C
;GPRLP
FBC1 : 4A         deca                ;decr A
FBC2 : 26 FD      bne  LFBC1          ;branch Z=0 GPRLP
FBC4 : A6 00      ldaa  $00,x         ;load A with X+00h
FBC6 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
FBC9 : 08         inx                 ;incr X
FBCA : 9C 2A      cpx  $2A            ;compare X with 2A
FBCC : 26 F1      bne  LFBBF          ;branch Z=0 GOUTLP
FBCE : 5A         decb                ;decr B
FBCF : 27 DA      beq  LFBAB          ;branch Z=1 GPLAY
FBD1 : 08         inx                 ;incr X
FBD2 : 09         dex                 ;decr X
FBD3 : 08         inx                 ;incr X
FBD4 : 09         dex                 ;decr X
FBD5 : 08         inx                 ;incr X
FBD6 : 09         dex                 ;decr X
FBD7 : 08         inx                 ;incr X
FBD8 : 09         dex                 ;decr X
FBD9 : 01         nop                 ;
FBDA : 01         nop                 ;
FBDB : 20 DF      bra  LFBBC          ;branch always GOUT
;GEND
FBDD : 96 20      ldaa  $20           ;load A with addr 20
FBDF : 8D 64      bsr  LFC45          ;branch sub WVDECA
;GEND40
FBE1 : 7A 00 2D   dec  $002D          ;decr addr 002D
FBE4 : 26 C1      bne  LFBA7          ;branch Z=0 GWT4
FBE6 : 96 10      ldaa  $10           ;load A with addr 10
FBE8 : 9A 11      oraa  $11           ;or A with addr 11
FBEA : 26 46      bne  LFC32          ;branch Z=0 GEND1
;GEND50
FBEC : 96 21      ldaa  $21           ;load A with addr 21
FBEE : 27 42      beq  LFC32          ;branch Z=1 GEND1
FBF0 : 7A 00 22   dec  $0022          ;decr addr 0022
FBF3 : 27 3D      beq  LFC32          ;branch Z=1 GEND1
FBF5 : 9B 2E      adda  $2E           ;add A with addr 2E
;GEND60
FBF7 : 97 2E      staa  $2E           ;store A in addr 2E
;GEND61 
FBF9 : DE 26      ldx  $26            ;load X with addr 26
FBFB : 5F         clrb                ;clear B
;GW0
FBFC : 96 2E      ldaa  $2E           ;load A with addr 2E
FBFE : 7D 00 21   tst  $0021          ;test addr 0021
FC01 : 2B 06      bmi  LFC09          ;branch N=1 GW1
FC03 : AB 00      adda  $00,x         ;add A with X+00h
FC05 : 25 08      bcs  LFC0F          ;branch C=1 GW2
FC07 : 20 0B      bra  LFC14          ;branch always GW2A
;GW1
FC09 : AB 00      adda  $00,x         ;add A with X+00h
FC0B : 27 02      beq  LFC0F          ;branch Z=1 GW2
FC0D : 25 05      bcs  LFC14          ;branch C=1 GW2A
;GW2
FC0F : 5D         tstb                ;test B
FC10 : 27 08      beq  LFC1A          ;branch Z=1 GW2B
FC12 : 20 0F      bra  LFC23          ;branch always GW3
;GW2A 
FC14 : 5D         tstb                ;test B
FC15 : 26 03      bne  LFC1A          ;branch Z=0 GW2B
FC17 : DF 26      stx  $26            ;store X in addr 26
FC19 : 5C         incb                ;incr B
;GW2B
FC1A : 08         inx                 ;incr X
FC1B : 9C 28      cpx  $28            ;compare X with addr 28
FC1D : 26 DD      bne  LFBFC          ;branch Z=0 GW0
FC1F : 5D         tstb                ;test B
FC20 : 26 01      bne  LFC23          ;branch Z=0 GW3
FC22 : 39         rts                 ;return subroutine
;GW3
FC23 : DF 28      stx  $28            ;store X in addr 28
FC25 : 96 20      ldaa  $20           ;load A with addr 20
FC27 : 27 06      beq  LFC2F          ;branch Z=1 GEND0
FC29 : 8D 08      bsr  LFC33          ;branch sub WVTRAN
FC2B : 96 25      ldaa  $25           ;load A with addr 25
FC2D : 8D 16      bsr  LFC45          ;branch sub WVDECA
;GEND0
FC2F : 7E FB A3   jmp  LFBA3          ;jump GWAVE
;GEND1
FC32 : 39         rts                 ;return subroutine
;*************************************;
;Wave Transfer Routine
;*************************************;
;WVTRAN
FC33 : CE 00 2F   ldx  #$002F         ;load X with addr 002F
FC36 : DF 1A      stx  $1A            ;store X in addr 1A
FC38 : DE 23      ldx  $23            ;load X with addr 23
FC3A : E6 00      ldab  $00,x         ;load B with X+00h
FC3C : 08         inx                 ;incr X
FC3D : BD FA 79   jsr  LFA79          ;jump sub TRANS
FC40 : DE 1A      ldx  $1A            ;load X with addr 1A
FC42 : DF 2A      stx  $2A            ;store X in 2A
FC44 : 39         rts                 ;return subroutine
;*************************************;
;Wave Decay Routinue
;*************************************;
;decay amount in ACCA 1/16 per decay
;WVDECA
FC45 : 4D         tsta                ;test A
FC46 : 27 2B      beq  LFC73          ;branch Z=1 WVDCX
FC48 : DE 23      ldx  $23            ;load X with addr 23
FC4A : DF 18      stx  $18            ;store X in addr 18
FC4C : CE 00 2F   ldx  #$002F         ;load X with 002Fh
FC4F : 97 1D      staa  $1D           ;store A in addr 1D
;WVDLP
FC51 : DF 1A      stx  $1A            ;store X in addr 1A
FC53 : DE 18      ldx  $18            ;load X with addr 18
FC55 : D6 1D      ldab  $1D           ;load B with addr 1D
FC57 : D7 1C      stab  $1C           ;store B in addr 1Ch
FC59 : E6 01      ldab  $01,x         ;load B with X+00h
FC5B : 54         lsrb                ;logic shift right B
FC5C : 54         lsrb                ;logic shift right B
FC5D : 54         lsrb                ;logic shift right B
FC5E : 54         lsrb                ;logic shift right B
FC5F : 08         inx                 ;incr X
FC60 : DF 18      stx  $18            ;store X in addr 18
FC62 : DE 1A      ldx  $1A            ;load X with addr 1A
FC64 : A6 00      ldaa  $00,x         ;load A with X+00h
;WVDLP1
FC66 : 10         sba                 ;A=A-B
FC67 : 7A 00 1C   dec  $001C          ;decr addr 001C
FC6A : 26 FA      bne  LFC66          ;branch Z=0 WVDLP1
FC6C : A7 00      staa  $00,x         ;store A in X+00h
FC6E : 08         inx                 ;incr X
FC6F : 9C 2A      cpx  $2A            ;compare X with addr 2A
FC71 : 26 DE      bne  LFC51          ;branch Z=0 WVDLP
;WVDCX
FC73 : 39         rts                 ;return subroutine
;*************************************;
;Interrupt Processing
;*************************************;
;IRQ
FC74 : 8E 00 7F   lds  #$007F         ;load SP with value 007Fh (#ENDRAM)
FC77 : B6 04 02   ldaa  $0402         ;load A with PIA sound select
FC7A : C6 80      ldab  #$80          ;load B with 80h
FC7C : F7 04 02   stab  $0402         ;store B in PIA sound select
FC7F : 7C 00 12   inc  $0012          ;incr addr 0012
FC82 : 43         coma                ;complement 1s A
FC83 : 84 7F      anda  #$7F          ;and A with 7Fh
FC85 : 36         psha                ;push A into stack then SP-1
FC86 : 84 1F      anda  #$1F          ;and A with 1Fh
FC88 : 81 0B      cmpa  #$0B          ;compare A with 0Bh
FC8A : 27 03      beq  LFC8F          ;branch Z=1 IRQ1
FC8C : 7F 00 10   clr  $0010          ;ckear addr 0010
;IRQ1 LFC8F:
FC8F : 81 18      cmpa  #$18          ;compare A with 18h
FC91 : 27 03      beq  LFC96          ;branch Z=1 IRQ2
FC93 : 7F 00 11   clr  $0011          ;clear addr 0011
;IRQ2 LFC96:
FC96 : 32         pula                ;SP+1 pull stack into A
FC97 : 85 20      bita  #$20          ;bit test A with 20h
FC99 : 27 3A      beq  LFCD5          ;branch Z=1 IRQ6
FC9B : F6 EF FD   ldab  $EFFD         ;load B with addr EFFD (TALK)
FC9E : C1 7E      cmpb  #$7E          ;compare B with 7Eh (looking for jmp opcode)
FCA0 : 26 33      bne  LFCD5          ;branch Z=0 IRQ6 (NO)
FCA2 : 84 1F      anda  #$1F          ;and A with 1Fh
FCA4 : 81 14      cmpa  #$14          ;compare A with 14h
FCA6 : 27 04      beq  LFCAC          ;branch Z=1 IRQ3
FCA8 : 22 13      bhi  LFCBD          ;branch C+Z=0 IRQ4
FCAA : 20 29      bra  LFCD5          ;branch always IRQ6
;IRQ3
FCAC : BD F9 9B   jsr  LF99B          ;jump sub NOISE2
FCAF : BD F9 8E   jsr  LF98E          ;jump sub NOISE1
FCB2 : 91 15      cmpa  $15           ;compare A with addr 15
FCB4 : 27 F6      beq  LFCAC          ;branch Z=1 IRQ3
FCB6 : 97 15      staa  $15           ;store A in addr 15
FCB8 : CE FD C2   ldx  #$FDC2         ;load X with FDC2h IRQTBL1
FCBB : 20 05      bra  LFCC2          ;branch always IRQ5
;IRQ4 LFCBD:
FCBD : CE FD CA   ldx  #$FDCA         ;load X with FDCAh IRQTBL2
FCC0 : 80 15      suba  #$15          ;sub A with 15h
;IRQ5 LFCC2:
FCC2 : BD FD 1B   jsr  LFD1B          ;jump sub ADDX
FCC5 : A6 00      ldaa  $00,x         ;load A with X+00h
FCC7 : CE 00 00   ldx  #$0000         ;load X with 0000h
FCCA : DF 00      stx  $00            ;store X in addr 00
FCCC : C6 FF      ldab  #$FF          ;load B with FFh
FCCE : D7 03      stab  $03           ;store B in addr 03
FCD0 : BD EF FD   jsr  LEFFD          ;jump sub addr EFFD (TALK)
FCD3 : 20 33      bra  LFD08          ;branch always IRQ9
;IRQ6 LFCD5:
FCD5 : 0E         cli                 ;clear interrupts I=0
FCD6 : 84 1F      anda  #$1F          ;and A with 1Fh
FCD8 : 27 2E      beq  LFD08          ;branch Z=1 IRQ9
FCDA : 4A         deca                ;decr A
FCDB : 27 4D      beq  LFD2A          ;branch Z=1 TILT
FCDD : 81 07      cmpa  #$07          ;compare A with 07h
FCDF : 22 09      bhi  LFCEA          ;branch C+Z=0 IRQ7
FCE1 : 4A         deca                ;decr A
FCE2 : BD FB 3D   jsr  LFB3D          ;jump sub GWLD
FCE5 : BD FB A3   jsr  LFBA3          ;jump sub GWAVE
FCE8 : 20 1E      bra  LFD08          ;branch always IRQ9
;IRQ7 LFCEA:
FCEA : 81 09      cmpa  #$09          ;compare A with 09h
FCEC : 22 0A      bhi  LFCF8          ;branch C+Z=0 IRQ8
FCEE : 80 08      suba  #$08          ;sub A with 08h
FCF0 : BD F8 32   jsr  LF832          ;jump sub VARILD
FCF3 : BD F8 47   jsr  LF847          ;jump sub VARI
FCF6 : 20 10      bra  LFD08          ;branch always IRQ9
;IRQ8 LFCF8:
FCF8 : 81 12      cmpa  #$12          ;compare A with 12h
FCFA : 22 0C      bhi  LFD08          ;branch C+Z=0 IRQ9
FCFC : 80 0A      suba  #$0A          ;sub A with 0Ah
FCFE : 48         asla                ;arith shift left A
FCFF : CE FD 95   ldx  #$FD95         ;load X with FD95h JMPTBL
FD02 : 8D 17      bsr  LFD1B          ;branch sub ADDX
FD04 : EE 00      ldx  $00,x          ;load X with X+00h
FD06 : AD 00      jsr  $00,x          ;jump sub X+00h
;IRQ9 LFD08:
FD08 : 96 0D      ldaa  $0D           ;load A with addr 0D
FD0A : 9A 0E      oraa  $0E           ;or A with addr 0Eh
;IRQW1 LFD0C:
FD0C : 27 FE      beq  LFD0C          ;branch Z=1 IRQW1
FD0E : 96 10      ldaa  $10           ;load A with addr 10
;IRQW2 LFD10:
FD10 : 26 FE      bne  LFD10          ;branch Z=0 IRQW2
FD12 : 96 0D      ldaa  $0D           ;load A with addr 0Dh
FD14 : 27 02      beq  LFD18          ;branch Z=1 IRQX
FD16 : 2B 00      bmi  LFD18          ;branch N=1 IRQX
;IRQX LFD18:
FD18 : 7E FA E6   jmp  LFAE6          ;jump BG2
;*************************************;
;Add A to Index Register
;*************************************;
;ADDX
FD1B : DF 18      stx  $18            ;store X in addr 18
FD1D : 9B 19      adda  $19           ;add A with addr 19
FD1F : 97 19      staa  $19           ;store A in addr 19
FD21 : 96 18      ldaa  $18           ;load A with addr 18
FD23 : 89 00      adca  #$00          ;add C + A + 00h
FD25 : 97 18      staa  $18           ;store A in addr 18
FD27 : DE 18      ldx  $18            ;load X with addr 18
FD29 : 39         rts                 ;return subroutine
;*************************************;
;Tilt sound, buzz saw down
;*************************************;
;TILT
FD2A : CE 00 E0   ldx  #$00E0         ;load X with 00E0h
;TILT1
FD2D : 86 20      ldaa  #$20          ;load A with 20h
FD2F : 8D EA      bsr  LFD1B          ;branch sub ADDX
;TILT2
FD31 : 09         dex                 ;decr X
FD32 : 26 FD      bne  LFD31          ;branch Z=0 TILT2
FD34 : 7F 04 00   clr  $0400          ;clear DAC output SOUND
;TILT3
FD37 : 5A         decb                ;decr B
FD38 : 26 FD      bne  LFD37          ;branch Z=0 TILT3
FD3A : 73 04 00   com  $0400          ;complement 1s DAC output SOUND
FD3D : DE 18      ldx  $18            ;load X with addr 18
FD3F : 8C 10 00   cpx  #$1000         ;compare X with 1000h
FD42 : 26 E9      bne  LFD2D          ;branch Z=0 TILT1
FD44 : 20 C2      bra  LFD08          ;branch always IRQ9
;*************************************;
;Diagnostic Processing Here
;*************************************;
;NMI
FD46 : 0F         sei                 ;set interrupt mask
FD47 : 8E 00 7F   lds  #$007F         ;load SP with 007Fh (#ENDRAM)
FD4A : CE FF FF   ldx  #$FFFF         ;load X with FFFFh
FD4D : 5F         clrb                ;clear B
;NMI1 LFD4E:
FD4E : E9 00      adcb  $00,x         ;add C + B + X+00h
FD50 : 09         dex                 ;decr X
FD51 : 8C F8 00   cpx  #$F800         ;compare X with F800h (ROM org)
FD54 : 26 F8      bne  LFD4E          ;branch Z=0 NMI1
FD56 : E1 00      cmpb  $00,x         ;compare B with X+00h
FD58 : 27 01      beq  LFD5B          ;branch Z=1 NMI2
FD5A : 3E         wai                 ;wait interrupts, PC+1 and halt
;NMI2 LFD5B:
FD5B : 7F 04 02   clr  $0402          ;clear addr 0402 PIA sound select
FD5E : CE 2E E0   ldx  #$2EE0         ;load X with 2EE0h (12,000d)
;NMILP timer loop
FD61 : 09         dex                 ;decr X
FD62 : 26 FD      bne  LFD61          ;branch NMILP
;
FD64 : BD FA 8D   jsr  LFA8D          ;jump sub KNOCK
FD67 : BD FA 8D   jsr  LFA8D          ;jump sub KNOCK
FD6A : BD FA 8D   jsr  LFA8D          ;jump sub KNOCK
FD6D : 86 80      ldaa  #$80          ;load A with 80h
FD6F : B7 04 02   staa  $0402         ;store A in PIA sound select
FD72 : 86 01      ldaa  #$01          ;load A with 01h
FD74 : BD FB 3D   jsr  LFB3D          ;jump sub GWLD
FD77 : BD FB A3   jsr  LFBA3          ;jump sub GWAVE
FD7A : 86 03      ldaa  #$03          ;load A with 03h
FD7C : BD FB 3D   jsr  LFB3D          ;jump sub GWLD
FD7F : BD FB A3   jsr  LFBA3          ;jump sub GWAVE
FD82 : 4F         clra                ;clear A
FD83 : BD F8 32   jsr  LF832          ;jump sub VARILD
FD86 : BD F8 47   jsr  LF847          ;jump VARI
FD89 : F6 EF FA   ldab  $EFFA         ;load B with EFFAh (Speech ROM)
FD8C : C1 7E      cmpb  #$7E          ;compare B with 7Eh (looking for jmp opcode)
FD8E : 26 B6      bne  LFD46          ;branch Z=0 NMI (NO)
FD90 : BD EF FA   jsr  LEFFA          ;jump sub addr EFFA (TALKD)
FD93 : 20 B1      bra  LFD46          ;branch always NMI
;*************************************;
;Special Routine Jump Table
;*************************************;
;JMPTBL
FD95 : FB 22                          ;BON1
FD97 : F9 01                          ;WNCLL
FD99 : F8 AA                          ;WSCLL
FD9B : F8 9F                          ;NSCLL2
FD9D : F8 94                          ;NSCLL1
FD9F : FA 8D                          ;KNOCK
FDA1 : FA D3                          ;BG2INC
FDA3 : FA FA                          ;SP1
FDA5 : FA CC                          ;BGEND
;*************************************;
;VARI VECTORS
;*************************************;
;VVECT EQU *
FDA7 : 40 01 00 10 E1 00 80 FF FF     ;SAW
EDB0 : 28 01 00 08 81 02 00 FF FF     ;FOSHIT
FDB9 : FF 01 00 18 41 04 80 00 FF     ;CABSHK
;*************************************;
;IRQ Table for Talk
;*************************************;
;IRQTBL1
FDC2 : 02 03 0F 11 12 14 17 1B        ;
;IRQTBL2
FDCA : 14 1E 19 13 11 0E 0C 0A        ;
;
FDD2 : 09 06 05                       ;
;*************************************;
;* KNOCKER PATTERN
;*************************************;
;KNKTAB
FDD5 : 01FC 02FC 03F8 04F8 06F8 08F4  ;
FDE1 : 0CF4 10F4 20F2 40F1 60F1 80F1  ;
FDED : A0F1 C0F1 0000                 ;
;*************************************;
;Wave table, 1st byte wave length
;*************************************;
;GWVTAB
FDF3 : 08                             ;GS2
FDF4 : 7F D9 FF D9 7F 24 00 24        ;
;
FDFC : 08                             ;GSQ2
FDFD : FF FF FF FF 00 00 00 00        ;
;
FE05 : 08                             ;GSSQ2
FE06 : 00 40 80 00 FF 00 80 40        ;
;
FE0E : 10                             ;GS1
FE0F : 7F B0 D9 F5 FF F5 D9 B0        ;
FE17 : 7F 4E 24 09 00 09 24 4E        ;
;
FE1F : 10                             ;GS12
FE20 : 7F C5 EC E7 BF 8D 6D 6A        ;
FE28 : 7F 94 92 71 40 17 12 39        ;
;
FE30 : 10                             ;GS1234
FE31 : 76 FF B8 D0 9D E6 6A 82        ;
FE39 : 76 EA 81 86 4E 9C 32 63        ;
;
FE41 : 10                             ;GSQ12
FE42 : FF FF FF FF FF FF FF FF        ;
FE4A : 00 00 00 00 00 00 00 00        ;
;
FE52 : 10                             ;GSQ22
FE53 : FF FF FF FF 00 00 00 00        ;
FE5B : FF FF FF FF 00 00 00 00        ;
;
FE63 : 10                             ;MW1
FE64 : 00 F4 00 E8 00 DC 00 E2        ;
FE6C : 00 DC 00 E8 00 F4 00 00        ;
;
FE74 : 48                             ;GS72
FE75 : 8A 95 A0 AB B5 BF C8 D1        ;
FE7D : DA E1 E8 EE F3 F7 FB FD        ;
FE85 : FE FF FE FD FB F7 F3 EE        ;
FE8D : E8 E1 DA D1 C8 BF B5 AB        ;
FE95 : A0 95 8A 7F 75 6A 5F 54        ;
FE9D : 4A 40 37 2E 25 1E 17 11        ;
FEA5 : 0C 08 04 02 01 00 01 02        ;
FEAD : 04 08 0C 11 17 1E 25 2E        ;
FEB5 : 37 40 4A 54 5F 6A 75 7F        ;
;
FEBD : 10                             ;GS1.7
FEBE : 59 7B 98 AC B3 AC 98 7B        ;
FEC6 : 59 37 19 06 00 06 19 37        ;
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
FECE : 14 10 00 01 00 01 6A           ;
FED5 : 81 27 00 00 00 16 54           ;
FEDC : 11 09 11 01 0F 01 6A           ;
FEE3 : 61 38 00 00 00 20 00           ;
FEEA : 15 00 11 00 00 13 54           ;
FEF1 : F2 17 03 00 00 0E 51           ;
FEF8 : 31 18 00 01 00 03 8D           ;
FEFF : 99 73 11 FF 01 04 5F           ;
FF06 : 18 03 00 FF 00 16 54           ;
;*************************************;
;GWAVE FREQ PATTERN TABLE
;*************************************;
;GFRTAB 
;Bonus Sound
FF0D : A0 98 90 88 80 78 70 68        ;BONSND
FF15 : 60 58 50 44 40                 ;
;Hundred Point Sound
FF1A : 01 01 02 02 04 04 08 08        ;HBTSND
FF22 : 10 10 30 60 C0 E0              ;
;Spinner Sound
FF28 : 01 01 02 02 03 04 05 06        ;SPNSND
FF30 : 07 08 09 0A 0C                 ;
;YUKSND
FF35 : 08 80 10 78 18 70 20 60        ;YUKSND
FF3D : 28 58 30 50 40 48              ;
;Unknown
FF43 : 04 05 06 07 08 0A 0C 0E        ;UNKNWN
FF4B : 10 11 12 13 14 15 16 17        ;
FF53 : 18 19 1A 1B 1C                 ;
;Turbine Start Up
FF58 : 80 7C 78 74 70 74 78 7C 80     ;TRBPAT
;Heartbeat Distorto 
FF61 : 01 01 02 02 04 04 08 08        ;HBDSND
FF69 : 10 20 28 30 38 40 48 50        ;
FF71 : 60 70 80 A0 B0 C0              ;
;BigBen Sounds
FF77 : 08 40 08 40 08 40 08 40 08 40  ;BBSND
FF81 : 08 40 08 40 08 40 08 40 08 40  ;
;Heartbeat Echo
FF8B : 01 02 04 08 09 0A 0B 0C        ;HBESND
FF93 : 0E 0F 10 12 14 16              ;
;Spinner Sound "Drip"
FF99 : 40                             ;SPNR
;Cool Downer;
FF9A : 10 08 01                       ;COOLDN 
;Unknown
FF9D : 92                             ;UNKNWN2
;Start Distorto Sound
FF9E : 01 01 01 01 02 02 03 03        ;STDSND 
FFA6 : 04 04 05 06 08 0A 0C 10        ;
FFAE : 14 18 20 30 40 50 40 30        ;
FFB6 : 20 10 0C 0A 08 07 06 05        ;
FFBE : 04 03 02 02 01 01 01           ;
;*************************************;
;zero padding
FFC5 : 00 00 00 00 00 00 00 00 
FFCD : 00 00 00 00 00 00 00 00 
FFD5 : 00 00 00 00 00 00 00 00 
FFDD : 00 00 00 00 00 00 00 00 
FFE5 : 00 00 00 00 00 00 00 00 
FFED : 00 00 00 00 00 00 
;*************************************;
;jump and FDB for Speech ROM
;*************************************;
FFF3 : 7E FD 1B    jmp  LFD1B         ;jump ADDX
;
FFF6 : DFDA                           ;JMPTBL addr in ROM6
;*************************************;
;Motorola vector table
;*************************************;
FFF8 : FC 74                          ;IRQ 
FFFA : F8 01                          ;RESET SWI (software) 
FFFC : FD 46                          ;NMI 
FFFE : F8 01                          ;RESET (hardware) 

;--------------------------------------------------------------







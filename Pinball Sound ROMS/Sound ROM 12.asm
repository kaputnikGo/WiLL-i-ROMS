        ;
        ;  Disassembled by:
        ;    DASMx object code disassembler
        ;    (c) Copyright 1996-2003   Conquest Consultants
        ;    Version 1.40 (Oct 18 2003)
        ;
        ;  File:    CosmicGunfight.716
        ;
        ;  Size:    2048 bytes
        ;  Checksum:  ABDE
        ;  CRC-32:    AF41737B
        ;
        ;  Date:    Sat May 15 23:08:52 2021
        ;
        ;  CPU:    Motorola 6800 (6800/6802/6808 family)
        ;
        ;Pinball Sound ROM 12, Cosmic Gunfight, June 1982
        ;
        ;complex IRQ and multiple GWave param loader routines
        ;
        ;updated 18 May 2021
        ;
org  $F800
        ;
F800 : 6F                             ;checksum byte
;*************************************;
;RESET power on
;*************************************;
;RESET
F801 : 0F         clr  $0F,x          ;clear X+0Fh
F802 : 8E 00 7F   lds  #$007F         ;load stack pointer with 007Fh(#ENDRAM)
F805 : 7E F8 50   jmp  LF850          ;jump SETUP
;*************************************;
;Diagnostic Processing Here
;*************************************;
;NMI
F808 : 0F         sei                 ;set interrupt mask
F809 : 8E 00 7F   lds  #$007F         ;load stack pointer with 007Fh(#ENDRAM)
F80C : CE FF FF   ldx  #$FFFF         ;load X with FFFFh
F80F : 4F         clra                ;clear A
;NMI1 
F810 : E6 00      ldab  $00,x         ;load B with X+00h
F812 : E1 00      cmpb  $00,x         ;compare B with X+00h
F814 : 26 0B      bne  LF821          ;branch Z=0 NMI2
F816 : 1B         aba                 ;add A to B
F817 : 09         dex                 ;decr X
F818 : 8C F8 00   cpx  #$F800         ;compare X with F800h
F81B : 26 F3      bne  LF810          ;branch Z=0 NMI1
F81D : E1 00      cmpb  $00,x         ;compare B with X+00h
F81F : 27 01      beq  LF822          ;branch Z=1 NMI3
;NMI2 
F821 : 3E         wai                 ;wait interrupts, PC+1 and halt
;NMI3 
F822 : 7F 04 02   clr  $0402          ;clear PIA sound select
F825 : CE 2E E0   ldx  #$2EE0         ;load X with 2EE0h(12,000d)
;NMI4 
F828 : 09         dex                 ;decr X
F829 : 26 FD      bne  LF828          ;branch Z=0 NMI4
F82B : BD F9 59   jsr  LF959          ;jump sub KNOCK
F82E : BD F9 59   jsr  LF959          ;jump sub KNOCK
F831 : BD F9 59   jsr  LF959          ;jump sub KNOCK
F834 : 86 80      ldaa  #$80          ;load A with 80h
F836 : B7 04 02   staa  $0402         ;store A in PIA sound select
F839 : 86 01      ldaa  #$01          ;load A with 01h
F83B : BD FC 0B   jsr  LFC0B          ;jump sub GWJMPR
F83E : 86 15      ldaa  #$15          ;load A with 15h
F840 : BD FC 0B   jsr  LFC0B          ;jump sub GWJMPR
F843 : BD F8 D7   jsr  LF8D7          ;jump sub LITE
F846 : 86 00      ldaa  #$00          ;load A with 00h
F848 : BD F8 75   jsr  LF875          ;jump sub VARILD
F84B : BD F8 8A   jsr  LF88A          ;jump sub VARI
F84E : 20 B8      bra  LF808          ;branch always NMI
;*************************************;
;setup 
;*************************************;
;SETUP
F850 : CE 04 00   ldx  #$0400         ;load X with addr 0400 PIA
F853 : 6F 01      clr  $01,x          ;clear addr X+01h (0401 PIA1 CR port A)
F855 : 6F 03      clr  $03,x          ;clear addr X+03h (0403 PIA1 CR port B)
F857 : 86 FF      ldaa  #$FF          ;load A with FFh
F859 : A7 00      staa  $00,x         ;store A in addr X + 00h (0400 PIA1 PR/DDR port A out)
F85B : C6 80      ldab  #$80          ;load B with 80h
F85D : E7 02      stab  $02,x         ;store B in addr X+02h (0402 PIA port B in)(sound select)
F85F : 86 37      ldaa  #$37          ;load A with value 37h (CB2 low, IRQ allowed)
F861 : A7 03      staa  $03,x         ;store A in addr X+03h (0403 PIA1 CR port B)
F863 : 86 3C      ldaa  #$3C          ;load A with value 3Ch (CA2 set init high, no IRQs)
F865 : A7 01      staa  $01,x         ;store A in addr X+01h (0401 PIA1 CR port A)
F867 : 97 0A      staa  $0A           ;store A in addr 0A
F869 : E7 02      stab  $02,x         ;;store B in addr X+02h (0402 PIA port B in)
F86B : 4F         clra                ;clear A
F86C : 97 07      staa  $07           ;store A in addr 07
F86E : 97 05      staa  $05           ;store A in addr 05
F870 : 97 08      staa  $08           ;store A in addr 08
F872 : 0E         cli                 ;clear interrupts I=0
;STDBY
F873 : 20 FE      bra  LF873          ;branch always STDBY
;*************************************;
;Vari Loader
;*************************************;
;VARILD
F875 : 16         tab                 ;transfer A to B
F876 : 48         asla                ;arith shift left A
F877 : 48         asla                ;arith shift left A
F878 : 48         asla                ;arith shift left A
F879 : 1B         aba                 ;add B to A
F87A : CE 00 14   ldx  #$0014         ;load X with addr 0014(#LOCRAM)
F87D : DF 10      stx  $10            ;store X in addr 10
F87F : CE FC 57   ldx  #$FC57         ;load X with FC57h (VVECT)
F882 : BD FB 9A   jsr  LFB9A          ;jump sub ADDX
F885 : C6 09      ldab  #$09          ;load B with 09h
F887 : 7E F9 45   jmp  LF945          ;jump TRANS
;*************************************;
;Variable Duty Cycle Square Wave Routine
;*************************************;
;VARI
F88A : 96 1C      ldaa  $1C           ;load A with addr 1C
F88C : B7 04 00   staa  $0400         ;store A in DAC output SOUND
;VAR0
F88F : 96 14      ldaa  $14           ;load A with addr 14
F891 : 97 1D      staa  $1D           ;store A in addr 1D
F893 : 96 15      ldaa  $15           ;load A with addr 15
F895 : 97 1E      staa  $1E           ;store A in addr 1E
;VAR0
F897 : DE 19      ldx  $19            ;load X with addr 19
;V0LP
F899 : 96 1D      ldaa  $1D           ;load A with addr 1D
F89B : 73 04 00   com  $0400          ;complement 1s DAC output SOUND
;V1
F89E : 09         dex                 ;decr X
F89F : 27 10      beq  LF8B1          ;branch Z=1 VSWEEP
F8A1 : 4A         deca                ;decr A
F8A2 : 26 FA      bne  LF89E          ;branch Z=0 V1
F8A4 : 73 04 00   com  $0400          ;complement 1s DAC output SOUND
F8A7 : 96 1E      ldaa  $1E           ;load A with addr 1E
;V2
F8A9 : 09         dex                 ;decr X
F8AA : 27 05      beq  LF8B1          ;branch Z=1 VSWEEP
F8AC : 4A         deca                ;decr A
F8AD : 26 FA      bne  LF8A9          ;branch Z=0 V2
F8AF : 20 E8      bra  LF899          ;branch always V0LP
;VSWEEP
F8B1 : B6 04 0    ldaa  $0400         ;load A with DAC
F8B4 : 2B 01      bmi  LF8B7          ;brnach N=1 VS1
F8B6 : 43         coma                ;complement 1s A
;VS1
F8B7 : 8B 00      adda  #$00          ;add A with 00h
F8B9 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F8BC : 96 1D      ldaa  $1D           ;load A with addr 1D
F8BE : 9B 16      adda  $16           ;add A with addr 16
F8C0 : 97 1D      staa  $1D           ;store A with addr 1D
F8C2 : 96 1E      ldaa  $1E           ;load A with addr 1E
F8C4 : 9B 17      adda  $17           ;add A with addr 17
F8C6 : 97 1E      staa  $1E           ;store A in addr 1E
F8C8 : 91 18      cmpa  $18           ;compare A with addr 18
F8CA : 26 CB      bne  LF897          ;branch Z=0 VAR0
F8CC : 96 1B      ldaa  $1B           ;load A with addr 1B
F8CE : 27 06      beq  LF8D6          ;branch Z=1 VARX
F8D0 : 9B 14      adda  $14           ;add A with addr 14
F8D2 : 97 14      staa  $14           ;store A in addr 14
F8D4 : 26 B9      bne  LF88F          ;branch Z=0 VAR0
;VARX
F8D6 : 39         rts                 ;return subroutine
;*************************************;
;Lightning - Liten routine params
;*************************************;
;LITE
F8D7 : 86 01      ldaa  #$01          ;load A with addr 1A
F8D9 : 97 1B      staa  $1B           ;store A in addr 1B
F8DB : C6 03      ldab  #$03          ;load B with 03h
F8DD : 20 00      bra  LF8DF          ;branch always LITEN
;*************************************;
;Lightning+Appear Noise Routine
;*************************************;
;LITEN:
F8DF : 97 1A      staa  $1A           ;store A in addr 1A
F8E1 : 86 FF      ldaa  #$FF          ;load A with FFh
F8E3 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F8E6 : D7 16      stab  $16           ;store B in addr 16
;LITE0
F8E8 : D6 16      ldab  $16           ;load B with addr 16
;LITE1
F8EA : 96 0B      ldaa  $0B           ;load A with addr 0B
F8EC : 44         lsra                ;logic shift right A
F8ED : 44         lsra                ;logic shift right A
F8EE : 44         lsra                ;logic shift right A
F8EF : 98 0B      eora  $0B           ;exclusive or A with addr 0B
F8F1 : 44         lsra                ;logic shift right A
F8F2 : 76 00 0A   ror  $000A          ;rotate right addr 000A
F8F5 : 76 00 0B   ror  $000B          ;rotate right addr 000B
F8F8 : 24 03      bcc  LF8FD          ;branch C=0 LITE2
F8FA : 73 04 00   com  $0400          ;complement 1s DAC output SOUND
;LITE2
F8FD : 96 1A      ldaa  $1A           ;load A with addr 1A
;LITE3
F8FF : 4A         deca                ;decr A
F900 : 26 FD      bne  LF8FF          ;branch Z=0 LITE3
F902 : 5A         decb                ;decr B
F903 : 26 E5      bne  LF8EA          ;branch Z=0 LITE1
F905 : 96 1A      ldaa  $1A           ;load A with addr 1A
F907 : 9B 1B      adda  $1B           ;add A with addr 1B
F909 : 97 1A      staa  $1A           ;store A in addr 1A
F90B : 26 DB      bne  LF8E8          ;branch Z=0 LITE0
F90D : 39         rts                 ;return subroutine
;*************************************;
;White Noise Routine
;*************************************;
;X=INIT PERIOD, ACCB=INIT AMP, ACCA DECAY RATE
;CYCNT=CYCLE COUNT, NFFLG= FREQ DECAY FLAG
;NOISE:
F90E : 97 14      staa  $14           ;store A in addr 14
;NOISE0
F910 : DF 17      stx  $17            ;store X in addr 17
;NOIS00
F912 : D7 15      stab  $15           ;store B in addr 15
F914 : D6 16      ldab  $16           ;load B with addr 16
;NOISE1
F916 : 96 0B      ldaa  $0B           ;load A with addr 0B
F918 : 44         lsra                ;logic shift right A
F919 : 44         lsra                ;logic shift right A
F91A : 44         lsra                ;logic shift right A
F91B : 98 0B      eora  $0B
F91D : 44         lsra                ;logic shift right A
F91E : 76 00 0A   ror  $000A          ;rotate right addr 000A
F921 : 76 00 0B   ror  $000B          ;rotate right addr 000B
F924 : 86 00      ldaa  #$00          ;load A with 00h
F926 : 24 02      bcc  LF92A          ;branch C=0 NOISE2
F928 : 96 15      ldaa  $15           ;load A with addr 15
;NOISE2
F92A : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F92D : DE 17      ldx  $17            ;load X with addr 17
;NOISE3
F92F : 09         dex                 ;decr X
F930 : 26 FD      bne  LF92F          ;branch Z=0 NOISE3
F932 : 5A         decb                ;decr B
F933 : 26 E1      bne  LF916          ;branch Z=0 NOISE1
F935 : D6 15      ldab  $15           ;load B with addr 15
F937 : D0 14      subb  $14           ;sub B with addr 14
F939 : 27 09      beq  LF944          ;branch Z=1 NSEND
F93B : DE 17      ldx  $17            ;load X with addr 17
F93D : 08         inx                 ;incr X
F93E : 96 19      ldaa  $19           ;load A with addr 19
F940 : 27 D0      beq  LF912          ;branch Z=1 NOIS00
F942 : 20 CC      bra  LF910          ;branch always NOISE0
;NSEND
F944 : 39         rts                 ;return subroutine
;*************************************;
;Parameter Transfer
;*************************************;
;TRANS
F945 : 36         psha                ;push A into stack then SP-1
;TRANS1
F946 : A6 00      ldaa  $00,x         ;load A with X+00h
F948 : DF 0E      stx  $0E            ;store X in addr 0E
F94A : DE 10      ldx  $10            ;load X with addr 10
F94C : A7 00      staa  $00,x         ;store A in addr X+00h
F94E : 08         inx                 ;incr X
F94F : DF 10      stx  $10            ;store X in addr 10
F951 : DE 0E      ldx  $0E            ;load X with addr 0E
F953 : 08         inx                 ;incr X
F954 : 5A         decb                ;decr B
F955 : 26 EF      bne  LF946          ;branch Z=0 TRANS1
F957 : 32         pula                ;SP+1 pull stack into A
F958 : 39         rts                 ;return subroutine
;*************************************;
;Knocker Routine
;*************************************;
;KNOCK:
F959 : CE FC 8D   ldx  #$FC8D         ;load X with FC8Dh (KNKTAB)
F95C : DF 16      stx  $16            ;store X in addr 16
;SQLP
F95E : DE 16      ldx  $16            ;load X with addr 16
F960 : A6 00      ldaa  $00,x         ;load A with X+00h
F962 : 27 33      beq  LF997          ;branch Z=1 END
F964 : E6 01      ldab  $01,x         ;load B with X+01h
F966 : C4 F0      andb  #$F0          ;and B with F0h
F968 : D7 15      stab  $15           ;store B in addr 15
F96A : E6 01      ldab  $01,x         ;load B with X+01h
F96C : 08         inx                 ;incr X
F96D : 08         inx                 ;incr X
F96E : DF 16      stx  $16            ;store X in addr 16
F970 : 97 14      staa  $14           ;store A in addr 14
F972 : C4 0F      andb  #$0F          ;and B with 0Fh
;LP0
F974 : 96 15      ldaa  $15           ;load A with addr 15
F976 : B7 04 00   staa  $0400         ;store A DAC output SOUND
F979 : 96 14      ldaa  $14           ;load A with addr 14
;LP1
F97B : CE 00 05   ldx  #$0005         ;load X with 0005h
;LP11
F97E : 09         dex                 ;decr X
F97F : 26 FD      bne  LF97E          ;branch Z=0 LP11
F981 : 4A         deca                ;decr A
F982 : 26 F7      bne  LF97B          ;branch Z=0 LP1
F984 : 7F 04 00   clr  $0400          ;clear DAC output SOUND
F987 : 96 14      ldaa  $14           ;load A with addr 14
;LP2
F989 : CE 00 05   ldx  #$0005         ;load X with 0005h
;LP22
F98C : 09         dex                 ;decr X
F98D : 26 FD      bne  LF98C          ;branch Z=0 LP22
F98F : 4A         deca                ;decr A
F990 : 26 F7      bne  LF989          ;branch Z=0 LP2
F992 : 5A         decb                ;decr B
F993 : 26 DF      bne  LF974          ;branch Z=0 LP0
F995 : 20 C7      bra  LF95E          ;branch always SQLP
;END
F997 : 39         rts                 ;return subroutine
;*************************************;
;Background End Routine
;*************************************;
;BGEND
F998 : 7F 00 05   clr  $0005          ;clear addr 0005
F99B : 39         rts                 ;return subroutine
;*************************************;
;set background params and wait (assumed)
;*************************************;
;BGSET
F99C : 86 01      ldaa  #$01          ;load A with 01h
F99E : 97 05      staa  $05           ;store A in addr 05
F9A0 : CE 00 00   ldx  #$0000         ;load X with 0000h
F9A3 : DF 03      stx  $03            ;store X in addr 03
;BGSETX
F9A5 : 20 FE      bra  LF9A5          ;branch always BGSETX
;*************************************;
;GWave Calling routine #1
;*************************************;
;GWCAL1
F9A7 : 96 07      ldaa  $07           ;load A with addr 07
F9A9 : 26 08      bne  LF9B3          ;branch Z=0 GWCL11
F9AB : 7C 00 07   inc  $0007          ;incr addr 0007
F9AE : 86 14      ldaa  #$14          ;load A with 14h(#(SVTAB)/7)
F9B0 : 7E FC 0B   jmp  LFC0B          ;jump GWVJMP
;GWCL11
F9B3 : 7A 00 08   dec  $0008          ;decr addr 0008
F9B6 : 2A 07      bpl  LF9BF          ;branch N=0  GWCALX
F9B8 : 86 02      ldaa  #$02          ;load A with 02h
F9BA : 97 08      staa  $08           ;store A in addr 08
F9BC : 7E FA 8E   jmp  LFA8E          ;jump GEND50
;GWCALX
F9BF : 7E FA 44   jmp  LFA44          ;jump GWAVE
;*************************************;
;GWave Alternate Routine
;*************************************;
;GWVALT
F9C2 : 7F 00 07   clr  $0007          ;clear addr 0007
F9C5 : 86 FC      ldaa  #$FC          ;load A with FCh
F9C7 : 9B 24      adda  $24           ;add A with addr 24
F9C9 : 97 24      staa  $24           ;store A in addr 24
F9CB : 86 01      ldaa  #$01          ;load A with 01h
F9CD : 97 18      staa  $18           ;store A in addr 18
F9CF : 86 10      ldaa  #$10          ;load A with 10h
F9D1 : 97 14      staa  $14           ;store A in addr 14
F9D3 : 86 02      ldaa  #$02          ;load A with 02h
F9D5 : 97 15      staa  $15           ;store A in addr 15
F9D7 : 86 01      ldaa  #$01          ;load A with 01h
F9D9 : 97 16      staa  $16           ;store A in addr 16
F9DB : 7E FA 9B   jmp  LFA9B          ;jump GEND61
;*************************************;
;GWAVE Loader
;*************************************;
;GWLD:
F9DE : 16         tab                 ;transfer A to B(MULKT BY 7)(sound select x7)
F9DF : 58         aslb                ;arith shift left B
F9E0 : 1B         aba                 ;add B to A
F9E1 : 1B         aba                 ;add B to A
F9E2 : 1B         aba                 ;add B to A
F9E3 : CE FE 19   ldx  #$FE19         ;load X with FE19h (SVTAB)(SOUND VECTOR TABLE)
F9E6 : BD FB 9A   jsr  LFB9A          ;jump sub ADDX
F9E9 : A6 00      ldaa  $00,x         ;load A with X+00h
F9EB : 16         tab                 ;transfer A to B
F9EC : 84 0F      anda  #$0F          ;and A with 0Fh
F9EE : 97 15      staa  $15           ;store A with addr 15
F9F0 : 54         lsrb                ;logic shift right B
F9F1 : 54         lsrb                ;logic shift right B
F9F2 : 54         lsrb                ;logic shift right B
F9F3 : 54         lsrb                ;logic shift right B
F9F4 : D7 14      stab  $14           ;store B in addr 14
F9F6 : A6 01      ldaa  $01,x         ;load A with X+01h
F9F8 : 16         tab                 ;transfer A to B
F9F9 : 54         lsrb                ;logic shift right B
F9FA : 54         lsrb                ;logic shift right B
F9FB : 54         lsrb                ;logic shift right B
F9FC : 54         lsrb                ;logic shift right B
F9FD : D7 16      stab  $16           ;store B in addr 16
F9FF : 84 0F      anda  #$0F          ;and A with 0Fh
FA01 : 97 12      staa  $12           ;store A in addr 12
FA03 : DF 0C      stx  $0C            ;store X in addr 0C
FA05 : CE FC AB   ldx  #$FCAB         ;load X with FCABh (GWVTAB)(CALC WAVEFORM ADDR)
;GWLD2
FA08 : 7A 00 12   dec  $0012          ;decr addr 0012
FA0B : 2B 08      bmi  LFA15          ;branch N=1 GWLD3
FA0D : A6 00      ldaa  $00,x         ;load A with X+00h
FA0F : 4C         inca                ;incr A
FA10 : BD FB 9A   jsr  LFB9A          ;jump sub ADDX
FA13 : 20 F3      bra  LFA08          ;branch always GWLD2
;GWLD3
FA15 : DF 19      stx  $19            ;store X in addr 19
FA17 : BD FA D5   jsr  LFAD5          ;jump sub WVTRAN
FA1A : DE 0C      ldx  $0C            ;load X with addr 0C
FA1C : A6 02      ldaa  $02,x         ;load A with X+02h
FA1E : 97 1B      staa  $1B           ;store A in addr 1B
FA20 : BD FA E7   jsr  LFAE7          ;jump sub WVDECA
FA23 : DE 0C      ldx  $0C            ;load X with addr 0C
FA25 : A6 03      ldaa  $03,x         ;load A with X+03h
FA27 : 97 17      staa  $17           ;store A in addr 17
FA29 : A6 04      ldaa  $04,x         ;load A with X+04h
FA2B : 97 18      staa  $18           ;store A in addr 18
FA2D : A6 05      ldaa  $05,x         ;load A with X+05h
FA2F : 16         tab                 ;transfer A to B
FA30 : A6 06      ldaa  $06,x         ;load A with X+06h
FA32 : CE FE DD   ldx  #$FEDD         ;load X with FEDDh (#GFRTAB)
FA35 : BD FB 9A   jsr  LFB9A          ;jump sub ADDX
FA38 : 17         tba                 ;transfer B to A
FA39 : DF 1C      stx  $1C            ;store X in addr 1C
FA3B : 7F 00 24   clr  $0024          ;clear addr 0024
FA3E : BD FB 9A   jsr  LFB9A          ;jump sub ADDX
FA41 : DF 1E      stx  $1E            ;store X in addr 1E
FA43 : 39         rts                 ;return subroutine
;*************************************;
;GWAVE routine
;*************************************;
;ACCA=Freq Pattern Length, X=Freq Pattern Addr
;GWAVE
FA44 : 96 14      ldaa  $14           ;load A with addr 14
FA46 : 97 23      staa  $23           ;store A in addr 23
;GWT4 
FA48 : DE 1C      ldx  $1C            ;load X with addr 1C
FA4A : DF 0E      stx  $0E            ;store X in addr 0E
;GPLAY 
FA4C : DE 0E      ldx  $0E            ;load X with addr 0E
FA4E : A6 00      ldaa  $00,x         ;load A with X+00h
FA50 : 9B 24      adda  $24           ;add A with addr 24
FA52 : 97 22      staa  $22           ;store A in addr 22
FA54 : 9C 1E      cpx  $1E            ;compare X with addr 1E
FA56 : 27 26      beq  LFA7E          ;branch Z=1 GEND
FA58 : D6 15      ldab  $15           ;load B with addr 15
FA5A : 08         inx                 ;incr X
FA5B : DF 0E      stx  $0E            ;store X in addr 0E
;GOUT 
FA5D : CE 00 25   ldx  #$0025         ;load X with 0025h
;GOUTLP
FA60 : 96 22      ldaa  $22           ;load A with addr 22
;GPRLP 
FA62 : 4A         deca                ;decr A
FA63 : 26 FD      bne  LFA62          ;branch Z=0 GPRLP
FA65 : A6 00      ldaa  $00,x         ;load A with X+00h
FA67 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
FA6A : 08         inx                 ;incr X
FA6B : 9C 20      cpx  $20            ;compare X with addr 20
FA6D : 26 F1      bne  LFA60          ;branch Z=0 GOUTLP
FA6F : 5A         decb                ;decr B
FA70 : 27 DA      beq  LFA4C          ;branch Z=1 GPLAY
FA72 : 08         inx                 ;incr X
FA73 : 09         dex                 ;decr X
FA74 : 08         inx                 ;incr X
FA75 : 09         dex                 ;decr X
FA76 : 08         inx                 ;incr X
FA77 : 09         dex                 ;decr X
FA78 : 08         inx                 ;incr X
FA79 : 09         dex                 ;decr X
FA7A : 01         nop                 ;
FA7B : 01         nop                 ;
FA7C : 20 DF      bra  LFA5D          ;branch always GOUT
;GEND 
FA7E : 96 16      ldaa  $16           ;load A with addr 16
FA80 : 8D 65      bsr  LFAE7          ;branch sub WVDECA
;GEND40
FA82 : 7A 00 23   dec  $0023          ;decr addr 0023
FA85 : 26 C1      bne  LFA48          ;branch Z=0 GWT4
FA87 : 96 07      ldaa  $07           ;load A with addr 07
FA89 : 27 03      beq  LFA8E          ;branch Z=1 GEND50
FA8B : 7E F9 C2   jmp  LF9C2          ;jump GWVALT
;GEND50 
FA8E : 96 17      ldaa  $17           ;load A with addr 17
FA90 : 27 42      beq  LFAD4          ;branch Z=1 GEND1
FA92 : 7A 00 18   dec  $0018          ;decr addr 0018
FA95 : 27 3D      beq  LFAD4          ;branch Z=1 GEND1
FA97 : 9B 24      adda  $24           ;add A with addr 24
;GEND60
FA99 : 97 24      staa  $24           ;store A in addr 24
;GEND61 
FA9B : DE 1C      ldx  $1C            ;load X with addr 1C
FA9D : 5F         clrb                ;clear B
;GW0 
FA9E : 96 24      ldaa  $24           ;load A with addr 24
FAA0 : 7D 00 17   tst  $0017          ;test addr 0017
FAA3 : 2B 06      bmi  LFAAB          ;branch N=1 GW1
FAA5 : AB 00      adda  $00,x         ;add A with X+00h
FAA7 : 25 08      bcs  LFAB1          ;branch C=1 GW2
FAA9 : 20 0B      bra  LFAB6          ;branch always GW2A
;GW1 
FAAB : AB 00      adda  $00,x         ;add A with X+00h
FAAD : 27 02      beq  LFAB1          ;branch Z=1 GW2
FAAF : 25 05      bcs  LFAB6          ;branch C=1 GW2A
;GW2 
FAB1 : 5D         tstb                ;test B
FAB2 : 27 08      beq  LFABC          ;branch Z=1 GW2B
FAB4 : 20 0F      bra  LFAC5          ;branch always GW3
;GW2A 
FAB6 : 5D         tstb                ;test B
FAB7 : 26 03      bne  LFABC          ;branch Z=0 GW2B
FAB9 : DF 1C      stx  $1C            ;store X in addr 1C
FABB : 5C         incb                ;incr B
;GW2B 
FABC : 08         inx                 ;incr X
FABD : 9C 1E      cpx  $1E            ;compare X with addr 1E
FABF : 26 DD      bne  LFA9E          ;branch Z=0 GW0
FAC1 : 5D         tstb                ;test B
FAC2 : 26 01      bne  LFAC5          ;branch Z=0 GW3
FAC4 : 39         rts                 ;return subroutine
;GW3 
FAC5 : DF 1E      stx  $1E            ;store X in addr 1E
FAC7 : 96 16      ldaa  $16           ;load A with addr 16
FAC9 : 27 06      beq  LFAD1          ;branch Z=1 GEND0
FACB : 8D 08      bsr  LFAD5          ;branch sub WVTRAN
FACD : 96 1B      ldaa  $1B           ;load A with addr 1B
FACF : 8D 16      bsr  LFAE7          ;branch sub WVDECA
;GEND0 
FAD1 : 7E FA 44   jmp  LFA44          ;jump GWAVE
;GEND1 
FAD4 : 39         rts                 ;return subroutine
;*************************************;
;Wave Transfer Routine
;*************************************;
;WVTRAN
FAD5 : CE 00 25   ldx  #$0025         ;load X with addr 0025
FAD8 : DF 10      stx  $10            ;store X in addr 10
FADA : DE 19      ldx  $19            ;load X with addr 19
FADC : E6 00      ldab  $00,x         ;load B with X+00h
FADE : 08         inx                 ;incr X
FADF : BD F9 45   jsr  LF945          ;jump sub TRANS
FAE2 : DE 10      ldx  $10            ;load X with addr 10
FAE4 : DF 20      stx  $20            ;store X in addr 20
FAE6 : 39         rts                 ;return subroutine
;*************************************;
;Wave Decay Routinue
;*************************************;
;decay amount in ACCA 1/16 per decay
;WVDECA
FAE7 : 4D         tsta                ;test A
FAE8 : 27 2B      beq  LFB15          ;branch Z=1 WVDCX
FAEA : DE 19      ldx  $19            ;load X with addr 19
FAEC : DF 0E      stx  $0E            ;store X in addr 0E
FAEE : CE 00 25   ldx  #$0025         ;load X with 0025h
FAF1 : 97 13      staa  $13           ;store A in addr 13
;WVDLP
FAF3 : DF 10      stx  $10            ;store X in addr 10
FAF5 : DE 0E      ldx  $0E            ;load X with addr 0E
FAF7 : D6 13      ldab  $13           ;load B with addr 13
FAF9 : D7 12      stab  $12           ;store B in addr 12
FAFB : E6 01      ldab  $01,x         ;load B with X+01h
FAFD : 54         lsrb                ;logic shift right B
FAFE : 54         lsrb                ;logic shift right B
FAFF : 54         lsrb                ;logic shift right B
FB00 : 54         lsrb                ;logic shift right B
FB01 : 08         inx                 ;incr X
FB02 : DF 0E      stx  $0E            ;store X in addr 0E
FB04 : DE 10      ldx  $10            ;load X with addr 10
FB06 : A6 00      ldaa  $00,x         ;load A with X+00h
;WVDLP1
FB08 : 10         sba                 ;sub B with A
FB09 : 7A 00 12   dec  $0012          ;decr addr 0012
FB0C : 26 FA      bne  LFB08          ;branch Z=0 WVDLP1
FB0E : A7 00      staa  $00,x         ;store A in addr X+00h
FB10 : 08         inx                 ;incr X
FB11 : 9C 20      cpx  $20            ;compare X with addr 20
FB13 : 26 DE      bne  LFAF3          ;branch Z=0 WVDLP
;WVDCX
FB15 : 39         rts                 ;return subroutine
;*************************************;
;Interrupt Processing
;*************************************;
;IRQ
FB16 : 8E 00 7F   lds  #$007F         ;load SP with value 007Fh (#ENDRAM)
FB19 : B6 04 02   ldaa  $0402         ;load A with addr 0402 PIA sound select
FB1C : C6 80      ldab  #$80          ;load B with 80h
FB1E : F7 04 02   stab  $0402         ;store B in PIA sound select
FB21 : 43         coma                ;complement 1s A (invert)
FB22 : 84 1F      anda  #$1F          ;and A with 1Fh (mask)
FB24 : 4A         deca                ;decr A (-1)
FB25 : 81 1A      cmpa  #$1A          ;compare A with 1Ah
FB27 : 27 06      beq  LFB2F          ;branch Z=1 IRQ1
FB29 : 7F 00 08   clr  $0008          ;clear addr 0008
FB2C : 7F 00 07   clr  $0007          ;clear addr 0007
;IRQ1 
FB2F : 81 17      cmpa  #$17          ;compare A with 17h
FB31 : 27 08      beq  LFB3B          ;branch Z=1 IRQ2
FB33 : 81 16      cmpa  #$16          ;compare A with 16h
FB35 : 27 04      beq  LFB3B          ;branch Z=1 IRQ2
FB37 : 81 1D      cmpa  #$1D          ;compare A with 1Dh
FB39 : 26 03      bne  LFB3E          ;branch Z=0 IRQ3
;IRQ2 
FB3B : 7F 00 05   clr  $0005          ;clear addr 0005
;IRQ3 
FB3E : 0E         cli                 ;clear interrupts I=0
FB3F : 4D         tsta                ;test A
FB40 : 2D 27      blt  LFB69          ;branch N(+)V=1 IRQ6
FB42 : CE FC 24   ldx  #$FC24         ;load X with FC24h (IRQDAT)
FB45 : 8D 53      bsr  LFB9A          ;branch sub ADDX
FB47 : A6 00      ldaa  $00,x         ;load A with X+00h
FB49 : 84 3F      anda  #$3F          ;and A with 3Fh
FB4B : E6 00      ldab  $00,x         ;load B with X+00h
FB4D : 58         aslb                ;arith shift left B
FB4E : 25 0F      bcs  LFB5F          ;branch C=1 IRQ5
FB50 : 2B 05      bmi  LFB57          ;branch N=1 IRQ4
FB52 : BD FC 0B   jsr  LFC0B          ;jump sub GWVJMP
FB55 : 20 12      bra  LFB69          ;branch always IRQ6
;IRQ4 
FB57 : BD F8 75   jsr  LF875          ;jump sub VARILD
FB5A : BD F8 8A   jsr  LF88A          ;jump sub VARI
FB5D : 20 0A      bra  LFB69          ;branch always IRQ6
;IRQ5 
FB5F : 48         asla                ;arith shift left A
FB60 : CE FC 43   ldx  #$FC43         ;load X with FC43h (JMPTBL)
FB63 : 8D 35      bsr  LFB9A          ;branch sub ADDX
FB65 : EE 00      ldx  $00,x          ;load X with X+00h
FB67 : AD 00      jsr  $00,x          ;jump sub X+00h
;IRQ6 
FB69 : 96 05      ldaa  $0005         ;load A with addr 0005
;IRQ7 
FB6B : 27 FE      beq  LFB6B          ;branch Z=1 IRQ7
FB6D : DE 03      ldx  $0003          ;load X with addr 0003
FB6F : 27 07      beq  LFB78          ;branch Z=1 IRQ9
;IRQ8 
FB71 : DF 03      stx  $0003          ;store X in addr 0003
FB73 : DF 03      stx  $0003          ;store X in addr 0003
FB75 : 09         dex                 ;decr X
FB76 : 26 F9      bne  LFB71          ;branch Z=0 IRQ8
;IRQ9 
FB78 : 4F         clra                ;clear A
FB79 : 97 07      staa  $07           ;store A in addr 07
FB7B : 97 08      staa  $08           ;store A in addr 08
FB7D : 86 15      ldaa  #$15          ;load A with (#(SVTAB)/7)
FB7F : BD F9 DE   jsr  LF9DE          ;jump sub GWLD
FB82 : 96 05      ldaa  $05           ;load A with addr 05
FB84 : 81 17      cmpa  #$17          ;compare A with 17h
FB86 : 26 01      bne  LFB89          ;branch Z=0 IRQ10
FB88 : 4F         clra                ;clear A
;IRQ10 
FB89 : 4C         inca                ;incr A
FB8A : 97 05      staa  $05           ;store A in addr 05
FB8C : 48         asla                ;arith shift left A
FB8D : 48         asla                ;arith shift left A
FB8E : 43         coma                ;complement 1s A
FB8F : BD FA 99   jsr  LFA99          ;jump sub GEND60
;IRQ11
FB92 : 7C 00 18   inc  $0018          ;incr addr 0018
FB95 : BD FA 9B   jsr  LFA9B          ;jump sub GEND61
FB98 : 20 F8      bra  LFB92          ;branch always IRQ11
;*************************************;
;Add A to Index Register
;*************************************;
;ADDX
FB9A : DF 0E      stx  $0E            ;store X in addr 0E
FB9C : 9B 0F      adda  $0F           ;add A with addr 0F
FB9E : 97 0F      staa  $0F           ;store A in addr 0F
FBA0 : 96 0E      ldaa  $0E           ;load A with addr 0E
FBA2 : 89 00      adca  #$00          ;add C + A with 00h
FBA4 : 97 0E      staa  $0E           ;store A in addr 0E
FBA6 : DE 0E      ldx  $0E            ;load X with addr 0E
FBA8 : 39         rts                 ;return subroutine
;*************************************;
;Tilt sound, buzz saw down
;*************************************;
;TILT
FBA9 : CE 00 E0   ldx  #$00E0         ;load X with 00E0h
;TILT1
FBAC : 86 20      ldaa  #$20          ;load A with 20h
FBAE : 8D EA      bsr  LFB9A          ;branch sub ADDX
;TILT2:
FBB0 : 09         dex                 ;decr X
FBB1 : 26 FD      bne  LFBB0          ;branch Z=0 TILT2
FBB3 : 7F 04 00   clr  $0400          ;clear DAC output SOUND
;TILT3
FBB6 : 5A         decb                ;decr B
FBB7 : 26 FD      bne  LFBB6          ;branch Z=0 TILT3
FBB9 : 73 04 00   com  $0400          ;complement 1s DAC output SOUND
FBBC : DE 0E      ldx  $0E            ;load X with addr 0E
FBBE : 8C 10 00   cpx  #$1000         ;compare X with 1000h
FBC1 : 26 E9      bne  LFBAC          ;branch Z=0 TILT1
FBC3 : 39         rts                 ;return subroutine
;*************************************;
;GWave+Knock Calling Routine
;*************************************;
;GWKNK
FBC4 : 7F 00 09   clr  $0009          ;clear addr 0009
;GWKNKA
FBC7 : 7C 00 09   inc  $0009          ;incr addr 0009
FBCA : CE 10 47   ldx  #$1047         ;load X with 1047h
;GWKNK1
FBCD : 09         dex                 ;decr X
FBCE : 26 FD      bne  LFBCD          ;branch Z=0 GWKNK1
FBD0 : 96 09      ldaa  $09           ;load A with addr 09
;GWKNK2
FBD2 : 36         psha                ;push A into stack then SP - 1
FBD3 : BD F9 59   jsr  LF959          ;jump sub KNOCK
FBD6 : 32         pula                ;SP + 1 pull stack into A
FBD7 : 4A         deca                ;decr A
FBD8 : 26 F8      bne  LFBD2          ;branch Z=0 GWKNK2
FBDA : 86 18      ldaa  #$18          ;load A with 18h
FBDC : D6 09      ldab  $09           ;load B with addr 09
FBDE : 5A         decb                ;decr B
FBDF : 26 06      bne  LFBE7          ;branch Z=0 GWKNKX
FBE1 : 86 17      ldaa  #$17          ;load A with 17h(#(SVTAB)/7)
FBE3 : 8D 26      bsr  LFC0B          ;branch sub GWVJMP
FBE5 : 86 1B      ldaa  #$1B          ;load A with 1Bh(#(SVTAB)/7)
;GWKNKX
FBE7 : 20 22      bra  LFC0B          ;branch always GWVJMP
;*************************************;
;GWave Calling Routine #2
;*************************************;
;GWCAL2
FBE9 : CE 3D 09   ldx  #$3D09         ;load X with 3D09h
;GWCL21
FBEC : 09         dex                 ;decr X
FBED : 26 FD      bne  LFBEC          ;branch Z=0 GWCL21
FBEF : 86 16      ldaa  #$16          ;load A with 16h(#(SVTAB)/7)
FBF1 : 8D 18      bsr  LFC0B          ;branch sub GWVJMP
FBF3 : 86 0D      ldaa  #$0D          ;load A with 0Dh
FBF5 : 97 14      staa  $14           ;store A in addr 14
FBF7 : 86 01      ldaa  #$01          ;load A with 01h
FBF9 : 97 16      staa  $16           ;store A in addr 16
FBFB : 7F 00 17   clr  $0017          ;clear addr 0017
FBFE : 7E FA 44   jmp  LFA44          ;jump GWAVE
;*************************************;
;GWave Calling Routine #3
;*************************************;
;GWCAL3
FC01 : 86 0E      ldaa  #$0E          ;load A with 0Eh(#(SVTAB)/7)
FC03 : 8D 06      bsr  LFC0B          ;branch sub GWVJMP
FC05 : 86 0E      ldaa  #$0E          ;load A with 0Eh(#(SVTAB)/7)
FC07 : 8D 02      bsr  LFC0B          ;branch sub GWVJMP
FC09 : 86 12      ldaa  #$12          ;load A with 12h(#(SVTAB)/7)
;GWVJMP
FC0B : BD F9 DE   jsr  LF9DE          ;jump sub GWLD
FC0E : 7E FA 44   jmp  LFA44          ;jump GWAVE
;*************************************;
;GWave Calling Routine #4
;*************************************;
;GWCAL4
FC11 : CE FF FF   ldx  #$FFFF         ;load X with FFFFh
FC14 : DF 03      stx  $03            ;store X in addr 03
FC16 : 86 0B      ldaa  #$0B          ;load A with 0Bh
FC18 : 7C 00 06   inc  $0006          ;incr addr 0006
FC1B : D6 06      ldab  $06           ;load B with addr 06
FC1D : 56         rorb                ;rotate right B
FC1E : 24 02      bcc  LFC22          ;branch C=0 GWCL4X
FC20 : 86 10      ldaa  #$10          ;load A with 10h
;GWCL4X
FC22 : 20 E7      bra  LFC0B          ;branch always GWVJMP
;*************************************;
; Interrupt Request data
;*************************************;
;IRQDAT
FC24 : 80 00 01 02 03 89 05 06        ;
FC2C : 07 08 09 0A 88 0C 0D 87        ;
FC34 : 0F 1A 11 12 13 43 44 45        ;
FC3C : 81 82 83 84 85 86 19           ;
;*************************************;
;Special Routine Jump Table
;*************************************;
;JMPTBL
FC43 : FB A9                          ;TILT
FC45 : F9 98                          ;BGEND
FC47 : F9 9C                          ;BGSET
FC49 : F9 A7                          ;GWCAL1
FC4B : FB C4                          ;GWKNK
FC4D : FB C7                          ;GWKNKA
FC4F : FB E9                          ;GWCAL2
FC51 : FC 01                          ;GWCAL3
FC53 : FC 11                          ;GWCAL4
FC55 : F8 D7                          ;LITE
;*************************************;
; VARI VECTORS - 9 bytes
;*************************************;
;VVECT
FC57 : 28 01 00 08 81 02 00 FF FF     ;FOSHIT 
FC60 : 60 01 57 08 E1 02 00 FE B0     ;
FC69 : FF 01 00 18 41 04 80 00 FF     ;CABSHK 
FC72 : 40 01 00 10 E1 00 80 FF FF     ;SAW
FC7B : 00 FF 08 FF 68 04 80 00 FF     ;CSCALE
FC84 : 28 81 00 FC 01 02 00 FC FF     ;QUASAR
;*************************************;
;* KNOCKER PATTERN
;*************************************;
;KNKTAB
FC8D : 01FC 02FC 03F8 04F8 06F8 08F4  ;
FC99 : 0CF4 10F4 20F2 40F1 60F1 80F1  ;
FCA5 : A0F1 C0F1 0000                 ;
;*************************************;
;Wave table, 1st byte wave length
;*************************************;
;GWVTAB
FCAB : 08                             ;GS2
FCAC : 7F D9 FF D9 7F 24 00 24        ;
;
FCB4 : 0A                             ;
FCB5 : D9 D9 D9 25 25 FF FF FF        ;
FCBD : 00 00                          ;
;
FCBF : 08                             ;
FCC0 : 00 40 80 00 FF 00 80 40        ;
;
FCC8 : 10                             ;GS1
FCC9 : 7F B0 D9 F5 FF F5 D9 B0        ;
FCD1 : 7F 4E 24 09 00 09 24 4E        ;
;
FCD9 : 3C                             ;(60)
FCDA : CC E8 F9 FF F9 E8 CF B4        ;
FCE2 : 9A 84 77 73 77 83 93 A3        ;
FCEA : AF B5 B3 AA 9B 88 76 67        ;
FCF2 : 61 63 6E 81 9A B4 CC DC        ;
FCFA : E2 DC CB AF 8D 69 46 29        ;
FD02 : 15 0C 0C 15 23 32 3F 47        ;
FD0A : 48 43 39 2D 22 1C 1E 2A        ;
FD12 : 3F 5F 83 A8                    ;
;
FD16 : 24                             ;(36)
FD17 : 7F BA E6 FC F6 D7 AA 7B        ;
FD1F : 59 4C 59 7B AA D7 F6 FC        ;
FD27 : E6 BA 7F 43 17 01 07 26        ;
FD2F : 53 82 A4 B1 A4 82 53 26        ;
FD37 : 07 01 17 43                    ;
;
FD3B : 24                             ;(36)
FD3C : 7F B1 D9 F5 FE F6 E5 CF        ;
FD44 : BF B9 BF CF E5 D8 CB BA        ;
FD4C : A6 93 7F 6A 57 43 32 25        ;
FD54 : 18 10 0B 09 0B 10 18 25        ;
FD5C : 32 43 57 6A                    ;
;
FD60 : 10                             ;GSQ22
FD61 : FF FF FF FF 00 00 00 00        ;
FD69 : FF FF FF FF 00 00 00 00        ;
;
FD71 : 10                             ;MW1
FD72 : 00 F4 00 E8 00 DC 00 E2        ;
FD7A : 00 DC 00 E8 00 F4 00 00        ;
;
FD82 : 48                             ;GS72
FD83 : 8A 95 A0 AB B5 BF C8 D1        ;
FD8B : DA E1 E8 EE F3 F7 FB FD        ;
FD93 : FE FF FE FD FB F7 F3 EE        ;
FD9B : E8 E1 DA D1 C8 BF B5 AB        ;
FDA3 : A0 95 8A 7F 75 6A 5F 54        ;
FDAB : 4A 40 37 2E 25 1E 17 11        ;
FDB3 : 0C 08 04 02 01 00 01 02        ;
FDBB : 04 08 0C 11 17 1E 25 2E        ;
FDC3 : 37 40 4A 54 5F 6A 75 7F        ;
;
FDCB : 10                             ;
FDCC : 59 7B 98 AC B3 AC 98 7B        ;
FDD4 : 59 37 19 06 00 06 19 37        ;
;
FDDC : 10                             ;
FDDD : 00 6E 00 7C 00 8A 00 76        ;
FDE5 : 00 8A 00 7C 00 6E 00 00        ;
;
FDED : 08                             ;
FDEE : 62 B4 EC FF EC B4 62 00        ;
;
FDF6 : 0B                             ;(11)
FDF7 : 00 FF 00 FF 00 2B 55 80        ;
FDFF : AA D5 FF                       ;
;
FE02 : 16                             ;(22)
FE03 : 20 40 60 80 A0 C0 E0 FF        ;
FE0B : 00 FF 00 FF 00 20 40 60        ;
FE13 : 80 A0 C0 E0 FF 00              ;
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
FE19 : 81 27 00 00 00 16 32           ;(1)
FE20 : 11 32 00 01 00 0D 0E           ;
FE27 : 11 09 11 01 0F 01 48           ;
FE2E : 92 25 00 00 10 0F 5C           ;
FE35 : F4 13 00 00 00 14 48           ;
FE3C : 33 65 00 00 10 0F 5C           ;
FE43 : 61 35 00 00 20 27 6E           ;
FE4A : 84 24 00 00 03 0D 0E           ;(8)
FE51 : E2 14 00 03 04 0D 0E           ;
FE58 : F1 18 00 00 00 0E 1B           ;
FE5F : 91 24 00 00 05 0F 5C           ;
FE66 : 12 09 11 02 06 01 B6           ;
FE6D : 15 12 00 00 00 16 32           ;
FE74 : 21 88 00 00 00 16 32           ;(E)
FE7B : 31 03 00 03 06 03 6B           ;(F)
FE82 : 15 10 00 0C 01 0E 00           ;(10)
FE89 : 11 09 11 01 0A 01 B5           ;
FE90 : F1 17 00 00 06 0E 1B           ;(12)
FE97 : 31 03 00 03 0A 03 6B           ;
FE9E : F4 16 00 00 0C 0D 0E           ;
FEA5 : 12 0B 00 FF 00 20 95           ;(15)
FEAC : 12 0A 00 FF 01 09 29           ;(16)
FEB3 : 22 23 00 02 2F 10 B7           ;(17)
FEBA : 13 0C 00 FF 50 09 29           ;
FEC1 : 45 5D 00 00 04 0E 5C           ;
FEC8 : 12 05 00 00 00 23 C7           ;(1A)
FECF : 93 21 00 00 50 0E 00           ;(1B)
FED6 : 43 41 00 00 50 0E 00           ;(1C)
;*************************************;
;GWAVE FREQ PATTERN TABLE
;*************************************;
;GFRTAB 
;Hundred Point Sound
FEDD : 01 01 02 02 04 04 08 08        ;HBTSND
FEE5 : 10 10 30 60 C0 E0              ;
;Spinner Sound
FEEB : 01 01 02 02 03 04 05 06        ;SPNSND
FEF3 : 07 08 09 0A 0C                 ;
;Yuksnd
FEF8 : 08 80 10 78 18 70 20 60        ;YUKSND
FF00 : 28 58 30 50 40 48              ;
;Turbine Start Up
FF06 : 80 7C 78 74 70 74 78 7C 80     ;TRBPAT
;Heartbeat Distorto
FF0F : 01 01 02 02 04 04 08 08        ;HBDSND
FF17 : 10 20 28 30 38 40 48 50        ;
FF1F : 60 70 80 A0 B0 C0              ;
;BigBen Sounds
FF25 : 08 40 08 40 08 40 08 40 08 40  ;BBSND
FF2F : 08 40 08 40 08 40 08 40 08 40  ;
;Heartbeat Echo
FF39 : 01 02 04 08 09 0A 0B 0C        ;HBESND
FF41 : 0E 0F 10 12 14 16              ;
;Spinner Sound "Drip"
FF47 : 40                             ;SPNR
;Cool Downer
FF48 : 10 08 01                       ;COOLDN 
;Start Distorto Sound
FF4B : 01 01 01 01 02 02 03 03        ;STDSND 
FF53 : 04 04 05 06 08 0A 0C 10        ;
FF5B : 14 18 20 30 40 50 40 30        ;
FF63 : 20 10 0C 0A 08 07 06 05        ;
FF6B : 04 03 02 02 01 01 01           ;
;
FF72 : 06 06 06 06 07 07 08 08        ;UNKNWN
FF7A : 09 09 0A 0B 0D 0F 11 15        ;
FF82 : 17 1D 25 35 45 55 65 75        ;
FF8A : 85 95 A5 B5 C5 D5 E5 F5        ;
;
FF92 : 08 10 1A 32 1A 11 1A 1B        ;UNKNWN
FF9A : 1C 1B 1A 19 11 19 1A 1E        ;
FFA2 : 26 30                          ;
;
FFA4 : 01 01 11 11 11 11 12 12        ;UNKNWN
FFAC : 13 13 14 14 15 16 18 1A        ;
FFB4 : 1C                             ;
;
FFB5 : 20 24 28 30 40 50 60 50        ;UNKNWN
FFBD : 40 30 20                       ;
;
FFC0 : 1C 1A 18 17 16 15 14           ;UNKNWN
;*************************************;
;zero padding
FFC7 : 00 00 00 00 00 00 
FFCD : 00 00 00 00 00 00 00 00 
FFD5 : 00 00 00 00 00 00 00 00 
FFDD : 00 00 00 00 00 00 00 00 
FFE5 : 00 00 00 00 00 00 00 00 
FFED : 00 00 00 00 00 00 00 00 
FFF5 : 00 00 00 
;*************************************;
;Motorola vector table
;*************************************;
FFF8 : FB 16                          ;IRQ 
FFFA : F8 01                          ;RESET SWI (software) 
FFFC : F8 08                          ;NMI 
FFFE : F8 01                          ;RESET (hardware) 

;--------------------------------------------------------------







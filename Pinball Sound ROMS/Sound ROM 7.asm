        ;
        ;  Disassembled by:
        ;    DASMx object code disassembler
        ;    (c) Copyright 1996-2003   Conquest Consultants
        ;    Version 1.40 (Oct 18 2003)
        ;
        ;  File:    SolarFire.716
        ;
        ;  Size:    2048 bytes
        ;  Checksum:  DA1D
        ;  CRC-32:    05A2230C
        ;
        ;  Date:    Sat Mar 20 12:39:55 2021
        ;
        ;  CPU:    Motorola 6800 (6800/6802/6808 family)
        ;
        ; 
        ; Solar Fire dated 1981, Pinball Sound ROM 7
        ;
        ; updated 17 May 2021
        ;
          org  $F800
F800 : FC                        ;hmmm
;*************************************;
;RESET, power on
;*************************************; 
F801 : 0F         sei                 ;set interrupt mask  
F802 : 8E 00 7F   lds  #$007F         ;load stack pointer with 007Fh 
F805 : CE 04 00   ldx  #$0400         ;load X with 0400h  PIA addr
F808 : 6F 01      clr  $01,x          ;clear X+01h (0401) PIA CR port A
F80A : 6F 03      clr  $03,x          ;clear X+03h (0403) PIA CR port B
F80C : 86 FF      ldaa  #$FF          ;load A with FFh 
F80E : A7 00      staa  $00,x         ;store A in addr X+00h (0400) PIA port A out (DAC sound)
F810 : C6 80      ldab  #$80          ;load B with 80h 
F812 : E7 02      stab  $02,x         ;store B in addr X+00h (0402) PIA port B in (sound select)
F814 : 86 37      ldaa  #$37          ;load A with 37h 
F816 : A7 03      staa  $03,x         ;store A in addr X+03h (0403) PIA CR port B
F818 : 86 3C      ldaa  #$3C          ;load A with 3Ch
F81A : A7 01      staa  $01,x         ;store A in addr X+01h (0401) PIA1 CR port A
F81C : 97 14      staa  $14           ;store A in addr 0014
F81E : E7 02      stab  $02,x         ;store A in addr X + 02h (0402) PIA port B
F820 : 4F         clra                ;clear A
F821 : 97 11      staa  $11           ;store A in addr 11
F823 : 97 12      staa  $12           ;store A in addr 12
F825 : 97 0F      staa  $0F           ;store A in addr 0F
F827 : 97 10      staa  $10           ;store A in addr 10
F829 : 0E         cli                 ;clear interrupt
;STDBY1
F82A : 20 FE      bra  LF82A          ;branch always here STDBY1
;*************************************;
; Copyright Notice
;*************************************;
F82C : 43    "C"                 ;COPYRIGHT
F82D : 4F    "O"
F82E : 50    "P"
F82F : 59    "Y"
F830 : 52    "R"
F831 : 49    "I"
F832 : 47    "G"
F833 : 48    "H"
F834 : 54    "T"
F835 : 20 28    " ("            ; (C)
F837 : 43    "C"
F838 : 29 20    ") "
F83A : 57    "W"                 ;WILLIAMS
F83B : 49    "I"
F83C : 4C    "L"
F83D : 4C    "L"
F83E : 49    "I"
F83F : 41    "A"
F840 : 4D    "M"
F841 : 53    "S"
F842 : 20 45    " E"            ;ELECTRONICS
F844 : 4C    "L"
F845 : 45    "E"
F846 : 43    "C"
F847 : 54    "T"
F848 : 52    "R"
F849 : 4F    "O"
F84A : 4E    "N"
F84B : 49    "I"
F84C : 43    "C"  
F84D : 53    "S"
F84E : 20 35    " 5"            ; 5/29/81
F850 : 2F 32    "/2"
F852 : 39    "9"
F853 : 2F 38    "/8"
F855 : 31    "1"
F856 : 20 45    " E"            ; EJS (Ed Suchocki)
F858 : 4A    "J"
F859 : 53    "S"
;*************************************;
;Vari Loader
;*************************************;
;VARILD
F85A : 16         tab                 ;trans A to B
F85B : 48         asla                ;arith shift left A (bit0 is 0)
F85C : 48         asla                ;arith shift left A
F85D : 48         asla                ;arith shift left A (shifts all bits left x3)
F85E : 1B         aba                 ;add A and B into A 
F85F : CE 00 1F   ldx  #$001F         ;load X with 001Fh
F862 : DF 1B      stx  $1B            ;store X in addr 1B
F864 : CE FD 6F   ldx  #$FD6F         ;load X with FD6Fh (VVECT table)
F867 : BD FC DF   jsr  LFCDF          ;jump sub ADDX
F86A : C6 09      ldab  #$09          ;load B with 09h (0000 1001)
;*************************************;
;Parameter Transfer
;*************************************;
;TRANS:
F86C : A6 00      ldaa  $00,x         ;load A with addr X + 00h
F86E : DF 19      stx  X0019          ;store X in addr 19
F870 : DE 1B      ldx  X001B          ;load X with addr 1B
F872 : A7 00      staa  $00,x         ;store A in addr X + 00h
F874 : 08         inx                 ;incr X
F875 : DF 1B      stx  X001B          ;store X in addr 1B
F877 : DE 19      ldx  X0019          ;load X with addr 19
F879 : 08         inx                 ;incr X
F87A : 5A         decb                ;decr B
F87B : 26 EF      bne  LF86C          ;branch !=0 TRANS
F87D : 39         rts                 ;return subroutine
;*************************************;
;Variable Duty Cycle Square Wave Routine
;*************************************;
;VARI
F87E : 96 27      ldaa  X0027         ;load A with addr 27
F880 : B7 04 00   staa  X0400         ;store A in DAC output SOUND
;VAR0
F883 : 96 1F      ldaa  X001F         ;load A with addr 1F
F885 : 97 28      staa  X0028         ;store A in addr 28
F887 : 96 20      ldaa  X0020         ;load A with addr 20
F889 : 97 29      staa  X0029         ;store A in addr 28
;V0
F88B : DE 24      ldx  X0024          ;load X with addr 24
;V0LP
F88D : 96 28      ldaa  X0028         ;load A with addr 28
F88F : 73 04 00   com  X0400          ;complement 1s in DAC output SOUND
;V1
F892 : 09         dex                 ;decr X
F893 : 27 10      beq  LF8A5          ;branch Z=1 VSWEEP
F895 : 4A         deca                ;decr A
F896 : 26 FA      bne  LF892          ;branch Z=0 V1
F898 : 73 04 00   com  X0400          ;complement 1s in DAC output SOUND
F89B : 96 29      ldaa  X0029         ;load A with addr 29
;V2
F89D : 09         dex                 ;decr X
F89E : 27 05      beq  LF8A5          ;branch Z=1 VSWEEP
F8A0 : 4A         deca                ;decr A
F8A1 : 26 FA      bne  LF89D          ;branch Z=0 V2
F8A3 : 20 E8      bra  LF88D          ;branch always V0LP
;VSWEEP
F8A5 : B6 04 00   ldaa  X0400         ;load A with addr PIA DAC 
F8A8 : 2B 01      bmi  LF8AB          ;branch N=1 VS1
F8AA : 43         coma                ;complement 1s A
;VS1
F8AB : 8B 00      adda  #$00          ;add A with 00h
F8AD : B7 04 00   staa  X0400         ;store A in DAC output SOUND
F8B0 : 96 28      ldaa  X0028         ;load A with addr 28
F8B2 : 9B 21      adda  X0021         ;add A with addr 21
F8B4 : 97 28      staa  X0028         ;store A in addr 28
F8B6 : 96 29      ldaa  X0029         ;load A with addr 29
F8B8 : 9B 22      adda  X0022         ;add A with addr 22
F8BA : 97 29      staa  X0029         ;store A in addr 29
F8BC : 91 23      cmpa  X0023         ;comp A with addr 23
F8BE : 26 CB      bne  LF88B          ;branch Z=0 V0
F8C0 : 96 26      ldaa  X0026         ;load A with addr 26
F8C2 : 27 06      beq  LF8CA          ;branch Z=1 VARX
F8C4 : 9B 1F      adda  X001F         ;add A with addr 1F
F8C6 : 97 1F      staa  X001F         ;store A in addr 1F
F8C8 : 26 B9      bne  LF883          ;branch Z=0 VAR0
;VARX
F8CA : 39         rts                 ;return subroutine
;*************************************;
;Noise tables
;*************************************;
F8CB : 10 FF 01 01 01                 ;NSTAB1
;
F8D0 : C0 FF 01 01 01                 ;NSTAB2
;*************************************;
;Siren Air Raid
;*************************************;
;ZIREN
F8D5 : 86 FF      ldaa  #$FF          ;load A with FFh
F8D7 : 97 1F      staa  $1F           ;store A in addr 1F (TOP)
F8D9 : CE FE C0   ldx  #$FEC0         ;load X with FEC0h
F8DC : DF 21      stx  $21            ;store X in addr 21 (SWEEP)
F8DE : 86 20      ldaa  #$20          ;load A with 20h 
F8E0 : CE FF E0   ldx  #$FFE0         ;load X with FFE0h 
F8E3 : 8D 05      bsr  LF8EA          ;branch sub ZIREN0
F8E5 : 86 01      ldaa  #$01          ;load A with 01h 
F8E7 : CE 00 44   ldx  #$0044         ;load X with 0044h 
;ZIREN0
F8EA : 97 23      staa  $23           ;store A in addr 23 (SLOPE)
F8EC : DF 24      stx  $24            ;store X in addr 24 (END)
;ZIREN1
F8EE : CE 00 10   ldx  #$0010         ;load X with 0010h (COUNT2)
;ZIREN2
F8F1 : 8D 21      bsr  LF914          ;branch sub ZIRTRI
F8F3 : 96 20      ldaa  $20           ;load A with addr 20 (TOP+1)
F8F5 : 9B 22      adda  $22           ;add A with addr 22 (SWEEP+1)
F8F7 : 97 20      staa  $20           ;store A in addr 20 (TOP+1)
F8F9 : 96 1F      ldaa  $1F           ;load A with addr 1F (TOP)
F8FB : 99 21      adca  $21           ;add C+A + addr 21 (SWEEP)
F8FD : 97 1F      staa  $1F           ;store A in addr 1F (TOP)
F8FF : 09         dex                 ;decr X
F900 : 26 EF      bne  LF8F1          ;branch Z=0 ZIREN2
F902 : 96 22      ldaa  $22           ;load A with addr 22(SWEEP+1)
F904 : 9B 23      adda  $23           ;add A with addr 23(SLOPE)
F906 : 97 22      staa  $22           ;store A in addr 22(SWEEP+1)
F908 : 24 03      bcc  LF90D          ;branch C=0 ZIREN5
F90A : 7C 00 21   inc  $0021          ;incr addr 21(SWEEP)
;ZIREN5
F90D : DE 21      ldx  $21            ;load X with addr 21(SWEEP)
F90F : 9C 24      cpx  $24            ;compare X with addr 24 (END2))
F911 : 26 DB      bne  LF8EE          ;branch Z=0 ZIREN1
F913 : 39         rts                 ;return subroutine
;* Flat Triangle Loop
;ZIRTRI
F914 : 4F         clra                ;clear A
;ZIRLP1
F915 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F918 : 8B 20      adda  #$20          ;add A with 20h
F91A : 24 F9      bcc  LF915          ;branch C=0 ZIRLP1
F91C : 8D 09      bsr  LF927          ;branch sub ZIRT
F91E : 86 E0      ldaa  #$E0          ;load A with E0h
;ZIRLP4
F920 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F923 : 80 20      suba  #$20          ;sub A with 20h
F925 : 24 F9      bcc  LF920          ;branch C=0 ZIRLP4
;ZIRT
F927 : D6 1F      ldab  $1F           ;load B with addr 1F (TOP)
;ZIRLP2
F929 : 86 02      ldaa  #$02          ;load A with 02h 
;ZIRLP3
F92B : 4A         deca                ;decr A
F92C : 26 FD      bne  LF92B          ;branch Z=0 ZIRLP3
F92E : 5A         decb                ;decr B
F92F : 26 F8      bne  LF929          ;branch Z=0 ZIRLP2
F931 : 39         rts                 ;return subroutine
;*************************************;
;Lightning+Appear Noise Routine
;*************************************;
;LITEN
F932 : 86 C0      ldaa  #$C0          ;load A with C0h 
F934 : 97 27      staa  $27           ;store A in addr 27
F936 : 86 FF      ldaa  #$FF          ;load A with FFh
F938 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
;LITE0
F93B : C6 10      ldab  #$10          ;load B with 10h
;LITE1
F93D : 8D 79      bsr  LF9B8          ;branch sub NOISE1
F93F : 44         lsra                ;logic shift right A 
F940 : 76 00 14   ror  $0014          ;rotate right addr 14 
F943 : 76 00 15   ror  $0015          ;rotate right addr 15 
F946 : 24 03      bcc  LF94B          ;branch C=0 LITE2
F948 : 73 04 00   com  $0400          ;complement 1s in DAC output SOUND
;LITE2
F94B : 96 27      ldaa  $27           ;load A with addr 27
;LITE3
F94D : 4A         deca                ;decr A
F94E : 26 FD      bne  LF94D          ;branch Z=0 LITE3
F950 : 5A         decb                ;decr B
F951 : 26 EA      bne  LF93D          ;branch Z=0 LITE1
F953 : 96 27      ldaa  $27           ;load A with addr 27
F955 : 8B FE      adda  #$FE          ;add A with FEh 
F957 : 97 27      staa  $27           ;store A in addr 27
F959 : 26 E0      bne  LF93B          ;branch Z=0 LITE0
F95B : 39         rts                 ;return subroutine
;*************************************;
;*WHITE NOISE ROUTINE
;*************************************;
;*NFRQ=INIT PERIOD, NAMP=INIT AMP, DECAY AMPLITUDE RATE
;*CYCNT=CYCLE COUNT, NFFLG= FREQ DECAY FLAG
;*NFFLG=0 NO FREQ CHANGE;=POS DECAY;=MINUS INC FREQ
;*NOISE LOAD PROG-ENTER WITH XREG POINTING TO DATA
;*
;NOISLD
F95C : A6 00      ldaa  $00,x   ;load A with addr X + 00h
F95E : 97 24      staa  X0024   ;store A in addr 24
F960 : A6 01      ldaa  $01,x   ;load A with addr X + 01h
F962 : 97 20      staa  X0020   ;store A in addr 20
F964 : A6 02      ldaa  $02,x   ;load A with addr X + 02h
F966 : 97 1F      staa  X001F   ;store A in addr 1F
F968 : A6 03      ldaa  $03,x   ;load A with addr X + 03h
F96A : 97 22      staa  X0022   ;store A in addr 22
F96C : A6 04      ldaa  $04,x   ;load A with addr X + 04h
F96E : 97 27      staa  X0027   ;store A in addr 27
;NEND
F970 : 39         rts           ;return subroutine
;*************************************;
;Noise Table Loader #1
;*************************************;
;NSTLD1
F971 : CE F8 CB   ldx  #$F8CB         ;load X with F8CBh (NSTAB1)
F974 : 20 03      bra  LF979          ;branch always NOISLG
;*************************************;
;Noise Table Loader #2
;*************************************;
;NSTLD2
F976 : CE F8 D0   ldx  #$F8D0         ;load X with F8D0h (NSTAB2)
;
;*LOAD NOISE AND GO
;NOISLG:
F979 : 8D E1      bsr  LF95C          ;branch sub NOISLD
;
;*NOISE INIT
;NOIN
F97B : 8D 30      bsr  LF9AD          ;branch sub NSUB
;
;*NOISE LOOP
;NO1
F97D : 8D 5B      bsr  LF9DA          ;branch sub RNT
F97F : 96 26      ldaa  X0026         ;load A with addr 26
F981 : 91 27      cmpa  X0027         ;comp A with addr 27
F983 : 26 F8      bne  LF97D          ;branch !=0 NO1
F985 : 59         rolb                ;rotate left B (bit7 = Carry)
F986 : F7 04 00   stab  X0400         ;store B in DAC output SOUND
F989 : 8D 35      bsr  LF9C0          ;branch sub NOIS12
F98B : 8D 3B      bsr  LF9C8          ;branch sub NOISE2
F98D : 8D 5F      bsr  LF9EE          ;branch sub RNA
F98F : 7D 00 20   tst  X0020          ;test addr 20
F992 : 27 DC      beq  LF970          ;branch =0 NEND
F994 : 7D 00 21   tst  X0021          ;test addr 21
F997 : 26 E4      bne  LF97D          ;branch !=0 NO1
F999 : 7D 00 22   tst  X0022          ;test addr 22
F99C : 27 DF      beq  LF97D          ;branch =0 NO1
F99E : 2B 05      bmi  LF9A5          ;branch N=1 NO3 
F9A0 : 7C 00 27   inc  X0027          ;incr addr 27
F9A3 : 20 D8      bra  LF97D          ;branch always NO1
;NO3
F9A5 : 7A 00 27   dec  X0027          ;decr addr 27
F9A8 : 7A 00 26   dec  X0026          ;decr addr 26
F9AB : 20 D0      bra  LF97D          ;branch always NO1
;NSUB
F9AD : 7F 00 21   clr  X0021          ;clr (00) addr 21
F9B0 : 96 27      ldaa  X0027         ;load A with addr 27
F9B2 : 97 26      staa  X0026         ;store A in addr 26
F9B4 : 7F 00 25   clr  X0025          ;clr (00) addr 25
F9B7 : 39         rts                 ;return subroutine
;*
;* 23 CYCLES FOR EACH SUBROUTINE PLUS CALLING OVERHEAD
;*
;NOISE1:
F9B8 : 96 15      ldaa  X0015         ;load A with addr 15
F9BA : 44         lsra                ;logic shift right A (bit7=0)
F9BB : 44         lsra                ;logic shift right A
F9BC : 44         lsra                ;logic shift right A (bit7=0)
F9BD : 98 15      eora  X0015         ;exclusive OR A with addr 15
F9BF : 39         rts                 ;return subroutine
;NOIS12
F9C0 : 8D F6      bsr  LF9B8          ;branch sub NOISE1
F9C2 : 97 23      staa  X0023         ;store A in addr 23
F9C4 : 08         inx                 ;incr X
F9C5 : 84 07      anda  #$07          ;and A with 07h (0000 0111)
F9C7 : 39         rts                 ;return subroutine
;*
;NOISE2:
F9C8 : 96 23      ldaa  X0023         ;load A with addr 23
F9CA : 44         lsra                ;logic shift right A (bit7=0)
F9CB : 76 00 14   ror  X0014          ;rotate right addr 14 (bit7=C,C=bit0)
F9CE : 76 00 15   ror  X0015          ;rotate right addr 15 (bit7=C,C=bit0)
F9D1 : 86 00      ldaa  #$00          ;load A with 00h (0000 0000)
F9D3 : 24 02      bcc  LF9D7          ;branch Carry clear NOISE3
F9D5 : 96 20      ldaa  X0020         ;load A with addr 20
;NOISE3
F9D7 : 97 25      staa  X0025         ;store A in addr 25
F9D9 : 39         rts                 ;return subroutine
;*
;RNT:
F9DA : 96 27      ldaa  X0027         ;load A with addr 27
F9DC : 7A 00 26   dec  X0026          ;decr addr 26
F9DF : 27 04      beq  LF9E5          ;branch =0 NW0
F9E1 : 08         inx                 ;incr X
F9E2 : 09         dex                 ;decr X
F9E3 : 20 08      bra  LF9ED          ;branch always NNW1
;NW0
F9E5 : 97 26      staa  X0026         ;store A ina ddr 26
F9E7 : D6 25      ldab  X0025         ;load A with addr 25
F9E9 : 54         lsrb                ;logic shift right B (bit7=0)
F9EA : 7C 00 21   inc  X0021          ;incr addr 21
;NNW1
F9ED : 39         rts                 ;return subroutine
;*
;RNA:
F9EE : 96 24      ldaa  X0024         ;load A with addr 24
F9F0 : 91 21      cmpa  X0021         ;comp A with addr 21
F9F2 : 27 04      beq  LF9F8          ;branch =0 NW2
F9F4 : 08         inx                 ;incr X
F9F5 : 09         dex                 ;decr X
F9F6 : 20 09      bra  LFA01          ;branch always NW3
;NW2
F9F8 : 7F 00 21   clr  X0021          ;clr (00) addr 21
F9FB : 96 20      ldaa  X0020         ;load A with addr 20
F9FD : 90 1F      suba  X001F         ;A = A - addr 1F
F9FF : 97 20      staa  X0020         ;store A in addr 20
;NW3:
FA01 : 39         rts                 ;return subroutine
;*************************************;
;* THE BOMB OOOOOH NOOOOO!
;*************************************;
;WHIST
FA02 : 86 80      ldaa  #$80          ;load A with 80h 
FA04 : 97 22      staa  X0022         ;store A in addr 22(FREQZ)
FA06 : 86 FA      ldaa  #$FA          ;load A with FAh (#SINTBL/$100)
FA08 : 97 20      staa  X0020         ;store A in addr 20(TABLE)
;WHIST0
FA0A : 86 80      ldaa  #$80          ;load A with 80h 
FA0C : 97 1D      staa  X001D         ;store A in addr 1D(TEMPA)
;WHIST1
FA0E : 86 12      ldaa  #$12          ;load A with 12h 
;WHIST2
FA10 : 4A         deca                ;decr A
FA11 : 26 FD      bne  LFA10          ;branch !=0 WHIST2
FA13 : 96 1F      ldaa  X001F         ;load A with addr 1F(TIME)
FA15 : 9B 22      adda  X0022         ;add A with addr 22(FREQZ)
FA17 : 97 1F      staa  X001F         ;store A in addr 1F(TIME)
FA19 : 44         lsra                ;logic shift right A 
FA1A : 44         lsra                ;logic shift right A 
FA1B : 44         lsra                ;logic shift right A 
FA1C : 8B 36      adda  #$36          ;add A with 36h (#SINTBL!.$FF)
FA1E : 97 21      staa  X0021         ;store A in addr 21(TABLE+1)
FA20 : DE 20      ldx  X0020          ;load X with addr 20(TABLE)
FA22 : A6 00      ldaa  $00,x         ;load A with addr X + 00h
FA24 : B7 04 00   staa  X0400         ;store A in DAC output SOUND
FA27 : 7A 00 1D   dec  X001D          ;decr addr 1D(TEMPA)
FA2A : 26 E2      bne  LFA0E          ;branch !=0 WHIST1
FA2C : 7A 00 22   dec  X0022          ;decr addr 22(FREQZ)
FA2F : 96 22      ldaa  X0022         ;load A with addr 22(FREQZ)
FA31 : 81 20      cmpa  #$20          ;comp A with 20h 
FA33 : 26 D5      bne  LFA0A          ;branch !=0 WHIST0
FA35 : 39         rts                 ;return subroutine
;*************************************;
;*SINE TABLE
;*************************************;
;SINTBL
FA36 : 80 8C 98 A5 B0 BC C6 D0        ;
FA3E : DA E2 EA F0 F5 FA FD FE        ;
FA46 : FF FE FD FA F5 F0 EA E2        ;
FA4E : DA D0 C6 BC B0 A5 98 8C        ;
FA56 : 80 73 67 5A 4F 43 39 2F        ;
FA5E : 25 1D 15 0F 0A 05 02 01        ;
FA66 : 00 01 02 05 0A 0F 15 1D        ;
FA6E : 25 2F 39 43 4F 5A 67 73        ;
;*************************************;
;Background End Routine
;*************************************;
;BGEND
FA76 : 7F 00 0F   clr  $000F          ;clear addr 000F (BG1FLG)
FA79 : 7F 00 10   clr  $0010          ;clear addr 0010 (BG2FLG)
FA7C : 39         rts                 ;return subroutine
;*************************************;
;Background Sound #1 increment
;*************************************;
;BG1INC
FA7D : 96 10      ldaa  $10           ;load A with addr 10 (BG2FLG)
FA7F : 8A 80      oraa  #$80          ;OR A with 80h 
FA81 : 97 10      staa  $10           ;store A in addr 10(BG2FLG)
FA83 : 96 0F      ldaa  $0F           ;load A with addr 0F(BG1FLG)
FA85 : 84 7F      anda  #$7F          ;and A with 7Fh 
FA87 : 81 7F      cmpa  #$7F          ;comp A with 7Fh
FA89 : 26 01      bne  LFA8C          ;branch !Z=0 PRM111
FA8B : 4F         clra                ;clear A
;BG1IO
FA8C : 4C         inca                ;incr A
FA8D : 97 0F      staa  $0F           ;store A in addr 0F(BG1FLG)
FA8F : 39         rts                 ;return subroutine
;*************************************;
;Background 1 Routine
;*************************************;
;BG1
FA90 : 86 0E      ldaa  #$0E          ;load A with 0Eh 
FA92 : 8D 5C      bsr  LFAF0          ;branch sub GWLD
FA94 : 96 0F      ldaa  $0F           ;load A with addr 0F(BG1FLG)
FA96 : 43         coma                ;complement 1s A
FA97 : BD FB AB   jsr  LFBAB          ;jump sub GEND60
;BG1LP
FA9A : 7C 00 23   inc  $0023          ;incr addr 23
FA9D : BD FB AD   jsr  LFBAD          ;jump sub GEND61
FAA0 : 20 F8      bra  LFA9A          ;branch always LOOP18
;*************************************;
;Background Sound #2 increment
;*************************************;
;BG2INC
FAA2 : 96 0F      ldaa  $0F           ;load A with addr 0F(BG1FLG)
FAA4 : 8A 80      oraa  #$80          ;OR A with 80h 
FAA6 : 97 0F      staa  $0F           ;store A in addr 0F(BG1FLG)
FAA8 : 96 10      ldaa  $10           ;load A with addr 10(BG2FLG)
FAAA : 84 7F      anda  #$7F          ;and A with 7F 
FAAC : 81 7F      cmpa  #$7F          ;compare A with 7Fh
FAAE : 26 01      bne  LFAB1          ;branch Z=0 BG2IO
FAB0 : 4F         clra                ;clear A
;BG2IO
FAB1 : 4C         inca                ;incr A
FAB2 : 97 10      staa  $10           ;store A in addr 10(BG2FLG)
FAB4 : 39         rts                 ;return subroutine
;*************************************;
;Background 2 Routine
;*************************************;
;BG2
FAB5 : 86 0F      ldaa  #$0F          ;load A with 0Fh 
FAB7 : 8D 37      bsr  LFAF0          ;branch sub GWLD
FAB9 : 96 10      ldaa  $10           ;load A with addr 10(BG2FLG)
FABB : 43         coma                ;complement 1s A
FABC : BD FB AB   jsr  LFBAB          ;jump sub GEND60
;BG2LP
FABF : 7C 00 23   inc  $0023          ;incr addr 23
FAC2 : BD FB AD   jsr  LFBAD          ;jump sub GEND61
FAC5 : 20 F8      bra  LFABF          ;branch always BG2LP
;*************************************;
;GWAVE Calling routine #1
;*************************************;
;GWCAL1
FAC7 : 96 11      ldaa  $11           ;load A with addr 11
FAC9 : 26 07      bne  LFAD2          ;branch !=0 GWCL11
FACB : 7C 00 11   inc  $0011          ;incr addr 11
;GCL1LP
FACE : 86 10      ldaa  #$10          ;load A with 10h
FAD0 : 20 11      bra  LFAE3          ;branch always GWLDCL
;*
;GWCL11
FAD2 : 96 23      ldaa  $23           ;load A with addr 23
FAD4 : 81 B2      cmpa  #$B2          ;compare A with B2h
FAD6 : 27 F6      beq  LFACE          ;branch Z=1 GCL1LP
FAD8 : 20 13      bra  LFAED          ;branch always GWCLX
;*************************************;
;GWAVE Calling Routine #2
;*************************************;
;GWCAL2
FADA : 96 12      ldaa  $12           ;load A with addr 12
FADC : 26 09      bne  LFAE7          ;branch Z=0 GWCL21
FADE : 7C 00 12   inc  $0012          ;incr 12
;GCL2LP
FAE1 : 86 11      ldaa  #$11          ;load A with 11h 
;*
;GWLDCL 
FAE3 : 8D 0B      bsr  LFAF0          ;branch sub GWLD
FAE5 : 20 70      bra  LFB57          ;branch always GWAVE
;*
;GWCL21
FAE7 : 96 23      ldaa  $23           ;load A with addr 23
FAE9 : 81 C0      cmpa  #$C0          ;comp A with C0h
FAEB : 27 F4      beq  LFAE1          ;branch =0 GCL2LP
;GWCLX
FAED : 7E FB A0   jmp  LFBA0          ;jump GEND50
;*************************************;
;GWAVE Loader
;*************************************;
;GWLD:
FAF0 : 16         tab                 ;trans A to B
FAF1 : 58         aslb                ;arith shift left B 
FAF2 : 1B         aba                 ;add A and B into A
FAF3 : 1B         aba                 ;add A and B into A
FAF4 : 1B         aba                 ;add A and B into A
FAF5 : CE FE 66   ldx  #$FE66         ;load X with (SVTAB)(SOUND VECTOR TABLE)
FAF8 : BD FC DF   jsr  LFCDF          ;jump sub ADDX
FAFB : A6 00      ldaa  $00,x         ;load A with addr X + 00h
FAFD : 16         tab                 ;trans A to B
FAFE : 84 0F      anda  #$0F          ;and A with 0Fh 
FB00 : 97 20      staa  X0020         ;store A in addr 20
FB02 : 8D 4E      bsr  LFB52          ;branch sub ECHO
FB04 : D7 1F      stab  X001F         ;store B in addr 1F
FB06 : A6 01      ldaa  $01,x         ;load A with addr X + 00h
FB08 : 16         tab                 ;trans A to B
FB09 : 8D 47      bsr  LFB52          ;branch sub ECHO
FB0B : D7 21      stab  X0021         ;store B in addr 21
FB0D : 84 0F      anda  #$0F          ;and A with 0Fh 
FB0F : 97 1D      staa  X001D         ;store A in addr 1D
FB11 : DF 17      stx  X0017          ;store X in addr 17
FB13 : CE FD 9C   ldx  #$FD9C         ;load X with FD9Ch (#GWVTAB) CALC WAVEFORM ADDR
;GWLD2
FB16 : 7A 00 1D   dec  X001D          ;decr addr 1D
FB19 : 2B 08      bmi  LFB23          ;branch N=1 GWLD3
FB1B : A6 00      ldaa  $00,x         ;load A with addr X + 00h
FB1D : 4C         inca                ;incr A
FB1E : BD FC DF   jsr  LFCDF          ;jump sub ADDX
FB21 : 20 F3      bra  LFB16          ;branch always GWLD2
;GWLD3
FB23 : DF 24      stx  X0024          ;store X in addr 24
FB25 : BD FB E7   jsr  LFBE7          ;jump sub WVTRAN
FB28 : DE 17      ldx  X0017          ;load X with addr 17
FB2A : A6 02      ldaa  $02,x         ;load A with addr X + 02h
FB2C : 97 26      staa  X0026         ;store A in addr 26
FB2E : BD FB F9   jsr  LFBF9          ;jump sub WVDECA
FB31 : DE 17      ldx  X0017          ;load X with addr 17
FB33 : A6 03      ldaa  $03,x         ;load A with addr X + 03h
FB35 : 97 22      staa  X0022         ;store A in addr 22
FB37 : A6 04      ldaa  $04,x         ;load A with addr X + 04h
FB39 : 97 23      staa  X0023         ;store A in addr 23
FB3B : A6 05      ldaa  $05,x         ;load A with addr X + 05h
FB3D : 16         tab                 ;trans A to B
FB3E : A6 06      ldaa  $06,x         ;load A with addr X + 06h
FB40 : CE FE E4   ldx  #$FEE4         ;load X with FEE4h (#GFRTAB)
FB43 : BD FC DF   jsr  LFCDF          ;jump sub ADDX
FB46 : 17         tba                 ;trans B to A
FB47 : DF 27      stx  X0027          ;store X in addr 27
FB49 : 7F 00 2F   clr  X002F          ;clr (00) addr 2F
FB4C : BD FC DF   jsr  LFCDF          ;jump sub ADDX
FB4F : DF 29      stx  X0029          ;store X in addr 29
FB51 : 39         rts                 ;return subroutine
;*************************************;
;Echo Routine 
;*************************************;
;ECHO
FB52 : 54         lsrb                ;logic shift right B 
FB53 : 54         lsrb                ;logic shift right B
FB54 : 54         lsrb                ;logic shift right B
FB55 : 54         lsrb                ;logic shift right B 
FB56 : 39         rts                 ;return subroutine
;*************************************;
;GWAVE routine
;*************************************;
;ACCA=Freq Pattern Length, X=Freq Pattern Addr
;GWAVE
FB57 : 96 1F      ldaa  X001F         ;load A with addr 1F
FB59 : 97 2E      staa  X002E         ;store A in addr 2E
;GWT4
FB5B : DE 27      ldx  X0027          ;load X with addr 27
FB5D : DF 19      stx  X0019          ;store X in addr 19
;GPLAY
FB5F : DE 19      ldx  X0019          ;load X with addr 19
FB61 : A6 00      ldaa  $00,x         ;load A with addr X + 00h
FB63 : 9B 2F      adda  X002F         ;add A with addr 2F
FB65 : 97 2D      staa  X002D         ;store A in addr 2D
FB67 : 9C 29      cpx  X0029          ;comp X with addr 29
FB69 : 27 26      beq  LFB91          ;branch Z=1 GEND
FB6B : D6 20      ldab  X0020         ;load B with addr 20
FB6D : 08         inx                 ;incr X
FB6E : DF 19      stx  X0019          ;store X in addr 19
;GOUT
FB70 : CE 00 30   ldx  #$0030         ;load X with addr 30
;GOUTLP
FB73 : 96 2D      ldaa  X002D         ;load A with addr 2D
;GPRLP
FB75 : 4A         deca                ;decr A
FB76 : 26 FD      bne  LFB75          ;branch Z=0 GPRLP
FB78 : A6 00      ldaa  $00,x         ;load A with addr X + 00h
FB7A : B7 04 00   staa  $0400         ;store A in DAC output SOUND
;GPR1
FB7D : 08         inx                 ;incr X
FB7E : 9C 2B      cpx  X002B          ;compare X with addr 2B
FB80 : 26 F1      bne  LFB73          ;branch Z=0 GOUTLP
FB82 : 5A         decb                ;decr B
FB83 : 27 DA      beq  LFB5F          ;branch Z=1 GPLAY
FB85 : 08         inx                 ;incr X
FB86 : 09         dex                 ;decr X
FB87 : 08         inx                 ;incr X
FB88 : 09         dex                 ;decr X
FB89 : 08         inx                 ;incr X
FB8A : 09         dex                 ;decr X
FB8B : 08         inx                 ;incr X
FB8C : 09         dex                 ;decr X
FB8D : 01         nop                 ;
FB8E : 01         nop                 ;
FB8F : 20 DF      bra  LFB70          ;branch always GOUT
;GEND
FB91 : 96 21      ldaa  X0021         ;load A with addr 21
FB93 : 8D 64      bsr  LFBF9          ;branch sub WVDECA
;GEND40
FB95 : 7A 00 2E   dec  X002E          ;decr addr 2E
FB98 : 26 C1      bne  LFB5B          ;branch Z=0 GWT4
FB9A : 96 11      ldaa  X0011         ;load A with addr 11
FB9C : 9A 12      oraa  X0012         ;OR A with addr 12
FB9E : 26 46      bne  LFBE6          ;branch Z=0 GEND1
;GEND50
FBA0 : 96 22      ldaa  X0022         ;load A with addr 22
FBA2 : 27 42      beq  LFBE6          ;branch Z=1 GEND1
FBA4 : 7A 00 23   dec  X0023          ;decr addr 23
FBA7 : 27 3D      beq  LFBE6          ;branch Z=1 GEND1
FBA9 : 9B 2F      adda  X002F         ;add A with addr 2F
;GEND60
FBAB : 97 2F      staa  X002F         ;store A in addr 2F
;GEND61
FBAD : DE 27      ldx  X0027          ;load X with addr 27
FBAF : 5F         clrb                ;clr (00) B
;GW0
FBB0 : 96 2F      ldaa  X002F         ;load A with addr 2F
FBB2 : 7D 00 22   tst  X0022          ;test addr 22
FBB5 : 2B 06      bmi  LFBBD          ;branch N=1 GW1
FBB7 : AB 00      adda  $00,x         ;add A with adr X + 00h
FBB9 : 25 08      bcs  LFBC3          ;branch C=1 GW2
FBBB : 20 0B      bra  LFBC8          ;branch always GW2A
;GW1
FBBD : AB 00      adda  $00,x         ;add A with addr X + 00h
FBBF : 27 02      beq  LFBC3          ;branch Z=1 GW3
FBC1 : 25 05      bcs  LFBC8          ;branch C=1 GW2A
;GW2
FBC3 : 5D         tstb                ;test B
FBC4 : 27 08      beq  LFBCE          ;branch Z=1 GW2B
FBC6 : 20 0F      bra  LFBD7          ;branch always GW3
;GW2A
FBC8 : 5D         tstb                ;test B
FBC9 : 26 03      bne  LFBCE          ;branch !=0 GW2B
FBCB : DF 27      stx  X0027          ;store X in addr 27
FBCD : 5C         incb                ;incr B
;GW2B
FBCE : 08         inx                 ;incr X
FBCF : 9C 29      cpx  X0029          ;compare X with addr 29
FBD1 : 26 DD      bne  LFBB0          ;branch Z=0 GW0
FBD3 : 5D         tstb                ;test B
FBD4 : 26 01      bne  LFBD7          ;branch Z=0 GGW3
FBD6 : 39         rts                 ;return subroutine
;GW3
FBD7 : DF 29      stx  X0029          ;store X in addr 29
FBD9 : 96 21      ldaa  X0021         ;load A with addr 21
FBDB : 27 06      beq  LFBE3          ;branch Z=1 GEND0
FBDD : 8D 08      bsr  LFBE7          ;branch sub WVTRAN
FBDF : 96 26      ldaa  X0026         ;load A with addr 26
FBE1 : 8D 16      bsr  LFBF9          ;branch sub WVDECA
;GEND0
FBE3 : 7E FB 57   jmp  LFB57          ;jump GWAVE
;GEND1
FBE6 : 39         rts                 ;return subroutine
;*************************************;
;Wave Transfer
;*************************************;
;WVTRAN
FBE7 : CE 00 30   ldx  #$0030         ;load X with 30h
FBEA : DF 1B      stx  X001B          ;store X in addr 1B
FBEC : DE 24      ldx  X0024          ;load X with addr 24
FBEE : E6 00      ldab  $00,x         ;load B with addr X + 00h
FBF0 : 08         inx                 ;incr X
FBF1 : BD F8 6C   jsr  LF86C          ;jump sub TRANS
FBF4 : DE 1B      ldx  X001B          ;load X with addr 1B
FBF6 : DF 2B      stx  X002B          ;store X in addr 2B
FBF8 : 39         rts                 ;return subroutine
;*************************************;
;Wave Decay
;*************************************;
;WVDECA
FBF9 : 4D         tsta                ;test B
FBFA : 27 2A      beq  LFC26          ;branch =0 WVDCX
FBFC : DE 24      ldx  X0024          ;load X with addr 24
FBFE : DF 19      stx  X0019          ;store X in addr 19
FC00 : CE 00 30   ldx  #$0030         ;load X with 30h
FC03 : 97 1E      staa  X001E         ;store A in addr 1E
;WVDLP
FC05 : DF 1B      stx  X001B          ;store X in addr 1B
FC07 : DE 19      ldx  X0019          ;load X with addr 19
FC09 : D6 1E      ldab  X001E         ;load B with addr 1E
FC0B : D7 1D      stab  X001D         ;store B in addr 1D
FC0D : E6 01      ldab  $01,x         ;load B with addr X + 01h
FC0F : BD FB 52   jsr  LFB52          ;jump sub ECHO
FC12 : 08         inx                 ;incr X
FC13 : DF 19      stx  X0019          ;store X in addr 19
FC15 : DE 1B      ldx  X001B          ;load X with addr 1B
FC17 : A6 00      ldaa  $00,x         ;load A with addr X + 00h
;WVDLP1
FC19 : 10         sba                 ;A = A - B
FC1A : 7A 00 1D   dec  X001D          ;decr addr 1D
FC1D : 26 FA      bne  LFC19          ;branch Z=0 WVDLP1
FC1F : A7 00      staa  $00,x         ;store A in addr X + 00h
FC21 : 08         inx                 ;incr X
FC22 : 9C 2B      cpx  X002B          ;comp X with addr 2B
FC24 : 26 DF      bne  LFC05          ;branch Z=0 WVDLP
;WVDCX
FC26 : 39         rts                 ;return subroutine
;*************************************;
;* KNOCKER ROUTINE
;*************************************;
;KNOCK:
FC27 : CE FF 9C   ldx  #$FF9C         ;load X with FF9Ch (#KNKTAB)
FC2A : DF 21      stx  X0021          ;store X in addr 21
;SQLP
FC2C : DE 21      ldx  X0021          ;load X with addr 21
FC2E : A6 00      ldaa  $00,x         ;load A with addr X + 00h
FC30 : 27 33      beq  LFC65          ;branch Z=1 END
FC32 : E6 01      ldab  $01,x         ;load B with addr X + 01h
FC34 : C4 F0      andb  #$F0          ;and B with F0h 
FC36 : D7 20      stab  X0020         ;store B in addr 20
FC38 : E6 01      ldab  $01,x         ;load B with addr X + 01h
FC3A : 08         inx                 ;incr X
FC3B : 08         inx                 ;incr X
FC3C : DF 21      stx  X0021          ;store X in addr 21
FC3E : 97 1F      staa  X001F         ;store A in addr 1F
FC40 : C4 0F      andb  #$0F          ;and B with 0Fh 
;LP0
FC42 : 96 20      ldaa  X0020         ;load A with addr 20
FC44 : B7 04 00   staa  X0400         ;store A in DAC output SOUND
FC47 : 96 1F      ldaa  X001F         ;load A with addr 1F
;LP1
FC49 : CE 00 05   ldx  #$0005         ;load X with 0005h
;LP11
FC4C : 09         dex                 ;decr X
FC4D : 26 FD      bne  LFC4C          ;branch Z=0 LP11
FC4F : 4A         deca                ;decr A
FC50 : 26 F7      bne  LFC49          ;branch Z=0 LP1
FC52 : 7F 04 00   clr  X0400          ;clr (00) in DAC output SOUND
FC55 : 96 1F      ldaa  X001F         ;load A with addr 1F
;LP2
FC57 : CE 00 05   ldx  #$0005         ;load X with 0005h
;LP22
FC5A : 09         dex                 ;decr X
FC5B : 26 FD      bne  LFC5A          ;branch Z=0 LP22
FC5D : 4A         deca                ;decr A
FC5E : 26 F7      bne  LFC57          ;branch Z=0 LP2
FC60 : 5A         decb                ;decr B
FC61 : 26 DF      bne  LFC42          ;branch Z=0 LP0
FC63 : 20 C7      bra  LFC2C          ;branch always SQLP
;END
FC65 : 39         rts                 ;return subroutine
;*************************************;
;IRQ
;*************************************;
FC66 : 8E 00 7F   lds  #$007F         ;load stack pointer with 007Fh 
FC69 : B6 04 02   ldaa  X0402         ;load A with 0402 PIA sound select
FC6C : C6 80      ldab  #$80          ;load B with 80h 
FC6E : F7 04 02   stab  X0402         ;store B into 0402 (PIA sound select)
FC71 : 7C 00 13   inc  X0013          ;incr addr 13
FC74 : 43         coma                ;complement 1s A
FC75 : 84 7F      anda  #$7F          ;and A with 7Fh 
FC77 : 36         psha                ;push A into stack then SP - 1
FC78 : 84 1F      anda  #$1F          ;and A with 1Fh 
FC7A : 81 14      cmpa  #$14          ;compare A with 14h 
FC7C : 27 0A      beq  LFC88          ;branch Z=1 IRQ1
FC7E : 7F 00 11   clr  X0011          ;clear addr 11
FC81 : 81 15      cmpa  #$15          ;comp A with 15h 
FC83 : 27 03      beq  LFC88          ;branch Z=1 IRQ1
FC85 : 7F 00 12   clr  X0012          ;clear addr 12
;IRQ1 - check for Speech ROMs
FC88 : 32         pula                ;SP + 1 pull stack into A
FC89 : 85 20      bita  #$20          ;bit test A with 20h 
FC8B : 27 0F      beq  LFC9C          ;branch Z=1 IRQ4
FC8D : C6 7E      ldab  #$7E          ;load B with 7Eh (7E jmp opcode)
FC8F : F1 EF FD   cmpb  XEFFD         ;comp B with EFFDh (check Speech ROM IC4)
FC92 : 27 05      beq  LFC99          ;branch Z=1 IRQ3 (NO)
FC94 : F1 DF FD   cmpb  XDFFD         ;comp B with DFFDh (check Speech ROM IC6)
FC97 : 26 03      bne  LFC9C          ;branch Z=0 IRQ4 (NO)
;IRQ2
FC99 : BD EF FD   jsr  LEFFD          ;jump sub EFFD (TALK)
;IRQ3
FC9C : 0E         cli                 ;clear interrupt
FC9D : 84 1F      anda  #$1F          ;and A with 1Fh 
FC9F : 27 27      beq  LFCC8          ;branch Z=1 IRQ6
FCA1 : 4A         deca                ;decr A
FCA2 : 81 0D      cmpa  #$0D          ;comp A with 0Dh 
FCA4 : 22 08      bhi  LFCAE          ;branch C+Z=0 IRQ4
FCA6 : BD FA F0   jsr  LFAF0          ;jump sub GWLD
FCA9 : BD FB 57   jsr  LFB57          ;jump sub GWAVE
FCAC : 20 1A      bra  LFCC8          ;branch always IRQ6
;IRQ4
FCAE : 81 19      cmpa  #$19          ;comp A with 19h 
FCB0 : 22 0E      bhi  LFCC0          ;branch C+Z=0 IRQ5
FCB2 : 80 0E      suba  #$0E          ;A = A - 0Eh 
FCB4 : 48         asla                ;arith shift left A (bit0=0)
FCB5 : CE FD 57   ldx  #$FD57         ;load X with FD57h (JMPTBL)
FCB8 : 8D 25      bsr  LFCDF          ;branch sub ADDX
FCBA : EE 00      ldx  $00,x          ;load X with addr X + 00h
FCBC : AD 00      jsr  $00,x          ;jump sub addr X + 00h
FCBE : 20 08      bra  LFCC8          ;branch always IRQ6
;IRQ5
FCC0 : 80 1A      suba  #$1A          ;A = A - 1Ah 
FCC2 : BD F8 5A   jsr  LF85A          ;jump sub VARILD
FCC5 : BD F8 7E   jsr  LF87E          ;jump sub VARI
;IRQ6
FCC8 : 96 0F      ldaa  X000F         ;load A with addr 0F
FCCA : 9A 10      oraa  X0010         ;or A with addr 10
;IRQ7
FCCC : 27 FE      beq  LFCCC          ;branch Z=1 here IRQ7
;
FCCE : 4F         clra                ;clear A
FCCF : 97 11      staa  X0011         ;store A in addr 11
FCD1 : 97 12      staa  X0012         ;store A in addr 12
FCD3 : 96 0F      ldaa  X000F         ;load A with addr 0F
FCD5 : 27 05      beq  LFCDC          ;branch Z=1 IRQ8
FCD7 : 2B 03      bmi  LFCDC          ;branch N=1 IRQ8
FCD9 : 7E FA 90   jmp  LFA90          ;jump BG1
;IRQ8
FCDC : 7E FA B5   jmp  LFAB5          ;jump BG2
;*************************************;
;ADDX
;*************************************;
FCDF : DF 19      stx  X0019          ;store X in addr 19
FCE1 : 9B 1A      adda  X001A         ;add A with addr 1A
FCE3 : 97 1A      staa  X001A         ;store A in addr 1A
FCE5 : 96 19      ldaa  X0019         ;load A with addr 19
FCE7 : 89 00      adca  #$00          ;A = C + A + 00h
FCE9 : 97 19      staa  X0019         ;store A in addr 19
FCEB : DE 19      ldx  X0019          ;load X with addr 19
FCED : 39         rts                 ;return subroutine
;*************************************;
;Tilt sound, buzz saw down
;*************************************;
FCEE : CE 00 E0   ldx  #$00E0         ;load X with 00E0h
;TILT1
FCF1 : 86 20      ldaa  #$20          ;load A with 20h 
FCF3 : 8D EA      bsr  LFCDF          ;branch sub ADDX
;TILT2
FCF5 : 09         dex                 ;decr X
FCF6 : 26 FD      bne  LFCF5          ;branch Z=0 TILT2
FCF8 : 7F 04 00   clr  X0400          ;clear in DAC output SOUND
;TILT3
FCFB : 5A         decb                ;decr B
FCFC : 26 FD      bne  LFCFB          ;branch Z=0 TILT3
FCFE : 73 04 00   com  X0400          ;complement 1s in DAC output SOUND
FD01 : DE 19      ldx  X0019          ;load X with addr 19
FD03 : 8C 10 00   cpx  #$1000         ;compare X with 1000h
FD06 : 26 E9      bne  LFCF1          ;branch Z=0 TILT1
FD08 : 39         rts                 ;return subroutine
;*************************************;
;NMI
;*************************************;
FD09 : 0F          sei                ;set interrupt mask
FD0A : 8E 00 7F   lds  #$007F         ;load SP with 007Fh (ENDRAM)
FD0D : CE FF FF   ldx  #$FFFF         ;load X with FFFFh (END ROM)
FD10 : 5F         clrb                ;clear B
;NMI1
FD11 : E9 00      adcb  $00,x         ;add C+B+ addr X+00h
FD13 : 09         dex                 ;decr X
FD14 : 8C F8 00   cpx  #$F800         ;comp X with F800h (ROM)
FD17 : 26 F8      bne  LFD11          ;branch Z=0 NMI1
FD19 : E1 00      cmpb  $00,x         ;comp B with addr X + 00h
FD1B : 27 01      beq  LFD1E          ;branch Z=1 NMI2
FD1D : 3E         wai                 ;wait for interrupt, PC+1
;NMI2
FD1E : 7F 04 02   clr  X0402          ;clear addr 0402 (PIA sound select)
FD21 : CE 2E E0   ldx  #$2EE0         ;load X with 2EE0h 
;NMI3
FD24 : 09         dex                 ;decr X
FD25 : 26 FD      bne  LFD24          ;branch Z=0 NMI3
FD27 : 86 80      ldaa  #$80          ;load A with 80h 
FD29 : B7 04 02   staa  X0402         ;store A in addr 0402 (PIA sound select)
FD2C : 86 0A      ldaa  #$0A          ;load A with 0Ah 
FD2E : BD FA F0   jsr  LFAF0          ;jump sub GWLD
FD31 : BD FB 57   jsr  LFB57          ;jump sub GWAVE
FD34 : 86 0B      ldaa  #$0B          ;load A with 0Bh 
FD36 : BD FA F0   jsr  LFAF0          ;jump sub GWLD
FD39 : BD FB 57   jsr  LFB57          ;jump sub GWAVE
FD3C : 4F         clra                ;clear A
FD3D : BD F8 5A   jsr  LF85A          ;jump sub VARILD
FD40 : BD F8 7E   jsr  LF87E          ;jump sub VARI
;check for Speech ROM
FD43 : CE EF FA   ldx  #$EFFA         ;load X with EFFAh (Speech ROM addr)
FD46 : C6 7E      ldab  #$7E          ;load B with 7Eh (look for 7E jmp op code)
FD48 : E1 00      cmpb  $00,x         ;compare B with X+00h
FD4A : 27 07      beq  LFD53          ;branch Z=1 NMI3 
FD4C : CE DF FA   ldx  #$DFFA         ;load X with DFFAh (TALKD) - Speech ROM 6
FD4F : E1 00      cmpb  $00,x         ;comp B with addr X + 00h
FD51 : 26 B6      bne  LFD09          ;branch Z=0 NMI
;NMI3
FD53 : AD 00      jsr  $00,x          ;jump sub addr X+00h (TALKD)
FD55 : 20 B2      bra  LFD09          ;branch always NMI
;*************************************;
; Jump table
;*************************************;
;JMPTBL
FD57 : F8 D5                          ;PARAM2 
FD59 : FA 02                          ;WHIST 
FD5B : FA 7D                          ;BG1INC
FD5D : FA A2                          ;BG2INC
FD5F : FA 76                          ;BGEND 
FD61 : FA C7                          ;GWCAL1
FD63 : FA DA                          ;GWCAL2
FD65 : FC EE                          ;TILT
FD67 : F9 76                          ;NSTLD2
FD69 : F9 71                          ;NSTLD1
FD6B : F9 32                          ;LITEN
FD6D : FC 27                          ;KNOCK
;*************************************;
;VVECT    EQU *
;*************************************;
;called from PARAM1 
FD6F : 40 01 00 10 E1 00 80 FF FF     ;SAW
FD78 : 28 01 00 08 81 02 00 FF FF     ;FOSHIT
FD81 : 00 FF 08 FF 68 04 80 00 FF     ;CSCALE
FD8A : 36 21 09 06 EF 03 C0 00 FF     ; ? 
FD93 : 0E E7 35 33 79 03 80 F2 FF     ; ?
;*************************************;
;Wave table, 1st byte wave length
;*************************************;
;GWVTAB
FD9C : 08                             ;GS2
FD9D : 7F D9 FF D9 7F 24 00 24        ;
; 
FDA5 : 08                             ;GSQ2
FDA6 : FF FF FF FF 00 00 00 00        ;
;
FDAE : 08                             ;GSSQ2
FDAF : 00 40 80 00 FF 00 80 40        ;
;
FDB7 : 10                             ;GS1
FDB8 : 7F B0 D9 F5 FF F5 D9 B0        ;
FDC0 : 7F 4E 24 09 00 09 24 4E        ;
;
FDC8 : 10                             ;
FDC9 : 00 FF FF FF FA D0 C0 A0        ;
FDD1 : 90 80 70 00 00 00 30 C0        ;
;
FDD9 : 10                             ;GS1234
FDDA : 76 FF B8 D0 9D E6 6A 82        ;
FDE2 : 76 EA 81 86 4E 9C 32 63        ;
;
FDEA : 10                             ;GSQ12
FDEB : FF FF FF FF FF FF FF FF        ;
FDF3 : 00 00 00 00 00 00 00 00        ;
;
FDFB : 10                             ;GSQ22
FDFC : FF FF FF FF 00 00 00 00        ;
FE04 : FF FF FF FF 00 00 00 00        ;
;
FE0C : 10                             ;MW1
FE0D : 00 F4 00 E8 00 DC 00 E2        ;
FE15 : 00 DC 00 E8 00 F4 00 00        ;
;
FE1D : 48                             ;xx72
FE1E : 8A 95 A0 AB E7 E7 E7 E7        ;
FE26 : DA E1 E8 EE 25 25 25 25        ;
FE2E : FE FF FE FD 2D 2D 2D 2D        ;
FE36 : E8 E1 DA D1 FA FA FA FA        ;
FE3E : A0 95 8A 7F A7 A7 A7 A7        ;
FE46 : 4A 40 37 2E 57 57 57 57        ;
FE4E : 0C 08 04 02 33 33 33 33        ;
FE56 : 04 08 0C 11 49 49 49 49        ;
FE5E : 37 40 4A 54 91 91 91 91        ;
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
FE66 : F6 54 03 00 02 06 23           ;
FE6D : 14 10 00 01 00 01 6A           ;
FE74 : 99 23 0F 00 00 07 A8           ;
FE7B : 61 31 00 00 00 50 20           ;
FE82 : 31 12 11 FF 25 13 3A           ;
FE89 : 17 14 00 00 00 10 20           ;
FE90 : 11 08 02 00 00 20 27           ;
FE97 : 81 27 00 00 00 16 60           ;
FE9E : 81 27 00 00 00 16 15           ;
FEA5 : 41 03 D0 00 00 27 91           ;
FEAC : F2 29 80 00 00 0D 1B           ;
FEB3 : 81 27 00 00 00 16 54           ;
FEBA : 24 21 03 FF 10 09 39           ;
FEC1 : 11 17 00 01 20 09 14           ;
FEC8 : F2 F6 00 FF 01 15 39           ;
FECF : 93 35 F0 FF 01 07 15           ;
FED6 : 13 09 11 FF 00 05 31           ;
FEDD : 18 03 00 FF 00 16 54           ;
;*************************************;
;GWAVE FREQ PATTERN TABLE
;*************************************;
;GFRTAB 
;Bonus Sound
FEE4 : A0 98 90 88 80 78 70 68        ;BONSND
FEEC : 60 58 50 44 40                 ;
;Hundred Point Sound
FEF1 : 01 01 02 02 04 04 08 08        ;HBTSND
FEF9 : 10 10 30 60 C0 E0              ;
;Spinner Sound
FEFF : 01 01 02 02 03 04 05 06        ;SPNSND
FF07 : 07 08 09 0A 0C                 ;
;
FF0C : 08 80 10 78 18 70 20 60        ;UNKN1
FF14 : 28 58 30 50 40 48              ;
;
FF1A : 04 05 06 07 08 0A 0C 0E        ;UNKN2
FF22 : 10 11 12 13 14 15 16 17        ;
FF2A : 18 19 1A 1B 1C                 ;
;;Turbine Start Up
FF2F : 80 7C 78 74 70 74 78 7C 80     ;TRBPAT
;Heartbeat Distorto 
FF38 : 01 01 02 02 04 04 08 08        ;HBDSND
FF40 : 10 20 28 30 38 40 48 50        ;
FF48 : 60 70 80 A0 B0 C0              ;
;*SWPAT - SWEEP PATTERN
;BigBen Sounds
FF4E : 08 40 08 40 08 40 08 40 08 40  ;BBSND
FF58 : 08 40 08 40 08 40 08 40 08 40  ;
;Heartbeat Echo
FF62 : 01 02 04 08 09 0A 0B 0C        ;HBESND
FF6A : 0E 0F 10 12 14 16              ;
;Spinner Sound "Drip"
FF70 : 40                             ;SPNR
;Cool Downer
FF71 : 10 08 01                       ;COOLDN 
;
FF74 : 92                             ;UNKN3
;Start Distorto Sound
FF75 : 01 01 01 01 02 02 03 03        ;STDSND
FF7D : 04 04 05 06 08 0A 0C 10        ;
FF85 : 14 18 20 30 40 50 40 30        ;
FF8D : 20 10 0C 0A 08 07 06 05        ;
FF95 : 04 03 02 02 01 01 01           ;
;*************************************;
;* Knocker Pattern
;*************************************;
;KNKTAB
FF9C : 01FC 02FC 03F8 04F8 06F8 08F4  ;
FFA8 : 0CF4 10F4 20F2 40F1 60F1 80F1  ;
FFB4 : A0F1 C0F1 00 00                ;
;*************************************;
; zero byte padding
;*************************************;
FFBA : 00 00 00 00 00 00 
FFC0 : 00 00 00 00 00 00 00 00 
FFC8 : 00 00 00 00 00 00 00 00 
FFD0 : 00 00 00 00 00 00 00 00 
FFD8 : 00 00 00 00 00 00 00 00 
FFE0 : 00 00 00 00 00 00 00 00 
FFE8 : 00 00 00 00 00 00 00 00 
FFF0 : 00 00 00 
;*************************************;
;jump and FDBs for non existent Speech ROM
;*************************************;
FFF3 : 7E FC DF    jmp  LFCDF         ;jump ADDX
;
FFF6 : DFDA                           ;
;*************************************;
;Motorola vector table
;*************************************;
FFF8 : FC 66                          ;IRQ 
FFFA : F8 01                          ;RESET SWI (software) 
FFFC : FD 09                          ;NMI 
FFFE : F8 01                          ;RESET (hardware) 

;--------------------------------------------------------------

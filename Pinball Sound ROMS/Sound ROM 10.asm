        ;
        ;  Disassembled by:
        ;    DASMx object code disassembler
        ;    (c) Copyright 1996-2003   Conquest Consultants
        ;    Version 1.40 (Oct 18 2003)
        ;
        ;  File:    varkon.716
        ;  Size:    2048 bytes
        ;  Checksum:  A694
        ;  CRC-32:    D13DB2BB
        ;  Date:    Tue Mar 16 17:02:20 2021
        ;
        ;  CPU:    Motorola 6800 (6800/6802/6808 family)
        ;
        ;Pinball Sound ROM 10, Varkon, Sept 1982, 90 made
        ;
        ;Vertical arcade style cabinet, 2 separate playfields viewed via mirror
        ;
        ;complex IRQ, multiple GWAVE param loaders 
        ;
        ; UPDATED:: 18 May 2021
        ; 
        ;
org  $F800
        ;
F800 : 4A                             ;checksum byte
;*************************************;
;RESET Power On
;*************************************;
;RESET
F801 : 0F          sei                ;set interrupt mask
F802 : 8E 00 7F    lds  #$007F        ;load stack pointer with 007Fh (ENDRAM)
F805 : CE 00 7F    ldx  #$007F        ;load X with 007Fh (ENDRAM)
;RSTLP
F808 : 6F 00       clr  $00,x         ;clear X+00h
F80A : 09          dex                ;decr X
F80B : 26 FB       bne  LF808         ;branch !=0 RSTLP
F80D : CE 04 00    ldx  #$0400        ;load X with 0400h (PIA addr)
F810 : 6F 01       clr  $01,x         ;clear X+01h (0401) PIA CR port A
F812 : 6F 03       clr  $03,x         ;clear X+03h (0403) PIA CR port B
F814 : 86 FF       ldaa  #$FF         ;load A with FFh  
F816 : A7 00       staa  $00,x        ;store A in addr X+00h (0400) PIA port A out (DAC sound)
F818 : C6 80       ldab  #$80         ;load B with 80h  
F81A : E7 02       stab  $02,x        ;store B in addr X+02h (0402) PIA port B in (sound select)
F81C : 86 37       ldaa  #$37         ;load A with 37h 
F81E : A7 03       staa  $03,x        ;store A in addr X+03h (0403) PIA CR port B
F820 : 86 3C       ldaa  #$3C         ;load A with 3Ch 
F822 : A7 01       staa  $01,x        ;store A in addr X+01h (0401) PIA CR port A
F824 : 97 00       staa  $00          ;store A in addr 00
F826 : E7 02       stab  $02,x        ;store B in addr X + 02h (0402) PIA port B in 
F828 : 0E          cli                ;clear interrupt
;STDBY1:
F829 : 20 FE       bra  LF829         ;branch always to STDBY1
;WAIT:
F82B : 3E          wai                ;wait for interrupt, PC+1
;*************************************;
;Diagnostics Routine
;*************************************;
;NMI
F82C : 0F          sei                ;set interrupt mask
F82D : 8E 00 7F    lds  #$007F        ;load SP with 007Fh 
F830 : CE FF FF    ldx  #$FFFF        ;load X with FFFFh 
F833 : 4F          clra               ;clear A
;NMI2
F834 : AB 00       adda  $00,x        ;add A with X + 00h
F836 : 09          dex                ;decr X
F837 : 8C F8 00    cpx  #$F800        ;comp X with F800h
F83A : 26 F8       bne  LF834         ;branch !=0 NMI2
F83C : A1 00       cmpa  $00,x        ;comp A with X + 00h
F83E : 26 EB       bne  LF82B         ;branch !=0 WAIT
F840 : 8D 07       bsr  LF849         ;branch sub GWVJMP 
F842 : 8D 05       bsr  LF849         ;branch sub GWVJMP
F844 : BD FB 23    jsr  LFB23         ;jump sub LITEN
F847 : 20 E3       bra  LF82C         ;branch always NMI
;*************************************;
;GWave Jump
;*************************************;
;GWVJMP
F849 : 86 00       ldaa  #$00         ;load A with 00h 
F84B : 7E FC 08    jmp  LFC08         ;jump GWCL4X
;*************************************;
;Interrupt Request Routine
;*************************************;
;IRQ
F84E : 8E 00 7F    lds  #$007F        ;load SP with 007Fh 
F851 : B6 04 02    ldaa  $0402        ;load A with 0402 PIA sound select
F854 : C6 80       ldab  #$80         ;load B with 80h 
F856 : F7 04 02    stab  $0402        ;store B into 0402 (PIA sound select)
F859 : 43          coma               ;complement 1s A 
F85A : 84 1F       anda  #$1F         ;and A with 1Fh 
F85C : 27 48       beq  LF8A6         ;branch Z=1 IRQ8
F85E : 4A          deca               ;decr A
F85F : 5F          clrb               ;clear B
F860 : 81 16       cmpa  #$16         ;comp A with 16h 
F862 : 26 02       bne  LF866         ;branch Z=0 IRQ1
F864 : D7 0A       stab  $0A          ;store B in addr 0A
;IRQ1
F866 : 81 05       cmpa  #$05         ;compare A with 05h 
F868 : 27 06       beq  LF870         ;branch Z=1 IRQ2
F86A : D7 08       stab  $08          ;store B in addr 08
F86C : D7 09       stab  $09          ;store B in addr 09
F86E : 20 02       bra  LF872         ;branch always IRQ3
;IRQ2
F870 : D7 0A       stab  $0A          ;store B in addr 0A
;IRQ3
F872 : 81 1B       cmpa  #$1B         ;compare A with 1Bh 
F874 : 2D 02       blt  LF878         ;branch N(+)V=1 IRQ4
F876 : D7 07       stab  $07          ;store B (00) in addr 07
;IRQ4
F878 : 81 0B       cmpa  #$0B         ;comp A with 0Bh 
F87A : 2F 02       ble  LF87E         ;branch Z+(N(+)V)=1 IRQ5
F87C : D7 03       stab  $03          ;store B in addr 03
;IRQ5
F87E : 9B 03       adda  $03          ;add A with addr 03
F880 : 0E          cli                ;clear interrupt I=0
F881 : CE FC 2A    ldx  #$FC2A        ;load X with FC2Ah (IRQDAT)
F884 : BD FA F9    jsr  LFAF9         ;jump sub ADDX
F887 : A6 00       ldaa  $00,x        ;load A with X + 00h 
F889 : 16          tab                ;trans A to B
F88A : 84 3F       anda  #$3F         ;and A with 3Fh 
F88C : 58          aslb               ;arith shift left B 
F88D : 25 14       bcs  LF8A3         ;branch C=1 IRQ7
F88F : 2B 0D       bmi  LF89E         ;branch N=1 IRQ6
F891 : 48          asla               ;arith shift left A
F892 : CE FC 56    ldx  #$FC56        ;load X with FC56h (JMPTBL)
F895 : BD FA F9    jsr  LFAF9         ;jump sub ADDX
F898 : EE 00       ldx  $00,x         ;load X with X + 00h
F89A : AD 00       jsr  $00,x         ;jump sub X + 00h
F89C : 20 08       bra  LF8A6         ;branch always IRQ8
;IRQ6
F89E : BD F9 03    jsr  LF903         ;jump sub VARJMP
F8A1 : 20 03       bra  LF8A6         ;branch always IRQ1
;IRQ7
F8A3 : BD FC 08    jsr  LFC08         ;jump sub GWCL4X
;IRQ8
F8A6 : 0E          cli                ;clear interrupt
F8A7 : 96 07       ldaa  $07          ;load A with addr 07
;IRQ9
F8A9 : 27 FE       beq  LF8A9         ;branch Z=1 IRQ9
F8AB : 96 03       ldaa  $03          ;load A with addr 03
F8AD : 26 38       bne  LF8E7         ;branch Z=0 IRQ12
F8AF : 8D 20       bsr  LF8D1         ;branch sub IRQ11
F8B1 : 8D 1E       bsr  LF8D1         ;branch sub IRQ11
F8B3 : 8D 1C       bsr  LF8D1         ;branch sub IRQ11
F8B5 : 96 04       ldaa  $04          ;load A with addr 04
F8B7 : 81 0E       cmpa  #$0E         ;comp A with 0Eh 
F8B9 : 2E 0E       bgt  LF8C9         ;branch Z+(N(+)V)=0 IRQ9
F8BB : 96 02       ldaa  $02          ;load A with addr 02
F8BD : 81 2B       cmpa  #$2B         ;comp A with 2Bh 
F8BF : 2E 02       bgt  LF8C3         ;branch Z+(N(+)V)=0 IRQ8
F8C1 : 86 36       ldaa  #$36         ;load A with 36h 
;IRQ10
F8C3 : 4A          deca               ;decr A
F8C4 : 97 02       staa  $02          ;store A in addr 02
F8C6 : 8B E3       adda  #$E3         ;add A with E3h 
F8C8 : 4C          inca               ;incr A
;IRQ11
F8C9 : 8B FF       adda  #$FF         ;add A with FFh 
F8CB : 97 04       staa  $04          ;store A in addr 04
;IRQ12
F8CD : 8D 02       bsr  LF8D1         ;branch sub IRQ11
F8CF : 20 FC       bra  LF8CD         ;branch always IRQ10
;IRQ13
F8D1 : 86 06       ldaa  #$06         ;load A with 06h 
F8D3 : BD F9 B9    jsr  LF9B9         ;jump sub GWPRE
F8D6 : CE 00 02    ldx  #$0002        ;load X with 02h
F8D9 : DF 1C       stx  $1C           ;store X in addr 1C
F8DB : 08          inx                ;incr X
F8DC : DF 1E       stx  $1E           ;store X in addr 1E
F8DE : 96 04       ldaa  $04          ;load A with addr 04
F8E0 : 97 18       staa  $18          ;store A in addr 18
F8E2 : 80 24       suba  #$24         ;sub A with 24h 
F8E4 : 7E FA 7C    jmp  LFA7C         ;jump GEND60
;IRQ14
F8E7 : 86 07       ldaa  #$07         ;load A with 07h 
F8E9 : BD FC 08    jsr  LFC08         ;jump sub GWCL4X
F8EC : 20 F9       bra  LF8E7         ;branch always IRQ12
;*************************************;
;Vari Loader
;*************************************;
;VARILD
F8EE : 16          tab                ;trans A to B
F8EF : 48          asla               ;arith shift left A
F8F0 : 48          asla               ;arith shift left A
F8F1 : 48          asla               ;arith shift left A 
F8F2 : 1B          aba                ;add A and B into A 
F8F3 : CE 00 14    ldx  #$0014        ;load X with 0014h
F8F6 : DF 10       stx  X0010         ;store X in addr 10
F8F8 : CE FC 6C    ldx  #$FC6C        ;load X with FC6Ch (VVECT)
F8FB : BD FA F9    jsr  LFAF9         ;jump sub ADDX
F8FE : C6 09       ldab  #$09         ;load B with 09h 
F900 : 7E F9 52    jmp  LF952         ;jump TRANS
;*************************************;
;Variable Duty Cycle Square Wave Routine
;*************************************;
;VARJMP - vari calling jump
F903 : 8D E9      bsr  LF8EE          ;branch sub VARILD
;VARI
F905 : 96 1C      ldaa  $1C           ;load A with addr 1C
F907 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
;VAR0
F90A : 96 14      ldaa  $14           ;load A with addr 14
F90C : 97 1D      staa  $1D           ;store A in addr 1D
F90E : 96 15      ldaa  $15           ;load A with addr 15
F910 : 97 1E      staa  $1E           ;store A in addr 1E
;V0
F912 : DE 19      ldx  $19            ;load X with addr 19
;V0LP
F914 : 96 1D      ldaa  $1D           ;load A with addr 1D
F916 : 73 04 00   com  $0400          ;complement 1s in DAC SOUND
;V1
F919 : 09         dex                 ;decr X
F91A : 27 10      beq  LF92C          ;branch Z=1 VSWEEP
F91C : 4A         deca                ;decr A
F91D : 26 FA      bne  LF919          ;branch Z=0 V1
F91F : 73 04 00   com  $0400          ;complement 1s DAC SOUND
F922 : 96 1E      ldaa $1E            ;load A with addr 1E
;V2
F924 : 09         dex                 ;decr X
F925 : 27 05      beq  LF92C          ;branch Z=1 VSWEEP
F927 : 4A         deca                ;decr A
F928 : 26 FA      bne  LF924          ;branch Z=0 V2
F92A : 20 E8      bra  LF914          ;branch always V0LP
;VSWEEP
F92C : B6 04 00   ldaa  $0400         ;load A with DAC 0400
F92F : 2B 01      bmi  LF932          ;branch N=1 VS1
F931 : 43         coma                ;complement 1s A
;VS1
F932 : 8B 00      adda  #$00          ;add A with 00h 
F934 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F937 : 96 1D      ldaa  $1D           ;load A with addr 1D
F939 : 9B 16      adda  $16           ;add A with addr 16
F93B : 97 1D      staa  $1D           ;store A in addr 1D
F93D : 96 1E      ldaa  $1E           ;load A with addr 1E
F93F : 9B 17      adda  $17           ;add A with addr 17
F941 : 97 1E      staa  $1E           ;store A in addr 1E
F943 : 91 18      cmpa  $18           ;comp A with addr 18
F945 : 26 CB      bne  LF912          ;branch Z=0 V0
F947 : 96 1B      ldaa  $1B           ;load A with addr 1B
F949 : 27 06      beq  LF951          ;branch Z=1 VARX
F94B : 9B 14      adda  $14           ;add A with addr 14
F94D : 97 14      staa  $14           ;store A in addr 14
F94F : 26 B9      bne  LF90A          ;branch Z=0 VAR0
;VARX
F951 : 39         rts                 ;return subroutine
;*************************************;
;Parameter Transfer
;*************************************;
;TRANS
F952 : 36         psha                ;push A into stack then SP - 1
;TRANS1
F953 : A6 00      ldaa  $00,x         ;load A with addr X + 00h
F955 : DF 0E      stx  $0E            ;store X in addr 0E
F957 : DE 10      ldx  $10            ;load X with addr 10
F959 : A7 00      staa  $00,x         ;store A in addr X + 00h
F95B : 08         inx                 ;incr X
F95C : DF 10      stx  $10            ;store X in addr 10
F95E : DE 0E      ldx  $0E            ;load X with addr 0E
F960 : 08         inx                 ;incr X
F961 : 5A         decb                ;decr B
F962 : 26 EF      bne  LF953          ;branch Z=0 TRANS1
F964 : 32         pula                ;SP + 1 pull stack into A
F965 : 39         rts                 ;return subroutine
;*************************************;
;set background params and wait (assumed)
;*************************************;
;BGSET
F966 : 86 01      ldaa  #$01          ;load A with 01h 
F968 : 97 07      staa  $07           ;store A in addr 07
F96A : 86 23      ldaa  #$23          ;load A with 23h 
F96C : 97 04      staa  $04           ;store A in addr 04
F96E : 86 40      ldaa  #$40          ;load A with 40h 
F970 : 97 02      staa  $02           ;store A in addr 02
;BGSETX
F972 : 20 FE      bra  LF972          ;branch always BGSETX
;*************************************;
;GWave Calling routine #1
;*************************************;
;GWCAL1
F974 : 7A 00 08   dec  $08            ;decr addr 08
F977 : 86 15      ldaa  #$15          ;load A with 15h 
F979 : 8D 3E      bsr  LF9B9          ;branch sub GWPRE
F97B : 96 08      ldaa  $08           ;load A with addr 08
F97D : BD FA 7C   jsr  LFA7C          ;jump sub GEND60
;GWCALX
F980 : 20 FE      bra  LF980          ;branch always GWCALX
;*************************************;
;GWave Calling Routine #2
;*************************************;
;GWCAL2
F982 : 96 09      ldaa  $09           ;load A with addr 09
F984 : 26 08      bne  LF98E          ;branch Z=0 GWCL21
F986 : 7C 00 09   inc  $0009          ;incr addr 09
F989 : 86 14      ldaa  #$14          ;load A with 14h
F98B : 7E FC 08   jmp  LFC08          ;jump GWCL4X
;GWCL21
F98E : 4A         deca                ;decr A
F98F : 26 07      bne  LF998          ;branch Z=0 GWCL2X
F991 : 86 02      ldaa  #$02          ;load A with 02h
F993 : 97 09      staa  $09           ;store A in addr 09
F995 : 7E FA 71   jmp  LFA71          ;jump GEND50
;GWCL2X
F998 : 97 09      staa  $09           ;store A in addr 09
F99A : 7E FA 23   jmp  LFA23          ;jump GWAVE
;*************************************;
;GWave Alternate Routine
;*************************************;
;GWALT
F99D : 7F 00 09   clr  $0009          ;clear addr 09
F9A0 : 86 FC      ldaa  #$FC          ;load A with FCh 
F9A2 : 9B 24      adda  $24           ;add A with addr 24
F9A4 : 97 24      staa  $24           ;store A in addr 24
F9A6 : 86 01      ldaa  #$01          ;load A with 01h 
F9A8 : 97 18      staa  $18           ;store A in addr 18
F9AA : 86 10      ldaa  #$10          ;load A with 10h 
F9AC : 97 14      staa  $14           ;store A in addr 14
F9AE : 86 02      ldaa  #$02          ;load A with 02h 
F9B0 : 97 15      staa  $15           ;store A in addr 15
F9B2 : 86 01      ldaa  #$01          ;load A with 01h 
F9B4 : 97 16      staa  $16           ;store A in addr 16
F9B6 : 7E FA 7E   jmp  LFA7E          ;jump GEND61
;*************************************;
;GWAVE Preload routine
;*************************************;
;GWPRE
F9B9 : CE FD D4   ldx  #$FDD4         ;load X with FDD4h
F9BC : 48         asla                ;arith shift left A (x2)
F9BD : 48         asla                ;arith shift left A (x4)
F9BE : 48         asla                ;arith shift left A (x8)
F9BF : 24 03      bcc  LF9C4          ;branch if C=0 GWPRE1
F9C1 : CE FE D4   ldx  #$FED4         ;load X with FED4h (GFRTAB)
;GWPRE1
F9C4 : BD FA F9   jsr  LFAF9          ;jump sub ADDX
F9C7 : A6 00      ldaa  $00,x         ;load A with X+00h
;*************************************;
;GWave Loader
;*************************************;
;GWLD
F9C9 : 16         tab                 ;trans A to B
F9CA : 84 0F      anda  #$0F          ;and A with 0Fh 
F9CC : 97 15      staa  $15           ;store A in addr 15
F9CE : 54         lsrb                ;logic shift right B 
F9CF : 54         lsrb                ;logic shift right B 
F9D0 : 54         lsrb                ;logic shift right B 
F9D1 : 54         lsrb                ;logic shift right B 
F9D2 : D7 14      stab  $14           ;store B in addr 14
F9D4 : A6 01      ldaa  $01,x         ;load A with addr X + 01h
F9D6 : 16         tab                 ;trans A to B
F9D7 : 54         lsrb                ;logic shift right B
F9D8 : 54         lsrb                ;logic shift right B
F9D9 : 54         lsrb                ;logic shift right B
F9DA : 54         lsrb                ;logic shift right B 
F9DB : D7 16      stab  $16           ;store B in addr 16
F9DD : 84 0F      anda  #$0F          ;and A with 0Fh
F9DF : 97 12      staa  $12           ;store A in addr 12
F9E1 : DF 0C      stx  $0C            ;store X in addr 0C
F9E3 : CE FC 90   ldx  #$FC90         ;load X with FC90h (GWVTAB)
;GWLD2
F9E6 : 7A 00 12   dec  $0012          ;decr addr 12
F9E9 : 2B 08      bmi  LF9F3          ;branch N=1 GWLD3
F9EB : A6 00      ldaa  $00,x         ;load A with addr X + 00h
F9ED : 4C         inca                ;incr A
F9EE : BD FA F9   jsr  LFAF9          ;jump sub ADDX
F9F1 : 20 F3      bra  LF9E6          ;branch always GWLD2
;GWLD3
F9F3 : DF 19      stx  $19            ;store X in addr 19
F9F5 : BD FA B8   jsr  LFAB8          ;jump sub WVTRAN
F9F8 : DE 0C      ldx  $0C            ;load X with addr 0C
F9FA : A6 02      ldaa  $02,x         ;load A with addr X + 02h
F9FC : 97 1B      staa  $1B           ;store A in 1B
F9FE : BD FA CA   jsr  LFACA          ;jump sub WVDECA
FA01 : DE 0C      ldx  $0C            ;load X with addr 0C
FA03 : A6 03      ldaa  $03,x         ;load A with addr X + 03h
FA05 : 97 17      staa  $17           ;store A in addr 17
FA07 : A6 04      ldaa  $04,x         ;load A with addr X + 04h
FA09 : 97 18      staa  $18           ;store A in addr 18
FA0B : A6 05      ldaa  $05,x         ;load A with addr X + 05h
FA0D : 97 24      staa  $24           ;store A in addr 24
FA0F : A6 06      ldaa  $06,x         ;load A with addr X + 06h
FA11 : 16         tab                 ;trans A to B
FA12 : A6 07      ldaa  $07,x         ;load A with addr X + 07h
FA14 : CE FE CC   ldx  #$FECC         ;load X with FECCh (#GFRTAB)
FA17 : BD FA F9   jsr  LFAF9          ;jump sub ADDX
FA1A : 17         tba                 ;trans B to A
FA1B : DF 1C      stx  $1C            ;store X in addr 1C
FA1D : BD FA F9   jsr  LFAF9          ;jump sub ADDX
FA20 : DF 1E      stx  $1E            ;store X in addr 1E
FA22 : 39         rts                 ;return subroutine
;*************************************;
;GWAVE routine
;*************************************;
;ACCA=Freq Pattern Length, X=Freq Pattern Addr
;GWAVE - gwave init
FA23 : 96 24      ldaa  $24           ;load A with addr 24
FA25 : 26 55      bne  LFA7C          ;branch Z=0 GEND60
;GWAVE2
FA27 : 96 14      ldaa  $14           ;load A with addr 14
FA29 : 97 23      staa  $23           ;store A in addr 23
;GWT4
FA2B : DE 1C      ldx  $1C            ;load X with addr 1C
FA2D : DF 0E      stx  $0E            ;store X in addr 0E
;GPLAY
FA2F : DE 0E      ldx  $0E            ;load X with addr 0E
FA31 : A6 00      ldaa  $00,x         ;load A with addr X + 00h
FA33 : 9B 24      adda  $24           ;add A with addr 24
FA35 : 97 22      staa  $22           ;store A in addr 22
FA37 : 9C 1E      cpx  $1E            ;comp X with addr 1E
FA39 : 27 26      beq  LFA61          ;branch Z=1 GEND
FA3B : D6 15      ldab  $15           ;load B with addr 15
FA3D : 08         inx                 ;incr X
FA3E : DF 0E      stx  $0E            ;store X in addr 0E
;GOUT
FA40 : CE 00 25   ldx  #$0025         ;load X with 0025h
;GOUTLP
FA43 : 96 22      ldaa  $22           ;load A with addr 22
;GPRLP
FA45 : 4A         deca                ;decr A
FA46 : 26 FD      bne  LFA45          ;branch Z=0 GPRLP
FA48 : A6 00      ldaa  $00,x         ;load A with addr X + 00h
FA4A : B7 04 00   staa  $0400         ;store A in DAC output SOUND
FA4D : 08         inx                 ;incr X
FA4E : 9C 20      cpx  $20            ;comp X with addr 20
FA50 : 26 F1      bne  LFA43          ;branch Z=0 GOUTLP
FA52 : 5A         decb                ;decr B
FA53 : 27 DA      beq  LFA2F          ;branch Z=1 GPLAY
FA55 : 08         inx                 ;incr X
FA56 : 09         dex                 ;decr X
FA57 : 08         inx                 ;incr X
FA58 : 09         dex                 ;decr X
FA59 : 08         inx                 ;incr X
FA5A : 09         dex                 ;decr X
FA5B : 08         inx                 ;incr X
FA5C : 09         dex                 ;decr X
FA5D : 01         nop
FA5E : 01         nop
FA5F : 20 DF      bra  LFA40          ;branch always GOUT
;GEND
FA61 : 96 16      ldaa  $16           ;load A with addr 16
FA63 : 8D 65      bsr  LFACA          ;branch sub WVDECA
FA65 : 7A 00 23   dec  $0023          ;decr addr 23
FA68 : 26 C1      bne  LFA2B          ;branch Z=0 GWT4
FA6A : 96 09      ldaa  $09           ;load A with addr 09
FA6C : 27 03      beq  LFA71          ;branch Z=1 GEND50
FA6E : 7E F9 9D   jmp  LF99D          ;jump GWALT
;GEND50
FA71 : 96 17      ldaa  $17           ;load A with addr 17
FA73 : 27 42      beq  LFAB7          ;branch Z=1 GEND1
FA75 : 7A 00 18   dec  $0018          ;decr addr 18
FA78 : 27 3D      beq  LFAB7          ;branch Z=1 GEND1
FA7A : 9B 24      adda  $24           ;add A with addr 24
;GEND60
FA7C : 97 24      staa  $24           ;store A in addr 24
;GEND61
FA7E : DE 1C      ldx  $1C            ;load X with addr 1C
FA80 : 5F         clrb                ;clear B 
;GW0
FA81 : 96 24      ldaa  $24           ;load A with addr 24
FA83 : 7D 00 17   tst  $0017          ;test addr 17
FA86 : 2B 06      bmi  LFA8E          ;branch N=1 GW1
FA88 : AB 00      adda  $00,x         ;add A with addr X + 00h
FA8A : 25 08      bcs  LFA94          ;branch C=1 GW2
FA8C : 20 0B      bra  LFA99          ;branch always GW2A
;GW1
FA8E : AB 00      adda  $00,x         ;add A with addr X + 00h
FA90 : 27 02      beq  LFA94          ;branch Z=1 GW2
FA92 : 25 05      bcs  LFA99          ;branch C=1 GW2A
;GW2
FA94 : 5D         tstb                ;test B
FA95 : 27 08      beq  LFA9F          ;branch Z=1 GW2B
FA97 : 20 0F      bra  LFAA8          ;branch always GW3
;GW2A
FA99 : 5D         tstb                ;test B
FA9A : 26 03      bne  LFA9F          ;branch Z=0 GW2B
FA9C : DF 1C      stx  $1C            ;store X in addr 1C
FA9E : 5C         incb                ;incr B
;GW2B
FA9F : 08         inx                 ;incr X
FAA0 : 9C 1E      cpx  $1E            ;comp X with addr 1E
FAA2 : 26 DD      bne  LFA81          ;branch Z=0 GW0
FAA4 : 5D         tstb                ;test B
FAA5 : 26 01      bne  LFAA8          ;branch Z=0 GW3
FAA7 : 39         rts                 ;return subroutine
;GW3
FAA8 : DF 1E      stx  $1E            ;store X in addr 1E
FAAA : 96 16      ldaa  $16           ;load A with addr 16
FAAC : 27 06      beq  LFAB4          ;branch Z=1 GEND0
FAAE : 8D 08      bsr  LFAB8          ;branch sub WVTRAN
FAB0 : 96 1B      ldaa  $1B           ;load A with addr 1B
FAB2 : 8D 16      bsr  LFACA          ;branch sub WVDECA
;GEND0
FAB4 : 7E FA 27   jmp  LFA27          ;jump GWAVE2
;GEND1
FAB7 : 39         rts                 ;return subroutine
;*************************************;
;Wave Transfer Routine
;*************************************;
;WVTRAN
FAB8 : CE 00 25   ldx  #$0025         ;load X with 0025h
FABB : DF 10      stx  $10            ;store X in addr 10
FABD : DE 19      ldx  $19            ;load X with addr 19
FABF : E6 00      ldab  $00,x         ;load B with addr X + 00h
FAC1 : 08         inx                 ;incr X
FAC2 : BD F9 52   jsr  LF952          ;jump sub TRANS
FAC5 : DE 10      ldx  $10            ;load X with addr 10
FAC7 : DF 20      stx  $20            ;store X in addr 20
FAC9 : 39         rts                 ;return subroutine
;*************************************;
;Wave Decay Routinue
;*************************************;
;decay amount in ACCA 1/16 per decay
;WVDECA
FACA : 4D         tsta                ;test A
FACB : 27 2B      beq  LFAF8          ;branch Z=1 WVDCX
FACD : DE 19      ldx  $19            ;load X with addr 19
FACF : DF 0E      stx  $0E            ;store X in addr 0E
FAD1 : CE 00 25   ldx  #$0025         ;load X with 0025h
FAD4 : 97 13      staa  $13           ;store A in addr 13
;WVDLP
FAD6 : DF 10      stx  $10            ;store X in addr 10
FAD8 : DE 0E      ldx  $0E            ;load X with addr 0E
FADA : D6 13      ldab  $13           ;load B with addr 13
FADC : D7 12      stab  $12           ;store B in addr 12
FADE : E6 01      ldab  $01,x         ;load B with addr X + 01h
FAE0 : 54         lsrb                ;logic shift right B 
FAE1 : 54         lsrb                ;logic shift right B 
FAE2 : 54         lsrb                ;logic shift right B 
FAE3 : 54         lsrb                ;logic shift right B 
FAE4 : 08         inx                 ;incr X
FAE5 : DF 0E      stx  $0E            ;store X in addr 0E
FAE7 : DE 10      ldx  $10            ;load X with addr 10
FAE9 : A6 00      ldaa  $00,x         ;load A with addr X + 00h
;WVDLP1
FAEB : 10         sba                 ;A=A-B
FAEC : 7A 00 12   dec  $0012          ;decr addr 12
FAEF : 26 FA      bne  LFAEB          ;branch Z=0 WVDLP1
FAF1 : A7 00      staa  $00,x         ;store A in addr X + 00h
FAF3 : 08         inx                 ;incr X
FAF4 : 9C 20      cpx  $20            ;compare X with addr 20
FAF6 : 26 DE      bne  LFAD6          ;branch Z=0 WVDLP
;WVDCX
FAF8 : 39         rts                 ;return subroutine
;*************************************;
; Add A to X
;*************************************;
;ADDX
FAF9 : DF 0E      stx  $0E            ;store X in addr 0E
FAFB : 9B 0F      adda  $0F           ;add A with addr 0F
FAFD : 97 0F      staa  $0F           ;store A in addr 0F
FAFF : 96 0E      ldaa  $0E           ;load A with addr 0E
FB01 : 89 00      adca  #$00          ;A = C + A + 00h
FB03 : 97 0E      staa  $0E           ;store A in addr 0E
FB05 : DE 0E      ldx  $0E            ;load X from addr 0E
FB07 : 39         rts                 ;return subroutine
;*************************************;
;Tilt sound, buzz saw down
;*************************************;
;TILT
FB08 : CE 00 E0   ldx  #$00E0         ;load X with 00E0h
;TILT1
FB0B : 86 20      ldaa  #$20          ;load A with 20h 
FB0D : 8D EA      bsr  LFAF9          ;branch sub ADDX
;TILT2
FB0F : 09         dex                 ;decr X
FB10 : 26 FD      bne  LFB0F          ;branch Z=0 TILT2
FB12 : 7F 04 00   clr  $0400          ;clear in DAC output SOUND
;TILT3
FB15 : 5A         decb                ;decr B
FB16 : 26 FD      bne  LFB15          ;branch Z=0 TILT3
FB18 : 73 04 00   com  $0400          ;complements 1s in DAC output SOUND
FB1B : DE 0E      ldx  $0E            ;load X with addr 0E
FB1D : 8C 10 00   cpx  #$1000         ;compare X with 1000h
FB20 : 26 E9      bne  LFB0B          ;branch !=0 TILT1
FB22 : 39         rts                 ;return subroutine
;*************************************;
;Lightning+Appear Noise Routine 
;*************************************;
;LITEN:
FB23 : 86 01      ldaa  #$01          ;load A with 01h 
FB25 : 97 16      staa  $16           ;store A in addr 16
FB27 : C6 03      ldab  #$03          ;load B with 03h 
FB29 : 97 15      staa  $15           ;store A in addr 15
FB2B : 86 FF      ldaa  #$FF          ;load A with FFh 
FB2D : B7 04 00   staa  $0400         ;store A in DAC output SOUND
FB30 : D7 14      stab  $14           ;store B in addr 14
;LITE0
FB32 : D6 14      ldab  $14           ;load B with addr 14
;LITE1
FB34 : 96 01      ldaa  $01           ;load A with addr 01
FB36 : 44         lsra                ;logic shift right A
FB37 : 44         lsra                ;logic shift right A
FB38 : 44         lsra                ;logic shift right A 
FB39 : 98 01      eora  $01           ;exclusive OR A with addr 01
FB3B : 44         lsra                ;logic shift right A 
FB3C : 76 00 00   ror  $0000          ;rotate right addr 00 
FB3F : 76 00 01   ror  $0001          ;rotate right addr 01
FB42 : 24 03      bcc  LFB47          ;branch C=0 SYN41
FB44 : 73 04 00   com  $0400          ;complements 1s in DAC output SOUND
;LITE2
FB47 : 96 15      ldaa  $15           ;load A with addr 15
;LITE3
FB49 : 4A         deca                ;decr A
FB4A : 26 FD      bne  LFB49          ;branch Z=0 LITE3
FB4C : 5A         decb                ;decr B
FB4D : 26 E5      bne  LFB34          ;branch Z=0 LITE1
FB4F : 96 15      ldaa  $15           ;load A with addr 15
FB51 : 9B 16      adda  $16           ;add A with addr 16
FB53 : 97 15      staa  $15           ;store A in addr 15
FB55 : 26 DB      bne  LFB32          ;branch Z=0 LITE0
;****;
;what, fall through?
FB57 : 01 01 01   nop                 ;nop nop nop
FB5A : 40         nega                ;negate A
FB5B : 10         sba                 ;sub B from A
FB5C : 00                             ;null
;*************************************;
;Filtered Noise Loader
;*************************************;
;FNOSLD
FB5D : CE FB 57   ldx  #$FB57         ;load X with FB57h
FB60 : A6 00      ldaa  $00,x         ;load A with addr X + 00h
FB62 : 97 1B      staa  X001B         ;store A in addr 1B
FB64 : A6 01      ldaa  $01,x         ;load A with addr X + 01h
FB66 : 97 17      staa  X0017         ;store A in addr 17
FB68 : A6 02      ldaa  $02,x         ;load A with addr X + 02h
FB6A : E6 03      ldab  $03,x         ;load B with addr X + 03h
FB6C : EE 04      ldx  $04,x          ;load X with addr X + 04h
;*************************************;
;Filtered Noise Routine 
;*************************************;
;*X=SAMPLE COUNT, ACCB=INITIAL MAX FREQ
;*ACCA=FREQ DECAY FLAG ,DSFLG=DISTORTION FLAG
;FNOISE
FB6E : 97 1A      staa  $1A           ;store A in addr 1A
FB70 : D7 14      stab  $14           ;store B in addr 14
FB72 : DF 18      stx  $18            ;store X in addr 18
FB74 : 7F 00 16   clr  $0016          ;clear addr 16
;FNOIS0
FB77 : DE 18      ldx  $18            ;load X with addr 18
FB79 : B6 04 00   ldaa  $0400         ;load A with DAC
;FNOIS1
FB7C : 16         tab                 ;transfer A to B
FB7D : 54         lsrb                ;logic shift right B
FB7E : 54         lsrb                ;logic shift right B 
FB7F : 54         lsrb                ;logic shift right B 
FB80 : D8 01      eorb  $01           ;exclusive OR B with addr 01
FB82 : 54         lsrb                ;logic shift right B
FB83 : 76 00 00   ror  $0000          ;rotate right addr 00 
FB86 : 76 00 01   ror  $0001          ;rotate right addr 01 
FB89 : D6 14      ldab  $14           ;load B with addr 14
FB8B : 7D 00 1B   tst  $001B          ;test addr 1B
FB8E : 27 04      beq  LFB94          ;branch Z=1 FNOIS2
FB90 : D4 00      andb  $00           ;and B with addr 00
FB92 : DB 17      addb  $17           ;add B with addr 17
;FNOIS2
FB94 : D7 15      stab  $15           ;store B in addr 15
FB96 : D6 16      ldab  $16           ;load B with addr 16
FB98 : 91 01      cmpa  $01           ;compare A with addr 01
FB9A : 22 12      bhi  LFBAE          ;branch C+Z=0 FNOIS4
;FNOIS3
FB9C : 09         dex                 ;decr X
FB9D : 27 26      beq  LFBC5          ;branch Z=1 FNOIS6
FB9F : B7 04 00   staa  $0400         ;store A in DAC output SOUND
FBA2 : DB 16      addb  $16           ;add B with addr 16
FBA4 : 99 15      adca  $15           ;A = C + A + addr 15 
FBA6 : 25 16      bcs  LFBBE          ;branch C=1 FNOIS5
FBA8 : 91 01      cmpa  $01           ;comp A with addr 01
FBAA : 23 F0      bls  LFB9C          ;branch C+Z=1 FNOIS3
FBAC : 20 10      bra  LFBBE          ;branch always FNOIS5
;FNOIS4
FBAE : 09         dex                 ;decr X
FBAF : 27 14      beq  LFBC5          ;branch Z=1 FNOIS6
FBB1 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
FBB4 : D0 16      subb  $16           ;B = B - addr 16
FBB6 : 92 15      sbca  $15           ;A = A - addr 15 - C
FBB8 : 25 04      bcs  LFBBE          ;branch C=1 FNOIS5
FBBA : 91 01      cmpa  $01           ;comp A with addr 01
FBBC : 22 F0      bhi  LFBAE          ;branch C+Z=0 FNOIS4
;FNOIS5
FBBE : 96 01      ldaa  $01           ;load A with addr 01
FBC0 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
FBC3 : 20 B7      bra  LFB7C          ;branch always FNOIS1
;FNOIS6
FBC5 : D6 1A      ldab  $1A           ;load B with addr 1A
FBC7 : 27 B3      beq  LFB7C          ;branch Z=1 FNOIS1
FBC9 : 96 14      ldaa  $14           ;load A with addr 14
FBCB : D6 16      ldab  $16           ;load B with addr 16
FBCD : 44         lsra                ;logic shift right A
FBCE : 56         rorb                ;rotate right B
FBCF : 44         lsra                ;logic shift right A 
FBD0 : 56         rorb                ;rotate right B
FBD1 : 44         lsra                ;logic shift right A
FBD2 : 56         rorb                ;rotate right B
FBD3 : 43         coma                ;complement 1s A
FBD4 : 50         negb                ;negate B
FBD5 : 82 FF      sbca  #$FF          ;A = A - FFh  - C
FBD7 : DB 16      addb  $16           ;add B with addr 16
FBD9 : 99 14      adca  $14           ;A = C + A + addr 14 
FBDB : D7 16      stab  $16           ;store B in addr 16
FBDD : 97 14      staa  $14           ;store A in addr 14
FBDF : 26 96      bne  LFB77          ;branch Z=0 FNOIS0
FBE1 : C1 07      cmpb  #$07          ;comp B with 07h 
FBE3 : 26 92      bne  LFB77          ;branch Z=0 FNOIS0
FBE5 : 39         rts                 ;return subroutine
;*************************************;
;PARAM8 GWave Calling Routine #3
;*************************************;
;GWCAL3
FBE6 : CE 3D 09   ldx  #$3D09         ;load X with 3D09h 
;GWCL31
FBE9 : 09         dex                 ;decr X 
FBEA : 26 FD      bne  LFBE9          ;branch Z=0 GWCL31
FBEC : 86 16      ldaa  #$16          ;load A with 16h 
FBEE : 8D 18      bsr  LFC08          ;branch sub GWCL4X
FBF0 : 86 0D      ldaa  #$0D          ;load A with 0Dh 
FBF2 : 97 14      staa  $14           ;store A in addr 14
FBF4 : 86 01      ldaa  #$01          ;load A with 01h 
FBF6 : 97 16      staa  $16           ;store A in addr 16
FBF8 : 7F 00 17   clr  $0017          ;clear addr 17
FBFB : 7E FA 27   jmp  LFA27          ;jump GWAVE2
;*************************************;
;GWave Calling routine #4
;*************************************;
;GWCAL4
FBFE : 86 11      ldaa  #$11          ;load A with 11h 
FC00 : 8D 06      bsr  LFC08          ;branch sub GWCL4X
FC02 : 86 11      ldaa  #$11          ;load A with 11h 
FC04 : 8D 02      bsr  LFC08          ;branch sub GWCL4X
FC06 : 86 12      ldaa  #$12          ;load A with 12h 
;GWCL4X
FC08 : BD F9 B9   jsr  LF9B9          ;jump sub GWALT
FC0B : 7E FA 23   jmp  LFA23          ;jump GWAVE
;*************************************;
;GWave Calling Routine #5
;*************************************;
;GWCAL5
FC0E : 86 03      ldaa  #$03          ;load A with 03h
FC10 : BD F9 B9   jsr  LF9B9          ;jump sub GWALT
FC13 : 96 0A      ldaa  $0A           ;load A with addr 0A
FC15 : 8B 02      adda  #$02          ;add A with 02h 
FC17 : 2A 02      bpl  LFC1B          ;branch N=0 GWCL51
FC19 : 86 40      ldaa  #$40          ;load A with 40h
;GWCL51
FC1B : 97 0A      staa  $0A           ;store A in addr 0A
FC1D : 40         nega                ;negate A
FC1E : 80 10      suba  #$10          ;A = A - 10h 
FC20 : 7E FA 7C   jmp  LFA7C          ;jump GEND60
;*************************************;
;Filtered Noise Calling Routine
;*************************************;
;FNOSCL
FC23 : 86 1F      ldaa  #$1F          ;load A with 1Fh 
FC25 : 97 03      staa  X0003         ;store A in addr 03
FC27 : 7E FB 5D   jmp  LFB5D          ;jump FNOSLD
;*************************************;
; Interrupt Request processing data
;*************************************;
;IRQDAT
FC2A : 00 07 8A 88 84 03 8D 80        ;
FC32 : 9D 9E 08 8E 85 81 82 06        ;
FC3A : 80 90 98 9B 0A 40 43 09        ;
FC42 : 01 02 8F 41 42 05 97 00        ;
FC4A : 80 8C 9A 89 04 8D 9C 8B        ;
FC52 : 99 08 8E 85 
;*************************************;
; Jump Table
;*************************************;
;JMPTBL
FC56 : FB 08                          ;TILT
FC58 : F8 01                          ;RESET
FC5A : F9 66                          ;BGSET
FC5C : F9 74                          ;GWCAL1
FC5E : F9 82                          ;GWCAL2
FC60 : FB E6                          ;GWCAL3
FC62 : FB FE                          ;GWCAL4
FC64 : FC 0E                          ;GWCAL5
FC66 : FB 23                          ;LITEN
FC68 : FB 5D                          ;FNOSLD
FC6A : FC 23                          ;FNOSCL
;*************************************;
; VARI VECTORS
;*************************************;
FC6C : 40 01 00 10 E1 00 80 FF FF     ;SAW
FC75 : 00 FF 08 FF 68 04 80 00 FF     ;CSCALE
FC7E : 28 81 00 FC 01 02 00 FC FF     ;QUASAR
FC87 : 05 FF C0 FF 00 06 B0 00 FF     ;
;*************************************;
;*WAVE TABLE
;*1ST BYTE= WAVELENGTH
;*
;GWVTAB  EQU  *
FC90 : 08                             ;GS2
FC91 : 7F D9 FF D9 7F 24 00 24        ;
;
FC99 : 0A                             ;(10)
FC9A : D9 D9 D9 25 25 FF FF FF        ;
FCA2 : 00 00                          ;
;
FCA4 : 08                             ;(8)
FCA5 : 00 40 80 00 FF 00 80 40        ;
;
FCAD : 10                             ;GS1
FCAE : 7F B0 D9 F5 FF F5 D9 B0        ;
FCB6 : 7F 4E 24 09 00 09 24 4E        ;
;
FCBE : 3C                             ;(60)
FCBF : CC E8 F9 FF F9 E8 CF B4        ;
FCC7 : 9A 84 77 73 77 83 93 A3        ;
FCCF : AF B5 B3 AA 9B 88 76 67        ;
FCD7 : 61 63 6E 81 9A B4 CC DC        ;
FCDF : E2 DC CB AF 8D 69 46 29        ;
FCE7 : 15 0C 0C 15 23 32 3F 47        ;
FCEF : 48 43 39 2D 22 1C 1E 2A        ;
FCF7 : 3F 5F 83 A8                    ;
;
FCFB : 24                             ;(36)
FCFC : 7F BA E6 FC F6 D7 AA 7B        ;
FD04 : 59 4C 59 7B AA D7 F6 FC        ;
FD0C : E6 BA 7F 43 17 01 07 26        ;
FD14 : 53 82 A4 B1 A4 82 53 26        ;
FD1C : 07 01 17 43                    ;
;
FD20 : 06                             ;(6)
FD21 : 7F FF FF AA 55 00              ;
;
FD27 : 10                             ;GSQ22
FD28 : FF FF FF FF 00 00 00 00        ;
FD30 : FF FF FF FF 00 00 00 00        ;
;
FD38 : 10                             ;MW1
FD39 : 00 F4 00 E8 00 DC 00 E2        ;
FD41 : 00 DC 00 E8 00 F4 00 00        ;
;
FD49 : 48                             ;GS72
FD4A : 8A 95 A0 AB B5 BF C8 D1        ;
FD52 : DA E1 E8 EE F3 F7 FB FD        ;
FD5A : FE FF FE FD FB F7 F3 EE        ;
FD62 : E8 E1 DA D1 C8 BF B5 AB        ;
FD6A : A0 95 8A 7F 75 6A 5F 54        ;
FD72 : 4A 40 37 2E 25 1E 17 11        ;
FD7A : 0C 08 04 02 01 00 01 02        ;
FD82 : 04 08 0C 11 17 1E 25 2E        ;
FD8A : 37 40 4A 54 5F 6A 75 7F        ;
;
FD92 : 13                             ;(19)
FD93 : 8A AB D1 EE FD FD EE D1        ;
FD9B : AB 7F 54 2E 11 02 02 11        ;
FDA3 : 2E 54 7F                       ;

FDA6 : 0B                             ;(11)
FDA7 : 00 FF 00 FF 00 2B 55 80        ;
FDAF : AA D5 FF                       ;
;
FDB2 : 0A                             ;(10)
FDB3 : 00 64 96 C8 00 32 64 C8        ;
FDBB : FA 00 00                       ;
;
FDBE : 05                             ;(5)
FDBF : 7F FF CE 30 01                 ;
;
FDC4 : 0F                             ;(15)
FDC5 : 7F FF EA D5 C0 AB 96 81        ;
FDCD : 6C 57 42 2D 18 03 7F           ;
;*************************************;
;TABLE - GWALT call
;*************************************;
FDD4 : 81 27 00 00 00 00 16 3C        ;
FDDC : 15 12 00 00 00 00 16 3C        ;
FDE4 : 21 88 00 00 00 00 16 3C        ;
FDEC : C8 1E 00 FF 01 00 16 3C        ;
FDF4 : 38 6E 00 FF 01 B9 16 3C        ;
FDFC : 91 24 00 00 05 00 0F 52        ;
FE04 : 11 0A 04 FF 23 00 01 00        ;
FE0C : 28 19 00 01 02 00 01 2E        ;
FE14 : 11 09 11 01 0F 00 01 2E        ;
FE1C : 61 35 00 00 20 00 27 64        ;
FE24 : 92 2B 00 00 00 00 27 64        ;
FE2C : 84 24 00 00 03 00 0D 21        ;
FE34 : E2 14 00 00 00 00 0D 21        ;
FE3C : F1 18 00 00 00 00 0E 2E        ;
FE44 : F1 17 00 00 06 00 0E 2E        ;
FE4C : 93 21 00 00 50 00 0E 13        ;
FE54 : 15 10 00 0C 01 00 0E 13        ;
FE5C : 31 03 00 03 06 00 03 61        ;
FE64 : 31 03 00 03 0A 00 03 61        ;
FE6C : 26 0F 87 06 20 00 03 61        ;
FE74 : 12 08 00 FF 00 00 20 8B        ;
FE7C : 92 2E 00 FF 01 00 10 EE        ;
FE84 : 22 23 00 02 2F 00 10 AB        ;
FE8C : 12 05 00 00 00 00 23 CB        ;
FE94 : 12 0C 00 FF 30 00 09 0A        ;
FE9C : 86 2E 00 00 00 00 10 BB        ;
FEA4 : 12 0A 00 01 0C 00 10 BB        ;
FEAC : 42 2C 00 00 00 00 10 BB        ;
FEB4 : 35 7C 00 FF 01 00 10 BB        ;
FEBC : FE 16 00 00 00 00 0A 00        ;
FEC4 : 95 2C 00 00 00 00 0A 00        ;
;*************************************;
;GFRTAB - GWAVE FREQ PATTERN TABLE
;*************************************; 
;
FECC : 40 08 40 08 40 01 02 04        ;
FED4 : 08 09                          ;
;TURBINE START UP
FED6 : 80 7C 78 74 70 74 78 7C 80     ;TRBPAT
;Hundred Point Sound
FEDF : 01 01 02 02 04 04 08 08        ;HBTSND
FEE7 : 10 10 30 60 C0 E0              ;
;Spinner Sound
FEED : 01 01 02 02 03 04 05 06        ;SPNSND
FEF5 : 07 08 09 0A 0C                 ;
;Yuksnd
FEFA : 08 80 10 78 18 70 20 60        ;YUKSND
FF02 : 28 58 30 50 40 48              ;
;HEARTBEAT DISTORTO
FF08 : 01 01 02 02 04 04 08 08        ;HBDSND
FF10 : 10 20 28 30 38 40 48 50        ;
;
FF18 : 60 70 80 A0 B0 C0              ;UNKNWN
;Heartbeat Echo
FF1E : 01 02 04 08 09 0A 0B 0C        ;HBESND
FF26 : 0E 0F 10 12 14 16              ;
;Spinner Sound "Drip"
FF2C : 40                             ;SPNR
;Cool Downer
FF2D : 10 08 01                       ;COOLDN 
;Start Distorto Sound
FF30 : 01 01 01 01 02 02 03 03        ;STDSND 
FF38 : 04 04 05 06 08 0A 0C 10        ;
FF40 : 14 18 20 30 40 50 40 30        ;
FF48 : 20 10 0C 0A 08 07 06 05        ;
FF50 : 04 03 02 02 01 01 01           ;
;
FF57 : 06 06 06 06 07 07 08 08        ;UNKNWN
FF5F : 09 09 0A 0B 0D 0F 11 15        ;
FF67 : 17 1D 25 35 45 55 65 75        ;
FF6F : 85 95 A5 B5 C5 D5 E5 F5        ;
;
FF77 : 1A 32 1A 11 1A 1B 1C 1B        ;UNKNWN
FF7F : 1A 19 11 19 1A 1E 26 30        ;
;
FF87 : 01 18 02 20 03 28 04 30        ;UNKNWN
FF8F : 05 38 06 40 07 48 08 78        ;
;
FF97 : 01 01 11 11 11 11 12 12        ;UNKNWN
FF9F : 13 13 14 14 15 16 18 1A        ;
FFA7 : 1C 20 24 28 30 40 50 60        ;
FFAB : 50 40 30 20 1C 1A 18 17        ;
FFB7 : 16 15 14                       ;
;
FFBA : A0 C0 A0 C0 A0 C0 A0 C0        ;UNKNWN
FFC2 : C0 C0 C0 C0 FF C0 FF FF        ;
;*************************************;
;zero padding
FFCA : 00 00 00 00 00 00
FFD0 : 00 00 00 00 00 00 00 00
FFD8 : 00 00 00 00 00 00 00 00
FFE0 : 00 00 00 00 00 00 00 00
FFE8 : 00 00 00 00 00 00 00 00
FFF0 : 00 00 00 00 00 00 00 00
;*************************************;
;Motorola vector table
;*************************************;
FFF8 : F8 4E                          ;IRQ  
FFFA : F8 01                          ;RESET (software)
FFFC : F8 2C                          ;NMI
FFFE : F8 01                          ;RESET (hardware)

;--------------------------------------------------------------

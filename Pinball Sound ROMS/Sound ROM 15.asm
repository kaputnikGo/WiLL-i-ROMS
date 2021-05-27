              ;
              ;
              ;  Disassembled by:
              ;    DASMx object code disassembler
              ;    (c) Copyright 1996-2003   Conquest Consultants
              ;    Version 1.40 (Oct 18 2003)
              ;
              ;  File:    SOUND12.716
              ;
              ;  Size:    2048 bytes
              ;  Checksum:  AF3F
              ;  CRC-32:    CABAEC58
              ;
              ;  Date:    Tue Sep 17 17:59:50 2019
              ;
              ;  CPU:    Motorola 6802 (6800/6802/6808 family)
              ;
              ; Pinball Sound ROM 15, Defender, December 1982 
              ;
              ;update: based on Williams Sound ROM source code for arcade video game via :
              ; https://github.com/historicalsource/williams-soundroms/blob/main/VSNDRM1.SRC
              ;
              ;updated 20 May 2021
              ;
;
;NOGEN
;NAM  DEFENDER SOUNDS REV. 1.0 BY SAM D 10/80
;*COPYRIGHT WILLIAMS ELECTRONICS 1980
;*PROGRAM ORIGINATION DATE 10/24/80
;*PROGRAM RELEASE 10/31/80
;*PROGRAMMER: SAM DICKER
;
;*
;*SYSTEM CONSTANTS
;*
ROM      EQU  $F800
SOUND    EQU  $400
CKORG    EQU  $F700    ;CHECKSUM PROG ORG
ENDRAM   EQU  $7F
VECTOR   EQU  $FFF8    ;RESET,INT VECTORS
WVELEN   EQU  72
BG2MAX   EQU  29
SP1SND   EQU  $0E      ;SPINNER SOUND #1 CODE
B2SND    EQU  $12      ;BONUS SOUND #2 CODE
SP1MAX   EQU  32
TACC     EQU  4        ;TACCATA TEMPO CONSTANT
PHANC    EQU  3        ;PHANTOM TEMPO CONTANT
TAF      EQU  34715!>1 ;NOTE TIMES
TA       EQU  36780!>1
TBF      EQU  38967!>1
TB       EQU  41284!>1
TC       EQU  43739!>1
TCS      EQU  46340!>1
TD       EQU  49096!>1
TEF      EQU  52015!>1
TE       EQU  55108!>1
TF       EQU  58385!>1
TFS      EQU  61857!>1
TG       EQU  65535!>1
;*
;* SCREAM EQUATES
;*
ECHOS    EQU  4
FREQ     EQU  0
TIMER    EQU  1
;*
;*GLOBALS
;*
         ORG  0        ;DESCRIPTION              : ADDR
;
BG1FLG   RMB  1        ;BACKGROUND SOUND 1       : 0000
BG2FLG   RMB  1        ;BACKGROUND SOUND 2       : 0001
SP1FLG   RMB  1        ;SPINNER FLAG             : 0002
B2FLG    RMB  1        ;BONUS #2 FLAG            : 0003
ORGFLG   RMB  1        ;ORGAN FLAG               : 0004
HI       RMB  1        ;RANDOM SEED              : 0005
LO       RMB  1        ;RANDOM SEED              : 0006
;*
;*TEMPORARIES
;*
TMPRAM   EQU  *        ;TEMPORARY RAM
TEMPX    RMB  2        ;X TEMPS                  : 0007-0008
XPLAY    RMB  2        ;                         : 0009-000A
XPTR     RMB  2        ;                         : 000B-000C
TEMPA    RMB  1        ;ACCA TEMP                : 000D
TEMPB    RMB  1        ;                         : 000E
LOCRAM   EQU  *        ;                         : 000F
;*
;*GWAVE PARAMETERS
;*
         ORG  LOCRAM
GECHO    RMB  1        ;ECHO FLAG                : 000F
GCCNT    RMB  1        ;CYCLE COUNT              : 0010
GECDEC   RMB  1        ;# OF DECAYS PER ECHO     : 0011
GDFINC   RMB  1        ;DELTA FREQ INC           : 0012
GDCNT    RMB  1        ;DELTA FREQ COUNT         : 0013
GWFRM    RMB  2        ;WAVEFORM ADDRESS         : 0014-0015
;*TEMPORARY OR COMPUTED PARAMETERS
PRDECA   RMB  1        ;PRE-DECAY FACTOR         : 0016
GWFRQ    RMB  2        ;FREQ TABLE ADDR          : 0017-0018
FRQEND   RMB  2        ;END ADDR FREQ TABLE      : 0019-001A
WVEND    RMB  2        ;WAVE END ADDR            : 001B-001C
GPER     RMB  1        ;PERIOD                   : 001D
GECNT    RMB  1        ;# OF ECHOES COUNTER      : 001E
FOFSET   RMB  1        ;FREQUENCY OFFSET         : 001F
;*
;*GWAVE TABLES
;*
GWTAB    RMB  WVELEN   ;WAVE TABLE               : 0020-0068
;*
;*VARIWAVE PARAMETERS
;*
         ORG  LOCRAM
LOPER    RMB  1        ;LO PERIOD                : 000F
HIPER    RMB  1        ;HIPERIOD                 : 0010
LODT     RMB  1        ;PERIOD DELTAS            : 0011
HIDT     RMB  1        ;                         : 0012
HIEN     RMB  1        ;END PERIOD               : 0013
SWPDT    RMB  2        ;SWEEP PERIOD             : 0014-0015
LOMOD    RMB  1        ;BASE FREQ MOD            : 0016
VAMP     RMB  1        ;AMPLITUDE                : 0017
LOCNT    RMB  1        ;PERIOD COUNTERS          : 0018
HICNT    RMB  1        ;                         : 0019
;*
;*NOISE ROUTINE PARAMETERS
;*
         ORG  LOCRAM
DECAY    RMB  1        ;                         : 000F
NAMP     RMB  1        ;                         : 0010
CYCNT    RMB  1        ;                         : 0011
NFRQ1    RMB  2        ;                         : 0012-0013
NFFLG    RMB  1        ;                         : 0014
LFREQ    RMB  1        ;                         : 0015
DFREQ    RMB  1        ;                         : 0016
;*
;*FILTERED NOISE ROUTINE PARAMETERS
;*
         ORG  LOCRAM
FMAX     RMB  1        ;MAXIMUM_FREQUENCY        : 000F
FHI      RMB  1        ;FREQUENCY                : 0010
FLO      RMB  1        ;                         : 0011
SAMPC    RMB  2        ;SAMPLE COUNT             : 0012-0013
FDFLG    RMB  1        ;FREQUENCY DECREMENT FLAG : 0014
DSFLG    RMB  1        ;DISTORTION FLAG          : 0015
;*
;*SCREAM TABLES
;*
        ORG  LOCRAM
STABLE  RMB  2*ECHOS   ;SCREAM TABLE             : 000F-0017
SRMEND  EQU  *         ;                         : 0017
;*
;*ORGAN PARAMETERS
;*
         ORG  LOCRAM
DUR      RMB  2        ;NOTE DURATION            : 000F-0010
OSCIL    RMB  1        ;OSCILLATORS              : 0011
RDELAY   RMB  60       ;RAM DELAY LOAD           : 0012-0072
;*
;* CHECKSUM CALCULATOR & RELOCATOR
;*
         ORG  CKORG
CKSUM    LDS  #$F7FF   ;SET STACK POINTER
         LDX  #$FFFF   ;INDEX TO END OF ROM
         CLRB          ;ZERO CHECKSUM
CKSUM1   ADCB  0,X     ;ADD IN PROGRAM BYTE
         DEX           ;TO NEXT BYTE
         CPX  #$F800   ;DONE YET?
         BNE  CKSUM1   ;NOPE...
         STAB  0,X     ;SAVE CHECKSUM AT BEGINNING
         STX  FROM     ;SAVE FOR RELO
         LDX  #$6800   ;DESTINATION
         STX  TO       ;SAVE FOR LATER
RELO     LDX  FROM     ;GET SOURCE
         LDAA  0,X     ;GRAB THE BYTE
         INX           ;UPDATE
         STX  FROM     ;UPDATE SOURCE ADDRESS
         LDX  TO       ;GET DESTINATION ADDRESS
         STAA  0,X     ;SAVE IT IN NEW LOCATION
         INX           ;UPDATE
         STX  TO       ;UPDATE DESTINATION ADDRESS
         LDX  FROM     ;GET THE SOURCE
         BNE  RELO     ;KEEP MOVING
         WAI           ;TURN OFF LEDS
FROM     RMB  2        ;FOR POINTER
TO       RMB  2        ;FOR POINTER
;
;
;
;
org  $F800
;
F800 : 78                             ;Checksum byte
;*************************************;
;RESET power on
;*************************************;
;SETUP
F801 : 0F         sei                 ;set interrupt mask   
F802 : 8E 00 7F   lds  #$007F         ;load stack pointer with 007Fh 
F805 : CE 04 00   ldx  #$0400         ;load X with 0400h (PIA addr)
F808 : 6F 01      clr  $01,x          ;clear addr X + 01h (0401 PIA1 CR port A)
F80A : 6F 03      clr  $03,x          ;clear addr X + 03h (0403 PIA1 CR port B)
F80C : 86 FF      ldaa  #$FF          ;load A with FFh
F80E : A7 00      staa  $00,x         ;store A in addr X + 00h (0400 PIA1 PR/DDR port A out)
F810 : 6F 02      clr  $02,x          ;clear addr X + 02h (0402 PIA1 PR/DDR port B in)
F812 : 86 37      ldaa  #$37          ;load A with 37h (CB2 low, IRQ allowed)
F814 : A7 03      staa  $03,x         ;store A in addr X + 03h (0403 PIA1 CR port B)
F816 : 86 3C      ldaa  #$3C          ;load A with 3Ch (CA2 set init high, no IRQs)
F818 : A7 01      staa  $01,x         ;store A in addr X + 01h (0401 PIA1 CR port A)
F81A : 97 05      staa  $05           ;store A in addr 05 (HI, start Random Generator)
F81C : 4F         clra                ;clear A
F81D : 97 03      staa  $03           ;store A in addr 03 (B2FLG)
F81F : 97 00      staa  $00           ;store A in addr 00 (BG1FLG)
F821 : 97 01      staa  $01           ;store A in addr 01 (BG2FLG)
F823 : 97 02      staa  $02           ;store A in addr 02 (SP1FLG)
F825 : 97 04      staa  $04           ;store A in addr 04 (ORGFLG)
F827 : 0E         cli                 ;clear interrupt
;STDBY:
F828 : 20 FE      bra  LF828          ;branch always (STDBY)
;*************************************;
;Vari Loader 
;*************************************;
;VARILD
F82A : 16         tab                 ;transfer A to B
F82B : 48         asla                ;arith shift left A   x2
F82C : 48         asla                ;arith shift left A   x4
F82D : 48         asla                ;arith shift left A   x8
F82E : 1B         aba                 ;A = A + B (x9)
F82F : CE 00 0F   ldx  #$000F         ;load X with value 000Fh (#LOCRAM)
F832 : DF 0B      stx  $0B            ;store X in addr 0B (0B:XPTR)(SET XSFER)
F834 : CE FD 60   ldx  #$FD60         ;load X with value FD60h (VVECT SAW)
F837 : BD FC F0   jsr  LFCF0          ;jump sub ADDX
F83A : C6 09      ldab  #$09          ;load B with value 09h (COUNT)
F83C : 7E FA E0   jmp  LFAE0          ;jump TRANS 
;*************************************;
;Variable Duty Cycle Square Wave Routine 
;*************************************;
;VARI
F83F : 96 17      ldaa  $17           ;load A with value in addr 17 (VAMP)
F841 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
;VAR0:
F844 : 96 0F      ldaa  $0F           ;load A with value in addr 0F (LOPER)
F846 : 97 18      staa  $18           ;store A in addr 18 (LOCNT)
F848 : 96 10      ldaa  $10           ;load A with value in addr 10 (HIPER)
F84A : 97 19      staa  $19           ;store A in addr 19 (HICNT)
;V0:
F84C : DE 14      ldx  $14            ;load X with value in addr 14 (SWPDT)
;V0LP:
F84E : 96 18      ldaa  $18           ;load A with value in addr 18 (LOCNT) (LO CYCLE)
F850 : 73 04 00   com  $0400          ;complement 1s in DAC output SOUND
;V1:
F853 : 09         dex                 ;decr X
F854 : 27 10      beq  LF866          ;branch if Z=1 (VSWEEP)
F856 : 4A         deca                ;decr A
F857 : 26 FA      bne  LF853          ;branch if Z=0 (V1)
F859 : 73 04 00   com  $0400          ;complement 1s in DAC output SOUND
F85C : 96 19      ldaa  $19           ;load A with value in addr 19 (HICNT) (HI CYCLE)
;V2:
F85E : 09         dex                 ;decr X
F85F : 27 05      beq  LF866          ;branch if Z=1 (VSWEEP)
F861 : 4A         deca                ;decr A
F862 : 26 FA      bne  LF85E          ;branch if Z=0 (V2)
F864 : 20 E8      bra  LF84E          ;branch always (V0LP) (LOOP BACK)
;VSWEEP:
F866 : B6 04 00   ldaa  $0400         ;load A with value in addr DAC output SOUND
F869 : 2B 01      bmi  LF86C          ;branch if N=1 (VS1)
F86B : 43         coma                ;complement 1s in A
;VS1:
F86C : 8B 00      adda  #$00          ;add A with value 00h
F86E : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F871 : 96 18      ldaa  $18           ;load A with value in addr 18 (LOCNT)
F873 : 9B 11      adda  $11           ;add A with value in addr 11 (LODT)
F875 : 97 18      staa  $18           ;store A in addr 18 (LOCNT)
F877 : 96 19      ldaa  $19           ;load A with value in addr 19 (HICNT)
F879 : 9B 12      adda  $12           ;add A with value in addr 12 (HIDT)
F87B : 97 19      staa  $19           ;store A in addr 19 (HICNT)
F87D : 91 13      cmpa  $13           ;compare A with value in addr 13 (HIEN)
F87F : 26 CB      bne  LF84C          ;branch if Z=0 (V0)
F881 : 96 16      ldaa  $16           ;load A with value in addr 16 (LOMOD)
F883 : 27 06      beq  LF88B          ;branch if Z=1 (VARX)
F885 : 9B 0F      adda  $0F           ;add A with value in addr 0F (LOPER)
F887 : 97 0F      staa  $0F           ;store A in addr 0F (LOPER)
F889 : 26 B9      bne  LF844          ;branch if Z=0 (VAR0)
;VARX:
F88B : 39         rts                 ;return subroutine
;*************************************;
;Lightning 
;*************************************;
;LITE
F88C : 86 01      ldaa  #$01          ;load A with value 01h
F88E : 97 16      staa  $16           ;store A in addr 16 (DFREQ)
F890 : C6 03      ldab  #$03          ;load B with value 03h
F892 : 20 0A      bra  LF89E          ;branch always (LITEN)
;*************************************;
;Appear 
;*************************************;
;APPEAR
F894 : 86 FE      ldaa  #$FE          ;load A with value FEh
F896 : 97 16      staa  $16           ;store A in addr 16 (DFREQ)
F898 : 86 C0      ldaa  #$C0          ;load A with value C0h
F89A : C6 10      ldab  #$10          ;load B with value 10h
F89C : 20 00      bra  LF89E          ;branch always (LITEN)
;*************************************;
;Lightning+Appear Noise Routine 
;*************************************;
;LITEN:
F89E : 97 15      staa  $15           ;store A in addr 15 (LFREQ)
F8A0 : 86 FF      ldaa  #$FF          ;load A with value FFh (HIGHEST AMP)
F8A2 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F8A5 : D7 11      stab  $11           ;store B in addr 11 (CYCNT)
;LITE0:
F8A7 : D6 11      ldab  $11           ;load B with value in addr 11 (CYCNT)
;LITE1:
F8A9 : 96 06      ldaa  $06           ;load A with value in addr 06 (LO) (GET RANDOM)
F8AB : 44         lsra                ;logic shift right A
F8AC : 44         lsra                ;logic shift right A
F8AD : 44         lsra                ;logic shift right A 
F8AE : 98 06      eora  $06           ;exclusive OR with value in addr 06 (LO)
F8B0 : 44         lsra                ;logic shift right A 
F8B1 : 76 00 05   ror  $0005          ;rotate right in addr 0005 (HI)
F8B4 : 76 00 06   ror  $0006          ;rotate right in addr 0006  (LO)
F8B7 : 24 03      bcc  LF8BC          ;branch if C=0 (LITE2)
F8B9 : 73 04 00   com  $0400          ;complement 1s in DAC output SOUND
;LITE2:
F8BC : 96 15      ldaa  $15           ;load A in addr 15 (LFREQ)(COUNT FREQ)
;LITE3:
F8BE : 4A         deca                ;decr A
F8BF : 26 FD      bne  LF8BE          ;branch if Z=0 (LITE3)
F8C1 : 5A         decb                ;decr B (COUNT CYCLES)
F8C2 : 26 E5      bne  LF8A9          ;branch if Z=0 (LITE1)
F8C4 : 96 15      ldaa  $15           ;load A with value in addr 15 (LFREQ)
F8C6 : 9B 16      adda  $16           ;add A with value in addr 16 (DFREQ)
F8C8 : 97 15      staa  $15           ;store A in addr 15 (LFREQ)
F8CA : 26 DB      bne  LF8A7          ;branch if Z=0 (LITE0)
F8CC : 39         rts                 ;return subroutine
;*************************************;
;Turbo 
;*************************************;
;TURBO
F8CD : 86 20      ldaa  #$20          ;load A with value 20h
F8CF : 97 11      staa  $11           ;store A in addr 11 (CYCNT)
F8D1 : 97 14      staa  $14           ;store A in addr 14 (NFFLG)
F8D3 : 86 01      ldaa  #$01          ;load A with value 01h
F8D5 : CE 00 01   ldx  #$0001         ;load X with value 0001h
F8D8 : C6 FF      ldab  #$FF          ;load B with value FFh
F8DA : 20 00      bra  LF8DC          ;branch always (NOISE)
;*************************************;
;White Noise Routine 
;*************************************;
;X=INIT PERIOD, ACCB=INIT AMP, ACCA DECAY RATE
;CYCNT=CYCLE COUNT, NFFLG= FREQ DECAY FLAG
;NOISE:
F8DC : 97 0F      staa  $0F           ;store A in addr 0F (DECAY)
;NOISE0:
F8DE : DF 12      stx  $12            ;store X in addr 12 (NFRQ1)
;NOIS00: 
F8E0 : D7 10      stab  $10           ;store B in addr 10 (NAMP)
F8E2 : D6 11      ldab  $11           ;load B with value in addr 11 (CYCNT)
;NOISE1:
F8E4 : 96 06      ldaa  $06           ;load A with value in addr 06 (LO)(GET RANDOM BIT)
F8E6 : 44         lsra                ;logic shift right A 
F8E7 : 44         lsra                ;logic shift right A
F8E8 : 44         lsra                ;logic shift right A
F8E9 : 98 06      eora  $06           ;exclusive OR with value in addr 06 (LO)
F8EB : 44         lsra                ;logic shift right A  
F8EC : 76 00 05   ror  $0005          ;rotate right in addr 0005 (HI)
F8EF : 76 00 06   ror  $0006          ;rotate right in addr 0006 (LO)
F8F2 : 86 00      ldaa  #$00          ;load A with value 00h
F8F4 : 24 02      bcc  LF8F8          ;branch if C=0 (NOISE2)
F8F6 : 96 10      ldaa  $10           ;load A with value in addr 10 (NAMP)
;NOISE2:
F8F8 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F8FB : DE 12      ldx  $12            ;load X with value in addr 12 (NFRQ1)(INCREASING DELAY)
;NOISE3:
F8FD : 09         dex                 ;decr X
F8FE : 26 FD      bne  LF8FD          ;branch if Z=0 (NOISE3)
F900 : 5A         decb                ;decr B (FIN CYCLE COUNT?)
F901 : 26 E1      bne  LF8E4          ;branch if Z=0 (NOISE1)(NO)
F903 : D6 10      ldab  $10           ;load B with value in addr 10 (NAMP)(DECAY AMP)
F905 : D0 0F      subb  $0F           ;B = B - value in addr 0F (DECAY) 
F907 : 27 09      beq  LF912          ;branch if Z=1 (NSEND)
F909 : DE 12      ldx  $12            ;load X with value in addr 12 (NFRQ1)(INC FREQ)
F90B : 08         inx                 ;incr X 
F90C : 96 14      ldaa  $14           ;load A with value in addr 14 (NFFLG)(DECAY FREQ?)
F90E : 27 D0      beq  LF8E0          ;branch if Z=1 (NOIS00)(NO)
F910 : 20 CC      bra  LF8DE          ;branch always (NOISE0)
;NSEND:
F912 : 39         rts                 ;return subroutine
;*************************************;
;Background 1 Routine 
;*************************************;
;BG1:
F913 : C6 01      ldab  #$01          ;load B with value 01h
F915 : D7 00      stab  $00           ;store B in addr 00 (BG1FLG)
F917 : 4F         clra                ;clear A
F918 : 97 15      staa  $15           ;store A in addr 15 (DSFLG)
F91A : 20 14      bra  LF930          ;branch always (FNOISE)
;*************************************;
;Thrust 
;*************************************;
;THRUST
F91C : 4F         clra                ;clear A
F91D : 97 15      staa  $15           ;store A with value in addr 15 (DSFLG)
F91F : C6 03      ldab  #$03          ;load B with value 03h
F921 : 20 0D      bra  LF930          ;branch always (FNOISE)
;*************************************;
;Cannon 
;*************************************;
;CANNON
F923 : 86 01      ldaa  #$01          ;load A with value 01h
F925 : 97 15      staa  $15           ;store A in addr 15 (DSFLG)
F927 : CE 03 E8   ldx  #$03E8         ;load X with value 03E8h (#1000)
F92A : 86 01      ldaa  #$01          ;load A with value 01h
F92C : C6 FF      ldab  #$FF          ;load B with value FFh
F92E : 20 00      bra  LF930          ;branch always (FNOISE)
;*************************************;
;Filtered Noise Routine 
;*************************************;
;*X=SAMPLE COUNT, ACCB=INITIAL MAX FREQ
;*ACCA=FREQ DECAY FLAG ,DSFLG=DISTORTION FLAG
;FNOISE
F930 : 97 14      staa  $14           ;store A in addr 14 (FDFLG)
F932 : D7 0F      stab  $0F           ;store B in addr 0F (FMAX)
F934 : DF 12      stx  $12            ;store X in addr 12 (SAMPC)
F936 : 7F 00 11   clr  $0011          ;clear addr 0011 (FLO)
;FNOIS0:
F939 : DE 12      ldx  $12            ;load X with value in addr 12 (SAMPC)
F93B : B6 04 00   ldaa  $0400         ;load A with value in DAC sound OUTPUT
;FNOIS1:
F93E : 16         tab                 ;transfer A to B (NEXT RANDOM NUMBER)
F93F : 54         lsrb                ;logic shift right B
F940 : 54         lsrb                ;logic shift right B 
F941 : 54         lsrb                ;logic shift right B 
F942 : D8 06      eorb  $06           ;exclusive OR with value in addr 06 (LO)
F944 : 54         lsrb                ;logic shift right B 
F945 : 76 00 05   ror  $0005          ;rotate right in addr 0005 (HI)
F948 : 76 00 06   ror  $0006          ;rotate right in addr 0006 (LO)
F94B : D6 0F      ldab  $0F           ;load B with value in addr 0F (FMAX)(SET FREQ)
F94D : 7D 00 15   tst  $0015          ;test value in addr 0015 (DSFLG)
F950 : 27 02      beq  LF954          ;branch if Z=1 (FNOIS2)
F952 : D4 05      andb  $05           ;and B with value in addr 05 (HI)(DISTORT FREQ)
;FNOIS2:
F954 : D7 10      stab  $10           ;store B in addr 10 (FHI)
F956 : D6 11      ldab  $11           ;load B with value in addr 11 (FLO)
F958 : 91 06      cmpa  $06           ;compare A with value in addr 06 (LO)
F95A : 22 12      bhi  LF96E          ;branch if C=0 and Z=0 (FNOIS4)
;FNOIS3:
F95C : 09         dex                 ;decr X (SLOPE UP)
F95D : 27 26      beq  LF985          ;branch if Z=1 (FNOIS6)
F95F : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F962 : DB 11      addb  $11           ;add B with value in addr 11 (FLO)
F964 : 99 10      adca  $10           ;A = A + C + value in addr 10 (FHI)
F966 : 25 16      bcs  LF97E          ;branch if C=1 (FNOIS5)
F968 : 91 06      cmpa  $06           ;compare A with value in addr 06 (LO)
F96A : 23 F0      bls  LF95C          ;branch if C=1 and Z=1 (FNOIS3)
F96C : 20 10      bra  LF97E          ;branch always (FNOIS5)
;FNOIS4:
F96E : 09         dex                 ;decr X (SLOPE DOWN)
F96F : 27 14      beq  LF985          ;branch if Z=1 (FNOIS6)
F971 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F974 : D0 11      subb  $11           ;B = B - value in addr 11 (FLO)
F976 : 92 10      sbca  $10           ;A = A - C - value in addr 10 (FHI)
F978 : 25 04      bcs  LF97E          ;branch if C=1 (FNOIS5)
F97A : 91 06      cmpa  $06           ;compare A with value in addr 06 (LO)
F97C : 22 F0      bhi  LF96E          ;branch if C=0 and Z=0 (FNOIS4)
;FNOIS5:
F97E : 96 06      ldaa  $06           ;load A with value in addr 06 (LO)
F980 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F983 : 20 B9      bra  LF93E          ;branch always (FNOIS1)
;FNOIS6:
F985 : D6 14      ldab  $14           ;load B with value in addr 14 (FDFLG)
F987 : 27 B5      beq  LF93E          ;branch if Z=1 (FNOIS1)
F989 : 96 0F      ldaa  $0F           ;load A with value in addr 0F (FMAX)(DECAY MAX FREQ)
F98B : D6 11      ldab  $11           ;load B with value in addr 11 (FLO)
F98D : 44         lsra                ;logic shift right A 
F98E : 56         rorb                ;rotate right B 
F98F : 44         lsra                ;logic shift right A 
F990 : 56         rorb                ;rotate right B 
F991 : 44         lsra                ;logic shift right A 
F992 : 56         rorb                ;rotate right B 
F993 : 43         coma                ;complement 1s A
F994 : 50         negb                ;negate (complement 2s) B
F995 : 82 FF      sbca  #$FF          ;A = A - C - value FFh (#-1)
F997 : DB 11      addb  $11           ;add B with value in addr 11 (FLO)
F999 : 99 0F      adca  $0F           ;A = A + C + value in addr 0F (FMAX)
F99B : D7 11      stab  $11           ;store B in addr 11 (FLO)
F99D : 97 0F      staa  $0F           ;store A in addr 0F (FMAX)
F99F : 26 98      bne  LF939          ;branch if Z=0 (FNOIS0)
F9A1 : C1 07      cmpb  #$07          ;compare B with value 07h
F9A3 : 26 94      bne  LF939          ;branch if Z=0 (FNOIS0)
F9A5 : 39         rts                 ;return subroutine
;*************************************;
;Radio 
;*************************************;
;RADIO
F9A6 : 86 FD      ldaa  #$FD          ;load A with value FDh (#RADSND/$100 SOUND TABLE)(1st byte of addr:FD)
F9A8 : 97 0B      staa  $0B           ;store B in addr 0B (XPTR)
F9AA : CE 00 64   ldx  #$0064         ;load X with value 0064h (#100)(STARTING FREQ)
F9AD : DF 07      stx  $07            ;store X in addr 07 (TEMPX)
;RADIO1:
F9AF : DB 08      addb  $08           ;add B with value in addr 08 (TEMPX+1)(ADD FREQ TO TIMER)
F9B1 : 96 0D      ldaa  $0D           ;load A with value in addr 0D (TEMPA)
F9B3 : 99 07      adca  $07           ;A = A + C + value in addr 07 (TEMPX)
F9B5 : 97 0D      staa  $0D           ;store A in addr 0D (TEMPA)
F9B7 : DE 07      ldx  $07            ;load X with value in addr 07 (TEMPX)
F9B9 : 25 04      bcs  LF9BF          ;branch if C=1 (RADIO2)
F9BB : 20 00      bra  LF9BD          ;branch always (*+2)(EQUALIZE TIME)
F9BD : 20 03      bra  LF9C2          ;branch always (RADIO3)
;RADIO2:
F9BF : 08         inx                 ;incr X (CARRY?, RAISE FREQ)
F9C0 : 27 11      beq  LF9D3          ;branch if Z=1 (RADIO4)(DONE?)
;RADIO3:
F9C2 : DF 07      stx  $07            ;store X in addr 07 (TEMPX)
F9C4 : 84 0F      anda  #$0F          ;and A with value 0Fh (SET POINTER)
F9C6 : 8B 84      adda  #$84          ;add A with value 84h (RADSND!.$FF)(2nd byte of addr:84)
F9C8 : 97 0C      staa  $0C           ;store A in addr 0C (XPTR+1)
F9CA : DE 0B      ldx  $0B            ;load X with value in addr 0B (XPTR)
F9CC : A6 00      ldaa  $00,x         ;load A with value in addr X + 00h
F9CE : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F9D1 : 20 DC      bra  LF9AF          ;branch always (RADIO1)
;RADIO4:
F9D3 : 39         rts                 ;return subroutine
;*************************************;
;Hyper 
;*************************************;
;HYPER
F9D4 : 4F         clra                ;clear A 
F9D5 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F9D8 : 97 0D      staa  $0D           ;store A in addr 0D (TEMPA)(ZERO PHASE)
;HYPER1:
F9DA : 4F         clra                ;clear A (ZERO TIME COUNTER)
;HYPER2:
F9DB : 91 0D      cmpa  $0D           ;compare A with value in addr 0D (TEMPA)
F9DD : 26 03      bne  LF9E2          ;branch if Z=0 (HYPER3)
F9DF : 73 04 00   com  $0400          ;complement 1s in DAC output SOUND (PHASE EDGE?)
;HYPER3:
F9E2 : C6 12      ldab  #$12          ;load B with value 12h (DELAY)
;HYPER4:
F9E4 : 5A         decb                ;decr B
F9E5 : 26 FD      bne  LF9E4          ;branch if Z=0 (HYPER4)
F9E7 : 4C         inca                ;incr A (ADVANCE TIME COUNTER)
F9E8 : 2A F1      bpl  LF9DB          ;branch if N=0 (HYPER2)
F9EA : 73 04 00   com  $0400          ;complement 1s in DAC output SOUND (CYCLE DONE?, CYCLE EDGE)
F9ED : 7C 00 0D   inc  $000D          ;incr value in addr 000D (TEMPA)(NEXT PHASE)
F9F0 : 2A E8      bpl  LF9DA          ;branch if N=0 (HYPER1)(DONE?)
F9F2 : 39         rts                 ;return subroutine
;*************************************;
;Scream 
;*************************************;
;SCREAM
F9F3 : CE 00 0F   ldx  #$000F         ;load X with value 000Fh (#STABLE ZERO FREQS AND TIMES)
;SCREM1:
F9F6 : 6F 00      clr  $00,x          ;clear addr X + 00h
F9F8 : 08         inx                 ;incr X
F9F9 : 8C 00 17   cpx  #$0017         ;compare X with value 0017h (#SRMEND)
F9FC : 26 F8      bne  LF9F6          ;branch if Z=0 (SCREM1)
F9FE : 86 40      ldaa  #$40          ;load A with value 40h (START FIRST ECHO)
FA00 : 97 0F      staa  $0F           ;store A in addr 0F (STABLE+FREQ)
;SCREM2:
FA02 : CE 00 0F   ldx  #$000F         ;load X with value 000Fh (#STABLE INITIALIZE COUNTER)
FA05 : 86 80      ldaa  #$80          ;load A with value 80h (INITIALIZE AMPLITUDE)
FA07 : 97 0D      staa  $0D           ;store A in addr 0D (TEMPA)
FA09 : 5F         clrb                ;clear B (ZERO OUTPUT BUFFER)
;SCREM3:
FA0A : A6 01      ldaa  $01,x         ;load A with value in addr X + 01h (TIMER,X ADD FREQ TO TIMER)
FA0C : AB 00      adda  $00,x         ;add A with value in addr X +00h (FREQ)
FA0E : A7 01      staa  $01,x         ;store A in addr X + 01h (TIMER)
FA10 : 2A 02      bpl  LFA14          ;branch if N=0 (SCREM4)(ADD AMPLITUDE IF MINUS)
FA12 : DB 0D      addb  $0D           ;add B with value at addr 0D (TEMPA)
;SCREM4:
FA14 : 74 00 0D   lsr  $000D          ;logic shift right   in addr 000D (TEMPA)(DECAY AMPLITUDE)
FA17 : 08         inx                 ;incr X (NEXT ECHO)
FA18 : 08         inx                 ;incr X
FA19 : 8C 00 17   cpx  #$0017         ;compare X with value 0017h (#SRMEND LAST ECHO?)
FA1C : 26 EC      bne  LFA0A          ;branch if Z=0 (SCREM3)
FA1E : F7 04 00   stab  $0400         ;store B in DAC output SOUND
FA21 : 7C 00 0E   inc  $000E          ;incr value in addr 000E (TEMPB)(ADVANCE TIMER)
FA24 : 26 DC      bne  LFA02          ;branch if Z=0 (SCREM2)
FA26 : CE 00 0F   ldx  #$000F         ;load X with value 000Fh (#STABLE LOWER NON-ZERO FREQS)
FA29 : 5F         clrb                ;clear B (ALL ZERO NOT FLAG)
;SCREM5:
FA2A : A6 00      ldaa  $00,x         ;load A with value at addr X + 00h (FREQ)
FA2C : 27 0B      beq  LFA39          ;branch if Z=1 (SCREM7)
FA2E : 81 37      cmpa  #$37          ;compare A with value 37h
FA30 : 26 04      bne  LFA36          ;branch if Z=0 (SCREM6)
FA32 : C6 41      ldab  #$41          ;load B with value 41h (START NEXT ECHO)
FA34 : E7 02      stab  $02,x         ;store B in addr X + 02h (FREQ+2)
;SCREM6:
FA36 : 6A 00      dec  $00,x          ;decr value in addr X + 00h (FREQ)
FA38 : 5C         incb                ;incr B (SET FLAG)
;SCREM7:
FA39 : 08         inx                 ;incr X
FA3A : 08         inx                 ;incr X
FA3B : 8C 00 17   cpx  #$0017         ;compare X with value 0017h (#SRMEND)
FA3E : 26 EA      bne  LFA2A          ;branch if Z=0 (SCREM5)
FA40 : 5D         tstb                ;test B=0 (DONE?)
FA41 : 26 BF      bne  LFA02          ;branch if Z=0 (SCREM2)
FA43 : 39         rts                 ;return subroutine
;*************************************;
;Organ Tune 
;*************************************;
;ORGANT
FA44 : 7A 00 04   dec  $0004          ;decr value in addr 0004 (ORGFLG)(MINUS ORGAN FLAG)
FA47 : 39         rts                 ;return subroutine
FA48 : 8D 03      bsr  LFA4D          ;branch sub (ORGNT1)
FA4A : 7E FC DD   jmp  LFCDD          ;jump IRQ3
;ORGNT1:
FA4D : 7F 00 04   clr  $0004          ;clear addr 04 (ORGFLG)
FA50 : 97 0D      staa  $0D           ;store A in addr 0D (TEMPA) (TUNE NUMBER)
FA52 : CE FD 94   ldx  #$FD94         ;load X with FD94 (ORGTAB)
;ORGNT2:
FA55 : A6 00      ldaa  $00,x         ;load A with addr X + 00h (TUNE TABLE LENGTH)
FA57 : 27 2D      beq  LFA86          ;branch Z=1 (ORGNT5) (INVALID TUNE)
FA59 : 7A 00 0D   dec  $000D          ;decr addr 0D (TEMPA)
FA5C : 27 06      beq  LFA64          ;branch Z=1 (ORGNT3)
FA5E : 4C         inca                ;incr A
FA5F : BD FC F0   jsr  LFCF0          ;jump sub ADDX
FA62 : 20 F1      bra  LFA55          ;branch always (ORGNT2)
;ORGNT3:
FA64 : 08         inx                 ;incr X
FA65 : DF 0B      stx  $0B            ;store X in addr 0B (XPTR)(NOTE POINTER)
FA67 : BD FC F0   jsr  LFCF0          ;jump sub ADDX
FA6A : DF 09      stx  $09            ;store X in addr 09 (XPLAY)(TUNE END)
FA6C : DE 0B      ldx  $0B            ;load X in addr 0B (XPTR)
;ORGNT4:
FA6E : A6 00      ldaa  $00,x         ;load A with addr X + 00h (TUNE LOOP)
FA70 : 97 11      staa  $11           ;store A in addr 11 (OSCIL)
FA72 : A6 01      ldaa  $01,x        ;load A with addr X + 01h
FA74 : EE 02      ldx  $02,x          ;load X with addr X + 02h
FA76 : DF 0F      stx  $0F            ;store X in addr 0F (DUR)
FA78 : 8D 0E      bsr  LFA88          ;branch sub (ORGANL)
FA7A : DE 0B      ldx  $0B            ;load X with addr 0B (XPTR)
FA7C : 08         inx                 ;incr X
FA7D : 08         inx                 ;incr X
FA7E : 08         inx                 ;incr X
FA7F : 08         inx                 ;incr X
FA80 : DF 0B      stx  $0B            ;store X in addr 0B (XPTR)
FA82 : 9C 09      cpx  $09            ;comp X with addr 09 (XPLAY)
FA84 : 26 E8      bne  LFA6E          ;branch Z=0 (ORGNT4)
;ORGNT5:
FA86 : 39         rts                 ;return subroutine
;*
;*ORGAN NOTE
;*4 BYTES(MODE,OSCILLATOR MASK HI+1,LO+1,NOTE#)
;ORGANN
FA87 : 39         rts                 ;return subroutine
;*************************************;
;Organ Loader
;*************************************;
;ORGANL
FA88 : CE 00 12   ldx  #$0012         ;load X with 0012h (#RDELAY)
FA8B : 80 02      suba  #$02          ;A = A - 02h 
;LDLP:
FA8D : 23 15      bls  LFAA4          ;branch if lower or same (LD1)
FA8F : 81 03      cmpa  #$03          ;compare A with 03h
FA91 : 27 09      beq  LFA9C          ;branch Z=1 (LD2)
FA93 : C6 01      ldab  #$01          ;load B with 01h (NOP)
FA95 : E7 00      stab  $00,x         ;store B in addr X + 00h
FA97 : 08         inx                 ;incr X
FA98 : 80 02      suba  #$02          ;A = A - 02h
FA9A : 20 F1      bra  LFA8D          ;branch always (LDLP)
;LD2:
FA9C : C6 91      ldab  #$91          ;load B with 91h
FA9E : E7 00      stab  $00,x         ;store B in addr X + 00h
FAA0 : 6F 01      clr  $01,x          ;clear addr X + 01h
FAA2 : 08         inx                 ;incr X       
FAA3 : 08         inx                 ;incr X
;LD1 - (stores 7E FAB2 jmp $FAB2)
FAA4 : C6 7E      ldab  #$7E          ;load B with 7Eh (JMP START2)
FAA6 : E7 00      stab  $00,x         ;store B in addr X + 00h
FAA8 : C6 FA      ldab  #$FA          ;load B with FAh (#ORGAN1!>8 MSB)
FAAA : E7 01      stab  $01,x         ;store B in addr X + 01h
FAAC : C6 B2      ldab  #$B2          ;load B with B2h (#ORGAN1!.$FF LSB)
FAAE : E7 02      stab  $02,x         ;store B in addr X + 02h
;*************************************;
;Organ Routine 
;*************************************;
;DUR=DURATION, OSCILLATOR MASK
;ORGAN
FAB0 : DE 0F      ldx  $0F            ;load X with addr 0F (DUR)
;ORGAN1 
FAB2 : 4F         clra                ;clear A
FAB3 : F6 00 0E   ldab  $000E         ;load B with addr 0E (LOAD B EXTEND TEMPB)
FAB6 : 5C         incb                ;incr B
FAB7 : D7 0E      stab  $0E           ;store B in addr 0E (TEMPB)
FAB9 : D4 11      andb  $11           ;and B with addr 11 (OSCIL)(MASK OSCILLATORS)
FABB : 54         lsrb                ;logic shift right B  
FABC : 89 00      adca  #$00          ;A = Carry + A + 00h 
FABE : 54         lsrb                ;logic shift right B  
FABF : 89 00      adca  #$00          ;A = Carry + A + 00h 
FAC1 : 54         lsrb                ;logic shift right B  
FAC2 : 89 00      adca  #$00          ;A = Carry + A + 00h 
FAC4 : 54         lsrb                ;logic shift right B  
FAC5 : 89 00      adca  #$00          ;A = Carry + A + 00h 
FAC7 : 54         lsrb                ;logic shift right B  
FAC8 : 89 00      adca  #$00          ;A = Carry + A + 00h 
FACA : 54         lsrb                ;logic shift right B  
FACB : 89 00      adca  #$00          ;A = Carry + A + 00h 
FACD : 54         lsrb                ;logic shift right B  
FACE : 89 00      adca  #$00          ;A = Carry + A + 00h 
FAD0 : 1B         aba                 ;A = A + B
FAD1 : 48         asla                ;arith shift left A  
FAD2 : 48         asla                ;arith shift left A  
FAD3 : 48         asla                ;arith shift left A  
FAD4 : 48         asla                ;arith shift left A  
FAD5 : 48         asla                ;arith shift left A  
FAD6 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
FAD9 : 09         dex                 ;decr X
FADA : 27 03      beq  LFADF          ;branch Z=1 (ORGAN2)(NOTE OVER?)
FADC : 7E 00 12   jmp  L0012          ;jump extended addr 0012 (RDELAY)
;ORGAN2:
FADF : 39         rts                 ;return subroutine
;*************************************;
;Parameter Transfer 
;*************************************;
;TRANS
FAE0 : 36         psha                ;push A into stack then SP - 1
;TRANS1:
FAE1 : A6 00      ldaa  $00,x         ;load A in addr X + 00h
FAE3 : DF 09      stx  $09            ;store X in addr 09 (XPLAY)
FAE5 : DE 0B      ldx  $0B            ;load X from value in addr 0B (XPTR)
FAE7 : A7 00      staa  $00,x         ;store A in addr X + 00h
FAE9 : 08         inx                 ;incr X
FAEA : DF 0B      stx  $0B            ;store X in addr 0B (XPTR)
FAEC : DE 09      ldx  $09            ;load X from value in addr 09 (XPLAY)
FAEE : 08         inx                 ;incr X
FAEF : 5A         decb                ;decr B
FAF0 : 26 EF      bne  LFAE1          ;branch if Z=0 (TRANS1)
FAF2 : 32         pula                ;SP + 1 pull stack into A
FAF3 : 39         rts                 ;return subroutine
;*************************************;
;Background End Routine 
;*************************************;
;BGEND
FAF4 : 4F         clra                ;clear A
FAF5 : 97 00      staa  $00           ;store A in addr 00 (BG1FLG)
FAF7 : 97 01      staa  $01           ;store A in addr 01 (BG2FLG)
FAF9 : 39         rts                 ;return subroutine
;*************************************;
;Background Sound #2 increment 
;*************************************;
;BG2INC
FAFA : 7F 00 00   clr  $0000          ;clear addr 0000 (BG1FLG)(KILL BG1)
FAFD : 96 01      ldaa  $01           ;load A with value at addr 01(BG2FLG)(ACTIVATE BG2)
FAFF : 84 7F      anda  #$7F          ;and A with value 7Fh (REMOVE OVERRIDE)
FB01 : 81 1D      cmpa  #$1D          ;compare A with value 1Dh (#BG2MAX)
FB03 : 26 01      bne  LFB06          ;branch if Z=0 (BG2IO)
FB05 : 4F         clra                ;clear A
;BG2IO:
FB06 : 4C         inca                ;incr A
FB07 : 97 01      staa  $01           ;store A in addr 01 (BG2FLG)
FB09 : 39         rts                 ;return subroutine
;*************************************;
;Background 2 Routine 
;*************************************;
;BG2
FB0A : 86 0E      ldaa  #$0E          ;load A with value 0Eh (#(TRBV-SVTAB)/7) (GET SOUND)
FB0C : BD FB 57   jsr  LFB57          ;jump sub (GWLD)
FB0F : 96 01      ldaa  $01           ;load A with value at addr 01 (BG2FLG)
FB11 : 48         asla                ;arith shift left A  
FB12 : 48         asla                ;arith shift left A  
FB13 : 43         coma                ;complement 1s A
FB14 : BD FC 0F   jsr  LFC0F          ;jump sub (GEND60)
;BG2LP:
FB17 : 7C 00 13   inc  $0013          ;incr value in addr 0013 (GDCNT)
FB1A : BD FC 11   jsr  LFC11          ;jump sub (GEND61)
FB1D : 20 F8      bra  LFB17          ;branch always (BG2LP)
;*************************************;
;Spinner #1 Sound 
;*************************************;
;SP1
FB1F : 86 03      ldaa  #$03          ;load A with value 03h (#(CABSHK-VVECT)/9)
FB21 : BD F8 2A   jsr  LF82A          ;jump sub (VARILD)
FB24 : D6 02      ldab  $02           ;load B with value at addr 02 (SP1FLG)
FB26 : C1 1F      cmpb  #$1F          ;compare B with value 1Fh (#SP1MAX-1)
FB28 : 26 01      bne  LFB2B          ;branch if Z=0 (SP1A)
FB2A : 5F         clrb                ;clear B
;SP1A:
FB2B : 5C         incb                ;incr B
FB2C : D7 02      stab  $02           ;store B in addr 02 (SP1FLG)
FB2E : 86 20      ldaa  #$20          ;load A with value 20h (#SP1MAX)
FB30 : 10         sba                 ;A = A - B 
FB31 : 5F         clrb                ;clear B
;SP11:
FB32 : 81 14      cmpa  #$14          ;compare A with value 14h
FB34 : 23 05      bls  LFB3B          ;branch if C and Z = 1 (SP12)
FB36 : CB 0E      addb  #$0E          ;add B with 0Eh
FB38 : 4A         deca                ;decr A
FB39 : 20 F7      bra  LFB32          ;branch always (SP11)
;SP12:
FB3B : CB 05      addb  #$05          ;add B with 05h
FB3D : 4A         deca                ;decr A
FB3E : 26 FB      bne  LFB3B          ;branch if Z=0 (SP12)
FB40 : D7 0F      stab  $0F           ;store B in addr 0F (LOPER)
;SP1LP:
FB42 : BD F8 3F   jsr  LF83F          ;jump sub (VARI) (DO IT)
FB45 : 20 FB      bra  LFB42          ;branch always (SP1LP)
;*************************************;
;Laser Ball Bonus #2 
;*************************************;
;BON2
FB47 : 96 03      ldaa  $03           ;load A with value at addr 03 (B2FLG)
FB49 : 26 09      bne  LFB54          ;branch if Z=0 (BON21)
FB4B : 7C 00 03   inc  $0003          ;incr value at addr 0003 (B2FLG)
FB4E : 86 0D      ldaa  #$0D          ;load A with value 0Dh (#(BONV-SVTAB)/7)
FB50 : 8D 05      bsr  LFB57          ;branch sub (GWLD)
FB52 : 20 69      bra  LFBBD          ;branch always (GWAVE)
;BON21:
FB54 : 7E FC 04   jmp  LFC04          ;jump (GEND50)
;*************************************;
;GWAVE Loader 
;*************************************;
;GWLD:
FB57 : 16         tab                 ;transfer A to B (MULKT BY 7)(sound select x7)
FB58 : 58         aslb                ;arith shift left B 
FB59 : 1B         aba                 ;A = A + B
FB5A : 1B         aba                 ;A = A + B
FB5B : 1B         aba                 ;A = A + B
FB5C : CE FE D6   ldx  #$FED6         ;load X with FED6h (SVTAB)(SOUND VECTOR TABLE)
FB5F : BD FC F0   jsr  LFCF0          ;jump sub ADDX
FB62 : A6 00      ldaa  $00,x         ;load A with value at addr X + 00h
FB64 : 16         tab                 ;transfer A to B
FB65 : 84 0F      anda  #$0F          ;and A with value 0Fh
FB67 : 97 10      staa  $10           ;store A in addr 10 (GCCNT)(GET CYCLE COUNT)
FB69 : 54         lsrb                ;logic shift right B  
FB6A : 54         lsrb                ;logic shift right B  
FB6B : 54         lsrb                ;logic shift right B  
FB6C : 54         lsrb                ;logic shift right B  
FB6D : D7 0F      stab $0F            ;store B in addr 0F (GECHO)(GET #ECHOS)
FB6F : A6 01      ldaa  $01,x         ;load A with value at addr X + 01
FB71 : 16         tab                 ;transfer A to B
FB72 : 54         lsrb                ;logic shift right B  
FB73 : 54         lsrb                ;logic shift right B  
FB74 : 54         lsrb                ;logic shift right B  
FB75 : 54         lsrb                ;logic shift right B  
FB76 : D7 11      stab  $11           ;store B in addr 11 (GECDEC)
FB78 : 84 0F      anda  #$0F          ;and A with value 0Fh (WAVE #)
FB7A : 97 0D      staa  $0D           ;store A in addr 0D (TEMPA)(SAVE)
FB7C : DF 07      stx  $07            ;store X in addr 07 (TEMPX)(SAVE INDEX)
FB7E : CE FE 37   ldx  #$FE37         ;load X with FE37h (GWVTAB)(CALC WAVEFORM ADDR)
;GWLD2:
FB81 : 7A 00 0D   dec  $000D          ;decr value in addr 000D (TEMPA)(WAVE FROM #)
FB84 : 2B 08      bmi  LFB8E          ;branch if N=1 (GWLD3)(FINIS)
FB86 : A6 00      ldaa  $00,x         ;load A with value at addr X + 00h
FB88 : 4C         inca                ;incr A
FB89 : BD FC F0   jsr  LFCF0          ;jump sub ADDX
FB8C : 20 F3      bra  LFB81          ;branch always (GWLD2)
;GWLD3:
FB8E : DF 14      stx  $14            ;store X in addr 14 (GWFRM)
FB90 : BD FC 4B   jsr  LFC4B          ;jump sub (WVTRAN)(XSFER WAVE TO RAM)
FB93 : DE 07      ldx  $07            ;load X with value at addr 07 (TEMPX)(RESTORE INDEX)
FB95 : A6 02      ldaa  $02,x         ;load A with value at addr X + 02h (GET PREDECAY)
FB97 : 97 16      staa  $16           ;store A in addr 16 (PRDECA)
FB99 : BD FC 5D   jsr  LFC5D          ;jump sub (WVDECA) (DECAY IT)
FB9C : DE 07      ldx  $07            ;load X with value at addr 07 (TEMPX)
FB9E : A6 03      ldaa  $03,x         ;load A with value at addr X + 03h (GET FREQ INC)
FBA0 : 97 12      staa  $12           ;store A in addr 12 (GDFINC)
FBA2 : A6 04      ldaa  $04,x         ;load A with value at addr X + 04h (GET DELTA FREQ COUNT)
FBA4 : 97 13      staa  $13           ;store A in addr 13 (GDCNT)
FBA6 : A6 05      ldaa  $05,x         ;load A with value at addr X + 05h (GET PATTERN COUNT)
FBA8 : 16         tab                 ;transfer A to B (SAVE)
FBA9 : A6 06      ldaa  $06,x         ;load A with value at addr X + 06h (PATTERN OFFSET)
FBAB : CE FF 3F   ldx  #$FF3F         ;load X with FF3Fh (#GFRTAB)
FBAE : BD FC F0   jsr  LFCF0          ;jump sub ADDX
FBB1 : 17         tba                 ;transfer B to A (B unchanged)(GET PATTERN LENGTH)
FBB2 : DF 17      stx  $17            ;store X in addr 17 (GWFRQ)(FREQ TABLE ADDR)
FBB4 : 7F 00 1F   clr  $001F          ;clear (00) addr 1F (FOFSET)
FBB7 : BD FC F0   jsr  LFCF0          ;jump sub ADDX
FBBA : DF 19      stx  $0019          ;store X in addr 0019 (FRQEND)
FBBC : 39         rts                 ;return subroutine
;*************************************;
;GWAVE routine 
;*************************************;
;ACCA=Freq Pattern Length, X=Freq Pattern Addr
;GWAVE
FBBD : 96 0F      ldaa  $0F           ;load A in addr 0F (GECHO)
FBBF : 97 1E      staa  $1E           ;store A in addr 1E (GECNT)
;GWT4:
FBC1 : DE 17      ldx  $17            ;load X with value at addr 17 (GWFRQ)
FBC3 : DF 09      stx  $09            ;store X in addr 09 (XPLAY)
;GPLAY:
FBC5 : DE 09      ldx  $09            ;load X with value at addr 09 (XPLAY)(GET NEW PERIOD)
FBC7 : A6 00      ldaa  $00,x         ;load A with value at addr X + 00h
FBC9 : 9B 1F      adda  $1F           ;add A with value at addr 1F (FOFSET)
FBCB : 97 1D      staa  $1D           ;store A in addr 1D (GPER)
FBCD : 9C 19      cpx  $19            ;compare X with value at addr 19 (FRQEND)
FBCF : 27 26      beq  LFBF7          ;branch if Z=1 (GEND)(FINISH ON ZERO)
FBD1 : D6 10      ldab  $10           ;load B with value at addr 10 (GCCNT)(CYCLE COUNT)
FBD3 : 08         inx                 ;incr X
FBD4 : DF 09      stx  $09            ;store X in addr 09 (XPLAY)
;GOUT:
FBD6 : CE 00 20   ldx  #$0020         ;load X with value 0020h (#GWTAB)(SETUP WAVEFORM POINTER)
;GOUTLP:
FBD9 : 96 1D      ldaa  $1D           ;load A with value at addr 1D (GPER)
;GPRLP:
FBDB : 4A         deca                ;decr A (WAIT FOR PERIOD)
FBDC : 26 FD      bne  LFBDB          ;branch if Z=0 (GPRLP)
FBDE : A6 00      ldaa  $00,x         ;load A with value at addr X + 00h (OUTPUT SOUND)
FBE0 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
;GPR1
FBE3 : 08         inx                 ;incr X
FBE4 : 9C 1B      cpx  X001B          ;compare X with value at addr 1B (WVEND)(END OF WAVE?)
FBE6 : 26 F1      bne  LFBD9          ;branch if Z=0 (GOUTLP)
FBE8 : 5A         decb                ;decr B
FBE9 : 27 DA      beq  LFBC5          ;branch if Z=1 (GPLAY)
FBEB : 08         inx                 ;incr X 4 cycles
FBEC : 09         dex                 ;decr X 4 cycles
FBED : 08         inx                 ;incr X 4 cycles
FBEE : 09         dex                 ;decr X 4 cycles
FBEF : 08         inx                 ;incr X 4 cycles
FBF0 : 09         dex                 ;decr X 4 cycles
FBF1 : 08         inx                 ;incr X 4 cycles
FBF2 : 09         dex                 ;decr X 4 cycles
FBF3 : 01         nop                 ;2 cycles
FBF4 : 01         nop                 ;2 cycles (36 total)
FBF5 : 20 DF      bra  LFBD6          ;branch always (GOUT)(SYNC 36)
;GEND
FBF7 : 96 11      ldaa  $11           ;load A with value at addr 11 (GECDEC)
FBF9 : 8D 62      bsr  LFC5D          ;branch sub (WVDECA)
;GEND40
FBFB : 7A 00 1E   dec  $001E          ;decr value at addr 001E (GECNT)(ECHO ON?)
FBFE : 26 C1      bne  LFBC1          ;branch if Z=0 (GWT4)(YES)
FC00 : 96 03      ldaa  $03           ;load A with value at addr 03 (B2FLG)(STOP BONUS)
FC02 : 26 46      bne  LFC4A          ;branch if Z=0 (GEND1)
;GEND50:
FC04 : 96 12      ldaa  $12           ;load A with value at addr 12 (GDFINC)(CONTINUE FOR FREQ MOD SOUNDS)
FC06 : 27 42      beq  LFC4A          ;branch if Z=1 (GEND1)(NO)
FC08 : 7A 00 13   dec  $0013          ;decr value at addr 0013 (GDCNT)(DELTA FREQ OVER?)
FC0B : 27 3D      beq  LFC4A          ;branch if Z=1 (GEND1)(YES...)
FC0D : 9B 1F      adda  $1F           ;add A with value at addr 1F (FOFSET)(UPDATE FREQ OFFSET)
;GEND60:
FC0F : 97 1F      staa  $1F           ;store A in addr 1F (FOFSET)
;GEND61:
FC11 : DE 17      ldx  $17            ;load X with value at addr 17 (GWFRQ)(GET INDEX)
FC13 : 5F         clrb                ;clear B (START FOUND FLAG INIT CLEAR)
;GW0:
FC14 : 96 1F      ldaa  $1F           ;load A with value at addr 1F (FOFSET)(INC OR DEC?)
FC16 : 7D 00 12   tst  $0012          ;test addr 0012 (GDFINC)
FC19 : 2B 06      bmi  LFC21          ;branch if N=1 (GW1)(DEC)
FC1B : AB 00      adda  $00,x         ;add A with value at addr X + 00h (INC)
FC1D : 25 08      bcs  LFC27          ;branch if C=1 (GW2)(CARRY=OVERFLOW)
FC1F : 20 0B      bra  LFC2C          ;branch always (GW2A)
;GW1
FC21 : AB 00      adda  $00,x         ;add A with value at addr X + 00h (DEC)
FC23 : 27 02      beq  LFC27          ;branch if Z=1 (GW2)(OVERFLOW ON EQ)
FC25 : 25 05      bcs  LFC2C          ;branch if C=1 (GW2A)(OVERFLOW IF CARRY CLEAR)
;GW2:
FC27 : 5D         tstb                ;test B (FOUND START YET?)
FC28 : 27 08      beq  LFC32          ;branch if Z=1 (GW2B)(NO)
FC2A : 20 0F      bra  LFC3B          ;branch always (GW3)(YES, THIS IS THE END)
;GW2A
FC2C : 5D         tstb                ;test B 
FC2D : 26 03      bne  LFC32          ;branch if Z=0 (GW2B)(ALREADY FOUND START)
FC2F : DF 17      stx  $17            ;store X in addr 17 (GWFRQ)(FOUND START)
FC31 : 5C         incb                ;incr B
;GW2B:
FC32 : 08         inx                 ;incr X
FC33 : 9C 19      cpx  $19            ;compare X with value at addr 19 (FRQEND)
FC35 : 26 DD      bne  LFC14          ;branch if Z=0 (GW0)(NOT OVER YET)
FC37 : 5D         tstb                ;test B (FOUND START?)
FC38 : 26 01      bne  LFC3B          ;branch if Z=0 (GW3)(YES)
FC3A : 39         rts                 ;return subroutine (ALL OVER)
;GW3
FC3B : DF 19      stx  $19            ;store X in addr 19 (FRQEND)
FC3D : 96 11      ldaa  $11           ;load A with value at addr 11 (GECDEC)(RE:XSFER WAVE?)
FC3F : 27 06      beq  LFC47          ;branch if Z=1 (GEND0)(NO)
FC41 : 8D 08      bsr  LFC4B          ;branch sub (WVTRAN)(XSFER WAVE)
FC43 : 96 16      ldaa  $16           ;load A with value at addr 16 (PRDECA)
FC45 : 8D 16      bsr  LFC5D          ;branch sub (WVDECA)
;GEND0:
FC47 : 7E FB BD   jmp  LFBBD          ;jump (GWAVE)
;GEND1:
FC4A : 39         rts                 ;return subroutine (TERMINATE)
;*************************************;
;Wave Transfer Routine 
;*************************************;
;WVTRAN
FC4B : CE 00 20   ldx  #$0020         ;load X with value 0020h (#GWTAB)
FC4E : DF 0B      stx  $0B            ;store X in addr 0B (XPTR)
FC50 : DE 14      ldx  $14            ;load X with value at addr 14 (GWFRM)
FC52 : E6 00      ldab  $00,x         ;load B with value at addr X + 00h (GET WAVE LENGTH)
FC54 : 08         inx                 ;incr X
FC55 : BD FA E0   jsr  LFAE0          ;jump sub (TRANS)
FC58 : DE 0B      ldx  $0B            ;load X with value at addr 0B (XPTR)
FC5A : DF 1B      stx  $1B            ;store X in addr 1B (WVEND)(GET END ADDR)
FC5C : 39         rts                 ;return subroutine
;*************************************;
;Wave Decay Routinue 
;*************************************;
;decay amount in ACCA 1/16 per decay
;WVDECA
FC5D : 4D         tsta                ;test A 
FC5E : 27 2B      beq  LFC8B          ;branch if Z=1 (WVDCX)(NODECAY)
FC60 : DE 14      ldx  $14            ;load X with value at addr 14 (GWFRM)(ROM WAVE INDEX)
FC62 : DF 09      stx  $09            ;store X in addr 09 (XPLAY)
FC64 : CE 00 20   ldx  #$0020         ;load X with value 0020h (#GWTAB)
FC67 : 97 0E      staa  $0E           ;store A in addr 0E (TEMPB)(DECAY FACTOR)
;WVDLP:
FC69 : DF 0B      stx  $0B            ;store X in addr 0B (XPTR)
FC6B : DE 09      ldx  $09            ;load X with value in addr 09 (XPLAY)
FC6D : D6 0E      ldab  $0E           ;load B with vlaue in addr 0E (TEMPB)
FC6F : D7 0D      stab  $0D           ;store B in addr 0D (TEMPA)(DECAY FACTOR TEMP)
FC71 : E6 01      ldab  $01,x         ;load B with value in addr X + 01h (OFFSET FOR WAVE LENGTH)
FC73 : 54         lsrb                ;logic shift right B  
FC74 : 54         lsrb                ;logic shift right B  
FC75 : 54         lsrb                ;logic shift right B  
FC76 : 54         lsrb                ;logic shift right B  (CALC 1/16TH)
FC77 : 08         inx                 ;incr X
FC78 : DF 09      stx  $09            ;store X in addr 09 (XPLAY)
FC7A : DE 0B      ldx  $0B            ;load X with value at addr 0B (XPTR)
FC7C : A6 00      ldaa  $00,x         ;load A with value at addr X + 00h
;WVDLP1:
FC7E : 10         sba                 ;A = A - B (DECAY)
FC7F : 7A 00 0D   dec  $000D          ;decr value in addr 000D (TEMPA)
FC82 : 26 FA      bne  LFC7E          ;branch if Z=0 (WVDLP1)
FC84 : A7 00      staa  $00,x         ;store A in addr X + 00h
FC86 : 08         inx                 ;incr X
FC87 : 9C 1B      cpx  $1B            ;compare X with value at addr 1B (WVEND)(END OF WAVE?)
FC89 : 26 DE      bne  LFC69          ;branch if Z=0 (WVDLP)(NO)
;WVDCX:
FC8B : 39          rts                ;return subroutine
;*************************************;
;Interrupt Processing
;*************************************;
;IRQ
FC8C : 8E 00 7F   lds  #$007F         ;load SP with value 007Fh (#ENDRAM)
FC8F : B6 04 02   ldaa  $0402         ;load A with addr 0402 (PIA sound select)
FC92 : 0E         cli                 ;clear interrupt (I=0) (NOW ALLOW IRQS)
FC93 : 43         coma                ;complement 1s A (INVERT INPUT)
FC94 : 84 1F      anda  #$1F          ;and A with value 1F (MASK GARB)
FC96 : D6 04      ldab  $04           ;load B with value at addr 04 (ORGFLG)
FC98 : 27 03      beq  LFC9D          ;branch if Z=1 (IRQ00)
FC9A : BD FA 48   jsr  LFA48          ;jump sub (ORGNT1)(ORGAN TUNE)
;IRQ00:
FC9D : 5F         clrb                ;clear B 
FC9E : 81 0E      cmpa  #$0E          ;compare A with value 0Eh (#SP1SND)
FCA0 : 27 02      beq  LFCA4          ;branch if Z=1 (IRQ00A)
FCA2 : D7 02      stab  $02           ;store B in addr 02 (SP1FLG)
;IRQ00A:
FCA4 : 81 12      cmpa  #$12          ;compare A with value 12h (#B2SND)
FCA6 : 27 02      beq  LFCAA          ;branch if Z=1 (IRQ000)
FCA8 : D7 03      stab  $03           ;store B in addr 03 (B2FLG)
;IRQ1:
FCAA : 4D         tsta                ;test A 
FCAB : 27 30      beq  LFCDD          ;branch if Z=1 (IRQ3)(INVALID INPUT)
FCAD : 4A         deca                ;decr A (REMOVE OFFSET)
FCAE : 81 0C      cmpa  #$0C          ;compare A with value 0Ch
FCB0 : 22 11      bhi  LFCC3          ;branch if C and Z=0 (IRQ10)
FCB2 : 81 03      cmpa  #$03          ;compare A with value 03h
FCB4 : 26 05      bne  LFCBB          ;branch if Z=0 (LFCBB)
FCB6 : BD FC FE   jsr  LFCFE          ;jump sub TILT
FCB9 : 20 22      bra  LFCDD          ;branch always (IRQ3)
;LFCBB:
FCBB : BD FB 57   jsr  LFB57          ;jump sub (GWLD)(GWAVE SOUNDS)
FCBE : BD FB BD   jsr  LFBBD          ;jump sub (GWAVE)
FCC1 : 20 1A      bra  LFCDD          ;branch always (IRQ3)
;IRQ10:
FCC3 : 81 1B      cmpa  #$1B          ;compare A with value 1Bh (SPECIAL SOUND?)
FCC5 : 22 0E      bhi  LFCD5          ;branch if C and Z=0 (IRQ20)(VARI SOIUND)
FCC7 : 80 0D      suba  #$0D          ;A = A - 0Dh (SUB OFFSET)
FCC9 : 48         asla                ;arith shift left A   (DOUBLE FOR ADDRESSING)
FCCA : CE FD 42   ldx  #$FD42         ;load X with value FD42h (#JMPTBL)(INDEX TO JUMP TABLE)(VWTAB)
FCCD : 8D 21      bsr  LFCF0          ;branch sub ADDX (GET CORRECT INDEX)
FCCF : EE 00      ldx  $00,x          ;load X with value at addr X + 00h (GET ADDRESS TO INDEX)
FCD1 : AD 00      jsr  $00,x          ;jump sub addr X + 00h (PERFORM IT)
FCD3 : 20 08      bra  LFCDD          ;branch always (IRQ3)
;IRQ20:
FCD5 : 80 1C      suba  #$1C          ;A = A - 1Ch
FCD7 : BD F8 2A   jsr  LF82A          ;jump sub (VARILD)
FCDA : BD F8 3F   jsr  LF83F          ;jump sub (VARI)
;IRQ3:
FCDD : 96 00      ldaa  $00           ;load A with value at addr 00 (BG1FLG)(BGROUND ACTIVE)
FCDF : 9A 01      oraa  $01           ;OR A with value at addr 01 (B2FLG)
FCE1 : 27 FE      beq  LFCE1          ;branch if Z=1 here (NOPE)
FCE3 : 4F         clra                ;clear A 
FCE4 : 97 03      staa  $03           ;store A in addr 03 (B2FLG)(KILL BONUSES)
FCE6 : 96 00      ldaa  $00           ;load A with value in addr 00 (BG1FLG)
FCE8 : 27 03      beq  LFCED          ;branch if Z=1 (IRQXX)
FCEA : 7E F9 13   jmp  LF913          ;jump (BG1)
;IRQXX:
FCED : 7E FB 0A   jmp  LFB0A          ;jump (BG2)
;*************************************;
;Add A to Index Register 
;*************************************;
;ADDX
FCF0 : DF 09      stx  $09            ;store X in addr 09 (XPLAY)
FCF2 : 9B 0A      adda  $0A           ;add A with value in addr 0A (XPLAY+1)
FCF4 : 97 0A      staa  $0A           ;store A in addr 0A (XPLAY+1)
FCF6 : 24 03      bcc  LFCFB          ;branch if C=0 (ADDX1)
FCF8 : 7C 00 09   inc  X0009          ;incr value in addr 0009 (XPLAY)
;ADDX1:
FCFB : DE 09      ldx  $09            ;load X with value at addr 09 (XPLAY)
FCFD : 39         rts                 ;return subroutine
;*************************************;
;Tilt, buzz saw down sound
;*************************************;
;TILT
FCFE : CE 00 E0   ldx  #$00E0         ;load X with 00E0h
;TILT1
FD01 : 86 20      ldaa  #$20          ;load A with value 20h
FD03 : 8D EB      bsr  LFCF0          ;branch sub ADDX
;TILT2
FD05 : 09         dex                 ;decr X
FD06 : 26 FD      bne  LFD05          ;branch Z=0 TILT2
FD08 : 7F 04 00   clr  $0400          ;clear in DAC output SOUND
;TILT3
FD0B : 5A         decb                ;decr B
FD0C : 26 FD      bne  LFD0B          ;branch Z=0 TILT3
FD0E : 73 04 00   com  $0400          ;complement 1s in DAC output SOUND
FD11 : DE 09      ldx  $09            ;load X with value in addr 09
FD13 : 8C 10 00   cpx  #$1000         ;compare X with value 1000h
FD16 : 26 E9      bne  LFD01          ;branch Z=0 TILT1
FD18 : 39         rts                 ;return subroutine
;*************************************;
;Diagnostic Processing Here 
;*************************************;
;NMI
FD19 : 0F         sei                 ;set interrupt mask
FD1A : 8E 00 7F   lds  #$007F         ;load SP with 007Fh (#ENDRAM)
FD1D : CE FF FF   ldx  #$FFFF         ;load X with FFFFh
FD20 : 5F         clrb                ;clear B
;NMI1:
FD21 : E9 00      adcb  $00,x         ;B = Carry + B + addr X +00h
FD23 : 09         dex                 ;decr X
FD24 : 8C F8 00   cpx  #$F800         ;compare X with F800h (78h)
FD27 : 26 F8      bne  LFD21          ;branch Z=0 (NMI1)
FD29 : E1 00      cmpb  $00,x         ;compare B with addr X + 00h
FD2B : 27 01      beq  LFD2E          ;branch Z=1 (NMI2)
FD2D : 3E         wai                 ;wait interrupt
;NMI2:
FD2E : 86 01      ldaa  #$01          ;load A with 01h 
FD30 : BD F8 2A   jsr  LF82A          ;jump sub (VARILD)
FD33 : BD F8 3F   jsr  LF83F          ;jump sub (VARI)
FD36 : 86 02      ldaa  #$02          ;load A with 02h
FD38 : BD FA 4D   jsr  LFA4D          ;jump sub (ORGNT1)
FD3B : 86 01      ldaa  #$01          ;load A with 01h 
FD3D : BD FA 4D   jsr  LFA4D          ;jump sub (ORGNT1)
FD40 : 20 D7      bra  LFD19          ;branch always (NMI) (KEEP LOOPING)
;*************************************;
;Special Routine Jump Table (VWTAB)
;*************************************;
;JMPTBL
FD42 : FB 1F                          ;(SP1)
FD44 : F9 13                          ;(BG1)
FD46 : FA FA                          ;(BG2INC)
FD48 : F8 8C                          ;(LITE)
FD4A : FB 47                          ;(BON2)
FD4C : FA F4                          ;(BGEND)
FD4E : F8 CD                          ;(TURBO)
FD50 : F8 94                          ;(APPEAR)
FD52 : F9 1C                          ;(THRUST)
FD54 : F9 23                          ;(CANNON)
FD56 : F9 A6                          ;(RADIO)
FD58 : F9 D4                          ;(HYPER)
FD5A : F9 F3                          ;(SCREAM)
FD5C : FA 44                          ;(ORGANT)
FD5E : FA 87                          ;(ORGANN)
;*************************************;
;VARI VECTORS
;*************************************;
;VVECT EQU *
FD60 : 40 01 00 10 E1 00 80 FF FF     ;SAW
FD69 : 28 01 00 08 81 02 00 FF FF     ;FOSHIT 
FD72 : 28 81 00 FC 01 02 00 FC FF     ;QUASAR
FD7B : FF 01 00 18 41 04 80 00 FF     ;CABSHK 
;*************************************;
;Radio Sound Waveform
;*************************************;
FD84 : 8C 5B B6 40 BF 49 A4 73        ;RADSND
FD8C : 73 A4 49 BF 40 B6 5B 8C 
;*************************************;
;Organ Tune Table
;*************************************;
; Oscillator Mask(1), Delay(1), Duration(2)
;ORGTAB
;PHANTOM
FD94 : 0C                             ;FCB 3*4
;
FD95 : 7F 1D 0F FB
;$7F1D,TD/PHANC/2*1  D2 1/4  NOTE
FD99 : 7F 23 0F 15
;$7F23,TCS/PHANC/2*1  CS2 1/4 NOTE  
FD9D : FE 08 50 8A
;$FE08,(TFS/PHANC/1*1)*2  FS1 1 NOTE
;
;TACCATA
FDA1 : 88                             ;FCB 34*4
;
FDA2 : 3E 3F 02 3E
;$3E3F,TA/TACC/8*1  A3 1/16 NOTE
FDA6 : 7C 04 03 FF
;$7C04,TG/TACC/8*1  G2 1/16 NOTE 
FDAA : 3E 3F 2C E2
;$3E3F,TA/TACC/2*5  A3 5/4  NOTE 
FDAE : 7C 12 0D 74
;$7C12,TE/TACC/2*1  E2 1/4  NOTE 
FDB2 : 7C 0D 0E 41
;$7C0D,TF/TACC/2*1  F2 1/4  NOTE  
FDB6 : 7C 23 0B 50
;$7C23,TCS/TACC/2*1  CS2 1/4  NOTE 
FDBA : 7C 1D 29 F2
;$7C1D,TD/TACC/4*7  D2 7/8  NOTE  
FDBE : 7C 3F 02 3E 
;$7C3F,TA/TACC/8*1  A2 1/16 NOTE
FDC2 : F8 04 03 FF
;$F804,TG/TACC/8*1  G1 1/16 NOTE
FDC6 : 7C 3F 2C E2
;$7C3F,TA/TACC/2*5  A2 5/4  NOTE
FDCA : F8 12 0D 74
;$F812,TE/TACC/2*1  E1 1/4  NOTE  
FDCE : F8 0D 0E 41 
;$F80D,TF/TACC/2*1  F1 1/4  NOTE  
FDD2 : F8 23 0B 50
;$F823,TCS/TACC/2*1  CS1 1/4  NOTE 
FDD6 : F8 1D 2F F2
;$F81D,(TD/TACC/1*1)*2  D1 1  NOTE   
FDDA : F8 23 05 A8 
;$F823,TCS/TACC/4*1  CS1 1/8  NOTE
FDDE : F8 12 06 BA 
;$F812,TE/TACC/4*1  E1 1/8  NOTE
FDE2 : F8 04 07 FF 
;$F804,TG/TACC/4*1  G1 1/8  NOTE 
FDE6 : 7C 37 04 C1 
;$7C37,TBF/TACC/4*1  BF2 1/8  NOTE 
FDEA : 7C 23 05 A8 
;$7C23,TCS/TACC/4*1  CS2 1/8  NOTE 
FDEE : 7C 12 06 BA 
;$7C12,TE/TACC/4*1  E2 1/8  NOTE 
FDF2 : 3E 04 07 FF 
;$3E04,TG/TACC/4*1  G3 1/8  NOTE 
FDF6 : 3E 37 04 C1 
;$3E37,TBF/TACC/4*1  BF3 1/8  NOTE 
FEFA : 3E 23 05 A8 
;$3E23,TCS/TACC/4*1  CS3 1/8  NOTE 
FEFE : 1F 12 06 BA 
;$1F12,TE/TACC/4*1  E4 1/8  NOTE 
FE02 : 1F 04 07 FF 
;$1F04,TG/TACC/4*1  G4 1/8  NOTE 
FE06 : 1F 37 04 C1 
;$1F37,TBF/TACC/4*1  BF4 1/8  NOTE 
FE0A : 1F 23 16 A0 
;$1F23,TCS/TACC/1*1  CS4 1/2  NOTE 
FE0E : FE 1D 17 F9 
;$FE1D,TD/TACC/1*1  D1 1/2  NOTE 
FE12 : 7F 37 13 06 
;$7F37,TBF/TACC/1*1  BF2 1/2  NOTE 
FE16 : 7F 3F 08 FA 
;$7F3F,TA/TACC/2*1  A2 1/4  NOTE
FE1A : FE 04 0F FF 
;$FE04,TG/TACC/2*1  G1 1/4  NOTE
FE1E : FE 0D 0E 41 
;$FE0D,TF/TACC/2*1  F1 1/4  NOTE
FE22 : FE 23 0B 50 
;$FE23,TCS/TACC/2*1  CS1 1/4  NOTE 
FE26 : FE 1D 5F E4 
;$FE1D,(TD/TACC/1*2)*2  D1 2  NOTE 
FE2A : 00
; LAST TUNE 
;*************************************;
;Organ Note Table
;*************************************;
;NOTTAB
FE2B : 47 3F 37 30 29 23 
;note  AF A  BF B  C  CS
FE31 : 1D 17 12 0D 08 04
;note  D  E  FE F  FS G
;*************************************;
;GWVTAB - Wave table, 1st byte wavelength
;*************************************;
FE37 : 08                             ;GS2
FE38 : 7F D9 FF D9 7F 24 00 24        ;
;
FE40 : 08                             ;GSSQR2
FE41 : 00 40 80 00 FF 00 80 40        ;
;
FE49 : 10                             ;GS1
FE4A : 7F B0 D9 F5 FF F5 D9 B0        ;
FE52 : 7F 4E 24 09 00 09 24 4E        ;
;
FE5A : 10                             ;GS12
FE5B : 7F C5 EC E7 BF 8D 6D 6A        ;
FE63 : 7F 94 92 71 40 17 12 39        ;
;
FE6B : 10                             ;GSQ22
FE6C : FF FF FF FF 00 00 00 00        ;
FE74 : FF FF FF FF 00 00 00 00        ;
;
FE7C : 48                             ;GS72
FE7D : 8A 95 A0 AB B5 BF C8 D1        ;
FE85 : DA E1 E8 EE F3 F7 FB FD        ;
FE8D : FE FF FE FD FB F7 F3 EE        ;
FE95 : E8 E1 DA D1 C8 BF B5 AB        ;
FE9D : A0 95 8A 7F 75 6A 5F 54        ;
FEA5 : 4A 40 37 2E 25 1E 17 11        ;
FEAD : 0C 08 04 02 01 00 01 02        ;
FEB5 : 04 08 0C 11 17 1E 25 2E        ;
FEBD : 37 40 4A 54 5F 6A 75 7F        ;
;
FEC6 : 10                             ;GS1.7
FEC7 : 59 7B 98 AC B3 AC 98 7B        ;
;
;unknown
FECE : 59 37 19 06 00 06 19 37        ;
;*************************************;
;SVTAB - GWAVE SOUND VECTOR TABLE
;*************************************;
;b0 GECHO,GCCNT
;b1 GECDEC,WAVE#
;b2 PREDECAY FACTOR
;b3 GDFINC
;b4 VARIABLE FREQ COUNTER
;b5 FREQ PATTERN LENGTH
;b6 FREQ PATTERN OFFSET

FED6 : 81 24 00 00 00 16 31           ;HBDV 
;$81,$24,0,0,0,22,HBDSND-GFRTAB 1
FEDD : 12 05 1A FF 00 27 6D           ;STDV 
;$12,$05,$1A,$FF,0,39,STDSND-GFRTAB 2
FEE4 : 11 05 11 01 0F 01 47           ;DP1V
;$11,$05,$11,1,15,1,SWPAT-GFRTAB 3
FEEB : 11 31 00 01 00 0D 1B           ;XBV
;$11,$31,0,1,0,13,SPNSND-GFRTAB 4
FEF2 : F4 12 00 00 00 14 47           ;BBSV
;$F4,$12,$0,0,0,20,BBSND-GFRTAB 5
FEF9 : 41 45 00 00 00 0F 5B           ;HBEV
;$41,$45,0,0,0,15,HBESND-GFRTAB 6
FE00 : 21 35 11 FF 00 0D 1B           ;PROTV
;$21,$35,$11,$FF,0,13,SPNSND-GFRTAB 7
FE07 : 15 00 00 FD 00 01 69           ;SPNRV
;$15,$00,0,$FD,0,1,SPNR-GFRTAB 8
FF0E : 31 11 00 01 00 03 6A           ;CLDWNV
;$31,$11,0,1,0,3,COOLDN-GFRTAB 9
FF15 : 01 15 01 01 01 01 47           ;SV3
;$01,$15,1,1,1,1,BBSND-GFRTAB 10
FF1C : F6 53 03 00 02 06 94           ;ED10
;$F6,$53,3,0,2,6,ED10FP-GFRTAB 11 
FF23 : 6A 10 02 00 02 06 9A           ;ED12
;$6A,$10,2,0,2,6,ED13FP-GFRTAB 12
FF2A : 1F 12 00 FF 10 04 69           ;ED17
;$1F,$12,0,$FF,$10,4,SPNR-GFRTAB 13 
FF31 : 31 11 00 FF 00 0D 00           ;BONV
;$31,$11,0,$FF,0,13,BONSND-GFRTAB
FF38 : 12 06 00 FF 01 09 28           ;TRBV
;$12,$06,$0,$FF,1,9,TRBPAT-GFRTAB
;*************************************;
;GFRTAB - GWAVE FREQ PATTERN TABLE
;*************************************; 
;Bonus Sound
FF3F : A0 98 90 88 80 78 70 68        ;BONSND
FF47 : 60 58 50 44 40
;Hundred Point Sound
FF4C : 01 01 02 02 04 04 08 08        ;HBTSND
FF54 : 10 10 30 60 C0 E0 
;Spinner Sound
FF5A : 01 01 02 02 03 04 05 06        ;SPNSND
FF62 : 07 08 09 0A 0C
;Turbine Start Up
FF67 : 80 7C 78 74 70 74 78 7C        ;TRBPAT
FF6F : 80
;Heartbeat Distorto 
FF70 : 01 01 02 02 04 04 08 08        ;HBDSND
FF78 : 10 20 28 30 38 40 48 50
FF80 : 60 70 80 A0 B0 C0
;*
;SWPAT - SWEEP PATTERN
;*
;BigBen Sounds
FF86 : 08 40 08 40 08 40 08 40 08 40  ;BBSND
FF90 : 08 40 08 40 08 40 08 40 08 40
;Heartbeat Echo
FF9A : 01 02 04 08 09 0A 0B 0C        ;HBESND
FFA2 : 0E 0F 10 12 14 16
;Spinner Sound "Drip"
FFA8 : 40                             ;SPNR
;Cool Downer
FFA9 : 10 08 01                       ;COOLDN 
;Start Distorto Sound
FFBC : 01 01 01 01 02 02 03 03        ;STDSND 
FFC4 : 04 04 05 06 08 0A 0C 10 
FFCC : 14 18 20 30 40 50 40 30 
FFC4 : 20 10 0C 0A 08 07 06 05 
FFCC : 04 03 02 02 01 01 01
;Ed's Sound 10
FFD3 : 07 08 09 0A 0C 08              ;ED10FP
;Ed's Sound 13
FFD9 : 17 18 19 1A 1B 1C 00 00 00     ;ED13FP - MATCH THE PROMS  
;*************************************;
;zero padding
FFE2 : 00 00 00 00 00 00 00 00
FFEA : 00 00 00 00 00 00 00 00 
FFF2 : 00 00 00 00 00 00 
;*************************************;
;Motorola vector table
;*************************************;
FFF8 : FC 8C                          ;IRQ 
FFFA : F8 01                          ;RESET SWI (software) 
FFFC : FD 19                          ;NMI 
FFFE : F8 01                          ;RESET (hardware) 
;--------------------------------------------------------------

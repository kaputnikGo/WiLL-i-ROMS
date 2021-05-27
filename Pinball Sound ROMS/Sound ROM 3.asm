        ;
        ;  Disassembled by:
        ;    DASMx object code disassembler
        ;    (c) Copyright 1996-2003   Conquest Consultants
        ;    Version 1.40 (Oct 18 2003)
        ;
        ;  File:    Firepower.716
        ;
        ;  Size:    2048 bytes
        ;  Checksum:  BDCA
        ;  CRC-32:    55A10D13
        ;
        ;  Date:    Mon May 10 21:42:57 2021
        ;
        ;  CPU:    Motorola 6800 (6800/6802/6808 family)
        ;
        ;Firepower, 1980, System 6, Pinball Sound ROM 3 - released February 1980
        ; (speech rom 6 copyright message is dated 30 October 1979)
        ;
        ;Speech ROMs: 5($C000), 6($D000), 7($B000) -- ROM 4($E000) not used
        ; part num :  5T 4972 , 5T 4973 , 5T 4971
        ;
        ;
        ;IC1 Continuously Variable Slope Delta Modulator/Demodulator
        ;C-8226 Speech Board uses MC3417 
        ;C-8228 Speech Board uses MC55516
        ;
        ;Speech Clock uses PIA-CB2 Peripheral Control - output mode is TTL compatible
        ;Speech clck SPCH ROM -> sound PIA CB2 (0403) pin 19 -> IC1 CLin pin14(3417) or pin9(55516)
        ;
        ;Speech Data uses PIA-CA2 Peripheral Control - output mode is TTL compatible
        ;Speech data SPCH ROM -> sound PIA CA2 (0401) pin 39 -> IC1 DIn  pin13(3417) or pin12(55516)
        ;
        ;Write to bit3 of CB2 from LO(37h) to HI(3Fh) to LO(37h) for clock (TKSC)(0011 x111)
        ; then write bit3 of CA2 from LO(34h) to HI(3Ch) to LO(34h) for data (TKSD)(0011 x100)
        ;
        ; Diagnostic plays these words in this order:
        ;[Vocab         ROM ID    IC]
        ;"FIRE"         5T 4971   7
        ;"POWER:        5T 4971   7
        ;"ONE"          5T 4971   7
        ;"TWO"          5T 4971   7
        ;"THREE"        5T 4972   5
        ;"ENEMY"        5T 4972   5
        ;"DESTROYED"    5T 4972   5
        ;"MISSION"      5T 4972   5 and 5T 4973  6
        ;"ACCOMPLISHED" 5T 4973   6
        ;"YOU"          5T 4973   6
        ;"ARE"          5T 4973   6
        ;
        ;note: making a lot of assumptions about speech data
        ;
        ;Note: need to figure out IRQ counter $0009, 
        ;is incr at IRQ call, read in ROM6, masked(0-15), asl'd(x2) and 
        ;then addx to get one of 16 JMPTBL addrs for speech ROM phonemes locations
        ;
        ;updated 15 May 2021
        ;
;*
;*SYSTEM CONSTANTS
;*
ROM      EQU  $F800
SOUND    EQU  $400
ENDRAM   EQU  $7F
VECTOR   EQU  $FFF8    ;RESET,INT VECTORS
WVELEN   EQU  72
BG2MAX   EQU  29
SP1SND   EQU  $0E      ;SPINNER SOUND #1 CODE
B2SND    EQU  $12      ;BONUS SOUND #2 CODE
SP1MAX   EQU  32
;*
;* TALKING EQUATES
;*
TALK     EQU  $DFFD    ;ENTRY TO TALKING         : SPEECH ROM ADDR
TALKD    EQU  $DFFA    ;ENTRY FOR DIAGNOSTICS    :  "      "    "
;
;*
;*GLOBALS
;*
         ORG  0        ;DESCRIPTION              : ADDR
TLKGL    RMB  4        ;TALKING GLOBALS          : 0000-0003
BG1FLG   RMB  1        ;BACKGROUND SOUND 1       : 0004
BG2FLG   RMB  1        ;BACKGROUND SOUND 2       : 0005
SP1FLG   RMB  1        ;SPINNER FLAG             : 0006
B2FLG    RMB  1        ;BONUS #2 FLAG            : 0007
B1FLG    RMB  1        ;BONUS #1 FLAG            : 0008
??       RMB  1        ;IRQ COUNTER              : 0009 <-- counter(?) for speech ROM jumps
HI       RMB  1        ;RANDOM SEED              : 000A
LO       RMB  1        ;RANDOM SEED              : 000B
;*
;*TEMPORARIES
;*
TMPRAM   EQU  *        ;TEMPORARY RAM
TEMPX    RMB  2        ;X TEMPS                  : 000C-000D
XPLAY    RMB  2        ;                         : 000E-000F
XPTR     RMB  2        ;                         : 0010-0011
TEMPA    RMB  1        ;ACCA TEMP                : 0012
TEMPB    RMB  1        ;                         : 0013
LOCRAM   EQU  *        ;                         : 0014
;*
;*GWAVE PARAMETERS
;*
         ORG  LOCRAM
GECHO    RMB  1        ;ECHO FLAG                : 0014
GCCNT    RMB  1        ;CYCLE COUNT              : 0015
GECDEC   RMB  1        ;# OF DECAYS PER ECHO     : 0016
GDFINC   RMB  1        ;DELTA FREQ INC           : 0017
GDCNT    RMB  1        ;DELTA FREQ COUNT         : 0018
GWFRM    RMB  2        ;WAVEFORM ADDRESS         : 0019-001A
;*TEMPORARY OR COMPUTED PARAMETERS
PRDECA   RMB  1        ;PRE-DECAY FACTOR         : 001B
GWFRQ    RMB  2        ;FREQ TABLE ADDR          : 001C-001D
FRQEND   RMB  2        ;END ADDR FREQ TABLE      : 001E-001F
WVEND    RMB  2        ;WAVE END ADDR            : 0020-0021
GPER     RMB  1        ;PERIOD                   : 0022
GECNT    RMB  1        ;# OF ECHOES COUNTER      : 0023
FOFSET   RMB  1        ;FREQUENCY OFFSET         : 0024
;*
;*GWAVE TABLES
;*
GWTAB    RMB  WVELEN   ;WAVE TABLE               : 0025-006D (37d+72d=109d)
;*
;*VARIWAVE PARAMETERS
;*
         ORG  LOCRAM
LOPER    RMB  1        ;LO PERIOD                : 0014
HIPER    RMB  1        ;HIPERIOD                 : 0015
LODT     RMB  1        ;PERIOD DELTAS            : 0016
HIDT     RMB  1        ;                         : 0017
HIEN     RMB  1        ;END PERIOD               : 0018
SWPDT    RMB  2        ;SWEEP PERIOD             : 0019-001A
LOMOD    RMB  1        ;BASE FREQ MOD            : 001B
VAMP     RMB  1        ;AMPLITUDE                : 001C
LOCNT    RMB  1        ;PERIOD COUNTERS          : 001D
HICNT    RMB  1        ;                         : 001E
;*
;*NOISE ROUTINE PARAMETERS
;*
         ORG  LOCRAM
DECAY    RMB  1        ;                         : 0014
NAMP     RMB  1        ;                         : 0015
CYCNT    RMB  1        ;                         : 0016
NFRQ1    RMB  2        ;                         : 0017-0018
NFFLG    RMB  1        ;                         : 0019
LFREQ    RMB  1        ;                         : 001A
DFREQ    RMB  1        ;                         : 001B
;
;*
;* KNOCKER RAM
;*
         ORG  LOCRAM
PERIOD   RMB  1        ;                         : 0014
AMP      RMB  1        ;                         : 0015
SNDTMP   RMB  2        ;INDEX TMEP               : 0016-0017
;*
;* MAIN PROGRAM
;*
ORG  $F800
;
F800 : 45                             ;checksum byte
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
F81C : 97 0A      staa  $0A           ;store A in addr 0A(HI, start Random Generator)
F81E : E7 02      stab  $02,x         ;store B in addr X+02h (0402 PIA1 port B sound select)
F820 : 4F         clra                ;clear A
F821 : 97 07      staa  $07           ;store A in addr 07(B2FLG)
F823 : 97 08      staa  $08           ;store A in addr 08(B1FLG)
F825 : 97 04      staa  $04           ;store A in addr 04(BG1FLG)
F827 : 97 05      staa  $05           ;store A in addr 05(BG2FLG)
F829 : 97 06      staa  $06           ;store A in addr 06(SP1FLG)
F82B : 0E         cli                 ;clear interrupts I=0
;WAIT:
F82C : 20 FE      bra  LF82C          ;branch always WAIT
;*************************************;
;Vari Loader
;*************************************;
;VARILD
F82E : 16         tab                 ;transfer A to B
F82F : 48         asla                ;arith shift left A (bit0 is 0) x2
F830 : 48         asla                ;arith shift left A (bit0 is 0) x4
F831 : 48         asla                ;arith shift left A (bit0 is 0) x8
F832 : 1B         aba                 ;A=A+B (x9)
F833 : CE 00 14   ldx  #$0014         ;load X with value 0014h (#LOCRAM)
F836 : DF 10      stx  $10            ;store X in addr 10(0B:XPTR)(SET XSFER)
F838 : CE FD 15   ldx  #$FD15         ;load X with value FD15h (VVECT SAW)
F83B : BD FC 55   jsr  LFC55          ;jump sub ADDX
F83E : C6 09      ldab  #$09          ;load B with 09h(COUNT)
F840 : 7E F9 17   jmp  LF917          ;jump TRANS
;*************************************;
;Variable Duty Cycle Square Wave Routine
;*************************************;
;VARI
F843 : 96 1C      ldaa  $1C           ;load A with addr 1C(VAMP)
F845 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
;VAR0
F848 : 96 14      ldaa  $14           ;load A with addr 14(LOPER)
F84A : 97 1D      staa  $1D           ;store A in addr 1D(LOCNT)
F84C : 96 15      ldaa  $15           ;load A with addr 15(HIPER)
F84E : 97 1E      staa  $1E           ;store A in addr 1E(HICNT)
;V0
F850 : DE 19      ldx  $19            ;load X in addr 19(SWPDT)
;V0LP
F852 : 96 1D      ldaa  $1D           ;load A with addr 1D(LOCNT) (LO CYCLE)
F854 : 73 04 00   com  $0400          ;complement 1s in DAC output SOUND
;V1
F857 : 09         dex                 ;decr X
F858 : 27 10      beq  LF86A          ;branch Z=1 VSWEEP
F85A : 4A         deca                ;decr A
F85B : 26 FA      bne  LF857          ;branch Z=0 V1
F85D : 73 04 00   com  $0400          ;complement 1s in DAC output SOUND
F860 : 96 1E      ldaa  $1E           ;load A with addr 1E(HICNT) (HI CYCLE)
;V2
F862 : 09         dex                 ;decr X
F863 : 27 05      beq  LF86A          ;branch Z=1 VSWEEP
F865 : 4A         deca                ;decr A
F866 : 26 FA      bne  LF862          ;branch Z=0 V2
F868 : 20 E8      bra  LF852          ;branch always V0LP(LOOP BACK)
;VSWEEP
F86A : B6 04 00   ldaa  $0400         ;load A with addr 0400 DAC
F86D : 2B 01      bmi  LF870          ;branch N=1 VS1
F86F : 43         coma                ;complement 1s A
;VS1
F870 : 8B 00      adda  #$00          ;add A with 00h
F872 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F875 : 96 1D      ldaa  $1D           ;load A with 1D(LOCNT)
F877 : 9B 16      adda  $16           ;add A with addr 16(LODT)
F879 : 97 1D      staa  $1D           ;store A in addr 1D(LOCNT)
F87B : 96 1E      ldaa  $1E           ;load A with addr 1E(HICNT)
F87D : 9B 17      adda  $17           ;add A with addr 17(HIDT)
F87F : 97 1E      staa  $1E           ;store A in addr 1E(HICNT)
F881 : 91 18      cmpa  $18           ;compare A with addr 18(HIEN)
F883 : 26 CB      bne  LF850          ;branch Z=0 V0
F885 : 96 1B      ldaa  $1B           ;load A with addr 1B(LOMOD)
F887 : 27 06      beq  LF88F          ;branch Z=1 VARX
F889 : 9B 14      adda  $14           ;add A with addr 14(LOPER)
F88B : 97 14      staa  $14           ;store A in addr 14(LOPER)
F88D : 26 B9      bne  LF848          ;branch Z=0 VAR0
;VARX
F88F : 39         rts                 ;return subroutine
;*************************************;
;Lightning - Liten routine params
;*************************************;
;LITE
F890 : 86 01      ldaa  #$01          ;load A with 01h
F892 : 97 1B      staa  $1B           ;store A in addr 1B(DFREQ)
F894 : C6 03      ldab  #$03          ;load B with 03h
F896 : 20 0A      bra  LF8A2          ;branch always LITEN
;*************************************;
;Appear - Liten routine params
;*************************************;
;APPEAR
F898 : 86 FF      ldaa  #$FF          ;load A with FFh
F89A : 97 1B      staa  $1B           ;store A in addr 1B(DFREQ)
F89C : 86 60      ldaa  #$60          ;load A with 60h
F89E : C6 FF      ldab  #$FF          ;load B with FFh
F8A0 : 20 00      bra  LF8A2          ;branch always LITEN
;*************************************;
;Lightning+Appear Noise Routine
;*************************************;
;LITEN:
F8A2 : 97 1A      staa  $1A           ;store A in addr 1A(LFREQ)
F8A4 : 86 FF      ldaa  #$FF          ;load A with FFh(HIGHEST AMP)
F8A6 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F8A9 : D7 16      stab  $16           ;store B in addr 16(CYCNT)
;LITE0
F8AB : D6 16      ldab  $16           ;load B with addr 16(CYCNT)
;LITE1
F8AD : 96 0B      ldaa  $0B           ;load A with addr 0B(LO) (GET RANDOM)
F8AF : 44         lsra                ;logic shift right A (bit7=0)
F8B0 : 44         lsra                ;logic shift right A (bit7=0)
F8B1 : 44         lsra                ;logic shift right A (bit7=0)
F8B2 : 98 0B      eora  $0B           ;exclusive or A with addr 0B(LO)
F8B4 : 44         lsra                ;logic shift right A (bit7=0)
F8B5 : 76 00 0A   ror  $000A          ;rotate right addr 000A (bit0->C->bit7) (HI)
F8B8 : 76 00 0B   ror  $000B          ;rotate right addr 000B (bit0->C->bit7) (LO)
F8BB : 24 03      bcc  LF8C0          ;branch C=0 LITE2
F8BD : 73 04 00   com  $0400          ;complement 1s in DAC output SOUND
;LITE2
F8C0 : 96 1A      ldaa  $1A           ;load A with addr 1A(LFREQ)(COUNT FREQ)
;LITE3
F8C2 : 4A         deca                ;decr A
F8C3 : 26 FD      bne  LF8C2          ;branch Z=0 LITE3
F8C5 : 5A         decb                ;decr B (COUNT CYCLES)
F8C6 : 26 E5      bne  LF8AD          ;branch Z=0 LITE1
F8C8 : 96 1A      ldaa  $1A           ;load A with addr 1A(LFREQ)
F8CA : 9B 1B      adda  $1B           ;add A with addr 1B(DFREQ)
F8CC : 97 1A      staa  $1A           ;store A in addr 1A(LFREQ)
F8CE : 26 DB      bne  LF8AB          ;branch Z=0 LITE0
F8D0 : 39         rts                 ;return subroutine
;*************************************;
;Turbo - Noise routine params
;*************************************;
;TURBO
F8D1 : 86 20      ldaa  #$20          ;load A with 20h
F8D3 : 97 16      staa  $16           ;store A in addr 16(CYCNT)
F8D5 : 97 19      staa  $19           ;store A in addr 19(NFFLG)
F8D7 : 86 01      ldaa  #$01          ;load A with 01h
F8D9 : CE 00 01   ldx  #$0001         ;load X with 0001h
F8DC : C6 FF      ldab  #$FF          ;load B with FFh
F8DE : 20 00      bra  LF8E0          ;branch always NOISE
;*************************************;
;White Noise Routine
;*************************************;
;X=INIT PERIOD, ACCB=INIT AMP, ACCA DECAY RATE
;CYCNT=CYCLE COUNT, NFFLG= FREQ DECAY FLAG
;NOISE:
F8E0 : 97 14      staa  $14           ;store A in addr 14(DECAY)
;NOISE0
F8E2 : DF 17      stx  $17            ;store X in addr 17(NFRQ1)
;NOIS00
F8E4 : D7 15      stab  $15           ;store B in addr 15(NAMP)
F8E6 : D6 16      ldab  $16           ;load B with addr 16(CYCNT)
;NOISE1
F8E8 : 96 0B      ldaa  $0B           ;load A with addr 0B(LO)(GET RANDOM BIT)
F8EA : 44         lsra                ;logic shift right A (bit7=0)
F8EB : 44         lsra                ;logic shift right A (bit7=0)
F8EC : 44         lsra                ;logic shift right A (bit7=0)
F8ED : 98 0B      eora  $0B           ;exclusive or A and addr 0B(LO)
F8EF : 44         lsra                ;logic shift right A (bit7=0)
F8F0 : 76 00 0A   ror  $000A          ;rotate right addr 000A (bit0->C->bit7) (HI)
F8F3 : 76 00 0B   ror  $000B          ;rotate right addr 000B (bit0->C->bit7) (LO)
F8F6 : 86 00      ldaa  #$00          ;load A with 00h
F8F8 : 24 02      bcc  LF8FC          ;branch C=0 NOISE2
F8FA : 96 15      ldaa  $15           ;load A with addr 15 (NAMP)
;NOISE2
F8FC : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F8FF : DE 17      ldx  $17            ;load X with addr 17(NFRQ1)(INCREASING DELAY)
;NOISE3
F901 : 09         dex                 ;decr X
F902 : 26 FD      bne  LF901          ;branch Z=0 NOISE3
F904 : 5A         decb                ;decr B (FIN CYCLE COUNT?)
F905 : 26 E1      bne  LF8E8          ;branch Z=0 NOISE1(NO)
F907 : D6 15      ldab  $15           ;load B with addr 15(NAMP)(DECAY AMP)
F909 : D0 14      subb  $14           ;sub B with addr 14(DECAY)
F90B : 27 09      beq  LF916          ;branch Z=1 NSEND
F90D : DE 17      ldx  $17            ;load X with addr 17(NFRQ1)(INC FREQ)
F90F : 08         inx                 ;incr X
F910 : 96 19      ldaa  $19           ;load A with addr 19(NFFLG)(DECAY FREQ?)
F912 : 27 D0      beq  LF8E4          ;branch Z=1 NOIS00(NO)
F914 : 20 CC      bra  LF8E2          ;branch always NOISE0
;NSEND 
F916 : 39         rts                 ;return subroutine
;*************************************;
;Parameter Transfer
;*************************************;
;TRANS
F917 : 36         psha                ;push A into stack then SP - 1
;TRANS1
F918 : A6 00      ldaa  $00,x         ;load A with X+00h
F91A : DF 0E      stx  $0E            ;store X inaddr 0E (XPLAY)
F91C : DE 10      ldx  $10            ;load X with addr 10 (XPTR)
F91E : A7 00      staa  $00,x         ;store A in addr X+00h
F920 : 08         inx                 ;incr X
F921 : DF 10      stx  $10            ;store X in addr 10 (XPTR)
F923 : DE 0E      ldx  $0E            ;load X with addr 0E (XPLAY)
F925 : 08         inx                 ;incr X
F926 : 5A         decb                ;decr B
F927 : 26 EF      bne  LF918          ;branch Z=0 TRANS1
F929 : 32         pula                ;SP + 1 pull stack into A
F92A : 39         rts                 ;return subroutine
;*************************************;
;Pulse synth uses NOTTBL,SNDTBL,WAVFRM tables
;*************************************;
;PULSE
F92B : 84 1F      anda  #$1F          ;and A with 1Fh
;PULSE3
F92D : 27 FE      beq  LF92D          ;branch Z=1 here PULSE3
F92F : 84 0F      anda  #$0F          ;and A with 0Fh
F931 : CE 00 14   ldx  #$0014         ;load X with addr 14
F934 : DF 10      stx  $10            ;store X in addr 10
F936 : CE FC F7   ldx  #$FCF7         ;load X with FCF7h NOTTBL
F939 : BD FC 55   jsr  LFC55          ;jump sub ADDX
F93C : A6 00      ldaa  $00,x         ;load A with X+00h
F93E : 97 24      staa  $24           ;store A in addr 24
F940 : CE FC E7   ldx  #$FCE7         ;load X with FCE7h SNDTBL
F943 : C6 10      ldab  #$10          ;load B with 10h
F945 : BD F9 17   jsr  LF917          ;jump sub TRANS
F948 : CE FD 07   ldx  #$FD07         ;load X with FD07h WAVFRM
F94B : E6 00      ldab  $00,x         ;load B with X+00h
;PULSE4
F94D : D7 26      stab  $26           ;store B in addr 26
F94F : DF 10      stx  $10            ;store X in addr 10
;PULSE5
F951 : CE 00 14   ldx  #$0014         ;load X with addr 14
F954 : C6 08      ldab  #$08          ;load B with 08h
F956 : D7 25      stab  $25           ;store B in addr 25
;PULSE6
F958 : A6 00      ldaa  $00,x         ;load A with X+00h
F95A : D6 24      ldab  $24           ;load B with addr 24
F95C : 7D 00 26   tst  $0026          ;test addr 0026
F95F : 26 06      bne  LF967          ;branch Z=0 PULSE7
F961 : A0 08      suba  $08,x         ;sub A with X+08h
F963 : A7 00      staa  $00,x         ;store A in X+00h
F965 : C0 03      subb  #$03          ;sub B with 03h
;PULSE7
F967 : 08         inx                 ;incr X
F968 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
;PULSE8
F96B : 5A         decb                ;decr B
F96C : 26 FD      bne  LF96B          ;branch Z=0 PULSE8
F96E : 7A 00 25   dec  $0025          ;decr addr 0025
F971 : 26 E5      bne  LF958          ;branch Z=0 PULSE6
F973 : 7A 00 26   dec  $0026          ;decr addr 0026
F976 : 2A D9      bpl  LF951          ;branch N=0 PULSE5
F978 : DE 10      ldx  $10            ;load X with addr 10
F97A : 08         inx                 ;incr X
F97B : E6 00      ldab  $00,x         ;load B with X+00h
F97D : 26 CE      bne  LF94D          ;branch Z=0 PULSE4
;PULSEX
F97F : 20 FE      bra  LF97F          ;branch always PULSEX
;*************************************;
;Knocker Routine
;*************************************;
;KNOCK:
F981 : CE FD 6F   ldx  #$FD6F         ;load X with value FD64h (KNKTAB)
F984 : DF 16      stx  $16            ;store X in addr 16 (SNDTMP)
;SQLP
F986 : DE 16      ldx  $16            ;load X with addr 16 (SNDTMP)
F988 : A6 00      ldaa  $00,x         ;load A with X+00h (GET PERIOD)
F98A : 27 33      beq  LF9BF          ;branch Z=1 END (END ON ZERO)
F98C : E6 01      ldab  $01,x         ;load B with X+01h (GET AMP)
F98E : C4 F0      andb  #$F0          ;and B with F0h
F990 : D7 15      stab  $15           ;store B in addr 15 (AMP)
F992 : E6 01      ldab  $01,x         ;load B with X+01h
F994 : 08         inx                 ;incr X
F995 : 08         inx                 ;incr X
F996 : DF 16      stx  $16            ;store X in addr 16 (SNDTMP) (SAVE X)
F998 : 97 14      staa  $14           ;store A in addr 14 (PERIOD)
F99A : C4 0F      andb  #$0F          ;and B with 0Fh
;LP0
F99C : 96 15      ldaa  $15           ;load A with addr 15 (AMP)
F99E : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F9A1 : 96 14      ldaa  $14           ;load A with addr 14 (PERIOD)
;LP1
F9A3 : CE 00 05   ldx  #$0005         ;load X with 0005h (DELAY)
;LP11
F9A6 : 09         dex                 ;decr X
F9A7 : 26 FD      bne  LF9A6          ;branch Z=0 LP11
F9A9 : 4A         deca                ;decr A
F9AA : 26 F7      bne  LF9A3          ;branch Z=0 LP1
F9AC : 7F 04 00   clr  $0400          ;clear DAC output SOUND
F9AF : 96 14      ldaa  $14           ;load A with addr 14 (PERIOD)
;LP2
F9B1 : CE 00 05   ldx  #$0005         ;load X with 0005h (DELAY)
;LP22
F9B4 : 09         dex                 ;decr X
F9B5 : 26 FD      bne  LF9B4          ;branch Z=0 LP22
F9B7 : 4A         deca                ;decr A
F9B8 : 26 F7      bne  LF9B1          ;branch Z=0 LP2
F9BA : 5A         decb                ;decr B
F9BB : 26 DF      bne  LF99C          ;branch Z=0 LP0
F9BD : 20 C7      bra  LF986          ;branch always SQLP
;END LF9BF:
F9BF : 39         rts                 ;return subroutine
;*************************************;
;Background Sound #1 increment (assumed)
;*************************************;
;BG1INC
F9C0 : 96 05      ldaa  $05           ;load A with addr 05 (BG2FLG)
F9C2 : 8A 80      oraa  #$80          ;or A with 80h
F9C4 : 97 05      staa  $05           ;store A in addr 05 (BG2FLG)
F9C6 : D6 04      ldab  $04           ;load B with addr 04 (BG1FLG)
F9C8 : C4 7F      andb  #$7F          ;and B with 7Fh (REMOVE OVERRIDE)
F9CA : C1 24      cmpb  #$24          ;compare B with 24h (#BG1MAX)
F9CC : 26 01      bne  LF9CF          ;branch Z=0 BG1IO
F9CE : 5F         clrb                ;clear B
;BG1IO
F9CF : 5C         incb                ;incr B
F9D0 : D7 04      stab  $04           ;store B in addr 04 (BG1FLG)
F9D2 : 39         rts                 ;return subroutine
;*************************************;
; vari/varild params
;*************************************;
;VARPRM
F9D3 : 86 07      ldaa  #$07          ;load A with 07h
F9D5 : BD F8 2E   jsr  LF82E          ;jump sub VARILD
F9D8 : D6 04      ldab  $04           ;load B with addr 04
F9DA : C1 20      cmpb  #$20          ;compare B with 20h
F9DC : 23 02      bls  LF9E0          ;branch C+Z=1 VP1
F9DE : C6 20      ldab  #$20          ;load B with 20h
;VP1
F9E0 : CE 00 38   ldx  #$0038         ;load X with 0038h
F9E3 : 86 20      ldaa  #$20          ;load A with 20h
F9E5 : 10         sba                 ;A=A-B
F9E6 : 16         tab                 ;transfer A to B
;VP1LP1
F9E7 : C1 0F      cmpb  #$0F          ;compare B with 0Fh
F9E9 : 23 08      bls  LF9F3          ;branch C+Z=1 VP1LP2
F9EB : 86 10      ldaa  #$10          ;load A with 10h
F9ED : BD FC 55   jsr  LFC55          ;jump sub ADDX
F9F0 : 5A         decb                ;decr B
F9F1 : 20 F4      bra  LF9E7          ;branch always VP1LP1
;VP1LP2
F9F3 : 86 08      ldaa  #$08          ;load A with 08h
F9F5 : BD FC 55   jsr  LFC55          ;jump sub ADDX
F9F8 : 5A         decb                ;decr B
F9F9 : 26 F8      bne  LF9F3          ;branch Z=0 VP1LP2
F9FB : DF 19      stx  $19            ;store X in addr 19
F9FD : 96 0A      ldaa  $0A           ;load A in addr 0A
F9FF : 48         asla                ;arith shift left A
FA00 : 9B 0A      adda  $0A           ;add A with addr 0A
FA02 : 8B 0B      staa  $0A           ;store A in addr 0A
FA06 : 97 14      staa  $14           ;store A in addr 14
;VP1X
FA08 : BD F8 43   jsr  LF843          ;jump sub VARI
FA0B : 20 FB      bra  LFA08          ;branch always VP1X
;*************************************;
;Background End Routine
;*************************************;
;BGEND
FA0D : 7F 00 04   clr  $0004          ;clear addr 0004 (BG1FLG)
FA10 : 7F 00 05   clr  $0005          ;clear addr 0005 (BG2FLG)
FA13 : 39         rts                 ;return subroutine
;*************************************;
;Background Sound #2 increment
;*************************************;
;BG2INC
FA14 : 96 04      ldaa  $04           ;load A with addr 04 (BG1FLG)
FA16 : 8A 80      oraa  #$80          ;or A with 80h
FA18 : 97 04      staa  $04           ;store A in addr 04 (BG1FLG)
FA1A : 96 05      ldaa  $05           ;load A with addr 05 (BG2FLG)
FA1C : 84 7F      anda  #$7F          ;and A with 7Fh (REMOVE OVERRIDE)
FA1E : 81 1D      cmpa  #$1D          ;compare A with 1Dh (#BG2MAX)
FA20 : 26 01      bne  LFA23          ;branch Z=0 BG2IO
FA22 : 4F         clra                ;clear A
;BG2IO:
FA23 : 4C         inca                ;incr A
FA24 : 97 05      staa  $05           ;store A in addr 05 (BG2FLG)
FA26 : 39         rts                 ;return subroutine
;*************************************;
;Background 2 Routine
;*************************************;
;BG2
FA27 : 86 0F      ldaa  #$0F          ;load A with 0Fh
FA29 : BD FA 88   jsr  LFA88          ;jump sub GWLD
FA2C : 96 05      ldaa  $05           ;load A with addr 05
FA2E : 48         asla                ;arith shift left A
FA2F : 48         asla                ;arith shift left A
FA30 : 43         coma                ;complement 1s A
FA31 : BD FB 42   jsr  LFB42          ;jump sub GEND60
;BG2LP
FA34 : 7C 00 18   inc  $0018          ;incr adddr 0018
FA37 : BD FB 44   jsr  LFB44          ;jump sub GEND61
FA3A : 20 F8      bra  LFA34          ;branch always BG2LP
;*************************************;
;Spinner #1 Sound
;*************************************;
;SP1
FA3C : 86 08      ldaa  #$08          ;load A with 08h(#(CABSHK-VVECT)/9)
FA3E : BD F8 2E   jsr  LF82E          ;jump sub VARILD
FA41 : D6 06      ldab  $06           ;load B with addr 06 (SP1FLG)
FA43 : C1 1F      cmpb  #$1F          ;compare B with 1Fh (#SP1MAX-1)
FA45 : 26 01      bne  LFA48          ;branch Z=0 SP1A
FA47 : 5F         clrb                ;clear B
;SP1A
FA48 : 5C         incb                ;incr B
FA49 : D7 06      stab  $06           ;store B in addr 06 (SP1FLG)
FA4B : 86 20      ldaa  #$20          ;load A with 20h (#SP1MAX)
FA4D : 10         sba                 ;A=A-B
FA4E : 5F         clrb                ;clear B
;SP11
FA4F : 81 14      cmpa  #$14          ;compare A with 14h
FA51 : 23 05      bls  LFA58          ;branch C+Z=1 SP12
FA53 : CB 0E      addb  #$0E          ;add B with 0Eh
FA55 : 4A         deca                ;decr A
FA56 : 20 F7      bra  LFA4F          ;branch always SP11
;SP12
FA58 : CB 05      addb  #$05          ;add B with 05h
FA5A : 4A         deca                ;decr A
FA5B : 26 FB      bne  LFA58          ;branch Z=0 SP12
FA5D : D7 14      stab  $14           ;store B in addr 14 (LOPER)
;SP1LP
FA5F : BD F8 43   jsr  LF843          ;jump sub VARI (DO IT)
FA62 : 20 FB      bra  LFA5F          ;branch always SPILP
;*************************************;
;Laser Ball Bonus #2
;*************************************;
;BON2
FA64 : 96 07      ldaa  $07           ;load A with 07h
FA66 : 26 0B      bne  LFA73          ;branch Z=0 BON21
FA68 : 7C 00 07   inc  $0007          ;incr addr 0007(B2FLG)
FA6B : 86 0D      ldaa  #$0D          ;load A with 0Dh
FA6D : BD FA 88   jsr  LFA88          ;jump sub GWLD
FA70 : 7E FA EE   jmp  LFAEE          ;jump GWAVE
;BON21
FA73 : 7E FB 37   jmp  LFB37          ;jump GEND50
;*************************************;
;Laser Ball Bonus #1 (assumed name)
;*************************************;
;BON1
FA76 : 96 08      ldaa  $08           ;load A with 08h
FA78 : 26 0B      bne  LFA85          ;branch Z=0 BON11
FA7A : 7C 00 08   inc  $0008          ;incr 0008(B1FLG)
FA7D : 86 0E      ldaa  #$0E          ;load A with 0Eh
FA7F : BD FA 88   jsr  LFA88          ;jump sub GWLD
FA82 : 7E FA EE   jmp  LFAEE          ;jump GWAVE
;BON11
FA85 : 7E FB 37   jmp  LFB37          ;jump GEND50
;*************************************;
;GWAVE Loader
;*************************************;
;GWLD:
FA88 : 16         tab                 ;transfer A to B (MULKT BY 7)
FA89 : 58         aslb                ;arith shift left B(bit0 is 0)
FA8A : 1B         aba                 ;A = A + B
FA8B : 1B         aba                 ;A = A + B
FA8C : 1B         aba                 ;A = A + B
FA8D : CE FE 68   ldx  #$FE68         ;load X with FED6h (SVTAB)(SOUND VECTOR TABLE)
FA90 : BD FC 55   jsr  LFC55          ;jump sub ADDX
FA93 : A6 00      ldaa  $00,x         ;load A with X+00h
FA95 : 16         tab                 ;transfer A to B
FA96 : 84 0F      anda  #$0F          ;and A with 0Fh
FA98 : 97 15      staa  $15           ;store A in addr 15 (GCCNT)(GET CYCLE COUNT)
FA9A : 54         lsrb                ;logic shift right B (0Nxx xxxx)
FA9B : 54         lsrb                ;logic shift right B (00Nx xxxx)
FA9C : 54         lsrb                ;logic shift right B (000N xxxx)
FA9D : 54         lsrb                ;logic shift right B (0000 Nxxx)
FA9E : D7 14      stab  $14           ;store B in addr 14 (GECHO)(GET #ECHOS)
FAA0 : A6 01      ldaa  $01,x         ;load A with X+00h
FAA2 : 16         tab                 ;transfer A to B
FAA3 : 54         lsrb                ;logic shift right B (bit7=0)
FAA4 : 54         lsrb                ;logic shift right B (bit7=0)
FAA5 : 54         lsrb                ;logic shift right B (bit7=0)
FAA6 : 54         lsrb                ;logic shift right B (bit7=0)
FAA7 : D7 16      stab  $16           ;store B in addr 16(GECDEC)
FAA9 : 84 0F      anda  #$0F          ;and A with 0Fh (WAVE #)
FAAB : 97 12      staa  $12           ;store A in addr 12(TEMPA)(SAVE)
FAAD : DF 0C      stx  $0C            ;store X in addr 0C(TEMPX)(SAVE INDEX)
FAAF : CE FD 8D   ldx  #$FD8D         ;load X with FD8Dh (GWVTAB)(CALC WAVEFORM ADDR)
;GWLD2
FAB2 : 7A 00 12   dec  $0012          ;decr addr 0012(TEMPA)(WAVE FROM #) (meant to be WAVE FORM #?)
FAB5 : 2B 08      bmi  LFABF          ;branch N=1 GWLD3(FINIS)
FAB7 : A6 00      ldaa  $00,x         ;load A with X+00h
FAB9 : 4C         inca                ;incr A
FABA : BD FC 55   jsr  LFC55          ;jump sub ADDX
FABD : 20 F3      bra  LFAB2          ;branch always GWLD2
;GWLD3
FABF : DF 19      stx  $19            ;store X in addr 19(GWFRM)
FAC1 : BD FB 7E   jsr  LFB7E          ;jump sub WVTRAN(XSFER WAVE TO RAM)
FAC4 : DE 0C      ldx  $0C            ;load X with addr 0C(TEMPX)(RESTORE INDEX)
FAC6 : A6 02      ldaa  $02,x         ;load A with X+02h(GET PREDECAY)
FAC8 : 97 1B      staa  $1B           ;store A in addr 1B(PRDECA)
FACA : BD FB 90   jsr  LFB90          ;jump sub WVDECA(DECAY IT)
FACD : DE 0C      ldx  $0C            ;load X with addr 0C(TEMPX)
FACF : A6 03      ldaa  $03,x         ;load A with X+03h(GET FREQ INC)
FAD1 : 97 17      staa  $17           ;store A in addr 17 (GDFINC)
FAD3 : A6 04      ldaa  $04,x         ;load A with X+04h(GET DELTA FREQ COUNT)
FAD5 : 97 18      staa  $18           ;store A in addr 18(GDCNT)
FAD7 : A6 05      ldaa  $05,x         ;load A with X+05h(GET PATTERN COUNT)
FAD9 : 16         tab                 ;transfer A to B (SAVE)
FADA : A6 06      ldaa  $06,x         ;load A with X+06h(PATTERN OFFSET)
FADC : CE FE D8   ldx  #$FED8         ;load X with FED8h (#GFRTAB)
FADF : BD FC 55   jsr  LFC55          ;jumps sub ADDX
FAE2 : 17         tba                 ;transfer B to A(GET PATTERN LENGTH)
FAE3 : DF 1C      stx  $1C            ;store X in addr 1C(GWFRQ)(FREQ TABLE ADDR)
FAE5 : 7F 00 24   clr  $0024          ;clear addr 0024(FOFSET)
FAE8 : BD FC 55   jsr  LFC55          ;jump sub ADDX
FAEB : DF 1E      stx  $1E            ;store X in 1E(FRQEND)
FAED : 39         rts                 ;return subroutine
;*************************************;
;GWAVE routine
;*************************************;
;ACCA=Freq Pattern Length, X=Freq Pattern Addr
;GWAVE
FAEE : 96 14      ldaa  $14           ;load A with addr 14 (GECHO)
FAF0 : 97 23      staa  $23           ;store A in addr 23 (GECNT)
;GWT4 
FAF2 : DE 1C      ldx  $1C            ;load X with addr 1C (GWFRQ)
FAF4 : DF 0E      stx  $0E            ;store X in addr 0E (XPLAY)
;GPLAY 
FAF6 : DE 0E      ldx  $0E            ;load X with addr 0E (XPLAY)(GET NEW PERIOD)
FAF8 : A6 00      ldaa  $00,x         ;load A with X+00h
FAFA : 9B 24      adda  $24           ;add A with addr 24(FOFSET)
FAFC : 97 22      staa  $22           ;store A in addr 22(GPER)
FAFE : 9C 1E      cpx  $1E            ;compare X with addr 1E (FRQEND)
FB00 : 27 26      beq  LFB28          ;branch Z=1 GEND(FINISH ON ZERO)
FB02 : D6 15      ldab  $15           ;load B with addr 15(GCCNT)(CYCLE COUNT)
FB04 : 08         inx                 ;incr X
FB05 : DF 0E      stx  $0E            ;store X in addr 0E(XPLAY)
;GOUT 
FB07 : CE 00 25   ldx  #$0025         ;load X with addr 0025(#GWTAB)(SETUP WAVEFORM POINTER)
;GOUTLP 
FB0A : 96 22      ldaa  $22           ;load A with add 22(GPER)
;GPRLP
FB0C : 4A         deca                ;decr A(WAIT FOR PERIOD)
FB0D : 26 FD      bne  LFB0C          ;branch Z=0 GPRLP
FB0F : A6 00      ldaa  $00,x         ;load A with X+00h
FB11 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
;GPR1
FB14 : 08         inx                 ;incr X
FB15 : 9C 20      cpx  $20            ;compare X with addr 20 (WVEND)(END OF WAVE?)
FB17 : 26 F1      bne  LFB0A          ;branch Z=0 GOUTLP
FB19 : 5A         decb                ;decr B
FB1A : 27 DA      beq  LFAF6          ;branch Z=1 GPLAY
FB1C : 08         inx                 ;incr X (4 cycles)
FB1D : 09         dex                 ;decr X (4 cycles)
FB1E : 08         inx                 ;incr X (4 cycles)
FB1F : 09         dex                 ;decr X (4 cycles)
FB20 : 08         inx                 ;incr X (4 cycles)
FB21 : 09         dex                 ;decr X (4 cycles)
FB22 : 08         inx                 ;incr X (4 cycles)
FB23 : 09         dex                 ;decr X (4 cycles)
FB24 : 01         nop                 ;nop (2 cycles)
FB25 : 01         nop                 ;nop (2 cycles)
FB26 : 20 DF      bra  LFB07          ;branch always GOUT (SYNC 36)
;GEND 
FB28 : 96 16      ldaa  $16           ;load A with addr 16(GECDEC)
FB2A : 8D 64      bsr  LFB90          ;branch sub WVDECA
;GEND40
FB2C : 7A 00 23   dec  $0023          ;decr addr 0023(GECNT)(ECHO ON?)
FB2F : 26 C1      bne  LFAF2          ;branch Z=0 GWT4(YES)
FB31 : 96 07      ldaa  $07           ;load A with addr 07 (B2FLG)(STOP BONUS)
FB33 : 9A 08      oraa  $08           ;or A with addr 08 
FB35 : 26 46      bne  LFB7D          ;branch Z=0 GEND1
;GEND50 
FB37 : 96 17      ldaa  $17           ;load A with addr 17(GDFINC)(CONTINUE FOR FREQ MOD SOUNDS)
FB39 : 27 42      beq  LFB7D          ;branch Z=1 GEND1(NO)
FB3B : 7A 00 18   dec  $0018          ;decr addr 0018 (GDCNT)(DELTA FREQ OVER?)
FB3E : 27 3D      beq  LFB7D          ;branch Z=1 GEND1(YES...)
FB40 : 9B 24      adda  $24           ;add A with addr 24 (FOFSET)(UPDATE FREQ OFFSET)
;GEND60
FB42 : 97 24      staa  $24           ;store A in addr 24(FOFSET)
;GEND61
FB44 : DE 1C      ldx  $1C            ;load X with addr 1C (GWFRQ)(GET INDEX)
FB46 : 5F         clrb                ;clear B(START FOUND FLAG INIT CLEAR)
;GW0 
FB47 : 96 24      ldaa  $24           ;load A with addr 24(FOFSET)(INC OR DEC?)
FB49 : 7D 00 17   tst  $0017          ;test addr 0017 (GDFINC)
FB4C : 2B 06      bmi  LFB54          ;branch N=1 GW1(DEC)
FB4E : AB 00      adda  $00,x         ;add A with addr X+00h(INC)
FB50 : 25 08      bcs  LFB5A          ;branch C=1 GW2(CARRY=OVERFLOW)
FB52 : 20 0B      bra  LFB5F          ;branch always GW2A
;GW1 
FB54 : AB 00      adda  $00,x         ;add A with addr X+00h(DEC)
FB56 : 27 02      beq  LFB5A          ;branch Z=1 GW2(OVERFLOW ON EQ)
FB58 : 25 05      bcs  LFB5F          ;branch C=1 GW2A(OVERFLOW IF CARRY CLEAR)
;GW2 
FB5A : 5D         tstb                ;test B(FOUND START YET?)
FB5B : 27 08      beq  LFB65          ;branch Z=1 GW2B(NO)
FB5D : 20 0F      bra  LFB6E          ;branch always GW3(YES, THIS IS THE END)
;GW2A
FB5F : 5D         tstb                ;test B
FB60 : 26 03      bne  LFB65          ;branch Z=0 GW2B(ALREADY FOUND START)
FB62 : DF 1C      stx  $1C            ;store X in 1C (GWFRQ)(FOUND START)
FB64 : 5C         incb                ;incr B
;GW2B 
FB65 : 08         inx                 ;incr X
FB66 : 9C 1E      cpx  $1E            ;compare X with addr 1E (FRQEND)
FB68 : 26 DD      bne  LFB47          ;branch Z=0 GW0(NOT OVER YET)
FB6A : 5D         tstb                ;test B(FOUND START?)
FB6B : 26 01      bne  LFB6E          ;branch Z=0 GW3(YES)
FB6D : 39         rts                 ;return subroutine (ALL OVER)
;GW3 
FB6E : DF 1E      stx  $1E            ;store X in 1E (FRQEND)
FB70 : 96 16      ldaa  $16           ;load A with addr 16(GECDEC)(RE:XSFER WAVE?)
FB72 : 27 06      beq  LFB7A          ;branch Z=1 GEND0(NO)
FB74 : 8D 08      bsr  LFB7E          ;branch sub WVTRAN(XSFER WAVE)
FB76 : 96 1B      ldaa  $1B           ;load A with addr 1B (PRDECA)
FB78 : 8D 16      bsr  LFB90          ;branch sub WVDECA
;GEND0 
FB7A : 7E FA EE   jmp  LFAEE          ;jump GWAVE
;GEND1
FB7D : 39         rts                 ;return subroutine(TERMINATE)
;*************************************;
;Wave Transfer Routine (PARAM18)
;*************************************;
;WVTRAN
FB7E : CE 00 25   ldx  #$0025         ;load X with addr 0025 (#GWTAB)
FB81 : DF 10      stx  $10            ;store X in addr 10 (XPTR)
FB83 : DE 19      ldx  $19            ;load X with addr 19 (GWFRM)
FB85 : E6 00      ldab  $00,x         ;load B with X+00h (GET WAVE LENGTH)
FB87 : 08         inx                 ;incr X
FB88 : BD F9 17   jsr  LF917          ;jump sub TRANS
FB8B : DE 10      ldx  $10            ;load X with addr 10 (XPTR)
FB8D : DF 20      stx  $20            ;store X in addr 20 (WVEND)(GET END ADDR)
FB8F : 39         rts                 ;return subroutine
;*************************************;
;Wave Decay Routinue (PARAM19)
;*************************************;
;decay amount in ACCA 1/16 per decay
;WVDECA
FB90 : 4D         tsta                ;test A
FB91 : 27 2B      beq  LFBBE          ;branch Z=1 WVDCX(NODECAY)
FB93 : DE 19      ldx  $19            ;load X with addr 19 (GWFRM)(ROM WAVE INDEX)
FB95 : DF 0E      stx  $0E            ;store X in addr 0E (XPLAY)
FB97 : CE 00 25   ldx  #$0025         ;load X with addr 0025h (#GWTAB)
FB9A : 97 13      staa  $13           ;store A in addr 13 (TEMPB)(DECAY FACTOR)
;WVDLP
FB9C : DF 10      stx  $10            ;store X in addr 10 (XPTR)
FB9E : DE 0E      ldx  $0E            ;load X with addr 0E (XPLAY)
FBA0 : D6 13      ldab  $13           ;load B with addr 13 (TEMPB)
FBA2 : D7 12      stab  $12           ;store B in addr 12 (TEMPA)(DECAY FACTOR TEMP)
FBA4 : E6 01      ldab  $01,x         ;load B with X+01h
FBA6 : 54         lsrb                ;logic shift right B(bit7=0)
FBA7 : 54         lsrb                ;logic shift right B
FBA8 : 54         lsrb                ;logic shift right B
FBA9 : 54         lsrb                ;logic shift right B(CALC 1/16TH)
FBAA : 08         inx                 ;incr X
FBAB : DF 0E      stx  $0E            ;store X in addr 0E (XPLAY)
FBAD : DE 10      ldx  $10            ;load X with addr 10 (XPTR)
FBAF : A6 00      ldaa  $00,x         ;load A with X+00h
;WVDLP1
FBB1 : 10         sba                 ;A=A-B (DECAY)
FBB2 : 7A 00 12   dec  $0012          ;decr addr 0012 (TEMPA)
FBB5 : 26 FA      bne  LFBB1          ;branch Z=0 WVDLP1
FBB7 : A7 00      staa  $00,x         ;store A in X+00h
FBB9 : 08         inx                 ;incr X
FBBA : 9C 20      cpx  $20            ;compare X with addr 20 (WVEND)(END OF WAVE?)
FBBC : 26 DE      bne  LFB9C          ;branch Z=0 WVDLP
;WVDCX
FBBE : 39         rts                 ;return subroutine
;*************************************;
;Interrupt Processing
;*************************************;
;IRQ
FBBF : 8E 00 7F   lds  #$007F         ;load SP with value 007Fh (#ENDRAM)
FBC2 : B6 04 02   ldaa  $0402         ;load A with addr 0402 (PIA sound select)
FBC5 : C6 80      ldab  #$80          ;load B with 80h
FBC7 : F7 04 02   stab  $0402         ;store B in addr 0402 (PIA)
FBCA : 7C 00 09   inc  $0009          ;incr addr 0009 <-- origins/clear?
FBCD : 43         coma                ;complement 1s A (INVERT INPUT)
FBCE : 84 7F      anda  #$7F          ;and A with 7Fh (MASK GARB)
FBD0 : 36         psha                ;push A into stack then SP-1
FBD1 : 84 5F      anda  #$5F          ;and A with 5Fh
FBD3 : 81 16      cmpa  #$16          ;compare A with 16h
FBD5 : 27 03      beq  LFBDA          ;branch Z=1 IRQ1
FBD7 : 7F 00 07   clr  $0007          ;clear addr 0007
;IRQ1
FBDA : 81 18      cmpa  #$18          ;compare A with 18h
FBDC : 27 03      beq  LFBE1          ;branch Z=1 IRQ2
FBDE : 7F 00 08   clr  $0008          ;clear addr 0008
;IRQ2
FBE1 : 32         pula                ;SP+1 pull stack into A
FBE2 : 85 20      bita  #$20          ;bit test A with 20h
FBE4 : 27 1C      beq  LFC02          ;branch Z=1 IRQ3
;CHECK FOR PRESENCE OF TALKING PROGRAM
FBE6 : F6 DF FD   ldab  $DFFD         ;load B with addr DFFD (TALK) - Speech ROM IC6
FBE9 : C1 7E      cmpb  #$7E          ;compare B with 7Eh (look for 7E jmp opcode)
FBEB : 26 15      bne  LFC02          ;branch Z=0 IRQ3 (NO)
FBED : BD DF FD   jsr  LDFFD          ;jump sub DFFD (YES) - Speech ROM IC6
FBF0 : 0E         cli                 ;clear interrupts I=0
FBF1 : F6 04 02   ldab  $0402         ;load B with addr 0402
FBF4 : D6 13      ldab  $13           ;load B with addr 13
FBF6 : 26 0A      bne  LFC02          ;branch Z=0 IRQ3
FBF8 : 81 14      cmpa  #$14          ;compare A with 14h
FBFA : 27 06      beq  LFC02          ;branch Z=1 IRQ3
FBFC : CE 2E E0   ldx  #$2EE0         ;load X with 2EE0h
;IRQ2LP - count down X
FBFF : 09         dex                 ;decr X
FC00 : 26 FD      bne  LFBFF          ;branch Z=0 IRQ2LP
;IRQ3 - no speech ROM 
FC02 : 0E         cli                 ;clear interrupts I=0
FC03 : 85 40      bita  #$40          ;bit test A with 40h
FC05 : 27 09      beq  LFC10          ;branch Z=1 IRQ4
FC07 : 84 1F      anda  #$1F          ;and A with 1Fh
FC09 : 81 01      cmpa  #$01          ;compare A with 01h
FC0B : 27 03      beq  LFC10          ;branch Z=1 IRQ4
FC0D : 7E F9 2B   jmp  LF92B          ;jump PULSE
;IRQ4
FC10 : 84 1F      anda  #$1F          ;and A with 1Fh
FC12 : 27 2A      beq  LFC3E          ;branch Z=1 IRQ7
FC14 : 4A         deca                ;decr A
FC15 : 27 4D      beq  LFC64          ;branch Z=1 TILT
FC17 : 81 0D      cmpa  #$0D          ;compare A with 0Dh
FC19 : 22 09      bhi  LFC24          ;branch C+Z=0 IRQ5
FC1B : 4A         deca                ;decr A
FC1C : BD FA 88   jsr  LFA88          ;jump sub GWLD
FC1F : BD FA EE   jsr  LFAEE          ;jump sub GWAVE
FC22 : 20 1A      bra  LFC3E          ;branch always IRQ7
;IRQ5
FC24 : 81 17      cmpa  #$17          ;compare A with 17h
FC26 : 22 0E      bhi  LFC36          ;branch C+Z=0 IRQ36
FC28 : 80 0E      suba  #$0E          ;sub A with 0Eh
FC2A : 48         asla                ;arith shift left A
FC2B : CE FC D3   ldx  #$FCD3         ;load X with FCD3h JMPTBL
FC2E : 8D 25      bsr  LFC55          ;branch sub ADDX
FC30 : EE 00      ldx  $00,x          ;load X with X+00h
FC32 : AD 00      jsr  $00,x          ;jump sub X+00h (JMPTBL derived)
FC34 : 20 08      bra  LFC3E          ;branch always IRQ7
;IRQ6
FC36 : 80 18      suba  #$18          ;sub A with 18h
FC38 : BD F8 2E   jsr  LF82E          ;jump sub VARILD
FC3B : BD F8 43   jsr  LF843          ;jump sub VARI
;IRQ7
FC3E : 96 04      ldaa  $04           ;load A with addr 04
FC40 : 9A 05      oraa  $05           ;or A with addr 05
;IRQ7LP
FC42 : 27 FE      beq  LFC42          ;branch Z=1 IRQ7LP
FC44 : 4F         clra                ;clear A
FC45 : 97 07      staa  $07           ;store A in addr 07
FC47 : 97 08      staa  $08           ;store A in addr 08
FC49 : 96 04      ldaa  $04           ;load A with addr 04
FC4B : 27 05      beq  LFC52          ;branch Z=1 IRQ8
FC4D : 2B 03      bmi  LFC52          ;branch N=1 IRQ8
FC4F : 7E F9 D3   jmp  LF9D3          ;jump VARPRM
;IRQ8
FC52 : 7E FA 27   jmp  LFA27          ;jump BG2
;*************************************;
;Add A to Index Register
;*************************************;
;ADDX
FC55 : DF 0E      stx  $0E            ;store X in addr 0E
FC57 : 9B 0F      adda  $0F           ;add A with addr 0F
FC59 : 97 0F      staa  $0F           ;store A in addr 0F
FC5B : 96 0E      ldaa  $0E           ;load A with addr 0E
FC5D : 89 00      adca  #$00          ;add C+A + 00h
FC5F : 97 0E      staa  $0E           ;store A in addr 0E
FC61 : DE 0E      ldx  $0E            ;load X with addr 0E
FC63 : 39         rts                 ;return subroutine
;*************************************;
;Tilt sound, buzz saw down
;*************************************;
;TILT
FC64 : CE 00 E0   ldx  #$00E0         ;load X with 00E0h
;TILT1
FC67 : 86 20      ldaa  #$20          ;load A with 20h
FC69 : 8D EA      bsr  LFC55          ;branch sub ADDX
;TILT2
FC6B : 09         dex                 ;decr X
FC6C : 26 FD      bne  LFC6B          ;branch Z=0 TILT2
FC6E : 7F 04 00   clr  $0400          ;clear DAC output SOUND
;TILT3
FC71 : 5A         decb                ;decr B 
FC72 : 26 FD      bne  LFC71          ;branch Z=0 TILT3
FC74 : 73 04 00   com  $0400          ;complement 1s DAC output SOUND
FC77 : DE 0E      ldx  $0E            ;load X with 0Eh
FC79 : 8C 10 00   cpx  #$1000         ;compare X with 1000h
FC7C : 26 E9      bne  LFC67          ;branch Z=0 TILT1
FC7E : 20 BE      bra  LFC3E          ;branch always IRQ7
;*************************************;
;Diagnostic Processing Here (NMI)
;*************************************;
;NMI
FC80 : 0F         sei                 ;set interrupt mask
FC81 : 8E 00 7F   lds  #$007F         ;load SP with 007Fh (#ENDRAM)
FC84 : CE FF FF   ldx  #$FFFF         ;load X with FFFFh
FC87 : 5F         clrb                ;clear B
;NMI1:
FC88 : E9 00      adcb  $00,x
FC8A : 09         dex
FC8B : 8C F8 00   cpx  #$F800         ;compare X with F800h
FC8E : 26 F8      bne  LFC88          ;branch Z=0 NMI1
FC90 : E1 00      cmpb  $00,x
FC92 : 27 01      beq  LFC95          ;branch Z=1 NMI2
FC94 : 3E         wai                 ;wait interrupt
;NMI2
FC95 : 7F 04 02   clr  $0402          ;clear addr 0402 PIA sound select
FC98 : CE 2E E0   ldx  #$2EE0         ;load X with 2EE0h
;NMI3
FC9B : 09         dex                 ;decr X
FC9C : 26 FD      bne  LFC9B          ;branch Z=0 NMI3
FC9E : BD F9 81   jsr  LF981          ;jump sub KNOCK
FCA1 : BD F9 81   jsr  LF981          ;jump sub KNOCK
FCA4 : BD F9 81   jsr  LF981          ;jump sub KNOCK
FCA7 : 86 80      ldaa  #$80          ;load  Awith 80h
FCA9 : B7 04 02   staa  $0402         ;store A in addr 0402
FCAC : 86 01      ldaa  #$01          ;load A wuth 01h
FCAE : BD FA 88   jsr  LFA88          ;jump sub GWLD
FCB1 : BD FA EE   jsr  LFAEE          ;jump sub GWAVE
FCB4 : 86 0B      ldaa  #$0B          ;load A with 0Bh
FCB6 : BD FA 88   jsr  LFA88          ;jump sub GWLD
FCB9 : BD FA EE   jsr  LFAEE          ;jump sub GWAVE
FCBC : BD F8 90   jsr  LF890          ;jump sub LITE
FCBF : 86 02      ldaa  #$02          ;load A with 02h
FCC1 : BD F8 2E   jsr  LF82E          ;jump sub VARILD
FCC4 : BD F8 43   jsr  LF843          ;jump sub VARI
;check for Speech ROM diagnostics
FCC7 : F6 DF FA   ldab  $DFFA         ;load B with addr DFFA (TALKD) - Speech ROM IC6
FCCA : C1 7E      cmpb  #$7E          ;compare B with 7Eh (looking for 7E jmp opcode)
FCCC : 26 B2      bne  LFC80          ;branch Z=0 NMI (NO)
FCCE : BD DF FA   jsr  LDFFA          ;jump sub DFFA (YES)
FCD1 : 20 AD      bra  LFC80          ;branch always NMI
;*************************************;
;Special Routine Jump Table
;*************************************;
;JMPTBL
FCD3 : F898                           ;APPEAR
FCD4 : F981                           ;KNOCK
FCD7 : F9C0                           ;BG1INC
FCD9 : FA3C                           ;SP1
FCDB : FA0D                           ;BGEND
FCDD : F8D1                           ;TURBO
FCDF : FA14                           ;BG2INC
FCE1 : FA64                           ;BON2
FCE3 : F890                           ;LITE
FCE5 : FA76                           ;BON1
;*************************************;
;FDB tables below
;*************************************;
;SNDTBL
FCE7 : DA FF DA 80 26 01 26 80        ;
FCEF : 07 0A 07 00 F9 F6 F9 00        ;
;NOTTBL 
FCF7 : 3A 3E 50 46 33 2C 27 20        ;
FCFF : 25 1C 1A 17 14 11 10 33        ;
;WAVFRM
FD07 : 08 03 02 01 02 03 04 05        ;
FD0F : 06 0A 1E 32 70 00              ;
;*************************************;
;VARI VECTORS
;*************************************;
;VVECT EQU *
FD15 : 40 01 00 10 E1 00 80 FF FF     ;SAW
FD1E : 20 01 00 08 E1 00 80 FF FF     ;
FD27 : 28 01 00 08 81 02 00 FF FF     ;FOSHIT
FD30 : 00 FF 08 FF 68 04 80 00 FF     ;CSCALE
FD39 : 28 81 00 FC 01 02 00 FC FF     ;QUASAR
;
FD42 : 01 01 00 08 81 02 00 01 FF     ;
FD4B : 01 08 00 01 20 01 00 01 FF     ;
FD54 : 60 01 57 08 E1 02 00 FE B0     ;
FD5D : FF 01 00 18 41 04 80 00 FF     ;CABSHK
FD66 : FF 01 00 50 41 04 80 FF FF     ;
;*************************************;
;* KNOCKER PATTERN
;*************************************;
;KNKTAB
FD6F : 01FC 02FC 03F8 04F8 06F8 08F4  ;
FD7B : 0CF4 10F4 20F2 40F1 60F1 80F1  ;
FD87 : A0F1 C0F1 0000                 ;
;*************************************;
;Wave table, 1st byte wave length
;*************************************;
;GWVTAB
FD8D : 08                             ;GS2
FD8E : 7F D9 FF D9 7F 24 00 24        ;
;
FD96 : 08                             ;GSQ2
FD97 : FF FF FF FF 00 00 00 00        ;
;
FD9F : 08                             ;GSSQ2
FDA0 : 00 40 80 00 FF 00 80 40        ;
;
FDA8 : 10                             ;GS1
FDA9 : 7F B0 D9 F5 FF F5 D9 B0        ;
FDB1 : 7F 4E 24 09 00 09 24 4E        ;
;
FDB9 : 10                             ;GS12
FDBA : 7F C5 EC E7 BF 8D 6D 6A        ;
FDC2 : 7F 94 92 71 40 17 12 39        ;
;
FDCA : 10                             ;GS1234
FDCB : 76 FF B8 D0 9D E6 6A 82        ;
FDD3 : 76 EA 81 86 4E 9C 32 63        ;
;
FDDB : 10                             ;GSQ12
FDDC : FF FF FF FF FF FF FF FF        ;
FDE4 : 00 00 00 00 00 00 00 00        ;
;
FDEC : 10                             ;GSQ22
FDED : FF FF FF FF 00 00 00 00        ;
FDF5 : FF FF FF FF 00 00 00 00        ;
;
FDFD : 10                             ;MW1
FDFE : 00 F4 00 E8 00 DC 00 E2        ;
FE06 : 00 DC 00 E8 00 F4 00 00        ;
;
FE0E : 48                             ;GS72
FE0F : 8A 95 A0 AB B5 BF C8 D1        ;
FE17 : DA E1 E8 EE F3 F7 FB FD        ;
FE1F : FE FF FE FD FB F7 F3 EE        ;
FE27 : E8 E1 DA D1 C8 BF B5 AB        ;
FE2F : A0 95 8A 7F 75 6A 5F 54        ;
FE37 : 4A 40 37 2E 25 1E 17 11        ;
FE3F : 0C 08 04 02 01 00 01 02        ;
FE47 : 04 08 0C 11 17 1E 25 2E        ;
FE4F : 37 40 4A 54 5F 6A 75 7F        ;
;
FE57 : 10                             ;GS1.7
FE58 : 59 7B 98 AC B3 AC 98 7B        ;
FE60 : 59 37 19 06 00 06 19 37        ;
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
FE68 : 14 10 00 01 00 01 6A           ;(1,106)
FE6F : 81 27 00 00 00 16 54           ;(22,84)
FE76 : 12 09 1A FF 00 27 91           ;(39,-111)
FE7D : 11 09 11 01 0F 01 6A           ;(1,106)
FE84 : 11 32 00 01 00 0D 1B           ;(13,27)
FE8B : 14 11 00 00 00 0E 0D           ;(14,13)
FE92 : F4 13 00 00 00 14 6A           ;(20,106)
FE99 : 41 49 00 00 00 0F 7E           ;(15,126)
FEA0 : 21 39 11 FF 00 0D 1B           ;(13,27)
FEA7 : 42 46 00 00 00 0E 28           ;(14,40)
FEAE : 15 00 00 FD 00 01 8C           ;(1,-116)
FEB5 : F1 18 00 00 00 0E 28           ;(14,40)(UNKN1)
FEBC : 31 12 00 01 00 03 8D           ;(3,-115)
FEC3 : 81 09 11 FF 00 01 90           ;(1,-112)
FECA : 31 12 00 FF 00 0D 00           ;(13,0)
FED1 : 12 0A 00 FF 01 09 4B           ;(9,75) 
;*************************************;
;GWAVE FREQ PATTERN TABLE
;*************************************;
;GFRTAB 
;Bonus Sound
FED8 : A0 98 90 88 80 78 70 68        ;BONSND
FEE0 : 60 58 50 44 40                 ;
;Hundred Point Sound
FEE5 : 01 01 02 02 04 04 08 08        ;HBTSND
FEED : 10 10 30 60 C0 E0              ;
;Spinner Sound
FEF3 : 01 01 02 02 03 04 05 06        ;SPNSND
FEFB : 07 08 09 0A 0C                 ;
;
FF00 : 08 80 10 78 18 70 20 60        ;UNKN1
FF08 : 28 58 30 50 40 48              ;
;
FF0E : 04 05 06 07 08 0A 0C 0E        ;UNKN2
FF16 : 10 11 12 13 14 15 16 17        ;
FF1E : 18 19 1A 1B 1C                 ;
;Turbine Start Up
FF23 : 80 7C 78 74 70 74 78 7C 80     ;TRBPAT
;Heartbeat Distorto 
FF2C : 01 01 02 02 04 04 08 08        ;HBDSND
FF34 : 10 20 28 30 38 40 48 50        ;
FF3C : 60 70 80 A0 B0 C0              ;
;*
;*SWPAT - SWEEP PATTERN
;BigBen Sounds
FF42 : 08 40 08 40 08 40 08 40 08 40  ;BBSND
FF4C : 08 40 08 40 08 40 08 40 08 40  ;
;Heartbeat Echo
FF56 : 01 02 04 08 09 0A 0B 0C        ;HBESND
FF5E : 0E 0F 10 12 14 16              ;
;Spinner Sound "Drip"
FF64 : 40                             ;SPNR
;Cool Downer
FF65 : 10 08 01                       ;COOLDN 
;
FF68 : 92                             ;UNKN3
;Start Distorto Sound
FF69 : 01 01 01 01 02 02 03 03        ;STDSND
FF71 : 04 04 05 06 08 0A 0C 10        ;
FF79 : 14 18 20 30 40 50 40 30        ;
FF81 : 20 10 0C 0A 08 07 06 05        ;
FF89 : 04 03 02 02 01 01 01           ;
;*************************************;
;zero padding
FF90 : 00 00 00 00 00 00 00 00 
FF98 : 00 00 00 00 00 00 00 00 
FFA0 : 00 00 00 00 00 00 00 00 
FFA8 : 00 00 00 00 00 00 00 00 
FFB0 : 00 00 00 00 00 00 00 00 
FFB8 : 00 00 00 00 00 00 00 00 
FFC0 : 00 00 00 00 00 00 00 00 
FFC8 : 00 00 00 00 00 00 00 00 
FFD0 : 00 00 00 00 00 00 00 00 
FFD8 : 00 00 00 00 00 00 00 00 
FFE0 : 00 00 00 00 00 00 00 00 
FFE8 : 00 00 00 00 00 00 00 00 
FFF0 : 00 00 00 
;*************************************;
;Speech ROM6 jump sub destination
;*************************************;
FFF3 : 7E FC 55   jmp  LFC55          ;jump ADDX
;
FFF6 : DFDA                           ;JMPTBL addr in ROM6
;*************************************;
;Motorola vector table
;*************************************;
FFF8 : FB BF                          ;IRQ 
FFFA : F8 01                          ;RESET SWI (software) 
FFFC : FC 80                          ;NMI 
FFFE : F8 01                          ;RESET (hardware) 

;--------------------------------------------------------------





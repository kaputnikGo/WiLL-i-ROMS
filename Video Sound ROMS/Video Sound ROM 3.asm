        ;
        ;  Disassembled by:
        ;    DASMx object code disassembler
        ;    (c) Copyright 1996-2003   Conquest Consultants
        ;    Version 1.40 (Oct 18 2003)
        ;
        ;  File:    Robotron.532
        ;
        ;  Size:    4096 bytes
        ;  Checksum:  6780
        ;  CRC-32:    C56C1D28
        ;
        ;  Date:    Thu May 20 11:01:16 2021
        ;
        ;  CPU:    Motorola 6800 (6800/6802/6808 family)
        ;
        ; Video ROM 3, Robotron 2048, 1982
        ; 
        ;
        ;redo, merge with source - source comments and notes are in CAPS
        ;
        ;updated 4 June 2021
        ;
        ;
;  NAM  ROBOTRON SOUNDS VERSION 1.0  3-8-82 
;*COPYRIGHT WILLIAMS ELECTRONICS INC. 2084
;*PROGRAMMERS: EUGENE P. JARVIS, SAM DICKER,RANDY PFEIFFER,JOHN KOTLARIK
;*    PAUL G. DUSSAULT,CARY W. KOLKER,TIM  MURPHY
;*      AND A CAST OF THOUSANDS......
;*
        ;
;NOGEN
;
;*
;*SYSTEM CONSTANTS
;*
ROM      EQU  $F000
SOUND    EQU  $400
CKORG    EQU  $EF00     ;CHECKSUM PROG ORG
ENDRAM   EQU  $7F
VECTOR   EQU  $FFF8     ;RESET,INT VECTORS
WVELEN   EQU  72
BG1MAX   EQU  29        ;MAX BACKGROUND INCREMENT
HBLEN    EQU  72
BG2MAX   EQU  29  
SP1SND   EQU  $0E       ;SPINNER SOUND #1 CODE
B2SND    EQU  $12       ;BONUS SOUND #2 CODE
SP1MAX   EQU  32
NIN      EQU  5
FIF      EQU  6
TAF      EQU  34715!>1  ;NOTE TIMES
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
;*
;* SCREAM EQUATES
;*
ECHOS    EQU  4
FREQ     EQU  0 
TIMER    EQU  1
;*
;*GLOBALS
;*
        ORG  0
BG1FLG  RMB  1          ;BACKGROUND SOUND 1
BG2FLG  RMB  1          ;BACKGROUND SOUND 2
SP1FLG  RMB  1          ;SPINNER FLAG
B2FLG   RMB  1          ;BONUS #2 FLAG
ORGFLG  RMB  1          ;ORGAN FLAG
HI      RMB  1          ;RANDOM SEED
LO      RMB  1          ;RANDOM SEED
XDECAY  RMB  2
AMP0    RMB  1
;*
;*
;*TEMPORARIES
;*
TMPRAM  EQU  *          ;TEMPORARY RAM
TEMPX   RMB  2          ;X TEMPS
XPLAY   RMB  2
XPTR    RMB  2
TEMPA   RMB  1          ;ACCA TEMP
TEMPB   RMB  1
LOCRAM  EQU  *
;*
;*GWAVE PARAMETERS
;*
        ORG  LOCRAM
GECHO   RMB  1          ;ECHO FLAG
GCCNT   RMB  1          ;CYCLE COUNT
GECDEC  RMB  1          ;# OF DECAYS PER ECHO
GDFINC  RMB  1          ;DELTA FREQ INC
GDCNT   RMB  1          ;DELTA FREQ COUNT
GWFRM   RMB  2          ;WAVEFORM ADDRESS
;*TEMPORARY OR COMPUTED PARAMETERS
PRDECA  RMB  1          ;PRE-DECAY FACTOR
GWFRQ   RMB  2          ;FREQ TABLE ADDR
FRQEND  RMB  2          ;END ADDR FREQ TABLE
WVEND   RMB  2          ;WAVE END ADDR
GPER    RMB  1          ;PERIOD
GECNT   RMB  1          ;# OF ECHOES COUNTER
FOFSET  RMB  1          ;FREQUENCY OFFSET
;*
;*GWAVE TABLES
;*
GWTAB   RMB  WVELEN     ;WAVE TABLE
;*
;*VARIWAVE PARAMETERS
;*
        ORG  LOCRAM
LOPER   RMB  1          ;LO PERIOD
HIPER   RMB  1          ;HIPERIOD
LODT    RMB  1          ;PERIOD DELTAS
HIDT    RMB  1
HIEN    RMB  1          ;END PERIOD
SWPDT   RMB  2          ;SWEEP PERIOD
LOMOD   RMB  1          ;BASE FREQ MOD
VAMP    RMB  1          ;AMPLITUDE
LOCNT   RMB  1          ;PERIOD COUNTERS
HICNT   RMB  1
;* SIREN AND BOMB RAM
        ORG  LOCRAM
TOP     RMB  2
SWEEP   RMB  2
SLOPE   RMB  1
END2    RMB  2
TIME    RMB  1
TABLE   RMB  2
FREQZ   RMB  1
;*
;* KNOCKER RAM
;*
        ORG  LOCRAM
PERIOD  RMB  1
AMP     RMB  1
SNDTMP  RMB  2          ;INDEX TMEP
;*
;* FLASH LOCAL RAM
        ORG  LOCRAM
FREQ1   RMB  1          ;FREQUENCY CONSTANT 1
FREQ2   RMB  1          ;FREQUENCY CONSTANT 2
FREQ3   RMB  1          ;FREQUENCY CONSTANT 3
FREQ4   RMB  1          ;FREQUENCY CONSTANT 4
DELTA1  RMB  1          ;DELTA AMPLITUDE 1
DELTA2  RMB  1          ;DELTA AMPLITUDE 2
DELTA3  RMB  1          ;DELTA AMPLITUDE 3
DELTA4  RMB  1          ;DELTA AMPLITUDE 4
FREQ1$  RMB  1          ;FREQUENCY COUNTER 1
FREQ2$  RMB  1          ;FREQUENCY COUNTER 2
FREQ3$  RMB  1          ;FREQUENCY COUNTER 3
FREQ4$  RMB  1          ;FREQUENCY COUNTER 4
CYCLE1  RMB  1          ;CYCLE CONSTANT 1
CYCLE2  RMB  1          ;CYCLE CONSTANT 2
CYCLE3  RMB  1          ;CYCLE CONSTANT 3
CYCLE4  RMB  1          ;CYCLE CONSTANT 4
DFREQ1  RMB  1          ;DELTA FREQUENCY 1
DFREQ2  RMB  1          ;DELTA FREQUENCY 2
DFREQ3  RMB  1          ;DELTA FREQUENCY 3
DFREQ4  RMB  1          ;DELTA FREQUENCY 4
EFREQ1  RMB  1          ;END FREQUENCY 1
EFREQ2  RMB  1          ;END FREQUENCY 2
EFREQ3  RMB  1          ;END FREQUENCY 3
EFREQ4  RMB  1          ;END FREQUENCY 4
CYCL1$  RMB  1          ;CYCLE COUNTER 1
CYCL2$  RMB  1          ;CYCLE COUNTER 2
CYCL3$  RMB  1          ;CYCLE COUNTER 3
CYCL4$  RMB  1          ;CYCLE COUNTER 4
SNDX1   RMB  1

RANDOM  EQU  LO         ;SINGLE BYTE RANDOM
        ORG  LOCRAM+1
FREQ$   RMB  1          ;START FREQUENCY
C$FRQ   RMB  1          ;CYCLES AT FREQUENCY
D$FRQ   RMB  1          ;DELTA FREQUENCY
E$FRQ   RMB  1          ;END FREQUENCY
C$AMP   RMB  1          ;CYCLES AT AMPLITUDE
D$AMP   RMB  1          ;DELTA AMPLITUDE
C$AMP$  RMB  1          ;CYCLE COUNTER
C$FRQ$  RMB  1          ;CYCLE COUNTER
;*
;*NOISE/CROWD ROAR ROUTINE PARAMETERS
;*
        ORG  LOCRAM
DECAY   RMB  1
NAMP    RMB  1
CYCNT   RMB  1
NFRQ1   RMB  2
NFFLG   RMB  1
LFREQ   RMB  1
DFREQ   RMB  1
GALPAM  EQU  *
CYCNT2  RMB  1
NAMP2   RMB  1
DECAY2  RMB  1
NFFLG2  RMB  1
NFR2    RMB  1
GALCNT  RMB  1
WHIS    RMB  1          ;CROWD ROAR AMP
WFRQ    RMB  1          ;CROWD WHISTLE FREQ
WCNT    RMB  1          ;WHISTLE PASSCOUNTER
PTRHI   RMB  2          ;WHIS ADR PTR
WFRQ2   RMB  1
WCNT2   RMB  1
CURVAL  RMB  1          ;WHISTLING NOISE OUTPUT
ATP     RMB  1          ;INTERM NOISE VAL
MINWIS  RMB  1          ;MIN WHISTLE FREQ
CY2     RMB  1          ;NOISE CYCLE COUNTER
DFRQ    RMB  1          ;WHISTLE FREQ CHANGE
DFRQ2   RMB  1          ;INIT WHISTLE FREQ CHANGE
NNOIS   RMB  1          ;NEXT NOISE VALUE
NFRQ    RMB  1          ;NOISE FREQ
NFRQ2   RMB  1          ;INIT NOISE FREQ
RCNT2   RMB  1
;*
;*FILTERED NOISE ROUTINE PARAMETERS
;*
        ORG  LOCRAM
FMAX    RMB  1          ;MAXIMUM_FREQUENCY
FHI     RMB  1          ;FREQUENCY
FLO     RMB  1 
LOFRQ   RMB  1
SAMPC   RMB  2          ;SAMPLE COUNT
FDFLG   RMB  1          ;FREQUENCY DECREMENT FLAG
DSFLG   RMB  1          ;DISTORTION FLAG
;*
;*SCREAM TABLES
;*
        ORG  LOCRAM
STABLE  RMB  2*ECHOS    ;SCREAM TABLE
SRMEND  EQU  *
;*
;*ORGAN PARAMETERS
;*
        ORG  LOCRAM
DUR     RMB  2          ;NOTE DURATION
OSCIL   RMB  1          ;OSCILLATORS
RDELAY  RMB  60         ;RAM DELAY LOAD
;*
;* CHECKSUM CALCULATOR & RELOCATOR
;*
        ORG  CKORG
CKSUM   LDX  #$FFFF     ;INDEX TO END OF ROM
        CLRB            ;ZERO CHECKSUM
CKSUM1  ADCB  0,X       ;ADD IN PROGRAM BYTE
        DEX             ;TO NEXT BYTE
        CPX  #$F000     ;DONE YET?
        BNE  CKSUM1     ;NOPE...
        STAB  0,X       ;SAVE CHECKSUM AT BEGINNING
        WAI             ;TURN OFF LEDS
FROM    RMB  2          ;FOR POINTER
TO      RMB  2          ;FOR POINTER
;*
;* MAIN PROGRAM
;*
        ;
org  $F000
        ;
F000 : 76                             ;checksum byte
;*************************************;
; Copyright Message - FCC
;*************************************;
F001 : 28 43    "(C"                  ;(C)
F003 : 29 31    ")1"                  ;1982
F005 : 39    "9"
F006 : 38    "8"
F007 : 32    "2"
F008 : 20 57    " W"                  ;WILLIAMS
F00A : 49    "I"
F00B : 4C    "L"
F00C : 4C    "L"
F00D : 49    "I"
F00E : 41    "A"
F00F : 4D    "M"
F010 : 53    "S"
F011 : 20 45    " E"                  ;ELECTRONICS
F013 : 4C    "L"
F014 : 45    "E"
F015 : 43    "C"
F016 : 54    "T"
F017 : 52    "R"
F018 : 4F    "O"
F019 : 4E    "N"
F01A : 49    "I"
F01B : 43    "C"
F01C : 53    "S"
;*************************************;
;RESET power on
;*************************************;
;SETUP
F01D : 0F         sei                 ;set interrupt mask 
F01E : 8E 00 7F   lds  #$007F         ;load stack pointer with 007Fh (#ENDRAM) INITIALIZE STACK POINTER
F021 : CE 04 00   ldx  #$0400         ;load X with 0400h (#SOUND ) INDEX TO PIA
F024 : 6F 01      clr  $01,x          ;clear X+00h (ACCESS DDRA)
F026 : 6F 03      clr  $03,x          ;clear X+00h (ACCESS DDRB)
F028 : 86 FF      ldaa  #$FF          ;load A with FFh (PA0-PA7)
F02A : A7 00      staa  $00,x         ;store A in X+00h (SET SIDE A AS OUTPUTS)
F02C : 6F 02      clr  $02,x          ;clear X+02h (SET B SIDE AS INPUTS)
F02E : 86 37      ldaa  #$37          ;load A with 37h (CB2 LOW, IRQ ALLOWED)
F030 : A7 03      staa  $03,x         ;store A in X+03h (PROGRAM B CONTROL REG)
F032 : 86 3C      ldaa  #$3C          ;load A with 3Ch (CA2 SET INIT HIGH, NO IRQS)
F034 : A7 01      staa  $01,x         ;store A in X+01h (PROGRAM A SIDE)
F036 : 97 05      staa  $05           ;store A in addr 05 (HI) START RANDOM GENERATOR
F038 : 4F         clra                ;clear A 
F039 : 97 03      staa  $03           ;store A in addr 03 (B2FLG)
F03B : 97 00      staa  $00           ;store A in addr 00 (BG1FLG)
F03D : 97 01      staa  $01           ;store A in addr 01 (BG2FLG)
F03F : 97 02      staa  $02           ;store A in addr 02 (SP1FLG)
F041 : 97 04      staa  $04           ;store A in addr 04 (ORGFLG)
F043 : 0E         cli                 ;clear interrupts 
F044 : 20 FE      bra  LF044          ;branch always here (*) WAIT FOR INTERRUPT
;*************************************;
;* THREE OSCILLATOR SOUND GENERATOR
;*************************************;
;PLAY
F046 : DF 0C      stx  $0C            ;store X in addr 0C (XPLAY) SAVE CURRENT INDEX
F048 : CE F0 EB   ldx  #$F0EB         ;load X with F0EBh (#DECAYZ) SET TO MAXIMUM AMPLITUDE
F04B : DF 07      stx  $07            ;store X in addr 07 (XDECAY) AND SAVE
F04D : 86 80      ldaa  #$80          ;load A with 80h (LOAD ZERO AMPLITUDE)
;PLAY1
F04F : D6 15      ldab  $15           ;load B with addr 15 (FREQ4) CHECK WHITE NOISE COUNTER
F051 : 2A 09      bpl  LF05C          ;branch N=0 PLAY3 (NOT IN WHITE MODE)
F053 : D6 06      ldab  $06           ;load B with addr 06 (RANDOM) GET RANDOM NUMBER
F055 : 54         lsrb                ;logic shift right B (REDUCE IT)
F056 : 54         lsrb                ;logic shift right B
F057 : 54         lsrb                ;logic shift right B
F058 : 5C         incb                ;logic shift right B (NOW NON-ZERO)
;PLAY2
F059 : 5A         decb                ;decr B (TIME OUT COUNT)
F05A : 26 FD      bne  LF059          ;branch Z=0 PLAY2
;PLAY3
F05C : 7A 00 1A   dec  $001A          ;decr addr 001A (FREQ1$) COUNT DOWN OSC. 1
F05F : 27 4C      beq  LF0AD          ;branch Z=1 PLAY7 (DO AN UPDATE)
F061 : 7A 00 1B   dec  $001B          ;decr addr 001B (FREQ2$) COUNT DOWN OSC. 2
F064 : 27 4C      beq  LF0B2          ;branch Z=1 PLAY8 (DO AN UPDATE)
F066 : 7A 00 1C   dec  $001C          ;decr addr 001C (FREQ3$) COUNT DOWN OSC. 3
F069 : 27 4C      beq  LF0B7          ;branch Z=1 PLAY9 (DO AN UPDATE)
F06B : 7A 00 1D   dec  $001D          ;decr addr 001D (FREQ4$) COUNT DOWN WHITE NOISE
F06E : 26 DF      bne  LF04F          ;branch Z=0 PLAY1 (DO THEM AGAIN)
F070 : D6 15      ldab  $15           ;load B with addr 15 (FREQ4) CHECK WHITE NOISE CONSTANT
F072 : 27 DB      beq  LF04F          ;branch Z=1 PLAY1 (FORGET IT)
F074 : C4 7F      andb  #$7F          ;and A with 7Fh (STRIP FLAG BIT)
F076 : D7 1D      stab  $1D           ;store B in addr 1D (FREQ4$) SAVE WHITE NOISE COUNT
F078 : D6 06      ldab  $06           ;load B with addr 06 (RANDOM) GET CURRENT RANDOM
F07A : 58         aslb                ;arith shift left B (DOUBLE)
F07B : DB 06      addb  $06           ;add B with addr 06 (RANDOM) TRIPLE
F07D : CB 0B      addb  #$0B          ;add B with 0Bh (ADD IN 11)
F07F : D7 06      stab  $06           ;store B in addr 06 (RANDOM) VOILA...NEW RANDOM NUMBER
F081 : 7A 00 2D   dec  $002D          ;decr addr 002D (CYCL4$) COUNT DOWN DECAY
F084 : 26 0E      bne  LF094          ;branch Z=0 PLAY6 (DON'T DECAY)
F086 : D6 21      ldab  $21           ;load B with addr 21 (CYCLE4) RELOAD COUNT
F088 : D7 2D      stab  $2D           ;store B in addr 2D (CYCL4$) AND SAVE
F08A : DE 07      ldx  $07            ;load X with addr 07 (XDECAY) GET DECAY JUMP POINTER
F08C : 09         dex                 ;decr X (MOVE TO LESS AMPLITUDE)
F08D : 8C F0 E4   cpx  #$F0E4         ;compare X with F0E4h (#RDECAY+1) DONE?
F090 : 27 4E      beq  LF0E0          ;branch Z=1 PLAY12 (YUP...BYE BYE)
F092 : DF 07      stx  $07            ;store X in addr 07 (XDECAY) SAVE NEW POINTER
;PLAY6
F094 : D6 06      ldab  $06           ;load B with addr 06 (RANDOM) GET RANDOM AMPLITUDE
F096 : 2B 06      bmi  LF09E          ;branch N=1 PLAY6A (SKIP IF NEGATIVE)
F098 : D4 19      andb  $19           ;and B with addr 19 (DELTA4) REDUCE AMPLITUDE
F09A : C4 7F      andb  #$7F          ;and B with 7Fh (STRIP SIGN BIT)
F09C : 20 05      bra  LF0A3          ;branch always PLAY6B
;PLAY6A
F09E : D4 19      andb  $19           ;andB with addr 19 (DELTA4) REDUCE AMPLITUDE
F0A0 : C4 7F      andb  #$7F          ;and B with 7Fh (REMOVE SIGN BIT)
F0A2 : 50         negb                ;negate B 
;PLAY6B
F0A3 : 36         psha                ;push A into stack then SP-1
F0A4 : 1B         aba                 ;add B to A (ADD WHITE NOISE)
F0A5 : 16         tab                 ;transfer A to B
F0A6 : 32         pula                ;SP+1 pull stack into A
F0A7 : DE 07      ldx  $07            ;load X with addr 07 (XDECAY) GET DECAY POINTER
F0A9 : AD 00      jsr  $00,x          ;jump sub addr X+00h (OUTPUT NOISE)
F0AB : 20 A2      bra  LF04F          ;branch always PLAY1 (DO SOME MORE)
;PLAY7
F0AD : CE 00 12   ldx  #$0012         ;load X with 0012h (#FREQ1) INDEX TO SET 1
F0B0 : 20 08      bra  LF0BA          ;branch always PLAY10
;PLAY8
F0B2 : CE 00 13   ldx  #$0013         ;load X with 0013h (#FREQ2) INDEX TO SET 2
F0B5 : 20 03      bra  LF0BA          ;branch always PLAY10
;PLAY9
F0B7 : CE 00 14   ldx  #$0014         ;load X with 0014h (#FREQ3) INDEX TO SET 3
;PLAY10
F0BA : 6D 18      tst  $18,x          ;test addr X+18h (#24) CHECK CYCLES AT FREQUENCY
F0BC : 27 12      beq  LF0D0          ;branch Z=1 PLAY11 (ZERO, DON'T CHANGE)
F0BE : 6A 18      dec  $18,x          ;decr X+18h (#24) COUNT DOWN 
F0C0 : 26 0E      bne  LF0D0          ;branch Z=0 PLAY11 (NOT TIME TO CHANGE...)
F0C2 : E6 0C      ldab  $0C,x         ;load B with X+0Ch (#12) LOAD CYCLES AT FREQUENCY
F0C4 : E7 18      stab  $18,x         ;store B in X+18h (#24) SAVE IN COUNTER
F0C6 : E6 00      ldab  $00,x         ;load B with X+00h (GET CURRENT FRQUENCY)
F0C8 : EB 10      addb  $10,x         ;add B with X+10h (#16) ADD DELTA
F0CA : E1 14      cmpb  $14,x         ;compare B with X+14h (#20) COMPARE TO END
F0CC : 27 12      beq  LF0E0          ;branch Z=1 PLAY12 (DONE...)
F0CE : E7 00      stab  $00,x         ;store B in addr X+00h (SAVE NEW CURRENT FREQUENCY)
;PLAY11
F0D0 : E6 00      ldab  $00,x         ;load B with X+00h (GET CURRENT FREQUENCY)
F0D2 : E7 08      stab  $08,x         ;store B in addr X+08h (SAVE IN FREQUENCY COUNTER)
F0D4 : AB 04      adda  $04,x         ;add A with X+04h (ADD IN AMPLITUDE)
F0D6 : 60 04      neg  $04,x          ;negate addr X+04h (NEGATE AMPLITUDE)
F0D8 : 16         tab                 ;transfer A to B (SAVE DATA)
F0D9 : DE 07      ldx  $07            ;load X with addr 07 (XDECAY) INDEX TO DECAY
F0DB : AD 00      jsr  $00,x          ;jump sub addr X+00h (OUTPUT SOUND)
F0DD : 7E F0 4F   jmp  LF04F          ;jump PLAY1 (REPEAT)
;PLAY12
F0E0 : DE 0C      ldx  $0C            ;load X with addr 0C (XPLAY) RESTORE INDEX
F0E2 : 39         rts                 ;return subroutine
;*************************************;
;* ECHO AND DECAY ROUTINE
;*************************************;
;RDECAY
F0E3 : 54         lsrb                ;logic shift right B
F0E4 : 54         lsrb                ;logic shift right B
F0E5 : 54         lsrb                ;logic shift right B
F0E6 : 54         lsrb                ;logic shift right B
F0E7 : 54         lsrb                ;logic shift right B
F0E8 : 54         lsrb                ;logic shift right B
F0E9 : 54         lsrb                ;logic shift right B
F0EA : 54         lsrb                ;logic shift right B
;DECAYZ
F0EB : F7 04 00   stab  $0400         ;store B in DAC output SOUND
F0EE : 39         rts                 ;return subroutine
;*************************************;
;* 3 OSCILLATOR CALLING ROUTINES
;*************************************;
;THNDR
F0EF : CE F3 D2   ldx  #$F3D2         ;load X with F3D2h (#VEC01) THUNDER SOUND
;THNDR1
F0F2 : C6 1C      ldab  #$1C          ;load B with 1Ch (#28) NEED TO TRANSFER
F0F4 : BD F9 65   jsr  LF965          ;jump sub TRANS (28 BYTES FOR PLAY)
F0F7 : BD F0 46   jsr  LF046          ;jump sub PLAY (NOW PLAY IT)
F0FA : 39         rts                 ;return subroutine
;SND2
F0FB : CE F3 EE   ldx  #$F3EE         ;load X with F3EEh (#VEC02) SOUND 2
F0FE : 20 F2      bra  LF0F2          ;branch always THNDR1
;SND3
F100 : CE F4 0A   ldx  #$F40A         ;load X with F40Ah (#VEC03) SOUND 3
F103 : 20 ED      bra  LF0F2          ;branch always THNDR1
;SND4
F105 : CE F4 26   ldx  #$F426         ;load X with F426h (#VEC04) SOUND 4
F108 : 20 E8      bra  LF0F2          ;branch always THNDR1
;SND5
F10A : CE F4 42   ldx  #$F442         ;load X with F442h (#VEC05) SOUND 5
F10D : 20 E3      bra  LF0F2          ;branch always THNDR1
;SND16
F10F : CE F4 7A   ldx  #$F47A         ;load X with F47Ah (#VEC016)
F112 : 20 DE      bra  LF0F2          ;branch always THNDR1
;SND17
F114 : CE F4 96   ldx  #$F496         ;load X with F496h (#VEC017)
F117 : 20 D9      bra  LF0F2          ;branch always THNDR1
;*************************************;
;* PROGRESSIVE PITCH BONUS COUNTDOWN
;*************************************;
;BONUS$
F119 : CE 00 60   ldx  #$0060         ;load X with 0060h (PROGRESSIVE SINGLE FREQUENCY)
F11C : A6 00      ldaa  $00,x         ;load A with X+00h (GET CURRENT FREQUENCY)
F11E : 80 02      suba  #$02          ;sub A with 02h (NOW HIGHER)
F120 : A7 00      staa  $00,x         ;store A in addr X+00h (SAVE NEW FREQUENCY)
F122 : BD F3 30   jsr  LF330          ;jump sub MOVE (SET UP FOR SING)
F125 : 7E F3 49   jmp  LF349          ;jump SING (PLAY IT)
;*************************************;
;* DIVING PLANE SOUND
;*************************************;
;PLANE
F128 : CE 00 01   ldx  #$0001         ;load X with 0001h (SET FOR SHORT HALF CYCLE)
F12B : DF 12      stx  $12            ;store X in addr 12 (FREQ1) SAVE VALUE
F12D : CE 03 80   ldx  #$0380         ;load X with 0380h (SET FOR LONG HALF CYCLE)
F130 : DF 14      stx  $14            ;store X in addr 14 (FREQ3) SAVE VALUE
;PLANE1
F132 : 7F 04 00   clr  $0400          ;clear DAC output SOUND (SEND OUT ZEROES)
F135 : DE 12      ldx  $12            ;load X with addr 12 (FREQ1) GET LOW HALF CYCLE DATA
F137 : 08         inx                 ;incr X (INCREASE HALF CYCLE)
F138 : DF 12      stx  $12            ;store X in addr 12 (FREQ1) SAVE NEW VALUE
;PLANE2
F13A : 09         dex                 ;decr X (COUNT DOWN)
F13B : 26 FD      bne  LF13A          ;branch Z=0 PLANE2
F13D : 73 04 00   com  $0400          ;complement 1s DAC output SOUND (SEND OUT ONES)
F140 : DE 14      ldx  $14            ;load X with addr 14 (FREQ3) GET HIGH HALF CYCLE DATA
;PLANE3
F142 : 09         dex                 ;decr X (COUNT DOWN)
F143 : 26 FD      bne  LF142          ;branch Z=0 PLANE3
F145 : 20 EB      bra  LF132          ;branch always PLANE1
;*************************************;
;*  SIREN   AIR RAID
;*************************************;
;ZIREN
F147 : 86 FF      ldaa  #$FF          ;load A with FFh
F149 : 97 12      staa  $12           ;store A in addr 12 (TOP)
F14B : CE FE C0   ldx  #$FEC0         ;load X with FEC0h
F14E : DF 14      stx  $14            ;store X in addr 14 (SWEEP)
F150 : 86 20      ldaa  #$20          ;load A with 20h
F152 : CE FF E0   ldx  #$FFE0         ;load X with FFE0h
F155 : 8D 05      bsr  LF15C          ;branch sub ZIREN0
F157 : 86 01      ldaa  #$01          ;load A with 01h
F159 : CE 00 44   ldx  #$0044         ;load X with 0044h
;ZIREN0
F15C : 97 16      staa  $16           ;store A in addr 16 (SLOPE)
F15E : DF 17      stx  $17            ;store X in addr 17 (END2)
;ZIREN1
F160 : CE 00 10   ldx  #$0010         ;load X with 0010h
;ZIREN2
F163 : 8D 21      bsr  LF186          ;branch sub ZIRLOP
F165 : 96 13      ldaa  $13           ;load A with addr 13 (TOP+1)
F167 : 9B 15      adda  $15           ;add A with addr 15 (SWEEP+1)
F169 : 97 13      staa  $13           ;store A with addr 13 (TOP+1
F16B : 96 12      ldaa  $12           ;load A with addr 12 (TOP)
F16D : 99 14      adca  $14           ;add C+A with addr 14 (SWEEP)
F16F : 97 12      staa  $12           ;store A with addr 12 (TOP)
F171 : 09         dex                 ;decr X
F172 : 26 EF      bne  LF163          ;branch Z=0 ZIREN2
F174 : 96 15      ldaa  $15           ;load A with addr 15 (SWEEP+1)
F176 : 9B 16      adda  $16           ;add A with addr 16 (SLOPE)
F178 : 97 15      staa  $15           ;store A with addr 15 (SWEEP+1)
F17A : 24 03      bcc  LF17F          ;branch C=0 ZIREN5
F17C : 7C 00 14   inc  $0014          ;incr addr 0014 (SWEEP)
;ZIREN5
F17F : DE 14      ldx  $14            ;load X with addr 14 (SWEEP)
F181 : 9C 17      cpx  $17            ;compare X with addr 17 (END2)
F183 : 26 DB      bne  LF160          ;branch Z=0 ZIREN1
F185 : 39         rts                 ;return subroutine
;*FLAT TRIANGLE LOOP
;ZIRLOP
F186 : 4F         clra                ;clear A
;ZIRLP1
F187 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F18A : 8B 20      adda  #$20          ;add A with 20h
F18C : 24 F9      bcc  LF187          ;branch C=0 ZIRLP1
F18E : 8D 09      bsr  LF199          ;branch sub ZIRT
F190 : 86 E0      ldaa  #$E0          ;load A with EOh
;ZIRLP4
F192 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F195 : 80 20      suba  #$20          ;sub A with 20h
F197 : 24 F9      bcc  LF192          ;branch C=0 ZIRLP4
;ZIRT
F199 : D6 12      ldab  $12           ;load B with addr 12 (TOP)
;ZIRLP2
F19B : 86 02      ldaa  #$02          ;load A with 02h
;ZIRLP3
F19D : 4A         deca                ;decr A
F19E : 26 FD      bne  LF19D          ;branch Z=0 ZIRLP3
F1A0 : 5A         decb                ;decr B
F1A1 : 26 F8      bne  LF19B          ;branch Z=0 ZIRLP2
F1A3 : 39         rts                 ;return subroutine
;*************************************;
;* THE BOMB OOOOOH NOOOOO!
;*************************************;
;WHIST
F1A4 : 86 80      ldaa  #$80          ;load A with 80h
F1A6 : 97 1C      staa  $1C           ;store A in addr 1C (FREQZ)
F1A8 : 86 F1      ldaa  #$F1          ;load A with F1h (#SINTBL/$100)
F1AA : 97 1A      staa  $1A           ;store A in addr 1A (TABLE)
;WHIST0
F1AC : 86 80      ldaa  #$80          ;load A with 80h
F1AE : 97 10      staa  $10           ;store A in addr 10 (TEMPA)
;WHIST1
F1B0 : 86 12      ldaa  #$12          ;load A with 12h
;WHIST2
F1B2 : 4A         deca                ;decr A
F1B3 : 26 FD      bne  LF1B2          ;branch Z=0 WHIST2
F1B5 : 96 19      ldaa  $19           ;load A with addr 19 (TIME)
F1B7 : 9B 1C      adda  $1C           ;add A with 1C (FREQZ)
F1B9 : 97 19      staa  $19           ;store A in addr 19 (TIME)
F1BB : 44         lsra                ;logic shift right A
F1BC : 44         lsra                ;logic shift right A
F1BD : 44         lsra                ;logic shift right A
F1BE : 8B D8      adda  #$D8          ;add A with D8h (#SINTBL!.$FF)
F1C0 : 97 1B      staa  $1B           ;store A in addr 1B (TABLE+1)
F1C2 : DE 1A      ldx  $1A            ;load X with addr 1A (TABLE)
F1C4 : A6 00      ldaa  $00,x         ;load A with addr X+00h
F1C6 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F1C9 : 7A 00 10   dec  $0010          ;decr addr 0010 (TEMPA)
F1CC : 26 E2      bne  LF1B0          ;branch Z=0 WHIST1
F1CE : 7A 00 1C   dec  $001C          ;decr addr 001C (FREQZ)
F1D1 : 96 1C      ldaa  $1C           ;load A with addr 1C (FREQZ)
F1D3 : 81 20      cmpa  #$20          ;compare A with 20h
F1D5 : 26 D5      bne  LF1AC          ;branch Z=0 WHIST0
F1D7 : 39         rts                 ;return subroutine
;*************************************;
;*     SINE TABLE - FCB
;*************************************;
F1D8 : 80 8C 98 A5 B0 BC C6 D0        ;SINTBL
F1E0 : DA E2 EA F0 F5 FA FD FE        ;
F1E8 : FF FE FD FA F5 F0 EA E2        ;
F1F0 : DA D0 C6 BC B0 A5 98 8C        ;
F1F8 : 80 73 67 5A 4F 43 39 2F        ;
F200 : 25 1D 15 0F 0A 05 02 01        ;
F208 : 00 01 02 05 0A 0F 15 1D        ;
F210 : 25 2F 39 43 4F 5A 67 73        ;
;*************************************;
;* KNOCKER ROUTINE
;*************************************;
;KNOCK
F218 : 7F 04 02   clr  $0402          ;clear addr PIA (SOUND+2) FULL BLAST
F21B : CE F2 5F   ldx  #$F25F         ;load X with F25Fh (#KNKTAB)
F21E : DF 14      stx  $14            ;store X in addr 14 (SNDTMP)
;SQLP
F220 : DE 14      ldx  $14            ;load x with addr 14 (SNDTMP) RESTORE X REG
F222 : A6 00      ldaa  $00,x         ;load A with X+00h (GET PERIOD)
F224 : 27 33      beq  LF259          ;branch Z=1 END (END ON ZERO)
F226 : E6 01      ldab  $01,x         ;load B with X+01h (GET AMP)
F228 : C4 F0      andb  #$F0          ;and B with F0h 
F22A : D7 13      stab  $13           ;store B in addr 13 (AMP)
F22C : E6 01      ldab  $01,x         ;load B with X+01h
F22E : 08         inx                 ;incr X
F22F : 08         inx                 ;incr X
F230 : DF 14      stx  $14            ;store X in addr 14 (SNDTMP) SAVE X
F232 : 97 12      staa  $12           ;store A in addr 12 (PERIOD)
F234 : C4 0F      andb  #$0F          ;and B with 0Fh
;LP0
F236 : 96 13      ldaa  $13           ;load A with addr 13 (AMP)
F238 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F23B : 96 12      ldaa  $12           ;load A with addr 12 (PERIOD)
;LP1
F23D : CE 00 05   ldx  #$0005         ;load X with 0005h (#5) DELAY
;LP11
F240 : 09         dex                 ;decr X
F241 : 26 FD      bne  LF240          ;branch Z=0 LP11
F243 : 4A         deca                ;decr A
F244 : 26 F7      bne  LF23D          ;branch Z=0 LP1
F246 : 7F 04 00   clr  $0400          ;clear DAC output SOUND
F249 : 96 12      ldaa  $12           ;load A with addr 12 (PERIOD)
;LP2
F24B : CE 00 05   ldx  #$0005         ;load X with 0005h (#5) DELAY
;LP22
F24E : 09         dex                 ;decr X
F24F : 26 FD      bne  LF24E          ;branch Z=0 LP22
F251 : 4A         deca                ;decr A
F252 : 26 F7      bne  LF24B          ;branch Z=0 LP2
F254 : 5A         decb                ;decr B
F255 : 26 DF      bne  LF236          ;branch Z=0 LP0
F257 : 20 C7      bra  LF220          ;branch always SQLP
;END
F259 : 86 80      ldaa  #$80          ;load A with 80h (OVERRIDE OFF)
F25B : B7 04 02   staa  $0402         ;store A in PIA (SOUND+2)
F25E : 39         rts                 ;return subroutine
;*************************************;
;* KNOCKER PATTERN - FDB
;*************************************;
F25F : 01FC 02FC 03F8 04F8            ;KNKTAB
F267 : 06F8 08F4 0CF4 10F4            ;
F26F : 20F2 40F1 60F1 80F1            ;
F277 : A0F1 C0F1 0000                 ;
;*************************************;
;* FUNNY "ELECTRIC SOUND"
;*************************************;
;* SUPPOSED TO GENERATE A PHASED OUTPUT AT
;* A CHANGING FREQUENCY.  IT DOESN'T, AND
;* I'M NOT SURE EXACTLY WHAT IT DOES DO.
;* BEST LEAVE THIS ALONE.
;*
;BONUS
F27D : 7A 00 2E   dec  $002E          ;decr addr 002E (SNDX1)
F280 : 20 04      bra  LF286          ;branch always SND1$
;SND1
F282 : C6 A0      ldab  #$A0          ;load B with A0h
F284 : D7 2E      stab  $2E           ;store B in addr 2E (SNDX1)
;SND1$
F286 : 86 04      ldaa  #$04          ;load A with 04h
F288 : 97 13      staa  $13           ;store A in addr 13 (FREQ2)
;SND1$$
F28A : 86 9F      ldaa  #$9F          ;load A with 9Fh
F28C : D6 2E      ldab  $2E           ;load B with addr 2E (SNDX1)
;SND1A
F28E : CE 01 C0   ldx  #$01C0         ;load X with 01C0h
;SND1B
F291 : 09         dex                 ;decr X
F292 : 27 20      beq  LF2B4          ;branch Z=1 SND1E
F294 : F7 00 12   stab  $0012         ;store B in addr 0012 (FREQ1)
F297 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
;SND1C
F29A : 09         dex                 ;decr X
F29B : 27 17      beq  LF2B4          ;branch Z=1 SND1E
F29D : 7A 00 12   dec  $0012          ;decr addr 0012 (FREQ1)
F2A0 : 26 F8      bne  LF29A          ;branch Z=0 SND1C
F2A2 : 09         dex                 ;decr X
F2A3 : 27 0F      beq  LF2B4          ;branch Z=1 SND1E
F2A5 : D7 12      stab  $12           ;store B in addr 12 (FREQ1)
F2A7 : 73 04 00   com  $0400          ;complement 1s in DAC output SOUND
;SND1D
F2AA : 09         dex                 ;decr X
F2AB : 27 07      beq  LF2B4          ;branch Z=1 SND1E
F2AD : 7A 00 12   dec  $0012          ;decr addr 0012 (FREQ1)
F2B0 : 26 F8      bne  LF2AA          ;branch Z=0 SND1D
F2B2 : 20 DD      bra  LF291          ;branch always SND1B
;SND1E
F2B4 : D0 13      subb  $13           ;sub B with addr 13 (FREQ2)
F2B6 : C1 10      cmpb  #$10          ;compare B with 10h
F2B8 : 22 D4      bhi  LF28E          ;branch C+Z=0 SND1A
F2BA : 39         rts                 ;return subroutine
;START
F2BB : C6 11      ldab  #$11          ;load B with 11h
F2BD : D7 2E      stab  $2E           ;store B in addr 2E (SNDX1)
F2BF : 86 FE      ldaa  #$FE          ;load A with FEh
F2C1 : 97 13      staa  $13           ;store A in addr 13 (FREQ2)
F2C3 : 20 C5      bra  LF28A          ;branch always SND1$$
;*************************************;
;* SINGLE OSCILLATOR SOUND CALLS
;*************************************;
;PERK
F2C5 : CE F4 B2   ldx  #$F4B2         ;load X with F4B2h (#VEC01X)
F2C8 : 20 26      bra  LF2F0          ;branch always PERK$1
;PERK1
F2CA : BD F3 30   jsr  LF330          ;jump sub MOVE
F2CD : BD F3 49   jsr  LF349          ;jump sub SING
F2D0 : 39         rts                 ;return subroutine
;ATARI
F2D1 : CE F4 B8   ldx  #$F4B8         ;load X with F4B8h (#VEC02X)
F2D4 : 20 F4      bra  LF2CA          ;branch always PERK1
;SIREN
F2D6 : C6 FF      ldab  #$FF          ;load B with FFh
F2D8 : D7 09      stab  $09           ;store B in addr 09 (AMP0)
;SIREN1
F2DA : CE F4 BE   ldx  #$F4BE         ;load X with F4BEh (#VEC03X)
F2DD : 8D EB      bsr  LF2CA          ;branch sub PERK1
F2DF : CE F4 C4   ldx  #$F4C4         ;load X with F4C4h (#VEC04X)
F2E2 : 8D E6      bsr  LF2CA          ;branch sub PERK1
F2E4 : 5A         decb                ;decr B 
F2E5 : 26 F3      bne  LF2DA          ;branch Z=0 SIREN1
F2E7 : 39         rts                 ;return subroutine
;ORRRR
F2E8 : CE F4 CA   ldx  #$F4CA         ;load X with F4CAh (#VEC05X)
F2EB : 20 DD      bra  LF2CA          ;branch always PERK1
;PERK$
F2ED : CE F4 D6   ldx  #$F4D6         ;load X with F4D6h (#VEC07X)
;PERK$1
F2F0 : 8D D8      bsr  LF2CA          ;branch sub PERK1
F2F2 : 8D 30      bsr  LF324          ;branch sub ECHO
F2F4 : 20 FA      bra  LF2F0          ;branch always PERK$1
;HSTD
F2F6 : 86 FF      ldaa  #$FF          ;load A with FFh
F2F8 : 97 09      staa  $09           ;store A in addr 09 (AMP0)
F2FA : CE F4 DC   ldx  #$F4DC         ;load X with F4DCh (#VEC08X)
F2FD : 20 F1      bra  LF2F0          ;branch always PERK$1
;PERK$$
F2FF : 86 FF      ldaa  #$FF          ;load A with FFh
F301 : 97 09      staa  $09           ;store A in addr 09 (AMP0)
F303 : CE F4 D0   ldx  #$F4D0         ;load X with F4D0h (#VEC06X)
F306 : 20 E8      bra  LF2F0          ;branch always PERK$1
;*************************************;
;*  RANDOM SQUIRTS
;*************************************;
;SQRT
F308 : C6 30      ldab  #$30          ;load B with 30h
;SQRT1
F30A : CE F4 E2   ldx  #$F4E2         ;load X with F4E2h (#VEC09X)
F30D : 8D 21      bsr  LF330          ;branch sub MOVE
;SQRT2
F30F : 96 06      ldaa  $06           ;load A with addr 06 (RANDOM)
F311 : 48         asla                ;arith shift left A
F312 : 9B 06      adda  $06           ;add A with addr 06 (RANDOM)
F314 : 8B 0B      adda  #$0B          ;add A with 0Bh
F316 : 97 06      staa  $06           ;store A in addr 06 (RANDOM)
F318 : 44         lsra                ;logic shift right A
F319 : 44         lsra                ;logic shift right A
F31A : 8B 0C      adda  #$0C          ;add A with 0Ch
F31C : 97 13      staa  $13           ;store A in addr 13 (FREQ$)
F31E : 8D 29      bsr  LF349          ;branch sub SING
F320 : 5A         decb                ;decr B
F321 : 26 EC      bne  LF30F          ;branch Z=0 SQRT2
F323 : 39         rts                 ;return subroutine
;*************************************;
;*  ECHO FUNCTION
;*************************************;
;ECHO
F324 : 96 09      ldaa  $09           ;load A with addr 09 (AMP0)
F326 : 80 08      suba  #$08          ;sub A with 08h
F328 : 2A 03      bpl  LF32D          ;branch N=0 ECHO1
F32A : 97 09      staa  $09           ;store A in addr 09 (AMP0)
F32C : 39         rts                 ;return subroutine
;ECHO1
F32D : 32         pula                ;SP+1 pull stack into A
F32E : 32         pula                ;SP+1 pull stack into A
F32F : 39         rts                 ;return subroutine
;*************************************;
;*  MOVE PARAMETERS
;*************************************;
;MOVE
F330 : A6 00      ldaa  $00,x         ;load A with X+00h 
F332 : 97 13      staa  $13           ;store A in addr 13 (FREQ$)
F334 : A6 01      ldaa  $01,x         ;load A with X+01h
F336 : 97 14      staa  $14           ;store A in addr 14 (C$FRQ)
F338 : A6 02      ldaa  $02,x         ;load A with X+02h
F33A : 97 15      staa  $15           ;store A in addr 15 (D$FRQ)
F33C : A6 03      ldaa  $03,x         ;load A with X+03h
F33E : 97 16      staa  $16           ;store A in addr 16 (E$FRQ)
F340 : A6 04      ldaa  $04,x         ;load A with X+04h
F342 : 97 17      staa  $17           ;store A in addr 17 (C$AMP)
F344 : A6 05      ldaa  $05,x         ;load A with X+05h
F346 : 97 18      staa  $18           ;store A in addr 18 (D$AMP)
F348 : 39         rts                 ;return subroutine
;*************************************;
;*  DELTA F, DELTA A ROUTINE
;*************************************;
;SING
F349 : 96 09      ldaa  $09           ;load A with addr 09 (AMP0) GET STARTING AMPLITUDE
;SING$
F34B : 37         pshb                ;push B into stack then SP-1 (SAVE B)
F34C : D6 17      ldab  $17           ;load B with addr 17 (C$AMP) GET CYCLES AT AMPLITUDE
F34E : D7 19      stab  $19           ;store B in addr 19 (C$AMP$) SAVE AS COUNTER
F350 : D6 14      ldab  $14           ;load B with addr 14 (C$FRQ) GET CYCLES AT FREQUENCY
F352 : D7 1A      stab  $1A           ;store B in addr 1A (C$FRQ$) SAVE AS COUNTER
;SING1
F354 : 43         coma                ;complement 1s A (INVERT AMPLITUDE)
F355 : D6 13      ldab  $13           ;load B with addr 13 (FREQ$) GET FREQUENCY COUNTER
F357 : B7 04 00   staa  $0400         ;store A in DAC output SOUND (OUTPUT TO D/A)
;SING2
F35A : 5A         decb                ;decr B 
F35B : 26 FD      bne  LF35A          ;branch Z=0 SING2
F35D : 43         coma                ;complement 1s A (INVERT AMPLITUDE)
F35E : D6 13      ldab  $13           ;load B with addr 13 (FREQ$) GET FREQUENCY COUNTER
F360 : 20 00      bra  LF362          ;branch always (*+2) -I
F362 : 08         inx                 ;incr X (-I)
F363 : 09         dex                 ;decr X (-I---) SYNC, 20 CYCLES
F364 : 08         inx                 ;incr X (-I)
F365 : 09         dex                 ;decr X (-I)
F366 : B7 04 00   staa  $0400         ;store A in DAC output SOUND (OUTPUT TO D/A)
;SING3
F369 : 5A         decb                ;decr B
F36A : 26 FD      bne  LF369          ;branch Z=0 SING3
F36C : 7A 00 1A   dec  $001A          ;decr addr 001A (C$FRQ$) CHECK CYCLES AT FREQUENCY
F36F : 27 16      beq  LF387          ;branch Z=1 SING4 (GO CHANGE FREQUENCY)
F371 : 7A 00 19   dec  $0019          ;decr addr 0019 (C$AMP$) CHECK CYCLES AT AMPLITUDE
F374 : 26 DE      bne  LF354          ;branch Z=0 SING1 (ALL OK, GO OUTPUT)
F376 : 43         coma                ;complement 1s A (INVERT AMPLITUDE)
F377 : D6 17      ldab  $17           ;load B with addr 17 (C$AMP) GET CYCLES AT AMPLITUDE
F379 : B7 04 00   staa  $0400         ;store A in DAC output SOUND (OUTPUT TO D/A)
F37C : D7 19      stab  $19           ;store B in addr 19 (C$AMP$) SAVE AS COUNTER
F37E : D6 13      ldab  $13           ;load B with addr 13 (FREQ$)GET FREQUENCY COUNT
F380 : 9B 18      adda  $18           ;add A with addr 18 (D$AMP) ADD AMPLITUDE DELTA
F382 : 2B 1E      bmi  LF3A2          ;branch N=1 SING6 (RETURN FROM SUBROUTINE)
F384 : 01         nop                 ;(SYNC, 2 CYCLES)
F385 : 20 15      bra  LF39C          ;branch always SING5 
;SING4
F387 : 08         inx                 ;incr X (-I)
F388 : 09         dex                 ;decr X (-I---) SYNC, 10 CYCLES
F389 : 01         nop                 ;(-I)
F38A : 43         coma                ;complement 1s A (INVERT AMPLITUDE)
F38B : D6 14      ldab  $14           ;load B with addr 14 (C$FRQ) GET CYCLES AT FREQUENCY
F38D : B7 04 00   staa  $0400         ;store A in DAC output SOUND (OUTPUT TO D/A)
F390 : D7 1A      stab  $1A           ;store B in addr 1A (C$FRQ$) SAVE AS COUNTER
F392 : D6 13      ldab  $13           ;load B with addr 13 (FREQ$) GET FREQUENCY COUNT
F394 : D0 15      subb  $15           ;sub B with addr 15 (D$FRQ) SUBTRACT FREQUENCY DELTA
F396 : D1 16      cmpb  $16           ;compare B with addr 16 (E$FRQ) COMPARE TO END FREQUENCY
F398 : D1 16      cmpb  $16           ;compare B with addr 16 (E$FRQ) SYNC, 3 CYCLES
F39A : 27 06      beq  LF3A2          ;branch Z=1 SING6 (RETURN FROM SUBROUTINE)
;SING5
F39C : D7 13      stab  $13           ;store B in addr 13 (FREQ$) SAVE FREQUENCY COUNT
F39E : C0 05      subb  #$05          ;sub B with 05h (SYNC TO FREQUENCY COUNTDOWN)
F3A0 : 20 B8      bra  LF35A          ;branch always SING2 (JUMP INTO COUNTDOWN LOOP)
;SING6
F3A2 : 33         pulb                ;SP+1 pull stack into B (RESTORE B)
F3A3 : 39         rts                 ;return subroutine
;*************************************;
;* FCB tables for CHIME
;*************************************;
F3A4 : DA FF DA 80 26 01 26 80        ;SNDTBL
F3AC : 07 0A 07 00 F9 F6 F9 00        ;
;
F3B4 : 3A 3E 50 46 33 2C 27 20        ;NOTTBL
F3BC : 25 1C 1A 17 14 11 10 33        ;
;
F3C4 : 08 03 02 01 02 03 04 05        ;WAVFRM
F3CC : 06 0A 1E 32 70 00              ;
;*************************************;
;*FDB tables for PLAY
;*************************************;
;
F3D1 : FFFF FF90 FFFF FFFF            ;VEC01
F3DA : FFFF FF90 FFFF FFFF            ;
F3E2 : FFFF FFFF 0000 0000            ;
F3EA : 0000 0000                      ;
;
F3EE : 4801 0000 3F3F 0000            ;VEC02
F3F6 : 4801 0000 0108 0000            ;
F3FE : 8101 0000 01FF 0000            ;
F406 : 0108 0000                      ;
;
F40A : 0110 0000 3F3F 0000            ;VEC03
F412 : 0110 0000 0505 0000            ;
F41A : 0101 0000 31FF 0000            ;
F422 : 0505 0000                      ;
;
F426 : 3000 0000 7F00 0000            ;VEC04
F42E : 3000 0000 0100 0000            ;
F436 : 7F00 0000 0200 0000            ;
F43E : 0100 0000                      ;
;
F442 : 0400 0004 7F00 007F            ;VEC05
F44A : 0400 0004 FF00 00A0            ;
F452 : 0000 0000 0000 0000            ;
F45A : FF00 00A0                      ;
;
F45E : 0C68 6800 071F 0F00            ;VEC06
F466 : 0C80 8000 FFFF FF00            ;
F46E : 0000 0000 0000 0000            ;
F476 : FFFF FF00                      ;
;
F47A : 0104 0000 3F7F 0000            ;VEC016
F482 : 0104 0000 05FF 0000            ;
F48A : 0100 0000 4800 0000            ;
F492 : 05FF 0000                      ;
;
F496 : 0280 0030 0A7F 007F            ;VEC017
F49E : 0280 0030 C080 0020            ;
F4A6 : 0110 0015 C010 0000            ;
F4AE : C080 0000                      ;
;*************************************;
;* FDB tables for SING
;*************************************;
;
F4B2 : FF01 02C3 FF00                 ;VEC01X
;
F4B8 : 0103 FF80 FF00                 ;VEC02X
;
F4BE : 2003 FF50 FF00                 ;VEC03X
;
F4C4 : 5003 0120 FF00                 ;VEC04X
;
F4CA : FE04 0204 FF00                 ;VEC05X
;
F4D0 : 4803 010C FF00                 ;VEC06X
;
F4D6 : 4802 010C FF00                 ;VEC07X
;
F4DC : E001 0210 FF00                 ;VEC08X
;
F4E2 : 50FF 0000 6080                 ;VEC09X
;
F4E8 : FF02 0106 FF00                 ;VEC10X
;*************************************;
;*VARI LOADER
;*************************************;
;VARILD
F4EE : 16         tab                 ;transfer A to B
F4EF : 48         asla                ;arith shift left A (X2)
F4F0 : 48         asla                ;arith shift left A (X4)
F4F1 : 48         asla                ;arith shift left A (X8)
F4F2 : 1B         aba                 ;add B to A (X9)
F4F3 : CE 00 12   ldx  #$0012         ;load X with 0012h (#LOCRAM)
F4F6 : DF 0E      stx  $0E            ;store X in addr 0E (XPTR) SET XSFER
F4F8 : CE FC 08   ldx  #$FC08         ;load X with FC08h (#VVECT)
F4FB : BD FB 92   jsr  LFB92          ;jump sub ADDX 
F4FE : C6 09      ldab  #$09          ;load B with 09h (#9) GET COUNT
;VTRAN
F500 : 7E F9 65   jmp  LF965          ;jump TRANS
;*************************************;
;*VARIABLE DUTY CYCLE SQUARE WAVE ROUTINE
;*************************************;
;VARI
F503 : 96 1A      ldaa  $1A           ;load A with addr 1A (VAMP)
F505 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
;VAR0
F508 : 96 12      ldaa  $12           ;load A with addr 12 (LOPER)
F50A : 97 1B      staa  $1B           ;store A in addr 1B (LOCNT)
F50C : 96 13      ldaa  $13           ;load A with addr 13 (HIPER)
F50E : 97 1C      staa  $1C           ;store A with addr 1C (HICNT)
;V0
F510 : DE 17      ldx  $17            ;load X with addr 17 (SWPDT)
;V0LP
F512 : 96 1B      ldaa  $1B           ;load A with addr 1B (LOCNT) LO CYCLE
F514 : 73 04 00   com  $0400          ;complement 1s DAC output SOUND
;V1
F517 : 09         dex                 ;decr X
F518 : 27 10      beq  LF52A          ;branch Z=1 VSWEEP
F51A : 4A         deca                ;decr A
F51B : 26 FA      bne  LF517          ;branch Z=0 V1
F51D : 73 04 00   com  $0400          ;complement 1s in DAC output SOUND
F520 : 96 1C      ldaa  $1C           ;load A with addr 1C (HICNT) HI CYCLE
;V2
F522 : 09         dex                 ;decr X
F523 : 27 05      beq  LF52A          ;branch Z=1 VSWEEP
F525 : 4A         deca                ;decr A
F526 : 26 FA      bne  LF522          ;branch Z=0 V2
F528 : 20 E8      bra  LF512          ;branch always V0LP (LOOP BACK)
;VSWEEP
F52A : B6 04 00   ldaa  $0400         ;load A with addr DAC 
F52D : 2B 01      bmi  LF530          ;branch N=1 VS1
F52F : 43         coma                ;compement 1s A
;VS1
F530 : 8B 00      adda  #$00          ;add A with 00h
F532 : B7 04 00   staa  $0400         ;store A in DAC output SOUND (OUTPUT)
F535 : 96 1B      ldaa  $1B           ;load A with addr 1B (LOCNT)
F537 : 9B 14      adda  $14           ;add A with addr 14 (LODT)
F539 : 97 1B      staa  $1B           ;store A in addr 1B (LOCNT)
F53B : 96 1C      ldaa  $1C           ;load A with addr 1C (HICNT)
F53D : 9B 15      adda  $15           ;add A with addr 15 (HIDT)
F53F : 97 1C      staa  $1C           ;store A in addr 1C (HICNT)
F541 : 91 16      cmpa  $16           ;compare A with addr 16 (HIEN)
F543 : 26 CB      bne  LF510          ;branch Z=0 V0
F545 : 96 19      ldaa  $19           ;load A with addr 19 (LOMOD)
F547 : 27 06      beq  LF54F          ;branch Z=1 VARX
F549 : 9B 12      adda  $12           ;add A with addr 12 (LOPER)
F54B : 97 12      staa  $12           ;store A in addr 12 (LOPER)
F54D : 26 B9      bne  LF508          ;branch Z=0 VAR0
;VARX
F54F : 39         rts                 ;return subroutine
;*************************************;
;*LAUNCH
;*************************************;
;LAUNCH
F550 : 86 FF      ldaa  #$FF          ;load A with FFh
F552 : 97 19      staa  $19           ;store A in addr 19 (DFREQ)
F554 : 86 60      ldaa  #$60          ;load A with 60h
F556 : C6 FF      ldab  #$FF          ;load B with FFh
F558 : 20 12      bra  LF56C          ;branch always LITEN
;*************************************;
;*LIGHTNING
;*************************************;
;LITE
F55A : 86 01      ldaa  #$01          ;load A with 01h
F55C : 97 19      staa  $19           ;store A in addr 19 (DFREQ)
F55E : C6 03      ldab  #$03          ;load B with 03h
F560 : 20 0A      bra  LF56C          ;branch always LITEN
;*************************************;
;*APPEAR
;*************************************;
;APPEAR
F562 : 86 FE      ldaa  #$FE          ;load A with FEh
F564 : 97 19      staa  $19           ;store A in addr 19 (DFREQ)
F566 : 86 C0      ldaa  #$C0          ;load A with C0h
F568 : C6 10      ldab  #$10          ;load B with 10h
F56A : 20 00      bra  LF56C          ;branch always LITEN
;*************************************;
;*LIGHTNING+APPEAR NOISE ROUTINE
;*************************************;
;LITEN
F56C : 97 18      staa  $18           ;store A in addr 18 (LFREQ)
F56E : 86 FF      ldaa  #$FF          ;load A with FFh (HIGHEST AMP)
F570 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F573 : D7 14      stab  $14           ;store B in addr 14 (CYCNT)
;LITE0
F575 : D6 14      ldab  $14           ;load B with addr 14 (CYCNT)
;LITE1
F577 : 96 06      ldaa  $06           ;load A with addr 06 (LO) GET RANDOM
F579 : 44         lsra                ;logic shift right A
F57A : 44         lsra                ;logic shift right A
F57B : 44         lsra                ;logic shift right A
F57C : 98 06      eora  $06           ;exclusive or A with addr 06 (LO)
F57E : 44         lsra                ;logic shift right A
F57F : 76 00 05   ror  $0005          ;rotate right addr 0005 (HI)
F582 : 76 00 06   ror  $0006          ;rotate right addr 0006 (LO)
F585 : 24 03      bcc  LF58A          ;branch C=0 LITE2
F587 : 73 04 00   com  $0400          ;complement 1s in DAC output SOUND
;LITE2
F58A : 96 18      ldaa  $18           ;load A with addr 18 (LFREQ) COUNT FREQ
;LITE3
F58C : 4A         deca                ;decr A
F58D : 26 FD      bne  LF58C          ;branch Z=0 LITE3
F58F : 5A         decb                ;decr B (COUNT CYCLES)
F590 : 26 E5      bne  LF577          ;branch Z=0 LITE1
F592 : 96 18      ldaa  $18           ;load A with addr 18 (LFREQ)
F594 : 9B 19      adda  $19           ;add A with addr 19 (DFREQ)
F596 : 97 18      staa  $18           ;store A in addr 18 (LFREQ)
F598 : 26 DB      bne  LF575          ;branch Z=0 LITE0
F59A : 39         rts                 ;return subroutine
;*************************************;
;*TURBO
;*************************************;
;TURBO
F59B : 86 20      ldaa  #$20          ;load A with 20h
F59D : 97 14      staa  $14           ;store A in addr 14 (CYCNT)
F59F : 97 17      staa  $17           ;store A in addr 17 (NFFLG)
F5A1 : 86 01      ldaa  #$01          ;load A with 01h
F5A3 : CE 00 01   ldx  #$0001         ;load X with 0001h
F5A6 : C6 FF      ldab  #$FF          ;load B with FFh
F5A8 : 20 00      bra  LF5AA          ;branch always MOISE
;*************************************;
;*WHITE NOISE ROUTINE
;*************************************;
;*X=INIT PERIOD, ACCB=INIT AMP, ACCA DECAY RATE
;*CYCNT=CYCLE COUNT, NFFLG= FREQ DECAY FLAG
;*
; (label MOISE instead of NOISE - white noise routine)
;MOISE
F5AA : 97 12      staa  $12           ;store A in addr 12 (DECAY)
;MOISE0
F5AC : DF 15      stx  $15            ;store X in addr 15 (NFRQ1)
;MOIS00
F5AE : D7 13      stab  $13           ;store B in addr 13 (NAMP)
F5B0 : D6 14      ldab  $14           ;load B with addr 14 (CYCNT)
;MOISE1
F5B2 : 96 06      ldaa  $06           ;load A with addr 06 (LO) GET RANDOM BIT
F5B4 : 44         lsra                ;logic shift right A
F5B5 : 44         lsra                ;logic shift right A
F5B6 : 44         lsra                ;logic shift right A
F5B7 : 98 06      eora  $06           ;exclusive or A with addr 06 (LO)
F5B9 : 44         lsra                ;logic shift right A
F5BA : 76 00 05   ror  $0005          ;rotate right addr 0005 (HI)
F5BD : 76 00 06   ror  $0006          ;rotate right addr 0006 (LO)
F5C0 : 86 00      ldaa  #$00          ;load A with 00h
F5C2 : 24 02      bcc  LF5C6          ;branch C=0 MOISE2
F5C4 : 96 13      ldaa  $13           ;load A with addr 13 (NAMP)
;MOISE2
F5C6 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F5C9 : DE 15      ldx  $15            ;load X with addr 15 (NFRQ1) INCREASING DELAY
;MOISE3
F5CB : 09         dex                 ;decr X
F5CC : 26 FD      bne  LF5CB          ;branch Z=0 MOISE3
F5CE : 5A         decb                ;decr B (FINISH CYCLE COUNT?)
F5CF : 26 E1      bne  LF5B2          ;branch Z=0 MOISE1 (NO)
F5D1 : D6 13      ldab  $13           ;load B with addr 13 (NAMP) DECAY AMP
F5D3 : D0 12      subb  $12           ;sub B with addr 12 (DECAY)
F5D5 : 27 09      beq  LF5E0          ;branch Z=1 MSEND
F5D7 : DE 15      ldx  $15            ;load X with addr 15 (NFRQ1) INC FREQ
F5D9 : 08         inx                 ;incr X
F5DA : 96 17      ldaa  $17           ;load A with addr 17 (NFFLG) DECAY FREQ?
F5DC : 27 D0      beq  LF5AE          ;branch Z=1 MOIS00 (NO)
F5DE : 20 CC      bra  LF5AC          ;branch always MOISE0
;MSEND 
F5E0 : 39         rts                 ;return subroutine
;*************************************;
;*CROWD ROAR
;*************************************;
;CDR
F5E1 : CE F6 00   ldx  #$F600         ;load X with F600h (#WS1) 1ST WHISTLE PARAMS
F5E4 : DF 23      stx  $23            ;store X in addr 23 (PTRHI)
F5E6 : BD F7 2A   jsr  LF72A          ;jump sub WISLD
F5E9 : CE A5 00   ldx  #$A500         ;load X with A500h (SEED)
F5EC : DF 05      stx  $05            ;store X in addr 05 (HI)
F5EE : CE F6 29   ldx  #$F629         ;load X with F629h (#CR1) 1ST CROWD ROAR NOISE PARAMS
F5F1 : BD F6 33   jsr  LF633          ;jump sub NOISLD
F5F4 : BD F6 CE   jsr  LF6CE          ;jump sub NINIT
F5F7 : CE F6 2E   ldx  #$F62E         ;load X with F62Eh (#CR2)
F5FA : BD F6 33   jsr  LF633          ;jump sub NOISLD
F5FD : 7E F6 DB   jmp  LF6DB          ;jump NINIT2
;*************************************;
;*WHISTLE PARAMS - FCB
;*************************************;
F600 : 90 10 02 14 40                 ;WS1
F605 : B4 40 FF 14 30                 ;
F60A : D0 32 02 10 60                 ;
F60F : EE 20 02 08 54                 ;
F614 : E9 54 FF 20 28                 ;
F619 : C0 30 02 14 58                 ;
F61E : AC 20 02 08 58                 ;
F623 : A6 58 FF 18 22                 ;
F628 : 00                             ;
;
F629 : 30 10 FC 00 01                 ;CR1
;
F62E : 30 FC 01 00 01                 ;CR2
;*************************************;
;*WHITE NOISE ROUTINE - noise with whistle routine (full)
;*************************************;
;*NFRQ=INIT PERIOD, NAMP=INIT AMP, DECAY AMPLITUDE RATE
;*CYCNT=CYCLE COUNT, NFFLG= FREQ DECAY FLAG
;*NFFLG=0 NO FREQ CHANGE;=POS DECAY;=MINUS INC FREQ
;*NOISE LOAD PROG-ENTER WITH XREG POINTING TO DATA
;*
;NOISLD
F633 : A6 00      ldaa  $00,x         ;load A with X+00h
F635 : 97 2A      staa  $2A           ;store A in addr 2A
F637 : A6 01      ldaa  $01,x         ;load A with X+01h
F639 : 97 13      staa  $13           ;store A in addr 13
F63B : A6 02      ldaa  $02,x         ;load A with X+02h
F63D : 97 12      staa  $12           ;store A in addr 12
F63F : A6 03      ldaa  $03,x         ;load A with X+03h
F641 : 97 17      staa  $17           ;store A in addr 17
F643 : A6 04      ldaa  $04,x         ;load A with X+04h
F645 : 97 2F      staa  $2F           ;store A in addr 2F
;NEND
F647 : 39         rts                 ;return subroutine
;*************************************;
;*LOAD NOISE AND GO
;*************************************;
;NOISLG
F648 : 8D E9      bsr  LF633          ;branch sub NOISLD
;*************************************;
;*NOISE INIT
;*************************************;
;NOIN
F64A : 8D 30      bsr  LF67C          ;branch sub NSUB (CY2&NFRQ2 TO CYCNT&NFRQ)
;*************************************;
;*NOISE LOOP
;*************************************;
;NO1
F64C : 8D 58      bsr  LF6A6          ;branch sub RNT (FREQ CHECK)
F64E : 96 2E      ldaa  $2E           ;load A with addr 2E (NFRQ) FREQ REINITED?
F650 : 91 2F      cmpa  $2F           ;compare A with addr 2F (NFRQ2)
F652 : 26 F8      bne  LF64C          ;branch Z=0 NO1 (IF NOT KEEEP DELAYING)
F654 : 59         rolb                ;rotate left B (RESTORE MAX AMPLITUDE TO NOISE)
F655 : F7 04 00   stab  $0400         ;store B in DAC output SOUND (OUTPUT TO DAC)
F658 : 8D 2D      bsr  LF687          ;branch sub NOISE1 (PREPARE NEXT RAND NO)
F65A : 8D 38      bsr  LF694          ;branch sub NOISE2
F65C : 8D 5C      bsr  LF6BA          ;branch sub RNA (AMPLITUDE &CYCL3 COUNT CECK)
F65E : 7D 00 13   tst  $0013          ;test addr 0013 (NAMP) SEE IF DONE
F661 : 27 E4      beq  LF647          ;branch Z=1 NEND (RTS IF FINISHED)
F663 : 7D 00 14   tst  $0014          ;test addr 0014 (CYCNT) SEE IF NEXT FREQ
F666 : 26 E4      bne  LF64C          ;branch Z=0 NO1 (IF NOT GO FREQ DELAY LOOP)
F668 : 7D 00 17   tst  $0017          ;test addr 0017 (NFFLG) SEE IF SWEEP MODE
F66B : 27 DF      beq  LF64C          ;branch Z=1 NO1 (IF NO SWEEP GO DELAY)
F66D : 2B 05      bmi  LF674          ;branch N=1 NO3 (SWEEP DOWN)
F66F : 7C 00 2F   inc  $002F          ;incr addr 002F (NFRQ2)
F672 : 20 D8      bra  LF64C          ;branch always NO1
;NO3
F674 : 7A 00 2F   dec  $002F          ;decr addr 002F (NFRQ2)
F677 : 7A 00 2E   dec  $002E          ;decr addr 002E (NFRQ)
F67A : 20 D0      bra  LF64C          ;branch always NO1
;NSUB
F67C : 7F 00 14   clr  $0014          ;clear addr 0014 (CYCNT)
F67F : 96 2F      ldaa  $2F           ;load A with addr 2F (NFRQ2)
F681 : 97 2E      staa  $2E           ;store A in addr 2E (NFRQ) NOISE FREQ
F683 : 7F 00 2D   clr  $002D          ;clear addr 002D (NNOIS)
F686 : 39         rts                 ;return subroutine
;*************************************;
;* 23 CYCLES FOR EACH SUBROUTINE PLUS CALLING OVERHEAD
;*************************************;
;*
;NOISE1
F687 : 96 06      ldaa  $06           ;load A with addr 06 (LO) GET RANDOM BIT
F689 : 44         lsra                ;logic shift right A
F68A : 44         lsra                ;logic shift right A
F68B : 44         lsra                ;logic shift right A
F68C : 98 06      eora  $06           ;exclusive or A with addr 06 (LO)
F68E : 97 28      staa  $28           ;store A in addr 28 (ATP) INTERMED RAND NO
F690 : 08         inx                 ;incr X
F691 : 84 07      anda  #$07          ;and A with 07h (FOR 3 BIT RANDOM NO)
;*
F693 : 39         rts                 ;return subroutine
;*
;NOISE2
F694 : 96 28      ldaa  $28           ;load A with addr 28 (ATP)
F696 : 44         lsra                ;logic shift right A
F697 : 76 00 05   ror  $0005          ;rotate right addr 0005 (HI)
F69A : 76 00 06   ror  $0006          ;rotate right addr 0006 (LO)
F69D : 86 00      ldaa  #$00          ;load A with 00h
F69F : 24 02      bcc  LF6A3          ;branch C=0 NOISE3
F6A1 : 96 13      ldaa  $13           ;load A with addr 13 (NAMP)
;NOISE3
F6A3 : 97 2D      staa  $2D           ;store A in addr 2D (NNOIS) NEXT NOISE VALUE
;*
F6A5 : 39         rts                 ;return subroutine
;*
;RNT
F6A6 : 96 2F      ldaa  $2F           ;load A with addr 2F (NFRQ2) NOISE FREQ
F6A8 : 7A 00 2E   dec  $002E          ;decr addr 002E (NFRQ)
F6AB : 27 04      beq  LF6B1          ;branch Z=1 NW0
F6AD : 08         inx                 ;incr X
F6AE : 09         dex                 ;decr X (TEQ)
F6AF : 20 08      bra  LF6B9          ;branch always NW1
;NW0
F6B1 : 97 2E      staa  $2E           ;store A in addr 2E (NFRQ) REINIT FREQ
F6B3 : D6 2D      ldab  $2D           ;load B with addr 2D (NNOIS) SAVE NEXT NOISE VAL IN B REG
F6B5 : 54         lsrb                ;logic shift right B (HALF AMPLITUDE)
F6B6 : 7C 00 14   inc  $0014          ;incr addr 0014  (CYCNT) NOISE CYCLE COUNT AT NAMP
;*
;NW1
F6B9 : 39         rts                 ;return subroutine
;*
;RNA
F6BA : 96 2A      ldaa  $2A           ;load A with addr 2A (CY2) NOISE AMPL CHANGE
F6BC : 91 14      cmpa  $14           ;compare A with addr 14 (CYCNT)
F6BE : 27 04      beq  LF6C4          ;branch Z=1 NW2
F6C0 : 08         inx                 ;incr X
F6C1 : 09         dex                 ;decr X
F6C2 : 20 09      bra  LF6CD          ;branch always NW3 (TEQ)
;NW2
F6C4 : 7F 00 14   clr  $0014          ;clear addr 0014 (CYCNT)
F6C7 : 96 13      ldaa  $13           ;load A with addr 13 (NAMP)
F6C9 : 90 12      suba  $12           ;sub A with addr 12 (DECAY)
F6CB : 97 13      staa  $13           ;store A in addr 13 (NAMP)
;*
;NW3
F6CD : 39         rts                 ;return subroutine
;*
;*************************************;
;* NOISE WITH WHISTLE MAIN LOOP
;*************************************;
;NINIT
F6CE : 7F 00 21   clr  $0021          ;clear addr 0021 (WFRQ)
F6D1 : 7F 00 2B   clr  $002B          ;clear addr 002B (DFRQ)
F6D4 : 86 0E      ldaa  #$0E          ;load A with 0Eh (CYCLE OFFSET FOR WHISTLE)
F6D6 : 97 22      staa  $22           ;store A in addr 22 (WCNT)
F6D8 : 7F 00 27   clr  $0027          ;clear addr 0027 (CURVAL) CLR WHISTLE VALUES
;NINIT2
F6DB : 8D 9F      bsr  LF67C          ;branch sub NSUB (CLR CYCNT AND INIT FREQ)
;WIN
F6DD : 8D A8      bsr  LF687          ;branch sub NOISE1
F6DF : BD F7 64   jsr  LF764          ;jump sub TRIDR
F6E2 : 8D B0      bsr  LF694          ;branch sub NOISE2
F6E4 : BD F7 64   jsr  LF764          ;jump sub TRIDR
F6E7 : 8D BD      bsr  LF6A6          ;branch sub RNT
F6E9 : 8D 79      bsr  LF764          ;branch sub TRIDR
F6EB : 8D CD      bsr  LF6BA          ;branch sub RNA
F6ED : 8D 75      bsr  LF764          ;branch sub TRIDR
F6EF : 8D 0A      bsr  LF6FB          ;branch sub TRICNT
F6F1 : 8D 71      bsr  LF764          ;branch sub TRIDR
F6F3 : 8D 1D      bsr  LF712          ;branch sub TRIFRQ
F6F5 : 8D 6D      bsr  LF764          ;branch sub TRIDR
F6F7 : 8D 52      bsr  LF74B          ;branch sub NNW
F6F9 : 20 E2      bra  LF6DD          ;branch always WIN
;*
;TRICNT
F6FB : 96 26      ldaa  $26           ;load A with addr 26 (WCNT2) #CYCLES AT WHISTLE FREQ
F6FD : 7A 00 22   dec  $0022          ;decr addr 0022 (WCNT)
F700 : 27 07      beq  LF709          ;branch Z=1 NW4
F702 : B6 00 13   ldaa  $0013         ;load A with addr 0013 (NAMP)
F705 : 26 0A      bne  LF711          ;branch Z=0 NW5 (TEQ)
F707 : 20 68      bra  LF771          ;branch always NSEND (END NOISE)
;NW4
F709 : 97 22      staa  $22           ;store A in addr 22 (WCNT)
F70B : 96 21      ldaa  $21           ;load A with addr 21 (WFRQ)
F70D : 9B 2B      adda  $2B           ;add A with addr 2B (DFRQ)
F70F : 97 21      staa  $21           ;store A in addr 21 (WFRQ)
;*
;NW5
F711 : 39         rts                 ;return subroutine
;*
;TRIFRQ
F712 : 96 21      ldaa  $21           ;load A with addr 21 (WFRQ) WHISTLE END TEST
F714 : 91 29      cmpa  $29           ;compare A with addr 29 (MINWIS)
F716 : 27 07      beq  LF71F          ;branch Z=1 NW6
F718 : 08         inx                 ;incr X (TEQ)
F719 : 96 13      ldaa  $13           ;load A with addr 13 (NAMP) END TEST
F71B : 26 2A      bne  LF747          ;branch Z=0 NW7 (TEQ)
F71D : 20 29      bra  LF748          ;branch always PEND (END NOISE)
;NW6
F71F : 7F 00 21   clr  $0021          ;clear addr 0021 (WFRQ) TURN OFF WHISTLE
F722 : 7F 00 2B   clr  $002B          ;clear addr 002B (DFRQ)
F725 : 7F 00 27   clr  $0027          ;clear addr 0027 (CURVAL)
F728 : DE 23      ldx  $23            ;load X with addr 23 (PTRHI) SET UP FOR NEXT WHISTLE
;WISLD
F72A : A6 00      ldaa  $00,x         ;load A with X+00h
F72C : 97 20      staa  $20           ;store A in addr 20 (WHIS)
F72E : 27 17      beq  LF747          ;branch Z=1 NW7
F730 : A6 01      ldaa  $01,x         ;load A with X+01h
F732 : 97 25      staa  $25           ;store A in addr 25 (WFRQ2)
F734 : A6 02      ldaa  $02,x         ;load A with X+02h
F736 : 97 2C      staa  $2C           ;store A in addr 2C (DFRQ2)
F738 : A6 03      ldaa  $03,x         ;load A with X+03h
F73A : 97 26      staa  $26           ;store A in addr 26 (WCNT2)
F73C : A6 04      ldaa  $04,x         ;load A with X+04h
F73E : 97 29      staa  $29           ;store A in addr 29 (MINWIS)
F740 : 86 05      ldaa  #$05          ;load A with 05h
F742 : BD FB 92   jsr  LFB92          ;jump sub ADDX
F745 : DF 23      stx  $23            ;store X in addr 23 (PTRHI)
;*
;NW7
F747 : 39         rts                 ;return subroutine
;PEND
F748 : 32         pula                ;SP+1 pull stack into A
F749 : 32         pula                ;SP+1 pull stack into A (STACK ADJ)
F74A : 39         rts                 ;return subroutine
;*
;NNW
F74B : 96 20      ldaa  $20           ;load A with addr 20 (WHIS) WHISTLE INIT
F74D : 27 06      beq  LF755          ;branch Z=1 NW8 (ALREADY INITED)
F74F : 91 13      cmpa  $13           ;compare A with addr 13 (NAMP)
F751 : 26 04      bne  LF757          ;branch Z=0 NW9
F753 : 20 03      bra  LF758          ;branch always WINIT (GO INIT WHISTLE)
;NW8
F755 : 08         inx                 ;incr X
F756 : 09         dex                 ;decr X (TEQ)
;NW9
F757 : 39         rts                 ;return subroutine
;WINIT
F758 : 7F 00 20   clr  $0020          ;clear addr 0020 (WHIS0
F75B : 96 25      ldaa  $25           ;load A with addr 25 (WFRQ2)
F75D : 97 21      staa  $21           ;store A in addr 21 (WFRQ)
F75F : 96 2C      ldaa  $2C           ;load A with addr 2C (DFRQ2)
F761 : 97 2B      staa  $2B           ;store A in addr 2B (DFRQ)
F763 : 39         rts                 ;return subroutine
;******************
;TRIDR
F764 : 96 27      ldaa  $27           ;load A with addr 27 (CURVAL)
F766 : 9B 21      adda  $21           ;add A with addr 21 (WFRQ)
F768 : 97 27      staa  $27           ;store A in addr 27 (CURVAL)
F76A : 2A 01      bpl  LF76D          ;branch N=0 GO
F76C : 43         coma                ;complement 1s A
;GO
F76D : 1B         aba                 ;add B to A
F76E : B7 04 00   staa  $0400         ;store A in DAC output SOUND
;NSEND
F771 : 39         rts                 ;return subroutine
;*************************************;
;*BACKGROUND 1 ROUTINE
;*************************************;
;BG1
F772 : C6 01      ldab  #$01          ;load B with 01h
F774 : D7 00      stab  $00           ;store B in addr 00 (BG1FLG)
F776 : CE F7 85   ldx  #$F785         ;load X with F785h (#BG1TB)
F779 : 20 2A      bra  LF7A5          ;branch always FNLOAD
;*************************************;
;*THRUST
;*************************************;
;THRUST
F77B : CE F7 8B   ldx  #$F78B         ;load X with F78Bh (#THTB)
F77E : 20 25      bra  LF7A5          ;branch always FNLOAD
;*************************************;
;*CANNON
;*************************************;
;CANNON
F780 : CE F7 91   ldx  #$F791         ;load X with F791h (#CANTB)
F783 : 20 20      bra  LF7A5          ;branch always FNLOAD
;*************************************;
;FNTAB EQU  *  - FCB
;*************************************;
; : DSFLG,LOFRQ,DCYFLG,MAXFRQ,SMPCNT
F785 : 00 00 00 01 00 00              ;BG1TB
;
F78B : 00 00 00 03 00 00              ;THTB
;
F791 : 01 00 01 FF 03 E8              ;CANTB (DEFENDER SND #$17)
;
F797 : 01 01 01 40 10 00              ;HBMBTB
;
F79D : 01 80 01 40 FF                 ;RAIN
;*************************************;
;*HBOMB
;*************************************;
F7A2 : CE F7 97   ldx  #$F7A2         ;load X with F7A2h (#HBMBTB)
;*************************************;
;*LOADER
;*************************************;
;FNLOAD
F7A5 : A6 00      ldaa  $00,x         ;load A with X+00h
F7A7 : 97 19      staa  $19           ;store A in addr 19 (DSFLG) DISTORTION FLAG
F7A9 : A6 01      ldaa  $01,x         ;load A with X+01h
F7AB : 97 15      staa  $15           ;store A in addr 15 (LOFRQ)
F7AD : A6 02      ldaa  $02,x         ;load A with X+02h (FREQ DECAY FLAG)
F7AF : E6 03      ldab  $03,x         ;load B with X+03h (INIT MAX FREQ)
F7B1 : EE 04      ldx  $04,x          ;load X with X+04h (SAMPLE COUNT)
;*************************************;
;*FILTERED NOISE ROUTINE
;*************************************;
;*X=SAMPLE COUNT, ACCB=INITIAL MAX FREQ
;*ACCA=FREQ DECAY FLAG ,DSFLG=DISTORTION FLAG
;*
;FNOISE
F7B3 : 97 18      staa  $18           ;store A in addr 18 (FDFLG)
F7B5 : D7 12      stab  $12           ;store B in addr 12 (FMAX)
F7B7 : DF 16      stx  $16            ;store X in addr 16 (SAMPC)
F7B9 : 7F 00 14   clr  $0014          ;clear addr 0014 (FLO)
;FNOIS0
F7BC : DE 16      ldx  $16            ;load X with addr 16 (SAMPC)
F7BE : B6 04 00   ldaa  $0400         ;load A with DAC
;FNOIS1
F7C1 : 16         tab                 ;transfer A to B (NEXT RANDOM NUMBER)
F7C2 : 54         lsrb                ;logic shift right B
F7C3 : 54         lsrb                ;logic shift right B
F7C4 : 54         lsrb                ;logic shift right B
F7C5 : D8 06      eorb  $06           ;exclusive or B with addr 06 (LO)
F7C7 : 54         lsrb                ;logic shift right B
F7C8 : 76 00 05   ror  $0005          ;rotate right addr 0005 (HI)
F7CB : 76 00 06   ror  $0006          ;rotate right addr 0006 (LO)
F7CE : D6 12      ldab  $12           ;load B with addr 12 (FMAX) SET FREQ
F7D0 : 7D 00 19   tst  $0019          ;test addr 0019 (DSFLG)
F7D3 : 27 04      beq  LF7D9          ;branch Z=1 FNOIS2
F7D5 : D4 05      andb  $05           ;and B with addr 05 (HI) DISTORT FREQUENCY
F7D7 : DB 15      addb  $15           ;add B with addr 15 (LOFRQ) LO FREQ MIN
;FNOIS2
F7D9 : D7 13      stab  $13           ;store B in addr 13 (FHI)
F7DB : D6 14      ldab  $14           ;load B with addr 14 (FLO)
F7DD : 91 06      cmpa  $06           ;compare A with addr 06 (LO)
F7DF : 22 12      bhi  LF7F3          ;branch C+Z=0 FNOIS4
;FNOIS3
F7E1 : 09         dex                 ;decr X (SLOPE UP)
F7E2 : 27 26      beq  LF80A          ;branch Z=1 FNOIS6
F7E4 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F7E7 : DB 14      addb  $14           ;add B with addr 14 (FLO)
F7E9 : 99 13      adca  $13           ;add C+A + addr 13 (FHI)
F7EB : 25 16      bcs  LF803          ;branch C=1 FNOIS5
F7ED : 91 06      cmpa  $06           ;compare A with addr 06 (LO)
F7EF : 23 F0      bls  LF7E1          ;branch C+Z=1 FNOIS3
F7F1 : 20 10      bra  LF803          ;branch always FNOIS5
;FNOIS4
F7F3 : 09         dex                 ;decr X (SLOPE DOWN)
F7F4 : 27 14      beq  LF80A          ;branch Z=1 FNOIS6
F7F6 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F7F9 : D0 14      subb  $14           ;sub B with addr 14 (FLO)
F7FB : 92 13      sbca  $13           ;sub C+A + addr 13 (FHI)
F7FD : 25 04      bcs  LF803          ;branch C=1 FNOIS5
F7FF : 91 06      cmpa  $06           ;compare A with addr 06 (LO)
F801 : 22 F0      bhi  LF7F3          ;branch C+Z=0 FNOIS4
;FNOIS5
F803 : 96 06      ldaa  $06           ;load A with addr 06 (LO)
F805 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F808 : 20 B7      bra  LF7C1          ;branch always FNOIS1
;FNOIS6
F80A : D6 18      ldab  $18           ;load B with addr 18 (FDFLG)
F80C : 27 B3      beq  LF7C1          ;branch Z=1 FNOIS1
F80E : 96 12      ldaa  $12           ;load A with addr 12 (FMAX) DECAY MAX FREQ
F810 : D6 14      ldab  $14           ;load B with addr 14 (FLO)
F812 : 44         lsra                ;logic shift right A
F813 : 56         rorb                ;rotate right B
F814 : 44         lsra                ;logic shift right A
F815 : 56         rorb                ;rotate right B
F816 : 44         lsra                ;logic shift right A
F817 : 56         rorb                ;rotate right B
F818 : 43         coma                ;complement 1s A
F819 : 50         negb                ;negate B
F81A : 82 FF      sbca  #$FF          ;sub C+A + FFh (#-1)
F81C : DB 14      addb  $14           ;add B with addr 14 (FLO)
F81E : 99 12      adca  $12           ;add C+A + addr 12 (FMAX)
F820 : D7 14      stab  $14           ;store B in addr 14 (FLO)
F822 : 97 12      staa  $12           ;store A in addr 12 (FMAX)
F824 : 26 96      bne  LF7BC          ;branch Z=0 FNOIS0
F826 : C1 07      cmpb  #$07          ;compare B with 07h
F828 : 26 92      bne  LF7BC          ;branch Z=0 FNOIS0
F82A : 39         rts                 ;return subroutine
;*************************************;
;*RADIO
;*************************************;
;RADIO
F82B : 86 FC      ldaa  #$FC          ;load A with FCh (#RADSND/$100) SOUND TABLE
F82D : 97 0E      staa  $0E           ;store A in addr 0E (XPTR)
F82F : CE 00 64   ldx  #$0064         ;load X with 0064 (#100) STARTING FREQ
F832 : DF 0A      stx  $0A            ;store X in addr 0A (TEMPX)
;RADIO1
F834 : DB 0B      addb  $0B           ;add B with addr 0B (TEMPX+1) ADD FREQ TO TIMER
F836 : 96 10      ldaa  $10           ;load A with addr 10 (TEMPA)
F838 : 99 0A      adca  $0A           ;add C+A + addr 0A (TEMPX)
F83A : 97 10      staa  $10           ;store A in addr 10 (TEMPA)
F83C : DE 0A      ldx  $0A            ;load X with addr 0A (TEMPX)
F83E : 25 04      bcs  LF844          ;branch C=1 RADIO2
F840 : 20 00      bra  LF842          ;branch always (*+2) EQUALIZE TIME
F842 : 20 03      bra  LF847          ;branch always RADIO3
;RADIO2
F844 : 08         inx                 ;incr X (CARRY?, RAISE FREQ)
F845 : 27 11      beq  LF858          ;branch Z=1 RADIO4 (DONE?)
;RADIO3
F847 : DF 0A      stx  $0A            ;store X in addr 0A (TEMPX)
F849 : 84 0F      anda  #$0F          ;and A with 0Fh (SET POINTER)
F84B : 8B 47      adda  #$47          ;add A with 47h (#RADSND!.$FF)
F84D : 97 0F      staa  $0F           ;store A in addr 0F (XPTR+1)
F84F : DE 0E      ldx  $0E            ;load X with addr 0E (XPTR)
F851 : A6 00      ldaa  $00,x         ;load A with X+00h
F853 : B7 04 00   staa  $0400         ;store A in DAC output SOUND (PLAY SOUND)
F856 : 20 DC      bra  LF834          ;branch always RADIO1
;RADIO4
F858 : 39         rts                 ;return subroutine
;*************************************;
;*HYPER
;*************************************;
;HYPER
F859 : 4F         clra                ;clear A
F85A : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F85D : 97 10      staa  $10           ;store A in addr 10 (TEMPA) ZERO PHASE
;HYPER1
F85F : 4F         clra                ;clear A (ZERO TIME COUNTER)
;HYPER2
F860 : 91 10      cmpa  $10           ;compare A with addr 10 (TEMPA)
F862 : 26 03      bne  LF867          ;branch Z=0 HYPER3
F864 : 73 04 00   com  $0400          ;complement 1s DAC output SOUND (PHASE EDGE?, COMPLEMENT SOUND)
;HYPER3
F867 : C6 12      ldab  #$12          ;load B with 12h (#18) DELAY
;HYPER4
F869 : 5A         decb                ;decr B
F86A : 26 FD      bne  LF869          ;branch Z=0 HYPER4
F86C : 4C         inca                ;incr A (ADVANCE TIME COUNTER)
F86D : 2A F1      bpl  LF860          ;branch N=0 HYPER2
F86F : 73 04 00   com  $0400          ;complement 1s DAC output SOUND (CYCLE DONE?, CYCLE EDGE)
F872 : 7C 00 10   inc  $0010          ;incr addr 0010 (TEMPA) NEXT PHASE
F875 : 2A E8      bpl  LF85F          ;branch N=0 HYPER1 (DONE?)
F877 : 39         rts                 ;return subroutine
;*************************************;
;*SCREAM
;*************************************;
;SCREAM
F878 : CE 00 12   ldx  #$0012         ;load X with 0012h (#STABLE) ZERO FREQS AND TIMES
;SCREM1
F87B : 6F 00      clr  $00,x          ;clear addr X+00h
F87D : 08         inx                 ;incr X
F87E : 8C 00 1A   cpx  #$001A         ;compare X with 001Ah (#SRMEND)
F881 : 26 F8      bne  LF87B          ;branch Z=0 SCREM1
F883 : 86 40      ldaa  #$40          ;load A with 40h (START FIRST ECHO)
F885 : 97 12      staa  $12           ;store A in addr 12 (STABLE+FREQ)
;SCREM2
F887 : CE 00 12   ldx  #$0012         ;load X with 0012h (#STABLE) INITIALIZE COUNTER
F88A : 86 80      ldaa  #$80          ;load A with 80h (INITIALIZE AMPLITUDE)
F88C : 97 10      staa  $10           ;store A in addr 10 (TEMPA)
F88E : 5F         clrb                ;clear B (ZERO OUTPUT BUFFER)
;SCREM3
F88F : A6 01      ldaa  $01,x         ;load A with X+01h (TIMER,X) ADD FREQ TO TIMER
F891 : AB 00      adda  $00,x         ;add A with X+00h (FREQ,X)
F893 : A7 01      staa  $01,x         ;store A in addr X+01h (TIMER,X)
F895 : 2A 02      bpl  LF899          ;branch N=0 SCREM4 (ADD AMPLITUDE IF MINUS)
F897 : DB 10      addb  $10           ;add B with addr 10 (TEMPA)
;SCREM4
F899 : 74 00 10   lsr  $0010          ;logic shift right addr 0010 (TEMPA) DECAY AMPLITUDE
F89C : 08         inx                 ;incr X (NEXT ECHO)
F89D : 08         inx                 ;incr X
F89E : 8C 00 1A   cpx  #$001A         ;compare X with 001Ah (#SRMEND) LAST ECHO?
F8A1 : 26 EC      bne  LF88F          ;branch Z=0 SCREM3
F8A3 : F7 04 00   stab  $0400         ;store B in DAC output SOUND (OUTPUT SOUND)
F8A6 : 7C 00 11   inc  $0011          ;incr addr 0011 (TEMPB) ADVANCE TIMER
F8A9 : 26 DC      bne  LF887          ;branch Z=0 SCREM2
F8AB : CE 00 12   ldx  #$0012         ;load X with 0012h (#STABLE) LOWER NON-ZERO FREQUENCIES
F8AE : 5F         clrb                ;clear B (ALL ZERO NOT FLAG)
;SCREM5
F8AF : A6 00      ldaa  $00,x         ;load A with X+00h (FREQ,X)
F8B1 : 27 0B      beq  LF8BE          ;branch Z=1 SCREM7
F8B3 : 81 37      cmpa  #$37          ;compare A with 37h
F8B5 : 26 04      bne  LF8BB          ;branch Z=0 SCREM6
F8B7 : C6 41      ldab  #$41          ;load B with 41h (START NEXT ECHO)
F8B9 : E7 02      stab  $02,x         ;store B with X+02h (FREQ+2,X)
;SCREM6
F8BB : 6A 00      dec  $00,x          ;decr addr X+00h (FREQ,X)
F8BD : 5C         incb                ;incr B (SET FLAG)
;SCREM7
F8BE : 08         inx                 ;incr X
F8BF : 08         inx                 ;incr X
F8C0 : 8C 00 1A   cpx  #$001A         ;compare X with 001Ah (#SRMEND)
F8C3 : 26 EA      bne  LF8AF          ;branch Z=0 SCREM5
F8C5 : 5D         tstb                ;test B (DONE?)
F8C6 : 26 BF      bne  LF887          ;branch Z=0 SCREM2
F8C8 : 39         rts                 ;return subroutine
;*************************************;
;*ORGAN TUNE
;*************************************;
;ORGANT
F8C9 : 7A 00 04   dec  $0004          ;decr addr 0004 (ORGFLG) MINUS ORGAN FLAG
F8CC : 39         rts                 ;return subroutine
;ORGNT1
F8CD : 8D 03      bsr  LF8D2          ;branch sub ORGASM
F8CF : 7E FB 7F   jmp  LFB7F          ;jump IRQ3
;ORGASM
F8D2 : 7F 00 04   clr  $0004          ;clear addr 0004 (ORGFLG)
F8D5 : 97 10      staa  $10           ;store A in addr 10 (TEMPA) TUNE NUMBER
F8D7 : CE FC 57   ldx  #$FC57         ;load X with FC57h (#ORGTAB)
;ORGNT2
F8DA : A6 00      ldaa  $00,x         ;load A with X+00h (TUNE TABLE LENGTH)
F8DC : 27 2D      beq  LF90B          ;branch Z=1 ORGNT5 (INVALID TUNE)
F8DE : 7A 00 10   dec  $0010          ;decr addr 0010 (TEMPA)
F8E1 : 27 06      beq  LF8E9          ;branch Z=1 ORGNT3
F8E3 : 4C         inca                ;incr A
F8E4 : BD FB 92   jsr  LFB92          ;jump sub ADDX
F8E7 : 20 F1      bra  LF8DA          ;branch always ORGNT2
;ORGNT3
F8E9 : 08         inx                 ;incr X
F8EA : DF 0E      stx  $0E            ;store X in addr 0E (XPTR) NOTE POINTER
F8EC : BD FB 92   jsr  LFB92          ;jump sub ADDX
F8EF : DF 0C      stx  $0C            ;store X in addr 0C (XPLAY) TUNE END
F8F1 : DE 0E      ldx  $0E            ;load X with addr 0E (XPTR)
;ORGNT4
F8F3 : A6 00      ldaa  $00,x         ;load A with X+00h (TUNE LOOP)
F8F5 : 97 14      staa  $14           ;store A in addr 14 (OSCIL)
F8F7 : A6 01      ldaa  $01,x         ;load A with X+01h 
F8F9 : EE 02      ldx  $02,x          ;load X with X+02h
F8FB : DF 12      stx  $12            ;store X in addr 12 (DUR)
F8FD : 8D 0E      bsr  LF90D          ;branch sub ORGANL
F8FF : DE 0E      ldx  $0E            ;load X with addr 0E (XPTR)
F901 : 08         inx                 ;incr X
F902 : 08         inx                 ;incr X
F903 : 08         inx                 ;incr X
F904 : 08         inx                 ;incr X
F905 : DF 0E      stx  $0E            ;store X in addr 0E (XPTR)
F907 : 9C 0C      cpx  $0C            ;compare X with addr 0C (XPLAY)
F909 : 26 E8      bne  LF8F3          ;branch Z=0 ORGNT4
;ORGNT5
F90B : 39         rts                 ;return subroutine
;*************************************;
;*ORGAN NOTE
;*************************************;
;*4 BYTES(MODE,OSCILLATOR MASK HI+1,LO+1,NOTE#)
;ORGANN
F90C : 39         rts                 ;return subroutine
;*************************************;
;*ORGAN LOADER
;*************************************;
;*OSCIL=OSCILLATOR MASK, ACCA=DELAY, DUR=DURATION
;*
;ORGANL
F90D : CE 00 15   ldx  #$0015         ;load X with 0015h (#RDELAY)
F910 : 80 02      suba  #$02          ;sub A with 02h
;LDLP
F912 : 23 15      bls  LF929          ;branch C+Z=1 LD1
F914 : 81 03      cmpa  #$03          ;compare A with 03h
F916 : 27 09      beq  LF921          ;branch Z=1 LD2
F918 : C6 01      ldab  #$01          ;load B with 01h (NOP)
F91A : E7 00      stab  $00,x         ;store B in addr X+00h
F91C : 08         inx                 ;incr X
F91D : 80 02      suba  #$02          ;sub A with 02h
F91F : 20 F1      bra  LF912          ;branch always LDLP
;LD2
F921 : C6 91      ldab  #$91          ;load B with 91h (CMPA 0)
F923 : E7 00      stab  $00,x         ;store B in addr X+00h
F925 : 6F 01      clr  $01,x          ;clear addr X+01h
F927 : 08         inx                 ;incr X
F928 : 08         inx                 ;incr X
;LD1
F929 : C6 7E      ldab  #$7E          ;load B with 7Eh (JMP START2)
F92B : E7 00      stab  $00,x         ;store B in addr X+00h
F92D : C6 F9      ldab  #$F9          ;load B with F9h (#ORGAN1!>8 MSB)
F92F : E7 01      stab  $01,x         ;store B in addr X+01h
F931 : C6 37      ldab  #$37          ;load B with 37h (#ORGAN1!.$FF LSB)
F933 : E7 02      stab  $02,x         ;store B in addr X+02h
;*************************************;
;*ORGAN ROUTINE
;*************************************;
;*DUR=DURATION, OSCILLATOR MASK
;*
;ORGAN
F935 : DE 12      ldx  $12            ;load X with addr 12 (DUR)
F937 : 4F         clra                ;clear A
F938 : F6 00 11   ldab  $0011         ;load B with addr 0011 (LOAD B EXTND TEMPB)
F93B : 5C         incb                ;incr B
F93C : D7 11      stab  $11           ;store B in addr 11 (TEMPB)
F93E : D4 14      andb  $14           ;and B with addr 14 (OSCIL) MASK OSCILLATORS
F940 : 54         lsrb                ;logic shift right B
F941 : 89 00      adca  #$00          ;add C+A + 00h
F943 : 54         lsrb                ;logic shift right B
F944 : 89 00      adca  #$00          ;add C+A + 00h
F946 : 54         lsrb                ;logic shift right B
F947 : 89 00      adca  #$00          ;add C+A + 00h
F949 : 54         lsrb                ;logic shift right B
F94A : 89 00      adca  #$00          ;add C+A + 00h
F94C : 54         lsrb                ;logic shift right B
F94D : 89 00      adca  #$00          ;add C+A + 00h
F94F : 54         lsrb                ;logic shift right B
F950 : 89 00      adca  #$00          ;add C+A + 00h
F952 : 54         lsrb                ;logic shift right B
F953 : 89 00      adca  #$00          ;add C+A + 00h
F955 : 1B         aba                 ;add B to A
F956 : 48         asla                ;arith shift left A
F957 : 48         asla                ;arith shift left A
F958 : 48         asla                ;arith shift left A
F959 : 48         asla                ;arith shift left A
F95A : 48         asla                ;arith shift left A
F95B : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F95E : 09         dex                 ;decr X
F95F : 27 03      beq  LF964          ;branch Z=1 ORGAN2 (NOTE OVER?)
F961 : 7E 00 15   jmp  L0015          ;jump addr 0015 (RDELAY)
;ORGAN2
F964 : 39         rts                 ;return subroutine
;*************************************;
;*PARAMETER TRANSFER
;*************************************;
;TRANS
F965 : 36         psha                ;push A into stack then SP-1
;TRANS1
F966 : A6 00      ldaa  $00,x         ;load A with X+00h
F968 : DF 0C      stx  $0C            ;store X in addr 0C (XPLAY)
F96A : DE 0E      ldx  $0E            ;load X with addr 0E (XPTR)
F96C : A7 00      staa  $00,x         ;store A in addr X+00h
F96E : 08         inx                 ;incr X
F96F : DF 0E      stx  $0E            ;store X in addr 0E (XPTR)
F971 : DE 0C      ldx  $0C            ;load X wiuth 0C (XPLAY)
F973 : 08         inx                 ;incr X
F974 : 5A         decb                ;decr B
F975 : 26 EF      bne  LF966          ;branch Z=0 TRANS1
F977 : 32         pula                ;SP+1 pull stack into A
F978 : 39         rts                 ;return subroutine
;*************************************;
;*BACKGROUND END ROUTINE
;*************************************;
;BGEND
F979 : 4F         clra                ;clear A
F97A : 97 00      staa  $00           ;store A in addr 00 (BG1FLG)
F97C : 97 01      staa  $01           ;store A in addr 01 (BG2FLG)
F97E : 39         rts                 ;return subroutine
;*************************************;
;*BACKGROUND SOUND #2 INCREMENT
;*************************************;
;BG2INC
F97F : 7F 00 00   clr  $0000          ;clear addr 0000 (BG1FLG) KILL BG1
F982 : 96 01      ldaa  $01           ;load A with addr 01 (BG2FLG) ACTIVATE BG2
F984 : 84 7F      anda  #$7F          ;and A with 7Fh (REMOVE OVERRIDE)
F986 : 81 1D      cmpa  #$1D          ;compare A with 1Dh (#BG2MAX)
F988 : 26 01      bne  LF98B          ;branch Z=0 BG2IO
F98A : 4F         clra                ;clear A
;BG2IO
F98B : 4C         inca                ;incr A
F98C : 97 01      staa  $01           ;store A in addr 01 (BG2FLG)
F98E : 39         rts                 ;return subroutine
;*************************************;
;*BACKGROUND 2 ROUTINE
;*************************************;
;BG2
F98F : 86 0E      ldaa  #$0E          ;load A with 0Eh (#(TRBV-SVTAB)/7 GET SOUND#)
F991 : BD F9 DC   jsr  LF9DC          ;jump sub GWLD
F994 : 96 01      ldaa  $01           ;load A with addr 01 (BG2FLG)
F996 : 48         asla                ;arith shift left A
F997 : 48         asla                ;arith shift left A
F998 : 43         coma                ;complement 1s A
F999 : BD FA 94   jsr  LFA94          ;jump sub GEND60
;BG2LP
F99C : 7C 00 16   inc  $0016          ;incr addr 0016 (GDCNT)
F99F : BD FA 96   jsr  LFA96          ;jump sub GEND61
F9A2 : 20 F8      bra  LF99C          ;branch always BG2LP
;*
;*
;*
;*************************************;
;*SPINNER #1 SOUND
;*************************************;
;SP1
F9A4 : 86 03      ldaa  #$03          ;load A with 03h (#(CABSHK-VVECT)/9)
F9A6 : BD F4 EE   jsr  LF4EE          ;jump sub VARILD
F9A9 : D6 02      ldab  $02           ;load B with addr 02 (SP1FLG)
F9AB : C1 1F      cmpb  #$1F          ;compare B with 1Fh (#SP1MAX-1)
F9AD : 26 01      bne  LF9B0          ;branch Z=0 SP1A
F9AF : 5F         clrb                ;clear B
;SP1A
F9B0 : 5C         incb                ;incr B
F9B1 : D7 02      stab  $02           ;store B in addr 02 (SP1FLG)
F9B3 : 86 20      ldaa  #$20          ;load A with 20h (#SP1MAX)
F9B5 : 10         sba                 ;sub B from A
F9B6 : 5F         clrb                ;clear B
;SP11
F9B7 : 81 14      cmpa  #$14          ;compare B with 14h (#20)
F9B9 : 23 05      bls  LF9C0          ;branch C+Z=1 SP12
F9BB : CB 0E      addb  #$0E          ;add B with 0Eh (#14)
F9BD : 4A         deca                ;decr A
F9BE : 20 F7      bra  LF9B7          ;branch always SP11
;SP12
F9C0 : CB 05      addb  #$05          ;add B with 05h
F9C2 : 4A         deca                ;decr A
F9C3 : 26 FB      bne  LF9C0          ;branchZ=0 SP12
F9C5 : D7 12      stab  $12           ;store B in addr 12 (LOPER)
;SP1LP
F9C7 : BD F5 03   jsr  LF503          ;jump sub VARI (DO IT)
F9CA : 20 FB      bra  LF9C7          ;branch always SP1LP
;*************************************;
;*LASER BALL BONUS #2
;*************************************;
;BON2
F9CC : 96 03      ldaa  $03           ;load A with addr 03 (B2FLG)
F9CE : 26 09      bne  LF9D9          ;branch Z=0 BON21
F9D0 : 7C 00 03   inc  $0003          ;incr addr 0003 (B2FLG)
F9D3 : 86 0D      ldaa  #$0D          ;load A with 0Dh (#(BONV-SVTAB)/7)
F9D5 : 8D 05      bsr  LF9DC          ;branch sub GWLD
F9D7 : 20 69      bra  LFA42          ;branch always GWAVE
;BON21
F9D9 : 7E FA 89   jmp  LFA89          ;jump GEND50
;*************************************;
;*GWAVE LOADER
;*************************************;
;GWLD
F9DC : 16         tab                 ;transfer A to B (MULKT BY 7)
F9DD : 58         aslb                ;arith shift left B
F9DE : 1B         aba                 ;add B to A
F9DF : 1B         aba                 ;add B to A
F9E0 : 1B         aba                 ;add B to A
F9E1 : CE FE 45   ldx  #$FE45         ;load X with FE45h (#SVTAB) SOUND VECTOR TABLE
F9E4 : BD FB 92   jsr  LFB92          ;jump sub ADDX
F9E7 : A6 00      ldaa  $00,x         ;load A with X+00h
F9E9 : 16         tab                 ;transfer A to B
F9EA : 84 0F      anda  #$0F          ;and A with 0Fh
F9EC : 97 13      staa  $13           ;store A in addr 13 (GCCNT) GET CYCLE COUNT
F9EE : 54         lsrb                ;logic shift right B
F9EF : 54         lsrb                ;logic shift right B
F9F0 : 54         lsrb                ;logic shift right B
F9F1 : 54         lsrb                ;logic shift right B
F9F2 : D7 12      stab  $12           ;store B in addr 12 (GECHO) GET #ECHOS
F9F4 : A6 01      ldaa  $01,x         ;load A with X+01h
F9F6 : 16         tab                 ;transfer A to B
F9F7 : 54         lsrb                ;logic shift right B
F9F8 : 54         lsrb                ;logic shift right B
F9F9 : 54         lsrb                ;logic shift right B
F9FA : 54         lsrb                ;logic shift right B
F9FB : D7 14      stab  $14           ;store B in addr 14 (GECDEC)
F9FD : 84 0F      anda  #$0F          ;and A with 0Fh (WAVE #)
F9FF : 97 10      staa  $10           ;store A in addr 10 (TEMPA) SAVE
FA01 : DF 0A      stx  $0A            ;store X in addr 0A (TEMPX) SAVE INDEX
FA03 : CE FD 32   ldx  #$FD32         ;load X with FD32h (#GWVTAB) CALC WAVEFORM ADDR
;GWLD2
FA06 : 7A 00 10   dec  $0010          ;decr addr 0010 (TEMPA) WAVE FORM #
FA09 : 2B 08      bmi  LFA13          ;branch N=1 GWLD3 (FINIS)
FA0B : A6 00      ldaa  $00,x         ;load A with X+00h
FA0D : 4C         inca                ;incr A
FA0E : BD FB 92   jsr  LFB92          ;jump sub ADDX
FA11 : 20 F3      bra  LFA06          ;branch always GWLD2
;GWLD3
FA13 : DF 17      stx  $17            ;store X in addr 17 (GWFRM)
FA15 : BD FA D0   jsr  LFAD0          ;jump sub WVTRAN (XSFER WAVE TO RAM)
FA18 : DE 0A      ldx  $0A            ;load x with 0Ah (TEMPX) RESTORE INDEX
FA1A : A6 02      ldaa  $02,x         ;load A with X+02h (GET PREDECAY)
FA1C : 97 19      staa  $19           ;store A in addr 19 (PRDECA)
FA1E : BD FA E2   jsr  LFAE2          ;jump sub WVDECA (DECAY IT)
FA21 : DE 0A      ldx  $0A            ;load X with addr 0A (TEMPX)
FA23 : A6 03      ldaa  $03,x         ;load A with X+03h (GET FREQ INC)
FA25 : 97 15      staa  $15           ;store A in addr 15 (GDFINC)
FA27 : A6 04      ldaa  $04,x         ;load A with X+04h (GET DELTA FREQ COUNT)
FA29 : 97 16      staa  $16           ;store A in addr 16 (GDCNT)
FA2B : A6 05      ldaa  $05,x         ;load A with X+05h (GET PATTERN COUNT)
FA2D : 16         tab                 ;transfer A to B (SAVE)
FA2E : A6 06      ldaa  $06,x         ;load A with X+06h (PATTERN OFFSET)
FA30 : CE FF 02   ldx  #$FF02         ;load X with FF02h (#GFRTAB)
FA33 : BD FB 92   jsr  LFB92          ;jump sub ADDX
FA36 : 17         tba                 ;transfer B to A (GET PATTERN LENGTH)
FA37 : DF 1A      stx  $1A            ;store X in addr 1A (GWFRQ) FREQ TABLE ADDR
FA39 : 7F 00 22   clr  $0022          ;clear addr 0022 (FOFSET)
FA3C : BD FB 92   jsr  LFB92          ;jump sub ADDX
FA3F : DF 1C      stx  $1C            ;store X in addr 1C (FRQEND)
FA41 : 39         rts                 ;return subroutine
;*************************************;
;*GWAVE ROUTINE
;*************************************;
;*ACCA= FREQ PATTERN LENGTH, X= FREQ PAT ADDR
;*
;GWAVE
FA42 : 96 12      ldaa  $12           ;load A with addr 12 (GECHO)
FA44 : 97 21      staa  $21           ;store A in addr 21 (GECNT)
;GWT4
FA46 : DE 1A      ldx  $1A            ;load X with addr 1A (GWFRQ)
FA48 : DF 0C      stx  $0C            ;store X in addr 0C (XPLAY)
;GPLAY
FA4A : DE 0C      ldx  $0C            ;load X in addr 0C (XPLAY) GET NEW PERIOD
FA4C : A6 00      ldaa  $00,x         ;load A with X+00h
FA4E : 9B 22      adda  $22           ;add A with addr 22 (FOFSET)
FA50 : 97 20      staa  $20           ;store A in addr 20 (GPER)
FA52 : 9C 1C      cpx  $1C            ;compare X with addr 1C (FRQEND)
FA54 : 27 26      beq  LFA7C          ;branch Z=1 GEND (FINISH ON ZERO)
FA56 : D6 13      ldab  $13           ;load B with addr 13 (GCCNT) CYCLE COUNT
FA58 : 08         inx                 ;incr X
FA59 : DF 0C      stx  $0C            ;store X in addr 0C (XPLAY)
;GOUT
FA5B : CE 00 23   ldx  #$0023         ;load X with addr 0023 (#GWTAB) SETUP WAVEFORM POINTER
;GOUTLP
FA5E : 96 20      ldaa  $20           ;load A with addr 20 (GPER)
;GPRLP
FA60 : 4A         deca                ;decr A (WAIT FOR PERIOD)
FA61 : 26 FD      bne  LFA60          ;branch Z=0 GPRLP 
FA63 : A6 00      ldaa  $00,x         ;load A with X+00h (OUTPUT SOUND)
FA65 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
;GPR1
FA68 : 08         inx                 ;incr X
FA69 : 9C 1E      cpx  $1E            ;compare X with addr 1E (WVEND) END OF WAVE?
FA6B : 26 F1      bne  LFA5E          ;branch Z=0 GOUTLP
FA6D : 5A         decb                ;decr B
FA6E : 27 DA      beq  LFA4A          ;branch Z=1 GPLAY
FA70 : 08         inx                 ;incr X
FA71 : 09         dex                 ;decr X
FA72 : 08         inx                 ;incr X
FA73 : 09         dex                 ;decr X
FA74 : 08         inx                 ;incr X
FA75 : 09         dex                 ;decr X
FA76 : 08         inx                 ;incr X
FA77 : 09         dex                 ;decr X
FA78 : 01         nop                 ;
FA79 : 01         nop                 ;
FA7A : 20 DF      bra  LFA5B          ;branch always GOUT (SYNC 36)
;GEND
FA7C : 96 14      ldaa  $14           ;load A with addr 14 (GECDEC)
FA7E : 8D 62      bsr  LFAE2          ;branch sub WVDECA
;GEND40
FA80 : 7A 00 21   dec  $0021          ;decr addr 0021 (GECNT) ECHO ON?
FA83 : 26 C1      bne  LFA46          ;branch Z=0 GWT4 (YES)
FA85 : 96 03      ldaa  $03           ;load A with addr 03 (B2FLG) STOP BONUS
FA87 : 26 46      bne  LFACF          ;branch Z=0 GEND1
;GEND50
FA89 : 96 15      ldaa  $15           ;load A with addr 15 (GDFINC) CONTINUE FOR FREQ MOD SOUNDS
FA8B : 27 42      beq  LFACF          ;branch Z=1 GEND1 (NO)
FA8D : 7A 00 16   dec  $0016          ;decr addr 0016 (GDCNT) DELTA FREQ OVER?
FA90 : 27 3D      beq  LFACF          ;branch Z=1 GEND1 (YES...)
FA92 : 9B 22      adda  $22           ;add A with addr 22 (FOFSET) UPDATE FREQ OFFSET
;GEND60
FA94 : 97 22      staa  $22           ;store A in addr 22 (FOFSET)
;GEND61
FA96 : DE 1A      ldx  $1A            ;load X with addr 1A (GWFRQ) GET INDEX
FA98 : 5F         clrb                ;clear B (START FOUND FLAG INIT CLEAR)
;GW0
FA99 : 96 22      ldaa  $22           ;load A with addr 22 (FOFSET) INC OR DEC?
FA9B : 7D 00 15   tst  $0015          ;test addr 0015 (GDFINC)
FA9E : 2B 06      bmi  LFAA6          ;branch N=1 GW1 (DEC)
FAA0 : AB 00      adda  $00,x         ;add A with X+00h (INC)
FAA2 : 25 08      bcs  LFAAC          ;branch C=1 GW2 (CARRY=OVERFLOW)
FAA4 : 20 0B      bra  LFAB1          ;branch always GW2A
;GW1
FAA6 : AB 00      adda  $00,x         ;add A with X+00h (DEC)
FAA8 : 27 02      beq  LFAAC          ;branch Z=1 GW2 (OVERFLOW ON EQ)
FAAA : 25 05      bcs  LFAB1          ;branch C=1 GW2A (OVERFLOW IF CARRY CLEAR)
;GW2
FAAC : 5D         tstb                ;test B (FOUND START YET?)
FAAD : 27 08      beq  LFAB7          ;branch Z=1 GW2B (NO)
FAAF : 20 0F      bra  LFAC0          ;branch always GW3 (YES, THIS IS THE END)
;GW2A
FAB1 : 5D         tstb                ;test B 
FAB2 : 26 03      bne  LFAB7          ;branch Z=1 GW2B (ALREADY FOUND START)
FAB4 : DF 1A      stx  $1A            ;store X in addr 1A (GWFRQ) FOUND START
FAB6 : 5C         incb                ;incr B
;GW2B
FAB7 : 08         inx                 ;incr X
FAB8 : 9C 1C      cpx  $1C            ;compare X with addr 1C (FRQEND)
FABA : 26 DD      bne  LFA99          ;branch Z=0 GW0 (NOT OVER YET)
FABC : 5D         tstb                ;test B (FOUND START?)
FABD : 26 01      bne  LFAC0          ;branch Z=0 GW3 (YES)
FABF : 39         rts                 ;return subroutine (ALL OVER)
;GW3
FAC0 : DF 1C      stx  $1C            ;store X in addr 1C (FRQEND)
FAC2 : 96 14      ldaa  $14           ;load A with addr 14 (GECDEC) RE:XSFER WAVE?
FAC4 : 27 06      beq  LFACC          ;branch Z=1 GEND0 (NO)
FAC6 : 8D 08      bsr  LFAD0          ;branch sub WVTRAN (XSFER WAVE)
FAC8 : 96 19      ldaa  $19           ;load A with addr 19 (PRDECA)
FACA : 8D 16      bsr  LFAE2          ;branch sub WVDECA
;GEND0
FACC : 7E FA 42   jmp  LFA42          ;jump GWAVE
;GEND1
FACF : 39         rts                 ;return subroutine (TERMINATE)
;*************************************;
;*WAVE TRANSFER ROUTINE
;*************************************;
;WVTRAN
FAD0 : CE 00 23   ldx  #$0023         ;load X with addr 0023 (#GWTAB)
FAD3 : DF 0E      stx  $0E            ;store X in addr 0E (XPTR)
FAD5 : DE 17      ldx  $17            ;load X with addr 17 (GWFRM)
FAD7 : E6 00      ldab  $00,x         ;load B with X+00h (GET WAVE LENGTH)
FAD9 : 08         inx                 ;incr X
FADA : BD F9 65   jsr  LF965          ;jump sub TRANS
FADD : DE 0E      ldx  $0E            ;load X with addr 0E (XPTR)
FADF : DF 1E      stx  $1E            ;store X in addr 1E (WVEND) GET END ADDR
FAE1 : 39         rts                 ;return subroutine
;*************************************;
;*WAVE DECAY ROUTINE/ DECAY AMOUNT IN ACCA(1/16 PER DECAY)
;*************************************;
;WVDECA
FAE2 : 4D         tsta                ;test A
FAE3 : 27 2B      beq  LFB10          ;branch Z=1 WVDCX (NO DECAY)
FAE5 : DE 17      ldx  $17            ;load X with addr 17 (GWFRM) ROM WAVE INDEX
FAE7 : DF 0C      stx  $0C            ;store X in addr 0C (XPLAY)
FAE9 : CE 00 23   ldx  #$0023         ;load X with addr 0023 (#GWTAB)
FAEC : 97 11      staa  $11           ;store A in addr 11 (TEMPB) DECAY FACTOR
;WVDLP
FAEE : DF 0E      stx  $0E            ;store X in addr 0E (XPTR)
FAF0 : DE 0C      ldx  $0C            ;load X with addr 0C (XPLAY)
FAF2 : D6 11      ldab  $11           ;load B with addr 11 (TEMPB)
FAF4 : D7 10      stab  $10           ;store B in addr 10 (TEMPA) DECAY FACTOR TEMP
FAF6 : E6 01      ldab  $01,x         ;load B with X+01h (OFFSET FOR WAVE LENGTH)
FAF8 : 54         lsrb                ;logic shift left B
FAF9 : 54         lsrb                ;logic shift left B
FAFA : 54         lsrb                ;logic shift left B
FAFB : 54         lsrb                ;logic shift left B (CALC 1/16TH)
FAFC : 08         inx                 ;incr X
FAFD : DF 0C      stx  $0C            ;store X in addr 0C (XPLAY)
FAFF : DE 0E      ldx  $0E            ;load X with addr 0E (XPTR)
FB01 : A6 00      ldaa  $00,x         ;load A with X=00h
;WVDLP1
FB03 : 10         sba                 ;sub B from A (DECAY)
FB04 : 7A 00 10   dec  $0010          ;decr addr 0010 (TEMPA)
FB07 : 26 FA      bne  LFB03          ;branch Z=0 WVDLP1
FB09 : A7 00      staa  $00,x         ;store A in addr X=00h
FB0B : 08         inx                 ;incr X
FB0C : 9C 1E      cpx  $1E            ;compare X with addr 1E (WVEND) END OF WAVE?
FB0E : 26 DE      bne  LFAEE          ;branch Z=0 WVDLP (NO)
;WVDCX
FB10 : 39         rts                 ;return subroutine
;*************************************;
;Interrupt Processing
;*************************************;
;IRQ
FB11 : 8E 00 7F   lds  #$007F         ;load SP with value 007Fh (#ENDRAM) RE-INITIALIZE STACK
FB14 : B6 04 02   ldaa  $0402         ;load A with addr PIA (SOUND+2) GET INPUT TRIGGER
FB17 : CE F0 EB   ldx  #$F0EB         ;load X with F0EBh (#DECAYZ) RANDY'S BRAIN DAMAGE
FB1A : DF 07      stx  $07            ;store X in addr 07 (XDECAY)
FB1C : CE 00 12   ldx  #$0012         ;load X with addr 0012 (#FREQ1)
FB1F : DF 0E      stx  $0E            ;store X in addr 0E (XPTR)
FB21 : C6 AF      ldab  #$AF          ;load B with AFh
FB23 : D7 09      stab  $09           ;store B in addr 09 (AMP0)
FB25 : 0E         cli                 ;clear interrupts (NOW ALLOW IRQS)
FB26 : 43         coma                ;complement 1s A (INVERT INPUT)
FB27 : 84 3F      anda  #$3F          ;and A with 3Fh (MASK GARB)
FB29 : D6 04      ldab  $04           ;load B with addr 04 (ORGFLG)
FB2B : 27 03      beq  LFB30          ;branch Z=1 IRQ00 
FB2D : BD F8 CD   jsr  LF8CD          ;jump sub ORGNT1 (ORGAN TUNE)
;IRQ00
FB30 : 5F         clrb                ;clear B
FB31 : 81 0E      cmpa  #$0E          ;compare A with 0Eh (#SP1SND)
FB33 : 27 02      beq  LFB37          ;branch Z=1 IRQ00A 
FB35 : D7 02      stab  $02           ;store B in addr 02 (SP1FLG)
;IRQ00A
FB37 : 81 12      cmpa  #$12          ;compare A with 12h (#B2SND)
FB39 : 27 02      beq  LFB3D          ;branch Z=1 IRQ000
FB3B : D7 03      stab  $03           ;store B in addr 03 (B2FLG)
;IRQ000
FB3D : 4D         tsta                ;test A
FB3E : 27 3F      beq  LFB7F          ;branch Z=1 IRQ3 (INVALID INPUT)
FB40 : 4A         deca                ;decr A (REMOVE OFFSET)
FB41 : 81 1F      cmpa  #$1F          ;compare A with 1Fh
FB43 : 2D 14      blt  LFB59          ;branch N(+)V=1 IRQ001
FB45 : 81 3D      cmpa  #$3D          ;compare A with 3Dh
FB47 : 2E 08      bgt  LFB51          ;branch Z+(N(+)V)=0 IRQ00C
FB49 : 81 2A      cmpa  #$2A          ;compare A with 2Ah
FB4B : 22 08      bhi  LFB55          ;branch C+Z=0 IRQ00B
FB4D : 80 10      suba  #$10          ;sub A with 10h
FB4F : 20 0C      bra  LFB5D          ;branch always IRQ002
;IRQ00C
FB51 : 80 39      suba  #$39          ;sub A with 39h
FB53 : 20 24      bra  LFB79          ;branch always IRQ21
;IRQ00B
FB55 : 80 1C      suba  #$1C          ;sub A with 1Ch
FB57 : 20 12      bra  LFB6B          ;branch always IRQ2
;IRQ001
FB59 : 81 0C      cmpa  #$0C          ;compare A with 0Ch
FB5B : 22 08      bhi  LFB65          ;branch C+Z=0 IRQ10
;IRQ002
FB5D : BD F9 DC   jsr  LF9DC          ;jump sub GWLD (GWAVE SOUNDS)
FB60 : BD FA 42   jsr  LFA42          ;jump sub GWAVE
FB63 : 20 1A      bra  LFB7F          ;branch always IRQ3
;IRQ10
FB65 : 81 1B      cmpa  #$1B          ;compare A with 1Bh (SPECIAL SOUND?)
FB67 : 22 0E      bhi  LFB77          ;branch C+Z=0 IRQ20 (VARI SOUND)
FB69 : 80 0D      suba  #$0D          ;sub A with 0Dh (SUB OFFSET)
;IRQ2
FB6B : 48         asla                ;arith shift left A (DOUBLE FOR ADDRESSING)
FB6C : CE FB C4   ldx  #$FBC4         ;load X with FBC4h (INDEX TO JUMP TABLE)
FB6F : 8D 21      bsr  LFB92          ;branch sub ADDX (GET CORRECT INDEX)
FB71 : EE 00      ldx  $00,x          ;load X with X+00h (GET ADDRESS TO INDEX)
FB73 : AD 00      jsr  $00,x          ;jump sub addr X+00h (PERFORM IT)
FB75 : 20 08      bra  LFB7F          ;branch always IRQ3
;IRQ20
FB77 : 80 1C      suba  #$1C          ;sub A with 1Ch
;IRQ21
FB79 : BD F4 EE   jsr  LF4EE          ;jump sub VARILD
FB7C : BD F5 03   jsr  LF503          ;jump sub VARI
;IRQ3
FB7F : 96 00      ldaa  $00           ;load A with addr 00 (BG1FLG) BGROUND ACTIVE?
FB81 : 9A 01      oraa  $01           ;or A with addr 01 (BG2FLG)
FB83 : 27 FE      beq  LFB83          ;branch Z=1 here (*) NOPE
FB85 : 4F         clra                ;clear A
FB86 : 97 03      staa  $03           ;store A in addr 03 (B2FLG) KILL BONUSES
FB88 : 96 00      ldaa  $00           ;load A with addr 00 (BG1FLG)
FB8A : 27 03      beq  LFB8F          ;branch Z=1 IRQXX
FB8C : 7E F7 72   jmp  LF772          ;jump BG1
;IRQXX
FB8F : 7E F9 8F   jmp  LF98F          ;jump BG2
;*************************************;
;* ADD A TO INDEX REGISTER
;*************************************;
;ADDX
FB92 : DF 0C      stx  $0C            ;store X in addr 0C (XPLAY)
FB94 : 9B 0D      adda  $0D           ;add A with addr 0D (XPLAY+1)
FB96 : 97 0D      staa  $0D           ;store A in addr 0D (XPLAY+1)
FB98 : 24 03      bcc  LFB9D          ;branch C=0 ADDX1
FB9A : 7C 00 0C   inc  $000C          ;incr addr 000C (XPLAY)
;ADDX1
FB9D : DE 0C      ldx  $0C            ;load X with addr 0C (XPLAY)
FB9F : 39         rts                 ;return subroutine
;*************************************;
;Diagnostic Processing Here 
;*************************************;
;NMI
FBA0 : 0F         sei                 ;set interrupts
FBA1 : 8E 00 7F   lds  #$007F         ;load SP with 007Fh
FBA4 : CE FF FF   ldx  #$FFFF         ;load X with FFFFh
FBA7 : 5F         clrb                ;clear B
;NMI1
FBA8 : E9 00      adcb  $00,x         ;add C+B + X+00h
FBAA : 09         dex                 ;decr X
FBAB : 8C F0 00   cpx  #$F000         ;compare X with F000h
FBAE : 26 F8      bne  LFBA8          ;branch Z=0 NMI1
FBB0 : E1 00      cmpb  $00,x         ;compare B with X+00h
FBB2 : 27 01      beq  LFBB5          ;branch Z=1 NMI2
FBB4 : 3E         wai                 ;wait interrupts, PC+1
;NMI2
FBB5 : BD F7 A2   jsr  LF7A2          ;jump sub HBOMB
FBB8 : 86 02      ldaa  #$02          ;load A with 02h
FBBA : BD F8 D2   jsr  LF8D2          ;jump sub ORGASM
FBBD : 86 01      ldaa  #$01          ;load A with 01h
FBBF : BD F8 D2   jsr  LF8D2          ;jump sub ORGASM
FBC2 : 20 DC      bra  LFBA0          ;branch always NMI
;*************************************;
;*SPECIAL ROUTINE JUMP TABLE - FDB
;*************************************;
;JMPTBL
FBC4 : F9A4                           ;SP1
FBC6 : F772                           ;BG1
FBC8 : F97F                           ;BG2INC
FBCA : F55A                           ;LITE
FBCC : F9CC                           ;BON2
FBCE : F979                           ;BGEND
FBD0 : F59B                           ;TURBO
FBD2 : F562                           ;APPEAR
FBD4 : F77B                           ;THRUST
FBD6 : F780                           ;CANNON
FBD8 : F82B                           ;RADIO
FBDA : F859                           ;HYPER
FBDC : F878                           ;SCREAM
FBDE : F8C9                           ;ORGANT
FBE0 : F90C                           ;ORGANN
;*
;JMPTB1
FBE2 : F0FB                           ;SND2
FBE4 : F10A                           ;SND5
FBE6 : F0EF                           ;THNDR
FBE8 : F2F6                           ;HSTD
FBEA : F2D1                           ;ATARI
FBEC : F2D6                           ;SIREN
FBEE : F2E8                           ;ORRRR
FBF0 : F2FF                           ;PERK$$
FBF2 : F308                           ;SQRT
FBF4 : F2BB                           ;START
FBF6 : F128                           ;PLANE
FBF8 : F10F                           ;SND16
FBFA : F114                           ;SND17
FBFC : F550                           ;LAUNCH
FBFE : F5E1                           ;CDR
FC00 : F218                           ;KNOCK
FC02 : F147                           ;ZIREN
FC04 : F1A4                           ;WHIST
FC06 : F7A2                           ;HBOMB
;*************************************;
;*VARI VECTORS - FCB
;*************************************;
;VVECT  EQU  *
FC08 : 40 01 00 10 E1 00 80 FF FF     ;SAW
FC11 : 28 01 00 08 81 02 00 FF FF     ;FOSHIT
FC1A : 28 81 00 FC 01 02 00 FC FF     ;QUASAR
FC23 : FF 01 00 18 41 04 80 00 FF     ;CABSHK
FC2C : 00 FF 08 FF 68 04 80 00 FF     ;CSCALE
FC35 : 28 81 00 FC 01 02 00 FC FF     ;MOSQTO
FC3E : 60 01 57 08 E1 02 00 FE 80     ;VARBG1
;*************************************;
;*RADIO SOUND WAVEFORM
;*************************************;
FC46 : 8C 5B B6 40 BF 49 A4 73        ;RADSND
FC4F : 73 A4 49 BF 40 B6 5B 8C        ;
;*************************************;
;* NOTE DEFINITIONS AND ALL THAT JAZZ
;*************************************;
AF1  EQU  $F847
A1   EQU  $F83F
BF1  EQU  $F837
B1   EQU  $F830
C1   EQU  $F829
CS1  EQU  $F823
D1   EQU  $F81D
EF1  EQU  $F817
E1   EQU  $F812
F1   EQU  $F80D
FS1  EQU  $F808
G2   EQU  $F804
AF2  EQU  $7C47
A2   EQU  $7C3F
BF2  EQU  $7C37
B2   EQU  $7C30
C2   EQU  $7C29
CS2  EQU  $7C23
D2   EQU  $7C1D
EF2  EQU  $7C17
E2   EQU  $7C12
F2   EQU  $7C0D
FS2  EQU  $7C08
G3   EQU  $7C04
AF3  EQU  $3E47
A3   EQU  $3E3F
BF3  EQU  $3E37
B3   EQU  $3E30
C3   EQU  $3E29
CS3  EQU  $3E23
D3   EQU  $3E1D
EF3  EQU  $3E17
E3   EQU  $3E12
F3   EQU  $3E0D
FS3  EQU  $3E08
G4   EQU  $3E04
AF4  EQU  $1F47
A4   EQU  $1F3F
BF4  EQU  $1F37
B4   EQU  $1F30
C4   EQU  $1F29
CS4  EQU  $1F23
D4   EQU  $1F1D
EF4  EQU  $1F17
E4   EQU  $1F12
F4   EQU  $1F0D
FS4  EQU  $1F08
RS   EQU  $0004
TR   EQU  TG
;*************************************;
;*ORGAN TUNE TABLE
;*************************************;
;*OSCILLATOR MASK(1),DELAY(1),DURATION(2)
;*
;ORGTAB  EQU  *  (FCB)
FC57 : 1C                             ;NINTH-FIFTH-1
;FIFTH  EQU  *  (FDB)
FC58 : F804 0555                      ;G2,TG/FIF/4
FC5C : 0004 0555                      ;RS,TR/FIF/4
FC60 : F804 0555                      ;G2,TG/FIF/4
FC64 : 0004 0555                      ;RS,TR/FIF/4
FC68 : F804 0555                      ;G2,TG/FIF/4
FC6C : 0004 0555                      ;RS,TR/FIF/4
FC70 : F817 3B41                      ;EF1,TEF/FIF/2*7
;FCB
FC74 : B0                             ;TUNEND-NINTH
;NINTH  EQU  *
FC75 : 1F1D 04CB                      ;D4,TD/NIN/4
FC79 : 0004 0666                      ;RS,TR/NIN/4
FC7D : 3E1D 04CB                      ;D3,TD/NIN/4
FC81 : 0004 1FFE                      ;RS,TR/NIN/4*5
FC85 : 3E3F 0397                      ;A3,TA/NIN/4
FC89 : 0004 0666                      ;RS,TR/NIN/4
FC8D : 7C3F 0397                      ;A2,TA/NIN/4
FC91 : 0004 1FFE                      ;RS,TR/NIN/4*5
FC95 : 7C1D 04CB                      ;D2,TD/NIN/4
FC99 : 0004 0666                      ;RS,TR/NIN/4
FC9D : F81D 04CB                      ;D1,TD/NIN/4
FCA1 : 0004 0666                      ;RS,TR/NIN/4
FCA5 : 7C3F 0397                      ;A2,TA/NIN/4
FCA9 : 0004 0666                      ;RS,TR/NIN/4
FCAD : F83F 0397                      ;A1,TA/NIN/4
FCB1 : 0004 2CCA                      ;RS,TR/NIN/4*7
FCB5 : 7C3F 0397                      ;A2,TA/NIN/4
FCB9 : 7C1D 04CB                      ;D2,TD/NIN/4
FCBD : 7C12 0561                      ;E2,TE/NIN/4
FCC1 : 7C0D 05B3                      ;F2,TF/NIN/4
FCC5 : 7C12 0561                      ;E2,TE/NIN/4
FCC9 : 7C0D 05B3                      ;F2,TF/NIN/4
FCCD : 7C04 0666                      ;G3,TG/NIN/4
FCD1 : 7C0D 05B3                      ;F2,TF/NIN/4
FCD5 : 7C12 0561                      ;E2,TE/NIN/4
FCD9 : 7C1D 04CB                      ;D2,TD/NIN/4
FCDD : 3E37 03CE                      ;BF3,TBF/NIN/4
FCE1 : 3E3F 0397                      ;A3,TA/NIN/4
FCE5 : 7C04 0666                      ;G3,TG/NIN/4
FCE9 : 7C0D 05B3                      ;F2,TF/NIN/4
FCED : 7C12 0561                      ;E2,TE/NIN/4
FCF1 : 7C1D 04CB                      ;D2,TD/NIN/4
FCF5 : 7C23 0486                      ;CS2,TCS/NIN/4
FCF9 : 7C1D 04CB                      ;D2,TD/NIN/4
FCFD : 7C12 0561                      ;E2,TE/NIN/4
FD01 : 3E1D 04CB                      ;D3,TD/NIN/4
FD05 : 0004 0666                      ;RS,TR/NIN/4
FD09 : 7C1D 04CB                      ;D2,TD/NIN/4
FD0D : 0004 0666                      ;RS,TR/NIN/4
FD11 : 3E3F 0397                      ;A3,TA/NIN/4
FD15 : 0004 0666                      ;RS,TR/NIN/4
FD19 : 7C3F 0397                      ;A2,TA/NIN/4
FD1D : 0004 1FFE                      ;RS,TR/NIN/4*5
FD21 : F81D 2FEE                      ;D1,TD/NIN/2*5
;TUNEND
FD25 : 00                             ;LAST TUNE
;*************************************;
;*ORGAN NOTE TABLE
;*************************************;
;NOTTAB
;*SCALE    
;*     AF  A BF B  C  CS
FD26 : 47 3F 37 30 29 23              ;
;*    D  EF  E  F  FS  G
FD2C : 1D 17 12 0D 08 04              ;
;*************************************;
;*WAVE TABLE
;*************************************;
;*1ST BYTE= WAVELENGTH
;*
;GWVTAB  EQU  *
FD32 : 08                             ;GS2
FD33 : 7F D9 FF D9 7F 24 00 24        ;
;
FD3B : 08                             ;GSSQ2
FD3C : 00 40 80 00 FF 00 80 40        ;
;
FD44 : 10                             ;GS1
FD45 : 7F B0 D9 F5 FF F5 D9 B0        ;
FD4D : 7F 4E 24 09 00 09 24 4E        ;
;
FD55 : 10                             ;GS12
FD56 : 7F C5 EC E7 BF 8D 6D 6A        ;
FD5E : 7F 94 92 71 40 17 12 39        ;
;
FD66 : 10                             ;GSQ22
FD67 : FF FF FF FF 00 00 00 00        ;
FD6F : FF FF FF FF 00 00 00 00        ;
;
FD77 : 48                             ;GS72
FD78 : 8A 95 A0 AB B5 BF C8 D1        ;
FD80 : DA E1 E8 EE F3 F7 FB FD        ;
FD88 : FE FF FE FD FB F7 F3 EE        ;
FD90 : E8 E1 DA D1 C8 BF B5 AB        ;
FD98 : A0 95 8A 7F 75 6A 5F 54        ;
FDA0 : 4A 40 37 2E 25 1E 17 11        ;
FDA8 : 0C 08 04 02 01 00 01 02        ;
FDB0 : 04 08 0C 11 17 1E 25 2E        ;
FDB8 : 37 40 4A 54 5F 6A 75 7F        ;
;
FDC0 : 10                             ;GS1.7
FDC1 : 59 7B 98 AC B3 AC 98 7B        ;
FDC9 : 59 37 19 06 00 06 19 37        ;
;*****************************************************
FDD1 : 08                             ;GSQ2
FDD2 : FF FF FF FF 00 00 00 00        ;
;
FDDA : 10                             ;GS1234
FDDB : 76 FF B8 D0 9D E6 6A 82        ;
FDE3 : 76 EA 81 86 4E 9C 32 63        ;
;
FDEB : 10                             ;MW1
FDEC : 00 F4 00 E8 00 DC 00 E2        ;
FDF4 : 00 DC 00 E8 00 F4 00 00        ;
;
FDFC : 48                             ;HBPAT2
FDFD : 45 4B 50 56 5B 60 64 69        ;
FE05 : 6D 71 74 77 7A 7C 7E 7F        ;
FE0D : 7F 80 7F 7F 7E 7C 7A 77        ;
FE15 : 74 71 6D 69 64 60 5B 56        ;
FE1D : 50 4B 45 40 3B 35 30 2A        ;
FE25 : 25 20 1C 17 13 0F 0C 09        ;
FE2D : 06 04 02 01 01 00 01 01        ;
FE35 : 02 04 06 09 0C 0F 13 17        ;
FE3D : 1C 20 25 2A 30 35 3B 40        ;
;*************************************;
;*GWAVE SOUND VECTOR TABLE
;*************************************;
;*VECTOR FORMAT
;*BYTE 0: GECHO,GCCNT
;*BYTE 1: GECDEC,WAVE#
;*BYTE 2: PREDECAY FACTOR
;*BYTE 3: GDFINC
;*BYTE 4: VARIABLE FREQ COUNT
;*BYTE 5: FREQ PATTERN LENGTH
;*BYTE 6: FREQ PATTERN OFFSET
;*
;SVTAB  EQU  *
;HBDSND-GFRTAB 1
FE45 : 81 24 00 00 00 16 31           ;HBDV
;STDSND-GFRTAB 2
FE4C : 12 05 1A FF 00 27 6D           ;STDV
;SWPAT-GFRTAB 3
FE53 : 11 05 11 01 0F 01 47           ;DP1V
;SPNSND-GFRTAB 4
FE5A : 11 31 00 01 00 0D 1B           ;XBV
;BBSND-GFRTAB 5
FE61 : F4 12 00 00 00 14 47           ;BBSV
;HBESND-GFRTAB 6
FE68 : 41 45 00 00 00 0F 5B           ;HBEV
;SPNSND-GFRTAB 7
FE6F : 21 35 11 FF 00 0D 1B           ;PROTV
;SPNR-GFRTAB 8
FE76 : 15 00 00 FD 00 01 69           ;SPNRV
;COOLDN-GFRTAB 9
FE7D : 31 11 00 01 00 03 6A           ;CLDWNV
;BBSND-GFRTAB 10
FE84 : 01 15 01 01 01 01 47           ;SV3
;ED10FP-GFRTAB 11
FE8B : F6 53 03 00 02 06 94           ;ED10
;ED13FP-GFRTAB 12
FE92 : 6A 10 02 00 02 06 9A           ;ED12
;SPNR-GFRTAB 13
FE99 : 1F 12 00 FF 10 04 69           ;ED17
;BONSND-GFRTAB
FEA0 : 31 11 00 FF 00 0D 00           ;BONV
;TRBPAT-GFRTAB
FEA7 : 12 06 00 FF 01 09 28           ;TRBV
;****************************************************
;HBTSND-GFRTAB
FEAE : 14 17 00 00 00 0E 0D           ;HUNV
;HBTSND-GFRTAB
FEB5 : F4 11 00 00 00 0E 0D           ;SPD 
;SPNSND-GFRTAB
FEBC : 21 30 00 01 00 0D 1B           ;SPNV
;YUKSND-GFRTAB
FEC3 : 13 10 00 FF 00 09 A4           ;STRT
;SP1V
FECA : F4 18 00 00 00 12 B3           ;SP1V
;SSPVSSPSND-GFRTAB
FED1 : 82 22 00 00 00 18 C6           ;SSPV
;BWSSND-GFRTAB
FED8 : F2 19 00 00 00 16 DF           ;BMPV
;HBTSND-GFRTAB
FEDF : 21 30 00 FF 00 1B 0D           ;WIRDV
;YUKSND-GFRTAB
FEE6 : F1 19 00 00 00 0E A4           ;GDYUKV
;COOLDN-GFRTAB
FEED : 31 19 00 01 00 03 6A           ;BK8
;STDSND-GFRTAB
FEF4 : 41 02 D0 00 00 27 6D           ;SF10 
;SPNSND-GFRTAB
FEFB : 03 15 11 FF 00 0D 1B           ;BIL30
;*************************************;
;*GWAVE FREQ PATTERN TABLE
;*************************************;
;GFRTAB  EQU  *
;
;*BONUS SOUND
FF02 : A0 98 90 88 80 78 70 68        ;BONSND
FF09 : 60 58 50 44 40                 ;
;*HUNDRED POINT SOUND
FF0F : 01 01 02 02 04 04 08 08        ;HBTSND
FF17 : 10 10 30 60 C0 E0              ;
;*SPINNER SOUND
FF1D : 01 01 02 02 03 04 05 06        ;SPNSND
FF25 : 07 08 09 0A 0C                 ;
;*TURBINE START UP
FF2A : 80 7C 78 74 70 74 78 7C        ;TRBPAT
FF32 : 80                             ;
;*HEARTBEAT DISTORTO
FF33 : 01 01 02 02 04 04 08 08        ;HBDSND
FF3B : 10 20 28 30 38 40 48 50        ;
FF43 : 60 70 80 A0 B0 C0              ;
;*SWEEP PATTERN
;SWPAT  EQU  *
;*BIGBEN SOUNDS
FF48 : 08 40 08 40 08 40 08 40        ;BBSND
FF51 : 08 40 08 40 08 40 08 40        ;
FF59 : 08 40 08 40                    ;
;*HEARTBEAT ECHO
FF5D : 01 02 04 08 09 0A 0B 0C        ;HBESND
FF65 : 0E 0F 10 12 14 16              ;
;*SPINNER SOUND "DRIP"
FF6B : 40                             ;SPNR
;*COOL DOWNER
FF6C : 10 08 01                       ;COOLDN
;*START DISTORTO SOUND
FF6F : 01 01 01 01 02 02 03 03        ;STDSND
FF77 : 04 04 05 06 08 0A 0C 10        ;
FF7F : 14 18 20 30 40 50 40 30        ;
FF87 : 20 10 0C 0A 08 07 06 05        ;
FF8F : 04 03 02 02 01 01 01           ;
;*ED'S SOUND 10
FF96 : 07 08 09 0A 0C 08              ;ED10FP
;*ED'S SOUND 13
FF9C : 17 18 19 1A 1B 1C              ;ED13FP
;FILLER
FFA2 : 00 00 00 00 
;****************************************************
;YUKSND
FFA6 : 08 80 10 78 18 70 20 60        ;YUKSND
FFAE : 28 58 30 50 40 48 00           ;
;SP2SND
FFB5 : 01 08 10 01 08 10 01 08        ;SP2SND
FFBD : 10 01 08 10 01 08 10 01        ;
FFC5 : 08 10 00                       ;
;SSPSND
FFC8 : 10 20 40 10 20 40 10 20        ;SSPSND
FFD0 : 40 10 20 40 10 20 40 10        ;
FFD8 : 20 40 10 20 40 10 20 40        ;
FFE0 : 00                             ;
;BWSSND
FFE1 : 01 40 02 42 03 43 04 44        ;BWSSND
FFE9 : 05 45 06 46 07 47 08 48        ;
FFF1 : 09 49 0A 4A 0B 4B 00           ;
;*************************************;
;Motorola vector table
;*************************************;
FFF8 : FB 11                          ;IRQ 
FFFA : F0 1D                          ;RESET SWI (software) 
FFFC : FB A0                          ;NMI 
FFFE : F0 1D                          ;RESET (hardware) 
;END  CKSUM

;--------------------------------------------------------------






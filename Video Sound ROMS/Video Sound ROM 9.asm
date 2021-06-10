        ;
        ;  Disassembled by:
        ;    DASMx object code disassembler
        ;    (c) Copyright 1996-2003   Conquest Consultants
        ;    Version 1.40 (Oct 18 2003)
        ;
        ;  File:    Sinistar.532
        ;
        ;  Size:    4096 bytes
        ;  Checksum:  A822
        ;  CRC-32:    B82F4DDB
        ;
        ;  Date:    Sun May 16 11:17:56 2021
        ;
        ;  CPU:    Motorola 6800 (6800/6802/6808 family)
        ;
        ; Video Sound ROM 9 Sinistar, 1982, with Speech, optional stereo (2x mono)
        ; 
        ; ID: ROM13A A-5343-10209 (main sound board upright and cockpit versions)
        ; ID: ROM18A A-5343-10140 (rear sound board cockpit version)
        ; (note ROMnnA where nn is based on ROM count for whole game)
        ;
        ; Speech ROMS: IC 4,5,6,7 with Video Sound ROM 9
        ; ID: ROM14A A-5343-10199 (IC4)($F000)
        ; ID: ROM15A A-5343-10200 (IC5)($C000)
        ; ID: ROM16A A-5343-10201 (IC6)($D000)
        ; ID: ROM17A A-5343-10202 (IC7)($B000)
        ;
        ; ROM IC 4: TALK, TALKD
        ;
        ;Vocab: "Beware", "I", "Live", "Run", "Coward", "Hunger", "Am", "Sinistar", scream
        ;Phrases (x7): scream, "run coward", "I hunger coward", "beware I live", "I am Sinistar", "I hunger", "run run run".
        ; IRQ ldaa 2,3,4,5,6,7,9
        ;
        ;Organ Notes Table:
        ;hex : 47 3F 37 30 29 23 
        ;note: AF A  BF B  C  CS
        ;
        ;hex : 1D 17 12 0D 08 04
        ;note: D  E  FE F  FS G
        ;
        ;what is "the weird "extra ship" sound" made by randomised boot up RAM in dev machine?
        ; audio dump has #8 as RESET.
        ; Board 6 DS-2 does not turn off speech
        ; NMI does not trigger any sound at diag button press (due to checksum fail?)
        ;
        ; updated 02 June 2021
        ;
org  $F000
        ;
F000 : AA                             ;checksum
;*************************************;
;Reset and setup power on
;*************************************;
;RESET
F001 : 0F         sei                 ;SET INTERRUPT MASK
F002 : 8E 00 7F   lds  #$007F         ;load stack pointer with 007Fh (ENDRAM)
F005 : CE 04 00   ldx  #$0400         ;load X with 0400h (PIA addr)
F008 : 6F 01      clr  $01,x          ;clear addr X+01h (0401 PIA1 CR port A)
F00A : 6F 03      clr  $03,x          ;clear addr X+03h (0403 PIA1 CR port B)
F00C : 86 FF      ldaa  #$FF          ;load A with FFh
F00E : A7 00      staa  $00,x         ;store A in addr X+00h (0400 PIA1 PR/DDR port A out)
F010 : C6 80      ldab  #$80          ;load B with 80h
F012 : E7 02      stab  $02,x         ;store B in addr X+02h (0402 PIA1 PR/DDR port B in)
F014 : 86 37      ldaa  #$37          ;load A with 37h (CB2 low, IRQ allowed)
F016 : A7 03      staa  $03,x         ;store A in addr X+03h (0403 PIA1 CR port B)
F018 : 86 3C      ldaa  #$3C          ;load A with 3Ch (CA2 set init high, no IRQs)
F01A : A7 01      staa  $01,x         ;store A in addr X+01h (0401 PIA1 CR port A)
F01C : E7 02      stab  $02,x         ;store B in addr X+02h (0402 PIA1 PR/DDR port B in)
F01E : CE 00 7F   ldx  #$007F         ;load X with 007Fh (ENDRAM)
;RSET1 - clear all RAM mem
F021 : 6F 00      clr  $00,x          ;clear X+00h
F023 : 09         dex                 ;decr X
F024 : 26 FB      bne  LF021          ;branch Z=0 RSET1
F026 : 86 3C      ldaa  #$3C          ;load A with 3Ch (CA2 set init high, no IRQs)
F028 : 97 01      staa  $01           ;store A in addr 01
F02A : 0E         cli                 ;clear interrupts I=0
;STDBY
F02B : 20 FE      bra  LF02B          ;branch always STDBY
;*************************************;
;Organ Tune 
;*************************************;
;ORGANT
F02D : 7F 00 0E   clr  $000E          ;clear addr 0020 (ORGFLG)
F030 : 97 0C      staa  $0C           ;store A in addr 1E (TEMPA) (TUNE NUMBER)
F032 : 36         psha                ;push A into stack then SP-1
F033 : CE F1 D0   ldx  #$F1D0         ;load X with F1D0 (ORGTAB) <- 3 notes only :)
;ORGNT2:
F036 : A6 00      ldaa  $00,x         ;load A with X+00h (TUNE TABLE LENGTH)
F038 : 27 2D      beq  LF067          ;branch Z=1 ORGNT5
F03A : 7A 00 0C   dec  $000C          ;decr addr 000C
F03D : 27 06      beq  LF045          ;branch Z=1 ORGNT3
F03F : 4C         inca                ;incr A
F040 : BD F1 A7   jsr  LF1A7          ;jump sub ADDX
F043 : 20 F1      bra  LF036          ;branch always ORGNT2
;ORGNT3:
F045 : 08         inx                 ;incr X
F046 : DF 0A      stx  $0A            ;store X in addr 0A (XPTR)(NOTE POINTER)
F048 : BD F1 A7   jsr  LF1A7          ;jump sub ADDX
F04B : DF 08      stx  $08            ;store X in addr 08 (XPLAY)(TUNE END)
F04D : DE 0A      ldx  $0A            ;load X with addr 0A (XPTR)
;ORGNT4:
F04F : A6 00      ldaa  $00,x         ;load A with X+00h (TUNE LOOP)
F051 : 97 11      staa  $11           ;store A in addr 11 (OSCIL)
F053 : A6 01      ldaa  $01,x         ;load A with X+01h
F055 : EE 02      ldx  $02,x          ;load X with X+02h
F057 : DF 0F      stx  $0F            ;store X in addr 0F (DUR)
F059 : 8D 0F      bsr  LF06A          ;branch sub ORGANL
F05B : DE 0A      ldx  $0A            ;load X with addr 0A (XPTR)
F05D : 08         inx                 ;incr X
F05E : 08         inx                 ;incr X
F05F : 08         inx                 ;incr X
F060 : 08         inx                 ;incr X (4 bytes per note)
F061 : DF 0A      stx  $0A            ;store X in addr 0A (XPTR)
F063 : 9C 08      cpx  $08            ;compare X with addr 08 (XPLAY)(is tune end?)
F065 : 26 E8      bne  LF04F          ;branch Z=0 ORGNT4 (no)
;ORGNT5:
F067 : 32         pula                ;SP+1 pull stack into A (yes)
F068 : 20 63      bra  LF0CD          ;branch always IRQA
;*************************************;
;Organ Loader
;*************************************;
;ORGANL
F06A : CE 00 12   ldx  #$0012         ;load X with 0012h (#RDELAY)
;LDLP:
F06D : 81 00      cmpa  #$00          ;compare A with 00h
F06F : 27 15      beq  LF086          ;branch Z=1 LD1
F071 : 81 03      cmpa  #$03          ;compare A with 03h
F073 : 27 09      beq  LF07E          ;branch Z=1 LD2
F075 : C6 01      ldab  #$01          ;load B with 01h (opcode NOP)
F077 : E7 00      stab  $00,x         ;store B in add X+00h
F079 : 08         inx                 ;incr X
F07A : 80 02      suba  #$02          ;sub A with 02h
F07C : 20 EF      bra  LF06D          ;branch always LDLP
;LD2:
F07E : C6 91      ldab  #$91          ;load B with 91h (opcode CMPA)
F080 : E7 00      stab  $00,x         ;store B in addr X+00h
F082 : 6F 01      clr  $01,x          ;clear addr X+00h (00)
F084 : 08         inx                 ;incr X
F085 : 08         inx                 ;incr X
;LD1 - (stores 7E F094 jmp $F094)
F086 : C6 7E      ldab  #$7E          ;load B with 7Eh (opcode JMP extended addr'ing)(JMP START2)
F088 : E7 00      stab  $00,x         ;store B in addr X+00h
F08A : C6 F0      ldab  #$F0          ;load B with F0h (addr byte hi F0)(#ORGAN1!>8 MSB)
F08C : E7 01      stab  $01,x         ;store B in addr X+01h
F08E : C6 94      ldab  #$94          ;load B with 94h (addr byte lo 94)(#ORGAN1!.$FF LSB)
F090 : E7 02      stab  $02,x         ;store B in addr X+02h
;*************************************;
;Organ Routine 
;*************************************;
;DUR=DURATION, OSCILLATOR MASK
;ORGAN
F092 : DE 0F      ldx  $0F            ;load X with addr 0F
;ORGAN1 
F094 : 4F         clra                ;clear A
F095 : F6 00 0D   ldab  $000D         ;load B with addr 000D (LOAD B EXTEND TEMPB)
F098 : 5C         incb                ;incr B
F099 : D7 0D      stab  $0D           ;store B in addr 0D (TEMPB)
F09B : D4 11      andb  $11           ;and B with addr 11 (OSCIL)(MASK OSCILLATORS)
F09D : 54         lsrb                ;logic shift right B
F09E : 89 00      adca  #$00          ;add C+A + 00h
F0A0 : 54         lsrb                ;logic shift right B
F0A1 : 89 00      adca  #$00          ;add C+A + 00h
F0A3 : 54         lsrb                ;logic shift right B
F0A4 : 89 00      adca  #$00          ;add C+A + 00h
F0A6 : 54         lsrb                ;logic shift right B
F0A7 : 89 00      adca  #$00          ;add C+A + 00h
F0A9 : 54         lsrb                ;logic shift right B
F0AA : 89 00      adca  #$00          ;add C+A + 00h
F0AC : 54         lsrb                ;logic shift right B
F0AD : 89 00      adca  #$00          ;add C+A + 00h
F0AF : 54         lsrb                ;logic shift right B
F0B0 : 89 00      adca  #$00          ;add C+A + 00h
F0B2 : 48         asla                ;arith shift left A
F0B3 : 48         asla                ;arith shift left A
F0B4 : 48         asla                ;arith shift left A
F0B5 : 48         asla                ;arith shift left A
F0B6 : 48         asla                ;arith shift left A
F0B7 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F0BA : 09         dex                 ;decr X
F0BB : 27 03      beq  LF0C0          ;branch Z=1 ORGAN2 (NOTE OVER?)
F0BD : 7E 00 12   jmp  L0012          ;jump extend addr 0012 (RDELAY)
;ORGAN2:
F0C0 : 39         rts                 ;return subroutine
;*************************************;
;* INTERRUPT PROCESSING
;*************************************;
;IRQ
F0C1 : 8E 00 7F   lds  #$007F         ;load SP with value 007Fh (#ENDRAM)
F0C4 : B6 04 02   ldaa  $0402         ;load A with addr 0402 (PIA sound select)
F0C7 : 0E         cli                 ;clear interrupts I=0
F0C8 : 43         coma                ;complement 1s A
F0C9 : 84 1F      anda  #$1F          ;and A with 1Fh
F0CB : 8D 08      bsr  LF0D5          ;branch sub IRQ1
;IRQA
F0CD : 7D 00 04   tst  $0004          ;test addr 0004
F0D0 : 27 FB      beq  LF0CD          ;branch Z=1 IRQA
F0D2 : 7E F7 8B   jmp  LF78B          ;jump SYNTH30
;IRQ1
F0D5 : 81 01      cmpa  #$01          ;compare A with 01h
F0D7 : 2E 03      bgt  LF0DC          ;branch Z+(N(+)V)=0 IRQ3
F0D9 : 7E F0 2D   jmp  LF02D          ;jump ORGANT
;IRQ2 - CHECK FOR PRESENCE OF TALKING PROGRAM
F0DC : 81 02      cmpa  #$02          ;compare A with 02h
F0DE : 2E 0C      bgt  LF0EC          ;branch Z+(N(+)V)=0 IRQ3
F0E0 : F6 EF FD   ldab  $EFFD         ;load B with addr EFFD (TALK) ROM IC4
F0E3 : C1 7E      cmpb  #$7E          ;compare B with 7Eh (jmp opcode)
F0E5 : 26 09      bne  LF0F0          ;branch Z=0 IRQ3A
F0E7 : 86 09      ldaa  #$09          ;load A with 09h
F0E9 : 7E EF FD   jmp  LEFFD          ;jump TALK (#09)
;IRQ3
F0EC : 81 03      cmpa  #$03          ;compare A with 03h
F0EE : 2E 05      bgt  LF0F5          ;branch Z+(N(+)V)=0 IRQ4
;IRQ3A
F0F0 : 80 02      suba  #$02          ;sub A with 02h
F0F2 : 7E F6 60   jmp  LF660          ;jump WALSH
;IRQ4
F0F5 : 81 04      cmpa  #$04          ;compare A with 04h
F0F7 : 2E 04      bgt  LF0FD          ;branch Z+(N(+)V)=0 IRQ5
F0F9 : 7F 00 04   clr  $0004          ;clear addr 0004
F0FC : 39         rts                 ;return subroutine
;IRQ5
F0FD : 81 05      cmpa  #$05          ;compare A with 05h
F0FF : 2E 03      bgt  LF104          ;branch Z+(N(+)V)=0 IRQ6
F101 : 7E F7 7E   jmp  LF77E          ;jump MEM345
;IRQ6
F104 : 81 06      cmpa  #$06          ;compare A with 06h
F106 : 2E 0F      bgt  LF117          ;branch Z+(N(+)V)=0 IRQ7
F108 : F6 EF FD   ldab  $EFFD         ;load B with addr EFFD (TALK)
F10B : C1 7E      cmpb  #$7E          ;compare B with 7Eh (jmp opcode)
F10D : 27 03      beq  LF112          ;branch Z=1 IRQ6A
F10F : 7E F1 A2   jmp  LF1A2          ;jump IRQX2
;IRQ6A
F112 : 86 08      ldaa  #$08          ;load A with 08h
F114 : 7E EF FD   jmp  LEFFD          ;jump TALK (#08)
;IRQ7
F117 : 81 07      cmpa  #$07          ;compare A with 02h
F119 : 2E 03      bgt  LF11E          ;branch Z+(N(+)V)=0 IRQ8
F11B : 7E FB 1D   jmp  LFB1D          ;jump THRUST
;IRQ8
F11E : 81 08      cmpa  #$08          ;compare A with 08h
F120 : 2E 03      bgt  LF125          ;branch Z+(N(+)V)=0 IRQ0A
F122 : 7E FB 2A   jmp  LFB2A          ;jump C4NNON
;IRQ0A
F125 : 81 0A      cmpa  #$0A          ;compare A with 0Ah
F127 : 2E 05      bgt  LF12E          ;branch Z+(N(+)V)=0 IRQ0B
F129 : 80 09      suba  #$09          ;sub A with 09h
F12B : 7E F6 86   jmp  LF686          ;jump SYNTH27
;IRQ0B
F12E : 81 0B      cmpa  #$0B          ;compare A with 0Bh
F130 : 2E 0C      bgt  LF13E          ;branch Z+(N(+)V)=0 IRQ0C
F132 : F6 EF FD   ldab  $EFFD         ;load B with addr EFFD (TALK)
F135 : C1 7E      cmpb  #$7E          ;compare B with 7Eh (jmp opcode)
F137 : 26 69      bne  LF1A2          ;branch Z=0 IRQX2
F139 : 86 06      ldaa  #$06          ;load A with 06h
F13B : 7E EF FD   jmp  LEFFD          ;jump TALK (#06)
;IRQ0C
F13E : 81 0C      cmpa  #$0C          ;compare A with 0Ch
F140 : 2E 03      bgt  LF145          ;branch Z+(N(+)V)=0 IRQ0D
F142 : 7E FB 10   jmp  LFB10          ;jump CANNON
;IRQ0D
F145 : 81 0D      cmpa  #$0D          ;compare A with 0Dh
F147 : 2E 0C      bgt  LF155          ;branch Z+(N(+)V)=0 IRQ0E
F149 : F6 EF FD   ldab  $EFFD         ;load B with addr EFFD (TALK)
F14C : C1 7E      cmpb  #$7E          ;compare B with 7Eh (jmp opcode)
F14E : 26 52      bne  LF1A2          ;branch Z=0 IRQX2
F150 : 86 02      ldaa  #$02          ;load A with 02h
F152 : 7E EF FD   jmp  LEFFD          ;jump TALK (#02)
;IRQ0E
F155 : 81 0E      cmpa  #$0E          ;compare A with 0Eh
F157 : 2E 0C      bgt  LF165          ;branch Z+(N(+)V)=0 IRQ0F
F159 : F6 EF FD   ldab  $EFFD         ;load B with addr EFFD (TALK)
F15C : C1 7E      cmpb  #$7E          ;compare B with 7Eh (jmp opcode)
F15E : 26 42      bne  LF1A2          ;branch Z=0 IRQX2
F160 : 86 03      ldaa  #$03          ;load A with 03h
F162 : 7E EF FD   jmp  LEFFD          ;jump TALK (#03)
;IRQ0F
F165 : 81 0F      cmpa  #$0F          ;compare A with 0Fh
F167 : 2E 0C      bgt  LF175          ;branch Z+(N(+)V)=0 IRQ13
F169 : F6 EF FD   ldab  $EFFD         ;load B with addr EFFD (TALK)
F16C : C1 7E      cmpb  #$7E          ;compare B with 7Eh (jmp opcode)
F16E : 26 32      bne  LF1A2          ;branch Z=0 IRQX2
F170 : 86 04      ldaa  #$04          ;load A with 04h
F172 : 7E EF FD   jmp  LEFFD          ;jump TALK (#04)
;IRQ13
F175 : 81 13      cmpa  #$13          ;compare A with 13h
F177 : 26 0C      bne  LF185          ;branch Z=0 IRQ1C
F179 : F6 EF FD   ldab  $EFFD         ;load B with addr EFFD (TALK)
F17C : C1 7E      cmpb  #$7E          ;compare B with 7Eh (jmp opcode)
F17E : 26 22      bne  LF1A2          ;branch Z=0 IRQX2
F180 : 86 05      ldaa  #$05          ;load A with 05h
F182 : 7E EF FD   jmp  LEFFD          ;jump TALK (#05)
;IRQ1C
F185 : 81 1C      cmpa  #$1C          ;compare A with 1Ch
F187 : 2E 08      bgt  LF191          ;branch Z+(N(+)V)=0 IRQ1D
F189 : 80 0E      suba  #$0E          ;sub A with 0Eh
;IRQ1CA
F18B : BD F7 DA   jsr  LF7DA          ;jump sub GWLD
F18E : 7E F8 40   jmp  LF840          ;jump GWAVE
;IRQ1D
F191 : 81 1D      cmpa  #$1D          ;compare A with 1Dh
F193 : 2E 0C      bgt  LF1A1          ;branch Z+(N(+)V)=0 IRQX1
F195 : F6 EF FD   ldab  $EFFD         ;load B with addr EFFD (TALK)
F198 : C1 7E      cmpb  #$7E          ;compare B with 7Eh (jmp opcode)
F19A : 26 06      bne  LF1A2          ;branch Z=0 IRQX2
F19C : 86 07      ldaa  #$07          ;load A with 07h
F19E : 7E EF FD   jmp  LEFFD          ;jump TALK (#07)
;IRQX1
F1A1 : 39         rts                 ;return subroutine
;IRQX2
F1A2 : 86 01      ldaa  #$01          ;load A with 01h
F1A4 : 7E F1 8B   jmp  LF18B          ;jump IRQ1CA
;*************************************;
;Add A to Index Register
;*************************************;
;ADDX
F1A7 : DF 08      stx  $08            ;store X in addr 08
F1A9 : 9B 09      adda  $09           ;add A with addr 09
F1AB : 97 09      staa  $09           ;store A in addr 09
F1AD : 96 08      ldaa  $08           ;load A with addr 08
F1AF : 89 00      adca  #$00          ;add C+A + 00h
F1B1 : 97 08      staa  $08           ;store A in addr 08
F1B3 : DE 08      ldx  $08            ;load X with addr 08
F1B5 : 39         rts                 ;return subroutine
;*************************************;
;* DIAGNOSTIC PROCESSING HERE
;*************************************;
;NMI:
F1B6 : 0F         sei                 ;set interrupt mask
F1B7 : 8E 00 7F   lds  #$007F         ;load SP with 007Fh
F1BA : CE FF FF   ldx  #$FFFF         ;load X with FFFFh
F1BD : 5F         clrb                ;clear B
;NMI1
F1BE : E9 00      adcb  $00,x         ;add C+B + X+00h
F1C0 : 09         dex                 ;decr X
F1C1 : 8C F0 00   cpx  #$F000         ;compare X with F000h
F1C4 : 26 F8      bne  LF1BE          ;branch Z=0 NMI1
F1C6 : E1 00      cmpb  $00,x         ;compare B with X+00h (compare with checksum?)
F1C8 : 27 01      beq  LF1CB          ;branch Z=1 NMI2
F1CA : 3E         wai                 ;wait interrupts, PC+1
;NMI2
F1CB : BD F6 F9   jsr  LF6F9          ;jump sub SYNTH28
F1CE : 20 E6      bra  LF1B6          ;branch always NMI
;*************************************;
;Organ Tune Table - in 4th octave
;*************************************;
; Oscillator Mask(1), Delay(1), Duration(2)
F1D0 : 0C                             ;FCB 3*4
F1D1 : 03 47 05 FC                    ;AF4  EQU  $0347
F1D5 : 03 12 11 F0                    ;E4  EQU  $0312
F1D9 : 03 29 07 1E                    ;C4  EQU  $0329
;*************************************;
;* NAM WALSH FUNCTION SOUND MACHINE V2
;*************************************;
;* T. MURPHY  11/10/81
;
MINPER  EQU  25      ;6*25 = 150 MICROSECS IS MIN SAMPLE PERIOD
SOUND   SET  $400
;
WORG
        ORG  0
;
        RMB  8       ;GLOBALS
;
FCMDPT  RMB  2       ;PTR TO CURRENT FILTER COMMAND (USER INITIALIZED)
PCMDPT  RMB  2       ;SAME FOR PITCH PROGRAM
SMPPER  RMB  2       ;HI BYTE * 6 IS SAMPLE DELAY
HRMTBL  RMB  2       ;PTR TO HARMONIC FN VALUE TABLE
;
WAVSRT  RMB  16      ;WAVEFORM
;
PERVEL  RMB  2       ;ADDED TO SMPPER EACH WAVE (PITCH CONTROL)
GLBPRO  RMB  1       ;GLOBAL PERIOD OFFSET
TMPPER  RMB  1       ;= SMPPER + GLBPRO
PERACM  RMB  1       ;USED TO CALCULATE SMALL PITCH ADJUSTS
;
PWVCNT  EQU  *       ;#OF WAVES TO PLAY BEFORE NEXT PITCH CMD (P PROGRAM)
PSTK    RMB  2       ;TOP OF PITCH RETURN/COUNT STACK
PWAVPT  RMB  2       ;PTR TO CURRENT SAMPLE BEING PLAYED
PCMD    RMB  1       ;CURRENT PITCH CMD
PTEMP   RMB  2
;
FVECT   RMB  3       ;JUMP TO CURRENT FILTER STATE (FILTER PGM CONTROL)
FCNT    EQU  *       ;MISC CTR, WAVE DELAY IF <0
FSTK    RMB  2       ;TOP OF FILTER RETURN/COUNT STACK
HAPTR   RMB  2       ;PTR TO AMPLITUDE OF CURRENT HARMONIC
;
FWVPTR  RMB  2       ;PTS TO WAVE PT BEING ALTERED (FILTER GUTS)
HAMP    RMB  1       ;CURRENT HARMONIC AMPLITUDE
FMSK    RMB  1       ;BIT MASK SELECTS HARMONIC FN VALUE
*                    ;NEXT 3 MUST BE IN ORDER
FNHI    RMB  1       ;HOLDS CURRENT HARMONIC FN VALUES AS BITS
FNLO    RMB  1       ;ALSO USED AS TEMPORARIES
FCMD    RMB  1       ;CURRENT INSTRUCTION BEING EXECUTED
;
FBTM    EQU  *-3     ;FILTER STACK GROWS UP
        ORG  95
PBTM    EQU  *       ;PITCH STACK GROWS DOWN
;
        RMB  1       ;ADD2HA FOR CONST WAVE
ADD2HA  RMB  8       ;ADD ADD2HA(8-I)*HARM(I) TO WAVE
CNAMP   RMB  1       ;CURRENT AMP OF CONST FUNCTION
CURHA   RMB  8       ;CURHA(8-I) = <WAVE!HARM(I)>
;
ENDRAM  SET  127
;
        ORG  WORG

;*************************************;
; SUBTTL WAVE PLAYER AND PITCH MODIFICATION
;*************************************;
;* PLAY A SAMPLE, REMAINING DELAY IN B.  TOTAL DELAY = MIN (60,B*6) MICS.
;
;NTHRVC
F1DD : C0 0D      subb  #$0D          ;sub B with 0Dh (#13) LOOP DELAY IS 78 CYCLES
F1DF : 37         pshb                ;push B into stack then SP-1
F1E0 : BD 00 2C   jsr  L002C          ;jump sub LOCRAM addr 002C (FVECT)
F1E3 : 33         pulb                ;SP+1 pull stack into B
;NXTSMP:
F1E4 : C1 14      cmpb  #$14          ;compare B with 14h
F1E6 : 22 F5      bhi  LF1DD          ;branch C+Z=0 NTHRVC
;
F1E8 : 01         nop                 ;
F1E9 : 96 24      ldaa  $24           ;load A with addr 24 (PERACM)
F1EB : 9B 21      adda  $21           ;add A with addr 21 (PERVEL+1)
F1ED : 97 24      staa  $24           ;store A in addr 24 (PERACM)
F1EF : C9 F6      adcb  #$F6          ;add C+B + F6h (#-10) MINIMUM DELAY + FRACTION
;
F1F1 : 5A         decb                ;decr B (WASTE SMALL TIME)
F1F2 : 2A FD      bpl  LF1F1          ;branch N=0 (*-1)
;
F1F4 : 96 28      ldaa  $28           ;load A with addr 28 (PWAVPT+1) PT TO NEXT BYTE OF 16 BYTE WAVE
F1F6 : 4C         inca                ;incr A
F1F7 : 84 0F      anda  #$0F          ;and A with 0Fh (#15)
F1F9 : 8A 10      oraa  #$10          ;or A with 10h (#WAVSRT) ! WAVSRT MUST BE DIVISIBLE BY 16 !
F1FB : 97 28      staa  $28           ;store A in addr 28 (PWAVPT+1)
;
F1FD : DE 27      ldx  $27            ;load X with addr 27 (PWAVPT)
F1FF : E6 00      ldab  $00,x         ;load B with X+00h
F201 : F7 04 00   stab  $0400         ;store B in DAC output SOUND
;
F204 : 84 0F      anda  #$0F          ;and A with 0Fh (#15) 0 IFF RESTARTING WAVE
F206 : 39         rts                 ;return subroutine
;*************************************;
; Walsh Machine
;*************************************;
;* PLAYS WAVE AND ALTERS PITCH ACCORDING TO PITCH CMDS.
;* SMPPER IS INITIAL PITCH,  PCMDPT IS START PITCH PROGRAM,
;* FCMDPT IS START WAVE MODIFIER (FILTER) PROGRAM.
;
;WSM
F207 : 4F         clra                ;clear A
F208 : CE 00 10   ldx  #$0010         ;load X with 0010h (#WAVSRT)
F20B : C6 61      ldab  #$61          ;load B with 61h (#CURHA+8-WAVSRT)
;1$
F20D : A7 00      staa  $00,x         ;store A in addr X+00h
F20F : 08         inx                 ;incr X
F210 : 5A         decb                ;decr B
F211 : 26 FA      bne  LF20D          ;branch Z=0 1$
F213 : C6 5F      ldab  #$5F          ;load B with 5Fh (#PBTM)
F215 : D7 26      stab  $26           ;store B in addr 26 (PSTK+1)
F217 : C6 37      ldab  #$37          ;load B with 37h (#FBTM)
F219 : D7 30      stab  $30           ;store B in addr 30 (FSTK+1)
F21B : C6 7E      ldab  #$7E          ;load B with 7Eh (#126)
F21D : D7 2C      stab  $2C           ;store B in addr 2C (FVECT)
F21F : CE F3 F2   ldx  #$F3F2         ;load X with F3F3h (#NXTFCM)
F222 : DF 2D      stx  $2D            ;store X in addr 2D (FVECT+1)
F224 : D6 0C      ldab  $0C           ;load B with addr 0C (SMPPER)
F226 : D7 23      stab  $23           ;store B in addr 23 (TMPPER)
;PPLPE1
F228 : C0 03      subb  #$03          ;sub B with 03h
;PPLPE2
F22A : BD F1 E4   jsr  LF1E4          ;jump sub NXTSMP
F22D : 08         inx                 ;incr X
;PPLP
F22E : D6 23      ldab  $23           ;load B with addr 23 (TMPPER)
F230 : C0 02      subb  #$02          ;sub B with 02h (LOOP DELAY IS 18-6 = 12)
F232 : BD F1 DD   jsr  LF1DD          ;jump sub NTHRVC
F235 : 26 F7      bne  LF22E          ;branch Z=0 PPLP (ESCAPE ON WAVE BOUNDARY)
;
F237 : D6 20      ldab  $20           ;load B with addr 20 (PERVEL 7) (ALL TIMES ARE SINCE RTS FROM LAST NXTSMP)
F239 : 96 21      ldaa  $21           ;load A with addr 21 (PERVEL+1)
F23B : 9B 0D      adda  $0D           ;add A with addr 0D (SMPPER+1) UPDATE SAMPLE RATE ONCE EACH WAVE PLAY
F23D : D9 0C      adcb  $0C           ;add C+B + addr OC (SMPPER)
F23F : 97 0D      staa  $0D           ;store A in addr 0D (SMPPER+1)
F241 : D7 0C      stab  $0C           ;store B in addr 0C (SMPPER)
;
F243 : DB 22      addb  $22           ;add B with addr 22 (GLBPRO)
F245 : 86 19      ldaa  #$19          ;load A with 19h (#MINPER) AVOID SYNC ERROS BY LIMITING PITCH
F247 : 11         cba                 ;compare A with B (MAX. PITCH ALLOWS AT LEAST 1 FILTER)
F248 : 24 01      bcc  LF24B          ;branch C=0 (*+3) CALL PER SAMPLE
;F24A : 81 16      cmpa  #$16          ;<- disasm error (FCB 81 TAB)
F24A : 81                             ;FCB 129
F24B : 16         tab                 ;transfer A to B
;
F24C : D7 23      stab  $23           ;store B in addr 23 (TMPPER 41)
F24E : 01         nop                 ;
F24F : C0 09      subb  #$09          ;sub B with 09h 
F251 : BD F1 E4   jsr  LF1E4          ;jump sub NXTSMP
;
F254 : 96 2F      ldaa  $2F           ;load A with addr 2F (FCNT) COUNT WAVE PLAYS FOR FILTER
F256 : 16         tab                 ;transfer A to B (ONLY IF <0)
F257 : 48         asla                ;arith shift left A 
F258 : C9 00      adcb  #$00          ;add C+B + 00h
F25A : D7 2F      stab  $2F           ;store B in addr 2F (FCNT)
;
F25C : D6 23      ldab  $23           ;load B with addr 23 (TMPPER)
F25E : C0 05      subb  #$05          ;sub B with 05h
F260 : 96 25      ldaa  $25           ;load A with addr 25 (PWVCNT)
F262 : 2A 06      bpl  LF26A          ;branch N=0 PAWAKE
;
F264 : 7C 00 25   inc  $0025          ;incr addr 0025 (PWVCNT) UPDATE DELAY COUNT IF <0
F267 : 01         nop                 ;
F268 : 20 BE      bra  LF228          ;branch always PPLPE1
;PAWAKE
F26A : 5A         decb                ;decr B (ELSE WE ARE ALIVE)
F26B : BD F1 E4   jsr  LF1E4          ;jump sub NXTSMP
;
F26E : DE 0A      ldx  $0A            ;load X with addr 0A (PCMDPT)
F270 : A6 00      ldaa  $00,x         ;load A with X+00h
F272 : 2A 12      bpl  LF286          ;branch N=0 PPLP1 (MOST CMDS ARE >0)
;
F274 : 81 80      cmpa  #$80          ;compare A with 80h (#128)
F276 : 27 5F      beq  LF2D7          ;branch Z=1 STOPR (EXCEPT FOR END = 128)
;
F278 : 4C         inca                ;incr A
F279 : 97 25      staa  $25           ;store A in addr 25 (PWVCNT) OR A NEGATIVE NUMBER -N
F27B : 08         inx                 ;incr X  (WHICH WAITS N WAVE PLAYS)
;F27C : FF 00 0A   stx  X000A          ;<- disasm error (FCB -1,0,PCMDPT)
F27C : FF                             ;-1  (BEFORE FETCHING THE NEXT COMMAND)
F27D : 00                             ;0
F27E : 0A                             ;PCMDPT
;PPLP35
F27F : D6 23      ldab  $23           ;load B with addr 23 (TMPPER)
F281 : C0 06      subb  #$06          ;sub B with 06h
F283 : 7E F2 28   jmp  LF228          ;jump PPLPE1
;PPLP1
F286 : 08         inx                 ;incr X
F287 : E6 00      ldab  $00,x         ;load B with X+00h (GET NEXT COMMAND STRING BYTE ON STACK)
F289 : 37         pshb                ;push B into stack then SP-1
F28A : 08         inx                 ;incr X
F28B : DF 0A      stx  $0A            ;store X in addr 0A (PCMDPT)
;
F28D : 97 29      staa  $29           ;store A in addr 29 (PCMD)
F28F : 84 70      anda  #$70          ;and A with 70h (#112)
F291 : 44         lsra                ;logic shift right A
F292 : 44         lsra                ;logic shift right A
F293 : 44         lsra                ;logic shift right A
F294 : 5F         clrb                ;clear B
;
F295 : 8B 6B      adda  #$6B          ;add A with 6Bh (#PCMDJT!.255)
F297 : C9 F3      adcb  #$F3          ;add C+B + F3h (#PCMDJT/256)
F299 : 97 2B      staa  $2B           ;store A in addr 2B (PTEMP+1)
F29B : D7 2A      stab  $2A           ;store B in addr 2A (PTEMP)
;
F29D : D6 23      ldab  $23           ;load B with addr 23 (TMPPER)
F29F : D6 23      ldab  $23           ;load B with addr 23 (TMPPER)
F2A1 : C0 0D      subb  #$0D          ;sub B with 0Dh (#13)
F2A3 : BD F1 E4   jsr  LF1E4          ;jump sub NXTSMP
;
F2A6 : 5F         clrb                ;clear B
F2A7 : DE 2A      ldx  $2A            ;load X with addr 2A (PTEMP) EXECUTE CMD
F2A9 : EE 00      ldx  $00,x          ;load X with X+00h
F2AB : 6E 00      jmp  $00,x          ;jump addr X+00h
;*************************************;
;* PITCH COMMAND ROUTINES. 
;*************************************;
;  UNLESS OTHERWISE STATED, N IS A SIGNED 8 BIT
;* NUMBER = BYTE FOLLOWING OPCODE.
;
;* LDP N  IS  SMPPER := N,  ADP N  IS SMPPER := SMPPER + N
;
;LDPR
F2AD : 96 29      ldaa  $29           ;load A with addr 29 (PCMD) BIT 0 = 1 FOR LOAD
F2AF : 47         asra                ;arith shift right A
F2B0 : C2 00      sbcb  #$00          ;sub C+B + 00h
F2B2 : D4 0C      andb  $0C           ;and B with addr 0C (GLBPRO)
F2B4 : 32         pula                ;SP+1 pull stack into A
F2B5 : 10         sba                 ;sub B from A
F2B6 : 9B 0C      adda  $0C           ;add A with addr 0C (GLBPRO)
F2B8 : 97 0C      staa  $0C           ;store A in addr 0C (GLBPRO)
F2BA : 08         inx                 ;incr X
;LDPRE
F2BB : D6 23      ldab  $23           ;load B with addr 23 (TMPPER)
F2BD : C0 0A      subb  #$0A          ;sub B with 0Ah 
F2BF : 7E F2 2A   jmp  LF22A          ;jump PPLPE2
;*************************************;
;* LDO N IS  GLBPRO := N,  ADO N IS  GLBPRO := GLBPRO + N
;
;LDOR
F2C2 : 96 29      ldaa  $29           ;load A with addr 29 (PCMD) BIT 0 = 1 FOR LOAD
F2C4 : 47         asra                ;arith shift right A
F2C5 : C2 00      sbcb  #$00          ;sub C+B with 00h
F2C7 : D4 22      andb  $22           ;and B with addr 22 (GLBPRO)
F2C9 : 32         pula                ;SP+1 pull stack into A
F2CA : 10         sba                 ;sub B from A
F2CB : 9B 22      adda  $22           ;add A with addr 22 (GLBPRO)
F2CD : 97 22      staa  $22           ;store A in addr 22 (GLBPRO)
F2CF : 20 EA      bra  LF2BB          ;branch always LDPRE
;*************************************;
;* ESC EXECUTES MACHINE LANGUAGE IMMEDIATELY FOLLOWING
;
;ESCR
F2D1 : 32         pula                ;SP+1 pull stack into A
F2D2 : DE 0A      ldx  $0A            ;load X with addr 0A (PCMDPT)
F2D4 : 09         dex                 ;decr X
F2D5 : 6E 00      jmp  $00,x          ;jump addr X+00h
;*************************************;
;* STOP EITHER REPEATS A CALL, RETURNS FROM A CALL, OR ENDS SOUND.
;
;STOPR
F2D7 : 96 26      ldaa  $26           ;load A with addr 26 (PSTK+1)
F2D9 : 81 5F      cmpa  #$5F          ;compare A with 5Fh (#PBTM)
F2DB : 2B 01      bmi  LF2DE          ;branch N=1 (*+3)
F2DD : 39         rts                 ;return subroutine
;
F2DE : D6 23      ldab  $23           ;load B with addr 23 (TMPPER)
F2E0 : C0 07      subb  #$07          ;sub B with 07h
F2E2 : BD F1 E4   jsr  LF1E4          ;jump sub NXTSMP
;
F2E5 : DE 25      ldx  $25            ;load X with addr 25
F2E7 : 6A 02      dec  $02,x          ;decr addr X+02h
F2E9 : 2B 12      bmi  LF2FD          ;branch N=0 PRET (DONE)
;
F2EB : EE 00      ldx  $00,x          ;load X with X+00h (ELSE REPEAT)
F2ED : A6 00      ldaa  $00,x         ;load A with X+00h
F2EF : 36         psha                ;push A into stack then SP-1
F2F0 : 08         inx                 ;incr X
F2F1 : DF 0A      stx  $0A            ;store X in addr 0A (PCMDPT)
;
;F2F3 : F6 00 23   ldab  X0023         ;<- disasm error (FCB -10,0,TMPPER)
F2F3 : F6                             ;-10
F2F4 : 00                             ;0
F2F5 : 23                             ;TMPPER
F2F6 : C0 09      subb  #$09          ;sub B with 09h
F2F8 : BD F1 E4   jsr  LF1E4          ;jump sub NXTSMP
;
F2FB : 20 55      bra  LF352          ;branch always PTORE1
;
;PRET
F2FD : EE 00      ldx  $00,x          ;load X with X+00h
F2FF : 08         inx                 ;incr X
F300 : DF 0A      stx  $0A            ;store X in addr 0A (PCMDPT)
F302 : 96 26      ldaa  $26           ;load A with addr 26 (PSTK+1)
F304 : 8B 03      adda  #$03          ;add A with 03h
F306 : 97 26      staa  $26           ;store A in addr 26 (PSTK+1)
F308 : D6 23      ldab  $23           ;load B with addr 23 (TMPPER)
F30A : C0 07      subb  #$07          ;sub B with 07h
F30C : 01         nop                 ;
F30D : 7E F2 28   jmp  LF228          ;jump PPLPE1
;*************************************;
;* LDV N IS  PERVEL := N,  ADV N IS  PERVEL := PERVEL + N
;* IN THIS CASE  N IS A 12 BIT NUMBER, THE UPPER 4 BITS OF WHICH
;* ARE LO 4 BITS OF THE OPCODE BYTE.
;
;ADVR
F310 : 08         inx                 ;incr X
F311 : 20 04      bra  LF317          ;branch always (*+6)
;
;LDVR
F313 : D7 20      stab  $20           ;store B in addr 20 (PERVEL) CLEAR PERVEL FOR LOAD
F315 : D7 21      stab  $21           ;store B in addr 21 (PERVEL+1)
;
F317 : D6 29      ldab  $29           ;load B with addr 29 (PCMD)
F319 : C4 0F      andb  #$0F          ;and B with 0Fh (#15) SIGN EXTEND
F31B : CB F8      addb  #$F8          ;add B with F8h (#-8)
F31D : C8 F8      eorb  #$F8          ;exclusive or B with F8h (#-8)
; 
F31F : 32         pula                ;SP+1 pull stack into A
F320 : 9B 21      adda  $21           ;add A with addr 21 (PERVEL+1)
F322 : D9 20      adcb  $20           ;add C+B + addr 20 (PERVEL)
F324 : 97 21      staa  $21           ;store A in addr 21 (PERVEL+1)
F326 : D7 20      stab  $20           ;store B in addr 20 (PERVEL)
;
;F328 : F6 00 23    "  #"    ldab  X0023         ;<- disasm error (FCB -10,0,TMPPER)
F328 : F6                             ;-10
F329 : 00                             ;0
F32A : 23                             ;TMPPER
F32B : C0 09      subb  #$09          ;sub B with 09h
F32D : 7E F2 28   jmp  LF228          ;jump PPLPE1
;*************************************;
;* DO R,N  CALLS RTN AT *+N  R TIMES.
;
;PDOR
F330 : 96 26      ldaa  $26           ;load A with addr 26 (PSTK+1)
F332 : 80 03      suba  #$03          ;sub A with 03h
F334 : 97 26      staa  $26           ;store A in addr 26 (PSTK+1)
;
F336 : DE 25      ldx  $25            ;load X with addr 25 (PSTK)
F338 : 96 0B      ldaa  $0B           ;load A with addr 0B (PCMDPT+1) STACK ENTRY TO DISPLACEMENT
F33A : D6 0A      ldab  $0A           ;load B with addr 0A (PCMDPT)
F33C : 8B FF      adda  #$FF          ;add A with FFh (#-1)
F33E : C9 FF      adcb  #$FF          ;add C+B + FFh (#-1)
F340 : E7 00      stab  $00,x         ;store B in addr X+00h
F342 : A7 01      staa  $01,x         ;store A in addr X+01h
F344 : D6 29      ldab  $29           ;load B with addr 29 (PCMD) LO OPCODE BITS ARE REPEAT CNT
F346 : C4 0F      andb  #$0F          ;and B with 0Fh
F348 : E7 02      stab  $02,x         ;store B in addr X+02h
;
F34A : D6 23      ldab  $23           ;load B with addr 23 (TMPPER)
F34C : C0 0C      subb  #$0C          ;sub B with 0Ch
F34E : BD F1 E4   jsr  LF1E4          ;jump sub NXTSMP
;
F351 : 08         inx                 ;incr X
;PTORE1
F352 : 08         inx                 ;incr X
F353 : 08         inx                 ;incr X
F354 : 5F         clrb                ;clear B
F355 : 01         nop                 ;
;
;* TO N  SETS LOC TO BE *+N.
;
;PTOR
F356 : 32         pula                ;SP+1 pull stack into A
F357 : 47         asra                ;arith shift right A
F358 : 49         rola                ;rotate left A
F359 : C2 00      sbcb  #$00          ;sub C+B with 00h
F35B : 9B 0B      adda  $0B           ;add A with addr 0B (PCMDPT+1)
F35D : D9 0A      adcb  $0A           ;add C+B + addr 0A (PCMDPT)
F35F : 97 0B      staa  $0B           ;store A in addr 0B (PCMDPT+1)
;F361 : F7 00 0A    "   "    stab  X000A         ;<- disasm error (FCB -9,0,PCMDPT 41)
F361 : F7                             ;-9
F362 : 00                             ;0
F363 : 0A                             ;PCMDPT
;
F364 : D6 23      ldab  $23           ;load B with addr 23 (TMPPER)
F366 : C0 07      subb  #$07          ;sub B with 07h
F368 : 7E F2 28   jmp  LF228          ;jump PPLPE1
;*************************************;
;jump table
;*************************************;
;PCMDJT FDB - pitch command
F36B : F2 AD                          ;LDPR 0
F36C : F2 C2                          ;LDOR 1
F36F : F3 13                          ;LDVR 2
F371 : F3 10                          ;ADVR 3
F373 : F2 AD                          ;LDPR 4
F374 : F2 D1                          ;ESCR 5
F377 : F3 30                          ;PDOR 6
F379 : F3 56                          ;PTOR 7
;FCMDJT FDB - filter command
F37B : F4 EF                          ;ADHR 0
F37D : F5 78                          ;LDTR 1
F37F : F4 27                          ;ETBR 2
F381 : F5 20                          ;HIDR 3
F383 : F3 A2                          ;FINR 4
F385 : F5 31                          ;ZTBR 5
F387 : F3 CD                          ;FDOR 6
F389 : F4 64                          ;FTOR 7
;
;*************************************;
;SUBTTL	WAVE MODIFICATION
;*************************************;
;* FENDR OVERLAY GETS RETURN ADDR FROM STACK.
;
;FRTURN
F38B : DE 2F      ldx  $2F            ;load X with addr 2F (FSTK)
F38D : EE 03      ldx  $03,x          ;load X with X+03h
F38F : 08         inx                 ;incr X (NEXT INSTR IS AFTER DISPLACEMENT BYTE)
F390 : DF 08      stx  $08            ;store X in addr 08 (FCMDPT)
F392 : BD F4 5E   jsr  LF45E          ;jump sub FCMDNX
F395 : 08         inx                 ;incr X
F396 : 39         rts                 ;return subroutine
;*************************************;
;* REPEAT CALL.
;
;FDOAGN
F397 : EE 00      ldx  $00,x          ;load X with X+00h (PT TO DISPLACEMENT BYTE)
F399 : DF 08      stx  $08            ;store X in addr 08 (FCMDPT)
F39B : CE F4 64   ldx  #$F464         ;load X with F464h (#FTOR) JUMP RTN IS NEXT
F39E : DF 2D      stx  $2D            ;store X in addr 2D (FVECT+1)
F3A0 : 01         nop                 ;
F3A1 : 39         rts                 ;return subroutine
;*************************************;
;* FIN DOES  REPEAT CALL, RETURN TO CALLER, STOP RTN DEPENDING ON STACK.
;
;FINR
F3A2 : 96 30      ldaa  $30           ;load A with addr 30 (FSTK+1)
F3A4 : 81 37      cmpa  #$37          ;compare A with 37h (#FBTM)
F3A6 : 23 12      bls  LF3BA          ;branch C+Z=1 ALLDON (LAST END STATEMENT)
;
F3A8 : DE 2F      ldx  $2F            ;load X with addr 2F (FSTK)
F3AA : 6A 02      dec  $02,x          ;decr addr X+02h(NO, CHECK TOP OF STACK)
F3AC : 2A E9      bpl  LF397          ;branch N=0 FDOAGN (STILL REPEATING)
;
F3AE : 80 03      suba  #$03          ;sub A with 03h
F3B0 : 97 30      staa  $30           ;store A in addr 30 (FSTK+1)
F3B2 : CE F3 8B   ldx  #$F38B         ;load X with F38Bh (#FRTURN) ELSE RETURN
F3B5 : DF 2D      stx  $2D            ;store X in addr 2D (FVECT+1)
F3B7 : 6D 00      tst  $00,x          ;test addr X+00h
F3B9 : 39         rts                 ;return subroutine
;*************************************;
;ALLDON
F3BA : CE F3 C2   ldx  #$F3C2         ;load X with F3C2h (#WAST50)
F3BD : DF 2D      stx  $2D            ;store X in addr 2D (FVECT+1)
F3BF : 01         nop                 ;
F3C0 : 20 05      bra  LF3C7          ;branch always WAST27
;
;WAST50
F3C2 : 08         inx                 ;incr X
F3C3 : 08         inx                 ;incr X
F3C4 : 01         nop                 ;
;WAST40
F3C5 : 8D 05      bsr  LF3CC          ;branch sub WAST5
;WAST27
F3C7 : 8D 03      bsr  LF3CC          ;branch sub WAST5
;WAST14
F3C9 : 6D 00      tst  $00,x          ;test addr X+00h
;WAST7
F3CB : 01         nop                 ;
;WAST5
F3CC : 39         rts                 ;return subroutine
;*************************************;
;* CALL WITH REPEAT. REPEAT CNT 0(=1) TO 15 (=16) IS LO 4 BITS OF OPCODE.
;* NEXT BYTE IS DISPLACEMENT AS IN GO INSTRUCTION.  THE CTR AND RETURN
;* ADDRESS ARE SAVED ON A STACK.
;
;FDOR
F3CD : DE 2F      ldx  $2F            ;load X with addr 2F (FSTK)
F3CF : 96 08      ldaa  $08           ;load A with addr 08 (FCMDPT) SAVE ADDR OF DISPLACEMENT BYTE
F3D1 : A7 03      staa  $03,x         ;store A in addr X+03h
F3D3 : 96 09      ldaa  $09           ;load A with addr 09 (FCMDPT+1)
F3D5 : A7 04      staa  $04,x         ;store A in addr X+04h
F3D7 : 96 39      ldaa  $39           ;load A with addr 39 (FCMD)
F3D9 : 84 0F      anda  #$0F          ;and A with 0Fh 
F3DB : A7 05      staa  $05,x         ;store A in addr X+05h
;
F3DD : 08         inx                 ;incr X
F3DE : CE F3 E4   ldx  #$F3E4         ;load X with F3E4h (#1$)
F3E1 : DF 2D      stx  $2D            ;store X in addr 2D (FVECT+1)
F3E3 : 39         rts                 ;return subroutine 
;*************************************;
;* OVERLAY FOR CALL RTN.
;
;1$
F3E4 : 96 30      ldaa  $30           ;load A with addr 30 (FSTK+1)
F3E6 : 8B 03      adda  #$03          ;add A with 03h
F3E8 : 97 30      staa  $30           ;store A in addr 30 (FSTK+1)
F3EA : CE F4 64   ldx  #$F464         ;load X with F464h (#FTOR)
F3ED : DF 2D      stx  $2D            ;store X in addr 2D (FVECT+1) GET READY TO JUMP
F3EF : 01         nop                 ;
F3F0 : 20 D5      bra  LF3C7          ;branch always WAST27
;*************************************;
;* GET NEXT FILTER COMMAND
;
;NXTFCM
F3F2 : 7D 00 2F   tst  $002F          ;test addr 002F (FCNT)
F3F5 : 26 CE      bne  LF3C5          ;branch Z=0 WAST40 (IN A DELAY)
;
F3F7 : DE 08      ldx  $08            ;load X with addr 08 (FCMDPT)
F3F9 : A6 00      ldaa  $00,x         ;load A with addr X+00h
F3FB : 08         inx                 ;incr X
F3FC : DF 08      stx  $08            ;store X in addr 08 (FCMDPT)
F3FE : 97 39      staa  $39           ;store A in addr 39 (FCMD)
F400 : 2A 05      bpl  LF407          ;branch N=0 1$
;
F402 : 97 2F      staa  $2F           ;store A in addr 2F (FCNT) NEGATIVE CMD IS NEG OF WAVE DELAY
F404 : A6 00      ldaa  $00,x         ;load A with addr X+00h
F406 : 39         rts                 ;return subroutine
;1$:
F407 : CE F4 0E   ldx  #$F40E         ;load X with F40Eh (#EXFCMD) POSITIVE IS FROM TABLE
;F40A : FF 00 2D   stx  X002D          ;<- disasm error (FCB -1,0,FVECT+1)
F40A ; FF                             ;-1
F40B : 00                             ;0
F40C : 2D                             ;FVECT+1
F40D : 39         rts                 ;return subroutine
;*************************************;
;
;EXFCMD
F40E : 5F         clrb                ;clear B 
F40F : 96 39      ldaa  $39           ;load A with addr 39 (FCMD)
F411 : 84 70      anda  #$70          ;and A with 70h (B4 - B7 IS INSTRUCTION)
F413 : 44         lsra                ;logic shift right A
F414 : 44         lsra                ;logic shift right A
F415 : 44         lsra                ;logic shift right A
F416 : 8B 7B      adda  #$7B          ;add A with 7Bh (#FCMDJT!.255)
F418 : C9 F3      adcb  #$F3          ;add C+B + F3h (#FCMDJT/256)
F41A : D7 37      stab  $37           ;store B in addr 37 (FNHI)
F41C : 97 38      staa  $38           ;store A in addr 38 (FNLO)
;
F41E : DE 37      ldx  $37            ;load X with addr 37 (FNHI)
F420 : EE 00      ldx  $00,x          ;load X with addr X+00h
F422 : DF 2D      stx  $2D            ;store X in addr 2D (FVECT+1)
F424 : DF 2D      stx  $2D            ;store X in addr 2D (FVECT+1)
F426 : 39         rts                 ;return subroutine
;*************************************;
;* SET UP FOR REPEATED TABLE ADD.
;
;ETBR
F427 : 96 39      ldaa  $39           ;load A with addr 39 (FCMD)
F429 : 84 0F      anda  #$0F          ;and A with 0Fh 
F42B : 4C         inca                ;incr A
F42C : 4C         inca                ;incr A
F42D : 97 2F      staa  $2F           ;store A in addr 2F (FCNT)
F42F : 20 1D      bra  LF44E          ;branch always FHA1
;*************************************;
;* LOOK FOR A NONZERO HARMONIC CHANGE AND PERFORM IT.  IF ENTIRE TABLE
;* IS ZERO WE HAVE FINISHED THE LAST COMMAND AND PICK UP THE NEXT ONE.
;
;FINDHA
F431 : 7C 00 32   inc  $0032          ;incr addr 0032 (HAPTR+1)
F434 : DE 31      ldx  $31            ;load X with addr 31 (HAPTR)
F436 : 8C 00 68   cpx  #$0068         ;compare X with 0068h (#CNAMP) END TABLE?
F439 : 27 13      beq  LF44E          ;branch Z=1 FHA1
;
F43B : A6 00      ldaa  $00,x         ;load A with X+00h (NO, LOOK AT CURRENT ENTRY)
F43D : CE F4 78   ldx  #$F478         ;load X with F478h (#ADDINI)
F440 : 97 35      staa  $35           ;store A in addr 35 (HAMP)
F442 : 27 03      beq  LF447          ;branch Z=1 (*+5)
F444 : 7E F4 4A   jmp  LF44A          ;jump (*+6)
F447 : CE F4 31   ldx  #$F431         ;load X with F431h (#FINDHA) LOOK AGAIN IF 0
F44A : DF 2D      stx  $2D            ;store X in addr 2D (FVECT+1) SET FOR ADD IF <>0
F44C : 08         inx                 ;incr X
F44D : 39         rts                 ;return subroutine
;*************************************;
;FHA1:
F44E : 86 5E      ldaa  #$5E          ;load A with 5Eh (#ADD2HA-2) RESTART TABLE
;F450 : B7 00 32   staa  X0032         ;<- disasm error (FCB $B7,0,HAPTR+1)
F450 : B7                             ;$B7
F451 : 00                             ;0
F452 : 32                             ;HAPTR+1
F453 : CE F4 31   ldx  #$F431         ;load X with F431h (#FINDHA) MAYBE REPEAT
F456 : 7A 00 2F   dec  $002F          ;decr addr 002F (FCNT)
F459 : 27 03      beq  LF45E          ;branch Z=1 (*+5)
F45B : 7E F4 61   jmp  LF461          ;jump (*+6)
;FCMDNX:
F45E : CE F3 F2   ldx  #$F3F2         ;load X with F3F2h (#NXTFCM)
F461 : DF 2D      stx  $2D            ;store X in addr 2D (FVECT+1)
F463 : 39         rts                 ;return subroutine
;*************************************;
;* RELATIVE JUMP.
;
;FTOR
F464 : DE 08      ldx  $08            ;load X with addr 08 (FCMDPT)
F466 : 5F         clrb                ;clear B 
F467 : A6 00      ldaa  $00,x         ;load A with X+00h
F469 : 4C         inca                ;incr A (DISPLACEMENT IS FROM NEXT INSTRUCTION)
F46A : 47         asra                ;arith shift right A
F46B : 49         rola                ;rotate left A 
F46C : C2 00      sbcb  #$00          ;sub B+C + 00h
F46E : 9B 09      adda  $09           ;add A with addr 09 (FCMDPT+1)
F470 : D9 08      adcb  $08           ;add C+B + addr 08 (FCMDPT)
F472 : 97 09      staa  $09           ;store A in addr 09 (FCMDPT+1)
F474 : D7 08      stab  $08           ;store B in addr 08 (FCMDPT)
;
F476 : 20 E6      bra  LF45E          ;branch always FCMDNX
;*************************************;
;* SET UP FOR ADD OF HAMP * HARMONIC TO WAVE.
;
;ADDINI
F478 : 96 32      ldaa  $32           ;load A with addr 32 (HAPTR+1)
F47A : 80 5F      suba  #$5F          ;sub A with 5Fh (#ADD2HA-1)
F47C : 48         asla                ;arith shift left A
F47D : 5F         clrb                ;clear B
F47E : 9B 0F      adda  $0F           ;add A with 0Fh (HRMTBL+1) GET PTR TO HARMONIC IN FNHI, FNLO
F480 : D9 0E      adcb  $0E           ;add C+B + addr 0E (HRMTBL)
F482 : D7 37      stab  $37           ;store B in addr 37 (FNHI)
F484 : 97 38      staa  $38           ;store A in addr 38 (FNLO)
;
F486 : 86 80      ldaa  #$80          ;load A with 80h (#128)
F488 : 97 36      staa  $36           ;store A in addr 36 (FMSK)
;
F48A : CE F4 95   ldx  #$F495         ;load X with F495h (#2$)
F48D : DF 2D      stx  $2D            ;store X in addr 2D (FVECT+1)
F48F : CE 00 10   ldx  #$0010         ;load X with 0010h (#WAVSRT)
F492 : DF 33      stx  $33            ;store X in addr 33 (FWVPTR)
F494 : 39         rts                 ;return subroutine
;
;2$
F495 : DE 37      ldx  $37            ;load X with addr 37 (FNHI) GET HARMONIC FN TO FNHI,FNLO
F497 : EE 00      ldx  $00,x          ;load X with X+00h
F499 : DF 37      stx  $37            ;store X in addr 37 (FNHI)
F49B : CE F4 AA   ldx  #$F4AA         ;load X with F4AAh (#ADDLP)
F49E : DF 2D      stx  $2D            ;store X in addr 2D (FVECT+1)
;
F4A0 : DE 31      ldx  $31            ;load X with addr 31 (HAPTR)
F4A2 : A6 09      ldaa  $09,x         ;load A with X+09h
F4A4 : 9B 35      adda  $35           ;add A with addr 35 (HAMP)
F4A6 : A7 09      staa  $09,x         ;store A in addr X+09h (RECORD CHANGE)
F4A8 : 08         inx                 ;incr X
F4A9 : 39         rts                 ;return subroutine
;*************************************;
;* ADD HAMP * HARMONIC FN TO WAVEFORM.
;
;ADDLP
F4AA : 96 36      ldaa  $36           ;load A with addr 36 (FMSK) MSK PTS TO CURRENT HARMONIC VALUE
F4AC : 27 1D      beq  LF4CB          ;branch Z=1 1$
;
F4AE : 74 00 36   lsr  $0036          ;logic shift right addr 0036 (FMSK)
F4B1 : DE 33      ldx  $33            ;load X with addr 33 (FWVPTR)
F4B3 : E6 00      ldab  $00,x         ;load B with X+00h
F4B5 : 94 37      anda  $37           ;and A with 37h (FNHI) ADD/SUBTRACT HAMP FROM SAMPLE ON
F4B7 : 26 09      bne  LF4C2          ;branch Z=0 2$ (SIGN OF HARMONIC)
;F4B9 : FB 00 35   addb  X0035         ;<- disasm error (FCB -5,0,HAMP)
F4B9 : FB                             ;-5
F4BA : 00                             ;0
F4BB : 35                             ;HAMP
F4BC : E7 00      stab  $00,x         ;store B in addr X+00h
F4BE : 7C 00 34   inc  $0034          ;incr addr 0034 (FWVPTR+1)
F4C1 : 39         rts                 ;return subroutine
;
;2$:
;F4C2 : F0 00 35   subb  X0035         ;<- disasm error (FCB -16,0,HAMP)
FAC2 : F0                             ;-16
FAC3 : 00                             ;0
FAC4 : 35                             ;HAMP
F4C5 : E7 00      stab  $00,x         ;store B in addr X+00h
F4C7 : 7C 00 34   inc  $0034          ;incr addr 0034 (FWVPTR+1)
F4CA : 39         rts                 ;return subroutine
;
;1$:
F4CB : D6 34      ldab  $34           ;load B with addr 34 (FWVPTR+1)
F4CD : C1 20      cmpb  #$20          ;compare B with 20h (#WAVSRT+16)
F4CF : 27 0B      beq  LF4DC          ;branch Z=1 3$ (DONE)
F4D1 : D6 38      ldab  $38           ;load B with addr 38 (FNLO)
F4D3 : D7 37      stab  $37           ;store B in addr 37 (FNHI) ELSE SET FOR NEXT 8 SAMPLES
F4D5 : C6 80      ldab  #$80          ;load B with 80h (#128)
;F4D7 : F7 00 36   stab  X0036         ;<- disasm error (FCB -9,0,FMSK)
F4D7 : F7                             ;-9
F4D8 : 00                             ;0
F4D9 : 36                             ;FMSK
F4DA : 20 0F      bra  LF4EB          ;branch always 16$
;3$:
F4DC : CE F3 F2   ldx  #$F3F2         ;load X with F3F2h (#NXTFCM) RETURN TO THE RIGHT PLACE
F4DF : D6 2F      ldab  $2F           ;load B with addr 2F (FCNT)
F4E1 : 26 03      bne  LF4E6          ;branch Z=0 (*+5) FCNT <>0 MEANS IN TABLE LOOP
F4E3 : 7E F4 E9   jmp  LF4E9          ;jump (*+6) FCNT =0 MEANS EXECUTING COMMANDS
F4E6 : CE F4 31   ldx  #$F431         ;load X with F431h (#FINDHA)
F4E9 : DF 2D      stx  $2D            ;store X in addr 2D (FVECT+1)
;16$:
F4EB : 6D 00      tst  $00,x          ;test addr X+00h
F4ED : 08         inx                 ;incr X
F4EE : 39         rts                 ;return subroutine
;*************************************;
;* ADH H,N  LDH H,N  USE SAME RTN
;
;ADHR
;LDHR
F4EF : 96 39      ldaa  $39           ;load A with addr 39 (FCMD)
F4F1 : 84 07      anda  #$07          ;and A with 07h (HARMONIC #)
F4F3 : 8B 60      adda  #$60          ;add A with 60h (#ADD2HA)
F4F5 : 97 32      staa  $32           ;store A in addr 32 (HAPTR+1)
;
F4F7 : DE 08      ldx  $08            ;load X with addr 08 (FCMDPT)
F4F9 : A6 00      ldaa  $00,x         ;load A with addr X+00h
F4FB : 08         inx                 ;incr X
F4FC : DF 08      stx  $08            ;store X in addr 08 (FCMDPT)
F4FE : 97 35      staa  $35           ;store A in addr 35 (HAMP) SAVE VALUE
;
F500 : CE F5 07   ldx  #$F507         ;load X with F507h (#1$)
F503 : DF 2D      stx  $2D            ;store X in addr 2D (FVECT+1)
F505 : 08         inx                 ;incr X
F506 : 39         rts                 ;return subroutine
;1$
F507 : DE 31      ldx  $31            ;load X with addr 31 (HAPTR)
F509 : 5F         clrb                ;clear B
F50A : 96 39      ldaa  $39           ;load A with addr 39 (FCMD)
F50C : 8B F8      adda  #$F8          ;add A with F8h (#-8) CARRY IF LD
F50E : C2 00      sbcb  #$00          ;sub C+B + 00h
F510 : E4 09      andb  $09,x         ;and B with X+09h (LD = NEW SUB OLD + ADD NEW)
F512 : 50         negb                ;negate B
F513 : DB 35      addb  $35           ;add B with addr 35 (HAMP)
;ADHRE:
F515 : D7 35      stab  $35           ;store B in addr 35 (HAMP)
F517 : CE F4 78   ldx  #$F478         ;load x with F478h (#ADDINI)
F51A : DF 2D      stx  $2D            ;store X in addr 2D (FVECT+1)
F51C : 08         inx                 ;incr X
F51D : 08         inx                 ;incr X
F51E : 01         nop                 ;
F51F : 39         rts                 ;return subroutine
;*************************************;
;* HARMONIC INCREMENT OR DECREMENT
;
;HIDR
F520 : D6 39      ldab  $39           ;load B with addr 39 (FCMD)
F522 : 54         lsrb                ;logic shoft right B
F523 : C4 07      andb  #$07          ;and B with 07h
F525 : CA 60      orab  #$60          ;or B with 60h (#ADD2HA) ! ADD2HA MUST BE DIVISIBLE BY 8 !
F527 : D7 32      stab  $32           ;store B in addr 32 (HAPTR+1) PT TO THIS HARMONIC
;
F529 : C6 FF      ldab  #$FF          ;load B with FFh (#-1) CARRY IF INCREMENT (BIT 0 OF FCMD = 1)
F52B : C9 00      adcb  #$00          ;add C+B + 00h
F52D : C9 00      adcb  #$00          ;add C+B + 00h
F52F : 20 E4      bra  LF515          ;branch always ADHRE
;*************************************;
;* CLEAR ADD2HA OR ALTER 0TH AMPLITUDE.
;
;ZTBR
F531 : 96 39      ldaa  $39           ;load A with addr 39 (FCMD) LO BIT 0 IF ZT
F533 : 47         asra                ;arith shift right A
F534 : 25 13      bcs  LF549          ;branch C=1 ADCR
;
F536 : CE 00 00   ldx  #$0000         ;load X with 0000h
F539 : DF 60      stx  $60            ;store X in addr 60 (ADD2HA)
F53B : DF 62      stx  $62            ;store X in addr 62 (ADD2HA+2)
F53D : DF 64      stx  $64            ;store X in addr 64 (ADD2HA+4)
F53F : DF 66      stx  $66            ;store X in addr 66 (ADD2HA+6)
F541 : 08         inx                 ;incr X
;ATBRE
F542 : CE F3 F2   ldx  #$F3F2         ;load X with F3F2h (#NXTFCM)
;F545 : FF 00 2D   stx  X002D          ;<- disasm error (FCB -1,0,FVECT+1)
F545 : FF                             ;-1
F546 : 00                             ;0
F547 : 2D                             ;FVECT+1
;ATBRE1
F548 : 39         rts                 ;return subroutine 
;
;ADCR:
F549 : 85 02      bita  #$02          ;bit test A with 02h
F54B : 26 0C      bne  LF559          ;branch Z=0 ESC1 (BIT 2 FCMD =1 FOR ESCAPE)
F54D : C6 5F      ldab  #$5F          ;load B with 5Fh (#ADD2HA-1)
F54F : D7 32      stab  $32           ;store B in addr 32 (HAPTR+1)
F551 : CE F5 5E   ldx  #$F55E         ;load X with F55Eh (#ADCRO)
;ADCRE:
F554 : DF 2D      stx  $2D            ;store X in addr 2D (FVECT+1)
F556 : 7E F3 C9   jmp  LF3C9          ;jump WAST14
;
;ESC1:
;F559 : FE 00 08   ldx  X0008          ;<- disasm error (FCB -2,0,FCMDPT)
F559 : FE                             ;-2
F55A : 00                             ;0
F55B : 08                             ;FCMDPT
F55C : 20 F6      bra  LF554          ;branch always ADCRE
;
;ADCRO
F55E : 5F         clrb                ;clear B
F55F : 96 39      ldaa  $39           ;load A with addr 39 (FCMD)
F561 : 8B AE      adda  #$AE          ;add A with AEh (#-82) CARRY IF LDH
F563 : C2 00      sbcb  #$00          ;sub C+B +00h
F565 : D4 68      andb  $68           ;and B with addr 68 (CNAMP)
F567 : DE 08      ldx  $08            ;load X with addr 08 (FCMDPT)
F569 : A6 00      ldaa  $00,x         ;load A with X+00h
F56B : 08         inx                 ;incr X
F56C : DF 08      stx  $08            ;store X in addr 08 (FCMDPT)
F56E : 10         sba                 ;sub B from A
F56F : 97 35      staa  $35           ;store A in addr 35 (HAMP)
F571 : CE F4 78   ldx  #$F478         ;load X with F478h (#ADDINI)
;F574 : FF 00 2D   stx  X002D          ;<- disasm error (FCB -1,0,FVECT+1)
F574 : FF                             ;-1
F575 : 00                             ;0
F576 : 2D                             ;FVECT+1
F577 : 39         rts                 ;return subroutine
;*************************************;
;* CHANGE SOME ADD2HA ENTRIES.
;
;LDTR
F578 : C6 60      ldab  #$60          ;load B with 60h (#ADD2HA) ASSUME FIRST ENTRY IS H #8
F57A : D7 32      stab  $32           ;store B in addr 32 (HAPTR+1)
F57C : DE 08      ldx  $08            ;load X with addr 08 (FCMDPT)
F57E : E6 00      ldab  $00,x         ;load B with X+00h (EACH BIT INDICATES PRESENCE OF ENTRY)
F580 : D7 37      stab  $37           ;store B in addr 37 (FNHI)
F582 : 08         inx                 ;incr X
F583 : DF 08      stx  $08            ;store X in addr 08 (FCMDPT)
F585 : D6 39      ldab  $39           ;load B with addr 39 (FCMD) LO BIT 1 IF ENTRY FOR 0 IS PRESENT
F587 : 54         lsrb                ;logic shift right B
F588 : 24 18      bcc  LF5A2          ;branch C=0 5$
F58A : CE F5 BC   ldx  #$F5BC         ;load X with F5BCh (#6$)
F58D : DF 2D      stx  $2D            ;store X in addr 2D (FVECT+1)
F58F : 39         rts                 ;return subroutine
;
;4$
F590 : 5F         clrb                ;clear B
F591 : 96 38      ldaa  $38           ;load A with addr 38 (FNLO) LO BIT 0 IF REPLACE, 1 IF ADD TO CURRENT
F593 : 47         asra                ;arith shift left A
F594 : C2 00      sbcb  #$00          ;sub B+C + 00h
F596 : DE 31      ldx  $31            ;load X with addr 31 (HAPTR)
F598 : E4 00      andb  $00,x         ;and B with X+00h
F59A : 1B         aba                 ;add B to A
F59B : A7 00      staa  $00,x         ;store A in addr X+00h
F59D : 7C 00 32   inc  $0032          ;inc addr 0032 (HAPTR+1) PT TO NEXT GUY
F5A0 : A6 00      ldaa  $00,x         ;load A with X+00h
;5$:
F5A2 : CE F5 A8   ldx  #$F5A8         ;load X with F5A8h (#1$)
F5A5 : DF 2D      stx  $2D            ;store X in addr 2D (FVECT+1)
F5A7 : 39         rts                 ;return subroutine
;1$
F5A8 : 78 00 37   asl  $0037          ;arith shift left addr 0037 (FNHI)
F5AB : 25 13      bcs  LF5C0          ;branch C=1 2$
F5AD : 27 06      beq  LF5B5          ;branch Z=1 3$ (NO MORE IF 0)
F5AF : 7C 00 32   inc  $0032          ;incr addr 0032 (HAPTR+1)
F5B2 : 7E F3 C7   jmp  LF3C7          ;jump WAST27
;3$:
F5B5 : BD F4 5E   jsr  LF45E          ;jump sub FCMDNX
F5B8 : 6D 00      tst  $00,x          ;test X+00h
F5BA : 01         nop                 ;
F5BB : 39         rts                 ;return subroutine
;6$:
F5BC : 7A 00 32   dec  $0032          ;decr addr 0032
F5BF : 08         inx                 ;incr X
;2$:
F5C0 : A6 00      ldaa  $00,x         ;load A with X+00h
F5C2 : DE 08      ldx  $08            ;load X with addr 08 (FCMDPT)
F5C4 : A6 00      ldaa  $00,x         ;load A with X+00h
F5C6 : 08         inx                 ;incr X
F5C7 : DF 08      stx  $08            ;store X  in addr 08 (FCMDPT)
F5C9 : 97 38      staa  $38           ;store A in addr 38 (FNLO)
F5CB : CE F5 90   ldx  #$F590         ;load X with F590h (#4$)
F5CE : DF 2D      stx  $2D            ;store X in addr 2D (FVECT+1)
F5D0 : 39         rts                 ;return subroutine
;*************************************;
;SUBTTL SOUND PROGRAMS
;*************************************;
;* OPCODES ( ! SEPERATES NYBBLES  SPACES SEPERATE BYTES)
;
;* COMMON
;* WAIT N -N  ( 1<= N<= 127)
;* DO R,RTN $6!(R-1)  RTN - NEXT LOC
;* TO RTN $70   RTN - NEXT LOC
;* ESC  $55
;
;* FREQUENCY CONTROL
;* STOP          $80
;* LDP N         $01 N
;* ADP N         $00 N
;* LDV N         $2!(N&$F00) N&255
;* ADV N         $3!(N&$F00) N&255
;* LDO N         $11 N
;* ADO N         $10 N

;* WAVE CONTROL
;* FIN           $40
;* ZT            $50
;* ADH 0,N       $51 N
;* LDH 0,N       $53 N
;*        ( IN WHAT FOLLOWS 1<=H<=8  HHH = 8-H, A 3 BIT NUMBER)
;* ADH H,N       $0!0HHH
;* LDH H,N       $0!1HHH
;* IH H          $3!HHH1
;* DH H          $3!HHH0
;* DT R          $2!(R-1)
;* LT A0,...,A8  $1!000C 8765!4321 B0,...,B8
;*               WHERE C=1 IF ENTRY 0 IS ALTERED
;*                     N=1 IF ENTRY N IS ALTERED (N=1,...,8)
;*               BN=AN+AN+P WHERE P=1 IF AN IS TO BE ADDED TO ENTRY N
;*                                P=0 IF AN REPLACES ENTRY N
;*               BN IS PRESENT ONLY IF ENTRY N IS TO BE ALTERED
;
;* HARMONIC FUNCTIONS.  EACH BIT POSITION CORRESPONDS TO A WAVEFORM
;* POSITION.  IF THE BIT = 0, THE VALUE IS +1  IF THE BIT = 1, THE
;* VALUE IS -1.
;
;* THE HARMONICS ARE TREATED IN ORDER OF DECREASING AVERAGE FREQUENCY.
;*************************************;
;ODDTBL
F5D1 : 0000 
F5D3 : 0000 
F5D5 : AAAA 
F5D7 : 0FF0 
F5D9 : C3F0 
F5DB : 18CF 
F5DD : C7A1 
F5DF : FF00 
F5E1 : 00FF 
;*************************************;
;* WAVE PROGRAMS
;*************************************;
; assumptions (also, not possible):
;* DO R,RTN $6!(R-1)  RTN - NEXT LOC
;
;NLIST
;
;LBL0
F5E3 : 53 80 
F5E5 : 08 
F5E6 : 88 0A 
F5E8 : 10 
F5E9 : 09 
F5EA : 08 
F5EB : 0B 
F5EC : 10 
F5ED : 0C 
F5EE : 20 0C 
F5F0 : 05 
;LBL01
F5F1 : 10 80 
F5F3 : F0                             ;(WAIT 16)
F5F4 : 23 10 
F5F6 : 80 10 
F5F8 : 23 
F5F9 : 70 F6                          ;(-10)(TO LBL01)
;
;LBL1
F5FB : 96 2E 
F5FD : 00 EC 
F5FF : 22 00 
F601 : EC 
F602 : 80 20 
F604 : F6 80 
;
;LBL2
F606 : 53 
F607 : 00 
F608 : 0A 
F609 : 05 
F60A : FB 53 80 
F60D : 0A 
;
F60E : 1F 
F60F : 6F 03                          ;(DO 16,?)(-3)(LBL21)
F611 : 6E 01                          ;(DO 15,?)(-1)(LBL3)
F613 : 40 
F614 : 10 
F615 : 60 00                          ;(DO 0, ?)(*+0)
F617 : 02 
F618 : 23 10 
F61A : 40 
F61B : FE 22 10 
F61E : 20 FE 
F620 : 20 
;LBL21
F621 : 40 
;
;LBL3
F622 : 64 6F 
F624 : 03 
F625 : 6F 01 
F627 : 80 21 
F629 : 00 FC 
F62B : 2F 00 
F62D : FC 
F62E : 80                             ;(STOP)
;
;LBL4
F62F : 53 
F630 : 00 
F631 : 09 
F632 : FF FB 6F 
F635 : 03 
F636 : 6E 01 
F638 : 40 
F639 : 10 
F63A : 40 
F63B : FC 
F63C : 20 10 
F63E : 41 00 02 
F641 : 23 10 
F643 : 01 
F644 : FE 23 50 
F647 : 40                             ;(FIN)
;
;LBL5
F648 : 7D CE CE 
F64B : 80                             ;(STOP)
;*************************************;
;WALSHT
F64C : F5 E3                          ;LBL0
F64E : F5 FB                          ;LBL1
F650 : F6 06                          ;LBL2
F652 : F6 22                          ;LBL3
F654 : F6 2F                          ;LBL4
F656 : F6 48                          ;LBL5
F658 : F6 06                          ;LBL2
F65A : F6 48                          ;LBL5
F65C : F6 06                          ;LBL2
F65D : F5 FB                          ;LBL1
;*************************************;
;WALSH
;*************************************;
F660 : 5F         clrb                ;clear B
F661 : D7 0D      stab  $0D           ;store A in addr 0D (SMPPER+1)
F663 : 48         asla                ;arith shift left A
F664 : 48         asla                ;arith shift left A
F665 : 8B 4C      adda  #$4C          ;add A with 4Ch (#WALSHT!.255)
F667 : C9 F6      adcb  #$F6          ;add C+B + F6h (#WALSH/256)
F669 : D7 0A      stab  $0A           ;store B in addr 0A (PCMDPT)
F66B : 97 0B      staa  $0B           ;store A in addr 0B (PCMDPT+1)
F66D : DE 0A      ldx  $0A            ;load X with addr 0A (PCMDPT)
F66F : EE 00      ldx  $00,x          ;load X with X+00h
F671 : DF 08      stx  $08            ;store X in addr 08 (FCMDPT)
F673 : DE 0A      ldx  $0A            ;load X with addr 0A (PCMDPT)
F675 : EE 02      ldx  $02,x          ;load X with X+02h
F677 : E6 00      ldab  $00,x         ;load B with X+00h
F679 : D7 0C      stab  $0C           ;store B in addr 0C (SMPPER)
F67B : 08         inx                 ;incr X
F67C : DF 0A      stx  $0A            ;store X in addr 0A (PCMDPT)
F67E : CE F5 D1   ldx  #$F5D1         ;load X with F5D1h (#ODDTBL)
F681 : DF 0E      stx  $0E            ;store X in addr 0E (HRMTBL)
F683 : 7E F2 07   jmp  LF207          ;jump WSM
;*************************************;
;synth 27
;*************************************;
;SYNTH27
F686 : 16         tab                 ;transfer A to B
F687 : 2E 25      bgt  LF6AE          ;branch Z+(N(+)V)=0 S27AMP
F689 : 58         aslb                ;arith shift left B
F68A : 58         aslb                ;arith shift left B
F68B : 58         aslb                ;arith shift left B
F68C : 58         aslb                ;arith shift left B
F68D : D7 03      stab  $03           ;store B in addr 03
F68F : 16         tab                 ;transfer A to B
F690 : 86 04      ldaa  #$04          ;load A with 04h
F692 : 10         sba                 ;sub B from A
;S27MLP (main loop)
F693 : 36         psha                ;push A into stack then SP-1
F694 : BD F6 C8   jsr  LF6C8          ;jump sub S27ST
F697 : D6 03      ldab  $03           ;load B with addr 03
F699 : CB 30      addb  #$30          ;add B with 30h
F69B : D7 03      stab  $03           ;store B in addr 03
F69D : BD F6 C8   jsr  LF6C8          ;jump sub S27ST
F6A0 : D6 03      ldab  $03           ;load B with addr 03
F6A2 : C0 18      subb  #$18          ;sub B with 18h
F6A4 : D7 03      stab  $03           ;store B in addr 03
F6A6 : BD F6 C8   jsr  LF6C8          ;jump sub S27ST
F6A9 : 32         pula                ;SP+1 pull stack into A
F6AA : 4A         deca                ;decr A
F6AB : 26 E6      bne  LF693          ;branch Z=0 S27MLP
F6AD : 39         rts                 ;return subroutine
;****;
;S27AMP (sound with B value)
F6AE : C6 7F      ldab  #$7F          ;load B with 7Fh
F6B0 : BD F6 CA   jsr  LF6CA          ;jump sub S27OUT1
F6B3 : C6 C0      ldab  #$C0          ;load B with C0h
F6B5 : BD F6 CA   jsr  LF6CA          ;jump sub S27OUT1
F6B8 : C6 FF      ldab  #$FF          ;load B with FFh
F6BA : BD F6 CA   jsr  LF6CA          ;jump sub S27OUT1
F6BD : C6 7F      ldab  #$7F          ;load B with 7Fh
F6BF : BD F6 CA   jsr  LF6CA          ;jump sub S27OUT1
F6C2 : C6 3F      ldab  #$3F          ;load B with 3Fh
F6C4 : BD F6 CA   jsr  LF6CA          ;jump sub S27OUT1
F6C7 : 39         rts                 ;return subroutine
;****;
;S27ST (start)
F6C8 : D6 03      ldab  $03           ;load B with addr 03
;S27OUT1 (output)
F6CA : F7 04 00   stab  $0400         ;store B in DAC output SOUND
F6CD : CE 00 40   ldx  #$0040         ;load X with 0040h
;S27LP1 (div loop)
F6D0 : 8D 19      bsr  LF6EB          ;branch sub SYNDIV
;S27LP2 (SP & B loop)
F6D2 : 36         psha                ;push A into stack then SP-1
F6D3 : C6 03      ldab  #$03          ;load B with 03h
;S27LP3 (div & -B loop)
F6D5 : 8D 14      bsr  LF6EB          ;branch sub SYNDIV
F6D7 : 5A         decb                ;decr B
F6D8 : 26 FB      bne  LF6D5          ;branch Z=0 S27LP3
;end loop 3
F6DA : 32         pula                ;SP+1 pull stack into A
F6DB : 4A         deca                ;decr A
F6DC : 26 F4      bne  LF6D2          ;branch Z=0 S27LP2
;end loop 2
F6DE : 8D 0B      bsr  LF6EB          ;branch sub SYNDIV
F6E0 : 81 7F      cmpa  #$7F          ;compare A with 7Fh
F6E2 : 2E EC      bgt  LF6D0          ;branch Z+(N(+)V)=0 S27LP1
;end loop 1 high
;S27OUT2 (output)
F6E4 : 73 04 00   com  $0400          ;complement 1s DAC output SOUND
F6E7 : 09         dex                 ;decr X
F6E8 : 26 E6      bne  LF6D0          ;branch Z=0 S27LP1
;end loop 1 low
F6EA : 39         rts                 ;return subroutine;
;*************************************;
;synth div A routine
;*************************************;
;SYNDIV
F6EB : 96 02      ldaa  $02           ;load A with addr 02
F6ED : 44         lsra                ;logic shift right A
F6EE : 98 02      eora  $02           ;exclusive or A with addr 02
F6F0 : 44         lsra                ;logic shift right A
F6F1 : 44         lsra                ;logic shift right A
F6F2 : 76 00 01   ror  $0001          ;rotate right addr 0001
F6F5 : 76 00 02   ror  $0002          ;rotate right addr 0002
F6F8 : 39         rts                 ;return subroutine
;*************************************;
;synth 28 - stacker #1 called by NMI
;*************************************;
;SYNTH28
F6F9 : 4F         clra                ;clear A
F6FA : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F6FD : CE 00 7F   ldx  #$007F         ;load X with 7Fh
;S28MLP (main loop)
F700 : DF 0C      stx  $0C            ;store X in addr 0C
F702 : 96 0D      ldaa  $0D           ;load A with addr 0D (#127)
;S28LP1 (stacker loop 1)
F704 : 4A         deca                ;decr A
F705 : 36         psha                ;push A into stack then SP-1
F706 : 32         pula                ;SP+1 pull stack into A
F707 : 36         psha                ;push A into stack then SP-1
F708 : 32         pula                ;SP+1 pull stack into A
F709 : 36         psha                ;push A into stack then SP-1
F70A : 32         pula                ;SP+1 pull stack into A
F70B : 26 F7      bne  LF704          ;branch Z=0 S28LP1
;end loop 1
F70D : 73 04 00   com  $0400          ;complement 1s DAC output SOUND
F710 : 96 0D      ldaa  $0D           ;load A with addr 0D (#127)
;S28LP2 (stacker loop 2)
F712 : 4A         deca                ;decr A
F713 : 36         psha                ;push A into stack then SP-1
F714 : 32         pula                ;SP+1 pull stack into A
F715 : 36         psha                ;push A into stack then SP-1
F716 : 32         pula                ;SP+1 pull stack into A
F717 : 36         psha                ;push A into stack then SP-1
F718 : 32         pula                ;SP+1 pull stack into A
F719 : 26 F7      bne  LF712          ;branch Z=0 S28LP2
;end loop 2
F71B : 73 04 00   com  $0400          ;complement 1s DAC output SOUND
F71E : 8D CB      bsr  LF6EB          ;branch sub SYNDIV
F720 : 16         tab                 ;transfer A to B
;S28BL1 (dec B loop 1)
F721 : 5A         decb                ;decr B
F722 : 26 FD      bne  LF721          ;branch Z=0 S28BL1
;end B loop 1
F724 : 73 04 00   com  $0400          ;complement 1s DAC output SOUND
F727 : 16         tab                 ;trnasfer A to B
;S28BL2 (dec B loop 2)
F728 : 5A         decb                ;decr B
F729 : 26 FD      bne  LF728          ;branch Z=0 S28BL2
;end B loop 2
F72B : 73 04 00   com  $0400          ;complement 1s DAC output SOUND
F72E : 7C 04 00   inc  $0400          ;incr DAC output SOUND
F731 : 09         dex                 ;decr X
F732 : 26 CC      bne  LF700          ;branch Z=0 S28MLP
;end main loop
F734 : 39         rts                 ;return subroutine
;*************************************;
;synth 29 - stacker #2
;*************************************;
;SYNTH29
F735 : 4F         clra                ;clear A
F736 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F739 : CE 00 01   ldx  #$0001         ;load X with 0001
;S29MLP (main loop)
F73C : DF 0C      stx  $0C            ;store X in addr 0C
F73E : 96 0D      ldaa  $0D           ;load A with addr 0D (#01)
;S29LP1 (stacker loop 1)
F740 : 4A         deca                ;decr A
F741 : 36         psha                ;push A into stack then SP-1 (4 cycles)
F742 : 32         pula                ;SP+1 pull stack into A (4 cycles)
F743 : 36         psha                ;push A into stack then SP-1
F744 : 32         pula                ;SP+1 pull stack into A
F745 : 36         psha                ;push A into stack then SP-1
F746 : 32         pula                ;SP+1 pull stack into A
F747 : 26 F7      bne  LF740          ;branch Z=0 S29LP1
;end loop 1
F749 : 73 04 00   com  $0400          ;complement 1s DAC output SOUND
F74C : 96 0D      ldaa  $0D           ;load A with addr 0D (#01)
;S29LP2 (stacker loop 2)
F74E : 4A         deca                ;decr A
F74F : 36         psha                ;push A into stack then SP-1
F750 : 32         pula                ;SP+1 pull stack into A
F751 : 36         psha                ;push A into stack then SP-1
F752 : 32         pula                ;SP+1 pull stack into A
F753 : 36         psha                ;push A into stack then SP-1
F754 : 32         pula                ;SP+1 pull stack into A
F755 : 26 F7      bne  LF74E          ;branch Z=0 S29LP2
;end loop 2
F757 : 73 04 00   com  $0400          ;complement 1s DAC output SOUND
F75A : 8D 8F      bsr  LF6EB          ;branch sub SYNDIV
;S29LB1 (load B loop 1)
F75C : C6 20      ldab  #$20          ;load B with 20h (#32)
;S29BL1 (dec B loop 1)
F75E : 5A         decb                ;decr B
F75F : 26 FD      bne  LF75E          ;branch Z=0 S29BL1
;end B loop 1
F761 : 4A         deca                ;decr A
F762 : 26 F8      bne  LF75C          ;branch Z=0 S29LB1
;end load B loop 1
F764 : 73 04 00   com  $0400          ;complement 1s DAC output SOUND
F767 : 8D 82      bsr  LF6EB          ;branch sub SYNDIV
;S29LB2 (load B loop 2)
F769 : C6 20      ldab  #$20          ;load B with 20h (#32)
;S29BL2 (dec B loop 2)
F76B : 5A         decb                ;decr B 
F76C : 26 FD      bne  LF76B          ;branch Z=0 S29BL2
;end B loop 2
F76E : 4A         deca                ;decr A
F76F : 26 F8      bne  LF769          ;branch Z=0 S29LB2
;end load B loop 2
F771 : 73 04 00   com  $0400          ;complement 1s DAC output SOUND
F774 : 7C 04 00   inc  $0400          ;incr DAC output SOUND
F777 : 08         inx                 ;incr X
F778 : 8C 00 10   cpx  #$0010         ;compare X with 0010h
F77B : 26 BF      bne  LF73C          ;branch Z=0 S29MLP
;end main loop
F77D : 39         rts                 ;return subroutine
;*************************************;
;set memory addrs 03,04,05 (bg flags??)
;*************************************;
;MEM345
F77E : 7F 00 03   clr  $0003          ;clear addr 0003
F781 : 58         aslb                ;arith shift left B
F782 : 58         aslb                ;arith shift left B
F783 : 58         aslb                ;arith shift left B
F784 : D7 05      stab  $05           ;store B in addr 05
F786 : 86 01      ldaa  #$01          ;load A with 01h
F788 : 97 04      staa  $04           ;store A in addr 04
F78A : 39         rts                 ;return subroutine
;*************************************;
;synth30
;*************************************;
;SYNTH30
F78B : 86 60      ldaa  #$60          ;load A with 60h (#96)
F78D : B7 04 00   staa  $0400         ;store A in DAC output SOUND
;S30LP1 (main loop 1)
F790 : 96 05      ldaa  $05           ;load A with addr 05 (value set ?)
;S30A11 (inner loop 1 A1)
F792 : C6 13      ldab  #$13          ;load B with 13h (#19)
;S30B11 (inner loop 1 B1)
F794 : 5A         decb                ;decr B
F795 : 26 FD      bne  LF794          ;branch Z=0 S30L1B
;end inner loop 1 B1
F797 : 4A         deca                ;decr A
F798 : 26 F8      bne  LF792          ;branch Z=0 S30L1A
;end inner loop 1 A1
;
F79A : 73 04 00   com  $0400          ;complement 1s DAC output SOUND
F79D : 96 05      ldaa  $05           ;load A with addr 05
;S30A12 (inner loop 1 A2)
F79F : C6 13      ldab  #$13          ;load B with 13h (#19)
;S30B12 (inner loop 1 B2)
F7A1 : 5A         decb                ;decr B
F7A2 : 26 FD      bne  LF7A1          ;branch Z=0 S30B12
;end inner loop 1 B2
F7A4 : 4A         deca                ;decr A
F7A5 : 26 F8      bne  LF79F          ;branch Z=0 S30A12
;end inner loop 1 A2
;
F7A7 : 73 04 00   com  $0400          ;complement 1s DAC output SOUND
F7AA : 7C 04 00   inc  $0400          ;incr DAC output SOUND
F7AD : 86 7F      ldaa  #$7F          ;load A with 7Fh (#127)
F7AF : B1 04 00   cmpa  $0400         ;compare A with DAC
F7B2 : 26 DC      bne  LF790          ;branch Z=0 S30LP1
;end main loop 1
;S30LP2 (main loop 2)
F7B4 : 96 05      ldaa  $05           ;load A with addr 05
;S30A21 (inner loop 2 A1)
F7B6 : C6 13      ldab  #$13          ;load B with 13h (#19)
;S30B21 (inner loop 2 B1)
F7B8 : 5A         decb                ;decr B
F7B9 : 26 FD      bne  LF7B8          ;branch Z=0
;end inner loop 2 B1
F7BB : 4A         deca                ;decr A
F7BC : 26 F8      bne  LF7B6          ;branch Z=0
;end inner loop 2 A1
;
F7BE : 73 04 00   com  $0400          ;complement 1s DAC output SOUND
F7C1 : 96 05      ldaa  $05           ;load A with addr 05
;S30A22 (inner loop 2 A2)
F7C3 : C6 13      ldab  #$13          ;load B with 13h (#19)
;S30B22 (inner loop 2 B2)
F7C5 : 5A         decb                ;decr B
F7C6 : 26 FD      bne  LF7C5          ;branch Z=0
;end inner loop 2 B2
F7C8 : 4A         deca                ;decr A
F7C9 : 26 F8      bne  LF7C3          ;branch Z=0
;end inner loop 2 A2
;
F7CB : 73 04 00   com  $0400          ;complement 1s DAC output SOUND
F7CE : 7A 04 00   dec  $0400          ;decr DAC output SOUND
F7D1 : 86 60      ldaa  #$60          ;load A with 60h (#96)
F7D3 : B1 04 00   cmpa  $0400         ;compare A with DAC
F7D6 : 26 DC      bne  LF7B4          ;branch Z=0 S30LP2
;end main loop 2
F7D8 : 20 B6      bra  LF790          ;branch always S30MLP (repeat)
;*************************************;
;GWAVE Loader 
;*************************************;
;GWLD:
F7DA : 16         tab                 ;transfer A to B (MULKT BY 7)(sound select x7)
F7DB : 58         aslb                ;arith shift left B 
F7DC : 1B         aba                 ;add B to A
F7DD : 1B         aba                 ;add B to A
F7DE : 1B         aba                 ;add B to A
F7DF : CE F9 BB   ldx  #$F9BB         ;load X with F9BBh (SVTAB)(SOUND VECTOR TABLE)
F7E2 : BD F1 A7   jsr  LF1A7          ;jump sub ADDX
F7E5 : A6 00      ldaa  $00,x         ;load A with X+00h
F7E7 : 16         tab                 ;transfer A to B
F7E8 : 84 0F      anda  #$0F          ;and A with 0Fh
F7EA : 97 0F      staa  $0F           ;store A in addr 0F (GCCNT)(GET CYCLE COUNT)
F7EC : 54         lsrb                ;logic shift right B  
F7ED : 54         lsrb                ;logic shift right B  
F7EE : 54         lsrb                ;logic shift right B  
F7EF : 54         lsrb                ;logic shift right B  
F7F0 : D7 0E      stab  $0E           ;store B in addr 0E (GECHO)(GET #ECHOS)
F7F2 : A6 01      ldaa  $01,x         ;load A with X+01h
F7F4 : 16         tab                 ;transfer A to B
F7F5 : 54         lsrb                ;logic shift right B  
F7F6 : 54         lsrb                ;logic shift right B  
F7F7 : 54         lsrb                ;logic shift right B  
F7F8 : 54         lsrb                ;logic shift right B  
F7F9 : D7 10      stab  $10           ;store B in addr 10 (GECDEC)
F7FB : 84 0F      anda  #$0F          ;and A with 0Fh (WAVE #)
F7FD : 97 0C      staa  $0C           ;store A in addr 0C (TEMPA)(SAVE)
F7FF : DF 06      stx  $06            ;store X in addr 06 (TEMPX)(SAVE INDEX)
F801 : CE F9 0C   ldx  #$F90C         ;load X with F90Ch (GWVTAB)(CALC WAVEFORM ADDR)
;GWLD2:
F804 : 7A 00 0C   dec  $000C          ;decr value in addr 000C (TEMPA)(WAVE FROM #)
F807 : 2B 08      bmi  LF811          ;branch N=1 GWLD3(FINIS)
F809 : A6 00      ldaa  $00,x         ;load A with  X+00h
F80B : 4C         inca                ;incr A
F80C : BD F1 A7   jsr  LF1A7          ;jump sub ADDX
F80F : 20 F3      bra  LF804          ;branch always GWLD2
;GWLD3:
F811 : DF 13      stx  $13            ;store X in addr 13 (GWFRM)
F813 : BD F8 CB   jsr  LF8CB          ;jump sub WVTRAN(XSFER WAVE TO RAM)
F816 : DE 06      ldx  $06            ;load X with addr 06 (TEMPX)(RESTORE INDEX)
F818 : A6 02      ldaa  $02,x         ;load A with X+02h (GET PREDECAY)
F81A : 97 15      staa  $15           ;store A in addr 15 (PRDECA)
F81C : BD F8 DD   jsr  LF8DD          ;jump sub WVDECA (DECAY IT)
F81F : DE 06      ldx  $06            ;load X with addr 06 (TEMPX)
F821 : A6 03      ldaa  $03,x         ;load A with X+03h (GET FREQ INC)
F823 : 97 11      staa  $11           ;store A in addr 11 (GDFINC)
F825 : A6 04      ldaa  $04,x         ;load A with X+04h (GET DELTA FREQ COUNT)
F827 : 97 12      staa  $12           ;store A in addr 12 (GDCNT)
F829 : A6 05      ldaa  $05,x         ;load A with X+05h (GET PATTERN COUNT)
F82B : 16         tab                 ;transfer A to B (SAVE)
F82C : A6 06      ldaa  $06,x         ;load A with X+06h (PATTERN OFFSET)
F82E : CE FA 24   ldx  #$FA24         ;load X with FA24h (#GFRTAB)
F831 : BD F1 A7   jsr  LF1A7          ;jump sub ADDX
F834 : 17         tba                 ;transfer B to A (GET PATTERN LENGTH)
F835 : DF 16      stx  $16            ;store X in addr 16 (GWFRQ)(FREQ TABLE ADDR)
F837 : 7F 00 1E   clr  $001E          ;clear addr 001F (FOFSET)
F83A : BD F1 A7   jsr  LF1A7          ;jump sub ADDX
F83D : DF 18      stx  $18            ;store X in addr 0019 (FRQEND)
F83F : 39         rts                 ;return subroutine
;*************************************;
;GWAVE routine 
;*************************************;
;ACCA=Freq Pattern Length, X=Freq Pattern Addr
;GWAVE
F840 : 96 0E      ldaa  $0E           ;load A with addr 0E (GECHO)
F842 : 97 1D      staa  $1D           ;store A in addr 1D (GECNT)
;GWT4
F844 : DE 16      ldx  $16            ;load X with addr 16 (GWFRQ)
F846 : DF 08      stx  $08            ;store X in addr 08 (XPLAY)
;GPLAY:
F848 : DE 08      ldx  $08            ;load X with addr 08 (XPLAY)(GET NEW PERIOD)
F84A : A6 00      ldaa  $00,x         ;load A with X+00h
F84C : 9B 1E      adda  $1E           ;add A with addr 1E (FOFSET)
F84E : 97 1C      staa  $1C           ;store A in addr 1C (GPER)
F850 : 9C 18      cpx  $18            ;compare X with addr 18 (FRQEND)
F852 : 27 27      beq  LF87B          ;branch Z=1 GEND(FINISH ON ZERO)
F854 : D6 0F      ldab  $0F           ;load B with addr 0F (GCCNT)(CYCLE COUNT)
F856 : 08         inx                 ;incr X
F857 : DF 08      stx  $08            ;store X in addr 08 (XPLAY)
;GOUT:
F859 : CE 00 20   ldx  #$0020         ;load X with value 0020h (#GWTAB)(SETUP WAVEFORM POINTER)
;GOUTLP:
F85C : 96 1C      ldaa  $1C           ;load A with addr 1C (GPER)
;GPRLP:
F85E : 4A         deca                ;decr A (WAIT FOR PERIOD)
F85F : 26 FD      bne  LF85E          ;branch Z=0 GPRLP
F861 : A6 00      ldaa  $00,x         ;load A with X+00h (OUTPUT SOUND)
F863 : 44         lsra                ;logic shift right A ( <- not in typical GWave)
F864 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
;GPR1
F867 : 08         inx                 ;incr X
F868 : 9C 1A      cpx  $1A            ;compare X with addr 1A (WVEND)(END OF WAVE?)
F86A : 26 F0      bne  LF85C          ;branch Z=0 GOUTLP
F86C : 5A         decb                ;decr B
F86D : 27 D9      beq  LF848          ;branch Z=1 GPLAY
F86F : 08         inx                 ;incr X (4 cycles)
F870 : 09         dex                 ;decr X (4 cycles)
F871 : 08         inx                 ;incr X (4 cycles)
F872 : 09         dex                 ;decr X (4 cycles)
F873 : 08         inx                 ;incr X (4 cycles)
F874 : 09         dex                 ;decr X (4 cycles)
F875 : 08         inx                 ;incr X (4 cycles)
F876 : 09         dex                 ;decr X (4 cycles)
F877 : 01         nop                 ;(2 cycles)
F878 : 01         nop                 ;(2 cycles, 36 total)
F879 : 20 DE      bra  LF859          ;branch always GOUT(SYNC 36)
;GEND
F87B : 96 10      ldaa  $10           ;load A with addr 10 (GECDEC)
F87D : 8D 5E      bsr  LF8DD          ;branch sub WVDECA
;GEND40
F87F : 7A 00 1D   dec  $001D          ;decr addr 001D (GECNT)(ECHO ON?)
F882 : 26 C0      bne  LF844          ;branch Z=0 GWT4(YES)
;no B2FLG STOP BONUS in this ROM
;GEND50:
F884 : 96 11      ldaa  $11           ;load A with addr 12 (GDFINC)(CONTINUE FOR FREQ MOD SOUNDS)
F886 : 27 42      beq  LF8CA          ;branch Z=1 GEND1(NO)
F888 : 7A 00 12   dec  $0012          ;decr addr 0012 (GDCNT)(DELTA FREQ OVER?)
F88B : 27 3D      beq  LF8CA          ;branch Z=1 GEND1 (YES...)
F88D : 9B 1E      adda  $1E           ;add A with addr 1E (FOFSET)(UPDATE FREQ OFFSET)
;GEND60:
F88F : 97 1E      staa  $1E           ;store A in addr 1E (FOFSET)
;GEND61:
F891 : DE 16      ldx  $16            ;load X with addr 16 (GWFRQ)(GET INDEX)
F893 : 5F         clrb                ;clear B (START FOUND FLAG INIT CLEAR)
;GW0:
F894 : 96 1E      ldaa  $1E           ;load A with addr 1E (FOFSET)(INC OR DEC?)
F896 : 7D 00 11   tst  $0011          ;test addr 0011 (GDFINC)
F899 : 2B 06      bmi  LF8A1          ;branch N=1 GW1 (DEC)
F89B : AB 00      adda  $00,x         ;add A with X+00h (INC)
F89D : 25 08      bcs  LF8A7          ;branch C=1 GW2 (CARRY=OVERFLOW)
F89F : 20 0B      bra  LF8AC          ;branch always  GW2A
;GW1
F8A1 : AB 00      adda  $00,x         ;add A with X+00h (DEC)
F8A3 : 27 02      beq  LF8A7          ;branch Z=1 GW2 (OVERFLOW ON EQ)
F8A5 : 25 05      bcs  LF8AC          ;branch C=1 GW2A (OVERFLOW IF CARRY CLEAR)
;GW2:
F8A7 : 5D         tstb                ;test B (FOUND START YET?)
F8A8 : 27 08      beq  LF8B2          ;branch Z=1 GW2B (NO)
F8AA : 20 0F      bra  LF8BB          ;branch always GW3 (YES, THIS IS THE END)
;GW2A
F8AC : 5D         tstb                ;test B 
F8AD : 26 03      bne  LF8B2          ;branch Z=0 GW2B (ALREADY FOUND START)
F8AF : DF 16      stx  $16            ;store X in addr 16 (GWFRQ)(FOUND START)
F8B1 : 5C         incb                ;incr B
;GW2B:
F8B2 : 08         inx                 ;incr X
F8B3 : 9C 18      cpx  $18            ;compare X with addr 18 (FRQEND)
F8B5 : 26 DD      bne  LF894          ;branch Z=0 GW0 (NOT OVER YET)
F8B7 : 5D         tstb                ;test B (FOUND START?)
F8B8 : 26 01      bne  LF8BB          ;branch Z=0 GW3 (YES)
F8BA : 39         rts                 ;return subroutine (ALL OVER)
;GW3
F8BB : DF 18      stx  $18            ;store X in addr 18 (FRQEND)
F8BD : 96 10      ldaa  $10           ;load A with addr 10 (GECDEC)(RE:XSFER WAVE?)
F8BF : 27 06      beq  LF8C7          ;branch Z=1 GEND0 (NO)
F8C1 : 8D 08      bsr  LF8CB          ;branch sub WVTRAN (XSFER WAVE)
F8C3 : 96 15      ldaa  $15           ;load A with addr 15 (PRDECA)
F8C5 : 8D 16      bsr  LF8DD          ;branch sub WVDECA
;GEND0:
F8C7 : 7E F8 40   jmp  LF840          ;jump GWAVE
;GEND1
F8CA : 39         rts                 ;return subroutine (TERMINATE)
;*************************************;
;Wave Transfer Routine 
;*************************************;
;WVTRAN
F8CB : CE 00 20   ldx  #$0020         ;load X with 0020h (#GWTAB)
F8CE : DF 0A      stx  $0A            ;store X in addr 0A (XPTR)
F8D0 : DE 13      ldx  $13            ;load X with addr 13 (GWFRM)
F8D2 : E6 00      ldab  $00,x         ;load B with X+00h (GET WAVE LENGTH)
F8D4 : 08         inx                 ;incr X
F8D5 : BD FA 9A   jsr  LFA9A          ;jump sub TRANS
F8D8 : DE 0A      ldx  $0A            ;load X with addr 0A (XPTR)
F8DA : DF 1A      stx  $1A            ;store X in addr 1A (WVEND)(GET END ADDR)
F8DC : 39         rts                 ;return subroutine
;*************************************;
;Wave Decay Routinue 
;*************************************;
;decay amount in ACCA 1/16 per decay
;WVDECA
F8DD : 4D         tsta                ;test A
F8DE : 27 2B      beq  LF90B          ;branch Z=1 WVDCX (NODECAY)
F8E0 : DE 13      ldx  $13            ;load X with addr 13 (GWFRM)(ROM WAVE INDEX)
F8E2 : DF 08      stx  $08            ;store X in addr 08 (XPLAY)
F8E4 : CE 00 20   ldx  #$0020         ;load X with 0020h (#GWTAB)
F8E7 : 97 0D      staa  $0D           ;store A in addr 0D (TEMPB)(DECAY FACTOR)
;WVDLP:
F8E9 : DF 0A      stx  $0A            ;store X in addr 0A (XPTR)
F8EB : DE 08      ldx  $08            ;load X with addr 08 (XPLAY)
F8ED : D6 0D      ldab  $0D           ;load B with addr 0D (TEMPB)
F8EF : D7 0C      stab  $0C           ;store B in addr 0C (TEMPA)(DECAY FACTOR TEMP)
F8F1 : E6 01      ldab  $01,x         ;load B with X+00h (OFFSET FOR WAVE LENGTH)
F8F3 : 54         lsrb                ;logic shift right B 
F8F4 : 54         lsrb                ;logic shift right B
F8F5 : 54         lsrb                ;logic shift right B
F8F6 : 54         lsrb                ;logic shift right B (CALC 1/16TH)
F8F7 : 08         inx                 ;incr X
F8F8 : DF 08      stx  $08            ;store X in addr 08 (XPLAY)
F8FA : DE 0A      ldx  $0A            ;load X with addr 0A (XPTR)
F8FC : A6 00      ldaa  $00,x         ;load A with X+00h
;WVDLP1:
F8FE : 10         sba                 ;sub B from A (DECAY)
F8FF : 7A 00 0C   dec  $000C          ;decr addr 000C (TEMPA)
F902 : 26 FA      bne  LF8FE          ;branch Z=0 WVDLP1
F904 : A7 00      staa  $00,x         ;store A in addr X+00h
F906 : 08         inx                 ;incr X
F907 : 9C 1A      cpx  $1A            ;compare X with addr 1A (WVEND)(END OF WAVE?)
F909 : 26 DE      bne  LF8E9          ;branch Z=0 WVDLP (WVDLP)(NO)
;WVDCX:
F90B : 39         rts                 ;return subroutine
;*************************************;
;GWave table, 1st byte wavelength
;*************************************;
;GWVTAB
F90C : 08                             ;GS2
F90D : 7F D9 FF D9 7F 24 00 24        ;
;
F915 : 08                             ;GSSQR2
F916 : 00 40 80 00 FF 00 80 40        ;
;
F91E : 10                             ;GS1
F91F : 7F B0 D9 F5 FF F5 D9 B0        ;
F927 : 7F 4E 24 09 00 09 24 4E        ;
;
F92F : 1C                             ;(28)
F930 : 80 40 29 1B 10 09 06 04        ;
F938 : 07 0C 12 1E 30 49 A4 C9        ;
F940 : DF EB F6 FB FF FF FB F5        ;
F948 : EA DD C7 9B                    ;
;
F94C : 10                             ;GSQ22
F94D : FF FF FF FF 00 00 00 00        ;
F955 : FF FF FF FF 00 00 00 00        ;
;
F95D : 48                             ;GS72
F95E : 8A 95 A0 AB B5 BF C8 D1        ;
F966 : DA E1 E8 EE F3 F7 FB FD        ;
F96E : FE FF FE FD FB F7 F3 EE        ;
F976 : E8 E1 DA D1 C8 BF B5 AB        ;
F97E : A0 95 8A 7F 75 6A 5F 54        ;
F986 : 4A 40 37 2E 25 1E 17 11        ;
F98E : 0C 08 04 02 01 00 01 02        ;
F996 : 04 08 0C 11 17 1E 25 2E        ;
F99E : 37 40 4A 54 5F 6A 75 7F        ;
;
F9A6 : 0C                             ;(12)
F9A7 : 00 50 60 B0 20 20 F0 90        ;
F9AF : 80 C0 50 70                    ;

F9B3 : 07                             ;(7)
F9B4 : 40 09 35 0C 29 0F 20           ;
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
F9BB : 71 23 09 00 00 1E 00           ;(30)
F9C2 : 74 00 09 00 00 1A 1E           ;(26)
F9C9 : 74 12 09 00 00 0A 38           ;(10)BBSND
F9D0 : 11 06 06 02 20 03 42           ;(3)
F9D7 : 11 04 0B 01 20 04 42           ;(4)
F9DE : 12 03 09 00 00 04 46           ;(4)
F9E5 : 12 03 09 00 00 04 4A           ;(4)
F9EC : 16 00 09 00 00 16 4E           ;(28)
F9F3 : 11 05 11 01 0F 01 38           ;(1)
F9FA : 1F 12 09 FF 05 04 64           ;(4)
FA01 : F1 07 09 00 00 0E 68           ;(14)
FA08 : 68 20 00 02 26 03 04           ;(3)
FA0F : 08 47 0B 40 01 02 03           ;(2)
FA16 : 88 F3 90 13 B7 04 00           ;(4)
FA1D : 18 11 09 00 00 14 40           ;(20)
;*************************************;
;GWAVE FREQ PATTERN TABLE
;*************************************; 
;GFRTAB
FA24 : 28 01 02                       ;(30)
FA27 : 26 03 04                       ;
FA2A : 24 05 06                       ;
FA2D : 22 07 08                       ;
FA30 : 20 09 0A                       ;
FA33 : 1E 0B 0C                       ;
FA36 : 1C 0D 0E                       ;
FA39 : 1A 0F 10                       ;
FA3C : 18 11 12                       ;
FA3F : 16 13 14                       ;
;(1Eh)
FA42 : 40 01 3E 03 3C 05 3A 07        ;(26)
FA4A : 38 09 35 0C 32 0F 2F 12        ;
FA52 : 2C 15 28 19 24 1D 20 21        ;
FA5A : 20 21                          ;
;*
;SWPAT - SWEEP PATTERN
;*
;BigBen Sounds
FA5C : 08 40 08 40 08 40 08 40        ;BBSND (half)
FA64 : 08 40                          ;
;(42h)
FA66 : 01 02 03 04                    ;
;(46h)
FA6A : 20 18 20 01                    ;
;(4Ah)
FA6E : 01 30 28 30                    ;
;(4Eh)
FA72 : 1E 02 1B 04 23 07 1D 01        ;(22)
FA7A : 22 03 19 09 1F 06 1A 05        ;
FA82 : 1C 0B 21 08 20 0A              ;
;;Spinner Sound "Drip"(64h)
FA88 : 40                             ;SPNR
;Cool Downer
FA89 : 10 08 01                       ;COOLDN 
;(68h)
FA8C : 08 80 10 78 18 70 20 60        ;(14)
FA94 : 28 58 30 50 40 48              ;
;*************************************;
;Parameter Transfer 
;*************************************;
;TRANS
FA9A : 36         psha                ;push A into stack then SP-1
;TRANS1
FA9B : A6 00      ldaa  $00,x         ;load A with X+00h
FA9D : DF 08      stx  $08            ;store X in addr 08 (XPLAY)
FA9F : DE 0A      ldx  $0A            ;load X with addr 0A (XPTR)
FAA1 : A7 00      staa  $00,x         ;store A in addr X+00h
FAA3 : 08         inx                 ;incr X
FAA4 : DF 0A      stx  $0A            ;store X in addr 0A (XPTR)
FAA6 : DE 08      ldx  $08            ;load X with addr 08 (XPLAY)
FAA8 : 08         inx                 ;incr X
FAA9 : 5A         decb                ;decr B
FAAA : 26 EF      bne  LFA9B          ;branch Z=0 TRANS1
FAAC : 32         pula                ;SP+1 pull stack into A
FAAD : 39         rts                 ;return subroutine
;*************************************;
;liten parameter loader - no call?
;*************************************;
;LFAAE
FAAE : 48         asla                ;arith shift left A
FAAF : 48         asla                ;arith shift left A
FAB0 : 48         asla                ;arith shift left A
FAB1 : 48         asla                ;arith shift left A
FAB2 : 80 03      suba  #$03          ;sub A with 03h
FAB4 : 97 15      staa  $15           ;store A in addr 15 (DFREQ)
;Lightning
FAB6 : C6 03      ldab  #$03          ;load B with 03h
FAB8 : 97 14      staa  $14           ;store A in addr 14 (LFREQ)
FABA : 86 01      ldaa  #$01          ;load A with 01h
;*************************************;
;Lightning+Appear Noise Routine 
;*************************************;
;LITEN:
FABC : 97 1F      staa  $1F           ;store A in addr 1F (LFREQ)
FABE : 86 FF      ldaa  #$FF          ;load A with FFh (HIGHEST AMP)
FAC0 : 90 15      suba  $15           ;sub A with addr 15 (DFREQ)
FAC2 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
FAC5 : D7 10      stab  $10           ;store B in addr 10 (CYCNT)
;LITE0:
FAC7 : D6 10      ldab  $10           ;load B with addr 10 (CYCNT)
;LITE1:
FAC9 : 96 02      ldaa  $02           ;load A with addr 02 (LO) (GET RANDOM)
FACB : 44         lsra                ;logic shift right A
FACC : 44         lsra                ;logic shift right A
FACD : 44         lsra                ;logic shift right A
FACE : 98 02      eora  $02           ;exclusive or A with addr 02 (LO)
FAD0 : 44         lsra                ;logic shift right A
FAD1 : 76 00 01   ror  $0001          ;rotate right addr 0001 (HI)
FAD4 : 76 00 02   ror  $0002          ;rotate right dadr 0002 (LO)
FAD7 : 24 07      bcc  LFAE0          ;branch C=0 LITE2
FAD9 : B6 04 00   ldaa  $0400         ;load A with addr 0400 DAC
FADC : 43         coma                ;complement 1s A
FADD : B7 04 00   staa  $0400         ;store A in DAC output SOUND
;LITE2:
FAE0 : 96 14      ldaa  $14           ;load A with addr 14 (LFREQ)(COUNT FREQ)
;LITE3:
FAE2 : 4A         deca                ;decr A
FAE3 : 26 FD      bne  LFAE2          ;branch Z=0 LITE3
FAE5 : 5A         decb                ;decr B (COUNT CYCLES)
FAE6 : 26 E1      bne  LFAC9          ;branch Z=0 LITE1
FAE8 : 96 14      ldaa  $14           ;load A with addr 14 (LFREQ)
FAEA : 9B 15      adda  $15           ;add A with addr 15 (DFREQ)
FAEC : 97 14      staa  $14           ;store A in addr 14 (LFREQ)
;LFAEE:
FAEE : 26 D7      bne  LFAC7          ;branch Z=0 LITE0
FAF0 : 39         rts                 ;return subroutine
;*************************************;
;Hyper 
;*************************************;
;HYPER
FAF1 : 4F         clra                ;clear A
FAF2 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
FAF5 : 97 0C      staa  $0C           ;store A in addr 0C (TEMPA)(ZERO PHASE)
;HYPER1:
FAF7 : 4F         clra                ;clear A (ZERO TIME COUNTER)
;HYPER2:
FAF8 : 91 0C      cmpa  $0C           ;compare A with addr 0C (TEMPA)
FAFA : 26 03      bne  LFAFF          ;branch Z=0 HYPER3
FAFC : 73 04 00   com  $0400          ;complement 1s DAC output SOUND (PHASE EDGE?)
;HYPER3:
FAFF : C6 12      ldab  #$12          ;load B with 12h (DELAY)
;HYPER4:
FB01 : 5A         decb                ;decr B
FB02 : 26 FD      bne  LFB01          ;branch Z=0 HYPER4
FB04 : 4C         inca                ;incr A (ADVANCE TIME COUNTER)
FB05 : 2A F1      bpl  LFAF8          ;branch N=0 HYPER2
FB07 : 73 04 00   com  $0400          ;complement 1s DAC output SOUND (CYCLE DONE?, CYCLE EDGE)
FB0A : 7C 00 0C   inc  $000C          ;incr addr 000C (TEMPA)(NEXT PHASE)
FB0D : 2A E8      bpl  LFAF7          ;branch N=0 HYPER1 (DONE?)
FB0F : 39         rts                 ;return subroutine
;*************************************;
;Cannon 
;*************************************;
;CANNON
FB10 : 86 01      ldaa  #$01          ;load A with 01h
FB12 : 97 14      staa  $14           ;store A in addr 14 (DSFLAG)
FB14 : CE 03 E8   ldx  #$03E8         ;load X with 03E8h (#1000)
FB17 : 86 01      ldaa  #$01          ;load A with 01h
FB19 : C6 FF      ldab  #$FF          ;load B with FFh
FB1B : 20 1A      bra  LFB37          ;branch always FNOISE
;*************************************;
;Thrust variant
;*************************************;
;THRUST
FB1D : 86 00      ldaa  #$00          ;load A with 00h
FB1F : 97 14      staa  $14           ;store A in addr 14 (DSFLAG)
FB21 : CE 00 80   ldx  #$0080         ;load X with 0080h (#128)
FB24 : 86 01      ldaa  #$01          ;load A with 01h
FB26 : C6 C0      ldab  #$C0          ;load B with C0h
FB28 : 20 0D      bra  LFB37          ;branch always FNOISE
;*************************************;
;Cannon x4 (1337) - same vars except X counter 
;*************************************;
;C4NNON
FB2A : 86 01      ldaa  #$01          ;load A with 01h
FB2C : 97 14      staa  $14           ;store A in addr 14 (DSFLAG)
FB2E : CE 0F A0   ldx  #$0FA0         ;load X with 0FA0h (#4000)
FB31 : 86 01      ldaa  #$01          ;load A with 01h
FB33 : C6 FF      ldab  #$FF          ;load B with FFh
FB35 : 20 00      bra  LFB37          ;branch always FNOISE
;*************************************;
;Filtered Noise Routine 
;*************************************;
;*X=SAMPLE COUNT, ACCB=INITIAL MAX FREQ
;*ACCA=FREQ DECAY FLAG ,DSFLG=DISTORTION FLAG
;FNOISE
FB37 : 97 13      staa  $13           ;store A in addr 13 (FDFLG)
FB39 : D7 0E      stab  $0E           ;store B in addr 0E (FMAX)
FB3B : DF 11      stx  $11            ;store X in addr 11 (SAMPC)
FB3D : 7F 00 10   clr  $0010          ;clear addr 0010 (FLO)
;FNOIS0:
FB40 : DE 11      ldx  $11            ;load X with addr 11 (SAMPC)
FB42 : B6 04 00   ldaa  $0400         ;load A with addr 0400 DAC
;FNOIS1:
FB45 : 16         tab                 ;transfer A to B (NEXT RANDOM NUMBER)
FB46 : 54         lsrb                ;logic shift right B
FB47 : 54         lsrb                ;logic shift right B
FB48 : 54         lsrb                ;logic shift right B
FB49 : D8 02      eorb  $02           ;exclusive or B with addr 02 (LO)
FB4B : 54         lsrb                ;logic shift right B
FB4C : 76 00 01   ror  $0001          ;rotate right addr 0001 (HI)
FB4F : 76 00 02   ror  $0002          ;rotate right addr 0002 (LO)
FB52 : D6 0E      ldab  $0E           ;load B with addr 0E (FMAX)(SET FREQ)
FB54 : 7D 00 14   tst  $0014          ;test addr 0014 (DSFLG)
FB57 : 27 02      beq  LFB5B          ;branch Z=1 FNOIS2
FB59 : D4 01      andb  $01           ;and B with addr 01 (HI)(DISTORT FREQ)
;FNOIS2:
FB5B : D7 0F      stab  $0F           ;store B in addr 0F (FHI)
FB5D : D6 10      ldab  $10           ;load B with addr 10 FLO)
FB5F : 91 02      cmpa  $02           ;compare A with addr 02 (LO)
FB61 : 22 12      bhi  LFB75          ;branch C+Z=0 FNOIS4
;FNOIS3:
FB63 : 09         dex                 ;decr X (SLOPE UP)
FB64 : 27 26      beq  LFB8C          ;branch Z=1 FNOIS6
FB66 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
FB69 : DB 10      addb  $10           ;add B with addr 10 (FLO)
FB6B : 99 0F      adca  $0F           ;add C+A + addr 0F (FHI)
FB6D : 25 16      bcs  LFB85          ;branch C=1 FNOIS5
FB6F : 91 02      cmpa  $02           ;compare A with addr 02 (LO)
FB71 : 23 F0      bls  LFB63          ;branch C+Z=1 FNOIS3
FB73 : 20 10      bra  LFB85          ;branch always FNOIS5
;FNOIS4:
FB75 : 09         dex                 ;decr X (SLOPE DOWN)
FB76 : 27 14      beq  LFB8C          ;branch Z=1 FNOIS6
FB78 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
FB7B : D0 10      subb  $10           ;sub B with addr 10 (FLO)
FB7D : 92 0F      sbca  $0F           ;sub C+A with addr 0F (FHI)
FB7F : 25 04      bcs  LFB85          ;branch C=1 FNOIS5
FB81 : 91 02      cmpa  $02           ;compare A with addr 02 (LO)
FB83 : 22 F0      bhi  LFB75          ;branch C+Z=1 FNOIS4
;FNOIS5:
FB85 : 96 02      ldaa  $02           ;load A with addr 02 (LO)
FB87 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
FB8A : 20 B9      bra  LFB45          ;branch always FNOIS1
;FNOIS6:
FB8C : D6 13      ldab  $13           ;load B with addr 13 (FDFLG)
FB8E : 27 B5      beq  LFB45          ;branch Z=1 FNOIS1
FB90 : 96 0E      ldaa  $0E           ;load A with addr 0E (FMAX)(DECAY MAX FREQ)
FB92 : D6 10      ldab  $10           ;load B with addr 10 (FLO)
FB94 : 44         lsra                ;logic shift right A
FB95 : 56         rorb                ;rotate right B
FB96 : 44         lsra                ;logic shift right A
FB97 : 56         rorb                ;rotate right B
FB98 : 44         lsra                ;logic shift right A
FB99 : 56         rorb                ;rotate right B
FB9A : 43         coma                ;complement 1s A
FB9B : 50         negb                ;negate B (complement 2s)
FB9C : 82 FF      sbca  #$FF          ;sub C+A with FFh (#-1)
FB9E : DB 10      addb  $10           ;add B with addr 10 (FLO)
FBA0 : 99 0E      adca  $0E           ;add C+A + addr 0E (FMAX)
FBA2 : D7 10      stab  $10           ;store B in addr 10 (FLO)
FBA4 : 97 0E      staa  $0E           ;store A in addr 0E (FMAX)
FBA6 : 26 98      bne  LFB40          ;branch Z=0 FNOIS0
FBA8 : C1 07      cmpb  #$07          ;compare B with 07h
FBAA : 26 94      bne  LFB40          ;branch Z=0 FNOIS0
FBAC : 39         rts                 ;return subroutine
;*************************************;
;Single Oscillator Calling Routine Siren
;*************************************;
;SIREN
FBAD : C6 FF      ldab  #$FF          ;load B with FFh
FBAF : D7 18      stab  $18           ;store B in addr 18
;SIREN1
FBB1 : CE FB C6   ldx  #$FBC6         ;load X with FBC6h (VEC03X)
FBB4 : 8D 09      bsr  LFBBF          ;branch sub JMPSNG
FBB6 : CE FB CC   ldx  #$FBCC         ;load X with FBCCh (VEC04X)
FBB9 : 8D 04      bsr  LFBBF          ;branch sub JMPSNG
FBBB : 5A         decb                ;decr B
FBBC : 26 F3      bne  LFBB1          ;branch Z=0 
FBBE : 39         rts                 ;return subroutine
;*************************************;
;jump to Move and Sing
;*************************************;
;JMPSNG
FBBF : BD FB D2   jsr  LFBD2          ;jump sub MOVE
FBC2 : BD FB EB   jsr  LFBEB          ;jump sub SING
FBC5 : 39         rts                 ;return subroutine
;*************************************;
; data tables for SING (Single Osc)
;*************************************;
FBC6 : 20 03 FF 50 FF 00              ;VEC03X
FBCC : 50 03 01 20 FF 00              ;VEC04X
;*************************************;
;* MOVE PARAMETERS
;*************************************;
;MOVE:
FBD2 : A6 00      ldaa  $00,x         ;load A with X+00h
FBD4 : 97 0F      staa  $0F           ;store A in addr 0F
FBD6 : A6 01      ldaa  $01,x         ;load A with X+01h
FBD8 : 97 10      staa  $10           ;store A in addr 10
FBDA : A6 02      ldaa  $02,x         ;load A with X+02h
FBDC : 97 11      staa  $11           ;store A in addr 11
FBDE : A6 03      ldaa  $03,x         ;load A with X+03h
FBE0 : 97 12      staa  $12           ;store A in addr 12
FBE2 : A6 04      ldaa  $04,x         ;load A with X+04h
FBE4 : 97 13      staa  $13           ;store A in addr 13
FBE6 : A6 05      ldaa  $05,x         ;load A with X+05h
FBE8 : 97 14      staa  $14           ;store A in addr 14
FBEA : 39         rts                 ;return subroutine
;*************************************;
;* DELTA F, DELTA A ROUTINE, Single Oscillator Routine
;*************************************;
;SING:
FBEB : 96 18      ldaa  $18           ;load A with addr 18 (AMP0) (GET STARTING AMPLITUDE)
;SING$
FBED : 37         pshb                ;push B into stack then SP-1(SAVE B)
FBEE : D6 13      ldab  $13           ;load B with addr 13 (C$AMP)(GET CYCLES AT AMPLITUDE)
FBF0 : D7 15      stab  $15           ;store B in addr 15 (C$AMP$)(SAVE AS COUNTER)
FBF2 : D6 10      ldab  $10           ;load B with addr 10 (C$FRQ)(GET CYCLES AT FREQUENCY)
FBF4 : D7 16      stab  $16           ;store B in addr 16 (C$FRQ$)(SAVE AS COUNTER)
;SING1:
FBF6 : 43         coma                ;complement 1s A (INVERT AMPLITUDE)
FBF7 : D6 0F      ldab  $0F           ;load B with addr 0F (FREQ$)(GET FREQUENCY COUNTER)
FBF9 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
;SING2:
FBFC : 5A         decb                ;decr B
FBFD : 26 FD      bne  LFBFC          ;branch Z=0 SING2
FBFF : 43         coma                ;complement 1s A (INVERT AMPLITUDE)
FC00 : D6 0F      ldab  $0F           ;load B with addr 0F (FREQ$)(GET FREQUENCY COUNTER)
FC02 : 20 00      bra  LFC04          ;branch always (*+2)(-I)
FC04 : 08         inx                 ;incr X (-I)
FC05 : 09         dex                 ;decr X (-I---)(SYNC, 20 CYCLES)
FC06 : 08         inx                 ;incr X (-I)
FC07 : 09         dex                 ;decr X (-I)
FC08 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
;SING3:
FC0B : 5A         decb                ;decr B
FC0C : 26 FD      bne  LFC0B          ;branch Z=0 SING3
FC0E : 7A 00 16   dec  $0016          ;decr addr 0016 (C$FRQ$) (CHECK CYCLES AT FREQUENCY)
FC11 : 27 16      beq  LFC29          ;branch Z=1 SING4 (GO CHANGE FREQUENCY)
FC13 : 7A 00 15   dec  $0015          ;decr addr 0015 (C$AMP$)(CHECK CYCLES AT AMPLITUDE)
FC16 : 26 DE      bne  LFBF6          ;branch Z=0 SING1 (ALL OK, GO OUTPUT)
FC18 : 43         coma                ;complement 1s A (INVERT AMPLITUDE)
FC19 : D6 13      ldab  $13           ;load B with addr 13 (C$AMP)(GET CYCLES AT AMPLITUDE)
FC1B : B7 04 00   staa  $0400         ;store A in DAC output SOUND
FC1E : D7 15      stab  $15           ;store B in addr 15 (C$AMP$)(SAVE AS COUNTER)
FC20 : D6 0F      ldab  $0F           ;load B with addr 0F (FREQ$)(GET FREQUENCY COUNT)
FC22 : 9B 14      adda  $14           ;add A with addr 14 (D$AMP)(ADD AMPLITUDE DELTA)
FC24 : 2B 1E      bmi  LFC44          ;branch N=1 SING6 (RETURN FROM SUBROUTINE)
FC26 : 01         nop                 ;(SYNC, 2 CYCLES)
FC27 : 20 15      bra  LFC3E          ;branch always SING5
;SING4:
FC29 : 08         inx                 ;incr X (-I)
FC2A : 09         dex                 ;decr X (-I---)(SYNC, 10 CYCLES)
FC2B : 01         nop                 ;(-I)
FC2C : 43         coma                ;complement 1s A (INVERT AMPLITUDE)
FC2D : D6 10      ldab  $10           ;load B with addr 10 (C$FRQ)(GET CYCLES AT FREQUENCY)
FC2F : B7 04 00   staa  $0400         ;store A in DAC output SOUND
FC32 : D7 16      stab  $16           ;store B in addr 16 (C$FRQ$)(SAVE AS COUNTER)
FC34 : D6 0F      ldab  $0F           ;load B with addr 0F (FREQ$)(GET FREQUENCY COUNT)
FC36 : D0 11      subb  $11           ;sub B with addr 11  (D$FRQ)(SUBTRACT FREQUENCY DELTA)
FC38 : D1 12      cmpb  $12           ;compare B with addr 12 (E$FRQ)(COMPARE TO END FREQUENCY)
FC3A : D1 12      cmpb  $12           ;compare B with addr 12 (E$FRQ) SYNC, 3 CYCLES
FC3C : 27 06      beq  LFC44          ;branch Z=1 SING6 (RETURN FROM SUBROUTINE)
;SING5:
FC3E : D7 0F      stab  $0F           ;store B in addr 0F (FREQ$)(SAVE FREQUENCY COUNT)
FC40 : C0 05      subb  #$05          ;sub B with 05h (SYNC TO FREQUENCY COUNTDOWN)
FC42 : 20 B8      bra  LFBFC          ;branch always SING2 (JUMP INTO COUNTDOWN LOOP)
;SING6:
FC44 : 33         pulb                ;SP+1 pull stack into B (RESTORE B)
FC45 : 39         rts                 ;return subroutine
;*************************************;
;zero padding
FC46 : 00 00 00 00 00 00 00 00 
FC4E : 00 00 00 00 00 00 00 00 
FC56 : 00 00 00 00 00 00 00 00 
FC5E : 00 00 00 00 00 00 00 00 
FC66 : 00 00 00 00 00 00 00 00 
FC6E : 00 00 00 00 00 00 00 00 
FC76 : 00 00 00 00 00 00 00 00 
FC7E : 00 00 00 00 00 00 00 00 
FC86 : 00 00 00 00 00 00 00 00 
FC8E : 00 00 00 00 00 00 00 00 
FC96 : 00 00 00 00 00 00 00 00 
FC9E : 00 00 00 00 00 00 00 00 
FCA6 : 00 00 00 00 00 00 00 00 
FCAE : 00 00 00 00 00 00 00 00 
FCB6 : 00 00 00 00 00 00 00 00 
FCBE : 00 00 00 00 00 00 00 00 
FCC6 : 00 00 00 00 00 00 00 00 
FCCE : 00 00 00 00 00 00 00 00 
FCD6 : 00 00 00 00 00 00 00 00 
FCDE : 00 00 00 00 00 00 00 00 
FCE6 : 00 00 00 00 00 00 00 00 
FCEE : 00 00 00 00 00 00 00 00 
FCF6 : 00 00 00 00 00 00 00 00 
FCFE : 00 00 00 00 00 00 00 00 
FD06 : 00 00 00 00 00 00 00 00 
FD0E : 00 00 00 00 00 00 00 00 
FD16 : 00 00 00 00 00 00 00 00 
FD1E : 00 00 00 00 00 00 00 00 
FD26 : 00 00 00 00 00 00 00 00 
FD2E : 00 00 00 00 00 00 00 00 
FD36 : 00 00 00 00 00 00 00 00 
FD3E : 00 00 00 00 00 00 00 00 
FD46 : 00 00 00 00 00 00 00 00 
FD4E : 00 00 00 00 00 00 00 00 
FD56 : 00 00 00 00 00 00 00 00 
FD5E : 00 00 00 00 00 00 00 00 
FD66 : 00 00 00 00 00 00 00 00 
FD6E : 00 00 00 00 00 00 00 00 
FD76 : 00 00 00 00 00 00 00 00 
FD7E : 00 00 00 00 00 00 00 00 
FD86 : 00 00 00 00 00 00 00 00 
FD8E : 00 00 00 00 00 00 00 00 
FD96 : 00 00 00 00 00 00 00 00 
FD9E : 00 00 00 00 00 00 00 00 
FDA6 : 00 00 00 00 00 00 00 00 
FDAE : 00 00 00 00 00 00 00 00 
FDB6 : 00 00 00 00 00 00 00 00 
FDBE : 00 00 00 00 00 00 00 00 
FDC6 : 00 00 00 00 00 00 00 00 
FDCE : 00 00 00 00 00 00 00 00 
FDD6 : 00 00 00 00 00 00 00 00 
FDDE : 00 00 00 00 00 00 00 00 
FDE6 : 00 00 00 00 00 00 00 00 
FDEE : 00 00 00 00 00 00 00 00 
FDF6 : 00 00 00 00 00 00 00 00 
FDFE : 00 00 00 00 00 00 00 00 
FE06 : 00 00 00 00 00 00 00 00 
FE0E : 00 00 00 00 00 00 00 00 
FE16 : 00 00 00 00 00 00 00 00 
FE1E : 00 00 00 00 00 00 00 00 
FE26 : 00 00 00 00 00 00 00 00 
FE2E : 00 00 00 00 00 00 00 00 
FE36 : 00 00 00 00 00 00 00 00 
FE3E : 00 00 00 00 00 00 00 00 
FE46 : 00 00 00 00 00 00 00 00 
FE4E : 00 00 00 00 00 00 00 00 
FE56 : 00 00 00 00 00 00 00 00 
FE5E : 00 00 00 00 00 00 00 00 
FE66 : 00 00 00 00 00 00 00 00 
FE6E : 00 00 00 00 00 00 00 00 
FE76 : 00 00 00 00 00 00 00 00 
FE7E : 00 00 00 00 00 00 00 00 
FE86 : 00 00 00 00 00 00 00 00 
FE8E : 00 00 00 00 00 00 00 00 
FE96 : 00 00 00 00 00 00 00 00 
FE9E : 00 00 00 00 00 00 00 00 
FEA6 : 00 00 00 00 00 00 00 00 
FEAE : 00 00 00 00 00 00 00 00 
FEB6 : 00 00 00 00 00 00 00 00 
FEBE : 00 00 00 00 00 00 00 00 
FEC6 : 00 00 00 00 00 00 00 00 
FECE : 00 00 00 00 00 00 00 00 
FED6 : 00 00 00 00 00 00 00 00 
FEDE : 00 00 00 00 00 00 00 00 
FEE6 : 00 00 00 00 00 00 00 00 
FEEE : 00 00 00 00 00 00 00 00 
FEF6 : 00 00 00 00 00 00 00 00 
FEFE : 00 00 00 00 00 00 00 00 
FF06 : 00 00 00 00 00 00 00 00 
FF0E : 00 00 00 00 00 00 00 00 
FF16 : 00 00 00 00 00 00 00 00 
FF1E : 00 00 00 00 00 00 00 00 
FF26 : 00 00 00 00 00 00 00 00 
FF2E : 00 00 00 00 00 00 00 00 
FF36 : 00 00 00 00 00 00 00 00 
FF3E : 00 00 00 00 00 00 00 00 
FF46 : 00 00 00 00 00 00 00 00 
FF4E : 00 00 00 00 00 00 00 00 
FF56 : 00 00 00 00 00 00 00 00 
FF5E : 00 00 00 00 00 00 00 00 
FF66 : 00 00 00 00 00 00 00 00 
FF6E : 00 00 00 00 00 00 00 00 
FF76 : 00 00 00 00 00 00 00 00 
FF7E : 00 00 00 00 00 00 00 00 
FF86 : 00 00 00 00 00 00 00 00 
FF8E : 00 00 00 00 00 00 00 00 
FF96 : 00 00 00 00 00 00 00 00 
FF9E : 00 00 00 00 00 00 00 00 
FFA6 : 00 00 00 00 00 00 00 00 
FFAE : 00 00 00 00 00 00 00 00 
FFB6 : 00 00 00 00 00 00 00 00 
FFBE : 00 00 00 00 00 00 00 00 
FFC6 : 00 00 00 00 00 00 00 00 
FFCE : 00 00 00 00 00 00 00 00 
FFD6 : 00 00 00 00 00 00 00 00 
FFDE : 00 00 00 00 00 00 00 00 
FFE6 : 00 00 00 00 00 00 00 00 
FFEE : 00 00 00 00 00 
;*************************************;
;Speech ROM4 jump sub destination
;*************************************;
;ROMJMP
FFF3 : 7E F1 A7   jmp  LF1A7          ;jump ADDX
;
FFF6 : 0000                           ;FDB null
;*************************************;
;Motorola vector table
;*************************************;
FFF8 : F0 C1                          ;IRQ 
FFFA : F0 01                          ;RESET SWI (software) 
FFFC : F1 B6                          ;NMI 
FFFE : F0 01                          ;RESET (hardware) 

;--------------------------------------------------------------









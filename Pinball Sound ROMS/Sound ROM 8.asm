        ;
        ;  Disassembled by:
        ;    DASMx object code disassembler
        ;    (c) Copyright 1996-2003   Conquest Consultants
        ;    Version 1.40 (Oct 18 2003)
        ;
        ;  File:    Hyperball.532
        ;
        ;  Size:    4096 bytes
        ;  Checksum:  25A8
        ;  CRC-32:    06051E5E
        ;
        ;  Date:    Thu Apr 08 11:34:42 2021
        ;
        ;  CPU:    Motorola 6800 (6800/6802/6808 family)
        ;
        ; Sound ROM 8 Hyperball (Flipperless) 1981
        ;
        ; updated 17 May 2021
        ;
org  $F000
        ;
F000 : E8                             ;CHKSUM
;*************************************;
; NMI
;*************************************; 
F001 : CE F0 01   ldx #$F001          ;load X with F001h (NMI)
F004 : 4F         clra                ;clear A
;NMI1
F005 : A9 00      adca  $00,x         ;add C + A and X+00h
F007 : 08         inx                 ;incr X
F008 : 26 FB      bne  LF005          ;branch Z=0 NMI1
F00A : B0 F0 00   suba  $F000         ;sub A with addr F000 (ROM)
;NMI2
F00D : 26 FE      bne  LF00D          ;branch Z=0 NMI2
F00F : 8E 00 7F   lds  #$007F         ;load stack pointer with 007Fh (ENDRAM)
F012 : 8D 10      bsr  LF024          ;branch sub RST1
;NMI3
F014 : 86 06      ldaa  #$06          ;load A with 06h
F016 : BD F4 72   jsr  LF472          ;jump sub IRQ2
F019 : 20 F9      bra  LF014          ;branch always NMI3
;*************************************;
; RESET
;*************************************;
F01B : 0F         sei                 ;set interrupt mask  
F01C : 8E 00 7F   lds  #$007F         ;load stack pointer with 007Fh
F01F : 8D 03      bsr  LF024          ;branch sub RST1
F021 : 0E         cli                 ;clear interrupt I=0
;STDBY
F022 : 20 FE      bra  LF022          ;branch always STDBY
;RST1
F024 : CE 04 00   ldx #$0400          ;load X with 0400h PIA addr
F027 : 6F 01      clr $01,x           ;clear X + 01h (0401) PIA CR port A
F029 : 6F 03      clr $03,x           ;clear X + 03h (0403) PIA CR port B
F02B : 86 FF      ldaa  #$FF          ;load A with FFh
F02D : A7 00      staa  $00,x         ;store A in addr X + 00h (0400) PIA port A out (DAC sound)
F02F : C6 80      ldab  #$80          ;load B with 80h
F031 : E7 02      stab  $02,x         ;store B in addr X + 00h (0402) PIA port B in (sound select)
F033 : 86 37      ldaa  #$37          ;load A with 37h 
F035 : A7 03      staa  $03,x         ;store A in addr X + 03h (0403) PIA CR port B
F037 : 86 3C      ldaa  #$3C          ;load A with 3Ch
F039 : A7 01      staa  $01,x         ;store A in addr X + 01h (0401) PIA1 CR port A
F03B : 97 02      staa  $02           ;store A in addr 02
F03D : E7 02      stab  $02,x         ;store B in addr X + 02h (0402) PIA1 CR port A
F03F : 5F         clrb                ;clear B
F040 : D7 00      staa  $00           ;store A in addr 00
F042 : D7 01      staa  $01           ;store A in addr 01
F044 : 39         rts                 ;return subroutine
;*************************************;
;Radio Sound Waveform
;*************************************;
F045 : 8C 5B B6 40 BF 49 A4 73        ;RADSND
F04D : 73 A4 49 BF 40 B6 5B 8C 
;*************************************;
;
;* NAM WALSH FUNCTION SOUND MACHINE V2
;* T. MURPHY  11/10/81
;
;* FILTER TIMING
;* COMMAND      # OF FILTER CALLS TO EXECUTE
;  |-------|   |----------------------------------|
;* LDH, ADH     24
;* LDT, ADT     3+(2*N)  (N = # OF ENTRIES ALTERED)
;* ZT           3
;* DT  R        3+(R*{ 9+(22*NZH)})  WHERE
;*              R IS # OF TABLE REPEATS
;*              NZH IS # OF NONZERO ADD2HA ENTRIES
;* IH, DH       23
;* FIN          4  ( SAME FOR REPEAT AND RETURN)
;* DO           5
;* TO           3
;* WAIT N       1+ (N* WAVE PERIOD)
;
;NLIST
;* MACROS FOR PITCH AND FILTER COMMANDS MAKE DULL READING.
; see below disasm for tables
;
;*************************************;
;SUBTTL Wave Player and Pitch Modification 
;*************************************;
;
;ORG WORG
;
; SUBTTL WAVE PLAYER AND PITCH MODIFICATION
;
;* PLAY A SAMPLE, REMAINING DELAY IN B.  TOTAL DELAY = MIN (60,B*6) MICS.
;NTHRVC LF055
F055 : C0 0D      subb $0D            ;#13 (LOOP DELAY IS 78 CYCLES)
F057 : 37         pshb                ;push B into stack then SP-1
F058 : BD 00 2C   jsr  L002C          ;jump sub $002C mem (FVECT(62))
F05B : 33         pulb                ;SP+1 pull stack into B
;NXTSMP SYN11 LF05C:
F05C : C1 14      cmpb  #$14          ;(CALL HERE)
F05E : 22 F5      bhi  LF055          ;(NTHRVC)(MODIFY WAVE IF WE HAVE ENOUGH TIME) branch C=0 and Z=0 SYNTH1
F060 : 01         nop                 ;
F061 : 96 24      ldaa  $24           ;(PERACM)
F063 : 9B 21      adda  $21           ;(PERVEL+1)
F065 : 97 24      staa  $24           ;(PERACM)
F067 : C9 F6      adcb  #$F6          ;(#-10)(MINIMUM DELAY + FRACTION)
;SYN12 LF069:
F069 : 5A         decb                ;(WASTE SMALL TIME)
F06A : 2A FD      bpl  LF069          ;(*-1)branch N=0 SYN12
F06C : 96 28      ldaa  $28           ;(PWAVEPT+1)(PT TP NEXT BYTE OF 16 BYTE WAVE)
F06E : 4C         inca                ;
F06F : 84 0F      anda  #$0F          ;(#15)
F071 : 8A 10      oraa  #$10          ;(#WAVSRT)(! WAVSRT MUST BE DIVISIBLE BY 16 !)
F073 : 97 28      staa  $28           ;(PWAVPT+1)
F075 : DE 27      ldx  $27            ;(PWAVPT)
F077 : E6 00      ldab  $00,x         ;
F079 : F7 04 00   $0400               ;store B in DAC output SOUND
F07C : 84 0F      anda  #$0F          ;(#15)(0 IFF RESTARTING WAVE)
F07E : 39         rts                 ;return subroutine
;
; Walsh Machine
;* PLAYS WAVE AND ALTERS PITCH ACCORDING TO PITCH CMDS.
;* SMPPER IS INITIAL PITCH,  PCMDPT IS START PITCH PROGRAM,
;* FCMDPT IS START WAVE MODIFIER (FILTER) PROGRAM.
;
;WSM
F07F : 4F         clra                ;
F080 : CE 00 10   ldx  #$0010         ;(#WAVSRT)
F083 : C6 61      ldab  #$61          ;(#CURHA+8-WAVSRT)
;1$ 
F085 : A7 00      staa  $00,x         ;
F087 : 08         inx                 ;
F088 : 5A         decb                ;
F089 : 26 FA      bne  LF085          ;(1$) branch Z=0 
F08B : C6 5F      ldab  #$5F          ;(#PBTM)
F08D : D7 26      stab  $26           ;(PSTK+1)
F08F : C6 37      ldab  #$37          ;(#FBTM)
F091 : D7 30      stab  $30           ;(FSTK+1)
F093 : C6 7E      ldab  #$7E          ;(#126)
F095 : D7 2C      stab  $2C           ;(FVECT)
F097 : CE F2 6A   ldx  #$F26A         ;(#NXTFCM)load X with value F26Ah
F09A : DF 2D      stx  $2D            ;(FVECT+1)
F09C : D6 0C      ldab  $0C           ;(SMPPER)
F09E : D7 23      stab  $23           ;(TMPPER)
;PPLPE1
F0A0 : C0 03      subb  #$03          ;
;PPLPE2
F0A2 : BD F0 5C   jsr  LF05C          ;(NXTSMP)jump sub 
F0A5 : 08         inx
;PPLP 
F0A6 : D6 23      ldab  $23           ;(TMPPER)
F0A8 : C0 02      subb  #$02          ;(LOOP DELAY IS 18-6 = 12)
F0AA : BD F0 55   jsr  LF055          ;(NTHRVC) jump sub
F0AD : 26 F7      bne  LF0A6          ;(PPLP)(ESCAPE ON WAVE BOUNDARY) branch Z=0 PRM14
;
F0AF : D6 20      ldab  $20           ;(PERVEL)(7 (ALL TIMES ARE SINCE RTS FROM LAST NEXTSMP))
F0B1 : 96 21      ldaa  $21           ;(PERVEL+1)
F0B3 : 9B 0D      adda  $0D           ;(SMPPER+1)(UPDATE SAMPLE RATE ONCE EACH WAVE PLAY)
F0B5 : D9 0C      adcb  $0C           ;(SMPPER)
F0B7 : 97 0D      staa  $0D           ;(SMPPER+1)
F0B9 : D7 0C      stab  $0C           ;(SMPPER 24)
;
F0BB : DB 22      addb  $22           ;(GLBPRO)
F0BD : 86 19      ldaa  #$19          ;(#MINPER)(AVOID SYNC ERRORS BY LIMITING PITCH.)
F0BF : 11         cba                 ;(MAX. PITCH ALLOWS AT LEAST 1 FILTER)
F0C0 : 24 01      bcc  LF0C3          ;(*+3) (CALL PER SAMPLE)
;F0C2 : 81 16      cmpa  #$16          ; <-- wrong disasm : FCB 129, TAB
F0C2 : 81                             ;-127
F0C3 : 16         tab                 ; 
F0C4 : D7 23      stab  $23           ;(TMPPER 41)
F0C6 : 01         nop                 ;
F0C7 : C0 09      subb  #$09          ;
F0C9 : BD F0 5C   jsr  LF05C          ;(NXTSMP 54) jump sub 
;
F0CC : 96 2F      ldaa  $2F           ;(FCNT)(COUNT WAVE PLAYS FOR FILTER)
F0CE : 16         tab                 ; ((ONLY IF <0))
F0CF : 48         asla                ;
F0D0 : C9 00      adcb  #$00          ;
F0D2 : D7 2F      stab  $2F           ;(FCNT 13)
;
F0D4 : D6 23      ldab  $23           ;(TMPPPER)
F0D6 : C0 05      subb  #$05          ;
F0D8 : 96 25      ldaa  $25           ;(PWVCNT)
F0DA : 2A 06      bpl  LF0E2          ;(PAWAKE) branch N=0 
;
F0DC : 7C 00 25   inc  $0025          ;(PWVCNT)(UPDATE DELAY COUNT IF <0)
F0DF : 01         nop                 ;
F0E0 : 20 BE      bra  LF0A0          ;(PPLPE1 37) branch always 
;PWAWAKE 
F0E2 : 5A         decb                ;(ELSE WE ARE ALIVE)
F0E3 : BD F0 5C   jsr  LF05C          ;(NXTSMP 36) jump sub 
;
F0E6 : DE 0A      ldx  $0A            ;(PCMDPT)
F0E8 : A6 00      ldaa  $00,x         ;
F0EA : 2A 12      bpl  LF0FE          ;(PPLP1)(MOST CMDS ARE >0) branch N=0
;
F0EC : 81 80      cmpa  #$80          ;(#128)
F0EE : 27 5F      beq  LF14F          ;(STOPR 19)(EXCEPT FOR END = 128) branch Z=1 
;
F0F0 : 4C         inca                ;
F0F1 : 97 25      staa  $25           ;(PWVCNT)(OR A NEGATIVE NUMBER -N)
F0F3 : 08         inx                 ;(WHICH WAITS N WAVE PLAYS)
;F0F4 : FF 00 0A   stx  $000A         ; <-- wrong disasm : FCB -1,0,PCMDPT (BEFORE FETCHING THE NEXT COMMAND)
FOF4 : FF                             ;-1
FOF5 : 00                             ;0
FoF6 : 0A                             ;PCMDPT
;PPLP35
F0F7 : D6 23      ldab  $23           ;(TMPPER)
F0F9 : C0 06      subb  #$06
F0FB : 7E F0 A0   jmp  LF0A0          ;(PPLPE1 43) jump 
;PPLP1 
F0FE : 08         inx                 ;
F0FF : E6 00      ldab  $00,x         ;(GET NEXT CMD STRING BYTE ON STACK)
F101 : 37         pshb                ;
F102 : 08         inx                 ;
;
F103 : DF 0A      stx  $0A            ;(PCMDPT 35)
F105 : 97 29      staa  $29           ;(PCMD)
F107 : 84 70      anda  #$70          ;
F109 : 44         lsra                ;
F10A : 44         lsra                ;
F10B : 44         lsra                ;
F10C : 5F         clrb                ;
;
F10D : 8B E3      adda  #$E3          ;(#PCMDJT!.255)
F10F : C9 F1      adcb  #$F1          ;(#PCMDJT/256)
F111 : 97 2B      staa  $2B           ;(PTEMP+1)
F113 : D7 2A      stab  $2A           ;(PTEMP 61)
;
F115 : D6 23      ldab  $23           ;(TMPPER)
F117 : D6 23      ldab  $23           ;(TMPPER)
F119 : C0 0D      subb  #$0D          ;(#13)
F11B : BD F0 5C   jsr  LF05C          ;(NXTSMP 78)jump sub 
;
F11E : 5F         clrb
F11F : DE 2A      ldx  $2A            ;(PTEMP)(EXECUTE CMD)
F121 : EE 00      ldx  $00,x          ;
F123 : 6E 00      jmp  $00,x          ;(16)jump
;*
;* PITCH COMMAND ROUTINES.  UNLESS OTHERWISE STATED, N IS A SIGNED 8 BIT
;* NUMBER = BYTE FOLLOWING OPCODE.
;
;* LDP N  IS  SMPPER := N,  ADP N  IS SMPPER := SMPPER + N
;LDPR
F125 : 96 29      ldaa  $29           ;(PCMD)(BIT 0 = 1 FOR LOAD)
F127 : 47         asra                ;
F128 : C2 00      sbcb  #$00          ;
F12A : D4 0C      andb  $0C           ;(SMPPER)
F12C : 32         pula                ;
F12D : 10         sba                 ;
F12E : 9B 0C      adda  $0C           ;(SMPPER)
F130 : 97 0C      staa  $0C           ;(SMPPER 39)
F132 : 08         inx                 ;
;LDPRE
F133 : D6 23      ldab  $23           ;(TMPPER)
F135 : C0 0A      subb  #$0A          ;(#10)
F137 : 7E F0 A2   jmp  LF0A2          ;(PPLPE2 51) jump sub 
;
;* LDO N IS  GLBPRO := N,  ADO N IS  GLBPRO := GLBPRO + N
;LDOR
F13A : 96 29      ldaa  $29           ;(PCMD)((BIT 0 = 1 FOR LOAD)
F13C : 47         asra                ;
F13D : C2 00      sbcb  #$00          ;
F13F : D4 22      andb  $22           ;(GLBPRO)
F141 : 32         pula                ;
F142 : 10         sba                 ;
F143 : 9B 22      adda  $22           ;(GLBPRO)
F145 : 97 22      staa  $22           ;(GLBPRO)
F147 : 20 EA      bra  LF133          ;branch always 
;
;* ESC EXECUTES MACHINE LANGUAGE IMMEDIATELY FOLLOWING
;ESCR
F149 : 32         pula                ;
F14A : DE 0A      ldx  $0A            ;(PCMDPT)
F14C : 09         dex
F14D : 6E 00      jmp  $00,x          ;(,X 32) jump
;
;* STOP EITHER REPEATS A CALL, RETURNS FROM A CALL, OR ENDS SOUND.
;STOPR 
F14F : 96 26      ldaa  $26          ;(PSTK+1)
F151 : 81 5F      cmpa  #$5F          ;(#PBTM)
F153 : 2B 01      bmi  LF156          ;(*+3 28) branch N=1 
F155 : 39         rts                 ;return subroutine
;
F156 : D6 23      ldab  $23           ;(TMPPER)
F158 : C0 07      subb  #$07          ;
F15A : BD F0 5C   jsr  LF05C          ;(NXTSMP 42) jump sub
;
F15D : DE 25      ldx  $25            ;(PSTK)
F15F : 6A 02      dec  $02,x          ;
F161 : 2B 12      bmi  LF175          ;(PRET 15)(DONE) branch N=1 
;
F163 : EE 00      ldx  $00,x          ;(ELSE REPEAT)
F165 : A6 00      ldaa  $00,x         ;
F167 : 36         psha                ;
F168 : 08         inx                 ;
F169 : DF 0A      stx  $0A            ;(PCMDPT 39)
;
;F16B : F6 00 23   ldab  $0023        ; <- disasm error (FCB -10,0,TMPPER)
F16B : F6                             ;-10
F16C : 00                             ;0
F16D : 23                             ;TMPPER
F16E : C0 09      subb  #$09          ;
F170 : BD F0 5C   jsr  LF05C          ;(NXTSMP 54) jump sub
;
F173 : 20 55      bra  LF1CA          ;(PTORE1) branch always 
;*
;PRET
F175 : EE 00      ldx  $00,x          ;
F177 : 08         inx                 ;
F178 : DF 0A      stx  $0A            ;(PCMDPT)
F17A : 96 26      ldaa  $26           ;(PSTK+1)
F17C : 8B 03      adda  #$03          ;(#3)
F17E : 97 26      staa  $26           ;(PSTK+1)
;
F180 : D6 23      ldab  $23           ;(TMPPER)
F182 : C0 07      subb  #$07
F184 : 01         nop
F185 : 7E F0 A0   jmp  LF0A0          ;(PPLPE1 49) jump 
;
;* LDV N IS  PERVEL := N,  ADV N IS  PERVEL := PERVEL + N
;* IN THIS CASE  N IS A 12 BIT NUMBER, THE UPPER 4 BITS OF WHICH
;* ARE LO 4 BITS OF THE OPCODE BYTE.
;
;ADVR
F188 : 08         inx                 ;
F189 : 20 04      bra  LF18F          ;(*+6) branch always 
;
;LDVR 
F18B : D7 20      stab  $20           ;(PERVEL)(CLEAR PERVEL FOR LOAD)
F18D : D7 21      stab  $21           ;(PERVEL+1 24)
;
F18F : D6 29      ldab  $29           ;(PCMD)
F191 : C4 0F      andb  #$0F          ;(#15)(SIGN EXTEND)
F193 : CB F8      addb  #$F8          ;(#-8)
F195 : C8 F8      eorb  #$F8          ;(#-8 34)
;
F197 : 32         pula                ;
F198 : 9B 21      adda  $21           ;(PERVEL+1)
F19A : D9 20      adcb  $20           ;(PERVEL)
F19C : 97 21      staa  $21           ;(PERVEL+1)
F19E : D7 20      stab  $20           ;(PERVEL 52)
;
;F1A0 : F6 00 23   ldab  $23          ; <- disasm error (FCB -10,0,TMPPER)
F1A0 : F6                             ;-10
F1A1 : 00                             ;0
F1A2 : 23                             ;TMPPER
F1A3 : C0 09      subb  #$09          ;(#9)
F1A5 : 7E F0 A0   jmp  LF0A0          ;(PPLPE1 61) jump 
;
;* DO R,N  CALLS RTN AT *+N  R TIMES.
;FDOR
F1A8 : 96 26      ldaa  $26           ;(PSTK+1)
F1AA : 80 03      suba  #$03          ;(#3)
F1AC : 97 26      staa  $26           ;(PSTK+1 25)
;
F1AE : DE 25      ldx  $25            ;(PSTK)
F1B0 : 96 0B      ldaa  $0B           ;(PCMDPT+1)(STACK ENTRY PTS TO DISPLACEMENT)
F1B2 : D6 0A      ldab  $0A           ;(PCMDPT)
F1B4 : 8B FF      adda  #$FF          ;(#-1)
F1B6 : C9 FF      adcb  #$FF          ;(#-1)
F1B8 : E7 00      stab  $00,x         ;
F1BA : A7 01      staa  $01,x         ;(1,X 53)
F1BC : D6 29      ldab  $29           ;(PCMD)(LO OPCODE BITS ARE REPEAT CNT)
F1BE : C4 0F      andb  #$0F          ;(#15)
F1C0 : E7 02      stab  $02,x         ;(2,X 64)
;
F1C2 : D6 23      ldab  $23           ;(TMPPER)
F1C4 : C0 0C      subb  #$0C          ;(#12)
F1C6 : BD F0 5C   jsr  LF05C          ;(NXTSMP 78) jump sub 
;
F1C9 : 08         inx                 ;(SYNC W/NEXT RTN)
;PTORE 
F1CA : 08         inx                 ;
F1CB : 08         inx                 ;
F1CC : 5F         clrb                ;
F1CD : 01         nop                 ;
;
;* TO N  SETS LOC TO BE *+N.
;PTOR 
F1CE : 32         pula                ;(20)
F1CF : 47         asra                ;
F1D0 : 49         rola                ;
F1D1 : C2 00      sbcb  #$00          ;
F1D3 : 9B 0B      adda  $0B           ;(PCMDPT+1)
F1D5 : D9 0A      adcb  $0A           ;(PCMDPT)
F1D7 : 97 0B      staa  $0B           ;(PCMDPT+1)
;F1D9 : F7 00 0A   stab  $0A          ; <- disasm error (FCB -9,0,PCMDPT 41)
F1D9 : F7                             ;-9
F1DA : 00                             ;0
F1DB : 0A                             ;PCMDPT 41
;
F1DC : D6 23      ldab  $23           ;(TMPPER)
F1DE : C0 07      subb  #$07          ;(#7)
F1E0 : 7E F0 A0   jmp  LF0A0          ;(PPLPE1) jump PRM12
;*************************************;
; JMPTBL1
;*************************************;
;PCMDJT	FDB	LDPR,LDOR,LDVR,ADVR,LDPR,ESCR,PDOR,PTOR
;*		   0    1    2    3    4    5  	 6    7
;FCMDJT	FDB	ADHR,LDTR,ETBR,HIDR,FINR,ZTBR,FDOR,FTOR
;
;PCMDJT
F1E3 : F1 25                          ;LDPR 
F1E5 : F1 3A                          ;LDOR 
F1E7 : F1 8B                          ;LDVR 
F1E9 : F1 88                          ;ADVR 
F1EB : F1 25                          ;LDPR
F1ED : F1 49                          ;ESCR 
F1EF : F1 A8                          ;PDOR 
F1F1 : F1 CE                          ;PTOR 
;FCMDJT
F1F3 : F3 64                          ;ADHR 
F1F5 : F3 ED                          ;LDTR 
F1F7 : F2 9F                          ;ETBR 
F1F9 : F3 95                          ;HIDR
F1FB : F2 1A                          ;FINR 
F1FD : F3 A6                          ;ZTBR 
F1FF : F2 45                          ;FDOR 
F201 : F2 D9                          ;FTOR 
;*
;SUBTTL Wave Modification - PARAM8
;* FENDR OVERLAY GETS RETURN ADDR FROM STACK.
;FRTURN
F203 : DE 2F      ldx $2F             ;(FSTK)
F205 : EE 03      ldx $03,x           ;
F207 : 08         inx                 ;(NEXT INSTR IS AFTER DISPLACEMENT BYTE)
F208 : DF 08      stx  $08            ;(FCMDPT 19)
F20A : BD F2 D3   jsr  LF2D           ;(FCMDNX 41) jump sub 
F20D : 08         inx                 ;
F20E : 39         rts                 ;return subroutine
;*
;REPEAT CALL.
;*
;FDOAGN
F20F : EE 00      ldx  $00,x          ;(PT TO DISPLACEMENT BYTE)
F211 : DF 08      stx  $08            ;(FCMDPT 35)
F213 : CE F2 D9   ldx  #$F2D9         ;(#FTOR)(JUMP RTN IS NEXT) jump sub below 
F216 : DF 2D      stx  $2D            ;(FVECT+1)
F218 : 01         nop                 ;
F219 : 39         rts                 ;(50) return subroutine
;*
;* FIN DOES  REPEAT CALL, RETURN TO CALLER, STOP RTN DEPENDING ON STACK.
;FINR
F21A : 96 30      ldaa  $30           ;(FSTK+1)
F21C : 81 37      cmpa  #$37          ;(#FBTM)
F21E : 23 12      bls  LF232          ;(ALLDON 9)(LAST END STATEMENT) branch C=1 and Z=1 
;
F220 : DE 2F      ldx  $2F            ;(FSTK)
F222 : 6A 02      dec  $02,x          ;(NO, CHECK TOP OF STACK)
F224 : 2A E9      bpl  LF20F          ;(FDOAGN 24)(STILL REPEATING) branch N=0 
;
F226 : 80 03      suba  #$03          ;
F228 : 97 30      staa  $30           ;(FSTK+1)
F22A : CE F2 03   ldx  #$F203         ;(#FRTURN)(ELSE RETURN) load X with F203h 
F22D : DF 2D      stx  $2D            ;(FVECT+1 38)
F22F : 6D 00      tst  $00,x          ;
F231 : 39         rts                 ;return subroutine
;
;ALLDON
F232 : CE F2 3A   ldx  #$F23A         ;(#WAST50) load X with F23Ah 
F235 : DF 2D      stx  $2D            ;(FVECT+1)
F237 : 01         nop                 ;(19)
F238 : 20 05      bra  LF23F          ;(WAST27) branch always 
;WAST50
F23A : 08         inx                 ;
F23B : 08         inx                 ;
F23C : 01         nop                 ;
;WAST40
F23D : 8D 05      bsr  LF244          ;(WAST5) branch sub
;WAST27
F23F : 8D 03      bsr  LF244          ;(WAST5) branch sub
;WAST14
F241 : 6D 00      tst  $00,x          ;
;WAST7
F243 : 01         nop                 ;
;WAST5
F244 : 39         rts                 ;return subroutine
;*
;* CALL WITH REPEAT. REPEAT CNT 0(=1) TO 15 (=16) IS LO 4 BITS OF OPCODE.
;* NEXT BYTE IS DISPLACEMENT AS IN GO INSTRUCTION.  THE CTR AND RETURN
;* ADDRESS ARE SAVED ON A STACK.
;FDOR 
F245 : DE 2F      ldx  $2F            ;(FSTK)
F247 : 96 08      ldaa  $08           ;(FCMDPT)(SAVE ADDR OF DISPLACEMENT BYTE)
F249 : A7 03      staa  $03,x         ;(3,X)
F24B : 96 09      ldaa  $09           ;(FCMDPT+1)
F24D : A7 04      staa  $04,x         ;(4,X)
F24F : 96 39      ldaa  $39           ;(FCMD)
F251 : 84 0F      anda  #$0F          ;(#15)
F253 : A7 05      staa  $05,x         ;(5,X 33)
;
F255 : 08         inx                 ;
F256 : CE F2 5C   ldx  #$F25C         ;(#1$) load X with F25Ch 
F259 : DF 2D      stx  $2D            ;(FVECT+1)
F25B : 39         rts                 ;(50) return subroutine
;* OVERLAY FOR CALL RTN.
;1$ 
F25C : 96 30      ldaa  $30           ;(FSTK+1)
F25E : 8B 03      adda  #$03          ;(#3)
F260 : 97 30      staa  $30           ;(FSTK+1)
F262 : CE F2 D9   ldx  #$F2D9         ;(#FTOR) load X with F2D9h 
F265 : DF 2D      stx  $2D            ;(FVECT+1 17)(GET READY TO JUMP)
F267 : 01         nop                 ;
F268 : 20 D5      bra  LF23F          ;(WAST27) branch always 
;* GET NEXT FILTER COMMAND
;NXTFCM 
F26A : 7D 00 2F   tst  $002F          ;(FCNT)
F26D : 26 CE      bne  LF23D          ;(WAST40)(IN A DELAY) branch Z=0 
;
F26F : DE 08      ldx  $08            ;(FCMDPT)
F271 : A6 00      ldaa  $00,x         ;
F273 : 08         inx                 ;
F274 : DF 08      stx  $08            ;(FCMDPT)
F276 : 97 39      staa  $39           ;(FCMD)
F278 : 2A 05      bpl  LF27F          ;(1$ 36) branch N=0 
;
F27A : 97 2F      staa  $2F           ;(FCNT)(NEGATIVE CMD IS NEG OF WAVE DELAY)
F27C : A6 00      ldaa  $00,x         ;
F27E : 39         rts                 ;(50) return subroutine
;1$
F27F : CE F2 86   ldx  #$F286         ;(#EXFCMD)(POSITIVE IS FROM TABLE) load X with F286h 
;F282 : FF 00 2D   stx  $002D         ; <- disasm error (-1,0,FVECT+1)
F282 : FF                             ;-1
F283 : 00                             ;0
F284 : 2D                             ;FVECT+1
F285 : 39          rts                ;(50) return subroutine
;
;EXFCMD 
F286 : 5F         clrb                ;
F287 : 96 39      ldaa  $39           ;(FCMD)
F289 : 84 70      anda  #$70          ;(B4 - B7 IS INSTRUCTION)
F28B : 44         lsra                ;
F28C : 44         lsra                ;
F28D : 44         lsra                ;
F28E : 8B F3      adda  #$F3          ;(#FCMDJT!.255)
F290 : C9 F1      adcb  #$F1          ;(#FCMDJT/255)
F292 : D7 37      stab  $37           ;(FNHI)
F294 : 97 38      staa  $38           ;(FNLO 25)
;
F296 : DE 37      ldx  $37            ;(FNHI)
F298 : EE 00      ldx  $00,x          ;
F29A : DF 2D      stx  $2D            ;(FVECT+1)
F29C : DF 2D      stx  $2D            ;(FVECT+1)
F29E : 39         rts                 ;return subroutine
;*
;* SET UP FOR REPEATED TABLE ADD.
;ETBR 
F29F : 96 39      ldaa  $39           ;(FCMD)
F2A1 : 84 0F      anda  #$0F          ;(#15)
F2A3 : 4C         inca                ;
F2A4 : 4C         inca                ;
F2A5 : 97 2F      staa  $2F           ;(FCNT)
F2A7 : 20 1A      bra  LF2C3          ;(FHA1 17) ;branch always
;
;* LOOK FOR A NONZERO HARMONIC CHANGE AND PERFORM IT.  IF ENTIRE TABLE
;* IS ZERO WE HAVE FINISHED THE LAST COMMAND AND PICK UP THE NEXT ONE
;FINDHA 
F2A9 : 7C 00 32   inc  $0032          ;(HAPTR+1)
F2AC : DE 31      ldx  $31            ;(HAPTR)
F2AE : 8C 00 68   cpx  #$0068         ;(#CNAMP)(END TABLE?)
F2B1 : 27 10      beq  LF2C3          ;(FHAI 17) branch Z=1 
;
F2B3 : A6 00      ldaa  $00,x         ;(NO, LOOK AT CURRENT ENTRY)
F2B5 : CE F2 ED   ldx  #$F2ED         ;(#ADDINI) load X with F2EDh 
F2B8 : 97 35      staa  $35           ;(HAMP)
F2BA : 26 03      bne  LF2BF          ; 
F2BC : CE F2 A9   ldx  #$F2A9         ;(#FINDHA)(LOOK AGAIN IF 0) load X with F2A9h 
;
F2BF : DF 2D      stx  $2D            ;(FVECT+1)
F2C1 : 08         inx                 ;
F2C2 : 39         rts                 ;return subroutine
;
;FHA1 
F2C3 : 86 5E      ldaa  #$5E          ;(#ADD2HA-2)(RESTART TABLE)
;F2C5 : B7 00 32   staa  $0032    ; <- disasm error (FCB $B7,0,HAPTR+1)
F2C5 : B7                             ;$B7
F2C6 : 00                             ;0
F2C7 : 32                             ;HAPTR+1
F2C8 : CE F2 A9   ldx  #$F2A9         ;(#FINDHA)(MAYBE REPEAT) load X with F2A9h 
F2CB : 7A 00 2F   dec  $002F          ;(FCNT)
F2CE : 27 03      beq  LF2D3          ;(*+5) branch Z=1 
F2D0 : 7E F2 D6   jmp  LF2D6          ;(*+6) jump 
;FCMDNX 
F2D3 : CE F2 6A   ldx  #$F26A         ;(#NXTFCM 40) load X with F26Ah 
;
F2D6 : DF 2D      stx  $2D            ;(FVECT+1)
F2D8 : 39         rts                 ;return subroutine
;
;* RELATIVE JUMP
;FTOR 
F2D9 : DE 08      ldx  $08            ;(FCMDPT)
F2DB : 5F         clrb                ;
F2DC : A6 00      ldaa  $00,x         ;
F2DE : 4C         inca                ;(DISPLACEMENT IS FROM NEXT INSTRUCTION)
F2DF : 47         asra                ;
F2E0 : 49         rola                ;
F2E1 : C2 00      sbcb  #$00          ;
F2E3 : 9B 09      adda  $09           ;(FCMDPT+1)
F2E5 : D9 08      adcb  $08           ;(FCMDPT)
F2E7 : 97 09      staa  $09           ;(FCMDPT+1)
F2E9 : D7 08      stab  $08           ;(FCMDPT)
F2EB : 20 E6      bra  LF2D3          ;(FCMDNX 37) branch always 
;
;* SET UP FOR ADD OF HAMP * HARMONIC TO WAVE.
;ADDINI
F2ED : 96 32      ldaa  $32           ;(HAPTR+1)
F2EF : 80 5F      suba  #$5F          ;(#ADD2HA-1)
F2F1 : 48         asla                ;
F2F2 : 5F         clrb                ;
F2F3 : 9B 0F      adda  $0F           ;(HRMTBL+1)(GET PTR TO HARMONIC IN FNHI, FNLO)
F2F5 : D9 0E      adcb  $0E           ;(HRMTBL)
F2F7 : D7 37      stab  $37           ;(FNHI)
F2F9 : 97 38      staa  $38           ;(FNLO)
;
F2FB : 86 80      ldaa  #$80          ;(#128)
F2FD : 97 36      staa  $36           ;(FMSK)
;
F2FF : CE F3 0A   ldx  #$F30A         ;(#2$) load X with F30Ah 
F302 : DF 2D      stx  $2D            ;(FVECT+1 37)
F304 : CE 00 10   ldx  #$0010         ;#WAVSRT)
F307 : DF 33      stx  $33            ;(FWVPTR)
F309 : 39         rts                 ;return subroutine
;*
;2$
F30A : DE 37      ldx  $37            ;(FNHI)(GET HARMONIC FN TO FNHI,FNLO)
F30C : EE 00      ldx  $00,x          ;
F30E : DF 37      stx  $37            ;(FNHI)
F310 : CE F3 1F   ldx  #$F31F         ;(#ADDLP) load X with F31Fh 
F313 : DF 2D      stx  $2D            ;(FVECT+1 23)
;
F315 : DE 31      ldx  $31            ;(HAPTR)
F317 : A6 09      ldaa  $09,x         ;(9,X)
F319 : 9B 35      adda  $35           ;(HAMP)
F31B : A7 09      staa  $09,x         ;(9,X 41)(RECORD CHANGE)
F31D : 08         inx                 ;
F31E : 39         rts                 ;return subroutine
;*
;* ADD HAMP * HARMONIC FN TO WAVEFORM.
;ADDLP 
F31F : 96 36      ldaa  $36           ;(FMSK)(MSK PTS TO CURRENT HARMONIC VALUE)
F321 : 27 1D      beq  LF340          ;(1$)(NEED NEW MASK AFTER 8 SAMPLES) branch Z=1
;
F323 : 74 00 36   lsr  $0036          ;(FMSK)
F326 : DE 33      ldx  $33            ;(FWVPTR)
F328 : E6 00      ldab  $00,x         ;
F32A : 94 37      anda  $37           ;(FNHI)(ADD/SUBTRACT HAMP FROM SAMPLE ON)
F32C : 26 09      bne  LF337          ;(2$ 29) (SIGN OF HARMONIC) branch Z=0 
;F32E : FB 00 35   addb  $0035         ; <- disasm error (FCB -5,0,HAMP)
F32E : FB                             ;-16
F32F : 00                             ;0
F330 : 35                             ;HAMP
F331 : E7 00      stab  $00,x         ;
F333 : 7C 00 34   inc  $0034          ;(FWVPTR+1)
F336 : 39          rts                ;(50) return subroutine
;*
;2$
;F337 : F0 00 35   subb  $0035         ; <- disasm error (FCB -16,0,HAMP)
F337 : F0                             ;-16
F338 : 00                             ;0
F339 : 35                             ;HAMP
F33A : E7 00      stab  $00,x         ;
F33C : 7C 00 34   inc  $0034          ;(FWVPTR+1)
F33F : 39         rts                 ;return subroutine
;*
;1$ 
F340 : D6 34      ldab  $34           ;(FWVPTR+1)
F342 : C1 20      cmpb  #$20          ;(#WAVSRT+16)
F344 : 27 0B      beq  LF351          ;(3$ 16)(DONE) branch Z=1 
F346 : D6 38      ldab  $38           ;(FNLO)
F348 : D7 37      stab  $37           ;(FNHI)(ELSE SET FOR NEXT 8 SAMPLES)
F34A : C6 80      ldab  #$80          ;(#128)
;F34C : F7 00 36   stab  $0036         ; <- disasm error (FCB -9,0,FMSK)
F34C : F7                             ;-9
F34D : 00                             ;0
F34E : 36                             ;FMSK
F34F : 20 0F      bra  LF360          ;(16$ 34) branch always 
;
;3$ 
F351 : CE F2 6A   ldx  #$F26A         ;(#NXTFCM)(RETURN TO THE RIGHT PLACE) load X with F26Ah 
F354 : D6 2F      ldab  $2F           ;(FCNT)
F356 : 26 03      bne  LF35B          ;(*+5)(FCNT <>0 MEANS IN TABLE LOOP) branch Z=0 
F358 : 7E F3 5E   jmp  LF35E          ;(*+6)(FCNT = 0 MEANS EXECUTING COMMANDS) jump 
F35B : CE F2 A9   ldx  #$F2A9         ;(#FINDHA) load X with F2A9h 
F35E : DF 2D      stx  $2D            ;(FVECT+1 34)
;16$
F360 : 6D 00      tst  $00,x          ;
F362 : 08         inx                 ;
F363 : 39         rts                 ;return subroutine
;
;* ADH H,N  LDH H,N  USE SAME RTN
; ADHR
;LDHR
F364 : 96 39      ldaa  $39           ;(FCMD)
F366 : 84 07      anda  #$07          ;(HARMONIC #)
F368 : 8B 60      adda  #$60          ;(#ADD2HA)
F36A : 97 32      staa  $32           ;(HAPTR+1)
;
F36C : DE 08      ldx  $08            ;(FCMDPT)
F36E : A6 00      ldaa  $00,x         ;
F370 : 08         inx                 ;
F371 : DF 08      stx  $08            ;(FCMDPT)
F373 : 97 35      staa  $35           ;(HAMP 33)(SAVE VALUE)
;
F375 : CE F3 7C   ldx  #$F37C         ;(#1$) load X with F37Ch 
F378 : DF 2D      stx  $2D            ;(FVECT+1) 
F37A : 08         inx                 ;
F37B : 39         rts                 ;return subroutine
;*
;1$
F37C : DE 31      ldx  $31            ;(HAPTR)
F37E : 5F         clrb                ;
F37F : 96 39      ldaa  $39           ;(FCMD)
F381 : 8B F8      adda  #$F8          ;(#-8)(CARRY IF LD)
F383 : C2 00      sbcb  #$00          ;(#0)
F385 : E4 09      andb  $09,x         ;(9,X)(LD NEW = SUB OLD + ADD NEW)
F387 : 50         negb                ;
F388 : DB 35      addb  $35           ;(HAMP)
;
;ADHRE
F38A : D7 35      stab  $35           ;(HAMP)
F38C : CE F2 ED   ldx  #$F2ED         ;(#ADDINI) load X with F2EDh 
F38F : DF 2D      stx  $2D            ;(FVECT+1)
F391 : 08         inx                 ;
F392 : 08         inx                 ;
F393 : 01         nop                 ;
F394 : 39         rts                 ;return subroutine
;
;* HARMONIC INCREMENT OR DECREMENT
;HIDR
F395 : D6 39      ldab  $39           ;(FCMD)
F397 : 54         lsrb                ;
F398 : C4 07      andb  #$07          ;(#7)
F39A : CA 60      orab  #$60          ;(#ADD2HA)(! ADD2HA MUST BE DIVISIBLE BY 8 !)
F39C : D7 32      stab  $32           ;(HAPTR+1)(PT TO THIS HARMONIC)
;
F39E : C6 FF      ldab  #$FF          ;(#-1)(CARRY IF INCREMENT (BIT 0 OF FCMD = 1)
F3A0 : C9 00      adcb  #$00          ;(#0)
F3A2 : C9 00      adcb  #$00          ;(#0)
F3A4 : 20 E4      bra  LF38A          ; ADHRE 23) branch always
;
;* CLEAR ADD2HA OR ALTER 0TH AMPLITUDE.
;ZTBR 
F3A6 : 96 39      ldaa  $39           ;(FCMD)(LO BIT 0 IF ZT)
F3A8 : 47         asra                ;
F3A9 : 25 13      bcs  LF3BE          ;(ADCR) branch C=1
;
F3AB : CE 00 00   ldx  #$0000         ;(#0)
F3AE : DF 60      stx  $60            ;(ADD2HA)
F3B0 : DF 62      stx  $62            ;(ADD2HA+2)
F3B2 : DF 64      stx  $64            ;(ADD2HA+4)
F3B4 : DF 66      stx  $66            ;(ADD2HA+6 32)
F3B6 : 08         inx                 ;
;
F3B7 : CE F2 6A   ldx  #$F26A         ;(#NXTFCM) load X with F26Ah 
;F3BA : FF 00 2D   stx  $002D          ; <- disasm error (FCB -1,0,FVECT+1)
F3BA : FF                             ;-1
F3BB : 00                             ;0
F3BC : 2D                             ;FVECT+1
;ATBRE1
F3BD : 39         rts                 ;return subroutine
;
;ADCR
F3BE : 85 02      bita  #$02          ;(#2)
F3C0 : 26 0C      bne  LF3CE          ;(ESC1 15)(BIT 2 FCMD =1 FOR ESCAPE) branch C=1
F3C2 : C6 5F      ldab  #$5F          ;(#ADD2HA-1)
F3C4 : D7 32      stab  $32           ;(HAPTR+1 21)
F3C6 : CE F3 D3   ldx  #$F3D3         ;(#ADCRO) load X with F3D3h 
;ADCRE 
F3C9 : DF 2D      stx  $2D            ;(FVECT+1)
F3CB : 7E F2 41   jmp  LF241          ;(WAST14)jump
;ESC1
;F3CE : FE 00 08   ldx  $0008          ; <- disasm error (FCB -2,0,FCMDPT)
F3CE : FE                             ;-2
F3CF : 00                             ;0
F3D0 : 08                             ;FCMDPT
F3D1 : 20 F6      bra  LF3C9          ;(ADCRE 24) branch always 
;
;ADCR0 
F3D3 : 5F         clrb                ;
F3D4 : 96 39      ldaa  $39           ;(FCMD)
F3D6 : 8B AE      adda  #$AE          ;(#-82)(CARRY IF LDH)
F3D8 : C2 00      sbcb  #$00          ;(#0)
F3DA : D4 68      andb  $68           ;(CNAMP)
F3DC : DE 08      ldx  $08            ;(FCMDPT)
F3DE : A6 00      ldaa  $00,x         ;
F3E0 : 08         inx                 ;
F3E1 : DF 08      stx  $08            ;(FCMDPT 30)
F3E3 : 10         sba                 ;
F3E4 : 97 35      staa  $35           ;(HAMP)
F3E6 : CE F2 ED   ldx  #$F2ED         ;(#ADDINI) load X with F2EDh 
;F3E9 : FF 00 2D   stx  $002D          ; <- disasm error (FCB -1,0,FVECT+1)
F3E9 : FF                             ;-1
F3EA : 00                             ;0
F3EB : 2D                             ;FVECT+1
F3EC : 39         rts                 ;return subroutine
;
;* CHANGE SOME ADD2HA ENTRIES.
;LDTR 
F3ED : C6 60      ldab  #$60          ;(#ADD2HA)(ASSUME FIRST ENTRY IS H #8)
F3EF : D7 32      stab  $32           ;(HAPTR+1)
F3F1 : DE 08      ldx  $08            ;(FCMDPT)
F3F3 : E6 00      ldab  $00,x         ;(EACH BIT INDICATES PRESENCE OF ENTRY)
F3F5 : D7 37      stab  $37           ;(FNHI)
F3F7 : 08         inx                 ;
F3F8 : DF 08      stx  $08            ;(FCMDPT 28)
F3FA : D6 39      ldab  $39           ;(FCMD)(LO BIT 1 IF ENTRY FOR 0 IS PRESENT)
F3FC : 54         lsrb                ;
F3FD : 24 18      bcc  LF417          ;(5$) branch C=0 
F3FF : CE F4 31   ldx  #$F431         ;(#6$) load X with F431h 
F402 : DF 2D      stx  $2D            ;(FVECT+1)
F404 : 39         rts                 ;return subroutine
;
;4$ 
F405 : 5F         clrb                ;
F406 : 96 38      ldaa  $38           ;(FNLO)(LO BIT 0 IF REPLACE, 1 IF ADD TO CURRENT)
F408 : 47         asra                ;
F409 : C2 00      sbcb  #$00          ;(#0)
F40B : DE 31      ldx  $31            ;(HAPTR)
F40D : E4 00      andb  $00,x         ;
F40F : 1B         aba                 ;
F410 : A7 00      staa  $00,x         ;(,X 26)
F412 : 7C 00 32   inc  $0032          ;(HAPTR+1)(P1 TO NEXT GUY)
F415 : A6 00      ldaa  $00,x         ;
;
;5$ 
F417 : CE F4 1D   ldx  #$F41D         ;(#1$) load X with F41Dh 
F41A : DF 2D      stx  $2D            ;(FVECT+1)
F41C : 39         rts                 ;return subroutine
;
;1$ 
F41D : 78 00 37   asl  $0037          ;(FNHI)
F420 : 25 13      bcs  LF435          ;(2$) branch C=1 
F422 : 27 06      beq  LF42A          ;(3$)(NO MORE IF 0) branch Z=1 
F424 : 7C 00 32   inc  $0032          ;(HAPTR+1)
F427 : 7E F2 3F   jmp  LF23F          ;(WAST27) jump 
;
;3$ 
F42A : BD F2 D3   jsr  LF2D3          ;(FCMDNX 36) jump sub 
F42D : 6D 00      tst  $00,x          ;
F42F : 01         nop                 ;
F430 : 39         rts                 ;return subroutine
;
;6$ 
F431 : 7A 00 32   dec  $0032          ;(HAPTR+1)(SET FOR 0TH ENTRY)
F434 : 08         inx                 ;
;2$
F435 : A6 00      ldaa  $00,x         ;
F437 : DE 08      ldx  $08            ;(FCMDPT)
F439 : A6 00      ldaa  $00,x         ;
F43B : 08         inx                 ;
F43C : DF 08      stx  $08            ;(FCMDPT 33)
F43E : 97 38      staa  $38           ;(FNLO)
F440 : CE F4 05   ldx  #$F405         ;(#4$) load X with F405h 
F443 : DF 2D      stx  $2D            ;(FVECT+1)
F445 : 39         rts                 ;return subroutine
;*************************************;
;TILT 
;*************************************;
;TILT
F446 : CE 00 E0   ldx  #$00E0         ;load X with 00E0h
;TILT1
F449 : 86 20      ldaa  #$20          ;load A with 20h
F44B : 8D 51      bsr  LF49E          ;branch sub ADDX
;TILT2
F44D : 09         dex                 ;decr X
F44E : 26 FD      bne  LF44D          ;branch Z=0 TILT2
F450 : 7F 04 00   clr  $0400          ;clear (00) DAC output SOUND
;TILT3
F453 : 5A         decb                ;decr B
F454 : 26 FD      bne  LF453          ;branch Z=0 TILT3
F456 : 73 04 00   com  $0400          ;complement 1s in DAC output SOUND
F459 : DE 06      ldx  $06            ;load X with addr 06
F45B : 8C 10 00   cpx  #$1000         ;compare X with 1000h
F45E : 26 E9      bne  LF449          ;branch Z=0 TILT1
F460 : 39         rts                 ;return subroutine
;*************************************;
; IRQ
;*************************************; 
F461 : 8E 00 7F   lds #$007F          ;load stack pointer with 007Fh 
F464 : B6 04 02   ldaa  $0402         ;load A with value at addr 0402 (PIA sound select)
F467 : 0E         cli                 ;clear interrupt I=0
F468 : 43         coma                ;complement 1s A
F469 : 84 1F      anda  #$1F          ;and A with value 1Fh
F46B : 27 03      beq  LF470          ;branch Z=1 IRQ1
F46D : 4A         deca                ;decr A
F46E : 8D 02      bsr  LF472          ;branch sub IRQ2
;IRQ1
F470 : 20 FE      bra  LF470          ;branch always IRQ1
;IRQ2
F472 : 27 38      beq  LF4AC          ;branch Z=1 CAL1 (rts)
F474 : 80 02      suba  #$02          ;sub A with 02h
F476 : 2B CE      bmi  LF446          ;branch N=1 SYNTH2
F478 : 81 06      cmpa  #$06          ;compare A with 06h
F47A : 24 06      bcc  LF482          ;branch C=0 IRQ2
F47C : BD F6 A9   jsr  LF6A9          ;jump sub GWLD
F47F : 7E F7 0F   jmp  LF70F          ;jump GWAVE
;IRQ3
F482 : 81 0C      cmpa  #$0C          ;compare A with 0Ch
F484 : 24 08      bcc  LF48E          ;branch C=0 IRQ4
F486 : 80 06      suba  #$06          ;sub A with 06h
F488 : BD F6 36   jsr  LF636          ;jump sub VARILD
F48B : 7E F6 5C   jmp  LF65C          ;jump VARI
;IRQ4
F48E : 81 12      cmpa  #$12          ;compare A with 12h
F490 : 24 1B      bcc  LF4AD          ;branch C=0 WALSH
F492 : 80 0C      suba  #$0C          ;sub A with 0Ch
F494 : 48         asla                ;arith shift left A
F495 : CE F8 40   ldx  #$F840         ;load X with JMPTBL2
F498 : 8D 04      bsr  LF49E          ;branch sub ADDX
F49A : EE 00      ldx  $00,x          ;load X with addr X
F49C : 6E 00      jmp  $00,x          ;jump addr X
;*************************************;
;Add A to X
;*************************************;
;ADDX
F49E : DF 06      stx  $06            ;store X in addr 06
F4A0 : 9B 07      adda  $07           ;add A with addr 07
F4A2 : 97 07      staa  $07           ;store A in addr 07
F4A4 : 96 06      ldaa  $06           ;load A with addr 06
F4A6 : 89 00      adca  #$00          ;add C + A and 00h
F4A8 : 97 06      staa  $06           ;store A in addr 06
F4AA : DE 06      ldx  $06            ;load X with addr 06
;ADDXX
F4AC : 39         rts                 ;return subroutine
;*************************************;
;Walsh calling routine
;*************************************; 
;WALSH
F4AD : 81 1D      cmpa  #$1D          ;compare A with 1Dh
F4AF : 24 FB      bcc  LF4AC          ;branch C=0 ADDXX
F4B1 : 80 12      suba  #$12          ;sub A with 12h
F4B3 : CE F9 87   ldx  #$F987         ;load X with F987h ODDTBL 
F4B6 : DF 0E      stx  $0E            ;(SMPPER)
F4B8 : CE F9 5E   ldx  #$F95E         ;load X with F95Eh (WSHTBL1)
F4BB : 8D E1      bsr  LF49E          ;branch sub ADDX
F4BD : A6 00      ldaa  $00,x         ;load A with addr X+00h
F4BF : 16         tab                 ;transfer A to B
F4C0 : C4 0F      andb  #$0F          ;and B with 0Fh
F4C2 : 10         sba                 ;sub B from A
F4C3 : 44         lsra                ;logic shift right A
F4C4 : 44         lsra                ;logic shift right A
F4C5 : 44         lsra                ;logic shift right A
F4C6 : CE F9 69   ldx  #$F969         ;load X with F969h (WSHTBL2) 
F4C9 : 8D D3      bsr  LF49E          ;branch sub ADDX
F4CB : EE 00      ldx  $00,x          ;load X with addr X+00h
F4CD : DF 08      stx  $08            ;(FCMDPT)
F4CF : 17         tba                 ;transfer B to A
F4D0 : 84 0E      anda  #$0E          ;and A with 0Eh
F4D2 : CE F9 7B   ldx  #$F97B         ;load X with F97Bh (WSHTBL3) 
F4D5 : 8D C7      bsr  LF49E          ;branch sub ADDX
F4D7 : EE 00      ldx  $00,x          ;load X with X+00h
F4D9 : A6 00      ldaa  $00,x         ;load A with X+00h
F4DB : 97 0C      staa  $0C           ;store A in addr 0C
F4DD : 08         inx                 ;incr X
F4DE : DF 0A      stx  $0A            ;(PCMDPT)
F4E0 : 56         rorb                ;rotate right B
F4E1 : 56         rorb                ;rotate right B
F4E2 : C4 80      andb  #$80          ;and B with 80h
F4E4 : 7E F0 7F   jmp  LF07F          ;jump WSM
;*************************************;
;Cannon
;*************************************; 
;CANNON
F4E7 : 86 01      ldaa  #$01          ;load A with 01h
F4E9 : 97 12      staa  $12           ;store A in addr 12
F4EB : CE 03 E8   ldx  #$03E8         ;load X with 03E8h
F4EE : C6 FF      ldab  #$FF          ;load B with FFh
;*************************************;
;Filtered Noise Routine 
;*************************************;
;*X=SAMPLE COUNT, ACCB=INITIAL MAX FREQ
;*ACCA=FREQ DECAY FLAG ,DSFLG=DISTORTION FLAG
;FNOISE
F4F0 : 97 11      staa  $11           ;store A in addr 11
F4F2 : D7 0C      stab  $0C           ;store B in addr 0C
F4F4 : DF 0F      stx  $0F            ;store X in addr 0F
F4F6 : 7F 00 0E   clr  $000E          ;clear addr 000E
;FNOIS0
F4F9 : DE 0F      ldx  $0F            ;load X with addr 0F
F4FB : B6 04 00   ldaa  $0400         ;load A with DAC
;FNOIS1
F4FE : 16         tab                 ;transfer A to B
F4FF : 54         lsrb                ;logic shift right B
F500 : 54         lsrb                ;logic shift right B
F501 : 54         lsrb                ;logic shift right B
F502 : D8 03      eorb  $03           ;exclusive or B with addr 03
F504 : 54         lsrb                ;logic shift right B
F505 : 76 00 02   ror  $0002          ;rotate right addr 0002
F508 : 76 00 03   ror  $0003          ;rotate right addr 0003
F50B : D6 0C      ldab  $0C           ;load B with addr 0C
F50D : 7D 00 12   tst  $0012          ;test addr 0012
F510 : 27 02      beq  LF514          ;branch Z=1 FNOIS2
F512 : D4 02      andb  $02           ;and B with addr 02
;FNOIS2
F514 : D7 0D      stab  $0D           ;store B in addr 0D
F516 : D6 0E      ldab  $0E           ;load B with addr 0E
F518 : 91 03      cmpa  $03           ;compare A with addr 03
F51A : 22 12      bhi  LF52E          ;branch C+Z=0 FNOIS4
;FNOIS3
F51C : 09         dex                 ;decr X
F51D : 27 26      beq  LF545          ;branch Z=1 FNOIS6
F51F : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F522 : DB 0E      addb  $0E           ;add B with addr 0E
F524 : 99 0D      adca  $0D           ;add C+A + addr 0D
F526 : 25 16      bcs  LF53E          ;branch C=1 FNOIS5
F528 : 91 03      cmpa  $03           ;compare A with addr 03
F52A : 23 F0      bls  LF51C          ;branch C+Z=1 FNOIS3
F52C : 20 10      bra  LF53E          ;branch always FNOIS5
;FNOIS4
F52E : 09         dex                 ;decr X
F52F : 27 14      beq  LF545          ;branch Z=1 FNOIS6
F531 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F534 : D0 0E      subb  $0E           ;sub B with addr 0E
F536 : 92 0D      sbca  $0D           ;sub C+A + addr 03
F538 : 25 04      bcs  LF53E          ;branch C=1 FNOIS5
F53A : 91 03      cmpa  $03           ;compare A with addr 03
F53C : 22 F0      bhi  LF52E          ;branch C+Z=0 FNOIS4
;FNOIS5
F53E : 96 03      ldaa  $03           ;load A with addr 03
F540 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F543 : 20 B9      bra  LF4FE          ;branch always FNOIS1
;FNOIS6
F545 : D6 11      ldab  $11           ;load B with addr 11
F547 : 27 B5      beq  LF4FE          ;branch Z=1 FNOIS1
F549 : 96 0C      ldaa  $0C           ;load A with addr 0C
F54B : D6 0E      ldab  $0E           ;load B with addr 0E
F54D : 44         lsra                ;logic shift right A
F54E : 56         rorb                ;rotate right B
F54F : 44         lsra                ;logic shift right A
F550 : 56         rorb                ;rotate right B
F551 : 44         lsra                ;logic shift right A
F552 : 56         rorb                ;rotate right B
F553 : 43         coma                ;complement 1s A
F554 : 50         negb                ;negate B
F555 : 82 FF      sbca  #$FF          ;sub C+A + FFh
F557 : DB 0E      addb  $0E           ;add B with addr 0E
F559 : 99 0C      adca  $0C           ;add C+A + addr 0C
F55B : D7 0E      stab  $0E           ;store B in addr 0E
F55D : 97 0C      staa  $0C           ;store A in addr 0C
F55F : 26 98      bne  LF4F9          ;branch Z=0 FNOIS0
F561 : C1 07      cmpb  #$07          ;compare B with 07h
F563 : 26 94      bne  LF4F9          ;branch Z=0 FNOIS0
F565 : 39         rts                 ;return subroutine
;*************************************;
; Radio
;*************************************;
;RADIO
F566 : 86 F0      ldaa  #$F0          ;load A with value F0h (#RADSND/$100 SOUND TABLE)(1st byte of addr RADSND)
F568 : 97 08      staa  $08           ;store B in addr 08 (XPTR)
F56A : CE 00 64   ldx  #$0064         ;load X with value 0064h (#100)(STARTING FREQ)
F56D : DF 04      stx  $04            ;store X in addr 04 (TEMPX)
;RADIO1
F56F : DB 05      addb  $05           ;add B with value in addr 05 (TEMPX+1)(ADD FREQ TO TIMER)
F571 : 96 0A      ldaa  $0A           ;load A with value in addr 0A (TEMPA)
F573 : 99 04      adca  $04           ;A = A + C + value in addr 04 (TEMPX)
F575 : 97 0A      staa  $0A           ;store A in addr 0A (TEMPA)
F577 : DE 04      ldx  $04            ;load X with value in addr 04 (TEMPX)
F579 : 25 04      bcs  LF57F          ;branch if C=1 (RADIO2)
F57B : 20 00      bra  LF57D          ;branch always (*+2)(EQUALIZE TIME)
F57D : 20 03      bra  LF582          ;branch always (RADIO3)
;RADIO2
F57F : 08         inx                 ;incr X (CARRY?, RAISE FREQ)
F580 : 27 11      beq  LF593          ;branch if Z=1 (RADIO4)(DONE?)
;RADIO3
F582 : DF 04      stx  $04            ;store X in addr 04 (TEMPX)
F584 : 84 0F      anda  #$0F          ;and A with value 0Fh (SET POINTER)
F586 : 8B 45      adda  #$45          ;add A with value 45h (RADSND!.$FF)(2nd byte of addr RADSND)
F588 : 97 09      staa  $09           ;store A in addr 09 (XPTR+1)
F58A : DE 08      ldx  $08            ;load X with value in addr 08 (XPTR)
F58C : A6 00      ldaa  $00,x         ;load A with value in addr X + 00h
F58E : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F591 : 20 DC      bra  LF56F          ;branch always (RADIO1)
;RADIO4
F593 : 39         rts                 ;return subroutine
;*************************************;
; Hyper
;*************************************;
;HYPER
F594 : 4F         clra                ;clear A
F595 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F598 : 97 0A      staa  $0A           ;store A in addr 0A (TEMPA)(ZERO PHASE)
;HYPER1
F59A : 4F         clra                ;clear A (ZERO TIME COUNTER)
;HYPER2
F59B : 91 0A      cmpa  $0A           ;compare A with value in addr 0A (TEMPA)
F59D : 26 03      bne  LF5A2          ;branch if Z=0 (HYPER3)
F59F : 73 04 00   com  $0400          ;complement 1s in DAC output SOUND (PHASE EDGE?)
;HYPER3
F5A2 : C6 12      ldab  #$12          ;load B with value 12h (DELAY)
;HYPER4
F5A4 : 5A         decb                ;decr B
F5A5 : 26 FD      bne  LF5A4          ;branch if Z=0 (HYPER4)
F5A7 : 4C         inca                ;incr A (ADVANCE TIME COUNTER)
F5A8 : 2A F1      bpl  LF59B          ;branch if N=0 (HYPER2)
F5AA : 73 04 00   com  $0400          ;complement 1s in DAC output SOUND (CYCLE DONE?, CYCLE EDGE)
F5AD : 7C 00 0A   inc  $000A          ;incr value in addr 000A (TEMPA)(NEXT PHASE)
F5B0 : 2A E8      bpl  LF59A          ;branch if N=0 (HYPER1)(DONE?)
F5B2 : 39         rts                 ;return subroutine
;*************************************;
;Lightning 
;*************************************;
;LITE 
F5B3 : 86 01      ldaa  #$01          ;load A with 01h
F5B5 : 97 13      staa  $13           ;store A in addr 13 (DFREQ)
F5B7 : C6 03      ldab  #$03          ;load B with 03h
F5B9 : 20 08      bra  LF5C3          ;branch always (LITEN)
;*************************************;
;Appear 
;*************************************;
;APPEAR
F5BB : 86 FF      ldaa  #$FF          ;load A with FFh
F5BD : 97 13      staa  $13           ;store A in addr 13 (DFREQ)
F5BF : 86 60      ldaa  #$60          ;load A with 60h
F5C1 : C6 FF      ldab  #$FF          ;load B with FFh
;*************************************;
; Lightning+Appear Noise Routine
;*************************************;
;LITEN:
F5C3 : 97 12      staa  $12           ;store A in addr 12 (LFREQ)
F5C5 : 86 FF      ldaa  #$FF          ;load A with value FFh (HIGHEST AMP)
F5C7 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F5CA : D7 0E      stab  $0E           ;store B in addr 0E (CYCNT)
;LITE0:
F5CC : D6 0E      ldab  $0E           ;load B with value in addr 0E (CYCNT)
;LITE1:
F5CE : 96 03      ldaa  $03           ;load A with value in addr 03 (LO) (GET RANDOM)
F5D0 : 44         lsra                ;logic shift right A (bit0=0)
F5D1 : 44         lsra                ;logic shift right A (bit0=0)
F5D2 : 44         lsra                ;logic shift right A (bit0=0)
F5D3 : 98 03      eora  $03           ;exclusive OR with value in addr 03 (LO)
F5D5 : 44         lsra                ;logic shift right A (bit0=0)
F5D6 : 76 00 02   ror  $0002          ;rotate right addr 02 (bit7=C,C=bit0)(HI)
F5D9 : 76 00 03   ror  $0003          ;rotate right addr 03 (bit7=C,C=bit0)(LO)
F5DC : 24 03      bcc  LF5E1          ;branch C=0 (LITE2)
F5DE : 73 04 00   com  $0400          ;complement 1s in DAC output SOUND
;LITE2:
F5E1 : 96 12      ldaa  $12           ;load A in addr 12 (LFREQ)(COUNT FREQ)
;LITE3:
F5E3 : 4A         deca                ;decr A
F5E4 : 26 FD      bne  LF5E3          ;branch Z=0 (LITE3)
F5E6 : 5A         decb                ;decr B (COUNT CYCLES)
F5E7 : 26 E5      bne  LF5CE          ;branch Z=0 (LITE1)
F5E9 : 96 12      ldaa  $12           ;load A with value in addr 12 (LFREQ)
F5EB : 9B 13      adda  $13           ;add A with value in addr 13 (DFREQ)
F5ED : 97 12      staa  $12           ;store A in addr 12 (LFREQ)
F5EF : 26 DB      bne  LF5CC          ;branch Z=0 (LITE0)
F5F1 : 39         rts                 ;return subroutine
;*************************************;
;Turbo
;*************************************;
;TURBO 
F5F2 : 86 20      ldaa  #$20          ;load A with 20h
F5F4 : 97 0E      staa  $0E           ;store A in addr 0E (CYCNT)
F5F6 : 97 11      staa  $11           ;store A in addr 11 (NFFLG)
F5F8 : 86 01      ldaa  #$01          ;load A with 01h
F5FA : CE 00 01   ldx  #$0001         ;load X with 0001h
F5FD : C6 FF      ldab  #$FF          ;load B with FFh
;*************************************;
; White Noise Routine 
;*************************************;
;X=INIT PERIOD, ACCB=INIT AMP, ACCA DECAY RATE
;CYCNT=CYCLE COUNT, NFFLG= FREQ DECAY FLAG
;NOISE
F5FF : 97 0C      staa  $0C           ;store A in addr 0C (DECAY)
;NOIS0:
F601 : DF 0F      stx  $0F            ;store X in addr 0F (NFRQ1)
;NOIS00:
F603 : D7 0D      stab  $0D           ;store B in addr 0D (NAMP)
F605 : D6 0E      ldab  $0E           ;load B with value in addr 0E (CYCNT)
;NOISE1:
F607 : 96 03      ldaa  $03           ;load A with value in addr 03 (LO)(GET RANDOM BIT)
F609 : 44         lsra                ;logic shift right A (bit0=0)
F60A : 44         lsra                ;logic shift right A (bit0=0)
F60B : 44         lsra                ;logic shift right A (bit0=0)
F60C : 98 03      eora  $03           ;exclusive OR with value in addr 03 (LO)
F60E : 44         lsra                ;logic shift right A (bit0=0)
F60F : 76 00 02   ror  $0002          ;rotate right addr 02 (bit7=C,C=bit0)(HI)
F612 : 76 00 03   ror  $0003          ;rotate right addr 03 (bit7=C,C=bit0)(LO)
F615 : 86 00      ldaa  #$00          ;load A with 00h
F617 : 24 02      bcc  LF61B          ;branch C=0 (NOISE2)
F619 : 96 0D      ldaa  $0D           ;load A with value in addr 0D (NAMP)
;NOISE2:
F61B : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F61E : DE 0F      ldx  $0F            ;load X with value in addr 0F (NFRQ1)(INCREASING DELAY)
;NOISE3:
F620 : 09         dex                 ;decr X
F621 : 26 FD      bne  LF620          ;branch Z=0 (NOISE3)
F623 : 5A         decb                ;decr B (FIN CYCLE COUNT?)
F624 : 26 E1      bne  LF607          ;branch Z=0 (NOISE1)(NO)
F626 : D6 0D      ldab  $0D           ;load B with value in addr 0D (NAMP)(DECAY AMP)
F628 : D0 0C      subb  $0C           ;B = B - value in addr 0C (DECAY) 
F62A : 27 09      beq  LF635          ;branch Z=1 (NSEND)
F62C : DE 0F      ldx  $0F            ;load X with value in addr 0F (NFRQ1)(INC FREQ)
F62E : 08         inx                 ;incr X
F62F : 96 11      ldaa  $11           ;load A with value in addr 11 (NFFLG)(DECAY FREQ?)
F631 : 27 D0      beq  LF603          ;branch Z=1 (NOIS00)(NO)
F633 : 20 CC      bra  LF601          ;branch always (NOISE0)
;NSEND:
F635 : 39         rts                 ;return subroutine
;*************************************;
; VARI Loader 
;*************************************;
;VARILD 
F636 : 16         tab                 ;transfer A to B
F637 : 48         asla                ;arith shift left A (bit0 is 0) x2
F638 : 48         asla                ;arith shift left A (bit0 is 0) x4
F639 : 48         asla                ;arith shift left A (bit0 is 0) x8
F63A : 1B         aba                 ;A = A + B (x9)
F63B : CE 00 0C   ldx  #$000C         ;load X with value 000Ch (#LOCRAM)
F63E : DF 08      stx  $08            ;store X in addr 08 (0B:XPTR)(SET XSFER)
F640 : CE F8 0A   ldx  #$F80A         ;load X with value FD60h (VVECT)
F643 : BD F4 9E   jsr  LF49E          ;jump sub ADDX
F646 : C6 09      ldab  #$09          ;load B with value 09h (COUNT)
;*************************************;
;Parameter Transfer
;*************************************;
;TRANS
F648 : 36         psha                ;push A into stack then SP - 1
;TRANS1
F649 : A6 00      ldaa  $00,x         ;load A with X+00h
F64B : DF 06      stx  $06            ;store X in addr 06 (XPLAY)
F64D : DE 08      ldx  $08            ;load X from value in addr 08 (XPTR)
F64F : A7 00      staa  $00,x         ;store A in addr X+00h
F651 : 08         inx                 ;incr X
F652 : DF 08      stx  $08            ;store X in addr 08 (XPTR)
F654 : DE 06      ldx  $06            ;load X from value in addr 06 (XPLAY)
F656 : 08         inx                 ;incr X
F657 : 5A         decb                ;decr B
F658 : 26 EF      bne  LF649          ;branch if Z=0 (TRANS1)
F65A : 32         pula                ;SP + 1 pull stack into A
F65B : 39         rts                 ;return subroutine
;*************************************;
; VARI
;*************************************;
;VARI
F65C : 96 14      ldaa  $14           ;load A with value in addr 14 (VAMP)
F65E : B7 04 00   staa  $0400         ;store A in DAC output SOUND
;VAR0 
F661 : 96 0C      ldaa  $0C           ;load A with value in addr 0C (LOPER)
F663 : 97 15      staa  $15           ;store A in addr 15 (LOCNT)
F665 : 96 0D      ldaa  $0D           ;load A with value in addr 0D (HIPER)
F667 : 97 16      staa  $16           ;store A in addr 16 (HICNT)
;V0
F669 : DE 11      ldx  $11            ;load X with value in addr 11 (SWPDT)
;V0LP
F66B : 96 15      ldaa  $15           ;load A with value in addr 15 (LOCNT) (LO CYCLE)
F66D : 73 04 00   com  $0400          ;complement 1s DAC output SOUND
;V1
F670 : 09         dex                 ;decr X
F671 : 27 10      beq  LF683          ;branch if Z=1 (VSWEEP)
F673 : 4A         deca                ;decr A
F674 : 26 FA      bne  LF670          ;branch if Z=0 (V1)
F676 : 73 04 00   com  $0400          ;complement 1s DAC output SOUND
F679 : 96 16      ldaa  $16           ;load A with value in addr 16 (HICNT) (HI CYCLE)
;V2 
F67B : 09         dex                 ;decr X
F67C : 27 05      beq  LF683          ;branch if Z=1 (VSWEEP)
F67E : 4A         deca                ;decr A
F67F : 26 FA      bne  LF67B          ;branch if Z=0 (V2)
F681 : 20 E8      bra  LF66B          ;branch always (V0LP) (LOOP BACK)
;VSWEEP
F683 : B6 04 00   ldaa  $0400         ;load A with value in DAC output SOUND
F686 : 2B 01      bmi  LF689          ;branch if N=1 (VS1)
F688 : 43         coma                ;complement 1s A
;VS1
F689 : 8B 00      adda  #$00          ;add A with 00h
F68B : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F68E : 96 15      ldaa  $15           ;load A with value in addr 15 (LOCNT)
F690 : 9B 0E      adda  $0E           ;add A with value in addr 0E (LODT)
F692 : 97 15      staa  $15           ;store A in addr 15 (LOCNT)
F694 : 96 16      ldaa  $16           ;load A with value in addr 16 (HICNT)
F696 : 9B 0F      adda  $0F           ;add A with value in addr 0F (HIDT)
F698 : 97 16      staa  $16           ;store A in addr 16 (HICNT)
F69A : 91 10      cmpa  $10           ;compare A with value in addr 10 (HIEN)
F69C : 26 CB      bne  LF669          ;branch if Z=0 (V0)
F69E : 96 13      ldaa  $13           ;load A with value in addr 13 (LOMOD)
F6A0 : 27 06      beq  LF6A8          ;branch if Z=1 (VARX)
F6A2 : 9B 0C      adda  $0C           ;add A with value in addr 0F (LOPER)
F6A4 : 97 0C      staa  $0C           ;store A in addr 0F (LOPER)
F6A6 : 26 B9      bne  LF661          ;branch if Z=0 (VAR0)
;VARX
F6A8 : 39         rts                 ;return subroutine
;*************************************;
; GWAVE Loader 
;*************************************;
;GWLD
F6A9 : 16         tab                 ;transfer A to B 
F6AA : 58         aslb                ;arith shift left B
F6AB : 1B         aba                 ;A = A + B
F6AC : 1B         aba                 ;A = A + B
F6AD : 1B         aba                 ;A = A + B
F6AE : CE F7 E0   ldx  #$F7E0         ;load X with F7E0h (SVTAB)
F6B1 : BD F4 9E   jsr  LF49E          ;jump sub ADDX
F6B4 : A6 00      ldaa  $00,x         ;load A with X+00h
F6B6 : 16         tab                 ;transfer A to B 
F6B7 : 84 0F      anda  #$0F          ;and A with value 0Fh
F6B9 : 97 0D      staa  $0D           ;store A in addr 0D
F6BB : 54         lsrb                ;logic shift right B
F6BC : 54         lsrb                ;logic shift right B
F6BD : 54         lsrb                ;logic shift right B 
F6BE : 54         lsrb                ;logic shift right B
F6BF : D7 0C      stab $0C            ;store B in addr 0C
F6C1 : A6 01      ldaa  $01,x         ;load A with value at addr X + 01
F6C3 : 16         tab                 ;transfer A to B 
F6C4 : 54         lsrb                ;logic shift right B 
F6C5 : 54         lsrb                ;logic shift right B
F6C6 : 54         lsrb                ;logic shift right B
F6C7 : 54         lsrb                ;logic shift right B 
F6C8 : D7 0E      stab  $0E           ;store B in addr 0E
F6CA : 84 0F      anda  #$0F          ;and A with value 0Fh 
F6CC : 97 0A      staa  $0A           ;store A in addr 0A
F6CE : DF 04      stx  $04            ;store X in addr 04
F6D0 : CE F8 4C   ldx  #$F84C         ;load X with F84Ch (GWVTAB)
;GWLD2
F6D3 : 7A 00 0A   dec  $000A          ;decr addr 000A
F6D6 : 2B 08      bmi  LF6E0          ;branch N=1 PRM372
F6D8 : A6 00      ldaa  $00,x         ;load A with X+00h
F6DA : 4C         inca                ;incr A
F6DB : BD F4 9E   jsr  LF49E          ;jump sub ADDX
F6DE : 20 F3      bra  LF6D3          ;branch always GWLD3
;GWLD3
F6E0 : DF 11      stx  $11            ;store X in addr 11
F6E2 : BD F7 9F   jsr  LF79F          ;jump sub WVTRAN
F6E5 : DE 04      ldx  $04            ;load X with addr 04
F6E7 : A6 02      ldaa  $02,x         ;load A with X+02h
F6E9 : 97 13      staa  $13           ;store A in addr 13
F6EB : BD F7 B1   jsr  LF7B1          ;jump sub WVDECA
F6EE : DE 04      ldx  $04            ;load X with addr 04
F6F0 : A6 03      ldaa  $03,x         ;load A with X+03h
F6F2 : 97 0F      staa  $0F           ;store A in addr 0F
F6F4 : A6 04      ldaa  $04,x         ;load A with X+04h
F6F6 : 97 10      staa  $10           ;store A in addr 10
F6F8 : A6 05      ldaa  $05,x         ;load A with X+05h
F6FA : 16         tab                 ;transfer A to B
F6FB : A6 06      ldaa  $06,x         ;load A with X+06h
F6FD : CE F8 C9   ldx  #$F8C9         ;load X with F8C9h (#GFRTAB)
F700 : BD F4 9E   jsr  LF49E          ;jump sub ADDX
F703 : 17         tba                 ;transfer B to A
F704 : DF 14      stx  $14            ;store X in addr 14
F706 : 7F 00 1C   clr  $001C          ;clear addr 001C
F709 : BD F4 9E   jsr  LF49E          ;jump sub ADDX
F70C : DF 16      stx  $16            ;store X in addr 16
F70E : 39         rts                 ;return subroutine
;*************************************;
; GWAVE Routine 
;*************************************;
;GWAVE
F70F : 96 0C      ldaa  $0C           ;load A with addr 0C
F711 : 97 1B      staa  $1B           ;store A in addr 1B
;GWT4
F713 : DE 14      ldx  $14            ;load X with addr 14
F715 : DF 06      stx  $06            ;store X in addr 06
;GPLAY
F717 : DE 06      ldx  $06            ;load X with addr 06
F719 : A6 00      ldaa  $00,x         ;load A with X+00h
F71B : 9B 1C      adda  $1C           ;add A with addr 1C
F71D : 97 1A      staa  $1A           ;store A in addr 1A
F71F : 9C 16      cpx  $16            ;compare X with addr 16
F721 : 27 26      beq  LF749          ;branch Z=1 GEND
F723 : D6 0D      ldab  $0D           ;load B with addr 0D
F725 : 08         inx                 ;incr X
F726 : DF 06      stx  $06            ;store X in addr 06
;GOUT
F728 : CE 00 1D   ldx  #$001D         ;load X with addr 001D
;GOUTLP
F72B : 96 1A      ldaa  $1A           ;load A with addr 1A
;GPRLP
F72D : 4A         deca                ;decr A
F72E : 26 FD      bne  LF72D          ;branch Z=0 GPRLP
F730 : A6 00      ldaa  $00,x         ;load A with X+00h
F732 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
;GPR1
F735 : 08         inx                 ;incr X
F736 : 9C 18      cpx  $18            ;compare X with addr 18
F738 : 26 F1      bne  LF72B          ;branch Z=0 GOUTLP
F73A : 5A         decb                ;decr B
F73B : 27 DA      beq  LF717          ;branch Z=0 GPLAY
F73D : 08         inx                 ;incr X
F73E : 09         dex                 ;decr X
F73F : 08         inx                 ;incr X
F740 : 09         dex                 ;decr X
F741 : 08         inx                 ;incr X
F742 : 09         dex                 ;decr X
F743 : 08         inx                 ;incr X
F744 : 09         dex                 ;decr X
F745 : 01         nop                 ;
F746 : 01         nop                 ;
F747 : 20 DF      bra  LF728          ;branch Z=0 GOUT
;GEND
F749 : 96 0E      ldaa  $0E           ;load A with addr 0E
F74B : 8D 64      bsr  LF7B1          ;branch sub WVDECA
;GEND40
F74D : 7A 00 1B   dec  $001B          ;decr addr 001B
F750 : 26 C1      bne  LF713          ;branch Z=0 GWT4
F752 : 96 00      ldaa  $00           ;load A with addr 00
F754 : 9A 01      oraa  $01           ;or A with addr 01
;GEND50
F756 : 26 46      bne  LF79E          ;branch Z=0 GEND1
F758 : 96 0F      ldaa  $0F           ;load A with addr 0F
F75A : 27 42      beq  LF79E          ;branch Z=1 GEND1
F75C : 7A 00 10   dec  $0010          ;decr addr 0010
F75F : 27 3D      beq  LF79E          ;branch Z=1 GEND1
F761 : 9B 1C      adda  $1C           ;add A with addr 1C
;GEND60
F763 : 97 1C      staa  $1C           ;store A in addr 1C
;GEND61
F765 : DE 14      ldx  $14            ;load X with addr 14
F767 : 5F         clrb                ;clear B
;GW0
F768 : 96 1C      ldaa  $1C           ;load A with addr 1C
F76A : 7D 00 0F   tst  $000F          ;test addr 000F
F76D : 2B 06      bmi  LF775          ;branch N=1 GW1
F76F : AB 00      adda  $00,x         ;add A with X+00h
F771 : 25 08      bcs  LF77B          ;branch C=1 GW2
F773 : 20 0B      bra  LF780          ;branch always GW2A
;GW1
F775 : AB 00      adda  $00,x         ;add A with X+00h
F777 : 27 02      beq  LF77B          ;branch Z=1 GW2
F779 : 25 05      bcs  LF780          ;branch C=1 GW2A
;GW2
F77B : 5D         tstb                ;test B
F77C : 27 08      beq  LF786          ;branch Z=0 GW2B
F77E : 20 0F      bra  LF78F          ;branch always GW3
;GW2A
F780 : 5D         tstb                ;test B
F781 : 26 03      bne  LF786          ;branch Z=0 GW2B
F783 : DF 14      stx  $14            ;store X in addr 14
F785 : 5C         incb                ;incr B
;GW2B
F786 : 08         inx                 ;incr X
F787 : 9C 16      cpx  $16            ;compare X with addr 16
F789 : 26 DD      bne  LF768          ;branch Z=0 GW0
F78B : 5D         tstb                ;test B
F78C : 26 01      bne  LF78F          ;branch Z=0 GW3
F78E : 39         rts                 ;return subroutine
;GW3
F78F : DF 16      stx  $16            ;store X in addr 16
F791 : 96 0E      ldaa  $0E           ;load A with addr 0E
F793 : 27 06      beq  LF79B          ;branch Z=1 GEND0
F795 : 8D 08      bsr  LF79F          ;branch sub WVTRAN
F797 : 96 13      ldaa  $13           ;load A with addr 13
F799 : 8D 16      bsr  LF7B1          ;branch sub WVDECA
;GEND0
F79B : 7E F7 0F   jmp  LF70F          ;jump GWAVE
;GEND1
F79E : 39         rts                 ;return subroutine
;*************************************;
; Wave Transfer
;*************************************;
;WVTRAN 
F79F : CE 00 1D   ldx  #$001D         ;load X with value 001Dh (#GWTAB)
F7A2 : DF 08      stx  $08            ;store X in addr 08 (XPTR)
F7A4 : DE 11      ldx  $11            ;load X with value at addr 11 (GWFRM)
F7A6 : E6 00      ldab  $00,x         ;load B with value at addr X + 00h (GET WAVE LENGTH)
F7A8 : 08         inx                 ;incr X
F7A9 : BD F6 48   jsr  LF648          ;jump sub (TRANS)
F7AC : DE 08      ldx  $08            ;load X with value at addr 08 (XPTR)
F7AE : DF 18      stx  $18            ;store X in addr 18 (WVEND)(GET END ADDR)
F7B0 : 39         rts                 ;return subroutine
;*************************************;
; Wave Decay Routine 
;*************************************;
; DECAY AMOUNT IN ACCA(1/16 PER DECAY)
;WVDECA
F7B1 : 4D         tsta                ;test A
F7B2 : 27 2B      beq  LF7DF          ;branch Z=1 (WVDCX)(NODECAY)
F7B4 : DE 11      ldx  $11            ;load X with value at addr 11 (GWFRM)(ROM WAVE INDEX)
F7B6 : DF 06      stx  $06            ;store X in addr 06 (XPLAY) 
F7B8 : CE 00 1D   ldx  #$001D         ;load X with value 001Dh (#GWTAB)
F7BB : 97 0B      staa  $0B           ;store A in addr 0B (TEMPB)(DECAY FACTOR)
;WVDLP
F7BD : DF 08      stx  $08            ;store X in addr 08 (XPTR)
F7BF : DE 06      ldx  $06            ;load X with value in addr 06 (XPLAY)
F7C1 : D6 0B      ldab  $0B           ;load B with vlaue in addr 0B (TEMPB)
F7C3 : D7 0A      stab  $0A           ;store B in addr 0A (TEMPA)(DECAY FACTOR TEMP)
F7C5 : E6 01      ldab  $01,x         ;load B with value in addr X + 01h (OFFSET FOR WAVE LENGTH)
F7C7 : 54         lsrb                ;logic shift right B
F7C8 : 54         lsrb                ;logic shift right B
F7C9 : 54         lsrb                ;logic shift right B
F7CA : 54         lsrb                ;logic shift right B (CALC 1/16TH)
F7CB : 08         inx                 ;incr X
F7CC : DF 06      stx  $06            ;store X in addr 06 (XPLAY)
F7CE : DE 08      ldx  $08            ;load X with value at addr 08 (XPTR)
F7D0 : A6 00      ldaa  $00,x         ;load A with X+00h
;WVDLP1
F7D2 : 10         sba                 ;A = A - B  (DECAY)
F7D3 : 7A 00 0A   dec  $000A          ;decr value in addr 000A (TEMPA)
F7D6 : 26 FA      bne  LF7D2          ;branch Z=0 (WVDLP1)
F7D8 : A7 00      staa  $00,x         ;store A in addr X+00h
F7DA : 08         inx                 ;incr X
F7DB : 9C 18      cpx  $18            ;compare X with value at addr 18 (WVEND)(END OF WAVE?)
F7DD : 26 DE      bne  LF7BD          ;branch Z=0 WVDLP(NO)
;WVDCX
F7DF : 39         rts                 ;return subroutine
;*************************************;
;(SVTAB) tables below,
;*************************************;
;*GWAVE SOUND VECTOR TABLE
;*VECTOR FORMAT
;*BYTE 0: GECHO,GCCNT
;*BYTE 1: GECDEC,WAVE#
;*BYTE 2: PREDECAY FACTOR
;*BYTE 3: GDFINC
;*BYTE 4: VARIABLE FREQ COUNT
;*BYTE 5: FREQ PATTERN LENGTH
;*BYTE 6: FREQ PATTERN OFFSET
;called by PARAM37
F7E0 : F2 20 02 00 00 10 45...........;UNKN1
F7E7 : 57 32 00 00 00 20 03           ;STDSND (partial)
F7EE : 31 13 00 01 00 03 00           ;COOLDN
F7F5 : 41 00 D0 00 00 27 03           ;STDSND (full)
F7FC : 03 11 11 FF 00 0D 2A           ;SPNSND
F803 : 23 34 03 01 28 0E 37           ;YUKSND
;*************************************;
;VVECTs called by VARI Loader 
;*************************************; 
F80A : 40 0F 00 99 09 02 00 F8 FF     ; 
F813 : 00 FF 08 FF 68 04 80 00 FF     ; 
F81C : F0 0F 02 21 26 02 80 00 FF     ; 
F825 : 36 21 09 06 EF 03 C0 00 FF     ; 
F82E : 28 01 00 08 81 02 00 FF FF     ;FOSHIT
F837 : 01 01 00 08 81 02 00 01 FF     ;
;*************************************;
;JMPTBL2
;*************************************; 
F840 : F5 BB                          ; Appear
F842 : F4 E7                          ; Cannon
F844 : F5 66                          ; Radio 
F846 : F5 94                          ; Hyper 
F848 : F5 F2                          ; Turbo 
F84A : F5 B3                          ; Lightning 
;*************************************;
;(GWVTAB) called by PARAM37
;*************************************; 
F84C : 10                             ;GS1
F84D : 7F B0 D9 F5 FF F5 D9 B0        ;
F855 : 7F 4E 24 09 00 09 24 4E        ;
;
F85D : 48                             ;GS72
F85E : 8A 95 A0 AB B5 BF C8 D1        ;
F866 : DA E1 E8 EE F3 F7 FB FD        ;
F86E : FE FF FE FD FB F7 F3 EE        ;
F876 : E8 E1 DA D1 C8 BF B5 AB        ;
F87E : A0 95 8A 7F 75 6A 5F 54        ;
F886 : 4A 40 37 2E 25 1E 17 11        ;
F88E : 0C 08 04 02 01 00 01 02        ;
F896 : 04 08 0C 11 17 1E 2E 37        ;
F89E : 40 4A 54 5F 6A 75 7F           ;
;
F8A6 : 08                             ;GS2
F8A7 : 7F D9 FF D9 7F 24 00 24        ;
;
F8AF : 10                             ;MW1
F8B0 : 00 F4 00 E8 00 DC 00 E2        ;
F8B8 : 00 DC 00 E8 00 F4 00 00        ;
;
F8C0 : 08                             ;
F8C1 : FF FF FF FF 00 00 00 00        ;GSQ2
;*************************************;
;(#GFRTAB) called by PARAM37
;*************************************; 
;COOL DOWNER
F8C9 : 10 08 01                       ;COOLDN
;
;START DISTORTO SOUND
F8CC : 01 01 01 01 02 02 03 03        ;STDSND
F8D4 : 04 04 05 06 08 0A 0C 10        ;
F8DC : 14 18 20 30 40 50 40 30        ;
E8E4 : 20 10 0C 0A 08 07 06 05        ;
F8EC : 04 03 02 02 01 01 01           ;
;
;SPINNER SOUND
F8F3 : 01 01 02 02 03 04 05 06        ;SPNSND
F8FB : 07 08 09 0A 0C                 ;
;
F900 : 08 80 10 78 18 70 20 60        ;YUKSND
F908 : 28 58 30 50 40 48              ;
;
F90E : 01 02 02 03 03 03 06 06        ; UNKN1
F916 : 06 06 0F 1F 36 55 74 91        ;
;*************************************;
;Copyright notice FDB
;*************************************;
;* AND THE EVER POPULAR COPYRIGHT MESSAGE 
F91E : 43    "C"                      ;COPYRIGHT
F91F : 4F    "O"
F920 : 50    "P"
F921 : 59    "Y"
F922 : 52    "R"
F923 : 49    "I"
F924 : 47    "G"
F925 : 48    "H"
F926 : 54    "T"                      ;
F927 : 20 28    " ("                  ;(C)
F929 : 43    "C"
F92A : 29 20    ") "                  ;
F92C : 31    "1"                      ;1982
F92D : 39    "9"
F92E : 38    "8"
F92F : 32    "2"                      ;
F930 : 20 57    " W"                  ;WILLIAMS
F932 : 49    "I"
F933 : 4C    "L"
F934 : 4C    "L"
F935 : 49    "I"
F936 : 41    "A"
F937 : 4D    "M"
F938 : 53    "S"                      ;
F939 : 20 45    " E"                  ;ELECTRONICS
F93B : 4C    "L"
F93C : 45    "E"
F93D : 43    "C"
F93E : 54    "T"
F93F : 52    "R"
F940 : 4F    "O"
F941 : 4E    "N"
F942 : 49    "I"
F943 : 43    "C"
F944 : 53    "S"                      ;
F945 : 20 49    " I"                  ;INC.
F947 : 4E    "N" 
F948 : 43    "C" 
F949 : 2E 20    ". "                  ; 
F94B : 41    "A"                      ;ALL
F94C : 4C    "L" 
F94D : 4C    "L"                      ;
F94E : 20 52    " R"                  ;RIGHTS
F950 : 49    "I" 
F951 : 47    "G" 
F952 : 48    "H" 
F953 : 54    "T" 
F954 : 53    "S"                      ; 
F955 : 20 52    " R"                  ;RESERVED
F957 : 45    "E" 
F958 : 53    "S" 
F959 : 45 52    "ER" 
F95B : 56    "V" 
F95C : 45    "E" 
F95D : 44    "D"                      ;
;*************************************;
;WSHTBL1 data
;*************************************;
F95E : 04 10 22 32 44 54 61 74 
F966 : 78 8A 67 
;*************************************;
;WSHTBL2 jump table - Wave Programs NLIST
;*************************************;
F969 : F9 99                          ;
F96B : F9 AA                          ;
F96D : F9 D0                          ; 
F96F : F9 E3                          ;
F971 : FA 0C                          ; 
F973 : FA 1E                          ;SCREMW
F975 : FA 5B                          ; 
F977 : FA 95                          ; 
F979 : FA 9E                          ;
;*************************************;
;WSHTBL3 jump table - Wave Programs NLIST
;*************************************; 
F97B : FA B6                          ;
F97D : FA BA                          ;
F97F : FA C8                          ; 
F981 : FB 04                          ;
F983 : FA DC                          ;
F985 : FA F4                          ;
;
;SUBTTL SOUND PROGRAMS
;
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

;* HARMONIC FUNCTIONS.  EACH BIT POSITION CORRESPONDS TO A WAVEFORM
;* POSITION.  IF THE BIT = 0, THE VALUE IS +1  IF THE BIT = 1, THE
;* VALUE IS -1.
;
;* THE HARMONICS ARE TREATED IN ORDER OF DECREASING AVERAGE FREQUENCY.
;
;*************************************;
;ODDTBL 
;*************************************; 
F987 : 0000                           ;FDB %0000000000000000  0  CONSTANT IS WEIRDO FOR NOW
F989 : 5555                           ;FDB %0101010101010101  8
F98B : AA55                           ;FDB %1010101001010101  7
F98D : 5A5A                           ;FDB %0101101001011010  6
F98F : 9669                           ;FDB %1001011001101001  5
F991 : 6666                           ;FDB %0110011001100110  4
F993 : CC33                           ;FDB %1100110000110011  3
F995 : 3C3C                           ;FDB %0011110000111100  2
F997 : 0FF0                           ;FDB %0000111111110000  1
;*************************************;
;
;* WAVE PROGRAMS
;
;NLIST
;
;LF999 
F999 : 0F 
F99A : 28 0E    
F99C : 28 0D    
F99E : 28 0C    
F9A0 : 28 0B    
F9A2 : 28 0A    
F9A4 : 28 09    
F9A6 : 28 08    
F9A8 : 28 40    
;****; 
;LF9AA
F9AA : 10 0F 08 06 04 02 29 10
F9B2 : 08 F8 22 10 0C 00 FA 23 
F9BA : 10 0C FC 00 23 10 07 FC 
F9C2 : FC FE 29 10 0E 00 FE FA 
F9CA : 26 3C 07 FC 
F9CE : 70 DA                          ;TO LF9AA(-38)
;****; 
;LF9D0
F9D0 : 0F 08 0B 28 0D 00 FD 0C
F9D8 : 28 0B 00 FD 0D 28 0C 00 
F9E0 : FD 
F9E1 : 70 EF                          ;TO (-17)
;****;  
;LF9E3(prob not...)
F9E3 : 10 01 02                       ;(LT 1,<9,-1>)
F9E6 : 2F                             ;DT 16
F9E7 : 10 02 02                       ;(LT 1,<8,-1>)
F9EA : 2F                             ;DT 16
F9EB : 10 04 02                       ;(LT 1,<7,-1>)
F9EE : 2F                             ;DT 16
F9EF : 10 09 02 FE                    ;(LT 1,<6,0>,<-1,-1>)
F9F3 : 2F                             ;DT 16
F9F4 : 10 02 FE                       ;(LT 1,<5,-1>)
F9F7 : 2F                             ;DT 16
F9F8 : 10 04 FE                       ;(LT 1,<4,-1>)
F9FB : 2F                             ;DT 16
F9FC : 10 09 FE 00                    ;(LT 1,<3,0>,<-1,0>)
FA00 : 2F                             ;DT 16
FA01 : 10 02 00                       ;(LT 0,<2,0>)
FA04 : 2F                             ;DT 16
FA05 : 10 04 00                       ;(LT 0,<1,0>)
FA08 : 2F                             ;DT 16
FA09 : 50                             ;ZT
FA0A : 70 D7                          ;TO LF9E3 (-39)
;****;  
;LFA0C
FA0C : 0C 28 67 04 67 07 70 FA 
FA14 : 63 00 38 37 40 63 00 36
FA1C : 39 
FA1D : 40                             ;FIN
;****; 
;LBL SCREMW,<FPF>
FA1E : 10 FF                          ;(LT 7)
FA20 : 02 02 02 02                    ;<8,1>,<7,1>,<6,1>,<5,1>,
FA24 : 02 02 02 02                    ;<4,1>,<3,1>,<2,1>,<1,1>
FA28 : 2F                             ;(DT 16)
FA29 : 2F                             ;(DT 16) 
FA2A : 50                             ;(ZT)
FA2B : 10 80 FE                       ;(LT 0,<8,-1>)
FA2E : 2F                             ;(DT 16)
FA2F : 10 40 FE                       ;(LT 0,<7,-1>)
FA32 : 2F                             ;(DT 16)
FA33 : 10 A0 00 FE                    ;(LT 1,<8,0>,<6,-1>)
FA37 : 2F                             ;(DT 16)
FA38 : 10 50 00 FE                    ;(LT 1,<7,0>,<5,-1>)
FA3C : 2F                             ;(DT 16)
FA3D : 10 28 00 FE                    ;(LT 1,<6,0>,<4,-1>)
FA41 : 2F                             ;(DT 16)
FA42 : 10 14 00 FE                    ;(LT 1,<5,0>,<3,-1>)
FA46 : 2F                             ;(DT 16)
FA47 : 10 0A 00 FE                    ;(LT 1,<4,0>,<2,-1>)
FA4B : 2F                             ;(DT 16)
FA4C : 10 05 00 FE                    ;(LT 1,<3,0>,<1,-1>)
FA50 : 2F                             ;(DT 16)
FA51 : 10 02 00                       ;(LT 0,<2,0>)
FA54 : 2F                             ;(DT 16)
FA55 : 10 01 00                       ;(LT 0,<1,0>)
FA58 : 2F                             ;(DT 16)
FA59 : 70 C3                          ;(TO SCREMW) (-61)
;****; 
;LFA5B
FA5B : 53 80 10 8B 08 06 04 02
FA63 : 69 28 10 80 F8 62 23 10
FA6B : 88 00 FA 63 1D 10 88 FC
FA73 : 00 63 17 10 0B FC FC FE 
FA7B : 69 10 10 8A 00 FE FA 66
FA83 : 09 3C 07 FC 70 D4 FF FF 
FA8B : FF FF FF FF FF FF FF FF
FA93 : 20 
FA94 : 40                             ;FIN
;****; 
;LFA95
FA95 : 10 0F 02 FE 02 FE 2F 
FA9C : 70 FD                          ;TO
;****; 
;LFA9E
FA9E : 10 74 02 02 02 02 2F 10
FAA6 : 24 FE FE 2F 10 50 FE FE 
FAAE : 2F 10 24 02 02 2F 
FAB4 : 70 E8                          ;TO
;****; 
;LFAB6
FAB6 : 3C 81 
FAB8 : 70 FD                          ;TO
;****; 
;LFABA:
FABA : 2A 21 00 01 2A F0 01 1F
FAC2 : EB 01 19 F5 
FAC6 : 70 F3                          ;TO
;****; 
;LFAC8
FAC8 : 37 2F 00 01 37 F5 01 2D
FAD0 : F5 01 46 FA 70 F5 00 FA 
FAD8 : 20 80 F4 
FADB : 80                             ;STOP
;****; 
;LFADC 
FADC : 32 60 08 10 06 60 04 10
FAE4 : FA 70 F6 01 32 69 EB 01
FAEC : 28 6B E7 01 20 6E E3 
FAF3 : 80                             ;STOP
;****; 
;LFAF4
FAF4 : 19 69 00 10 04 01 19 20 
FAFC : 64 88 01 20 20 96 B0 
FB03 : 80                             ;STOP
;****; 
;LFB04
FB04 : 32 20 50 C7 20 AA D1 21
FB0C : FE D0 
FB0E : 80                             ;STOP
;*************************************;
; Zero padding
;*************************************;
FB0F : 00 00 00 00 00 00 00 00 
FB17 : 00 00 00 00 00 00 00 00 
FB1F : 00 00 00 00 00 00 00 00 
FB27 : 00 00 00 00 00 00 00 00 
FB2F : 00 00 00 00 00 00 00 00 
FB37 : 00 00 00 00 00 00 00 00 
FB3F : 00 00 00 00 00 00 00 00 
FB47 : 00 00 00 00 00 00 00 00 
FB4F : 00 00 00 00 00 00 00 00 
FB57 : 00 00 00 00 00 00 00 00 
FB5F : 00 00 00 00 00 00 00 00 
FB67 : 00 00 00 00 00 00 00 00 
FB6F : 00 00 00 00 00 00 00 00 
FB77 : 00 00 00 00 00 00 00 00 
FB7F : 00 00 00 00 00 00 00 00 
FB87 : 00 00 00 00 00 00 00 00 
FB8F : 00 00 00 00 00 00 00 00 
FB97 : 00 00 00 00 00 00 00 00 
FB9F : 00 00 00 00 00 00 00 00 
FBA7 : 00 00 00 00 00 00 00 00 
FBAF : 00 00 00 00 00 00 00 00 
FBB7 : 00 00 00 00 00 00 00 00 
FBBF : 00 00 00 00 00 00 00 00 
FBC7 : 00 00 00 00 00 00 00 00 
FBCF : 00 00 00 00 00 00 00 00 
FBD7 : 00 00 00 00 00 00 00 00 
FBDF : 00 00 00 00 00 00 00 00 
FBE7 : 00 00 00 00 00 00 00 00 
FBEF : 00 00 00 00 00 00 00 00 
FBF7 : 00 00 00 00 00 00
FBFD : 00 00 00 00 00 00 00 00 
FC05 : 00 00 00 00 00 00 00 00 
FC0D : 00 00 00 00 00 00 00 00 
FC15 : 00 00 00 00 00 00 00 00 
FC1D : 00 00 00 00 00 00 00 00 
FC25 : 00 00 00 00 00 00 00 00 
FC2D : 00 00 00 00 00 00 00 00 
FC35 : 00 00 00 00 00 00 00 00 
FC3D : 00 00 00 00 00 00 00 00 
FC45 : 00 00 00 00 00 00 00 00 
FC4D : 00 00 00 00 00 00 00 00 
FC55 : 00 00 00 00 00 00 00 00 
FC5D : 00 00 00 00 00 00 00 00 
FC65 : 00 00 00 00 00 00 00 00 
FC6D : 00 00 00 00 00 00 00 00 
FC75 : 00 00 00 00 00 00 00 00 
FC7D : 00 00 00 00 00 00 00 00 
FC85 : 00 00 00 00 00 00 00 00 
FC8D : 00 00 00 00 00 00 00 00 
FC95 : 00 00 00 00 00 00 00 00 
FC9D : 00 00 00 00 00 00 00 00 
FCA5 : 00 00 00 00 00 00 00 00 
FCAD : 00 00 00 00 00 00 00 00 
FCB5 : 00 00 00 00 00 00 00 00 
FCBD : 00 00 00 00 00 00 00 00 
FCC5 : 00 00 00 00 00 00 00 00 
FCCD : 00 00 00 00 00 00 00 00 
FCD5 : 00 00 00 00 00 00 00 00 
FCDD : 00 00 00 00 00 00 00 00 
FCE5 : 00 00 00 00 00 00 00 00 
FCED : 00 00 00 00 00 00 00 00 
FCF5 : 00 00 00 00 00 00 00 00 
FCFD : 00 00 00 00 00 00 00 00 
FD05 : 00 00 00 00 00 00 00 00 
FD0D : 00 00 00 00 00 00 00 00 
FD15 : 00 00 00 00 00 00 00 00 
FD1D : 00 00 00 00 00 00 00 00 
FD25 : 00 00 00 00 00 00 00 00 
FD2D : 00 00 00 00 00 00 00 00 
FD35 : 00 00 00 00 00 00 00 00 
FD3D : 00 00 00 00 00 00 00 00 
FD45 : 00 00 00 00 00 00 00 00 
FD4D : 00 00 00 00 00 00 00 00 
FD55 : 00 00 00 00 00 00 00 00 
FD5D : 00 00 00 00 00 00 00 00 
FD65 : 00 00 00 00 00 00 00 00 
FD6D : 00 00 00 00 00 00 00 00 
FD75 : 00 00 00 00 00 00 00 00 
FD7D : 00 00 00 00 00 00 00 00 
FD85 : 00 00 00 00 00 00 00 00 
FD8D : 00 00 00 00 00 00 00 00 
FD95 : 00 00 00 00 00 00 00 00 
FD9D : 00 00 00 00 00 00 00 00 
FDA5 : 00 00 00 00 00 00 00 00 
FDAD : 00 00 00 00 00 00 00 00 
FDB5 : 00 00 00 00 00 00 00 00 
FDBD : 00 00 00 00 00 00 00 00 
FDC5 : 00 00 00 00 00 00 00 00 
FDCD : 00 00 00 00 00 00 00 00 
FDD5 : 00 00 00 00 00 00 00 00 
FDDD : 00 00 00 00 00 00 00 00 
FDE5 : 00 00 00 00 00 00 00 00 
FDED : 00 00 00 00 00 00 00 00 
FDF5 : 00 00 00 00 00 00 00 00 
FDFD : 00 00 00 00 00 00 00 00 
FE05 : 00 00 00 00 00 00 00 00 
FE0D : 00 00 00 00 00 00 00 00 
FE15 : 00 00 00 00 00 00 00 00 
FE1D : 00 00 00 00 00 00 00 00 
FE25 : 00 00 00 00 00 00 00 00 
FE2D : 00 00 00 00 00 00 
FE33 : 00 00 00 00 00 00 00 00 
FE3B : 00 00 00 00 00 00 00 00 
FE43 : 00 00 00 00 00 00 00 00 
FE4B : 00 00 00 00 00 00 00 00 
FE53 : 00 00 00 00 00 00 00 00 
FE5B : 00 00 00 00 00 00 00 00 
FE63 : 00 00 00 00 00 00 00 00 
FE6B : 00 00 00 00 00 00 00 00 
FE73 : 00 00 00 00 00 00 00 00 
FE7B : 00 00 00 00 00 00 00 00 
FE83 : 00 00 00 00 00 00 00 00 
FE8B : 00 00 00 00 00 00 00 00 
FE93 : 00 00 00 00 00 00 00 00 
FE9B : 00 00 00 00 00 00 00 00 
FEA3 : 00 00 00 00 00 00 00 00 
FEAB : 00 00 00 00 00 00 00 00 
FEB3 : 00 00 00 00 00 00 00 00 
FEBB : 00 00 00 00 00 00 00 00 
FEC3 : 00 00 00 00 00 00 00 00 
FECB : 00 00 00 00 00 00 00 00 
FED3 : 00 00 00 00 00 00 00 00 
FEDB : 00 00 00 00 00 00 00 00 
FEE3 : 00 00 00 00 00 00 00 00 
FEEB : 00 00 00 00 00 00 00 00 
FEF3 : 00 00 00 00 00 00 00 00 
FEFB : 00 00 00 00 00 00
FF01 : 00 00 00 00 00 00 00 00 
FF09 : 00 00 00 00 00 00 00 00 
FF11 : 00 00 00 00 00 00 00 00 
FF19 : 00 00 00 00 00 00 00 00 
FF21 : 00 00 00 00 00 00 00 00 
FF29 : 00 00 00 00 00 00 00 00 
FF31 : 00 00 00 00 00 00 00 00 
FF39 : 00 00 00 00 00 00 00 00 
FF41 : 00 00 00 00 00 00 00 00 
FF49 : 00 00 00 00 00 00 00 00 
FF51 : 00 00 00 00 00 00 00 00 
FF59 : 00 00 00 00 00 00 00 00 
FF61 : 00 00 00 00 00 00 00 00 
FF69 : 00 00 00 00 00 00 00 00 
FF71 : 00 00 00 00 00 00 00 00 
FF79 : 00 00 00 00 00 00 00 00 
FF81 : 00 00 00 00 00 00 00 00 
FF89 : 00 00 00 00 00 00 00 00 
FF91 : 00 00 00 00 00 00 00 00 
FF99 : 00 00 00 00 00 00 00 00 
FFA1 : 00 00 00 00 00 00 00 00 
FFA9 : 00 00 00 00 00 00 00 00 
FFB1 : 00 00 00 00 00 00 00 00 
FFB9 : 00 00 00 00 00 00 00 00 
FFC1 : 00 00 00 00 00 00 00 00 
FFC9 : 00 00 00 00 00 00 00 00 
FFD1 : 00 00 00 00 00 00 00 00 
FFD9 : 00 00 00 00 00 00 00 00 
FFE1 : 00 00 00 00 00 00 00 00 
FFE9 : 00 00 00 00 00 00 00 00 
FFF1 : 00 00 00 00 00 00 00
;*************************************;
;Motorola vector table
;*************************************;
FFF8 : F4 61                          ;IRQ  
FFFA : F0 1B                          ;RESET SWI (software)   
FFFC : F0 01                          ;NMI 
FFFE : F0 1B                          ;RESET (hardware) 

;--------------------------------------------------------------

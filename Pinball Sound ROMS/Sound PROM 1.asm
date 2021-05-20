        ;
        ;  Disassembled by:
        ;    DASMx object code disassembler
        ;    (c) Copyright 1996-2003   Conquest Consultants
        ;    Version 1.40 (Oct 18 2003)
        ;
        ;  File:    DiscoFeverPROM.716
        ;
        ;  Size:    512 bytes
        ;  Checksum:  C8AC
        ;  CRC-32:    4D8F6A3C
        ;
        ;  Date:    Wed May 19 00:44:43 2021
        ;
        ;  CPU:    Motorola 6800 (6800/6802/6808 family)
        ;
        ;Sound PROM 1 System 3 : Disco Fever June 1978
        ; Sound by: Randy Pfeiffer
        ; same as World Cup (March 1978) - first Williams solid state game with electronic sounds.
        ;
        ; also possibly used in Contact as PROM (May 1978)
        ;
        ;updated 19 May 2021
        ;
org  $7E00
        ;
;*************************************;
;RESET power on
;*************************************;
;SETUP
7E00 : 0F         sei                 ;set interrupt mask
7E01 : 8E 00 7F   lds  #$007F         ;load stack pointer with 007Fh(ENDRAM)
7E04 : CE 84 00   ldx  #$8400         ;load X with addr 8400 PIA
7E07 : 6F 01      clr  $01,x          ;clear X+01h (8401) PIA CR port A
7E09 : 6F 03      clr  $03,x          ;clear X+03h (8403) PIA CR port B
7E0B : 86 FF      ldaa  #$FF          ;load A with FFh
7E0D : A7 00      staa  $00,x         ;store A in addr X+00h (8400) PIA port A out (DAC sound)
7E0F : 6F 02      clr  $02,x          ;clear addr X+02h(8402) PIA port B in (sound select)
7E11 : 86 34      ldaa  #$34          ;load A with 34h
7E13 : A7 01      staa  $01,x         ;store A in addr X+01h (8401) PIA CR port A
7E15 : 86 37      ldaa  #$37          ;load A with 37h
7E17 : A7 03      staa  $03,x         ;store A in addr X + 03h (8403) PIA CR port B
7E19 : 86 80      ldaa  #$80          ;load A with 80h
7E1B : A7 00      staa  $00,x         ;store A in addr X+00h (8400) PIA port A out (DAC sound)
7E1D : 7F 00 09   clr  $0009          ;clear addr 0009
7E20 : 0E         cli                 ;clear interrupts I=0
;STDBY
7E21 : 20 FE      bra  L7821          ;branch always STDBY
;*************************************;
;early version (pre) of Tilt sound
;*************************************;
;PTILT
7E23 : 4F         clra                ;clear A
7E24 : B7 84 00   staa  $8400         ;store A in DAC output SOUND
7E27 : CE 00 DF   ldx  #$00DF         ;load X with 00DFh
;PTILT1
7E2A : C6 20      ldab  #$20          ;load B with 20h
7E2C : BD 7F 83   jsr  L7F83          ;jump sub ADDBX
;PTILT2
7E2F : 09         dex                 ;decr X
7E30 : 26 FD      bne  L7E2F          ;branch Z=0 PTILT2
7E32 : 73 84 00   com  $8400          ;complement 1s DAC output SOUND
;PTILT3
7E35 : 4A         deca                ;decr A
7E36 : 26 FD      bne  L7E35          ;branch Z=0 PTILT3
7E38 : 73 84 00   com  $8400          ;complement 1s DAC output SOUND
7E3B : D6 0B      ldab  $0B           ;load B with 0B
7E3D : DE 0B      ldx  $0B            ;load X with 0B
7E3F : C5 10      bitb  #$10          ;bit test B with 10h
7E41 : 27 E7      beq  L7E2A          ;branch Z=1 PTILT1
7E43 : 39         rts                 ;return subroutine
;*************************************;
;Single Oscillator Sound Calls #1
;*************************************;
;PERK
7E44 : CE 7F 94   ldx  #$7F94         ;load X with 7F94h (VEC01P)
;PERK1
7E47 : BD 7E D1   jsr  L7ED1          ;jump sub MOVE
7E4A : BD 7E EA   jsr  L7EEA          ;jump sub SING
7E4D : 39         rts                 ;return subroutine
;ATARI
7E4E : CE 7F 9A   ldx  #$7F9A         ;load X with 7F9Ah (VEC02P)
7E51 : 20 F4      bra  L7E47          ;branch always PERK1
;SIREN
7E53 : C6 FF      ldab  #$FF          ;load B with FFh
7E55 : D7 00      stab  $00           ;store B in addr 00
;SIREN1
7E57 : CE 7F A0   ldx  #$7FA0         ;load X with 7FA0h (VEC03X)
7E5A : 8D EB      bsr  L7E47          ;branch sub PERK1
7E5C : CE 7F A6   ldx  #$7FA6         ;load X with 7FA6h (VEC04X)
7E5F : 8D E6      bsr  L7E47          ;branch sub PERK1
7E61 : 5A         decb                ;decr B
7E62 : 26 F3      bne  L7E57          ;branch Z=0 SIREN1
7E64 : 39         rts                 ;return subroutine
;ORRRR
7E65 : CE 7F AC   ldx  #$7FAC         ;load X with 7FACh (VEC05X)
7E68 : 20 DD      bra  L7E47          ;branch always PERK1
;*************************************;
;Single Oscillator Sound Calls #2 - unique to PROM
;*************************************;
;PERK2
7E6A : CE 7F B2   ldx  #$7FB2         ;load X with 7FB2h (VEC06P)
7E6D : 8D 62      bsr  L7ED1          ;branch sub MOVE
7E6F : 58         aslb                ;arith shift left B
7E70 : CE 7F D0   ldx  #$7FD0         ;load X with 7FD0h (VEC11P)
7E73 : BD 7F 83   jsr  L7F83          ;jump sub ADDBX
7E76 : A6 00      ldaa  $00,x         ;load A with X+00h
7E78 : 97 01      staa  $01           ;store A in addr 01
7E7A : A6 01      ldaa  $01,x         ;load A with X+01h
7E7C : 97 05      staa  $05           ;store A in addr 05
7E7E : 8D 6A      bsr  L7EEA          ;branch sub SING
7E80 : 86 88      ldaa  #$88          ;load A with 88h
7E82 : C6 01      ldab  #$01          ;load B with 01h
7E84 : D7 06      stab  $06           ;store B in addr 06
7E86 : C6 60      ldab  #$60          ;load B with 60h
7E88 : D7 05      stab  $05           ;store B in addr 05
7E8A : 8D 60      bsr  L7EEC          ;branch sub SINGA
7E8C : 39         rts                 ;return subroutine
;*************************************;
;Single Oscillator Sound Calls #3
;*************************************;
;PERK$
7E8D : CE 7F B8   ldx  #$7FB8         ;load X with 7FB8h (VEC07P)
;PERK$1
7E90 : 8D B5      bsr  L7E47          ;branch sub PERK1
7E92 : 8D 31      bsr  L7EC5          ;branch sub ECHO
7E94 : 20 FA      bra  L7E90          ;branch always PERK$1
;HSTD
7E96 : 86 FF      ldaa  #$FF          ;load A with FFh
7E98 : 97 00      staa  $00           ;store A in addr 00
7E9A : CE 7F BE   ldx  #$7FBE         ;load X with 7FBEh (VEC08X)
7E9D : 8D F1      bsr  L7E90          ;branch sub PERK$1
7E9F : 39         rts                 ;return subroutine
;*************************************;
;Random Squirts 
;*************************************;
;SQRT
7EA0 : C6 20      ldab  #$20          ;load B with 20h
;SQRT1
7EA2 : CE 7F C4   ldx  #$7FC4         ;load X with 7FC4h (VEC09X)
7EA5 : 8D 2A      bsr  L7ED1          ;branch sub MOVE
;SQRT2
7EA7 : 96 0A      ldaa  $0A           ;load A with addr 0A(RANDOM)
7EA9 : 48         asla                ;arith shift left A
7EAA : 9B 0A      adda  $0A           ;add A with addr 0A(RANDOM)
7EAC : 8B 0B      adda  #$0B          ;add A with 0Bh
7EAE : 97 0A      staa  $0A           ;store A in addr 0A(RANDOM)
7EB0 : 44         lsra                ;logic shift right A
7EB1 : 44         lsra                ;logic shift right A
7EB2 : 8B 10      adda  #$10          ;add A with 10h
7EB4 : 97 01      staa  $01           ;store A in addr 01(FREQ$)
7EB6 : 8D 32      bsr  L7EEA          ;branch sub SING
7EB8 : 5A         decb                ;decr B
7EB9 : 26 EC      bne  L7EA7          ;branch Z=0 SQRT2
7EBB : 39         rts                 ;return subroutine
;*************************************;
; Single Oscillator Sound Call #4 - unique to PROM
;*************************************;
;PERK4
7EBC : CE 7F CA   ldx  #$7FCA         ;load X with 7FCAh (VEC10P)
;PERK$4
7EBF : 8D 86      bsr  L7E47          ;branch sub PERK1
7EC1 : 8D 02      bsr  L7EC5          ;branch sub ECHO
7EC3 : 20 FA      bra  L7EBF          ;branch always PERK$4
;*************************************;
;Echo Function 
;*************************************;
;ECHO:
7EC5 : 96 00      ldaa  $00           ;load A with addr 00(AMP0)
7EC7 : 80 0C      suba  #$0C          ;sub A with 0Ch
7EC9 : 2A 03      bpl  L7ECE          ;branch N=0 ECHO1
7ECB : 97 00      staa  $00           ;store A in addr 00(AMP0)
7ECD : 39         rts                 ;return subroutine
;ECHO1
7ECE : 32         pula                ;SP + 1 pull stack into A
7ECF : 32         pula                ;SP + 1 pull stack into A
7ED0 : 39         rts                 ;return subroutine
;*************************************;
;Move Parameters
;*************************************;
;MOVE
7ED1 : A6 00      ldaa  $00,x         ;load A with value in addr X+00h
7ED3 : 97 01      staa  $01           ;store A in addr 01 (FREQ$)
7ED5 : A6 01      ldaa  $01,x         ;load A with value in addr X+01h
7ED7 : 97 02      staa  $02           ;store A in addr 02 (C$FRQ)
7ED9 : A6 02      ldaa  $02,x         ;load A with value in addr X+02h
7EDB : 97 03      staa  $03           ;store A in addr 03 (D$FRQ)
7EDD : A6 03      ldaa  $03,x         ;load A with value in addr X+03h
7EDF : 97 04      staa  $04           ;store A in addr 04 (E$FRQ)
7EE1 : A6 04      ldaa  $04,x         ;load A with value in addr X+04h
7EE3 : 97 05      staa  $05           ;store A in addr 05 (C$AMP)
7EE5 : A6 05      ldaa  $05,x         ;load A with value in addr X+05h
7EE7 : 97 06      staa  $06           ;store A in addr 06 (D$AMP)
7EE9 : 39         rts                 ;return subroutine
;*************************************;
;Delta F, Delta A Routine (Single Osc)
;*************************************;
;SING:
7EEA : 96 00      ldaa  $00           ;load A with addr 00 (AMP0) (GET STARTING AMPLITUDE)
;SINGA
7EEC : 37         pshb                ;push B into stack then SP - 1 (SAVE B)
7EED : D6 05      ldab  $05           ;load B with addr 05(C$AMP)(GET CYCLES AT AMPLITUDE)
7EEF : D7 07      stab  $07           ;store B in addr 07(C$AMP$)(SAVE AS COUNTER)
7EF1 : D6 02      ldab  $02           ;load B with addr 02(C$FRQ)(GET CYCLES AT FREQUENCY)
7EF3 : D7 08      stab  $08           ;store B in addr 08(C$FRQ$)(SAVE AS COUNTER)
;SING1
7EF5 : 43         coma                ;complement 1s A (INVERT AMPLITUDE)
7EF6 : D6 01      ldab  $01           ;load B with addr 01(FREQ$)(GET FREQUENCY COUNTER)
7EF8 : B7 84 00   staa  $8400         ;store A in DAC output SOUND
;SING2
7EFB : 5A         decb                ;decr B
7EFC : 26 FD      bne  L7EFB          ;branch Z=0 SING2
7EFE : 43         coma                ;complement 1s A(INVERT AMPLITUDE)
7EFF : D6 01      ldab  $01           ;load B with addr 01(FREQ$)(GET FREQUENCY COUNTER)
7F01 : 20 00      bra  L7F03          ;branch always (*+2)(-I)
7F03 : 08         inx                 ;incr X(-I)
7F04 : 09         dex                 ;decr X(-I---)(SYNC, 20 CYCLES)
7F05 : 08         inx                 ;incr X(-I)
7F06 : 09         dex                 ;decr X(-I)
7F07 : B7 84 00   staa  $8400         ;store A in DAC output SOUND
;SING3
7F0A : 5A         decb                ;decr B
7F0B : 26 FD      bne  L7F0A          ;branch Z=0 SING3
7F0D : 7A 00 08   dec  $0008          ;decr addr 0008(C$FRQ$)(CHECK CYCLES AT FREQUENCY)
7F10 : 27 16      beq  L7F28          ;branch Z=1 SING4
7F12 : 7A 00 07   dec  $0007          ;decr addr 0007(C$AMP$)(CHECK CYCLES AT AMPLITUDE)
7F15 : 26 DE      bne  L7EF5          ;branch Z=0 SING1(ALL OK, GO OUTPUT)
7F17 : 43         coma                ;complement 1s A(INVERT AMPLITUDE)
7F18 : D6 05      ldab  $05           ;load B with addr 05(C$AMP)(GET CYCLES AT AMPLITUDE)
7F1A : B7 84 00   staa  $8400         ;store A in DAC output SOUND
7F1D : D7 07      stab  $07           ;store B in addr 07(C$AMP$)(SAVE AS COUNTER)
7F1F : D6 01      ldab  $01           ;load B in addr 01(FREQ$)(GET FREQUENCY COUNT)
7F21 : 9B 06      adda  $06           ;add A with addr 06(D$AMP)(ADD AMPLITUDE DELTA)
7F23 : 2B 1E      bmi  L7F43          ;branch N=1 SING6(RETURN FROM SUBROUTINE)
7F25 : 01         nop                 ;(SYNC, 2 CYCLES)
7F26 : 20 15      bra  L7F3D          ;branch always SING5
;SING4
7F28 : 08         inx                 ;incr X (-I)
7F29 : 09         dex                 ;decr X (-I---)(SYNC, 10 CYCLES)
7F2A : 01         nop                 ; (-I)
7F2B : 43         coma                ;complement 1s A (INVERT AMPLITUDE)
7F2C : D6 02      ldab  $02           ;load B with addr 02(C$FRQ)(GET CYCLES AT FREQUENCY)
7F2E : B7 84 00   staa  $8400         ;store A in DAC output SOUND
7F31 : D7 08      stab  $08           ;store B in addr 08(C$FRQ$)(SAVE AS COUNTER)
7F33 : D6 01      ldab  $01           ;load B with addr 01 (FREQ$)(GET FREQUENCY COUNT)
7F35 : D0 03      subb  $03           ;sub B with addr 03 (D$FRQ)(SUBTRACT FREQUENCY DELTA)
7F37 : D1 04      cmpb  $04           ;compare B with addr 04 (E$FRQ)(COMPARE TO END FREQUENCY)
7F39 : D1 04      cmpb  $04           ;compare B with addr 04 (E$FRQ)(SYNC, 3 CYCLES)
7F3B : 27 06      beq  L7F43          ;branch Z=1 SING6 (RETURN FROM SUBROUTINE)
;SING5
7F3D : D7 01      stab  $01           ;store B in addr 01 (FREQ$)(SAVE FREQUENCY COUNT)
7F3F : C0 05      subb  #$05          ;sub B with 05h (SYNC TO FREQUENCY COUNTDOWN)
7F41 : 20 B8      bra  L7EFB          ;branch always SING2(JUMP INTO COUNTDOWN LOOP)
;SING6
7F43 : 33         pulb                ;SP + 1 pull stack into B (RESTORE B)
7F44 : 39         rts                 ;return subroutine
;*************************************;
;Interrupt Processing
;*************************************;
;IRQ
7F45 : 8E 00 7F   lds  #$007F         ;load SP with value 007Fh (#ENDRAM)
7F48 : 86 BF      ldaa  #$BF          ;load A with BFh
7F4A : 97 00      staa  $00           ;store A in addr 00
7F4C : B6 84 02   ldaa  $8402         ;load A with PIA sound select
7F4F : 0E         cli                 ;clear interrupts I=0
7F50 : 43         coma                ;complement 1s in A
7F51 : 85 9F      bita  #$9F          ;bit test A with 9Fh
;IRQ1
7F53 : 27 FE      beq  L7F53          ;branch Z=1 IRQ1
7F55 : 2A 06      bpl  L7F5D          ;branch N=0 IRQ3
7F57 : 86 05      ldaa  #$05          ;load A with 05h
7F59 : 97 09      staa  $09           ;store A in addr 09
;IRQ2
7F5B : 20 FE      bra  L7F5B          ;branch always IRQ2
;IRQ3
7F5D : D6 09      ldab  $09           ;load B with addr 09
7F5F : 26 0D      bne  L7F6E          ;branch Z=0 IRQ5
7F61 : 85 50      bita  #$50          ;bit test A with 50h
7F63 : 26 09      bne  L7F6E          ;branch Z=0 IRQ5
7F65 : 16         tab                 ;transfer A to B
7F66 : C4 0F      andb  #$0F          ;and B with 0Fh
7F68 : 5A         decb                ;decr B
7F69 : BD 7E 6A   jsr  L7E6A          ;jump sub PERK2
;IRQ4
7F6C : 20 FE      bra  L7F6C          ;branch always IRQ4
;IRQ5
7F6E : 7F 00 09   clr  $0009          ;clear addr 0009
;IRQ6
7F71 : 44         lsra                ;logic shift right A
7F72 : 25 03      bcs  L7F77          ;branch C=1 IRQ7
7F74 : 5C         incb                ;incr B
7F75 : 20 FA      bra  L7F71          ;branch always IRQ6
;IRQ7
7F77 : 58         aslb                ;arith shift left B
7F78 : CE 7F E0   ldx  #$7FE0         ;load X with 7FE0h (JMPTBL)
7F7B : 8D 06      bsr  L7F83          ;branch sub ADDBX
7F7D : EE 00      ldx  $00,x          ;load X with X+00h
7F7F : AD 00      jsr  $00,x          ;jump sub X+00h
;IRQX
7F81 : 20 FE      bra  L7F81          ;branch always IRQX
;*************************************;
;Add B to Index Register
;*************************************;
;ADDBX 
7F83 : DF 0B      stx  $0B            ;store X in addr 0B
7F85 : DB 0C      addb  $0C           ;add B with addr 0C
7F87 : D7 0C      stab  $0C           ;store B in addr 0C
7F89 : D6 0B      ldab  $0B           ;load B with addr 0B
7F8B : C9 00      adcb  #$00          ;add C + B + 00h
7F8D : D7 0B      stab  $0B           ;store B in addr 0B
7F8F : DE 0B      ldx  $0B            ;load X with addr 0B
7F91 : E6 00      ldab  $00,x         ;load B with X+00h
7F93 : 39         rts                 ;return subroutine
;*************************************;
;data tables for SING (Single Osc)
;*************************************;
;VEC01P                               ;"P" vector unique to PROM
7F94 : A003 0430 FF00
;VEC02P
7F9A : 0802 FDFE FF00
;VEC03X                               ;"X" vector also in ROM 1
7FA0 : 2003 FF50 FF00
;VEC04X 
7FA6 : 5003 0120 FF00
;VEC05X 
7FAC : FE04 0204 FF00
;VEC06P
7FB2 : 50FF 0000 0112
;VEC07P
7FB8 : E002 04B8 FF00
;VEC08X
7FBE : E001 0210 FF00
;VEC09X
7FC4 : 50FF 0000 6080
;VEC10P
7FCA : 0801 FFFF FF00
;VEC11P
7FD0 : FF10 C018 343D
;*************************************;
;unknown
;*************************************;
7FD6 : 98 1E 38 3A 40 34 44 31
7FDE : 7C 24 
;*************************************;
;Special Routine Jump Table
;*************************************;
;JMPTBL
7FE0 : 7E 44                          ;PERK
7FE2 : 7E 8D                          ;PERK$
7FE4 : 7E 4E                          ;ATARI
7FE6 : 7E 65                          ;ORRRR
7FE8 : 7E 23                          ;PTILT
7FE0 : 7E A0                          ;SQRT
7FEC : 7E 53                          ;SIREN
7FEE : 7E 96                          ;HSTD
7FF0 : 7E BC                          ;PERK4
;*************************************;
;zero padding
7FF2 : 00 00 00 00 00 00              ;
;*************************************;
;Motorola vector table
;*************************************; 
7FF8 : 7F 45                          ;IRQ
7FFA : 7E 00                          ;RESET SWI (software)  
7FFC : 7E 00                          ;NMI
7FFE : 7E 00                          ;RESET (hardware)

;--------------------------------------------------------------





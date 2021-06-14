        ;
        ;  Disassembled by:
        ;    DASMx object code disassembler
        ;    (c) Copyright 1996-2003   Conquest Consultants
        ;    Version 1.40 (Oct 18 2003)
        ;
        ;  File:    WorldCupPROM.716
        ;
        ;Orig 716 .lst
        ;  Size:    2048 bytes
        ;  Checksum:  E564
        ;  CRC-32:    CF012812
        ;
        ;Cut .lst file:
        ;  Size:    512 bytes
        ;  Checksum:  B959
        ;  CRC-32:    6C58F0F4
        ;
        ;  Date:    Mon May 24 12:34:55 2021
        ;
        ;  CPU:    Motorola 6800 (6800/6802/6808 family)
        ;
        ; Sound PROM 1A System 3 : World Cup, March 1978, 
        ; Sound by: Randy Pfeiffer - first pinball with electronic sounds
        ; Different sound routines from Sound PROM1B - Disco Fever
        ;
        ;4x ROM Code so dasmx checksum is out,
        ; removed 3x copies of ROM code, so only $7E00 - $7FFF
        ;
org  $7E00
        ;
        ;
7E00 : 09                             ;checksum byte
;*************************************;
;RESET power on
;*************************************;
;SETUP
7E01 : 0F         sei                 ;set interrupt mask
7E02 : 8E 00 7F   lds  #$007F         ;load stack pointer with 007Fh(ENDRAM)
7E05 : CE 04 00   ldx  #$0400         ;load X with addr 0400 PIA
7E08 : 6F 01      clr  $01,x          ;clear X+01h (8401) PIA CR port A
7E0A : 6F 03      clr  $03,x          ;clear X+03h (8403) PIA CR port B
7E0C : 86 FF      ldaa  #$FF          ;load A with FFh
7E0E : A7 00      staa  $00,x         ;store A in addr X+00h (0400) PIA port A out (DAC sound)
7E10 : 6F 02      clr  $02,x          ;clear addr X+02h(0402) PIA port B in (sound select)
7E12 : 86 34      ldaa  #$34          ;load A with 34h
7E14 : A7 01      staa  $01,x         ;store A in addr X+01h (0401) PIA CR port A
7E16 : 86 37      ldaa  #$37          ;load A with 37h
7E18 : A7 03      staa  $03,x         ;store A in addr X + 03h (0403) PIA CR port B
7E1A : 86 80      ldaa  #$80          ;load A with 80h
7E1C : A7 00      staa  $00,x         ;store A in addr X+00h (0400) PIA port A out (DAC sound)
7E1E : 7F 00 0B   clr  $000B          ;clear addr 000B
7E21 : 0E         cli                 ;clear interrupts I=0
7E22 : 3E         wai                 ;wait interrupts, PC+1
;*************************************;
;unknown synth A (also in ContactPROM without SNDTBL2)
;*************************************;
;SYNTHA L7E23
7E23 : DF 01      stx  $01            ;store X in addr 01
7E25 : 36         psha                ;push A into stack then SP - 1
;SYNA1
7E26 : CE 7F D1   ldx  #$7FD1         ;load X with 7FD1h (SNDTBL2)
;SYNA2
7E29 : A6 00      ldaa  $00,x         ;load A with X+00h
7E2B : 27 0B      beq  L7E38          ;branch Z=1 SYNA4
7E2D : B7 04 00   staa  $0400         ;store A in DAC output SOUND
7E30 : 96 00      ldaa  $00           ;load A with addr 00
;SYNA3
7E32 : 4A         deca                ;decr A
7E33 : 26 FD      bne  L7E32          ;branch Z=0 SYNA3
7E35 : 08         inx                 ;incr X
7E36 : 20 F1      bra  L7E29          ;branch always SYNA2
;SYNA4
7E38 : 5A         decb                ;decr B
7E39 : 26 EB      bne  L7E26          ;branch Z=0 SYNA1
7E3B : DE 01      ldx  $01            ;load X with addr 01
7E3D : 32         pula                ;SP + 1 pull stack into A
7E3E : 39         rts                 ;return subroutine
;*************************************;
;param A for SYNTHA
;*************************************;
;PARAMA
7E3F : 96 08      ldaa  $08           ;load A with addr 08
;PRMA1
7E41 : 97 00      staa  $00           ;store A in addr 00
7E43 : D6 09      ldab  $09           ;load B with addr 09
7E45 : 8D DC      bsr  L7E23          ;branch sub SYNTHA
7E47 : 4A         deca                ;decr A
7E48 : 91 07      cmpa  $07           ;compare A with addr 07
7E4A : 26 F5      bne  L7E41          ;branch Z=0 PRMA1
;PRMA2
7E4C : 97 00      staa  $00           ;store A in addr 00
7E4E : D6 09      ldab  $09           ;load B with addr 09
7E50 : 8D D1      bsr  L7E23          ;branch sub SYNTHA
7E52 : 4C         inca                ;incr A
7E53 : 91 08      cmpa  $08           ;compare A with addr 08
7E55 : 26 F5      bne  L7E4C          ;branch Z=0 PRMA2
7E57 : 7A 00 0A   dec  $000A          ;decr addr 000A
7E5A : 26 E3      bne  L7E3F          ;branch Z=0 PARAMA
7E5C : 3E         wai                 ;wait interrupts, PC+1
;*************************************;
;synthA table loader #1
;*************************************;
;SNALD1
7E5D : CE 7F 9D   ldx  #$7F9D         ;load X with 7F9Dh (TBL1)
;SNALDX
7E60 : 8D 07      bsr  L7E69          ;branch sub PMOVE
7E62 : 20 DB      bra  L7E3F          ;branch always PARAMA
;SNALD2
7E64 : CE 7F A1   ldx  #$7FA1         ;load X with 7FA1h (TBL2)
7E67 : 20 F7      bra  L7E60          ;branch always SNALDX
;*************************************;
;PMOVE - move 4 params to LOCRAM
;*************************************;
;PMOVE 
7E69 : A6 00      ldaa  $00,x         ;load A with X+00h
7E6B : 97 07      staa  $07           ;store A in addr 07
7E6D : E6 01      ldab  $01,x         ;load B with X+01h
7E6F : D7 08      stab  $08           ;store B in addr 08
7E71 : EE 02      ldx  $02,x          ;load X with X+02h
7E73 : DF 09      stx  $09            ;store X in addr 09
7E75 : 39         rts                 ;return subroutine
;*************************************;
;param synthA
;*************************************;
;SNALD3
7E76 : CE 7F A5   ldx  #$7FA5         ;load X with 7FA5h (TBL3)
7E79 : 20 E5      bra  L7E60          ;branch always SNALDX
;*************************************;
;param B for SYNTHA
;*************************************;
;PARAMB
7E7B : 4F         clra                ;clear A
;PARAMB1
7E7C : 4C         inca                ;incr A
7E7D : 81 2A      cmpa  #$2A          ;compare A with 2Ah
7E7F : 27 19      beq  L7E9A          ;branch Z=1 SNALDW
7E81 : 97 00      staa  $00           ;store A in addr 00
7E83 : C6 03      ldab  #$03          ;load B with 03h
7E85 : 8D 9C      bsr  L7E23          ;branch sub SYNTHA
7E87 : 20 F3      bra  L7E7C          ;branch always PARAMB1
;*************************************;
;data loader A for SYNTHA #4
;*************************************;
;SNALD4
7E89 : CE 7F A9   ldx  #$7FA9         ;load X with 7FA9h (TBL4)
;SNALD41
7E8C : 8D DB      bsr  L7E69          ;branch sub PMOVE
;SNALD42
7E8E : 97 00      staa  $00           ;store A in addr 00
7E90 : D6 08      ldab  $08           ;load B with addr 08
7E92 : 8D 8F      bsr  L7E23          ;branch sub SYNTHA
7E94 : 90 09      suba  $09           ;sub A with addr 09
7E96 : 91 0A      cmpa  $0A           ;compare A with addr 0A
7E98 : 2E F4      bgt  L7E8E          ;branch Z+(N(+)V)=0 SNALD42
;SNALDW
7E9A : 3E         wai                 ;wait interrupts, PC+1
;*************************************;
;data loader A for SYNTHA #5
;*************************************;
;SNALD5
7E9B : CE 7F AD   ldx  #$7FAD         ;load X with 7FADh (TBL5)
7E9E : 20 EC      bra  L7E8C          ;branch always SNALD41
;*************************************;
;PChime - early (pre) Chime synth, uses SNDTBL,WAVFRM tables
;*************************************; 
;PCHIME
7EA0 : D7 00      stab  $00           ;store B in addr 00
7EA2 : CE 00 0C   ldx  #$000C         ;load X with addr 000C
7EA5 : DF 03      stx  $03            ;store X in addr 03
7EA7 : CE 7F C1   ldx  #$7FC1         ;load X with 7FC1h (SNDTBL1)
7EAA : C6 10      ldab  #$10          ;load B with 10h
;PCHIM1
7EAC : A6 00      ldaa  $00,x         ;load A with X+00h
7EAE : 08         inx                 ;incr X
7EAF : DF 05      stx  $05            ;store X in addr 05
7EB1 : DE 03      ldx  $03            ;load X with addr 03
7EB3 : A7 00      staa  $00,x         ;store A in X+00h
7EB5 : 08         inx                 ;incr X
7EB6 : DF 03      stx  $03            ;store X in addr 03
7EB8 : DE 05      ldx  $05            ;load X with addr 05
7EBA : 5A         decb                ;decr B
7EBB : 26 EF      bne  L7EAC          ;branch Z=0 PCHIM1
7EBD : CE 7F E2   ldx  #$7FE2         ;load X with 7FE2h (WAVFRM)
7EC0 : E6 00      ldab  $00,x         ;load B with X+00h
;PCHIM2
7EC2 : D7 09      stab  $09           ;store B in addr 09
7EC4 : DF 05      stx  $05            ;store X in addr 05
;PCHIM3
7EC6 : CE 00 0C   ldx  #$000C         ;load X with 000Ch
7EC9 : C6 08      ldab  #$08          ;load B with 08h
7ECB : D7 07      stab  $07           ;store B in addr 07
;PCHIM4 
7ECD : A6 00      ldaa  $00,x         ;load A with X+00h
7ECF : D6 00      ldab  $00           ;load B with addr 00
7ED1 : 7D 00 09   tst  $0009          ;test addr 0009
7ED4 : 26 06      bne  L7EDC          ;branch Z=0 PCHIM5
7ED6 : A0 08      suba  $08,x         ;sub A with X+08h
7ED8 : A7 00      staa  $00,x         ;store A in X+00h
7EDA : C0 03      subb  #$03          ;sub B with 03h
;PCHIM5
7EDC : 08         inx                 ;incr X
7EDD : B7 04 00   staa  $0400         ;store A in DAC output SOUND
;PCHIM6
7EE0 : 5A         decb                ;decr B
7EE1 : 26 FD      bne  L7EE0          ;branch Z=0 PCHIM6
7EE3 : 7A 00 07   dec  $0007          ;decr addr 0007
7EE6 : 26 E5      bne  L7ECD          ;branch Z=0 PCHIM4
7EE8 : 7A 00 09   dec  $0009          ;decr addr 0009
7EEB : 2A D9      bpl  L7EC6          ;branch N=0 PCHIM3
7EED : DE 05      ldx  $05            ;load X with addr 05
7EEF : 08         inx                 ;incr X
7EF0 : E6 00      ldab  $00,x         ;load B with X+00h
7EF2 : 26 CE      bne  L7EC2          ;branch Z=0 PCHIM2
;PCHIMX
7EF4 : 3E         wai                 ;wait interrupts, PC+1
;*************************************;
;early version (pre) of Tilt sound
;*************************************;
;PTILT
7EF5 : 4F         clra                ;clear A
7EF6 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
7EF9 : CE 00 DF   ldx  #$00DF         ;load X with 00DFh
;PTILT1
7EFC : C6 20      ldab  #$20          ;load B with 20h
7EFE : 8D 57      bsr  L7F57          ;branch sub ADDBX
;PTILT2
7F00 : 09         dex                 ;decr X
7F01 : 26 FD      bne  L7F00          ;branch Z=0 PTILT2
7F03 : 73 04 00   com  $0400          ;complement 1s DAC output SOUND
;PTILT3
7F06 : 4A         deca                ;decr A
7F07 : 26 FD      bne  L7F06          ;branch Z=0 PTILT3
7F09 : 73 04 00   com  $0400          ;complement 1s DAC output SOUND
7F0C : D6 03      ldab  $03           ;load B with addr 03
7F0E : DE 03      ldx  $03            ;load X with addr 03
7F10 : C5 10      bitb  #$10          ;bit test B with 10h
7F12 : 27 E8      beq  L7EFC          ;branch Z=1 PTILT1
7F14 : 3E         wai                 ;wait interrupts, PC+1
;*************************************;
;Interrupt Processing
;*************************************;
;IRQ
7F15 : 8E 00 7F   lds  #$007F         ;load SP with value 007Fh (#ENDRAM)
7F18 : F6 04 02   ldab  $0402         ;load B with PIA sound select
7F1B : 0E         cli                 ;clear interrupts I=0
7F1C : 2B 0B      bmi  L7F29          ;branch N=1 IRQ2
7F1E : 96 0B      ldaa  $0B           ;load A with addr 0B
7F20 : 26 03      bne  L7F25          ;branch Z=0 IRQ1
7F22 : D7 0B      stab  $0B           ;store B in addr 0B
7F24 : 3E         wai                 ;wait interrupts, PC+1
;IRQ1
7F25 : 7F 00 0B   clr  $000B          ;clear addr 000B
7F28 : 3E         wai                 ;wait interrupts, PC+1
;IRQ2
7F29 : 53         comb                ;complement 1s B
7F2A : 17         tba                 ;transfer A to B
7F2B : C5 10      bitb  #$10          ;bit test B with 10h
7F2D : 26 C6      bne  L7EF5          ;branch Z=0 PTILT
7F2F : C5 20      bitb  #$20          ;bit test B with 20h
7F31 : 27 05      beq  L7F38          ;branch Z=1 IRQ3
7F33 : C6 B9      ldab  #$B9          ;load B with B9h
7F35 : 7E 7E A0   jmp  L7EA0          ;jump PCHIME
;IRQ3
7F38 : C4 0F      andb  #$0F          ;and B with 0Fh
7F3A : 27 B8      beq  L7EF4          ;branch Z=1 PCHIMX (PC at PTILT)
7F3C : 5A         decb                ;decr B
7F3D : 85 40      bita  #$40          ;bit test A with 40h
7F3F : 26 0E      bne  L7F4F          ;branch Z=0 IRQ5
7F41 : 96 0B      ldaa  $0B           ;load A with addr 0B
7F43 : 26 0A      bne  L7F4F          ;branch Z=0 IRQ5
7F45 : CE 7F B1   ldx  #$7FB1         ;load X with 7FB1h (JMPTBL)
7F48 : 58         aslb                ;arith shift left B (sound select offset)
;IRQ4
7F49 : 8D 0C      bsr  L7F57          ;branch sub ADDBX
7F4B : EE 00      ldx  $00,x          ;load X with X+00h
7F4D : 6E 00      jmp  $00,x          ;jump X+00h
;IRQ5
7F4F : CE 7F DA   ldx  #$7FDA         ;load X with 7FDAh (SNDTBL3)
7F52 : 8D 03      bsr  L7F57          ;branch sub ADDBX
7F54 : 7E 7E A0   jmp  L7EA0          ;jump PCHIME
;*************************************;
;Add B to Index Register
;*************************************;
;ADDBX 
7F57 : DF 03      stx  $03            ;store X in addr 03
7F59 : DB 04      addb  $04           ;add B with addr 04
7F5B : D7 04      stab  $04           ;store B in addr 04
7F5D : D6 03      ldab  $03           ;load B with addr 03
7F5F : C9 00      adcb  #$00          ;add C+B + 00h
7F61 : D7 03      stab  $03           ;store B in addr 03
7F63 : DE 03      ldx  $03            ;load X with addr 03
7F65 : E6 00      ldab  $00,x         ;load B with X+00h
7F67 : 39         rts                 ;return subroutine
;*************************************;
;Diagnostic Processing Here 
;*************************************;
;NMI
7F68 : 0F         sei                 ;set interrupt mask
7F69 : CE 7F FF   ldx  #$7FFF         ;load X with 7FFFh
7F6C : 4F         clra                ;clear A
;NMI1
7F6D : A9 00      adca  $00,x         ;add C+A + X+00h
7F6F : 09         dex                 ;decr X
7F70 : 8C 7E 00   cpx  #$7E00         ;compare X with 7E00h 
7F73 : 26 F8      bne  L7F6D          ;branch Z=0 NMI1
7F75 : A1 00      cmpa  $00,x         ;compare A with X+00h
7F77 : 27 08      beq  L7F81          ;branch Z=1 NMI4
7F79 : 3E         wai                 ;wait interrupts, PC+1
;NMI2
7F7A : CE FF FF   ldx  #$FFFF         ;load X with FFFFh
;NMI3
7F7D : 09         dex                 ;decr X
7F7E : 26 FD      bne  L7F7D          ;branch Z=0 NMI3
7F80 : 39         rts                 ;return subroutine
;NMI4
7F81 : 8D F7      bsr  L7F7A          ;branch sub NMI2
7F83 : 86 3C      ldaa  #$3C          ;load A with 3Ch(CA2 set init high, no IRQs)
7F85 : B7 04 01   staa  $0401         ;store A in addr 0401(PIA1 CR port A)
7F88 : B7 04 03   staa  $0403         ;store A in addr 0403(PIA1 CR port B)
7F8B : 8D ED      bsr  L7F7A          ;branch sub NMI2
7F8D : 86 34      ldaa  #$34          ;load A with 34h
7F8F : B7 04 01   staa  $0401         ;store A in addr 0401(PIA1 CR port A)
7F92 : B7 04 03   staa  $0403         ;store A in addr 0403(PIA1 CR port B)
;NMI5
7F95 : 97 00      staa  $00           ;store A in addr 00
7F97 : 16         tab                 ;transfer A to B
7F98 : BD 7E 23   jsr  L7E23          ;jump sub SYNTHA
7F9B : 20 F8      bra  L7F95          ;branch always NMI5
;*************************************;
;SYNTHA tables
;*************************************; 
7F9D : 14 20 02 04                    ;TBL1
;
7FA1 : 0A 12 05 04                    ;TBL2
;
7FA5 : 01 2C 03 01                    ;TBL3
;
7FA9 : 2C 08 03 00                    ;TBL4
;
7FAD : 7F 02 01 10                    ;TBL5
;*************************************;
;Special Routine Jump Table 
;*************************************;
;JMPTBL
7FB1 : 7E 89                          ;SNALD4
7FB3 : 7E 7B                          ;PARAMB
7FB5 : 7E 89                          ;SNALD4
7FB7 : 7E 76                          ;SNALD3
7FB9 : 7E 89                          ;SNALD4
7FBB : 7E 89                          ;SNALD4
7FBD : 7E 89                          ;SNALD4
7FBF : 7E 9B                          ;SNALD5
;*************************************;
;PCHIME tables
;*************************************;
7FC1 : DA FF DA 80 26 01 26 80        ;SNDTBL1
7FC9 : 07 0A 07 00 F9 F6 F9 00        ;
;
7FD1 : AD BF AD 80 53 41 53 80        ;SNDTBL2
7FD9 : 00                             ;
;
7FDA : 50 3A 00 33 00 00 00 2C        ;SNDTBL3
;
7FE2 : 08 03 02 01 02 03 04 05        ;WAVFRM
7FEA : 06 0A 1E 32 70 00              ;
;*************************************;
;zero padding
7FF0 : 00 00 00 00 00 00 00 00        ;
;*************************************;
;Motorola vector table
;*************************************; 
7FF8 : 7F 15                          ;IRQ
7FFA : 7E 01                          ;RESET SWI (software)  
7FFC : 7F 68                          ;NMI
7FFE : 7E 01                          ;RESET (hardware) 
;*************************************;






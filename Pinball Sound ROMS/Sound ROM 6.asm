        ;
        ;  Disassembled by:
        ;    DASMx object code disassembler
        ;    (c) Copyright 1996-2003   Conquest Consultants
        ;    Version 1.40 (Oct 18 2003)
        ;
        ;  File:    Pharaoh.716
        ;
        ;  Size:    2048 bytes
        ;  Checksum:  BF93
        ;  CRC-32:    B0E3A04B
        ;
        ;  Date:    Tue Mar 30 12:47:15 2021
        ;
        ;  CPU:    Motorola 6800 (6800/6802/6808 family)
        ;
        ; Pinball Sound and Speech ROM 6
        ;
        ; first version of ORGAN
        ;
        ; v. similar to Algar, Barracora ROM, diff is Speech ROMs used in this game for some sound selects
        ; game dated 05/1981 (4 months earlier than Barracora)
        ; copyright message on speech rom chip 4 (COPYRIGHT-WILLIAMS ELECTRONICS-4/23/81-JK-)
        ;
        ;Speech ROM addrs IC7 $B000, IC5 $C000, IC6 $D000, IC4 $E000
        ; IRQ has jump sub DFFD - Speech ROM IC6
        ;    and  jump sub EFFD - Speech ROM IC4
        ; Speech data SPCH ROM -> sound PIA CA2 (0401) (pin 39) -> IC1 Dig In (pin 12)
        ; CA2 - speech data
        ; CB2 - speech clock
        ;
        ;updated 17 May 2021
        ;
org  $F800
        ;
F800 : AA                             ;checksum byte
;*************************************;
;RESET, power on
;*************************************; 
F801 : 0F         sei                 ;set interrupt mask  
F802 : 8E 00 7F   lds #$007F          ;load stack pointer with 007Fh  
F805 : CE 04 00   ldx #$0400          ;load X with 0400h PIA addr
F808 : 6F 01      clr $01,x           ;clr (00) X + 01h (0401) PIA CR port A
F80A : 6F 03      clr $03,x           ;clr (00) X + 03h (0403) PIA CR port B
F80C : 86 FF      ldaa  #$FF          ;load A with FFh
F80E : A7 00      staa  $00,x         ;store A in addr X + 00h (0400) PIA port A out (DAC sound)
F810 : C6 80      ldab  #$80          ;load B with 80h
F812 : E7 02      stab  $02,x         ;store B in addr X + 00h (0402) PIA port B in (sound select)
F814 : 86 37      ldaa  #$37          ;load A with 37h 
F816 : A7 03      staa  $03,x         ;store A in addr X + 03h (0403) PIA CR port B
F818 : 86 3C      ldaa  #$3C          ;load A with 3Ch
F81A : A7 01      staa  $01,x         ;store A in addr X + 01h (0401) PIA1 CR port A
F81C : E7 02      stab  $02,x         ;store B in addr X + 02h (0402) PIA1 CR port A
F81E : CE 00 7F   ldx #$007F          ;load X with value 007F
;RSET1:
F821 : 6F 00      clr  $00,x          ;clear addr X + 00h
F823 : 09         dex                 ;decr X
F824 : 26 FB      bne  LF821          ;branch if Z=0 RSET1 
F826 : 86 3C      ldaa  #$3C          ;load A with value 3Ch
F828 : 97 16      staa  X0016         ;store A in addr 16
F82A : 0E         cli                 ;clear interrupt I=0
;STDBY1
F82B : 20 FE      bra  LF82B          ;branch always here STDBY1
;*************************************;
;Vari Loader 
;*************************************;
;VARILD
F82D : 16         tab                 ;transfer A to B
F82E : 48         asla                ;arith shift left A
F82F : 48         asla                ;arith shift left A 
F830 : 48         asla                ;arith shift left A
F831 : 1B         aba                 ;A = A + B 
F832 : CE 00 20   ldx  #$0020         ;load X with value 0020h
F835 : DF 1C      stx  $1C            ;store X in addr 1C
F837 : CE FC 18   ldx  #$FC18         ;load X with value FC18h (VVECT SAW)
F83A : BD FB 8F   jsr  LFB8F          ;jump sub ADDX
F83D : C6 09      ldab  #$09          ;load B with value 09h
F83F : 7E F9 28   jmp  LF928          ;jump TRANS
;*************************************;
;Variable Duty Cycle Square Wave Routine
;*************************************;
;VARI
F842 : 96 28      ldaa  $28           ;load A with value in addr 28
F844 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
;VAR0
F847 : DE 20      ldx  $20            ;load X with value from addr 20
F849 : DF 29      stx  $29            ;store X in addr 29
;V0
F84B : DE 25      ldx  $25            ;load X with value in addr 25
;V0LP
F84D : 96 29      ldaa  $29           ;load A with value in addr 29
F84F : 73 04 00   com  $0400          ;complement 1s in DAC output SOUND
;V1
F852 : 09         dex                 ;decr X
F853 : 27 10      beq  LF865          ;branch if Z=1 VSWEEP
F855 : 4A         deca                ;decr A
F856 : 26 FA      bne  LF852          ;branch if Z=0 V1
F858 : 96 2A      ldaa  $2A           ;load A with value at addr 2A
F85A : 73 04 00   com  $0400          ;complement 1s in DAC output SOUND
;V2
F85D : 09         dex                 ;decr X
F85E : 27 05      beq  LF865          ;branch if Z=1 VSWEEP
F860 : 4A         deca                ;decr A
F861 : 26 FA      bne  LF85D          ;branch if Z=0 V2
F863 : 20 E8      bra  LF84D          ;branch always V0LP
;VSWEEP
F865 : B6 04 00   ldaa  $0400         ;load A with value at DAC output SOUND
F868 : 2B 01      bmi  LF86B          ;branch if N=1 VS1
F86A : 43         coma                ;complement 1s A
;VS1
F86B : 8B 00      adda  #$00          ;add A with value 00h
F86D : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F870 : 96 29      ldaa  $29           ;load A with value in addr 29
F872 : 9B 22      adda  $22           ;add A with value in addr 22
F874 : 97 29      staa  $29           ;store A in addr 29
F876 : 96 2A      ldaa  $2A           ;load A with value in addr 2A
F878 : 9B 23      adda  $23           ;add A with value in addr 23
F87A : 97 2A      staa  $2A           ;store A in addr 2A
F87C : 91 24      cmpa  $24           ;compare A with value in addr 24
F87E : 26 CB      bne  LF84B          ;branch if Z=0 V0
F880 : 96 27      ldaa  $27           ;load A with value in addr 27
F882 : 27 06      beq  LF88A          ;branch if Z=1 VARX
F884 : 9B 20      adda  $20           ;add A with value in addr 20
F886 : 97 20      staa  $20           ;store A in addr 20
F888 : 26 BD      bne  LF847          ;branch if Z=0 VAR0
;VARX
F88A : 39         rts                 ;return subroutine
;*************************************;
;Organ Tune 
;*************************************;
;ORGANT 
F88B : 86 01      ldaa  #$01          ;load A with value 01h
F88D : 20 06      bra  LF895          ;branch always ORGNT1
;ORGLD1
F88F : 86 02      ldaa  #$02          ;load A with value 02h
F891 : 20 02      bra  LF895          ;branch always ORGNT1
;ORGLD2 
F893 : 86 03      ldaa  #$03          ;load A with value 03h
;ORGNT1
F895 : 7F 00 20   clr  $0020          ;clear addr 0020
F898 : 97 1E      staa  $1E           ;store A in addr 1E
F89A : CE FE CD   ldx  #$FECD         ;load X with value FECDh (ORGTAB)
;ORGNT2
F89D : A6 00      ldaa  $00,x         ;load A with value in addr X + 00h
F89F : 27 2D      beq  LF8CE          ;branch Z=1 ORGNTX
F8A1 : 7A 00 1E   dec  $001E          ;decr value in addr 001E
F8A4 : 27 06      beq  LF8AC          ;branch Z=1 ORGNT3
F8A6 : 4C         inca                ;incr A
F8A7 : BD FB 8F   jsr  LFB8F          ;jump sub ADDX
F8AA : 20 F1      bra  LF89D          ;branch always ORGNT2
;ORGNT3 
F8AC : 08         inx                 ;incr X
F8AD : DF 1C      stx  $1C            ;store X in addr ADDX
F8B2 : DF 1A      stx  $1A            ;store X in addr 1A
F8B4 : DE 1C      ldx  $1C            ;load X with value in addr 1C
;ORGNT4 
F8B6 : A6 00      ldaa  $00,x         ;load A with value in addr X + 00h
F8B8 : 97 23      staa  $23           ;store A in addr 23
F8BA : A6 01      ldaa  $01,x         ;load A with value at X + 01h
F8BC : EE 02      ldx  $02,x          ;load X with value at addr X + 02h
F8BE : DF 21      stx  $21            ;store X in addr 21
F8C0 : 8D 0F      bsr  LF8D1          ;branch sub ORGANL
F8C2 : DE 1C      ldx  $1C            ;load X with value in addr 1C
F8C4 : 08         inx                 ;incr X
F8C5 : 08         inx                 ;incr X
F8C6 : 08         inx                 ;incr X
F8C7 : 08         inx                 ;incr X
F8C8 : DF 1C      stx  $1C            ;store X in addr 1C
F8CA : 9C 1A      cpx  $1A            ;compare X with value in addr 1A
F8CC : 26 E8      bne  LF8B6          ;branch Z=0 ORGNT4
;ORGNTX
F8CE : 7E FB 33   jmp  LFB33          ;jump IRQ8
;*************************************;
;Organ Loader
;*************************************;
;ORGANL
F8D1 : CE 00 24   ldx  #$0024         ;load X with value 0024h (#RDELAY)(LOCRAM)
;LDLP
F8D4 : 81 00      cmpa  #$00          ;compare A with value 00h
F8D6 : 27 15      beq  LF8ED          ;branch if Z=1 LD1
F8D8 : 81 03      cmpa  #$03          ;compare A with value 03h
F8DA : 27 09      beq  LF8E5          ;branch if Z=1 LD2
F8DC : C6 01      ldab  #$01          ;load B with value 01h
F8DE : E7 00      stab  $00,x         ;store B in addr X + 00h
F8E0 : 08         inx                 ;incr X
F8E1 : 80 02      suba  #$02          ;A = A - 02h 
F8E3 : 20 EF      bra  LF8D4          ;branch always LDLP
;LD2 - writes 91 00 (cmpa $00)
F8E5 : C6 91      ldab  #$91          ;load B with value 91h
F8E7 : E7 00      stab  $00,x         ;store B in addr X + 00h
F8E9 : 6F 01      clr  $01,x          ;clear addr X + 01h
F8EB : 08         inx                 ;incr X
F8EC : 08         inx                 ;incr X
;LD1 - writes 7E F8 FB (jmp $F8FB)
F8ED : C6 7E      ldab  #$7E          ;load B with value 7Eh
F8EF : E7 00      stab  $00,x         ;store B in addr X + 00h
F8F1 : C6 F8      ldab  #$F8          ;load B with value F8h
F8F3 : E7 01      stab  $01,x         ;store B in addr X + 01h
F8F5 : C6 FB      ldab  #$FB          ;load B with value FBh
F8F7 : E7 02      stab  $02,x         ;store B in addr X + 02h
;*************************************;
;Organ Routine
;*************************************;
;DUR=DURATION, OSCILLATOR MASK
;ORGAN
F8F9 : DE 21      ldx  $21            ;load X with value in addr 21
;ORGAN1 - stores 7E F8 FB )jmp $F8FB)
F8FB : 4F         clra                ;clear A
F8FC : F6 00 1F   ldab  $001F         ;load B with value in addr 001F
F8FF : 5C         incb                ;incr B
F900 : D7 1F      stab  $1F           ;store B in addr 1F
F902 : D4 23      andb  $23           ;and B with value in addr 23
F904 : 54         lsrb                ;logic shift right B (bit7=0)
F905 : 89 00      adca  #$00          ;A = Carry + A + 00h 
F907 : 54         lsrb                ;logic shift right B (bit7=0)
F908 : 89 00      adca  #$00          ;A = Carry + A + 00h 
F90A : 54         lsrb                ;logic shift right B (bit7=0)
F90B : 89 00      adca  #$00          ;A = Carry + A + 00h 
F90D : 54         lsrb                ;logic shift right B (bit7=0)
F90E : 89 00      adca  #$00          ;A = Carry + A + 00h 
F910 : 54         lsrb                ;logic shift right B (bit7=0)
F911 : 89 00      adca  #$00          ;A = Carry + A + 00h 
F913 : 54         lsrb                ;logic shift right B (bit7=0)
F914 : 89 00      adca  #$00          ;A = Carry + A + 00h 
F916 : 54         lsrb                ;logic shift right B (bit7=0)
F917 : 89 00      adca  #$00          ;A = Carry + A + 00h 
F919 : 48         asla                ;arith shift left A (bit0 is 0)
F91A : 48         asla                ;arith shift left A (bit0 is 0)
F91B : 48         asla                ;arith shift left A (bit0 is 0)
F91C : 48         asla                ;arith shift left A (bit0 is 0)
F91D : 48         asla                ;arith shift left A (bit0 is 0)
F91E : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F921 : 09         dex                 ;decr X
F922 : 27 03      beq  LF927          ;branch Z=1 ORGAN2
F924 : 7E 00 24   jmp  L0024          ;jump addr 0024 (flood write location)
;ORGAN2
F927 : 39         rts                 ;return subroutine
;*************************************;
;Parameter Transfer 
;*************************************;
;TRANS
F928 : 36         psha                ;push A into stack then SP - 1
;TRANS1
F929 : A6 00      ldaa  $00,x         ;load A with value at addr X + 00h
F92B : DF 1A      stx  $1A            ;store X in addr 1A
F92D : DE 1C      ldx  $1C            ;load X with value at addr 1C
F92F : A7 00      staa  $00,x         ;store A in addr X + 00h
F931 : 08         inx                 ;incr X
F932 : DF 1C      stx  $1C            ;store X in addr 1C
F934 : DE 1A      ldx  $1A            ;load X with value at addr 1A
F936 : 08         inx                 ;incr X
F937 : 5A         decb                ;decr B
F938 : 26 EF      bne  LF929          ;branch Z=0 TRANS1
F93A : 32         pula                ;SP + 1 pull stack into A
F93B : 39         rts                 ;return subroutine
;*************************************;
;KNOCKER ROUTINE
;*************************************;
;KNOCK:
F93C : CE FC 72   ldx  #$FC72         ;load X with value FC72h (KNKTAB)
F93F : DF 22      stx  $22            ;store X in addr 22(SNDTMP)
;SQLP - main loop
F941 : DE 22      ldx  $22            ;load X with value at addr 22(SNDTMP)
F943 : A6 00      ldaa  $00,x         ;load A with value at addr X + 00h
F945 : 27 33      beq  LF97A          ;branch Z=1 SYN37
F947 : E6 01      ldab  $01,x         ;load B with value at addr X + 01h
F949 : C4 F0      andb  #$F0          ;and B with value F0h
F94B : D7 21      stab  $21           ;store B in addr 21(AMP)
F94D : E6 01      ldab  $01,x         ;load B with value at addr X + 01h
F94F : 08         inx                 ;incr X
F950 : 08         inx                 ;incr X
F951 : DF 22      stx  $22            ;store X in addr 22(SNDTMP)
F953 : 97 20      staa  $20           ;store A in addr 20(PERIOD)
F955 : C4 0F      andb  #$0F          ;and B with value 0Fh
;LP0 - 2nd loop
F957 : 96 21      ldaa  $21           ;load A with value at addr 21(AMP)
F959 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
F95C : 96 20      ldaa  $20           ;load A with value at addr 20(PERIOD)
;LP1 
F95E : CE 00 05   ldx  #$0005         ;load X with value at addr 0005 (DELAY)
;LP11 
F961 : 09         dex                 ;decr X
F962 : 26 FD      bne  LF961          ;branch Z=0 LP11
F964 : 4A         deca                ;decr A
F965 : 26 F7      bne  LF95E          ;branch Z=0 LP1
F967 : 7F 04 00   clr  $0400          ;clear addr DAC output SOUND
F96A : 96 20      ldaa  $20           ;load A with value at addr 20
;LP2
F96C : CE 00 05   ldx  #$0005         ;load X with value at addr 0005
;LP22
F96F : 09         dex                 ;decr X
F970 : 26 FD      bne  LF96F          ;branch Z=0 LP22
F972 : 4A         deca                ;decr A
F973 : 26 F7      bne  LF96C          ;branch Z=0 LP2
F975 : 5A         decb                ;decr B
F976 : 26 DF      bne  LF957          ;branch Z=0 LP0
;end 2nd loop
F978 : 20 C7      bra  LF941          ;branch always SQLP
;end main loop
F97A : 39         rts                 ;return subroutine
;*************************************;
;Background End Routine
;*************************************;
;BGEND
F97B : 7F 00 10   clr  $0010          ;clear addr 0010(BG1FLG)
F97E : 7F 00 11   clr  $0011          ;clear addr 0011(BG2FLG)
F981 : 39          rts                ;return subroutine
;*************************************;
;Background Sound #2 increment
;*************************************;
;BG2INC
F982 : 96 10      ldaa  $10           ;load A with value in addr 10
F984 : 8A 80      oraa  #$80          ;or A with value 80h
F986 : 97 10      staa  $10           ;store A in addr 10(BG1FLG)
F988 : 96 11      ldaa  $11           ;load A with value in addr 11 (BG2FLG)
F98A : 84 3F      anda  #$3F          ;and A with value 3Fh
F98C : 81 1D      cmpa  #$1D          ;compare A with value 1Dh(#BG2MAX)
F98E : 2E 02      bgt  LF992          ;branch Z+(N+V)=0 BG2IO
F990 : 86 1F      ldaa  #$1F          ;load A with value 1F
;BG2IO
F992 : 4C         inca                ;incr A
F993 : 97 11      staa  $11           ;store A in addr 11(BG2FLG)
F995 : 39         rts                 ;return subroutine
;*************************************;
;Background 2 Routine
;*************************************;
;BG2 
F996 : 86 04      ldaa  #$04          ;load A with value 04h (#(TRBV-SVTAB)/7) (GET SOUND)
F998 : BD F9 AB   jsr  LF9AB          ;jump sub GWLD
F99B : 96 11      ldaa  $11           ;load A with value in addr 11 (BG2FLG)
F99D : 48         asla                ;arith shift left A (bit0 is 0)
F99E : 48         asla                ;arith shift left A (bit0 is 0)
F99F : 43         coma                ;complement 1s A
F9A0 : BD FA 65   jsr  LFA65          ;jump sub GEND60
;BG2LP
F9A3 : 7C 00 24   inc  $0024          ;incr value in addr 0024 (GDCNT)
F9A6 : BD FA 67   jsr  LFA67          ;jump sub GEND61
F9A9 : 20 F8      bra  LF9A3          ;branch always BG2LP
;*************************************;
;GWAVE Loader
;*************************************;
;GWLD:
F9AB : 16         tab                 ;transfer A to B (A unchanged)
F9AC : 58         aslb                ;arith shift left B (bit0 is 0)
F9AD : 1B         aba                 ;A = A + B
F9AE : 1B         aba                 ;A = A + B
F9AF : 1B         aba                 ;A = A + B
F9B0 : CE FD 87   ldx  #$FD87         ;load X with value FD87h (SVTAB)(SOUND VECTOR TABLE)
F9B3 : BD FB 8F   jsr  LFB8F          ;jump sub ADDX
F9B6 : A6 00      ldaa  $00,x         ;load A with value in addr X + 00h
F9B8 : 16         tab                 ;transfer A to B (A unchanged)
F9B9 : 84 0F      anda  #$0F          ;and A with value 0Fh
F9BB : 97 21      staa  $21           ;store A in addr 21
F9BD : 54         lsrb                ;logic shift right B (bit7=0)
F9BE : 54         lsrb                ;logic shift right B (bit7=0)
F9BF : 54         lsrb                ;logic shift right B (bit7=0)
F9C0 : 54         lsrb                ;logic shift right B (bit7=0)
F9C1 : D7 20      stab  $20           ;store B in addr 20
F9C3 : A6 01      ldaa  $01,x         ;load A with value in addr X + 00h
F9C5 : 16         tab                 ;transfer A to B (A unchanged)
F9C6 : 54         lsrb                ;logic shift right B (bit7=0)
F9C7 : 54         lsrb                ;logic shift right B (bit7=0)
F9C8 : 54         lsrb                ;logic shift right B (bit7=0)
F9C9 : 54         lsrb                ;logic shift right B (bit7=0)
F9CA : D7 22      stab  $22           ;store B in addr 22
F9CC : 84 0F      anda  #$0F          ;and A with value 0Fh    
F9CE : 97 1E      staa  $1E           ;store A in addr 1E
F9D0 : DF 18      stx  $18            ;store X in addr 18
F9D2 : CE FC 90   ldx  #$FC90         ;load X with value FC90h (GWVTAB)(CALC WAVEFORM ADDR)
;GWLD2 PRM53
F9D5 : 7A 00 1E   dec  $001E          ;decr value in addr 001E
F9D8 : 2B 08      bmi  LF9E2          ;branch if N=1
F9DA : A6 00      ldaa  $00,x         ;load A with value in addr X + 00h
F9DC : 4C         inca                ;incr A
F9DD : BD FB 8F   jsr  LFB8F          ;jump sub ADDX
F9E0 : 20 F3      bra  LF9D5          ;branch always PRM53
;PRM54
F9E2 : DF 25      stx  $25            ;store X in addr 25
F9E4 : BD FA A1   jsr  LFAA1          ;jump sub PARAM7
F9E7 : DE 18      ldx  $18            ;load X with value in addr 18
F9E9 : A6 02      ldaa  $02,x         ;load A with value at addr X + 02h
F9EB : 97 27      staa  $27           ;store A in addr 27
F9ED : BD FA B3   jsr  LFAB3          ;jump sub PARAM8
F9F0 : DE 18      ldx  $18            ;load X with value in addr 18
F9F2 : A6 03      ldaa  $03,x         ;load A with value at addr X + 03h
F9F4 : 97 23      staa  $23           ;store A in addr 23     
F9F6 : A6 04      ldaa  $04,x         ;load A with value at addr X + 04h
F9F8 : 97 24      staa  $24           ;store A in addr 24
F9FA : A6 05      ldaa  $05,x         ;load A with value at addr X + 05h
F9FC : 16         tab                 ;transfer A to B
F9FD : A6 06      ldaa  $06,x         ;load A with value in addr X + 06h
F9FF : CE FE 00   ldx  #$FE00         ;load X with value FE00h (#GFRTAB)
FA02 : BD FB 8F   jsr  LFB8F          ;jump sub ADDX
FA05 : 17         tba                 ;transfer B to A (B unchanged)
FA06 : DF 28      stx  $28            ;store X in addr 28
FA08 : 7F 00 30   clr  $0030          ;clear addr 0030
FA0B : BD FB 8F   jsr  LFB8F          ;jump sub ADDX
FA0E : DF 2A      stx  $2A            ;store X in addr 2A
FA10 : 39         rts                 ;return subroutine
;*************************************;
;GWAVE routine
;*************************************;
;ACCA=Freq Pattern Length, X=Freq Pattern Addr
;GWAVE
FA11 : 96 20      ldaa  $20           ;load A with value in addr 20
FA13 : 97 2F      staa  $2F           ;store A in addr 2F
;GWT4
FA15 : DE 28      ldx  $28            ;load X with value in addr 28
FA17 : DF 1A      stx  $1A            ;store X in addr 1A
;GPLAY
FA19 : DE 1A      ldx  $1A            ;load X with value in addr 1A
FA1B : A6 00      ldaa  $00,x         ;load A with value in addr X + 00h
FA1D : 9B 30      adda  $30           ;add A with value in addr 30
FA1F : 97 2E      staa  $2E           ;store A in addr 2E
FA21 : 9C 2A      cpx  $2A            ;compare X with value in addr 2A
FA23 : 27 26      beq  LFA4B          ;branch if Z=1 GEND
FA25 : D6 21      ldab  $21           ;load B with value in addr 21
FA27 : 08         inx                 ;incr X
FA28 : DF 1A      stx  $1A            ;store X in addr 1A
;GOUT
FA2A : CE 00 31   ldx  #$0031         ;load X with value 0031h
;GOUTLP
FA2D : 96 2E      ldaa  $2E           ;load A with value in 2E
;GPRLP
FA2F : 4A         deca                ;decr A
FA30 : 26 FD      bne  LFA2F          ;branch if Z=0 GPRLP
FA32 : A6 00      ldaa  $00,x         ;load A with value in addr X + 00h
FA34 : B7 04 00   staa  $0400         ;store A in DAC output SOUND
;GPR1
FA37 : 08         inx                 ;incr X
FA38 : 9C 2C      cpx  $2C            ;compare X with value in addr 2C
FA3A : 26 F1      bne  LFA2D          ;branch if Z=0 GOUTLP
FA3C : 5A         decb                ;decr B
FA3D : 27 DA      beq  LFA19          ;branch if Z=1 GPLAY
FA3F : 08         inx                 ;incr X
FA40 : 09         dex                 ;decr X
FA41 : 08         inx                 ;incr X
FA42 : 09         dex                 ;decr X
FA43 : 08         inx                 ;incr X
FA44 : 09         dex                 ;decr X
FA45 : 08         inx                 ;incr X
FA46 : 09         dex                 ;4 cycles (32 cycles total)
FA47 : 01         nop                 ;no op
FA48 : 01         nop                 ;2 cycles 
FA49 : 20 DF      bra  LFA2A          ;branch always GOUT
;GEND
FA4B : 96 22      ldaa  $22           ;load A with value in addr 22
FA4D : 8D 64      bsr  LFAB3          ;branch sub WVDECA
;GEND40
FA4F : 7A 00 2F   dec  X002F          ;decr value in addr 002F
FA52 : 26 C1      bne  LFA15          ;branch if Z=0 GWT4
FA54 : 96 13      ldaa  $13           ;load A with value in addr 13
FA56 : 9A 14      oraa  $14           ;OR A with value in addr 14
FA58 : 26 46      bne  LFAA0          ;branch if Z=0 GEND1
FA5A : 96 23      ldaa  $23           ;load A with value in addr 23
FA5C : 27 42      beq  LFAA0          ;branch if Z=1 GEND1
FA5E : 7A 00 24   dec  X0024          ;decr value in addr 0024
FA61 : 27 3D      beq  LFAA0          ;branch if Z=1 GEND1 
FA63 : 9B 30      adda  $30           ;add A with value in addr 30
;GEND60
FA65 : 97 30      staa  $30           ;store A in addr 30
;GEND61
FA67 : DE 28      ldx  $28            ;load X with value in addr 28
FA69 : 5F         clrb                ;clear B
;GW0
FA6A : 96 30      ldaa  $30           ;load A with value in addr 30
FA6C : 7D 00 23   tst  $0023          ;test value in addr 0023
FA6F : 2B 06      bmi  LFA77          ;branch if N=1 GW1
FA71 : AB 00      adda  $00,x         ;add A with value in addr X + 00h
FA73 : 25 08      bcs  LFA7D          ;branch if C=1 GW2
FA75 : 20 0B      bra  LFA82          ;branch always GW2A
;GW1
FA77 : AB 00      adda  $00,x         ;add A with value in addr X + 00h
FA79 : 27 02      beq  LFA7D          ;branch if Z=1 GW2
FA7B : 25 05      bcs  LFA82          ;branch if C=1 GW2A
;GW2
FA7D : 5D         tstb                ;test B (N=0(MSB), Z=1)
FA7E : 27 08      beq  LFA88          ;branch if Z=1 GW2B
FA80 : 20 0F      bra  LFA91          ;branch always GW3
;GW2A
FA82 : 5D         tstb                ;test B (N=0(MSB), Z=1)
FA83 : 26 03      bne  LFA88          ;branch if Z=0 GW2B
FA85 : DF 28      stx  $28            ;store X in addr 28
FA87 : 5C         incb                ;incr B
;GW2B
FA88 : 08         inx                 ;incr X
FA89 : 9C 2A      cpx  $2A            ;compare X with value in 2A
FA8B : 26 DD      bne  LFA6A          ;branch if Z=0 GW0
FA8D : 5D         tstb                ;test B (N=0(MSB), Z=1)
FA8E : 26 01      bne  LFA91          ;branch if Z=0 GW3
FA90 : 39         rts                 ;return subroutine
;GW3
FA91 : DF 2A      stx  $2A            ;store X in addr 2A
FA93 : 96 22      ldaa  $22           ;load A with value in addr 22
FA95 : 27 06      beq  LFA9D          ;branch if Z=1 GEND0
FA97 : 8D 08      bsr  LFAA1          ;branch sub WVTRAN
FA99 : 96 27      ldaa  $27           ;load A with value in addr 27
FA9B : 8D 16      bsr  LFAB3          ;branch sub WVDECA
;GEND0
FA9D : 7E FA 11   jmp  LFA11          ;jump GWAVE
;GEND1
FAA0 : 39         rts                 ;return subroutine
;*************************************;
;Wave Transfer Routine 
;*************************************;
;WVTRAN
FAA1 : CE 00 31   ldx  #$0031         ;load X with 0031h (#GWTAB)
FAA4 : DF 1C      stx  $1C            ;store X in addr 1C (XPTR)
FAA6 : DE 25      ldx  $25            ;load X with value in addr 25 (GWFRM)
FAA8 : E6 00      ldab  $00,x         ;load B with value in addr X + 00h (GET WAVE LENGTH)
FAAA : 08         inx                 ;incr X
FAAB : BD F9 28   jsr  LF928          ;jump sub TRANS
FAAE : DE 1C      ldx  $1C            ;load X with value in addr 1C (XPTR)
FAB0 : DF 2C      stx  $2C            ;store X in addr 2C (WVEND)(GET END ADDR)
FAB2 : 39         rts                 ;return subroutine
;*************************************;
;Wave Decay Routinue 
;*************************************;
;decay amount in ACCA 1/16 per decay
;WVDECA
FAB3 : 4D         tsta                ;test A and set N,Z
FAB4 : 27 2B      beq  LFAE1          ;branch if Z=1 WVDCX(NODECAY)
FAB6 : DE 25      ldx  $25            ;load X with value in addr 25(GWFRM)(ROM WAVE INDEX)
FAB8 : DF 1A      stx  $1A            ;store X in addr 1A(XPLAY) 
FABA : CE 00 31   ldx  #$0031         ;load X with value in addr 0031(#GWTAB)
FABD : 97 1F      staa  $1F           ;store A in addr 1F(TEMPB)(DECAY FACTOR)
;WVDLP
FABF : DF 1C      stx  $1C            ;store X in addr 1C(XPTR)
FAC1 : DE 1A      ldx  $1A            ;load X with value in addr 1A(XPLAY)
FAC3 : D6 1F      ldab  $1F           ;load B with value in addr 1F(TEMPB)
FAC5 : D7 1E      stab  $1E           ;store B in addr 1E(TEMPA)(DECAY FACTOR TEMP)
FAC7 : E6 01      ldab  $01,x         ;load B with value in addr X + 01h(OFFSET FOR WAVE LENGTH)
FAC9 : 54         lsrb                ;logic shift right B (bit7=0)
FACA : 54         lsrb                ;logic shift right B (bit7=0)
FACB : 54         lsrb                ;logic shift right B (bit7=0)
FACC : 54         lsrb                ;logic shift right B (bit7=0)(CALC 1/16TH)
FACD : 08         inx                 ;incr X
FACE : DF 1A      stx  $1A            ;store X in addr 1A(XPLAY)
FAD0 : DE 1C      ldx  $1C            ;load X with value in addr 1C(XPTR)
FAD2 : A6 00      ldaa  $00,x         ;load A with value in addr X + 00h
;WVDLP1
FAD4 : 10         sba                 ;A = A - B (B unchanged)(DECAY)
FAD5 : 7A 00 1E   dec  $001E          ;decr value in addr 001E(TEMPA)
FAD8 : 26 FA      bne  LFAD4          ;branch if Z=0 WVDLP1
FADA : A7 00      staa  $00,x         ;store A in addr X + 00h
FADC : 08         inx                 ;incr X
FADD : 9C 2C      cpx  $2C            ;compare X with value in addr 2C(WVEND)(END OF WAVE?)
FADF : 26 DE      bne  LFABF          ;branch if Z=0 WVDLP(NO)
;WVDCX
FAE1 : 39         rts                 ;return subroutine
;*************************************;
;Interrupt Processing - speech, bg2
;*************************************; 
;IRQ
FAE2 : 8E 00 7F   lds  #$007F         ;load SP with value 007Fh
FAE5 : 7F 00 00   clr  $0000          ;clear addr 0000
FAE8 : B6 04 02   ldaa  $0402         ;load A with value at addr 0402 (PIA sound select)
FAEB : C6 80      ldab  #$80          ;load B with value 80h
FAED : F7 04 02   stab  $0402         ;store B in addr 0402 (PIA sound select)
FAF0 : 7C 00 15   inc  $0015          ;incr value in addr 0015
FAF3 : 43         coma                ;complement 1s A
FAF4 : 84 7F      anda  #$7F          ;and A with value 7Fh
FAF6 : 36         psha                ;push A into stack then SP - 1
FAF7 : 84 5F      anda  #$5F          ;and A with value 5Fh
FAF9 : 81 16      cmpa  #$16          ;compare A with value 16h
FAFB : 27 03      beq  LFB00          ;branch if Z=1 IRQ1
FAFD : 7F 00 13   clr  $0013          ;clear addr 0013
;IRQ1
FB00 : 81 18      cmpa  #$18          ;compare A with value 18h
FB02 : 27 03      beq  LFB07          ;branch if Z=1 IRQ2
FB04 : 7F 00 14   clr  $0014          ;clear addr 0014
;IRQ2
FB07 : 32         pula                ;SP + 1 pull stack into A
FB08 : 85 20      bita  #$20          ;bit test A with value 20h
FB0A : 27 18      beq  LFB24          ;branch if Z=1 IRQ6
;IRQ3 - jsr Speech ROM IC4 
FB0C : C6 7E      ldab  #$7E          ;load B with value 7Eh
FB0E : F1 EF FD   cmpb  $EFFD         ;compare B with value at addr EFFD - Speech ROM IC4
FB11 : 26 05      bne  LFB18          ;branch if Z=0 IRQ4
FB13 : BD EF FD   jsr  LEFFD          ;jump sub EFFD - Speech ROM IC4
FB16 : 20 08      bra  LFB20          ;branch always IRQ5 
;IRQ4 - jsr Speech ROM 6 
FB18 : F1 DF FD   cmpb  $DFFD         ;compare B with value at addr DFFD - Speech ROM IC6
FB1B : 26 07      bne  LFB24          ;branch if Z=0 IRQ6
FB1D : BD DF FD   jsr  LDFFD          ;jump sub DFFD - Speech ROM IC6
;IRQ5
FB20 : 96 00      ldaa  $00           ;load A with value in addr 00
FB22 : 20 04      bra  LFB28          ;branch always IRQ7
;IRQ6 - load sound select set by Speech ROM routines
FB24 : 0E         cli                 ;clear interrupt I=0
FB25 : F6 04 02   ldab  $0402         ;load B with value in addr 0402 (PIA sound select)
;IRQ7 - load sound select set by Speech ROM routines
FB28 : 8D 20      bsr  LFB4A          ;branch sub IRQ11
FB2A : 7D 00 00   tst  $0000          ;test addr 0000
FB2D : 26 DD      bne  LFB0C          ;branch if Z=0 IRQ3
FB2F : 0E         cli                 ;clear interrupt I=0
FB30 : F6 04 02   ldab  $0402         ;load B with value in addr 0402 (PIA sound select)
;organ tune jump
;IRQ8
FB33 : 96 10      ldaa  $10           ;load A with value in addr 10
FB35 : 9A 11      oraa  $11           ;OR A with value in addr 11
;IRQ9
FB37 : 27 FE      beq  LFB37          ;branch if Z=1 IRQ9 (stdby)
FB39 : 4F         clra                ;clear A
FB3A : 97 13      staa  $13           ;store A in addr 13
FB3C : 97 14      staa  $14           ;store A in addr 14
FB3E : 96 10      ldaa  $10           ;load A with value in addr 10
FB40 : 27 05      beq  LFB47          ;branch if Z=1 IRQ10
FB42 : 2B 03      bmi  LFB47          ;branch if N=1 IRQ10  
FB44 : 7E F9 7B   jmp  LF97B          ;jump BGEND
;IRQ10
FB47 : 7E F9 96   jmp  LF996          ;jump BG2
;IRQ11
FB4A : 84 1F      anda  #$1F          ;and A with value 1Fh
FB4C : 26 01      bne  LFB4F          ;branch if Z=0 IRQ12
FB4E : 39         rts                 ;return subroutine
;interrupts for organ, gwave, vari
;IRQ12
FB4F : 4A         deca                ;decr A
FB50 : 27 4C      beq  LFB9E          ;branch if Z=1 SYNTH5
FB52 : 81 0A      cmpa  #$0A          ;compare A with value 0Ah
FB54 : 26 03      bne  LFB59          ;branch if Z=0 IRQ13
FB56 : 7E F8 8B   jmp  LF88B          ;jump ORGANT
;IRQ13
FB59 : 81 18      cmpa  #$18          ;compare A with value 18h
FB5B : 26 03      bne  LFB60          ;branch if Z=0 IRQ14
FB5D : 7E F8 8F   jmp  LF88F          ;jump ORGLD1
;IRQ14
FB60 : 81 0F      cmpa  #$0F          ;compare A with value 0Fh
FB62 : 22 0B      bhi  LFB6F          ;branch if C=0 and Z=0 IRQ15
;IRQLP1
FB64 : 4A         deca                ;decr A
FB65 : BD F9 AB   jsr  LF9AB          ;jump sub GWLD
FB68 : 7E FA 11   jmp  LFA11          ;jump GWAVE
;IRQLP2
FB6B : 80 06      suba  #$06          ;A = A - 06h
FB6D : 20 F5      bra  LFB64          ;branch always IRQLP1
;IRQ15
FB6F : 81 16      cmpa  #$16          ;compare A with value 16h
FB71 : 27 F8      beq  LFB6B          ;branch if Z=1 IRQLP2
FB73 : 81 17      cmpa  #$17          ;compare A with value 17h   
FB75 : 27 F4      beq  LFB6B          ;branch if Z=1 IRQLP2
FB77 : 81 17      cmpa  #$17          ;compare A with value 17h
FB79 : 22 0C      bhi  LFB87          ;branch if C=0 and Z=0 IRQ16
FB7B : 80 10      suba  #$10          ;A = A - 10h
FB7D : 48         asla                ;arith shift left A (bit0 is 0)
FB7E : CE FE C1   ldx  #$FEC1         ;load X with value FEC1h JMPTBL
FB81 : 8D 0C      bsr  LFB8F          ;branch sub ADDX CALCOS
FB83 : EE 00      ldx  $00,x          ;load X with value at addr X + 00h
FB85 : 6E 00      jmp  $00,x          ;jump addr X + 00h
;IRQ16
FB87 : 80 18      suba  #$18          ;A = A - 18h
FB89 : BD F8 2D   jsr  LF82D          ;jump sub VARILD
FB8C : 7E F8 42   jmp  LF842          ;jump VARI
;*************************************;
;Add A to X
;*************************************; 
;ADDX
FB8F : DF 1A      stx  $1A            ;store X in addr 1A
FB91 : 9B 1B      adda  $1B           ;add A with value in addr 1B
FB93 : 97 1B      staa  $1B           ;store A in addr 1B
FB95 : 96 1A      ldaa  $1A           ;load A with value in addr 1A
FB97 : 89 00      adca  #$00          ;A = A + C + value 00h
FB99 : 97 1A      staa  $1A           ;store A in addr 1A 
FB9B : DE 1A      ldx  $1A            ;load X with value in addr 1A
FB9D : 39         rts                 ;return subroutine
;*************************************;
;TILT 
;*************************************; 
FB9E : CE 00 E0   ldx  #$00E0         ;load X with 00E0h
;TILT1
FBA1 : 86 20      ldaa  #$20          ;load A with value 20h 
FBA3 : 8D EA      bsr  LFB8F          ;branch sub ADDX
;TILT2
FBA5 : 09         dex                 ;decr X
FBA6 : 26 FD      bne  LFBA5          ;branch Z=0 TILT2
FBA8 : 7F 04 00   clr  $0400          ;clear (00) in DAC output SOUND
;TILT3
FBAB : 5A         decb                ;decr B
FBAC : 26 FD      bne  LFBAB          ;branch Z=0 TILT3
FBAE : 73 04 00   com  $0400          ;complement 1s in DAC output SOUND
FBB1 : DE 1A      ldx  $1A            ;load X with value in addr 1A
FBB3 : 8C 10 00   cpx  #$1000         ;compare X with value 1000h
FBB6 : 26 E9      bne  LFBA1          ;branch Z=0 TITL1
FBB8 : 39         rts                 ;return subroutine
;*************************************;
;NMI
;*************************************; 
FBB9 : 0F         sei                 ;set interrupt mask
FBBA : 8E 00 7F   lds  #$007F         ;load SP with 007Fh
FBBD : CE FF FF   ldx  #$FFFF         ;load X with FFFFh
FBC0 : 5F         clrb                ;clear B
;NMI1
FBC1 : E9 00      adcb  $00,x         ;B = Carry + B + addr X +00h
FBC3 : 09         dex                 ;decr X
FBC4 : 8C F8 00   cpx  #$F800         ;comp X with F800h (ROM addr)  
FBC7 : 26 F8      bne  LFBC1          ;branch if Z=0 NMI1
FBC9 : E1 00      cmpb  $00,x         ;comp B with addr X + 00h
FBCB : 27 01      beq  LFBCE          ;branch if Z=1 NMI2
FBCD : 3E         wai                 ;wait interrupt, PC+1 and halt
;NMI2
FBCE : 7F 04 02   clr  $0402          ;clear addr 0402 PIA
FBD1 : CE 2E E0   ldx  #$2EE0         ;load X with value 2EE0h
;NMI3
FBD4 : 09         dex                 ;decr X
FBD5 : 26 FD      bne  LFBD4          ;branch if Z=0 NMI3
FBD7 : BD F9 3C   jsr  LF93C          ;jump sub KNOCK
FBDA : BD F9 3C   jsr  LF93C          ;jump sub KNOCK
FBDD : BD F9 3C   jsr  LF93C          ;jump sub KNOCK
FBE0 : 86 80      ldaa  #$80          ;load A with value 80h
FBE2 : B7 04 02   staa  $0402         ;store A in addr 0402 (PIA sound select)
FBE5 : 86 01      ldaa  #$01          ;load A with value 01h
FBE7 : BD F9 AB   jsr  LF9AB          ;jump sub GWLD
FBEA : BD FA 11   jsr  LFA11          ;jump sub GWAVE
FBED : 86 0B      ldaa  #$0B          ;load A with value 0Bh
FBEF : BD F9 AB   jsr  LF9AB          ;jump sub GWLD
FBF2 : BD FA 11   jsr  LFA11          ;jump sub GWAVE
FBF5 : 01         nop                 ;(rem'd calls to LITE)
FBF6 : 01         nop                 ;
FBF7 : 01         nop                 ;
FBF8 : 86 02      ldaa  #$02          ;load A with value 02h
FBFA : BD F8 2D   jsr  LF82D          ;jump sub VARILD
FBFD : BD F8 42   jsr  LF842          ;jump sub VARI
;check for Speech ROMS
FC00 : F6 DF FA   ldab  $DFFA         ;load B with value DFFAh - Speech ROM IC6
FC03 : C1 7E      cmpb  #$7E          ;compare B with value 7Eh (looking for a jmp opcode)
FC05 : 26 05      bne  LFC0C          ;branch if Z=0 NMI5 (not present, check for next speech rom)
FC07 : BD DF FA   jsr  LDFFA          ;jump sub DFFA - Speech ROM IC6
FC0A : 20 AD      bra  LFBB9          ;branch always NMI
;NMI5
FC0C : F6 EF FA   ldab  XEFFA         ;load B with value EFFAh - Speech ROM IC4
FC0F : C1 7E      cmpb  #$7E          ;compare B with value 7Eh (looking for a jmp opcode)
FC11 : 26 A6      bne  LFBB9          ;branch if Z=0 NMI
FC13 : BD EF FA   jsr  LEFFA          ;jump sub EFFA - Speech ROM IC4
FC16 : 20 A1      bra  LFBB9          ;branch always NMI
;*************************************;
;VARI VECTORS
;*************************************;
;VVECT EQU *
FC18 : 40 0F 00 99 09 02 00 F8 FF     ;
FC21 : F0 0F 02 21 26 02 80 00 FF     ;
FC2A : 05 01 01 01 20 01 08 FF FF     ;
FC33 : FF 01 01 0F 02 01 80 00 FF     ;
FC3C : 01 20 01 23 00 03 20 00 FF     ;
FC45 : 0E E7 35 33 79 03 80 F2 FF     ;
FC4E : 36 21 09 06 EF 03 C0 00 FF     ;
FC57 : 20 11 07 07 04 00 D0 00 BB     ;
FC60 : 01 08 00 47 01 01 22 00 DD     ;
FC69 : 17 0B 0D 44 01 02 03 00 CC     ;
;*************************************;
;* KNOCKER PATTERN
;*************************************;
;KNKTAB
FC72 : 01 FC 02 FC 03 F8 04 F8        ;
FC7A : 06 F8 08 F4 0C F4 10 F4        ;
FC82 : 20 F2 40 F1 60 F1 80 F1        ;
FC8A : A0 F1 C0 F1                    ;
FC8E : 00 00                          ;
;*************************************;
;GWVTAB - Wave table, 1st byte wavelength
;*************************************;
;
FC90 : 04                             ;
FC91 : FF FF 00 00                    ;
;
FC95 : 08                             ;
FC96 : 7F D9 FF D9 7F 24 00 24        ;
;
FC9E : 08                             ;
FC9F : FF FF FF FF 00 00 00 00        ;

FCA7 : 08                             ;
FCA8 : 00 40 80 00 FF 00 80 40        ;
;
FCB0 : 10                             ;
FCB1 : 7F B0 D9 F5 FF F5 D9 B0        ;
FCB9 : 7F 4E 24 09 00 09 24 4E        ;
;
FCC1 : 10                             ;
FCC2 : FF FF FF FF FF FF FF FF        ;
FCCA : 00 00 00 00 00 00 00 00        ;
;
FCD2 : 10                             ;
FCD3 : 00 F4 00 E8 00 DC 00 E2        ;
FCDB : 00 DC 00 E8 00 F4 00 00        ;
;
FCE3 : 10                             ;
FCE4 : 59 7B 98 AC B3 AC 98 7B        ;
FCEC : 59 37 19 06 00 06 19 37        ;
;
FCF4 : 18                             ;(24)
FCF5 : FF FF FF BF FF FF FF 7F        ;
FCFD : FF FF FF 3F FF FF FF 00        ;
FD05 : FF FF FF 3F FF FF FF BF        ;
;
FD0D : 30                             ;(48)
FD0E : 83 78 69 5B 4E 42 37 2D        ;
FD16 : 24 1C 15 0F 0A 06 03 01        ;
FD1E : 00 01 03 06 0A 0F 15 1C        ;
FD26 : 24 2D 37 42 4E 5B 69 78        ;
FD2E : 88 99 AB BE D2 E7 FD E7        ;
FD36 : D2 BE AB 99 95 90 8C 88        ;
;
FD3E : 47                             ;(71)
FD3F : 8A 95 A0 AB B5 BF C8 D1        ;
FD47 : DA E1 E8 EE F3 F7 FB FD        ;
FD4F : FE FF FE FD FB F7 F3 EE        ;
FD57 : E8 E1 DA D1 C8 BF B5 AB        ;
FD5F : A0 95 8A 7F 75 6A 5F 54        ;
FD67 : 4A 40 37 2E 25 1E 17 11        ;
FD6F : 0C 08 04 02 01 00 01 02        ;
FD77 : 04 08 0C 11 17 1E 25 2E        ;
FD7F : 37 40 4A 54 5F 6A 75 7F        ;
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

FD87 : 52 37 00 00 00 10 54           ;HBDSND(16)
FD8E : 73 26 03 00 00 10 A1           ;
FD95 : 11 41 03 ED 09 09 4B           ;TRBPAT(9)
FD9C : 01 1A 01 01 01 01 6A           ;BBSND (1)
FDA3 : F2 24 02 00 00 10 36           ; (16)
FDAA : 26 A0 00 00 00 16 54           ;HBDSND(22)
FDB1 : 57 31 00 00 00 20 91           ;
FDB8 : 46 41 02 0E 01 0E 27           ;(14)
FDBF : 51 36 00 00 00 0C 00           ;(12)
FDC6 : 33 60 01 01 01 20 36           ; (32)
FDCD : 16 84 03 0E 01 0E 27           ;(14)
FDD4 : 11 26 00 F0 05 08 B1           ;
FDDB : 51 32 01 00 00 10 00           ;(16)
FDE2 : 46 56 00 00 00 08 6A           ;BBSND (08)
FDE9 : 14 27 01 FE 10 10 54           ;HBDSND (16)
FDF0 : 63 27 06 00 00 10 A1           ;
FDF7 : 52 32 04 00 00 20 84           ;
;zero padding
FDFE : 00 00
;*************************************;
;GFRTAB - GWAVE FREQ PATTERN TABLE
;*************************************; 
;
FE00 : 10 90 91 A2 3A B4 5B C6        ;
FE08 : 7C D8 9D EA BE FC DF 0E        ;
;
FE10 : 01 01 02 02 04 88 40 08        ;
FE18 : 08 40 88 01 01 02 02 03        ;
FE20 : 04 05 06 07 08 09 0A 0C        ;
;
FE28 : 08 80 10 78 18 70 20 60        ;YUKSND
FE30 : 28 58 30 50 40 48              ;
;
FE36 : 01 02 02 03 03 03 06 06        ;
FE3E : 06 06 0F 1F 36 55 74 91        ;
FE46 : A8 B9 CA DB EC                 ;
;TURBINE START UP
FE4B : 80 7C 78 74 70 74 78 7C 80     ;TRBPAT
;Heartbeat Distorto 
FE54 : 01 01 02 02 04 04 08 08        ;HBDSND
FE5C : 10 20 28 30 38 40 48 50        ;
FE64 : 60 70 80 A0 B0 C0              ;
;BigBen Sounds (variation)
FE6A : 08 40 06 44 06 44 06 44 06 44  ;BBSND
FE74 : 06 44 06 44 06 44 06 44 06 44  ;
;
FE7E : 01 02 04 08 09 0A              ;
;
FE84 : 3F 4F 5F 6F 7F 68 58 48        ;
FE8C : 38 28 18 1F 2F                 ;
;Start Distorto Sound 
FE91 : 01 01 01 01 02 02 03 03        ;
FE99 : 04 04 05 06 08 0A 0C 10        ;
FEA1 : 14 18 20 30 40 50 40 30        ;
FEA9 : 20 10 0C 0A 08 07 06 05        ;
; 
FEB1 : CC BB 60 10 EE AA 50 00        ;
FEB9 : 93 8E 82 7C 71 6A 5F 42        ;
;*************************************;
;vector jump tables
;*************************************;
;JMPTBL
FEC1 : F97B                           ;BGEND
FEC3 : F982                           ;BG2INC
FEC5 : F97B                           ;BGEND
FEC7 : F893                           ;ORGLD2
FEC9 : F97B                           ;BGEND
FECB : F93C                           ;KNOCK 
;*************************************;
;Organ Tune Table
;*************************************;
; Oscillator Mask(1), Delay(1), Duration(2)
; n X 4
;ORGTAB
FECD : 34                             ;(52 / 4 = 13)
FECE : 7C 29 05 56                    ;
FED2 : 7C 1D 05 FE                    ;
FED6 : 7C 17 0C B2                    ;
FEDA : 7C 1D 0B FC                    ;
FEDE : 7C 29 05 56                    ;
FEE2 : F8 04 07 FF                    ;
FEE6 : 7C 29 05 56                    ;
FEEA : 7C 1D 05 FE                    ;
FEEE : 7C 17 06 59                    ;
FEF2 : 7C 04 07 FF                    ;
FEF6 : 7C 1D 05 FE                    ;
FEFA : 7C 17 06 59                    ;
FEFE : 7C 29 2A B6                    ;
FE02 : 18                             ;(24 / 4 = 6)
FE03 : F8 04 02 FF                    ;
FF07 : 00 23 06 01                    ;
FF0B : F8 04 03 FF                    ;
FF0F : 00 23 02 AB                    ;
FF13 : F8 04 07 FF                    ;
FF17 : 7C 29 15 5B                    ;
FF1B : 60                             ;(96 / 4 = 24)
FF1C : 7C 1D 05 FE                    ;
FF20 : F8 04 1F FF                    ;
FF24 : 7C 04 1F FF                    ;
FF28 : 7C 1D 11 FA                    ;
FF2C : 00 1D 02 FF                    ;
FF30 : 7C 1D 02 FF                    ;
FF34 : 7C 17 0C B2                    ;
FF38 : 7C 1D 0B FC                    ;
FF3C : 7C 23 0A AD                    ;
FF40 : 7C 37 09 83                    ;
FF44 : 7C 3F 11 F5                    ;
FF48 : 3E 3F 11 F5                    ;
FF4C : 7C 17 16 34                    ;
FF50 : 7C 1D 02 FF                    ;
FF54 : 7C 17 0C B2                    ;
FF58 : 7C 1D 0B FC                    ;
FF5C : 7C 29 0A AD                    ;
FF60 : 7C 3F 04 7D                    ;
FF64 : 7C 37 04 C1                    ;
FF68 : 7C 3F 14 36                    ;
FF6C : F8 1D 14 FF                    ;
FF70 : F8 04 03 FF                    ;
FF74 : 00 04 03 F8                    ;
FF78 : F8 04 3F FF                    ;
;*************************************;
; zero padding
FF7C : 00 00
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
FFEE : 00 00
;*************************************;
;jumps from Speech ROM
;*************************************;
FFF0 : 7E FB 4A   jmp $FB4A           ;jump IRQ11
FFF3 : 7E FB 8F   jmp $FB8F           ;jump ADDX
;
FFF6 : F97B                           ;BGEND
;*************************************;
;Motorola vector table
;*************************************; 
FFF8 : FAE2                           ;IRQ  
FFFA : F801                           ;RESET SWI (software) 
FFFC : FBB9                           ;NMI  
FFFE : F801                           ;RESET (hardware) 

;--------------------------------------------------------------

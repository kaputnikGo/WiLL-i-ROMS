    ;
    ; Disassembled by:
    ;  DASMx object code disassembler
    ;  (c) Copyright 1996-2003   Conquest Consultants
    ;  Version 1.40 (Oct 18 2003)
    ;
    ; File:  Flash.716
    ;
    ; Size:  2048 bytes
    ; Checksum: E106
    ; CRC-32:  F4190CA3
    ;
    ; Date:  Tue Apr 13 19:00:04 2021
    ;
    ; CPU:  Motorola 6800 (6800/6802/6808 family)
    ;
        ; NOTE: PIA DAC addr 8400
        ;
        ; 
        ; Stellar Wars dated 1979, SoundROM 1
        ; for System [4]-[6] sound boards (rectangular)
        ; for pinball games Flash[4][1979], Time Warp[6][1979], Stellar Wars[4][1979], Scorpion[6][1980], Tri Zone[6][1979] 
        ;
        ; Flash[System 4][1979] - programmed by Randy Pfeiffer
        ; 8x bell tones 
        ; possible WhiteNoise routine
        ;
        ;update 27 April 2021
        ;
;
org $7800
;
7800 : 74                        ;Checksum byte
;*************************************;
;RESET power on
;*************************************; 
7801 : 0F         sei            ;set interrupt mask   
7802 : 8E 00 7F   lds  #$007F    ;load stack pointer with 007Fh  
7805 : CE 84 00   ldx  #$8400    ;load X with 8400h (PIA addr)
7808 : 6F 01      clr $01,x      ;clr (00) X + 01h (8401) PIA CR port A
780A : 6F 03      clr $03,x      ;clr (00) X + 03h (8403) PIA CR port B
780C : 86 FF      ldaa #$FF      ;load A with FFh
780E : A7 00      staa $00,x     ;store A in addr X + 00h (8400) PIA port A out (DAC sound)
7810 : 6F 02      clr $02,x      ;clr (00) X + 01h (8402) PIA port B in (sound select)
7812 : 86 07      ldaa #$07      ;load A with 07h
7814 : A7 01      staa $01,x     ;store A in addr X + 01h (8401) PIA CR port A
7816 : A7 03      staa $03,x     ;store A in addr X + 03h (8403) PIA CR port B
7818 : 97 1C      staa $1C       ;store A in addr 1C (HI)(START RANDOM GENERATOR)
781A : 7F 00 20   clr $0020      ;clr (00) addr 20
781D : 0E         cli            ;clear interrupt
;STDBY L781E:
781E : 20 FE      bra LF81E      ;branch always here STDBY1
;*************************************;
;Three Oscillator Sound Generator (PARAM1) (source Robotron)
;*************************************;
;L7820 PLAY:
7820 : DF 24      stx $24        ;store X in addr 24 (XPLAY)(SAVE CURRENT INDEX)
7822 : CE 78 C5   ldx #$78C5     ;load X with 78C5h (#DECAYZ)(SET TO MAXIMUM AMPLITUDE)(SYN02)
7825 : DF 26      stx $26        ;store X in addr 26 (XDECAY)(AND SAVE)
7827 : 86 80      ldaa #$80      ;load A with value 80h (LOAD ZERO AMPLITUDE)
;PRM11 L7829 PLAY1:
7829 : D6 03      ldab $03       ;load B with value in addr 03 (FREQ4)(CHECK WHITE NOISE COUNTER)
782B : 2A 09      bpl L7836      ;branch N=0 PRM13 (PLAY3)(NOT IN WHITE MODE)
782D : D6 1D      ldab $1D       ;load B with value in addr 1D (RANDOM)(GET RANDOM NUMBER)
782F : 54         lsrb           ;logic shift right B (REDUCE IT)
7830 : 54         lsrb           ;logic shift right B
7831 : 54         lsrb           ;logic shift right B
7832 : 5C         incb           ;incr B (NOW NON-ZERO)
;PRM12 L7833 PLAY2:
7833 : 5A         decb           ;decr B (TIME OUT COUNT)
7834 : 26 FD      bne L7833      ;branch Z=0 PRM12 (PLAY2)
;PRM13 L7836 PLAY3:
7836 : 7A 00 08   dec $0008      ;decr addr 0008 (FREQ1$)(COUNT DOWN OSC. 1)
7839 : 27 4C      beq L7887      ;branch Z=1 PRM17 (PLAY7)(DO AN UPDATE)
783B : 7A 00 09   dec $0009      ;decr addr 0009 (FREQ2$)(COUNT DOWN OSC. 2)
783E : 27 4C      beq L788C      ;branch Z=1 PRM18 (PLAY8)(DO AN UPDATE)
7840 : 7A 00 0A   dec $000A      ;decr addr 000A (FREQ3$)(COUNT DOWN OSC. 3)
7843 : 27 4C      beq L7891      ;branch Z=1 PRM19 (PLAY9)(DO AN UPDATE)
7845 : 7A 00 0B   dec $000B      ;decr addr 000B (FREQ4$)(COUNT DOWN WHITE NOISE)
7848 : 26 DF      bne L7829      ;branch Z=0 PRM11 (PLAY1)(DO THEM AGAIN)
784A : D6 03      ldab $03       ;load B with value in addr 03 (FREQ4)(CHECK WHOTE NOISE CONSTANT)
784C : 27 DB      beq L7829      ;branch Z=1 PRM11 (PLAY1)(FORGET IT)
784E : C4 7F      andb #$7F      ;and B with value 7Fh (STRIP FLAG BIT)
7850 : D7 0B      stab $0B       ;store B in addr 0B (FREQ4$)(SAVE WHITE NOISE COUNT)
7852 : D6 1D      ldab $1D       ;load B with value in addr 1D (RANDOM)(GET CURRENT RANDOM)
7854 : 58         aslb           ;arith shift left B (DOUBLE)
7855 : DB 1D      addb $1D       ;add B with value in addr 1D (RANDOM)(TRIPLE)
7857 : CB 0B      addb #$0B      ;add B with value 0Bh (ADD IN 11)
7859 : D7 1D      stab $1D       ;store B in addr 1D (RANDOM)(VOILA...NEW RANDOM NUMBER)
785B : 7A 00 1B   dec $001B      ;decr addr 001B (CYCL4$)(COUNT DOWN DECAY)
785E : 26 0E      bne L786E      ;branch Z=0 PRM14 (PLAY6)(DON'T DECAY)
7860 : D6 0F      ldab $0F       ;load B with value in addr 0F (CYCLE4)(RELOAD COUNT)
7862 : D7 1B      stab $1B       ;store B in addr 1B (CYCL4$)(AND SAVE)
7864 : DE 26      ldx $26        ;load X with value in addr 26 (XDECAY)(GET DECAY JUMP POINTER)
7866 : 09         dex            ;decr X (MOVE TO LESS AMPLITUDE)
7867 : 8C 78 BE   cpx #$78BE     ;compare X with value 78BEh (#RDECAY+1)(DONE?)
786A : 27 4E      beq L78BA      ;branch Z=1 PRM1C (PLAY12)(YUP...BYE BYE)
786C : DF 26      stx $26        ;store X in addr 26 (XDECAY)(SAVE NEW POINTER)
;PRM14 L786E PLAY6:
786E : D6 1D      ldab $1D       ;load B with value in addr 1D (RANDOM)(GET RANDOM AMPLITUDE)
7870 : 2B 06      bmi L7878      ;branch N=1 PRM15 (PLAY6A)(SKIP IF NEGATIVE)
7872 : D4 07      andb $07       ;and B with value in addr 07 (DELTA4)(REDUCE AMPLITUDE)
7874 : C4 7F      andb #$7F      ;and B with value 7Fh (REMOVE SIGN BIT)
7876 : 20 05      bra L787D      ;branch always PRM16 (PLAY6B)
;PRM15 L7878 PLAY6A:
7878 : D4 07      andb $07       ;and B with value in addr 07 (DELTA4)(REDUCE AMPLITUDE)
787A : C4 7F      andb #$7F      ;and B with value 7Fh (REMOVE SIGN BIT)
787C : 50         negb           ;complement 2s B (NEGATE)
;PRM16 L787D PLAY6B:
787D : 36         psha           ;push A into stack then SP - 1
787E : 1B         aba            ;A = A + B (ADD WHITE NOISE)
787F : 16         tab            ;transfer A to B
7880 : 32         pula           ;SP + 1 pull stack into A
7881 : DE 26      ldx $26        ;load X with value in addr 26 (XDECAY)(GET DECAY POINTER)
7883 : AD 00      jsr $00,x      ;jump sub addr X (OUTPUT NOISE)
7885 : 20 A2      bra L7829      ;branch always PRM11 (PLAY1)(DO SOME MORE)
;PRM17 L7887 PLAY7:
7887 : CE 00 00   ldx #$0000     ;load X with value 0000h (#FREQ1)(INDEX SET 1)
788A : 20 08      bra L7894      ;branch always PRM1A (PLAY10)
;PRM18 L788C PLAY8:
788C : CE 00 01   ldx #$0001     ;load X with value 0001h (#FREQ2)(INDEX SET 2)
788F : 20 03      bra L7894      ;branch always PRM1A (PLAY10)
;PRM19 L7891 PLAY9:
7891 : CE 00 02   ldx #$0002     ;load X with value 0002h (#FREQ3)(INDEX SET 3)
;PRM1A L7894 PLAY10:
7894 : 6D 18      tst $18,x      ;test value in X+18h (24,X)(CHECK CYCLES AT FREQUENCY)
7896 : 27 12      beq L78AA      ;branch Z=1 PRM1B (PLAY11)(ZERO, DON'T CHANGE)
7898 : 6A 18      dec $18,x      ;decr addr X+18h (24,X)(COUNT DOWN)
789A : 26 0E      bne L78AA      ;branch Z=0 PRM1B (PLAY11)(NOT TIME TO CHANGE...)
789C : E6 0C      ldab $0C,x     ;load B with value in addr X+0Ch (12,X)(LOAD CYCLES AT FREQUENCY)
789E : E7 18      stab $18,x     ;store B in addr X+18h (24,X)(SAVE IN COUNTER)
78A0 : E6 00      ldab $00,x     ;load B with value in X (GET CURRENT FREQUENCY)
78A2 : EB 10      addb $10,x     ;add B with value in addr X+10h (16,X)(ADD DELTA)
78A4 : E1 14      cmpb $14,x     ;compare B with value in addr X+14h (20,X)(COMPARE TO END)
78A6 : 27 12      beq L78BA      ;branch Z=1 PRM1C (PLAY12)(DONE...)
78A8 : E7 00      stab $00,x     ;store B in addr X (SAVE NEW CURRENT FREQUENCY)
;PRM1B L78AA PLAY11:
78AA : E6 00      ldab $00,x     ;load B with value in addr X (GET CURRENT FREQUENCY)
78AC : E7 08      stab $08,x     ;store B in addr X+08h (SAVE IN FREQUENCY COUNTER)
78AE : AB 04      adda $04,x     ;add A with value in addr X+04h (ADD IN AMPLITUDE)
78B0 : 60 04      neg $04,x      ;complement 2s in X+04h (NEGATE AMPLITUDE)
78B2 : 16         tab            ;transfer A to B (SAVE DATA)
78B3 : DE 26      ldx $26        ;load X with value in addr 26 (XDECAY)(INDEX TO DECAY)
78B5 : AD 00      jsr $00,x      ;jump sub addr X (OUTPUT SOUND)
78B7 : 7E 78 29   jmp L7829      ;jump PRM11 (PLAY1)(REPEAT)
;PRM1C L78BA PLAY12:
78BA : DE 24      ldx $24        ;load X with value in addr 24 (XPLAY)(RESTORE INDEX)
78BC : 39         rts            ;return subroutine
;*************************************;
;Echo And Decay Routine (SYNTH0) (source Robotron)
;*************************************;
;RDECAY
78BD : 54         lsrb           ;logical shift right B (0nnn nnnn)
;SYN01 L78BE
78BE : 54         lsrb           ;logical shift right B (0nnn nnnn) note fall through above:add one lsrb
78BF : 54         lsrb           ;logical shift right B (00nn nnnn)
78C0 : 54         lsrb           ;logical shift right B (000n nnnn)
78C1 : 54         lsrb           ;logical shift right B (0000 nnnn)
78C2 : 54         lsrb           ;logical shift right B (0000 0nnn)
78C3 : 54         lsrb           ;logical shift right B (0000 00nn)
78C4 : 54         lsrb           ;logical shift right B (0000 000n)
;SYN02 L78C5 DECAYZ
78C5 : F7 84 00   stab $8400     ;store B in DAC output SOUND 
78C8 : 39         rts            ;return subroutine
;*************************************;
;3 Oscillator Calling Routines (PARAM2) (source Robotron)
;*************************************;
;THNDR
78C9 : CE 7C 12   ldx #$7C12     ;load X with value 7C12h (#VEC01)(THUNDER SOUND)(FDBTBL4)
;PRM21 L78CC THNDR1:
78CC : C6 1C      ldab #$1C      ;load B with value 1Ch (NEED TO TRANSFER)
78CE : BD 7A 13   jsr L7A13      ;jump sub TRANS (28 BYTES FOR PLAY)
78D1 : BD 78 20   jsr L7820      ;jump sub PARAM1 (PLAY)(NOW PLAY IT)
78D4 : 39         rts            ;return subroutine
;L78D5 SND2
78D5 : CE 7C 2E   ldx #$7C2E     ;load X with value 7C2Eh (#VEC02)(SOUND 2)(FDBTBL5)
78D8 : 20 F2      bra L78CC      ;branch always PRM21 (THNDR1)
;PRM31 L78DA SND3
78DA : CE 7C 4A   ldx #$7C4A     ;load X with value 7C4Ah (#VEC03)(SOUND 3)(FDBTBL6)
78DD : 20 ED      bra L78CC      ;branch always PRM21(THNDR1)
;PRM32 L78DF SND4
78DF : CE 7C 66   ldx #$7C66     ;load X with value 7C66h (#VEC04)(SOUND 4)(FDBTBL7)
78E2 : 20 E8      bra L78CC      ;branch alwyas PRM21(THNDR1)
;PRM33 L78E4 SND5
78E4 : CE 7C 82   ldx #$7C82     ;load X with value 7C82h (#VEC05)(SOUND 5)(FDBTBL8)
78E7 : 20 E3      bra L78CC      ;branch always PRM21(THNDR1)
;*************************************;
;PARAM4 called by JMPTBL (additional PARAMS for 3 Oscillator Calling Routine)
;*************************************;
;L78E9
78E9 : 7C 00 20   inc $0020      ;incr addr 0020
78EC : 7C 00 1F   inc $001F      ;incr addr 001F
78EF : CE 00 30   ldx #$0030     ;load X with value in addr 0030
78F2 : DF 22      stx $22        ;store X in addr 22
78F4 : CE 7C 9E   ldx #$7C9E     ;load X with value 7C9Eh (#VEC06)(FDBTBL9)
78F7 : C6 1C      ldab #$1C      ;load B with value 1Ch
78F9 : BD 7A 13   jsr L7A13      ;jump sub TRANS
78FC : CE 00 00   ldx #$0000     ;load X with value 0000h
78FF : DF 22      stx $22        ;store X in addr 22
7901 : CE 7C 9E   ldx #$7C9E     ;load X with value 7C9Eh (#VEC06)(FDBTBL9)
7904 : 20 C6      bra L78CC      ;branch always PRM21 THNDR1
;*************************************;
;PARAM5 called by JMPTBL (sets params only, no output)
;*************************************;
;L7906
7906 : 7F 00 20   clr $0020      ;clear addr 0020
7909 : C6 88      ldab #$88      ;load B with value 88h
790B : D7 21      stab $21       ;store B with value in addr 21
790D : CE 00 60   ldx #$0060     ;load X with value 0060h
7910 : DF 22      stx $22        ;store X in addr 22
7912 : CE 7C F0   ldx #$7CF0     ;load X with value 7CF0h (#VEC010X)(FDBVECT10)
7915 : C6 06      ldab #$06      ;load B with value 06h
7917 : BD 7A 13   jsr L7A13      ;jump sub TRANS
791A : 39         rts            ;return subroutine
;*************************************;
;PARAM6 called by JMPTBL (after IRQ2 goes to Three Oscillator Sound Gen (PARAM1))
;*************************************;
;L791B
791B : 96 1F      ldaa $1F       ;load A with value in addr 1F
791D : 27 1E      beq L793D      ;branch Z=1 PRM62
791F : 7F 00 1F   clr $001F      ;clear addr 001F
7922 : CE 00 31   ldx #$0031     ;load X with value 0031h
7925 : C6 06      ldab #$06      ;load B with value 06h
7927 : A6 00      ldaa $00,x     ;load A with vvalue in addr X
7929 : 81 36      cmpa #$36      ;compare A with value 36h
792B : 22 08      bhi L7935      ;branch C+Z=0 PRM61
792D : C6 04      ldab #$04      ;load B with value 04h
792F : 81 10      cmpa #$10      ;compare A with value 10h
7931 : 22 02      bhi L7935      ;branch C+Z=0 PRM61
7933 : C6 02      ldab #$02      ;load B with value 02h
;PRM61 L7935:
7935 : 10         sba            ;A = A - B
7936 : A7 00      staa $00,x     ;store A in addr X
7938 : A6 01      ldaa $01,x     ;load A with value in addr X+01h
793A : 10         sba            ;A = A - B
793B : A7 01      staa $01,x     ;store A in addr X+01h
;PRM62 L793D:
793D : 32         pula           ;SP + 1 pull stack into A
793E : 32         pula           ;SP + 1 pull stack into A
793F : 7E 7B 9E   jmp L7B9E      ;jump IRQ2
;*************************************;
;Progressive Pitch Countdown (PARAM7)
;*************************************;
;L7942 BONUS$
7942 : CE 00 60   ldx #$0060     ;load X with value 0060h (PROGRESSIVE SINGLE FREQUENCY)
7945 : A6 00      ldaa $00,x     ;load A with value in addr X (GET CURRENT FREQUENCY)
7947 : 80 02      suba #$02      ;subtract B with value 02h (NOW HIGHER)
7949 : A7 00      staa $00,x     ;store A in addr X (SAVE NEW FREQUENCY)
794B : BD 7A 92   jsr L7A92      ;jump sub PARAM21 (MOVE)(SET UP FOR SING)
794E : 7E 7A AB   jmp L7AAB      ;jump SYNTH5 (SING)(PLAY IT)
;*************************************;
;Diving Plane Sound (SYNTH1)
;*************************************;
;PLANE
7951 : CE 00 01   ldx #$0001     ;load X with value 0001h (SET FOR SHORT HALF CYCLE)
7954 : DF 00      stx $00        ;store X in addr 00 (FREQ1)(SAVE VALUE)
7956 : CE 03 80   ldx #$0380     ;load X with value 0380h (SET FOR LONG HALF CYCLE)
7959 : DF 02      stx $02        ;store X in addr 02 (FREQ3)(SAVE VALUE)
;SYN11 L795B PLANE1:
795B : 7F 84 00   clr $8400      ;clear DAC output SOUND  (SEND OUT ZEROES)
795E : DE 00      ldx $00        ;load X with value in addr 00 (FREQ1)(GET LOW HALF CYCLE DATA)
7960 : 08         inx            ;incr X (INCREASE HALF CYCLE)
7961 : DF 00      stx $00        ;store X in addr 00 (FREQ1)(SAVE NEW VALUE)
;SYN12 L7963 PLANE2:
7963 : 09         dex            ;decr X (COUNT DOWN)
7964 : 26 FD      bne L7963      ;branch Z=0 SYN12 (PLANE2)
7966 : 73 84 00   com $8400      ;complement 1s DAC output SOUND (SEND OUT ONES)
7969 : DE 02      ldx $02        ;load X with value in addr 02 (FREQ3)(GET HIGH HALF CYCLE DATA)
;SYN13 L796B PLANE3:
796B : 09         dex            ;decr X (COUNT DOWN)
796C : 26 FD      bne L796B      ;branch Z=0 SYN13 (PLANE3)
796E : 20 EB      bra L795B      ;branch always SYN11 (PLANE1)
;*************************************;
;SYNTH2
;*************************************;
7970 : 5F         clrb           ;clear B
7971 : F7 84 00   stab $8400     ;store B in DAC output SOUND 
7974 : CE 00 DF   ldx #$00DF     ;load X with value 00DFh
;SYN21 L7977:
7977 : 86 20      ldaa #$20      ;load A with value 20h
7979 : BD 7B B4   jsr L7BB4      ;jump sub CALCOS
;SYN22 L797C:
797C : 09         dex            ;decr X
797D : 26 FD      bne L797C      ;branch Z=0 SYN22
797F : 73 84 00   com $8400      ;complement 1s DAC output SOUND 
;SYN23 L7982:
7982 : 5A         decb           ;decr B
7983 : 26 FD      bne L7982      ;branch Z=0 SYN23
7985 : 73 84 00   com $8400      ;complement 1s DAC output SOUND 
7988 : 96 24      ldaa $24       ;load A with value in addr 24
798A : DE 24      ldx $24        ;load X with value in addr 24
798C : 85 10      bita #$10      ;bit test A with value 10h
798E : 27 E7      beq L7977      ;branch Z=1 SYN21
7990 : 39         rts            ;return subroutine
;*************************************;
;SYNTH3 - (possible version of Lightning+Appear Noise Routine)
;*************************************;
7991 : C6 01      ldab #$01      ;load B with value 01h
7993 : D7 00      stab $00       ;store B in addr 00 (LFREQ)
7995 : C6 FF      ldab #$FF      ;load B with value FFh (HIGHEST AMP)
7997 : 20 06      bra L799F      ;branch always SYN31
;SYN30 L7999
7999 : C6 01      ldab #$01      ;load B with value 01h
799B : D7 00      stab $00       ;store B in addr 00
799D : C6 AF      ldab #$AF      ;load B with value AFh
;SYN31 L799F:
799F : D7 02      stab $02       ;store B in addr 02
;SYN32 L79A1:
79A1 : C6 03      ldab #$03      ;load B with value 03h
79A3 : D7 01      stab $01       ;store B in addr 01
;SYN33 L79A5:
79A5 : D6 02      ldab $02       ;load B with value in addr 02
79A7 : 96 1D      ldaa $1D       ;load A with value in addr 1D
79A9 : 44         lsra           ;logic shift right A
79AA : 44         lsra           ;logic shift right A
79AB : 44         lsra           ;logic shift right A
79AC : 98 1D      eora $1D       ;exclusive OR A with value 1Dh
79AE : 44         lsra           ;logic shift right A
79AF : 76 00 1C   ror $001C      ;rotate right addr 001C (HI)
79B2 : 76 00 1D   ror $001D      ;rotate right addr 001D (LO)
79B5 : 24 01      bcc L79B8      ;branch C=0 SYN34
79B7 : 53         comb           ;complement 1s B
;SYN34 L79B8:
79B8 : F7 84 00   stab $8400     ;store B in DAC output SOUND 
79BB : D6 00      ldab $00       ;load B with value in addr 00
;SYN35 L79BD:
79BD : 5A         decb           ;decr B
79BE : 26 FD      bne L79BD      ;branch Z=0 SYN35
79C0 : 7A 00 01   dec $0001      ;decr addr 0001
79C3 : 26 E0      bne L79A5      ;branch Z=0 SYN33
79C5 : 7C 00 00   inc $0000      ;incr addr 0000
79C8 : 26 D7      bne L79A1      ;branch Z=0 SYN32
79CA : 39         rts            ;return subroutine
;*************************************;
;Funny "Electric Sound" (PARAM8)
;*************************************;
;* SUPPOSED TO GENERATE A PHASED OUTPUT AT
;* A CHANGING FREQUENCY. IT DOESN'T, AND
;* I'M NOT SURE EXACTLY WHAT IT DOES DO.
;* BEST LEAVE THIS ALONE.
;L79CB BONUS
79CB : 7A 00 21   dec $0021      ;decr addr 0021 (SNDX1)
79CE : 20 04      bra L79D4      ;branch always SYN41 (SND1$)
;L79D0 SND1 (SYNTH4):
79D0 : C6 A0      ldab #$A0      ;load B with value A0h
79D2 : D7 21      stab $21       ;store B in addr 21 (SNDX1)
;SYN41 L79D4 SND1$:
79D4 : 86 04      ldaa #$04      ;load A with value 04h
79D6 : 97 01      staa $01       ;store A in addr 01 (FREQ2)
;SYN42 L79D8 SND1$$:
79D8 : 86 9F      ldaa #$9F      ;load A with value 9Fh
79DA : D6 21      ldab $21       ;load B with value in addr 21 (SNDX1)
;SYN43 L79DC SND1A:
79DC : CE 01 C0   ldx #$01C0     ;load X with value 01C0h
;SYN44 L79DF SND1B:
79DF : 09         dex            ;decr X
79E0 : 27 20      beq L7A02      ;branch Z=1 SYN47 (SND1E)
79E2 : F7 00 00   stab $0000     ;store B with in addr 0000h (FCB $F7 "STAB")
;                 FDB            ;(FREQ1)
79E5 : B7 84 00   staa $8400     ;store A in DAC output SOUND 
;SYN45 L79E8 SND1C:
79E8 : 09         dex            ;decr X
79E9 : 27 17      beq L7A02      ;branch Z=1 SYN47 (SND1E)
79EB : 7A 00 00   dec $0000      ;decr addr 0000h (FREQ1)
79EE : 26 F8      bne L79E8      ;branch Z=0 SYN45 (SND1C)
79F0 : 09         dex            ;decr X
79F1 : 27 0F      beq L7A02      ;branch Z=1 SYN47 (SND1E)
79F3 : D7 00      stab $00       ;store B in addr 00 (FREQ1)
79F5 : 73 84 00   com $8400      ;complement 1s DAC output SOUND 
;SYN46 L79F8 SND1D:
79F8 : 09         dex            ;decr X
79F9 : 27 07      beq L7A02      ;branch Z=1 SYN47 (SND1E)
79FB : 7A 00 00   dec $0000      ;decr addr 0000 (FREQ1)
79FE : 26 F8      bne L79F8      ;branch Z=0 SYN46 (SND1D)
7A00 : 20 DD      bra L79DF      ;branch always SYN44 (SND1B)
;SYN47 L7A02 SND1E:
7A02 : D0 01      subb $01       ;subtract B with value in addr 01 (FREQ2)
7A04 : C1 10      cmpb #$10      ;compare B with value 10h
7A06 : 22 D4      bhi L79DC      ;branch C+Z=0 SYN43 (SND1A)
7A08 : 39         rts            ;return subroutine
;L7A09 START (PARAM9)
7A09 : C6 11      ldab #$11      ;load B with value 11h
7A0B : D7 21      stab $21       ;store B in addr 21 (SNDX1)
7A0D : 86 FE      ldaa #$FE      ;load A with value FEh
7A0F : 97 01      staa $01       ;store A in addr 01 (FREQ2)
7A11 : 20 C5      bra L79D8      ;branch always SYN42 (SND1$$)
;*************************************;
;Parameter Transfer
;*************************************;
;L7A13 TRANS:
7A13 : 36         psha           ;push A into stack then SP - 1
;TRNS1 L7A14:
7A14 : A6 00      ldaa $00,x     ;load A with X
7A16 : DF 24      stx $24        ;store X in addr 24 (XPLAY)
7A18 : DE 22      ldx $22        ;load X with value in addr 22 (XPTR)
7A1A : A7 00      staa $00,x     ;store A in addr X
7A1C : 08         inx            ;incr X
7A1D : DF 22      stx $22        ;store X in addr 22 (XPTR)
7A1F : DE 24      ldx $24        ;load X with value in addr 24 (XPLAY)
7A21 : 08         inx            ;incr X
7A22 : 5A         decb           ;decr B
7A23 : 26 EF      bne L7A14      ;branch Z=0 TRNS1
7A25 : 32         pula           ;SP + 1 pull stack into A
7A26 : 39         rts            ;return subroutine
;*************************************;
;Single Oscillator Sound Calls (PARAM10)
;*************************************;
;L7A27 PERK
7A27 : CE 7C BA   ldx #$7CBA     ;load X with value 7CBAh (#VEC01X)(FDBVECT1)
7A2A : 20 26      bra L7A52      ;branch always PRM151 (PERK$1)
;L7A2C PERK1:
7A2C : BD 7A 92   jsr L7A92      ;jump sub PARAM21 (MOVE)
7A2F : BD 7A AB   jsr L7AAB      ;jump sub SYNTH5 (SING)
7A32 : 39         rts            ;return subroutine
;L7A33 ATARI
7A33 : CE 7C C0   ldx #$7CC0     ;load X with value 7CC0h (#VEC02X)(FDBVECT2)
7A36 : 20 F4      bra L7A2C      ;branch always PARAM11 (PERK1)
;L7A38 SIREN
7A38 : C6 FF      ldab #$FF      ;load B with value FFh
7A3A : D7 1E      stab $1E       ;store X in addr 1E (AMP0)
;PRM131 L7A3C SIREN1:
7A3C : CE 7C C6   ldx #$7CC6     ;load X with value 7CC6h (#VEC03X)(FDBVECT3)
7A3F : 8D EB      bsr L7A2C      ;branch sub PARAM11 (PERK1)
7A41 : CE 7C CC   ldx #$7CCC     ;load X with value 7CCCh (#VEC04X)(FDBVECT4)
7A44 : 8D E6      bsr L7A2C      ;branch sub PARAM11 (PERK1)
7A46 : 5A         decb           ;decr B
7A47 : 26 F3      bne L7A3C      ;branch Z=0 PRM131 (SIREN1)
7A49 : 39         rts            ;return subroutine
;L7A4A ORRRR
7A4A : CE 7C D2   ldx #$7CD2     ;load X with value 7CD2h (#VEC05X)(FDBVECT5)
7A4D : 20 DD      bra L7A2C      ;branch always PARAM11 (PERK1)
;L7A4F PERK$
7A4F : CE 7C DE   ldx #$7CDE     ;load X with value 7CDEh (#VEC07X)(FDBVECT7)
;PRM151 L7A52 PERK$1:
7A52 : 8D D8      bsr L7A2C      ;branch sub PARAM11 (PERK1)
7A54 : 8D 30      bsr L7A86      ;branch sub PARAM19 (ECHO)
7A56 : 20 FA      bra L7A52      ;branch always PRM151 (PERK$1)
;L7A58 HSTD
7A58 : 86 FF      ldaa #$FF      ;load A with value FFh
7A5A : 97 1E      staa $1E       ;store A in addr 1E (AMP0)
7A5C : CE 7C E4   ldx #$7CE4     ;load X with value 7CE4h (#VEC08X)(FDBVECT8)
7A5F : 20 F1      bra L7A52      ;branch always PRM151 (PERK$1)
;L7A61 PERK$$
7A61 : 86 FF      ldaa #$FF      ;load A with value FFh
7A63 : 97 1E      staa $1E       ;store A in addr 1E (AMP0)
7A65 : CE 7C D8   ldx #$7CD8     ;load X with value 7CD8h (#VEC06X)(FDBVECT6)
7A68 : 20 E8      bra L7A52      ;branch always PRM151 (PERK$1)
;*************************************;
;Random Squirts (PARAM18)
;*************************************;
;L7A6A SQRT
7A6A : C6 30      ldab #$30      ;load B with value 30h
;SQRT1
7A6C : CE 7C EA   ldx #$7CEA     ;load X with value 7CEAh (#VEC09X)(FDBVECT9)
7A6F : 8D 21      bsr L7A92      ;branch sub PARAM21 (MOVE)
;PRM181 L7A71 SQRT2:
7A71 : 96 1D      ldaa $1D       ;load A with value in addr 1D (RANDOM)
7A73 : 48         asla           ;arith shift left A
7A74 : 9B 1D      adda $1D       ;add A with value in addr 1D (RANDOM)
7A76 : 8B 0B      adda #$0B      ;add A with value 0Bh
7A78 : 97 1D      staa $1D       ;store A in addr 1D (RANDOM)
7A7A : 44         lsra           ;logic shift right
7A7B : 44         lsra           ;logic shift right
7A7C : 8B 0C      adda #$0C      ;add A with value 0Ch
7A7E : 97 01      staa $01       ;store A in addr 01 (FREQ$)
7A80 : 8D 29      bsr L7AAB      ;branch sub SYNTH5 (SING)
7A82 : 5A         decb           ;decr B
7A83 : 26 EC      bne L7A71      ;branch Z=0 PRM181 (SQRT2)
7A85 : 39         rts            ;return subroutine
;*************************************;
;Echo Function (PARAM19)
;*************************************;
;L7A86 ECHO:
7A86 : 96 1E      ldaa $1E       ;load A with value in addr 1E (AMP0)
7A88 : 80 08      suba #$08      ;subtract A with value 08h
7A8A : 2A 03      bpl L7A8F      ;branch N=0 PARAM20 (ECHO1)
7A8C : 97 1E      staa $1E       ;store A in addr 1E (AMP0)
7A8E : 39         rts            ;return subroutine
;L7A8F ECHO1:
7A8F : 32         pula           ;SP + 1 pull stack into A
7A90 : 32         pula           ;SP + 1 pull stack into A
7A91 : 39         rts            ;return subroutine
;*************************************;
;Move Parameters (PARAM21)
;*************************************;
;L7A92 MOVE:
7A92 : A6 00      ldaa $00,x     ;load A with value in addr X+00h
7A94 : 97 01      staa $01       ;store A in addr 01 (FREQ$)
7A96 : A6 01      ldaa $01,x     ;load A with value in addr X+01h
7A98 : 97 02      staa $02       ;store A in addr 02 (C$FRQ)
7A9A : A6 02      ldaa $02,x     ;load A with value in addr X+02h
7A9C : 97 03      staa $03       ;store A in addr 03 (D$FRQ)
7A9E : A6 03      ldaa $03,x     ;load A with value in addr X+03h
7AA0 : 97 04      staa $04       ;store A in addr 04 (E$FRQ)
7AA2 : A6 04      ldaa $04,x     ;load A with value in addr X+04h
7AA4 : 97 05      staa $05       ;store A in addr 05 (C$AMP)
7AA6 : A6 05      ldaa $05,x     ;load A with value in addr X+05h
7AA8 : 97 06      staa $06       ;store A in addr 06 (D$AMP)
7AAA : 39         rts            ;return subroutine
;*************************************;
;Delta F, Delta A Routine (SYNTH5)
;*************************************;
;L7AAB SING:
7AAB : 96 1E      ldaa $1E       ;load A with value in addr 1E (AMP0) (GET STARTING AMPLITUDE)
7AAD : 37         pshb           ;push B into stack then SP - 1 (SAVE B)
7AAE : D6 05      ldab $05       ;load B with value in addr 05 (C$AMP)(GET CYCLES AT AMPLITUDE)
7AB0 : D7 07      stab $07       ;store B in addr 07 (C$AMP$)(SAVE AS COUNTER)
7AB2 : D6 02      ldab $02       ;load B with value in addr 02 (C$FRQ)(GET CYCLES AT FREQUENCY)
7AB4 : D7 08      stab $08       ;store B in addr 08 (C$FRQ$)(SAVE AS COUNTER)
;SYN51 L7AB6 SING1:
7AB6 : 43         coma           ;complement 1s A (INVERT AMPLITUDE)
7AB7 : D6 01      ldab $01       ;load B with value in addr 01 (FREQ$)(GET FREQUENCY COUNTER)
7AB9 : B7 84 00   staa $8400     ;store A in DAC output SOUND 
;SYN52 L7ABC SING2:
7ABC : 5A         decb           ;decr B
7ABD : 26 FD      bne L7ABC      ;branch Z=0 SYN52 (SING2)
7ABF : 43         coma           ;complement 1s A (INVERT AMPLITUDE)
7AC0 : D6 01      ldab $01       ;load B with value in addr 01 (FREQ$)(GET FREQUENCY COUNTER)
7AC2 : 20 00      bra L7AC4      ;branch always SYN53 (*+2)(-I)
7AC4 : 08         inx            ;incr X (-I)
7AC5 : 09         dex            ;decr X (-I---)(SYNC, 20 CYCLES)
7AC6 : 08         inx            ;incr X (-I)
7AC7 : 09         dex            ;decr X (-I)
7AC8 : B7 84 00   staa $8400     ;store A in DAC output SOUND 
;SYN54 L7ACB SING3:
7ACB : 5A         decb           ;decr B
7ACC : 26 FD      bne L7ACB      ;branch Z=0 SYN54 (SING3)
7ACE : 7A 00 08   dec $0008      ;decr addr 0008 (C$FRQ$)(CHECK CYCLES AT FREQUENCY)
7AD1 : 27 16      beq L7AE9      ;branch Z=1 SYN55 (SING4)(GO CHANGE FREQUENCY)
7AD3 : 7A 00 07   dec $0007      ;decr addr 0007 (C$AMP$)(CHECK CYCLES AT AMPLITUDE)
7AD6 : 26 DE      bne L7AB6      ;branch Z=0 SYN51 (SING1)(ALL OK, GO OUTPUT)
7AD8 : 43         coma           ;complement 1s A (INVERT AMPLITUDE)
7AD9 : D6 05      ldab $05       ;load B with value in addr 05 (C$AMP)(GET CYCLES AT AMPLITUDE)
7ADB : B7 84 00   staa $8400     ;store A in DAC output SOUND 
7ADE : D7 07      stab $07       ;store B in addr 07 (C$AMP$)(SAVE AS COUNTER)
7AE0 : D6 01      ldab $01       ;load B with value in addr 01 (FREQ$)(GET FREQUENCY COUNT)
7AE2 : 9B 06      adda $06       ;add A with value in addr 06 (D$AMP)(ADD AMPLITUDE DELTA)
7AE4 : 2B 1E      bmi L7B04      ;branch N=1 SYN57 (SING6)(RETURN FROM SUBROUTINE)
7AE6 : 01         nop            ; (SYNC, 2 CYCLES)
7AE7 : 20 15      bra L7AFE      ;branch always SYN56 (SING5)
;SYN55 L7AE9 SING4:
7AE9 : 08         inx            ;incr X (-i)
7AEA : 09         dex            ;decr X (-I---)(SYNC, 10 CYCLES)
7AEB : 01         nop            ; (-I)
7AEC : 43         coma           ;complement 1s A (INVERT AMPLITUDE)
7AED : D6 02      ldab $02       ;load B with value in addr 02 (C$FRQ)(GET CYCLES AT FREQUENCY)
7AEF : B7 84 00   staa $8400     ;store A in DAC output SOUND 
7AF2 : D7 08      stab $08       ;store B in addr 08 (C$FRQ$)(SAVE AS COUNTER)
7AF4 : D6 01      ldab $01       ;load B with value in addr 01 (FREQ$)(GET FREQUENCY COUNT)
7AF6 : D0 03      subb $03       ;subtract B with value in addr 03 (D$FRQ)(SUBTRACT FREQUENCY DELTA)
7AF8 : D1 04      cmpb $04       ;compare B with value in addr 04 (E$FRQ)(COMPARE TO END FREQUENCY)
7AFA : D1 04      cmpb $04       ;compare B with value in addr 04 (E$FRQ)(SYNC, 3 CYCLES)
7AFC : 27 06      beq L7B04      ;branch Z=1 SYN57 (SING6)(RETURN FROM SUBROUTINE)
;SYN56 L7AFE SING5:
7AFE : D7 01      stab $01       ;store B in addr 01 (FREQ$)(SAVE FREQUENCY COUNT)
7B00 : C0 05      subb #$05      ;subtract B with value 05h (SYNC TO FREQUENCY COUNTDOWN)
7B02 : 20 B8      bra L7ABC      ;branch always SYN52 (SING2)(JUMP INTO COUNTDOWN LOOP)
;SYN57 L7B04 SING6:
7B04 : 33         pulb           ;SP + 1 pull stack into B (RESTORE B)
7B05 : 39         rts            ;return subroutine
;*************************************;
;SYNTH6 (uses NOTTBL,SNDTBL,WAVFRM, 16 bytes each)
;*************************************;
;L7B06:
7B06 : 84 1F      anda #$1F      ;and A with value 1Fh
;SYN61 L7B08:
7B08 : 27 FE      beq L7B08      ;branch Z=1 SYN61
7B0A : 81 11      cmpa #$11      ;compare A with value 11h
;SYN62 L7B0C:
7B0C : 27 FE      beq L7B0C      ;branch Z=1 SYN62
7B0E : 81 12      cmpa #$12      ;compare A with value 12h
;SYN63 L7B10:
7B10 : 27 FE      beq L7B10      ;branch Z=1 SYN63
7B12 : 84 0F      anda #$0F      ;and A with value 0Fh
7B14 : CE 7B F4   ldx #$7BF4     ;load X with value 7BF4h (FDBTBL2)(NOTTBL)
7B17 : BD 7B B4   jsr L7BB4      ;jump sub CALCOS
7B1A : A6 00      ldaa $00,x     ;load A with addr X
7B1C : 97 18      staa $18       ;store A in addr 18 
7B1E : CE 7B E4   ldx #$7BE4     ;load X with value 7BE4h (FDBTBL1)(SNDTBL)
7B21 : C6 10      ldab #$10      ;load B with value 10h
7B23 : BD 7A 13   jsr L7A13      ;jump sub TRANS
7B26 : CE 7C 04   ldx #$7C04     ;load X with value 7C04h (FDBTBL3)(WAVFRM)
7B29 : E6 00      ldab $00,x     ;load B with addr X
;SYN64 L7B2B:
7B2B : D7 1A      stab $1A       ;store B in addr 1A
7B2D : DF 22      stx $22        ;store X in addr 22
;SYN65 L7B2F:
7B2F : CE 00 00   ldx #$0000     ;load X with value 0000h
7B32 : C6 08      ldab #$08      ;load B with value 08h
7B34 : D7 19      stab $19       ;store B in addr 19
;SYN66 L7B36:
7B36 : A6 00      ldaa $00,x     ;load A with value in addr X
7B38 : D6 18      ldab $18       ;load B with value in addr 18
7B3A : 7D 00 1A   tst $001A      ;test value in addr 001A
7B3D : 26 06      bne L7B45      ;branch Z=0 SYN67
7B3F : A0 08      suba $08,x     ;subtract B with value in X,08h
7B41 : A7 00      staa $00,x     ;store A in addr X
7B43 : C0 03      subb #$03      ;subtract B with value 03h
;SYN67 L7B45:
7B45 : 08         inx            ;increment X
7B46 : B7 84 00   staa $8400     ;store A in DAC output SOUND 
;SYN68 L7B49:
7B49 : 5A         decb           ;decr B
7B4A : 26 FD      bne L7B49      ;branch Z=0 SYN68
7B4C : 7A 00 19   dec $0019      ;decr value in addr 0019
7B4F : 26 E5      bne L7B36      ;branch Z=0 SYN36
7B51 : 7A 00 1A   dec $001A      ;decr value in addr 001A
7B54 : 2A D9      bpl L7B2F      ;branch N=0 SYN65
7B56 : DE 22      ldx $22        ;load X with value in addr 22
7B58 : 08         inx            ;incr X
7B59 : E6 00      ldab $00,x     ;load B with value in addr X
7B5B : 26 CE      bne L7B2B      ;branch Z=0 SYN64
7B5D : 86 80      ldaa #$80      ;load A with value 80h
7B5F : B7 84 00   staa $8400     ;store A in DAC output SOUND 
7B62 : 3E         wai            ;wait for interrupt
;SYN69 L7B63:
7B63 : 20 A1      bra L7B06      ;branch always SYNTH6
;*************************************;
;IRQ
;*************************************;
7B65 : 8E 00 7F   lds  #$007F    ;load SP with value 007Fh (#ENDRAM)
7B68 : CE 78 C5   ldx #$78C5     ;load X with value 78C5h (SYN02)
7B6B : DF 26      stx $26        ;store X in addr 26
7B6D : B6 84 02   ldaa $8402     ;load A with addr 8402 (PIA sound select)
7B70 : CE 00 00   ldx #$0000     ;load X with value 0000h
7B73 : DF 22      stx $22        ;store X in addr 22
7B75 : C6 AF      ldab #$AF      ;load B with value AFh
7B77 : D7 1E      stab $1E       ;store B in addr 1E
7B79 : 0E         cli            ;clear interrupts I=0
7B7A : 43         coma           ;complement 1s A, invert bits
7B7B : 81 46      cmpa #$46      ;compare A with value 46h
7B7D : 27 04      beq L7B83      ;branch Z=1 IRQ1
7B7F : 85 40      bita #$40      ;bit test A with value 40h
7B81 : 26 83      bne L7B06      ;branch Z=0 SYNTH6
;IRQ1 L7B83:
7B83 : 84 1F      anda #$1F      ;and A with value 1Fh
7B85 : 27 17      beq L7B9E      ;branch Z=1 IRQ2
7B87 : 81 18      cmpa #$18      ;compare A with value 18h
7B89 : 22 D8      bhi L7B63      ;branch C+Z=0
7B8B : 4A         deca           ;decr A
7B8C : 48         asla           ;arith shift left A
7B8D : CE 7C F6   ldx #$7CF6     ;load X with value 7CF6h (JMPTBL)
7B90 : 8D 22      bsr L7BB4      ;branch sub CALCOS
7B92 : EE 00      ldx $00,x      ;load X with addr X
7B94 : AD 00      jsr $00,x      ;jump sub to addr X (JMPTBL)
7B96 : 86 80      ldaa #$80      ;load A with value 80h
7B98 : B7 84 00   staa $8400     ;store A in DAC output SOUND 
7B9B : 7C 00 1F   inc $001F      ;incr value in addr 001F
;IRQ2 L7B9E:
7B9E : 96 20      ldaa $20       ;load A with value in addr 20
;IRQ3 L7BA0:
7BA0 : 27 FE      beq L7BA0      ;branch Z=1 IRQ3
7BA2 : CE 00 00   ldx #$0000     ;load X with value 0000h
7BA5 : DF 22      stx $22        ;store X in addr 22
7BA7 : CE 00 30   ldx #$0030     ;load X with value 0030h
7BAA : C6 1C      ldab #$1C      ;load B with value 1Ch
7BAC : BD 7A 13   jsr L7A13      ;jump sub TRANS
7BAF : BD 78 20   jsr L7820      ;jump sub PARAM1
;IRQ4 L7BB2:
7BB2 : 20 FE      bra L7BB2      ;branch always IRQ4
;*************************************;
;CALCOS - ADDX - ADD A TO INDEX REGISTER
;*************************************;
;ADDX L7BB4:
7BB4 : DF 24      stx $24        ;store X in addr 24 (XPLAY)
7BB6 : 9B 25      adda $25       ;add A with value in addr 25 (XPLAY+1)
7BB8 : 97 25      staa $25       ;store A in addr 25 (XPLAY+1)
7BBA : 96 24      ldaa $24       ;load A with value in addr 24 (XPLAY)
7BBC : 89 00      adca #$00      ;A = C + A + 00h
7BBE : 97 24      staa $24       ;store A in addr 24 (XPLAY)
7BC0 : DE 24      ldx $24        ;load X with value at addr 09 (XPLAY)
7BC2 : 39         rts            ;return subroutine
;*************************************;
;NMI
;*************************************;
7BC3 : 0F         sei            ;set interrupt mask I=1
7BC4 : CE 7F FF   ldx #$7FFF     ;load X with value 7FFFh ( )
7BC7 : 5F         clrb           ;clear B
;NMI1 L7BC8:
7BC8 : E9 00      adcb $00,x     ;A = C + A + X,00h
7BCA : 09         dex            ;decr X
7BCB : 8C 78 00   cpx #$7800     ;compare X with value 7800h (PIA sound select)
7BCE : 26 F8      bne L7BC8      ;branch Z=0 NMI1
7BD0 : E1 00      cmpb $00,x     ;compare B with X
7BD2 : 27 01      beq L7BD5      ;branch Z=1 NMI2
7BD4 : 3E         wai            ;wait for interrupt
;NMI2 L7BD5:
7BD5 : CE 78 C5   ldx #$78C5     ;load X with value 78C5h (SYN02)
7BD8 : DF 26      stx $26        ;store X in addr 26
7BDA : CE 00 00   ldx #$0000     ;load X with value 0000h
7BDD : DF 22      stx $22        ;store X in addr 22
7BDF : BD 79 D0   jsr L79D0      ;jump sub SYNTH4
7BE2 : 20 F1      bra L7BD5      ;branch always NMI2
;*************************************;
;FDB tables below
;*************************************;
;SNDTBL FDBTBL1 
7BE4 : DA FF DA 80 26 01 26 80
7BEC : 07 0A 07 00 F9 F6 F9 00 
;NOTTBL FDBTBL2 
7BF4 : 3A 3E 50 46 33 2C 27 20 
7BFC : 25 1C 1A 17 14 11 10 33
;WAVFRM FDBTBL3 
7C04 : 08 03 02 01 02 03 04 05
7C0C : 06 0A 1E  32 70 00 
;VEC01 FDBTBL4 
7C12 : FFFF FF90 FFFF FFFF FFFF
7C1C : FF90 FFFF FFFF FFFF FFFF 
7C26 : 0000 0000 0000 0000
;VEC02 FDBTBL5 
7C2E : 4801 0000 3F3F 0000 4801
7C38 : 0000 0108 0000 8101 0000
7C42 : 01FF 0000 0108 0000
;VEC03 FDBTBL6
7C4A : 0110 0000 3F3F 0000 0110
7C54 : 0000 0505 0000 0101 0000
7C5E : 31FF 0000 0505 0000
;VEC04 FDBTBL7 
7C66 : 3000 0000 7F00 0000 3000 
7C70 : 0000 0100 0000 7F00 0000 
7C7A : 0200 0000 0100 0000 
;VEC05 FDBTBL8 
7C82 : 0400 0004 7F00 007F 0400
7C8C : 0004 FF00 00A0 0000 0000 
7C96 : 0000 0000 FF00 00A0 
;VEC06 FDBTBL9 
7C9E : 0C68 6800 071F 0F00 0C80 
7CA8 : 8000 FFFF FF00 0000 0000 
7CB2 : 0000 0000 FFFF FF00
;*************************************;
; Vectors
;*************************************;
;VEC01X FDBVECT1
7CBA : FF01 02C3 FF00 
;VEC02X FDBVECT2
7CC0 : 0103 FF80 FF00
;VEC03X FDBVECT3
7CC6 : 2003 FF50 FF00
;VEC04X FDBVECT4
7CCC : 5003 0120 FF00
;VEC05X FDBVECT5
7CD2 : FE04 0204 FF00 
;VEC06X FDBVECT6
7CD8 : 4803 010C FF00 
;VEC07X FDBVECT7
7CDE : 4802 010C FF00 
;VEC08X FDBVECT8
7CE4 : E001 0210 FF00 
;VEC09X FDBVECT9
7CEA : 50FF 0000 6080
;VEC010X FDBVECT10
7CF0 : FF02 0106 FF00 
;*************************************;
;SPECIAL ROUTINE JUMP TABLE
;*************************************;
;JMPTBL
7CF6 : 79 D0                     ;SND1 (SYNTH4)
7CF8 : 78 D5                     ;SND2 (PARAM3)
7CFA : 78 DA                     ;SND3 (PRM31)
7CFC : 78 DF                     ;SND4 (PRM32)
7CFE : 78 E4                     ;SND5 (PRM33)
7D00 : 79 70                     ;SYNTH2 (no source)
7D02 : 79 99                     ;SYN30 (poss LITEN+NOISE)
7D04 : 78 C9                     ;THNDR (PARAM2)
7D06 : 7A 58                     ;HSTD (PARAM16)
7D08 : 7A 33                     ;ATARI (PARAM12)
7D0A : 7A 38                     ;SIREN (PARAM13)
7D0C : 7A 4A                     ;ORRRR (PARAM14)
7D0E : 7A 4F                     ;PERK$ (PARAM15)
7D10 : 7A 27                     ;PERK (PARAM10)
7D12 : 7A 61                     ;PERK$$ (PARAM17)
7D14 : 7A 6A                     ;SQRT (PARAM18)
7D16 : 78 E9                     ;PARAM4 (then to THNDR1)
7D18 : 79 1B                     ;PARAM6 (to IRQ2 then 3 OSCIL Sound)
7D1A : 79 06                     ;PARAM5 (sets params only)
7D1C : 79 CB                     ;BONUS (PARAM8)
7D1E : 79 42                     ;BONUS$ (PARAM7)
7D20 : 79 91                     ;SYNTH3 (possible LITEN+NOISE routine)
7D22 : 7A 09                     ;START (PARAM9)
7D24 : 79 51                     ;PLANE (SYNTH1)
;*************************************;
;zero padding
;*************************************;
7D26 : 00
7D27 : 00 00 00 00 "    "  db $00, $00, $00, $00
7D2B : 00 00 00 00 "    "  db $00, $00, $00, $00
7D2F : 00 00 00 00 "    "  db $00, $00, $00, $00
7D33 : 00 00 00 00 "    "  db $00, $00, $00, $00
7D37 : 00 00 00 00 "    "  db $00, $00, $00, $00
7D3B : 00 00 00 00 "    "  db $00, $00, $00, $00
7D3F : 00 00 00 00 "    "  db $00, $00, $00, $00
7D43 : 00 00 00 00 "    "  db $00, $00, $00, $00
7D47 : 00 00 00 00 "    "  db $00, $00, $00, $00
7D4B : 00 00 00 00 "    "  db $00, $00, $00, $00
7D4F : 00 00 00 00 "    "  db $00, $00, $00, $00
7D53 : 00 00 00 00 "    "  db $00, $00, $00, $00
7D57 : 00 00 00 00 "    "  db $00, $00, $00, $00
7D5B : 00 00 00 00 "    "  db $00, $00, $00, $00
7D5F : 00 00 00 00 "    "  db $00, $00, $00, $00
7D63 : 00 00 00 00 "    "  db $00, $00, $00, $00
7D67 : 00 00 00 00 "    "  db $00, $00, $00, $00
7D6B : 00 00 00 00 "    "  db $00, $00, $00, $00
7D6F : 00 00 00 00 "    "  db $00, $00, $00, $00
7D73 : 00 00 00 00 "    "  db $00, $00, $00, $00
7D77 : 00 00 00 00 "    "  db $00, $00, $00, $00
7D7B : 00 00 00 00 "    "  db $00, $00, $00, $00
7D7F : 00 00 00 00 "    "  db $00, $00, $00, $00
7D83 : 00 00 00 00 "    "  db $00, $00, $00, $00
7D87 : 00 00 00 00 "    "  db $00, $00, $00, $00
7D8B : 00 00 00 00 "    "  db $00, $00, $00, $00
7D8F : 00 00 00 00 "    "  db $00, $00, $00, $00
7D93 : 00 00 00 00 "    "  db $00, $00, $00, $00
7D97 : 00 00 00 00 "    "  db $00, $00, $00, $00
7D9B : 00 00 00 00 "    "  db $00, $00, $00, $00
7D9F : 00 00 00 00 "    "  db $00, $00, $00, $00
7DA3 : 00 00 00 00 "    "  db $00, $00, $00, $00
7DA7 : 00 00 00 00 "    "  db $00, $00, $00, $00
7DAB : 00 00 00 00 "    "  db $00, $00, $00, $00
7DAF : 00 00 00 00 "    "  db $00, $00, $00, $00
7DB3 : 00 00 00 00 "    "  db $00, $00, $00, $00
7DB7 : 00 00 00 00 "    "  db $00, $00, $00, $00
7DBB : 00 00 00 00 "    "  db $00, $00, $00, $00
7DBF : 00 00 00 00 "    "  db $00, $00, $00, $00
7DC3 : 00 00 00 00 "    "  db $00, $00, $00, $00
7DC7 : 00 00 00 00 "    "  db $00, $00, $00, $00
7DCB : 00 00 00 00 "    "  db $00, $00, $00, $00
7DCF : 00 00 00 00 "    "  db $00, $00, $00, $00
7DD3 : 00 00 00 00 "    "  db $00, $00, $00, $00
7DD7 : 00 00 00 00 "    "  db $00, $00, $00, $00
7DDB : 00 00 00 00 "    "  db $00, $00, $00, $00
7DDF : 00 00 00 00 "    "  db $00, $00, $00, $00
7DE3 : 00 00 00 00 "    "  db $00, $00, $00, $00
7DE7 : 00 00 00 00 "    "  db $00, $00, $00, $00
7DEB : 00 00 00 00 "    "  db $00, $00, $00, $00
7DEF : 00 00 00 00 "    "  db $00, $00, $00, $00
7DF3 : 00 00 00 00 "    "  db $00, $00, $00, $00
7DF7 : 00 00 00 00 "    "  db $00, $00, $00, $00
7DFB : 00 00 00 00 "    "  db $00, $00, $00, $00
7DFF : 00 00 00 00 "    "  db $00, $00, $00, $00
7E03 : 00 00 00 00 "    "  db $00, $00, $00, $00
7E07 : 00 00 00 00 "    "  db $00, $00, $00, $00
7E0B : 00 00 00 00 "    "  db $00, $00, $00, $00
7E0F : 00 00 00 00 "    "  db $00, $00, $00, $00
7E13 : 00 00 00 00 "    "  db $00, $00, $00, $00
7E17 : 00 00 00 00 "    "  db $00, $00, $00, $00
7E1B : 00 00 00 00 "    "  db $00, $00, $00, $00
7E1F : 00 00 00 00 "    "  db $00, $00, $00, $00
7E23 : 00 00 00 00 "    "  db $00, $00, $00, $00
7E27 : 00 00 00 00 "    "  db $00, $00, $00, $00
7E2B : 00 00 00 00 "    "  db $00, $00, $00, $00
7E2F : 00 00 00 00 "    "  db $00, $00, $00, $00
7E33 : 00 00 00 00 "    "  db $00, $00, $00, $00
7E37 : 00 00 00 00 "    "  db $00, $00, $00, $00
7E3B : 00 00 00 00 "    "  db $00, $00, $00, $00
7E3F : 00 00 00 00 "    "  db $00, $00, $00, $00
7E43 : 00 00 00 00 "    "  db $00, $00, $00, $00
7E47 : 00 00 00 00 "    "  db $00, $00, $00, $00
7E4B : 00 00 00 00 "    "  db $00, $00, $00, $00
7E4F : 00 00 00 00 "    "  db $00, $00, $00, $00
7E53 : 00 00 00 00 "    "  db $00, $00, $00, $00
7E57 : 00 00 00 00 "    "  db $00, $00, $00, $00
7E5B : 00 00 00 00 "    "  db $00, $00, $00, $00
7E5F : 00 00 00 00 "    "  db $00, $00, $00, $00
7E63 : 00 00 00 00 "    "  db $00, $00, $00, $00
7E67 : 00 00 00 00 "    "  db $00, $00, $00, $00
7E6B : 00 00 00 00 "    "  db $00, $00, $00, $00
7E6F : 00 00 00 00 "    "  db $00, $00, $00, $00
7E73 : 00 00 00 00 "    "  db $00, $00, $00, $00
7E77 : 00 00 00 00 "    "  db $00, $00, $00, $00
7E7B : 00 00 00 00 "    "  db $00, $00, $00, $00
7E7F : 00 00 00 00 "    "  db $00, $00, $00, $00
7E83 : 00 00 00 00 "    "  db $00, $00, $00, $00
7E87 : 00 00 00 00 "    "  db $00, $00, $00, $00
7E8B : 00 00 00 00 "    "  db $00, $00, $00, $00
7E8F : 00 00 00 00 "    "  db $00, $00, $00, $00
7E93 : 00 00 00 00 "    "  db $00, $00, $00, $00
7E97 : 00 00 00 00 "    "  db $00, $00, $00, $00
7E9B : 00 00 00 00 "    "  db $00, $00, $00, $00
7E9F : 00 00 00 00 "    "  db $00, $00, $00, $00
7EA3 : 00 00 00 00 "    "  db $00, $00, $00, $00
7EA7 : 00 00 00 00 "    "  db $00, $00, $00, $00
7EAB : 00 00 00 00 "    "  db $00, $00, $00, $00
7EAF : 00 00 00 00 "    "  db $00, $00, $00, $00
7EB3 : 00 00 00 00 "    "  db $00, $00, $00, $00
7EB7 : 00 00 00 00 "    "  db $00, $00, $00, $00
7EBB : 00 00 00 00 "    "  db $00, $00, $00, $00
7EBF : 00 00 00 00 "    "  db $00, $00, $00, $00
7EC3 : 00 00 00 00 "    "  db $00, $00, $00, $00
7EC7 : 00 00 00 00 "    "  db $00, $00, $00, $00
7ECB : 00 00 00 00 "    "  db $00, $00, $00, $00
7ECF : 00 00 00 00 "    "  db $00, $00, $00, $00
7ED3 : 00 00 00 00 "    "  db $00, $00, $00, $00
7ED7 : 00 00 00 00 "    "  db $00, $00, $00, $00
7EDB : 00 00 00 00 "    "  db $00, $00, $00, $00
7EDF : 00 00 00 00 "    "  db $00, $00, $00, $00
7EE3 : 00 00 00 00 "    "  db $00, $00, $00, $00
7EE7 : 00 00 00 00 "    "  db $00, $00, $00, $00
7EEB : 00 00 00 00 "    "  db $00, $00, $00, $00
7EEF : 00 00 00 00 "    "  db $00, $00, $00, $00
7EF3 : 00 00 00 00 "    "  db $00, $00, $00, $00
7EF7 : 00 00 00 00 "    "  db $00, $00, $00, $00
7EFB : 00 00 00 00 "    "  db $00, $00, $00, $00
7EFF : 00 00 00 00 "    "  db $00, $00, $00, $00
7F03 : 00 00 00 00 "    "  db $00, $00, $00, $00
7F07 : 00 00 00 00 "    "  db $00, $00, $00, $00
7F0B : 00 00 00 00 "    "  db $00, $00, $00, $00
7F0F : 00 00 00 00 "    "  db $00, $00, $00, $00
7F13 : 00 00 00 00 "    "  db $00, $00, $00, $00
7F17 : 00 00 00 00 "    "  db $00, $00, $00, $00
7F1B : 00 00 00 00 "    "  db $00, $00, $00, $00
7F1F : 00 00 00 00 "    "  db $00, $00, $00, $00
7F23 : 00 00 00 00 "    "  db $00, $00, $00, $00
7F27 : 00 00 00 00 "    "  db $00, $00, $00, $00
7F2B : 00 00 00 00 "    "  db $00, $00, $00, $00
7F2F : 00 00 00 00 "    "  db $00, $00, $00, $00
7F33 : 00 00 00 00 "    "  db $00, $00, $00, $00
7F37 : 00 00 00 00 "    "  db $00, $00, $00, $00
7F3B : 00 00 00 00 "    "  db $00, $00, $00, $00
7F3F : 00 00 00 00 "    "  db $00, $00, $00, $00
7F43 : 00 00 00 00 "    "  db $00, $00, $00, $00
7F47 : 00 00 00 00 "    "  db $00, $00, $00, $00
7F4B : 00 00 00 00 "    "  db $00, $00, $00, $00
7F4F : 00 00 00 00 "    "  db $00, $00, $00, $00
7F53 : 00 00 00 00 "    "  db $00, $00, $00, $00
7F57 : 00 00 00 00 "    "  db $00, $00, $00, $00
7F5B : 00 00 00 00 "    "  db $00, $00, $00, $00
7F5F : 00 00 00 00 "    "  db $00, $00, $00, $00
7F63 : 00 00 00 00 "    "  db $00, $00, $00, $00
7F67 : 00 00 00 00 "    "  db $00, $00, $00, $00
7F6B : 00 00 00 00 "    "  db $00, $00, $00, $00
7F6F : 00 00 00 00 "    "  db $00, $00, $00, $00
7F73 : 00 00 00 00 "    "  db $00, $00, $00, $00
7F77 : 00 00 00 00 "    "  db $00, $00, $00, $00
7F7B : 00 00 00 00 "    "  db $00, $00, $00, $00
7F7F : 00 00 00 00 "    "  db $00, $00, $00, $00
7F83 : 00 00 00 00 "    "  db $00, $00, $00, $00
7F87 : 00 00 00 00 "    "  db $00, $00, $00, $00
7F8B : 00 00 00 00 "    "  db $00, $00, $00, $00
7F8F : 00 00 00 00 "    "  db $00, $00, $00, $00
7F93 : 00 00 00 00 "    "  db $00, $00, $00, $00
7F97 : 00 00 00 00 "    "  db $00, $00, $00, $00
7F9B : 00 00 00 00 "    "  db $00, $00, $00, $00
7F9F : 00 00 00 00 "    "  db $00, $00, $00, $00
7FA3 : 00 00 00 00 "    "  db $00, $00, $00, $00
7FA7 : 00 00 00 00 "    "  db $00, $00, $00, $00
7FAB : 00 00 00 00 "    "  db $00, $00, $00, $00
7FAF : 00 00 00 00 "    "  db $00, $00, $00, $00
7FB3 : 00 00 00 00 "    "  db $00, $00, $00, $00
7FB7 : 00 00 00 00 "    "  db $00, $00, $00, $00
7FBB : 00 00 00 00 "    "  db $00, $00, $00, $00
7FBF : 00 00 00 00 "    "  db $00, $00, $00, $00
7FC3 : 00 00 00 00 "    "  db $00, $00, $00, $00
7FC7 : 00 00 00 00 "    "  db $00, $00, $00, $00
7FCB : 00 00 00 00 "    "  db $00, $00, $00, $00
7FCF : 00 00 00 00 "    "  db $00, $00, $00, $00
7FD3 : 00 00 00 00 "    "  db $00, $00, $00, $00
7FD7 : 00 00 00 00 "    "  db $00, $00, $00, $00
7FDB : 00 00 00 00 "    "  db $00, $00, $00, $00
7FDF : 00 00 00 00 "    "  db $00, $00, $00, $00
7FE3 : 00 00 00 00 "    "  db $00, $00, $00, $00
7FE7 : 00 00 00 00 "    "  db $00, $00, $00, $00
7FEB : 00 00 00 00 "    "  db $00, $00, $00, $00
7FEF : 00 00 00 00 "    "  db $00, $00, $00, $00
7FF3 : 00 00 00 00 "    "  db $00, $00, $00, $00
7FF7 : 00
;*************************************;
;Motorola vector table
;*************************************; 
7FF8 : 7B 65                  ;IRQ 
7FFA : 78 01                  ;RESET SWI (software)  
7FFC : 7B C3                  ;NMI  
7FFE : 78 01                  ;RESET (hardware)

;--------------------------------------------------------------

;MEM ADDRS:
00 FREQ1  (frequency constant)
01 FREQ2
02 FREQ3
03 FREQ4
;
04 DELTA1 (delta amplitude)
05
06
07 DELTA4
;
08 FREQ1$ (frequency counter)
09 FREQ2$
0A FREQ3$
0B FREQ4$
;
0C CYCLE1 (cycle constant)
0D
0E
0F CYCLE4
;
18 CYCL1$ (cycle counter)
19
1A
1B CYCL4$
;
1D RANDOM
1E AMP0
21 SNDX1
;
22 XPTR
23 XPTR +1
24 XPLAY
25 XPLAY +1
26 XDECAY
27 XDECAY +1
;
7F ENDRAM FLAG BIT
;;;;;;;;;;;;;;;;;;;



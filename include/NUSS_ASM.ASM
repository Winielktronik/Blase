        MACRO-80 3.43   27-Jul-81       PAGE    1


                                ;------------------
                                ; Nussknacker Steuerung
                                ; VERS. 1.0  23.09.2018
                                ;
                                ; Beinhaltet PIO Ansteuerung
                                ; Ausgang:
                                ; 1. 5V 200mA Getriebemotor Nussbehaelter
                                ; 1. 5V 150mA Getriebemotor Foerderband
                                ; 1. 24V 1A Getriebemotor Schraubstock
                                ; 1. 5V Vierphasen Steppermotor Schieber
                                ;------------
                                ; Eingang:
                                ; 1. Reflektor Nussbehaelter auswurf
                                ; 1. Lichtschranke Foerderband
                                ; 1. Homeschalter Schieber
                                ; 1. Schraubstock Wegeschalter
                                ; 1. Knack erkennungs Sensor
                                ;
                                ; LCD128X128 STEUERBEFEHLE
                                ; 29.12.2017 LCD INITIALISIERUNG
                                
  0000'                         ASEG
                                .Z80
                                
                                ORG 0H
                                
                         C      INCLUDE Z84C15H.MAC
                         C      ;--------------------------
                         C      ; BIOS Hardware CS Adresse
                         C      ; Z84C15 PERIFERIE
                         C      ; 22.09.2018 Hansjoerg Winterhalter
                         C      ;
  0018                   C      SIOA    EQU 18H         ; SIOA DATA REGISTER (84C43)
                         C                              ; SIOA +1 CONTROLL REGISTER
  001A                   C      SIOB    EQU 1AH         ; SIOB DATA REGISTER (84C43)
                         C                              ; SIOB +1 CONTROLL REGISTER
  0010                   C      CTC0    EQU 10H         ; CTC    CH0 CONTROLL REGISTER (84C30)
  0011                   C      CTC1    EQU 11H         ; CTC +1 CH1 CONTROLL REGISTER (84C30)
  0012                   C      CTC2    EQU 12H         ; CTC +2 CH2 CONTROLL REGISTER (84C30)
  0013                   C      CTC3    EQU 13H         ; CTC +3 CH3 CONTROLL REGISTER (84C30)
  001C                   C      PIOA    EQU 1CH         ; PIOA DATA REGISTER (84C20)
                         C                              ; PIOA +1 COMMAND REGISTER
  001E                   C      PIOB    EQU 1EH         ; PIOB DATA REGISTER (84C20)
                         C                              ; PIOB +1 COMMAND REGISTER
                         C      ;---------------
  00F0                   C      WDTMR   EQU 0F0H        ; MASTER REGISTER WATCH DOG TIMER
  00F1                   C      WDTCR   EQU 0F1H        ; CONTROLL REGISTER
  00F4                   C      DCI     EQU 0F4H        ; DAISY-CAINE-INTRRUPT
                         C      ;---------------
  00EE                   C      SCRP    EQU 0EEH        ; SYSTEM CONTROLL REGISTER POINTER
  00EF                   C      SCDP    EQU 0EFH        ; SYSTEM CONTROLL DATA PORT
                         C      ;---------------
                         C      ; I/O CONTROLL REGISTER ADDRESS
                         C      ; END
  8000                          RAM     EQU 8000H       ; START SRAM ADRESSE
  8000                          STATUS  EQU RAM         ; FEHLER ZUSTAND
        MACRO-80 3.43   27-Jul-81       PAGE    1-1


  8002                          WEG     EQU STATUS+2    ; STEPP DER ABLAEUFE
  8004                          STEPC   EQU WEG+2       ; STEP COUNT
                                
  9FF0                          IADR    EQU RAM+1FF0H   ; INTERRUPT SPRUNGADRESSE
  0004                          LATCH   EQU 04H         ; 74LS273 FUER UL2069 OUTPUT
                                
                                ;------------------------
                                ; CTC COMMANDOS
                                ;
  0007                          BAUD0   EQU 07H         ;9600 
  0004                          TIME0   EQU 04H         ;TIME CONSTANTE
  0047                          BAUD1   EQU 47H         ;TGOT 1:2
  0004                          TIME1   EQU 04H
  0047                          BAUD2   EQU 47H         ;TGOT 1:2
  0004                          TIME2   EQU 04H
  0087                          BAUD3   EQU 087H        ; MIT INT =0E7H TGOUT
  0050                          TIME3   EQU 050H
  0080                          MSTIME  EQU 80H
                                
                                ;------------------------
                                ; SIO COMMANDOS
                                ;
  0018                          SIORES  EQU 18H         ; SIO RESET
  0004                          KANAL4  EQU 04H         ; REG4
  0044                          REG4    EQU 44H         ; X16 CLOCK,8,SYNC
  0003                          KANAL3  EQU 03H         ; REG3
  00C1                          REG3    EQU 0C1H        ; 8BIT RX ENABLE
  0005                          KANAL5  EQU 05H         ; REG5
  00EA                          REG5    EQU 0EAH        ; DTR,TX8BIT,TX ENABLE
  0001                          KANAL1  EQU 01H         ; REG1
  0000                          REG1    EQU 00H         ; NO INT
  0000                          KANAL0  EQU 00H         ; REG0
                                
                                ;------------------------
                                ; PIO INIT 0=OUT/1=IN
                                ;
  0000    31 9FF0                       LD SP,RAM+1FF0H
  0003    ED 5E                         IM 2
  0005    FB                            EI      ;DI
                                
  0006    3E DB                         LD A,0DBH
  0008    D3 F1                         OUT (WDTCR),A
  000A    3E 7B                         LD A,07BH
  000C    D3 F0                         OUT (WDTMR),A
  000E    3E B1                         LD A,0B1H
  0010    D3 F1                         OUT (WDTCR),A
                                        ;---------------
                                        ;PIOA
  0012    3E CF                         LD A,0CFH       ; MODE 3
  0014    D3 1D                         OUT (PIOA+1),A
  0016    3E F0                         LD A,0F0H
  0018    D3 1D                         OUT (PIOA+1),A  ; I/O PIN
  001A    3E 07                         LD A,07H
  001C    D3 1D                         OUT (PIOA+1),A  ; NO INT
                                        ;------
                                        ; PIOB
        MACRO-80 3.43   27-Jul-81       PAGE    1-2


  001E    3E CF                         LD A,0CFH       ; MODE 3
  0020    D3 1F                         OUT (PIOB+1),A
  0022    3E 5F                         LD A,5FH
  0024    D3 1F                         OUT (PIOB+1),A  ; I/O PIN
  0026    3E 07                         LD A,07H
  0028    D3 1F                         OUT (PIOB+1),A  ; NO INT
                                
                                ;------------------------
                                ;V24 SIOA, SIOB
                                ; LCD 4BIT INIT
                                ; HD6402 PINBELEGUNG:
                                ; 5(RBR8)= D7, 6(RBR7)= D6, 7(RBR6)= D5
                                ; 8(RBR5)= D4, 9(RBR4)= BACKLIGHT, 10(RBR3)=NC
                                ; 11(RBR2)= E, 12(RBR1)=RS
                                ; LCD PIN5 =R/W-> GND
                                ;
                                        ;BAUD GESAMT
  002A    3E 07                         LD A,BAUD0
  002C    D3 10                         OUT (CTC0),A
  002E    3E 04                         LD A,TIME0
  0030    D3 10                         OUT (CTC0),A
                                        ;-------
                                        ;BAUD SIOA
  0032    3E 47                         LD A,BAUD1
  0034    D3 11                         OUT (CTC1),A
  0036    3E 04                         LD A,TIME1
  0038    D3 11                         OUT (CTC1),A
                                        ;-------
                                        ;BAUD SIOB
  003A    3E 47                         LD A,BAUD2
  003C    D3 12                         OUT (CTC2),A
  003E    3E 04                         LD A,TIME2
  0040    D3 12                         OUT (CTC2),A
                                
                                ;------------------------
                                ; START
  0042    3E 80                         LD A,80H
  0044    22 8004                       LD (STEPC),HL
  0047    21 9FF0                       LD HL,IADR
  004A    7D                    ICTC0:  LD A,L
  004B    E6 07                         AND 07H
  004D    28 03                         JR Z,ICTC1      ; -> CTC0
  004F    23                            INC HL
  0050    18 F8                         JR ICTC0
                                        ;-----------
  0052    7C                    ICTC1:  LD A,H
  0053    ED 47                         LD I,A
  0055    3E 87                         LD A,BAUD3
  0057    D3 13                         OUT (CTC3),A
  0059    3E 50                         LD A,TIME3
  005B    D3 13                         OUT (CTC3),A
  005D    7D                            LD A,L
  005E    D3 10                         OUT (CTC0),A
  0060    23                            INC HL
  0061    23                            INC HL  ;CTC1
  0062    23                            INC HL
        MACRO-80 3.43   27-Jul-81       PAGE    1-3


  0063    23                            INC HL  ;CTC2
  0064    23                            INC HL
  0065    23                            INC HL  ;CTC3
  0066    11 013D                       LD DE,TIME
  0069    73                            LD (HL),E
  006A    23                            INC HL
  006B    72                            LD (HL),D
                                        ;--------------
                                
  006C    3A 800A               LOP3:   LD A,(RAM+10)
  006F    D3 04                         OUT (LATCH),A   ; MOTOR 
  0071    3C                            INC A
  0072    32 800A                       LD (RAM+10),A
  0075    3A 8000                       LD A,(RAM)
                                ;       JR NZ,LOP3 
  0078    E6 0F                         AND 0FH
                                ;       OUT (PIOA),A
  007A    3C                            INC A
  007B    32 8000                       LD (RAM),A
  007E    CD 009B                       CALL STEPMR
  0081    18 E9                         JR LOP3
                                
  0083    3E 00                         LD A,00H        ; OUTPUT 74LS273 STOPP
  0085    D3 04                 LOP2:   OUT (LATCH),A   ; MOTOR 
  0087    32 8000                       LD (RAM),A
                                ;       AND 0FH
                                ;       OUT (PIOA),A    ; ZUM TEST
  008A    3A 800A                       LD A,(RAM+10)
  008D    3C                            INC A
  008E    D3 1C                         OUT (PIOA),A
  0090    32 800A                       LD (RAM+10),A
  0093    3E 4F                         LD A,4FH
                                ;       OUT (WDTCR),A
  0095    3A 8000                       LD A,(RAM)
  0098    3C                            INC A
                                ;       JR NZ,LOP2
  0099    18 EA                         JR LOP2
                                
                                ;------------------------
                                ; 4 Phasen Steppermotor rechts/zurueck
                                ; TAKT AN PIOA PA3-PA0
                                ; -> 5,9,A,6,5,usw.....
                                ;
  009B    F5                    STEPMR: PUSH AF
  009C    C5                            PUSH BC
  009D    E5                            PUSH HL
                                        ; ENDSCHALTER ABFRAGE
  009E    DB 1E                         IN A,(PIOB)
  00A0    47                            LD B,A
  00A1    DB 1C                         IN A,(PIOA)
  00A3    E6 F0                         AND 0F0H
  00A5    CB 58                         BIT 3,B         ; ENDSCHALTER
  00A7    28 4D                         JR Z,STEP96
                                        ; COUNTER ABFRAGEN
  00A9    3A 8004                       LD A,(STEPC)
  00AC    FE 00                         CP 0
        MACRO-80 3.43   27-Jul-81       PAGE    1-4


  00AE    20 42                         JR NZ,STEP97
                                        ;---------
  00B0    3A 8005                       LD A,(STEPC+1)
  00B3    3D                            DEC A
  00B4    32 8005                       LD (STEPC+1),A
  00B7    DB 1C                         IN A,(PIOA)
  00B9    E6 F0                         AND 0F0H
  00BB    47                            LD B,A
  00BC    DB 1C                         IN A,(PIOA)
  00BE    E6 0F                         AND 0FH         ; PA0-PA3
  00C0    FE 05                         CP 05H
  00C2    28 10                         JR Z,FLIP741
  00C4    FE 06                         CP 06H
  00C6    28 18                         JR Z,FLIP742
  00C8    FE 09                         CP 09H
  00CA    28 10                         JR Z,FLIP743
  00CC    FE 0A                         CP 0AH
  00CE    28 08                         JR Z,FLIP744
  00D0    3E 05                         LD A,05H
  00D2    18 0E                         JR STEP99
                                        ;----------     
  00D4                          FLIP741:
  00D4    C6 04                         ADD A,04H       ; 05+04=09
  00D6    18 0A                         JR STEP99
  00D8                          FLIP744:
  00D8    D6 04                         SUB 04H         ; 0A-04=06
  00DA    18 06                         JR STEP99
  00DC                          FLIP743:
  00DC    C6 01                         ADD A,01H       ; 09+01=0A
  00DE    18 02                         JR STEP99
  00E0                          FLIP742:
  00E0    D6 01                         SUB 01H         ; 06-01=05
  00E2    4F                    STEP99: LD C,A
  00E3    3E 3C                         LD A,3CH        ; 1ms*HL 
  00E5    32 8004                       LD (STEPC),A
  00E8    79                            LD A,C
  00E9    B0                            OR B            ; PIOA PA4 - 7
  00EA    D3 1C                 STEP98: OUT (PIOA),A
  00EC    DB 1E                         IN A,(PIOB)
  00EE    C6 20                         ADD A,20H
  00F0    D3 1E                         OUT (PIOB),A
  00F2    E1                    STEP97: POP HL
  00F3    C1                            POP BC
  00F4    F1                            POP AF  
  00F5    C9                            RET
                                ;---------------
                                ; ENDSCHALTER ERREICHT
                                ;
  00F6    F5                    STEP96: PUSH AF
  00F7    3E 00                         LD A,00H
  00F9    32 8005                       LD (STEPC+1),A
  00FC    F1                            POP AF
  00FD    18 EB                         JR STEP98
                                
                                ;------------------------
                                ; 4 Phasen Steppermotor links/Auswurf
        MACRO-80 3.43   27-Jul-81       PAGE    1-5


                                ; TAKT AN PIOA PA3-PA0
                                ; -> 5,6,A,9,5,usw.....
  00FF    F5                    STEPML: PUSH AF
  0100    C5                            PUSH BC
  0101    E5                            PUSH HL
                                        ; COUNTER ABFRAGEN
  0102    3A 8004                       LD A,(STEPC)
  0105    FE 00                         CP 0
  0107    20 E9                         JR NZ,STEP97
                                        ;---------
  0109    3A 8005                       LD A,(STEPC+1)
  010C    3C                            INC A
  010D    32 8005                       LD (STEPC+1),A
  0110    DB 1C                         IN A,(PIOA)
  0112    E6 F0                         AND 0F0H
  0114    47                            LD B,A
  0115    DB 1C                         IN A,(PIOA)
  0117    E6 0F                         AND 0FH         ; PA0-PA3
  0119    FE 05                         CP 05H
  011B    28 10                         JR Z,FLOP741
  011D    FE 06                         CP 06H
  011F    28 18                         JR Z,FLOP742
  0121    FE 09                         CP 09H
  0123    28 10                         JR Z,FLOP743
  0125    FE 0A                         CP 0AH
  0127    28 08                         JR Z,FLOP744
  0129    3E 05                         LD A,05H
  012B    18 B5                         JR STEP99
                                        ;----------     
  012D                          FLOP741:
  012D    C6 01                         ADD A,01H       ; 05+01=06
  012F    18 B1                         JR STEP99
  0131                          FLOP744:
  0131    D6 01                         SUB 01H         ; 0A-01=09
  0133    18 AD                         JR STEP99
  0135                          FLOP743:
  0135    D6 04                         SUB 04H         ; 09-04=05
  0137    18 A9                         JR STEP99
  0139                          FLOP742:
  0139    C6 04                         ADD A,04H       ; 06+04=0A
  013B    18 A5                         JR STEP99
                                
                                ;-----------------------
                                ; INTERRUPT ROUTINE  RETI
                                ; Timer in Millisec.
                                ;
  013D    F5                    TIME:   PUSH AF
  013E    3A 8004                       LD A,(STEPC)
  0141    3D                            DEC A
  0142    30 02                         JR NC,TIME01
  0144    3E 00                         LD A,00H
  0146    32 8004               TIME01: LD (STEPC),A
  0149    F1                            POP AF
  014A    FB                            EI
  014B    ED 4D                         RETI
                                
        MACRO-80 3.43   27-Jul-81       PAGE    1-6


                                ;------------------------
                                END
        MACRO-80 3.43   27-Jul-81       PAGE    S


Macros:

Symbols:
0007    BAUD0           0047    BAUD1           0047    BAUD2           
0087    BAUD3           0010    CTC0            0011    CTC1            
0012    CTC2            0013    CTC3            00F4    DCI             
00D4    FLIP741         00E0    FLIP742         00DC    FLIP743         
00D8    FLIP744         012D    FLOP741         0139    FLOP742         
0135    FLOP743         0131    FLOP744         9FF0    IADR            
004A    ICTC0           0052    ICTC1           0000    KANAL0          
0001    KANAL1          0003    KANAL3          0004    KANAL4          
0005    KANAL5          0004    LATCH           0085    LOP2            
006C    LOP3            0080    MSTIME          001C    PIOA            
001E    PIOB            8000    RAM             0000    REG1            
00C1    REG3            0044    REG4            00EA    REG5            
00EF    SCDP            00EE    SCRP            0018    SIOA            
001A    SIOB            0018    SIORES          8000    STATUS          
00F6    STEP96          00F2    STEP97          00EA    STEP98          
00E2    STEP99          8004    STEPC           00FF    STEPML          
009B    STEPMR          013D    TIME            0004    TIME0           
0146    TIME01          0004    TIME1           0004    TIME2           
0050    TIME3           00F1    WDTCR           00F0    WDTMR           
8002    WEG             



No Fatal error(s)


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     MR           
8002    WEG             



No Fatal error(s)


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
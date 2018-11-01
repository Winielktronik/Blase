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


  8002                          WEGS    EQU STATUS+2    ; STEPP DER ABLAEUFE
  8004                          STEPC   EQU WEGS+2      ; STEP COUNT
  8006                          STEPCI  EQU STEPC+2     ; INT COUNTER 
  8008                          RLATCH  EQU STEPCI+2    ; WERT FUER 74LS273 LATCH 
                                
  9FF0                          IADR    EQU RAM+1FF0H   ; INTERRUPT SPRUNGADRESSE
                                
  0004                          LATCH   EQU 04H         ; 74LS273 FUER UL2069 OUTPUT
  0008                          SMOT    EQU 08H         ; START MOTOR 74LS74
                                
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
  0000    31 9FF0                       LD SP,IADR
  0003    ED 5E                         IM 2
  0005    FB                            EI
                                        ;------
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
        MACRO-80 3.43   27-Jul-81       PAGE    1-2


  001A    3E 07                         LD A,07H
  001C    D3 1D                         OUT (PIOA+1),A  ; NO INT
                                        ;------
                                        ; PIOB
  001E    3E CF                         LD A,0CFH       ; MODE 3
  0020    D3 1F                         OUT (PIOB+1),A
  0022    3E 5F                         LD A,5FH
  0024    D3 1F                         OUT (PIOB+1),A  ; I/O PIN
  0026    3E 07                         LD A,07H
  0028    D3 1F                         OUT (PIOB+1),A  ; NO INT
                                
                                ;------------------------
                                ;V24 SIOA, SIOB
                                ; LCD 4BIT INIT
                                ; HD6402 MIT 9600,8,N,1 PINBELEGUNG:
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
                                ; CTC 3 ALS TIMER IM INTERRUPT-MODE
                                ; 
  0042    21 0080                       LD HL,0080H
  0045    22 8004                       LD (STEPC),HL   ; BUFFER COUNTER
  0048    22 8006                       LD (STEPCI),HL  ; INT. COUNTER
  004B    21 9FF0                       LD HL,IADR
  004E    7D                    ICTC0:  LD A,L
  004F    E6 07                         AND 07H
  0051    28 03                         JR Z,ICTC1      ; -> CTC0
  0053    23                            INC HL
  0054    18 F8                         JR ICTC0
                                        ;-----------
  0056    7C                    ICTC1:  LD A,H
  0057    ED 47                         LD I,A
  0059    3E 87                         LD A,BAUD3
  005B    D3 13                         OUT (CTC3),A
  005D    3E 50                         LD A,TIME3
        MACRO-80 3.43   27-Jul-81       PAGE    1-3


  005F    D3 13                         OUT (CTC3),A
  0061    7D                            LD A,L
  0062    D3 10                         OUT (CTC0),A
  0064    23                            INC HL
  0065    23                            INC HL  ;CTC1
  0066    23                            INC HL
  0067    23                            INC HL  ;CTC2
  0068    23                            INC HL
  0069    23                            INC HL  ;CTC3
  006A    11 020C                       LD DE,TIMEI
  006D    73                            LD (HL),E
  006E    23                            INC HL
  006F    72                            LD (HL),D
                                ;--------------------------
                                ;  START:
                                
  0070    3E 00                         LD A,00H
  0072    D3 04                         OUT (LATCH),A   ; MOTOR 
  0074    32 8008                       LD (RLATCH),A   ; SPEICHEN
  0077    D3 1C                         OUT (PIOA),A    ; SCHIEBER -VDD OFF
  0079    DB 1E                         IN A,(PIOB)
  007B    CB EF                         SET 5,A         ; D=1 -> Q=1 MOTOR ON
  007D    C6 80                         ADD A,80H
  007F    D3 1E                         OUT (PIOB),A    ; SET D 74LS74(2)
  0081    D3 08                         OUT (SMOT),A    ; STARTIMPULS 74LS74(3)
                                        ;-----
  0083    21 00FF               LOP10:  LD HL,00FFH
  0086    22 8002                       LD (WEGS),HL
  0089    21 010F                       LD HL,010FH
  008C    22 8004                       LD (STEPC),HL   ; COUNTER BUFFER
  008F    22 8006                       LD (STEPCI),HL  ; INT. COUNTER
  0092    DB 1E                 LOP11:  IN A,(PIOB)
  0094    CB 57                         BIT 2,A         ; NUSSKNACKER MOTOR AN 74LS74(5) 
                                ;       JR Z,LOP20      ; =LOW MOTOR AUS
  0096    CD 0130                       CALL TIMEC
  0099    30 F7                         JR NC,LOP11
  009B    DB 1E                         IN A,(PIOB)
  009D    CB AF                         RES 5,A
                                ;       BIT 3,A         ; ENDSCHALTER AUSWURF SCHIEBER
  009F    D3 1E                         OUT (PIOB),A
  00A1    D3 08                         OUT (SMOT),A    ; STARTIMPULS 74LS74(3)
  00A3    21 0080                       LD HL,0080H
  00A6    22 8002                       LD (WEGS),HL
  00A9    21 00FF                       LD HL,00FFH
  00AC    22 8004                       LD (STEPC),HL   ; BUFFER COUNTER
  00AF    22 8006                       LD (STEPCI),HL  ; INT. COUNTER
  00B2    CD 015B               LOP12:  CALL STEPMR
  00B5    2A 8002                       LD HL,(WEGS)
  00B8    CD 0153                       CALL DECHL
  00BB    30 F5                         JR NC,LOP12
  00BD    3E 00                         LD A,00H
  00BF    D3 04                         OUT (LATCH),A   ; MOTOR 
  00C1    32 8008                       LD (RLATCH),A   ; SPEICHEN
  00C4    D3 1C                         OUT (PIOA),A    ; SCHIEBER -VDD OFF
  00C6    D3 1E                         OUT (PIOB),A    ; SUMMER OFF/ON
  00C8    21 00FF               LOP14:  LD HL,00FFH
        MACRO-80 3.43   27-Jul-81       PAGE    1-4


  00CB    22 8006                       LD (STEPCI),HL
  00CE    22 8004                       LD (STEPC),HL
  00D1    2A 8006               LOP13:  LD HL,(STEPCI)  ; INT. COUNTER =0
  00D4    CD 0153                       CALL DECHL
  00D7    D3 08                         OUT (SMOT),A    ; STARTIMPULS 74LS74(3)
  00D9    20 F6                         JR NZ,LOP13
  00DB    DB 1E                         IN A,(PIOB)
  00DD    C6 80                         ADD A,80H
  00DF    D3 1E                         OUT (PIOB),A
  00E1    3A 8008                       LD A,(RLATCH)
  00E4    3C                            INC A
  00E5    32 8008                       LD (RLATCH),A
  00E8    CB 07                         RLC A
  00EA    CB 07                         RLC A
  00EC    D3 04                         OUT (LATCH),A
  00EE    20 D8                         JR NZ,LOP14
  00F0    F3                            DI
  00F1    76                            HALT    
                                        ;-----
  00F2    DB 1E                 LOP20:  IN A,(PIOB)
  00F4    CB BF                         RES 7,A
  00F6    D3 1E                         OUT (PIOB),A    ; SUMMER OFF    
  00F8    DB 1C                         IN A,(PIOA)
  00FA    E6 F0                         AND 0F0H
  00FC    CB 58                         BIT 3,B         ; ENDSCHALTER AUSWURF SCHIEBER
  00FE    CC 01BD                       CALL Z,STEP96
                                
  0101    3A 8008               LOP3:   LD A,(RLATCH)
  0104    D3 04                         OUT (LATCH),A   ; MOTOR 
  0106    3C                            INC A
  0107    32 8008                       LD (RLATCH),A
  010A    3A 8000                       LD A,(RAM)
                                ;       JR NZ,LOP3 
  010D    E6 0F                         AND 0FH
                                ;       OUT (PIOA),A
  010F    3C                            INC A
  0110    32 8000                       LD (RAM),A
  0113    CD 01C9                       CALL STEPML
  0116    18 E9                         JR LOP3
                                
  0118    3E 00                         LD A,00H        ; OUTPUT 74LS273 STOPP
  011A    D3 04                 LOP2:   OUT (LATCH),A   ; MOTOR 
  011C    32 8000                       LD (RAM),A
                                ;       AND 0FH
                                ;       OUT (PIOA),A    ; ZUM TEST
  011F    3A 800A                       LD A,(RAM+10)
  0122    3C                            INC A
  0123    D3 1C                         OUT (PIOA),A
  0125    32 800A                       LD (RAM+10),A
  0128    3E 4F                         LD A,4FH
                                ;       OUT (WDTCR),A
  012A    3A 8000                       LD A,(RAM)
  012D    3C                            INC A
                                ;       JR NZ,LOP2
  012E    18 EA                         JR LOP2
                                ;------------------------
        MACRO-80 3.43   27-Jul-81       PAGE    1-5


                                ; TIMER COUNTER (WEGS) 16BIT -1
                                ;
  0130    F3                    TIMEC:  DI              ; UM NICHT UNTERBROCHEN ZU WERDEN
  0131    D5                            PUSH DE
  0132    E5                            PUSH HL
  0133    2A 8006                       LD HL,(STEPCI)  ; PER INT DOWN COUNTER
  0136    CD 0153                       CALL DECHL
  0139    30 14                         JR NC,TIMEC1
  013B    2A 8004                       LD HL,(STEPC)
  013E    22 8006                       LD (STEPCI),HL
  0141    2A 8002                       LD HL,(WEGS)
  0144    CD 0153                       CALL DECHL
  0147    38 06                         JR C,TIMEC1
  0149    20 01                         JR NZ,TIMEC2
  014B    37                            SCF             ; SET CARRY-FLAG
  014C    22 8002               TIMEC2: LD (WEGS),HL
  014F    E1                    TIMEC1: POP HL
  0150    D1                            POP DE
  0151    FB                            EI
  0152    C9                            RET
                                        ;------------
  0153    D5                    DECHL:  PUSH DE
  0154    11 0001                       LD DE,0001H
  0157    ED 52                         SBC HL,DE
  0159    D1                            POP DE
  015A    C9                            RET
                                
                                ;------------------------
                                ; NUSSKNACHER MOTOR OEFFNEN
                                ; SET D7 AN 74LS373(2) WENDERELAIS =0
                                ; FUER OEFFNEN
                                
  015B                          KMOT0:  
                                
                                
                                ;------------------------
                                ; 4 Phasen Steppermotor rechts/zurueck
                                ; TAKT AN PIOA PA3-PA0
                                ; -> 5,9,A,6,5,usw.....
                                ;
  015B    F5                    STEPMR: PUSH AF
  015C    C5                            PUSH BC
  015D    E5                            PUSH HL
                                        ; ENDSCHALTER ABFRAGE
  015E    DB 1E                         IN A,(PIOB)
  0160    47                            LD B,A
  0161    CB 57                         BIT 2,A         ; NUSSKNACKER MOTOR AN 74LS74(5) 
                                ;       JR Z,STEP97     ; =LOW MOTOR AUS
  0163    DB 1C                         IN A,(PIOA)
  0165    E6 F0                         AND 0F0H
  0167    CB 58                         BIT 3,B         ; ENDSCHALTER AUSWURF SCHIEBER
  0169    28 52                         JR Z,STEP96
                                        ; COUNTER ABFRAGEN
  016B    2A 8006                       LD HL,(STEPCI)
  016E    CD 0153                       CALL DECHL
  0171    30 46                         JR NC,STEP97
        MACRO-80 3.43   27-Jul-81       PAGE    1-6


                                        ;---------
  0173    2A 8002                       LD HL,(WEGS)
  0176    CD 0153                       CALL DECHL
  0179    38 03                         JR C,FLIP70
  017B    22 8002                       LD (WEGS),HL
  017E    DB 1C                 FLIP70: IN A,(PIOA)
  0180    E6 F0                         AND 0F0H
  0182    47                            LD B,A
  0183    DB 1C                         IN A,(PIOA)
  0185    E6 0F                         AND 0FH         ; PA0-PA3
  0187    FE 05                         CP 05H
  0189    28 10                         JR Z,FLIP741
  018B    FE 06                         CP 06H
  018D    28 18                         JR Z,FLIP742
  018F    FE 09                         CP 09H
  0191    28 10                         JR Z,FLIP743
  0193    FE 0A                         CP 0AH
  0195    28 08                         JR Z,FLIP744
  0197    3E 05                         LD A,05H
  0199    18 0E                         JR STEP99
                                        ;----------     
  019B                          FLIP741:
  019B    C6 04                         ADD A,04H       ; 05+04=09
  019D    18 0A                         JR STEP99
  019F                          FLIP744:
  019F    D6 04                         SUB 04H         ; 0A-04=06
  01A1    18 06                         JR STEP99
  01A3                          FLIP743:
  01A3    C6 01                         ADD A,01H       ; 09+01=0A
  01A5    18 02                         JR STEP99
  01A7                          FLIP742:
  01A7    D6 01                         SUB 01H         ; 06-01=05
  01A9    4F                    STEP99: LD C,A
  01AA    21 003C                       LD HL,03CH      ; 1ms*HL 
  01AD    22 8006                       LD (STEPCI),HL
  01B0    22 8004                       LD (STEPC),HL
  01B3    79                            LD A,C
  01B4    B0                            OR B            ; PIOA PA4 - 7
  01B5    D3 1C                 STEP98: OUT (PIOA),A
  01B7    DB 1E                         IN A,(PIOB)
  01B9    E1                    STEP97: POP HL
  01BA    C1                            POP BC
  01BB    F1                            POP AF  
  01BC    C9                            RET
                                ;---------------
                                ; ENDSCHALTER ERREICHT
                                ;
  01BD    3E 00                 STEP96: LD A,00H
  01BF    32 8002                       LD (WEGS),A
  01C2    3A 001C                       LD A,(PIOA)
  01C5    E6 F0                         AND 0F0H
  01C7    18 EC                         JR STEP98
                                
                                ;------------------------
                                ; 4 Phasen Steppermotor links/Auswurf
                                ; TAKT AN PIOA PA3-PA0
        MACRO-80 3.43   27-Jul-81       PAGE    1-7


                                ; -> 5,6,A,9,5,usw.....
  01C9    F5                    STEPML: PUSH AF
  01CA    C5                            PUSH BC
  01CB    E5                            PUSH HL
                                        ; COUNTER ABFRAGEN
  01CC    2A 8006                       LD HL,(STEPCI)
  01CF    CD 0153                       CALL DECHL
  01D2    30 E5                         JR NC,STEP97
                                        ;---------
  01D4    2A 8002                       LD HL,(WEGS)
  01D7    CD 0153                       CALL DECHL
  01DA    38 03                         JR C,FLOP70
  01DC    22 8002                       LD (WEGS),HL
  01DF    DB 1C                 FLOP70: IN A,(PIOA)
  01E1    E6 F0                         AND 0F0H
  01E3    47                            LD B,A
  01E4    DB 1C                         IN A,(PIOA)
  01E6    E6 0F                         AND 0FH         ; PA0-PA3
  01E8    FE 05                         CP 05H
  01EA    28 10                         JR Z,FLOP741
  01EC    FE 06                         CP 06H
  01EE    28 18                         JR Z,FLOP742
  01F0    FE 09                         CP 09H
  01F2    28 10                         JR Z,FLOP743
  01F4    FE 0A                         CP 0AH
  01F6    28 08                         JR Z,FLOP744
  01F8    3E 05                         LD A,05H
  01FA    18 AD                         JR STEP99
                                        ;----------     
  01FC                          FLOP741:
  01FC    C6 01                         ADD A,01H       ; 05+01=06
  01FE    18 A9                         JR STEP99
  0200                          FLOP744:
  0200    D6 01                         SUB 01H         ; 0A-01=09
  0202    18 A5                         JR STEP99
  0204                          FLOP743:
  0204    D6 04                         SUB 04H         ; 09-04=05
  0206    18 A1                         JR STEP99
  0208                          FLOP742:
  0208    C6 04                         ADD A,04H       ; 06+04=0A
  020A    18 9D                         JR STEP99
                                
                                ;-----------------------
                                ; INTERRUPT ROUTINE  RETI
                                ; Timer in Millisec.
                                ;
  020C    F5                    TIMEI:  PUSH AF
  020D    E5                            PUSH HL
  020E    2A 8006                       LD HL,(STEPCI)
  0211    CD 0153                       CALL DECHL
  0214    38 03                         JR C,TIME01
  0216    22 8006                       LD (STEPCI),HL
  0219    E1                    TIME01: POP HL
  021A    F1                            POP AF
  021B    FB                            EI
  021C    ED 4D                         RETI
        MACRO-80 3.43   27-Jul-81       PAGE    1-8


                                
                                ;------------------------
                                END
        MACRO-80 3.43   27-Jul-81       PAGE    S


Macros:

Symbols:
0007    BAUD0           0047    BAUD1           0047    BAUD2           
0087    BAUD3           0010    CTC0            0011    CTC1            
0012    CTC2            0013    CTC3            00F4    DCI             
0153    DECHL           017E    FLIP70          019B    FLIP741         
01A7    FLIP742         01A3    FLIP743         019F    FLIP744         
01DF    FLOP70          01FC    FLOP741         0208    FLOP742         
0204    FLOP743         0200    FLOP744         9FF0    IADR            
004E    ICTC0           0056    ICTC1           0000    KANAL0          
0001    KANAL1          0003    KANAL3          0004    KANAL4          
0005    KANAL5          015B    KMOT0           0004    LATCH           
0083    LOP10           0092    LOP11           00B2    LOP12           
00D1    LOP13           00C8    LOP14           011A    LOP2            
00F2    LOP20           0101    LOP3            0080    MSTIME          
001C    PIOA            001E    PIOB            8000    RAM             
0000    REG1            00C1    REG3            0044    REG4            
00EA    REG5            8008    RLATCH          00EF    SCDP            
00EE    SCRP            0018    SIOA            001A    SIOB            
0018    SIORES          0008    SMOT            8000    STATUS          
01BD    STEP96          01B9    STEP97          01B5    STEP98          
01A9    STEP99          8004    STEPC           8006    STEPCI          
01C9    STEPML          015B    STEPMR          0004    TIME0           
0219    TIME01          0004    TIME1           0004    TIME2           
0050    TIME3           0130    TIMEC           014F    TIMEC1          
014C    TIMEC2          020C    TI
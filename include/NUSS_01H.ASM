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
  8006                          RLATCH  EQU STEPC+2     ; WERT FUER 74LS273 LATCH 
                                
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
  001A    3E 07                         LD A,07H
        MACRO-80 3.43   27-Jul-81       PAGE    1-2


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
        MACRO-80 3.43   27-Jul-81       PAGE    1-3


  005E    D3 10                         OUT (CTC0),A
  0060    23                            INC HL
  0061    23                            INC HL  ;CTC1
  0062    23                            INC HL
  0063    23                            INC HL  ;CTC2
  0064    23                            INC HL
  0065    23                            INC HL  ;CTC3
  0066    11 01D8                       LD DE,TIMEI
  0069    73                            LD (HL),E
  006A    23                            INC HL
  006B    72                            LD (HL),D
                                ;--------------------------
                                ;  START:
                                
  006C    3E 00                         LD A,00H
  006E    D3 04                         OUT (LATCH),A   ; MOTOR 
  0070    32 8006                       LD (RLATCH),A   ; SPEICHEN
  0073    D3 1C                         OUT (PIOA),A    ; SCHIEBER -VDD OFF
  0075    DB 1E                         IN A,(PIOB)
  0077    CB EF                         SET 5,A         ; D=1 -> Q=1 MOTOR ON
  0079    C6 80                         ADD A,80H
  007B    D3 1E                         OUT (PIOB),A    ; SET D 74LS74(2)
  007D    D3 08                         OUT (SMOT),A    ; STARTIMPULS 74LS74(3)
                                        ;-----
  007F    3E C0                 LOP10:  LD A,0C0H
  0081    32 8002                       LD (WEGS),A
  0084    32 8004                       LD (STEPC),A
  0087    DB 1E                 LOP11:  IN A,(PIOB)
  0089    CB 57                         BIT 2,A         ; NUSSKNACKER MOTOR AN 74LS74(5) 
                                ;       JR Z,LOP20      ; =LOW MOTOR AUS
  008B    CD 011A                       CALL TIMEC
  008E    30 F7                         JR NC,LOP11
  0090    DB 1E                         IN A,(PIOB)
  0092    CB AF                         RES 5,A
  0094    CB 5F                         BIT 3,A         ; ENDSCHALTER AUSWURF SCHIEBER
  0096    D3 1E                         OUT (PIOB),A
  0098    D3 08                         OUT (SMOT),A    ; STARTIMPULS 74LS74(3)
  009A    3E 80                         LD A,80H
  009C    32 8002                       LD (WEGS),A
  009F    32 8004                       LD (STEPC),A
  00A2    CD 0133               LOP12:  CALL STEPMR
  00A5    3A 8002                       LD A,(WEGS)
  00A8    FE 00                         CP 0
  00AA    20 F6                         JR NZ,LOP12
  00AC    3E 00                         LD A,00H
  00AE    D3 04                         OUT (LATCH),A   ; MOTOR 
  00B0    32 8006                       LD (RLATCH),A   ; SPEICHEN
  00B3    D3 1C                         OUT (PIOA),A    ; SCHIEBER -VDD OFF
  00B5    D3 1E                         OUT (PIOB),A    ; SUMMER OFF/ON
  00B7    3E FF                 LOP14:  LD A,0FFH
  00B9    32 8004                       LD (STEPC),A
  00BC    3A 8004               LOP13:  LD A,(STEPC)
  00BF    FE 00                         CP 0H
  00C1    D3 08                         OUT (SMOT),A    ; STARTIMPULS 74LS74(3)
  00C3    20 F7                         JR NZ,LOP13
  00C5    DB 1E                         IN A,(PIOB)
        MACRO-80 3.43   27-Jul-81       PAGE    1-4


  00C7    C6 80                         ADD A,80H
  00C9    D3 1E                         OUT (PIOB),A
  00CB    3A 8006                       LD A,(RLATCH)
  00CE    3C                            INC A
  00CF    32 8006                       LD (RLATCH),A
  00D2    CB 07                         RLC A
  00D4    CB 07                         RLC A
  00D6    D3 04                         OUT (LATCH),A
  00D8    20 DD                         JR NZ,LOP14
  00DA    F3                            DI
  00DB    76                            HALT    
                                        ;-----
  00DC    DB 1E                 LOP20:  IN A,(PIOB)
  00DE    CB BF                         RES 7,A
  00E0    D3 1E                         OUT (PIOB),A    ; SUMMER OFF    
  00E2    DB 1C                         IN A,(PIOA)
  00E4    E6 F0                         AND 0F0H
  00E6    CB 58                         BIT 3,B         ; ENDSCHALTER AUSWURF SCHIEBER
  00E8    CC 018E                       CALL Z,STEP96
                                
  00EB    3A 8006               LOP3:   LD A,(RLATCH)
  00EE    D3 04                         OUT (LATCH),A   ; MOTOR 
  00F0    3C                            INC A
  00F1    32 8006                       LD (RLATCH),A
  00F4    3A 8000                       LD A,(RAM)
                                ;       JR NZ,LOP3 
  00F7    E6 0F                         AND 0FH
                                ;       OUT (PIOA),A
  00F9    3C                            INC A
  00FA    32 8000                       LD (RAM),A
  00FD    CD 019A                       CALL STEPML
  0100    18 E9                         JR LOP3
                                
  0102    3E 00                         LD A,00H        ; OUTPUT 74LS273 STOPP
  0104    D3 04                 LOP2:   OUT (LATCH),A   ; MOTOR 
  0106    32 8000                       LD (RAM),A
                                ;       AND 0FH
                                ;       OUT (PIOA),A    ; ZUM TEST
  0109    3A 800A                       LD A,(RAM+10)
  010C    3C                            INC A
  010D    D3 1C                         OUT (PIOA),A
  010F    32 800A                       LD (RAM+10),A
  0112    3E 4F                         LD A,4FH
                                ;       OUT (WDTCR),A
  0114    3A 8000                       LD A,(RAM)
  0117    3C                            INC A
                                ;       JR NZ,LOP2
  0118    18 EA                         JR LOP2
                                ;------------------------
                                ; TIMER COUNTER (STEPC)
                                ; (WEGS)
  011A    D5                    TIMEC:  PUSH DE
  011B    E5                            PUSH HL
  011C    11 0001                       LD DE,0001H
  011F    2A 8004                       LD HL,(STEPC)
  0122    ED 52                         SBC HL,DE
        MACRO-80 3.43   27-Jul-81       PAGE    1-5


  0124    30 0A                         JR NC,TIMEC1
  0126    2A 8002                       LD HL,(WEGS)
  0129    ED 52                         SBC HL,DE
  012B    38 03                         JR C,TIMEC1
  012D    22 8002                       LD (WEGS),HL
  0130    E1                    TIMEC1: POP HL
  0131    D1                            POP DE
  0132    C9                            RET
                                ;------------------------
                                ; NUSSKNACHER MOTOR OEFFNEN
                                ; SET D7 AN 74LS373(2) WENDERELAIS =0
                                ; FUER OEFFNEN
                                
  0133                          KMOT0:  
                                
                                
                                ;------------------------
                                ; 4 Phasen Steppermotor rechts/zurueck
                                ; TAKT AN PIOA PA3-PA0
                                ; -> 5,9,A,6,5,usw.....
                                ;
  0133    F5                    STEPMR: PUSH AF
  0134    C5                            PUSH BC
  0135    E5                            PUSH HL
                                        ; ENDSCHALTER ABFRAGE
  0136    DB 1E                         IN A,(PIOB)
  0138    47                            LD B,A
  0139    CB 57                         BIT 2,A         ; NUSSKNACKER MOTOR AN 74LS74(5) 
                                ;       JR Z,STEP97     ; =LOW MOTOR AUS
  013B    DB 1C                         IN A,(PIOA)
  013D    E6 F0                         AND 0F0H
  013F    CB 58                         BIT 3,B         ; ENDSCHALTER AUSWURF SCHIEBER
  0141    28 4B                         JR Z,STEP96
                                        ; COUNTER ABFRAGEN
  0143    3A 8004                       LD A,(STEPC)
  0146    FE 00                         CP 0
  0148    20 40                         JR NZ,STEP97
                                        ;---------
  014A    3A 8002                       LD A,(WEGS)
  014D    3D                            DEC A
  014E    38 03                         JR C,FLIP70
  0150    32 8002                       LD (WEGS),A
  0153    DB 1C                 FLIP70: IN A,(PIOA)
  0155    E6 F0                         AND 0F0H
  0157    47                            LD B,A
  0158    DB 1C                         IN A,(PIOA)
  015A    E6 0F                         AND 0FH         ; PA0-PA3
  015C    FE 05                         CP 05H
  015E    28 10                         JR Z,FLIP741
  0160    FE 06                         CP 06H
  0162    28 18                         JR Z,FLIP742
  0164    FE 09                         CP 09H
  0166    28 10                         JR Z,FLIP743
  0168    FE 0A                         CP 0AH
  016A    28 08                         JR Z,FLIP744
  016C    3E 05                         LD A,05H
        MACRO-80 3.43   27-Jul-81       PAGE    1-6


  016E    18 0E                         JR STEP99
                                        ;----------     
  0170                          FLIP741:
  0170    C6 04                         ADD A,04H       ; 05+04=09
  0172    18 0A                         JR STEP99
  0174                          FLIP744:
  0174    D6 04                         SUB 04H         ; 0A-04=06
  0176    18 06                         JR STEP99
  0178                          FLIP743:
  0178    C6 01                         ADD A,01H       ; 09+01=0A
  017A    18 02                         JR STEP99
  017C                          FLIP742:
  017C    D6 01                         SUB 01H         ; 06-01=05
  017E    4F                    STEP99: LD C,A
  017F    3E 3C                         LD A,3CH        ; 1ms*HL 
  0181    32 8004                       LD (STEPC),A
  0184    79                            LD A,C
  0185    B0                            OR B            ; PIOA PA4 - 7
  0186    D3 1C                 STEP98: OUT (PIOA),A
  0188    DB 1E                         IN A,(PIOB)
  018A    E1                    STEP97: POP HL
  018B    C1                            POP BC
  018C    F1                            POP AF  
  018D    C9                            RET
                                ;---------------
                                ; ENDSCHALTER ERREICHT
                                ;
  018E    3E 00                 STEP96: LD A,00H
  0190    32 8002                       LD (WEGS),A
  0193    3A 001C                       LD A,(PIOA)
  0196    E6 F0                         AND 0F0H
  0198    18 EC                         JR STEP98
                                
                                ;------------------------
                                ; 4 Phasen Steppermotor links/Auswurf
                                ; TAKT AN PIOA PA3-PA0
                                ; -> 5,6,A,9,5,usw.....
  019A    F5                    STEPML: PUSH AF
  019B    C5                            PUSH BC
  019C    E5                            PUSH HL
                                        ; COUNTER ABFRAGEN
  019D    3A 8004                       LD A,(STEPC)
  01A0    FE 00                         CP 0
  01A2    20 E6                         JR NZ,STEP97
                                        ;---------
  01A4    3A 8002                       LD A,(WEGS)
  01A7    3C                            INC A
  01A8    32 8002                       LD (WEGS),A
  01AB    DB 1C                         IN A,(PIOA)
  01AD    E6 F0                         AND 0F0H
  01AF    47                            LD B,A
  01B0    DB 1C                         IN A,(PIOA)
  01B2    E6 0F                         AND 0FH         ; PA0-PA3
  01B4    FE 05                         CP 05H
  01B6    28 10                         JR Z,FLOP741
  01B8    FE 06                         CP 06H
        MACRO-80 3.43   27-Jul-81       PAGE    1-7


  01BA    28 18                         JR Z,FLOP742
  01BC    FE 09                         CP 09H
  01BE    28 10                         JR Z,FLOP743
  01C0    FE 0A                         CP 0AH
  01C2    28 08                         JR Z,FLOP744
  01C4    3E 05                         LD A,05H
  01C6    18 B6                         JR STEP99
                                        ;----------     
  01C8                          FLOP741:
  01C8    C6 01                         ADD A,01H       ; 05+01=06
  01CA    18 B2                         JR STEP99
  01CC                          FLOP744:
  01CC    D6 01                         SUB 01H         ; 0A-01=09
  01CE    18 AE                         JR STEP99
  01D0                          FLOP743:
  01D0    D6 04                         SUB 04H         ; 09-04=05
  01D2    18 AA                         JR STEP99
  01D4                          FLOP742:
  01D4    C6 04                         ADD A,04H       ; 06+04=0A
  01D6    18 A6                         JR STEP99
                                
                                ;-----------------------
                                ; INTERRUPT ROUTINE  RETI
                                ; Timer in Millisec.
                                ;
  01D8    F5                    TIMEI:  PUSH AF
  01D9    D5                            PUSH DE
  01DA    E5                            PUSH HL
  01DB    11 0001                       LD DE,0001H
  01DE    2A 8004                       LD HL,(STEPC)
  01E1    ED 52                         SBC HL,DE
  01E3    38 03                         JR C,TIME01
  01E5    22 8004                       LD (STEPC),HL
  01E8    E1                    TIME01: POP HL
  01E9    D1                            POP DE
  01EA    F1                            POP AF
  01EB    FB                            EI
  01EC    ED 4D                         RETI
                                
                                ;------------------------
                                END
        MACRO-80 3.43   27-Jul-81       PAGE    S


Macros:

Symbols:
0007    BAUD0           0047    BAUD1           0047    BAUD2           
0087    BAUD3           0010    CTC0            0011    CTC1            
0012    CTC2            0013    CTC3            00F4    DCI             
0153    FLIP70          0170    FLIP741         017C    FLIP742         
0178    FLIP743         0174    FLIP744         01C8    FLOP741         
01D4    FLOP742         01D0    FLOP743         01CC    FLOP744         
9FF0    IADR            004A    ICTC0           0052    ICTC1           
0000    KANAL0          0001    KANAL1          0003    KANAL3          
0004    KANAL4          0005    KANAL5          0133    KMOT0           
0004    LATCH           007F    LOP10           0087    LOP11           
00A2    LOP12           00BC    LOP13           00B7    LOP14           
0104    LOP2            00DC    LOP20           00EB    LOP3            
0080    MSTIME          001C    PIOA            001E    PIOB            
8000    RAM             0000    REG1            00C1    REG3            
0044    REG4            00EA    REG5            8006    RLATCH          
00EF    SCDP            00EE    SCRP            0018    SIOA            
001A    SIOB            0018    SIORES          0008    SMOT            
8000    STATUS          018E    STEP96          018A    STEP97          
0186    STEP98          017E    STEP99          8004    STEPC           
019A    STEPML          0133    STEPMR          0004    TIME0           
01E8    TIME01          0004    TIME1           0004    TIME2           
0050    TIME3           011A    TIMEC           0130    TIMEC1          
01D8    TIMEI           00F1    WDTCR           00F0    WDTMR           
8002    WEGS            



No Fatal error(s)


                                                                                                                                                                                                                                                    
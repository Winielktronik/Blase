        MACRO-80 3.43   27-Jul-81       PAGE    1


                                ;
                                ;   BLASE.MAC
                                ;   Vers. 1.0   01.12.2007
                                ;         1.1   27.12.2017 BIOS ANGEPASST NEU AUFGESETZT
                                ;-------------------------
                                ; Winterhalter CPU-System Neu
                                ; Entwicklungssystem  (c)
                                ;-------------------------
                                ;  ab USER=0 -> zu Eingabetext nach Blase suchen 
                                ;  Aus Bildschirm Blase TYPE1=0, TYPE2=0 als Maskedarstellung
                                ;  TYPE1, TYPE2 > 0 fuer Daten
                                ;-----------------------------------------------
  0000'                         ASEG
                                
                                .Z80
                                
                                
                                ORG 100H
                                
  0001                          DISPLAY EQU 1           ; 1=MIT DISPAY
                                
                         C      INCLUDE BLASEINI.MAC
                         C      ; BLASEINI.MAC
                         C      ; VERS. 1.0     05.04.2018
                         C      ;----------
                         C      ;  initialization vectoren
                         C      ;----------
                         C      
  6000                   C      RAM     EQU 6000H       ; A HIER FREIE RAMBEREICH
                         C      
  6200                   C      BLAN    EQU RAM+200H    ; L[NGR DER DARSTELLUNG
  7000                   C      PROG    EQU RAM+1000H   ; Programm auf Adresse uebertragen
                         C      ;------------------------
                         C      ; IN BLASE ENTHALTEN
                         C      
  6201                   C      USER    EQU BLAN+1      ; Benutzer Blasenspeicher festlegen 
  6202                   C      TYPE1   EQU USER+1      ; Anwendung
  6203                   C      TYPE2   EQU TYPE1+1     ; Anwendung
  6204                   C      TERM    EQU TYPE2+1     ; Gedaechtniszaehler    
  6205                   C      BSTAT   EQU TERM+1      ; Blasenstatus BYTE
                         C              ; Bit: 7 Gedaechtnisszaehler +/-
                         C              ; Bit: 6 Sortieren Stop/Start
                         C              ; Bit: 5
                         C              ;-------------------
  6500                   C      BFRLL   EQU RAM+500H    ; Aktuelle Blasen Adresse speichern
  6501                   C      BFRLH   EQU BFRLL+1
  6502                   C      BFRHL   EQU BFRLH+1
  6503                   C      BFRHH   EQU BFRHL+1
  6508                   C      BFVLL   EQU BFRHH+5     ; Aktuelle Blasen Adresse zum Vergleichen
  6509                   C      BFVLH   EQU BFVLL+1
  650A                   C      BFVHL   EQU BFVLH+1
  650B                   C      BFVHH   EQU BFVHL+1
  650C                   C      BFSLL   EQU BFVHH+1     ; Aktuelle Blasen Adresse zum Sortieren
  650D                   C      BFSLH   EQU BFSLL+1
  650E                   C      BFSHL   EQU BFSLH+1
  650F                   C      BFSHH   EQU BFSHL+1
        MACRO-80 3.43   27-Jul-81       PAGE    1-1


  6510                   C      LOGLL   EQU BFSHH+1
  6511                   C      LOGLH   EQU LOGLL+1
  6512                   C      LOGHL   EQU LOGLH+1
  6513                   C      LOGHH   EQU LOGHL+1
  6518                   C      CURS    EQU LOGHH+5     ; Aktuelle Cursor position
  651C                   C      CURT    EQU CURS+4      ; Cursor in Task (UHR)
  6520                   C      SANDB   EQU CURT+4
  6524                   C      RADR    EQU SANDB+4     ; Aktuelle ausgabe Adresstabelle 16Bit
  6526                   C      RMEN    EQU RADR+2      ; 8Bit
  6527                   C      RAMV    EQU RMEN+1      
  6727                   C      RAMS    EQU RAMV+200H   
  6B27                   C      RAMT    EQU RAMS+400H
  6BEF                   C      RTEX    EQU RAMT+200D
  6C3F                   C      COP     EQU RTEX+80D
                         C      
  0800                   C      HDD     EQU 0800H       ; Startadresse HDD
  00BE                   C      HDDE    EQU 00BEH       ; = 19,9...GB 16363CYL, 16HDS, 63SEC, LBA 39102336
  A101                   C      MMC     EQU 0A101H      ; Startadresse nach LW A:
  0007                   C      MMCE    EQU 07H         ; Ende 256MB Karte
                         C      ;-----------------------
                         C      ;   OFFSET BLASENEINTEILUNGS
                         C      
  0000                   C      RBLAN   EQU 00H         ; Length of the presentation
  0001                   C      RUSER   EQU RBLAN+1     ; Transfer program to address 
  0002                   C      RTYPE1  EQU RUSER+1     ; application User
  0003                   C      RTYPE2  EQU RTYPE1+1    ; application type
  0004                   C      RTERM   EQU RTYPE2+1    ; memory counter
  0005                   C      RBSTAT  EQU RTERM+1     ; Bubble Status Byte
  0006                   C      RSOTR   EQU RBSTAT+1    ; Buffer while searching        
                         C      ;------------------------
                         C      
  0004                   C      SELDM   EQU 04H         ; 0A4H MASTER LAUFWERK E: ZUM PROGRAMME LADEN 
  00F7                   C      SELDS   EQU 0F7H        ; 0F7H SLAVE LAUFWERK H:
  005C                   C      FCB     EQU 005CH       ; FCB address
  0080                   C      BUFF    EQU 0080H       ; input buffer
                         C      ;
  005D                   C      FCBFN   EQU FCB+1       ; file name
  0065                   C      FCBFT   EQU FCB+9       ; file type
  006B                   C      FCBCR   EQU FCB+15      ; record-number
  007C                   C      FCBRA   EQU 7CH         ; insertion counter
                         C      
  00F0                   C      IDE     EQU 0F0H        ; hard disk enable address
  00F6                   C      IDEDOR  EQU IDE+6       ; DIGITAL OUT REGISTER
  00F8                   C      IDEDAT  EQU IDE+8
  00F9                   C      IDEERR  EQU IDE+9
  00FA                   C      IDESCNT EQU IDE+0AH     ; SECTOR COUNTER
  00FB                   C      IDESNUM EQU IDE+0BH     ; SECTOR NUMBER
  00FC                   C      IDECLO  EQU IDE+0CH     ; CYLINDER LOW
  00FD                   C      IDECHI  EQU IDE+0DH     ; CYLINDER HIGH
  00FE                   C      IDESDH  EQU IDE+0EH     ; DRIVE UND HEAD
  00FF                   C      IDECMD  EQU IDE+0FH     ; /WR COMMAND
  00FF                   C      IDESTAT EQU IDECMD      ; /RD STATUS
                         C      
  0020                   C      CMD_READSEC     EQU 20H
  0030                   C      CMD_WRITESEC    EQU 30H
                         C      
        MACRO-80 3.43   27-Jul-81       PAGE    1-2


                         C      ;-----------------
                         C      ; Call subprogram in bubble
                         C      ; 0,1,2,3,4,.......
                         C      ;
  0001                   C      KEYOUT  EQU 01H         ; KEYS INQUERY
  0002                   C      KEYIN   EQU 02H         ; READ OUTPUT CHARACTER
                         C      ;
  0005                   C      P_READ  EQU 05H         ; HDD READ
  0006                   C      P_WRITE EQU 06H         ; HDD WRITE
  0007                   C      CPOS    EQU 07H         ; POSITION THE CURSOR
  0008                   C      LPOS    EQU 08H         ; POSITION BC
                         C      ; ENDE DEFINE
                                ;-----------------
                         C      INCLUDE BIOSSEL.MAC
                         C      ;--------------------------
                         C      ; BIOS Hardware CS Adresse
                         C      ;
  0018                   C      SIOA    EQU 18H         ; SIO A 84C43
  001A                   C      SIOB    EQU 1AH         ; SIO B 84C43
  0010                   C      CTC     EQU 10H         ; CTC BAUDRATE 84C30A
  001C                   C      PIOA    EQU 1CH         ; PIOA 84C20A
  001E                   C      PIOB    EQU 1EH         ; PIOB 84C20A
  00F0                   C      WDTCR   EQU 0F0H        ; WATCH DOG TIMER
  00F1                   C      WDTER   EQU 0F1H
  00F4                   C      DCI     EQU 0F4H        ; DAISY-CAINE-INTRRUPT
                         C      
  00F5                   C      LATCH   EQU 0F5H        ; I/O ADDRESS LATCH FOR A8-A15 EXTERN BUS
  0020                   C      SDC     EQU 20H         ; MMC KATE
  0060                   C      LCD     EQU 60H         ; LCD-DISPAY
  0080                   C      URCS    EQU 80H         ; MIT 2K SRAM A0-A4 PIOA A5-A7
                         C      
  0040                   C      EOFF    EQU 40H         ; EPROM AUS RAM <32K AKTIV
  0021                   C      RAMH    EQU 21H         ; BIT1,5 PIOA BANK1
  0000                   C      RAML    EQU 00H         ; BIT1,5 PIOA BANK0
                                ;---------------
  F814                          READ    EQU 0F814H
  F817                          WRITE   EQU 0F817H
  F82F                          SETDMA  EQU 0F82FH
  F832                          SETTRK  EQU 0F832H
  F835                          SETSEC  EQU 0F835H
  F838                          SELDSK  EQU 0F838H
                                
  FFA2                          TASKSP  EQU 0FFA2H
  FFA4                          TRACKL  EQU TASKSP+2
  FFA5                          TRACKH  EQU TRACKL+1
  FFAB                          TRACK   EQU TRACKH+6
                                
                                        ;---------------------
                                        ;  CTC-COMMANDOS
                                        ;---------------------
                                
  0047                          BAUD1   EQU 47H         ;9600
  0004                          TIME1   EQU 04H         ; TIME CONSTANTE
                                
  0047                          BAUD2   EQU 47H         ; TGOT 1:2
  0004                          TIME2   EQU 04H         ;
        MACRO-80 3.43   27-Jul-81       PAGE    1-3


                                
  0047                          BAUD3   EQU 47H         ; TGOT 1:2
  0004                          TIME3   EQU 04H         ;
                                
                                        ;--------------------
                                        ;  SIO-COMMANDOS
                                        ;--------------------
                                
  0018                          SIORES  EQU 18H         ; SIO RESET
  0004                          KANAL4  EQU 04H         ; REG 4
  0044                          REG4    EQU 44H         ; X16 CLOCK,8,SYNC
  0003                          KANAL3  EQU 03H         ; REG 3
  00C1                          REG3    EQU 0C1H        ; 8BIT. RXENABLE
  0005                          KANAL5  EQU 05H         ; REG 5
  00EA                          REG5    EQU 0EAH        ; DTR,TX8BIT,TXENAL
  0001                          KANAL1  EQU 01H         ; REG 1
  0000                          REG1    EQU 00H         ; NO INT
  0000                          KANAL0  EQU 00H         ; REG 0
                                
                                        ;------------------
                                        ;  LCD INIT
                                        ;------------------
                                
  0005                          FSET    EQU 05H         ; FUNKTION SET
  000C                          DCON    EQU 0CH         ; DISPLAY CONTROL
  0001                          DCLR    EQU 01H         ; DISPLAY CLEAR
  0002                          DHOM    EQU 02H         ; DISPLAY HOME
                                
                                ;----------------
                                ;     START
                                ;----------------
                                ; PROGRAMM HOCHLADEN
                                
  0100    3E 00                 LOS:    LD A,00H        ; WAIT STATE CONTROL REGISTER SELECT
  0102    D3 EE                         OUT (0EEH),A
  0104    3E 01                         LD A,01H        ; WAIT STATE CONTROL REGISTER SET
  0106    D3 EF                         OUT (0EFH),A
  0108    31 5FFE                       LD SP,RAM-2
  010B    F3                            DI
  010C    3E 00                         LD A,00H        ; INTERRUPT PRIORITY REGISTER CTC-SIO-PIO
  010E    D3 F4                         OUT (DCI),A     ; INTERRUPT PRIORITY REGISTER
                                        ;----------------
                                        ; PROGRAMM AN ZIEHLEDRESSE "PROG" LADEN
  0110    21 0130                       LD HL,PRO       ; Programm Quelle+1 ab RUN:
  0113    11 7000                       LD DE,PROG      ; Programm Ziel
  0116    01 3000                       LD BC,3000H     ; RAM Laenge
  0119    ED B0                         LDIR                    ; Programm uebertragen
                                        ;------------
                                        ; KEY BUFFER EMPTY
  011B    21 6B27                       LD HL,RAMT
  011E    06 C8                         LD B,200D
  0120    3E 00                 LOS1:   LD A,00H
  0122    77                            LD (HL),A
  0123    23                            INC HL
  0124    10 FA                         DJNZ LOS1
                                ;------------
        MACRO-80 3.43   27-Jul-81       PAGE    1-4


                                ; DRIVE NEU SET MASTER/SLAVE
                                ;
  0126    3A FD1A                       LD A,(0FD1AH)
  0129    FE A5                         CP 0A5H
  012B    3E F5                         LD A,0F5H
                                        ;LD (0FD1AH),A
  012D    C3 701B                       JP RUN          ;PROGRAMM Start
                                ;----------------
  0130                          PRO:
                                
                                .PHASE PROG
                                
  7000    C9                    T0:     RET
  7001    00                            NOP
  7002    00                            NOP
  7003    C3 788B               T1:     JP HEXC         ; ZEICHENAUSGEBEN
  7006    C3 79A0               T2:     JP KEYST        ; TASTENABFRABE OHNE SORTIERUNG
  7009    C3 7976               T3:     JP SUCH0        ; Blase mit Eintrag aus RAMT suchen  
  700C    C3 79B4               T4:     JP LBA0         ; Plattenzugriff (DE), (HL) +1
  700F    C3 7DA2               T5:     JP RDREAD       ; lesen einer Blase
  7012    C3 7DCB               T6:     JP RDWRITE      ; Speichern einer Blase
  7015    C3 7854               T7:     JP CUT          ; CURSOR POS SET IN (CURT)0-3
  7018    C3 7A8C               T8:     JP LIST         ; CURSOR POS SET IN BC
                                ;-----------------------
                                ;  LCD 128X128 ANSTEUERN
  701B    DB 1C                 RUN:    IN A,(PIOA)
  701D    CB BF                         RES 7,A         ; INTERN
  701F    D3 1C                         OUT (PIOA),A
                                ;-----------------------
                                ; LCD128X128
                                ; INCLUDE LCD
                                ;
                                ;       CALL LCDINI 
                                ;---------------------
                                ;       LD A,AWRON
                                ;       CALL CMD
                                        ;
                                        ; LCD LOESCHEN, CLEAR
                                        ;
                                ;       PUSH HL
                                ;       LD HL,01A0H
                                ;TXCR:  LD A,20H        ;WRITE DATA 20 =SPACE (00)
                                ;       CALL ADT
                                ;       DEC HL
                                ;       LD A,H
                                ;       OR L
                                ;       JR NZ,TXCR
                                ;       POP HL
                                ;       LD A,AWROFF     ; AUTO RESET
                                ;       CALL CMD
                                        ;
                                        ; WRITE TEXT DISPLAY DATA (INTERNAL CG)
                                        ;
                                ;       LD HL,0000      ; ADDRESS POINTER 0lINE, 0COLUMN
                                ;       CALL DT2
                                ;       LD A,ADPSET
        MACRO-80 3.43   27-Jul-81       PAGE    1-5


                                ;       CALL CMD
                                ;
                                ;       LD A,AWRON      ; SET DATA AUTO WRITE
                                ;       CALL CMD
                                ;
                                ;       LD HL,TEX3
                                ;       LD B,TXL3
                                ;       CALL LCDA       ; TEXT AUSGEBEN
                                ;
                                ;       LD A,AWROFF
                                ;       CALL CMD
                                ;---------------------------------
                                ; Blasenspeicher mit Startadresse vorbereiten
                                
  7021    21 0000               KI:     LD HL,0000H
  7024    22 801B                       LD (BF07+2),HL
  7027    22 6502                       LD (BFRHL),HL           ; AKTUELL TRACK/SECTORADRESSE LADEN
                                        ; SORTIERE IN BFS...
  702A    22 650E                       LD (BFSHL),HL           ; IN BFS ADRESSE ZUM SORZIEREN
  702D    22 6512                       LD (BFSHL+4),HL
  7030    22 6512                       LD (LOGHL),HL
  7033    21 0010                       LD HL,0010H             ; STARTADR. USER-LOGIN AUF HDD
  7036    22 6510                       LD (LOGLL),HL
  7039    21 0800                       LD HL,HDD               ; HD STARTADRESSE
  703C    22 8019                       LD (BF07),HL
  703F    22 6500                       LD (BFRLL),HL           ; AKTUELLE TRACK/SECTORADRESSE LADEN
                                        ;-----------------------
                                        ; SORTIER STARTADRESSE SETZEN 
                                        ; BLASE1 UND BLASE2+4 AUS HDD STARTADRESSE+1
  7042    23                            INC HL          ; 
  7043    22 650C                       LD (BFSLL),HL   ; Sortieranfang
  7046    22 6510                       LD (BFSLL+4),HL ; Sortieranfang
                                
                                        ;------------------
                                        ; Cursor REGISTER auf Z=24, S=1 setzen
  7049    01 2401                       LD BC,2401H
  704C    CD 7A8C                       CALL LIST
                                        ;
                                        ;------------------
                                        ; BF00 beim Neustart auf Null setzen 
                                        ; Suchparameter fuer neue Blase 
                                        ; USER wird nur durch Login veraendert
                                        ; TYPE1, TYPE2 aus Blasendaten 
  704F    AF                            XOR A
  7050    32 7FF1                       LD (BF00),A
  7053    32 7FF2                       LD (BF00+RUSER),A
  7056    32 7FF3                       LD (BF00+RTYPE1),A
  7059    32 7FF4                       LD (BF00+RTYPE2),A
  705C    32 7FF5                       LD (BF00+RTERM),A
                                        ;----------
  705F    C5                            PUSH BC
  7060    D5                            PUSH DE
  7061    E5                            PUSH HL
  7062    21 8030               COL0:   LD HL,COL01             ; BILDSCHIRM FARBE
  7065    06 09                         LD B,09D                ; AUSGABELAENGE
  7067    7E                    COL1:   LD A,(HL)
        MACRO-80 3.43   27-Jul-81       PAGE    1-6


  7068    CD 788B                       CALL HEXC
  706B    23                            INC HL
  706C    10 F9                         DJNZ COL1
  706E    E1                            POP HL
  706F    D1                            POP DE
  7070    C1                            POP BC
                                ;       JR KI1          ;!!STARTSEITE NICHT DA ->
                                        ;---
                                        ; Blase aus BFRxx laden
  7071    AF                    BL:     XOR A
  7072    ED 4B 6500                    LD BC,(BFRLL)   ; Aktuelle HIGH LBA laden
  7076    ED 5B 6502                    LD DE,(BFRHL)   ; Aktuelle LOW LBA laden
  707A    21 6000                       LD HL,RAM       ; DMA
  707D    CD 7DA2                       CALL RDREAD
                                        ;------
                                        ; READ SICHTBAR MACHEN
                                ;!!!    LD BC,0501H
                                ;!!!    CALL LIST
                                ;!!!    LD HL,RAM
                                ;!!!    CALL LIS0
  7080    3A 6000                       LD A,(RAM)
  7083    FE 43                         CP 43H
  7085    CA 7093                       JP Z,KI1
                                        ;-------------------
  7088    21 83BD                       LD HL,SMASKE            ; STARTMASKE LADEN
  708B    11 6000                       LD DE,RAM
  708E    01 0088                       LD BC,SRAL
  7091    ED B0                         LDIR
  7093    3E 0A                 KI1:    LD A,0AH        ; >9
  7095    32 802B                       LD (DAYZ+3),A   ; UHRZEIT LOESCHEN DAMIT GLEICH AUSGEGEBEN WIRD
                                        ;------------
                                        ; Blasenstatus schon mal auf benutzt setzen
                                        ; IN AKTUELLER BLASE RAM
  7098    3A 6005                       LD A,(RAM+RBSTAT)       ; RAM
  709B    CB FF                         SET 7,A         ; GedankenStatus Zaehler 0= minus 1= plus
  709D    CB B7                         RES 6,A         ; Sortieren aktivieren
  709F    32 6005                       LD (RAM+RBSTAT),A       ; AUS AKTUELLER BLASE
                                ; ???
  70A2    3A 6205                       LD A,(BLAN+RBSTAT)      ; RAM+200
  70A5    CB FF                         SET 7,A         ; Gedankenzaehler 0= minus 1= plus
  70A7    CB B7                         RES 6,A         ; Sortieren aktivieren
  70A9    32 6205                       LD (BLAN+RBSTAT),A      ; VORBEREITEN
                                ; ???
                                        ;---------------------------------
                                        ;  gebe die laenge von B auf VT100 Bildschirm aus 
                                        ;
  70AC    21 6000               BL00:   LD HL,RAM       ; BLASE address
  70AF    22 6524                       LD (RADR),HL    ; cache current BLASE address
  70B2    7E                            LD A,(HL)       ; Number of characters from mask
  70B3    32 6526                       LD (RMEN),A     ; caching character length
  70B6    11 6000                       LD DE,RAM
  70B9    ED 52                         SBC HL,DE       ; determine BLASEN start
  70BB    2A 6524                       LD HL,(RADR)    ; load current BLASE address
  70BE    20 09                         JR NZ,BL000     ; no BLASEN start ->
                                        ;-----------------------
                                        ; BLASEN beginning new
        MACRO-80 3.43   27-Jul-81       PAGE    1-7


                                        ; load restart parameter
  70C0    23                            INC HL          ; ->USER
  70C1    23                            INC HL          ; ->TYPE1
  70C2    7E                            LD A,(HL)       ; load type1
  70C3    32 7FF3                       LD (BF00+RTYPE1),A      
  70C6    23                            INC HL          ; ->Type2
  70C7    23                            INC HL          ; ->Gedaechtniszaehler
  70C8    23                            INC HL          ; ->Status Byte
                                        ;----------------
  70C9    3A 6526               BL000:  LD A,(RMEN)     ; load character length
  70CC    47                            LD B,A          ; B= counter
  70CD    AF                            XOR A           ; LOESCHEN
  70CE    B8                            CP B            ; counter > 0
  70CF    CA 757B                       JP Z,EING       ; jump to the input =0 ->
                                        ;--------------------------------
                                        ; SET CURSOR UND Block output 
                                        ;
  70D2    E5                            PUSH HL
  70D3    C5                            PUSH BC
  70D4    01 0101                       LD BC,0101H
  70D7    CD 7A8C                       CALL LIST       ; set cursor
  70DA    C1                            POP BC
  70DB    E1                            POP HL
  70DC    23                    BL01:   INC HL          ; from here graphic/text area
  70DD    7E                            LD A,(HL)       
  70DE    CD 788B                       CALL HEXC       ; output area 
  70E1    10 F9                         DJNZ BL01       ; counter[B
  70E3    22 6524                       LD (RADR),HL    ; cache current BLASE address
                                        ; (HL) KOPFZEILE ENDE
                                        ;---------------------------
                                        ; Issue Blasen parameters USER,TYPE1,TYPE2,
                                        ; memory in % 
                                        ; top right Z=1, S=60
                                        ;
  70E6    E5                            PUSH HL         ; RETTE BLASE
  70E7    D5                            PUSH DE
  70E8    C5                            PUSH BC
  70E9    01 0160                       LD BC,0160H     
  70EC    CD 7A8C                       CALL LIST       ; set cursor
  70EF    C1                            POP BC
  70F0    21 6001                       LD HL,RAM+RUSER         ; USER address from current BLASE
  70F3    C5                            PUSH BC
  70F4    4E                            LD C,(HL)       ; USER load
  70F5    C5                            PUSH BC
  70F6    CD 7817                       CALL HEX14      ; USER / %
  70F9    C1                            POP BC
  70FA    C1                            POP BC
  70FB    2A 6002                       LD HL,(RAM+RTYPE1)      ; TYPE2=L ,TYPE1=H LADEN
                                        ;---------------------
                                        ; output memory count in %
  70FE    3A 6004                       LD A,(RAM+RTERM)        ; memory count load
  7101    5F                            LD E,A  
  7102    3E 00                         LD A,00H
  7104    F5                    EZ03:   PUSH AF
  7105    7B                            LD A,E
  7106    D6 02                         SUB 02H
        MACRO-80 3.43   27-Jul-81       PAGE    1-8


  7108    FE 03                         CP 03h
  710A    38 28                         JR C,EZ04
  710C    28 26                         JR Z,EZ04
  710E    5F                            LD E,A
  710F    F1                            POP AF
  7110    3C                            INC A
  7111    27                            DAA
  7112    F5                            PUSH AF
  7113    7B                            LD A,E
  7114    D6 03                         SUB 03H
  7116    FE 03                         CP 03H
  7118    38 1A                         JR C,EZ04
  711A    28 18                         JR Z,EZ04
  711C    5F                            LD E,A
  711D    F1                            POP AF
  711E    3C                            INC A
  711F    27                            DAA
  7120    CB 47                         BIT 0,A
  7122    28 E0                         JR Z,EZ03
  7124    F5                            PUSH AF
  7125    7B                            LD A,E
  7126    D6 03                         SUB 03H
  7128    FE 03                         CP 03H
  712A    38 08                         JR C,EZ04
  712C    28 06                         JR Z,EZ04
  712E    5F                            LD E,A
  712F    F1                            POP AF
  7130    3C                            INC A
  7131    27                            DAA
  7132    18 D0                         JR EZ03
                                        ;-------------------
  7134    F1                    EZ04:   POP AF
  7135    C5                            PUSH BC
  7136    4F                            LD C,A
  7137    C5                            PUSH BC
  7138    CD 7817                       CALL HEX00              ; % WERT AUSGEBEN
  713B    C1                            POP BC
  713C    C1                            POP BC
  713D    3E 25                         LD A,'%'                ; % ALS ZEICHEN
  713F    CD 788B                       CALL HEXC
  7142    D1                            POP DE
  7143    E1                            POP HL
  7144    2A 6524                       LD HL,(RADR)    ; load current BLASE address
                                        ; from here against BLASEN address
                                        ;-------------------------------
                                        ; key in sign
                                        ;
  7147    23                            INC HL          ; next block
  7148    46                            LD B,(HL)       ; load block length 
  7149    E5                            PUSH HL
  714A    21 6B27                       LD HL,RAMT      ; RAMT Zeichen Buffer Eingaben
  714D    11 6B27                       LD DE,RAMT
  7150    13                            INC DE          ; fuer erstes Zeichen
  7151    AF                            XOR A
  7152    77                            LD (HL),A       ; Eingabe Zeichenzaehler auf Null setzen
  7153    B8                            CP B
        MACRO-80 3.43   27-Jul-81       PAGE    1-9


  7154    CA 7212                       JP Z,BL03       ; SPEUNG ZUR EINGABE OHNE GRAFIK AUSGABE 
                                        ;--------------------------
                                        ; Eingabezeile ausgeben
  7157    D5                            PUSH DE
  7158    E5                            PUSH HL         ; Grafik/Text 
  7159    C5                            PUSH BC
  715A    3A 6003                       LD A,(RAM+RTYPE2)
  715D    FE 00                         CP 0H
  715F    C2 716E                       JP NZ,EZ02
  7162    21 8045                       LD HL,EBUFF
  7165    06 36                         LD B,EZLEN
  7167    7E                    EZ01:   LD A,(HL)
  7168    CD 788B                       CALL HEXC
  716B    23                            INC HL
  716C    10 F9                         DJNZ EZ01
  716E    C1                    EZ02:   POP BC
  716F    E1                            POP HL
  7170    D1                            POP DE
  7171    C5                    BL02:   PUSH BC
  7172    D5                            PUSH DE
  7173    E5                            PUSH HL
  7174    CD 7ABF                       CALL TAS        ; auf Zeichen Warten
  7177    F5                            PUSH AF
  7178    CD 789A                       CALL CON        ; CURSOR ON
  717B    F1                            POP AF
  717C    E1                            POP HL
  717D    D1                            POP DE
  717E    C1                            POP BC
  717F    12                            LD (DE),A       ; Zeichen abspeichen
  7180    FE 0D                         CP 0DH
  7182    CA 7212                       JP Z,BL03       ; Ausgang mit CR
  7185    FE 08                         CP 08H          ; TAB
  7187    20 1F                         JR NZ,BL021     ; NEIN ->
                                        ;-----------------
                                        ; BACKSPACE FUNKTION CURSOR LINKS MIT ZEICHEN LOESCHEN
                                        ;
  7189    7E                            LD A,(HL)               ; Zeichenzaehler
  718A    D6 01                         SUB 01H
  718C    DA 7210                       JP C,BL023
  718F    77                            LD (HL),A               ; Zeichenlaenge -1
  7190    3E 20                         LD A,20H
  7192    CD 788B                       CALL HEXC
  7195    04                            INC B
  7196    1B                            DEC DE          ; Zeichen loeschen
  7197    3E 1B                         LD A,1BH
  7199    CD 788B                       CALL HEXC
  719C    3E 5B                         LD A,5BH
  719E    CD 788B                       CALL HEXC
  71A1    3E 44                         LD A,44H
  71A3    CD 788B                       CALL HEXC
  71A6    18 C9                         JR BL02         ; zurueck ohne B dec
                                        ;-------------------
                                        ; ESC 
                                        ; 
  71A8    FE 1B                 BL021:  CP 1BH          ; ESC
  71AA    20 5E                         JR NZ,BL022     ; NEIN ->
        MACRO-80 3.43   27-Jul-81       PAGE    1-10


  71AC    7E                            LD A,(HL)
  71AD    FE 00                         CP 0H
  71AF    20 59                         JR NZ,BL022
  71B1    D5                            PUSH DE
  71B2    C5                            PUSH BC
  71B3    E5                            PUSH HL
  71B4    06 A0                 BL120:  LD B,0A0H
  71B6    10 FE                         DJNZ $          ; DELAY
  71B8    CD 79A0                       CALL KEYST      ; pruefe ob Zeichen da
  71BB    FE 00                         CP 0H
  71BD    28 41                         JR Z,BL121      ; -> NO
  71BF    5F                            LD E,A
  71C0    FE 5B                         CP '['
  71C2    28 F0                         JR Z,BL120
  71C4    3E 44                         LD A,'D'
  71C6    BB                            CP E
  71C7    38 37                         JR C,BL121
  71C9    3E 40                         LD A,'@'
  71CB    BB                            CP E
  71CC    30 32                         JR NC,BL121
  71CE    3E 41                         LD A,'A'
  71D0    BB                            CP E
  71D1    20 0D                         JR NZ,BL123
  71D3    3A 802E                       LD A,(ZEIL)
  71D6    3C                            INC A
  71D7    FE 07                         CP CURUD
  71D9    30 25                         JR NC,BL121
  71DB    32 802E                       LD (ZEIL),A
  71DE    18 20                         JR BL121
                                ;--------------------------     
  71E0    3E 42                 BL123:  LD A,'B'
  71E2    BB                            CP E
  71E3    20 0D                         JR NZ,BL124
                                        ;JR NZ,BL123
  71E5    3A 802E                       LD A,(ZEIL)
  71E8    3D                            DEC A
  71E9    FE 01                         CP 01H
  71EB    38 13                         JR C,BL121
  71ED    32 802E                       LD (ZEIL),A
  71F0    18 0E                         JR BL121
                                        ;-------------------
  71F2    3E 43                 BL124:  LD A,'C'
  71F4    BB                            CP E
  71F5    20 02                         JR NZ,BL125
                                ; Cursor right
  71F7    18 07                         JR BL121
                                        ;-----------
  71F9    3E 44                 BL125:  LD A,'D'
  71FB    BB                            CP E
  71FC    20 02                         JR NZ,BL121
                                ; Cursor left
  71FE    18 B4                         JR BL120
                                        ;------------
  7200    AF                    BL121:  XOR A           ; letzes Zeichen loeschen
  7201    E1                            POP HL
  7202    C1                            POP BC
        MACRO-80 3.43   27-Jul-81       PAGE    1-11


  7203    D1                            POP DE
  7204    77                            LD (HL),A               ; Zeichenzaehler loeschen
  7205    18 03                         JR BL022
  7207    C3 7171               BL02X:  JP BL02
                                        ;-------------
  720A    FE 21                 BL022:  CP 21H          ; Zeichen < Space
  720C    38 02                         JR C,BL023
  720E    13                            INC DE          ; Zeichenadr. +1
  720F    34                            INC (HL)        ; Zeichenzaehler erhoehen
  7210    10 F5                 BL023:  DJNZ BL02X      ; vorgegebene Laenge aus Blase
                                ;-----------------------
                                ; load and execute file.com
                                ;
  7212    E1                    BL03:   POP HL          ; zurueck zur aktuellen RAM adre.
  7213    7E                            LD A,(HL)       ; Pruefe ob Zeiche ??Programmaufruf da 
  7214    23                            INC HL          ; PROGRAMM 
  7215    FE 00                         CP 00H
  7217    28 0A                         JR Z,BL031      ; ->set Programm number (Maske1 = 1)
  7219    3A 6B27                       LD A,(RAMT)
  721C    FE 00                         CP 00H
  721E    20 0D                         JR NZ,BL030
  7220    C3 70AF                       JP BL00+3       ; +3 VERSUCH !!!!kein Zeichen gedruekt
                                        ;------------------------
  7223    3E 31                 BL031:  LD A,31H        ; sonst Zeichenzaehler auf 1 setzen
  7225    32 6B28                       LD (RAMT+1),A   ; 
  7228    3E 01                         LD A,01H        ; Programme mindest ASCII 1
  722A    32 6B27                       LD (RAMT),A     ; Programmzaehler
  722D    46                    BL030:  LD B,(HL)       ; Anzahl von Programmaufrufe aus Blase
  722E    AF                            XOR A           ; LOESCHEN
  722F    B8                            CP B
  7230    CA 7338                       JP Z,BL14       ; SPEUNG 
                                        ;--------------
  7233    3A 6B27                       LD A,(RAMT)     ; Anzahl der Taste 
  7236    FE 02                         CP 02H          ; ZEICHEN ZAEHLER >
  7238    D2 7338                       JP NC,BL14      ; Taste mehr als eine Stelle
  723B    3A 6B28                       LD A,(RAMT+1)   ; gedruektes Taste =31-39  Zeichen
  723E    FE 30                         CP 30H
  7240    28 19                         JR Z,TEING      ; ??Aender moeglich machen mit 0
  7242    FE 39                         CP 39H          ; MIT 9 ENDE
  7244    20 05                         JR NZ,BL033
  7246    0E 00                 EXIT:   LD C,00H
  7248    C3 7FA5                       JP EPROMON
                                ;-------
  724B    FE 3A                 BL033:  CP 3AH          ; nicht > 9
  724D    D2 70AC                       JP NC,BL00      ; AUSGANG FEHLER
  7250    D6 30                         SUB 30H         ; nicht < 1
  7252    DA 70AC                       JP C,BL00       ; AUSGANG FEHLER
  7255    47                            LD B,A          ; Welches Programm in A 1 - 9
                                ;!!!    INC HL ;!!! FEHLERSUCHE AUSGABE FALSCH
  7256    22 6524                       LD (RADR),HL    ; aktuelle RAM Adresse retten 
  7259    18 0C                         JR BL131
                                        ;-------------------
                                        ; AENDERUNG NUR IN TYPE2 =0 MOEGLICH
  725B    3A 6003               TEING:  LD A,(RAM+RTYPE2)
  725E    FE 00                         CP 0H
  7260    CA 757B                       JP Z,EING
        MACRO-80 3.43   27-Jul-81       PAGE    1-12


  7263    C3 70AC                       JP BL00
                                        ;-----------------
                                        ; Programm suchen und Starten
  7266    19                            ADD HL,DE
  7267    11 000C               BL131:  LD DE,000CH     ; MAX Laenge einer Datei
  726A    10 FA                         DJNZ BL131-1    
  726C    11 0080               BL132:  LD DE,BUFF      ; <- Zurueck von Zeilen-Prog.aufruf
                                ;!!!    INC HL          ; WIEVIEL ZEICHEN DATEINAME
                                ;!!!    LD A,(HL)       ; PRUEFE DAPROGRAMME 
                                ;!!!    CP 0H
                                ;!!!    JP Z,BL00       ; KEIN PROGRAMM =0 ->
  726F    3E 0C                         LD A,12D
  7271    12                            LD (DE),A
  7272    13                            INC DE
  7273    E6 0F                         AND 0FH
  7275    47                            LD B,A          ; Laenge der Datei auslesen
  7276    CD 727F                       CALL BL13
  7279    DA 731A                       JP C,BL830      ; ERROR DATEI NICHT GEFUNDEN
  727C    C3 7311                       JP BL84
                                        ;-------------------
                                        ; PROGRAMM AUS (HL) ]BERNEHMEM UND LADEN
                                        ; B= LAENGE DES DATEINAMEN
                                        ; (HL) DATEINAME.COM
                                        ; NACH (DE) BUFFER COPIEREN 
                                        ;
  727F    23                    BL13:   INC HL          ; DATEINAME ERSTES ZEICHEN
  7280    7E                            LD A,(HL)
  7281    FE 21                         CP 21H          ; PRUEFE OB NOCH ASCII >20H (SPACE)
  7283    38 05                         JR C,BL13D      ; UMSTELLUNG DATEINAME IMMER 12D LANG
  7285    12                            LD (DE),A
  7286    CD 788B                       CALL HEXC       ;!!! PROGRAMM NAME SICHTBAR MACHEN ZUM TEST
  7289    13                            INC DE
  728A    10 F3                 BL13D:  DJNZ BL13
  728C    AF                            XOR A
  728D    12                            LD (DE),A
                                        ;------------------
                                        ;
  728E    11 005D                       LD DE,FCBFN
  7291    3E 20                         LD A,20H
  7293    06 0B                         LD B,0BH
  7295    12                    BL23:   LD (DE),A       ; LOESCHEN B MAL
  7296    13                            INC DE
  7297    10 FC                         DJNZ BL23
  7299    3E 00                         LD A,00H
  729B    06 08                         LD B,08H
  729D    12                    BL231:  LD (DE),A       ; LOESCHEN B MAL
  729E    13                            INC DE
  729F    10 FC                         DJNZ BL231
                                        ;--------------
                                        ;
  72A1    E5                            PUSH HL
  72A2    11 005C                       LD DE,FCB
  72A5    AF                            XOR A
  72A6    12                            LD (DE),A
  72A7    13                            INC DE
  72A8    21 0080                       LD HL,BUFF
        MACRO-80 3.43   27-Jul-81       PAGE    1-13


  72AB    46                            LD B,(HL)       ; DATEINAMEN LAENGE
  72AC    23                            INC HL
  72AD    7E                    BL33:   LD A,(HL)
  72AE    FE 2E                         CP 2EH          ; POINT ERKENNUNG .COM
  72B0    20 06                         JR NZ,BL43
  72B2    23                            INC HL
  72B3    11 0065                       LD DE,FCBFT
  72B6    18 F5                         JR BL33 
                                        ;-----------
  72B8    12                    BL43:   LD (DE),A
  72B9    13                            INC DE
  72BA    23                            INC HL
  72BB    10 F0                         DJNZ BL33
  72BD    CD 7928                       CALL IDERES
  72C0    AF                            XOR A
  72C1    06 14                         LD B,14H
  72C3    12                    BL53:   LD (DE),A
  72C4    13                            INC DE
  72C5    10 FC                         DJNZ BL53
  72C7    1E 04                         LD E,SELDM              ; MASTER DISK
  72C9    0E 0E                         LD C,14D
  72CB    CD 0005                       CALL 0005H              ; BEZUGSLAUFWERK LW-NUMMER
  72CE    E5                            PUSH HL
  72CF    AF                            XOR A
  72D0    32 006B                       LD (FCBCR),A    ; cr loeschen
  72D3    11 005C                       LD DE,FCB
  72D6    0E 0F                         LD C,0FH
  72D8    CD 0005                       CALL 0005H
  72DB    FE FF                         CP 0FFH
  72DD    20 04                         JR NZ,BL73              ; ->kein Fehler POP HL fehlt
  72DF    E1                            POP HL
  72E0    E1                            POP HL          ; Adresse zurueck
  72E1    37                            SCF
  72E2    C9                            RET
                                        ;--------------------
                                        ;  Dateisatz lesen
                                        ;
  72E3    3A 007C               BL73:   LD A,(FCBRA)
  72E6    11 0100                       LD DE,0100H     ; DMA Buffer
  72E9    FE 00                 BL736:  CP 00H
  72EB    28 09                         JR Z,BL83
  72ED    3D                            DEC A
  72EE    21 0080                       LD HL,0080H
  72F1    19                            ADD HL,DE
  72F2    E5                            PUSH HL
  72F3    D1                            POP DE          ; HL nach DE kopieren
  72F4    18 F3                         JR BL736
  72F6    0E 1A                 BL83:   LD C,1AH        ; Datenbuffer festlegen
  72F8    CD 0005                       CALL 0005H      ; CCP
  72FB    E5                            PUSH HL
  72FC    D5                            PUSH DE
  72FD    C5                            PUSH BC
  72FE    11 005C                       LD DE,FCB
  7301    0E 14                         LD C,14H
  7303    CD 0005                       CALL 0005H      ; Datei laden
  7306    C1                            POP BC
        MACRO-80 3.43   27-Jul-81       PAGE    1-14


  7307    D1                            POP DE
  7308    E1                            POP HL
  7309    FE 00                         CP 00H
  730B    28 D6                         JR Z,BL73       ; wiederhole bie Datei geladen
  730D    E1                            POP HL          ; wenn bei BL53: kein Fehler RAM weiter
  730E    E1                            POP HL          ; Adresse zurueck
  730F    AF                            XOR A
  7310    C9                            RET
                                        ;---------------
                                        ; GEFUNDENES PROGRAMM STARTEN
                                        ;
  7311    E5                    BL84:   PUSH HL
  7312    D5                            PUSH DE
  7313    C5                            PUSH BC
  7314    CD 0100                       CALL 0100H
  7317    C1                            POP BC
  7318    D1                            POP DE
  7319    E1                            POP HL
                                        ;------------------
                                        ; Ende der Programme berechnen
  731A    2A 6524               BL830:  LD HL,(RADR)    ; Aktuelle Blasenadresse holen
  731D    46                            LD B,(HL)       ; NAECHSTE DATEI LAENGE
  731E    04                            INC B           ; ERSTES ZEICHEN
  731F    18 01                         JR BL831
                                        ;-----------
  7321    19                            ADD HL,DE
  7322    11 000C               BL831:  LD DE,000CH     ; Laenge (13Dez.) einer Datei
  7325    10 FA                         DJNZ BL831-1    
  7327    23                            INC HL
                                        ;-----------------
                                        ; Sprungadresse in I/O-RAM (0) Laden
                                        ;
  7328    3A 6200               BL04:   LD A,(BLAN)     ; Rueckmeldung aus Unterprogramm
  732B    FE 00                         CP 00H
  732D    CA 70AC                       JP Z,BL00       ; Blase neu starten
  7330    FE 01                         CP 01H
  7332    CA 70AF                       JP Z,BL00+3     ; naechster Block 
  7335    C3 70AC                       JP BL00         ; weiter mit RAM
                                ;---------------------------
                                ; Aktuelle Blase im RAM nach Begriff durchsuchen
                                ;
  7338    3A 6001               BL14:   LD A,(RAM+1)    ; Type1
  733B    47                            LD B,A
                                ;??     LD A,(USER) TYPE1
  733C    B8                            CP B
  733D    CA 7340                       JP Z,BS10               ; gefunden
                                ;---------------------------
                                ;  Blase vom Anfang aus nach RAMR laden und Text suchen
                                 
  7340    3A 7FF2               BS10:   LD A,(BF00+RUSER)       ; UEBERNEHMEN
  7343    32 801E                       LD (BF10+RUSER),A       ; loeschen 
  7346    3A 7FF3                       LD A,(BF00+RTYPE1)      ; uebernehmen
  7349    32 801F                       LD (BF10+RTYPE1),A      ; loeschen 
  734C    3A 7FF4                       LD A,(BF00+RTYPE2)      ; uebernehmen 
  734F    32 8020                       LD (BF10+RTYPE2),A      ; loeschen 
  7352    32 8021                       LD (BF10+RTERM),A       ; loeschen 
        MACRO-80 3.43   27-Jul-81       PAGE    1-15


  7355    32 8022                       LD (BF10+RBSTAT),A      ; loeschen 
  7358    AF                            XOR A
  7359    32 650B                       LD (BFVHH),A    ; Aktuelle Track/Sectoradresse laden
  735C    32 650A                       LD (BFVHL),A
  735F    21 0801                       LD HL,HDD+1     ; Startadresse
  7362    22 6508                       LD (BFVLL),HL   ; Aktuelle Track/Sectoradresse laden
                                ;-------------------------
                                ; Blase zum vergleich laden und Text in Speicher suchen
                                ;
  7365    C5                    SU00:   PUSH BC
  7366    D5                            PUSH DE
  7367    E5                            PUSH HL
  7368    CD 78AB                       CALL COFF
  736B    06 50                         LD B,80D
  736D    21 6B27                       LD HL,RAMT
  7370    11 6BEF                       LD DE,RTEX
  7373    7E                    STX01:  LD A,(HL)
  7374    12                            LD (DE),A
  7375    23                            INC HL
  7376    13                            INC DE
  7377    10 FA                         DJNZ STX01
  7379    ED 4B 6508            SU01:   LD BC,(BFVLL)
  737D    ED 5B 650A                    LD DE,(BFVHL)           ; Suchadresse 
  7381    21 6527                       LD HL,RAMV
  7384    CD 7DA2                       CALL RDREAD             ; AKTUELLE BLASE LADEN
                                        ; READ SICHTBAR MACHEN
  7387    01 1501                       LD BC,1501H
  738A    CD 7A8C                       CALL LIST
  738D    21 6527                       LD HL,RAMV
  7390    CD 7AB2                       CALL LIS0
  7393    E5                            PUSH HL
  7394    21 0801                       LD HL,HDD+1
  7397    22 6510                       LD (BFSLL+4),HL
  739A    21 0000                       LD HL,0000H
  739D    22 6512                       LD (BFSHL+4),HL
  73A0    E1                            POP HL
                                        ;---------------------
                                        ; Cursor drehen lassen und
                                        ; nach Abstand gefundener Zeichen setzen
  73A1    CD 7E6A                       CALL UHR00
  73A4    3E 02                         LD A,02H
  73A6    32 651C                       LD (CURT),A
  73A9    3E 04                         LD A,04H
  73AB    32 651D                       LD (CURT+1),A
  73AE    3E 02                         LD A,02H
  73B0    32 651E                       LD (CURT+2),A
  73B3    3A 6B27                       LD A,(RAMT)
  73B6    FE 0A                         CP 0AH
  73B8    38 0E                         JR C,SU02
  73BA    D6 0A                         SUB 0AH
  73BC    32 651F                       LD (CURT+3),A
  73BF    3A 651E                       LD A,(CURT+2)
  73C2    3C                            INC A
  73C3    32 651E                       LD (CURT+2),A
  73C6    18 03                         JR SU03
  73C8    32 651F               SU02:   LD (CURT+3),A
        MACRO-80 3.43   27-Jul-81       PAGE    1-16


                                        ;------------------------
                                        ; vergleich, suche nach Blasen beginnen
                                        ;
  73CB    CD 7854               SU03:   CALL CUT
  73CE    21 6527                       LD HL,RAMV              ; in Blase suchen mit
  73D1    11 6B27                       LD DE,RAMT              ; Textanfang 1. Zeichen
  73D4    1A                            LD A,(DE)               ; neue TextLAENGE mit
  73D5    FE 02                         CP 02H                  ; Suchtext muss > 1 Zeichen sein
  73D7    DA 7536                       JP C,SU52               ; Ausgang ohne suchtext
  73DA    23                            INC HL                  ; ZU USER 
  73DB    3A 7FF2                       LD A,(BF00+RUSER)       ; Aus sichtbarer aktuel Blase
  73DE    BE                            CP (HL)                 ; RAMV VERGLEICH MIT USER IN BLASE 
                                        ;JP Z,SU80              ; User mit Blase ist gleich 
                                        ;JP NC,SU62             ; ERST IN USER+1 LEERE BLASE SUCHEN
  73DF    3A 652B               SU04:   LD A,(RAMV+RTERM)       ; Gedaechtnisszaehler
  73E2    FE FF                         CP 0FFH                 ; nach leerer ,abgelaufener Blase 
  73E4    C2 74AC                       JP NZ,SU62              ; noch nicht leer, abgelaufen
  73E7    3A 6003                       LD A,(RAM+RTYPE2)       ; MUSS BLASENANFANG SEIN
  73EA    FE 00                         CP 0H                   ; nach leerer ,abgelaufener Blase 
  73EC    C2 7536                       JP NZ,SU52              ; noch nicht leer, abgelaufen
                                ;-----------------------
                                ; neue Blase Eroeffnen mit Eingabetext 
                                ; als Ueberschrift
                                ;
                                ; Blasenadr. BFVxx mit BFRxx tauschen (HL)->(DE)
                                ;               
  73EF    11 6500                       LD DE,BFRLL     ; Aktuelle Blaseadresse ersetzen durch
  73F2    21 6508                       LD HL,BFVLL     ; Leere gefundene Blase
  73F5    EB                            EX DE,HL        ; TAUSCHEN
                                        ;----------------
  73F6    3A 8020                       LD A,(BF10+RTYPE2)
  73F9    FE 00                         CP 0H
  73FB    28 19                         JR Z,SU85
  73FD    06 19                         LD B,25D                ; laenge DES KOPFTEXT AUS Blase einkopieren
  73FF    11 601B                       LD DE,RAM+1BH   ; Adr. Aktueller Blase
  7402    21 8381                       LD HL,TBLASE+1BH        ; Textblock leerer Blase
  7405    1A                    SU88:   LD A,(DE)
  7406    77                            LD (HL),A
  7407    23                            INC HL
  7408    13                            INC DE
  7409    10 FA                         DJNZ SU88
  740B    06 57                         LD B,TBLLE      ; laenge neuer Blase einkopieren
  740D    11 6000                       LD DE,RAM       ; Adr. Aktueller Blase
  7410    21 8366                       LD HL,TBLASE    ; Textblock leerer Blase
  7413    C3 741E                       JP SU82
                                        ;---------------
  7416    06 AD                 SU85:   LD B,NBLLE      ; laenge neuer Blase einkopieren
  7418    11 6000                       LD DE,RAM       ; Adr. Aktueller Blase
  741B    21 82B9                       LD HL,NBLASE    ; Textblock leerer Blase
  741E    7E                    SU82:   LD A,(HL)       ; kopieren
  741F    12                            LD (DE),A
  7420    23                            INC HL
  7421    13                            INC DE
  7422    10 FA                         DJNZ SU82
  7424    11 6001                       LD DE,RAM+1     ; Aktuelle USER
                                        ;----------------
        MACRO-80 3.43   27-Jul-81       PAGE    1-17


                                        ; Ueberschrift aus suchtext einsetzen
  7427    3A 6B27                       LD A,(RAMT)
  742A    47                            LD B,A          ; Textlaenge in B
  742B    11 6000                       LD DE,RAM
  742E    13                    SU83:   INC DE          ; Nach Space 20H suchen erstes Zeichen
  742F    1A                            LD A,(DE)
  7430    FE 20                         CP 20H
  7432    20 FA                         JR NZ,SU83
                                        ;-----------------
  7434    21 6B28                       LD HL,RAMT+1    ; erstes Zeichen
  7437    7E                    SU84:   LD A,(HL)               ; uebertrageb bis B=0
  7438    12                            LD (DE),A
  7439    23                            INC HL
  743A    13                            INC DE
  743B    10 FA                         DJNZ SU84
                                        ;-----------------      
                                        ; BF10 IN NEU GEFUNDENE BLASE ]BERNEHMEN
                                        ; RUSER, RTYPE1+1, RTYPE2
                                        ;
  743D    3A 801E                       LD A,(BF10+RUSER)
  7440    32 6001                       LD (RAM+RUSER),A        ; Aktueller USER uebernehmen
  7443    3A 8020                       LD A,(BF10+RTYPE2)
  7446    FE 00                         CP 0
  7448    28 0B                         JR Z,SU86
  744A    3A 7FF3                       LD A,(BF00+RTYPE1)      ; uebernehmen 
  744D    32 6002                       LD (RAM+RTYPE1),A       ; uebernehmen 
  7450    3A 8020                       LD A,(BF10+RTYPE2)      ; uebernehmen 
                                        ;LD (RAM+RTYPE2),A      ; uebernehmen 
  7453    18 0D                         JR SU87 
  7455    3A 801F               SU86:   LD A,(BF10+RTYPE1)      ; uebernehmen 
  7458    3C                            INC A
  7459    32 6002                       LD (RAM+RTYPE1),A       ; uebernehmen 
  745C    3A 8020                       LD A,(BF10+RTYPE2)      ; uebernehmen 
  745F    32 6003                       LD (RAM+RTYPE2),A       ; uebernehmen 
                                        ;------------------
  7462    E1                    SU87:   POP HL
  7463    D1                            POP DE
  7464    C1                            POP BC
  7465    C3 70AC                       JP BL00
                                        ; ENDE neue Blase anspringen
                                        ;--------------------------
                                        ; weiter vergleichen
                                
  7468    23                    SU80:   INC HL          ; zu TYPE1 in RAMV
  7469    23                            INC HL          ; ZU TYPE2 IN RAMV
  746A    3A 8020                       LD A,(BF10+RTYPE2)
                                        ;CP (HL)
  746D    B6                            OR (HL)
  746E    CA 74EF                       JP Z,SU90
  7471    23                            INC HL          ; Gedaechtnisz. TERM 
  7472    3A 8021                       LD A,(BF10+RTERM)       ; 
  7475    BE                            CP (HL)
  7476    CA 74AC                       JP Z,SU62               ; nicht =1
  7479    23                            INC HL          ; Status Byte
  747A    23                            INC HL          ; ZEICHENAUSWERTUNG
  747B    13                            INC DE          ; ERSTES SUCHZEICHEN IN RAMT
        MACRO-80 3.43   27-Jul-81       PAGE    1-18


  747C    1A                            LD  A,(DE)              ; 1. ZEICHEN MUSS '/' SEIN
  747D    FE 2F                         CP '/'
  747F    28 07                         JR Z,SU25
  7481    AF                            XOR A
  7482    32 8020                       LD (BF10+RTYPE2),A      ; '/' fehlt dann TYPE2=0 und TYPE1 SUCHEN
  7485    C3 74AC                       JP SU62         ; WEITER NACH TYPE1+TYPE2=0 SUCHEN->
                                        ;------------
  7488    3A 6002               SU25:   LD A,(RAM+RTYPE1)
  748B    47                            LD B,A
  748C    3A 6529                       LD A,(RAMV+RTYPE1)
  748F    B8                            CP B
  7490    C2 74AC                       JP NZ,SU62
  7493    3A 652A                       LD A,(RAMV+RTYPE2)
  7496    FE 01                         CP 1H
  7498    DA 74AC                       JP C,SU62
  749B    C2 74AC                       JP NZ,SU62
  749E    3A 6B27                       LD A,(RAMT)     ; neuer Text mit
  74A1    06 3F                         LD B,03FH               ; laenge (255D) eine Zeile zum vergleichen
  74A3    CD 7976               SU21:   CALL SUCH0
  74A6    DA 74AC                       JP C,SU62
                                        ;CALL MAS00
  74A9    C3 7558                       JP SU23
                                        ; Error anzeigen ??
                                        ; Bereich Ende xxxxxxxx1, xxxxxxx2, .... ????
                                        ; noch einbauen
                                        ;
  74AC    CD 79A0               SU62:   CALL KEYST      ; CONSOLE AUF ZEICHEN ABFRAGE
  74AF    FE 1B                         CP 1BH
  74B1    CA 7536                       JP Z,SU52       ; ABBRUCH MIT ESC
  74B4    ED 5B 6508                    LD DE,(BFVLL)   ; Aktuelle Track/Sectoradresse laden
  74B8    D5                            PUSH DE
  74B9    2A 650A                       LD HL,(BFVHL)
  74BC    E5                            PUSH HL
  74BD    CD 79B4                       CALL LBA0               ; Suchadresse +1
  74C0    E1                            POP HL
  74C1    22 650A                       LD (BFVHL),HL   
  74C4    D1                            POP DE
  74C5    ED 53 6508                    LD (BFVLL),DE           ; Suchadresse speichern
  74C9    38 6B                         JR C,SU52       ; CARRY -> ENDE
  74CB    18 11                         JR SU63
                                        ;--------------
  74CD    ED 4B 801B                    LD BC,(BF07+2)          ; HL
  74D1    ED 42                         SBC HL,BC
  74D3    38 09                         JR C,SU63
  74D5    EB                            EX DE,HL
  74D6    ED 4B 8019                    LD BC,(BF07)            ; LL
  74DA    ED 42                         SBC HL,BC               
  74DC    30 58                         JR NC,SU52              ; LETZTE SUCHADRESSE AUS TAS00 
  74DE    7B                    SU63:   LD A,E
  74DF    E6 1F                         AND 1FH
  74E1    FE 10                         CP 10H
  74E3    C2 7379                       JP NZ,SU01
  74E6    CD 7854                       CALL CUT
  74E9    CD 7834                       CALL SANDU
  74EC    C3 7379                       JP SU01
                                        ;--------------------------
        MACRO-80 3.43   27-Jul-81       PAGE    1-19


                                        ; weiter vergleichen
                                        ; fuer naechste neue Blase vorbereiten 
                                        ; und in neuer Blase uebernehmen
  74EF    2B                    SU90:   DEC HL          ; ZURUECK ZU TYPE1
  74F0    3A 801F                       LD A,(BF10+RTYPE1)      ; Type1 
  74F3    BE                            CP (HL)
  74F4    30 09                         JR NC,SU99
  74F6    3C                            INC A
  74F7    28 06                         JR Z,SU99               ; groesser 0FFH
  74F9    BE                            CP (HL)
  74FA    20 03                         JR NZ,SU99              ; Abstand groesser 1
  74FC    32 801F                       LD (BF10+RTYPE1),A      ; Type1 wenn groesser uebernehmen
  74FF    23                    SU99:   INC HL          ; Type2 in Blase
                                ;--------------------------
                                ;       hier auf erste Type2 =0 selektiert aus Blase
                                ;
  7500    3A 8020                       LD A,(BF10+RTYPE2)      ; Type2 aus RAMV Blase
  7503    BE                            CP (HL)
  7504    C2 74AC                       JP NZ,SU62              ; NEUE RAMV BLASE nicht =0 
                                ;--------------------------
                                ; wenn Gedaechtnisszaehler =0 dann ungueltig
                                ; frei fuer neue Blase
  7507    23                            INC     HL              ; Gedaechtnisz. TERM 
  7508    3A 8021                       LD      A,(BF10+RTERM)  ; Gedaechtnisz. aus Blase
  750B    BE                            CP      (HL)
  750C    CA 74AC                       JP      Z,SU62          ; nicht =1 ->
  750F    23                            INC     HL              ; Status Byte
  7510    23                            INC     HL              ; ZeichenGROESSE
  7511    1A                            LD      A,(DE)          ; neuer Text mit
  7512    47                            LD      B,A
  7513    13                            INC     DE              ; ERSTES ZEICHEN
                                        ;--------------------
                                        ; ERSTES ZEICHEN GROSS
  7514    1A                            LD      A,(DE)
  7515    FE 5B                         CP      5BH
  7517    D2 7536                       JP      NC,SU52         ; ERSTES ZEICHEN MUSS GROSS BUCHST.SEIN
                                        ;--------------------
  751A    78                            LD      A,B
  751B    06 3F                         LD      B,3FH           ; laenge (46D) eine Zeile zum vergleichen
  751D    CD 7976                       CALL    SUCH0
  7520    DA 74AC                       JP      C,SU62
  7523    3A 6529                       LD      A,(RAMV+RTYPE1) ; WENN BLASE GEFUNDEN TYPE1 UEBERNEHMEN
  7526    32 801F                       LD      (BF10+RTYPE1),A ; Type1 =0 wenn BLASE GEFUNDEN
  7529    3A 8020                       LD      A,(BF10+RTYPE2) ; BLASE TYPE1 GEFUNDEN
  752C    3C                            INC     A               ;SET    0,A >0 SETZEN F]R TYPE2 SUCHEN
  752D    32 8020                       LD      (BF10+RTYPE2),A
  7530    C3 7558                       JP      SU23
                                ;-----------------------
                                ; Kein Eintrag in TYPE2>0 gefunden
                                ;       
  7533    C3 70AC               SU95:   JP BL00
                                ;----------------
                                ;
  7536    21 8238               SU52:   LD HL,MELD01
  7539    06 36                         LD B,MELD01X
  753B    0E 02                         LD C,02H                ; BIOS Console Output
        MACRO-80 3.43   27-Jul-81       PAGE    1-20


  753D    CD 7FE5                       CALL BIOS
  7540    11 0000                       LD DE,0000H
  7543    06 08                         LD B,08H
  7545    3E 00                         LD A,00H
  7547    32 6B27                       LD (RAMT),A
  754A    15                    SU520:  DEC D
  754B    20 FD                         JR NZ,SU520
  754D    1D                            DEC E
  754E    20 FA                         JR NZ,SU520
  7550    10 F8                         DJNZ SU520
  7552    E1                            POP HL
  7553    D1                            POP DE
  7554    C1                            POP BC
  7555    C3 70AC                       JP BL00
                                        ;----------------
                                        ; AKTUELLE MIT GEFUNDENE BLASE TAUSCHEN
                                        ; DANN NEUE BLASE ANZEIGEN      
  7558    06 04                 SU23:   LD B,04H
  755A    11 6500                       LD DE,BFRLL
  755D    21 6508                       LD HL,BFVLL
  7560    7E                    SU32:   LD A,(HL)
  7561    12                            LD (DE),A
  7562    23                            INC HL
  7563    13                            INC DE 
  7564    10 FA                         DJNZ SU32
                                        ; EINGABEZEILE LOESCHEN
  7566    01 2401                       LD BC,2401H
  7569    CD 7A8C                       CALL LIST
  756C    06 46                         LD B,70D
  756E    3E 20                 SU33:   LD A,20H
  7570    CD 788B                       CALL HEXC
  7573    10 F9                         DJNZ SU33
  7575    E1                            POP HL
  7576    D1                            POP DE
  7577    C1                            POP BC
  7578    C3 7071                       JP BL
                                ;------------------------
                                ;       Starte Eingabemode
                                ;
  757B    C5                    EING:   PUSH BC
  757C    D5                            PUSH DE
  757D    E5                            PUSH HL
                                        ;------------------------
                                        ; pruefe auf Anfangsadresse BLASE = RAM
                                        ;       
  757E    2A 6524                       LD HL,(RADR)    ; zuletzten Blasenabschnitt Adr.0
  7581    3E 00                         LD A,00H
  7583    32 6B27                       LD (RAMT),A     ; ZEICHEN EINGABEZAEHLER AUF 0 SETZEN
  7586    BE                            CP (HL)
  7587    20 18                         JR NZ,ED00
  7589    AF                            XOR A
  758A    11 6000                       LD DE,RAM
  758D    ED 52                         SBC HL,DE
  758F    20 34                         JR NZ,ED10              ; -> ADRESSE NICHT GLEICH
                                        ;--------------------
                                        ; (RADR) = RAM und kein Zechen 
        MACRO-80 3.43   27-Jul-81       PAGE    1-21


                                        ; dann Blase mit 00H ueberschreiben 2*256lang
                                        ;
  7591    06 00                         LD B,00H
  7593    3E 00                 ED01:   LD A,00H                ; RAM 256 auf null setzen
  7595    77                            LD (HL),A
  7596    23                            INC HL
  7597    10 FA                         DJNZ ED01
  7599    06 00                         LD B,00H
  759B    3E 00                 ED02:   LD A,00H                ; RAM 256 auf null setzen
  759D    77                            LD (HL),A
  759E    23                            INC HL
  759F    10 FA                         DJNZ ED02
                                        ;---------------------
                                        ; Blasenanfang bestimmen
                                        ;
  75A1    2A 6524               ED00:   LD HL,(RADR)
                                ;       LD B,(HL)
  75A4    06 F0                         LD B,0F0H               ; Max Zeicheneingabe
  75A6    AF                            XOR A
  75A7    11 6000                       LD DE,RAM
  75AA    ED 52                         SBC HL,DE
  75AC    2A 6524                       LD HL,(RADR)
  75AF    20 14                         JR NZ,ED10              ; -> kein Blasenanfang
  75B1    23                            INC HL
  75B2    3A 6201                       LD A,(USER)     ; in Blase uebernemen
  75B5    77                            LD (HL),A
  75B6    23                            INC HL
  75B7    3A 6202                       LD A,(TYPE1)
  75BA    77                            LD (HL),A
  75BB    23                            INC HL
  75BC    3A 6203                       LD A,(TYPE2)
  75BF    77                            LD (HL),A
  75C0    23                            INC HL          ; Gedaechtniss Zaehler
  75C1    3E 7F                         LD A,07FH               ; auf 50% setzen
  75C3    77                            LD (HL),A
  75C4    23                            INC HL          ; Status Byte
                                        ;------------------------
                                        ;  Grafik/Text ausgeben
                                        ;
  75C5    C5                    ED10:   PUSH BC
  75C6    01 0301                       LD BC,0301H
  75C9    CD 7A8C                       CALL LIST
  75CC    2A 6524                       LD HL,(RADR)
  75CF    3A 6B27                       LD A,(RAMT)
  75D2    3C                            INC A
  75D3    47                            LD B,A
  75D4    AF                            XOR A           ; RES CARRY FLAG
  75D5    11 6000                       LD DE,RAM
  75D8    ED 52                         SBC HL,DE       ; Blasen Anfang pruefen
  75DA    2A 6524                       LD HL,(RADR)
  75DD    20 0E                         JR NZ,ED100
  75DF    3E 05                         LD A,05H
  75E1    85                            ADD A,L         ; Versatz an Blasenanfang
  75E2    6F                            LD L,A          ; USER, TYPE1, TYPE2, GE, GS, 
  75E3    3E 00                         LD A,00H
  75E5    32 651C                       LD (CURT),A
        MACRO-80 3.43   27-Jul-81       PAGE    1-22


  75E8    3E 01                         LD A,01H
  75EA    32 651D                       LD (CURT+1),A
  75ED    CD 7854               ED100:  CALL CUT
  75F0    23                    ED11:   INC HL          ; erstes Zeichen
  75F1    10 03                         DJNZ ED03
  75F3    C1                            POP BC
  75F4    18 0C                         JR ED12
                                        ;----------------
                                        ; Zeichen ausgeben
                                        ;
  75F6    C5                    ED03:   PUSH BC
  75F7    E5                            PUSH HL
  75F8    5E                            LD E,(HL)
  75F9    0E 02                         LD C,02H
  75FB    CD 0005                       CALL 0005H
  75FE    E1                            POP HL
  75FF    C1                            POP BC
  7600    18 EE                         JR ED11
                                        ;---------------------
                                        ; Tasteneingabe
                                        ;       
  7602    C5                    ED12:   PUSH BC
  7603    E5                            PUSH HL
  7604    CD 79A0               _ED12:  CALL KEYST
  7607    FE 00                         CP 0H
  7609    28 F9                         JR Z,_ED12      ; -> KEIN ZEICHEN
  760B    5F                            LD E,A          ; neues Zeichen
  760C    E1                            POP HL
  760D    C1                            POP BC
  760E    FE 20                         CP 20H
  7610    38 2E                         JR C,ED30       ; wenn Zeichen < 20H
  7612    FE 23                         CP 23H          ; # Zeichen fuer Eingabenende
  7614    CA 763A                       JP Z,ED20
  7617    CD 76C1                       CALL ED50
                                        ;-------------------
                                        ; Rechts Parameter anzeichen
                                        ;
  761A    7E                    ED13:   LD A,(HL)       ; letztes Zeichen zurueckladen
  761B    5F                            LD E,A          ; und Anzeigen aus Reg. E
  761C    C5                            PUSH BC
  761D    01 0578                       LD BC,0578H
                                        ;CALL LIST
  7620    4E                            LD C,(HL)
  7621    C5                            PUSH BC         ; IX HOLEN
  7622    CD 7817                       CALL HEX14
  7625    C1                            POP BC
  7626    01 0473                       LD BC,0473H
  7629    CD 7A8C                       CALL LIST
  762C    C1                            POP BC
  762D    C5                            PUSH BC
  762E    3A 6B27                       LD A,(RAMT)
  7631    4F                            LD C,A
  7632    C5                            PUSH BC         ; IX HOLEN
  7633    CD 7817                       CALL HEX00
  7636    C1                            POP BC
  7637    C1                            POP BC
        MACRO-80 3.43   27-Jul-81       PAGE    1-23


  7638    10 03                 ED14:   DJNZ ED15               ; ED12
  763A    C3 76D8               ED20:   JP EING11
  763D    C3 75C5               ED15:   JP ED10
                                ;-------------------------
                                ; Steuerzeichen Auswerten
                                
  7640    FE 0D                 ED30:   CP 0DH          ; CR
  7642    28 2B                         JR Z,ED40
  7644    FE 08                         CP 08H          ; Backspase
  7646    28 32                         JR Z,ED41
  7648    FE 09                         CP 09H
  764A    28 3D                         JR Z,ED42               ; TAB
  764C    FE 1B                         CP 1BH          ; ESC
  764E    28 3E                         JR Z,ED43
  7650    FE 08                         CP 08H          ; ESC
  7652    28 3F                         JR Z,ED44               ; BackSpace
  7654    C5                            PUSH BC
  7655    E5                            PUSH HL
  7656    06 80                         LD B,80H
  7658    10 FE                 ED31:   DJNZ ED31
  765A    CD 79A0                       CALL KEYST      ; CONSOLE AUF ZEICHEN ABFRAGE
  765D    FE 00                         CP 0
  765F    28 0A                         JR Z,ED32
  7661    C5                            PUSH BC
  7662    4F                            LD C,A
  7663    C5                            PUSH BC
  7664    CD 7817                       CALL HEX14
  7667    C1                            POP BC
  7668    C1                            POP BC
  7669    18 EB                         JR ED31-2
                                        ;-----------
  766B    E1                    ED32:   POP HL
  766C    C1                            POP BC
  766D    18 AB                 ED33:   JR ED13
                                ;--------------------------
                                ;
  766F    CD 76C1               ED40:   CALL ED50
  7672    23                            INC HL
  7673    3E 0A                         LD A,0AH
  7675    CD 76C1                       CALL ED50
                                ;       INC HL
  7678    18 F3                         JR ED33
                                        ;-------------
  767A    3E 20                 ED41:   LD A,20H                ; Zeichen loeschen
  767C    77                            LD (HL),A
  767D    3A 6B27                       LD A,(RAMT)
  7680    D6 01                         SUB 01H
  7682    38 E9                         JR C,ED33
  7684    32 6B27                       LD (RAMT),A
  7687    18 E4                         JR ED33
                                        ;-----------
  7689    CD 76C1               ED42:   CALL ED50
                                ;       INC HL
  768C    18 DF                         JR ED33
                                        ;------------
  768E    CD 76C1               ED43:   CALL ED50
        MACRO-80 3.43   27-Jul-81       PAGE    1-24


                                ;       INC HL
  7691    18 DA                         JR ED33
                                        ;-----------
  7693    E5                    ED44:   PUSH HL
  7694    C5                            PUSH BC
  7695    3A 6524                       LD A,(RADR)
  7698    FE 00                         CP 00H
  769A    28 21                         JR Z,ED442
  769C    3A 6B27                       LD A,(RAMT)
  769F    FE 00                         CP 00H
  76A1    28 1A                         JR Z,ED442
  76A3    01 0002                       LD BC,0002H
  76A6    7E                    ED441:  LD A,(HL)
  76A7    2B                            DEC HL
  76A8    77                            LD (HL),A
  76A9    23                            INC HL
  76AA    23                            INC HL
  76AB    10 F9                         DJNZ ED441
  76AD    0D                            DEC C
  76AE    20 F6                         JR NZ,ED441
  76B0    2A 6524                       LD HL,(RADR)
  76B3    35                            DEC (HL)
  76B4    2A 6B27                       LD HL,(RAMT)
  76B7    35                            DEC (HL)
  76B8    C1                            POP BC
  76B9    E1                            POP HL
  76BA    2B                            DEC HL
  76BB    18 B0                         JR ED33
                                        ;-----------
  76BD    C1                    ED442:  POP BC
  76BE    E1                            POP HL
  76BF    18 AC                         JR ED33
                                ;--------------------------
                                ; Zeichenzaehler vergleichen
                                ; RAM-Aktuell mit RAM-Text
  76C1    77                    ED50:   LD (HL),A
  76C2    3A 6B27                       LD A,(RAMT)
  76C5    3C                            INC A
  76C6    32 6B27                       LD (RAMT),A
  76C9    C9                            RET
                                        ;--------
  76CA    4F                            LD C,A
  76CB    E5                            PUSH HL
  76CC    2A 6524                       LD HL,(RADR)
  76CF    7E                            LD A,(HL)
  76D0    B9                            CP C
  76D1    D2 76D6                       JP NC,ED51              ; RAMT > RADR dann RADR+1
  76D4    3C                            INC A
  76D5    77                            LD (HL),A
  76D6    E1                    ED51:   POP HL
  76D7    C9                            RET
                                        ;-----------------------
                                        ; KEY Stepps Eingabe in HEX
                                        ; 
  76D8    E5                    EING11: PUSH HL
  76D9    2A 6524                       LD HL,(RADR)
        MACRO-80 3.43   27-Jul-81       PAGE    1-25


  76DC    3A 6B27                       LD A,(RAMT)
  76DF    77                            LD (HL),A
  76E0    21 821B                       LD HL,KEYZ
  76E3    06 1D                         LD B,KEYZX
  76E5    0E 02                         LD C,02H                ; BIOS Console Output
  76E7    CD 7FE5                       CALL BIOS
                                        ;------------------------
  76EA    E1                            POP HL
  76EB    C5                            PUSH BC
  76EC    4E                            LD C,(HL)               ; Speicher Lesen 
  76ED    C5                            PUSH BC
  76EE    CD 7817                       CALL HEX00
  76F1    C1                            POP BC
  76F2    C1                            POP BC
  76F3    E5                            PUSH HL
  76F4    CD 7ABF                       CALL TAS
  76F7    5F                            LD E,A
  76F8    CD 77B5                       CALL HEXI1
  76FB    D5                            PUSH DE
  76FC    CD 7ABF                       CALL TAS
  76FF    D1                            POP DE
  7700    5F                            LD E,A
  7701    CD 77C8                       CALL HEXI2
  7704    E1                            POP HL
                                ;       LD D,10H
  7705    72                            LD (HL),D
  7706    23                            INC HL
                                        ;-----------------
                                        ; Dateiaufruf
                                        ; Text ausgeben
                                        ;
  7707    E5                    EING21: PUSH HL
  7708    21 826E                       LD HL,PROZ
  770B    06 25                         LD B,PROZX
  770D    0E 02                         LD C,02H                ; BIOS Console Output
  770F    CD 7FE5                       CALL BIOS
                                        ;------------------------
  7712    06 0C                         LD      B,0CH           ; Dateinamenlaenge
  7714    0E 00                         LD      C,00H           ; loeschen
  7716    E1                            POP     HL
  7717    C5                    EING22: PUSH    BC
  7718    D5                            PUSH    DE
  7719    5E                            LD      E,(HL)          ; Speicher Lesen 
  771A    E5                            PUSH    HL
  771B    D5                            PUSH    DE
  771C    C5                            PUSH BC
  771D    4B                            LD C,E
  771E    C5                            PUSH BC
  771F    CD 7817                       CALL    HEX00           ; HEX Anzeigen
  7722    C1                            POP BC
  7723    C1                            POP BC
  7724    CD 7ABF                       CALL    TAS     ; ZEICHEN EINGABE
  7727    D1                            POP     DE
  7728    E1                            POP     HL
  7729    77                            LD      (HL),A          ; Tasteneingabee retten
  772A    D1                            POP     DE
        MACRO-80 3.43   27-Jul-81       PAGE    1-26


  772B    C1                            POP     BC
  772C    FE 2E                         CP      2EH             ; Dateineman Ende
  772E    20 02                         JR      NZ,EING23       ; -> noch nicht
  7730    06 04                         LD      B,04H           ; Zaehler aus Erweiterung set
  7732    3E 0C                 EING23: LD      A,0CH           ; Dateinamenlaenge
  7734    B8                            CP      B
  7735    20 1A                         JR      NZ,EING25       ; -> kein Anfang mehr
  7737    7E                            LD      A,(HL)          ; Tastein ASCII -> 0-9 unr.
  7738    D6 30                         SUB     30H
  773A    38 2E                         JR      C,EING26
  773C    FE 0A                         CP      0AH
  773E    38 02                         JR      C,EING24
  7740    D6 07                         SUB     07H
  7742    E6 0F                 EING24: AND     0FH
  7744    4F                            LD      C,A
  7745    77                            LD      (HL),A          ; Speichern
  7746    FE 00                         CP      00H
  7748    28 20                         JR      Z,EING26        ; Ende -> Ausgang
  774A    E5                            PUSH    HL
  774B    D1                            POP     DE              ; HL -> DE
  774C    13                            INC     DE
  774D    3E FF                         LD      A,0FFH
  774F    12                            LD      (DE),A
  7750    23                            INC     HL
  7751    23                    EING25: INC     HL
  7752    1A                            LD      A,(DE)
  7753    3C                            INC     A
  7754    12                            LD      (DE),A          ; Dateiname Zeichezaehler +1
  7755    10 C0                         DJNZ    EING22
  7757    47                            LD      B,A             ; naechste Dateiadresse berechnen
  7758    3E 0C                         LD      A,0CH
  775A    90                            SUB     B
  775B    16 00                         LD      D,00H
  775D    5F                            LD      E,A
  775E    19                            ADD     HL,DE
  775F    E5                            PUSH    HL
  7760    D1                            POP     DE
  7761    3E 00                         LD      A,00H
  7763    12                            LD      (DE),A
  7764    23                            INC     HL
  7765    06 0B                         LD      B,0BH
  7767    0D                            DEC     C
  7768    20 AD                         JR      NZ,EING22
  776A    06 0F                 EING26: LD      B,0FH
  776C    AF                    EING27: XOR     A
  776D    77                            LD      (HL),A
  776E    23                            INC     HL
  776F    10 FB                         DJNZ    EING27
  7771    C3 70AC                       JP BL00         ; PUSH POP ???
  7774    E1                    EING30: POP HL
  7775    D1                            POP DE
  7776    C1                            POP BC
  7777    C3 70AC                       JP BL00
                                ;-------------------------
                                ; TYPE2 MASKE AUFBAUEN
                                
        MACRO-80 3.43   27-Jul-81       PAGE    1-27


  777A    3A 6000               MAS00:  LD A,(RAM)
  777D    47                            LD B,A          ; ZEICHENL$NGE ZUM ANHAENGEN
                                        ; CURSOR AUF XXXXZEILE 1 SETZEN
  777E    3E 00                         LD A,00H
  7780    32 651C                       LD (CURT),A
  7783    3E 01                         LD A,01H
  7785    32 651D                       LD (CURT+1),A
                                        ;------------------
                                        ; CURSOR RECHTR SCHIEBEN
                                
  7788    3E 00                         LD A,00H
  778A    3C                    MAS01:  INC A
  778B    27                            DAA
  778C    10 FC                         DJNZ MAS01
  778E    47                            LD B,A
  778F    E6 0F                         AND 0FH
  7791    32 651F                       LD (CURT+3),A
  7794    78                            LD A,B
  7795    0F                            RRCA
  7796    0F                            RRCA
  7797    0F                            RRCA
  7798    0F                            RRCA
  7799    E6 0F                         AND 0FH
  779B    32 651E                       LD (CURT+2),A
  779E    CD 7854                       CALL CUT
  77A1    11 6B27                       LD DE,RAMT
  77A4    1A                            LD A,(DE)
  77A5    47                            LD B,A
  77A6    13                    MAS02:  INC DE
  77A7    1A                            LD A,(DE)
  77A8    CD 788B                       CALL HEXC
  77AB    10 F9                         DJNZ MAS02
  77AD    C9                            RET     
  77AE    C3 7536                       JP SU52
                                ;-------------------------
                                ; Programmaufruf mit Cursor up/down
                                
  77B1    00                    ZEI00:  NOP
  77B2    C3 726C                       JP      BL132
                                
                                ;-------------------------
                                ;   Hexunwandlung
                                
  77B5    7B                    HEXI1:  LD A,E          ; Eingabe Umwandeln
  77B6    D6 30                         SUB 30H
  77B8    38 1D                         JR C,HEXIE
  77BA    FE 0A                         CP 0AH
  77BC    38 02                         JR C,HEX11
  77BE    D6 07                         SUB 07H
  77C0    07                    HEX11:  RLCA
  77C1    07                            RLCA
  77C2    07                            RLCA
  77C3    07                            RLCA
  77C4    E6 F0                         AND 0F0H
  77C6    57                            LD D,A
  77C7    C9                            RET
        MACRO-80 3.43   27-Jul-81       PAGE    1-28


                                        ;-----------
  77C8    7B                    HEXI2:  LD A,E          ; Adresse anzeigen
  77C9    D6 30                         SUB 30H
  77CB    38 0A                         JR C,HEXIE
  77CD    FE 0A                         CP 0AH
  77CF    38 02                         JR C,HEX12
  77D1    D6 07                         SUB 07H
  77D3    E6 0F                 HEX12:  AND 0FH
                                        ;ADD A,D        ; ??
                                        ;LD D,A ; ??
  77D5    5F                            LD E,A
  77D6    C9                            RET
                                        ;--------
  77D7    06 01                 HEXIE:  LD B,01H
  77D9    C9                            RET
                                ;-------------------------
                                ;  HEX Ausgabe mit Position
                                ;
  77DA    3A 651C               HEXP:   LD A,(CURT)
  77DD    F5                            PUSH AF
  77DE    3A 651D                       LD A,(CURT+1)
  77E1    F5                            PUSH AF
  77E2    3A 651E                       LD A,(CURT+2)
  77E5    F5                            PUSH AF
  77E6    3A 651F                       LD A,(CURT+3)
  77E9    F5                            PUSH AF
  77EA    C5                            PUSH BC
  77EB    01 0150                       LD BC,0150H
  77EE    CD 7A8C                       CALL LIST
  77F1    4B                            LD C,E
  77F2    C5                            PUSH BC
  77F3    CD 7817                       CALL HEX00
  77F6    C1                            POP BC
  77F7    C1                            POP BC
  77F8    F1                            POP AF
  77F9    32 651F                       LD (CURT+3),A
  77FC    F1                            POP AF
  77FD    32 651E                       LD (CURT+2),A
  7800    F1                            POP AF
  7801    32 651D                       LD (CURT+1),A
  7804    F1                            POP AF
  7805    32 651C                       LD (CURT),A
  7808    CD 7854                       CALL CUT
  780B    C9                            RET
                                ;-------------------------
                                ;  Hex ausgeben
  780C    3E 0A                 HEXA:   LD A,0AH
  780E    CD 788B                       CALL HEXC
  7811    3E 0D                         LD A,0DH
  7813    CD 788B                       CALL HEXC
  7816    C9                            RET
                                ;------------------
  7817                          HEX00:  
  7817    DD E5                 HEX14:  PUSH IX
  7819    DD 21 0000                    LD IX,0
  781D    DD 39                         ADD IX,SP
        MACRO-80 3.43   27-Jul-81       PAGE    1-29


                                ;---------
  781F    DD 4E 04                      LD C,(IX+4)             ; Adresse anzeigen
  7822    C5                            PUSH BC
  7823    CD 7EC4                       CALL ASCII_CODE
  7826    C1                            POP BC
  7827    78                            LD A,B
  7828    CD 788B                       CALL HEXC
  782B    79                            LD A,C          ; ADRESSE ANZEIGEN
  782C    CD 788B                       CALL HEXC
                                ;-----------
  782F    DD F9                         LD SP,IX
  7831    DD E1                         POP IX
  7833    C9                            RET
                                ;------------------------
                                ; Warte schlange
                                
  7834    C5                    SANDU:  PUSH BC
  7835    D5                            PUSH DE
  7836    E5                            PUSH HL
  7837    3A 6520                       LD A,(SANDB)
  783A    FE 2F                         CP 2FH  
  783C    38 06                         JR C,SA1
  783E    28 08                         JR Z,SA2
  7840    3E 2D                         LD A,2DH
  7842    18 06                         JR SA3
  7844    3E 2F                 SA1:    LD A,2FH
  7846    18 02                         JR SA3
  7848    3E 5C                 SA2:    LD A,5CH
  784A    32 6520               SA3:    LD (SANDB),A
  784D    CD 788B                       CALL HEXC
  7850    E1                            POP HL
  7851    D1                            POP DE
  7852    C1                            POP BC
  7853    C9                            RET
                                ;------------------------
                                ; Cursor auf Position setzen
                                ;
  7854    F5                    CUT:    PUSH AF
  7855    3E 1B                         LD A,1BH
  7857    CD 788B                       CALL HEXC
  785A    3E 5B                         LD A,5BH
  785C    CD 788B                       CALL HEXC
  785F    3A 651C                       LD A,(CURT)
  7862    C6 30                         ADD A,30H
  7864    CD 788B                       CALL HEXC
  7867    3A 651D                       LD A,(CURT+1)
  786A    C6 30                         ADD A,30H
  786C    CD 788B                       CALL HEXC
  786F    3E 3B                         LD A,3BH
  7871    CD 788B                       CALL HEXC
  7874    3A 651E                       LD A,(CURT+2)
  7877    C6 30                         ADD A,30H
  7879    CD 788B                       CALL HEXC
  787C    3A 651F                       LD A,(CURT+3)
  787F    C6 30                         ADD A,30H
  7881    CD 788B                       CALL HEXC
        MACRO-80 3.43   27-Jul-81       PAGE    1-30


  7884    3E 48                         LD A,48H
  7886    CD 788B                       CALL HEXC
  7889    F1                            POP AF
  788A    C9                            RET
                                ;------------------------
                                ;  Zeichen Ausgeben
                                ;
  788B    C5                    HEXC:   PUSH BC
  788C    D5                            PUSH DE
  788D    E5                            PUSH HL
  788E    5F                            LD E,A
  788F    F5                            PUSH AF
  7890    0E 02                         LD C,02H
  7892    CD 0005                       CALL 0005H
  7895    F1                            POP AF
  7896    E1                            POP HL
  7897    D1                            POP DE
  7898    C1                            POP BC
  7899    C9                            RET
                                        ;--------------
                                        ; Cursor on
  789A    E5                    CON:    PUSH HL
  789B    C5                            PUSH BC
  789C    21 8039                       LD HL,CURON             ; CURSOR ON
  789F    06 06                         LD B,06H
  78A1    7E                    CUR02:  LD A,(HL)
  78A2    CD 788B                       CALL HEXC
  78A5    23                            INC HL
  78A6    10 F9                         DJNZ CUR02
  78A8    C1                            POP BC
  78A9    E1                            POP HL
  78AA    C9                            RET
                                        ;--------------
                                        ; Cursor off
  78AB    E5                    COFF:   PUSH HL
  78AC    C5                            PUSH BC
  78AD    21 803F                       LD HL,CUROFF            ; CURSOR OFF
  78B0    06 06                         LD B,06D
  78B2    7E                    CUR01:  LD A,(HL)
  78B3    CD 788B                       CALL HEXC
  78B6    23                            INC HL
  78B7    10 F9                         DJNZ CUR01
  78B9    C1                            POP BC
  78BA    E1                            POP HL
  78BB    C9                            RET
                                ;-----------------------
                                ;  DRIVE ZUGRIFF VORBEREITEN
  78BC    DB FF                 WAITRDY:IN A,(IDESTAT)
  78BE    CB 77                         BIT 6,A
  78C0    28 FA                         JR Z,WAITRDY
  78C2    CB 7F                         BIT 7,A
  78C4    20 F6                         JR NZ,WAITRDY
  78C6    C9                            RET
                                        ;----------
  78C7                          WAITDRQ: 
  78C7    DB FF                         IN A,(IDESTAT)
        MACRO-80 3.43   27-Jul-81       PAGE    1-31


  78C9    CB 5F                         BIT 3,A
  78CB    28 FA                         JR Z,WAITDRQ
  78CD    CB 7F                         BIT 7,A
  78CF    20 F6                         JR NZ,WAITDRQ
  78D1    C9                            RET
                                        ;----------
  78D2                          HDD_WAIT:
                                        ;LD B,0
                                        ;DJNZ $
  78D2    DB FF                 _WAIT1: IN A,(IDESTAT)
  78D4    E6 80                         AND 80H
  78D6    20 FA                         JR NZ,_WAIT1
  78D8    C9                            RET
                                        ;-------------
  78D9                          HDD_INIT:
  78D9    3E 02                         LD A,02H
  78DB    D3 FF                         OUT (IDECMD),A
  78DD    CD 78D2                       CALL HDD_WAIT
                                ;-----
  78E0    3E F0                         LD A,0F0H
  78E2    D3 FE                         OUT (IDESDH),A
  78E4    3E 01                         LD A,01H
  78E6    D3 FA                         OUT (IDESCNT),A
  78E8    3E EF                         LD A,0EFH
  78EA    D3 FF                         OUT (IDECMD),A
  78EC    CD 78D2                       CALL HDD_WAIT
  78EF    CD 78F3                       CALL HDD_ERROR
  78F2    C9                            RET
                                ;---------
  78F3                          HDD_ERROR:
  78F3    DB FF                         IN A,(IDESTAT)
  78F5    4F                            LD C,A
  78F6    C5                            PUSH BC
  78F7    CD 7817                       CALL HEX00
  78FA    C1                            POP BC
  78FB    79                            LD A,C
  78FC    E6 01                         AND 01H
  78FE    C8                            RET Z
  78FF    21 8293                       LD HL,DERR
  7902    06 26                         LD B,L_DERR
  7904    7E                    ERR1:   LD A,(HL)
  7905    CD 788B                       CALL HEXC
  7908    23                            INC HL
  7909    10 F9                         DJNZ ERR1
  790B    C9                            RET
                                ;--------------
  790C                          HDD_INFO:
  790C    CD 78D2                       CALL HDD_WAIT
  790F    3E EC                         LD A,0ECH
  7911    D3 FF                         OUT (IDECMD),A
  7913    21 1964                       LD HL,6500
  7916    CD 791A                       CALL HDD_READ
  7919    C9                            RET
                                ;-----------
  791A                          HDD_READ:
  791A    CD 78D2                       CALL HDD_WAIT
        MACRO-80 3.43   27-Jul-81       PAGE    1-32


  791D    DB FF                         IN A,(IDESTAT)
  791F    E6 08                         AND 08H
  7921    C8                            RET Z
  7922    DB F8                         IN A,(IDEDAT)
  7924    77                            LD (HL),A
                                ;       CALL HEXC;!!! TESTAUSGABEN
  7925    23                            INC HL
  7926    18 F2                         JR HDD_READ
                                ;-------------
                                ; IDE-FESTPLATTE RESET
  7928                          IDERES:
  7928    CD 792E                       CALL IDERES1
  792B    C3 78D2                       JP HDD_WAIT
                                        ;----------
  792E    CD 7F9C               IDERES1:CALL EXTERN
  7931    F5                            PUSH AF         ; PIOA
  7932    C5                            PUSH BC
  7933    3E 06                         LD A,06H
  7935    D3 F6                         OUT (IDEDOR),A
  7937    06 00                         LD B,0
  7939    10 FE                         DJNZ $
  793B    3E 02                         LD A,02H
  793D    D3 F6                         OUT (IDEDOR),A
  793F    C1                            POP BC
  7940    F1                            POP AF
  7941    D3 1C                         OUT (PIOA),A
  7943    C9                            RET 
                                ;-------------
  7944    DD E5                 DISK:   PUSH IX
  7946    DD 21 0000                    LD IX,0
  794A    DD 39                         ADD IX,SP
                                ;--------
  794C    DD 7E 05                      LD A,(IX+5)     ; D= HEAD SELECT, LBA HIGH MIT HIGH=B
  794F    E6 0F                         AND 0FH         ; HEAD SELECT
  7951    47                            LD B,A
  7952    3E F7                         LD A,SELDS      ; IN INCLUDE
  7954    E6 F0                         AND 0F0H
  7956    B0                            OR B
  7957    CB FF                         SET 7,A
  7959    DD 77 05                      LD (IX+5),A
  795C    D3 FE                         OUT (IDESDH),A
  795E    DD 7E 04                      LD A,(IX+4)     ; TRACK HIGH
  7961    D3 FD                         OUT (IDECHI),A
  7963    DD 7E 07                      LD A,(IX+7)     ; TRACK LOW
  7966    D3 FC                         OUT (IDECLO),A
  7968    DD 7E 06                      LD A,(IX+6)     ; C= SECTOR
  796B    D3 FB                         OUT (IDESNUM),A
  796D    3E 01                         LD A,01H
  796F    D3 FA                         OUT (IDESCNT),A
                                        ;----------
  7971    DD F9                         LD SP,IX
  7973    DD E1                         POP IX
  7975    C9                            RET
                                ;-----------------------
                                ; ZEICHEN SUCHEN IM RAM AUS EINGABE RAMT
                                ;
        MACRO-80 3.43   27-Jul-81       PAGE    1-33


  7976    08                    SUCH0:  EX AF,AF'               ; Textlaenge retten
  7977    1A                            LD A,(DE)               ; neuer Text mit
  7978    BE                            CP (HL)         ; Blaseninhalt 
  7979    28 0B                         JR Z,SUCH2
  797B    23                            INC HL
  797C    3A 6B27                       LD A,(RAMT)
  797F    11 6B28                       LD DE,RAMT+1
  7982    10 F2                         DJNZ SUCH0
  7984    37                    SUCH1:  SCF
  7985    C9                            RET
                                        ;------------
  7986    13                    SUCH2:  INC DE
  7987    23                            INC HL
  7988    3E 2A                         LD A,2AH
  798A    CD 788B                       CALL HEXC
  798D    08                            EX AF,AF'
  798E    3D                            DEC A
  798F    20 E5                         JR NZ,SUCH0
  7991    7E                            LD A,(HL)               ; Text Ende <30H
  7992    FE 2F                         CP 2FH          ; ENDE < 21H = !
  7994    30 EE                         JR NC,SUCH1     ; -> kein Ende
  7996    AF                            XOR A
  7997    C9                            RET     
                                ;-------------
  7998    C5                    FREI:   PUSH BC
  7999    0E 0B                         LD C,0BH        ; GET CONSILE STATUS
  799B    CD 0005                       CALL 0005H
  799E    C1                            POP BC
  799F    C9                            RET
                                ;-----------------------
                                ; CONSOLE QUERY AND PICK 
                                ; WITHOUT WAITING
                                ; 
  79A0    CD 7E6A               KEYST:  CALL UHR00
  79A3    C5                            PUSH BC
  79A4    0E 0B                         LD C,0BH        ; GET CONSILE STATUS
  79A6    CD 0005                       CALL 0005H
  79A9    FE 00                         CP 0
  79AB    28 05                         JR Z,KEY01
  79AD    0E 01                         LD C,01H        ; console Input read chr
  79AF    CD 0005                       CALL 0005H
  79B2    C1                    KEY01:  POP BC
  79B3    C9                            RET 
                                ;-----------------------
                                ; LBA Z[HLER HERH\HE BID HDDE ENDE
                                ;
  79B4    DD E5                 LBA0:   PUSH IX
  79B6    DD 21 0000                    LD IX,0
  79BA    DD 39                         ADD IX,SP
                                ;--------
  79BC    DD 4E 06                      LD C,(IX+6)     ; LBA LOW SECTOR
  79BF    DD 46 07                      LD B,(IX+7)
  79C2    0C                            INC C
  79C3    DD 71 06                      LD (IX+6),C
  79C6    20 35                         JR NZ,LBA20
  79C8    04                            INC B
        MACRO-80 3.43   27-Jul-81       PAGE    1-34


  79C9    DD 70 07                      LD (IX+7),B
  79CC    20 2F                         JR NZ,LBA20
  79CE    DD 4E 04                      LD C,(IX+4)     ; LBA TRACK 
  79D1    DD 46 05                      LD B,(IX+5)
  79D4    03                            INC BC
  79D5    DD 71 04                      LD (IX+4),C     ; LBA TRACK
  79D8    DD 70 05                      LD (IX+5),B
  79DB    AF                            XOR A           ; RES CARRY FLAG
  79DC    21 00BE                       LD HL,HDDE      ; DISK ENDE
  79DF    ED 42                         SBC HL,BC       ; -C
  79E1    30 1A                         JR NC,LBA20     
  79E3    01 0801                       LD BC,HDD+1
  79E6    DD 71 06                      LD (IX+6),C
  79E9    DD 70 07                      LD (IX+7),B
  79EC    01 0000                       LD BC,0
  79EF    DD 71 04                      LD (IX+4),C
  79F2    DD 70 05                      LD (IX+5),B
  79F5    C3 0000                       JP 0;!!!!
  79F8    18 03                         JR LBA20
                                        ; ENDE ERREICHT
  79FA    37                    LBA4:   SCF             ;AUSGANG FEHLER
  79FB    18 01                         JR LBA21
                                ;-----------
  79FD    AF                    LBA20:  XOR A           ; SET CARRY -> OHNE FEHLER
  79FE    DD F9                 LBA21:  LD SP,IX
  7A00    DD E1                         POP IX
  7A02    C9                            RET
                                ;-----------------
                                ; ADRESSE -1
  7A03    C3 0000               LBA5:   JP 0;!!!
  7A06    DD E5                 PUSH IX
  7A08    DD 21 0000                    LD IX,0
  7A0C    DD 39                         ADD IX,SP
                                ;------
  7A0E    DD 46 07                      LD B,(IX+7)     ; LBA 
  7A11    DD 4E 06                      LD C,(IX+6)     ; LOW
  7A14    0B                            DEC BC
  7A15    78                            LD A,B
  7A16    E6 F0                         AND 0F0H
  7A18    28 23                         JR Z,L__6
  7A1A    06 0F                         LD B,0FH
  7A1C    DD 70 07                      LD (IX+7),B     ; LBA 
  7A1F    DD 71 06                      LD (IX+6),C     ; LOW
  7A22    DD 46 05                      LD B,(IX+5)     ; LBA HIGH
  7A25    DD 4E 04                      LD C,(IX+4)     ; LOW
  7A28    0B                            DEC BC
  7A29    E5                            PUSH HL
  7A2A    AF                            XOR A
  7A2B    21 0800                       LD HL,HDD
  7A2E    ED 42                         SBC HL,BC
  7A30    E1                            POP HL
  7A31    38 02                         JR C,L__7
  7A33    18 C5                         JR LBA4
                                        ;-----------
  7A35    DD 70 05              L__7:   LD (IX+5),B
  7A38    DD 71 04                      LD (IX+4),C
        MACRO-80 3.43   27-Jul-81       PAGE    1-35


  7A3B    18 C0                         JR LBA20
                                        ;_-------
  7A3D    DD 70 07              L__6:   LD (IX+7),B     ; LBA HIGH
  7A40    DD 71 06                      LD (IX+6),C     ; LOW
  7A43    18 B8                         JR LBA20
                                
  7A45    DD 46 05                      LD B,(IX+5)     ; LBA HIGH
  7A48    DD 4E 04                      LD C,(IX+4)     ; LOW
  7A4B    0B                            DEC BC
  7A4C    DD 70 05                      LD (IX+5),B
  7A4F    DD 71 04                      LD (IX+4),C
  7A52    18 A9                         JR LBA20
                                        ; --------------------
                                        ; aktuelle Blasenadresse
                                ;------------------------
                                ; Cursor auf Position setzen
                                
  7A54    F5                    RLIST:  PUSH AF
  7A55    3A 6518                       LD A,(CURS)
  7A58    32 651C                       LD (CURT),A
  7A5B    3A 6519                       LD A,(CURS+1)
  7A5E    32 651D                       LD (CURT+1),A
  7A61    3A 651A                       LD A,(CURS+2)
  7A64    32 651E                       LD (CURT+2),A
  7A67    3A 651B                       LD A,(CURS+3)
  7A6A    32 651F                       LD (CURT+3),A
  7A6D    CD 7854                       CALL CUT
  7A70    F1                            POP AF
  7A71    C9                            RET
                                        ;------------
                                        ; CURSER POS SAVE
  7A72    F5                    WLIST:  PUSH AF
  7A73    3A 651C                       LD A,(CURT)
  7A76    32 6518                       LD (CURS),A
  7A79    3A 651D                       LD A,(CURT+1)
  7A7C    32 6519                       LD (CURS+1),A
  7A7F    3A 651E                       LD A,(CURT+2)
  7A82    32 651A                       LD (CURS+2),A
  7A85    3A 651F                       LD A,(CURT+3)
  7A88    32 651B                       LD (CURS+3),A
  7A8B    F1                            POP AF
                                        ;------------
  7A8C    F5                    LIST:   PUSH AF
  7A8D    78                            LD A,B
  7A8E    E6 F0                         AND 0F0H
  7A90    0F                            RRCA
  7A91    0F                            RRCA
  7A92    0F                            RRCA
  7A93    0F                            RRCA
  7A94    32 651C                       LD (CURT),A
  7A97    78                            LD A,B
  7A98    E6 0F                         AND 0FH
  7A9A    32 651D                       LD (CURT+1),a
  7A9D    79                            LD A,C
  7A9E    E6 F0                         AND 0F0H
  7AA0    0F                            RRCA
        MACRO-80 3.43   27-Jul-81       PAGE    1-36


  7AA1    0F                            RRCA
  7AA2    0F                            RRCA
  7AA3    0F                            RRCA
  7AA4    32 651E                       LD (CURT+2),A
  7AA7    79                            LD A,C
  7AA8    E6 0F                         AND 0FH
  7AAA    32 651F                       LD (CURT+3),A
  7AAD    CD 7854                       CALL CUT
  7AB0    F1                            POP AF
  7AB1    C9                            RET
                                        ;-------------
                                        ; ZUM TEST (HL)+1  30MAL AUSGEBEN
                                        ;
  7AB2    06 1E                 LIS0:   LD B,30D
  7AB4    7E                    LIS1:   LD A,(HL)
  7AB5    4F                            LD C,A
  7AB6    C5                            PUSH BC
  7AB7    CD 7817                       CALL HEX00
  7ABA    C1                            POP BC
  7ABB    23                            INC HL
  7ABC    10 F6                         DJNZ LIS1
  7ABE    C9                            RET
                                ;---------------------------
                                ;  Kontrollausgabe rechts
                                ;
  7ABF    CD 78AB               TAS:    CALL COFF
  7AC2    ED 73 651C                    LD (CURT),SP
  7AC6    C5                            PUSH BC
  7AC7    01 2273                       LD BC,2273H
  7ACA    CD 7A8C                       CALL LIST       ;CURSOR POS
  7ACD    C1                            POP BC
  7ACE    3A 650F                       LD A,(BFSHH)
  7AD1    4F                            LD C,A
  7AD2    C5                            PUSH BC
  7AD3    CD 7817                       CALL HEX00              ; ADRESSE DER AKTUEL GELESENEN BLASE
  7AD6    C1                            POP BC
  7AD7    3A 650E                       LD A,(BFSHL)
  7ADA    4F                            LD C,A
  7ADB    C5                            PUSH BC
  7ADC    CD 7817                       CALL HEX00
  7ADF    C1                            POP BC
  7AE0    3A 650D                       LD A,(BFSLH)
  7AE3    4F                            LD C,A
  7AE4    C5                            PUSH BC
  7AE5    CD 7817                       CALL HEX00
  7AE8    C1                            POP BC
  7AE9    3A 650C                       LD A,(BFSLL)
  7AEC    4F                            LD C,A
  7AED    C5                            PUSH BC
  7AEE    CD 7817                       CALL HEX00
  7AF1    C1                            POP BC
                                        ; --------------------
                                        ; aktuelle Blasenadresse
  7AF2    C5                            PUSH BC
  7AF3    01 2173                       LD BC,2173H
  7AF6    CD 7A8C                       CALL LIST       ;CURSOR POS
        MACRO-80 3.43   27-Jul-81       PAGE    1-37


  7AF9    C1                            POP BC
  7AFA    3A 801C                       LD A,(BF07+3) ;(BFRHH)
  7AFD    4F                            LD C,A
  7AFE    C5                            PUSH BC
  7AFF    CD 7817                       CALL HEX00
  7B02    C1                            POP BC
  7B03    3A 801B                       LD A,(BF07+2)  ;(BFRHL)
  7B06    4F                            LD C,A
  7B07    C5                            PUSH BC
  7B08    CD 7817                       CALL HEX00
  7B0B    C1                            POP BC
  7B0C    3A 801A                       LD A,(BF07+1)  ;(BFRLH)
  7B0F    4F                            LD C,A
  7B10    C5                            PUSH BC
  7B11    CD 7817                       CALL HEX00
  7B14    C1                            POP BC
  7B15    3A 8019                       LD A,(BF07) ;(BFRLL)
  7B18    4F                            LD C,A
  7B19    C5                            PUSH BC
  7B1A    CD 7817                       CALL HEX00
  7B1D    C1                            POP BC
                                        ;---------------------
                                        ; CURSOR IN EINGABEZEILE MIT EINGABE SCHIEBEN
  7B1E    3E 02                 TAS00:  LD A,02H
  7B20    32 651C                       LD (CURT),A
  7B23    3E 04                         LD A,04H
  7B25    32 651D                       LD (CURT+1),A
  7B28    3E 01                         LD A,01H
  7B2A    32 651E                       LD (CURT+2),A
  7B2D    3A 6B27                       LD A,(RAMT)
  7B30    FE 0A                         CP 0AH
  7B32    38 0E                         JR C,RD07       ; < 0AH ->
  7B34    D6 0A                         SUB 0AH
  7B36    32 651F                       LD (CURT+3),A
  7B39    3A 651E                       LD A,(CURT+2)
  7B3C    3C                            INC A
  7B3D    32 651E                       LD (CURT+2),A
  7B40    18 03                         JR RD08
  7B42    32 651F               RD07:   LD (CURT+3),A
  7B45    CD 7854               RD08:   CALL CUT
  7B48    06 14                         LD B,20D
  7B4A    21 6728                       LD HL,RAMS+RUSER
  7B4D    CD 7854               RD09:   CALL CUT
  7B50    CD 789A                       CALL CON
                                ;-----------------------
                                ; Tastenabfrage und Zeichen einlesen
                                ; Sonst weitere Task ausfueren
                                ;
                                ; LBA ZAEHLER +1
                                ;
  7B53    ED 5B 650C                    LD DE,(BFSLL)   ; Aktuelle Track/Sectoradresse laden
  7B57    ED 53 6C43                    LD (COP+4),DE   ; STARTPUNKT NACH SPEICHERN
  7B5B    D5                            PUSH DE
  7B5C    2A 650E                       LD HL,(BFSHL)
  7B5F    22 6C45                       LD (COP+6),HL
  7B62    E5                            PUSH HL
        MACRO-80 3.43   27-Jul-81       PAGE    1-38


  7B63    CD 79B4                       CALL LBA0       ; LBA + 1
  7B66    E1                            POP HL
  7B67    22 650E                       LD (BFSHL),HL   ; adresse HIGH speichern
  7B6A    D1                            POP DE
  7B6B    ED 53 650C                    LD (BFSLL),DE   ; adresse LOW speichern
  7B6F    DA 0000                       JP C,0 ;NOCH ENDE BEI FEHLER RD91               ; RUECKGABE CARRY 0=FEHLER
                                        ;---------------- 
                                        ; 1. BLASE + 1 = 2.BLASE
  7B72    D5                            PUSH DE         ; IX UEBERGABE
  7B73    E5                            PUSH HL         ; IX UEBERGEBE
  7B74    CD 79B4                       CALL LBA0       ; LBA + 1
  7B77    E1                            POP HL
  7B78    22 6512                       LD (BFSHL+4),HL ; adresse HIGH speichern
  7B7B    D1                            POP DE
  7B7C    ED 53 6510                    LD (BFSLL+4),DE ; adresse LOW speichern
  7B80    DA 0000                       JP C,0 ;NOCH ENDE BEI FEHLER RD91               ; RUECKGABE CARRY 0=FEHLER
  7B83    CD 7998                       CALL FREI       ; TAST INT FREI
                                        ;---------------------
                                        ; Erste Blase laden
  7B86    ED 4B 650C                    LD BC,(BFSLL)
  7B8A    ED 5B 650E                    LD DE,(BFSHL)
  7B8E    21 6727                       LD HL,RAMS
  7B91    CD 7DA2                       CALL RDREAD     ; BFSLL BLASE LADEN
  7B94    CD 7998                       CALL FREI
                                        ; READ SICHTBAR MACHEN
                                        ;LD BC,1001H
                                        ;CALL LIST
                                        ;LD HL,RAMS
                                        ;CALL LIS0
                                        ;------
  7B97    3A 672D                       LD A,(RAMS+RSOTR)
  7B9A    FE 1B                         CP 1BH
  7B9C    28 0E                         JR Z,TAS03
  7B9E    21 82B9                       LD HL,NBLASE
  7BA1    11 6727                       LD DE,RAMS
  7BA4    01 00AD                       LD BC,NBLLE
  7BA7    ED B0                         LDIR
                                        ; READ SICHTBAR MACHEN
                                        ;LD BC,1101H
                                        ;CALL LIST
                                        ;LD HL,RAMS
                                        ;CALL LIS0
  7BA9    C3 7C82                       JP RD170
                                        ;-------------------
                                        ; Zweite Blase laden
  7BAC    ED 4B 6510            TAS03:  LD BC,(BFSLL+4)
  7BB0    ED 5B 6512                    LD DE,(BFSHL+4)
  7BB4    21 6927                       LD HL,RAMS+200H
  7BB7    CD 7DA2                       CALL RDREAD     ; BFSLL BLASE LADEN
  7BBA    CD 7998                       CALL FREI
                                        ;------
                                        ; READ SICHTBAR MACHEN
                                        ;LD BC,1101H
                                        ;CALL LIST
                                        ;LD HL,RAMS+200H
                                        ;CALL LIS0
        MACRO-80 3.43   27-Jul-81       PAGE    1-39


                                ;------------------------------
                                ; Blasen der groesse nach Sortieren
                                ; USER, AUSFSTEIGEND
                                ; wenn U > U+1 dann tauschen
                                ; wenn U < U+1 dann Gedaechtniss -1
                                ; wsen der groesse nach Sortieren
                                ; USER, AUSFSTEIGEND
                                ; wenn U > U+1 dann tauschen
                                ; wenn U < U+1 dann Gedaechtniss -1
                                ; wenn U = U+1 dann weiter
                                ;
  7BBD    21 6928                       LD      HL,RAMS+RUSER+200H      ;BLASE2 RAM
  7BC0    11 6728                       LD      DE,RAMS+RUSER           ;BLASE1 RAM
  7BC3    1A                            LD      A,(DE)          ; USER vergleich
  7BC4    BE                            CP      (HL)            ; Blase2 > Blase1 dann
  7BC5    DA 7C34                       JP      C,RD06          ; zum naechstem >USER 2  neu anfangen
  7BC8    C2 7C98                       JP      NZ,RD01         ; Blase2 < Blase1 tauschen ->
                                ;----------------------
                                ; Blasen der groesse nach Sortieren
                                ; TYPE1, AUFSTEIGEND
                                ; wenn T1 > T1+1 (DE)-(HL) =NC,dann tauschen
                                ; wenn T1 = T1+1 (DE)-(HL) =Z,dann TYPE2 
                                ; wenn T1 < T1+1 (DE)-(HL) =NZ,dann GEDAECHTNIS
                                ;
  7BCB    21 6929                       LD      HL,RAMS+RTYPE1+200H     ; Blase2
  7BCE    11 6729                       LD      DE,RAMS+RTYPE1          ; Blase1
  7BD1    1A                            LD      A,(DE)                  ; TYPE1 Vergleich
  7BD2    BE                            CP      (HL)                    ; Blase2 > Blase1 dann
  7BD3    DA 7C34                       JP      C,RD06                  ; zum Gedaechtnis zuruecksetzen 
  7BD6    C2 7C98                       JP      NZ,RD01                 ; tauschen und Speichern 
                                ;       JP RD02 ;!!!!!TEST
                                ;----------------------
                                ; Blasen der groesse nach Sortieren
                                ; TYPE2 AUFSTEIGEND
                                ; wenn T2 > T2+1 (DE)-(HL) =NC,dann tauschen
                                ; wenn T2 = T2+1 (DE)-(HL) = Z,dann gedaechtniss-1
                                ; wenn T2 < T2+1 (DE)-(HL) =NZ,dann weiter
                                ;
  7BD9    21 692A               RD25:   LD HL,RAMS+RTYPE2+200H  ; Blase2
  7BDC    11 672A                       LD DE,RAMS+RTYPE2       ; Blase1
  7BDF    1A                            LD A,(DE)
  7BE0    FE 01                         CP 01H                  ; RAM+TYPE2 > 0
  7BE2    20 09                         JR NZ,RD255             ; TYPE2 BEREITS 1=FORNE JA ->
  7BE4    BE                            CP (HL)
                                ;??     CALL C,TASK     ; NOCH AUSARBEITEN
  7BE5    3A 692C                       LD A,(RAMS+RBSTAT+200H)
  7BE8    E6 07                         AND 07H
  7BEA    CA 7C98                       JP Z,RD01               ; BLASE 2 SPEICHERN MIT TAUSCHEN
  7BED    1A                    RD255:  LD A,(DE)
  7BEE    BE                            CP (HL)                 ; Blase2 > Blase1 dann
  7BEF    38 06                         JR C,RD26
  7BF1    CA 7C17                       JP Z,RD36               ; ZUM GEDAECHTNIS
  7BF4    D2 7C98                       JP NC,RD01              ; TAUSCHEN
                                        ;----------------------
  7BF7    1A                    RD26:   LD A,(DE)               ; BLASE1 TYPE2 Vergleich
  7BF8    FE 00                         CP 0H
        MACRO-80 3.43   27-Jul-81       PAGE    1-40


  7BFA    C2 7C34                       JP NZ,RD06              ; zum Gedaechtnisszaehler
                                        ;----------------------
                                        ; GED[CHTNISS BLASE1 TYPE2=0 MIT BLASE2 TYPE2>0 VERGLEICHEN
                                         
  7BFD    21 672B                       LD HL,RAMS+RTERM                ; Blase1
  7C00    11 692B                       LD DE,RAMS+RTERM+200H   ; Blase2
  7C03    1A                            LD A,(DE)                       ; Gedaechtnissz Vergleich
  7C04    BE                            CP (HL)
  7C05    38 2D                         JR C,RD06                       ; 1>2 GEDAECHTNISS FALLEND
  7C07    3C                            INC A
  7C08    20 01                         JR NZ,RD250
  7C0A    1A                            LD A,(DE)
  7C0B    77                    RD250:  LD (HL),A
  7C0C    ED 4B 650C                    LD BC,(BFSLL)
  7C10    ED 5B 650E                    LD DE,(BFSHL)           ; Suchadresse 2. BLASE speichern
  7C14    C3 7D05                       JP RD03
                                        ;----------------------
                                        ; Blasen der groesse nach Sortieren
                                        ; GEDAECHTNIS FALLEND
  7C17    7E                    RD36:   LD A,(HL)
  7C18    FE 00                         CP 0
  7C1A    20 0D                         JR NZ,RD35
  7C1C    3A 672C                       LD A,(RAMS+RBSTAT)
  7C1F    E6 78                         AND 78H
  7C21    F6 47                         OR 47H
  7C23    32 672C                       LD (RAMS+RBSTAT),A
  7C26    C3 7BF7                       JP RD26 
                                        ;---------------------
  7C29    21 692B               RD35:   LD HL,RAMS+RTERM+200H   ; Blase2
  7C2C    11 672B                       LD DE,RAMS+RTERM        ; Blase1
  7C2F    1A                            LD A,(DE)               ; Gedaechtnissz Vergleich
  7C30    BE                            CP (HL)
  7C31    DA 7C98                       JP C,RD01               ; tauschen und Speichern fallend
                                        ;---------------------
                                        ; Gedaechtniss zuruecksetzen wenn MONAT ungleich ist
                                
  7C34    CD 7998               RD06:   CALL FREI
  7C37    3A 8026                       LD A,(DAYM)             ; MONAT AUS UHR
  7C3A    E6 1F                         AND 1FH
  7C3C    47                            LD B,A
  7C3D    3A 672C                       LD A,(RAMS+RBSTAT)      ; MONAT AUS BLASE1
  7C40    E6 1F                         AND 1FH
  7C42    B8                            CP B
  7C43    C2 7C50                       JP NZ,RDD1              ; NICHT GLEICH ->
  7C46    3A 672C                       LD A,(RAMS+RBSTAT)      ; MONAT AUS BLASE1
  7C49    CB 77                         BIT 6,A                 ; PRUEFE SORTIEREN 
  7C4B    20 03                         JR NZ,RDD1              ; SPEICHERN ->
  7C4D    C3 7D54                       JP RD02                 ; GLEICH nicht speichern gleicher MONAT
                                        ;------------------
                                        ; NEUER MONAT UND GEDAECHTNIS SPEICHERN
  7C50    3A 672C               RDD1:   LD A,(RAMS+RBSTAT)      ; BLASE 1
  7C53    E6 E0                         AND 0E0H
  7C55    B0                            OR B            ; neuer MONAT einbinden 
  7C56    CB B7                         RES 6,A         ; Zaehler aktivieren
  7C58    CB 7F                         BIT 7,A         ; Blase benutzt fuer +/-
  7C5A    28 11                         JR Z,RD16       ; Gedaechtniss abziehen =0
        MACRO-80 3.43   27-Jul-81       PAGE    1-41


  7C5C    CB BF                         RES 7,A         ; =1 ADDIEREN loesche
  7C5E    32 672C                       LD (RAMS+RBSTAT),A      ; wieder zurueck in Blase1
  7C61    3A 672B                       LD A,(RAMS+RTERM)       ; GEDAECHTNISSZAEHLER AUS RAM
  7C64    3C                            INC A                   ; Gedaechtniss +1
  7C65    CA 7C82                       JP Z,RD170              ; Ausgang WENN MAX ERREICHT
  7C68    32 672B                       LD (RAMS+RTERM),A       ; ZURUECK IN RAM
  7C6B    18 0D                         JR RD17
                                        ;--------------
  7C6D    32 672C               RD16:   LD (RAMS+RBSTAT),A      ; MONAT SPEICHERN
  7C70    3A 672B                       LD A,(RAMS+RTERM)
  7C73    D6 01                         SUB 01H                 ; Gedaechtniss schon Min
  7C75    38 16                         JR C,RD171              ; Ausgang WENN MIN ERREICHT
  7C77    32 672B                       LD (RAMS+RTERM),A       ; ZURUECK IN RAM
  7C7A    3A 6205               RD17:   LD A,(BSTAT)
  7C7D    CB B7                         RES 6,A                 ; Sortieren aktivieren aller Blasen
  7C7F    32 6205                       LD (BSTAT),A
  7C82    ED 5B 650E            RD170:  LD DE,(BFSHL)           ; Suchadresse speichern
  7C86    ED 4B 650C                    LD BC,(BFSLL)
  7C8A    C3 7D05                       JP RD03                 ; nur Blase1 ohne tauschen speicher
                                        ;------------------
  7C8D    3A 6728               RD171:  LD A,(RAMS+RUSER)
  7C90    3C                            INC A
  7C91    28 EF                         JR Z,RD170
  7C93    32 6728                       LD (RAMS+RUSER),A       ; User =FFH damit Blase wieder an Schluss wandert
  7C96    18 EA                         JR RD170
                                        ;-----------------------
                                        ; Zweite Blase mit Erster Blase beim Speichern tauschen
  7C98    ED 4B 650C            RD01:   LD BC,(BFSLL)
  7C9C    ED 5B 650E                    LD DE,(BFSHL)   ; Suchadresse 1.Blase speichern
  7CA0    21 6927                       LD HL,RAMS+200H         ; MIT WERT AUS 2.BLASE SPEICHERN
  7CA3    CD 7DCB                       CALL RDWRITE
                                        ;------
                                        ; WRITE SICHTBAR MACHEN
                                        ;LD BC,1401H
                                        ;CALL LIST
                                        ;LD HL,RAMS+200H
                                        ;CALL LIS0
                                        ;--------
  7CA6    3A 6205                       LD A,(BSTAT)
  7CA9    CB B7                         RES 6,A         ; SORTIEREN START
  7CAB    32 6205                       LD (BSTAT),A
                                        ;-------------------
                                        ; pruefe ob AKTUELLE ZAEHLER ALS 1. Blase offen ist
  7CAE    AF                            XOR A           ; RES CARRY FLAG
  7CAF    ED 5B 650E                    LD DE,(BFSHL)   ; ADRESSE HIGH
  7CB3    2A 6502                       LD HL,(BFRHL)   ; AKTUELL SICHTBARE BLASE
  7CB6    ED 52                         SBC HL,DE       ;-C
  7CB8    20 1D                         JR NZ,TAS22     ; BLASE H SORTIEREN UND OFFEN NICHT GLEICH ->
  7CBA    AF                            XOR A           ; RES CARRY FAG
  7CBB    ED 5B 650C                    LD DE,(BFSLL)   ; ADRESSE LOW
  7CBF    2A 6500                       LD HL,(BFRLL)
  7CC2    ED 52                         SBC HL,DE       ;-C
  7CC4    20 11                         JR NZ,TAS22
                                        ;-------------------
                                        ; DANN ADRESSE AKTUELLER BLASE AUCH TAUSCHEN
                                        ; SICHTBARE BLASE VERSCHIEBEN
        MACRO-80 3.43   27-Jul-81       PAGE    1-42


  7CC6    ED 5B 6510                    LD DE,(BFSLL+4)
  7CCA    2A 6512                       LD HL,(BFSHL+4)
  7CCD    22 6502                       LD (BFRHL),HL
  7CD0    ED 53 6500                    LD (BFRLL),DE
  7CD4    C3 7CFD                       JP TAS24
                                        ;-------------------
                                        ; pruefe ob AKTUELLE ZAEHLER ALS 1. Blase offen ist
  7CD7    AF                    TAS22:  XOR A           ; RES CARRY FLAG
  7CD8    ED 5B 6512                    LD DE,(BFSHL+4) ; Aktuelle Track/Sectoradresse laden
  7CDC    2A 6502                       LD HL,(BFRHL)
  7CDF    ED 52                         SBC HL,DE       ; -C
  7CE1    20 1A                         JR NZ,TAS24     ; BLASE H SORTIEREN UND OFFEN NICHT GLEICH ->
  7CE3    AF                            XOR A           ; RES CARRY FLAG
  7CE4    ED 5B 6510                    LD DE,(BFSLL+4) ; Aktuelle Track/Sectoradresse laden
  7CE8    2A 6500                       LD HL,(BFRLL)
  7CEB    ED 52                         SBC HL,DE       ; -C
  7CED    20 0E                         JR NZ,TAS24
                                        ;-----------------
                                        ; AKTUELLE BLASE TAUSCHEN H->L
  7CEF    ED 5B 650C                    LD DE,(BFSLL)
  7CF3    2A 650E                       LD HL,(BFSHL)
  7CF6    ED 53 6500                    LD (BFRLL),DE
  7CFA    22 6502                       LD (BFRHL),HL
                                        ;-----------------------
                                        ; Erste Blase mit zweiter Blase beim Speichern tauschen
  7CFD    ED 4B 6510            TAS24:  LD BC,(BFSLL+4)
  7D01    ED 5B 6512                    LD DE,(BFSHL+4) ; Suchadresse 2. BLASE speichern
  7D05    21 6727               RD03:   LD HL,RAMS
  7D08    CD 7DCB                       CALL RDWRITE
                                        ;------
                                        ; WRITE SICHTBAR MACHEN
                                        ;LD BC,1601H
                                        ;CALL LIST
                                        ;LD HL,RAMS+200H
                                        ;CALL LIS0
                                        ;--------
  7D0B    3A 6205                       LD A,(BSTAT)
  7D0E    CB 77                         BIT 6,A
  7D10    20 42                         JR NZ,RD02
  7D12    CB F7                         SET 6,A         ; STOP/START
  7D14    32 6205                       LD (BSTAT),A
                                        ;----------------------
                                        ; nach letztem Blase speichern Sortieradresse > letzter Blase Adr. 
                                        ; dann neu Adr. speichern und bei HDD-neu Anfangsadr. beginnen
  7D17    AF                            XOR A           ; RES CARRY FLAG
  7D18    2A 801B                       LD HL,(BF07+2)
  7D1B    ED 5B 650E                    LD DE,(BFSHL)   ; LETZTE Suchadresse speichern
  7D1F    ED 52                         SBC HL,DE       ; -C
  7D21    30 17                         JR NC,RD30
  7D23    ED 53 801B                    LD (BF07+2),DE  ; SPEICHE WENN HL<DE
  7D27    ED 4B 650C                    LD BC,(BFSLL)
  7D2B    ED 43 8019                    LD (BF07),BC
  7D2F    ED 5B 650C                    LD DE,(BFSLL)
  7D33    ED 4B 650E                    LD BC,(BFSHL)
  7D37    C3 7D68                       JP RD90 
                                        ;---------------
        MACRO-80 3.43   27-Jul-81       PAGE    1-43


  7D3A    ED 5B 650C            RD30:   LD DE,(BFSLL)
  7D3E    ED 4B 650E                    LD BC,(BFSHL)
  7D42    C2 7D95                       JP NZ,RD92
  7D45    AF                            XOR A           ; RES CARRY FLAG
  7D46    2A 8019                       LD HL,(BF07)
  7D49    ED 52                         SBC HL,DE       ; -C
  7D4B    30 07                         JR NC,RD02
  7D4D    ED 53 8019                    LD (BF07),DE
  7D51    C3 7D68                       JP RD90         ; NACH sPEICHERN BLASE VON NULL NEUSTART
                                ;-----------
  7D54                          RD02:   ;------
                                        ; READ SICHTBAR MACHEN
                                        ;LD BC,0501H
                                        ;CALL LIST
                                        ;LD HL,RAMS
                                        ;CALL LIS0
  7D54    CD 7998                       CALL FREI
  7D57    ED 5B 650E                    LD DE,(BFSHL)           ; LETZTE SUCHADRESSE SPEICHERN
                                        ; LD (BF07+4),DE
  7D5B    ED 4B 650C                    LD BC,(BFSLL)
                                        ; LD (BF07+6),BC
                                        ;ACHTUNG SECTOR 8/16 LD (BF07),BC
                                        ;---------------------
                                        ; Tastenabfrage und Zeichen einlesen
  7D5F    CD 79A0                       CALL KEYST
  7D62    FE 00                         CP 0H
  7D64    CA 7ABF                       JP Z,TAS        ;TAS00
  7D67    C9                            RET                     ; RETURN ZU BL ENDE
                                
                                ;---------------------
                                ; RD90 AUSGABE UEBERSPRINGEN
                                ; SUCHADRESSE
                                ;
  7D68    E5                    RD90:   PUSH HL
  7D69    D5                            PUSH DE
  7D6A    C5                            PUSH BC
  7D6B    ED 5B 650C                    LD DE,(BFSLL)
  7D6F    ED 4B 650E                    LD BC,(BFSHL)
  7D73    CB 38                         SRL B
  7D75    CB 19                         RR C
  7D77    CB 1A                         RR D
  7D79    CB 1B                         RR E
  7D7B    AF                            XOR A           ; RES CARRY FLAG
  7D7C    21 0000                       LD HL,0000H
  7D7F    ED 42                         SBC HL,BC       ; -C HIGH
  7D81    20 12                         JR NZ,RD92      ; BC >0 ->
  7D83    21 0800                       LD HL,HDD
  7D86    ED 52                         SBC HL,DE
  7D88    30 05                         JR NC,RD911
  7D8A    18 09                         JR RD92
                                ;----------------------
                                ; RESET TO HDD START
                                ; 
  7D8C    E5                    RD91:   PUSH HL
  7D8D    D5                            PUSH DE
  7D8E    C5                            PUSH BC
        MACRO-80 3.43   27-Jul-81       PAGE    1-44


  7D8F    11 0801               RD911:  LD DE,HDD+1
  7D92    01 0000                       LD BC,0
  7D95    ED 53 650C            RD92:   LD (BFSLL),DE
  7D99    ED 43 650E                    LD (BFSHL),BC
  7D9D    C1                            POP BC
  7D9E    D1                            POP DE
  7D9F    E1                            POP HL
  7DA0    18 B2                         JR RD02
                                ;------------------------
                                ; READ SECTOR VON HDD
                                ;
  7DA2    DD E5                 RDREAD: PUSH IX
  7DA4    DD 21 0000                    LD IX,0
  7DA8    DD 39                         ADD IX,SP
                                        ;----------------
  7DAA    CD 7F9C                       CALL EXTERN
  7DAD    F5                            PUSH AF         ; PIOA RESCUE
                                        ;----------------
  7DAE    E5                            PUSH HL         ; DMA
  7DAF    C5                            PUSH BC         ; DISK SEL
  7DB0    D5                            PUSH DE         ; DISK SEL
  7DB1    CD 7944                       CALL DISK
  7DB4    D1                            POP DE
  7DB5    3E 20                         LD A,CMD_READSEC
  7DB7    D3 FF                         OUT (IDECMD),A
  7DB9    7A                            LD A,D
  7DBA    D3 FE                         OUT (IDESDH),A
  7DBC    CD 78C7                       CALL WAITDRQ
  7DBF    C1                            POP BC
  7DC0    E1                            POP HL
  7DC1    06 00                         LD B,00H
  7DC3    0E F8                         LD C,IDEDAT
  7DC5    ED B2                         INIR
  7DC7    ED B2                         INIR
  7DC9    18 24                         JR HDIST
                                ;----------------------
                                ; BLASE TO SAVE DE=HIGH, BC=LOW
                                ;
  7DCB                          RDWRITE:
  7DCB    DD E5                         PUSH IX
  7DCD    DD 21 0000                    LD IX,0
  7DD1    DD 39                         ADD IX,SP
                                        ;----------------
  7DD3    CD 7F9C                       CALL EXTERN
  7DD6    F5                            PUSH AF         ; PIOA RESCUE
                                        ;----------------
  7DD7    E5                            PUSH HL         ; DMA
  7DD8    C5                            PUSH BC         ; DISK SEL
  7DD9    D5                            PUSH DE         ; DISK SEL
  7DDA    CD 7944                       CALL DISK
  7DDD    D1                            POP DE
  7DDE    C1                            POP BC
  7DDF    3E 30                         LD A,CMD_WRITESEC
  7DE1    D3 FF                         OUT (IDECMD),A
  7DE3    CD 78C7                       CALL WAITDRQ
  7DE6    E1                            POP HL          ; DMA ZURUECK
        MACRO-80 3.43   27-Jul-81       PAGE    1-45


  7DE7    06 00                         LD B,00H
  7DE9    0E F8                         LD C,IDEDAT
  7DEB    ED B3                         OTIR
  7DED    ED B3                         OTIR
                                        ;----------------
  7DEF    F1                    HDIST:  POP AF
  7DF0    D3 1C                         OUT (PIOA),A    ; PIOA BACK UP
  7DF2    DD F9                         LD SP,IX
  7DF4    DD E1                         POP IX
  7DF6    C9                            RET
                                ;---------------------
                                ; TASK zum Programm Starten
                                ; auf Adr. 100H
                                
  7DF7                          TASK:   ;PUSH   AF
  7DF7    C5                            PUSH    BC
  7DF8    D5                            PUSH    DE
  7DF9    E5                            PUSH    HL
  7DFA    3A 6928                       LD      A,(RAMS+RUSER+200H)
  7DFD    FE FF                         CP      0FFH
  7DFF    30 41                         JR      NC,TASK99       ; USER = FFH nicht auswerten
  7E01    7E                            LD      A,(HL)          ; TYPE2 Blase2 vergleichen
  7E02    FE 02                         CP      02H
  7E04    38 3C                         JR      C,TASK99
  7E06    3A 6003                       LD      A,(RAM+RTYPE2)
  7E09    FE 02                         CP      02H
  7E0B    30 35                         JR      NC,TASK99       ; WENN IN RAM >1 EXTERNE TASK EINGABE
                                        ;----------------------
                                        ; EXTERN BEARBEITEN
                                
  7E0D    11 0080                       LD      DE,BUFF
  7E10    21 81C8                       LD      HL,PRLO1
  7E13    7E                            LD      A,(HL)
  7E14    12                            LD      (DE),A
  7E15    13                            INC     DE
  7E16    47                            LD      B,A
  7E17    CD 727F                       CALL    BL13
                                ;ERROR ??
                                ; CALL  E.TEXT
                                ; JR    NC,TASK99
                                
  7E1A    CD 0100                       CALL    0100H
  7E1D    FE 00                         CP      0
  7E1F    20 21                         JR      NZ,TASK99
  7E21    ED 4B 6510                    LD BC,(BFSLL+4)
  7E25    C5                            PUSH BC
  7E26    ED 5B 6512                    LD DE,(BFSHL+4) ; Suchadresse 2. BLASE speichern
  7E2A    D5                            PUSH DE
  7E2B    CD 7944                       CALL DISK
  7E2E    D1                            POP DE
  7E2F    C1                            POP BC
  7E30    38 10                         JR      C,TASK99
  7E32    01 6927                       LD      BC,RAMS+200H            ; MIT WERT AUS 1. BLASE
  7E35    CD F82F                       CALL    SETDMA
  7E38    CD 7F9C                       CALL EXTERN
  7E3B    F5                            PUSH AF
        MACRO-80 3.43   27-Jul-81       PAGE    1-46


  7E3C    CD F817                       CALL WRITE
  7E3F    F1                            POP AF
  7E40    D3 1C                         OUT (PIOA),A
                                
                                        ;----------------
  7E42    E1                    TASK99: POP     HL
  7E43    D1                            POP     DE
  7E44    C1                            POP     BC
                                        ;POP    AF
  7E45    C9                            RET
                                        ;-----------------------
                                        ; Blase Speichern  aus RAMS in 
                                        ; BC = LL- LH , DE = HL-HH Adresse LBA
  7E46    C5                    TWRITE: PUSH BC
  7E47    D5                            PUSH DE
  7E48    CD 7944                       CALL DISK
  7E4B    D1                            POP DE
  7E4C    C1                            POP BC
  7E4D    D8                            RET C
  7E4E    01 6727                       LD BC,RAMS              ; MIT WERT AUS 2. BLASE
  7E51    CD F82F                       CALL SETDMA
  7E54    CD 7F9C                       CALL EXTERN
  7E57    F5                            PUSH AF
  7E58    CD F817                       CALL WRITE
  7E5B    F1                            POP AF
  7E5C    D3 1C                         OUT (PIOA),A
  7E5E    AF                            XOR     A
  7E5F    C9                            RET
                                ;---------------
                                ; INTERRUPT FUER TASK PRUEFEN
                                ;INT:   EI
  7E60    00                            NOP
  7E61    00                            NOP
  7E62    00                            NOP
  7E63    00                            NOP
  7E64    00                            NOP
  7E65    00                            NOP
  7E66    00                            NOP
  7E67    00                            NOP
  7E68    F3                            DI
  7E69    C9                            RET
                                
                                ;-----------------------
                                ;  Uhr auslesen
                                
  7E6A    C5                    UHR00:  PUSH BC
  7E6B    CD 7F95                       CALL INTERN
  7E6E    F5                            PUSH AF
  7E6F    DB 1E                         IN A,(PIOB)
  7E71    F5                            PUSH AF
  7E72    3E 3F                         LD A,3FH                ; Adresse fuer Uhr
  7E74    D3 1E                         OUT (PIOB),A
                                        ;-----------------
                                        ; Minuten in Dezimal
                                        ;
  7E76    3E 40                         LD A,040H               ; Lesen Ein
        MACRO-80 3.43   27-Jul-81       PAGE    1-47


  7E78    D3 98                         OUT (URCS+18H),A
  7E7A    DB 9A                         IN A,(URCS+1AH) ; Minuten
  7E7C    4F                            LD C,A
                                ;       XOR A
                                ;       OUT (URCS+18H),A        ; R/W Aus
  7E7D    C5                            PUSH BC
  7E7E    CD 7EC4                       CALL ASCII_CODE
  7E81    C1                            POP BC
  7E82    78                            LD A,B
  7E83    32 802A                       LD (DAYZ+2),A           ; ZEHNER
  7E86    3A 802B                       LD A,(DAYZ+3)
  7E89    B9                            CP C
  7E8A    28 2B                         JR Z,UHR01              ; ZEITAENERUNG NEIN ->
  7E8C    79                            LD A,C
  7E8D    32 802B                       LD (DAYZ+3),A
                                        ;-----------------------
                                        ;       Stunde
                                        ;
                                ;       LD A,040H               ; Lesen Ein
                                ;       OUT (URCS+18H),A
  7E90    00                            NOP
  7E91    DB 9B                         IN A,(URCS+1BH) ; Stunde
  7E93    4F                            LD C,A
  7E94    AF                            XOR A
  7E95    D3 98                         OUT (URCS+18H),A        ; R/W Aus
  7E97    C5                            PUSH BC
  7E98    CD 7EC4                       CALL ASCII_CODE
  7E9B    C1                            POP BC
  7E9C    78                            LD A,B
  7E9D    32 8028                       LD (DAYZ),A
  7EA0    79                            LD A,C
  7EA1    32 8029                       LD (DAYZ+1),A
                                        ;-----------------
                                        ; DAY auslesen
                                        ;
                                ;       LD A,040H               ; Lesen Ein
                                ;       OUT (URCS+18H),A
  7EA4    00                            NOP
  7EA5    DB 9D                         IN A,(URCS+1DH) ; Tag
  7EA7    47                            LD B,A
                                ;       XOR A
                                ;       OUT (URCS+18H),A        ; Lesen Aus
  7EA8    78                            LD A,B
  7EA9    32 8027                       LD (DAYT),A
                                        ;-----------------
                                        ; Monat auslesen
                                        ;
                                ;       LD A,040H               ; Lesen Ein
                                ;       OUT (URCS+18H),A
  7EAC    00                            NOP
  7EAD    DB 9E                         IN A,(URCS+1EH) ; Tag
  7EAF    47                            LD B,A
                                ;       XOR A
                                ;       OUT (URCS+18H),A        ; Lesen Aus
  7EB0    78                            LD A,B
  7EB1    32 8026                       LD (DAYM),A
        MACRO-80 3.43   27-Jul-81       PAGE    1-48


                                        ;------------------
                                        ; Zeit ausgeben
                                        ;
  7EB4    CD 7EF5                       CALL    UHR10
  7EB7    AF                    UHR01:  XOR A
  7EB8    D3 98                         OUT (URCS+18H),A        ; Lesen Aus
  7EBA    F1                            POP AF
  7EBB    E6 F0                         AND 0F0H
  7EBD    D3 1E                         OUT (PIOB),A
  7EBF    F1                            POP AF
  7EC0    D3 1C                         OUT (PIOA),A
  7EC2    C1                            POP BC
  7EC3    C9                            RET
                                ;---------
  7EC4                          ASCII_CODE:
  7EC4    DD E5                         PUSH IX
  7EC6    DD 21 0000                    LD IX,0
  7ECA    DD 39                         ADD IX,SP
                                        ;------
  7ECC    DD 7E 04                      LD A,(IX+4)     ;B=HIGH
  7ECF    0F                            RRCA
  7ED0    0F                            RRCA
  7ED1    0F                            RRCA
  7ED2    0F                            RRCA
  7ED3    E6 0F                         AND 0FH
  7ED5    C6 30                         ADD A,30H
  7ED7    FE 3A                         CP 3AH
  7ED9    38 02                         JR C,ASC_1
  7EDB    C6 07                         ADD A,07H
  7EDD    DD 77 05              ASC_1:  LD (IX+5),A
  7EE0    DD 7E 04                      LD A,(IX+4)     ; C=LOW
  7EE3    E6 0F                         AND 0FH
  7EE5    C6 30                         ADD A,30H
  7EE7    FE 3A                         CP 3AH
  7EE9    38 02                         JR C,ASC_2
  7EEB    C6 07                         ADD A,07H
  7EED    DD 77 04              ASC_2:  LD (IX+4),A
                                        ;---------
  7EF0    DD F9                         LD SP,IX
  7EF2    DD E1                         POP IX
  7EF4    C9                            RET             ; RETURN =BC
                                ;-----------------------
                                ;   Uhr anzeigen
                                ;
  7EF5    CD 78AB               UHR10:  CALL COFF       ; CURSOR AUS
                                        ;---------------
                                        ; Zeile/Spalte
  7EF8    C5                            PUSH BC
  7EF9    01 0075                       LD BC,0075H
  7EFC    CD 7A72                       CALL WLIST      ; CURSOR POS
  7EFF    C1                            POP BC
  7F00    3A 8028                       LD A,(DAYZ)
  7F03    CD 788B                       CALL HEXC
  7F06    3A 8029                       LD A,(DAYZ+1)
  7F09    CD 788B                       CALL HEXC
  7F0C    3E 3A                         LD A,3AH
        MACRO-80 3.43   27-Jul-81       PAGE    1-49


  7F0E    CD 788B                       CALL HEXC
  7F11    3A 802A                       LD A,(DAYZ+2)
  7F14    CD 788B                       CALL HEXC
  7F17    3A 802B                       LD A,(DAYZ+3)
  7F1A    CD 788B                       CALL HEXC
                                        ;-----------
  7F1D    CD 78AB                       CALL COFF 
  7F20    C5                            PUSH BC
  7F21    01 2475                       LD BC,2475H
  7F24    CD 7A8C                       CALL LIST       ;CURSOR POS
  7F27    C1                            POP BC
  7F28    3A 8027                       LD A,(DAYT)
  7F2B    4F                            LD C,A
  7F2C    C5                            PUSH BC
  7F2D    CD 7EC4                       CALL ASCII_CODE
  7F30    C1                            POP BC
  7F31    78                            LD A,B
  7F32    CD 788B                       CALL HEXC
  7F35    79                            LD A,C
  7F36    CD 788B                       CALL HEXC
  7F39    3E 2E                         LD A,2EH
  7F3B    CD 788B                       CALL HEXC
  7F3E    3A 8026                       LD A,(DAYM)
  7F41    4F                            LD C,A
  7F42    C5                            PUSH BC
  7F43    CD 7EC4                       CALL ASCII_CODE
  7F46    C1                            POP BC
  7F47    78                            LD A,B
  7F48    CD 788B                       CALL HEXC
  7F4B    79                            LD A,C
  7F4C    CD 788B                       CALL HEXC
  7F4F    18 34                         JR RDU02
                                ;-----------------------
  7F51    3E 02                         LD A,02H
  7F53    32 651C                       LD (CURT),A
  7F56    3E 04                         LD A,04H
  7F58    32 651D                       LD (CURT+1),A
  7F5B    3A 6B27                       LD A,(RAMT)
  7F5E    CB 7F                         BIT 7,A
  7F60    28 04                         JR Z,RDU03
  7F62    3E 00                         LD A,00H
  7F64    18 02                         JR RDU03+2
  7F66    3E 01                 RDU03:  LD A,01H
  7F68    32 651E                       LD (CURT+2),A
  7F6B    3A 6B27                       LD A,(RAMT)
  7F6E    E6 0F                         AND 0FH
  7F70    FE 0A                         CP 0AH
  7F72    38 0E                         JR C,RDU01
  7F74    D6 0A                         SUB 0AH
  7F76    32 651F                       LD (CURT+3),A
  7F79    3A 651E                       LD A,(CURT+2)
  7F7C    3C                            INC A
  7F7D    32 651E                       LD (CURT+2),A
  7F80    18 03                         JR RDU02
  7F82    32 651F               RDU01:  LD (CURT+3),A
                                
        MACRO-80 3.43   27-Jul-81       PAGE    1-50


  7F85    CD 7A54               RDU02:  CALL RLIST      
  7F88    21 8039                       LD HL,CURON     ; CURSOR ON
  7F8B    06 06                         LD B,06D
  7F8D    7E                    CUR03:  LD A,(HL)
  7F8E    CD 788B                       CALL HEXC
  7F91    23                            INC HL
  7F92    10 F9                         DJNZ CUR03
  7F94    C9                            RET
                                ;------------------
                                ;INCLUDE LCDINI.MAC
                                ;------------------
                                        ;
                                        ; BUS INTERN UMSCHALTUNG
                                        ;
  7F95    DB 1C                 INTERN: IN A,(PIOA)
  7F97    F5                            PUSH AF
  7F98    CB BF                         RES 7,A
  7F9A    18 05                         JR TERN
  7F9C    DB 1C                 EXTERN: IN A,(PIOA)
  7F9E    F5                            PUSH AF
  7F9F    CB FF                         SET 7,A
  7FA1    D3 1C                 TERN:   OUT (PIOA),A
  7FA3    F1                            POP AF
  7FA4    C9                            RET
                                ;----------------
  7FA5                          EPROMON:        
  7FA5    DB 1C                         IN A,(PIOA)
  7FA7    CB B7                         RES 6,A
  7FA9    D3 1C                         OUT (PIOA),A    ; EPROM Ein
  7FAB    C3 0000                       JP 0000H        ; EPROM NEUSTART -> PROGRAMM ENDE
                                ;------------------------
  7FAE    42 4C 41 53           TEX1:   DEFM 'BLASE VERGLEICH:'
  7FB2    45 20 56 45           
  7FB6    52 47 4C 45           
  7FBA    49 43 48 3A           
                                ;TEX1I: DEFB 78H,78H,78H,78H    
  0010                          TXL     EQU $-TEX1
                                
  7FBE    42 4C 41 53           TEX2:   DEFM 'BLASE GEFUNDEN: '
  7FC2    45 20 47 45           
  7FC6    46 55 4E 44           
  7FCA    45 4E 3A 20           
  7FCE    00 00 00 00           TEX2I:  DEFB 00H,00H,00H,00H    
                                
  7FD2    4B 49 53 59           TEX3:   DEFM 'KISYS 08.12.2009/17'
  7FD6    53 20 30 38           
  7FDA    2E 31 32 2E           
  7FDE    32 30 30 39           
  7FE2    2F 31 37              
  0013                          TXL3    EQU $-TEX3
                                ;-----------------------
                                ;  BIOS Function Summary
                                
  7FE5    C5                    BIOS:   PUSH    BC
  7FE6    E5                            PUSH    HL
  7FE7    5E                            LD      E,(HL)          ; Speicher Lesen 
        MACRO-80 3.43   27-Jul-81       PAGE    1-51


  7FE8    CD 0005                       CALL    0005H
  7FEB    E1                            POP     HL
  7FEC    C1                            POP     BC
  7FED    23                            INC     HL
  7FEE    10 F5                         DJNZ    BIOS
  7FF0    C9                            RET
                                ;----------------------
                                ; Blasen Adress Buffer
                                
  7FF1    00 00 00 00           BF00:   DEFB    00H,00H,00H,00H,80H,00H         ; U,T1,T2 Zaehler zum Blase eroeffnen
  7FF5    80 00                 
  7FF7    00 00 00 00           BF01:   DEFB    00H,00H,00H,00H,00H,00H         ; LAST CURSOR POS XX,YY
  7FFB    00 00                 
  7FFD    00 00 00 00           BF02:   DEFB    00H,00H,00H,00H,00H,00H
  8001    00 00                 
  8003    00 00 00 00           BF03:   DEFB    00H,00H,00H,00H,00H,00H
  8007    00 00                 
  8009    00 00 00 00           BF04:   DEFB    00H,00H,00H,00H,00H,00H
  800D    00 00                 
  800F    00 00 00 00           BF05:   DEFB    00H,00H,00H,00H,00H,00H
  8013    00 00                 
  8015    00 00 00 00           BF06:   DEFB    00H,00H,00H,00H         ; Datenbankverwaltung
  8019    00 00 00 00           BF07:   DEFB    00H,00H,00H,00H         ; Letzte HDD SORTIERADRESSE
                                ;----------------------
  801D    00 00 00 00           BF10:   DEFB    00H,00H,00H,00H,00H,00H,00H,00H ; User Type, G.Zaehler
  8021    00 00 00 00           
                                ;----------------------
                                ; Kalender
  8025    30                    DAYJ:   DEFB    30H
  8026    30                    DAYM:   DEFB    30H
  8027    30                    DAYT:   DEFB    30H
  8028    30 30 30 30           DAYZ:   DEFB    30H,30H,30H,30H,30H,30H
  802C    30 30                 
                                
                                ;----------------------
                                ; Eingabe Meldung Zeile 24, Spalte 1
  0007                          CURUD   EQU 07H                 ; Zaehlen ab 01 - 09
  802E    00 00                 ZEIL:   DEFB 00H,00H
  8030    1B 5B 31 6D           COL01:  DEFB 1BH,5BH,31H,6DH,1BH,5BH,34H,34H,6DH        ;COLOR
  8034    1B 5B 34 34           
  8038    6D                    
  8039    1B 5B 3F 32           CURON:  DEFB 1BH,5BH,3FH,32H,35H,68H            ;SET CURSOR ON
  803D    35 68                 
  803F    1B 5B 3F 32           CUROFF: DEFB 1BH,5BH,3FH,32H,35H,6CH            ;SET CURSOR OFF
  8043    35 6C                 
  8045    1B 5B 32 34           EBUFF:  DEFB 1BH,5BH,'2','4',';','0','1','H'
  8049    3B 30 31 48           
  804D    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  8051    6D                    
  8052    20 20 20 20                   DEFM '                           '
  8056    20 20 20 20           
  805A    20 20 20 20           
  805E    20 20 20 20           
  8062    20 20 20 20           
  8066    20 20 20 20           
  806A    20 20 20              
        MACRO-80 3.43   27-Jul-81       PAGE    1-52


  806D    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  8071    3B 30 31 48           
  8075    53 75 63 68           EBUFFE: DEFM 'Suche:'
  8079    65 3A                 
  0036                          EZLEN   EQU $-EBUFF
  807B    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  807F    3B 30 31 48           
  8083    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  8087    6D                    
  8088    4C 69 73 74                   DEFM 'List                '
  808C    20 20 20 20           
  8090    20 20 20 20           
  8094    20 20 20 20           
  8098    20 20 20 20           
  809C    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  80A0    3B 30 31 48           
  80A4    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  80A8    6D                    
  80A9    8E 6E 64 65                   DEFM  142D,'ndern              '
  80AD    72 6E 20 20           
  80B1    20 20 20 20           
  80B5    20 20 20 20           
  80B9    20 20 20 20           
  80BD    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  80C1    3B 30 31 48           
  80C5    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  80C9    6D                    
  80CA    53 70 65 69                   DEFM 'Speichern           '
  80CE    63 68 65 72           
  80D2    6E 20 20 20           
  80D6    20 20 20 20           
  80DA    20 20 20 20           
  80DE    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  80E2    3B 30 31 48           
  80E6    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  80EA    6D                    
  80EB    56 65 72 67                   DEFM 'Vergessen           '
  80EF    65 73 73 65           
  80F3    6E 20 20 20           
  80F7    20 20 20 20           
  80FB    20 20 20 20           
  80FF    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  8103    3B 30 31 48           
  8107    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  810B    6D                    
  810C    45 6E 64 65                   DEFM 'Ende                '
  8110    20 20 20 20           
  8114    20 20 20 20           
  8118    20 20 20 20           
  811C    20 20 20 20           
                                
  8120    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  8124    3B 30 31 48           
  8128    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  812C    6D                    
  812D    20 20 20 4C                   DEFM '   List             '
        MACRO-80 3.43   27-Jul-81       PAGE    1-53


  8131    69 73 74 20           
  8135    20 20 20 20           
  8139    20 20 20 20           
  813D    20 20 20 20           
                                
  8141    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  8145    3B 30 31 48           
  8149    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  814D    6D                    
  814E    20 20 8E 6E                   DEFM '  ',142D,'ndern               '
  8152    64 65 72 6E           
  8156    20 20 20 20           
  815A    20 20 20 20           
  815E    20 20 20 20           
  8162    20 20 20              
                                
  8165    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  8169    3B 30 31 48           
  816D    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  8171    6D                    
  8172    41 6E 6C 65                   DEFM 'Anlegen             '
  8176    67 65 6E 20           
  817A    20 20 20 20           
  817E    20 20 20 20           
  8182    20 20 20 20           
                                
  8186    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  818A    3B 30 31 48           
  818E    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  8192    6D                    
  8193    53 70 65 69                   DEFM 'Speichern           '
  8197    63 68 65 72           
  819B    6E 20 20 20           
  819F    20 20 20 20           
  81A3    20 20 20 20           
                                
  81A7    3A                            DEFB ':'        ; Ende Text
                                
  81A8                          ZCUR:
                                ;!!!    DEFB 08H                                
  81A8    4C 49 53 54                   DEFM 'LISTF.COM   '                             
  81AC    46 2E 43 4F           
  81B0    4D 20 20 20           
                                ;!!!    DEFB 07H        
  81B4    4D 45 4D 2E                   DEFM 'MEM.COM     '
  81B8    43 4F 4D 20           
  81BC    20 20 20 20           
                                ;!!!    DEFB 08H                                
  81C0    45 44 49 54                   DEFM 'EDIT.COM'                         
  81C4    2E 43 4F 4D           
                                
                                ;----------------------
                                
  81C8                          PRLO1:
                                ;!!!    DEFB 08H
  81C8    46 41 4B 54                   DEFM 'FAKT.COM'
        MACRO-80 3.43   27-Jul-81       PAGE    1-54


  81CC    2E 43 4F 4D           
                                
  81D0    53 74 61 72           STEX:   DEFM 'Start Programm  '
  81D4    74 20 50 72           
  81D8    6F 67 72 61           
  81DC    6D 6D 20 20           
  0010                          LSTEX   EQU $-STEX
                                
  81E0    4B 49 53 79           LCDE:   DEFM  'KISystem Winterhalter'
  81E4    73 74 65 6D           
  81E8    20 57 69 6E           
  81EC    74 65 72 68           
  81F0    61 6C 74 65           
  81F4    72                    
  0015                          LCDEX   EQU     $-LCDE
                                
  81F5    1B 5B 31 35           COMZ:   DEFB 1BH,5BH,31H,35H,3BH,30H,31H,48H,1BH,5BH,30H,4AH
  81F9    3B 30 31 48           
  81FD    1B 5B 30 4A           
  8201    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH,1BH,5BH,34H,32H,6DH
  8205    6D 1B 5B 34           
  8209    32 6D                 
  820B    43 6F 6D 6D                   DEFM  'Commando Zeile= '
  820F    61 6E 64 6F           
  8213    20 5A 65 69           
  8217    6C 65 3D 20           
  0026                          COMZX   EQU     $-COMZ
                                
                                
  821B    1B 5B 32 34           KEYZ:   DEFB 1BH,5BH,32H,34H,3BH,30H,31H,48H
  821F    3B 30 31 48           
  8223    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH,1BH,5BH,34H,32H,6DH
  8227    6D 1B 5B 34           
  822B    32 6D                 
  822D    4B 45 59 20                   DEFM  'KEY Stepp= '
  8231    53 74 65 70           
  8235    70 3D 20              
  001D                          KEYZX   EQU     $-KEYZ
                                
  8238    1B 5B 30 31           MELD01: DEFB 1BH,5BH,30H,31H,3BH,30H,31H,48H
  823C    3B 30 31 48           
  8240    1B 5B 33 31                   DEFB 1BH,5BH,33H,31H,6DH,1BH,5BH,34H,34H,6DH
  8244    6D 1B 5B 34           
  8248    34 6D                 
  824A    44 69 65 73                   DEFM  'Dieser Begriff ist mir nicht bekannt'
  824E    65 72 20 42           
  8252    65 67 72 69           
  8256    66 66 20 69           
  825A    73 74 20 6D           
  825E    69 72 20 6E           
  8262    69 63 68 74           
  8266    20 62 65 6B           
  826A    61 6E 6E 74           
  0036                          MELD01X EQU     $-MELD01
                                
  826E    1B 5B 32 34           PROZ:   DEFB 1BH,5BH,32H,34H,3BH,30H,31H,48H
        MACRO-80 3.43   27-Jul-81       PAGE    1-55


  8272    3B 30 31 48           
  8276    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH,1BH,5BH,34H,32H,6DH
  827A    6D 1B 5B 34           
  827E    32 6D                 
  8280    44 61 74 65                   DEFM  'Dateiname= Dez/Text'
  8284    69 6E 61 6D           
  8288    65 3D 20 44           
  828C    65 7A 2F 54           
  8290    65 78 74              
  0025                          PROZX   EQU     $-PROZ
                                
  8293    1B 5B 32 34           DERR:   DEFB 1BH,5BH,32H,34H,3BH,31H,31H,48H
  8297    3B 31 31 48           
  829B    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH,1BH,5BH,34H,37H,6DH
  829F    6D 1B 5B 34           
  82A3    37 6D                 
  82A5    44 49 53 4B                   DEFM  'DISK / HDD ERROR $'
  82A9    20 2F 20 48           
  82AD    44 44 20 45           
  82B1    52 52 4F 52           
  82B5    20 24                 
  82B7    05 05                         DEFB 05H,05H
  0026                          L_DERR  EQU $-DERR
                                ;---------------------------
  82B9    43 00 00 00           NBLASE: DEFB  MNBL1,00H,00H,00H,80H,00H                       ;         
  82BD    80 00                 
                                        ;------------------
  82BF    1B 5B 32 4A           NBL1:   DEFB  1BH,5BH,32H,4AH,1BH,5BH,48H,1BH,5BH,33H,37H,6DH ; 12 Zeichen
  82C3    1B 5B 48 1B           
  82C7    5B 33 37 6D           
  82CB    1B 5B 31 6D                   DEFB  1BH,5BH,31H,6DH,1BH,5BH,34H,34H,6DH             ; 9 ZEICHEN
  82CF    1B 5B 34 34           
  82D3    6D                    
  82D4    20 20 20 20                   DEFM '                                              ' ; 46 ZEICHEN
  82D8    20 20 20 20           
  82DC    20 20 20 20           
  82E0    20 20 20 20           
  82E4    20 20 20 20           
  82E8    20 20 20 20           
  82EC    20 20 20 20           
  82F0    20 20 20 20           
  82F4    20 20 20 20           
  82F8    20 20 20 20           
  82FC    20 20 20 20           
  8300    20 20                 
  0043                          MNBL1   EQU $-NBL1
                                        ; Taste
  8302    00                            DEFB 00H                                        ; Key Eingabe
                                        ; Programm
  8303    01                            DEFB 01H                                        ; Programme
                                ;!!!    DEFB 0AH                                        ; Leange Programm
  8304    4D 41 53 4B                   DEFM 'MASKE1.COM  '                             ; 10 ZEICHEN
  8308    45 31 2E 43           
  830C    4F 4D 20 20           
  8310    39                            DEFB MNBL2 ;57D                                 ; zum naechsten Textlaenge
  8311    1B 5B 33 37           NBL2:   DEFB 1BH,5BH,33H,37H,6DH                        ; 5 ZEICHEN
        MACRO-80 3.43   27-Jul-81       PAGE    1-56


  8315    6D                    
  8316    1B 5B 30 33                   DEFB 1BH,5BH,30H,33H,3BH,30H,31H,48H            ; 8 ZEICHEN
  831A    3B 30 31 48           
  831E    09 09 09                      DEFB 09H,09H,09H                                ; 3 ZEICHEN     
  8321    4E 65 75 65                   DEFM 'Neue Seite eroeffnet'                     ; 20 ZEICHEN
  8325    20 53 65 69           
  8329    74 65 20 65           
  832D    72 6F 65 66           
  8331    66 6E 65 74           
  8335    0A 0D                         DEFB 0AH,0DH                                    ; 2 ZEICHEN     
  8337    20 31 20 20                   DEFM ' 1  A'                                    ; 5 ZEICHEN
  833B    41                    
  833C    0A 0D                         DEFB 0AH,0DH                                    ; 2 ZEICHEN
  833E    20 32 20 20                   DEFM ' 2  S'                                    ; 5 ZEICHEN     
  8342    53                    
  8343    0A 0D                         DEFB 0AH,0DH                                    ; 2 ZEICHEN
  8345    20 39 20 20                   DEFM ' 9  E'                                    ; 5 ZEICHEN
  8349    45                    
  0039                          MNBL2   EQU $-NBL2
                                        ; TASTE
  834A    10                            DEFB 10H
                                        ; PROGRAMM
  834B    02                            DEFB 02H
                                ;!!!    DEFB 08D
  834C    41 55 54 4F                   DEFM 'AUTO.COM    '
  8350    2E 43 4F 4D           
  8354    20 20 20 20           
                                ;!!!    DEFB 07D        
  8358    4D 45 4D 2E                   DEFM 'MEM.COM     '
  835C    43 4F 4D 20           
  8360    20 20 20 20           
  8364    00 00                         DEFB 00H,00H     ; 00= keine Keyeingabe folgend, 00= kein Progr.
  00AD                          NBLLE   EQU     $-NBLASE
                                ;----------------------
  8366    43 00 00 01           TBLASE: DEFB  MTBLA1,00H,00H,01H,80H,00H                                ;       
  836A    80 00                 
                                        ;------------
  836C    1B 5B 30 6D           TBLA1:  DEFB  1BH,5BH,30H,6DH,1BH,5BH,48H,1BH,5BH,33H,37H,6DH   ; 12 Zeichen
  8370    1B 5B 48 1B           
  8374    5B 33 37 6D           
  8378    1B 5B 31 6D                   DEFB  1BH,5BH,31H,6DH,1BH,5BH,34H,34H,6DH               ; 9 ZEICHEN
  837C    1B 5B 34 34           
  8380    6D                    
  8381    20 20 20 20                   DEFM '                                              '   ; 46 ZEICHEN
  8385    20 20 20 20           
  8389    20 20 20 20           
  838D    20 20 20 20           
  8391    20 20 20 20           
  8395    20 20 20 20           
  8399    20 20 20 20           
  839D    20 20 20 20           
  83A1    20 20 20 20           
  83A5    20 20 20 20           
  83A9    20 20 20 20           
  83AD    20 20                 
  0043                          MTBLA1  EQU $-TBLA1
        MACRO-80 3.43   27-Jul-81       PAGE    1-57


                                        ; Taste
  83AF    00                            DEFB 00H                                        ; Key Eingabe
                                        ; Programm
  83B0    01                            DEFB 01H                                        ; Programme
                                ;!!!    DEFB 0AH                                        ; Leange Programm
  83B1    45 44 49 54                   DEFM 'EDITOR.COM  '                             ; 10 ZEICHEN
  83B5    4F 52 2E 43           
  83B9    4F 4D 20 20           
  0057                          TBLLE   EQU     $-TBLASE
                                ;-----------------------------
  83BD    43 00 02 00           SMASKE: DEFB MSMAS1,00H,02H,00H,76H,80H
  83C1    76 80                 
                                        ;-------------------
                                        ; BLOCK LAENG OBEN SMASKE ERSTER WERT(43H)
  83C3    1B 5B 32 4A           SMAS1:  DEFB 1BH,5BH,32H,4AH,1BH,5BH,48H,1BH,5BH,33H,37H,6DH
  83C7    1B 5B 48 1B           
  83CB    5B 33 37 6D           
  83CF    1B 5B 31 6D                   DEFB 1BH,5BH,31H,6DH,1BH,5BH,34H,34H,6DH
  83D3    1B 5B 34 34           
  83D7    6D                    
  83D8    53 74 61 72                   DEFM 'Start                                         ' ;46D Zeichen
  83DC    74 20 20 20           
  83E0    20 20 20 20           
  83E4    20 20 20 20           
  83E8    20 20 20 20           
  83EC    20 20 20 20           
  83F0    20 20 20 20           
  83F4    20 20 20 20           
  83F8    20 20 20 20           
  83FC    20 20 20 20           
  8400    20 20 20 20           
  8404    20 20                 
                                        ;------------------
  0043                          MSMAS1  EQU $-SMAS1
  8406    00                            DEFB 00H        
  8407    01                            DEFB 01H        ; ANZAHL PROGRAMMAUFRUFE
                                ;!!!    DEFB 0AH        ; FILE NAME LAENGE
  8408    4D 41 53 4B                   DEFM 'MASKE1.COM  '
  840C    45 31 2E 43           
  8410    4F 4D 20 20           
  8414    20 20 20 20                   DEFM '      Ersatzseite KI-System V1.0 '
  8418    20 20 45 72           
  841C    73 61 74 7A           
  8420    73 65 69 74           
  8424    65 20 4B 49           
  8428    2D 53 79 73           
  842C    74 65 6D 20           
  8430    56 31 2E 30           
  8434    20                    
  8435    0D 0A                         DEFB 0DH,0AH
  8437    10                            DEFB 10H        ; TASTATUR MENGE ZEICHENEINGABE
  8438    01                            DEFB 01H        ; ANZAHL PROGRAMMAUFRUFE
                                ;!!!    DEFB 07H        ; FILE NAME LAENGE
  8439    4D 45 4D 2E                   DEFM 'MEM.COM     '
  843D    43 4F 4D 20           
  8441    20 20 20 20           
        MACRO-80 3.43   27-Jul-81       PAGE    1-58


  0088                          SRAL    EQU $-SMASKE
                                
  8445    39                            DEFB 57D
  8446    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH                        ; 5 ZEICHEN
  844A    6D                    
  844B    1B 5B 30 33                   DEFB 1BH,5BH,30H,33H,3BH,30H,31H,48H            ; 8 ZEICHEN
  844F    3B 30 31 48           
  8453    09 09 09                      DEFB 09H,09H,09H                                ; 3 ZEICHEN     
  8456    4E 65 75 65                   DEFM 'Neue TYPE2 eroeffnet'                     ; 20 ZEICHEN
  845A    20 54 59 50           
  845E    45 32 20 65           
  8462    72 6F 65 66           
  8466    66 6E 65 74           
  846A    0A 0D                         DEFB 0AH,0DH                                    ; 2 ZEICHEN     
  846C    20 30 20 41                   DEFM ' 0 A?'                                    ; 5 ZEICHEN
  8470    3F                    
  8471    0A 0D                         DEFB 0AH,0DH                                    ; 2 ZEICHEN
  8473    20 31 20 20                   DEFM ' 1  S'                                    ; 5 ZEICHEN     
  8477    53                    
  8478    0A 0D                         DEFB 0AH,0DH                                    ; 2 ZEICHEN
  847A    20 39 20 20                   DEFM ' 9  E'                                    ; 5 ZEICHEN
  847E    45                    
                                        ; TASTE
  847F    10                            DEFB 10H
                                        ; PROGRAMM
  8480    01                            DEFB 01H
  8481    07                            DEFB 07H        
  8482    4D 45 4D 2E                   DEFM 'MEM.COM     '
  8486    43 4F 4D 20           
  848A    20 20 20 20           
  848E    00 00                         DEFB 00H,00H     ; 00= keine Keyeingabe folgend, 00= kein Progr.
                                
                                END
        MACRO-80 3.43   27-Jul-81       PAGE    S


Macros:

Symbols:
7604    _ED12           78D2    _WAIT1          7EC4    ASCII_CODE      
7EDD    ASC_1           7EED    ASC_2           0047    BAUD1           
0047    BAUD2           0047    BAUD3           7FF1    BF00            
7FF7    BF01            7FFD    BF02            8003    BF03            
8009    BF04            800F    BF05            8015    BF06            
8019    BF07            801D    BF10            6503    BFRHH           
6502    BFRHL           6501    BFRLH           6500    BFRLL           
650F    BFSHH           650E    BFSHL           650D    BFSLH           
650C    BFSLL           650B    BFVHH           650A    BFVHL           
6509    BFVLH           6508    BFVLL           7FE5    BIOS            
7071    BL              70AC    BL00            70C9    BL000           
70DC    BL01            7171    BL02            71A8    BL021           
720A    BL022           7210    BL023           7207    BL02X           
7212    BL03            722D    BL030           7223    BL031           
724B    BL033           7328    BL04            71B4    BL120           
7200    BL121           71E0    BL123           71F2    BL124           
71F9    BL125           727F    BL13            7267    BL131           
726C    BL132           728A    BL13D           7338    BL14            
7295    BL23            729D    BL231           72AD    BL33            
72B8    BL43            72C3    BL53            72E3    BL73            
72E9    BL736           72F6    BL83            731A    BL830           
7322    BL831           7311    BL84            6200    BLAN            
7340    BS10            6205    BSTAT           0080    BUFF            
0020    CMD_READSEC     0030    CMD_WRITESEC    78AB    COFF            
7062    COL0            8030    COL01           7067    COL1            
81F5    COMZ            0026    COMZX           789A    CON             
6C3F    COP             0007    CPOS            0010    CTC             
78B2    CUR01           78A1    CUR02           7F8D    CUR03           
803F    CUROFF          8039    CURON           6518    CURS            
651C    CURT            0007    CURUD           7854    CUT             
8025    DAYJ            8026    DAYM            8027    DAYT            
8028    DAYZ            00F4    DCI             0001    DCLR            
000C    DCON            8293    DERR            0002    DHOM            
7944    DISK            0001    DISPLAY         8045    EBUFF           
8075    EBUFFE          75A1    ED00            7593    ED01            
759B    ED02            75F6    ED03            75C5    ED10            
75ED    ED100           75F0    ED11            7602    ED12            
761A    ED13            7638    ED14            763D    ED15            
763A    ED20            7640    ED30            7658    ED31            
766B    ED32            766D    ED33            766F    ED40            
767A    ED41            7689    ED42            768E    ED43            
7693    ED44            76A6    ED441           76BD    ED442           
76C1    ED50            76D6    ED51            757B    EING            
76D8    EING11          7707    EING21          7717    EING22          
7732    EING23          7742    EING24          7751    EING25          
776A    EING26          776C    EING27          7774    EING30          
0040    EOFF            7FA5    EPROMON         7904    ERR1            
7246    EXIT            7F9C    EXTERN          7167    EZ01            
716E    EZ02            7104    EZ03            7134    EZ04            
0036    EZLEN           005C    FCB             006B    FCBCR           
005D    FCBFN           0065    FCBFT           007C    FCBRA           
7998    FREI            0005    FSET            0800    HDD             
00BE    HDDE            78F3    HDD_ERROR       790C    HDD_INFO        
78D9    HDD_INIT        791A    HDD_READ        78D2    HDD_WAIT        
        MACRO-80 3.43   27-Jul-81       PAGE    S-1


7DEF    HDIST           7817    HEX00           77C0    HEX11           
77D3    HEX12           7817    HEX14           780C    HEXA            
788B    HEXC            77B5    HEXI1           77C8    HEXI2           
77D7    HEXIE           77DA    HEXP            00F0    IDE             
00FD    IDECHI          00FC    IDECLO          00FF    IDECMD          
00F8    IDEDAT          00F6    IDEDOR          00F9    IDEERR          
7928    IDERES          792E    IDERES1         00FA    IDESCNT         
00FE    IDESDH          00FB    IDESNUM         00FF    IDESTAT         
7F95    INTERN          0000    KANAL0          0001    KANAL1          
0003    KANAL3          0004    KANAL4          0005    KANAL5          
79B2    KEY01           0002    KEYIN           0001    KEYOUT          
79A0    KEYST           821B    KEYZ            001D    KEYZX           
7021    KI              7093    KI1             00F5    LATCH           
79B4    LBA0            79FD    LBA20           79FE    LBA21           
79FA    LBA4            7A03    LBA5            0060    LCD             
81E0    LCDE            0015    LCDEX           7AB2    LIS0            
7AB4    LIS1            7A8C    LIST            6513    LOGHH           
6512    LOGHL           6511    LOGLH           6510    LOGLL           
0100    LOS             0120    LOS1            0008    LPOS            
0010    LSTEX           0026    L_DERR          7A3D    L__6            
7A35    L__7            777A    MAS00           778A    MAS01           
77A6    MAS02           8238    MELD01          0036    MELD01X         
A101    MMC             0007    MMCE            0043    MNBL1           
0039    MNBL2           0043    MSMAS1          0043    MTBLA1          
82BF    NBL1            8311    NBL2            82B9    NBLASE          
00AD    NBLLE           001C    PIOA            001E    PIOB            
81C8    PRLO1           0130    PRO             7000    PROG            
826E    PROZ            0025    PROZX           0005    P_READ          
0006    P_WRITE         6524    RADR            6000    RAM             
0021    RAMH            0000    RAML            6727    RAMS            
6B27    RAMT            6527    RAMV            0000    RBLAN           
0005    RBSTAT          7C98    RD01            7D54    RD02            
7D05    RD03            7C34    RD06            7B42    RD07            
7B45    RD08            7B4D    RD09            7C6D    RD16            
7C7A    RD17            7C82    RD170           7C8D    RD171           
7BD9    RD25            7C0B    RD250           7BED    RD255           
7BF7    RD26            7D3A    RD30            7C29    RD35            
7C17    RD36            7D68    RD90            7D8C    RD91            
7D8F    RD911           7D95    RD92            7C50    RDD1            
7DA2    RDREAD          7F82    RDU01           7F85    RDU02           
7F66    RDU03           7DCB    RDWRITE         F814    READ            
0000    REG1            00C1    REG3            0044    REG4            
00EA    REG5            7A54    RLIST           6526    RMEN            
0006    RSOTR           0004    RTERM           6BEF    RTEX            
0002    RTYPE1          0003    RTYPE2          701B    RUN             
0001    RUSER           7844    SA1             7848    SA2             
784A    SA3             6520    SANDB           7834    SANDU           
0020    SDC             0004    SELDM           00F7    SELDS           
F838    SELDSK          F82F    SETDMA          F835    SETSEC          
F832    SETTRK          0018    SIOA            001A    SIOB            
0018    SIORES          83C3    SMAS1           83BD    SMASKE          
0088    SRAL            81D0    STEX            7373    STX01           
7365    SU00            7379    SU01            73C8    SU02            
73CB    SU03            73DF    SU04            74A3    SU21            
7558    SU23            7488    SU25            7560    SU32            
756E    SU33            7536    SU52            754A    SU520           
        MACRO-80 3.43   27-Jul-81       PAGE    S-2


74AC    SU62            74DE    SU63            7468    SU80            
741E    SU82            742E    SU83            7437    SU84            
7416    SU85            7455    SU86            7462    SU87            
7405    SU88            74EF    SU90            7533    SU95            
74FF    SU99            7976    SUCH0           7984    SUCH1           
7986    SUCH2           7000    T0              7003    T1              
7006    T2              7009    T3              700C    T4              
700F    T5              7012    T6              7015    T7              
7018    T8              7ABF    TAS             7B1E    TAS00           
7BAC    TAS03           7CD7    TAS22           7CFD    TAS24           
7DF7    TASK            7E42    TASK99          FFA2    TASKSP          
836C    TBLA1           8366    TBLASE          0057    TBLLE           
725B    TEING           6204    TERM            7FA1    TERN            
7FAE    TEX1            7FBE    TEX2            7FCE    TEX2I           
7FD2    TEX3            0004    TIME1           0004    TIME2           
0004    TIME3           FFAB    TRACK           FFA5    TRACKH          
FFA4    TRACKL          7E46    TWRITE          0010    TXL             
0013    TXL3            6202    TYPE1           6203    TYPE2           
7E6A    UHR00           7EB7    UHR01           7EF5    UHR10           
0080    URCS            6201    USER            78C7    WAITDRQ         
78BC    WAITRDY         00F0    WDTCR           00F1    WDTER           
7A72    WLIST           F817    WRITE           81A8    ZCUR            
77B1    ZEI00           802E    ZEIL            



No Fatal error(s)


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
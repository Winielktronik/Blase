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
                                ; DRIVE NEU SET MASTER/SLAVE
        MACRO-80 3.43   27-Jul-81       PAGE    1-4


                                ;
  0126    3A FD1A                       LD A,(0FD1AH)
  0129    FE A5                         CP 0A5H
  012B    3E F5                         LD A,0F5H
                                        ;LD (0FD1AH),A
  012D    C3 7018                       JP RUN          ;PROGRAMM Start
                                ;----------------
  0130                          PRO:
                                
                                .PHASE PROG
                                
  7000    C9                    T0:     RET
  7001    00                            NOP
  7002    00                            NOP
  7003    C3 7894               T1:     JP HEXC         ; ZEICHENAUSGEBEN
  7006    C3 79A9               T2:     JP KEYST        ; TASTENABFRABE OHNE SORTIERUNG
  7009    C3 797F               T3:     JP SUCH0        ; Blase mit Eintrag aus RAMT suchen  
  700C    C3 79BD               T4:     JP LBA0         ; Plattenzugriff (DE), (HL) +1
  700F    C3 7DA5               T5:     JP RDREAD       ; lesen einer Blase
  7012    C3 7DCE               T6:     JP RDWRITE      ; Speichern einer Blase
  7015    C3 7859               T7:     JP CUT          ; CURSOR POS SET IN (CURT)0-3
                                ;-----------------------
                                ;  LCD 128X128 ANSTEUERN
  7018    DB 1C                 RUN:    IN A,(PIOA)
  701A    CB BF                         RES 7,A         ; INTERN
  701C    D3 1C                         OUT (PIOA),A
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
                                ;       CALL CMD
                                ;
        MACRO-80 3.43   27-Jul-81       PAGE    1-5


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
                                
  701E    21 0000               KI:     LD HL,0000H
  7021    22 801E                       LD (BF07+2),HL
  7024    22 6502                       LD (BFRHL),HL           ; AKTUELL TRACK/SECTORADRESSE LADEN
                                        ; SORTIERE IN BFS...
  7027    22 650E                       LD (BFSHL),HL           ; IN BFS ADRESSE ZUM SORZIEREN
  702A    22 6512                       LD (BFSHL+4),HL
  702D    22 6512                       LD (LOGHL),HL
  7030    21 0010                       LD HL,0010H             ; STARTADR. USER-LOGIN AUF HDD
  7033    22 6510                       LD (LOGLL),HL
  7036    21 0800                       LD HL,HDD               ; HD STARTADRESSE
  7039    22 801C                       LD (BF07),HL
  703C    22 6500                       LD (BFRLL),HL           ; AKTUELLE TRACK/SECTORADRESSE LADEN
                                        ;-----------------------
                                        ; SORTIER STARTADRESSE SETZEN 
                                        ; BLASE1 UND BLASE2+4 AUS HDD STARTADRESSE+1
  703F    23                            INC HL          ; 
  7040    22 650C                       LD (BFSLL),HL   ; Sortieranfang
  7043    22 6510                       LD (BFSLL+4),HL ; Sortieranfang
                                
                                        ;------------------
                                        ; Cursor REGISTER auf Z=24, S=1 setzen
  7046    01 2401                       LD BC,2401H
  7049    CD 7A91                       CALL LIST
                                        ;
                                        ;------------------
                                        ; BF00 beim Neustart auf Null setzen 
                                        ; Suchparameter fuer neue Blase 
                                        ; USER wird nur durch Login veraendert
                                        ; TYPE1, TYPE2 aus Blasendaten 
  704C    AF                            XOR A
  704D    32 7FF4                       LD (BF00),A
  7050    32 7FF5                       LD (BF00+RUSER),A
  7053    32 7FF6                       LD (BF00+RTYPE1),A
  7056    32 7FF7                       LD (BF00+RTYPE2),A
  7059    32 7FF8                       LD (BF00+RTERM),A
                                        ;----------
  705C    C5                            PUSH BC
  705D    D5                            PUSH DE
  705E    E5                            PUSH HL
  705F    21 8033               COL0:   LD HL,COL01             ; BILDSCHIRM FARBE
  7062    06 09                         LD B,09D                ; AUSGABELAENGE
  7064    7E                    COL1:   LD A,(HL)
  7065    CD 7894                       CALL HEXC
  7068    23                            INC HL
        MACRO-80 3.43   27-Jul-81       PAGE    1-6


  7069    10 F9                         DJNZ COL1
  706B    E1                            POP HL
  706C    D1                            POP DE
  706D    C1                            POP BC
                                ;       JR KI1          ;!!STARTSEITE NICHT DA ->
                                        ;---
                                        ; Blase aus BFRxx laden
  706E    AF                    BL:     XOR A
  706F    ED 4B 6500                    LD BC,(BFRLL)   ; Aktuelle HIGH LBA laden
  7073    ED 5B 6502                    LD DE,(BFRHL)   ; Aktuelle LOW LBA laden
  7077    21 6000                       LD HL,RAM       ; DMA
  707A    CD 7DA5                       CALL RDREAD
                                        ;------
                                        ; READ SICHTBAR MACHEN
                                ;!!!    LD BC,0501H
                                ;!!!    CALL LIST
                                ;!!!    LD HL,RAM
                                ;!!!    CALL LIS0
  707D    3A 6000                       LD A,(RAM)
  7080    FE 43                         CP 43H
  7082    CA 7090                       JP Z,KI1
                                        ;-------------------
  7085    21 83CE                       LD HL,SMASKE            ; STARTMASKE LADEN
  7088    11 6000                       LD DE,RAM
  708B    01 0083                       LD BC,SRAL
  708E    ED B0                         LDIR
  7090    3E 0A                 KI1:    LD A,0AH        ; >9
  7092    32 802E                       LD (DAYZ+3),A   ; UHRZEIT LOESCHEN DAMIT GLEICH AUSGEGEBEN WIRD
                                        ;------------
                                        ; Blasenstatus schon mal auf benutzt setzen
                                        ; IN AKTUELLER BLASE RAM
  7095    3A 6005                       LD A,(RAM+RBSTAT)       ; RAM
  7098    CB FF                         SET 7,A         ; GedankenStatus Zaehler 0= minus 1= plus
  709A    CB B7                         RES 6,A         ; Sortieren aktivieren
  709C    32 6005                       LD (RAM+RBSTAT),A       ; AUS AKTUELLER BLASE
                                ; ???
  709F    3A 6205                       LD A,(BLAN+RBSTAT)      ; RAM+200
  70A2    CB FF                         SET 7,A         ; Gedankenzaehler 0= minus 1= plus
  70A4    CB B7                         RES 6,A         ; Sortieren aktivieren
  70A6    32 6205                       LD (BLAN+RBSTAT),A      ; VORBEREITEN
                                ; ???
                                        ;---------------------------------
                                        ;  gebe die laenge von B auf VT100 Bildschirm aus 
                                        ;
  70A9    21 6000               BL00:   LD HL,RAM       ; AB HEIR SPEICHER BESCHREIBEN
  70AC    22 6524                       LD (RADR),HL    ; Aktuelle Blasenadresse zwischenspeichern
  70AF    4E                            LD C,(HL)       ; Anzahl von Zeichen ausgeben
  70B0    79                            LD A,C
  70B1    32 6526                       LD (RMEN),A     ; Zeichen laenge zwischenspeichern
  70B4    AF                            XOR A
  70B5    11 6000                       LD DE,RAM
  70B8    ED 52                         SBC HL,DE       ; Blasenanfang bestimmen
  70BA    2A 6524                       LD HL,(RADR)
  70BD    20 09                         JR NZ,BL000     ; NICHT NOCH KEIN BLASENANFANG ->
  70BF    23                            INC HL          ; USER
  70C0    23                            INC HL          ; TYPE1
        MACRO-80 3.43   27-Jul-81       PAGE    1-7


  70C1    7E                            LD A,(HL)
  70C2    32 7FF6                       LD (BF00+RTYPE1),A
  70C5    23                            INC HL          ; Type2
  70C6    23                            INC HL          ; Gedaechtniszaehler
  70C7    23                            INC HL          ; Status Byte
  70C8    3A 6526               BL000:  LD A,(RMEN)
  70CB    47                            LD B,A
  70CC    AF                            XOR A           ; LOESCHEN
  70CD    B8                            CP B
  70CE    CA 7580                       JP Z,EING       ; SPRUNG ZUR EINGABE wenn Zeichenlaenge =0
                                        ;--------------------------------
                                        ; Block ausgeben
  70D1    E5                            PUSH HL
  70D2    D5                            PUSH DE
  70D3    C5                            PUSH BC
  70D4    01 0101                       LD BC,0101H
  70D7    CD 7A91                       CALL LIST
  70DA    C1                            POP BC
  70DB    D1                            POP DE
  70DC    E1                            POP HL
  70DD    23                    BL01:   INC HL          ; ab hier Grafik/Text Bereich
  70DE    7E                            LD A,(HL)       ; Speicher Lesen 
  70DF    CD 7894                       CALL HEXC       ; und ausgeben 
  70E2    10 F9                         DJNZ BL01
                                        ;
                                        ;---------------------------
                                        ; Blasen Parameter USER,TYPE1,TYPE2,Gedaechtnis in % Anzeigen
                                        ; OBEN RECHTS Z=1, S=60
  70E4    E5                            PUSH HL
  70E5    D5                            PUSH DE
  70E6    C5                            PUSH BC
  70E7    01 0160                       LD BC,0160H     ; AUSGABE ZEILE/SPALTE
  70EA    CD 7A91                       CALL LIST
  70ED    C1                            POP BC
  70EE    21 6001                       LD HL,RAM+RUSER         ; USER AUS AKTUELLER BLASE
  70F1    C5                            PUSH BC
  70F2    4E                            LD C,(HL)
  70F3    C5                            PUSH BC
  70F4    CD 781C                       CALL HEX14      ; USER / %
  70F7    C1                            POP BC
  70F8    C1                            POP BC
  70F9    2A 6002                       LD HL,(RAM+RTYPE1)      ; TYPE2=L ,TYPE1=H LADEN
                                        ;---------------------
                                        ; GED[CHTNISZ[HLER IN % UMRECHEN
  70FC    3A 6004                       LD      A,(RAM+RTERM)   ; GED[CHTMISZ[HLER LADEN
  70FF    5F                            LD      E,A     
  7100    3E 00                         LD      A,00H
  7102    F5                    EZ03:   PUSH    AF
  7103    7B                            LD      A,E
  7104    D6 02                         SUB     02H
  7106    FE 03                         CP      03h
  7108    38 28                         JR      C,EZ04
  710A    28 26                         JR      Z,EZ04
  710C    5F                            LD      E,A
  710D    F1                            POP     AF
  710E    3C                            INC     A
        MACRO-80 3.43   27-Jul-81       PAGE    1-8


  710F    27                            DAA
  7110    F5                            PUSH    AF
  7111    7B                            LD      A,E
  7112    D6 03                         SUB     03H
  7114    FE 03                         CP      03H
  7116    38 1A                         JR      C,EZ04
  7118    28 18                         JR      Z,EZ04
  711A    5F                            LD      E,A
  711B    F1                            POP     AF
  711C    3C                            INC     A
  711D    27                            DAA
  711E    CB 47                         BIT     0,A
  7120    28 E0                         JR      Z,EZ03
  7122    F5                            PUSH    AF
  7123    7B                            LD      A,E
  7124    D6 03                         SUB     03H
  7126    FE 03                         CP      03H
  7128    38 08                         JR      C,EZ04
  712A    28 06                         JR      Z,EZ04
  712C    5F                            LD      E,A
  712D    F1                            POP     AF
  712E    3C                            INC     A
  712F    27                            DAA
  7130    18 D0                         JR      EZ03
                                        ;-------------------
  7132    F1                    EZ04:   POP AF
  7133    C5                            PUSH BC
  7134    4F                            LD C,A
  7135    C5                            PUSH BC
  7136    CD 781C                       CALL HEX00              ; % WERT AUSGEBEN
  7139    C1                            POP BC
  713A    C1                            POP BC
  713B    3E 25                         LD A,'%'                ; % ALS ZEICHEN
  713D    CD 7894                       CALL HEXC
  7140    D1                            POP DE
  7141    E1                            POP HL
                                        ;-------------------------------
                                        ;       Tasten Zeichen Eingeben
  7142    23                            INC HL          ; naechster Block
  7143    46                            LD B,(HL)               ; Eingabelaenge 
  7144    E5                            PUSH HL
  7145    21 6B27                       LD HL,RAMT              ; RAMT Zeichen Buffer Eingaben
  7148    11 6B27                       LD DE,RAMT
  714B    13                            INC DE          ; fuer erstes Zeichen
  714C    AF                            XOR A
  714D    77                            LD (HL),A               ; Eingabe Zeichenzaehler auf Null setzen
  714E    B8                            CP B
  714F    CA 7219                       JP Z,BL03               ; SPEUNG ZUR EINGABE OHNE GRAFIK AUSGABE 
                                        ;--------------------------
                                        ; Eingabezeile ausgeben
  7152    D5                            PUSH DE
  7153    E5                            PUSH HL         ; Grafik/Text 
  7154    C5                            PUSH BC
  7155    3A 6003                       LD A,(RAM+RTYPE2)
  7158    FE 00                         CP 0H
  715A    C2 716E                       JP NZ,EZ02
        MACRO-80 3.43   27-Jul-81       PAGE    1-9


  715D    21 8048                       LD HL,EBUFF
  7160    06 44                         LD B,EZLEN
  7162    7E                    EZ01:   LD A,(HL)
  7163    CD 7894                       CALL HEXC
  7166    7E                            LD A,(HL)
  7167    FE 3A                         CP ':'          ; FRUEHER ENDE
  7169    28 03                         JR Z,EZ02
  716B    23                            INC HL
  716C    10 F4                         DJNZ EZ01
  716E    C1                    EZ02:   POP BC
  716F    E1                            POP HL
  7170    D1                            POP DE
  7171    C5                    BL02:   PUSH BC
  7172    D5                            PUSH DE
  7173    E5                            PUSH HL
  7174    CD 7AC2                       CALL TAS                ; auf Zeichen Warten
  7177    F5                            PUSH AF
  7178    CD 78A3                       CALL CON                ; CURSOR ON
  717B    F1                            POP AF
  717C    E1                            POP HL
  717D    D1                            POP DE
  717E    C1                            POP BC
  717F    12                            LD (DE),A               ; Zeichen abspeichen
  7180    FE 0D                         CP 0DH
  7182    CA 7219                       JP Z,BL03               ; Ausgang mit CR
  7185    FE 08                         CP 08H          ; TAB
  7187    20 1F                         JR NZ,BL021     ; NEIN ->
                                        ;-----------------
                                        ; BACKSPACE FUNKTION CURSOR LINKS MIT ZEICHEN LOESCHEN
                                        ;
  7189    7E                            LD A,(HL)               ; Zeichenzaehler
  718A    D6 01                         SUB 01H
  718C    DA 7217                       JP C,BL023
  718F    77                            LD (HL),A               ; Zeichenlaenge -1
  7190    3E 20                         LD A,20H
  7192    CD 7894                       CALL HEXC
  7195    04                            INC B
  7196    1B                            DEC DE          ; Zeichen loeschen
  7197    3E 1B                         LD A,1BH
  7199    CD 7894                       CALL HEXC
  719C    3E 5B                         LD A,5BH
  719E    CD 7894                       CALL HEXC
  71A1    3E 44                         LD A,44H
  71A3    CD 7894                       CALL HEXC
  71A6    18 C9                         JR BL02         ; zurueck ohne B dec
                                        ;-------------------
                                        ; 
  71A8    FE 1B                 BL021:  CP 1BH          ; ESC
  71AA    20 65                         JR NZ,BL022     ; NEIN ->
  71AC    7E                            LD A,(HL)
  71AD    FE 00                         CP 0H
  71AF    20 60                         JR NZ,BL022
  71B1    D5                            PUSH DE
  71B2    C5                            PUSH BC
  71B3    E5                            PUSH HL
  71B4    06 A0                 BL120:  LD B,0A0H
        MACRO-80 3.43   27-Jul-81       PAGE    1-10


  71B6    10 FE                         DJNZ $
  71B8    0E 0B                         LD C,0BH        ; GET CONSOLE STATUS
  71BA    CD 0005                       CALL 0005H      ; pruefe ob Zeichen da
  71BD    FE 00                         CP 0H
  71BF    28 46                         JR Z,BL121      ; -> NO
  71C1    0E 01                         LD C,01H        ; CONSOLE INPUT
  71C3    CD 0005                       CALL 0005H      ; ZEICHEN HOLEN
  71C6    5F                            LD E,A
  71C7    FE 5B                         CP '['
  71C9    28 E9                         JR Z,BL120
  71CB    3E 44                         LD A,'D'
  71CD    BB                            CP E
  71CE    38 37                         JR C,BL121
  71D0    3E 40                         LD A,'@'
  71D2    BB                            CP E
  71D3    30 32                         JR NC,BL121
  71D5    3E 41                         LD A,'A'
  71D7    BB                            CP E
  71D8    20 0D                         JR NZ,BL123
  71DA    3A 8031                       LD A,(ZEIL)
  71DD    3C                            INC A
  71DE    FE 07                         CP CURUD
  71E0    30 25                         JR NC,BL121
  71E2    32 8031                       LD (ZEIL),A
  71E5    18 20                         JR BL121
                                ;--------------------------     
  71E7    3E 42                 BL123:  LD      A,'B'
  71E9    BB                            CP      E
  71EA    20 0D                         JR      NZ,BL124
                                        ;JR     NZ,BL123
  71EC    3A 8031                       LD      A,(ZEIL)
  71EF    3D                            DEC     A
  71F0    FE 01                         CP      01H
  71F2    38 13                         JR      C,BL121
  71F4    32 8031                       LD      (ZEIL),A
  71F7    18 0E                         JR      BL121
                                        ;-------------------
                                
  71F9    3E 43                 BL124:  LD      A,'C'
  71FB    BB                            CP      E
  71FC    20 02                         JR      NZ,BL125
                                ; Cursor right
  71FE    18 07                         JR      BL121
                                        ;-----------
  7200    3E 44                 BL125:  LD A,'D'
  7202    BB                            CP E
  7203    20 02                         JR NZ,BL121
                                ; Cursor left
  7205    18 AD                         JR BL120
                                        ;------------
  7207    AF                    BL121:  XOR A           ; letzes Zeichen loeschen
  7208    E1                            POP HL
  7209    C1                            POP BC
  720A    D1                            POP DE
  720B    77                            LD (HL),A               ; Zeichenzaehler loeschen
  720C    18 03                         JR BL022
        MACRO-80 3.43   27-Jul-81       PAGE    1-11


  720E    C3 7171               BL02X:  JP BL02
                                        ;-------------
  7211    FE 21                 BL022:  CP 21H          ; Zeichen < Space
  7213    38 02                         JR C,BL023
  7215    13                            INC DE          ; Zeichenadr. +1
  7216    34                            INC (HL)        ; Zeichenzaehler erhoehen
  7217    10 F5                 BL023:  DJNZ BL02X      ; vorgegebene Laenge aus Blase
                                ;-----------------------
                                ; Programm ausfuehrung
                                ;
  7219    E1                    BL03:   POP     HL              ; zurueck zur aktuellen RAM adre.
  721A    7E                            LD      A,(HL)          ; Pruefe ob Zeiche ??Programmaufruf da 
  721B    23                            INC     HL              ; weiter zur Programmanzahl     
  721C    FE 00                         CP      00H
  721E    28 0A                         JR      Z,BL031         ; kein Zeichen gedrueckt
  7220    3A 6B27                       LD      A,(RAMT)
  7223    FE 00                         CP      00H
  7225    20 0D                         JR      NZ,BL030
  7227    C3 70A9                       JP      BL00            ; kein Zeichen gedruekt
                                        ;------------------------
  722A    3E 01                 BL031:  LD      A,01H           ; sonst Zeichenzaehler auf 1 setzen
  722C    32 6B27                       LD      (RAMT),A        ; 
  722F    3E 31                         LD      A,31H           ; Programme mindest 1
  7231    32 6B28                       LD      (RAMT+1),A      ; Programmzaehler
  7234    46                    BL030:  LD      B,(HL)          ; Anzahl von Programmaufrufe aus Blase
  7235    AF                            XOR     A               ; LOESCHEN
  7236    B8                            CP      B
  7237    CA 733D                       JP      Z,BL14          ; SPEUNG 
                                        ;--------------
  723A    3A 6B27                       LD A,(RAMT)     ; Anzahl der Taste 
  723D    FE 02                         CP 02H
  723F    D2 733D                       JP NC,BL14              ; Taste mehr als eine Stelle
  7242    3A 6B28                       LD A,(RAMT+1)   ; gedruektes Taste = Zeichen
  7245    FE 30                         CP 30H
  7247    28 19                         JR Z,TEING              ; ??Aender moeglich machen mit 0
  7249    FE 39                         CP 39H                  ; 9 ENDE
  724B    20 05                         JR NZ,BL033
  724D    0E 00                 EXIT:   LD C,00H
  724F    C3 7FA8                       JP EPROMON
                                ;-------
  7252    FE 3A                 BL033:  CP      3AH             ; nicht > 9
  7254    D2 70A9                       JP      NC,BL00
  7257    D6 30                         SUB     30H             ; nicht < 1
  7259    DA 70A9                       JP      C,BL00
  725C    47                            LD      B,A             ; Welche Programm in A 1 - 9
  725D    22 6524                       LD      (RADR),HL       ; aktuelle RAM Adresse retten 
  7260    18 0C                         JR      BL131
                                        ;-------------------
                                        ; AENDERUNG NUR IN TYPE2 =0 MOEGLICH
  7262    3A 6003               TEING:  LD A,(RAM+RTYPE2)
  7265    FE 00                         CP 0H
  7267    CA 7580                       JP Z,EING
  726A    C3 70A9                       JP BL00
                                        ;-----------------
                                        ; Programm suchen und Starten
  726D    19                            ADD     HL,DE
        MACRO-80 3.43   27-Jul-81       PAGE    1-12


  726E    11 000D               BL131:  LD      DE,000DH        ; Laenge einer Datei
  7271    10 FA                         DJNZ    BL131-1 
  7273    11 0080               BL132:  LD      DE,BUFF         ; <- Zurueck von Zeilen-Prog.aufruf
  7276    23                            INC     HL
  7277    7E                            LD      A,(HL)
  7278    FE 00                         CP      0H
  727A    CA 70A9                       JP      Z,BL00
  727D    12                            LD      (DE),A
  727E    13                            INC     DE
  727F    E6 0F                         AND     0FH
  7281    47                            LD      B,A             ; Laenge der Datei auslesen
  7282    CD 728B                       CALL    BL13
  7285    DA 731F                       JP      C,BL830         ; ERROR DATEI NICHT GEFUNDEN
  7288    C3 7316                       JP      BL84
                                        ;-------------------
                                        ; PROGRAMM AUS (HL) ]BERNEHMEM UND LADEN
                                        ; B= LAENGE DES DATEINAMEN
                                        ; (HL) DATEINAME.COM
                                        ; NACH (DE) BUFFER COPIEREN 
                                
  728B    23                    BL13:   INC     HL
  728C    7E                            LD      A,(HL)
  728D    12                            LD      (DE),A
                                        ;CALL HEXC      ;!!! PROGRAMM NAME SICHTBAR MACHEN ZUM TEST
  728E    13                            INC     DE
  728F    10 FA                         DJNZ    BL13
  7291    AF                            XOR     A
  7292    12                            LD      (DE),A
                                        ;------------------
                                        ;
  7293    11 005D                       LD      DE,FCBFN
  7296    3E 20                         LD      A,20H
  7298    06 0B                         LD      B,0BH
  729A    12                    BL23:   LD      (DE),A
  729B    13                            INC     DE
  729C    10 FC                         DJNZ    BL23
  729E    3E 00                         LD      A,00H
  72A0    06 08                         LD      B,08H
  72A2    12                    BL231:  LD      (DE),A
  72A3    13                            INC     DE
  72A4    10 FC                         DJNZ    BL231
                                        ;--------------
                                        ;
  72A6    E5                            PUSH    HL
  72A7    11 005C                       LD      DE,FCB
  72AA    AF                            XOR     A
  72AB    12                            LD      (DE),A
  72AC    13                            INC     DE
  72AD    21 0080                       LD      HL,BUFF
  72B0    46                            LD      B,(HL)
  72B1    23                            INC     HL
  72B2    7E                    BL33:   LD      A,(HL)
  72B3    FE 2E                         CP      2EH
  72B5    20 06                         JR      NZ,BL43
  72B7    23                            INC     HL
  72B8    11 0065                       LD      DE,FCBFT
        MACRO-80 3.43   27-Jul-81       PAGE    1-13


  72BB    18 F5                         JR      BL33    
                                        ;-----------
  72BD    12                    BL43:   LD      (DE),A
  72BE    13                            INC     DE
  72BF    23                            INC     HL
  72C0    10 F0                         DJNZ    BL33
  72C2    CD 7931                       CALL IDERES
  72C5    AF                            XOR A
  72C6    06 14                         LD B,14H
  72C8    12                    BL53:   LD (DE),A
  72C9    13                            INC DE
  72CA    10 FC                         DJNZ BL53
  72CC    1E 04                         LD E,SELDM              ; MASTER DISK
  72CE    0E 0E                         LD C,14D
  72D0    CD 0005                       CALL 0005H              ; BEZUGSLAUFWERK LW-NUMMER
  72D3    E5                            PUSH HL
  72D4    AF                            XOR A
  72D5    32 006B                       LD (FCBCR),A    ; cr loeschen
  72D8    11 005C                       LD DE,FCB
  72DB    0E 0F                         LD C,0FH
  72DD    CD 0005                       CALL 0005H
  72E0    FE FF                         CP 0FFH
  72E2    20 04                         JR NZ,BL73              ; ->kein Fehler POP HL fehlt
  72E4    E1                            POP HL
  72E5    E1                            POP HL          ; Adresse zurueck
  72E6    37                            SCF
  72E7    C9                            RET
                                        ;--------------------
                                        ;  Dateisatz lesen
                                        ;
  72E8    3A 007C               BL73:   LD A,(FCBRA)
  72EB    11 0100                       LD DE,0100H     ; DMA Buffer
  72EE    FE 00                 BL736:  CP 00H
  72F0    28 09                         JR Z,BL83
  72F2    3D                            DEC A
  72F3    21 0080                       LD HL,0080H
  72F6    19                            ADD HL,DE
  72F7    E5                            PUSH HL
  72F8    D1                            POP DE          ; HL nach DE kopieren
  72F9    18 F3                         JR BL736
  72FB    0E 1A                 BL83:   LD C,1AH                ; Datenbuffer festlegen
  72FD    CD 0005                       CALL 0005H              ; CCP
  7300    E5                            PUSH HL
  7301    D5                            PUSH DE
  7302    C5                            PUSH BC
  7303    11 005C                       LD DE,FCB
  7306    0E 14                         LD C,14H
  7308    CD 0005                       CALL 0005H              ; Datei laden
  730B    C1                            POP BC
  730C    D1                            POP DE
  730D    E1                            POP HL
  730E    FE 00                         CP 00H
  7310    28 D6                         JR Z,BL73               ; wiederhole bie Datei geladen
  7312    E1                            POP HL          ; wenn bei BL53: kein Fehler RAM weiter
  7313    E1                            POP HL          ; Adresse zurueck
  7314    AF                            XOR A
        MACRO-80 3.43   27-Jul-81       PAGE    1-14


  7315    C9                            RET
                                        ;---------------
                                        ; GEFUNDENES PROGRAMM STARTEN
                                        ;
  7316    E5                    BL84:   PUSH HL
  7317    D5                            PUSH DE
  7318    C5                            PUSH BC
  7319    CD 0100                       CALL 0100H
  731C    C1                            POP BC
  731D    D1                            POP DE
  731E    E1                            POP HL
                                        ;------------------
                                        ; Ende der Programme berechnen
  731F    2A 6524               BL830:  LD HL,(RADR)    ; Aktuelle Blasenadresse holen
  7322    46                            LD B,(HL)       ; NAECHSTE DATEI LAENGE
  7323    04                            INC B
  7324    18 01                         JR BL831
  7326    19                            ADD HL,DE
  7327    11 000D               BL831:  LD DE,000DH     ; Laenge (13Dez.) einer Datei
  732A    10 FA                         DJNZ BL831-1    
  732C    23                            INC HL
                                        ;-----------------
                                        ; Sprungadresse in I/O-RAM (0) Laden
                                        ;
  732D    3A 6200               BL04:   LD A,(BLAN)     ; Rueckmeldung aus Unterprogramm
  7330    FE 00                         CP 00H
  7332    CA 706E                       JP Z,BL         ;BL00 Blase neu starten
  7335    FE 01                         CP 01H
  7337    CA 70AC                       JP Z,BL00+3     ; naechster Block 
  733A    C3 70A9                       JP BL00         ; weiter mit RAM
                                ;---------------------------
                                ; Aktuelle Blase im RAM nach Begriff durchsuchen
                                ;
  733D    3A 6001               BL14:   LD A,(RAM+1)    ; Type1
  7340    47                            LD B,A
                                ;??     LD A,(USER) TYPE1
  7341    B8                            CP B
  7342    CA 7345                       JP Z,BS10               ; gefunden
                                ;---------------------------
                                ;  Blase vom Anfang aus nach RAMR laden und Text suchen
                                 
  7345    3A 7FF5               BS10:   LD A,(BF00+RUSER)       ; UEBERNEHMEN
  7348    32 8021                       LD (BF10+RUSER),A       ; loeschen 
  734B    3A 7FF6                       LD A,(BF00+RTYPE1)      ; uebernehmen
  734E    32 8022                       LD (BF10+RTYPE1),A      ; loeschen 
  7351    3A 7FF7                       LD A,(BF00+RTYPE2)      ; uebernehmen 
  7354    32 8023                       LD (BF10+RTYPE2),A      ; loeschen 
  7357    32 8024                       LD (BF10+RTERM),A       ; loeschen 
  735A    32 8025                       LD (BF10+RBSTAT),A      ; loeschen 
  735D    AF                            XOR A
  735E    32 650B                       LD (BFVHH),A    ; Aktuelle Track/Sectoradresse laden
  7361    32 650A                       LD (BFVHL),A
  7364    21 0801                       LD HL,HDD+1     ; Startadresse
  7367    22 6508                       LD (BFVLL),HL   ; Aktuelle Track/Sectoradresse laden
                                ;-------------------------
                                ; Blase zum vergleich laden und Text in Speicher suchen
        MACRO-80 3.43   27-Jul-81       PAGE    1-15


                                ;
  736A    C5                    SU00:   PUSH BC
  736B    D5                            PUSH DE
  736C    E5                            PUSH HL
  736D    CD 78B4                       CALL COFF
  7370    06 50                         LD B,80D
  7372    21 6B27                       LD HL,RAMT
  7375    11 6BEF                       LD DE,RTEX
  7378    7E                    STX01:  LD A,(HL)
  7379    12                            LD (DE),A
  737A    23                            INC HL
  737B    13                            INC DE
  737C    10 FA                         DJNZ STX01
  737E    ED 4B 6508            SU01:   LD BC,(BFVLL)
  7382    ED 5B 650A                    LD DE,(BFVHL)           ; Suchadresse 
  7386    21 6527                       LD HL,RAMV
  7389    CD 7DA5                       CALL RDREAD             ; AKTUELLE BLASE LADEN
                                        ; READ SICHTBAR MACHEN
  738C    01 1501                       LD BC,1501H
  738F    CD 7A91                       CALL LIST
  7392    21 6527                       LD HL,RAMV
  7395    CD 7AB5                       CALL LIS0
  7398    E5                            PUSH HL
  7399    21 0801                       LD HL,HDD+1
  739C    22 6510                       LD (BFSLL+4),HL
  739F    21 0000                       LD HL,0000H
  73A2    22 6512                       LD (BFSHL+4),HL
  73A5    E1                            POP HL
                                        ;---------------------
                                        ; Cursor drehen lassen und
                                        ; nach Abstand gefundener Zeichen setzen
  73A6    CD 7E6D                       CALL UHR00
  73A9    3E 02                         LD A,02H
  73AB    32 651C                       LD (CURT),A
  73AE    3E 04                         LD A,04H
  73B0    32 651D                       LD (CURT+1),A
  73B3    3E 02                         LD A,02H
  73B5    32 651E                       LD (CURT+2),A
  73B8    3A 6B27                       LD A,(RAMT)
  73BB    FE 0A                         CP 0AH
  73BD    38 0E                         JR C,SU02
  73BF    D6 0A                         SUB 0AH
  73C1    32 651F                       LD (CURT+3),A
  73C4    3A 651E                       LD A,(CURT+2)
  73C7    3C                            INC A
  73C8    32 651E                       LD (CURT+2),A
  73CB    18 03                         JR SU03
  73CD    32 651F               SU02:   LD (CURT+3),A
                                        ;------------------------
                                        ; vergleich, suche nach Blasen beginnen
                                        ;
  73D0    CD 7859               SU03:   CALL CUT
  73D3    21 6527                       LD HL,RAMV              ; in Blase suchen mit
  73D6    11 6B27                       LD DE,RAMT              ; Textanfang 1. Zeichen
  73D9    1A                            LD A,(DE)               ; neue TextLAENGE mit
  73DA    FE 02                         CP 02H                  ; Suchtext muss > 1 Zeichen sein
        MACRO-80 3.43   27-Jul-81       PAGE    1-16


  73DC    DA 753B                       JP C,SU52               ; Ausgang ohne suchtext
  73DF    23                            INC HL                  ; ZU USER 
  73E0    3A 7FF5                       LD A,(BF00+RUSER)       ; Aus sichtbarer aktuel Blase
  73E3    BE                            CP (HL)                 ; RAMV VERGLEICH MIT USER IN BLASE 
                                        ;JP Z,SU80              ; User mit Blase ist gleich 
                                        ;JP NC,SU62             ; ERST IN USER+1 LEERE BLASE SUCHEN
  73E4    3A 652B               SU04:   LD A,(RAMV+RTERM)       ; Gedaechtnisszaehler
  73E7    FE FF                         CP 0FFH                 ; nach leerer ,abgelaufener Blase 
  73E9    C2 74B1                       JP NZ,SU62              ; noch nicht leer, abgelaufen
  73EC    3A 6003                       LD A,(RAM+RTYPE2)       ; MUSS BLASENANFANG SEIN
  73EF    FE 00                         CP 0H                   ; nach leerer ,abgelaufener Blase 
  73F1    C2 753B                       JP NZ,SU52              ; noch nicht leer, abgelaufen
                                ;-----------------------
                                ; neue Blase Eroeffnen mit Eingabetext 
                                ; als Ueberschrift
                                ;
                                ; Blasenadr. BFVxx mit BFRxx tauschen (HL)->(DE)
                                ;               
  73F4    11 6500                       LD DE,BFRLL     ; Aktuelle Blaseadresse ersetzen durch
  73F7    21 6508                       LD HL,BFVLL     ; Leere gefundene Blase
  73FA    EB                            EX DE,HL        ; TAUSCHEN
                                        ;----------------
  73FB    3A 8023                       LD A,(BF10+RTYPE2)
  73FE    FE 00                         CP 0H
  7400    28 19                         JR Z,SU85
  7402    06 19                         LD B,25D                ; laenge DES KOPFTEXT AUS Blase einkopieren
  7404    11 601B                       LD DE,RAM+1BH   ; Adr. Aktueller Blase
  7407    21 8391                       LD HL,TBLASE+1BH        ; Textblock leerer Blase
  740A    1A                    SU88:   LD A,(DE)
  740B    77                            LD (HL),A
  740C    23                            INC HL
  740D    13                            INC DE
  740E    10 FA                         DJNZ SU88
  7410    06 58                         LD B,TBLLE      ; laenge neuer Blase einkopieren
  7412    11 6000                       LD DE,RAM       ; Adr. Aktueller Blase
  7415    21 8376                       LD HL,TBLASE    ; Textblock leerer Blase
  7418    C3 7423                       JP SU82
                                        ;---------------
  741B    06 B0                 SU85:   LD B,NBLLE      ; laenge neuer Blase einkopieren
  741D    11 6000                       LD DE,RAM       ; Adr. Aktueller Blase
  7420    21 82C6                       LD HL,NBLASE    ; Textblock leerer Blase
  7423    7E                    SU82:   LD A,(HL)       ; kopieren
  7424    12                            LD (DE),A
  7425    23                            INC HL
  7426    13                            INC DE
  7427    10 FA                         DJNZ SU82
  7429    11 6001                       LD DE,RAM+1     ; Aktuelle USER
                                        ;----------------
                                        ; Ueberschrift aus suchtext einsetzen
  742C    3A 6B27                       LD A,(RAMT)
  742F    47                            LD B,A          ; Textlaenge in B
  7430    11 6000                       LD DE,RAM
  7433    13                    SU83:   INC DE          ; Nach Space 20H suchen erstes Zeichen
  7434    1A                            LD A,(DE)
  7435    FE 20                         CP 20H
  7437    20 FA                         JR NZ,SU83
        MACRO-80 3.43   27-Jul-81       PAGE    1-17


                                        ;-----------------
  7439    21 6B28                       LD HL,RAMT+1    ; erstes Zeichen
  743C    7E                    SU84:   LD A,(HL)               ; uebertrageb bis B=0
  743D    12                            LD (DE),A
  743E    23                            INC HL
  743F    13                            INC DE
  7440    10 FA                         DJNZ SU84
                                        ;-----------------      
                                        ; BF10 IN NEU GEFUNDENE BLASE ]BERNEHMEN
                                        ; RUSER, RTYPE1+1, RTYPE2
                                        ;
  7442    3A 8021                       LD A,(BF10+RUSER)
  7445    32 6001                       LD (RAM+RUSER),A        ; Aktueller USER uebernehmen
  7448    3A 8023                       LD A,(BF10+RTYPE2)
  744B    FE 00                         CP 0
  744D    28 0B                         JR Z,SU86
  744F    3A 7FF6                       LD A,(BF00+RTYPE1)      ; uebernehmen 
  7452    32 6002                       LD (RAM+RTYPE1),A       ; uebernehmen 
  7455    3A 8023                       LD A,(BF10+RTYPE2)      ; uebernehmen 
                                        ;LD (RAM+RTYPE2),A      ; uebernehmen 
  7458    18 0D                         JR SU87 
  745A    3A 8022               SU86:   LD A,(BF10+RTYPE1)      ; uebernehmen 
  745D    3C                            INC A
  745E    32 6002                       LD (RAM+RTYPE1),A       ; uebernehmen 
  7461    3A 8023                       LD A,(BF10+RTYPE2)      ; uebernehmen 
  7464    32 6003                       LD (RAM+RTYPE2),A       ; uebernehmen 
                                        ;------------------
  7467    E1                    SU87:   POP HL
  7468    D1                            POP DE
  7469    C1                            POP BC
  746A    C3 70A9                       JP BL00
                                        ; ENDE neue Blase anspringen
                                        ;--------------------------
                                        ; weiter vergleichen
                                
  746D    23                    SU80:   INC HL          ; zu TYPE1 in RAMV
  746E    23                            INC HL          ; ZU TYPE2 IN RAMV
  746F    3A 8023                       LD A,(BF10+RTYPE2)
                                        ;CP (HL)
  7472    B6                            OR (HL)
  7473    CA 74F4                       JP Z,SU90
  7476    23                            INC HL          ; Gedaechtnisz. TERM 
  7477    3A 8024                       LD A,(BF10+RTERM)       ; 
  747A    BE                            CP (HL)
  747B    CA 74B1                       JP Z,SU62               ; nicht =1
  747E    23                            INC HL          ; Status Byte
  747F    23                            INC HL          ; ZEICHENAUSWERTUNG
  7480    13                            INC DE          ; ERSTES SUCHZEICHEN IN RAMT
  7481    1A                            LD  A,(DE)              ; 1. ZEICHEN MUSS '/' SEIN
  7482    FE 2F                         CP '/'
  7484    28 07                         JR Z,SU25
  7486    AF                            XOR A
  7487    32 8023                       LD (BF10+RTYPE2),A      ; '/' fehlt dann TYPE2=0 und TYPE1 SUCHEN
  748A    C3 74B1                       JP SU62         ; WEITER NACH TYPE1+TYPE2=0 SUCHEN->
                                        ;------------
  748D    3A 6002               SU25:   LD A,(RAM+RTYPE1)
        MACRO-80 3.43   27-Jul-81       PAGE    1-18


  7490    47                            LD B,A
  7491    3A 6529                       LD A,(RAMV+RTYPE1)
  7494    B8                            CP B
  7495    C2 74B1                       JP NZ,SU62
  7498    3A 652A                       LD A,(RAMV+RTYPE2)
  749B    FE 01                         CP 1H
  749D    DA 74B1                       JP C,SU62
  74A0    C2 74B1                       JP NZ,SU62
  74A3    3A 6B27                       LD A,(RAMT)     ; neuer Text mit
  74A6    06 3F                         LD B,03FH               ; laenge (255D) eine Zeile zum vergleichen
  74A8    CD 797F               SU21:   CALL SUCH0
  74AB    DA 74B1                       JP C,SU62
                                        ;CALL MAS00
  74AE    C3 755D                       JP SU23
                                        ; Error anzeigen ??
                                        ; Bereich Ende xxxxxxxx1, xxxxxxx2, .... ????
                                        ; noch einbauen
                                        ;
  74B1    CD 79A9               SU62:   CALL KEYST      ; CONSOLE AUF ZEICHEN ABFRAGE
  74B4    FE 1B                         CP 1BH
  74B6    CA 753B                       JP Z,SU52       ; ABBRUCH MIT ESC
  74B9    ED 5B 6508                    LD DE,(BFVLL)   ; Aktuelle Track/Sectoradresse laden
  74BD    D5                            PUSH DE
  74BE    2A 650A                       LD HL,(BFVHL)
  74C1    E5                            PUSH HL
  74C2    CD 79BD                       CALL LBA0               ; Suchadresse +1
  74C5    E1                            POP HL
  74C6    22 650A                       LD (BFVHL),HL   
  74C9    D1                            POP DE
  74CA    ED 53 6508                    LD (BFVLL),DE           ; Suchadresse speichern
  74CE    38 6B                         JR C,SU52       ; CARRY -> ENDE
  74D0    18 11                         JR SU63
                                        ;--------------
  74D2    ED 4B 801E                    LD BC,(BF07+2)          ; HL
  74D6    ED 42                         SBC HL,BC
  74D8    38 09                         JR C,SU63
  74DA    EB                            EX DE,HL
  74DB    ED 4B 801C                    LD BC,(BF07)            ; LL
  74DF    ED 42                         SBC HL,BC               
  74E1    30 58                         JR NC,SU52              ; LETZTE SUCHADRESSE AUS TAS00 
  74E3    7B                    SU63:   LD A,E
  74E4    E6 1F                         AND 1FH
  74E6    FE 10                         CP 10H
  74E8    C2 737E                       JP NZ,SU01
  74EB    CD 7859                       CALL CUT
  74EE    CD 7839                       CALL SANDU
  74F1    C3 737E                       JP SU01
                                        ;--------------------------
                                        ; weiter vergleichen
                                        ; fuer naechste neue Blase vorbereiten 
                                        ; und in neuer Blase uebernehmen
  74F4    2B                    SU90:   DEC HL          ; ZURUECK ZU TYPE1
  74F5    3A 8022                       LD A,(BF10+RTYPE1)      ; Type1 
  74F8    BE                            CP (HL)
  74F9    30 09                         JR NC,SU99
  74FB    3C                            INC A
        MACRO-80 3.43   27-Jul-81       PAGE    1-19


  74FC    28 06                         JR Z,SU99               ; groesser 0FFH
  74FE    BE                            CP (HL)
  74FF    20 03                         JR NZ,SU99              ; Abstand groesser 1
  7501    32 8022                       LD (BF10+RTYPE1),A      ; Type1 wenn groesser uebernehmen
  7504    23                    SU99:   INC HL          ; Type2 in Blase
                                ;--------------------------
                                ;       hier auf erste Type2 =0 selektiert aus Blase
                                ;
  7505    3A 8023                       LD A,(BF10+RTYPE2)      ; Type2 aus RAMV Blase
  7508    BE                            CP (HL)
  7509    C2 74B1                       JP NZ,SU62              ; NEUE RAMV BLASE nicht =0 
                                ;--------------------------
                                ; wenn Gedaechtnisszaehler =0 dann ungueltig
                                ; frei fuer neue Blase
  750C    23                            INC     HL              ; Gedaechtnisz. TERM 
  750D    3A 8024                       LD      A,(BF10+RTERM)  ; Gedaechtnisz. aus Blase
  7510    BE                            CP      (HL)
  7511    CA 74B1                       JP      Z,SU62          ; nicht =1 ->
  7514    23                            INC     HL              ; Status Byte
  7515    23                            INC     HL              ; ZeichenGROESSE
  7516    1A                            LD      A,(DE)          ; neuer Text mit
  7517    47                            LD      B,A
  7518    13                            INC     DE              ; ERSTES ZEICHEN
                                        ;--------------------
                                        ; ERSTES ZEICHEN GROSS
  7519    1A                            LD      A,(DE)
  751A    FE 5B                         CP      5BH
  751C    D2 753B                       JP      NC,SU52         ; ERSTES ZEICHEN MUSS GROSS BUCHST.SEIN
                                        ;--------------------
  751F    78                            LD      A,B
  7520    06 3F                         LD      B,3FH           ; laenge (46D) eine Zeile zum vergleichen
  7522    CD 797F                       CALL    SUCH0
  7525    DA 74B1                       JP      C,SU62
  7528    3A 6529                       LD      A,(RAMV+RTYPE1) ; WENN BLASE GEFUNDEN TYPE1 UEBERNEHMEN
  752B    32 8022                       LD      (BF10+RTYPE1),A ; Type1 =0 wenn BLASE GEFUNDEN
  752E    3A 8023                       LD      A,(BF10+RTYPE2) ; BLASE TYPE1 GEFUNDEN
  7531    3C                            INC     A               ;SET    0,A >0 SETZEN F]R TYPE2 SUCHEN
  7532    32 8023                       LD      (BF10+RTYPE2),A
  7535    C3 755D                       JP      SU23
                                ;-----------------------
                                ; Kein Eintrag in TYPE2>0 gefunden
                                ;       
  7538    C3 70A9               SU95:   JP BL00
                                ;----------------
                                ;
  753B    21 8245               SU52:   LD HL,MELD01
  753E    06 36                         LD B,MELD01X
  7540    0E 02                         LD C,02H                ; BIOS Console Output
  7542    CD 7FE8                       CALL BIOS
  7545    11 0000                       LD DE,0000H
  7548    06 08                         LD B,08H
  754A    3E 00                         LD A,00H
  754C    32 6B27                       LD (RAMT),A
  754F    15                    SU520:  DEC D
  7550    20 FD                         JR NZ,SU520
  7552    1D                            DEC E
        MACRO-80 3.43   27-Jul-81       PAGE    1-20


  7553    20 FA                         JR NZ,SU520
  7555    10 F8                         DJNZ SU520
  7557    E1                            POP HL
  7558    D1                            POP DE
  7559    C1                            POP BC
  755A    C3 70A9                       JP BL00
                                        ;----------------
                                        ; AKTUELLE MIT GEFUNDENE BLASE TAUSCHEN
                                        ; DANN NEUE BLASE ANZEIGEN      
  755D    06 04                 SU23:   LD B,04H
  755F    11 6500                       LD DE,BFRLL
  7562    21 6508                       LD HL,BFVLL
  7565    7E                    SU32:   LD A,(HL)
  7566    12                            LD (DE),A
  7567    23                            INC HL
  7568    13                            INC DE 
  7569    10 FA                         DJNZ SU32
                                        ; EINGABEZEILE LOESCHEN
  756B    01 2401                       LD BC,2401H
  756E    CD 7A91                       CALL LIST
  7571    06 46                         LD B,70D
  7573    3E 20                 SU33:   LD A,20H
  7575    CD 7894                       CALL HEXC
  7578    10 F9                         DJNZ SU33
  757A    E1                            POP HL
  757B    D1                            POP DE
  757C    C1                            POP BC
  757D    C3 706E                       JP BL
                                ;------------------------
                                ;       Starte Eingabemode
                                ;
  7580    C5                    EING:   PUSH BC
  7581    D5                            PUSH DE
  7582    E5                            PUSH HL
                                        ;------------------------
                                        ; pruefe auf Anfangsadresse BLASE = RAM
                                        ;       
  7583    2A 6524                       LD HL,(RADR)    ; zuletzten Blasenabschnitt Adr.0
  7586    3E 00                         LD A,00H
  7588    32 6B27                       LD (RAMT),A     ; ZEICHEN EINGABEZAEHLER AUF 0 SETZEN
  758B    BE                            CP (HL)
  758C    20 18                         JR NZ,ED00
  758E    AF                            XOR A
  758F    11 6000                       LD DE,RAM
  7592    ED 52                         SBC HL,DE
  7594    20 34                         JR NZ,ED10              ; -> ADRESSE NICHT GLEICH
                                        ;--------------------
                                        ; (RADR) = RAM und kein Zechen 
                                        ; dann Blase mit 00H ueberschreiben 2*256lang
                                        ;
  7596    06 00                         LD B,00H
  7598    3E 00                 ED01:   LD A,00H                ; RAM 256 auf null setzen
  759A    77                            LD (HL),A
  759B    23                            INC HL
  759C    10 FA                         DJNZ ED01
  759E    06 00                         LD B,00H
        MACRO-80 3.43   27-Jul-81       PAGE    1-21


  75A0    3E 00                 ED02:   LD A,00H                ; RAM 256 auf null setzen
  75A2    77                            LD (HL),A
  75A3    23                            INC HL
  75A4    10 FA                         DJNZ ED02
                                        ;---------------------
                                        ; Blasenanfang bestimmen
                                        ;
  75A6    2A 6524               ED00:   LD HL,(RADR)
                                ;       LD B,(HL)
  75A9    06 F0                         LD B,0F0H               ; Max Zeicheneingabe
  75AB    AF                            XOR A
  75AC    11 6000                       LD DE,RAM
  75AF    ED 52                         SBC HL,DE
  75B1    2A 6524                       LD HL,(RADR)
  75B4    20 14                         JR NZ,ED10              ; -> kein Blasenanfang
  75B6    23                            INC HL
  75B7    3A 6201                       LD A,(USER)     ; in Blase uebernemen
  75BA    77                            LD (HL),A
  75BB    23                            INC HL
  75BC    3A 6202                       LD A,(TYPE1)
  75BF    77                            LD (HL),A
  75C0    23                            INC HL
  75C1    3A 6203                       LD A,(TYPE2)
  75C4    77                            LD (HL),A
  75C5    23                            INC HL          ; Gedaechtniss Zaehler
  75C6    3E 7F                         LD A,07FH               ; auf 50% setzen
  75C8    77                            LD (HL),A
  75C9    23                            INC HL          ; Status Byte
                                        ;------------------------
                                        ;  Grafik/Text ausgeben
                                        ;
  75CA    C5                    ED10:   PUSH BC
  75CB    01 0301                       LD BC,0301H
  75CE    CD 7A91                       CALL LIST
  75D1    2A 6524                       LD HL,(RADR)
  75D4    3A 6B27                       LD A,(RAMT)
  75D7    3C                            INC A
  75D8    47                            LD B,A
  75D9    AF                            XOR A           ; RES CARRY FLAG
  75DA    11 6000                       LD DE,RAM
  75DD    ED 52                         SBC HL,DE       ; Blasen Anfang pruefen
  75DF    2A 6524                       LD HL,(RADR)
  75E2    20 0E                         JR NZ,ED100
  75E4    3E 05                         LD A,05H
  75E6    85                            ADD A,L         ; Versatz an Blasenanfang
  75E7    6F                            LD L,A          ; USER, TYPE1, TYPE2, GE, GS, 
  75E8    3E 00                         LD A,00H
  75EA    32 651C                       LD (CURT),A
  75ED    3E 01                         LD A,01H
  75EF    32 651D                       LD (CURT+1),A
  75F2    CD 7859               ED100:  CALL CUT
  75F5    23                    ED11:   INC HL          ; erstes Zeichen
  75F6    10 03                         DJNZ ED03
  75F8    C1                            POP BC
  75F9    18 0C                         JR ED12
                                        ;----------------
        MACRO-80 3.43   27-Jul-81       PAGE    1-22


                                        ; Zeichen ausgeben
                                        ;
  75FB    C5                    ED03:   PUSH BC
  75FC    E5                            PUSH HL
  75FD    5E                            LD E,(HL)
  75FE    0E 02                         LD C,02H
  7600    CD 0005                       CALL 0005H
  7603    E1                            POP HL
  7604    C1                            POP BC
  7605    18 EE                         JR ED11
                                        ;---------------------
                                        ; Tasteneingabe
                                        ;       
  7607    C5                    ED12:   PUSH BC
  7608    E5                            PUSH HL
  7609    CD 79A9               _ED12:  CALL KEYST
  760C    FE 00                         CP 0H
  760E    28 F9                         JR Z,_ED12      ; -> KEIN ZEICHEN
  7610    5F                            LD E,A          ; neues Zeichen
  7611    E1                            POP HL
  7612    C1                            POP BC
  7613    FE 20                         CP 20H
  7615    38 2E                         JR C,ED30       ; wenn Zeichen < 20H
  7617    FE 23                         CP 23H          ; # Zeichen fuer Eingabenende
  7619    CA 763F                       JP Z,ED20
  761C    CD 76C6                       CALL ED50
                                        ;-------------------
                                        ; Rechts Parameter anzeichen
                                        ;
  761F    7E                    ED13:   LD A,(HL)       ; letztes Zeichen zurueckladen
  7620    5F                            LD E,A          ; und Anzeigen aus Reg. E
  7621    C5                            PUSH BC
  7622    01 0578                       LD BC,0578H
                                        ;CALL LIST
  7625    4E                            LD C,(HL)
  7626    C5                            PUSH BC
  7627    CD 781C                       CALL HEX14
  762A    C1                            POP BC
  762B    01 0473                       LD BC,0473H
  762E    CD 7A91                       CALL LIST
  7631    C1                            POP BC
  7632    C5                            PUSH BC
  7633    3A 6B27                       LD A,(RAMT)
  7636    4F                            LD C,A
  7637    C5                            PUSH BC
  7638    CD 781C                       CALL HEX00
  763B    C1                            POP BC
  763C    C1                            POP BC
  763D    10 03                 ED14:   DJNZ ED15               ; ED12
  763F    C3 76DD               ED20:   JP EING11
  7642    C3 75CA               ED15:   JP ED10
                                ;-------------------------
                                ; Steuerzeichen Auswerten
                                
  7645    FE 0D                 ED30:   CP 0DH          ; CR
  7647    28 2B                         JR Z,ED40
        MACRO-80 3.43   27-Jul-81       PAGE    1-23


  7649    FE 08                         CP 08H          ; Backspase
  764B    28 32                         JR Z,ED41
  764D    FE 09                         CP 09H
  764F    28 3D                         JR Z,ED42               ; TAB
  7651    FE 1B                         CP 1BH          ; ESC
  7653    28 3E                         JR Z,ED43
  7655    FE 08                         CP 08H          ; ESC
  7657    28 3F                         JR Z,ED44               ; BackSpace
  7659    C5                            PUSH BC
  765A    E5                            PUSH HL
  765B    06 80                         LD B,80H
  765D    10 FE                 ED31:   DJNZ ED31
  765F    CD 79A9                       CALL KEYST      ; CONSOLE AUF ZEICHEN ABFRAGE
  7662    FE 00                         CP 0
  7664    28 0A                         JR Z,ED32
  7666    C5                            PUSH BC
  7667    4F                            LD C,A
  7668    C5                            PUSH BC
  7669    CD 781C                       CALL HEX14
  766C    C1                            POP BC
  766D    C1                            POP BC
  766E    18 EB                         JR ED31-2
                                        ;-----------
  7670    E1                    ED32:   POP HL
  7671    C1                            POP BC
  7672    18 AB                 ED33:   JR ED13
                                ;--------------------------
                                ;
  7674    CD 76C6               ED40:   CALL ED50
  7677    23                            INC HL
  7678    3E 0A                         LD A,0AH
  767A    CD 76C6                       CALL ED50
                                ;       INC HL
  767D    18 F3                         JR ED33
                                        ;-------------
  767F    3E 20                 ED41:   LD A,20H                ; Zeichen loeschen
  7681    77                            LD (HL),A
  7682    3A 6B27                       LD A,(RAMT)
  7685    D6 01                         SUB 01H
  7687    38 E9                         JR C,ED33
  7689    32 6B27                       LD (RAMT),A
  768C    18 E4                         JR ED33
                                        ;-----------
  768E    CD 76C6               ED42:   CALL ED50
                                ;       INC HL
  7691    18 DF                         JR ED33
                                        ;------------
  7693    CD 76C6               ED43:   CALL ED50
                                ;       INC HL
  7696    18 DA                         JR ED33
                                        ;-----------
  7698    E5                    ED44:   PUSH HL
  7699    C5                            PUSH BC
  769A    3A 6524                       LD A,(RADR)
  769D    FE 00                         CP 00H
  769F    28 21                         JR Z,ED442
        MACRO-80 3.43   27-Jul-81       PAGE    1-24


  76A1    3A 6B27                       LD A,(RAMT)
  76A4    FE 00                         CP 00H
  76A6    28 1A                         JR Z,ED442
  76A8    01 0002                       LD BC,0002H
  76AB    7E                    ED441:  LD A,(HL)
  76AC    2B                            DEC HL
  76AD    77                            LD (HL),A
  76AE    23                            INC HL
  76AF    23                            INC HL
  76B0    10 F9                         DJNZ ED441
  76B2    0D                            DEC C
  76B3    20 F6                         JR NZ,ED441
  76B5    2A 6524                       LD HL,(RADR)
  76B8    35                            DEC (HL)
  76B9    2A 6B27                       LD HL,(RAMT)
  76BC    35                            DEC (HL)
  76BD    C1                            POP BC
  76BE    E1                            POP HL
  76BF    2B                            DEC HL
  76C0    18 B0                         JR ED33
                                        ;-----------
  76C2    C1                    ED442:  POP BC
  76C3    E1                            POP HL
  76C4    18 AC                         JR ED33
                                ;--------------------------
                                ; Zeichenzaehler vergleichen
                                ; RAM-Aktuell mit RAM-Text
  76C6    77                    ED50:   LD (HL),A
  76C7    3A 6B27                       LD A,(RAMT)
  76CA    3C                            INC A
  76CB    32 6B27                       LD (RAMT),A
  76CE    C9                            RET
                                        ;--------
  76CF    4F                            LD C,A
  76D0    E5                            PUSH HL
  76D1    2A 6524                       LD HL,(RADR)
  76D4    7E                            LD A,(HL)
  76D5    B9                            CP C
  76D6    D2 76DB                       JP NC,ED51              ; RAMT > RADR dann RADR+1
  76D9    3C                            INC A
  76DA    77                            LD (HL),A
  76DB    E1                    ED51:   POP HL
  76DC    C9                            RET
                                        ;-----------------------
                                        ; KEY Stepps Eingabe in HEX
                                        ; 
  76DD    E5                    EING11: PUSH HL
  76DE    2A 6524                       LD HL,(RADR)
  76E1    3A 6B27                       LD A,(RAMT)
  76E4    77                            LD (HL),A
  76E5    21 8228                       LD HL,KEYZ
  76E8    06 1D                         LD B,KEYZX
  76EA    0E 02                         LD C,02H                ; BIOS Console Output
  76EC    CD 7FE8                       CALL BIOS
                                        ;------------------------
  76EF    E1                            POP HL
        MACRO-80 3.43   27-Jul-81       PAGE    1-25


  76F0    C5                            PUSH BC
  76F1    4E                            LD C,(HL)               ; Speicher Lesen 
  76F2    C5                            PUSH BC
  76F3    CD 781C                       CALL HEX00
  76F6    C1                            POP BC
  76F7    C1                            POP BC
  76F8    E5                            PUSH HL
  76F9    CD 7AC2                       CALL TAS
  76FC    5F                            LD E,A
  76FD    CD 77BA                       CALL HEXI1
  7700    D5                            PUSH DE
  7701    CD 7AC2                       CALL TAS
  7704    D1                            POP DE
  7705    5F                            LD E,A
  7706    CD 77CD                       CALL HEXI2
  7709    E1                            POP HL
                                ;       LD D,10H
  770A    72                            LD (HL),D
  770B    23                            INC HL
                                        ;-----------------
                                        ; Dateiaufruf
                                        ; Text ausgeben
                                        ;
  770C    E5                    EING21: PUSH HL
  770D    21 827B                       LD HL,PROZ
  7710    06 25                         LD B,PROZX
  7712    0E 02                         LD C,02H                ; BIOS Console Output
  7714    CD 7FE8                       CALL BIOS
                                        ;------------------------
  7717    06 0C                         LD      B,0CH           ; Dateinamenlaenge
  7719    0E 00                         LD      C,00H           ; loeschen
  771B    E1                            POP     HL
  771C    C5                    EING22: PUSH    BC
  771D    D5                            PUSH    DE
  771E    5E                            LD      E,(HL)          ; Speicher Lesen 
  771F    E5                            PUSH    HL
  7720    D5                            PUSH    DE
  7721    C5                            PUSH BC
  7722    4B                            LD C,E
  7723    C5                            PUSH BC
  7724    CD 781C                       CALL    HEX00           ; HEX Anzeigen
  7727    C1                            POP BC
  7728    C1                            POP BC
  7729    CD 7AC2                       CALL    TAS     ; ZEICHEN EINGABE
  772C    D1                            POP     DE
  772D    E1                            POP     HL
  772E    77                            LD      (HL),A          ; Tasteneingabee retten
  772F    D1                            POP     DE
  7730    C1                            POP     BC
  7731    FE 2E                         CP      2EH             ; Dateineman Ende
  7733    20 02                         JR      NZ,EING23       ; -> noch nicht
  7735    06 04                         LD      B,04H           ; Zaehler aus Erweiterung set
  7737    3E 0C                 EING23: LD      A,0CH           ; Dateinamenlaenge
  7739    B8                            CP      B
  773A    20 1A                         JR      NZ,EING25       ; -> kein Anfang mehr
  773C    7E                            LD      A,(HL)          ; Tastein ASCII -> 0-9 unr.
        MACRO-80 3.43   27-Jul-81       PAGE    1-26


  773D    D6 30                         SUB     30H
  773F    38 2E                         JR      C,EING26
  7741    FE 0A                         CP      0AH
  7743    38 02                         JR      C,EING24
  7745    D6 07                         SUB     07H
  7747    E6 0F                 EING24: AND     0FH
  7749    4F                            LD      C,A
  774A    77                            LD      (HL),A          ; Speichern
  774B    FE 00                         CP      00H
  774D    28 20                         JR      Z,EING26        ; Ende -> Ausgang
  774F    E5                            PUSH    HL
  7750    D1                            POP     DE              ; HL -> DE
  7751    13                            INC     DE
  7752    3E FF                         LD      A,0FFH
  7754    12                            LD      (DE),A
  7755    23                            INC     HL
  7756    23                    EING25: INC     HL
  7757    1A                            LD      A,(DE)
  7758    3C                            INC     A
  7759    12                            LD      (DE),A          ; Dateiname Zeichezaehler +1
  775A    10 C0                         DJNZ    EING22
  775C    47                            LD      B,A             ; naechste Dateiadresse berechnen
  775D    3E 0C                         LD      A,0CH
  775F    90                            SUB     B
  7760    16 00                         LD      D,00H
  7762    5F                            LD      E,A
  7763    19                            ADD     HL,DE
  7764    E5                            PUSH    HL
  7765    D1                            POP     DE
  7766    3E 00                         LD      A,00H
  7768    12                            LD      (DE),A
  7769    23                            INC     HL
  776A    06 0B                         LD      B,0BH
  776C    0D                            DEC     C
  776D    20 AD                         JR      NZ,EING22
  776F    06 0F                 EING26: LD      B,0FH
  7771    AF                    EING27: XOR     A
  7772    77                            LD      (HL),A
  7773    23                            INC     HL
  7774    10 FB                         DJNZ    EING27
  7776    C3 70A9                       JP BL00         ; PUSH POP ???
  7779    E1                    EING30: POP HL
  777A    D1                            POP DE
  777B    C1                            POP BC
  777C    C3 70A9                       JP BL00
                                ;-------------------------
                                ; TYPE2 MASKE AUFBAUEN
                                
  777F    3A 6000               MAS00:  LD A,(RAM)
  7782    47                            LD B,A          ; ZEICHENL$NGE ZUM ANHAENGEN
                                        ; CURSOR AUF XXXXZEILE 1 SETZEN
  7783    3E 00                         LD A,00H
  7785    32 651C                       LD (CURT),A
  7788    3E 01                         LD A,01H
  778A    32 651D                       LD (CURT+1),A
                                        ;------------------
        MACRO-80 3.43   27-Jul-81       PAGE    1-27


                                        ; CURSOR RECHTR SCHIEBEN
                                
  778D    3E 00                         LD A,00H
  778F    3C                    MAS01:  INC A
  7790    27                            DAA
  7791    10 FC                         DJNZ MAS01
  7793    47                            LD B,A
  7794    E6 0F                         AND 0FH
  7796    32 651F                       LD (CURT+3),A
  7799    78                            LD A,B
  779A    0F                            RRCA
  779B    0F                            RRCA
  779C    0F                            RRCA
  779D    0F                            RRCA
  779E    E6 0F                         AND 0FH
  77A0    32 651E                       LD (CURT+2),A
  77A3    CD 7859                       CALL CUT
  77A6    11 6B27                       LD DE,RAMT
  77A9    1A                            LD A,(DE)
  77AA    47                            LD B,A
  77AB    13                    MAS02:  INC DE
  77AC    1A                            LD A,(DE)
  77AD    CD 7894                       CALL HEXC
  77B0    10 F9                         DJNZ MAS02
  77B2    C9                            RET     
  77B3    C3 753B                       JP SU52
                                ;-------------------------
                                ; Programmaufruf mit Cursor up/down
                                
  77B6    00                    ZEI00:  NOP
  77B7    C3 7273                       JP      BL132
                                
                                ;-------------------------
                                ;   Hexunwandlung
                                
  77BA    7B                    HEXI1:  LD A,E          ; Eingabe Umwandeln
  77BB    D6 30                         SUB 30H
  77BD    38 1D                         JR C,HEXIE
  77BF    FE 0A                         CP 0AH
  77C1    38 02                         JR C,HEX11
  77C3    D6 07                         SUB 07H
  77C5    07                    HEX11:  RLCA
  77C6    07                            RLCA
  77C7    07                            RLCA
  77C8    07                            RLCA
  77C9    E6 F0                         AND 0F0H
  77CB    57                            LD D,A
  77CC    C9                            RET
                                        ;-----------
  77CD    7B                    HEXI2:  LD A,E          ; Adresse anzeigen
  77CE    D6 30                         SUB 30H
  77D0    38 0A                         JR C,HEXIE
  77D2    FE 0A                         CP 0AH
  77D4    38 02                         JR C,HEX12
  77D6    D6 07                         SUB 07H
  77D8    E6 0F                 HEX12:  AND 0FH
        MACRO-80 3.43   27-Jul-81       PAGE    1-28


                                        ;ADD A,D        ; ??
                                        ;LD D,A ; ??
  77DA    5F                            LD E,A
  77DB    C9                            RET
                                        ;--------
  77DC    06 01                 HEXIE:  LD B,01H
  77DE    C9                            RET
                                ;-------------------------
                                ;  HEX Ausgabe mit Position
                                ;
  77DF    3A 651C               HEXP:   LD A,(CURT)
  77E2    F5                            PUSH AF
  77E3    3A 651D                       LD A,(CURT+1)
  77E6    F5                            PUSH AF
  77E7    3A 651E                       LD A,(CURT+2)
  77EA    F5                            PUSH AF
  77EB    3A 651F                       LD A,(CURT+3)
  77EE    F5                            PUSH AF
  77EF    C5                            PUSH BC
  77F0    01 0150                       LD BC,0150H
  77F3    CD 7A91                       CALL LIST
  77F6    4B                            LD C,E
  77F7    C5                            PUSH BC
  77F8    CD 781C                       CALL HEX00
  77FB    C1                            POP BC
  77FC    C1                            POP BC
  77FD    F1                            POP AF
  77FE    32 651F                       LD (CURT+3),A
  7801    F1                            POP AF
  7802    32 651E                       LD (CURT+2),A
  7805    F1                            POP AF
  7806    32 651D                       LD (CURT+1),A
  7809    F1                            POP AF
  780A    32 651C                       LD (CURT),A
  780D    CD 7859                       CALL CUT
  7810    C9                            RET
                                ;-------------------------
                                ;  Hex ausgeben
  7811    3E 0A                 HEXA:   LD A,0AH
  7813    CD 7894                       CALL HEXC
  7816    3E 0D                         LD A,0DH
  7818    CD 7894                       CALL HEXC
  781B    C9                            RET
                                ;------------------
  781C                          HEX00:  
  781C    DD E5                 HEX14:  PUSH IX
  781E    DD 21 0000                    LD IX,0
  7822    DD 39                         ADD IX,SP
                                ;---------
  7824    DD 4E 04                      LD C,(IX+4)             ; Adresse anzeigen
  7827    C5                            PUSH BC
  7828    CD 7EC7                       CALL ASCII_CODE
  782B    C1                            POP BC
  782C    78                            LD A,B
  782D    CD 7894                       CALL HEXC
  7830    79                            LD A,C          ; ADRESSE ANZEIGEN
        MACRO-80 3.43   27-Jul-81       PAGE    1-29


  7831    CD 7894                       CALL HEXC
                                ;-----------
  7834    DD F9                         LD SP,IX
  7836    DD E1                         POP IX
  7838    C9                            RET
                                ;------------------------
                                ; Warte schlange
                                
  7839    C5                    SANDU:  PUSH BC
  783A    D5                            PUSH DE
  783B    E5                            PUSH HL
  783C    3A 6520                       LD A,(SANDB)
  783F    FE 2F                         CP 2FH  
  7841    38 06                         JR C,SA1
  7843    28 08                         JR Z,SA2
  7845    3E 2D                         LD A,2DH
  7847    18 06                         JR SA3
  7849    3E 2F                 SA1:    LD A,2FH
  784B    18 02                         JR SA3
  784D    3E 5C                 SA2:    LD A,5CH
  784F    32 6520               SA3:    LD (SANDB),A
  7852    CD 7894                       CALL HEXC
  7855    E1                            POP HL
  7856    D1                            POP DE
  7857    C1                            POP BC
  7858    C9                            RET
                                ;------------------------
                                ; Cursor auf Position setzen
                                ;
  7859    C5                    CUT:    PUSH BC
  785A    D5                            PUSH DE
  785B    E5                            PUSH HL
  785C    3E 1B                         LD A,1BH
  785E    CD 7894                       CALL HEXC
  7861    3E 5B                         LD A,5BH
  7863    CD 7894                       CALL HEXC
  7866    3A 651C                       LD A,(CURT)
  7869    C6 30                         ADD A,30H
  786B    CD 7894                       CALL HEXC
  786E    3A 651D                       LD A,(CURT+1)
  7871    C6 30                         ADD A,30H
  7873    CD 7894                       CALL HEXC
  7876    3E 3B                         LD A,3BH
  7878    CD 7894                       CALL HEXC
  787B    3A 651E                       LD A,(CURT+2)
  787E    C6 30                         ADD A,30H
  7880    CD 7894                       CALL HEXC
  7883    3A 651F                       LD A,(CURT+3)
  7886    C6 30                         ADD A,30H
  7888    CD 7894                       CALL HEXC
  788B    3E 48                         LD A,48H
  788D    CD 7894                       CALL HEXC
  7890    E1                            POP HL
  7891    D1                            POP DE
  7892    C1                            POP BC
  7893    C9                            RET
        MACRO-80 3.43   27-Jul-81       PAGE    1-30


                                ;------------------------
                                ;  Zeichen Ausgeben
                                ;
  7894    C5                    HEXC:   PUSH BC
  7895    D5                            PUSH DE
  7896    E5                            PUSH HL
  7897    5F                            LD E,A
  7898    F5                            PUSH AF
  7899    0E 02                         LD C,02H
  789B    CD 0005                       CALL 0005H
  789E    F1                            POP AF
  789F    E1                            POP HL
  78A0    D1                            POP DE
  78A1    C1                            POP BC
  78A2    C9                            RET
                                        ;--------------
                                        ; Cursor on
  78A3    E5                    CON:    PUSH HL
  78A4    C5                            PUSH BC
  78A5    21 803C                       LD HL,CURON             ; CURSOR ON
  78A8    06 06                         LD B,06H
  78AA    7E                    CUR02:  LD A,(HL)
  78AB    CD 7894                       CALL HEXC
  78AE    23                            INC HL
  78AF    10 F9                         DJNZ CUR02
  78B1    C1                            POP BC
  78B2    E1                            POP HL
  78B3    C9                            RET
                                        ;--------------
                                        ; Cursor off
  78B4    E5                    COFF:   PUSH HL
  78B5    C5                            PUSH BC
  78B6    21 8042                       LD HL,CUROFF            ; CURSOR OFF
  78B9    06 06                         LD B,06D
  78BB    7E                    CUR01:  LD A,(HL)
  78BC    CD 7894                       CALL HEXC
  78BF    23                            INC HL
  78C0    10 F9                         DJNZ CUR01
  78C2    C1                            POP BC
  78C3    E1                            POP HL
  78C4    C9                            RET
                                ;-----------------------
                                ;  DRIVE ZUGRIFF VORBEREITEN
  78C5    DB FF                 WAITRDY:IN A,(IDESTAT)
  78C7    CB 77                         BIT 6,A
  78C9    28 FA                         JR Z,WAITRDY
  78CB    CB 7F                         BIT 7,A
  78CD    20 F6                         JR NZ,WAITRDY
  78CF    C9                            RET
                                        ;----------
  78D0                          WAITDRQ: 
  78D0    DB FF                         IN A,(IDESTAT)
  78D2    CB 5F                         BIT 3,A
  78D4    28 FA                         JR Z,WAITDRQ
  78D6    CB 7F                         BIT 7,A
  78D8    20 F6                         JR NZ,WAITDRQ
        MACRO-80 3.43   27-Jul-81       PAGE    1-31


  78DA    C9                            RET
                                        ;----------
  78DB                          HDD_WAIT:
                                        ;LD B,0
                                        ;DJNZ $
  78DB    DB FF                 _WAIT1: IN A,(IDESTAT)
  78DD    E6 80                         AND 80H
  78DF    20 FA                         JR NZ,_WAIT1
  78E1    C9                            RET
                                        ;-------------
  78E2                          HDD_INIT:
  78E2    3E 02                         LD A,02H
  78E4    D3 FF                         OUT (IDECMD),A
  78E6    CD 78DB                       CALL HDD_WAIT
                                ;-----
  78E9    3E F0                         LD A,0F0H
  78EB    D3 FE                         OUT (IDESDH),A
  78ED    3E 01                         LD A,01H
  78EF    D3 FA                         OUT (IDESCNT),A
  78F1    3E EF                         LD A,0EFH
  78F3    D3 FF                         OUT (IDECMD),A
  78F5    CD 78DB                       CALL HDD_WAIT
  78F8    CD 78FC                       CALL HDD_ERROR
  78FB    C9                            RET
                                ;---------
  78FC                          HDD_ERROR:
  78FC    DB FF                         IN A,(IDESTAT)
  78FE    4F                            LD C,A
  78FF    C5                            PUSH BC
  7900    CD 781C                       CALL HEX00
  7903    C1                            POP BC
  7904    79                            LD A,C
  7905    E6 01                         AND 01H
  7907    C8                            RET Z
  7908    21 82A0                       LD HL,DERR
  790B    06 26                         LD B,L_DERR
  790D    7E                    ERR1:   LD A,(HL)
  790E    CD 7894                       CALL HEXC
  7911    23                            INC HL
  7912    10 F9                         DJNZ ERR1
  7914    C9                            RET
                                ;--------------
  7915                          HDD_INFO:
  7915    CD 78DB                       CALL HDD_WAIT
  7918    3E EC                         LD A,0ECH
  791A    D3 FF                         OUT (IDECMD),A
  791C    21 1964                       LD HL,6500
  791F    CD 7923                       CALL HDD_READ
  7922    C9                            RET
                                ;-----------
  7923                          HDD_READ:
  7923    CD 78DB                       CALL HDD_WAIT
  7926    DB FF                         IN A,(IDESTAT)
  7928    E6 08                         AND 08H
  792A    C8                            RET Z
  792B    DB F8                         IN A,(IDEDAT)
        MACRO-80 3.43   27-Jul-81       PAGE    1-32


  792D    77                            LD (HL),A
                                ;       CALL HEXC;!!! TESTAUSGABEN
  792E    23                            INC HL
  792F    18 F2                         JR HDD_READ
                                ;-------------
                                ; IDE-FESTPLATTE RESET
  7931                          IDERES:
  7931    CD 7937                       CALL IDERES1
  7934    C3 78DB                       JP HDD_WAIT
                                        ;----------
  7937    CD 7F9F               IDERES1:CALL EXTERN
  793A    F5                            PUSH AF         ; PIOA
  793B    C5                            PUSH BC
  793C    3E 06                         LD A,06H
  793E    D3 F6                         OUT (IDEDOR),A
  7940    06 00                         LD B,0
  7942    10 FE                         DJNZ $
  7944    3E 02                         LD A,02H
  7946    D3 F6                         OUT (IDEDOR),A
  7948    C1                            POP BC
  7949    F1                            POP AF
  794A    D3 1C                         OUT (PIOA),A
  794C    C9                            RET 
                                ;-------------
  794D    DD E5                 DISK:   PUSH IX
  794F    DD 21 0000                    LD IX,0
  7953    DD 39                         ADD IX,SP
                                ;--------
  7955    DD 7E 05                      LD A,(IX+5)     ; D= HEAD SELECT, LBA HIGH MIT HIGH=B
  7958    E6 0F                         AND 0FH         ; HEAD SELECT
  795A    47                            LD B,A
  795B    3E F7                         LD A,SELDS      ; IN INCLUDE
  795D    E6 F0                         AND 0F0H
  795F    B0                            OR B
  7960    CB FF                         SET 7,A
  7962    DD 77 05                      LD (IX+5),A
  7965    D3 FE                         OUT (IDESDH),A
  7967    DD 7E 04                      LD A,(IX+4)     ; TRACK HIGH
  796A    D3 FD                         OUT (IDECHI),A
  796C    DD 7E 07                      LD A,(IX+7)     ; TRACK LOW
  796F    D3 FC                         OUT (IDECLO),A
  7971    DD 7E 06                      LD A,(IX+6)     ; C= SECTOR
  7974    D3 FB                         OUT (IDESNUM),A
  7976    3E 01                         LD A,01H
  7978    D3 FA                         OUT (IDESCNT),A
                                        ;----------
  797A    DD F9                         LD SP,IX
  797C    DD E1                         POP IX
  797E    C9                            RET
                                ;-----------------------
                                ; ZEICHEN SUCHEN IM RAM AUS EINGABE RAMT
                                ;
  797F    08                    SUCH0:  EX AF,AF'               ; Textlaenge retten
  7980    1A                            LD A,(DE)               ; neuer Text mit
  7981    BE                            CP (HL)         ; Blaseninhalt 
  7982    28 0B                         JR Z,SUCH2
        MACRO-80 3.43   27-Jul-81       PAGE    1-33


  7984    23                            INC HL
  7985    3A 6B27                       LD A,(RAMT)
  7988    11 6B28                       LD DE,RAMT+1
  798B    10 F2                         DJNZ SUCH0
  798D    37                    SUCH1:  SCF
  798E    C9                            RET
                                        ;------------
  798F    13                    SUCH2:  INC DE
  7990    23                            INC HL
  7991    3E 2A                         LD A,2AH
  7993    CD 7894                       CALL HEXC
  7996    08                            EX AF,AF'
  7997    3D                            DEC A
  7998    20 E5                         JR NZ,SUCH0
  799A    7E                            LD A,(HL)               ; Text Ende <30H
  799B    FE 2F                         CP 2FH          ; ENDE < 21H = !
  799D    30 EE                         JR NC,SUCH1     ; -> kein Ende
  799F    AF                            XOR A
  79A0    C9                            RET     
                                ;-------------
  79A1    C5                    FREI:   PUSH BC
  79A2    0E 0B                         LD C,0BH        ; GET CONSILE STATUS
  79A4    CD 0005                       CALL 0005H
  79A7    C1                            POP BC
  79A8    C9                            RET
                                ;-----------------------
                                ; CONSOLE QUERY AND PICK 
                                ; WITHOUT WAITING
                                ; 
  79A9    CD 7E6D               KEYST:  CALL UHR00
  79AC    C5                            PUSH BC
  79AD    0E 0B                         LD C,0BH        ; GET CONSILE STATUS
  79AF    CD 0005                       CALL 0005H
  79B2    FE 00                         CP 0
  79B4    28 05                         JR Z,KEY01
  79B6    0E 01                         LD C,01H        ; console Input read chr
  79B8    CD 0005                       CALL 0005H
  79BB    C1                    KEY01:  POP BC
  79BC    C9                            RET 
                                ;-----------------------
                                ; LBA Z[HLER HERH\HE BID HDDE ENDE
                                ;
  79BD    DD E5                 LBA0:   PUSH IX
  79BF    DD 21 0000                    LD IX,0
  79C3    DD 39                         ADD IX,SP
                                ;--------
  79C5    DD 4E 06                      LD C,(IX+6)     ; LBA LOW SECTOR
  79C8    DD 46 07                      LD B,(IX+7)
  79CB    0C                            INC C
  79CC    DD 71 06                      LD (IX+6),C
  79CF    20 35                         JR NZ,LBA20
  79D1    04                            INC B
  79D2    DD 70 07                      LD (IX+7),B
  79D5    20 2F                         JR NZ,LBA20
  79D7    DD 4E 04                      LD C,(IX+4)     ; LBA TRACK 
  79DA    DD 46 05                      LD B,(IX+5)
        MACRO-80 3.43   27-Jul-81       PAGE    1-34


  79DD    03                            INC BC
  79DE    DD 71 04                      LD (IX+4),C     ; LBA TRACK
  79E1    DD 70 05                      LD (IX+5),B
  79E4    AF                            XOR A           ; RES CARRY FLAG
  79E5    21 00BE                       LD HL,HDDE      ; DISK ENDE
  79E8    ED 42                         SBC HL,BC       ; -C
  79EA    30 1A                         JR NC,LBA20     
  79EC    01 0801                       LD BC,HDD+1
  79EF    DD 71 06                      LD (IX+6),C
  79F2    DD 70 07                      LD (IX+7),B
  79F5    01 0000                       LD BC,0
  79F8    DD 71 04                      LD (IX+4),C
  79FB    DD 70 05                      LD (IX+5),B
  79FE    C3 0000                       JP 0;!!!!
  7A01    18 03                         JR LBA20
                                        ; ENDE ERREICHT
  7A03    37                    LBA4:   SCF             ;AUSGANG FEHLER
  7A04    18 01                         JR LBA21
                                ;-----------
  7A06    AF                    LBA20:  XOR A           ; SET CARRY -> OHNE FEHLER
  7A07    DD F9                 LBA21:  LD SP,IX
  7A09    DD E1                         POP IX
  7A0B    C9                            RET
                                ;-----------------
                                ; ADRESSE -1
  7A0C    C3 0000               LBA5:   JP 0;!!!
  7A0F    DD E5                 PUSH IX
  7A11    DD 21 0000                    LD IX,0
  7A15    DD 39                         ADD IX,SP
                                ;------
  7A17    DD 46 07                      LD B,(IX+7)     ; LBA 
  7A1A    DD 4E 06                      LD C,(IX+6)     ; LOW
  7A1D    0B                            DEC BC
  7A1E    78                            LD A,B
  7A1F    E6 F0                         AND 0F0H
  7A21    28 23                         JR Z,L__6
  7A23    06 0F                         LD B,0FH
  7A25    DD 70 07                      LD (IX+7),B     ; LBA 
  7A28    DD 71 06                      LD (IX+6),C     ; LOW
  7A2B    DD 46 05                      LD B,(IX+5)     ; LBA HIGH
  7A2E    DD 4E 04                      LD C,(IX+4)     ; LOW
  7A31    0B                            DEC BC
  7A32    E5                            PUSH HL
  7A33    AF                            XOR A
  7A34    21 0800                       LD HL,HDD
  7A37    ED 42                         SBC HL,BC
  7A39    E1                            POP HL
  7A3A    38 02                         JR C,L__7
  7A3C    18 C5                         JR LBA4
                                        ;-----------
  7A3E    DD 70 05              L__7:   LD (IX+5),B
  7A41    DD 71 04                      LD (IX+4),C
  7A44    18 C0                         JR LBA20
                                        ;_-------
  7A46    DD 70 07              L__6:   LD (IX+7),B     ; LBA HIGH
  7A49    DD 71 06                      LD (IX+6),C     ; LOW
        MACRO-80 3.43   27-Jul-81       PAGE    1-35


  7A4C    18 B8                         JR LBA20
                                
  7A4E    DD 46 05                      LD B,(IX+5)     ; LBA HIGH
  7A51    DD 4E 04                      LD C,(IX+4)     ; LOW
  7A54    0B                            DEC BC
  7A55    DD 70 05                      LD (IX+5),B
  7A58    DD 71 04                      LD (IX+4),C
  7A5B    18 A9                         JR LBA20
                                        ; --------------------
                                        ; aktuelle Blasenadresse
                                ;------------------------
                                ; Cursor auf Position setzen
                                
  7A5D    3A 6518               RLIST:  LD A,(CURS)
  7A60    32 651C                       LD (CURT),A
  7A63    3A 6519                       LD A,(CURS+1)
  7A66    32 651D                       LD (CURT+1),A
  7A69    3A 651A                       LD A,(CURS+2)
  7A6C    32 651E                       LD (CURT+2),A
  7A6F    3A 651B                       LD A,(CURS+3)
  7A72    32 651F                       LD (CURT+3),A
  7A75    CD 7859                       CALL CUT
  7A78    C9                            RET
                                        ;------------
                                        ; CURSER POS SAVE
  7A79    3A 651C               WLIST:  LD A,(CURT)
  7A7C    32 6518                       LD (CURS),A
  7A7F    3A 651D                       LD A,(CURT+1)
  7A82    32 6519                       LD (CURS+1),A
  7A85    3A 651E                       LD A,(CURT+2)
  7A88    32 651A                       LD (CURS+2),A
  7A8B    3A 651F                       LD A,(CURT+3)
  7A8E    32 651B                       LD (CURS+3),A
                                        ;------------
  7A91    78                    LIST:   LD A,B
  7A92    E6 F0                         AND 0F0H
  7A94    0F                            RRCA
  7A95    0F                            RRCA
  7A96    0F                            RRCA
  7A97    0F                            RRCA
  7A98    32 651C                       LD (CURT),A
  7A9B    78                            LD A,B
  7A9C    E6 0F                         AND 0FH
  7A9E    32 651D                       LD (CURT+1),a
  7AA1    79                            LD A,C
  7AA2    E6 F0                         AND 0F0H
  7AA4    0F                            RRCA
  7AA5    0F                            RRCA
  7AA6    0F                            RRCA
  7AA7    0F                            RRCA
  7AA8    32 651E                       LD (CURT+2),A
  7AAB    79                            LD A,C
  7AAC    E6 0F                         AND 0FH
  7AAE    32 651F                       LD (CURT+3),A
  7AB1    CD 7859                       CALL CUT
  7AB4    C9                            RET
        MACRO-80 3.43   27-Jul-81       PAGE    1-36


                                        ;-------------
                                        ; ZUM TEST (HL)+1  30MAL AUSGEBEN
                                        ;
  7AB5    06 1E                 LIS0:   LD B,30D
  7AB7    7E                    LIS1:   LD A,(HL)
  7AB8    4F                            LD C,A
  7AB9    C5                            PUSH BC
  7ABA    CD 781C                       CALL HEX00
  7ABD    C1                            POP BC
  7ABE    23                            INC HL
  7ABF    10 F6                         DJNZ LIS1
  7AC1    C9                            RET
                                ;---------------------------
                                ;  Kontrollausgabe rechts
                                ;
  7AC2    CD 78B4               TAS:    CALL COFF
  7AC5    ED 73 651C                    LD (CURT),SP
  7AC9    C5                            PUSH BC
  7ACA    01 2273                       LD BC,2273H
  7ACD    CD 7A91                       CALL LIST       ;CURSOR POS
  7AD0    C1                            POP BC
  7AD1    3A 650F                       LD A,(BFSHH)
  7AD4    4F                            LD C,A
  7AD5    C5                            PUSH BC
  7AD6    CD 781C                       CALL HEX00              ; ADRESSE DER AKTUEL GELESENEN BLASE
  7AD9    C1                            POP BC
  7ADA    3A 650E                       LD A,(BFSHL)
  7ADD    4F                            LD C,A
  7ADE    C5                            PUSH BC
  7ADF    CD 781C                       CALL HEX00
  7AE2    C1                            POP BC
  7AE3    3A 650D                       LD A,(BFSLH)
  7AE6    4F                            LD C,A
  7AE7    C5                            PUSH BC
  7AE8    CD 781C                       CALL HEX00
  7AEB    C1                            POP BC
  7AEC    3A 650C                       LD A,(BFSLL)
  7AEF    4F                            LD C,A
  7AF0    C5                            PUSH BC
  7AF1    CD 781C                       CALL HEX00
  7AF4    C1                            POP BC
                                        ; --------------------
                                        ; aktuelle Blasenadresse
  7AF5    C5                            PUSH BC
  7AF6    01 2173                       LD BC,2173H
  7AF9    CD 7A91                       CALL LIST       ;CURSOR POS
  7AFC    C1                            POP BC
  7AFD    3A 801F                       LD A,(BF07+3) ;(BFRHH)
  7B00    4F                            LD C,A
  7B01    C5                            PUSH BC
  7B02    CD 781C                       CALL HEX00
  7B05    C1                            POP BC
  7B06    3A 801E                       LD A,(BF07+2)  ;(BFRHL)
  7B09    4F                            LD C,A
  7B0A    C5                            PUSH BC
  7B0B    CD 781C                       CALL HEX00
        MACRO-80 3.43   27-Jul-81       PAGE    1-37


  7B0E    C1                            POP BC
  7B0F    3A 801D                       LD A,(BF07+1)  ;(BFRLH)
  7B12    4F                            LD C,A
  7B13    C5                            PUSH BC
  7B14    CD 781C                       CALL HEX00
  7B17    C1                            POP BC
  7B18    3A 801C                       LD A,(BF07) ;(BFRLL)
  7B1B    4F                            LD C,A
  7B1C    C5                            PUSH BC
  7B1D    CD 781C                       CALL HEX00
  7B20    C1                            POP BC
                                        ;---------------------
                                        ; CURSOR IN EINGABEZEILE MIT EINGABE SCHIEBEN
  7B21    3E 02                 TAS00:  LD A,02H
  7B23    32 651C                       LD (CURT),A
  7B26    3E 04                         LD A,04H
  7B28    32 651D                       LD (CURT+1),A
  7B2B    3E 01                         LD A,01H
  7B2D    32 651E                       LD (CURT+2),A
  7B30    3A 6B27                       LD A,(RAMT)
  7B33    FE 0A                         CP 0AH
  7B35    38 0E                         JR C,RD07       ; < 0AH ->
  7B37    D6 0A                         SUB 0AH
  7B39    32 651F                       LD (CURT+3),A
  7B3C    3A 651E                       LD A,(CURT+2)
  7B3F    3C                            INC A
  7B40    32 651E                       LD (CURT+2),A
  7B43    18 03                         JR RD08
  7B45    32 651F               RD07:   LD (CURT+3),A
  7B48    CD 7859               RD08:   CALL CUT
  7B4B    06 14                         LD B,20D
  7B4D    21 6728                       LD HL,RAMS+RUSER
  7B50    CD 7859               RD09:   CALL CUT
  7B53    CD 78A3                       CALL CON
                                ;-----------------------
                                ; Tastenabfrage und Zeichen einlesen
                                ; Sonst weitere Task ausfueren
                                ;
                                ; LBA ZAEHLER +1
                                ;
  7B56    ED 5B 650C                    LD DE,(BFSLL)   ; Aktuelle Track/Sectoradresse laden
  7B5A    ED 53 6C43                    LD (COP+4),DE   ; STARTPUNKT NACH SPEICHERN
  7B5E    D5                            PUSH DE
  7B5F    2A 650E                       LD HL,(BFSHL)
  7B62    22 6C45                       LD (COP+6),HL
  7B65    E5                            PUSH HL
  7B66    CD 79BD                       CALL LBA0       ; LBA + 1
  7B69    E1                            POP HL
  7B6A    22 650E                       LD (BFSHL),HL   ; adresse HIGH speichern
  7B6D    D1                            POP DE
  7B6E    ED 53 650C                    LD (BFSLL),DE   ; adresse LOW speichern
  7B72    DA 0000                       JP C,0 ;NOCH ENDE BEI FEHLER RD91               ; RUECKGABE CARRY 0=FEHLER
                                        ;---------------- 
                                        ; 1. BLASE + 1 = 2.BLASE
  7B75    D5                            PUSH DE         ; IX UEBERGABE
  7B76    E5                            PUSH HL         ; IX UEBERGEBE
        MACRO-80 3.43   27-Jul-81       PAGE    1-38


  7B77    CD 79BD                       CALL LBA0       ; LBA + 1
  7B7A    E1                            POP HL
  7B7B    22 6512                       LD (BFSHL+4),HL ; adresse HIGH speichern
  7B7E    D1                            POP DE
  7B7F    ED 53 6510                    LD (BFSLL+4),DE ; adresse LOW speichern
  7B83    DA 0000                       JP C,0 ;NOCH ENDE BEI FEHLER RD91               ; RUECKGABE CARRY 0=FEHLER
  7B86    CD 79A1                       CALL FREI       ; TAST INT FREI
                                        ;---------------------
                                        ; Erste Blase laden
  7B89    ED 4B 650C                    LD BC,(BFSLL)
  7B8D    ED 5B 650E                    LD DE,(BFSHL)
  7B91    21 6727                       LD HL,RAMS
  7B94    CD 7DA5                       CALL RDREAD     ; BFSLL BLASE LADEN
  7B97    CD 79A1                       CALL FREI
                                        ; READ SICHTBAR MACHEN
                                        ;LD BC,1001H
                                        ;CALL LIST
                                        ;LD HL,RAMS
                                        ;CALL LIS0
                                        ;------
  7B9A    3A 672D                       LD A,(RAMS+RSOTR)
  7B9D    FE 1B                         CP 1BH
  7B9F    28 0E                         JR Z,TAS03
  7BA1    21 82C6                       LD HL,NBLASE
  7BA4    11 6727                       LD DE,RAMS
  7BA7    01 00B0                       LD BC,NBLLE
  7BAA    ED B0                         LDIR
                                        ; READ SICHTBAR MACHEN
                                        ;LD BC,1101H
                                        ;CALL LIST
                                        ;LD HL,RAMS
                                        ;CALL LIS0
  7BAC    C3 7C85                       JP RD170
                                        ;-------------------
                                        ; Zweite Blase laden
  7BAF    ED 4B 6510            TAS03:  LD BC,(BFSLL+4)
  7BB3    ED 5B 6512                    LD DE,(BFSHL+4)
  7BB7    21 6927                       LD HL,RAMS+200H
  7BBA    CD 7DA5                       CALL RDREAD     ; BFSLL BLASE LADEN
  7BBD    CD 79A1                       CALL FREI
                                        ;------
                                        ; READ SICHTBAR MACHEN
                                        ;LD BC,1101H
                                        ;CALL LIST
                                        ;LD HL,RAMS+200H
                                        ;CALL LIS0
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
        MACRO-80 3.43   27-Jul-81       PAGE    1-39


                                ;
  7BC0    21 6928                       LD      HL,RAMS+RUSER+200H      ;BLASE2 RAM
  7BC3    11 6728                       LD      DE,RAMS+RUSER           ;BLASE1 RAM
  7BC6    1A                            LD      A,(DE)          ; USER vergleich
  7BC7    BE                            CP      (HL)            ; Blase2 > Blase1 dann
  7BC8    DA 7C37                       JP      C,RD06          ; zum naechstem >USER 2  neu anfangen
  7BCB    C2 7C9B                       JP      NZ,RD01         ; Blase2 < Blase1 tauschen ->
                                ;----------------------
                                ; Blasen der groesse nach Sortieren
                                ; TYPE1, AUFSTEIGEND
                                ; wenn T1 > T1+1 (DE)-(HL) =NC,dann tauschen
                                ; wenn T1 = T1+1 (DE)-(HL) =Z,dann TYPE2 
                                ; wenn T1 < T1+1 (DE)-(HL) =NZ,dann GEDAECHTNIS
                                ;
  7BCE    21 6929                       LD      HL,RAMS+RTYPE1+200H     ; Blase2
  7BD1    11 6729                       LD      DE,RAMS+RTYPE1          ; Blase1
  7BD4    1A                            LD      A,(DE)                  ; TYPE1 Vergleich
  7BD5    BE                            CP      (HL)                    ; Blase2 > Blase1 dann
  7BD6    DA 7C37                       JP      C,RD06                  ; zum Gedaechtnis zuruecksetzen 
  7BD9    C2 7C9B                       JP      NZ,RD01                 ; tauschen und Speichern 
                                ;       JP RD02 ;!!!!!TEST
                                ;----------------------
                                ; Blasen der groesse nach Sortieren
                                ; TYPE2 AUFSTEIGEND
                                ; wenn T2 > T2+1 (DE)-(HL) =NC,dann tauschen
                                ; wenn T2 = T2+1 (DE)-(HL) = Z,dann gedaechtniss-1
                                ; wenn T2 < T2+1 (DE)-(HL) =NZ,dann weiter
                                ;
  7BDC    21 692A               RD25:   LD HL,RAMS+RTYPE2+200H  ; Blase2
  7BDF    11 672A                       LD DE,RAMS+RTYPE2       ; Blase1
  7BE2    1A                            LD A,(DE)
  7BE3    FE 01                         CP 01H                  ; RAM+TYPE2 > 0
  7BE5    20 09                         JR NZ,RD255             ; TYPE2 BEREITS 1=FORNE JA ->
  7BE7    BE                            CP (HL)
                                ;??     CALL C,TASK     ; NOCH AUSARBEITEN
  7BE8    3A 692C                       LD A,(RAMS+RBSTAT+200H)
  7BEB    E6 07                         AND 07H
  7BED    CA 7C9B                       JP Z,RD01               ; BLASE 2 SPEICHERN MIT TAUSCHEN
  7BF0    1A                    RD255:  LD A,(DE)
  7BF1    BE                            CP (HL)                 ; Blase2 > Blase1 dann
  7BF2    38 06                         JR C,RD26
  7BF4    CA 7C1A                       JP Z,RD36               ; ZUM GEDAECHTNIS
  7BF7    D2 7C9B                       JP NC,RD01              ; TAUSCHEN
                                        ;----------------------
  7BFA    1A                    RD26:   LD A,(DE)               ; BLASE1 TYPE2 Vergleich
  7BFB    FE 00                         CP 0H
  7BFD    C2 7C37                       JP NZ,RD06              ; zum Gedaechtnisszaehler
                                        ;----------------------
                                        ; GED[CHTNISS BLASE1 TYPE2=0 MIT BLASE2 TYPE2>0 VERGLEICHEN
                                         
  7C00    21 672B                       LD HL,RAMS+RTERM                ; Blase1
  7C03    11 692B                       LD DE,RAMS+RTERM+200H   ; Blase2
  7C06    1A                            LD A,(DE)                       ; Gedaechtnissz Vergleich
  7C07    BE                            CP (HL)
  7C08    38 2D                         JR C,RD06                       ; 1>2 GEDAECHTNISS FALLEND
  7C0A    3C                            INC A
        MACRO-80 3.43   27-Jul-81       PAGE    1-40


  7C0B    20 01                         JR NZ,RD250
  7C0D    1A                            LD A,(DE)
  7C0E    77                    RD250:  LD (HL),A
  7C0F    ED 4B 650C                    LD BC,(BFSLL)
  7C13    ED 5B 650E                    LD DE,(BFSHL)           ; Suchadresse 2. BLASE speichern
  7C17    C3 7D08                       JP RD03
                                        ;----------------------
                                        ; Blasen der groesse nach Sortieren
                                        ; GEDAECHTNIS FALLEND
  7C1A    7E                    RD36:   LD A,(HL)
  7C1B    FE 00                         CP 0
  7C1D    20 0D                         JR NZ,RD35
  7C1F    3A 672C                       LD A,(RAMS+RBSTAT)
  7C22    E6 78                         AND 78H
  7C24    F6 47                         OR 47H
  7C26    32 672C                       LD (RAMS+RBSTAT),A
  7C29    C3 7BFA                       JP RD26 
                                        ;---------------------
  7C2C    21 692B               RD35:   LD HL,RAMS+RTERM+200H   ; Blase2
  7C2F    11 672B                       LD DE,RAMS+RTERM        ; Blase1
  7C32    1A                            LD A,(DE)               ; Gedaechtnissz Vergleich
  7C33    BE                            CP (HL)
  7C34    DA 7C9B                       JP C,RD01               ; tauschen und Speichern fallend
                                        ;---------------------
                                        ; Gedaechtniss zuruecksetzen wenn MONAT ungleich ist
                                
  7C37    CD 79A1               RD06:   CALL FREI
  7C3A    3A 8029                       LD A,(DAYM)             ; MONAT AUS UHR
  7C3D    E6 1F                         AND 1FH
  7C3F    47                            LD B,A
  7C40    3A 672C                       LD A,(RAMS+RBSTAT)      ; MONAT AUS BLASE1
  7C43    E6 1F                         AND 1FH
  7C45    B8                            CP B
  7C46    C2 7C53                       JP NZ,RDD1              ; NICHT GLEICH ->
  7C49    3A 672C                       LD A,(RAMS+RBSTAT)      ; MONAT AUS BLASE1
  7C4C    CB 77                         BIT 6,A                 ; PRUEFE SORTIEREN 
  7C4E    20 03                         JR NZ,RDD1              ; SPEICHERN ->
  7C50    C3 7D57                       JP RD02                 ; GLEICH nicht speichern gleicher MONAT
                                        ;------------------
                                        ; NEUER MONAT UND GEDAECHTNIS SPEICHERN
  7C53    3A 672C               RDD1:   LD A,(RAMS+RBSTAT)      ; BLASE 1
  7C56    E6 E0                         AND 0E0H
  7C58    B0                            OR B            ; neuer MONAT einbinden 
  7C59    CB B7                         RES 6,A         ; Zaehler aktivieren
  7C5B    CB 7F                         BIT 7,A         ; Blase benutzt fuer +/-
  7C5D    28 11                         JR Z,RD16       ; Gedaechtniss abziehen =0
  7C5F    CB BF                         RES 7,A         ; =1 ADDIEREN loesche
  7C61    32 672C                       LD (RAMS+RBSTAT),A      ; wieder zurueck in Blase1
  7C64    3A 672B                       LD A,(RAMS+RTERM)       ; GEDAECHTNISSZAEHLER AUS RAM
  7C67    3C                            INC A                   ; Gedaechtniss +1
  7C68    CA 7C85                       JP Z,RD170              ; Ausgang WENN MAX ERREICHT
  7C6B    32 672B                       LD (RAMS+RTERM),A       ; ZURUECK IN RAM
  7C6E    18 0D                         JR RD17
                                        ;--------------
  7C70    32 672C               RD16:   LD (RAMS+RBSTAT),A      ; MONAT SPEICHERN
  7C73    3A 672B                       LD A,(RAMS+RTERM)
        MACRO-80 3.43   27-Jul-81       PAGE    1-41


  7C76    D6 01                         SUB 01H                 ; Gedaechtniss schon Min
  7C78    38 16                         JR C,RD171              ; Ausgang WENN MIN ERREICHT
  7C7A    32 672B                       LD (RAMS+RTERM),A       ; ZURUECK IN RAM
  7C7D    3A 6205               RD17:   LD A,(BSTAT)
  7C80    CB B7                         RES 6,A                 ; Sortieren aktivieren aller Blasen
  7C82    32 6205                       LD (BSTAT),A
  7C85    ED 5B 650E            RD170:  LD DE,(BFSHL)           ; Suchadresse speichern
  7C89    ED 4B 650C                    LD BC,(BFSLL)
  7C8D    C3 7D08                       JP RD03                 ; nur Blase1 ohne tauschen speicher
                                        ;------------------
  7C90    3A 6728               RD171:  LD A,(RAMS+RUSER)
  7C93    3C                            INC A
  7C94    28 EF                         JR Z,RD170
  7C96    32 6728                       LD (RAMS+RUSER),A       ; User =FFH damit Blase wieder an Schluss wandert
  7C99    18 EA                         JR RD170
                                        ;-----------------------
                                        ; Zweite Blase mit Erster Blase beim Speichern tauschen
  7C9B    ED 4B 650C            RD01:   LD BC,(BFSLL)
  7C9F    ED 5B 650E                    LD DE,(BFSHL)   ; Suchadresse 1.Blase speichern
  7CA3    21 6927                       LD HL,RAMS+200H         ; MIT WERT AUS 2.BLASE SPEICHERN
  7CA6    CD 7DCE                       CALL RDWRITE
                                        ;------
                                        ; WRITE SICHTBAR MACHEN
                                        ;LD BC,1401H
                                        ;CALL LIST
                                        ;LD HL,RAMS+200H
                                        ;CALL LIS0
                                        ;--------
  7CA9    3A 6205                       LD A,(BSTAT)
  7CAC    CB B7                         RES 6,A         ; SORTIEREN START
  7CAE    32 6205                       LD (BSTAT),A
                                        ;-------------------
                                        ; pruefe ob AKTUELLE ZAEHLER ALS 1. Blase offen ist
  7CB1    AF                            XOR A           ; RES CARRY FLAG
  7CB2    ED 5B 650E                    LD DE,(BFSHL)   ; ADRESSE HIGH
  7CB6    2A 6502                       LD HL,(BFRHL)   ; AKTUELL SICHTBARE BLASE
  7CB9    ED 52                         SBC HL,DE       ;-C
  7CBB    20 1D                         JR NZ,TAS22     ; BLASE H SORTIEREN UND OFFEN NICHT GLEICH ->
  7CBD    AF                            XOR A           ; RES CARRY FAG
  7CBE    ED 5B 650C                    LD DE,(BFSLL)   ; ADRESSE LOW
  7CC2    2A 6500                       LD HL,(BFRLL)
  7CC5    ED 52                         SBC HL,DE       ;-C
  7CC7    20 11                         JR NZ,TAS22
                                        ;-------------------
                                        ; DANN ADRESSE AKTUELLER BLASE AUCH TAUSCHEN
                                        ; SICHTBARE BLASE VERSCHIEBEN
  7CC9    ED 5B 6510                    LD DE,(BFSLL+4)
  7CCD    2A 6512                       LD HL,(BFSHL+4)
  7CD0    22 6502                       LD (BFRHL),HL
  7CD3    ED 53 6500                    LD (BFRLL),DE
  7CD7    C3 7D00                       JP TAS24
                                        ;-------------------
                                        ; pruefe ob AKTUELLE ZAEHLER ALS 1. Blase offen ist
  7CDA    AF                    TAS22:  XOR A           ; RES CARRY FLAG
  7CDB    ED 5B 6512                    LD DE,(BFSHL+4) ; Aktuelle Track/Sectoradresse laden
  7CDF    2A 6502                       LD HL,(BFRHL)
        MACRO-80 3.43   27-Jul-81       PAGE    1-42


  7CE2    ED 52                         SBC HL,DE       ; -C
  7CE4    20 1A                         JR NZ,TAS24     ; BLASE H SORTIEREN UND OFFEN NICHT GLEICH ->
  7CE6    AF                            XOR A           ; RES CARRY FLAG
  7CE7    ED 5B 6510                    LD DE,(BFSLL+4) ; Aktuelle Track/Sectoradresse laden
  7CEB    2A 6500                       LD HL,(BFRLL)
  7CEE    ED 52                         SBC HL,DE       ; -C
  7CF0    20 0E                         JR NZ,TAS24
                                        ;-----------------
                                        ; AKTUELLE BLASE TAUSCHEN H->L
  7CF2    ED 5B 650C                    LD DE,(BFSLL)
  7CF6    2A 650E                       LD HL,(BFSHL)
  7CF9    ED 53 6500                    LD (BFRLL),DE
  7CFD    22 6502                       LD (BFRHL),HL
                                        ;-----------------------
                                        ; Erste Blase mit zweiter Blase beim Speichern tauschen
  7D00    ED 4B 6510            TAS24:  LD BC,(BFSLL+4)
  7D04    ED 5B 6512                    LD DE,(BFSHL+4) ; Suchadresse 2. BLASE speichern
  7D08    21 6727               RD03:   LD HL,RAMS
  7D0B    CD 7DCE                       CALL RDWRITE
                                        ;------
                                        ; WRITE SICHTBAR MACHEN
                                        ;LD BC,1601H
                                        ;CALL LIST
                                        ;LD HL,RAMS+200H
                                        ;CALL LIS0
                                        ;--------
  7D0E    3A 6205                       LD A,(BSTAT)
  7D11    CB 77                         BIT 6,A
  7D13    20 42                         JR NZ,RD02
  7D15    CB F7                         SET 6,A         ; STOP/START
  7D17    32 6205                       LD (BSTAT),A
                                        ;----------------------
                                        ; nach letztem Blase speichern Sortieradresse > letzter Blase Adr. 
                                        ; dann neu Adr. speichern und bei HDD-neu Anfangsadr. beginnen
  7D1A    AF                            XOR A           ; RES CARRY FLAG
  7D1B    2A 801E                       LD HL,(BF07+2)
  7D1E    ED 5B 650E                    LD DE,(BFSHL)   ; LETZTE Suchadresse speichern
  7D22    ED 52                         SBC HL,DE       ; -C
  7D24    30 17                         JR NC,RD30
  7D26    ED 53 801E                    LD (BF07+2),DE  ; SPEICHE WENN HL<DE
  7D2A    ED 4B 650C                    LD BC,(BFSLL)
  7D2E    ED 43 801C                    LD (BF07),BC
  7D32    ED 5B 650C                    LD DE,(BFSLL)
  7D36    ED 4B 650E                    LD BC,(BFSHL)
  7D3A    C3 7D6B                       JP RD90 
                                        ;---------------
  7D3D    ED 5B 650C            RD30:   LD DE,(BFSLL)
  7D41    ED 4B 650E                    LD BC,(BFSHL)
  7D45    C2 7D98                       JP NZ,RD92
  7D48    AF                            XOR A           ; RES CARRY FLAG
  7D49    2A 801C                       LD HL,(BF07)
  7D4C    ED 52                         SBC HL,DE       ; -C
  7D4E    30 07                         JR NC,RD02
  7D50    ED 53 801C                    LD (BF07),DE
  7D54    C3 7D6B                       JP RD90         ; NACH sPEICHERN BLASE VON NULL NEUSTART
                                ;-----------
        MACRO-80 3.43   27-Jul-81       PAGE    1-43


  7D57                          RD02:   ;------
                                        ; READ SICHTBAR MACHEN
                                        ;LD BC,0501H
                                        ;CALL LIST
                                        ;LD HL,RAMS
                                        ;CALL LIS0
  7D57    CD 79A1                       CALL FREI
  7D5A    ED 5B 650E                    LD DE,(BFSHL)           ; LETZTE SUCHADRESSE SPEICHERN
                                        ; LD (BF07+4),DE
  7D5E    ED 4B 650C                    LD BC,(BFSLL)
                                        ; LD (BF07+6),BC
                                        ;ACHTUNG SECTOR 8/16 LD (BF07),BC
                                        ;---------------------
                                        ; Tastenabfrage und Zeichen einlesen
  7D62    CD 79A9                       CALL KEYST
  7D65    FE 00                         CP 0H
  7D67    CA 7AC2                       JP Z,TAS        ;TAS00
  7D6A    C9                            RET                     ; RETURN ZU BL ENDE
                                
                                ;---------------------
                                ; RD90 AUSGABE UEBERSPRINGEN
                                ; SUCHADRESSE
                                ;
  7D6B    E5                    RD90:   PUSH HL
  7D6C    D5                            PUSH DE
  7D6D    C5                            PUSH BC
  7D6E    ED 5B 650C                    LD DE,(BFSLL)
  7D72    ED 4B 650E                    LD BC,(BFSHL)
  7D76    CB 38                         SRL B
  7D78    CB 19                         RR C
  7D7A    CB 1A                         RR D
  7D7C    CB 1B                         RR E
  7D7E    AF                            XOR A           ; RES CARRY FLAG
  7D7F    21 0000                       LD HL,0000H
  7D82    ED 42                         SBC HL,BC       ; -C HIGH
  7D84    20 12                         JR NZ,RD92      ; BC >0 ->
  7D86    21 0800                       LD HL,HDD
  7D89    ED 52                         SBC HL,DE
  7D8B    30 05                         JR NC,RD911
  7D8D    18 09                         JR RD92
                                ;----------------------
                                ; RESET TO HDD START
                                ; 
  7D8F    E5                    RD91:   PUSH HL
  7D90    D5                            PUSH DE
  7D91    C5                            PUSH BC
  7D92    11 0801               RD911:  LD DE,HDD+1
  7D95    01 0000                       LD BC,0
  7D98    ED 53 650C            RD92:   LD (BFSLL),DE
  7D9C    ED 43 650E                    LD (BFSHL),BC
  7DA0    C1                            POP BC
  7DA1    D1                            POP DE
  7DA2    E1                            POP HL
  7DA3    18 B2                         JR RD02
                                ;------------------------
                                ; READ SECTOR VON HDD
        MACRO-80 3.43   27-Jul-81       PAGE    1-44


                                ;
  7DA5    DD E5                 RDREAD: PUSH IX
  7DA7    DD 21 0000                    LD IX,0
  7DAB    DD 39                         ADD IX,SP
                                        ;----------------
  7DAD    CD 7F9F                       CALL EXTERN
  7DB0    F5                            PUSH AF         ; PIOA RESCUE
                                        ;----------------
  7DB1    E5                            PUSH HL         ; DMA
  7DB2    C5                            PUSH BC         ; DISK SEL
  7DB3    D5                            PUSH DE         ; DISK SEL
  7DB4    CD 794D                       CALL DISK
  7DB7    D1                            POP DE
  7DB8    3E 20                         LD A,CMD_READSEC
  7DBA    D3 FF                         OUT (IDECMD),A
  7DBC    7A                            LD A,D
  7DBD    D3 FE                         OUT (IDESDH),A
  7DBF    CD 78D0                       CALL WAITDRQ
  7DC2    C1                            POP BC
  7DC3    E1                            POP HL
  7DC4    06 00                         LD B,00H
  7DC6    0E F8                         LD C,IDEDAT
  7DC8    ED B2                         INIR
  7DCA    ED B2                         INIR
  7DCC    18 24                         JR HDIST
                                ;----------------------
                                ; BLASE TO SAVE DE=HIGH, BC=LOW
                                ;
  7DCE                          RDWRITE:
  7DCE    DD E5                         PUSH IX
  7DD0    DD 21 0000                    LD IX,0
  7DD4    DD 39                         ADD IX,SP
                                        ;----------------
  7DD6    CD 7F9F                       CALL EXTERN
  7DD9    F5                            PUSH AF         ; PIOA RESCUE
                                        ;----------------
  7DDA    E5                            PUSH HL         ; DMA
  7DDB    C5                            PUSH BC         ; DISK SEL
  7DDC    D5                            PUSH DE         ; DISK SEL
  7DDD    CD 794D                       CALL DISK
  7DE0    D1                            POP DE
  7DE1    C1                            POP BC
  7DE2    3E 30                         LD A,CMD_WRITESEC
  7DE4    D3 FF                         OUT (IDECMD),A
  7DE6    CD 78D0                       CALL WAITDRQ
  7DE9    E1                            POP HL          ; DMA ZURUECK
  7DEA    06 00                         LD B,00H
  7DEC    0E F8                         LD C,IDEDAT
  7DEE    ED B3                         OTIR
  7DF0    ED B3                         OTIR
                                        ;----------------
  7DF2    F1                    HDIST:  POP AF
  7DF3    D3 1C                         OUT (PIOA),A    ; PIOA BACK UP
  7DF5    DD F9                         LD SP,IX
  7DF7    DD E1                         POP IX
  7DF9    C9                            RET
        MACRO-80 3.43   27-Jul-81       PAGE    1-45


                                ;---------------------
                                ; TASK zum Programm Starten
                                ; auf Adr. 100H
                                
  7DFA                          TASK:   ;PUSH   AF
  7DFA    C5                            PUSH    BC
  7DFB    D5                            PUSH    DE
  7DFC    E5                            PUSH    HL
  7DFD    3A 6928                       LD      A,(RAMS+RUSER+200H)
  7E00    FE FF                         CP      0FFH
  7E02    30 41                         JR      NC,TASK99       ; USER = FFH nicht auswerten
  7E04    7E                            LD      A,(HL)          ; TYPE2 Blase2 vergleichen
  7E05    FE 02                         CP      02H
  7E07    38 3C                         JR      C,TASK99
  7E09    3A 6003                       LD      A,(RAM+RTYPE2)
  7E0C    FE 02                         CP      02H
  7E0E    30 35                         JR      NC,TASK99       ; WENN IN RAM >1 EXTERNE TASK EINGABE
                                        ;----------------------
                                        ; EXTERN BEARBEITEN
                                
  7E10    11 0080                       LD      DE,BUFF
  7E13    21 81D4                       LD      HL,PRLO1
  7E16    7E                            LD      A,(HL)
  7E17    12                            LD      (DE),A
  7E18    13                            INC     DE
  7E19    47                            LD      B,A
  7E1A    CD 728B                       CALL    BL13
                                ;ERROR ??
                                ; CALL  E.TEXT
                                ; JR    NC,TASK99
                                
  7E1D    CD 0100                       CALL    0100H
  7E20    FE 00                         CP      0
  7E22    20 21                         JR      NZ,TASK99
  7E24    ED 4B 6510                    LD BC,(BFSLL+4)
  7E28    C5                            PUSH BC
  7E29    ED 5B 6512                    LD DE,(BFSHL+4) ; Suchadresse 2. BLASE speichern
  7E2D    D5                            PUSH DE
  7E2E    CD 794D                       CALL DISK
  7E31    D1                            POP DE
  7E32    C1                            POP BC
  7E33    38 10                         JR      C,TASK99
  7E35    01 6927                       LD      BC,RAMS+200H            ; MIT WERT AUS 1. BLASE
  7E38    CD F82F                       CALL    SETDMA
  7E3B    CD 7F9F                       CALL EXTERN
  7E3E    F5                            PUSH AF
  7E3F    CD F817                       CALL WRITE
  7E42    F1                            POP AF
  7E43    D3 1C                         OUT (PIOA),A
                                
                                        ;----------------
  7E45    E1                    TASK99: POP     HL
  7E46    D1                            POP     DE
  7E47    C1                            POP     BC
                                        ;POP    AF
  7E48    C9                            RET
        MACRO-80 3.43   27-Jul-81       PAGE    1-46


                                        ;-----------------------
                                        ; Blase Speichern  aus RAMS in 
                                        ; BC = LL- LH , DE = HL-HH Adresse LBA
  7E49    C5                    TWRITE: PUSH BC
  7E4A    D5                            PUSH DE
  7E4B    CD 794D                       CALL DISK
  7E4E    D1                            POP DE
  7E4F    C1                            POP BC
  7E50    D8                            RET C
  7E51    01 6727                       LD BC,RAMS              ; MIT WERT AUS 2. BLASE
  7E54    CD F82F                       CALL SETDMA
  7E57    CD 7F9F                       CALL EXTERN
  7E5A    F5                            PUSH AF
  7E5B    CD F817                       CALL WRITE
  7E5E    F1                            POP AF
  7E5F    D3 1C                         OUT (PIOA),A
  7E61    AF                            XOR     A
  7E62    C9                            RET
                                ;---------------
                                ; INTERRUPT FUER TASK PRUEFEN
                                ;INT:   EI
  7E63    00                            NOP
  7E64    00                            NOP
  7E65    00                            NOP
  7E66    00                            NOP
  7E67    00                            NOP
  7E68    00                            NOP
  7E69    00                            NOP
  7E6A    00                            NOP
  7E6B    F3                            DI
  7E6C    C9                            RET
                                
                                ;-----------------------
                                ;  Uhr auslesen
                                
  7E6D    C5                    UHR00:  PUSH BC
  7E6E    CD 7F98                       CALL INTERN
  7E71    F5                            PUSH AF
  7E72    DB 1E                         IN A,(PIOB)
  7E74    F5                            PUSH AF
  7E75    3E 3F                         LD A,3FH                ; Adresse fuer Uhr
  7E77    D3 1E                         OUT (PIOB),A
                                        ;-----------------
                                        ; Minuten in Dezimal
                                        ;
  7E79    3E 40                         LD A,040H               ; Lesen Ein
  7E7B    D3 98                         OUT (URCS+18H),A
  7E7D    DB 9A                         IN A,(URCS+1AH) ; Minuten
  7E7F    4F                            LD C,A
                                ;       XOR A
                                ;       OUT (URCS+18H),A        ; R/W Aus
  7E80    C5                            PUSH BC
  7E81    CD 7EC7                       CALL ASCII_CODE
  7E84    C1                            POP BC
  7E85    78                            LD A,B
  7E86    32 802D                       LD (DAYZ+2),A           ; ZEHNER
        MACRO-80 3.43   27-Jul-81       PAGE    1-47


  7E89    3A 802E                       LD A,(DAYZ+3)
  7E8C    B9                            CP C
  7E8D    28 2B                         JR Z,UHR01              ; ZEITAENERUNG NEIN ->
  7E8F    79                            LD A,C
  7E90    32 802E                       LD (DAYZ+3),A
                                        ;-----------------------
                                        ;       Stunde
                                        ;
                                ;       LD A,040H               ; Lesen Ein
                                ;       OUT (URCS+18H),A
  7E93    00                            NOP
  7E94    DB 9B                         IN A,(URCS+1BH) ; Stunde
  7E96    4F                            LD C,A
  7E97    AF                            XOR A
  7E98    D3 98                         OUT (URCS+18H),A        ; R/W Aus
  7E9A    C5                            PUSH BC
  7E9B    CD 7EC7                       CALL ASCII_CODE
  7E9E    C1                            POP BC
  7E9F    78                            LD A,B
  7EA0    32 802B                       LD (DAYZ),A
  7EA3    79                            LD A,C
  7EA4    32 802C                       LD (DAYZ+1),A
                                        ;-----------------
                                        ; DAY auslesen
                                        ;
                                ;       LD A,040H               ; Lesen Ein
                                ;       OUT (URCS+18H),A
  7EA7    00                            NOP
  7EA8    DB 9D                         IN A,(URCS+1DH) ; Tag
  7EAA    47                            LD B,A
                                ;       XOR A
                                ;       OUT (URCS+18H),A        ; Lesen Aus
  7EAB    78                            LD A,B
  7EAC    32 802A                       LD (DAYT),A
                                        ;-----------------
                                        ; Monat auslesen
                                        ;
                                ;       LD A,040H               ; Lesen Ein
                                ;       OUT (URCS+18H),A
  7EAF    00                            NOP
  7EB0    DB 9E                         IN A,(URCS+1EH) ; Tag
  7EB2    47                            LD B,A
                                ;       XOR A
                                ;       OUT (URCS+18H),A        ; Lesen Aus
  7EB3    78                            LD A,B
  7EB4    32 8029                       LD (DAYM),A
                                        ;------------------
                                        ; Zeit ausgeben
                                        ;
  7EB7    CD 7EF8                       CALL    UHR10
  7EBA    AF                    UHR01:  XOR A
  7EBB    D3 98                         OUT (URCS+18H),A        ; Lesen Aus
  7EBD    F1                            POP AF
  7EBE    E6 F0                         AND 0F0H
  7EC0    D3 1E                         OUT (PIOB),A
  7EC2    F1                            POP AF
        MACRO-80 3.43   27-Jul-81       PAGE    1-48


  7EC3    D3 1C                         OUT (PIOA),A
  7EC5    C1                            POP BC
  7EC6    C9                            RET
                                ;---------
  7EC7                          ASCII_CODE:
  7EC7    DD E5                         PUSH IX
  7EC9    DD 21 0000                    LD IX,0
  7ECD    DD 39                         ADD IX,SP
                                        ;------
  7ECF    DD 7E 04                      LD A,(IX+4)     ;B=HIGH
  7ED2    0F                            RRCA
  7ED3    0F                            RRCA
  7ED4    0F                            RRCA
  7ED5    0F                            RRCA
  7ED6    E6 0F                         AND 0FH
  7ED8    C6 30                         ADD A,30H
  7EDA    FE 3A                         CP 3AH
  7EDC    38 02                         JR C,ASC_1
  7EDE    C6 07                         ADD A,07H
  7EE0    DD 77 05              ASC_1:  LD (IX+5),A
  7EE3    DD 7E 04                      LD A,(IX+4)     ; C=LOW
  7EE6    E6 0F                         AND 0FH
  7EE8    C6 30                         ADD A,30H
  7EEA    FE 3A                         CP 3AH
  7EEC    38 02                         JR C,ASC_2
  7EEE    C6 07                         ADD A,07H
  7EF0    DD 77 04              ASC_2:  LD (IX+4),A
                                        ;---------
  7EF3    DD F9                         LD SP,IX
  7EF5    DD E1                         POP IX
  7EF7    C9                            RET             ; RETURN =BC
                                ;-----------------------
                                ;   Uhr anzeigen
                                ;
  7EF8    CD 78B4               UHR10:  CALL COFF       ; CURSOR AUS
                                        ;---------------
                                        ; Zeile/Spalte
  7EFB    C5                            PUSH BC
  7EFC    01 0075                       LD BC,0075H
  7EFF    CD 7A79                       CALL WLIST      ; CURSOR POS
  7F02    C1                            POP BC
  7F03    3A 802B                       LD A,(DAYZ)
  7F06    CD 7894                       CALL HEXC
  7F09    3A 802C                       LD A,(DAYZ+1)
  7F0C    CD 7894                       CALL HEXC
  7F0F    3E 3A                         LD A,3AH
  7F11    CD 7894                       CALL HEXC
  7F14    3A 802D                       LD A,(DAYZ+2)
  7F17    CD 7894                       CALL HEXC
  7F1A    3A 802E                       LD A,(DAYZ+3)
  7F1D    CD 7894                       CALL HEXC
                                        ;-----------
  7F20    CD 78B4                       CALL COFF 
  7F23    C5                            PUSH BC
  7F24    01 2475                       LD BC,2475H
  7F27    CD 7A91                       CALL LIST       ;CURSOR POS
        MACRO-80 3.43   27-Jul-81       PAGE    1-49


  7F2A    C1                            POP BC
  7F2B    3A 802A                       LD A,(DAYT)
  7F2E    4F                            LD C,A
  7F2F    C5                            PUSH BC
  7F30    CD 7EC7                       CALL ASCII_CODE
  7F33    C1                            POP BC
  7F34    78                            LD A,B
  7F35    CD 7894                       CALL HEXC
  7F38    79                            LD A,C
  7F39    CD 7894                       CALL HEXC
  7F3C    3E 2E                         LD A,2EH
  7F3E    CD 7894                       CALL HEXC
  7F41    3A 8029                       LD A,(DAYM)
  7F44    4F                            LD C,A
  7F45    C5                            PUSH BC
  7F46    CD 7EC7                       CALL ASCII_CODE
  7F49    C1                            POP BC
  7F4A    78                            LD A,B
  7F4B    CD 7894                       CALL HEXC
  7F4E    79                            LD A,C
  7F4F    CD 7894                       CALL HEXC
  7F52    18 34                         JR RDU02
                                ;-----------------------
  7F54    3E 02                         LD A,02H
  7F56    32 651C                       LD (CURT),A
  7F59    3E 04                         LD A,04H
  7F5B    32 651D                       LD (CURT+1),A
  7F5E    3A 6B27                       LD A,(RAMT)
  7F61    CB 7F                         BIT 7,A
  7F63    28 04                         JR Z,RDU03
  7F65    3E 00                         LD A,00H
  7F67    18 02                         JR RDU03+2
  7F69    3E 01                 RDU03:  LD A,01H
  7F6B    32 651E                       LD (CURT+2),A
  7F6E    3A 6B27                       LD A,(RAMT)
  7F71    E6 0F                         AND 0FH
  7F73    FE 0A                         CP 0AH
  7F75    38 0E                         JR C,RDU01
  7F77    D6 0A                         SUB 0AH
  7F79    32 651F                       LD (CURT+3),A
  7F7C    3A 651E                       LD A,(CURT+2)
  7F7F    3C                            INC A
  7F80    32 651E                       LD (CURT+2),A
  7F83    18 03                         JR RDU02
  7F85    32 651F               RDU01:  LD (CURT+3),A
                                
  7F88    CD 7A5D               RDU02:  CALL RLIST      
  7F8B    21 803C                       LD HL,CURON     ; CURSOR ON
  7F8E    06 06                         LD B,06D
  7F90    7E                    CUR03:  LD A,(HL)
  7F91    CD 7894                       CALL HEXC
  7F94    23                            INC HL
  7F95    10 F9                         DJNZ CUR03
  7F97    C9                            RET
                                ;------------------
                                ;INCLUDE LCDINI.MAC
        MACRO-80 3.43   27-Jul-81       PAGE    1-50


                                ;------------------
                                        ;
                                        ; BUS INTERN UMSCHALTUNG
                                        ;
  7F98    DB 1C                 INTERN: IN A,(PIOA)
  7F9A    F5                            PUSH AF
  7F9B    CB BF                         RES 7,A
  7F9D    18 05                         JR TERN
  7F9F    DB 1C                 EXTERN: IN A,(PIOA)
  7FA1    F5                            PUSH AF
  7FA2    CB FF                         SET 7,A
  7FA4    D3 1C                 TERN:   OUT (PIOA),A
  7FA6    F1                            POP AF
  7FA7    C9                            RET
                                ;----------------
  7FA8                          EPROMON:        
  7FA8    DB 1C                         IN A,(PIOA)
  7FAA    CB B7                         RES 6,A
  7FAC    D3 1C                         OUT (PIOA),A    ; EPROM Ein
  7FAE    C3 0000                       JP 0000H        ; EPROM NEUSTART -> PROGRAMM ENDE
                                ;------------------------
  7FB1    42 4C 41 53           TEX1:   DEFM 'BLASE VERGLEICH:'
  7FB5    45 20 56 45           
  7FB9    52 47 4C 45           
  7FBD    49 43 48 3A           
                                ;TEX1I: DEFB 78H,78H,78H,78H    
  0010                          TXL     EQU $-TEX1
                                
  7FC1    42 4C 41 53           TEX2:   DEFM 'BLASE GEFUNDEN: '
  7FC5    45 20 47 45           
  7FC9    46 55 4E 44           
  7FCD    45 4E 3A 20           
  7FD1    00 00 00 00           TEX2I:  DEFB 00H,00H,00H,00H    
                                
  7FD5    4B 49 53 59           TEX3:   DEFM 'KISYS 08.12.2009/17'
  7FD9    53 20 30 38           
  7FDD    2E 31 32 2E           
  7FE1    32 30 30 39           
  7FE5    2F 31 37              
  0013                          TXL3    EQU $-TEX3
                                ;-----------------------
                                ;  BIOS Function Summary
                                
  7FE8    C5                    BIOS:   PUSH    BC
  7FE9    E5                            PUSH    HL
  7FEA    5E                            LD      E,(HL)          ; Speicher Lesen 
  7FEB    CD 0005                       CALL    0005H
  7FEE    E1                            POP     HL
  7FEF    C1                            POP     BC
  7FF0    23                            INC     HL
  7FF1    10 F5                         DJNZ    BIOS
  7FF3    C9                            RET
                                ;----------------------
                                ; Blasen Adress Buffer
                                
  7FF4    00 00 00 00           BF00:   DEFB    00H,00H,00H,00H,80H,00H         ; U,T1,T2 Zaehler zum Blase eroeffnen
        MACRO-80 3.43   27-Jul-81       PAGE    1-51


  7FF8    80 00                 
  7FFA    00 00 00 00           BF01:   DEFB    00H,00H,00H,00H,00H,00H         ; LAST CURSOR POS XX,YY
  7FFE    00 00                 
  8000    00 00 00 00           BF02:   DEFB    00H,00H,00H,00H,00H,00H
  8004    00 00                 
  8006    00 00 00 00           BF03:   DEFB    00H,00H,00H,00H,00H,00H
  800A    00 00                 
  800C    00 00 00 00           BF04:   DEFB    00H,00H,00H,00H,00H,00H
  8010    00 00                 
  8012    00 00 00 00           BF05:   DEFB    00H,00H,00H,00H,00H,00H
  8016    00 00                 
  8018    00 00 00 00           BF06:   DEFB    00H,00H,00H,00H         ; Datenbankverwaltung
  801C    00 00 00 00           BF07:   DEFB    00H,00H,00H,00H         ; Letzte HDD SORTIERADRESSE
                                ;----------------------
  8020    00 00 00 00           BF10:   DEFB    00H,00H,00H,00H,00H,00H,00H,00H ; User Type, G.Zaehler
  8024    00 00 00 00           
                                ;----------------------
                                ; Kalender
  8028    30                    DAYJ:   DEFB    30H
  8029    30                    DAYM:   DEFB    30H
  802A    30                    DAYT:   DEFB    30H
  802B    30 30 30 30           DAYZ:   DEFB    30H,30H,30H,30H,30H,30H
  802F    30 30                 
                                
                                ;----------------------
                                ; Eingabe Meldung Zeile 24, Spalte 1
  0007                          CURUD   EQU 07H                 ; Zaehlen ab 01 - 09
  8031    00 00                 ZEIL:   DEFB 00H,00H
  8033    1B 5B 31 6D           COL01:  DEFB 1BH,5BH,31H,6DH,1BH,5BH,34H,34H,6DH        ;COLOR
  8037    1B 5B 34 34           
  803B    6D                    
  803C    1B 5B 3F 32           CURON:  DEFB 1BH,5BH,3FH,32H,35H,68H            ;SET CURSOR ON
  8040    35 68                 
  8042    1B 5B 3F 32           CUROFF: DEFB 1BH,5BH,3FH,32H,35H,6CH            ;SET CURSOR OFF
  8046    35 6C                 
  8048    1B 5B 32 34           EBUFF:  DEFB 1BH,5BH,'2','4',';','0','1','H'
  804C    3B 30 31 48           
  8050    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  8054    6D                    
  8055    20 20 20 20                   DEFM '                           '
  8059    20 20 20 20           
  805D    20 20 20 20           
  8061    20 20 20 20           
  8065    20 20 20 20           
  8069    20 20 20 20           
  806D    20 20 20              
  8070    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  8074    3B 30 31 48           
  8078    53 75 63 68           EBUFFE: DEFM 'Suche:              '
  807C    65 3A 20 20           
  8080    20 20 20 20           
  8084    20 20 20 20           
  8088    20 20 20 20           
  0044                          EZLEN   EQU $-EBUFF
  808C    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  8090    3B 30 31 48           
        MACRO-80 3.43   27-Jul-81       PAGE    1-52


  8094    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  8098    6D                    
  8099    4C 69 73 74                   DEFM 'List                '
  809D    20 20 20 20           
  80A1    20 20 20 20           
  80A5    20 20 20 20           
  80A9    20 20 20 20           
  80AD    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  80B1    3B 30 31 48           
  80B5    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  80B9    6D                    
  80BA    8E 6E 64 65                   DEFM  142D,'ndern              '
  80BE    72 6E 20 20           
  80C2    20 20 20 20           
  80C6    20 20 20 20           
  80CA    20 20 20 20           
  80CE    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  80D2    3B 30 31 48           
  80D6    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  80DA    6D                    
  80DB    53 70 65 69                   DEFM 'Speichern           '
  80DF    63 68 65 72           
  80E3    6E 20 20 20           
  80E7    20 20 20 20           
  80EB    20 20 20 20           
  80EF    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  80F3    3B 30 31 48           
  80F7    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  80FB    6D                    
  80FC    56 65 72 67                   DEFM 'Vergessen           '
  8100    65 73 73 65           
  8104    6E 20 20 20           
  8108    20 20 20 20           
  810C    20 20 20 20           
  8110    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  8114    3B 30 31 48           
  8118    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  811C    6D                    
  811D    45 6E 64 65                   DEFM 'Ende                '
  8121    20 20 20 20           
  8125    20 20 20 20           
  8129    20 20 20 20           
  812D    20 20 20 20           
                                
  8131    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  8135    3B 30 31 48           
  8139    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  813D    6D                    
  813E    20 20 20 4C                   DEFM '   List             '
  8142    69 73 74 20           
  8146    20 20 20 20           
  814A    20 20 20 20           
  814E    20 20 20 20           
                                
  8152    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  8156    3B 30 31 48           
        MACRO-80 3.43   27-Jul-81       PAGE    1-53


  815A    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  815E    6D                    
  815F    20 20 8E 6E                   DEFM '  ',142D,'ndern               '
  8163    64 65 72 6E           
  8167    20 20 20 20           
  816B    20 20 20 20           
  816F    20 20 20 20           
  8173    20 20 20              
                                
  8176    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  817A    3B 30 31 48           
  817E    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  8182    6D                    
  8183    41 6E 6C 65                   DEFM 'Anlegen             '
  8187    67 65 6E 20           
  818B    20 20 20 20           
  818F    20 20 20 20           
  8193    20 20 20 20           
                                
  8197    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  819B    3B 30 31 48           
  819F    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  81A3    6D                    
  81A4    53 70 65 69                   DEFM 'Speichern           '
  81A8    63 68 65 72           
  81AC    6E 20 20 20           
  81B0    20 20 20 20           
  81B4    20 20 20 20           
                                
  81B8    3A                            DEFB ':'        ; Ende Text
                                
  81B9    08                    ZCUR:   DEFB 08H                                
  81BA    4C 49 53 54                   DEFM 'LISTF.COM'                                
  81BE    46 2E 43 4F           
  81C2    4D                    
  81C3    07                            DEFB 07H        
  81C4    4D 45 4D 2E                   DEFM 'MEM.COM'
  81C8    43 4F 4D              
  81CB    08                            DEFB 08H                                
  81CC    45 44 49 54                   DEFM 'EDIT.COM'                         
  81D0    2E 43 4F 4D           
                                
                                ;----------------------
                                
  81D4    08                    PRLO1:  DEFB 08H
  81D5    46 41 4B 54                   DEFM 'FAKT.COM'
  81D9    2E 43 4F 4D           
                                
  81DD    53 74 61 72           STEX:   DEFM 'Start Programm  '
  81E1    74 20 50 72           
  81E5    6F 67 72 61           
  81E9    6D 6D 20 20           
  0010                          LSTEX   EQU $-STEX
                                
  81ED    4B 49 53 79           LCDE:   DEFM  'KISystem Winterhalter'
  81F1    73 74 65 6D           
        MACRO-80 3.43   27-Jul-81       PAGE    1-54


  81F5    20 57 69 6E           
  81F9    74 65 72 68           
  81FD    61 6C 74 65           
  8201    72                    
  0015                          LCDEX   EQU     $-LCDE
                                
  8202    1B 5B 31 35           COMZ:   DEFB 1BH,5BH,31H,35H,3BH,30H,31H,48H,1BH,5BH,30H,4AH
  8206    3B 30 31 48           
  820A    1B 5B 30 4A           
  820E    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH,1BH,5BH,34H,32H,6DH
  8212    6D 1B 5B 34           
  8216    32 6D                 
  8218    43 6F 6D 6D                   DEFM  'Commando Zeile= '
  821C    61 6E 64 6F           
  8220    20 5A 65 69           
  8224    6C 65 3D 20           
  0026                          COMZX   EQU     $-COMZ
                                
                                
  8228    1B 5B 32 34           KEYZ:   DEFB 1BH,5BH,32H,34H,3BH,30H,31H,48H
  822C    3B 30 31 48           
  8230    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH,1BH,5BH,34H,32H,6DH
  8234    6D 1B 5B 34           
  8238    32 6D                 
  823A    4B 45 59 20                   DEFM  'KEY Stepp= '
  823E    53 74 65 70           
  8242    70 3D 20              
  001D                          KEYZX   EQU     $-KEYZ
                                
  8245    1B 5B 30 31           MELD01: DEFB 1BH,5BH,30H,31H,3BH,30H,31H,48H
  8249    3B 30 31 48           
  824D    1B 5B 33 31                   DEFB 1BH,5BH,33H,31H,6DH,1BH,5BH,34H,34H,6DH
  8251    6D 1B 5B 34           
  8255    34 6D                 
  8257    44 69 65 73                   DEFM  'Dieser Begriff ist mir nicht bekannt'
  825B    65 72 20 42           
  825F    65 67 72 69           
  8263    66 66 20 69           
  8267    73 74 20 6D           
  826B    69 72 20 6E           
  826F    69 63 68 74           
  8273    20 62 65 6B           
  8277    61 6E 6E 74           
  0036                          MELD01X EQU     $-MELD01
                                
  827B    1B 5B 32 34           PROZ:   DEFB 1BH,5BH,32H,34H,3BH,30H,31H,48H
  827F    3B 30 31 48           
  8283    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH,1BH,5BH,34H,32H,6DH
  8287    6D 1B 5B 34           
  828B    32 6D                 
  828D    44 61 74 65                   DEFM  'Dateiname= Dez/Text'
  8291    69 6E 61 6D           
  8295    65 3D 20 44           
  8299    65 7A 2F 54           
  829D    65 78 74              
  0025                          PROZX   EQU     $-PROZ
        MACRO-80 3.43   27-Jul-81       PAGE    1-55


                                
  82A0    1B 5B 32 34           DERR:   DEFB 1BH,5BH,32H,34H,3BH,31H,31H,48H
  82A4    3B 31 31 48           
  82A8    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH,1BH,5BH,34H,37H,6DH
  82AC    6D 1B 5B 34           
  82B0    37 6D                 
  82B2    44 49 53 4B                   DEFM  'DISK / HDD ERROR $'
  82B6    20 2F 20 48           
  82BA    44 44 20 45           
  82BE    52 52 4F 52           
  82C2    20 24                 
  82C4    05 05                         DEFB 05H,05H
  0026                          L_DERR  EQU $-DERR
                                ;---------------------------
  82C6    43 00 00 00           NBLASE: DEFB  MNBL1,00H,00H,00H,80H,00H                       ;         
  82CA    80 00                 
                                        ;------------------
  82CC    1B 5B 32 4A           NBL1:   DEFB  1BH,5BH,32H,4AH,1BH,5BH,48H,1BH,5BH,33H,37H,6DH ; 12 Zeichen
  82D0    1B 5B 48 1B           
  82D4    5B 33 37 6D           
  82D8    1B 5B 31 6D                   DEFB  1BH,5BH,31H,6DH,1BH,5BH,34H,34H,6DH             ; 9 ZEICHEN
  82DC    1B 5B 34 34           
  82E0    6D                    
  82E1    20 20 20 20                   DEFM '                                              ' ; 46 ZEICHEN
  82E5    20 20 20 20           
  82E9    20 20 20 20           
  82ED    20 20 20 20           
  82F1    20 20 20 20           
  82F5    20 20 20 20           
  82F9    20 20 20 20           
  82FD    20 20 20 20           
  8301    20 20 20 20           
  8305    20 20 20 20           
  8309    20 20 20 20           
  830D    20 20                 
  0043                          MNBL1   EQU $-NBL1
                                        ; Taste
  830F    00                            DEFB 00H                                        ; Key Eingabe
                                        ; Programm
  8310    01                            DEFB 01H                                        ; Programme
  8311    0A                            DEFB 0AH                                        ; Leange Programm
  8312    4D 41 53 4B                   DEFM 'MASKE1.COM  '                             ; 10 ZEICHEN
  8316    45 31 2E 43           
  831A    4F 4D 20 20           
  831E    39                            DEFB 57D                                        ; zum naechsten Textlaenge
  831F    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH                        ; 5 ZEICHEN
  8323    6D                    
  8324    1B 5B 30 33                   DEFB 1BH,5BH,30H,33H,3BH,30H,31H,48H            ; 8 ZEICHEN
  8328    3B 30 31 48           
  832C    09 09 09                      DEFB 09H,09H,09H                                ; 3 ZEICHEN     
  832F    4E 65 75 65                   DEFM 'Neue Seite eroeffnet'                     ; 20 ZEICHEN
  8333    20 53 65 69           
  8337    74 65 20 65           
  833B    72 6F 65 66           
  833F    66 6E 65 74           
  8343    0A 0D                         DEFB 0AH,0DH                                    ; 2 ZEICHEN     
        MACRO-80 3.43   27-Jul-81       PAGE    1-56


  8345    20 31 20 20                   DEFM ' 1  A'                                    ; 5 ZEICHEN
  8349    41                    
  834A    0A 0D                         DEFB 0AH,0DH                                    ; 2 ZEICHEN
  834C    20 32 20 20                   DEFM ' 2  S'                                    ; 5 ZEICHEN     
  8350    53                    
  8351    0A 0D                         DEFB 0AH,0DH                                    ; 2 ZEICHEN
  8353    20 39 20 20                   DEFM ' 9  E'                                    ; 5 ZEICHEN
  8357    45                    
                                        ; TASTE
  8358    10                            DEFB 10H
                                        ; PROGRAMM
  8359    02                            DEFB 02H
  835A    08                            DEFB 08D
  835B    41 55 54 4F                   DEFM 'AUTO.COM    '
  835F    2E 43 4F 4D           
  8363    20 20 20 20           
  8367    07                            DEFB 07D        
  8368    4D 45 4D 2E                   DEFM 'MEM.COM     '
  836C    43 4F 4D 20           
  8370    20 20 20 20           
  8374    00 00                         DEFB 00H,00H     ; 00= keine Keyeingabe folgend, 00= kein Progr.
                                
  00B0                          NBLLE   EQU     $-NBLASE
                                
  8376    43 00 00 01           TBLASE: DEFB  MTBLA1,00H,00H,01H,80H,00H                                ;       
  837A    80 00                 
                                        ;------------
  837C    1B 5B 30 6D           TBLA1:  DEFB  1BH,5BH,30H,6DH,1BH,5BH,48H,1BH,5BH,33H,37H,6DH   ; 12 Zeichen
  8380    1B 5B 48 1B           
  8384    5B 33 37 6D           
  8388    1B 5B 31 6D                   DEFB  1BH,5BH,31H,6DH,1BH,5BH,34H,34H,6DH               ; 9 ZEICHEN
  838C    1B 5B 34 34           
  8390    6D                    
  8391    20 20 20 20                   DEFM '                                              '   ; 46 ZEICHEN
  8395    20 20 20 20           
  8399    20 20 20 20           
  839D    20 20 20 20           
  83A1    20 20 20 20           
  83A5    20 20 20 20           
  83A9    20 20 20 20           
  83AD    20 20 20 20           
  83B1    20 20 20 20           
  83B5    20 20 20 20           
  83B9    20 20 20 20           
  83BD    20 20                 
  0043                          MTBLA1  EQU $-TBLA1
                                        ; Taste
  83BF    00                            DEFB 00H                                        ; Key Eingabe
                                        ; Programm
  83C0    01                            DEFB 01H                                        ; Programme
  83C1    0A                            DEFB 0AH                                        ; Leange Programm
  83C2    45 44 49 54                   DEFM 'EDITOR.COM  '                             ; 10 ZEICHEN
  83C6    4F 52 2E 43           
  83CA    4F 4D 20 20           
  0058                          TBLLE   EQU     $-TBLASE
                                
        MACRO-80 3.43   27-Jul-81       PAGE    1-57


  83CE    43 00 02 00           SMASKE: DEFB MSMAS1,00H,02H,00H,76H,80H
  83D2    76 80                 
                                        ;-------------------
                                        ; BLOCK LAENG OBEN SMASKE ERSTER WERT(43H)
  83D4    1B 5B 32 4A           SMAS1:  DEFB 1BH,5BH,32H,4AH,1BH,5BH,48H,1BH,5BH,33H,37H,6DH
  83D8    1B 5B 48 1B           
  83DC    5B 33 37 6D           
  83E0    1B 5B 31 6D                   DEFB 1BH,5BH,31H,6DH,1BH,5BH,34H,34H,6DH
  83E4    1B 5B 34 34           
  83E8    6D                    
  83E9    53 74 61 72                   DEFM 'Start                                         ' ;46D Zeichen
  83ED    74 20 20 20           
  83F1    20 20 20 20           
  83F5    20 20 20 20           
  83F9    20 20 20 20           
  83FD    20 20 20 20           
  8401    20 20 20 20           
  8405    20 20 20 20           
  8409    20 20 20 20           
  840D    20 20 20 20           
  8411    20 20 20 20           
  8415    20 20                 
                                        ;------------------
  0043                          MSMAS1  EQU $-SMAS1
  8417    00                            DEFB 00H        
  8418    01                            DEFB 01H        ; ANZAHL PROGRAMMAUFRUFE
  8419    0A                            DEFB 0AH        ; FILE NAME LAENGE
  841A    4D 41 53 4B                   DEFM 'MASKE1.COM'
  841E    45 31 2E 43           
  8422    4F 4D                 
  8424    20 20 20 20                   DEFM '      Ersatzseite KI-System V1.0 '
  8428    20 20 45 72           
  842C    73 61 74 7A           
  8430    73 65 69 74           
  8434    65 20 4B 49           
  8438    2D 53 79 73           
  843C    74 65 6D 20           
  8440    56 31 2E 30           
  8444    20                    
  8445    0D 0A                         DEFB 0DH,0AH
  8447    10                            DEFB 10H        ; TASTATUR MENGE ZEICHENEINGABE
  8448    01                            DEFB 01H        ; ANZAHL PROGRAMMAUFRUFE
  8449    07                            DEFB 07H        ; FILE NAME LAENGE
  844A    4D 45 4D 2E                   DEFM 'MEM.COM'
  844E    43 4F 4D              
  0083                          SRAL    EQU $-SMASKE
                                
  8451    39                            DEFB 57D
  8452    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH                        ; 5 ZEICHEN
  8456    6D                    
  8457    1B 5B 30 33                   DEFB 1BH,5BH,30H,33H,3BH,30H,31H,48H            ; 8 ZEICHEN
  845B    3B 30 31 48           
  845F    09 09 09                      DEFB 09H,09H,09H                                ; 3 ZEICHEN     
  8462    4E 65 75 65                   DEFM 'Neue TYPE2 eroeffnet'                     ; 20 ZEICHEN
  8466    20 54 59 50           
  846A    45 32 20 65           
        MACRO-80 3.43   27-Jul-81       PAGE    1-58


  846E    72 6F 65 66           
  8472    66 6E 65 74           
  8476    0A 0D                         DEFB 0AH,0DH                                    ; 2 ZEICHEN     
  8478    20 30 20 41                   DEFM ' 0 A?'                                    ; 5 ZEICHEN
  847C    3F                    
  847D    0A 0D                         DEFB 0AH,0DH                                    ; 2 ZEICHEN
  847F    20 31 20 20                   DEFM ' 1  S'                                    ; 5 ZEICHEN     
  8483    53                    
  8484    0A 0D                         DEFB 0AH,0DH                                    ; 2 ZEICHEN
  8486    20 39 20 20                   DEFM ' 9  E'                                    ; 5 ZEICHEN
  848A    45                    
                                        ; TASTE
  848B    10                            DEFB 10H
                                        ; PROGRAMM
  848C    01                            DEFB 01H
  848D    07                            DEFB 07H        
  848E    4D 45 4D 2E                   DEFM 'MEM.COM     '
  8492    43 4F 4D 20           
  8496    20 20 20 20           
  849A    00 00                         DEFB 00H,00H     ; 00= keine Keyeingabe folgend, 00= kein Progr.
                                
                                END
        MACRO-80 3.43   27-Jul-81       PAGE    S


Macros:

Symbols:
7609    _ED12           78DB    _WAIT1          7EC7    ASCII_CODE      
7EE0    ASC_1           7EF0    ASC_2           0047    BAUD1           
0047    BAUD2           0047    BAUD3           7FF4    BF00            
7FFA    BF01            8000    BF02            8006    BF03            
800C    BF04            8012    BF05            8018    BF06            
801C    BF07            8020    BF10            6503    BFRHH           
6502    BFRHL           6501    BFRLH           6500    BFRLL           
650F    BFSHH           650E    BFSHL           650D    BFSLH           
650C    BFSLL           650B    BFVHH           650A    BFVHL           
6509    BFVLH           6508    BFVLL           7FE8    BIOS            
706E    BL              70A9    BL00            70C8    BL000           
70DD    BL01            7171    BL02            71A8    BL021           
7211    BL022           7217    BL023           720E    BL02X           
7219    BL03            7234    BL030           722A    BL031           
7252    BL033           732D    BL04            71B4    BL120           
7207    BL121           71E7    BL123           71F9    BL124           
7200    BL125           728B    BL13            726E    BL131           
7273    BL132           733D    BL14            729A    BL23            
72A2    BL231           72B2    BL33            72BD    BL43            
72C8    BL53            72E8    BL73            72EE    BL736           
72FB    BL83            731F    BL830           7327    BL831           
7316    BL84            6200    BLAN            7345    BS10            
6205    BSTAT           0080    BUFF            0020    CMD_READSEC     
0030    CMD_WRITESEC    78B4    COFF            705F    COL0            
8033    COL01           7064    COL1            8202    COMZ            
0026    COMZX           78A3    CON             6C3F    COP             
0007    CPOS            0010    CTC             78BB    CUR01           
78AA    CUR02           7F90    CUR03           8042    CUROFF          
803C    CURON           6518    CURS            651C    CURT            
0007    CURUD           7859    CUT             8028    DAYJ            
8029    DAYM            802A    DAYT            802B    DAYZ            
00F4    DCI             0001    DCLR            000C    DCON            
82A0    DERR            0002    DHOM            794D    DISK            
0001    DISPLAY         8048    EBUFF           8078    EBUFFE          
75A6    ED00            7598    ED01            75A0    ED02            
75FB    ED03            75CA    ED10            75F2    ED100           
75F5    ED11            7607    ED12            761F    ED13            
763D    ED14            7642    ED15            763F    ED20            
7645    ED30            765D    ED31            7670    ED32            
7672    ED33            7674    ED40            767F    ED41            
768E    ED42            7693    ED43            7698    ED44            
76AB    ED441           76C2    ED442           76C6    ED50            
76DB    ED51            7580    EING            76DD    EING11          
770C    EING21          771C    EING22          7737    EING23          
7747    EING24          7756    EING25          776F    EING26          
7771    EING27          7779    EING30          0040    EOFF            
7FA8    EPROMON         790D    ERR1            724D    EXIT            
7F9F    EXTERN          7162    EZ01            716E    EZ02            
7102    EZ03            7132    EZ04            0044    EZLEN           
005C    FCB             006B    FCBCR           005D    FCBFN           
0065    FCBFT           007C    FCBRA           79A1    FREI            
0005    FSET            0800    HDD             00BE    HDDE            
78FC    HDD_ERROR       7915    HDD_INFO        78E2    HDD_INIT        
7923    HDD_READ        78DB    HDD_WAIT        7DF2    HDIST           
        MACRO-80 3.43   27-Jul-81       PAGE    S-1


781C    HEX00           77C5    HEX11           77D8    HEX12           
781C    HEX14           7811    HEXA            7894    HEXC            
77BA    HEXI1           77CD    HEXI2           77DC    HEXIE           
77DF    HEXP            00F0    IDE             00FD    IDECHI          
00FC    IDECLO          00FF    IDECMD          00F8    IDEDAT          
00F6    IDEDOR          00F9    IDEERR          7931    IDERES          
7937    IDERES1         00FA    IDESCNT         00FE    IDESDH          
00FB    IDESNUM         00FF    IDESTAT         7F98    INTERN          
0000    KANAL0          0001    KANAL1          0003    KANAL3          
0004    KANAL4          0005    KANAL5          79BB    KEY01           
0002    KEYIN           0001    KEYOUT          79A9    KEYST           
8228    KEYZ            001D    KEYZX           701E    KI              
7090    KI1             00F5    LATCH           79BD    LBA0            
7A06    LBA20           7A07    LBA21           7A03    LBA4            
7A0C    LBA5            0060    LCD             81ED    LCDE            
0015    LCDEX           7AB5    LIS0            7AB7    LIS1            
7A91    LIST            6513    LOGHH           6512    LOGHL           
6511    LOGLH           6510    LOGLL           0100    LOS             
0120    LOS1            0010    LSTEX           0026    L_DERR          
7A46    L__6            7A3E    L__7            777F    MAS00           
778F    MAS01           77AB    MAS02           8245    MELD01          
0036    MELD01X         A101    MMC             0007    MMCE            
0043    MNBL1           0043    MSMAS1          0043    MTBLA1          
82CC    NBL1            82C6    NBLASE          00B0    NBLLE           
001C    PIOA            001E    PIOB            81D4    PRLO1           
0130    PRO             7000    PROG            827B    PROZ            
0025    PROZX           0005    P_READ          0006    P_WRITE         
6524    RADR            6000    RAM             0021    RAMH            
0000    RAML            6727    RAMS            6B27    RAMT            
6527    RAMV            0000    RBLAN           0005    RBSTAT          
7C9B    RD01            7D57    RD02            7D08    RD03            
7C37    RD06            7B45    RD07            7B48    RD08            
7B50    RD09            7C70    RD16            7C7D    RD17            
7C85    RD170           7C90    RD171           7BDC    RD25            
7C0E    RD250           7BF0    RD255           7BFA    RD26            
7D3D    RD30            7C2C    RD35            7C1A    RD36            
7D6B    RD90            7D8F    RD91            7D92    RD911           
7D98    RD92            7C53    RDD1            7DA5    RDREAD          
7F85    RDU01           7F88    RDU02           7F69    RDU03           
7DCE    RDWRITE         F814    READ            0000    REG1            
00C1    REG3            0044    REG4            00EA    REG5            
7A5D    RLIST           6526    RMEN            0006    RSOTR           
0004    RTERM           6BEF    RTEX            0002    RTYPE1          
0003    RTYPE2          7018    RUN             0001    RUSER           
7849    SA1             784D    SA2             784F    SA3             
6520    SANDB           7839    SANDU           0020    SDC             
0004    SELDM           00F7    SELDS           F838    SELDSK          
F82F    SETDMA          F835    SETSEC          F832    SETTRK          
0018    SIOA            001A    SIOB            0018    SIORES          
83D4    SMAS1           83CE    SMASKE          0083    SRAL            
81DD    STEX            7378    STX01           736A    SU00            
737E    SU01            73CD    SU02            73D0    SU03            
73E4    SU04            74A8    SU21            755D    SU23            
748D    SU25            7565    SU32            7573    SU33            
753B    SU52            754F    SU520           74B1    SU62            
74E3    SU63            746D    SU80            7423    SU82            
        MACRO-80 3.43   27-Jul-81       PAGE    S-2


7433    SU83            743C    SU84            741B    SU85            
745A    SU86            7467    SU87            740A    SU88            
74F4    SU90            7538    SU95            7504    SU99            
797F    SUCH0           798D    SUCH1           798F    SUCH2           
7000    T0              7003    T1              7006    T2              
7009    T3              700C    T4              700F    T5              
7012    T6              7015    T7              7AC2    TAS             
7B21    TAS00           7BAF    TAS03           7CDA    TAS22           
7D00    TAS24           7DFA    TASK            7E45    TASK99          
FFA2    TASKSP          837C    TBLA1           8376    TBLASE          
0058    TBLLE           7262    TEING           6204    TERM            
7FA4    TERN            7FB1    TEX1            7FC1    TEX2            
7FD1    TEX2I           7FD5    TEX3            0004    TIME1           
0004    TIME2           0004    TIME3           FFAB    TRACK           
FFA5    TRACKH          FFA4    TRACKL          7E49    TWRITE          
0010    TXL             0013    TXL3            6202    TYPE1           
6203    TYPE2           7E6D    UHR00           7EBA    UHR01           
7EF8    UHR10           0080    URCS            6201    USER            
78D0    WAITDRQ         78C5    WAITRDY         00F0    WDTCR           
00F1    WDTER           7A79    WLIST           F817    WRITE           
81B9    ZCUR            77B6    ZEI00           8031    ZEIL            



No Fatal error(s)

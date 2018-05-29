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
  0009                   C      KEYBUF  EQU 09H         ; input keypad buffer, end with <cr> 
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
        MACRO-80 3.43   27-Jul-81       PAGE    1-3


  0004                          TIME2   EQU 04H         ;
                                
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
        MACRO-80 3.43   27-Jul-81       PAGE    1-4


                                ;------------
                                ; DRIVE NEU SET MASTER/SLAVE
                                ;
  0126    3A FD1A                       LD A,(0FD1AH)
  0129    FE A5                         CP 0A5H
  012B    3E F5                         LD A,0F5H
                                        ;LD (0FD1AH),A
  012D    C3 701E                       JP RUN          ;PROGRAMM Start
                                ;----------------
  0130                          PRO:
                                
                                .PHASE PROG
                                
  7000    C9                    T0:     RET
  7001    00                            NOP
  7002    00                            NOP
  7003    C3 7802               T1:     JP HEXC         ; ZEICHENAUSGEBEN
  7006    C3 79B7               T2:     JP KEYST        ; TASTENABFRABE OHNE SORTIERUNG
  7009    C3 78ED               T3:     JP SUCH0        ; Blase mit Eintrag aus RAMT suchen  
  700C    C3 79CB               T4:     JP LBA0         ; Plattenzugriff (DE), (HL) +1
  700F    C3 7DB9               T5:     JP RDREAD       ; lesen einer Blase
  7012    C3 7DE2               T6:     JP RDWRITE      ; Speichern einer Blase
  7015    C3 77CB               T7:     JP CUT          ; CURSOR POS SET IN (CURT)0-3
  7018    C3 7AA3               T8:     JP LIST         ; CURSOR POS SET IN BC
  701B    C3 7917               T9:     JP KEYB         ; input keypad buffer, end with <cr>
                                ;-----------------------
                                ;  LCD 128X128 ANSTEUERN
  701E    DB 1C                 RUN:    IN A,(PIOA)
  7020    CB BF                         RES 7,A         ; INTERN
  7022    D3 1C                         OUT (PIOA),A
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
        MACRO-80 3.43   27-Jul-81       PAGE    1-5


                                ;       CALL DT2
                                ;       LD A,ADPSET
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
                                
  7024    21 0000               KI:     LD HL,0000H
  7027    22 8032                       LD (BF07+2),HL
  702A    22 6502                       LD (BFRHL),HL           ; AKTUELL TRACK/SECTORADRESSE LADEN
                                        ; SORTIERE IN BFS...
  702D    22 650E                       LD (BFSHL),HL           ; IN BFS ADRESSE ZUM SORZIEREN
  7030    22 6512                       LD (BFSHL+4),HL
  7033    22 6512                       LD (LOGHL),HL
  7036    21 0010                       LD HL,0010H             ; STARTADR. USER-LOGIN AUF HDD
  7039    22 6510                       LD (LOGLL),HL
  703C    21 0800                       LD HL,HDD               ; HD STARTADRESSE
  703F    22 8030                       LD (BF07),HL
  7042    22 6500                       LD (BFRLL),HL           ; AKTUELLE TRACK/SECTORADRESSE LADEN
                                        ;-----------------------
                                        ; SORTIER STARTADRESSE SETZEN 
                                        ; BLASE1 UND BLASE2+4 AUS HDD STARTADRESSE+1
  7045    23                            INC HL          ; 
  7046    22 650C                       LD (BFSLL),HL   ; Sortieranfang
  7049    22 6510                       LD (BFSLL+4),HL ; Sortieranfang
                                
                                        ;------------------
                                        ; Cursor REGISTER auf Z=24, S=1 setzen
  704C    01 2401                       LD BC,2401H
  704F    CD 7018                       CALL T8
                                        ;
                                        ;------------------
                                        ; BF00 beim Neustart auf Null setzen 
                                        ; Suchparameter fuer neue Blase 
                                        ; USER wird nur durch Login veraendert
                                        ; TYPE1, TYPE2 aus Blasendaten 
  7052    AF                            XOR A
  7053    32 8008                       LD (BF00),A
  7056    32 8009                       LD (BF00+RUSER),A
  7059    32 800A                       LD (BF00+RTYPE1),A
  705C    32 800B                       LD (BF00+RTYPE2),A
  705F    32 800C                       LD (BF00+RTERM),A
                                        ;----------
  7062    C5                            PUSH BC
  7063    D5                            PUSH DE
  7064    E5                            PUSH HL
  7065    21 8047               COL0:   LD HL,COL01             ; BILDSCHIRM FARBE
        MACRO-80 3.43   27-Jul-81       PAGE    1-6


  7068    06 09                         LD B,09D                ; AUSGABELAENGE
  706A    7E                    COL1:   LD A,(HL)
  706B    CD 7802                       CALL HEXC
  706E    23                            INC HL
  706F    10 F9                         DJNZ COL1
  7071    E1                            POP HL
  7072    D1                            POP DE
  7073    C1                            POP BC
                                ;       JR KI1          ;!!STARTSEITE NICHT DA ->
                                        ;---
                                        ; Blase aus BFRxx laden
  7074    AF                    BL:     XOR A
  7075    ED 4B 6500                    LD BC,(BFRLL)   ; Aktuelle HIGH LBA laden
  7079    ED 5B 6502                    LD DE,(BFRHL)   ; Aktuelle LOW LBA laden
  707D    21 6000                       LD HL,RAM       ; DMA
  7080    CD 7DB9                       CALL RDREAD
                                        ;------
                                        ; READ SICHTBAR MACHEN
                                ;!!!    LD BC,0501H
                                ;!!!    CALL T8
                                ;!!!    LD HL,RAM
                                ;!!!    CALL LIS0
  7083    3A 6000                       LD A,(RAM)
  7086    FE 43                         CP 43H
  7088    CA 7096                       JP Z,KI1
                                        ;-------------------
  708B    21 83D4                       LD HL,SMASKE            ; STARTMASKE LADEN
  708E    11 6000                       LD DE,RAM
  7091    01 0088                       LD BC,SRAL
  7094    ED B0                         LDIR
  7096    3E 0A                 KI1:    LD A,0AH        ; >9
  7098    32 8042                       LD (DAYZ+3),A   ; UHRZEIT LOESCHEN DAMIT GLEICH AUSGEGEBEN WIRD
                                        ;------------
                                        ; Blasenstatus schon mal auf benutzt setzen
                                        ; IN AKTUELLER BLASE RAM
  709B    3A 6005                       LD A,(RAM+RBSTAT)       ; RAM
  709E    CB FF                         SET 7,A         ; GedankenStatus Zaehler 0= minus 1= plus
  70A0    CB B7                         RES 6,A         ; Sortieren aktivieren
  70A2    32 6005                       LD (RAM+RBSTAT),A       ; AUS AKTUELLER BLASE
                                ; ???
  70A5    3A 6205                       LD A,(BLAN+RBSTAT)      ; RAM+200
  70A8    CB FF                         SET 7,A         ; Gedankenzaehler 0= minus 1= plus
  70AA    CB B7                         RES 6,A         ; Sortieren aktivieren
  70AC    32 6205                       LD (BLAN+RBSTAT),A      ; VORBEREITEN
                                ; ???
                                        ;---------------------------------
                                        ;  gebe die laenge von B auf VT100 Bildschirm aus 
                                        ;
  70AF    21 6000               BL00:   LD HL,RAM       ; BLASE address
  70B2    22 6524                       LD (RADR),HL    ; cache current BLASE address
  70B5    7E                            LD A,(HL)       ; Number of characters from mask
  70B6    32 6526                       LD (RMEN),A     ; caching character length
  70B9    11 6000                       LD DE,RAM
  70BC    ED 52                         SBC HL,DE       ; determine BLASEN start
  70BE    2A 6524                       LD HL,(RADR)    ; load current BLASE address
  70C1    20 09                         JR NZ,BL000     ; no BLASEN start ->
        MACRO-80 3.43   27-Jul-81       PAGE    1-7


                                        ;-----------------------
                                        ; BLASEN beginning new
                                        ; load restart parameter
  70C3    23                            INC HL          ; ->USER
  70C4    23                            INC HL          ; ->TYPE1
  70C5    7E                            LD A,(HL)       ; load type1
  70C6    32 800A                       LD (BF00+RTYPE1),A      
  70C9    23                            INC HL          ; ->Type2
  70CA    23                            INC HL          ; ->Gedaechtniszaehler
  70CB    23                            INC HL          ; ->Status Byte
                                        ;----------------
  70CC    3A 6526               BL000:  LD A,(RMEN)     ; load character length
  70CF    47                            LD B,A          ; B= counter
  70D0    AF                            XOR A           ; LOESCHEN
  70D1    B8                            CP B            ; counter > 0
  70D2    CA 74F2                       JP Z,EING       ; jump to the input =0 ->
                                        ;--------------------------------
                                        ; SET CURSOR UND Block output 
                                        ;
  70D5    E5                            PUSH HL
  70D6    C5                            PUSH BC
  70D7    01 0101                       LD BC,0101H
  70DA    CD 7018                       CALL T8         ; set cursor
  70DD    C1                            POP BC
  70DE    E1                            POP HL
  70DF    23                    BL01:   INC HL          ; from here graphic/text area
  70E0    7E                            LD A,(HL)       
  70E1    CD 7802                       CALL HEXC       ; output area 
  70E4    10 F9                         DJNZ BL01       ; counter[B
  70E6    22 6524                       LD (RADR),HL    ; cache current BLASE address
                                        ; (HL) KOPFZEILE ENDE
                                        ;---------------------------
                                        ; Issue Blasen parameters USER,TYPE1,TYPE2,
                                        ; memory in % 
                                        ; top right Z=1, S=60
                                        ;
  70E9    E5                            PUSH HL         ; RETTE BLASE
  70EA    D5                            PUSH DE
  70EB    C5                            PUSH BC
  70EC    01 0160                       LD BC,0160H     
  70EF    CD 7018                       CALL T8         ; set cursor
  70F2    C1                            POP BC
  70F3    21 6001                       LD HL,RAM+RUSER         ; USER address from current BLASE
  70F6    C5                            PUSH BC
  70F7    4E                            LD C,(HL)       ; USER load
  70F8    C5                            PUSH BC
  70F9    CD 778E                       CALL HEX14      ; USER / %
  70FC    C1                            POP BC
  70FD    C1                            POP BC
  70FE    2A 6002                       LD HL,(RAM+RTYPE1)      ; TYPE2=L ,TYPE1=H LADEN
                                        ;---------------------
                                        ; output memory count in %
  7101    3A 6004                       LD A,(RAM+RTERM)        ; memory count load
  7104    5F                            LD E,A  
  7105    3E 00                         LD A,00H
  7107    F5                    EZ03:   PUSH AF
        MACRO-80 3.43   27-Jul-81       PAGE    1-8


  7108    7B                            LD A,E
  7109    D6 02                         SUB 02H
  710B    FE 03                         CP 03h
  710D    38 28                         JR C,EZ04
  710F    28 26                         JR Z,EZ04
  7111    5F                            LD E,A
  7112    F1                            POP AF
  7113    3C                            INC A
  7114    27                            DAA
  7115    F5                            PUSH AF
  7116    7B                            LD A,E
  7117    D6 03                         SUB 03H
  7119    FE 03                         CP 03H
  711B    38 1A                         JR C,EZ04
  711D    28 18                         JR Z,EZ04
  711F    5F                            LD E,A
  7120    F1                            POP AF
  7121    3C                            INC A
  7122    27                            DAA
  7123    CB 47                         BIT 0,A
  7125    28 E0                         JR Z,EZ03
  7127    F5                            PUSH AF
  7128    7B                            LD A,E
  7129    D6 03                         SUB 03H
  712B    FE 03                         CP 03H
  712D    38 08                         JR C,EZ04
  712F    28 06                         JR Z,EZ04
  7131    5F                            LD E,A
  7132    F1                            POP AF
  7133    3C                            INC A
  7134    27                            DAA
  7135    18 D0                         JR EZ03
                                        ;-------------------
  7137    F1                    EZ04:   POP AF
  7138    C5                            PUSH BC
  7139    4F                            LD C,A
  713A    C5                            PUSH BC
  713B    CD 778E                       CALL HEX00              ; % WERT AUSGEBEN
  713E    C1                            POP BC
  713F    C1                            POP BC
  7140    3E 25                         LD A,'%'                ; % ALS ZEICHEN
  7142    CD 7802                       CALL HEXC
  7145    D1                            POP DE
  7146    E1                            POP HL
  7147    2A 6524                       LD HL,(RADR)    ; load current BLASE address
                                        ; from here against BLASEN address
                                        ;-------------------------------
                                        ; key in sign
                                        ;
  714A    23                            INC HL          ; next block
  714B    46                            LD B,(HL)       ; load block length 
  714C    E5                            PUSH HL
  714D    21 6B27                       LD HL,RAMT      ; RAMT Zeichen Buffer Eingaben
  7150    11 6B27                       LD DE,RAMT
  7153    13                            INC DE          ; fuer erstes Zeichen
  7154    AF                            XOR A
        MACRO-80 3.43   27-Jul-81       PAGE    1-9


  7155    77                            LD (HL),A       ; Eingabe Zeichenzaehler auf Null setzen
  7156    B8                            CP B
  7157    CA 7189                       JP Z,BL03       ; SPEUNG ZUR EINGABE OHNE GRAFIK AUSGABE 
                                        ;--------------------------
                                        ; Eingabezeile ausgeben
  715A    D5                            PUSH DE
  715B    E5                            PUSH HL         ; Grafik/Text 
  715C    C5                            PUSH BC
  715D    3A 6003                       LD A,(RAM+RTYPE2)
  7160    FE 00                         CP 0H
  7162    C2 7171                       JP NZ,EZ02
  7165    21 805C                       LD HL,EBUFF
  7168    06 36                         LD B,EZLEN
  716A    7E                    EZ01:   LD A,(HL)
  716B    CD 7802                       CALL HEXC
  716E    23                            INC HL
  716F    10 F9                         DJNZ EZ01
  7171    C1                    EZ02:   POP BC
  7172    E1                            POP HL
  7173    D1                            POP DE
  7174    C5                    BL02:   PUSH BC
  7175    D5                            PUSH DE
  7176    E5                            PUSH HL
  7177    CD 7AD6                       CALL TAS        ; auf Zeichen Warten
  717A    F5                            PUSH AF
  717B    CD 7811                       CALL CON        ; CURSOR ON
  717E    F1                            POP AF
  717F    E1                            POP HL
  7180    D1                            POP DE
  7181    C1                            POP BC
  7182    CD 701B                       CALL T9
  7185    FE 0D                         CP 0DH
  7187    20 EB                         JR NZ,BL02
                                ;-----------------------
                                ; load and execute file.com
                                ;
  7189    E1                    BL03:   POP HL          ; zurueck zur aktuellen RAM adre.
  718A    7E                            LD A,(HL)       ; Pruefe ob Zeiche ??Programmaufruf da 
  718B    23                            INC HL          ; PROGRAMM 
  718C    FE 00                         CP 00H
  718E    28 0A                         JR Z,BL031      ; ->set Programm number (Maske1 = 1)
  7190    3A 6B27                       LD A,(RAMT)
  7193    FE 00                         CP 00H
  7195    20 0D                         JR NZ,BL030
  7197    C3 70B2                       JP BL00+3       ; +3 VERSUCH !!!!kein Zeichen gedruekt
                                        ;------------------------
  719A    3E 31                 BL031:  LD A,31H        ; sonst Zeichenzaehler auf 1 setzen
  719C    32 6B28                       LD (RAMT+1),A   ; 
  719F    3E 01                         LD A,01H        ; Programme mindest ASCII 1
  71A1    32 6B27                       LD (RAMT),A     ; Programmzaehler
  71A4    46                    BL030:  LD B,(HL)       ; Anzahl von Programmaufrufe aus Blase
  71A5    AF                            XOR A           ; LOESCHEN
  71A6    B8                            CP B
  71A7    CA 72AF                       JP Z,BL14       ; SPEUNG 
                                        ;--------------
  71AA    3A 6B27                       LD A,(RAMT)     ; Anzahl der Taste 
        MACRO-80 3.43   27-Jul-81       PAGE    1-10


  71AD    FE 02                         CP 02H          ; ZEICHEN ZAEHLER >
  71AF    D2 72AF                       JP NC,BL14      ; Taste mehr als eine Stelle
  71B2    3A 6B28                       LD A,(RAMT+1)   ; gedruektes Taste =31-39  Zeichen
  71B5    FE 30                         CP 30H
  71B7    28 19                         JR Z,TEING      ; ??Aender moeglich machen mit 0
  71B9    FE 39                         CP 39H          ; MIT 9 ENDE
  71BB    20 05                         JR NZ,BL033
  71BD    0E 00                 EXIT:   LD C,00H
  71BF    C3 7FBC                       JP EPROMON
                                ;-------
  71C2    FE 3A                 BL033:  CP 3AH          ; nicht > 9
  71C4    D2 70AF                       JP NC,BL00      ; AUSGANG FEHLER
  71C7    D6 30                         SUB 30H         ; nicht < 1
  71C9    DA 70AF                       JP C,BL00       ; AUSGANG FEHLER
  71CC    47                            LD B,A          ; Welches Programm in A 1 - 9
                                ;!!!    INC HL ;!!! FEHLERSUCHE AUSGABE FALSCH
  71CD    22 6524                       LD (RADR),HL    ; aktuelle RAM Adresse retten 
  71D0    18 0C                         JR BL131
                                        ;-------------------
                                        ; AENDERUNG NUR IN TYPE2 =0 MOEGLICH
  71D2    3A 6003               TEING:  LD A,(RAM+RTYPE2)
  71D5    FE 00                         CP 0H
  71D7    CA 74F2                       JP Z,EING
  71DA    C3 70AF                       JP BL00
                                        ;-----------------
                                        ; Programm suchen und Starten
  71DD    19                            ADD HL,DE
  71DE    11 000C               BL131:  LD DE,000CH     ; MAX Laenge einer Datei
  71E1    10 FA                         DJNZ BL131-1    
  71E3    11 0080               BL132:  LD DE,BUFF      ; <- Zurueck von Zeilen-Prog.aufruf
                                ;!!!    INC HL          ; WIEVIEL ZEICHEN DATEINAME
                                ;!!!    LD A,(HL)       ; PRUEFE DAPROGRAMME 
                                ;!!!    CP 0H
                                ;!!!    JP Z,BL00       ; KEIN PROGRAMM =0 ->
  71E6    3E 0C                         LD A,12D
  71E8    12                            LD (DE),A
  71E9    13                            INC DE
  71EA    E6 0F                         AND 0FH
  71EC    47                            LD B,A          ; Laenge der Datei auslesen
  71ED    CD 71F6                       CALL BL13
  71F0    DA 7291                       JP C,BL830      ; ERROR DATEI NICHT GEFUNDEN
  71F3    C3 7288                       JP BL84
                                        ;-------------------
                                        ; PROGRAMM AUS (HL) ]BERNEHMEM UND LADEN
                                        ; B= LAENGE DES DATEINAMEN
                                        ; (HL) DATEINAME.COM
                                        ; NACH (DE) BUFFER COPIEREN 
                                        ;
  71F6    23                    BL13:   INC HL          ; DATEINAME ERSTES ZEICHEN
  71F7    7E                            LD A,(HL)
  71F8    FE 21                         CP 21H          ; PRUEFE OB NOCH ASCII >20H (SPACE)
  71FA    38 05                         JR C,BL13D      ; UMSTELLUNG DATEINAME IMMER 12D LANG
  71FC    12                            LD (DE),A
  71FD    CD 7802                       CALL HEXC       ;!!! PROGRAMM NAME SICHTBAR MACHEN ZUM TEST
  7200    13                            INC DE
  7201    10 F3                 BL13D:  DJNZ BL13
        MACRO-80 3.43   27-Jul-81       PAGE    1-11


  7203    AF                            XOR A
  7204    12                            LD (DE),A
                                        ;------------------
                                        ;
  7205    11 005D                       LD DE,FCBFN
  7208    3E 20                         LD A,20H
  720A    06 0B                         LD B,0BH
  720C    12                    BL23:   LD (DE),A       ; LOESCHEN B MAL
  720D    13                            INC DE
  720E    10 FC                         DJNZ BL23
  7210    3E 00                         LD A,00H
  7212    06 08                         LD B,08H
  7214    12                    BL231:  LD (DE),A       ; LOESCHEN B MAL
  7215    13                            INC DE
  7216    10 FC                         DJNZ BL231
                                        ;--------------
                                        ;
  7218    E5                            PUSH HL
  7219    11 005C                       LD DE,FCB
  721C    AF                            XOR A
  721D    12                            LD (DE),A
  721E    13                            INC DE
  721F    21 0080                       LD HL,BUFF
  7222    46                            LD B,(HL)       ; DATEINAMEN LAENGE
  7223    23                            INC HL
  7224    7E                    BL33:   LD A,(HL)
  7225    FE 2E                         CP 2EH          ; POINT ERKENNUNG .COM
  7227    20 06                         JR NZ,BL43
  7229    23                            INC HL
  722A    11 0065                       LD DE,FCBFT
  722D    18 F5                         JR BL33 
                                        ;-----------
  722F    12                    BL43:   LD (DE),A
  7230    13                            INC DE
  7231    23                            INC HL
  7232    10 F0                         DJNZ BL33
  7234    CD 789F                       CALL IDERES
  7237    AF                            XOR A
  7238    06 14                         LD B,14H
  723A    12                    BL53:   LD (DE),A
  723B    13                            INC DE
  723C    10 FC                         DJNZ BL53
  723E    1E 04                         LD E,SELDM      ; MASTER DISK
  7240    0E 0E                         LD C,14D
  7242    CD 0005                       CALL 0005H      ; BEZUGSLAUFWERK LW-NUMMER
  7245    E5                            PUSH HL
  7246    AF                            XOR A
  7247    32 006B                       LD (FCBCR),A    ; cr loeschen
  724A    11 005C                       LD DE,FCB
  724D    0E 0F                         LD C,0FH
  724F    CD 0005                       CALL 0005H
  7252    FE FF                         CP 0FFH
  7254    20 04                         JR NZ,BL73      ; ->kein Fehler POP HL fehlt
  7256    E1                            POP HL
  7257    E1                            POP HL          ; Adresse zurueck
  7258    37                            SCF
        MACRO-80 3.43   27-Jul-81       PAGE    1-12


  7259    C9                            RET
                                        ;--------------------
                                        ;  Dateisatz lesen
                                        ;
  725A    3A 007C               BL73:   LD A,(FCBRA)
  725D    11 0100                       LD DE,0100H     ; DMA Buffer
  7260    FE 00                 BL736:  CP 00H
  7262    28 09                         JR Z,BL83
  7264    3D                            DEC A
  7265    21 0080                       LD HL,0080H
  7268    19                            ADD HL,DE
  7269    E5                            PUSH HL
  726A    D1                            POP DE          ; HL nach DE kopieren
  726B    18 F3                         JR BL736
  726D    0E 1A                 BL83:   LD C,1AH        ; Datenbuffer festlegen
  726F    CD 0005                       CALL 0005H      ; CCP
  7272    E5                            PUSH HL
  7273    D5                            PUSH DE
  7274    C5                            PUSH BC
  7275    11 005C                       LD DE,FCB
  7278    0E 14                         LD C,14H
  727A    CD 0005                       CALL 0005H      ; Datei laden
  727D    C1                            POP BC
  727E    D1                            POP DE
  727F    E1                            POP HL
  7280    FE 00                         CP 00H
  7282    28 D6                         JR Z,BL73       ; wiederhole bie Datei geladen
  7284    E1                            POP HL          ; wenn bei BL53: kein Fehler RAM weiter
  7285    E1                            POP HL          ; Adresse zurueck
  7286    AF                            XOR A
  7287    C9                            RET
                                        ;---------------
                                        ; GEFUNDENES PROGRAMM STARTEN
                                        ;
  7288    E5                    BL84:   PUSH HL
  7289    D5                            PUSH DE
  728A    C5                            PUSH BC
  728B    CD 0100                       CALL 0100H
  728E    C1                            POP BC
  728F    D1                            POP DE
  7290    E1                            POP HL
                                        ;----------
                                        ; Ende der Programme berechnen
  7291    2A 6524               BL830:  LD HL,(RADR)    ; Aktuelle Blasenadresse holen
  7294    46                            LD B,(HL)       ; NAECHSTE DATEI LAENGE
  7295    04                            INC B           ; ERSTES ZEICHEN
  7296    18 01                         JR BL831
                                        ;-----------
  7298    19                            ADD HL,DE
  7299    11 000C               BL831:  LD DE,000CH     ; Laenge (13Dez.) einer Datei
  729C    10 FA                         DJNZ BL831-1    
  729E    23                            INC HL
                                        ;-----------------
                                        ; Sprungadresse in I/O-RAM (0) Laden
                                        ;
  729F    3A 6200               BL04:   LD A,(BLAN)     ; Rueckmeldung aus Unterprogramm
        MACRO-80 3.43   27-Jul-81       PAGE    1-13


  72A2    FE 00                         CP 00H
  72A4    CA 70AF                       JP Z,BL00       ; Blase neu starten
  72A7    FE 01                         CP 01H
  72A9    CA 70B2                       JP Z,BL00+3     ; naechster Block 
  72AC    C3 70AF                       JP BL00         ; weiter mit RAM
                                ;---------------------------
                                ; Aktuelle Blase im RAM nach Begriff durchsuchen
                                ;
  72AF    3A 6001               BL14:   LD A,(RAM+1)    ; Type1
  72B2    47                            LD B,A
                                ;??     LD A,(USER) TYPE1
  72B3    B8                            CP B
  72B4    CA 72B7                       JP Z,BS10               ; gefunden
                                ;---------------------------
                                ;  Blase vom Anfang aus nach RAMR laden und Text suchen
                                 
  72B7    3A 8009               BS10:   LD A,(BF00+RUSER)       ; UEBERNEHMEN
  72BA    32 8035                       LD (BF10+RUSER),A       ; loeschen 
  72BD    3A 800A                       LD A,(BF00+RTYPE1)      ; uebernehmen
  72C0    32 8036                       LD (BF10+RTYPE1),A      ; loeschen 
  72C3    3A 800B                       LD A,(BF00+RTYPE2)      ; uebernehmen 
  72C6    32 8037                       LD (BF10+RTYPE2),A      ; loeschen 
  72C9    32 8038                       LD (BF10+RTERM),A       ; loeschen 
  72CC    32 8039                       LD (BF10+RBSTAT),A      ; loeschen 
  72CF    AF                            XOR A
  72D0    32 650B                       LD (BFVHH),A    ; Aktuelle Track/Sectoradresse laden
  72D3    32 650A                       LD (BFVHL),A
  72D6    21 0801                       LD HL,HDD+1     ; Startadresse
  72D9    22 6508                       LD (BFVLL),HL   ; Aktuelle Track/Sectoradresse laden
                                ;-------------------------
                                ; Blase zum vergleich laden und Text in Speicher suchen
                                ;
  72DC    C5                    SU00:   PUSH BC
  72DD    D5                            PUSH DE
  72DE    E5                            PUSH HL
  72DF    CD 7822                       CALL COFF
  72E2    06 50                         LD B,80D
  72E4    21 6B27                       LD HL,RAMT
  72E7    11 6BEF                       LD DE,RTEX
  72EA    7E                    STX01:  LD A,(HL)
  72EB    12                            LD (DE),A
  72EC    23                            INC HL
  72ED    13                            INC DE
  72EE    10 FA                         DJNZ STX01
  72F0    ED 4B 6508            SU01:   LD BC,(BFVLL)
  72F4    ED 5B 650A                    LD DE,(BFVHL)           ; Suchadresse 
  72F8    21 6527                       LD HL,RAMV
  72FB    CD 7DB9                       CALL RDREAD             ; AKTUELLE BLASE LADEN
                                        ; READ SICHTBAR MACHEN
  72FE    01 1501                       LD BC,1501H
  7301    CD 7018                       CALL T8
  7304    21 6527                       LD HL,RAMV
  7307    CD 7AC9                       CALL LIS0
  730A    E5                            PUSH HL
  730B    21 0801                       LD HL,HDD+1
  730E    22 6510                       LD (BFSLL+4),HL
        MACRO-80 3.43   27-Jul-81       PAGE    1-14


  7311    21 0000                       LD HL,0000H
  7314    22 6512                       LD (BFSHL+4),HL
  7317    E1                            POP HL
                                        ;---------------------
                                        ; Cursor drehen lassen und
                                        ; nach Abstand gefundener Zeichen setzen
  7318    CD 7E81                       CALL UHR00
  731B    3E 02                         LD A,02H
  731D    32 651C                       LD (CURT),A
  7320    3E 04                         LD A,04H
  7322    32 651D                       LD (CURT+1),A
  7325    3E 02                         LD A,02H
  7327    32 651E                       LD (CURT+2),A
  732A    3A 6B27                       LD A,(RAMT)
  732D    FE 0A                         CP 0AH
  732F    38 0E                         JR C,SU02
  7331    D6 0A                         SUB 0AH
  7333    32 651F                       LD (CURT+3),A
  7336    3A 651E                       LD A,(CURT+2)
  7339    3C                            INC A
  733A    32 651E                       LD (CURT+2),A
  733D    18 03                         JR SU03
  733F    32 651F               SU02:   LD (CURT+3),A
                                        ;------------------------
                                        ; vergleich, suche nach Blasen beginnen
                                        ;
  7342    CD 77CB               SU03:   CALL CUT
  7345    21 6527                       LD HL,RAMV              ; in Blase suchen mit
  7348    11 6B27                       LD DE,RAMT              ; Textanfang 1. Zeichen
  734B    1A                            LD A,(DE)               ; neue TextLAENGE mit
  734C    FE 02                         CP 02H                  ; Suchtext muss > 1 Zeichen sein
  734E    DA 74AD                       JP C,SU52               ; Ausgang ohne suchtext
  7351    23                            INC HL                  ; ZU USER 
  7352    3A 8009                       LD A,(BF00+RUSER)       ; Aus sichtbarer aktuel Blase
  7355    BE                            CP (HL)                 ; RAMV VERGLEICH MIT USER IN BLASE 
                                        ;JP Z,SU80              ; User mit Blase ist gleich 
                                        ;JP NC,SU62             ; ERST IN USER+1 LEERE BLASE SUCHEN
  7356    3A 652B               SU04:   LD A,(RAMV+RTERM)       ; Gedaechtnisszaehler
  7359    FE FF                         CP 0FFH                 ; nach leerer ,abgelaufener Blase 
  735B    C2 7423                       JP NZ,SU62              ; noch nicht leer, abgelaufen
  735E    3A 6003                       LD A,(RAM+RTYPE2)       ; MUSS BLASENANFANG SEIN
  7361    FE 00                         CP 0H                   ; nach leerer ,abgelaufener Blase 
  7363    C2 74AD                       JP NZ,SU52              ; noch nicht leer, abgelaufen
                                ;-----------------------
                                ; neue Blase Eroeffnen mit Eingabetext 
                                ; als Ueberschrift
                                ;
                                ; Blasenadr. BFVxx mit BFRxx tauschen (HL)->(DE)
                                ;               
  7366    11 6500                       LD DE,BFRLL     ; Aktuelle Blaseadresse ersetzen durch
  7369    21 6508                       LD HL,BFVLL     ; Leere gefundene Blase
  736C    EB                            EX DE,HL        ; TAUSCHEN
                                        ;----------------
  736D    3A 8037                       LD A,(BF10+RTYPE2)
  7370    FE 00                         CP 0H
  7372    28 19                         JR Z,SU85
        MACRO-80 3.43   27-Jul-81       PAGE    1-15


  7374    06 19                         LD B,25D                ; laenge DES KOPFTEXT AUS Blase einkopieren
  7376    11 601B                       LD DE,RAM+1BH   ; Adr. Aktueller Blase
  7379    21 8398                       LD HL,TBLASE+1BH        ; Textblock leerer Blase
  737C    1A                    SU88:   LD A,(DE)
  737D    77                            LD (HL),A
  737E    23                            INC HL
  737F    13                            INC DE
  7380    10 FA                         DJNZ SU88
  7382    06 57                         LD B,TBLLE      ; laenge neuer Blase einkopieren
  7384    11 6000                       LD DE,RAM       ; Adr. Aktueller Blase
  7387    21 837D                       LD HL,TBLASE    ; Textblock leerer Blase
  738A    C3 7395                       JP SU82
                                        ;---------------
  738D    06 AD                 SU85:   LD B,NBLLE      ; laenge neuer Blase einkopieren
  738F    11 6000                       LD DE,RAM       ; Adr. Aktueller Blase
  7392    21 82D0                       LD HL,NBLASE    ; Textblock leerer Blase
  7395    7E                    SU82:   LD A,(HL)       ; kopieren
  7396    12                            LD (DE),A
  7397    23                            INC HL
  7398    13                            INC DE
  7399    10 FA                         DJNZ SU82
  739B    11 6001                       LD DE,RAM+1     ; Aktuelle USER
                                        ;----------------
                                        ; Ueberschrift aus suchtext einsetzen
  739E    3A 6B27                       LD A,(RAMT)
  73A1    47                            LD B,A          ; Textlaenge in B
  73A2    11 6000                       LD DE,RAM
  73A5    13                    SU83:   INC DE          ; Nach Space 20H suchen erstes Zeichen
  73A6    1A                            LD A,(DE)
  73A7    FE 20                         CP 20H
  73A9    20 FA                         JR NZ,SU83
                                        ;-----------------
  73AB    21 6B28                       LD HL,RAMT+1    ; erstes Zeichen
  73AE    7E                    SU84:   LD A,(HL)               ; uebertrageb bis B=0
  73AF    12                            LD (DE),A
  73B0    23                            INC HL
  73B1    13                            INC DE
  73B2    10 FA                         DJNZ SU84
                                        ;-----------------      
                                        ; BF10 IN NEU GEFUNDENE BLASE ]BERNEHMEN
                                        ; RUSER, RTYPE1+1, RTYPE2
                                        ;
  73B4    3A 8035                       LD A,(BF10+RUSER)
  73B7    32 6001                       LD (RAM+RUSER),A        ; Aktueller USER uebernehmen
  73BA    3A 8037                       LD A,(BF10+RTYPE2)
  73BD    FE 00                         CP 0
  73BF    28 0B                         JR Z,SU86
  73C1    3A 800A                       LD A,(BF00+RTYPE1)      ; uebernehmen 
  73C4    32 6002                       LD (RAM+RTYPE1),A       ; uebernehmen 
  73C7    3A 8037                       LD A,(BF10+RTYPE2)      ; uebernehmen 
                                        ;LD (RAM+RTYPE2),A      ; uebernehmen 
  73CA    18 0D                         JR SU87 
  73CC    3A 8036               SU86:   LD A,(BF10+RTYPE1)      ; uebernehmen 
  73CF    3C                            INC A
  73D0    32 6002                       LD (RAM+RTYPE1),A       ; uebernehmen 
  73D3    3A 8037                       LD A,(BF10+RTYPE2)      ; uebernehmen 
        MACRO-80 3.43   27-Jul-81       PAGE    1-16


  73D6    32 6003                       LD (RAM+RTYPE2),A       ; uebernehmen 
                                        ;------------------
  73D9    E1                    SU87:   POP HL
  73DA    D1                            POP DE
  73DB    C1                            POP BC
  73DC    C3 70AF                       JP BL00
                                        ; ENDE neue Blase anspringen
                                        ;--------------------------
                                        ; weiter vergleichen
                                
  73DF    23                    SU80:   INC HL          ; zu TYPE1 in RAMV
  73E0    23                            INC HL          ; ZU TYPE2 IN RAMV
  73E1    3A 8037                       LD A,(BF10+RTYPE2)
                                        ;CP (HL)
  73E4    B6                            OR (HL)
  73E5    CA 7466                       JP Z,SU90
  73E8    23                            INC HL          ; Gedaechtnisz. TERM 
  73E9    3A 8038                       LD A,(BF10+RTERM)       ; 
  73EC    BE                            CP (HL)
  73ED    CA 7423                       JP Z,SU62               ; nicht =1
  73F0    23                            INC HL          ; Status Byte
  73F1    23                            INC HL          ; ZEICHENAUSWERTUNG
  73F2    13                            INC DE          ; ERSTES SUCHZEICHEN IN RAMT
  73F3    1A                            LD  A,(DE)              ; 1. ZEICHEN MUSS '/' SEIN
  73F4    FE 2F                         CP '/'
  73F6    28 07                         JR Z,SU25
  73F8    AF                            XOR A
  73F9    32 8037                       LD (BF10+RTYPE2),A      ; '/' fehlt dann TYPE2=0 und TYPE1 SUCHEN
  73FC    C3 7423                       JP SU62         ; WEITER NACH TYPE1+TYPE2=0 SUCHEN->
                                        ;------------
  73FF    3A 6002               SU25:   LD A,(RAM+RTYPE1)
  7402    47                            LD B,A
  7403    3A 6529                       LD A,(RAMV+RTYPE1)
  7406    B8                            CP B
  7407    C2 7423                       JP NZ,SU62
  740A    3A 652A                       LD A,(RAMV+RTYPE2)
  740D    FE 01                         CP 1H
  740F    DA 7423                       JP C,SU62
  7412    C2 7423                       JP NZ,SU62
  7415    3A 6B27                       LD A,(RAMT)     ; neuer Text mit
  7418    06 3F                         LD B,03FH               ; laenge (255D) eine Zeile zum vergleichen
  741A    CD 78ED               SU21:   CALL SUCH0
  741D    DA 7423                       JP C,SU62
                                        ;CALL MAS00
  7420    C3 74CF                       JP SU23
                                        ; Error anzeigen ??
                                        ; Bereich Ende xxxxxxxx1, xxxxxxx2, .... ????
                                        ; noch einbauen
                                        ;
  7423    CD 79B7               SU62:   CALL KEYST      ; CONSOLE AUF ZEICHEN ABFRAGE
  7426    FE 1B                         CP 1BH
  7428    CA 74AD                       JP Z,SU52       ; ABBRUCH MIT ESC
  742B    ED 5B 6508                    LD DE,(BFVLL)   ; Aktuelle Track/Sectoradresse laden
  742F    D5                            PUSH DE
  7430    2A 650A                       LD HL,(BFVHL)
  7433    E5                            PUSH HL
        MACRO-80 3.43   27-Jul-81       PAGE    1-17


  7434    CD 79CB                       CALL LBA0               ; Suchadresse +1
  7437    E1                            POP HL
  7438    22 650A                       LD (BFVHL),HL   
  743B    D1                            POP DE
  743C    ED 53 6508                    LD (BFVLL),DE           ; Suchadresse speichern
  7440    38 6B                         JR C,SU52       ; CARRY -> ENDE
  7442    18 11                         JR SU63
                                        ;--------------
  7444    ED 4B 8032                    LD BC,(BF07+2)          ; HL
  7448    ED 42                         SBC HL,BC
  744A    38 09                         JR C,SU63
  744C    EB                            EX DE,HL
  744D    ED 4B 8030                    LD BC,(BF07)            ; LL
  7451    ED 42                         SBC HL,BC               
  7453    30 58                         JR NC,SU52              ; LETZTE SUCHADRESSE AUS TAS00 
  7455    7B                    SU63:   LD A,E
  7456    E6 1F                         AND 1FH
  7458    FE 10                         CP 10H
  745A    C2 72F0                       JP NZ,SU01
  745D    CD 77CB                       CALL CUT
  7460    CD 77AB                       CALL SANDU
  7463    C3 72F0                       JP SU01
                                        ;--------------------------
                                        ; weiter vergleichen
                                        ; fuer naechste neue Blase vorbereiten 
                                        ; und in neuer Blase uebernehmen
  7466    2B                    SU90:   DEC HL          ; ZURUECK ZU TYPE1
  7467    3A 8036                       LD A,(BF10+RTYPE1)      ; Type1 
  746A    BE                            CP (HL)
  746B    30 09                         JR NC,SU99
  746D    3C                            INC A
  746E    28 06                         JR Z,SU99               ; groesser 0FFH
  7470    BE                            CP (HL)
  7471    20 03                         JR NZ,SU99              ; Abstand groesser 1
  7473    32 8036                       LD (BF10+RTYPE1),A      ; Type1 wenn groesser uebernehmen
  7476    23                    SU99:   INC HL          ; Type2 in Blase
                                ;--------------------------
                                ;       hier auf erste Type2 =0 selektiert aus Blase
                                ;
  7477    3A 8037                       LD A,(BF10+RTYPE2)      ; Type2 aus RAMV Blase
  747A    BE                            CP (HL)
  747B    C2 7423                       JP NZ,SU62              ; NEUE RAMV BLASE nicht =0 
                                ;--------------------------
                                ; wenn Gedaechtnisszaehler =0 dann ungueltig
                                ; frei fuer neue Blase
  747E    23                            INC     HL              ; Gedaechtnisz. TERM 
  747F    3A 8038                       LD      A,(BF10+RTERM)  ; Gedaechtnisz. aus Blase
  7482    BE                            CP      (HL)
  7483    CA 7423                       JP      Z,SU62          ; nicht =1 ->
  7486    23                            INC     HL              ; Status Byte
  7487    23                            INC     HL              ; ZeichenGROESSE
  7488    1A                            LD      A,(DE)          ; neuer Text mit
  7489    47                            LD      B,A
  748A    13                            INC     DE              ; ERSTES ZEICHEN
                                        ;--------------------
                                        ; ERSTES ZEICHEN GROSS
        MACRO-80 3.43   27-Jul-81       PAGE    1-18


  748B    1A                            LD      A,(DE)
  748C    FE 5B                         CP      5BH
  748E    D2 74AD                       JP      NC,SU52         ; ERSTES ZEICHEN MUSS GROSS BUCHST.SEIN
                                        ;--------------------
  7491    78                            LD      A,B
  7492    06 3F                         LD      B,3FH           ; laenge (46D) eine Zeile zum vergleichen
  7494    CD 78ED                       CALL    SUCH0
  7497    DA 7423                       JP      C,SU62
  749A    3A 6529                       LD      A,(RAMV+RTYPE1) ; WENN BLASE GEFUNDEN TYPE1 UEBERNEHMEN
  749D    32 8036                       LD      (BF10+RTYPE1),A ; Type1 =0 wenn BLASE GEFUNDEN
  74A0    3A 8037                       LD      A,(BF10+RTYPE2) ; BLASE TYPE1 GEFUNDEN
  74A3    3C                            INC     A               ;SET    0,A >0 SETZEN F]R TYPE2 SUCHEN
  74A4    32 8037                       LD      (BF10+RTYPE2),A
  74A7    C3 74CF                       JP      SU23
                                ;-----------------------
                                ; Kein Eintrag in TYPE2>0 gefunden
                                ;       
  74AA    C3 70AF               SU95:   JP BL00
                                ;----------------
                                ;
  74AD    21 824F               SU52:   LD HL,MELD01
  74B0    06 36                         LD B,MELD01X
  74B2    0E 02                         LD C,02H                ; BIOS Console Output
  74B4    CD 7FFC                       CALL BIOS
  74B7    11 0000                       LD DE,0000H
  74BA    06 08                         LD B,08H
  74BC    3E 00                         LD A,00H
  74BE    32 6B27                       LD (RAMT),A
  74C1    15                    SU520:  DEC D
  74C2    20 FD                         JR NZ,SU520
  74C4    1D                            DEC E
  74C5    20 FA                         JR NZ,SU520
  74C7    10 F8                         DJNZ SU520
  74C9    E1                            POP HL
  74CA    D1                            POP DE
  74CB    C1                            POP BC
  74CC    C3 70AF                       JP BL00
                                        ;----------------
                                        ; AKTUELLE MIT GEFUNDENE BLASE TAUSCHEN
                                        ; DANN NEUE BLASE ANZEIGEN      
  74CF    06 04                 SU23:   LD B,04H
  74D1    11 6500                       LD DE,BFRLL
  74D4    21 6508                       LD HL,BFVLL
  74D7    7E                    SU32:   LD A,(HL)
  74D8    12                            LD (DE),A
  74D9    23                            INC HL
  74DA    13                            INC DE 
  74DB    10 FA                         DJNZ SU32
                                        ; EINGABEZEILE LOESCHEN
  74DD    01 2401                       LD BC,2401H
  74E0    CD 7018                       CALL T8
  74E3    06 46                         LD B,70D
  74E5    3E 20                 SU33:   LD A,20H
  74E7    CD 7802                       CALL HEXC
  74EA    10 F9                         DJNZ SU33
  74EC    E1                            POP HL
        MACRO-80 3.43   27-Jul-81       PAGE    1-19


  74ED    D1                            POP DE
  74EE    C1                            POP BC
  74EF    C3 7074                       JP BL
                                ;------------------------
                                ;       Starte Eingabemode
                                ;
  74F2    C5                    EING:   PUSH BC
  74F3    D5                            PUSH DE
  74F4    E5                            PUSH HL
                                        ;------------------------
                                        ; pruefe auf Anfangsadresse BLASE = RAM
                                        ;       
  74F5    2A 6524                       LD HL,(RADR)    ; zuletzten Blasenabschnitt Adr.0
  74F8    3E 00                         LD A,00H
  74FA    32 6B27                       LD (RAMT),A     ; ZEICHEN EINGABEZAEHLER AUF 0 SETZEN
  74FD    BE                            CP (HL)
  74FE    20 18                         JR NZ,ED00
  7500    AF                            XOR A
  7501    11 6000                       LD DE,RAM
  7504    ED 52                         SBC HL,DE
  7506    20 34                         JR NZ,ED10              ; -> ADRESSE NICHT GLEICH
                                        ;--------------------
                                        ; (RADR) = RAM und kein Zechen 
                                        ; dann Blase mit 00H ueberschreiben 2*256lang
                                        ;
  7508    06 00                         LD B,00H
  750A    3E 00                 ED01:   LD A,00H                ; RAM 256 auf null setzen
  750C    77                            LD (HL),A
  750D    23                            INC HL
  750E    10 FA                         DJNZ ED01
  7510    06 00                         LD B,00H
  7512    3E 00                 ED02:   LD A,00H                ; RAM 256 auf null setzen
  7514    77                            LD (HL),A
  7515    23                            INC HL
  7516    10 FA                         DJNZ ED02
                                        ;---------------------
                                        ; Blasenanfang bestimmen
                                        ;
  7518    2A 6524               ED00:   LD HL,(RADR)
                                ;       LD B,(HL)
  751B    06 F0                         LD B,0F0H               ; Max Zeicheneingabe
  751D    AF                            XOR A
  751E    11 6000                       LD DE,RAM
  7521    ED 52                         SBC HL,DE
  7523    2A 6524                       LD HL,(RADR)
  7526    20 14                         JR NZ,ED10              ; -> kein Blasenanfang
  7528    23                            INC HL
  7529    3A 6201                       LD A,(USER)     ; in Blase uebernemen
  752C    77                            LD (HL),A
  752D    23                            INC HL
  752E    3A 6202                       LD A,(TYPE1)
  7531    77                            LD (HL),A
  7532    23                            INC HL
  7533    3A 6203                       LD A,(TYPE2)
  7536    77                            LD (HL),A
  7537    23                            INC HL          ; Gedaechtniss Zaehler
        MACRO-80 3.43   27-Jul-81       PAGE    1-20


  7538    3E 7F                         LD A,07FH               ; auf 50% setzen
  753A    77                            LD (HL),A
  753B    23                            INC HL          ; Status Byte
                                        ;------------------------
                                        ;  Grafik/Text ausgeben
                                        ;
  753C    C5                    ED10:   PUSH BC
  753D    01 0301                       LD BC,0301H
  7540    CD 7018                       CALL T8
  7543    2A 6524                       LD HL,(RADR)
  7546    3A 6B27                       LD A,(RAMT)
  7549    3C                            INC A
  754A    47                            LD B,A
  754B    AF                            XOR A           ; RES CARRY FLAG
  754C    11 6000                       LD DE,RAM
  754F    ED 52                         SBC HL,DE       ; Blasen Anfang pruefen
  7551    2A 6524                       LD HL,(RADR)
  7554    20 0E                         JR NZ,ED100
  7556    3E 05                         LD A,05H
  7558    85                            ADD A,L         ; Versatz an Blasenanfang
  7559    6F                            LD L,A          ; USER, TYPE1, TYPE2, GE, GS, 
  755A    3E 00                         LD A,00H
  755C    32 651C                       LD (CURT),A
  755F    3E 01                         LD A,01H
  7561    32 651D                       LD (CURT+1),A
  7564    CD 77CB               ED100:  CALL CUT
  7567    23                    ED11:   INC HL          ; erstes Zeichen
  7568    10 03                         DJNZ ED03
  756A    C1                            POP BC
  756B    18 0C                         JR ED12
                                        ;----------------
                                        ; Zeichen ausgeben
                                        ;
  756D    C5                    ED03:   PUSH BC
  756E    E5                            PUSH HL
  756F    5E                            LD E,(HL)
  7570    0E 02                         LD C,02H
  7572    CD 0005                       CALL 0005H
  7575    E1                            POP HL
  7576    C1                            POP BC
  7577    18 EE                         JR ED11
                                        ;---------------------
                                        ; Tasteneingabe
                                        ;       
  7579    C5                    ED12:   PUSH BC
  757A    E5                            PUSH HL
  757B    CD 79B7               _ED12:  CALL KEYST
  757E    FE 00                         CP 0H
  7580    28 F9                         JR Z,_ED12      ; -> KEIN ZEICHEN
  7582    5F                            LD E,A          ; neues Zeichen
  7583    E1                            POP HL
  7584    C1                            POP BC
  7585    FE 20                         CP 20H
  7587    38 2E                         JR C,ED30       ; wenn Zeichen < 20H
  7589    FE 23                         CP 23H          ; # Zeichen fuer Eingabenende
  758B    CA 75B1                       JP Z,ED20
        MACRO-80 3.43   27-Jul-81       PAGE    1-21


  758E    CD 7638                       CALL ED50
                                        ;-------------------
                                        ; Rechts Parameter anzeichen
                                        ;
  7591    7E                    ED13:   LD A,(HL)       ; letztes Zeichen zurueckladen
  7592    5F                            LD E,A          ; und Anzeigen aus Reg. E
  7593    C5                            PUSH BC
  7594    01 0578                       LD BC,0578H
                                        ;CALL T8
  7597    4E                            LD C,(HL)
  7598    C5                            PUSH BC         ; IX HOLEN
  7599    CD 778E                       CALL HEX14
  759C    C1                            POP BC
  759D    01 0473                       LD BC,0473H
  75A0    CD 7018                       CALL T8
  75A3    C1                            POP BC
  75A4    C5                            PUSH BC
  75A5    3A 6B27                       LD A,(RAMT)
  75A8    4F                            LD C,A
  75A9    C5                            PUSH BC         ; IX HOLEN
  75AA    CD 778E                       CALL HEX00
  75AD    C1                            POP BC
  75AE    C1                            POP BC
  75AF    10 03                 ED14:   DJNZ ED15               ; ED12
  75B1    C3 764F               ED20:   JP EING11
  75B4    C3 753C               ED15:   JP ED10
                                ;-------------------------
                                ; Steuerzeichen Auswerten
                                
  75B7    FE 0D                 ED30:   CP 0DH          ; CR
  75B9    28 2B                         JR Z,ED40
  75BB    FE 08                         CP 08H          ; Backspase
  75BD    28 32                         JR Z,ED41
  75BF    FE 09                         CP 09H
  75C1    28 3D                         JR Z,ED42               ; TAB
  75C3    FE 1B                         CP 1BH          ; ESC
  75C5    28 3E                         JR Z,ED43
  75C7    FE 08                         CP 08H          ; ESC
  75C9    28 3F                         JR Z,ED44               ; BackSpace
  75CB    C5                            PUSH BC
  75CC    E5                            PUSH HL
  75CD    06 80                         LD B,80H
  75CF    10 FE                 ED31:   DJNZ ED31
  75D1    CD 79B7                       CALL KEYST      ; CONSOLE AUF ZEICHEN ABFRAGE
  75D4    FE 00                         CP 0
  75D6    28 0A                         JR Z,ED32
  75D8    C5                            PUSH BC
  75D9    4F                            LD C,A
  75DA    C5                            PUSH BC
  75DB    CD 778E                       CALL HEX14
  75DE    C1                            POP BC
  75DF    C1                            POP BC
  75E0    18 EB                         JR ED31-2
                                        ;-----------
  75E2    E1                    ED32:   POP HL
  75E3    C1                            POP BC
        MACRO-80 3.43   27-Jul-81       PAGE    1-22


  75E4    18 AB                 ED33:   JR ED13
                                ;--------------------------
                                ;
  75E6    CD 7638               ED40:   CALL ED50
  75E9    23                            INC HL
  75EA    3E 0A                         LD A,0AH
  75EC    CD 7638                       CALL ED50
                                ;       INC HL
  75EF    18 F3                         JR ED33
                                        ;-------------
  75F1    3E 20                 ED41:   LD A,20H                ; Zeichen loeschen
  75F3    77                            LD (HL),A
  75F4    3A 6B27                       LD A,(RAMT)
  75F7    D6 01                         SUB 01H
  75F9    38 E9                         JR C,ED33
  75FB    32 6B27                       LD (RAMT),A
  75FE    18 E4                         JR ED33
                                        ;-----------
  7600    CD 7638               ED42:   CALL ED50
                                ;       INC HL
  7603    18 DF                         JR ED33
                                        ;------------
  7605    CD 7638               ED43:   CALL ED50
                                ;       INC HL
  7608    18 DA                         JR ED33
                                        ;-----------
  760A    E5                    ED44:   PUSH HL
  760B    C5                            PUSH BC
  760C    3A 6524                       LD A,(RADR)
  760F    FE 00                         CP 00H
  7611    28 21                         JR Z,ED442
  7613    3A 6B27                       LD A,(RAMT)
  7616    FE 00                         CP 00H
  7618    28 1A                         JR Z,ED442
  761A    01 0002                       LD BC,0002H
  761D    7E                    ED441:  LD A,(HL)
  761E    2B                            DEC HL
  761F    77                            LD (HL),A
  7620    23                            INC HL
  7621    23                            INC HL
  7622    10 F9                         DJNZ ED441
  7624    0D                            DEC C
  7625    20 F6                         JR NZ,ED441
  7627    2A 6524                       LD HL,(RADR)
  762A    35                            DEC (HL)
  762B    2A 6B27                       LD HL,(RAMT)
  762E    35                            DEC (HL)
  762F    C1                            POP BC
  7630    E1                            POP HL
  7631    2B                            DEC HL
  7632    18 B0                         JR ED33
                                        ;-----------
  7634    C1                    ED442:  POP BC
  7635    E1                            POP HL
  7636    18 AC                         JR ED33
                                ;--------------------------
        MACRO-80 3.43   27-Jul-81       PAGE    1-23


                                ; Zeichenzaehler vergleichen
                                ; RAM-Aktuell mit RAM-Text
  7638    77                    ED50:   LD (HL),A
  7639    3A 6B27                       LD A,(RAMT)
  763C    3C                            INC A
  763D    32 6B27                       LD (RAMT),A
  7640    C9                            RET
                                        ;--------
  7641    4F                            LD C,A
  7642    E5                            PUSH HL
  7643    2A 6524                       LD HL,(RADR)
  7646    7E                            LD A,(HL)
  7647    B9                            CP C
  7648    D2 764D                       JP NC,ED51              ; RAMT > RADR dann RADR+1
  764B    3C                            INC A
  764C    77                            LD (HL),A
  764D    E1                    ED51:   POP HL
  764E    C9                            RET
                                        ;-----------------------
                                        ; KEY Stepps Eingabe in HEX
                                        ; 
  764F    E5                    EING11: PUSH HL
  7650    2A 6524                       LD HL,(RADR)
  7653    3A 6B27                       LD A,(RAMT)
  7656    77                            LD (HL),A
  7657    21 8232                       LD HL,KEYZ
  765A    06 1D                         LD B,KEYZX
  765C    0E 02                         LD C,02H                ; BIOS Console Output
  765E    CD 7FFC                       CALL BIOS
                                        ;------------------------
  7661    E1                            POP HL
  7662    C5                            PUSH BC
  7663    4E                            LD C,(HL)               ; Speicher Lesen 
  7664    C5                            PUSH BC
  7665    CD 778E                       CALL HEX00
  7668    C1                            POP BC
  7669    C1                            POP BC
  766A    E5                            PUSH HL
  766B    CD 7AD6                       CALL TAS
  766E    5F                            LD E,A
  766F    CD 772C                       CALL HEXI1
  7672    D5                            PUSH DE
  7673    CD 7AD6                       CALL TAS
  7676    D1                            POP DE
  7677    5F                            LD E,A
  7678    CD 773F                       CALL HEXI2
  767B    E1                            POP HL
                                ;       LD D,10H
  767C    72                            LD (HL),D
  767D    23                            INC HL
                                        ;-----------------
                                        ; Dateiaufruf
                                        ; Text ausgeben
                                        ;
  767E    E5                    EING21: PUSH HL
  767F    21 8285                       LD HL,PROZ
        MACRO-80 3.43   27-Jul-81       PAGE    1-24


  7682    06 25                         LD B,PROZX
  7684    0E 02                         LD C,02H                ; BIOS Console Output
  7686    CD 7FFC                       CALL BIOS
                                        ;------------------------
  7689    06 0C                         LD      B,0CH           ; Dateinamenlaenge
  768B    0E 00                         LD      C,00H           ; loeschen
  768D    E1                            POP     HL
  768E    C5                    EING22: PUSH    BC
  768F    D5                            PUSH    DE
  7690    5E                            LD      E,(HL)          ; Speicher Lesen 
  7691    E5                            PUSH    HL
  7692    D5                            PUSH    DE
  7693    C5                            PUSH BC
  7694    4B                            LD C,E
  7695    C5                            PUSH BC
  7696    CD 778E                       CALL    HEX00           ; HEX Anzeigen
  7699    C1                            POP BC
  769A    C1                            POP BC
  769B    CD 7AD6                       CALL    TAS     ; ZEICHEN EINGABE
  769E    D1                            POP     DE
  769F    E1                            POP     HL
  76A0    77                            LD      (HL),A          ; Tasteneingabee retten
  76A1    D1                            POP     DE
  76A2    C1                            POP     BC
  76A3    FE 2E                         CP      2EH             ; Dateineman Ende
  76A5    20 02                         JR      NZ,EING23       ; -> noch nicht
  76A7    06 04                         LD      B,04H           ; Zaehler aus Erweiterung set
  76A9    3E 0C                 EING23: LD      A,0CH           ; Dateinamenlaenge
  76AB    B8                            CP      B
  76AC    20 1A                         JR      NZ,EING25       ; -> kein Anfang mehr
  76AE    7E                            LD      A,(HL)          ; Tastein ASCII -> 0-9 unr.
  76AF    D6 30                         SUB     30H
  76B1    38 2E                         JR      C,EING26
  76B3    FE 0A                         CP      0AH
  76B5    38 02                         JR      C,EING24
  76B7    D6 07                         SUB     07H
  76B9    E6 0F                 EING24: AND     0FH
  76BB    4F                            LD      C,A
  76BC    77                            LD      (HL),A          ; Speichern
  76BD    FE 00                         CP      00H
  76BF    28 20                         JR      Z,EING26        ; Ende -> Ausgang
  76C1    E5                            PUSH    HL
  76C2    D1                            POP     DE              ; HL -> DE
  76C3    13                            INC     DE
  76C4    3E FF                         LD      A,0FFH
  76C6    12                            LD      (DE),A
  76C7    23                            INC     HL
  76C8    23                    EING25: INC     HL
  76C9    1A                            LD      A,(DE)
  76CA    3C                            INC     A
  76CB    12                            LD      (DE),A          ; Dateiname Zeichezaehler +1
  76CC    10 C0                         DJNZ    EING22
  76CE    47                            LD      B,A             ; naechste Dateiadresse berechnen
  76CF    3E 0C                         LD      A,0CH
  76D1    90                            SUB     B
  76D2    16 00                         LD      D,00H
        MACRO-80 3.43   27-Jul-81       PAGE    1-25


  76D4    5F                            LD      E,A
  76D5    19                            ADD     HL,DE
  76D6    E5                            PUSH    HL
  76D7    D1                            POP     DE
  76D8    3E 00                         LD      A,00H
  76DA    12                            LD      (DE),A
  76DB    23                            INC     HL
  76DC    06 0B                         LD      B,0BH
  76DE    0D                            DEC     C
  76DF    20 AD                         JR      NZ,EING22
  76E1    06 0F                 EING26: LD      B,0FH
  76E3    AF                    EING27: XOR     A
  76E4    77                            LD      (HL),A
  76E5    23                            INC     HL
  76E6    10 FB                         DJNZ    EING27
  76E8    C3 70AF                       JP BL00         ; PUSH POP ???
  76EB    E1                    EING30: POP HL
  76EC    D1                            POP DE
  76ED    C1                            POP BC
  76EE    C3 70AF                       JP BL00
                                ;-------------------------
                                ; TYPE2 MASKE AUFBAUEN
                                
  76F1    3A 6000               MAS00:  LD A,(RAM)
  76F4    47                            LD B,A          ; ZEICHENL$NGE ZUM ANHAENGEN
                                        ; CURSOR AUF XXXXZEILE 1 SETZEN
  76F5    3E 00                         LD A,00H
  76F7    32 651C                       LD (CURT),A
  76FA    3E 01                         LD A,01H
  76FC    32 651D                       LD (CURT+1),A
                                        ;------------------
                                        ; CURSOR RECHTR SCHIEBEN
                                
  76FF    3E 00                         LD A,00H
  7701    3C                    MAS01:  INC A
  7702    27                            DAA
  7703    10 FC                         DJNZ MAS01
  7705    47                            LD B,A
  7706    E6 0F                         AND 0FH
  7708    32 651F                       LD (CURT+3),A
  770B    78                            LD A,B
  770C    0F                            RRCA
  770D    0F                            RRCA
  770E    0F                            RRCA
  770F    0F                            RRCA
  7710    E6 0F                         AND 0FH
  7712    32 651E                       LD (CURT+2),A
  7715    CD 77CB                       CALL CUT
  7718    11 6B27                       LD DE,RAMT
  771B    1A                            LD A,(DE)
  771C    47                            LD B,A
  771D    13                    MAS02:  INC DE
  771E    1A                            LD A,(DE)
  771F    CD 7802                       CALL HEXC
  7722    10 F9                         DJNZ MAS02
  7724    C9                            RET     
        MACRO-80 3.43   27-Jul-81       PAGE    1-26


  7725    C3 74AD                       JP SU52
                                ;-------------------------
                                ; Programmaufruf mit Cursor up/down
                                
  7728    00                    ZEI00:  NOP
  7729    C3 71E3                       JP      BL132
                                
                                ;-------------------------
                                ;   Hexunwandlung
                                
  772C    7B                    HEXI1:  LD A,E          ; Eingabe Umwandeln
  772D    D6 30                         SUB 30H
  772F    38 1D                         JR C,HEXIE
  7731    FE 0A                         CP 0AH
  7733    38 02                         JR C,HEX11
  7735    D6 07                         SUB 07H
  7737    07                    HEX11:  RLCA
  7738    07                            RLCA
  7739    07                            RLCA
  773A    07                            RLCA
  773B    E6 F0                         AND 0F0H
  773D    57                            LD D,A
  773E    C9                            RET
                                        ;-----------
  773F    7B                    HEXI2:  LD A,E          ; Adresse anzeigen
  7740    D6 30                         SUB 30H
  7742    38 0A                         JR C,HEXIE
  7744    FE 0A                         CP 0AH
  7746    38 02                         JR C,HEX12
  7748    D6 07                         SUB 07H
  774A    E6 0F                 HEX12:  AND 0FH
                                        ;ADD A,D        ; ??
                                        ;LD D,A ; ??
  774C    5F                            LD E,A
  774D    C9                            RET
                                        ;--------
  774E    06 01                 HEXIE:  LD B,01H
  7750    C9                            RET
                                ;-------------------------
                                ;  HEX Ausgabe mit Position
                                ;
  7751    3A 651C               HEXP:   LD A,(CURT)
  7754    F5                            PUSH AF
  7755    3A 651D                       LD A,(CURT+1)
  7758    F5                            PUSH AF
  7759    3A 651E                       LD A,(CURT+2)
  775C    F5                            PUSH AF
  775D    3A 651F                       LD A,(CURT+3)
  7760    F5                            PUSH AF
  7761    C5                            PUSH BC
  7762    01 0150                       LD BC,0150H
  7765    CD 7018                       CALL T8
  7768    4B                            LD C,E
  7769    C5                            PUSH BC
  776A    CD 778E                       CALL HEX00
  776D    C1                            POP BC
        MACRO-80 3.43   27-Jul-81       PAGE    1-27


  776E    C1                            POP BC
  776F    F1                            POP AF
  7770    32 651F                       LD (CURT+3),A
  7773    F1                            POP AF
  7774    32 651E                       LD (CURT+2),A
  7777    F1                            POP AF
  7778    32 651D                       LD (CURT+1),A
  777B    F1                            POP AF
  777C    32 651C                       LD (CURT),A
  777F    CD 77CB                       CALL CUT
  7782    C9                            RET
                                ;-------------------------
                                ;  Hex ausgeben
  7783    3E 0A                 HEXA:   LD A,0AH
  7785    CD 7802                       CALL HEXC
  7788    3E 0D                         LD A,0DH
  778A    CD 7802                       CALL HEXC
  778D    C9                            RET
                                ;------------------
  778E                          HEX00:  
  778E    DD E5                 HEX14:  PUSH IX
  7790    DD 21 0000                    LD IX,0
  7794    DD 39                         ADD IX,SP
                                ;---------
  7796    DD 4E 04                      LD C,(IX+4)             ; Adresse anzeigen
  7799    C5                            PUSH BC
  779A    CD 7EDB                       CALL ASCII_CODE
  779D    C1                            POP BC
  779E    78                            LD A,B
  779F    CD 7802                       CALL HEXC
  77A2    79                            LD A,C          ; ADRESSE ANZEIGEN
  77A3    CD 7802                       CALL HEXC
                                ;-----------
  77A6    DD F9                         LD SP,IX
  77A8    DD E1                         POP IX
  77AA    C9                            RET
                                ;------------------------
                                ; Warte schlange
                                
  77AB    C5                    SANDU:  PUSH BC
  77AC    D5                            PUSH DE
  77AD    E5                            PUSH HL
  77AE    3A 6520                       LD A,(SANDB)
  77B1    FE 2F                         CP 2FH  
  77B3    38 06                         JR C,SA1
  77B5    28 08                         JR Z,SA2
  77B7    3E 2D                         LD A,2DH
  77B9    18 06                         JR SA3
  77BB    3E 2F                 SA1:    LD A,2FH
  77BD    18 02                         JR SA3
  77BF    3E 5C                 SA2:    LD A,5CH
  77C1    32 6520               SA3:    LD (SANDB),A
  77C4    CD 7802                       CALL HEXC
  77C7    E1                            POP HL
  77C8    D1                            POP DE
  77C9    C1                            POP BC
        MACRO-80 3.43   27-Jul-81       PAGE    1-28


  77CA    C9                            RET
                                ;------------------------
                                ; Cursor auf Position setzen
                                ;
  77CB    F5                    CUT:    PUSH AF
  77CC    3E 1B                         LD A,1BH
  77CE    CD 7802                       CALL HEXC
  77D1    3E 5B                         LD A,5BH
  77D3    CD 7802                       CALL HEXC
  77D6    3A 651C                       LD A,(CURT)
  77D9    C6 30                         ADD A,30H
  77DB    CD 7802                       CALL HEXC
  77DE    3A 651D                       LD A,(CURT+1)
  77E1    C6 30                         ADD A,30H
  77E3    CD 7802                       CALL HEXC
  77E6    3E 3B                         LD A,3BH
  77E8    CD 7802                       CALL HEXC
  77EB    3A 651E                       LD A,(CURT+2)
  77EE    C6 30                         ADD A,30H
  77F0    CD 7802                       CALL HEXC
  77F3    3A 651F                       LD A,(CURT+3)
  77F6    C6 30                         ADD A,30H
  77F8    CD 7802                       CALL HEXC
  77FB    3E 48                         LD A,48H
  77FD    CD 7802                       CALL HEXC
  7800    F1                            POP AF
  7801    C9                            RET
                                ;------------------------
                                ;  Zeichen Ausgeben
                                ;
  7802    C5                    HEXC:   PUSH BC
  7803    D5                            PUSH DE
  7804    E5                            PUSH HL
  7805    5F                            LD E,A
  7806    F5                            PUSH AF
  7807    0E 02                         LD C,02H
  7809    CD 0005                       CALL 0005H
  780C    F1                            POP AF
  780D    E1                            POP HL
  780E    D1                            POP DE
  780F    C1                            POP BC
  7810    C9                            RET
                                        ;--------------
                                        ; Cursor on
  7811    E5                    CON:    PUSH HL
  7812    C5                            PUSH BC
  7813    21 8050                       LD HL,CURON             ; CURSOR ON
  7816    06 06                         LD B,06H
  7818    7E                    CUR02:  LD A,(HL)
  7819    CD 7802                       CALL HEXC
  781C    23                            INC HL
  781D    10 F9                         DJNZ CUR02
  781F    C1                            POP BC
  7820    E1                            POP HL
  7821    C9                            RET
                                        ;--------------
        MACRO-80 3.43   27-Jul-81       PAGE    1-29


                                        ; Cursor off
  7822    E5                    COFF:   PUSH HL
  7823    C5                            PUSH BC
  7824    21 8056                       LD HL,CUROFF            ; CURSOR OFF
  7827    06 06                         LD B,06D
  7829    7E                    CUR01:  LD A,(HL)
  782A    CD 7802                       CALL HEXC
  782D    23                            INC HL
  782E    10 F9                         DJNZ CUR01
  7830    C1                            POP BC
  7831    E1                            POP HL
  7832    C9                            RET
                                ;-----------------------
                                ;  DRIVE ZUGRIFF VORBEREITEN
  7833    DB FF                 WAITRDY:IN A,(IDESTAT)
  7835    CB 77                         BIT 6,A
  7837    28 FA                         JR Z,WAITRDY
  7839    CB 7F                         BIT 7,A
  783B    20 F6                         JR NZ,WAITRDY
  783D    C9                            RET
                                        ;----------
  783E                          WAITDRQ: 
  783E    DB FF                         IN A,(IDESTAT)
  7840    CB 5F                         BIT 3,A
  7842    28 FA                         JR Z,WAITDRQ
  7844    CB 7F                         BIT 7,A
  7846    20 F6                         JR NZ,WAITDRQ
  7848    C9                            RET
                                        ;----------
  7849                          HDD_WAIT:
                                        ;LD B,0
                                        ;DJNZ $
  7849    DB FF                 _WAIT1: IN A,(IDESTAT)
  784B    E6 80                         AND 80H
  784D    20 FA                         JR NZ,_WAIT1
  784F    C9                            RET
                                        ;-------------
  7850                          HDD_INIT:
  7850    3E 02                         LD A,02H
  7852    D3 FF                         OUT (IDECMD),A
  7854    CD 7849                       CALL HDD_WAIT
                                ;-----
  7857    3E F0                         LD A,0F0H
  7859    D3 FE                         OUT (IDESDH),A
  785B    3E 01                         LD A,01H
  785D    D3 FA                         OUT (IDESCNT),A
  785F    3E EF                         LD A,0EFH
  7861    D3 FF                         OUT (IDECMD),A
  7863    CD 7849                       CALL HDD_WAIT
  7866    CD 786A                       CALL HDD_ERROR
  7869    C9                            RET
                                ;---------
  786A                          HDD_ERROR:
  786A    DB FF                         IN A,(IDESTAT)
  786C    4F                            LD C,A
  786D    C5                            PUSH BC
        MACRO-80 3.43   27-Jul-81       PAGE    1-30


  786E    CD 778E                       CALL HEX00
  7871    C1                            POP BC
  7872    79                            LD A,C
  7873    E6 01                         AND 01H
  7875    C8                            RET Z
  7876    21 82AA                       LD HL,DERR
  7879    06 26                         LD B,L_DERR
  787B    7E                    ERR1:   LD A,(HL)
  787C    CD 7802                       CALL HEXC
  787F    23                            INC HL
  7880    10 F9                         DJNZ ERR1
  7882    C9                            RET
                                ;--------------
  7883                          HDD_INFO:
  7883    CD 7849                       CALL HDD_WAIT
  7886    3E EC                         LD A,0ECH
  7888    D3 FF                         OUT (IDECMD),A
  788A    21 1964                       LD HL,6500
  788D    CD 7891                       CALL HDD_READ
  7890    C9                            RET
                                ;-----------
  7891                          HDD_READ:
  7891    CD 7849                       CALL HDD_WAIT
  7894    DB FF                         IN A,(IDESTAT)
  7896    E6 08                         AND 08H
  7898    C8                            RET Z
  7899    DB F8                         IN A,(IDEDAT)
  789B    77                            LD (HL),A
                                ;       CALL HEXC;!!! TESTAUSGABEN
  789C    23                            INC HL
  789D    18 F2                         JR HDD_READ
                                ;-------------
                                ; IDE-FESTPLATTE RESET
  789F                          IDERES:
  789F    CD 78A5                       CALL IDERES1
  78A2    C3 7849                       JP HDD_WAIT
                                        ;----------
  78A5    CD 7FB3               IDERES1:CALL EXTERN
  78A8    F5                            PUSH AF         ; PIOA
  78A9    C5                            PUSH BC
  78AA    3E 06                         LD A,06H
  78AC    D3 F6                         OUT (IDEDOR),A
  78AE    06 00                         LD B,0
  78B0    10 FE                         DJNZ $
  78B2    3E 02                         LD A,02H
  78B4    D3 F6                         OUT (IDEDOR),A
  78B6    C1                            POP BC
  78B7    F1                            POP AF
  78B8    D3 1C                         OUT (PIOA),A
  78BA    C9                            RET 
                                ;-------------
  78BB    DD E5                 DISK:   PUSH IX
  78BD    DD 21 0000                    LD IX,0
  78C1    DD 39                         ADD IX,SP
                                ;--------
  78C3    DD 7E 05                      LD A,(IX+5)     ; D= HEAD SELECT, LBA HIGH MIT HIGH=B
        MACRO-80 3.43   27-Jul-81       PAGE    1-31


  78C6    E6 0F                         AND 0FH         ; HEAD SELECT
  78C8    47                            LD B,A
  78C9    3E F7                         LD A,SELDS      ; IN INCLUDE
  78CB    E6 F0                         AND 0F0H
  78CD    B0                            OR B
  78CE    CB FF                         SET 7,A
  78D0    DD 77 05                      LD (IX+5),A
  78D3    D3 FE                         OUT (IDESDH),A
  78D5    DD 7E 04                      LD A,(IX+4)     ; TRACK HIGH
  78D8    D3 FD                         OUT (IDECHI),A
  78DA    DD 7E 07                      LD A,(IX+7)     ; TRACK LOW
  78DD    D3 FC                         OUT (IDECLO),A
  78DF    DD 7E 06                      LD A,(IX+6)     ; C= SECTOR
  78E2    D3 FB                         OUT (IDESNUM),A
  78E4    3E 01                         LD A,01H
  78E6    D3 FA                         OUT (IDESCNT),A
                                        ;----------
  78E8    DD F9                         LD SP,IX
  78EA    DD E1                         POP IX
  78EC    C9                            RET
                                ;-----------------------
                                ; ZEICHEN SUCHEN IM RAM AUS EINGABE RAMT
                                ;
  78ED    08                    SUCH0:  EX AF,AF'               ; Textlaenge retten
  78EE    1A                            LD A,(DE)               ; neuer Text mit
  78EF    BE                            CP (HL)         ; Blaseninhalt 
  78F0    28 0B                         JR Z,SUCH2
  78F2    23                            INC HL
  78F3    3A 6B27                       LD A,(RAMT)
  78F6    11 6B28                       LD DE,RAMT+1
  78F9    10 F2                         DJNZ SUCH0
  78FB    37                    SUCH1:  SCF
  78FC    C9                            RET
                                        ;------------
  78FD    13                    SUCH2:  INC DE
  78FE    23                            INC HL
  78FF    3E 2A                         LD A,2AH
  7901    CD 7802                       CALL HEXC
  7904    08                            EX AF,AF'
  7905    3D                            DEC A
  7906    20 E5                         JR NZ,SUCH0
  7908    7E                            LD A,(HL)               ; Text Ende <30H
  7909    FE 2F                         CP 2FH          ; ENDE < 21H = !
  790B    30 EE                         JR NC,SUCH1     ; -> kein Ende
  790D    AF                            XOR A
  790E    C9                            RET     
                                ;-------------
  790F    C5                    FREI:   PUSH BC
  7910    0E 0B                         LD C,0BH        ; GET CONSILE STATUS
  7912    CD 0005                       CALL 0005H
  7915    C1                            POP BC
  7916    C9                            RET
                                ;-----------------------
                                ; ZEICHEN IN KEYBUFFER SCHREIBEN
                                ; UND MIT CR ENDE
  7917    FE 0D                 KEYB:   CP 0DH
        MACRO-80 3.43   27-Jul-81       PAGE    1-32


  7919    C8                            RET Z   ;,BL03  ; Ausgang mit CR
  791A    12                            LD (DE),A       ; Zeichen abspeichen
  791B    FE 08                         CP 08H          ; TAB
  791D    20 2F                         JR NZ,BL021     ; NEIN ->
                                        ;-----------------
                                        ; BACKSPACE FUNKTION CURSOR LINKS MIT ZEICHEN LOESCHEN
                                        ;
  791F    7E                            LD A,(HL)       ; Zeichenzaehler
  7920    D6 01                         SUB 01H
  7922    38 19                         JR C,KEYB1
  7924    77                            LD (HL),A       ; Zeichenlaenge -1
  7925    3E 20                         LD A,20H
  7927    CD 7802                       CALL HEXC
  792A    04                            INC B
  792B    1B                            DEC DE          ; Zeichen loeschen
                                        ;----------
                                        ; set cursor 1 left
  792C    3E 1B                         LD A,1BH
  792E    CD 7802                       CALL HEXC
  7931    3E 5B                         LD A,5BH
  7933    CD 7802                       CALL HEXC
  7936    3E 44                         LD A,44H
  7938    CD 7802                       CALL HEXC
  793B    AF                            XOR A
  793C    C9                            RET             ; zurueck ohne B dec
                                        ;----------
                                        ; set cursor 1 right
  793D    3E 1B                 KEYB1:  LD A,1BH
  793F    CD 7802                       CALL HEXC
  7942    3E 5B                         LD A,5BH
  7944    CD 7802                       CALL HEXC
  7947    3E 43                         LD A,43H
  7949    CD 7802                       CALL HEXC
  794C    AF                            XOR A
  794D    C9                            RET             ; zurueck ohne B dec
                                        ;-------------------
                                        ; ESC 
                                        ; 
  794E    FE 1B                 BL021:  CP 1BH          ; ESC
  7950    20 5A                         JR NZ,BL022     ; NEIN ->
  7952    7E                            LD A,(HL)
  7953    FE 00                         CP 0H
  7955    20 55                         JR NZ,BL022
  7957    D5                            PUSH DE
  7958    C5                            PUSH BC
  7959    E5                            PUSH HL
  795A    06 A0                 BL120:  LD B,0A0H
  795C    10 FE                         DJNZ $          ; DELAY
  795E    CD 79B7                       CALL KEYST      ; pruefe ob Zeichen da
  7961    FE 00                         CP 0H
  7963    28 42                         JR Z,BL121      ; -> NO
  7965    5F                            LD E,A
  7966    FE 5B                         CP '['
  7968    28 F0                         JR Z,BL120
  796A    3E 44                         LD A,'D'
  796C    BB                            CP E
        MACRO-80 3.43   27-Jul-81       PAGE    1-33


  796D    38 38                         JR C,BL121
  796F    3E 40                         LD A,'@'
  7971    BB                            CP E
  7972    30 33                         JR NC,BL121
  7974    3E 41                         LD A,'A'
  7976    BB                            CP E
  7977    20 0D                         JR NZ,BL123
  7979    3A 8045                       LD A,(ZEIL)
  797C    3C                            INC A
  797D    FE 07                         CP CURUD
  797F    30 26                         JR NC,BL121
  7981    32 8045                       LD (ZEIL),A
  7984    18 21                         JR BL121
                                ;--------------------------     
  7986    3E 42                 BL123:  LD A,'B'
  7988    BB                            CP E
  7989    20 0D                         JR NZ,BL124
                                        ;JR NZ,BL123
  798B    3A 8045                       LD A,(ZEIL)
  798E    3D                            DEC A
  798F    FE 01                         CP 01H
  7991    38 14                         JR C,BL121
  7993    32 8045                       LD (ZEIL),A
  7996    18 0F                         JR BL121
                                        ;-------------------
  7998    3E 43                 BL124:  LD A,'C'
  799A    BB                            CP E
  799B    20 02                         JR NZ,BL125
                                ; Cursor right
  799D    18 08                         JR BL121
                                        ;-----------
  799F    3E 44                 BL125:  LD A,'D'
  79A1    BB                            CP E
  79A2    20 03                         JR NZ,BL121
                                ; Cursor left
  79A4    18 B4                         JR BL120
  79A6    C9                    BL02X:  RET ;!!JP BL02
                                        ;------------
  79A7    E1                    BL121:  POP HL
  79A8    C1                            POP BC
  79A9    D1                            POP DE
  79AA    AF                            XOR A           ; letzes Zeichen loeschen
  79AB    77                            LD (HL),A       ; Zeichenzaehler loeschen
                                        ;-------------
  79AC    FE 21                 BL022:  CP 21H          ; Zeichen < Space
  79AE    38 02                         JR C,BL023
  79B0    13                            INC DE          ; Zeichenadr. +1
  79B1    34                            INC (HL)        ; Zeichenzaehler erhoehen
  79B2    10 F2                 BL023:  DJNZ BL02X      ; vorgegebene Laenge aus Blase
  79B4    3E 0D                         LD A,0DH        ; LAENGE B ERREICHT ENDE
  79B6    C9                            RET
                                ;-----------------------
                                ; CONSOLE QUERY AND PICK 
                                ; WITHOUT WAITING
                                ; 
  79B7    CD 7E81               KEYST:  CALL UHR00
        MACRO-80 3.43   27-Jul-81       PAGE    1-34


  79BA    C5                            PUSH BC
  79BB    0E 0B                         LD C,0BH        ; GET CONSILE STATUS
  79BD    CD 0005                       CALL 0005H
  79C0    FE 00                         CP 0
  79C2    28 05                         JR Z,KEY01
  79C4    0E 01                         LD C,01H        ; console Input read chr
  79C6    CD 0005                       CALL 0005H
  79C9    C1                    KEY01:  POP BC
  79CA    C9                            RET 
                                ;-----------------------
                                ; LBA Z[HLER HERH\HE BID HDDE ENDE
                                ;
  79CB    DD E5                 LBA0:   PUSH IX
  79CD    DD 21 0000                    LD IX,0
  79D1    DD 39                         ADD IX,SP
                                ;--------
  79D3    DD 4E 06                      LD C,(IX+6)     ; LBA LOW SECTOR
  79D6    DD 46 07                      LD B,(IX+7)
  79D9    0C                            INC C
  79DA    DD 71 06                      LD (IX+6),C
  79DD    20 35                         JR NZ,LBA20
  79DF    04                            INC B
  79E0    DD 70 07                      LD (IX+7),B
  79E3    20 2F                         JR NZ,LBA20
  79E5    DD 4E 04                      LD C,(IX+4)     ; LBA TRACK 
  79E8    DD 46 05                      LD B,(IX+5)
  79EB    03                            INC BC
  79EC    DD 71 04                      LD (IX+4),C     ; LBA TRACK
  79EF    DD 70 05                      LD (IX+5),B
  79F2    AF                            XOR A           ; RES CARRY FLAG
  79F3    21 00BE                       LD HL,HDDE      ; DISK ENDE
  79F6    ED 42                         SBC HL,BC       ; -C
  79F8    30 1A                         JR NC,LBA20     
  79FA    01 0801                       LD BC,HDD+1
  79FD    DD 71 06                      LD (IX+6),C
  7A00    DD 70 07                      LD (IX+7),B
  7A03    01 0000                       LD BC,0
  7A06    DD 71 04                      LD (IX+4),C
  7A09    DD 70 05                      LD (IX+5),B
  7A0C    C3 0000                       JP 0;!!!!
  7A0F    18 03                         JR LBA20
                                        ; ENDE ERREICHT
  7A11    37                    LBA4:   SCF             ;AUSGANG FEHLER
  7A12    18 01                         JR LBA21
                                ;-----------
  7A14    AF                    LBA20:  XOR A           ; SET CARRY -> OHNE FEHLER
  7A15    DD F9                 LBA21:  LD SP,IX
  7A17    DD E1                         POP IX
  7A19    C9                            RET
                                ;-----------------
                                ; ADRESSE -1
  7A1A    C3 0000               LBA5:   JP 0;!!!
  7A1D    DD E5                 PUSH IX
  7A1F    DD 21 0000                    LD IX,0
  7A23    DD 39                         ADD IX,SP
                                ;------
        MACRO-80 3.43   27-Jul-81       PAGE    1-35


  7A25    DD 46 07                      LD B,(IX+7)     ; LBA 
  7A28    DD 4E 06                      LD C,(IX+6)     ; LOW
  7A2B    0B                            DEC BC
  7A2C    78                            LD A,B
  7A2D    E6 F0                         AND 0F0H
  7A2F    28 23                         JR Z,L__6
  7A31    06 0F                         LD B,0FH
  7A33    DD 70 07                      LD (IX+7),B     ; LBA 
  7A36    DD 71 06                      LD (IX+6),C     ; LOW
  7A39    DD 46 05                      LD B,(IX+5)     ; LBA HIGH
  7A3C    DD 4E 04                      LD C,(IX+4)     ; LOW
  7A3F    0B                            DEC BC
  7A40    E5                            PUSH HL
  7A41    AF                            XOR A
  7A42    21 0800                       LD HL,HDD
  7A45    ED 42                         SBC HL,BC
  7A47    E1                            POP HL
  7A48    38 02                         JR C,L__7
  7A4A    18 C5                         JR LBA4
                                        ;-----------
  7A4C    DD 70 05              L__7:   LD (IX+5),B
  7A4F    DD 71 04                      LD (IX+4),C
  7A52    18 C0                         JR LBA20
                                        ;_-------
  7A54    DD 70 07              L__6:   LD (IX+7),B     ; LBA HIGH
  7A57    DD 71 06                      LD (IX+6),C     ; LOW
  7A5A    18 B8                         JR LBA20
                                
  7A5C    DD 46 05                      LD B,(IX+5)     ; LBA HIGH
  7A5F    DD 4E 04                      LD C,(IX+4)     ; LOW
  7A62    0B                            DEC BC
  7A63    DD 70 05                      LD (IX+5),B
  7A66    DD 71 04                      LD (IX+4),C
  7A69    18 A9                         JR LBA20
                                        ; --------------------
                                        ; aktuelle Blasenadresse
                                ;------------------------
                                ; Cursor auf Position setzen
                                
  7A6B    F5                    RLIST:  PUSH AF
  7A6C    3A 6518                       LD A,(CURS)
  7A6F    32 651C                       LD (CURT),A
  7A72    3A 6519                       LD A,(CURS+1)
  7A75    32 651D                       LD (CURT+1),A
  7A78    3A 651A                       LD A,(CURS+2)
  7A7B    32 651E                       LD (CURT+2),A
  7A7E    3A 651B                       LD A,(CURS+3)
  7A81    32 651F                       LD (CURT+3),A
  7A84    CD 77CB                       CALL CUT
  7A87    F1                            POP AF
  7A88    C9                            RET
                                        ;------------
                                        ; CURSER POS SAVE
  7A89    F5                    WLIST:  PUSH AF
  7A8A    3A 651C                       LD A,(CURT)
  7A8D    32 6518                       LD (CURS),A
        MACRO-80 3.43   27-Jul-81       PAGE    1-36


  7A90    3A 651D                       LD A,(CURT+1)
  7A93    32 6519                       LD (CURS+1),A
  7A96    3A 651E                       LD A,(CURT+2)
  7A99    32 651A                       LD (CURS+2),A
  7A9C    3A 651F                       LD A,(CURT+3)
  7A9F    32 651B                       LD (CURS+3),A
  7AA2    F1                            POP AF
                                        ;------------
  7AA3    F5                    LIST:   PUSH AF
  7AA4    78                            LD A,B
  7AA5    E6 F0                         AND 0F0H
  7AA7    0F                            RRCA
  7AA8    0F                            RRCA
  7AA9    0F                            RRCA
  7AAA    0F                            RRCA
  7AAB    32 651C                       LD (CURT),A
  7AAE    78                            LD A,B
  7AAF    E6 0F                         AND 0FH
  7AB1    32 651D                       LD (CURT+1),a
  7AB4    79                            LD A,C
  7AB5    E6 F0                         AND 0F0H
  7AB7    0F                            RRCA
  7AB8    0F                            RRCA
  7AB9    0F                            RRCA
  7ABA    0F                            RRCA
  7ABB    32 651E                       LD (CURT+2),A
  7ABE    79                            LD A,C
  7ABF    E6 0F                         AND 0FH
  7AC1    32 651F                       LD (CURT+3),A
  7AC4    CD 77CB                       CALL CUT
  7AC7    F1                            POP AF
  7AC8    C9                            RET
                                        ;-------------
                                        ; ZUM TEST (HL)+1  30MAL AUSGEBEN
                                        ;
  7AC9    06 1E                 LIS0:   LD B,30D
  7ACB    7E                    LIS1:   LD A,(HL)
  7ACC    4F                            LD C,A
  7ACD    C5                            PUSH BC
  7ACE    CD 778E                       CALL HEX00
  7AD1    C1                            POP BC
  7AD2    23                            INC HL
  7AD3    10 F6                         DJNZ LIS1
  7AD5    C9                            RET
                                ;---------------------------
                                ;  Kontrollausgabe rechts
                                ;
  7AD6    CD 7822               TAS:    CALL COFF
  7AD9    ED 73 651C                    LD (CURT),SP
  7ADD    C5                            PUSH BC
  7ADE    01 2273                       LD BC,2273H
  7AE1    CD 7018                       CALL T8         ;CURSOR POS
  7AE4    C1                            POP BC
  7AE5    3A 650F                       LD A,(BFSHH)
  7AE8    4F                            LD C,A
  7AE9    C5                            PUSH BC
        MACRO-80 3.43   27-Jul-81       PAGE    1-37


  7AEA    CD 778E                       CALL HEX00      ; ADRESSE DER AKTUEL GELESENEN BLASE
  7AED    C1                            POP BC
  7AEE    3A 650E                       LD A,(BFSHL)
  7AF1    4F                            LD C,A
  7AF2    C5                            PUSH BC
  7AF3    CD 778E                       CALL HEX00
  7AF6    C1                            POP BC
  7AF7    3A 650D                       LD A,(BFSLH)
  7AFA    4F                            LD C,A
  7AFB    C5                            PUSH BC
  7AFC    CD 778E                       CALL HEX00
  7AFF    C1                            POP BC
  7B00    3A 650C                       LD A,(BFSLL)
  7B03    4F                            LD C,A
  7B04    C5                            PUSH BC
  7B05    CD 778E                       CALL HEX00
  7B08    C1                            POP BC
                                        ; --------------------
                                        ; aktuelle Blasenadresse
  7B09    C5                            PUSH BC
  7B0A    01 2173                       LD BC,2173H
  7B0D    CD 7018                       CALL T8         ;CURSOR POS
  7B10    C1                            POP BC
  7B11    3A 8033                       LD A,(BF07+3) ;(BFRHH)
  7B14    4F                            LD C,A
  7B15    C5                            PUSH BC
  7B16    CD 778E                       CALL HEX00
  7B19    C1                            POP BC
  7B1A    3A 8032                       LD A,(BF07+2)  ;(BFRHL)
  7B1D    4F                            LD C,A
  7B1E    C5                            PUSH BC
  7B1F    CD 778E                       CALL HEX00
  7B22    C1                            POP BC
  7B23    3A 8031                       LD A,(BF07+1)  ;(BFRLH)
  7B26    4F                            LD C,A
  7B27    C5                            PUSH BC
  7B28    CD 778E                       CALL HEX00
  7B2B    C1                            POP BC
  7B2C    3A 8030                       LD A,(BF07) ;(BFRLL)
  7B2F    4F                            LD C,A
  7B30    C5                            PUSH BC
  7B31    CD 778E                       CALL HEX00
  7B34    C1                            POP BC
                                        ;---------------------
                                        ; CURSOR IN EINGABEZEILE MIT EINGABE SCHIEBEN
  7B35    3E 02                 TAS00:  LD A,02H
  7B37    32 651C                       LD (CURT),A
  7B3A    3E 04                         LD A,04H
  7B3C    32 651D                       LD (CURT+1),A
  7B3F    3E 01                         LD A,01H
  7B41    32 651E                       LD (CURT+2),A
  7B44    3A 6B27                       LD A,(RAMT)
  7B47    FE 0A                         CP 0AH
  7B49    38 0E                         JR C,RD07       ; < 0AH ->
  7B4B    D6 0A                         SUB 0AH
  7B4D    32 651F                       LD (CURT+3),A
        MACRO-80 3.43   27-Jul-81       PAGE    1-38


  7B50    3A 651E                       LD A,(CURT+2)
  7B53    3C                            INC A
  7B54    32 651E                       LD (CURT+2),A
  7B57    18 03                         JR RD08
  7B59    32 651F               RD07:   LD (CURT+3),A
  7B5C    CD 77CB               RD08:   CALL CUT
  7B5F    06 14                         LD B,20D
  7B61    21 6728                       LD HL,RAMS+RUSER
  7B64    CD 77CB               RD09:   CALL CUT
  7B67    CD 7811                       CALL CON
                                ;-----------------------
                                ; Tastenabfrage und Zeichen einlesen
                                ; Sonst weitere Task ausfueren
                                ;
                                ; LBA ZAEHLER +1
                                ;
  7B6A    ED 5B 650C                    LD DE,(BFSLL)   ; Aktuelle Track/Sectoradresse laden
  7B6E    ED 53 6C43                    LD (COP+4),DE   ; STARTPUNKT NACH SPEICHERN
  7B72    D5                            PUSH DE
  7B73    2A 650E                       LD HL,(BFSHL)
  7B76    22 6C45                       LD (COP+6),HL
  7B79    E5                            PUSH HL
  7B7A    CD 79CB                       CALL LBA0       ; LBA + 1
  7B7D    E1                            POP HL
  7B7E    22 650E                       LD (BFSHL),HL   ; adresse HIGH speichern
  7B81    D1                            POP DE
  7B82    ED 53 650C                    LD (BFSLL),DE   ; adresse LOW speichern
  7B86    DA 0000                       JP C,0 ;NOCH ENDE BEI FEHLER RD91               ; RUECKGABE CARRY 0=FEHLER
                                        ;---------------- 
                                        ; 1. BLASE + 1 = 2.BLASE
  7B89    D5                            PUSH DE         ; IX UEBERGABE
  7B8A    E5                            PUSH HL         ; IX UEBERGEBE
  7B8B    CD 79CB                       CALL LBA0       ; LBA + 1
  7B8E    E1                            POP HL
  7B8F    22 6512                       LD (BFSHL+4),HL ; adresse HIGH speichern
  7B92    D1                            POP DE
  7B93    ED 53 6510                    LD (BFSLL+4),DE ; adresse LOW speichern
  7B97    DA 0000                       JP C,0 ;NOCH ENDE BEI FEHLER RD91               ; RUECKGABE CARRY 0=FEHLER
  7B9A    CD 790F                       CALL FREI       ; TAST INT FREI
                                        ;---------------------
                                        ; Erste Blase laden
  7B9D    ED 4B 650C                    LD BC,(BFSLL)
  7BA1    ED 5B 650E                    LD DE,(BFSHL)
  7BA5    21 6727                       LD HL,RAMS
  7BA8    CD 7DB9                       CALL RDREAD     ; BFSLL BLASE LADEN
  7BAB    CD 790F                       CALL FREI
                                        ; READ SICHTBAR MACHEN
                                        ;LD BC,1001H
                                        ;CALL T8
                                        ;LD HL,RAMS
                                        ;CALL LIS0
                                        ;------
  7BAE    3A 672D                       LD A,(RAMS+RSOTR)
  7BB1    FE 1B                         CP 1BH
  7BB3    28 0E                         JR Z,TAS03
  7BB5    21 82D0                       LD HL,NBLASE
        MACRO-80 3.43   27-Jul-81       PAGE    1-39


  7BB8    11 6727                       LD DE,RAMS
  7BBB    01 00AD                       LD BC,NBLLE
  7BBE    ED B0                         LDIR
                                        ; READ SICHTBAR MACHEN
                                        ;LD BC,1101H
                                        ;CALL T8
                                        ;LD HL,RAMS
                                        ;CALL LIS0
  7BC0    C3 7C99                       JP RD170
                                        ;-------------------
                                        ; Zweite Blase laden
  7BC3    ED 4B 6510            TAS03:  LD BC,(BFSLL+4)
  7BC7    ED 5B 6512                    LD DE,(BFSHL+4)
  7BCB    21 6927                       LD HL,RAMS+200H
  7BCE    CD 7DB9                       CALL RDREAD     ; BFSLL BLASE LADEN
  7BD1    CD 790F                       CALL FREI
                                        ;------
                                        ; READ SICHTBAR MACHEN
                                        ;LD BC,1101H
                                        ;CALL T8
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
                                ;
  7BD4    21 6928                       LD      HL,RAMS+RUSER+200H      ;BLASE2 RAM
  7BD7    11 6728                       LD      DE,RAMS+RUSER           ;BLASE1 RAM
  7BDA    1A                            LD      A,(DE)          ; USER vergleich
  7BDB    BE                            CP      (HL)            ; Blase2 > Blase1 dann
  7BDC    DA 7C4B                       JP      C,RD06          ; zum naechstem >USER 2  neu anfangen
  7BDF    C2 7CAF                       JP      NZ,RD01         ; Blase2 < Blase1 tauschen ->
                                ;----------------------
                                ; Blasen der groesse nach Sortieren
                                ; TYPE1, AUFSTEIGEND
                                ; wenn T1 > T1+1 (DE)-(HL) =NC,dann tauschen
                                ; wenn T1 = T1+1 (DE)-(HL) =Z,dann TYPE2 
                                ; wenn T1 < T1+1 (DE)-(HL) =NZ,dann GEDAECHTNIS
                                ;
  7BE2    21 6929                       LD      HL,RAMS+RTYPE1+200H     ; Blase2
  7BE5    11 6729                       LD      DE,RAMS+RTYPE1          ; Blase1
  7BE8    1A                            LD      A,(DE)                  ; TYPE1 Vergleich
  7BE9    BE                            CP      (HL)                    ; Blase2 > Blase1 dann
  7BEA    DA 7C4B                       JP      C,RD06                  ; zum Gedaechtnis zuruecksetzen 
  7BED    C2 7CAF                       JP      NZ,RD01                 ; tauschen und Speichern 
                                ;       JP RD02 ;!!!!!TEST
                                ;----------------------
                                ; Blasen der groesse nach Sortieren
                                ; TYPE2 AUFSTEIGEND
        MACRO-80 3.43   27-Jul-81       PAGE    1-40


                                ; wenn T2 > T2+1 (DE)-(HL) =NC,dann tauschen
                                ; wenn T2 = T2+1 (DE)-(HL) = Z,dann gedaechtniss-1
                                ; wenn T2 < T2+1 (DE)-(HL) =NZ,dann weiter
                                ;
  7BF0    21 692A               RD25:   LD HL,RAMS+RTYPE2+200H  ; Blase2
  7BF3    11 672A                       LD DE,RAMS+RTYPE2       ; Blase1
  7BF6    1A                            LD A,(DE)
  7BF7    FE 01                         CP 01H                  ; RAM+TYPE2 > 0
  7BF9    20 09                         JR NZ,RD255             ; TYPE2 BEREITS 1=FORNE JA ->
  7BFB    BE                            CP (HL)
                                ;??     CALL C,TASK     ; NOCH AUSARBEITEN
  7BFC    3A 692C                       LD A,(RAMS+RBSTAT+200H)
  7BFF    E6 07                         AND 07H
  7C01    CA 7CAF                       JP Z,RD01               ; BLASE 2 SPEICHERN MIT TAUSCHEN
  7C04    1A                    RD255:  LD A,(DE)
  7C05    BE                            CP (HL)                 ; Blase2 > Blase1 dann
  7C06    38 06                         JR C,RD26
  7C08    CA 7C2E                       JP Z,RD36               ; ZUM GEDAECHTNIS
  7C0B    D2 7CAF                       JP NC,RD01              ; TAUSCHEN
                                        ;----------------------
  7C0E    1A                    RD26:   LD A,(DE)               ; BLASE1 TYPE2 Vergleich
  7C0F    FE 00                         CP 0H
  7C11    C2 7C4B                       JP NZ,RD06              ; zum Gedaechtnisszaehler
                                        ;----------------------
                                        ; GED[CHTNISS BLASE1 TYPE2=0 MIT BLASE2 TYPE2>0 VERGLEICHEN
                                         
  7C14    21 672B                       LD HL,RAMS+RTERM                ; Blase1
  7C17    11 692B                       LD DE,RAMS+RTERM+200H   ; Blase2
  7C1A    1A                            LD A,(DE)                       ; Gedaechtnissz Vergleich
  7C1B    BE                            CP (HL)
  7C1C    38 2D                         JR C,RD06                       ; 1>2 GEDAECHTNISS FALLEND
  7C1E    3C                            INC A
  7C1F    20 01                         JR NZ,RD250
  7C21    1A                            LD A,(DE)
  7C22    77                    RD250:  LD (HL),A
  7C23    ED 4B 650C                    LD BC,(BFSLL)
  7C27    ED 5B 650E                    LD DE,(BFSHL)           ; Suchadresse 2. BLASE speichern
  7C2B    C3 7D1C                       JP RD03
                                        ;----------------------
                                        ; Blasen der groesse nach Sortieren
                                        ; GEDAECHTNIS FALLEND
  7C2E    7E                    RD36:   LD A,(HL)
  7C2F    FE 00                         CP 0
  7C31    20 0D                         JR NZ,RD35
  7C33    3A 672C                       LD A,(RAMS+RBSTAT)
  7C36    E6 78                         AND 78H
  7C38    F6 47                         OR 47H
  7C3A    32 672C                       LD (RAMS+RBSTAT),A
  7C3D    C3 7C0E                       JP RD26 
                                        ;---------------------
  7C40    21 692B               RD35:   LD HL,RAMS+RTERM+200H   ; Blase2
  7C43    11 672B                       LD DE,RAMS+RTERM        ; Blase1
  7C46    1A                            LD A,(DE)               ; Gedaechtnissz Vergleich
  7C47    BE                            CP (HL)
  7C48    DA 7CAF                       JP C,RD01               ; tauschen und Speichern fallend
                                        ;---------------------
        MACRO-80 3.43   27-Jul-81       PAGE    1-41


                                        ; Gedaechtniss zuruecksetzen wenn MONAT ungleich ist
                                
  7C4B    CD 790F               RD06:   CALL FREI
  7C4E    3A 803D                       LD A,(DAYM)             ; MONAT AUS UHR
  7C51    E6 1F                         AND 1FH
  7C53    47                            LD B,A
  7C54    3A 672C                       LD A,(RAMS+RBSTAT)      ; MONAT AUS BLASE1
  7C57    E6 1F                         AND 1FH
  7C59    B8                            CP B
  7C5A    C2 7C67                       JP NZ,RDD1              ; NICHT GLEICH ->
  7C5D    3A 672C                       LD A,(RAMS+RBSTAT)      ; MONAT AUS BLASE1
  7C60    CB 77                         BIT 6,A                 ; PRUEFE SORTIEREN 
  7C62    20 03                         JR NZ,RDD1              ; SPEICHERN ->
  7C64    C3 7D6B                       JP RD02                 ; GLEICH nicht speichern gleicher MONAT
                                        ;------------------
                                        ; NEUER MONAT UND GEDAECHTNIS SPEICHERN
  7C67    3A 672C               RDD1:   LD A,(RAMS+RBSTAT)      ; BLASE 1
  7C6A    E6 E0                         AND 0E0H
  7C6C    B0                            OR B            ; neuer MONAT einbinden 
  7C6D    CB B7                         RES 6,A         ; Zaehler aktivieren
  7C6F    CB 7F                         BIT 7,A         ; Blase benutzt fuer +/-
  7C71    28 11                         JR Z,RD16       ; Gedaechtniss abziehen =0
  7C73    CB BF                         RES 7,A         ; =1 ADDIEREN loesche
  7C75    32 672C                       LD (RAMS+RBSTAT),A      ; wieder zurueck in Blase1
  7C78    3A 672B                       LD A,(RAMS+RTERM)       ; GEDAECHTNISSZAEHLER AUS RAM
  7C7B    3C                            INC A                   ; Gedaechtniss +1
  7C7C    CA 7C99                       JP Z,RD170              ; Ausgang WENN MAX ERREICHT
  7C7F    32 672B                       LD (RAMS+RTERM),A       ; ZURUECK IN RAM
  7C82    18 0D                         JR RD17
                                        ;--------------
  7C84    32 672C               RD16:   LD (RAMS+RBSTAT),A      ; MONAT SPEICHERN
  7C87    3A 672B                       LD A,(RAMS+RTERM)
  7C8A    D6 01                         SUB 01H                 ; Gedaechtniss schon Min
  7C8C    38 16                         JR C,RD171              ; Ausgang WENN MIN ERREICHT
  7C8E    32 672B                       LD (RAMS+RTERM),A       ; ZURUECK IN RAM
  7C91    3A 6205               RD17:   LD A,(BSTAT)
  7C94    CB B7                         RES 6,A                 ; Sortieren aktivieren aller Blasen
  7C96    32 6205                       LD (BSTAT),A
  7C99    ED 5B 650E            RD170:  LD DE,(BFSHL)           ; Suchadresse speichern
  7C9D    ED 4B 650C                    LD BC,(BFSLL)
  7CA1    C3 7D1C                       JP RD03                 ; nur Blase1 ohne tauschen speicher
                                        ;------------------
  7CA4    3A 6728               RD171:  LD A,(RAMS+RUSER)
  7CA7    3C                            INC A
  7CA8    28 EF                         JR Z,RD170
  7CAA    32 6728                       LD (RAMS+RUSER),A       ; User =FFH damit Blase wieder an Schluss wandert
  7CAD    18 EA                         JR RD170
                                        ;-----------------------
                                        ; Zweite Blase mit Erster Blase beim Speichern tauschen
  7CAF    ED 4B 650C            RD01:   LD BC,(BFSLL)
  7CB3    ED 5B 650E                    LD DE,(BFSHL)   ; Suchadresse 1.Blase speichern
  7CB7    21 6927                       LD HL,RAMS+200H         ; MIT WERT AUS 2.BLASE SPEICHERN
  7CBA    CD 7DE2                       CALL RDWRITE
                                        ;------
                                        ; WRITE SICHTBAR MACHEN
                                        ;LD BC,1401H
        MACRO-80 3.43   27-Jul-81       PAGE    1-42


                                        ;CALL T8
                                        ;LD HL,RAMS+200H
                                        ;CALL LIS0
                                        ;--------
  7CBD    3A 6205                       LD A,(BSTAT)
  7CC0    CB B7                         RES 6,A         ; SORTIEREN START
  7CC2    32 6205                       LD (BSTAT),A
                                        ;-------------------
                                        ; pruefe ob AKTUELLE ZAEHLER ALS 1. Blase offen ist
  7CC5    AF                            XOR A           ; RES CARRY FLAG
  7CC6    ED 5B 650E                    LD DE,(BFSHL)   ; ADRESSE HIGH
  7CCA    2A 6502                       LD HL,(BFRHL)   ; AKTUELL SICHTBARE BLASE
  7CCD    ED 52                         SBC HL,DE       ;-C
  7CCF    20 1D                         JR NZ,TAS22     ; BLASE H SORTIEREN UND OFFEN NICHT GLEICH ->
  7CD1    AF                            XOR A           ; RES CARRY FAG
  7CD2    ED 5B 650C                    LD DE,(BFSLL)   ; ADRESSE LOW
  7CD6    2A 6500                       LD HL,(BFRLL)
  7CD9    ED 52                         SBC HL,DE       ;-C
  7CDB    20 11                         JR NZ,TAS22
                                        ;-------------------
                                        ; DANN ADRESSE AKTUELLER BLASE AUCH TAUSCHEN
                                        ; SICHTBARE BLASE VERSCHIEBEN
  7CDD    ED 5B 6510                    LD DE,(BFSLL+4)
  7CE1    2A 6512                       LD HL,(BFSHL+4)
  7CE4    22 6502                       LD (BFRHL),HL
  7CE7    ED 53 6500                    LD (BFRLL),DE
  7CEB    C3 7D14                       JP TAS24
                                        ;-------------------
                                        ; pruefe ob AKTUELLE ZAEHLER ALS 1. Blase offen ist
  7CEE    AF                    TAS22:  XOR A           ; RES CARRY FLAG
  7CEF    ED 5B 6512                    LD DE,(BFSHL+4) ; Aktuelle Track/Sectoradresse laden
  7CF3    2A 6502                       LD HL,(BFRHL)
  7CF6    ED 52                         SBC HL,DE       ; -C
  7CF8    20 1A                         JR NZ,TAS24     ; BLASE H SORTIEREN UND OFFEN NICHT GLEICH ->
  7CFA    AF                            XOR A           ; RES CARRY FLAG
  7CFB    ED 5B 6510                    LD DE,(BFSLL+4) ; Aktuelle Track/Sectoradresse laden
  7CFF    2A 6500                       LD HL,(BFRLL)
  7D02    ED 52                         SBC HL,DE       ; -C
  7D04    20 0E                         JR NZ,TAS24
                                        ;-----------------
                                        ; AKTUELLE BLASE TAUSCHEN H->L
  7D06    ED 5B 650C                    LD DE,(BFSLL)
  7D0A    2A 650E                       LD HL,(BFSHL)
  7D0D    ED 53 6500                    LD (BFRLL),DE
  7D11    22 6502                       LD (BFRHL),HL
                                        ;-----------------------
                                        ; Erste Blase mit zweiter Blase beim Speichern tauschen
  7D14    ED 4B 6510            TAS24:  LD BC,(BFSLL+4)
  7D18    ED 5B 6512                    LD DE,(BFSHL+4) ; Suchadresse 2. BLASE speichern
  7D1C    21 6727               RD03:   LD HL,RAMS
  7D1F    CD 7DE2                       CALL RDWRITE
                                        ;------
                                        ; WRITE SICHTBAR MACHEN
                                        ;LD BC,1601H
                                        ;CALL T8
                                        ;LD HL,RAMS+200H
        MACRO-80 3.43   27-Jul-81       PAGE    1-43


                                        ;CALL LIS0
                                        ;--------
  7D22    3A 6205                       LD A,(BSTAT)
  7D25    CB 77                         BIT 6,A
  7D27    20 42                         JR NZ,RD02
  7D29    CB F7                         SET 6,A         ; STOP/START
  7D2B    32 6205                       LD (BSTAT),A
                                        ;----------------------
                                        ; nach letztem Blase speichern Sortieradresse > letzter Blase Adr. 
                                        ; dann neu Adr. speichern und bei HDD-neu Anfangsadr. beginnen
  7D2E    AF                            XOR A           ; RES CARRY FLAG
  7D2F    2A 8032                       LD HL,(BF07+2)
  7D32    ED 5B 650E                    LD DE,(BFSHL)   ; LETZTE Suchadresse speichern
  7D36    ED 52                         SBC HL,DE       ; -C
  7D38    30 17                         JR NC,RD30
  7D3A    ED 53 8032                    LD (BF07+2),DE  ; SPEICHE WENN HL<DE
  7D3E    ED 4B 650C                    LD BC,(BFSLL)
  7D42    ED 43 8030                    LD (BF07),BC
  7D46    ED 5B 650C                    LD DE,(BFSLL)
  7D4A    ED 4B 650E                    LD BC,(BFSHL)
  7D4E    C3 7D7F                       JP RD90 
                                        ;---------------
  7D51    ED 5B 650C            RD30:   LD DE,(BFSLL)
  7D55    ED 4B 650E                    LD BC,(BFSHL)
  7D59    C2 7DAC                       JP NZ,RD92
  7D5C    AF                            XOR A           ; RES CARRY FLAG
  7D5D    2A 8030                       LD HL,(BF07)
  7D60    ED 52                         SBC HL,DE       ; -C
  7D62    30 07                         JR NC,RD02
  7D64    ED 53 8030                    LD (BF07),DE
  7D68    C3 7D7F                       JP RD90         ; NACH sPEICHERN BLASE VON NULL NEUSTART
                                ;-----------
  7D6B                          RD02:   ;------
                                        ; READ SICHTBAR MACHEN
                                        ;LD BC,0501H
                                        ;CALL T8
                                        ;LD HL,RAMS
                                        ;CALL LIS0
  7D6B    CD 790F                       CALL FREI
  7D6E    ED 5B 650E                    LD DE,(BFSHL)           ; LETZTE SUCHADRESSE SPEICHERN
                                        ; LD (BF07+4),DE
  7D72    ED 4B 650C                    LD BC,(BFSLL)
                                        ; LD (BF07+6),BC
                                        ;ACHTUNG SECTOR 8/16 LD (BF07),BC
                                        ;---------------------
                                        ; Tastenabfrage und Zeichen einlesen
  7D76    CD 79B7                       CALL KEYST
  7D79    FE 00                         CP 0H
  7D7B    CA 7AD6                       JP Z,TAS        ;TAS00
  7D7E    C9                            RET                     ; RETURN ZU BL ENDE
                                
                                ;---------------------
                                ; RD90 AUSGABE UEBERSPRINGEN
                                ; SUCHADRESSE
                                ;
  7D7F    E5                    RD90:   PUSH HL
        MACRO-80 3.43   27-Jul-81       PAGE    1-44


  7D80    D5                            PUSH DE
  7D81    C5                            PUSH BC
  7D82    ED 5B 650C                    LD DE,(BFSLL)
  7D86    ED 4B 650E                    LD BC,(BFSHL)
  7D8A    CB 38                         SRL B
  7D8C    CB 19                         RR C
  7D8E    CB 1A                         RR D
  7D90    CB 1B                         RR E
  7D92    AF                            XOR A           ; RES CARRY FLAG
  7D93    21 0000                       LD HL,0000H
  7D96    ED 42                         SBC HL,BC       ; -C HIGH
  7D98    20 12                         JR NZ,RD92      ; BC >0 ->
  7D9A    21 0800                       LD HL,HDD
  7D9D    ED 52                         SBC HL,DE
  7D9F    30 05                         JR NC,RD911
  7DA1    18 09                         JR RD92
                                ;----------------------
                                ; RESET TO HDD START
                                ; 
  7DA3    E5                    RD91:   PUSH HL
  7DA4    D5                            PUSH DE
  7DA5    C5                            PUSH BC
  7DA6    11 0801               RD911:  LD DE,HDD+1
  7DA9    01 0000                       LD BC,0
  7DAC    ED 53 650C            RD92:   LD (BFSLL),DE
  7DB0    ED 43 650E                    LD (BFSHL),BC
  7DB4    C1                            POP BC
  7DB5    D1                            POP DE
  7DB6    E1                            POP HL
  7DB7    18 B2                         JR RD02
                                ;------------------------
                                ; READ SECTOR VON HDD
                                ;
  7DB9    DD E5                 RDREAD: PUSH IX
  7DBB    DD 21 0000                    LD IX,0
  7DBF    DD 39                         ADD IX,SP
                                        ;----------------
  7DC1    CD 7FB3                       CALL EXTERN
  7DC4    F5                            PUSH AF         ; PIOA RESCUE
                                        ;----------------
  7DC5    E5                            PUSH HL         ; DMA
  7DC6    C5                            PUSH BC         ; DISK SEL
  7DC7    D5                            PUSH DE         ; DISK SEL
  7DC8    CD 78BB                       CALL DISK
  7DCB    D1                            POP DE
  7DCC    3E 20                         LD A,CMD_READSEC
  7DCE    D3 FF                         OUT (IDECMD),A
  7DD0    7A                            LD A,D
  7DD1    D3 FE                         OUT (IDESDH),A
  7DD3    CD 783E                       CALL WAITDRQ
  7DD6    C1                            POP BC
  7DD7    E1                            POP HL
  7DD8    06 00                         LD B,00H
  7DDA    0E F8                         LD C,IDEDAT
  7DDC    ED B2                         INIR
  7DDE    ED B2                         INIR
        MACRO-80 3.43   27-Jul-81       PAGE    1-45


  7DE0    18 24                         JR HDIST
                                ;----------------------
                                ; BLASE TO SAVE DE=HIGH, BC=LOW
                                ;
  7DE2                          RDWRITE:
  7DE2    DD E5                         PUSH IX
  7DE4    DD 21 0000                    LD IX,0
  7DE8    DD 39                         ADD IX,SP
                                        ;----------------
  7DEA    CD 7FB3                       CALL EXTERN
  7DED    F5                            PUSH AF         ; PIOA RESCUE
                                        ;----------------
  7DEE    E5                            PUSH HL         ; DMA
  7DEF    C5                            PUSH BC         ; DISK SEL
  7DF0    D5                            PUSH DE         ; DISK SEL
  7DF1    CD 78BB                       CALL DISK
  7DF4    D1                            POP DE
  7DF5    C1                            POP BC
  7DF6    3E 30                         LD A,CMD_WRITESEC
  7DF8    D3 FF                         OUT (IDECMD),A
  7DFA    CD 783E                       CALL WAITDRQ
  7DFD    E1                            POP HL          ; DMA ZURUECK
  7DFE    06 00                         LD B,00H
  7E00    0E F8                         LD C,IDEDAT
  7E02    ED B3                         OTIR
  7E04    ED B3                         OTIR
                                        ;----------------
  7E06    F1                    HDIST:  POP AF
  7E07    D3 1C                         OUT (PIOA),A    ; PIOA BACK UP
  7E09    DD F9                         LD SP,IX
  7E0B    DD E1                         POP IX
  7E0D    C9                            RET
                                ;---------------------
                                ; TASK zum Programm Starten
                                ; auf Adr. 100H
                                
  7E0E                          TASK:   ;PUSH   AF
  7E0E    C5                            PUSH    BC
  7E0F    D5                            PUSH    DE
  7E10    E5                            PUSH    HL
  7E11    3A 6928                       LD      A,(RAMS+RUSER+200H)
  7E14    FE FF                         CP      0FFH
  7E16    30 41                         JR      NC,TASK99       ; USER = FFH nicht auswerten
  7E18    7E                            LD      A,(HL)          ; TYPE2 Blase2 vergleichen
  7E19    FE 02                         CP      02H
  7E1B    38 3C                         JR      C,TASK99
  7E1D    3A 6003                       LD      A,(RAM+RTYPE2)
  7E20    FE 02                         CP      02H
  7E22    30 35                         JR      NC,TASK99       ; WENN IN RAM >1 EXTERNE TASK EINGABE
                                        ;----------------------
                                        ; EXTERN BEARBEITEN
                                
  7E24    11 0080                       LD      DE,BUFF
  7E27    21 81DF                       LD      HL,PRLO1
  7E2A    7E                            LD      A,(HL)
  7E2B    12                            LD      (DE),A
        MACRO-80 3.43   27-Jul-81       PAGE    1-46


  7E2C    13                            INC     DE
  7E2D    47                            LD      B,A
  7E2E    CD 71F6                       CALL    BL13
                                ;ERROR ??
                                ; CALL  E.TEXT
                                ; JR    NC,TASK99
                                
  7E31    CD 0100                       CALL    0100H
  7E34    FE 00                         CP      0
  7E36    20 21                         JR      NZ,TASK99
  7E38    ED 4B 6510                    LD BC,(BFSLL+4)
  7E3C    C5                            PUSH BC
  7E3D    ED 5B 6512                    LD DE,(BFSHL+4) ; Suchadresse 2. BLASE speichern
  7E41    D5                            PUSH DE
  7E42    CD 78BB                       CALL DISK
  7E45    D1                            POP DE
  7E46    C1                            POP BC
  7E47    38 10                         JR      C,TASK99
  7E49    01 6927                       LD      BC,RAMS+200H            ; MIT WERT AUS 1. BLASE
  7E4C    CD F82F                       CALL    SETDMA
  7E4F    CD 7FB3                       CALL EXTERN
  7E52    F5                            PUSH AF
  7E53    CD F817                       CALL WRITE
  7E56    F1                            POP AF
  7E57    D3 1C                         OUT (PIOA),A
                                
                                        ;----------------
  7E59    E1                    TASK99: POP     HL
  7E5A    D1                            POP     DE
  7E5B    C1                            POP     BC
                                        ;POP    AF
  7E5C    C9                            RET
                                        ;-----------------------
                                        ; Blase Speichern  aus RAMS in 
                                        ; BC = LL- LH , DE = HL-HH Adresse LBA
  7E5D    C5                    TWRITE: PUSH BC
  7E5E    D5                            PUSH DE
  7E5F    CD 78BB                       CALL DISK
  7E62    D1                            POP DE
  7E63    C1                            POP BC
  7E64    D8                            RET C
  7E65    01 6727                       LD BC,RAMS              ; MIT WERT AUS 2. BLASE
  7E68    CD F82F                       CALL SETDMA
  7E6B    CD 7FB3                       CALL EXTERN
  7E6E    F5                            PUSH AF
  7E6F    CD F817                       CALL WRITE
  7E72    F1                            POP AF
  7E73    D3 1C                         OUT (PIOA),A
  7E75    AF                            XOR     A
  7E76    C9                            RET
                                ;---------------
                                ; INTERRUPT FUER TASK PRUEFEN
                                ;INT:   EI
  7E77    00                            NOP
  7E78    00                            NOP
  7E79    00                            NOP
        MACRO-80 3.43   27-Jul-81       PAGE    1-47


  7E7A    00                            NOP
  7E7B    00                            NOP
  7E7C    00                            NOP
  7E7D    00                            NOP
  7E7E    00                            NOP
  7E7F    F3                            DI
  7E80    C9                            RET
                                
                                ;-----------------------
                                ;  Uhr auslesen
                                
  7E81    C5                    UHR00:  PUSH BC
  7E82    CD 7FAC                       CALL INTERN
  7E85    F5                            PUSH AF
  7E86    DB 1E                         IN A,(PIOB)
  7E88    F5                            PUSH AF
  7E89    3E 3F                         LD A,3FH                ; Adresse fuer Uhr
  7E8B    D3 1E                         OUT (PIOB),A
                                        ;-----------------
                                        ; Minuten in Dezimal
                                        ;
  7E8D    3E 40                         LD A,040H               ; Lesen Ein
  7E8F    D3 98                         OUT (URCS+18H),A
  7E91    DB 9A                         IN A,(URCS+1AH) ; Minuten
  7E93    4F                            LD C,A
                                ;       XOR A
                                ;       OUT (URCS+18H),A        ; R/W Aus
  7E94    C5                            PUSH BC
  7E95    CD 7EDB                       CALL ASCII_CODE
  7E98    C1                            POP BC
  7E99    78                            LD A,B
  7E9A    32 8041                       LD (DAYZ+2),A           ; ZEHNER
  7E9D    3A 8042                       LD A,(DAYZ+3)
  7EA0    B9                            CP C
  7EA1    28 2B                         JR Z,UHR01              ; ZEITAENERUNG NEIN ->
  7EA3    79                            LD A,C
  7EA4    32 8042                       LD (DAYZ+3),A
                                        ;-----------------------
                                        ;       Stunde
                                        ;
                                ;       LD A,040H               ; Lesen Ein
                                ;       OUT (URCS+18H),A
  7EA7    00                            NOP
  7EA8    DB 9B                         IN A,(URCS+1BH) ; Stunde
  7EAA    4F                            LD C,A
  7EAB    AF                            XOR A
  7EAC    D3 98                         OUT (URCS+18H),A        ; R/W Aus
  7EAE    C5                            PUSH BC
  7EAF    CD 7EDB                       CALL ASCII_CODE
  7EB2    C1                            POP BC
  7EB3    78                            LD A,B
  7EB4    32 803F                       LD (DAYZ),A
  7EB7    79                            LD A,C
  7EB8    32 8040                       LD (DAYZ+1),A
                                        ;-----------------
                                        ; DAY auslesen
        MACRO-80 3.43   27-Jul-81       PAGE    1-48


                                        ;
                                ;       LD A,040H               ; Lesen Ein
                                ;       OUT (URCS+18H),A
  7EBB    00                            NOP
  7EBC    DB 9D                         IN A,(URCS+1DH) ; Tag
  7EBE    47                            LD B,A
                                ;       XOR A
                                ;       OUT (URCS+18H),A        ; Lesen Aus
  7EBF    78                            LD A,B
  7EC0    32 803E                       LD (DAYT),A
                                        ;-----------------
                                        ; Monat auslesen
                                        ;
                                ;       LD A,040H               ; Lesen Ein
                                ;       OUT (URCS+18H),A
  7EC3    00                            NOP
  7EC4    DB 9E                         IN A,(URCS+1EH) ; Tag
  7EC6    47                            LD B,A
                                ;       XOR A
                                ;       OUT (URCS+18H),A        ; Lesen Aus
  7EC7    78                            LD A,B
  7EC8    32 803D                       LD (DAYM),A
                                        ;------------------
                                        ; Zeit ausgeben
                                        ;
  7ECB    CD 7F0C                       CALL    UHR10
  7ECE    AF                    UHR01:  XOR A
  7ECF    D3 98                         OUT (URCS+18H),A        ; Lesen Aus
  7ED1    F1                            POP AF
  7ED2    E6 F0                         AND 0F0H
  7ED4    D3 1E                         OUT (PIOB),A
  7ED6    F1                            POP AF
  7ED7    D3 1C                         OUT (PIOA),A
  7ED9    C1                            POP BC
  7EDA    C9                            RET
                                ;---------
  7EDB                          ASCII_CODE:
  7EDB    DD E5                         PUSH IX
  7EDD    DD 21 0000                    LD IX,0
  7EE1    DD 39                         ADD IX,SP
                                        ;------
  7EE3    DD 7E 04                      LD A,(IX+4)     ;B=HIGH
  7EE6    0F                            RRCA
  7EE7    0F                            RRCA
  7EE8    0F                            RRCA
  7EE9    0F                            RRCA
  7EEA    E6 0F                         AND 0FH
  7EEC    C6 30                         ADD A,30H
  7EEE    FE 3A                         CP 3AH
  7EF0    38 02                         JR C,ASC_1
  7EF2    C6 07                         ADD A,07H
  7EF4    DD 77 05              ASC_1:  LD (IX+5),A
  7EF7    DD 7E 04                      LD A,(IX+4)     ; C=LOW
  7EFA    E6 0F                         AND 0FH
  7EFC    C6 30                         ADD A,30H
  7EFE    FE 3A                         CP 3AH
        MACRO-80 3.43   27-Jul-81       PAGE    1-49


  7F00    38 02                         JR C,ASC_2
  7F02    C6 07                         ADD A,07H
  7F04    DD 77 04              ASC_2:  LD (IX+4),A
                                        ;---------
  7F07    DD F9                         LD SP,IX
  7F09    DD E1                         POP IX
  7F0B    C9                            RET             ; RETURN =BC
                                ;-----------------------
                                ;   Uhr anzeigen
                                ;
  7F0C    CD 7822               UHR10:  CALL COFF       ; CURSOR AUS
                                        ;---------------
                                        ; Zeile/Spalte
  7F0F    C5                            PUSH BC
  7F10    01 0075                       LD BC,0075H
  7F13    CD 7A89                       CALL WLIST      ; CURSOR POS
  7F16    C1                            POP BC
  7F17    3A 803F                       LD A,(DAYZ)
  7F1A    CD 7802                       CALL HEXC
  7F1D    3A 8040                       LD A,(DAYZ+1)
  7F20    CD 7802                       CALL HEXC
  7F23    3E 3A                         LD A,3AH
  7F25    CD 7802                       CALL HEXC
  7F28    3A 8041                       LD A,(DAYZ+2)
  7F2B    CD 7802                       CALL HEXC
  7F2E    3A 8042                       LD A,(DAYZ+3)
  7F31    CD 7802                       CALL HEXC
                                        ;-----------
  7F34    CD 7822                       CALL COFF 
  7F37    C5                            PUSH BC
  7F38    01 2475                       LD BC,2475H
  7F3B    CD 7018                       CALL T8         ;CURSOR POS
  7F3E    C1                            POP BC
  7F3F    3A 803E                       LD A,(DAYT)
  7F42    4F                            LD C,A
  7F43    C5                            PUSH BC
  7F44    CD 7EDB                       CALL ASCII_CODE
  7F47    C1                            POP BC
  7F48    78                            LD A,B
  7F49    CD 7802                       CALL HEXC
  7F4C    79                            LD A,C
  7F4D    CD 7802                       CALL HEXC
  7F50    3E 2E                         LD A,2EH
  7F52    CD 7802                       CALL HEXC
  7F55    3A 803D                       LD A,(DAYM)
  7F58    4F                            LD C,A
  7F59    C5                            PUSH BC
  7F5A    CD 7EDB                       CALL ASCII_CODE
  7F5D    C1                            POP BC
  7F5E    78                            LD A,B
  7F5F    CD 7802                       CALL HEXC
  7F62    79                            LD A,C
  7F63    CD 7802                       CALL HEXC
  7F66    18 34                         JR RDU02
                                ;-----------------------
  7F68    3E 02                         LD A,02H
        MACRO-80 3.43   27-Jul-81       PAGE    1-50


  7F6A    32 651C                       LD (CURT),A
  7F6D    3E 04                         LD A,04H
  7F6F    32 651D                       LD (CURT+1),A
  7F72    3A 6B27                       LD A,(RAMT)
  7F75    CB 7F                         BIT 7,A
  7F77    28 04                         JR Z,RDU03
  7F79    3E 00                         LD A,00H
  7F7B    18 02                         JR RDU03+2
  7F7D    3E 01                 RDU03:  LD A,01H
  7F7F    32 651E                       LD (CURT+2),A
  7F82    3A 6B27                       LD A,(RAMT)
  7F85    E6 0F                         AND 0FH
  7F87    FE 0A                         CP 0AH
  7F89    38 0E                         JR C,RDU01
  7F8B    D6 0A                         SUB 0AH
  7F8D    32 651F                       LD (CURT+3),A
  7F90    3A 651E                       LD A,(CURT+2)
  7F93    3C                            INC A
  7F94    32 651E                       LD (CURT+2),A
  7F97    18 03                         JR RDU02
  7F99    32 651F               RDU01:  LD (CURT+3),A
                                
  7F9C    CD 7A6B               RDU02:  CALL RLIST      
  7F9F    21 8050                       LD HL,CURON     ; CURSOR ON
  7FA2    06 06                         LD B,06D
  7FA4    7E                    CUR03:  LD A,(HL)
  7FA5    CD 7802                       CALL HEXC
  7FA8    23                            INC HL
  7FA9    10 F9                         DJNZ CUR03
  7FAB    C9                            RET
                                ;------------------
                                ;INCLUDE LCDINI.MAC
                                ;------------------
                                        ;
                                        ; BUS INTERN UMSCHALTUNG
                                        ;
  7FAC    DB 1C                 INTERN: IN A,(PIOA)
  7FAE    F5                            PUSH AF
  7FAF    CB BF                         RES 7,A
  7FB1    18 05                         JR TERN
  7FB3    DB 1C                 EXTERN: IN A,(PIOA)
  7FB5    F5                            PUSH AF
  7FB6    CB FF                         SET 7,A
  7FB8    D3 1C                 TERN:   OUT (PIOA),A
  7FBA    F1                            POP AF
  7FBB    C9                            RET
                                ;----------------
  7FBC                          EPROMON:        
  7FBC    DB 1C                         IN A,(PIOA)
  7FBE    CB B7                         RES 6,A
  7FC0    D3 1C                         OUT (PIOA),A    ; EPROM Ein
  7FC2    C3 0000                       JP 0000H        ; EPROM NEUSTART -> PROGRAMM ENDE
                                ;------------------------
  7FC5    42 4C 41 53           TEX1:   DEFM 'BLASE VERGLEICH:'
  7FC9    45 20 56 45           
  7FCD    52 47 4C 45           
        MACRO-80 3.43   27-Jul-81       PAGE    1-51


  7FD1    49 43 48 3A           
                                ;TEX1I: DEFB 78H,78H,78H,78H    
  0010                          TXL     EQU $-TEX1
                                
  7FD5    42 4C 41 53           TEX2:   DEFM 'BLASE GEFUNDEN: '
  7FD9    45 20 47 45           
  7FDD    46 55 4E 44           
  7FE1    45 4E 3A 20           
  7FE5    00 00 00 00           TEX2I:  DEFB 00H,00H,00H,00H    
                                
  7FE9    4B 49 53 59           TEX3:   DEFM 'KISYS 08.12.2009/17'
  7FED    53 20 30 38           
  7FF1    2E 31 32 2E           
  7FF5    32 30 30 39           
  7FF9    2F 31 37              
  0013                          TXL3    EQU $-TEX3
                                ;-----------------------
                                ;  BIOS Function Summary
                                
  7FFC    C5                    BIOS:   PUSH    BC
  7FFD    E5                            PUSH    HL
  7FFE    5E                            LD      E,(HL)          ; Speicher Lesen 
  7FFF    CD 0005                       CALL    0005H
  8002    E1                            POP     HL
  8003    C1                            POP     BC
  8004    23                            INC     HL
  8005    10 F5                         DJNZ    BIOS
  8007    C9                            RET
                                ;----------------------
                                ; Blasen Adress Buffer
                                
  8008    00 00 00 00           BF00:   DEFB    00H,00H,00H,00H,80H,00H         ; U,T1,T2 Zaehler zum Blase eroeffnen
  800C    80 00                 
  800E    00 00 00 00           BF01:   DEFB    00H,00H,00H,00H,00H,00H         ; LAST CURSOR POS XX,YY
  8012    00 00                 
  8014    00 00 00 00           BF02:   DEFB    00H,00H,00H,00H,00H,00H
  8018    00 00                 
  801A    00 00 00 00           BF03:   DEFB    00H,00H,00H,00H,00H,00H
  801E    00 00                 
  8020    00 00 00 00           BF04:   DEFB    00H,00H,00H,00H,00H,00H
  8024    00 00                 
  8026    00 00 00 00           BF05:   DEFB    00H,00H,00H,00H,00H,00H
  802A    00 00                 
  802C    00 00 00 00           BF06:   DEFB    00H,00H,00H,00H         ; Datenbankverwaltung
  8030    00 00 00 00           BF07:   DEFB    00H,00H,00H,00H         ; Letzte HDD SORTIERADRESSE
                                ;----------------------
  8034    00 00 00 00           BF10:   DEFB    00H,00H,00H,00H,00H,00H,00H,00H ; User Type, G.Zaehler
  8038    00 00 00 00           
                                ;----------------------
                                ; Kalender
  803C    30                    DAYJ:   DEFB    30H
  803D    30                    DAYM:   DEFB    30H
  803E    30                    DAYT:   DEFB    30H
  803F    30 30 30 30           DAYZ:   DEFB    30H,30H,30H,30H,30H,30H
  8043    30 30                 
                                
        MACRO-80 3.43   27-Jul-81       PAGE    1-52


                                ;----------------------
                                ; Eingabe Meldung Zeile 24, Spalte 1
  0007                          CURUD   EQU 07H                 ; Zaehlen ab 01 - 09
  8045    00 00                 ZEIL:   DEFB 00H,00H
  8047    1B 5B 31 6D           COL01:  DEFB 1BH,5BH,31H,6DH,1BH,5BH,34H,34H,6DH        ;COLOR
  804B    1B 5B 34 34           
  804F    6D                    
  8050    1B 5B 3F 32           CURON:  DEFB 1BH,5BH,3FH,32H,35H,68H            ;SET CURSOR ON
  8054    35 68                 
  8056    1B 5B 3F 32           CUROFF: DEFB 1BH,5BH,3FH,32H,35H,6CH            ;SET CURSOR OFF
  805A    35 6C                 
  805C    1B 5B 32 34           EBUFF:  DEFB 1BH,5BH,'2','4',';','0','1','H'
  8060    3B 30 31 48           
  8064    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  8068    6D                    
  8069    20 20 20 20                   DEFM '                           '
  806D    20 20 20 20           
  8071    20 20 20 20           
  8075    20 20 20 20           
  8079    20 20 20 20           
  807D    20 20 20 20           
  8081    20 20 20              
  8084    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  8088    3B 30 31 48           
  808C    53 75 63 68           EBUFFE: DEFM 'Suche:'
  8090    65 3A                 
  0036                          EZLEN   EQU $-EBUFF
  8092    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  8096    3B 30 31 48           
  809A    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  809E    6D                    
  809F    4C 69 73 74                   DEFM 'List                '
  80A3    20 20 20 20           
  80A7    20 20 20 20           
  80AB    20 20 20 20           
  80AF    20 20 20 20           
  80B3    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  80B7    3B 30 31 48           
  80BB    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  80BF    6D                    
  80C0    8E 6E 64 65                   DEFM  142D,'ndern              '
  80C4    72 6E 20 20           
  80C8    20 20 20 20           
  80CC    20 20 20 20           
  80D0    20 20 20 20           
  80D4    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  80D8    3B 30 31 48           
  80DC    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  80E0    6D                    
  80E1    53 70 65 69                   DEFM 'Speichern           '
  80E5    63 68 65 72           
  80E9    6E 20 20 20           
  80ED    20 20 20 20           
  80F1    20 20 20 20           
  80F5    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  80F9    3B 30 31 48           
        MACRO-80 3.43   27-Jul-81       PAGE    1-53


  80FD    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  8101    6D                    
  8102    56 65 72 67                   DEFM 'Vergessen           '
  8106    65 73 73 65           
  810A    6E 20 20 20           
  810E    20 20 20 20           
  8112    20 20 20 20           
  8116    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  811A    3B 30 31 48           
  811E    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  8122    6D                    
  8123    45 6E 64 65                   DEFM 'Ende                '
  8127    20 20 20 20           
  812B    20 20 20 20           
  812F    20 20 20 20           
  8133    20 20 20 20           
                                
  8137    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  813B    3B 30 31 48           
  813F    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  8143    6D                    
  8144    20 20 20 4C                   DEFM '   List             '
  8148    69 73 74 20           
  814C    20 20 20 20           
  8150    20 20 20 20           
  8154    20 20 20 20           
                                
  8158    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  815C    3B 30 31 48           
  8160    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  8164    6D                    
  8165    20 20 8E 6E                   DEFM '  ',142D,'ndern               '
  8169    64 65 72 6E           
  816D    20 20 20 20           
  8171    20 20 20 20           
  8175    20 20 20 20           
  8179    20 20 20              
                                
  817C    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  8180    3B 30 31 48           
  8184    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  8188    6D                    
  8189    41 6E 6C 65                   DEFM 'Anlegen             '
  818D    67 65 6E 20           
  8191    20 20 20 20           
  8195    20 20 20 20           
  8199    20 20 20 20           
                                
  819D    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  81A1    3B 30 31 48           
  81A5    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  81A9    6D                    
  81AA    53 70 65 69                   DEFM 'Speichern           '
  81AE    63 68 65 72           
  81B2    6E 20 20 20           
  81B6    20 20 20 20           
        MACRO-80 3.43   27-Jul-81       PAGE    1-54


  81BA    20 20 20 20           
                                
  81BE    3A                            DEFB ':'        ; Ende Text
                                
  81BF                          ZCUR:
                                ;!!!    DEFB 08H                                
  81BF    4C 49 53 54                   DEFM 'LISTF.COM   '                             
  81C3    46 2E 43 4F           
  81C7    4D 20 20 20           
                                ;!!!    DEFB 07H        
  81CB    4D 45 4D 2E                   DEFM 'MEM.COM     '
  81CF    43 4F 4D 20           
  81D3    20 20 20 20           
                                ;!!!    DEFB 08H                                
  81D7    45 44 49 54                   DEFM 'EDIT.COM'                         
  81DB    2E 43 4F 4D           
                                
                                ;----------------------
                                
  81DF                          PRLO1:
                                ;!!!    DEFB 08H
  81DF    46 41 4B 54                   DEFM 'FAKT.COM'
  81E3    2E 43 4F 4D           
                                
  81E7    53 74 61 72           STEX:   DEFM 'Start Programm  '
  81EB    74 20 50 72           
  81EF    6F 67 72 61           
  81F3    6D 6D 20 20           
  0010                          LSTEX   EQU $-STEX
                                
  81F7    4B 49 53 79           LCDE:   DEFM  'KISystem Winterhalter'
  81FB    73 74 65 6D           
  81FF    20 57 69 6E           
  8203    74 65 72 68           
  8207    61 6C 74 65           
  820B    72                    
  0015                          LCDEX   EQU     $-LCDE
                                
  820C    1B 5B 31 35           COMZ:   DEFB 1BH,5BH,31H,35H,3BH,30H,31H,48H,1BH,5BH,30H,4AH
  8210    3B 30 31 48           
  8214    1B 5B 30 4A           
  8218    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH,1BH,5BH,34H,32H,6DH
  821C    6D 1B 5B 34           
  8220    32 6D                 
  8222    43 6F 6D 6D                   DEFM  'Commando Zeile= '
  8226    61 6E 64 6F           
  822A    20 5A 65 69           
  822E    6C 65 3D 20           
  0026                          COMZX   EQU     $-COMZ
                                
                                
  8232    1B 5B 32 34           KEYZ:   DEFB 1BH,5BH,32H,34H,3BH,30H,31H,48H
  8236    3B 30 31 48           
  823A    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH,1BH,5BH,34H,32H,6DH
  823E    6D 1B 5B 34           
  8242    32 6D                 
        MACRO-80 3.43   27-Jul-81       PAGE    1-55


  8244    4B 45 59 20                   DEFM  'KEY Stepp= '
  8248    53 74 65 70           
  824C    70 3D 20              
  001D                          KEYZX   EQU     $-KEYZ
                                
  824F    1B 5B 30 31           MELD01: DEFB 1BH,5BH,30H,31H,3BH,30H,31H,48H
  8253    3B 30 31 48           
  8257    1B 5B 33 31                   DEFB 1BH,5BH,33H,31H,6DH,1BH,5BH,34H,34H,6DH
  825B    6D 1B 5B 34           
  825F    34 6D                 
  8261    44 69 65 73                   DEFM  'Dieser Begriff ist mir nicht bekannt'
  8265    65 72 20 42           
  8269    65 67 72 69           
  826D    66 66 20 69           
  8271    73 74 20 6D           
  8275    69 72 20 6E           
  8279    69 63 68 74           
  827D    20 62 65 6B           
  8281    61 6E 6E 74           
  0036                          MELD01X EQU     $-MELD01
                                
  8285    1B 5B 32 34           PROZ:   DEFB 1BH,5BH,32H,34H,3BH,30H,31H,48H
  8289    3B 30 31 48           
  828D    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH,1BH,5BH,34H,32H,6DH
  8291    6D 1B 5B 34           
  8295    32 6D                 
  8297    44 61 74 65                   DEFM  'Dateiname= Dez/Text'
  829B    69 6E 61 6D           
  829F    65 3D 20 44           
  82A3    65 7A 2F 54           
  82A7    65 78 74              
  0025                          PROZX   EQU     $-PROZ
                                
  82AA    1B 5B 32 34           DERR:   DEFB 1BH,5BH,32H,34H,3BH,31H,31H,48H
  82AE    3B 31 31 48           
  82B2    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH,1BH,5BH,34H,37H,6DH
  82B6    6D 1B 5B 34           
  82BA    37 6D                 
  82BC    44 49 53 4B                   DEFM  'DISK / HDD ERROR $'
  82C0    20 2F 20 48           
  82C4    44 44 20 45           
  82C8    52 52 4F 52           
  82CC    20 24                 
  82CE    05 05                         DEFB 05H,05H
  0026                          L_DERR  EQU $-DERR
                                ;---------------------------
  82D0    43 00 00 00           NBLASE: DEFB  MNBL1,00H,00H,00H,80H,00H                       ;         
  82D4    80 00                 
                                        ;------------------
  82D6    1B 5B 32 4A           NBL1:   DEFB  1BH,5BH,32H,4AH,1BH,5BH,48H,1BH,5BH,33H,37H,6DH ; 12 Zeichen
  82DA    1B 5B 48 1B           
  82DE    5B 33 37 6D           
  82E2    1B 5B 31 6D                   DEFB  1BH,5BH,31H,6DH,1BH,5BH,34H,34H,6DH             ; 9 ZEICHEN
  82E6    1B 5B 34 34           
  82EA    6D                    
  82EB    20 20 20 20                   DEFM '                                              ' ; 46 ZEICHEN
        MACRO-80 3.43   27-Jul-81       PAGE    1-56


  82EF    20 20 20 20           
  82F3    20 20 20 20           
  82F7    20 20 20 20           
  82FB    20 20 20 20           
  82FF    20 20 20 20           
  8303    20 20 20 20           
  8307    20 20 20 20           
  830B    20 20 20 20           
  830F    20 20 20 20           
  8313    20 20 20 20           
  8317    20 20                 
  0043                          MNBL1   EQU $-NBL1
                                        ; Taste
  8319    00                            DEFB 00H                                        ; Key Eingabe
                                        ; Programm
  831A    01                            DEFB 01H                                        ; Programme
                                ;!!!    DEFB 0AH                                        ; Leange Programm
  831B    4D 41 53 4B                   DEFM 'MASKE1.COM  '                             ; 10 ZEICHEN
  831F    45 31 2E 43           
  8323    4F 4D 20 20           
  8327    39                            DEFB MNBL2 ;57D                                 ; zum naechsten Textlaenge
  8328    1B 5B 33 37           NBL2:   DEFB 1BH,5BH,33H,37H,6DH                        ; 5 ZEICHEN
  832C    6D                    
  832D    1B 5B 30 33                   DEFB 1BH,5BH,30H,33H,3BH,30H,31H,48H            ; 8 ZEICHEN
  8331    3B 30 31 48           
  8335    09 09 09                      DEFB 09H,09H,09H                                ; 3 ZEICHEN     
  8338    4E 65 75 65                   DEFM 'Neue Seite eroeffnet'                     ; 20 ZEICHEN
  833C    20 53 65 69           
  8340    74 65 20 65           
  8344    72 6F 65 66           
  8348    66 6E 65 74           
  834C    0A 0D                         DEFB 0AH,0DH                                    ; 2 ZEICHEN     
  834E    20 31 20 20                   DEFM ' 1  A'                                    ; 5 ZEICHEN
  8352    41                    
  8353    0A 0D                         DEFB 0AH,0DH                                    ; 2 ZEICHEN
  8355    20 32 20 20                   DEFM ' 2  S'                                    ; 5 ZEICHEN     
  8359    53                    
  835A    0A 0D                         DEFB 0AH,0DH                                    ; 2 ZEICHEN
  835C    20 39 20 20                   DEFM ' 9  E'                                    ; 5 ZEICHEN
  8360    45                    
  0039                          MNBL2   EQU $-NBL2
                                        ; TASTE
  8361    10                            DEFB 10H
                                        ; PROGRAMM
  8362    02                            DEFB 02H
                                ;!!!    DEFB 08D
  8363    41 55 54 4F                   DEFM 'AUTO.COM    '
  8367    2E 43 4F 4D           
  836B    20 20 20 20           
                                ;!!!    DEFB 07D        
  836F    4D 45 4D 2E                   DEFM 'MEM.COM     '
  8373    43 4F 4D 20           
  8377    20 20 20 20           
  837B    00 00                         DEFB 00H,00H     ; 00= keine Keyeingabe folgend, 00= kein Progr.
  00AD                          NBLLE   EQU     $-NBLASE
                                ;----------------------
        MACRO-80 3.43   27-Jul-81       PAGE    1-57


  837D    43 00 00 01           TBLASE: DEFB  MTBLA1,00H,00H,01H,80H,00H                                ;       
  8381    80 00                 
                                        ;------------
  8383    1B 5B 30 6D           TBLA1:  DEFB  1BH,5BH,30H,6DH,1BH,5BH,48H,1BH,5BH,33H,37H,6DH   ; 12 Zeichen
  8387    1B 5B 48 1B           
  838B    5B 33 37 6D           
  838F    1B 5B 31 6D                   DEFB  1BH,5BH,31H,6DH,1BH,5BH,34H,34H,6DH               ; 9 ZEICHEN
  8393    1B 5B 34 34           
  8397    6D                    
  8398    20 20 20 20                   DEFM '                                              '   ; 46 ZEICHEN
  839C    20 20 20 20           
  83A0    20 20 20 20           
  83A4    20 20 20 20           
  83A8    20 20 20 20           
  83AC    20 20 20 20           
  83B0    20 20 20 20           
  83B4    20 20 20 20           
  83B8    20 20 20 20           
  83BC    20 20 20 20           
  83C0    20 20 20 20           
  83C4    20 20                 
  0043                          MTBLA1  EQU $-TBLA1
                                        ; Taste
  83C6    00                            DEFB 00H                                        ; Key Eingabe
                                        ; Programm
  83C7    01                            DEFB 01H                                        ; Programme
                                ;!!!    DEFB 0AH                                        ; Leange Programm
  83C8    45 44 49 54                   DEFM 'EDITOR.COM  '                             ; 10 ZEICHEN
  83CC    4F 52 2E 43           
  83D0    4F 4D 20 20           
  0057                          TBLLE   EQU     $-TBLASE
                                ;-----------------------------
  83D4    43 00 02 00           SMASKE: DEFB MSMAS1,00H,02H,00H,76H,80H
  83D8    76 80                 
                                        ;-------------------
                                        ; BLOCK LAENG OBEN SMASKE ERSTER WERT(43H)
  83DA    1B 5B 32 4A           SMAS1:  DEFB 1BH,5BH,32H,4AH,1BH,5BH,48H,1BH,5BH,33H,37H,6DH
  83DE    1B 5B 48 1B           
  83E2    5B 33 37 6D           
  83E6    1B 5B 31 6D                   DEFB 1BH,5BH,31H,6DH,1BH,5BH,34H,34H,6DH
  83EA    1B 5B 34 34           
  83EE    6D                    
  83EF    53 74 61 72                   DEFM 'Start                                         ' ;46D Zeichen
  83F3    74 20 20 20           
  83F7    20 20 20 20           
  83FB    20 20 20 20           
  83FF    20 20 20 20           
  8403    20 20 20 20           
  8407    20 20 20 20           
  840B    20 20 20 20           
  840F    20 20 20 20           
  8413    20 20 20 20           
  8417    20 20 20 20           
  841B    20 20                 
                                        ;------------------
  0043                          MSMAS1  EQU $-SMAS1
        MACRO-80 3.43   27-Jul-81       PAGE    1-58


  841D    00                            DEFB 00H        
  841E    01                            DEFB 01H        ; ANZAHL PROGRAMMAUFRUFE
                                ;!!!    DEFB 0AH        ; FILE NAME LAENGE
  841F    4D 41 53 4B                   DEFM 'MASKE1.COM  '
  8423    45 31 2E 43           
  8427    4F 4D 20 20           
  842B    20 20 20 20                   DEFM '      Ersatzseite KI-System V1.0 '
  842F    20 20 45 72           
  8433    73 61 74 7A           
  8437    73 65 69 74           
  843B    65 20 4B 49           
  843F    2D 53 79 73           
  8443    74 65 6D 20           
  8447    56 31 2E 30           
  844B    20                    
  844C    0D 0A                         DEFB 0DH,0AH
  844E    10                            DEFB 10H        ; TASTATUR MENGE ZEICHENEINGABE
  844F    01                            DEFB 01H        ; ANZAHL PROGRAMMAUFRUFE
                                ;!!!    DEFB 07H        ; FILE NAME LAENGE
  8450    4D 45 4D 2E                   DEFM 'MEM.COM     '
  8454    43 4F 4D 20           
  8458    20 20 20 20           
  0088                          SRAL    EQU $-SMASKE
                                
  845C    39                            DEFB 57D
  845D    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH                        ; 5 ZEICHEN
  8461    6D                    
  8462    1B 5B 30 33                   DEFB 1BH,5BH,30H,33H,3BH,30H,31H,48H            ; 8 ZEICHEN
  8466    3B 30 31 48           
  846A    09 09 09                      DEFB 09H,09H,09H                                ; 3 ZEICHEN     
  846D    4E 65 75 65                   DEFM 'Neue TYPE2 eroeffnet'                     ; 20 ZEICHEN
  8471    20 54 59 50           
  8475    45 32 20 65           
  8479    72 6F 65 66           
  847D    66 6E 65 74           
  8481    0A 0D                         DEFB 0AH,0DH                                    ; 2 ZEICHEN     
  8483    20 30 20 41                   DEFM ' 0 A?'                                    ; 5 ZEICHEN
  8487    3F                    
  8488    0A 0D                         DEFB 0AH,0DH                                    ; 2 ZEICHEN
  848A    20 31 20 20                   DEFM ' 1  S'                                    ; 5 ZEICHEN     
  848E    53                    
  848F    0A 0D                         DEFB 0AH,0DH                                    ; 2 ZEICHEN
  8491    20 39 20 20                   DEFM ' 9  E'                                    ; 5 ZEICHEN
  8495    45                    
                                        ; TASTE
  8496    10                            DEFB 10H
                                        ; PROGRAMM
  8497    01                            DEFB 01H
  8498    07                            DEFB 07H        
  8499    4D 45 4D 2E                   DEFM 'MEM.COM     '
  849D    43 4F 4D 20           
  84A1    20 20 20 20           
  84A5    00 00                         DEFB 00H,00H     ; 00= keine Keyeingabe folgend, 00= kein Progr.
                                
                                END
        MACRO-80 3.43   27-Jul-81       PAGE    S


Macros:

Symbols:
757B    _ED12           7849    _WAIT1          7EDB    ASCII_CODE      
7EF4    ASC_1           7F04    ASC_2           0047    BAUD1           
0047    BAUD2           0047    BAUD3           8008    BF00            
800E    BF01            8014    BF02            801A    BF03            
8020    BF04            8026    BF05            802C    BF06            
8030    BF07            8034    BF10            6503    BFRHH           
6502    BFRHL           6501    BFRLH           6500    BFRLL           
650F    BFSHH           650E    BFSHL           650D    BFSLH           
650C    BFSLL           650B    BFVHH           650A    BFVHL           
6509    BFVLH           6508    BFVLL           7FFC    BIOS            
7074    BL              70AF    BL00            70CC    BL000           
70DF    BL01            7174    BL02            794E    BL021           
79AC    BL022           79B2    BL023           79A6    BL02X           
7189    BL03            71A4    BL030           719A    BL031           
71C2    BL033           729F    BL04            795A    BL120           
79A7    BL121           7986    BL123           7998    BL124           
799F    BL125           71F6    BL13            71DE    BL131           
71E3    BL132           7201    BL13D           72AF    BL14            
720C    BL23            7214    BL231           7224    BL33            
722F    BL43            723A    BL53            725A    BL73            
7260    BL736           726D    BL83            7291    BL830           
7299    BL831           7288    BL84            6200    BLAN            
72B7    BS10            6205    BSTAT           0080    BUFF            
0020    CMD_READSEC     0030    CMD_WRITESEC    7822    COFF            
7065    COL0            8047    COL01           706A    COL1            
820C    COMZ            0026    COMZX           7811    CON             
6C3F    COP             0007    CPOS            0010    CTC             
7829    CUR01           7818    CUR02           7FA4    CUR03           
8056    CUROFF          8050    CURON           6518    CURS            
651C    CURT            0007    CURUD           77CB    CUT             
803C    DAYJ            803D    DAYM            803E    DAYT            
803F    DAYZ            00F4    DCI             0001    DCLR            
000C    DCON            82AA    DERR            0002    DHOM            
78BB    DISK            0001    DISPLAY         805C    EBUFF           
808C    EBUFFE          7518    ED00            750A    ED01            
7512    ED02            756D    ED03            753C    ED10            
7564    ED100           7567    ED11            7579    ED12            
7591    ED13            75AF    ED14            75B4    ED15            
75B1    ED20            75B7    ED30            75CF    ED31            
75E2    ED32            75E4    ED33            75E6    ED40            
75F1    ED41            7600    ED42            7605    ED43            
760A    ED44            761D    ED441           7634    ED442           
7638    ED50            764D    ED51            74F2    EING            
764F    EING11          767E    EING21          768E    EING22          
76A9    EING23          76B9    EING24          76C8    EING25          
76E1    EING26          76E3    EING27          76EB    EING30          
0040    EOFF            7FBC    EPROMON         787B    ERR1            
71BD    EXIT            7FB3    EXTERN          716A    EZ01            
7171    EZ02            7107    EZ03            7137    EZ04            
0036    EZLEN           005C    FCB             006B    FCBCR           
005D    FCBFN           0065    FCBFT           007C    FCBRA           
790F    FREI            0005    FSET            0800    HDD             
00BE    HDDE            786A    HDD_ERROR       7883    HDD_INFO        
7850    HDD_INIT        7891    HDD_READ        7849    HDD_WAIT        
        MACRO-80 3.43   27-Jul-81       PAGE    S-1


7E06    HDIST           778E    HEX00           7737    HEX11           
774A    HEX12           778E    HEX14           7783    HEXA            
7802    HEXC            772C    HEXI1           773F    HEXI2           
774E    HEXIE           7751    HEXP            00F0    IDE             
00FD    IDECHI          00FC    IDECLO          00FF    IDECMD          
00F8    IDEDAT          00F6    IDEDOR          00F9    IDEERR          
789F    IDERES          78A5    IDERES1         00FA    IDESCNT         
00FE    IDESDH          00FB    IDESNUM         00FF    IDESTAT         
7FAC    INTERN          0000    KANAL0          0001    KANAL1          
0003    KANAL3          0004    KANAL4          0005    KANAL5          
79C9    KEY01           7917    KEYB            793D    KEYB1           
0009    KEYBUF          0002    KEYIN           0001    KEYOUT          
79B7    KEYST           8232    KEYZ            001D    KEYZX           
7024    KI              7096    KI1             00F5    LATCH           
79CB    LBA0            7A14    LBA20           7A15    LBA21           
7A11    LBA4            7A1A    LBA5            0060    LCD             
81F7    LCDE            0015    LCDEX           7AC9    LIS0            
7ACB    LIS1            7AA3    LIST            6513    LOGHH           
6512    LOGHL           6511    LOGLH           6510    LOGLL           
0100    LOS             0120    LOS1            0008    LPOS            
0010    LSTEX           0026    L_DERR          7A54    L__6            
7A4C    L__7            76F1    MAS00           7701    MAS01           
771D    MAS02           824F    MELD01          0036    MELD01X         
A101    MMC             0007    MMCE            0043    MNBL1           
0039    MNBL2           0043    MSMAS1          0043    MTBLA1          
82D6    NBL1            8328    NBL2            82D0    NBLASE          
00AD    NBLLE           001C    PIOA            001E    PIOB            
81DF    PRLO1           0130    PRO             7000    PROG            
8285    PROZ            0025    PROZX           0005    P_READ          
0006    P_WRITE         6524    RADR            6000    RAM             
0021    RAMH            0000    RAML            6727    RAMS            
6B27    RAMT            6527    RAMV            0000    RBLAN           
0005    RBSTAT          7CAF    RD01            7D6B    RD02            
7D1C    RD03            7C4B    RD06            7B59    RD07            
7B5C    RD08            7B64    RD09            7C84    RD16            
7C91    RD17            7C99    RD170           7CA4    RD171           
7BF0    RD25            7C22    RD250           7C04    RD255           
7C0E    RD26            7D51    RD30            7C40    RD35            
7C2E    RD36            7D7F    RD90            7DA3    RD91            
7DA6    RD911           7DAC    RD92            7C67    RDD1            
7DB9    RDREAD          7F99    RDU01           7F9C    RDU02           
7F7D    RDU03           7DE2    RDWRITE         F814    READ            
0000    REG1            00C1    REG3            0044    REG4            
00EA    REG5            7A6B    RLIST           6526    RMEN            
0006    RSOTR           0004    RTERM           6BEF    RTEX            
0002    RTYPE1          0003    RTYPE2          701E    RUN             
0001    RUSER           77BB    SA1             77BF    SA2             
77C1    SA3             6520    SANDB           77AB    SANDU           
0020    SDC             0004    SELDM           00F7    SELDS           
F838    SELDSK          F82F    SETDMA          F835    SETSEC          
F832    SETTRK          0018    SIOA            001A    SIOB            
0018    SIORES          83DA    SMAS1           83D4    SMASKE          
0088    SRAL            81E7    STEX            72EA    STX01           
72DC    SU00            72F0    SU01            733F    SU02            
7342    SU03            7356    SU04            741A    SU21            
74CF    SU23            73FF    SU25            74D7    SU32            
        MACRO-80 3.43   27-Jul-81       PAGE    S-2


74E5    SU33            74AD    SU52            74C1    SU520           
7423    SU62            7455    SU63            73DF    SU80            
7395    SU82            73A5    SU83            73AE    SU84            
738D    SU85            73CC    SU86            73D9    SU87            
737C    SU88            7466    SU90            74AA    SU95            
7476    SU99            78ED    SUCH0           78FB    SUCH1           
78FD    SUCH2           7000    T0              7003    T1              
7006    T2              7009    T3              700C    T4              
700F    T5              7012    T6              7015    T7              
7018    T8              701B    T9              7AD6    TAS             
7B35    TAS00           7BC3    TAS03           7CEE    TAS22           
7D14    TAS24           7E0E    TASK            7E59    TASK99          
FFA2    TASKSP          8383    TBLA1           837D    TBLASE          
0057    TBLLE           71D2    TEING           6204    TERM            
7FB8    TERN            7FC5    TEX1            7FD5    TEX2            
7FE5    TEX2I           7FE9    TEX3            0004    TIME1           
0004    TIME2           0004    TIME3           FFAB    TRACK           
FFA5    TRACKH          FFA4    TRACKL          7E5D    TWRITE          
0010    TXL             0013    TXL3            6202    TYPE1           
6203    TYPE2           7E81    UHR00           7ECE    UHR01           
7F0C    UHR10           0080    URCS            6201    USER            
783E    WAITDRQ         7833    WAITRDY         00F0    WDTCR           
00F1    WDTER           7A89    WLIST           F817    WRITE           
81BF    ZCUR            7728    ZEI00           8045    ZEIL            



No Fatal error(s)


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
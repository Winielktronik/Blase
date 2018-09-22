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
  6201                   C      USER    EQU BLAN+1      ; 16BIT Benutzer Blasenspeicher festlegen 
  6203                   C      TYPE    EQU USER+2      ; 16BIT Anwendung
  6205                   C      TERM    EQU TYPE+2      ; 8BIT Gedaechtniszaehler       
                         C              ; Bit: 7 Gedaechtnisszaehler +/-
                         C              ; Bit: 6 Sortieren Stop/Start
                         C              ; Bit: 5
  6206                   C      BSTAT   EQU TERM+1      ; 8BIT Blasenstatus BYTE % counter
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
  6510                   C      LOGLL   EQU BFSHH+1
        MACRO-80 3.43   27-Jul-81       PAGE    1-1


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
  0003                   C      RTYPE1  EQU RUSER+2     ; application User
  0004                   C      RTYPE2  EQU RTYPE1+1    ; application type
  0005                   C      RTERM   EQU RTYPE2+1    ; memory counter
  0006                   C      RBSTAT  EQU RTERM+1     ; Bubble Status Byte
  0007                   C      RSOTR   EQU RBSTAT+1    ; Buffer while searching        
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
                         C      ;-----------------
        MACRO-80 3.43   27-Jul-81       PAGE    1-2


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
                         C      ;-----------------
                         C      ; PARAMETER
  006F                   C      FBLOCK  EQU 6FH         ; GROESSE FILEBLOCK AM BLASENENDE
                         C      ;-----------------
                                 
                         C      INCLUDE BIOSSEL.MAC
                         C      ;--------------------------
                         C      ; BIOS Hardware CS Adresse
                         C      ; IM SYSTEM HARDWARE
                         C      ;
  00F5                   C      LATCH   EQU 0F5H        ; I/O ADDRESS LATCH FOR A8-A15 EXTERN BUS
  0020                   C      SDC     EQU 20H         ; MMC KATE
  0060                   C      LCD     EQU 60H         ; LCD-DISPAY
  0080                   C      URCS    EQU 80H         ; MIT 2K SRAM A0-A4 PIOA A5-A7
                         C      
  0040                   C      EOFF    EQU 40H         ; EPROM AUS RAM <32K AKTIV
  0021                   C      RAMH    EQU 21H         ; BIT1,5 PIOA BANK1
  0000                   C      RAML    EQU 00H         ; BIT1,5 PIOA BANK0
                                ;---------------
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
        MACRO-80 3.43   27-Jul-81       PAGE    1-3


                         C      ;---------------
                         C      ; I/O CONTROLL REGISTER ADDRESS
                         C      ; END
                                
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
        MACRO-80 3.43   27-Jul-81       PAGE    1-4


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
  7003    C3 780A               T1:     JP HEXC         ; ZEICHENAUSGEBEN
  7006    C3 79F8               T2:     JP KEYST        ; TASTENABFRABE OHNE SORTIERUNG
  7009    C3 78FF               T3:     JP SUCH0        ; Blase mit Eintrag aus RAMT suchen  
  700C    C3 7A0C               T4:     JP LBA0         ; Plattenzugriff (DE), (HL) +1
  700F    C3 7DFA               T5:     JP RDREAD       ; lesen einer Blase
  7012    C3 7E23               T6:     JP RDWRITE      ; Speichern einer Blase
  7015    C3 77D3               T7:     JP CUT          ; CURSOR POS SET IN (CURT)0-3
  7018    C3 7AE4               T8:     JP LIST         ; CURSOR POS SET IN BC
  701B    C3 7929               T9:     JP KEYB         ; input keypad buffer, end with <cr>
                                ;-----------------------
                                ;  LCD 128X128 ANSTEUERN
  701E    DB 1C                 RUN:    IN A,(PIOA)
  7020    CB BF                         RES 7,A         ; INTERN
  7022    D3 1C                         OUT (PIOA),A
                                ;-----------------------
                                ; LCD128X128
        MACRO-80 3.43   27-Jul-81       PAGE    1-5


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
  7027    22 8073                       LD (BF07+2),HL
  702A    22 6502                       LD (BFRHL),HL           ; AKTUELL TRACK/SECTORADRESSE LADEN
                                        ; SORTIERE IN BFS...
  702D    22 650E                       LD (BFSHL),HL           ; IN BFS ADRESSE ZUM SORZIEREN
  7030    22 6512                       LD (BFSHL+4),HL
  7033    22 6512                       LD (LOGHL),HL
  7036    21 0010                       LD HL,0010H             ; STARTADR. USER-LOGIN AUF HDD
  7039    22 6510                       LD (LOGLL),HL
  703C    21 0800                       LD HL,HDD               ; HD STARTADRESSE
  703F    22 8071                       LD (BF07),HL
  7042    22 6500                       LD (BFRLL),HL           ; AKTUELLE TRACK/SECTORADRESSE LADEN
                                        ;-----------------------
                                        ; SORTIER STARTADRESSE SETZEN 
                                        ; BLASE1 UND BLASE2+4 AUS HDD STARTADRESSE+1
  7045    23                            INC HL          ; 
        MACRO-80 3.43   27-Jul-81       PAGE    1-6


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
  7053    32 8049                       LD (BF00),A
  7056    32 804A                       LD (BF00+1),A
  7059    32 804B                       LD (BF00+2),A
  705C    32 804C                       LD (BF00+3),A
  705F    32 804D                       LD (BF00+4),A
  7062    32 804E                       LD (BF00+5),A
  7065    32 804F                       LD (BF00+6),A
                                        ;----------
  7068    C5                            PUSH BC
  7069    D5                            PUSH DE
  706A    E5                            PUSH HL
  706B    21 8088               COL0:   LD HL,COL01             ; BILDSCHIRM FARBE
  706E    06 09                         LD B,09D                ; AUSGABELAENGE
  7070    7E                    COL1:   LD A,(HL)
  7071    CD 780A                       CALL HEXC
  7074    23                            INC HL
  7075    10 F9                         DJNZ COL1
  7077    E1                            POP HL
  7078    D1                            POP DE
  7079    C1                            POP BC
                                ;!!!!   JR KI1          ;!!STARTSEITE NICHT DA ->
                                        ;---
                                        ; Blase aus BFRxx laden
  707A    AF                    BL:     XOR A
  707B    ED 4B 6500                    LD BC,(BFRLL)   ; Aktuelle HIGH LBA laden
  707F    ED 5B 6502                    LD DE,(BFRHL)   ; Aktuelle LOW LBA laden
  7083    21 6000                       LD HL,RAM       ; DMA
  7086    CD 7DFA                       CALL RDREAD
                                        ;------
                                        ; READ SICHTBAR MACHEN
                                ;!!!    LD BC,0501H
                                ;!!!    CALL T8
                                ;!!!    LD HL,RAM
                                ;!!!    CALL LIS0
  7089    3A 6000                       LD A,(RAM)
  708C    FE 43                         CP 43H
  708E    18 0B                         JR KI1 ;!!!!!
                                        ;JR NC,KI1
                                        ;-------------------
  7090    21 8511                       LD HL,SMASKE            ; STARTMASKE LADEN
  7093    11 6000                       LD DE,RAM
  7096    01 00F5                       LD BC,NSMAS
        MACRO-80 3.43   27-Jul-81       PAGE    1-7


  7099    ED B0                         LDIR
  709B    3E 0A                 KI1:    LD A,0AH        ; >9
  709D    32 8083                       LD (DAYZ+3),A   ; UHRZEIT LOESCHEN DAMIT GLEICH AUSGEGEBEN WIRD
                                        ;------------
                                        ; Blasenstatus schon mal auf benutzt setzen
                                        ; IN AKTUELLER BLASE RAM
  70A0    3A 6006                       LD A,(RAM+RBSTAT)       ; RAM
  70A3    CB FF                         SET 7,A         ; GedankenStatus Zaehler 0= minus 1= plus
  70A5    CB B7                         RES 6,A         ; Sortieren aktivieren
  70A7    32 6006                       LD (RAM+RBSTAT),A       ; AUS AKTUELLER BLASE
                                ; ???
  70AA    3A 6206                       LD A,(BLAN+RBSTAT)      ; RAM+200
  70AD    CB FF                         SET 7,A         ; Gedankenzaehler 0= minus 1= plus
  70AF    CB B7                         RES 6,A         ; Sortieren aktivieren
  70B1    32 6206                       LD (BLAN+RBSTAT),A      ; VORBEREITEN
                                        ;---------------------------------
                                        ;  gebe die laenge von B auf VT100 Bildschirm aus 
                                        ;
  70B4    21 6000               BL00:   LD HL,RAM       ; BLASE address
  70B7    AF                            XOR A
  70B8    32 6200                       LD (BLAN),A     ; RUECKSPRUNG BEDINGUNG =0
  70BB    22 6524               BL00A:  LD (RADR),HL    ; cache current BLASE address JE DURCHLAUF 1.2.3...
  70BE    7E                            LD A,(HL)       ; Number of characters from mask BLOCK 1
  70BF    32 6526                       LD (RMEN),A     ; caching character length
  70C2    11 6000                       LD DE,RAM
  70C5    ED 52                         SBC HL,DE       ; determine BLASEN start
  70C7    2A 6524                       LD HL,(RADR)    ; load current BLASE address
  70CA    20 1E                         JR NZ,BL01      ; no BLASEN start ->
                                        ;-----------------------
                                        ; BLASEN beginning new (RAM)
                                        ; load restart parameter
                                        ; 
  70CC    23                            INC HL          ; ->USER
  70CD    23                            INC HL          ; USER+1
  70CE    23                            INC HL          ; ->TYPE1
  70CF    7E                            LD A,(HL)       ; load type1
  70D0    32 804C                       LD (BF00+RTYPE1),A      
  70D3    23                            INC HL          ; ->Type2
  70D4    23                            INC HL          ; ->Gedaechtniszaehler
  70D5    23                            INC HL          ; ->Status Byte
  70D6    23                            INC HL          ; from here graphic/text area
                                        ;----------------
                                        ; in header =5 byte
  70D7    3A 6526               BL000:  LD A,(RMEN)     ; load character length
  70DA    47                            LD B,A          ; B= counter
  70DB    AF                            XOR A           ; USER.... 
  70DC    B8                            CP B            ; counter > 0
  70DD    CA 74FD                       JP Z,EING       ; no character jump to the input =0 ->
                                        ;--------------------------------
                                        ; set cursor und BLOCK output 
                                        ;
  70E0    E5                            PUSH HL
  70E1    C5                            PUSH BC
  70E2    01 0101                       LD BC,0101H     ; cursor home
  70E5    CD 7018                       CALL T8         ; set cursor
  70E8    C1                            POP BC
        MACRO-80 3.43   27-Jul-81       PAGE    1-8


  70E9    E1                            POP HL
                                        ; BLOCK output
  70EA    7E                    BL01:   LD A,(HL)       ; first char
  70EB    CD 780A                       CALL HEXC       ; output area
  70EE    23                            INC HL          ; from here graphic/text area
  70EF    10 F9                         DJNZ BL01       ; counter B
                                
                                        ; (HL) KOPFZEILE ENDE
                                        ;---------------------------
                                        ; Issue Blasen parameters USER,TYPE1,TYPE2,
                                        ; memory in % 
                                        ; top right Z=1, S=60
                                        ;
  70F1    E5                            PUSH HL         ; RETTE BLASE
  70F2    D5                            PUSH DE
  70F3    C5                            PUSH BC
  70F4    01 0160                       LD BC,0160H     
  70F7    CD 7018                       CALL T8         ; set cursor
  70FA    C1                            POP BC
  70FB    21 6001                       LD HL,RAM+RUSER ; USER address from current BLASE
  70FE    C5                            PUSH BC
  70FF    4E                            LD C,(HL)       ; USER load
  7100    C5                            PUSH BC
  7101    CD 7792                       CALL HEX14      ; USER / %
  7104    C1                            POP BC
  7105    C1                            POP BC
  7106    21 6002                       LD HL,RAM+RUSER+1       ; USER address from current BLASE
  7109    C5                            PUSH BC
  710A    4E                            LD C,(HL)       ; USER load
  710B    C5                            PUSH BC
  710C    CD 7792                       CALL HEX14      ; USER / %
  710F    C1                            POP BC
  7110    C1                            POP BC
  7111    2A 6003                       LD HL,(RAM+RTYPE1)      ; TYPE2=L ,TYPE1=H LADEN
                                        ;---------------------
                                        ; output memory count in %
  7114    3A 6005                       LD A,(RAM+RTERM)        ; memory count load
  7117    5F                            LD E,A  
                                ;!!!??  LD A,00H
  7118    F5                    EZ03:   PUSH AF
  7119    7B                            LD A,E
  711A    D6 02                         SUB 02H
  711C    FE 03                         CP 03h
  711E    38 28                         JR C,EZ04
  7120    28 26                         JR Z,EZ04
  7122    5F                            LD E,A
  7123    F1                            POP AF
  7124    3C                            INC A
  7125    27                            DAA
  7126    F5                            PUSH AF
  7127    7B                            LD A,E
  7128    D6 03                         SUB 03H
  712A    FE 03                         CP 03H
  712C    38 1A                         JR C,EZ04
  712E    28 18                         JR Z,EZ04
  7130    5F                            LD E,A
        MACRO-80 3.43   27-Jul-81       PAGE    1-9


  7131    F1                            POP AF
  7132    3C                            INC A
  7133    27                            DAA
  7134    CB 47                         BIT 0,A
  7136    28 E0                         JR Z,EZ03
  7138    F5                            PUSH AF
  7139    7B                            LD A,E
  713A    D6 03                         SUB 03H
  713C    FE 03                         CP 03H
  713E    38 08                         JR C,EZ04
  7140    28 06                         JR Z,EZ04
  7142    5F                            LD E,A
  7143    F1                            POP AF
  7144    3C                            INC A
  7145    27                            DAA
  7146    18 D0                         JR EZ03
                                        ;-------------------
  7148    F1                    EZ04:   POP AF
  7149    C5                            PUSH BC
  714A    4F                            LD C,A
  714B    C5                            PUSH BC
  714C    CD 7792                       CALL HEX00              ; % WERT AUSGEBEN
  714F    C1                            POP BC
  7150    C1                            POP BC
  7151    3E 25                         LD A,'%'                ; % ALS ZEICHEN
  7153    CD 780A                       CALL HEXC
  7156    D1                            POP DE
  7157    E1                            POP HL
                                        ; from here against BLASEN address
                                        ;-------------------------------
                                        ; key in sign
                                        ;
                                ;!!! SCHON BEI BL00A:   INC HL          ; key 
  7158    46                            LD B,(HL)       ; 00H = no grafic VT100 output
  7159    E5                            PUSH HL
  715A    21 6B27                       LD HL,RAMT      ; RAMT Zeichen Buffer Eingaben
  715D    11 6B27                       LD DE,RAMT      ; ZEICHEN SPEICHERN
  7160    13                            INC DE          ; fuer erstes Zeichen
  7161    AF                            XOR A
  7162    77                            LD (HL),A       ; Eingabe Zeichenzaehler auf Null setzen
  7163    B8                            CP B
  7164    CA 7196                       JP Z,BL03       ; SPEUNG ZUR EINGABE OHNE GRAFIK AUSGABE 
                                        ; WEITER MIT GRAFIK TEXTEINGABE
                                        ;--------------------------
                                        ; BLOCK AN VT100 ausgeben LAENGE IN B
  7167    D5                            PUSH DE
  7168    E5                            PUSH HL         ; Grafik/Text 
  7169    C5                            PUSH BC
  716A    3A 6004                       LD A,(RAM+RTYPE2)
  716D    FE 00                         CP 0H
  716F    C2 717E                       JP NZ,EZ02      ; exit not 0
  7172    21 809D                       LD HL,EBUFF
  7175    06 36                         LD B,EZLEN
  7177    7E                    EZ01:   LD A,(HL)
  7178    CD 780A                       CALL HEXC
  717B    23                            INC HL
        MACRO-80 3.43   27-Jul-81       PAGE    1-10


  717C    10 F9                         DJNZ EZ01
  717E    C1                    EZ02:   POP BC
  717F    E1                            POP HL
  7180    D1                            POP DE
  7181    C5                    BL02:   PUSH BC
  7182    D5                            PUSH DE
  7183    E5                            PUSH HL
  7184    CD 7B17                       CALL TAS        ; auf Zeichen Warten
  7187    F5                            PUSH AF
  7188    CD 7823                       CALL CON        ; CURSOR ON
  718B    F1                            POP AF
  718C    E1                            POP HL
  718D    D1                            POP DE
  718E    C1                            POP BC
  718F    CD 701B                       CALL T9
  7192    FE 0D                         CP 0DH
  7194    20 EB                         JR NZ,BL02
                                ;-----------------------
                                ; load and execute file.com
                                ;
  7196    E1                    BL03:   POP HL          ; zurueck zur aktuellen RAM adre.
  7197    23                            INC HL          ; PROGRAMM AUFRUF 1,2,3,4....
  7198    7E                            LD A,(HL)       ; Pruefe ob Zeichen ??Programmaufruf da 
                                        ;!!!INC HL              ; 
  7199    FE 00                         CP 00H
  719B    20 0A                         JR NZ,BL031     ; SPRUNG AUS BLASENVORGABE
  719D    3A 6B27                       LD A,(RAMT)
  71A0    FE 00                         CP 00H
  71A2    20 0D                         JR NZ,BL030     ; SPRUNG AUS KEYBUFF PRORAMMAUFRUF 
  71A4    C3 72BE                       JP BL14 ;!!!!00A        ; KEIN AUFRUF =00 ->WEITER 
                                        ;------------------------
  71A7    F6 30                 BL031:  OR 30H          ; sonst Zeichenzaehler auf 1 setzen
  71A9    32 6B28                       LD (RAMT+1),A   ; 
  71AC    3E 01                         LD A,01H        ; Programme mindest ASCII 1
  71AE    32 6B27                       LD (RAMT),A     ; Programmzaehler
  71B1    3A 6B27               BL030:  LD A,(RAMT)     ; Anzahl der Taste 
  71B4    FE 02                         CP 02H          ; ZEICHEN ZAEHLER >
  71B6    D2 72BE                       JP NC,BL14      ; Taste mehr als eine Stelle
  71B9    3A 6B28                       LD A,(RAMT+1)   ; gedruektes Taste =31-39  Zeichen
  71BC    FE 30                         CP 30H
  71BE    28 19                         JR Z,TEING      ; ??Aender moeglich machen mit 0
  71C0    FE 39                         CP 39H          ; MIT 9 ENDE
  71C2    20 05                         JR NZ,BL033
  71C4    0E 00                 EXIT:   LD C,00H
  71C6    C3 7FFD                       JP EPROMON
                                ;-------
  71C9    FE 3A                 BL033:  CP 3AH          ; nicht > 9
  71CB    D2 70B4                       JP NC,BL00      ; AUSGANG FEHLER
  71CE    D6 30                         SUB 30H         ; nicht < 1
  71D0    DA 70B4                       JP C,BL00       ; AUSGANG FEHLER
  71D3    47                            LD B,A          ; Welches Programm in A 1 - 9
  71D4    22 6524                       LD (RADR),HL    ; aktuelle RAM Adresse retten 
  71D7    18 0C                         JR BL131
                                        ;-------------------
                                        ; AENDERUNG NUR IN TYPE2 =0 MOEGLICH
  71D9    3A 6004               TEING:  LD A,(RAM+RTYPE2)
        MACRO-80 3.43   27-Jul-81       PAGE    1-11


  71DC    FE 00                         CP 0H
  71DE    CA 74FD                       JP Z,EING
  71E1    C3 70B4                       JP BL00
                                        ;-----------------
                                        ; Programm suchen und Starten
  71E4    19                    BL131A: ADD HL,DE
  71E5    11 000C               BL131:  LD DE,000CH     ; MAX Laenge einer Datei
  71E8    10 FA                         DJNZ BL131A
  71EA    11 0080               BL132:  LD DE,BUFF      ; <- Zurueck von Zeilen-Prog.aufruf
                                ;!!!    INC HL          ; WIEVIEL ZEICHEN DATEINAME
                                ;!!!    LD A,(HL)       ; PRUEFE DAPROGRAMME 
                                ;!!!    CP 0H
                                ;!!!    JP Z,BL00       ; KEIN PROGRAMM =0 ->
  71ED    3E 0C                         LD A,12D
  71EF    12                            LD (DE),A
  71F0    13                            INC DE
  71F1    E6 0F                         AND 0FH
  71F3    47                            LD B,A          ; Laenge der Datei auslesen
  71F4    CD 7205                       CALL BL13
  71F7    D2 7297                       JP NC,BL84
  71FA    D5                            PUSH DE
  71FB    11 82EF                       LD DE,DERR
  71FE    CD 7819                       CALL HEXB
  7201    D1                            POP DE  ;BL830  ; ERROR DATEI NICHT GEFUNDEN
  7202    C3 70B4                       JP BL00
                                        ;-------------------
                                        ; PROGRAMM AUS (HL) ]BERNEHMEM UND LADEN
                                        ; B= LAENGE DES DATEINAMEN
                                        ; (HL) DATEINAME.COM
                                        ; NACH (DE) BUFFER COPIEREN 
                                        ;
  7205    7E                    BL13:   LD A,(HL)
  7206    FE 21                         CP 21H          ; PRUEFE OB NOCH ASCII >20 (SPACE)
  7208    38 05                         JR C,BL13E
  720A    12                            LD (DE),A
  720B    CD 780A                       CALL HEXC       ; !!!! PROGRAMMNAME SICHTBAR MACHEN ZUM TEST
  720E    13                            INC DE
  720F    23                    BL13E:  INC HL          ; FILE NACH KOPFTEXE 
  7210    10 F3                         DJNZ BL13
                                        ;--
                                        ;!!!! LD (RADR),HL
  7212    AF                            XOR A
  7213    12                            LD (DE),A
                                        ;------------------
                                        ;
  7214    11 005D                       LD DE,FCBFN
  7217    3E 20                         LD A,20H
  7219    06 0B                         LD B,0BH
  721B    12                    BL23:   LD (DE),A       ; LOESCHEN B MAL
  721C    13                            INC DE
  721D    10 FC                         DJNZ BL23
  721F    3E 00                         LD A,00H
  7221    06 08                         LD B,08H
  7223    12                    BL231:  LD (DE),A       ; LOESCHEN B MAL
  7224    13                            INC DE
  7225    10 FC                         DJNZ BL231
        MACRO-80 3.43   27-Jul-81       PAGE    1-12


                                        ;--------------
                                        ;
  7227    E5                            PUSH HL
  7228    11 005C                       LD DE,FCB
  722B    AF                            XOR A
  722C    12                            LD (DE),A
  722D    13                            INC DE
  722E    21 0080                       LD HL,BUFF
  7231    46                            LD B,(HL)       ; DATEINAMEN LAENGE
  7232    23                            INC HL
  7233    7E                    BL33:   LD A,(HL)
  7234    FE 2E                         CP 2EH          ; POINT ERKENNUNG .COM
  7236    20 06                         JR NZ,BL43
  7238    23                            INC HL
  7239    11 0065                       LD DE,FCBFT
  723C    18 F5                         JR BL33 
                                        ;-----------
  723E    12                    BL43:   LD (DE),A
  723F    13                            INC DE
  7240    23                            INC HL
  7241    10 F0                         DJNZ BL33
  7243    CD 78B1                       CALL IDERES
  7246    AF                            XOR A
  7247    06 14                         LD B,14H
  7249    12                    BL53:   LD (DE),A
  724A    13                            INC DE
  724B    10 FC                         DJNZ BL53
  724D    1E 04                         LD E,SELDM      ; MASTER DISK
  724F    0E 0E                         LD C,14D
  7251    CD 0005                       CALL 0005H      ; BEZUGSLAUFWERK LW-NUMMER
  7254    E5                            PUSH HL
  7255    AF                            XOR A
  7256    32 006B                       LD (FCBCR),A    ; cr loeschen
  7259    11 005C                       LD DE,FCB
  725C    0E 0F                         LD C,0FH
  725E    CD 0005                       CALL 0005H
  7261    FE FF                         CP 0FFH
  7263    20 04                         JR NZ,BL73      ; ->kein Fehler POP HL fehlt
  7265    E1                            POP HL
  7266    E1                            POP HL          ; Adresse zurueck
  7267    37                            SCF
  7268    C9                            RET
                                        ;--------------------
                                        ;  Dateisatz lesen
                                        ;
  7269    3A 007C               BL73:   LD A,(FCBRA)
  726C    11 0100                       LD DE,0100H     ; DMA Buffer
  726F    FE 00                 BL736:  CP 00H
  7271    28 09                         JR Z,BL83
  7273    3D                            DEC A
  7274    21 0080                       LD HL,0080H
  7277    19                            ADD HL,DE
  7278    E5                            PUSH HL
  7279    D1                            POP DE          ; HL nach DE kopieren
  727A    18 F3                         JR BL736
  727C    0E 1A                 BL83:   LD C,1AH        ; Datenbuffer festlegen
        MACRO-80 3.43   27-Jul-81       PAGE    1-13


  727E    CD 0005                       CALL 0005H      ; CCP
  7281    E5                            PUSH HL
  7282    D5                            PUSH DE
  7283    C5                            PUSH BC
  7284    11 005C                       LD DE,FCB
  7287    0E 14                         LD C,14H
  7289    CD 0005                       CALL 0005H      ; Datei laden
  728C    C1                            POP BC
  728D    D1                            POP DE
  728E    E1                            POP HL
  728F    FE 00                         CP 00H
  7291    28 D6                         JR Z,BL73       ; wiederhole bie Datei geladen
  7293    E1                            POP HL          ; wenn bei BL53: kein Fehler RAM weiter
  7294    E1                            POP HL          ; Adresse zurueck
  7295    AF                            XOR A
  7296    C9                            RET
                                        ;---------------
                                        ; GEFUNDENES PROGRAMM STARTEN
                                        ;
  7297    E5                    BL84:   PUSH HL
  7298    D5                            PUSH DE
  7299    C5                            PUSH BC
  729A    CD 0100                       CALL 0100H
  729D    C1                            POP BC
  729E    D1                            POP DE
  729F    E1                            POP HL
                                        ;----------
                                        ; Ende der Programme berechnen
  72A0    2A 6524               BL830:  LD HL,(RADR)    ; Aktuelle Blasenadresse holen
  72A3    46                            LD B,(HL)       ; NAECHSTE DATEI LAENGE
  72A4    04                            INC B           ; ERSTES ZEICHEN
  72A5    18 01                         JR BL831
                                        ;-----------
  72A7    19                            ADD HL,DE
  72A8    11 000C               BL831:  LD DE,000CH     ; Laenge (13Dez.) einer Datei
  72AB    10 FA                         DJNZ BL831-1    
  72AD    23                            INC HL
                                        ;-----------------
                                        ; Sprungadresse in I/O-RAM (0) Laden
                                        ;
  72AE    3A 6200               BL04:   LD A,(BLAN)     ; Rueckmeldung aus Unterprogramm
  72B1    FE 00                         CP 00H
  72B3    CA 70B4                       JP Z,BL00       ; Blase neu starten
  72B6    FE 01                         CP 01H
  72B8    CA 70BB                       JP Z,BL00A      ; naechster Block aus Blase 
  72BB    C3 70B4                       JP BL00         ; weiter mit RAM
                                ;---------------------------
                                ; Aktuelle Blase im RAM nach Begriff durchsuchen
                                ;
  72BE    3A 6001               BL14:   LD A,(RAM+1)    ; Type1
  72C1    47                            LD B,A
                                ;??neu 16BIT     LD A,(USER) TYPE1
  72C2    B8                            CP B
  72C3    CA 72C6                       JP Z,BS10               ; gefunden
                                ;---------------------------
                                ;  Blase vom Anfang aus nach RAMR laden und Text suchen
        MACRO-80 3.43   27-Jul-81       PAGE    1-14


                                 
  72C6    3A 804A               BS10:   LD A,(BF00+RUSER)       ; UEBERNEHMEN
  72C9    32 8076                       LD (BF10+RUSER),A       ; loeschen 
  72CC    3A 804C                       LD A,(BF00+RTYPE1)      ; uebernehmen
  72CF    32 8078                       LD (BF10+RTYPE1),A      ; loeschen 
  72D2    3A 804D                       LD A,(BF00+RTYPE2)      ; uebernehmen 
  72D5    32 8079                       LD (BF10+RTYPE2),A      ; loeschen 
  72D8    32 807A                       LD (BF10+RTERM),A       ; loeschen 
  72DB    32 807B                       LD (BF10+RBSTAT),A      ; loeschen 
  72DE    AF                            XOR A
  72DF    32 650B                       LD (BFVHH),A    ; Aktuelle Track/Sectoradresse laden
  72E2    32 650A                       LD (BFVHL),A
  72E5    21 0801                       LD HL,HDD+1     ; Startadresse
  72E8    22 6508                       LD (BFVLL),HL   ; Aktuelle Track/Sectoradresse laden
                                ;-------------------------
                                ; Blase zum vergleich laden und Text in Speicher suchen
                                ;
  72EB    C5                    SU00:   PUSH BC
  72EC    D5                            PUSH DE
  72ED    E5                            PUSH HL
  72EE    CD 7834                       CALL COFF
  72F1    06 50                         LD B,80D
  72F3    21 6B27                       LD HL,RAMT
  72F6    11 6BEF                       LD DE,RTEX
  72F9    7E                    STX01:  LD A,(HL)
  72FA    12                            LD (DE),A
  72FB    23                            INC HL
  72FC    13                            INC DE
  72FD    10 FA                         DJNZ STX01
  72FF    ED 4B 6508            SU01:   LD BC,(BFVLL)
  7303    ED 5B 650A                    LD DE,(BFVHL)           ; Suchadresse 
  7307    21 6527                       LD HL,RAMV
  730A    CD 7DFA                       CALL RDREAD             ; AKTUELLE BLASE LADEN
                                        ; READ SICHTBAR MACHEN
  730D    01 1501                       LD BC,1501H
  7310    CD 7018                       CALL T8
  7313    21 6527                       LD HL,RAMV
  7316    CD 7B0A                       CALL LIS0
  7319    E5                            PUSH HL
  731A    21 0801                       LD HL,HDD+1
  731D    22 6510                       LD (BFSLL+4),HL
  7320    21 0000                       LD HL,0000H
  7323    22 6512                       LD (BFSHL+4),HL
  7326    E1                            POP HL
                                        ;---------------------
                                        ; Cursor drehen lassen und
                                        ; nach Abstand gefundener Zeichen setzen
  7327    CD 7EC2                       CALL UHR00
  732A    3E 02                         LD A,02H
  732C    32 651C                       LD (CURT),A
  732F    3E 04                         LD A,04H
  7331    32 651D                       LD (CURT+1),A
  7334    3E 02                         LD A,02H
  7336    32 651E                       LD (CURT+2),A
  7339    3A 6B27                       LD A,(RAMT)
  733C    FE 0A                         CP 0AH
        MACRO-80 3.43   27-Jul-81       PAGE    1-15


  733E    38 0E                         JR C,SU02
  7340    D6 0A                         SUB 0AH
  7342    32 651F                       LD (CURT+3),A
  7345    3A 651E                       LD A,(CURT+2)
  7348    3C                            INC A
  7349    32 651E                       LD (CURT+2),A
  734C    18 03                         JR SU03
  734E    32 651F               SU02:   LD (CURT+3),A
                                        ;------------------------
                                        ; vergleich, suche nach Blasen beginnen
                                        ;
  7351    CD 77D3               SU03:   CALL CUT
  7354    21 6527                       LD HL,RAMV              ; in Blase suchen mit
  7357    11 6B27                       LD DE,RAMT              ; Textanfang 1. Zeichen
  735A    1A                            LD A,(DE)               ; neue TextLAENGE mit
  735B    FE 02                         CP 02H                  ; Suchtext muss > 1 Zeichen sein
  735D    DA 74B8                       JP C,SU52               ; Ausgang ohne suchtext
  7360    23                            INC HL                  ; ZU USER 
  7361    3A 804A                       LD A,(BF00+RUSER)       ; Aus sichtbarer aktuel Blase
  7364    BE                            CP (HL)                 ; RAMV VERGLEICH MIT USER IN BLASE 
                                        ;JP Z,SU80              ; User mit Blase ist gleich 
                                        ;JP NC,SU62             ; ERST IN USER+1 LEERE BLASE SUCHEN
  7365    3A 652C               SU04:   LD A,(RAMV+RTERM)       ; Gedaechtnisszaehler
  7368    FE FF                         CP 0FFH                 ; nach leerer ,abgelaufener Blase 
  736A    C2 742E                       JP NZ,SU62              ; noch nicht leer, abgelaufen
  736D    3A 6004                       LD A,(RAM+RTYPE2)       ; MUSS BLASENANFANG SEIN
  7370    FE 00                         CP 0H                   ; nach leerer ,abgelaufener Blase 
  7372    C2 74B8                       JP NZ,SU52              ; noch nicht leer, abgelaufen
                                ;-----------------------
                                ; neue Blase Eroeffnen mit Eingabetext 
                                ; als Ueberschrift
                                ;
                                ; Blasenadr. BFVxx mit BFRxx tauschen (HL)->(DE)
                                ;               
  7375    11 6500                       LD DE,BFRLL     ; Aktuelle Blaseadresse ersetzen durch
  7378    21 6508                       LD HL,BFVLL     ; Leere gefundene Blase
  737B    EB                            EX DE,HL        ; TAUSCHEN
                                        ;----------------
  737C    3A 8079                       LD A,(BF10+RTYPE2)
  737F    FE 00                         CP 0H
  7381    28 18                         JR Z,SU85
  7383    18 16                         JR SU85         ;!!!! HIER RAUS
  7385    06 19                         LD B,25D                ; laenge DES KOPFTEXT AUS Blase einkopieren
  7387    11 601B                       LD DE,RAM+1BH   ; Adr. Aktueller Blase
  738A    21 843A                       LD HL,TBLASE+1BH        ; Textblock leerer Blase
  738D    1A                    SU88:   LD A,(DE)
  738E    77                            LD (HL),A
  738F    23                            INC HL
  7390    13                            INC DE
  7391    10 FA                         DJNZ SU88
  7393    06 F2                         LD B,TBLLE      ; laenge neuer Blase einkopieren
  7395    11 6000                       LD DE,RAM       ; Adr. Aktueller Blase
  7398    21 841F                       LD HL,TBLASE    ; Textblock leerer Blase
                                        ;!!!JP SU82
                                        ;---------------
                                        ; Ueberschrift aus suchtext einsetzen
        MACRO-80 3.43   27-Jul-81       PAGE    1-16


  739B    01 0101               SU85:   LD BC,NBLLE     ; copy length of new block
  739E    11 6000                       LD DE,RAM
  73A1    21 831E                       LD HL,NBLASE
  73A4    ED B0                         LDIR
  73A6    CD 79C9                       CALL MASK1
  73A9    3A 6B27                       LD A,(RAMT)
  73AC    47                            LD B,A          ; Textlaenge in B
  73AD    11 6000                       LD DE,RAM
  73B0    13                    SU83:   INC DE          ; Nach Space 20H suchen erstes Zeichen
  73B1    1A                            LD A,(DE)
  73B2    FE 20                         CP 20H
  73B4    20 FA                         JR NZ,SU83
                                        ;-----------------
  73B6    21 6B28                       LD HL,RAMT+1    ; erstes Zeichen
  73B9    7E                    SU84:   LD A,(HL)               ; uebertrageb bis B=0
  73BA    12                            LD (DE),A
  73BB    23                            INC HL
  73BC    13                            INC DE
  73BD    10 FA                         DJNZ SU84
                                        ;-----------------      
                                        ; BF10 IN NEU GEFUNDENE BLASE ]BERNEHMEN
                                        ; RUSER, RTYPE1+1, RTYPE2
                                        ;
  73BF    3A 8076                       LD A,(BF10+RUSER)
  73C2    32 6001                       LD (RAM+RUSER),A        ; Aktueller USER uebernehmen
  73C5    3A 8079                       LD A,(BF10+RTYPE2)
  73C8    FE 00                         CP 0
  73CA    28 0B                         JR Z,SU86
  73CC    3A 804C                       LD A,(BF00+RTYPE1)      ; uebernehmen 
  73CF    32 6003                       LD (RAM+RTYPE1),A       ; uebernehmen 
  73D2    3A 8079                       LD A,(BF10+RTYPE2)      ; uebernehmen 
                                        ;LD (RAM+RTYPE2),A      ; uebernehmen 
  73D5    18 0D                         JR SU87 
  73D7    3A 8078               SU86:   LD A,(BF10+RTYPE1)      ; uebernehmen 
  73DA    3C                            INC A
  73DB    32 6003                       LD (RAM+RTYPE1),A       ; uebernehmen 
  73DE    3A 8079                       LD A,(BF10+RTYPE2)      ; uebernehmen 
  73E1    32 6004                       LD (RAM+RTYPE2),A       ; uebernehmen 
                                        ;------------------
  73E4    E1                    SU87:   POP HL
  73E5    D1                            POP DE
  73E6    C1                            POP BC
  73E7    C3 70B4                       JP BL00
                                        ; ENDE neue Blase anspringen
                                        ;--------------------------
                                        ; weiter vergleichen
                                
  73EA    23                    SU80:   INC HL          ; zu TYPE1 in RAMV
  73EB    23                            INC HL          ; ZU TYPE2 IN RAMV
  73EC    3A 8079                       LD A,(BF10+RTYPE2)
                                        ;CP (HL)
  73EF    B6                            OR (HL)
  73F0    CA 7471                       JP Z,SU90
  73F3    23                            INC HL          ; Gedaechtnisz. TERM 
  73F4    3A 807A                       LD A,(BF10+RTERM)       ; 
  73F7    BE                            CP (HL)
        MACRO-80 3.43   27-Jul-81       PAGE    1-17


  73F8    CA 742E                       JP Z,SU62               ; nicht =1
  73FB    23                            INC HL          ; Status Byte
  73FC    23                            INC HL          ; ZEICHENAUSWERTUNG
  73FD    13                            INC DE          ; ERSTES SUCHZEICHEN IN RAMT
  73FE    1A                            LD  A,(DE)              ; 1. ZEICHEN MUSS '/' SEIN
  73FF    FE 2F                         CP '/'
  7401    28 07                         JR Z,SU25
  7403    AF                            XOR A
  7404    32 8079                       LD (BF10+RTYPE2),A      ; '/' fehlt dann TYPE2=0 und TYPE1 SUCHEN
  7407    C3 742E                       JP SU62         ; WEITER NACH TYPE1+TYPE2=0 SUCHEN->
                                        ;------------
  740A    3A 6003               SU25:   LD A,(RAM+RTYPE1)
  740D    47                            LD B,A
  740E    3A 652A                       LD A,(RAMV+RTYPE1)
  7411    B8                            CP B
  7412    C2 742E                       JP NZ,SU62
  7415    3A 652B                       LD A,(RAMV+RTYPE2)
  7418    FE 01                         CP 1H
  741A    DA 742E                       JP C,SU62
  741D    C2 742E                       JP NZ,SU62
  7420    3A 6B27                       LD A,(RAMT)     ; neuer Text mit
  7423    06 3F                         LD B,03FH               ; laenge (255D) eine Zeile zum vergleichen
  7425    CD 78FF               SU21:   CALL SUCH0
  7428    DA 742E                       JP C,SU62
                                        ;CALL MAS00
  742B    C3 74DA                       JP SU23
                                        ; Error anzeigen ??
                                        ; Bereich Ende xxxxxxxx1, xxxxxxx2, .... ????
                                        ; noch einbauen
                                        ;
  742E    CD 79F8               SU62:   CALL KEYST      ; CONSOLE AUF ZEICHEN ABFRAGE
  7431    FE 1B                         CP 1BH
  7433    CA 74B8                       JP Z,SU52       ; ABBRUCH MIT ESC
  7436    ED 5B 6508                    LD DE,(BFVLL)   ; Aktuelle Track/Sectoradresse laden
  743A    D5                            PUSH DE
  743B    2A 650A                       LD HL,(BFVHL)
  743E    E5                            PUSH HL
  743F    CD 7A0C                       CALL LBA0               ; Suchadresse +1
  7442    E1                            POP HL
  7443    22 650A                       LD (BFVHL),HL   
  7446    D1                            POP DE
  7447    ED 53 6508                    LD (BFVLL),DE           ; Suchadresse speichern
  744B    38 6B                         JR C,SU52       ; CARRY -> ENDE
  744D    18 11                         JR SU63
                                        ;--------------
  744F    ED 4B 8073                    LD BC,(BF07+2)          ; HL
  7453    ED 42                         SBC HL,BC
  7455    38 09                         JR C,SU63
  7457    EB                            EX DE,HL
  7458    ED 4B 8071                    LD BC,(BF07)            ; LL
  745C    ED 42                         SBC HL,BC               
  745E    30 58                         JR NC,SU52              ; LETZTE SUCHADRESSE AUS TAS00 
  7460    7B                    SU63:   LD A,E
  7461    E6 1F                         AND 1FH
  7463    FE 10                         CP 10H
  7465    C2 72FF                       JP NZ,SU01
        MACRO-80 3.43   27-Jul-81       PAGE    1-18


  7468    CD 77D3                       CALL CUT
  746B    CD 77B3                       CALL SANDU
  746E    C3 72FF                       JP SU01
                                        ;--------------------------
                                        ; weiter vergleichen
                                        ; fuer naechste neue Blase vorbereiten 
                                        ; und in neuer Blase uebernehmen
  7471    2B                    SU90:   DEC HL          ; ZURUECK ZU TYPE1
  7472    3A 8078                       LD A,(BF10+RTYPE1)      ; Type1 
  7475    BE                            CP (HL)
  7476    30 09                         JR NC,SU99
  7478    3C                            INC A
  7479    28 06                         JR Z,SU99               ; groesser 0FFH
  747B    BE                            CP (HL)
  747C    20 03                         JR NZ,SU99              ; Abstand groesser 1
  747E    32 8078                       LD (BF10+RTYPE1),A      ; Type1 wenn groesser uebernehmen
  7481    23                    SU99:   INC HL          ; Type2 in Blase
                                ;--------------------------
                                ;       hier auf erste Type2 =0 selektiert aus Blase
                                ;
  7482    3A 8079                       LD A,(BF10+RTYPE2)      ; Type2 aus RAMV Blase
  7485    BE                            CP (HL)
  7486    C2 742E                       JP NZ,SU62              ; NEUE RAMV BLASE nicht =0 
                                ;--------------------------
                                ; wenn Gedaechtnisszaehler =0 dann ungueltig
                                ; frei fuer neue Blase
  7489    23                            INC HL          ; Gedaechtnisz. TERM 
  748A    3A 807A                       LD A,(BF10+RTERM)       ; Gedaechtnisz. aus Blase
  748D    BE                            CP (HL)
  748E    CA 742E                       JP Z,SU62               ; nicht =1 ->
  7491    23                            INC HL          ; Status Byte
  7492    23                            INC HL          ; ZeichenGROESSE
  7493    1A                            LD A,(DE)               ; neuer Text mit
  7494    47                            LD B,A
  7495    13                            INC DE          ; ERSTES ZEICHEN
                                        ;--------------------
                                        ; ERSTES ZEICHEN GROSS
  7496    1A                            LD A,(DE)
  7497    FE 5B                         CP 5BH
  7499    D2 74B8                       JP NC,SU52              ; ERSTES ZEICHEN MUSS GROSS BUCHST.SEIN
                                        ;--------------------
  749C    78                            LD A,B
  749D    06 3F                         LD B,3FH                ; laenge (46D) eine Zeile zum vergleichen
  749F    CD 78FF                       CALL SUCH0
  74A2    DA 742E                       JP C,SU62
  74A5    3A 652A                       LD A,(RAMV+RTYPE1) ; WENN BLASE GEFUNDEN TYPE1 UEBERNEHMEN
  74A8    32 8078                       LD (BF10+RTYPE1),A      ; Type1 =0 wenn BLASE GEFUNDEN
  74AB    3A 8079                       LD A,(BF10+RTYPE2)      ; BLASE TYPE1 GEFUNDEN
  74AE    3C                            INC A           ;SET    0,A >0 SETZEN F]R TYPE2 SUCHEN
  74AF    32 8079                       LD (BF10+RTYPE2),A
  74B2    C3 74DA                       JP SU23
                                ;-----------------------
                                ; Kein Eintrag in TYPE2>0 gefunden
                                ;       
  74B5    C3 70B4               SU95:   JP BL00
                                ;----------------
        MACRO-80 3.43   27-Jul-81       PAGE    1-19


                                ;
  74B8    21 8294               SU52:   LD HL,MELD01
  74BB    06 36                         LD B,MELD01X
  74BD    0E 02                         LD C,02H                ; BIOS Console Output
  74BF    CD 803D                       CALL BIOS
  74C2    11 0000                       LD DE,0000H
  74C5    06 08                         LD B,08H
  74C7    3E 00                         LD A,00H
  74C9    32 6B27                       LD (RAMT),A
  74CC    15                    SU520:  DEC D
  74CD    20 FD                         JR NZ,SU520
  74CF    1D                            DEC E
  74D0    20 FA                         JR NZ,SU520
  74D2    10 F8                         DJNZ SU520
  74D4    E1                            POP HL
  74D5    D1                            POP DE
  74D6    C1                            POP BC
  74D7    C3 70B4                       JP BL00
                                        ;----------------
                                        ; AKTUELLE MIT GEFUNDENE BLASE TAUSCHEN
                                        ; DANN NEUE BLASE ANZEIGEN      
  74DA    06 04                 SU23:   LD B,04H
  74DC    11 6500                       LD DE,BFRLL
  74DF    21 6508                       LD HL,BFVLL
  74E2    7E                    SU32:   LD A,(HL)
  74E3    12                            LD (DE),A
  74E4    23                            INC HL
  74E5    13                            INC DE 
  74E6    10 FA                         DJNZ SU32
                                        ; EINGABEZEILE LOESCHEN
  74E8    01 2401                       LD BC,2401H
  74EB    CD 7018                       CALL T8
  74EE    06 46                         LD B,70D
  74F0    3E 20                 SU33:   LD A,20H
  74F2    CD 780A                       CALL HEXC
  74F5    10 F9                         DJNZ SU33
  74F7    E1                            POP HL
  74F8    D1                            POP DE
  74F9    C1                            POP BC
  74FA    C3 707A                       JP BL
                                ;------------------------
                                ;       Starte Eingabemode
                                ;
  74FD    C5                    EING:   PUSH BC
  74FE    D5                            PUSH DE
  74FF    E5                            PUSH HL
                                        ;------------------------
                                        ; pruefe auf Anfangsadresse BLASE = RAM
                                        ;       
  7500    2A 6524                       LD HL,(RADR)    ; zuletzten Blasenabschnitt Adr.0
  7503    3E 00                         LD A,00H
  7505    32 6B27                       LD (RAMT),A     ; ZEICHEN EINGABEZAEHLER AUF 0 SETZEN
  7508    BE                            CP (HL)
  7509    20 16                         JR NZ,ED00      ; 
  750B    AF                            XOR A
  750C    11 6000                       LD DE,RAM
        MACRO-80 3.43   27-Jul-81       PAGE    1-20


  750F    ED 52                         SBC HL,DE
  7511    20 37                         JR NZ,ED10              ; -> ADRESSE NICHT GLEICH
                                        ;--------------------
                                        ; (RADR) = RAM und kein Zeichen 
                                        ; dann Blase mit 00H ueberschreiben 2*256lang
                                        ;
  7513    06 00                         LD B,00H
  7515    3E 00                 ED01:   LD A,00H                ; RAM 256 auf null setzen
  7517    77                            LD (HL),A
  7518    23                            INC HL
  7519    10 FA                         DJNZ ED01
  751B    06 F9                         LD B,0F9H
  751D    3E 00                 ED02:   LD A,00H                ; RAM 249 auf null setzen
  751F    77                            LD (HL),A
  7520    23                            INC HL
                                        ;!!!!DJNZ ED02
                                        ;---------------------
                                        ; Blasenanfang bestimmen
                                        ;
  7521    2A 6524               ED00:   LD HL,(RADR)
                                ;       LD B,(HL)
  7524    06 F0                         LD B,0F0H               ; Max Zeicheneingabe
  7526    AF                            XOR A
  7527    11 6000                       LD DE,RAM
  752A    ED 52                         SBC HL,DE
  752C    2A 6524                       LD HL,(RADR)
  752F    20 19                         JR NZ,ED10              ; -> kein Blasenanfang
  7531    23                            INC HL
  7532    3A 6201                       LD A,(USER)     ; in Blase uebernemen
  7535    77                            LD (HL),A
  7536    23                            INC HL
  7537    3A 6202                       LD A,(USER+1)   ; in Blase uebernemen
  753A    77                            LD (HL),A
  753B    23                            INC HL
  753C    3A 6203                       LD A,(TYPE)
  753F    77                            LD (HL),A
  7540    23                            INC HL
  7541    3A 6204                       LD A,(TYPE+1)
  7544    77                            LD (HL),A
  7545    23                            INC HL          ; Gedaechtniss Zaehler
  7546    3E 7F                         LD A,07FH               ; auf 50% setzen
  7548    77                            LD (HL),A
  7549    23                            INC HL          ; Status Byte
                                        ;------------------------
                                        ;  Grafik/Text ausgeben
                                        ;
  754A    C5                    ED10:   PUSH BC
  754B    01 0301                       LD BC,0301H
  754E    CD 7018                       CALL T8
  7551    2A 6524                       LD HL,(RADR)
  7554    3A 6B27                       LD A,(RAMT)
  7557    3C                            INC A
  7558    47                            LD B,A
  7559    AF                            XOR A           ; RES CARRY FLAG
  755A    11 6000                       LD DE,RAM
  755D    ED 52                         SBC HL,DE       ; Blasen Anfang pruefen
        MACRO-80 3.43   27-Jul-81       PAGE    1-21


  755F    2A 6524                       LD HL,(RADR)
  7562    20 0E                         JR NZ,ED100
  7564    3E 06                         LD A,06H
  7566    85                            ADD A,L         ; Versatz an Blasenanfang
  7567    6F                            LD L,A          ; USER, TYPE1, TYPE2, GE, GS, 
  7568    3E 00                         LD A,00H
  756A    32 651C                       LD (CURT),A
  756D    3E 01                         LD A,01H
  756F    32 651D                       LD (CURT+1),A
  7572    CD 77D3               ED100:  CALL CUT
  7575    7E                    ED11:   LD A,(HL)
  7576    CD 780A                       CALL HEXC
  7579    23                            INC HL          ; naechstes Zeichen
  757A    10 F9                         DJNZ ED11
  757C    C1                            POP BC
                                        ;---------------------
                                        ; Tasteneingabe
                                        ;       
  757D    C5                    ED12:   PUSH BC
  757E    E5                            PUSH HL
  757F    CD 79F8               _ED12:  CALL KEYST
  7582    FE 00                         CP 0H
  7584    28 F9                         JR Z,_ED12      ; -> KEIN ZEICHEN
  7586    5F                            LD E,A          ; neues Zeichen
  7587    E1                            POP HL
  7588    C1                            POP BC
  7589    FE 20                         CP 20H
  758B    38 2E                         JR C,ED30       ; wenn Zeichen < 20H
  758D    FE 23                         CP 23H          ; # Zeichen fuer Eingabenende
  758F    CA 75B5                       JP Z,ED20
  7592    CD 763C                       CALL ED50
                                        ;-------------------
                                        ; Rechts Parameter anzeichen
                                        ;
  7595    7E                    ED13:   LD A,(HL)       ; letztes Zeichen zurueckladen
  7596    5F                            LD E,A          ; und Anzeigen aus Reg. E
  7597    C5                            PUSH BC
  7598    01 0578                       LD BC,0578H
                                        ;CALL T8
  759B    4E                            LD C,(HL)
  759C    C5                            PUSH BC         ; IX HOLEN
  759D    CD 7792                       CALL HEX14
  75A0    C1                            POP BC
  75A1    01 0473                       LD BC,0473H
  75A4    CD 7018                       CALL T8
  75A7    C1                            POP BC
  75A8    C5                            PUSH BC
  75A9    3A 6B27                       LD A,(RAMT)
  75AC    4F                            LD C,A
  75AD    C5                            PUSH BC         ; IX HOLEN
  75AE    CD 7792                       CALL HEX00
  75B1    C1                            POP BC
  75B2    C1                            POP BC
  75B3    10 03                 ED14:   DJNZ ED15               ; ED12
  75B5    C3 7653               ED20:   JP EING11
  75B8    C3 754A               ED15:   JP ED10
        MACRO-80 3.43   27-Jul-81       PAGE    1-22


                                ;-------------------------
                                ; Steuerzeichen Auswerten
                                
  75BB    FE 0D                 ED30:   CP 0DH          ; CR
  75BD    28 2B                         JR Z,ED40
  75BF    FE 08                         CP 08H          ; Backspase
  75C1    28 32                         JR Z,ED41
  75C3    FE 09                         CP 09H
  75C5    28 3D                         JR Z,ED42               ; TAB
  75C7    FE 1B                         CP 1BH          ; ESC
  75C9    28 3E                         JR Z,ED43
  75CB    FE 08                         CP 08H          ; ESC
  75CD    28 3F                         JR Z,ED44               ; BackSpace
  75CF    C5                            PUSH BC
  75D0    E5                            PUSH HL
  75D1    06 80                         LD B,80H
  75D3    10 FE                 ED31:   DJNZ ED31
  75D5    CD 79F8                       CALL KEYST      ; CONSOLE AUF ZEICHEN ABFRAGE
  75D8    FE 00                         CP 0
  75DA    28 0A                         JR Z,ED32
  75DC    C5                            PUSH BC
  75DD    4F                            LD C,A
  75DE    C5                            PUSH BC
  75DF    CD 7792                       CALL HEX14
  75E2    C1                            POP BC
  75E3    C1                            POP BC
  75E4    18 EB                         JR ED31-2
                                        ;-----------
  75E6    E1                    ED32:   POP HL
  75E7    C1                            POP BC
  75E8    18 AB                 ED33:   JR ED13
                                ;--------------------------
                                ;
  75EA    CD 763C               ED40:   CALL ED50
  75ED    23                            INC HL
  75EE    3E 0A                         LD A,0AH
  75F0    CD 763C                       CALL ED50
                                ;       INC HL
  75F3    18 F3                         JR ED33
                                        ;-------------
  75F5    3E 20                 ED41:   LD A,20H                ; Zeichen loeschen
  75F7    77                            LD (HL),A
  75F8    3A 6B27                       LD A,(RAMT)
  75FB    D6 01                         SUB 01H
  75FD    38 E9                         JR C,ED33
  75FF    32 6B27                       LD (RAMT),A
  7602    18 E4                         JR ED33
                                        ;-----------
  7604    CD 763C               ED42:   CALL ED50
                                ;       INC HL
  7607    18 DF                         JR ED33
                                        ;------------
  7609    CD 763C               ED43:   CALL ED50
                                ;       INC HL
  760C    18 DA                         JR ED33
                                        ;-----------
        MACRO-80 3.43   27-Jul-81       PAGE    1-23


  760E    E5                    ED44:   PUSH HL
  760F    C5                            PUSH BC
  7610    3A 6524                       LD A,(RADR)
  7613    FE 00                         CP 00H
  7615    28 21                         JR Z,ED442
  7617    3A 6B27                       LD A,(RAMT)
  761A    FE 00                         CP 00H
  761C    28 1A                         JR Z,ED442
  761E    01 0002                       LD BC,0002H
  7621    7E                    ED441:  LD A,(HL)
  7622    2B                            DEC HL
  7623    77                            LD (HL),A
  7624    23                            INC HL
  7625    23                            INC HL
  7626    10 F9                         DJNZ ED441
  7628    0D                            DEC C
  7629    20 F6                         JR NZ,ED441
  762B    2A 6524                       LD HL,(RADR)
  762E    35                            DEC (HL)
  762F    2A 6B27                       LD HL,(RAMT)
  7632    35                            DEC (HL)
  7633    C1                            POP BC
  7634    E1                            POP HL
  7635    2B                            DEC HL
  7636    18 B0                         JR ED33
                                        ;-----------
  7638    C1                    ED442:  POP BC
  7639    E1                            POP HL
  763A    18 AC                         JR ED33
                                ;--------------------------
                                ; Zeichenzaehler vergleichen
                                ; RAM-Aktuell mit RAM-Text
  763C    77                    ED50:   LD (HL),A
  763D    3A 6B27                       LD A,(RAMT)
  7640    3C                            INC A
  7641    32 6B27                       LD (RAMT),A
  7644    C9                            RET
                                        ;--------
  7645    4F                            LD C,A
  7646    E5                            PUSH HL
  7647    2A 6524                       LD HL,(RADR)
  764A    7E                            LD A,(HL)
  764B    B9                            CP C
  764C    D2 7651                       JP NC,ED51              ; RAMT > RADR dann RADR+1
  764F    3C                            INC A
  7650    77                            LD (HL),A
  7651    E1                    ED51:   POP HL
  7652    C9                            RET
                                        ;-----------------------
                                        ; KEY Stepps Eingabe in HEX
                                        ; 
  7653    E5                    EING11: PUSH HL
  7654    2A 6524                       LD HL,(RADR)
  7657    3A 6B27                       LD A,(RAMT)
  765A    77                            LD (HL),A
  765B    21 8277                       LD HL,KEYZ
        MACRO-80 3.43   27-Jul-81       PAGE    1-24


  765E    06 1D                         LD B,KEYZX
  7660    0E 02                         LD C,02H                ; BIOS Console Output
  7662    CD 803D                       CALL BIOS
                                        ;------------------------
  7665    E1                            POP HL
  7666    C5                            PUSH BC
  7667    4E                            LD C,(HL)               ; Speicher Lesen 
  7668    C5                            PUSH BC
  7669    CD 7792                       CALL HEX00
  766C    C1                            POP BC
  766D    C1                            POP BC
  766E    E5                            PUSH HL
  766F    CD 7B17                       CALL TAS
  7672    5F                            LD E,A
  7673    CD 7730                       CALL HEXI1
  7676    D5                            PUSH DE
  7677    CD 7B17                       CALL TAS
  767A    D1                            POP DE
  767B    5F                            LD E,A
  767C    CD 7743                       CALL HEXI2
  767F    E1                            POP HL
                                ;       LD D,10H
  7680    72                            LD (HL),D
  7681    23                            INC HL
                                        ;-----------------
                                        ; Dateiaufruf
                                        ; Text ausgeben
                                        ;
  7682    E5                    EING21: PUSH HL
  7683    21 82CA                       LD HL,PROZ
  7686    06 25                         LD B,PROZX
  7688    0E 02                         LD C,02H                ; BIOS Console Output
  768A    CD 803D                       CALL BIOS
                                        ;------------------------
  768D    06 0C                         LD      B,0CH           ; Dateinamenlaenge
  768F    0E 00                         LD      C,00H           ; loeschen
  7691    E1                            POP     HL
  7692    C5                    EING22: PUSH    BC
  7693    D5                            PUSH    DE
  7694    5E                            LD      E,(HL)          ; Speicher Lesen 
  7695    E5                            PUSH    HL
  7696    D5                            PUSH    DE
  7697    C5                            PUSH BC
  7698    4B                            LD C,E
  7699    C5                            PUSH BC
  769A    CD 7792                       CALL    HEX00           ; HEX Anzeigen
  769D    C1                            POP BC
  769E    C1                            POP BC
  769F    CD 7B17                       CALL    TAS     ; ZEICHEN EINGABE
  76A2    D1                            POP     DE
  76A3    E1                            POP     HL
  76A4    77                            LD      (HL),A          ; Tasteneingabee retten
  76A5    D1                            POP     DE
  76A6    C1                            POP     BC
  76A7    FE 2E                         CP      2EH             ; Dateineman Ende
  76A9    20 02                         JR      NZ,EING23       ; -> noch nicht
        MACRO-80 3.43   27-Jul-81       PAGE    1-25


  76AB    06 04                         LD      B,04H           ; Zaehler aus Erweiterung set
  76AD    3E 0C                 EING23: LD      A,0CH           ; Dateinamenlaenge
  76AF    B8                            CP      B
  76B0    20 1A                         JR      NZ,EING25       ; -> kein Anfang mehr
  76B2    7E                            LD      A,(HL)          ; Tastein ASCII -> 0-9 unr.
  76B3    D6 30                         SUB     30H
  76B5    38 2E                         JR      C,EING26
  76B7    FE 0A                         CP      0AH
  76B9    38 02                         JR      C,EING24
  76BB    D6 07                         SUB     07H
  76BD    E6 0F                 EING24: AND     0FH
  76BF    4F                            LD      C,A
  76C0    77                            LD      (HL),A          ; Speichern
  76C1    FE 00                         CP      00H
  76C3    28 20                         JR      Z,EING26        ; Ende -> Ausgang
  76C5    E5                            PUSH    HL
  76C6    D1                            POP     DE              ; HL -> DE
  76C7    13                            INC     DE
  76C8    3E FF                         LD      A,0FFH
  76CA    12                            LD      (DE),A
  76CB    23                            INC     HL
  76CC    23                    EING25: INC     HL
  76CD    1A                            LD      A,(DE)
  76CE    3C                            INC     A
  76CF    12                            LD      (DE),A          ; Dateiname Zeichezaehler +1
  76D0    10 C0                         DJNZ    EING22
  76D2    47                            LD      B,A             ; naechste Dateiadresse berechnen
  76D3    3E 0C                         LD      A,0CH
  76D5    90                            SUB     B
  76D6    16 00                         LD      D,00H
  76D8    5F                            LD      E,A
  76D9    19                            ADD     HL,DE
  76DA    E5                            PUSH    HL
  76DB    D1                            POP     DE
  76DC    3E 00                         LD      A,00H
  76DE    12                            LD      (DE),A
  76DF    23                            INC     HL
  76E0    06 0B                         LD      B,0BH
  76E2    0D                            DEC     C
  76E3    20 AD                         JR      NZ,EING22
  76E5    06 0F                 EING26: LD      B,0FH
  76E7    AF                    EING27: XOR     A
  76E8    77                            LD      (HL),A
  76E9    23                            INC     HL
  76EA    10 FB                         DJNZ    EING27
  76EC    C3 70B4                       JP BL00         ; PUSH POP ???
  76EF    E1                    EING30: POP HL
  76F0    D1                            POP DE
  76F1    C1                            POP BC
  76F2    C3 70B4                       JP BL00
                                ;-------------------------
                                ; TYPE2 MASKE AUFBAUEN
                                
  76F5    3A 6000               MAS00:  LD A,(RAM)
  76F8    47                            LD B,A          ; ZEICHENL$NGE ZUM ANHAENGEN
                                        ; CURSOR AUF XXXXZEILE 1 SETZEN
        MACRO-80 3.43   27-Jul-81       PAGE    1-26


  76F9    3E 00                         LD A,00H
  76FB    32 651C                       LD (CURT),A
  76FE    3E 01                         LD A,01H
  7700    32 651D                       LD (CURT+1),A
                                        ;------------------
                                        ; CURSOR RECHTR SCHIEBEN
                                
  7703    3E 00                         LD A,00H
  7705    3C                    MAS01:  INC A
  7706    27                            DAA
  7707    10 FC                         DJNZ MAS01
  7709    47                            LD B,A
  770A    E6 0F                         AND 0FH
  770C    32 651F                       LD (CURT+3),A
  770F    78                            LD A,B
  7710    0F                            RRCA
  7711    0F                            RRCA
  7712    0F                            RRCA
  7713    0F                            RRCA
  7714    E6 0F                         AND 0FH
  7716    32 651E                       LD (CURT+2),A
  7719    CD 77D3                       CALL CUT
  771C    11 6B27                       LD DE,RAMT
  771F    1A                            LD A,(DE)
  7720    47                            LD B,A
  7721    13                    MAS02:  INC DE
  7722    1A                            LD A,(DE)
  7723    CD 780A                       CALL HEXC
  7726    10 F9                         DJNZ MAS02
  7728    C9                            RET     
  7729    C3 74B8                       JP SU52
                                ;-------------------------
                                ; Programmaufruf mit Cursor up/down
                                
  772C    00                    ZEI00:  NOP
  772D    C3 71EA                       JP      BL132
                                
                                ;-------------------------
                                ;   Hexunwandlung
                                
  7730    7B                    HEXI1:  LD A,E          ; Eingabe Umwandeln
  7731    D6 30                         SUB 30H
  7733    38 1D                         JR C,HEXIE
  7735    FE 0A                         CP 0AH
  7737    38 02                         JR C,HEX11
  7739    D6 07                         SUB 07H
  773B    07                    HEX11:  RLCA
  773C    07                            RLCA
  773D    07                            RLCA
  773E    07                            RLCA
  773F    E6 F0                         AND 0F0H
  7741    57                            LD D,A
  7742    C9                            RET
                                        ;-----------
  7743    7B                    HEXI2:  LD A,E          ; Adresse anzeigen
  7744    D6 30                         SUB 30H
        MACRO-80 3.43   27-Jul-81       PAGE    1-27


  7746    38 0A                         JR C,HEXIE
  7748    FE 0A                         CP 0AH
  774A    38 02                         JR C,HEX12
  774C    D6 07                         SUB 07H
  774E    E6 0F                 HEX12:  AND 0FH
                                        ;ADD A,D        ; ??
                                        ;LD D,A ; ??
  7750    5F                            LD E,A
  7751    C9                            RET
                                        ;--------
  7752    06 01                 HEXIE:  LD B,01H
  7754    C9                            RET
                                ;-------------------------
                                ;  HEX Ausgabe mit Position
                                ;
  7755    3A 651C               HEXP:   LD A,(CURT)
  7758    F5                            PUSH AF
  7759    3A 651D                       LD A,(CURT+1)
  775C    F5                            PUSH AF
  775D    3A 651E                       LD A,(CURT+2)
  7760    F5                            PUSH AF
  7761    3A 651F                       LD A,(CURT+3)
  7764    F5                            PUSH AF
  7765    C5                            PUSH BC
  7766    01 0150                       LD BC,0150H
  7769    CD 7018                       CALL T8
  776C    4B                            LD C,E
  776D    C5                            PUSH BC
  776E    CD 7792                       CALL HEX00
  7771    C1                            POP BC
  7772    C1                            POP BC
  7773    F1                            POP AF
  7774    32 651F                       LD (CURT+3),A
  7777    F1                            POP AF
  7778    32 651E                       LD (CURT+2),A
  777B    F1                            POP AF
  777C    32 651D                       LD (CURT+1),A
  777F    F1                            POP AF
  7780    32 651C                       LD (CURT),A
  7783    CD 77D3                       CALL CUT
  7786    C9                            RET
                                ;-------------------------
                                ;  Hex ausgeben
  7787    3E 0A                 HEXA:   LD A,0AH
  7789    CD 780A                       CALL HEXC
  778C    3E 0D                         LD A,0DH
  778E    CD 780A                       CALL HEXC
  7791    C9                            RET
                                ;------------------
  7792                          HEX00:  
  7792    DD E5                 HEX14:  PUSH IX
  7794    DD 21 0000                    LD IX,0
  7798    DD 39                         ADD IX,SP
                                ;---------
  779A    F5                            PUSH AF
  779B    C5                            PUSH BC
        MACRO-80 3.43   27-Jul-81       PAGE    1-28


  779C    DD 4E 04                      LD C,(IX+4)             ; Adresse anzeigen
  779F    C5                            PUSH BC
  77A0    CD 7F1C                       CALL ASCII_CODE
  77A3    C1                            POP BC
  77A4    78                            LD A,B
  77A5    CD 780A                       CALL HEXC
  77A8    79                            LD A,C          ; ADRESSE ANZEIGEN
  77A9    CD 780A                       CALL HEXC
  77AC    C1                            POP BC
  77AD    F1                            POP AF
                                ;-----------
  77AE    DD F9                         LD SP,IX
  77B0    DD E1                         POP IX
  77B2    C9                            RET
                                ;------------------------
                                ; Warte schlange
                                
  77B3    C5                    SANDU:  PUSH BC
  77B4    D5                            PUSH DE
  77B5    E5                            PUSH HL
  77B6    3A 6520                       LD A,(SANDB)
  77B9    FE 2F                         CP 2FH  
  77BB    38 06                         JR C,SA1
  77BD    28 08                         JR Z,SA2
  77BF    3E 2D                         LD A,2DH
  77C1    18 06                         JR SA3
  77C3    3E 2F                 SA1:    LD A,2FH
  77C5    18 02                         JR SA3
  77C7    3E 5C                 SA2:    LD A,5CH
  77C9    32 6520               SA3:    LD (SANDB),A
  77CC    CD 780A                       CALL HEXC
  77CF    E1                            POP HL
  77D0    D1                            POP DE
  77D1    C1                            POP BC
  77D2    C9                            RET
                                ;------------------------
                                ; Cursor auf Position setzen
                                ;
  77D3    F5                    CUT:    PUSH AF
  77D4    3E 1B                         LD A,1BH
  77D6    CD 780A                       CALL HEXC
  77D9    3E 5B                         LD A,5BH
  77DB    CD 780A                       CALL HEXC
  77DE    3A 651C                       LD A,(CURT)
  77E1    C6 30                         ADD A,30H
  77E3    CD 780A                       CALL HEXC
  77E6    3A 651D                       LD A,(CURT+1)
  77E9    C6 30                         ADD A,30H
  77EB    CD 780A                       CALL HEXC
  77EE    3E 3B                         LD A,3BH
  77F0    CD 780A                       CALL HEXC
  77F3    3A 651E                       LD A,(CURT+2)
  77F6    C6 30                         ADD A,30H
  77F8    CD 780A                       CALL HEXC
  77FB    3A 651F                       LD A,(CURT+3)
  77FE    C6 30                         ADD A,30H
        MACRO-80 3.43   27-Jul-81       PAGE    1-29


  7800    CD 780A                       CALL HEXC
  7803    3E 48                         LD A,48H
  7805    CD 780A                       CALL HEXC
  7808    F1                            POP AF
  7809    C9                            RET
                                ;------------------------
                                ;  Zeichen Ausgeben
                                ;
  780A    C5                    HEXC:   PUSH BC
  780B    D5                            PUSH DE
  780C    E5                            PUSH HL
  780D    5F                            LD E,A
  780E    F5                            PUSH AF
  780F    0E 02                         LD C,02H
  7811    CD 0005                       CALL 0005H
  7814    F1                            POP AF
  7815    E1                            POP HL
  7816    D1                            POP DE
  7817    C1                            POP BC
  7818    C9                            RET
                                        ;--------------
                                        ; TEXTBLOCK UEBER BIOS AUSGEBEN
                                        ; TEXTBLOCK ADRESSE IN DE
                                        ;
  7819    E5                    HEXB:   PUSH HL
  781A    C5                            PUSH BC
  781B    0E 09                         LD C,09
  781D    CD 0005                       CALL 0005H
  7820    C1                            POP BC
  7821    E1                            POP HL
  7822    C9                            RET
                                        ;--------------
                                        ; Cursor on
  7823    E5                    CON:    PUSH HL
  7824    C5                            PUSH BC
  7825    21 8091                       LD HL,CURON             ; CURSOR ON
  7828    06 06                         LD B,06H
  782A    7E                    CUR02:  LD A,(HL)
  782B    CD 780A                       CALL HEXC
  782E    23                            INC HL
  782F    10 F9                         DJNZ CUR02
  7831    C1                            POP BC
  7832    E1                            POP HL
  7833    C9                            RET
                                        ;--------------
                                        ; Cursor off
  7834    E5                    COFF:   PUSH HL
  7835    C5                            PUSH BC
  7836    21 8097                       LD HL,CUROFF            ; CURSOR OFF
  7839    06 06                         LD B,06D
  783B    7E                    CUR01:  LD A,(HL)
  783C    CD 780A                       CALL HEXC
  783F    23                            INC HL
  7840    10 F9                         DJNZ CUR01
  7842    C1                            POP BC
  7843    E1                            POP HL
        MACRO-80 3.43   27-Jul-81       PAGE    1-30


  7844    C9                            RET
                                ;-----------------------
                                ;  DRIVE ZUGRIFF VORBEREITEN
  7845    DB FF                 WAITRDY:IN A,(IDESTAT)
  7847    CB 77                         BIT 6,A
  7849    28 FA                         JR Z,WAITRDY
  784B    CB 7F                         BIT 7,A
  784D    20 F6                         JR NZ,WAITRDY
  784F    C9                            RET
                                        ;----------
  7850                          WAITDRQ: 
  7850    DB FF                         IN A,(IDESTAT)
  7852    CB 5F                         BIT 3,A
  7854    28 FA                         JR Z,WAITDRQ
  7856    CB 7F                         BIT 7,A
  7858    20 F6                         JR NZ,WAITDRQ
  785A    C9                            RET
                                        ;----------
  785B                          HDD_WAIT:
                                        ;LD B,0
                                        ;DJNZ $
  785B    DB FF                 _WAIT1: IN A,(IDESTAT)
  785D    E6 80                         AND 80H
  785F    20 FA                         JR NZ,_WAIT1
  7861    C9                            RET
                                        ;-------------
  7862                          HDD_INIT:
  7862    3E 02                         LD A,02H
  7864    D3 FF                         OUT (IDECMD),A
  7866    CD 785B                       CALL HDD_WAIT
                                ;-----
  7869    3E F0                         LD A,0F0H
  786B    D3 FE                         OUT (IDESDH),A
  786D    3E 01                         LD A,01H
  786F    D3 FA                         OUT (IDESCNT),A
  7871    3E EF                         LD A,0EFH
  7873    D3 FF                         OUT (IDECMD),A
  7875    CD 785B                       CALL HDD_WAIT
  7878    CD 787C                       CALL HDD_ERROR
  787B    C9                            RET
                                ;---------
  787C                          HDD_ERROR:
  787C    DB FF                         IN A,(IDESTAT)
  787E    4F                            LD C,A
  787F    C5                            PUSH BC
  7880    CD 7792                       CALL HEX00
  7883    C1                            POP BC
  7884    79                            LD A,C
  7885    E6 01                         AND 01H
  7887    C8                            RET Z
  7888    21 82EF                       LD HL,DERR
  788B    06 2F                         LD B,L_DERR
  788D    7E                    ERR1:   LD A,(HL)
  788E    CD 780A                       CALL HEXC
  7891    23                            INC HL
  7892    10 F9                         DJNZ ERR1
        MACRO-80 3.43   27-Jul-81       PAGE    1-31


  7894    C9                            RET
                                ;--------------
  7895                          HDD_INFO:
  7895    CD 785B                       CALL HDD_WAIT
  7898    3E EC                         LD A,0ECH
  789A    D3 FF                         OUT (IDECMD),A
  789C    21 1964                       LD HL,6500
  789F    CD 78A3                       CALL HDD_READ
  78A2    C9                            RET
                                ;-----------
  78A3                          HDD_READ:
  78A3    CD 785B                       CALL HDD_WAIT
  78A6    DB FF                         IN A,(IDESTAT)
  78A8    E6 08                         AND 08H
  78AA    C8                            RET Z
  78AB    DB F8                         IN A,(IDEDAT)
  78AD    77                            LD (HL),A
                                ;       CALL HEXC;!!! TESTAUSGABEN
  78AE    23                            INC HL
  78AF    18 F2                         JR HDD_READ
                                ;-------------
                                ; IDE-FESTPLATTE RESET
  78B1                          IDERES:
  78B1    CD 78B7                       CALL IDERES1
  78B4    C3 785B                       JP HDD_WAIT
                                        ;----------
  78B7    CD 7FF4               IDERES1:CALL EXTERN
  78BA    F5                            PUSH AF         ; PIOA
  78BB    C5                            PUSH BC
  78BC    3E 06                         LD A,06H
  78BE    D3 F6                         OUT (IDEDOR),A
  78C0    06 00                         LD B,0
  78C2    10 FE                         DJNZ $
  78C4    3E 02                         LD A,02H
  78C6    D3 F6                         OUT (IDEDOR),A
  78C8    C1                            POP BC
  78C9    F1                            POP AF
  78CA    D3 1C                         OUT (PIOA),A
  78CC    C9                            RET 
                                ;-------------
  78CD    DD E5                 DISK:   PUSH IX
  78CF    DD 21 0000                    LD IX,0
  78D3    DD 39                         ADD IX,SP
                                ;--------
  78D5    DD 7E 05                      LD A,(IX+5)     ; D= HEAD SELECT, LBA HIGH MIT HIGH=B
  78D8    E6 0F                         AND 0FH         ; HEAD SELECT
  78DA    47                            LD B,A
  78DB    3E F7                         LD A,SELDS      ; IN INCLUDE
  78DD    E6 F0                         AND 0F0H
  78DF    B0                            OR B
  78E0    CB FF                         SET 7,A
  78E2    DD 77 05                      LD (IX+5),A
  78E5    D3 FE                         OUT (IDESDH),A
  78E7    DD 7E 04                      LD A,(IX+4)     ; TRACK HIGH
  78EA    D3 FD                         OUT (IDECHI),A
  78EC    DD 7E 07                      LD A,(IX+7)     ; TRACK LOW
        MACRO-80 3.43   27-Jul-81       PAGE    1-32


  78EF    D3 FC                         OUT (IDECLO),A
  78F1    DD 7E 06                      LD A,(IX+6)     ; C= SECTOR
  78F4    D3 FB                         OUT (IDESNUM),A
  78F6    3E 01                         LD A,01H
  78F8    D3 FA                         OUT (IDESCNT),A
                                        ;----------
  78FA    DD F9                         LD SP,IX
  78FC    DD E1                         POP IX
  78FE    C9                            RET
                                ;-----------------------
                                ; ZEICHEN SUCHEN IM RAM AUS EINGABE RAMT
                                ;
  78FF    08                    SUCH0:  EX AF,AF'               ; Textlaenge retten
  7900    1A                            LD A,(DE)               ; neuer Text mit
  7901    BE                            CP (HL)         ; Blaseninhalt 
  7902    28 0B                         JR Z,SUCH2
  7904    23                            INC HL
  7905    3A 6B27                       LD A,(RAMT)
  7908    11 6B28                       LD DE,RAMT+1
  790B    10 F2                         DJNZ SUCH0
  790D    37                    SUCH1:  SCF
  790E    C9                            RET
                                        ;------------
  790F    13                    SUCH2:  INC DE
  7910    23                            INC HL
  7911    3E 2A                         LD A,2AH
  7913    CD 780A                       CALL HEXC
  7916    08                            EX AF,AF'
  7917    3D                            DEC A
  7918    20 E5                         JR NZ,SUCH0
  791A    7E                            LD A,(HL)               ; Text Ende <30H
  791B    FE 2F                         CP 2FH          ; ENDE < 21H = !
  791D    30 EE                         JR NC,SUCH1     ; -> kein Ende
  791F    AF                            XOR A
  7920    C9                            RET     
                                ;-------------
  7921    C5                    FREI:   PUSH BC
  7922    0E 0B                         LD C,0BH        ; GET CONSILE STATUS
  7924    CD 0005                       CALL 0005H
  7927    C1                            POP BC
  7928    C9                            RET
                                ;-----------------------
                                ; ZEICHEN IN KEYBUFFER SCHREIBEN
                                ; UND MIT CR ENDE
  7929    FE 0D                 KEYB:   CP 0DH
  792B    C8                            RET Z   ;,BL03  ; Ausgang mit CR
  792C    12                            LD (DE),A       ; Zeichen abspeichen
  792D    FE 08                         CP 08H          ; TAB
  792F    20 2F                         JR NZ,BL021     ; NEIN ->
                                        ;-----------------
                                        ; BACKSPACE FUNKTION CURSOR LINKS MIT ZEICHEN LOESCHEN
                                        ;
  7931    7E                            LD A,(HL)       ; Zeichenzaehler
  7932    D6 01                         SUB 01H
  7934    38 19                         JR C,KEYB1
  7936    77                            LD (HL),A       ; Zeichenlaenge -1
        MACRO-80 3.43   27-Jul-81       PAGE    1-33


  7937    3E 20                         LD A,20H
  7939    CD 780A                       CALL HEXC
  793C    04                            INC B
  793D    1B                            DEC DE          ; Zeichen loeschen
                                        ;----------
                                        ; set cursor 1 left
  793E    3E 1B                         LD A,1BH
  7940    CD 780A                       CALL HEXC
  7943    3E 5B                         LD A,5BH
  7945    CD 780A                       CALL HEXC
  7948    3E 44                         LD A,44H
  794A    CD 780A                       CALL HEXC
  794D    AF                            XOR A
  794E    C9                            RET             ; zurueck ohne B dec
                                        ;----------
                                        ; set cursor 1 right
  794F    3E 1B                 KEYB1:  LD A,1BH
  7951    CD 780A                       CALL HEXC
  7954    3E 5B                         LD A,5BH
  7956    CD 780A                       CALL HEXC
  7959    3E 43                         LD A,43H
  795B    CD 780A                       CALL HEXC
  795E    AF                            XOR A
  795F    C9                            RET             ; zurueck ohne B dec
                                        ;-------------------
                                        ; ESC 
                                        ; 
  7960    FE 1B                 BL021:  CP 1BH          ; ESC
  7962    20 5A                         JR NZ,BL022     ; NEIN ->
  7964    7E                            LD A,(HL)
  7965    FE 00                         CP 0H
  7967    20 55                         JR NZ,BL022
  7969    D5                            PUSH DE
  796A    C5                            PUSH BC
  796B    E5                            PUSH HL
  796C    06 A0                 BL120:  LD B,0A0H
  796E    10 FE                         DJNZ $          ; DELAY
  7970    CD 79F8                       CALL KEYST      ; pruefe ob Zeichen da
  7973    FE 00                         CP 0H
  7975    28 42                         JR Z,BL121      ; -> NO
  7977    5F                            LD E,A
  7978    FE 5B                         CP '['
  797A    28 F0                         JR Z,BL120
  797C    3E 44                         LD A,'D'
  797E    BB                            CP E
  797F    38 38                         JR C,BL121
  7981    3E 40                         LD A,'@'
  7983    BB                            CP E
  7984    30 33                         JR NC,BL121
  7986    3E 41                         LD A,'A'
  7988    BB                            CP E
  7989    20 0D                         JR NZ,BL123
  798B    3A 8086                       LD A,(ZEIL)
  798E    3C                            INC A
  798F    FE 07                         CP CURUD
  7991    30 26                         JR NC,BL121
        MACRO-80 3.43   27-Jul-81       PAGE    1-34


  7993    32 8086                       LD (ZEIL),A
  7996    18 21                         JR BL121
                                ;--------------------------     
  7998    3E 42                 BL123:  LD A,'B'
  799A    BB                            CP E
  799B    20 0D                         JR NZ,BL124
                                        ;JR NZ,BL123
  799D    3A 8086                       LD A,(ZEIL)
  79A0    3D                            DEC A
  79A1    FE 01                         CP 01H
  79A3    38 14                         JR C,BL121
  79A5    32 8086                       LD (ZEIL),A
  79A8    18 0F                         JR BL121
                                        ;-------------------
  79AA    3E 43                 BL124:  LD A,'C'
  79AC    BB                            CP E
  79AD    20 02                         JR NZ,BL125
                                ; Cursor right
  79AF    18 08                         JR BL121
                                        ;-----------
  79B1    3E 44                 BL125:  LD A,'D'
  79B3    BB                            CP E
  79B4    20 03                         JR NZ,BL121
                                ; Cursor left
  79B6    18 B4                         JR BL120
  79B8    C9                    BL02X:  RET ;!!JP BL02
                                        ;------------
  79B9    E1                    BL121:  POP HL
  79BA    C1                            POP BC
  79BB    D1                            POP DE
  79BC    AF                            XOR A           ; letzes Zeichen loeschen
  79BD    77                            LD (HL),A       ; Zeichenzaehler loeschen
                                        ;-------------
  79BE    FE 21                 BL022:  CP 21H          ; Zeichen < Space
  79C0    38 02                         JR C,BL023
  79C2    13                            INC DE          ; Zeichenadr. +1
  79C3    34                            INC (HL)        ; Zeichenzaehler erhoehen
  79C4    10 F2                 BL023:  DJNZ BL02X      ; vorgegebene Laenge aus Blase
  79C6    3E 0D                         LD A,0DH        ; LAENGE B ERREICHT ENDE
  79C8    C9                            RET
                                        ;-----------------------------
                                        ; BLASE AUF 512BYTE UMKOPIEREN
                                        ;
  79C9    C5                    MASK1:  PUSH BC
  79CA    D5                            PUSH DE
  79CB    21 6000                       LD HL,RAM       ; Adr. Aktueller Blase
  79CE    01 0200                       LD BC,200H
  79D1    3E 20                 MASK2:  LD A,20H        ; SPACE
  79D3    77                            LD (HL),A
  79D4    23                            INC HL
  79D5    0D                            DEC C
  79D6    20 F9                         JR NZ,MASK2
  79D8    10 F7                         DJNZ MASK2
                                        ;---------
  79DA    21 831E                       LD HL,NBLASE
  79DD    11 6000                       LD DE,RAM
        MACRO-80 3.43   27-Jul-81       PAGE    1-35


  79E0    01 0039                       LD BC,MNBL2
  79E3    ED B0                         LDIR
  79E5    E5                            PUSH HL
  79E6    21 6200                       LD HL,RAM+200H
  79E9    11 006F                       LD DE,FBLOCK
  79EC    ED 52                         SBC HL,DE
  79EE    EB                            EX DE,HL
  79EF    E1                            POP HL
  79F0    01 006F                       LD BC,FBLOCK
  79F3    ED B0                         LDIR
  79F5    D1                            POP DE
  79F6    C1                            POP BC
  79F7    C9                            RET
                                ;-----------------------
                                ; CONSOLE QUERY AND PICK 
                                ; WITHOUT WAITING
                                ; 
  79F8    CD 7EC2               KEYST:  CALL UHR00
  79FB    C5                            PUSH BC
  79FC    0E 0B                         LD C,0BH        ; GET CONSILE STATUS
  79FE    CD 0005                       CALL 0005H
  7A01    FE 00                         CP 0
  7A03    28 05                         JR Z,KEY01
  7A05    0E 01                         LD C,01H        ; console Input read chr
  7A07    CD 0005                       CALL 0005H
  7A0A    C1                    KEY01:  POP BC
  7A0B    C9                            RET 
                                ;-----------------------
                                ; LBA Z[HLER HERH\HE BID HDDE ENDE
                                ;
  7A0C    DD E5                 LBA0:   PUSH IX
  7A0E    DD 21 0000                    LD IX,0
  7A12    DD 39                         ADD IX,SP
                                ;--------
  7A14    DD 4E 06                      LD C,(IX+6)     ; LBA LOW SECTOR
  7A17    DD 46 07                      LD B,(IX+7)
  7A1A    0C                            INC C
  7A1B    DD 71 06                      LD (IX+6),C
  7A1E    20 35                         JR NZ,LBA20
  7A20    04                            INC B
  7A21    DD 70 07                      LD (IX+7),B
  7A24    20 2F                         JR NZ,LBA20
  7A26    DD 4E 04                      LD C,(IX+4)     ; LBA TRACK 
  7A29    DD 46 05                      LD B,(IX+5)
  7A2C    03                            INC BC
  7A2D    DD 71 04                      LD (IX+4),C     ; LBA TRACK
  7A30    DD 70 05                      LD (IX+5),B
  7A33    AF                            XOR A           ; RES CARRY FLAG
  7A34    21 00BE                       LD HL,HDDE      ; DISK ENDE
  7A37    ED 42                         SBC HL,BC       ; -C
  7A39    30 1A                         JR NC,LBA20     
  7A3B    01 0801                       LD BC,HDD+1
  7A3E    DD 71 06                      LD (IX+6),C
  7A41    DD 70 07                      LD (IX+7),B
  7A44    01 0000                       LD BC,0
  7A47    DD 71 04                      LD (IX+4),C
        MACRO-80 3.43   27-Jul-81       PAGE    1-36


  7A4A    DD 70 05                      LD (IX+5),B
  7A4D    C3 0000                       JP 0;!!!!
  7A50    18 03                         JR LBA20
                                        ; ENDE ERREICHT
  7A52    37                    LBA4:   SCF             ;AUSGANG FEHLER
  7A53    18 01                         JR LBA21
                                ;-----------
  7A55    AF                    LBA20:  XOR A           ; SET CARRY -> OHNE FEHLER
  7A56    DD F9                 LBA21:  LD SP,IX
  7A58    DD E1                         POP IX
  7A5A    C9                            RET
                                ;-----------------
                                ; ADRESSE -1
  7A5B    C3 0000               LBA5:   JP 0;!!!
  7A5E    DD E5                 PUSH IX
  7A60    DD 21 0000                    LD IX,0
  7A64    DD 39                         ADD IX,SP
                                ;------
  7A66    DD 46 07                      LD B,(IX+7)     ; LBA 
  7A69    DD 4E 06                      LD C,(IX+6)     ; LOW
  7A6C    0B                            DEC BC
  7A6D    78                            LD A,B
  7A6E    E6 F0                         AND 0F0H
  7A70    28 23                         JR Z,L__6
  7A72    06 0F                         LD B,0FH
  7A74    DD 70 07                      LD (IX+7),B     ; LBA 
  7A77    DD 71 06                      LD (IX+6),C     ; LOW
  7A7A    DD 46 05                      LD B,(IX+5)     ; LBA HIGH
  7A7D    DD 4E 04                      LD C,(IX+4)     ; LOW
  7A80    0B                            DEC BC
  7A81    E5                            PUSH HL
  7A82    AF                            XOR A
  7A83    21 0800                       LD HL,HDD
  7A86    ED 42                         SBC HL,BC
  7A88    E1                            POP HL
  7A89    38 02                         JR C,L__7
  7A8B    18 C5                         JR LBA4
                                        ;-----------
  7A8D    DD 70 05              L__7:   LD (IX+5),B
  7A90    DD 71 04                      LD (IX+4),C
  7A93    18 C0                         JR LBA20
                                        ;_-------
  7A95    DD 70 07              L__6:   LD (IX+7),B     ; LBA HIGH
  7A98    DD 71 06                      LD (IX+6),C     ; LOW
  7A9B    18 B8                         JR LBA20
                                
  7A9D    DD 46 05                      LD B,(IX+5)     ; LBA HIGH
  7AA0    DD 4E 04                      LD C,(IX+4)     ; LOW
  7AA3    0B                            DEC BC
  7AA4    DD 70 05                      LD (IX+5),B
  7AA7    DD 71 04                      LD (IX+4),C
  7AAA    18 A9                         JR LBA20
                                        ; --------------------
                                        ; aktuelle Blasenadresse
                                ;------------------------
                                ; Cursor auf Position setzen
        MACRO-80 3.43   27-Jul-81       PAGE    1-37


                                
  7AAC    F5                    RLIST:  PUSH AF
  7AAD    3A 6518                       LD A,(CURS)
  7AB0    32 651C                       LD (CURT),A
  7AB3    3A 6519                       LD A,(CURS+1)
  7AB6    32 651D                       LD (CURT+1),A
  7AB9    3A 651A                       LD A,(CURS+2)
  7ABC    32 651E                       LD (CURT+2),A
  7ABF    3A 651B                       LD A,(CURS+3)
  7AC2    32 651F                       LD (CURT+3),A
  7AC5    CD 77D3                       CALL CUT
  7AC8    F1                            POP AF
  7AC9    C9                            RET
                                        ;------------
                                        ; CURSER POS SAVE
  7ACA    F5                    WLIST:  PUSH AF
  7ACB    3A 651C                       LD A,(CURT)
  7ACE    32 6518                       LD (CURS),A
  7AD1    3A 651D                       LD A,(CURT+1)
  7AD4    32 6519                       LD (CURS+1),A
  7AD7    3A 651E                       LD A,(CURT+2)
  7ADA    32 651A                       LD (CURS+2),A
  7ADD    3A 651F                       LD A,(CURT+3)
  7AE0    32 651B                       LD (CURS+3),A
  7AE3    F1                            POP AF
                                        ;------------
  7AE4    F5                    LIST:   PUSH AF
  7AE5    78                            LD A,B
  7AE6    E6 F0                         AND 0F0H
  7AE8    0F                            RRCA
  7AE9    0F                            RRCA
  7AEA    0F                            RRCA
  7AEB    0F                            RRCA
  7AEC    32 651C                       LD (CURT),A
  7AEF    78                            LD A,B
  7AF0    E6 0F                         AND 0FH
  7AF2    32 651D                       LD (CURT+1),a
  7AF5    79                            LD A,C
  7AF6    E6 F0                         AND 0F0H
  7AF8    0F                            RRCA
  7AF9    0F                            RRCA
  7AFA    0F                            RRCA
  7AFB    0F                            RRCA
  7AFC    32 651E                       LD (CURT+2),A
  7AFF    79                            LD A,C
  7B00    E6 0F                         AND 0FH
  7B02    32 651F                       LD (CURT+3),A
  7B05    CD 77D3                       CALL CUT
  7B08    F1                            POP AF
  7B09    C9                            RET
                                        ;-------------
                                        ; ZUM TEST (HL)+1  30MAL AUSGEBEN
                                        ;
  7B0A    06 1E                 LIS0:   LD B,30D
  7B0C    7E                    LIS1:   LD A,(HL)
  7B0D    4F                            LD C,A
        MACRO-80 3.43   27-Jul-81       PAGE    1-38


  7B0E    C5                            PUSH BC
  7B0F    CD 7792                       CALL HEX00
  7B12    C1                            POP BC
  7B13    23                            INC HL
  7B14    10 F6                         DJNZ LIS1
  7B16    C9                            RET
                                ;---------------------------
                                ;  Kontrollausgabe rechts
                                ;
  7B17    CD 7834               TAS:    CALL COFF
  7B1A    ED 73 651C                    LD (CURT),SP
  7B1E    C5                            PUSH BC
  7B1F    01 2273                       LD BC,2273H
  7B22    CD 7018                       CALL T8         ;CURSOR POS
  7B25    C1                            POP BC
  7B26    3A 650F                       LD A,(BFSHH)
  7B29    4F                            LD C,A
  7B2A    C5                            PUSH BC
  7B2B    CD 7792                       CALL HEX00      ; ADRESSE DER AKTUEL GELESENEN BLASE
  7B2E    C1                            POP BC
  7B2F    3A 650E                       LD A,(BFSHL)
  7B32    4F                            LD C,A
  7B33    C5                            PUSH BC
  7B34    CD 7792                       CALL HEX00
  7B37    C1                            POP BC
  7B38    3A 650D                       LD A,(BFSLH)
  7B3B    4F                            LD C,A
  7B3C    C5                            PUSH BC
  7B3D    CD 7792                       CALL HEX00
  7B40    C1                            POP BC
  7B41    3A 650C                       LD A,(BFSLL)
  7B44    4F                            LD C,A
  7B45    C5                            PUSH BC
  7B46    CD 7792                       CALL HEX00
  7B49    C1                            POP BC
                                        ; --------------------
                                        ; aktuelle Blasenadresse
  7B4A    C5                            PUSH BC
  7B4B    01 2173                       LD BC,2173H
  7B4E    CD 7018                       CALL T8         ;CURSOR POS
  7B51    C1                            POP BC
  7B52    3A 8074                       LD A,(BF07+3) ;(BFRHH)
  7B55    4F                            LD C,A
  7B56    C5                            PUSH BC
  7B57    CD 7792                       CALL HEX00
  7B5A    C1                            POP BC
  7B5B    3A 8073                       LD A,(BF07+2)  ;(BFRHL)
  7B5E    4F                            LD C,A
  7B5F    C5                            PUSH BC
  7B60    CD 7792                       CALL HEX00
  7B63    C1                            POP BC
  7B64    3A 8072                       LD A,(BF07+1)  ;(BFRLH)
  7B67    4F                            LD C,A
  7B68    C5                            PUSH BC
  7B69    CD 7792                       CALL HEX00
  7B6C    C1                            POP BC
        MACRO-80 3.43   27-Jul-81       PAGE    1-39


  7B6D    3A 8071                       LD A,(BF07) ;(BFRLL)
  7B70    4F                            LD C,A
  7B71    C5                            PUSH BC
  7B72    CD 7792                       CALL HEX00
  7B75    C1                            POP BC
                                        ;---------------------
                                        ; CURSOR IN EINGABEZEILE MIT EINGABE SCHIEBEN
  7B76    3E 02                 TAS00:  LD A,02H
  7B78    32 651C                       LD (CURT),A
  7B7B    3E 04                         LD A,04H
  7B7D    32 651D                       LD (CURT+1),A
  7B80    3E 01                         LD A,01H
  7B82    32 651E                       LD (CURT+2),A
  7B85    3A 6B27                       LD A,(RAMT)
  7B88    FE 0A                         CP 0AH
  7B8A    38 0E                         JR C,RD07       ; < 0AH ->
  7B8C    D6 0A                         SUB 0AH
  7B8E    32 651F                       LD (CURT+3),A
  7B91    3A 651E                       LD A,(CURT+2)
  7B94    3C                            INC A
  7B95    32 651E                       LD (CURT+2),A
  7B98    18 03                         JR RD08
  7B9A    32 651F               RD07:   LD (CURT+3),A
  7B9D    CD 77D3               RD08:   CALL CUT
  7BA0    06 14                         LD B,20D
  7BA2    21 6728                       LD HL,RAMS+RUSER
  7BA5    CD 77D3               RD09:   CALL CUT
  7BA8    CD 7823                       CALL CON
                                ;-----------------------
                                ; Tastenabfrage und Zeichen einlesen
                                ; Sonst weitere Task ausfueren
                                ;
                                ; LBA ZAEHLER +1
                                ;
  7BAB    ED 5B 650C                    LD DE,(BFSLL)   ; Aktuelle Track/Sectoradresse laden
  7BAF    ED 53 6C43                    LD (COP+4),DE   ; STARTPUNKT NACH SPEICHERN
  7BB3    D5                            PUSH DE
  7BB4    2A 650E                       LD HL,(BFSHL)
  7BB7    22 6C45                       LD (COP+6),HL
  7BBA    E5                            PUSH HL
  7BBB    CD 7A0C                       CALL LBA0       ; LBA + 1
  7BBE    E1                            POP HL
  7BBF    22 650E                       LD (BFSHL),HL   ; adresse HIGH speichern
  7BC2    D1                            POP DE
  7BC3    ED 53 650C                    LD (BFSLL),DE   ; adresse LOW speichern
  7BC7    DA 0000                       JP C,0 ;NOCH ENDE BEI FEHLER RD91               ; RUECKGABE CARRY 0=FEHLER
                                        ;---------------- 
                                        ; 1. BLASE + 1 = 2.BLASE
  7BCA    D5                            PUSH DE         ; IX UEBERGABE
  7BCB    E5                            PUSH HL         ; IX UEBERGEBE
  7BCC    CD 7A0C                       CALL LBA0       ; LBA + 1
  7BCF    E1                            POP HL
  7BD0    22 6512                       LD (BFSHL+4),HL ; adresse HIGH speichern
  7BD3    D1                            POP DE
  7BD4    ED 53 6510                    LD (BFSLL+4),DE ; adresse LOW speichern
  7BD8    DA 0000                       JP C,0 ;NOCH ENDE BEI FEHLER RD91               ; RUECKGABE CARRY 0=FEHLER
        MACRO-80 3.43   27-Jul-81       PAGE    1-40


  7BDB    CD 7921                       CALL FREI       ; TAST INT FREI
                                        ;---------------------
                                        ; Erste Blase laden
  7BDE    ED 4B 650C                    LD BC,(BFSLL)
  7BE2    ED 5B 650E                    LD DE,(BFSHL)
  7BE6    21 6727                       LD HL,RAMS
  7BE9    CD 7DFA                       CALL RDREAD     ; BFSLL BLASE LADEN
  7BEC    CD 7921                       CALL FREI
                                        ; READ SICHTBAR MACHEN
                                        ;LD BC,1001H
                                        ;CALL T8
                                        ;LD HL,RAMS
                                        ;CALL LIS0
                                        ;------
  7BEF    3A 672E                       LD A,(RAMS+RSOTR)
  7BF2    FE 1B                         CP 1BH
  7BF4    28 0E                         JR Z,TAS03
  7BF6    21 831E                       LD HL,NBLASE
  7BF9    11 6727                       LD DE,RAMS
  7BFC    01 0101                       LD BC,NBLLE
  7BFF    ED B0                         LDIR
                                        ; READ SICHTBAR MACHEN
                                        ;LD BC,1101H
                                        ;CALL T8
                                        ;LD HL,RAMS
                                        ;CALL LIS0
  7C01    C3 7CDA                       JP RD170
                                        ;-------------------
                                        ; Zweite Blase laden
  7C04    ED 4B 6510            TAS03:  LD BC,(BFSLL+4)
  7C08    ED 5B 6512                    LD DE,(BFSHL+4)
  7C0C    21 6927                       LD HL,RAMS+200H
  7C0F    CD 7DFA                       CALL RDREAD     ; BFSLL BLASE LADEN
  7C12    CD 7921                       CALL FREI
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
  7C15    21 6928                       LD      HL,RAMS+RUSER+200H      ;BLASE2 RAM
  7C18    11 6728                       LD      DE,RAMS+RUSER           ;BLASE1 RAM
  7C1B    1A                            LD      A,(DE)          ; USER vergleich
  7C1C    BE                            CP      (HL)            ; Blase2 > Blase1 dann
  7C1D    DA 7C8C                       JP      C,RD06          ; zum naechstem >USER 2  neu anfangen
        MACRO-80 3.43   27-Jul-81       PAGE    1-41


  7C20    C2 7CF0                       JP      NZ,RD01         ; Blase2 < Blase1 tauschen ->
                                ;----------------------
                                ; Blasen der groesse nach Sortieren
                                ; TYPE1, AUFSTEIGEND
                                ; wenn T1 > T1+1 (DE)-(HL) =NC,dann tauschen
                                ; wenn T1 = T1+1 (DE)-(HL) =Z,dann TYPE2 
                                ; wenn T1 < T1+1 (DE)-(HL) =NZ,dann GEDAECHTNIS
                                ;
  7C23    21 692A                       LD      HL,RAMS+RTYPE1+200H     ; Blase2
  7C26    11 672A                       LD      DE,RAMS+RTYPE1          ; Blase1
  7C29    1A                            LD      A,(DE)                  ; TYPE1 Vergleich
  7C2A    BE                            CP      (HL)                    ; Blase2 > Blase1 dann
  7C2B    DA 7C8C                       JP      C,RD06                  ; zum Gedaechtnis zuruecksetzen 
  7C2E    C2 7CF0                       JP      NZ,RD01                 ; tauschen und Speichern 
                                ;       JP RD02 ;!!!!!TEST
                                ;----------------------
                                ; Blasen der groesse nach Sortieren
                                ; TYPE2 AUFSTEIGEND
                                ; wenn T2 > T2+1 (DE)-(HL) =NC,dann tauschen
                                ; wenn T2 = T2+1 (DE)-(HL) = Z,dann gedaechtniss-1
                                ; wenn T2 < T2+1 (DE)-(HL) =NZ,dann weiter
                                ;
  7C31    21 692B               RD25:   LD HL,RAMS+RTYPE2+200H  ; Blase2
  7C34    11 672B                       LD DE,RAMS+RTYPE2       ; Blase1
  7C37    1A                            LD A,(DE)
  7C38    FE 01                         CP 01H                  ; RAM+TYPE2 > 0
  7C3A    20 09                         JR NZ,RD255             ; TYPE2 BEREITS 1=FORNE JA ->
  7C3C    BE                            CP (HL)
                                ;??     CALL C,TASK     ; NOCH AUSARBEITEN
  7C3D    3A 692D                       LD A,(RAMS+RBSTAT+200H)
  7C40    E6 07                         AND 07H
  7C42    CA 7CF0                       JP Z,RD01               ; BLASE 2 SPEICHERN MIT TAUSCHEN
  7C45    1A                    RD255:  LD A,(DE)
  7C46    BE                            CP (HL)                 ; Blase2 > Blase1 dann
  7C47    38 06                         JR C,RD26
  7C49    CA 7C6F                       JP Z,RD36               ; ZUM GEDAECHTNIS
  7C4C    D2 7CF0                       JP NC,RD01              ; TAUSCHEN
                                        ;----------------------
  7C4F    1A                    RD26:   LD A,(DE)               ; BLASE1 TYPE2 Vergleich
  7C50    FE 00                         CP 0H
  7C52    C2 7C8C                       JP NZ,RD06              ; zum Gedaechtnisszaehler
                                        ;----------------------
                                        ; GED[CHTNISS BLASE1 TYPE2=0 MIT BLASE2 TYPE2>0 VERGLEICHEN
                                         
  7C55    21 672C                       LD HL,RAMS+RTERM                ; Blase1
  7C58    11 692C                       LD DE,RAMS+RTERM+200H   ; Blase2
  7C5B    1A                            LD A,(DE)                       ; Gedaechtnissz Vergleich
  7C5C    BE                            CP (HL)
  7C5D    38 2D                         JR C,RD06                       ; 1>2 GEDAECHTNISS FALLEND
  7C5F    3C                            INC A
  7C60    20 01                         JR NZ,RD250
  7C62    1A                            LD A,(DE)
  7C63    77                    RD250:  LD (HL),A
  7C64    ED 4B 650C                    LD BC,(BFSLL)
  7C68    ED 5B 650E                    LD DE,(BFSHL)           ; Suchadresse 2. BLASE speichern
  7C6C    C3 7D5D                       JP RD03
        MACRO-80 3.43   27-Jul-81       PAGE    1-42


                                        ;----------------------
                                        ; Blasen der groesse nach Sortieren
                                        ; GEDAECHTNIS FALLEND
  7C6F    7E                    RD36:   LD A,(HL)
  7C70    FE 00                         CP 0
  7C72    20 0D                         JR NZ,RD35
  7C74    3A 672D                       LD A,(RAMS+RBSTAT)
  7C77    E6 78                         AND 78H
  7C79    F6 47                         OR 47H
  7C7B    32 672D                       LD (RAMS+RBSTAT),A
  7C7E    C3 7C4F                       JP RD26 
                                        ;---------------------
  7C81    21 692C               RD35:   LD HL,RAMS+RTERM+200H   ; Blase2
  7C84    11 672C                       LD DE,RAMS+RTERM        ; Blase1
  7C87    1A                            LD A,(DE)               ; Gedaechtnissz Vergleich
  7C88    BE                            CP (HL)
  7C89    DA 7CF0                       JP C,RD01               ; tauschen und Speichern fallend
                                        ;---------------------
                                        ; Gedaechtniss zuruecksetzen wenn MONAT ungleich ist
                                
  7C8C    CD 7921               RD06:   CALL FREI
  7C8F    3A 807E                       LD A,(DAYM)             ; MONAT AUS UHR
  7C92    E6 1F                         AND 1FH
  7C94    47                            LD B,A
  7C95    3A 672D                       LD A,(RAMS+RBSTAT)      ; MONAT AUS BLASE1
  7C98    E6 1F                         AND 1FH
  7C9A    B8                            CP B
  7C9B    C2 7CA8                       JP NZ,RDD1              ; NICHT GLEICH ->
  7C9E    3A 672D                       LD A,(RAMS+RBSTAT)      ; MONAT AUS BLASE1
  7CA1    CB 77                         BIT 6,A                 ; PRUEFE SORTIEREN 
  7CA3    20 03                         JR NZ,RDD1              ; SPEICHERN ->
  7CA5    C3 7DAC                       JP RD02                 ; GLEICH nicht speichern gleicher MONAT
                                        ;------------------
                                        ; NEUER MONAT UND GEDAECHTNIS SPEICHERN
  7CA8    3A 672D               RDD1:   LD A,(RAMS+RBSTAT)      ; BLASE 1
  7CAB    E6 E0                         AND 0E0H
  7CAD    B0                            OR B            ; neuer MONAT einbinden 
  7CAE    CB B7                         RES 6,A         ; Zaehler aktivieren
  7CB0    CB 7F                         BIT 7,A         ; Blase benutzt fuer +/-
  7CB2    28 11                         JR Z,RD16       ; Gedaechtniss abziehen =0
  7CB4    CB BF                         RES 7,A         ; =1 ADDIEREN loesche
  7CB6    32 672D                       LD (RAMS+RBSTAT),A      ; wieder zurueck in Blase1
  7CB9    3A 672C                       LD A,(RAMS+RTERM)       ; GEDAECHTNISSZAEHLER AUS RAM
  7CBC    3C                            INC A                   ; Gedaechtniss +1
  7CBD    CA 7CDA                       JP Z,RD170              ; Ausgang WENN MAX ERREICHT
  7CC0    32 672C                       LD (RAMS+RTERM),A       ; ZURUECK IN RAM
  7CC3    18 0D                         JR RD17
                                        ;--------------
  7CC5    32 672D               RD16:   LD (RAMS+RBSTAT),A      ; MONAT SPEICHERN
  7CC8    3A 672C                       LD A,(RAMS+RTERM)
  7CCB    D6 01                         SUB 01H                 ; Gedaechtniss schon Min
  7CCD    38 16                         JR C,RD171              ; Ausgang WENN MIN ERREICHT
  7CCF    32 672C                       LD (RAMS+RTERM),A       ; ZURUECK IN RAM
  7CD2    3A 6206               RD17:   LD A,(BSTAT)
  7CD5    CB B7                         RES 6,A                 ; Sortieren aktivieren aller Blasen
  7CD7    32 6206                       LD (BSTAT),A
        MACRO-80 3.43   27-Jul-81       PAGE    1-43


  7CDA    ED 5B 650E            RD170:  LD DE,(BFSHL)           ; Suchadresse speichern
  7CDE    ED 4B 650C                    LD BC,(BFSLL)
  7CE2    C3 7D5D                       JP RD03                 ; nur Blase1 ohne tauschen speicher
                                        ;------------------
  7CE5    3A 6728               RD171:  LD A,(RAMS+RUSER)
  7CE8    3C                            INC A
  7CE9    28 EF                         JR Z,RD170
  7CEB    32 6728                       LD (RAMS+RUSER),A       ; User =FFH damit Blase wieder an Schluss wandert
  7CEE    18 EA                         JR RD170
                                        ;-----------------------
                                        ; Zweite Blase mit Erster Blase beim Speichern tauschen
  7CF0    ED 4B 650C            RD01:   LD BC,(BFSLL)
  7CF4    ED 5B 650E                    LD DE,(BFSHL)   ; Suchadresse 1.Blase speichern
  7CF8    21 6927                       LD HL,RAMS+200H         ; MIT WERT AUS 2.BLASE SPEICHERN
  7CFB    CD 7E23                       CALL RDWRITE
                                        ;------
                                        ; WRITE SICHTBAR MACHEN
                                        ;LD BC,1401H
                                        ;CALL T8
                                        ;LD HL,RAMS+200H
                                        ;CALL LIS0
                                        ;--------
  7CFE    3A 6206                       LD A,(BSTAT)
  7D01    CB B7                         RES 6,A         ; SORTIEREN START
  7D03    32 6206                       LD (BSTAT),A
                                        ;-------------------
                                        ; pruefe ob AKTUELLE ZAEHLER ALS 1. Blase offen ist
  7D06    AF                            XOR A           ; RES CARRY FLAG
  7D07    ED 5B 650E                    LD DE,(BFSHL)   ; ADRESSE HIGH
  7D0B    2A 6502                       LD HL,(BFRHL)   ; AKTUELL SICHTBARE BLASE
  7D0E    ED 52                         SBC HL,DE       ;-C
  7D10    20 1D                         JR NZ,TAS22     ; BLASE H SORTIEREN UND OFFEN NICHT GLEICH ->
  7D12    AF                            XOR A           ; RES CARRY FAG
  7D13    ED 5B 650C                    LD DE,(BFSLL)   ; ADRESSE LOW
  7D17    2A 6500                       LD HL,(BFRLL)
  7D1A    ED 52                         SBC HL,DE       ;-C
  7D1C    20 11                         JR NZ,TAS22
                                        ;-------------------
                                        ; DANN ADRESSE AKTUELLER BLASE AUCH TAUSCHEN
                                        ; SICHTBARE BLASE VERSCHIEBEN
  7D1E    ED 5B 6510                    LD DE,(BFSLL+4)
  7D22    2A 6512                       LD HL,(BFSHL+4)
  7D25    22 6502                       LD (BFRHL),HL
  7D28    ED 53 6500                    LD (BFRLL),DE
  7D2C    C3 7D55                       JP TAS24
                                        ;-------------------
                                        ; pruefe ob AKTUELLE ZAEHLER ALS 1. Blase offen ist
  7D2F    AF                    TAS22:  XOR A           ; RES CARRY FLAG
  7D30    ED 5B 6512                    LD DE,(BFSHL+4) ; Aktuelle Track/Sectoradresse laden
  7D34    2A 6502                       LD HL,(BFRHL)
  7D37    ED 52                         SBC HL,DE       ; -C
  7D39    20 1A                         JR NZ,TAS24     ; BLASE H SORTIEREN UND OFFEN NICHT GLEICH ->
  7D3B    AF                            XOR A           ; RES CARRY FLAG
  7D3C    ED 5B 6510                    LD DE,(BFSLL+4) ; Aktuelle Track/Sectoradresse laden
  7D40    2A 6500                       LD HL,(BFRLL)
  7D43    ED 52                         SBC HL,DE       ; -C
        MACRO-80 3.43   27-Jul-81       PAGE    1-44


  7D45    20 0E                         JR NZ,TAS24
                                        ;-----------------
                                        ; AKTUELLE BLASE TAUSCHEN H->L
  7D47    ED 5B 650C                    LD DE,(BFSLL)
  7D4B    2A 650E                       LD HL,(BFSHL)
  7D4E    ED 53 6500                    LD (BFRLL),DE
  7D52    22 6502                       LD (BFRHL),HL
                                        ;-----------------------
                                        ; Erste Blase mit zweiter Blase beim Speichern tauschen
  7D55    ED 4B 6510            TAS24:  LD BC,(BFSLL+4)
  7D59    ED 5B 6512                    LD DE,(BFSHL+4) ; Suchadresse 2. BLASE speichern
  7D5D    21 6727               RD03:   LD HL,RAMS
  7D60    CD 7E23                       CALL RDWRITE
                                        ;------
                                        ; WRITE SICHTBAR MACHEN
                                        ;LD BC,1601H
                                        ;CALL T8
                                        ;LD HL,RAMS+200H
                                        ;CALL LIS0
                                        ;--------
  7D63    3A 6206                       LD A,(BSTAT)
  7D66    CB 77                         BIT 6,A
  7D68    20 42                         JR NZ,RD02
  7D6A    CB F7                         SET 6,A         ; STOP/START
  7D6C    32 6206                       LD (BSTAT),A
                                        ;----------------------
                                        ; nach letztem Blase speichern Sortieradresse > letzter Blase Adr. 
                                        ; dann neu Adr. speichern und bei HDD-neu Anfangsadr. beginnen
  7D6F    AF                            XOR A           ; RES CARRY FLAG
  7D70    2A 8073                       LD HL,(BF07+2)
  7D73    ED 5B 650E                    LD DE,(BFSHL)   ; LETZTE Suchadresse speichern
  7D77    ED 52                         SBC HL,DE       ; -C
  7D79    30 17                         JR NC,RD30
  7D7B    ED 53 8073                    LD (BF07+2),DE  ; SPEICHE WENN HL<DE
  7D7F    ED 4B 650C                    LD BC,(BFSLL)
  7D83    ED 43 8071                    LD (BF07),BC
  7D87    ED 5B 650C                    LD DE,(BFSLL)
  7D8B    ED 4B 650E                    LD BC,(BFSHL)
  7D8F    C3 7DC0                       JP RD90 
                                        ;---------------
  7D92    ED 5B 650C            RD30:   LD DE,(BFSLL)
  7D96    ED 4B 650E                    LD BC,(BFSHL)
  7D9A    C2 7DED                       JP NZ,RD92
  7D9D    AF                            XOR A           ; RES CARRY FLAG
  7D9E    2A 8071                       LD HL,(BF07)
  7DA1    ED 52                         SBC HL,DE       ; -C
  7DA3    30 07                         JR NC,RD02
  7DA5    ED 53 8071                    LD (BF07),DE
  7DA9    C3 7DC0                       JP RD90         ; NACH sPEICHERN BLASE VON NULL NEUSTART
                                ;-----------
  7DAC                          RD02:   ;------
                                        ; READ SICHTBAR MACHEN
                                        ;LD BC,0501H
                                        ;CALL T8
                                        ;LD HL,RAMS
                                        ;CALL LIS0
        MACRO-80 3.43   27-Jul-81       PAGE    1-45


  7DAC    CD 7921                       CALL FREI
  7DAF    ED 5B 650E                    LD DE,(BFSHL)           ; LETZTE SUCHADRESSE SPEICHERN
                                        ; LD (BF07+4),DE
  7DB3    ED 4B 650C                    LD BC,(BFSLL)
                                        ; LD (BF07+6),BC
                                        ;ACHTUNG SECTOR 8/16 LD (BF07),BC
                                        ;---------------------
                                        ; Tastenabfrage und Zeichen einlesen
  7DB7    CD 79F8                       CALL KEYST
  7DBA    FE 00                         CP 0H
  7DBC    CA 7B17                       JP Z,TAS        ;TAS00
  7DBF    C9                            RET                     ; RETURN ZU BL ENDE
                                
                                ;---------------------
                                ; RD90 AUSGABE UEBERSPRINGEN
                                ; SUCHADRESSE
                                ;
  7DC0    E5                    RD90:   PUSH HL
  7DC1    D5                            PUSH DE
  7DC2    C5                            PUSH BC
  7DC3    ED 5B 650C                    LD DE,(BFSLL)
  7DC7    ED 4B 650E                    LD BC,(BFSHL)
  7DCB    CB 38                         SRL B
  7DCD    CB 19                         RR C
  7DCF    CB 1A                         RR D
  7DD1    CB 1B                         RR E
  7DD3    AF                            XOR A           ; RES CARRY FLAG
  7DD4    21 0000                       LD HL,0000H
  7DD7    ED 42                         SBC HL,BC       ; -C HIGH
  7DD9    20 12                         JR NZ,RD92      ; BC >0 ->
  7DDB    21 0800                       LD HL,HDD
  7DDE    ED 52                         SBC HL,DE
  7DE0    30 05                         JR NC,RD911
  7DE2    18 09                         JR RD92
                                ;----------------------
                                ; RESET TO HDD START
                                ; 
  7DE4    E5                    RD91:   PUSH HL
  7DE5    D5                            PUSH DE
  7DE6    C5                            PUSH BC
  7DE7    11 0801               RD911:  LD DE,HDD+1
  7DEA    01 0000                       LD BC,0
  7DED    ED 53 650C            RD92:   LD (BFSLL),DE
  7DF1    ED 43 650E                    LD (BFSHL),BC
  7DF5    C1                            POP BC
  7DF6    D1                            POP DE
  7DF7    E1                            POP HL
  7DF8    18 B2                         JR RD02
                                ;------------------------
                                ; READ SECTOR VON HDD
                                ;
  7DFA    DD E5                 RDREAD: PUSH IX
  7DFC    DD 21 0000                    LD IX,0
  7E00    DD 39                         ADD IX,SP
                                        ;----------------
  7E02    CD 7FF4                       CALL EXTERN
        MACRO-80 3.43   27-Jul-81       PAGE    1-46


  7E05    F5                            PUSH AF         ; PIOA RESCUE
                                        ;----------------
  7E06    E5                            PUSH HL         ; DMA
  7E07    C5                            PUSH BC         ; DISK SEL
  7E08    D5                            PUSH DE         ; DISK SEL
  7E09    CD 78CD                       CALL DISK
  7E0C    D1                            POP DE
  7E0D    3E 20                         LD A,CMD_READSEC
  7E0F    D3 FF                         OUT (IDECMD),A
  7E11    7A                            LD A,D
  7E12    D3 FE                         OUT (IDESDH),A
  7E14    CD 7850                       CALL WAITDRQ
  7E17    C1                            POP BC
  7E18    E1                            POP HL
  7E19    06 00                         LD B,00H
  7E1B    0E F8                         LD C,IDEDAT
  7E1D    ED B2                         INIR
  7E1F    ED B2                         INIR
  7E21    18 24                         JR HDIST
                                ;----------------------
                                ; BLASE TO SAVE DE=HIGH, BC=LOW
                                ;
  7E23                          RDWRITE:
  7E23    DD E5                         PUSH IX
  7E25    DD 21 0000                    LD IX,0
  7E29    DD 39                         ADD IX,SP
                                        ;----------------
  7E2B    CD 7FF4                       CALL EXTERN
  7E2E    F5                            PUSH AF         ; PIOA RESCUE
                                        ;----------------
  7E2F    E5                            PUSH HL         ; DMA
  7E30    C5                            PUSH BC         ; DISK SEL
  7E31    D5                            PUSH DE         ; DISK SEL
  7E32    CD 78CD                       CALL DISK
  7E35    D1                            POP DE
  7E36    C1                            POP BC
  7E37    3E 30                         LD A,CMD_WRITESEC
  7E39    D3 FF                         OUT (IDECMD),A
  7E3B    CD 7850                       CALL WAITDRQ
  7E3E    E1                            POP HL          ; DMA ZURUECK
  7E3F    06 00                         LD B,00H
  7E41    0E F8                         LD C,IDEDAT
  7E43    ED B3                         OTIR
  7E45    ED B3                         OTIR
                                        ;----------------
  7E47    F1                    HDIST:  POP AF
  7E48    D3 1C                         OUT (PIOA),A    ; PIOA BACK UP
  7E4A    DD F9                         LD SP,IX
  7E4C    DD E1                         POP IX
  7E4E    C9                            RET
                                ;---------------------
                                ; TASK zum Programm Starten
                                ; auf Adr. 100H
                                
  7E4F                          TASK:   ;PUSH   AF
  7E4F    C5                            PUSH    BC
        MACRO-80 3.43   27-Jul-81       PAGE    1-47


  7E50    D5                            PUSH    DE
  7E51    E5                            PUSH    HL
  7E52    3A 6928                       LD      A,(RAMS+RUSER+200H)
  7E55    FE FF                         CP      0FFH
  7E57    30 41                         JR      NC,TASK99       ; USER = FFH nicht auswerten
  7E59    7E                            LD      A,(HL)          ; TYPE2 Blase2 vergleichen
  7E5A    FE 02                         CP      02H
  7E5C    38 3C                         JR      C,TASK99
  7E5E    3A 6004                       LD      A,(RAM+RTYPE2)
  7E61    FE 02                         CP      02H
  7E63    30 35                         JR      NC,TASK99       ; WENN IN RAM >1 EXTERNE TASK EINGABE
                                        ;----------------------
                                        ; EXTERN BEARBEITEN
                                
  7E65    11 0080                       LD      DE,BUFF
  7E68    21 8224                       LD      HL,PRLO1
  7E6B    7E                            LD      A,(HL)
  7E6C    12                            LD      (DE),A
  7E6D    13                            INC     DE
  7E6E    47                            LD      B,A
  7E6F    CD 7205                       CALL    BL13
                                ;ERROR ??
                                ; CALL  E.TEXT
                                ; JR    NC,TASK99
                                
  7E72    CD 0100                       CALL    0100H
  7E75    FE 00                         CP      0
  7E77    20 21                         JR      NZ,TASK99
  7E79    ED 4B 6510                    LD BC,(BFSLL+4)
  7E7D    C5                            PUSH BC
  7E7E    ED 5B 6512                    LD DE,(BFSHL+4) ; Suchadresse 2. BLASE speichern
  7E82    D5                            PUSH DE
  7E83    CD 78CD                       CALL DISK
  7E86    D1                            POP DE
  7E87    C1                            POP BC
  7E88    38 10                         JR      C,TASK99
  7E8A    01 6927                       LD      BC,RAMS+200H            ; MIT WERT AUS 1. BLASE
  7E8D    CD F82F                       CALL    SETDMA
  7E90    CD 7FF4                       CALL EXTERN
  7E93    F5                            PUSH AF
  7E94    CD F817                       CALL WRITE
  7E97    F1                            POP AF
  7E98    D3 1C                         OUT (PIOA),A
                                
                                        ;----------------
  7E9A    E1                    TASK99: POP     HL
  7E9B    D1                            POP     DE
  7E9C    C1                            POP     BC
                                        ;POP    AF
  7E9D    C9                            RET
                                        ;-----------------------
                                        ; Blase Speichern  aus RAMS in 
                                        ; BC = LL- LH , DE = HL-HH Adresse LBA
  7E9E    C5                    TWRITE: PUSH BC
  7E9F    D5                            PUSH DE
  7EA0    CD 78CD                       CALL DISK
        MACRO-80 3.43   27-Jul-81       PAGE    1-48


  7EA3    D1                            POP DE
  7EA4    C1                            POP BC
  7EA5    D8                            RET C
  7EA6    01 6727                       LD BC,RAMS              ; MIT WERT AUS 2. BLASE
  7EA9    CD F82F                       CALL SETDMA
  7EAC    CD 7FF4                       CALL EXTERN
  7EAF    F5                            PUSH AF
  7EB0    CD F817                       CALL WRITE
  7EB3    F1                            POP AF
  7EB4    D3 1C                         OUT (PIOA),A
  7EB6    AF                            XOR     A
  7EB7    C9                            RET
                                ;---------------
                                ; INTERRUPT FUER TASK PRUEFEN
                                ;INT:   EI
  7EB8    00                            NOP
  7EB9    00                            NOP
  7EBA    00                            NOP
  7EBB    00                            NOP
  7EBC    00                            NOP
  7EBD    00                            NOP
  7EBE    00                            NOP
  7EBF    00                            NOP
  7EC0    F3                            DI
  7EC1    C9                            RET
                                
                                ;-----------------------
                                ;  Uhr auslesen
                                
  7EC2    C5                    UHR00:  PUSH BC
  7EC3    CD 7FED                       CALL INTERN
  7EC6    F5                            PUSH AF
  7EC7    DB 1E                         IN A,(PIOB)
  7EC9    F5                            PUSH AF
  7ECA    3E 3F                         LD A,3FH                ; Adresse fuer Uhr
  7ECC    D3 1E                         OUT (PIOB),A
                                        ;-----------------
                                        ; Minuten in Dezimal
                                        ;
  7ECE    3E 40                         LD A,040H               ; Lesen Ein
  7ED0    D3 98                         OUT (URCS+18H),A
  7ED2    DB 9A                         IN A,(URCS+1AH) ; Minuten
  7ED4    4F                            LD C,A
                                ;       XOR A
                                ;       OUT (URCS+18H),A        ; R/W Aus
  7ED5    C5                            PUSH BC
  7ED6    CD 7F1C                       CALL ASCII_CODE
  7ED9    C1                            POP BC
  7EDA    78                            LD A,B
  7EDB    32 8082                       LD (DAYZ+2),A           ; ZEHNER
  7EDE    3A 8083                       LD A,(DAYZ+3)
  7EE1    B9                            CP C
  7EE2    28 2B                         JR Z,UHR01              ; ZEITAENERUNG NEIN ->
  7EE4    79                            LD A,C
  7EE5    32 8083                       LD (DAYZ+3),A
                                        ;-----------------------
        MACRO-80 3.43   27-Jul-81       PAGE    1-49


                                        ;       Stunde
                                        ;
                                ;       LD A,040H               ; Lesen Ein
                                ;       OUT (URCS+18H),A
  7EE8    00                            NOP
  7EE9    DB 9B                         IN A,(URCS+1BH) ; Stunde
  7EEB    4F                            LD C,A
  7EEC    AF                            XOR A
  7EED    D3 98                         OUT (URCS+18H),A        ; R/W Aus
  7EEF    C5                            PUSH BC
  7EF0    CD 7F1C                       CALL ASCII_CODE
  7EF3    C1                            POP BC
  7EF4    78                            LD A,B
  7EF5    32 8080                       LD (DAYZ),A
  7EF8    79                            LD A,C
  7EF9    32 8081                       LD (DAYZ+1),A
                                        ;-----------------
                                        ; DAY auslesen
                                        ;
                                ;       LD A,040H               ; Lesen Ein
                                ;       OUT (URCS+18H),A
  7EFC    00                            NOP
  7EFD    DB 9D                         IN A,(URCS+1DH) ; Tag
  7EFF    47                            LD B,A
                                ;       XOR A
                                ;       OUT (URCS+18H),A        ; Lesen Aus
  7F00    78                            LD A,B
  7F01    32 807F                       LD (DAYT),A
                                        ;-----------------
                                        ; Monat auslesen
                                        ;
                                ;       LD A,040H               ; Lesen Ein
                                ;       OUT (URCS+18H),A
  7F04    00                            NOP
  7F05    DB 9E                         IN A,(URCS+1EH) ; Tag
  7F07    47                            LD B,A
                                ;       XOR A
                                ;       OUT (URCS+18H),A        ; Lesen Aus
  7F08    78                            LD A,B
  7F09    32 807E                       LD (DAYM),A
                                        ;------------------
                                        ; Zeit ausgeben
                                        ;
  7F0C    CD 7F4D                       CALL    UHR10
  7F0F    AF                    UHR01:  XOR A
  7F10    D3 98                         OUT (URCS+18H),A        ; Lesen Aus
  7F12    F1                            POP AF
  7F13    E6 F0                         AND 0F0H
  7F15    D3 1E                         OUT (PIOB),A
  7F17    F1                            POP AF
  7F18    D3 1C                         OUT (PIOA),A
  7F1A    C1                            POP BC
  7F1B    C9                            RET
                                ;---------
  7F1C                          ASCII_CODE:
  7F1C    DD E5                         PUSH IX
        MACRO-80 3.43   27-Jul-81       PAGE    1-50


  7F1E    DD 21 0000                    LD IX,0
  7F22    DD 39                         ADD IX,SP
                                        ;------
  7F24    DD 7E 04                      LD A,(IX+4)     ;B=HIGH
  7F27    0F                            RRCA
  7F28    0F                            RRCA
  7F29    0F                            RRCA
  7F2A    0F                            RRCA
  7F2B    E6 0F                         AND 0FH
  7F2D    C6 30                         ADD A,30H
  7F2F    FE 3A                         CP 3AH
  7F31    38 02                         JR C,ASC_1
  7F33    C6 07                         ADD A,07H
  7F35    DD 77 05              ASC_1:  LD (IX+5),A
  7F38    DD 7E 04                      LD A,(IX+4)     ; C=LOW
  7F3B    E6 0F                         AND 0FH
  7F3D    C6 30                         ADD A,30H
  7F3F    FE 3A                         CP 3AH
  7F41    38 02                         JR C,ASC_2
  7F43    C6 07                         ADD A,07H
  7F45    DD 77 04              ASC_2:  LD (IX+4),A
                                        ;---------
  7F48    DD F9                         LD SP,IX
  7F4A    DD E1                         POP IX
  7F4C    C9                            RET             ; RETURN =BC
                                ;-----------------------
                                ;   Uhr anzeigen
                                ;
  7F4D    CD 7834               UHR10:  CALL COFF       ; CURSOR AUS
                                        ;---------------
                                        ; Zeile/Spalte
  7F50    C5                            PUSH BC
  7F51    01 0075                       LD BC,0075H
  7F54    CD 7ACA                       CALL WLIST      ; CURSOR POS
  7F57    C1                            POP BC
  7F58    3A 8080                       LD A,(DAYZ)
  7F5B    CD 780A                       CALL HEXC
  7F5E    3A 8081                       LD A,(DAYZ+1)
  7F61    CD 780A                       CALL HEXC
  7F64    3E 3A                         LD A,3AH
  7F66    CD 780A                       CALL HEXC
  7F69    3A 8082                       LD A,(DAYZ+2)
  7F6C    CD 780A                       CALL HEXC
  7F6F    3A 8083                       LD A,(DAYZ+3)
  7F72    CD 780A                       CALL HEXC
                                        ;-----------
  7F75    CD 7834                       CALL COFF 
  7F78    C5                            PUSH BC
  7F79    01 2475                       LD BC,2475H
  7F7C    CD 7018                       CALL T8         ;CURSOR POS
  7F7F    C1                            POP BC
  7F80    3A 807F                       LD A,(DAYT)
  7F83    4F                            LD C,A
  7F84    C5                            PUSH BC
  7F85    CD 7F1C                       CALL ASCII_CODE
  7F88    C1                            POP BC
        MACRO-80 3.43   27-Jul-81       PAGE    1-51


  7F89    78                            LD A,B
  7F8A    CD 780A                       CALL HEXC
  7F8D    79                            LD A,C
  7F8E    CD 780A                       CALL HEXC
  7F91    3E 2E                         LD A,2EH
  7F93    CD 780A                       CALL HEXC
  7F96    3A 807E                       LD A,(DAYM)
  7F99    4F                            LD C,A
  7F9A    C5                            PUSH BC
  7F9B    CD 7F1C                       CALL ASCII_CODE
  7F9E    C1                            POP BC
  7F9F    78                            LD A,B
  7FA0    CD 780A                       CALL HEXC
  7FA3    79                            LD A,C
  7FA4    CD 780A                       CALL HEXC
  7FA7    18 34                         JR RDU02
                                ;-----------------------
  7FA9    3E 02                         LD A,02H
  7FAB    32 651C                       LD (CURT),A
  7FAE    3E 04                         LD A,04H
  7FB0    32 651D                       LD (CURT+1),A
  7FB3    3A 6B27                       LD A,(RAMT)
  7FB6    CB 7F                         BIT 7,A
  7FB8    28 04                         JR Z,RDU03
  7FBA    3E 00                         LD A,00H
  7FBC    18 02                         JR RDU03+2
  7FBE    3E 01                 RDU03:  LD A,01H
  7FC0    32 651E                       LD (CURT+2),A
  7FC3    3A 6B27                       LD A,(RAMT)
  7FC6    E6 0F                         AND 0FH
  7FC8    FE 0A                         CP 0AH
  7FCA    38 0E                         JR C,RDU01
  7FCC    D6 0A                         SUB 0AH
  7FCE    32 651F                       LD (CURT+3),A
  7FD1    3A 651E                       LD A,(CURT+2)
  7FD4    3C                            INC A
  7FD5    32 651E                       LD (CURT+2),A
  7FD8    18 03                         JR RDU02
  7FDA    32 651F               RDU01:  LD (CURT+3),A
                                
  7FDD    CD 7AAC               RDU02:  CALL RLIST      
  7FE0    21 8091                       LD HL,CURON     ; CURSOR ON
  7FE3    06 06                         LD B,06D
  7FE5    7E                    CUR03:  LD A,(HL)
  7FE6    CD 780A                       CALL HEXC
  7FE9    23                            INC HL
  7FEA    10 F9                         DJNZ CUR03
  7FEC    C9                            RET
                                ;------------------
                                ;INCLUDE LCDINI.MAC
                                ;------------------
                                        ;
                                        ; BUS INTERN UMSCHALTUNG
                                        ;
  7FED    DB 1C                 INTERN: IN A,(PIOA)
  7FEF    F5                            PUSH AF
        MACRO-80 3.43   27-Jul-81       PAGE    1-52


  7FF0    CB BF                         RES 7,A
  7FF2    18 05                         JR TERN
  7FF4    DB 1C                 EXTERN: IN A,(PIOA)
  7FF6    F5                            PUSH AF
  7FF7    CB FF                         SET 7,A
  7FF9    D3 1C                 TERN:   OUT (PIOA),A
  7FFB    F1                            POP AF
  7FFC    C9                            RET
                                ;----------------
  7FFD                          EPROMON:        
  7FFD    DB 1C                         IN A,(PIOA)
  7FFF    CB B7                         RES 6,A
  8001    D3 1C                         OUT (PIOA),A    ; EPROM Ein
  8003    C3 0000                       JP 0000H        ; EPROM NEUSTART -> PROGRAMM ENDE
                                ;------------------------
  8006    42 4C 41 53           TEX1:   DEFM 'BLASE VERGLEICH:'
  800A    45 20 56 45           
  800E    52 47 4C 45           
  8012    49 43 48 3A           
                                ;TEX1I: DEFB 78H,78H,78H,78H    
  0010                          TXL     EQU $-TEX1
                                
  8016    42 4C 41 53           TEX2:   DEFM 'BLASE GEFUNDEN: '
  801A    45 20 47 45           
  801E    46 55 4E 44           
  8022    45 4E 3A 20           
  8026    00 00 00 00           TEX2I:  DEFB 00H,00H,00H,00H    
                                
  802A    4B 49 53 59           TEX3:   DEFM 'KISYS 08.12.2009/17'
  802E    53 20 30 38           
  8032    2E 31 32 2E           
  8036    32 30 30 39           
  803A    2F 31 37              
  0013                          TXL3    EQU $-TEX3
                                ;-----------------------
                                ;  BIOS Function Summary
                                
  803D    C5                    BIOS:   PUSH    BC
  803E    E5                            PUSH    HL
  803F    5E                            LD      E,(HL)          ; Speicher Lesen 
  8040    CD 0005                       CALL    0005H
  8043    E1                            POP     HL
  8044    C1                            POP     BC
  8045    23                            INC     HL
  8046    10 F5                         DJNZ    BIOS
  8048    C9                            RET
                                ;----------------------
                                ; Blasen Adress Buffer
                                
  8049    00 00 00 00           BF00:   DEFB    00H,00H,00H,00H,80H,00H         ; U,T1,T2 Zaehler zum Blase eroeffnen
  804D    80 00                 
  804F    00 00 00 00           BF01:   DEFB    00H,00H,00H,00H,00H,00H         ; LAST CURSOR POS XX,YY
  8053    00 00                 
  8055    00 00 00 00           BF02:   DEFB    00H,00H,00H,00H,00H,00H
  8059    00 00                 
  805B    00 00 00 00           BF03:   DEFB    00H,00H,00H,00H,00H,00H
        MACRO-80 3.43   27-Jul-81       PAGE    1-53


  805F    00 00                 
  8061    00 00 00 00           BF04:   DEFB    00H,00H,00H,00H,00H,00H
  8065    00 00                 
  8067    00 00 00 00           BF05:   DEFB    00H,00H,00H,00H,00H,00H
  806B    00 00                 
  806D    00 00 00 00           BF06:   DEFB    00H,00H,00H,00H         ; Datenbankverwaltung
  8071    00 00 00 00           BF07:   DEFB    00H,00H,00H,00H         ; Letzte HDD SORTIERADRESSE
                                ;----------------------
  8075    00 00 00 00           BF10:   DEFB    00H,00H,00H,00H,00H,00H,00H,00H ; User Type, G.Zaehler
  8079    00 00 00 00           
                                ;----------------------
                                ; Kalender
  807D    30                    DAYJ:   DEFB    30H
  807E    30                    DAYM:   DEFB    30H
  807F    30                    DAYT:   DEFB    30H
  8080    30 30 30 30           DAYZ:   DEFB    30H,30H,30H,30H,30H,30H
  8084    30 30                 
                                
                                ;----------------------
                                ; Eingabe Meldung Zeile 24, Spalte 1
  0007                          CURUD   EQU 07H                 ; Zaehlen ab 01 - 09
  8086    00 00                 ZEIL:   DEFB 00H,00H
  8088    1B 5B 31 6D           COL01:  DEFB 1BH,5BH,31H,6DH,1BH,5BH,34H,34H,6DH        ;COLOR
  808C    1B 5B 34 34           
  8090    6D                    
  8091    1B 5B 3F 32           CURON:  DEFB 1BH,5BH,3FH,32H,35H,68H            ;SET CURSOR ON
  8095    35 68                 
  8097    1B 5B 3F 32           CUROFF: DEFB 1BH,5BH,3FH,32H,35H,6CH            ;SET CURSOR OFF
  809B    35 6C                 
  809D    1B 5B 32 34           EBUFF:  DEFB 1BH,5BH,'2','4',';','0','1','H'
  80A1    3B 30 31 48           
  80A5    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  80A9    6D                    
  80AA    20 20 20 20                   DEFM '                           '
  80AE    20 20 20 20           
  80B2    20 20 20 20           
  80B6    20 20 20 20           
  80BA    20 20 20 20           
  80BE    20 20 20 20           
  80C2    20 20 20              
  80C5    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  80C9    3B 30 31 48           
  80CD    53 75 63 68           EBUFFE: DEFM 'Suche:'
  80D1    65 3A                 
  0036                          EZLEN   EQU $-EBUFF
  80D3    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  80D7    3B 30 31 48           
  80DB    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  80DF    6D                    
  80E0    4C 69 73 74                   DEFM 'List                '
  80E4    20 20 20 20           
  80E8    20 20 20 20           
  80EC    20 20 20 20           
  80F0    20 20 20 20           
  80F4    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  80F8    3B 30 31 48           
        MACRO-80 3.43   27-Jul-81       PAGE    1-54


  80FC    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  8100    6D                    
  8101    8E 6E 64 65                   DEFM  142D,'ndern              '
  8105    72 6E 20 20           
  8109    20 20 20 20           
  810D    20 20 20 20           
  8111    20 20 20 20           
  8115    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  8119    3B 30 31 48           
  811D    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  8121    6D                    
  8122    53 70 65 69                   DEFM 'Speichern           '
  8126    63 68 65 72           
  812A    6E 20 20 20           
  812E    20 20 20 20           
  8132    20 20 20 20           
  8136    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  813A    3B 30 31 48           
  813E    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  8142    6D                    
  8143    56 65 72 67                   DEFM 'Vergessen           '
  8147    65 73 73 65           
  814B    6E 20 20 20           
  814F    20 20 20 20           
  8153    20 20 20 20           
  8157    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  815B    3B 30 31 48           
  815F    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  8163    6D                    
  8164    45 6E 64 65                   DEFM 'Ende                '
  8168    20 20 20 20           
  816C    20 20 20 20           
  8170    20 20 20 20           
  8174    20 20 20 20           
                                
  8178    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  817C    3B 30 31 48           
  8180    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  8184    6D                    
  8185    20 20 20 4C                   DEFM '   List             '
  8189    69 73 74 20           
  818D    20 20 20 20           
  8191    20 20 20 20           
  8195    20 20 20 20           
                                
  8199    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  819D    3B 30 31 48           
  81A1    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  81A5    6D                    
  81A6    20 20 8E 6E                   DEFM '  ',142D,'ndern               '
  81AA    64 65 72 6E           
  81AE    20 20 20 20           
  81B2    20 20 20 20           
  81B6    20 20 20 20           
  81BA    20 20 20              
                                
        MACRO-80 3.43   27-Jul-81       PAGE    1-55


  81BD    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  81C1    3B 30 31 48           
  81C5    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  81C9    6D                    
  81CA    41 6E 6C 65                   DEFM 'Anlegen             '
  81CE    67 65 6E 20           
  81D2    20 20 20 20           
  81D6    20 20 20 20           
  81DA    20 20 20 20           
                                
  81DE    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  81E2    3B 30 31 48           
  81E6    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  81EA    6D                    
  81EB    53 70 65 69                   DEFM 'Speichern           '
  81EF    63 68 65 72           
  81F3    6E 20 20 20           
  81F7    20 20 20 20           
  81FB    20 20 20 20           
                                
  81FF    3A                            DEFB ':'        ; Ende Text
                                
  8200    4C 49 53 54           ZCUR:   DEFM 'LISTF.COM   '                             
  8204    46 2E 43 4F           
  8208    4D 20 20 20           
  820C    4D 45 4D 2E           ZCUR1:  DEFM 'MEM.COM     '
  8210    43 4F 4D 20           
  8214    20 20 20 20           
  8218    45 44 49 54                   DEFM 'EDIT.COM    '                             
  821C    2E 43 4F 4D           
  8220    20 20 20 20           
                                
                                ;----------------------
                                
  8224                          PRLO1:
                                ;!!!    DEFB 08H
  8224    46 41 4B 54                   DEFM 'FAKT.COM'
  8228    2E 43 4F 4D           
                                
  822C    53 74 61 72           STEX:   DEFM 'Start Programm  '
  8230    74 20 50 72           
  8234    6F 67 72 61           
  8238    6D 6D 20 20           
  0010                          LSTEX   EQU $-STEX
                                
  823C    4B 49 53 79           LCDE:   DEFM  'KISystem Winterhalter'
  8240    73 74 65 6D           
  8244    20 57 69 6E           
  8248    74 65 72 68           
  824C    61 6C 74 65           
  8250    72                    
  0015                          LCDEX   EQU     $-LCDE
                                
  8251    1B 5B 31 35           COMZ:   DEFB 1BH,5BH,31H,35H,3BH,30H,31H,48H,1BH,5BH,30H,4AH
  8255    3B 30 31 48           
  8259    1B 5B 30 4A           
        MACRO-80 3.43   27-Jul-81       PAGE    1-56


  825D    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH,1BH,5BH,34H,32H,6DH
  8261    6D 1B 5B 34           
  8265    32 6D                 
  8267    43 6F 6D 6D                   DEFM  'Commando Zeile= '
  826B    61 6E 64 6F           
  826F    20 5A 65 69           
  8273    6C 65 3D 20           
  0026                          COMZX   EQU     $-COMZ
                                
                                
  8277    1B 5B 32 34           KEYZ:   DEFB 1BH,5BH,32H,34H,3BH,30H,31H,48H
  827B    3B 30 31 48           
  827F    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH,1BH,5BH,34H,32H,6DH
  8283    6D 1B 5B 34           
  8287    32 6D                 
  8289    4B 45 59 20                   DEFM  'KEY Stepp= '
  828D    53 74 65 70           
  8291    70 3D 20              
  001D                          KEYZX   EQU     $-KEYZ
                                
  8294    1B 5B 30 31           MELD01: DEFB 1BH,5BH,30H,31H,3BH,30H,31H,48H
  8298    3B 30 31 48           
  829C    1B 5B 33 31                   DEFB 1BH,5BH,33H,31H,6DH,1BH,5BH,34H,34H,6DH
  82A0    6D 1B 5B 34           
  82A4    34 6D                 
  82A6    44 69 65 73                   DEFM  'Dieser Begriff ist mir nicht bekannt'
  82AA    65 72 20 42           
  82AE    65 67 72 69           
  82B2    66 66 20 69           
  82B6    73 74 20 6D           
  82BA    69 72 20 6E           
  82BE    69 63 68 74           
  82C2    20 62 65 6B           
  82C6    61 6E 6E 74           
  0036                          MELD01X EQU     $-MELD01
                                
  82CA    1B 5B 32 34           PROZ:   DEFB 1BH,5BH,32H,34H,3BH,30H,31H,48H
  82CE    3B 30 31 48           
  82D2    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH,1BH,5BH,34H,32H,6DH
  82D6    6D 1B 5B 34           
  82DA    32 6D                 
  82DC    44 61 74 65                   DEFM  'Dateiname= Dez/Text'
  82E0    69 6E 61 6D           
  82E4    65 3D 20 44           
  82E8    65 7A 2F 54           
  82EC    65 78 74              
  0025                          PROZX   EQU     $-PROZ
                                
  82EF    1B 5B 32 34           DERR:   DEFB 1BH,5BH,32H,34H,3BH,31H,31H,48H
  82F3    3B 31 31 48           
  82F7    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH,1BH,5BH,34H,37H,6DH
  82FB    6D 1B 5B 34           
  82FF    37 6D                 
  8301    2D 2D 2D 4D                   DEFM  '---MMC / SD / HDD ERROR---'
  8305    4D 43 20 2F           
  8309    20 53 44 20           
        MACRO-80 3.43   27-Jul-81       PAGE    1-57


  830D    2F 20 48 44           
  8311    44 20 45 52           
  8315    52 4F 52 2D           
  8319    2D 2D                 
  831B    05 05                         DEFB 05H,05H
  831D    24                            DEFM '$'
  002F                          L_DERR  EQU $-DERR
                                ;---------------------------
  831E    43 00 00 00           NBLASE: DEFB  MNBL1,00H,00H,00H,80H,00H                       ;         
  8322    80 00                 
                                        ;------------------
  8324    1B 5B 32 4A           NBL1:   DEFB  1BH,5BH,32H,4AH,1BH,5BH,48H,1BH,5BH,33H,37H,6DH ; 12 Zeichen
  8328    1B 5B 48 1B           
  832C    5B 33 37 6D           
  8330    1B 5B 31 6D                   DEFB  1BH,5BH,31H,6DH,1BH,5BH,34H,34H,6DH             ; 9 ZEICHEN
  8334    1B 5B 34 34           
  8338    6D                    
  8339    20 20 20 20                   DEFM '                                              ' ; 46 ZEICHEN
  833D    20 20 20 20           
  8341    20 20 20 20           
  8345    20 20 20 20           
  8349    20 20 20 20           
  834D    20 20 20 20           
  8351    20 20 20 20           
  8355    20 20 20 20           
  8359    20 20 20 20           
  835D    20 20 20 20           
  8361    20 20 20 20           
  8365    20 20                 
  0043                          MNBL1   EQU $-NBL1
                                        ; ??? key or grafic ??? 
  8367    00                            DEFB 00H                                ; no key no grafic output
                                        ; Programm
  8368    01                            DEFB 01H                                ; Programme
  8369    4D 41 53 4B                   DEFM 'MASKE1.COM  '                     ; 12 ZEICHEN
  836D    45 31 2E 43           
  8371    4F 4D 20 20           
  8375    39                            DEFB MNBL2 ;57D                         ; zum naechsten Textlaenge
  8376    1B 5B 33 37           NBL2:   DEFB 1BH,5BH,33H,37H,6DH                ; 5 ZEICHEN
  837A    6D                    
  837B    1B 5B 30 33                   DEFB 1BH,5BH,30H,33H,3BH,30H,31H,48H    ; 8 ZEICHEN
  837F    3B 30 31 48           
  8383    09 09 09                      DEFB 09H,09H,09H                        ; 3 ZEICHEN     
  8386    4E 65 75 65                   DEFM 'Neue Seite eroeffnet'             ; 20 ZEICHEN
  838A    20 53 65 69           
  838E    74 65 20 65           
  8392    72 6F 65 66           
  8396    66 6E 65 74           
  839A    0A 0D                         DEFB 0AH,0DH                            ; 2 ZEICHEN     
  839C    20 31 20 20                   DEFM ' 1  A'                            ; 5 ZEICHEN
  83A0    41                    
  83A1    0A 0D                         DEFB 0AH,0DH                            ; 2 ZEICHEN
  83A3    20 32 20 20                   DEFM ' 2  S'                            ; 5 ZEICHEN     
  83A7    53                    
  83A8    0A 0D                         DEFB 0AH,0DH                            ; 2 ZEICHEN
  83AA    20 39 20 20                   DEFM ' 9  E'                            ; 5 ZEICHEN
        MACRO-80 3.43   27-Jul-81       PAGE    1-58


  83AE    45                    
  0039                          MNBL2   EQU $-NBL2
                                        ; TASTE
  83AF    10                    MFILE:  DEFB 10H
                                        ; PROGRAMM
  83B0    02                            DEFB 02H
  83B1    41 55 54 4F                   DEFM 'AUTO.COM    '
  83B5    2E 43 4F 4D           
  83B9    20 20 20 20           
  83BD    4D 45 4D 2E                   DEFM 'MEM.COM     '
  83C1    43 4F 4D 20           
  83C5    20 20 20 20           
  83C9    20 20 20 20                   DEFM '            '
  83CD    20 20 20 20           
  83D1    20 20 20 20           
  83D5    20 20 20 20                   DEFM '            '
  83D9    20 20 20 20           
  83DD    20 20 20 20           
  83E1    20 20 20 20                   DEFM '            '
  83E5    20 20 20 20           
  83E9    20 20 20 20           
  83ED    20 20 20 20                   DEFM '            '
  83F1    20 20 20 20           
  83F5    20 20 20 20           
  83F9    20 20 20 20                   DEFM '            '
  83FD    20 20 20 20           
  8401    20 20 20 20           
  8405    20 20 20 20                   DEFM '            '
  8409    20 20 20 20           
  840D    20 20 20 20           
  8411    20 20 20 20                   DEFM '            '
  8415    20 20 20 20           
  8419    20 20 20 20           
  841D    00 00                         DEFB 00H,00H     ; 00= keine Keyeingabe folgend, 00= kein Progr.
  0101                          NBLLE   EQU     $-NBLASE
                                ;----------------------
  841F    43 00 00 01           TBLASE: DEFB  MTBLA1,00H,00H,01H,80H,00H                                ;       
  8423    80 00                 
                                        ;------------
  8425    1B 5B 30 6D           TBLA1:  DEFB  1BH,5BH,30H,6DH,1BH,5BH,48H,1BH,5BH,33H,37H,6DH   ; 12 Zeichen
  8429    1B 5B 48 1B           
  842D    5B 33 37 6D           
  8431    1B 5B 31 6D                   DEFB  1BH,5BH,31H,6DH,1BH,5BH,34H,34H,6DH               ; 9 ZEICHEN
  8435    1B 5B 34 34           
  8439    6D                    
  843A    20 20 20 20                   DEFM '            Leere BLASE                       ' ; 46 ZEICHEN
  843E    20 20 20 20           
  8442    20 20 20 20           
  8446    4C 65 65 72           
  844A    65 20 42 4C           
  844E    41 53 45 20           
  8452    20 20 20 20           
  8456    20 20 20 20           
  845A    20 20 20 20           
  845E    20 20 20 20           
  8462    20 20 20 20           
        MACRO-80 3.43   27-Jul-81       PAGE    1-59


  8466    20 20                 
  0043                          MTBLA1  EQU $-TBLA1
                                        ; Taste
  8468    00                            DEFB 00H                                        ; Key Eingabe
                                        ; Programm
  8469    01                            DEFB 01H                                        ; Programme
  846A    41 55 54 4F                   DEFM 'AUTO.COM    '                             ; 10 ZEICHEN
  846E    2E 43 4F 4D           
  8472    20 20 20 20           
  8476    2A                            DEFB MTBL2
  8477    1B 5B 33 37           TBL2:   DEFB 1BH,5BH,33H,37H,6DH                ; 5 ZEICHEN
  847B    6D                    
  847C    1B 5B 30 33                   DEFB 1BH,5BH,30H,33H,3BH,30H,31H,48H    ; 8 ZEICHEN
  8480    3B 30 31 48           
  8484    2A 2A 2A 2A                   DEFM '***********************      '
  8488    2A 2A 2A 2A           
  848C    2A 2A 2A 2A           
  8490    2A 2A 2A 2A           
  8494    2A 2A 2A 2A           
  8498    2A 2A 2A 20           
  849C    20 20 20 20           
  84A0    20                    
  002A                          MTBL2   EQU $-TBL2
                                        ; TASTE
  84A1    10                            DEFB 10H
                                        ; PROGRAMM
  84A2    02                            DEFB 02H
  84A3    54 45 4E 44                   DEFM 'TENDE.COM   '
  84A7    45 2E 43 4F           
  84AB    4D 20 20 20           
  84AF    20 20 20 20                   DEFM '            '
  84B3    20 20 20 20           
  84B7    20 20 20 20           
  84BB    20 20 20 20                   DEFM '            '
  84BF    20 20 20 20           
  84C3    20 20 20 20           
  84C7    20 20 20 20                   DEFM '            '
  84CB    20 20 20 20           
  84CF    20 20 20 20           
  84D3    20 20 20 20                   DEFM '            '
  84D7    20 20 20 20           
  84DB    20 20 20 20           
  84DF    20 20 20 20                   DEFM '            '
  84E3    20 20 20 20           
  84E7    20 20 20 20           
  84EB    20 20 20 20                   DEFM '            '
  84EF    20 20 20 20           
  84F3    20 20 20 20           
  84F7    20 20 20 20                   DEFM '            '
  84FB    20 20 20 20           
  84FF    20 20 20 20           
  8503    20 20 20 20                   DEFM '            '
  8507    20 20 20 20           
  850B    20 20 20 20           
  850F    00 00                         DEFB 00H,00H     ; 00= keine Keyeingabe folgend, 00= kein Progr.
  00F2                          TBLLE   EQU $-TBLASE
        MACRO-80 3.43   27-Jul-81       PAGE    1-60


                                ;-----------------------------
  8511    36 00 00 02           SMASKE: DEFB MSMAS1,00H,00H,02H,00H,76H,80H
  8515    00 76 80              
                                        ;-------------------
                                        ; BLOCK LAENG OBEN SMASKE ERSTER WERT(43H)
  8518    1B 5B 32 4A           SMAS1:  DEFB 1BH,5BH,32H,4AH,1BH,5BH,48H,1BH,5BH,33H,37H,6DH
  851C    1B 5B 48 1B           
  8520    5B 33 37 6D           
  8524    1B 5B 31 6D                   DEFB 1BH,5BH,31H,6DH,1BH,5BH,34H,34H,6DH
  8528    1B 5B 34 34           
  852C    6D                    
  852D    20 20 20 20                   DEFM '     Ersatzseite KI-System V1.0  ' ;46D Zeichen
  8531    20 45 72 73           
  8535    61 74 7A 73           
  8539    65 69 74 65           
  853D    20 4B 49 2D           
  8541    53 79 73 74           
  8545    65 6D 20 56           
  8549    31 2E 30 20           
  854D    20                    
                                        ;------------------
  0036                          MSMAS1  EQU $-SMAS1
  854E    00                            DEFB 00H        ; 00H no grafic output
  854F    01                            DEFB 01H        ; ANZAHL PROGRAMMAUFRUFE
  8550    4D 45 4D 2E                   DEFM 'MEM.COM     '    ; 'MASKE1.COM  ' 
  8554    43 4F 4D 20           
  8558    20 20 20 20           
                                
  855C    39                            DEFB MSMAS2
  855D    1B 5B 33 37           SMAS2:  DEFB 1BH,5BH,33H,37H,6DH                        ; 5 ZEICHEN
  8561    6D                    
  8562    1B 5B 30 33                   DEFB 1BH,5BH,30H,33H,3BH,30H,31H,48H            ; 8 ZEICHEN
  8566    3B 30 31 48           
  856A    09 09 09                      DEFB 09H,09H,09H                                ; 3 ZEICHEN     
  856D    4E 65 75 65                   DEFM 'Neue TYPE2 eroeffnet'                     ; 20 ZEICHEN
  8571    20 54 59 50           
  8575    45 32 20 65           
  8579    72 6F 65 66           
  857D    66 6E 65 74           
  8581    0A 0D                         DEFB 0AH,0DH                                    ; 2 ZEICHEN     
  8583    20 30 20 41                   DEFM ' 0 A?'                                    ; 5 ZEICHEN
  8587    3F                    
  8588    0A 0D                         DEFB 0AH,0DH                                    ; 2 ZEICHEN
  858A    20 31 20 20                   DEFM ' 1  S'                                    ; 5 ZEICHEN     
  858E    53                    
  858F    0A 0D                         DEFB 0AH,0DH                                    ; 2 ZEICHEN
  8591    20 39 20 20                   DEFM ' 9  E'                                    ; 5 ZEICHEN
  8595    45                    
  0039                          MSMAS2  EQU $-SMAS2
                                        ; TASTE
  8596    10                            DEFB 10H
                                        ; PROGRAMM
  8597    01                            DEFB 01H
  8598    4D 45 4D 2E                   DEFM 'MEM.COM     '
  859C    43 4F 4D 20           
  85A0    20 20 20 20           
        MACRO-80 3.43   27-Jul-81       PAGE    1-61


  85A4    20 20 20 20                   DEFM '            '
  85A8    20 20 20 20           
  85AC    20 20 20 20           
  85B0    20 20 20 20                   DEFM '            '
  85B4    20 20 20 20           
  85B8    20 20 20 20           
  85BC    20 20 20 20                   DEFM '            '
  85C0    20 20 20 20           
  85C4    20 20 20 20           
  85C8    20 20 20 20                   DEFM '            '
  85CC    20 20 20 20           
  85D0    20 20 20 20           
  85D4    20 20 20 20                   DEFM '            '
  85D8    20 20 20 20           
  85DC    20 20 20 20           
  85E0    20 20 20 20                   DEFM '            '
  85E4    20 20 20 20           
  85E8    20 20 20 20           
  85EC    20 20 20 20                   DEFM '            '
  85F0    20 20 20 20           
  85F4    20 20 20 20           
  85F8    20 20 20 20                   DEFM '            '
  85FC    20 20 20 20           
  8600    20 20 20 20           
  8604    00 00                         DEFB 00H,00H     ; 00= keine Keyeingabe folgend, 00= kein Progr.
  00F5                          NSMAS   EQU $-SMASKE
                                
                                END
        MACRO-80 3.43   27-Jul-81       PAGE    S


Macros:

Symbols:
757F    _ED12           785B    _WAIT1          7F1C    ASCII_CODE      
7F35    ASC_1           7F45    ASC_2           0047    BAUD1           
0047    BAUD2           0047    BAUD3           8049    BF00            
804F    BF01            8055    BF02            805B    BF03            
8061    BF04            8067    BF05            806D    BF06            
8071    BF07            8075    BF10            6503    BFRHH           
6502    BFRHL           6501    BFRLH           6500    BFRLL           
650F    BFSHH           650E    BFSHL           650D    BFSLH           
650C    BFSLL           650B    BFVHH           650A    BFVHL           
6509    BFVLH           6508    BFVLL           803D    BIOS            
707A    BL              70B4    BL00            70D7    BL000           
70BB    BL00A           70EA    BL01            7181    BL02            
7960    BL021           79BE    BL022           79C4    BL023           
79B8    BL02X           7196    BL03            71B1    BL030           
71A7    BL031           71C9    BL033           72AE    BL04            
796C    BL120           79B9    BL121           7998    BL123           
79AA    BL124           79B1    BL125           7205    BL13            
71E5    BL131           71E4    BL131A          71EA    BL132           
720F    BL13E           72BE    BL14            721B    BL23            
7223    BL231           7233    BL33            723E    BL43            
7249    BL53            7269    BL73            726F    BL736           
727C    BL83            72A0    BL830           72A8    BL831           
7297    BL84            6200    BLAN            72C6    BS10            
6206    BSTAT           0080    BUFF            0020    CMD_READSEC     
0030    CMD_WRITESEC    7834    COFF            706B    COL0            
8088    COL01           7070    COL1            8251    COMZ            
0026    COMZX           7823    CON             6C3F    COP             
0007    CPOS            0010    CTC0            0011    CTC1            
0012    CTC2            0013    CTC3            783B    CUR01           
782A    CUR02           7FE5    CUR03           8097    CUROFF          
8091    CURON           6518    CURS            651C    CURT            
0007    CURUD           77D3    CUT             807D    DAYJ            
807E    DAYM            807F    DAYT            8080    DAYZ            
00F4    DCI             0001    DCLR            000C    DCON            
82EF    DERR            0002    DHOM            78CD    DISK            
0001    DISPLAY         809D    EBUFF           80CD    EBUFFE          
7521    ED00            7515    ED01            751D    ED02            
754A    ED10            7572    ED100           7575    ED11            
757D    ED12            7595    ED13            75B3    ED14            
75B8    ED15            75B5    ED20            75BB    ED30            
75D3    ED31            75E6    ED32            75E8    ED33            
75EA    ED40            75F5    ED41            7604    ED42            
7609    ED43            760E    ED44            7621    ED441           
7638    ED442           763C    ED50            7651    ED51            
74FD    EING            7653    EING11          7682    EING21          
7692    EING22          76AD    EING23          76BD    EING24          
76CC    EING25          76E5    EING26          76E7    EING27          
76EF    EING30          0040    EOFF            7FFD    EPROMON         
788D    ERR1            71C4    EXIT            7FF4    EXTERN          
7177    EZ01            717E    EZ02            7118    EZ03            
7148    EZ04            0036    EZLEN           006F    FBLOCK          
005C    FCB             006B    FCBCR           005D    FCBFN           
0065    FCBFT           007C    FCBRA           7921    FREI            
0005    FSET            0800    HDD             00BE    HDDE            
        MACRO-80 3.43   27-Jul-81       PAGE    S-1


787C    HDD_ERROR       7895    HDD_INFO        7862    HDD_INIT        
78A3    HDD_READ        785B    HDD_WAIT        7E47    HDIST           
7792    HEX00           773B    HEX11           774E    HEX12           
7792    HEX14           7787    HEXA            7819    HEXB            
780A    HEXC            7730    HEXI1           7743    HEXI2           
7752    HEXIE           7755    HEXP            00F0    IDE             
00FD    IDECHI          00FC    IDECLO          00FF    IDECMD          
00F8    IDEDAT          00F6    IDEDOR          00F9    IDEERR          
78B1    IDERES          78B7    IDERES1         00FA    IDESCNT         
00FE    IDESDH          00FB    IDESNUM         00FF    IDESTAT         
7FED    INTERN          0000    KANAL0          0001    KANAL1          
0003    KANAL3          0004    KANAL4          0005    KANAL5          
7A0A    KEY01           7929    KEYB            794F    KEYB1           
0009    KEYBUF          0002    KEYIN           0001    KEYOUT          
79F8    KEYST           8277    KEYZ            001D    KEYZX           
7024    KI              709B    KI1             00F5    LATCH           
7A0C    LBA0            7A55    LBA20           7A56    LBA21           
7A52    LBA4            7A5B    LBA5            0060    LCD             
823C    LCDE            0015    LCDEX           7B0A    LIS0            
7B0C    LIS1            7AE4    LIST            6513    LOGHH           
6512    LOGHL           6511    LOGLH           6510    LOGLL           
0100    LOS             0120    LOS1            0008    LPOS            
0010    LSTEX           002F    L_DERR          7A95    L__6            
7A8D    L__7            76F5    MAS00           7705    MAS01           
7721    MAS02           79C9    MASK1           79D1    MASK2           
8294    MELD01          0036    MELD01X         83AF    MFILE           
A101    MMC             0007    MMCE            0043    MNBL1           
0039    MNBL2           0036    MSMAS1          0039    MSMAS2          
002A    MTBL2           0043    MTBLA1          8324    NBL1            
8376    NBL2            831E    NBLASE          0101    NBLLE           
00F5    NSMAS           001C    PIOA            001E    PIOB            
8224    PRLO1           0130    PRO             7000    PROG            
82CA    PROZ            0025    PROZX           0005    P_READ          
0006    P_WRITE         6524    RADR            6000    RAM             
0021    RAMH            0000    RAML            6727    RAMS            
6B27    RAMT            6527    RAMV            0000    RBLAN           
0006    RBSTAT          7CF0    RD01            7DAC    RD02            
7D5D    RD03            7C8C    RD06            7B9A    RD07            
7B9D    RD08            7BA5    RD09            7CC5    RD16            
7CD2    RD17            7CDA    RD170           7CE5    RD171           
7C31    RD25            7C63    RD250           7C45    RD255           
7C4F    RD26            7D92    RD30            7C81    RD35            
7C6F    RD36            7DC0    RD90            7DE4    RD91            
7DE7    RD911           7DED    RD92            7CA8    RDD1            
7DFA    RDREAD          7FDA    RDU01           7FDD    RDU02           
7FBE    RDU03           7E23    RDWRITE         F814    READ            
0000    REG1            00C1    REG3            0044    REG4            
00EA    REG5            7AAC    RLIST           6526    RMEN            
0007    RSOTR           0005    RTERM           6BEF    RTEX            
0003    RTYPE1          0004    RTYPE2          701E    RUN             
0001    RUSER           77C3    SA1             77C7    SA2             
77C9    SA3             6520    SANDB           77B3    SANDU           
00EF    SCDP            00EE    SCRP            0020    SDC             
0004    SELDM           00F7    SELDS           F838    SELDSK          
F82F    SETDMA          F835    SETSEC          F832    SETTRK          
0018    SIOA            001A    SIOB            0018    SIORES          
        MACRO-80 3.43   27-Jul-81       PAGE    S-2


8518    SMAS1           855D    SMAS2           8511    SMASKE          
822C    STEX            72F9    STX01           72EB    SU00            
72FF    SU01            734E    SU02            7351    SU03            
7365    SU04            7425    SU21            74DA    SU23            
740A    SU25            74E2    SU32            74F0    SU33            
74B8    SU52            74CC    SU520           742E    SU62            
7460    SU63            73EA    SU80            73B0    SU83            
73B9    SU84            739B    SU85            73D7    SU86            
73E4    SU87            738D    SU88            7471    SU90            
74B5    SU95            7481    SU99            78FF    SUCH0           
790D    SUCH1           790F    SUCH2           7000    T0              
7003    T1              7006    T2              7009    T3              
700C    T4              700F    T5              7012    T6              
7015    T7              7018    T8              701B    T9              
7B17    TAS             7B76    TAS00           7C04    TAS03           
7D2F    TAS22           7D55    TAS24           7E4F    TASK            
7E9A    TASK99          FFA2    TASKSP          8477    TBL2            
8425    TBLA1           841F    TBLASE          00F2    TBLLE           
71D9    TEING           6205    TERM            7FF9    TERN            
8006    TEX1            8016    TEX2            8026    TEX2I           
802A    TEX3            0004    TIME1           0004    TIME2           
0004    TIME3           FFAB    TRACK           FFA5    TRACKH          
FFA4    TRACKL          7E9E    TWRITE          0010    TXL             
0013    TXL3            6203    TYPE            7EC2    UHR00           
7F0F    UHR01           7F4D    UHR10           0080    URCS            
6201    USER            7850    WAITDRQ         7845    WAITRDY         
00F1    WDTCR           00F0    WDTMR           7ACA    WLIST           
F817    WRITE           8200    ZCUR            820C    ZCUR1           
772C    ZEI00           8086    ZEIL            



No Fatal error(s)


                                                                        
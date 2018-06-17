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
                         C      ;-----------------
                         C      ; PARAMETER
  006F                   C      FBLOCK  EQU 6FH         ; GROESSE FILEBLOCK AM BLASENENDE
                         C      ;-----------------
                                 
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
                                
        MACRO-80 3.43   27-Jul-81       PAGE    1-3


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
        MACRO-80 3.43   27-Jul-81       PAGE    1-4


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
  7003    C3 7812               T1:     JP HEXC         ; ZEICHENAUSGEBEN
  7006    C3 79F6               T2:     JP KEYST        ; TASTENABFRABE OHNE SORTIERUNG
  7009    C3 78FD               T3:     JP SUCH0        ; Blase mit Eintrag aus RAMT suchen  
  700C    C3 7A0A               T4:     JP LBA0         ; Plattenzugriff (DE), (HL) +1
  700F    C3 7DF8               T5:     JP RDREAD       ; lesen einer Blase
  7012    C3 7E21               T6:     JP RDWRITE      ; Speichern einer Blase
  7015    C3 77DB               T7:     JP CUT          ; CURSOR POS SET IN (CURT)0-3
  7018    C3 7AE2               T8:     JP LIST         ; CURSOR POS SET IN BC
  701B    C3 7927               T9:     JP KEYB         ; input keypad buffer, end with <cr>
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
        MACRO-80 3.43   27-Jul-81       PAGE    1-5


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
  7027    22 8071                       LD (BF07+2),HL
  702A    22 6502                       LD (BFRHL),HL           ; AKTUELL TRACK/SECTORADRESSE LADEN
                                        ; SORTIERE IN BFS...
  702D    22 650E                       LD (BFSHL),HL           ; IN BFS ADRESSE ZUM SORZIEREN
  7030    22 6512                       LD (BFSHL+4),HL
  7033    22 6512                       LD (LOGHL),HL
  7036    21 0010                       LD HL,0010H             ; STARTADR. USER-LOGIN AUF HDD
  7039    22 6510                       LD (LOGLL),HL
  703C    21 0800                       LD HL,HDD               ; HD STARTADRESSE
  703F    22 806F                       LD (BF07),HL
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
  7053    32 8047                       LD (BF00),A
  7056    32 8048                       LD (BF00+RUSER),A
  7059    32 8049                       LD (BF00+RTYPE1),A
  705C    32 804A                       LD (BF00+RTYPE2),A
  705F    32 804B                       LD (BF00+RTERM),A
                                        ;----------
        MACRO-80 3.43   27-Jul-81       PAGE    1-6


  7062    C5                            PUSH BC
  7063    D5                            PUSH DE
  7064    E5                            PUSH HL
  7065    21 8086               COL0:   LD HL,COL01             ; BILDSCHIRM FARBE
  7068    06 09                         LD B,09D                ; AUSGABELAENGE
  706A    7E                    COL1:   LD A,(HL)
  706B    CD 7812                       CALL HEXC
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
  7080    CD 7DF8                       CALL RDREAD
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
  708B    21 8502                       LD HL,SMASKE            ; STARTMASKE LADEN
  708E    11 6000                       LD DE,RAM
  7091    01 00F4                       LD BC,NSMAS
  7094    ED B0                         LDIR
  7096    3E 0A                 KI1:    LD A,0AH        ; >9
  7098    32 8081                       LD (DAYZ+3),A   ; UHRZEIT LOESCHEN DAMIT GLEICH AUSGEGEBEN WIRD
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
  70B2    AF                            XOR A
  70B3    32 806A                       LD (BF05+5),A   ; BLOCK status
  70B6    32 6200                       LD (BLAN),A     ; RUECKSPRUNG BEDINGUNG =0
        MACRO-80 3.43   27-Jul-81       PAGE    1-7


  70B9    22 6524               BL00A:  LD (RADR),HL    ; cache current BLASE address
  70BC    3A 806A                       LD A,(BF05+5)
  70BF    3C                            INC A
  70C0    32 806A                       LD (BF05+5),A   ; BLOCK ABSCHNITT
  70C3    7E                            LD A,(HL)       ; Number of characters from mask
  70C4    32 6526                       LD (RMEN),A     ; caching character length
  70C7    11 6000                       LD DE,RAM
  70CA    ED 52                         SBC HL,DE       ; determine BLASEN start
  70CC    2A 6524                       LD HL,(RADR)    ; load current BLASE address
  70CF    20 0A                         JR NZ,BL000     ; no BLASEN start ->
                                        ;-----------------------
                                        ; BLASEN beginning new
                                        ; load restart parameter
                                        ; 
  70D1    23                            INC HL          ; ->USER
  70D2    23                            INC HL          ; ->TYPE1
  70D3    7E                            LD A,(HL)       ; load type1
  70D4    32 8049                       LD (BF00+RTYPE1),A      
  70D7    23                            INC HL          ; ->Type2
  70D8    23                            INC HL          ; ->Gedaechtniszaehler
  70D9    23                            INC HL          ; ->Status Byte
  70DA    23                            INC HL          ; KOPFTEXT
                                        ;----------------
                                        ; in header =5 byte
  70DB    3A 6526               BL000:  LD A,(RMEN)     ; load character length
  70DE    47                            LD B,A          ; B= counter
  70DF    3E 05                         LD A,05H        ; USER.... 
  70E1    B8                            CP B            ; counter > 0
  70E2    D2 74FE                       JP NC,EING      ; no character jump to the input =0 ->
                                        ;--------------------------------
                                        ; set cursor und BLOCK output 
                                        ;
  70E5    E5                            PUSH HL
  70E6    C5                            PUSH BC
  70E7    01 0101                       LD BC,0101H
  70EA    CD 7018                       CALL T8         ; set cursor
  70ED    C1                            POP BC
  70EE    E1                            POP HL
                                        ; BLOCK output
  70EF    7E                    BL01:   LD A,(HL)       
  70F0    CD 7812                       CALL HEXC       ; output area 
  70F3    23                            INC HL          ; from here graphic/text area
  70F4    10 F9                         DJNZ BL01       ; counter[B
  70F6    22 6524                       LD (RADR),HL    ; cache current BLASE address
                                        ; (HL) KOPFZEILE ENDE
                                        ;---------------------------
                                        ; Issue Blasen parameters USER,TYPE1,TYPE2,
                                        ; memory in % 
                                        ; top right Z=1, S=60
                                        ;
  70F9    E5                            PUSH HL         ; RETTE BLASE
  70FA    D5                            PUSH DE
  70FB    C5                            PUSH BC
  70FC    01 0160                       LD BC,0160H     
  70FF    CD 7018                       CALL T8         ; set cursor
  7102    C1                            POP BC
        MACRO-80 3.43   27-Jul-81       PAGE    1-8


  7103    21 6001                       LD HL,RAM+RUSER         ; USER address from current BLASE
  7106    C5                            PUSH BC
  7107    4E                            LD C,(HL)       ; USER load
  7108    C5                            PUSH BC
  7109    CD 779A                       CALL HEX14      ; USER / %
  710C    C1                            POP BC
  710D    C1                            POP BC
  710E    2A 6002                       LD HL,(RAM+RTYPE1)      ; TYPE2=L ,TYPE1=H LADEN
                                        ;---------------------
                                        ; output memory count in %
  7111    3A 6004                       LD A,(RAM+RTERM)        ; memory count load
  7114    5F                            LD E,A  
  7115    3E 00                         LD A,00H
  7117    F5                    EZ03:   PUSH AF
  7118    7B                            LD A,E
  7119    D6 02                         SUB 02H
  711B    FE 03                         CP 03h
  711D    38 28                         JR C,EZ04
  711F    28 26                         JR Z,EZ04
  7121    5F                            LD E,A
  7122    F1                            POP AF
  7123    3C                            INC A
  7124    27                            DAA
  7125    F5                            PUSH AF
  7126    7B                            LD A,E
  7127    D6 03                         SUB 03H
  7129    FE 03                         CP 03H
  712B    38 1A                         JR C,EZ04
  712D    28 18                         JR Z,EZ04
  712F    5F                            LD E,A
  7130    F1                            POP AF
  7131    3C                            INC A
  7132    27                            DAA
  7133    CB 47                         BIT 0,A
  7135    28 E0                         JR Z,EZ03
  7137    F5                            PUSH AF
  7138    7B                            LD A,E
  7139    D6 03                         SUB 03H
  713B    FE 03                         CP 03H
  713D    38 08                         JR C,EZ04
  713F    28 06                         JR Z,EZ04
  7141    5F                            LD E,A
  7142    F1                            POP AF
  7143    3C                            INC A
  7144    27                            DAA
  7145    18 D0                         JR EZ03
                                        ;-------------------
  7147    F1                    EZ04:   POP AF
  7148    C5                            PUSH BC
  7149    4F                            LD C,A
  714A    C5                            PUSH BC
  714B    CD 779A                       CALL HEX00              ; % WERT AUSGEBEN
  714E    C1                            POP BC
  714F    C1                            POP BC
  7150    3E 25                         LD A,'%'                ; % ALS ZEICHEN
  7152    CD 7812                       CALL HEXC
        MACRO-80 3.43   27-Jul-81       PAGE    1-9


  7155    D1                            POP DE
  7156    E1                            POP HL
  7157    2A 6524                       LD HL,(RADR)    ; load current BLASE address
                                        ; from here against BLASEN address
                                        ;-------------------------------
                                        ; key in sign
                                        ;
  715A    46                            LD B,(HL)       ; 00H = no grafic VT100 output
  715B    23                            INC HL          ; key 
  715C    E5                            PUSH HL
  715D    21 6B27                       LD HL,RAMT      ; RAMT Zeichen Buffer Eingaben
  7160    11 6B27                       LD DE,RAMT      ; ZEICHEN SPEICHERN
  7163    13                            INC DE          ; fuer erstes Zeichen
  7164    AF                            XOR A
  7165    77                            LD (HL),A       ; Eingabe Zeichenzaehler auf Null setzen
  7166    B8                            CP B
  7167    CA 7199                       JP Z,BL03       ; SPEUNG ZUR EINGABE OHNE GRAFIK AUSGABE 
                                        ;--------------------------
                                        ; BLOCK AN VT100 ausgeben LAENGE IN B
  716A    D5                            PUSH DE
  716B    E5                            PUSH HL         ; Grafik/Text 
  716C    C5                            PUSH BC
  716D    3A 6003                       LD A,(RAM+RTYPE2)
  7170    FE 00                         CP 0H
  7172    C2 7181                       JP NZ,EZ02
  7175    21 809B                       LD HL,EBUFF
  7178    06 36                         LD B,EZLEN
  717A    7E                    EZ01:   LD A,(HL)
  717B    CD 7812                       CALL HEXC
  717E    23                            INC HL
  717F    10 F9                         DJNZ EZ01
  7181    C1                    EZ02:   POP BC
  7182    E1                            POP HL
  7183    D1                            POP DE
  7184    C5                    BL02:   PUSH BC
  7185    D5                            PUSH DE
  7186    E5                            PUSH HL
  7187    CD 7B15                       CALL TAS        ; auf Zeichen Warten
  718A    F5                            PUSH AF
  718B    CD 7821                       CALL CON        ; CURSOR ON
  718E    F1                            POP AF
  718F    E1                            POP HL
  7190    D1                            POP DE
  7191    C1                            POP BC
  7192    CD 701B                       CALL T9
  7195    FE 0D                         CP 0DH
  7197    20 EB                         JR NZ,BL02
                                ;-----------------------
                                ; load and execute file.com
                                ;
  7199    E1                    BL03:   POP HL          ; zurueck zur aktuellen RAM adre.
  719A    7E                            LD A,(HL)       ; Pruefe ob Zeiche ??Programmaufruf da 
  719B    23                            INC HL          ; PROGRAMM 
  719C    FE 00                         CP 00H
  719E    20 0A                         JR NZ,BL031
  71A0    3A 6B27                       LD A,(RAMT)
        MACRO-80 3.43   27-Jul-81       PAGE    1-10


  71A3    FE 00                         CP 00H
  71A5    20 0D                         JR NZ,BL030     ; 00H AUSGANG KEIN PRORAMMAUFRUF 
  71A7    C3 70B9                       JP BL00A
                                        ;------------------------
  71AA    F6 30                 BL031:  OR 30H          ; sonst Zeichenzaehler auf 1 setzen
  71AC    32 6B28                       LD (RAMT+1),A   ; 
  71AF    3E 01                         LD A,01H        ; Programme mindest ASCII 1
  71B1    32 6B27                       LD (RAMT),A     ; Programmzaehler
  71B4    46                    BL030:  LD B,(HL)       ; Anzahl von Programmaufrufe aus Blase
  71B5    AF                            XOR A           ; LOESCHEN
  71B6    B8                            CP B
  71B7    CA 72BF                       JP Z,BL14       ; SPEUNG 
                                        ;--------------
  71BA    3A 6B27                       LD A,(RAMT)     ; Anzahl der Taste 
  71BD    FE 02                         CP 02H          ; ZEICHEN ZAEHLER >
  71BF    D2 72BF                       JP NC,BL14      ; Taste mehr als eine Stelle
  71C2    3A 6B28                       LD A,(RAMT+1)   ; gedruektes Taste =31-39  Zeichen
  71C5    FE 30                         CP 30H
  71C7    28 19                         JR Z,TEING      ; ??Aender moeglich machen mit 0
  71C9    FE 39                         CP 39H          ; MIT 9 ENDE
  71CB    20 05                         JR NZ,BL033
  71CD    0E 00                 EXIT:   LD C,00H
  71CF    C3 7FFB                       JP EPROMON
                                ;-------
  71D2    FE 3A                 BL033:  CP 3AH          ; nicht > 9
  71D4    D2 70AF                       JP NC,BL00      ; AUSGANG FEHLER
  71D7    D6 30                         SUB 30H         ; nicht < 1
  71D9    DA 70AF                       JP C,BL00       ; AUSGANG FEHLER
  71DC    47                            LD B,A          ; Welches Programm in A 1 - 9
  71DD    22 6524                       LD (RADR),HL    ; aktuelle RAM Adresse retten 
  71E0    18 0C                         JR BL131
                                        ;-------------------
                                        ; AENDERUNG NUR IN TYPE2 =0 MOEGLICH
  71E2    3A 6003               TEING:  LD A,(RAM+RTYPE2)
  71E5    FE 00                         CP 0H
  71E7    CA 74FE                       JP Z,EING
  71EA    C3 70AF                       JP BL00
                                        ;-----------------
                                        ; Programm suchen und Starten
  71ED    19                    BL131A: ADD HL,DE
  71EE    11 000C               BL131:  LD DE,000CH     ; MAX Laenge einer Datei
  71F1    10 FA                         DJNZ BL131A
  71F3    11 0080               BL132:  LD DE,BUFF      ; <- Zurueck von Zeilen-Prog.aufruf
                                ;!!!    INC HL          ; WIEVIEL ZEICHEN DATEINAME
                                ;!!!    LD A,(HL)       ; PRUEFE DAPROGRAMME 
                                ;!!!    CP 0H
                                ;!!!    JP Z,BL00       ; KEIN PROGRAMM =0 ->
  71F6    3E 0C                         LD A,12D
  71F8    12                            LD (DE),A
  71F9    13                            INC DE
  71FA    E6 0F                         AND 0FH
  71FC    47                            LD B,A          ; Laenge der Datei auslesen
  71FD    CD 7206                       CALL BL13
  7200    DA 72A1                       JP C,BL830      ; ERROR DATEI NICHT GEFUNDEN
  7203    C3 7298                       JP BL84
                                        ;-------------------
        MACRO-80 3.43   27-Jul-81       PAGE    1-11


                                        ; PROGRAMM AUS (HL) ]BERNEHMEM UND LADEN
                                        ; B= LAENGE DES DATEINAMEN
                                        ; (HL) DATEINAME.COM
                                        ; NACH (DE) BUFFER COPIEREN 
                                        ;
  7206    23                    BL13:   INC HL          ; FILE NACH KOPFTEXE 
  7207    7E                            LD A,(HL)
  7208    FE 21                         CP 21H          ; PRUEFE OB NOCH ASCII >20 (SPACE)
  720A    38 05                         JR C,BL13E
  720C    12                            LD (DE),A
  720D    CD 7812                       CALL HEXC       ; !!!! PROGRAMMNAME SICHTBAR MACHEN ZUM TEST
  7210    13                            INC DE
  7211    10 F3                 BL13E:  DJNZ BL13
                                        ;--
                                ;!!!    LD (RADR),HL
  7213    AF                            XOR A
  7214    12                            LD (DE),A
                                        ;------------------
                                        ;
  7215    11 005D                       LD DE,FCBFN
  7218    3E 20                         LD A,20H
  721A    06 0B                         LD B,0BH
  721C    12                    BL23:   LD (DE),A       ; LOESCHEN B MAL
  721D    13                            INC DE
  721E    10 FC                         DJNZ BL23
  7220    3E 00                         LD A,00H
  7222    06 08                         LD B,08H
  7224    12                    BL231:  LD (DE),A       ; LOESCHEN B MAL
  7225    13                            INC DE
  7226    10 FC                         DJNZ BL231
                                        ;--------------
                                        ;
  7228    E5                            PUSH HL
  7229    11 005C                       LD DE,FCB
  722C    AF                            XOR A
  722D    12                            LD (DE),A
  722E    13                            INC DE
  722F    21 0080                       LD HL,BUFF
  7232    46                            LD B,(HL)       ; DATEINAMEN LAENGE
  7233    23                            INC HL
  7234    7E                    BL33:   LD A,(HL)
  7235    FE 2E                         CP 2EH          ; POINT ERKENNUNG .COM
  7237    20 06                         JR NZ,BL43
  7239    23                            INC HL
  723A    11 0065                       LD DE,FCBFT
  723D    18 F5                         JR BL33 
                                        ;-----------
  723F    12                    BL43:   LD (DE),A
  7240    13                            INC DE
  7241    23                            INC HL
  7242    10 F0                         DJNZ BL33
  7244    CD 78AF                       CALL IDERES
  7247    AF                            XOR A
  7248    06 14                         LD B,14H
  724A    12                    BL53:   LD (DE),A
  724B    13                            INC DE
        MACRO-80 3.43   27-Jul-81       PAGE    1-12


  724C    10 FC                         DJNZ BL53
  724E    1E 04                         LD E,SELDM      ; MASTER DISK
  7250    0E 0E                         LD C,14D
  7252    CD 0005                       CALL 0005H      ; BEZUGSLAUFWERK LW-NUMMER
  7255    E5                            PUSH HL
  7256    AF                            XOR A
  7257    32 006B                       LD (FCBCR),A    ; cr loeschen
  725A    11 005C                       LD DE,FCB
  725D    0E 0F                         LD C,0FH
  725F    CD 0005                       CALL 0005H
  7262    FE FF                         CP 0FFH
  7264    20 04                         JR NZ,BL73      ; ->kein Fehler POP HL fehlt
  7266    E1                            POP HL
  7267    E1                            POP HL          ; Adresse zurueck
  7268    37                            SCF
  7269    C9                            RET
                                        ;--------------------
                                        ;  Dateisatz lesen
                                        ;
  726A    3A 007C               BL73:   LD A,(FCBRA)
  726D    11 0100                       LD DE,0100H     ; DMA Buffer
  7270    FE 00                 BL736:  CP 00H
  7272    28 09                         JR Z,BL83
  7274    3D                            DEC A
  7275    21 0080                       LD HL,0080H
  7278    19                            ADD HL,DE
  7279    E5                            PUSH HL
  727A    D1                            POP DE          ; HL nach DE kopieren
  727B    18 F3                         JR BL736
  727D    0E 1A                 BL83:   LD C,1AH        ; Datenbuffer festlegen
  727F    CD 0005                       CALL 0005H      ; CCP
  7282    E5                            PUSH HL
  7283    D5                            PUSH DE
  7284    C5                            PUSH BC
  7285    11 005C                       LD DE,FCB
  7288    0E 14                         LD C,14H
  728A    CD 0005                       CALL 0005H      ; Datei laden
  728D    C1                            POP BC
  728E    D1                            POP DE
  728F    E1                            POP HL
  7290    FE 00                         CP 00H
  7292    28 D6                         JR Z,BL73       ; wiederhole bie Datei geladen
  7294    E1                            POP HL          ; wenn bei BL53: kein Fehler RAM weiter
  7295    E1                            POP HL          ; Adresse zurueck
  7296    AF                            XOR A
  7297    C9                            RET
                                        ;---------------
                                        ; GEFUNDENES PROGRAMM STARTEN
                                        ;
  7298    E5                    BL84:   PUSH HL
  7299    D5                            PUSH DE
  729A    C5                            PUSH BC
  729B    CD 0100                       CALL 0100H
  729E    C1                            POP BC
  729F    D1                            POP DE
  72A0    E1                            POP HL
        MACRO-80 3.43   27-Jul-81       PAGE    1-13


                                        ;----------
                                        ; Ende der Programme berechnen
  72A1    2A 6524               BL830:  LD HL,(RADR)    ; Aktuelle Blasenadresse holen
  72A4    46                            LD B,(HL)       ; NAECHSTE DATEI LAENGE
  72A5    04                            INC B           ; ERSTES ZEICHEN
  72A6    18 01                         JR BL831
                                        ;-----------
  72A8    19                            ADD HL,DE
  72A9    11 000C               BL831:  LD DE,000CH     ; Laenge (13Dez.) einer Datei
  72AC    10 FA                         DJNZ BL831-1    
  72AE    23                            INC HL
                                        ;-----------------
                                        ; Sprungadresse in I/O-RAM (0) Laden
                                        ;
  72AF    3A 6200               BL04:   LD A,(BLAN)     ; Rueckmeldung aus Unterprogramm
  72B2    FE 00                         CP 00H
  72B4    CA 70AF                       JP Z,BL00       ; Blase neu starten
  72B7    FE 01                         CP 01H
  72B9    CA 70B9                       JP Z,BL00A      ; naechster Block 
  72BC    C3 70AF                       JP BL00         ; weiter mit RAM
                                ;---------------------------
                                ; Aktuelle Blase im RAM nach Begriff durchsuchen
                                ;
  72BF    3A 6001               BL14:   LD A,(RAM+1)    ; Type1
  72C2    47                            LD B,A
                                ;??     LD A,(USER) TYPE1
  72C3    B8                            CP B
  72C4    CA 72C7                       JP Z,BS10               ; gefunden
                                ;---------------------------
                                ;  Blase vom Anfang aus nach RAMR laden und Text suchen
                                 
  72C7    3A 8048               BS10:   LD A,(BF00+RUSER)       ; UEBERNEHMEN
  72CA    32 8074                       LD (BF10+RUSER),A       ; loeschen 
  72CD    3A 8049                       LD A,(BF00+RTYPE1)      ; uebernehmen
  72D0    32 8075                       LD (BF10+RTYPE1),A      ; loeschen 
  72D3    3A 804A                       LD A,(BF00+RTYPE2)      ; uebernehmen 
  72D6    32 8076                       LD (BF10+RTYPE2),A      ; loeschen 
  72D9    32 8077                       LD (BF10+RTERM),A       ; loeschen 
  72DC    32 8078                       LD (BF10+RBSTAT),A      ; loeschen 
  72DF    AF                            XOR A
  72E0    32 650B                       LD (BFVHH),A    ; Aktuelle Track/Sectoradresse laden
  72E3    32 650A                       LD (BFVHL),A
  72E6    21 0801                       LD HL,HDD+1     ; Startadresse
  72E9    22 6508                       LD (BFVLL),HL   ; Aktuelle Track/Sectoradresse laden
                                ;-------------------------
                                ; Blase zum vergleich laden und Text in Speicher suchen
                                ;
  72EC    C5                    SU00:   PUSH BC
  72ED    D5                            PUSH DE
  72EE    E5                            PUSH HL
  72EF    CD 7832                       CALL COFF
  72F2    06 50                         LD B,80D
  72F4    21 6B27                       LD HL,RAMT
  72F7    11 6BEF                       LD DE,RTEX
  72FA    7E                    STX01:  LD A,(HL)
  72FB    12                            LD (DE),A
        MACRO-80 3.43   27-Jul-81       PAGE    1-14


  72FC    23                            INC HL
  72FD    13                            INC DE
  72FE    10 FA                         DJNZ STX01
  7300    ED 4B 6508            SU01:   LD BC,(BFVLL)
  7304    ED 5B 650A                    LD DE,(BFVHL)           ; Suchadresse 
  7308    21 6527                       LD HL,RAMV
  730B    CD 7DF8                       CALL RDREAD             ; AKTUELLE BLASE LADEN
                                        ; READ SICHTBAR MACHEN
  730E    01 1501                       LD BC,1501H
  7311    CD 7018                       CALL T8
  7314    21 6527                       LD HL,RAMV
  7317    CD 7B08                       CALL LIS0
  731A    E5                            PUSH HL
  731B    21 0801                       LD HL,HDD+1
  731E    22 6510                       LD (BFSLL+4),HL
  7321    21 0000                       LD HL,0000H
  7324    22 6512                       LD (BFSHL+4),HL
  7327    E1                            POP HL
                                        ;---------------------
                                        ; Cursor drehen lassen und
                                        ; nach Abstand gefundener Zeichen setzen
  7328    CD 7EC0                       CALL UHR00
  732B    3E 02                         LD A,02H
  732D    32 651C                       LD (CURT),A
  7330    3E 04                         LD A,04H
  7332    32 651D                       LD (CURT+1),A
  7335    3E 02                         LD A,02H
  7337    32 651E                       LD (CURT+2),A
  733A    3A 6B27                       LD A,(RAMT)
  733D    FE 0A                         CP 0AH
  733F    38 0E                         JR C,SU02
  7341    D6 0A                         SUB 0AH
  7343    32 651F                       LD (CURT+3),A
  7346    3A 651E                       LD A,(CURT+2)
  7349    3C                            INC A
  734A    32 651E                       LD (CURT+2),A
  734D    18 03                         JR SU03
  734F    32 651F               SU02:   LD (CURT+3),A
                                        ;------------------------
                                        ; vergleich, suche nach Blasen beginnen
                                        ;
  7352    CD 77DB               SU03:   CALL CUT
  7355    21 6527                       LD HL,RAMV              ; in Blase suchen mit
  7358    11 6B27                       LD DE,RAMT              ; Textanfang 1. Zeichen
  735B    1A                            LD A,(DE)               ; neue TextLAENGE mit
  735C    FE 02                         CP 02H                  ; Suchtext muss > 1 Zeichen sein
  735E    DA 74B9                       JP C,SU52               ; Ausgang ohne suchtext
  7361    23                            INC HL                  ; ZU USER 
  7362    3A 8048                       LD A,(BF00+RUSER)       ; Aus sichtbarer aktuel Blase
  7365    BE                            CP (HL)                 ; RAMV VERGLEICH MIT USER IN BLASE 
                                        ;JP Z,SU80              ; User mit Blase ist gleich 
                                        ;JP NC,SU62             ; ERST IN USER+1 LEERE BLASE SUCHEN
  7366    3A 652B               SU04:   LD A,(RAMV+RTERM)       ; Gedaechtnisszaehler
  7369    FE FF                         CP 0FFH                 ; nach leerer ,abgelaufener Blase 
  736B    C2 742F                       JP NZ,SU62              ; noch nicht leer, abgelaufen
  736E    3A 6003                       LD A,(RAM+RTYPE2)       ; MUSS BLASENANFANG SEIN
        MACRO-80 3.43   27-Jul-81       PAGE    1-15


  7371    FE 00                         CP 0H                   ; nach leerer ,abgelaufener Blase 
  7373    C2 74B9                       JP NZ,SU52              ; noch nicht leer, abgelaufen
                                ;-----------------------
                                ; neue Blase Eroeffnen mit Eingabetext 
                                ; als Ueberschrift
                                ;
                                ; Blasenadr. BFVxx mit BFRxx tauschen (HL)->(DE)
                                ;               
  7376    11 6500                       LD DE,BFRLL     ; Aktuelle Blaseadresse ersetzen durch
  7379    21 6508                       LD HL,BFVLL     ; Leere gefundene Blase
  737C    EB                            EX DE,HL        ; TAUSCHEN
                                        ;----------------
  737D    3A 8076                       LD A,(BF10+RTYPE2)
  7380    FE 00                         CP 0H
  7382    28 18                         JR Z,SU85
  7384    18 16                         JR SU85         ;!!!! HIER RAUS
  7386    06 19                         LD B,25D                ; laenge DES KOPFTEXT AUS Blase einkopieren
  7388    11 601B                       LD DE,RAM+1BH   ; Adr. Aktueller Blase
  738B    21 842B                       LD HL,TBLASE+1BH        ; Textblock leerer Blase
  738E    1A                    SU88:   LD A,(DE)
  738F    77                            LD (HL),A
  7390    23                            INC HL
  7391    13                            INC DE
  7392    10 FA                         DJNZ SU88
  7394    06 F2                         LD B,TBLLE      ; laenge neuer Blase einkopieren
  7396    11 6000                       LD DE,RAM       ; Adr. Aktueller Blase
  7399    21 8410                       LD HL,TBLASE    ; Textblock leerer Blase
                                        ;!!!JP SU82
                                        ;---------------
                                        ; Ueberschrift aus suchtext einsetzen
  739C    01 0101               SU85:   LD BC,NBLLE     ; copy length of new block
  739F    11 6000                       LD DE,RAM
  73A2    21 830F                       LD HL,NBLASE
  73A5    ED B0                         LDIR
  73A7    CD 79C7                       CALL MASK1
  73AA    3A 6B27                       LD A,(RAMT)
  73AD    47                            LD B,A          ; Textlaenge in B
  73AE    11 6000                       LD DE,RAM
  73B1    13                    SU83:   INC DE          ; Nach Space 20H suchen erstes Zeichen
  73B2    1A                            LD A,(DE)
  73B3    FE 20                         CP 20H
  73B5    20 FA                         JR NZ,SU83
                                        ;-----------------
  73B7    21 6B28                       LD HL,RAMT+1    ; erstes Zeichen
  73BA    7E                    SU84:   LD A,(HL)               ; uebertrageb bis B=0
  73BB    12                            LD (DE),A
  73BC    23                            INC HL
  73BD    13                            INC DE
  73BE    10 FA                         DJNZ SU84
                                        ;-----------------      
                                        ; BF10 IN NEU GEFUNDENE BLASE ]BERNEHMEN
                                        ; RUSER, RTYPE1+1, RTYPE2
                                        ;
  73C0    3A 8074                       LD A,(BF10+RUSER)
  73C3    32 6001                       LD (RAM+RUSER),A        ; Aktueller USER uebernehmen
  73C6    3A 8076                       LD A,(BF10+RTYPE2)
        MACRO-80 3.43   27-Jul-81       PAGE    1-16


  73C9    FE 00                         CP 0
  73CB    28 0B                         JR Z,SU86
  73CD    3A 8049                       LD A,(BF00+RTYPE1)      ; uebernehmen 
  73D0    32 6002                       LD (RAM+RTYPE1),A       ; uebernehmen 
  73D3    3A 8076                       LD A,(BF10+RTYPE2)      ; uebernehmen 
                                        ;LD (RAM+RTYPE2),A      ; uebernehmen 
  73D6    18 0D                         JR SU87 
  73D8    3A 8075               SU86:   LD A,(BF10+RTYPE1)      ; uebernehmen 
  73DB    3C                            INC A
  73DC    32 6002                       LD (RAM+RTYPE1),A       ; uebernehmen 
  73DF    3A 8076                       LD A,(BF10+RTYPE2)      ; uebernehmen 
  73E2    32 6003                       LD (RAM+RTYPE2),A       ; uebernehmen 
                                        ;------------------
  73E5    E1                    SU87:   POP HL
  73E6    D1                            POP DE
  73E7    C1                            POP BC
  73E8    C3 70AF                       JP BL00
                                        ; ENDE neue Blase anspringen
                                        ;--------------------------
                                        ; weiter vergleichen
                                
  73EB    23                    SU80:   INC HL          ; zu TYPE1 in RAMV
  73EC    23                            INC HL          ; ZU TYPE2 IN RAMV
  73ED    3A 8076                       LD A,(BF10+RTYPE2)
                                        ;CP (HL)
  73F0    B6                            OR (HL)
  73F1    CA 7472                       JP Z,SU90
  73F4    23                            INC HL          ; Gedaechtnisz. TERM 
  73F5    3A 8077                       LD A,(BF10+RTERM)       ; 
  73F8    BE                            CP (HL)
  73F9    CA 742F                       JP Z,SU62               ; nicht =1
  73FC    23                            INC HL          ; Status Byte
  73FD    23                            INC HL          ; ZEICHENAUSWERTUNG
  73FE    13                            INC DE          ; ERSTES SUCHZEICHEN IN RAMT
  73FF    1A                            LD  A,(DE)              ; 1. ZEICHEN MUSS '/' SEIN
  7400    FE 2F                         CP '/'
  7402    28 07                         JR Z,SU25
  7404    AF                            XOR A
  7405    32 8076                       LD (BF10+RTYPE2),A      ; '/' fehlt dann TYPE2=0 und TYPE1 SUCHEN
  7408    C3 742F                       JP SU62         ; WEITER NACH TYPE1+TYPE2=0 SUCHEN->
                                        ;------------
  740B    3A 6002               SU25:   LD A,(RAM+RTYPE1)
  740E    47                            LD B,A
  740F    3A 6529                       LD A,(RAMV+RTYPE1)
  7412    B8                            CP B
  7413    C2 742F                       JP NZ,SU62
  7416    3A 652A                       LD A,(RAMV+RTYPE2)
  7419    FE 01                         CP 1H
  741B    DA 742F                       JP C,SU62
  741E    C2 742F                       JP NZ,SU62
  7421    3A 6B27                       LD A,(RAMT)     ; neuer Text mit
  7424    06 3F                         LD B,03FH               ; laenge (255D) eine Zeile zum vergleichen
  7426    CD 78FD               SU21:   CALL SUCH0
  7429    DA 742F                       JP C,SU62
                                        ;CALL MAS00
  742C    C3 74DB                       JP SU23
        MACRO-80 3.43   27-Jul-81       PAGE    1-17


                                        ; Error anzeigen ??
                                        ; Bereich Ende xxxxxxxx1, xxxxxxx2, .... ????
                                        ; noch einbauen
                                        ;
  742F    CD 79F6               SU62:   CALL KEYST      ; CONSOLE AUF ZEICHEN ABFRAGE
  7432    FE 1B                         CP 1BH
  7434    CA 74B9                       JP Z,SU52       ; ABBRUCH MIT ESC
  7437    ED 5B 6508                    LD DE,(BFVLL)   ; Aktuelle Track/Sectoradresse laden
  743B    D5                            PUSH DE
  743C    2A 650A                       LD HL,(BFVHL)
  743F    E5                            PUSH HL
  7440    CD 7A0A                       CALL LBA0               ; Suchadresse +1
  7443    E1                            POP HL
  7444    22 650A                       LD (BFVHL),HL   
  7447    D1                            POP DE
  7448    ED 53 6508                    LD (BFVLL),DE           ; Suchadresse speichern
  744C    38 6B                         JR C,SU52       ; CARRY -> ENDE
  744E    18 11                         JR SU63
                                        ;--------------
  7450    ED 4B 8071                    LD BC,(BF07+2)          ; HL
  7454    ED 42                         SBC HL,BC
  7456    38 09                         JR C,SU63
  7458    EB                            EX DE,HL
  7459    ED 4B 806F                    LD BC,(BF07)            ; LL
  745D    ED 42                         SBC HL,BC               
  745F    30 58                         JR NC,SU52              ; LETZTE SUCHADRESSE AUS TAS00 
  7461    7B                    SU63:   LD A,E
  7462    E6 1F                         AND 1FH
  7464    FE 10                         CP 10H
  7466    C2 7300                       JP NZ,SU01
  7469    CD 77DB                       CALL CUT
  746C    CD 77BB                       CALL SANDU
  746F    C3 7300                       JP SU01
                                        ;--------------------------
                                        ; weiter vergleichen
                                        ; fuer naechste neue Blase vorbereiten 
                                        ; und in neuer Blase uebernehmen
  7472    2B                    SU90:   DEC HL          ; ZURUECK ZU TYPE1
  7473    3A 8075                       LD A,(BF10+RTYPE1)      ; Type1 
  7476    BE                            CP (HL)
  7477    30 09                         JR NC,SU99
  7479    3C                            INC A
  747A    28 06                         JR Z,SU99               ; groesser 0FFH
  747C    BE                            CP (HL)
  747D    20 03                         JR NZ,SU99              ; Abstand groesser 1
  747F    32 8075                       LD (BF10+RTYPE1),A      ; Type1 wenn groesser uebernehmen
  7482    23                    SU99:   INC HL          ; Type2 in Blase
                                ;--------------------------
                                ;       hier auf erste Type2 =0 selektiert aus Blase
                                ;
  7483    3A 8076                       LD A,(BF10+RTYPE2)      ; Type2 aus RAMV Blase
  7486    BE                            CP (HL)
  7487    C2 742F                       JP NZ,SU62              ; NEUE RAMV BLASE nicht =0 
                                ;--------------------------
                                ; wenn Gedaechtnisszaehler =0 dann ungueltig
                                ; frei fuer neue Blase
        MACRO-80 3.43   27-Jul-81       PAGE    1-18


  748A    23                            INC     HL              ; Gedaechtnisz. TERM 
  748B    3A 8077                       LD      A,(BF10+RTERM)  ; Gedaechtnisz. aus Blase
  748E    BE                            CP      (HL)
  748F    CA 742F                       JP      Z,SU62          ; nicht =1 ->
  7492    23                            INC     HL              ; Status Byte
  7493    23                            INC     HL              ; ZeichenGROESSE
  7494    1A                            LD      A,(DE)          ; neuer Text mit
  7495    47                            LD      B,A
  7496    13                            INC     DE              ; ERSTES ZEICHEN
                                        ;--------------------
                                        ; ERSTES ZEICHEN GROSS
  7497    1A                            LD      A,(DE)
  7498    FE 5B                         CP      5BH
  749A    D2 74B9                       JP      NC,SU52         ; ERSTES ZEICHEN MUSS GROSS BUCHST.SEIN
                                        ;--------------------
  749D    78                            LD      A,B
  749E    06 3F                         LD      B,3FH           ; laenge (46D) eine Zeile zum vergleichen
  74A0    CD 78FD                       CALL    SUCH0
  74A3    DA 742F                       JP      C,SU62
  74A6    3A 6529                       LD      A,(RAMV+RTYPE1) ; WENN BLASE GEFUNDEN TYPE1 UEBERNEHMEN
  74A9    32 8075                       LD      (BF10+RTYPE1),A ; Type1 =0 wenn BLASE GEFUNDEN
  74AC    3A 8076                       LD      A,(BF10+RTYPE2) ; BLASE TYPE1 GEFUNDEN
  74AF    3C                            INC     A               ;SET    0,A >0 SETZEN F]R TYPE2 SUCHEN
  74B0    32 8076                       LD      (BF10+RTYPE2),A
  74B3    C3 74DB                       JP      SU23
                                ;-----------------------
                                ; Kein Eintrag in TYPE2>0 gefunden
                                ;       
  74B6    C3 70AF               SU95:   JP BL00
                                ;----------------
                                ;
  74B9    21 828E               SU52:   LD HL,MELD01
  74BC    06 36                         LD B,MELD01X
  74BE    0E 02                         LD C,02H                ; BIOS Console Output
  74C0    CD 803B                       CALL BIOS
  74C3    11 0000                       LD DE,0000H
  74C6    06 08                         LD B,08H
  74C8    3E 00                         LD A,00H
  74CA    32 6B27                       LD (RAMT),A
  74CD    15                    SU520:  DEC D
  74CE    20 FD                         JR NZ,SU520
  74D0    1D                            DEC E
  74D1    20 FA                         JR NZ,SU520
  74D3    10 F8                         DJNZ SU520
  74D5    E1                            POP HL
  74D6    D1                            POP DE
  74D7    C1                            POP BC
  74D8    C3 70AF                       JP BL00
                                        ;----------------
                                        ; AKTUELLE MIT GEFUNDENE BLASE TAUSCHEN
                                        ; DANN NEUE BLASE ANZEIGEN      
  74DB    06 04                 SU23:   LD B,04H
  74DD    11 6500                       LD DE,BFRLL
  74E0    21 6508                       LD HL,BFVLL
  74E3    7E                    SU32:   LD A,(HL)
  74E4    12                            LD (DE),A
        MACRO-80 3.43   27-Jul-81       PAGE    1-19


  74E5    23                            INC HL
  74E6    13                            INC DE 
  74E7    10 FA                         DJNZ SU32
                                        ; EINGABEZEILE LOESCHEN
  74E9    01 2401                       LD BC,2401H
  74EC    CD 7018                       CALL T8
  74EF    06 46                         LD B,70D
  74F1    3E 20                 SU33:   LD A,20H
  74F3    CD 7812                       CALL HEXC
  74F6    10 F9                         DJNZ SU33
  74F8    E1                            POP HL
  74F9    D1                            POP DE
  74FA    C1                            POP BC
  74FB    C3 7074                       JP BL
                                ;------------------------
                                ;       Starte Eingabemode
                                ;
  74FE    C5                    EING:   PUSH BC
  74FF    D5                            PUSH DE
  7500    E5                            PUSH HL
                                        ;------------------------
                                        ; pruefe auf Anfangsadresse BLASE = RAM
                                        ;       
  7501    2A 6524                       LD HL,(RADR)    ; zuletzten Blasenabschnitt Adr.0
  7504    3E 00                         LD A,00H
  7506    32 6B27                       LD (RAMT),A     ; ZEICHEN EINGABEZAEHLER AUF 0 SETZEN
  7509    BE                            CP (HL)
  750A    20 18                         JR NZ,ED00
  750C    AF                            XOR A
  750D    11 6000                       LD DE,RAM
  7510    ED 52                         SBC HL,DE
  7512    20 34                         JR NZ,ED10              ; -> ADRESSE NICHT GLEICH
                                        ;--------------------
                                        ; (RADR) = RAM und kein Zechen 
                                        ; dann Blase mit 00H ueberschreiben 2*256lang
                                        ;
  7514    06 00                         LD B,00H
  7516    3E 00                 ED01:   LD A,00H                ; RAM 256 auf null setzen
  7518    77                            LD (HL),A
  7519    23                            INC HL
  751A    10 FA                         DJNZ ED01
  751C    06 00                         LD B,00H
  751E    3E 00                 ED02:   LD A,00H                ; RAM 256 auf null setzen
  7520    77                            LD (HL),A
  7521    23                            INC HL
  7522    10 FA                         DJNZ ED02
                                        ;---------------------
                                        ; Blasenanfang bestimmen
                                        ;
  7524    2A 6524               ED00:   LD HL,(RADR)
                                ;       LD B,(HL)
  7527    06 F0                         LD B,0F0H               ; Max Zeicheneingabe
  7529    AF                            XOR A
  752A    11 6000                       LD DE,RAM
  752D    ED 52                         SBC HL,DE
  752F    2A 6524                       LD HL,(RADR)
        MACRO-80 3.43   27-Jul-81       PAGE    1-20


  7532    20 14                         JR NZ,ED10              ; -> kein Blasenanfang
  7534    23                            INC HL
  7535    3A 6201                       LD A,(USER)     ; in Blase uebernemen
  7538    77                            LD (HL),A
  7539    23                            INC HL
  753A    3A 6202                       LD A,(TYPE1)
  753D    77                            LD (HL),A
  753E    23                            INC HL
  753F    3A 6203                       LD A,(TYPE2)
  7542    77                            LD (HL),A
  7543    23                            INC HL          ; Gedaechtniss Zaehler
  7544    3E 7F                         LD A,07FH               ; auf 50% setzen
  7546    77                            LD (HL),A
  7547    23                            INC HL          ; Status Byte
                                        ;------------------------
                                        ;  Grafik/Text ausgeben
                                        ;
  7548    C5                    ED10:   PUSH BC
  7549    01 0301                       LD BC,0301H
  754C    CD 7018                       CALL T8
  754F    2A 6524                       LD HL,(RADR)
  7552    3A 6B27                       LD A,(RAMT)
  7555    3C                            INC A
  7556    47                            LD B,A
  7557    AF                            XOR A           ; RES CARRY FLAG
  7558    11 6000                       LD DE,RAM
  755B    ED 52                         SBC HL,DE       ; Blasen Anfang pruefen
  755D    2A 6524                       LD HL,(RADR)
  7560    20 0E                         JR NZ,ED100
  7562    3E 05                         LD A,05H
  7564    85                            ADD A,L         ; Versatz an Blasenanfang
  7565    6F                            LD L,A          ; USER, TYPE1, TYPE2, GE, GS, 
  7566    3E 00                         LD A,00H
  7568    32 651C                       LD (CURT),A
  756B    3E 01                         LD A,01H
  756D    32 651D                       LD (CURT+1),A
  7570    CD 77DB               ED100:  CALL CUT
  7573    23                    ED11:   INC HL          ; erstes Zeichen
  7574    10 03                         DJNZ ED03
  7576    C1                            POP BC
  7577    18 0C                         JR ED12
                                        ;----------------
                                        ; Zeichen ausgeben
                                        ;
  7579    C5                    ED03:   PUSH BC
  757A    E5                            PUSH HL
  757B    5E                            LD E,(HL)
  757C    0E 02                         LD C,02H
  757E    CD 0005                       CALL 0005H
  7581    E1                            POP HL
  7582    C1                            POP BC
  7583    18 EE                         JR ED11
                                        ;---------------------
                                        ; Tasteneingabe
                                        ;       
  7585    C5                    ED12:   PUSH BC
        MACRO-80 3.43   27-Jul-81       PAGE    1-21


  7586    E5                            PUSH HL
  7587    CD 79F6               _ED12:  CALL KEYST
  758A    FE 00                         CP 0H
  758C    28 F9                         JR Z,_ED12      ; -> KEIN ZEICHEN
  758E    5F                            LD E,A          ; neues Zeichen
  758F    E1                            POP HL
  7590    C1                            POP BC
  7591    FE 20                         CP 20H
  7593    38 2E                         JR C,ED30       ; wenn Zeichen < 20H
  7595    FE 23                         CP 23H          ; # Zeichen fuer Eingabenende
  7597    CA 75BD                       JP Z,ED20
  759A    CD 7644                       CALL ED50
                                        ;-------------------
                                        ; Rechts Parameter anzeichen
                                        ;
  759D    7E                    ED13:   LD A,(HL)       ; letztes Zeichen zurueckladen
  759E    5F                            LD E,A          ; und Anzeigen aus Reg. E
  759F    C5                            PUSH BC
  75A0    01 0578                       LD BC,0578H
                                        ;CALL T8
  75A3    4E                            LD C,(HL)
  75A4    C5                            PUSH BC         ; IX HOLEN
  75A5    CD 779A                       CALL HEX14
  75A8    C1                            POP BC
  75A9    01 0473                       LD BC,0473H
  75AC    CD 7018                       CALL T8
  75AF    C1                            POP BC
  75B0    C5                            PUSH BC
  75B1    3A 6B27                       LD A,(RAMT)
  75B4    4F                            LD C,A
  75B5    C5                            PUSH BC         ; IX HOLEN
  75B6    CD 779A                       CALL HEX00
  75B9    C1                            POP BC
  75BA    C1                            POP BC
  75BB    10 03                 ED14:   DJNZ ED15               ; ED12
  75BD    C3 765B               ED20:   JP EING11
  75C0    C3 7548               ED15:   JP ED10
                                ;-------------------------
                                ; Steuerzeichen Auswerten
                                
  75C3    FE 0D                 ED30:   CP 0DH          ; CR
  75C5    28 2B                         JR Z,ED40
  75C7    FE 08                         CP 08H          ; Backspase
  75C9    28 32                         JR Z,ED41
  75CB    FE 09                         CP 09H
  75CD    28 3D                         JR Z,ED42               ; TAB
  75CF    FE 1B                         CP 1BH          ; ESC
  75D1    28 3E                         JR Z,ED43
  75D3    FE 08                         CP 08H          ; ESC
  75D5    28 3F                         JR Z,ED44               ; BackSpace
  75D7    C5                            PUSH BC
  75D8    E5                            PUSH HL
  75D9    06 80                         LD B,80H
  75DB    10 FE                 ED31:   DJNZ ED31
  75DD    CD 79F6                       CALL KEYST      ; CONSOLE AUF ZEICHEN ABFRAGE
  75E0    FE 00                         CP 0
        MACRO-80 3.43   27-Jul-81       PAGE    1-22


  75E2    28 0A                         JR Z,ED32
  75E4    C5                            PUSH BC
  75E5    4F                            LD C,A
  75E6    C5                            PUSH BC
  75E7    CD 779A                       CALL HEX14
  75EA    C1                            POP BC
  75EB    C1                            POP BC
  75EC    18 EB                         JR ED31-2
                                        ;-----------
  75EE    E1                    ED32:   POP HL
  75EF    C1                            POP BC
  75F0    18 AB                 ED33:   JR ED13
                                ;--------------------------
                                ;
  75F2    CD 7644               ED40:   CALL ED50
  75F5    23                            INC HL
  75F6    3E 0A                         LD A,0AH
  75F8    CD 7644                       CALL ED50
                                ;       INC HL
  75FB    18 F3                         JR ED33
                                        ;-------------
  75FD    3E 20                 ED41:   LD A,20H                ; Zeichen loeschen
  75FF    77                            LD (HL),A
  7600    3A 6B27                       LD A,(RAMT)
  7603    D6 01                         SUB 01H
  7605    38 E9                         JR C,ED33
  7607    32 6B27                       LD (RAMT),A
  760A    18 E4                         JR ED33
                                        ;-----------
  760C    CD 7644               ED42:   CALL ED50
                                ;       INC HL
  760F    18 DF                         JR ED33
                                        ;------------
  7611    CD 7644               ED43:   CALL ED50
                                ;       INC HL
  7614    18 DA                         JR ED33
                                        ;-----------
  7616    E5                    ED44:   PUSH HL
  7617    C5                            PUSH BC
  7618    3A 6524                       LD A,(RADR)
  761B    FE 00                         CP 00H
  761D    28 21                         JR Z,ED442
  761F    3A 6B27                       LD A,(RAMT)
  7622    FE 00                         CP 00H
  7624    28 1A                         JR Z,ED442
  7626    01 0002                       LD BC,0002H
  7629    7E                    ED441:  LD A,(HL)
  762A    2B                            DEC HL
  762B    77                            LD (HL),A
  762C    23                            INC HL
  762D    23                            INC HL
  762E    10 F9                         DJNZ ED441
  7630    0D                            DEC C
  7631    20 F6                         JR NZ,ED441
  7633    2A 6524                       LD HL,(RADR)
  7636    35                            DEC (HL)
        MACRO-80 3.43   27-Jul-81       PAGE    1-23


  7637    2A 6B27                       LD HL,(RAMT)
  763A    35                            DEC (HL)
  763B    C1                            POP BC
  763C    E1                            POP HL
  763D    2B                            DEC HL
  763E    18 B0                         JR ED33
                                        ;-----------
  7640    C1                    ED442:  POP BC
  7641    E1                            POP HL
  7642    18 AC                         JR ED33
                                ;--------------------------
                                ; Zeichenzaehler vergleichen
                                ; RAM-Aktuell mit RAM-Text
  7644    77                    ED50:   LD (HL),A
  7645    3A 6B27                       LD A,(RAMT)
  7648    3C                            INC A
  7649    32 6B27                       LD (RAMT),A
  764C    C9                            RET
                                        ;--------
  764D    4F                            LD C,A
  764E    E5                            PUSH HL
  764F    2A 6524                       LD HL,(RADR)
  7652    7E                            LD A,(HL)
  7653    B9                            CP C
  7654    D2 7659                       JP NC,ED51              ; RAMT > RADR dann RADR+1
  7657    3C                            INC A
  7658    77                            LD (HL),A
  7659    E1                    ED51:   POP HL
  765A    C9                            RET
                                        ;-----------------------
                                        ; KEY Stepps Eingabe in HEX
                                        ; 
  765B    E5                    EING11: PUSH HL
  765C    2A 6524                       LD HL,(RADR)
  765F    3A 6B27                       LD A,(RAMT)
  7662    77                            LD (HL),A
  7663    21 8271                       LD HL,KEYZ
  7666    06 1D                         LD B,KEYZX
  7668    0E 02                         LD C,02H                ; BIOS Console Output
  766A    CD 803B                       CALL BIOS
                                        ;------------------------
  766D    E1                            POP HL
  766E    C5                            PUSH BC
  766F    4E                            LD C,(HL)               ; Speicher Lesen 
  7670    C5                            PUSH BC
  7671    CD 779A                       CALL HEX00
  7674    C1                            POP BC
  7675    C1                            POP BC
  7676    E5                            PUSH HL
  7677    CD 7B15                       CALL TAS
  767A    5F                            LD E,A
  767B    CD 7738                       CALL HEXI1
  767E    D5                            PUSH DE
  767F    CD 7B15                       CALL TAS
  7682    D1                            POP DE
  7683    5F                            LD E,A
        MACRO-80 3.43   27-Jul-81       PAGE    1-24


  7684    CD 774B                       CALL HEXI2
  7687    E1                            POP HL
                                ;       LD D,10H
  7688    72                            LD (HL),D
  7689    23                            INC HL
                                        ;-----------------
                                        ; Dateiaufruf
                                        ; Text ausgeben
                                        ;
  768A    E5                    EING21: PUSH HL
  768B    21 82C4                       LD HL,PROZ
  768E    06 25                         LD B,PROZX
  7690    0E 02                         LD C,02H                ; BIOS Console Output
  7692    CD 803B                       CALL BIOS
                                        ;------------------------
  7695    06 0C                         LD      B,0CH           ; Dateinamenlaenge
  7697    0E 00                         LD      C,00H           ; loeschen
  7699    E1                            POP     HL
  769A    C5                    EING22: PUSH    BC
  769B    D5                            PUSH    DE
  769C    5E                            LD      E,(HL)          ; Speicher Lesen 
  769D    E5                            PUSH    HL
  769E    D5                            PUSH    DE
  769F    C5                            PUSH BC
  76A0    4B                            LD C,E
  76A1    C5                            PUSH BC
  76A2    CD 779A                       CALL    HEX00           ; HEX Anzeigen
  76A5    C1                            POP BC
  76A6    C1                            POP BC
  76A7    CD 7B15                       CALL    TAS     ; ZEICHEN EINGABE
  76AA    D1                            POP     DE
  76AB    E1                            POP     HL
  76AC    77                            LD      (HL),A          ; Tasteneingabee retten
  76AD    D1                            POP     DE
  76AE    C1                            POP     BC
  76AF    FE 2E                         CP      2EH             ; Dateineman Ende
  76B1    20 02                         JR      NZ,EING23       ; -> noch nicht
  76B3    06 04                         LD      B,04H           ; Zaehler aus Erweiterung set
  76B5    3E 0C                 EING23: LD      A,0CH           ; Dateinamenlaenge
  76B7    B8                            CP      B
  76B8    20 1A                         JR      NZ,EING25       ; -> kein Anfang mehr
  76BA    7E                            LD      A,(HL)          ; Tastein ASCII -> 0-9 unr.
  76BB    D6 30                         SUB     30H
  76BD    38 2E                         JR      C,EING26
  76BF    FE 0A                         CP      0AH
  76C1    38 02                         JR      C,EING24
  76C3    D6 07                         SUB     07H
  76C5    E6 0F                 EING24: AND     0FH
  76C7    4F                            LD      C,A
  76C8    77                            LD      (HL),A          ; Speichern
  76C9    FE 00                         CP      00H
  76CB    28 20                         JR      Z,EING26        ; Ende -> Ausgang
  76CD    E5                            PUSH    HL
  76CE    D1                            POP     DE              ; HL -> DE
  76CF    13                            INC     DE
  76D0    3E FF                         LD      A,0FFH
        MACRO-80 3.43   27-Jul-81       PAGE    1-25


  76D2    12                            LD      (DE),A
  76D3    23                            INC     HL
  76D4    23                    EING25: INC     HL
  76D5    1A                            LD      A,(DE)
  76D6    3C                            INC     A
  76D7    12                            LD      (DE),A          ; Dateiname Zeichezaehler +1
  76D8    10 C0                         DJNZ    EING22
  76DA    47                            LD      B,A             ; naechste Dateiadresse berechnen
  76DB    3E 0C                         LD      A,0CH
  76DD    90                            SUB     B
  76DE    16 00                         LD      D,00H
  76E0    5F                            LD      E,A
  76E1    19                            ADD     HL,DE
  76E2    E5                            PUSH    HL
  76E3    D1                            POP     DE
  76E4    3E 00                         LD      A,00H
  76E6    12                            LD      (DE),A
  76E7    23                            INC     HL
  76E8    06 0B                         LD      B,0BH
  76EA    0D                            DEC     C
  76EB    20 AD                         JR      NZ,EING22
  76ED    06 0F                 EING26: LD      B,0FH
  76EF    AF                    EING27: XOR     A
  76F0    77                            LD      (HL),A
  76F1    23                            INC     HL
  76F2    10 FB                         DJNZ    EING27
  76F4    C3 70AF                       JP BL00         ; PUSH POP ???
  76F7    E1                    EING30: POP HL
  76F8    D1                            POP DE
  76F9    C1                            POP BC
  76FA    C3 70AF                       JP BL00
                                ;-------------------------
                                ; TYPE2 MASKE AUFBAUEN
                                
  76FD    3A 6000               MAS00:  LD A,(RAM)
  7700    47                            LD B,A          ; ZEICHENL$NGE ZUM ANHAENGEN
                                        ; CURSOR AUF XXXXZEILE 1 SETZEN
  7701    3E 00                         LD A,00H
  7703    32 651C                       LD (CURT),A
  7706    3E 01                         LD A,01H
  7708    32 651D                       LD (CURT+1),A
                                        ;------------------
                                        ; CURSOR RECHTR SCHIEBEN
                                
  770B    3E 00                         LD A,00H
  770D    3C                    MAS01:  INC A
  770E    27                            DAA
  770F    10 FC                         DJNZ MAS01
  7711    47                            LD B,A
  7712    E6 0F                         AND 0FH
  7714    32 651F                       LD (CURT+3),A
  7717    78                            LD A,B
  7718    0F                            RRCA
  7719    0F                            RRCA
  771A    0F                            RRCA
  771B    0F                            RRCA
        MACRO-80 3.43   27-Jul-81       PAGE    1-26


  771C    E6 0F                         AND 0FH
  771E    32 651E                       LD (CURT+2),A
  7721    CD 77DB                       CALL CUT
  7724    11 6B27                       LD DE,RAMT
  7727    1A                            LD A,(DE)
  7728    47                            LD B,A
  7729    13                    MAS02:  INC DE
  772A    1A                            LD A,(DE)
  772B    CD 7812                       CALL HEXC
  772E    10 F9                         DJNZ MAS02
  7730    C9                            RET     
  7731    C3 74B9                       JP SU52
                                ;-------------------------
                                ; Programmaufruf mit Cursor up/down
                                
  7734    00                    ZEI00:  NOP
  7735    C3 71F3                       JP      BL132
                                
                                ;-------------------------
                                ;   Hexunwandlung
                                
  7738    7B                    HEXI1:  LD A,E          ; Eingabe Umwandeln
  7739    D6 30                         SUB 30H
  773B    38 1D                         JR C,HEXIE
  773D    FE 0A                         CP 0AH
  773F    38 02                         JR C,HEX11
  7741    D6 07                         SUB 07H
  7743    07                    HEX11:  RLCA
  7744    07                            RLCA
  7745    07                            RLCA
  7746    07                            RLCA
  7747    E6 F0                         AND 0F0H
  7749    57                            LD D,A
  774A    C9                            RET
                                        ;-----------
  774B    7B                    HEXI2:  LD A,E          ; Adresse anzeigen
  774C    D6 30                         SUB 30H
  774E    38 0A                         JR C,HEXIE
  7750    FE 0A                         CP 0AH
  7752    38 02                         JR C,HEX12
  7754    D6 07                         SUB 07H
  7756    E6 0F                 HEX12:  AND 0FH
                                        ;ADD A,D        ; ??
                                        ;LD D,A ; ??
  7758    5F                            LD E,A
  7759    C9                            RET
                                        ;--------
  775A    06 01                 HEXIE:  LD B,01H
  775C    C9                            RET
                                ;-------------------------
                                ;  HEX Ausgabe mit Position
                                ;
  775D    3A 651C               HEXP:   LD A,(CURT)
  7760    F5                            PUSH AF
  7761    3A 651D                       LD A,(CURT+1)
  7764    F5                            PUSH AF
        MACRO-80 3.43   27-Jul-81       PAGE    1-27


  7765    3A 651E                       LD A,(CURT+2)
  7768    F5                            PUSH AF
  7769    3A 651F                       LD A,(CURT+3)
  776C    F5                            PUSH AF
  776D    C5                            PUSH BC
  776E    01 0150                       LD BC,0150H
  7771    CD 7018                       CALL T8
  7774    4B                            LD C,E
  7775    C5                            PUSH BC
  7776    CD 779A                       CALL HEX00
  7779    C1                            POP BC
  777A    C1                            POP BC
  777B    F1                            POP AF
  777C    32 651F                       LD (CURT+3),A
  777F    F1                            POP AF
  7780    32 651E                       LD (CURT+2),A
  7783    F1                            POP AF
  7784    32 651D                       LD (CURT+1),A
  7787    F1                            POP AF
  7788    32 651C                       LD (CURT),A
  778B    CD 77DB                       CALL CUT
  778E    C9                            RET
                                ;-------------------------
                                ;  Hex ausgeben
  778F    3E 0A                 HEXA:   LD A,0AH
  7791    CD 7812                       CALL HEXC
  7794    3E 0D                         LD A,0DH
  7796    CD 7812                       CALL HEXC
  7799    C9                            RET
                                ;------------------
  779A                          HEX00:  
  779A    DD E5                 HEX14:  PUSH IX
  779C    DD 21 0000                    LD IX,0
  77A0    DD 39                         ADD IX,SP
                                ;---------
  77A2    F5                            PUSH AF
  77A3    C5                            PUSH BC
  77A4    DD 4E 04                      LD C,(IX+4)             ; Adresse anzeigen
  77A7    C5                            PUSH BC
  77A8    CD 7F1A                       CALL ASCII_CODE
  77AB    C1                            POP BC
  77AC    78                            LD A,B
  77AD    CD 7812                       CALL HEXC
  77B0    79                            LD A,C          ; ADRESSE ANZEIGEN
  77B1    CD 7812                       CALL HEXC
  77B4    C1                            POP BC
  77B5    F1                            POP AF
                                ;-----------
  77B6    DD F9                         LD SP,IX
  77B8    DD E1                         POP IX
  77BA    C9                            RET
                                ;------------------------
                                ; Warte schlange
                                
  77BB    C5                    SANDU:  PUSH BC
  77BC    D5                            PUSH DE
        MACRO-80 3.43   27-Jul-81       PAGE    1-28


  77BD    E5                            PUSH HL
  77BE    3A 6520                       LD A,(SANDB)
  77C1    FE 2F                         CP 2FH  
  77C3    38 06                         JR C,SA1
  77C5    28 08                         JR Z,SA2
  77C7    3E 2D                         LD A,2DH
  77C9    18 06                         JR SA3
  77CB    3E 2F                 SA1:    LD A,2FH
  77CD    18 02                         JR SA3
  77CF    3E 5C                 SA2:    LD A,5CH
  77D1    32 6520               SA3:    LD (SANDB),A
  77D4    CD 7812                       CALL HEXC
  77D7    E1                            POP HL
  77D8    D1                            POP DE
  77D9    C1                            POP BC
  77DA    C9                            RET
                                ;------------------------
                                ; Cursor auf Position setzen
                                ;
  77DB    F5                    CUT:    PUSH AF
  77DC    3E 1B                         LD A,1BH
  77DE    CD 7812                       CALL HEXC
  77E1    3E 5B                         LD A,5BH
  77E3    CD 7812                       CALL HEXC
  77E6    3A 651C                       LD A,(CURT)
  77E9    C6 30                         ADD A,30H
  77EB    CD 7812                       CALL HEXC
  77EE    3A 651D                       LD A,(CURT+1)
  77F1    C6 30                         ADD A,30H
  77F3    CD 7812                       CALL HEXC
  77F6    3E 3B                         LD A,3BH
  77F8    CD 7812                       CALL HEXC
  77FB    3A 651E                       LD A,(CURT+2)
  77FE    C6 30                         ADD A,30H
  7800    CD 7812                       CALL HEXC
  7803    3A 651F                       LD A,(CURT+3)
  7806    C6 30                         ADD A,30H
  7808    CD 7812                       CALL HEXC
  780B    3E 48                         LD A,48H
  780D    CD 7812                       CALL HEXC
  7810    F1                            POP AF
  7811    C9                            RET
                                ;------------------------
                                ;  Zeichen Ausgeben
                                ;
  7812    C5                    HEXC:   PUSH BC
  7813    D5                            PUSH DE
  7814    E5                            PUSH HL
  7815    5F                            LD E,A
  7816    F5                            PUSH AF
  7817    0E 02                         LD C,02H
  7819    CD 0005                       CALL 0005H
  781C    F1                            POP AF
  781D    E1                            POP HL
  781E    D1                            POP DE
  781F    C1                            POP BC
        MACRO-80 3.43   27-Jul-81       PAGE    1-29


  7820    C9                            RET
                                        ;--------------
                                        ; Cursor on
  7821    E5                    CON:    PUSH HL
  7822    C5                            PUSH BC
  7823    21 808F                       LD HL,CURON             ; CURSOR ON
  7826    06 06                         LD B,06H
  7828    7E                    CUR02:  LD A,(HL)
  7829    CD 7812                       CALL HEXC
  782C    23                            INC HL
  782D    10 F9                         DJNZ CUR02
  782F    C1                            POP BC
  7830    E1                            POP HL
  7831    C9                            RET
                                        ;--------------
                                        ; Cursor off
  7832    E5                    COFF:   PUSH HL
  7833    C5                            PUSH BC
  7834    21 8095                       LD HL,CUROFF            ; CURSOR OFF
  7837    06 06                         LD B,06D
  7839    7E                    CUR01:  LD A,(HL)
  783A    CD 7812                       CALL HEXC
  783D    23                            INC HL
  783E    10 F9                         DJNZ CUR01
  7840    C1                            POP BC
  7841    E1                            POP HL
  7842    C9                            RET
                                ;-----------------------
                                ;  DRIVE ZUGRIFF VORBEREITEN
  7843    DB FF                 WAITRDY:IN A,(IDESTAT)
  7845    CB 77                         BIT 6,A
  7847    28 FA                         JR Z,WAITRDY
  7849    CB 7F                         BIT 7,A
  784B    20 F6                         JR NZ,WAITRDY
  784D    C9                            RET
                                        ;----------
  784E                          WAITDRQ: 
  784E    DB FF                         IN A,(IDESTAT)
  7850    CB 5F                         BIT 3,A
  7852    28 FA                         JR Z,WAITDRQ
  7854    CB 7F                         BIT 7,A
  7856    20 F6                         JR NZ,WAITDRQ
  7858    C9                            RET
                                        ;----------
  7859                          HDD_WAIT:
                                        ;LD B,0
                                        ;DJNZ $
  7859    DB FF                 _WAIT1: IN A,(IDESTAT)
  785B    E6 80                         AND 80H
  785D    20 FA                         JR NZ,_WAIT1
  785F    C9                            RET
                                        ;-------------
  7860                          HDD_INIT:
  7860    3E 02                         LD A,02H
  7862    D3 FF                         OUT (IDECMD),A
  7864    CD 7859                       CALL HDD_WAIT
        MACRO-80 3.43   27-Jul-81       PAGE    1-30


                                ;-----
  7867    3E F0                         LD A,0F0H
  7869    D3 FE                         OUT (IDESDH),A
  786B    3E 01                         LD A,01H
  786D    D3 FA                         OUT (IDESCNT),A
  786F    3E EF                         LD A,0EFH
  7871    D3 FF                         OUT (IDECMD),A
  7873    CD 7859                       CALL HDD_WAIT
  7876    CD 787A                       CALL HDD_ERROR
  7879    C9                            RET
                                ;---------
  787A                          HDD_ERROR:
  787A    DB FF                         IN A,(IDESTAT)
  787C    4F                            LD C,A
  787D    C5                            PUSH BC
  787E    CD 779A                       CALL HEX00
  7881    C1                            POP BC
  7882    79                            LD A,C
  7883    E6 01                         AND 01H
  7885    C8                            RET Z
  7886    21 82E9                       LD HL,DERR
  7889    06 26                         LD B,L_DERR
  788B    7E                    ERR1:   LD A,(HL)
  788C    CD 7812                       CALL HEXC
  788F    23                            INC HL
  7890    10 F9                         DJNZ ERR1
  7892    C9                            RET
                                ;--------------
  7893                          HDD_INFO:
  7893    CD 7859                       CALL HDD_WAIT
  7896    3E EC                         LD A,0ECH
  7898    D3 FF                         OUT (IDECMD),A
  789A    21 1964                       LD HL,6500
  789D    CD 78A1                       CALL HDD_READ
  78A0    C9                            RET
                                ;-----------
  78A1                          HDD_READ:
  78A1    CD 7859                       CALL HDD_WAIT
  78A4    DB FF                         IN A,(IDESTAT)
  78A6    E6 08                         AND 08H
  78A8    C8                            RET Z
  78A9    DB F8                         IN A,(IDEDAT)
  78AB    77                            LD (HL),A
                                ;       CALL HEXC;!!! TESTAUSGABEN
  78AC    23                            INC HL
  78AD    18 F2                         JR HDD_READ
                                ;-------------
                                ; IDE-FESTPLATTE RESET
  78AF                          IDERES:
  78AF    CD 78B5                       CALL IDERES1
  78B2    C3 7859                       JP HDD_WAIT
                                        ;----------
  78B5    CD 7FF2               IDERES1:CALL EXTERN
  78B8    F5                            PUSH AF         ; PIOA
  78B9    C5                            PUSH BC
  78BA    3E 06                         LD A,06H
        MACRO-80 3.43   27-Jul-81       PAGE    1-31


  78BC    D3 F6                         OUT (IDEDOR),A
  78BE    06 00                         LD B,0
  78C0    10 FE                         DJNZ $
  78C2    3E 02                         LD A,02H
  78C4    D3 F6                         OUT (IDEDOR),A
  78C6    C1                            POP BC
  78C7    F1                            POP AF
  78C8    D3 1C                         OUT (PIOA),A
  78CA    C9                            RET 
                                ;-------------
  78CB    DD E5                 DISK:   PUSH IX
  78CD    DD 21 0000                    LD IX,0
  78D1    DD 39                         ADD IX,SP
                                ;--------
  78D3    DD 7E 05                      LD A,(IX+5)     ; D= HEAD SELECT, LBA HIGH MIT HIGH=B
  78D6    E6 0F                         AND 0FH         ; HEAD SELECT
  78D8    47                            LD B,A
  78D9    3E F7                         LD A,SELDS      ; IN INCLUDE
  78DB    E6 F0                         AND 0F0H
  78DD    B0                            OR B
  78DE    CB FF                         SET 7,A
  78E0    DD 77 05                      LD (IX+5),A
  78E3    D3 FE                         OUT (IDESDH),A
  78E5    DD 7E 04                      LD A,(IX+4)     ; TRACK HIGH
  78E8    D3 FD                         OUT (IDECHI),A
  78EA    DD 7E 07                      LD A,(IX+7)     ; TRACK LOW
  78ED    D3 FC                         OUT (IDECLO),A
  78EF    DD 7E 06                      LD A,(IX+6)     ; C= SECTOR
  78F2    D3 FB                         OUT (IDESNUM),A
  78F4    3E 01                         LD A,01H
  78F6    D3 FA                         OUT (IDESCNT),A
                                        ;----------
  78F8    DD F9                         LD SP,IX
  78FA    DD E1                         POP IX
  78FC    C9                            RET
                                ;-----------------------
                                ; ZEICHEN SUCHEN IM RAM AUS EINGABE RAMT
                                ;
  78FD    08                    SUCH0:  EX AF,AF'               ; Textlaenge retten
  78FE    1A                            LD A,(DE)               ; neuer Text mit
  78FF    BE                            CP (HL)         ; Blaseninhalt 
  7900    28 0B                         JR Z,SUCH2
  7902    23                            INC HL
  7903    3A 6B27                       LD A,(RAMT)
  7906    11 6B28                       LD DE,RAMT+1
  7909    10 F2                         DJNZ SUCH0
  790B    37                    SUCH1:  SCF
  790C    C9                            RET
                                        ;------------
  790D    13                    SUCH2:  INC DE
  790E    23                            INC HL
  790F    3E 2A                         LD A,2AH
  7911    CD 7812                       CALL HEXC
  7914    08                            EX AF,AF'
  7915    3D                            DEC A
  7916    20 E5                         JR NZ,SUCH0
        MACRO-80 3.43   27-Jul-81       PAGE    1-32


  7918    7E                            LD A,(HL)               ; Text Ende <30H
  7919    FE 2F                         CP 2FH          ; ENDE < 21H = !
  791B    30 EE                         JR NC,SUCH1     ; -> kein Ende
  791D    AF                            XOR A
  791E    C9                            RET     
                                ;-------------
  791F    C5                    FREI:   PUSH BC
  7920    0E 0B                         LD C,0BH        ; GET CONSILE STATUS
  7922    CD 0005                       CALL 0005H
  7925    C1                            POP BC
  7926    C9                            RET
                                ;-----------------------
                                ; ZEICHEN IN KEYBUFFER SCHREIBEN
                                ; UND MIT CR ENDE
  7927    FE 0D                 KEYB:   CP 0DH
  7929    C8                            RET Z   ;,BL03  ; Ausgang mit CR
  792A    12                            LD (DE),A       ; Zeichen abspeichen
  792B    FE 08                         CP 08H          ; TAB
  792D    20 2F                         JR NZ,BL021     ; NEIN ->
                                        ;-----------------
                                        ; BACKSPACE FUNKTION CURSOR LINKS MIT ZEICHEN LOESCHEN
                                        ;
  792F    7E                            LD A,(HL)       ; Zeichenzaehler
  7930    D6 01                         SUB 01H
  7932    38 19                         JR C,KEYB1
  7934    77                            LD (HL),A       ; Zeichenlaenge -1
  7935    3E 20                         LD A,20H
  7937    CD 7812                       CALL HEXC
  793A    04                            INC B
  793B    1B                            DEC DE          ; Zeichen loeschen
                                        ;----------
                                        ; set cursor 1 left
  793C    3E 1B                         LD A,1BH
  793E    CD 7812                       CALL HEXC
  7941    3E 5B                         LD A,5BH
  7943    CD 7812                       CALL HEXC
  7946    3E 44                         LD A,44H
  7948    CD 7812                       CALL HEXC
  794B    AF                            XOR A
  794C    C9                            RET             ; zurueck ohne B dec
                                        ;----------
                                        ; set cursor 1 right
  794D    3E 1B                 KEYB1:  LD A,1BH
  794F    CD 7812                       CALL HEXC
  7952    3E 5B                         LD A,5BH
  7954    CD 7812                       CALL HEXC
  7957    3E 43                         LD A,43H
  7959    CD 7812                       CALL HEXC
  795C    AF                            XOR A
  795D    C9                            RET             ; zurueck ohne B dec
                                        ;-------------------
                                        ; ESC 
                                        ; 
  795E    FE 1B                 BL021:  CP 1BH          ; ESC
  7960    20 5A                         JR NZ,BL022     ; NEIN ->
  7962    7E                            LD A,(HL)
        MACRO-80 3.43   27-Jul-81       PAGE    1-33


  7963    FE 00                         CP 0H
  7965    20 55                         JR NZ,BL022
  7967    D5                            PUSH DE
  7968    C5                            PUSH BC
  7969    E5                            PUSH HL
  796A    06 A0                 BL120:  LD B,0A0H
  796C    10 FE                         DJNZ $          ; DELAY
  796E    CD 79F6                       CALL KEYST      ; pruefe ob Zeichen da
  7971    FE 00                         CP 0H
  7973    28 42                         JR Z,BL121      ; -> NO
  7975    5F                            LD E,A
  7976    FE 5B                         CP '['
  7978    28 F0                         JR Z,BL120
  797A    3E 44                         LD A,'D'
  797C    BB                            CP E
  797D    38 38                         JR C,BL121
  797F    3E 40                         LD A,'@'
  7981    BB                            CP E
  7982    30 33                         JR NC,BL121
  7984    3E 41                         LD A,'A'
  7986    BB                            CP E
  7987    20 0D                         JR NZ,BL123
  7989    3A 8084                       LD A,(ZEIL)
  798C    3C                            INC A
  798D    FE 07                         CP CURUD
  798F    30 26                         JR NC,BL121
  7991    32 8084                       LD (ZEIL),A
  7994    18 21                         JR BL121
                                ;--------------------------     
  7996    3E 42                 BL123:  LD A,'B'
  7998    BB                            CP E
  7999    20 0D                         JR NZ,BL124
                                        ;JR NZ,BL123
  799B    3A 8084                       LD A,(ZEIL)
  799E    3D                            DEC A
  799F    FE 01                         CP 01H
  79A1    38 14                         JR C,BL121
  79A3    32 8084                       LD (ZEIL),A
  79A6    18 0F                         JR BL121
                                        ;-------------------
  79A8    3E 43                 BL124:  LD A,'C'
  79AA    BB                            CP E
  79AB    20 02                         JR NZ,BL125
                                ; Cursor right
  79AD    18 08                         JR BL121
                                        ;-----------
  79AF    3E 44                 BL125:  LD A,'D'
  79B1    BB                            CP E
  79B2    20 03                         JR NZ,BL121
                                ; Cursor left
  79B4    18 B4                         JR BL120
  79B6    C9                    BL02X:  RET ;!!JP BL02
                                        ;------------
  79B7    E1                    BL121:  POP HL
  79B8    C1                            POP BC
  79B9    D1                            POP DE
        MACRO-80 3.43   27-Jul-81       PAGE    1-34


  79BA    AF                            XOR A           ; letzes Zeichen loeschen
  79BB    77                            LD (HL),A       ; Zeichenzaehler loeschen
                                        ;-------------
  79BC    FE 21                 BL022:  CP 21H          ; Zeichen < Space
  79BE    38 02                         JR C,BL023
  79C0    13                            INC DE          ; Zeichenadr. +1
  79C1    34                            INC (HL)        ; Zeichenzaehler erhoehen
  79C2    10 F2                 BL023:  DJNZ BL02X      ; vorgegebene Laenge aus Blase
  79C4    3E 0D                         LD A,0DH        ; LAENGE B ERREICHT ENDE
  79C6    C9                            RET
                                        ;-----------------------------
                                        ; BLASE AUF 512BYTE UMKOPIEREN
                                        ;
  79C7    C5                    MASK1:  PUSH BC
  79C8    D5                            PUSH DE
  79C9    21 6000                       LD HL,RAM       ; Adr. Aktueller Blase
  79CC    01 0200                       LD BC,200H
  79CF    3E 20                 MASK2:  LD A,20H        ; SPACE
  79D1    77                            LD (HL),A
  79D2    23                            INC HL
  79D3    0D                            DEC C
  79D4    20 F9                         JR NZ,MASK2
  79D6    10 F7                         DJNZ MASK2
                                        ;---------
  79D8    21 830F                       LD HL,NBLASE
  79DB    11 6000                       LD DE,RAM
  79DE    01 0039                       LD BC,MNBL2
  79E1    ED B0                         LDIR
  79E3    E5                            PUSH HL
  79E4    21 6200                       LD HL,RAM+200H
  79E7    11 006F                       LD DE,FBLOCK
  79EA    ED 52                         SBC HL,DE
  79EC    EB                            EX DE,HL
  79ED    E1                            POP HL
  79EE    01 006F                       LD BC,FBLOCK
  79F1    ED B0                         LDIR
  79F3    D1                            POP DE
  79F4    C1                            POP BC
  79F5    C9                            RET
                                ;-----------------------
                                ; CONSOLE QUERY AND PICK 
                                ; WITHOUT WAITING
                                ; 
  79F6    CD 7EC0               KEYST:  CALL UHR00
  79F9    C5                            PUSH BC
  79FA    0E 0B                         LD C,0BH        ; GET CONSILE STATUS
  79FC    CD 0005                       CALL 0005H
  79FF    FE 00                         CP 0
  7A01    28 05                         JR Z,KEY01
  7A03    0E 01                         LD C,01H        ; console Input read chr
  7A05    CD 0005                       CALL 0005H
  7A08    C1                    KEY01:  POP BC
  7A09    C9                            RET 
                                ;-----------------------
                                ; LBA Z[HLER HERH\HE BID HDDE ENDE
                                ;
        MACRO-80 3.43   27-Jul-81       PAGE    1-35


  7A0A    DD E5                 LBA0:   PUSH IX
  7A0C    DD 21 0000                    LD IX,0
  7A10    DD 39                         ADD IX,SP
                                ;--------
  7A12    DD 4E 06                      LD C,(IX+6)     ; LBA LOW SECTOR
  7A15    DD 46 07                      LD B,(IX+7)
  7A18    0C                            INC C
  7A19    DD 71 06                      LD (IX+6),C
  7A1C    20 35                         JR NZ,LBA20
  7A1E    04                            INC B
  7A1F    DD 70 07                      LD (IX+7),B
  7A22    20 2F                         JR NZ,LBA20
  7A24    DD 4E 04                      LD C,(IX+4)     ; LBA TRACK 
  7A27    DD 46 05                      LD B,(IX+5)
  7A2A    03                            INC BC
  7A2B    DD 71 04                      LD (IX+4),C     ; LBA TRACK
  7A2E    DD 70 05                      LD (IX+5),B
  7A31    AF                            XOR A           ; RES CARRY FLAG
  7A32    21 00BE                       LD HL,HDDE      ; DISK ENDE
  7A35    ED 42                         SBC HL,BC       ; -C
  7A37    30 1A                         JR NC,LBA20     
  7A39    01 0801                       LD BC,HDD+1
  7A3C    DD 71 06                      LD (IX+6),C
  7A3F    DD 70 07                      LD (IX+7),B
  7A42    01 0000                       LD BC,0
  7A45    DD 71 04                      LD (IX+4),C
  7A48    DD 70 05                      LD (IX+5),B
  7A4B    C3 0000                       JP 0;!!!!
  7A4E    18 03                         JR LBA20
                                        ; ENDE ERREICHT
  7A50    37                    LBA4:   SCF             ;AUSGANG FEHLER
  7A51    18 01                         JR LBA21
                                ;-----------
  7A53    AF                    LBA20:  XOR A           ; SET CARRY -> OHNE FEHLER
  7A54    DD F9                 LBA21:  LD SP,IX
  7A56    DD E1                         POP IX
  7A58    C9                            RET
                                ;-----------------
                                ; ADRESSE -1
  7A59    C3 0000               LBA5:   JP 0;!!!
  7A5C    DD E5                 PUSH IX
  7A5E    DD 21 0000                    LD IX,0
  7A62    DD 39                         ADD IX,SP
                                ;------
  7A64    DD 46 07                      LD B,(IX+7)     ; LBA 
  7A67    DD 4E 06                      LD C,(IX+6)     ; LOW
  7A6A    0B                            DEC BC
  7A6B    78                            LD A,B
  7A6C    E6 F0                         AND 0F0H
  7A6E    28 23                         JR Z,L__6
  7A70    06 0F                         LD B,0FH
  7A72    DD 70 07                      LD (IX+7),B     ; LBA 
  7A75    DD 71 06                      LD (IX+6),C     ; LOW
  7A78    DD 46 05                      LD B,(IX+5)     ; LBA HIGH
  7A7B    DD 4E 04                      LD C,(IX+4)     ; LOW
  7A7E    0B                            DEC BC
        MACRO-80 3.43   27-Jul-81       PAGE    1-36


  7A7F    E5                            PUSH HL
  7A80    AF                            XOR A
  7A81    21 0800                       LD HL,HDD
  7A84    ED 42                         SBC HL,BC
  7A86    E1                            POP HL
  7A87    38 02                         JR C,L__7
  7A89    18 C5                         JR LBA4
                                        ;-----------
  7A8B    DD 70 05              L__7:   LD (IX+5),B
  7A8E    DD 71 04                      LD (IX+4),C
  7A91    18 C0                         JR LBA20
                                        ;_-------
  7A93    DD 70 07              L__6:   LD (IX+7),B     ; LBA HIGH
  7A96    DD 71 06                      LD (IX+6),C     ; LOW
  7A99    18 B8                         JR LBA20
                                
  7A9B    DD 46 05                      LD B,(IX+5)     ; LBA HIGH
  7A9E    DD 4E 04                      LD C,(IX+4)     ; LOW
  7AA1    0B                            DEC BC
  7AA2    DD 70 05                      LD (IX+5),B
  7AA5    DD 71 04                      LD (IX+4),C
  7AA8    18 A9                         JR LBA20
                                        ; --------------------
                                        ; aktuelle Blasenadresse
                                ;------------------------
                                ; Cursor auf Position setzen
                                
  7AAA    F5                    RLIST:  PUSH AF
  7AAB    3A 6518                       LD A,(CURS)
  7AAE    32 651C                       LD (CURT),A
  7AB1    3A 6519                       LD A,(CURS+1)
  7AB4    32 651D                       LD (CURT+1),A
  7AB7    3A 651A                       LD A,(CURS+2)
  7ABA    32 651E                       LD (CURT+2),A
  7ABD    3A 651B                       LD A,(CURS+3)
  7AC0    32 651F                       LD (CURT+3),A
  7AC3    CD 77DB                       CALL CUT
  7AC6    F1                            POP AF
  7AC7    C9                            RET
                                        ;------------
                                        ; CURSER POS SAVE
  7AC8    F5                    WLIST:  PUSH AF
  7AC9    3A 651C                       LD A,(CURT)
  7ACC    32 6518                       LD (CURS),A
  7ACF    3A 651D                       LD A,(CURT+1)
  7AD2    32 6519                       LD (CURS+1),A
  7AD5    3A 651E                       LD A,(CURT+2)
  7AD8    32 651A                       LD (CURS+2),A
  7ADB    3A 651F                       LD A,(CURT+3)
  7ADE    32 651B                       LD (CURS+3),A
  7AE1    F1                            POP AF
                                        ;------------
  7AE2    F5                    LIST:   PUSH AF
  7AE3    78                            LD A,B
  7AE4    E6 F0                         AND 0F0H
  7AE6    0F                            RRCA
        MACRO-80 3.43   27-Jul-81       PAGE    1-37


  7AE7    0F                            RRCA
  7AE8    0F                            RRCA
  7AE9    0F                            RRCA
  7AEA    32 651C                       LD (CURT),A
  7AED    78                            LD A,B
  7AEE    E6 0F                         AND 0FH
  7AF0    32 651D                       LD (CURT+1),a
  7AF3    79                            LD A,C
  7AF4    E6 F0                         AND 0F0H
  7AF6    0F                            RRCA
  7AF7    0F                            RRCA
  7AF8    0F                            RRCA
  7AF9    0F                            RRCA
  7AFA    32 651E                       LD (CURT+2),A
  7AFD    79                            LD A,C
  7AFE    E6 0F                         AND 0FH
  7B00    32 651F                       LD (CURT+3),A
  7B03    CD 77DB                       CALL CUT
  7B06    F1                            POP AF
  7B07    C9                            RET
                                        ;-------------
                                        ; ZUM TEST (HL)+1  30MAL AUSGEBEN
                                        ;
  7B08    06 1E                 LIS0:   LD B,30D
  7B0A    7E                    LIS1:   LD A,(HL)
  7B0B    4F                            LD C,A
  7B0C    C5                            PUSH BC
  7B0D    CD 779A                       CALL HEX00
  7B10    C1                            POP BC
  7B11    23                            INC HL
  7B12    10 F6                         DJNZ LIS1
  7B14    C9                            RET
                                ;---------------------------
                                ;  Kontrollausgabe rechts
                                ;
  7B15    CD 7832               TAS:    CALL COFF
  7B18    ED 73 651C                    LD (CURT),SP
  7B1C    C5                            PUSH BC
  7B1D    01 2273                       LD BC,2273H
  7B20    CD 7018                       CALL T8         ;CURSOR POS
  7B23    C1                            POP BC
  7B24    3A 650F                       LD A,(BFSHH)
  7B27    4F                            LD C,A
  7B28    C5                            PUSH BC
  7B29    CD 779A                       CALL HEX00      ; ADRESSE DER AKTUEL GELESENEN BLASE
  7B2C    C1                            POP BC
  7B2D    3A 650E                       LD A,(BFSHL)
  7B30    4F                            LD C,A
  7B31    C5                            PUSH BC
  7B32    CD 779A                       CALL HEX00
  7B35    C1                            POP BC
  7B36    3A 650D                       LD A,(BFSLH)
  7B39    4F                            LD C,A
  7B3A    C5                            PUSH BC
  7B3B    CD 779A                       CALL HEX00
  7B3E    C1                            POP BC
        MACRO-80 3.43   27-Jul-81       PAGE    1-38


  7B3F    3A 650C                       LD A,(BFSLL)
  7B42    4F                            LD C,A
  7B43    C5                            PUSH BC
  7B44    CD 779A                       CALL HEX00
  7B47    C1                            POP BC
                                        ; --------------------
                                        ; aktuelle Blasenadresse
  7B48    C5                            PUSH BC
  7B49    01 2173                       LD BC,2173H
  7B4C    CD 7018                       CALL T8         ;CURSOR POS
  7B4F    C1                            POP BC
  7B50    3A 8072                       LD A,(BF07+3) ;(BFRHH)
  7B53    4F                            LD C,A
  7B54    C5                            PUSH BC
  7B55    CD 779A                       CALL HEX00
  7B58    C1                            POP BC
  7B59    3A 8071                       LD A,(BF07+2)  ;(BFRHL)
  7B5C    4F                            LD C,A
  7B5D    C5                            PUSH BC
  7B5E    CD 779A                       CALL HEX00
  7B61    C1                            POP BC
  7B62    3A 8070                       LD A,(BF07+1)  ;(BFRLH)
  7B65    4F                            LD C,A
  7B66    C5                            PUSH BC
  7B67    CD 779A                       CALL HEX00
  7B6A    C1                            POP BC
  7B6B    3A 806F                       LD A,(BF07) ;(BFRLL)
  7B6E    4F                            LD C,A
  7B6F    C5                            PUSH BC
  7B70    CD 779A                       CALL HEX00
  7B73    C1                            POP BC
                                        ;---------------------
                                        ; CURSOR IN EINGABEZEILE MIT EINGABE SCHIEBEN
  7B74    3E 02                 TAS00:  LD A,02H
  7B76    32 651C                       LD (CURT),A
  7B79    3E 04                         LD A,04H
  7B7B    32 651D                       LD (CURT+1),A
  7B7E    3E 01                         LD A,01H
  7B80    32 651E                       LD (CURT+2),A
  7B83    3A 6B27                       LD A,(RAMT)
  7B86    FE 0A                         CP 0AH
  7B88    38 0E                         JR C,RD07       ; < 0AH ->
  7B8A    D6 0A                         SUB 0AH
  7B8C    32 651F                       LD (CURT+3),A
  7B8F    3A 651E                       LD A,(CURT+2)
  7B92    3C                            INC A
  7B93    32 651E                       LD (CURT+2),A
  7B96    18 03                         JR RD08
  7B98    32 651F               RD07:   LD (CURT+3),A
  7B9B    CD 77DB               RD08:   CALL CUT
  7B9E    06 14                         LD B,20D
  7BA0    21 6728                       LD HL,RAMS+RUSER
  7BA3    CD 77DB               RD09:   CALL CUT
  7BA6    CD 7821                       CALL CON
                                ;-----------------------
                                ; Tastenabfrage und Zeichen einlesen
        MACRO-80 3.43   27-Jul-81       PAGE    1-39


                                ; Sonst weitere Task ausfueren
                                ;
                                ; LBA ZAEHLER +1
                                ;
  7BA9    ED 5B 650C                    LD DE,(BFSLL)   ; Aktuelle Track/Sectoradresse laden
  7BAD    ED 53 6C43                    LD (COP+4),DE   ; STARTPUNKT NACH SPEICHERN
  7BB1    D5                            PUSH DE
  7BB2    2A 650E                       LD HL,(BFSHL)
  7BB5    22 6C45                       LD (COP+6),HL
  7BB8    E5                            PUSH HL
  7BB9    CD 7A0A                       CALL LBA0       ; LBA + 1
  7BBC    E1                            POP HL
  7BBD    22 650E                       LD (BFSHL),HL   ; adresse HIGH speichern
  7BC0    D1                            POP DE
  7BC1    ED 53 650C                    LD (BFSLL),DE   ; adresse LOW speichern
  7BC5    DA 0000                       JP C,0 ;NOCH ENDE BEI FEHLER RD91               ; RUECKGABE CARRY 0=FEHLER
                                        ;---------------- 
                                        ; 1. BLASE + 1 = 2.BLASE
  7BC8    D5                            PUSH DE         ; IX UEBERGABE
  7BC9    E5                            PUSH HL         ; IX UEBERGEBE
  7BCA    CD 7A0A                       CALL LBA0       ; LBA + 1
  7BCD    E1                            POP HL
  7BCE    22 6512                       LD (BFSHL+4),HL ; adresse HIGH speichern
  7BD1    D1                            POP DE
  7BD2    ED 53 6510                    LD (BFSLL+4),DE ; adresse LOW speichern
  7BD6    DA 0000                       JP C,0 ;NOCH ENDE BEI FEHLER RD91               ; RUECKGABE CARRY 0=FEHLER
  7BD9    CD 791F                       CALL FREI       ; TAST INT FREI
                                        ;---------------------
                                        ; Erste Blase laden
  7BDC    ED 4B 650C                    LD BC,(BFSLL)
  7BE0    ED 5B 650E                    LD DE,(BFSHL)
  7BE4    21 6727                       LD HL,RAMS
  7BE7    CD 7DF8                       CALL RDREAD     ; BFSLL BLASE LADEN
  7BEA    CD 791F                       CALL FREI
                                        ; READ SICHTBAR MACHEN
                                        ;LD BC,1001H
                                        ;CALL T8
                                        ;LD HL,RAMS
                                        ;CALL LIS0
                                        ;------
  7BED    3A 672D                       LD A,(RAMS+RSOTR)
  7BF0    FE 1B                         CP 1BH
  7BF2    28 0E                         JR Z,TAS03
  7BF4    21 830F                       LD HL,NBLASE
  7BF7    11 6727                       LD DE,RAMS
  7BFA    01 0101                       LD BC,NBLLE
  7BFD    ED B0                         LDIR
                                        ; READ SICHTBAR MACHEN
                                        ;LD BC,1101H
                                        ;CALL T8
                                        ;LD HL,RAMS
                                        ;CALL LIS0
  7BFF    C3 7CD8                       JP RD170
                                        ;-------------------
                                        ; Zweite Blase laden
  7C02    ED 4B 6510            TAS03:  LD BC,(BFSLL+4)
        MACRO-80 3.43   27-Jul-81       PAGE    1-40


  7C06    ED 5B 6512                    LD DE,(BFSHL+4)
  7C0A    21 6927                       LD HL,RAMS+200H
  7C0D    CD 7DF8                       CALL RDREAD     ; BFSLL BLASE LADEN
  7C10    CD 791F                       CALL FREI
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
  7C13    21 6928                       LD      HL,RAMS+RUSER+200H      ;BLASE2 RAM
  7C16    11 6728                       LD      DE,RAMS+RUSER           ;BLASE1 RAM
  7C19    1A                            LD      A,(DE)          ; USER vergleich
  7C1A    BE                            CP      (HL)            ; Blase2 > Blase1 dann
  7C1B    DA 7C8A                       JP      C,RD06          ; zum naechstem >USER 2  neu anfangen
  7C1E    C2 7CEE                       JP      NZ,RD01         ; Blase2 < Blase1 tauschen ->
                                ;----------------------
                                ; Blasen der groesse nach Sortieren
                                ; TYPE1, AUFSTEIGEND
                                ; wenn T1 > T1+1 (DE)-(HL) =NC,dann tauschen
                                ; wenn T1 = T1+1 (DE)-(HL) =Z,dann TYPE2 
                                ; wenn T1 < T1+1 (DE)-(HL) =NZ,dann GEDAECHTNIS
                                ;
  7C21    21 6929                       LD      HL,RAMS+RTYPE1+200H     ; Blase2
  7C24    11 6729                       LD      DE,RAMS+RTYPE1          ; Blase1
  7C27    1A                            LD      A,(DE)                  ; TYPE1 Vergleich
  7C28    BE                            CP      (HL)                    ; Blase2 > Blase1 dann
  7C29    DA 7C8A                       JP      C,RD06                  ; zum Gedaechtnis zuruecksetzen 
  7C2C    C2 7CEE                       JP      NZ,RD01                 ; tauschen und Speichern 
                                ;       JP RD02 ;!!!!!TEST
                                ;----------------------
                                ; Blasen der groesse nach Sortieren
                                ; TYPE2 AUFSTEIGEND
                                ; wenn T2 > T2+1 (DE)-(HL) =NC,dann tauschen
                                ; wenn T2 = T2+1 (DE)-(HL) = Z,dann gedaechtniss-1
                                ; wenn T2 < T2+1 (DE)-(HL) =NZ,dann weiter
                                ;
  7C2F    21 692A               RD25:   LD HL,RAMS+RTYPE2+200H  ; Blase2
  7C32    11 672A                       LD DE,RAMS+RTYPE2       ; Blase1
  7C35    1A                            LD A,(DE)
  7C36    FE 01                         CP 01H                  ; RAM+TYPE2 > 0
  7C38    20 09                         JR NZ,RD255             ; TYPE2 BEREITS 1=FORNE JA ->
  7C3A    BE                            CP (HL)
                                ;??     CALL C,TASK     ; NOCH AUSARBEITEN
  7C3B    3A 692C                       LD A,(RAMS+RBSTAT+200H)
        MACRO-80 3.43   27-Jul-81       PAGE    1-41


  7C3E    E6 07                         AND 07H
  7C40    CA 7CEE                       JP Z,RD01               ; BLASE 2 SPEICHERN MIT TAUSCHEN
  7C43    1A                    RD255:  LD A,(DE)
  7C44    BE                            CP (HL)                 ; Blase2 > Blase1 dann
  7C45    38 06                         JR C,RD26
  7C47    CA 7C6D                       JP Z,RD36               ; ZUM GEDAECHTNIS
  7C4A    D2 7CEE                       JP NC,RD01              ; TAUSCHEN
                                        ;----------------------
  7C4D    1A                    RD26:   LD A,(DE)               ; BLASE1 TYPE2 Vergleich
  7C4E    FE 00                         CP 0H
  7C50    C2 7C8A                       JP NZ,RD06              ; zum Gedaechtnisszaehler
                                        ;----------------------
                                        ; GED[CHTNISS BLASE1 TYPE2=0 MIT BLASE2 TYPE2>0 VERGLEICHEN
                                         
  7C53    21 672B                       LD HL,RAMS+RTERM                ; Blase1
  7C56    11 692B                       LD DE,RAMS+RTERM+200H   ; Blase2
  7C59    1A                            LD A,(DE)                       ; Gedaechtnissz Vergleich
  7C5A    BE                            CP (HL)
  7C5B    38 2D                         JR C,RD06                       ; 1>2 GEDAECHTNISS FALLEND
  7C5D    3C                            INC A
  7C5E    20 01                         JR NZ,RD250
  7C60    1A                            LD A,(DE)
  7C61    77                    RD250:  LD (HL),A
  7C62    ED 4B 650C                    LD BC,(BFSLL)
  7C66    ED 5B 650E                    LD DE,(BFSHL)           ; Suchadresse 2. BLASE speichern
  7C6A    C3 7D5B                       JP RD03
                                        ;----------------------
                                        ; Blasen der groesse nach Sortieren
                                        ; GEDAECHTNIS FALLEND
  7C6D    7E                    RD36:   LD A,(HL)
  7C6E    FE 00                         CP 0
  7C70    20 0D                         JR NZ,RD35
  7C72    3A 672C                       LD A,(RAMS+RBSTAT)
  7C75    E6 78                         AND 78H
  7C77    F6 47                         OR 47H
  7C79    32 672C                       LD (RAMS+RBSTAT),A
  7C7C    C3 7C4D                       JP RD26 
                                        ;---------------------
  7C7F    21 692B               RD35:   LD HL,RAMS+RTERM+200H   ; Blase2
  7C82    11 672B                       LD DE,RAMS+RTERM        ; Blase1
  7C85    1A                            LD A,(DE)               ; Gedaechtnissz Vergleich
  7C86    BE                            CP (HL)
  7C87    DA 7CEE                       JP C,RD01               ; tauschen und Speichern fallend
                                        ;---------------------
                                        ; Gedaechtniss zuruecksetzen wenn MONAT ungleich ist
                                
  7C8A    CD 791F               RD06:   CALL FREI
  7C8D    3A 807C                       LD A,(DAYM)             ; MONAT AUS UHR
  7C90    E6 1F                         AND 1FH
  7C92    47                            LD B,A
  7C93    3A 672C                       LD A,(RAMS+RBSTAT)      ; MONAT AUS BLASE1
  7C96    E6 1F                         AND 1FH
  7C98    B8                            CP B
  7C99    C2 7CA6                       JP NZ,RDD1              ; NICHT GLEICH ->
  7C9C    3A 672C                       LD A,(RAMS+RBSTAT)      ; MONAT AUS BLASE1
  7C9F    CB 77                         BIT 6,A                 ; PRUEFE SORTIEREN 
        MACRO-80 3.43   27-Jul-81       PAGE    1-42


  7CA1    20 03                         JR NZ,RDD1              ; SPEICHERN ->
  7CA3    C3 7DAA                       JP RD02                 ; GLEICH nicht speichern gleicher MONAT
                                        ;------------------
                                        ; NEUER MONAT UND GEDAECHTNIS SPEICHERN
  7CA6    3A 672C               RDD1:   LD A,(RAMS+RBSTAT)      ; BLASE 1
  7CA9    E6 E0                         AND 0E0H
  7CAB    B0                            OR B            ; neuer MONAT einbinden 
  7CAC    CB B7                         RES 6,A         ; Zaehler aktivieren
  7CAE    CB 7F                         BIT 7,A         ; Blase benutzt fuer +/-
  7CB0    28 11                         JR Z,RD16       ; Gedaechtniss abziehen =0
  7CB2    CB BF                         RES 7,A         ; =1 ADDIEREN loesche
  7CB4    32 672C                       LD (RAMS+RBSTAT),A      ; wieder zurueck in Blase1
  7CB7    3A 672B                       LD A,(RAMS+RTERM)       ; GEDAECHTNISSZAEHLER AUS RAM
  7CBA    3C                            INC A                   ; Gedaechtniss +1
  7CBB    CA 7CD8                       JP Z,RD170              ; Ausgang WENN MAX ERREICHT
  7CBE    32 672B                       LD (RAMS+RTERM),A       ; ZURUECK IN RAM
  7CC1    18 0D                         JR RD17
                                        ;--------------
  7CC3    32 672C               RD16:   LD (RAMS+RBSTAT),A      ; MONAT SPEICHERN
  7CC6    3A 672B                       LD A,(RAMS+RTERM)
  7CC9    D6 01                         SUB 01H                 ; Gedaechtniss schon Min
  7CCB    38 16                         JR C,RD171              ; Ausgang WENN MIN ERREICHT
  7CCD    32 672B                       LD (RAMS+RTERM),A       ; ZURUECK IN RAM
  7CD0    3A 6205               RD17:   LD A,(BSTAT)
  7CD3    CB B7                         RES 6,A                 ; Sortieren aktivieren aller Blasen
  7CD5    32 6205                       LD (BSTAT),A
  7CD8    ED 5B 650E            RD170:  LD DE,(BFSHL)           ; Suchadresse speichern
  7CDC    ED 4B 650C                    LD BC,(BFSLL)
  7CE0    C3 7D5B                       JP RD03                 ; nur Blase1 ohne tauschen speicher
                                        ;------------------
  7CE3    3A 6728               RD171:  LD A,(RAMS+RUSER)
  7CE6    3C                            INC A
  7CE7    28 EF                         JR Z,RD170
  7CE9    32 6728                       LD (RAMS+RUSER),A       ; User =FFH damit Blase wieder an Schluss wandert
  7CEC    18 EA                         JR RD170
                                        ;-----------------------
                                        ; Zweite Blase mit Erster Blase beim Speichern tauschen
  7CEE    ED 4B 650C            RD01:   LD BC,(BFSLL)
  7CF2    ED 5B 650E                    LD DE,(BFSHL)   ; Suchadresse 1.Blase speichern
  7CF6    21 6927                       LD HL,RAMS+200H         ; MIT WERT AUS 2.BLASE SPEICHERN
  7CF9    CD 7E21                       CALL RDWRITE
                                        ;------
                                        ; WRITE SICHTBAR MACHEN
                                        ;LD BC,1401H
                                        ;CALL T8
                                        ;LD HL,RAMS+200H
                                        ;CALL LIS0
                                        ;--------
  7CFC    3A 6205                       LD A,(BSTAT)
  7CFF    CB B7                         RES 6,A         ; SORTIEREN START
  7D01    32 6205                       LD (BSTAT),A
                                        ;-------------------
                                        ; pruefe ob AKTUELLE ZAEHLER ALS 1. Blase offen ist
  7D04    AF                            XOR A           ; RES CARRY FLAG
  7D05    ED 5B 650E                    LD DE,(BFSHL)   ; ADRESSE HIGH
  7D09    2A 6502                       LD HL,(BFRHL)   ; AKTUELL SICHTBARE BLASE
        MACRO-80 3.43   27-Jul-81       PAGE    1-43


  7D0C    ED 52                         SBC HL,DE       ;-C
  7D0E    20 1D                         JR NZ,TAS22     ; BLASE H SORTIEREN UND OFFEN NICHT GLEICH ->
  7D10    AF                            XOR A           ; RES CARRY FAG
  7D11    ED 5B 650C                    LD DE,(BFSLL)   ; ADRESSE LOW
  7D15    2A 6500                       LD HL,(BFRLL)
  7D18    ED 52                         SBC HL,DE       ;-C
  7D1A    20 11                         JR NZ,TAS22
                                        ;-------------------
                                        ; DANN ADRESSE AKTUELLER BLASE AUCH TAUSCHEN
                                        ; SICHTBARE BLASE VERSCHIEBEN
  7D1C    ED 5B 6510                    LD DE,(BFSLL+4)
  7D20    2A 6512                       LD HL,(BFSHL+4)
  7D23    22 6502                       LD (BFRHL),HL
  7D26    ED 53 6500                    LD (BFRLL),DE
  7D2A    C3 7D53                       JP TAS24
                                        ;-------------------
                                        ; pruefe ob AKTUELLE ZAEHLER ALS 1. Blase offen ist
  7D2D    AF                    TAS22:  XOR A           ; RES CARRY FLAG
  7D2E    ED 5B 6512                    LD DE,(BFSHL+4) ; Aktuelle Track/Sectoradresse laden
  7D32    2A 6502                       LD HL,(BFRHL)
  7D35    ED 52                         SBC HL,DE       ; -C
  7D37    20 1A                         JR NZ,TAS24     ; BLASE H SORTIEREN UND OFFEN NICHT GLEICH ->
  7D39    AF                            XOR A           ; RES CARRY FLAG
  7D3A    ED 5B 6510                    LD DE,(BFSLL+4) ; Aktuelle Track/Sectoradresse laden
  7D3E    2A 6500                       LD HL,(BFRLL)
  7D41    ED 52                         SBC HL,DE       ; -C
  7D43    20 0E                         JR NZ,TAS24
                                        ;-----------------
                                        ; AKTUELLE BLASE TAUSCHEN H->L
  7D45    ED 5B 650C                    LD DE,(BFSLL)
  7D49    2A 650E                       LD HL,(BFSHL)
  7D4C    ED 53 6500                    LD (BFRLL),DE
  7D50    22 6502                       LD (BFRHL),HL
                                        ;-----------------------
                                        ; Erste Blase mit zweiter Blase beim Speichern tauschen
  7D53    ED 4B 6510            TAS24:  LD BC,(BFSLL+4)
  7D57    ED 5B 6512                    LD DE,(BFSHL+4) ; Suchadresse 2. BLASE speichern
  7D5B    21 6727               RD03:   LD HL,RAMS
  7D5E    CD 7E21                       CALL RDWRITE
                                        ;------
                                        ; WRITE SICHTBAR MACHEN
                                        ;LD BC,1601H
                                        ;CALL T8
                                        ;LD HL,RAMS+200H
                                        ;CALL LIS0
                                        ;--------
  7D61    3A 6205                       LD A,(BSTAT)
  7D64    CB 77                         BIT 6,A
  7D66    20 42                         JR NZ,RD02
  7D68    CB F7                         SET 6,A         ; STOP/START
  7D6A    32 6205                       LD (BSTAT),A
                                        ;----------------------
                                        ; nach letztem Blase speichern Sortieradresse > letzter Blase Adr. 
                                        ; dann neu Adr. speichern und bei HDD-neu Anfangsadr. beginnen
  7D6D    AF                            XOR A           ; RES CARRY FLAG
  7D6E    2A 8071                       LD HL,(BF07+2)
        MACRO-80 3.43   27-Jul-81       PAGE    1-44


  7D71    ED 5B 650E                    LD DE,(BFSHL)   ; LETZTE Suchadresse speichern
  7D75    ED 52                         SBC HL,DE       ; -C
  7D77    30 17                         JR NC,RD30
  7D79    ED 53 8071                    LD (BF07+2),DE  ; SPEICHE WENN HL<DE
  7D7D    ED 4B 650C                    LD BC,(BFSLL)
  7D81    ED 43 806F                    LD (BF07),BC
  7D85    ED 5B 650C                    LD DE,(BFSLL)
  7D89    ED 4B 650E                    LD BC,(BFSHL)
  7D8D    C3 7DBE                       JP RD90 
                                        ;---------------
  7D90    ED 5B 650C            RD30:   LD DE,(BFSLL)
  7D94    ED 4B 650E                    LD BC,(BFSHL)
  7D98    C2 7DEB                       JP NZ,RD92
  7D9B    AF                            XOR A           ; RES CARRY FLAG
  7D9C    2A 806F                       LD HL,(BF07)
  7D9F    ED 52                         SBC HL,DE       ; -C
  7DA1    30 07                         JR NC,RD02
  7DA3    ED 53 806F                    LD (BF07),DE
  7DA7    C3 7DBE                       JP RD90         ; NACH sPEICHERN BLASE VON NULL NEUSTART
                                ;-----------
  7DAA                          RD02:   ;------
                                        ; READ SICHTBAR MACHEN
                                        ;LD BC,0501H
                                        ;CALL T8
                                        ;LD HL,RAMS
                                        ;CALL LIS0
  7DAA    CD 791F                       CALL FREI
  7DAD    ED 5B 650E                    LD DE,(BFSHL)           ; LETZTE SUCHADRESSE SPEICHERN
                                        ; LD (BF07+4),DE
  7DB1    ED 4B 650C                    LD BC,(BFSLL)
                                        ; LD (BF07+6),BC
                                        ;ACHTUNG SECTOR 8/16 LD (BF07),BC
                                        ;---------------------
                                        ; Tastenabfrage und Zeichen einlesen
  7DB5    CD 79F6                       CALL KEYST
  7DB8    FE 00                         CP 0H
  7DBA    CA 7B15                       JP Z,TAS        ;TAS00
  7DBD    C9                            RET                     ; RETURN ZU BL ENDE
                                
                                ;---------------------
                                ; RD90 AUSGABE UEBERSPRINGEN
                                ; SUCHADRESSE
                                ;
  7DBE    E5                    RD90:   PUSH HL
  7DBF    D5                            PUSH DE
  7DC0    C5                            PUSH BC
  7DC1    ED 5B 650C                    LD DE,(BFSLL)
  7DC5    ED 4B 650E                    LD BC,(BFSHL)
  7DC9    CB 38                         SRL B
  7DCB    CB 19                         RR C
  7DCD    CB 1A                         RR D
  7DCF    CB 1B                         RR E
  7DD1    AF                            XOR A           ; RES CARRY FLAG
  7DD2    21 0000                       LD HL,0000H
  7DD5    ED 42                         SBC HL,BC       ; -C HIGH
  7DD7    20 12                         JR NZ,RD92      ; BC >0 ->
        MACRO-80 3.43   27-Jul-81       PAGE    1-45


  7DD9    21 0800                       LD HL,HDD
  7DDC    ED 52                         SBC HL,DE
  7DDE    30 05                         JR NC,RD911
  7DE0    18 09                         JR RD92
                                ;----------------------
                                ; RESET TO HDD START
                                ; 
  7DE2    E5                    RD91:   PUSH HL
  7DE3    D5                            PUSH DE
  7DE4    C5                            PUSH BC
  7DE5    11 0801               RD911:  LD DE,HDD+1
  7DE8    01 0000                       LD BC,0
  7DEB    ED 53 650C            RD92:   LD (BFSLL),DE
  7DEF    ED 43 650E                    LD (BFSHL),BC
  7DF3    C1                            POP BC
  7DF4    D1                            POP DE
  7DF5    E1                            POP HL
  7DF6    18 B2                         JR RD02
                                ;------------------------
                                ; READ SECTOR VON HDD
                                ;
  7DF8    DD E5                 RDREAD: PUSH IX
  7DFA    DD 21 0000                    LD IX,0
  7DFE    DD 39                         ADD IX,SP
                                        ;----------------
  7E00    CD 7FF2                       CALL EXTERN
  7E03    F5                            PUSH AF         ; PIOA RESCUE
                                        ;----------------
  7E04    E5                            PUSH HL         ; DMA
  7E05    C5                            PUSH BC         ; DISK SEL
  7E06    D5                            PUSH DE         ; DISK SEL
  7E07    CD 78CB                       CALL DISK
  7E0A    D1                            POP DE
  7E0B    3E 20                         LD A,CMD_READSEC
  7E0D    D3 FF                         OUT (IDECMD),A
  7E0F    7A                            LD A,D
  7E10    D3 FE                         OUT (IDESDH),A
  7E12    CD 784E                       CALL WAITDRQ
  7E15    C1                            POP BC
  7E16    E1                            POP HL
  7E17    06 00                         LD B,00H
  7E19    0E F8                         LD C,IDEDAT
  7E1B    ED B2                         INIR
  7E1D    ED B2                         INIR
  7E1F    18 24                         JR HDIST
                                ;----------------------
                                ; BLASE TO SAVE DE=HIGH, BC=LOW
                                ;
  7E21                          RDWRITE:
  7E21    DD E5                         PUSH IX
  7E23    DD 21 0000                    LD IX,0
  7E27    DD 39                         ADD IX,SP
                                        ;----------------
  7E29    CD 7FF2                       CALL EXTERN
  7E2C    F5                            PUSH AF         ; PIOA RESCUE
                                        ;----------------
        MACRO-80 3.43   27-Jul-81       PAGE    1-46


  7E2D    E5                            PUSH HL         ; DMA
  7E2E    C5                            PUSH BC         ; DISK SEL
  7E2F    D5                            PUSH DE         ; DISK SEL
  7E30    CD 78CB                       CALL DISK
  7E33    D1                            POP DE
  7E34    C1                            POP BC
  7E35    3E 30                         LD A,CMD_WRITESEC
  7E37    D3 FF                         OUT (IDECMD),A
  7E39    CD 784E                       CALL WAITDRQ
  7E3C    E1                            POP HL          ; DMA ZURUECK
  7E3D    06 00                         LD B,00H
  7E3F    0E F8                         LD C,IDEDAT
  7E41    ED B3                         OTIR
  7E43    ED B3                         OTIR
                                        ;----------------
  7E45    F1                    HDIST:  POP AF
  7E46    D3 1C                         OUT (PIOA),A    ; PIOA BACK UP
  7E48    DD F9                         LD SP,IX
  7E4A    DD E1                         POP IX
  7E4C    C9                            RET
                                ;---------------------
                                ; TASK zum Programm Starten
                                ; auf Adr. 100H
                                
  7E4D                          TASK:   ;PUSH   AF
  7E4D    C5                            PUSH    BC
  7E4E    D5                            PUSH    DE
  7E4F    E5                            PUSH    HL
  7E50    3A 6928                       LD      A,(RAMS+RUSER+200H)
  7E53    FE FF                         CP      0FFH
  7E55    30 41                         JR      NC,TASK99       ; USER = FFH nicht auswerten
  7E57    7E                            LD      A,(HL)          ; TYPE2 Blase2 vergleichen
  7E58    FE 02                         CP      02H
  7E5A    38 3C                         JR      C,TASK99
  7E5C    3A 6003                       LD      A,(RAM+RTYPE2)
  7E5F    FE 02                         CP      02H
  7E61    30 35                         JR      NC,TASK99       ; WENN IN RAM >1 EXTERNE TASK EINGABE
                                        ;----------------------
                                        ; EXTERN BEARBEITEN
                                
  7E63    11 0080                       LD      DE,BUFF
  7E66    21 821E                       LD      HL,PRLO1
  7E69    7E                            LD      A,(HL)
  7E6A    12                            LD      (DE),A
  7E6B    13                            INC     DE
  7E6C    47                            LD      B,A
  7E6D    CD 7206                       CALL    BL13
                                ;ERROR ??
                                ; CALL  E.TEXT
                                ; JR    NC,TASK99
                                
  7E70    CD 0100                       CALL    0100H
  7E73    FE 00                         CP      0
  7E75    20 21                         JR      NZ,TASK99
  7E77    ED 4B 6510                    LD BC,(BFSLL+4)
  7E7B    C5                            PUSH BC
        MACRO-80 3.43   27-Jul-81       PAGE    1-47


  7E7C    ED 5B 6512                    LD DE,(BFSHL+4) ; Suchadresse 2. BLASE speichern
  7E80    D5                            PUSH DE
  7E81    CD 78CB                       CALL DISK
  7E84    D1                            POP DE
  7E85    C1                            POP BC
  7E86    38 10                         JR      C,TASK99
  7E88    01 6927                       LD      BC,RAMS+200H            ; MIT WERT AUS 1. BLASE
  7E8B    CD F82F                       CALL    SETDMA
  7E8E    CD 7FF2                       CALL EXTERN
  7E91    F5                            PUSH AF
  7E92    CD F817                       CALL WRITE
  7E95    F1                            POP AF
  7E96    D3 1C                         OUT (PIOA),A
                                
                                        ;----------------
  7E98    E1                    TASK99: POP     HL
  7E99    D1                            POP     DE
  7E9A    C1                            POP     BC
                                        ;POP    AF
  7E9B    C9                            RET
                                        ;-----------------------
                                        ; Blase Speichern  aus RAMS in 
                                        ; BC = LL- LH , DE = HL-HH Adresse LBA
  7E9C    C5                    TWRITE: PUSH BC
  7E9D    D5                            PUSH DE
  7E9E    CD 78CB                       CALL DISK
  7EA1    D1                            POP DE
  7EA2    C1                            POP BC
  7EA3    D8                            RET C
  7EA4    01 6727                       LD BC,RAMS              ; MIT WERT AUS 2. BLASE
  7EA7    CD F82F                       CALL SETDMA
  7EAA    CD 7FF2                       CALL EXTERN
  7EAD    F5                            PUSH AF
  7EAE    CD F817                       CALL WRITE
  7EB1    F1                            POP AF
  7EB2    D3 1C                         OUT (PIOA),A
  7EB4    AF                            XOR     A
  7EB5    C9                            RET
                                ;---------------
                                ; INTERRUPT FUER TASK PRUEFEN
                                ;INT:   EI
  7EB6    00                            NOP
  7EB7    00                            NOP
  7EB8    00                            NOP
  7EB9    00                            NOP
  7EBA    00                            NOP
  7EBB    00                            NOP
  7EBC    00                            NOP
  7EBD    00                            NOP
  7EBE    F3                            DI
  7EBF    C9                            RET
                                
                                ;-----------------------
                                ;  Uhr auslesen
                                
  7EC0    C5                    UHR00:  PUSH BC
        MACRO-80 3.43   27-Jul-81       PAGE    1-48


  7EC1    CD 7FEB                       CALL INTERN
  7EC4    F5                            PUSH AF
  7EC5    DB 1E                         IN A,(PIOB)
  7EC7    F5                            PUSH AF
  7EC8    3E 3F                         LD A,3FH                ; Adresse fuer Uhr
  7ECA    D3 1E                         OUT (PIOB),A
                                        ;-----------------
                                        ; Minuten in Dezimal
                                        ;
  7ECC    3E 40                         LD A,040H               ; Lesen Ein
  7ECE    D3 98                         OUT (URCS+18H),A
  7ED0    DB 9A                         IN A,(URCS+1AH) ; Minuten
  7ED2    4F                            LD C,A
                                ;       XOR A
                                ;       OUT (URCS+18H),A        ; R/W Aus
  7ED3    C5                            PUSH BC
  7ED4    CD 7F1A                       CALL ASCII_CODE
  7ED7    C1                            POP BC
  7ED8    78                            LD A,B
  7ED9    32 8080                       LD (DAYZ+2),A           ; ZEHNER
  7EDC    3A 8081                       LD A,(DAYZ+3)
  7EDF    B9                            CP C
  7EE0    28 2B                         JR Z,UHR01              ; ZEITAENERUNG NEIN ->
  7EE2    79                            LD A,C
  7EE3    32 8081                       LD (DAYZ+3),A
                                        ;-----------------------
                                        ;       Stunde
                                        ;
                                ;       LD A,040H               ; Lesen Ein
                                ;       OUT (URCS+18H),A
  7EE6    00                            NOP
  7EE7    DB 9B                         IN A,(URCS+1BH) ; Stunde
  7EE9    4F                            LD C,A
  7EEA    AF                            XOR A
  7EEB    D3 98                         OUT (URCS+18H),A        ; R/W Aus
  7EED    C5                            PUSH BC
  7EEE    CD 7F1A                       CALL ASCII_CODE
  7EF1    C1                            POP BC
  7EF2    78                            LD A,B
  7EF3    32 807E                       LD (DAYZ),A
  7EF6    79                            LD A,C
  7EF7    32 807F                       LD (DAYZ+1),A
                                        ;-----------------
                                        ; DAY auslesen
                                        ;
                                ;       LD A,040H               ; Lesen Ein
                                ;       OUT (URCS+18H),A
  7EFA    00                            NOP
  7EFB    DB 9D                         IN A,(URCS+1DH) ; Tag
  7EFD    47                            LD B,A
                                ;       XOR A
                                ;       OUT (URCS+18H),A        ; Lesen Aus
  7EFE    78                            LD A,B
  7EFF    32 807D                       LD (DAYT),A
                                        ;-----------------
                                        ; Monat auslesen
        MACRO-80 3.43   27-Jul-81       PAGE    1-49


                                        ;
                                ;       LD A,040H               ; Lesen Ein
                                ;       OUT (URCS+18H),A
  7F02    00                            NOP
  7F03    DB 9E                         IN A,(URCS+1EH) ; Tag
  7F05    47                            LD B,A
                                ;       XOR A
                                ;       OUT (URCS+18H),A        ; Lesen Aus
  7F06    78                            LD A,B
  7F07    32 807C                       LD (DAYM),A
                                        ;------------------
                                        ; Zeit ausgeben
                                        ;
  7F0A    CD 7F4B                       CALL    UHR10
  7F0D    AF                    UHR01:  XOR A
  7F0E    D3 98                         OUT (URCS+18H),A        ; Lesen Aus
  7F10    F1                            POP AF
  7F11    E6 F0                         AND 0F0H
  7F13    D3 1E                         OUT (PIOB),A
  7F15    F1                            POP AF
  7F16    D3 1C                         OUT (PIOA),A
  7F18    C1                            POP BC
  7F19    C9                            RET
                                ;---------
  7F1A                          ASCII_CODE:
  7F1A    DD E5                         PUSH IX
  7F1C    DD 21 0000                    LD IX,0
  7F20    DD 39                         ADD IX,SP
                                        ;------
  7F22    DD 7E 04                      LD A,(IX+4)     ;B=HIGH
  7F25    0F                            RRCA
  7F26    0F                            RRCA
  7F27    0F                            RRCA
  7F28    0F                            RRCA
  7F29    E6 0F                         AND 0FH
  7F2B    C6 30                         ADD A,30H
  7F2D    FE 3A                         CP 3AH
  7F2F    38 02                         JR C,ASC_1
  7F31    C6 07                         ADD A,07H
  7F33    DD 77 05              ASC_1:  LD (IX+5),A
  7F36    DD 7E 04                      LD A,(IX+4)     ; C=LOW
  7F39    E6 0F                         AND 0FH
  7F3B    C6 30                         ADD A,30H
  7F3D    FE 3A                         CP 3AH
  7F3F    38 02                         JR C,ASC_2
  7F41    C6 07                         ADD A,07H
  7F43    DD 77 04              ASC_2:  LD (IX+4),A
                                        ;---------
  7F46    DD F9                         LD SP,IX
  7F48    DD E1                         POP IX
  7F4A    C9                            RET             ; RETURN =BC
                                ;-----------------------
                                ;   Uhr anzeigen
                                ;
  7F4B    CD 7832               UHR10:  CALL COFF       ; CURSOR AUS
                                        ;---------------
        MACRO-80 3.43   27-Jul-81       PAGE    1-50


                                        ; Zeile/Spalte
  7F4E    C5                            PUSH BC
  7F4F    01 0075                       LD BC,0075H
  7F52    CD 7AC8                       CALL WLIST      ; CURSOR POS
  7F55    C1                            POP BC
  7F56    3A 807E                       LD A,(DAYZ)
  7F59    CD 7812                       CALL HEXC
  7F5C    3A 807F                       LD A,(DAYZ+1)
  7F5F    CD 7812                       CALL HEXC
  7F62    3E 3A                         LD A,3AH
  7F64    CD 7812                       CALL HEXC
  7F67    3A 8080                       LD A,(DAYZ+2)
  7F6A    CD 7812                       CALL HEXC
  7F6D    3A 8081                       LD A,(DAYZ+3)
  7F70    CD 7812                       CALL HEXC
                                        ;-----------
  7F73    CD 7832                       CALL COFF 
  7F76    C5                            PUSH BC
  7F77    01 2475                       LD BC,2475H
  7F7A    CD 7018                       CALL T8         ;CURSOR POS
  7F7D    C1                            POP BC
  7F7E    3A 807D                       LD A,(DAYT)
  7F81    4F                            LD C,A
  7F82    C5                            PUSH BC
  7F83    CD 7F1A                       CALL ASCII_CODE
  7F86    C1                            POP BC
  7F87    78                            LD A,B
  7F88    CD 7812                       CALL HEXC
  7F8B    79                            LD A,C
  7F8C    CD 7812                       CALL HEXC
  7F8F    3E 2E                         LD A,2EH
  7F91    CD 7812                       CALL HEXC
  7F94    3A 807C                       LD A,(DAYM)
  7F97    4F                            LD C,A
  7F98    C5                            PUSH BC
  7F99    CD 7F1A                       CALL ASCII_CODE
  7F9C    C1                            POP BC
  7F9D    78                            LD A,B
  7F9E    CD 7812                       CALL HEXC
  7FA1    79                            LD A,C
  7FA2    CD 7812                       CALL HEXC
  7FA5    18 34                         JR RDU02
                                ;-----------------------
  7FA7    3E 02                         LD A,02H
  7FA9    32 651C                       LD (CURT),A
  7FAC    3E 04                         LD A,04H
  7FAE    32 651D                       LD (CURT+1),A
  7FB1    3A 6B27                       LD A,(RAMT)
  7FB4    CB 7F                         BIT 7,A
  7FB6    28 04                         JR Z,RDU03
  7FB8    3E 00                         LD A,00H
  7FBA    18 02                         JR RDU03+2
  7FBC    3E 01                 RDU03:  LD A,01H
  7FBE    32 651E                       LD (CURT+2),A
  7FC1    3A 6B27                       LD A,(RAMT)
  7FC4    E6 0F                         AND 0FH
        MACRO-80 3.43   27-Jul-81       PAGE    1-51


  7FC6    FE 0A                         CP 0AH
  7FC8    38 0E                         JR C,RDU01
  7FCA    D6 0A                         SUB 0AH
  7FCC    32 651F                       LD (CURT+3),A
  7FCF    3A 651E                       LD A,(CURT+2)
  7FD2    3C                            INC A
  7FD3    32 651E                       LD (CURT+2),A
  7FD6    18 03                         JR RDU02
  7FD8    32 651F               RDU01:  LD (CURT+3),A
                                
  7FDB    CD 7AAA               RDU02:  CALL RLIST      
  7FDE    21 808F                       LD HL,CURON     ; CURSOR ON
  7FE1    06 06                         LD B,06D
  7FE3    7E                    CUR03:  LD A,(HL)
  7FE4    CD 7812                       CALL HEXC
  7FE7    23                            INC HL
  7FE8    10 F9                         DJNZ CUR03
  7FEA    C9                            RET
                                ;------------------
                                ;INCLUDE LCDINI.MAC
                                ;------------------
                                        ;
                                        ; BUS INTERN UMSCHALTUNG
                                        ;
  7FEB    DB 1C                 INTERN: IN A,(PIOA)
  7FED    F5                            PUSH AF
  7FEE    CB BF                         RES 7,A
  7FF0    18 05                         JR TERN
  7FF2    DB 1C                 EXTERN: IN A,(PIOA)
  7FF4    F5                            PUSH AF
  7FF5    CB FF                         SET 7,A
  7FF7    D3 1C                 TERN:   OUT (PIOA),A
  7FF9    F1                            POP AF
  7FFA    C9                            RET
                                ;----------------
  7FFB                          EPROMON:        
  7FFB    DB 1C                         IN A,(PIOA)
  7FFD    CB B7                         RES 6,A
  7FFF    D3 1C                         OUT (PIOA),A    ; EPROM Ein
  8001    C3 0000                       JP 0000H        ; EPROM NEUSTART -> PROGRAMM ENDE
                                ;------------------------
  8004    42 4C 41 53           TEX1:   DEFM 'BLASE VERGLEICH:'
  8008    45 20 56 45           
  800C    52 47 4C 45           
  8010    49 43 48 3A           
                                ;TEX1I: DEFB 78H,78H,78H,78H    
  0010                          TXL     EQU $-TEX1
                                
  8014    42 4C 41 53           TEX2:   DEFM 'BLASE GEFUNDEN: '
  8018    45 20 47 45           
  801C    46 55 4E 44           
  8020    45 4E 3A 20           
  8024    00 00 00 00           TEX2I:  DEFB 00H,00H,00H,00H    
                                
  8028    4B 49 53 59           TEX3:   DEFM 'KISYS 08.12.2009/17'
  802C    53 20 30 38           
        MACRO-80 3.43   27-Jul-81       PAGE    1-52


  8030    2E 31 32 2E           
  8034    32 30 30 39           
  8038    2F 31 37              
  0013                          TXL3    EQU $-TEX3
                                ;-----------------------
                                ;  BIOS Function Summary
                                
  803B    C5                    BIOS:   PUSH    BC
  803C    E5                            PUSH    HL
  803D    5E                            LD      E,(HL)          ; Speicher Lesen 
  803E    CD 0005                       CALL    0005H
  8041    E1                            POP     HL
  8042    C1                            POP     BC
  8043    23                            INC     HL
  8044    10 F5                         DJNZ    BIOS
  8046    C9                            RET
                                ;----------------------
                                ; Blasen Adress Buffer
                                
  8047    00 00 00 00           BF00:   DEFB    00H,00H,00H,00H,80H,00H         ; U,T1,T2 Zaehler zum Blase eroeffnen
  804B    80 00                 
  804D    00 00 00 00           BF01:   DEFB    00H,00H,00H,00H,00H,00H         ; LAST CURSOR POS XX,YY
  8051    00 00                 
  8053    00 00 00 00           BF02:   DEFB    00H,00H,00H,00H,00H,00H
  8057    00 00                 
  8059    00 00 00 00           BF03:   DEFB    00H,00H,00H,00H,00H,00H
  805D    00 00                 
  805F    00 00 00 00           BF04:   DEFB    00H,00H,00H,00H,00H,00H
  8063    00 00                 
  8065    00 00 00 00           BF05:   DEFB    00H,00H,00H,00H,00H,00H
  8069    00 00                 
  806B    00 00 00 00           BF06:   DEFB    00H,00H,00H,00H         ; Datenbankverwaltung
  806F    00 00 00 00           BF07:   DEFB    00H,00H,00H,00H         ; Letzte HDD SORTIERADRESSE
                                ;----------------------
  8073    00 00 00 00           BF10:   DEFB    00H,00H,00H,00H,00H,00H,00H,00H ; User Type, G.Zaehler
  8077    00 00 00 00           
                                ;----------------------
                                ; Kalender
  807B    30                    DAYJ:   DEFB    30H
  807C    30                    DAYM:   DEFB    30H
  807D    30                    DAYT:   DEFB    30H
  807E    30 30 30 30           DAYZ:   DEFB    30H,30H,30H,30H,30H,30H
  8082    30 30                 
                                
                                ;----------------------
                                ; Eingabe Meldung Zeile 24, Spalte 1
  0007                          CURUD   EQU 07H                 ; Zaehlen ab 01 - 09
  8084    00 00                 ZEIL:   DEFB 00H,00H
  8086    1B 5B 31 6D           COL01:  DEFB 1BH,5BH,31H,6DH,1BH,5BH,34H,34H,6DH        ;COLOR
  808A    1B 5B 34 34           
  808E    6D                    
  808F    1B 5B 3F 32           CURON:  DEFB 1BH,5BH,3FH,32H,35H,68H            ;SET CURSOR ON
  8093    35 68                 
  8095    1B 5B 3F 32           CUROFF: DEFB 1BH,5BH,3FH,32H,35H,6CH            ;SET CURSOR OFF
  8099    35 6C                 
  809B    1B 5B 32 34           EBUFF:  DEFB 1BH,5BH,'2','4',';','0','1','H'
        MACRO-80 3.43   27-Jul-81       PAGE    1-53


  809F    3B 30 31 48           
  80A3    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  80A7    6D                    
  80A8    20 20 20 20                   DEFM '                           '
  80AC    20 20 20 20           
  80B0    20 20 20 20           
  80B4    20 20 20 20           
  80B8    20 20 20 20           
  80BC    20 20 20 20           
  80C0    20 20 20              
  80C3    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  80C7    3B 30 31 48           
  80CB    53 75 63 68           EBUFFE: DEFM 'Suche:'
  80CF    65 3A                 
  0036                          EZLEN   EQU $-EBUFF
  80D1    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  80D5    3B 30 31 48           
  80D9    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  80DD    6D                    
  80DE    4C 69 73 74                   DEFM 'List                '
  80E2    20 20 20 20           
  80E6    20 20 20 20           
  80EA    20 20 20 20           
  80EE    20 20 20 20           
  80F2    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  80F6    3B 30 31 48           
  80FA    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  80FE    6D                    
  80FF    8E 6E 64 65                   DEFM  142D,'ndern              '
  8103    72 6E 20 20           
  8107    20 20 20 20           
  810B    20 20 20 20           
  810F    20 20 20 20           
  8113    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  8117    3B 30 31 48           
  811B    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  811F    6D                    
  8120    53 70 65 69                   DEFM 'Speichern           '
  8124    63 68 65 72           
  8128    6E 20 20 20           
  812C    20 20 20 20           
  8130    20 20 20 20           
  8134    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  8138    3B 30 31 48           
  813C    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  8140    6D                    
  8141    56 65 72 67                   DEFM 'Vergessen           '
  8145    65 73 73 65           
  8149    6E 20 20 20           
  814D    20 20 20 20           
  8151    20 20 20 20           
  8155    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  8159    3B 30 31 48           
  815D    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  8161    6D                    
  8162    45 6E 64 65                   DEFM 'Ende                '
        MACRO-80 3.43   27-Jul-81       PAGE    1-54


  8166    20 20 20 20           
  816A    20 20 20 20           
  816E    20 20 20 20           
  8172    20 20 20 20           
                                
  8176    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  817A    3B 30 31 48           
  817E    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  8182    6D                    
  8183    20 20 20 4C                   DEFM '   List             '
  8187    69 73 74 20           
  818B    20 20 20 20           
  818F    20 20 20 20           
  8193    20 20 20 20           
                                
  8197    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  819B    3B 30 31 48           
  819F    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  81A3    6D                    
  81A4    20 20 8E 6E                   DEFM '  ',142D,'ndern               '
  81A8    64 65 72 6E           
  81AC    20 20 20 20           
  81B0    20 20 20 20           
  81B4    20 20 20 20           
  81B8    20 20 20              
                                
  81BB    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  81BF    3B 30 31 48           
  81C3    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  81C7    6D                    
  81C8    41 6E 6C 65                   DEFM 'Anlegen             '
  81CC    67 65 6E 20           
  81D0    20 20 20 20           
  81D4    20 20 20 20           
  81D8    20 20 20 20           
                                
  81DC    1B 5B 32 34                   DEFB 1BH,5BH,'2','4',';','0','1','H'
  81E0    3B 30 31 48           
  81E4    1B 5B 33 37                   DEFB 1BH,5BH,'3','7','m'        ; Vordergrund Zeichen
  81E8    6D                    
  81E9    53 70 65 69                   DEFM 'Speichern           '
  81ED    63 68 65 72           
  81F1    6E 20 20 20           
  81F5    20 20 20 20           
  81F9    20 20 20 20           
                                
  81FD    3A                            DEFB ':'        ; Ende Text
                                
  81FE                          ZCUR:
                                ;!!!    DEFB 08H                                
  81FE    4C 49 53 54                   DEFM 'LISTF.COM   '                             
  8202    46 2E 43 4F           
  8206    4D 20 20 20           
                                ;!!!    DEFB 07H        
  820A    4D 45 4D 2E                   DEFM 'MEM.COM     '
  820E    43 4F 4D 20           
        MACRO-80 3.43   27-Jul-81       PAGE    1-55


  8212    20 20 20 20           
                                ;!!!    DEFB 08H                                
  8216    45 44 49 54                   DEFM 'EDIT.COM'                         
  821A    2E 43 4F 4D           
                                
                                ;----------------------
                                
  821E                          PRLO1:
                                ;!!!    DEFB 08H
  821E    46 41 4B 54                   DEFM 'FAKT.COM'
  8222    2E 43 4F 4D           
                                
  8226    53 74 61 72           STEX:   DEFM 'Start Programm  '
  822A    74 20 50 72           
  822E    6F 67 72 61           
  8232    6D 6D 20 20           
  0010                          LSTEX   EQU $-STEX
                                
  8236    4B 49 53 79           LCDE:   DEFM  'KISystem Winterhalter'
  823A    73 74 65 6D           
  823E    20 57 69 6E           
  8242    74 65 72 68           
  8246    61 6C 74 65           
  824A    72                    
  0015                          LCDEX   EQU     $-LCDE
                                
  824B    1B 5B 31 35           COMZ:   DEFB 1BH,5BH,31H,35H,3BH,30H,31H,48H,1BH,5BH,30H,4AH
  824F    3B 30 31 48           
  8253    1B 5B 30 4A           
  8257    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH,1BH,5BH,34H,32H,6DH
  825B    6D 1B 5B 34           
  825F    32 6D                 
  8261    43 6F 6D 6D                   DEFM  'Commando Zeile= '
  8265    61 6E 64 6F           
  8269    20 5A 65 69           
  826D    6C 65 3D 20           
  0026                          COMZX   EQU     $-COMZ
                                
                                
  8271    1B 5B 32 34           KEYZ:   DEFB 1BH,5BH,32H,34H,3BH,30H,31H,48H
  8275    3B 30 31 48           
  8279    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH,1BH,5BH,34H,32H,6DH
  827D    6D 1B 5B 34           
  8281    32 6D                 
  8283    4B 45 59 20                   DEFM  'KEY Stepp= '
  8287    53 74 65 70           
  828B    70 3D 20              
  001D                          KEYZX   EQU     $-KEYZ
                                
  828E    1B 5B 30 31           MELD01: DEFB 1BH,5BH,30H,31H,3BH,30H,31H,48H
  8292    3B 30 31 48           
  8296    1B 5B 33 31                   DEFB 1BH,5BH,33H,31H,6DH,1BH,5BH,34H,34H,6DH
  829A    6D 1B 5B 34           
  829E    34 6D                 
  82A0    44 69 65 73                   DEFM  'Dieser Begriff ist mir nicht bekannt'
  82A4    65 72 20 42           
        MACRO-80 3.43   27-Jul-81       PAGE    1-56


  82A8    65 67 72 69           
  82AC    66 66 20 69           
  82B0    73 74 20 6D           
  82B4    69 72 20 6E           
  82B8    69 63 68 74           
  82BC    20 62 65 6B           
  82C0    61 6E 6E 74           
  0036                          MELD01X EQU     $-MELD01
                                
  82C4    1B 5B 32 34           PROZ:   DEFB 1BH,5BH,32H,34H,3BH,30H,31H,48H
  82C8    3B 30 31 48           
  82CC    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH,1BH,5BH,34H,32H,6DH
  82D0    6D 1B 5B 34           
  82D4    32 6D                 
  82D6    44 61 74 65                   DEFM  'Dateiname= Dez/Text'
  82DA    69 6E 61 6D           
  82DE    65 3D 20 44           
  82E2    65 7A 2F 54           
  82E6    65 78 74              
  0025                          PROZX   EQU     $-PROZ
                                
  82E9    1B 5B 32 34           DERR:   DEFB 1BH,5BH,32H,34H,3BH,31H,31H,48H
  82ED    3B 31 31 48           
  82F1    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH,1BH,5BH,34H,37H,6DH
  82F5    6D 1B 5B 34           
  82F9    37 6D                 
  82FB    44 49 53 4B                   DEFM  'DISK / HDD ERROR $'
  82FF    20 2F 20 48           
  8303    44 44 20 45           
  8307    52 52 4F 52           
  830B    20 24                 
  830D    05 05                         DEFB 05H,05H
  0026                          L_DERR  EQU $-DERR
                                ;---------------------------
  830F    43 00 00 00           NBLASE: DEFB  MNBL1,00H,00H,00H,80H,00H                       ;         
  8313    80 00                 
                                        ;------------------
  8315    1B 5B 32 4A           NBL1:   DEFB  1BH,5BH,32H,4AH,1BH,5BH,48H,1BH,5BH,33H,37H,6DH ; 12 Zeichen
  8319    1B 5B 48 1B           
  831D    5B 33 37 6D           
  8321    1B 5B 31 6D                   DEFB  1BH,5BH,31H,6DH,1BH,5BH,34H,34H,6DH             ; 9 ZEICHEN
  8325    1B 5B 34 34           
  8329    6D                    
  832A    20 20 20 20                   DEFM '                                              ' ; 46 ZEICHEN
  832E    20 20 20 20           
  8332    20 20 20 20           
  8336    20 20 20 20           
  833A    20 20 20 20           
  833E    20 20 20 20           
  8342    20 20 20 20           
  8346    20 20 20 20           
  834A    20 20 20 20           
  834E    20 20 20 20           
  8352    20 20 20 20           
  8356    20 20                 
  0043                          MNBL1   EQU $-NBL1
        MACRO-80 3.43   27-Jul-81       PAGE    1-57


                                        ; ??? key or grafic ??? 
  8358    00                            DEFB 00H                                ; no key no grafic output
                                        ; Programm
  8359    01                            DEFB 01H                                ; Programme
  835A    4D 41 53 4B                   DEFM 'MASKE1.COM  '                     ; 12 ZEICHEN
  835E    45 31 2E 43           
  8362    4F 4D 20 20           
  8366    39                            DEFB MNBL2 ;57D                         ; zum naechsten Textlaenge
  8367    1B 5B 33 37           NBL2:   DEFB 1BH,5BH,33H,37H,6DH                ; 5 ZEICHEN
  836B    6D                    
  836C    1B 5B 30 33                   DEFB 1BH,5BH,30H,33H,3BH,30H,31H,48H    ; 8 ZEICHEN
  8370    3B 30 31 48           
  8374    09 09 09                      DEFB 09H,09H,09H                        ; 3 ZEICHEN     
  8377    4E 65 75 65                   DEFM 'Neue Seite eroeffnet'             ; 20 ZEICHEN
  837B    20 53 65 69           
  837F    74 65 20 65           
  8383    72 6F 65 66           
  8387    66 6E 65 74           
  838B    0A 0D                         DEFB 0AH,0DH                            ; 2 ZEICHEN     
  838D    20 31 20 20                   DEFM ' 1  A'                            ; 5 ZEICHEN
  8391    41                    
  8392    0A 0D                         DEFB 0AH,0DH                            ; 2 ZEICHEN
  8394    20 32 20 20                   DEFM ' 2  S'                            ; 5 ZEICHEN     
  8398    53                    
  8399    0A 0D                         DEFB 0AH,0DH                            ; 2 ZEICHEN
  839B    20 39 20 20                   DEFM ' 9  E'                            ; 5 ZEICHEN
  839F    45                    
  0039                          MNBL2   EQU $-NBL2
                                        ; TASTE
  83A0    10                    MFILE:  DEFB 10H
                                        ; PROGRAMM
  83A1    02                            DEFB 02H
  83A2    41 55 54 4F                   DEFM 'AUTO.COM    '
  83A6    2E 43 4F 4D           
  83AA    20 20 20 20           
  83AE    4D 45 4D 2E                   DEFM 'MEM.COM     '
  83B2    43 4F 4D 20           
  83B6    20 20 20 20           
  83BA    20 20 20 20                   DEFM '            '
  83BE    20 20 20 20           
  83C2    20 20 20 20           
  83C6    20 20 20 20                   DEFM '            '
  83CA    20 20 20 20           
  83CE    20 20 20 20           
  83D2    20 20 20 20                   DEFM '            '
  83D6    20 20 20 20           
  83DA    20 20 20 20           
  83DE    20 20 20 20                   DEFM '            '
  83E2    20 20 20 20           
  83E6    20 20 20 20           
  83EA    20 20 20 20                   DEFM '            '
  83EE    20 20 20 20           
  83F2    20 20 20 20           
  83F6    20 20 20 20                   DEFM '            '
  83FA    20 20 20 20           
  83FE    20 20 20 20           
        MACRO-80 3.43   27-Jul-81       PAGE    1-58


  8402    20 20 20 20                   DEFM '            '
  8406    20 20 20 20           
  840A    20 20 20 20           
  840E    00 00                         DEFB 00H,00H     ; 00= keine Keyeingabe folgend, 00= kein Progr.
  0101                          NBLLE   EQU     $-NBLASE
                                ;----------------------
  8410    43 00 00 01           TBLASE: DEFB  MTBLA1,00H,00H,01H,80H,00H                                ;       
  8414    80 00                 
                                        ;------------
  8416    1B 5B 30 6D           TBLA1:  DEFB  1BH,5BH,30H,6DH,1BH,5BH,48H,1BH,5BH,33H,37H,6DH   ; 12 Zeichen
  841A    1B 5B 48 1B           
  841E    5B 33 37 6D           
  8422    1B 5B 31 6D                   DEFB  1BH,5BH,31H,6DH,1BH,5BH,34H,34H,6DH               ; 9 ZEICHEN
  8426    1B 5B 34 34           
  842A    6D                    
  842B    20 20 20 20                   DEFM '            Leere BLASE                       ' ; 46 ZEICHEN
  842F    20 20 20 20           
  8433    20 20 20 20           
  8437    4C 65 65 72           
  843B    65 20 42 4C           
  843F    41 53 45 20           
  8443    20 20 20 20           
  8447    20 20 20 20           
  844B    20 20 20 20           
  844F    20 20 20 20           
  8453    20 20 20 20           
  8457    20 20                 
  0043                          MTBLA1  EQU $-TBLA1
                                        ; Taste
  8459    00                            DEFB 00H                                        ; Key Eingabe
                                        ; Programm
  845A    01                            DEFB 01H                                        ; Programme
  845B    41 55 54 4F                   DEFM 'AUTO.COM    '                             ; 10 ZEICHEN
  845F    2E 43 4F 4D           
  8463    20 20 20 20           
  8467    2A                            DEFB MTBL2
  8468    1B 5B 33 37           TBL2:   DEFB 1BH,5BH,33H,37H,6DH                ; 5 ZEICHEN
  846C    6D                    
  846D    1B 5B 30 33                   DEFB 1BH,5BH,30H,33H,3BH,30H,31H,48H    ; 8 ZEICHEN
  8471    3B 30 31 48           
  8475    2A 2A 2A 2A                   DEFM '***********************      '
  8479    2A 2A 2A 2A           
  847D    2A 2A 2A 2A           
  8481    2A 2A 2A 2A           
  8485    2A 2A 2A 2A           
  8489    2A 2A 2A 20           
  848D    20 20 20 20           
  8491    20                    
  002A                          MTBL2   EQU $-TBL2
                                        ; TASTE
  8492    10                            DEFB 10H
                                        ; PROGRAMM
  8493    02                            DEFB 02H
  8494    54 45 4E 44                   DEFM 'TENDE.COM   '
  8498    45 2E 43 4F           
  849C    4D 20 20 20           
        MACRO-80 3.43   27-Jul-81       PAGE    1-59


  84A0    20 20 20 20                   DEFM '            '
  84A4    20 20 20 20           
  84A8    20 20 20 20           
  84AC    20 20 20 20                   DEFM '            '
  84B0    20 20 20 20           
  84B4    20 20 20 20           
  84B8    20 20 20 20                   DEFM '            '
  84BC    20 20 20 20           
  84C0    20 20 20 20           
  84C4    20 20 20 20                   DEFM '            '
  84C8    20 20 20 20           
  84CC    20 20 20 20           
  84D0    20 20 20 20                   DEFM '            '
  84D4    20 20 20 20           
  84D8    20 20 20 20           
  84DC    20 20 20 20                   DEFM '            '
  84E0    20 20 20 20           
  84E4    20 20 20 20           
  84E8    20 20 20 20                   DEFM '            '
  84EC    20 20 20 20           
  84F0    20 20 20 20           
  84F4    20 20 20 20                   DEFM '            '
  84F8    20 20 20 20           
  84FC    20 20 20 20           
  8500    00 00                         DEFB 00H,00H     ; 00= keine Keyeingabe folgend, 00= kein Progr.
  00F2                          TBLLE   EQU $-TBLASE
                                ;-----------------------------
  8502    36 00 02 00           SMASKE: DEFB MSMAS1,00H,02H,00H,76H,80H
  8506    76 80                 
                                        ;-------------------
                                        ; BLOCK LAENG OBEN SMASKE ERSTER WERT(43H)
  8508    1B 5B 32 4A           SMAS1:  DEFB 1BH,5BH,32H,4AH,1BH,5BH,48H,1BH,5BH,33H,37H,6DH
  850C    1B 5B 48 1B           
  8510    5B 33 37 6D           
  8514    1B 5B 31 6D                   DEFB 1BH,5BH,31H,6DH,1BH,5BH,34H,34H,6DH
  8518    1B 5B 34 34           
  851C    6D                    
  851D    20 20 20 20                   DEFM '     Ersatzseite KI-System V1.0  ' ;46D Zeichen
  8521    20 45 72 73           
  8525    61 74 7A 73           
  8529    65 69 74 65           
  852D    20 4B 49 2D           
  8531    53 79 73 74           
  8535    65 6D 20 56           
  8539    31 2E 30 20           
  853D    20                    
                                        ;------------------
  0036                          MSMAS1  EQU $-SMAS1
  853E    00                            DEFB 00H        ; 00H no grafic output
  853F    01                            DEFB 01H        ; ANZAHL PROGRAMMAUFRUFE
  8540    4D 45 4D 2E                   DEFM 'MEM.COM     '
  8544    43 4F 4D 20           
  8548    20 20 20 20           
                                
  854C    39                            DEFB MSMAS2
  854D    1B 5B 33 37           SMAS2:  DEFB 1BH,5BH,33H,37H,6DH                        ; 5 ZEICHEN
        MACRO-80 3.43   27-Jul-81       PAGE    1-60


  8551    6D                    
  8552    1B 5B 30 33                   DEFB 1BH,5BH,30H,33H,3BH,30H,31H,48H            ; 8 ZEICHEN
  8556    3B 30 31 48           
  855A    09 09 09                      DEFB 09H,09H,09H                                ; 3 ZEICHEN     
  855D    4E 65 75 65                   DEFM 'Neue TYPE2 eroeffnet'                     ; 20 ZEICHEN
  8561    20 54 59 50           
  8565    45 32 20 65           
  8569    72 6F 65 66           
  856D    66 6E 65 74           
  8571    0A 0D                         DEFB 0AH,0DH                                    ; 2 ZEICHEN     
  8573    20 30 20 41                   DEFM ' 0 A?'                                    ; 5 ZEICHEN
  8577    3F                    
  8578    0A 0D                         DEFB 0AH,0DH                                    ; 2 ZEICHEN
  857A    20 31 20 20                   DEFM ' 1  S'                                    ; 5 ZEICHEN     
  857E    53                    
  857F    0A 0D                         DEFB 0AH,0DH                                    ; 2 ZEICHEN
  8581    20 39 20 20                   DEFM ' 9  E'                                    ; 5 ZEICHEN
  8585    45                    
  0039                          MSMAS2  EQU $-SMAS2
                                        ; TASTE
  8586    10                            DEFB 10H
                                        ; PROGRAMM
  8587    01                            DEFB 01H
  8588    4D 45 4D 2E                   DEFM 'MEM.COM     '
  858C    43 4F 4D 20           
  8590    20 20 20 20           
  8594    20 20 20 20                   DEFM '            '
  8598    20 20 20 20           
  859C    20 20 20 20           
  85A0    20 20 20 20                   DEFM '            '
  85A4    20 20 20 20           
  85A8    20 20 20 20           
  85AC    20 20 20 20                   DEFM '            '
  85B0    20 20 20 20           
  85B4    20 20 20 20           
  85B8    20 20 20 20                   DEFM '            '
  85BC    20 20 20 20           
  85C0    20 20 20 20           
  85C4    20 20 20 20                   DEFM '            '
  85C8    20 20 20 20           
  85CC    20 20 20 20           
  85D0    20 20 20 20                   DEFM '            '
  85D4    20 20 20 20           
  85D8    20 20 20 20           
  85DC    20 20 20 20                   DEFM '            '
  85E0    20 20 20 20           
  85E4    20 20 20 20           
  85E8    20 20 20 20                   DEFM '            '
  85EC    20 20 20 20           
  85F0    20 20 20 20           
  85F4    00 00                         DEFB 00H,00H     ; 00= keine Keyeingabe folgend, 00= kein Progr.
  00F4                          NSMAS   EQU $-SMASKE
                                
                                END
        MACRO-80 3.43   27-Jul-81       PAGE    S


Macros:

Symbols:
7587    _ED12           7859    _WAIT1          7F1A    ASCII_CODE      
7F33    ASC_1           7F43    ASC_2           0047    BAUD1           
0047    BAUD2           0047    BAUD3           8047    BF00            
804D    BF01            8053    BF02            8059    BF03            
805F    BF04            8065    BF05            806B    BF06            
806F    BF07            8073    BF10            6503    BFRHH           
6502    BFRHL           6501    BFRLH           6500    BFRLL           
650F    BFSHH           650E    BFSHL           650D    BFSLH           
650C    BFSLL           650B    BFVHH           650A    BFVHL           
6509    BFVLH           6508    BFVLL           803B    BIOS            
7074    BL              70AF    BL00            70DB    BL000           
70B9    BL00A           70EF    BL01            7184    BL02            
795E    BL021           79BC    BL022           79C2    BL023           
79B6    BL02X           7199    BL03            71B4    BL030           
71AA    BL031           71D2    BL033           72AF    BL04            
796A    BL120           79B7    BL121           7996    BL123           
79A8    BL124           79AF    BL125           7206    BL13            
71EE    BL131           71ED    BL131A          71F3    BL132           
7211    BL13E           72BF    BL14            721C    BL23            
7224    BL231           7234    BL33            723F    BL43            
724A    BL53            726A    BL73            7270    BL736           
727D    BL83            72A1    BL830           72A9    BL831           
7298    BL84            6200    BLAN            72C7    BS10            
6205    BSTAT           0080    BUFF            0020    CMD_READSEC     
0030    CMD_WRITESEC    7832    COFF            7065    COL0            
8086    COL01           706A    COL1            824B    COMZ            
0026    COMZX           7821    CON             6C3F    COP             
0007    CPOS            0010    CTC             7839    CUR01           
7828    CUR02           7FE3    CUR03           8095    CUROFF          
808F    CURON           6518    CURS            651C    CURT            
0007    CURUD           77DB    CUT             807B    DAYJ            
807C    DAYM            807D    DAYT            807E    DAYZ            
00F4    DCI             0001    DCLR            000C    DCON            
82E9    DERR            0002    DHOM            78CB    DISK            
0001    DISPLAY         809B    EBUFF           80CB    EBUFFE          
7524    ED00            7516    ED01            751E    ED02            
7579    ED03            7548    ED10            7570    ED100           
7573    ED11            7585    ED12            759D    ED13            
75BB    ED14            75C0    ED15            75BD    ED20            
75C3    ED30            75DB    ED31            75EE    ED32            
75F0    ED33            75F2    ED40            75FD    ED41            
760C    ED42            7611    ED43            7616    ED44            
7629    ED441           7640    ED442           7644    ED50            
7659    ED51            74FE    EING            765B    EING11          
768A    EING21          769A    EING22          76B5    EING23          
76C5    EING24          76D4    EING25          76ED    EING26          
76EF    EING27          76F7    EING30          0040    EOFF            
7FFB    EPROMON         788B    ERR1            71CD    EXIT            
7FF2    EXTERN          717A    EZ01            7181    EZ02            
7117    EZ03            7147    EZ04            0036    EZLEN           
006F    FBLOCK          005C    FCB             006B    FCBCR           
005D    FCBFN           0065    FCBFT           007C    FCBRA           
791F    FREI            0005    FSET            0800    HDD             
00BE    HDDE            787A    HDD_ERROR       7893    HDD_INFO        
        MACRO-80 3.43   27-Jul-81       PAGE    S-1


7860    HDD_INIT        78A1    HDD_READ        7859    HDD_WAIT        
7E45    HDIST           779A    HEX00           7743    HEX11           
7756    HEX12           779A    HEX14           778F    HEXA            
7812    HEXC            7738    HEXI1           774B    HEXI2           
775A    HEXIE           775D    HEXP            00F0    IDE             
00FD    IDECHI          00FC    IDECLO          00FF    IDECMD          
00F8    IDEDAT          00F6    IDEDOR          00F9    IDEERR          
78AF    IDERES          78B5    IDERES1         00FA    IDESCNT         
00FE    IDESDH          00FB    IDESNUM         00FF    IDESTAT         
7FEB    INTERN          0000    KANAL0          0001    KANAL1          
0003    KANAL3          0004    KANAL4          0005    KANAL5          
7A08    KEY01           7927    KEYB            794D    KEYB1           
0009    KEYBUF          0002    KEYIN           0001    KEYOUT          
79F6    KEYST           8271    KEYZ            001D    KEYZX           
7024    KI              7096    KI1             00F5    LATCH           
7A0A    LBA0            7A53    LBA20           7A54    LBA21           
7A50    LBA4            7A59    LBA5            0060    LCD             
8236    LCDE            0015    LCDEX           7B08    LIS0            
7B0A    LIS1            7AE2    LIST            6513    LOGHH           
6512    LOGHL           6511    LOGLH           6510    LOGLL           
0100    LOS             0120    LOS1            0008    LPOS            
0010    LSTEX           0026    L_DERR          7A93    L__6            
7A8B    L__7            76FD    MAS00           770D    MAS01           
7729    MAS02           79C7    MASK1           79CF    MASK2           
828E    MELD01          0036    MELD01X         83A0    MFILE           
A101    MMC             0007    MMCE            0043    MNBL1           
0039    MNBL2           0036    MSMAS1          0039    MSMAS2          
002A    MTBL2           0043    MTBLA1          8315    NBL1            
8367    NBL2            830F    NBLASE          0101    NBLLE           
00F4    NSMAS           001C    PIOA            001E    PIOB            
821E    PRLO1           0130    PRO             7000    PROG            
82C4    PROZ            0025    PROZX           0005    P_READ          
0006    P_WRITE         6524    RADR            6000    RAM             
0021    RAMH            0000    RAML            6727    RAMS            
6B27    RAMT            6527    RAMV            0000    RBLAN           
0005    RBSTAT          7CEE    RD01            7DAA    RD02            
7D5B    RD03            7C8A    RD06            7B98    RD07            
7B9B    RD08            7BA3    RD09            7CC3    RD16            
7CD0    RD17            7CD8    RD170           7CE3    RD171           
7C2F    RD25            7C61    RD250           7C43    RD255           
7C4D    RD26            7D90    RD30            7C7F    RD35            
7C6D    RD36            7DBE    RD90            7DE2    RD91            
7DE5    RD911           7DEB    RD92            7CA6    RDD1            
7DF8    RDREAD          7FD8    RDU01           7FDB    RDU02           
7FBC    RDU03           7E21    RDWRITE         F814    READ            
0000    REG1            00C1    REG3            0044    REG4            
00EA    REG5            7AAA    RLIST           6526    RMEN            
0006    RSOTR           0004    RTERM           6BEF    RTEX            
0002    RTYPE1          0003    RTYPE2          701E    RUN             
0001    RUSER           77CB    SA1             77CF    SA2             
77D1    SA3             6520    SANDB           77BB    SANDU           
0020    SDC             0004    SELDM           00F7    SELDS           
F838    SELDSK          F82F    SETDMA          F835    SETSEC          
F832    SETTRK          0018    SIOA            001A    SIOB            
0018    SIORES          8508    SMAS1           854D    SMAS2           
8502    SMASKE          8226    STEX            72FA    STX01           
        MACRO-80 3.43   27-Jul-81       PAGE    S-2


72EC    SU00            7300    SU01            734F    SU02            
7352    SU03            7366    SU04            7426    SU21            
74DB    SU23            740B    SU25            74E3    SU32            
74F1    SU33            74B9    SU52            74CD    SU520           
742F    SU62            7461    SU63            73EB    SU80            
73B1    SU83            73BA    SU84            739C    SU85            
73D8    SU86            73E5    SU87            738E    SU88            
7472    SU90            74B6    SU95            7482    SU99            
78FD    SUCH0           790B    SUCH1           790D    SUCH2           
7000    T0              7003    T1              7006    T2              
7009    T3              700C    T4              700F    T5              
7012    T6              7015    T7              7018    T8              
701B    T9              7B15    TAS             7B74    TAS00           
7C02    TAS03           7D2D    TAS22           7D53    TAS24           
7E4D    TASK            7E98    TASK99          FFA2    TASKSP          
8468    TBL2            8416    TBLA1           8410    TBLASE          
00F2    TBLLE           71E2    TEING           6204    TERM            
7FF7    TERN            8004    TEX1            8014    TEX2            
8024    TEX2I           8028    TEX3            0004    TIME1           
0004    TIME2           0004    TIME3           FFAB    TRACK           
FFA5    TRACKH          FFA4    TRACKL          7E9C    TWRITE          
0010    TXL             0013    TXL3            6202    TYPE1           
6203    TYPE2           7EC0    UHR00           7F0D    UHR01           
7F4B    UHR10           0080    URCS            6201    USER            
784E    WAITDRQ         7843    WAITRDY         00F0    WDTCR           
00F1    WDTER           7AC8    WLIST           F817    WRITE           
81FE    ZCUR            7734    ZEI00           8084    ZEIL            



No Fatal error(s)


                                                                                                                                                                                                                                                                                                                    
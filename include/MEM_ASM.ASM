        MACRO-80 3.43   27-Jul-81       PAGE    1


                                ;  MEM.MAC
                                ;  Vers. 1,0  01.01.2008
                                ;        1,1  05.04.2018
                                ;----------------------
                                ;  Winterhalter CPU-System Neu
                                ;  Entwicklungssystem  (c)
                                ;----------------------
                                ;  save current bubble
                                ;---------------------------
                                
                                .Z80
                                
                                ORG 100H
                                
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
  6510                   C      LOGLL   EQU BFSHH+1
  6511                   C      LOGLH   EQU LOGLL+1
  6512                   C      LOGHL   EQU LOGLH+1
  6513                   C      LOGHH   EQU LOGHL+1
  6518                   C      CURS    EQU LOGHH+5     ; Aktuelle Cursor position
  651C                   C      CURT    EQU CURS+4      ; Cursor in Task (UHR)
  6520                   C      SANDB   EQU CURT+4
        MACRO-80 3.43   27-Jul-81       PAGE    1-1


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
                         C      ;-----------------
                         C      ; Call subprogram in bubble
                         C      ; 0,1,2,3,4,.......
                         C      ;
  0001                   C      KEYIN   EQU 01H         ; KEYS INQUERY
  0002                   C      KEYOUT  EQU 02H         ; OUTPUT CHARACTER
                         C      ;
        MACRO-80 3.43   27-Jul-81       PAGE    1-2


  0005                   C      P_READ  EQU 05H         ; HDD READ
  0006                   C      P_WRITE EQU 06H         ; HDD WRITE
  0007                   C      CPOS    EQU 07H         ; POSITION THE CURSOR
                         C      ; ENDE DEFINE
                                ;-----------------
                                ;--------------------------
                                ; START
  0100'   C5                            PUSH BC
  0101'   D5                            PUSH DE
  0102'   E5                            PUSH HL
  0103'   18 24                         JR ST0          ; SPRUNG OHNE ERSTE NEUE SEITE SPEICHER
                                        ;-------------------
                                        ; ZUM SPEICHERN EINER ERSTEN SEITE
                                
  0105'   21 0162'                      LD HL,MASKE
  0108'   11 6000                       LD DE,RAM
  010B'   01 0083                       LD BC,RAL
  010E'   ED B0                         LDIR
  0110'   3E 30                         LD A,30H
  0112'   32 651C                       LD (CURT),A
  0115'   3E 31                         LD A,31H
  0117'   32 651D                       LD (CURT+1),A
  011A'   3E 30                         LD A,30H
  011C'   32 651E                       LD (CURT+2),A
  011F'   3E 31                         LD A,31H
  0121'   32 651F                       LD (CURT+3),A
  0124'   06 07                         LD B,CPOS               ; UNTERPROG. CURSOR IN BLASE SET POS
  0126'   CD 013F'                      CALL UPROG
                                        ;----------------------         
                                        ; AKTUELLE BLASE SPEICHER 
                                        ;
  0129'                         ST0:    ;LD B,P_READ    ; UNTERPROG. RDREAD:
  0129'   06 06                         LD B,P_WRITE    ; UNTERPROG. RDWRITE:
  012B'   CD 0144'                      CALL UPROG1
  012E'   AF                            XOR A
  012F'   32 6200                       LD (BLAN),A
  0132'   E1                            POP HL
  0133'   D1                            POP DE
  0134'   C1                            POP BC
  0135'   C9                            RET
                                        ;----------
  0136'   AF                    STE:    XOR A   
  0137'   32 6200                       LD (BLAN),A
  013A'   37                            SCF
  013B'   E1                            POP HL
  013C'   D1                            POP DE
  013D'   C1                            POP BC
  013E'   C9                            RET
                                        ;-----------
  013F'   CD 0154'              UPROG:  CALL UPROG2
  0142'   D5                            PUSH DE         ; ALS SPRUNGADRESSE BEI RET
  0143'   C9                            RET     ;JP (HL) SPRUNG ALS POP HL Tx   
                                        ;-------------
                                        ;     
  0144'   CD 0154'              UPROG1: CALL UPROG2
  0147'   D5                            PUSH DE         ; ALS SPRUNGADRESSE BEI RET
        MACRO-80 3.43   27-Jul-81       PAGE    1-3


                                        ;LD BC,HDD      ;(BFRLL)
                                        ;LD DE,0000H    ;(BFRHL)
  0148'   ED 4B 6500                    LD BC,(BFRLL)
  014C'   ED 5B 6502                    LD DE,(BFRHL)
  0150'   21 6000                       LD HL,RAM
  0153'   C9                            RET     ;JP (HL) SPRUNG ALS POP HL Tx   
                                        ;--------------
                                        ; DIE SPRUNGADRESSE IN DE LADEN
                                        ;
  0154'   21 7000               UPROG2: LD HL,PROG
  0157'   11 0003                       LD DE,03H       ; ABSTAND 3BYTE SPRUNGBEFEHL
  015A'   19                    SUM:    ADD HL,DE
  015B'   10 FD                         DJNZ SUM
  015D'   23                            INC HL          ; JP BEFEHL (C3) UEBERSPRINGEN
  015E'   5E                            LD E,(HL)
  015F'   23                            INC HL
  0160'   56                            LD D,(HL)
  0161'   C9                            RET
                                ;--------------------
  0162'   43 00 02 00           MASKE:  DEFB MBILD1,00H,02H,00H,76H,80H
  0166'   76 80                 
  0168'   1B 5B 32 4A           BILD1:  DEFB 1BH,5BH,32H,4AH,1BH,5BH,48H,1BH,5BH,33H
  016C'   1B 5B 48 1B           
  0170'   5B 33                 
  0172'   37 6D 1B 5B                   DEFB 37H,6DH,1BH,5BH,31H,6DH,1BH,5BH
  0176'   31 6D 1B 5B           
  017A'   34 34 6D                      DEFB 34H,34H,6DH
  017D'   53 74 61 72                   DEFM 'Start (MEM)                                   '   ; 46 Zeichen
  0181'   74 20 28 4D           
  0185'   45 4D 29 20           
  0189'   20 20 20 20           
  018D'   20 20 20 20           
  0191'   20 20 20 20           
  0195'   20 20 20 20           
  0199'   20 20 20 20           
  019D'   20 20 20 20           
  01A1'   20 20 20 20           
  01A5'   20 20 20 20           
  01A9'   20 20                 
  0043                          MBILD1  EQU $-BILD1     
  01AB'   00                            DEFB 00H
  01AC'   01                            DEFB 01H        ; ANZAHL PROGRAMMAUFRUFE
  01AD'   0A                            DEFB 0AH        ; FILE NAME LAENGE
  01AE'   4D 41 53 4B                   DEFM 'MASKE1.COM'
  01B2'   45 31 2E 43           
  01B6'   4F 4D                 
  01B8'   20 20 20 20                   DEFM '       Startseite KI-System V1.0 '
  01BC'   20 20 20 53           
  01C0'   74 61 72 74           
  01C4'   73 65 69 74           
  01C8'   65 20 4B 49           
  01CC'   2D 53 79 73           
  01D0'   74 65 6D 20           
  01D4'   56 31 2E 30           
  01D8'   20                    
  01D9'   0D 0A                         DEFB 0DH,0AH
        MACRO-80 3.43   27-Jul-81       PAGE    1-4


  01DB'   10                            DEFB 10H        ; TASTATUR MENGE ZEICHENEINGABE
  01DC'   01                            DEFB 01H        ; ANZAHL PROGRAMMAUFRUFE
  01DD'   07                            DEFB 07H        ; FILE NAME LAENGE
  01DE'   4D 45 4D 2E                   DEFM 'MEM.COM'
  01E2'   43 4F 4D              
                                
  0083                          RAL     EQU $-MASKE
                                
                                END
        MACRO-80 3.43   27-Jul-81       PAGE    S


Macros:

Symbols:
6503    BFRHH           6502    BFRHL           6501    BFRLH           
6500    BFRLL           650F    BFSHH           650E    BFSHL           
650D    BFSLH           650C    BFSLL           650B    BFVHH           
650A    BFVHL           6509    BFVLH           6508    BFVLL           
0168'   BILD1           6200    BLAN            6205    BSTAT           
0080    BUFF            0020    CMD_READSEC     0030    CMD_WRITESEC    
6C3F    COP             0007    CPOS            6518    CURS            
651C    CURT            005C    FCB             006B    FCBCR           
005D    FCBFN           0065    FCBFT           007C    FCBRA           
0800    HDD             00BE    HDDE            00F0    IDE             
00FD    IDECHI          00FC    IDECLO          00FF    IDECMD          
00F8    IDEDAT          00F6    IDEDOR          00F9    IDEERR          
00FA    IDESCNT         00FE    IDESDH          00FB    IDESNUM         
00FF    IDESTAT         0001    KEYIN           0002    KEYOUT          
6513    LOGHH           6512    LOGHL           6511    LOGLH           
6510    LOGLL           0162'   MASKE           0043    MBILD1          
A101    MMC             0007    MMCE            7000    PROG            
0005    P_READ          0006    P_WRITE         6524    RADR            
0083    RAL             6000    RAM             6727    RAMS            
6B27    RAMT            6527    RAMV            0000    RBLAN           
0005    RBSTAT          6526    RMEN            0006    RSOTR           
0004    RTERM           6BEF    RTEX            0002    RTYPE1          
0003    RTYPE2          0001    RUSER           6520    SANDB           
0004    SELDM           00F7    SELDS           0129'   ST0             
0136'   STE             015A'   SUM             6204    TERM            
6202    TYPE1           6203    TYPE2           013F'   UPROG           
0144'   UPROG1          0154'   UPROG2          6201    USER            



No Fatal error(s)


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
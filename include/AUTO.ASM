        MACRO-80 3.43   27-Jul-81       PAGE    1
17:55 21.04.2018

                                ;  AUTO.MAC
                                ;  Vers. 1.0  01.01.2009
                                ;        1.1  05.04.2018
                                ;----------------------
                                ;  Winterhalter CPU-System Neu
                                ;  ASCII-EDITOR  (c)
                                ;----------------------
                                
  0000'                         ASEG
                                
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
  0001                   C      KEYOUT  EQU 01H         ; KEYS INQUERY
  0002                   C      KEYIN   EQU 02H         ; READ OUTPUT CHARACTER
                         C      ;
        MACRO-80 3.43   27-Jul-81       PAGE    1-2


  0005                   C      P_READ  EQU 05H         ; HDD READ
  0006                   C      P_WRITE EQU 06H         ; HDD WRITE
  0007                   C      CPOS    EQU 07H         ; POSITION THE CURSOR
                         C      ; ENDE DEFINE
                                ;-----------------
                                ;--------------------------
  0020                          FDC     EQU 20H         ; SD-CART
  0060                          LCD     EQU 60H         ; LCD-Display
  0080                          URCS    EQU 80H         ; 2K IO-RAM AND CLOCK
  001E                          PIOB    EQU 1EH         ; PIO B
                                ;--------------------------
                                ; START
                                ;
  0100    C5                            PUSH BC
  0101    D5                            PUSH DE
  0102    E5                            PUSH HL
                                        ;-----------------
                                        ; PROGRAM ONLY RUNS IN TYPE2 > 0
                                        ;
  0103    3A 6003                       LD A,(RAM+RTYPE2)
  0106    FE 00                         CP 0
                                ;??     JP Z,AUEND              ; OUTPUT IF TYPE2 <1
                                        ;--------------------
                                        ; SET CURSOR ON START POSITION
                                        ;
  0108    3E 00                         LD A,00H
  010A    32 651C                       LD (CURT),A
  010D    3E 03                         LD A,03H
  010F    32 651D                       LD (CURT+1),A
  0112    3E 00                         LD A,00H
  0114    32 651E                       LD (CURT+2),A
  0117    3E 01                         LD A,01H
  0119    32 651F                       LD (CURT+3),A
  011C    06 07                         LD B,CPOS               ; SUBROUTINE CALL CURSOR IN BLASE ON POSITION
  011E    CD 03BC                       CALL UPROG
                                        ;-----------------
                                        ; PUT TEXT OUT
                                        ;       
  0121    21 03DF                       LD HL,TTEX
  0124    06 36                         LD B,TTLEN
  0126    CD 0393                       CALL CURPOS
  0129    7E                    TT01:   LD A,(HL)
  012A    C5                            PUSH BC
  012B    E5                            PUSH HL
  012C    06 01                         LD B,KEYOUT     ; SUBROUTINE KEY CALL OUTPUT IN BLASE
  012E    CD 03BC                       CALL UPROG
  0131    E1                            POP HL
  0132    C1                            POP BC
  0133    23                            INC HL
  0134    10 F3                         DJNZ TT01
  0136    06 02                 KEY0:   LD B,KEYIN      ; CALL SUBROUTINE KEY INPUT IN BLASE
  0138    CD 03BC                       CALL UPROG
  013B    FE 00                         CP 0
  013D    28 F7                         JR Z,KEY0       ;->NO KEY 
  013F    C3 0382                       JP AUEND
                                        ;-----------------
        MACRO-80 3.43   27-Jul-81       PAGE    1-3


                                        ; NAECHSTE FREIE TYPE2 >1 SUCHEN
                                        ; USER ,TYPE1 MUSS GLEICHBLEIBEN
                                
  0142    3E 01                         LD      A,01H
  0144    32 0419                       LD      (BF03),A        ; TYPE2 ZAEHLER
  0147    ED 5B 6500                    LD      DE,(BFRLL)
  014B    ED 53 0415                    LD      (BF02),DE
  014F    2A 6502                       LD      HL,(BFRHL)
  0152    22 0417                       LD      (BF02+2),HL     ; ADRESSE TYPE2=1 RETTEN
  0155                          FI00:   ;CALL   LBA0
  0155    DA 0382                       JP      C,AUEND
  0158    ED 53 6508                    LD      (BFVLL),DE
  015C    22 650A                       LD      (BFVHL),HL
  015F    ED 4B 6508                    LD      BC,(BFVLL)
  0163    ED 5B 650A                    LD      DE,(BFVHL)
                                        ;CALL   DISK
  0167    01 6527                       LD      BC,RAMV
                                        ;--------------------
                                        ; USER VERGLEICHEN
  016A    3A 6001                       LD      A,(RAM+RUSER)
  016D    47                            LD      B,A
  016E    3A 6528                       LD      A,(RAMV+RUSER)
  0171    B8                            CP      B
  0172    38 40                         JR      C,FI61
  0174    20 48                         JR      NZ,FI10
                                        ;---------------------
                                        ; TYPE1 VERGLEICHEN
  0176    3A 6002                       LD      A,(RAM+RTYPE1)
  0179    47                            LD      B,A
  017A    3A 6529                       LD      A,(RAMV+RTYPE1)
  017D    B8                            CP      B
  017E    20 34                         JR      NZ,FI61
                                        ;---------------------
                                        ; TYPE2 MUSS >0 SEIN 2
  0180    3A 652A                       LD      A,(RAMV+RTYPE2)
  0183    FE 02                         CP      02H
  0185    38 2D                         JR      C,FI61
                                        ;---------------------
                                        ; COPY SUCHTEXT AUS EINGABE ZUR]CH NACH RAMT
  0187    21 6BEF                       LD      HL,RTEX
  018A    11 6B27                       LD      DE,RAMT
  018D    46                            LD      B,(HL)
  018E    7E                            LD      A,(HL)
  018F    12                            LD      (DE),A  
  0190    13                            INC     DE
  0191    23                            INC     HL
  0192    7E                    TY00:   LD      A,(HL)
  0193    12                            LD      (DE),A
  0194    13                            INC     DE
  0195    23                            INC     HL
  0196    10 FA                         DJNZ    TY00
                                        ;-------------------
                                        ; SUCHE NACH WEITEREN EINTRAEGEN
                                        ; UND BESTIMME NAECHSTE BLASE
  0198    21 6527                       LD      HL,RAMV
  019B    3A 6B27                       LD      A,(RAMT)
        MACRO-80 3.43   27-Jul-81       PAGE    1-4


  019E    11 6B28                       LD      DE,RAMT+1
  01A1    06 3F                         LD      B,3FH
  01A3    21 652C                       LD      HL,RAMV+RBSTAT
                                        ;CALL   SUCH0
  01A6    38 0C                         JR      C,FI61
  01A8    3A 0419               FI60:   LD      A,(BF03)
  01AB    3C                            INC     A
                                        ; JR    Z,  UEBERLAUF ABFABGEN  ????
  01AC    32 0419                       LD      (BF03),A
  01AF    CB EF                         SET     5,A
  01B1    CD 03AD                       CALL    TEXOUT
  01B4    ED 5B 6508            FI61:   LD      DE,(BFVLL)
  01B8    2A 650A                       LD      HL,(BFVHL)
  01BB    C3 0155                       JP      FI00
                                        ;--------------------
                                        ; NEUE BLASE MUSS TERM = 0 SEIN
  01BE    3A 652B               FI10:   LD      A,(RAMV+RTERM)
  01C1    FE 00                         CP      0
  01C3    20 EF                         JR      NZ,FI61
  01C5    3A 0419                       LD      A,(BF03)
  01C8    3C                            INC     A
                                        ; JR    Z,  UEBERLAUF ABFRAGEN ???
  01C9    32 6003                       LD      (RAM+RTYPE2),A
  01CC    3E FE                         LD      A,0FEH
  01CE    32 6004                       LD      (RAM+RTERM),A           
  01D1    2A 6508                       LD      HL,(BFVLL)      
  01D4    22 6500                       LD      (BFRLL),HL
  01D7    2A 650A                       LD      HL,(BFVHL)
  01DA    22 6502                       LD      (BFRHL),HL
                                
                                        ;-----------------
                                        ; UEBERSPRINGE ERSTER BLOCK
                                        ; UND ZWEITER BLOCK BIS TEXTBEGIN
                                
  01DD    21 6000               FI99:   LD      HL,RAM
  01E0    46                            LD      B,(HL)
  01E1    23                    AU00:   INC     HL
  01E2    10 FD                         DJNZ    AU00
  01E4    46                            LD      B,(HL)
  01E5    23                    AU01:   INC     HL
  01E6    10 FD                         DJNZ    AU01
                                        ;--------------------
                                        ; AB HIER (HL) ERSTES ZEICHEN MOEGLICH
                                
  01E8    06 FF                         LD      B,0FFH  ; MAX LAENGE BIS ERSTEN ZEICHEN
  01EA    7E                    AU10:   LD      A,(HL)
  01EB    FE 30                         CP      30H     ; ZEICHEN KLEINER "!"
  01ED    30 06                         JR      NC,AU11 ; ZEICHEN GEFUNDEN
  01EF    23                            INC     HL
  01F0    10 F8                         DJNZ    AU10
  01F2    C3 0382                       JP      AUEND   
                                        ;---------------------
                                        ; ZEICHEN GEFUNDEN
  01F5    C5                    AU11:   PUSH    BC
  01F6    2B                            DEC     HL      ; EIN ZEICHEN ZURUECKSETZEN
  01F7    06 14                 AU12:   LD      B,20D
        MACRO-80 3.43   27-Jul-81       PAGE    1-5


  01F9    3E 82                         LD      A,82H   ; BIT 7 =1 UM EXTERNE CURSOR POSITION ZU ERKENNEN
  01FB    32 6B27                       LD      (RAMT),A
  01FE    11 044F                       LD      DE,AUTEX
  0201    23                    AU13:   INC     HL      ; ZUM NAECHSTEN ZEICHEN 
  0202    7E                            LD      A,(HL)
  0203    FE 0D                         CP      0DH             ; CR NEUE ZEILE
  0205    28 F0                         JR      Z,AU12
  0207    12                            LD      (DE),A
  0208    FE 3F                         CP      '?'
  020A    CA 0381                       JP      Z,AU90
  020D    FE 3A                         CP      ':'
  020F    28 12                         JR      Z,AU20
  0211    13                            INC     DE
  0212    FE 30                         CP      30H
  0214    38 07                         JR      C,AU14
  0216    3A 6B27                       LD      A,(RAMT)
  0219    3C                            INC     A
  021A    32 6B27                       LD      (RAMT),A        ; LAENGE ANZEIGETEXT
  021D    10 E2                 AU14:   DJNZ    AU13
  021F    C1                            POP     BC
  0220    C3 01EA                       JP      AU10
                                        ;----------------
                                        ; ZEILE 24,1 LOESCHEN MIT SPACE (20H)
  0223    E5                    AU20:   PUSH    HL
  0224    06 2A                         LD      B,EZLEN
  0226    21 041D                       LD      HL,EBUFF
  0229    7E                    AU21:   LD      A,(HL)
  022A    CD 03AD               AU22:   CALL    TEXOUT
  022D    23                            INC     HL
  022E    10 F9                         DJNZ    AU21
                                        ;----------------
                                        ; TEXTZEILE AUSGEBEN
                                
  0230    3E 30                         LD      A,30H
  0232    32 651E                       LD      (CURT+2),A
  0235    3E 31                         LD      A,31H
  0237    32 651F                       LD      (CURT+3),A
  023A    06 25                         LD      B,AZLEN
  023C    21 0447                       LD      HL,ABUFF
  023F    7E                    AU31:   LD      A,(HL)
  0240    FE 1B                         CP      1BH
  0242    38 1E                         JR      C,AU33  
  0244    FE 20                         CP      20H
  0246    28 1A                         JR      Z,AU33
  0248    CD 03AD                       CALL    TEXOUT
  024B    3A 651F                       LD      A,(CURT+3)
  024E    3C                            INC     A
  024F    FE 3A                         CP      3AH
  0251    38 07                         JR      C,CAU31
                                        ;LD     A,(CURT+2)
                                        ;INC    A
  0253    3E 31                         LD      A,31H
  0255    32 651E                       LD      (CURT+2),A
  0258    3E 30                         LD      A,30H
  025A    32 651F               CAU31:  LD      (CURT+3),A
  025D    7E                            LD      A,(HL)
        MACRO-80 3.43   27-Jul-81       PAGE    1-6


  025E    FE 3A                         CP      ':'
  0260    28 03                         JR      Z,AU32
  0262    23                    AU33:   INC     HL
  0263    18 DA                         JR      AU31
                                        ;---------------
  0265    11 6B28               AU32:   LD      DE,RAMT+1
  0268    3A 6B27                       LD      A,(RAMT)
  026B    32 6B77                       LD      (RAMT+50H),A
  026E    06 14                         LD      B,20D
  0270    3E 2E                 LO01:   LD      A,2EH           ; (RAMT) LOESCHEN MIT '.'
  0272    12                            LD      (DE),A
  0273    13                            INC     DE
  0274    10 FA                         DJNZ    LO01
  0276    11 6B28                       LD      DE,RAMT+1
  0279    AF                            XOR     A
  027A    32 6B27                       LD      (RAMT),A
  027D    D5                    AU34:   PUSH    DE
                                        ;CALL   TAS00
  027E    D1                            POP     DE
  027F    FE 3A                         CP      3AH
  0281    D2 02AF                       JP      NC,AU370        ; EINGAND > 39H (9)
  0284    FE 08                         CP      08H             ; TAB
  0286    28 10                         JR      Z,AU35
  0288    FE 10                         CP      10H
  028A    DA 02E7                       JP      C,AU40          ; AUSGANG A < 10H
  028D    12                            LD      (DE),A
  028E    13                            INC     DE
  028F    3A 6B27                       LD      A,(RAMT)
  0292    3C                            INC     A
  0293    32 6B27                       LD      (RAMT),A
  0296    18 E5                         JR      AU34
                                
                                        ;------------------
                                        ; ZEICHEN MIT TAB LOESCHEN 
  0298    3A 6B27               AU35:   LD      A,(RAMT)
  029B    FE 01                         CP      1
  029D    38 36                         JR      C,AU36
  029F    3D                            DEC     A
  02A0    32 6B27                       LD      (RAMT),A
  02A3    3E 20                         LD      A,20H
  02A5    12                            LD      (DE),A
  02A6    CD 03AD                       CALL    TEXOUT
  02A9    1B                            DEC     DE
  02AA    3E 20                         LD      A,20H
  02AC    12                            LD      (DE),A
  02AD    18 14                         JR      AU37
                                        ;-------------
                                        ; CURSOR LINKS
                                
  02AF    3E 1B                 AU370:  LD      A,1BH
  02B1    CD 03AD                       CALL    TEXOUT
  02B4    3E 5B                         LD      A,5BH
  02B6    CD 03AD                       CALL    TEXOUT
  02B9    3E 44                         LD      A,44H
  02BB    CD 03AD                       CALL    TEXOUT
  02BE    3E 20                         LD      A,20H
        MACRO-80 3.43   27-Jul-81       PAGE    1-7


  02C0    CD 03AD                       CALL    TEXOUT
  02C3    3E 1B                 AU37:   LD      A,1BH
  02C5    CD 03AD                       CALL    TEXOUT
  02C8    3E 5B                         LD      A,5BH
  02CA    CD 03AD                       CALL    TEXOUT
  02CD    3E 44                         LD      A,44H
  02CF    CD 03AD                       CALL    TEXOUT
  02D2    C3 027D                       JP      AU34
                                
                                        ;-------------
                                        ; CURSOR RECHTS
                                
  02D5    3E 1B                 AU36:   LD      A,1BH
  02D7    CD 03AD                       CALL    TEXOUT
  02DA    3E 5B                         LD      A,5BH
  02DC    CD 03AD                       CALL    TEXOUT
  02DF    3E 43                         LD      A,43H
  02E1    CD 03AD                       CALL    TEXOUT
  02E4    C3 027D                       JP      AU34
                                
  02E7    E1                    AU40:   POP     HL
  02E8    23                            INC     HL      ; ZUM ERSTEN ZEICHEN
  02E9    E5                            PUSH    HL
                                        ;---------------------
                                        ; EINGABE L[NGE MIT RAMT VERGLEICHEN
                                        ; EINGABE NICHT LAENGER ALS ...,.. 
  02EA    0E 01                         LD      C,1
  02EC    06 0F                         LD      B,15D
  02EE    7E                    BES00:  LD      A,(HL)
  02EF    FE 3A                         CP      3AH
  02F1    30 09                         JR      NC,BES01        ; ENDE ERREICHT
  02F3    0C                            INC     C       
  02F4    23                            INC     HL
  02F5    10 F7                         DJNZ    BES00
  02F7    E1                    BES99:  POP     HL
  02F8    C1                            POP     BC
  02F9    C3 01EA                       JP      AU10            ; KEIN ENDE GEFUNDEN
                                        ;------------------
                                        ; PRUEFE OB EINGANS IN ZEILE PASST ...,..
  02FC    3A 6B27               BES01:  LD      A,(RAMT)
  02FF    E6 7F                         AND     7FH             ; BIT 7 LOESCHEN
  0301    FE 02                         CP      2H
  0303    38 F2                         JR      C,BES99
  0305    B9                            CP      C               ; C= RICHTIG
  0306    38 03                         JR      C,BES02
  0308    C2 02F7                       JP      NZ,BES99        ; EINGABE IST GROESSER
                                        ;-------------------
                                        ; EINGABE PASST IN ZEILE 
                                        ; ZEILE ZUORDNEN AUS BLASE 
  030B    41                    BES02:  LD      B,C
  030C    2B                    BES03:  DEC     HL
  030D    7E                            LD      A,(HL)
  030E    FE 2C                         CP      ','             ; KOMMA SUCHEN
  0310    28 05                         JR      Z,BES10         ; ',' GEFUNDEN
  0312    10 F8                         DJNZ    BES03
  0314    C3 02F7                       JP      BES99   ; WENN KEIN KOMMA GEFUNDEN IN BLASE
        MACRO-80 3.43   27-Jul-81       PAGE    1-8


                                        ;---------------------
                                        ; RAMT ZUORDNEN
  0317    3A 6B27               BES10:  LD      A,(RAMT)
  031A    E6 7F                         AND     7FH             ; BIT 7 LOESCHEN
  031C    11 6B28                       LD      DE,RAMT+1
  031F    C5                            PUSH    BC
  0320    47                            LD      B,A
  0321    0E 00                         LD      C,0H
  0323    1A                    BES11:  LD      A,(DE)
  0324    FE 2C                         CP      ','             ; KOMMA SUCHEN
  0326    28 1D                         JR      Z,BES19
  0328    FE 31                         CP      '1'
  032A    30 11                         JR      NC,BES12
  032C    79                            LD      A,C
  032D    FE 00                         CP      0H
  032F    20 0C                         JR      NZ,BES12
  0331    13                            INC     DE
  0332    1A                            LD      A,(DE)
  0333    FE 2C                         CP      ','             ; KOMMA SUCHEN
  0335    28 08                         JR      Z,BES13+1
  0337    1B                            DEC     DE
  0338    3E 2E                         LD      A,2EH
  033A    12                            LD      (DE),A
  033B    18 01                         JR      BES13
  033D    0C                    BES12:  INC     C
  033E    13                    BES13:  INC     DE
  033F    10 E2                         DJNZ    BES11
  0341    C1                            POP     BC
  0342    C3 02F7                       JP      BES99           ; WENN IN EINGABE KEIN KOMME GEFUNDEN
                                        ;----------------------
                                        ; EINGABE EINF]GEN
  0345    C1                    BES19:  POP     BC
  0346    23                    BES20:  INC     HL              ; NACHKOMMA STELLEN
  0347    13                            INC     DE              ; NACHKOMMA STELLEN
  0348    7E                            LD      A,(HL)
  0349    FE 3A                         CP      3AH
  034B    30 17                         JR      NC,BES24        ; PR]FE ENDE
  034D    1A                            LD      A,(DE)
  034E    FE 30                         CP      '0'
  0350    38 06                         JR      C,BES23         ; WENN <0
  0352    FE 3A                         CP      ':'
  0354    30 02                         JR      NC,BES23
  0356    18 EE                         JR      BES20
  0358    3E 30                 BES23:  LD      A,30H
  035A    12                            LD      (DE),A
  035B    3A 6B27                       LD      A,(RAMT)
  035E    3C                            INC     A
  035F    32 6B27                       LD      (RAMT),A
  0362    18 E2                         JR      BES20
                                
  0364    3A 6B27               BES24:  LD      A,(RAMT)
  0367    E6 7F                         AND     7FH             ; BIT 7 LOESCHEN
  0369    47                            LD      B,A
  036A    2B                            DEC     HL
  036B    1B                            DEC     DE
  036C    1A                    BES21:  LD      A,(DE)
        MACRO-80 3.43   27-Jul-81       PAGE    1-9


  036D    FE 2C                         CP      ','
  036F    28 06                         JR      Z,BES210
  0371    38 05                         JR      C,BES22
  0373    FE 3A                         CP      ':'
  0375    30 01                         JR      NC,BES22                ; SOLANG BIS KEINE ZAHL MEHR 
  0377    77                    BES210: LD      (HL),A
  0378    1B                    BES22:  DEC     DE
  0379    2B                            DEC     HL
  037A    10 F0                         DJNZ    BES21
                                
                                        ;---------------------
  037C    E1                            POP     HL
  037D    C1                            POP     BC
  037E    C3 01EA                       JP      AU10
                                        ;----------
  0381    C1                    AU90:   POP BC
  0382    E1                    AUEND:  POP HL
  0383    D1                            POP DE
  0384    C1                            POP BC
  0385    AF                            XOR A
  0386    32 6B27                       LD (RAMT),A
  0389    32 6200                       LD (BLAN),A
  038C    C9                            RET
                                        ;-----------------
  038D    37                    STE:    SCF
  038E    AF                            XOR     A       
  038F    32 6200                       LD      (BLAN),A
  0392    C9                            RET
                                        ;---------------
  0393    C5                    CURPOS: PUSH BC
  0394    04                            INC B           ; CHARACTER LENGTH +1
  0395    3E 00                         LD A,00H        ; COUNT FROM 0
  0397    3C                    CURP1:  INC A
  0398    27                            DAA
  0399    10 FC                         DJNZ CURP1
  039B    47                            LD B,A
  039C    E6 0F                         AND 0FH
  039E    32 651F                       LD (CURT+3),A
  03A1    78                            LD A,B
  03A2    0F                            RRCA
  03A3    0F                            RRCA
  03A4    0F                            RRCA
  03A5    0F                            RRCA
  03A6    E6 0F                         AND 0FH
  03A8    32 651E                       LD (CURT+2),A
  03AB    C1                            POP BC
  03AC    C9                            RET
                                        ;---------------
  03AD    F5                    TEXOUT: PUSH AF
  03AE    C5                            PUSH BC
  03AF    D5                            PUSH DE
  03B0    E5                            PUSH HL
  03B1    5F                            LD E,A
  03B2    0E 02                         LD C,02H
  03B4    CD 0005                       CALL 0005H
  03B7    E1                            POP HL
        MACRO-80 3.43   27-Jul-81       PAGE    1-10


  03B8    D1                            POP DE
  03B9    C1                            POP BC
  03BA    F1                            POP AF
  03BB    C9                            RET
                                        ;------------
                                        ; EXECUTE PARAMETER AND JUMP BACK
                                        ;
  03BC    CD 03D1               UPROG:  CALL UPROG2
  03BF    D5                            PUSH DE         ; DE AS A BACKSPACE ADDRESS ON A STACK
  03C0    C9                            RET             ; JUMP (DE)     
                                        ;-------------
                                        ;     
  03C1    CD 03D1               UPROG1: CALL UPROG2
  03C4    D5                            PUSH DE         ; DE AS A BACKSPACE ADDRESS ON A STACK
                                        ;LD BC,HDD      ;(BFRLL)
                                        ;LD DE,0000H    ;(BFRHL)
  03C5    ED 4B 6500                    LD BC,(BFRLL)
  03C9    ED 5B 6502                    LD DE,(BFRHL)
  03CD    21 6000                       LD HL,RAM
  03D0    C9                            RET             ; JUMP (DE)             
                                        ;--------------
                                        ; LOAD THE JUMP ADDRESS IN DE
                                        ;
  03D1    21 7000               UPROG2: LD HL,PROG
  03D4    11 0003                       LD DE,03H       ; ABSTAND 3BYTE SPRUNGBEFEHL
  03D7    19                    SUM:    ADD HL,DE
  03D8    10 FD                         DJNZ SUM
  03DA    23                            INC HL          ; JP BEFEHL (C3) UEBERSPRINGEN
  03DB    5E                            LD E,(HL)
  03DC    23                            INC HL
  03DD    56                            LD D,(HL)
  03DE    C9                            RET
                                ;---------------------------
  03DF    41 55 54 4F           TTEX:   DEFM 'AUTO.MAC ausgabe Text                                <'
  03E3    2E 4D 41 43           
  03E7    20 61 75 73           
  03EB    67 61 62 65           
  03EF    20 54 65 78           
  03F3    74 20 20 20           
  03F7    20 20 20 20           
  03FB    20 20 20 20           
  03FF    20 20 20 20           
  0403    20 20 20 20           
  0407    20 20 20 20           
  040B    20 20 20 20           
  040F    20 20 20 20           
  0413    20 3C                 
  0036                          TTLEN   EQU $-TTEX
                                
  0415    00 00 00 00           BF02:   DEFB 00H,00H,00H,00H
  0419    00 00 00 00           BF03:   DEFB 00H,00H,00H,00H    
                                
  041D    1B 5B 02 04           EBUFF:  DEFB 1BH,5BH,02H,04H,3BH,00H,01H,48H
  0421    3B 00 01 48           
  0425    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH
  0429    6D                    
        MACRO-80 3.43   27-Jul-81       PAGE    1-11


  042A    20 20 20 20                   DEFM '                             '
  042E    20 20 20 20           
  0432    20 20 20 20           
  0436    20 20 20 20           
  043A    20 20 20 20           
  043E    20 20 20 20           
  0442    20 20 20 20           
  0446    20                    
  002A                          EZLEN   EQU $-EBUFF
                                
  0447    1B 5B 02 04           ABUFF:  DEFB 1BH,5BH,02H,04H,3BH,00H,01H,48H
  044B    3B 00 01 48           
  044F    20 20 20 20           AUTEX:  DEFM '                             '
  0453    20 20 20 20           
  0457    20 20 20 20           
  045B    20 20 20 20           
  045F    20 20 20 20           
  0463    20 20 20 20           
  0467    20 20 20 20           
  046B    20                    
  0025                          AZLEN   EQU $-ABUFF
                                
                                END
        MACRO-80 3.43   27-Jul-81       PAGE    S


Macros:

Symbols:
0447    ABUFF           01E1    AU00            01E5    AU01            
01EA    AU10            01F5    AU11            01F7    AU12            
0201    AU13            021D    AU14            0223    AU20            
0229    AU21            022A    AU22            023F    AU31            
0265    AU32            0262    AU33            027D    AU34            
0298    AU35            02D5    AU36            02C3    AU37            
02AF    AU370           02E7    AU40            0381    AU90            
0382    AUEND           044F    AUTEX           0025    AZLEN           
02EE    BES00           02FC    BES01           030B    BES02           
030C    BES03           0317    BES10           0323    BES11           
033D    BES12           033E    BES13           0345    BES19           
0346    BES20           036C    BES21           0377    BES210          
0378    BES22           0358    BES23           0364    BES24           
02F7    BES99           0415    BF02            0419    BF03            
6503    BFRHH           6502    BFRHL           6501    BFRLH           
6500    BFRLL           650F    BFSHH           650E    BFSHL           
650D    BFSLH           650C    BFSLL           650B    BFVHH           
650A    BFVHL           6509    BFVLH           6508    BFVLL           
6200    BLAN            6205    BSTAT           0080    BUFF            
025A    CAU31           0020    CMD_READSEC     0030    CMD_WRITESEC    
6C3F    COP             0007    CPOS            0397    CURP1           
0393    CURPOS          6518    CURS            651C    CURT            
041D    EBUFF           002A    EZLEN           005C    FCB             
006B    FCBCR           005D    FCBFN           0065    FCBFT           
007C    FCBRA           0020    FDC             0155    FI00            
01BE    FI10            01A8    FI60            01B4    FI61            
01DD    FI99            0800    HDD             00BE    HDDE            
00F0    IDE             00FD    IDECHI          00FC    IDECLO          
00FF    IDECMD          00F8    IDEDAT          00F6    IDEDOR          
00F9    IDEERR          00FA    IDESCNT         00FE    IDESDH          
00FB    IDESNUM         00FF    IDESTAT         0136    KEY0            
0002    KEYIN           0001    KEYOUT          0060    LCD             
0270    LO01            6513    LOGHH           6512    LOGHL           
6511    LOGLH           6510    LOGLL           A101    MMC             
0007    MMCE            001E    PIOB            7000    PROG            
0005    P_READ          0006    P_WRITE         6524    RADR            
6000    RAM             6727    RAMS            6B27    RAMT            
6527    RAMV            0000    RBLAN           0005    RBSTAT          
6526    RMEN            0006    RSOTR           0004    RTERM           
6BEF    RTEX            0002    RTYPE1          0003    RTYPE2          
0001    RUSER           6520    SANDB           0004    SELDM           
00F7    SELDS           038D    STE             03D7    SUM             
6204    TERM            03AD    TEXOUT          0129    TT01            
03DF    TTEX            0036    TTLEN           0192    TY00            
6202    TYPE1           6203    TYPE2           03BC    UPROG           
03C1    UPROG1          03D1    UPROG2          0080    URCS            
6201    USER            



No Fatal error(s)


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
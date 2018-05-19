        MACRO-80 3.43   27-Jul-81       PAGE    1


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
  0008                   C      LPOS    EQU 08H         ; POSITION BC
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
                                        ;--------------
                                        ; search image output
                                        ;
  0108    CD 056D                       CALL MASK1
                                        ;
                                        ; from here issue
                                        ;
  010B    C5                            PUSH BC
  010C    06 08                         LD B,LPOS
  010E    CD 055D                       CALL UPROG2
  0111    01 0471                       LD BC,0471H
  0114    ED 43 06D8                    LD (FILEN),BC
  0118    CD 054B                       CALL UPROG
  011B    C1                            POP BC
  011C    3E 31                         LD A,'1'
  011E    32 06DA               FIL6:   LD (ZEILEN),A
  0121    CD 053A                       CALL TEXOUT
  0124    3E 20                         LD A,' '
  0126    CD 053A                       CALL TEXOUT
  0129    06 0C                         LD B,0CH
  012B    7E                    FIL7:   LD A,(HL)
  012C    FE 00                         CP 00H
  012E    28 31                         JR Z,TEXIN
  0130    CD 053A                       CALL TEXOUT
  0133    23                            INC HL
  0134    7E                            LD A,(HL)
  0135    FE 2E                         CP '.'
  0137    28 04                         JR Z,FIL8
  0139    10 F0                         DJNZ FIL7
  013B    18 24                         JR TEXIN
                                        ;------------
  013D    05                    FIL8:   DEC B
  013E    23                            INC HL
        MACRO-80 3.43   27-Jul-81       PAGE    1-3


  013F    10 FD                         DJNZ FIL8+1
                                        ;------------
  0141    C5                            PUSH BC
  0142    06 08                         LD B,LPOS
  0144    CD 055D                       CALL UPROG2
  0147    ED 4B 06D8                    LD BC,(FILEN)
  014B    04                            INC B
  014C    ED 43 06D8                    LD (FILEN),BC
  0150    CD 054B                       CALL UPROG
  0153    C1                            POP BC
  0154    7E                            LD A,(HL)
  0155    FE 00                         CP 00H
  0157    28 08                         JR Z,TEXIN
  0159    3A 06DA                       LD A,(ZEILEN)
  015C    3C                            INC A
  015D    E5                            PUSH HL
  015E    D1                            POP DE
  015F    18 BD                         JR FIL6         
                                        ;--------------------
                                        ; SET CURSOR ON START POSITION
                                        ;
  0161    C3 01FD               TEXIN:  JP KEY9
  0164    CD 05A3                       CALL SDEL
  0167    11 05CA                       LD DE,TTEX
  016A    CD 058A                       CALL BTEX       ; text block TTEX output
  016D    01 1110                       LD BC,1110H     ; positon 
  0170    21 0E01                       LD HL,0E01H     ; length Width 
  0173    CD 020C                       CALL WINDOW
                                        ;--------------
                                        ; TEXT input
                                        ;
  0176    11 06CC                       LD DE,AUTO
  0179    CD 0594               KEY1:   CALL INKEY
  017C    FE 00                         CP 0
  017E    28 F9                         JR Z,KEY1
  0180    FE 0D                         CP 0DH
  0182    CA 019F                       JP Z,KEY2       ; !!!!AUSGANG VORERST 
  0185    12                            LD (DE),A
  0186    13                            INC DE
  0187    23                            INC HL
  0188    D5                            PUSH DE
  0189    3E 2E                         LD A,'.'
  018B    12                            LD (DE),A
  018C    13                            INC DE
  018D    3E 43                         LD A,'C'
  018F    12                            LD (DE),A
  0190    13                            INC DE
  0191    3E 4F                         LD A,'O'
  0193    12                            LD (DE),A
  0194    13                            INC DE
  0195    3E 4D                         LD A,'M'
  0197    12                            LD (DE),A
  0198    13                            INC DE 
  0199    3E 20                         LD A,' '
  019B    12                            LD (DE),A
  019C    D1                            POP DE
        MACRO-80 3.43   27-Jul-81       PAGE    1-4


  019D    18 DA                         JR KEY1
                                        ;--------------
                                        ; search image output
                                        ;
  019F    CD 056D               KEY2:   CALL MASK1
                                        ;
                                        ; from here issue
                                        ;
  01A2    C5                            PUSH BC
  01A3    06 08                         LD B,LPOS
  01A5    CD 055D                       CALL UPROG2
  01A8    01 0471                       LD BC,0471H
  01AB    ED 43 06D8                    LD (FILEN),BC
  01AF    CD 054B                       CALL UPROG
  01B2    C1                            POP BC
  01B3    11 06CC                       LD DE,AUTO
  01B6    3E 31                         LD A,'1'
  01B8    32 06DA               KEY7:   LD (ZEILEN),A
  01BB    CD 053A                       CALL TEXOUT
  01BE    3E 20                         LD A,' '
  01C0    CD 053A                       CALL TEXOUT
  01C3    06 0C                         LD B,0CH
  01C5    1A                    SUCHD:  LD A,(DE)
  01C6    FE 00                         CP 00H
  01C8    28 33                         JR Z,KEY9
  01CA    77                            LD (HL),A       
  01CB    CD 053A                       CALL TEXOUT
  01CE    13                            INC DE
  01CF    23                            INC HL
  01D0    1A                            LD A,(DE)
  01D1    FE 2E                         CP '.'
  01D3    28 04                         JR Z,KEY8
  01D5    10 EE                         DJNZ SUCHD
  01D7    18 24                         JR KEY9
                                        ;------------
  01D9    05                    KEY8:   DEC B
  01DA    23                            INC HL
  01DB    10 FD                         DJNZ KEY8+1
  01DD    C5                            PUSH BC
  01DE    06 08                         LD B,LPOS
  01E0    CD 055D                       CALL UPROG2
  01E3    ED 4B 06D8                    LD BC,(FILEN)
  01E7    04                            INC B
  01E8    ED 43 06D8                    LD (FILEN),BC
  01EC    CD 054B                       CALL UPROG
  01EF    C1                            POP BC
  01F0    7E                            LD A,(HL)
  01F1    FE 00                         CP 00H
  01F3    28 08                         JR Z,KEY9
  01F5    3A 06DA                       LD A,(ZEILEN)
  01F8    3C                            INC A
  01F9    E5                            PUSH HL
  01FA    D1                            POP DE
  01FB    18 BB                         JR KEY7         
                                        ;--------------
  01FD    06 02                 KEY9:   LD B,KEYIN
        MACRO-80 3.43   27-Jul-81       PAGE    1-5


  01FF    CD 055D                       CALL UPROG2
  0202    CD 054B                       CALL UPROG
  0205    FE 00                         CP 0
  0207    28 F4                         JR Z,KEY9       ; press key for end
  0209    C3 050D                       JP AUEND
                                        ;------------------
                         C              INCLUDE RAHMEN.MAC      ; SET WINDOW
                         C              ;----------------
  020C    22 02BE        C      WINDOW: LD (WINXY),HL   ; WINDOW X,Y
  020F    ED 43 02C0     C              LD (WINPOS),BC  ; STARTPOS X,Y
  0213    C5             C              PUSH BC         ; =X,Y POSITION 
  0214    E5             C              PUSH HL         ; =X,Y LAENGE
  0215    04             C              INC B
  0216    0C             C              INC C
  0217    ED 43 02C2     C              LD (WINCHA),BC  ; for pos in windows
  021B    06 08          C              LD B,LPOS       ; SUBROUTINE CALL CURSOR IN BLASE ON POSITION
  021D    CD 055D        C              CALL UPROG2
  0220    ED 4B 02C0     C              LD BC,(WINPOS)
  0224    CD 054B        C              CALL UPROG
                         C              ;----------------
                         C              ; START WINDOW
                         C              ;
  0227    3A 02C4        C              LD A,(WINDO)    ; LEFT UP CORNER
  022A    CD 02B1        C              CALL WINOUT
  022D    ED 4B 02BE     C              LD BC,(WINXY)   ; LOAD X
  0231    3A 02C5        C      WINX1:  LD A,(WINDO+1)  ; UP X LINE
  0234    CD 02B1        C              CALL WINOUT
  0237    10 F8          C              DJNZ WINX1
  0239    3A 02C6        C              LD A,(WINDO+2)  ; RIGHT UP CORNER
  023C    CD 02B1        C              CALL WINOUT
                         C              ;----------------OK.
                         C              ; NEW LINE
                         C              ;
  023F    06 08          C      WINY1:  LD B,LPOS       ; BIOS BLASE
  0241    CD 055D        C              CALL UPROG2
  0244    ED 4B 02C0     C              LD BC,(WINPOS)
  0248    04             C              INC B
  0249    78             C              LD A,B
  024A    27             C              DAA
  024B    47             C              LD B,A
  024C    ED 43 02C0     C              LD (WINPOS),BC
  0250    CD 054B        C              CALL UPROG      ; SET
  0253    3A 02C7        C              LD A,(WINDO+3)  ; LEFT SIDE
  0256    CD 02B1        C              CALL WINOUT
                         C              ;----------------
  0259    ED 4B 02BE     C              LD BC,(WINXY)
  025D    3A 02C8        C      WINX2:  LD A,(WINDO+4)  ; SPACE 
  0260    CD 02B1        C              CALL WINOUT
  0263    10 F8          C              DJNZ WINX2
  0265    3A 02C9        C              LD A,(WINDO+5)  ; RIGHT SIDE
  0268    CD 02B1        C              CALL WINOUT
  026B    ED 4B 02BE     C              LD BC,(WINXY)
  026F    0D             C              DEC C
  0270    ED 43 02BE     C              LD (WINXY),BC
  0274    20 C9          C              JR NZ,WINY1
  0276    06 08          C              LD B,LPOS
        MACRO-80 3.43   27-Jul-81       PAGE    1-6


  0278    CD 055D        C              CALL UPROG2
  027B    ED 4B 02C0     C              LD BC,(WINPOS)
  027F    04             C              INC B
  0280    78             C              LD A,B
  0281    27             C              DAA
  0282    47             C              LD B,A
  0283    ED 43 02C0     C              LD (WINPOS),BC
  0287    CD 054B        C              CALL UPROG      ; SET
  028A    3A 02CA        C              LD A,(WINDO+6)  ; LEFT DOWN CORNER
  028D    CD 02B1        C              CALL WINOUT
  0290    ED 4B 02BE     C              LD BC,(WINXY)
  0294    3A 02CB        C      WINX3:  LD A,(WINDO+7)  ; DOWN LINE 
  0297    CD 02B1        C              CALL WINOUT
  029A    10 F8          C              DJNZ WINX3
  029C    3A 02CC        C              LD A,(WINDO+8)  ; RIGHT SIDE
  029F    CD 02B1        C              CALL WINOUT
  02A2    06 08          C              LD B,LPOS
  02A4    CD 055D        C              CALL UPROG2
  02A7    ED 4B 02C2     C              LD BC,(WINCHA)
  02AB    CD 054B        C              CALL UPROG      ; SET
  02AE    E1             C              POP HL
  02AF    C1             C              POP BC
  02B0    C9             C              RET
                         C              ;-----------------
  02B1    C5             C      WINOUT: PUSH BC
  02B2    E5             C              PUSH HL
  02B3    06 01          C              LD B,KEYOUT     ; SUBROUTINE KEY CALL OUTPUT IN BLASE
  02B5    CD 055D        C              CALL UPROG2
  02B8    CD 054B        C              CALL UPROG
  02BB    E1             C              POP HL
  02BC    C1             C              POP BC
  02BD    C9             C              RET
  02BE    0000           C      WINXY:  DEFW 0000H
  02C0    0000           C      WINPOS: DEFW 0000H
  02C2    0000           C      WINCHA: DEFW 0000H
  02C4    DA C4 BF       C      WINDO:  DEFB 218D,196D,191D
  02C7    B3 20 B3       C              DEFB 179D,20H,179D
  02CA    C0 C4 D9       C              DEFB 192D,196D,217D
                         C              ;-----------------
                         C      
                                        ;-----------------
                                        ; NAECHSTE FREIE TYPE2 >1 SUCHEN
                                        ; USER ,TYPE1 MUSS GLEICHBLEIBEN
                                        ;
  02CD    3E 01                         LD A,01H
  02CF    32 0679                       LD (BF03),A     ; TYPE2 ZAEHLER
  02D2    ED 5B 6500                    LD DE,(BFRLL)
  02D6    ED 53 0675                    LD (BF02),DE
  02DA    2A 6502                       LD HL,(BFRHL)
  02DD    22 0677                       LD (BF02+2),HL  ; ADRESSE TYPE2=1 RETTEN
  02E0                          FI00:   ;CALL LBA0
  02E0    DA 050D                       JP C,AUEND
  02E3    ED 53 6508                    LD (BFVLL),DE
  02E7    22 650A                       LD (BFVHL),HL
  02EA    ED 4B 6508                    LD BC,(BFVLL)
  02EE    ED 5B 650A                    LD DE,(BFVHL)
        MACRO-80 3.43   27-Jul-81       PAGE    1-7


                                        ;CALL   DISK
  02F2    01 6527                       LD BC,RAMV
                                        ;--------------------
                                        ; USER VERGLEICHEN
  02F5    3A 6001                       LD A,(RAM+RUSER)
  02F8    47                            LD B,A
  02F9    3A 6528                       LD A,(RAMV+RUSER)
  02FC    B8                            CP B
  02FD    38 40                         JR C,FI61
  02FF    20 48                         JR NZ,FI10
                                        ;---------------------
                                        ; TYPE1 VERGLEICHEN
  0301    3A 6002                       LD A,(RAM+RTYPE1)
  0304    47                            LD B,A
  0305    3A 6529                       LD A,(RAMV+RTYPE1)
  0308    B8                            CP B
  0309    20 34                         JR NZ,FI61
                                        ;---------------------
                                        ; TYPE2 MUSS >0 SEIN 2
  030B    3A 652A                       LD A,(RAMV+RTYPE2)
  030E    FE 02                         CP 02H
  0310    38 2D                         JR C,FI61
                                        ;---------------------
                                        ; COPY SUCHTEXT AUS EINGABE ZUR]CH NACH RAMT
  0312    21 6BEF                       LD HL,RTEX
  0315    11 6B27                       LD DE,RAMT
  0318    46                            LD B,(HL)
  0319    7E                            LD A,(HL)
  031A    12                            LD (DE),A       
  031B    13                            INC DE
  031C    23                            INC HL
  031D    7E                    TY00:   LD A,(HL)
  031E    12                            LD (DE),A
  031F    13                            INC DE
  0320    23                            INC HL
  0321    10 FA                         DJNZ TY00
                                        ;-------------------
                                        ; SUCHE NACH WEITEREN EINTRAEGEN
                                        ; UND BESTIMME NAECHSTE BLASE
  0323    21 6527                       LD HL,RAMV
  0326    3A 6B27                       LD A,(RAMT)
  0329    11 6B28                       LD DE,RAMT+1
  032C    06 3F                         LD B,3FH
  032E    21 652C                       LD HL,RAMV+RBSTAT
                                        ;CALL SUCH0
  0331    38 0C                         JR C,FI61
  0333    3A 0679               FI60:   LD A,(BF03)
  0336    3C                            INC A
                                        ; JR Z,  UEBERLAUF ABFABGEN  ????
  0337    32 0679                       LD (BF03),A
  033A    CB EF                         SET 5,A
  033C    CD 053A                       CALL TEXOUT
  033F    ED 5B 6508            FI61:   LD DE,(BFVLL)
  0343    2A 650A                       LD HL,(BFVHL)
  0346    C3 02E0                       JP FI00
                                        ;--------------------
        MACRO-80 3.43   27-Jul-81       PAGE    1-8


                                        ; NEUE BLASE MUSS TERM = 0 SEIN
  0349    3A 652B               FI10:   LD A,(RAMV+RTERM)
  034C    FE 00                         CP 0
  034E    20 EF                         JR NZ,FI61
  0350    3A 0679                       LD A,(BF03)
  0353    3C                            INC A
                                        ; JR Z,  UEBERLAUF ABFRAGEN ???
  0354    32 6003                       LD (RAM+RTYPE2),A
  0357    3E FE                         LD A,0FEH
  0359    32 6004                       LD (RAM+RTERM),A                
  035C    2A 6508                       LD HL,(BFVLL)   
  035F    22 6500                       LD (BFRLL),HL
  0362    2A 650A                       LD HL,(BFVHL)
  0365    22 6502                       LD (BFRHL),HL
                                        ;-----------------
                                        ; UEBERSPRINGE ERSTER BLOCK
                                        ; UND ZWEITER BLOCK BIS TEXTBEGIN
                                        ;
  0368    21 6000               FI99:   LD HL,RAM
  036B    46                            LD B,(HL)
  036C    23                    AU00:   INC HL
  036D    10 FD                         DJNZ AU00
  036F    46                            LD B,(HL)
  0370    23                    AU01:   INC HL
  0371    10 FD                         DJNZ AU01
                                        ;--------------------
                                        ; AB HIER (HL) ERSTES ZEICHEN MOEGLICH
                                        ;
  0373    06 FF                         LD B,0FFH       ; MAX LAENGE BIS ERSTEN ZEICHEN
  0375    7E                    AU10:   LD A,(HL)
  0376    FE 30                         CP 30H  ; ZEICHEN KLEINER "!"
  0378    30 06                         JR NC,AU11      ; ZEICHEN GEFUNDEN
  037A    23                            INC HL
  037B    10 F8                         DJNZ AU10
  037D    C3 050D                       JP AUEND        
                                        ;---------------------
                                        ; ZEICHEN GEFUNDEN
  0380    C5                    AU11:   PUSH BC
  0381    2B                            DEC HL  ; EIN ZEICHEN ZURUECKSETZEN
  0382    06 14                 AU12:   LD B,20D
  0384    3E 82                         LD A,82H        ; BIT 7 =1 UM EXTERNE CURSOR POSITION ZU ERKENNEN
  0386    32 6B27                       LD (RAMT),A
  0389    11 06AF                       LD DE,AUTEX
  038C    23                    AU13:   INC HL  ; ZUM NAECHSTEN ZEICHEN 
  038D    7E                            LD A,(HL)
  038E    FE 0D                         CP 0DH          ; CR NEUE ZEILE
  0390    28 F0                         JR Z,AU12
  0392    12                            LD (DE),A
  0393    FE 3F                         CP '?'
  0395    CA 050C                       JP Z,AU90
  0398    FE 3A                         CP ':'
  039A    28 12                         JR Z,AU20
  039C    13                            INC DE
  039D    FE 30                         CP 30H
  039F    38 07                         JR C,AU14
  03A1    3A 6B27                       LD A,(RAMT)
        MACRO-80 3.43   27-Jul-81       PAGE    1-9


  03A4    3C                            INC A
  03A5    32 6B27                       LD (RAMT),A     ; LAENGE ANZEIGETEXT
  03A8    10 E2                 AU14:   DJNZ AU13
  03AA    C1                            POP BC
  03AB    C3 0375                       JP AU10
                                        ;----------------
                                        ; ZEILE 24,1 LOESCHEN MIT SPACE (20H)
  03AE    E5                    AU20:   PUSH    HL
  03AF    06 2A                         LD      B,EZLEN
  03B1    21 067D                       LD      HL,EBUFF
  03B4    7E                    AU21:   LD      A,(HL)
  03B5    CD 053A               AU22:   CALL    TEXOUT
  03B8    23                            INC     HL
  03B9    10 F9                         DJNZ    AU21
                                        ;----------------
                                        ; TEXTZEILE AUSGEBEN
                                
  03BB    3E 30                         LD      A,30H
  03BD    32 651E                       LD      (CURT+2),A
  03C0    3E 31                         LD      A,31H
  03C2    32 651F                       LD      (CURT+3),A
  03C5    06 25                         LD      B,AZLEN
  03C7    21 06A7                       LD      HL,ABUFF
  03CA    7E                    AU31:   LD      A,(HL)
  03CB    FE 1B                         CP      1BH
  03CD    38 1E                         JR      C,AU33  
  03CF    FE 20                         CP      20H
  03D1    28 1A                         JR      Z,AU33
  03D3    CD 053A                       CALL    TEXOUT
  03D6    3A 651F                       LD      A,(CURT+3)
  03D9    3C                            INC     A
  03DA    FE 3A                         CP      3AH
  03DC    38 07                         JR      C,CAU31
                                        ;LD     A,(CURT+2)
                                        ;INC    A
  03DE    3E 31                         LD      A,31H
  03E0    32 651E                       LD      (CURT+2),A
  03E3    3E 30                         LD      A,30H
  03E5    32 651F               CAU31:  LD      (CURT+3),A
  03E8    7E                            LD      A,(HL)
  03E9    FE 3A                         CP      ':'
  03EB    28 03                         JR      Z,AU32
  03ED    23                    AU33:   INC     HL
  03EE    18 DA                         JR      AU31
                                        ;---------------
  03F0    11 6B28               AU32:   LD      DE,RAMT+1
  03F3    3A 6B27                       LD      A,(RAMT)
  03F6    32 6B77                       LD      (RAMT+50H),A
  03F9    06 14                         LD      B,20D
  03FB    3E 2E                 LO01:   LD      A,2EH           ; (RAMT) LOESCHEN MIT '.'
  03FD    12                            LD      (DE),A
  03FE    13                            INC     DE
  03FF    10 FA                         DJNZ    LO01
  0401    11 6B28                       LD      DE,RAMT+1
  0404    AF                            XOR     A
  0405    32 6B27                       LD      (RAMT),A
        MACRO-80 3.43   27-Jul-81       PAGE    1-10


  0408    D5                    AU34:   PUSH    DE
                                        ;CALL   TAS00
  0409    D1                            POP     DE
  040A    FE 3A                         CP      3AH
  040C    D2 043A                       JP      NC,AU370        ; EINGAND > 39H (9)
  040F    FE 08                         CP      08H             ; TAB
  0411    28 10                         JR      Z,AU35
  0413    FE 10                         CP      10H
  0415    DA 0472                       JP      C,AU40          ; AUSGANG A < 10H
  0418    12                            LD      (DE),A
  0419    13                            INC     DE
  041A    3A 6B27                       LD      A,(RAMT)
  041D    3C                            INC     A
  041E    32 6B27                       LD      (RAMT),A
  0421    18 E5                         JR      AU34
                                
                                        ;------------------
                                        ; ZEICHEN MIT TAB LOESCHEN 
  0423    3A 6B27               AU35:   LD      A,(RAMT)
  0426    FE 01                         CP      1
  0428    38 36                         JR      C,AU36
  042A    3D                            DEC     A
  042B    32 6B27                       LD      (RAMT),A
  042E    3E 20                         LD      A,20H
  0430    12                            LD      (DE),A
  0431    CD 053A                       CALL    TEXOUT
  0434    1B                            DEC     DE
  0435    3E 20                         LD      A,20H
  0437    12                            LD      (DE),A
  0438    18 14                         JR      AU37
                                        ;-------------
                                        ; CURSOR LINKS
                                
  043A    3E 1B                 AU370:  LD      A,1BH
  043C    CD 053A                       CALL    TEXOUT
  043F    3E 5B                         LD      A,5BH
  0441    CD 053A                       CALL    TEXOUT
  0444    3E 44                         LD      A,44H
  0446    CD 053A                       CALL    TEXOUT
  0449    3E 20                         LD      A,20H
  044B    CD 053A                       CALL    TEXOUT
  044E    3E 1B                 AU37:   LD      A,1BH
  0450    CD 053A                       CALL    TEXOUT
  0453    3E 5B                         LD      A,5BH
  0455    CD 053A                       CALL    TEXOUT
  0458    3E 44                         LD      A,44H
  045A    CD 053A                       CALL    TEXOUT
  045D    C3 0408                       JP      AU34
                                        ;-------------
                                        ; CURSOR RECHTS
                                
  0460    3E 1B                 AU36:   LD      A,1BH
  0462    CD 053A                       CALL    TEXOUT
  0465    3E 5B                         LD      A,5BH
  0467    CD 053A                       CALL    TEXOUT
  046A    3E 43                         LD      A,43H
        MACRO-80 3.43   27-Jul-81       PAGE    1-11


  046C    CD 053A                       CALL    TEXOUT
  046F    C3 0408                       JP      AU34
                                
  0472    E1                    AU40:   POP     HL
  0473    23                            INC     HL      ; ZUM ERSTEN ZEICHEN
  0474    E5                            PUSH    HL
                                        ;---------------------
                                        ; EINGABE L[NGE MIT RAMT VERGLEICHEN
                                        ; EINGABE NICHT LAENGER ALS ...,.. 
  0475    0E 01                         LD      C,1
  0477    06 0F                         LD      B,15D
  0479    7E                    BES00:  LD      A,(HL)
  047A    FE 3A                         CP      3AH
  047C    30 09                         JR      NC,BES01        ; ENDE ERREICHT
  047E    0C                            INC     C       
  047F    23                            INC     HL
  0480    10 F7                         DJNZ    BES00
  0482    E1                    BES99:  POP     HL
  0483    C1                            POP     BC
  0484    C3 0375                       JP      AU10            ; KEIN ENDE GEFUNDEN
                                        ;------------------
                                        ; PRUEFE OB EINGANS IN ZEILE PASST ...,..
  0487    3A 6B27               BES01:  LD      A,(RAMT)
  048A    E6 7F                         AND     7FH             ; BIT 7 LOESCHEN
  048C    FE 02                         CP      2H
  048E    38 F2                         JR      C,BES99
  0490    B9                            CP      C               ; C= RICHTIG
  0491    38 03                         JR      C,BES02
  0493    C2 0482                       JP      NZ,BES99        ; EINGABE IST GROESSER
                                        ;-------------------
                                        ; EINGABE PASST IN ZEILE 
                                        ; ZEILE ZUORDNEN AUS BLASE 
  0496    41                    BES02:  LD      B,C
  0497    2B                    BES03:  DEC     HL
  0498    7E                            LD      A,(HL)
  0499    FE 2C                         CP      ','             ; KOMMA SUCHEN
  049B    28 05                         JR      Z,BES10         ; ',' GEFUNDEN
  049D    10 F8                         DJNZ    BES03
  049F    C3 0482                       JP      BES99   ; WENN KEIN KOMMA GEFUNDEN IN BLASE
                                        ;---------------------
                                        ; RAMT ZUORDNEN
  04A2    3A 6B27               BES10:  LD      A,(RAMT)
  04A5    E6 7F                         AND     7FH             ; BIT 7 LOESCHEN
  04A7    11 6B28                       LD      DE,RAMT+1
  04AA    C5                            PUSH    BC
  04AB    47                            LD      B,A
  04AC    0E 00                         LD      C,0H
  04AE    1A                    BES11:  LD      A,(DE)
  04AF    FE 2C                         CP      ','             ; KOMMA SUCHEN
  04B1    28 1D                         JR      Z,BES19
  04B3    FE 31                         CP      '1'
  04B5    30 11                         JR      NC,BES12
  04B7    79                            LD      A,C
  04B8    FE 00                         CP      0H
  04BA    20 0C                         JR      NZ,BES12
  04BC    13                            INC     DE
        MACRO-80 3.43   27-Jul-81       PAGE    1-12


  04BD    1A                            LD      A,(DE)
  04BE    FE 2C                         CP      ','             ; KOMMA SUCHEN
  04C0    28 08                         JR      Z,BES13+1
  04C2    1B                            DEC     DE
  04C3    3E 2E                         LD      A,2EH
  04C5    12                            LD      (DE),A
  04C6    18 01                         JR      BES13
  04C8    0C                    BES12:  INC     C
  04C9    13                    BES13:  INC     DE
  04CA    10 E2                         DJNZ    BES11
  04CC    C1                            POP     BC
  04CD    C3 0482                       JP      BES99           ; WENN IN EINGABE KEIN KOMME GEFUNDEN
                                        ;----------------------
                                        ; EINGABE EINF]GEN
  04D0    C1                    BES19:  POP     BC
  04D1    23                    BES20:  INC     HL              ; NACHKOMMA STELLEN
  04D2    13                            INC     DE              ; NACHKOMMA STELLEN
  04D3    7E                            LD      A,(HL)
  04D4    FE 3A                         CP      3AH
  04D6    30 17                         JR      NC,BES24        ; PR]FE ENDE
  04D8    1A                            LD      A,(DE)
  04D9    FE 30                         CP      '0'
  04DB    38 06                         JR      C,BES23         ; WENN <0
  04DD    FE 3A                         CP      ':'
  04DF    30 02                         JR      NC,BES23
  04E1    18 EE                         JR      BES20
  04E3    3E 30                 BES23:  LD      A,30H
  04E5    12                            LD      (DE),A
  04E6    3A 6B27                       LD      A,(RAMT)
  04E9    3C                            INC     A
  04EA    32 6B27                       LD      (RAMT),A
  04ED    18 E2                         JR      BES20
                                        ;---------------
  04EF    3A 6B27               BES24:  LD      A,(RAMT)
  04F2    E6 7F                         AND     7FH             ; BIT 7 LOESCHEN
  04F4    47                            LD      B,A
  04F5    2B                            DEC     HL
  04F6    1B                            DEC     DE
  04F7    1A                    BES21:  LD      A,(DE)
  04F8    FE 2C                         CP      ','
  04FA    28 06                         JR      Z,BES210
  04FC    38 05                         JR      C,BES22
  04FE    FE 3A                         CP      ':'
  0500    30 01                         JR      NC,BES22                ; SOLANG BIS KEINE ZAHL MEHR 
  0502    77                    BES210: LD      (HL),A
  0503    1B                    BES22:  DEC     DE
  0504    2B                            DEC     HL
  0505    10 F0                         DJNZ    BES21
  0507    E1                            POP     HL
  0508    C1                            POP     BC
  0509    C3 0375                       JP      AU10
                                        ;----------
  050C    C1                    AU90:   POP BC
  050D    E1                    AUEND:  POP HL
  050E    D1                            POP DE
  050F    C1                            POP BC
        MACRO-80 3.43   27-Jul-81       PAGE    1-13


  0510    AF                            XOR A
  0511    32 6B27                       LD (RAMT),A
  0514    3E 00                         LD A,00         ; PROGRAMM START XX
  0516    32 6200                       LD (BLAN),A
  0519    C9                            RET
                                        ;-----------------
  051A    37                    STE:    SCF
  051B    AF                            XOR     A       
  051C    32 6200                       LD      (BLAN),A
  051F    C9                            RET
                                        ;---------------
                                        ; CURSOR OFF END FROM CHARACTER SET
  0520    C5                    CURPOS: PUSH BC
  0521    04                            INC B           ;CHARACTER LENGTH +1
  0522    3E 00                         LD A,00H        ;COUNR FROM 0
  0524    3C                    CURP1:  INC A
  0525    27                            DAA
  0526    10 FC                         DJNZ CURP1
  0528    47                            LD B,A
  0529    E6 0F                         AND 0FH
  052B    32 651F                       LD (CURT+3),A
  052E    78                            LD A,B
  052F    0F                            RRCA
  0530    0F                            RRCA
  0531    0F                            RRCA
  0532    0F                            RRCA
  0533    E6 0F                         AND 0FH
  0535    32 651E                       LD (CURT+2),A
  0538    C1                            POP BC
  0539    C9                            RET
                                        ;---------------
                                        ; give up sing in a
                                        ;
  053A    F5                    TEXOUT: PUSH AF
  053B    C5                            PUSH BC
  053C    D5                            PUSH DE
  053D    E5                            PUSH HL
  053E    06 01                         LD B,KEYOUT
  0540    CD 055D                       CALL UPROG2
  0543    CD 054B                       CALL UPROG
  0546    E1                            POP HL
  0547    D1                            POP DE
  0548    C1                            POP BC
  0549    F1                            POP AF
  054A    C9                            RET
                                        ;------------
                                        ; EXECUTE PARAMETER AND JUMP BACK
                                        ;
  054B                          UPROG:  ;       CALL UPROG2
  054B    D5                            PUSH DE         ; DE AS A BACKSPACE ADDRESS ON A STACK
  054C    C9                            RET             ; JUMP (DE)     
                                        ;-------------
                                        ;     
  054D    CD 055D               UPROG1: CALL UPROG2
  0550    D5                            PUSH DE         ; DE AS A BACKSPACE ADDRESS ON A STACK
                                        ;LD BC,HDD      ;(BFRLL)
        MACRO-80 3.43   27-Jul-81       PAGE    1-14


                                        ;LD DE,0000H    ;(BFRHL)
  0551    ED 4B 6500                    LD BC,(BFRLL)
  0555    ED 5B 6502                    LD DE,(BFRHL)
  0559    21 6000                       LD HL,RAM
  055C    C9                            RET             ; JUMP (DE)             
                                        ;--------------
                                        ; LOAD THE JUMP ADDRESS IN DE
                                        ;
  055D    E5                    UPROG2: PUSH HL
  055E    21 7000                       LD HL,PROG
  0561    11 0003                       LD DE,03H       ; ABSTAND 3BYTE SPRUNGBEFEHL
  0564    19                    SUM:    ADD HL,DE
  0565    10 FD                         DJNZ SUM
  0567    23                            INC HL          ; JP BEFEHL (C3) UEBERSPRINGEN
  0568    5E                            LD E,(HL)
  0569    23                            INC HL
  056A    56                            LD D,(HL)
  056B    E1                            POP HL
  056C    C9                            RET
                                        ;--------------
                                        ; earch file name begining
                                        ;
  056D    21 6000               MASK1:  LD HL,RAM
  0570    46                            LD B,(HL)       ; first block length header
  0571    21 6006                       LD HL,RAM+6
  0574    23                    MASK2:  INC HL
  0575    10 FD                         DJNZ MASK2      ; step length
  0577    23                    MASK3:  INC HL          ; 
  0578    3E 1B                         LD A,1BH
  057A    BE                            CP (HL)
  057B    20 FA                         JR NZ,MASK3
  057D    2B                            DEC HL          ; 
  057E    46                            LD B,(HL)       ; to B
  057F    04                            INC B
  0580    7E                            LD A,(HL)
  0581    CD 053A                       CALL TEXOUT
  0584    23                            INC HL
  0585    23                    MASK4:  INC HL
  0586    10 FD                         DJNZ MASK4      ; until the text/image block end
  0588    23                            INC HL          ; file name block beginning
  0589    C9                            RET
                                        ;---------------
                                        ; text block output
                                        ;
  058A    E5                    BTEX:   PUSH HL
  058B    C5                            PUSH BC
  058C    0E 09                         LD C,09H
  058E    CD 0005                       CALL 0005
  0591    C1                            POP BC
  0592    E1                            POP HL
  0593    C9                            RET
                                        ;----------------
                                        ; key input
                                        ;
  0594    C5                    INKEY:  PUSH BC
  0595    D5                            PUSH DE
        MACRO-80 3.43   27-Jul-81       PAGE    1-15


  0596    E5                            PUSH HL
  0597    06 02                         LD B,KEYIN
  0599    CD 055D                       CALL UPROG2
  059C    CD 054B                       CALL UPROG
  059F    E1                            POP HL
  05A0    D1                            POP DE
  05A1    C1                            POP BC
  05A2    C9                            RET
                                        ;-----------------
                                        ; delete screen area
                                        ;
  05A3    C5                    SDEL:   PUSH BC
  05A4    D5                            PUSH DE
  05A5    16 14                         LD D,14H
  05A7    01 0301                       LD BC,0301H
  05AA    1E 45                 SDEL1:  LD E,69D        ; loop counter line
  05AC    D5                            PUSH DE
  05AD    C5                            PUSH BC
  05AE    06 08                         LD B,LPOS
  05B0    CD 055D                       CALL UPROG2
  05B3    C1                            POP BC
  05B4    CD 054B                       CALL UPROG
  05B7    D1                            POP DE
  05B8    3E 20                 SDEL2:  LD A,20H
  05BA    CD 053A                       CALL TEXOUT
  05BD    1D                            DEC E
  05BE    20 F8                         JR NZ,SDEL2
  05C0    78                            LD A,B
  05C1    3C                            INC A
  05C2    27                            DAA
  05C3    47                            LD B,A
  05C4    15                            DEC D
  05C5    20 E3                         JR NZ,SDEL1
  05C7    D1                            POP DE
  05C8    C1                            POP BC
  05C9    C9                            RET
                                ;---------------------------
                                ;
  05CA    1B 5B 30 33           TTEX:   DEFB 1BH,5BH,30H,33H,3BH,30H,35H,48H    ; 
  05CE    3B 30 35 48           
  05D2    53 65 69 74                   DEFM 'Seite neu erstellen '
  05D6    65 20 6E 65           
  05DA    75 20 65 72           
  05DE    73 74 65 6C           
  05E2    6C 65 6E 20           
  05E6    1B 5B 30 36                   DEFB 1BH,5BH,30H,36H,3BH,30H,35H,48H    ; 
  05EA    3B 30 35 48           
  05EE    31 3E 20 41                   DEFM '1> Aendern (Pos.Numer)'
  05F2    65 6E 64 65           
  05F6    72 6E 20 28           
  05FA    50 6F 73 2E           
  05FE    4E 75 6D 65           
  0602    72 29                 
  0604    1B 5B 30 37                   DEFB 1BH,5BH,30H,37H,3BH,30H,35H,48H    ; 
  0608    3B 30 35 48           
  060C    32 3E 20 45                   DEFM '2> Einfuegen (Pos.Numer)'
        MACRO-80 3.43   27-Jul-81       PAGE    1-16


  0610    69 6E 66 75           
  0614    65 67 65 6E           
  0618    20 28 50 6F           
  061C    73 2E 4E 75           
  0620    6D 65 72 29           
  0624    1B 5B 30 38                   DEFB 1BH,5BH,30H,38H,3BH,30H,35H,48H    ; 
  0628    3B 30 35 48           
  062C    33 3E 20 42                   DEFM '3> Bildschirmtext (mit 9 speichern)'
  0630    69 6C 64 73           
  0634    63 68 69 72           
  0638    6D 74 65 78           
  063C    74 20 28 6D           
  0640    69 74 20 39           
  0644    20 73 70 65           
  0648    69 63 68 65           
  064C    72 6E 29              
  064F    1B 5B 30 39                   DEFB 1BH,5BH,30H,39H,3BH,30H,35H,48H    ; 
  0653    3B 30 35 48           
  0657    45 43 53 3E                   DEFM 'ECS> alles verwerfen'
  065B    20 61 6C 6C           
  065F    65 73 20 76           
  0663    65 72 77 65           
  0667    72 66 65 6E           
  066B    1B 5B 31 31                   DEFB 1BH,5BH,31H,31H,3BH,30H,31H,48H    ; 
  066F    3B 30 31 48           
  0673    24                            DEFM '$'        ; block output end BIOS
  0674    2A                            DEFB 2AH
  00AB                          TTLEN   EQU $-TTEX
                                
  0675    00 00 00 00           BF02:   DEFB 00H,00H,00H,00H
  0679    00 00 00 00           BF03:   DEFB 00H,00H,00H,00H    
                                
  067D    1B 5B 02 04           EBUFF:  DEFB 1BH,5BH,02H,04H,3BH,00H,01H,48H
  0681    3B 00 01 48           
  0685    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH
  0689    6D                    
  068A    20 20 20 20                   DEFM '                             '
  068E    20 20 20 20           
  0692    20 20 20 20           
  0696    20 20 20 20           
  069A    20 20 20 20           
  069E    20 20 20 20           
  06A2    20 20 20 20           
  06A6    20                    
  002A                          EZLEN   EQU $-EBUFF
                                
  06A7    1B 5B 02 04           ABUFF:  DEFB 1BH,5BH,02H,04H,3BH,00H,01H,48H
  06AB    3B 00 01 48           
  06AF    20 20 20 20           AUTEX:  DEFM '                             '
  06B3    20 20 20 20           
  06B7    20 20 20 20           
  06BB    20 20 20 20           
  06BF    20 20 20 20           
  06C3    20 20 20 20           
  06C7    20 20 20 20           
  06CB    20                    
        MACRO-80 3.43   27-Jul-81       PAGE    1-17


  0025                          AZLEN   EQU $-ABUFF
                                
  06CC    2E 43 4F 4D           AUTO:   DEFM '.COM        '
  06D0    20 20 20 20           
  06D4    20 20 20 20           
  06D8    0000                  FILEN:  DEFW 0000H
  06DA    00                    ZEILEN: DEFB 00H
                                
                                END
        MACRO-80 3.43   27-Jul-81       PAGE    S


Macros:

Symbols:
06A7    ABUFF           036C    AU00            0370    AU01            
0375    AU10            0380    AU11            0382    AU12            
038C    AU13            03A8    AU14            03AE    AU20            
03B4    AU21            03B5    AU22            03CA    AU31            
03F0    AU32            03ED    AU33            0408    AU34            
0423    AU35            0460    AU36            044E    AU37            
043A    AU370           0472    AU40            050C    AU90            
050D    AUEND           06AF    AUTEX           06CC    AUTO            
0025    AZLEN           0479    BES00           0487    BES01           
0496    BES02           0497    BES03           04A2    BES10           
04AE    BES11           04C8    BES12           04C9    BES13           
04D0    BES19           04D1    BES20           04F7    BES21           
0502    BES210          0503    BES22           04E3    BES23           
04EF    BES24           0482    BES99           0675    BF02            
0679    BF03            6503    BFRHH           6502    BFRHL           
6501    BFRLH           6500    BFRLL           650F    BFSHH           
650E    BFSHL           650D    BFSLH           650C    BFSLL           
650B    BFVHH           650A    BFVHL           6509    BFVLH           
6508    BFVLL           6200    BLAN            6205    BSTAT           
058A    BTEX            0080    BUFF            03E5    CAU31           
0020    CMD_READSEC     0030    CMD_WRITESEC    6C3F    COP             
0007    CPOS            0524    CURP1           0520    CURPOS          
6518    CURS            651C    CURT            067D    EBUFF           
002A    EZLEN           005C    FCB             006B    FCBCR           
005D    FCBFN           0065    FCBFT           007C    FCBRA           
0020    FDC             02E0    FI00            0349    FI10            
0333    FI60            033F    FI61            0368    FI99            
011E    FIL6            012B    FIL7            013D    FIL8            
06D8    FILEN           0800    HDD             00BE    HDDE            
00F0    IDE             00FD    IDECHI          00FC    IDECLO          
00FF    IDECMD          00F8    IDEDAT          00F6    IDEDOR          
00F9    IDEERR          00FA    IDESCNT         00FE    IDESDH          
00FB    IDESNUM         00FF    IDESTAT         0594    INKEY           
0179    KEY1            019F    KEY2            01B8    KEY7            
01D9    KEY8            01FD    KEY9            0002    KEYIN           
0001    KEYOUT          0060    LCD             03FB    LO01            
6513    LOGHH           6512    LOGHL           6511    LOGLH           
6510    LOGLL           0008    LPOS            056D    MASK1           
0574    MASK2           0577    MASK3           0585    MASK4           
A101    MMC             0007    MMCE            001E    PIOB            
7000    PROG            0005    P_READ          0006    P_WRITE         
6524    RADR            6000    RAM             6727    RAMS            
6B27    RAMT            6527    RAMV            0000    RBLAN           
0005    RBSTAT          6526    RMEN            0006    RSOTR           
0004    RTERM           6BEF    RTEX            0002    RTYPE1          
0003    RTYPE2          0001    RUSER           6520    SANDB           
05A3    SDEL            05AA    SDEL1           05B8    SDEL2           
0004    SELDM           00F7    SELDS           051A    STE             
01C5    SUCHD           0564    SUM             6204    TERM            
0161    TEXIN           053A    TEXOUT          05CA    TTEX            
00AB    TTLEN           031D    TY00            6202    TYPE1           
6203    TYPE2           054B    UPROG           054D    UPROG1          
055D    UPROG2          0080    URCS            6201    USER            
02C2    WINCHA          02C4    WINDO           020C    WINDOW          
        MACRO-80 3.43   27-Jul-81       PAGE    S-1


02B1    WINOUT          02C0    WINPOS          0231    WINX1           
025D    WINX2           0294    WINX3           02BE    WINXY           
023F    WINY1           06DA    ZEILEN          



No Fatal error(s)


                                                                                                                                                                                                                                                                                                                                                                                                                                   
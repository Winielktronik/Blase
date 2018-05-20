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
  0100    DD E5                         PUSH IX
  0102    DD 21 0000                    LD IX,0
  0106    DD 39                         ADD IX,SP
                                        ;--------
  0108    C5                            PUSH BC
  0109    D5                            PUSH DE
  010A    E5                            PUSH HL
                                        ;-----------------
                                        ; PROGRAM ONLY RUNS IN TYPE2 > 0
                                        ;
  010B    3A 6003                       LD A,(RAM+RTYPE2)
  010E    FE 00                         CP 0
                                ;??     JP Z,AUEND              ; OUTPUT IF TYPE2 <1
                                        ;--------------
                                        ; search image output
                                        ;
  0110    CD 0343                       CALL MASK1
                                        ;
                                        ; from here issue
                                        ;
  0113    C5                            PUSH BC
  0114    06 08                         LD B,LPOS
  0116    CD 0333                       CALL UPROG2
  0119    01 0471                       LD BC,0471H
  011C    ED 43 04AE                    LD (FILEN),BC
  0120    CD 0321                       CALL UPROG
  0123    C1                            POP BC
  0124    3E 31                         LD A,'1'
  0126    32 04B0               FIL6:   LD (ZEILEN),A
  0129    CD 0310                       CALL TEXOUT
  012C    3E 20                         LD A,' '
  012E    CD 0310                       CALL TEXOUT
  0131    06 0C                         LD B,0CH
  0133    7E                    FIL7:   LD A,(HL)
  0134    FE 00                         CP 00H
  0136    28 31                         JR Z,TEXIN
  0138    CD 0310                       CALL TEXOUT
  013B    23                            INC HL
  013C    7E                            LD A,(HL)
  013D    FE 2E                         CP '.'
  013F    28 04                         JR Z,FIL8
  0141    10 F0                         DJNZ FIL7
        MACRO-80 3.43   27-Jul-81       PAGE    1-3


  0143    18 24                         JR TEXIN
                                        ;------------
  0145    05                    FIL8:   DEC B
  0146    23                            INC HL
  0147    10 FD                         DJNZ FIL8+1
                                        ;------------
  0149    C5                            PUSH BC
  014A    06 08                         LD B,LPOS
  014C    CD 0333                       CALL UPROG2
  014F    ED 4B 04AE                    LD BC,(FILEN)
  0153    04                            INC B
  0154    ED 43 04AE                    LD (FILEN),BC
  0158    CD 0321                       CALL UPROG
  015B    C1                            POP BC
  015C    7E                            LD A,(HL)
  015D    FE 00                         CP 00H
  015F    28 08                         JR Z,TEXIN
  0161    3A 04B0                       LD A,(ZEILEN)
  0164    3C                            INC A
  0165    E5                            PUSH HL         ; SWAP HL->DE
  0166    D1                            POP DE
  0167    18 BD                         JR FIL6         
                                        ;--------------------
                                        ; SET CURSOR ON START POSITION
                                        ;
  0169    CD 0379               TEXIN:  CALL SDEL
  016C    11 03A0                       LD DE,TTEX
  016F    CD 0360                       CALL BTEX       ; text block TTEX output
  0172    01 1110                       LD BC,1110H     ; positon 
  0175    21 0E01                       LD HL,0E01H     ; length Width 
  0178    CD 021D                       CALL WINDOW
                                        ;--------------
                                        ; TEXT input
                                        ;
  017B    11 04A2                       LD DE,AUTO
  017E    CD 036A               KEY1:   CALL INKEY
  0181    FE 00                         CP 0
  0183    28 F9                         JR Z,KEY1
  0185    FE 0D                         CP 0DH
  0187    CA 01A4                       JP Z,KEY2       ; !!!!AUSGANG VORERST 
  018A    12                            LD (DE),A
  018B    13                            INC DE
  018C    23                            INC HL
  018D    D5                            PUSH DE
  018E    3E 2E                         LD A,'.'
  0190    12                            LD (DE),A
  0191    13                            INC DE
  0192    3E 43                         LD A,'C'
  0194    12                            LD (DE),A
  0195    13                            INC DE
  0196    3E 4F                         LD A,'O'
  0198    12                            LD (DE),A
  0199    13                            INC DE
  019A    3E 4D                         LD A,'M'
  019C    12                            LD (DE),A
  019D    13                            INC DE 
        MACRO-80 3.43   27-Jul-81       PAGE    1-4


  019E    3E 20                         LD A,' '
  01A0    12                            LD (DE),A
  01A1    D1                            POP DE
  01A2    18 DA                         JR KEY1
                                        ;--------------
                                        ; search image output
                                        ;
  01A4    CD 0343               KEY2:   CALL MASK1
                                        ;
                                        ; from here issue
                                        ;
  01A7    C5                            PUSH BC
  01A8    06 08                         LD B,LPOS
  01AA    CD 0333                       CALL UPROG2
  01AD    01 0471                       LD BC,0471H
  01B0    ED 43 04AE                    LD (FILEN),BC
  01B4    CD 0321                       CALL UPROG
  01B7    C1                            POP BC
  01B8    11 04A2                       LD DE,AUTO
  01BB    3E 31                         LD A,'1'
  01BD    32 04B0               KEY7:   LD (ZEILEN),A
  01C0    CD 0310                       CALL TEXOUT
  01C3    3E 20                         LD A,' '
  01C5    CD 0310                       CALL TEXOUT
  01C8    06 0C                         LD B,0CH
  01CA    1A                    SUCHD:  LD A,(DE)
  01CB    FE 00                         CP 00H
  01CD    28 3F                         JR Z,KEY9
  01CF    77                            LD (HL),A       
  01D0    CD 0310                       CALL TEXOUT
  01D3    13                            INC DE
  01D4    23                            INC HL
  01D5    1A                            LD A,(DE)
  01D6    FE 2E                         CP '.'
  01D8    28 04                         JR Z,SUCHE      ; ->continue without issue
  01DA    10 EE                         DJNZ SUCHD
  01DC    18 30                         JR KEY9
                                        ;------------
  01DE    1A                    SUCHE:  LD A,(DE)
  01DF    77                            LD (HL),A
  01E0    FE 00                         CP 00H
  01E2    28 2A                         JR Z,KEY9
  01E4    13                            INC DE
  01E5    23                            INC HL
  01E6    10 F6                         DJNZ SUCHE
  01E8    18 24                         JR KEY9
                                        ;------------
  01EA    05                    KEY8:   DEC B
  01EB    23                            INC HL
  01EC    10 FD                         DJNZ KEY8+1
  01EE    C5                            PUSH BC
  01EF    06 08                         LD B,LPOS
  01F1    CD 0333                       CALL UPROG2
  01F4    ED 4B 04AE                    LD BC,(FILEN)
  01F8    04                            INC B
  01F9    ED 43 04AE                    LD (FILEN),BC
        MACRO-80 3.43   27-Jul-81       PAGE    1-5


  01FD    CD 0321                       CALL UPROG
  0200    C1                            POP BC
  0201    7E                            LD A,(HL)
  0202    FE 00                         CP 00H
  0204    28 08                         JR Z,KEY9
  0206    3A 04B0                       LD A,(ZEILEN)
  0209    3C                            INC A
  020A    E5                            PUSH HL         ; SWAP HL->DE
  020B    D1                            POP DE
  020C    18 AF                         JR KEY7         
                                        ;--------------
  020E    06 02                 KEY9:   LD B,KEYIN
  0210    CD 0333                       CALL UPROG2
  0213    CD 0321                       CALL UPROG
  0216    FE 00                         CP 0
  0218    28 F4                         JR Z,KEY9       ; press key for end
  021A    C3 02DF                       JP AUEND
                                        ;------------------
                         C              INCLUDE RAHMEN.MAC      ; SET WINDOW
                         C              ;----------------
  021D    22 02CF        C      WINDOW: LD (WINXY),HL   ; WINDOW X,Y
  0220    ED 43 02D1     C              LD (WINPOS),BC  ; STARTPOS X,Y
  0224    C5             C              PUSH BC         ; =X,Y POSITION 
  0225    E5             C              PUSH HL         ; =X,Y LAENGE
  0226    04             C              INC B
  0227    0C             C              INC C
  0228    ED 43 02D3     C              LD (WINCHA),BC  ; for pos in windows
  022C    06 08          C              LD B,LPOS       ; SUBROUTINE CALL CURSOR IN BLASE ON POSITION
  022E    CD 0333        C              CALL UPROG2
  0231    ED 4B 02D1     C              LD BC,(WINPOS)
  0235    CD 0321        C              CALL UPROG
                         C              ;----------------
                         C              ; START WINDOW
                         C              ;
  0238    3A 02D5        C              LD A,(WINDO)    ; LEFT UP CORNER
  023B    CD 02C2        C              CALL WINOUT
  023E    ED 4B 02CF     C              LD BC,(WINXY)   ; LOAD X
  0242    3A 02D6        C      WINX1:  LD A,(WINDO+1)  ; UP X LINE
  0245    CD 02C2        C              CALL WINOUT
  0248    10 F8          C              DJNZ WINX1
  024A    3A 02D7        C              LD A,(WINDO+2)  ; RIGHT UP CORNER
  024D    CD 02C2        C              CALL WINOUT
                         C              ;----------------OK.
                         C              ; NEW LINE
                         C              ;
  0250    06 08          C      WINY1:  LD B,LPOS       ; BIOS BLASE
  0252    CD 0333        C              CALL UPROG2
  0255    ED 4B 02D1     C              LD BC,(WINPOS)
  0259    04             C              INC B
  025A    78             C              LD A,B
  025B    27             C              DAA
  025C    47             C              LD B,A
  025D    ED 43 02D1     C              LD (WINPOS),BC
  0261    CD 0321        C              CALL UPROG      ; SET
  0264    3A 02D8        C              LD A,(WINDO+3)  ; LEFT SIDE
  0267    CD 02C2        C              CALL WINOUT
        MACRO-80 3.43   27-Jul-81       PAGE    1-6


                         C              ;----------------
  026A    ED 4B 02CF     C              LD BC,(WINXY)
  026E    3A 02D9        C      WINX2:  LD A,(WINDO+4)  ; SPACE 
  0271    CD 02C2        C              CALL WINOUT
  0274    10 F8          C              DJNZ WINX2
  0276    3A 02DA        C              LD A,(WINDO+5)  ; RIGHT SIDE
  0279    CD 02C2        C              CALL WINOUT
  027C    ED 4B 02CF     C              LD BC,(WINXY)
  0280    0D             C              DEC C
  0281    ED 43 02CF     C              LD (WINXY),BC
  0285    20 C9          C              JR NZ,WINY1
  0287    06 08          C              LD B,LPOS
  0289    CD 0333        C              CALL UPROG2
  028C    ED 4B 02D1     C              LD BC,(WINPOS)
  0290    04             C              INC B
  0291    78             C              LD A,B
  0292    27             C              DAA
  0293    47             C              LD B,A
  0294    ED 43 02D1     C              LD (WINPOS),BC
  0298    CD 0321        C              CALL UPROG      ; SET
  029B    3A 02DB        C              LD A,(WINDO+6)  ; LEFT DOWN CORNER
  029E    CD 02C2        C              CALL WINOUT
  02A1    ED 4B 02CF     C              LD BC,(WINXY)
  02A5    3A 02DC        C      WINX3:  LD A,(WINDO+7)  ; DOWN LINE 
  02A8    CD 02C2        C              CALL WINOUT
  02AB    10 F8          C              DJNZ WINX3
  02AD    3A 02DD        C              LD A,(WINDO+8)  ; RIGHT SIDE
  02B0    CD 02C2        C              CALL WINOUT
  02B3    06 08          C              LD B,LPOS
  02B5    CD 0333        C              CALL UPROG2
  02B8    ED 4B 02D3     C              LD BC,(WINCHA)
  02BC    CD 0321        C              CALL UPROG      ; SET
  02BF    E1             C              POP HL
  02C0    C1             C              POP BC
  02C1    C9             C              RET
                         C              ;-----------------
  02C2    C5             C      WINOUT: PUSH BC
  02C3    E5             C              PUSH HL
  02C4    06 01          C              LD B,KEYOUT     ; SUBROUTINE KEY CALL OUTPUT IN BLASE
  02C6    CD 0333        C              CALL UPROG2
  02C9    CD 0321        C              CALL UPROG
  02CC    E1             C              POP HL
  02CD    C1             C              POP BC
  02CE    C9             C              RET
  02CF    0000           C      WINXY:  DEFW 0000H
  02D1    0000           C      WINPOS: DEFW 0000H
  02D3    0000           C      WINCHA: DEFW 0000H
  02D5    DA C4 BF       C      WINDO:  DEFB 218D,196D,191D
  02D8    B3 20 B3       C              DEFB 179D,20H,179D
  02DB    C0 C4 D9       C              DEFB 192D,196D,217D
                         C              ;-----------------
                         C      
                                        ;-----------------
  02DE    C1                    AU90:   POP BC
  02DF    E1                    AUEND:  POP HL
  02E0    D1                            POP DE
        MACRO-80 3.43   27-Jul-81       PAGE    1-7


  02E1    C1                            POP BC
                                        ;---------
  02E2    DD F9                         LD SP,IX
  02E4    DD E1                         POP IX
                                        ;---------
  02E6    AF                            XOR A
  02E7    32 6B27                       LD (RAMT),A
  02EA    3E 00                         LD A,00         ; PROGRAMM START XX
  02EC    32 6200                       LD (BLAN),A
  02EF    C9                            RET
                                        ;-----------------
  02F0    37                    STE:    SCF
  02F1    AF                            XOR     A       
  02F2    32 6200                       LD      (BLAN),A
  02F5    C9                            RET
                                        ;---------------
                                        ; CURSOR OFF END FROM CHARACTER SET
  02F6    C5                    CURPOS: PUSH BC
  02F7    04                            INC B           ;CHARACTER LENGTH +1
  02F8    3E 00                         LD A,00H        ;COUNR FROM 0
  02FA    3C                    CURP1:  INC A
  02FB    27                            DAA
  02FC    10 FC                         DJNZ CURP1
  02FE    47                            LD B,A
  02FF    E6 0F                         AND 0FH
  0301    32 651F                       LD (CURT+3),A
  0304    78                            LD A,B
  0305    0F                            RRCA
  0306    0F                            RRCA
  0307    0F                            RRCA
  0308    0F                            RRCA
  0309    E6 0F                         AND 0FH
  030B    32 651E                       LD (CURT+2),A
  030E    C1                            POP BC
  030F    C9                            RET
                                        ;---------------
                                        ; give up sing in a
                                        ;
  0310    F5                    TEXOUT: PUSH AF
  0311    C5                            PUSH BC
  0312    D5                            PUSH DE
  0313    E5                            PUSH HL
  0314    06 01                         LD B,KEYOUT
  0316    CD 0333                       CALL UPROG2
  0319    CD 0321                       CALL UPROG
  031C    E1                            POP HL
  031D    D1                            POP DE
  031E    C1                            POP BC
  031F    F1                            POP AF
  0320    C9                            RET
                                        ;------------
                                        ; EXECUTE PARAMETER AND JUMP BACK
                                        ;
  0321                          UPROG:  ;       CALL UPROG2
  0321    D5                            PUSH DE         ; DE AS A BACKSPACE ADDRESS ON A STACK
  0322    C9                            RET             ; JUMP (DE)     
        MACRO-80 3.43   27-Jul-81       PAGE    1-8


                                        ;-------------
                                        ;     
  0323    CD 0333               UPROG1: CALL UPROG2
  0326    D5                            PUSH DE         ; DE AS A BACKSPACE ADDRESS ON A STACK
                                        ;LD BC,HDD      ;(BFRLL)
                                        ;LD DE,0000H    ;(BFRHL)
  0327    ED 4B 6500                    LD BC,(BFRLL)
  032B    ED 5B 6502                    LD DE,(BFRHL)
  032F    21 6000                       LD HL,RAM
  0332    C9                            RET             ; JUMP (DE)             
                                        ;--------------
                                        ; LOAD THE JUMP ADDRESS IN DE
                                        ;
  0333    E5                    UPROG2: PUSH HL
  0334    21 7000                       LD HL,PROG
  0337    11 0003                       LD DE,03H       ; ABSTAND 3BYTE SPRUNGBEFEHL
  033A    19                    SUM:    ADD HL,DE
  033B    10 FD                         DJNZ SUM
  033D    23                            INC HL          ; JP BEFEHL (C3) UEBERSPRINGEN
  033E    5E                            LD E,(HL)
  033F    23                            INC HL
  0340    56                            LD D,(HL)
  0341    E1                            POP HL
  0342    C9                            RET
                                        ;--------------
                                        ; earch file name begining
                                        ;
  0343    21 6000               MASK1:  LD HL,RAM
  0346    46                            LD B,(HL)       ; first block length header
  0347    21 6006                       LD HL,RAM+6
  034A    23                    MASK2:  INC HL
  034B    10 FD                         DJNZ MASK2      ; step length
  034D    23                    MASK3:  INC HL          ; 
  034E    3E 1B                         LD A,1BH
  0350    BE                            CP (HL)
  0351    20 FA                         JR NZ,MASK3
  0353    2B                            DEC HL          ; 
  0354    46                            LD B,(HL)       ; to B
  0355    04                            INC B
  0356    7E                            LD A,(HL)
  0357    CD 0310                       CALL TEXOUT
  035A    23                            INC HL
  035B    23                    MASK4:  INC HL
  035C    10 FD                         DJNZ MASK4      ; until the text/image block end
  035E    23                            INC HL          ; file name block beginning
  035F    C9                            RET
                                        ;---------------
                                        ; text block output
                                        ;
  0360    E5                    BTEX:   PUSH HL
  0361    C5                            PUSH BC
  0362    0E 09                         LD C,09H
  0364    CD 0005                       CALL 0005
  0367    C1                            POP BC
  0368    E1                            POP HL
  0369    C9                            RET
        MACRO-80 3.43   27-Jul-81       PAGE    1-9


                                        ;----------------
                                        ; key input
                                        ;
  036A    C5                    INKEY:  PUSH BC
  036B    D5                            PUSH DE
  036C    E5                            PUSH HL
  036D    06 02                         LD B,KEYIN
  036F    CD 0333                       CALL UPROG2
  0372    CD 0321                       CALL UPROG
  0375    E1                            POP HL
  0376    D1                            POP DE
  0377    C1                            POP BC
  0378    C9                            RET
                                        ;-----------------
                                        ; delete screen area
                                        ;
  0379    C5                    SDEL:   PUSH BC
  037A    D5                            PUSH DE
  037B    16 14                         LD D,14H
  037D    01 0301                       LD BC,0301H
  0380    1E 45                 SDEL1:  LD E,69D        ; loop counter line
  0382    D5                            PUSH DE
  0383    C5                            PUSH BC
  0384    06 08                         LD B,LPOS
  0386    CD 0333                       CALL UPROG2
  0389    C1                            POP BC
  038A    CD 0321                       CALL UPROG
  038D    D1                            POP DE
  038E    3E 20                 SDEL2:  LD A,20H
  0390    CD 0310                       CALL TEXOUT
  0393    1D                            DEC E
  0394    20 F8                         JR NZ,SDEL2
  0396    78                            LD A,B
  0397    3C                            INC A
  0398    27                            DAA
  0399    47                            LD B,A
  039A    15                            DEC D
  039B    20 E3                         JR NZ,SDEL1
  039D    D1                            POP DE
  039E    C1                            POP BC
  039F    C9                            RET
                                ;---------------------------
                                ;
  03A0    1B 5B 30 33           TTEX:   DEFB 1BH,5BH,30H,33H,3BH,30H,35H,48H    ; 
  03A4    3B 30 35 48           
  03A8    53 65 69 74                   DEFM 'Seite neu erstellen '
  03AC    65 20 6E 65           
  03B0    75 20 65 72           
  03B4    73 74 65 6C           
  03B8    6C 65 6E 20           
  03BC    1B 5B 30 36                   DEFB 1BH,5BH,30H,36H,3BH,30H,35H,48H    ; 
  03C0    3B 30 35 48           
  03C4    31 3E 20 41                   DEFM '1> Aendern (Pos.Numer)'
  03C8    65 6E 64 65           
  03CC    72 6E 20 28           
  03D0    50 6F 73 2E           
        MACRO-80 3.43   27-Jul-81       PAGE    1-10


  03D4    4E 75 6D 65           
  03D8    72 29                 
  03DA    1B 5B 30 37                   DEFB 1BH,5BH,30H,37H,3BH,30H,35H,48H    ; 
  03DE    3B 30 35 48           
  03E2    32 3E 20 45                   DEFM '2> Einfuegen (Pos.Numer)'
  03E6    69 6E 66 75           
  03EA    65 67 65 6E           
  03EE    20 28 50 6F           
  03F2    73 2E 4E 75           
  03F6    6D 65 72 29           
  03FA    1B 5B 30 38                   DEFB 1BH,5BH,30H,38H,3BH,30H,35H,48H    ; 
  03FE    3B 30 35 48           
  0402    33 3E 20 42                   DEFM '3> Bildschirmtext (mit 9 speichern)'
  0406    69 6C 64 73           
  040A    63 68 69 72           
  040E    6D 74 65 78           
  0412    74 20 28 6D           
  0416    69 74 20 39           
  041A    20 73 70 65           
  041E    69 63 68 65           
  0422    72 6E 29              
  0425    1B 5B 30 39                   DEFB 1BH,5BH,30H,39H,3BH,30H,35H,48H    ; 
  0429    3B 30 35 48           
  042D    45 43 53 3E                   DEFM 'ECS> alles verwerfen'
  0431    20 61 6C 6C           
  0435    65 73 20 76           
  0439    65 72 77 65           
  043D    72 66 65 6E           
  0441    1B 5B 31 31                   DEFB 1BH,5BH,31H,31H,3BH,30H,31H,48H    ; 
  0445    3B 30 31 48           
  0449    24                            DEFM '$'        ; block output end BIOS
  044A    2A                            DEFB 2AH
  00AB                          TTLEN   EQU $-TTEX
                                
  044B    00 00 00 00           BF02:   DEFB 00H,00H,00H,00H
  044F    00 00 00 00           BF03:   DEFB 00H,00H,00H,00H    
                                
  0453    1B 5B 02 04           EBUFF:  DEFB 1BH,5BH,02H,04H,3BH,00H,01H,48H
  0457    3B 00 01 48           
  045B    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH
  045F    6D                    
  0460    20 20 20 20                   DEFM '                             '
  0464    20 20 20 20           
  0468    20 20 20 20           
  046C    20 20 20 20           
  0470    20 20 20 20           
  0474    20 20 20 20           
  0478    20 20 20 20           
  047C    20                    
  002A                          EZLEN   EQU $-EBUFF
                                
  047D    1B 5B 02 04           ABUFF:  DEFB 1BH,5BH,02H,04H,3BH,00H,01H,48H
  0481    3B 00 01 48           
  0485    20 20 20 20           AUTEX:  DEFM '                             '
  0489    20 20 20 20           
  048D    20 20 20 20           
        MACRO-80 3.43   27-Jul-81       PAGE    1-11


  0491    20 20 20 20           
  0495    20 20 20 20           
  0499    20 20 20 20           
  049D    20 20 20 20           
  04A1    20                    
  0025                          AZLEN   EQU $-ABUFF
                                
  04A2    2E 43 4F 4D           AUTO:   DEFM '.COM        '
  04A6    20 20 20 20           
  04AA    20 20 20 20           
  04AE    0000                  FILEN:  DEFW 0000H
  04B0    00                    ZEILEN: DEFB 00H
                                
                                END
        MACRO-80 3.43   27-Jul-81       PAGE    S


Macros:

Symbols:
047D    ABUFF           02DE    AU90            02DF    AUEND           
0485    AUTEX           04A2    AUTO            0025    AZLEN           
044B    BF02            044F    BF03            6503    BFRHH           
6502    BFRHL           6501    BFRLH           6500    BFRLL           
650F    BFSHH           650E    BFSHL           650D    BFSLH           
650C    BFSLL           650B    BFVHH           650A    BFVHL           
6509    BFVLH           6508    BFVLL           6200    BLAN            
6205    BSTAT           0360    BTEX            0080    BUFF            
0020    CMD_READSEC     0030    CMD_WRITESEC    6C3F    COP             
0007    CPOS            02FA    CURP1           02F6    CURPOS          
6518    CURS            651C    CURT            0453    EBUFF           
002A    EZLEN           005C    FCB             006B    FCBCR           
005D    FCBFN           0065    FCBFT           007C    FCBRA           
0020    FDC             0126    FIL6            0133    FIL7            
0145    FIL8            04AE    FILEN           0800    HDD             
00BE    HDDE            00F0    IDE             00FD    IDECHI          
00FC    IDECLO          00FF    IDECMD          00F8    IDEDAT          
00F6    IDEDOR          00F9    IDEERR          00FA    IDESCNT         
00FE    IDESDH          00FB    IDESNUM         00FF    IDESTAT         
036A    INKEY           017E    KEY1            01A4    KEY2            
01BD    KEY7            01EA    KEY8            020E    KEY9            
0002    KEYIN           0001    KEYOUT          0060    LCD             
6513    LOGHH           6512    LOGHL           6511    LOGLH           
6510    LOGLL           0008    LPOS            0343    MASK1           
034A    MASK2           034D    MASK3           035B    MASK4           
A101    MMC             0007    MMCE            001E    PIOB            
7000    PROG            0005    P_READ          0006    P_WRITE         
6524    RADR            6000    RAM             6727    RAMS            
6B27    RAMT            6527    RAMV            0000    RBLAN           
0005    RBSTAT          6526    RMEN            0006    RSOTR           
0004    RTERM           6BEF    RTEX            0002    RTYPE1          
0003    RTYPE2          0001    RUSER           6520    SANDB           
0379    SDEL            0380    SDEL1           038E    SDEL2           
0004    SELDM           00F7    SELDS           02F0    STE             
01CA    SUCHD           01DE    SUCHE           033A    SUM             
6204    TERM            0169    TEXIN           0310    TEXOUT          
03A0    TTEX            00AB    TTLEN           6202    TYPE1           
6203    TYPE2           0321    UPROG           0323    UPROG1          
0333    UPROG2          0080    URCS            6201    USER            
02D3    WINCHA          02D5    WINDO           021D    WINDOW          
02C2    WINOUT          02D1    WINPOS          0242    WINX1           
026E    WINX2           02A5    WINX3           02CF    WINXY           
0250    WINY1           04B0    ZEILEN          



No Fatal error(s)


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
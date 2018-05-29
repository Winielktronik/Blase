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
  0009                   C      KEYBUF  EQU 09H         ; input keypad buffer, end with <cr> 
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
  0106    DD 39                         ADD IX,SP       ; Rescue SP to save
                                        ;--------
  0108    C5                            PUSH BC
  0109    D5                            PUSH DE
  010A    E5                            PUSH HL
                                        ;-----------------
                                        ; execute program only if TYPE2 > 0
                                        ;
  010B    3A 6003                       LD A,(RAM+RTYPE2)
  010E    FE 00                         CP 0
                                ;??     JP Z,AUEND              ; ??? Exit if TYPE2 < 1
                                        ;--------------
                                        ; search image output
                                        ;
  0110    CD 03C5                       CALL MASK1
                                        ;
                                        ; from here issue
                                        ;
  0113    C5                            PUSH BC
  0114    06 08                         LD B,LPOS
  0116    CD 03B5                       CALL UPROG2
  0119    01 0471                       LD BC,0471H
  011C    ED 43 0542                    LD (FILEN),BC
  0120    CD 03AE                       CALL UPROG
  0123    C1                            POP BC
  0124    3E 31                         LD A,'1'
  0126    32 0544               FIL6:   LD (ZEILEN),A
  0129    CD 039D                       CALL TEXOUT
  012C    3E 20                         LD A,' '
  012E    CD 039D                       CALL TEXOUT
  0131    06 0C                         LD B,0CH
  0133    7E                    FIL7:   LD A,(HL)
  0134    FE 21                         CP 21H
  0136    38 31                         JR C,TEXIN
  0138    CD 039D                       CALL TEXOUT
  013B    23                            INC HL
  013C    7E                            LD A,(HL)
  013D    FE 2E                         CP '.'
  013F    28 04                         JR Z,FIL8
        MACRO-80 3.43   27-Jul-81       PAGE    1-3


  0141    10 F0                         DJNZ FIL7
  0143    18 24                         JR TEXIN
                                        ;------------
  0145    05                    FIL8:   DEC B
  0146    23                            INC HL
  0147    10 FD                         DJNZ FIL8+1
                                        ;------------
  0149    C5                            PUSH BC
  014A    06 08                         LD B,LPOS
  014C    CD 03B5                       CALL UPROG2
  014F    ED 4B 0542                    LD BC,(FILEN)
  0153    04                            INC B
  0154    ED 43 0542                    LD (FILEN),BC
  0158    CD 03AE                       CALL UPROG
  015B    C1                            POP BC
  015C    7E                            LD A,(HL)
  015D    FE 21                         CP 21H
  015F    38 08                         JR C,TEXIN
  0161    3A 0544                       LD A,(ZEILEN)
  0164    3C                            INC A
  0165    E5                            PUSH HL         ; SWAP HL->DE
  0166    D1                            POP DE
  0167    18 BD                         JR FIL6         
                                        ;--------------------
                                        ; SET CURSOR ON START POSITION
                                        ;
  0169    CD 040D               TEXIN:  CALL SDEL
  016C    11 0434                       LD DE,TTEX
  016F    CD 03E2                       CALL BTEX       ; text block TTEX output
  0172    01 1110                       LD BC,1110H     ; positon 
  0175    21 0E01                       LD HL,0E01H     ; length Width 
  0178    CD 0227                       CALL WINDOW
                                        ;--------------
                                        ; TEXT input
                                        ;
  017B    21 6B27                       LD HL,RAMT
  017E    AF                            XOR A
  017F    77                            LD (HL),A
  0180    11 0536                       LD DE,AUTO
  0183    06 08                         LD B,08H        ; input character length (file) name.
  0185    C5                    KEY1:   PUSH BC
  0186    D5                            PUSH DE
  0187    E5                            PUSH HL
  0188    CD 03FE                       CALL INKEY
  018B    E1                            POP HL
  018C    D1                            POP DE
  018D    C1                            POP BC
  018E    FE 00                         CP 0
  0190    28 F3                         JR Z,KEY1
  0192    CD 03EC                       CALL COMKEY
  0195    FE 0D                         CP 0DH
  0197    28 17                         JR Z,KEY2
  0199    D5                            PUSH DE
  019A    3E 2E                         LD A,'.'
  019C    12                            LD (DE),A
  019D    13                            INC DE
        MACRO-80 3.43   27-Jul-81       PAGE    1-4


  019E    3E 43                         LD A,'C'
  01A0    12                            LD (DE),A
  01A1    13                            INC DE
  01A2    3E 4F                         LD A,'O'
  01A4    12                            LD (DE),A
  01A5    13                            INC DE
  01A6    3E 4D                         LD A,'M'
  01A8    12                            LD (DE),A
  01A9    13                            INC DE 
  01AA    3E 20                         LD A,' '
  01AC    12                            LD (DE),A
  01AD    D1                            POP DE
  01AE    18 D5                         JR KEY1
                                        ;--------------
                                        ; search image output
                                        ;
  01B0    CD 03C5               KEY2:   CALL MASK1
                                        ;
                                        ; from here issue
                                        ;
  01B3    C5                            PUSH BC
  01B4    06 08                         LD B,LPOS
  01B6    CD 03B5                       CALL UPROG2
  01B9    01 0471                       LD BC,0471H
  01BC    ED 43 0542                    LD (FILEN),BC
  01C0    CD 03AE                       CALL UPROG
  01C3    C1                            POP BC
  01C4    11 0536                       LD DE,AUTO
  01C7    3E 31                         LD A,'1'
  01C9    32 0544               KEY7:   LD (ZEILEN),A
  01CC    CD 039D                       CALL TEXOUT
  01CF    3E 20                         LD A,' '
  01D1    CD 039D                       CALL TEXOUT
  01D4    06 0C                         LD B,0CH
  01D6    1A                    SUCHD:  LD A,(DE)
  01D7    FE 21                         CP 21H
  01D9    38 3D                         JR C,KEY9
  01DB    77                            LD (HL),A       
  01DC    CD 039D                       CALL TEXOUT
  01DF    13                            INC DE
  01E0    23                            INC HL
  01E1    1A                            LD A,(DE)
  01E2    FE 2E                         CP '.'
  01E4    28 04                         JR Z,SUCHE      ; ->continue without issue
  01E6    10 EE                         DJNZ SUCHD
  01E8    18 2E                         JR KEY9
                                        ;------------
  01EA    1A                    SUCHE:  LD A,(DE)
  01EB    77                            LD (HL),A
  01EC    FE 21                         CP 21H
  01EE    38 04                         JR C,KEY8
  01F0    13                            INC DE
  01F1    23                            INC HL
  01F2    10 F6                         DJNZ SUCHE
                                        ;!!! JR KEY9
                                        ;------------
        MACRO-80 3.43   27-Jul-81       PAGE    1-5


  01F4    05                    KEY8:   DEC B
  01F5    23                            INC HL
  01F6    10 FD                         DJNZ KEY8+1
  01F8    C5                            PUSH BC
  01F9    06 08                         LD B,LPOS
  01FB    CD 03B5                       CALL UPROG2
  01FE    ED 4B 0542                    LD BC,(FILEN)
  0202    04                            INC B
  0203    ED 43 0542                    LD (FILEN),BC
  0207    CD 03AE                       CALL UPROG
  020A    C1                            POP BC
  020B    7E                            LD A,(HL)
  020C    FE 21                         CP 21H
  020E    38 08                         JR C,KEY9
  0210    3A 0544                       LD A,(ZEILEN)
  0213    3C                            INC A
  0214    E5                            PUSH HL         ; SWAP HL->DE
  0215    D1                            POP DE
  0216    18 B1                         JR KEY7         
                                        ;--------------
  0218    06 02                 KEY9:   LD B,KEYIN
  021A    CD 03B5                       CALL UPROG2
  021D    CD 03AE                       CALL UPROG
  0220    FE 00                         CP 0
  0222    28 F4                         JR Z,KEY9       ; press key for end
  0224    C3 02E8                       JP AUEND
                                        ;------------------
                         C              INCLUDE RAHMEN.MAC      ; SET WINDOW:
                         C              ;----------------
  0227    22 02D9        C      WINDOW: LD (WINXY),HL   ; WINDOW X,Y
  022A    ED 43 02DB     C              LD (WINPOS),BC  ; STARTPOS X,Y
  022E    C5             C              PUSH BC         ; =X,Y POSITION 
  022F    E5             C              PUSH HL         ; =X,Y LAENGE
  0230    04             C              INC B
  0231    0C             C              INC C
  0232    ED 43 02DD     C              LD (WINCHA),BC  ; for pos in windows
  0236    06 08          C              LD B,LPOS       ; SUBROUTINE CALL CURSOR IN BLASE ON POSITION
  0238    CD 03B5        C              CALL UPROG2
  023B    ED 4B 02DB     C              LD BC,(WINPOS)
  023F    CD 03AE        C              CALL UPROG
                         C              ;----------------
                         C              ; START WINDOW
                         C              ;
  0242    3A 02DF        C              LD A,(WINDO)    ; LEFT UP CORNER
  0245    CD 02CC        C              CALL WINOUT
  0248    ED 4B 02D9     C              LD BC,(WINXY)   ; LOAD X
  024C    3A 02E0        C      WINX1:  LD A,(WINDO+1)  ; UP X LINE
  024F    CD 02CC        C              CALL WINOUT
  0252    10 F8          C              DJNZ WINX1
  0254    3A 02E1        C              LD A,(WINDO+2)  ; RIGHT UP CORNER
  0257    CD 02CC        C              CALL WINOUT
                         C              ;----------------OK.
                         C              ; NEW LINE
                         C              ;
  025A    06 08          C      WINY1:  LD B,LPOS       ; BIOS BLASE
  025C    CD 03B5        C              CALL UPROG2
        MACRO-80 3.43   27-Jul-81       PAGE    1-6


  025F    ED 4B 02DB     C              LD BC,(WINPOS)
  0263    04             C              INC B
  0264    78             C              LD A,B
  0265    27             C              DAA
  0266    47             C              LD B,A
  0267    ED 43 02DB     C              LD (WINPOS),BC
  026B    CD 03AE        C              CALL UPROG      ; SET
  026E    3A 02E2        C              LD A,(WINDO+3)  ; LEFT SIDE
  0271    CD 02CC        C              CALL WINOUT
                         C              ;----------------
  0274    ED 4B 02D9     C              LD BC,(WINXY)
  0278    3A 02E3        C      WINX2:  LD A,(WINDO+4)  ; SPACE 
  027B    CD 02CC        C              CALL WINOUT
  027E    10 F8          C              DJNZ WINX2
  0280    3A 02E4        C              LD A,(WINDO+5)  ; RIGHT SIDE
  0283    CD 02CC        C              CALL WINOUT
  0286    ED 4B 02D9     C              LD BC,(WINXY)
  028A    0D             C              DEC C
  028B    ED 43 02D9     C              LD (WINXY),BC
  028F    20 C9          C              JR NZ,WINY1
  0291    06 08          C              LD B,LPOS
  0293    CD 03B5        C              CALL UPROG2
  0296    ED 4B 02DB     C              LD BC,(WINPOS)
  029A    04             C              INC B
  029B    78             C              LD A,B
  029C    27             C              DAA
  029D    47             C              LD B,A
  029E    ED 43 02DB     C              LD (WINPOS),BC
  02A2    CD 03AE        C              CALL UPROG      ; SET
  02A5    3A 02E5        C              LD A,(WINDO+6)  ; LEFT DOWN CORNER
  02A8    CD 02CC        C              CALL WINOUT
  02AB    ED 4B 02D9     C              LD BC,(WINXY)
  02AF    3A 02E6        C      WINX3:  LD A,(WINDO+7)  ; DOWN LINE 
  02B2    CD 02CC        C              CALL WINOUT
  02B5    10 F8          C              DJNZ WINX3
  02B7    3A 02E7        C              LD A,(WINDO+8)  ; RIGHT SIDE
  02BA    CD 02CC        C              CALL WINOUT
  02BD    06 08          C              LD B,LPOS
  02BF    CD 03B5        C              CALL UPROG2
  02C2    ED 4B 02DD     C              LD BC,(WINCHA)
  02C6    CD 03AE        C              CALL UPROG      ; SET
  02C9    E1             C              POP HL
  02CA    C1             C              POP BC
  02CB    C9             C              RET
                         C              ;-----------------
  02CC    C5             C      WINOUT: PUSH BC
  02CD    E5             C              PUSH HL
  02CE    06 01          C              LD B,KEYOUT     ; SUBROUTINE KEY CALL OUTPUT IN BLASE
  02D0    CD 03B5        C              CALL UPROG2
  02D3    CD 03AE        C              CALL UPROG
  02D6    E1             C              POP HL
  02D7    C1             C              POP BC
  02D8    C9             C              RET
  02D9    0000           C      WINXY:  DEFW 0000H
  02DB    0000           C      WINPOS: DEFW 0000H
  02DD    0000           C      WINCHA: DEFW 0000H
        MACRO-80 3.43   27-Jul-81       PAGE    1-7


  02DF    DA C4 BF       C      WINDO:  DEFB 218D,196D,191D
  02E2    B3 20 B3       C              DEFB 179D,20H,179D
  02E5    C0 C4 D9       C              DEFB 192D,196D,217D
                         C              ;-----------------
                         C      
                                        ;-----------------
  02E8    E1                    AUEND:  POP HL
  02E9    D1                            POP DE
  02EA    C1                            POP BC
                                        ;---------
                                ;!!!    CALL ESTACK     ; 
  02EB    DD F9                         LD SP,IX        ; return SP
  02ED    DD E1                         POP IX
                                        ;---------
  02EF    AF                            XOR A
  02F0    32 6B27                       LD (RAMT),A
  02F3    3E 00                         LD A,00         ; program start condition
  02F5    32 6200                       LD (BLAN),A
  02F8    C9                            RET             ; Exit program end
                                ;------------------------
                         C              INCLUDE ESTACK.MAC      ; SET ESTACK:
                         C              ;----------------
  02F9    DD E5          C      ESTACK: PUSH IX
  02FB    E1             C              POP HL
  02FC    ED 72          C              SBC HL,SP
  02FE    20 01          C              JR NZ,ERROR
  0300    C9             C              RET
  0301    38 05          C      ERROR:  JR C,ERR1
  0303    11 031B        C              LD DE,ETEX1
  0306    18 03          C              JR ERR2
  0308    11 034F        C      ERR1:   LD DE,ETEX2
  030B    E5             C      ERR2:   PUSH HL
  030C    C5             C              PUSH BC
  030D    F5             C              PUSH AF
  030E    0E 09          C              LD C,09H
  0310    CD 0005        C              CALL 0005H
  0313    F1             C              POP AF
  0314    C1             C              POP BC
  0315    E1             C              POP HL
  0316    0E 00          C              LD C,0H
  0318    C3 0000        C              JP 0
                         C              ;------------
  031B    1B 5B 32 34    C      ETEX1:  DEFB 1BH,5BH,32H,34H,3BH,30H,31H,48H    ;cursor pos.
  031F    3B 30 31 48    C      
  0323    3E 2D 2D 2D    C              DEFM '>---- Stack ERROR < IX - 0000 < FFFF ---<'
  0327    2D 20 53 74    C      
  032B    61 63 6B 20    C      
  032F    45 52 52 4F    C      
  0333    52 20 3C 20    C      
  0337    49 58 20 2D    C      
  033B    20 30 30 30    C      
  033F    30 20 3C 20    C      
  0343    46 46 46 46    C      
  0347    20 2D 2D 2D    C      
  034B    3C             C      
  034C    0A 0D          C              DEFB 0AH,0DH
        MACRO-80 3.43   27-Jul-81       PAGE    1-8


  034E    24             C              DEFM '$'
                         C      
  034F    1B 5B 32 34    C      ETEX2:  DEFB 1BH,5BH,32H,34H,3BH,30H,31H,48H    ;cursor pos.
  0353    3B 30 31 48    C      
  0357    3E 2D 2D 2D    C              DEFM '>---- Stack ERROR > IX - FFFF > 0000 ---<'
  035B    2D 20 53 74    C      
  035F    61 63 6B 20    C      
  0363    45 52 52 4F    C      
  0367    52 20 3E 20    C      
  036B    49 58 20 2D    C      
  036F    20 46 46 46    C      
  0373    46 20 3E 20    C      
  0377    30 30 30 30    C      
  037B    20 2D 2D 2D    C      
  037F    3C             C      
  0380    0A 0D          C              DEFB 0AH,0DH
  0382    24             C              DEFM '$'
                         C      
                         C      ;---------------------
                                ;-------------------------
                                        ; CURSOR OFF END FROM CHARACTER SET
  0383    C5                    CURPOS: PUSH BC
  0384    04                            INC B           ;CHARACTER LENGTH +1
  0385    3E 00                         LD A,00H        ;COUNR FROM 0
  0387    3C                    CURP1:  INC A
  0388    27                            DAA
  0389    10 FC                         DJNZ CURP1
  038B    47                            LD B,A
  038C    E6 0F                         AND 0FH
  038E    32 651F                       LD (CURT+3),A
  0391    78                            LD A,B
  0392    0F                            RRCA
  0393    0F                            RRCA
  0394    0F                            RRCA
  0395    0F                            RRCA
  0396    E6 0F                         AND 0FH
  0398    32 651E                       LD (CURT+2),A
  039B    C1                            POP BC
  039C    C9                            RET
                                        ;---------------
                                        ; give up sing in a
                                        ;
  039D    F5                    TEXOUT: PUSH AF
  039E    C5                            PUSH BC
  039F    D5                            PUSH DE
  03A0    E5                            PUSH HL
  03A1    06 01                         LD B,KEYOUT
  03A3    CD 03B5                       CALL UPROG2
  03A6    CD 03AE                       CALL UPROG
  03A9    E1                            POP HL
  03AA    D1                            POP DE
  03AB    C1                            POP BC
  03AC    F1                            POP AF
  03AD    C9                            RET
                                        ;------------
                                        ; EXECUTE PARAMETER AND JUMP BACK
        MACRO-80 3.43   27-Jul-81       PAGE    1-9


                                        ;
  03AE    D5                    UPROG:  PUSH DE         ; DE AS A BACKSPACE ADDRESS ON A STACK
  03AF    C9                            RET             ; JUMP (DE) -> WIE POP DE
                                        ;----------------
                                        ; EXECUTE PARAMETER AND JUMP BACK
                                        ;
  03B0    E5                    UPROG1: PUSH HL         ; HL AS A BACKSPACE ADDRESS ON A STACK
  03B1    21 6B27                       LD HL,RAMT
  03B4    C9                            RET             ; JUMP (HL) -> WIE POP HL       
                                        ;----------------
                                        ; LOAD THE JUMP ADDRESS IN DE
                                        ;
  03B5    E5                    UPROG2: PUSH HL
  03B6    21 7000                       LD HL,PROG
  03B9    11 0003                       LD DE,03H       ; distance 3byte jump
  03BC    19                    SUM:    ADD HL,DE
  03BD    10 FD                         DJNZ SUM
  03BF    23                            INC HL          ; Skip JP COMMAND (C3....)
  03C0    5E                            LD E,(HL)
  03C1    23                            INC HL
  03C2    56                            LD D,(HL)
  03C3    E1                            POP HL
  03C4    C9                            RET
                                        ;--------------
                                        ; earch file name begining
                                        ;
  03C5    21 6000               MASK1:  LD HL,RAM
  03C8    46                            LD B,(HL)       ; first block length header
  03C9    21 6006                       LD HL,RAM+6
  03CC    23                    MASK2:  INC HL
  03CD    10 FD                         DJNZ MASK2      ; step length
  03CF    23                    MASK3:  INC HL          ; 
  03D0    3E 1B                         LD A,1BH
  03D2    BE                            CP (HL)
  03D3    20 FA                         JR NZ,MASK3
  03D5    2B                            DEC HL          ; 
  03D6    46                            LD B,(HL)       ; to B
  03D7    04                            INC B
  03D8    7E                            LD A,(HL)
  03D9    CD 039D                       CALL TEXOUT
  03DC    23                            INC HL
  03DD    23                    MASK4:  INC HL
  03DE    10 FD                         DJNZ MASK4      ; until the text/image block end
  03E0    23                            INC HL          ; file name block beginning
  03E1    C9                            RET
                                        ;---------------
                                        ; text block output
                                        ;
  03E2    E5                    BTEX:   PUSH HL
  03E3    C5                            PUSH BC
  03E4    0E 09                         LD C,09H
  03E6    CD 0005                       CALL 0005
  03E9    C1                            POP BC
  03EA    E1                            POP HL
  03EB    C9                            RET
                                        ;----------------
        MACRO-80 3.43   27-Jul-81       PAGE    1-10


                                        ; key save
                                        ;
  03EC    E5                    COMKEY: PUSH HL
  03ED    D5                            PUSH DE
  03EE    C5                            PUSH BC
  03EF    F5                            PUSH AF
  03F0    06 09                         LD B,KEYBUF
  03F2    CD 03B5                       CALL UPROG2
  03F5    F1                            POP AF
  03F6    C1                            POP BC
  03F7    EB                            EX DE,HL        ; SPRUNADRESSE NACH HL
  03F8    D1                            POP DE  ; ADRESSDATEN ZURUECK HOLEN
  03F9    CD 03B0                       CALL UPROG1     ; RET SPRUNG VON HL
  03FC    E1                            POP HL
  03FD    C9                            RET
                                        ;-------
                                        ; key input
                                        ;
  03FE    C5                    INKEY:  PUSH BC
  03FF    D5                            PUSH DE
  0400    E5                            PUSH HL
  0401    06 02                         LD B,KEYIN
  0403    CD 03B5                       CALL UPROG2
  0406    CD 03AE                       CALL UPROG
  0409    E1                            POP HL
  040A    D1                            POP DE
  040B    C1                            POP BC
  040C    C9                            RET
                                        ;-----------------
                                        ; delete screen area
                                        ;
  040D    C5                    SDEL:   PUSH BC
  040E    D5                            PUSH DE
  040F    16 14                         LD D,14H
  0411    01 0301                       LD BC,0301H
  0414    1E 45                 SDEL1:  LD E,69D        ; loop counter line
  0416    D5                            PUSH DE
  0417    C5                            PUSH BC
  0418    06 08                         LD B,LPOS
  041A    CD 03B5                       CALL UPROG2
  041D    C1                            POP BC
  041E    CD 03AE                       CALL UPROG
  0421    D1                            POP DE
  0422    3E 20                 SDEL2:  LD A,20H
  0424    CD 039D                       CALL TEXOUT
  0427    1D                            DEC E
  0428    20 F8                         JR NZ,SDEL2
  042A    78                            LD A,B
  042B    3C                            INC A
  042C    27                            DAA
  042D    47                            LD B,A
  042E    15                            DEC D
  042F    20 E3                         JR NZ,SDEL1
  0431    D1                            POP DE
  0432    C1                            POP BC
  0433    C9                            RET
        MACRO-80 3.43   27-Jul-81       PAGE    1-11


                                ;---------------------------
                                ;
  0434    1B 5B 30 33           TTEX:   DEFB 1BH,5BH,30H,33H,3BH,30H,35H,48H    ; 
  0438    3B 30 35 48           
  043C    53 65 69 74                   DEFM 'Seite neu erstellen '
  0440    65 20 6E 65           
  0444    75 20 65 72           
  0448    73 74 65 6C           
  044C    6C 65 6E 20           
  0450    1B 5B 30 36                   DEFB 1BH,5BH,30H,36H,3BH,30H,35H,48H    ; 
  0454    3B 30 35 48           
  0458    31 3E 20 41                   DEFM '1> Aendern (Pos.Numer)'
  045C    65 6E 64 65           
  0460    72 6E 20 28           
  0464    50 6F 73 2E           
  0468    4E 75 6D 65           
  046C    72 29                 
  046E    1B 5B 30 37                   DEFB 1BH,5BH,30H,37H,3BH,30H,35H,48H    ; 
  0472    3B 30 35 48           
  0476    32 3E 20 45                   DEFM '2> Einfuegen (Pos.Numer)'
  047A    69 6E 66 75           
  047E    65 67 65 6E           
  0482    20 28 50 6F           
  0486    73 2E 4E 75           
  048A    6D 65 72 29           
  048E    1B 5B 30 38                   DEFB 1BH,5BH,30H,38H,3BH,30H,35H,48H    ; 
  0492    3B 30 35 48           
  0496    33 3E 20 42                   DEFM '3> Bildschirmtext (mit 9 speichern)'
  049A    69 6C 64 73           
  049E    63 68 69 72           
  04A2    6D 74 65 78           
  04A6    74 20 28 6D           
  04AA    69 74 20 39           
  04AE    20 73 70 65           
  04B2    69 63 68 65           
  04B6    72 6E 29              
  04B9    1B 5B 30 39                   DEFB 1BH,5BH,30H,39H,3BH,30H,35H,48H    ; 
  04BD    3B 30 35 48           
  04C1    45 43 53 3E                   DEFM 'ECS> alles verwerfen'
  04C5    20 61 6C 6C           
  04C9    65 73 20 76           
  04CD    65 72 77 65           
  04D1    72 66 65 6E           
  04D5    1B 5B 31 31                   DEFB 1BH,5BH,31H,31H,3BH,30H,31H,48H    ; 
  04D9    3B 30 31 48           
  04DD    24                            DEFM '$'        ; block output end BIOS
  04DE    2A                            DEFB 2AH
  00AB                          TTLEN   EQU $-TTEX
                                
  04DF    00 00 00 00           BF02:   DEFB 00H,00H,00H,00H
  04E3    00 00 00 00           BF03:   DEFB 00H,00H,00H,00H    
                                
  04E7    1B 5B 02 04           EBUFF:  DEFB 1BH,5BH,02H,04H,3BH,00H,01H,48H
  04EB    3B 00 01 48           
  04EF    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH
  04F3    6D                    
        MACRO-80 3.43   27-Jul-81       PAGE    1-12


  04F4    20 20 20 20                   DEFM '                             '
  04F8    20 20 20 20           
  04FC    20 20 20 20           
  0500    20 20 20 20           
  0504    20 20 20 20           
  0508    20 20 20 20           
  050C    20 20 20 20           
  0510    20                    
  002A                          EZLEN   EQU $-EBUFF
                                
  0511    1B 5B 02 04           ABUFF:  DEFB 1BH,5BH,02H,04H,3BH,00H,01H,48H
  0515    3B 00 01 48           
  0519    20 20 20 20           AUTEX:  DEFM '                             '
  051D    20 20 20 20           
  0521    20 20 20 20           
  0525    20 20 20 20           
  0529    20 20 20 20           
  052D    20 20 20 20           
  0531    20 20 20 20           
  0535    20                    
  0025                          AZLEN   EQU $-ABUFF
                                
  0536    2E 43 4F 4D           AUTO:   DEFM '.COM        '
  053A    20 20 20 20           
  053E    20 20 20 20           
  0542    0000                  FILEN:  DEFW 0000H
  0544    00                    ZEILEN: DEFB 00H
                                
                                END
        MACRO-80 3.43   27-Jul-81       PAGE    S


Macros:

Symbols:
0511    ABUFF           02E8    AUEND           0519    AUTEX           
0536    AUTO            0025    AZLEN           04DF    BF02            
04E3    BF03            6503    BFRHH           6502    BFRHL           
6501    BFRLH           6500    BFRLL           650F    BFSHH           
650E    BFSHL           650D    BFSLH           650C    BFSLL           
650B    BFVHH           650A    BFVHL           6509    BFVLH           
6508    BFVLL           6200    BLAN            6205    BSTAT           
03E2    BTEX            0080    BUFF            0020    CMD_READSEC     
0030    CMD_WRITESEC    03EC    COMKEY          6C3F    COP             
0007    CPOS            0387    CURP1           0383    CURPOS          
6518    CURS            651C    CURT            04E7    EBUFF           
0308    ERR1            030B    ERR2            0301    ERROR           
02F9    ESTACK          031B    ETEX1           034F    ETEX2           
002A    EZLEN           005C    FCB             006B    FCBCR           
005D    FCBFN           0065    FCBFT           007C    FCBRA           
0020    FDC             0126    FIL6            0133    FIL7            
0145    FIL8            0542    FILEN           0800    HDD             
00BE    HDDE            00F0    IDE             00FD    IDECHI          
00FC    IDECLO          00FF    IDECMD          00F8    IDEDAT          
00F6    IDEDOR          00F9    IDEERR          00FA    IDESCNT         
00FE    IDESDH          00FB    IDESNUM         00FF    IDESTAT         
03FE    INKEY           0185    KEY1            01B0    KEY2            
01C9    KEY7            01F4    KEY8            0218    KEY9            
0009    KEYBUF          0002    KEYIN           0001    KEYOUT          
0060    LCD             6513    LOGHH           6512    LOGHL           
6511    LOGLH           6510    LOGLL           0008    LPOS            
03C5    MASK1           03CC    MASK2           03CF    MASK3           
03DD    MASK4           A101    MMC             0007    MMCE            
001E    PIOB            7000    PROG            0005    P_READ          
0006    P_WRITE         6524    RADR            6000    RAM             
6727    RAMS            6B27    RAMT            6527    RAMV            
0000    RBLAN           0005    RBSTAT          6526    RMEN            
0006    RSOTR           0004    RTERM           6BEF    RTEX            
0002    RTYPE1          0003    RTYPE2          0001    RUSER           
6520    SANDB           040D    SDEL            0414    SDEL1           
0422    SDEL2           0004    SELDM           00F7    SELDS           
01D6    SUCHD           01EA    SUCHE           03BC    SUM             
6204    TERM            0169    TEXIN           039D    TEXOUT          
0434    TTEX            00AB    TTLEN           6202    TYPE1           
6203    TYPE2           03AE    UPROG           03B0    UPROG1          
03B5    UPROG2          0080    URCS            6201    USER            
02DD    WINCHA          02DF    WINDO           0227    WINDOW          
02CC    WINOUT          02DB    WINPOS          024C    WINX1           
0278    WINX2           02AF    WINX3           02D9    WINXY           
025A    WINY1           0544    ZEILEN          



No Fatal error(s)


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
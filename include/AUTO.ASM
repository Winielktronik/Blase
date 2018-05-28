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
  0110    CD 03C0                       CALL MASK1
                                        ;
                                        ; from here issue
                                        ;
  0113    C5                            PUSH BC
  0114    06 08                         LD B,LPOS
  0116    CD 03B0                       CALL UPROG2
  0119    01 0471                       LD BC,0471H
  011C    ED 43 053D                    LD (FILEN),BC
  0120    CD 03A9                       CALL UPROG
  0123    C1                            POP BC
  0124    3E 31                         LD A,'1'
  0126    32 053F               FIL6:   LD (ZEILEN),A
  0129    CD 0398                       CALL TEXOUT
  012C    3E 20                         LD A,' '
  012E    CD 0398                       CALL TEXOUT
  0131    06 0C                         LD B,0CH
  0133    7E                    FIL7:   LD A,(HL)
  0134    FE 00                         CP 00H
  0136    28 31                         JR Z,TEXIN
  0138    CD 0398                       CALL TEXOUT
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
  014C    CD 03B0                       CALL UPROG2
  014F    ED 4B 053D                    LD BC,(FILEN)
  0153    04                            INC B
  0154    ED 43 053D                    LD (FILEN),BC
  0158    CD 03A9                       CALL UPROG
  015B    C1                            POP BC
  015C    7E                            LD A,(HL)
  015D    FE 00                         CP 00H
  015F    28 08                         JR Z,TEXIN
  0161    3A 053F                       LD A,(ZEILEN)
  0164    3C                            INC A
  0165    E5                            PUSH HL         ; SWAP HL->DE
  0166    D1                            POP DE
  0167    18 BD                         JR FIL6         
                                        ;--------------------
                                        ; SET CURSOR ON START POSITION
                                        ;
  0169    CD 0408               TEXIN:  CALL SDEL
  016C    11 042F                       LD DE,TTEX
  016F    CD 03DD                       CALL BTEX       ; text block TTEX output
  0172    01 1110                       LD BC,1110H     ; positon 
  0175    21 0E01                       LD HL,0E01H     ; length Width 
  0178    CD 0222                       CALL WINDOW
                                        ;--------------
                                        ; TEXT input
                                        ;
  017B    11 0531                       LD DE,AUTO
  017E    06 08                         LD B,08H        ; input character length (file) name.
  0180    C5                    KEY1:   PUSH BC
  0181    D5                            PUSH DE
  0182    E5                            PUSH HL
  0183    CD 03F9                       CALL INKEY
  0186    E1                            POP HL
  0187    D1                            POP DE
  0188    C1                            POP BC
  0189    FE 00                         CP 0
  018B    28 F3                         JR Z,KEY1
  018D    CD 03E7                       CALL COMKEY
  0190    FE 0D                         CP 0DH
  0192    28 17                         JR Z,KEY2
  0194    D5                            PUSH DE
  0195    3E 2E                         LD A,'.'
  0197    12                            LD (DE),A
  0198    13                            INC DE
  0199    3E 43                         LD A,'C'
  019B    12                            LD (DE),A
  019C    13                            INC DE
        MACRO-80 3.43   27-Jul-81       PAGE    1-4


  019D    3E 4F                         LD A,'O'
  019F    12                            LD (DE),A
  01A0    13                            INC DE
  01A1    3E 4D                         LD A,'M'
  01A3    12                            LD (DE),A
  01A4    13                            INC DE 
  01A5    3E 20                         LD A,' '
  01A7    12                            LD (DE),A
  01A8    D1                            POP DE
  01A9    18 D5                         JR KEY1
                                        ;--------------
                                        ; search image output
                                        ;
  01AB    CD 03C0               KEY2:   CALL MASK1
                                        ;
                                        ; from here issue
                                        ;
  01AE    C5                            PUSH BC
  01AF    06 08                         LD B,LPOS
  01B1    CD 03B0                       CALL UPROG2
  01B4    01 0471                       LD BC,0471H
  01B7    ED 43 053D                    LD (FILEN),BC
  01BB    CD 03A9                       CALL UPROG
  01BE    C1                            POP BC
  01BF    11 0531                       LD DE,AUTO
  01C2    3E 31                         LD A,'1'
  01C4    32 053F               KEY7:   LD (ZEILEN),A
  01C7    CD 0398                       CALL TEXOUT
  01CA    3E 20                         LD A,' '
  01CC    CD 0398                       CALL TEXOUT
  01CF    06 0C                         LD B,0CH
  01D1    1A                    SUCHD:  LD A,(DE)
  01D2    FE 00                         CP 00H
  01D4    28 3D                         JR Z,KEY9
  01D6    77                            LD (HL),A       
  01D7    CD 0398                       CALL TEXOUT
  01DA    13                            INC DE
  01DB    23                            INC HL
  01DC    1A                            LD A,(DE)
  01DD    FE 2E                         CP '.'
  01DF    28 04                         JR Z,SUCHE      ; ->continue without issue
  01E1    10 EE                         DJNZ SUCHD
  01E3    18 2E                         JR KEY9
                                        ;------------
  01E5    1A                    SUCHE:  LD A,(DE)
  01E6    77                            LD (HL),A
  01E7    FE 00                         CP 00H
  01E9    28 04                         JR Z,KEY8
  01EB    13                            INC DE
  01EC    23                            INC HL
  01ED    10 F6                         DJNZ SUCHE
                                        ;!!! JR KEY9
                                        ;------------
  01EF    05                    KEY8:   DEC B
  01F0    23                            INC HL
  01F1    10 FD                         DJNZ KEY8+1
        MACRO-80 3.43   27-Jul-81       PAGE    1-5


  01F3    C5                            PUSH BC
  01F4    06 08                         LD B,LPOS
  01F6    CD 03B0                       CALL UPROG2
  01F9    ED 4B 053D                    LD BC,(FILEN)
  01FD    04                            INC B
  01FE    ED 43 053D                    LD (FILEN),BC
  0202    CD 03A9                       CALL UPROG
  0205    C1                            POP BC
  0206    7E                            LD A,(HL)
  0207    FE 00                         CP 00H
  0209    28 08                         JR Z,KEY9
  020B    3A 053F                       LD A,(ZEILEN)
  020E    3C                            INC A
  020F    E5                            PUSH HL         ; SWAP HL->DE
  0210    D1                            POP DE
  0211    18 B1                         JR KEY7         
                                        ;--------------
  0213    06 02                 KEY9:   LD B,KEYIN
  0215    CD 03B0                       CALL UPROG2
  0218    CD 03A9                       CALL UPROG
  021B    FE 00                         CP 0
  021D    28 F4                         JR Z,KEY9       ; press key for end
  021F    C3 02E3                       JP AUEND
                                        ;------------------
                         C              INCLUDE RAHMEN.MAC      ; SET WINDOW:
                         C              ;----------------
  0222    22 02D4        C      WINDOW: LD (WINXY),HL   ; WINDOW X,Y
  0225    ED 43 02D6     C              LD (WINPOS),BC  ; STARTPOS X,Y
  0229    C5             C              PUSH BC         ; =X,Y POSITION 
  022A    E5             C              PUSH HL         ; =X,Y LAENGE
  022B    04             C              INC B
  022C    0C             C              INC C
  022D    ED 43 02D8     C              LD (WINCHA),BC  ; for pos in windows
  0231    06 08          C              LD B,LPOS       ; SUBROUTINE CALL CURSOR IN BLASE ON POSITION
  0233    CD 03B0        C              CALL UPROG2
  0236    ED 4B 02D6     C              LD BC,(WINPOS)
  023A    CD 03A9        C              CALL UPROG
                         C              ;----------------
                         C              ; START WINDOW
                         C              ;
  023D    3A 02DA        C              LD A,(WINDO)    ; LEFT UP CORNER
  0240    CD 02C7        C              CALL WINOUT
  0243    ED 4B 02D4     C              LD BC,(WINXY)   ; LOAD X
  0247    3A 02DB        C      WINX1:  LD A,(WINDO+1)  ; UP X LINE
  024A    CD 02C7        C              CALL WINOUT
  024D    10 F8          C              DJNZ WINX1
  024F    3A 02DC        C              LD A,(WINDO+2)  ; RIGHT UP CORNER
  0252    CD 02C7        C              CALL WINOUT
                         C              ;----------------OK.
                         C              ; NEW LINE
                         C              ;
  0255    06 08          C      WINY1:  LD B,LPOS       ; BIOS BLASE
  0257    CD 03B0        C              CALL UPROG2
  025A    ED 4B 02D6     C              LD BC,(WINPOS)
  025E    04             C              INC B
  025F    78             C              LD A,B
        MACRO-80 3.43   27-Jul-81       PAGE    1-6


  0260    27             C              DAA
  0261    47             C              LD B,A
  0262    ED 43 02D6     C              LD (WINPOS),BC
  0266    CD 03A9        C              CALL UPROG      ; SET
  0269    3A 02DD        C              LD A,(WINDO+3)  ; LEFT SIDE
  026C    CD 02C7        C              CALL WINOUT
                         C              ;----------------
  026F    ED 4B 02D4     C              LD BC,(WINXY)
  0273    3A 02DE        C      WINX2:  LD A,(WINDO+4)  ; SPACE 
  0276    CD 02C7        C              CALL WINOUT
  0279    10 F8          C              DJNZ WINX2
  027B    3A 02DF        C              LD A,(WINDO+5)  ; RIGHT SIDE
  027E    CD 02C7        C              CALL WINOUT
  0281    ED 4B 02D4     C              LD BC,(WINXY)
  0285    0D             C              DEC C
  0286    ED 43 02D4     C              LD (WINXY),BC
  028A    20 C9          C              JR NZ,WINY1
  028C    06 08          C              LD B,LPOS
  028E    CD 03B0        C              CALL UPROG2
  0291    ED 4B 02D6     C              LD BC,(WINPOS)
  0295    04             C              INC B
  0296    78             C              LD A,B
  0297    27             C              DAA
  0298    47             C              LD B,A
  0299    ED 43 02D6     C              LD (WINPOS),BC
  029D    CD 03A9        C              CALL UPROG      ; SET
  02A0    3A 02E0        C              LD A,(WINDO+6)  ; LEFT DOWN CORNER
  02A3    CD 02C7        C              CALL WINOUT
  02A6    ED 4B 02D4     C              LD BC,(WINXY)
  02AA    3A 02E1        C      WINX3:  LD A,(WINDO+7)  ; DOWN LINE 
  02AD    CD 02C7        C              CALL WINOUT
  02B0    10 F8          C              DJNZ WINX3
  02B2    3A 02E2        C              LD A,(WINDO+8)  ; RIGHT SIDE
  02B5    CD 02C7        C              CALL WINOUT
  02B8    06 08          C              LD B,LPOS
  02BA    CD 03B0        C              CALL UPROG2
  02BD    ED 4B 02D8     C              LD BC,(WINCHA)
  02C1    CD 03A9        C              CALL UPROG      ; SET
  02C4    E1             C              POP HL
  02C5    C1             C              POP BC
  02C6    C9             C              RET
                         C              ;-----------------
  02C7    C5             C      WINOUT: PUSH BC
  02C8    E5             C              PUSH HL
  02C9    06 01          C              LD B,KEYOUT     ; SUBROUTINE KEY CALL OUTPUT IN BLASE
  02CB    CD 03B0        C              CALL UPROG2
  02CE    CD 03A9        C              CALL UPROG
  02D1    E1             C              POP HL
  02D2    C1             C              POP BC
  02D3    C9             C              RET
  02D4    0000           C      WINXY:  DEFW 0000H
  02D6    0000           C      WINPOS: DEFW 0000H
  02D8    0000           C      WINCHA: DEFW 0000H
  02DA    DA C4 BF       C      WINDO:  DEFB 218D,196D,191D
  02DD    B3 20 B3       C              DEFB 179D,20H,179D
  02E0    C0 C4 D9       C              DEFB 192D,196D,217D
        MACRO-80 3.43   27-Jul-81       PAGE    1-7


                         C              ;-----------------
                         C      
                                        ;-----------------
  02E3    E1                    AUEND:  POP HL
  02E4    D1                            POP DE
  02E5    C1                            POP BC
                                        ;---------
                                ;!!!    CALL ESTACK     ; 
  02E6    DD F9                         LD SP,IX        ; return SP
  02E8    DD E1                         POP IX
                                        ;---------
  02EA    AF                            XOR A
  02EB    32 6B27                       LD (RAMT),A
  02EE    3E 00                         LD A,00         ; program start condition
  02F0    32 6200                       LD (BLAN),A
  02F3    C9                            RET             ; Exit program end
                                ;------------------------
                         C              INCLUDE ESTACK.MAC      ; SET ESTACK:
                         C              ;----------------
  02F4    DD E5          C      ESTACK: PUSH IX
  02F6    E1             C              POP HL
  02F7    ED 72          C              SBC HL,SP
  02F9    20 01          C              JR NZ,ERROR
  02FB    C9             C              RET
  02FC    38 05          C      ERROR:  JR C,ERR1
  02FE    11 0316        C              LD DE,ETEX1
  0301    18 03          C              JR ERR2
  0303    11 034A        C      ERR1:   LD DE,ETEX2
  0306    E5             C      ERR2:   PUSH HL
  0307    C5             C              PUSH BC
  0308    F5             C              PUSH AF
  0309    0E 09          C              LD C,09H
  030B    CD 0005        C              CALL 0005H
  030E    F1             C              POP AF
  030F    C1             C              POP BC
  0310    E1             C              POP HL
  0311    0E 00          C              LD C,0H
  0313    C3 0000        C              JP 0
                         C              ;------------
  0316    1B 5B 32 34    C      ETEX1:  DEFB 1BH,5BH,32H,34H,3BH,30H,31H,48H    ;cursor pos.
  031A    3B 30 31 48    C      
  031E    3E 2D 2D 2D    C              DEFM '>---- Stack ERROR < IX - 0000 < FFFF ---<'
  0322    2D 20 53 74    C      
  0326    61 63 6B 20    C      
  032A    45 52 52 4F    C      
  032E    52 20 3C 20    C      
  0332    49 58 20 2D    C      
  0336    20 30 30 30    C      
  033A    30 20 3C 20    C      
  033E    46 46 46 46    C      
  0342    20 2D 2D 2D    C      
  0346    3C             C      
  0347    0A 0D          C              DEFB 0AH,0DH
  0349    24             C              DEFM '$'
                         C      
  034A    1B 5B 32 34    C      ETEX2:  DEFB 1BH,5BH,32H,34H,3BH,30H,31H,48H    ;cursor pos.
        MACRO-80 3.43   27-Jul-81       PAGE    1-8


  034E    3B 30 31 48    C      
  0352    3E 2D 2D 2D    C              DEFM '>---- Stack ERROR > IX - FFFF > 0000 ---<'
  0356    2D 20 53 74    C      
  035A    61 63 6B 20    C      
  035E    45 52 52 4F    C      
  0362    52 20 3E 20    C      
  0366    49 58 20 2D    C      
  036A    20 46 46 46    C      
  036E    46 20 3E 20    C      
  0372    30 30 30 30    C      
  0376    20 2D 2D 2D    C      
  037A    3C             C      
  037B    0A 0D          C              DEFB 0AH,0DH
  037D    24             C              DEFM '$'
                         C      
                         C      ;---------------------
                                ;-------------------------
                                        ; CURSOR OFF END FROM CHARACTER SET
  037E    C5                    CURPOS: PUSH BC
  037F    04                            INC B           ;CHARACTER LENGTH +1
  0380    3E 00                         LD A,00H        ;COUNR FROM 0
  0382    3C                    CURP1:  INC A
  0383    27                            DAA
  0384    10 FC                         DJNZ CURP1
  0386    47                            LD B,A
  0387    E6 0F                         AND 0FH
  0389    32 651F                       LD (CURT+3),A
  038C    78                            LD A,B
  038D    0F                            RRCA
  038E    0F                            RRCA
  038F    0F                            RRCA
  0390    0F                            RRCA
  0391    E6 0F                         AND 0FH
  0393    32 651E                       LD (CURT+2),A
  0396    C1                            POP BC
  0397    C9                            RET
                                        ;---------------
                                        ; give up sing in a
                                        ;
  0398    F5                    TEXOUT: PUSH AF
  0399    C5                            PUSH BC
  039A    D5                            PUSH DE
  039B    E5                            PUSH HL
  039C    06 01                         LD B,KEYOUT
  039E    CD 03B0                       CALL UPROG2
  03A1    CD 03A9                       CALL UPROG
  03A4    E1                            POP HL
  03A5    D1                            POP DE
  03A6    C1                            POP BC
  03A7    F1                            POP AF
  03A8    C9                            RET
                                        ;------------
                                        ; EXECUTE PARAMETER AND JUMP BACK
                                        ;
  03A9    D5                    UPROG:  PUSH DE         ; DE AS A BACKSPACE ADDRESS ON A STACK
  03AA    C9                            RET             ; JUMP (DE) -> WIE POP DE
        MACRO-80 3.43   27-Jul-81       PAGE    1-9


                                        ;----------------
                                        ; EXECUTE PARAMETER AND JUMP BACK
                                        ;
  03AB    E5                    UPROG1: PUSH HL         ; HL AS A BACKSPACE ADDRESS ON A STACK
  03AC    21 6B27                       LD HL,RAMT
  03AF    C9                            RET             ; JUMP (HL) -> WIE POP HL       
                                        ;----------------
                                        ; LOAD THE JUMP ADDRESS IN DE
                                        ;
  03B0    E5                    UPROG2: PUSH HL
  03B1    21 7000                       LD HL,PROG
  03B4    11 0003                       LD DE,03H       ; distance 3byte jump
  03B7    19                    SUM:    ADD HL,DE
  03B8    10 FD                         DJNZ SUM
  03BA    23                            INC HL          ; Skip JP COMMAND (C3....)
  03BB    5E                            LD E,(HL)
  03BC    23                            INC HL
  03BD    56                            LD D,(HL)
  03BE    E1                            POP HL
  03BF    C9                            RET
                                        ;--------------
                                        ; earch file name begining
                                        ;
  03C0    21 6000               MASK1:  LD HL,RAM
  03C3    46                            LD B,(HL)       ; first block length header
  03C4    21 6006                       LD HL,RAM+6
  03C7    23                    MASK2:  INC HL
  03C8    10 FD                         DJNZ MASK2      ; step length
  03CA    23                    MASK3:  INC HL          ; 
  03CB    3E 1B                         LD A,1BH
  03CD    BE                            CP (HL)
  03CE    20 FA                         JR NZ,MASK3
  03D0    2B                            DEC HL          ; 
  03D1    46                            LD B,(HL)       ; to B
  03D2    04                            INC B
  03D3    7E                            LD A,(HL)
  03D4    CD 0398                       CALL TEXOUT
  03D7    23                            INC HL
  03D8    23                    MASK4:  INC HL
  03D9    10 FD                         DJNZ MASK4      ; until the text/image block end
  03DB    23                            INC HL          ; file name block beginning
  03DC    C9                            RET
                                        ;---------------
                                        ; text block output
                                        ;
  03DD    E5                    BTEX:   PUSH HL
  03DE    C5                            PUSH BC
  03DF    0E 09                         LD C,09H
  03E1    CD 0005                       CALL 0005
  03E4    C1                            POP BC
  03E5    E1                            POP HL
  03E6    C9                            RET
                                        ;----------------
                                        ; key save
                                        ;
  03E7    E5                    COMKEY: PUSH HL
        MACRO-80 3.43   27-Jul-81       PAGE    1-10


  03E8    D5                            PUSH DE
  03E9    C5                            PUSH BC
  03EA    F5                            PUSH AF
  03EB    06 09                         LD B,KEYBUF
  03ED    CD 03B0                       CALL UPROG2
  03F0    F1                            POP AF
  03F1    C1                            POP BC
  03F2    EB                            EX DE,HL        ; SPRUNADRESSE NACH HL
  03F3    D1                            POP DE  ; ADRESSDATEN ZURUECK HOLEN
  03F4    CD 03AB                       CALL UPROG1     ; RET SPRUNG VON HL
  03F7    E1                            POP HL
  03F8    C9                            RET
                                        ;-------
                                        ; key input
                                        ;
  03F9    C5                    INKEY:  PUSH BC
  03FA    D5                            PUSH DE
  03FB    E5                            PUSH HL
  03FC    06 02                         LD B,KEYIN
  03FE    CD 03B0                       CALL UPROG2
  0401    CD 03A9                       CALL UPROG
  0404    E1                            POP HL
  0405    D1                            POP DE
  0406    C1                            POP BC
  0407    C9                            RET
                                        ;-----------------
                                        ; delete screen area
                                        ;
  0408    C5                    SDEL:   PUSH BC
  0409    D5                            PUSH DE
  040A    16 14                         LD D,14H
  040C    01 0301                       LD BC,0301H
  040F    1E 45                 SDEL1:  LD E,69D        ; loop counter line
  0411    D5                            PUSH DE
  0412    C5                            PUSH BC
  0413    06 08                         LD B,LPOS
  0415    CD 03B0                       CALL UPROG2
  0418    C1                            POP BC
  0419    CD 03A9                       CALL UPROG
  041C    D1                            POP DE
  041D    3E 20                 SDEL2:  LD A,20H
  041F    CD 0398                       CALL TEXOUT
  0422    1D                            DEC E
  0423    20 F8                         JR NZ,SDEL2
  0425    78                            LD A,B
  0426    3C                            INC A
  0427    27                            DAA
  0428    47                            LD B,A
  0429    15                            DEC D
  042A    20 E3                         JR NZ,SDEL1
  042C    D1                            POP DE
  042D    C1                            POP BC
  042E    C9                            RET
                                ;---------------------------
                                ;
  042F    1B 5B 30 33           TTEX:   DEFB 1BH,5BH,30H,33H,3BH,30H,35H,48H    ; 
        MACRO-80 3.43   27-Jul-81       PAGE    1-11


  0433    3B 30 35 48           
  0437    53 65 69 74                   DEFM 'Seite neu erstellen '
  043B    65 20 6E 65           
  043F    75 20 65 72           
  0443    73 74 65 6C           
  0447    6C 65 6E 20           
  044B    1B 5B 30 36                   DEFB 1BH,5BH,30H,36H,3BH,30H,35H,48H    ; 
  044F    3B 30 35 48           
  0453    31 3E 20 41                   DEFM '1> Aendern (Pos.Numer)'
  0457    65 6E 64 65           
  045B    72 6E 20 28           
  045F    50 6F 73 2E           
  0463    4E 75 6D 65           
  0467    72 29                 
  0469    1B 5B 30 37                   DEFB 1BH,5BH,30H,37H,3BH,30H,35H,48H    ; 
  046D    3B 30 35 48           
  0471    32 3E 20 45                   DEFM '2> Einfuegen (Pos.Numer)'
  0475    69 6E 66 75           
  0479    65 67 65 6E           
  047D    20 28 50 6F           
  0481    73 2E 4E 75           
  0485    6D 65 72 29           
  0489    1B 5B 30 38                   DEFB 1BH,5BH,30H,38H,3BH,30H,35H,48H    ; 
  048D    3B 30 35 48           
  0491    33 3E 20 42                   DEFM '3> Bildschirmtext (mit 9 speichern)'
  0495    69 6C 64 73           
  0499    63 68 69 72           
  049D    6D 74 65 78           
  04A1    74 20 28 6D           
  04A5    69 74 20 39           
  04A9    20 73 70 65           
  04AD    69 63 68 65           
  04B1    72 6E 29              
  04B4    1B 5B 30 39                   DEFB 1BH,5BH,30H,39H,3BH,30H,35H,48H    ; 
  04B8    3B 30 35 48           
  04BC    45 43 53 3E                   DEFM 'ECS> alles verwerfen'
  04C0    20 61 6C 6C           
  04C4    65 73 20 76           
  04C8    65 72 77 65           
  04CC    72 66 65 6E           
  04D0    1B 5B 31 31                   DEFB 1BH,5BH,31H,31H,3BH,30H,31H,48H    ; 
  04D4    3B 30 31 48           
  04D8    24                            DEFM '$'        ; block output end BIOS
  04D9    2A                            DEFB 2AH
  00AB                          TTLEN   EQU $-TTEX
                                
  04DA    00 00 00 00           BF02:   DEFB 00H,00H,00H,00H
  04DE    00 00 00 00           BF03:   DEFB 00H,00H,00H,00H    
                                
  04E2    1B 5B 02 04           EBUFF:  DEFB 1BH,5BH,02H,04H,3BH,00H,01H,48H
  04E6    3B 00 01 48           
  04EA    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH
  04EE    6D                    
  04EF    20 20 20 20                   DEFM '                             '
  04F3    20 20 20 20           
  04F7    20 20 20 20           
        MACRO-80 3.43   27-Jul-81       PAGE    1-12


  04FB    20 20 20 20           
  04FF    20 20 20 20           
  0503    20 20 20 20           
  0507    20 20 20 20           
  050B    20                    
  002A                          EZLEN   EQU $-EBUFF
                                
  050C    1B 5B 02 04           ABUFF:  DEFB 1BH,5BH,02H,04H,3BH,00H,01H,48H
  0510    3B 00 01 48           
  0514    20 20 20 20           AUTEX:  DEFM '                             '
  0518    20 20 20 20           
  051C    20 20 20 20           
  0520    20 20 20 20           
  0524    20 20 20 20           
  0528    20 20 20 20           
  052C    20 20 20 20           
  0530    20                    
  0025                          AZLEN   EQU $-ABUFF
                                
  0531    2E 43 4F 4D           AUTO:   DEFM '.COM        '
  0535    20 20 20 20           
  0539    20 20 20 20           
  053D    0000                  FILEN:  DEFW 0000H
  053F    00                    ZEILEN: DEFB 00H
                                
                                END
        MACRO-80 3.43   27-Jul-81       PAGE    S


Macros:

Symbols:
050C    ABUFF           02E3    AUEND           0514    AUTEX           
0531    AUTO            0025    AZLEN           04DA    BF02            
04DE    BF03            6503    BFRHH           6502    BFRHL           
6501    BFRLH           6500    BFRLL           650F    BFSHH           
650E    BFSHL           650D    BFSLH           650C    BFSLL           
650B    BFVHH           650A    BFVHL           6509    BFVLH           
6508    BFVLL           6200    BLAN            6205    BSTAT           
03DD    BTEX            0080    BUFF            0020    CMD_READSEC     
0030    CMD_WRITESEC    03E7    COMKEY          6C3F    COP             
0007    CPOS            0382    CURP1           037E    CURPOS          
6518    CURS            651C    CURT            04E2    EBUFF           
0303    ERR1            0306    ERR2            02FC    ERROR           
02F4    ESTACK          0316    ETEX1           034A    ETEX2           
002A    EZLEN           005C    FCB             006B    FCBCR           
005D    FCBFN           0065    FCBFT           007C    FCBRA           
0020    FDC             0126    FIL6            0133    FIL7            
0145    FIL8            053D    FILEN           0800    HDD             
00BE    HDDE            00F0    IDE             00FD    IDECHI          
00FC    IDECLO          00FF    IDECMD          00F8    IDEDAT          
00F6    IDEDOR          00F9    IDEERR          00FA    IDESCNT         
00FE    IDESDH          00FB    IDESNUM         00FF    IDESTAT         
03F9    INKEY           0180    KEY1            01AB    KEY2            
01C4    KEY7            01EF    KEY8            0213    KEY9            
0009    KEYBUF          0002    KEYIN           0001    KEYOUT          
0060    LCD             6513    LOGHH           6512    LOGHL           
6511    LOGLH           6510    LOGLL           0008    LPOS            
03C0    MASK1           03C7    MASK2           03CA    MASK3           
03D8    MASK4           A101    MMC             0007    MMCE            
001E    PIOB            7000    PROG            0005    P_READ          
0006    P_WRITE         6524    RADR            6000    RAM             
6727    RAMS            6B27    RAMT            6527    RAMV            
0000    RBLAN           0005    RBSTAT          6526    RMEN            
0006    RSOTR           0004    RTERM           6BEF    RTEX            
0002    RTYPE1          0003    RTYPE2          0001    RUSER           
6520    SANDB           0408    SDEL            040F    SDEL1           
041D    SDEL2           0004    SELDM           00F7    SELDS           
01D1    SUCHD           01E5    SUCHE           03B7    SUM             
6204    TERM            0169    TEXIN           0398    TEXOUT          
042F    TTEX            00AB    TTLEN           6202    TYPE1           
6203    TYPE2           03A9    UPROG           03AB    UPROG1          
03B0    UPROG2          0080    URCS            6201    USER            
02D8    WINCHA          02DA    WINDO           0222    WINDOW          
02C7    WINOUT          02D6    WINPOS          0247    WINX1           
0273    WINX2           02AA    WINX3           02D4    WINXY           
0255    WINY1           053F    ZEILEN          



No Fatal error(s)


                                             2           02B1    WINX3           02DB    WINXY           
025C    WINY1           0549    ZEILEN          



No Fatal error(s)


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
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
  0110    CD 0361                       CALL MASK1
  0113    CD 037E                       CALL MENU       ; menu right output
  0116    3E 00                         LD A,00
  0118    32 0686                       LD (ZEILEN),A
                                        ;
                                        ;--------------------
                                        ; SET CURSOR ON START POSITION
                                        ;
  011B    CD 045B               TEXIN:  CALL SDEL
  011E    11 0489                       LD DE,TTEX
  0121    CD 03D1                       CALL BTEX       ; text block TTEX output
  0124    11 0599                       LD DE,MTEX
  0127    CD 03D1                       CALL BTEX       ; text block TTEX output
  012A    C5                    TEXIN1: PUSH BC
  012B    D5                            PUSH DE
  012C    E5                            PUSH HL
  012D    CD 0445                       CALL INKEY
  0130    E1                            POP HL
  0131    D1                            POP DE
  0132    C1                            POP BC
  0133    FE 00                         CP 0
  0135    28 F3                         JR Z,TEXIN1
  0137    FE 1B                         CP 1BH
  0139    CA 0284                       JP Z,AUEND
  013C    F5                            PUSH AF
        MACRO-80 3.43   27-Jul-81       PAGE    1-3


  013D    CD 0454                       CALL DELK
  0140    F1                            POP AF
  0141    FE 31                         CP 31H          ; <1
  0143    38 E5                         JR C,TEXIN1
  0145    FE 35                         CP 35H          ; >4
  0147    30 E1                         JR NC,TEXIN1
                                ; AUSWERTUNG KEY
  0149    01 3333                       LD BC,3333H     ; B=H , C=V
  014C    CD 03E2                       CALL COLM
  014F    11 0489                       LD DE,TTEX
  0152    CD 03D1                       CALL BTEX       ; text block TTEX output
  0155    11 05D2                       LD DE,NRMENU
  0158    CD 03D1                       CALL BTEX       ; text block TTEX output
  015B    CD 0445               LOOP1:  CALL INKEY
  015E    FE 00                         CP 0
  0160    28 F9                         JR Z,LOOP1      
  0162    01 1605                       LD BC,1605H     ; positon 
  0165    21 0E01                       LD HL,0E01H     ; length Width 
  0168    CD 01C3                       CALL WINDOW
                                        ;--------------
                                        ; TEXT input
                                        ;
  016B    21 6B27                       LD HL,RAMT
  016E    AF                            XOR A
  016F    77                            LD (HL),A
  0170    11 0678                       LD DE,AUTO
  0173    06 08                         LD B,08H        ; input character length (file) name.
  0175    C5                    KEY1:   PUSH BC
  0176    D5                            PUSH DE
  0177    E5                            PUSH HL
  0178    CD 0445                       CALL INKEY
  017B    E1                            POP HL
  017C    D1                            POP DE
  017D    C1                            POP BC
  017E    FE 00                         CP 0
  0180    28 F3                         JR Z,KEY1
  0182    CD 0433                       CALL COMKEY
  0185    FE 0D                         CP 0DH
  0187    28 17                         JR Z,KEY2
  0189    D5                            PUSH DE
  018A    3E 2E                         LD A,'.'
  018C    12                            LD (DE),A
  018D    13                            INC DE
  018E    3E 43                         LD A,'C'
  0190    12                            LD (DE),A
  0191    13                            INC DE
  0192    3E 4F                         LD A,'O'
  0194    12                            LD (DE),A
  0195    13                            INC DE
  0196    3E 4D                         LD A,'M'
  0198    12                            LD (DE),A
  0199    13                            INC DE 
  019A    3E 20                         LD A,' '
  019C    12                            LD (DE),A
  019D    D1                            POP DE
  019E    18 D5                         JR KEY1
        MACRO-80 3.43   27-Jul-81       PAGE    1-4


                                        ;--------------
                                        ; search image output
                                        ;
  01A0    CD 0361               KEY2:   CALL MASK1 ; HIER DANN DIE MENU SELECT 1,2,3,4 UEBER (ZEILEN)
                                        ;
                                        ;--------------
  01A3    06 0C                         LD B,0CH
  01A5    11 0678                       LD DE,AUTO
  01A8    1A                    KEY7:   LD A,(DE)
  01A9    77                            LD (HL),A
  01AA    13                            INC DE
  01AB    23                            INC HL
  01AC    10 FA                         DJNZ KEY7
  01AE    CD 0361                       CALL MASK1
  01B1    CD 037E                       CALL MENU       ; menu right output
                                        ;--------------
  01B4    06 02                 KEY9:   LD B,KEYIN
  01B6    CD 0351                       CALL UPROG2
  01B9    CD 034A                       CALL UPROG
  01BC    FE 00                         CP 0
  01BE    28 F4                         JR Z,KEY9       ; press key for end
  01C0    C3 0284                       JP AUEND
                                        ;------------------
                         C              INCLUDE RAHMEN.MAC      ; SET WINDOW:
                         C              ;----------------
  01C3    22 0275        C      WINDOW: LD (WINXY),HL   ; WINDOW X,Y
  01C6    ED 43 0277     C              LD (WINPOS),BC  ; STARTPOS X,Y
  01CA    C5             C              PUSH BC         ; =X,Y POSITION 
  01CB    E5             C              PUSH HL         ; =X,Y LAENGE
  01CC    04             C              INC B
  01CD    0C             C              INC C
  01CE    ED 43 0279     C              LD (WINCHA),BC  ; for pos in windows
  01D2    06 08          C              LD B,LPOS       ; SUBROUTINE CALL CURSOR IN BLASE ON POSITION
  01D4    CD 0351        C              CALL UPROG2
  01D7    ED 4B 0277     C              LD BC,(WINPOS)
  01DB    CD 034A        C              CALL UPROG
                         C              ;----------------
                         C              ; START WINDOW
                         C              ;
  01DE    3A 027B        C              LD A,(WINDO)    ; LEFT UP CORNER
  01E1    CD 0268        C              CALL WINOUT
  01E4    ED 4B 0275     C              LD BC,(WINXY)   ; LOAD X
  01E8    3A 027C        C      WINX1:  LD A,(WINDO+1)  ; UP X LINE
  01EB    CD 0268        C              CALL WINOUT
  01EE    10 F8          C              DJNZ WINX1
  01F0    3A 027D        C              LD A,(WINDO+2)  ; RIGHT UP CORNER
  01F3    CD 0268        C              CALL WINOUT
                         C              ;----------------OK.
                         C              ; NEW LINE
                         C              ;
  01F6    06 08          C      WINY1:  LD B,LPOS       ; BIOS BLASE
  01F8    CD 0351        C              CALL UPROG2
  01FB    ED 4B 0277     C              LD BC,(WINPOS)
  01FF    04             C              INC B
  0200    78             C              LD A,B
  0201    27             C              DAA
        MACRO-80 3.43   27-Jul-81       PAGE    1-5


  0202    47             C              LD B,A
  0203    ED 43 0277     C              LD (WINPOS),BC
  0207    CD 034A        C              CALL UPROG      ; SET
  020A    3A 027E        C              LD A,(WINDO+3)  ; LEFT SIDE
  020D    CD 0268        C              CALL WINOUT
                         C              ;----------------
  0210    ED 4B 0275     C              LD BC,(WINXY)
  0214    3A 027F        C      WINX2:  LD A,(WINDO+4)  ; SPACE 
  0217    CD 0268        C              CALL WINOUT
  021A    10 F8          C              DJNZ WINX2
  021C    3A 0280        C              LD A,(WINDO+5)  ; RIGHT SIDE
  021F    CD 0268        C              CALL WINOUT
  0222    ED 4B 0275     C              LD BC,(WINXY)
  0226    0D             C              DEC C
  0227    ED 43 0275     C              LD (WINXY),BC
  022B    20 C9          C              JR NZ,WINY1
  022D    06 08          C              LD B,LPOS
  022F    CD 0351        C              CALL UPROG2
  0232    ED 4B 0277     C              LD BC,(WINPOS)
  0236    04             C              INC B
  0237    78             C              LD A,B
  0238    27             C              DAA
  0239    47             C              LD B,A
  023A    ED 43 0277     C              LD (WINPOS),BC
  023E    CD 034A        C              CALL UPROG      ; SET
  0241    3A 0281        C              LD A,(WINDO+6)  ; LEFT DOWN CORNER
  0244    CD 0268        C              CALL WINOUT
  0247    ED 4B 0275     C              LD BC,(WINXY)
  024B    3A 0282        C      WINX3:  LD A,(WINDO+7)  ; DOWN LINE 
  024E    CD 0268        C              CALL WINOUT
  0251    10 F8          C              DJNZ WINX3
  0253    3A 0283        C              LD A,(WINDO+8)  ; RIGHT SIDE
  0256    CD 0268        C              CALL WINOUT
  0259    06 08          C              LD B,LPOS
  025B    CD 0351        C              CALL UPROG2
  025E    ED 4B 0279     C              LD BC,(WINCHA)
  0262    CD 034A        C              CALL UPROG      ; SET
  0265    E1             C              POP HL
  0266    C1             C              POP BC
  0267    C9             C              RET
                         C              ;-----------------
  0268    C5             C      WINOUT: PUSH BC
  0269    E5             C              PUSH HL
  026A    06 01          C              LD B,KEYOUT     ; SUBROUTINE KEY CALL OUTPUT IN BLASE
  026C    CD 0351        C              CALL UPROG2
  026F    CD 034A        C              CALL UPROG
  0272    E1             C              POP HL
  0273    C1             C              POP BC
  0274    C9             C              RET
  0275    0000           C      WINXY:  DEFW 0000H
  0277    0000           C      WINPOS: DEFW 0000H
  0279    0000           C      WINCHA: DEFW 0000H
  027B    DA C4 BF       C      WINDO:  DEFB 218D,196D,191D
  027E    B3 20 B3       C              DEFB 179D,20H,179D
  0281    C0 C4 D9       C              DEFB 192D,196D,217D
                         C              ;-----------------
        MACRO-80 3.43   27-Jul-81       PAGE    1-6


                         C      
                                        ;-----------------
  0284    E1                    AUEND:  POP HL
  0285    D1                            POP DE
  0286    C1                            POP BC
                                        ;---------
                                ;!!!    CALL ESTACK     ; 
  0287    DD F9                         LD SP,IX        ; return SP
  0289    DD E1                         POP IX
                                        ;---------
  028B    AF                            XOR A
  028C    32 6B27                       LD (RAMT),A
  028F    3E 00                         LD A,00         ; program start condition
  0291    32 6200                       LD (BLAN),A
  0294    C9                            RET             ; Exit program end
                                ;------------------------
                         C              INCLUDE ESTACK.MAC      ; SET ESTACK:
                         C              ;----------------
  0295    DD E5          C      ESTACK: PUSH IX
  0297    E1             C              POP HL
  0298    ED 72          C              SBC HL,SP
  029A    20 01          C              JR NZ,ERROR
  029C    C9             C              RET
  029D    38 05          C      ERROR:  JR C,ERR1
  029F    11 02B7        C              LD DE,ETEX1
  02A2    18 03          C              JR ERR2
  02A4    11 02EB        C      ERR1:   LD DE,ETEX2
  02A7    E5             C      ERR2:   PUSH HL
  02A8    C5             C              PUSH BC
  02A9    F5             C              PUSH AF
  02AA    0E 09          C              LD C,09H
  02AC    CD 0005        C              CALL 0005H
  02AF    F1             C              POP AF
  02B0    C1             C              POP BC
  02B1    E1             C              POP HL
  02B2    0E 00          C              LD C,0H
  02B4    C3 0000        C              JP 0
                         C              ;------------
  02B7    1B 5B 32 34    C      ETEX1:  DEFB 1BH,5BH,32H,34H,3BH,30H,31H,48H    ;cursor pos.
  02BB    3B 30 31 48    C      
  02BF    3E 2D 2D 2D    C              DEFM '>---- Stack ERROR < IX - 0000 < FFFF ---<'
  02C3    2D 20 53 74    C      
  02C7    61 63 6B 20    C      
  02CB    45 52 52 4F    C      
  02CF    52 20 3C 20    C      
  02D3    49 58 20 2D    C      
  02D7    20 30 30 30    C      
  02DB    30 20 3C 20    C      
  02DF    46 46 46 46    C      
  02E3    20 2D 2D 2D    C      
  02E7    3C             C      
  02E8    0A 0D          C              DEFB 0AH,0DH
  02EA    24             C              DEFM '$'
                         C      
  02EB    1B 5B 32 34    C      ETEX2:  DEFB 1BH,5BH,32H,34H,3BH,30H,31H,48H    ;cursor pos.
  02EF    3B 30 31 48    C      
        MACRO-80 3.43   27-Jul-81       PAGE    1-7


  02F3    3E 2D 2D 2D    C              DEFM '>---- Stack ERROR > IX - FFFF > 0000 ---<'
  02F7    2D 20 53 74    C      
  02FB    61 63 6B 20    C      
  02FF    45 52 52 4F    C      
  0303    52 20 3E 20    C      
  0307    49 58 20 2D    C      
  030B    20 46 46 46    C      
  030F    46 20 3E 20    C      
  0313    30 30 30 30    C      
  0317    20 2D 2D 2D    C      
  031B    3C             C      
  031C    0A 0D          C              DEFB 0AH,0DH
  031E    24             C              DEFM '$'
                         C      
                         C      ;---------------------
                                ;-------------------------
                                        ; CURSOR OFF END FROM CHARACTER SET
  031F    C5                    CURPOS: PUSH BC
  0320    04                            INC B           ;CHARACTER LENGTH +1
  0321    3E 00                         LD A,00H        ;COUNR FROM 0
  0323    3C                    CURP1:  INC A
  0324    27                            DAA
  0325    10 FC                         DJNZ CURP1
  0327    47                            LD B,A
  0328    E6 0F                         AND 0FH
  032A    32 651F                       LD (CURT+3),A
  032D    78                            LD A,B
  032E    0F                            RRCA
  032F    0F                            RRCA
  0330    0F                            RRCA
  0331    0F                            RRCA
  0332    E6 0F                         AND 0FH
  0334    32 651E                       LD (CURT+2),A
  0337    C1                            POP BC
  0338    C9                            RET
                                        ;---------------
                                        ; give up sing in a
                                        ;
  0339    F5                    TEXOUT: PUSH AF
  033A    C5                            PUSH BC
  033B    D5                            PUSH DE
  033C    E5                            PUSH HL
  033D    06 01                         LD B,KEYOUT
  033F    CD 0351                       CALL UPROG2
  0342    CD 034A                       CALL UPROG
  0345    E1                            POP HL
  0346    D1                            POP DE
  0347    C1                            POP BC
  0348    F1                            POP AF
  0349    C9                            RET
                                        ;------------
                                        ; EXECUTE PARAMETER AND JUMP BACK
                                        ;
  034A    D5                    UPROG:  PUSH DE         ; DE AS A BACKSPACE ADDRESS ON A STACK
  034B    C9                            RET             ; JUMP (DE) -> WIE POP DE
                                        ;----------------
        MACRO-80 3.43   27-Jul-81       PAGE    1-8


                                        ; EXECUTE PARAMETER AND JUMP BACK
                                        ;
  034C    E5                    UPROG1: PUSH HL         ; HL AS A BACKSPACE ADDRESS ON A STACK
  034D    21 6B27                       LD HL,RAMT
  0350    C9                            RET             ; JUMP (HL) -> WIE POP HL       
                                        ;----------------
                                        ; LOAD THE JUMP ADDRESS IN DE
                                        ;
  0351    E5                    UPROG2: PUSH HL
  0352    21 7000                       LD HL,PROG
  0355    11 0003                       LD DE,03H       ; distance 3byte jump
  0358    19                    SUM:    ADD HL,DE
  0359    10 FD                         DJNZ SUM
  035B    23                            INC HL          ; Skip JP COMMAND (C3....)
  035C    5E                            LD E,(HL)
  035D    23                            INC HL
  035E    56                            LD D,(HL)
  035F    E1                            POP HL
  0360    C9                            RET
                                        ;--------------
                                        ; search file name begining
                                        ;
  0361    21 6000               MASK1:  LD HL,RAM
  0364    46                            LD B,(HL)       ; first block length header
  0365    21 6006                       LD HL,RAM+6
  0368    23                    MASK2:  INC HL
  0369    10 FD                         DJNZ MASK2      ; step length
  036B    23                    MASK3:  INC HL          ; 
  036C    3E 1B                         LD A,1BH
  036E    BE                            CP (HL)
  036F    20 FA                         JR NZ,MASK3
  0371    2B                            DEC HL          ; 
  0372    46                            LD B,(HL)       ; to B
  0373    04                            INC B
  0374    7E                            LD A,(HL)
  0375    CD 0339                       CALL TEXOUT
  0378    23                            INC HL
  0379    23                    MASK4:  INC HL
  037A    10 FD                         DJNZ MASK4      ; until the text/image block end
  037C    23                            INC HL          ; file name block beginning
  037D    C9                            RET
                                        ;---------------
                                        ; from here issue
                                        ;
  037E    C5                    MENU:   PUSH BC
  037F    06 08                         LD B,LPOS
  0381    CD 0351                       CALL UPROG2
  0384    01 0471                       LD BC,0471H
  0387    ED 43 0684                    LD (FILEN),BC
  038B    CD 034A                       CALL UPROG
  038E    C1                            POP BC
  038F    3E 31                         LD A,'1'
  0391    32 0686               MENU6:  LD (ZEILEN),A
  0394    CD 0339                       CALL TEXOUT
  0397    3E 20                         LD A,' '
  0399    CD 0339                       CALL TEXOUT
        MACRO-80 3.43   27-Jul-81       PAGE    1-9


  039C    06 0C                         LD B,0CH
  039E    7E                    MENU7:  LD A,(HL)
  039F    FE 21                         CP 21H
  03A1    D8                            RET C
  03A2    CD 0339                       CALL TEXOUT
  03A5    23                            INC HL
  03A6    7E                            LD A,(HL)
  03A7    FE 2E                         CP '.'
  03A9    28 03                         JR Z,MENU8
  03AB    10 F1                         DJNZ MENU7
  03AD    C9                            RET     ;!!!JR TEXIN
                                        ;------------
  03AE    05                    MENU8:  DEC B
  03AF    23                            INC HL
  03B0    10 FD                         DJNZ MENU8+1
                                        ;------------
  03B2    C5                            PUSH BC
  03B3    06 08                         LD B,LPOS
  03B5    CD 0351                       CALL UPROG2
  03B8    ED 4B 0684                    LD BC,(FILEN)
  03BC    04                            INC B
  03BD    ED 43 0684                    LD (FILEN),BC
  03C1    CD 034A                       CALL UPROG
  03C4    C1                            POP BC
  03C5    7E                            LD A,(HL)
  03C6    FE 21                         CP 21H
  03C8    D8                            RET C
  03C9    3A 0686                       LD A,(ZEILEN)
  03CC    3C                            INC A
  03CD    E5                            PUSH HL         ; SWAP HL->DE
  03CE    D1                            POP DE
  03CF    18 C0                         JR MENU6
                                        ;--------------------
                                        ; text block output
                                        ;
  03D1    E5                    BTEX:   PUSH HL
  03D2    C5                            PUSH BC
  03D3    0E 09                         LD C,09H
  03D5    CD 0005                       CALL 0005
  03D8    CD 0445               BTEX1:  CALL INKEY
  03DB    FE 00                         CP 0
  03DD    20 F9                         JR NZ,BTEX1     ; keybuff empty?
  03DF    C1                            POP BC
  03E0    E1                            POP HL
  03E1    C9                            RET
                                        ;--------------
                                        ; color select
                                        ;
  03E2    FE 31                 COLM:   CP 31H
  03E4    20 09                         JR NZ,COLM1
  03E6    78                            LD A,B
  03E7    32 04BF                       LD (TTEX11),A
  03EA    79                            LD A,C
  03EB    32 04BA                       LD (TTEX1),A
  03EE    C9                            RET
  03EF    FE 32                 COLM1:  CP 32H
        MACRO-80 3.43   27-Jul-81       PAGE    1-10


  03F1    20 13                         JR NZ,COLM2
  03F3    3E 37                         LD A,37H
  03F5    32 04BA                       LD (TTEX1),A
  03F8    3E 34                         LD A,34H
  03FA    32 04BF                       LD (TTEX11),A
  03FD    78                            LD A,B
  03FE    32 04E7                       LD (TTEX21),A
  0401    79                            LD A,C
  0402    32 04E2                       LD (TTEX2),A
  0405    C9                            RET
  0406    FE 33                 COLM2:  CP 33H
  0408    20 13                         JR NZ,COLM3
  040A    3E 37                         LD A,37H
  040C    32 04E2                       LD (TTEX2),A
  040F    3E 34                         LD A,34H
  0411    32 04E7                       LD (TTEX21),A
  0414    78                            LD A,B
  0415    32 0511                       LD (TTEX31),A
  0418    79                            LD A,C
  0419    32 050C                       LD (TTEX3),A
  041C    C9                            RET
  041D    FE 34                 COLM3:  CP 34H
  041F    C0                            RET NZ
  0420    3E 37                         LD A,37H
  0422    32 050C                       LD (TTEX3),A
  0425    3E 34                         LD A,34H
  0427    32 0511                       LD (TTEX31),A
  042A    78                            LD A,B
  042B    32 0544                       LD (TTEX41),A
  042E    79                            LD A,C
  042F    32 053F                       LD (TTEX4),A
  0432    C9                            RET
                                        ;----------------
                                        ; key save
                                        ;
  0433    E5                    COMKEY: PUSH HL
  0434    D5                            PUSH DE
  0435    C5                            PUSH BC
  0436    F5                            PUSH AF
  0437    06 09                         LD B,KEYBUF
  0439    CD 0351                       CALL UPROG2
  043C    F1                            POP AF
  043D    C1                            POP BC
  043E    EB                            EX DE,HL        ; SPRUNADRESSE NACH HL
  043F    D1                            POP DE  ; ADRESSDATEN ZURUECK HOLEN
  0440    CD 034C                       CALL UPROG1     ; RET SPRUNG VON HL
  0443    E1                            POP HL
  0444    C9                            RET
                                        ;-------
                                        ; key input
                                        ;
  0445    C5                    INKEY:  PUSH BC
  0446    D5                            PUSH DE
  0447    E5                            PUSH HL
  0448    06 02                         LD B,KEYIN
  044A    CD 0351                       CALL UPROG2
        MACRO-80 3.43   27-Jul-81       PAGE    1-11


  044D    CD 034A                       CALL UPROG
  0450    E1                            POP HL
  0451    D1                            POP DE
  0452    C1                            POP BC
  0453    C9                            RET
                                        ;-----------------
                                        ; delete sign and cursor 1step left
  0454    11 0649               DELK:   LD DE,DELKEY
  0457    CD 03D1                       CALL BTEX
  045A    C9                            RET
                                        ;-----------------
                                        ; delete screen area
                                        ;
  045B    C5                    SDEL:   PUSH BC
  045C    D5                            PUSH DE
  045D    11 0643                       LD DE,CUROFF
  0460    CD 03D1                       CALL BTEX       ; text block TTEX output
  0463    01 0369                       LD BC,0369H     ; set cursor position
  0466    D5                    SDEL1:  PUSH DE
  0467    C5                            PUSH BC
  0468    06 08                         LD B,LPOS
  046A    CD 0351                       CALL UPROG2
  046D    C1                            POP BC
  046E    CD 034A                       CALL UPROG
  0471    D1                            POP DE
  0472    11 064E               SDEL2:  LD DE,LROW
  0475    CD 03D1                       CALL BTEX
  0478    78                            LD A,B
  0479    3C                            INC A
  047A    27                            DAA
  047B    47                            LD B,A
  047C    FE 22                         CP 22H
  047E    20 E6                         JR NZ,SDEL1
  0480    11 063D                       LD DE,CURON
  0483    CD 03D1                       CALL BTEX       ; text block TTEX output
  0486    D1                            POP DE
  0487    C1                            POP BC
  0488    C9                            RET
                                ;---------------------------
                                ;
  0489    1B 5B 33 37           TTEX:   DEFB 1BH,5BH,33H,37H,6DH
  048D    6D                    
  048E    1B 5B 34 34                   DEFB 1BH,5BH,34H,34H,6DH
  0492    6D                    
  0493    1B 5B 30 33                   DEFB 1BH,5BH,30H,33H,3BH,30H,35H,48H    ; 
  0497    3B 30 35 48           
  049B    53 65 69 74                   DEFM 'Seite neu erstellen '
  049F    65 20 6E 65           
  04A3    75 20 65 72           
  04A7    73 74 65 6C           
  04AB    6C 65 6E 20           
  04AF    1B 5B 30 36                   DEFB 1BH,5BH,30H,36H,3BH,30H,35H,48H    ; 
  04B3    3B 30 35 48           
  04B7    1B 5B 33                      DEFB 1BH,5BH,33H
  04BA    37 6D                 TTEX1:  DEFB 37H,6DH
  04BC    1B 5B 34                      DEFB 1BH,5BH,34H
        MACRO-80 3.43   27-Jul-81       PAGE    1-12


  04BF    34 6D                 TTEX11: DEFB 34H,6DH
  04C1    31 3E 20 41                   DEFM '1> Aendern (Pos.Numer)'
  04C5    65 6E 64 65           
  04C9    72 6E 20 28           
  04CD    50 6F 73 2E           
  04D1    4E 75 6D 65           
  04D5    72 29                 
  04D7    1B 5B 30 37                   DEFB 1BH,5BH,30H,37H,3BH,30H,35H,48H    ; 
  04DB    3B 30 35 48           
  04DF    1B 5B 33                      DEFB 1BH,5BH,33H
  04E2    37 6D                 TTEX2:  DEFB 37H,6DH
  04E4    1B 5B 34                      DEFB 1BH,5BH,34H
  04E7    34 6D                 TTEX21: DEFB 34H,6DH
  04E9    32 3E 20 45                   DEFM '2> Einfuegen (Pos.Numer)'
  04ED    69 6E 66 75           
  04F1    65 67 65 6E           
  04F5    20 28 50 6F           
  04F9    73 2E 4E 75           
  04FD    6D 65 72 29           
  0501    1B 5B 30 38                   DEFB 1BH,5BH,30H,38H,3BH,30H,35H,48H    ; 
  0505    3B 30 35 48           
  0509    1B 5B 33                      DEFB 1BH,5BH,33H
  050C    37 6D                 TTEX3:  DEFB 37H,6DH
  050E    1B 5B 34                      DEFB 1BH,5BH,34H
  0511    34 6D                 TTEX31: DEFB 34H,6DH
  0513    33 3E 20 4D                   DEFM '3> Menupunkt loeschen (Pos.Numer)'
  0517    65 6E 75 70           
  051B    75 6E 6B 74           
  051F    20 6C 6F 65           
  0523    73 63 68 65           
  0527    6E 20 28 50           
  052B    6F 73 2E 4E           
  052F    75 6D 65 72           
  0533    29                    
  0534    1B 5B 30 39                   DEFB 1BH,5BH,30H,39H,3BH,30H,35H,48H    ; 
  0538    3B 30 35 48           
  053C    1B 5B 33                      DEFB 1BH,5BH,33H
  053F    37 6D                 TTEX4:  DEFB 37H,6DH
  0541    1B 5B 34                      DEFB 1BH,5BH,34H
  0544    34 6D                 TTEX41: DEFB 34H,6DH
  0546    34 3E 20 42                   DEFM '4> Bildschirmtext (mit 9 speichern)'
  054A    69 6C 64 73           
  054E    63 68 69 72           
  0552    6D 74 65 78           
  0556    74 20 28 6D           
  055A    69 74 20 39           
  055E    20 73 70 65           
  0562    69 63 68 65           
  0566    72 6E 29              
  0569    1B 5B 31 31                   DEFB 1BH,5BH,31H,31H,3BH,30H,35H,48H    ; 
  056D    3B 30 35 48           
  0571    45 43 53 3E                   DEFM 'ECS> alles verwerfen'
  0575    20 61 6C 6C           
  0579    65 73 20 76           
  057D    65 72 77 65           
  0581    72 66 65 6E           
        MACRO-80 3.43   27-Jul-81       PAGE    1-13


  0585    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH
  0589    6D                    
  058A    1B 5B 34 34                   DEFB 1BH,5BH,34H,34H,6DH
  058E    6D                    
  058F    1B 5B 31 34                   DEFB 1BH,5BH,31H,34H,3BH,30H,31H,48H    ; 
  0593    3B 30 31 48           
  0597    24                            DEFM '$'        ; block output end BIOS
  0598    2A                            DEFB 2AH
  0110                          TTLEN   EQU $-TTEX
                                        ;------------
  0599    1B 5B 33 37           MTEX:   DEFB 1BH,5BH,33H,37H,6DH
  059D    6D                    
  059E    1B 5B 33 34                   DEFB 1BH,5BH,33H,34H,6DH
  05A2    6D                    
  05A3    1B 5B 32 34                   DEFB 1BH,5BH,32H,34H,3BH,30H,31H,48H    ; 
  05A7    3B 30 31 48           
  05AB    41 75 73 77                   DEFM 'Auswahl: '
  05AF    61 68 6C 3A           
  05B3    20                    
  05B4    1B 37                         DEFB 1BH,37H    ; cursor pos save
  05B6    20 20 20 20                   DEFM '                         '
  05BA    20 20 20 20           
  05BE    20 20 20 20           
  05C2    20 20 20 20           
  05C6    20 20 20 20           
  05CA    20 20 20 20           
  05CE    20                    
  05CF    1B 38                         DEFB 1BH,38H    ; return cursor pos
  05D1    24                            DEFM '$'        ; block output end BIOS
                                        ;------------
  05D2    1B 5B 31 36           NRMENU: DEFB 1BH,5BH,31H,36H,3BH,30H,31H,48H    ; 
  05D6    3B 30 31 48           
  05DA    4E 72 2E 20                   DEFM 'Nr. eingeben: '
  05DE    65 69 6E 67           
  05E2    65 62 65 6E           
  05E6    3A 20                 
  05E8    1B 37                         DEFB 1BH,37H    ; cursor pos save
  05EA    20 20 20 20                   DEFM '                         '
  05EE    20 20 20 20           
  05F2    20 20 20 20           
  05F6    20 20 20 20           
  05FA    20 20 20 20           
  05FE    20 20 20 20           
  0602    20                    
  0603    1B 38                         DEFB 1BH,38H    ; return cursor pos
  0605    24                            DEFM '$'        ; block output end BIOS
                                        ;-------------
  0606    00 00 00 00           BF02:   DEFB 00H,00H,00H,00H
  060A    00 00 00 00           BF03:   DEFB 00H,00H,00H,00H    
                                
  060E    1B 5B 02 04           EBUFF:  DEFB 1BH,5BH,02H,04H,3BH,00H,01H,48H
  0612    3B 00 01 48           
  0616    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH
  061A    6D                    
  061B    1B 5B 34 34                   DEFB 1BH,5BH,34H,34H,6DH
  061F    6D                    
        MACRO-80 3.43   27-Jul-81       PAGE    1-14


  0620    20 20 20 20                   DEFM '                             '
  0624    20 20 20 20           
  0628    20 20 20 20           
  062C    20 20 20 20           
  0630    20 20 20 20           
  0634    20 20 20 20           
  0638    20 20 20 20           
  063C    20                    
  002F                          EZLEN   EQU $-EBUFF
                                
  063D    1B 5B 3F 25           CURON:  DEFB 1BH,5BH,'?','%','h'
  0641    68                    
  0642    24                            DEFM '$'        ; block output end BIOS
  0643    1B 5B 3F 25           CUROFF: DEFB 1BH,5BH,'?','%','l'
  0647    6C                    
  0648    24                            DEFM '$'        ; block output end BIOS
  0649    1B 5B 44              DELKEY: DEFB 1BH,5BH,'D'
  064C    20                            DEFB 20H
  064D    24                            DEFM '$'        ; block output end BIOS
  064E    1B 5B 31 4B           LROW:   DEFB 1BH,5BH,'1','K'
  0652    24                            DEFM '$'        ; block output end BIOS
                                
  0653    1B 5B 02 04           ABUFF:  DEFB 1BH,5BH,02H,04H,3BH,00H,01H,48H
  0657    3B 00 01 48           
  065B    20 20 20 20           AUTEX:  DEFM '                             '
  065F    20 20 20 20           
  0663    20 20 20 20           
  0667    20 20 20 20           
  066B    20 20 20 20           
  066F    20 20 20 20           
  0673    20 20 20 20           
  0677    20                    
  0025                          AZLEN   EQU $-ABUFF
  0678    2E 43 4F 4D           AUTO:   DEFM '.COM        '
  067C    20 20 20 20           
  0680    20 20 20 20           
  0684    0000                  FILEN:  DEFW 0000H
  0686    00                    ZEILEN: DEFB 00H
                                
                                END
        MACRO-80 3.43   27-Jul-81       PAGE    S


Macros:

Symbols:
0653    ABUFF           0284    AUEND           065B    AUTEX           
0678    AUTO            0025    AZLEN           0606    BF02            
060A    BF03            6503    BFRHH           6502    BFRHL           
6501    BFRLH           6500    BFRLL           650F    BFSHH           
650E    BFSHL           650D    BFSLH           650C    BFSLL           
650B    BFVHH           650A    BFVHL           6509    BFVLH           
6508    BFVLL           6200    BLAN            6205    BSTAT           
03D1    BTEX            03D8    BTEX1           0080    BUFF            
0020    CMD_READSEC     0030    CMD_WRITESEC    03E2    COLM            
03EF    COLM1           0406    COLM2           041D    COLM3           
0433    COMKEY          6C3F    COP             0007    CPOS            
0643    CUROFF          063D    CURON           0323    CURP1           
031F    CURPOS          6518    CURS            651C    CURT            
0454    DELK            0649    DELKEY          060E    EBUFF           
02A4    ERR1            02A7    ERR2            029D    ERROR           
0295    ESTACK          02B7    ETEX1           02EB    ETEX2           
002F    EZLEN           005C    FCB             006B    FCBCR           
005D    FCBFN           0065    FCBFT           007C    FCBRA           
0020    FDC             0684    FILEN           0800    HDD             
00BE    HDDE            00F0    IDE             00FD    IDECHI          
00FC    IDECLO          00FF    IDECMD          00F8    IDEDAT          
00F6    IDEDOR          00F9    IDEERR          00FA    IDESCNT         
00FE    IDESDH          00FB    IDESNUM         00FF    IDESTAT         
0445    INKEY           0175    KEY1            01A0    KEY2            
01A8    KEY7            01B4    KEY9            0009    KEYBUF          
0002    KEYIN           0001    KEYOUT          0060    LCD             
6513    LOGHH           6512    LOGHL           6511    LOGLH           
6510    LOGLL           015B    LOOP1           0008    LPOS            
064E    LROW            0361    MASK1           0368    MASK2           
036B    MASK3           0379    MASK4           037E    MENU            
0391    MENU6           039E    MENU7           03AE    MENU8           
A101    MMC             0007    MMCE            0599    MTEX            
05D2    NRMENU          001E    PIOB            7000    PROG            
0005    P_READ          0006    P_WRITE         6524    RADR            
6000    RAM             6727    RAMS            6B27    RAMT            
6527    RAMV            0000    RBLAN           0005    RBSTAT          
6526    RMEN            0006    RSOTR           0004    RTERM           
6BEF    RTEX            0002    RTYPE1          0003    RTYPE2          
0001    RUSER           6520    SANDB           045B    SDEL            
0466    SDEL1           0472    SDEL2           0004    SELDM           
00F7    SELDS           0358    SUM             6204    TERM            
011B    TEXIN           012A    TEXIN1          0339    TEXOUT          
0489    TTEX            04BA    TTEX1           04BF    TTEX11          
04E2    TTEX2           04E7    TTEX21          050C    TTEX3           
0511    TTEX31          053F    TTEX4           0544    TTEX41          
0110    TTLEN           6202    TYPE1           6203    TYPE2           
034A    UPROG           034C    UPROG1          0351    UPROG2          
0080    URCS            6201    USER            0279    WINCHA          
027B    WINDO           01C3    WINDOW          0268    WINOUT          
0277    WINPOS          01E8    WINX1           0214    WINX2           
024B    WINX3           0275    WINXY           01F6    WINY1           
0686    ZEILEN          



No Fatal error(s)


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
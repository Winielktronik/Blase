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
  0108    21 6000               FIL2:   LD HL,RAM
  010B    46                            LD B,(HL)       ; first block
  010C    21 6006                       LD HL,RAM+6
  010F    23                    FIL3:   INC HL
  0110    10 FD                         DJNZ FIL3
  0112    23                    FIL4:   INC HL
  0113    3E 1B                         LD A,1BH
  0115    BE                            CP (HL)
  0116    20 FA                         JR NZ,FIL4
                                        ;---------
                                        ; from here issue
                                        ;
  0118    2B                            DEC HL          ; length second block
  0119    46                            LD B,(HL)       ; to B
  011A    04                            INC B
  011B    7E                            LD A,(HL)
  011C    CD 056B                       CALL TEXOUT
  011F    23                            INC HL
  0120    23                    FIL5:   INC HL
  0121    10 FD                         DJNZ FIL5       ; until the end
  0123    23                            INC HL
  0124    C5                            PUSH BC
  0125    06 08                         LD B,LPOS
  0127    CD 058E                       CALL UPROG2
  012A    01 0471                       LD BC,0471H
  012D    ED 43 0607                    LD (FILEN),BC
  0131    CD 057C                       CALL UPROG
  0134    C1                            POP BC
  0135    3E 31                         LD A,'1'
  0137    32 0609               FIL6:   LD (ZEILEN),A
        MACRO-80 3.43   27-Jul-81       PAGE    1-3


  013A    CD 056B                       CALL TEXOUT
  013D    3E 20                         LD A,' '
  013F    CD 056B                       CALL TEXOUT
  0142    06 0C                         LD B,0CH
  0144    7E                    FIL7:   LD A,(HL)
  0145    FE 00                         CP 00H
  0147    28 31                         JR Z,TEXIN
  0149    CD 056B                       CALL TEXOUT
  014C    23                            INC HL
  014D    7E                            LD A,(HL)
  014E    FE 2E                         CP '.'
  0150    28 04                         JR Z,FIL8
  0152    10 F0                         DJNZ FIL7
  0154    18 24                         JR TEXIN
                                        ;------------
  0156    05                    FIL8:   DEC B
  0157    23                            INC HL
  0158    10 FD                         DJNZ FIL8+1
                                        ;------------
  015A    C5                            PUSH BC
  015B    06 08                         LD B,LPOS
  015D    CD 058E                       CALL UPROG2
  0160    ED 4B 0607                    LD BC,(FILEN)
  0164    04                            INC B
  0165    ED 43 0607                    LD (FILEN),BC
  0169    CD 057C                       CALL UPROG
  016C    C1                            POP BC
  016D    7E                            LD A,(HL)
  016E    FE 00                         CP 00H
  0170    28 08                         JR Z,TEXIN
  0172    3A 0609                       LD A,(ZEILEN)
  0175    3C                            INC A
  0176    E5                            PUSH HL
  0177    D1                            POP DE
  0178    18 BD                         JR FIL6         
                                        ;--------------------
                                        ; SET CURSOR ON START POSITION
                                        ;
  017A    01 0510               TEXIN:  LD BC,0510H
  017D    21 0E01                       LD HL,0E01H
  0180    CD 023D                       CALL WINDOW
                                        ;--------------
                                        ; TEXT input
                                        ;
  0183    11 05FB                       LD DE,AUTO
  0186    C5                    KEY1:   PUSH BC
  0187    D5                            PUSH DE
  0188    E5                            PUSH HL
  0189    06 02                         LD B,KEYIN
  018B    CD 058E                       CALL UPROG2
  018E    CD 057C                       CALL UPROG
  0191    E1                            POP HL
  0192    D1                            POP DE
  0193    C1                            POP BC
  0194    FE 00                         CP 0
  0196    28 EE                         JR Z,KEY1
        MACRO-80 3.43   27-Jul-81       PAGE    1-4


  0198    FE 0D                         CP 0DH
  019A    CA 01B7                       JP Z,KEY2       ; !!!!AUSGANG VORERST 
  019D    12                            LD (DE),A
  019E    13                            INC DE
  019F    23                            INC HL
  01A0    D5                            PUSH DE
  01A1    3E 2E                         LD A,'.'
  01A3    12                            LD (DE),A
  01A4    13                            INC DE
  01A5    3E 43                         LD A,'C'
  01A7    12                            LD (DE),A
  01A8    13                            INC DE
  01A9    3E 4F                         LD A,'O'
  01AB    12                            LD (DE),A
  01AC    13                            INC DE
  01AD    3E 4D                         LD A,'M'
  01AF    12                            LD (DE),A
  01B0    13                            INC DE 
  01B1    3E 20                         LD A,' '
  01B3    12                            LD (DE),A
  01B4    D1                            POP DE
  01B5    18 CF                         JR KEY1
                                        ;--------------
                                        ; search image output
                                        ;
  01B7    21 6000               KEY2:   LD HL,RAM
  01BA    46                            LD B,(HL)       ; first block
  01BB    21 6006                       LD HL,RAM+6
  01BE    23                    SUCHE:  INC HL
  01BF    10 FD                         DJNZ SUCHE
  01C1    23                    SUCHF:  INC HL
  01C2    3E 1B                         LD A,1BH
  01C4    BE                            CP (HL)
  01C5    20 FA                         JR NZ,SUCHF
                                        ;---------
                                        ; from here issue
                                        ;
  01C7    2B                            DEC HL          ; length second block
  01C8    46                            LD B,(HL)       ; to B
  01C9    04                            INC B
  01CA    7E                            LD A,(HL)
  01CB    CD 056B                       CALL TEXOUT
  01CE    23                            INC HL
  01CF    23                    SUCHG:  INC HL
  01D0    10 FD                         DJNZ SUCHG      ; until the end
  01D2    23                            INC HL
  01D3    C5                            PUSH BC
  01D4    06 08                         LD B,LPOS
  01D6    CD 058E                       CALL UPROG2
  01D9    01 0471                       LD BC,0471H
  01DC    ED 43 0607                    LD (FILEN),BC
  01E0    CD 057C                       CALL UPROG
  01E3    C1                            POP BC
  01E4    11 05FB                       LD DE,AUTO
  01E7    3E 31                         LD A,'1'
  01E9    32 0609               KEY7:   LD (ZEILEN),A
        MACRO-80 3.43   27-Jul-81       PAGE    1-5


  01EC    CD 056B                       CALL TEXOUT
  01EF    3E 20                         LD A,' '
  01F1    CD 056B                       CALL TEXOUT
  01F4    06 0C                         LD B,0CH
  01F6    1A                    SUCHD:  LD A,(DE)
  01F7    FE 00                         CP 00H
  01F9    28 33                         JR Z,KEY9
  01FB    77                            LD (HL),A       ; NOCH FALSCH DA PROG NICHT GEAENDERT WURDE
  01FC    CD 056B                       CALL TEXOUT
  01FF    13                            INC DE
  0200    23                            INC HL
  0201    1A                            LD A,(DE)
  0202    FE 2E                         CP '.'
  0204    28 04                         JR Z,KEY8
  0206    10 EE                         DJNZ SUCHD
  0208    18 24                         JR KEY9
                                        ;------------
  020A    05                    KEY8:   DEC B
  020B    23                            INC HL
  020C    10 FD                         DJNZ KEY8+1
  020E    C5                            PUSH BC
  020F    06 08                         LD B,LPOS
  0211    CD 058E                       CALL UPROG2
  0214    ED 4B 0607                    LD BC,(FILEN)
  0218    04                            INC B
  0219    ED 43 0607                    LD (FILEN),BC
  021D    CD 057C                       CALL UPROG
  0220    C1                            POP BC
  0221    7E                            LD A,(HL)
  0222    FE 00                         CP 00H
  0224    28 08                         JR Z,KEY9
  0226    3A 0609                       LD A,(ZEILEN)
  0229    3C                            INC A
  022A    E5                            PUSH HL
  022B    D1                            POP DE
  022C    18 BB                         JR KEY7         
                                        ;--------------
  022E    06 02                 KEY9:   LD B,KEYIN
  0230    CD 058E                       CALL UPROG2
  0233    CD 057C                       CALL UPROG
  0236    FE 00                         CP 0
  0238    28 F4                         JR Z,KEY9       ; press key for end
  023A    C3 053E                       JP AUEND
                                        ;------------------
                         C              INCLUDE RAHMEN.MAC      ; SET WINDOW
                         C              ;----------------
  023D    22 02EF        C      WINDOW: LD (WINXY),HL   ; WINDOW X,Y
  0240    ED 43 02F1     C              LD (WINPOS),BC  ; STARTPOS X,Y
  0244    C5             C              PUSH BC         ; =X,Y POSITION 
  0245    E5             C              PUSH HL         ; =X,Y LAENGE
  0246    04             C              INC B
  0247    0C             C              INC C
  0248    ED 43 02F3     C              LD (WINCHA),BC  ; for pos in windows
  024C    06 08          C              LD B,LPOS       ; SUBROUTINE CALL CURSOR IN BLASE ON POSITION
  024E    CD 058E        C              CALL UPROG2
  0251    ED 4B 02F1     C              LD BC,(WINPOS)
        MACRO-80 3.43   27-Jul-81       PAGE    1-6


  0255    CD 057C        C              CALL UPROG
                         C              ;----------------
                         C              ; START WINDOW
                         C              ;
  0258    3A 02F5        C              LD A,(WINDO)    ; LEFT UP CORNER
  025B    CD 02E2        C              CALL WINOUT
  025E    ED 4B 02EF     C              LD BC,(WINXY)   ; LOAD X
  0262    3A 02F6        C      WINX1:  LD A,(WINDO+1)  ; UP X LINE
  0265    CD 02E2        C              CALL WINOUT
  0268    10 F8          C              DJNZ WINX1
  026A    3A 02F7        C              LD A,(WINDO+2)  ; RIGHT UP CORNER
  026D    CD 02E2        C              CALL WINOUT
                         C              ;----------------OK.
                         C              ; NEW LINE
                         C              ;
  0270    06 08          C      WINY1:  LD B,LPOS       ; BIOS BLASE
  0272    CD 058E        C              CALL UPROG2
  0275    ED 4B 02F1     C              LD BC,(WINPOS)
  0279    04             C              INC B
  027A    78             C              LD A,B
  027B    27             C              DAA
  027C    47             C              LD B,A
  027D    ED 43 02F1     C              LD (WINPOS),BC
  0281    CD 057C        C              CALL UPROG      ; SET
  0284    3A 02F8        C              LD A,(WINDO+3)  ; LEFT SIDE
  0287    CD 02E2        C              CALL WINOUT
                         C              ;----------------
  028A    ED 4B 02EF     C              LD BC,(WINXY)
  028E    3A 02F9        C      WINX2:  LD A,(WINDO+4)  ; SPACE 
  0291    CD 02E2        C              CALL WINOUT
  0294    10 F8          C              DJNZ WINX2
  0296    3A 02FA        C              LD A,(WINDO+5)  ; RIGHT SIDE
  0299    CD 02E2        C              CALL WINOUT
  029C    ED 4B 02EF     C              LD BC,(WINXY)
  02A0    0D             C              DEC C
  02A1    ED 43 02EF     C              LD (WINXY),BC
  02A5    20 C9          C              JR NZ,WINY1
  02A7    06 08          C              LD B,LPOS
  02A9    CD 058E        C              CALL UPROG2
  02AC    ED 4B 02F1     C              LD BC,(WINPOS)
  02B0    04             C              INC B
  02B1    78             C              LD A,B
  02B2    27             C              DAA
  02B3    47             C              LD B,A
  02B4    ED 43 02F1     C              LD (WINPOS),BC
  02B8    CD 057C        C              CALL UPROG      ; SET
  02BB    3A 02FB        C              LD A,(WINDO+6)  ; LEFT DOWN CORNER
  02BE    CD 02E2        C              CALL WINOUT
  02C1    ED 4B 02EF     C              LD BC,(WINXY)
  02C5    3A 02FC        C      WINX3:  LD A,(WINDO+7)  ; DOWN LINE 
  02C8    CD 02E2        C              CALL WINOUT
  02CB    10 F8          C              DJNZ WINX3
  02CD    3A 02FD        C              LD A,(WINDO+8)  ; RIGHT SIDE
  02D0    CD 02E2        C              CALL WINOUT
  02D3    06 08          C              LD B,LPOS
  02D5    CD 058E        C              CALL UPROG2
        MACRO-80 3.43   27-Jul-81       PAGE    1-7


  02D8    ED 4B 02F3     C              LD BC,(WINCHA)
  02DC    CD 057C        C              CALL UPROG      ; SET
  02DF    E1             C              POP HL
  02E0    C1             C              POP BC
  02E1    C9             C              RET
                         C              ;-----------------
  02E2    C5             C      WINOUT: PUSH BC
  02E3    E5             C              PUSH HL
  02E4    06 01          C              LD B,KEYOUT     ; SUBROUTINE KEY CALL OUTPUT IN BLASE
  02E6    CD 058E        C              CALL UPROG2
  02E9    CD 057C        C              CALL UPROG
  02EC    E1             C              POP HL
  02ED    C1             C              POP BC
  02EE    C9             C              RET
  02EF    0000           C      WINXY:  DEFW 0000H
  02F1    0000           C      WINPOS: DEFW 0000H
  02F3    0000           C      WINCHA: DEFW 0000H
  02F5    DA C4 BF       C      WINDO:  DEFB 218D,196D,191D
  02F8    B3 20 B3       C              DEFB 179D,20H,179D
  02FB    C0 C4 D9       C              DEFB 192D,196D,217D
                         C              ;-----------------
                         C      
                                        ;-----------------
                                        ; NAECHSTE FREIE TYPE2 >1 SUCHEN
                                        ; USER ,TYPE1 MUSS GLEICHBLEIBEN
                                        ;
  02FE    3E 01                         LD A,01H
  0300    32 05A8                       LD (BF03),A     ; TYPE2 ZAEHLER
  0303    ED 5B 6500                    LD DE,(BFRLL)
  0307    ED 53 05A4                    LD (BF02),DE
  030B    2A 6502                       LD HL,(BFRHL)
  030E    22 05A6                       LD (BF02+2),HL  ; ADRESSE TYPE2=1 RETTEN
  0311                          FI00:   ;CALL LBA0
  0311    DA 053E                       JP C,AUEND
  0314    ED 53 6508                    LD (BFVLL),DE
  0318    22 650A                       LD (BFVHL),HL
  031B    ED 4B 6508                    LD BC,(BFVLL)
  031F    ED 5B 650A                    LD DE,(BFVHL)
                                        ;CALL   DISK
  0323    01 6527                       LD BC,RAMV
                                        ;--------------------
                                        ; USER VERGLEICHEN
  0326    3A 6001                       LD A,(RAM+RUSER)
  0329    47                            LD B,A
  032A    3A 6528                       LD A,(RAMV+RUSER)
  032D    B8                            CP B
  032E    38 40                         JR C,FI61
  0330    20 48                         JR NZ,FI10
                                        ;---------------------
                                        ; TYPE1 VERGLEICHEN
  0332    3A 6002                       LD A,(RAM+RTYPE1)
  0335    47                            LD B,A
  0336    3A 6529                       LD A,(RAMV+RTYPE1)
  0339    B8                            CP B
  033A    20 34                         JR NZ,FI61
                                        ;---------------------
        MACRO-80 3.43   27-Jul-81       PAGE    1-8


                                        ; TYPE2 MUSS >0 SEIN 2
  033C    3A 652A                       LD A,(RAMV+RTYPE2)
  033F    FE 02                         CP 02H
  0341    38 2D                         JR C,FI61
                                        ;---------------------
                                        ; COPY SUCHTEXT AUS EINGABE ZUR]CH NACH RAMT
  0343    21 6BEF                       LD HL,RTEX
  0346    11 6B27                       LD DE,RAMT
  0349    46                            LD B,(HL)
  034A    7E                            LD A,(HL)
  034B    12                            LD (DE),A       
  034C    13                            INC DE
  034D    23                            INC HL
  034E    7E                    TY00:   LD A,(HL)
  034F    12                            LD (DE),A
  0350    13                            INC DE
  0351    23                            INC HL
  0352    10 FA                         DJNZ TY00
                                        ;-------------------
                                        ; SUCHE NACH WEITEREN EINTRAEGEN
                                        ; UND BESTIMME NAECHSTE BLASE
  0354    21 6527                       LD HL,RAMV
  0357    3A 6B27                       LD A,(RAMT)
  035A    11 6B28                       LD DE,RAMT+1
  035D    06 3F                         LD B,3FH
  035F    21 652C                       LD HL,RAMV+RBSTAT
                                        ;CALL SUCH0
  0362    38 0C                         JR C,FI61
  0364    3A 05A8               FI60:   LD A,(BF03)
  0367    3C                            INC A
                                        ; JR Z,  UEBERLAUF ABFABGEN  ????
  0368    32 05A8                       LD (BF03),A
  036B    CB EF                         SET 5,A
  036D    CD 056B                       CALL TEXOUT
  0370    ED 5B 6508            FI61:   LD DE,(BFVLL)
  0374    2A 650A                       LD HL,(BFVHL)
  0377    C3 0311                       JP FI00
                                        ;--------------------
                                        ; NEUE BLASE MUSS TERM = 0 SEIN
  037A    3A 652B               FI10:   LD A,(RAMV+RTERM)
  037D    FE 00                         CP 0
  037F    20 EF                         JR NZ,FI61
  0381    3A 05A8                       LD A,(BF03)
  0384    3C                            INC A
                                        ; JR Z,  UEBERLAUF ABFRAGEN ???
  0385    32 6003                       LD (RAM+RTYPE2),A
  0388    3E FE                         LD A,0FEH
  038A    32 6004                       LD (RAM+RTERM),A                
  038D    2A 6508                       LD HL,(BFVLL)   
  0390    22 6500                       LD (BFRLL),HL
  0393    2A 650A                       LD HL,(BFVHL)
  0396    22 6502                       LD (BFRHL),HL
                                        ;-----------------
                                        ; UEBERSPRINGE ERSTER BLOCK
                                        ; UND ZWEITER BLOCK BIS TEXTBEGIN
                                        ;
        MACRO-80 3.43   27-Jul-81       PAGE    1-9


  0399    21 6000               FI99:   LD HL,RAM
  039C    46                            LD B,(HL)
  039D    23                    AU00:   INC HL
  039E    10 FD                         DJNZ AU00
  03A0    46                            LD B,(HL)
  03A1    23                    AU01:   INC HL
  03A2    10 FD                         DJNZ AU01
                                        ;--------------------
                                        ; AB HIER (HL) ERSTES ZEICHEN MOEGLICH
                                        ;
  03A4    06 FF                         LD B,0FFH       ; MAX LAENGE BIS ERSTEN ZEICHEN
  03A6    7E                    AU10:   LD A,(HL)
  03A7    FE 30                         CP 30H  ; ZEICHEN KLEINER "!"
  03A9    30 06                         JR NC,AU11      ; ZEICHEN GEFUNDEN
  03AB    23                            INC HL
  03AC    10 F8                         DJNZ AU10
  03AE    C3 053E                       JP AUEND        
                                        ;---------------------
                                        ; ZEICHEN GEFUNDEN
  03B1    C5                    AU11:   PUSH BC
  03B2    2B                            DEC HL  ; EIN ZEICHEN ZURUECKSETZEN
  03B3    06 14                 AU12:   LD B,20D
  03B5    3E 82                         LD A,82H        ; BIT 7 =1 UM EXTERNE CURSOR POSITION ZU ERKENNEN
  03B7    32 6B27                       LD (RAMT),A
  03BA    11 05DE                       LD DE,AUTEX
  03BD    23                    AU13:   INC HL  ; ZUM NAECHSTEN ZEICHEN 
  03BE    7E                            LD A,(HL)
  03BF    FE 0D                         CP 0DH          ; CR NEUE ZEILE
  03C1    28 F0                         JR Z,AU12
  03C3    12                            LD (DE),A
  03C4    FE 3F                         CP '?'
  03C6    CA 053D                       JP Z,AU90
  03C9    FE 3A                         CP ':'
  03CB    28 12                         JR Z,AU20
  03CD    13                            INC DE
  03CE    FE 30                         CP 30H
  03D0    38 07                         JR C,AU14
  03D2    3A 6B27                       LD A,(RAMT)
  03D5    3C                            INC A
  03D6    32 6B27                       LD (RAMT),A     ; LAENGE ANZEIGETEXT
  03D9    10 E2                 AU14:   DJNZ AU13
  03DB    C1                            POP BC
  03DC    C3 03A6                       JP AU10
                                        ;----------------
                                        ; ZEILE 24,1 LOESCHEN MIT SPACE (20H)
  03DF    E5                    AU20:   PUSH    HL
  03E0    06 2A                         LD      B,EZLEN
  03E2    21 05AC                       LD      HL,EBUFF
  03E5    7E                    AU21:   LD      A,(HL)
  03E6    CD 056B               AU22:   CALL    TEXOUT
  03E9    23                            INC     HL
  03EA    10 F9                         DJNZ    AU21
                                        ;----------------
                                        ; TEXTZEILE AUSGEBEN
                                
  03EC    3E 30                         LD      A,30H
        MACRO-80 3.43   27-Jul-81       PAGE    1-10


  03EE    32 651E                       LD      (CURT+2),A
  03F1    3E 31                         LD      A,31H
  03F3    32 651F                       LD      (CURT+3),A
  03F6    06 25                         LD      B,AZLEN
  03F8    21 05D6                       LD      HL,ABUFF
  03FB    7E                    AU31:   LD      A,(HL)
  03FC    FE 1B                         CP      1BH
  03FE    38 1E                         JR      C,AU33  
  0400    FE 20                         CP      20H
  0402    28 1A                         JR      Z,AU33
  0404    CD 056B                       CALL    TEXOUT
  0407    3A 651F                       LD      A,(CURT+3)
  040A    3C                            INC     A
  040B    FE 3A                         CP      3AH
  040D    38 07                         JR      C,CAU31
                                        ;LD     A,(CURT+2)
                                        ;INC    A
  040F    3E 31                         LD      A,31H
  0411    32 651E                       LD      (CURT+2),A
  0414    3E 30                         LD      A,30H
  0416    32 651F               CAU31:  LD      (CURT+3),A
  0419    7E                            LD      A,(HL)
  041A    FE 3A                         CP      ':'
  041C    28 03                         JR      Z,AU32
  041E    23                    AU33:   INC     HL
  041F    18 DA                         JR      AU31
                                        ;---------------
  0421    11 6B28               AU32:   LD      DE,RAMT+1
  0424    3A 6B27                       LD      A,(RAMT)
  0427    32 6B77                       LD      (RAMT+50H),A
  042A    06 14                         LD      B,20D
  042C    3E 2E                 LO01:   LD      A,2EH           ; (RAMT) LOESCHEN MIT '.'
  042E    12                            LD      (DE),A
  042F    13                            INC     DE
  0430    10 FA                         DJNZ    LO01
  0432    11 6B28                       LD      DE,RAMT+1
  0435    AF                            XOR     A
  0436    32 6B27                       LD      (RAMT),A
  0439    D5                    AU34:   PUSH    DE
                                        ;CALL   TAS00
  043A    D1                            POP     DE
  043B    FE 3A                         CP      3AH
  043D    D2 046B                       JP      NC,AU370        ; EINGAND > 39H (9)
  0440    FE 08                         CP      08H             ; TAB
  0442    28 10                         JR      Z,AU35
  0444    FE 10                         CP      10H
  0446    DA 04A3                       JP      C,AU40          ; AUSGANG A < 10H
  0449    12                            LD      (DE),A
  044A    13                            INC     DE
  044B    3A 6B27                       LD      A,(RAMT)
  044E    3C                            INC     A
  044F    32 6B27                       LD      (RAMT),A
  0452    18 E5                         JR      AU34
                                
                                        ;------------------
                                        ; ZEICHEN MIT TAB LOESCHEN 
        MACRO-80 3.43   27-Jul-81       PAGE    1-11


  0454    3A 6B27               AU35:   LD      A,(RAMT)
  0457    FE 01                         CP      1
  0459    38 36                         JR      C,AU36
  045B    3D                            DEC     A
  045C    32 6B27                       LD      (RAMT),A
  045F    3E 20                         LD      A,20H
  0461    12                            LD      (DE),A
  0462    CD 056B                       CALL    TEXOUT
  0465    1B                            DEC     DE
  0466    3E 20                         LD      A,20H
  0468    12                            LD      (DE),A
  0469    18 14                         JR      AU37
                                        ;-------------
                                        ; CURSOR LINKS
                                
  046B    3E 1B                 AU370:  LD      A,1BH
  046D    CD 056B                       CALL    TEXOUT
  0470    3E 5B                         LD      A,5BH
  0472    CD 056B                       CALL    TEXOUT
  0475    3E 44                         LD      A,44H
  0477    CD 056B                       CALL    TEXOUT
  047A    3E 20                         LD      A,20H
  047C    CD 056B                       CALL    TEXOUT
  047F    3E 1B                 AU37:   LD      A,1BH
  0481    CD 056B                       CALL    TEXOUT
  0484    3E 5B                         LD      A,5BH
  0486    CD 056B                       CALL    TEXOUT
  0489    3E 44                         LD      A,44H
  048B    CD 056B                       CALL    TEXOUT
  048E    C3 0439                       JP      AU34
                                        ;-------------
                                        ; CURSOR RECHTS
                                
  0491    3E 1B                 AU36:   LD      A,1BH
  0493    CD 056B                       CALL    TEXOUT
  0496    3E 5B                         LD      A,5BH
  0498    CD 056B                       CALL    TEXOUT
  049B    3E 43                         LD      A,43H
  049D    CD 056B                       CALL    TEXOUT
  04A0    C3 0439                       JP      AU34
                                
  04A3    E1                    AU40:   POP     HL
  04A4    23                            INC     HL      ; ZUM ERSTEN ZEICHEN
  04A5    E5                            PUSH    HL
                                        ;---------------------
                                        ; EINGABE L[NGE MIT RAMT VERGLEICHEN
                                        ; EINGABE NICHT LAENGER ALS ...,.. 
  04A6    0E 01                         LD      C,1
  04A8    06 0F                         LD      B,15D
  04AA    7E                    BES00:  LD      A,(HL)
  04AB    FE 3A                         CP      3AH
  04AD    30 09                         JR      NC,BES01        ; ENDE ERREICHT
  04AF    0C                            INC     C       
  04B0    23                            INC     HL
  04B1    10 F7                         DJNZ    BES00
  04B3    E1                    BES99:  POP     HL
        MACRO-80 3.43   27-Jul-81       PAGE    1-12


  04B4    C1                            POP     BC
  04B5    C3 03A6                       JP      AU10            ; KEIN ENDE GEFUNDEN
                                        ;------------------
                                        ; PRUEFE OB EINGANS IN ZEILE PASST ...,..
  04B8    3A 6B27               BES01:  LD      A,(RAMT)
  04BB    E6 7F                         AND     7FH             ; BIT 7 LOESCHEN
  04BD    FE 02                         CP      2H
  04BF    38 F2                         JR      C,BES99
  04C1    B9                            CP      C               ; C= RICHTIG
  04C2    38 03                         JR      C,BES02
  04C4    C2 04B3                       JP      NZ,BES99        ; EINGABE IST GROESSER
                                        ;-------------------
                                        ; EINGABE PASST IN ZEILE 
                                        ; ZEILE ZUORDNEN AUS BLASE 
  04C7    41                    BES02:  LD      B,C
  04C8    2B                    BES03:  DEC     HL
  04C9    7E                            LD      A,(HL)
  04CA    FE 2C                         CP      ','             ; KOMMA SUCHEN
  04CC    28 05                         JR      Z,BES10         ; ',' GEFUNDEN
  04CE    10 F8                         DJNZ    BES03
  04D0    C3 04B3                       JP      BES99   ; WENN KEIN KOMMA GEFUNDEN IN BLASE
                                        ;---------------------
                                        ; RAMT ZUORDNEN
  04D3    3A 6B27               BES10:  LD      A,(RAMT)
  04D6    E6 7F                         AND     7FH             ; BIT 7 LOESCHEN
  04D8    11 6B28                       LD      DE,RAMT+1
  04DB    C5                            PUSH    BC
  04DC    47                            LD      B,A
  04DD    0E 00                         LD      C,0H
  04DF    1A                    BES11:  LD      A,(DE)
  04E0    FE 2C                         CP      ','             ; KOMMA SUCHEN
  04E2    28 1D                         JR      Z,BES19
  04E4    FE 31                         CP      '1'
  04E6    30 11                         JR      NC,BES12
  04E8    79                            LD      A,C
  04E9    FE 00                         CP      0H
  04EB    20 0C                         JR      NZ,BES12
  04ED    13                            INC     DE
  04EE    1A                            LD      A,(DE)
  04EF    FE 2C                         CP      ','             ; KOMMA SUCHEN
  04F1    28 08                         JR      Z,BES13+1
  04F3    1B                            DEC     DE
  04F4    3E 2E                         LD      A,2EH
  04F6    12                            LD      (DE),A
  04F7    18 01                         JR      BES13
  04F9    0C                    BES12:  INC     C
  04FA    13                    BES13:  INC     DE
  04FB    10 E2                         DJNZ    BES11
  04FD    C1                            POP     BC
  04FE    C3 04B3                       JP      BES99           ; WENN IN EINGABE KEIN KOMME GEFUNDEN
                                        ;----------------------
                                        ; EINGABE EINF]GEN
  0501    C1                    BES19:  POP     BC
  0502    23                    BES20:  INC     HL              ; NACHKOMMA STELLEN
  0503    13                            INC     DE              ; NACHKOMMA STELLEN
  0504    7E                            LD      A,(HL)
        MACRO-80 3.43   27-Jul-81       PAGE    1-13


  0505    FE 3A                         CP      3AH
  0507    30 17                         JR      NC,BES24        ; PR]FE ENDE
  0509    1A                            LD      A,(DE)
  050A    FE 30                         CP      '0'
  050C    38 06                         JR      C,BES23         ; WENN <0
  050E    FE 3A                         CP      ':'
  0510    30 02                         JR      NC,BES23
  0512    18 EE                         JR      BES20
  0514    3E 30                 BES23:  LD      A,30H
  0516    12                            LD      (DE),A
  0517    3A 6B27                       LD      A,(RAMT)
  051A    3C                            INC     A
  051B    32 6B27                       LD      (RAMT),A
  051E    18 E2                         JR      BES20
                                        ;---------------
  0520    3A 6B27               BES24:  LD      A,(RAMT)
  0523    E6 7F                         AND     7FH             ; BIT 7 LOESCHEN
  0525    47                            LD      B,A
  0526    2B                            DEC     HL
  0527    1B                            DEC     DE
  0528    1A                    BES21:  LD      A,(DE)
  0529    FE 2C                         CP      ','
  052B    28 06                         JR      Z,BES210
  052D    38 05                         JR      C,BES22
  052F    FE 3A                         CP      ':'
  0531    30 01                         JR      NC,BES22                ; SOLANG BIS KEINE ZAHL MEHR 
  0533    77                    BES210: LD      (HL),A
  0534    1B                    BES22:  DEC     DE
  0535    2B                            DEC     HL
  0536    10 F0                         DJNZ    BES21
  0538    E1                            POP     HL
  0539    C1                            POP     BC
  053A    C3 03A6                       JP      AU10
                                        ;----------
  053D    C1                    AU90:   POP BC
  053E    E1                    AUEND:  POP HL
  053F    D1                            POP DE
  0540    C1                            POP BC
  0541    AF                            XOR A
  0542    32 6B27                       LD (RAMT),A
  0545    3E 00                         LD A,00         ; PROGRAMM START XX
  0547    32 6200                       LD (BLAN),A
  054A    C9                            RET
                                        ;-----------------
  054B    37                    STE:    SCF
  054C    AF                            XOR     A       
  054D    32 6200                       LD      (BLAN),A
  0550    C9                            RET
                                        ;---------------
                                        ; CURSOR OFF END FROM CHARACTER SET
  0551    C5                    CURPOS: PUSH BC
  0552    04                            INC B           ;CHARACTER LENGTH +1
  0553    3E 00                         LD A,00H        ;COUNR FROM 0
  0555    3C                    CURP1:  INC A
  0556    27                            DAA
  0557    10 FC                         DJNZ CURP1
        MACRO-80 3.43   27-Jul-81       PAGE    1-14


  0559    47                            LD B,A
  055A    E6 0F                         AND 0FH
  055C    32 651F                       LD (CURT+3),A
  055F    78                            LD A,B
  0560    0F                            RRCA
  0561    0F                            RRCA
  0562    0F                            RRCA
  0563    0F                            RRCA
  0564    E6 0F                         AND 0FH
  0566    32 651E                       LD (CURT+2),A
  0569    C1                            POP BC
  056A    C9                            RET
                                        ;---------------
                                        ; give up sing in a
                                        ;
  056B    F5                    TEXOUT: PUSH AF
  056C    C5                            PUSH BC
  056D    D5                            PUSH DE
  056E    E5                            PUSH HL
  056F    06 01                         LD B,KEYOUT
  0571    CD 058E                       CALL UPROG2
  0574    CD 057C                       CALL UPROG
  0577    E1                            POP HL
  0578    D1                            POP DE
  0579    C1                            POP BC
  057A    F1                            POP AF
  057B    C9                            RET
                                        ;------------
                                        ; EXECUTE PARAMETER AND JUMP BACK
                                        ;
  057C                          UPROG:  ;       CALL UPROG2
  057C    D5                            PUSH DE         ; DE AS A BACKSPACE ADDRESS ON A STACK
  057D    C9                            RET             ; JUMP (DE)     
                                        ;-------------
                                        ;     
  057E    CD 058E               UPROG1: CALL UPROG2
  0581    D5                            PUSH DE         ; DE AS A BACKSPACE ADDRESS ON A STACK
                                        ;LD BC,HDD      ;(BFRLL)
                                        ;LD DE,0000H    ;(BFRHL)
  0582    ED 4B 6500                    LD BC,(BFRLL)
  0586    ED 5B 6502                    LD DE,(BFRHL)
  058A    21 6000                       LD HL,RAM
  058D    C9                            RET             ; JUMP (DE)             
                                        ;--------------
                                        ; LOAD THE JUMP ADDRESS IN DE
                                        ;
  058E    E5                    UPROG2: PUSH HL
  058F    21 7000                       LD HL,PROG
  0592    11 0003                       LD DE,03H       ; ABSTAND 3BYTE SPRUNGBEFEHL
  0595    19                    SUM:    ADD HL,DE
  0596    10 FD                         DJNZ SUM
  0598    23                            INC HL          ; JP BEFEHL (C3) UEBERSPRINGEN
  0599    5E                            LD E,(HL)
  059A    23                            INC HL
  059B    56                            LD D,(HL)
  059C    E1                            POP HL
        MACRO-80 3.43   27-Jul-81       PAGE    1-15


  059D    C9                            RET
                                ;---------------------------
                                ;
  059E    43 6F 75 6E           TTEX:   DEFM 'Count:'
  05A2    74 3A                 
  0006                          TTLEN   EQU $-TTEX
                                
  05A4    00 00 00 00           BF02:   DEFB 00H,00H,00H,00H
  05A8    00 00 00 00           BF03:   DEFB 00H,00H,00H,00H    
                                
  05AC    1B 5B 02 04           EBUFF:  DEFB 1BH,5BH,02H,04H,3BH,00H,01H,48H
  05B0    3B 00 01 48           
  05B4    1B 5B 33 37                   DEFB 1BH,5BH,33H,37H,6DH
  05B8    6D                    
  05B9    20 20 20 20                   DEFM '                             '
  05BD    20 20 20 20           
  05C1    20 20 20 20           
  05C5    20 20 20 20           
  05C9    20 20 20 20           
  05CD    20 20 20 20           
  05D1    20 20 20 20           
  05D5    20                    
  002A                          EZLEN   EQU $-EBUFF
                                
  05D6    1B 5B 02 04           ABUFF:  DEFB 1BH,5BH,02H,04H,3BH,00H,01H,48H
  05DA    3B 00 01 48           
  05DE    20 20 20 20           AUTEX:  DEFM '                             '
  05E2    20 20 20 20           
  05E6    20 20 20 20           
  05EA    20 20 20 20           
  05EE    20 20 20 20           
  05F2    20 20 20 20           
  05F6    20 20 20 20           
  05FA    20                    
  0025                          AZLEN   EQU $-ABUFF
                                
  05FB    2E 43 4F 4D           AUTO:   DEFM '.COM        '
  05FF    20 20 20 20           
  0603    20 20 20 20           
  0607    0000                  FILEN:  DEFW 0000H
  0609    00                    ZEILEN: DEFB 00H
                                
                                END
        MACRO-80 3.43   27-Jul-81       PAGE    S


Macros:

Symbols:
05D6    ABUFF           039D    AU00            03A1    AU01            
03A6    AU10            03B1    AU11            03B3    AU12            
03BD    AU13            03D9    AU14            03DF    AU20            
03E5    AU21            03E6    AU22            03FB    AU31            
0421    AU32            041E    AU33            0439    AU34            
0454    AU35            0491    AU36            047F    AU37            
046B    AU370           04A3    AU40            053D    AU90            
053E    AUEND           05DE    AUTEX           05FB    AUTO            
0025    AZLEN           04AA    BES00           04B8    BES01           
04C7    BES02           04C8    BES03           04D3    BES10           
04DF    BES11           04F9    BES12           04FA    BES13           
0501    BES19           0502    BES20           0528    BES21           
0533    BES210          0534    BES22           0514    BES23           
0520    BES24           04B3    BES99           05A4    BF02            
05A8    BF03            6503    BFRHH           6502    BFRHL           
6501    BFRLH           6500    BFRLL           650F    BFSHH           
650E    BFSHL           650D    BFSLH           650C    BFSLL           
650B    BFVHH           650A    BFVHL           6509    BFVLH           
6508    BFVLL           6200    BLAN            6205    BSTAT           
0080    BUFF            0416    CAU31           0020    CMD_READSEC     
0030    CMD_WRITESEC    6C3F    COP             0007    CPOS            
0555    CURP1           0551    CURPOS          6518    CURS            
651C    CURT            05AC    EBUFF           002A    EZLEN           
005C    FCB             006B    FCBCR           005D    FCBFN           
0065    FCBFT           007C    FCBRA           0020    FDC             
0311    FI00            037A    FI10            0364    FI60            
0370    FI61            0399    FI99            0108    FIL2            
010F    FIL3            0112    FIL4            0120    FIL5            
0137    FIL6            0144    FIL7            0156    FIL8            
0607    FILEN           0800    HDD             00BE    HDDE            
00F0    IDE             00FD    IDECHI          00FC    IDECLO          
00FF    IDECMD          00F8    IDEDAT          00F6    IDEDOR          
00F9    IDEERR          00FA    IDESCNT         00FE    IDESDH          
00FB    IDESNUM         00FF    IDESTAT         0186    KEY1            
01B7    KEY2            01E9    KEY7            020A    KEY8            
022E    KEY9            0002    KEYIN           0001    KEYOUT          
0060    LCD             042C    LO01            6513    LOGHH           
6512    LOGHL           6511    LOGLH           6510    LOGLL           
0008    LPOS            A101    MMC             0007    MMCE            
001E    PIOB            7000    PROG            0005    P_READ          
0006    P_WRITE         6524    RADR            6000    RAM             
6727    RAMS            6B27    RAMT            6527    RAMV            
0000    RBLAN           0005    RBSTAT          6526    RMEN            
0006    RSOTR           0004    RTERM           6BEF    RTEX            
0002    RTYPE1          0003    RTYPE2          0001    RUSER           
6520    SANDB           0004    SELDM           00F7    SELDS           
054B    STE             01F6    SUCHD           01BE    SUCHE           
01C1    SUCHF           01CF    SUCHG           0595    SUM             
6204    TERM            017A    TEXIN           056B    TEXOUT          
059E    TTEX            0006    TTLEN           034E    TY00            
6202    TYPE1           6203    TYPE2           057C    UPROG           
057E    UPROG1          058E    UPROG2          0080    URCS            
6201    USER            02F3    WINCHA          02F5    WINDO           
023D    WINDOW          02E2    WINOUT          02F1    WINPOS          
        MACRO-80 3.43   27-Jul-81       PAGE    S-1


0262    WINX1           028E    WINX2           02C5    WINX3           
02EF    WINXY           0270    WINY1           0609    ZEILEN          



No Fatal error(s)


                                                                                                                                                                                                                                                                                                   
;-------------------------------------------
; Interrupt Vectors


.ifdef _EZ80190
;UARTs
UART0_IVECT	.equ	%12
UART1_IVECT	.equ	%14


;Ports
PA0_IVECT    .equ   %16
PA1_IVECT    .equ   %18
PA2_IVECT    .equ   %1A
PA3_IVECT    .equ   %1C
PA4_IVECT    .equ   %1E
PA5_IVECT    .equ   %20
PA6_IVECT    .equ   %22
PA7_IVECT    .equ   %24
                        
PB0_IVECT    .equ   %26
PB1_IVECT    .equ   %28
PB2_IVECT    .equ   %2A
PB3_IVECT    .equ   %2C
PB4_IVECT    .equ   %2E
PB5_IVECT    .equ   %30
PB6_IVECT    .equ   %32
PB7_IVECT    .equ   %34
                        
PC0_IVECT    .equ   %36
PC1_IVECT    .equ   %38
PC2_IVECT    .equ   %3A
PC3_IVECT    .equ   %3C
PC4_IVECT    .equ   %3E
PC5_IVECT    .equ   %40
PC6_IVECT    .equ   %42
PC7_IVECT    .equ   %44
                        
PD0_IVECT    .equ   %46
PD1_IVECT    .equ   %48
PD2_IVECT    .equ   %4A
PD3_IVECT    .equ   %4C
PD4_IVECT    .equ   %4E
PD5_IVECT    .equ   %50
PD6_IVECT    .equ   %52
PD7_IVECT    .equ   %54
.endif

.ifdef _EZ80F91
;UARTs
UART0_IVECT	.equ	%70
UART1_IVECT .equ	%74

;Ports
PA0_IVECT    .equ   %80
PA1_IVECT    .equ   %84
PA2_IVECT    .equ   %88
PA3_IVECT    .equ   %8C
PA4_IVECT    .equ   %90
PA5_IVECT    .equ   %94
PA6_IVECT    .equ   %98
PA7_IVECT    .equ   %9C
                        
PB0_IVECT    .equ   %A0
PB1_IVECT    .equ   %A4
PB2_IVECT    .equ   %A8
PB3_IVECT    .equ   %AC
PB4_IVECT    .equ   %B0
PB5_IVECT    .equ   %B4
PB6_IVECT    .equ   %B8
PB7_IVECT    .equ   %BC
                        
PC0_IVECT    .equ   %C0
PC1_IVECT    .equ   %C4
PC2_IVECT    .equ   %C8
PC3_IVECT    .equ   %CC
PC4_IVECT    .equ   %D0
PC5_IVECT    .equ   %D4
PC6_IVECT    .equ   %D8
PC7_IVECT    .equ   %DC
                        
PD0_IVECT    .equ   %E0
PD1_IVECT    .equ   %E4
PD2_IVECT    .equ   %E8
PD3_IVECT    .equ   %EC
PD4_IVECT    .equ   %F0
PD5_IVECT    .equ   %F4
PD6_IVECT    .equ   %F8
PD7_IVECT    .equ   %FC
.endif

.ifdef _EZ80L92
.define INCIVECTS
.endif

.ifdef _EZ80F92
.define INCIVECTS
.endif

.ifdef _EZ80F93
.define INCIVECTS
.endif

.ifdef INCIVECTS
;UARTs
UART0_IVECT	.equ	%18
UART1_IVECT	.equ	%1A

;Ports
PB0_IVECT    .equ   %30
PB1_IVECT    .equ   %32
PB2_IVECT    .equ   %34
PB3_IVECT    .equ   %36
PB4_IVECT    .equ   %38
PB5_IVECT    .equ   %3A
PB6_IVECT    .equ   %3C
PB7_IVECT    .equ   %3E
                       
PC0_IVECT    .equ   %40
PC1_IVECT    .equ   %42
PC2_IVECT    .equ   %44
PC3_IVECT    .equ   %46
PC4_IVECT    .equ   %48
PC5_IVECT    .equ   %4A
PC6_IVECT    .equ   %4C
PC7_IVECT    .equ   %4E
                       
PD0_IVECT    .equ   %50
PD1_IVECT    .equ   %52
PD2_IVECT    .equ   %54
PD3_IVECT    .equ   %56
PD4_IVECT    .equ   %58
PD5_IVECT    .equ   %5A
PD6_IVECT    .equ   %5C
PD7_IVECT    .equ   %5E
.endif

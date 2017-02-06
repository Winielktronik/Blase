;************************************************************************
;*    eZ80L92.inc
;*
;*		eZ80l92 Registers
;************************************************************************

;-------------------------------------------
; Clock and Power-Down

CLK_PPD1:	.equ	%DB
CLK_PPD2:	.equ	%DC

;-------------------------------------------
; General Purpose I/O

PB_DR:		.equ	%9A
PB_DDR:		.equ	%9B
PB_ALT1:	.equ	%9C
PB_ALT2:	.equ	%9D

PC_DR:		.equ	%9E
PC_DDR:		.equ	%9F
PC_ALT1:	.equ	%A0
PC_ALT2:	.equ	%A1

PD_DR:		.equ	%A2
PD_DDR:		.equ	%A3
PD_ALT1:	.equ	%A4
PD_ALT2:	.equ	%A5

;-------------------------------------------
; Chip Select / Wait State Generator

; Keept for Backward Compatability
CS_LBR0:	.equ	%A8
CS_UBR0:	.equ	%A9
CS_CTL0:	.equ	%AA
CS_BMC0:	.equ	%F0

CS_LBR1:	.equ	%AB
CS_UBR1:	.equ	%AC
CS_CTL1:	.equ	%AD
CS_BMC1:	.equ	%F1

CS_LBR2:	.equ	%AE
CS_UBR2:	.equ	%AF
CS_CTL2:	.equ	%B0
CS_BMC2:	.equ	%F2

CS_LBR3:	.equ	%B1
CS_UBR3:	.equ	%B2
CS_CTL3:	.equ	%B3
CS_BMC3:	.equ	%F3

; Manual Naming Convention
CS0_LBR:	.equ	%A8
CS0_UBR:	.equ	%A9
CS0_CTL:	.equ	%AA
CS0_BMC:	.equ	%F0

CS1_LBR:	.equ	%AB
CS1_UBR:	.equ	%AC
CS1_CTL:	.equ	%AD
CS1_BMC:	.equ	%F1

CS2_LBR:	.equ	%AE
CS2_UBR:	.equ	%AF
CS2_CTL:	.equ	%B0
CS2_BMC:	.equ	%F2

CS3_LBR:	.equ	%B1
CS3_UBR:	.equ	%B2
CS3_CTL:	.equ	%B3
CS3_BMC:	.equ	%F3

;-------------------------------------------
; Watch Dog Timer

WDT_CTL:	.equ	%93
WDT_RR:		.equ	%94

;-------------------------------------------
; Programmable Reload Timers

TMR_CTL0:	.equ	%80
TMR_DRL0:	.equ	%81
TMR_DRH0:	.equ	%82
TMR_RRL0:	.equ	%81
TMR_RRH0:	.equ	%82

TMR_CTL1:	.equ	%83
TMR_DRL1:	.equ	%84
TMR_DRH1:	.equ	%85
TMR_RRL1:	.equ	%84
TMR_RRH1:	.equ	%85

TMR_CTL2:	.equ	%86
TMR_DRL2:	.equ	%87
TMR_DRH2:	.equ	%88
TMR_RRL2:	.equ	%87
TMR_RRH2:	.equ	%88

TMR_CTL3:	.equ	%89
TMR_DRL3:	.equ	%8A
TMR_DRH3:	.equ	%8B
TMR_RRL3:	.equ	%8A
TMR_RRH3:	.equ	%8B

TMR_CTL4:	.equ	%8C
TMR_DRL4:	.equ	%8D
TMR_DRH4:	.equ	%8E
TMR_RRL4:	.equ	%8D
TMR_RRH4:	.equ	%8E

TMR_CTL5:	.equ	%8F
TMR_DRL5:	.equ	%90
TMR_DRH5:	.equ	%91
TMR_RRL5:	.equ	%90
TMR_RRH5:	.equ	%91

;-- Manual Naming

TMR0_CTL:	.equ	%80
TMR0_DR_L:	.equ	%81
TMR0_DR_H:	.equ	%82
TMR0_RR_L:	.equ	%81
TMR0_RR_H:	.equ	%82

TMR1_CTL:	.equ	%83
TMR1_DR_L:	.equ	%84
TMR1_DR_H:	.equ	%85
TMR1_RR_L:	.equ	%84
TMR1_RR_H:	.equ	%85

TMR2_CTL:	.equ	%86
TMR2_DR_L:	.equ	%87
TMR2_DR_H:	.equ	%88
TMR2_RR_L:	.equ	%87
TMR2_RR_H:	.equ	%88

TMR3_CTL:	.equ	%89
TMR3_DR_L:	.equ	%8A
TMR3_DR_H:	.equ	%8B
TMR3_RR_L:	.equ	%8A
TMR3_RR_H:	.equ	%8B

TMR4_CTL:	.equ	%8C
TMR4_DR_L:	.equ	%8D
TMR4_DR_H:	.equ	%8E
TMR4_RR_L:	.equ	%8D
TMR4_RR_H:	.equ	%8E

TMR5_CTL:	.equ	%8F
TMR5_DR_L:	.equ	%90
TMR5_DR_H:	.equ	%91
TMR5_RR_L:	.equ	%90
TMR5_RR_H:	.equ	%91

TMR_ISS:	.equ	%92


;-------------------------------------------
; Real-Time Clock

RTC_SEC:	.equ	%E0
RTC_MIN:	.equ	%E1
RTC_HRS:	.equ	%E2
RTC_DOW:	.equ	%E3
RTC_DOM:	.equ	%E4
RTC_MON:	.equ	%E5
RTC_YR:		.equ	%E6
RTC_CEN:	.equ	%E7
RTC_ASEC:	.equ	%E8
RTC_AMIN:	.equ	%E9
RTC_AHRS:	.equ	%EA
RTC_ADOW:	.equ	%EB
RTC_CTRL:	.equ	%ED
RTC_ACTRL:	.equ	%EC

;-------------------------------------------
; UARTs

UART_BRGL0:	.equ	%C0
UART_BRGH0:	.equ	%C1
UART_RBR0:	.equ	%C0
UART_THR0:	.equ	%C0
UART_IER0:	.equ	%C1
UART_IIR0:	.equ	%C2
UART_FCTL0:	.equ	%C2
UART_LCTL0:	.equ	%C3
UART_MCTL0:	.equ	%C4
UART_LSR0:	.equ	%C5
UART_MSR0:	.equ	%C6
UART_SPR0:	.equ	%C7

UART_BRGL1:	.equ	%D0
UART_BRGH1:	.equ	%D1
UART_RBR1:	.equ	%D0
UART_THR1:	.equ	%D0
UART_IER1:	.equ	%D1
UART_IIR1:	.equ	%D2
UART_FCTL1:	.equ	%D2
UART_LCTL1:	.equ	%D3
UART_MCTL1:	.equ	%D4
UART_LSR1:	.equ	%D5
UART_MSR1:	.equ	%D6
UART_SPR1:	.equ	%D7

;-- Correct Naming

UART0_BRG_L:	.equ	%C0
UART0_BRG_H:	.equ	%C1
UART0_RBR:	.equ	%C0
UART0_THR:	.equ	%C0
UART0_IER:	.equ	%C1
UART0_IIR:	.equ	%C2
UART0_FCTL:	.equ	%C2
UART0_LCTL:	.equ	%C3
UART0_MCTL:	.equ	%C4
UART0_LSR:	.equ	%C5
UART0_MSR:	.equ	%C6
UART0_SPR:	.equ	%C7

UART1_BRG_L:	.equ	%D0
UART1_BRG_H:	.equ	%D1
UART1_RBR:	.equ	%D0
UART1_THR:	.equ	%D0
UART1_IER:	.equ	%D1
UART1_IIR:	.equ	%D2
UART1_FCTL:	.equ	%D2
UART1_LCTL:	.equ	%D3
UART1_MCTL:	.equ	%D4
UART1_LSR:	.equ	%D5
UART1_MSR:	.equ	%D6
UART1_SPR:	.equ	%D7
;-------------------------------------------
; IrDA

IR_CTL:	.equ	%BF

;-------------------------------------------
; SPI

SPI_BRGL:	.equ	%B8
SPI_BRG_L:	.equ	%B8
SPI_BRGH:	.equ	%B9
SPI_BRG_H:	.equ	%B9
SPI_CTL:	.equ	%BA
SPI_SR:		.equ	%BB
SPI_TSR:	.equ	%BC
SPI_RBR:	.equ	%BC

;-------------------------------------------
; I2C

I2C_SAR:	.equ	%C8
I2C_XSAR:	.equ	%C9
I2C_DR:		.equ	%CA
I2C_CTL:	.equ	%CB
I2C_SR:		.equ	%CC
I2C_CCR:	.equ	%CC
I2C_SRR:	.equ	%CD

;-------------------------------------------



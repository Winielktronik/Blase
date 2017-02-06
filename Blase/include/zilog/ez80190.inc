;************************************************************************
;* eZ80190.inc
;*
;*
;************************************************************************

;-------------------------------------------
; Programmable Reload Counter/Timers

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
TMR_DRL3:	.equ	%8a
TMR_DRH3:	.equ	%8b
TMR_RRL3:	.equ	%8a
TMR_RRH3:	.equ	%8b

TMR_CTL4:	.equ	%8c
TMR_DRL4:	.equ	%8d
TMR_DRH4:	.equ	%8e
TMR_RRL4:	.equ	%8d
TMR_RRH4:	.equ	%8e

TMR_CTL5:	.equ	%8f
TMR_DRL5:	.equ	%90
TMR_DRH5:	.equ	%91
TMR_RRL5:	.equ	%90
TMR_RRH5:	.equ	%91

TMR0_DRL:	.equ	%81
TMR0_DRH:	.equ	%82
TMR0_RRL:	.equ	%81
TMR0_RRH:	.equ	%82

TMR1_DRL:	.equ	%84
TMR1_DRH:	.equ	%85
TMR1_RRL:	.equ	%84
TMR1_RRH:	.equ	%85

TMR2_DRL:	.equ	%87
TMR2_DRH:	.equ	%88
TMR2_RRL:	.equ	%87
TMR2_RRH:	.equ	%88

TMR3_DRL:	.equ	%8a
TMR3_DRH:	.equ	%8b
TMR3_RRL:	.equ	%8a
TMR3_RRH:	.equ	%8b

TMR4_DRL:	.equ	%8d
TMR4_DRH:	.equ	%8e
TMR4_RRL:	.equ	%8d
TMR4_RRH:	.equ	%8e

TMR5_DRL:	.equ	%90
TMR5_DRH:	.equ	%91
TMR5_RRL:	.equ	%90
TMR5_RRH:	.equ	%91

; specified naming

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
TMR3_DR_L:	.equ	%8a
TMR3_DR_H:	.equ	%8b
TMR3_RR_L:	.equ	%8a
TMR3_RR_H:	.equ	%8b

TMR4_CTL:	.equ	%8c
TMR4_DR_L:	.equ	%8d
TMR4_DR_H:	.equ	%8e
TMR4_RR_L:	.equ	%8d
TMR4_RR_H:	.equ	%8e

TMR5_CTL:	.equ	%8f
TMR5_DR_L:	.equ	%90
TMR5_DR_H:	.equ	%91
TMR5_RR_L:	.equ	%90
TMR5_RR_H:	.equ	%91

;-------------------------------------------
; Watch Dog Timer

WDT_CTL:	.equ	%93
WDT_RR:		.equ	%94

;-------------------------------------------
; General Purpose I/O

PA_DR:		.equ	%96
PA_DDR:		.equ	%97
PA_ALT1:	.equ	%98
PA_ALT2:	.equ	%99

PB_DR:		.equ	%9a
PB_DDR:		.equ	%9b
PB_ALT1:	.equ	%9c
PB_ALT2:	.equ	%9d

PC_DR:		.equ	%9e
PC_DDR:		.equ	%9f
PC_ALT1:	.equ	%a0
PC_ALT2:	.equ	%a1

PD_DR:		.equ	%a2
PD_DDR:		.equ	%a3
PD_ALT1:	.equ	%a4
PD_ALT2:	.equ	%a5

;-------------------------------------------
; Chip Select / Wait State Generator
; Name kept for bacward compatibility
CS_LBR0:	.equ	%a8
CS_UBR0:	.equ	%a9
CS_CTL0:	.equ	%aa

CS_LBR1:	.equ	%ab
CS_UBR1:	.equ	%ac
CS_CTL1:	.equ	%ad

CS_LBR2:	.equ	%ae
CS_UBR2:	.equ	%af
CS_CTL2:	.equ	%b0

CS_LBR3:	.equ	%b1
CS_UBR3:	.equ	%b2
CS_CTL3:	.equ	%b3

; specified naming

CS0_LBR:	.equ	%a8
CS0_UBR:	.equ	%a9
CS0_CTL:	.equ	%aa

CS1_LBR:	.equ	%ab
CS1_UBR:	.equ	%ac
CS1_CTL:	.equ	%ad

CS2_LBR:	.equ	%ae
CS2_UBR:	.equ	%af
CS2_CTL:	.equ	%b0

CS3_LBR:	.equ	%b1
CS3_UBR:	.equ	%b2
CS3_CTL:	.equ	%b3


;-------------------------------------------
; Ram Control

RAM_CTL0:	.equ	%b4
RAM_CTL1:	.equ	%b5

; specified naming
RAM_CTL:	.equ	%b4
RAM_ADDR_U:	.equ	%b5

;-------------------------------------------
; Universal Zilog Interface

SPI_CTL0:	.equ	%b6
SPI_SR0:	.equ	%b7
SPI_RBR0:	.equ	%b8
SPI_TSR0:	.equ	%b8

SPI_CTL1:	.equ	%ba
SPI_SR1:	.equ	%bb
SPI_RBR1:	.equ	%bc
SPI_TSR1:	.equ	%bc

BRG_DLRL0:	.equ	%c0
BRG_DLRH0:	.equ	%c1
UART_RBR0:	.equ	%c0
UART_THR0:	.equ	%c0
UART_IER0:	.equ	%c1
UART_IIR0:	.equ	%c2
UART_FCTL0:	.equ	%c2
UART_LCTL0:	.equ	%c3
UART_MCTL0:	.equ	%c4
UART_LSR0:	.equ	%c5
UART_MSR0:	.equ	%c6
UART_SPR0:	.equ	%c7
I2C_SAR0:	.equ	%c8
I2C_XSAR0:	.equ	%c9
I2C_DR0:	.equ	%ca
I2C_CTL0:	.equ	%cb
I2C_SR0:	.equ	%cc
I2C_CCR0:	.equ	%cc
I2C_SRR0:	.equ	%cd
UZI_CTL0:	.equ	%cf

BRG_DLRL1:	.equ	%d0
BRG_DLRH1:	.equ	%d1
UART_RBR1:	.equ	%d0
UART_THR1:	.equ	%d0
UART_IER1:	.equ	%d1
UART_IIR1:	.equ	%d2
UART_FCTL1:	.equ	%d2
UART_LCTL1:	.equ	%d3
UART_MCTL1:	.equ	%d4
UART_LSR1:	.equ	%d5
UART_MSR1:	.equ	%d6
UART_SPR1:	.equ	%d7
I2C_SAR1:	.equ	%d8
I2C_XSAR1:	.equ	%d9
I2C_DR1:	.equ	%da
I2C_CTL1:	.equ	%db
I2C_SR1:	.equ	%dc
I2C_CCR1:	.equ	%dc
I2C_SRR1:	.equ	%dd
UZI_CTL1:	.equ	%df


;-------------------------------------------
; Universal Zilog Interface

SPI0_CTL:	.equ	%b6
SPI0_SR:	.equ	%b7
SPI0_RBR:	.equ	%b8
SPI0_TSR:	.equ	%b8

SPI1_CTL:	.equ	%ba
SPI1_SR:	.equ	%bb
SPI1_RBR:	.equ	%bc
SPI1_TSR:	.equ	%bc

BRG0_DLR_L:	.equ	%c0
BRG0_DLR_H:	.equ	%c1
UART0_RBR:	.equ	%c0
UART0_THR:	.equ	%c0
UART0_IER:	.equ	%c1
UART0_IIR:	.equ	%c2
UART0_FCTL:	.equ	%c2
UART0_LCTL:	.equ	%c3
UART0_MCTL:	.equ	%c4
UART0_LSR:	.equ	%c5
UART0_MSR:	.equ	%c6
UART0_SPR:	.equ	%c7
I2C0_SAR:	.equ	%c8
I2C0_XSAR:	.equ	%c9
I2C0_xSAR:	.equ	%c9
I2C0_DR:	.equ	%ca
I2C0_CTL:	.equ	%cb
I2C0_SR:	.equ	%cc
I2C0_CCR:	.equ	%cc
I2C0_SRR:	.equ	%cd
UZI0_CTL:	.equ	%cf

BRG1_DLR_L:	.equ	%d0
BRG1_DLR_H:	.equ	%d1
UART1_RBR:	.equ	%d0
UART1_THR:	.equ	%d0
UART1_IER:	.equ	%d1
UART1_IIR:	.equ	%d2
UART1_FCTL:	.equ	%d2
UART1_LCTL:	.equ	%d3
UART1_MCTL:	.equ	%d4
UART1_LSR:	.equ	%d5
UART1_MSR:	.equ	%d6
UART1_SPR:	.equ	%d7
I2C1_SAR:	.equ	%d8
I2C1_XSAR:	.equ	%d9
I2C1_xSAR:	.equ	%d9
I2C1_DR:	.equ	%da
I2C1_CTL:	.equ	%db
I2C1_SR:	.equ	%dc
I2C1_CCR:	.equ	%dc
I2C1_SRR:	.equ	%dd
UZI1_CTL:	.equ	%df

;-------------------------------------------
; Multiply Accumulator

MAC_XSTART:	.equ	%e0
MAC_XEND:	.equ	%e1
MAC_XRELOAD:	.equ	%e2
MAC_LENGTH:	.equ	%e3
MAC_YSTART:	.equ	%e4
MAC_YEND:	.equ	%e5
MAC_YRELOAD:	.equ	%e6
MAC_CTL:	.equ	%e7
MAC_AC0:	.equ	%e8
MAC_AC1:	.equ	%e9
MAC_AC2:	.equ	%ea
MAC_AC3:	.equ	%eb
MAC_AC4:	.equ	%ec
MAC_SR:		.equ	%ed

; specified naming

MACC_xSTART:	.equ	%e0
MACC_xEND:	.equ	%e1
MACC_xRELOAD:	.equ	%e2
MACC_LENGTH:	.equ	%e3
MACC_ySTART:	.equ	%e4
MACC_yEND:	.equ	%e5
MACC_yRELOAD:	.equ	%e6
MACC_CTL:	.equ	%e7
MACC_AC0:	.equ	%e8
MACC_AC1:	.equ	%e9
MACC_AC2:	.equ	%ea
MACC_AC3:	.equ	%eb
MACC_AC4:	.equ	%ec
MACC_STAT:	.equ	%ed

;-------------------------------------------
; DMA Controller

DMA_SARL0:	.equ	%ee
DMA_SARM0:	.equ	%ef
DMA_SARH0:	.equ	%f0
DMA_DARL0:	.equ	%f1
DMA_DARM0:	.equ	%f2
DMA_DARH0:	.equ	%f3
DMA_BCL0:	.equ	%f4
DMA_BCH0:	.equ	%f5
DMA_CTL0:	.equ	%f6

DMA_SARL1:	.equ	%f7
DMA_SARM1:	.equ	%f8
DMA_SARH1:	.equ	%f9
DMA_DARL1:	.equ	%fa
DMA_DARM1:	.equ	%fb
DMA_DARH1:	.equ	%fc
DMA_BCL1:	.equ	%fd
DMA_BCH1:	.equ	%fe
DMA_CTL1:	.equ	%ff

;-------------------------------------------
; DMA Controller Manual

DMA0_SAR_L:	.equ	%ee
DMA0_SAR_H:	.equ	%ef
DMA0_SAR_U:	.equ	%f0
DMA0_DAR_L:	.equ	%f1
DMA0_DAR_H:	.equ	%f2
DMA0_DAR_U:	.equ	%f3
DMA0_BC_L:	.equ	%f4
DMA0_BC_H:	.equ	%f5
DMA0_CTL:	.equ	%f6

DMA1_SAR_L:	.equ	%f7
DMA1_SAR_H:	.equ	%f8
DMA1_SAR_U:	.equ	%f9
DMA1_DAR_L:	.equ	%fa
DMA1_DAR_H:	.equ	%fb
DMA1_DAR_U:	.equ	%fc
DMA1_BC_L:	.equ	%fd
DMA1_BC_H:	.equ	%fe
DMA1_CTL:	.equ	%ff

;-------------------------------------------



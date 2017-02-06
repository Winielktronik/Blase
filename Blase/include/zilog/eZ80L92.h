/*****************************************************************************
 *  Copyright (C) 1999-2008 by  Zilog, Inc.
 *  All Rights Reserved
 *****************************************************************************/
#ifndef __eZ80L92_included
#define __eZ80L92_included


/* Programmable Reload Counter/Timers */
#define TMR0_CTL        (*(volatile unsigned char __INTIO *)0x80)
#define TMR0_DR_L       (*(volatile unsigned char __INTIO *)0x81)
#define TMR0_RR_L       (*(volatile unsigned char __INTIO *)0x81)
#define TMR0_DR_H       (*(volatile unsigned char __INTIO *)0x82)
#define TMR0_RR_H       (*(volatile unsigned char __INTIO *)0x82)
#define TMR1_CTL        (*(volatile unsigned char __INTIO *)0x83)
#define TMR1_DR_L       (*(volatile unsigned char __INTIO *)0x84)
#define TMR1_RR_L       (*(volatile unsigned char __INTIO *)0x84)
#define TMR1_DR_H       (*(volatile unsigned char __INTIO *)0x85)
#define TMR1_RR_H       (*(volatile unsigned char __INTIO *)0x85)
#define TMR2_CTL        (*(volatile unsigned char __INTIO *)0x86)
#define TMR2_DR_L       (*(volatile unsigned char __INTIO *)0x87)
#define TMR2_RR_L       (*(volatile unsigned char __INTIO *)0x87)
#define TMR2_DR_H       (*(volatile unsigned char __INTIO *)0x88)
#define TMR2_RR_H       (*(volatile unsigned char __INTIO *)0x88)
#define TMR3_CTL        (*(volatile unsigned char __INTIO *)0x89)
#define TMR3_DR_L       (*(volatile unsigned char __INTIO *)0x8A)
#define TMR3_RR_L       (*(volatile unsigned char __INTIO *)0x8A)
#define TMR3_DR_H       (*(volatile unsigned char __INTIO *)0x8B)
#define TMR3_RR_H       (*(volatile unsigned char __INTIO *)0x8B)
#define TMR4_CTL        (*(volatile unsigned char __INTIO *)0x8C)
#define TMR4_DR_L       (*(volatile unsigned char __INTIO *)0x8D)
#define TMR4_RR_L       (*(volatile unsigned char __INTIO *)0x8D)
#define TMR4_DR_H       (*(volatile unsigned char __INTIO *)0x8E)
#define TMR4_RR_H       (*(volatile unsigned char __INTIO *)0x8E)
#define TMR5_CTL        (*(volatile unsigned char __INTIO *)0x8F)
#define TMR5_DR_L       (*(volatile unsigned char __INTIO *)0x90)
#define TMR5_RR_L       (*(volatile unsigned char __INTIO *)0x90)
#define TMR5_DR_H       (*(volatile unsigned char __INTIO *)0x91)
#define TMR5_RR_H       (*(volatile unsigned char __INTIO *)0x91)
#define TMR_ISS         (*(volatile unsigned char __INTIO *)0x92)

/* Watch-Dog Timer */
#define WDT_CTL         (*(volatile unsigned char __INTIO *)0x93)
#define WDT_RR          (*(volatile unsigned char __INTIO *)0x94)

/* General-Purpose Input/Output Ports */
#define PB_DR           (*(volatile unsigned char __INTIO *)0x9A)
#define PB_DDR          (*(volatile unsigned char __INTIO *)0x9B)
#define PB_ALT1         (*(volatile unsigned char __INTIO *)0x9C)
#define PB_ALT2         (*(volatile unsigned char __INTIO *)0x9D)
#define PC_DR           (*(volatile unsigned char __INTIO *)0x9E)
#define PC_DDR          (*(volatile unsigned char __INTIO *)0x9F)
#define PC_ALT1         (*(volatile unsigned char __INTIO *)0xA0)
#define PC_ALT2         (*(volatile unsigned char __INTIO *)0xA1)
#define PD_DR           (*(volatile unsigned char __INTIO *)0xA2)
#define PD_DDR          (*(volatile unsigned char __INTIO *)0xA3)
#define PD_ALT1         (*(volatile unsigned char __INTIO *)0xA4)
#define PD_ALT2         (*(volatile unsigned char __INTIO *)0xA5)

/* Chip Select/Wait State Generator */
#define CS0_LBR         (*(volatile unsigned char __INTIO *)0xA8)
#define CS0_UBR         (*(volatile unsigned char __INTIO *)0xA9)
#define CS0_CTL         (*(volatile unsigned char __INTIO *)0xAA)
#define CS1_LBR         (*(volatile unsigned char __INTIO *)0xAB)
#define CS1_UBR         (*(volatile unsigned char __INTIO *)0xAC)
#define CS1_CTL         (*(volatile unsigned char __INTIO *)0xAD)
#define CS2_LBR         (*(volatile unsigned char __INTIO *)0xAE)
#define CS2_UBR         (*(volatile unsigned char __INTIO *)0xAF)
#define CS2_CTL         (*(volatile unsigned char __INTIO *)0xB0)
#define CS3_LBR         (*(volatile unsigned char __INTIO *)0xB1)
#define CS3_UBR         (*(volatile unsigned char __INTIO *)0xB2)
#define CS3_CTL         (*(volatile unsigned char __INTIO *)0xB3)

/* Serial Peripheral Interface */
#define SPI_BRG_L       (*(volatile unsigned char __INTIO *)0xB8)
#define SPI_BRG_H       (*(volatile unsigned char __INTIO *)0xB9)
#define SPI_CTL         (*(volatile unsigned char __INTIO *)0xBA)
#define SPI_SR          (*(volatile unsigned char __INTIO *)0xBB)
#define SPI_TSR         (*(volatile unsigned char __INTIO *)0xBC)
#define SPI_RBR         (*(volatile unsigned char __INTIO *)0xBC)

/* Infrared Encoder/Decoder */
#define IR_CTL          (*(volatile unsigned char __INTIO *)0xBF)

/* Universal Asynchronous Receiver/Transmitter 0 (UART0) */
#define UART0_RBR       (*(volatile unsigned char __INTIO *)0xC0)
#define UART0_THR       (*(volatile unsigned char __INTIO *)0xC0)
#define UART0_BRG_L     (*(volatile unsigned char __INTIO *)0xC0)
#define UART0_IER       (*(volatile unsigned char __INTIO *)0xC1)
#define UART0_BRG_H     (*(volatile unsigned char __INTIO *)0xC1)
#define UART0_IIR       (*(volatile unsigned char __INTIO *)0xC2)
#define UART0_FCTL      (*(volatile unsigned char __INTIO *)0xC2)
#define UART0_LCTL      (*(volatile unsigned char __INTIO *)0xC3)
#define UART0_MCTL      (*(volatile unsigned char __INTIO *)0xC4)
#define UART0_LSR       (*(volatile unsigned char __INTIO *)0xC5)
#define UART0_MSR       (*(volatile unsigned char __INTIO *)0xC6)
#define UART0_SPR       (*(volatile unsigned char __INTIO *)0xC7)

/* Inter-Integrated Circuit Bus Control (I2C) */
#define I2C_SAR         (*(volatile unsigned char __INTIO *)0xC8)
#define I2C_XSAR        (*(volatile unsigned char __INTIO *)0xC9)
#define I2C_DR          (*(volatile unsigned char __INTIO *)0xCA)
#define I2C_CTL         (*(volatile unsigned char __INTIO *)0xCB)
#define I2C_SR          (*(volatile unsigned char __INTIO *)0xCC)
#define I2C_CCR         (*(volatile unsigned char __INTIO *)0xCC)
#define I2C_SRR         (*(volatile unsigned char __INTIO *)0xCD)

/* Universal Asynchronous Receiver/Transmitter 1 (UART1) */
#define UART1_RBR       (*(volatile unsigned char __INTIO *)0xD0)
#define UART1_THR       (*(volatile unsigned char __INTIO *)0xD0)
#define UART1_BRG_L     (*(volatile unsigned char __INTIO *)0xD0)
#define UART1_IER       (*(volatile unsigned char __INTIO *)0xD1)
#define UART1_BRG_H     (*(volatile unsigned char __INTIO *)0xD1)
#define UART1_IIR       (*(volatile unsigned char __INTIO *)0xD2)
#define UART1_FCTL      (*(volatile unsigned char __INTIO *)0xD2)
#define UART1_LCTL      (*(volatile unsigned char __INTIO *)0xD3)
#define UART1_MCTL      (*(volatile unsigned char __INTIO *)0xD4)
#define UART1_LSR       (*(volatile unsigned char __INTIO *)0xD5)
#define UART1_MSR       (*(volatile unsigned char __INTIO *)0xD6)
#define UART1_SPR       (*(volatile unsigned char __INTIO *)0xD7)

/* Low-Power Control */
#define CLK_PPD1        (*(volatile unsigned char __INTIO *)0xDB)
#define CLK_PPD2        (*(volatile unsigned char __INTIO *)0xDC)

/* Real-Time Clock */
#define RTC_SEC         (*(volatile unsigned char __INTIO *)0xE0)
#define RTC_MIN         (*(volatile unsigned char __INTIO *)0xE1)
#define RTC_HRS         (*(volatile unsigned char __INTIO *)0xE2)
#define RTC_DOW         (*(volatile unsigned char __INTIO *)0xE3)
#define RTC_DOM         (*(volatile unsigned char __INTIO *)0xE4)
#define RTC_MON         (*(volatile unsigned char __INTIO *)0xE5)
#define RTC_YR          (*(volatile unsigned char __INTIO *)0xE6)
#define RTC_CEN         (*(volatile unsigned char __INTIO *)0xE7)
#define RTC_ASEC        (*(volatile unsigned char __INTIO *)0xE8)
#define RTC_AMIN        (*(volatile unsigned char __INTIO *)0xE9)
#define RTC_AHRS        (*(volatile unsigned char __INTIO *)0xEA)
#define RTC_ADOW        (*(volatile unsigned char __INTIO *)0xEB)
#define RTC_ACTRL       (*(volatile unsigned char __INTIO *)0xEC)
#define RTC_CTRL        (*(volatile unsigned char __INTIO *)0xED)

/* Chip Select Bus Mode Control */
#define CS0_BMC         (*(volatile unsigned char __INTIO *)0xF0)
#define CS1_BMC         (*(volatile unsigned char __INTIO *)0xF1)
#define CS2_BMC         (*(volatile unsigned char __INTIO *)0xF2)
#define CS3_BMC         (*(volatile unsigned char __INTIO *)0xF3)


/* Unspecified register definitions, retained for compatibility */
#define TMR_CTL0        TMR0_CTL
#define TMR_DRL0        TMR0_DR_L
#define TMR_RRL0        TMR0_RR_L
#define TMR_DRH0        TMR0_DR_H
#define TMR_RRH0        TMR0_RR_H
#define TMR_CTL1        TMR1_CTL
#define TMR_DRL1        TMR1_DR_L
#define TMR_RRL1        TMR1_RR_L
#define TMR_DRH1        TMR1_DR_H
#define TMR_RRH1        TMR1_RR_H
#define TMR_CTL2        TMR2_CTL
#define TMR_DRL2        TMR2_DR_L
#define TMR_RRL2        TMR2_RR_L
#define TMR_DRH2        TMR2_DR_H
#define TMR_RRH2        TMR2_RR_H
#define TMR_CTL3        TMR3_CTL
#define TMR_DRL3        TMR3_DR_L
#define TMR_RRL3        TMR3_RR_L
#define TMR_DRH3        TMR3_DR_H
#define TMR_RRH3        TMR3_RR_H
#define TMR_CTL4        TMR4_CTL
#define TMR_DRL4        TMR4_DR_L
#define TMR_RRL4        TMR4_RR_L
#define TMR_DRH4        TMR4_DR_H
#define TMR_RRH4        TMR4_RR_H
#define TMR_CTL5        TMR5_CTL
#define TMR_DRL5        TMR5_DR_L
#define TMR_RRL5        TMR5_RR_L
#define TMR_DRH5        TMR5_DR_H
#define TMR_RRH5        TMR5_RR_H
#define CS_LBR0         CS0_LBR
#define CS_UBR0         CS0_UBR
#define CS_CTL0         CS0_CTL
#define CS_LBR1         CS1_LBR
#define CS_UBR1         CS1_UBR
#define CS_CTL1         CS1_CTL
#define CS_LBR2         CS2_LBR
#define CS_UBR2         CS2_UBR
#define CS_CTL2         CS2_CTL
#define CS_LBR3         CS3_LBR
#define CS_UBR3         CS3_UBR
#define CS_CTL3         CS3_CTL
#define SPI_BRGL        SPI_BRG_L
#define SPI_BRGH        SPI_BRG_H
#define UART_RBR0       UART0_RBR
#define UART_THR0       UART0_THR
#define UART_BRGL0      UART0_BRG_L
#define UART_IER0       UART0_IER
#define UART_BRGH0      UART0_BRG_H
#define UART_IIR0       UART0_IIR
#define UART_FCTL0      UART0_FCTL
#define UART_LCTL0      UART0_LCTL
#define UART_MCTL0      UART0_MCTL
#define UART_LSR0       UART0_LSR
#define UART_MSR0       UART0_MSR
#define UART_SPR0       UART0_SPR
#define UART_RBR1       UART1_RBR
#define UART_THR1       UART1_THR
#define UART_BRGL1      UART1_BRG_L
#define UART_IER1       UART1_IER
#define UART_BRGH1      UART1_BRG_H
#define UART_IIR1       UART1_IIR
#define UART_FCTL1      UART1_FCTL
#define UART_LCTL1      UART1_LCTL
#define UART_MCTL1      UART1_MCTL
#define UART_LSR1       UART1_LSR
#define UART_MSR1       UART1_MSR
#define UART_SPR1       UART1_SPR
#define CS_BMC0         CS0_BMC
#define CS_BMC1         CS1_BMC
#define CS_BMC2         CS2_BMC
#define CS_BMC3         CS3_BMC


/* Deprecated, this section may be uncommented by the user if necessary
// Number of interrupt vectors supported by CPU. Defined in startup.asm
extern unsigned short _num_vectors;

#define FALSE    0
#define TRUE     1
#define ERROR   -1

typedef unsigned char bool;
typedef unsigned char byte;
typedef unsigned short word;
typedef unsigned long dword;
/* */


#define _ei() asm("\tEI\n")
#define _di() asm("\tDI\n")

#define _asm asm


typedef volatile unsigned char __INTIO *ISFR;
typedef volatile unsigned char __EXTIO *XSFR;


/* Initializes the vector table with the default handler */
void _init_default_vectors(void);

/* Assigns a service routine to an interrupt vector */
void *_set_vector(unsigned int, void (*)(void));

/************************************************************************/
/* Interrupt vector offsets for set_vector                              */
/************************************************************************/
#define PRT0_IVECT			0x0A
#define PRT1_IVECT			0x0C
#define PRT2_IVECT			0x0E
#define PRT3_IVECT			0x10
#define PRT4_IVECT			0x12
#define PRT5_IVECT			0x14

#define RTC_IVECT			0x16

#if !defined(UART0_IVECT) /*If it already defined using uart.h*/
#define UART0_IVECT			0x18
#endif
#if !defined(UART1_IVECT) /*If it already defined using uart.h*/
#define UART1_IVECT			0x1A
#endif

#define I2C_IVECT			0x1C
#define SPI_IVECT			0x1E

#define PORTB0_IVECT		0x30
#define PORTB1_IVECT		0x32
#define PORTB2_IVECT		0x34
#define PORTB3_IVECT		0x36
#define PORTB4_IVECT		0x38
#define PORTB5_IVECT		0x3A
#define PORTB6_IVECT		0x3C
#define PORTB7_IVECT		0x3E

#define PORTC0_IVECT		0x40
#define PORTC1_IVECT		0x42
#define PORTC2_IVECT		0x44
#define PORTC3_IVECT		0x46
#define PORTC4_IVECT		0x48
#define PORTC5_IVECT		0x4A
#define PORTC6_IVECT		0x4C
#define PORTC7_IVECT		0x4E

#define PORTD0_IVECT		0x50
#define PORTD1_IVECT		0x52
#define PORTD2_IVECT		0x54
#define PORTD3_IVECT		0x56
#define PORTD4_IVECT		0x58
#define PORTD5_IVECT		0x5A
#define PORTD6_IVECT		0x5C
#define PORTD7_IVECT		0x5E

#endif  /* __eZ80l92_included */

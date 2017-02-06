/*****************************************************************************
 *  Copyright (C) 1999-2008 by  Zilog, Inc.
 *  All Rights Reserved
 *****************************************************************************/
#ifndef __eZ80190_included
#define __eZ80190_included


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

/* Watch-Dog Timer */
#define WDT_CTL         (*(volatile unsigned char __INTIO *)0x93)
#define WDT_RR          (*(volatile unsigned char __INTIO *)0x94)

/* General-Purpose Input/Output Ports */
#define PA_DR           (*(volatile unsigned char __INTIO *)0x96)
#define PA_DDR          (*(volatile unsigned char __INTIO *)0x97)
#define PA_ALT1         (*(volatile unsigned char __INTIO *)0x98)
#define PA_ALT2         (*(volatile unsigned char __INTIO *)0x99)
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

/* On-Chip Random Access Memory Control */
#define RAM_CTL         (*(volatile unsigned char __INTIO *)0xB4)
#define RAM_ADDR_U      (*(volatile unsigned char __INTIO *)0xB5)

/* Serial Peripheral Interfaces */
#define SPI0_CTL        (*(volatile unsigned char __INTIO *)0xB6)
#define SPI0_SR         (*(volatile unsigned char __INTIO *)0xB7)
#define SPI0_RBR        (*(volatile unsigned char __INTIO *)0xB8)
#define SPI0_TSR        (*(volatile unsigned char __INTIO *)0xB8)
#define SPI1_CTL        (*(volatile unsigned char __INTIO *)0xBA)
#define SPI1_SR         (*(volatile unsigned char __INTIO *)0xBB)
#define SPI1_RBR        (*(volatile unsigned char __INTIO *)0xBC)
#define SPI1_TSR        (*(volatile unsigned char __INTIO *)0xBC)

/* Universal Asynchronous Receiver/Transmitter 0 (UART0) */
#define UART0_RBR       (*(volatile unsigned char __INTIO *)0xC0)
#define UART0_THR       (*(volatile unsigned char __INTIO *)0xC0)
#define BRG0_DLR_L      (*(volatile unsigned char __INTIO *)0xC0)
#define UART0_IER       (*(volatile unsigned char __INTIO *)0xC1)
#define BRG0_DLR_H      (*(volatile unsigned char __INTIO *)0xC1)
#define UART0_IIR       (*(volatile unsigned char __INTIO *)0xC2)
#define UART0_FCTL      (*(volatile unsigned char __INTIO *)0xC2)
#define UART0_LCTL      (*(volatile unsigned char __INTIO *)0xC3)
#define UART0_MCTL      (*(volatile unsigned char __INTIO *)0xC4)
#define UART0_LSR       (*(volatile unsigned char __INTIO *)0xC5)
#define UART0_MSR       (*(volatile unsigned char __INTIO *)0xC6)
#define UART0_SPR       (*(volatile unsigned char __INTIO *)0xC7)

/* Inter-Integrated Circuit Bus Control 0 (I2C0) */
#define I2C0_SAR        (*(volatile unsigned char __INTIO *)0xC8)
#define I2C0_xSAR       (*(volatile unsigned char __INTIO *)0xC9)
#define I2C0_DR         (*(volatile unsigned char __INTIO *)0xCA)
#define I2C0_CTL        (*(volatile unsigned char __INTIO *)0xCB)
#define I2C0_SR         (*(volatile unsigned char __INTIO *)0xCC)
#define I2C0_CCR        (*(volatile unsigned char __INTIO *)0xCC)
#define I2C0_SRR        (*(volatile unsigned char __INTIO *)0xCD)

/* Universal Zilog Interface 0 */
#define UZI0_CTL        (*(volatile unsigned char __INTIO *)0xCF)

/* Universal Asynchronous Receiver/Transmitter 1 (UART1) */
#define UART1_RBR       (*(volatile unsigned char __INTIO *)0xD0)
#define UART1_THR       (*(volatile unsigned char __INTIO *)0xD0)
#define BRG1_DLR_L      (*(volatile unsigned char __INTIO *)0xD0)
#define UART1_IER       (*(volatile unsigned char __INTIO *)0xD1)
#define BRG1_DLR_H      (*(volatile unsigned char __INTIO *)0xD1)
#define UART1_IIR       (*(volatile unsigned char __INTIO *)0xD2)
#define UART1_FCTL      (*(volatile unsigned char __INTIO *)0xD2)
#define UART1_LCTL      (*(volatile unsigned char __INTIO *)0xD3)
#define UART1_MCTL      (*(volatile unsigned char __INTIO *)0xD4)
#define UART1_LSR       (*(volatile unsigned char __INTIO *)0xD5)
#define UART1_MSR       (*(volatile unsigned char __INTIO *)0xD6)
#define UART1_SPR       (*(volatile unsigned char __INTIO *)0xD7)

/* Inter-Integrated Circuit Bus Control 1 (I2C1) */
#define I2C1_SAR        (*(volatile unsigned char __INTIO *)0xD8)
#define I2C1_xSAR       (*(volatile unsigned char __INTIO *)0xD9)
#define I2C1_DR         (*(volatile unsigned char __INTIO *)0xDA)
#define I2C1_CTL        (*(volatile unsigned char __INTIO *)0xDB)
#define I2C1_SR         (*(volatile unsigned char __INTIO *)0xDC)
#define I2C1_CCR        (*(volatile unsigned char __INTIO *)0xDC)
#define I2C1_SRR        (*(volatile unsigned char __INTIO *)0xDD)

/* Universal Zilog Interface 1 */
#define UZI1_CTL        (*(volatile unsigned char __INTIO *)0xDF)

/* Multiply-Accumulator */
#define MACC_xSTART     (*(volatile unsigned char __INTIO *)0xE0)
#define MACC_xEND       (*(volatile unsigned char __INTIO *)0xE1)
#define MACC_xRELOAD    (*(volatile unsigned char __INTIO *)0xE2)
#define MACC_LENGTH     (*(volatile unsigned char __INTIO *)0xE3)
#define MACC_ySTART     (*(volatile unsigned char __INTIO *)0xE4)
#define MACC_yEND       (*(volatile unsigned char __INTIO *)0xE5)
#define MACC_yRELOAD    (*(volatile unsigned char __INTIO *)0xE6)
#define MACC_CTL        (*(volatile unsigned char __INTIO *)0xE7)
#define MACC_AC0        (*(volatile unsigned char __INTIO *)0xE8)
#define MACC_AC1        (*(volatile unsigned char __INTIO *)0xE9)
#define MACC_AC2        (*(volatile unsigned char __INTIO *)0xEA)
#define MACC_AC3        (*(volatile unsigned char __INTIO *)0xEB)
#define MACC_AC4        (*(volatile unsigned char __INTIO *)0xEC)
#define MACC_STAT       (*(volatile unsigned char __INTIO *)0xED)

/* Direct Memory Access Controllers */
#define DMA0_SAR_L      (*(volatile unsigned char __INTIO *)0xEE)
#define DMA0_SAR_H      (*(volatile unsigned char __INTIO *)0xEF)
#define DMA0_SAR_U      (*(volatile unsigned char __INTIO *)0xF0)
#define DMA0_DAR_L      (*(volatile unsigned char __INTIO *)0xF1)
#define DMA0_DAR_H      (*(volatile unsigned char __INTIO *)0xF2)
#define DMA0_DAR_U      (*(volatile unsigned char __INTIO *)0xF3)
#define DMA0_BC_L       (*(volatile unsigned char __INTIO *)0xF4)
#define DMA0_BC_H       (*(volatile unsigned char __INTIO *)0xF5)
#define DMA0_CTL        (*(volatile unsigned char __INTIO *)0xF6)
#define DMA1_SAR_L      (*(volatile unsigned char __INTIO *)0xF7)
#define DMA1_SAR_H      (*(volatile unsigned char __INTIO *)0xF8)
#define DMA1_SAR_U      (*(volatile unsigned char __INTIO *)0xF9)
#define DMA1_DAR_L      (*(volatile unsigned char __INTIO *)0xFA)
#define DMA1_DAR_H      (*(volatile unsigned char __INTIO *)0xFB)
#define DMA1_DAR_U      (*(volatile unsigned char __INTIO *)0xFC)
#define DMA1_BC_L       (*(volatile unsigned char __INTIO *)0xFD)
#define DMA1_BC_H       (*(volatile unsigned char __INTIO *)0xFE)
#define DMA1_CTL        (*(volatile unsigned char __INTIO *)0xFF)


/* Unspecified register definitions, retained for compatibility */
#define PIDLOW          (*(volatile unsigned char __INTIO *)0x00)
#define PIDHI           (*(volatile unsigned char __INTIO *)0x01)
#define PIDREV          (*(volatile unsigned char __INTIO *)0x02)
#define TMR0_CT_L       TMR0_CTL
#define TMR0_DRL        TMR0_DR_L
#define TMR0_RRL        TMR0_RR_L
#define TMR0_DRH        TMR0_DR_H
#define TMR0_RRH        TMR0_RR_H
#define TMR1_CT_L       TMR1_CTL
#define TMR1_DRL        TMR1_DR_L
#define TMR1_RRL        TMR1_RR_L
#define TMR1_DRH        TMR1_DR_H
#define TMR1_RRH        TMR1_RR_H
#define TMR2_CT_L       TMR2_CTL
#define TMR2_DRL        TMR2_DR_L
#define TMR2_RRL        TMR2_RR_L
#define TMR2_DRH        TMR2_DR_H
#define TMR2_RRH        TMR2_RR_H
#define TMR3_CT_L       TMR3_CTL
#define TMR3_RRL        TMR3_DR_L
#define TMR3_DRL        TMR3_RR_L
#define TMR3_DRH        TMR3_DR_H
#define TMR3_RRH        TMR3_RR_H
#define TMR4_CT_L       TMR4_CTL
#define TMR4_DRL        TMR4_DR_L
#define TMR4_RRL        TMR4_RR_L
#define TMR4_DRH        TMR4_DR_H
#define TMR4_RRH        TMR4_RR_H
#define TMR5_CT_L       TMR5_CTL
#define TMR5_DRL        TMR5_DR_L
#define TMR5_RRL        TMR5_RR_L
#define TMR5_DRH        TMR5_DR_H
#define TMR5_RRH        TMR5_RR_H
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
#define RAM_CTL0        RAM_CTL
#define RAM_CTL1        RAM_ADDR_U
#define UZI_SPI0        SPI0_CTL
#define UZI0_SPI        SPI0_CTL
#define UZI_SPI1        SPI1_CTL
#define UZI1_SPI        SPI1_CTL
#define UZI_UART0       (*(volatile unsigned char __INTIO *)0xC0)
#define UZI0_UART       (*(volatile unsigned char __INTIO *)0xC0)
#define UZI_I2C0        I2C0_SAR
#define UZI0_I2C        I2C0_SAR
#define I2C0_XSAR       I2C0_xSAR
#define UZI_CTL0        UZI0_CTL
#define UZI_UART1       (*(volatile unsigned char __INTIO *)0xD0)
#define UZI1_UART       (*(volatile unsigned char __INTIO *)0xD0)
#define UZI_I2C1        I2C1_SAR
#define UZI1_I2C        I2C1_SAR
#define I2C1_XSAR       I2C1_xSAR
#define UZI_CTL1        UZI1_CTL


/* Deprecated, this section may be uncommented by the user if necessary
// Include uartdefs.h to include some of the definitions related to uart.
// These definitions originally in this file are now moved to uart.h.
#include <uartdefs.h>

// Number of interrupt vectors supported by CPU. Defined in startup.asm
extern unsigned short _num_vectors;

// Interrupt vector table offsets
// These are offsets into __vector_ptr table
// which contains JP <addr24>
#define MACC            0x00
#define DMA0            0x04
#define DMA1            0x08
#define TMR0            0x10
#define TMR1            0x14
#define TMR2            0x18
#define TMR3            0x20
#define TMR4            0x24
#define TMR5            0x28
#define UZI0            0x30
#define UZI1            0x34
#define PA0             0x38
#define PA1             0x40
#define PA2             0x44
#define PA3             0x48
#define PA4             0x50
#define PA5             0x54
#define PA6             0x58
#define PA7             0x60
#define PB0             0x64
#define PB1             0x68
#define PB2             0x70
#define PB3             0x74
#define PB4             0x78
#define PB5             0x80
#define PB6             0x84
#define PB7             0x88
#define PC0             0x90
#define PC1             0x94
#define PC2             0x98
#define PC3             0xa0
#define PC4             0xa4
#define PC5             0xa8
#define PC6             0xb0
#define PC7             0xb4
#define PD0             0xb8
#define PD1             0xc0
#define PD2             0xc4
#define PD3             0xc8
#define PD4             0xd0
#define PD5             0xd4
#define PD6             0xd8
#define PD7             0xe0
#define RSV1            0xe4
#define RSV2            0xe8
#define RSV3            0xf0
#define RSV4            0xf4
#define RSV5            0xf8
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
#define MACC_IVECT		0x00
#define DMA0_IVECT		0x02
#define DMA1_IVECT		0x04

#define PRT0_IVECT		0x06
#define PRT1_IVECT		0x08
#define PRT2_IVECT		0x0A
#define PRT3_IVECT		0x0C
#define PRT4_IVECT		0x0E
#define PRT5_IVECT		0x10

#define UZI0_IVECT		0x12
#define UZI1_IVECT		0x14

#define PORTA0_IVECT	0x16
#define PORTA1_IVECT	0x18
#define PORTA2_IVECT	0x1A
#define PORTA3_IVECT	0x1C
#define PORTA4_IVECT	0x1E
#define PORTA5_IVECT	0x20
#define PORTA6_IVECT	0x22
#define PORTA7_IVECT	0x24

#define PORTB0_IVECT	0x26
#define PORTB1_IVECT	0x28
#define PORTB2_IVECT	0x2A
#define PORTB3_IVECT	0x2C
#define PORTB4_IVECT	0x2E
#define PORTB5_IVECT	0x30
#define PORTB6_IVECT	0x32
#define PORTB7_IVECT	0x34

#define PORTC0_IVECT	0x36
#define PORTC1_IVECT	0x38
#define PORTC2_IVECT	0x3A
#define PORTC3_IVECT	0x3C
#define PORTC4_IVECT	0x3E
#define PORTC5_IVECT	0x40
#define PORTC6_IVECT	0x42
#define PORTC7_IVECT	0x44

#define PORTD0_IVECT	0x46
#define PORTD1_IVECT	0x48
#define PORTD2_IVECT	0x4A
#define PORTD3_IVECT	0x4C
#define PORTD4_IVECT	0x4E
#define PORTD5_IVECT	0x50
#define PORTD6_IVECT	0x52
#define PORTD7_IVECT	0x54

/* for backward compatibility */
#if !defined(UART0_IVECT) /*If it already defined using uart.h*/
#define UART0_IVECT		UZI0_IVECT
#endif
#if !defined(UART1_IVECT) /*If it already defined using uart.h*/
#define UART1_IVECT		UZI1_IVECT
#endif
/* for backward compatibility */

#endif  /* __eZ80190_included */


/*======================================================================
								       
		     Copyright (C) 1998-2003 by			       
		            ZiLOG, Inc.
			All Rights Reserved			       
							 	       
========================================================================*/

/*Update ISFR use without base, XSFR use with base. 12-15-02*/

#define _ei() asm("\tEI\n")
#define _di() asm("\tDI\n")

#define _asm asm

// Initializes the vector tables to the default handler
// This subroutine is called by startup.asm before calling
// main()
extern void _init_default_vectors(void);

// Function to set up interrupt vectors
extern void _set_vector(unsigned short vector,void (*hndlr)(void));

// Number of interrupt vectors supported by CPU. Defined in startup.asm
extern unsigned short _num_vectors;

typedef volatile unsigned char __INTIO *ISFR;
typedef volatile unsigned char __EXTIO *XSFR;

/* Onchip register definitions */
/* Product Id */

#define PIDLOW		(*(ISFR)0x00)
#define PIDHI		(*(ISFR)0x01)
#define PIDREV		(*(ISFR)0x02)

/**********************Moved to ez80190B.h *************/

/* Timer 0 */
#define TMR0_CTL	(*(ISFR)0x80)
#define TMR0_DRL	(*(ISFR)0x81)
#define TMR0_DRH	(*(ISFR)0x82)
#define TMR0_RRL	(*(ISFR)0x81)
#define TMR0_RRH	(*(ISFR)0x82)

/* Timer 0 For compatibility with Prod Spec ez80190. hhl */

#define TMR0_CT_L       (*(ISFR)0x80)
#define TMR0_DR_L	(*(ISFR)0x81)
#define TMR0_DR_H	(*(ISFR)0x82)
#define TMR0_RR_L	(*(ISFR)0x81)
#define TMR0_RR_H	(*(ISFR)0x82)

/* Timer 1 */
#define TMR1_CTL	(*(ISFR)0x83)
#define TMR1_DRL	(*(ISFR)0x84)
#define TMR1_DRH	(*(ISFR)0x85)
#define TMR1_RRL	(*(ISFR)0x84)
#define TMR1_RRH	(*(ISFR)0x85)

/* Timer 1 For compatibility with Prod Spec ez80190. hhl*/

#define TMR1_CT_L   	(*(ISFR)0x83)
#define TMR1_DR_L	(*(ISFR)0x84)
#define TMR1_DR_H	(*(ISFR)0x85)
#define TMR1_RR_L	(*(ISFR)0x84)
#define TMR1_RR_H	(*(ISFR)0x85)

/* Timer 2 */
#define TMR2_CTL	(*(ISFR)0x86)
#define TMR2_DRL	(*(ISFR)0x87)
#define TMR2_DRH	(*(ISFR)0x88)
#define TMR2_RRL	(*(ISFR)0x87)
#define TMR2_RRH	(*(ISFR)0x88)

/* Timer 2 For compatibility with Prod Spec ez80190. hhl*/

#define TMR2_DR_L	(*(ISFR)0x87)
#define TMR2_DR_H	(*(ISFR)0x88)
#define TMR2_RR_L	(*(ISFR)0x87)
#define TMR2_RR_H	(*(ISFR)0x88)

/* Timer 3 */
#define TMR3_CTL	(*(ISFR)0x89)
#define TMR3_DRL	(*(ISFR)0x8A)
#define TMR3_DRH	(*(ISFR)0x8B)
#define TMR3_RRL	(*(ISFR)0x8A)
#define TMR3_RRH	(*(ISFR)0x8B)

/* Timer 3 For compatibility with Prod Spec ez80190. hhl*/

#define TMR3_CT_L   	(*(ISFR)0x89)
#define TMR3_DR_L	(*(ISFR)0x8A)
#define TMR3_DR_H	(*(ISFR)0x8B)
#define TMR3_RR_L	(*(ISFR)0x8A)
#define TMR3_RR_H	(*(ISFR)0x8B)

/* Timer 4 */
#define TMR4_CTL	(*(ISFR)0x8C)
#define TMR4_DRL	(*(ISFR)0x8D)
#define TMR4_DRH	(*(ISFR)0x8E)
#define TMR4_RRL	(*(ISFR)0x8D)
#define TMR4_RRH	(*(ISFR)0x8E)

/* Timer 4 For compatibility with Prod Spec ez80190. hhl*/

#define TMR4_CT_L   	(*(ISFR)0x8c)
#define TMR4_DR_L	(*(ISFR)0x8D)
#define TMR4_DR_H	(*(ISFR)0x8E)
#define TMR4_RR_L	(*(ISFR)0x8D)
#define TMR4_RR_H	(*(ISFR)0x8E)

/* Timer 5 */
#define TMR5_CTL	(*(ISFR)0x8F)
#define TMR5_DRL	(*(ISFR)0x90)
#define TMR5_DRH	(*(ISFR)0x91)
#define TMR5_RRL	(*(ISFR)0x90)
#define TMR5_RRH	(*(ISFR)0x91)

/* Timer 5 For compatibility with Prod Spec ez80190. hhl*/

#define TMR5_CT_L       (*(ISFR)0x8f)
#define TMR5_DR_L	(*(ISFR)0x90)
#define TMR5_DR_H	(*(ISFR)0x91)
#define TMR5_RR_L	(*(ISFR)0x90)
#define TMR5_RR_H	(*(ISFR)0x91)

/* GPIO */
#define PA_DR		(*(ISFR)0x96)
#define PA_DDR		(*(ISFR)0x97)
#define PA_ALT1		(*(ISFR)0x98)
#define PA_ALT2		(*(ISFR)0x99)

/* RAM Control */
#define RAM_CTL0	(*(ISFR)0xB4)
#define RAM_CTL1	(*(ISFR)0xB5)

/* RAM Control For compatibility with Prod Spec. hhl*/
#define RAM_CTL		(*(ISFR)0xB4)
#define RAM_ADDR_U	(*(ISFR)0xB5)
/******************************************/

/*Update ISFR use without base, XSFR use with base. 12-15-02*/
/* UZI */
#define UZI_SPI0	(*(ISFR)0xb6)
#define UZI_UART0	(*(ISFR)0xc0)
#define UZI_I2C0	(*(ISFR)0xc8)

#define UZI_CTL0	(*(ISFR)0xcf)
#define UZI_SPI1	(*(ISFR)0xba)
#define UZI_UART1	(*(ISFR)0xd0)
#define UZI_I2C1	(*(ISFR)0xd8)
#define UZI_CTL1	(*(ISFR)0xdf)

#define UZI0_SPI	(*(ISFR)0xb6)
#define UZI0_UART	(*(ISFR)0xc0)
#define UZI0_I2C	(*(ISFR)0xc8)
#define UZI0_CTL	(*(ISFR)0xcf)

#define UZI1_SPI	(*(ISFR)0xba)
#define UZI1_UART	(*(ISFR)0xd0)
#define UZI1_I2C	(*(ISFR)0xd8)
#define UZI1_CTL	(*(ISFR)0xdf)

#define UART_RBR(base)	(*((XSFR)(base+0)))
#define UART_THR(base)	(*((XSFR)(base+0)))
#define BRG_DLRL(base)	(*((XSFR)(base+0)))
#define BRG_DLRH(base)	(*((XSFR)(base+1)))
#define UART_IER(base)	(*((XSFR)(base+1)))
#define UART_IIR(base)	(*((XSFR)(base+2)))
#define UART_FCTL(base)	(*((XSFR)(base+2)))
#define UART_LCTL(base)	(*((XSFR)(base+3)))
#define UART_MCTL(base)	(*((XSFR)(base+4)))
#define UART_LSR(base)	(*((XSFR)(base+5)))
#define UART_MSR(base)	(*((XSFR)(base+6)))
#define UART_SPR(base)	(*((XSFR)(base+7)))
#define I2C_xSAR(base)	(*((XSFR)(base+1)))
#define UZI_CTL(base)	(*((XSFR)(base)))

/* UART_IER bits */
#define UART_IER_MIIE		0x08
#define UART_IER_LSIE		0x04
#define UART_IER_TIE		0x02
#define UART_IER_RIE		0x01

/* UART_IIR bits */
#define UART_IIR_FIFOEN		0xC0
#define UART_IIR_ISCMASK	0x0E
#define UART_IIR_RLS		0x06
#define UART_IIR_RDR		0x04
#define UART_IIR_CTO		0x0C
#define UART_IIR_TBE		0x02
#define UART_IIR_MS			0x00
#define UART_IIR_INTBIT		0x01

/* UART_FCTL bits */
#define UART_FCTL_TRIGMASK	0x00
#define UART_FCTL_TRIG_1	0x00
#define UART_FCTL_TRIG_4	0x40
#define UART_FCTL_TRIG_8	0x80
#define UART_FCTL_TRIG_14	0xC0
#define UART_FCTL_CLRTXF	0x04
#define UART_FCTL_CLRRXF	0x02
#define UART_FCTL_FIFOEN	0x01

/* UART_LCTL bits */
#define UART_LCTL_DLAB		0x80
#define UART_LCTL_SB		0x40 /* Send Break */
#define UART_UART_LCTL_FPE	0x20 /* Force Parity Error */
#define UART_LCTL_EPS		0x10 /* Even Parity */
#define UART_LCTL_PEN		0x08 /* Parity Enable */
#define UART_LCTL_2STOPBITS	0x04
#define UART_LCTL_5DATABITS	0x00
#define UART_LCTL_6DATABITS	0x01
#define UART_LCTL_7DATABITS	0x02
#define UART_LCTL_8DATABITS	0x03

/* UART_MCTL bits */
#define UART_MCTL_LOOP	0x10
#define UART_MCTL_OUT2	0x08
#define UART_MCTL_OUT1	0x04
#define UART_MCTL_RTS	0x02
#define UART_MCTL_DTR	0x01

/* UART_LSR bits */
#define UART_LSR_ERR	0x80
#define UART_LSR_TEMT	0x40
#define UART_LSR_THRE	0x20
#define UART_LSR_BI		0x10
#define UART_LSR_FE		0x08
#define UART_LSR_PE		0x04
#define UART_LSR_OE		0x02
#define UART_LSR_DR		0x01

/* UART_MSR bits */
#define UART_MSR_DCD	0x80
#define UART_MSR_RI		0x40
#define UART_MSR_DSR	0x20
#define UART_MSR_CTS	0x10
#define UART_MSR_DDCD	0x08
#define UART_MSR_TERI	0x04
#define UART_MSR_DDSR	0x02
#define UART_MSR_DCTS	0x01

/* TMR_CTL bits */
#define TMR_IRQ			0x80
#define TMR_IRQ_EN		0x40
#define TMR_BRK_CTL		0x20
#define TMR_MULT_SING	0x10
#define TMR_CLKDIV_MASK	0x0C
#define TMR_CLKDIV_2	0x00
#define TMR_CLKDIV_4	0x04
#define TMR_CLKDIV_8	0x08
#define TMR_CLKDIV_16	0x0C
#define TMR_LDRST		0x02
#define TMR_ENABLE		0x01

/* WDT_CTL bits */
#define WDT_CTL_EN		0x80
#define WDT_CTL_NMI		0x40
#define WDT_CTL_TWO18	0x03
#define WDT_CTL_TWO22	0x02
#define WDT_CTL_TWO25	0x01
#define WDT_CTL_TWO27	0x00

/* Interrupt vector table offsets            */
/* These are offsets into __vector_ptr table */
/* which contains JP <addr24>                */
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


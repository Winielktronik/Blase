/*======================================================================
								       
		     Copyright (C) 1998-2003 by			       
		            ZiLOG, Inc.
			All Rights Reserved			       
							 	       
========================================================================
                                eZ80

				<ez80190B.h>

=======================================================================*/
#define PB_DR		(*(ISFR)0x9A)
#define PB_DDR		(*(ISFR)0x9B)
#define PB_ALT1		(*(ISFR)0x9C)
#define PB_ALT2		(*(ISFR)0x9D)
#define PC_DR		(*(ISFR)0x9E)
#define PC_DDR		(*(ISFR)0x9F)
#define PC_ALT1		(*(ISFR)0xA0)
#define PC_ALT2		(*(ISFR)0xA1)
#define PD_DR		(*(ISFR)0xA2)
#define PD_DDR		(*(ISFR)0xA3)
#define PD_ALT1		(*(ISFR)0xA4)
#define PD_ALT2		(*(ISFR)0xA5)

/* Chip Select */
#define CS_LBR0		(*(ISFR)0xA8)
#define CS_UBR0		(*(ISFR)0xA9)
#define CS_CTL0		(*(ISFR)0xAA)
#define CS_LBR1		(*(ISFR)0xAB)
#define CS_UBR1		(*(ISFR)0xAC)
#define CS_CTL1		(*(ISFR)0xAD)
#define CS_LBR2		(*(ISFR)0xAE)
#define CS_UBR2		(*(ISFR)0xAF)
#define CS_CTL2		(*(ISFR)0xB0)
#define CS_LBR3		(*(ISFR)0xB1)
#define CS_UBR3		(*(ISFR)0xB2)
#define CS_CTL3		(*(ISFR)0xB3)

; Manual Definition
#define CS0_LBR		(*(ISFR)0xA8)
#define CS0_UBR		(*(ISFR)0xA9)
#define CS0_CTL		(*(ISFR)0xAA)
#define CS1_LBR		(*(ISFR)0xAB)
#define CS1_UBR		(*(ISFR)0xAC)
#define CS1_CTL		(*(ISFR)0xAD)
#define CS2_LBR		(*(ISFR)0xAE)
#define CS2_UBR		(*(ISFR)0xAF)
#define CS2_CTL		(*(ISFR)0xB0)
#define CS3_LBR		(*(ISFR)0xB1)
#define CS3_UBR		(*(ISFR)0xB2)
#define CS3_CTL		(*(ISFR)0xB3)

#define SPI_CTL(base)	(*((XSFR)(base+0)))
#define SPI_SR(base)	(*((XSFR)(base+1)))
#define SPI_RBR(base)	(*((XSFR)(base+2)))
#define SPI_TSR(base)	(*((XSFR)(base+2)))

#define I2C_SAR(base)	(*((XSFR)(base+0)))
#define I2C_DR(base)	(*((XSFR)(base+2)))
#define I2C_CTL(base)	(*((XSFR)(base+3)))
#define I2C_SR(base)	(*((XSFR)(base+4)))
#define I2C_CCR(base)	(*((XSFR)(base+4)))
#define I2C_SRR(base)	(*((XSFR)(base+5)))

/* Watch Dog Timer */
#define WDT_CTL		(*(ISFR)0x93)
#define WDT_RR		(*(ISFR)0x94)

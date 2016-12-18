/*!\file gpio.h
 * \brief Definition file for the Z84C15 ZILOG / Toshiba.
 *
 *
 *  Copyright (C) 2014 by  Hansjörg Winterhalter
 *  All Rights Reserved.
 */

/**
 * \ingroup GLCD
 */
//! @{
//! Macro definitions.


//#ifndef _GPIO_H_
//#define _GPIO_H_

#include <defines.h>
#include <ez80.h>



#ifndef _Z84C15_included
#define _Z84C15_included

#define CTC_CH0			(*(volatile unsigned char __INTIO *)0x10)	//!< The CTC chanal 0 for eZ84C15.
#define CTC_CH1			(*(volatile unsigned char __INTIO *)0x11)	//!< The CTC chanal 1 for eZ84C15.
#define CTC_CH2			(*(volatile unsigned char __INTIO *)0x12)	//!< The CTC chanal 2 for eZ84C15.
#define CTC_CH3			(*(volatile unsigned char __INTIO *)0x13)	//!< The CTC chanal 3 for eZ84C15.
#define CTC_CH0_INTADR	(*(volatile unsigned char __INTIO *)0x10)	//!< The CTC chanal 0 Interrupt Register for eZ84C15.

#define CTC_CH0_VECTOR		0x00		//!< The CTC chanal 0 Vector  for eZ84C15.    xxxxx000
#define CTC_CH1_INTADR		0x02		//!< The CTC chanal 1 Vector  for eZ84C15.    xxxxx010
#define CTC_CH2_INTADR		0x04		//!< The CTC chanal 2 Vector  for eZ84C15.    xxxxx100
#define CTC_CH3_INTADR		0x06		//!< The CTC chanal 3 Vector  for eZ84C15.    xxxxx110

#define CTC_INT				7			//!< The CTC Interrupt     (D7) for eZ84C15.
#define CTC_CLK_MODE		6			//!< The CTC COUNTER/TIMER (D6) for eZ84C15.
#define CTC_PRESCAL			5			//!< The CTC Prescaler 16    (D5) for eZ84C15.
#define CTC_EDGE			4			//!< The CTC Edge          (D4) for eZ84C15.
#define CTC_TRIGGER			3			//!< The CTC Trigger       (D3) for eZ84C15.
#define CTC_TIMECONST		2			//!< The CTC Time constant (D2) for eZ84C15.
#define CTC_RESET			1			//!< The CTC Reset		   (D1) for eZ84C15.

#endif

#ifdef _Z84C15_IORQ
#define SDC				(*(volatile unsigned char __EXTIO *)0x20)	//!< The MMC-Karte Intern for eZ84C15.
#define IDE				(*(volatile unsigned char __EXTIO *)0x40)	//!< Extern for eZ84C15.
#define LCD_CMD			(*(volatile unsigned char __EXTIO *)0x60)	//!< The LCD Intern for eZ84C15 Command.
#define LCD_DAT			(*(volatile unsigned char __EXTIO *)0x61)	//!< The LCD Intern for eZ84C15. Daten
#define URCS			(*(volatile unsigned char __EXTIO *)0x80)	//!< Uhr mit 2K SRAM intern for eZ84C15.
#define LATCH			(*(volatile unsigned char __EXTIO *)0xF5)	//!< ECB-Bus Karten selekt for Z84C15 System.

#define SET_LCDDAT( x )	( LCD_DAT = (x) )		//!< Set Port A Data Register with the value specified by argument \a x.

#endif



#ifdef _Z84C15_SIO
#define SIOA_DATA		(*(volatile unsigned char __INTIO *)0x18)	//!< The SIO A Data for eZ84C15.
#define SIOA_COM		(*(volatile unsigned char __INTIO *)0x19)	//!< The SIO A Command for eZ84C15.

#define SIOB_DATA		(*(volatile unsigned char __INTIO *)0x1A)	//!< The SIO B Data for eZ84C15.
#define SIOB_COM		(*(volatile unsigned char __INTIO *)0x1B)	//!< The SIO B Command for eZ84C15.

#endif

#ifdef _Z84C15_PIO
#define PIOA_DATA		(*(volatile unsigned char __INTIO *)0x1C) 	//!< The Port A Data for eZ84C15.
#define PIOA_COM		(*(volatile unsigned char __INTIO *)0x1D) 	//!< The Port A Command for eZ84C15.

#define PIOB_DATA		(*(volatile unsigned char __INTIO *)0x1E) //	0x1E			//!< The Port B Data for eZ84C15.
#define PIOB_COM		(*(volatile unsigned char __INTIO *)0x1F) //	0x1F			//!< The Port B Command for eZ84C15.

#define PIOB_MODE0			0x0F			//!< The Port Mode 0 for eZ84C15.
#define PIOB_MODE1			0x4F			//!< The Port Mode 1 for eZ84C15.
#define PIOB_MODE2			0x8F			//!< The Port Mode 2 for eZ84C15.
#define PIOB_MODE3			0xCF			//!< The Port Mode 3 for eZ84C15.

#define PIO_VECTOR			0x1E			//!< The Port Vectoe D0=0 for eZ84C15.

#endif

#ifdef _Z84C15_WATCH_DOG
#define WATCH_DOG_MODE	(*(volatile unsigned char __INTIO *)0xF0)	//!< The Watch Dog Timer Stand-by mode Register for eZ84C15.
#define WATCH_DOG_COM	(*(volatile unsigned char __INTIO *)0xF1)	//!< The Watch Dog Timer Command Register for eZ84C15.

#define DAISY_CHAINE	(*(volatile unsigned char __INTIO *)0xF4)	//!< The Daisy-chaine interrupt precedence Register for eZ84C15.			

#endif /* Z84c15 included */
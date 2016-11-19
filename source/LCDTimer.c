/*****************************************************************************
 * LcdTimer.c
 *
 * routines for timing the LED Matrix and wait routine
 *****************************************************************************
 * Copyright (C) 2005 by ZiLOG, Inc.  All Rights Reserved.
 *****************************************************************************/

#include <ez80.h>
#include "C:\Program Files (x86)\Zilog\ZDSII_eZ80Acclaim!_5.2.1\samples\Blase\include\LCDMatrix.h"
#include "Z84C15.h"

int timer;

void * set_vector(unsigned int vector,void (*hndlr)(void));

/* masterclock and timer 2 interrupt vectors for the various devices */
#ifdef _EZ80F91
#define SYSTEMCLOCK 50000000
#define TMR2_IVECT 0x5c
#endif

#ifdef _EZ80F93
#define SYSTEMCLOCK 20000000
#define TMR2_IVECT 0x0e
#endif

#ifdef _EZ80F92
#define SYSTEMCLOCK 20000000
#define TMR2_IVECT 0x0e
#endif

#ifdef _EZ80L92
#define SYSTEMCLOCK 48000000
#define TMR2_IVECT 0x0e
#endif

#ifdef _EZ80190
#define SYSTEMCLOCK 50000000
#define TMR2_IVECT 0x0a
#endif


/*****************************************************************************
 *  timer 2 interrupt service routine
 *
 *  controls the LED Matrix scroll rate
 */
void interrupt tmr2_isr(void)
{
    static unsigned char i, row;
    unsigned char tmp;

#ifdef _EZ80F91
    tmp = TMR2_IIR;
#else
    /* _EZ80190, _EZ80L92, _EZ80F92, _EZ80F93 */
	tmp = TMR2_CTL;
#endif

    if (0 > i || i > 6)
    {
        row = 0x01;
        i = 0;
	}

   // LCDMATRIX_ROW = row;
   // LCDMATRIX_COLUMN = *(pcolumn + i);

    i++;
    row = row << 1;

    timer++;
}


/*****************************************************************************
 *  lcdtimer_init()
 *
 *  initialization routine for timer 2
 */
void lcdtimer_init(int interval)
{
    unsigned char tmp;
	unsigned short rr;

	TMR2_CTL = 0x00;
//	CTC_CH2 = 0x00;

	/* set Timer 2 interrupt vector */
    set_vector(TMR2_IVECT, tmr2_isr);

	rr = (unsigned short)(((SYSTEMCLOCK / 1000) * interval) / 16);
	TMR2_RR_H = (unsigned char)(rr >> 8);
	TMR2_RR_L = (unsigned char)(rr);

#ifdef _EZ80190
	tmp = TMR2_CTL;
    TMR2_CTL = 0x5f;
#endif

#ifdef _EZ80F91
    tmp = TMR2_IIR;
    TMR2_CTL = 0x0F;
   	TMR2_IER = 0x01;
#endif

#ifdef _EZ80L92
	tmp = TMR2_CTL;
    TMR2_CTL = 0x57;
#endif

#ifdef _EZ80F92
	tmp = TMR2_CTL;
    TMR2_CTL = 0x57;
#endif

#ifdef _EZ80F93
	tmp = TMR2_CTL;
    TMR2_CTL = 0x57;
#endif

}


/*****************************************************************************
 *  wait()
 *
 *  wait routine for displaying text messages
 */
void wait(int j)
{
    timer = 0;

	while (timer < j)
	{
	    if (user_input == 1)
		{
			user_input = 0;
		    pcolumn = p_user_input;
			timer = 0;
			j = 500;
	    }
	}
}


/*****************************************************************************
 * LedMatrix.c
 *
 * functions for LED matrix on eZ80 Development Board
 *****************************************************************************
 * Copyright (C) 2005 by ZiLOG, Inc.  All Rights Reserved.
 *****************************************************************************/

#define _Z84C15_IORQ

#include <string.h>
#include <stdio.h>
#include <ez80.h>
#include "LCDInit.h"
#include "Z84C15.h"


/*  LED matrix display pointer, what ever 5 byte string this points to will
 *  be displayed
 */
unsigned char *pcolumn;
unsigned char *p_user_input;
char user_input;

//int i;

// *********************
// *  LCD Initialisieren
//**********************

char LCD128(char ch)
{
    int i;
	i = 100;

	while(( LCD_DAT & 0x03) == 0x03)
	{
		if (!i) 
		{
			return (0);
		}
		i--;
	}
	
	return (1);
	
}


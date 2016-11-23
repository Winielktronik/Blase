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

int TXHOME = 40;  	// Set XT HM ADD

// *********************
// *  LCD Initialisieren
//**********************

void LCD128_ini(void)
{
	//*
	//* Set Text Home adresse
	//*
	short int i;
	char ex;
	
	i =0x0000;				// Adresse
	ex = LCD128_dt2(i);	
	i =TXHOME;
	ex = LCD_CMD(i);
	
	//*
	//* set Graphic Home Adresse
	//*
	i =0x0200;
	
	
	
}

/*
void LCD128_cmd(char ch)
{
	return 0
}

void LCD128_dt1(char ch)
{
	return 0
}
*/
char LCD128_dt2(short int hm)
{
	
	int i;
	//while(!( LCD_DAT & 0x03) == 0x03)
	{ 
		for(i = 1000; i > 0; i--)
		   {
			   	if(( LCD_DAT & 0x03) == 0x03)
				{
					LCD_DAT= hm;
					return 1;
				}
			}
			return 0;
	}
	
	LCD_CMD = hm;
	return 1;
	
}

/*

void LCD128_adt(char ch)
{
	return 0
}
*/

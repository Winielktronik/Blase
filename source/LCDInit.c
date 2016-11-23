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

int TXHOME = 0x40;  // Set Text Home Add.
int TXAREA = 0x41;	// Set Text Area
int GRHOME = 0x42;	// Set Grafik Home Add.
int GRAREA = 0x43;	// Set Grafik Area
int OFFSET = 0x22;	// Set offset Add.
int ADPSET = 0x24;	// Set Add. PTR
int AWRON  = 0x80;	// Set auto Write Mode

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
	ex = 0x40;
	LCD128_cmd(ex);
		
	//*
	//* set Graphic Home Adresse
	//*
	i =0x0200;
	ex = LCD128_dt2(i);
	ex = 0x42;
	LCD128_cmd(ex);
	
	//*
	//* set Text Area
	//*
	i =0x0014;
	ex = LCD128_dt2(i);
	ex = 0x41;
	LCD128_cmd(ex);	

	//*
	//* set Graphic Area
	//*
	i =0x0014;
	ex = LCD128_dt2(i);
	ex = 0x43;
	LCD128_cmd(ex);
	
	//*
	//* Mode Set (orMade, Internal Character Generator Mode)
	//*
	i = 0x80;
	LCD128_cmd(i);
	
	//*
	//* set Offset Register 
	//*
	i =0x0002;
	ex = LCD128_dt2(i);
	ex = 0x22;
	LCD128_cmd(ex);
	
	//*
	//* Display Mode (Text on, Grafik of, Cursor off)
	//*
	i = 0x98;
	ex = LCD128_dt2(i);

	//*
	//* Write Text Blank Code 
	//*
	i =0x0000;
	ex = LCD128_dt2(i);
	ex = 0x24;
	LCD128_cmd(ex);
	i = 0xb0;
	LCD128_cmd(i);
	
	//*
	//* mit Space Blank Display löschen
	
	// Weiter .....
	
	
}

//*
//* Command Write Routne
//*

void LCD128_cmd(char hm)
{
	int i;

   	while(( LCD_DAT & 0x03) == 0x03);		// LCD Ready
		
	LCD_DAT= hm;
	return ;				
}

//*
//* Data Write 1Byte Routine
//*

char LCD128_dt1(char hm)
{
	int i;

	for(i = 1000; i > 0; i--)			// Time Out -> Return =0
	   {
		   	if(!( LCD_DAT & 0x03) == 0x03)
			{
				LCD_CMD= hm;			// 8Bit Ausgabe 
				return 1;				// LCD Ready	
			}
		}
		return 0;
}

//*
//* Date Write 2Byte Routine
//*

char LCD128_dt2(short int hm)
{
	
	int i;

	for(i = 1000; i > 0; i--)			// Time Out -> Return =0
	   {
		   	if(!( LCD_DAT & 0x03) == 0x03)
			{
				LCD_CMD= hm;			// 16Bit Ausgabe 2x bei Z80
				return 1;				// LCD Ready	
			}
		}
		return 0;
}

/*

void LCD128_adt(char ch)
{
	return 0
}
*/

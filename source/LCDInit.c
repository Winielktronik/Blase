/*****************************************************************************
 * LCSInit.c
 *****************************************************************************
 * Copyright (C) 2016 All Contributors All Rights Reserved.
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

extern unsigned char matrix_char_map[128][7];


//----- Utils --------------------------------------------
void lcd128_put_byte(int addr, short int data);

//----- API ----------------------------------------------

void lcd128_init_driver(Display* interface) {
	interface->init = lcd128_init;
}

void lcd128_init(void)
{
	// Set Text Home adresse
	lcd128_data_write(0);	// Adresse
	lcd128_cmd(ADDR_TXT_HOME);
		
	// Set Graphic Home Adresse
	lcd128_data_write(0x0200);
	lcd128_cmd(ADDR_GRAPHIC_HOME);
	
	// Set Text Area
	lcd128_data_write(0x0014);
	lcd128_cmd(TXT_AREA);	

	// Set Graphic Area
	lcd128_data_write(0x0014);
	lcd128_cmd(GRAPHIC_AREA);
	
	// Mode Set (orMade, Internal Character Generator Mode)
	lcd128_cmd(MODE_AUTOWRITE);
	
	// Set Offset Register
	lcd128_data_write(0x0002);
	lcd128_cmd(ADDR_OFFSET);
	
	// Display Mode (Text on, Grafik of, Cursor off)
	lcd128_data_write(0x98);

	// Write Text Blank Code 
	lcd128_data_write(0x0000);
	lcd128_cmd(0x24);
	lcd128_cmd(0xb0);
	
	//* mit Space Blank Display löschen
	
	// Weiter .....
}

void lcd128_cmd(char cmd)
{
   	int i = 0;
	char result = 0;
	
	result = lcd128_put_byte(&LCD_CMD, cmd);
	
	return result;
}

char lcd128_data_write(short int data)
{
	char result = 0;
	
	result = lcd128_put_byte(&LCD_DATA, data);
	
	return result;
}

void LCD128_adt(char ch)
{
	return 0;
}

//----- Utils --------------------------------------------
char lcd128_put_byte(int* addr, short int data)
{
	char result = 0;
	
	while(i++ < 1000 && ( LCD_DAT & 0x03) == 0x03);		// LCD Ready
	
	if (i < 1000) {
		(*addr) = hm;
		result = 1;
	}
	
	return result;
}

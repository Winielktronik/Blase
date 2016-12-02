/*****************************************************************************
 * LCDInit.c
 *****************************************************************************
 * Copyright (C) 2016 All Contributors All Rights Reserved.
 *****************************************************************************/
#define _Z84C15_IORQ
#define _Z84C15_PIO

#include <string.h>
#include <stdio.h>
#include <ez80.h>
#include "LCDInit.h"
#include "Z84C15.h"

//----- Utils --------------------------------------------
#define lcd128_put_byte(addr, data, result)\

	int __i = 0; \
	
	while(__i++ < 1000 && (LCD_DAT & 0x03) != 0x03); // LCD Ready \
 	if (__i < 1000) { \
		addr = data; \
		result = 1; \
	} \

//----- API ----------------------------------------------

void lcd128_init_driver(Display* interface) {
	interface->init = lcd128_init;
}

void lcd128_init(void)
{
	char ECB_BUS;
	
	
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

BOOL lcd128_cmd(char cmd)
{
   	int i = 0;
	char result = 0;
	ECB_BUS = PIOA_DATA;
	PIOA_DATA = (ECB_BUS & 0x7F);
	
	lcd128_put_byte(LCD_CMD, cmd, result);
	// if(result)
	LCD_CMD =cmd;

	PIOA_DATA = ECB_BUS;
	return result;
}

BOOL lcd128_data_write(short int data)
{
	char result = 0;
	ECB_BUS = PIOA_DATA;
	PIOA_DATA = (ECB_BUS & 0x7F);
	
	lcd128_put_byte(LCD_DATA, data, result);
	// if(result)
	LCD_DAT =data;

	PIOA_DATA = ECB_BUS;	
	return result;
}

BOOL LCD128_adt(char ch)
{
	ECB_BUS = PIOA_DATA;
	PIOA_DATA = (ECB_BUS & 0x7F);

	lcd128_put_byte(LCD_DATA, data, result);
	// if(result)
	LCD_DAT =data;
	
	PIOA_DATA = ECB_BUS;
	return result;
}

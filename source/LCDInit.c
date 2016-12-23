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
	while(__i++ <1000 && (LCD_DAT & 0x03) != 0x03);\
	if (__i < 1000) {\
		addr = data;\
		result = 1;\
		}\
		
#define ecb_bus_intern()\
	ECB_BUS = PIOA_DATA;\
	PIOA_DATA = (ECB_BUS & 0x7F);\
		
#define ecb_bus_extern(karte)\
	ECB_BUS = PIOA_DATA;\
	PIOA_DATA = (ECB_BUS | 0x80);\
	LATCH = karte;\

//----- API ----------------------------------------------
	
void lcd128_init_driver(Display* interface) {
		interface->init = lcd128_init;
}

void lcd128_init(void)
{
	char ECB_BUS;
	int i = 0;
	
	// Set Text Home adresse
	lcd128_data_write16(0x0000);	// Adresse
	lcd128_cmd(ADDR_TXT_HOME);
		
	// Set Graphic Home Adresse
	lcd128_data_write16(0x0200);
	lcd128_cmd(ADDR_GRAPHIC_HOME);
	
	// Set Text Area
	lcd128_data_write16(0x0014);
	lcd128_cmd(TXT_AREA);	

	// Set Graphic Area
	lcd128_data_write16(0x0014);
	lcd128_cmd(GRAPHIC_AREA);
	
	// Mode Set (orMade, Internal Character Generator Mode)
	lcd128_cmd(MODE_AUTOWRITE);
	
	// Set Offset Register
	lcd128_data_write16(0x0002);
	lcd128_cmd(ADDR_OFFSET);
	
	// Display Mode (Text on, Grafik of, Cursor off)
	lcd128_data_write8(0x98);

	// Write Text Blank Code 
	lcd128_data_write16(0x0000);
	lcd128_cmd(0x24);
	lcd128_cmd(0xb0);
	
	//* LCD Clear mit Space (20H)

	for (i=0; i < 0x1A0; i++)
		{
			lcd128_adt(0x20);
		}
	

	
	// Weiter .....
	
}

BOOL lcd128_cmd(char cmd)
{
   	int __i = 0;
	char ECB_BUS;
	char result = 0;
	
	ecb_bus_intern();
	
	lcd128_put_byte(LCD_CMD, cmd, result);
	
	PIOA_DATA = ECB_BUS;
	return result;
}

BOOL lcd128_data_write8(char data)
{
   	int __i = 0;
	char ECB_BUS;
	char result = 0;
	
	ecb_bus_intern();
	
	lcd128_put_byte(LCD_DAT, data, result);

	PIOA_DATA = ECB_BUS;	
	return result;
}

BOOL lcd128_data_write16(short int data)
{
	int __i = 0;
	char ECB_BUS;
	char result = 0;
	
	ecb_bus_intern();
	
	lcd128_put_byte(LCD_DAT, (data), result);
	if(result)
		{
		char ECB_BUS;
		lcd128_put_byte(LCD_DAT, (data >>4), result);
		}

	PIOA_DATA = ECB_BUS;	
	return result;
}

BOOL lcd128_adt(char data)
{
	int __i = 0;
	char ECB_BUS;
	char result = 0;
	
	ecb_bus_intern();

	lcd128_put_byte(LCD_DAT, (data - 0x20), result);
	
	PIOA_DATA = ECB_BUS;
	return result;
}


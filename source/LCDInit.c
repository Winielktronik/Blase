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
#include <gpio.h>
#include "uart.h"

//----- Utils --------------------------------------------
#define lcd128_put_byte(addr, data, result)\
		SET_BIT(PC_DR, 7);\
        SET_BIT(PC_DR, 6);\
        SET_BIT(PC_DR, 5);\
        LEDMATRIX_COLUMN = 0x1d;\
        LEDMATRIX_ROW = 0x04;\
        if(addr < 2) {\
			LEDMATRIX_ROW = 0x84;\
            SET_BIT(PC_DR, 4);\
            while(__i++ <1000 && ((EMUL_GPIO & 0x03) !=0x03)){\
				SET_BIT(PC_DR, 7);\
                SET_BIT(PC_DR, 6);\
                SET_BIT(PC_DR, 5);\
                delay(2);\
                CLEAR_BIT(PC_DR, 6);\
                CLEAR_BIT(PC_DR, 7);\
                delay(2);\
            }\
		}\
		if(addr == 2) {\
			LEDMATRIX_ROW = 0x84;\
			SET_BIT(PC_DR, 4);\
			while(__i++ <1000 && ((EMUL_GPIO & 0x08) != 0x08)){\
				SET_BIT(PC_DR, 7);\
            	SET_BIT(PC_DR, 6);\
            	SET_BIT(PC_DR, 5);\
				delay(2);\
                CLEAR_BIT(PC_DR, 6);\
                CLEAR_BIT(PC_DR, 7);\
                delay(2);\
            }\
		}\
        LEDMATRIX_ROW = 0x04;\
        SET_BIT(PC_DR, 7);\
		SET_BIT(PC_DR, 6);\
        SET_BIT(PC_DR, 5);\
        CLEAR_BIT(PC_DR, 4);\
        if(addr == 1) {\
			SET_BIT(PC_DR, 4);\
        }\
        delay(2);\
        CLEAR_BIT(PC_DR, 5);\
        CLEAR_BIT(PC_DR, 7);\
        EMUL_GPIO = data;\
        delay(1);\
        LEDMATRIX_COLUMN = 0x17;\
       	result = 1;\
       	SET_BIT(PC_DR, 7);\
		SET_BIT(PC_DR, 5);\
        SET_BIT(PC_DR, 6);\
		delay(1);\
        LEDMATRIX_COLUMN = 0x1f;\
		
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

void lcd128_init(void){
	
	char ECB_BUS;
	int i = 0;

	PC_ALT2 = 0x00;
	PC_ALT1 = 0x00;
	PC_DDR = 0x00;
    PC_DR = 0xe2;
	
//	CLEAR_BIT(PC_DR, 3);
	delay(500);
	SET_BIT(PC_DR, 7);
	SET_BIT(PC_DR, 3);
	
	
	// Set Text Home adresse
	lcd128_data_write8(0x00);	// Adre
	lcd128_data_write8(0x00);	// Adresse
	lcd128_cmd(ADDR_TXT_HOME);
		
	// Set Graphic Home Adresse
	lcd128_data_write8(0x00);
	lcd128_data_write8(0x02);
	lcd128_cmd(ADDR_GRAPHIC_HOME);
	
	// Set Text Area
	lcd128_data_write8(0x14);
	lcd128_data_write8(0x00);
	lcd128_cmd(TXT_AREA);	

	// Set Graphic Area
	lcd128_data_write8(0x14);
	lcd128_data_write8(0x00);
	lcd128_cmd(GRAPHIC_AREA);
	
	// Mode Set (orMade, Internal Character Generator Mode)
	lcd128_cmd(MODE_AUTOWRITE);
	
	// Set Offset Register
	lcd128_data_write8(0x02);
	lcd128_data_write8(0x00);
	lcd128_cmd(ADDR_OFFSET);
	
	// Display Mode (Text on, Grafik of, Cursor off)
	lcd128_cmd(0x94);

	// Write Text Blank Code
	lcd128_data_write8(0x00);
	lcd128_data_write8(0x00);
	lcd128_cmd(PTR_ADDR);

	// Weiter .....
	
}

BOOL lcd128_cmd(char cmd)
{
   	int __i = 0;
	char ECB_BUS;
	char result = 0;
	
	//ecb_bus_intern();
	//lcd128_put_byte(LCD_CMD, cmd, result);
	lcd128_put_byte(1, cmd, result);
	
	//PIOA_DATA = ECB_BUS;
	return result;
}

BOOL lcd128_data_write8(char data)
{
   	int __i = 0;
	char ECB_BUS;
	char result = 0;
	
	//ecb_bus_intern();
	//lcd128_put_byte(LCD_DAT, data, result);
	lcd128_put_byte(0, data, result);

	//PIOA_DATA = ECB_BUS;	
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
	lcd128_cmd(AWR_ON);

	//ecb_bus_intern();
	//lcd128_put_byte(LCD_DAT, (data - 0x20), result);
	lcd128_put_byte(2, data, result);
	
	//PIOA_DATA = ECB_BUS;
	lcd128_cmd(AWR_OFF);
	
return result;
}

void delay(int amount)  
{
	int i = 0;
	while(i++ < (amount*1000));
	return;
}

/*
void kreis(void)  
{
	//void rasterCircle(int x0, int y0, int radius)
	
	int x0,y0,radius;
	//{
int f = 1 - radius;
int ddF_x = 0;
int ddF_y = -2 * radius;
int x = 0;
int y = radius;
setPixel(x0, y0 + radius);
setPixel(x0, y0 - radius);
setPixel(x0 + radius, y0);
setPixel(x0 - radius, y0);
while(x < y)
{
if(f >= 0)
{
y--;
ddF_y += 2;
f += ddF_y;
}
x++;
ddF_x += 2;
f += ddF_x + 1;
setPixel(x0 + x, y0 + y);
setPixel(x0 - x, y0 + y);
setPixel(x0 + x, y0 - y);
setPixel(x0 - x, y0 - y);
setPixel(x0 + y, y0 + x);
setPixel(x0 - y, y0 + x);
setPixel(x0 + y, y0 - x);
setPixel(x0 - y, y0 - x);
}

	return;
	
}*/
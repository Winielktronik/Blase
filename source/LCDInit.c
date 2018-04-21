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

/*   LCD 128x128 Port Anschlussbelegung
//       Port eZ8091 -> IC 74F32  ->  LCD128x128
//                      3Vto 5V
//         PC7 J6 39 ->  10 - 7   ->     7   /CS
//         PC6 J6 41 ->  12 - 11  ->     6   /RD
//         PC5 J6 43 ->   2 -  3  ->     5   /WR
//         PC4 J6 45 ->   4 -  6  ->     8    A0
*/

//----- Utils --------------------------------------------
#define lcd128_put_byte(addr, data, result)\
		SET_BIT(PC_DR, 7);\
        SET_BIT(PC_DR, 6);\
        SET_BIT(PC_DR, 5);\
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
		if(addr >= 2) {\
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
        if(addr == 1 || addr == 3){\
			SET_BIT(PC_DR, 4);\
        }\
        delay(2);\
		if ( addr <3 ){ \
			CLEAR_BIT(PC_DR, 5);\
			CLEAR_BIT(PC_DR, 7);\
			EMUL_GPIO = data;\
			LEDMATRIX_COLUMN = 0x17;\
			result = 1;\
			LEDMATRIX_COLUMN = 0x1f;\
		}\
		if (addr ==3){\
			SET_BIT(PC_DR, 5);\
			CLEAR_BIT(PC_DR, 7);\
			result = EMUL_GPIO; \
		}\
        delay(2);\
       	SET_BIT(PC_DR, 7);\
		SET_BIT(PC_DR, 5);\
        SET_BIT(PC_DR, 6);\
		//result = 1;\
		delay(2);\

//***************************************************

#define ecb_bus_intern()\
	ECB_BUS = PIOA_DATA;\
	PIOA_DATA = (ECB_BUS & 0x7F);\
		
#define ecb_bus_extern(karte)\
	ECB_BUS = PIOA_DATA;\
	PIOA_DATA = (ECB_BUS | 0x80);\
	LATCH = karte;\

char extcg[] = {
	0x01,0x01,0xff,0x01,0x3f,0x21,0x3f,0x21,		// 0x07 upper/left 80H
	0x00,0x00,0xff,0x00,0xfc,0x04,0xfc,0x04,		// 0x0f upper/right 81H
	0x21,0x3f,0x05,0x0d,0x19,0x31,0xe1,0x01,		// 0x17 lower/left 82H
	0x04,0xfc,0x40,0x60,0x30,0x1c,0x07,0x00,		// 0x1f lower/right 83H
	0x08,0x08,0xff,0x08,0x09,0x01,0x01,0x7f,		// 0x27 upper/left 84H
	0x10,0x10,0xff,0x10,0x10,0x00,0x00,0xfc,		// 0x2f upper/right 85H
	0x00,0x00,0x00,0x01,0x07,0x3c,0xe7,0x00,		// 0x30 lower/left 86H
	0x18,0x30,0x60,0xc0,0x00,0x00,0xe0,0x3f,		// 0x3f lower/right 87H
	//-----------------
	0xff,0x00,0xe0,0xe0,0xe0,0xe0,0x00,0xff,		// 0x40 upper/left 88H
	0xff,0x00,0x00,0x00,0x00,0x00,0x00,0xff,		// 0x4f upper/right 89H
	0xff,0x00,0x00,0x00,0x00,0x00,0x00,0xff,		// 0x50 lower/left 8AH
	0xff,0x00,0x00,0x00,0x00,0x00,0x00,0xff,		// 0x5f lower/right 8BH	
	};

short exprt1[] = {
	0x80, 0x81, 0x00, 0x00, 0x84, 0x85
	};
	
short exprt2[] = {
	0x82, 0x83, 0x00, 0x00, 0x86, 0x87
	};
	
short exprt3[] = {
	0x88, 0x89, 0x89, 0x89
	};
//----- API ----------------------------------------------
	
void lcd128_init_driver(Display* interface) {
		interface->init = lcd128_init;
}

void lcd128_init(void){
	
	char ECB_BUS;
	int i = 0;
	int wind = 0;

	PC_ALT2 = 0x00;
	PC_ALT1 = 0x00;
	PC_DDR = 0x00;
    PC_DR = 0xe2;

	SET_BIT(PC_DR, 7);		// LCD CS
	delay(250);
	SET_BIT(PC_DR, 3);		// LCD Reset
	delay(500);
	
	
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
	
	// Mode Set (or Mode, Internal Character Generator Mode)
	lcd128_cmd(MODE_AUTOWRITE);
	
	// Set Offset Register
	lcd128_data_write8(0x02);
	lcd128_data_write8(0x00);
	lcd128_cmd(ADDR_OFFSET);
	
	// Display Mode (Text on, Grafik of, Cursor off)
	lcd128_cmd(0x94);

	lcd128_data_write8(0x00);
	lcd128_data_write8(0x14);
	lcd128_cmd(PTR_ADDR);
	
	lcd128_cmd(AWR_ON);
	/*	//* LCD Clear mit Space (20H)
	
	for (i=0; i < 322; i++)
		{
			lcd128_adt(0);
		}
	
	lcd128_cmd(AWR_OFF);
	
	// Write Text Blank Code
	lcd128_data_write8(0x00);
	lcd128_data_write8(0x00);
	lcd128_cmd(PTR_ADDR);
	
	lcd128_cmd(AWR_ON);
		
	//* LCD Clear mit Space (20H)
	
	for (i=0; i < 322; i++)
		{
			lcd128_adt(i &0x3f);
			delay(50);
		}
	
	lcd128_cmd(AWR_OFF);
	*/
	
	for(i=0; i<=0x60 ; i++) 
	{
		lcd128_adt(extcg[i]);
		
	}
	
	lcd128_cmd(AWR_OFF);
	
	lcd128_data_write8(0x57);
	lcd128_data_write8(0x00);
	lcd128_cmd(PTR_ADDR);
	
	lcd128_cmd(AWR_ON);
	
	for(i=0; i<=0x05 ; i++) 
	{
		lcd128_adt(exprt1[i]);
		
	}
	
	lcd128_cmd(AWR_OFF);
	
	lcd128_data_write8(0x6b);
	lcd128_data_write8(0x00);
	lcd128_cmd(PTR_ADDR);
	
	lcd128_cmd(AWR_ON);
	
	for(i=0; i<=0x05 ; i++) 
	{
		lcd128_adt(exprt2[i]);
		
	}
	
	lcd128_cmd(AWR_OFF);

	lcd128_data_write8(0x79);
	lcd128_data_write8(0x00);
	lcd128_cmd(PTR_ADDR);
	
	lcd128_cmd(AWR_ON);
	
	for(i=0; i<0x13 ; i++) 
	{
		if (i < 3)
		{
			lcd128_adt(exprt3[i]);
		}
		if (i > 2)
		{
			lcd128_adt(exprt3[2]);
		}
	}
	
	lcd128_cmd(AWR_OFF);
	
	lcd128_data_write8(0x00);
	lcd128_data_write8(0x00);
	lcd128_cmd(PTR_ADDR);
	
	lcd128_cmd(AWR_ON);

	delay(2);
	
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
	
	//ecb_bus_intern();
	
	//lcd128_put_byte(LCD_DAT, (data), result);
	//char ECB_BUS;
	lcd128_put_byte(0, data, result);
	lcd128_put_byte(0, (data >> 4), result);	
	//lcd128_cmd(PTR_ADDR);
	//PIOA_DATA = ECB_BUS;	
	return result;
}

BOOL lcd128_adt(char data)
{
	int __i = 0;
	char ECB_BUS;
	char result = 0;
	lcd128_cmd(AWR_ON);
	LEDMATRIX_COLUMN = (data & 0x1f);
	lcd128_put_byte(2, data, result);
	
return result;
}

int lcd128_ard()
{
	int __i = 0;
	char ECB_BUS;
	char result = 0;
	lcd128_cmd(ARD_ON);
	//result = lcd128_put_byte(3, 0x00, result);

	lcd128_cmd(AWR_OFF);
	
return result;
}

void delay(int amount)  
{
	int i = 0;
	while(i++ < (amount*1000));
	return;
}

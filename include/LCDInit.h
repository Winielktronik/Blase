/*****************************************************************************
 * LCSInit.h
 *****************************************************************************
 * Copyright (C) 2016 All Contributors All Rights Reserved.
 *****************************************************************************/
#ifndef INC_LCDINIT_H
#define INC_LCDINIT_H

#include "Display.h"
#include "defines.h"


//----- Constants ----------------------------------------

/**
 * Set text home address
 */
const int ADDR_TXT_HOME = 0x40;

/**
 * Set text area
 */
const int TXT_AREA = 0x41;

/**
 * Set grafic home address
 */
const int ADDR_GRAPHIC_HOME = 0x42;

/**
 * Set grafic area
 */
const int GRAPHIC_AREA = 0x43;

/**
 * Set offset address
 */
const int ADDR_OFFSET = 0x22;

/**
 * Set address PTR
 */
const int PTR_ADDR = 0x24;

/**
 * Set auto write mode
 */
const int MODE_AUTOWRITE  = 0x80;



//----- API ----------------------------------------------
// eZ80 development board led matrix functions

/**
 * Registers the lcd128 interface in the given driver instance.
 */
void lcd128_init_driver(Display* interface);

/**
 * Initializes the lcd hardware with the default settings
 */
void lcd128_init(void);

/**
 * Sends a command directly to the lcd interface.
 * 
 * @param The command byte to send to the lcd interface
 */
BOOL lcd128_cmd(char cmd);

/**
 * Sends data directly to the lcd interface
 * 
 * @param The data to send to the lcd interface
 */
BOOL lcd128_data_write(short int);

/**
 * 
 */
BOOL lcd128_adt(char);

//bbit lcd_daten(char dat);
//bbit lcd_command(char com);
/*void ledmatrix_fill(void);
void ledmatrix_putc(char c);
void ledmatrix_puts(char *str);
void ledmatrix_test(void);
*/


#endif // INC_LCDINIT_H

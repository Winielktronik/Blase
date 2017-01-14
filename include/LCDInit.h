/*****************************************************************************
 * LCDInit.h
 *****************************************************************************
 * Copyright (C) 2016 All Contributors All Rights Reserved.
 *****************************************************************************/
#ifndef INC_LCDINIT_H
#define INC_LCDINIT_H

#include "Display.h"
#include "defines.h"

#define SET_BIT(val, bit) (val |= (1<<bit))
#define CLEAR_BIT(val, bit) (val &= (~(1<<bit)))

/* LED anode and cathode external I/O pointers */
#define LEDMATRIX_ROW      (*(unsigned char*)0x800000)  //Anode
#define LEDMATRIX_COLUMN   (*(unsigned char*)0x800001)  //Cathode

/* emulated GPIO port */
#define EMUL_GPIO       (*(volatile unsigned char*)0x800002)

//----- Constants ----------------------------------------

/**
 * Set text home address
 */
static const int ADDR_TXT_HOME = 0x40;

/**
 * Set text area
 */
static const int TXT_AREA = 0x41;

/**
 * Set grafic home address
 */
static const int ADDR_GRAPHIC_HOME = 0x42;

/**
 * Set grafic area
 */
static const int GRAPHIC_AREA = 0x43;

/**
 * Set offset address
 */
static const int ADDR_OFFSET = 0x22;

/**
 * Set address PTR
 */
static const int PTR_ADDR = 0x24;

/**
 * Set auto write mode
 */
static const int MODE_AUTOWRITE  = 0x80;

/**
 * Set Data Auto write
 */
static const int AWR_ON  = 0xb0;

/**
 * AUTO RESET
 */
static const int AWR_OFF = 0xb2;

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
BOOL lcd128_cmd(char);

/**
 * Sends data directly to the lcd interface
 * 
 * @param The data to send to the lcd interface
 */
BOOL lcd128_data_write8(char);

/**
 * Sends data directly to the lcd interface
 * 
 * @param The data to send to the lcd interface
 */
BOOL lcd128_data_write16(short int);

/**
 * 
 */
BOOL lcd128_adt(char); 

/**
 *  Pause
 */
void delay(int);

/**
 *  Kreisberechnung
 */
void kreis(void);

#endif // INC_LCDINIT_H

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
 * Set Data Auto read
 */
static const int ARD_ON  = 0xb1;

/**
 * AUTO RESET
 */
static const int AWR_OFF = 0xb2;

//----- API ----------------------------------------------
// eZ80 development board led matrix functions


/**
 * Sends a Track, Sector and addiere.
 * 
 * @param The LBA trk, sec
 */
int lba0(INT16 trk, int sec);


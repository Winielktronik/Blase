/*****************************************************************************
 * LBA.c
 *****************************************************************************
 * Copyright (C) 2016 All Contributors All Rights Reserved.
 *****************************************************************************/
#define _Z84C15_IORQ
#define _Z84C15_PIO

#include <string.h>
#include <stdio.h>
#include <ez80.h>
// #include "hdd.h"
#include "Z84C15.h"
#include <gpio.h>
#include "uart.h"


INT lba0(trk, sec)
{
	
	sec = sec+1;
	
	if (sec > 0xff)
	{
		trk = trk+1;
		sec = 0x00;
	}
	
	return trk, sec;
	

}

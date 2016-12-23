/*****************************************************************************
 * BlaseSort.c
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



int LBA_mode(int lba)
{
	if(lba < hdd_max)
		{
			lba++;
		}
		
	lba = hdd_min;
	
	return lba;
}
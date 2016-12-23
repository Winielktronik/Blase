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
#include "BlaseSort.h"
#include "Z84C15.h"
#include "defines.h"



int LBA_mode_plus(int lba)
{
	int hdd_max = 1048575;
	int hdd_min = 2048;
	
	if(lba <= hdd_max)
		{
			lba++;
		}
		else 
		{
			lba = hdd_min;
		}
	
	return lba;
}


//************************

int LBA_mode_minus(int lba)
{
	int hdd_max = 1048575;
	int hdd_min = 2048;
	
	if(lba > hdd_min)
		{
			lba--;
		}
	
		
	return lba;
}
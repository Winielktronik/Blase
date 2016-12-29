/*****************************************************************************
 * BlaseSort.c
 *****************************************************************************
 * Copyright (C) 2016 All Contributors All Rights Reserved.
 *****************************************************************************/
#define _Z84C15_IORQ
#define _Z84C15_PIO
#define _Z84C15_PERIPHERIE
#define zsldevinit
//#define _DEFINES_H_

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
	char result = 0;
	
	if(lba <= hdd_max)
		{
			lba++;
			result = 1;
			//open_HDD_TRK(0xF832, lba);
		}
	
	return lba;
}


//************************

int LBA_mode_minus(int lba)
{
	int hdd_max = 1048575;
	int hdd_min = 2048;
	char result = 0;
	
	if(lba > hdd_min)
		{
			lba--;
			result = 1;
		}
		
	return lba;
}

/*
void open_HDD_read(lba)
{
	asm ("ld bc, 0"
		 "push bc"		 //; pass a null pointer.
		 "call HDD_TRK"	 //; initialize Port B.
		 "pop bc"
		 "ret");
}
*/
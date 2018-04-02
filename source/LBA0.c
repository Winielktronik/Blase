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
#include "LCDInit.h"
#include "Z84C15.h"
#include <gpio.h>
#include "uart.h"


INT16 lba0(t,s){
	
	INT16 i;

	s=s+1;
	if (s > 0xff)
	{
		s = 0x00;
		i= t+1;
		t=i;
	}
	
	return t, s;
	

}

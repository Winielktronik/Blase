/*****************************************************************************
 * Driver.h
 *****************************************************************************
 * Copyright (C) 2016 All Contributors All Rights Reserved.
 *****************************************************************************/
#ifndef INC_DRIVER_H
#define INC_DRIVER_H

/**
 * Driver.h
 **
 * @version 0.1
 * @file Declares the driver API.
 */

/************
 * INCLUDES *
 ************/

#include "kernel.h"

/*********
 * TYPES *
 *********/

/**
 * A basic driver struct, which is used as interface for the kernel.
 */
typedef struct {
	
	int(*init)();
	
	void(*shutdown)();
	
	int (*status)();
	
	void(*cycle)();
} Driver;


/*********
 * MACRO *
 *********/



/*******
 * API *
 *******/

const int INIT_DRIVER_SUCCESS = 0;
const int INIT_DRIVER_UNKNOWN_ERROR = 1;
const int INIT_DRIVER_NOT_COMPATIBLE = 2;
const int INIT_DRIVER_NO_DEVICE_FOUND = 3;

#endif // INC_DRIVER_H

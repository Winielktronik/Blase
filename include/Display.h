/*****************************************************************************
 * LCDInit.h
 *****************************************************************************
 * Copyright (C) 2016 All Contributors All Rights Reserved.
 *****************************************************************************/
 
#ifndef INC_DISPLAY_H
#define INC_DISPLAY_H


/**
 * General display driver interface
 * 
 * @details
 * Use it for accessing the display without coupling to a specific 
 * hardware.
 * 
 * @code {
 * 	Display display;
 * 	lcd128_init_driver(&display);
 * }
 * 
 * Or better define an abstract function:
 * 
 * kernel.c
 * @code {
 * 	#define LCD_DRIVER_INIT lcd128_init_driver
 * 
 * 	Display* kernel_init_display() {
 * 		static Display display = NULL;
 * 
 * 		if (display == NULL) {
 * 			LCD_DRIVER_INIT(&display);
 * 		}
 * 
 * 		return &display;
 * 	}
 * }
 * 
 * main.c
 * @code {
 *  ...
 * 	void main(void) {
 * 		Display* display = kerne_init_display();
 * 
 * 		display->init();
 * 
 * 		display->print_text(...)
 * 
 * 		// and so on...
 * 	}
 * }
 */
typedef struct _Display {
	/**
	 * Initializes the lcd hardware with the default settings
	 */
	void (*init)(void);
} Display;

#endif // INC_DISPLAY_H

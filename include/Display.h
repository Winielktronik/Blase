/*****************************************************************************
 * LCSInit.h
 *****************************************************************************
 * Copyright (C) 2016 All Contributors All Rights Reserved.
 *****************************************************************************/
 
#ifndef INC_DISPLAY_H
#define INC_DISPLAY_H

#include "Driver.h"

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
 * 		display->draw_string(...)
 * 
 * 		// and so on...
 * 	}
 * }
 */
typedef struct _Display {
	/**
	 * 
	 */
	Driver* base;
	
	// Display control
	void(*set_backlight)(byte_t);
	void(*set_state)(byte_t);
	void(*set_tearing)(byte_t);
	void(*set_idle)(byte_t);

	// Informations
	void(*get_type)();

	// Drawing
	void(*draw_pixel)(uint16_t, uint16_t, uint16_t);
	void(*set_fcolor)(byte_t, byte_t, byte_t);
	void(*set_bcolor)(byte_t, byte_t, byte_t);
	void(*draw_pixels)(uint16_t, uint16_t, uint16_t, uint16_t, uint16_t*);
	void(*draw_rect)(uint16_t, uint16_t, uint16_t, uint16_t, uint16_t);
	void(*draw_scroll)(int16_t, uint16_t);
	void(*clear_screen)(uint16_t);
	void(*set_xy)(int16_t, uint16_t);
	
	// Utils
	void(*draw_character)(const char);
	void(*draw_string)(const char*, const int);
	
} Display;

#endif // INC_DISPLAY_H

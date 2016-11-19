/*****************************************************************************
 * LcdMatrix.h
 *****************************************************************************
 * Copyright (C) 2005 by ZiLOG, Inc.  All Rights Reserved.
 *****************************************************************************/

/* LCD external I/O pointers */
#define LCD_CS      (*(unsigned char*)0x60)  

//#define LCDMATRIX_COLUMN   (*(unsigned char*)0x800001)  //Cathode

/* emulated GPIO port */
//#define EMUL_GPIO       (*(volatile unsigned char*)0x800002)

extern unsigned char *pcolumn;
extern unsigned char *p_user_input;
extern char user_input;

extern unsigned char matrix_char_map[128][7];

/* eZ80 development board lcd matrix functions */
void lcdmatrix_init(void);
void lcdmatrix_clear(void);
void lcdmatrix_fill(void);
void lcdmatrix_putc(char c);
void lcdmatrix_puts(char *str);
void lcdmatrix_test(void);
void lcdmatrix_flash(void);
void lcdmatrix_spin(void);


/*****************************************************************************
 * LCSInit.h
 *****************************************************************************
 * Copyright (C) 2016 by Hansjörg Winterhalter  All Rights Reserved.
 *****************************************************************************/

/* LED anode and cathode external I/O pointers */
/* #define LEDMATRIX_ROW      (*(unsigned char*)0x800000)  //Anode */
/* #define LEDMATRIX_COLUMN   (*(unsigned char*)0x800001)  //Cathode */

/* emulated GPIO port */
/* 
extern unsigned char *pcolumn;
extern unsigned char *p_user_input;
extern char user_input;

extern unsigned char matrix_char_map[128][7];
*/

/* eZ80 development board led matrix functions */

void LCD128_ini(void);
void LCD128_cmd(char);
char LCD128_dt1(char);
char LCD128_dt2(short int);
void LCD128_adt(char);
//bbit lcd_daten(char dat);
//bbit lcd_command(char com);
/*void ledmatrix_fill(void);
void ledmatrix_putc(char c);
void ledmatrix_puts(char *str);
void ledmatrix_test(void);
*/
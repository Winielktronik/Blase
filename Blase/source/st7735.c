#include "st7735.h"
#include "display.h"
#include "driver.h"
#include "i2c.h"
#include "fonts.h"

/**
 * st7735.c
 **
 * @version 0.1
 * @file Defines the st7735 API
 */



const byte_t FontSizeX = 5;
const byte_t FontSizeY = 7;

uint16_t cursor_x = 0;
uint16_t cursor_y = 0;
byte_t fcolorr = 0;
byte_t fcolorg = 0;
byte_t fcolorb = 0;

byte_t bcolorr = 0;
byte_t bcolorg = 0;
byte_t bcolorb = 0;

int disp_size_x = 127;
int disp_size_y = 158;

/************************
 * Initialize utilities *
 ************************/

/**
 *
 */
static void delay(uint16_t p_loop)
{
	int i = 0;
	while(i++ < 10);
}

/**
 * Initializes the i2c interface.
 */
static void st7735_init_i2c()
{
	PC_ALT2 = 0x00;
	PC_ALT1 = 0x00;
	PC_DDR = 0x00;

	// Reset LCD Port D2
	SET_CS;      // CS= 1
	SET_RES;
	delay(10);
	CLR_RES; 	// /RES PC2 = 0 LOW
	delay(10);
	SET_RES; 		// /RES PC2 = 1 HIGH
	delay(10);

	reset_i2c();

	st7735_write_cmd(ST7735_SWRESET);
	delay(10);
	st7735_write_cmd(ST7735_SLPOUT);//Sleep exit 
}

/**
 * Initializes the color mode.
 */
static void st7735_init_color_mode()
{
	// Set colorMode
	st7735_write_cmd(ST7735_IPIXFORM);
	st7735_write_data(0x05);
	delay(10);
}

/**
 * Initializes the frame rate.
 */
static void st7735_init_frame_rate()
{
	//ST7735R Frame Rate
	st7735_write_cmd(ST7735_FRMCTR1);
	st7735_write_data(0x01);
	st7735_write_data(0x2C);
	st7735_write_data(0x2D);
	delay(10);
}

/**
 * Initializes the memory access.
 */
static void st7735_init_memory_access()
{
	// Memory acces
	st7735_write_cmd(ST7735_MADCTL);
	st7735_write_data(0xC8);
}

/**
 * Applies the display settings.
 */
static void st7735_init_display_setting()
{
	// DisplaySetting
	st7735_write_cmd(ST7735_DISSET5);
	st7735_write_data(0x15);
	st7735_write_data(0x02);
}

/**
 * Initializes the display inversion.
 */
static void st7735_init_display_inversion()
{
	//Display inversion  
	st7735_write_cmd(ST7735_INVCTR); //Column inversion 
	st7735_write_data(0x00);
}

/**
 * Initializes the power sequence.
 */
static void st7735_init_power_sequence()
{
	//ST7735R Power Sequence
	st7735_write_cmd(ST7735_PWCTR1); 	//PWCTR1
	st7735_write_data(0x32);	//a, 02
	st7735_write_data(0x02);   //70
	st7735_write_data(0x84);   // AUTO mode
	delay(10);

	st7735_write_cmd(ST7735_PWCTR2);	//PWCTR2
	st7735_write_data(0xC5);   //05

	st7735_write_cmd(ST7735_PWCTR3); 	//PWCTR3
	st7735_write_data(0x0A);  	//21
	st7735_write_data(0x00);	//22

	st7735_write_cmd(ST7735_PWCTR4);  	//PWCTR4
	st7735_write_data(0x8A);   // BCLK/2, Opamp current small & Medium low
	st7735_write_data(0x2A);

	st7735_write_cmd(ST7735_PWCTR5);  	//PWCTR5
	st7735_write_data(0x8A);
	st7735_write_data(0xEE);

	st7735_write_cmd(ST7735_VMCTR1); 	//VMCTR1 
	st7735_write_data(0x0E);
	st7735_write_data(0x38);
	delay(10);

	st7735_write_cmd(ST7735_PWCTR6);	//PWCTR6 
	st7735_write_data(0x11);
	st7735_write_data(0x15);
}

/**
 * Initializes the row and column addresses.
 */
static void st7735_init_addresses()
{
	//CASET ([C]olumn [A]ddress SET)
	st7735_write_cmd(ST7735_CASET);	//CASET
	st7735_write_data(0x00);
	st7735_write_data(0x00);
	st7735_write_data(0x00);
	st7735_write_data(0x7F);

	//RASET ([R]ow [A]ddress SET)
	st7735_write_cmd(ST7735_RASET);	//RASET
	st7735_write_data(0x00);
	st7735_write_data(0x00);
	st7735_write_data(0x00);
	st7735_write_data(0x9F);
}

/**
 * Initilizes the gamma sequence
 */
static void st7735_init_gamma_sequence()
{
	//ST7735R Gamma Sequence
	st7735_write_cmd(ST7735_GMCTRP1); 	//GMCTRP1
	st7735_write_data(0x0F);
	st7735_write_data(0x1A);
	st7735_write_data(0x0F);
	st7735_write_data(0x18);
	st7735_write_data(0x2F);
	st7735_write_data(0x28);
	st7735_write_data(0x20);
	st7735_write_data(0x22);
	st7735_write_data(0x1F);
	st7735_write_data(0x1B);
	st7735_write_data(0x23);
	st7735_write_data(0x37);
	st7735_write_data(0x00);
	st7735_write_data(0x07);
	st7735_write_data(0x02);
	st7735_write_data(0x10);

	st7735_write_cmd(ST7735_GMCTRN1); 	//GMCTRN1
	st7735_write_data(0x0F);
	st7735_write_data(0x1B);
	st7735_write_data(0x0F);
	st7735_write_data(0x17);
	st7735_write_data(0x33);
	st7735_write_data(0x2C);
	st7735_write_data(0x29);
	st7735_write_data(0x2E);
	st7735_write_data(0x30);
	st7735_write_data(0x30);
	st7735_write_data(0x39);
	st7735_write_data(0x3F);
	st7735_write_data(0x00);
	st7735_write_data(0x07);
	st7735_write_data(0x03);
	st7735_write_data(0x10);
	delay(10);
}


/*****************
 * COMMUNICATION *
 *****************/


void st7735_clear_xy() {
	cursor_x = 0;
	cursor_y = 0;
	st7735_set_window_addr(0,0, disp_size_x, disp_size_y);
	st7735_write_cmd(0x2C);   
}

/**
* Sends the given command byte to the display.
*
* @param byte_t The byte to send.
*/
void st7735_write_cmd(byte_t p_cmd)
{
	CLEAR_BIT(PC_DR, 0);  	// RS/DC 0=Command
	CLEAR_BIT(PC_DR, 1);
	mtx_start_i2c();
	mtx_byte_i2c(p_cmd);
	mtx_stop_i2c();
	SET_BIT(PC_DR, 1);      // CS= 1
}

/**
* Writes the given data byte to the display.
*
* @param byte_t The byte to send.
*/
void st7735_write_data(byte_t p_dat)
{
	
	SET_BIT(PC_DR, 0);	// RS/DC 1=Data
	CLEAR_BIT(PC_DR, 1);
	mtx_start_i2c();
	mtx_byte_i2c(p_dat);
	mtx_stop_i2c();
	SET_BIT(PC_DR, 1);      // CS= 1
	
}


/**
* Writes data into the given register.
*
* @param uint16_t Registry ID
* @param uint16_t Data
*/
void st7735_write_reg(uint16_t p_reg, uint16_t p_data)
{
	// TODO
}

/**
* Sets the windows address space.
*
* @param byte_t X start address
* @param byte_t Y start address
* @param byte_t X end address
* @param byte_t Y end address
*/
void st7735_set_window_addr(byte_t p_xstart, byte_t p_ystart, byte_t p_xend, byte_t p_yend)
{
	st7735_write_cmd(ST7735_CASET);   // column addr set
	st7735_write_data(0x00);
	st7735_write_data(p_xstart);          // XSTART 
	st7735_write_data(0x00);
	st7735_write_data(p_xend);          // XEND

	st7735_write_cmd(ST7735_RASET);   // row addr set
	st7735_write_data(0x00);
	st7735_write_data(p_ystart);          // YSTART
	st7735_write_data(0x00);
	st7735_write_data(p_yend);          // YEND
}

/**
* Sets the state of the backlight.
*
* @param byte_t The state of the backlight. 1 for ON and 0 for OFF.
*/
void st7735_set_backlight(byte_t p_state)
{
	// No backlight
}

/**
* Sets the display state.
*
* @param byte_t State of the display 0 = off, 1 = on.
*/
void st7735_set_state(byte_t p_state)
{
	st7735_write_cmd(p_state == 1 ? ST7735_DISPON : ST7735_DISPOFF);
}

/*
* Sets the display idle mode.
*
* @param byte_t State of the idle mode 0 = off, 1 = on.
*/
void st7735_set_idle(byte_t p_state)
{
	st7735_write_cmd(p_state == 1 ? ST7735_IDLEON : ST7735_IDLEOFF);
}

/**
* Stets the tearing effect mode.
*
* @param uint16_t 0 = off; 1 = mode 0; 2 = mode 1;
*/
void st7735_set_tearing(uint16_t p_mode)
{
	// TODO
}

/**
* Clears the screen with the given color.
*
* @param uint16_t The color to fill the screen with.
*/
void st7735_clear_screen(uint16_t p_color)
{
	uint16_t x, y;
	//st7735_set_window_addr(0, 0, ST7735_SCREEN_WIDTH - 1, ST7735_SCREEN_HEIGHT - 1);
	for (y = 0; y < ST7735_SCREEN_HEIGHT; y++)
	{
		st7735_set_window_addr(0, y, ST7735_SCREEN_WIDTH - 1, y+1);
		st7735_write_cmd(ST7735_RAMWR);  // write to RAM
		for (x = 0; x < ST7735_SCREEN_WIDTH; x++)
		{
			st7735_write_data(p_color >> 8);
			st7735_write_data(p_color);
		}
		st7735_write_cmd(ST7735_NOP);
	}
}

/**
* Draws a pixel on the display at the given position.
*
* @param uint16_t The x position.
* @param uint16_t The y position.
* @param uint16_t The color of the pixel.
*/
void st7735_draw_pixel(uint16_t p_x, uint16_t p_y, uint16_t p_color)
{
	st7735_set_window_addr(p_x, p_y, p_x + 1, p_y + 1);
	st7735_write_cmd(ST7735_RAMWR);  // write to RAM
	st7735_write_data(p_color >> 8);
	st7735_write_data(p_color);
}

/**
* Draws a chunk of pixels at the given position.
*
* @param uint16_t The x position.
* @param uint16_t The y position.
* @param uint16_t The x size.
* @param uint16_t The y size.
* @param uint16_t The color data.
*/
void st7735_draw_pixels(uint16_t p_x, uint16_t p_y, uint16_t p_width, uint16_t p_height, uint16_t* p_data)
{
	uint16_t x, y;
	st7735_set_window_addr(p_x, p_y, p_x + p_width - 1, p_y + p_height - 1);
	st7735_write_cmd(ST7735_RAMWR);  // write to RAM
	for (y = 0; y < p_height; y++)
	{
		for (x = 0; x < p_width; x++)
		{
			uint16_t pos = (y * p_width) + x;
			st7735_write_data(p_data[pos] << 8);
			st7735_write_data(p_data[pos]);
		}
	}
	st7735_write_cmd(ST7735_NOP);
}

/**
 *
 */
void st7735_draw_rect(uint16_t p_x, uint16_t p_y, uint16_t p_width, uint16_t p_height, uint16_t p_color)
{
	uint16_t x, y;
	st7735_set_window_addr(p_x, p_y, p_x + p_width - 1, p_y + p_height - 1);
	st7735_write_cmd(ST7735_RAMWR);  // write to RAM
	for (x = 0; x < p_width; x++)
	{
		for (y = 0; y < p_height; y++)
		{
			st7735_write_data(p_color >> 8);
			st7735_write_data(p_color);
		}
	}
	st7735_write_cmd(ST7735_NOP);
}

/**
* Draws a horizontal line
*
* @param X start position
* @param Y start position
* @param Y end position
* @param Color
*/
void st7735_draw_hline(uint16_t p_x, uint16_t p_xend, uint16_t p_y, uint16_t p_color)
{
	// Allows for slightly better performance than setting individual pixels
	uint16_t x, pixels;

	if (p_xend < p_x)
	{
		// Switch p_xend and p_x
		x = p_xend;
		p_xend = p_x;
		p_x = x;
	}

	// Check limits
	if (p_xend >= ST7735_SCREEN_WIDTH)
	{
		p_xend = ST7735_SCREEN_WIDTH - 1;
	}
	if (p_x >= ST7735_SCREEN_WIDTH)
	{
		p_x = ST7735_SCREEN_WIDTH - 1;
	}

	st7735_set_window_addr(p_x, p_y, ST7735_SCREEN_WIDTH, p_y + 1);
	st7735_write_cmd(ST7735_RAMWR);  // write to RAM
	for (pixels = 0; pixels < p_xend - p_x + 1; pixels++)
	{
		st7735_write_data(p_color >> 8);
		st7735_write_data(p_color);
	}
	st7735_write_cmd(ST7735_NOP);
}

/**
* Draws a horizontal line
*
* @param X start position
* @param X end position
* @param Y start position
* @param Color
*/
void st7735_draw_vline(uint16_t p_x, uint16_t p_y, uint16_t p_yend, uint16_t p_color)
{
	// Allows for slightly better performance than setting individual pixels
	uint16_t y, pixels;

	if (p_yend < p_y)
	{
		// Switch p_yend and p_y
		y = p_yend;
		p_yend = p_y;
		p_y = y;
	}

	// Check limits
	if (p_yend >= ST7735_SCREEN_HEIGHT)
	{
		p_yend = ST7735_SCREEN_HEIGHT - 1;
	}
	if (p_y >= ST7735_SCREEN_HEIGHT)
	{
		p_y = ST7735_SCREEN_HEIGHT - 1;
	}

	st7735_set_window_addr(p_x, p_y, p_x, ST7735_SCREEN_HEIGHT);
	st7735_write_cmd(ST7735_RAMWR);  // write to RAM
	for (pixels = 0; pixels < p_yend - p_y + 1; pixels++)
	{
		st7735_write_data(p_color >> 8);
		st7735_write_data(p_color);
	}
	st7735_write_cmd(ST7735_NOP);
}


/**
* Scrolls the display content.
*
* @param uint16_t Amount of pixels to scroll.
* @param uint16_t Color to fill undrawn area.
*/
void st7735_scroll(int16_t p_pix, uint16_t p_color)
{

}

/**
 *
 */
void st7735_set_xy(uint16_t pX, uint16_t pY) {
	cursor_x = pX;
	cursor_y = pY;
	st7735_set_window_addr(pX, pY, disp_size_x, disp_size_y);
}

/**
* Creates an instance of the display_driver_t struct.
*
* @return Returns 1 on success. Otherwise 0.
*/
int16_t st7735_create(display_driver_t *p_instance)
{
	int16_t res = 1;

	p_instance->driver->init = st7735_init;
	p_instance->driver->cycle = st7735_cycle;
	p_instance->driver->shutdown = st7735_shutdown;

	p_instance->clear_screen = st7735_clear_screen;
	p_instance->draw_pixel = st7735_draw_pixel;
	p_instance->draw_rect = st7735_draw_rect;
	p_instance->draw_pixels = st7735_draw_pixels;
	p_instance->draw_scroll = st7735_scroll;
	p_instance->set_backlight = st7735_set_backlight;
	p_instance->set_idle = st7735_set_idle;
	p_instance->set_fcolor = st7735_set_fcolor;
	p_instance->set_bcolor = st7735_set_bcolor;
	p_instance->set_state = st7735_set_state;
	p_instance->draw_character = st7735_write_character;
	p_instance->set_xy = st7735_set_xy;
	p_instance->draw_string = st7735_write_string;

	return res;
}

void st7735_set_fcolor(byte_t pR, byte_t pG, byte_t pB) {
	fcolorr = pR;
	fcolorg = pG;
	fcolorb = pB;
}

void st7735_set_bcolor(byte_t pR, byte_t pG, byte_t pB) {
	bcolorr = pR;
	bcolorg = pG;
	bcolorb = pB;
}

/**
* Initializes the st7735 driver.
*
* @return Returns constant value of INIT_DRIVER_SUCCESS on succes. Otherwise an driver error constant.
*/
int16_t st7735_init()
{
	int16_t res = 1;

	st7735_init_i2c();
	st7735_init_color_mode();
	st7735_init_frame_rate();
	st7735_init_memory_access();
	st7735_init_display_setting();
	st7735_init_display_inversion();
	st7735_init_power_sequence();
	st7735_init_addresses();
	st7735_init_gamma_sequence();

	st7735_write_cmd(ST7735_NORON); 	//Enable tet command  
	delay(10);

	//-------------------------
	SET_CS;
	
	st7735_clear_screen(0);

	return res;
}


/**
*
*/
void st7735_cycle()
{

}


/**
* Disposes the driver.
*/
void st7735_shutdown()
{

}


void st7735_write_string(const char *pString, const int pLength) {
	int i = 0;
	for(i = 0; i < pLength; i++) {
		st7735_write_character(pString[i]);
	}
}

void st7735_write_character(const char c) {
	int y,i,v,j=0,max,b,fch,fcl,bch,bcl, res;
	unsigned int data[FontSizeX * FontSizeY];
	
	if(cursor_y + FontSizeY >= disp_size_y) {
		st7735_clear_screen(0);
		st7735_clear_xy();
	}
	
	if(c == '\n') {
		cursor_y += FontSizeY + 1;
		cursor_x = 0;
		return;
	} else if(c == '\r') {
		cursor_x = 0;
		return;
	} else if(0x7f == c) {
		if(cursor_x < FontSizeX) {
			cursor_x = disp_size_x - (FontSizeX + 2);
			cursor_y -= FontSizeY + 1;
			st7735_write_character(' ');
			cursor_x = disp_size_x - (FontSizeX + 2);
			cursor_y -= FontSizeY + 1;
		} else {
			cursor_x -= FontSizeX + 1;
			st7735_write_character(' ');
			cursor_x -= FontSizeX + 1;
		}
		return;
	} else if(c < ' ' || c > '~') {
		return;
	}
	
	v=(c-' ')*5+4;
	max = v-5;
	fch=((fcolorr&248)|fcolorg>>5);
	fcl=((fcolorg&28)<<3|fcolorb>>3);
	bch=((bcolorr&248)|bcolorg>>5);
	bcl=((bcolorg&28)<<3|bcolorb>>3);
	
	st7735_set_xy(cursor_x, cursor_y);
	
	for(i=v;i>max;i--) {
		for(b=0; b<=7;b++) {
			if(i == (max+1) && b == 6) {
				break;
			}
			
			res = CHECK_BIT(SmallFont[i], b);
			
			if(res){
				data[j] = fch;
				data[j] = data[j] << 8;
				data[j] += fcl;
			} else {
				data[j] = bch;
				data[j] = data[j] << 8;
				data[j] += bcl;
			}
			j++;
		}
	}
	
	st7735_draw_pixels(cursor_x, cursor_y, FontSizeX, FontSizeY, data);
	
	y = cursor_y;
	
	if('\n' != c && '\r' != c) {
		cursor_x += FontSizeX + 1;
	}
	
	
	if(cursor_x + FontSizeX > disp_size_x) {
		cursor_y += FontSizeY + 1;
		cursor_x = 0;
	}
	
	st7735_set_window_addr(cursor_x + FontSizeX + 1, y, disp_size_x, disp_size_y);
}
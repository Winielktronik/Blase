#ifndef INC_ST7735_H
#define INC_ST7735_H

/************
* INCLUDES *
************/

#include "ez80f91/KernelConfig.h"
#include "Display.h"

/*********
* TYPES *
*********/



/*********
* MACRO *
*********/

#define SET_BIT(val, bit) (val |= (1<<bit))
#define CLEAR_BIT(val, bit) (val &= (~(1<<bit)))
#define CHECK_BIT(var,pos) ((var) & (1<<(pos)))

/************
* INTERNAL *
************/

static const byte_t ST7735_SCREEN_WIDTH = 128;
static const byte_t ST7735_SCREEN_HEIGHT = 160;

// Control pins
#define ST7735_GPIODATAREG     (PC_DR)
#define ST7735_PORT            (2)
#define ST7735_RS_PIN          (0)
#define ST7735_SDA_PIN         (2)
#define ST7735_SCL_PIN         (3)
#define ST7735_CS_PIN          (1)
#define ST7735_RES_PIN         (2)
#define ST7735_BL_PIN          (6)

// Macros for control line state
#define CLR_RS      do { ST7735_GPIODATAREG &= ~(1<<ST7735_RS_PIN); } while(0)
#define SET_RS      do { ST7735_GPIODATAREG &= ~(1<<ST7735_RS_PIN); ST7735_GPIODATAREG |= (1<<ST7735_RS_PIN); } while(0)
#define CLR_SDA     do { ST7735_GPIODATAREG &= ~(1<<ST7735_SDA_PIN); } while(0)
#define SET_SDA     do { ST7735_GPIODATAREG &= ~(1<<ST7735_SDA_PIN); ST7735_GPIODATAREG |= (1<<ST7735_SDA_PIN); } while(0)
#define CLR_SCL     do { ST7735_GPIODATAREG &= ~(1<<ST7735_SCL_PIN); } while(0)
#define SET_SCL     do { ST7735_GPIODATAREG &= ~(1<<ST7735_SCL_PIN); ST7735_GPIODATAREG |= (1<<ST7735_SCL_PIN); } while(0)
#define CLR_CS      do { ST7735_GPIODATAREG &= ~(1<<ST7735_CS_PIN); } while(0)
#define SET_CS      do { ST7735_GPIODATAREG &= ~(1<<ST7735_CS_PIN); ST7735_GPIODATAREG |= (1<<ST7735_CS_PIN); } while(0)
#define CLR_RES     do { ST7735_GPIODATAREG &= ~(1<<ST7735_RES_PIN); } while(0)
#define SET_RES     do { ST7735_GPIODATAREG &= ~(1<<ST7735_RES_PIN); ST7735_GPIODATAREG |= (1<<ST7735_RES_PIN); } while(0)
#define CLR_BL      do { ST7735_GPIODATAREG &= ~(1<<ST7735_BL_PIN); } while(0)
#define SET_BL      do { ST7735_GPIODATAREG &= ~(1<<ST7735_BL_PIN); ST7735_GPIODATAREG |= (1<<ST7735_BL_PIN); } while(0)


/************
* COMMANDS *
************/

// No operation
#define ST7735_NOP           (0x00)

// Software reset
#define ST7735_SWRESET       (0x01)

// Read display ID
#define ST7735_RDISPID       (0x04)

// Read display status
#define ST7735_RDISPSTAT     (0x09)

// Read display power
#define ST7735_RDISPLPOW     (0x0A)

// Read display
#define ST7735_RDISP         (0x0B)

// Read display pixel
#define ST7735_RDISPPIX      (0x0C)

// Read display image
#define ST7735_RDISPIMG      (0x0D)

// Read display signal
#define ST7735_RDISPSIG      (0x0E)

// Sleep in & Boost off
#define ST7735_SLPIN         (0x10)

// Sleep out & Boost on
#define ST7735_SLPOUT        (0x11)

// Partial mode on
#define ST7735_PTLON         (0x12)

// Partial mode off (default)
#define ST7735_NORON         (0x13)

// Inversion off
#define ST7735_INVOFF        (0x20)

// Inversion on
#define ST7735_INVON         (0x21)

// Gamma curve select
#define ST7735_GMACURV       (0x26)

// Display off
#define ST7735_DISPOFF       (0x28)

// Display on
#define ST7735_DISPON        (0x29)

// Column address setter
#define ST7735_CASET         (0x2A)

// Row address setter
#define ST7735_RASET         (0x2B)

// Ram write
#define ST7735_RAMWR         (0x2C)

// Set color mode
#define ST7735_LUT           (0x2D)

// Ram read
#define ST7735_RAMRD         (0x2E)

//PArtoal address
#define ST7735_PTLADR        (0x30)

// Tearin effect line on
#define ST7735_TEARLOFF      (0x34)

// Tearin effect mode.
#define ST7735_TEARMODE      (0x35)

// Memory data access control
#define ST7735_MADCTL        (0x36)

// Idle mode off
#define ST7735_IDLEOFF       (0x38)

// Idle mode on
#define ST7735_IDLEON        (0x39)

// Interface pixel format
#define ST7735_IPIXFORM      (0x3A)

// Read ID 1
#define ST7735_RDID1         (0xDA)

// Read ID 2
#define ST7735_RDID2         (0xDB)

// Read ID 3
#define ST7735_RDID3         (0xDC)

#define ST7735_FRMCTR1       (0xB1)
#define ST7735_INVCTR        (0xB4)
#define ST7735_DISSET5       (0xB6)
#define ST7735_PWCTR1        (0xC0)
#define ST7735_PWCTR2        (0xC1)
#define ST7735_PWCTR3        (0xC2)
#define ST7735_PWCTR4        (0xC3)
#define ST7735_PWCTR5        (0xC4)
#define ST7735_VMCTR1        (0xC5)
#define ST7735_PWCTR6        (0xFC)
#define ST7735_GMCTRP1       (0xE0)
#define ST7735_GMCTRN1       (0xE1)


/*************
* REGISTERS *
*************/

#define ST7735_REG_OSCSTART      (0x0000);
#define ST7735_REG_DRVOUTCTL     (0x0001);
#define ST7735_REG_ACCTL         (0x0002);
#define ST7735_REG_PWCTL1        (0x0003);
#define ST7735_REG_CMP1          (0x0005);
#define ST7735_REG_CMP2          (0x0006);
#define ST7735_REG_DISPCTL       (0x0007);
#define ST7735_REG_FRMCYCCTL     (0x000B);
#define ST7735_REG_PWCTL2        (0x000C);
#define ST7735_REG_PWCTL3        (0x000D);
#define ST7735_REG_PWCTL4        (0x000E);
#define ST7735_REG_GATSCNSTART   (0x000F);
#define ST7735_REG_SLEEP         (0x0010);
#define ST7735_REG_ENTRY         (0x0011);
#define ST7735_REG_HPORCH        (0x0016);
#define ST7735_REG_VPORCH        (0x0017);
#define ST7735_REG_RAMDREAD      (0x001E);
#define ST7735_REG_RAMDWR        (0x0022);
#define ST7735_REG_RAMDWRMASK1   (0x0023);
#define ST7735_REG_RAMDWRMASK2   (0x0024);
#define ST7735_REG_VCOMOTP1      (0x0028);
#define ST7735_REG_VCOMOTP2      (0x0029);
#define ST7735_REG_yCTL1         (0x0030);
#define ST7735_REG_yCTL2         (0x0031);
#define ST7735_REG_yCTL3         (0x0032);
#define ST7735_REG_yCTL4         (0x0033);
#define ST7735_REG_yCTL5         (0x0034);
#define ST7735_REG_yCTL6         (0x0035);
#define ST7735_REG_yCTL7         (0x0036);
#define ST7735_REG_yCTL8         (0x0037);
#define ST7735_REG_yCTL9         (0x003A);
#define ST7735_REG_VSCROLLCTL1   (0x0041);
#define ST7735_REG_VSCROLLCTL2   (0x0042);
#define ST7735_REG_HRAMADDR      (0x0044);
#define ST7735_REG_VRAMADDRSTART (0x0045);
#define ST7735_REG_VRAMADDREND   (0x0046);
#define ST7735_REG_FSTWINSTART   (0x0048);
#define ST7735_REG_FSTWINEND     (0x0049);
#define ST7735_REG_SECWINSTART   (0x004A);
#define ST7735_REG_SECWINEND     (0x004B);
#define ST7735_REG_XGDDRAMCNTR   (0x004E);
#define ST7735_REG_YGDDRAMCNTR   (0x004F);


static const byte_t ST7735_TEAR_OFF = 0;
static const byte_t ST7735_TEAR_MODE1 = 1;
static const byte_t ST7735_TEAR_MODE2 = 2;

/********
* BASE *
********/

/**
* Sends the given command byte to the display.
*
* @param byte_t The byte to send.
*/
void st7735_write_cmd(byte_t);

/**
* Writes data into the given register.
*
* @param uint16_t Registry ID
* @param uint16_t Data
*/
void st7735_write_reg(uint16_t, uint16_t);


/**
* Writes the given data byte to the display.
*
* @param byte_t The byte to send.
*/
void st7735_write_data(byte_t);

/**
* Sets the windows address space.
*
* @param byte_t X start address
* @param byte_t Y start address
* @param byte_t X end address
* @param byte_t Y end address
*/
void st7735_set_window_addr(byte_t, byte_t, byte_t, byte_t);

/**
* Sets the state of the backlight.
*
* @param byte_t The state of the backlight. 1 for ON and 0 for OFF.
*/
void st7735_set_backlight(byte_t);

/**
* Sets the display state.
*
* @param byte_t State of the display 0 = off, 1 = on.
*/
void st7735_set_state(byte_t);

/*
* Sets the display idle mode.
*
* @param byte_t State of the idle mode 0 = off, 1 = on.
*/
void st7735_set_idle(byte_t);

/**
* Stets the tearing effect mode.
*
* @param uint16_t 0 = off; 1 = mode 0; 2 = mode 1;
*/
void st7735_set_tearing(uint16_t);

/**
* Clears the screen with the given color.
*
* @param uint16_t The color to fill the screen with.
*/
void st7735_clear_screen(uint16_t);

/**
* Draws a pixel on the display at the given position.
*
* @param uint16_t The x position.
* @param uint16_t The y position.
* @param uint16_t The color of the pixel.
*/
void st7735_draw_pixel(uint16_t, uint16_t, uint16_t);

/**
* Draws a chunk of pixels at the given position.
*
* @param uint16_t The x position.
* @param uint16_t The y position.
* @param uint16_t The x size.
* @param uint16_t The y size.
* @param uint16_t The color data.
*/
void st7735_draw_pixels(uint16_t, uint16_t, uint16_t, uint16_t, uint16_t*);

/**
* Draws a horizontal line
*
* @param X start position
* @param Y start position
* @param Y end position.
* @param Color.
*/
void st7735_draw_hline(uint16_t, uint16_t, uint16_t, uint16_t);


/**
* Draws a vertical line
*
* @param X start position
* @param Y start position
* @param Y end position.
* @param Color.
*/
void st7735_draw_vline(uint16_t, uint16_t, uint16_t, uint16_t);

/**
* Scrolls the display content.
*
* @param uint16_t Amount of pixels to scroll.
* @param uint16_t Color to fill undrawn area.
*/
void st7735_scroll(int16_t, uint16_t);

/**
* Creates an instance of the display_driver_t struct.
*
* @return Returns 1 on success. Otherwise 0.
*/
int16_t st7735_create(display_driver_t*);


/**
* Initializes the st7735 driver.
*
* @return Returns constant value of INIT_DRIVER_SUCCESS on succes. Otherwise an driver error constant.
*/
int16_t st7735_init();


/**
*
*/
void st7735_cycle();


/**
* Disposes the driver.
*/
void st7735_shutdown();

void st7735_set_fcolor(byte_t, byte_t, byte_t);

void st7735_set_bcolor(byte_t, byte_t, byte_t);

void st7735_write_string(const char *pString, const int pLength);

/**
*
*/
void st7735_write_character(const char c);

#endif // INC_ST7735_H
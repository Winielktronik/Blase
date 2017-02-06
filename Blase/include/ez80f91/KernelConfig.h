#ifndef INC_EZ80_KERNEL_CONFIG_H
#define INC_EZ80_KERNEL_CONFIG_H

#define UART                 0			// change to 1 when using UART 1
#define UART_BPS             57600
#define UART_DATA_BITS       8
#define UART_PARITY          0
#define UART_STOP_BITS       1

#define DEVICE_NAME          "eZ80F91"

#if !defined(_ZSL_UART_USED)
#if (UART==1) 
#define	UART_FCTL	     	 UART1_FCTL
#define UART_RBR             UART1_RBR
#define UART_THR             UART1_THR
#define UART_BRG_L           UART1_BRG_L
#define UART_BRG_H           UART1_BRG_H
#define UART_LCTL            UART1_LCTL
#define UART_LSR             UART1_LSR
#define LCD1_DAT			 LCD_DAT
#else
#define	UART_FCTL	     	 UART0_FCTL
#define UART_RBR             UART0_RBR
#define UART_THR             UART0_THR
#define UART_BRG_L           UART0_BRG_L
#define UART_BRG_H           UART0_BRG_H
#define UART_LCTL            UART0_LCTL
#define UART_LSR             UART0_LSR
#endif

#define LCTL_DLAB            (unsigned char)0x80
#define LSR_THRE             (unsigned char)0x20
#define LSR_DR               (unsigned char)0x01


#define SetLCTL(d, p, s)     UART_LCTL = ((d-5)&3) | (((s-1)&1)<<2) | (p&3)
#endif //!defined(_ZSL_UART_USED)

#define LF                   '\n'
#define CR                   '\r'


//- Types
typedef unsigned char byte_t;

/**
* This file contains the default (or out-of-the-box) configuration of the kernel
*/

#define DISPLAY_DRIVER_INIT lcd128_init_driver

#endif // INC_EZ80_KERNEL_CONFIG_H

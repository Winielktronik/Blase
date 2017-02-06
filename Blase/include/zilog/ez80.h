/*======================================================================
								       
		     Copyright (C) 1998-2008 by			       
		            Zilog, Inc.
			All Rights Reserved			       
							 	       
========================================================================
                                eZ80

				<ez80.h>

=======================================================================*/
#ifndef __ez80_included
#define __ez80_included

#ifdef _EZ80F91
#include <eZ80F91.h>
#endif

#ifdef _EZ80190
#include <eZ80190.h>
#endif

#ifdef _EZ80L92
#include <eZ80L92.h>
#endif

#ifdef _EZ80F92
#include <eZ80F92.h>
#endif

#ifdef _EZ80F93
#include <eZ80F93.h>
#endif

#ifdef _ZSL_PORT_USED
#include <gpio.h>
#endif

#ifdef _ZSL_UART_USED
#include <uart.h>
#endif

#endif /* __ez80_included */



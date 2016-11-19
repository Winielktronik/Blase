/*****************************************************************************
 * LedTimer.h
 *****************************************************************************
 * Copyright (C) 2005 by ZiLOG, Inc.  All Rights Reserved.
 *****************************************************************************/

void lcdtimer_init(int interval);
//void interrupt tmr2_isr(void);
void wait(int j);

extern int timer;

#ifdef _SIO
void usertimer_init(int interval);
void interrupt tmr1_isr(void);
#endif


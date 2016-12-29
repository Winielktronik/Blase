/*****************************************************************************
 * BlaseSort.h
 *****************************************************************************
 * Copyright (C) 2016 All Contributors All Rights Reserved.
 *****************************************************************************/
//#ifndef INC_LCDINIT_H
//#define INC_LCDINIT_H

/**
 * LBA counter Plus.
 */
int LBA_mode_plus(int);

/**
 * LBA counter Minus.
 */
int LBA_mode_minus(int);

/**
 *   SET Track for HDD
 * 
 */
BOOL lcd128_cmd(char);

/*!
 * jump to BIOS
  */
VOID open_HDD_read();

/*************************************************
 *  Copyright (C) 1999-2008 by  Zilog, Inc.
 *  All Rights Reserved
 *************************************************/
#ifndef STDDEF_H
#define STDDEF_H

#ifndef SIZE_T_DEFINED
#define SIZE_T_DEFINED
typedef unsigned int size_t;
#endif

#ifndef NULL
#define NULL	(void *)0
#endif
#define offsetof(type,member)   ((size_t) &((type*)0)->member)

typedef unsigned int ptrdiff_t;

#ifndef WCHAR_T_DEFINED
#define WCHAR_T_DEFINED
typedef unsigned short wchar_t;
#endif

#endif

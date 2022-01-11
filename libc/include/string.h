#ifndef _STRING_H
#define _STRING_H

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Implemented */
char* strcpy(char*, const char*);
size_t strlen(const char*);
void strrev(char str[]);

/* Should implement */
void* memcpy(void*, const void*, size_t);
void* memset(void*, int, size_t);

/* Not now */

#ifdef __cplusplus
}
#endif

#endif
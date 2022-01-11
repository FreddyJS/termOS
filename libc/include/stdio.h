#ifndef _STDIO_H
#define _STDIO_H

#define EOF (-1)

#include <stdarg.h>
#include <stddef.h>

#define SEEK_SET 0
typedef struct { int unused; } FILE;

#ifdef __cplusplus
extern "C" {
#endif

extern FILE* stderr;
#define stderr stderr

/* Implemented */

/* Only Kernel */
int putchar(int c);
int printf(const char* __restrict, ...);

/* Not now */
int fclose(FILE*);
int fflush(FILE*);
FILE* fopen(const char*, const char*);
int fprintf(FILE*, const char*, ...);
size_t fread(void*, size_t, size_t, FILE*);
int fseek(FILE*, long, int);
long ftell(FILE*);
size_t fwrite(const void*, size_t, size_t, FILE*);
void setbuf(FILE*, char*);
int vfprintf(FILE*, const char*, va_list);


#ifdef __cplusplus
}
#endif

#endif

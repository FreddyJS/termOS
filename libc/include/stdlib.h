#ifndef _STDLIB_H
#define _STDLIB_H

#include <sys/types.h>

#ifdef __cplusplus
extern "C" {
#endif

int atoi(const char *nptr);
char *itoa(int value, char *string, int radix); 

/* Should implement */
void free(void*);
void* malloc(size_t);

/* Not now */
void abort(void);
int atexit(void (*)(void));
char* getenv(const char*);

#ifdef __cplusplus
}
#endif

#endif

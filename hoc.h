#include "complejo_cal.h"

typedef struct Symbol { /* entrada de la tabla de s�mbolos */
	char   *name;
	short   type;   /* VAR, BLTIN, UNDEF */
	union {
		ComplejoAP val;	       /* si es VAR */
		ComplejoAP  (*ptr)();      /* s� es BLTIN */
		//double num;
	} u;
	struct Symbol   *next;  /* para ligarse a otro */ 
} Symbol;

Symbol *install(char *s,int t, ComplejoAP d), *lookup(char *s);

#include <string.h>
struct complejo {
  double real, img;
};
typedef struct complejo Complejo;
typedef struct complejo *ComplejoAP;
/*  prototypes of the provided functions */ 
Complejo *creaComplejo(double real, double img);
Complejo *Complejo_add(Complejo *, Complejo *);
Complejo *Complejo_sub(Complejo *, Complejo *);
Complejo *Complejo_mul(Complejo *, Complejo *);
Complejo *Complejo_div(Complejo *, Complejo *);
Complejo *Complejo_pow(Complejo *, double n);
void imprimirC(Complejo *c);
/*  prototypes of the provided functions */ 
/* define the return type of FLEX */
//#define YYSTYPE ComplejoAP

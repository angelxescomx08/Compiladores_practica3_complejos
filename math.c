#include  <math.h>
#include <stdlib.h>
#include  <errno.h>
#include "hoc.h"

extern    int	errno;
extern Complejo *creaComplejo();
Complejo  *errcheck();

Complejo *Complejo_sin(Complejo *c){
  return errcheck(creaComplejo((sin(c->real)*(((exp(c->img)+exp(-1*(c->img)))/2))),
                      (cos(c->real)*((exp(c->img)-exp(-1*(c->img)))/2))), "sin");
}

Complejo *Complejo_cos(Complejo *c){
  return errcheck(creaComplejo((cos(c->real)*((exp(c->img)+exp(-1*c->img))/2)),
                      (-sin(c->real)*((exp(c->img)-exp(-1*c->img))/2))),"cos");
}

Complejo *Complejo_exp(Complejo *c){

   return errcheck(creaComplejo( (exp(c->real)*cos(c->img)),
                        (exp(c->real)*sin(c->img))),"exp");
}

Complejo *Complejo_log(Complejo *c){

   return errcheck(creaComplejo(0.5*log(((c->real)*(c->real))+((c->img)*(c->img))),atan((c->img)/(c->real))),"log");
}

Complejo *errcheck(Complejo *d, char *s)   /* revisar el resultado de la llamada
                                        a la biblioteca */
{
	if (errno == EDOM) {
		errno = 0;
		execerror(s, "argument out of domain");
	} else if (errno == ERANGE) {
		errno = 0;
		execerror(s,"result out of range");
        }
        return d;
}



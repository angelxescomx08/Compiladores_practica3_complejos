%{
#include <stdio.h>
#include <stdlib.h>

#include <math.h>
#include "hoc.h"

void yyerror (char *s);
int yylex ();
void warning(char *s, char *t);
void execerror(char *s, char *t);
void fpecatch();
extern double Pow(double, double);

%}
%union {
	ComplejoAP val;
	Symbol *sym;
	double num;
}

%token <num> NUMBER
%token <sym> VAR BLTIN INDEF
%type <val> complejo expr asgn
%right '='
%left '+' '-'
%left '*' '/'
%left UNARYMINUS
%right '^'

%%

list:   
	| list'\n'
	| list asgn'\n'
  	| list expr '\n'  {  imprimirC($2);}
  	| list error '\n'	{ yyerrok; }
	;
	
      asgn:VAR '=' expr { $$=$1->u.val=$3; $1->type=VAR;}
	;
    

complejo: 	NUMBER '+' NUMBER 'i' 	{$$=creaComplejo($1,$3);}
	| 		NUMBER '-' NUMBER 'i' 	{$$=creaComplejo($1,-$3);}
	| 	'-' NUMBER '+' NUMBER 'i' 	{$$=creaComplejo(-$2,$4);}
	| 	'-' NUMBER '-' NUMBER 'i' 	{$$=creaComplejo(-$2,-$4);}
	|		NUMBER					{$$=creaComplejo($1,0);}
	|	'-'	NUMBER					{$$=creaComplejo(-$2,0);}
	|				   NUMBER 'i'	{$$=creaComplejo(0,$1);}
	|			   '-' NUMBER 'i'	{$$=creaComplejo(0,-$2);}
	|		NUMBER '+' 		  'i'	{$$=creaComplejo($1,1);}
	|		NUMBER '-' 		  'i'	{$$=creaComplejo($1,-1);}
	|	'-'	NUMBER '+' 		  'i'	{$$=creaComplejo(-$2,1);}
	|	'-'	NUMBER '-' 		  'i'	{$$=creaComplejo(-$2,-1);}
	|						  'i'	{$$=creaComplejo(0,1);}
	|			   '-'		  'i'	{$$=creaComplejo(0,-1);}
    ;

expr: complejo { $$ = $1;}
	    | VAR { if($1->type == INDEF)
			execerror("variable no definida",$1->name);
			$$=$1->u.val;}
	    | asgn
	    | BLTIN  '(' expr ')' { $$=(*($1->u.ptr))($3);}
	    | expr '+' expr {$$ = Complejo_add($1,$3);}
       	| expr '-' expr {$$ = Complejo_sub($1,$3);}
	    | expr '*' expr {$$ = Complejo_mul($1,$3);}
	    | expr '/' expr {$$ = Complejo_div($1,$3);}
	    | expr '^' NUMBER { $$=Complejo_pow($1, $3);}
	    | '(' expr ')' {$$ = $2;}
        ;

%%

#include <stdio.h>
#include <ctype.h>
#include <signal.h>
#include <setjmp.h>

jmp_buf begin;
char *progname;
int lineno = 1;

void main (int argc, char *argv[]){
	progname=argv[0];
	init();
	setjmp(begin);
	signal(SIGFPE, fpecatch);
  	yyparse ();
}
void execerror(char *s, char *t){
	warning(s, t);
	longjmp(begin, 0);
}

void fpecatch(){
	execerror("excepcion de punto flotante", (char *)0);
}
int yylex (){
  	int c;

  	while ((c = getchar ()) == ' ' || c == '\t');
 	if (c == EOF)                            
    		return 0;
  	if (c == '.' || isdigit (c)){
      		ungetc (c, stdin);
      		scanf ("%lf", &yylval.num);
	      	return NUMBER;
    }
	if(isalpha(c)&& c!='i'){
		Symbol *s;
		ComplejoAP comp;
		char sbuf[200], *p=sbuf;
		do {
			*p++=c;
		} while ((c=getchar())!=EOF && isalnum(c));
		ungetc(c, stdin);
		*p='\0';
		if((s=lookup(sbuf))==(Symbol *)NULL)
			s=install(sbuf, INDEF,comp);
		yylval.sym=s;   
        if(s->type == INDEF){
			return VAR;
        } else {
            return s->type;
        }
	}
  	if(c == '\n'){
		lineno++;
    }

  	return c;                                
}
void yyerror (char *s) {
	warning(s, (char *) 0);
}
void warning(char *s, char *t){
	fprintf (stderr, "%s: %s", progname, s);
	if(t)
		fprintf (stderr, " %s", t);
	fprintf (stderr, "cerca de la linea %d\n", lineno);
}



















Complejo *creaComplejo(double real, double img){
   Complejo *nvo = (Complejo*)malloc(sizeof(Complejo));
   nvo -> real = real;
   nvo -> img = img;
   return nvo;
}
Complejo *Complejo_add(Complejo *c1, Complejo *c2){
  return creaComplejo(c1->real + c2->real, c1->img + c2->img);
}
Complejo *Complejo_sub(Complejo *c1, Complejo *c2){
  return creaComplejo(c1->real - c2->real, c1->img - c2->img);
}
Complejo *Complejo_mul(Complejo *c1, Complejo *c2){
  return creaComplejo( c1->real*c2->real - c1->img*c2->img,
                       c1->img*c2->real + c1->real*c2->img);
}
Complejo *Complejo_div(Complejo *c1, Complejo *c2){
   double d = c2->real*c2->real + c2->img*c2->img;
   return creaComplejo( (c1->real*c2->real + c1->img*c2->img) / d,
                        (c1->img*c2->real - c1->real*c2->img) / d);
}

Complejo *Complejo_pow(Complejo *c, double n){
  double norma=pow(sqrt((c->real*c->real)+(c->img*c->img)),n);

   return  creaComplejo( (norma*cos(n*atan2(c->img,c->real))),
                          (norma*sin(n*atan2(c->img,c->real)))
                        );
}
void imprimirC(Complejo *c){
   if(c->img != 0)
      printf("%f%+fi\n", c->real, c->img);
   else
      printf("%f\n", c->real);
}




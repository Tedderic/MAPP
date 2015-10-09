%{
#include <stdio.h>
void yyerror(const char *str);
%}

%token RESISTOR CAPACITOR INDUCTOR VSOURCE ISOURCE NODE VALUE

%%
commands:
	|
	commands RESISTOR NODE NODE VALUE {printf("cknetlist = addElement(cknetlist, resModSpec(), %s, {%i,%i}, {{'R', %s}});",$1,$2,$3,$4);}
	|
	commands CAPACITOR NODE NODE VALUE {printf("cknetlist = addElement(cknetlist, capModSpec(), %i, {%i,%i}, {{'C', %s}});",$1,$2,$3,$4);}
	|
	commands INDUCTOR NODE NODE VALUE {printf("cknetlist = addElement(cknetlist, inModSpec(), %i, {%i,%i}, {{'L', %s}});",$1,$2,$3,$4);}
	|
	commands VSOURCE NODE NODE VALUE {printf("cknetlist = addElement(cknetlist, vsrcModSpec, %i, {%i,%i}, {{'R', %s}});",$1,$2,$3,$4);}
	|
	commands ISOURCE  NODE NODE VALUE {printf("cknetlist = addElement(cknetlist, resModSpec(), %i, {%i,%i}, {{'R', %s}});",$1,$2,$3,$4);}
;

%%
void yyerror(const char *str)
{
        fprintf(stderr,"error: %s\n",str);
}
int main()
{
	yyparse();
	return 1;
}

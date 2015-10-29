%{
#include <stdio.h>
void yyerror(const char *str);
void storeResistor(char *str);
struct res
{
	char *name;
	char *value;
	int nodes[2];
};
%}

%union
{
    int intValue;
    float floatValue;
    char *stringValue;
}
%token RESISTOR CAPACITOR INDUCTOR VSOURCE ISOURCE NODE VALUE
%type <stringValue> RESISTOR 
%type <stringValue> CAPACITOR 
%type <stringValue> INDUCTOR 
%type <stringValue> VSOURCE 
%type <stringValue> ISOURCE 
%type <stringValue> NODE 
%type <stringValue> VALUE
%type <stringValue> commands

%%
commands: RESISTOR {storeResistor($1);}

;

%%
void yyerror(const char *str)
{
        fprintf(stderr,"error: %s\n",str);
}
void storeResistor(char *str)
{
	printf("%s",str);
	
	for(int i=0;i<sizeOf(str);i++)
	{
		
	}
}
int main()
{
	yyparse();
	return 1;
}

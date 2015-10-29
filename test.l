
%{
#include <stdio.h>
#include "y.tab.h"
%}
%%
[/r][a-zA-Z0-9]{8,}\n           {printf("Too many letters\n");}
[/R][a-zA-Z0-9]{8,}\n           {printf("Too many letters\n");}
[/c][a-zA-Z0-9]{8,}\n           {printf("Too many letters\n");}
[/C][a-zA-Z0-9]{8,}\n           {printf("Too many letters\n");}
[/l][a-zA-Z0-9]{8,}\n           {printf("Too many letters\n");}
[/L][a-zA-Z0-9]{8,}\n           {printf("Too many letters\n");}
[/v][a-zA-Z0-9]{8,}\n           {printf("Too many letters\n");}
[/V][a-zA-Z0-9]{8,}\n           {printf("Too many letters\n");}
[/i][a-zA-Z0-9]{8,}\n           {printf("Too many letters\n");}
[/I][a-zA-Z0-9]{8,}\n           {printf("Too many letters\n");}
[/r][a-zA-Z0-9]{1,7}" "+[a-zA-Z0-9]+" "+[a-zA-Z0-9]+" "+[0-9]([a-zA-Z0-9]+)? 		    {yylval.stringValue = strdup(yytext); return RESISTOR;}
[/R][a-zA-Z0-9]{1,7}" "+[a-zA-Z0-9]+" "+[a-zA-Z0-9]+" "+[0-9]([a-zA-Z0-9]+)? 		    {yylval.stringValue = strdup(yytext); return RESISTOR;}
[/c][a-zA-Z0-9]{1,7}" "+[a-zA-Z0-9]+" "+[a-zA-Z0-9]+" "+[0-9]([a-zA-Z0-9]+)? 		    {printf("capacitor\n"); return CAPACITOR;}
[/C][a-zA-Z0-9]{1,7}" "+[a-zA-Z0-9]+" "+[a-zA-Z0-9]+" "+[0-9]([a-zA-Z0-9]+)? 		    {printf("Capacitor\n"); return CAPACITOR;}
[/l][a-zA-Z0-9]{1,7}" "+[a-zA-Z0-9]+" "+[a-zA-Z0-9]+" "+[0-9]([a-zA-Z0-9]+)? 			{printf("inductor\n"); return INDUCTOR;}
[/L][a-zA-Z0-9]{1,7}" "+[a-zA-Z0-9]+" "+[a-zA-Z0-9]+" "+[0-9]([a-zA-Z0-9]+)?  	 		{printf("Inductor\n"); return INDUCTOR;}
[/v][a-zA-Z0-9]{1,7}" "+[a-zA-Z0-9]+" "+[a-zA-Z0-9]+" "+[0-9]([a-zA-Z0-9]+)? 			{printf("voltage\n"); return VSOURCE;}
[/V][a-zA-Z0-9]{1,7}\n 			{printf("Voltage\n"); return VSOURCE;}
[/i][a-zA-Z0-9]{1,7}\n 	 		{printf("current\n"); return ISOURCE;}
[/I][a-zA-Z0-9]{1,7}\n 			{printf("Current\n"); return ISOURCE;}
.						;
\n                      /* ignore end of line */;
[ \t]+                  /* ignore whitespace */;
%%

int yywrap(void)
{
	return 1;
}

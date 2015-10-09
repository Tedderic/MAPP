%{
#include <stdio.h>
#include "y.tab.h"
%}
%%
[0-9]+ 			{yylval = atoi(yytext);return NODE;}
[/r][a-z]+  		{yylval = strdup(yytext); return RESISTOR;}
[/R][a-z]+  		{yylval = strdup(yytext); return RESISTOR;}
[/c][a-z]+ 		{yylval = strdup(yytext); return CAPACITOR;}
[/C][a-z]+ 		{yylval = strdup(yytext); return CAPACITOR;}
[/l][a-z]+ 		{yylval = strdup(yytext); return INDUCTOR;}
[/L][a-z]+ 		{yylval = strdup(yytext); return INDUCTOR;}
[/v][a-z]+ 		{yylval = strdup(yytext); return VSOURCE;}
[/V][a-z]+ 		{yylval = strdup(yytext); return VSOURCE;}
[/i][a-z]+ 		{yylval = strdup(yytext); return ISOURCE;}
[/I][a-z]+ 		{yylval = strdup(yytext); return ISOURCE;}
[0-9a-z]+ 		{yylval = strdup(yytext); return VALUE;}
\n                      /* ignore end of line */;
[ \t]+                  /* ignore whitespace */;
%%
int yywrap(void)
{
	return 1;
}


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
[/r][a-zA-Z0-9]{1,7}" "+[a-zA-Z0-9]+" "+[a-zA-Z0-9]+" "+[0-9]+((e[0-9]+)|(e[-][0-9]+))?											{yylval.stringValue = strdup(yytext); return RESISTOR;}
[/R][a-zA-Z0-9]{1,7}" "+[a-zA-Z0-9]+" "+[a-zA-Z0-9]+" "+[0-9]+((e[0-9]+)|(e[-][0-9]+))?											{yylval.stringValue = strdup(yytext); return RESISTOR;}
[/c][a-zA-Z0-9]{1,7}" "+[a-zA-Z0-9]+" "+[a-zA-Z0-9]+" "+[0-9]+((e[0-9]+)|(e[-][0-9]+))?											{yylval.stringValue = strdup(yytext); return CAPACITOR;}
[/C][a-zA-Z0-9]{1,7}" "+[a-zA-Z0-9]+" "+[a-zA-Z0-9]+" "+[0-9]+((e[0-9]+)|(e[-][0-9]+))?											{yylval.stringValue = strdup(yytext); return CAPACITOR;}
[/l][a-zA-Z0-9]{1,7}" "+[a-zA-Z0-9]+" "+[a-zA-Z0-9]+" "+[0-9]+((e[0-9]+)|(e[-][0-9]+))? 											{yylval.stringValue = strdup(yytext); return INDUCTOR;}
[/L][a-zA-Z0-9]{1,7}" "+[a-zA-Z0-9]+" "+[a-zA-Z0-9]+" "+[0-9]+((e[0-9]+)|(e[-][0-9]+))?  											{yylval.stringValue = strdup(yytext); return INDUCTOR;}
[/v][a-zA-Z0-9]{1,7}" "+[a-zA-Z0-9]+" "+[a-zA-Z0-9]+" "+((DC" "+[0-9]+|AC" "+[0-9]+)|(AC|DC)" "+[0-9]+" "+(AC|DC)" "+[0-9]+)							{yylval.stringValue = strdup(yytext); return VSOURCE;}
[/V][a-zA-Z0-9]{1,7}" "+[a-zA-Z0-9]+" "+[a-zA-Z0-9]+" "+((DC" "+[0-9]+|AC" "+[0-9]+)|(AC|DC)" "+[0-9]+" "+(AC|DC)" "+[0-9]+) 							{yylval.stringValue = strdup(yytext); return VSOURCE;}
[/i][a-zA-Z0-9]{1,7}" "+[a-zA-Z0-9]+" "+[a-zA-Z0-9]+" "+((DC" "+[0-9]+|AC" "+[0-9]+)|(AC|DC)" "+[0-9]+" "+(AC|DC)" "+[0-9]+) 							{yylval.stringValue = strdup(yytext); return ISOURCE;}
[/I][a-zA-Z0-9]{1,7}" "+[a-zA-Z0-9]+" "+[a-zA-Z0-9]+" "+((DC" "+[0-9]+|AC" "+[0-9]+)|(AC|DC)" "+[0-9]+" "+(AC|DC)" "+[0-9]+) 							{yylval.stringValue = strdup(yytext); return ISOURCE;}
[/v][a-zA-Z0-9]{1,7}" "+[a-zA-Z0-9]+" "+[a-zA-Z0-9]+" "+SIN"("[0-9]+" "[0-9]+" "[0-9]+" "[0-9]+" "[0-9]+")"		                						{yylval.stringValue = strdup(yytext); return VSOURCESIN;}
[/V][a-zA-Z0-9]{1,7}" "+[a-zA-Z0-9]+" "+[a-zA-Z0-9]+" "+SIN"("[0-9]+" "[0-9]+" "[0-9]+" "[0-9]+" "[0-9]+")"		                						{yylval.stringValue = strdup(yytext); return VSOURCESIN;}
[/.]TRAN" "+[0-9]+((e[0-9]+)|(e[-][0-9]+))?" "+[0-9]+((e[0-9]+)|(e[-][0-9]+))?" "+[0-9]+((e[0-9]+)|(e[-][0-9]+))?" "+[0-9]+((e[0-9]+)|(e[-][0-9]+))?	{yylval.stringValue = strdup(yytext); return TRAN;}
[/.]PLOT" "+TRAN																																		{return PLOTTRAN;}
.						;
\n                      /* ignore end of line */;
[ \t]+s                  /* ignore whitespace */;
%%

int yywrap(void)
{
	return 1;
}

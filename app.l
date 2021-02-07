%{
	#include <cstdio>

	#include "app.tab.h"
%}

%option noyywrap

%%
[\t\n] 	;
[0-9]+\.[0-9]+ { yylval.floatValue = atof(yytext); }
[0-9]+ { yylval.intValue = atoi(yytext); }
[a-zA-Z0-9]+ {
	yylval.charValue = strdup(yytext);
	return STRING;
}

%%



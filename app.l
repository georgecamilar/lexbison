%{
	#include <stdio.h>
	#include "app.tab.h"

	using namespace std;

	char* dataSegment;
	char* codeSegment;

	FILE* fileSource;
	extern int yyparse();
	int yylex();
    int yyerror(const char* s);
%}

%option noyywrap
digit [0-9]
notZeroDigit [1-9]
letter [a-zA-Z_]
number {digit}|{notZeroDigit}{digit}*

identifier 	{letter}({letter}|{digit})*
constant 	([+-]?{number}([.]{number})?)|(["][^"]*["])

%%

"#include<iostream>" 									return HEADER;
"using namespace std;" 									return NAMESPACESTATEMENT;
"int"														return INT;
"cin"														return CIN;
"cout"														return COUT;
"<<"														return LLARROWS;
">>"														return RRARROWS;
";"															return ';'; 
"{"														return '{';
"}" 													return '}'; 
"="														return '=';
"-"														return '-';
\*														return '*';
\+														return '+';
\/														return '/';

{constant}												{strcpy(yylval.string, yytext); return CONSTANT;}
{identifier}											{strcpy(yylval.string, yytext); return IDENTIFIER;}

. ;

[\t\n] 	;

%%

int yyerror(const char* s) {
	printf("%s\n", s);
	return 1;
}

void addData (char data[1000]) {
	strcat(dataSegment, data);
}

void addCode (char code[1000]) {
	strcat(codeSegment, code);
}


int main(void) {
	fileSource = fopen("testFile.cpp", "r");

	dataSegment = (char*) malloc(3000 * sizeof(char));
	dataSegment[0] = '\0';
	

	codeSegment = (char*)malloc(3000 * sizeof(char));
	codeSegment[0] = '\0';

	addData("\nsegment data use32 class=data\n");
	addData("\t_format db \"Print: %d\", 10, 0\n");
	addData("\t_sformat db \"%d\",0\n");

	addCode("segment code use32 class=code\n");
	addCode("start:\n");

	int exitCode = yyparse();

	fprintf(fileSource, "bits 32\n");
	fprintf(fileSource, "global start\n");
	fprintf(fileSource, "extern exit, printf, scanf\n");
	fprintf(fileSource, "import exit msvcrt.dll \n");
	fprintf(fileSource, "import printf msvcrt.dll \n");
	fprintf(fileSource, "import scanf msvcrt.dll \n");

	fprintf(fileSource, "%s\n\n", dataSegment);
	fprintf(fileSource, "%s\n\n", codeSegment);
	
	return exitCode;
}




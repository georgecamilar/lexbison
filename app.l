%{
	#include <stdio.h>
	#include "app.tab.h"

	using namespace std;

	char* dataSegment;
	char* codeSegment;

	FILE* fileSource;
	FILE* outputFile;
	extern int yyparse();
	int yylex();
    int yyerror(const char* s);
%}

%option yylineno
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

. 														;	

[\t\n] 													;

%%

int yyerror(const char* s) {
	printf("%s on line %d\n", s, yylineno);
	return 1;
}

void addData (char data[1000]) {
	strcat(dataSegment, data);
}

void addCode (char code[1000]) {
	strcat(codeSegment, code);
}


int main(void) {
	fileSource = fopen("./data/testFile.cpp", "r");
	outputFile = fopen("./target/output.asm", "w");

	yyin = fileSource;
	yyout = outputFile;

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

	fprintf(outputFile, "bits 32\n");
	fprintf(outputFile, "global start\n");
	fprintf(outputFile, "extern exit, printf, scanf\n");
	fprintf(outputFile, "import exit msvcrt.dll \n");
	fprintf(outputFile, "import printf msvcrt.dll \n");
	fprintf(outputFile, "import scanf msvcrt.dll \n");

	fprintf(outputFile, "%s\n\n", dataSegment);
	fprintf(outputFile, "%s\n\n", codeSegment);
	
	return exitCode;
}




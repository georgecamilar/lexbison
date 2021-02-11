%{
    #include <cstdio>
    #include <stdio.h>
    #include <iostream>
    #include <string>
    using namespace std;

    extern FILE* fileSource;

    void addData(char data[1000]);
    void addCode(char code[1000]);
    extern int yyerror(const char* s);
    extern int yylex();

%}


%union{
    int number;
    char string[2000];
}

%error-verbose

%token <intValue> INT
%token <string> STRING
%token RRARROWS
%token CIN
%token LLARROWS
%token COUT
%token HEADER
%token CONSTANT
%token IDENTIFIER
%token NAMESPACESTATEMENT 
%type<string> CONSTANT IDENTIFIER variable expresie


%%

program: HEADER NAMESPACESTATEMENT programBody ;
programBody: INT IDENTIFIER '{' code '}' ;
code: instruction instructionOrDeclaration | instructionOrDeclaration;
instructionOrDeclaration: declaration | instruction ;
declaration: INT IDENTIFIER ';' {
            char code[1000];
            code[0] = 0;
            strcat(code, "\t");
            strcat(code, $2);
            strcat(code, " dd 0\n");
            addData(code);
            };
instruction: read | write | assign ;
read: COUT LLARROWS IDENTIFIER ';' {
            char code[1000];
			code[0] = 0;
			strcat(code, "\tpush ");
			strcat(code, "dword ");
			strcat(code, $3);
			strcat(code, "\n");
			addCode(code);
			addCode("\tpush dword _sformat\n");
			addCode("\tcall [scanf]\n");
			addCode("\tadd esp, 4 * 2\n");
        } ;

write: CIN RRARROWS IDENTIFIER ';' {
    char code[1000];
			code[0] = 0;
			strcat(code, "\n");
			strcat(code, "\tpush ");

			if(isdigit($3[0])) {
				strcat(code, $3);
			} else {
				strcat(code, "dword [");
				strcat(code, $3);
				strcat(code, "]\n");
			}
			strcat(code, "\n");
			addCode(code);
			addCode("\tpush dword _format\n");
			addCode("\tcall [printf]\n");
			addCode("\tadd esp, 4 * 2\n");
};

assign: IDENTIFIER '=' expresie ';' {
                char code[1000];
				code[0] = 0;
				strcat(code, "\tmov eax, 0\n");
				strcat(code, $3);
				strcat(code, "\tmov dword [");
				strcat(code, $1);
				strcat(code, "], ");
				strcat(code, "eax\n");
				addCode(code);
                };

expresie: expresie '+' variable {
                char code[1000];
				code[0] = 0;
				strcat(code, "\tadd eax, ");
				if(isdigit($3[0])) {
				  strcat(code, $3);
				} else {
				  strcat(code, "[");
				  strcat(code, $3);
				  strcat(code, "]");
				}
				strcat(code, "\n");

				strcpy($$, $1);
				strcat($$, code);   
            }
            | expresie '-' variable {
				char code[1000];
				code[0] = 0;
				strcat(code, "\tsub eax, ");
				if(isdigit($3[0])) {
				  strcat(code, $3);
				} else {
				  strcat(code, "[");
				  strcat(code, $3);
				  strcat(code, "]");
				}
				strcat(code, "\n");

				strcpy($$, $1);
				strcat($$, code);
			}
			
			| variable {
			
				char code[1000];
				code[0] = 0;
				strcat(code, "\tadd eax, ");
				if(isdigit($1[0])) {
				  strcat(code, $1);
				} else {
				  strcat(code, "[");
				  strcat(code, $1);
				  strcat(code, "]");
				}
				strcat(code, "\n");
				strcpy($$, code);
			
			}
			;

variable : IDENTIFIER {strcpy($$, $1);}
     | CONSTANT {strcpy($$, $1);}
     ;

%%

%{
	#include <iostream>
	#include <string>
	#include <cstdio>
	using namespace std;

	extern "C" int yylex();
	FILE* file;
%}

%option noyywrap

%%

[0-9]+ {
	printf("Hit a number");
}

[0-9]+\.[0-9]+  { 
	cout << "Found a floating-point number:" << yytext << endl;
}


[a-zA-Z]+ {
	cout<<"Found a word"<<endl;
	writeToFile(yylex, 1);
}


%%


void writeToFile(char* line, int status){
	file = fopen("./data/data.txt", "w")
}

int main(){
	yylex();
	return 0;
}


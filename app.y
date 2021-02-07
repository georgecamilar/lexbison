%{
    #include <cstdio>
    #include <iostream>
    using namespace std;

    extern int yylex();
    extern int yyparse();
    extern FILE *yyin;

    void yyerror(const char* s);
%}


%union{
    int intValue;
    char* charValue;
    float floatValue;
}

%token <intValue> INT
%token <charValue> STRING
%token <floatValue> FLOAT

%%


app:
    app INT {
        // printMessage("int", $2);
        cout << "bison found an int: " << $2 << endl;

    }
    | app FLOAT {
        // printMessage("float", $2);
        cout << "bison found a float: " << $2 << endl;
    }
    | app STRING {
        cout << "bison found a string: " << $2 << endl; free($2);
    }
    | INT {
        cout << "bison found an int: " << $1 << endl;
    }
    | FLOAT {
        cout << "bison found a float: " << $1 << endl;
    }
    | STRING {
        cout << "bison found a string: " << $1 << endl; free($1);
    }
;

%%

void printMessage(char* type, char* s) {
    cout <<"Bison found a type: " << type << " Value: " << s <<endl;  
}

int main(int, char**){
    FILE *myFile = fopen("bisonTokens.file", "r");
    if(!myFile){
        cout << "Cannot open bisonTokens file"<<endl;
        return -1;
    }

    yyin = myFile;
    yyparse();
}

void yyerror(const char* s){
    cout << "[ERROR] Parse Error Message : " << s << endl;
    exit(-1);
}
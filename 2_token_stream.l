%{
#include <stdio.h>
#include <string.h>

int lineno = 1;


int yywrap(void) { return 1; }

void report_error(const char *msg) {
    printf("Lexical error at line %d: %s ", lineno, msg);
}

void print_token(const char* token) {
    if (print_lineno) {
        printf("%d: ", lineno);
        
    }
    printf("%s ", token);
}
%}

%%

[\n] {
    lineno++;
    printf("\n");
}

[ \t]+

"//".*       

"/*"([^*]|\*+[^*/])*\*+"/"   

"int"|"float"|"char"|"double"   { print_token("DT"); }
"main"                         { print_token("ID"); }
[a-zA-Z_][a-zA-Z0-9_]*         { print_token("ID"); }

\#.*    { print_token("PREPROCESSOR"); }

"("   { print_token("("); }
")"   { print_token(")"); }
"{"   { print_token("{"); }
"}"   { print_token("}"); }

"=="  { print_token("=="); }
"!="  { print_token("!="); }
"<="  { print_token("<="); }
">="  { print_token(">="); }
"="   { print_token("="); }
"+"   { print_token("+"); }
"-"   { print_token("-"); }
"*"   { print_token("*"); }
"/"   { print_token("/"); }
"%"   { print_token("%"); }
";"   { print_token(";"); }
","   { print_token(","); }
"\""  { print_token("\""); }
"\'"  { print_token("\'"); }

[0-9]*\.[0-9]+   { print_token("FLOAT"); }
[0-9]+           { print_token("NUM"); }

. { print_token(""); report_error(yytext); }

%%

int main(void) {
    yylex();
    return 0;
}


flex 2.l
gcc lex.yy.c -o 2.exe
./2.exe < input.c



input:
#include <stdio.h>
int main() {
   int x = 10;
   float y = 20.5;
   return 0;

}

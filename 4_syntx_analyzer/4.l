%{
#include "analyzer.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>



char* my_strdup(const char* s) {
    char* d = malloc(strlen(s) + 1);
    if (d)
        strcpy(d, s);
    return d;
}
%}


%%

"if"      { return IF; }
"else"    { return ELSE; }
"while"   { return WHILE; }
"for"     { return FOR; }

[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = my_strdup(yytext); return ID; }
[0-9]+                { return NUM; }

"=="      { return EQ; }
"!="      { return NEQ; }
"<="      { return LE; }
">="      { return GE; }
"<"       { return LT; }
">"       { return GT; }

"="       { return ASSIGN; }
"+"       { return PLUS; }
"-"       { return MINUS; }
"*"       { return MUL; }
"/"       { return DIV; }
"%"       { return MOD; }

"++"      { return INC; }
"--"      { return DEC; }

"("       { return LPAREN; }
")"       { return RPAREN; }
"{"       { return LBRACE; }
"}"       { return RBRACE; }
";"       { return SEMI; }


[ \t\r]+  ;

.         { return yytext[0]; }

%%

int yywrap(void) {
    return 1;
}
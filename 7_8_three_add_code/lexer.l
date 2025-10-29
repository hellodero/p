%{
#include <stdio.h>
#include <string.h> /* <<--- ADD THIS LINE to define strdup() */
#include "p7_8.tab.h"
%}

%%
[ \t]         ;
"if"          { return IF; }
"else"        { return ELSE; }
"while"       { return WHILE; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.sval = strdup(yytext); return ID; }
[0-9]+        { yylval.sval = strdup(yytext); return NUM; }
">="          { return GE; }
"<="          { return LE; }
"=="          { return EQ; }
"!="          { return NE; }
">"           { return GT; }
"<"           { return LT; }
\n            { return 0; }
.             { return yytext[0]; }
%%

int yywrap(void) {
    return 1;
}
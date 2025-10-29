%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
%}

%%

"int"       { return INT_KEYWORD; }
[0-9]+      { yylval.num_val = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str_val = strdup(yytext); return IDENTIFIER; }

"="         { return ASSIGN; }
";"         { return SEMICOLON; }

"("         { return '('; }
")"         { return ')'; }

"//".*
"/*"([^*]|\*+[^*/])*"*/"
[ \t\r\n]+
.           { printf("Lexical Error: Unrecognized character '%s'\n", yytext); }

%%

int yywrap(void) {
    return 1;
}


%{
#include "parser.tab.h"
#include <stdlib.h>
%}

%option yylineno

%%

"if"        { return IF; }
"else"      { return ELSE; }
"for"       { return FOR; }

[0-9]+      { yylval = atoi(yytext); return NUM; }
[a-zA-Z_][a-zA-Z0-9_]*  { yylval = 0; return ID; }

"("         { return '('; }
")"         { return ')'; }

"="         { return EQ; }
";"         { return SEMI; }

[ \t\r\n]+    ;

"//".*
"/\*"([^*]|\*+[^*/])*"\*/"    

.           { printf("Unknown character (line %d): %s\n", yylineno, yytext); }

%%

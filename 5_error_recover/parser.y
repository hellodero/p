%{
#include <stdio.h>
#include <stdlib.h>
int yylex(void);
void yyerror(const char *s);

extern int yylineno;

void print_line_error(const char *s){
    fprintf(stderr, "Syntax error at line %d: %s\n", yylineno, s);
}
%}

%token IF ELSE FOR ID NUM
%token EQ SEMI

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%define parse.error verbose

%%

program
    : stms
    ;

stms
    : stms stm
    | stm
    ;

stm
    : expr SEMI
    | if_stmt
    | for_stmt
    | error SEMI        { print_line_error("Recovered from statement error"); }
    ;

expr
    : ID EQ NUM
    ;

if_stmt
    : IF '(' expr ')' stm
    | IF '(' expr ')' stm ELSE stm
    | IF '(' error ')' stm   { print_line_error("Error in if condition"); yyerrok; }
    ;

for_stmt
    : FOR '(' expr2 SEMI expr2 SEMI expr2 ')' stm
    | FOR '(' error ')' stm  { print_line_error("Error in for header"); yyerrok; }
    ;

expr2
    : expr
    | /* empty */
    | error   { print_line_error("Error in for expression"); yyerrok; }
    ;

%%

int main(int argc, char **argv) {
    return yyparse();
}

void yyerror(const char *s) {
    print_line_error("Error in for expression"); yyerrok;
    fprintf(stderr, "Syntax error: %s\n", s);
}

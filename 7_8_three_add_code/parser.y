%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(char *s);
extern int yylex();

int temp_count = 0;
int label_count = 0;

char* new_temp() {
    char* temp = malloc(8);
    sprintf(temp, "t%d", temp_count++);
    return temp;
}

char* new_label() {
    char* label = malloc(8);
    sprintf(label, "L%d", label_count++);
    return label;
}

%}

%union {
    char* sval;
}

%token <sval> ID NUM
%token IF ELSE WHILE
%token GE LE EQ NE GT LT

%type <sval> E T F Stmt M B N

%left '+' '-'
%left '*' '/'

%start program

%%

program:
    Stmt
    ;

Stmt:
      ID '=' E ';'                  { printf("%s = %s\n", $1, $3); }
    | IF '(' B ')' M Stmt N ELSE M Stmt { printf("%s:\n", $7); }
    | WHILE M '(' B ')' M Stmt        { printf("goto %s\n", $2); printf("%s:\n", $6); }
    ;

B: /* Boolean expression */
    E LT E  { $$ = new_label(); printf("if %s < %s goto %s\n", $1, $3, $$); }
    | E GT E  { $$ = new_label(); printf("if %s > %s goto %s\n", $1, $3, $$); }
    | E EQ E  { $$ = new_label(); printf("if %s == %s goto %s\n", $1, $3, $$); }
    ;

E: /* Expression */
    E '+' T   { $$ = new_temp(); printf("%s = %s + %s\n", $$, $1, $3); }
    | T
    ;

T:
    T '*' F   { $$ = new_temp(); printf("%s = %s * %s\n", $$, $1, $3); }
    | F
    ;

F:
    '(' E ')' { $$ = $2; }
    | ID
    | NUM
    ;

M: /* Marker for a new label */
    /* empty */ { $$ = new_label(); printf("%s:\n", $$); }
    ;

N: /* Marker for a goto */
    /* empty */ { $$ = new_label(); printf("goto %s\n", $$); }
    ;

%%

void yyerror(char *s) {
    fprintf(stderr, "Syntax Error: %s\n", s);
}

int main() {
    printf("Enter code to generate TAC (end with Ctrl+D or a newline):\n");
    yyparse();
    printf("---- END ----\n");
    return 0;
}
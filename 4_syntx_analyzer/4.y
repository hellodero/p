%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);
%}

%union {
    char* str;
}

%token <str> ID
%token NUM
%token IF ELSE WHILE FOR
%token EQ NEQ LE GE LT GT
%token INC DEC ASSIGN
%token PLUS MINUS MUL DIV MOD
%token LPAREN RPAREN LBRACE RBRACE SEMI

%right ASSIGN
%left EQ NEQ
%left LT GT LE GE
%left PLUS MINUS
%left MUL DIV MOD
%nonassoc IFX      
%nonassoc ELSE     

%%

Program:
    StmtList
    ;

StmtList:
    StmtList Stmt
    | 
    ;

Stmt:
    Expr SEMI
    | IF LPAREN Expr RPAREN Stmt %prec IFX 
    | IF LPAREN Expr RPAREN Stmt ELSE Stmt
    | WHILE LPAREN Expr RPAREN Stmt
    | FOR LPAREN OptExpr SEMI OptExpr SEMI OptExpr RPAREN Stmt
    | LBRACE StmtList RBRACE
    | SEMI
    ;

OptExpr:
    Expr
    | 
    ;

Expr:
    Term
    | ID ASSIGN Expr   
    | Expr PLUS Expr
    | Expr MINUS Expr
    | Expr MUL Expr
    | Expr DIV Expr
    | Expr MOD Expr
    | Expr EQ Expr
    | Expr NEQ Expr
    | Expr LE Expr
    | Expr GE Expr
    | Expr LT Expr
    | Expr GT Expr
    | LPAREN Expr RPAREN
    ;

Term:
    ID      
    | NUM
    | INC ID 
    | DEC ID 
    ;

%%

int main() {
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Syntax Error\n");
}
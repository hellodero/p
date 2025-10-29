%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);

typedef struct {
    char *name;
    char *type;
} Symbol;

Symbol symbolTable[256];
int symbolCount = 0;

int findSymbol(char *name) {
    for (int i = 0; i < symbolCount; i++) {
        if (strcmp(symbolTable[i].name, name) == 0) {
            return i;
        }
    }
    return -1;
}

int createSymbol(char *name, char *type) {
    if (findSymbol(name) != -1) {
        return 0; 
    }
    symbolTable[symbolCount].name = strdup(name);
    symbolTable[symbolCount].type = strdup(type);
    symbolCount++;
    return 1;
}

void verifySymbol(char *name) {
    if (findSymbol(name) == -1) {
        printf("Semantic Error: Variable '%s' is not declared.\n", name);
    }
}

void displaySymbolTable() {
    printf("\n--- Symbol Table ---\n");
    printf("Index | Name  | Type\n");
    printf("--------------------\n");
    for (int i = 0; i < symbolCount; i++) {
        printf("%-5d | %-5s | %s\n", i, symbolTable[i].name, symbolTable[i].type);
    }
    printf("--------------------\n");
}

%}

%union {
    int num_val;
    char *str_val;
}

%token <str_val> IDENTIFIER
%token <num_val> NUMBER
%token INT_KEYWORD ASSIGN SEMICOLON

%%

program:
    statements { displaySymbolTable(); }
    ;

statements:
    statements statement
    | statement
    ;

statement:
    declaration SEMICOLON { }
    | assignment SEMICOLON { }
    ;

declaration:
    INT_KEYWORD IDENTIFIER {
        if (!createSymbol($2, "int")) {
            printf("Semantic Error: Redeclaration of variable '%s'.\n", $2);
        }
        free($2);
    }
    ;

assignment:
    IDENTIFIER ASSIGN NUMBER {
        verifySymbol($1);
        free($1);
    }
    | IDENTIFIER ASSIGN IDENTIFIER {
        verifySymbol($1);
        verifySymbol($3);
        free($1);
        free($3);
    }
    ;

%%

int main() {
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Syntax Error: %s\n", s);
}


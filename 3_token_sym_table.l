%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAX_TOKENS 100

typedef enum {
    SYM_VARIABLE,
    SYM_FUNCTION,
    SYM_LABEL,
    SYM_PREPROCESSOR,
    SYM_KEYWORD,
    SYM_CONSTANT,
    SYM_OPERATOR,
    SYM_SYMBOL
} SymbolCategory;

typedef struct {
    char *token;
    SymbolCategory category;
} Symbol;

Symbol symbol_table[MAX_TOKENS];

int symbol_count = 0;

void add_token_to_table(const char *token, SymbolCategory category);
void print_symbol_table();

int lineno = 1;

int print_lineno = 1;
int yywrap(void) { return 1; }
void report_error(const char *msg) {

    printf("Lexical error at line %d: %s ", lineno, msg);

}



void print_token(const char* token) {

    if (print_lineno) {

        printf("%d: ", lineno);

        print_lineno = 0;

    }

    printf("%s ", token);

}

%}



%%



[\n] {

    lineno++;

    print_lineno = 1;

    printf("\n");

}



[ \t]+   ;



"#".*        { print_token("PREPROC"); add_token_to_table(yytext, SYM_PREPROCESSOR); }



"int"|"float"|"char"|"double"|"return"   { print_token("KW"); add_token_to_table(yytext, SYM_KEYWORD); }



[a-zA-Z_][a-zA-Z0-9_]* {

    int c = input();

    if (c == '(') {

        print_token("FUNC");

        add_token_to_table(yytext, SYM_FUNCTION);

        unput(c);

    } else if (c == ':') {

        print_token("LABEL");

        add_token_to_table(yytext, SYM_LABEL);

        unput(c);

    } else {

        print_token("ID");

        add_token_to_table(yytext, SYM_VARIABLE);

        unput(c);

    }

}







[0-9]+\.[0-9]+   { print_token("FLOAT_CONST"); add_token_to_table(yytext, SYM_CONSTANT); }

[0-9]+           { print_token("INT_CONST"); add_token_to_table(yytext, SYM_CONSTANT); }



"(" | ")" | "{" | "}" | ";" | ","   { print_token("SYM"); add_token_to_table(yytext, SYM_SYMBOL); }



. { report_error(yytext); }



%%



void add_token_to_table(const char *token, SymbolCategory category) {

    if (symbol_count < MAX_TOKENS) {

        symbol_table[symbol_count].token = strdup(token);

        symbol_table[symbol_count].category = category;

        symbol_count++;

    }

}



void print_symbol_table() {

    printf("\n\nSymbol Table:\n");

    for (int i = 0; i < symbol_count; i++) {

        const char *cat_str;

        switch (symbol_table[i].category) {

            case SYM_VARIABLE: cat_str = "Variable"; break;

            case SYM_FUNCTION: cat_str = "Function"; break;

            case SYM_LABEL: cat_str = "Label"; break;

            case SYM_PREPROCESSOR: cat_str = "Preprocessor"; break;

            case SYM_KEYWORD: cat_str = "Keyword"; break;

            case SYM_CONSTANT: cat_str = "Constant"; break;

            case SYM_SYMBOL: cat_str = "Special Symbol"; break;

            default: cat_str = "Unknown"; break;

        }

        printf("%s    : %s\n", symbol_table[i].token, cat_str);

        free(symbol_table[i].token);

    }

}



int main() {

    yylex();

    print_symbol_table();

    return 0;

}
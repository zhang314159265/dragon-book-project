%{
#include <ctype.h>
#include <stdio.h>

int yylex();
void yyerror(const char*);
#define YYSTYPE double

%}

%token NUMBER

%left '+' '-'
%left '*' '/'
%right UMINUS

%%

lines : lines expr '\n' { printf("%lf\n", $2); } 
      | lines '\n' 
      | /* empty */
      ;

expr : expr '+' expr { $$ = $1 + $3; }
     | expr '-' expr { $$ = $1 - $3; }
     | expr '*' expr { $$ = $1 * $3; }
     | expr '/' expr { $$ = $1 / $3; }
     | '-' expr %prec UMINUS { $$ = -$2; }
     | '(' expr ')' { $$ = $2; }
     | NUMBER
     ;

%%

#if 0
int yylex() {
  int c;
  while ((c = getchar()) == ' ') {
  }

  if (c == '.' || isdigit(c)) {
    ungetc(c, stdin);
    scanf("%lf", &yylval);
    return NUMBER;
  }
  return c;
}
#endif

#include "lex.yy.c"

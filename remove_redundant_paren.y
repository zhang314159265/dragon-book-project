%{
#include <stdio.h>
#include <ctype.h>
int yylex(void);
void yyerror(const char *);

struct Attributes {
  char buf[4096]; // TODO: C++ string should be better here. If we want, we can define the attributes in a separate C++ file and let this C file depends on the C++ file
  int need_protect;
};
#define YYSTYPE struct Attributes
%}
%token ID

%%

line : expr '\n' { printf("%s\n", $1.buf); }

expr : expr '+' term {
       $$.need_protect = 1;
       sprintf($$.buf, "%s+%s", $1.buf, $3.buf);
     }
     | term
     ;

term : term '*' factor {
         $$.need_protect = 0;
         char *ptr = $$.buf;
         if ($1.need_protect) {
           ptr += sprintf(ptr, "%c", '('); 
         }
         ptr += sprintf(ptr, "%s", $1.buf);
         if ($1.need_protect) {
           ptr += sprintf(ptr, "%c", ')'); 
         }
         ptr += sprintf(ptr, "*");

         // NOTE: we may need protect factor by parenthesis since we have ignored parenthesis for the factor production
         if ($3.need_protect) {
           ptr += sprintf(ptr, "%c", '('); 
         }
         ptr += sprintf(ptr, "%s", $3.buf);
         if ($3.need_protect) {
           ptr += sprintf(ptr, "%c", ')'); 
         }
       }
     | factor
     ;

factor : '(' expr ')' { $$ = $2; }
       | ID
       ;

%%

int yylex(void) {
  char ch;
  while ((ch = fgetc(stdin)) == ' ') {
  }
  if (isalpha(ch)) {
    yylval.need_protect = 0;
    sprintf(yylval.buf, "%c", ch);
    return ID;
  } else {
    return ch;
  }
}

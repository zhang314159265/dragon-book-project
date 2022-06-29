letter [a-zA-Z_]
digit [0-9]

%%
float { printf("double"); }

{letter}({letter}|{digit})* {
  /* The rule is needed so float2 is not treated as float */
  printf("%*s", (int) yyleng, yytext); 
}

. {
  /* anything else */
  printf("%c", yytext[0]);
}

%%

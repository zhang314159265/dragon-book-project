%%

[ \t]+ { return ' '; }
. { return yytext[0]; }

%%

int main(void) {
  int tok;
  while ((tok = yylex())) {
    printf("%c", (char) tok);
  }
  return 0;
}

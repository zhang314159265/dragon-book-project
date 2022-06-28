/*
 * Translate an infix expressoin to an postfix expression
 *
 * Original Grammar:
 *   expr -> expr + term { print + }
 *         | expr - term { print - }
 *         | term
 *
 *   term -> digit {print digit}
 *
 * Eliminate left-recursion:
 *   expr -> term rest
 *   rest -> + term { print + } rest
 *         | - term { print - } rest
 *         | epsilon
 *   term the same as above
 */
#include <assert.h>
#include <stdio.h>
#include <cctype>

class Postfix {
 public:
  explicit Postfix() {
    next();
  }

  void expr() {
    term();
    while (lookahead_ == '+' || lookahead_ == '-') {
      int op = lookahead_;
      match(lookahead_); // or call next directly
      term();
      printf("%c", (char) op);
    }

    // assert everything is consumed
    match(EOF);
  }

  void term() {
    if (isdigit(lookahead_)) {
      printf("%c", lookahead_);
      next();
    } else {
      assert(false && "unexpected token");
    }
  }

  void match(int expected) {
    if (expected != lookahead_) {
      printf("Expected %d('%c') but got %d('%c')\n", expected, (char) expected, lookahead_, (char)lookahead_);
      assert(false);
    }
    next();
  }

  void next() {
    lookahead_ = fgetc(stdin);
  }
 private:
  int lookahead_;
};

int main(void) {
  Postfix postfix;
  postfix.expr();
  printf("\n");
  return 0;
}

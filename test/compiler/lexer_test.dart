library poma.compiler.lexer.test;

import 'package:unittest/unittest.dart';
import 'package:poma/src/compiler/lexer.dart';
import 'package:poma/src/compiler/token.dart';

main() {
  group('Lexer success tests', () {
    test('Identifiers', () {
      var document = 'Banana123 mango_orange DoIt';
      var expectedTokens = <Token>[
        new Token(0, 0, '', TokenCategory.INDENTATION),
        new Token(0, 0, 'Banana123', TokenCategory.IDENTIFIER),
        new Token(0, 10, 'mango_orange', TokenCategory.IDENTIFIER),
        new Token(0, 23, 'DoIt', TokenCategory.IDENTIFIER),
        new Token(0, 27, '\n', TokenCategory.NEWLINE)
      ];
      expect(new Lexer(document).analyze().tokens, equals(expectedTokens));
    });

    test('Integer literals', () {
      var document = '0 123 -4567';
      var expectedTokens = <Token>[
        new Token(0, 0, '', TokenCategory.INDENTATION),
        new Token(0, 0, '0', TokenCategory.INTEGER_LITERAL),
        new Token(0, 2, '123', TokenCategory.INTEGER_LITERAL),
        new Token(0, 6, '-', TokenCategory.MINUS),
        new Token(0, 7, '4567', TokenCategory.INTEGER_LITERAL),
        new Token(0, 11, '\n', TokenCategory.NEWLINE)
      ];
      expect(new Lexer(document).analyze().tokens, equals(expectedTokens));
    });

    test('Assignment', () {
      var document = 'a=5';
      var expectedTokens = <Token>[
        new Token(0, 0, '', TokenCategory.INDENTATION),
        new Token(0, 0, 'a', TokenCategory.IDENTIFIER),
        new Token(0, 1, '=', TokenCategory.ASSIGNMENT),
        new Token(0, 2, '5', TokenCategory.INTEGER_LITERAL),
        new Token(0, 3, '\n', TokenCategory.NEWLINE)
      ];
      expect(new Lexer(document).analyze().tokens, equals(expectedTokens));
    });

    test('Parenthesis', () {
      var document = '())(';
      var expectedTokens = <Token>[
        new Token(0, 0, '', TokenCategory.INDENTATION),
        new Token(0, 0, '(', TokenCategory.OPEN_PAREN),
        new Token(0, 1, ')', TokenCategory.CLOSED_PAREN),
        new Token(0, 2, ')', TokenCategory.CLOSED_PAREN),
        new Token(0, 3, '(', TokenCategory.OPEN_PAREN),
        new Token(0, 4, '\n', TokenCategory.NEWLINE)
      ];
      expect(new Lexer(document).analyze().tokens, equals(expectedTokens));
    });

    test('Keywords', () {
      var document = 'and android classname class if IF while wHiLe';
      var expectedTokens = <Token>[
        new Token(0, 0, '', TokenCategory.INDENTATION),
        new Token(0, 0, 'and', TokenCategory.AND),
        new Token(0, 4, 'android', TokenCategory.IDENTIFIER),
        new Token(0, 12, 'classname', TokenCategory.IDENTIFIER),
        new Token(0, 22, 'class', TokenCategory.CLASS),
        new Token(0, 28, 'if', TokenCategory.IF),
        new Token(0, 31, 'IF', TokenCategory.IF),
        new Token(0, 34, 'while', TokenCategory.WHILE),
        new Token(0, 40, 'wHiLe', TokenCategory.IDENTIFIER),
        new Token(0, 45, '\n', TokenCategory.NEWLINE)
      ];
      expect(new Lexer(document).analyze().tokens, equals(expectedTokens));
    });

    test('Logical operators', () {
      var document = 'and && or || not !';
      var expectedTokens = <Token>[
        new Token(0, 0, '', TokenCategory.INDENTATION),
        new Token(0, 0, 'and', TokenCategory.AND),
        new Token(0, 4, '&&', TokenCategory.AND),
        new Token(0, 7, 'or', TokenCategory.OR),
        new Token(0, 10, '||', TokenCategory.OR),
        new Token(0, 13, 'not', TokenCategory.NOT),
        new Token(0, 17, '!', TokenCategory.NOT),
        new Token(0, 18, '\n', TokenCategory.NEWLINE)
      ];
      expect(new Lexer(document).analyze().tokens, equals(expectedTokens));
    });

    test('Arithmetic operators', () {
      var document = '+ - * / %';
      var expectedTokens = <Token>[
        new Token(0, 0, '', TokenCategory.INDENTATION),
        new Token(0, 0, '+', TokenCategory.PLUS),
        new Token(0, 2, '-', TokenCategory.MINUS),
        new Token(0, 4, '*', TokenCategory.TIMES),
        new Token(0, 6, '/', TokenCategory.DIVIDE),
        new Token(0, 8, '%', TokenCategory.MODULO),
        new Token(0, 9, '\n', TokenCategory.NEWLINE)
      ];
      expect(new Lexer(document).analyze().tokens, equals(expectedTokens));
    });

    test('Relational operators', () {
      var document = '== != < <= > >=';
      var expectedTokens = <Token>[
        new Token(0, 0, '', TokenCategory.INDENTATION),
        new Token(0, 0, '==', TokenCategory.EQUALS),
        new Token(0, 3, '!=', TokenCategory.NOT_EQUALS),
        new Token(0, 6, '<', TokenCategory.LESS_THAN),
        new Token(0, 8, '<=', TokenCategory.LESS_THAN_OR_EQUALS),
        new Token(0, 11, '>', TokenCategory.GREATER_THAN),
        new Token(0, 13, '>=', TokenCategory.GREATER_THAN_OR_EQUALS),
        new Token(0, 15, '\n', TokenCategory.NEWLINE)
      ];
      expect(new Lexer(document).analyze().tokens, equals(expectedTokens));
    });

    test('Separators', () {
      var document = '.,:';
      var expectedTokens = <Token>[
        new Token(0, 0, '', TokenCategory.INDENTATION),
        new Token(0, 0, '.', TokenCategory.DOT),
        new Token(0, 1, ',', TokenCategory.COMMA),
        new Token(0, 2, ':', TokenCategory.COLON),
        new Token(0, 3, '\n', TokenCategory.NEWLINE)
      ];
      expect(new Lexer(document).analyze().tokens, equals(expectedTokens));
    });

    test('Swallows whitespace', () {
      var document = '    a  b    c   ';
      var expectedTokens = <Token>[
        new Token(0, 0, '    ', TokenCategory.INDENTATION),
        new Token(0, 4, 'a', TokenCategory.IDENTIFIER),
        new Token(0, 7, 'b', TokenCategory.IDENTIFIER),
        new Token(0, 12, 'c', TokenCategory.IDENTIFIER),
        new Token(0, 16, '\n', TokenCategory.NEWLINE)
      ];
      expect(new Lexer(document).analyze().tokens, equals(expectedTokens));
    });

    test('Swallows blank lines', () {
      var document =
          '       \n'
          '    firstIdentifier\n'
          '\n'
          '     secondIdentifier\n'
          '   ';
      var expectedTokens = <Token>[
        new Token(1, 0, '    ', TokenCategory.INDENTATION),
        new Token(1, 4, 'firstIdentifier', TokenCategory.IDENTIFIER),
        new Token(1, 19, '\n', TokenCategory.NEWLINE),
        new Token(3, 0, '     ', TokenCategory.INDENTATION),
        new Token(3, 5, 'secondIdentifier', TokenCategory.IDENTIFIER),
        new Token(3, 21, '\n', TokenCategory.NEWLINE)
      ];
      expect(new Lexer(document).analyze().tokens, equals(expectedTokens));
    });
  });
}
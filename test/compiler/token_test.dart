library poma.compiler.token.test;

import 'package:unittest/unittest.dart';
import 'package:poma/src/compiler/token.dart';

main() {
  group('Token category tests', () {
    test('Arithmetic operator', () {
      var token = new Token(5, 10, '+', TokenCategory.PLUS);
      expect(token.inCategory(TokenCategory.OPERATOR), isTrue);
      expect(token.inCategory(TokenCategory.ARITHMETIC_OPERATOR), isTrue);
      expect(token.inCategory(TokenCategory.PLUS), isTrue);
      expect(token.inCategory(TokenCategory.SEPARATOR), isFalse);
    });

    test('Relational operator', () {
      var token = new Token(5, 10, '>', TokenCategory.GREATER_THAN);
      expect(token.inCategory(TokenCategory.OPERATOR), isTrue);
      expect(token.inCategory(TokenCategory.RELATIONAL_OPERATOR), isTrue);
      expect(token.inCategory(TokenCategory.GREATER_THAN), isTrue);
      expect(token.inCategory(TokenCategory.SEPARATOR), isFalse);
    });

    test('Logical operator', () {
      var token = new Token(5, 10, '&&', TokenCategory.AND);
      expect(token.inCategory(TokenCategory.OPERATOR), isTrue);
      expect(token.inCategory(TokenCategory.LOGICAL_OPERATOR), isTrue);
      expect(token.inCategory(TokenCategory.AND), isTrue);
      expect(token.inCategory(TokenCategory.SEPARATOR), isFalse);
    });

    test('Integer literal', () {
      var token = new Token(5, 10, '12345', TokenCategory.INTEGER_LITERAL);
      expect(token.inCategory(TokenCategory.LITERAL), isTrue);
      expect(token.inCategory(TokenCategory.INTEGER_LITERAL), isTrue);
      expect(token.inCategory(TokenCategory.SEPARATOR), isFalse);
    });
  });

  group('Equality tests', () {
    test('Equality test', () {
      var token = new Token(15, 5, '==', TokenCategory.EQUALS);
      expect(token, equals(new Token(15, 5, '==', TokenCategory.EQUALS)));
      expect(token, isNot(equals(new Token(15, 5, '==', TokenCategory.OPERATOR))));
      expect(token, isNot(equals(new Token(15, 5, '<', TokenCategory.EQUALS))));
    });
  });
}

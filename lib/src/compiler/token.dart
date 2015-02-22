library poma.compiler.token;

enum TokenCategory {
  INDENTATION,
  NEWLINE,
  IDENTIFIER,
  LITERAL,
  INTEGER_LITERAL,
  ASSIGNMENT,
  SEPARATOR,
  COMMA,
  DOT,
  COLON,
  PARENTHESIS,
  OPEN_PAREN,
  CLOSED_PAREN,
  OPERATOR,
  ARITHMETIC_OPERATOR,
  PLUS,
  MINUS,
  TIMES,
  DIVIDE,
  MODULO,
  LOGICAL_OPERATOR,
  AND,
  OR,
  NOT,
  RELATIONAL_OPERATOR,
  EQUALS,
  NOT_EQUALS,
  LESS_THAN,
  LESS_THAN_OR_EQUALS,
  GREATER_THAN,
  GREATER_THAN_OR_EQUALS,
  IF,
  WHILE,
  CLASS,
}

class Token {
  final int row;
  final int col;
  final String text;
  final TokenCategory category;
  const Token(this.row, this.col, this.text, this.category);

  bool operator ==(Token that) {
    return this.row == that.row &&
           this.col == that.col &&
           this.text == that.text &&
           this.category == that.category;
  }

  String toString() {
    return category == TokenCategory.NEWLINE
        ? '"<newline>" at $row:$col, category: $category'
        : '"$text" at $row:$col, category: $category';
  }

  bool inCategory(TokenCategory targetCategory) {
    return _inCategory(category, targetCategory);
  }

  static bool _inCategory(TokenCategory category,
                          TokenCategory targetCategory) {
    if (category == null) return false;
    if (category == targetCategory) return true;
    return _inCategory(_parentCategory[category], targetCategory);
  }

  static final Map<TokenCategory, TokenCategory> _parentCategory =
      <TokenCategory, TokenCategory>{
        TokenCategory.INTEGER_LITERAL: TokenCategory.LITERAL,
        TokenCategory.COMMA: TokenCategory.SEPARATOR,
        TokenCategory.DOT: TokenCategory.SEPARATOR,
        TokenCategory.COLON: TokenCategory.SEPARATOR,
        TokenCategory.OPEN_PAREN: TokenCategory.PARENTHESIS,
        TokenCategory.CLOSED_PAREN: TokenCategory.SEPARATOR,
        TokenCategory.ARITHMETIC_OPERATOR: TokenCategory.OPERATOR,
        TokenCategory.PLUS: TokenCategory.ARITHMETIC_OPERATOR,
        TokenCategory.MINUS: TokenCategory.ARITHMETIC_OPERATOR,
        TokenCategory.TIMES: TokenCategory.ARITHMETIC_OPERATOR,
        TokenCategory.DIVIDE: TokenCategory.ARITHMETIC_OPERATOR,
        TokenCategory.MODULO: TokenCategory.ARITHMETIC_OPERATOR,
        TokenCategory.LOGICAL_OPERATOR: TokenCategory.OPERATOR,
        TokenCategory.AND: TokenCategory.LOGICAL_OPERATOR,
        TokenCategory.OR: TokenCategory.LOGICAL_OPERATOR,
        TokenCategory.NOT: TokenCategory.LOGICAL_OPERATOR,
        TokenCategory.RELATIONAL_OPERATOR: TokenCategory.OPERATOR,
        TokenCategory.EQUALS: TokenCategory.RELATIONAL_OPERATOR,
        TokenCategory.NOT_EQUALS: TokenCategory.RELATIONAL_OPERATOR,
        TokenCategory.LESS_THAN: TokenCategory.RELATIONAL_OPERATOR,
        TokenCategory.LESS_THAN_OR_EQUALS: TokenCategory.RELATIONAL_OPERATOR,
        TokenCategory.GREATER_THAN: TokenCategory.RELATIONAL_OPERATOR,
        TokenCategory.GREATER_THAN_OR_EQUALS: TokenCategory.RELATIONAL_OPERATOR,
      };
}

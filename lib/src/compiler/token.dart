library poma.compiler.token;

enum TokenCategory {
  SPACE,
  NEWLINE,
  IDENTIFIER,
  LITERAL,
  INTEGER_LITERAL,
  SEPARATOR,
  PARENTHESIS,
  OPERATOR,
  ARITHMETIC_OPERATOR,
  LOGICAL_OPERATOR
}

class Token {
  final num row;
  final num col;
  final String text;
  final TokenCategory category;
  final num count;
  const Token(this.row, this.col, this.text, this.category, this.count);
  
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
        TokenCategory.ARITHMETIC_OPERATOR: TokenCategory.OPERATOR,
        TokenCategory.LOGICAL_OPERATOR: TokenCategory.OPERATOR,
        TokenCategory.INTEGER_LITERAL: TokenCategory.LITERAL,
      };
} 
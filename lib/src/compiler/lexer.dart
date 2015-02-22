library poma.compiler.lexer;

import 'package:poma/src/compiler/token.dart';

class LexerResult {
  final List<Token> tokens;
  final String error;
  const LexerResult.Success(this.tokens) : error = null;
  const LexerResult.Failure(this.error) : tokens = null;
}

class TokenMatcher {
  final Pattern pattern;
  final TokenCategory category;
  const TokenMatcher(this.pattern, this.category);
}

class KeywordMatcher {
  final String keyword;
  final TokenCategory category;
  const KeywordMatcher(this.keyword, this.category);
}

class Lexer {
  List<Token> _tokens = new List<Token>();
  int _pos = 0;
  int _row = 0;
  int _col = 0;
  String _doc;

  Lexer(this._doc);

  LexerResult analyze() {
    while (_pos != _doc.length) {
      if (_col == 0) {
        _matches(_indentationPattern, TokenCategory.INDENTATION);
        if (_pos == _doc.length) break;
      }
      if (_matches(_whitespacePattern, null)) continue;
      if (_matches(_newlinePattern, TokenCategory.NEWLINE)) continue;
      if (!_triggersAnyBaseMatcher()) {
        return new LexerResult.Failure(
            'Unexpected character at row ${_row + 1}, column ${_col + 1}');
      }
    }
    if (_tokens.isEmpty) {
      return new LexerResult.Failure('The source code is empty.');
    }
    _maybeAddNewlineToken();
    return new LexerResult.Success(_tokens);
  }

  void _maybeAddNewlineToken() {
    if (_tokens.last.category == TokenCategory.INDENTATION) {
      _tokens.removeLast();
    } else if (_tokens.last.category != TokenCategory.NEWLINE) {
      _tokens.add(new Token(_row, _col, '\n', TokenCategory.NEWLINE));
    }
  }

  bool _triggersAnyBaseMatcher() {
    for (var tokenMatcher in _baseMatchers) {
      if (_matches(tokenMatcher.pattern, tokenMatcher.category)) return true;
    }
    return false;
  }

  bool _identifierIsAKeyword(String identifier) {
    for (var keywordMatcher in _keywordMatchers) {
      if (keywordMatcher.keyword == identifier) {
        _tokens.add(new Token(_row, _col, identifier,
                    keywordMatcher.category));
        return true;
      }
    }
    return false;
  }

  bool _matches(Pattern pattern, TokenCategory category) {
    var match = pattern.matchAsPrefix(_doc, _pos);
    if (match == null) return false;

    if (category == TokenCategory.NEWLINE) {
      _maybeAddNewlineToken();
      _row += 1;
      _col = 0;
    } else {
      if (category != null &&
          (category != TokenCategory.IDENTIFIER ||
           !_identifierIsAKeyword(match.group(0)))) {
        _tokens.add(new Token(_row, _col, match.group(0), category));
      }
      _col += match.group(0).length;
    }
    _pos += match.group(0).length;
    return true;
  }

  final RegExp _indentationPattern = new RegExp(' *');
  final RegExp _whitespacePattern = new RegExp(' +');
  final RegExp _newlinePattern = new RegExp('\n');
  final RegExp _identifierPattern = new RegExp('[a-zA-Z][a-zA-z0-9_]*');

  final List<TokenMatcher> _baseMatchers = <TokenMatcher>[
    new TokenMatcher('\n', TokenCategory.NEWLINE),
    new TokenMatcher(',', TokenCategory.COMMA),
    new TokenMatcher('.', TokenCategory.DOT),
    new TokenMatcher(':', TokenCategory.COLON),
    new TokenMatcher('(', TokenCategory.OPEN_PAREN),
    new TokenMatcher(')', TokenCategory.CLOSED_PAREN),
    new TokenMatcher('+', TokenCategory.PLUS),
    new TokenMatcher('-', TokenCategory.MINUS),
    new TokenMatcher('*', TokenCategory.TIMES),
    new TokenMatcher('/', TokenCategory.DIVIDE),
    new TokenMatcher('%', TokenCategory.MODULO),
    new TokenMatcher('==', TokenCategory.EQUALS),
    new TokenMatcher('!=', TokenCategory.NOT_EQUALS),
    new TokenMatcher('<=', TokenCategory.LESS_THAN_OR_EQUALS),
    new TokenMatcher('>=', TokenCategory.GREATER_THAN_OR_EQUALS),
    new TokenMatcher('<', TokenCategory.LESS_THAN),
    new TokenMatcher('>', TokenCategory.GREATER_THAN),
    new TokenMatcher('&&', TokenCategory.AND),
    new TokenMatcher('||', TokenCategory.OR),
    new TokenMatcher('!', TokenCategory.NOT),
    new TokenMatcher('=', TokenCategory.ASSIGNMENT),
    new TokenMatcher(':=', TokenCategory.ASSIGNMENT),
    new TokenMatcher(new RegExp('[a-zA-Z][a-zA-z0-9_]*'), TokenCategory.IDENTIFIER),
    new TokenMatcher(new RegExp('[0-9]+'), TokenCategory.INTEGER_LITERAL),
  ];

  final List<KeywordMatcher> _keywordMatchers = <KeywordMatcher>[
    new KeywordMatcher('and', TokenCategory.AND),
    new KeywordMatcher('AND', TokenCategory.AND),
    new KeywordMatcher('or', TokenCategory.OR),
    new KeywordMatcher('OR', TokenCategory.OR),
    new KeywordMatcher('not', TokenCategory.NOT),
    new KeywordMatcher('NOT', TokenCategory.NOT),
    new KeywordMatcher('if', TokenCategory.IF),
    new KeywordMatcher('IF', TokenCategory.IF),
    new KeywordMatcher('while', TokenCategory.WHILE),
    new KeywordMatcher('WHILE', TokenCategory.WHILE),
    new KeywordMatcher('class', TokenCategory.CLASS),
    new KeywordMatcher('CLASS', TokenCategory.CLASS),
  ];
}

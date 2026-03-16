{loadGrammar} = require('../utils/loadGrammar')
require('../utils/compatibleExpect')
{expect} = require('chai')

describe 'PHP regexp grammar', ->
  grammar = null
  before(-> grammar = await loadGrammar('source.php'))

  expectPlainAssignment = (tokens) ->
    expect(tokens[0]).toEqual value: '$', scopes: ['source.php', 'variable.other.php', 'punctuation.definition.variable.php']
    expect(tokens[1]).toEqual value: 'x', scopes: ['source.php', 'variable.other.php']
    expect(tokens[2]).toEqual value: ' ', scopes: ['source.php']
    expect(tokens[3]).toEqual value: '=', scopes: ['source.php', 'keyword.operator.assignment.php']
    expect(tokens[4]).toEqual value: ' ', scopes: ['source.php']
    expect(tokens[5]).toEqual value: '1', scopes: ['source.php', 'constant.numeric.decimal.php']
    expect(tokens[6]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

  quotedSingleRegexpScope = ['source.php', 'meta.embedded.regexp.php', 'string.regexp.single-quoted.php']
  quotedDoubleRegexpScope = ['source.php', 'meta.embedded.regexp.php', 'string.regexp.double-quoted.php']
  heredocRegexpBoundaryScope = ['source.php', 'string.unquoted.heredoc.php', 'meta.embedded.regexp.php']
  heredocRegexpScope = heredocRegexpBoundaryScope.concat ['string.regexp.heredoc.php']
  nowdocRegexpBoundaryScope = ['source.php', 'string.unquoted.nowdoc.php', 'meta.embedded.regexp.php']
  nowdocRegexpScope = nowdocRegexpBoundaryScope.concat ['string.regexp.nowdoc.php']
  regexpCharacterClassBoundaryScope = ['meta.embedded.character-class.regexp.php']
  regexpCharacterClassScope = ['meta.embedded.character-class.regexp.php', 'constant.other.character-class.set.regexp.php']
  regexpCharacterClassScopes = (baseScope) ->
    baseScope.concat regexpCharacterClassScope
  regexpCharacterClassPunctuationScopes = (baseScope) ->
    baseScope.concat regexpCharacterClassBoundaryScope.concat ['punctuation.definition.character-class.regexp.php']
  regexpCharacterClassBoundaryNegationScopes = (baseScope) ->
    baseScope.concat regexpCharacterClassBoundaryScope.concat ['keyword.operator.negation.regexp.php']
  regexpCharacterClassLiteralScopes = (baseScope) ->
    regexpCharacterClassScopes(baseScope)
  regexpCharacterClassEscapeScopes = (baseScope) ->
    regexpCharacterClassScopes(baseScope).concat ['constant.character.escape.php']
  regexpCharacterClassPhpHexEscapeScopes = (baseScope) ->
    regexpCharacterClassScopes(baseScope).concat ['constant.character.escape.hex.php']
  regexpCharacterClassNumericScopes = (baseScope) ->
    regexpCharacterClassScopes(baseScope).concat ['constant.numeric.regexp.php']
  regexpCharacterClassLetterRangeScopes = (baseScope) ->
    regexpCharacterClassScopes(baseScope).concat ['variable.other.constant.character-class.range.regexp.php']
  regexpCharacterClassDigitRangeScopes = (baseScope) ->
    regexpCharacterClassScopes(baseScope).concat ['constant.numeric.character-class.range.regexp.php']
  regexpCharacterClassGenericRangeScopes = (baseScope) ->
    regexpCharacterClassScopes(baseScope).concat ['constant.other.character-class.range.regexp.php', 'support.class.range.regexp.php']
  regexpCharacterClassHexRangeScopes = (baseScope) ->
    regexpCharacterClassScopes(baseScope).concat ['constant.other.character-class.range.regexp.php', 'support.class.range.regexp.php']
  regexpCharacterClassPosixScope = ['meta.embedded.character-class.posix.regexp.php', 'constant.other.character-class.posix.regexp.php']
  regexpCharacterClassPosixScopes = (baseScope) ->
    regexpCharacterClassScopes(baseScope).concat regexpCharacterClassPosixScope
  regexpGroupScope = ['meta.embedded.group.regexp.php']
  regexpGroupScopes = (baseScope) ->
    baseScope.concat regexpGroupScope
  regexpGroupContentScopes = (baseScope) ->
    regexpGroupScopes(baseScope).concat [baseScope[baseScope.length - 1]]
  regexpSpecificGroupPunctuationScopes = (baseScope, specificScope) ->
    baseScope.concat ['punctuation.definition.group.regexp.php', specificScope]
  regexpGroupNameScopes = (baseScope) ->
    baseScope.concat ['variable.other.regexp.php']
  regexpNamedBackreferenceScopes = (baseScope) ->
    baseScope.concat ['keyword.other.back-reference.named.regexp.php']
  regexpNamedBackreferenceNameScopes = (baseScope) ->
    regexpNamedBackreferenceScopes(baseScope).concat ['variable.other.regexp.php']
  regexpAssertionGroupScope = ['meta.embedded.group.assertion.regexp.php']
  regexpAssertionGroupScopes = (baseScope) ->
    baseScope.concat regexpAssertionGroupScope
  regexpAssertionGroupContentScopes = (baseScope) ->
    regexpAssertionGroupScopes(baseScope).concat [baseScope[baseScope.length - 1]]
  regexpCommentGroupScope = regexpGroupScope.concat ['comment.block.regexp.php']
  regexpCommentGroupScopes = (baseScope) ->
    baseScope.concat regexpCommentGroupScope
  regexpQuotedLiteralBoundaryScope = ['meta.embedded.quoted-literal.regexp.php']
  regexpQuotedLiteralBoundaryScopes = (baseScope) ->
    baseScope.concat regexpQuotedLiteralBoundaryScope
  regexpQuotedLiteralContentScopes = (baseScope) ->
    regexpQuotedLiteralBoundaryScopes(baseScope).concat ['string.regexp.quoted-literal.php']
  regexpRangeQuantifierScopes = (baseScope) ->
    baseScope.concat ['meta.embedded.quantifier.range.regexp.php', 'keyword.operator.quantifier.regexp.php']
  regexpRangeQuantifierBeginScopes = (baseScope) ->
    regexpRangeQuantifierScopes(baseScope).concat ['punctuation.definition.quantifier.begin.regexp.php']
  regexpRangeQuantifierEndScopes = (baseScope) ->
    regexpRangeQuantifierScopes(baseScope).concat ['punctuation.definition.quantifier.end.regexp.php']

  it 'parses the grammar', ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe 'source.php'

  describe 'quoted regex strings', ->
    it 'should tokenize single quoted string regex escape characters correctly', ->
      {tokens} = grammar.tokenizeLine "'/[\\\\\\\\]/';"

      expect(tokens[0]).toEqual value: '\'/', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(tokens[1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(tokens[2]).toEqual value: '\\\\', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(tokens[4]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(tokens[5]).toEqual value: '/\'', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.end.php']
      expect(tokens[6]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

    it 'should tokenize single quoted string regex with escaped bracket', ->
      {tokens} = grammar.tokenizeLine "'/\\[/'"

      expect(tokens[0]).toEqual value: '\'/', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(tokens[1]).toEqual value: '\\[', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php']
      expect(tokens[2]).toEqual value: '/\'', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.end.php']

    for {description, regex} in [
      {description: 'empty character class', regex: '/[]/'}
      {description: 'negated empty character class', regex: '/[^]/'}
      {description: 'unclosed character class', regex: '/[a/'}
      {description: 'unclosed negated character class', regex: '/[^a/'}
      {description: 'slash after opening character class', regex: '/[/'}
    ]
      do (description, regex) ->
        it "should not leak single quoted regex with #{description}", ->
          lines = grammar.tokenizeLines "$r = '#{regex}';\n$x = 1;"
          expectPlainAssignment(lines[1])

        it "should not leak double quoted regex with #{description}", ->
          lines = grammar.tokenizeLines "$r = \"#{regex}\";\n$x = 1;"
          expectPlainAssignment(lines[1])

    it 'should tokenize single quoted regex with slash inside character class', ->
      {tokens} = grammar.tokenizeLine "'/[a/b]/'"

      expect(tokens[0]).toEqual value: '\'/', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(tokens[1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(tokens[2]).toEqual value: 'a', scopes: regexpCharacterClassLiteralScopes(quotedSingleRegexpScope)
      expect(tokens[3]).toEqual value: '/', scopes: regexpCharacterClassLiteralScopes(quotedSingleRegexpScope)
      expect(tokens[4]).toEqual value: 'b', scopes: regexpCharacterClassLiteralScopes(quotedSingleRegexpScope)
      expect(tokens[5]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(tokens[6]).toEqual value: '/\'', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should tokenize double quoted regex with slash inside character class', ->
      {tokens} = grammar.tokenizeLine "\"/[a/b]/\""

      expect(tokens[0]).toEqual value: '"/', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(tokens[1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(tokens[2]).toEqual value: 'a', scopes: regexpCharacterClassLiteralScopes(quotedDoubleRegexpScope)
      expect(tokens[3]).toEqual value: '/', scopes: regexpCharacterClassLiteralScopes(quotedDoubleRegexpScope)
      expect(tokens[4]).toEqual value: 'b', scopes: regexpCharacterClassLiteralScopes(quotedDoubleRegexpScope)
      expect(tokens[5]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(tokens[6]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should tokenize quoted regex range quantifiers without string-only legacy scopes', ->
      singleQuoted = grammar.tokenizeLine "'/a{3,4}+/'"
      doubleQuoted = grammar.tokenizeLine "\"/a{,4}?/\""

      expect(singleQuoted.tokens[0]).toEqual value: '\'/', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(singleQuoted.tokens[1]).toEqual value: 'a', scopes: quotedSingleRegexpScope
      expect(singleQuoted.tokens[2]).toEqual value: '{', scopes: regexpRangeQuantifierBeginScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[3]).toEqual value: '3,4', scopes: regexpRangeQuantifierScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[4]).toEqual value: '}', scopes: regexpRangeQuantifierEndScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[5]).toEqual value: '+', scopes: regexpRangeQuantifierScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[6]).toEqual value: '/\'', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.end.php']

      expect(doubleQuoted.tokens[0]).toEqual value: '"/', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(doubleQuoted.tokens[1]).toEqual value: 'a', scopes: quotedDoubleRegexpScope
      expect(doubleQuoted.tokens[2]).toEqual value: '{', scopes: regexpRangeQuantifierBeginScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: ',4', scopes: regexpRangeQuantifierScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[4]).toEqual value: '}', scopes: regexpRangeQuantifierEndScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[5]).toEqual value: '?', scopes: regexpRangeQuantifierScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[6]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should tokenize interpolation inside double quoted regex bodies', ->
      {tokens} = grammar.tokenizeLine "\"/($value)/\""

      expect(tokens[0]).toEqual value: '"/', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(tokens[1]).toEqual value: '(', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(tokens[2]).toEqual value: '$', scopes: regexpGroupContentScopes(quotedDoubleRegexpScope).concat ['variable.other.php', 'punctuation.definition.variable.php']
      expect(tokens[3]).toEqual value: 'value', scopes: regexpGroupContentScopes(quotedDoubleRegexpScope).concat ['variable.other.php']
      expect(tokens[4]).toEqual value: ')', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(tokens[5]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should tokenize interpolation inside double quoted regex character classes', ->
      {tokens} = grammar.tokenizeLine "\"/[{$value}\\d]/\""

      expect(tokens[0]).toEqual value: '"/', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(tokens[1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(tokens[2]).toEqual value: '{', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.variable.php']
      expect(tokens[3]).toEqual value: '$', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['variable.other.php', 'punctuation.definition.variable.php']
      expect(tokens[4]).toEqual value: 'value', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['variable.other.php']
      expect(tokens[5]).toEqual value: '}', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.variable.php']
      expect(tokens[6]).toEqual value: '\\d', scopes: regexpCharacterClassEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[7]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(tokens[8]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should tokenize rich character class constructs in double quoted regexes', ->
      {tokens} = grammar.tokenizeLine '"/[a-z0-9\\x{4A}-\\x{4f}J[:digit:]\\d\\p{L}\\-\\]]/"'

      expect(tokens[0]).toEqual value: '"/', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(tokens[1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(tokens[2]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(quotedDoubleRegexpScope)
      expect(tokens[3]).toEqual value: '-', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['keyword.operator.range.regexp.php']
      expect(tokens[4]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(quotedDoubleRegexpScope)
      expect(tokens[5]).toEqual value: '0', scopes: regexpCharacterClassDigitRangeScopes(quotedDoubleRegexpScope).concat ['constant.numeric.regexp.php']
      expect(tokens[6]).toEqual value: '-', scopes: regexpCharacterClassDigitRangeScopes(quotedDoubleRegexpScope).concat ['keyword.operator.range.regexp.php']
      expect(tokens[7]).toEqual value: '9', scopes: regexpCharacterClassDigitRangeScopes(quotedDoubleRegexpScope).concat ['constant.numeric.regexp.php']
      expect(tokens[8]).toEqual value: '\\x{4A}', scopes: regexpCharacterClassHexRangeScopes(quotedDoubleRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(tokens[9]).toEqual value: '-', scopes: regexpCharacterClassHexRangeScopes(quotedDoubleRegexpScope).concat ['keyword.operator.range.regexp.php']
      expect(tokens[10]).toEqual value: '\\x{4f}', scopes: regexpCharacterClassHexRangeScopes(quotedDoubleRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(tokens[11]).toEqual value: 'J', scopes: regexpCharacterClassLiteralScopes(quotedDoubleRegexpScope)
      expect(tokens[12]).toEqual value: '[:', scopes: regexpCharacterClassPosixScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.character-class.set.begin.regexp.php']
      expect(tokens[13]).toEqual value: 'digit', scopes: regexpCharacterClassPosixScopes(quotedDoubleRegexpScope)
      expect(tokens[14]).toEqual value: ':]', scopes: regexpCharacterClassPosixScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.character-class.set.end.regexp.php']
      expect(tokens[15]).toEqual value: '\\d', scopes: regexpCharacterClassEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[16]).toEqual value: '\\p{L}', scopes: regexpCharacterClassEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[17]).toEqual value: '\\-', scopes: regexpCharacterClassEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[18]).toEqual value: '\\]', scopes: regexpCharacterClassEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[19]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(tokens[20]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should keep PHP string escapes inside double quoted regex character classes', ->
      {tokens} = grammar.tokenizeLine '"/[\\x01-\\x09\\n\\r]/"'

      expect(tokens[0]).toEqual value: '"/', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(tokens[1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(tokens[2]).toEqual value: '\\x01', scopes: regexpCharacterClassPhpHexEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[3]).toEqual value: '-', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['keyword.operator.range.regexp.php']
      expect(tokens[4]).toEqual value: '\\x09', scopes: regexpCharacterClassPhpHexEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[5]).toEqual value: '\\n', scopes: regexpCharacterClassEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[6]).toEqual value: '\\r', scopes: regexpCharacterClassEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[7]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(tokens[8]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should keep interpolation-like syntax raw in single quoted regex bodies', ->
      {tokens} = grammar.tokenizeLine "'/($value)/'"

      expect(tokens[0]).toEqual value: '\'/', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(tokens[1]).toEqual value: '(', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(tokens[2]).toEqual value: '$', scopes: regexpGroupContentScopes(quotedSingleRegexpScope).concat ['keyword.control.anchor.regexp.php']
      expect(tokens[3]).toEqual value: 'value', scopes: regexpGroupContentScopes(quotedSingleRegexpScope)
      expect(tokens[4]).toEqual value: ')', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(tokens[5]).toEqual value: '/\'', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.end.php']
      expect(tokens.some((token) -> 'variable.other.php' in token.scopes)).toBe false

    it 'should keep interpolation-like syntax raw in single quoted regex character classes', ->
      {tokens} = grammar.tokenizeLine "'/[{$value}\\d]/'"

      expect(tokens[0]).toEqual value: '\'/', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(tokens[1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(tokens[2]).toEqual value: '{', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope)
      expect(tokens[3]).toEqual value: '$', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope)
      expect(tokens[4]).toEqual value: 'v', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope)
      expect(tokens[5]).toEqual value: 'a', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope)
      expect(tokens[6]).toEqual value: 'l', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope)
      expect(tokens[7]).toEqual value: 'u', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope)
      expect(tokens[8]).toEqual value: 'e', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope)
      expect(tokens[9]).toEqual value: '}', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope)
      expect(tokens[10]).toEqual value: '\\d', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(tokens[11]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(tokens[12]).toEqual value: '/\'', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.end.php']
      expect(tokens.some((token) -> 'variable.other.php' in token.scopes)).toBe false

    it 'should tokenize rich character class constructs in single quoted regexes', ->
      {tokens} = grammar.tokenizeLine "'/[a-z0-9\\x{4A}-\\x{4f}J[:digit:]\\d\\p{L}\\-\\]]/'"

      expect(tokens[0]).toEqual value: '\'/', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(tokens[1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(tokens[2]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(quotedSingleRegexpScope)
      expect(tokens[3]).toEqual value: '-', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['keyword.operator.range.regexp.php']
      expect(tokens[4]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(quotedSingleRegexpScope)
      expect(tokens[5]).toEqual value: '0', scopes: regexpCharacterClassDigitRangeScopes(quotedSingleRegexpScope).concat ['constant.numeric.regexp.php']
      expect(tokens[6]).toEqual value: '-', scopes: regexpCharacterClassDigitRangeScopes(quotedSingleRegexpScope).concat ['keyword.operator.range.regexp.php']
      expect(tokens[7]).toEqual value: '9', scopes: regexpCharacterClassDigitRangeScopes(quotedSingleRegexpScope).concat ['constant.numeric.regexp.php']
      expect(tokens[8]).toEqual value: '\\x{4A}', scopes: regexpCharacterClassHexRangeScopes(quotedSingleRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(tokens[9]).toEqual value: '-', scopes: regexpCharacterClassHexRangeScopes(quotedSingleRegexpScope).concat ['keyword.operator.range.regexp.php']
      expect(tokens[10]).toEqual value: '\\x{4f}', scopes: regexpCharacterClassHexRangeScopes(quotedSingleRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(tokens[11]).toEqual value: 'J', scopes: regexpCharacterClassLiteralScopes(quotedSingleRegexpScope)
      expect(tokens[12]).toEqual value: '[:', scopes: regexpCharacterClassPosixScopes(quotedSingleRegexpScope).concat ['punctuation.definition.character-class.set.begin.regexp.php']
      expect(tokens[13]).toEqual value: 'digit', scopes: regexpCharacterClassPosixScopes(quotedSingleRegexpScope)
      expect(tokens[14]).toEqual value: ':]', scopes: regexpCharacterClassPosixScopes(quotedSingleRegexpScope).concat ['punctuation.definition.character-class.set.end.regexp.php']
      expect(tokens[15]).toEqual value: '\\d', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(tokens[16]).toEqual value: '\\p{L}', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(tokens[17]).toEqual value: '\\-', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(tokens[18]).toEqual value: '\\]', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(tokens[19]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(tokens[20]).toEqual value: '/\'', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should tokenize richer body escapes and operators in double quoted regexes', ->
      {tokens} = grammar.tokenizeLine '"/^\\d|\\p{L}.+\\x{4A}$/"'

      expect(tokens[0]).toEqual value: '"/', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(tokens[1]).toEqual value: '^', scopes: quotedDoubleRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(tokens[2]).toEqual value: '\\d', scopes: quotedDoubleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(tokens[3]).toEqual value: '|', scopes: quotedDoubleRegexpScope.concat ['keyword.operator.or.regexp.php']
      expect(tokens[4]).toEqual value: '\\p{L}', scopes: quotedDoubleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(tokens[5]).toEqual value: '.', scopes: quotedDoubleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(tokens[6]).toEqual value: '+', scopes: quotedDoubleRegexpScope.concat ['keyword.operator.quantifier.regexp.php']
      expect(tokens[7]).toEqual value: '\\x{4A}', scopes: quotedDoubleRegexpScope.concat ['constant.character.numeric.regexp.php']
      expect(tokens[8]).toEqual value: '$', scopes: quotedDoubleRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(tokens[9]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should keep PHP string escapes while adding regex body escapes in double quoted regexes', ->
      {tokens} = grammar.tokenizeLine '"/\\n\\d/"'

      expect(tokens[0]).toEqual value: '"/', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(tokens[1]).toEqual value: '\\n', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php']
      expect(tokens[2]).toEqual value: '\\d', scopes: quotedDoubleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(tokens[3]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should tokenize richer body escapes and operators in single quoted regexes', ->
      {tokens} = grammar.tokenizeLine "'/^\\d|\\p{L}.+\\x41\\x{4A}$/'"

      expect(tokens[0]).toEqual value: '\'/', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(tokens[1]).toEqual value: '^', scopes: quotedSingleRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(tokens[2]).toEqual value: '\\d', scopes: quotedSingleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(tokens[3]).toEqual value: '|', scopes: quotedSingleRegexpScope.concat ['keyword.operator.or.regexp.php']
      expect(tokens[4]).toEqual value: '\\p{L}', scopes: quotedSingleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(tokens[5]).toEqual value: '.', scopes: quotedSingleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(tokens[6]).toEqual value: '+', scopes: quotedSingleRegexpScope.concat ['keyword.operator.quantifier.regexp.php']
      expect(tokens[7]).toEqual value: '\\x41', scopes: quotedSingleRegexpScope.concat ['constant.character.numeric.regexp.php']
      expect(tokens[8]).toEqual value: '\\x{4A}', scopes: quotedSingleRegexpScope.concat ['constant.character.numeric.regexp.php']
      expect(tokens[9]).toEqual value: '$', scopes: quotedSingleRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(tokens[10]).toEqual value: '/\'', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should tokenize quoted regex groups and assertions', ->
      doubleQuoted = grammar.tokenizeLine '"/(ab)(?<=cd)(?:ef)(?im:gh)/"'
      singleQuoted = grammar.tokenizeLine "'/(ab)(?<=cd)(?:ef)(?im:gh)/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"/', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(doubleQuoted.tokens[1]).toEqual value: '(', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(doubleQuoted.tokens[2]).toEqual value: 'ab', scopes: regexpGroupContentScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: ')', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(doubleQuoted.tokens[4]).toEqual value: '(', scopes: regexpAssertionGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(doubleQuoted.tokens[5]).toEqual value: '?<=', scopes: regexpSpecificGroupPunctuationScopes(regexpAssertionGroupScopes(quotedDoubleRegexpScope), 'punctuation.definition.group.assertion.regexp.php')
      expect(doubleQuoted.tokens[6]).toEqual value: 'cd', scopes: regexpAssertionGroupContentScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[7]).toEqual value: ')', scopes: regexpAssertionGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(doubleQuoted.tokens[8]).toEqual value: '(', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(doubleQuoted.tokens[9]).toEqual value: '?:', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(quotedDoubleRegexpScope), 'punctuation.definition.group.no-capture.regexp.php')
      expect(doubleQuoted.tokens[10]).toEqual value: 'ef', scopes: regexpGroupContentScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[11]).toEqual value: ')', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(doubleQuoted.tokens[12]).toEqual value: '(', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(doubleQuoted.tokens[13]).toEqual value: '?', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(quotedDoubleRegexpScope), 'punctuation.definition.group.option.regexp.php')
      expect(doubleQuoted.tokens[14]).toEqual value: 'im', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['storage.modifier.regexp.php']
      expect(doubleQuoted.tokens[15]).toEqual value: ':', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(quotedDoubleRegexpScope), 'punctuation.definition.group.option.regexp.php')
      expect(doubleQuoted.tokens[16]).toEqual value: 'gh', scopes: regexpGroupContentScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[17]).toEqual value: ')', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(doubleQuoted.tokens[18]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

      expect(singleQuoted.tokens[0]).toEqual value: '\'/', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(singleQuoted.tokens[1]).toEqual value: '(', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(singleQuoted.tokens[2]).toEqual value: 'ab', scopes: regexpGroupContentScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[3]).toEqual value: ')', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(singleQuoted.tokens[4]).toEqual value: '(', scopes: regexpAssertionGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(singleQuoted.tokens[5]).toEqual value: '?<=', scopes: regexpSpecificGroupPunctuationScopes(regexpAssertionGroupScopes(quotedSingleRegexpScope), 'punctuation.definition.group.assertion.regexp.php')
      expect(singleQuoted.tokens[6]).toEqual value: 'cd', scopes: regexpAssertionGroupContentScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[7]).toEqual value: ')', scopes: regexpAssertionGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(singleQuoted.tokens[8]).toEqual value: '(', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(singleQuoted.tokens[9]).toEqual value: '?:', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(quotedSingleRegexpScope), 'punctuation.definition.group.no-capture.regexp.php')
      expect(singleQuoted.tokens[10]).toEqual value: 'ef', scopes: regexpGroupContentScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[11]).toEqual value: ')', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(singleQuoted.tokens[12]).toEqual value: '(', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(singleQuoted.tokens[13]).toEqual value: '?', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(quotedSingleRegexpScope), 'punctuation.definition.group.option.regexp.php')
      expect(singleQuoted.tokens[14]).toEqual value: 'im', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['storage.modifier.regexp.php']
      expect(singleQuoted.tokens[15]).toEqual value: ':', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(quotedSingleRegexpScope), 'punctuation.definition.group.option.regexp.php')
      expect(singleQuoted.tokens[16]).toEqual value: 'gh', scopes: regexpGroupContentScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[17]).toEqual value: ')', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(singleQuoted.tokens[18]).toEqual value: '/\'', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should tokenize quoted regex named groups and backreferences', ->
      doubleQuoted = grammar.tokenizeLine '"/(?<name>ab)\\k<name>(?P=name)/"'
      singleQuoted = grammar.tokenizeLine "'/(?<name>ab)\\1\\k<name>(?P=name)/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"/', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(doubleQuoted.tokens[1]).toEqual value: '(', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(doubleQuoted.tokens[2]).toEqual value: '?<', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(quotedDoubleRegexpScope), 'punctuation.definition.group.capture.begin.regexp.php')
      expect(doubleQuoted.tokens[3]).toEqual value: 'name', scopes: regexpGroupNameScopes(regexpGroupScopes(quotedDoubleRegexpScope))
      expect(doubleQuoted.tokens[4]).toEqual value: '>', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(quotedDoubleRegexpScope), 'punctuation.definition.group.capture.end.regexp.php')
      expect(doubleQuoted.tokens[5]).toEqual value: 'ab', scopes: regexpGroupContentScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[6]).toEqual value: ')', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(doubleQuoted.tokens[7]).toEqual value: '\\k', scopes: regexpNamedBackreferenceScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[8]).toEqual value: '<', scopes: regexpNamedBackreferenceScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
      expect(doubleQuoted.tokens[9]).toEqual value: 'name', scopes: regexpNamedBackreferenceNameScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[10]).toEqual value: '>', scopes: regexpNamedBackreferenceScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']
      expect(doubleQuoted.tokens[11]).toEqual value: '(', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(doubleQuoted.tokens[12]).toEqual value: '?P=', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['keyword.other.back-reference.named.regexp.php']
      expect(doubleQuoted.tokens[13]).toEqual value: 'name', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['variable.other.regexp.php']
      expect(doubleQuoted.tokens[14]).toEqual value: ')', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(doubleQuoted.tokens[15]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

      expect(singleQuoted.tokens[0]).toEqual value: '\'/', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(singleQuoted.tokens[1]).toEqual value: '(', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(singleQuoted.tokens[2]).toEqual value: '?<', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(quotedSingleRegexpScope), 'punctuation.definition.group.capture.begin.regexp.php')
      expect(singleQuoted.tokens[3]).toEqual value: 'name', scopes: regexpGroupNameScopes(regexpGroupScopes(quotedSingleRegexpScope))
      expect(singleQuoted.tokens[4]).toEqual value: '>', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(quotedSingleRegexpScope), 'punctuation.definition.group.capture.end.regexp.php')
      expect(singleQuoted.tokens[5]).toEqual value: 'ab', scopes: regexpGroupContentScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[6]).toEqual value: ')', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(singleQuoted.tokens[7]).toEqual value: '\\', scopes: quotedSingleRegexpScope.concat ['keyword.other.back-reference.regexp.php']
      expect(singleQuoted.tokens[8]).toEqual value: '1', scopes: quotedSingleRegexpScope.concat ['keyword.other.back-reference.regexp.php', 'constant.numeric.regexp.php']
      expect(singleQuoted.tokens[9]).toEqual value: '\\k', scopes: regexpNamedBackreferenceScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[10]).toEqual value: '<', scopes: regexpNamedBackreferenceScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
      expect(singleQuoted.tokens[11]).toEqual value: 'name', scopes: regexpNamedBackreferenceNameScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[12]).toEqual value: '>', scopes: regexpNamedBackreferenceScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']
      expect(singleQuoted.tokens[13]).toEqual value: '(', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(singleQuoted.tokens[14]).toEqual value: '?P=', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['keyword.other.back-reference.named.regexp.php']
      expect(singleQuoted.tokens[15]).toEqual value: 'name', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['variable.other.regexp.php']
      expect(singleQuoted.tokens[16]).toEqual value: ')', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(singleQuoted.tokens[17]).toEqual value: '/\'', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should keep double quoted numeric backreferences as PHP octal escapes', ->
      {tokens} = grammar.tokenizeLine '"/\\1/"'

      expect(tokens[0]).toEqual value: '"/', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(tokens[1]).toEqual value: '\\1', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.octal.php']
      expect(tokens[2]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should tokenize comment groups in quoted regex strings', ->
      doubleQuoted = grammar.tokenizeLine '"/(?#comment)/"'
      singleQuoted = grammar.tokenizeLine "'/(?#comment)/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"/', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(doubleQuoted.tokens[1]).toEqual value: '(', scopes: regexpCommentGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.comment.begin.regexp.php']
      expect(doubleQuoted.tokens[2]).toEqual value: '?#', scopes: regexpCommentGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.comment.begin.regexp.php']
      expect(doubleQuoted.tokens[3]).toEqual value: 'comment', scopes: regexpCommentGroupScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[4]).toEqual value: ')', scopes: regexpCommentGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.comment.end.regexp.php']
      expect(doubleQuoted.tokens[5]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

      expect(singleQuoted.tokens[0]).toEqual value: '\'/', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(singleQuoted.tokens[1]).toEqual value: '(', scopes: regexpCommentGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.comment.begin.regexp.php']
      expect(singleQuoted.tokens[2]).toEqual value: '?#', scopes: regexpCommentGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.comment.begin.regexp.php']
      expect(singleQuoted.tokens[3]).toEqual value: 'comment', scopes: regexpCommentGroupScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[4]).toEqual value: ')', scopes: regexpCommentGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.comment.end.regexp.php']
      expect(singleQuoted.tokens[5]).toEqual value: '/\'', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should tokenize quoted literals in quoted regex strings', ->
      doubleQuoted = grammar.tokenizeLine '"/\\Qfoo/bar\\E/"'
      singleQuoted = grammar.tokenizeLine "'/\\Qfoo/bar\\E/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"/', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(doubleQuoted.tokens[1]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regex.php']
      expect(doubleQuoted.tokens[2]).toEqual value: 'foo/bar', scopes: regexpQuotedLiteralContentScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: '\\E', scopes: regexpQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regex.php']
      expect(doubleQuoted.tokens[4]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

      expect(singleQuoted.tokens[0]).toEqual value: '\'/', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(singleQuoted.tokens[1]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regex.php']
      expect(singleQuoted.tokens[2]).toEqual value: 'foo/bar', scopes: regexpQuotedLiteralContentScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[3]).toEqual value: '\\E', scopes: regexpQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regex.php']
      expect(singleQuoted.tokens[4]).toEqual value: '/\'', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should stop unclosed quoted literals at the quoted regex terminator', ->
      doubleQuoted = grammar.tokenizeLine '"/\\Qfoo/bar/"'
      singleQuoted = grammar.tokenizeLine "'/\\Qfoo/bar/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"/', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(doubleQuoted.tokens[1]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regex.php']
      expect(doubleQuoted.tokens[2]).toEqual value: 'foo/bar', scopes: regexpQuotedLiteralContentScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

      expect(singleQuoted.tokens[0]).toEqual value: '\'/', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(singleQuoted.tokens[1]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regex.php']
      expect(singleQuoted.tokens[2]).toEqual value: 'foo/bar', scopes: regexpQuotedLiteralContentScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[3]).toEqual value: '/\'', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should tokenize interpolation inside double quoted regex quoted literals', ->
      {tokens} = grammar.tokenizeLine '"/\\Q$foo\\E/"'

      expect(tokens[0]).toEqual value: '"/', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(tokens[1]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regex.php']
      expect(tokens[2]).toEqual value: '$', scopes: regexpQuotedLiteralContentScopes(quotedDoubleRegexpScope).concat ['variable.other.php', 'punctuation.definition.variable.php']
      expect(tokens[3]).toEqual value: 'foo', scopes: regexpQuotedLiteralContentScopes(quotedDoubleRegexpScope).concat ['variable.other.php']
      expect(tokens[4]).toEqual value: '\\E', scopes: regexpQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regex.php']
      expect(tokens[5]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should not treat escaped parentheses as groups in double quoted regexes', ->
      {tokens} = grammar.tokenizeLine '"/\\(ab\\)/"'

      expect(tokens[0]).toEqual value: '"/', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(tokens[1]).toEqual value: '\\(', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regex.php']
      expect(tokens[2]).toEqual value: 'ab', scopes: quotedDoubleRegexpScope
      expect(tokens[3]).toEqual value: '\\)', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regex.php']
      expect(tokens[4]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should keep multiline slash-prefixed double quoted strings out of regex mode', ->
      lines = grammar.tokenizeLines "$r = \"/foo\nbar/\";"

      expect(lines[0].some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false
      expect(lines[1].some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false

    it 'should keep multiline slash-prefixed single quoted strings out of regex mode', ->
      lines = grammar.tokenizeLines "$r = '/foo\nbar/';"

      expect(lines[0].some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false
      expect(lines[1].some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false

  describe 'explicit REGEX and REGEXP blocks', ->
    it 'should tokenize a heredoc with embedded regex escaped bracket correctly', ->
      lines = grammar.tokenizeLines '''
        $a = <<<REGEX
        /\\[/
        REGEX;
      '''

      expect(lines[0][5]).toEqual value: '<<<', scopes: heredocRegexpBoundaryScope.concat ['punctuation.section.embedded.begin.php', 'punctuation.definition.string.php']
      expect(lines[0][6]).toEqual value: 'REGEX', scopes: heredocRegexpBoundaryScope.concat ['punctuation.section.embedded.begin.php', 'keyword.operator.heredoc.php']
      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[1][1]).toEqual value: '\\[', scopes: heredocRegexpScope.concat ['constant.character.escape.regex.php']
      expect(lines[1][2]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[2][0]).toEqual value: 'REGEX', scopes: heredocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.heredoc.php']
      expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

    it 'should tokenize a nowdoc with embedded regex escape characters correctly', ->
      lines = grammar.tokenizeLines '''
        $a = <<<'REGEX'
        /[\\\\\\\\]/
        REGEX;
      '''

      expect(lines[0][5]).toEqual value: '<<<', scopes: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.begin.php', 'punctuation.definition.string.php']
      expect(lines[0][6]).toEqual value: '\'', scopes: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.begin.php']
      expect(lines[0][7]).toEqual value: 'REGEX', scopes: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.begin.php', 'keyword.operator.nowdoc.php']
      expect(lines[0][8]).toEqual value: '\'', scopes: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.begin.php']
      expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(lines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(nowdocRegexpScope).concat ['constant.character.escape.php']
      expect(lines[1][3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(nowdocRegexpScope).concat ['constant.character.escape.php']
      expect(lines[1][4]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(lines[1][5]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(lines[2][0]).toEqual value: 'REGEX', scopes: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.nowdoc.php']
      expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

    it 'should tokenize a nowdoc with embedded regex escaped bracket correctly', ->
      lines = grammar.tokenizeLines '''
        $a = <<<'REGEX'
        /\\[/
        REGEX;
      '''

      expect(lines[0][5]).toEqual value: '<<<', scopes: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.begin.php', 'punctuation.definition.string.php']
      expect(lines[0][6]).toEqual value: '\'', scopes: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.begin.php']
      expect(lines[0][7]).toEqual value: 'REGEX', scopes: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.begin.php', 'keyword.operator.nowdoc.php']
      expect(lines[0][8]).toEqual value: '\'', scopes: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.begin.php']
      expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(lines[1][1]).toEqual value: '\\[', scopes: nowdocRegexpScope.concat ['constant.character.escape.regex.php']
      expect(lines[1][2]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(lines[2][0]).toEqual value: 'REGEX', scopes: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.nowdoc.php']
      expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

    it 'should tokenize a heredoc with embedded regex escape characters correctly', ->
      lines = grammar.tokenizeLines '''
        $a = <<<REGEXP
        /[\\\\\\\\]/
        REGEXP;
      '''

      expect(lines[0][5]).toEqual value: '<<<', scopes: heredocRegexpBoundaryScope.concat ['punctuation.section.embedded.begin.php', 'punctuation.definition.string.php']
      expect(lines[0][6]).toEqual value: 'REGEXP', scopes: heredocRegexpBoundaryScope.concat ['punctuation.section.embedded.begin.php', 'keyword.operator.heredoc.php']
      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php']
      expect(lines[1][3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php']
      expect(lines[1][4]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][5]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[2][0]).toEqual value: 'REGEXP', scopes: heredocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.heredoc.php']
      expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

    it 'should tokenize a heredoc with embedded regex escaped bracket correctly', ->
      lines = grammar.tokenizeLines '''
        $a = <<<REGEXP
        /\\[/
        REGEXP;
      '''

      expect(lines[0][5]).toEqual value: '<<<', scopes: heredocRegexpBoundaryScope.concat ['punctuation.section.embedded.begin.php', 'punctuation.definition.string.php']
      expect(lines[0][6]).toEqual value: 'REGEXP', scopes: heredocRegexpBoundaryScope.concat ['punctuation.section.embedded.begin.php', 'keyword.operator.heredoc.php']
      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[1][1]).toEqual value: '\\[', scopes: heredocRegexpScope.concat ['constant.character.escape.regex.php']
      expect(lines[1][2]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[2][0]).toEqual value: 'REGEXP', scopes: heredocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.heredoc.php']
      expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

    it 'should tokenize a nowdoc with embedded regex escape characters correctly', ->
      lines = grammar.tokenizeLines '''
        $a = <<<'REGEXP'
        /[\\\\\\\\]/
        REGEXP;
      '''

      expect(lines[0][5]).toEqual value: '<<<', scopes: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.begin.php', 'punctuation.definition.string.php']
      expect(lines[0][6]).toEqual value: '\'', scopes: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.begin.php']
      expect(lines[0][7]).toEqual value: 'REGEXP', scopes: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.begin.php', 'keyword.operator.nowdoc.php']
      expect(lines[0][8]).toEqual value: '\'', scopes: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.begin.php']
      expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(lines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(nowdocRegexpScope).concat ['constant.character.escape.php']
      expect(lines[1][3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(nowdocRegexpScope).concat ['constant.character.escape.php']
      expect(lines[1][4]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(lines[1][5]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(lines[2][0]).toEqual value: 'REGEXP', scopes: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.nowdoc.php']
      expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

    it 'should tokenize a nowdoc with embedded regex escaped bracket correctly', ->
      lines = grammar.tokenizeLines '''
        $a = <<<'REGEXP'
        /\\[/
        REGEXP;
      '''

      expect(lines[0][5]).toEqual value: '<<<', scopes: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.begin.php', 'punctuation.definition.string.php']
      expect(lines[0][6]).toEqual value: '\'', scopes: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.begin.php']
      expect(lines[0][7]).toEqual value: 'REGEXP', scopes: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.begin.php', 'keyword.operator.nowdoc.php']
      expect(lines[0][8]).toEqual value: '\'', scopes: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.begin.php']
      expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(lines[1][1]).toEqual value: '\\[', scopes: nowdocRegexpScope.concat ['constant.character.escape.regex.php']
      expect(lines[1][2]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(lines[2][0]).toEqual value: 'REGEXP', scopes: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.nowdoc.php']
      expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

    for {description, regex} in [
      {description: 'empty character class', regex: '/[]/'}
      {description: 'negated empty character class', regex: '/[^]/'}
      {description: 'unclosed character class', regex: '/[a/'}
      {description: 'unclosed negated character class', regex: '/[^a/'}
      {description: 'slash after opening character class', regex: '/[/'}
    ]
      do (description, regex) ->
        it "should not leak REGEXP heredoc with #{description}", ->
          lines = grammar.tokenizeLines """
            $r = <<<REGEXP
            #{regex}
            REGEXP;
            $x = 1;
          """

          expect(lines[2][0]).toEqual value: 'REGEXP', scopes: heredocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.heredoc.php']
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']
          expectPlainAssignment(lines[3])

        it "should not leak REGEXP nowdoc with #{description}", ->
          lines = grammar.tokenizeLines """
            $r = <<<'REGEXP'
            #{regex}
            REGEXP;
            $x = 1;
          """

          expect(lines[2][0]).toEqual value: 'REGEXP', scopes: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.nowdoc.php']
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']
          expectPlainAssignment(lines[3])

    for {description, opener, label, regexScope, terminatorScope} in [
      {
        description: 'REGEX heredoc'
        opener: '<<<REGEX'
        label: 'REGEX'
        regexScope: heredocRegexpScope
        terminatorScope: heredocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.heredoc.php']
      }
      {
        description: 'REGEXP nowdoc'
        opener: '<<<\'REGEXP\''
        label: 'REGEXP'
        regexScope: nowdocRegexpScope
        terminatorScope: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.nowdoc.php']
      }
    ]
      do (description, opener, label, regexScope, terminatorScope) ->
        it "should keep multiline character classes open in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /[ab
            cd]/
            #{label};
            $x = 1;
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][2]).toEqual value: 'a', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[1][3]).toEqual value: 'b', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[2][0]).toEqual value: 'c', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[2][1]).toEqual value: 'd', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[2][2]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[2][3]).toEqual value: '/', scopes: regexScope
          expect(lines[3][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[3][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']
          expectPlainAssignment(lines[4])

        it "should stop multiline unclosed character classes at the terminator in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /[ab
            #{label};
            $x = 1;
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][2]).toEqual value: 'a', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[1][3]).toEqual value: 'b', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']
          expectPlainAssignment(lines[3])

        it "should tokenize richer character class internals in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /[^a-z[:digit:]\\d\\]]/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][2]).toEqual value: '^', scopes: regexpCharacterClassBoundaryNegationScopes(regexScope)
          expect(lines[1][3]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(regexScope)
          expect(lines[1][4]).toEqual value: '-', scopes: regexpCharacterClassScopes(regexScope).concat ['keyword.operator.range.regexp.php']
          expect(lines[1][5]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(regexScope)
          expect(lines[1][6]).toEqual value: '[:', scopes: regexpCharacterClassPosixScopes(regexScope).concat ['punctuation.definition.character-class.set.begin.regexp.php']
          expect(lines[1][7]).toEqual value: 'digit', scopes: regexpCharacterClassPosixScopes(regexScope)
          expect(lines[1][8]).toEqual value: ':]', scopes: regexpCharacterClassPosixScopes(regexScope).concat ['punctuation.definition.character-class.set.end.regexp.php']
          expect(lines[1][9]).toEqual value: '\\d', scopes: regexpCharacterClassScopes(regexScope).concat ['constant.character.escape.php']
          expect(lines[1][10]).toEqual value: '\\]', scopes: regexpCharacterClassScopes(regexScope).concat ['constant.character.escape.php']
          expect(lines[1][11]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][12]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize literal and numeric character class contents in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /[a-zQx-z0-9#]/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][2]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(regexScope)
          expect(lines[1][3]).toEqual value: '-', scopes: regexpCharacterClassScopes(regexScope).concat ['keyword.operator.range.regexp.php']
          expect(lines[1][4]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(regexScope)
          expect(lines[1][5]).toEqual value: 'Q', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[1][6]).toEqual value: 'x', scopes: regexpCharacterClassLetterRangeScopes(regexScope)
          expect(lines[1][7]).toEqual value: '-', scopes: regexpCharacterClassScopes(regexScope).concat ['keyword.operator.range.regexp.php']
          expect(lines[1][8]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(regexScope)
          expect(lines[1][9]).toEqual value: '0', scopes: regexpCharacterClassDigitRangeScopes(regexScope).concat ['constant.numeric.regexp.php']
          expect(lines[1][10]).toEqual value: '-', scopes: regexpCharacterClassDigitRangeScopes(regexScope).concat ['keyword.operator.range.regexp.php']
          expect(lines[1][11]).toEqual value: '9', scopes: regexpCharacterClassDigitRangeScopes(regexScope).concat ['constant.numeric.regexp.php']
          expect(lines[1][12]).toEqual value: '#', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[1][13]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][14]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize non-ASCII literal ranges in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /[а-я😀-🤓Q]/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][2]).toEqual value: 'а', scopes: regexpCharacterClassGenericRangeScopes(regexScope)
          expect(lines[1][3]).toEqual value: '-', scopes: regexpCharacterClassGenericRangeScopes(regexScope).concat ['keyword.operator.range.regexp.php']
          expect(lines[1][4]).toEqual value: 'я', scopes: regexpCharacterClassGenericRangeScopes(regexScope)
          expect(lines[1][5]).toEqual value: '😀', scopes: regexpCharacterClassGenericRangeScopes(regexScope)
          expect(lines[1][6]).toEqual value: '-', scopes: regexpCharacterClassGenericRangeScopes(regexScope).concat ['keyword.operator.range.regexp.php']
          expect(lines[1][7]).toEqual value: '🤓', scopes: regexpCharacterClassGenericRangeScopes(regexScope)
          expect(lines[1][8]).toEqual value: 'Q', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[1][9]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][10]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should treat trailing hyphens as plain class content in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /[q-]/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][2]).toEqual value: 'q', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[1][3]).toEqual value: '-', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[1][4]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][5]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should treat opening brackets as literals inside character classes in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            re[g[G]][e\\\\]
            #{label};
          """

          expect(lines[1][0]).toEqual value: 're', scopes: regexScope
          expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][2]).toEqual value: 'g', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[1][3]).toEqual value: '[', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[1][4]).toEqual value: 'G', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[1][5]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][6]).toEqual value: ']', scopes: regexScope
          expect(lines[1][7]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][8]).toEqual value: 'e', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[1][9]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(regexScope).concat ['constant.character.escape.php']
          expect(lines[1][10]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should close character classes at the first unescaped bracket in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            r\\e[g[G]]e(x)
            #{label};
          """

          expect(lines[1][0]).toEqual value: 'r', scopes: regexScope
          expect(lines[1][1]).toEqual value: '\\e', scopes: regexScope.concat ['constant.character.escape.regex.php']
          expect(lines[1][2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][3]).toEqual value: 'g', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[1][4]).toEqual value: '[', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[1][5]).toEqual value: 'G', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[1][6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][7]).toEqual value: ']e', scopes: regexScope
          expect(lines[1][8]).toEqual value: '(', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][9]).toEqual value: 'x', scopes: regexpGroupContentScopes(regexScope)
          expect(lines[1][10]).toEqual value: ')', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize negated POSIX classes and property escapes in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /[[:^digit:]\\p{L}\\-]/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][2]).toEqual value: '[:', scopes: regexpCharacterClassPosixScopes(regexScope).concat ['punctuation.definition.character-class.set.begin.regexp.php']
          expect(lines[1][3]).toEqual value: '^', scopes: regexpCharacterClassPosixScopes(regexScope).concat ['keyword.operator.negation.regexp.php']
          expect(lines[1][4]).toEqual value: 'digit', scopes: regexpCharacterClassPosixScopes(regexScope)
          expect(lines[1][5]).toEqual value: ':]', scopes: regexpCharacterClassPosixScopes(regexScope).concat ['punctuation.definition.character-class.set.end.regexp.php']
          expect(lines[1][6]).toEqual value: '\\p{L}', scopes: regexpCharacterClassScopes(regexScope).concat ['constant.character.escape.php']
          expect(lines[1][7]).toEqual value: '\\-', scopes: regexpCharacterClassScopes(regexScope).concat ['constant.character.escape.php']
          expect(lines[1][8]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][9]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize plain groups in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /(ab)/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '(', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][2]).toEqual value: 'ab', scopes: regexpGroupContentScopes(regexScope)
          expect(lines[1][3]).toEqual value: ')', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][4]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should keep multiline groups open in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /(ab
            cd)/
            #{label};
            $x = 1;
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '(', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][2]).toEqual value: 'ab', scopes: regexpGroupContentScopes(regexScope)
          expect(lines[2][0]).toEqual value: 'cd', scopes: regexpGroupContentScopes(regexScope)
          expect(lines[2][1]).toEqual value: ')', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[2][2]).toEqual value: '/', scopes: regexScope
          expect(lines[3][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[3][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']
          expectPlainAssignment(lines[4])

        it "should stop multiline unclosed groups at the terminator in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /(ab
            #{label};
            $x = 1;
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '(', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][2]).toEqual value: 'ab', scopes: regexpGroupContentScopes(regexScope)
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']
          expectPlainAssignment(lines[3])

        it "should not treat escaped parentheses as groups in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /\\(ab\\)/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '\\(', scopes: regexScope.concat ['constant.character.escape.regex.php']
          expect(lines[1][2]).toEqual value: 'ab', scopes: regexScope
          expect(lines[1][3]).toEqual value: '\\)', scopes: regexScope.concat ['constant.character.escape.regex.php']
          expect(lines[1][4]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize assertion groups in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /(?<=ab)/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '(', scopes: regexpAssertionGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][2]).toEqual value: '?<=', scopes: regexpSpecificGroupPunctuationScopes(regexpAssertionGroupScopes(regexScope), 'punctuation.definition.group.assertion.regexp.php')
          expect(lines[1][3]).toEqual value: 'ab', scopes: regexpAssertionGroupContentScopes(regexScope)
          expect(lines[1][4]).toEqual value: ')', scopes: regexpAssertionGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][5]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize non-capturing groups in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /(?:ab)/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '(', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][2]).toEqual value: '?:', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(regexScope), 'punctuation.definition.group.no-capture.regexp.php')
          expect(lines[1][3]).toEqual value: 'ab', scopes: regexpGroupContentScopes(regexScope)
          expect(lines[1][4]).toEqual value: ')', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][5]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize option groups in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /(?im:ab)/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '(', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][2]).toEqual value: '?', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(regexScope), 'punctuation.definition.group.option.regexp.php')
          expect(lines[1][3]).toEqual value: 'im', scopes: regexpGroupScopes(regexScope).concat ['storage.modifier.regexp.php']
          expect(lines[1][4]).toEqual value: ':', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(regexScope), 'punctuation.definition.group.option.regexp.php')
          expect(lines[1][5]).toEqual value: 'ab', scopes: regexpGroupContentScopes(regexScope)
          expect(lines[1][6]).toEqual value: ')', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][7]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize angle-bracket named groups in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /(?<word>ab)/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '(', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][2]).toEqual value: '?<', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(regexScope), 'punctuation.definition.group.capture.begin.regexp.php')
          expect(lines[1][3]).toEqual value: 'word', scopes: regexpGroupNameScopes(regexpGroupScopes(regexScope))
          expect(lines[1][4]).toEqual value: '>', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(regexScope), 'punctuation.definition.group.capture.end.regexp.php')
          expect(lines[1][5]).toEqual value: 'ab', scopes: regexpGroupContentScopes(regexScope)
          expect(lines[1][6]).toEqual value: ')', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][7]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize atomic groups in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /(?>ab)/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '(', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][2]).toEqual value: '?>', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(regexScope), 'punctuation.definition.group.atomic.regexp.php')
          expect(lines[1][3]).toEqual value: 'ab', scopes: regexpGroupContentScopes(regexScope)
          expect(lines[1][4]).toEqual value: ')', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][5]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize branch-reset groups in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /(?|ab)/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '(', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][2]).toEqual value: '?|', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(regexScope), 'punctuation.definition.group.branch-reset.regexp.php')
          expect(lines[1][3]).toEqual value: 'ab', scopes: regexpGroupContentScopes(regexScope)
          expect(lines[1][4]).toEqual value: ')', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][5]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize comment groups in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /(?# note)/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '(', scopes: regexpCommentGroupScopes(regexScope).concat ['punctuation.definition.comment.begin.regexp.php']
          expect(lines[1][2]).toEqual value: '?#', scopes: regexpCommentGroupScopes(regexScope).concat ['punctuation.definition.comment.begin.regexp.php']
          expect(lines[1][3]).toEqual value: ' note', scopes: regexpCommentGroupScopes(regexScope)
          expect(lines[1][4]).toEqual value: ')', scopes: regexpCommentGroupScopes(regexScope).concat ['punctuation.definition.comment.end.regexp.php']
          expect(lines[1][5]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should stop unclosed comment groups at the terminator in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /(?# note
            #{label};
            $x = 1;
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '(', scopes: regexpCommentGroupScopes(regexScope).concat ['punctuation.definition.comment.begin.regexp.php']
          expect(lines[1][2]).toEqual value: '?#', scopes: regexpCommentGroupScopes(regexScope).concat ['punctuation.definition.comment.begin.regexp.php']
          expect(lines[1][3]).toEqual value: ' note', scopes: regexpCommentGroupScopes(regexScope)
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']
          expectPlainAssignment(lines[3])

        it "should tokenize option toggles in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /(?im)/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '(', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][2]).toEqual value: '?im', scopes: regexpGroupScopes(regexScope).concat ['keyword.other.option-toggle.regexp.php']
          expect(lines[1][3]).toEqual value: ')', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][4]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize backreferences in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /\\1\\k<word>\\k'word'(?P=word)/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '\\', scopes: regexScope.concat ['keyword.other.back-reference.regexp.php']
          expect(lines[1][2]).toEqual value: '1', scopes: regexScope.concat ['keyword.other.back-reference.regexp.php', 'constant.numeric.regexp.php']
          expect(lines[1][3]).toEqual value: '\\k', scopes: regexScope.concat ['keyword.other.back-reference.named.regexp.php']
          expect(lines[1][4]).toEqual value: '<', scopes: regexpNamedBackreferenceScopes(regexScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
          expect(lines[1][5]).toEqual value: 'word', scopes: regexpNamedBackreferenceNameScopes(regexScope)
          expect(lines[1][6]).toEqual value: '>', scopes: regexpNamedBackreferenceScopes(regexScope).concat ['punctuation.definition.group.capture.end.regexp.php']
          expect(lines[1][7]).toEqual value: '\\k', scopes: regexpNamedBackreferenceScopes(regexScope)
          expect(lines[1][8]).toEqual value: '\'', scopes: regexpNamedBackreferenceScopes(regexScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
          expect(lines[1][9]).toEqual value: 'word', scopes: regexpNamedBackreferenceNameScopes(regexScope)
          expect(lines[1][10]).toEqual value: '\'', scopes: regexpNamedBackreferenceScopes(regexScope).concat ['punctuation.definition.group.capture.end.regexp.php']
          expect(lines[1][11]).toEqual value: '(', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][12]).toEqual value: '?P=', scopes: regexpGroupScopes(regexScope).concat ['keyword.other.back-reference.named.regexp.php']
          expect(lines[1][13]).toEqual value: 'word', scopes: regexpGroupNameScopes(regexpGroupScopes(regexScope))
          expect(lines[1][14]).toEqual value: ')', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][15]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize basic character-type and property escapes in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /\\d\\D\\w\\W\\s\\S\\h\\H\\v\\V\\R\\p{L}\\P{N}/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '\\d', scopes: regexScope.concat ['constant.character.class.regexp.php']
          expect(lines[1][2]).toEqual value: '\\D', scopes: regexScope.concat ['constant.character.class.regexp.php']
          expect(lines[1][3]).toEqual value: '\\w', scopes: regexScope.concat ['constant.character.class.regexp.php']
          expect(lines[1][4]).toEqual value: '\\W', scopes: regexScope.concat ['constant.character.class.regexp.php']
          expect(lines[1][5]).toEqual value: '\\s', scopes: regexScope.concat ['constant.character.class.regexp.php']
          expect(lines[1][6]).toEqual value: '\\S', scopes: regexScope.concat ['constant.character.class.regexp.php']
          expect(lines[1][7]).toEqual value: '\\h', scopes: regexScope.concat ['constant.character.class.regexp.php']
          expect(lines[1][8]).toEqual value: '\\H', scopes: regexScope.concat ['constant.character.class.regexp.php']
          expect(lines[1][9]).toEqual value: '\\v', scopes: regexScope.concat ['constant.character.class.regexp.php']
          expect(lines[1][10]).toEqual value: '\\V', scopes: regexScope.concat ['constant.character.class.regexp.php']
          expect(lines[1][11]).toEqual value: '\\R', scopes: regexScope.concat ['constant.character.class.regexp.php']
          expect(lines[1][12]).toEqual value: '\\p{L}', scopes: regexScope.concat ['constant.character.class.regexp.php']
          expect(lines[1][13]).toEqual value: '\\P{N}', scopes: regexScope.concat ['constant.character.class.regexp.php']
          expect(lines[1][14]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize basic literal escapes in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /\\n\\r\\t\\f\\a\\e\\xFF\\x{1F600}\\0\\077\\cA\\/\\+\\*\\?\\|\\-\\#/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '\\n', scopes: regexScope.concat ['constant.character.escape.regex.php']
          expect(lines[1][2]).toEqual value: '\\r', scopes: regexScope.concat ['constant.character.escape.regex.php']
          expect(lines[1][3]).toEqual value: '\\t', scopes: regexScope.concat ['constant.character.escape.regex.php']
          expect(lines[1][4]).toEqual value: '\\f', scopes: regexScope.concat ['constant.character.escape.regex.php']
          expect(lines[1][5]).toEqual value: '\\a', scopes: regexScope.concat ['constant.character.escape.regex.php']
          expect(lines[1][6]).toEqual value: '\\e', scopes: regexScope.concat ['constant.character.escape.regex.php']
          expect(lines[1][7]).toEqual value: '\\xFF', scopes: regexScope.concat ['constant.character.numeric.regexp.php']
          expect(lines[1][8]).toEqual value: '\\x{1F600}', scopes: regexScope.concat ['constant.character.numeric.regexp.php']
          expect(lines[1][9]).toEqual value: '\\0', scopes: regexScope.concat ['constant.character.escape.regex.php']
          expect(lines[1][10]).toEqual value: '\\077', scopes: regexScope.concat ['constant.character.escape.regex.php']
          expect(lines[1][11]).toEqual value: '\\cA', scopes: regexScope.concat ['constant.character.escape.regex.php']
          expect(lines[1][12]).toEqual value: '\\/', scopes: regexScope.concat ['constant.character.escape.regex.php']
          expect(lines[1][13]).toEqual value: '\\+', scopes: regexScope.concat ['constant.character.escape.regex.php']
          expect(lines[1][14]).toEqual value: '\\*', scopes: regexScope.concat ['constant.character.escape.regex.php']
          expect(lines[1][15]).toEqual value: '\\?', scopes: regexScope.concat ['constant.character.escape.regex.php']
          expect(lines[1][16]).toEqual value: '\\|', scopes: regexScope.concat ['constant.character.escape.regex.php']
          expect(lines[1][17]).toEqual value: '\\-', scopes: regexScope.concat ['constant.character.escape.regex.php']
          expect(lines[1][18]).toEqual value: '\\#', scopes: regexScope.concat ['constant.character.escape.regex.php']
          expect(lines[1][19]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should keep character classes after escaped backslashes in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f]/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '\\\\', scopes: regexScope.concat ['constant.character.escape.regex.php']
          expect(lines[1][2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][3]).toEqual value: '\\x01', scopes: regexpCharacterClassHexRangeScopes(regexScope).concat ['constant.character.numeric.regexp.php']
          expect(lines[1][4]).toEqual value: '-', scopes: regexpCharacterClassHexRangeScopes(regexScope).concat ['keyword.operator.range.regexp.php']
          expect(lines[1][5]).toEqual value: '\\x09', scopes: regexpCharacterClassHexRangeScopes(regexScope).concat ['constant.character.numeric.regexp.php']
          expect(lines[1][6]).toEqual value: '\\x0b', scopes: regexpCharacterClassScopes(regexScope).concat ['constant.character.numeric.regexp.php']
          expect(lines[1][7]).toEqual value: '\\x0c', scopes: regexpCharacterClassScopes(regexScope).concat ['constant.character.numeric.regexp.php']
          expect(lines[1][8]).toEqual value: '\\x0e', scopes: regexpCharacterClassHexRangeScopes(regexScope).concat ['constant.character.numeric.regexp.php']
          expect(lines[1][9]).toEqual value: '-', scopes: regexpCharacterClassHexRangeScopes(regexScope).concat ['keyword.operator.range.regexp.php']
          expect(lines[1][10]).toEqual value: '\\x7f', scopes: regexpCharacterClassHexRangeScopes(regexScope).concat ['constant.character.numeric.regexp.php']
          expect(lines[1][11]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][12]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize braced hex escapes inside character classes in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /[\\x{4A}-\\x{4f}J]/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][2]).toEqual value: '\\x{4A}', scopes: regexpCharacterClassHexRangeScopes(regexScope).concat ['constant.character.numeric.regexp.php']
          expect(lines[1][3]).toEqual value: '-', scopes: regexpCharacterClassHexRangeScopes(regexScope).concat ['keyword.operator.range.regexp.php']
          expect(lines[1][4]).toEqual value: '\\x{4f}', scopes: regexpCharacterClassHexRangeScopes(regexScope).concat ['constant.character.numeric.regexp.php']
          expect(lines[1][5]).toEqual value: 'J', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[1][6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][7]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should keep groups and quantifiers after escaped backslashes in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /\\\\(ab){2,3}/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '\\\\', scopes: regexScope.concat ['constant.character.escape.regex.php']
          expect(lines[1][2]).toEqual value: '(', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][3]).toEqual value: 'ab', scopes: regexpGroupContentScopes(regexScope)
          expect(lines[1][4]).toEqual value: ')', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][5]).toEqual value: '{', scopes: regexpRangeQuantifierBeginScopes(regexScope)
          expect(lines[1][6]).toEqual value: '2,3', scopes: regexpRangeQuantifierScopes(regexScope)
          expect(lines[1][7]).toEqual value: '}', scopes: regexpRangeQuantifierEndScopes(regexScope)
          expect(lines[1][8]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should not treat doubled backslashes as backreferences or shorthand escapes in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /\\\\1\\\\d/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '\\\\', scopes: regexScope.concat ['constant.character.escape.regex.php']
          expect(lines[1][2]).toEqual value: '1', scopes: regexScope
          expect(lines[1][3]).toEqual value: '\\\\', scopes: regexScope.concat ['constant.character.escape.regex.php']
          expect(lines[1][4]).toEqual value: 'd/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize escaped slashes in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            foo/bar\\/baz
            #{label};
          """

          expect(lines[1][0]).toEqual value: 'foo/bar', scopes: regexScope
          expect(lines[1][1]).toEqual value: '\\/', scopes: regexScope.concat ['constant.character.escape.regex.php']
          expect(lines[1][2]).toEqual value: 'baz', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize quoted literals in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /\\Qa.b+#\\E\\d/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(regexScope).concat ['constant.character.escape.regex.php']
          expect(lines[1][2]).toEqual value: 'a.b+#', scopes: regexpQuotedLiteralContentScopes(regexScope)
          expect(lines[1][3]).toEqual value: '\\E', scopes: regexpQuotedLiteralBoundaryScopes(regexScope).concat ['constant.character.escape.regex.php']
          expect(lines[1][4]).toEqual value: '\\d', scopes: regexScope.concat ['constant.character.class.regexp.php']
          expect(lines[1][5]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should stop unclosed quoted literals at the terminator in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /\\Qab
            #{label};
            $x = 1;
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(regexScope).concat ['constant.character.escape.regex.php']
          expect(lines[1][2]).toEqual value: 'ab', scopes: regexpQuotedLiteralContentScopes(regexScope)
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']
          expectPlainAssignment(lines[3])

        it "should tokenize anchors, dots, alternation, and quantifiers in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /^\\A.a+?|b{2,4}+$/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '^', scopes: regexScope.concat ['keyword.control.anchor.regexp.php']
          expect(lines[1][2]).toEqual value: '\\A', scopes: regexScope.concat ['keyword.control.anchor.regexp.php']
          expect(lines[1][3]).toEqual value: '.', scopes: regexScope.concat ['constant.character.class.regexp.php']
          expect(lines[1][4]).toEqual value: 'a', scopes: regexScope
          expect(lines[1][5]).toEqual value: '+?', scopes: regexScope.concat ['keyword.operator.quantifier.regexp.php']
          expect(lines[1][6]).toEqual value: '|', scopes: regexScope.concat ['keyword.operator.or.regexp.php']
          expect(lines[1][7]).toEqual value: 'b', scopes: regexScope
          expect(lines[1][8]).toEqual value: '{', scopes: regexpRangeQuantifierBeginScopes(regexScope)
          expect(lines[1][9]).toEqual value: '2,4', scopes: regexpRangeQuantifierScopes(regexScope)
          expect(lines[1][10]).toEqual value: '}', scopes: regexpRangeQuantifierEndScopes(regexScope)
          expect(lines[1][11]).toEqual value: '+', scopes: regexpRangeQuantifierScopes(regexScope)
          expect(lines[1][12]).toEqual value: '$', scopes: regexScope.concat ['keyword.control.anchor.regexp.php']
          expect(lines[1][13]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

    it 'should tokenize interpolation inside REGEXP heredoc groups', ->
      lines = grammar.tokenizeLines '''
        $r = <<<REGEXP
        /($value)/
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[1][1]).toEqual value: '(', scopes: regexpGroupScopes(heredocRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(lines[1][2]).toEqual value: '$', scopes: regexpGroupContentScopes(heredocRegexpScope).concat ['variable.other.php', 'punctuation.definition.variable.php']
      expect(lines[1][3]).toEqual value: 'value', scopes: regexpGroupContentScopes(heredocRegexpScope).concat ['variable.other.php']
      expect(lines[1][4]).toEqual value: ')', scopes: regexpGroupScopes(heredocRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(lines[1][5]).toEqual value: '/', scopes: heredocRegexpScope

    it 'should tokenize interpolation inside REGEXP heredoc quoted literals', ->
      lines = grammar.tokenizeLines '''
        $r = <<<REGEXP
        /\\Q$value\\E/
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[1][1]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(heredocRegexpScope).concat ['constant.character.escape.regex.php']
      expect(lines[1][2]).toEqual value: '$', scopes: regexpQuotedLiteralContentScopes(heredocRegexpScope).concat ['variable.other.php', 'punctuation.definition.variable.php']
      expect(lines[1][3]).toEqual value: 'value', scopes: regexpQuotedLiteralContentScopes(heredocRegexpScope).concat ['variable.other.php']
      expect(lines[1][4]).toEqual value: '\\E', scopes: regexpQuotedLiteralBoundaryScopes(heredocRegexpScope).concat ['constant.character.escape.regex.php']
      expect(lines[1][5]).toEqual value: '/', scopes: heredocRegexpScope

    it 'should tokenize nested quoted regex escapes and operators inside REGEXP heredoc quoted literals', ->
      nestedQuotedRegex = '"/(\\"\\\'[a-z]|\\d+)/ui"'
      # Build the heredoc with interpolation so the nested quoted regex stays readable without over-escaping.
      lines = grammar.tokenizeLines """
        $r = <<<REGEXP
        \\Q$fragment{$makeFragment(#{nestedQuotedRegex})}\\E
        REGEXP;
      """

      nestedQuotedDoubleRegexpScope = regexpQuotedLiteralContentScopes(heredocRegexpScope).concat ['meta.function-call.invoke.php', 'meta.embedded.regexp.php', 'string.regexp.double-quoted.php']
      nestedQuotedDoubleRegexpGroupContentScopes = regexpGroupContentScopes(nestedQuotedDoubleRegexpScope)

      expect(lines[1][16]).toEqual value: '|', scopes: nestedQuotedDoubleRegexpGroupContentScopes.concat ['keyword.operator.or.regexp.php']
      expect(lines[1][17]).toEqual value: '\\d', scopes: nestedQuotedDoubleRegexpGroupContentScopes.concat ['constant.character.class.regexp.php']
      expect(lines[1][18]).toEqual value: '+', scopes: nestedQuotedDoubleRegexpGroupContentScopes.concat ['keyword.operator.quantifier.regexp.php']

    it 'should tokenize interpolation inside REGEXP heredoc character classes', ->
      lines = grammar.tokenizeLines '''
        $r = <<<REGEXP
        /[{$value}\\d]/
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][2]).toEqual value: '{', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['punctuation.definition.variable.php']
      expect(lines[1][3]).toEqual value: '$', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['variable.other.php', 'punctuation.definition.variable.php']
      expect(lines[1][4]).toEqual value: 'value', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['variable.other.php']
      expect(lines[1][5]).toEqual value: '}', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['punctuation.definition.variable.php']
      expect(lines[1][6]).toEqual value: '\\d', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php']
      expect(lines[1][7]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][8]).toEqual value: '/', scopes: heredocRegexpScope

    it 'should keep character-class interpolation syntax raw inside REGEXP nowdoc', ->
      lines = grammar.tokenizeLines '''
        $r = <<<'REGEXP'
        /[{$value}\\d]/
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(lines[1][2]).toEqual value: '{', scopes: regexpCharacterClassScopes(nowdocRegexpScope)
      expect(lines[1][3]).toEqual value: '$', scopes: regexpCharacterClassScopes(nowdocRegexpScope)
      expect(lines[1][9]).toEqual value: '}', scopes: regexpCharacterClassScopes(nowdocRegexpScope)
      expect(lines[1][10]).toEqual value: '\\d', scopes: regexpCharacterClassScopes(nowdocRegexpScope).concat ['constant.character.escape.php']
      expect(lines[1][11]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(lines[1][12]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(lines[1].some((token) -> 'variable.other.php' in token.scopes)).toBe false

    it 'should tokenize single-quoted named groups in REGEXP heredoc', ->
      lines = grammar.tokenizeLines '''
        $r = <<<REGEXP
        /(?'word'ab)/
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[1][1]).toEqual value: '(', scopes: regexpGroupScopes(heredocRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(lines[1][2]).toEqual value: '?\'', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(heredocRegexpScope), 'punctuation.definition.group.capture.begin.regexp.php')
      expect(lines[1][3]).toEqual value: 'word', scopes: regexpGroupNameScopes(regexpGroupScopes(heredocRegexpScope))
      expect(lines[1][4]).toEqual value: '\'', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(heredocRegexpScope), 'punctuation.definition.group.capture.end.regexp.php')
      expect(lines[1][5]).toEqual value: 'ab', scopes: regexpGroupContentScopes(heredocRegexpScope)
      expect(lines[1][6]).toEqual value: ')', scopes: regexpGroupScopes(heredocRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(lines[1][7]).toEqual value: '/', scopes: heredocRegexpScope

    it 'should tokenize PCRE named groups in REGEXP heredoc', ->
      lines = grammar.tokenizeLines '''
        $r = <<<REGEXP
        /(?P<word>ab)/
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[1][1]).toEqual value: '(', scopes: regexpGroupScopes(heredocRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(lines[1][2]).toEqual value: '?P<', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(heredocRegexpScope), 'punctuation.definition.group.capture.begin.regexp.php')
      expect(lines[1][3]).toEqual value: 'word', scopes: regexpGroupNameScopes(regexpGroupScopes(heredocRegexpScope))
      expect(lines[1][4]).toEqual value: '>', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(heredocRegexpScope), 'punctuation.definition.group.capture.end.regexp.php')
      expect(lines[1][5]).toEqual value: 'ab', scopes: regexpGroupContentScopes(heredocRegexpScope)
      expect(lines[1][6]).toEqual value: ')', scopes: regexpGroupScopes(heredocRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(lines[1][7]).toEqual value: '/', scopes: heredocRegexpScope

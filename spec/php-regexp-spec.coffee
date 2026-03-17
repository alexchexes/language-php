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
    regexpCharacterClassScopes(baseScope).concat ['constant.character.escape.regexp.php']
  regexpCharacterClassClassEscapeScopes = (baseScope) ->
    regexpCharacterClassScopes(baseScope).concat ['constant.character.class.regexp.php']
  regexpCharacterClassPhpEscapeScopes = (baseScope) ->
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
      expect(tokens[1]).toEqual value: '\\[', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
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
      expect(tokens[2]).toEqual value: '{', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['meta.embedded.interpolation.php', 'punctuation.definition.variable.php']
      expect(tokens[3]).toEqual value: '$', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['meta.embedded.interpolation.php', 'variable.other.php', 'punctuation.definition.variable.php']
      expect(tokens[4]).toEqual value: 'value', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['meta.embedded.interpolation.php', 'variable.other.php']
      expect(tokens[5]).toEqual value: '}', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['meta.embedded.interpolation.php', 'punctuation.definition.variable.php']
      expect(tokens[6]).toEqual value: '\\d', scopes: regexpCharacterClassClassEscapeScopes(quotedDoubleRegexpScope)
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
      expect(tokens[15]).toEqual value: '\\d', scopes: regexpCharacterClassClassEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[16]).toEqual value: '\\p{L}', scopes: regexpCharacterClassClassEscapeScopes(quotedDoubleRegexpScope)
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
      expect(tokens[5]).toEqual value: '\\n', scopes: regexpCharacterClassPhpEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[6]).toEqual value: '\\r', scopes: regexpCharacterClassPhpEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[7]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(tokens[8]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should tokenize decoded overlapping escapes in double quoted regex character classes', ->
      {tokens} = grammar.tokenizeLine '"/[\\\\1\\\\x41\\\\n\\\\v\\\\$]/"'

      expect(tokens[0]).toEqual value: '"/', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(tokens[1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(tokens[2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php']
      expect(tokens[3]).toEqual value: '1', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.numeric.regexp.php']
      expect(tokens[4]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php']
      expect(tokens[5]).toEqual value: 'x41', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(tokens[6]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php']
      expect(tokens[7]).toEqual value: 'n', scopes: regexpCharacterClassEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[8]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php']
      expect(tokens[9]).toEqual value: 'v', scopes: regexpCharacterClassClassEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[10]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php']
      expect(tokens[11]).toEqual value: '$', scopes: regexpCharacterClassEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[12]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(tokens[13]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should tokenize decoded bell escapes in interpreted quoted regex character classes', ->
      doubleQuoted = grammar.tokenizeLine '"/[\\\\a]/"'
      singleQuoted = grammar.tokenizeLine "'/[\\\\a]/'"

      expect(doubleQuoted.tokens[1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php']
      expect(doubleQuoted.tokens[3]).toEqual value: 'a', scopes: regexpCharacterClassEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[4]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php']
      expect(singleQuoted.tokens[3]).toEqual value: 'a', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[4]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)

    it 'should tokenize decoded shorthand class escapes in quoted regex character classes', ->
      doubleQuoted = grammar.tokenizeLine '"/[\\\\d]/"'
      singleQuoted = grammar.tokenizeLine "'/[\\\\d]/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"/', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(doubleQuoted.tokens[1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php']
      expect(doubleQuoted.tokens[3]).toEqual value: 'd', scopes: regexpCharacterClassClassEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[4]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[5]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

      expect(singleQuoted.tokens[0]).toEqual value: '\'/', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(singleQuoted.tokens[1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php']
      expect(singleQuoted.tokens[3]).toEqual value: 'd', scopes: regexpCharacterClassClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[4]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[5]).toEqual value: '/\'', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should tokenize decoded property and braced hex escapes in quoted regex character classes', ->
      doubleQuoted = grammar.tokenizeLine '"/[\\\\p{L}\\\\x{41}]/"'
      singleQuoted = grammar.tokenizeLine "'/[\\\\p{L}\\\\x{41}]/'"

      expect(doubleQuoted.tokens[1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php']
      expect(doubleQuoted.tokens[3]).toEqual value: 'p{L}', scopes: regexpCharacterClassClassEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[4]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php']
      expect(doubleQuoted.tokens[5]).toEqual value: 'x{41}', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(doubleQuoted.tokens[6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php']
      expect(singleQuoted.tokens[3]).toEqual value: 'p{L}', scopes: regexpCharacterClassClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[4]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php']
      expect(singleQuoted.tokens[5]).toEqual value: 'x{41}', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(singleQuoted.tokens[6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)

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
      expect(tokens[10]).toEqual value: '\\d', scopes: regexpCharacterClassClassEscapeScopes(quotedSingleRegexpScope)
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
      expect(tokens[15]).toEqual value: '\\d', scopes: regexpCharacterClassClassEscapeScopes(quotedSingleRegexpScope)
      expect(tokens[16]).toEqual value: '\\p{L}', scopes: regexpCharacterClassClassEscapeScopes(quotedSingleRegexpScope)
      expect(tokens[17]).toEqual value: '\\-', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(tokens[18]).toEqual value: '\\]', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(tokens[19]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(tokens[20]).toEqual value: '/\'', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should tokenize decoded overlapping escapes in single quoted regex character classes', ->
      {tokens} = grammar.tokenizeLine "'/[\\\\1\\\\x41\\\\n\\\\v\\\\$]/'"

      expect(tokens[0]).toEqual value: '\'/', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(tokens[1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(tokens[2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php']
      expect(tokens[3]).toEqual value: '1', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.numeric.regexp.php']
      expect(tokens[4]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php']
      expect(tokens[5]).toEqual value: 'x41', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(tokens[6]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php']
      expect(tokens[7]).toEqual value: 'n', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(tokens[8]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php']
      expect(tokens[9]).toEqual value: 'v', scopes: regexpCharacterClassClassEscapeScopes(quotedSingleRegexpScope)
      expect(tokens[10]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php']
      expect(tokens[11]).toEqual value: '$', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(tokens[12]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(tokens[13]).toEqual value: '/\'', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.end.php']

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

    it 'should tokenize decoded overlapping escapes in double quoted regexes', ->
      {tokens} = grammar.tokenizeLine '"/\\\\1\\\\x41\\\\n\\\\v\\\\$/"'

      expect(tokens[0]).toEqual value: '"/', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(tokens[1]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'keyword.other.back-reference.regexp.php']
      expect(tokens[2]).toEqual value: '1', scopes: quotedDoubleRegexpScope.concat ['keyword.other.back-reference.regexp.php', 'constant.numeric.regexp.php']
      expect(tokens[3]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.numeric.regexp.php']
      expect(tokens[4]).toEqual value: 'x41', scopes: quotedDoubleRegexpScope.concat ['constant.character.numeric.regexp.php']
      expect(tokens[5]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(tokens[6]).toEqual value: 'n', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[7]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(tokens[8]).toEqual value: 'v', scopes: quotedDoubleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(tokens[9]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(tokens[10]).toEqual value: '$', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[11]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should tokenize decoded bell escapes in interpreted quoted regexes', ->
      doubleQuoted = grammar.tokenizeLine '"/\\\\a/"'
      singleQuoted = grammar.tokenizeLine "'/\\\\a/'"

      expect(doubleQuoted.tokens[1]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[2]).toEqual value: 'a', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']

      expect(singleQuoted.tokens[1]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[2]).toEqual value: 'a', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']

    it 'should tokenize decoded shorthand character-type escapes in quoted regexes', ->
      doubleQuoted = grammar.tokenizeLine '"/\\\\d/"'
      singleQuoted = grammar.tokenizeLine "'/\\\\d/'"

      expect(doubleQuoted.tokens[1]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[2]).toEqual value: 'd', scopes: quotedDoubleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(singleQuoted.tokens[1]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(singleQuoted.tokens[2]).toEqual value: 'd', scopes: quotedSingleRegexpScope.concat ['constant.character.class.regexp.php']

    it 'should tokenize decoded property and braced hex escapes in quoted regexes', ->
      doubleQuoted = grammar.tokenizeLine '"/\\\\p{L}\\\\x{41}/"'
      singleQuoted = grammar.tokenizeLine "'/\\\\p{L}\\\\x{41}/'"

      expect(doubleQuoted.tokens[1]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[2]).toEqual value: 'p{L}', scopes: quotedDoubleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[3]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.numeric.regexp.php']
      expect(doubleQuoted.tokens[4]).toEqual value: 'x{41}', scopes: quotedDoubleRegexpScope.concat ['constant.character.numeric.regexp.php']

      expect(singleQuoted.tokens[1]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(singleQuoted.tokens[2]).toEqual value: 'p{L}', scopes: quotedSingleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(singleQuoted.tokens[3]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.numeric.regexp.php']
      expect(singleQuoted.tokens[4]).toEqual value: 'x{41}', scopes: quotedSingleRegexpScope.concat ['constant.character.numeric.regexp.php']

    it 'should tokenize decoded overlapping escapes in single quoted regexes', ->
      {tokens} = grammar.tokenizeLine "'/\\\\1\\\\x41\\\\n\\\\v\\\\$/'"

      expect(tokens[0]).toEqual value: '\'/', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(tokens[1]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'keyword.other.back-reference.regexp.php']
      expect(tokens[2]).toEqual value: '1', scopes: quotedSingleRegexpScope.concat ['keyword.other.back-reference.regexp.php', 'constant.numeric.regexp.php']
      expect(tokens[3]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.numeric.regexp.php']
      expect(tokens[4]).toEqual value: 'x41', scopes: quotedSingleRegexpScope.concat ['constant.character.numeric.regexp.php']
      expect(tokens[5]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(tokens[6]).toEqual value: 'n', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[7]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(tokens[8]).toEqual value: 'v', scopes: quotedSingleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(tokens[9]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(tokens[10]).toEqual value: '$', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[11]).toEqual value: '/\'', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.end.php']

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

    it 'should tokenize raw regex-native escapes in single quoted regexes', ->
      {tokens} = grammar.tokenizeLine "'/\\a\\cA\\n\\r\\t\\f\\e\\/\\+\\*\\?\\|\\-\\#\\(\\)/'"

      expect(tokens[0]).toEqual value: '\'/', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(tokens[1]).toEqual value: '\\a', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[2]).toEqual value: '\\cA', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[3]).toEqual value: '\\n', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[4]).toEqual value: '\\r', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[5]).toEqual value: '\\t', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[6]).toEqual value: '\\f', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[7]).toEqual value: '\\e', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[8]).toEqual value: '\\/', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[9]).toEqual value: '\\+', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[10]).toEqual value: '\\*', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[11]).toEqual value: '\\?', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[12]).toEqual value: '\\|', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[13]).toEqual value: '\\-', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[14]).toEqual value: '\\#', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[15]).toEqual value: '\\(', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[16]).toEqual value: '\\)', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[17]).toEqual value: '/\'', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should tokenize apostrophe escapes according to quoted PHP host rules', ->
      # Build the PHP strings from pieces so apostrophe transport stays readable and exact.
      doubleQuotedRaw = grammar.tokenizeLine "\"/" + "\\'" + "/\""
      doubleQuotedDecoded = grammar.tokenizeLine "\"/" + "\\\\" + "'" + "/\""
      singleQuotedRaw = grammar.tokenizeLine "'/" + "\\'" + "/'"

      expect(doubleQuotedRaw.tokens[0]).toEqual value: '"/', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(doubleQuotedRaw.tokens[1]).toEqual value: '\\\'', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(doubleQuotedRaw.tokens[2]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

      expect(doubleQuotedDecoded.tokens[0]).toEqual value: '"/', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(doubleQuotedDecoded.tokens[1]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(doubleQuotedDecoded.tokens[2]).toEqual value: '\'', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(doubleQuotedDecoded.tokens[3]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

      expect(singleQuotedRaw.tokens[0]).toEqual value: '\'/', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(singleQuotedRaw.tokens[1]).toEqual value: '\\\'', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php']
      expect(singleQuotedRaw.tokens[2]).toEqual value: '/\'', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should tokenize neutral non-alnum punctuation escapes according to PHP host rules', ->
      # Use `;` as a neutral PCRE "escaped non-alnum" sample because PHP does not consume it specially.
      doubleQuotedRaw = grammar.tokenizeLine "\"/" + "\\;" + "/\""
      doubleQuotedDecoded = grammar.tokenizeLine "\"/" + "\\\\" + ";" + "/\""
      singleQuotedRaw = grammar.tokenizeLine "'/" + "\\;" + "/'"
      singleQuotedDecoded = grammar.tokenizeLine "'/" + "\\\\" + ";" + "/'"

      expect(doubleQuotedRaw.tokens[0]).toEqual value: '"/', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(doubleQuotedRaw.tokens[1]).toEqual value: '\\;', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(doubleQuotedRaw.tokens[2]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

      expect(doubleQuotedDecoded.tokens[0]).toEqual value: '"/', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(doubleQuotedDecoded.tokens[1]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(doubleQuotedDecoded.tokens[2]).toEqual value: ';', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(doubleQuotedDecoded.tokens[3]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

      expect(singleQuotedRaw.tokens[0]).toEqual value: '\'/', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(singleQuotedRaw.tokens[1]).toEqual value: '\\;', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(singleQuotedRaw.tokens[2]).toEqual value: '/\'', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.end.php']

      expect(singleQuotedDecoded.tokens[0]).toEqual value: '\'/', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(singleQuotedDecoded.tokens[1]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(singleQuotedDecoded.tokens[2]).toEqual value: ';', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(singleQuotedDecoded.tokens[3]).toEqual value: '/\'', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should tokenize structural character-class opener parity in interpreted quoted regexes', ->
      twoBackslashes = '\\'.repeat 2
      threeBackslashes = '\\'.repeat 3
      fourBackslashes = '\\'.repeat 4

      doubleQuotedTwo = grammar.tokenizeLine '"/' + twoBackslashes + '[a-z]/"'
      doubleQuotedThree = grammar.tokenizeLine '"/' + threeBackslashes + '[a-z]/"'
      doubleQuotedFour = grammar.tokenizeLine '"/' + fourBackslashes + '[a-z]/"'
      singleQuotedTwo = grammar.tokenizeLine "'/" + twoBackslashes + "[a-z]/'"
      singleQuotedThree = grammar.tokenizeLine "'/" + threeBackslashes + "[a-z]/'"
      singleQuotedFour = grammar.tokenizeLine "'/" + fourBackslashes + "[a-z]/'"

      expect(doubleQuotedTwo.tokens[1]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(doubleQuotedTwo.tokens[2]).toEqual value: '[', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(doubleQuotedTwo.tokens[3]).toEqual value: 'a-z]', scopes: quotedDoubleRegexpScope

      expect(doubleQuotedThree.tokens[1]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(doubleQuotedThree.tokens[2]).toEqual value: '\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(doubleQuotedThree.tokens[3]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)

      expect(doubleQuotedFour.tokens[1]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php']
      expect(doubleQuotedFour.tokens[2]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(doubleQuotedFour.tokens[3]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)

      expect(singleQuotedTwo.tokens[1]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(singleQuotedTwo.tokens[2]).toEqual value: '[', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(singleQuotedTwo.tokens[3]).toEqual value: 'a-z]', scopes: quotedSingleRegexpScope

      expect(singleQuotedThree.tokens[1]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(singleQuotedThree.tokens[2]).toEqual value: '\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(singleQuotedThree.tokens[3]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)

      expect(singleQuotedFour.tokens[1]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php']
      expect(singleQuotedFour.tokens[2]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(singleQuotedFour.tokens[3]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)

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

    it 'should tokenize decoded named backreferences in interpreted quoted regexes', ->
      doubleQuoted = grammar.tokenizeLine "\"/\\\\k<name>\\\\k'name'/\""
      singleQuoted = grammar.tokenizeLine "'/\\\\k<name>/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"/', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(doubleQuoted.tokens[1]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'keyword.other.back-reference.named.regexp.php']
      expect(doubleQuoted.tokens[2]).toEqual value: 'k', scopes: regexpNamedBackreferenceScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: '<', scopes: regexpNamedBackreferenceScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
      expect(doubleQuoted.tokens[4]).toEqual value: 'name', scopes: regexpNamedBackreferenceNameScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[5]).toEqual value: '>', scopes: regexpNamedBackreferenceScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']
      expect(doubleQuoted.tokens[6]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'keyword.other.back-reference.named.regexp.php']
      expect(doubleQuoted.tokens[7]).toEqual value: 'k', scopes: regexpNamedBackreferenceScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[8]).toEqual value: '\'', scopes: regexpNamedBackreferenceScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
      expect(doubleQuoted.tokens[9]).toEqual value: 'name', scopes: regexpNamedBackreferenceNameScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[10]).toEqual value: '\'', scopes: regexpNamedBackreferenceScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']
      expect(doubleQuoted.tokens[11]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

      expect(singleQuoted.tokens[0]).toEqual value: '\'/', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(singleQuoted.tokens[1]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'keyword.other.back-reference.named.regexp.php']
      expect(singleQuoted.tokens[2]).toEqual value: 'k', scopes: regexpNamedBackreferenceScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[3]).toEqual value: '<', scopes: regexpNamedBackreferenceScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
      expect(singleQuoted.tokens[4]).toEqual value: 'name', scopes: regexpNamedBackreferenceNameScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[5]).toEqual value: '>', scopes: regexpNamedBackreferenceScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']
      expect(singleQuoted.tokens[6]).toEqual value: '/\'', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.end.php']

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
      expect(doubleQuoted.tokens[1]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[2]).toEqual value: 'foo/bar', scopes: regexpQuotedLiteralContentScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: '\\E', scopes: regexpQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[4]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

      expect(singleQuoted.tokens[0]).toEqual value: '\'/', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(singleQuoted.tokens[1]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[2]).toEqual value: 'foo/bar', scopes: regexpQuotedLiteralContentScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[3]).toEqual value: '\\E', scopes: regexpQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[4]).toEqual value: '/\'', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should stop unclosed quoted literals at the quoted regex terminator', ->
      doubleQuoted = grammar.tokenizeLine '"/\\Qfoo/bar/"'
      singleQuoted = grammar.tokenizeLine "'/\\Qfoo/bar/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"/', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(doubleQuoted.tokens[1]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[2]).toEqual value: 'foo/bar', scopes: regexpQuotedLiteralContentScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

      expect(singleQuoted.tokens[0]).toEqual value: '\'/', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(singleQuoted.tokens[1]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[2]).toEqual value: 'foo/bar', scopes: regexpQuotedLiteralContentScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[3]).toEqual value: '/\'', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should tokenize interpolation inside double quoted regex quoted literals', ->
      {tokens} = grammar.tokenizeLine '"/\\Q$foo\\E/"'

      expect(tokens[0]).toEqual value: '"/', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(tokens[1]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(tokens[2]).toEqual value: '$', scopes: regexpQuotedLiteralContentScopes(quotedDoubleRegexpScope).concat ['variable.other.php', 'punctuation.definition.variable.php']
      expect(tokens[3]).toEqual value: 'foo', scopes: regexpQuotedLiteralContentScopes(quotedDoubleRegexpScope).concat ['variable.other.php']
      expect(tokens[4]).toEqual value: '\\E', scopes: regexpQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(tokens[5]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should not treat escaped parentheses as groups in double quoted regexes', ->
      {tokens} = grammar.tokenizeLine '"/\\(ab\\)/"'

      expect(tokens[0]).toEqual value: '"/', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.begin.php']
      expect(tokens[1]).toEqual value: '\\(', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[2]).toEqual value: 'ab', scopes: quotedDoubleRegexpScope
      expect(tokens[3]).toEqual value: '\\)', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[4]).toEqual value: '/"', scopes: quotedDoubleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should keep multiline slash-prefixed double quoted strings out of regex mode', ->
      lines = grammar.tokenizeLines "$r = \"/foo\nbar/\";"

      expect(lines[0].some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false
      expect(lines[1].some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false

    it 'should keep multiline slash-prefixed single quoted strings out of regex mode', ->
      lines = grammar.tokenizeLines "$r = '/foo\nbar/';"

      expect(lines[0].some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false
      expect(lines[1].some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false

  describe 'PHP transport scopes in regex hosts', ->
    # These tests only lock in the PHP transport layer for doubled backslashes.
    # Some interpreted-host forms also gain regex meaning in more specific tests below.
    it 'should keep PHP transport scopes on doubled backslashes in quoted regex bodies', ->
      doubleQuoted = grammar.tokenizeLine '"/\\\\1\\\\x41\\\\d/";'
      singleQuoted = grammar.tokenizeLine "'/\\\\1\\\\x41\\\\d/';"
      singleQuotedEscapes = singleQuoted.tokens.filter (token) -> token.value.includes('\\\\')

      expect(doubleQuoted.tokens[1].value).toBe '\\\\'
      expect(doubleQuoted.tokens[3].value).toBe '\\\\'
      expect(doubleQuoted.tokens[5].value).toBe '\\\\'
      expect(doubleQuoted.tokens[1].scopes.includes('constant.character.escape.php')).toBe true
      expect(doubleQuoted.tokens[3].scopes.includes('constant.character.escape.php')).toBe true
      expect(doubleQuoted.tokens[5].scopes.includes('constant.character.escape.php')).toBe true

      expect(singleQuotedEscapes).to.have.lengthOf 3
      expect(singleQuotedEscapes.every((token) -> token.scopes.includes('constant.character.escape.php'))).toBe true

    it 'should keep PHP transport scopes on doubled backslashes in quoted regex character classes', ->
      doubleQuoted = grammar.tokenizeLine '"/[\\\\1\\\\x41\\\\d]/";'
      singleQuoted = grammar.tokenizeLine "'/[\\\\1\\\\x41\\\\d]/';"
      doubleQuotedEscapes = doubleQuoted.tokens.filter (token) -> token.value is '\\\\'
      singleQuotedEscapes = singleQuoted.tokens.filter (token) -> token.value is '\\\\'

      expect(doubleQuotedEscapes).to.have.lengthOf 3
      expect(singleQuotedEscapes).to.have.lengthOf 3
      expect(doubleQuotedEscapes.every((token) -> token.scopes.includes('constant.character.escape.php'))).toBe true
      expect(singleQuotedEscapes.every((token) -> token.scopes.includes('constant.character.escape.php'))).toBe true

    it 'should keep PHP transport scopes on doubled backslashes in REGEX heredoc bodies', ->
      lines = grammar.tokenizeLines '''
        $r = <<<REGEX
        /\\\\1\\\\x41\\\\d/
        REGEX;
      '''

      expect(lines[1][1].value).toBe '\\\\'
      expect(lines[1][3].value).toBe '\\\\'
      expect(lines[1][5].value).toBe '\\\\'
      expect(lines[1][1].scopes.includes('constant.character.escape.php')).toBe true
      expect(lines[1][3].scopes.includes('constant.character.escape.php')).toBe true
      expect(lines[1][5].scopes.includes('constant.character.escape.php')).toBe true

    it 'should keep PHP transport scopes on doubled backslashes in REGEXP heredoc character classes', ->
      lines = grammar.tokenizeLines '''
        $r = <<<REGEXP
        /[\\\\1\\\\x41\\\\d]/
        REGEXP;
      '''
      heredocEscapes = lines[1].filter (token) -> token.value is '\\\\'

      expect(heredocEscapes).to.have.lengthOf 3
      expect(heredocEscapes.every((token) -> token.scopes.includes('constant.character.escape.php'))).toBe true

    it 'should keep doubled backslashes regex-native in REGEXP nowdoc bodies', ->
      lines = grammar.tokenizeLines '''
        $r = <<<'REGEXP'
        /\\\\1/
        REGEXP;
      '''

      expect(lines[1][1]).toEqual value: '\\\\', scopes: nowdocRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(lines[1][1].scopes.includes('constant.character.escape.php')).toBe false

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
      expect(lines[1][1]).toEqual value: '\\[', scopes: heredocRegexpScope.concat ['constant.character.escape.regexp.php']
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
      expect(lines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
      expect(lines[1][3]).toEqual value: '\\\\', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
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
      expect(lines[1][1]).toEqual value: '\\[', scopes: nowdocRegexpScope.concat ['constant.character.escape.regexp.php']
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
      expect(lines[1][1]).toEqual value: '\\[', scopes: heredocRegexpScope.concat ['constant.character.escape.regexp.php']
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
      expect(lines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
      expect(lines[1][3]).toEqual value: '\\\\', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
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
      expect(lines[1][1]).toEqual value: '\\[', scopes: nowdocRegexpScope.concat ['constant.character.escape.regexp.php']
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
          expect(lines[1][9]).toEqual value: '\\d', scopes: regexpCharacterClassClassEscapeScopes(regexScope)
          expect(lines[1][10]).toEqual value: '\\]', scopes: regexpCharacterClassEscapeScopes(regexScope)
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
          expect(lines[1][9]).toEqual value: '\\\\', scopes: if description is 'REGEXP nowdoc' then regexpCharacterClassEscapeScopes(regexScope) else regexpCharacterClassScopes(regexScope).concat ['constant.character.escape.php']
          expect(lines[1][10]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should close character classes at the first unescaped bracket in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            r\\a[g[G]]e(x)
            #{label};
          """

          expect(lines[1][0]).toEqual value: 'r', scopes: regexScope
          expect(lines[1][1]).toEqual value: '\\a', scopes: regexScope.concat ['constant.character.escape.regexp.php']
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
          expect(lines[1][6]).toEqual value: '\\p{L}', scopes: regexpCharacterClassClassEscapeScopes(regexScope)
          expect(lines[1][7]).toEqual value: '\\-', scopes: regexpCharacterClassEscapeScopes(regexScope)
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
          expect(lines[1][1]).toEqual value: '\\(', scopes: regexScope.concat ['constant.character.escape.regexp.php']
          expect(lines[1][2]).toEqual value: 'ab', scopes: regexScope
          expect(lines[1][3]).toEqual value: '\\)', scopes: regexScope.concat ['constant.character.escape.regexp.php']
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
            /\\k<word>\\k'word'(?P=word)/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '\\k', scopes: regexScope.concat ['keyword.other.back-reference.named.regexp.php']
          expect(lines[1][2]).toEqual value: '<', scopes: regexpNamedBackreferenceScopes(regexScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
          expect(lines[1][3]).toEqual value: 'word', scopes: regexpNamedBackreferenceNameScopes(regexScope)
          expect(lines[1][4]).toEqual value: '>', scopes: regexpNamedBackreferenceScopes(regexScope).concat ['punctuation.definition.group.capture.end.regexp.php']
          expect(lines[1][5]).toEqual value: '\\k', scopes: regexpNamedBackreferenceScopes(regexScope)
          expect(lines[1][6]).toEqual value: '\'', scopes: regexpNamedBackreferenceScopes(regexScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
          expect(lines[1][7]).toEqual value: 'word', scopes: regexpNamedBackreferenceNameScopes(regexScope)
          expect(lines[1][8]).toEqual value: '\'', scopes: regexpNamedBackreferenceScopes(regexScope).concat ['punctuation.definition.group.capture.end.regexp.php']
          expect(lines[1][9]).toEqual value: '(', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][10]).toEqual value: '?P=', scopes: regexpGroupScopes(regexScope).concat ['keyword.other.back-reference.named.regexp.php']
          expect(lines[1][11]).toEqual value: 'word', scopes: regexpGroupNameScopes(regexpGroupScopes(regexScope))
          expect(lines[1][12]).toEqual value: ')', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][13]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        if description is 'REGEX heredoc'
          it 'should keep single-backslash overlapping escapes PHP-first in REGEX heredoc', ->
            lines = grammar.tokenizeLines """
              $r = <<<REGEX
              /\\1\\x41\\n\\v\\$\\d\\x{41}/
              REGEX;
            """

            expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
            expect(lines[1][1]).toEqual value: '\\1', scopes: heredocRegexpScope.concat ['constant.character.escape.octal.php']
            expect(lines[1][2]).toEqual value: '\\x41', scopes: heredocRegexpScope.concat ['constant.character.escape.hex.php']
            expect(lines[1][3]).toEqual value: '\\n', scopes: heredocRegexpScope.concat ['constant.character.escape.php']
            expect(lines[1][4]).toEqual value: '\\v', scopes: heredocRegexpScope.concat ['constant.character.escape.php']
            expect(lines[1][5]).toEqual value: '\\$', scopes: heredocRegexpScope.concat ['constant.character.escape.php']
            expect(lines[1][6]).toEqual value: '\\d', scopes: heredocRegexpScope.concat ['constant.character.class.regexp.php']
            expect(lines[1][7]).toEqual value: '\\x{41}', scopes: heredocRegexpScope.concat ['constant.character.numeric.regexp.php']
            expect(lines[1][8]).toEqual value: '/', scopes: heredocRegexpScope
            expect(lines[2][0]).toEqual value: 'REGEX', scopes: heredocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.heredoc.php']
            expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        if description is 'REGEXP nowdoc'
          it 'should keep overlapping single-backslash escapes regex-first in REGEXP nowdoc', ->
            lines = grammar.tokenizeLines """
              $r = <<<'REGEXP'
              /\\1\\x41\\n\\v\\$\\d\\x{41}/
              REGEXP;
            """

            expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
            expect(lines[1][1]).toEqual value: '\\', scopes: nowdocRegexpScope.concat ['keyword.other.back-reference.regexp.php']
            expect(lines[1][2]).toEqual value: '1', scopes: nowdocRegexpScope.concat ['keyword.other.back-reference.regexp.php', 'constant.numeric.regexp.php']
            expect(lines[1][3]).toEqual value: '\\x41', scopes: nowdocRegexpScope.concat ['constant.character.numeric.regexp.php']
            expect(lines[1][4]).toEqual value: '\\n', scopes: nowdocRegexpScope.concat ['constant.character.escape.regexp.php']
            expect(lines[1][5]).toEqual value: '\\v', scopes: nowdocRegexpScope.concat ['constant.character.class.regexp.php']
            expect(lines[1][6]).toEqual value: '\\$', scopes: nowdocRegexpScope.concat ['constant.character.escape.regexp.php']
            expect(lines[1][7]).toEqual value: '\\d', scopes: nowdocRegexpScope.concat ['constant.character.class.regexp.php']
            expect(lines[1][8]).toEqual value: '\\x{41}', scopes: nowdocRegexpScope.concat ['constant.character.numeric.regexp.php']
            expect(lines[1][9]).toEqual value: '/', scopes: nowdocRegexpScope
            expect(lines[2][0]).toEqual value: 'REGEXP', scopes: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.nowdoc.php']
            expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize regex-only character-type and property escapes in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /\\d\\D\\w\\W\\s\\S\\h\\H\\V\\R\\p{L}\\P{N}/
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
          expect(lines[1][9]).toEqual value: '\\V', scopes: regexScope.concat ['constant.character.class.regexp.php']
          expect(lines[1][10]).toEqual value: '\\R', scopes: regexScope.concat ['constant.character.class.regexp.php']
          expect(lines[1][11]).toEqual value: '\\p{L}', scopes: regexScope.concat ['constant.character.class.regexp.php']
          expect(lines[1][12]).toEqual value: '\\P{N}', scopes: regexScope.concat ['constant.character.class.regexp.php']
          expect(lines[1][13]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize regex-only literal escapes in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /\\a\\cA\\/\\+\\*\\?\\|\\-\\#\\x{1F600}/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '\\a', scopes: regexScope.concat ['constant.character.escape.regexp.php']
          expect(lines[1][2]).toEqual value: '\\cA', scopes: regexScope.concat ['constant.character.escape.regexp.php']
          expect(lines[1][3]).toEqual value: '\\/', scopes: regexScope.concat ['constant.character.escape.regexp.php']
          expect(lines[1][4]).toEqual value: '\\+', scopes: regexScope.concat ['constant.character.escape.regexp.php']
          expect(lines[1][5]).toEqual value: '\\*', scopes: regexScope.concat ['constant.character.escape.regexp.php']
          expect(lines[1][6]).toEqual value: '\\?', scopes: regexScope.concat ['constant.character.escape.regexp.php']
          expect(lines[1][7]).toEqual value: '\\|', scopes: regexScope.concat ['constant.character.escape.regexp.php']
          expect(lines[1][8]).toEqual value: '\\-', scopes: regexScope.concat ['constant.character.escape.regexp.php']
          expect(lines[1][9]).toEqual value: '\\#', scopes: regexScope.concat ['constant.character.escape.regexp.php']
          expect(lines[1][10]).toEqual value: '\\x{1F600}', scopes: regexScope.concat ['constant.character.numeric.regexp.php']
          expect(lines[1][11]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        if description is 'REGEXP nowdoc'
          it "should keep character classes after escaped backslashes in #{description}", ->
            lines = grammar.tokenizeLines """
              $r = #{opener}
              /\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f]/
              #{label};
            """

            expect(lines[1][0]).toEqual value: '/', scopes: regexScope
            expect(lines[1][1]).toEqual value: '\\\\', scopes: regexScope.concat ['constant.character.escape.regexp.php']
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

          it "should keep dot operators and anchors after escaped backslashes in #{description}", ->
            lines = grammar.tokenizeLines """
              $r = #{opener}
              /\\\\.$/
              #{label};
            """

            expect(lines[1][0]).toEqual value: '/', scopes: regexScope
            expect(lines[1][1]).toEqual value: '\\\\', scopes: regexScope.concat ['constant.character.escape.regexp.php']
            expect(lines[1][2]).toEqual value: '.', scopes: regexScope.concat ['constant.character.class.regexp.php']
            expect(lines[1][3]).toEqual value: '$', scopes: regexScope.concat ['keyword.control.anchor.regexp.php']
            expect(lines[1][4]).toEqual value: '/', scopes: regexScope
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

        if description is 'REGEXP nowdoc'
          it "should keep groups and quantifiers after escaped backslashes in #{description}", ->
            lines = grammar.tokenizeLines """
              $r = #{opener}
              /\\\\(ab){2,3}/
              #{label};
            """

            expect(lines[1][0]).toEqual value: '/', scopes: regexScope
            expect(lines[1][1]).toEqual value: '\\\\', scopes: regexScope.concat ['constant.character.escape.regexp.php']
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
            expect(lines[1][1]).toEqual value: '\\\\', scopes: regexScope.concat ['constant.character.escape.regexp.php']
            expect(lines[1][2]).toEqual value: '1', scopes: regexScope
            expect(lines[1][3]).toEqual value: '\\\\', scopes: regexScope.concat ['constant.character.escape.regexp.php']
            expect(lines[1][4]).toEqual value: 'd/', scopes: regexScope
            expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
            expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        if description is 'REGEX heredoc'
          it 'should tokenize decoded overlapping escapes in REGEX heredoc', ->
            lines = grammar.tokenizeLines """
              $r = <<<REGEX
              /\\\\1\\\\x41\\\\n\\\\v\\\\$/
              REGEX;
            """

            expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
            expect(lines[1][1]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'keyword.other.back-reference.regexp.php']
            expect(lines[1][2]).toEqual value: '1', scopes: heredocRegexpScope.concat ['keyword.other.back-reference.regexp.php', 'constant.numeric.regexp.php']
            expect(lines[1][3]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.numeric.regexp.php']
            expect(lines[1][4]).toEqual value: 'x41', scopes: heredocRegexpScope.concat ['constant.character.numeric.regexp.php']
            expect(lines[1][5]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
            expect(lines[1][6]).toEqual value: 'n', scopes: heredocRegexpScope.concat ['constant.character.escape.regexp.php']
            expect(lines[1][7]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
            expect(lines[1][8]).toEqual value: 'v', scopes: heredocRegexpScope.concat ['constant.character.class.regexp.php']
            expect(lines[1][9]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
            expect(lines[1][10]).toEqual value: '$', scopes: heredocRegexpScope.concat ['constant.character.escape.regexp.php']
            expect(lines[1][11]).toEqual value: '/', scopes: heredocRegexpScope
            expect(lines[2][0]).toEqual value: 'REGEX', scopes: heredocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.heredoc.php']

          it 'should tokenize decoded bell escapes in REGEX heredoc', ->
            lines = grammar.tokenizeLines """
              $r = <<<REGEX
              /\\\\a/
              REGEX;
            """

            expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
            expect(lines[1][1]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
            expect(lines[1][2]).toEqual value: 'a', scopes: heredocRegexpScope.concat ['constant.character.escape.regexp.php']
            expect(lines[1][3]).toEqual value: '/', scopes: heredocRegexpScope
            expect(lines[2][0]).toEqual value: 'REGEX', scopes: heredocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.heredoc.php']

          it 'should tokenize raw and decoded apostrophe escapes in REGEX heredoc', ->
            rawLines = grammar.tokenizeLines """
              $r = <<<REGEX
              /\\'/
              REGEX;
            """
            decodedLines = grammar.tokenizeLines """
              $r = <<<REGEX
              /\\\\'/
              REGEX;
            """

            expect(rawLines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
            expect(rawLines[1][1]).toEqual value: '\\\'', scopes: heredocRegexpScope.concat ['constant.character.escape.regexp.php']
            expect(rawLines[1][2]).toEqual value: '/', scopes: heredocRegexpScope

            expect(decodedLines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
            expect(decodedLines[1][1]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
            expect(decodedLines[1][2]).toEqual value: '\'', scopes: heredocRegexpScope.concat ['constant.character.escape.regexp.php']
            expect(decodedLines[1][3]).toEqual value: '/', scopes: heredocRegexpScope

          it 'should tokenize neutral non-alnum punctuation escapes in REGEX heredoc', ->
            rawLines = grammar.tokenizeLines """
              $r = <<<REGEX
              /\\;/
              REGEX;
            """
            decodedLines = grammar.tokenizeLines """
              $r = <<<REGEX
              /\\\\;/
              REGEX;
            """

            expect(rawLines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
            expect(rawLines[1][1]).toEqual value: '\\;', scopes: heredocRegexpScope.concat ['constant.character.escape.regexp.php']
            expect(rawLines[1][2]).toEqual value: '/', scopes: heredocRegexpScope

            expect(decodedLines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
            expect(decodedLines[1][1]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
            expect(decodedLines[1][2]).toEqual value: ';', scopes: heredocRegexpScope.concat ['constant.character.escape.regexp.php']
            expect(decodedLines[1][3]).toEqual value: '/', scopes: heredocRegexpScope

          it 'should tokenize structural character-class opener parity in REGEX heredoc', ->
            twoBackslashes = '\\'.repeat 2
            threeBackslashes = '\\'.repeat 3
            fourBackslashes = '\\'.repeat 4
            twoLines = grammar.tokenizeLines ['$r = <<<REGEX', '/' + twoBackslashes + '[a-z]/', 'REGEX;'].join "\n"
            threeLines = grammar.tokenizeLines ['$r = <<<REGEX', '/' + threeBackslashes + '[a-z]/', 'REGEX;'].join "\n"
            fourLines = grammar.tokenizeLines ['$r = <<<REGEX', '/' + fourBackslashes + '[a-z]/', 'REGEX;'].join "\n"

            expect(twoLines[1][1]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
            expect(twoLines[1][2]).toEqual value: '[', scopes: heredocRegexpScope.concat ['constant.character.escape.regexp.php']
            expect(twoLines[1][3]).toEqual value: 'a-z]/', scopes: heredocRegexpScope

            expect(threeLines[1][1]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
            expect(threeLines[1][2]).toEqual value: '\\', scopes: heredocRegexpScope.concat ['constant.character.escape.regexp.php']
            expect(threeLines[1][3]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)

            expect(fourLines[1][1]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php']
            expect(fourLines[1][2]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
            expect(fourLines[1][3]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)

          it 'should tokenize decoded named backreferences in REGEX heredoc', ->
            lines = grammar.tokenizeLines """
              $r = <<<REGEX
              /\\\\k<word>\\\\k'word'/
              REGEX;
            """

            expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
            expect(lines[1][1]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'keyword.other.back-reference.named.regexp.php']
            expect(lines[1][2]).toEqual value: 'k', scopes: regexpNamedBackreferenceScopes(heredocRegexpScope)
            expect(lines[1][3]).toEqual value: '<', scopes: regexpNamedBackreferenceScopes(heredocRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
            expect(lines[1][4]).toEqual value: 'word', scopes: regexpNamedBackreferenceNameScopes(heredocRegexpScope)
            expect(lines[1][5]).toEqual value: '>', scopes: regexpNamedBackreferenceScopes(heredocRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']
            expect(lines[1][6]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'keyword.other.back-reference.named.regexp.php']
            expect(lines[1][7]).toEqual value: 'k', scopes: regexpNamedBackreferenceScopes(heredocRegexpScope)
            expect(lines[1][8]).toEqual value: '\'', scopes: regexpNamedBackreferenceScopes(heredocRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
            expect(lines[1][9]).toEqual value: 'word', scopes: regexpNamedBackreferenceNameScopes(heredocRegexpScope)
            expect(lines[1][10]).toEqual value: '\'', scopes: regexpNamedBackreferenceScopes(heredocRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']
            expect(lines[1][11]).toEqual value: '/', scopes: heredocRegexpScope
            expect(lines[2][0]).toEqual value: 'REGEX', scopes: heredocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.heredoc.php']

        if description is 'REGEXP nowdoc'
          it 'should tokenize raw apostrophe escapes in REGEXP nowdoc', ->
            lines = grammar.tokenizeLines '''
              $r = <<<'REGEXP'
              /\\'/
              REGEXP;
            '''

            expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
            expect(lines[1][1]).toEqual value: '\\\'', scopes: nowdocRegexpScope.concat ['constant.character.escape.regexp.php']
            expect(lines[1][2]).toEqual value: '/', scopes: nowdocRegexpScope

          it 'should tokenize neutral non-alnum punctuation escapes in REGEXP nowdoc', ->
            # Build these raw nowdoc fixtures from pieces so CoffeeScript does not collapse the backslashes.
            rawLines = grammar.tokenizeLines ["$r = <<<'REGEXP'", '/\\;/', 'REGEXP;'].join "\n"
            doubledLines = grammar.tokenizeLines ["$r = <<<'REGEXP'", '/\\\\;/', 'REGEXP;'].join "\n"

            expect(rawLines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
            expect(rawLines[1][1]).toEqual value: '\\;', scopes: nowdocRegexpScope.concat ['constant.character.escape.regexp.php']
            expect(rawLines[1][2]).toEqual value: '/', scopes: nowdocRegexpScope

            expect(doubledLines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
            expect(doubledLines[1][1]).toEqual value: '\\\\', scopes: nowdocRegexpScope.concat ['constant.character.escape.regexp.php']
            expect(doubledLines[1][2]).toEqual value: ';/', scopes: nowdocRegexpScope

          it 'should tokenize decoded property and braced hex escapes in REGEX heredoc', ->
            lines = grammar.tokenizeLines """
              $r = <<<REGEX
              /\\\\p{L}\\\\x{41}/
              REGEX;
            """

            expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
            expect(lines[1][1]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
            expect(lines[1][2]).toEqual value: 'p{L}', scopes: heredocRegexpScope.concat ['constant.character.class.regexp.php']
            expect(lines[1][3]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.numeric.regexp.php']
            expect(lines[1][4]).toEqual value: 'x{41}', scopes: heredocRegexpScope.concat ['constant.character.numeric.regexp.php']
            expect(lines[1][5]).toEqual value: '/', scopes: heredocRegexpScope
            expect(lines[2][0]).toEqual value: 'REGEX', scopes: heredocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.heredoc.php']
            expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize escaped slashes in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            foo/bar\\/baz
            #{label};
          """

          expect(lines[1][0]).toEqual value: 'foo/bar', scopes: regexScope
          expect(lines[1][1]).toEqual value: '\\/', scopes: regexScope.concat ['constant.character.escape.regexp.php']
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
          expect(lines[1][1]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(regexScope).concat ['constant.character.escape.regexp.php']
          expect(lines[1][2]).toEqual value: 'a.b+#', scopes: regexpQuotedLiteralContentScopes(regexScope)
          expect(lines[1][3]).toEqual value: '\\E', scopes: regexpQuotedLiteralBoundaryScopes(regexScope).concat ['constant.character.escape.regexp.php']
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
          expect(lines[1][1]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(regexScope).concat ['constant.character.escape.regexp.php']
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
      expect(lines[1][1]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(heredocRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(lines[1][2]).toEqual value: '$', scopes: regexpQuotedLiteralContentScopes(heredocRegexpScope).concat ['variable.other.php', 'punctuation.definition.variable.php']
      expect(lines[1][3]).toEqual value: 'value', scopes: regexpQuotedLiteralContentScopes(heredocRegexpScope).concat ['variable.other.php']
      expect(lines[1][4]).toEqual value: '\\E', scopes: regexpQuotedLiteralBoundaryScopes(heredocRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(lines[1][5]).toEqual value: '/', scopes: heredocRegexpScope

    it 'should tokenize nested quoted regex escapes and operators inside REGEXP heredoc quoted literals', ->
      nestedQuotedRegex = '"/(\\"\\\'[a-z]|\\d+)/ui"'
      # Build the heredoc with interpolation so the nested quoted regex stays readable without over-escaping.
      lines = grammar.tokenizeLines """
        $r = <<<REGEXP
        \\Q$fragment{$makeFragment(#{nestedQuotedRegex})}\\E
        REGEXP;
      """

      nestedQuotedDoubleRegexpScope = regexpQuotedLiteralContentScopes(heredocRegexpScope).concat ['meta.embedded.interpolation.php', 'meta.function-call.php', 'meta.embedded.regexp.php', 'string.regexp.double-quoted.php']
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
      expect(lines[1][2]).toEqual value: '{', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['meta.embedded.interpolation.php', 'punctuation.definition.variable.php']
      expect(lines[1][3]).toEqual value: '$', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['meta.embedded.interpolation.php', 'variable.other.php', 'punctuation.definition.variable.php']
      expect(lines[1][4]).toEqual value: 'value', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['meta.embedded.interpolation.php', 'variable.other.php']
      expect(lines[1][5]).toEqual value: '}', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['meta.embedded.interpolation.php', 'punctuation.definition.variable.php']
      expect(lines[1][6]).toEqual value: '\\d', scopes: regexpCharacterClassClassEscapeScopes(heredocRegexpScope)
      expect(lines[1][7]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][8]).toEqual value: '/', scopes: heredocRegexpScope

    it 'should keep single-backslash overlapping escapes PHP-first in REGEXP heredoc character classes', ->
      lines = grammar.tokenizeLines '''
        $r = <<<REGEXP
        /[\\1\\x41\\n\\v\\$\\u{41}\\d\\x{41}]/
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][2]).toEqual value: '\\1', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.octal.php']
      expect(lines[1][3]).toEqual value: '\\x41', scopes: regexpCharacterClassPhpHexEscapeScopes(heredocRegexpScope)
      expect(lines[1][4]).toEqual value: '\\n', scopes: regexpCharacterClassPhpEscapeScopes(heredocRegexpScope)
      expect(lines[1][5]).toEqual value: '\\v', scopes: regexpCharacterClassPhpEscapeScopes(heredocRegexpScope)
      expect(lines[1][6]).toEqual value: '\\$', scopes: regexpCharacterClassPhpEscapeScopes(heredocRegexpScope)
      expect(lines[1][7]).toEqual value: '\\u{41}', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.unicode.php']
      expect(lines[1][8]).toEqual value: '\\d', scopes: regexpCharacterClassClassEscapeScopes(heredocRegexpScope)
      expect(lines[1][9]).toEqual value: '\\x{41}', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(lines[1][10]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][11]).toEqual value: '/', scopes: heredocRegexpScope

    it 'should tokenize decoded overlapping escapes in REGEXP heredoc character classes', ->
      lines = grammar.tokenizeLines '''
        $r = <<<REGEXP
        /[\\\\1\\\\x41\\\\n\\\\v\\\\$]/
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php']
      expect(lines[1][3]).toEqual value: '1', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.numeric.regexp.php']
      expect(lines[1][4]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php']
      expect(lines[1][5]).toEqual value: 'x41', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(lines[1][6]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php']
      expect(lines[1][7]).toEqual value: 'n', scopes: regexpCharacterClassEscapeScopes(heredocRegexpScope)
      expect(lines[1][8]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php']
      expect(lines[1][9]).toEqual value: 'v', scopes: regexpCharacterClassClassEscapeScopes(heredocRegexpScope)
      expect(lines[1][10]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php']
      expect(lines[1][11]).toEqual value: '$', scopes: regexpCharacterClassEscapeScopes(heredocRegexpScope)
      expect(lines[1][12]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][13]).toEqual value: '/', scopes: heredocRegexpScope

    it 'should tokenize decoded bell escapes in REGEXP heredoc character classes', ->
      lines = grammar.tokenizeLines '''
        $r = <<<REGEXP
        /[\\\\a]/
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php']
      expect(lines[1][3]).toEqual value: 'a', scopes: regexpCharacterClassEscapeScopes(heredocRegexpScope)
      expect(lines[1][4]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][5]).toEqual value: '/', scopes: heredocRegexpScope

    it 'should tokenize decoded property and braced hex escapes in REGEXP heredoc character classes', ->
      lines = grammar.tokenizeLines '''
        $r = <<<REGEXP
        /[\\\\p{L}\\\\x{41}]/
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php']
      expect(lines[1][3]).toEqual value: 'p{L}', scopes: regexpCharacterClassClassEscapeScopes(heredocRegexpScope)
      expect(lines[1][4]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php']
      expect(lines[1][5]).toEqual value: 'x{41}', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(lines[1][6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][7]).toEqual value: '/', scopes: heredocRegexpScope

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
      expect(lines[1][10]).toEqual value: '\\d', scopes: regexpCharacterClassClassEscapeScopes(nowdocRegexpScope)
      expect(lines[1][11]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(lines[1][12]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(lines[1].some((token) -> 'variable.other.php' in token.scopes)).toBe false

    it 'should keep overlapping single-backslash escapes raw-regex in REGEXP nowdoc character classes', ->
      lines = grammar.tokenizeLines '''
        $r = <<<'REGEXP'
        /[\\1\\x41\\n\\v\\$\\u{41}\\d\\x{41}]/
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(lines[1][2]).toEqual value: '\\1', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
      expect(lines[1][3]).toEqual value: '\\x41', scopes: regexpCharacterClassScopes(nowdocRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(lines[1][4]).toEqual value: '\\n', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
      expect(lines[1][5]).toEqual value: '\\v', scopes: regexpCharacterClassClassEscapeScopes(nowdocRegexpScope)
      expect(lines[1][6]).toEqual value: '\\$', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
      expect(lines[1][7]).toEqual value: '\\u', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
      expect(lines[1][8]).toEqual value: '{', scopes: regexpCharacterClassLiteralScopes(nowdocRegexpScope)
      expect(lines[1][9]).toEqual value: '41', scopes: regexpCharacterClassNumericScopes(nowdocRegexpScope)
      expect(lines[1][10]).toEqual value: '}', scopes: regexpCharacterClassLiteralScopes(nowdocRegexpScope)
      expect(lines[1][11]).toEqual value: '\\d', scopes: regexpCharacterClassClassEscapeScopes(nowdocRegexpScope)
      expect(lines[1][12]).toEqual value: '\\x{41}', scopes: regexpCharacterClassScopes(nowdocRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(lines[1][13]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(lines[1][14]).toEqual value: '/', scopes: nowdocRegexpScope

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


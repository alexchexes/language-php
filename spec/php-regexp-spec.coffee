{loadGrammar} = require('../utils/loadGrammar')
require('../utils/compatibleExpect')
{expect} = require('chai')

{
  expectPlainAssignment
  quotedSingleRegexpScope
  quotedDoubleRegexpScope
  heredocRegexpBoundaryScope
  heredocRegexpScope
  nowdocRegexpBoundaryScope
  nowdocRegexpScope
  regexpCharacterClassBoundaryScope
  regexpCharacterClassScope
  regexpCharacterClassScopes
  regexpCharacterClassPunctuationScopes
  regexpCharacterClassBoundaryNegationScopes
  regexpCharacterClassLiteralScopes
  regexpCharacterClassEscapeScopes
  regexpCharacterClassClassEscapeScopes
  regexpCharacterClassInvalidEscapeScopes
  regexpCharacterClassDecodedEscapeTransportScopes
  regexpCharacterClassDecodedInvalidTransportScopes
  regexpCharacterClassDecodedNumericTransportScopes
  regexpCharacterClassPhpEscapeScopes
  regexpCharacterClassPhpHexEscapeScopes
  regexpCharacterClassNumericScopes
  regexpCharacterClassOctalScopes
  regexpCharacterClassRangeScopes
  regexpCharacterClassLetterRangeScopes
  regexpCharacterClassRangeOperatorScopes
  regexpCharacterClassDigitRangeScopes
  regexpCharacterClassGenericRangeScopes
  regexpCharacterClassHexRangeScopes
  regexpCharacterClassPosixScope
  regexpCharacterClassPosixScopes
  regexpGroupScope
  regexpGroupScopes
  regexpGroupContentScopes
  regexpSpecificGroupPunctuationScopes
  regexpGroupNameScopes
  regexpNamedBackreferenceScopes
  regexpNamedBackreferenceNameScopes
  regexpSubroutineScopes
  regexpNamedSubroutineScopes
  regexpNamedSubroutineNameScopes
  regexpDecodedSubroutineTransportScopes
  regexpDecodedNamedSubroutineTransportScopes
  regexpGroupRecursionScopes
  regexpGroupSubroutineScopes
  regexpGroupNamedSubroutineScopes
  regexpInvalidEscapeScopes
  regexpOctalScopes
  regexpDecodedInvalidTransportScopes
  regexpDecodedNumericTransportScopes
  regexpDecodedAnchorTransportScopes
  regexpWrapperBeginQuoteScopes
  regexpWrapperBeginDelimiterScopes
  regexpWrapperEndDelimiterScopes
  regexpWrapperFlagScopes
  regexpWrapperEndQuoteScopes
  regexpWildcardScopes
  regexpControlKeywordScopes
  regexpBacktrackingVerbScopes
  regexpDirectiveScopes
  regexpAssertionGroupScope
  regexpAssertionGroupScopes
  regexpAssertionGroupContentScopes
  regexpSpecificAssertionPunctuationScopes
  regexpConditionalGroupScope
  regexpConditionalGroupScopes
  regexpConditionalGroupContentScopes
  regexpConditionalAssertionConditionScopes
  regexpConditionalAssertionContentScopes
  regexpConditionalAssertionEndScopes
  regexpSpecificConditionalAssertionPunctuationScopes
  regexpConditionalBeginKeywordScopes
  regexpConditionalBeginPunctuationScopes
  regexpConditionalPunctuationScopes
  regexpConditionalKeywordScopes
  expectScopedToken
  expectConditionalGroupTokens
  regexpConditionalRecursionScopes
  regexpConditionalNestedGroupScopes
  regexpCommentGroupScope
  regexpCommentGroupScopes
  regexpQuotedLiteralBoundaryScope
  regexpQuotedLiteralBoundaryScopes
  regexpDecodedQuotedLiteralTransportScopes
  regexpQuotedLiteralContentScopes
  regexpCharacterClassQuotedLiteralBoundaryScopes
  regexpCharacterClassDecodedQuotedLiteralTransportScopes
  regexpCharacterClassQuotedLiteralContentScopes
  regexpRangeQuantifierScopes
  regexpRangeQuantifierBeginScopes
  regexpRangeQuantifierEndScopes
  interpretedTransportBackslashScopes
} = require './php-regexp-helpers'

describe 'PHP quoted regexp grammar', ->
  grammar = null
  before(-> grammar = await loadGrammar('source.php'))

  it 'parses the grammar', ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe 'source.php'

  describe 'quoted regex strings', ->
    it 'should tokenize single quoted string regex escape characters correctly', ->
      {tokens} = grammar.tokenizeLine "'/[\\\\\\\\]/';"

      expect(tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php']
      expect(tokens[4]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(tokens[5]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(tokens[6]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(tokens[7]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)
      expect(tokens[8]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

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

    it 'should tokenize interpolation inside double quoted regex bodies', ->
      {tokens} = grammar.tokenizeLine "\"/($value)/\""

      expect(tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[2]).toEqual value: '(', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(tokens[3]).toEqual value: '$', scopes: regexpGroupContentScopes(quotedDoubleRegexpScope).concat ['variable.other.php', 'punctuation.definition.variable.php']
      expect(tokens[4]).toEqual value: 'value', scopes: regexpGroupContentScopes(quotedDoubleRegexpScope).concat ['variable.other.php']
      expect(tokens[5]).toEqual value: ')', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(tokens[6]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[7]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

    it 'should keep interpolation after interpreted backslash transport in double quoted regex bodies', ->
      [2, 4, 6, 8].forEach (slashes) ->
        expectedBackslashes = interpretedTransportBackslashScopes quotedDoubleRegexpScope, slashes
        {tokens} = grammar.tokenizeLine '"/' + '\\'.repeat(slashes) + '$a/"'

        expect(tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
        expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
        for scopes, i in expectedBackslashes
          expect(tokens[i + 2]).toEqual value: '\\\\', scopes: scopes
        variableIndex = expectedBackslashes.length + 2
        expect(tokens[variableIndex]).toEqual value: '$', scopes: quotedDoubleRegexpScope.concat ['variable.other.php', 'punctuation.definition.variable.php']
        expect(tokens[variableIndex + 1]).toEqual value: 'a', scopes: quotedDoubleRegexpScope.concat ['variable.other.php']
        expect(tokens[variableIndex + 2]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
        expect(tokens[variableIndex + 3]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

    it 'should tokenize interpolation inside double quoted regex character classes', ->
      {tokens} = grammar.tokenizeLine "\"/[{$value}\\d]/\""

      expect(tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(tokens[3]).toEqual value: '{', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.variable.php']
      expect(tokens[4]).toEqual value: '$', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['variable.other.php', 'punctuation.definition.variable.php']
      expect(tokens[5]).toEqual value: 'value', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['variable.other.php']
      expect(tokens[6]).toEqual value: '}', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.variable.php']
      expect(tokens[7]).toEqual value: '\\d', scopes: regexpCharacterClassClassEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[8]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(tokens[9]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[10]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

    it 'should keep interpolation after interpreted backslash transport in double quoted regex character classes', ->
      [2, 4, 6, 8].forEach (slashes) ->
        expectedBackslashes = interpretedTransportBackslashScopes regexpCharacterClassScopes(quotedDoubleRegexpScope), slashes
        {tokens} = grammar.tokenizeLine '"/[' + '\\'.repeat(slashes) + '$a]/"'

        expect(tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
        expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
        expect(tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
        for scopes, i in expectedBackslashes
          expect(tokens[i + 3]).toEqual value: '\\\\', scopes: scopes
        variableIndex = expectedBackslashes.length + 3
        expect(tokens[variableIndex]).toEqual value: '$', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['variable.other.php', 'punctuation.definition.variable.php']
        expect(tokens[variableIndex + 1]).toEqual value: 'a', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['variable.other.php']
        expect(tokens[variableIndex + 2]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
        expect(tokens[variableIndex + 3]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
        expect(tokens[variableIndex + 4]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

    it 'should tokenize rich character class constructs in double quoted regexes', ->
      {tokens} = grammar.tokenizeLine '"/[a-z0-9\\x{4A}-\\x{4f}J[:digit:]\\d\\p{L}\\-\\]]/"'

      expect(tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(tokens[3]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(quotedDoubleRegexpScope)
      expect(tokens[4]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(quotedDoubleRegexpScope)
      expect(tokens[5]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(quotedDoubleRegexpScope)
      expect(tokens[6]).toEqual value: '0', scopes: regexpCharacterClassDigitRangeScopes(quotedDoubleRegexpScope).concat ['constant.numeric.regexp.php']
      expect(tokens[7]).toEqual value: '-', scopes: regexpCharacterClassDigitRangeScopes(quotedDoubleRegexpScope).concat ['keyword.operator.range.regexp.php']
      expect(tokens[8]).toEqual value: '9', scopes: regexpCharacterClassDigitRangeScopes(quotedDoubleRegexpScope).concat ['constant.numeric.regexp.php']
      expect(tokens[9]).toEqual value: '\\x{4A}', scopes: regexpCharacterClassHexRangeScopes(quotedDoubleRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(tokens[10]).toEqual value: '-', scopes: regexpCharacterClassHexRangeScopes(quotedDoubleRegexpScope).concat ['keyword.operator.range.regexp.php']
      expect(tokens[11]).toEqual value: '\\x{4f}', scopes: regexpCharacterClassHexRangeScopes(quotedDoubleRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(tokens[12]).toEqual value: 'J', scopes: regexpCharacterClassLiteralScopes(quotedDoubleRegexpScope)
      expect(tokens[13]).toEqual value: '[:', scopes: regexpCharacterClassPosixScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.character-class.set.begin.regexp.php']
      expect(tokens[14]).toEqual value: 'digit', scopes: regexpCharacterClassPosixScopes(quotedDoubleRegexpScope)
      expect(tokens[15]).toEqual value: ':]', scopes: regexpCharacterClassPosixScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.character-class.set.end.regexp.php']
      expect(tokens[16]).toEqual value: '\\d', scopes: regexpCharacterClassClassEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[17]).toEqual value: '\\p{L}', scopes: regexpCharacterClassClassEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[18]).toEqual value: '\\-', scopes: regexpCharacterClassEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[19]).toEqual value: '\\]', scopes: regexpCharacterClassEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[20]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(tokens[21]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[22]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

    it 'should tokenize raw \\N, \\o, \\p, and \\P as invalid in quoted regex character classes', ->
      quotedHosts = [
        {
          regexScope: quotedDoubleRegexpScope
          line: '"/[\\N\\o\\p\\P]/"'
          quoteValue: '"'
        }
        {
          regexScope: quotedSingleRegexpScope
          line: "'/[\\N\\o\\p\\P]/'"
          quoteValue: '\''
        }
      ]
      expectedEscapes = ['\\N', '\\o', '\\p', '\\P']

      for {regexScope, line, quoteValue} in quotedHosts
        {tokens} = grammar.tokenizeLine line

        expect(tokens[0]).toEqual value: quoteValue, scopes: regexpWrapperBeginQuoteScopes(regexScope)
        expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(regexScope)
        expect(tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
        for value, index in expectedEscapes
          expect(tokens[3 + index]).toEqual value: value, scopes: regexpCharacterClassInvalidEscapeScopes(regexScope)
        expect(tokens[7]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
        expect(tokens[8]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(regexScope)
        expect(tokens[9]).toEqual value: quoteValue, scopes: regexpWrapperEndQuoteScopes(regexScope)

    it 'should tokenize negated character classes in quoted regexes', ->
      doubleQuoted = grammar.tokenizeLine '"/[^0-9]/"'
      singleQuoted = grammar.tokenizeLine "'/[^0-9]/'"

      expect(doubleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: '^', scopes: regexpCharacterClassBoundaryNegationScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[4]).toEqual value: '0', scopes: regexpCharacterClassDigitRangeScopes(quotedDoubleRegexpScope).concat ['constant.numeric.regexp.php']
      expect(doubleQuoted.tokens[5]).toEqual value: '-', scopes: regexpCharacterClassDigitRangeScopes(quotedDoubleRegexpScope).concat ['keyword.operator.range.regexp.php']
      expect(doubleQuoted.tokens[6]).toEqual value: '9', scopes: regexpCharacterClassDigitRangeScopes(quotedDoubleRegexpScope).concat ['constant.numeric.regexp.php']
      expect(doubleQuoted.tokens[7]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[3]).toEqual value: '^', scopes: regexpCharacterClassBoundaryNegationScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[4]).toEqual value: '0', scopes: regexpCharacterClassDigitRangeScopes(quotedSingleRegexpScope).concat ['constant.numeric.regexp.php']
      expect(singleQuoted.tokens[5]).toEqual value: '-', scopes: regexpCharacterClassDigitRangeScopes(quotedSingleRegexpScope).concat ['keyword.operator.range.regexp.php']
      expect(singleQuoted.tokens[6]).toEqual value: '9', scopes: regexpCharacterClassDigitRangeScopes(quotedSingleRegexpScope).concat ['constant.numeric.regexp.php']
      expect(singleQuoted.tokens[7]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)

    it 'should keep PHP string escapes inside double quoted regex character classes', ->
      {tokens} = grammar.tokenizeLine '"/[\\x01-\\x09\\n\\r\\$]/"'

      expect(tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(tokens[3]).toEqual value: '\\x01', scopes: regexpCharacterClassPhpHexEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[4]).toEqual value: '-', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['keyword.operator.range.regexp.php']
      expect(tokens[5]).toEqual value: '\\x09', scopes: regexpCharacterClassPhpHexEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[6]).toEqual value: '\\n', scopes: regexpCharacterClassPhpEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[7]).toEqual value: '\\r', scopes: regexpCharacterClassPhpEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[8]).toEqual value: '\\$', scopes: regexpCharacterClassPhpEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[9]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(tokens[10]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[11]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

    it 'should tokenize decoded overlapping escapes in double quoted regex character classes', ->
      {tokens} = grammar.tokenizeLine '"/[\\\\1\\\\x41\\\\n\\\\v\\\\$]/"'

      expect(tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php', 'constant.numeric.octal.regexp.php']
      expect(tokens[4]).toEqual value: '1', scopes: regexpCharacterClassOctalScopes(quotedDoubleRegexpScope)
      expect(tokens[5]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php', 'constant.character.numeric.regexp.php']
      expect(tokens[6]).toEqual value: 'x41', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(tokens[7]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(tokens[8]).toEqual value: 'n', scopes: regexpCharacterClassEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[9]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(tokens[10]).toEqual value: 'v', scopes: regexpCharacterClassClassEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[11]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(tokens[12]).toEqual value: '$', scopes: regexpCharacterClassEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[13]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(tokens[14]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[15]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

    it 'should keep transported PHP code-point escapes PHP-first in double quoted regex character classes', ->
      {tokens} = grammar.tokenizeLine '"/[' + '\\'.repeat(3) + 'x21' + '\\'.repeat(3) + 'u{21}]/"'

      expect(tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php']
      expect(tokens[4]).toEqual value: '\\x21', scopes: regexpCharacterClassPhpHexEscapeScopes(quotedDoubleRegexpScope)
      expect(tokens[5]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php']
      expect(tokens[6]).toEqual value: '\\u{21}', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.unicode.php']
      expect(tokens[7]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(tokens[8]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[9]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

    it 'should tokenize decoded bell escapes in interpreted quoted regex character classes', ->
      doubleQuoted = grammar.tokenizeLine '"/[\\\\a]/"'
      singleQuoted = grammar.tokenizeLine "'/[\\\\a]/'"

      expect(doubleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[4]).toEqual value: 'a', scopes: regexpCharacterClassEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[5]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[4]).toEqual value: 'a', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[5]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)

    it 'should tokenize decoded \\N, \\o, \\p, and \\P as invalid in quoted regex character classes', ->
      quotedHosts = [
        {
          regexScope: quotedDoubleRegexpScope
          line: '"/[\\\\N\\\\o\\\\p\\\\P]/"'
          quoteValue: '"'
        }
        {
          regexScope: quotedSingleRegexpScope
          line: "'/[\\\\N\\\\o\\\\p\\\\P]/'"
          quoteValue: '\''
        }
      ]
      expectedPayloads = ['N', 'o', 'p', 'P']

      for {regexScope, line, quoteValue} in quotedHosts
        {tokens} = grammar.tokenizeLine line

        expect(tokens[0]).toEqual value: quoteValue, scopes: regexpWrapperBeginQuoteScopes(regexScope)
        expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(regexScope)
        expect(tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
        for value, index in expectedPayloads
          tokenOffset = 3 + index * 2
          expect(tokens[tokenOffset]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedInvalidTransportScopes(regexScope)
          expect(tokens[tokenOffset + 1]).toEqual value: value, scopes: regexpCharacterClassInvalidEscapeScopes(regexScope)
        expect(tokens[11]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
        expect(tokens[12]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(regexScope)
        expect(tokens[13]).toEqual value: quoteValue, scopes: regexpWrapperEndQuoteScopes(regexScope)

    it 'should tokenize decoded character-type escapes in quoted regex character classes', ->
      expectedTypes = ['d', 'D', 'h', 'H', 's', 'S', 'v', 'V', 'w', 'W', 'R']
      doubleQuoted = grammar.tokenizeLine '"/[' + expectedTypes.map((type) -> '\\\\' + type).join('') + ']/"'
      singleQuoted = grammar.tokenizeLine "'/[" + expectedTypes.map((type) -> '\\\\' + type).join('') + "]/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      doubleOffset = 3
      for type in expectedTypes
        expect(doubleQuoted.tokens[doubleOffset]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
        expect(doubleQuoted.tokens[doubleOffset + 1]).toEqual value: type, scopes: regexpCharacterClassClassEscapeScopes(quotedDoubleRegexpScope)
        doubleOffset += 2
      expect(doubleQuoted.tokens[doubleOffset]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[doubleOffset + 1]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[doubleOffset + 2]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      singleOffset = 3
      for type in expectedTypes
        expect(singleQuoted.tokens[singleOffset]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
        expect(singleQuoted.tokens[singleOffset + 1]).toEqual value: type, scopes: regexpCharacterClassClassEscapeScopes(quotedSingleRegexpScope)
        singleOffset += 2
      expect(singleQuoted.tokens[singleOffset]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[singleOffset + 1]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[singleOffset + 2]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should tokenize raw braced octal escapes in quoted regex character classes', ->
      doubleQuoted = grammar.tokenizeLine '"/[\\o{141}]/"'
      singleQuoted = grammar.tokenizeLine "'/[\\o{141}]/'"

      expect(doubleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: '\\o{141}', scopes: regexpCharacterClassOctalScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[4]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[3]).toEqual value: '\\o{141}', scopes: regexpCharacterClassOctalScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[4]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)

    it 'should tokenize decoded property, braced hex, braced octal, and Unicode code point escapes in quoted regex character classes', ->
      doubleQuoted = grammar.tokenizeLine '"/[\\\\pL\\\\PL\\\\p{L}\\\\P{N}\\\\x{41}\\\\o{141}\\\\N{U+41}]/"'
      singleQuoted = grammar.tokenizeLine "'/[\\\\pL\\\\PL\\\\p{L}\\\\P{N}\\\\x{41}\\\\o{141}\\\\N{U+41}]/'"

      expect(doubleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[4]).toEqual value: 'pL', scopes: regexpCharacterClassClassEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[5]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[6]).toEqual value: 'PL', scopes: regexpCharacterClassClassEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[7]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[8]).toEqual value: 'p{L}', scopes: regexpCharacterClassClassEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[9]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[10]).toEqual value: 'P{N}', scopes: regexpCharacterClassClassEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[11]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php', 'constant.character.numeric.regexp.php']
      expect(doubleQuoted.tokens[12]).toEqual value: 'x{41}', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(doubleQuoted.tokens[13]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php', 'constant.numeric.octal.regexp.php']
      expect(doubleQuoted.tokens[14]).toEqual value: 'o{141}', scopes: regexpCharacterClassOctalScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[15]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php', 'constant.character.numeric.regexp.php']
      expect(doubleQuoted.tokens[16]).toEqual value: 'N{U+41}', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(doubleQuoted.tokens[17]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(singleQuoted.tokens[4]).toEqual value: 'pL', scopes: regexpCharacterClassClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[5]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(singleQuoted.tokens[6]).toEqual value: 'PL', scopes: regexpCharacterClassClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[7]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(singleQuoted.tokens[8]).toEqual value: 'p{L}', scopes: regexpCharacterClassClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[9]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(singleQuoted.tokens[10]).toEqual value: 'P{N}', scopes: regexpCharacterClassClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[11]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'constant.character.numeric.regexp.php']
      expect(singleQuoted.tokens[12]).toEqual value: 'x{41}', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(singleQuoted.tokens[13]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'constant.numeric.octal.regexp.php']
      expect(singleQuoted.tokens[14]).toEqual value: 'o{141}', scopes: regexpCharacterClassOctalScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[15]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'constant.character.numeric.regexp.php']
      expect(singleQuoted.tokens[16]).toEqual value: 'N{U+41}', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(singleQuoted.tokens[17]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)

    it 'should tokenize interpreted braced hex ranges in quoted regex character classes', ->
      quotedHosts = [
        {
          regexScope: quotedDoubleRegexpScope
          wrap: (body) -> '"/[' + body + ']/"'
        }
        {
          regexScope: quotedSingleRegexpScope
          wrap: (body) -> "'/[" + body + "]/'"
        }
      ]

      for {regexScope, wrap} in quotedHosts
        rangeScopes = regexpCharacterClassHexRangeScopes(regexScope)
        decodedTransportScopes = rangeScopes.concat ['constant.character.escape.php', 'constant.character.numeric.regexp.php']
        numericRangeScopes = rangeScopes.concat ['constant.character.numeric.regexp.php']
        rangeOperatorScopes = rangeScopes.concat ['keyword.operator.range.regexp.php']

        rawDecoded = grammar.tokenizeLine(wrap '\\x{42}-' + '\\'.repeat(2) + 'x{44}').tokens
        decodedRaw = grammar.tokenizeLine(wrap '\\'.repeat(2) + 'x{42}-\\x{44}').tokens
        decodedBoth = grammar.tokenizeLine(wrap '\\'.repeat(2) + 'x{42}-' + '\\'.repeat(2) + 'x{44}').tokens

        expect(rawDecoded[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
        expect(rawDecoded[3]).toEqual value: '\\x{42}', scopes: numericRangeScopes
        expect(rawDecoded[4]).toEqual value: '-', scopes: rangeOperatorScopes
        expect(rawDecoded[5]).toEqual value: '\\\\', scopes: decodedTransportScopes
        expect(rawDecoded[6]).toEqual value: 'x{44}', scopes: numericRangeScopes
        expect(rawDecoded[7]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)

        expect(decodedRaw[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
        expect(decodedRaw[3]).toEqual value: '\\\\', scopes: decodedTransportScopes
        expect(decodedRaw[4]).toEqual value: 'x{42}', scopes: numericRangeScopes
        expect(decodedRaw[5]).toEqual value: '-', scopes: rangeOperatorScopes
        expect(decodedRaw[6]).toEqual value: '\\x{44}', scopes: numericRangeScopes
        expect(decodedRaw[7]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)

        expect(decodedBoth[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
        expect(decodedBoth[3]).toEqual value: '\\\\', scopes: decodedTransportScopes
        expect(decodedBoth[4]).toEqual value: 'x{42}', scopes: numericRangeScopes
        expect(decodedBoth[5]).toEqual value: '-', scopes: rangeOperatorScopes
        expect(decodedBoth[6]).toEqual value: '\\\\', scopes: decodedTransportScopes
        expect(decodedBoth[7]).toEqual value: 'x{44}', scopes: numericRangeScopes
        expect(decodedBoth[8]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)

    it 'should keep interpolation-like syntax raw in single quoted regex bodies', ->
      {tokens} = grammar.tokenizeLine "'/($value)/'"

      expect(tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(tokens[2]).toEqual value: '(', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(tokens[3]).toEqual value: '$', scopes: regexpGroupContentScopes(quotedSingleRegexpScope).concat ['keyword.control.anchor.regexp.php']
      expect(tokens[4]).toEqual value: 'value', scopes: regexpGroupContentScopes(quotedSingleRegexpScope)
      expect(tokens[5]).toEqual value: ')', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(tokens[6]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(tokens[7]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)
      expect(tokens.some((token) -> 'variable.other.php' in token.scopes)).toBe false

    it 'should keep interpolation-like syntax raw in single quoted regex character classes', ->
      {tokens} = grammar.tokenizeLine "'/[{$value}\\d]/'"

      expect(tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(tokens[3]).toEqual value: '{', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope)
      expect(tokens[4]).toEqual value: '$', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope)
      expect(tokens[5]).toEqual value: 'v', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope)
      expect(tokens[6]).toEqual value: 'a', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope)
      expect(tokens[7]).toEqual value: 'l', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope)
      expect(tokens[8]).toEqual value: 'u', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope)
      expect(tokens[9]).toEqual value: 'e', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope)
      expect(tokens[10]).toEqual value: '}', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope)
      expect(tokens[11]).toEqual value: '\\d', scopes: regexpCharacterClassClassEscapeScopes(quotedSingleRegexpScope)
      expect(tokens[12]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(tokens[13]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(tokens[14]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)
      expect(tokens.some((token) -> 'variable.other.php' in token.scopes)).toBe false

    it 'should tokenize rich character class constructs in single quoted regexes', ->
      {tokens} = grammar.tokenizeLine "'/[a-z0-9\\x{4A}-\\x{4f}J[:digit:]\\d\\p{L}\\-\\]]/'"

      expect(tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(tokens[3]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(quotedSingleRegexpScope)
      expect(tokens[4]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(quotedSingleRegexpScope)
      expect(tokens[5]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(quotedSingleRegexpScope)
      expect(tokens[6]).toEqual value: '0', scopes: regexpCharacterClassDigitRangeScopes(quotedSingleRegexpScope).concat ['constant.numeric.regexp.php']
      expect(tokens[7]).toEqual value: '-', scopes: regexpCharacterClassDigitRangeScopes(quotedSingleRegexpScope).concat ['keyword.operator.range.regexp.php']
      expect(tokens[8]).toEqual value: '9', scopes: regexpCharacterClassDigitRangeScopes(quotedSingleRegexpScope).concat ['constant.numeric.regexp.php']
      expect(tokens[9]).toEqual value: '\\x{4A}', scopes: regexpCharacterClassHexRangeScopes(quotedSingleRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(tokens[10]).toEqual value: '-', scopes: regexpCharacterClassHexRangeScopes(quotedSingleRegexpScope).concat ['keyword.operator.range.regexp.php']
      expect(tokens[11]).toEqual value: '\\x{4f}', scopes: regexpCharacterClassHexRangeScopes(quotedSingleRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(tokens[12]).toEqual value: 'J', scopes: regexpCharacterClassLiteralScopes(quotedSingleRegexpScope)
      expect(tokens[13]).toEqual value: '[:', scopes: regexpCharacterClassPosixScopes(quotedSingleRegexpScope).concat ['punctuation.definition.character-class.set.begin.regexp.php']
      expect(tokens[14]).toEqual value: 'digit', scopes: regexpCharacterClassPosixScopes(quotedSingleRegexpScope)
      expect(tokens[15]).toEqual value: ':]', scopes: regexpCharacterClassPosixScopes(quotedSingleRegexpScope).concat ['punctuation.definition.character-class.set.end.regexp.php']
      expect(tokens[16]).toEqual value: '\\d', scopes: regexpCharacterClassClassEscapeScopes(quotedSingleRegexpScope)
      expect(tokens[17]).toEqual value: '\\p{L}', scopes: regexpCharacterClassClassEscapeScopes(quotedSingleRegexpScope)
      expect(tokens[18]).toEqual value: '\\-', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(tokens[19]).toEqual value: '\\]', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(tokens[20]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(tokens[21]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(tokens[22]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should tokenize raw octal escapes as numeric in single quoted regex character classes', ->
      {tokens} = grammar.tokenizeLine "'/[\\1-\\3]/'"

      expect(tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(tokens[3]).toEqual value: '\\1', scopes: regexpCharacterClassRangeScopes(quotedSingleRegexpScope).concat ['constant.numeric.octal.regexp.php']
      expect(tokens[4]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(quotedSingleRegexpScope)
      expect(tokens[5]).toEqual value: '\\3', scopes: regexpCharacterClassRangeScopes(quotedSingleRegexpScope).concat ['constant.numeric.octal.regexp.php']
      expect(tokens[6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(tokens[7]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(tokens[8]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should tokenize raw octal escapes as octal in single quoted regex character classes', ->
      {tokens} = grammar.tokenizeLine "'/[\\0\\4]/'"

      expect(tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(tokens[3]).toEqual value: '\\0', scopes: regexpCharacterClassOctalScopes(quotedSingleRegexpScope)
      expect(tokens[4]).toEqual value: '\\4', scopes: regexpCharacterClassOctalScopes(quotedSingleRegexpScope)
      expect(tokens[5]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(tokens[6]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(tokens[7]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should tokenize decoded overlapping escapes in single quoted regex character classes', ->
      {tokens} = grammar.tokenizeLine "'/[\\\\1\\\\x41\\\\n\\\\v\\\\$]/'"

      expect(tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'constant.numeric.octal.regexp.php']
      expect(tokens[4]).toEqual value: '1', scopes: regexpCharacterClassOctalScopes(quotedSingleRegexpScope)
      expect(tokens[5]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'constant.character.numeric.regexp.php']
      expect(tokens[6]).toEqual value: 'x41', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(tokens[7]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(tokens[8]).toEqual value: 'n', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(tokens[9]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(tokens[10]).toEqual value: 'v', scopes: regexpCharacterClassClassEscapeScopes(quotedSingleRegexpScope)
      expect(tokens[11]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(tokens[12]).toEqual value: '$', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(tokens[13]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(tokens[14]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(tokens[15]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should tokenize decoded backspace, short hex, and one-digit hex escapes in quoted regex character classes', ->
      doubleQuoted = grammar.tokenizeLine '"/[\\\\b\\\\x\\\\x4Q]/"'
      singleQuoted = grammar.tokenizeLine "'/[\\\\b\\\\x\\\\x4Q]/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedEscapeTransportScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[4]).toEqual value: 'b', scopes: regexpCharacterClassEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[5]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedNumericTransportScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[6]).toEqual value: 'x', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(doubleQuoted.tokens[7]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedNumericTransportScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[8]).toEqual value: 'x4', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(doubleQuoted.tokens[9]).toEqual value: 'Q', scopes: regexpCharacterClassLiteralScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[10]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[11]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[12]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedEscapeTransportScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[4]).toEqual value: 'b', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[5]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedNumericTransportScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[6]).toEqual value: 'x', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(singleQuoted.tokens[7]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedNumericTransportScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[8]).toEqual value: 'x4', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(singleQuoted.tokens[9]).toEqual value: 'Q', scopes: regexpCharacterClassLiteralScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[10]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[11]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[12]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should literalize odd decoded backslashes before x and u in double quoted regex character classes', ->
      for payload in ['x', 'u']
        {tokens} = grammar.tokenizeLine '"/[' + '\\'.repeat(3) + payload + ']/"'

        expect(tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
        expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
        expect(tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
        expect(tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassPhpEscapeScopes(quotedDoubleRegexpScope)
        expect(tokens[4]).toEqual value: '\\', scopes: regexpCharacterClassEscapeScopes(quotedDoubleRegexpScope)
        expect(tokens[5]).toEqual value: payload, scopes: regexpCharacterClassLiteralScopes(quotedDoubleRegexpScope)
        expect(tokens[6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
        expect(tokens[7]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
        expect(tokens[8]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

    it 'should literalize odd decoded backslashes before selected overlap escapes in single quoted regex character classes', ->
      for payload in ['e', 'f', 'n', 'r', 't', 'v', 'x', 'u']
        {tokens} = grammar.tokenizeLine "'/[" + '\\'.repeat(3) + payload + "]/'"

        expect(tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
        expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
        expect(tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
        expect(tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassPhpEscapeScopes(quotedSingleRegexpScope)
        expect(tokens[4]).toEqual value: '\\', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
        expect(tokens[5]).toEqual value: payload, scopes: regexpCharacterClassLiteralScopes(quotedSingleRegexpScope)
        expect(tokens[6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
        expect(tokens[7]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
        expect(tokens[8]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should keep PHP string escapes while adding regex body escapes in double quoted regexes', ->
      {tokens} = grammar.tokenizeLine '"/\\n\\$\\d/"'

      expect(tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[2]).toEqual value: '\\n', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php']
      expect(tokens[3]).toEqual value: '\\$', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'keyword.control.anchor.regexp.php']
      expect(tokens[4]).toEqual value: '\\d', scopes: quotedDoubleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(tokens[5]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[6]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

    it 'should tokenize raw short and one-digit hex escapes and raw 8/9 backreferences in quoted regexes', ->
      doubleShortHex = grammar.tokenizeLine '"/\\x/"'
      singleShortHex = grammar.tokenizeLine "'/\\x/'"
      singlePartialHex = grammar.tokenizeLine "'/\\x1Q600\\x4Q/'"
      doubleBackrefs = grammar.tokenizeLine '"/\\8\\9/"'

      expect(doubleShortHex.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleShortHex.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleShortHex.tokens[2]).toEqual value: '\\x', scopes: quotedDoubleRegexpScope.concat ['constant.character.numeric.regexp.php']
      expect(doubleShortHex.tokens[3]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleShortHex.tokens[4]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleShortHex.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleShortHex.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleShortHex.tokens[2]).toEqual value: '\\x', scopes: quotedSingleRegexpScope.concat ['constant.character.numeric.regexp.php']
      expect(singleShortHex.tokens[3]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleShortHex.tokens[4]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

      expect(singlePartialHex.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singlePartialHex.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singlePartialHex.tokens[2]).toEqual value: '\\x1', scopes: quotedSingleRegexpScope.concat ['constant.character.numeric.regexp.php']
      expect(singlePartialHex.tokens[3]).toEqual value: 'Q600', scopes: quotedSingleRegexpScope
      expect(singlePartialHex.tokens[4]).toEqual value: '\\x4', scopes: quotedSingleRegexpScope.concat ['constant.character.numeric.regexp.php']
      expect(singlePartialHex.tokens[5]).toEqual value: 'Q', scopes: quotedSingleRegexpScope
      expect(singlePartialHex.tokens[6]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singlePartialHex.tokens[7]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

      expect(doubleBackrefs.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleBackrefs.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleBackrefs.tokens[2]).toEqual value: '\\', scopes: quotedDoubleRegexpScope.concat ['keyword.other.back-reference.regexp.php']
      expect(doubleBackrefs.tokens[3]).toEqual value: '8', scopes: quotedDoubleRegexpScope.concat ['keyword.other.back-reference.regexp.php', 'constant.numeric.regexp.php']
      expect(doubleBackrefs.tokens[4]).toEqual value: '\\', scopes: quotedDoubleRegexpScope.concat ['keyword.other.back-reference.regexp.php']
      expect(doubleBackrefs.tokens[5]).toEqual value: '9', scopes: quotedDoubleRegexpScope.concat ['keyword.other.back-reference.regexp.php', 'constant.numeric.regexp.php']
      expect(doubleBackrefs.tokens[6]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleBackrefs.tokens[7]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

    it 'should not let raw \\c consume the regex terminator in quoted regexes', ->
      doubleQuoted = grammar.tokenizeLine '"/\\c/"'
      singleQuoted = grammar.tokenizeLine "'/\\c/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '\\c', scopes: regexpInvalidEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[4]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: '\\c', scopes: regexpInvalidEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[3]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[4]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should tokenize raw body escapes \\C, \\N, and \\X in quoted regexes', ->
      doubleQuoted = grammar.tokenizeLine '"/\\C\\N\\X/"'
      singleQuoted = grammar.tokenizeLine "'/\\C\\N\\X/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '\\C', scopes: quotedDoubleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[3]).toEqual value: '\\N', scopes: quotedDoubleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[4]).toEqual value: '\\X', scopes: quotedDoubleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[5]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[6]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: '\\C', scopes: quotedSingleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(singleQuoted.tokens[3]).toEqual value: '\\N', scopes: quotedSingleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(singleQuoted.tokens[4]).toEqual value: '\\X', scopes: quotedSingleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(singleQuoted.tokens[5]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[6]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should tokenize raw Unicode code point escapes in quoted regexes', ->
      doubleQuoted = grammar.tokenizeLine '"/\\N{U+41}/"'
      singleQuoted = grammar.tokenizeLine "'/\\N{U+41}/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '\\N{U+41}', scopes: quotedDoubleRegexpScope.concat ['constant.character.numeric.regexp.php']
      expect(doubleQuoted.tokens[3]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[4]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: '\\N{U+41}', scopes: quotedSingleRegexpScope.concat ['constant.character.numeric.regexp.php']
      expect(singleQuoted.tokens[3]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[4]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should tokenize raw braced octal escapes in quoted regexes', ->
      doubleQuoted = grammar.tokenizeLine '"/\\o{141}/"'
      singleQuoted = grammar.tokenizeLine "'/\\o{141}/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '\\o{141}', scopes: regexpOctalScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[4]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: '\\o{141}', scopes: regexpOctalScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[3]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[4]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should tokenize raw body escape \\K in quoted regexes', ->
      doubleQuoted = grammar.tokenizeLine '"/\\K/"'
      singleQuoted = grammar.tokenizeLine "'/\\K/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '\\K', scopes: regexpControlKeywordScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[4]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: '\\K', scopes: regexpControlKeywordScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[3]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[4]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should tokenize decoded overlapping escapes in double quoted regexes', ->
      {tokens} = grammar.tokenizeLine '"/\\\\1\\\\x41\\\\n\\\\v\\\\$/"'

      expect(tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[2]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'keyword.other.back-reference.regexp.php']
      expect(tokens[3]).toEqual value: '1', scopes: quotedDoubleRegexpScope.concat ['keyword.other.back-reference.regexp.php', 'constant.numeric.regexp.php']
      expect(tokens[4]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.numeric.regexp.php']
      expect(tokens[5]).toEqual value: 'x41', scopes: quotedDoubleRegexpScope.concat ['constant.character.numeric.regexp.php']
      expect(tokens[6]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(tokens[7]).toEqual value: 'n', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[8]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(tokens[9]).toEqual value: 'v', scopes: quotedDoubleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(tokens[10]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(tokens[11]).toEqual value: '$', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[12]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[13]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

    it 'should not let decoded \\\\c consume the regex terminator in quoted regexes', ->
      doubleQuoted = grammar.tokenizeLine '"/\\\\c/"'
      singleQuoted = grammar.tokenizeLine "'/\\\\c/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: 'c', scopes: regexpInvalidEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[4]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[5]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[3]).toEqual value: 'c', scopes: regexpInvalidEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[4]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[5]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should tokenize decoded body escapes \\\\C, \\\\N, and \\\\X in quoted regexes', ->
      doubleQuoted = grammar.tokenizeLine '"/\\\\C\\\\N\\\\X/"'
      singleQuoted = grammar.tokenizeLine "'/\\\\C\\\\N\\\\X/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[3]).toEqual value: 'C', scopes: quotedDoubleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[4]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[5]).toEqual value: 'N', scopes: quotedDoubleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[6]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[7]).toEqual value: 'X', scopes: quotedDoubleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[8]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[9]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(singleQuoted.tokens[3]).toEqual value: 'C', scopes: quotedSingleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(singleQuoted.tokens[4]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(singleQuoted.tokens[5]).toEqual value: 'N', scopes: quotedSingleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(singleQuoted.tokens[6]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(singleQuoted.tokens[7]).toEqual value: 'X', scopes: quotedSingleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(singleQuoted.tokens[8]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[9]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should tokenize decoded body escape \\\\K in quoted regexes', ->
      doubleQuoted = grammar.tokenizeLine '"/\\\\K/"'
      singleQuoted = grammar.tokenizeLine "'/\\\\K/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php']
      expect(doubleQuoted.tokens[3]).toEqual value: 'K', scopes: regexpControlKeywordScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[4]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[5]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php']
      expect(singleQuoted.tokens[3]).toEqual value: 'K', scopes: regexpControlKeywordScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[4]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[5]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should keep transported PHP code-point escapes PHP-first in double quoted regex bodies', ->
      {tokens} = grammar.tokenizeLine '"/' + '\\'.repeat(3) + 'x21' + '\\'.repeat(3) + 'u{21}/"'

      expect(tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[2]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php']
      expect(tokens[3]).toEqual value: '\\x21', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.hex.php']
      expect(tokens[4]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php']
      expect(tokens[5]).toEqual value: '\\u{21}', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.unicode.php']
      expect(tokens[6]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[7]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

    it 'should keep transported PHP octal and simple escapes PHP-first in double quoted regex bodies', ->
      {tokens} = grammar.tokenizeLine '"/' + '\\'.repeat(3) + '1' + '\\'.repeat(3) + 'n' + '\\'.repeat(3) + 'v' + '\\'.repeat(3) + '$/"'

      expect(tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[2]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php']
      expect(tokens[3]).toEqual value: '\\1', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.octal.php']
      expect(tokens[4]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php']
      expect(tokens[5]).toEqual value: '\\n', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php']
      expect(tokens[6]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php']
      expect(tokens[7]).toEqual value: '\\v', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php']
      expect(tokens[8]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php']
      expect(tokens[9]).toEqual value: '\\$', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php']
      expect(tokens[10]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[11]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

    it 'should tokenize decoded octal zero in double quoted regex bodies', ->
      {tokens} = grammar.tokenizeLine '"/\\\\0/"'

      expect(tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[2]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.numeric.octal.regexp.php']
      expect(tokens[3]).toEqual value: '0', scopes: regexpOctalScopes(quotedDoubleRegexpScope)
      expect(tokens[4]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[5]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

    it 'should tokenize decoded bell escapes in interpreted quoted regexes', ->
      doubleQuoted = grammar.tokenizeLine '"/\\\\a/"'
      singleQuoted = grammar.tokenizeLine "'/\\\\a/'"

      expect(doubleQuoted.tokens[2]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[3]).toEqual value: 'a', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']

      expect(singleQuoted.tokens[2]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[3]).toEqual value: 'a', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']

    it 'should tokenize decoded character-type escapes in quoted regexes', ->
      expectedTypes = ['d', 'D', 'h', 'H', 's', 'S', 'v', 'V', 'w', 'W', 'R']
      doubleQuoted = grammar.tokenizeLine '"/' + expectedTypes.map((type) -> '\\\\' + type).join('') + '/"'
      singleQuoted = grammar.tokenizeLine "'/" + expectedTypes.map((type) -> '\\\\' + type).join('') + "/'"

      doubleOffset = 2
      for type in expectedTypes
        expect(doubleQuoted.tokens[doubleOffset]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
        expect(doubleQuoted.tokens[doubleOffset + 1]).toEqual value: type, scopes: quotedDoubleRegexpScope.concat ['constant.character.class.regexp.php']
        doubleOffset += 2

      singleOffset = 2
      for type in expectedTypes
        expect(singleQuoted.tokens[singleOffset]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
        expect(singleQuoted.tokens[singleOffset + 1]).toEqual value: type, scopes: quotedSingleRegexpScope.concat ['constant.character.class.regexp.php']
        singleOffset += 2

    it 'should tokenize decoded property, braced hex, braced octal, and Unicode code point escapes in quoted regexes', ->
      doubleQuoted = grammar.tokenizeLine '"/\\\\pL\\\\PL\\\\p{L}\\\\P{N}\\\\x{41}\\\\o{141}\\\\N{U+41}/"'
      singleQuoted = grammar.tokenizeLine "'/\\\\pL\\\\PL\\\\p{L}\\\\P{N}\\\\x{41}\\\\o{141}\\\\N{U+41}/'"

      expect(doubleQuoted.tokens[2]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[3]).toEqual value: 'pL', scopes: quotedDoubleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[4]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[5]).toEqual value: 'PL', scopes: quotedDoubleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[6]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[7]).toEqual value: 'p{L}', scopes: quotedDoubleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[8]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[9]).toEqual value: 'P{N}', scopes: quotedDoubleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[10]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.numeric.regexp.php']
      expect(doubleQuoted.tokens[11]).toEqual value: 'x{41}', scopes: quotedDoubleRegexpScope.concat ['constant.character.numeric.regexp.php']
      expect(doubleQuoted.tokens[12]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.numeric.octal.regexp.php']
      expect(doubleQuoted.tokens[13]).toEqual value: 'o{141}', scopes: regexpOctalScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[14]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.numeric.regexp.php']
      expect(doubleQuoted.tokens[15]).toEqual value: 'N{U+41}', scopes: quotedDoubleRegexpScope.concat ['constant.character.numeric.regexp.php']

      expect(singleQuoted.tokens[2]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(singleQuoted.tokens[3]).toEqual value: 'pL', scopes: quotedSingleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(singleQuoted.tokens[4]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(singleQuoted.tokens[5]).toEqual value: 'PL', scopes: quotedSingleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(singleQuoted.tokens[6]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(singleQuoted.tokens[7]).toEqual value: 'p{L}', scopes: quotedSingleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(singleQuoted.tokens[8]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(singleQuoted.tokens[9]).toEqual value: 'P{N}', scopes: quotedSingleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(singleQuoted.tokens[10]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.numeric.regexp.php']
      expect(singleQuoted.tokens[11]).toEqual value: 'x{41}', scopes: quotedSingleRegexpScope.concat ['constant.character.numeric.regexp.php']
      expect(singleQuoted.tokens[12]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.numeric.octal.regexp.php']
      expect(singleQuoted.tokens[13]).toEqual value: 'o{141}', scopes: regexpOctalScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[14]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.numeric.regexp.php']
      expect(singleQuoted.tokens[15]).toEqual value: 'N{U+41}', scopes: quotedSingleRegexpScope.concat ['constant.character.numeric.regexp.php']

    it 'should tokenize decoded overlapping escapes in single quoted regexes', ->
      {tokens} = grammar.tokenizeLine "'/\\\\1\\\\x41\\\\n\\\\v\\\\$/'"

      expect(tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(tokens[2]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'keyword.other.back-reference.regexp.php']
      expect(tokens[3]).toEqual value: '1', scopes: quotedSingleRegexpScope.concat ['keyword.other.back-reference.regexp.php', 'constant.numeric.regexp.php']
      expect(tokens[4]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.numeric.regexp.php']
      expect(tokens[5]).toEqual value: 'x41', scopes: quotedSingleRegexpScope.concat ['constant.character.numeric.regexp.php']
      expect(tokens[6]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(tokens[7]).toEqual value: 'n', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[8]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(tokens[9]).toEqual value: 'v', scopes: quotedSingleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(tokens[10]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(tokens[11]).toEqual value: '$', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[12]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(tokens[13]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should tokenize decoded anchors and short hex escapes in quoted regexes', ->
      doubleQuoted = grammar.tokenizeLine '"/\\\\b\\\\x\\\\z/"'
      singleQuoted = grammar.tokenizeLine "'/\\\\A\\\\B\\\\G\\\\Z\\\\x/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '\\\\', scopes: regexpDecodedAnchorTransportScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: 'b', scopes: quotedDoubleRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(doubleQuoted.tokens[4]).toEqual value: '\\\\', scopes: regexpDecodedNumericTransportScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[5]).toEqual value: 'x', scopes: quotedDoubleRegexpScope.concat ['constant.character.numeric.regexp.php']
      expect(doubleQuoted.tokens[6]).toEqual value: '\\\\', scopes: regexpDecodedAnchorTransportScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[7]).toEqual value: 'z', scopes: quotedDoubleRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(doubleQuoted.tokens[8]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[9]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: '\\\\', scopes: regexpDecodedAnchorTransportScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[3]).toEqual value: 'A', scopes: quotedSingleRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(singleQuoted.tokens[4]).toEqual value: '\\\\', scopes: regexpDecodedAnchorTransportScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[5]).toEqual value: 'B', scopes: quotedSingleRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(singleQuoted.tokens[6]).toEqual value: '\\\\', scopes: regexpDecodedAnchorTransportScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[7]).toEqual value: 'G', scopes: quotedSingleRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(singleQuoted.tokens[8]).toEqual value: '\\\\', scopes: regexpDecodedAnchorTransportScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[9]).toEqual value: 'Z', scopes: quotedSingleRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(singleQuoted.tokens[10]).toEqual value: '\\\\', scopes: regexpDecodedNumericTransportScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[11]).toEqual value: 'x', scopes: quotedSingleRegexpScope.concat ['constant.character.numeric.regexp.php']
      expect(singleQuoted.tokens[12]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[13]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should tokenize decoded one-digit hex escapes in quoted regexes', ->
      doubleQuoted = grammar.tokenizeLine '"/\\\\x4Q/"'
      singleQuoted = grammar.tokenizeLine "'/\\\\x1Q600/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '\\\\', scopes: regexpDecodedNumericTransportScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: 'x4', scopes: quotedDoubleRegexpScope.concat ['constant.character.numeric.regexp.php']
      expect(doubleQuoted.tokens[4]).toEqual value: 'Q', scopes: quotedDoubleRegexpScope
      expect(doubleQuoted.tokens[5]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[6]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: '\\\\', scopes: regexpDecodedNumericTransportScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[3]).toEqual value: 'x1', scopes: quotedSingleRegexpScope.concat ['constant.character.numeric.regexp.php']
      expect(singleQuoted.tokens[4]).toEqual value: 'Q600', scopes: quotedSingleRegexpScope
      expect(singleQuoted.tokens[5]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[6]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should tokenize raw regex-native escapes in single quoted regexes', ->
      {tokens} = grammar.tokenizeLine "'/\\a\\cA\\c;\\n\\r\\t\\f\\e\\/\\+\\*\\?\\|\\-\\#\\(\\)/'"

      expect(tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(tokens[2]).toEqual value: '\\a', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[3]).toEqual value: '\\cA', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[4]).toEqual value: '\\c;', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[5]).toEqual value: '\\n', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[6]).toEqual value: '\\r', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[7]).toEqual value: '\\t', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[8]).toEqual value: '\\f', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[9]).toEqual value: '\\e', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[10]).toEqual value: '\\/', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[11]).toEqual value: '\\+', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[12]).toEqual value: '\\*', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[13]).toEqual value: '\\?', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[14]).toEqual value: '\\|', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[15]).toEqual value: '\\-', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[16]).toEqual value: '\\#', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[17]).toEqual value: '\\(', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[18]).toEqual value: '\\)', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[19]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(tokens[20]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should keep escaped dots and anchors distinct after interpreted backslash transport in double quoted regexes', ->
      {tokens} = grammar.tokenizeLine '"/\\\\.$/"'

      expect(tokens[2]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(tokens[3]).toEqual value: '.', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[4]).toEqual value: '$', scopes: quotedDoubleRegexpScope.concat ['keyword.control.anchor.regexp.php']

    it 'should tokenize raw octal escapes in single quoted regexes', ->
      {tokens} = grammar.tokenizeLine "'/\\0\\00\\000\\o{141}/'"

      expect(tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(tokens[2]).toEqual value: '\\0', scopes: regexpOctalScopes(quotedSingleRegexpScope)
      expect(tokens[3]).toEqual value: '\\00', scopes: regexpOctalScopes(quotedSingleRegexpScope)
      expect(tokens[4]).toEqual value: '\\000', scopes: regexpOctalScopes(quotedSingleRegexpScope)
      expect(tokens[5]).toEqual value: '\\o{141}', scopes: regexpOctalScopes(quotedSingleRegexpScope)
      expect(tokens[6]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(tokens[7]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should tokenize supported non-state-changing operator escapes in quoted regexes from fixtures', ->
      supportedEscapedOperators = ['.', '*', '+', '?', '^', '|']
      quotedHosts = [
        {
          quoteValue: '"'
          regexScope: quotedDoubleRegexpScope
          wrap: (body) -> '"/' + body + '/"'
        }
        {
          quoteValue: '\''
          regexScope: quotedSingleRegexpScope
          wrap: (body) -> "'/" + body + "/'"
        }
      ]

      for {quoteValue, regexScope, wrap} in quotedHosts
        for symbol in supportedEscapedOperators
          raw = grammar.tokenizeLine wrap '\\' + symbol
          decoded = grammar.tokenizeLine wrap '\\'.repeat(2) + symbol

          expect(raw.tokens[0]).toEqual value: quoteValue, scopes: regexpWrapperBeginQuoteScopes(regexScope)
          expect(raw.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(regexScope)
          expect(raw.tokens[2]).toEqual value: '\\' + symbol, scopes: regexScope.concat ['constant.character.escape.regexp.php']
          expect(raw.tokens[3]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(regexScope)
          expect(raw.tokens[4]).toEqual value: quoteValue, scopes: regexpWrapperEndQuoteScopes(regexScope)

          expect(decoded.tokens[0]).toEqual value: quoteValue, scopes: regexpWrapperBeginQuoteScopes(regexScope)
          expect(decoded.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(regexScope)
          expect(decoded.tokens[2]).toEqual value: '\\\\', scopes: regexScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
          expect(decoded.tokens[3]).toEqual value: symbol, scopes: regexScope.concat ['constant.character.escape.regexp.php']
          expect(decoded.tokens[4]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(regexScope)
          expect(decoded.tokens[5]).toEqual value: quoteValue, scopes: regexpWrapperEndQuoteScopes(regexScope)

    it 'should tokenize apostrophe escapes according to quoted PHP host rules', ->
      # Build the PHP strings from pieces so apostrophe transport stays readable and exact.
      doubleQuotedRaw = grammar.tokenizeLine "\"/" + "\\'" + "/\""
      doubleQuotedDecoded = grammar.tokenizeLine "\"/" + "\\\\" + "'" + "/\""
      singleQuotedRaw = grammar.tokenizeLine "'/" + "\\'" + "/'"

      expect(doubleQuotedRaw.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuotedRaw.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuotedRaw.tokens[2]).toEqual value: '\\\'', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(doubleQuotedRaw.tokens[3]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuotedRaw.tokens[4]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(doubleQuotedDecoded.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuotedDecoded.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuotedDecoded.tokens[2]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(doubleQuotedDecoded.tokens[3]).toEqual value: '\'', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(doubleQuotedDecoded.tokens[4]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuotedDecoded.tokens[5]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuotedRaw.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuotedRaw.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuotedRaw.tokens[2]).toEqual value: '\\\'', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php']
      expect(singleQuotedRaw.tokens[3]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuotedRaw.tokens[4]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should keep PHP-escaped quotes after interpreted transport in quoted regex bodies', ->
      doubleQuotedDecoded = grammar.tokenizeLine "\"/" + "\\\\" + "\\\"" + "/\""
      singleQuotedDecoded = grammar.tokenizeLine "'/" + "\\\\" + "\\'" + "/'"

      expect(doubleQuotedDecoded.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuotedDecoded.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuotedDecoded.tokens[2]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(doubleQuotedDecoded.tokens[3]).toEqual value: '\\"', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php']
      expect(doubleQuotedDecoded.tokens[4]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuotedDecoded.tokens[5]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuotedDecoded.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuotedDecoded.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuotedDecoded.tokens[2]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(singleQuotedDecoded.tokens[3]).toEqual value: '\\\'', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php']
      expect(singleQuotedDecoded.tokens[4]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuotedDecoded.tokens[5]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should tokenize opposite-quote regex escapes in quoted regex bodies', ->
      doubleQuoted = grammar.tokenizeLine ['"/', '\\'.repeat(2), "'", '/"'].join ''
      singleQuotedRaw = grammar.tokenizeLine ["'/", '\\', '"', "/'"].join ''
      singleQuotedDecoded = grammar.tokenizeLine ["'/", '\\'.repeat(2), '"', "/'"].join ''

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[3]).toEqual value: '\'', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[4]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[5]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuotedRaw.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuotedRaw.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuotedRaw.tokens[2]).toEqual value: '\\"', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(singleQuotedRaw.tokens[3]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuotedRaw.tokens[4]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

      expect(singleQuotedDecoded.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuotedDecoded.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuotedDecoded.tokens[2]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(singleQuotedDecoded.tokens[3]).toEqual value: '"', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(singleQuotedDecoded.tokens[4]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuotedDecoded.tokens[5]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should decompose repeated interpreted backslashes inside quoted regex character classes', ->
      fourBackslashes = '\\'.repeat 4
      doubleQuoted = grammar.tokenizeLine '"/[' + fourBackslashes + 'a-z]/"'
      singleQuoted = grammar.tokenizeLine "'/[" + fourBackslashes + "a-z]/'"

      expect(doubleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php']
      expect(doubleQuoted.tokens[4]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[5]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php']
      expect(singleQuoted.tokens[4]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[5]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(quotedSingleRegexpScope)

    it 'should keep PHP-escaped quotes in quoted regex character classes after interpreted transport', ->
      doubleQuotedDecoded = grammar.tokenizeLine "\"/[" + "\\\\" + "\\\"" + "a-z]/\""
      singleQuotedRaw = grammar.tokenizeLine "'/[" + "\\'" + "a-z]/'"
      singleQuotedDecoded = grammar.tokenizeLine "'/[" + "\\\\" + "\\'" + "a-z]/'"

      expect(doubleQuotedDecoded.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(doubleQuotedDecoded.tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(doubleQuotedDecoded.tokens[4]).toEqual value: '\\"', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php']
      expect(doubleQuotedDecoded.tokens[5]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(quotedDoubleRegexpScope)
      expect(doubleQuotedDecoded.tokens[6]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(quotedDoubleRegexpScope)
      expect(doubleQuotedDecoded.tokens[7]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(quotedDoubleRegexpScope)

      expect(singleQuotedRaw.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(singleQuotedRaw.tokens[3]).toEqual value: '\\\'', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php']
      expect(singleQuotedRaw.tokens[4]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(quotedSingleRegexpScope)
      expect(singleQuotedRaw.tokens[5]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(quotedSingleRegexpScope)
      expect(singleQuotedRaw.tokens[6]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(quotedSingleRegexpScope)

      expect(singleQuotedDecoded.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(singleQuotedDecoded.tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(singleQuotedDecoded.tokens[4]).toEqual value: '\\\'', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php']
      expect(singleQuotedDecoded.tokens[5]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(quotedSingleRegexpScope)
      expect(singleQuotedDecoded.tokens[6]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(quotedSingleRegexpScope)
      expect(singleQuotedDecoded.tokens[7]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(quotedSingleRegexpScope)

    it 'should tokenize opposite-quote regex escapes in quoted regex character classes', ->
      doubleQuoted = grammar.tokenizeLine ['"/[', '\\'.repeat(2), "'", 'a-z]/"'].join ''
      singleQuotedRaw = grammar.tokenizeLine ["'/[", '\\', '"', "a-z]/'"].join ''
      singleQuotedDecoded = grammar.tokenizeLine ["'/[", '\\'.repeat(2), '"', "a-z]/'"].join ''

      expect(doubleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[4]).toEqual value: '\'', scopes: regexpCharacterClassEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[5]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[6]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[7]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(quotedDoubleRegexpScope)

      expect(singleQuotedRaw.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(singleQuotedRaw.tokens[3]).toEqual value: '\\"', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuotedRaw.tokens[4]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(quotedSingleRegexpScope)
      expect(singleQuotedRaw.tokens[5]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(quotedSingleRegexpScope)
      expect(singleQuotedRaw.tokens[6]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(quotedSingleRegexpScope)

      expect(singleQuotedDecoded.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(singleQuotedDecoded.tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(singleQuotedDecoded.tokens[4]).toEqual value: '"', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuotedDecoded.tokens[5]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(quotedSingleRegexpScope)
      expect(singleQuotedDecoded.tokens[6]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(quotedSingleRegexpScope)
      expect(singleQuotedDecoded.tokens[7]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(quotedSingleRegexpScope)

    it 'should keep same-host quotes after even interpreted parity out of quoted regex mode in quoted regex character classes', ->
      singleQuotedSameQuote = grammar.tokenizeLine ["'/[", '\\'.repeat(4), "'", "a-z]/'"].join ''
      doubleQuotedSameQuote = grammar.tokenizeLine ['"/[', '\\'.repeat(4), '"', 'a-z]/"'].join ''

      expect(singleQuotedSameQuote.tokens[1]).toEqual value: '/[', scopes: ['source.php', 'string.quoted.single.php']
      expect(singleQuotedSameQuote.tokens[2]).toEqual value: '\\\\', scopes: ['source.php', 'string.quoted.single.php', 'constant.character.escape.php']
      expect(singleQuotedSameQuote.tokens[3]).toEqual value: '\\\\', scopes: ['source.php', 'string.quoted.single.php', 'constant.character.escape.php']
      expect(singleQuotedSameQuote.tokens[4]).toEqual value: '\'', scopes: ['source.php', 'string.quoted.single.php', 'punctuation.definition.string.end.php']
      expect(singleQuotedSameQuote.tokens[1].scopes).not.toContain 'meta.embedded.regexp.php'

      expect(doubleQuotedSameQuote.tokens[1]).toEqual value: '/[', scopes: ['source.php', 'string.quoted.double.php']
      expect(doubleQuotedSameQuote.tokens[2]).toEqual value: '\\\\', scopes: ['source.php', 'string.quoted.double.php', 'constant.character.escape.php']
      expect(doubleQuotedSameQuote.tokens[3]).toEqual value: '\\\\', scopes: ['source.php', 'string.quoted.double.php', 'constant.character.escape.php']
      expect(doubleQuotedSameQuote.tokens[4]).toEqual value: '"', scopes: ['source.php', 'string.quoted.double.php', 'punctuation.definition.string.end.php']
      expect(doubleQuotedSameQuote.tokens[1].scopes).not.toContain 'meta.embedded.regexp.php'

    it 'should keep opposite-host quotes inside quoted regex character classes after even interpreted parity', ->
      singleQuotedOppositeQuote = grammar.tokenizeLine ["'/[", '\\'.repeat(4), '"', "a-z]/'"].join ''
      doubleQuotedOppositeQuote = grammar.tokenizeLine ['"/[', '\\'.repeat(4), "'", 'a-z]/"'].join ''

      expect(singleQuotedOppositeQuote.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(singleQuotedOppositeQuote.tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php']
      expect(singleQuotedOppositeQuote.tokens[4]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(singleQuotedOppositeQuote.tokens[5]).toEqual value: '"', scopes: regexpCharacterClassLiteralScopes(quotedSingleRegexpScope)
      expect(singleQuotedOppositeQuote.tokens[6]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(quotedSingleRegexpScope)

      expect(doubleQuotedOppositeQuote.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(doubleQuotedOppositeQuote.tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php']
      expect(doubleQuotedOppositeQuote.tokens[4]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(doubleQuotedOppositeQuote.tokens[5]).toEqual value: '\'', scopes: regexpCharacterClassLiteralScopes(quotedDoubleRegexpScope)
      expect(doubleQuotedOppositeQuote.tokens[6]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(quotedDoubleRegexpScope)

    it 'should keep longer quote parity consistent in quoted regex character classes', ->
      singleQuotedSameQuote = grammar.tokenizeLine ["'/[", '\\'.repeat(6), "'", "a-z]/'"].join ''
      singleQuotedOppositeQuote = grammar.tokenizeLine ["'/[", '\\'.repeat(6), '"', "a-z]/'"].join ''
      doubleQuotedSameQuote = grammar.tokenizeLine ['"/[', '\\'.repeat(6), '"', 'a-z]/"'].join ''
      doubleQuotedOppositeQuote = grammar.tokenizeLine ['"/[', '\\'.repeat(6), "'", 'a-z]/"'].join ''

      expect(singleQuotedSameQuote.tokens[1]).toEqual value: '/[', scopes: ['source.php', 'string.quoted.single.php']
      expect(singleQuotedSameQuote.tokens[2]).toEqual value: '\\\\', scopes: ['source.php', 'string.quoted.single.php', 'constant.character.escape.php']
      expect(singleQuotedSameQuote.tokens[3]).toEqual value: '\\\\', scopes: ['source.php', 'string.quoted.single.php', 'constant.character.escape.php']
      expect(singleQuotedSameQuote.tokens[4]).toEqual value: '\\\\', scopes: ['source.php', 'string.quoted.single.php', 'constant.character.escape.php']
      expect(singleQuotedSameQuote.tokens[5]).toEqual value: '\'', scopes: ['source.php', 'string.quoted.single.php', 'punctuation.definition.string.end.php']
      expect(singleQuotedSameQuote.tokens[1].scopes).not.toContain 'meta.embedded.regexp.php'

      expect(singleQuotedOppositeQuote.tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php']
      expect(singleQuotedOppositeQuote.tokens[4]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(singleQuotedOppositeQuote.tokens[5]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(singleQuotedOppositeQuote.tokens[6]).toEqual value: '"', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuotedOppositeQuote.tokens[7]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(quotedSingleRegexpScope)

      expect(doubleQuotedSameQuote.tokens[1]).toEqual value: '/[', scopes: ['source.php', 'string.quoted.double.php']
      expect(doubleQuotedSameQuote.tokens[2]).toEqual value: '\\\\', scopes: ['source.php', 'string.quoted.double.php', 'constant.character.escape.php']
      expect(doubleQuotedSameQuote.tokens[3]).toEqual value: '\\\\', scopes: ['source.php', 'string.quoted.double.php', 'constant.character.escape.php']
      expect(doubleQuotedSameQuote.tokens[4]).toEqual value: '\\\\', scopes: ['source.php', 'string.quoted.double.php', 'constant.character.escape.php']
      expect(doubleQuotedSameQuote.tokens[5]).toEqual value: '"', scopes: ['source.php', 'string.quoted.double.php', 'punctuation.definition.string.end.php']
      expect(doubleQuotedSameQuote.tokens[1].scopes).not.toContain 'meta.embedded.regexp.php'

      expect(doubleQuotedOppositeQuote.tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php']
      expect(doubleQuotedOppositeQuote.tokens[4]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(doubleQuotedOppositeQuote.tokens[5]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(doubleQuotedOppositeQuote.tokens[6]).toEqual value: '\'', scopes: regexpCharacterClassEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuotedOppositeQuote.tokens[7]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(quotedDoubleRegexpScope)

    it 'should keep quoted regex character-class closing bracket parity consistent from fixtures', ->
      quotedHosts = [
        {
          regexScope: quotedDoubleRegexpScope
          wrap: (body) -> '"/[' + body + '/"'
        }
        {
          regexScope: quotedSingleRegexpScope
          wrap: (body) -> "'/[" + body + "/'"
        }
      ]
      closingBracketCases = [
        {
          caseBody: '\\'.repeat(3) + 'a-z]a-z]'
          assertCase: (tokens, regexScope) ->
            expect(tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
            expect(tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(regexScope).concat ['constant.character.escape.php']
            expect(tokens[4]).toEqual value: '\\', scopes: regexpCharacterClassEscapeScopes(regexScope)
            expect(tokens[5]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(regexScope)
            expect(tokens[8]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
            expect(tokens[9]).toEqual value: 'a-z]', scopes: regexScope
        }
        {
          caseBody: '\\'.repeat(3) + 'a-z\\]a-z]'
          assertCase: (tokens, regexScope) ->
            expect(tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
            expect(tokens[8]).toEqual value: '\\]', scopes: regexpCharacterClassEscapeScopes(regexScope)
            expect(tokens[9]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(regexScope)
            expect(tokens[12]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
        }
        {
          caseBody: '\\'.repeat(3) + 'a-z' + '\\'.repeat(2) + ']a-z]'
          assertCase: (tokens, regexScope) ->
            expect(tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
            expect(tokens[8]).toEqual value: '\\\\', scopes: regexpCharacterClassPhpEscapeScopes(regexScope).concat ['constant.character.escape.regexp.php']
            expect(tokens[9]).toEqual value: ']', scopes: regexpCharacterClassEscapeScopes(regexScope)
            expect(tokens[10]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(regexScope)
            expect(tokens[13]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
        }
      ]

      for {regexScope, wrap} in quotedHosts
        for {caseBody, assertCase} in closingBracketCases
          tokens = grammar.tokenizeLine(wrap(caseBody)).tokens
          assertCase tokens, regexScope

    it 'should literalize basic single-quoted payloads after odd interpreted backslash parity in quoted regex character classes', ->
      payloads = ['e', 'f', 'n', 'r', 't', 'v']

      for slashCount in [3, 7]
        for payload in payloads
          {tokens} = grammar.tokenizeLine "'/[a" + '\\'.repeat(slashCount) + payload + "]/'"
          payloadIndex = tokens.findIndex (token) -> token.value is payload

          expect(tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
          expect(tokens[3]).toEqual value: 'a', scopes: regexpCharacterClassLiteralScopes(quotedSingleRegexpScope)
          expect(tokens.some((token) -> token.value is '\\' + payload)).toBe false
          expect(payloadIndex).to.be.greaterThan 4
          expect(tokens[payloadIndex - 1]).toEqual value: '\\', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
          expect(tokens[payloadIndex]).toEqual value: payload, scopes: regexpCharacterClassLiteralScopes(quotedSingleRegexpScope)
          expect(tokens[payloadIndex + 1]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
          expect(tokens[tokens.length - 2]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
          expect(tokens[tokens.length - 1]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should stop unclosed angle named groups at the quoted wrapper boundary', ->
      for [tokens, baseScope, quoteValue] in [
        [grammar.tokenizeLine('"/a(?<word>foo/"').tokens, quotedDoubleRegexpScope, '"']
        [grammar.tokenizeLine("'/a(?<word>foo/'").tokens, quotedSingleRegexpScope, '\'']
      ]
        expect(tokens[0]).toEqual value: quoteValue, scopes: regexpWrapperBeginQuoteScopes(baseScope)
        expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(baseScope)
        expect(tokens[2]).toEqual value: 'a', scopes: baseScope
        expect(tokens[3]).toEqual value: '(', scopes: regexpGroupScopes(baseScope).concat ['punctuation.definition.group.regexp.php']
        expect(tokens[4]).toEqual value: '?<', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(baseScope), 'punctuation.definition.group.capture.begin.regexp.php')
        expect(tokens[5]).toEqual value: 'word', scopes: regexpGroupNameScopes(regexpGroupScopes(baseScope))
        expect(tokens[6]).toEqual value: '>', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(baseScope), 'punctuation.definition.group.capture.end.regexp.php')
        expect(tokens[7]).toEqual value: 'foo', scopes: regexpGroupContentScopes(baseScope)
        expect(tokens[8]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(baseScope)
        expect(tokens[9]).toEqual value: quoteValue, scopes: regexpWrapperEndQuoteScopes(baseScope)

    it 'should stop unclosed apostrophe-delimited named groups at the quoted wrapper boundary', ->
      doubleQuoted = grammar.tokenizeLine "\"/a(?'word'foo/\""
      singleQuoted = grammar.tokenizeLine "'/a(?\\'word\\'foo/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: 'a', scopes: quotedDoubleRegexpScope
      expect(doubleQuoted.tokens[3]).toEqual value: '(', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(doubleQuoted.tokens[4]).toEqual value: '?\'', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(quotedDoubleRegexpScope), 'punctuation.definition.group.capture.begin.regexp.php')
      expect(doubleQuoted.tokens[5]).toEqual value: 'word', scopes: regexpGroupNameScopes(regexpGroupScopes(quotedDoubleRegexpScope))
      expect(doubleQuoted.tokens[6]).toEqual value: '\'', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(quotedDoubleRegexpScope), 'punctuation.definition.group.capture.end.regexp.php')
      expect(doubleQuoted.tokens[7]).toEqual value: 'foo', scopes: regexpGroupContentScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[8]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[9]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: 'a', scopes: quotedSingleRegexpScope
      expect(singleQuoted.tokens[3]).toEqual value: '(', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(singleQuoted.tokens[4]).toEqual value: '?', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(quotedSingleRegexpScope), 'punctuation.definition.group.capture.begin.regexp.php')
      expect(singleQuoted.tokens[5]).toEqual value: '\\\'', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'punctuation.definition.group.capture.begin.regexp.php']
      expect(singleQuoted.tokens[6]).toEqual value: 'word', scopes: regexpGroupNameScopes(regexpGroupScopes(quotedSingleRegexpScope))
      expect(singleQuoted.tokens[7]).toEqual value: '\\\'', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'punctuation.definition.group.capture.end.regexp.php']
      expect(singleQuoted.tokens[8]).toEqual value: 'foo', scopes: regexpGroupContentScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[9]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[10]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should stop unclosed PCRE named groups at the quoted wrapper boundary', ->
      for [tokens, baseScope, quoteValue] in [
        [grammar.tokenizeLine('"/a(?P<word>foo/"').tokens, quotedDoubleRegexpScope, '"']
        [grammar.tokenizeLine("'/a(?P<word>foo/'").tokens, quotedSingleRegexpScope, '\'']
      ]
        expect(tokens[0]).toEqual value: quoteValue, scopes: regexpWrapperBeginQuoteScopes(baseScope)
        expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(baseScope)
        expect(tokens[2]).toEqual value: 'a', scopes: baseScope
        expect(tokens[3]).toEqual value: '(', scopes: regexpGroupScopes(baseScope).concat ['punctuation.definition.group.regexp.php']
        expect(tokens[4]).toEqual value: '?P<', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(baseScope), 'punctuation.definition.group.capture.begin.regexp.php')
        expect(tokens[5]).toEqual value: 'word', scopes: regexpGroupNameScopes(regexpGroupScopes(baseScope))
        expect(tokens[6]).toEqual value: '>', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(baseScope), 'punctuation.definition.group.capture.end.regexp.php')
        expect(tokens[7]).toEqual value: 'foo', scopes: regexpGroupContentScopes(baseScope)
        expect(tokens[8]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(baseScope)
        expect(tokens[9]).toEqual value: quoteValue, scopes: regexpWrapperEndQuoteScopes(baseScope)

    it 'should stop unclosed quoted literals at the quoted wrapper boundary', ->
      doubleQuoted = grammar.tokenizeLine '"/\\Qfoo/bar/"'
      singleQuoted = grammar.tokenizeLine "'/\\Qfoo/bar/'"
      decodedDoubleQuoted = grammar.tokenizeLine '"/\\\\Qfoo/bar/"'
      decodedSingleQuoted = grammar.tokenizeLine "'/\\\\Qfoo/bar/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[3]).toEqual value: 'foo/bar', scopes: regexpQuotedLiteralContentScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[4]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[5]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[3]).toEqual value: 'foo/bar', scopes: regexpQuotedLiteralContentScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[4]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[5]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

      expect(decodedDoubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(decodedDoubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(decodedDoubleQuoted.tokens[2]).toEqual value: '\\\\', scopes: regexpDecodedQuotedLiteralTransportScopes(quotedDoubleRegexpScope)
      expect(decodedDoubleQuoted.tokens[3]).toEqual value: 'Q', scopes: regexpQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(decodedDoubleQuoted.tokens[4]).toEqual value: 'foo/bar', scopes: regexpQuotedLiteralContentScopes(quotedDoubleRegexpScope)
      expect(decodedDoubleQuoted.tokens[5]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(decodedDoubleQuoted.tokens[6]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(decodedSingleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(decodedSingleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(decodedSingleQuoted.tokens[2]).toEqual value: '\\\\', scopes: regexpDecodedQuotedLiteralTransportScopes(quotedSingleRegexpScope)
      expect(decodedSingleQuoted.tokens[3]).toEqual value: 'Q', scopes: regexpQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(decodedSingleQuoted.tokens[4]).toEqual value: 'foo/bar', scopes: regexpQuotedLiteralContentScopes(quotedSingleRegexpScope)
      expect(decodedSingleQuoted.tokens[5]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(decodedSingleQuoted.tokens[6]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should tokenize interpolation inside double quoted regex quoted literals', ->
      {tokens} = grammar.tokenizeLine '"/\\Q$foo\\E/"'

      expect(tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[2]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(tokens[3]).toEqual value: '$', scopes: regexpQuotedLiteralContentScopes(quotedDoubleRegexpScope).concat ['variable.other.php', 'punctuation.definition.variable.php']
      expect(tokens[4]).toEqual value: 'foo', scopes: regexpQuotedLiteralContentScopes(quotedDoubleRegexpScope).concat ['variable.other.php']
      expect(tokens[5]).toEqual value: '\\E', scopes: regexpQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(tokens[6]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[7]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

    it 'should not treat escaped parentheses as groups in double quoted regexes', ->
      {tokens} = grammar.tokenizeLine '"/\\(ab\\)/"'

      expect(tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[2]).toEqual value: '\\(', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[3]).toEqual value: 'ab', scopes: quotedDoubleRegexpScope
      expect(tokens[4]).toEqual value: '\\)', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[5]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[6]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

    it 'should keep closing-delimiter slash parity consistent in quoted regex wrappers', ->
      quotedHosts = [
        {
          regexScope: quotedDoubleRegexpScope
          wrap: (slashes) -> '"/a' + '\\'.repeat(slashes) + '/"'
          quoteValue: '"'
        }
        {
          regexScope: quotedSingleRegexpScope
          wrap: (slashes) -> "'/a" + '\\'.repeat(slashes) + "/'"
          quoteValue: '\''
        }
      ]
      validSlashCounts = [0, 3, 4, 7]

      for {regexScope, wrap, quoteValue} in quotedHosts
        for slashCount in [0..7]
          {tokens} = grammar.tokenizeLine wrap slashCount
          entersRegex = tokens.some (token) -> 'meta.embedded.regexp.php' in token.scopes

          if slashCount in validSlashCounts
            expect(entersRegex).toBe true
            expect(tokens[tokens.length - 2]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(regexScope)
            expect(tokens[tokens.length - 1]).toEqual value: quoteValue, scopes: regexpWrapperEndQuoteScopes(regexScope)
          else
            expect(entersRegex).toBe false

    it 'should keep multiline slash-prefixed double quoted strings out of regex mode', ->
      lines = grammar.tokenizeLines "$r = \"/foo\nbar/\";"

      expect(lines[0].some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false
      expect(lines[1].some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false

    it 'should keep multiline slash-prefixed single quoted strings out of regex mode', ->
      lines = grammar.tokenizeLines "$r = '/foo\nbar/';"

      expect(lines[0].some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false
      expect(lines[1].some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false

    it 'should enter wrapped broken character classes when the local wrapper tail is present', ->
      plainSingleQuoted = grammar.tokenizeLine "'/foo[ba/xui'"
      quotedLiteralSingleQuoted = grammar.tokenizeLine "'/foo[\\Qba/xui'"
      plainDoubleQuoted = grammar.tokenizeLine '"/foo[ba/xui"'

      expect(plainSingleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(plainSingleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(plainSingleQuoted.tokens[2]).toEqual value: 'foo', scopes: quotedSingleRegexpScope
      expect(plainSingleQuoted.tokens[3]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(plainSingleQuoted.tokens[4]).toEqual value: 'b', scopes: regexpCharacterClassLiteralScopes(quotedSingleRegexpScope)
      expect(plainSingleQuoted.tokens[5]).toEqual value: 'a', scopes: regexpCharacterClassLiteralScopes(quotedSingleRegexpScope)
      expect(plainSingleQuoted.tokens[6]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(plainSingleQuoted.tokens[7]).toEqual value: 'xui', scopes: quotedSingleRegexpScope.concat ['storage.modifier.regexp.php']
      expect(plainSingleQuoted.tokens[8]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

      expect(quotedLiteralSingleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(quotedLiteralSingleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(quotedLiteralSingleQuoted.tokens[2]).toEqual value: 'foo', scopes: quotedSingleRegexpScope
      expect(quotedLiteralSingleQuoted.tokens[3]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(quotedLiteralSingleQuoted.tokens[4]).toEqual value: '\\Q', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(quotedLiteralSingleQuoted.tokens[5]).toEqual value: 'ba', scopes: regexpCharacterClassQuotedLiteralContentScopes(quotedSingleRegexpScope)
      expect(quotedLiteralSingleQuoted.tokens[6]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(quotedLiteralSingleQuoted.tokens[7]).toEqual value: 'xui', scopes: quotedSingleRegexpScope.concat ['storage.modifier.regexp.php']
      expect(quotedLiteralSingleQuoted.tokens[8]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

      expect(plainDoubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(plainDoubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(plainDoubleQuoted.tokens[2]).toEqual value: 'foo', scopes: quotedDoubleRegexpScope
      expect(plainDoubleQuoted.tokens[3]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(plainDoubleQuoted.tokens[4]).toEqual value: 'b', scopes: regexpCharacterClassLiteralScopes(quotedDoubleRegexpScope)
      expect(plainDoubleQuoted.tokens[5]).toEqual value: 'a', scopes: regexpCharacterClassLiteralScopes(quotedDoubleRegexpScope)
      expect(plainDoubleQuoted.tokens[6]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(plainDoubleQuoted.tokens[7]).toEqual value: 'xui', scopes: quotedDoubleRegexpScope.concat ['storage.modifier.regexp.php']
      expect(plainDoubleQuoted.tokens[8]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

  describe 'PHP transport scopes in quoted regex hosts', ->
    # These tests only lock in the PHP transport layer for doubled backslashes.
    # Some interpreted-host forms also gain regex meaning in more specific tests below.
    it 'should keep PHP transport scopes on doubled backslashes in quoted regex bodies', ->
      doubleQuoted = grammar.tokenizeLine '"/\\\\1\\\\x41\\\\d/";'
      singleQuoted = grammar.tokenizeLine "'/\\\\1\\\\x41\\\\d/';"
      singleQuotedEscapes = singleQuoted.tokens.filter (token) -> token.value.includes('\\\\')

      expect(doubleQuoted.tokens[2].value).toBe '\\\\'
      expect(doubleQuoted.tokens[4].value).toBe '\\\\'
      expect(doubleQuoted.tokens[6].value).toBe '\\\\'
      expect(doubleQuoted.tokens[2].scopes.includes('constant.character.escape.php')).toBe true
      expect(doubleQuoted.tokens[4].scopes.includes('constant.character.escape.php')).toBe true
      expect(doubleQuoted.tokens[6].scopes.includes('constant.character.escape.php')).toBe true

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

describe 'PHP quoted regexp recovery', ->
  grammar = null
  before(-> grammar = await loadGrammar('source.php'))

  regexValues = (tokens) ->
    tokens
      .filter((token) -> 'meta.embedded.regexp.php' in token.scopes)
      .map((token) -> token.value)

  it 'keeps incomplete local class fragments out of quoted regex mode even when later same-line PHP text looks class-like', ->
    plainSingleCases = [
      "'/[^' . $foo . '.\\\\-a-zA-Z\\d\\s]/';"
      "'/[' . $foo . ']+/u';"
    ]
    plainDoubleCases = [
      "\"/[^\" . $foo . \".\\\\-a-zA-Z\\d\\s]/\";"
      "\"/[\" . $foo . \"]+/u\";"
    ]
    singleWithInnerRegex = "'/[' . \\preg_replace('/a-z/', $foo, $bar) . ']+/u';"
    doubleWithInnerRegex = "\"/[\" . \\preg_replace(\"/a-z/\", $foo, $bar) . \"]+/u\";"

    for line in plainSingleCases
      {tokens} = grammar.tokenizeLine line
      expect(regexValues(tokens)).toEqual []
      expect(tokens.some((token) -> token.value is '$foo' and 'meta.embedded.regexp.php' in token.scopes)).toBe false
      expect(tokens.some((token) -> token.value is '.\\\\-a-zA-Z\\d\\s]/' and 'meta.embedded.regexp.php' in token.scopes)).toBe false
      expect(tokens[tokens.length - 1].scopes).toContain 'punctuation.terminator.expression.php'

    for line in plainDoubleCases
      {tokens} = grammar.tokenizeLine line
      expect(regexValues(tokens)).toEqual []
      expect(tokens.some((token) -> token.value is '$foo' and 'meta.embedded.regexp.php' in token.scopes)).toBe false
      expect(tokens.some((token) -> token.value is '.\\\\-a-zA-Z\\d\\s]/' and 'meta.embedded.regexp.php' in token.scopes)).toBe false
      expect(tokens[tokens.length - 1].scopes).toContain 'punctuation.terminator.expression.php'

    {tokens: singleWithInnerRegexTokens} = grammar.tokenizeLine singleWithInnerRegex
    expect(regexValues(singleWithInnerRegexTokens)).toEqual ['\'', '/', 'a-z', '/', '\'']

    {tokens: doubleWithInnerRegexTokens} = grammar.tokenizeLine doubleWithInnerRegex
    expect(regexValues(doubleWithInnerRegexTokens)).toEqual ['"', '/', 'a-z', '/', '"']

  it 'keeps complete local wrapped class fragments in regex mode when concatenation continues later on the line', ->
    plainSingleLine = "'/foo[ba/xui' . 'a]/xui';"
    quotedLiteralSingleLine = "'/foo[\\Qba/xui' . 'a]/xui';"
    plainDoubleLine = "\"/foo[ba/xui\" . \"a]/xui\";"

    {tokens: plainSingleTokens} = grammar.tokenizeLine plainSingleLine
    expect(regexValues(plainSingleTokens)).toEqual ['\'', '/', 'foo', '[', 'b', 'a', '/', 'xui', '\'']
    expect(plainSingleTokens.some((token) -> token.value is 'a]/xui' and 'meta.embedded.regexp.php' in token.scopes)).toBe false

    {tokens: quotedLiteralSingleTokens} = grammar.tokenizeLine quotedLiteralSingleLine
    expect(regexValues(quotedLiteralSingleTokens)).toEqual ['\'', '/', 'foo', '[', '\\Q', 'ba', '/', 'xui', '\'']
    expect(quotedLiteralSingleTokens.some((token) -> token.value is 'a]/xui' and 'meta.embedded.regexp.php' in token.scopes)).toBe false

    {tokens: plainDoubleTokens} = grammar.tokenizeLine plainDoubleLine
    expect(regexValues(plainDoubleTokens)).toEqual ['"', '/', 'foo', '[', 'b', 'a', '/', 'xui', '"']
    expect(plainDoubleTokens.some((token) -> token.value is 'a]/xui' and 'meta.embedded.regexp.php' in token.scopes)).toBe false

  it 'keeps incomplete local class-internal quoted-literal fragments out of quoted regex mode across concatenated string fragments', ->
    singleLine = "'/[\\Qfoo' . $foo . 'bar]/';"
    doubleLine = "\"/[\\\\Qfoo\" . $foo . \"bar]/\";"

    {tokens: singleTokens} = grammar.tokenizeLine singleLine
    expect(regexValues(singleTokens)).toEqual []
    expect(singleTokens.some((token) -> token.value is '$foo' and 'meta.embedded.regexp.php' in token.scopes)).toBe false
    expect(singleTokens.some((token) -> token.value is 'bar]/' and 'meta.embedded.regexp.php' in token.scopes)).toBe false

    {tokens: doubleTokens} = grammar.tokenizeLine doubleLine
    expect(regexValues(doubleTokens)).toEqual []
    expect(doubleTokens.some((token) -> token.value is '$foo' and 'meta.embedded.regexp.php' in token.scopes)).toBe false
    expect(doubleTokens.some((token) -> token.value is 'bar]/' and 'meta.embedded.regexp.php' in token.scopes)).toBe false

  it 'stops unclosed quoted regex character-class quoted literals at the quoted wrapper boundary', ->
    rawDoubleQuoted = grammar.tokenizeLine '"/[\\Qfoo/bar]/"'
    rawSingleQuoted = grammar.tokenizeLine "'/[\\Qfoo/bar]/'"
    decodedDoubleQuoted = grammar.tokenizeLine '"/[\\\\Qfoo/bar]/"'
    decodedSingleQuoted = grammar.tokenizeLine "'/[\\\\Qfoo/bar]/'"

    expect(rawDoubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
    expect(rawDoubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
    expect(rawDoubleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
    expect(rawDoubleQuoted.tokens[3]).toEqual value: '\\Q', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
    expect(rawDoubleQuoted.tokens[4]).toEqual value: 'foo/bar]', scopes: regexpCharacterClassQuotedLiteralContentScopes(quotedDoubleRegexpScope)
    expect(rawDoubleQuoted.tokens[5]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
    expect(rawDoubleQuoted.tokens[6]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

    expect(rawSingleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
    expect(rawSingleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
    expect(rawSingleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
    expect(rawSingleQuoted.tokens[3]).toEqual value: '\\Q', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']
    expect(rawSingleQuoted.tokens[4]).toEqual value: 'foo/bar]', scopes: regexpCharacterClassQuotedLiteralContentScopes(quotedSingleRegexpScope)
    expect(rawSingleQuoted.tokens[5]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
    expect(rawSingleQuoted.tokens[6]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    expect(decodedDoubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
    expect(decodedDoubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
    expect(decodedDoubleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
    expect(decodedDoubleQuoted.tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedQuotedLiteralTransportScopes(quotedDoubleRegexpScope)
    expect(decodedDoubleQuoted.tokens[4]).toEqual value: 'Q', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
    expect(decodedDoubleQuoted.tokens[5]).toEqual value: 'foo/bar]', scopes: regexpCharacterClassQuotedLiteralContentScopes(quotedDoubleRegexpScope)
    expect(decodedDoubleQuoted.tokens[6]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
    expect(decodedDoubleQuoted.tokens[7]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

    expect(decodedSingleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
    expect(decodedSingleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
    expect(decodedSingleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
    expect(decodedSingleQuoted.tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedQuotedLiteralTransportScopes(quotedSingleRegexpScope)
    expect(decodedSingleQuoted.tokens[4]).toEqual value: 'Q', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']
    expect(decodedSingleQuoted.tokens[5]).toEqual value: 'foo/bar]', scopes: regexpCharacterClassQuotedLiteralContentScopes(quotedSingleRegexpScope)
    expect(decodedSingleQuoted.tokens[6]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
    expect(decodedSingleQuoted.tokens[7]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

  it 'keeps concatenated quoted-literal fragments out of quoted regex mode while wrapper entry stays conservative', ->
    rawSingleLine = "'/\\Qfoo' . $foo . 'bar\\E/';"
    rawDoubleLine = "\"/\\Qfoo\" . $foo . \"bar\\E/\";"
    decodedSingleLine = "'/\\\\Qfoo' . $foo . 'bar\\\\E/';"
    decodedDoubleLine = "\"/\\\\Qfoo\" . $foo . \"bar\\\\E/\";"

    {tokens: rawSingleTokens} = grammar.tokenizeLine rawSingleLine
    expect(rawSingleTokens.some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false
    expect(rawSingleTokens.some((token) -> token.value is '$foo' and 'meta.embedded.regexp.php' in token.scopes)).toBe false
    expect(rawSingleTokens.some((token) -> token.value is 'bar\\E/' and 'meta.embedded.regexp.php' in token.scopes)).toBe false

    {tokens: rawDoubleTokens} = grammar.tokenizeLine rawDoubleLine
    expect(rawDoubleTokens.some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false
    expect(rawDoubleTokens.some((token) -> token.value is '$foo' and 'meta.embedded.regexp.php' in token.scopes)).toBe false
    expect(rawDoubleTokens.some((token) -> token.value is 'bar\\E/' and 'meta.embedded.regexp.php' in token.scopes)).toBe false

    {tokens: decodedSingleTokens} = grammar.tokenizeLine decodedSingleLine
    expect(decodedSingleTokens.some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false
    expect(decodedSingleTokens.some((token) -> token.value is '$foo' and 'meta.embedded.regexp.php' in token.scopes)).toBe false
    expect(decodedSingleTokens.some((token) -> token.value is 'bar\\\\E/' and 'meta.embedded.regexp.php' in token.scopes)).toBe false

    {tokens: decodedDoubleTokens} = grammar.tokenizeLine decodedDoubleLine
    expect(decodedDoubleTokens.some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false
    expect(decodedDoubleTokens.some((token) -> token.value is '$foo' and 'meta.embedded.regexp.php' in token.scopes)).toBe false
    expect(decodedDoubleTokens.some((token) -> token.value is 'bar\\\\E/' and 'meta.embedded.regexp.php' in token.scopes)).toBe false

  it 'stops unclosed quoted comment groups at the quoted wrapper boundary', ->
    doubleQuoted = grammar.tokenizeLine '"/(?#comment/"'
    singleQuoted = grammar.tokenizeLine "'/(?#comment/'"

    expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
    expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
    expect(doubleQuoted.tokens[2]).toEqual value: '(', scopes: regexpCommentGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.comment.begin.regexp.php']
    expect(doubleQuoted.tokens[3]).toEqual value: '?#', scopes: regexpCommentGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.comment.begin.regexp.php']
    expect(doubleQuoted.tokens[4]).toEqual value: 'comment', scopes: regexpCommentGroupScopes(quotedDoubleRegexpScope)
    expect(doubleQuoted.tokens[5]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
    expect(doubleQuoted.tokens[6]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

    expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
    expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
    expect(singleQuoted.tokens[2]).toEqual value: '(', scopes: regexpCommentGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.comment.begin.regexp.php']
    expect(singleQuoted.tokens[3]).toEqual value: '?#', scopes: regexpCommentGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.comment.begin.regexp.php']
    expect(singleQuoted.tokens[4]).toEqual value: 'comment', scopes: regexpCommentGroupScopes(quotedSingleRegexpScope)
    expect(singleQuoted.tokens[5]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
    expect(singleQuoted.tokens[6]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

  it 'keeps concatenated plain-group fragments out of quoted regex mode while wrapper entry stays conservative', ->
    singleLine = "'/a(foo' . $foo . 'bar)/';"
    doubleLine = "\"/a(foo\" . $foo . \"bar)/\";"

    {tokens: singleTokens} = grammar.tokenizeLine singleLine
    expect(singleTokens.some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false
    expect(singleTokens.some((token) -> token.value is '$foo' and 'meta.embedded.regexp.php' in token.scopes)).toBe false

    {tokens: doubleTokens} = grammar.tokenizeLine doubleLine
    expect(doubleTokens.some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false
    expect(doubleTokens.some((token) -> token.value is '$foo' and 'meta.embedded.regexp.php' in token.scopes)).toBe false

  it 'keeps concatenated assertion-group fragments out of quoted regex mode while wrapper entry stays conservative', ->
    singleLine = "'/a(?=foo' . $foo . 'bar)/';"
    doubleLine = "\"/a(?=foo\" . $foo . \"bar)/\";"

    {tokens: singleTokens} = grammar.tokenizeLine singleLine
    expect(singleTokens.some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false
    expect(singleTokens.some((token) -> token.value is '$foo' and 'meta.embedded.regexp.php' in token.scopes)).toBe false

    {tokens: doubleTokens} = grammar.tokenizeLine doubleLine
    expect(doubleTokens.some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false
    expect(doubleTokens.some((token) -> token.value is '$foo' and 'meta.embedded.regexp.php' in token.scopes)).toBe false

  it 'keeps concatenated non-capturing and option-group fragments out of quoted regex mode while wrapper entry stays conservative', ->
    nonCapturingSingleLine = "'/a(?:foo' . $foo . 'bar)/';"
    nonCapturingDoubleLine = "\"/a(?:foo\" . $foo . \"bar)/\";"
    optionsSingleLine = "'/a(?im:foo' . $foo . 'bar)/';"
    optionsDoubleLine = "\"/a(?im:foo\" . $foo . \"bar)/\";"

    {tokens: nonCapturingSingleTokens} = grammar.tokenizeLine nonCapturingSingleLine
    expect(nonCapturingSingleTokens.some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false
    expect(nonCapturingSingleTokens.some((token) -> token.value is '$foo' and 'meta.embedded.regexp.php' in token.scopes)).toBe false

    {tokens: nonCapturingDoubleTokens} = grammar.tokenizeLine nonCapturingDoubleLine
    expect(nonCapturingDoubleTokens.some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false
    expect(nonCapturingDoubleTokens.some((token) -> token.value is '$foo' and 'meta.embedded.regexp.php' in token.scopes)).toBe false

    {tokens: optionsSingleTokens} = grammar.tokenizeLine optionsSingleLine
    expect(optionsSingleTokens.some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false
    expect(optionsSingleTokens.some((token) -> token.value is '$foo' and 'meta.embedded.regexp.php' in token.scopes)).toBe false

    {tokens: optionsDoubleTokens} = grammar.tokenizeLine optionsDoubleLine
    expect(optionsDoubleTokens.some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false
    expect(optionsDoubleTokens.some((token) -> token.value is '$foo' and 'meta.embedded.regexp.php' in token.scopes)).toBe false

  it 'keeps concatenated named-group fragments out of quoted regex mode while wrapper entry stays conservative', ->
    lines = [
      "\"/a(?<word>foo\" . $foo . \"bar)/\";"
      "\"/a(?'word'foo\" . $foo . \"bar)/\";"
      "\"/a(?P<word>foo\" . $foo . \"bar)/\";"
      "'/a(?<word>foo' . $foo . 'bar)/';"
      "'/a(?\\'word\\'foo' . $foo . 'bar)/';"
      "'/a(?P<word>foo' . $foo . 'bar)/';"
    ]

    for line in lines
      {tokens} = grammar.tokenizeLine line
      expect(tokens.some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false
      expect(tokens.some((token) -> token.value is '$foo' and 'meta.embedded.regexp.php' in token.scopes)).toBe false

  it 'stops unclosed quoted conditionals at the quoted wrapper boundary', ->
    doubleQuoted = grammar.tokenizeLine '"/(?(1)ab/"'
    singleQuoted = grammar.tokenizeLine "'/(?(<word>)ab/'"

    expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
    expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
    expect(doubleQuoted.tokens[2]).toEqual value: '(', scopes: regexpConditionalGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
    expect(doubleQuoted.tokens[3]).toEqual value: '?', scopes: regexpConditionalBeginKeywordScopes(quotedDoubleRegexpScope)
    expect(doubleQuoted.tokens[4]).toEqual value: '(', scopes: regexpConditionalBeginPunctuationScopes(quotedDoubleRegexpScope)
    expect(doubleQuoted.tokens[5]).toEqual value: '1', scopes: regexpConditionalGroupScopes(quotedDoubleRegexpScope).concat ['constant.numeric.regexp.php']
    expect(doubleQuoted.tokens[6]).toEqual value: ')', scopes: regexpConditionalPunctuationScopes(quotedDoubleRegexpScope)
    expect(doubleQuoted.tokens[7]).toEqual value: 'ab', scopes: regexpConditionalGroupContentScopes(quotedDoubleRegexpScope)
    expect(doubleQuoted.tokens[8]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
    expect(doubleQuoted.tokens[9]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

    expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
    expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
    expect(singleQuoted.tokens[2]).toEqual value: '(', scopes: regexpConditionalGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
    expect(singleQuoted.tokens[3]).toEqual value: '?', scopes: regexpConditionalBeginKeywordScopes(quotedSingleRegexpScope)
    expect(singleQuoted.tokens[4]).toEqual value: '(', scopes: regexpConditionalBeginPunctuationScopes(quotedSingleRegexpScope)
    expect(singleQuoted.tokens[5]).toEqual value: '<', scopes: regexpSpecificGroupPunctuationScopes(regexpConditionalGroupScopes(quotedSingleRegexpScope), 'punctuation.definition.group.capture.begin.regexp.php')
    expect(singleQuoted.tokens[6]).toEqual value: 'word', scopes: regexpConditionalGroupScopes(quotedSingleRegexpScope).concat ['variable.other.regexp.php']
    expect(singleQuoted.tokens[7]).toEqual value: '>', scopes: regexpSpecificGroupPunctuationScopes(regexpConditionalGroupScopes(quotedSingleRegexpScope), 'punctuation.definition.group.capture.end.regexp.php')
    expect(singleQuoted.tokens[8]).toEqual value: ')', scopes: regexpConditionalPunctuationScopes(quotedSingleRegexpScope)
    expect(singleQuoted.tokens[9]).toEqual value: 'ab', scopes: regexpConditionalGroupContentScopes(quotedSingleRegexpScope)
    expect(singleQuoted.tokens[10]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
    expect(singleQuoted.tokens[11]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

  it 'should layer generic group punctuation on apostrophe-delimited named conditional delimiters in quoted regexes', ->
    doubleQuoted = grammar.tokenizeLine '"/(?(\'word\')ab|cd)/"'
    singleQuoted = grammar.tokenizeLine "'/(?(\\'word\\')ab|cd)/'"

    expect(doubleQuoted.tokens[5]).toEqual value: '\'', scopes: regexpSpecificGroupPunctuationScopes(regexpConditionalGroupScopes(quotedDoubleRegexpScope), 'punctuation.definition.group.capture.begin.regexp.php')
    expect(doubleQuoted.tokens[7]).toEqual value: '\'', scopes: regexpSpecificGroupPunctuationScopes(regexpConditionalGroupScopes(quotedDoubleRegexpScope), 'punctuation.definition.group.capture.end.regexp.php')

    expect(singleQuoted.tokens[5]).toEqual value: '\\\'', scopes: regexpConditionalGroupScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'punctuation.definition.group.regexp.php', 'punctuation.definition.group.capture.begin.regexp.php']
    expect(singleQuoted.tokens[7]).toEqual value: '\\\'', scopes: regexpConditionalGroupScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'punctuation.definition.group.regexp.php', 'punctuation.definition.group.capture.end.regexp.php']

  it 'stops unclosed quoted conditional assertion conditions at the quoted wrapper boundary', ->
    doubleQuoted = grammar.tokenizeLine '"/(?(?=ab/"'
    singleQuoted = grammar.tokenizeLine "'/(?(?!ab/'"

    expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
    expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
    expect(doubleQuoted.tokens[2]).toEqual value: '(', scopes: regexpConditionalGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
    expect(doubleQuoted.tokens[3]).toEqual value: '?', scopes: regexpConditionalBeginKeywordScopes(quotedDoubleRegexpScope)
    expect(doubleQuoted.tokens[4]).toEqual value: '(', scopes: regexpConditionalBeginPunctuationScopes(quotedDoubleRegexpScope)
    expect(doubleQuoted.tokens[5]).toEqual value: '?=', scopes: regexpSpecificConditionalAssertionPunctuationScopes(quotedDoubleRegexpScope, 'meta.assertion.look-ahead.regexp.php')
    expect(doubleQuoted.tokens[6]).toEqual value: 'ab', scopes: regexpConditionalAssertionContentScopes(quotedDoubleRegexpScope)
    expect(doubleQuoted.tokens[7]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
    expect(doubleQuoted.tokens[8]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

    expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
    expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
    expect(singleQuoted.tokens[2]).toEqual value: '(', scopes: regexpConditionalGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
    expect(singleQuoted.tokens[3]).toEqual value: '?', scopes: regexpConditionalBeginKeywordScopes(quotedSingleRegexpScope)
    expect(singleQuoted.tokens[4]).toEqual value: '(', scopes: regexpConditionalBeginPunctuationScopes(quotedSingleRegexpScope)
    expect(singleQuoted.tokens[5]).toEqual value: '?!', scopes: regexpSpecificConditionalAssertionPunctuationScopes(quotedSingleRegexpScope, 'meta.assertion.negative-look-ahead.regexp.php')
    expect(singleQuoted.tokens[6]).toEqual value: 'ab', scopes: regexpConditionalAssertionContentScopes(quotedSingleRegexpScope)
    expect(singleQuoted.tokens[7]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
    expect(singleQuoted.tokens[8]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

  it 'keeps concatenated conditional-group fragments out of quoted regex mode while wrapper entry stays conservative', ->
    lines = [
      "\"/(?(1)ab\" . $foo . \"cd)/\";"
      "\"/(?(<word>)ab\" . $foo . \"cd)/\";"
      "\"/(?('word')ab\" . $foo . \"cd)/\";"
      "'/(?(1)ab' . $foo . 'cd)/';"
      "'/(?(<word>)ab' . $foo . 'cd)/';"
      "'/(?(\\'word\\')ab' . $foo . 'cd)/';"
    ]

    for line in lines
      {tokens} = grammar.tokenizeLine line
      expect(tokens.some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false
      expect(tokens.some((token) -> token.value is '$foo' and 'meta.embedded.regexp.php' in token.scopes)).toBe false

  it 'keeps concatenated assertion-conditional fragments out of quoted regex mode while wrapper entry stays conservative', ->
    lines = [
      "\"/(?(?=ab)cd\" . $foo . \"ef)/\";"
      "'/(?(?!ab)cd' . $foo . 'ef)/';"
    ]

    for line in lines
      {tokens} = grammar.tokenizeLine line
      expect(tokens.some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false
      expect(tokens.some((token) -> token.value is '$foo' and 'meta.embedded.regexp.php' in token.scopes)).toBe false


describe 'PHP regexp decoded apostrophe-delimited forms', ->
  grammar = null
  before(-> grammar = await loadGrammar('source.php'))

describe 'PHP regexp single-quoted source apostrophe forms', ->
  grammar = null
  before(-> grammar = await loadGrammar('source.php'))

  it 'tokenizes apostrophe-delimited named groups and conditionals in single quoted regex source', ->
    namedGroup = grammar.tokenizeLine "'/(?\\'name\\'foo)/';"
    conditional = grammar.tokenizeLine "'/(?(\\'word\\')yes|no)/';"

    expect(namedGroup.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
    expect(namedGroup.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
    expect(namedGroup.tokens[2]).toEqual value: '(', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
    expect(namedGroup.tokens[3]).toEqual value: '?', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php', 'punctuation.definition.group.capture.begin.regexp.php']
    expect(namedGroup.tokens[4]).toEqual value: '\\\'', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'punctuation.definition.group.capture.begin.regexp.php']
    expect(namedGroup.tokens[5]).toEqual value: 'name', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['variable.other.regexp.php']
    expect(namedGroup.tokens[6]).toEqual value: '\\\'', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'punctuation.definition.group.capture.end.regexp.php']
    expect(namedGroup.tokens[7]).toEqual value: 'foo', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['string.regexp.single-quoted.php']
    expect(namedGroup.tokens[8]).toEqual value: ')', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']

    expect(conditional.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
    expect(conditional.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
    expect(conditional.tokens[2]).toEqual value: '(', scopes: regexpConditionalGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
    expect(conditional.tokens[3]).toEqual value: '?', scopes: regexpConditionalGroupScopes(quotedSingleRegexpScope).concat ['keyword.control.conditional.begin.regexp.php']
    expect(conditional.tokens[4]).toEqual value: '(', scopes: regexpConditionalGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.conditional.regexp.php']
    expect(conditional.tokens[5]).toEqual value: '\\\'', scopes: regexpConditionalGroupScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'punctuation.definition.group.regexp.php', 'punctuation.definition.group.capture.begin.regexp.php']
    expect(conditional.tokens[6]).toEqual value: 'word', scopes: regexpConditionalGroupScopes(quotedSingleRegexpScope).concat ['variable.other.regexp.php']
    expect(conditional.tokens[7]).toEqual value: '\\\'', scopes: regexpConditionalGroupScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'punctuation.definition.group.regexp.php', 'punctuation.definition.group.capture.end.regexp.php']
    expect(conditional.tokens[8]).toEqual value: ')', scopes: regexpConditionalGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.conditional.regexp.php']

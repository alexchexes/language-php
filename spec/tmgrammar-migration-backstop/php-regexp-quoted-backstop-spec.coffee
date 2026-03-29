{loadGrammar} = require('../../utils/loadGrammar')
require('../../utils/compatibleExpect')
{expect} = require('chai')

{
  quotedSingleRegexpScope
  quotedDoubleRegexpScope
  regexpCharacterClassPunctuationScopes
  regexpCharacterClassBoundaryNegationScopes
  regexpCharacterClassLiteralScopes
  regexpCharacterClassLetterRangeScopes
  regexpCharacterClassRangeOperatorScopes
  regexpCharacterClassScopes
  regexpCharacterClassEscapeScopes
  regexpCharacterClassClassEscapeScopes
  regexpCharacterClassInvalidEscapeScopes
  regexpCharacterClassDecodedEscapeTransportScopes
  regexpCharacterClassDecodedInvalidTransportScopes
  regexpCharacterClassQuotedLiteralBoundaryScopes
  regexpCharacterClassDecodedQuotedLiteralTransportScopes
  regexpCharacterClassQuotedLiteralContentScopes
  regexpWrapperBeginQuoteScopes
  regexpWrapperBeginDelimiterScopes
  regexpWrapperEndDelimiterScopes
  regexpWrapperFlagScopes
  regexpWrapperEndQuoteScopes
  regexpQuotedLiteralBoundaryScopes
  regexpDecodedQuotedLiteralTransportScopes
  regexpQuotedLiteralContentScopes
  regexpInvalidEscapeScopes
  regexpDecodedInvalidTransportScopes
} = require '../php-regexp-helpers'

describe 'PHP quoted regexp tmgrammar migration backstop', ->
  grammar = null
  before(-> grammar = await loadGrammar('source.php'))

  it 'parses the grammar', ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe 'source.php'

  describe 'quoted regex strings', ->
    it 'should tokenize single quoted string regex with escaped bracket', ->
      {tokens} = grammar.tokenizeLine "'/\\[/'"

      expect(tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(tokens[2]).toEqual value: '\\[', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(tokens[3]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(tokens[4]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should tokenize quoted regex with slash inside character class', ->
      doubleQuoted = grammar.tokenizeLine "\"/[a/b]/\""
      singleQuoted = grammar.tokenizeLine "'/[a/b]/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: 'a', scopes: regexpCharacterClassLiteralScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[4]).toEqual value: '/', scopes: regexpCharacterClassLiteralScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[5]).toEqual value: 'b', scopes: regexpCharacterClassLiteralScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[7]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[8]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[3]).toEqual value: 'a', scopes: regexpCharacterClassLiteralScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[4]).toEqual value: '/', scopes: regexpCharacterClassLiteralScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[5]).toEqual value: 'b', scopes: regexpCharacterClassLiteralScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[7]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[8]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should tokenize trailing wrapper flags in quoted regexes', ->
      doubleQuoted = grammar.tokenizeLine '"/a/im"'
      singleQuoted = grammar.tokenizeLine "'/a/im'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: 'a', scopes: quotedDoubleRegexpScope
      expect(doubleQuoted.tokens[3]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[4]).toEqual value: 'im', scopes: regexpWrapperFlagScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[5]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: 'a', scopes: quotedSingleRegexpScope
      expect(singleQuoted.tokens[3]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[4]).toEqual value: 'im', scopes: regexpWrapperFlagScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[5]).toEqual value: '\'', scopes: quotedSingleRegexpScope.concat ['punctuation.definition.string.end.php']

    it 'should treat a leading closing bracket as literal class content in quoted regexes', ->
      doubleQuoted = grammar.tokenizeLine '"/[]a-z]/"'
      negatedDoubleQuoted = grammar.tokenizeLine '"/[^]a-z]/"'
      singleQuoted = grammar.tokenizeLine "'/[]a-z]/'"
      negatedSingleQuoted = grammar.tokenizeLine "'/[^]a-z]/'"

      expect(doubleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: ']', scopes: regexpCharacterClassLiteralScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[4]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[5]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[6]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[7]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)

      expect(negatedDoubleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(negatedDoubleQuoted.tokens[3]).toEqual value: '^', scopes: regexpCharacterClassBoundaryNegationScopes(quotedDoubleRegexpScope)
      expect(negatedDoubleQuoted.tokens[4]).toEqual value: ']', scopes: regexpCharacterClassLiteralScopes(quotedDoubleRegexpScope)
      expect(negatedDoubleQuoted.tokens[5]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(quotedDoubleRegexpScope)
      expect(negatedDoubleQuoted.tokens[6]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(quotedDoubleRegexpScope)
      expect(negatedDoubleQuoted.tokens[7]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(quotedDoubleRegexpScope)
      expect(negatedDoubleQuoted.tokens[8]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[3]).toEqual value: ']', scopes: regexpCharacterClassLiteralScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[4]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[5]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[6]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[7]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)

      expect(negatedSingleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(negatedSingleQuoted.tokens[3]).toEqual value: '^', scopes: regexpCharacterClassBoundaryNegationScopes(quotedSingleRegexpScope)
      expect(negatedSingleQuoted.tokens[4]).toEqual value: ']', scopes: regexpCharacterClassLiteralScopes(quotedSingleRegexpScope)
      expect(negatedSingleQuoted.tokens[5]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(quotedSingleRegexpScope)
      expect(negatedSingleQuoted.tokens[6]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(quotedSingleRegexpScope)
      expect(negatedSingleQuoted.tokens[7]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(quotedSingleRegexpScope)
      expect(negatedSingleQuoted.tokens[8]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)

    it 'should keep escaped alternation and quantifiers distinct from real operators in quoted regexes', ->
      doubleQuoted = grammar.tokenizeLine "\"/" + "\\|" + "\\?" + "\\+" + "\\*" + "a?b+c*" + "/\""
      singleQuoted = grammar.tokenizeLine "'/" + "\\|" + "\\?" + "\\+" + "\\*" + "a?b+c*" + "/'"

      expect(doubleQuoted.tokens[2]).toEqual value: '\\|', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[3]).toEqual value: '\\?', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[4]).toEqual value: '\\+', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[5]).toEqual value: '\\*', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[6]).toEqual value: 'a', scopes: quotedDoubleRegexpScope
      expect(doubleQuoted.tokens[7]).toEqual value: '?', scopes: quotedDoubleRegexpScope.concat ['keyword.operator.quantifier.regexp.php']
      expect(doubleQuoted.tokens[8]).toEqual value: 'b', scopes: quotedDoubleRegexpScope
      expect(doubleQuoted.tokens[9]).toEqual value: '+', scopes: quotedDoubleRegexpScope.concat ['keyword.operator.quantifier.regexp.php']
      expect(doubleQuoted.tokens[10]).toEqual value: 'c', scopes: quotedDoubleRegexpScope
      expect(doubleQuoted.tokens[11]).toEqual value: '*', scopes: quotedDoubleRegexpScope.concat ['keyword.operator.quantifier.regexp.php']

      expect(singleQuoted.tokens[2]).toEqual value: '\\|', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[3]).toEqual value: '\\?', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[4]).toEqual value: '\\+', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[5]).toEqual value: '\\*', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[6]).toEqual value: 'a', scopes: quotedSingleRegexpScope
      expect(singleQuoted.tokens[7]).toEqual value: '?', scopes: quotedSingleRegexpScope.concat ['keyword.operator.quantifier.regexp.php']
      expect(singleQuoted.tokens[8]).toEqual value: 'b', scopes: quotedSingleRegexpScope
      expect(singleQuoted.tokens[9]).toEqual value: '+', scopes: quotedSingleRegexpScope.concat ['keyword.operator.quantifier.regexp.php']
      expect(singleQuoted.tokens[10]).toEqual value: 'c', scopes: quotedSingleRegexpScope
      expect(singleQuoted.tokens[11]).toEqual value: '*', scopes: quotedSingleRegexpScope.concat ['keyword.operator.quantifier.regexp.php']

    it 'should keep anchors distinct from fallback operator chars in quoted regexes', ->
      doubleQuoted = grammar.tokenizeLine '"/^a$+*/"'
      singleQuoted = grammar.tokenizeLine "'/^a$+*/'"

      expect(doubleQuoted.tokens[2]).toEqual value: '^', scopes: quotedDoubleRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(doubleQuoted.tokens[3]).toEqual value: 'a', scopes: quotedDoubleRegexpScope
      expect(doubleQuoted.tokens[4]).toEqual value: '$', scopes: quotedDoubleRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(doubleQuoted.tokens[5]).toEqual value: '+', scopes: quotedDoubleRegexpScope.concat ['keyword.operator.quantifier.regexp.php']
      expect(doubleQuoted.tokens[6]).toEqual value: '*', scopes: quotedDoubleRegexpScope.concat ['keyword.operator.quantifier.regexp.php']

      expect(singleQuoted.tokens[2]).toEqual value: '^', scopes: quotedSingleRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(singleQuoted.tokens[3]).toEqual value: 'a', scopes: quotedSingleRegexpScope
      expect(singleQuoted.tokens[4]).toEqual value: '$', scopes: quotedSingleRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(singleQuoted.tokens[5]).toEqual value: '+', scopes: quotedSingleRegexpScope.concat ['keyword.operator.quantifier.regexp.php']
      expect(singleQuoted.tokens[6]).toEqual value: '*', scopes: quotedSingleRegexpScope.concat ['keyword.operator.quantifier.regexp.php']

    it 'should tokenize quoted literals in quoted regex strings', ->
      doubleQuoted = grammar.tokenizeLine '"/\\Qfoo/bar\\E/"'
      singleQuoted = grammar.tokenizeLine "'/\\Qfoo/bar\\E/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[3]).toEqual value: 'foo/bar', scopes: regexpQuotedLiteralContentScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[4]).toEqual value: '\\E', scopes: regexpQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[5]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[6]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[3]).toEqual value: 'foo/bar', scopes: regexpQuotedLiteralContentScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[4]).toEqual value: '\\E', scopes: regexpQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[5]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[6]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should keep operator-looking punctuation literal inside quoted regex quoted literals', ->
      doubleQuoted = grammar.tokenizeLine '"/\\Q.?+*^$|(){}[]\\E/"'
      singleQuoted = grammar.tokenizeLine "'/\\Q.?+*^$|(){}[]\\E/'"

      expect(doubleQuoted.tokens[2]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[3]).toEqual value: '.?+*^$|(){}[]', scopes: regexpQuotedLiteralContentScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[4]).toEqual value: '\\E', scopes: regexpQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']

      expect(singleQuoted.tokens[2]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[3]).toEqual value: '.?+*^$|(){}[]', scopes: regexpQuotedLiteralContentScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[4]).toEqual value: '\\E', scopes: regexpQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']

    it 'should tokenize decoded quoted literals in quoted regex strings', ->
      doubleQuoted = grammar.tokenizeLine '"/\\\\Qfoo/bar\\\\E/"'
      singleQuoted = grammar.tokenizeLine "'/\\\\Qfoo/bar\\\\E/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '\\\\', scopes: regexpDecodedQuotedLiteralTransportScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: 'Q', scopes: regexpQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[4]).toEqual value: 'foo/bar', scopes: regexpQuotedLiteralContentScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[5]).toEqual value: '\\\\', scopes: regexpDecodedQuotedLiteralTransportScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[6]).toEqual value: 'E', scopes: regexpQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[7]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[8]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: '\\\\', scopes: regexpDecodedQuotedLiteralTransportScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[3]).toEqual value: 'Q', scopes: regexpQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[4]).toEqual value: 'foo/bar', scopes: regexpQuotedLiteralContentScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[5]).toEqual value: '\\\\', scopes: regexpDecodedQuotedLiteralTransportScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[6]).toEqual value: 'E', scopes: regexpQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[7]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[8]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should tokenize asymmetric quoted-literal boundaries in quoted regex strings', ->
      decodedStartDoubleQuoted = grammar.tokenizeLine '"/\\\\Qabc\\E/"'
      rawStartDoubleQuoted = grammar.tokenizeLine '"/\\Qabc\\\\E/"'
      decodedStartSingleQuoted = grammar.tokenizeLine "'/\\\\Qabc\\E/'"
      rawStartSingleQuoted = grammar.tokenizeLine "'/\\Qabc\\\\E/'"

      expect(decodedStartDoubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(decodedStartDoubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(decodedStartDoubleQuoted.tokens[2]).toEqual value: '\\\\', scopes: regexpDecodedQuotedLiteralTransportScopes(quotedDoubleRegexpScope)
      expect(decodedStartDoubleQuoted.tokens[3]).toEqual value: 'Q', scopes: regexpQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(decodedStartDoubleQuoted.tokens[4]).toEqual value: 'abc', scopes: regexpQuotedLiteralContentScopes(quotedDoubleRegexpScope)
      expect(decodedStartDoubleQuoted.tokens[5]).toEqual value: '\\E', scopes: regexpQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(decodedStartDoubleQuoted.tokens[6]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(decodedStartDoubleQuoted.tokens[7]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(rawStartDoubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(rawStartDoubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(rawStartDoubleQuoted.tokens[2]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(rawStartDoubleQuoted.tokens[3]).toEqual value: 'abc', scopes: regexpQuotedLiteralContentScopes(quotedDoubleRegexpScope)
      expect(rawStartDoubleQuoted.tokens[4]).toEqual value: '\\\\', scopes: regexpDecodedQuotedLiteralTransportScopes(quotedDoubleRegexpScope)
      expect(rawStartDoubleQuoted.tokens[5]).toEqual value: 'E', scopes: regexpQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(rawStartDoubleQuoted.tokens[6]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(rawStartDoubleQuoted.tokens[7]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(decodedStartSingleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(decodedStartSingleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(decodedStartSingleQuoted.tokens[2]).toEqual value: '\\\\', scopes: regexpDecodedQuotedLiteralTransportScopes(quotedSingleRegexpScope)
      expect(decodedStartSingleQuoted.tokens[3]).toEqual value: 'Q', scopes: regexpQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(decodedStartSingleQuoted.tokens[4]).toEqual value: 'abc', scopes: regexpQuotedLiteralContentScopes(quotedSingleRegexpScope)
      expect(decodedStartSingleQuoted.tokens[5]).toEqual value: '\\E', scopes: regexpQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(decodedStartSingleQuoted.tokens[6]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(decodedStartSingleQuoted.tokens[7]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

      expect(rawStartSingleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(rawStartSingleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(rawStartSingleQuoted.tokens[2]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(rawStartSingleQuoted.tokens[3]).toEqual value: 'abc', scopes: regexpQuotedLiteralContentScopes(quotedSingleRegexpScope)
      expect(rawStartSingleQuoted.tokens[4]).toEqual value: '\\\\', scopes: regexpDecodedQuotedLiteralTransportScopes(quotedSingleRegexpScope)
      expect(rawStartSingleQuoted.tokens[5]).toEqual value: 'E', scopes: regexpQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(rawStartSingleQuoted.tokens[6]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(rawStartSingleQuoted.tokens[7]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should enter regex mode for same-host quote escapes inside quoted literals', ->
      doubleQuoted = grammar.tokenizeLine '"/\\Q\\"\\E/"'
      singleQuoted = grammar.tokenizeLine "'/\\Q\\'\\E/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[3]).toEqual value: '\\"', scopes: regexpQuotedLiteralContentScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php']
      expect(doubleQuoted.tokens[4]).toEqual value: '\\E', scopes: regexpQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[5]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[6]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[3]).toEqual value: '\\\'', scopes: regexpQuotedLiteralContentScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php']
      expect(singleQuoted.tokens[4]).toEqual value: '\\E', scopes: regexpQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[5]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[6]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should tokenize standalone quoted-literal end markers in quoted regex bodies', ->
      doubleQuoted = grammar.tokenizeLine '"/\\E/"'
      singleQuoted = grammar.tokenizeLine "'/\\E/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '\\E', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[3]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[4]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: '\\E', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[3]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[4]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should tokenize decoded quoted-literal end markers outside quoted literals in quoted regex strings', ->
      doubleQuoted = grammar.tokenizeLine '"/abc\\\\E/"'
      singleQuoted = grammar.tokenizeLine "'/abc\\\\E/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: 'abc', scopes: quotedDoubleRegexpScope
      expect(doubleQuoted.tokens[3]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php']
      expect(doubleQuoted.tokens[4]).toEqual value: 'E', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[5]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[6]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: 'abc', scopes: quotedSingleRegexpScope
      expect(singleQuoted.tokens[3]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php']
      expect(singleQuoted.tokens[4]).toEqual value: 'E', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[5]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[6]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

  describe 'quoted regex character classes', ->
    it 'should tokenize quoted literals inside quoted regex character classes', ->
      doubleQuoted = grammar.tokenizeLine ['"/[', '\\Q', '[', '\\"', ']', '\\E', 'a]/"'].join ''
      singleQuoted = grammar.tokenizeLine ["'/[", '\\Q', '[', "\\'", ']', '\\E', "a]/'"].join ''

      expect(doubleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: '\\Q', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[4]).toEqual value: '[', scopes: regexpCharacterClassQuotedLiteralContentScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[5]).toEqual value: '\\"', scopes: regexpCharacterClassQuotedLiteralContentScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php']
      expect(doubleQuoted.tokens[6]).toEqual value: ']', scopes: regexpCharacterClassQuotedLiteralContentScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[7]).toEqual value: '\\E', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[8]).toEqual value: 'a', scopes: regexpCharacterClassLiteralScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[9]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[3]).toEqual value: '\\Q', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[4]).toEqual value: '[', scopes: regexpCharacterClassQuotedLiteralContentScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[5]).toEqual value: '\\\'', scopes: regexpCharacterClassQuotedLiteralContentScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php']
      expect(singleQuoted.tokens[6]).toEqual value: ']', scopes: regexpCharacterClassQuotedLiteralContentScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[7]).toEqual value: '\\E', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[8]).toEqual value: 'a', scopes: regexpCharacterClassLiteralScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[9]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)

    it 'should keep operator-looking punctuation literal inside quoted regex character-class quoted literals', ->
      doubleQuoted = grammar.tokenizeLine '"/[\\Q.?+*^$|(){}[]\\E]/"'
      singleQuoted = grammar.tokenizeLine "'/[\\Q.?+*^$|(){}[]\\E]/'"

      expect(doubleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: '\\Q', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[4]).toEqual value: '.?+*^$|(){}[]', scopes: regexpCharacterClassQuotedLiteralContentScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[5]).toEqual value: '\\E', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[3]).toEqual value: '\\Q', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[4]).toEqual value: '.?+*^$|(){}[]', scopes: regexpCharacterClassQuotedLiteralContentScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[5]).toEqual value: '\\E', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)

    it 'should tokenize decoded and asymmetric quoted-literal boundaries in quoted regex character classes', ->
      decodedStartDoubleQuoted = grammar.tokenizeLine ['"/[', '\\\\', 'Q', '[', '\\"', ']', '\\E', 'a]/"'].join ''
      rawStartDoubleQuoted = grammar.tokenizeLine ['"/[', '\\Q', '[', '\\"', ']', '\\\\', 'E', 'a]/"'].join ''
      decodedStartSingleQuoted = grammar.tokenizeLine ["'/[", '\\\\', 'Q', '[', "\\'", ']', '\\E', "a]/'"].join ''
      rawStartSingleQuoted = grammar.tokenizeLine ["'/[", '\\Q', '[', "\\'", ']', '\\\\', 'E', "a]/'"].join ''

      expect(decodedStartDoubleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(decodedStartDoubleQuoted.tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedQuotedLiteralTransportScopes(quotedDoubleRegexpScope)
      expect(decodedStartDoubleQuoted.tokens[4]).toEqual value: 'Q', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(decodedStartDoubleQuoted.tokens[5]).toEqual value: '[', scopes: regexpCharacterClassQuotedLiteralContentScopes(quotedDoubleRegexpScope)
      expect(decodedStartDoubleQuoted.tokens[6]).toEqual value: '\\"', scopes: regexpCharacterClassQuotedLiteralContentScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php']
      expect(decodedStartDoubleQuoted.tokens[7]).toEqual value: ']', scopes: regexpCharacterClassQuotedLiteralContentScopes(quotedDoubleRegexpScope)
      expect(decodedStartDoubleQuoted.tokens[8]).toEqual value: '\\E', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']

      expect(rawStartDoubleQuoted.tokens[3]).toEqual value: '\\Q', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(rawStartDoubleQuoted.tokens[4]).toEqual value: '[', scopes: regexpCharacterClassQuotedLiteralContentScopes(quotedDoubleRegexpScope)
      expect(rawStartDoubleQuoted.tokens[5]).toEqual value: '\\"', scopes: regexpCharacterClassQuotedLiteralContentScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php']
      expect(rawStartDoubleQuoted.tokens[6]).toEqual value: ']', scopes: regexpCharacterClassQuotedLiteralContentScopes(quotedDoubleRegexpScope)
      expect(rawStartDoubleQuoted.tokens[7]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedQuotedLiteralTransportScopes(quotedDoubleRegexpScope)
      expect(rawStartDoubleQuoted.tokens[8]).toEqual value: 'E', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.regexp.php']

      expect(decodedStartSingleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(decodedStartSingleQuoted.tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedQuotedLiteralTransportScopes(quotedSingleRegexpScope)
      expect(decodedStartSingleQuoted.tokens[4]).toEqual value: 'Q', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(decodedStartSingleQuoted.tokens[5]).toEqual value: '[', scopes: regexpCharacterClassQuotedLiteralContentScopes(quotedSingleRegexpScope)
      expect(decodedStartSingleQuoted.tokens[6]).toEqual value: '\\\'', scopes: regexpCharacterClassQuotedLiteralContentScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php']
      expect(decodedStartSingleQuoted.tokens[7]).toEqual value: ']', scopes: regexpCharacterClassQuotedLiteralContentScopes(quotedSingleRegexpScope)
      expect(decodedStartSingleQuoted.tokens[8]).toEqual value: '\\E', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']

      expect(rawStartSingleQuoted.tokens[3]).toEqual value: '\\Q', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']
      expect(rawStartSingleQuoted.tokens[4]).toEqual value: '[', scopes: regexpCharacterClassQuotedLiteralContentScopes(quotedSingleRegexpScope)
      expect(rawStartSingleQuoted.tokens[5]).toEqual value: '\\\'', scopes: regexpCharacterClassQuotedLiteralContentScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php']
      expect(rawStartSingleQuoted.tokens[6]).toEqual value: ']', scopes: regexpCharacterClassQuotedLiteralContentScopes(quotedSingleRegexpScope)
      expect(rawStartSingleQuoted.tokens[7]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedQuotedLiteralTransportScopes(quotedSingleRegexpScope)
      expect(rawStartSingleQuoted.tokens[8]).toEqual value: 'E', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(quotedSingleRegexpScope).concat ['constant.character.escape.regexp.php']

  describe 'quoted invalid escapes', ->
    it 'tokenizes closed malformed raw braced hex and octal escapes as invalid in double quoted regexes and classes', ->
      body = '"/' + '\\x{1,2}' + '\\o{abc}/"'
      charClass = '"/[' + '\\x{1,2}' + '\\o{abc}]/"'
      bodyTokens = grammar.tokenizeLine(body).tokens
      classTokens = grammar.tokenizeLine(charClass).tokens

      expect(bodyTokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(bodyTokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(bodyTokens[2]).toEqual value: '\\x{1,2}', scopes: regexpInvalidEscapeScopes(quotedDoubleRegexpScope)
      expect(bodyTokens[3]).toEqual value: '\\o{abc}', scopes: regexpInvalidEscapeScopes(quotedDoubleRegexpScope)
      expect(bodyTokens[4]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(bodyTokens[5]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(classTokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(classTokens[3]).toEqual value: '\\x{1,2}', scopes: regexpCharacterClassInvalidEscapeScopes(quotedDoubleRegexpScope)
      expect(classTokens[4]).toEqual value: '\\o{abc}', scopes: regexpCharacterClassInvalidEscapeScopes(quotedDoubleRegexpScope)
      expect(classTokens[5]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)

    it 'tokenizes closed malformed decoded braced hex and octal escapes as invalid in double quoted regexes and classes', ->
      body = '"/' + '\\'.repeat(2) + 'x{1,2}' + '\\'.repeat(2) + 'o{abc}/"'
      charClass = '"/[' + '\\'.repeat(2) + 'x{1,2}' + '\\'.repeat(2) + 'o{abc}]/"'
      bodyTokens = grammar.tokenizeLine(body).tokens
      classTokens = grammar.tokenizeLine(charClass).tokens

      expect(bodyTokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(bodyTokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(bodyTokens[2]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(quotedDoubleRegexpScope)
      expect(bodyTokens[3]).toEqual value: 'x{1,2}', scopes: regexpInvalidEscapeScopes(quotedDoubleRegexpScope)
      expect(bodyTokens[4]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(quotedDoubleRegexpScope)
      expect(bodyTokens[5]).toEqual value: 'o{abc}', scopes: regexpInvalidEscapeScopes(quotedDoubleRegexpScope)
      expect(bodyTokens[6]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(bodyTokens[7]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(classTokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(classTokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedInvalidTransportScopes(quotedDoubleRegexpScope)
      expect(classTokens[4]).toEqual value: 'x{1,2}', scopes: regexpCharacterClassInvalidEscapeScopes(quotedDoubleRegexpScope)
      expect(classTokens[5]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedInvalidTransportScopes(quotedDoubleRegexpScope)
      expect(classTokens[6]).toEqual value: 'o{abc}', scopes: regexpCharacterClassInvalidEscapeScopes(quotedDoubleRegexpScope)
      expect(classTokens[7]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)

    it 'tokenizes closed malformed raw \\k/\\g forms as invalid in quoted regexes', ->
      invalidForms = ['\\k{}', '\\k{1}', '\\k<١foo>', '\\k<a💩>', '\\g{}', '\\g{1x}', '\\g<💩>', '\\g{a💩}']
      body = '"/' + invalidForms.join('') + '/"'
      tokens = grammar.tokenizeLine(body).tokens

      expect(tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      offset = 2
      for invalidForm in invalidForms
        expect(tokens[offset]).toEqual value: invalidForm, scopes: regexpInvalidEscapeScopes(quotedDoubleRegexpScope)
        offset += 1
      expect(tokens[offset]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[offset + 1]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

    it 'tokenizes closed malformed decoded \\k/\\g forms as invalid in quoted regexes', ->
      invalidPayloads = ['k{}', 'k<١foo>', 'k<a💩>', 'g{}', 'g<💩>', 'g{a💩}']
      body = '"/' + invalidPayloads.map((payload) -> '\\'.repeat(2) + payload).join('') + '/"'
      tokens = grammar.tokenizeLine(body).tokens

      expect(tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      offset = 2
      for payload in invalidPayloads
        expect(tokens[offset]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(quotedDoubleRegexpScope)
        expect(tokens[offset + 1]).toEqual value: payload, scopes: regexpInvalidEscapeScopes(quotedDoubleRegexpScope)
        offset += 2
      expect(tokens[offset]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[offset + 1]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

  describe 'quoted escape mixtures', ->
    it 'should keep valid raw class escapes, stray \\E, short \\x, and invalid ones distinct in quoted regex character classes', ->
      doubleQuoted = grammar.tokenizeLine '"/[\\c;\\pL\\PL\\x\\E\\L\\z\\A\\D\\H\\V\\W]/"'
      singleQuoted = grammar.tokenizeLine "'/[\\c;\\pL\\PL\\x\\E\\L\\z\\A\\D\\H\\V\\W]/'"

      expect(doubleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: '\\c;', scopes: regexpCharacterClassEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[4]).toEqual value: '\\pL', scopes: regexpCharacterClassClassEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[5]).toEqual value: '\\PL', scopes: regexpCharacterClassClassEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[6]).toEqual value: '\\x', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(doubleQuoted.tokens[7]).toEqual value: '\\E', scopes: regexpCharacterClassEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[8]).toEqual value: '\\L', scopes: regexpCharacterClassInvalidEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[9]).toEqual value: '\\z', scopes: regexpCharacterClassInvalidEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[10]).toEqual value: '\\A', scopes: regexpCharacterClassInvalidEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[11]).toEqual value: '\\D', scopes: regexpCharacterClassClassEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[12]).toEqual value: '\\H', scopes: regexpCharacterClassClassEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[13]).toEqual value: '\\V', scopes: regexpCharacterClassClassEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[14]).toEqual value: '\\W', scopes: regexpCharacterClassClassEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[15]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[3]).toEqual value: '\\c;', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[4]).toEqual value: '\\pL', scopes: regexpCharacterClassClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[5]).toEqual value: '\\PL', scopes: regexpCharacterClassClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[6]).toEqual value: '\\x', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(singleQuoted.tokens[7]).toEqual value: '\\E', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[8]).toEqual value: '\\L', scopes: regexpCharacterClassInvalidEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[9]).toEqual value: '\\z', scopes: regexpCharacterClassInvalidEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[10]).toEqual value: '\\A', scopes: regexpCharacterClassInvalidEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[11]).toEqual value: '\\D', scopes: regexpCharacterClassClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[12]).toEqual value: '\\H', scopes: regexpCharacterClassClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[13]).toEqual value: '\\V', scopes: regexpCharacterClassClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[14]).toEqual value: '\\W', scopes: regexpCharacterClassClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[15]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)

    it 'should keep valid decoded class escapes, stray \\\\E, and invalid ones distinct in quoted regex character classes', ->
      doubleQuoted = grammar.tokenizeLine '"/[\\\\c;\\\\pL\\\\PL\\\\E\\\\L\\\\z\\\\A\\\\D\\\\H\\\\V\\\\W]/"'
      singleQuoted = grammar.tokenizeLine "'/[\\\\c;\\\\pL\\\\PL\\\\E\\\\L\\\\z\\\\A\\\\D\\\\H\\\\V\\\\W]/'"

      expect(doubleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedEscapeTransportScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[4]).toEqual value: 'c;', scopes: regexpCharacterClassEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[5]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[6]).toEqual value: 'pL', scopes: regexpCharacterClassClassEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[7]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[8]).toEqual value: 'PL', scopes: regexpCharacterClassClassEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[9]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedEscapeTransportScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[10]).toEqual value: 'E', scopes: regexpCharacterClassEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[11]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedInvalidTransportScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[12]).toEqual value: 'L', scopes: regexpCharacterClassInvalidEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[17]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[18]).toEqual value: 'D', scopes: regexpCharacterClassClassEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[25]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedEscapeTransportScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[4]).toEqual value: 'c;', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[5]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(singleQuoted.tokens[6]).toEqual value: 'pL', scopes: regexpCharacterClassClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[7]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(singleQuoted.tokens[8]).toEqual value: 'PL', scopes: regexpCharacterClassClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[9]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedEscapeTransportScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[10]).toEqual value: 'E', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[11]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedInvalidTransportScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[12]).toEqual value: 'L', scopes: regexpCharacterClassInvalidEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[17]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(singleQuoted.tokens[18]).toEqual value: 'D', scopes: regexpCharacterClassClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[25]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)

    it 'should keep valid raw body escapes, stray \\E, and invalid ones distinct in quoted regexes', ->
      doubleQuoted = grammar.tokenizeLine '"/\\c;\\pL\\E\\L\\g\\k\\o\\p\\u\\z\\A\\B\\G/"'
      singleQuoted = grammar.tokenizeLine "'/\\c;\\pL\\E\\L\\g\\k\\o\\p\\u\\z\\A\\B\\G/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '\\c;', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[3]).toEqual value: '\\pL', scopes: quotedDoubleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[4]).toEqual value: '\\E', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[5]).toEqual value: '\\L', scopes: regexpInvalidEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[6]).toEqual value: '\\g', scopes: regexpInvalidEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[7]).toEqual value: '\\k', scopes: regexpInvalidEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[8]).toEqual value: '\\o', scopes: regexpInvalidEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[9]).toEqual value: '\\p', scopes: regexpInvalidEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[10]).toEqual value: '\\u', scopes: regexpInvalidEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[11]).toEqual value: '\\z', scopes: quotedDoubleRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(doubleQuoted.tokens[12]).toEqual value: '\\A', scopes: quotedDoubleRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(doubleQuoted.tokens[13]).toEqual value: '\\B', scopes: quotedDoubleRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(doubleQuoted.tokens[14]).toEqual value: '\\G', scopes: quotedDoubleRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(doubleQuoted.tokens[15]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[16]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: '\\c;', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[3]).toEqual value: '\\pL', scopes: quotedSingleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(singleQuoted.tokens[4]).toEqual value: '\\E', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[5]).toEqual value: '\\L', scopes: regexpInvalidEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[6]).toEqual value: '\\g', scopes: regexpInvalidEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[7]).toEqual value: '\\k', scopes: regexpInvalidEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[8]).toEqual value: '\\o', scopes: regexpInvalidEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[9]).toEqual value: '\\p', scopes: regexpInvalidEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[10]).toEqual value: '\\u', scopes: regexpInvalidEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[11]).toEqual value: '\\z', scopes: quotedSingleRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(singleQuoted.tokens[12]).toEqual value: '\\A', scopes: quotedSingleRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(singleQuoted.tokens[13]).toEqual value: '\\B', scopes: quotedSingleRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(singleQuoted.tokens[14]).toEqual value: '\\G', scopes: quotedSingleRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(singleQuoted.tokens[15]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[16]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should keep valid decoded body escapes, stray \\\\E, and invalid ones distinct in quoted regexes', ->
      doubleQuoted = grammar.tokenizeLine '"/\\\\c;\\\\pL\\\\E\\\\L\\\\g\\\\k\\\\o\\\\p\\\\u/"'
      singleQuoted = grammar.tokenizeLine "'/\\\\c;\\\\pL\\\\E\\\\L\\\\g\\\\k\\\\o\\\\p\\\\u/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[3]).toEqual value: 'c;', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[4]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[5]).toEqual value: 'pL', scopes: quotedDoubleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(doubleQuoted.tokens[6]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php']
      expect(doubleQuoted.tokens[7]).toEqual value: 'E', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[8]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[9]).toEqual value: 'L', scopes: regexpInvalidEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[18]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[19]).toEqual value: 'u', scopes: regexpInvalidEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[20]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[21]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[3]).toEqual value: 'c;', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[4]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(singleQuoted.tokens[5]).toEqual value: 'pL', scopes: quotedSingleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(singleQuoted.tokens[6]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php']
      expect(singleQuoted.tokens[7]).toEqual value: 'E', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[8]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[9]).toEqual value: 'L', scopes: regexpInvalidEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[18]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[19]).toEqual value: 'u', scopes: regexpInvalidEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[20]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[21]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

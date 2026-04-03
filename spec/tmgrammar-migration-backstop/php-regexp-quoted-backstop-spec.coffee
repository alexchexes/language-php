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
  regexpCharacterClassPhpEscapeScopes
  regexpCharacterClassPosixScopes
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
  regexpGroupScopes
  regexpGroupRecursionScopes
  regexpGroupSubroutineScopes
  regexpGroupNamedSubroutineScopes
  regexpSpecificGroupPunctuationScopes
  regexpGroupNameScopes
  regexpNamedBackreferenceScopes
  regexpNamedBackreferenceNameScopes
  regexpSubroutineScopes
  regexpNamedSubroutineScopes
  regexpNamedSubroutineNameScopes
  regexpDecodedSubroutineTransportScopes
  regexpDecodedNamedSubroutineTransportScopes
  regexpCommentGroupScopes
  regexpDirectiveScopes
  regexpGroupContentScopes
  regexpWildcardScopes
  regexpRangeQuantifierBeginScopes
  regexpRangeQuantifierScopes
  regexpRangeQuantifierEndScopes
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

    it 'should keep operator-looking punctuation literal inside quoted regex character classes', ->
      quotedHosts = [
        [grammar.tokenizeLine('"/[.?+*^$|(){}]/"').tokens, quotedDoubleRegexpScope, '"']
        [grammar.tokenizeLine("'/[.?+*^$|(){}]/'").tokens, quotedSingleRegexpScope, '\'']
      ]

      for [tokens, baseScope, quote] in quotedHosts
        expect(tokens[0]).toEqual value: quote, scopes: regexpWrapperBeginQuoteScopes(baseScope)
        expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(baseScope)
        expect(tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(baseScope)
        for value, i in ['.', '?', '+', '*', '^', '$', '|', '(', ')', '{', '}']
          expect(tokens[i + 3]).toEqual value: value, scopes: regexpCharacterClassLiteralScopes(baseScope)
        expect(tokens[14]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(baseScope)
        expect(tokens[15]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(baseScope)
        expect(tokens[16]).toEqual value: quote, scopes: regexpWrapperEndQuoteScopes(baseScope)

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

  describe 'quoted character-class backslash parity before letter ranges', ->
    it 'should keep interpreted escaped backslashes separate from following letter ranges in quoted regex character classes', ->
      threeBackslashes = '\\'.repeat 3
      doubleQuoted = grammar.tokenizeLine '"/[' + threeBackslashes + 'a-z]/"'
      singleQuoted = grammar.tokenizeLine "'/[" + threeBackslashes + "a-z]/'"

      expect(doubleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php']
      expect(doubleQuoted.tokens[4]).toEqual value: '\\', scopes: regexpCharacterClassEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[5]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[6]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[7]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php']
      expect(singleQuoted.tokens[4]).toEqual value: '\\', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[5]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[6]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[7]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(quotedSingleRegexpScope)

    it 'should keep interpreted backslash parity consistent before letter ranges in quoted regex character classes', ->
      doubleQuotedOne = grammar.tokenizeLine '"/[\\a-z]/"'
      doubleQuotedTwo = grammar.tokenizeLine '"/[\\\\a-z]/"'
      singleQuotedOne = grammar.tokenizeLine "'/[\\a-z]/'"
      singleQuotedTwo = grammar.tokenizeLine "'/[\\\\a-z]/'"

      expect(doubleQuotedOne.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(doubleQuotedOne.tokens[3]).toEqual value: '\\a', scopes: regexpCharacterClassEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuotedOne.tokens[4]).toEqual value: '-', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['keyword.operator.range.regexp.php']
      expect(doubleQuotedOne.tokens[5]).toEqual value: 'z', scopes: regexpCharacterClassLiteralScopes(quotedDoubleRegexpScope)

      expect(doubleQuotedTwo.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedDoubleRegexpScope)
      expect(doubleQuotedTwo.tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(doubleQuotedTwo.tokens[4]).toEqual value: 'a', scopes: regexpCharacterClassEscapeScopes(quotedDoubleRegexpScope)
      expect(doubleQuotedTwo.tokens[5]).toEqual value: '-', scopes: regexpCharacterClassScopes(quotedDoubleRegexpScope).concat ['keyword.operator.range.regexp.php']
      expect(doubleQuotedTwo.tokens[6]).toEqual value: 'z', scopes: regexpCharacterClassLiteralScopes(quotedDoubleRegexpScope)

      expect(singleQuotedOne.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(singleQuotedOne.tokens[3]).toEqual value: '\\a', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuotedOne.tokens[4]).toEqual value: '-', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['keyword.operator.range.regexp.php']
      expect(singleQuotedOne.tokens[5]).toEqual value: 'z', scopes: regexpCharacterClassLiteralScopes(quotedSingleRegexpScope)

      expect(singleQuotedTwo.tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(quotedSingleRegexpScope)
      expect(singleQuotedTwo.tokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(singleQuotedTwo.tokens[4]).toEqual value: 'a', scopes: regexpCharacterClassEscapeScopes(quotedSingleRegexpScope)
      expect(singleQuotedTwo.tokens[5]).toEqual value: '-', scopes: regexpCharacterClassScopes(quotedSingleRegexpScope).concat ['keyword.operator.range.regexp.php']
      expect(singleQuotedTwo.tokens[6]).toEqual value: 'z', scopes: regexpCharacterClassLiteralScopes(quotedSingleRegexpScope)

  describe 'quoted character-class backslash parity for structural payloads', ->
    it 'should keep interpreted backslash parity consistent before POSIX character classes in quoted regex character classes', ->
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

      for {regexScope, wrap} in quotedHosts
        decodedClassEscapeScopes = regexpCharacterClassPhpEscapeScopes(regexScope).concat ['constant.character.escape.regexp.php']
        phpClassEscapeScopes = regexpCharacterClassPhpEscapeScopes(regexScope)

        oneBackslash = grammar.tokenizeLine(wrap '\\[:digit:]]').tokens
        twoBackslashes = grammar.tokenizeLine(wrap '\\'.repeat(2) + '[:digit:]]').tokens
        threeBackslashes = grammar.tokenizeLine(wrap '\\'.repeat(3) + '[:digit:]]').tokens
        fourBackslashes = grammar.tokenizeLine(wrap '\\'.repeat(4) + '[:digit:]]').tokens

        expect(oneBackslash[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
        expect(oneBackslash[3]).toEqual value: '\\[', scopes: regexpCharacterClassEscapeScopes(regexScope)
        expect(oneBackslash[4]).toEqual value: ':', scopes: regexpCharacterClassLiteralScopes(regexScope)
        expect(oneBackslash[11]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)

        expect(twoBackslashes[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
        expect(twoBackslashes[3]).toEqual value: '\\\\', scopes: decodedClassEscapeScopes
        expect(twoBackslashes[4]).toEqual value: '[', scopes: regexpCharacterClassEscapeScopes(regexScope)
        expect(twoBackslashes[5]).toEqual value: ':', scopes: regexpCharacterClassLiteralScopes(regexScope)
        expect(twoBackslashes[12]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)

        expect(threeBackslashes[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
        expect(threeBackslashes[3]).toEqual value: '\\\\', scopes: phpClassEscapeScopes
        expect(threeBackslashes[4]).toEqual value: '\\', scopes: regexpCharacterClassEscapeScopes(regexScope)
        expect(threeBackslashes[5]).toEqual value: '[:', scopes: regexpCharacterClassPosixScopes(regexScope).concat ['punctuation.definition.character-class.set.begin.regexp.php']
        expect(threeBackslashes[7]).toEqual value: ':]', scopes: regexpCharacterClassPosixScopes(regexScope).concat ['punctuation.definition.character-class.set.end.regexp.php']
        expect(threeBackslashes[8]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)

        expect(fourBackslashes[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
        expect(fourBackslashes[3]).toEqual value: '\\\\', scopes: phpClassEscapeScopes
        expect(fourBackslashes[4]).toEqual value: '\\\\', scopes: decodedClassEscapeScopes
        expect(fourBackslashes[5]).toEqual value: '[:', scopes: regexpCharacterClassPosixScopes(regexScope).concat ['punctuation.definition.character-class.set.begin.regexp.php']
        expect(fourBackslashes[7]).toEqual value: ':]', scopes: regexpCharacterClassPosixScopes(regexScope).concat ['punctuation.definition.character-class.set.end.regexp.php']
        expect(fourBackslashes[8]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)

    it 'should keep direct closing-bracket backslash parity consistent in interpreted quoted regex character classes', ->
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

      for {regexScope, wrap} in quotedHosts
        decodedClassEscapeScopes = regexpCharacterClassPhpEscapeScopes(regexScope).concat ['constant.character.escape.regexp.php']
        phpClassEscapeScopes = regexpCharacterClassPhpEscapeScopes(regexScope)

        rawEscaped = grammar.tokenizeLine(wrap '\\]a]').tokens
        decodedEscaped = grammar.tokenizeLine(wrap '\\'.repeat(2) + ']a]').tokens
        threeBackslashes = grammar.tokenizeLine(wrap '\\'.repeat(3) + ']a]').tokens
        fourBackslashes = grammar.tokenizeLine(wrap '\\'.repeat(4) + ']a]').tokens

        expect(rawEscaped[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
        expect(rawEscaped[3]).toEqual value: '\\]', scopes: regexpCharacterClassEscapeScopes(regexScope)
        expect(rawEscaped[4]).toEqual value: 'a', scopes: regexpCharacterClassLiteralScopes(regexScope)
        expect(rawEscaped[5]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)

        expect(decodedEscaped[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
        expect(decodedEscaped[3]).toEqual value: '\\\\', scopes: decodedClassEscapeScopes
        expect(decodedEscaped[4]).toEqual value: ']', scopes: regexpCharacterClassEscapeScopes(regexScope)
        expect(decodedEscaped[5]).toEqual value: 'a', scopes: regexpCharacterClassLiteralScopes(regexScope)
        expect(decodedEscaped[6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)

        expect(threeBackslashes[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
        expect(threeBackslashes[3]).toEqual value: '\\\\', scopes: phpClassEscapeScopes
        expect(threeBackslashes[4]).toEqual value: '\\', scopes: regexpCharacterClassEscapeScopes(regexScope)
        expect(threeBackslashes[5]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
        expect(threeBackslashes[6]).toEqual value: 'a]', scopes: regexScope

        expect(fourBackslashes[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
        expect(fourBackslashes[3]).toEqual value: '\\\\', scopes: phpClassEscapeScopes
        expect(fourBackslashes[4]).toEqual value: '\\\\', scopes: decodedClassEscapeScopes
        expect(fourBackslashes[5]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
        expect(fourBackslashes[6]).toEqual value: 'a]', scopes: regexScope

  describe 'quoted character-class odd-parity literalized payloads', ->
    it 'should literalize non-PHP-owned class payloads after odd interpreted backslash parity in quoted regex character classes', ->
      quotedHosts = [
        {
          regexScope: quotedDoubleRegexpScope
          wrap: (slashes, payload) -> '"/[a' + '\\'.repeat(slashes) + payload + ']/"'
          quoteValue: '"'
        }
        {
          regexScope: quotedSingleRegexpScope
          wrap: (slashes, payload) -> "'/[a" + '\\'.repeat(slashes) + payload + "]/'"
          quoteValue: '\''
        }
      ]
      payloads = ['h', 'i', 'd', 'p', ';', 'c']

      for {regexScope, wrap, quoteValue} in quotedHosts
        for slashCount in [3, 7]
          for payload in payloads
            {tokens} = grammar.tokenizeLine wrap slashCount, payload
            payloadIndex = tokens.findIndex (token) -> token.value is payload

            expect(tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
            expect(tokens.some((token) -> token.value is '\\' + payload)).toBe false
            expect(payloadIndex).to.be.greaterThan 3
            expect(tokens[payloadIndex - 1]).toEqual value: '\\', scopes: regexpCharacterClassEscapeScopes(regexScope)
            expect(tokens[payloadIndex]).toEqual value: payload, scopes: regexpCharacterClassLiteralScopes(regexScope)
            expect(tokens[payloadIndex + 1]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
            expect(tokens[tokens.length - 2]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(regexScope)
            expect(tokens[tokens.length - 1]).toEqual value: quoteValue, scopes: regexpWrapperEndQuoteScopes(regexScope)

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

    it 'should tokenize neutral non-alnum punctuation escapes according to PHP host rules', ->
      # Use `;` as a neutral PCRE "escaped non-alnum" sample because PHP does not consume it specially.
      doubleQuotedRaw = grammar.tokenizeLine "\"/" + "\\;" + "/\""
      doubleQuotedDecoded = grammar.tokenizeLine "\"/" + "\\\\" + ";" + "/\""
      singleQuotedRaw = grammar.tokenizeLine "'/" + "\\;" + "/'"
      singleQuotedDecoded = grammar.tokenizeLine "'/" + "\\\\" + ";" + "/'"

      expect(doubleQuotedRaw.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuotedRaw.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuotedRaw.tokens[2]).toEqual value: '\\;', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(doubleQuotedRaw.tokens[3]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuotedRaw.tokens[4]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(doubleQuotedDecoded.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuotedDecoded.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuotedDecoded.tokens[2]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(doubleQuotedDecoded.tokens[3]).toEqual value: ';', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(doubleQuotedDecoded.tokens[4]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuotedDecoded.tokens[5]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuotedRaw.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuotedRaw.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuotedRaw.tokens[2]).toEqual value: '\\;', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(singleQuotedRaw.tokens[3]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuotedRaw.tokens[4]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

      expect(singleQuotedDecoded.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuotedDecoded.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuotedDecoded.tokens[2]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(singleQuotedDecoded.tokens[3]).toEqual value: ';', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(singleQuotedDecoded.tokens[4]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuotedDecoded.tokens[5]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should decompose repeated interpreted backslashes before neutral punctuation in quoted regexes', ->
      fourBackslashes = '\\'.repeat 4
      doubleQuoted = grammar.tokenizeLine '"/' + fourBackslashes + ';/"'
      singleQuoted = grammar.tokenizeLine "'/" + fourBackslashes + ";/'"

      expect(doubleQuoted.tokens[2]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php']
      expect(doubleQuoted.tokens[3]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(doubleQuoted.tokens[4]).toEqual value: ';', scopes: quotedDoubleRegexpScope

      expect(singleQuoted.tokens[2]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php']
      expect(singleQuoted.tokens[3]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(singleQuoted.tokens[4]).toEqual value: ';', scopes: quotedSingleRegexpScope

    it 'should tokenize supported structural opener parity in interpreted quoted regexes from fixtures', ->
      structuralOpeners = [
        {
          opener: '['
          suffix: 'a]'
          assertStructured: (tokens, regexScope) ->
            expect(tokens[4]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
            expect(tokens[5]).toEqual value: 'a', scopes: regexpCharacterClassLiteralScopes(regexScope)
            expect(tokens[6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
        }
        {
          opener: '('
          suffix: 'a)'
          assertStructured: (tokens, regexScope) ->
            expect(tokens[4]).toEqual value: '(', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
            expect(tokens[5]).toEqual value: 'a', scopes: regexpGroupContentScopes(regexScope)
            expect(tokens[6]).toEqual value: ')', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
        }
        {
          opener: '{'
          suffix: '1}'
          assertStructured: (tokens, regexScope) ->
            expect(tokens[4]).toEqual value: '{', scopes: regexpRangeQuantifierBeginScopes(regexScope)
            expect(tokens[5]).toEqual value: '1', scopes: regexpRangeQuantifierScopes(regexScope)
            expect(tokens[6]).toEqual value: '}', scopes: regexpRangeQuantifierEndScopes(regexScope)
        }
      ]
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

      for {opener, suffix, assertStructured} in structuralOpeners
        for {quoteValue, regexScope, wrap} in quotedHosts
          twoBackslashes = grammar.tokenizeLine wrap '\\'.repeat(2) + opener + suffix
          threeBackslashes = grammar.tokenizeLine wrap '\\'.repeat(3) + opener + suffix
          fourBackslashes = grammar.tokenizeLine wrap '\\'.repeat(4) + opener + suffix

          expect(twoBackslashes.tokens[0]).toEqual value: quoteValue, scopes: regexpWrapperBeginQuoteScopes(regexScope)
          expect(twoBackslashes.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(regexScope)
          expect(twoBackslashes.tokens[2]).toEqual value: '\\\\', scopes: regexScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
          expect(twoBackslashes.tokens[3]).toEqual value: opener, scopes: regexScope.concat ['constant.character.escape.regexp.php']
          expect(twoBackslashes.tokens[4]).toEqual value: suffix, scopes: regexScope
          expect(twoBackslashes.tokens[5]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(regexScope)
          expect(twoBackslashes.tokens[6]).toEqual value: quoteValue, scopes: regexpWrapperEndQuoteScopes(regexScope)

          expect(threeBackslashes.tokens[0]).toEqual value: quoteValue, scopes: regexpWrapperBeginQuoteScopes(regexScope)
          expect(threeBackslashes.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(regexScope)
          expect(threeBackslashes.tokens[2]).toEqual value: '\\\\', scopes: regexScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
          expect(threeBackslashes.tokens[3]).toEqual value: '\\', scopes: regexScope.concat ['constant.character.escape.regexp.php']
          assertStructured threeBackslashes.tokens, regexScope
          expect(threeBackslashes.tokens[7]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(regexScope)
          expect(threeBackslashes.tokens[8]).toEqual value: quoteValue, scopes: regexpWrapperEndQuoteScopes(regexScope)

          expect(fourBackslashes.tokens[0]).toEqual value: quoteValue, scopes: regexpWrapperBeginQuoteScopes(regexScope)
          expect(fourBackslashes.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(regexScope)
          expect(fourBackslashes.tokens[2]).toEqual value: '\\\\', scopes: regexScope.concat ['constant.character.escape.php']
          expect(fourBackslashes.tokens[3]).toEqual value: '\\\\', scopes: regexScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
          assertStructured fourBackslashes.tokens, regexScope
          expect(fourBackslashes.tokens[7]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(regexScope)
          expect(fourBackslashes.tokens[8]).toEqual value: quoteValue, scopes: regexpWrapperEndQuoteScopes(regexScope)

    it 'should keep malformed braced quantifier text plain in quoted regex bodies', ->
      singleQuotedTokens = grammar.tokenizeLine("'/a{}b{,}c{a}d{1a}e{1,2,3}f{,1x}/'").tokens
      doubleQuotedTokens = grammar.tokenizeLine("\"/a{}b{,}c{a}d{1a}e{1,2,3}f{,1x}/\"").tokens
      quotedHosts = [
        [singleQuotedTokens, quotedSingleRegexpScope, '\'']
        [doubleQuotedTokens, quotedDoubleRegexpScope, '"']
      ]

      for [tokens, baseScope, quote] in quotedHosts
        expect(tokens[0]).toEqual value: quote, scopes: regexpWrapperBeginQuoteScopes(baseScope)
        expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(baseScope)
        expect(tokens[2]).toEqual value: 'a{}b{,}c{a}d{1a}e{1,2,3}f{,1x}', scopes: baseScope
        expect(tokens[3]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(baseScope)
        expect(tokens[4]).toEqual value: quote, scopes: regexpWrapperEndQuoteScopes(baseScope)

    it 'should let + quantify a literal opening brace in quoted regex bodies', ->
      doubleQuoted = grammar.tokenizeLine '"/a{+1}/"'
      singleQuoted = grammar.tokenizeLine "'/a{+1}/'"
      doubleQuotedMinus = grammar.tokenizeLine '"/a{-1}/"'
      singleQuotedMinus = grammar.tokenizeLine "'/a{-1}/'"

      expect(doubleQuoted.tokens[2]).toEqual value: 'a{', scopes: quotedDoubleRegexpScope
      expect(doubleQuoted.tokens[3]).toEqual value: '+', scopes: quotedDoubleRegexpScope.concat ['keyword.operator.quantifier.regexp.php']
      expect(doubleQuoted.tokens[4]).toEqual value: '1}', scopes: quotedDoubleRegexpScope
      expect(singleQuoted.tokens[2]).toEqual value: 'a{', scopes: quotedSingleRegexpScope
      expect(singleQuoted.tokens[3]).toEqual value: '+', scopes: quotedSingleRegexpScope.concat ['keyword.operator.quantifier.regexp.php']
      expect(singleQuoted.tokens[4]).toEqual value: '1}', scopes: quotedSingleRegexpScope

      expect(doubleQuotedMinus.tokens[2]).toEqual value: 'a{-1}', scopes: quotedDoubleRegexpScope
      expect(singleQuotedMinus.tokens[2]).toEqual value: 'a{-1}', scopes: quotedSingleRegexpScope

    it 'should tokenize quoted regex range quantifiers without string-only legacy scopes', ->
      singleQuoted = grammar.tokenizeLine "'/a{3,4}+/'"
      doubleQuoted = grammar.tokenizeLine "\"/a{,4}?/\""

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: 'a', scopes: quotedSingleRegexpScope
      expect(singleQuoted.tokens[3]).toEqual value: '{', scopes: regexpRangeQuantifierBeginScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[4]).toEqual value: '3,4', scopes: regexpRangeQuantifierScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[5]).toEqual value: '}', scopes: regexpRangeQuantifierEndScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[6]).toEqual value: '+', scopes: regexpRangeQuantifierScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[7]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[8]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: 'a', scopes: quotedDoubleRegexpScope
      expect(doubleQuoted.tokens[3]).toEqual value: '{', scopes: regexpRangeQuantifierBeginScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[4]).toEqual value: ',4', scopes: regexpRangeQuantifierScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[5]).toEqual value: '}', scopes: regexpRangeQuantifierEndScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[6]).toEqual value: '?', scopes: regexpRangeQuantifierScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[7]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[8]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

    it 'should tokenize richer body escapes and operators in double quoted regexes', ->
      {tokens} = grammar.tokenizeLine '"/^\\d|\\p{L}.+\\x{4A}$/"'

      expect(tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[2]).toEqual value: '^', scopes: quotedDoubleRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(tokens[3]).toEqual value: '\\d', scopes: quotedDoubleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(tokens[4]).toEqual value: '|', scopes: quotedDoubleRegexpScope.concat ['keyword.operator.or.regexp.php']
      expect(tokens[5]).toEqual value: '\\p{L}', scopes: quotedDoubleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(tokens[6]).toEqual value: '.', scopes: regexpWildcardScopes(quotedDoubleRegexpScope)
      expect(tokens[7]).toEqual value: '+', scopes: quotedDoubleRegexpScope.concat ['keyword.operator.quantifier.regexp.php']
      expect(tokens[8]).toEqual value: '\\x{4A}', scopes: quotedDoubleRegexpScope.concat ['constant.character.numeric.regexp.php']
      expect(tokens[9]).toEqual value: '$', scopes: quotedDoubleRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(tokens[10]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[11]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

    it 'should tokenize richer body escapes and operators in single quoted regexes', ->
      {tokens} = grammar.tokenizeLine "'/^\\d|\\pL\\p{L}.+\\x41\\x{4A}$/'"

      expect(tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(tokens[2]).toEqual value: '^', scopes: quotedSingleRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(tokens[3]).toEqual value: '\\d', scopes: quotedSingleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(tokens[4]).toEqual value: '|', scopes: quotedSingleRegexpScope.concat ['keyword.operator.or.regexp.php']
      expect(tokens[5]).toEqual value: '\\pL', scopes: quotedSingleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(tokens[6]).toEqual value: '\\p{L}', scopes: quotedSingleRegexpScope.concat ['constant.character.class.regexp.php']
      expect(tokens[7]).toEqual value: '.', scopes: regexpWildcardScopes(quotedSingleRegexpScope)
      expect(tokens[8]).toEqual value: '+', scopes: quotedSingleRegexpScope.concat ['keyword.operator.quantifier.regexp.php']
      expect(tokens[9]).toEqual value: '\\x41', scopes: quotedSingleRegexpScope.concat ['constant.character.numeric.regexp.php']
      expect(tokens[10]).toEqual value: '\\x{4A}', scopes: quotedSingleRegexpScope.concat ['constant.character.numeric.regexp.php']
      expect(tokens[11]).toEqual value: '$', scopes: quotedSingleRegexpScope.concat ['keyword.control.anchor.regexp.php']

    it 'should keep braced quantifier-like text literal inside quoted regex character classes', ->
      quotedHosts = [
        [grammar.tokenizeLine('"/[{1}]/"').tokens, quotedDoubleRegexpScope, '"']
        [grammar.tokenizeLine("'/[{1}]/'").tokens, quotedSingleRegexpScope, '\'']
      ]

      for [tokens, baseScope, quote] in quotedHosts
        expect(tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(baseScope)
        expect(tokens[3]).toEqual value: '{', scopes: regexpCharacterClassLiteralScopes(baseScope)
        expect(tokens[4]).toEqual value: '1', scopes: regexpCharacterClassScopes(baseScope).concat ['constant.numeric.regexp.php']
        expect(tokens[5]).toEqual value: '}', scopes: regexpCharacterClassLiteralScopes(baseScope)
        expect(tokens[6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(baseScope)
        expect(tokens[7]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(baseScope)
        expect(tokens[8]).toEqual value: quote, scopes: regexpWrapperEndQuoteScopes(baseScope)

    it 'should tokenize angle named groups and classic named backreferences in quoted regexes', ->
      doubleQuoted = grammar.tokenizeLine '"/(?<name>ab)\\k<name>(?P=name)/"'
      singleQuoted = grammar.tokenizeLine "'/(?<name>ab)\\k<name>(?P=name)/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '(', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(doubleQuoted.tokens[3]).toEqual value: '?<', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(quotedDoubleRegexpScope), 'punctuation.definition.group.capture.begin.regexp.php')
      expect(doubleQuoted.tokens[4]).toEqual value: 'name', scopes: regexpGroupNameScopes(regexpGroupScopes(quotedDoubleRegexpScope))
      expect(doubleQuoted.tokens[5]).toEqual value: '>', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(quotedDoubleRegexpScope), 'punctuation.definition.group.capture.end.regexp.php')
      expect(doubleQuoted.tokens[6]).toEqual value: 'ab', scopes: regexpGroupContentScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[7]).toEqual value: ')', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(doubleQuoted.tokens[8]).toEqual value: '\\k', scopes: regexpNamedBackreferenceScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[9]).toEqual value: '<', scopes: regexpNamedBackreferenceScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
      expect(doubleQuoted.tokens[10]).toEqual value: 'name', scopes: regexpNamedBackreferenceNameScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[11]).toEqual value: '>', scopes: regexpNamedBackreferenceScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']
      expect(doubleQuoted.tokens[12]).toEqual value: '(', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(doubleQuoted.tokens[13]).toEqual value: '?P=', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['keyword.other.back-reference.named.regexp.php']
      expect(doubleQuoted.tokens[14]).toEqual value: 'name', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['variable.other.regexp.php']
      expect(doubleQuoted.tokens[15]).toEqual value: ')', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(doubleQuoted.tokens[16]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[17]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: '(', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(singleQuoted.tokens[3]).toEqual value: '?<', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(quotedSingleRegexpScope), 'punctuation.definition.group.capture.begin.regexp.php')
      expect(singleQuoted.tokens[4]).toEqual value: 'name', scopes: regexpGroupNameScopes(regexpGroupScopes(quotedSingleRegexpScope))
      expect(singleQuoted.tokens[5]).toEqual value: '>', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(quotedSingleRegexpScope), 'punctuation.definition.group.capture.end.regexp.php')
      expect(singleQuoted.tokens[6]).toEqual value: 'ab', scopes: regexpGroupContentScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[7]).toEqual value: ')', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(singleQuoted.tokens[8]).toEqual value: '\\k', scopes: regexpNamedBackreferenceScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[9]).toEqual value: '<', scopes: regexpNamedBackreferenceScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
      expect(singleQuoted.tokens[10]).toEqual value: 'name', scopes: regexpNamedBackreferenceNameScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[11]).toEqual value: '>', scopes: regexpNamedBackreferenceScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']
      expect(singleQuoted.tokens[12]).toEqual value: '(', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(singleQuoted.tokens[13]).toEqual value: '?P=', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['keyword.other.back-reference.named.regexp.php']
      expect(singleQuoted.tokens[14]).toEqual value: 'name', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['variable.other.regexp.php']
      expect(singleQuoted.tokens[15]).toEqual value: ')', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(singleQuoted.tokens[16]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[17]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should tokenize braced named backreferences in quoted regexes', ->
      for [tokens, baseScope, quoteValue] in [
        [grammar.tokenizeLine('"/\\k{name}\\g{name}/"').tokens, quotedDoubleRegexpScope, '"']
        [grammar.tokenizeLine("'/\\k{name}\\g{name}/'").tokens, quotedSingleRegexpScope, '\'']
      ]
        expect(tokens[0]).toEqual value: quoteValue, scopes: regexpWrapperBeginQuoteScopes(baseScope)
        expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(baseScope)

        namedBackreferenceScopes = regexpNamedBackreferenceScopes(baseScope)
        expectedTokens = [
          ['\\k', namedBackreferenceScopes]
          ['{', namedBackreferenceScopes.concat ['punctuation.definition.group.capture.begin.regexp.php']]
          ['name', regexpNamedBackreferenceNameScopes(baseScope)]
          ['}', namedBackreferenceScopes.concat ['punctuation.definition.group.capture.end.regexp.php']]
          ['\\g', namedBackreferenceScopes]
          ['{', namedBackreferenceScopes.concat ['punctuation.definition.group.capture.begin.regexp.php']]
          ['name', regexpNamedBackreferenceNameScopes(baseScope)]
          ['}', namedBackreferenceScopes.concat ['punctuation.definition.group.capture.end.regexp.php']]
        ]

        for [i, [value, scopes]] in expectedTokens.entries()
          expect(tokens[i + 2]).toEqual value: value, scopes: scopes

        expect(tokens[10]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(baseScope)
        expect(tokens[11]).toEqual value: quoteValue, scopes: regexpWrapperEndQuoteScopes(baseScope)

    it 'should tokenize decoded named backreferences in interpreted quoted regexes', ->
      doubleQuoted = grammar.tokenizeLine "\"/\\\\k<name>\\\\k'name'/\""
      singleQuoted = grammar.tokenizeLine "'/\\\\k<name>/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'keyword.other.back-reference.named.regexp.php']
      expect(doubleQuoted.tokens[3]).toEqual value: 'k', scopes: regexpNamedBackreferenceScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[4]).toEqual value: '<', scopes: regexpNamedBackreferenceScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
      expect(doubleQuoted.tokens[5]).toEqual value: 'name', scopes: regexpNamedBackreferenceNameScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[6]).toEqual value: '>', scopes: regexpNamedBackreferenceScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']
      expect(doubleQuoted.tokens[7]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'keyword.other.back-reference.named.regexp.php']
      expect(doubleQuoted.tokens[8]).toEqual value: 'k', scopes: regexpNamedBackreferenceScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[9]).toEqual value: '\'', scopes: regexpNamedBackreferenceScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
      expect(doubleQuoted.tokens[10]).toEqual value: 'name', scopes: regexpNamedBackreferenceNameScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[11]).toEqual value: '\'', scopes: regexpNamedBackreferenceScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']
      expect(doubleQuoted.tokens[12]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[13]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'keyword.other.back-reference.named.regexp.php']
      expect(singleQuoted.tokens[3]).toEqual value: 'k', scopes: regexpNamedBackreferenceScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[4]).toEqual value: '<', scopes: regexpNamedBackreferenceScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
      expect(singleQuoted.tokens[5]).toEqual value: 'name', scopes: regexpNamedBackreferenceNameScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[6]).toEqual value: '>', scopes: regexpNamedBackreferenceScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']
      expect(singleQuoted.tokens[7]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[8]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should tokenize decoded braced named backreferences in interpreted quoted regexes', ->
      for [tokens, baseScope, quoteValue] in [
        [grammar.tokenizeLine("\"/\\\\k{name}\\\\g{name}/\"").tokens, quotedDoubleRegexpScope, '"']
        [grammar.tokenizeLine("'/\\\\k{name}\\\\g{name}/'").tokens, quotedSingleRegexpScope, '\'']
      ]
        expect(tokens[0]).toEqual value: quoteValue, scopes: regexpWrapperBeginQuoteScopes(baseScope)
        expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(baseScope)

        decodedNamedBackreferenceLead = baseScope.concat ['constant.character.escape.php', 'keyword.other.back-reference.named.regexp.php']
        namedBackreferenceScopes = regexpNamedBackreferenceScopes(baseScope)
        expectedTokens = [
          ['\\\\', decodedNamedBackreferenceLead]
          ['k', namedBackreferenceScopes]
          ['{', namedBackreferenceScopes.concat ['punctuation.definition.group.capture.begin.regexp.php']]
          ['name', regexpNamedBackreferenceNameScopes(baseScope)]
          ['}', namedBackreferenceScopes.concat ['punctuation.definition.group.capture.end.regexp.php']]
          ['\\\\', decodedNamedBackreferenceLead]
          ['g', namedBackreferenceScopes]
          ['{', namedBackreferenceScopes.concat ['punctuation.definition.group.capture.begin.regexp.php']]
          ['name', regexpNamedBackreferenceNameScopes(baseScope)]
          ['}', namedBackreferenceScopes.concat ['punctuation.definition.group.capture.end.regexp.php']]
        ]

        for [i, [value, scopes]] in expectedTokens.entries()
          expect(tokens[i + 2]).toEqual value: value, scopes: scopes

        expect(tokens[12]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(baseScope)
        expect(tokens[13]).toEqual value: quoteValue, scopes: regexpWrapperEndQuoteScopes(baseScope)

    it 'should tokenize decoded numeric g-style backreferences in interpreted quoted regexes', ->
      for [tokens, baseScope, quoteValue] in [
        [grammar.tokenizeLine("\"/\\\\g1\\\\g{1}\\\\g{-1}/\"").tokens, quotedDoubleRegexpScope, '"']
        [grammar.tokenizeLine("'/\\\\g1\\\\g{1}\\\\g{-1}/'").tokens, quotedSingleRegexpScope, '\'']
      ]
        expect(tokens[0]).toEqual value: quoteValue, scopes: regexpWrapperBeginQuoteScopes(baseScope)
        expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(baseScope)

        decodedNumericBackreferenceLead = baseScope.concat ['constant.character.escape.php', 'keyword.other.back-reference.regexp.php']
        numericBackreferenceScopes = baseScope.concat ['keyword.other.back-reference.regexp.php']
        expectedTokens = [
          ['\\\\', decodedNumericBackreferenceLead]
          ['g', numericBackreferenceScopes]
          ['1', numericBackreferenceScopes.concat ['constant.numeric.regexp.php']]
          ['\\\\', decodedNumericBackreferenceLead]
          ['g', numericBackreferenceScopes]
          ['{', numericBackreferenceScopes.concat ['punctuation.definition.group.capture.begin.regexp.php']]
          ['1', numericBackreferenceScopes.concat ['constant.numeric.regexp.php']]
          ['}', numericBackreferenceScopes.concat ['punctuation.definition.group.capture.end.regexp.php']]
          ['\\\\', decodedNumericBackreferenceLead]
          ['g', numericBackreferenceScopes]
          ['{', numericBackreferenceScopes.concat ['punctuation.definition.group.capture.begin.regexp.php']]
          ['-1', numericBackreferenceScopes.concat ['constant.numeric.regexp.php']]
          ['}', numericBackreferenceScopes.concat ['punctuation.definition.group.capture.end.regexp.php']]
        ]

        for [i, [value, scopes]] in expectedTokens.entries()
          expect(tokens[i + 2]).toEqual value: value, scopes: scopes

        expect(tokens[15]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(baseScope)
        expect(tokens[16]).toEqual value: quoteValue, scopes: regexpWrapperEndQuoteScopes(baseScope)

  describe 'quoted decoded apostrophe-delimited forms', ->
    it 'tokenizes decoded apostrophe-delimited named backreferences in single quoted regexes', ->
      {tokens} = grammar.tokenizeLine "'/\\\\k\\'name\\'/'"

      expect(tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(tokens[2]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'keyword.other.back-reference.named.regexp.php']
      expect(tokens[3]).toEqual value: 'k', scopes: regexpNamedBackreferenceScopes(quotedSingleRegexpScope)
      expect(tokens[4]).toEqual value: '\\\'', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'punctuation.definition.group.capture.begin.regexp.php']
      expect(tokens[5]).toEqual value: 'name', scopes: regexpNamedBackreferenceNameScopes(quotedSingleRegexpScope)
      expect(tokens[6]).toEqual value: '\\\'', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'punctuation.definition.group.capture.end.regexp.php']
      expect(tokens[7]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(tokens[8]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'tokenizes decoded apostrophe-delimited Oniguruma subroutine calls in single quoted regexes', ->
      {tokens} = grammar.tokenizeLine "'/\\\\g\\'word\\'\\\\g\\'+1\\'\\\\g\\'-1\\'/'"

      expect(tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)

      expect(tokens[2]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'keyword.other.subroutine.named.regexp.php']
      expect(tokens[3]).toEqual value: 'g', scopes: regexpNamedSubroutineScopes(quotedSingleRegexpScope)
      expect(tokens[4]).toEqual value: '\\\'', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'punctuation.definition.group.capture.begin.regexp.php']
      expect(tokens[5]).toEqual value: 'word', scopes: regexpNamedSubroutineNameScopes(quotedSingleRegexpScope)
      expect(tokens[6]).toEqual value: '\\\'', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'punctuation.definition.group.capture.end.regexp.php']

      expect(tokens[7]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'keyword.other.subroutine.regexp.php']
      expect(tokens[8]).toEqual value: 'g', scopes: regexpSubroutineScopes(quotedSingleRegexpScope)
      expect(tokens[9]).toEqual value: '\\\'', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'punctuation.definition.group.capture.begin.regexp.php']
      expect(tokens[10]).toEqual value: '+1', scopes: regexpSubroutineScopes(quotedSingleRegexpScope).concat ['constant.numeric.regexp.php']
      expect(tokens[11]).toEqual value: '\\\'', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'punctuation.definition.group.capture.end.regexp.php']

      expect(tokens[12]).toEqual value: '\\\\', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'keyword.other.subroutine.regexp.php']
      expect(tokens[13]).toEqual value: 'g', scopes: regexpSubroutineScopes(quotedSingleRegexpScope)
      expect(tokens[14]).toEqual value: '\\\'', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'punctuation.definition.group.capture.begin.regexp.php']
      expect(tokens[15]).toEqual value: '-1', scopes: regexpSubroutineScopes(quotedSingleRegexpScope).concat ['constant.numeric.regexp.php']
      expect(tokens[16]).toEqual value: '\\\'', scopes: quotedSingleRegexpScope.concat ['constant.character.escape.php', 'punctuation.definition.group.capture.end.regexp.php']

      expect(tokens[17]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(tokens[18]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

  describe 'quoted numeric backreferences', ->
    it 'should tokenize numeric g-style backreferences in quoted regexes', ->
      for [tokens, baseScope, quoteValue] in [
        [grammar.tokenizeLine('"/\\g1\\g{1}\\g{-1}/"').tokens, quotedDoubleRegexpScope, '"']
        [grammar.tokenizeLine("'/\\g1\\g{1}\\g{-1}/'").tokens, quotedSingleRegexpScope, '\'']
      ]
        expect(tokens[0]).toEqual value: quoteValue, scopes: regexpWrapperBeginQuoteScopes(baseScope)
        expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(baseScope)

        numericBackreferenceScopes = baseScope.concat ['keyword.other.back-reference.regexp.php']
        expectedTokens = [
          ['\\g', numericBackreferenceScopes]
          ['1', numericBackreferenceScopes.concat ['constant.numeric.regexp.php']]
          ['\\g', numericBackreferenceScopes]
          ['{', numericBackreferenceScopes.concat ['punctuation.definition.group.capture.begin.regexp.php']]
          ['1', numericBackreferenceScopes.concat ['constant.numeric.regexp.php']]
          ['}', numericBackreferenceScopes.concat ['punctuation.definition.group.capture.end.regexp.php']]
          ['\\g', numericBackreferenceScopes]
          ['{', numericBackreferenceScopes.concat ['punctuation.definition.group.capture.begin.regexp.php']]
          ['-1', numericBackreferenceScopes.concat ['constant.numeric.regexp.php']]
          ['}', numericBackreferenceScopes.concat ['punctuation.definition.group.capture.end.regexp.php']]
        ]

        for [i, [value, scopes]] in expectedTokens.entries()
          expect(tokens[i + 2]).toEqual value: value, scopes: scopes

        expect(tokens[12]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(baseScope)
        expect(tokens[13]).toEqual value: quoteValue, scopes: regexpWrapperEndQuoteScopes(baseScope)

    it 'should keep double quoted numeric backreferences as PHP octal escapes', ->
      {tokens} = grammar.tokenizeLine '"/\\1/"'

      expect(tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[2]).toEqual value: '\\1', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.octal.php']
      expect(tokens[3]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[4]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

    it 'should tokenize the full double quoted raw 8/9 backreference surface', ->
      {tokens} = grammar.tokenizeLine '"/\\8\\9\\80\\99/"'

      expect(tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[2]).toEqual value: '\\', scopes: quotedDoubleRegexpScope.concat ['keyword.other.back-reference.regexp.php']
      expect(tokens[3]).toEqual value: '8', scopes: quotedDoubleRegexpScope.concat ['keyword.other.back-reference.regexp.php', 'constant.numeric.regexp.php']
      expect(tokens[4]).toEqual value: '\\', scopes: quotedDoubleRegexpScope.concat ['keyword.other.back-reference.regexp.php']
      expect(tokens[5]).toEqual value: '9', scopes: quotedDoubleRegexpScope.concat ['keyword.other.back-reference.regexp.php', 'constant.numeric.regexp.php']
      expect(tokens[6]).toEqual value: '\\', scopes: quotedDoubleRegexpScope.concat ['keyword.other.back-reference.regexp.php']
      expect(tokens[7]).toEqual value: '80', scopes: quotedDoubleRegexpScope.concat ['keyword.other.back-reference.regexp.php', 'constant.numeric.regexp.php']
      expect(tokens[8]).toEqual value: '\\', scopes: quotedDoubleRegexpScope.concat ['keyword.other.back-reference.regexp.php']
      expect(tokens[9]).toEqual value: '99', scopes: quotedDoubleRegexpScope.concat ['keyword.other.back-reference.regexp.php', 'constant.numeric.regexp.php']
      expect(tokens[10]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[11]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

  describe 'quoted Unicode named constructs', ->
    it 'should accept Unicode letters and decimal digits in quoted named groups and conditionals', ->
      unicodeName = 'Ж١'
      patternSource = [
        "(?<#{unicodeName}>a)"
        "(?P<#{unicodeName}>a)"
        "(?(<#{unicodeName}>)a|b)"
        "(?(R&#{unicodeName})a|b)"
        "(?(#{unicodeName})a|b)"
      ].join ''
      tokens = grammar.tokenizeLine("\"/#{patternSource}/\"").tokens

      namedTokens = tokens.filter (token) ->
        token.value is unicodeName and token.scopes.includes 'variable.other.regexp.php'

      expect(namedTokens.length).toBe 5

    it 'should keep invalid Unicode-start quoted named groups and conditionals out of name scopes', ->
      startDigitName = '١foo'
      emojiName = '💩'
      patternSource = [
        "(?<#{startDigitName}>a)"
        "(?P<#{emojiName}>a)"
        "(?(#{startDigitName})a|b)"
        "(?(<#{emojiName}>)a|b)"
        "(?(R&#{startDigitName})a|b)"
      ].join ''
      tokens = grammar.tokenizeLine("\"/#{patternSource}/\"").tokens

      expect(tokens.some((token) -> token.value.includes(startDigitName) and token.scopes.includes 'variable.other.regexp.php')).toBe false
      expect(tokens.some((token) -> token.value.includes(emojiName) and token.scopes.includes 'variable.other.regexp.php')).toBe false

    it 'should accept Unicode letters and decimal digits in quoted named refs and subroutines', ->
      unicodeName = 'Ж١'
      patternSource = [
        "\\\\k<#{unicodeName}>"
        "\\\\k{#{unicodeName}}"
        "\\\\g<#{unicodeName}>"
        "\\\\g{#{unicodeName}}"
        "(?&#{unicodeName})"
        "(?P=#{unicodeName})"
        "(?P>#{unicodeName})"
      ].join ''
      tokens = grammar.tokenizeLine("\"/#{patternSource}/\"").tokens

      expect(tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)

      expect(tokens[2]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'keyword.other.back-reference.named.regexp.php']
      expect(tokens[3]).toEqual value: 'k', scopes: regexpNamedBackreferenceScopes(quotedDoubleRegexpScope)
      expect(tokens[4]).toEqual value: '<', scopes: regexpNamedBackreferenceScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
      expect(tokens[5]).toEqual value: unicodeName, scopes: regexpNamedBackreferenceNameScopes(quotedDoubleRegexpScope)
      expect(tokens[6]).toEqual value: '>', scopes: regexpNamedBackreferenceScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']

      expect(tokens[7]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'keyword.other.back-reference.named.regexp.php']
      expect(tokens[8]).toEqual value: 'k', scopes: regexpNamedBackreferenceScopes(quotedDoubleRegexpScope)
      expect(tokens[9]).toEqual value: '{', scopes: regexpNamedBackreferenceScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
      expect(tokens[10]).toEqual value: unicodeName, scopes: regexpNamedBackreferenceNameScopes(quotedDoubleRegexpScope)
      expect(tokens[11]).toEqual value: '}', scopes: regexpNamedBackreferenceScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']

      expect(tokens[12]).toEqual value: '\\\\', scopes: regexpDecodedNamedSubroutineTransportScopes(quotedDoubleRegexpScope)
      expect(tokens[13]).toEqual value: 'g', scopes: regexpNamedSubroutineScopes(quotedDoubleRegexpScope)
      expect(tokens[14]).toEqual value: '<', scopes: regexpNamedSubroutineScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
      expect(tokens[15]).toEqual value: unicodeName, scopes: regexpNamedSubroutineNameScopes(quotedDoubleRegexpScope)
      expect(tokens[16]).toEqual value: '>', scopes: regexpNamedSubroutineScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']

      expect(tokens[17]).toEqual value: '\\\\', scopes: quotedDoubleRegexpScope.concat ['constant.character.escape.php', 'keyword.other.back-reference.named.regexp.php']
      expect(tokens[18]).toEqual value: 'g', scopes: regexpNamedBackreferenceScopes(quotedDoubleRegexpScope)
      expect(tokens[19]).toEqual value: '{', scopes: regexpNamedBackreferenceScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
      expect(tokens[20]).toEqual value: unicodeName, scopes: regexpNamedBackreferenceNameScopes(quotedDoubleRegexpScope)
      expect(tokens[21]).toEqual value: '}', scopes: regexpNamedBackreferenceScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']

      offset = 22
      for head in ['?&', '?P=', '?P>']
        expect(tokens[offset]).toEqual value: '(', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
        if head is '?P='
          expect(tokens[offset + 1]).toEqual value: head, scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['keyword.other.back-reference.named.regexp.php']
        else
          expect(tokens[offset + 1]).toEqual value: head, scopes: regexpGroupNamedSubroutineScopes(quotedDoubleRegexpScope)
        expect(tokens[offset + 2]).toEqual value: unicodeName, scopes: (if head is '?P=' then regexpGroupScopes(quotedDoubleRegexpScope) else regexpGroupNamedSubroutineScopes(quotedDoubleRegexpScope)).concat ['variable.other.regexp.php']
        expect(tokens[offset + 3]).toEqual value: ')', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
        offset += 4

      expect(tokens[offset]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(tokens[offset + 1]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

    it 'accepts Unicode letters and decimal digits in apostrophe-delimited single quoted regex source forms', ->
      unicodeName = 'Ж١'
      {tokens} = grammar.tokenizeLine "'/(?\\'#{unicodeName}\\'a)(?(\\'#{unicodeName}\\')a|b)/';"

      namedTokens = tokens.filter (token) ->
        token.value is unicodeName and token.scopes.includes 'variable.other.regexp.php'

      expect(namedTokens.length).toBe 2

  it 'keeps invalid Unicode-start apostrophe-delimited single quoted regex source forms out of name scopes', ->
    invalidName = '١foo'
    {tokens} = grammar.tokenizeLine "'/(?\\'#{invalidName}\\'a)(?(\\'#{invalidName}\\')a|b)/';"

    expect(tokens.some((token) -> token.value.includes(invalidName) and token.scopes.includes 'variable.other.regexp.php')).toBe false

  describe 'quoted option groups', ->
    it 'should tokenize full option-group payloads in quoted regexes', ->
      optionPayload = 'im-sxADJUXunr'
      doubleQuoted = grammar.tokenizeLine '"/(?' + optionPayload + ':ab)/"'
      singleQuoted = grammar.tokenizeLine "'/(?" + optionPayload + ":ab)/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '(', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(doubleQuoted.tokens[3]).toEqual value: '?', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(quotedDoubleRegexpScope), 'punctuation.definition.group.option.regexp.php')
      expect(doubleQuoted.tokens[4]).toEqual value: optionPayload, scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['storage.modifier.regexp.php']
      expect(doubleQuoted.tokens[5]).toEqual value: ':', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(quotedDoubleRegexpScope), 'punctuation.definition.group.option.regexp.php')
      expect(doubleQuoted.tokens[6]).toEqual value: 'ab', scopes: regexpGroupContentScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[7]).toEqual value: ')', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(doubleQuoted.tokens[8]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[9]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: '(', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(singleQuoted.tokens[3]).toEqual value: '?', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(quotedSingleRegexpScope), 'punctuation.definition.group.option.regexp.php')
      expect(singleQuoted.tokens[4]).toEqual value: optionPayload, scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['storage.modifier.regexp.php']
      expect(singleQuoted.tokens[5]).toEqual value: ':', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(quotedSingleRegexpScope), 'punctuation.definition.group.option.regexp.php')
      expect(singleQuoted.tokens[6]).toEqual value: 'ab', scopes: regexpGroupContentScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[7]).toEqual value: ')', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(singleQuoted.tokens[8]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[9]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

  describe 'quoted start directives', ->
    it 'should tokenize start directives in quoted regexes', ->
      expectedDirectives = ['*UTF', '*UCP', '*NO_START_OPT', '*LIMIT_MATCH=10', '*CRLF', '*BSR_UNICODE']
      directiveSource = expectedDirectives.map((directive) -> "(#{directive})").join ''
      doubleQuoted = grammar.tokenizeLine "\"/#{directiveSource}/\""
      singleQuoted = grammar.tokenizeLine "'/#{directiveSource}/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      offset = 2
      for directive in expectedDirectives
        expect(doubleQuoted.tokens[offset]).toEqual value: '(', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
        expect(doubleQuoted.tokens[offset + 1]).toEqual value: directive, scopes: regexpDirectiveScopes(quotedDoubleRegexpScope)
        expect(doubleQuoted.tokens[offset + 2]).toEqual value: ')', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
        offset += 3
      expect(doubleQuoted.tokens[offset]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[offset + 1]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      offset = 2
      for directive in expectedDirectives
        expect(singleQuoted.tokens[offset]).toEqual value: '(', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
        expect(singleQuoted.tokens[offset + 1]).toEqual value: directive, scopes: regexpDirectiveScopes(quotedSingleRegexpScope)
        expect(singleQuoted.tokens[offset + 2]).toEqual value: ')', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
        offset += 3
      expect(singleQuoted.tokens[offset]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[offset + 1]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

  describe 'quoted subroutines and recursion', ->
    it 'should tokenize recursion and subroutine calls in quoted regexes', ->
      groupExpectations = [
        ['recursion', '?R']
        ['recursion', '?0']
        ['numeric', '?', '1']
        ['numeric', '?', '+1']
        ['numeric', '?', '-1']
        ['named', '?&', 'word']
        ['named', '?P>', 'word']
      ]
      groupSource = groupExpectations.map(([kind, head, payload]) ->
        switch kind
          when 'recursion' then "(#{head})"
          else "(#{head}#{payload})"
      ).join ''
      gExpectations = [
        ['named', '<', 'word', '>']
        ['named', '\'', 'word', '\'']
        ['numeric', '<', '1', '>']
        ['numeric', '<', '+1', '>']
        ['numeric', '\'', '-1', '\'']
      ]
      doubleGSource = gExpectations.map(([, beginPunctuation, payload, endPunctuation]) -> "\\g#{beginPunctuation}#{payload}#{endPunctuation}").join ''
      singleGSource = [
        ['named', '<', 'word', '>']
        ['numeric', '<', '1', '>']
        ['numeric', '<', '+1', '>']
        ['numeric', '<', '-1', '>']
      ].map(([, beginPunctuation, payload, endPunctuation]) -> "\\g#{beginPunctuation}#{payload}#{endPunctuation}").join ''
      doubleQuoted = grammar.tokenizeLine "\"/#{groupSource}#{doubleGSource}/\""
      singleQuoted = grammar.tokenizeLine "'/#{groupSource}#{singleGSource}/'"

      for [tokens, baseScope, useSingleQuotedGForms] in [
        [doubleQuoted.tokens, quotedDoubleRegexpScope, true]
        [singleQuoted.tokens, quotedSingleRegexpScope, false]
      ]
        quote = if baseScope is quotedDoubleRegexpScope then '"' else '\''
        expect(tokens[0]).toEqual value: quote, scopes: regexpWrapperBeginQuoteScopes(baseScope)
        expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(baseScope)

        offset = 2
        for [kind, head, payload] in groupExpectations
          expect(tokens[offset]).toEqual value: '(', scopes: regexpGroupScopes(baseScope).concat ['punctuation.definition.group.regexp.php']
          if kind is 'recursion'
            expect(tokens[offset + 1]).toEqual value: head, scopes: regexpGroupRecursionScopes(baseScope)
            expect(tokens[offset + 2]).toEqual value: ')', scopes: regexpGroupScopes(baseScope).concat ['punctuation.definition.group.regexp.php']
            offset += 3
          else if kind is 'numeric'
            expect(tokens[offset + 1]).toEqual value: head, scopes: regexpGroupSubroutineScopes(baseScope)
            expect(tokens[offset + 2]).toEqual value: payload, scopes: regexpGroupSubroutineScopes(baseScope).concat ['constant.numeric.regexp.php']
            expect(tokens[offset + 3]).toEqual value: ')', scopes: regexpGroupScopes(baseScope).concat ['punctuation.definition.group.regexp.php']
            offset += 4
          else
            expect(tokens[offset + 1]).toEqual value: head, scopes: regexpGroupNamedSubroutineScopes(baseScope)
            expect(tokens[offset + 2]).toEqual value: payload, scopes: regexpGroupNamedSubroutineScopes(baseScope).concat ['variable.other.regexp.php']
            expect(tokens[offset + 3]).toEqual value: ')', scopes: regexpGroupScopes(baseScope).concat ['punctuation.definition.group.regexp.php']
            offset += 4

        hostGExpectations = if useSingleQuotedGForms
          gExpectations
        else
          [
            ['named', '<', 'word', '>']
            ['numeric', '<', '1', '>']
            ['numeric', '<', '+1', '>']
            ['numeric', '<', '-1', '>']
          ]

        for [kind, beginPunctuation, payload, endPunctuation] in hostGExpectations
          if kind is 'named'
            expect(tokens[offset]).toEqual value: '\\g', scopes: regexpNamedSubroutineScopes(baseScope)
            expect(tokens[offset + 1]).toEqual value: beginPunctuation, scopes: regexpNamedSubroutineScopes(baseScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
            expect(tokens[offset + 2]).toEqual value: payload, scopes: regexpNamedSubroutineNameScopes(baseScope)
            expect(tokens[offset + 3]).toEqual value: endPunctuation, scopes: regexpNamedSubroutineScopes(baseScope).concat ['punctuation.definition.group.capture.end.regexp.php']
          else
            expect(tokens[offset]).toEqual value: '\\g', scopes: regexpSubroutineScopes(baseScope)
            expect(tokens[offset + 1]).toEqual value: beginPunctuation, scopes: regexpSubroutineScopes(baseScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
            expect(tokens[offset + 2]).toEqual value: payload, scopes: regexpSubroutineScopes(baseScope).concat ['constant.numeric.regexp.php']
            expect(tokens[offset + 3]).toEqual value: endPunctuation, scopes: regexpSubroutineScopes(baseScope).concat ['punctuation.definition.group.capture.end.regexp.php']
          offset += 4

        expect(tokens[offset]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(baseScope)
        expect(tokens[offset + 1]).toEqual value: quote, scopes: regexpWrapperEndQuoteScopes(baseScope)

    it 'should tokenize decoded Oniguruma subroutine calls in interpreted quoted regexes', ->
      doubleQuoted = grammar.tokenizeLine "\"/#{[
        "\\\\g<word>"
        "\\\\g'word'"
        "\\\\g<1>"
        "\\\\g<+1>"
        "\\\\g'-1'"
      ].join ''}/\""
      singleQuoted = grammar.tokenizeLine "'/#{[
        "\\\\g<word>"
        "\\\\g<1>"
        "\\\\g<+1>"
        "\\\\g<-1>"
      ].join ''}/'"

      for [tokens, baseScope, useSingleQuotedGForms] in [
        [doubleQuoted.tokens, quotedDoubleRegexpScope, true]
        [singleQuoted.tokens, quotedSingleRegexpScope, false]
      ]
        quote = if baseScope is quotedDoubleRegexpScope then '"' else '\''
        expect(tokens[0]).toEqual value: quote, scopes: regexpWrapperBeginQuoteScopes(baseScope)
        expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(baseScope)

        hostGExpectations = if useSingleQuotedGForms
          [
            ['named', '<', 'word', '>']
            ['named', '\'', 'word', '\'']
            ['numeric', '<', '1', '>']
            ['numeric', '<', '+1', '>']
            ['numeric', '\'', '-1', '\'']
          ]
        else
          [
            ['named', '<', 'word', '>']
            ['numeric', '<', '1', '>']
            ['numeric', '<', '+1', '>']
            ['numeric', '<', '-1', '>']
          ]

        offset = 2
        for [kind, beginPunctuation, payload, endPunctuation] in hostGExpectations
          if kind is 'named'
            expect(tokens[offset]).toEqual value: '\\\\', scopes: regexpDecodedNamedSubroutineTransportScopes(baseScope)
            expect(tokens[offset + 1]).toEqual value: 'g', scopes: regexpNamedSubroutineScopes(baseScope)
            expect(tokens[offset + 2]).toEqual value: beginPunctuation, scopes: regexpNamedSubroutineScopes(baseScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
            expect(tokens[offset + 3]).toEqual value: payload, scopes: regexpNamedSubroutineNameScopes(baseScope)
            expect(tokens[offset + 4]).toEqual value: endPunctuation, scopes: regexpNamedSubroutineScopes(baseScope).concat ['punctuation.definition.group.capture.end.regexp.php']
          else
            expect(tokens[offset]).toEqual value: '\\\\', scopes: regexpDecodedSubroutineTransportScopes(baseScope)
            expect(tokens[offset + 1]).toEqual value: 'g', scopes: regexpSubroutineScopes(baseScope)
            expect(tokens[offset + 2]).toEqual value: beginPunctuation, scopes: regexpSubroutineScopes(baseScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
            expect(tokens[offset + 3]).toEqual value: payload, scopes: regexpSubroutineScopes(baseScope).concat ['constant.numeric.regexp.php']
            expect(tokens[offset + 4]).toEqual value: endPunctuation, scopes: regexpSubroutineScopes(baseScope).concat ['punctuation.definition.group.capture.end.regexp.php']
          offset += 5

        expect(tokens[offset]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(baseScope)
        expect(tokens[offset + 1]).toEqual value: quote, scopes: regexpWrapperEndQuoteScopes(baseScope)

  describe 'quoted comment groups', ->
    it 'should tokenize comment groups in quoted regex strings', ->
      doubleQuoted = grammar.tokenizeLine '"/(?#comment)/"'
      singleQuoted = grammar.tokenizeLine "'/(?#comment)/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[2]).toEqual value: '(', scopes: regexpCommentGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.comment.begin.regexp.php']
      expect(doubleQuoted.tokens[3]).toEqual value: '?#', scopes: regexpCommentGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.comment.begin.regexp.php']
      expect(doubleQuoted.tokens[4]).toEqual value: 'comment', scopes: regexpCommentGroupScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[5]).toEqual value: ')', scopes: regexpCommentGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.comment.end.regexp.php']
      expect(doubleQuoted.tokens[6]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[7]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[2]).toEqual value: '(', scopes: regexpCommentGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.comment.begin.regexp.php']
      expect(singleQuoted.tokens[3]).toEqual value: '?#', scopes: regexpCommentGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.comment.begin.regexp.php']
      expect(singleQuoted.tokens[4]).toEqual value: 'comment', scopes: regexpCommentGroupScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[5]).toEqual value: ')', scopes: regexpCommentGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.comment.end.regexp.php']
      expect(singleQuoted.tokens[6]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[7]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

  describe 'quoted special groups', ->
    it 'should tokenize script-run groups in quoted regexes', ->
      expectedGroups = [
        ['*sr:', 'ab', 'punctuation.definition.group.script-run.regexp.php']
        ['*script_run:', 'cd', 'punctuation.definition.group.script-run.regexp.php']
        ['*asr:', 'ef', 'punctuation.definition.group.atomic-script-run.regexp.php']
        ['*atomic_script_run:', 'gh', 'punctuation.definition.group.atomic-script-run.regexp.php']
      ]
      groupSource = expectedGroups.map(([opener, content]) -> "(#{opener}#{content})").join ''
      doubleQuoted = grammar.tokenizeLine "\"/#{groupSource}/\""
      singleQuoted = grammar.tokenizeLine "'/#{groupSource}/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      doubleOffset = 2
      for [opener, content, specificScope] in expectedGroups
        expect(doubleQuoted.tokens[doubleOffset]).toEqual value: '(', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
        expect(doubleQuoted.tokens[doubleOffset + 1]).toEqual value: opener, scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(quotedDoubleRegexpScope), specificScope)
        expect(doubleQuoted.tokens[doubleOffset + 2]).toEqual value: content, scopes: regexpGroupContentScopes(quotedDoubleRegexpScope)
        expect(doubleQuoted.tokens[doubleOffset + 3]).toEqual value: ')', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
        doubleOffset += 4
      expect(doubleQuoted.tokens[doubleOffset]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[doubleOffset + 1]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      singleOffset = 2
      for [opener, content, specificScope] in expectedGroups
        expect(singleQuoted.tokens[singleOffset]).toEqual value: '(', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
        expect(singleQuoted.tokens[singleOffset + 1]).toEqual value: opener, scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(quotedSingleRegexpScope), specificScope)
        expect(singleQuoted.tokens[singleOffset + 2]).toEqual value: content, scopes: regexpGroupContentScopes(quotedSingleRegexpScope)
        expect(singleQuoted.tokens[singleOffset + 3]).toEqual value: ')', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
        singleOffset += 4
      expect(singleQuoted.tokens[singleOffset]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[singleOffset + 1]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

    it 'should tokenize atomic and branch-reset groups in quoted regexes', ->
      expectedGroups = [
        ['?>', 'ab', 'punctuation.definition.group.atomic.regexp.php']
        ['*atomic:', 'cd', 'punctuation.definition.group.atomic.regexp.php']
        ['?|', 'ef', 'punctuation.definition.group.branch-reset.regexp.php']
      ]
      groupSource = expectedGroups.map(([opener, content]) -> "(#{opener}#{content})").join ''
      doubleQuoted = grammar.tokenizeLine "\"/#{groupSource}/\""
      singleQuoted = grammar.tokenizeLine "'/#{groupSource}/'"

      expect(doubleQuoted.tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
      doubleOffset = 2
      for [opener, content, specificScope] in expectedGroups
        expect(doubleQuoted.tokens[doubleOffset]).toEqual value: '(', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
        expect(doubleQuoted.tokens[doubleOffset + 1]).toEqual value: opener, scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(quotedDoubleRegexpScope), specificScope)
        expect(doubleQuoted.tokens[doubleOffset + 2]).toEqual value: content, scopes: regexpGroupContentScopes(quotedDoubleRegexpScope)
        expect(doubleQuoted.tokens[doubleOffset + 3]).toEqual value: ')', scopes: regexpGroupScopes(quotedDoubleRegexpScope).concat ['punctuation.definition.group.regexp.php']
        doubleOffset += 4
      expect(doubleQuoted.tokens[doubleOffset]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
      expect(doubleQuoted.tokens[doubleOffset + 1]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

      expect(singleQuoted.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
      singleOffset = 2
      for [opener, content, specificScope] in expectedGroups
        expect(singleQuoted.tokens[singleOffset]).toEqual value: '(', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
        expect(singleQuoted.tokens[singleOffset + 1]).toEqual value: opener, scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(quotedSingleRegexpScope), specificScope)
        expect(singleQuoted.tokens[singleOffset + 2]).toEqual value: content, scopes: regexpGroupContentScopes(quotedSingleRegexpScope)
        expect(singleQuoted.tokens[singleOffset + 3]).toEqual value: ')', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
        singleOffset += 4
      expect(singleQuoted.tokens[singleOffset]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedSingleRegexpScope)
      expect(singleQuoted.tokens[singleOffset + 1]).toEqual value: '\'', scopes: regexpWrapperEndQuoteScopes(quotedSingleRegexpScope)

describe 'PHP regexp single-quoted source apostrophe forms', ->
  grammar = null
  before(-> grammar = await loadGrammar('source.php'))

  it 'tokenizes apostrophe-delimited backreferences and subroutine calls in single quoted regex source', ->
    {tokens} = grammar.tokenizeLine "'/\\k\\'name\\'\\g\\'word\\'\\g\\'+1\\'\\g\\'-1\\'/';"

    expect(tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
    expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)

    expect(tokens[2]).toEqual value: '\\k', scopes: regexpNamedBackreferenceScopes(quotedSingleRegexpScope)
    expect(tokens[3]).toEqual value: '\\\'', scopes: regexpNamedBackreferenceScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'punctuation.definition.group.capture.begin.regexp.php']
    expect(tokens[4]).toEqual value: 'name', scopes: regexpNamedBackreferenceNameScopes(quotedSingleRegexpScope)
    expect(tokens[5]).toEqual value: '\\\'', scopes: regexpNamedBackreferenceScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'punctuation.definition.group.capture.end.regexp.php']

    expect(tokens[6]).toEqual value: '\\g', scopes: regexpNamedSubroutineScopes(quotedSingleRegexpScope)
    expect(tokens[7]).toEqual value: '\\\'', scopes: regexpNamedSubroutineScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'punctuation.definition.group.capture.begin.regexp.php']
    expect(tokens[8]).toEqual value: 'word', scopes: regexpNamedSubroutineNameScopes(quotedSingleRegexpScope)
    expect(tokens[9]).toEqual value: '\\\'', scopes: regexpNamedSubroutineScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'punctuation.definition.group.capture.end.regexp.php']

    expect(tokens[10]).toEqual value: '\\g', scopes: regexpSubroutineScopes(quotedSingleRegexpScope)
    expect(tokens[11]).toEqual value: '\\\'', scopes: regexpSubroutineScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'punctuation.definition.group.capture.begin.regexp.php']
    expect(tokens[12]).toEqual value: '+1', scopes: regexpSubroutineScopes(quotedSingleRegexpScope).concat ['constant.numeric.regexp.php']
    expect(tokens[13]).toEqual value: '\\\'', scopes: regexpSubroutineScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'punctuation.definition.group.capture.end.regexp.php']

    expect(tokens[14]).toEqual value: '\\g', scopes: regexpSubroutineScopes(quotedSingleRegexpScope)
    expect(tokens[15]).toEqual value: '\\\'', scopes: regexpSubroutineScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'punctuation.definition.group.capture.begin.regexp.php']
    expect(tokens[16]).toEqual value: '-1', scopes: regexpSubroutineScopes(quotedSingleRegexpScope).concat ['constant.numeric.regexp.php']
    expect(tokens[17]).toEqual value: '\\\'', scopes: regexpSubroutineScopes(quotedSingleRegexpScope).concat ['constant.character.escape.php', 'punctuation.definition.group.capture.end.regexp.php']

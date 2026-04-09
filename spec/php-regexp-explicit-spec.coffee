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

describe 'PHP explicit regexp grammar', ->
  grammar = null
  before(-> grammar = await loadGrammar('source.php'))

  it 'parses the grammar', ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe 'source.php'

  describe 'PHP transport scopes in explicit regex hosts', ->
    # These tests only lock in the PHP transport layer for doubled backslashes.
    # More specific regex meaning is covered in the explicit-host feature tests below.
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
    it 'should split doubled class backslashes between PHP transport and regex escapes in REGEXP heredoc', ->
      bodyTokens = grammar.tokenizeLines('''
        $a = <<<REGEXP
        /[\\\\\\\\]/
        REGEXP;
      ''')[1]

      expect(bodyTokens[0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(bodyTokens[1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(bodyTokens[2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php']
      expect(bodyTokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(bodyTokens[4]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(bodyTokens[5]).toEqual value: '/', scopes: heredocRegexpScope

    it 'should tokenize escaped `[` in REGEXP nowdoc', ->
      bodyTokens = grammar.tokenizeLines('''
        $a = <<<'REGEXP'
        /\\[/
        REGEXP;
      ''')[1]

      expect(bodyTokens[0]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(bodyTokens[1]).toEqual value: '\\[', scopes: nowdocRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(bodyTokens[2]).toEqual value: '/', scopes: nowdocRegexpScope

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

    for {description, opener, label, regexScope, terminatorScope, sourceSurface} in [
      {
        description: 'REGEX heredoc'
        opener: '<<<REGEX'
        label: 'REGEX'
        regexScope: heredocRegexpScope
        terminatorScope: heredocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.heredoc.php']
        sourceSurface: 'interpreted'
      }
      {
        description: 'REGEXP nowdoc'
        opener: '<<<\'REGEXP\''
        label: 'REGEXP'
        regexScope: nowdocRegexpScope
        terminatorScope: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.nowdoc.php']
        sourceSurface: 'raw'
      }
    ]
      do (description, opener, label, regexScope, terminatorScope, sourceSurface) ->
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
          expect(lines[1][4]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(regexScope)
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
          expect(lines[1][3]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(regexScope)
          expect(lines[1][4]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(regexScope)
          expect(lines[1][5]).toEqual value: 'Q', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[1][6]).toEqual value: 'x', scopes: regexpCharacterClassLetterRangeScopes(regexScope)
          expect(lines[1][7]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(regexScope)
          expect(lines[1][8]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(regexScope)
          expect(lines[1][9]).toEqual value: '0', scopes: regexpCharacterClassDigitRangeScopes(regexScope).concat ['constant.numeric.regexp.php']
          expect(lines[1][10]).toEqual value: '-', scopes: regexpCharacterClassDigitRangeScopes(regexScope).concat ['keyword.operator.range.regexp.php']
          expect(lines[1][11]).toEqual value: '9', scopes: regexpCharacterClassDigitRangeScopes(regexScope).concat ['constant.numeric.regexp.php']
          expect(lines[1][12]).toEqual value: '#', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[1][13]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][14]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should treat a leading closing bracket as literal class content in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /[]a-z]/
            /[^]a-z]/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][2]).toEqual value: ']', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[1][3]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(regexScope)
          expect(lines[1][4]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(regexScope)
          expect(lines[1][5]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(regexScope)
          expect(lines[1][6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][7]).toEqual value: '/', scopes: regexScope

          expect(lines[2][0]).toEqual value: '/', scopes: regexScope
          expect(lines[2][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[2][2]).toEqual value: '^', scopes: regexpCharacterClassBoundaryNegationScopes(regexScope)
          expect(lines[2][3]).toEqual value: ']', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[2][4]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(regexScope)
          expect(lines[2][5]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(regexScope)
          expect(lines[2][6]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(regexScope)
          expect(lines[2][7]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[2][8]).toEqual value: '/', scopes: regexScope
          expect(lines[3][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[3][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize generic literal ranges in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /[!-~а-я😀-🤓Q]/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][2]).toEqual value: '!', scopes: regexpCharacterClassGenericRangeScopes(regexScope)
          expect(lines[1][3]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(regexScope)
          expect(lines[1][4]).toEqual value: '~', scopes: regexpCharacterClassGenericRangeScopes(regexScope)
          expect(lines[1][5]).toEqual value: 'а', scopes: regexpCharacterClassGenericRangeScopes(regexScope)
          expect(lines[1][6]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(regexScope)
          expect(lines[1][7]).toEqual value: 'я', scopes: regexpCharacterClassGenericRangeScopes(regexScope)
          expect(lines[1][8]).toEqual value: '😀', scopes: regexpCharacterClassGenericRangeScopes(regexScope)
          expect(lines[1][9]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(regexScope)
          expect(lines[1][10]).toEqual value: '🤓', scopes: regexpCharacterClassGenericRangeScopes(regexScope)
          expect(lines[1][11]).toEqual value: 'Q', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[1][12]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][13]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        if sourceSurface is 'raw'
          it 'should tokenize raw class range families and numeric literals in REGEXP nowdoc', ->
            lines = grammar.tokenizeLines """
              $r = #{opener}
              /[A-Za-z0-9\\x1-\\x4\\x{41}-\\x{4F}\\1-\\3\\001-\\003123]/
              #{label};
            """

            expect(lines[1][0]).toEqual value: '/', scopes: regexScope
            expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
            expect(lines[1][2]).toEqual value: 'A', scopes: regexpCharacterClassLetterRangeScopes(regexScope)
            expect(lines[1][3]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(regexScope)
            expect(lines[1][4]).toEqual value: 'Z', scopes: regexpCharacterClassLetterRangeScopes(regexScope)
            expect(lines[1][5]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(regexScope)
            expect(lines[1][6]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(regexScope)
            expect(lines[1][7]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(regexScope)
            expect(lines[1][8]).toEqual value: '0', scopes: regexpCharacterClassRangeScopes(regexScope).concat ['constant.numeric.regexp.php']
            expect(lines[1][9]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(regexScope)
            expect(lines[1][10]).toEqual value: '9', scopes: regexpCharacterClassRangeScopes(regexScope).concat ['constant.numeric.regexp.php']
            expect(lines[1][11]).toEqual value: '\\x1', scopes: regexpCharacterClassHexRangeScopes(regexScope).concat ['constant.character.numeric.regexp.php']
            expect(lines[1][12]).toEqual value: '-', scopes: regexpCharacterClassHexRangeScopes(regexScope).concat ['keyword.operator.range.regexp.php']
            expect(lines[1][13]).toEqual value: '\\x4', scopes: regexpCharacterClassHexRangeScopes(regexScope).concat ['constant.character.numeric.regexp.php']
            expect(lines[1][14]).toEqual value: '\\x{41}', scopes: regexpCharacterClassHexRangeScopes(regexScope).concat ['constant.character.numeric.regexp.php']
            expect(lines[1][15]).toEqual value: '-', scopes: regexpCharacterClassHexRangeScopes(regexScope).concat ['keyword.operator.range.regexp.php']
            expect(lines[1][16]).toEqual value: '\\x{4F}', scopes: regexpCharacterClassHexRangeScopes(regexScope).concat ['constant.character.numeric.regexp.php']
            expect(lines[1][17]).toEqual value: '\\1', scopes: regexpCharacterClassRangeScopes(regexScope).concat ['constant.numeric.octal.regexp.php']
            expect(lines[1][18]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(regexScope)
            expect(lines[1][19]).toEqual value: '\\3', scopes: regexpCharacterClassRangeScopes(regexScope).concat ['constant.numeric.octal.regexp.php']
            expect(lines[1][20]).toEqual value: '\\001', scopes: regexpCharacterClassRangeScopes(regexScope).concat ['constant.numeric.octal.regexp.php']
            expect(lines[1][21]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(regexScope)
            expect(lines[1][22]).toEqual value: '\\003', scopes: regexpCharacterClassRangeScopes(regexScope).concat ['constant.numeric.octal.regexp.php']
            expect(lines[1][23]).toEqual value: '123', scopes: regexpCharacterClassScopes(regexScope).concat ['constant.numeric.regexp.php']
            expect(lines[1][24]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
            expect(lines[1][25]).toEqual value: '/', scopes: regexScope
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
            /[a[b]/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][2]).toEqual value: 'a', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[1][3]).toEqual value: '[', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[1][4]).toEqual value: 'b', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[1][5]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][6]).toEqual value: '/', scopes: regexScope
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

          it 'should keep interpolation after interpreted backslash transport in REGEX heredoc bodies', ->
            [2, 4, 6, 8].forEach (slashes) ->
              expectedBackslashes = interpretedTransportBackslashScopes heredocRegexpScope, slashes
              lines = grammar.tokenizeLines [
                '$r = <<<REGEX'
                '/' + '\\'.repeat(slashes) + '$a/'
                'REGEX;'
              ].join "\n"

              expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
              for scopes, i in expectedBackslashes
                expect(lines[1][i + 1]).toEqual value: '\\\\', scopes: scopes
              variableIndex = expectedBackslashes.length + 1
              expect(lines[1][variableIndex]).toEqual value: '$', scopes: heredocRegexpScope.concat ['variable.other.php', 'punctuation.definition.variable.php']
              expect(lines[1][variableIndex + 1]).toEqual value: 'a', scopes: heredocRegexpScope.concat ['variable.other.php']
              expect(lines[1][variableIndex + 2]).toEqual value: '/', scopes: heredocRegexpScope

        it "should tokenize regex-only character-type and property escapes in #{description}", ->
          expectedTypes = if sourceSurface is 'interpreted'
            [
              ['\\d', regexScope.concat ['constant.character.class.regexp.php']]
              ['\\D', regexScope.concat ['constant.character.class.regexp.php']]
              ['\\w', regexScope.concat ['constant.character.class.regexp.php']]
              ['\\W', regexScope.concat ['constant.character.class.regexp.php']]
              ['\\s', regexScope.concat ['constant.character.class.regexp.php']]
              ['\\S', regexScope.concat ['constant.character.class.regexp.php']]
              ['\\h', regexScope.concat ['constant.character.class.regexp.php']]
              ['\\H', regexScope.concat ['constant.character.class.regexp.php']]
              ['\\v', regexScope.concat ['constant.character.escape.php']]
              ['\\V', regexScope.concat ['constant.character.class.regexp.php']]
              ['\\R', regexScope.concat ['constant.character.class.regexp.php']]
            ]
          else
            [
              ['\\d', regexScope.concat ['constant.character.class.regexp.php']]
              ['\\D', regexScope.concat ['constant.character.class.regexp.php']]
              ['\\w', regexScope.concat ['constant.character.class.regexp.php']]
              ['\\W', regexScope.concat ['constant.character.class.regexp.php']]
              ['\\s', regexScope.concat ['constant.character.class.regexp.php']]
              ['\\S', regexScope.concat ['constant.character.class.regexp.php']]
              ['\\h', regexScope.concat ['constant.character.class.regexp.php']]
              ['\\H', regexScope.concat ['constant.character.class.regexp.php']]
              ['\\v', regexScope.concat ['constant.character.class.regexp.php']]
              ['\\V', regexScope.concat ['constant.character.class.regexp.php']]
              ['\\R', regexScope.concat ['constant.character.class.regexp.php']]
            ]
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /#{expectedTypes.map(([type]) -> type).join ''}\\pL\\PL\\p{L}\\P{N}/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          offset = 1
          for [type, scopes] in expectedTypes
            expect(lines[1][offset]).toEqual value: type, scopes: scopes
            offset += 1
          expect(lines[1][offset]).toEqual value: '\\pL', scopes: regexScope.concat ['constant.character.class.regexp.php']
          expect(lines[1][offset + 1]).toEqual value: '\\PL', scopes: regexScope.concat ['constant.character.class.regexp.php']
          expect(lines[1][offset + 2]).toEqual value: '\\p{L}', scopes: regexScope.concat ['constant.character.class.regexp.php']
          expect(lines[1][offset + 3]).toEqual value: '\\P{N}', scopes: regexScope.concat ['constant.character.class.regexp.php']
          expect(lines[1][offset + 4]).toEqual value: '/', scopes: regexScope
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

        if sourceSurface is 'raw'
          it "should keep dot operators and anchors after escaped backslashes in #{description}", ->
            lines = grammar.tokenizeLines """
              $r = #{opener}
              /\\\\.$/
              #{label};
            """

            expect(lines[1][0]).toEqual value: '/', scopes: regexScope
            expect(lines[1][1]).toEqual value: '\\\\', scopes: regexScope.concat ['constant.character.escape.regexp.php']
            expect(lines[1][2]).toEqual value: '.', scopes: regexpWildcardScopes(regexScope)
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

        if sourceSurface is 'raw'
          it 'should tokenize one-digit hex ranges inside character classes in REGEXP nowdoc', ->
            lines = grammar.tokenizeLines """
              $r = #{opener}
              /[\\x1-\\x4]/
              #{label};
            """

            expect(lines[1][0]).toEqual value: '/', scopes: regexScope
            expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
            expect(lines[1][2]).toEqual value: '\\x1', scopes: regexpCharacterClassHexRangeScopes(regexScope).concat ['constant.character.numeric.regexp.php']
            expect(lines[1][3]).toEqual value: '-', scopes: regexpCharacterClassHexRangeScopes(regexScope).concat ['keyword.operator.range.regexp.php']
            expect(lines[1][4]).toEqual value: '\\x4', scopes: regexpCharacterClassHexRangeScopes(regexScope).concat ['constant.character.numeric.regexp.php']
            expect(lines[1][5]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
            expect(lines[1][6]).toEqual value: '/', scopes: regexScope
            expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
            expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize braced octal escapes inside character classes in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /[\\o{141}]/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][2]).toEqual value: '\\o{141}', scopes: regexpCharacterClassOctalScopes(regexScope)
          expect(lines[1][3]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][4]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize Unicode code point escapes inside character classes in #{description}", ->
          body = if sourceSurface is 'raw' then '/[\\N{U+41}]/' else '/[\\\\N{U+41}]/'
          lines = grammar.tokenizeLines """
            $r = #{opener}
            #{body}
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          if sourceSurface is 'raw'
            expect(lines[1][2]).toEqual value: '\\N{U+41}', scopes: regexpCharacterClassScopes(regexScope).concat ['constant.character.numeric.regexp.php']
            expect(lines[1][3]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
            expect(lines[1][4]).toEqual value: '/', scopes: regexScope
          else
            expect(lines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(regexScope).concat ['constant.character.escape.php', 'constant.character.numeric.regexp.php']
            expect(lines[1][3]).toEqual value: 'N{U+41}', scopes: regexpCharacterClassScopes(regexScope).concat ['constant.character.numeric.regexp.php']
            expect(lines[1][4]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
            expect(lines[1][5]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        if sourceSurface is 'raw'
          it "should not treat doubled backslashes as backreferences or character-type escapes in #{description}", ->
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

        if sourceSurface is 'interpreted'
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

          it 'should decompose repeated interpreted backslashes inside REGEX heredoc character classes', ->
            fourBackslashes = '\\'.repeat 4
            lines = grammar.tokenizeLines ['$r = <<<REGEX', '/[' + fourBackslashes + 'a-z]/', 'REGEX;'].join "\n"

            expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
            expect(lines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php']
            expect(lines[1][3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
            expect(lines[1][4]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(heredocRegexpScope)

          it 'should treat decoded \\c before end-of-line as invalid in REGEX heredoc', ->
            lines = grammar.tokenizeLines '''
              $r = <<<REGEX
              /\\\\c
              REGEX;
            '''

            expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
            expect(lines[1][1]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(heredocRegexpScope)
            expect(lines[1][2]).toEqual value: 'c', scopes: regexpInvalidEscapeScopes(heredocRegexpScope)
            expect(lines[2][0]).toEqual value: 'REGEX', scopes: heredocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.heredoc.php']

          it 'should tokenize the full decoded invalid body escape surface in REGEX heredoc', ->
            lines = grammar.tokenizeLines '''
              $r = <<<REGEX
              /\\\\g;\\\\k;\\\\i;\\\\l;\\\\m;\\\\q;\\\\u;\\\\y;\\\\F;\\\\I;\\\\L;\\\\M;\\\\O;\\\\T;\\\\U;\\\\Y;\\\\o;\\\\p;\\\\P;/
              REGEX;
            '''

            expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
            invalids = ['g', 'k', 'i', 'l', 'm', 'q', 'u', 'y', 'F', 'I', 'L', 'M', 'O', 'T', 'U', 'Y', 'o', 'p', 'P']
            offset = 1
            for invalid, i in invalids
              separator = if i is invalids.length - 1 then ';/' else ';'
              expect(lines[1][offset]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(heredocRegexpScope)
              expect(lines[1][offset + 1]).toEqual value: invalid, scopes: regexpInvalidEscapeScopes(heredocRegexpScope)
              expect(lines[1][offset + 2]).toEqual value: separator, scopes: heredocRegexpScope
              offset += 3

          it 'should not let decoded \\\\c consume the regex terminator in REGEX heredoc', ->
            lines = grammar.tokenizeLines '''
              $r = <<<REGEX
              /\\\\c/
              REGEX;
            '''

            expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
            expect(lines[1][1]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(heredocRegexpScope)
            expect(lines[1][2]).toEqual value: 'c', scopes: regexpInvalidEscapeScopes(heredocRegexpScope)
            expect(lines[1][3]).toEqual value: '/', scopes: heredocRegexpScope

          it 'should tokenize decoded body escapes \\\\C, \\\\N, and \\\\X in REGEX heredoc', ->
            lines = grammar.tokenizeLines '''
              $r = <<<REGEX
              /\\\\C\\\\N\\\\X/
              REGEX;
            '''

            expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
            expect(lines[1][1]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
            expect(lines[1][2]).toEqual value: 'C', scopes: heredocRegexpScope.concat ['constant.character.class.regexp.php']
            expect(lines[1][3]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
            expect(lines[1][4]).toEqual value: 'N', scopes: heredocRegexpScope.concat ['constant.character.class.regexp.php']
            expect(lines[1][5]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
            expect(lines[1][6]).toEqual value: 'X', scopes: heredocRegexpScope.concat ['constant.character.class.regexp.php']
            expect(lines[1][7]).toEqual value: '/', scopes: heredocRegexpScope

          it 'should tokenize decoded body escape \\\\K in REGEX heredoc', ->
            lines = grammar.tokenizeLines '''
              $r = <<<REGEX
              /\\\\K/
              REGEX;
            '''

            expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
            expect(lines[1][1]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php']
            expect(lines[1][2]).toEqual value: 'K', scopes: regexpControlKeywordScopes(heredocRegexpScope)
            expect(lines[1][3]).toEqual value: '/', scopes: heredocRegexpScope

          it 'should tokenize the reachable decoded body literal-escape surface in REGEX heredoc', ->
            lines = grammar.tokenizeLines '''
              $r = <<<REGEX
              /\\\\a;\\\\n;\\\\r;\\\\t;\\\\f;\\\\e;\\\\$/
              REGEX;
            '''

            expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
            offset = 1
            escapeChars = ['a', 'n', 'r', 't', 'f', 'e', '$']
            for escapeChar, i in escapeChars
              separator = if i is escapeChars.length - 1 then '/' else ';'
              expect(lines[1][offset]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
              expect(lines[1][offset + 1]).toEqual value: escapeChar, scopes: heredocRegexpScope.concat ['constant.character.escape.regexp.php']
              expect(lines[1][offset + 2]).toEqual value: separator, scopes: heredocRegexpScope
              offset += 3

        if sourceSurface is 'raw'
          it 'should treat raw \\c before end-of-line as invalid in REGEXP nowdoc', ->
            lines = grammar.tokenizeLines '''
              $r = <<<'REGEXP'
              /\\c
              REGEXP;
            '''

            expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
            expect(lines[1][1]).toEqual value: '\\c', scopes: regexpInvalidEscapeScopes(nowdocRegexpScope)
            expect(lines[2][0]).toEqual value: 'REGEXP', scopes: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.nowdoc.php']

          it 'should tokenize the full raw invalid body escape surface in REGEXP nowdoc', ->
            lines = grammar.tokenizeLines '''
              $r = <<<'REGEXP'
              /\\g;\\k;\\i;\\l;\\m;\\q;\\u;\\y;\\F;\\I;\\L;\\M;\\O;\\T;\\U;\\Y;\\o;\\p;\\P;/
              REGEXP;
            '''

            expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
            invalids = ['\\g', '\\k', '\\i', '\\l', '\\m', '\\q', '\\u', '\\y', '\\F', '\\I', '\\L', '\\M', '\\O', '\\T', '\\U', '\\Y', '\\o', '\\p', '\\P']
            offset = 1
            for invalid, i in invalids
              separator = if i is invalids.length - 1 then ';/' else ';'
              expect(lines[1][offset]).toEqual value: invalid, scopes: regexpInvalidEscapeScopes(nowdocRegexpScope)
              expect(lines[1][offset + 1]).toEqual value: separator, scopes: nowdocRegexpScope
              offset += 2

          it 'should not let raw \\c consume the regex terminator in REGEXP nowdoc', ->
            lines = grammar.tokenizeLines '''
              $r = <<<'REGEXP'
              /\\c/
              REGEXP;
            '''

            expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
            expect(lines[1][1]).toEqual value: '\\c', scopes: regexpInvalidEscapeScopes(nowdocRegexpScope)
            expect(lines[1][2]).toEqual value: '/', scopes: nowdocRegexpScope

          it 'should tokenize raw body escapes \\C, \\N, and \\X in REGEXP nowdoc', ->
            lines = grammar.tokenizeLines '''
              $r = <<<'REGEXP'
              /\\C\\N\\X/
              REGEXP;
            '''

            expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
            expect(lines[1][1]).toEqual value: '\\C', scopes: nowdocRegexpScope.concat ['constant.character.class.regexp.php']
            expect(lines[1][2]).toEqual value: '\\N', scopes: nowdocRegexpScope.concat ['constant.character.class.regexp.php']
            expect(lines[1][3]).toEqual value: '\\X', scopes: nowdocRegexpScope.concat ['constant.character.class.regexp.php']
            expect(lines[1][4]).toEqual value: '/', scopes: nowdocRegexpScope

          it 'should tokenize raw body escape \\K in REGEXP nowdoc', ->
            lines = grammar.tokenizeLines '''
              $r = <<<'REGEXP'
              /\\K/
              REGEXP;
            '''

            expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
            expect(lines[1][1]).toEqual value: '\\K', scopes: regexpControlKeywordScopes(nowdocRegexpScope)
            expect(lines[1][2]).toEqual value: '/', scopes: nowdocRegexpScope

          it 'should tokenize representative raw literal-escape categories in REGEXP nowdoc', ->
            body = '/' + '\\'.repeat(2) + '\\c~\\e\\f\\n\\r\\t\\;/'
            lines = grammar.tokenizeLines [
              "$r = <<<'REGEXP'"
              body
              'REGEXP;'
            ].join "\n"

            expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
            expect(lines[1][1]).toEqual value: '\\\\', scopes: nowdocRegexpScope.concat ['constant.character.escape.regexp.php']
            expect(lines[1][2]).toEqual value: '\\c~', scopes: nowdocRegexpScope.concat ['constant.character.escape.regexp.php']
            expect(lines[1][3]).toEqual value: '\\e', scopes: nowdocRegexpScope.concat ['constant.character.escape.regexp.php']
            expect(lines[1][4]).toEqual value: '\\f', scopes: nowdocRegexpScope.concat ['constant.character.escape.regexp.php']
            expect(lines[1][5]).toEqual value: '\\n', scopes: nowdocRegexpScope.concat ['constant.character.escape.regexp.php']
            expect(lines[1][6]).toEqual value: '\\r', scopes: nowdocRegexpScope.concat ['constant.character.escape.regexp.php']
            expect(lines[1][7]).toEqual value: '\\t', scopes: nowdocRegexpScope.concat ['constant.character.escape.regexp.php']
            expect(lines[1][8]).toEqual value: '\\;', scopes: nowdocRegexpScope.concat ['constant.character.escape.regexp.php']
            expect(lines[1][9]).toEqual value: '/', scopes: nowdocRegexpScope

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

      expect(lines[1][17]).toEqual value: '|', scopes: nestedQuotedDoubleRegexpGroupContentScopes.concat ['keyword.operator.or.regexp.php']
      expect(lines[1][18]).toEqual value: '\\d', scopes: nestedQuotedDoubleRegexpGroupContentScopes.concat ['constant.character.class.regexp.php']
      expect(lines[1][19]).toEqual value: '+', scopes: nestedQuotedDoubleRegexpGroupContentScopes.concat ['keyword.operator.quantifier.regexp.php']

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
      expect(lines[1][6]).toEqual value: '\\d', scopes: regexpCharacterClassClassEscapeScopes(heredocRegexpScope)
      expect(lines[1][7]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][8]).toEqual value: '/', scopes: heredocRegexpScope

    it 'should keep interpolation after interpreted backslash transport in REGEXP heredoc character classes', ->
      [2, 4, 6, 8].forEach (slashes) ->
        expectedBackslashes = interpretedTransportBackslashScopes regexpCharacterClassScopes(heredocRegexpScope), slashes
        lines = grammar.tokenizeLines [
          '$r = <<<REGEXP'
          '/[' + '\\'.repeat(slashes) + '$a]/'
          'REGEXP;'
        ].join "\n"

        expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
        expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
        for scopes, i in expectedBackslashes
          expect(lines[1][i + 2]).toEqual value: '\\\\', scopes: scopes
        variableIndex = expectedBackslashes.length + 2
        expect(lines[1][variableIndex]).toEqual value: '$', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['variable.other.php', 'punctuation.definition.variable.php']
        expect(lines[1][variableIndex + 1]).toEqual value: 'a', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['variable.other.php']
        expect(lines[1][variableIndex + 2]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
        expect(lines[1][variableIndex + 3]).toEqual value: '/', scopes: heredocRegexpScope

    it 'should tokenize decoded backspace and short hex escapes in REGEXP heredoc character classes', ->
      lines = grammar.tokenizeLines '''
        $r = <<<REGEXP
        /[\\\\b\\\\x]/
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedEscapeTransportScopes(heredocRegexpScope)
      expect(lines[1][3]).toEqual value: 'b', scopes: regexpCharacterClassEscapeScopes(heredocRegexpScope)
      expect(lines[1][4]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedNumericTransportScopes(heredocRegexpScope)
      expect(lines[1][5]).toEqual value: 'x', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(lines[1][6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][7]).toEqual value: '/', scopes: heredocRegexpScope

    it 'should literalize odd decoded backslashes before x and u in REGEXP heredoc character classes', ->
      for payload in ['x', 'u']
        lines = grammar.tokenizeLines ['$r = <<<REGEXP', '/[' + '\\'.repeat(3) + payload + ']/', 'REGEXP;'].join "\n"

        expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
        expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
        expect(lines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassPhpEscapeScopes(heredocRegexpScope)
        expect(lines[1][3]).toEqual value: '\\', scopes: regexpCharacterClassEscapeScopes(heredocRegexpScope)
        expect(lines[1][4]).toEqual value: payload, scopes: regexpCharacterClassLiteralScopes(heredocRegexpScope)
        expect(lines[1][5]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
        expect(lines[1][6]).toEqual value: '/', scopes: heredocRegexpScope

    it 'should tokenize decoded bell escapes in REGEXP heredoc character classes', ->
      lines = grammar.tokenizeLines '''
        $r = <<<REGEXP
        /[\\\\a]/
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(lines[1][3]).toEqual value: 'a', scopes: regexpCharacterClassEscapeScopes(heredocRegexpScope)
      expect(lines[1][4]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][5]).toEqual value: '/', scopes: heredocRegexpScope

    it 'should tokenize the full decoded class literal-escape surface in REGEXP heredoc character classes', ->
      lines = grammar.tokenizeLines '''
        $r = <<<REGEXP
        /[\\\\a\\\\E\\\\n\\\\r\\\\t\\\\f\\\\e\\\\$]/
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      offset = 2
      for escapeChar in ['a', 'E', 'n', 'r', 't', 'f', 'e', '$']
        expect(lines[1][offset]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedEscapeTransportScopes(heredocRegexpScope)
        expect(lines[1][offset + 1]).toEqual value: escapeChar, scopes: regexpCharacterClassEscapeScopes(heredocRegexpScope)
        offset += 2
      expect(lines[1][offset]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][offset + 1]).toEqual value: '/', scopes: heredocRegexpScope

    it 'should tokenize the full decoded class octal surface in REGEXP heredoc character classes', ->
      lines = grammar.tokenizeLines '''
        $r = <<<REGEXP
        /[\\\\0\\\\7\\\\00\\\\77\\\\000\\\\777]/
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      offset = 2
      for octal in ['0', '7', '00', '77', '000', '777']
        expect(lines[1][offset]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.numeric.octal.regexp.php']
        expect(lines[1][offset + 1]).toEqual value: octal, scopes: regexpCharacterClassOctalScopes(heredocRegexpScope)
        offset += 2
      expect(lines[1][offset]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][offset + 1]).toEqual value: '/', scopes: heredocRegexpScope

    it 'should tokenize decoded property, braced hex, and braced octal escapes in REGEXP heredoc character classes', ->
      lines = grammar.tokenizeLines '''
        $r = <<<REGEXP
        /[\\\\pL\\\\PL\\\\p{L}\\\\P{N}\\\\x{41}\\\\o{141}]/
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(lines[1][3]).toEqual value: 'pL', scopes: regexpCharacterClassClassEscapeScopes(heredocRegexpScope)
      expect(lines[1][4]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(lines[1][5]).toEqual value: 'PL', scopes: regexpCharacterClassClassEscapeScopes(heredocRegexpScope)
      expect(lines[1][6]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(lines[1][7]).toEqual value: 'p{L}', scopes: regexpCharacterClassClassEscapeScopes(heredocRegexpScope)
      expect(lines[1][8]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(lines[1][9]).toEqual value: 'P{N}', scopes: regexpCharacterClassClassEscapeScopes(heredocRegexpScope)
      expect(lines[1][10]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.character.numeric.regexp.php']
      expect(lines[1][11]).toEqual value: 'x{41}', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(lines[1][12]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.numeric.octal.regexp.php']
      expect(lines[1][13]).toEqual value: 'o{141}', scopes: regexpCharacterClassOctalScopes(heredocRegexpScope)
      expect(lines[1][14]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][15]).toEqual value: '/', scopes: heredocRegexpScope

    it 'should tokenize decoded \\N, \\o, \\p, and \\P as invalid in REGEXP heredoc character classes', ->
      lines = grammar.tokenizeLines '''
        $r = <<<REGEXP
        /[\\\\N\\\\o\\\\p\\\\P]/
        REGEXP;
      '''
      expectedPayloads = ['N', 'o', 'p', 'P']

      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      for value, index in expectedPayloads
        tokenOffset = 2 + index * 2
        expect(lines[1][tokenOffset]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedInvalidTransportScopes(heredocRegexpScope)
        expect(lines[1][tokenOffset + 1]).toEqual value: value, scopes: regexpCharacterClassInvalidEscapeScopes(heredocRegexpScope)
      expect(lines[1][10]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][11]).toEqual value: '/', scopes: heredocRegexpScope

    it 'should tokenize the reachable decoded class invalid-escape surface in REGEXP heredoc character classes', ->
      lines = grammar.tokenizeLines '''
        $r = <<<REGEXP
        /[\\\\i;\\\\l;\\\\m;\\\\q;\\\\u;\\\\y;\\\\z;\\\\A;\\\\B;\\\\C;\\\\F;\\\\G;\\\\I;\\\\K;\\\\L;\\\\M;\\\\O;\\\\T;\\\\U;\\\\X;\\\\Y;\\\\Z;\\\\N;\\\\o;\\\\p;\\\\P;]/
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      invalidPayloads = ['i', 'l', 'm', 'q', 'u', 'y', 'z', 'A', 'B', 'C', 'F', 'G', 'I', 'K', 'L', 'M', 'O', 'T', 'U', 'X', 'Y', 'Z', 'N', 'o', 'p', 'P']
      offset = 2
      for payload in invalidPayloads
        expect(lines[1][offset]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedInvalidTransportScopes(heredocRegexpScope)
        expect(lines[1][offset + 1]).toEqual value: payload, scopes: regexpCharacterClassInvalidEscapeScopes(heredocRegexpScope)
        expect(lines[1][offset + 2]).toEqual value: ';', scopes: regexpCharacterClassLiteralScopes(heredocRegexpScope)
        offset += 3
      expect(lines[1][offset]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][offset + 1]).toEqual value: '/', scopes: heredocRegexpScope

    it 'should treat decoded \\c before the REGEXP heredoc terminator as invalid inside character classes', ->
      lines = grammar.tokenizeLines '''
        $r = <<<REGEXP
        /[\\\\c
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedInvalidTransportScopes(heredocRegexpScope)
      expect(lines[1][3]).toEqual value: 'c', scopes: regexpCharacterClassInvalidEscapeScopes(heredocRegexpScope)

    it 'should tokenize interpreted braced hex ranges in REGEXP heredoc character classes', ->
      rangeScopes = regexpCharacterClassHexRangeScopes(heredocRegexpScope)
      decodedTransportScopes = rangeScopes.concat ['constant.character.escape.php', 'constant.character.numeric.regexp.php']
      numericRangeScopes = rangeScopes.concat ['constant.character.numeric.regexp.php']
      rangeOperatorScopes = rangeScopes.concat ['keyword.operator.range.regexp.php']

      rawDecodedLines = grammar.tokenizeLines ['$r = <<<REGEXP', '/[\\x{42}-' + '\\'.repeat(2) + 'x{44}]/', 'REGEXP;'].join "\n"
      decodedRawLines = grammar.tokenizeLines ['$r = <<<REGEXP', '/[' + '\\'.repeat(2) + 'x{42}-\\x{44}]/', 'REGEXP;'].join "\n"
      decodedBothLines = grammar.tokenizeLines ['$r = <<<REGEXP', '/[' + '\\'.repeat(2) + 'x{42}-' + '\\'.repeat(2) + 'x{44}]/', 'REGEXP;'].join "\n"

      expect(rawDecodedLines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(rawDecodedLines[1][2]).toEqual value: '\\x{42}', scopes: numericRangeScopes
      expect(rawDecodedLines[1][3]).toEqual value: '-', scopes: rangeOperatorScopes
      expect(rawDecodedLines[1][4]).toEqual value: '\\\\', scopes: decodedTransportScopes
      expect(rawDecodedLines[1][5]).toEqual value: 'x{44}', scopes: numericRangeScopes
      expect(rawDecodedLines[1][6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)

      expect(decodedRawLines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(decodedRawLines[1][2]).toEqual value: '\\\\', scopes: decodedTransportScopes
      expect(decodedRawLines[1][3]).toEqual value: 'x{42}', scopes: numericRangeScopes
      expect(decodedRawLines[1][4]).toEqual value: '-', scopes: rangeOperatorScopes
      expect(decodedRawLines[1][5]).toEqual value: '\\x{44}', scopes: numericRangeScopes
      expect(decodedRawLines[1][6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)

      expect(decodedBothLines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(decodedBothLines[1][2]).toEqual value: '\\\\', scopes: decodedTransportScopes
      expect(decodedBothLines[1][3]).toEqual value: 'x{42}', scopes: numericRangeScopes
      expect(decodedBothLines[1][4]).toEqual value: '-', scopes: rangeOperatorScopes
      expect(decodedBothLines[1][5]).toEqual value: '\\\\', scopes: decodedTransportScopes
      expect(decodedBothLines[1][6]).toEqual value: 'x{44}', scopes: numericRangeScopes
      expect(decodedBothLines[1][7]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)

    it 'should tokenize raw double-quote escapes in REGEXP heredoc character classes', ->
      lines = grammar.tokenizeLines ["$r = <<<REGEXP", '/[\\"a-z]/', 'REGEXP;'].join "\n"

      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][2]).toEqual value: '\\"', scopes: regexpCharacterClassEscapeScopes(heredocRegexpScope)
      expect(lines[1][3]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(heredocRegexpScope)
      expect(lines[1][4]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(heredocRegexpScope)
      expect(lines[1][5]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(heredocRegexpScope)
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

    it 'should tokenize representative raw class literal-escape categories in REGEXP nowdoc character classes', ->
      lines = grammar.tokenizeLines [
        "$r = <<<'REGEXP'"
        '/[\\c~\\E\\;\\\\]/'
        'REGEXP;'
      ].join "\n"

      expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(lines[1][2]).toEqual value: '\\c~', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
      expect(lines[1][3]).toEqual value: '\\E', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
      expect(lines[1][4]).toEqual value: '\\;', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
      expect(lines[1][5]).toEqual value: '\\\\', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
      expect(lines[1][6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(lines[1][7]).toEqual value: '/', scopes: nowdocRegexpScope

    it 'should tokenize raw \\N, \\o, \\p, and \\P as invalid in REGEXP nowdoc character classes', ->
      lines = grammar.tokenizeLines '''
        $r = <<<'REGEXP'
        /[\\N\\o\\p\\P]/
        REGEXP;
      '''
      expectedEscapes = ['\\N', '\\o', '\\p', '\\P']

      expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      for value, index in expectedEscapes
        expect(lines[1][2 + index]).toEqual value: value, scopes: regexpCharacterClassInvalidEscapeScopes(nowdocRegexpScope)
      expect(lines[1][6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(lines[1][7]).toEqual value: '/', scopes: nowdocRegexpScope

    it 'should tokenize the reachable raw class invalid-escape surface in REGEXP nowdoc character classes', ->
      lines = grammar.tokenizeLines '''
        $r = <<<'REGEXP'
        /[\\i;\\l;\\m;\\q;\\u;\\y;\\z;\\A;\\B;\\C;\\F;\\G;\\I;\\K;\\L;\\M;\\O;\\T;\\U;\\X;\\Y;\\Z;\\N;\\o;\\p;\\P;]/
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      invalidEscapes = ['\\i', '\\l', '\\m', '\\q', '\\u', '\\y', '\\z', '\\A', '\\B', '\\C', '\\F', '\\G', '\\I', '\\K', '\\L', '\\M', '\\O', '\\T', '\\U', '\\X', '\\Y', '\\Z', '\\N', '\\o', '\\p', '\\P']
      offset = 2
      for invalidEscape in invalidEscapes
        expect(lines[1][offset]).toEqual value: invalidEscape, scopes: regexpCharacterClassInvalidEscapeScopes(nowdocRegexpScope)
        expect(lines[1][offset + 1]).toEqual value: ';', scopes: regexpCharacterClassLiteralScopes(nowdocRegexpScope)
        offset += 2
      expect(lines[1][offset]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(lines[1][offset + 1]).toEqual value: '/', scopes: nowdocRegexpScope

    it 'should treat raw \\c before the REGEXP nowdoc terminator as invalid inside character classes', ->
      lines = grammar.tokenizeLines '''
        $r = <<<'REGEXP'
        /[\\c
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(lines[1][2]).toEqual value: '\\c', scopes: regexpCharacterClassInvalidEscapeScopes(nowdocRegexpScope)

    it 'should keep overlapping single-backslash escapes raw-regex in REGEXP nowdoc character classes', ->
      lines = grammar.tokenizeLines '''
        $r = <<<'REGEXP'
        /[\\1\\x41\\n\\v\\$\\u{41}\\d\\x{41}]/
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(lines[1][2]).toEqual value: '\\1', scopes: regexpCharacterClassOctalScopes(nowdocRegexpScope)
      expect(lines[1][3]).toEqual value: '\\x41', scopes: regexpCharacterClassScopes(nowdocRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(lines[1][4]).toEqual value: '\\n', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
      expect(lines[1][5]).toEqual value: '\\v', scopes: regexpCharacterClassClassEscapeScopes(nowdocRegexpScope)
      expect(lines[1][6]).toEqual value: '\\$', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
      expect(lines[1][7]).toEqual value: '\\u', scopes: regexpCharacterClassInvalidEscapeScopes(nowdocRegexpScope)
      expect(lines[1][8]).toEqual value: '{', scopes: regexpCharacterClassLiteralScopes(nowdocRegexpScope)
      expect(lines[1][9]).toEqual value: '41', scopes: regexpCharacterClassNumericScopes(nowdocRegexpScope)
      expect(lines[1][10]).toEqual value: '}', scopes: regexpCharacterClassLiteralScopes(nowdocRegexpScope)
      expect(lines[1][11]).toEqual value: '\\d', scopes: regexpCharacterClassClassEscapeScopes(nowdocRegexpScope)
      expect(lines[1][12]).toEqual value: '\\x{41}', scopes: regexpCharacterClassScopes(nowdocRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(lines[1][13]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(lines[1][14]).toEqual value: '/', scopes: nowdocRegexpScope

    it 'should tokenize raw octal escapes as octal in REGEXP nowdoc character classes', ->
      lines = grammar.tokenizeLines '''
        $r = <<<'REGEXP'
        /[\\0\\4]/
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(lines[1][2]).toEqual value: '\\0', scopes: regexpCharacterClassOctalScopes(nowdocRegexpScope)
      expect(lines[1][3]).toEqual value: '\\4', scopes: regexpCharacterClassOctalScopes(nowdocRegexpScope)
      expect(lines[1][4]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(lines[1][5]).toEqual value: '/', scopes: nowdocRegexpScope

    it 'should tokenize the full raw class octal surface in REGEXP nowdoc character classes', ->
      lines = grammar.tokenizeLines '''
        $r = <<<'REGEXP'
        /[\\0\\7\\00\\77\\000\\777\\o{1}\\o{77}]/
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      offset = 2
      for octal in ['\\0', '\\7', '\\00', '\\77', '\\000', '\\777', '\\o{1}', '\\o{77}']
        expect(lines[1][offset]).toEqual value: octal, scopes: regexpCharacterClassOctalScopes(nowdocRegexpScope)
        offset += 1
      expect(lines[1][offset]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(lines[1][offset + 1]).toEqual value: '/', scopes: nowdocRegexpScope

    it 'should tokenize raw octal ranges as numeric in REGEXP nowdoc character classes', ->
      lines = grammar.tokenizeLines '''
        $r = <<<'REGEXP'
        /[\\1-\\3]/
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(lines[1][2]).toEqual value: '\\1', scopes: regexpCharacterClassRangeScopes(nowdocRegexpScope).concat ['constant.numeric.octal.regexp.php']
      expect(lines[1][3]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(nowdocRegexpScope)
      expect(lines[1][4]).toEqual value: '\\3', scopes: regexpCharacterClassRangeScopes(nowdocRegexpScope).concat ['constant.numeric.octal.regexp.php']
      expect(lines[1][5]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(lines[1][6]).toEqual value: '/', scopes: nowdocRegexpScope

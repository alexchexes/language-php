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
            /(?=ab)(?!cd)(?<=ef)(?<!gh)/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '(', scopes: regexpAssertionGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][2]).toEqual value: '?=', scopes: regexpSpecificAssertionPunctuationScopes(regexpAssertionGroupScopes(regexScope), 'meta.assertion.look-ahead.regexp.php')
          expect(lines[1][3]).toEqual value: 'ab', scopes: regexpAssertionGroupContentScopes(regexScope)
          expect(lines[1][4]).toEqual value: ')', scopes: regexpAssertionGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][5]).toEqual value: '(', scopes: regexpAssertionGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][6]).toEqual value: '?!', scopes: regexpSpecificAssertionPunctuationScopes(regexpAssertionGroupScopes(regexScope), 'meta.assertion.negative-look-ahead.regexp.php')
          expect(lines[1][7]).toEqual value: 'cd', scopes: regexpAssertionGroupContentScopes(regexScope)
          expect(lines[1][8]).toEqual value: ')', scopes: regexpAssertionGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][9]).toEqual value: '(', scopes: regexpAssertionGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][10]).toEqual value: '?<=', scopes: regexpSpecificAssertionPunctuationScopes(regexpAssertionGroupScopes(regexScope), 'meta.assertion.look-behind.regexp.php')
          expect(lines[1][11]).toEqual value: 'ef', scopes: regexpAssertionGroupContentScopes(regexScope)
          expect(lines[1][12]).toEqual value: ')', scopes: regexpAssertionGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][13]).toEqual value: '(', scopes: regexpAssertionGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][14]).toEqual value: '?<!', scopes: regexpSpecificAssertionPunctuationScopes(regexpAssertionGroupScopes(regexScope), 'meta.assertion.negative-look-behind.regexp.php')
          expect(lines[1][15]).toEqual value: 'gh', scopes: regexpAssertionGroupContentScopes(regexScope)
          expect(lines[1][16]).toEqual value: ')', scopes: regexpAssertionGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][17]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should stop multiline unclosed assertion groups at the terminator in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /(?=ab
            #{label};
            $x = 1;
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '(', scopes: regexpAssertionGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][2]).toEqual value: '?=', scopes: regexpSpecificAssertionPunctuationScopes(regexpAssertionGroupScopes(regexScope), 'meta.assertion.look-ahead.regexp.php')
          expect(lines[1][3]).toEqual value: 'ab', scopes: regexpAssertionGroupContentScopes(regexScope)
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']
          expectPlainAssignment(lines[3])

        it "should tokenize verb-style assertion groups in #{description}", ->
          expectedAssertions = [
            ['*pla:', 'ab', 'meta.assertion.look-ahead.regexp.php']
            ['*positive_lookahead:', 'cd', 'meta.assertion.look-ahead.regexp.php']
            ['*nla:', 'ef', 'meta.assertion.negative-look-ahead.regexp.php']
            ['*negative_lookahead:', 'gh', 'meta.assertion.negative-look-ahead.regexp.php']
            ['*plb:', 'ij', 'meta.assertion.look-behind.regexp.php']
            ['*positive_lookbehind:', 'kl', 'meta.assertion.look-behind.regexp.php']
            ['*nlb:', 'mn', 'meta.assertion.negative-look-behind.regexp.php']
            ['*negative_lookbehind:', 'op', 'meta.assertion.negative-look-behind.regexp.php']
          ]
          assertionSource = expectedAssertions.map(([assertionOpener, content]) -> "(#{assertionOpener}#{content})").join ''
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /#{assertionSource}/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          offset = 1
          for [assertionOpener, content, specificScope] in expectedAssertions
            expect(lines[1][offset]).toEqual value: '(', scopes: regexpAssertionGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
            expect(lines[1][offset + 1]).toEqual value: assertionOpener, scopes: regexpSpecificAssertionPunctuationScopes(regexpAssertionGroupScopes(regexScope), specificScope)
            expect(lines[1][offset + 2]).toEqual value: content, scopes: regexpAssertionGroupContentScopes(regexScope)
            expect(lines[1][offset + 3]).toEqual value: ')', scopes: regexpAssertionGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
            offset += 4
          expect(lines[1][offset]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize non-atomic assertion groups in #{description}", ->
          expectedAssertions = [
            ['?*', 'ab', 'meta.assertion.look-ahead.regexp.php']
            ['?<*', 'cd', 'meta.assertion.look-behind.regexp.php']
            ['*napla:', 'ef', 'meta.assertion.look-ahead.regexp.php']
            ['*non_atomic_positive_lookahead:', 'gh', 'meta.assertion.look-ahead.regexp.php']
            ['*naplb:', 'ij', 'meta.assertion.look-behind.regexp.php']
            ['*non_atomic_positive_lookbehind:', 'kl', 'meta.assertion.look-behind.regexp.php']
          ]
          assertionSource = expectedAssertions.map(([assertionOpener, content]) -> "(#{assertionOpener}#{content})").join ''
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /#{assertionSource}/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          offset = 1
          for [assertionOpener, content, specificScope] in expectedAssertions
            expect(lines[1][offset]).toEqual value: '(', scopes: regexpAssertionGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
            expect(lines[1][offset + 1]).toEqual value: assertionOpener, scopes: regexpSpecificAssertionPunctuationScopes(regexpAssertionGroupScopes(regexScope), specificScope)
            expect(lines[1][offset + 2]).toEqual value: content, scopes: regexpAssertionGroupContentScopes(regexScope)
            expect(lines[1][offset + 3]).toEqual value: ')', scopes: regexpAssertionGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
            offset += 4
          expect(lines[1][offset]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize the supported non-assertion conditional families in #{description}", ->
          conditionalSources = [
            '(?(1)ab|cd)'
            '(?(<word>)ef|gh)'
            "(?('word')ij|kl)"
            '(?(word)mn|op)'
            '(?(R)qr|st)'
            '(?(R1)uv|wx)'
            '(?(R&word)yz|za)'
            '(?(DEFINE)(?<word>ab))'
            '(?(VERSION>=10.4)bc|de)'
          ]
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /#{conditionalSources.join ''}/
            #{label};
          """
          conditionalSpecs = [
            [
              ['?', regexpConditionalBeginKeywordScopes(regexScope)]
              ['(', regexpConditionalBeginPunctuationScopes(regexScope)]
              ['1', regexpConditionalGroupScopes(regexScope).concat ['constant.numeric.regexp.php']]
              [')', regexpConditionalPunctuationScopes(regexScope)]
              ['ab', regexpConditionalGroupContentScopes(regexScope)]
              ['|', regexpConditionalGroupContentScopes(regexScope).concat ['keyword.operator.or.regexp.php']]
              ['cd', regexpConditionalGroupContentScopes(regexScope)]
            ]
            [
              ['?', regexpConditionalBeginKeywordScopes(regexScope)]
              ['(', regexpConditionalBeginPunctuationScopes(regexScope)]
              ['<', regexpSpecificGroupPunctuationScopes(regexpConditionalGroupScopes(regexScope), 'punctuation.definition.group.capture.begin.regexp.php')]
              ['word', regexpConditionalGroupScopes(regexScope).concat ['variable.other.regexp.php']]
              ['>', regexpSpecificGroupPunctuationScopes(regexpConditionalGroupScopes(regexScope), 'punctuation.definition.group.capture.end.regexp.php')]
              [')', regexpConditionalPunctuationScopes(regexScope)]
              ['ef', regexpConditionalGroupContentScopes(regexScope)]
              ['|', regexpConditionalGroupContentScopes(regexScope).concat ['keyword.operator.or.regexp.php']]
              ['gh', regexpConditionalGroupContentScopes(regexScope)]
            ]
            [
              ['?', regexpConditionalBeginKeywordScopes(regexScope)]
              ['(', regexpConditionalBeginPunctuationScopes(regexScope)]
              ['\'', regexpSpecificGroupPunctuationScopes(regexpConditionalGroupScopes(regexScope), 'punctuation.definition.group.capture.begin.regexp.php')]
              ['word', regexpConditionalGroupScopes(regexScope).concat ['variable.other.regexp.php']]
              ['\'', regexpSpecificGroupPunctuationScopes(regexpConditionalGroupScopes(regexScope), 'punctuation.definition.group.capture.end.regexp.php')]
              [')', regexpConditionalPunctuationScopes(regexScope)]
              ['ij', regexpConditionalGroupContentScopes(regexScope)]
              ['|', regexpConditionalGroupContentScopes(regexScope).concat ['keyword.operator.or.regexp.php']]
              ['kl', regexpConditionalGroupContentScopes(regexScope)]
            ]
            [
              ['?', regexpConditionalBeginKeywordScopes(regexScope)]
              ['(', regexpConditionalBeginPunctuationScopes(regexScope)]
              ['word', regexpConditionalGroupScopes(regexScope).concat ['variable.other.regexp.php']]
              [')', regexpConditionalPunctuationScopes(regexScope)]
              ['mn', regexpConditionalGroupContentScopes(regexScope)]
              ['|', regexpConditionalGroupContentScopes(regexScope).concat ['keyword.operator.or.regexp.php']]
              ['op', regexpConditionalGroupContentScopes(regexScope)]
            ]
            [
              ['?', regexpConditionalBeginKeywordScopes(regexScope)]
              ['(', regexpConditionalBeginPunctuationScopes(regexScope)]
              ['R', regexpConditionalRecursionScopes(regexScope)]
              [')', regexpConditionalPunctuationScopes(regexScope)]
              ['qr', regexpConditionalGroupContentScopes(regexScope)]
              ['|', regexpConditionalGroupContentScopes(regexScope).concat ['keyword.operator.or.regexp.php']]
              ['st', regexpConditionalGroupContentScopes(regexScope)]
            ]
            [
              ['?', regexpConditionalBeginKeywordScopes(regexScope)]
              ['(', regexpConditionalBeginPunctuationScopes(regexScope)]
              ['R', regexpConditionalRecursionScopes(regexScope)]
              ['1', regexpConditionalGroupScopes(regexScope).concat ['constant.numeric.regexp.php']]
              [')', regexpConditionalPunctuationScopes(regexScope)]
              ['uv', regexpConditionalGroupContentScopes(regexScope)]
              ['|', regexpConditionalGroupContentScopes(regexScope).concat ['keyword.operator.or.regexp.php']]
              ['wx', regexpConditionalGroupContentScopes(regexScope)]
            ]
            [
              ['?', regexpConditionalBeginKeywordScopes(regexScope)]
              ['(', regexpConditionalBeginPunctuationScopes(regexScope)]
              ['R&', regexpConditionalRecursionScopes(regexScope)]
              ['word', regexpConditionalGroupScopes(regexScope).concat ['variable.other.regexp.php']]
              [')', regexpConditionalPunctuationScopes(regexScope)]
              ['yz', regexpConditionalGroupContentScopes(regexScope)]
              ['|', regexpConditionalGroupContentScopes(regexScope).concat ['keyword.operator.or.regexp.php']]
              ['za', regexpConditionalGroupContentScopes(regexScope)]
            ]
            [
              ['?', regexpConditionalBeginKeywordScopes(regexScope)]
              ['(', regexpConditionalBeginPunctuationScopes(regexScope)]
              ['DEFINE', regexpConditionalKeywordScopes(regexScope)]
              [')', regexpConditionalPunctuationScopes(regexScope)]
              ['(', regexpConditionalNestedGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']]
              ['?<', regexpConditionalNestedGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php', 'punctuation.definition.group.capture.begin.regexp.php']]
              ['word', regexpConditionalNestedGroupScopes(regexScope).concat ['variable.other.regexp.php']]
              ['>', regexpConditionalNestedGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php', 'punctuation.definition.group.capture.end.regexp.php']]
              ['ab', regexpConditionalNestedGroupScopes(regexScope).concat [regexScope[regexScope.length - 1]]]
              [')', regexpConditionalNestedGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']]
            ]
            [
              ['?', regexpConditionalBeginKeywordScopes(regexScope)]
              ['(', regexpConditionalBeginPunctuationScopes(regexScope)]
              ['VERSION>=10.4', regexpConditionalKeywordScopes(regexScope)]
              [')', regexpConditionalPunctuationScopes(regexScope)]
              ['bc', regexpConditionalGroupContentScopes(regexScope)]
              ['|', regexpConditionalGroupContentScopes(regexScope).concat ['keyword.operator.or.regexp.php']]
              ['de', regexpConditionalGroupContentScopes(regexScope)]
            ]
          ]

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          offset = 1
          for spec in conditionalSpecs
            offset = expectConditionalGroupTokens lines[1], offset, regexScope, spec
          expect(lines[1][offset]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize the supported assertion-conditional families in #{description}", ->
          expectedConditions = [
            ['?=', 'aa', 'ab', 'ac', 'meta.assertion.look-ahead.regexp.php']
            ['?!', 'ba', 'bb', 'bc', 'meta.assertion.negative-look-ahead.regexp.php']
            ['?<=', 'ca', 'cb', 'cc', 'meta.assertion.look-behind.regexp.php']
            ['?<!', 'da', 'db', 'dc', 'meta.assertion.negative-look-behind.regexp.php']
            ['*pla:', 'ea', 'eb', 'ec', 'meta.assertion.look-ahead.regexp.php']
            ['*positive_lookahead:', 'fa', 'fb', 'fc', 'meta.assertion.look-ahead.regexp.php']
            ['*nla:', 'ga', 'gb', 'gc', 'meta.assertion.negative-look-ahead.regexp.php']
            ['*negative_lookahead:', 'ha', 'hb', 'hc', 'meta.assertion.negative-look-ahead.regexp.php']
            ['*plb:', 'ia', 'ib', 'ic', 'meta.assertion.look-behind.regexp.php']
            ['*positive_lookbehind:', 'ja', 'jb', 'jc', 'meta.assertion.look-behind.regexp.php']
            ['*nlb:', 'ka', 'kb', 'kc', 'meta.assertion.negative-look-behind.regexp.php']
            ['*negative_lookbehind:', 'la', 'lb', 'lc', 'meta.assertion.negative-look-behind.regexp.php']
          ]
          conditionalSource = expectedConditions.map(([assertionOpener, conditionContent, yesBranch, noBranch]) ->
            "(?(#{assertionOpener}#{conditionContent})#{yesBranch}|#{noBranch})"
          ).join ''
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /#{conditionalSource}/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          offset = 1
          for [assertionOpener, conditionContent, yesBranch, noBranch, specificScope] in expectedConditions
            expect(lines[1][offset]).toEqual value: '(', scopes: regexpConditionalGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
            expect(lines[1][offset + 1]).toEqual value: '?', scopes: regexpConditionalBeginKeywordScopes(regexScope)
            expect(lines[1][offset + 2]).toEqual value: '(', scopes: regexpConditionalBeginPunctuationScopes(regexScope)
            expect(lines[1][offset + 3]).toEqual value: assertionOpener, scopes: regexpSpecificConditionalAssertionPunctuationScopes(regexScope, specificScope)
            expect(lines[1][offset + 4]).toEqual value: conditionContent, scopes: regexpConditionalAssertionContentScopes(regexScope)
            expect(lines[1][offset + 5]).toEqual value: ')', scopes: regexpConditionalAssertionEndScopes(regexScope)
            expect(lines[1][offset + 6]).toEqual value: yesBranch, scopes: regexpConditionalGroupContentScopes(regexScope)
            expect(lines[1][offset + 7]).toEqual value: '|', scopes: regexpConditionalGroupContentScopes(regexScope).concat ['keyword.operator.or.regexp.php']
            expect(lines[1][offset + 8]).toEqual value: noBranch, scopes: regexpConditionalGroupContentScopes(regexScope)
            expect(lines[1][offset + 9]).toEqual value: ')', scopes: regexpConditionalGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
            offset += 10
          expect(lines[1][offset]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize backtracking verbs in #{description}", ->
          expectedVerbs = [
            ['*ACCEPT', null]
            ['*FAIL', null]
            ['*F', null]
            ['*:', 'label']
            ['*ACCEPT:', 'label']
            ['*FAIL:', 'label']
            ['*F:', 'label']
            ['*MARK:', 'label']
            ['*COMMIT:', 'label']
            ['*PRUNE:', 'label']
            ['*SKIP:', 'label']
            ['*THEN:', 'label']
            ['*COMMIT', null]
            ['*PRUNE', null]
            ['*SKIP', null]
            ['*THEN', null]
          ]
          verbSource = expectedVerbs.map(([verb, markLabel]) -> "(#{verb}#{if markLabel? then markLabel else ''})").join ''
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /#{verbSource}/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          offset = 1
          for [verb, markLabel] in expectedVerbs
            expect(lines[1][offset]).toEqual value: '(', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
            expect(lines[1][offset + 1]).toEqual value: verb, scopes: regexpBacktrackingVerbScopes(regexScope, verb)
            if markLabel?
              expect(lines[1][offset + 2]).toEqual value: markLabel, scopes: regexpGroupScopes(regexScope).concat ['variable.other.regexp.php']
              expect(lines[1][offset + 3]).toEqual value: ')', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
              offset += 4
            else
              expect(lines[1][offset + 2]).toEqual value: ')', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
              offset += 3
          expect(lines[1][offset]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should allow default-PCRE2 punctuation-heavy verb labels in #{description}", ->
          expectedVerbs = [
            ['*:', 'foo-bar']
            ['*MARK:', 'two words']
            ['*COMMIT:', '1']
            ['*SKIP:', '!done']
            ['*THEN:', '💩']
          ]
          verbSource = expectedVerbs.map(([verb, markLabel]) -> "(#{verb}#{markLabel})").join ''
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /#{verbSource}/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          offset = 1
          for [verb, markLabel] in expectedVerbs
            expect(lines[1][offset]).toEqual value: '(', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
            expect(lines[1][offset + 1]).toEqual value: verb, scopes: regexpBacktrackingVerbScopes(regexScope, verb)
            expect(lines[1][offset + 2]).toEqual value: markLabel, scopes: regexpGroupScopes(regexScope).concat ['variable.other.regexp.php']
            expect(lines[1][offset + 3]).toEqual value: ')', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
            offset += 4
          expect(lines[1][offset]).toEqual value: '/', scopes: regexScope

        it "should keep incomplete or empty named backtracking verbs plain in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /(*MARK:)(*SKIP:two words/
            #{label};
          """

          expect(lines[1].some((token) -> token.scopes.some((scope) -> scope.includes 'keyword.control.backtracking'))).toBe false
          expect(lines[1].some((token) -> token.scopes.includes 'variable.other.regexp.php')).toBe false

        it "should tokenize start directives in #{description}", ->
          expectedDirectives = [
            '*LIMIT_DEPTH=10'
            '*LIMIT_HEAP=11'
            '*LIMIT_MATCH=12'
            '*CASELESS_RESTRICT'
            '*NOTEMPTY_ATSTART'
            '*NOTEMPTY'
            '*NO_AUTO_POSSESS'
            '*NO_DOTSTAR_ANCHOR'
            '*NO_START_OPT'
            '*NO_JIT'
            '*TURKISH_CASING'
            '*BSR_ANYCRLF'
            '*BSR_UNICODE'
            '*ANYCRLF'
            '*CRLF'
            '*UTF'
            '*UCP'
            '*ANY'
            '*NUL'
            '*CR'
            '*LF'
          ]
          directiveSource = expectedDirectives.map((directive) -> '(' + directive + ')').join ''
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /#{directiveSource}/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          offset = 1
          for directive in expectedDirectives
            expect(lines[1][offset]).toEqual value: '(', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
            expect(lines[1][offset + 1]).toEqual value: directive, scopes: regexpDirectiveScopes(regexScope)
            expect(lines[1][offset + 2]).toEqual value: ')', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
            offset += 3
          expect(lines[1][offset]).toEqual value: '/', scopes: regexScope
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
          optionPayload = 'im-sxADJUXunr'
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /(?#{optionPayload}:ab)/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '(', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][2]).toEqual value: '?', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(regexScope), 'punctuation.definition.group.option.regexp.php')
          expect(lines[1][3]).toEqual value: optionPayload, scopes: regexpGroupScopes(regexScope).concat ['storage.modifier.regexp.php']
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

        it "should accept Unicode letters and decimal digits in named groups and conditionals in #{description}", ->
          unicodeName = 'Ж١'
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /(?<#{unicodeName}>a)(?'#{unicodeName}'a)(?P<#{unicodeName}>a)(?(<#{unicodeName}>)a|b)(?('#{unicodeName}')a|b)(?(R&#{unicodeName})a|b)(?(#{unicodeName})a|b)/
            #{label};
          """

          namedTokens = lines[1].filter (token) ->
            token.value is unicodeName and token.scopes.includes 'variable.other.regexp.php'

          expect(namedTokens.length).toBe 7

        it "should keep invalid Unicode-start named groups and conditionals out of name scopes in #{description}", ->
          startDigitName = '١foo'
          emojiName = '💩'
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /(?<#{startDigitName}>a)(?'#{emojiName}'a)(?(#{startDigitName})a|b)(?(<#{emojiName}>)a|b)(?(R&#{startDigitName})a|b)/
            #{label};
          """

          expect(lines[1].some((token) -> token.value.includes(startDigitName) and token.scopes.includes 'variable.other.regexp.php')).toBe false
          expect(lines[1].some((token) -> token.value.includes(emojiName) and token.scopes.includes 'variable.other.regexp.php')).toBe false

        it "should tokenize atomic groups in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /(?>ab)(*atomic:cd)/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '(', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][2]).toEqual value: '?>', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(regexScope), 'punctuation.definition.group.atomic.regexp.php')
          expect(lines[1][3]).toEqual value: 'ab', scopes: regexpGroupContentScopes(regexScope)
          expect(lines[1][4]).toEqual value: ')', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][5]).toEqual value: '(', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][6]).toEqual value: '*atomic:', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(regexScope), 'punctuation.definition.group.atomic.regexp.php')
          expect(lines[1][7]).toEqual value: 'cd', scopes: regexpGroupContentScopes(regexScope)
          expect(lines[1][8]).toEqual value: ')', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][9]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize script-run groups in #{description}", ->
          expectedGroups = [
            ['*sr:', 'ab', 'punctuation.definition.group.script-run.regexp.php']
            ['*script_run:', 'cd', 'punctuation.definition.group.script-run.regexp.php']
            ['*asr:', 'ef', 'punctuation.definition.group.atomic-script-run.regexp.php']
            ['*atomic_script_run:', 'gh', 'punctuation.definition.group.atomic-script-run.regexp.php']
          ]
          groupSource = expectedGroups.map(([openerText, content]) -> "(#{openerText}#{content})").join ''
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /#{groupSource}/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          offset = 1
          for [openerText, content, specificScope] in expectedGroups
            expect(lines[1][offset]).toEqual value: '(', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
            expect(lines[1][offset + 1]).toEqual value: openerText, scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(regexScope), specificScope)
            expect(lines[1][offset + 2]).toEqual value: content, scopes: regexpGroupContentScopes(regexScope)
            expect(lines[1][offset + 3]).toEqual value: ')', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
            offset += 4
          expect(lines[1][offset]).toEqual value: '/', scopes: regexScope
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
            /(?imsxADJUXunr-)/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '(', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
          expect(lines[1][2]).toEqual value: '?imsxADJUXunr-', scopes: regexpGroupScopes(regexScope).concat ['keyword.other.option-toggle.regexp.php']
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

        it "should tokenize braced and g-style backreferences in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /\\k{word}\\g{word}\\g1\\g{1}\\g{-1}/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '\\k', scopes: regexScope.concat ['keyword.other.back-reference.named.regexp.php']
          expect(lines[1][2]).toEqual value: '{', scopes: regexpNamedBackreferenceScopes(regexScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
          expect(lines[1][3]).toEqual value: 'word', scopes: regexpNamedBackreferenceNameScopes(regexScope)
          expect(lines[1][4]).toEqual value: '}', scopes: regexpNamedBackreferenceScopes(regexScope).concat ['punctuation.definition.group.capture.end.regexp.php']
          expect(lines[1][5]).toEqual value: '\\g', scopes: regexpNamedBackreferenceScopes(regexScope)
          expect(lines[1][6]).toEqual value: '{', scopes: regexpNamedBackreferenceScopes(regexScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
          expect(lines[1][7]).toEqual value: 'word', scopes: regexpNamedBackreferenceNameScopes(regexScope)
          expect(lines[1][8]).toEqual value: '}', scopes: regexpNamedBackreferenceScopes(regexScope).concat ['punctuation.definition.group.capture.end.regexp.php']
          expect(lines[1][9]).toEqual value: '\\g', scopes: regexScope.concat ['keyword.other.back-reference.regexp.php']
          expect(lines[1][10]).toEqual value: '1', scopes: regexScope.concat ['keyword.other.back-reference.regexp.php', 'constant.numeric.regexp.php']
          expect(lines[1][11]).toEqual value: '\\g', scopes: regexScope.concat ['keyword.other.back-reference.regexp.php']
          expect(lines[1][12]).toEqual value: '{', scopes: regexScope.concat ['keyword.other.back-reference.regexp.php', 'punctuation.definition.group.capture.begin.regexp.php']
          expect(lines[1][13]).toEqual value: '1', scopes: regexScope.concat ['keyword.other.back-reference.regexp.php', 'constant.numeric.regexp.php']
          expect(lines[1][14]).toEqual value: '}', scopes: regexScope.concat ['keyword.other.back-reference.regexp.php', 'punctuation.definition.group.capture.end.regexp.php']
          expect(lines[1][15]).toEqual value: '\\g', scopes: regexScope.concat ['keyword.other.back-reference.regexp.php']
          expect(lines[1][16]).toEqual value: '{', scopes: regexScope.concat ['keyword.other.back-reference.regexp.php', 'punctuation.definition.group.capture.begin.regexp.php']
          expect(lines[1][17]).toEqual value: '-1', scopes: regexScope.concat ['keyword.other.back-reference.regexp.php', 'constant.numeric.regexp.php']
          expect(lines[1][18]).toEqual value: '}', scopes: regexScope.concat ['keyword.other.back-reference.regexp.php', 'punctuation.definition.group.capture.end.regexp.php']
          expect(lines[1][19]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        if sourceSurface is 'raw'
          it 'should tokenize raw numeric backreferences in REGEXP nowdoc', ->
            lines = grammar.tokenizeLines [
              "$r = <<<'REGEXP'"
              '/\\1\\12\\123/'
              'REGEXP;'
            ].join "\n"

            expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
            expect(lines[1][1]).toEqual value: '\\', scopes: nowdocRegexpScope.concat ['keyword.other.back-reference.regexp.php']
            expect(lines[1][2]).toEqual value: '1', scopes: nowdocRegexpScope.concat ['keyword.other.back-reference.regexp.php', 'constant.numeric.regexp.php']
            expect(lines[1][3]).toEqual value: '\\', scopes: nowdocRegexpScope.concat ['keyword.other.back-reference.regexp.php']
            expect(lines[1][4]).toEqual value: '12', scopes: nowdocRegexpScope.concat ['keyword.other.back-reference.regexp.php', 'constant.numeric.regexp.php']
            expect(lines[1][5]).toEqual value: '\\', scopes: nowdocRegexpScope.concat ['keyword.other.back-reference.regexp.php']
            expect(lines[1][6]).toEqual value: '123', scopes: nowdocRegexpScope.concat ['keyword.other.back-reference.regexp.php', 'constant.numeric.regexp.php']
            expect(lines[1][7]).toEqual value: '/', scopes: nowdocRegexpScope

        it "should tokenize recursion and subroutine calls in #{description}", ->
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
          gSource = [
            ['named', '<', 'word', '>']
            ['named', '\'', 'word', '\'']
            ['numeric', '<', '1', '>']
            ['numeric', '<', '+1', '>']
            ['numeric', '\'', '-1', '\'']
          ].map(([, beginPunctuation, payload, endPunctuation]) -> "\\g#{beginPunctuation}#{payload}#{endPunctuation}").join ''
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /#{groupSource}#{gSource}/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          offset = 1
          for [kind, head, payload] in groupExpectations
            expect(lines[1][offset]).toEqual value: '(', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
            if kind is 'recursion'
              expect(lines[1][offset + 1]).toEqual value: head, scopes: regexpGroupRecursionScopes(regexScope)
              expect(lines[1][offset + 2]).toEqual value: ')', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
              offset += 3
            else if kind is 'numeric'
              expect(lines[1][offset + 1]).toEqual value: head, scopes: regexpGroupSubroutineScopes(regexScope)
              expect(lines[1][offset + 2]).toEqual value: payload, scopes: regexpGroupSubroutineScopes(regexScope).concat ['constant.numeric.regexp.php']
              expect(lines[1][offset + 3]).toEqual value: ')', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
              offset += 4
            else
              expect(lines[1][offset + 1]).toEqual value: head, scopes: regexpGroupNamedSubroutineScopes(regexScope)
              expect(lines[1][offset + 2]).toEqual value: payload, scopes: regexpGroupNamedSubroutineScopes(regexScope).concat ['variable.other.regexp.php']
              expect(lines[1][offset + 3]).toEqual value: ')', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
              offset += 4

          for [kind, beginPunctuation, payload, endPunctuation] in [
            ['named', '<', 'word', '>']
            ['named', '\'', 'word', '\'']
            ['numeric', '<', '1', '>']
            ['numeric', '<', '+1', '>']
            ['numeric', '\'', '-1', '\'']
          ]
            if kind is 'named'
              expect(lines[1][offset]).toEqual value: '\\g', scopes: regexpNamedSubroutineScopes(regexScope)
              expect(lines[1][offset + 1]).toEqual value: beginPunctuation, scopes: regexpNamedSubroutineScopes(regexScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
              expect(lines[1][offset + 2]).toEqual value: payload, scopes: regexpNamedSubroutineNameScopes(regexScope)
              expect(lines[1][offset + 3]).toEqual value: endPunctuation, scopes: regexpNamedSubroutineScopes(regexScope).concat ['punctuation.definition.group.capture.end.regexp.php']
            else
              expect(lines[1][offset]).toEqual value: '\\g', scopes: regexpSubroutineScopes(regexScope)
              expect(lines[1][offset + 1]).toEqual value: beginPunctuation, scopes: regexpSubroutineScopes(regexScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
              expect(lines[1][offset + 2]).toEqual value: payload, scopes: regexpSubroutineScopes(regexScope).concat ['constant.numeric.regexp.php']
              expect(lines[1][offset + 3]).toEqual value: endPunctuation, scopes: regexpSubroutineScopes(regexScope).concat ['punctuation.definition.group.capture.end.regexp.php']
            offset += 4

          expect(lines[1][offset]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        if sourceSurface is 'raw'
          it 'should tokenize the full raw named backreference surface in REGEXP nowdoc', ->
            lines = grammar.tokenizeLines [
              "$r = <<<'REGEXP'"
              "/\\k<word>\\k'word'\\k{word}\\g{word}/"
              'REGEXP;'
            ].join "\n"

            expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope

            expect(lines[1][1]).toEqual value: '\\k', scopes: regexpNamedBackreferenceScopes(nowdocRegexpScope)
            expect(lines[1][2]).toEqual value: '<', scopes: regexpNamedBackreferenceScopes(nowdocRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
            expect(lines[1][3]).toEqual value: 'word', scopes: regexpNamedBackreferenceNameScopes(nowdocRegexpScope)
            expect(lines[1][4]).toEqual value: '>', scopes: regexpNamedBackreferenceScopes(nowdocRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']

            expect(lines[1][5]).toEqual value: '\\k', scopes: regexpNamedBackreferenceScopes(nowdocRegexpScope)
            expect(lines[1][6]).toEqual value: '\'', scopes: regexpNamedBackreferenceScopes(nowdocRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
            expect(lines[1][7]).toEqual value: 'word', scopes: regexpNamedBackreferenceNameScopes(nowdocRegexpScope)
            expect(lines[1][8]).toEqual value: '\'', scopes: regexpNamedBackreferenceScopes(nowdocRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']

            for [offset, leader] in [[9, '\\k'], [13, '\\g']]
              expect(lines[1][offset]).toEqual value: leader, scopes: regexpNamedBackreferenceScopes(nowdocRegexpScope)
              expect(lines[1][offset + 1]).toEqual value: '{', scopes: regexpNamedBackreferenceScopes(nowdocRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
              expect(lines[1][offset + 2]).toEqual value: 'word', scopes: regexpNamedBackreferenceNameScopes(nowdocRegexpScope)
              expect(lines[1][offset + 3]).toEqual value: '}', scopes: regexpNamedBackreferenceScopes(nowdocRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']

            expect(lines[1][17]).toEqual value: '/', scopes: nowdocRegexpScope

          it 'should accept Unicode letters and decimal digits in raw named refs and subroutines in REGEXP nowdoc', ->
            unicodeName = 'Ж١'
            patternSource = [
              "\\k<#{unicodeName}>"
              "\\k'#{unicodeName}'"
              "\\k{#{unicodeName}}"
              "\\g<#{unicodeName}>"
              "\\g'#{unicodeName}'"
              "\\g{#{unicodeName}}"
              "(?&#{unicodeName})"
              "(?P=#{unicodeName})"
              "(?P>#{unicodeName})"
            ].join ''
            lines = grammar.tokenizeLines [
              "$r = <<<'REGEXP'"
              "/#{patternSource}/"
              'REGEXP;'
            ].join "\n"

            expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope

            offset = 1
            for [beginPunctuation, endPunctuation] in [['<', '>'], ['\'', '\''], ['{', '}']]
              expect(lines[1][offset]).toEqual value: '\\k', scopes: regexpNamedBackreferenceScopes(nowdocRegexpScope)
              expect(lines[1][offset + 1]).toEqual value: beginPunctuation, scopes: regexpNamedBackreferenceScopes(nowdocRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
              expect(lines[1][offset + 2]).toEqual value: unicodeName, scopes: regexpNamedBackreferenceNameScopes(nowdocRegexpScope)
              expect(lines[1][offset + 3]).toEqual value: endPunctuation, scopes: regexpNamedBackreferenceScopes(nowdocRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']
              offset += 4

            for [beginPunctuation, endPunctuation] in [['<', '>'], ['\'', '\'']]
              expect(lines[1][offset]).toEqual value: '\\g', scopes: regexpNamedSubroutineScopes(nowdocRegexpScope)
              expect(lines[1][offset + 1]).toEqual value: beginPunctuation, scopes: regexpNamedSubroutineScopes(nowdocRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
              expect(lines[1][offset + 2]).toEqual value: unicodeName, scopes: regexpNamedSubroutineNameScopes(nowdocRegexpScope)
              expect(lines[1][offset + 3]).toEqual value: endPunctuation, scopes: regexpNamedSubroutineScopes(nowdocRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']
              offset += 4

            expect(lines[1][offset]).toEqual value: '\\g', scopes: regexpNamedBackreferenceScopes(nowdocRegexpScope)
            expect(lines[1][offset + 1]).toEqual value: '{', scopes: regexpNamedBackreferenceScopes(nowdocRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
            expect(lines[1][offset + 2]).toEqual value: unicodeName, scopes: regexpNamedBackreferenceNameScopes(nowdocRegexpScope)
            expect(lines[1][offset + 3]).toEqual value: '}', scopes: regexpNamedBackreferenceScopes(nowdocRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']
            offset += 4

            for head in ['?&', '?P=', '?P>']
              expect(lines[1][offset]).toEqual value: '(', scopes: regexpGroupScopes(nowdocRegexpScope).concat ['punctuation.definition.group.regexp.php']
              if head is '?P='
                expect(lines[1][offset + 1]).toEqual value: head, scopes: regexpGroupScopes(nowdocRegexpScope).concat ['keyword.other.back-reference.named.regexp.php']
              else
                expect(lines[1][offset + 1]).toEqual value: head, scopes: regexpGroupNamedSubroutineScopes(nowdocRegexpScope)
              expect(lines[1][offset + 2]).toEqual value: unicodeName, scopes: (if head is '?P=' then regexpGroupScopes(nowdocRegexpScope) else regexpGroupNamedSubroutineScopes(nowdocRegexpScope)).concat ['variable.other.regexp.php']
              expect(lines[1][offset + 3]).toEqual value: ')', scopes: regexpGroupScopes(nowdocRegexpScope).concat ['punctuation.definition.group.regexp.php']
              offset += 4

            expect(lines[1][offset]).toEqual value: '/', scopes: nowdocRegexpScope

          it 'should tokenize the full raw \\g numeric backreference and subroutine surface in REGEXP nowdoc', ->
            patternSource = [
              '\\g1'
              '\\g+1'
              '\\g-1'
              '\\g{1}'
              '\\g{+1}'
              '\\g{-1}'
              '\\g<word>'
              "\\g'word'"
              '\\g<1>'
              '\\g<+1>'
              '\\g<-1>'
              "\\g'1'"
              "\\g'+1'"
              "\\g'-1'"
            ].join ''
            lines = grammar.tokenizeLines [
              "$r = <<<'REGEXP'"
              "/#{patternSource}/"
              'REGEXP;'
            ].join "\n"

            expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
            offset = 1

            for payload in ['1', '+1', '-1']
              expect(lines[1][offset]).toEqual value: '\\g', scopes: nowdocRegexpScope.concat ['keyword.other.back-reference.regexp.php']
              expect(lines[1][offset + 1]).toEqual value: payload, scopes: nowdocRegexpScope.concat ['keyword.other.back-reference.regexp.php', 'constant.numeric.regexp.php']
              offset += 2

            for payload in ['1', '+1', '-1']
              expect(lines[1][offset]).toEqual value: '\\g', scopes: nowdocRegexpScope.concat ['keyword.other.back-reference.regexp.php']
              expect(lines[1][offset + 1]).toEqual value: '{', scopes: nowdocRegexpScope.concat ['keyword.other.back-reference.regexp.php', 'punctuation.definition.group.capture.begin.regexp.php']
              expect(lines[1][offset + 2]).toEqual value: payload, scopes: nowdocRegexpScope.concat ['keyword.other.back-reference.regexp.php', 'constant.numeric.regexp.php']
              expect(lines[1][offset + 3]).toEqual value: '}', scopes: nowdocRegexpScope.concat ['keyword.other.back-reference.regexp.php', 'punctuation.definition.group.capture.end.regexp.php']
              offset += 4

            for [beginPunctuation, payload, endPunctuation] in [
              ['<', 'word', '>']
              ['\'', 'word', '\'']
            ]
              expect(lines[1][offset]).toEqual value: '\\g', scopes: regexpNamedSubroutineScopes(nowdocRegexpScope)
              expect(lines[1][offset + 1]).toEqual value: beginPunctuation, scopes: regexpNamedSubroutineScopes(nowdocRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
              expect(lines[1][offset + 2]).toEqual value: payload, scopes: regexpNamedSubroutineNameScopes(nowdocRegexpScope)
              expect(lines[1][offset + 3]).toEqual value: endPunctuation, scopes: regexpNamedSubroutineScopes(nowdocRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']
              offset += 4

            for [beginPunctuation, payload, endPunctuation] in [
              ['<', '1', '>']
              ['<', '+1', '>']
              ['<', '-1', '>']
              ['\'', '1', '\'']
              ['\'', '+1', '\'']
              ['\'', '-1', '\'']
            ]
              expect(lines[1][offset]).toEqual value: '\\g', scopes: regexpSubroutineScopes(nowdocRegexpScope)
              expect(lines[1][offset + 1]).toEqual value: beginPunctuation, scopes: regexpSubroutineScopes(nowdocRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
              expect(lines[1][offset + 2]).toEqual value: payload, scopes: regexpSubroutineScopes(nowdocRegexpScope).concat ['constant.numeric.regexp.php']
              expect(lines[1][offset + 3]).toEqual value: endPunctuation, scopes: regexpSubroutineScopes(nowdocRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']
              offset += 4

            expect(lines[1][offset]).toEqual value: '/', scopes: nowdocRegexpScope

        if sourceSurface is 'interpreted'
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
            expect(lines[1][5]).toEqual value: '\\$', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'keyword.control.anchor.regexp.php']
            expect(lines[1][6]).toEqual value: '\\d', scopes: heredocRegexpScope.concat ['constant.character.class.regexp.php']
            expect(lines[1][7]).toEqual value: '\\x{41}', scopes: heredocRegexpScope.concat ['constant.character.numeric.regexp.php']
            expect(lines[1][8]).toEqual value: '/', scopes: heredocRegexpScope
            expect(lines[2][0]).toEqual value: 'REGEX', scopes: heredocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.heredoc.php']
            expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

          it 'should keep transported PHP code-point escapes PHP-first in REGEX heredoc bodies', ->
            lines = grammar.tokenizeLines [
              '$r = <<<REGEX'
              '/' + '\\'.repeat(3) + 'x21' + '\\'.repeat(3) + 'u{21}/'
              'REGEX;'
            ].join "\n"

            expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
            expect(lines[1][1]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php']
            expect(lines[1][2]).toEqual value: '\\x21', scopes: heredocRegexpScope.concat ['constant.character.escape.hex.php']
            expect(lines[1][3]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php']
            expect(lines[1][4]).toEqual value: '\\u{21}', scopes: heredocRegexpScope.concat ['constant.character.escape.unicode.php']
            expect(lines[1][5]).toEqual value: '/', scopes: heredocRegexpScope

          it 'should keep transported PHP octal and basic escapes PHP-first in REGEX heredoc bodies', ->
            basicEscapes = ['n', 'r', 't', 'v', 'e', 'f', '$']
            lines = grammar.tokenizeLines [
              '$r = <<<REGEX'
              '/' + '\\'.repeat(3) + '1' + basicEscapes.map((char) -> '\\'.repeat(3) + char).join('') + '/'
              'REGEX;'
            ].join "\n"

            expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
            expect(lines[1][1]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php']
            expect(lines[1][2]).toEqual value: '\\1', scopes: heredocRegexpScope.concat ['constant.character.escape.octal.php']
            offset = 3
            for char in basicEscapes
              expect(lines[1][offset]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php']
              expect(lines[1][offset + 1]).toEqual value: '\\' + char, scopes: heredocRegexpScope.concat ['constant.character.escape.php']
              offset += 2
            expect(lines[1][offset]).toEqual value: '/', scopes: heredocRegexpScope

          it 'should tokenize decoded octal zero in REGEX heredoc bodies', ->
            lines = grammar.tokenizeLines [
              '$r = <<<REGEX'
              '/\\\\0/'
              'REGEX;'
            ].join "\n"

            expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
            expect(lines[1][1]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.numeric.octal.regexp.php']
            expect(lines[1][2]).toEqual value: '0', scopes: regexpOctalScopes(heredocRegexpScope)
            expect(lines[1][3]).toEqual value: '/', scopes: heredocRegexpScope

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

        if sourceSurface is 'raw'
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
          it 'should tokenize raw octal zero escapes in REGEXP nowdoc', ->
            lines = grammar.tokenizeLines [
              '$r = <<<' + "'REGEXP'"
              '/\\0\\00\\000/'
              'REGEXP;'
            ].join "\n"

            expect(lines[1][0]).toEqual value: '/', scopes: regexScope
            expect(lines[1][1]).toEqual value: '\\0', scopes: regexpOctalScopes(regexScope)
            expect(lines[1][2]).toEqual value: '\\00', scopes: regexpOctalScopes(regexScope)
            expect(lines[1][3]).toEqual value: '\\000', scopes: regexpOctalScopes(regexScope)
            expect(lines[1][4]).toEqual value: '/', scopes: regexScope

          it 'should tokenize the full raw octal-escape surface in REGEXP nowdoc', ->
            lines = grammar.tokenizeLines [
              '$r = <<<' + "'REGEXP'"
              '/\\0\\07\\012\\o{141}/'
              'REGEXP;'
            ].join "\n"

            expect(lines[1][0]).toEqual value: '/', scopes: regexScope
            expect(lines[1][1]).toEqual value: '\\0', scopes: regexpOctalScopes(regexScope)
            expect(lines[1][2]).toEqual value: '\\07', scopes: regexpOctalScopes(regexScope)
            expect(lines[1][3]).toEqual value: '\\012', scopes: regexpOctalScopes(regexScope)
            expect(lines[1][4]).toEqual value: '\\o{141}', scopes: regexpOctalScopes(regexScope)
            expect(lines[1][5]).toEqual value: '/', scopes: regexScope

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

        it "should tokenize braced octal escapes in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /\\o{141}/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '\\o{141}', scopes: regexpOctalScopes(regexScope)
          expect(lines[1][2]).toEqual value: '/', scopes: regexScope
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

        it "should tokenize Unicode code point escapes in #{description}", ->
          body = if sourceSurface is 'raw' then '/\\N{U+41}/' else '/\\\\N{U+41}/'
          lines = grammar.tokenizeLines """
            $r = #{opener}
            #{body}
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          if sourceSurface is 'raw'
            expect(lines[1][1]).toEqual value: '\\N{U+41}', scopes: regexScope.concat ['constant.character.numeric.regexp.php']
            expect(lines[1][2]).toEqual value: '/', scopes: regexScope
          else
            expect(lines[1][1]).toEqual value: '\\\\', scopes: regexScope.concat ['constant.character.escape.php', 'constant.character.numeric.regexp.php']
            expect(lines[1][2]).toEqual value: 'N{U+41}', scopes: regexScope.concat ['constant.character.numeric.regexp.php']
            expect(lines[1][3]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize one-digit hex escapes in #{description}", ->
          body = if sourceSurface is 'raw' then '/\\x1Q600\\x4Q/' else '/\\\\x1Q600\\\\x4Q/'
          lines = grammar.tokenizeLines """
            $r = #{opener}
            #{body}
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          if sourceSurface is 'raw'
            expect(lines[1][1]).toEqual value: '\\x1', scopes: regexScope.concat ['constant.character.numeric.regexp.php']
            expect(lines[1][2]).toEqual value: 'Q600', scopes: regexScope
            expect(lines[1][3]).toEqual value: '\\x4', scopes: regexScope.concat ['constant.character.numeric.regexp.php']
            expect(lines[1][4]).toEqual value: 'Q/', scopes: regexScope
          else
            expect(lines[1][1]).toEqual value: '\\\\', scopes: regexpDecodedNumericTransportScopes(regexScope)
            expect(lines[1][2]).toEqual value: 'x1', scopes: regexScope.concat ['constant.character.numeric.regexp.php']
            expect(lines[1][3]).toEqual value: 'Q600', scopes: regexScope
            expect(lines[1][4]).toEqual value: '\\\\', scopes: regexpDecodedNumericTransportScopes(regexScope)
            expect(lines[1][5]).toEqual value: 'x4', scopes: regexScope.concat ['constant.character.numeric.regexp.php']
            expect(lines[1][6]).toEqual value: 'Q/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        if sourceSurface is 'raw'
          it 'should tokenize raw two-digit hex escapes in REGEXP nowdoc', ->
            lines = grammar.tokenizeLines [
              "$r = <<<'REGEXP'"
              '/\\x41\\xAf/'
              'REGEXP;'
            ].join "\n"

            expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
            expect(lines[1][1]).toEqual value: '\\x41', scopes: nowdocRegexpScope.concat ['constant.character.numeric.regexp.php']
            expect(lines[1][2]).toEqual value: '\\xAf', scopes: nowdocRegexpScope.concat ['constant.character.numeric.regexp.php']
            expect(lines[1][3]).toEqual value: '/', scopes: nowdocRegexpScope

          it 'should tokenize raw braced hex escapes in REGEXP nowdoc', ->
            lines = grammar.tokenizeLines [
              "$r = <<<'REGEXP'"
              '/\\x{4A}\\x{1F600}/'
              'REGEXP;'
            ].join "\n"

            expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
            expect(lines[1][1]).toEqual value: '\\x{4A}', scopes: nowdocRegexpScope.concat ['constant.character.numeric.regexp.php']
            expect(lines[1][2]).toEqual value: '\\x{1F600}', scopes: nowdocRegexpScope.concat ['constant.character.numeric.regexp.php']
            expect(lines[1][3]).toEqual value: '/', scopes: nowdocRegexpScope

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

          it 'should accept Unicode letters and decimal digits in decoded named refs and subroutines in REGEX heredoc', ->
            unicodeName = 'Ж١'
            lines = grammar.tokenizeLines """
              $r = <<<REGEX
              /\\\\k<#{unicodeName}>\\\\k{#{unicodeName}}\\\\g<#{unicodeName}>\\\\g{#{unicodeName}}(?&#{unicodeName})(?P=#{unicodeName})(?P>#{unicodeName})/
              REGEX;
            """

            expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope

            expect(lines[1][1]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'keyword.other.back-reference.named.regexp.php']
            expect(lines[1][6]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'keyword.other.back-reference.named.regexp.php']
            expect(lines[1][11]).toEqual value: '\\\\', scopes: regexpDecodedNamedSubroutineTransportScopes(heredocRegexpScope)
            expect(lines[1][16]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'keyword.other.back-reference.named.regexp.php']

            expect(lines[1][2]).toEqual value: 'k', scopes: regexpNamedBackreferenceScopes(heredocRegexpScope)
            expect(lines[1][3]).toEqual value: '<', scopes: regexpNamedBackreferenceScopes(heredocRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
            expect(lines[1][4]).toEqual value: unicodeName, scopes: regexpNamedBackreferenceNameScopes(heredocRegexpScope)
            expect(lines[1][5]).toEqual value: '>', scopes: regexpNamedBackreferenceScopes(heredocRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']

            expect(lines[1][7]).toEqual value: 'k', scopes: regexpNamedBackreferenceScopes(heredocRegexpScope)
            expect(lines[1][8]).toEqual value: '{', scopes: regexpNamedBackreferenceScopes(heredocRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
            expect(lines[1][9]).toEqual value: unicodeName, scopes: regexpNamedBackreferenceNameScopes(heredocRegexpScope)
            expect(lines[1][10]).toEqual value: '}', scopes: regexpNamedBackreferenceScopes(heredocRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']

            expect(lines[1][12]).toEqual value: 'g', scopes: regexpNamedSubroutineScopes(heredocRegexpScope)
            expect(lines[1][13]).toEqual value: '<', scopes: regexpNamedSubroutineScopes(heredocRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
            expect(lines[1][14]).toEqual value: unicodeName, scopes: regexpNamedSubroutineNameScopes(heredocRegexpScope)
            expect(lines[1][15]).toEqual value: '>', scopes: regexpNamedSubroutineScopes(heredocRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']

            expect(lines[1][17]).toEqual value: 'g', scopes: regexpNamedBackreferenceScopes(heredocRegexpScope)
            expect(lines[1][18]).toEqual value: '{', scopes: regexpNamedBackreferenceScopes(heredocRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
            expect(lines[1][19]).toEqual value: unicodeName, scopes: regexpNamedBackreferenceNameScopes(heredocRegexpScope)
            expect(lines[1][20]).toEqual value: '}', scopes: regexpNamedBackreferenceScopes(heredocRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']

            offset = 21
            for head in ['?&', '?P=', '?P>']
              expect(lines[1][offset]).toEqual value: '(', scopes: regexpGroupScopes(heredocRegexpScope).concat ['punctuation.definition.group.regexp.php']
              if head is '?P='
                expect(lines[1][offset + 1]).toEqual value: head, scopes: regexpGroupScopes(heredocRegexpScope).concat ['keyword.other.back-reference.named.regexp.php']
              else
                expect(lines[1][offset + 1]).toEqual value: head, scopes: regexpGroupNamedSubroutineScopes(heredocRegexpScope)
              expect(lines[1][offset + 2]).toEqual value: unicodeName, scopes: (if head is '?P=' then regexpGroupScopes(heredocRegexpScope) else regexpGroupNamedSubroutineScopes(heredocRegexpScope)).concat ['variable.other.regexp.php']
              expect(lines[1][offset + 3]).toEqual value: ')', scopes: regexpGroupScopes(heredocRegexpScope).concat ['punctuation.definition.group.regexp.php']
              offset += 4

            expect(lines[1][offset]).toEqual value: '/', scopes: heredocRegexpScope
            expect(lines[2][0]).toEqual value: 'REGEX', scopes: heredocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.heredoc.php']

          it 'should tokenize decoded braced and g-style backreferences in REGEX heredoc', ->
            lines = grammar.tokenizeLines """
              $r = <<<REGEX
              /\\\\k{word}\\\\g{word}\\\\g1\\\\g{1}\\\\g{-1}/
              REGEX;
            """

            expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
            expect(lines[1][1]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'keyword.other.back-reference.named.regexp.php']
            expect(lines[1][2]).toEqual value: 'k', scopes: regexpNamedBackreferenceScopes(heredocRegexpScope)
            expect(lines[1][3]).toEqual value: '{', scopes: regexpNamedBackreferenceScopes(heredocRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
            expect(lines[1][4]).toEqual value: 'word', scopes: regexpNamedBackreferenceNameScopes(heredocRegexpScope)
            expect(lines[1][5]).toEqual value: '}', scopes: regexpNamedBackreferenceScopes(heredocRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']
            expect(lines[1][6]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'keyword.other.back-reference.named.regexp.php']
            expect(lines[1][7]).toEqual value: 'g', scopes: regexpNamedBackreferenceScopes(heredocRegexpScope)
            expect(lines[1][8]).toEqual value: '{', scopes: regexpNamedBackreferenceScopes(heredocRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
            expect(lines[1][9]).toEqual value: 'word', scopes: regexpNamedBackreferenceNameScopes(heredocRegexpScope)
            expect(lines[1][10]).toEqual value: '}', scopes: regexpNamedBackreferenceScopes(heredocRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']
            expect(lines[1][11]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'keyword.other.back-reference.regexp.php']
            expect(lines[1][12]).toEqual value: 'g', scopes: heredocRegexpScope.concat ['keyword.other.back-reference.regexp.php']
            expect(lines[1][13]).toEqual value: '1', scopes: heredocRegexpScope.concat ['keyword.other.back-reference.regexp.php', 'constant.numeric.regexp.php']
            expect(lines[1][14]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'keyword.other.back-reference.regexp.php']
            expect(lines[1][15]).toEqual value: 'g', scopes: heredocRegexpScope.concat ['keyword.other.back-reference.regexp.php']
            expect(lines[1][16]).toEqual value: '{', scopes: heredocRegexpScope.concat ['keyword.other.back-reference.regexp.php', 'punctuation.definition.group.capture.begin.regexp.php']
            expect(lines[1][17]).toEqual value: '1', scopes: heredocRegexpScope.concat ['keyword.other.back-reference.regexp.php', 'constant.numeric.regexp.php']
            expect(lines[1][18]).toEqual value: '}', scopes: heredocRegexpScope.concat ['keyword.other.back-reference.regexp.php', 'punctuation.definition.group.capture.end.regexp.php']
            expect(lines[1][19]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'keyword.other.back-reference.regexp.php']
            expect(lines[1][20]).toEqual value: 'g', scopes: heredocRegexpScope.concat ['keyword.other.back-reference.regexp.php']
            expect(lines[1][21]).toEqual value: '{', scopes: heredocRegexpScope.concat ['keyword.other.back-reference.regexp.php', 'punctuation.definition.group.capture.begin.regexp.php']
            expect(lines[1][22]).toEqual value: '-1', scopes: heredocRegexpScope.concat ['keyword.other.back-reference.regexp.php', 'constant.numeric.regexp.php']
            expect(lines[1][23]).toEqual value: '}', scopes: heredocRegexpScope.concat ['keyword.other.back-reference.regexp.php', 'punctuation.definition.group.capture.end.regexp.php']
            expect(lines[1][24]).toEqual value: '/', scopes: heredocRegexpScope
            expect(lines[2][0]).toEqual value: 'REGEX', scopes: heredocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.heredoc.php']

          it 'should tokenize decoded Oniguruma subroutine calls in REGEX heredoc', ->
            lines = grammar.tokenizeLines """
              $r = <<<REGEX
              /\\\\g<word>\\\\g'word'\\\\g<1>\\\\g<+1>\\\\g'-1'/
              REGEX;
            """

            expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
            expect(lines[1][1]).toEqual value: '\\\\', scopes: regexpDecodedNamedSubroutineTransportScopes(heredocRegexpScope)
            expect(lines[1][2]).toEqual value: 'g', scopes: regexpNamedSubroutineScopes(heredocRegexpScope)
            expect(lines[1][3]).toEqual value: '<', scopes: regexpNamedSubroutineScopes(heredocRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
            expect(lines[1][4]).toEqual value: 'word', scopes: regexpNamedSubroutineNameScopes(heredocRegexpScope)
            expect(lines[1][5]).toEqual value: '>', scopes: regexpNamedSubroutineScopes(heredocRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']
            expect(lines[1][6]).toEqual value: '\\\\', scopes: regexpDecodedNamedSubroutineTransportScopes(heredocRegexpScope)
            expect(lines[1][7]).toEqual value: 'g', scopes: regexpNamedSubroutineScopes(heredocRegexpScope)
            expect(lines[1][8]).toEqual value: '\'', scopes: regexpNamedSubroutineScopes(heredocRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
            expect(lines[1][9]).toEqual value: 'word', scopes: regexpNamedSubroutineNameScopes(heredocRegexpScope)
            expect(lines[1][10]).toEqual value: '\'', scopes: regexpNamedSubroutineScopes(heredocRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']
            expect(lines[1][11]).toEqual value: '\\\\', scopes: regexpDecodedSubroutineTransportScopes(heredocRegexpScope)
            expect(lines[1][12]).toEqual value: 'g', scopes: regexpSubroutineScopes(heredocRegexpScope)
            expect(lines[1][13]).toEqual value: '<', scopes: regexpSubroutineScopes(heredocRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
            expect(lines[1][14]).toEqual value: '1', scopes: regexpSubroutineScopes(heredocRegexpScope).concat ['constant.numeric.regexp.php']
            expect(lines[1][15]).toEqual value: '>', scopes: regexpSubroutineScopes(heredocRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']
            expect(lines[1][16]).toEqual value: '\\\\', scopes: regexpDecodedSubroutineTransportScopes(heredocRegexpScope)
            expect(lines[1][17]).toEqual value: 'g', scopes: regexpSubroutineScopes(heredocRegexpScope)
            expect(lines[1][18]).toEqual value: '<', scopes: regexpSubroutineScopes(heredocRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
            expect(lines[1][19]).toEqual value: '+1', scopes: regexpSubroutineScopes(heredocRegexpScope).concat ['constant.numeric.regexp.php']
            expect(lines[1][20]).toEqual value: '>', scopes: regexpSubroutineScopes(heredocRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']
            expect(lines[1][21]).toEqual value: '\\\\', scopes: regexpDecodedSubroutineTransportScopes(heredocRegexpScope)
            expect(lines[1][22]).toEqual value: 'g', scopes: regexpSubroutineScopes(heredocRegexpScope)
            expect(lines[1][23]).toEqual value: '\'', scopes: regexpSubroutineScopes(heredocRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php']
            expect(lines[1][24]).toEqual value: '-1', scopes: regexpSubroutineScopes(heredocRegexpScope).concat ['constant.numeric.regexp.php']
            expect(lines[1][25]).toEqual value: '\'', scopes: regexpSubroutineScopes(heredocRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php']
            expect(lines[1][26]).toEqual value: '/', scopes: heredocRegexpScope
            expect(lines[2][0]).toEqual value: 'REGEX', scopes: heredocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.heredoc.php']

          it 'should tokenize raw short hex escapes in REGEX heredoc', ->
            lines = grammar.tokenizeLines '''
              $r = <<<REGEX
              /\\x/
              REGEX;
            '''

            expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
            expect(lines[1][1]).toEqual value: '\\x', scopes: heredocRegexpScope.concat ['constant.character.numeric.regexp.php']
            expect(lines[1][2]).toEqual value: '/', scopes: heredocRegexpScope

          it 'should tokenize decoded anchors and short hex escapes in REGEX heredoc', ->
            lines = grammar.tokenizeLines '''
              $r = <<<REGEX
              /\\\\b\\\\x\\\\z/
              REGEX;
            '''

            expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
            expect(lines[1][1]).toEqual value: '\\\\', scopes: regexpDecodedAnchorTransportScopes(heredocRegexpScope)
            expect(lines[1][2]).toEqual value: 'b', scopes: heredocRegexpScope.concat ['keyword.control.anchor.regexp.php']
            expect(lines[1][3]).toEqual value: '\\\\', scopes: regexpDecodedNumericTransportScopes(heredocRegexpScope)
            expect(lines[1][4]).toEqual value: 'x', scopes: heredocRegexpScope.concat ['constant.character.numeric.regexp.php']
            expect(lines[1][5]).toEqual value: '\\\\', scopes: regexpDecodedAnchorTransportScopes(heredocRegexpScope)
            expect(lines[1][6]).toEqual value: 'z', scopes: heredocRegexpScope.concat ['keyword.control.anchor.regexp.php']
            expect(lines[1][7]).toEqual value: '/', scopes: heredocRegexpScope

          it 'should tokenize the full decoded anchor surface in REGEX heredoc', ->
            lines = grammar.tokenizeLines '''
              $r = <<<REGEX
              /\\\\b\\\\B\\\\A\\\\Z\\\\z\\\\G/
              REGEX;
            '''

            expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
            offset = 1
            for anchor in ['b', 'B', 'A', 'Z', 'z', 'G']
              expect(lines[1][offset]).toEqual value: '\\\\', scopes: regexpDecodedAnchorTransportScopes(heredocRegexpScope)
              expect(lines[1][offset + 1]).toEqual value: anchor, scopes: heredocRegexpScope.concat ['keyword.control.anchor.regexp.php']
              offset += 2
            expect(lines[1][offset]).toEqual value: '/', scopes: heredocRegexpScope

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

          it 'should tokenize the full raw anchor surface in REGEXP nowdoc', ->
            rawAnchors = ['\\b', '\\B', '\\A', '\\Z', '\\z', '\\G', '^', '$']
            lines = grammar.tokenizeLines [
              "$r = <<<'REGEXP'"
              '/' + rawAnchors.join('') + '/'
              'REGEXP;'
            ].join "\n"

            expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
            offset = 1
            for anchor in rawAnchors
              expect(lines[1][offset]).toEqual value: anchor, scopes: nowdocRegexpScope.concat ['keyword.control.anchor.regexp.php']
              offset += 1
            expect(lines[1][offset]).toEqual value: '/', scopes: nowdocRegexpScope

          it 'should tokenize the full raw structural-escape surface in REGEXP nowdoc', ->
            rawEscapes = ['\\.', '\\$', '\\^', '\\[', '\\]', '\\{', '\\}']
            lines = grammar.tokenizeLines [
              "$r = <<<'REGEXP'"
              '/' + rawEscapes.join('') + '/'
              'REGEXP;'
            ].join "\n"

            expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
            offset = 1
            for escape in rawEscapes
              expect(lines[1][offset]).toEqual value: escape, scopes: nowdocRegexpScope.concat ['constant.character.escape.regexp.php']
              offset += 1
            expect(lines[1][offset]).toEqual value: '/', scopes: nowdocRegexpScope

          it 'should tokenize raw escaped parentheses in REGEXP nowdoc', ->
            lines = grammar.tokenizeLines [
              "$r = <<<'REGEXP'"
              '/\\(\\)/'
              'REGEXP;'
            ].join "\n"

            expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
            expect(lines[1][1]).toEqual value: '\\(', scopes: nowdocRegexpScope.concat ['constant.character.escape.regexp.php']
            expect(lines[1][2]).toEqual value: '\\)', scopes: nowdocRegexpScope.concat ['constant.character.escape.regexp.php']
            expect(lines[1][3]).toEqual value: '/', scopes: nowdocRegexpScope

          it 'should tokenize decoded property, braced hex, and braced octal escapes in REGEX heredoc', ->
            lines = grammar.tokenizeLines """
              $r = <<<REGEX
              /\\\\pL\\\\PL\\\\p{L}\\\\P{N}\\\\x{41}\\\\o{141}/
              REGEX;
            """

            expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
            expect(lines[1][1]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
            expect(lines[1][2]).toEqual value: 'pL', scopes: heredocRegexpScope.concat ['constant.character.class.regexp.php']
            expect(lines[1][3]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
            expect(lines[1][4]).toEqual value: 'PL', scopes: heredocRegexpScope.concat ['constant.character.class.regexp.php']
            expect(lines[1][5]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
            expect(lines[1][6]).toEqual value: 'p{L}', scopes: heredocRegexpScope.concat ['constant.character.class.regexp.php']
            expect(lines[1][7]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
            expect(lines[1][8]).toEqual value: 'P{N}', scopes: heredocRegexpScope.concat ['constant.character.class.regexp.php']
            expect(lines[1][9]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.numeric.regexp.php']
            expect(lines[1][10]).toEqual value: 'x{41}', scopes: heredocRegexpScope.concat ['constant.character.numeric.regexp.php']
            expect(lines[1][11]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.numeric.octal.regexp.php']
            expect(lines[1][12]).toEqual value: 'o{141}', scopes: regexpOctalScopes(heredocRegexpScope)
            expect(lines[1][13]).toEqual value: '/', scopes: heredocRegexpScope
            expect(lines[2][0]).toEqual value: 'REGEX', scopes: heredocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.heredoc.php']
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

        it "should tokenize line comments in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /a # note
            b/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/a ', scopes: regexScope
          expect(lines[1][1]).toEqual value: '#', scopes: regexScope.concat ['comment.line.number-sign.php', 'punctuation.definition.comment.php']
          expect(lines[1][2]).toEqual value: ' ', scopes: regexScope.concat ['comment.line.number-sign.php']
          expect(lines[1][3]).toEqual value: 'note', scopes: regexScope.concat ['comment.line.number-sign.php']
          expect(lines[2][0]).toEqual value: 'b/', scopes: regexScope
          expect(lines[3][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[3][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should allow only the conservative explicit # comment starters in #{description}", ->
          allowedLines = [
            'a # note'
            'b # 1'
            'c # _'
            'd # .'
            'e # ,'
            'f # ?'
            'g # !'
            'h # -'
            'i # é'
            "j # \tnote"
            'k #'
          ]

          for commentLine in allowedLines
            lines = grammar.tokenizeLines """
              $r = #{opener}
              #{commentLine}
              z
              #{label};
            """

            expect(lines[1].some((token) -> token.scopes.includes 'comment.line.number-sign.php')).toBe true
            expect(lines[2][0]).toEqual value: 'z', scopes: regexScope

        it "should keep disallowed explicit # starters plain in #{description}", ->
          disallowedLines = [
            'a# note'
            'b #note'
            'c # :'
            'd # /'
            'e # ='
            'f # "'
            "g # '"
          ]

          for commentLine in disallowedLines
            lines = grammar.tokenizeLines """
              $r = #{opener}
              #{commentLine}
              z
              #{label};
            """

            expect(lines[1].some((token) -> token.scopes.includes 'comment.line.number-sign.php')).toBe false
            expect(lines[2][0]).toEqual value: 'z', scopes: regexScope

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

    it 'should keep transported PHP code-point escapes PHP-first in REGEXP heredoc character classes', ->
      lines = grammar.tokenizeLines [
        '$r = <<<REGEXP'
        '/[' + '\\'.repeat(3) + 'x21' + '\\'.repeat(3) + 'u{21}]/'
        'REGEXP;'
      ].join "\n"

      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php']
      expect(lines[1][3]).toEqual value: '\\x21', scopes: regexpCharacterClassPhpHexEscapeScopes(heredocRegexpScope)
      expect(lines[1][4]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php']
      expect(lines[1][5]).toEqual value: '\\u{21}', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.unicode.php']
      expect(lines[1][6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][7]).toEqual value: '/', scopes: heredocRegexpScope

    it 'should tokenize decoded overlapping escapes in REGEXP heredoc character classes', ->
      lines = grammar.tokenizeLines '''
        $r = <<<REGEXP
        /[\\\\1\\\\x41\\\\n\\\\v\\\\$]/
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.numeric.octal.regexp.php']
      expect(lines[1][3]).toEqual value: '1', scopes: regexpCharacterClassOctalScopes(heredocRegexpScope)
      expect(lines[1][4]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.character.numeric.regexp.php']
      expect(lines[1][5]).toEqual value: 'x41', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(lines[1][6]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(lines[1][7]).toEqual value: 'n', scopes: regexpCharacterClassEscapeScopes(heredocRegexpScope)
      expect(lines[1][8]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(lines[1][9]).toEqual value: 'v', scopes: regexpCharacterClassClassEscapeScopes(heredocRegexpScope)
      expect(lines[1][10]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(lines[1][11]).toEqual value: '$', scopes: regexpCharacterClassEscapeScopes(heredocRegexpScope)
      expect(lines[1][12]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][13]).toEqual value: '/', scopes: heredocRegexpScope

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

    it 'should tokenize single-quoted and PCRE named groups in REGEXP nowdoc', ->
      singleQuoted = grammar.tokenizeLines '''
        $r = <<<'REGEXP'
        /(?'word'ab)/
        REGEXP;
      '''
      pcre = grammar.tokenizeLines '''
        $r = <<<'REGEXP'
        /(?P<word>ab)/
        REGEXP;
      '''

      expect(singleQuoted[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(singleQuoted[1][1]).toEqual value: '(', scopes: regexpGroupScopes(nowdocRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(singleQuoted[1][2]).toEqual value: '?\'', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(nowdocRegexpScope), 'punctuation.definition.group.capture.begin.regexp.php')
      expect(singleQuoted[1][3]).toEqual value: 'word', scopes: regexpGroupNameScopes(regexpGroupScopes(nowdocRegexpScope))
      expect(singleQuoted[1][4]).toEqual value: '\'', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(nowdocRegexpScope), 'punctuation.definition.group.capture.end.regexp.php')
      expect(singleQuoted[1][5]).toEqual value: 'ab', scopes: regexpGroupContentScopes(nowdocRegexpScope)
      expect(singleQuoted[1][6]).toEqual value: ')', scopes: regexpGroupScopes(nowdocRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(singleQuoted[1][7]).toEqual value: '/', scopes: nowdocRegexpScope

      expect(pcre[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(pcre[1][1]).toEqual value: '(', scopes: regexpGroupScopes(nowdocRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(pcre[1][2]).toEqual value: '?P<', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(nowdocRegexpScope), 'punctuation.definition.group.capture.begin.regexp.php')
      expect(pcre[1][3]).toEqual value: 'word', scopes: regexpGroupNameScopes(regexpGroupScopes(nowdocRegexpScope))
      expect(pcre[1][4]).toEqual value: '>', scopes: regexpSpecificGroupPunctuationScopes(regexpGroupScopes(nowdocRegexpScope), 'punctuation.definition.group.capture.end.regexp.php')
      expect(pcre[1][5]).toEqual value: 'ab', scopes: regexpGroupContentScopes(nowdocRegexpScope)
      expect(pcre[1][6]).toEqual value: ')', scopes: regexpGroupScopes(nowdocRegexpScope).concat ['punctuation.definition.group.regexp.php']
      expect(pcre[1][7]).toEqual value: '/', scopes: nowdocRegexpScope

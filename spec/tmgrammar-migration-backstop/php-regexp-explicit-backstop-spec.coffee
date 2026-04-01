{loadGrammar} = require('../../utils/loadGrammar')
require('../../utils/compatibleExpect')
{expect} = require('chai')

{
  regexpCharacterClassScopes
  regexpCharacterClassClassEscapeScopes
  heredocRegexpBoundaryScope
  heredocRegexpScope
  nowdocRegexpBoundaryScope
  nowdocRegexpScope
  regexpCharacterClassDecodedEscapeTransportScopes
  regexpCharacterClassPhpEscapeScopes
  regexpCharacterClassPunctuationScopes
  regexpCharacterClassEscapeScopes
  regexpCharacterClassLiteralScopes
  regexpCharacterClassLetterRangeScopes
  regexpCharacterClassPosixScopes
  regexpCharacterClassRangeOperatorScopes
  regexpCharacterClassInvalidEscapeScopes
  regexpCharacterClassDecodedInvalidTransportScopes
  regexpInvalidEscapeScopes
  regexpDecodedInvalidTransportScopes
  regexpQuotedLiteralBoundaryScopes
  regexpDecodedQuotedLiteralTransportScopes
  regexpQuotedLiteralContentScopes
  regexpCharacterClassQuotedLiteralBoundaryScopes
  regexpCharacterClassDecodedQuotedLiteralTransportScopes
  regexpCharacterClassQuotedLiteralContentScopes
  regexpGroupScopes
  regexpSpecificGroupPunctuationScopes
  regexpGroupNameScopes
  regexpNamedBackreferenceScopes
  regexpNamedBackreferenceNameScopes
  regexpCommentGroupScopes
  regexpGroupContentScopes
  regexpRangeQuantifierBeginScopes
  regexpRangeQuantifierScopes
  regexpRangeQuantifierEndScopes
  regexpWildcardScopes
} = require '../php-regexp-helpers'

describe 'PHP explicit regexp tmgrammar migration backstop', ->
  grammar = null
  before(-> grammar = await loadGrammar('source.php'))

  it 'parses the grammar', ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe 'source.php'

  describe 'explicit REGEX and REGEXP blocks', ->
    it 'should tokenize escaped `[` in REGEX heredoc', ->
      bodyTokens = grammar.tokenizeLines('''
        $a = <<<REGEX
        /\\[/
        REGEX;
      ''')[1]

      expect(bodyTokens[0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(bodyTokens[1]).toEqual value: '\\[', scopes: heredocRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(bodyTokens[2]).toEqual value: '/', scopes: heredocRegexpScope

    it 'should tokenize doubled class backslashes in REGEX nowdoc', ->
      bodyTokens = grammar.tokenizeLines('''
        $a = <<<'REGEX'
        /[\\\\\\\\]/
        REGEX;
      ''')[1]

      expect(bodyTokens[0]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(bodyTokens[1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(bodyTokens[2]).toEqual value: '\\\\', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
      expect(bodyTokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
      expect(bodyTokens[4]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(bodyTokens[5]).toEqual value: '/', scopes: nowdocRegexpScope

    it 'should tokenize escaped `[` in REGEX nowdoc', ->
      bodyTokens = grammar.tokenizeLines('''
        $a = <<<'REGEX'
        /\\[/
        REGEX;
      ''')[1]

      expect(bodyTokens[0]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(bodyTokens[1]).toEqual value: '\\[', scopes: nowdocRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(bodyTokens[2]).toEqual value: '/', scopes: nowdocRegexpScope

    it 'should tokenize escaped `[` in REGEXP heredoc', ->
      bodyTokens = grammar.tokenizeLines('''
        $a = <<<REGEXP
        /\\[/
        REGEXP;
      ''')[1]

      expect(bodyTokens[0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(bodyTokens[1]).toEqual value: '\\[', scopes: heredocRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(bodyTokens[2]).toEqual value: '/', scopes: heredocRegexpScope

    it 'should tokenize doubled class backslashes in REGEXP nowdoc', ->
      bodyTokens = grammar.tokenizeLines('''
        $a = <<<'REGEXP'
        /[\\\\\\\\]/
        REGEXP;
      ''')[1]

      expect(bodyTokens[0]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(bodyTokens[1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(bodyTokens[2]).toEqual value: '\\\\', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
      expect(bodyTokens[3]).toEqual value: '\\\\', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
      expect(bodyTokens[4]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(bodyTokens[5]).toEqual value: '/', scopes: nowdocRegexpScope

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
        opener: "<<<'REGEXP'"
        label: 'REGEXP'
        regexScope: nowdocRegexpScope
        terminatorScope: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.nowdoc.php']
      }
    ]
      do (description, opener, label, regexScope, terminatorScope) ->
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

        it "should keep escaped alternation and quantifiers distinct from real operators in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /\\|\\?\\+\\*a?b+c*/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '\\|', scopes: regexScope.concat ['constant.character.escape.regexp.php']
          expect(lines[1][2]).toEqual value: '\\?', scopes: regexScope.concat ['constant.character.escape.regexp.php']
          expect(lines[1][3]).toEqual value: '\\+', scopes: regexScope.concat ['constant.character.escape.regexp.php']
          expect(lines[1][4]).toEqual value: '\\*', scopes: regexScope.concat ['constant.character.escape.regexp.php']
          expect(lines[1][5]).toEqual value: 'a', scopes: regexScope
          expect(lines[1][6]).toEqual value: '?', scopes: regexScope.concat ['keyword.operator.quantifier.regexp.php']
          expect(lines[1][7]).toEqual value: 'b', scopes: regexScope
          expect(lines[1][8]).toEqual value: '+', scopes: regexScope.concat ['keyword.operator.quantifier.regexp.php']
          expect(lines[1][9]).toEqual value: 'c', scopes: regexScope
          expect(lines[1][10]).toEqual value: '*', scopes: regexScope.concat ['keyword.operator.quantifier.regexp.php']
          expect(lines[1][11]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should keep anchors distinct from fallback operator chars in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /^a$+*/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '^', scopes: regexScope.concat ['keyword.control.anchor.regexp.php']
          expect(lines[1][2]).toEqual value: 'a', scopes: regexScope
          expect(lines[1][3]).toEqual value: '$', scopes: regexScope.concat ['keyword.control.anchor.regexp.php']
          expect(lines[1][4]).toEqual value: '+', scopes: regexScope.concat ['keyword.operator.quantifier.regexp.php']
          expect(lines[1][5]).toEqual value: '*', scopes: regexScope.concat ['keyword.operator.quantifier.regexp.php']
          expect(lines[1][6]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should keep operator-looking punctuation literal inside character classes in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /[.?+*^$|(){}]/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          for value, i in ['.', '?', '+', '*', '^', '$', '|', '(', ')', '{', '}']
            expect(lines[1][i + 2]).toEqual value: value, scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[1][13]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][14]).toEqual value: '/', scopes: regexScope
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

        it "should keep operator-looking punctuation literal inside quoted literals in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /\\Q.?+*^$|(){}[]\\E/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(regexScope).concat ['constant.character.escape.regexp.php']
          expect(lines[1][2]).toEqual value: '.?+*^$|(){}[]', scopes: regexpQuotedLiteralContentScopes(regexScope)
          expect(lines[1][3]).toEqual value: '\\E', scopes: regexpQuotedLiteralBoundaryScopes(regexScope).concat ['constant.character.escape.regexp.php']
          expect(lines[1][4]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize standalone quoted-literal end markers in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /\\E/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '\\E', scopes: regexScope.concat ['constant.character.escape.regexp.php']
          expect(lines[1][2]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

    describe 'explicit quoted literals', ->
      it 'should tokenize decoded quoted literals in REGEXP heredoc', ->
        lines = grammar.tokenizeLines '''
          $r = <<<REGEXP
          /\\\\Qfoo/bar\\\\E/
          REGEXP;
        '''

        expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
        expect(lines[1][1]).toEqual value: '\\\\', scopes: regexpDecodedQuotedLiteralTransportScopes(heredocRegexpScope)
        expect(lines[1][2]).toEqual value: 'Q', scopes: regexpQuotedLiteralBoundaryScopes(heredocRegexpScope).concat ['constant.character.escape.regexp.php']
        expect(lines[1][3]).toEqual value: 'foo/bar', scopes: regexpQuotedLiteralContentScopes(heredocRegexpScope)
        expect(lines[1][4]).toEqual value: '\\\\', scopes: regexpDecodedQuotedLiteralTransportScopes(heredocRegexpScope)
        expect(lines[1][5]).toEqual value: 'E', scopes: regexpQuotedLiteralBoundaryScopes(heredocRegexpScope).concat ['constant.character.escape.regexp.php']
        expect(lines[1][6]).toEqual value: '/', scopes: heredocRegexpScope

      it 'should tokenize asymmetric quoted-literal boundaries in REGEXP heredoc', ->
        decodedStartLines = grammar.tokenizeLines '''
          $r = <<<REGEXP
          /\\\\Qabc\\E/
          REGEXP;
        '''
        rawStartLines = grammar.tokenizeLines '''
          $r = <<<REGEXP
          /\\Qabc\\\\E/
          REGEXP;
        '''

        expect(decodedStartLines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
        expect(decodedStartLines[1][1]).toEqual value: '\\\\', scopes: regexpDecodedQuotedLiteralTransportScopes(heredocRegexpScope)
        expect(decodedStartLines[1][2]).toEqual value: 'Q', scopes: regexpQuotedLiteralBoundaryScopes(heredocRegexpScope).concat ['constant.character.escape.regexp.php']
        expect(decodedStartLines[1][3]).toEqual value: 'abc', scopes: regexpQuotedLiteralContentScopes(heredocRegexpScope)
        expect(decodedStartLines[1][4]).toEqual value: '\\E', scopes: regexpQuotedLiteralBoundaryScopes(heredocRegexpScope).concat ['constant.character.escape.regexp.php']
        expect(decodedStartLines[1][5]).toEqual value: '/', scopes: heredocRegexpScope

        expect(rawStartLines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
        expect(rawStartLines[1][1]).toEqual value: '\\Q', scopes: regexpQuotedLiteralBoundaryScopes(heredocRegexpScope).concat ['constant.character.escape.regexp.php']
        expect(rawStartLines[1][2]).toEqual value: 'abc', scopes: regexpQuotedLiteralContentScopes(heredocRegexpScope)
        expect(rawStartLines[1][3]).toEqual value: '\\\\', scopes: regexpDecodedQuotedLiteralTransportScopes(heredocRegexpScope)
        expect(rawStartLines[1][4]).toEqual value: 'E', scopes: regexpQuotedLiteralBoundaryScopes(heredocRegexpScope).concat ['constant.character.escape.regexp.php']
        expect(rawStartLines[1][5]).toEqual value: '/', scopes: heredocRegexpScope

    describe 'explicit quoted-literal character classes', ->
      it 'should tokenize quoted literals inside REGEXP heredoc character classes', ->
        rawLines = grammar.tokenizeLines '''
          $r = <<<REGEXP
          /[\\Q[']\\Ea]/
          REGEXP;
        '''
        decodedLines = grammar.tokenizeLines '''
          $r = <<<REGEXP
          /[\\\\Q[']\\\\Ea]/
          REGEXP;
        '''
        decodedStartLines = grammar.tokenizeLines '''
          $r = <<<REGEXP
          /[\\\\Q[']\\Ea]/
          REGEXP;
        '''
        rawStartLines = grammar.tokenizeLines '''
          $r = <<<REGEXP
          /[\\Q[']\\\\Ea]/
          REGEXP;
        '''

        expect(rawLines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
        expect(rawLines[1][2]).toEqual value: '\\Q', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(heredocRegexpScope).concat ['constant.character.escape.regexp.php']
        expect(rawLines[1][3]).toEqual value: "[']", scopes: regexpCharacterClassQuotedLiteralContentScopes(heredocRegexpScope)
        expect(rawLines[1][4]).toEqual value: '\\E', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(heredocRegexpScope).concat ['constant.character.escape.regexp.php']
        expect(rawLines[1][5]).toEqual value: 'a', scopes: regexpCharacterClassLiteralScopes(heredocRegexpScope)
        expect(rawLines[1][6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)

        expect(decodedLines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedQuotedLiteralTransportScopes(heredocRegexpScope)
        expect(decodedLines[1][3]).toEqual value: 'Q', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(heredocRegexpScope).concat ['constant.character.escape.regexp.php']
        expect(decodedLines[1][4]).toEqual value: "[']", scopes: regexpCharacterClassQuotedLiteralContentScopes(heredocRegexpScope)
        expect(decodedLines[1][5]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedQuotedLiteralTransportScopes(heredocRegexpScope)
        expect(decodedLines[1][6]).toEqual value: 'E', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(heredocRegexpScope).concat ['constant.character.escape.regexp.php']

        expect(decodedStartLines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedQuotedLiteralTransportScopes(heredocRegexpScope)
        expect(decodedStartLines[1][3]).toEqual value: 'Q', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(heredocRegexpScope).concat ['constant.character.escape.regexp.php']
        expect(decodedStartLines[1][4]).toEqual value: "[']", scopes: regexpCharacterClassQuotedLiteralContentScopes(heredocRegexpScope)
        expect(decodedStartLines[1][5]).toEqual value: '\\E', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(heredocRegexpScope).concat ['constant.character.escape.regexp.php']

        expect(rawStartLines[1][2]).toEqual value: '\\Q', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(heredocRegexpScope).concat ['constant.character.escape.regexp.php']
        expect(rawStartLines[1][3]).toEqual value: "[']", scopes: regexpCharacterClassQuotedLiteralContentScopes(heredocRegexpScope)
        expect(rawStartLines[1][4]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedQuotedLiteralTransportScopes(heredocRegexpScope)
        expect(rawStartLines[1][5]).toEqual value: 'E', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(heredocRegexpScope).concat ['constant.character.escape.regexp.php']

      it 'should keep operator-looking punctuation literal inside REGEXP heredoc character-class quoted literals', ->
        lines = grammar.tokenizeLines '''
          $r = <<<REGEXP
          /[\\Q.?+*^$|(){}[]\\E]/
          REGEXP;
        '''

        expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
        expect(lines[1][2]).toEqual value: '\\Q', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(heredocRegexpScope).concat ['constant.character.escape.regexp.php']
        expect(lines[1][3]).toEqual value: '.?+*^$|(){}[]', scopes: regexpCharacterClassQuotedLiteralContentScopes(heredocRegexpScope)
        expect(lines[1][4]).toEqual value: '\\E', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(heredocRegexpScope).concat ['constant.character.escape.regexp.php']
        expect(lines[1][5]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)

      it 'should tokenize quoted literals inside REGEXP nowdoc character classes', ->
        lines = grammar.tokenizeLines '''
          $r = <<<'REGEXP'
          /[\\Q[]\\Ea]/
          /[\\Q[']\\Ea]/
          REGEXP;
        '''

        expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
        expect(lines[1][2]).toEqual value: '\\Q', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(nowdocRegexpScope).concat ['constant.character.escape.regexp.php']
        expect(lines[1][3]).toEqual value: '[]', scopes: regexpCharacterClassQuotedLiteralContentScopes(nowdocRegexpScope)
        expect(lines[1][4]).toEqual value: '\\E', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(nowdocRegexpScope).concat ['constant.character.escape.regexp.php']
        expect(lines[1][5]).toEqual value: 'a', scopes: regexpCharacterClassLiteralScopes(nowdocRegexpScope)
        expect(lines[1][6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)

        expect(lines[2][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
        expect(lines[2][2]).toEqual value: '\\Q', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(nowdocRegexpScope).concat ['constant.character.escape.regexp.php']
        expect(lines[2][3]).toEqual value: "[']", scopes: regexpCharacterClassQuotedLiteralContentScopes(nowdocRegexpScope)
        expect(lines[2][4]).toEqual value: '\\E', scopes: regexpCharacterClassQuotedLiteralBoundaryScopes(nowdocRegexpScope).concat ['constant.character.escape.regexp.php']
        expect(lines[2][5]).toEqual value: 'a', scopes: regexpCharacterClassLiteralScopes(nowdocRegexpScope)
        expect(lines[2][6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)

    describe 'explicit host quote parity', ->
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

      it 'should tokenize decoded double-quote escapes in REGEX heredoc', ->
        lines = grammar.tokenizeLines ['$r = <<<REGEX', '/' + '\\'.repeat(2) + '"'+ '/', 'REGEX;'].join "\n"

        expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
        expect(lines[1][1]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
        expect(lines[1][2]).toEqual value: '"', scopes: heredocRegexpScope.concat ['constant.character.escape.regexp.php']
        expect(lines[1][3]).toEqual value: '/', scopes: heredocRegexpScope

      it 'should tokenize raw apostrophe escapes in REGEXP nowdoc', ->
        lines = grammar.tokenizeLines '''
          $r = <<<'REGEXP'
          /\\'/
          REGEXP;
        '''

        expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
        expect(lines[1][1]).toEqual value: '\\\'', scopes: nowdocRegexpScope.concat ['constant.character.escape.regexp.php']
        expect(lines[1][2]).toEqual value: '/', scopes: nowdocRegexpScope

      it 'should tokenize raw double-quote escapes in REGEXP nowdoc', ->
        lines = grammar.tokenizeLines ["$r = <<<'REGEXP'", '/\\"/', 'REGEXP;'].join "\n"

        expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
        expect(lines[1][1]).toEqual value: '\\"', scopes: nowdocRegexpScope.concat ['constant.character.escape.regexp.php']
        expect(lines[1][2]).toEqual value: '/', scopes: nowdocRegexpScope

      it 'should tokenize decoded apostrophe escapes in REGEX heredoc character classes', ->
        lines = grammar.tokenizeLines ['$r = <<<REGEX', '/[' + '\\'.repeat(2) + "'a-z]/", 'REGEX;'].join "\n"

        expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
        expect(lines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
        expect(lines[1][3]).toEqual value: '\'', scopes: regexpCharacterClassEscapeScopes(heredocRegexpScope)
        expect(lines[1][4]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(heredocRegexpScope)
        expect(lines[1][5]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(heredocRegexpScope)
        expect(lines[1][6]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(heredocRegexpScope)

      it 'should tokenize decoded double-quote escapes in REGEX heredoc character classes', ->
        lines = grammar.tokenizeLines ['$r = <<<REGEX', '/[' + '\\'.repeat(2) + '"a-z]/', 'REGEX;'].join "\n"

        expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
        expect(lines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
        expect(lines[1][3]).toEqual value: '"', scopes: regexpCharacterClassEscapeScopes(heredocRegexpScope)
        expect(lines[1][4]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(heredocRegexpScope)
        expect(lines[1][5]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(heredocRegexpScope)
        expect(lines[1][6]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(heredocRegexpScope)

      it 'should decompose repeated interpreted backslashes before quotes in REGEX heredoc character classes', ->
        apostropheLines = grammar.tokenizeLines ['$r = <<<REGEX', '/[' + '\\'.repeat(4) + "'a-z]/", 'REGEX;'].join "\n"
        doubleQuoteLines = grammar.tokenizeLines ['$r = <<<REGEX', '/[' + '\\'.repeat(4) + '"a-z]/', 'REGEX;'].join "\n"

        expect(apostropheLines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
        expect(apostropheLines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php']
        expect(apostropheLines[1][3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
        expect(apostropheLines[1][4]).toEqual value: '\'', scopes: regexpCharacterClassLiteralScopes(heredocRegexpScope)
        expect(apostropheLines[1][5]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(heredocRegexpScope)

        expect(doubleQuoteLines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
        expect(doubleQuoteLines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php']
        expect(doubleQuoteLines[1][3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
        expect(doubleQuoteLines[1][4]).toEqual value: '"', scopes: regexpCharacterClassLiteralScopes(heredocRegexpScope)
        expect(doubleQuoteLines[1][5]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(heredocRegexpScope)

      it 'should keep longer quote parity consistent in REGEX heredoc character classes', ->
        apostropheLines = grammar.tokenizeLines ['$r = <<<REGEX', '/[' + '\\'.repeat(6) + "'a-z]/", 'REGEX;'].join "\n"
        doubleQuoteLines = grammar.tokenizeLines ['$r = <<<REGEX', '/[' + '\\'.repeat(6) + '"a-z]/', 'REGEX;'].join "\n"

        expect(apostropheLines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php']
        expect(apostropheLines[1][3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
        expect(apostropheLines[1][4]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
        expect(apostropheLines[1][5]).toEqual value: '\'', scopes: regexpCharacterClassEscapeScopes(heredocRegexpScope)
        expect(apostropheLines[1][6]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(heredocRegexpScope)

        expect(doubleQuoteLines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php']
        expect(doubleQuoteLines[1][3]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
        expect(doubleQuoteLines[1][4]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
        expect(doubleQuoteLines[1][5]).toEqual value: '"', scopes: regexpCharacterClassEscapeScopes(heredocRegexpScope)
        expect(doubleQuoteLines[1][6]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(heredocRegexpScope)

      it 'should tokenize quote parity in REGEXP nowdoc character classes', ->
        rawApostropheLines = grammar.tokenizeLines ["$r = <<<'REGEXP'", '/[' + '\\'.repeat(1) + "'a-z]/", 'REGEXP;'].join "\n"
        rawDoubleQuoteLines = grammar.tokenizeLines ["$r = <<<'REGEXP'", '/[' + '\\'.repeat(1) + '"a-z]/', 'REGEXP;'].join "\n"
        doubledBackslashDoubleQuoteLines = grammar.tokenizeLines ["$r = <<<'REGEXP'", '/[' + '\\'.repeat(2) + '"a-z]/', 'REGEXP;'].join "\n"

        expect(rawApostropheLines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
        expect(rawApostropheLines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
        expect(rawApostropheLines[1][2]).toEqual value: "\\'", scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
        expect(rawApostropheLines[1][3]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(nowdocRegexpScope)
        expect(rawApostropheLines[1][4]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(nowdocRegexpScope)
        expect(rawApostropheLines[1][5]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(nowdocRegexpScope)
        expect(rawApostropheLines[1][6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
        expect(rawApostropheLines[1][7]).toEqual value: '/', scopes: nowdocRegexpScope

        expect(rawDoubleQuoteLines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
        expect(rawDoubleQuoteLines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
        expect(rawDoubleQuoteLines[1][2]).toEqual value: '\\"', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
        expect(rawDoubleQuoteLines[1][3]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(nowdocRegexpScope)
        expect(rawDoubleQuoteLines[1][4]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(nowdocRegexpScope)
        expect(rawDoubleQuoteLines[1][5]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(nowdocRegexpScope)
        expect(rawDoubleQuoteLines[1][6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
        expect(rawDoubleQuoteLines[1][7]).toEqual value: '/', scopes: nowdocRegexpScope

        expect(doubledBackslashDoubleQuoteLines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
        expect(doubledBackslashDoubleQuoteLines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
        expect(doubledBackslashDoubleQuoteLines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
        expect(doubledBackslashDoubleQuoteLines[1][3]).toEqual value: '"', scopes: regexpCharacterClassLiteralScopes(nowdocRegexpScope)
        expect(doubledBackslashDoubleQuoteLines[1][4]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(nowdocRegexpScope)
        expect(doubledBackslashDoubleQuoteLines[1][5]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(nowdocRegexpScope)
        expect(doubledBackslashDoubleQuoteLines[1][6]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(nowdocRegexpScope)
        expect(doubledBackslashDoubleQuoteLines[1][7]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
        expect(doubledBackslashDoubleQuoteLines[1][8]).toEqual value: '/', scopes: nowdocRegexpScope

      it 'should keep longer quote parity consistent in REGEXP nowdoc character classes', ->
        apostropheLines = grammar.tokenizeLines ["$r = <<<'REGEXP'", '/[' + '\\'.repeat(6) + "'a-z]/", 'REGEXP;'].join "\n"
        doubleQuoteLines = grammar.tokenizeLines ["$r = <<<'REGEXP'", '/[' + '\\'.repeat(6) + '"a-z]/', 'REGEXP;'].join "\n"

        expect(apostropheLines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
        expect(apostropheLines[1][3]).toEqual value: '\\\\', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
        expect(apostropheLines[1][4]).toEqual value: '\\\\', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
        expect(apostropheLines[1][5]).toEqual value: '\'', scopes: regexpCharacterClassLiteralScopes(nowdocRegexpScope)
        expect(apostropheLines[1][6]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(nowdocRegexpScope)

        expect(doubleQuoteLines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
        expect(doubleQuoteLines[1][3]).toEqual value: '\\\\', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
        expect(doubleQuoteLines[1][4]).toEqual value: '\\\\', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
        expect(doubleQuoteLines[1][5]).toEqual value: '"', scopes: regexpCharacterClassLiteralScopes(nowdocRegexpScope)
        expect(doubleQuoteLines[1][6]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(nowdocRegexpScope)

  describe 'explicit character-class backslash parity before letter ranges', ->
    it 'should keep interpreted escaped backslashes separate from following letter ranges in REGEX heredoc character classes', ->
      threeBackslashes = '\\'.repeat 3
      lines = grammar.tokenizeLines ['$r = <<<REGEX', '/[' + threeBackslashes + 'a-z]/', 'REGEX;'].join "\n"

      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php']
      expect(lines[1][3]).toEqual value: '\\', scopes: regexpCharacterClassEscapeScopes(heredocRegexpScope)
      expect(lines[1][4]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(heredocRegexpScope)
      expect(lines[1][5]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(heredocRegexpScope)
      expect(lines[1][6]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(heredocRegexpScope)

    it 'should keep interpreted backslash parity consistent before letter ranges in REGEX heredoc character classes', ->
      oneBackslashLines = grammar.tokenizeLines ['$r = <<<REGEX', '/[\\a-z]/', 'REGEX;'].join "\n"
      twoBackslashLines = grammar.tokenizeLines ['$r = <<<REGEX', '/[\\\\a-z]/', 'REGEX;'].join "\n"

      expect(oneBackslashLines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(oneBackslashLines[1][2]).toEqual value: '\\a', scopes: regexpCharacterClassEscapeScopes(heredocRegexpScope)
      expect(oneBackslashLines[1][3]).toEqual value: '-', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['keyword.operator.range.regexp.php']
      expect(oneBackslashLines[1][4]).toEqual value: 'z', scopes: regexpCharacterClassLiteralScopes(heredocRegexpScope)

      expect(twoBackslashLines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(twoBackslashLines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(twoBackslashLines[1][3]).toEqual value: 'a', scopes: regexpCharacterClassEscapeScopes(heredocRegexpScope)
      expect(twoBackslashLines[1][4]).toEqual value: '-', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['keyword.operator.range.regexp.php']
      expect(twoBackslashLines[1][5]).toEqual value: 'z', scopes: regexpCharacterClassLiteralScopes(heredocRegexpScope)

    it 'should keep raw backslash parity consistent before letter ranges in REGEXP nowdoc character classes', ->
      oneBackslashLines = grammar.tokenizeLines ["$r = <<<'REGEXP'", '/[' + '\\'.repeat(1) + 'a-z]/', 'REGEXP;'].join "\n"
      twoBackslashLines = grammar.tokenizeLines ["$r = <<<'REGEXP'", '/[' + '\\'.repeat(2) + 'a-z]/', 'REGEXP;'].join "\n"
      threeBackslashLines = grammar.tokenizeLines ["$r = <<<'REGEXP'", '/[' + '\\'.repeat(3) + 'a-z]/', 'REGEXP;'].join "\n"
      fourBackslashLines = grammar.tokenizeLines ["$r = <<<'REGEXP'", '/[' + '\\'.repeat(4) + 'a-z]/', 'REGEXP;'].join "\n"

      expect(oneBackslashLines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(oneBackslashLines[1][2]).toEqual value: '\\a', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
      expect(oneBackslashLines[1][3]).toEqual value: '-', scopes: regexpCharacterClassScopes(nowdocRegexpScope).concat ['keyword.operator.range.regexp.php']
      expect(oneBackslashLines[1][4]).toEqual value: 'z', scopes: regexpCharacterClassLiteralScopes(nowdocRegexpScope)

      expect(twoBackslashLines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(twoBackslashLines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
      expect(twoBackslashLines[1][3]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(nowdocRegexpScope)
      expect(twoBackslashLines[1][4]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(nowdocRegexpScope)
      expect(twoBackslashLines[1][5]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(nowdocRegexpScope)

      expect(threeBackslashLines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(threeBackslashLines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
      expect(threeBackslashLines[1][3]).toEqual value: '\\a', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
      expect(threeBackslashLines[1][4]).toEqual value: '-', scopes: regexpCharacterClassScopes(nowdocRegexpScope).concat ['keyword.operator.range.regexp.php']
      expect(threeBackslashLines[1][5]).toEqual value: 'z', scopes: regexpCharacterClassLiteralScopes(nowdocRegexpScope)

      expect(fourBackslashLines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(fourBackslashLines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
      expect(fourBackslashLines[1][3]).toEqual value: '\\\\', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
      expect(fourBackslashLines[1][4]).toEqual value: 'a', scopes: regexpCharacterClassLetterRangeScopes(nowdocRegexpScope)
      expect(fourBackslashLines[1][5]).toEqual value: '-', scopes: regexpCharacterClassRangeOperatorScopes(nowdocRegexpScope)
      expect(fourBackslashLines[1][6]).toEqual value: 'z', scopes: regexpCharacterClassLetterRangeScopes(nowdocRegexpScope)

  describe 'explicit character-class backslash parity for structural payloads', ->
    it 'should keep interpreted backslash parity consistent before POSIX character classes in REGEX heredoc character classes', ->
      decodedClassEscapeScopes = regexpCharacterClassPhpEscapeScopes(heredocRegexpScope).concat ['constant.character.escape.regexp.php']
      phpClassEscapeScopes = regexpCharacterClassPhpEscapeScopes(heredocRegexpScope)

      oneBackslashLines = grammar.tokenizeLines ['$r = <<<REGEX', '/[\\[:digit:]]/', 'REGEX;'].join "\n"
      twoBackslashLines = grammar.tokenizeLines ['$r = <<<REGEX', '/[' + '\\'.repeat(2) + '[:digit:]]/', 'REGEX;'].join "\n"
      threeBackslashLines = grammar.tokenizeLines ['$r = <<<REGEX', '/[' + '\\'.repeat(3) + '[:digit:]]/', 'REGEX;'].join "\n"
      fourBackslashLines = grammar.tokenizeLines ['$r = <<<REGEX', '/[' + '\\'.repeat(4) + '[:digit:]]/', 'REGEX;'].join "\n"

      expect(oneBackslashLines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(oneBackslashLines[1][2]).toEqual value: '\\[', scopes: regexpCharacterClassEscapeScopes(heredocRegexpScope)
      expect(oneBackslashLines[1][3]).toEqual value: ':', scopes: regexpCharacterClassLiteralScopes(heredocRegexpScope)
      expect(oneBackslashLines[1][10]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)

      expect(twoBackslashLines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(twoBackslashLines[1][2]).toEqual value: '\\\\', scopes: decodedClassEscapeScopes
      expect(twoBackslashLines[1][3]).toEqual value: '[', scopes: regexpCharacterClassEscapeScopes(heredocRegexpScope)
      expect(twoBackslashLines[1][4]).toEqual value: ':', scopes: regexpCharacterClassLiteralScopes(heredocRegexpScope)
      expect(twoBackslashLines[1][11]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)

      expect(threeBackslashLines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(threeBackslashLines[1][2]).toEqual value: '\\\\', scopes: phpClassEscapeScopes
      expect(threeBackslashLines[1][3]).toEqual value: '\\', scopes: regexpCharacterClassEscapeScopes(heredocRegexpScope)
      expect(threeBackslashLines[1][4]).toEqual value: '[:', scopes: regexpCharacterClassPosixScopes(heredocRegexpScope).concat ['punctuation.definition.character-class.set.begin.regexp.php']
      expect(threeBackslashLines[1][6]).toEqual value: ':]', scopes: regexpCharacterClassPosixScopes(heredocRegexpScope).concat ['punctuation.definition.character-class.set.end.regexp.php']
      expect(threeBackslashLines[1][7]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)

      expect(fourBackslashLines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(fourBackslashLines[1][2]).toEqual value: '\\\\', scopes: phpClassEscapeScopes
      expect(fourBackslashLines[1][3]).toEqual value: '\\\\', scopes: decodedClassEscapeScopes
      expect(fourBackslashLines[1][4]).toEqual value: '[:', scopes: regexpCharacterClassPosixScopes(heredocRegexpScope).concat ['punctuation.definition.character-class.set.begin.regexp.php']
      expect(fourBackslashLines[1][6]).toEqual value: ':]', scopes: regexpCharacterClassPosixScopes(heredocRegexpScope).concat ['punctuation.definition.character-class.set.end.regexp.php']
      expect(fourBackslashLines[1][7]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)

    it 'should keep direct closing-bracket backslash parity consistent in REGEX heredoc character classes', ->
      decodedClassEscapeScopes = regexpCharacterClassPhpEscapeScopes(heredocRegexpScope).concat ['constant.character.escape.regexp.php']
      phpClassEscapeScopes = regexpCharacterClassPhpEscapeScopes(heredocRegexpScope)

      rawEscapedLines = grammar.tokenizeLines ['$r = <<<REGEX', '/[\\]a]/', 'REGEX;'].join "\n"
      decodedEscapedLines = grammar.tokenizeLines ['$r = <<<REGEX', '/[' + '\\'.repeat(2) + ']a]/', 'REGEX;'].join "\n"
      threeBackslashLines = grammar.tokenizeLines ['$r = <<<REGEX', '/[' + '\\'.repeat(3) + ']a]/', 'REGEX;'].join "\n"
      fourBackslashLines = grammar.tokenizeLines ['$r = <<<REGEX', '/[' + '\\'.repeat(4) + ']a]/', 'REGEX;'].join "\n"

      expect(rawEscapedLines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(rawEscapedLines[1][2]).toEqual value: '\\]', scopes: regexpCharacterClassEscapeScopes(heredocRegexpScope)
      expect(rawEscapedLines[1][3]).toEqual value: 'a', scopes: regexpCharacterClassLiteralScopes(heredocRegexpScope)
      expect(rawEscapedLines[1][4]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)

      expect(decodedEscapedLines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(decodedEscapedLines[1][2]).toEqual value: '\\\\', scopes: decodedClassEscapeScopes
      expect(decodedEscapedLines[1][3]).toEqual value: ']', scopes: regexpCharacterClassEscapeScopes(heredocRegexpScope)
      expect(decodedEscapedLines[1][4]).toEqual value: 'a', scopes: regexpCharacterClassLiteralScopes(heredocRegexpScope)
      expect(decodedEscapedLines[1][5]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)

      expect(threeBackslashLines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(threeBackslashLines[1][2]).toEqual value: '\\\\', scopes: phpClassEscapeScopes
      expect(threeBackslashLines[1][3]).toEqual value: '\\', scopes: regexpCharacterClassEscapeScopes(heredocRegexpScope)
      expect(threeBackslashLines[1][4]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(threeBackslashLines[1][5]).toEqual value: 'a]/', scopes: heredocRegexpScope

      expect(fourBackslashLines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(fourBackslashLines[1][2]).toEqual value: '\\\\', scopes: phpClassEscapeScopes
      expect(fourBackslashLines[1][3]).toEqual value: '\\\\', scopes: decodedClassEscapeScopes
      expect(fourBackslashLines[1][4]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(fourBackslashLines[1][5]).toEqual value: 'a]/', scopes: heredocRegexpScope

  describe 'explicit character-class odd-parity literalized payloads', ->
    it 'should literalize non-PHP-owned class payloads after odd interpreted backslash parity in REGEX heredoc character classes', ->
      payloads = ['h', 'i', 'd', 'p', ';', 'c']

      for slashCount in [3, 7]
        for payload in payloads
          lines = grammar.tokenizeLines ['$r = <<<REGEX', '/[a' + '\\'.repeat(slashCount) + payload + ']/', 'REGEX;'].join "\n"
          payloadIndex = lines[1].findIndex (token) -> token.value is payload

          expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
          expect(lines[1].some((token) -> token.value is '\\' + payload)).toBe false
          expect(payloadIndex).to.be.greaterThan 2
          expect(lines[1][payloadIndex - 1]).toEqual value: '\\', scopes: regexpCharacterClassEscapeScopes(heredocRegexpScope)
          expect(lines[1][payloadIndex]).toEqual value: payload, scopes: regexpCharacterClassLiteralScopes(heredocRegexpScope)
          expect(lines[1][payloadIndex + 1]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
          expect(lines[1][lines[1].length - 1]).toEqual value: '/', scopes: heredocRegexpScope

  describe 'explicit invalid escapes', ->
    it 'tokenizes closed malformed raw braced hex and octal escapes as invalid in REGEXP nowdoc', ->
      lines = grammar.tokenizeLines [
        "$r = <<<'REGEXP'"
        '/\\x{1,2}\\o{abc}/'
        '/[\\x{1,2}\\o{abc}]/'
        'REGEXP;'
      ].join "\n"

      expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(lines[1][1]).toEqual value: '\\x{1,2}', scopes: regexpInvalidEscapeScopes(nowdocRegexpScope)
      expect(lines[1][2]).toEqual value: '\\o{abc}', scopes: regexpInvalidEscapeScopes(nowdocRegexpScope)
      expect(lines[1][3]).toEqual value: '/', scopes: nowdocRegexpScope

      expect(lines[2][0]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(lines[2][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(lines[2][2]).toEqual value: '\\x{1,2}', scopes: regexpCharacterClassInvalidEscapeScopes(nowdocRegexpScope)
      expect(lines[2][3]).toEqual value: '\\o{abc}', scopes: regexpCharacterClassInvalidEscapeScopes(nowdocRegexpScope)
      expect(lines[2][4]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(lines[2][5]).toEqual value: '/', scopes: nowdocRegexpScope

    it 'tokenizes closed malformed decoded braced hex and octal escapes as invalid in REGEX heredoc', ->
      lines = grammar.tokenizeLines """
        $r = <<<REGEXP
        /\\\\x{1,2}\\\\o{abc}/
        /[\\\\x{1,2}\\\\o{abc}]/
        REGEXP;
      """

      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[1][1]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(heredocRegexpScope)
      expect(lines[1][2]).toEqual value: 'x{1,2}', scopes: regexpInvalidEscapeScopes(heredocRegexpScope)
      expect(lines[1][3]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(heredocRegexpScope)
      expect(lines[1][4]).toEqual value: 'o{abc}', scopes: regexpInvalidEscapeScopes(heredocRegexpScope)
      expect(lines[1][5]).toEqual value: '/', scopes: heredocRegexpScope

      expect(lines[2][0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[2][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[2][2]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedInvalidTransportScopes(heredocRegexpScope)
      expect(lines[2][3]).toEqual value: 'x{1,2}', scopes: regexpCharacterClassInvalidEscapeScopes(heredocRegexpScope)
      expect(lines[2][4]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedInvalidTransportScopes(heredocRegexpScope)
      expect(lines[2][5]).toEqual value: 'o{abc}', scopes: regexpCharacterClassInvalidEscapeScopes(heredocRegexpScope)
      expect(lines[2][6]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[2][7]).toEqual value: '/', scopes: heredocRegexpScope

    it 'tokenizes every closed malformed raw \\k form as invalid in REGEXP nowdoc', ->
      invalidKForms = ['\\k{}', '\\k{1}', '\\k{١foo}', '\\k{a💩}', '\\k<>', '\\k<1>', '\\k<💩>', '\\k<a💩>', '\\k\'\'', '\\k\'١foo\'', '\\k\'a💩\'']
      lines = grammar.tokenizeLines [
        "$r = <<<'REGEXP'"
        '/' + invalidKForms.join('') + '/'
        'REGEXP;'
      ].join "\n"

      expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
      offset = 1
      for invalidForm in invalidKForms
        expect(lines[1][offset]).toEqual value: invalidForm, scopes: regexpInvalidEscapeScopes(nowdocRegexpScope)
        offset += 1
      expect(lines[1][offset]).toEqual value: '/', scopes: nowdocRegexpScope

    it 'tokenizes every closed malformed raw \\g form as invalid in REGEXP nowdoc', ->
      invalidGForms = [
        '\\g{}'
        '\\g{+}'
        '\\g{1x}'
        '\\g{١foo}'
        '\\g{a💩}'
        '\\g<>'
        '\\g<+>'
        '\\g<1x>'
        '\\g<💩>'
        '\\g<a💩>'
        '\\g\'\''
        '\\g\'+\''
        '\\g\'1x\''
        '\\g\'١foo\''
        '\\g\'a💩\''
      ]
      lines = grammar.tokenizeLines [
        "$r = <<<'REGEXP'"
        '/' + invalidGForms.join('') + '/'
        'REGEXP;'
      ].join "\n"

      expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
      offset = 1
      for invalidForm in invalidGForms
        expect(lines[1][offset]).toEqual value: invalidForm, scopes: regexpInvalidEscapeScopes(nowdocRegexpScope)
        offset += 1
      expect(lines[1][offset]).toEqual value: '/', scopes: nowdocRegexpScope

    it 'tokenizes every closed malformed decoded \\k form as invalid in REGEX heredoc', ->
      invalidKPayloads = ['k{}', 'k{1}', 'k{١foo}', 'k{a💩}', 'k<>', 'k<1>', 'k<💩>', 'k<a💩>', 'k\'\'', 'k\'١foo\'', 'k\'a💩\'']
      lines = grammar.tokenizeLines [
        '$r = <<<REGEXP'
        '/' + invalidKPayloads.map((payload) -> '\\'.repeat(2) + payload).join('') + '/'
        'REGEXP;'
      ].join "\n"

      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      offset = 1
      for payload in invalidKPayloads
        expect(lines[1][offset]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(heredocRegexpScope)
        expect(lines[1][offset + 1]).toEqual value: payload, scopes: regexpInvalidEscapeScopes(heredocRegexpScope)
        offset += 2
      expect(lines[1][offset]).toEqual value: '/', scopes: heredocRegexpScope

    it 'tokenizes every closed malformed decoded \\g form as invalid in REGEX heredoc', ->
      invalidGPayloads = [
        'g{}'
        'g{+}'
        'g{1x}'
        'g{١foo}'
        'g{a💩}'
        'g<>'
        'g<+>'
        'g<1x>'
        'g<💩>'
        'g<a💩>'
        'g\'\''
        'g\'+\''
        'g\'1x\''
        'g\'١foo\''
        'g\'a💩\''
      ]
      lines = grammar.tokenizeLines [
        '$r = <<<REGEXP'
        '/' + invalidGPayloads.map((payload) -> '\\'.repeat(2) + payload).join('') + '/'
        'REGEXP;'
      ].join "\n"

      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      offset = 1
      for payload in invalidGPayloads
        expect(lines[1][offset]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(heredocRegexpScope)
        expect(lines[1][offset + 1]).toEqual value: payload, scopes: regexpInvalidEscapeScopes(heredocRegexpScope)
        offset += 2
      expect(lines[1][offset]).toEqual value: '/', scopes: heredocRegexpScope

  describe 'explicit escape mixtures', ->
    it 'should keep valid decoded body escapes, stray \\\\E, and invalid ones distinct in REGEX heredoc', ->
      lines = grammar.tokenizeLines '''
        $r = <<<REGEX
        /\\\\c;\\\\pL\\\\E\\\\L\\\\g\\\\k\\\\o\\\\p\\\\u/
        REGEX;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[1][1]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
      expect(lines[1][2]).toEqual value: 'c;', scopes: heredocRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(lines[1][3]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(lines[1][4]).toEqual value: 'pL', scopes: heredocRegexpScope.concat ['constant.character.class.regexp.php']
      expect(lines[1][5]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php']
      expect(lines[1][6]).toEqual value: 'E', scopes: heredocRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(lines[1][7]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(heredocRegexpScope)
      expect(lines[1][8]).toEqual value: 'L', scopes: regexpInvalidEscapeScopes(heredocRegexpScope)
      expect(lines[1][9]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(heredocRegexpScope)
      expect(lines[1][10]).toEqual value: 'g', scopes: regexpInvalidEscapeScopes(heredocRegexpScope)
      expect(lines[1][11]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(heredocRegexpScope)
      expect(lines[1][12]).toEqual value: 'k', scopes: regexpInvalidEscapeScopes(heredocRegexpScope)
      expect(lines[1][13]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(heredocRegexpScope)
      expect(lines[1][14]).toEqual value: 'o', scopes: regexpInvalidEscapeScopes(heredocRegexpScope)
      expect(lines[1][15]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(heredocRegexpScope)
      expect(lines[1][16]).toEqual value: 'p', scopes: regexpInvalidEscapeScopes(heredocRegexpScope)
      expect(lines[1][17]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(heredocRegexpScope)
      expect(lines[1][18]).toEqual value: 'u', scopes: regexpInvalidEscapeScopes(heredocRegexpScope)
      expect(lines[1][19]).toEqual value: '/', scopes: heredocRegexpScope

    it 'should keep valid raw body escapes, short \\x, stray \\E, and invalid ones distinct in REGEXP nowdoc', ->
      lines = grammar.tokenizeLines '''
        $r = <<<'REGEXP'
        /\\c;\\pL\\x\\E\\L\\g\\k\\o\\p\\u\\z\\A\\B\\G/
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(lines[1][1]).toEqual value: '\\c;', scopes: nowdocRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(lines[1][2]).toEqual value: '\\pL', scopes: nowdocRegexpScope.concat ['constant.character.class.regexp.php']
      expect(lines[1][3]).toEqual value: '\\x', scopes: nowdocRegexpScope.concat ['constant.character.numeric.regexp.php']
      expect(lines[1][4]).toEqual value: '\\E', scopes: nowdocRegexpScope.concat ['constant.character.escape.regexp.php']
      expect(lines[1][5]).toEqual value: '\\L', scopes: regexpInvalidEscapeScopes(nowdocRegexpScope)
      expect(lines[1][6]).toEqual value: '\\g', scopes: regexpInvalidEscapeScopes(nowdocRegexpScope)
      expect(lines[1][7]).toEqual value: '\\k', scopes: regexpInvalidEscapeScopes(nowdocRegexpScope)
      expect(lines[1][8]).toEqual value: '\\o', scopes: regexpInvalidEscapeScopes(nowdocRegexpScope)
      expect(lines[1][9]).toEqual value: '\\p', scopes: regexpInvalidEscapeScopes(nowdocRegexpScope)
      expect(lines[1][10]).toEqual value: '\\u', scopes: regexpInvalidEscapeScopes(nowdocRegexpScope)
      expect(lines[1][11]).toEqual value: '\\z', scopes: nowdocRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(lines[1][12]).toEqual value: '\\A', scopes: nowdocRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(lines[1][13]).toEqual value: '\\B', scopes: nowdocRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(lines[1][14]).toEqual value: '\\G', scopes: nowdocRegexpScope.concat ['keyword.control.anchor.regexp.php']
      expect(lines[1][15]).toEqual value: '/', scopes: nowdocRegexpScope

    it 'should keep valid decoded class escapes, stray \\\\E, and invalid ones distinct in REGEXP heredoc character classes', ->
      lines = grammar.tokenizeLines '''
        $r = <<<REGEXP
        /[\\\\c;\\\\pL\\\\PL\\\\E\\\\L\\\\z\\\\A\\\\D\\\\H\\\\V\\\\W]/
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][2]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedEscapeTransportScopes(heredocRegexpScope)
      expect(lines[1][3]).toEqual value: 'c;', scopes: regexpCharacterClassEscapeScopes(heredocRegexpScope)
      expect(lines[1][4]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(lines[1][5]).toEqual value: 'pL', scopes: regexpCharacterClassClassEscapeScopes(heredocRegexpScope)
      expect(lines[1][6]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(lines[1][7]).toEqual value: 'PL', scopes: regexpCharacterClassClassEscapeScopes(heredocRegexpScope)
      expect(lines[1][8]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedEscapeTransportScopes(heredocRegexpScope)
      expect(lines[1][9]).toEqual value: 'E', scopes: regexpCharacterClassEscapeScopes(heredocRegexpScope)
      expect(lines[1][10]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedInvalidTransportScopes(heredocRegexpScope)
      expect(lines[1][11]).toEqual value: 'L', scopes: regexpCharacterClassInvalidEscapeScopes(heredocRegexpScope)
      expect(lines[1][12]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedInvalidTransportScopes(heredocRegexpScope)
      expect(lines[1][13]).toEqual value: 'z', scopes: regexpCharacterClassInvalidEscapeScopes(heredocRegexpScope)
      expect(lines[1][14]).toEqual value: '\\\\', scopes: regexpCharacterClassDecodedInvalidTransportScopes(heredocRegexpScope)
      expect(lines[1][15]).toEqual value: 'A', scopes: regexpCharacterClassInvalidEscapeScopes(heredocRegexpScope)
      expect(lines[1][16]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(lines[1][17]).toEqual value: 'D', scopes: regexpCharacterClassClassEscapeScopes(heredocRegexpScope)
      expect(lines[1][18]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(lines[1][19]).toEqual value: 'H', scopes: regexpCharacterClassClassEscapeScopes(heredocRegexpScope)
      expect(lines[1][20]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(lines[1][21]).toEqual value: 'V', scopes: regexpCharacterClassClassEscapeScopes(heredocRegexpScope)
      expect(lines[1][22]).toEqual value: '\\\\', scopes: regexpCharacterClassScopes(heredocRegexpScope).concat ['constant.character.escape.php', 'constant.character.class.regexp.php']
      expect(lines[1][23]).toEqual value: 'W', scopes: regexpCharacterClassClassEscapeScopes(heredocRegexpScope)
      expect(lines[1][24]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
      expect(lines[1][25]).toEqual value: '/', scopes: heredocRegexpScope

    it 'should keep valid raw class escapes, stray \\E, short \\x, and invalid ones distinct in REGEXP nowdoc character classes', ->
      lines = grammar.tokenizeLines '''
        $r = <<<'REGEXP'
        /[\\c;\\pL\\PL\\x\\E\\L\\z\\A\\D\\H\\V\\W]/
        REGEXP;
      '''

      expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
      expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(lines[1][2]).toEqual value: '\\c;', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
      expect(lines[1][3]).toEqual value: '\\pL', scopes: regexpCharacterClassClassEscapeScopes(nowdocRegexpScope)
      expect(lines[1][4]).toEqual value: '\\PL', scopes: regexpCharacterClassClassEscapeScopes(nowdocRegexpScope)
      expect(lines[1][5]).toEqual value: '\\x', scopes: regexpCharacterClassScopes(nowdocRegexpScope).concat ['constant.character.numeric.regexp.php']
      expect(lines[1][6]).toEqual value: '\\E', scopes: regexpCharacterClassEscapeScopes(nowdocRegexpScope)
      expect(lines[1][7]).toEqual value: '\\L', scopes: regexpCharacterClassInvalidEscapeScopes(nowdocRegexpScope)
      expect(lines[1][8]).toEqual value: '\\z', scopes: regexpCharacterClassInvalidEscapeScopes(nowdocRegexpScope)
      expect(lines[1][9]).toEqual value: '\\A', scopes: regexpCharacterClassInvalidEscapeScopes(nowdocRegexpScope)
      expect(lines[1][10]).toEqual value: '\\D', scopes: regexpCharacterClassClassEscapeScopes(nowdocRegexpScope)
      expect(lines[1][11]).toEqual value: '\\H', scopes: regexpCharacterClassClassEscapeScopes(nowdocRegexpScope)
      expect(lines[1][12]).toEqual value: '\\V', scopes: regexpCharacterClassClassEscapeScopes(nowdocRegexpScope)
      expect(lines[1][13]).toEqual value: '\\W', scopes: regexpCharacterClassClassEscapeScopes(nowdocRegexpScope)
      expect(lines[1][14]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(nowdocRegexpScope)
      expect(lines[1][15]).toEqual value: '/', scopes: nowdocRegexpScope

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
        opener: "<<<'REGEXP'"
        label: 'REGEXP'
        regexScope: nowdocRegexpScope
        terminatorScope: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.nowdoc.php']
      }
    ]
      do (description, opener, label, regexScope, terminatorScope) ->
        if description is 'REGEXP nowdoc'
          it "should tokenize supported structural opener parity in #{description} from fixtures", ->
            structuralOpeners = [
              {
                structuralOpener: '['
                suffix: 'a]'
                assertStructured: (tokens) ->
                  expect(tokens[2]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
                  expect(tokens[3]).toEqual value: 'a', scopes: regexpCharacterClassLiteralScopes(regexScope)
                  expect(tokens[4]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
              }
              {
                structuralOpener: '('
                suffix: 'a)'
                assertStructured: (tokens) ->
                  expect(tokens[2]).toEqual value: '(', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
                  expect(tokens[3]).toEqual value: 'a', scopes: regexpGroupContentScopes(regexScope)
                  expect(tokens[4]).toEqual value: ')', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']
              }
              {
                structuralOpener: '{'
                suffix: '1}'
                assertStructured: (tokens) ->
                  expect(tokens[2]).toEqual value: '{', scopes: regexpRangeQuantifierBeginScopes(regexScope)
                  expect(tokens[3]).toEqual value: '1', scopes: regexpRangeQuantifierScopes(regexScope)
                  expect(tokens[4]).toEqual value: '}', scopes: regexpRangeQuantifierEndScopes(regexScope)
              }
            ]

            for {structuralOpener, suffix, assertStructured} in structuralOpeners
              oneBackslashLines = grammar.tokenizeLines ['$r = ' + opener, '/' + '\\'.repeat(1) + structuralOpener + suffix + '/', label + ';'].join "\n"
              twoBackslashLines = grammar.tokenizeLines ['$r = ' + opener, '/' + '\\'.repeat(2) + structuralOpener + suffix + '/', label + ';'].join "\n"
              threeBackslashLines = grammar.tokenizeLines ['$r = ' + opener, '/' + '\\'.repeat(3) + structuralOpener + suffix + '/', label + ';'].join "\n"

              expect(oneBackslashLines[1][0]).toEqual value: '/', scopes: regexScope
              expect(oneBackslashLines[1][1]).toEqual value: '\\' + structuralOpener, scopes: regexScope.concat ['constant.character.escape.regexp.php']
              expect(oneBackslashLines[1][2]).toEqual value: suffix + '/', scopes: regexScope

              expect(twoBackslashLines[1][0]).toEqual value: '/', scopes: regexScope
              expect(twoBackslashLines[1][1]).toEqual value: '\\\\', scopes: regexScope.concat ['constant.character.escape.regexp.php']
              assertStructured twoBackslashLines[1]
              expect(twoBackslashLines[1][5]).toEqual value: '/', scopes: regexScope

              expect(threeBackslashLines[1][0]).toEqual value: '/', scopes: regexScope
              expect(threeBackslashLines[1][1]).toEqual value: '\\\\', scopes: regexScope.concat ['constant.character.escape.regexp.php']
              expect(threeBackslashLines[1][2]).toEqual value: '\\' + structuralOpener, scopes: regexScope.concat ['constant.character.escape.regexp.php']
              expect(threeBackslashLines[1][3]).toEqual value: suffix + '/', scopes: regexScope

        if description is 'REGEX heredoc'
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

          it 'should decompose repeated interpreted backslashes before neutral punctuation in REGEX heredoc', ->
            fourBackslashes = '\\'.repeat 4
            lines = grammar.tokenizeLines ['$r = <<<REGEX', '/' + fourBackslashes + ';/', 'REGEX;'].join "\n"

            expect(lines[1][1]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php']
            expect(lines[1][2]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
            expect(lines[1][3]).toEqual value: ';/', scopes: heredocRegexpScope

          it 'should tokenize supported structural opener parity in REGEX heredoc from fixtures', ->
            structuralOpeners = [
              {
                structuralOpener: '['
                suffix: 'a]'
                assertStructured: (tokens) ->
                  expect(tokens[3]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
                  expect(tokens[4]).toEqual value: 'a', scopes: regexpCharacterClassLiteralScopes(heredocRegexpScope)
                  expect(tokens[5]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(heredocRegexpScope)
              }
              {
                structuralOpener: '('
                suffix: 'a)'
                assertStructured: (tokens) ->
                  expect(tokens[3]).toEqual value: '(', scopes: regexpGroupScopes(heredocRegexpScope).concat ['punctuation.definition.group.regexp.php']
                  expect(tokens[4]).toEqual value: 'a', scopes: regexpGroupContentScopes(heredocRegexpScope)
                  expect(tokens[5]).toEqual value: ')', scopes: regexpGroupScopes(heredocRegexpScope).concat ['punctuation.definition.group.regexp.php']
              }
              {
                structuralOpener: '{'
                suffix: '1}'
                assertStructured: (tokens) ->
                  expect(tokens[3]).toEqual value: '{', scopes: regexpRangeQuantifierBeginScopes(heredocRegexpScope)
                  expect(tokens[4]).toEqual value: '1', scopes: regexpRangeQuantifierScopes(heredocRegexpScope)
                  expect(tokens[5]).toEqual value: '}', scopes: regexpRangeQuantifierEndScopes(heredocRegexpScope)
              }
            ]

            for {structuralOpener, suffix, assertStructured} in structuralOpeners
              twoBackslashLines = grammar.tokenizeLines ['$r = <<<REGEX', '/' + '\\'.repeat(2) + structuralOpener + suffix + '/', 'REGEX;'].join "\n"
              threeBackslashLines = grammar.tokenizeLines ['$r = <<<REGEX', '/' + '\\'.repeat(3) + structuralOpener + suffix + '/', 'REGEX;'].join "\n"
              fourBackslashLines = grammar.tokenizeLines ['$r = <<<REGEX', '/' + '\\'.repeat(4) + structuralOpener + suffix + '/', 'REGEX;'].join "\n"

              expect(twoBackslashLines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
              expect(twoBackslashLines[1][1]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
              expect(twoBackslashLines[1][2]).toEqual value: structuralOpener, scopes: heredocRegexpScope.concat ['constant.character.escape.regexp.php']
              expect(twoBackslashLines[1][3]).toEqual value: suffix + '/', scopes: heredocRegexpScope

              expect(threeBackslashLines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
              expect(threeBackslashLines[1][1]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
              expect(threeBackslashLines[1][2]).toEqual value: '\\', scopes: heredocRegexpScope.concat ['constant.character.escape.regexp.php']
              assertStructured threeBackslashLines[1]
              expect(threeBackslashLines[1][6]).toEqual value: '/', scopes: heredocRegexpScope

              expect(fourBackslashLines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
              expect(fourBackslashLines[1][1]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php']
              expect(fourBackslashLines[1][2]).toEqual value: '\\\\', scopes: heredocRegexpScope.concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
              assertStructured fourBackslashLines[1]
              expect(fourBackslashLines[1][6]).toEqual value: '/', scopes: heredocRegexpScope

        if description is 'REGEXP nowdoc'
          it 'should tokenize neutral non-alnum punctuation escapes in REGEXP nowdoc', ->
            rawLines = grammar.tokenizeLines ["$r = <<<'REGEXP'", '/\\;/', 'REGEXP;'].join "\n"
            doubledLines = grammar.tokenizeLines ["$r = <<<'REGEXP'", '/\\\\;/', 'REGEXP;'].join "\n"

            expect(rawLines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
            expect(rawLines[1][1]).toEqual value: '\\;', scopes: nowdocRegexpScope.concat ['constant.character.escape.regexp.php']
            expect(rawLines[1][2]).toEqual value: '/', scopes: nowdocRegexpScope

            expect(doubledLines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
            expect(doubledLines[1][1]).toEqual value: '\\\\', scopes: nowdocRegexpScope.concat ['constant.character.escape.regexp.php']
            expect(doubledLines[1][2]).toEqual value: ';/', scopes: nowdocRegexpScope

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
        opener: "<<<'REGEXP'"
        label: 'REGEXP'
        regexScope: nowdocRegexpScope
        terminatorScope: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.nowdoc.php']
      }
    ]
      do (description, opener, label, regexScope, terminatorScope) ->
        it "should keep malformed braced quantifier text plain in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /a{}b{,}c{a}d{1a}e{1,2,3}f{,1x}/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/a{}b{,}c{a}d{1a}e{1,2,3}f{,1x}/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should let + quantify a literal opening brace in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /a{+1}/
            /a{-1}/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/a{', scopes: regexScope
          expect(lines[1][1]).toEqual value: '+', scopes: regexScope.concat ['keyword.operator.quantifier.regexp.php']
          expect(lines[1][2]).toEqual value: '1}/', scopes: regexScope
          expect(lines[2][0]).toEqual value: '/a{-1}/', scopes: regexScope
          expect(lines[3][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[3][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should tokenize anchors, dots, alternation, and quantifiers in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /^\\A.a+?|b{2,4}+$/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/', scopes: regexScope
          expect(lines[1][1]).toEqual value: '^', scopes: regexScope.concat ['keyword.control.anchor.regexp.php']
          expect(lines[1][2]).toEqual value: '\\A', scopes: regexScope.concat ['keyword.control.anchor.regexp.php']
          expect(lines[1][3]).toEqual value: '.', scopes: regexpWildcardScopes(regexScope)
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

        it "should tokenize simple quantifier variants in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /a?b??c?+d+e++f+?g*h*?i*+/
            #{label};
          """

          expect(lines[1][0]).toEqual value: '/a', scopes: regexScope
          expect(lines[1][1]).toEqual value: '?', scopes: regexScope.concat ['keyword.operator.quantifier.regexp.php']
          expect(lines[1][2]).toEqual value: 'b', scopes: regexScope
          expect(lines[1][3]).toEqual value: '??', scopes: regexScope.concat ['keyword.operator.quantifier.regexp.php']
          expect(lines[1][4]).toEqual value: 'c', scopes: regexScope
          expect(lines[1][5]).toEqual value: '?+', scopes: regexScope.concat ['keyword.operator.quantifier.regexp.php']
          expect(lines[1][6]).toEqual value: 'd', scopes: regexScope
          expect(lines[1][7]).toEqual value: '+', scopes: regexScope.concat ['keyword.operator.quantifier.regexp.php']
          expect(lines[1][8]).toEqual value: 'e', scopes: regexScope
          expect(lines[1][9]).toEqual value: '++', scopes: regexScope.concat ['keyword.operator.quantifier.regexp.php']
          expect(lines[1][10]).toEqual value: 'f', scopes: regexScope
          expect(lines[1][11]).toEqual value: '+?', scopes: regexScope.concat ['keyword.operator.quantifier.regexp.php']
          expect(lines[1][12]).toEqual value: 'g', scopes: regexScope
          expect(lines[1][13]).toEqual value: '*', scopes: regexScope.concat ['keyword.operator.quantifier.regexp.php']
          expect(lines[1][14]).toEqual value: 'h', scopes: regexScope
          expect(lines[1][15]).toEqual value: '*?', scopes: regexScope.concat ['keyword.operator.quantifier.regexp.php']
          expect(lines[1][16]).toEqual value: 'i', scopes: regexScope
          expect(lines[1][17]).toEqual value: '*+', scopes: regexScope.concat ['keyword.operator.quantifier.regexp.php']
          expect(lines[1][18]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

        it "should keep braced quantifier-like text literal inside character classes in #{description}", ->
          lines = grammar.tokenizeLines """
            $r = #{opener}
            /[{1}]/
            #{label};
          """

          expect(lines[1][1]).toEqual value: '[', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][2]).toEqual value: '{', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[1][3]).toEqual value: '1', scopes: regexpCharacterClassScopes(regexScope).concat ['constant.numeric.regexp.php']
          expect(lines[1][4]).toEqual value: '}', scopes: regexpCharacterClassLiteralScopes(regexScope)
          expect(lines[1][5]).toEqual value: ']', scopes: regexpCharacterClassPunctuationScopes(regexScope)
          expect(lines[1][6]).toEqual value: '/', scopes: regexScope
          expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
          expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

  describe 'explicit named groups and raw named backreferences', ->
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
        opener: "<<<'REGEXP'"
        label: 'REGEXP'
        regexScope: nowdocRegexpScope
        terminatorScope: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.nowdoc.php']
      }
    ]
      do (description, opener, label, regexScope, terminatorScope) ->
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

  describe 'explicit comment groups', ->
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
        opener: "<<<'REGEXP'"
        label: 'REGEXP'
        regexScope: nowdocRegexpScope
        terminatorScope: nowdocRegexpBoundaryScope.concat ['punctuation.section.embedded.end.php', 'keyword.operator.nowdoc.php']
      }
    ]
      do (description, opener, label, regexScope, terminatorScope) ->
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

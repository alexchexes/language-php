{loadGrammar} = require('../utils/loadGrammar')
require('../utils/compatibleExpect')
{expect} = require('chai')

describe 'PHP regexp backslash regressions', ->
  grammar = null
  before(-> grammar = await loadGrammar('source.php'))

  heredocRegexpBoundaryScope = ['source.php', 'string.unquoted.heredoc.php', 'meta.embedded.regexp.php']
  heredocRegexpScope = heredocRegexpBoundaryScope.concat ['string.regexp.heredoc.php']
  nowdocRegexpBoundaryScope = ['source.php', 'string.unquoted.nowdoc.php', 'meta.embedded.regexp.php']
  nowdocRegexpScope = nowdocRegexpBoundaryScope.concat ['string.regexp.nowdoc.php']
  regexpCharacterClassScope = ['meta.embedded.character-class.regexp.php', 'string.regexp.character-class.php']
  regexpCharacterClassScopes = (baseScope) ->
    baseScope.concat regexpCharacterClassScope
  regexpGroupScope = ['meta.embedded.group.regexp.php']
  regexpGroupScopes = (baseScope) ->
    baseScope.concat regexpGroupScope

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
      it "should keep character classes after escaped backslashes in #{description}", ->
        lines = grammar.tokenizeLines """
          $r = #{opener}
          /\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f]/
          #{label};
        """

        for token, index in [
          {value: '/', scopes: regexScope}
          {value: '\\\\', scopes: regexScope.concat ['constant.character.escape.regex.php']}
          {value: '[', scopes: regexpCharacterClassScopes(regexScope).concat ['punctuation.definition.character-class.php']}
          {value: '\\x01', scopes: regexpCharacterClassScopes(regexScope).concat ['constant.character.escape.php']}
          {value: '-', scopes: regexpCharacterClassScopes(regexScope).concat ['keyword.operator.range.regexp.php']}
          {value: '\\x09', scopes: regexpCharacterClassScopes(regexScope).concat ['constant.character.escape.php']}
          {value: '\\x0b', scopes: regexpCharacterClassScopes(regexScope).concat ['constant.character.escape.php']}
          {value: '\\x0c', scopes: regexpCharacterClassScopes(regexScope).concat ['constant.character.escape.php']}
          {value: '\\x0e', scopes: regexpCharacterClassScopes(regexScope).concat ['constant.character.escape.php']}
          {value: '-', scopes: regexpCharacterClassScopes(regexScope).concat ['keyword.operator.range.regexp.php']}
          {value: '\\x7f', scopes: regexpCharacterClassScopes(regexScope).concat ['constant.character.escape.php']}
          {value: ']', scopes: regexpCharacterClassScopes(regexScope).concat ['punctuation.definition.character-class.php']}
          {value: '/', scopes: regexScope}
        ]
          expect(lines[1][index]).toEqual token

        expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
        expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

      it "should keep groups and quantifiers after escaped backslashes in #{description}", ->
        lines = grammar.tokenizeLines """
          $r = #{opener}
          /\\\\(ab){2,3}/
          #{label};
        """

        for token, index in [
          {value: '/', scopes: regexScope}
          {value: '\\\\', scopes: regexScope.concat ['constant.character.escape.regex.php']}
          {value: '(', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']}
          {value: 'ab', scopes: regexpGroupScopes(regexScope)}
          {value: ')', scopes: regexpGroupScopes(regexScope).concat ['punctuation.definition.group.regexp.php']}
          {value: '{', scopes: regexScope.concat ['keyword.operator.quantifier.regexp.php', 'string.regexp.arbitrary-repitition.php', 'punctuation.definition.arbitrary-repitition.php']}
          {value: '2,3', scopes: regexScope.concat ['keyword.operator.quantifier.regexp.php', 'string.regexp.arbitrary-repitition.php']}
          {value: '}', scopes: regexScope.concat ['keyword.operator.quantifier.regexp.php', 'string.regexp.arbitrary-repitition.php', 'punctuation.definition.arbitrary-repitition.php']}
          {value: '/', scopes: regexScope}
        ]
          expect(lines[1][index]).toEqual token

        expect(lines[2][0]).toEqual value: label, scopes: terminatorScope
        expect(lines[2][1]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

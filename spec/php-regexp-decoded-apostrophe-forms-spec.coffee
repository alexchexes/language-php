{loadGrammar} = require('../utils/loadGrammar')
require('../utils/compatibleExpect')
{expect} = require('chai')

describe 'PHP regexp decoded apostrophe-delimited forms', ->
  grammar = null
  before(-> grammar = await loadGrammar('source.php'))

  quotedSingleRegexpScope = ['source.php', 'meta.embedded.regexp.php', 'string.regexp.single-quoted.php']
  regexpWrapperBeginQuoteScopes = (baseScope) ->
    baseScope.concat ['punctuation.definition.string.begin.php']
  regexpWrapperBeginDelimiterScopes = (baseScope) ->
    baseScope.concat ['punctuation.definition.string.begin.regexp.php']
  regexpWrapperEndDelimiterScopes = (baseScope) ->
    baseScope.concat ['punctuation.definition.string.end.regexp.php']
  regexpWrapperEndQuoteScopes = (baseScope) ->
    baseScope.concat ['punctuation.definition.string.end.php']
  regexpNamedBackreferenceScopes = (baseScope) ->
    baseScope.concat ['keyword.other.back-reference.named.regexp.php']
  regexpNamedBackreferenceNameScopes = (baseScope) ->
    regexpNamedBackreferenceScopes(baseScope).concat ['variable.other.regexp.php']
  regexpNamedSubroutineScopes = (baseScope) ->
    baseScope.concat ['keyword.other.subroutine.named.regexp.php']
  regexpNamedSubroutineNameScopes = (baseScope) ->
    regexpNamedSubroutineScopes(baseScope).concat ['variable.other.regexp.php']
  regexpSubroutineScopes = (baseScope) ->
    baseScope.concat ['keyword.other.subroutine.regexp.php']

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

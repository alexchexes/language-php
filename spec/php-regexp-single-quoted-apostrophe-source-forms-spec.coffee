{loadGrammar} = require('../utils/loadGrammar')
require('../utils/compatibleExpect')
{expect} = require('chai')

describe 'PHP regexp single-quoted source apostrophe forms', ->
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
  regexpGroupScopes = (baseScope) ->
    baseScope.concat ['meta.embedded.group.regexp.php']
  regexpConditionalGroupScopes = (baseScope) ->
    baseScope.concat ['meta.embedded.group.conditional.regexp.php']
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

  it 'tokenizes apostrophe-delimited named groups and conditionals in single quoted regex source', ->
    namedGroup = grammar.tokenizeLine "'/(?\\'name\\'foo)/';"
    conditional = grammar.tokenizeLine "'/(?(\\'word\\')yes|no)/';"

    expect(namedGroup.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
    expect(namedGroup.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
    expect(namedGroup.tokens[2]).toEqual value: '(', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
    expect(namedGroup.tokens[3]).toEqual value: '?\\\'', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php', 'constant.character.escape.php', 'punctuation.definition.group.capture.begin.regexp.php']
    expect(namedGroup.tokens[4]).toEqual value: 'name', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['variable.other.regexp.php']
    expect(namedGroup.tokens[5]).toEqual value: '\\\'', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php', 'constant.character.escape.php', 'punctuation.definition.group.capture.end.regexp.php']
    expect(namedGroup.tokens[6]).toEqual value: 'foo', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['string.regexp.single-quoted.php']
    expect(namedGroup.tokens[7]).toEqual value: ')', scopes: regexpGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']

    expect(conditional.tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
    expect(conditional.tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)
    expect(conditional.tokens[2]).toEqual value: '(', scopes: regexpConditionalGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.regexp.php']
    expect(conditional.tokens[3]).toEqual value: '?', scopes: regexpConditionalGroupScopes(quotedSingleRegexpScope).concat ['keyword.control.conditional.begin.regexp.php']
    expect(conditional.tokens[4]).toEqual value: '(', scopes: regexpConditionalGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.conditional.regexp.php']
    expect(conditional.tokens[5]).toEqual value: '\\\'', scopes: regexpConditionalGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php', 'constant.character.escape.php']
    expect(conditional.tokens[6]).toEqual value: 'word', scopes: regexpConditionalGroupScopes(quotedSingleRegexpScope).concat ['variable.other.regexp.php']
    expect(conditional.tokens[7]).toEqual value: '\\\'', scopes: regexpConditionalGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php', 'constant.character.escape.php']
    expect(conditional.tokens[8]).toEqual value: ')', scopes: regexpConditionalGroupScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.conditional.regexp.php']

  it 'tokenizes apostrophe-delimited backreferences and subroutine calls in single quoted regex source', ->
    {tokens} = grammar.tokenizeLine "'/\\k\\'name\\'\\g\\'word\\'\\g\\'+1\\'\\g\\'-1\\'/';"

    expect(tokens[0]).toEqual value: '\'', scopes: regexpWrapperBeginQuoteScopes(quotedSingleRegexpScope)
    expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedSingleRegexpScope)

    expect(tokens[2]).toEqual value: '\\k', scopes: regexpNamedBackreferenceScopes(quotedSingleRegexpScope)
    expect(tokens[3]).toEqual value: '\\\'', scopes: regexpNamedBackreferenceScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php', 'constant.character.escape.php']
    expect(tokens[4]).toEqual value: 'name', scopes: regexpNamedBackreferenceNameScopes(quotedSingleRegexpScope)
    expect(tokens[5]).toEqual value: '\\\'', scopes: regexpNamedBackreferenceScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php', 'constant.character.escape.php']

    expect(tokens[6]).toEqual value: '\\g', scopes: regexpNamedSubroutineScopes(quotedSingleRegexpScope)
    expect(tokens[7]).toEqual value: '\\\'', scopes: regexpNamedSubroutineScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php', 'constant.character.escape.php']
    expect(tokens[8]).toEqual value: 'word', scopes: regexpNamedSubroutineNameScopes(quotedSingleRegexpScope)
    expect(tokens[9]).toEqual value: '\\\'', scopes: regexpNamedSubroutineScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php', 'constant.character.escape.php']

    expect(tokens[10]).toEqual value: '\\g', scopes: regexpSubroutineScopes(quotedSingleRegexpScope)
    expect(tokens[11]).toEqual value: '\\\'', scopes: regexpSubroutineScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php', 'constant.character.escape.php']
    expect(tokens[12]).toEqual value: '+1', scopes: regexpSubroutineScopes(quotedSingleRegexpScope).concat ['constant.numeric.regexp.php']
    expect(tokens[13]).toEqual value: '\\\'', scopes: regexpSubroutineScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php', 'constant.character.escape.php']

    expect(tokens[14]).toEqual value: '\\g', scopes: regexpSubroutineScopes(quotedSingleRegexpScope)
    expect(tokens[15]).toEqual value: '\\\'', scopes: regexpSubroutineScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.capture.begin.regexp.php', 'constant.character.escape.php']
    expect(tokens[16]).toEqual value: '-1', scopes: regexpSubroutineScopes(quotedSingleRegexpScope).concat ['constant.numeric.regexp.php']
    expect(tokens[17]).toEqual value: '\\\'', scopes: regexpSubroutineScopes(quotedSingleRegexpScope).concat ['punctuation.definition.group.capture.end.regexp.php', 'constant.character.escape.php']

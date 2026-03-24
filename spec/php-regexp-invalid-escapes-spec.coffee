{loadGrammar} = require('../utils/loadGrammar')
require('../utils/compatibleExpect')
{expect} = require('chai')

describe 'PHP regexp invalid escapes', ->
  grammar = null
  before(-> grammar = await loadGrammar('source.php'))

  quotedDoubleRegexpScope = ['source.php', 'meta.embedded.regexp.php', 'string.regexp.double-quoted.php']
  heredocRegexpBoundaryScope = ['source.php', 'string.unquoted.heredoc.php', 'meta.embedded.regexp.php']
  heredocRegexpScope = heredocRegexpBoundaryScope.concat ['string.regexp.heredoc.php']
  nowdocRegexpBoundaryScope = ['source.php', 'string.unquoted.nowdoc.php', 'meta.embedded.regexp.php']
  nowdocRegexpScope = nowdocRegexpBoundaryScope.concat ['string.regexp.nowdoc.php']

  regexpCharacterClassBoundaryScope = ['meta.embedded.character-class.regexp.php']
  regexpCharacterClassScope = ['meta.embedded.character-class.regexp.php', 'string.regexp.character-class.php', 'constant.other.character-class.set.regexp.php']
  regexpCharacterClassScopes = (baseScope) ->
    baseScope.concat regexpCharacterClassScope
  regexpCharacterClassPunctuationScopes = (baseScope) ->
    baseScope.concat regexpCharacterClassBoundaryScope.concat ['punctuation.definition.character-class.regexp.php']
  regexpCharacterClassInvalidEscapeScopes = (baseScope) ->
    regexpCharacterClassScopes(baseScope).concat ['invalid.illegal.escape.regexp.php']
  regexpCharacterClassDecodedInvalidTransportScopes = (baseScope) ->
    regexpCharacterClassScopes(baseScope).concat ['constant.character.escape.php', 'invalid.illegal.escape.regexp.php']

  regexpInvalidEscapeScopes = (baseScope) ->
    baseScope.concat ['invalid.illegal.escape.regexp.php']
  regexpDecodedInvalidTransportScopes = (baseScope) ->
    baseScope.concat ['constant.character.escape.php', 'invalid.illegal.escape.regexp.php']
  regexpWrapperBeginQuoteScopes = (baseScope) ->
    baseScope.concat ['punctuation.definition.string.begin.php']
  regexpWrapperBeginDelimiterScopes = (baseScope) ->
    baseScope.concat ['punctuation.definition.string.begin.regexp.php']
  regexpWrapperEndDelimiterScopes = (baseScope) ->
    baseScope.concat ['punctuation.definition.string.end.regexp.php']
  regexpWrapperEndQuoteScopes = (baseScope) ->
    baseScope.concat ['punctuation.definition.string.end.php']

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

  it 'tokenizes closed malformed raw \\k/\\g forms as invalid in quoted regexes', ->
    body = '"/' + '\\k{}' + '\\k{1}' + '\\g{}' + '\\g{1x}' + '\\g<>' + '/"'
    tokens = grammar.tokenizeLine(body).tokens

    expect(tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
    expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
    expect(tokens[2]).toEqual value: '\\k{}', scopes: regexpInvalidEscapeScopes(quotedDoubleRegexpScope)
    expect(tokens[3]).toEqual value: '\\k{1}', scopes: regexpInvalidEscapeScopes(quotedDoubleRegexpScope)
    expect(tokens[4]).toEqual value: '\\g{}', scopes: regexpInvalidEscapeScopes(quotedDoubleRegexpScope)
    expect(tokens[5]).toEqual value: '\\g{1x}', scopes: regexpInvalidEscapeScopes(quotedDoubleRegexpScope)
    expect(tokens[6]).toEqual value: '\\g<>', scopes: regexpInvalidEscapeScopes(quotedDoubleRegexpScope)
    expect(tokens[7]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
    expect(tokens[8]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

  it 'tokenizes closed malformed decoded \\k/\\g forms as invalid in quoted regexes', ->
    body = '"/' + '\\'.repeat(2) + 'k{}' + '\\'.repeat(2) + 'k{1}' + '\\'.repeat(2) + 'g{}' + '\\'.repeat(2) + 'g{1x}' + '/"'
    tokens = grammar.tokenizeLine(body).tokens

    expect(tokens[0]).toEqual value: '"', scopes: regexpWrapperBeginQuoteScopes(quotedDoubleRegexpScope)
    expect(tokens[1]).toEqual value: '/', scopes: regexpWrapperBeginDelimiterScopes(quotedDoubleRegexpScope)
    expect(tokens[2]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(quotedDoubleRegexpScope)
    expect(tokens[3]).toEqual value: 'k{}', scopes: regexpInvalidEscapeScopes(quotedDoubleRegexpScope)
    expect(tokens[4]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(quotedDoubleRegexpScope)
    expect(tokens[5]).toEqual value: 'k{1}', scopes: regexpInvalidEscapeScopes(quotedDoubleRegexpScope)
    expect(tokens[6]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(quotedDoubleRegexpScope)
    expect(tokens[7]).toEqual value: 'g{}', scopes: regexpInvalidEscapeScopes(quotedDoubleRegexpScope)
    expect(tokens[8]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(quotedDoubleRegexpScope)
    expect(tokens[9]).toEqual value: 'g{1x}', scopes: regexpInvalidEscapeScopes(quotedDoubleRegexpScope)
    expect(tokens[10]).toEqual value: '/', scopes: regexpWrapperEndDelimiterScopes(quotedDoubleRegexpScope)
    expect(tokens[11]).toEqual value: '"', scopes: regexpWrapperEndQuoteScopes(quotedDoubleRegexpScope)

  it 'tokenizes closed malformed raw \\k/\\g forms as invalid in REGEXP nowdoc', ->
    lines = grammar.tokenizeLines [
      "$r = <<<'REGEXP'"
      '/\\k{}\\k{1}\\g{}\\g{1x}/'
      'REGEXP;'
    ].join "\n"

    expect(lines[1][0]).toEqual value: '/', scopes: nowdocRegexpScope
    expect(lines[1][1]).toEqual value: '\\k{}', scopes: regexpInvalidEscapeScopes(nowdocRegexpScope)
    expect(lines[1][2]).toEqual value: '\\k{1}', scopes: regexpInvalidEscapeScopes(nowdocRegexpScope)
    expect(lines[1][3]).toEqual value: '\\g{}', scopes: regexpInvalidEscapeScopes(nowdocRegexpScope)
    expect(lines[1][4]).toEqual value: '\\g{1x}', scopes: regexpInvalidEscapeScopes(nowdocRegexpScope)
    expect(lines[1][5]).toEqual value: '/', scopes: nowdocRegexpScope

  it 'tokenizes closed malformed decoded \\k/\\g forms as invalid in REGEX heredoc', ->
    lines = grammar.tokenizeLines """
      $r = <<<REGEXP
      /\\\\k{}\\\\k{1}\\\\g{}\\\\g{1x}/
      REGEXP;
    """

    expect(lines[1][0]).toEqual value: '/', scopes: heredocRegexpScope
    expect(lines[1][1]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(heredocRegexpScope)
    expect(lines[1][2]).toEqual value: 'k{}', scopes: regexpInvalidEscapeScopes(heredocRegexpScope)
    expect(lines[1][3]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(heredocRegexpScope)
    expect(lines[1][4]).toEqual value: 'k{1}', scopes: regexpInvalidEscapeScopes(heredocRegexpScope)
    expect(lines[1][5]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(heredocRegexpScope)
    expect(lines[1][6]).toEqual value: 'g{}', scopes: regexpInvalidEscapeScopes(heredocRegexpScope)
    expect(lines[1][7]).toEqual value: '\\\\', scopes: regexpDecodedInvalidTransportScopes(heredocRegexpScope)
    expect(lines[1][8]).toEqual value: 'g{1x}', scopes: regexpInvalidEscapeScopes(heredocRegexpScope)
    expect(lines[1][9]).toEqual value: '/', scopes: heredocRegexpScope

{loadGrammar} = require('../utils/loadGrammar')
require('../utils/compatibleExpect')
{expect} = require('chai')

describe 'PHP regexp concatenated string fragments', ->
  grammar = null
  before(-> grammar = await loadGrammar('source.php'))

  it 'does not enter quoted regex mode across concatenated string fragments that contain raw host quotes in character classes', ->
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
      expect(tokens.some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false
      expect(tokens[0].scopes).toContain 'string.quoted.single.php'

    for line in plainDoubleCases
      {tokens} = grammar.tokenizeLine line
      expect(tokens.some((token) -> 'meta.embedded.regexp.php' in token.scopes)).toBe false
      expect(tokens[0].scopes).toContain 'string.quoted.double.php'

    {tokens: singleWithInnerRegexTokens} = grammar.tokenizeLine singleWithInnerRegex
    singleInnerRegexTokens = singleWithInnerRegexTokens.filter (token) -> 'meta.embedded.regexp.php' in token.scopes
    expect(singleWithInnerRegexTokens[0].scopes).toContain 'string.quoted.single.php'
    expect(singleInnerRegexTokens.map((token) -> token.value)).toEqual ['\'', '/', 'a-z', '/', '\'']

    {tokens: doubleWithInnerRegexTokens} = grammar.tokenizeLine doubleWithInnerRegex
    doubleInnerRegexTokens = doubleWithInnerRegexTokens.filter (token) -> 'meta.embedded.regexp.php' in token.scopes
    expect(doubleWithInnerRegexTokens[0].scopes).toContain 'string.quoted.double.php'
    expect(doubleInnerRegexTokens.map((token) -> token.value)).toEqual ['"', '/', 'a-z', '/', '"']

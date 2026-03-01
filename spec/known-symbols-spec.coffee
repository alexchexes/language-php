{loadGrammar} = require('../utils/loadGrammar')
require('../utils/compatibleExpect')
{expect} = require('chai')
harness = require('../utils/knownSymbolsHarness')
fs = require('fs')
path = require('path')
{compile} = require('coffeescript')
{runInThisContext} = require('vm')

readGrammarDefinition = do ->
  cache = null

  ->
    return cache if cache?

    grammarPath = path.join(__dirname, '../grammars/php.cson')
    source = fs.readFileSync(grammarPath, 'utf8')
    compiled = compile(source, bare: true, header: false, sourceMap: false)
    cache = runInThisContext(compiled)
    cache

extractPatternRulesForScope = (expectedScope) ->
  grammar = readGrammarDefinition()
  rules = []
  queue = [grammar]

  while queue.length > 0
    node = queue.pop()

    if Array.isArray(node)
      queue.push(child) for child in node
      continue

    continue unless node? and typeof node is 'object'

    if typeof node.name is 'string' and typeof node.match is 'string' and expectedScope.test(node.name)
      rules.push(node)

    Object.values(node).forEach((value) ->
      queue.push(value))

  rules

cleanRegexNaive = (pattern) ->
  # Keep order intact; later steps rely on earlier ones.
  pattern
    # Strip leading inline flags like (?i), (?xi), etc.
    .replace(/^(?:\s*\(\?[a-z-]+\))+/i, ' ')
    # Strip inline comment groups like (?# comment)
    .replace(/\(\?#[\s\S]*?\)/g, ' ')
    # Strip character classes like [gs] and [01]
    .replace(/\[[^\]]*\]/g, ' ')
    # Strip hash comments like " ... # comment"
    .replace(/(^|[^\\])#.*$/gm, ' $1 ')
    # Strip word boundaries like \b
    .replace(/\\b/g, ' ')

extractRegexWordParts = (pattern) ->
  regexTokens = new Set(['x', 'i', 'b'])
  cleanedPattern = cleanRegexNaive(pattern)
  parts = cleanedPattern.match(/\w+/g) ? []
  [...new Set(parts)]
    .filter((part) -> not regexTokens.has(part))

describe 'PHP known symbols', ->
  grammar = null
  before ->
    grammar = await loadGrammar('source.php')
  

  targets = [
    {
      name: 'constants'
      expectedScope: /^support\.constant\..+\.php$/
      sourceFormatFn: (symbol) -> "#{symbol};"
    }
    {
      name: 'functions'
      expectedScope: /^support\.function\..+\.php$/
      sourceFormatFn: (symbol) -> "#{symbol}();"
    }
  ]

  targets.forEach (target) ->
    describe target.name, ->
      snapshotName = "#{target.name}.snapshot.json"
      symbols = harness.readIdentifierList("#{target.name}.properties")

      scopeForSymbol = (identifier) ->
        {tokens} = grammar.tokenizeLine(target.sourceFormatFn(identifier))
        token = tokens.find((item) -> item.value is identifier)
        if not Array.isArray(token?.scopes) or token.scopes.length is 0
          return null
        token.scopes[token.scopes.length - 1]

      captureScopes = ->
        scopes = {}
        symbols.forEach (symbol) ->
          scopes[symbol] = scopeForSymbol(symbol)
        scopes

      formatEntries = (entries) ->
        entries.map(([symbol, scope]) ->
          "#{symbol} - #{scope}").join("\n") + "\n Total: " + entries.length

      it "should match #{target.expectedScope}", ->
        scopes = captureScopes()
        invalidEntries = Object.entries(scopes)
          .filter(([, scope]) -> typeof scope isnt 'string' or not target.expectedScope.test(scope))

        if invalidEntries.length > 0
          throw new Error("Entries don't match:\n" + formatEntries(invalidEntries))

      it "should match scopes snapshot", ->
        scopes = captureScopes()

        if harness.UPDATE_SNAPSHOTS
          harness.writeSnapshot(snapshotName, scopes)
          return

        hintText = "Run tests with UPDATE_SNAPSHOTS=1 to update."
        expectedSnapshot = harness.readSnapshot(snapshotName)

        unless expectedSnapshot?
          throw new Error("Missing snapshot file: #{snapshotName}. #{hintText}")

        expect(scopes, "Scopes snapshot doesn't match. #{hintText}").toEqual(expectedSnapshot)

      it "should not match #{target.expectedScope} for generated near-miss symbols", ->
        nearMisses = harness.generateNearMissSet(symbols)
        overmatches = []
        nearMisses.forEach (candidate) ->
          scope = scopeForSymbol(candidate)
          if typeof scope is 'string' and target.expectedScope.test(scope)
            overmatches.push([candidate, scope])

        expect(nearMisses.length > 0).toBe(true)
        if overmatches.length > 0
          throw new Error("Unexpected matches:\n" + formatEntries(overmatches))

      it "should cover regex parts for #{target.expectedScope}", ->
        scopes = captureScopes()
        symbolsByScope = {}

        Object.entries(scopes).forEach ([symbol, scope]) ->
          return unless typeof scope is 'string'
          symbolsByScope[scope] ?= []
          symbolsByScope[scope].push(symbol)

        missingCoverage = []
        rules = extractPatternRulesForScope(target.expectedScope)

        unless rules.length > 0
          throw new Error("No regex rules found for #{target.expectedScope}")

        rules.forEach (rule) ->
          scopedSymbols = symbolsByScope[rule.name] ? []
          parts = extractRegexWordParts(rule.match)

          parts.forEach (part) ->
            hasScopeCoverage = scopedSymbols.some((symbol) ->
              symbol.toUpperCase().includes(part.toUpperCase()))
            unless hasScopeCoverage
              missingCoverage.push([rule.name, part])

        if missingCoverage.length > 0
          details = missingCoverage
            .map(([scope, part]) -> "#{scope} - #{part}")
            .join("\n")

          throw new Error("""
            Missing regex-part coverage in #{target.name}.properties:
            #{details}
            Total: #{missingCoverage.length}
          """)

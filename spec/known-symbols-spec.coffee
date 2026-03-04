{loadGrammar} = require('../utils/loadGrammar')
require('../utils/compatibleExpect')
{expect} = require('chai')
harness = require('../utils/knownSymbolsHarness')
fs = require('fs')
path = require('path')
{compile} = require('coffeescript')
{runInThisContext} = require('vm')
{toRegExp} = require('oniguruma-to-es')
{count, expandAll} = require('regex-to-strings')

MAX_REGEX_EXPANSIONS = 25_000

normalizeIdentifier = (value) ->
  value.toLowerCase()

stripCaseInsensitiveInlineFlags = (pattern) ->
  pattern.replace(/\(\?([a-z-]+)\)/ig, (match, flags) ->
    normalizedFlags = flags.replace(/i/ig, '')
    if normalizedFlags.length is 0 then '' else "(?#{normalizedFlags})"
  )

expandRegexSymbols = (pattern) ->
  normalizedPattern = stripCaseInsensitiveInlineFlags(pattern)
  regex = toRegExp(normalizedPattern, target: 'ES2018', avoidSubclass: true)

  expansionCount = count(regex)
  if not Number.isFinite(expansionCount) or expansionCount > MAX_REGEX_EXPANSIONS
    throw new Error("""
      Regex expansion count #{expansionCount} exceeds limit #{MAX_REGEX_EXPANSIONS}.
    """)

  [...new Set(expandAll(regex))]

readGrammarDefinition = do ->
  cache = null
  ->
    if cache?
      return cache

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

    unless node? and typeof node is 'object'
      continue

    if typeof node.name is 'string' and typeof node.match is 'string' and expectedScope.test(node.name)
      rules.push(node)

    Object.values(node).forEach((value) ->
      queue.push(value))

  rules

describe 'PHP known symbols', ->
  grammar = null
  before ->
    grammar = await loadGrammar('source.php')
  

  targets = [
    {
      name: 'constants'
      knownSymbolsFile: 'constants.properties'
      expectedScope: /^support\.constant\..+\.php$/
      sourceFormatFn: (symbol) -> "#{symbol};"
    }
    {
      name: 'classes'
      knownSymbolsFile: 'classes.properties'
      expectedScope: /^support\.class\.builtin\.php$/
      sourceFormatFn: (symbol) -> "new #{symbol}();"
    }
    {
      name: 'functions'
      knownSymbolsFile: 'functions.properties'
      expectedScope: /^support\.function\..+\.php$/
      sourceFormatFn: (symbol) -> "#{symbol}();"
    }
  ]

  targets.forEach (target) ->
    describe "#{target.name}", ->
      snapshotName = "#{target.name}.snapshot.json"
      symbols = harness.readIdentifierList(target.knownSymbolsFile)
      knownSymbols = new Set(symbols.map((symbol) -> normalizeIdentifier(symbol)))

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
        sortedEntries = [...entries].sort(([symbolA, scopeA], [symbolB, scopeB]) ->
          scopeCompare = String(scopeA ? '').localeCompare(String(scopeB ? ''))
          unless scopeCompare is 0
            return scopeCompare
          String(symbolA ? '').localeCompare(String(symbolB ? ''))
        )

        sortedEntries.map(([symbol, scope]) ->
          "#{symbol} (#{scope})").join("\n") + "\n Total: " + entries.length

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

      it "should not produce unknown symbols when expanding regexes", ->
        missingCoverage = new Map()
        rules = extractPatternRulesForScope(target.expectedScope)

        unless rules.length > 0
          throw new Error("No regex rules found for #{target.expectedScope}")

        rules.forEach (rule) ->
          expandedSymbols = null
          try
            expandedSymbols = expandRegexSymbols(rule.match)
          catch error
            throw new Error("Failed to expand regex for #{rule.name}: #{error.message}")

          expandedSymbols.forEach (symbol) ->
            matchedScope = scopeForSymbol(symbol)
            # Only keep symbols whose tokenized scope exactly matches this rule's scope (rule.name).
            unless matchedScope is rule.name
              return
              
            if knownSymbols.has(normalizeIdentifier(symbol))
              return

            entry = [symbol, rule.name]
            missingCoverage.set(JSON.stringify(entry), entry)

        if missingCoverage.size > 0
          throw new Error("""
            Regex expansion for rules matching #{target.expectedScope} produced symbols not found in #{target.knownSymbolsFile} file.
            #{formatEntries([...missingCoverage.values()])}
          """)

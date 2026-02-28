{loadGrammar} = require('../utils/loadGrammar')
require('../utils/compatibleExpect')
{expect} = require('chai')
harness = require('../utils/knownSymbolsHarness')

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
          formatted = entries.map(([symbol, scope]) ->
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

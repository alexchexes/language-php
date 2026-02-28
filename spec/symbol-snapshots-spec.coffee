{loadGrammar} = require('../utils/loadGrammar')
require('../utils/compatibleExpect')
{expect} = require('chai')
harness = require('../utils/symbolSnapshotHarness')

MAX_DIFF_LINES = 40
formatSnapshotDiff = (diff) ->
  lines = []

  if diff.missing.length > 0
    lines.push "Missing identifiers in current run (#{diff.missing.length}):"
    diff.missing.slice(0, MAX_DIFF_LINES).forEach (name) ->
      lines.push "  - #{name}"

  if diff.unexpected.length > 0
    lines.push "Unexpected identifiers in current run (#{diff.unexpected.length}):"
    diff.unexpected.slice(0, MAX_DIFF_LINES).forEach (name) ->
      lines.push "  + #{name}"

  if diff.changed.length > 0
    lines.push "Changed scopes (#{diff.changed.length}):"
    diff.changed.slice(0, MAX_DIFF_LINES).forEach (item) ->
      lines.push "  * #{item.name}: expected=#{item.expected}, actual=#{item.actual}"

  lines.join('\n')

verifyOrUpdateEntriesSnapshot = (symbolType, entries, snapshotPath) ->
  if harness.UPDATE_SNAPSHOTS
    harness.writeSnapshot(snapshotPath, entries)
    return entries

  expectedSnapshot = harness.readSnapshot(snapshotPath)
  unless expectedSnapshot?
    throw new Error("Snapshot file is missing: #{snapshotPath}\nRun tests with UPDATE_SNAPSHOTS=1 to create it.")

  diff = harness.diffSnapshots(expectedSnapshot, entries)
  if diff.missing.length > 0 or diff.unexpected.length > 0 or diff.changed.length > 0
    throw new Error("Snapshot mismatch for #{symbolType}s:\n#{formatSnapshotDiff(diff)}")

  entries

verifyOrUpdateSymbolSnapshot = (symbolType, names, snapshotPath, grammar) ->
  actualEntries = harness.captureScopes(grammar, names, symbolType)
  verifyOrUpdateEntriesSnapshot(symbolType, actualEntries, snapshotPath)

collectNearMissOvermatches = (symbolType, names, grammar) ->
  nearMisses = harness.buildNearMissSet(names)
  scopeFn = if symbolType is 'constant' then harness.scopeForConstant else harness.scopeForFunction
  supportPrefix = if symbolType is 'constant' then 'support.constant.' else 'support.function.'

  overmatches = []
  nearMisses.forEach (candidate) ->
    scope = scopeFn(grammar, candidate)
    if typeof scope is 'string' and scope.indexOf(supportPrefix) is 0
      overmatches.push({candidate, scope})

  {nearMisses, overmatches}

formatOvermatches = (symbolType, overmatches, maxLines = 40) ->
  lines = overmatches.slice(0, maxLines).map (item) ->
    "  - #{item.candidate}: #{item.scope}"

  "Generated near-miss #{symbolType}s were incorrectly matched as support symbols (#{overmatches.length}):\n#{lines.join('\n')}"

formatInvalidKnownScopes = (symbolType, invalidEntries, maxLines = 40) ->
  lines = invalidEntries.slice(0, maxLines).map (item) ->
    "  - #{item.name}: #{item.scope}"

  "Known #{symbolType}s must resolve to support scopes, but got #{invalidEntries.length} invalid entries:\n#{lines.join('\n')}"

assertKnownSymbolsHaveSupportScopes = (symbolType, scopes) ->
  supportPrefix = if symbolType is 'constant' then 'support.constant.' else 'support.function.'
  invalidEntries = Object.entries(scopes)
    .filter(([, scope]) -> typeof scope isnt 'string' or scope.indexOf(supportPrefix) isnt 0)
    .map(([name, scope]) -> {name, scope})

  if invalidEntries.length > 0
    throw new Error(formatInvalidKnownScopes(symbolType, invalidEntries))

describe 'PHP built-in symbol snapshots', ->
  grammar = null
  constants = []
  functions = []

  before ->
    grammar = await loadGrammar('source.php')
    constants = harness.readIdentifierList(harness.paths.constantsList)
    functions = harness.readIdentifierList(harness.paths.functionsList)

  it 'verifies constant scopes snapshot', ->
    scopes = verifyOrUpdateSymbolSnapshot(
      'constant',
      constants,
      harness.paths.constantsSnapshot,
      grammar
    )
    expect(Object.keys(scopes).length).toBe(constants.length)
    assertKnownSymbolsHaveSupportScopes('constant', scopes)

  it 'verifies function scopes snapshot', ->
    scopes = verifyOrUpdateSymbolSnapshot(
      'function',
      functions,
      harness.paths.functionsSnapshot,
      grammar
    )
    expect(Object.keys(scopes).length).toBe(functions.length)
    assertKnownSymbolsHaveSupportScopes('function', scopes)

  it 'does not overmatch support.constant.* for generated near-miss constants', ->
    {nearMisses, overmatches} = collectNearMissOvermatches('constant', constants, grammar)

    expect(nearMisses.length > 0).toBe(true)
    if overmatches.length > 0
      throw new Error(formatOvermatches('constant', overmatches))

  it 'does not overmatch support.function.* for generated near-miss functions', ->
    {nearMisses, overmatches} = collectNearMissOvermatches('function', functions, grammar)

    expect(nearMisses.length > 0).toBe(true)
    if overmatches.length > 0
      throw new Error(formatOvermatches('function', overmatches))

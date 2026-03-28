{loadGrammar} = require '../utils/loadGrammar'
{
  assertBlock
  buildTokenModel
  dumpBlockActual
  getLineModel
  parseFixtureFile
  writeUpdatedFixture
} = require '../utils/caret-tests'
{getDirItems} = require '../utils/caret-tests/discover-fixtures'

specRoot = __dirname
updateMode = process.argv.includes '--update'

fixtureGroups = [
  {
    label: 'php-regexp'
    root: 'caret/php-regexp'
    scopeName: 'text.html.php'
    startScope: 'source.php'
  }
]

allScopeNames = [...new Set fixtureGroups.map (group) -> group.scopeName]

describe 'PHP caret tests', ->
  grammars = new Map()

  before ->
    loadedGrammars = await Promise.all allScopeNames.map (scopeName) ->
      grammar = await loadGrammar scopeName
      [scopeName, grammar]
    for [scopeName, grammar] in loadedGrammars
      grammars.set scopeName, grammar

  walkDirItems = (dirItems, scopeName, startScope) ->
    for item in dirItems
      do (item) ->
        describe item.relativePath, ->
          if item.isDir
            walkDirItems item.dirItems, scopeName, startScope
            return

          fixture = parseFixtureFile item.path, item.specRelativePath
          tokenModel = null
          replacementBySourceLine = new Map()
          updatedBlocks = []

          before ->
            grammar = grammars.get scopeName
            throw new Error "Grammar not loaded for #{scopeName}" unless grammar?
            tokenizedLines = grammar.tokenizeLines fixture.cleanedSource
            tokenModel = buildTokenModel fixture, tokenizedLines

          after ->
            return unless updateMode
            return unless replacementBySourceLine.size > 0
            for {lineNumber, sourceLine} in updatedBlocks
              console.warn "[caret update] #{item.specRelativePath}:#{lineNumber} #{sourceLine}"
            writeUpdatedFixture fixture, replacementBySourceLine

          for block in fixture.blocks
            do (block) ->
              it "L:#{block.sourceLineNumber} #{block.sourceLine}", ->
                lineModel = getLineModel tokenModel, block.sourceLineNumber

                if updateMode
                  try
                    assertBlock block, lineModel, {startScope, relativePath: item.specRelativePath}
                  catch error
                    dumpedLines = dumpBlockActual block, lineModel, {startScope}
                    replacementBySourceLine.set block.sourceLineNumber, dumpedLines.map (line) -> line.line
                    updatedBlocks.push
                      lineNumber: block.sourceLineNumber
                      sourceLine: block.sourceLine
                  return

                assertBlock block, lineModel, {startScope, relativePath: item.specRelativePath}

  for {label, root, scopeName, startScope} in fixtureGroups
    do (label, root, scopeName, startScope) ->
      describe label, ->
        dirItems = getDirItems specRoot, root
        walkDirItems dirItems, scopeName, startScope

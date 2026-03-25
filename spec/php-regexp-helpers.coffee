require('../utils/compatibleExpect')
{expect} = require('chai')

expectPlainAssignment = (tokens) ->
  expect(tokens[0]).toEqual value: '$', scopes: ['source.php', 'variable.other.php', 'punctuation.definition.variable.php']
  expect(tokens[1]).toEqual value: 'x', scopes: ['source.php', 'variable.other.php']
  expect(tokens[2]).toEqual value: ' ', scopes: ['source.php']
  expect(tokens[3]).toEqual value: '=', scopes: ['source.php', 'keyword.operator.assignment.php']
  expect(tokens[4]).toEqual value: ' ', scopes: ['source.php']
  expect(tokens[5]).toEqual value: '1', scopes: ['source.php', 'constant.numeric.decimal.php']
  expect(tokens[6]).toEqual value: ';', scopes: ['source.php', 'punctuation.terminator.expression.php']

quotedSingleRegexpScope = ['source.php', 'meta.embedded.regexp.php', 'string.regexp.single-quoted.php']
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
regexpCharacterClassBoundaryNegationScopes = (baseScope) ->
  baseScope.concat regexpCharacterClassBoundaryScope.concat ['keyword.operator.negation.regexp.php']
regexpCharacterClassLiteralScopes = (baseScope) ->
  regexpCharacterClassScopes(baseScope)
regexpCharacterClassEscapeScopes = (baseScope) ->
  regexpCharacterClassScopes(baseScope).concat ['constant.character.escape.regexp.php']
regexpCharacterClassClassEscapeScopes = (baseScope) ->
  regexpCharacterClassScopes(baseScope).concat ['constant.character.class.regexp.php']
regexpCharacterClassInvalidEscapeScopes = (baseScope) ->
  regexpCharacterClassScopes(baseScope).concat ['invalid.illegal.escape.regexp.php']
regexpCharacterClassDecodedEscapeTransportScopes = (baseScope) ->
  regexpCharacterClassScopes(baseScope).concat ['constant.character.escape.php', 'constant.character.escape.regexp.php']
regexpCharacterClassDecodedInvalidTransportScopes = (baseScope) ->
  regexpCharacterClassScopes(baseScope).concat ['constant.character.escape.php', 'invalid.illegal.escape.regexp.php']
regexpCharacterClassDecodedNumericTransportScopes = (baseScope) ->
  regexpCharacterClassScopes(baseScope).concat ['constant.character.escape.php', 'constant.character.numeric.regexp.php']
regexpCharacterClassPhpEscapeScopes = (baseScope) ->
  regexpCharacterClassScopes(baseScope).concat ['constant.character.escape.php']
regexpCharacterClassPhpHexEscapeScopes = (baseScope) ->
  regexpCharacterClassScopes(baseScope).concat ['constant.character.escape.hex.php']
regexpCharacterClassNumericScopes = (baseScope) ->
  regexpCharacterClassScopes(baseScope).concat ['constant.numeric.regexp.php']
regexpCharacterClassOctalScopes = (baseScope) ->
  regexpCharacterClassScopes(baseScope).concat ['constant.numeric.octal.regexp.php']
regexpCharacterClassRangeScopes = (baseScope) ->
  regexpCharacterClassScopes(baseScope).concat ['constant.other.character-class.range.regexp.php']
regexpCharacterClassLetterRangeScopes = (baseScope) ->
  regexpCharacterClassRangeScopes(baseScope).concat ['variable.other.constant.range.regexp.php']
regexpCharacterClassRangeOperatorScopes = (baseScope) ->
  regexpCharacterClassRangeScopes(baseScope).concat ['keyword.operator.range.regexp.php']
regexpCharacterClassDigitRangeScopes = (baseScope) ->
  regexpCharacterClassRangeScopes(baseScope)
regexpCharacterClassGenericRangeScopes = (baseScope) ->
  regexpCharacterClassRangeScopes(baseScope).concat ['support.class.range.regexp.php']
regexpCharacterClassHexRangeScopes = (baseScope) ->
  regexpCharacterClassRangeScopes(baseScope)
regexpCharacterClassPosixScope = ['meta.embedded.character-class.posix.regexp.php', 'constant.other.character-class.posix.regexp.php']
regexpCharacterClassPosixScopes = (baseScope) ->
  regexpCharacterClassScopes(baseScope).concat regexpCharacterClassPosixScope
regexpGroupScope = ['meta.embedded.group.regexp.php']
regexpGroupScopes = (baseScope) ->
  baseScope.concat regexpGroupScope
regexpGroupContentScopes = (baseScope) ->
  regexpGroupScopes(baseScope).concat [baseScope[baseScope.length - 1]]
regexpSpecificGroupPunctuationScopes = (baseScope, specificScope) ->
  baseScope.concat ['punctuation.definition.group.regexp.php', specificScope]
regexpGroupNameScopes = (baseScope) ->
  baseScope.concat ['variable.other.regexp.php']
regexpNamedBackreferenceScopes = (baseScope) ->
  baseScope.concat ['keyword.other.back-reference.named.regexp.php']
regexpNamedBackreferenceNameScopes = (baseScope) ->
  regexpNamedBackreferenceScopes(baseScope).concat ['variable.other.regexp.php']
regexpSubroutineScopes = (baseScope) ->
  baseScope.concat ['keyword.other.subroutine.regexp.php']
regexpNamedSubroutineScopes = (baseScope) ->
  baseScope.concat ['keyword.other.subroutine.named.regexp.php']
regexpNamedSubroutineNameScopes = (baseScope) ->
  regexpNamedSubroutineScopes(baseScope).concat ['variable.other.regexp.php']
regexpDecodedSubroutineTransportScopes = (baseScope) ->
  baseScope.concat ['constant.character.escape.php', 'keyword.other.subroutine.regexp.php']
regexpDecodedNamedSubroutineTransportScopes = (baseScope) ->
  baseScope.concat ['constant.character.escape.php', 'keyword.other.subroutine.named.regexp.php']
regexpGroupRecursionScopes = (baseScope) ->
  regexpGroupScopes(baseScope).concat ['keyword.other.recursion.regexp.php']
regexpGroupSubroutineScopes = (baseScope) ->
  regexpGroupScopes(baseScope).concat ['keyword.other.subroutine.regexp.php']
regexpGroupNamedSubroutineScopes = (baseScope) ->
  regexpGroupScopes(baseScope).concat ['keyword.other.subroutine.named.regexp.php']
regexpInvalidEscapeScopes = (baseScope) ->
  baseScope.concat ['invalid.illegal.escape.regexp.php']
regexpOctalScopes = (baseScope) ->
  baseScope.concat ['constant.numeric.octal.regexp.php']
regexpDecodedInvalidTransportScopes = (baseScope) ->
  baseScope.concat ['constant.character.escape.php', 'invalid.illegal.escape.regexp.php']
regexpDecodedNumericTransportScopes = (baseScope) ->
  baseScope.concat ['constant.character.escape.php', 'constant.character.numeric.regexp.php']
regexpDecodedAnchorTransportScopes = (baseScope) ->
  baseScope.concat ['constant.character.escape.php', 'keyword.control.anchor.regexp.php']
regexpWrapperBeginQuoteScopes = (baseScope) ->
  baseScope.concat ['punctuation.definition.string.begin.php']
regexpWrapperBeginDelimiterScopes = (baseScope) ->
  baseScope.concat ['punctuation.definition.string.begin.regexp.php']
regexpWrapperEndDelimiterScopes = (baseScope) ->
  baseScope.concat ['punctuation.definition.string.end.regexp.php']
regexpWrapperFlagScopes = (baseScope) ->
  baseScope.concat ['storage.modifier.regexp.php']
regexpWrapperEndQuoteScopes = (baseScope) ->
  baseScope.concat ['punctuation.definition.string.end.php']
regexpWildcardScopes = (baseScope) ->
  baseScope.concat ['constant.character.class.wildcard.regexp.php']
regexpControlKeywordScopes = (baseScope) ->
  baseScope.concat ['keyword.control.regexp.php']
regexpBacktrackingVerbScopes = (baseScope, verb) ->
  normalizedVerb = if verb is '*:'
    'mark'
  else
    verb.replace(/^\*/, '').replace(/:$/, '').toLowerCase()
  regexpGroupScopes(baseScope).concat ["keyword.control.backtracking.#{normalizedVerb}.regexp.php"]
regexpDirectiveScopes = (baseScope) ->
  regexpGroupScopes(baseScope).concat ['keyword.control.directive.regexp.php']
regexpAssertionGroupScope = ['meta.embedded.group.assertion.regexp.php']
regexpAssertionGroupScopes = (baseScope) ->
  baseScope.concat regexpAssertionGroupScope
regexpAssertionGroupContentScopes = (baseScope) ->
  regexpAssertionGroupScopes(baseScope).concat [baseScope[baseScope.length - 1]]
regexpSpecificAssertionPunctuationScopes = (baseScope, specificScope) ->
  baseScope.concat ['punctuation.definition.group.assertion.regexp.php', specificScope]
regexpConditionalGroupScope = ['meta.embedded.group.conditional.regexp.php']
regexpConditionalGroupScopes = (baseScope) ->
  baseScope.concat regexpConditionalGroupScope
regexpConditionalGroupContentScopes = (baseScope) ->
  regexpConditionalGroupScopes(baseScope).concat [baseScope[baseScope.length - 1]]
regexpConditionalAssertionConditionScopes = (baseScope) ->
  regexpConditionalGroupScopes(baseScope).concat [baseScope[baseScope.length - 1], 'meta.embedded.group.assertion.regexp.php']
regexpConditionalAssertionContentScopes = (baseScope) ->
  regexpConditionalAssertionConditionScopes(baseScope).concat [baseScope[baseScope.length - 1]]
regexpConditionalAssertionEndScopes = (baseScope) ->
  regexpConditionalAssertionConditionScopes(baseScope).concat ['punctuation.definition.group.conditional.regexp.php']
regexpSpecificConditionalAssertionPunctuationScopes = (baseScope, specificScope) ->
  regexpConditionalAssertionConditionScopes(baseScope).concat ['punctuation.definition.group.assertion.regexp.php', specificScope]
regexpConditionalBeginKeywordScopes = (baseScope) ->
  regexpConditionalGroupScopes(baseScope).concat ['keyword.control.conditional.begin.regexp.php']
regexpConditionalBeginPunctuationScopes = (baseScope) ->
  regexpConditionalGroupScopes(baseScope).concat ['punctuation.definition.group.conditional.regexp.php']
regexpConditionalPunctuationScopes = (baseScope) ->
  regexpConditionalGroupScopes(baseScope).concat ['punctuation.definition.group.conditional.regexp.php']
regexpConditionalKeywordScopes = (baseScope) ->
  regexpConditionalGroupScopes(baseScope).concat ['keyword.control.conditional.regexp.php']
expectScopedToken = (tokens, index, value, scopes) ->
  expect(tokens[index]).toEqual value: value, scopes: scopes
expectConditionalGroupTokens = (tokens, offset, baseScope, innerSpecs) ->
  expectScopedToken tokens, offset, '(', regexpConditionalGroupScopes(baseScope).concat ['punctuation.definition.group.regexp.php']
  innerOffset = offset + 1
  for [value, scopes] in innerSpecs
    expectScopedToken tokens, innerOffset, value, scopes
    innerOffset += 1
  expectScopedToken tokens, innerOffset, ')', regexpConditionalGroupScopes(baseScope).concat ['punctuation.definition.group.regexp.php']
  innerOffset + 1
regexpConditionalRecursionScopes = (baseScope) ->
  regexpConditionalGroupScopes(baseScope).concat ['keyword.other.recursion.regexp.php']
regexpConditionalNestedGroupScopes = (baseScope) ->
  regexpConditionalGroupContentScopes(baseScope).concat regexpGroupScope
regexpCommentGroupScope = regexpGroupScope.concat ['comment.block.regexp.php']
regexpCommentGroupScopes = (baseScope) ->
  baseScope.concat regexpCommentGroupScope
regexpQuotedLiteralBoundaryScope = ['meta.embedded.quoted-literal.regexp.php']
regexpQuotedLiteralBoundaryScopes = (baseScope) ->
  baseScope.concat regexpQuotedLiteralBoundaryScope
regexpDecodedQuotedLiteralTransportScopes = (baseScope) ->
  regexpQuotedLiteralBoundaryScopes(baseScope).concat ['constant.character.escape.php']
regexpQuotedLiteralContentScopes = (baseScope) ->
  regexpQuotedLiteralBoundaryScopes(baseScope).concat ['string.regexp.quoted-literal.php']
regexpCharacterClassQuotedLiteralBoundaryScopes = (baseScope) ->
  regexpCharacterClassScopes(baseScope).concat regexpQuotedLiteralBoundaryScope
regexpCharacterClassDecodedQuotedLiteralTransportScopes = (baseScope) ->
  regexpCharacterClassQuotedLiteralBoundaryScopes(baseScope).concat ['constant.character.escape.php']
regexpCharacterClassQuotedLiteralContentScopes = (baseScope) ->
  regexpCharacterClassQuotedLiteralBoundaryScopes(baseScope).concat ['string.regexp.quoted-literal.php']
regexpRangeQuantifierScopes = (baseScope) ->
  baseScope.concat ['meta.embedded.quantifier.range.regexp.php', 'keyword.operator.quantifier.regexp.php']
regexpRangeQuantifierBeginScopes = (baseScope) ->
  regexpRangeQuantifierScopes(baseScope).concat ['punctuation.definition.quantifier.begin.regexp.php']
regexpRangeQuantifierEndScopes = (baseScope) ->
  regexpRangeQuantifierScopes(baseScope).concat ['punctuation.definition.quantifier.end.regexp.php']
interpretedTransportBackslashScopes = (baseScope, slashes) ->
  [0...(slashes / 2)].map (pairIndex) ->
    scopes = baseScope.concat ['constant.character.escape.php']
    if pairIndex % 2 is 1
      scopes.concat ['constant.character.escape.regexp.php']
    else
      scopes


module.exports =
  expectPlainAssignment: expectPlainAssignment
  quotedSingleRegexpScope: quotedSingleRegexpScope
  quotedDoubleRegexpScope: quotedDoubleRegexpScope
  heredocRegexpBoundaryScope: heredocRegexpBoundaryScope
  heredocRegexpScope: heredocRegexpScope
  nowdocRegexpBoundaryScope: nowdocRegexpBoundaryScope
  nowdocRegexpScope: nowdocRegexpScope
  regexpCharacterClassBoundaryScope: regexpCharacterClassBoundaryScope
  regexpCharacterClassScope: regexpCharacterClassScope
  regexpCharacterClassScopes: regexpCharacterClassScopes
  regexpCharacterClassPunctuationScopes: regexpCharacterClassPunctuationScopes
  regexpCharacterClassBoundaryNegationScopes: regexpCharacterClassBoundaryNegationScopes
  regexpCharacterClassLiteralScopes: regexpCharacterClassLiteralScopes
  regexpCharacterClassEscapeScopes: regexpCharacterClassEscapeScopes
  regexpCharacterClassClassEscapeScopes: regexpCharacterClassClassEscapeScopes
  regexpCharacterClassInvalidEscapeScopes: regexpCharacterClassInvalidEscapeScopes
  regexpCharacterClassDecodedEscapeTransportScopes: regexpCharacterClassDecodedEscapeTransportScopes
  regexpCharacterClassDecodedInvalidTransportScopes: regexpCharacterClassDecodedInvalidTransportScopes
  regexpCharacterClassDecodedNumericTransportScopes: regexpCharacterClassDecodedNumericTransportScopes
  regexpCharacterClassPhpEscapeScopes: regexpCharacterClassPhpEscapeScopes
  regexpCharacterClassPhpHexEscapeScopes: regexpCharacterClassPhpHexEscapeScopes
  regexpCharacterClassNumericScopes: regexpCharacterClassNumericScopes
  regexpCharacterClassOctalScopes: regexpCharacterClassOctalScopes
  regexpCharacterClassRangeScopes: regexpCharacterClassRangeScopes
  regexpCharacterClassLetterRangeScopes: regexpCharacterClassLetterRangeScopes
  regexpCharacterClassRangeOperatorScopes: regexpCharacterClassRangeOperatorScopes
  regexpCharacterClassDigitRangeScopes: regexpCharacterClassDigitRangeScopes
  regexpCharacterClassGenericRangeScopes: regexpCharacterClassGenericRangeScopes
  regexpCharacterClassHexRangeScopes: regexpCharacterClassHexRangeScopes
  regexpCharacterClassPosixScope: regexpCharacterClassPosixScope
  regexpCharacterClassPosixScopes: regexpCharacterClassPosixScopes
  regexpGroupScope: regexpGroupScope
  regexpGroupScopes: regexpGroupScopes
  regexpGroupContentScopes: regexpGroupContentScopes
  regexpSpecificGroupPunctuationScopes: regexpSpecificGroupPunctuationScopes
  regexpGroupNameScopes: regexpGroupNameScopes
  regexpNamedBackreferenceScopes: regexpNamedBackreferenceScopes
  regexpNamedBackreferenceNameScopes: regexpNamedBackreferenceNameScopes
  regexpSubroutineScopes: regexpSubroutineScopes
  regexpNamedSubroutineScopes: regexpNamedSubroutineScopes
  regexpNamedSubroutineNameScopes: regexpNamedSubroutineNameScopes
  regexpDecodedSubroutineTransportScopes: regexpDecodedSubroutineTransportScopes
  regexpDecodedNamedSubroutineTransportScopes: regexpDecodedNamedSubroutineTransportScopes
  regexpGroupRecursionScopes: regexpGroupRecursionScopes
  regexpGroupSubroutineScopes: regexpGroupSubroutineScopes
  regexpGroupNamedSubroutineScopes: regexpGroupNamedSubroutineScopes
  regexpInvalidEscapeScopes: regexpInvalidEscapeScopes
  regexpOctalScopes: regexpOctalScopes
  regexpDecodedInvalidTransportScopes: regexpDecodedInvalidTransportScopes
  regexpDecodedNumericTransportScopes: regexpDecodedNumericTransportScopes
  regexpDecodedAnchorTransportScopes: regexpDecodedAnchorTransportScopes
  regexpWrapperBeginQuoteScopes: regexpWrapperBeginQuoteScopes
  regexpWrapperBeginDelimiterScopes: regexpWrapperBeginDelimiterScopes
  regexpWrapperEndDelimiterScopes: regexpWrapperEndDelimiterScopes
  regexpWrapperFlagScopes: regexpWrapperFlagScopes
  regexpWrapperEndQuoteScopes: regexpWrapperEndQuoteScopes
  regexpWildcardScopes: regexpWildcardScopes
  regexpControlKeywordScopes: regexpControlKeywordScopes
  regexpBacktrackingVerbScopes: regexpBacktrackingVerbScopes
  regexpDirectiveScopes: regexpDirectiveScopes
  regexpAssertionGroupScope: regexpAssertionGroupScope
  regexpAssertionGroupScopes: regexpAssertionGroupScopes
  regexpAssertionGroupContentScopes: regexpAssertionGroupContentScopes
  regexpSpecificAssertionPunctuationScopes: regexpSpecificAssertionPunctuationScopes
  regexpConditionalGroupScope: regexpConditionalGroupScope
  regexpConditionalGroupScopes: regexpConditionalGroupScopes
  regexpConditionalGroupContentScopes: regexpConditionalGroupContentScopes
  regexpConditionalAssertionConditionScopes: regexpConditionalAssertionConditionScopes
  regexpConditionalAssertionContentScopes: regexpConditionalAssertionContentScopes
  regexpConditionalAssertionEndScopes: regexpConditionalAssertionEndScopes
  regexpSpecificConditionalAssertionPunctuationScopes: regexpSpecificConditionalAssertionPunctuationScopes
  regexpConditionalBeginKeywordScopes: regexpConditionalBeginKeywordScopes
  regexpConditionalBeginPunctuationScopes: regexpConditionalBeginPunctuationScopes
  regexpConditionalPunctuationScopes: regexpConditionalPunctuationScopes
  regexpConditionalKeywordScopes: regexpConditionalKeywordScopes
  expectScopedToken: expectScopedToken
  expectConditionalGroupTokens: expectConditionalGroupTokens
  regexpConditionalRecursionScopes: regexpConditionalRecursionScopes
  regexpConditionalNestedGroupScopes: regexpConditionalNestedGroupScopes
  regexpCommentGroupScope: regexpCommentGroupScope
  regexpCommentGroupScopes: regexpCommentGroupScopes
  regexpQuotedLiteralBoundaryScope: regexpQuotedLiteralBoundaryScope
  regexpQuotedLiteralBoundaryScopes: regexpQuotedLiteralBoundaryScopes
  regexpDecodedQuotedLiteralTransportScopes: regexpDecodedQuotedLiteralTransportScopes
  regexpQuotedLiteralContentScopes: regexpQuotedLiteralContentScopes
  regexpCharacterClassQuotedLiteralBoundaryScopes: regexpCharacterClassQuotedLiteralBoundaryScopes
  regexpCharacterClassDecodedQuotedLiteralTransportScopes: regexpCharacterClassDecodedQuotedLiteralTransportScopes
  regexpCharacterClassQuotedLiteralContentScopes: regexpCharacterClassQuotedLiteralContentScopes
  regexpRangeQuantifierScopes: regexpRangeQuantifierScopes
  regexpRangeQuantifierBeginScopes: regexpRangeQuantifierBeginScopes
  regexpRangeQuantifierEndScopes: regexpRangeQuantifierEndScopes
  interpretedTransportBackslashScopes: interpretedTransportBackslashScopes


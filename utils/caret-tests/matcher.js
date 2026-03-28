// @ts-check

/**
 * @param {string} selector
 * @param {string} scope
 * @returns {boolean}
 */
const matchesSelector = (selector, scope) =>
  scope === selector || scope.startsWith(`${selector}.`);

/**
 * @param {string[]} selectors
 * @param {string[]} scopes
 * @returns {boolean}
 */
const matchesOrderedSelectors = (selectors, scopes) => {
  if (selectors.length === 0) return false;

  let scopeIndex = 0;
  for (const selector of selectors) {
    let matched = false;
    while (scopeIndex < scopes.length) {
      if (matchesSelector(selector, scopes[scopeIndex])) {
        matched = true;
        scopeIndex += 1;
        break;
      }
      scopeIndex += 1;
    }

    if (!matched) return false;
  }

  return true;
};

/**
 * @param {string[]} selectors
 * @param {string[]} scopes
 * @param {string} startScope
 * @returns {boolean}
 */
const assertsBeforeStartScope = (selectors, scopes, startScope) => {
  const startIndex = scopes.indexOf(startScope);
  if (startIndex === -1) return false;

  for (const selector of selectors) {
    for (let index = 0; index < startIndex; index += 1) {
      if (matchesSelector(selector, scopes[index])) return true;
    }
  }

  return false;
};

module.exports = {
  assertsBeforeStartScope,
  matchesOrderedSelectors,
  matchesSelector,
};

// @ts-check

const { readdirSync, statSync } = require("fs");
const path = require("path");

/**
 * @typedef {{
 *   isDir: true,
 *   relativePath: string,
 *   dirItems: DirItem[],
 * } | {
 *   isDir: false,
 *   relativePath: string,
 *   specRelativePath: string,
 *   path: string,
 * }} DirItem
 */

/**
 * @param {string} value
 * @returns {string}
 */
const normalizeSlashes = (value) => value.replace(/\\/g, "/");

/**
 * @param {string} pattern
 * @returns {RegExp}
 */
const patternToRegExp = (pattern) => {
  const normalized = normalizeSlashes(pattern);
  const placeholders = normalized
    .replace(/\*\*\//g, "\u0000DOUBLE_STAR_DIR\u0000")
    .replace(/\*\*/g, "\u0000DOUBLE_STAR\u0000")
    .replace(/\*/g, "\u0000SINGLE_STAR\u0000");
  const escaped = placeholders.replace(/[-/\\^$+?.()|[\]{}]/g, "\\$&");
  const withDoubleStarDir = escaped.replace(
    /\u0000DOUBLE_STAR_DIR\u0000/g,
    "(?:.*/)?"
  );
  const withDoubleStar = withDoubleStarDir.replace(
    /\u0000DOUBLE_STAR\u0000/g,
    ".*"
  );
  const withSingleStar = withDoubleStar.replace(
    /\u0000SINGLE_STAR\u0000/g,
    "[^/]*"
  );
  return new RegExp(`^${withSingleStar}$`);
};

/**
 * @param {string} absoluteRoot
 * @param {string} relativeDir
 * @param {string[]} filePaths
 */
const walkFiles = (absoluteRoot, relativeDir, filePaths) => {
  const dirPath = path.join(absoluteRoot, relativeDir);
  /** @type {import("fs").Dirent[]} */
  const entries = readdirSync(dirPath, { withFileTypes: true });

  for (const entry of entries) {
    const entryRelativePath = relativeDir
      ? path.posix.join(relativeDir, entry.name)
      : entry.name;

    if (entry.isDirectory()) {
      walkFiles(absoluteRoot, entryRelativePath, filePaths);
      continue;
    }

    filePaths.push(entryRelativePath);
  }
};

/**
 * @param {string} specRoot
 * @param {{ pattern: string, scopeName: string, startScope?: string }[]} groups
 */
const discoverFixtures = (specRoot, groups) => {
  const caretRoot = path.join(specRoot, "caret");
  if (!statSync(caretRoot).isDirectory()) return [];

  /** @type {string[]} */
  const filePaths = [];
  walkFiles(specRoot, "caret", filePaths);

  const compiledGroups = groups.map((group) => ({
    ...group,
    matcher: patternToRegExp(group.pattern),
  }));

  return filePaths
    .filter((relativePath) => relativePath.endsWith(".php"))
    .map((relativePath) => {
      const group = compiledGroups.find(({ matcher }) => matcher.test(relativePath));
      if (!group) return null;

      return {
        path: path.join(specRoot, relativePath),
        relativePath: normalizeSlashes(relativePath),
        scopeName: group.scopeName,
        startScope: group.startScope || null,
      };
    })
    .filter(Boolean);
};

/**
 * @param {string} specRoot
 * @param {string} relativeDir
 * @returns {DirItem[]}
 */
const getDirItems = (specRoot, relativeDir) => {
  const dirPath = path.join(specRoot, relativeDir);
  /** @type {import("fs").Dirent[]} */
  const entries = readdirSync(dirPath, { withFileTypes: true })
    .filter((entry) => entry.isDirectory() || entry.name.endsWith(".php"))
    .sort((left, right) => {
      if (left.isDirectory() && !right.isDirectory()) return -1;
      if (!left.isDirectory() && right.isDirectory()) return 1;
      return left.name.localeCompare(right.name);
    });

  return entries.map((entry) => {
    const entryRelativePath = path.posix.join(relativeDir, entry.name);
    if (entry.isDirectory()) {
      return {
        isDir: true,
        relativePath: entry.name,
        dirItems: getDirItems(specRoot, entryRelativePath),
      };
    }

    return {
      isDir: false,
      relativePath: entry.name,
      specRelativePath: normalizeSlashes(entryRelativePath),
      path: path.join(specRoot, entryRelativePath),
    };
  });
};

module.exports = {
  discoverFixtures,
  getDirItems,
  patternToRegExp,
};

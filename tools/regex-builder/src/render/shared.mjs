export function groupOpen(groupStyle) {
  return groupStyle === "noncapturing" ? "(?:" : "(";
}

export function isAutoIndentMode(indent) {
  return indent === "auto";
}

export function escapeRegexLiteral(value) {
  return String(value).replace(/[\\^$.*+?()[\]{}|]/g, "\\$&");
}

/**
 * @param {string} text
 * @param {boolean} hasGroup
 * @returns {{ text: string, singleLine: boolean, hasGroup: boolean }}
 */
export function makeEmitted(text, hasGroup) {
  return {
    text,
    singleLine: !text.includes("\n"),
    hasGroup,
  };
}

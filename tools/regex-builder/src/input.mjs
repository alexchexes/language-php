export function parseInputLines(text) {
  return String(text)
    .replace(/\r\n?/g, "\n")
    .split("\n")
    .map((line) => line.trim())
    .map((line) => line.replace(/^\|+\s*/, ""))
    .filter(Boolean);
}

export function uniqueStable(values) {
  const seen = new Set();
  const out = [];

  for (const value of values) {
    if (seen.has(value)) continue;
    seen.add(value);
    out.push(value);
  }

  return out;
}

/** @typedef {{ terminal: boolean, children: Map<string, TrieNode> }} TrieNode */
/** @typedef {{ terminal: boolean, edges: Array<{ label: string, node: CompNode }> }} CompNode */

function createTrieNode() {
  return { terminal: false, children: new Map() };
}

/**
 * Build a character trie from a list of literal strings.
 * @param {string[]} strings
 * @returns {TrieNode}
 */
export function buildTrie(strings) {
  const root = createTrieNode();

  for (const value of strings) {
    let node = root;
    for (const ch of value) {
      if (!node.children.has(ch)) {
        node.children.set(ch, createTrieNode());
      }
      node = node.children.get(ch);
    }
    node.terminal = true;
  }

  return root;
}

/**
 * Compress single-child chains into edge labels.
 * Keeps terminal boundaries intact.
 * @param {TrieNode} node
 * @returns {CompNode}
 */
export function compressTrie(node) {
  /** @type {CompNode} */
  const out = { terminal: node.terminal, edges: [] };

  const entries = [...node.children.entries()].sort((a, b) =>
    a[0].localeCompare(b[0]),
  );

  for (const [ch, child] of entries) {
    let label = ch;
    let n = child;

    while (!n.terminal && n.children.size === 1) {
      const [[nextCh, nextNode]] = [...n.children.entries()];
      label += nextCh;
      n = nextNode;
    }

    out.edges.push({ label, node: compressTrie(n) });
  }

  return out;
}

/**
 * JSON-friendly representation (useful for inspection/debugging).
 * @param {CompNode} node
 * @returns {any}
 */
export function compTrieToObject(node) {
  const out = {};
  if (node.terminal) out.$ = true;

  for (const edge of node.edges) {
    out[edge.label] = compTrieToObject(edge.node);
  }

  return out;
}

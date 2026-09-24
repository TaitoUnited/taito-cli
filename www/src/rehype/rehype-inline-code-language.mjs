import { visit } from 'unist-util-visit';

// Tags inline `code` (not inside a fenced ```block```) as language-text, so
// it picks up Prism's `code[class*="language-"]` box styling.
export default function rehypeInlineCodeLanguage() {
  return (tree) => {
    visit(tree, 'element', (node, _index, parent) => {
      if (node.tagName !== 'code' || parent?.tagName === 'pre') return;

      const className = node.properties.className;
      if (
        Array.isArray(className) &&
        className.some((c) => String(c).startsWith('language-'))
      ) {
        return;
      }

      node.properties.className = [...(className ?? []), 'language-text'];
    });
  };
}

import { visit } from 'unist-util-visit';

// Excludes the `**Next:** [chapter](link)` paragraphs from the Pagefind index.
export default function rehypeIgnoreNextLinks() {
  return (tree) => {
    visit(tree, 'element', (node) => {
      if (node.tagName !== 'p') return;

      const first = node.children[0];
      const text = first?.children?.[0];
      if (
        first?.type === 'element' &&
        first.tagName === 'strong' &&
        text?.type === 'text' &&
        text.value.trim() === 'Next:'
      ) {
        node.properties.dataPagefindIgnore = '';
      }
    });
  };
}

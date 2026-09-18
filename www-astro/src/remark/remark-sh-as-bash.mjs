import { visit } from 'unist-util-visit';

// Normalizes ` ```sh ` fenced code blocks to ` ```bash `
// Ported from `gatsby-remark-prismjs`'s `aliases: { sh: 'bash' }` option,
// as no direct equivalent in built-in Prism highligter
export default function remarkShAsBash() {
  return (tree) => {
    visit(tree, 'code', (node) => {
      if (node.lang === 'sh') {
        node.lang = 'bash';
      }
    });
  };
}

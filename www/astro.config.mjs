// @ts-check
import { defineConfig } from 'astro/config';

import react from '@astrojs/react';
import pagefind from 'astro-pagefind';
import { unified } from '@astrojs/markdown-remark';
import rehypeSlug from 'rehype-slug';

import remarkLinksBase from './src/remark/remark-links-base.mjs';
import remarkShAsBash from './src/remark/remark-sh-as-bash.mjs';
import rehypeHeadingAnchors from './src/rehype/rehype-heading-anchors.mjs';
import rehypeIgnoreNextLinks from './src/rehype/rehype-ignore-next-links.mjs';
import rehypeInlineCodeLanguage from './src/rehype/rehype-inline-code-language.mjs';

//GitHub Pages project-site path taito-cli is served
export const BASE = '/taito-cli';

export default defineConfig({
  site: 'https://taitounited.github.io',
  base: BASE,
  trailingSlash: 'always',
  prefetch: { prefetchAll: true },

  integrations: [react(), pagefind()],

  markdown: {
    syntaxHighlight: 'prism',
    processor: unified({
      remarkPlugins: [remarkShAsBash, [remarkLinksBase, { base: BASE }]],
      rehypePlugins: [
        rehypeSlug,
        rehypeHeadingAnchors,
        rehypeInlineCodeLanguage,
        rehypeIgnoreNextLinks,
      ],
    }),
  },
});

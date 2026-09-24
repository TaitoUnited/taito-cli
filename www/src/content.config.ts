import { defineCollection } from 'astro:content';
import { glob } from 'astro/loaders';

// Keeps ids as the raw filename (no slug-casing), matching remark-links-base.mjs's
// README/filename handling and every id comparison elsewhere in this codebase.
const generateId = ({ entry }: { entry: string }) => entry.replace(/\.md$/, '');

const docs = defineCollection({
  loader: glob({ pattern: '*.md', base: '../docs/docs', generateId }),
});

const tutorial = defineCollection({
  loader: glob({ pattern: '*.md', base: '../docs/tutorial', generateId }),
});

const topics = defineCollection({
  loader: glob({ pattern: '*.md', base: '../docs', generateId }),
});

export const collections = { docs, tutorial, topics };

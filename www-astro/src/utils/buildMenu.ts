import type { MarkdownHeading } from 'astro';
import { getCollection, render, type CollectionEntry } from 'astro:content';

export interface MenuItem {
  id: string;
  slug: string;
  label: string;
}

// Chapter title is the document's `##` heading (`#` is used for tutorial PART headings)
export function getEntryTitle(headings: MarkdownHeading[]) {
  return headings.find((heading) => heading.depth === 2)?.text;
}

export async function buildMenu<C extends 'docs' | 'tutorial'>(
  collection: C,
  basePath: string
): Promise<MenuItem[]> {
  const entries = await getCollection(
    collection,
    (entry) => entry.id !== 'README'
  );
  entries.sort((a, b) => a.id.localeCompare(b.id));

  return Promise.all(
    entries.map(async (entry) => {
      const { headings } = await render(entry as CollectionEntry<C>);
      return {
        id: entry.id,
        slug: `${basePath}/${entry.id}`,
        label: getEntryTitle(headings) ?? 'Missing heading!',
      };
    })
  );
}

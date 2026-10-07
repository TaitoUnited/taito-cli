import { getCollection, render, type CollectionEntry } from 'astro:content';

export interface MenuItem {
  id: string;
  slug: string;
  label: string;
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
      const h2 = headings.find((heading) => heading.depth === 2);
      return {
        id: entry.id,
        slug: `${basePath}/${entry.id}`,
        label: h2 ? h2.text : 'Missing heading!',
      };
    })
  );
}

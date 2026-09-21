import createCache from '@emotion/cache';

// Own cache per island, pointed at its persisted container in Root.astro,
// so styles survive <ClientRouter /> navigations.
export function createIslandCache(containerId: string) {
  if (typeof document === 'undefined') {
    return createCache({ key: 'css' });
  }

  const container = document.getElementById(containerId) ?? document.head;
  // speedy: false because transition:persist detach/reattach resets a <style> element's CSSOM,
  // which wipes Emotion's default insertRule()-only styles but not real text content.
  return createCache({ key: 'css', container, speedy: false });
}

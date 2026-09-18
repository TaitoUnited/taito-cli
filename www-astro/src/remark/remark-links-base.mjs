import { visit } from 'unist-util-visit';

const MD_LINK = /^(.*?)\.md(#.*)?$/;

// Turns a `.md` link into a real route, e.g. `01-quick-start.md` -> `/docs/01-quick-start/`.
function resolveMdLink(url, sourceDir) {
  const match = url.match(MD_LINK);
  if (!match) return url;

  const [, target, hash = ''] = match;
  const fullPath = url.startsWith('/') ? target : `${sourceDir}${target}`;
  const segments = fullPath.split('/').filter(Boolean);
  const filename = segments.pop() ?? '';
  const dir = `/${segments.join('/')}${segments.length ? '/' : ''}`;

  // READMEs are index pages: they don't get their own path segment.
  if (filename.toLowerCase() === 'readme') {
    return `${dir}${hash}`;
  }

  return `${dir}${filename}/${hash}`;
}

// Rewrites markdown links into real routes and prefixes them with the site's base path.
export default function remarkLinksBase({ base = '' } = {}) {
  return (tree, file) => {
    const sourceDir = getSourceDir(file);

    visit(tree, 'link', (node) => {
      if (!node.url || /^https?:\/\//.test(node.url)) return;

      if (MD_LINK.test(node.url)) {
        node.url = resolveMdLink(node.url, sourceDir);
      }

      if (node.url.startsWith('/') && base && !node.url.startsWith(base)) {
        node.url = `${base}${node.url}`.replace(/\/{2,}/g, '/');
      }
    });
  };
}

function getSourceDir(file) {
  const sourcePath = file?.path ?? file?.history?.[0] ?? '';
  const normalized = sourcePath.replaceAll('\\', '/');

  if (normalized.includes('/docs/docs/')) return '/docs/';
  if (normalized.includes('/docs/tutorial/')) return '/tutorial/';
  return '/';
}

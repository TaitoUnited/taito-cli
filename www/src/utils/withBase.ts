// Prefixes an internal path with the site's base path (e.g. `/taito-cli`),
// and adds a trailing slash - every route in this project has one
export function withBase(path: string): string {
  const base = import.meta.env.BASE_URL;
  const trimmedBase = base.endsWith('/') ? base.slice(0, -1) : base;
  const normalizedPath = path.startsWith('/') ? path : `/${path}`;
  const withSlash = normalizedPath.endsWith('/')
    ? normalizedPath
    : `${normalizedPath}/`;
  return `${trimmedBase}${withSlash}`.replace(/\/{2,}/g, '/');
}

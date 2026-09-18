# Migrate taito-cli docs site from Gatsby to Astro (GitHub Pages)

## Context

The `www/` site runs Gatsby 2.4.5 (react 16, 2019-era). It's already broken on
modern Node — verified directly: `npm run develop` fails on Node 22 with the
OpenSSL legacy-provider webpack error, and even with
`NODE_OPTIONS=--openssl-legacy-provider` it fails again inside Gatsby's bundled
`source-map` package trying to load `mappings.wasm`. There's no `.nvmrc` or
`engines` field anywhere, so nobody can currently develop this site without
manually pinning an old Node version. That's the forcing function: this isn't
a style preference, the current toolchain is unmaintainable.

Decisions already made:
- Target framework: **Astro**.
- Hosting: **stays on GitHub Pages**, same public URL
  (`https://taitounited.github.io/taito-cli`) — no domain change.
- Content stays as markdown in `/docs` at the repo root (not moved into
  `www/`), since it's also read directly on GitHub.
- Public URL structure is preserved exactly: `/docs/<slug>/`, `/docs/`,
  `/tutorial/<slug>/`, `/tutorial/`, `/extensions/`, `/plugins/`,
  `/templates/`, `/`, `/404`.
- Algolia search is kept, just re-plumbed for a build-time script instead of a
  Gatsby plugin hook.

Verified facts underpinning the plan: 40 markdown files total (13 in
`docs/docs` incl. README, 24 in `docs/tutorial` incl. README, 3 root topic
files), no images/frontmatter in any of them, `www/` is not an npm workspace
member (fully independent package), and there's a confirmed live SSR bug in
`GitHubEditLink.js` (`filename = path ? path : pathname` evaluates to the
literal string `"false"` during Gatsby's server render because `pathname` is
`false` when `IS_BROWSER` is false and no `path` prop is passed — e.g. from
`doc.js`'s bare `<GitHubEditLink />`) that this migration fixes as a natural
side effect by always passing an explicit build-time path.

## Approach

**New project lives at `www-astro/`, sibling to `www/`**, built out fully,
then swapped in at cutover (rename/replace). Both directories can reference
`../docs` identically, there's no workspace coupling to break, and Gatsby is
already non-functional so there's no need to keep two working builds green in
parallel — this just gives a trivial rollback path and a way to diff URLs
against the last live deploy before cutting over.

### 1. Scaffold & config

- `npm create astro@latest` in `www-astro/`, add `@astrojs/react` (needed for
  React islands: Terminal, Navbar, Sidemenu, Drawer, Search).
- `astro.config.mjs`: `site: 'https://taitounited.github.io'`,
  `base: '/taito-cli'`, `trailingSlash: 'always'` (matches every current
  Gatsby URL), `markdown.syntaxHighlight: 'prism'` (visual parity with the
  current `prism-themes` CSS import).
- `markdown.remarkPlugins`: a ported `remark-links-base.mjs` (see §5) plus a
  small `remark-sh-as-bash.mjs` to replicate `gatsby-remark-prismjs`'s
  `aliases: { sh: 'bash' }` (defensive — no `sh`-tagged fences exist today,
  only `shell` and untagged, but cheap to keep parity).
- `markdown.rehypePlugins`: `rehype-slug` + `rehype-autolink-headings`
  (`className: 'autolink-a'` — **must** stay this exact class name, since
  `Page.js`'s content CSS special-cases `a:not(.autolink-a)`).

### 2. Content collections

Use Astro's Content Layer `glob()` loader in `src/content.config.ts`, which
accepts an arbitrary filesystem `base` — no symlink/copy step needed:

```
docs      -> glob({ pattern: '*.md', base: '../docs/docs' })
tutorial  -> glob({ pattern: '*.md', base: '../docs/tutorial' })
topics    -> glob({ pattern: '*.md', base: '../docs' })   // single '*' excludes docs/ and tutorial/ subfolders
```

No schema needed — verified no frontmatter exists in any of the 40 files.
**Spike first**: confirm the glob loader's default `id` format (expected:
`01-introduction`, `README`, `a-technology-tutorials`, case/prefix preserved)
before building routing on top of it — if it's different, it's a one-line
`generateId` override, not a redesign.

### 3. Routing (replaces `gatsby-node.js` + the 6 duplicated page/template files)

Two shared layouts instead of Gatsby's `doc.js`/`tutorial.js`/`basic.js` +
5 near-duplicate hand-written pages:

- `src/layouts/CollectionPage.astro` — sidebar + drawer + content + edit link.
  Used by `docs/[...slug].astro` and `tutorial/[...slug].astro`.
- `src/layouts/BasicPage.astro` — no sidebar. Used by `docs/index.astro`,
  `tutorial/index.astro`, and `[topic].astro` (4 use-sites, 1 file).

| Route | File | Source |
|---|---|---|
| `/docs/<slug>/` | `src/pages/docs/[...slug].astro` | `getStaticPaths` over `docs` collection, `id !== 'README'`, sorted by `id` |
| `/docs/` | `src/pages/docs/index.astro` | `getEntry('docs', 'README')` |
| `/tutorial/<slug>/` | `src/pages/tutorial/[...slug].astro` | same pattern, `tutorial` collection |
| `/tutorial/` | `src/pages/tutorial/index.astro` | `getEntry('tutorial', 'README')` |
| `/extensions/`, `/plugins/`, `/templates/` | `src/pages/[topic].astro` | `getStaticPaths` over `topics` collection |
| `/`, `/404` | `index.astro`, `404.astro` | static |

Sidebar/menu (replaces the sibling `allMarkdownRemark` query in
`doc.js`/`tutorial.js`): compute once inside `getStaticPaths` using
`render(entry).headings` (Astro's compiled-heading output, same
`{depth, text}` shape as Gatsby's `headings(depth: h2)`), taking the first
`depth === 2` heading as the label — verified this matches both corpora (docs
pages start at h2, tutorial pages have a `# PART I` h1 before their h2s, so
the filter still works).

"Active" sidebar highlighting: compute
`isActive = menuItem.slug === Astro.url.pathname` at build time per generated
page and pass a plain boolean prop — no more client-side
`IS_BROWSER ? window.location.pathname === slug : false` check.

**Always pass `GitHubEditLink` an explicit `path` prop** (`/docs/${id}`,
`/docs/README`, etc.) — fixes the confirmed bug above and removes the
`window.location.pathname` fallback branch entirely.

**Note**: filtering `id !== 'README'` out of `[...slug].astro` naturally drops
two orphaned pages Gatsby currently generates (`/docs/README/`,
`/tutorial/README/` — nothing links to them, they exist only because
`gatsby-node.js` picks templates by slug-prefix regex with no README
special-case). Not a regression against the "preserve URLs" constraint, since
these aren't real/linked URLs today.

### 4. Component migration

| Component | Action |
|---|---|
| `Terminal.js`, `Layout.js`, `Page.js`, `Heading.js`, `Spacing.js`, `Text.js`, `Footer.js`, `theme.js`, `styles/*` | Port as-is (React islands or reused as plain components) |
| `utils.js` | Port `slugify`/`media`/`mobileOnly`/`desktopOnly`/`responsivify` as-is. **Drop** `flattenListData`/`flattenData` — they only exist to unwrap Gatsby GraphQL's `edges[].node` shape; Content Collections return plain arrays/objects already |
| `Navbar.js`, `Sidemenu.js`, `SearchHit.js`, `pages/index.js`'s CTA | Replace `import { Link } from 'gatsby'` with a plain `<a href={withBase(to)}>`; drop `activeStyle`/`partiallyActive`, pass an `isActive`/`currentPath` boolean down from the page instead |
| `Drawer.js` | Drop `import { navigate } from 'gatsby'`; `navigateDelayed` becomes `setTimeout(() => { window.location.href = withBase(to); }, MENU_CLOSE_MS)` — full page load is correct since Astro ships no client router by default |
| `hooks.js` | Delete `useForceTrailingSlash` (unnecessary once `trailingSlash: 'always'` + correct hrefs are in place). Port `useOnScreen` as-is |
| `GitHubEditLink.js` | Make `path` a required prop, delete the `window.location.pathname` fallback |
| `SEO.js` | Drop `StaticQuery`/`graphql`; pass `title`/`description` as plain props from a static constants module into `<head>` (keep `react-helmet`, or inline `<title>`/`<meta>` directly in `Root.astro` — either works since Astro has no need for a runtime head-manager) |

Add one shared helper, `withBase(path)` using `import.meta.env.BASE_URL`, used
everywhere an internal link is built.

**Decide before Milestone 2**: Emotion has no Astro SSR critical-CSS
extraction integration. Recommended: hydrate Emotion-consuming islands
(`Navbar`/`Search` at `client:load`, `Sidemenu`/`Drawer` at `client:idle`) and
accept the same brief FOUC Gatsby's own dev mode already has — building a
custom `@emotion/server` extraction integration is not worth it for a docs
site.

### 5. Port the custom remark plugin

`plugins/gatsby-remark-links-path-prefix/index.js` does two things, both
still needed (Astro's `base` config never touches raw `<a href>`s baked into
compiled markdown HTML):

1. Relative `.md` link resolution (e.g. `01-starting-a-new-project.md`) —
   simpler to port than the original since both content dirs are flat with a
   1:1 directory→URL-prefix mapping; derive the prefix from which content
   collection the source file belongs to.
2. Absolute-path prefixing (`/tutorial` → `/taito-cli/tutorial`) — port as a
   function of a shared `BASE` constant passed in as a plugin option (remark
   plugins run in the Node build process, they can't read
   `import.meta.env.BASE_URL`).

### 6. Search

- `scripts/algolia-index.mjs`: standalone Node script reusing the
  heading-extraction logic from `www/search/index.js` (`hash`, `slugify`, the
  headings-to-records transformer), driven by the same content-globbing
  approach as `content.config.ts`, excluding README entries. Bump
  `algoliasearch` off the ancient v3 dependency since this is a fresh script.
  Wired into the GitHub Actions workflow as a build step gated to the `dev`
  branch (closest equivalent to today's `!IS_DEV` production-only gate),
  reading `ALGOLIA_ADMIN_KEY` from a repo secret.
- Client widget: **keep `react-instantsearch-dom`** for a 1:1 port — still
  works fine for this simple search-box+hits use case, and upgrading to
  `react-instantsearch` v7's hooks-based API is a non-trivial rewrite with no
  user-facing payoff worth bundling into this migration.
- Rename client-exposed env vars `GATSBY_ALGOLIA_APP_ID`/`GATSBY_ALGOLIA_SEARCH_KEY`
  → `PUBLIC_ALGOLIA_APP_ID`/`PUBLIC_ALGOLIA_SEARCH_KEY` (Astro/Vite convention),
  update `.env.example`.

### 7. GitHub Pages deployment

Add `.github/workflows/deploy-www.yml` using `withastro/action@v6` (build,
path: `www-astro` → `www` post-cutover) +
`actions/deploy-pages@v5` (deploy), triggered on push to `dev` with a
`paths: ['www/**', 'docs/**']` filter. This replaces the current manual
`npm run deploy` (`gh-pages -d public`) script entirely.

**Manual step required, can't be done from the repo**: in GitHub repo
Settings → Pages, switch Source from "Deploy from a branch" (`gh-pages`) to
"GitHub Actions."

## Milestones

1. Scaffold + config (mechanical).
2. Static shell: theme/styles/Layout/Page/Navigation/Footer, homepage +
   404 pixel-parity. Resolve the Emotion-hydration decision here.
3. Content collections + `/docs` routing — **highest-risk milestone**:
   validate the glob loader's `id` format and the ported link-rewriting
   plugin against real links (spot-check `docs/docs/07-infrastructure-management.md`).
4. `/tutorial` routing (same pattern, re-verify h1-then-h2 heading structure).
5. Root topic pages (`[topic].astro`) — smallest, mechanical.
6. Search: indexer script + client widget port.
7. GitHub Actions deploy workflow + the manual Pages-source settings change.
8. Cutover: diff the full URL set against the live site (confirm the
   `/docs/README/`/`/tutorial/README/` orphan removal is intentional), retire
   `www/` (old Gatsby tree), rename `www-astro/` → `www/`.

## PR breakdown (stacked)

Ship this as a stack of small PRs rather than one large diff, using **GitHub's
native stacked PRs** (rolled out to all repos in public preview, July 2026) —
an ordered series of PRs, each a focused layer, reviewable independently;
merging the base PR auto-rebases/retargets everything above it on GitHub's
own servers. Usable straight from the github.com PR-creation UI, or via
`gh extension install github/gh-stack` from the CLI.

**PR 1 — plan + scaffold** (this document, branch
`feat/astro-migration-00-plan-and-scaffold`). Bundles the plan doc with the
empty `www-astro/` Astro project + config (§1) — nothing wired to real
content yet. Opened as the base PR of the stack, before any content/routing
work, so every reviewer has full context up front. Trivial to review; delete
or archive `ASTRO_MIGRATION_PLAN.md` in the cutover PR once the migration is
live.

Then roughly one PR per remaining milestone, since each already produces a
reviewable, mostly-self-contained unit:

2. **Static shell** — homepage, 404, Layout/Page/Navigation/Footer, the
   Emotion-hydration decision applied. Reviewable purely by visual diff
   against the live site, no content-collection risk yet. First point in the
   stack where a real page (the homepage) is visible in a browser.
3. **Content collections + `/docs` routing** — `content.config.ts`, the
   ported remark plugin, `CollectionPage.astro`/`BasicPage.astro`,
   `docs/[...slug].astro` + `docs/index.astro`. Largest/riskiest PR — call
   that out in the description so reviewers spend time on the link-rewriting
   and heading-extraction logic specifically. First point real markdown
   content is browsable.
4. **`/tutorial` routing** — thin PR once (3) is merged; mostly reuses its
   layouts, only the collection-specific quirks (h1-before-h2) are new.
5. **Root topic pages** (`[topic].astro`) — smallest PR in the stack.
6. **Search** — indexer script + client widget port. Independent enough that
   it could also be reordered earlier/later in the stack if convenient.
7. **GitHub Actions deploy workflow** — can be opened and merged without
   flipping the repo's Pages source setting yet, so it's low-risk to land
   ahead of full cutover (the workflow just won't be the active deploy path
   until the settings change in the next step).
8. **Cutover** — URL diff/verification, retire `www/`, rename
   `www-astro/` → `www/`, flip Pages source to GitHub Actions, remove
   `ASTRO_MIGRATION_PLAN.md`. Kept as its own final PR so it can be timed
   deliberately (e.g. low-traffic window) independently of the review cycle
   on the earlier stack.

Since each PR only needs the one below it in the stack merged (not the whole
stack), review of PR 3 can proceed while PR 4 is already being drafted on top
of it, rather than waiting for one giant PR to land.

## Key risks to watch

- Content Layer `glob()` loader's default entry-`id` format — spike before
  building routing on top of it.
- Prism-vs-Shiki visual fidelity — check a code-heavy page like
  `docs/tutorial/02-local-development.md`.
- `trailingSlash: 'always'` + GitHub Pages directory-index interaction on
  `/` and `404.html`.

## Verification

- `npm create astro@latest` scaffold boots with `astro dev` — no
  OpenSSL/wasm issues like the current Gatsby setup (this alone is proof the
  toolchain problem is solved).
- Milestone-by-milestone: run `astro build`, serve `dist/` locally (e.g.
  `npx serve dist`), and diff rendered output against the equivalent live
  page at `taitounited.github.io/taito-cli/...` for visual/content parity.
- After Milestone 3/4: crawl all generated routes from `dist/` and diff the
  URL set against a crawl of the current live site, to confirm no unintended
  URL changes (aside from the two intentional orphan-page removals).
- After Milestone 6: run the indexer script against a real Algolia test
  index and confirm the client search widget returns results.
- After Milestone 7: confirm the GitHub Actions workflow run succeeds and
  the Pages deployment serves correctly at the existing URL before flipping
  the repo's Pages source setting.

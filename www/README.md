# Taito CLI website

Docs site for [taitounited.github.io/taito-cli](https://taitounited.github.io/taito-cli/), built with [Astro](https://astro.build/). Page content comes from the markdown files in [`/docs`](../docs), which are also readable directly on GitHub.

Requires Node 22.12 or newer.

## Development

```
npm install
npm run dev
```

The site is served at <http://localhost:4321/taito-cli/>.

Search is built by [Pagefind](https://pagefind.app/) from the built HTML, so it only works in dev after running `npm run build` once (dev serves the index from the latest build).

Other commands:

| Command           | Description                                  |
| ----------------- | -------------------------------------------- |
| `npm run build`   | Build the site and search index into `dist/` |
| `npm run preview` | Serve the built `dist/` locally              |
| `npm run lint`    | Lint with ESLint                             |
| `npm run format`  | Format with Prettier                         |

## Deployment

The site is deployed to GitHub Pages by the [deploy www](../.github/workflows/deploy-www.yml) workflow:

- **Pull requests** touching `www/` or `docs/` are linted and built as a check. Draft PRs are skipped until marked ready for review.
- **Push to `master`** (a release) builds and deploys the site.
- **Manual deploy**: Actions → deploy www → Run workflow, on `dev` or `master`.

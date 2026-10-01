# Taito CLI website

**Search settings:** The Algolia keys are not required for local development: the search index is only pushed by production builds, so the search box is left out of the layout when the keys are missing. If you want to work on the search itself, copy `.env.example` to `.env` and set your Algolia keys there.

Development:

```
npm install
npm run start
```

Release:

```
npm run deploy
```

const path = require('path');
const queries = require('./search');

require('dotenv').config();

const IS_DEV = process.env.NODE_ENV === 'development';

module.exports = {
  siteMetadata: {
    title: 'Taito CLI',
    description: 'Taito CLI - An extensible toolkit for DevOps and NoOps.',
    author: 'Jukka Keski-Luopa',
  },

  pathPrefix: '/taito-cli',

  plugins: [
    !IS_DEV && false && {
      resolve: 'gatsby-plugin-algolia',
      options: {
        appId: process.env.GATSBY_ALGOLIA_APP_ID,
        apiKey: process.env.ALGOLIA_ADMIN_KEY,
        chunkSize: 10000, // default: 1000
        queries,
      },
    },

    {
      resolve: 'gatsby-source-filesystem',
      options: {
        path: path.join(__dirname, '../docs'),
        name: 'data',
      },
    },

    {
      resolve: 'gatsby-transformer-remark',
      options: {
        plugins: [
          {
            resolve: 'gatsby-remark-autolink-headers',
            options: {
              className: 'autolink-a',
              removeAccents: true,
            },
          },

          // NOTE: add `pathPrefix` to relative links in Markdown files
          // https://github.com/gatsbyjs/gatsby/issues/3316
          !IS_DEV && 'gatsby-remark-links-path-prefix',

          {
            resolve: 'gatsby-remark-prismjs',
            aliases: { sh: 'bash' },
            noInlineHighlight: false,
          },
        ].filter(Boolean),
      },
    },

    'gatsby-plugin-catch-links',
    'gatsby-remark-prismjs',
    'gatsby-plugin-emotion',
    'gatsby-plugin-react-helmet',
    'gatsby-plugin-remove-console',
  ].filter(Boolean),
};

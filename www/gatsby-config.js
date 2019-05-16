const path = require('path');

module.exports = {
  siteMetadata: {
    title: 'Taito CLI',
    description: 'Taito CLI - An extensible toolkit for DevOps and NoOps.',
  },

  pathPrefix: '/taito-cli',

  plugins: [
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
            resolve: 'gatsby-remark-prismjs',
            aliases: { sh: 'bash' },
            noInlineHighlight: false,
          },
        ],
      },
    },
    'gatsby-plugin-catch-links',
    'gatsby-remark-prismjs',
    'gatsby-plugin-emotion',
    'gatsby-plugin-react-helmet',
    'gatsby-plugin-remove-console',
  ].filter(Boolean),
};

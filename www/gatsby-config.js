const path = require('path');

module.exports = {
  siteMetadata: {
    title: 'Taito CLI',
    description: 'Taito CLI - An extensible toolkit for DevOps and NoOps.',
  },
  plugins: [
    {
      resolve: 'gatsby-source-filesystem',
      options: {
        path: path.join(__dirname, 'data'),
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

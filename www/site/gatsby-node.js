const path = require('path');
const { createFilePath } = require('gatsby-source-filesystem');

/**
 * Create pages from MD data:
 * -> Docs + sub pages
 * -> Tutorial + sub pages
 * -> Extensions
 * -> Plugins
 * -> Templates
 */

exports.createPages = ({ actions, graphql }) => {
  const { createPage } = actions;

  return graphql(`
    {
      allMarkdownRemark(limit: 1000) {
        edges {
          node {
            id
            fields {
              slug
            }
          }
        }
      }
    }
  `).then(result => {
    if (result.errors) {
      result.errors.forEach(e => console.error(e.toString()));
      return Promise.reject(result.errors);
    }

    const { edges } = result.data.allMarkdownRemark;

    edges.forEach(({ node }) => {
      const { id, fields } = node;
      let component = path.resolve('src/templates/basic.js');

      if (/^\/docs/.test(fields.slug)) {
        component = path.resolve('src/templates/doc.js');
      } else if (/^\/tutorial/.test(fields.slug)) {
        component = path.resolve('src/templates/tutorial.js');
      }

      createPage({
        component,
        path: fields.slug,
        context: { id },
      });
    });
  });
};

exports.onCreateNode = ({ node, actions, getNode }) => {
  const { createNodeField } = actions;

  // Add slug field
  if (node.internal.type === 'MarkdownRemark') {
    const path = createFilePath({ node, getNode });
    createNodeField({ name: 'slug', node, value: path });
  }
};

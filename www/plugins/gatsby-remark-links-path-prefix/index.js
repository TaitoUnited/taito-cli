const visit = require('unist-util-visit');

function withPrefix(path, pathPrefix = '') {
  // ensure only one `/` in new path
  return (pathPrefix + path).replace(/\/\//, '/');
}

module.exports = ({ markdownAST, pathPrefix, markdownNode }) => {
  const fields = markdownNode.fields;
  // READMEs act as index files and don't have a '/' after their slug
  const isIndex = fields ? fields.slug[fields.slug.length - 1] !== '/' : false;
  const path = fields ? fields.slug.split('/').slice(0, isIndex ? -1 : -2).join('/') + '/' : '';

  visit(markdownAST, 'link', node => {
    // Find and replace relative links to .md files to allow linking between documents
    // https://github.com/TaitoUnited/taito-cli/issues/83
    if (
      node.url &&
      !node.url.startsWith('/') &&
      !node.url.startsWith('http://') &&
      !node.url.startsWith('https://')
    ) {
      node.url = node.url.replace(/^(.*)\.md(#.*)?$/, (_match, base, hash) => {
        return `${path}${base}${hash || ''}`
      })
    }

    // Prefix absolute paths
    if (
      node.url.startsWith('/') &&
      pathPrefix &&
      !node.url.startsWith(pathPrefix)
    ) {
      node.url = withPrefix(node.url, pathPrefix);
    }
  });

  return markdownAST;
};

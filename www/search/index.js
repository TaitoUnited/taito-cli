const striptags = require('striptags');

const pageDataQuery = `{
  allMarkdownRemark(filter: {fileAbsolutePath: {regex: "/^((?!README).)*$/"}}) {
    edges {
      node {
        id
        html
        headings {
          value
        }
        fields {
          slug
        }
      }
    }
  }
}`;

const hash = s => {
  return s.split('').reduce((a, b) => {
    a = (a << 5) - a + b.charCodeAt(0);
    return a & a;
  }, 0);
};

const transformer = ({ data }) => {
  const pages = data.allMarkdownRemark.edges;
  let indices = [];

  pages.forEach(({ node }) => {
    const splitMark = '_SPLIT_MARKER_';
    const nodeHeadings = node.headings || [];
    const headingValues = nodeHeadings.map(x => x.value);

    // Strip html tags and cleanup chunks
    const chunks = striptags(node.html, [], splitMark)
      .split(splitMark)
      .map(x => x.trim())
      // HACK: This is a bit too custom / hacky text manipulation...
      // TODO: Figure out a better way to parse and index the md content...
      .map(x => (x.startsWith(': ') ? x.substr(2) : x))
      .filter(x => !!x)
      // Only include longer texts like paragraphs
      .filter(x => x.length > 10);

    // Get the index of each heading so we can attach chunk's parent heading
    const headingIndexes = chunks.reduce((acc, x, index) => {
      if (headingValues.includes(x)) {
        acc.push({ value: x, index });
      }
      return acc;
    }, []);

    // Attach parent node info to each chunk
    const indexableChunks = chunks.map((x, index) => {
      // Get nearest parent heading for chunk
      const h = headingIndexes.filter(x => x.index < index).reverse();
      const _parentHeading = h.length > 0 ? h[0].value : null;

      return {
        content: x,
        // Create a unique ID for chunk
        objectID: `${node.id}${hash(x)}`,
        slug: node.fields.slug,
        // Page heading is always the first heading
        pageHeading: headingValues[0] || null,
        // If the item is a heading use itself as `parentHeading`
        parentHeading: headingValues.includes(x) ? x : _parentHeading,
      };
    });

    indices = [...indices, ...indexableChunks];
  });

  return indices;
};

const queries = [
  {
    transformer,
    query: pageDataQuery,
    indexName: 'taitocli',
  },
];

module.exports = queries;

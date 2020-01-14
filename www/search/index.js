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

// This is a dublicate from ../src/utils because unlike the React files, Node.js requires CommonJS imports.
const slugify = text =>
  text
    .toString()
    .toLowerCase()
    .replace(/\s+/g, '-') // Replace spaces with -
    .replace(/[^\w\-]+/g, '') // Remove all non-word chars
    .replace(/\-\-+/g, '-') // Replace multiple - with single -
    .replace(/^-+/, '') // Trim - from start of text
    .replace(/-+$/, ''); // Trim - from end of text

const transformer = ({ data }) => {
  const pages = data.allMarkdownRemark.edges;

  const indices = pages.reduce((total, { node }) => {
    const nodeHeadings = node.headings || [];
    const headingValues = nodeHeadings.map(x => x.value);

    const newIndices = headingValues.reduce((acc, pageHeading) => {
      const index = {
        // Create a unique ID for each page
        objectID: `${node.id}${hash(pageHeading)}`,
        // Construct the slug for the subcategory
        slug: `${node.fields.slug}#${slugify(pageHeading)}`,
        pageHeading,
      };
      return [...acc, index];
    }, []);

    return [...total, ...newIndices];
  }, []);

  return indices;
};

// Make only the headings searchable
const settings = {
  searchableAttributes: ['pageHeading'],
};

const queries = [
  {
    transformer,
    settings,
    query: pageDataQuery,
    indexName: 'taitocli',
  },
];

module.exports = queries;

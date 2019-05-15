import React from 'react';
import { graphql } from 'gatsby';

import { flattenListData } from '../utils';
import Page from '../components/Page';
import SEO from '../components/SEO';

export default ({ data }) => {
  const items = flattenListData(data, 'items');
  const [pageData] = flattenListData(data, 'data');

  console.log('> items', items);

  return (
    <Page>
      <SEO />
      <div dangerouslySetInnerHTML={{ __html: pageData.html }} />
    </Page>
  );
};

export const query = graphql`
  query {
    items: allMarkdownRemark(
      filter: {
        fileAbsolutePath: { regex: "/docs/(?!README).+/" }
        fields: { slug: { regex: "/docs/" } }
      }
      sort: { fields: [fields___slug], order: ASC }
    ) {
      edges {
        node {
          id
          headings(depth: h2) {
            value
          }
          fields {
            slug
          }
        }
      }
    }
    data: allMarkdownRemark(
      filter: { fileAbsolutePath: { regex: "/docs/README.+/" } }
    ) {
      edges {
        node {
          id
          html
        }
      }
    }
  }
`;

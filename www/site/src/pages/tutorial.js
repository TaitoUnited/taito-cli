import React from 'react';
import { graphql, Link } from 'gatsby';

import { flattenListData } from '../utils';
import Page from '../components/Page';
import SEO from '../components/SEO';

export default ({ data }) => {
  const items = flattenListData(data, 'items');
  const [pageData] = flattenListData(data, 'data');

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
        fileAbsolutePath: { regex: "/tutorial/(?!README).+/" }
        fields: { slug: { regex: "/tutorial/" } }
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
      filter: { fileAbsolutePath: { regex: "/tutorial/README.+/" } }
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

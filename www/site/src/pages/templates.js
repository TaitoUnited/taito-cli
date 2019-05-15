import React from 'react';
import { graphql } from 'gatsby';

import { flattenListData } from '../utils';
import Page from '../components/Page';
import SEO from '../components/SEO';

export default ({ data }) => {
  const [pageData] = flattenListData(data, 'md');

  return (
    <Page>
      <SEO />
      <div dangerouslySetInnerHTML={{ __html: pageData.html }} />
    </Page>
  );
};

export const query = graphql`
  query {
    md: allMarkdownRemark(filter: { fields: { slug: { eq: "/templates/" } } }) {
      edges {
        node {
          id
          html
        }
      }
    }
  }
`;

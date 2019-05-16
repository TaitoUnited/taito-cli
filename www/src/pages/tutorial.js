import React from 'react';
import { graphql } from 'gatsby';

import { flattenListData } from '../utils';
import Page from '../components/Page';
import SEO from '../components/SEO';

export default ({ data }) => {
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

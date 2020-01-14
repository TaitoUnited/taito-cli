import React from 'react';
import { graphql } from 'gatsby';

import { flattenListData } from '../utils';
import Page from '../components/Page';
import SEO from '../components/SEO';
import GitHubEditLink from '../components/GitHubEditLink';
import Spacing from '../components/Spacing';

export default ({ data }) => {
  const [pageData] = flattenListData(data, 'md');

  return (
    <Page>
      <SEO />
      <div dangerouslySetInnerHTML={{ __html: pageData.html }} />

      <Spacing dir="y" amount={20} />

      <GitHubEditLink />
    </Page>
  );
};

export const query = graphql`
  query {
    md: allMarkdownRemark(filter: { fields: { slug: { eq: "/plugins/" } } }) {
      edges {
        node {
          id
          html
        }
      }
    }
  }
`;

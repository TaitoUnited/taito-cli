import React from 'react';
import { graphql, Link } from 'gatsby';
import styled from '@emotion/styled';

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
    md: allMarkdownRemark(filter: { fields: { slug: { eq: "/extensions/" } } }) {
      edges {
        node {
          id
          html
        }
      }
    }
  }
`;

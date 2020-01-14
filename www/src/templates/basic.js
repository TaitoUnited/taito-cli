import React from 'react';
import { graphql } from 'gatsby';

import Page from '../components/Page';
import SEO from '../components/SEO';
import { flattenData } from '../utils';
import GitHubEditLink from '../components/GitHubEditLink';
import Spacing from '../components/Spacing';

export default function BasicTemplate({ data }) {
  const item = flattenData(data);

  return (
    <Page>
      <SEO />
      <div dangerouslySetInnerHTML={{ __html: item.html }} />

      <Spacing dir="y" amount={20} />
      
      <GitHubEditLink />
    </Page>
  );
}

export const pageQuery = graphql`
  query BasicByID($id: String!) {
    markdownRemark(id: { eq: $id }) {
      id
      html
    }
  }
`;

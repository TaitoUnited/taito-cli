import React from 'react';
import { graphql } from 'gatsby';

import Page from '../components/Page';
import SEO from '../components/SEO';
import { flattenData } from '../utils';

export default function TutorialItemTemplate({ data }) {
  const item = flattenData(data);

  return (
    <Page>
      <SEO />
      <div dangerouslySetInnerHTML={{ __html: item.html }} />
    </Page>
  );
}

export const pageQuery = graphql`
  query TutorialByID($id: String!) {
    markdownRemark(id: { eq: $id }) {
      id
      html
    }
  }
`;

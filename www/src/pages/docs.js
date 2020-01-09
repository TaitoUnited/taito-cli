import React from 'react';
import { graphql } from 'gatsby';
import { MdModeEdit } from 'react-icons/md';

import { flattenListData } from '../utils';
import Page from '../components/Page';
import SEO from '../components/SEO';
import Link from '../components/Link';

export default ({ data }) => {
  const [pageData] = flattenListData(data, 'data');

  return (
    <Page>
      <SEO />
      <div dangerouslySetInnerHTML={{ __html: pageData.html }} />

      <Link
        url={
          'https://github.com/TaitoUnited/taito-cli/tree/dev/docs/docs/README.md'
        }
        text={'Edit this page on GitHub'}
        content={<MdModeEdit />}
      />
    </Page>
  );
};

export const query = graphql`
  query {
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

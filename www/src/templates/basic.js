import React from 'react';
import { graphql } from 'gatsby';
import { MdModeEdit } from 'react-icons/md';

import Page from '../components/Page';
import SEO from '../components/SEO';
import { flattenData } from '../utils';
import Link from '../components/Link';

export default function BasicTemplate({ data }) {
  const item = flattenData(data);

  const gitHubUrl = `https://github.com/TaitoUnited/taito-cli/tree/dev/docs${window.location.pathname.replace(
    /\/+$/,
    ''
  )}.md`;

  return (
    <Page>
      <SEO />
      <div dangerouslySetInnerHTML={{ __html: item.html }} />

      <Link
        url={gitHubUrl}
        text={'Edit this page on GitHub'}
        content={<MdModeEdit />}
      />
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

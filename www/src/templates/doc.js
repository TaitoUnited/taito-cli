import React from 'react';
import { graphql } from 'gatsby';

import { flattenListData } from '../utils';
import Page from '../components/Page';
import SEO from '../components/SEO';
import Text from '../components/Text';
import Gutter from '../components/Gutter';
import Sidemenu from '../components/Sidemenu';
import { IS_BROWSER } from '../constants';

export default function DocTemplate({ data }) {
  const menuItems = flattenListData(data, 'menu');

  return (
    <Page
      menu={
        <Sidemenu>
          <Text size={14} weight={200}>
            DOCUMENTATION
          </Text>

          <Gutter dir="vertical" />

          {menuItems.map(item => {
            const isActive = IS_BROWSER
              ? window.location.pathname === item.slug
              : false;

            return (
              <Sidemenu.Item key={item.id} to={item.slug} isActive={isActive}>
                {item.headings.length > 0
                  ? item.headings[0].value
                  : 'Missing heading!'}
              </Sidemenu.Item>
            );
          })}
        </Sidemenu>
      }
    >
      <SEO />
      <div dangerouslySetInnerHTML={{ __html: data.doc.html }} />
    </Page>
  );
}

export const pageQuery = graphql`
  query DocByID($id: String!) {
    doc: markdownRemark(id: { eq: $id }) {
      id
      html
    }

    menu: allMarkdownRemark(
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
  }
`;

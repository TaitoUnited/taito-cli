import React from 'react';
import { graphql } from 'gatsby';
import { FiBookOpen } from 'react-icons/fi';

import { flattenListData } from '../utils';
import { IS_BROWSER } from '../constants';
import Page from '../components/Page';
import SEO from '../components/SEO';
import Text from '../components/Text';
import Spacing from '../components/Spacing';
import Sidemenu from '../components/Sidemenu';
import Drawer from '../components/Drawer';
import GitHubEditLink from '../components/GitHubEditLink';

const isActive = slug =>
  IS_BROWSER ? window.location.pathname === slug : false;

export default function DocTemplate({ data }) {
  const menuItems = flattenListData(data, 'menu');

  return (
    <Page
      menu={
        <Sidemenu>
          <Text size={14} weight={200}>
            DOCUMENTATION
          </Text>

          <Spacing dir="y" />

          {menuItems.map(item => (
            <Sidemenu.Item
              key={item.id}
              to={item.slug}
              isActive={isActive(item.slug)}
            >
              {item.headings.length > 0
                ? item.headings[0].value
                : 'Missing heading!'}
            </Sidemenu.Item>
          ))}
        </Sidemenu>
      }
    >
      <SEO />
      <div dangerouslySetInnerHTML={{ __html: data.doc.html }} />

      <Spacing dir="y" amount={20} />
      
      <GitHubEditLink />

      <Drawer buttonPosition="bottom-right" buttonIcon={<FiBookOpen />}>
        {menuItems.map(item => (
          <Drawer.Item
            key={item.id}
            to={item.slug}
            isActive={isActive(item.slug)}
          >
            {item.headings.length > 0
              ? item.headings[0].value
              : 'Missing heading!'}
          </Drawer.Item>
        ))}
      </Drawer>
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
        fileAbsolutePath: { regex: "/^((?!README).)*$/" }
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

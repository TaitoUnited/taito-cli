import React from 'react';
import { graphql } from 'gatsby';
import { FiBookOpen } from 'react-icons/fi';

import { flattenListData } from '../utils';
import { IS_BROWSER } from '../constants';
import Page from '../components/Page';
import SEO from '../components/SEO';
import Text from '../components/Text';
import Gutter from '../components/Gutter';
import Sidemenu from '../components/Sidemenu';
import Drawer from '../components/Drawer';

export default function TutorialItemTemplate({ data }) {
  const menuItems = flattenListData(data, 'menu');

  return (
    <Page
      menu={
        <Sidemenu>
          <Text size={14} weight={200}>
            TUTORIAL
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
      <div dangerouslySetInnerHTML={{ __html: data.tutorial.html }} />

      <Drawer buttonPosition="bottom-right" buttonIcon={<FiBookOpen />}>
        {menuItems.map(item => (
          <Drawer.Item key={item.id} to={item.slug}>
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
  query TutorialByID($id: String!) {
    tutorial: markdownRemark(id: { eq: $id }) {
      id
      html
    }

    menu: allMarkdownRemark(
      filter: {
        fileAbsolutePath: { regex: "/tutorial/(?!README).+/" }
        fields: { slug: { regex: "/tutorial/" } }
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

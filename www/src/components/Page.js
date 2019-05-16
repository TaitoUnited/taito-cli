import React from 'react';
import styled from '@emotion/styled';

import { useForceTrailingSlash } from '../hooks';
import Navbar from '../components/Navbar';
import Drawer from '../components/Drawer';
import Footer from '../components/Footer';

const Page = ({ menu = null, children, ...rest }) => {
  useForceTrailingSlash();
  console.log({ menu });

  return (
    <Wrapper {...rest}>
      <Main>
        {menu}
        <Content>{children}</Content>
      </Main>
      <Footer />
      <Navbar />
      <Drawer />
    </Wrapper>
  );
};

const Wrapper = styled.div`
  width: 100%;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
`;

const Main = styled.div`
  display: flex;
  flex-direction: row;
  width: 100%;
  margin-top: 50px;
`;

const Content = styled.div`
  flex: 1;
  width: 100%;
  padding: 16px;
  max-width: 900px;
  margin: 0px auto;

  a {
    color: ${props => props.theme.primary[800]};
    background-color: ${props => props.theme.primary[100]};
    border-bottom: 1px solid rgba(0, 0, 0, 0.2);
    text-decoration: none;

    &:hover {
      background-color: ${props => props.theme.primary[200]};
    }
  }

  hr {
    margin-top: 24px;
    margin-bottom: 24px;
    border: none;
    height: 1px;
    background-color: ${props => props.theme.grey[300]};
  }

  ul {
    list-style: disc;
    padding-left: 24px;
  }

  ul > li {
    margin-top: 8px;
  }

  blockquote {
    margin: 0;
    padding: 8px 16px;
    background-color: ${props => props.theme.primary[100]};
    border-left: 8px solid ${props => props.theme.primary[500]};
    color: ${props => props.theme.primary[700]};
    border-radius: 2px;
  }
`;

export default Page;

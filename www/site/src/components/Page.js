import React from 'react';
import styled from '@emotion/styled';

import { useForceTrailingSlash } from '../hooks';
import Navbar from '../components/Navbar';
import Drawer from '../components/Drawer';
import Footer from '../components/Footer';

const Page = ({ children, ...rest }) => {
  useForceTrailingSlash();

  return (
    <Wrapper {...rest}>
      <Content>{children}</Content>
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

const Content = styled.div`
  flex: 1;
  max-width: 1000px;
  width: 100%;
  margin: 50px auto 16px auto;
  padding: 16px;

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
`;

export default Page;

import React from 'react';
import styled from '@emotion/styled';

import { mobileOnly } from '../utils';
import Navbar from './Navbar';
import Drawer from './Drawer';
import Search from './search';

const Navigation = ({ isHome }) => (
  <>
    <Navbar />

    <MobileSearch transparent={!!isHome}>
      <Search />
    </MobileSearch>

    <Drawer>
      <Drawer.Item to="/">Home</Drawer.Item>
      <Drawer.Item to="/docs">Docs</Drawer.Item>
      <Drawer.Item to="/tutorial">Tutorial</Drawer.Item>
      <Drawer.Item to="/plugins">Plugins</Drawer.Item>
      <Drawer.Item to="/templates">Templates</Drawer.Item>
      <Drawer.Item to="/extensions">Extensions</Drawer.Item>
    </Drawer>
  </>
);

const MobileSearch = styled.div`
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: 64px;
  display: flex;
  align-items: center;
  padding: 0px 64px 0px 16px;
  background-color: ${props => props.transparent ? 'transparent' : '#fff'};
  ${mobileOnly}
`;

export default Navigation;

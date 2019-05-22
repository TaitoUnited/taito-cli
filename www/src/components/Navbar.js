import React from 'react';
import styled from '@emotion/styled';
import { Link } from 'gatsby';
import { FaGithub } from 'react-icons/fa';

import { desktopOnly } from '../utils';
import theme from '../theme';
import Gutter from './Gutter';
import Search from './search';

const Navbar = () => {
  const activeStyle = {
    fontWeight: 500,
    borderColor: theme.primary[500],
  };

  return (
    <Nav>
      <NavLinks>
        <NavLink to="/">
          <strong>Taito</strong>&nbsp;CLI
        </NavLink>

        <Gutter amount={64} />

        <NavLink to="/docs" activeStyle={activeStyle} partiallyActive>
          Docs
        </NavLink>

        <Gutter amount={32} />

        <NavLink to="/tutorial" activeStyle={activeStyle} partiallyActive>
          Tutorial
        </NavLink>

        <Gutter amount={32} />

        <NavLink to="/plugins" activeStyle={activeStyle}>
          Plugins
        </NavLink>

        <Gutter amount={32} />

        <NavLink to="/templates" activeStyle={activeStyle}>
          Templates
        </NavLink>

        <Gutter amount={32} />

        <NavLink to="/extensions" activeStyle={activeStyle}>
          Extensions
        </NavLink>

        <div style={{ flex: 1 }} />

        <Search />

        <Gutter />

        <a
          href="https://github.com/TaitoUnited/taito-cli"
          target="__blank"
          rel="noopener noreferrer"
        >
          <FaGithub color="#fff" size={24} />
        </a>
      </NavLinks>
    </Nav>
  );
};

const Nav = styled.nav`
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  background-color: ${props => props.theme.primary[700]};
  z-index: 1;
  ${desktopOnly}
`;

const NavLinks = styled.nav`
  display: flex;
  flex-direction: row;
  align-items: center;
  padding: 0px 16px;
`;

const NavLink = styled(Link)`
  height: 50px;
  display: flex;
  justify-content: center;
  align-items: center;
  text-decoration: none;
  color: #fff;
  border-bottom: 4px solid ${props => props.theme.primary[700]};
  position: relative;
  &:hover {
    border-bottom: 4px solid ${props => props.theme.primary[900]};
  }
`;

export default Navbar;

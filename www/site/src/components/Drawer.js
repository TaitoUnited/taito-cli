import React from 'react';
import styled from '@emotion/styled';
import { FiMenu } from 'react-icons/fi';
import { navigate } from 'gatsby';

import { mobileOnly } from '../utils';
import { IS_BROWSER } from '../constants';

const MENU_WIDTH = IS_BROWSER ? Math.min(360, window.innerWidth * 0.8) : 360;
const MENU_CLOSE_MS = 400;

const Drawer = () => {
  const [isOpen, setOpen] = React.useState(false);

  const navigateDelayed = to => {
    setOpen(false);
    setTimeout(() => navigate(to), MENU_CLOSE_MS);
  };

  return (
    <>
      <MenuButton onClick={() => setOpen(true)}>
        <FiMenu size={20} />
      </MenuButton>

      <Backdrop isVisible={isOpen} onClick={() => setOpen(false)} />

      <Menu isOpen={isOpen}>
        <MenuItem onClick={() => navigateDelayed('/')}>Etusivu</MenuItem>
        <MenuItem onClick={() => navigateDelayed('/palvelut')}>
          Palvelut
        </MenuItem>
        <MenuItem onClick={() => navigateDelayed('/galleria')}>
          Galleria
        </MenuItem>
        <MenuItem onClick={() => navigateDelayed('/ota-yhteytta')}>
          Ota yhteyttä
        </MenuItem>
      </Menu>
    </>
  );
};

const Backdrop = styled.div`
  position: fixed;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  background-color: rgba(0, 0, 0, 0.4);
  z-index: 99;
  transition: opacity 0.3s ease-in;
  opacity: ${props => (props.isVisible ? 1 : 0)};
  pointer-events: ${props => (props.isVisible ? 'auto' : 'none')};
  ${mobileOnly};
`;

const Menu = styled.div`
  position: fixed;
  top: 0;
  bottom: 0;
  left: 0;
  width: ${MENU_WIDTH}px;
  z-index: 100;
  display: flex;
  flex-direction: column;
  box-shadow: 0px 0px 12px rgba(0, 0, 0, 0.5);
  will-change: transform;
  transform: translateX(${props => (props.isOpen ? 0 : -MENU_WIDTH - 10)}px);
  transition: transform ${MENU_CLOSE_MS}ms cubic-bezier(0.2, 0.71, 0.14, 0.91);
  background-color: #fff;
  ${mobileOnly};
`;

const MenuItem = styled.div`
  padding: 16px;
  text-align: center;

  &:active {
    background-color: #ddd;
  }
`;

const MenuButton = styled.button`
  position: fixed;
  top: 16px;
  left: 16px;
  border: none;
  padding: 0;
  background-color: #eee;
  border-radius: 50%;
  height: 40px;
  width: 40px;
  display: flex;
  justify-content: center;
  align-items: center;
  outline: none;
  transition: background-color 0.2s ease;

  &:active {
    background-color: #ddd;
  }

  ${mobileOnly};
`;

export default Drawer;

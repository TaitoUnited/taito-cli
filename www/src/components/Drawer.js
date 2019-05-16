import React from 'react';
import styled from '@emotion/styled';
import { css } from '@emotion/core';
import { FiMenu } from 'react-icons/fi';
import { navigate } from 'gatsby';
import PropTypes from 'prop-types';

import { mobileOnly } from '../utils';
import { IS_BROWSER } from '../constants';

const MENU_WIDTH = IS_BROWSER ? Math.min(360, window.innerWidth * 0.8) : 360;
const MENU_CLOSE_MS = 400;
const ELEVATIONS = { menu: 3, backdrop: 2, button: 1 };

const propTypes = {
  buttonPosition: PropTypes.oneOf(['top-left', 'bottom-right', 'top-right']),
  buttonIcon: PropTypes.node,
};

const Drawer = ({ buttonPosition, buttonIcon, children }) => {
  const [isOpen, setOpen] = React.useState(false);

  const navigateDelayed = to => {
    setOpen(false);
    setTimeout(() => navigate(to), MENU_CLOSE_MS);
  };

  return (
    <>
      <MenuButton onClick={() => setOpen(true)} position={buttonPosition}>
        {buttonIcon || <FiMenu />}
      </MenuButton>

      <Backdrop isVisible={isOpen} onClick={() => setOpen(false)} />

      <Menu isOpen={isOpen}>
        {React.Children.map(children, (comp, index) =>
          React.cloneElement(comp, {
            key: index,
            onClick: () => navigateDelayed(comp.props.to),
          })
        )}
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
  z-index: ${ELEVATIONS.backdrop};
  transition: opacity 0.3s ease-in;
  opacity: ${props => (props.isVisible ? 1 : 0)};
  pointer-events: ${props => (props.isVisible ? 'auto' : 'none')};
  ${mobileOnly};
`;

const Menu = styled.div`
  position: fixed;
  z-index: ${ELEVATIONS.menu};
  top: 0;
  bottom: 0;
  left: 0;
  overflow-y: auto;
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
  position: relative;

  &:active {
    background-color: ${props => props.theme.primary[100]};
  }

  &::before {
    content: '';
    display: ${props => (props.isActive ? 'block' : 'none')};
    position: absolute;
    left: -5px;
    top: 50%;
    transform: translateY(-50%);
    width: 12px;
    height: 8px;
    background-color: ${props => props.theme.primary[500]};
    border-radius: 99px;
  }
`;

const MenuButton = styled.button`
  position: fixed;
  z-index: ${ELEVATIONS.button};
  border: none;
  padding: 0;
  color: ${props => props.theme.primary[500]};
  background-color: #fff;
  border-radius: 50%;
  height: 48px;
  width: 48px;
  display: flex;
  justify-content: center;
  align-items: center;
  outline: none;
  opacity: 1;
  transition: opacity 0.2s ease;
  font-size: 24px;
  box-shadow: 0px 2px 8px rgba(0,0,0,0.2);

  &:active {
    opacity: 0.7;
  }

  ${props =>
    props.position === 'top-left' &&
    css`
      top: 8px;
      left: 8px;
    `}

  ${props =>
    props.position === 'top-right' &&
    css`
      top: 8px;
      right: 8px;
    `}

  ${props =>
    props.position === 'bottom-right' &&
    css`
      bottom: 24px;
      right: 8px;
    `}

  ${mobileOnly};
`;

Drawer.Item = MenuItem;
Drawer.propTypes = propTypes;
Drawer.defaultProps = {
  buttonPosition: 'top-right',
};

export default Drawer;

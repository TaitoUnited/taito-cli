import { useState } from 'react';
import styled from '@emotion/styled';
import { FiMenu } from 'react-icons/fi';
import { navigate } from 'astro:transitions/client';
import { theme } from '../../theme';
import { withBase } from '../../utils/withBase';
import { BREAKPOINTS } from '../../constants/site';

const IS_BROWSER = typeof window !== 'undefined';
const MENU_WIDTH = IS_BROWSER ? Math.min(360, window.innerWidth * 0.8) : 360;
const MENU_CLOSE_MS = 400;
const ELEVATIONS = { menu: 3, backdrop: 2, button: 1 };

export interface DrawerItemData {
  to: string;
  label: string;
  active?: boolean;
}

interface Props {
  items: DrawerItemData[];
}

export default function Drawer({ items }: Props) {
  const [isOpen, setIsOpen] = useState(false);

  const navigateDelayed = (to: string) => {
    setIsOpen(false);
    setTimeout(() => {
      navigate(withBase(to));
    }, MENU_CLOSE_MS);
  };

  return (
    <>
      <MenuButton onClick={() => setIsOpen(true)} aria-label="Open menu">
        <FiMenu />
      </MenuButton>

      <Backdrop isVisible={isOpen} onClick={() => setIsOpen(false)} />

      <Menu isOpen={isOpen}>
        {items.map((item) => (
          <MenuItem
            key={item.to}
            isActive={!!item.active}
            onClick={() => navigateDelayed(item.to)}
          >
            {item.label}
          </MenuItem>
        ))}
      </Menu>
    </>
  );
}

const mobileOnly = `
  @media (min-width: ${BREAKPOINTS.sm + 1}px) {
    display: none;
  }
`;

const Backdrop = styled.div<{ isVisible: boolean }>`
  position: fixed;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  background-color: rgba(0, 0, 0, 0.4);
  z-index: ${ELEVATIONS.backdrop};
  transition: opacity 0.3s ease-in;
  opacity: ${(props) => (props.isVisible ? 1 : 0)};
  pointer-events: ${(props) => (props.isVisible ? 'auto' : 'none')};
  ${mobileOnly}
`;

const Menu = styled.div<{ isOpen: boolean }>`
  position: fixed;
  z-index: 100;
  top: 0;
  bottom: 0;
  left: 0;
  overflow-y: auto;
  width: ${MENU_WIDTH}px;
  display: flex;
  flex-direction: column;
  box-shadow: 0px 0px 12px rgba(0, 0, 0, 0.5);
  will-change: transform;
  transform: translateX(${(props) => (props.isOpen ? 0 : -MENU_WIDTH - 10)}px);
  transition: transform ${MENU_CLOSE_MS}ms cubic-bezier(0.2, 0.71, 0.14, 0.91);
  background-color: #fff;
  ${mobileOnly}
`;

const MenuItem = styled.div<{ isActive: boolean }>`
  padding: 16px;
  position: relative;

  &:active {
    background-color: ${theme.primary[100]};
  }

  &::before {
    content: '';
    display: ${(props) => (props.isActive ? 'block' : 'none')};
    position: absolute;
    left: -5px;
    top: 50%;
    transform: translateY(-50%);
    width: 12px;
    height: 8px;
    background-color: ${theme.primary[500]};
    border-radius: 99px;
  }
`;

const MenuButton = styled.button`
  position: fixed;
  z-index: ${ELEVATIONS.button};
  border: none;
  padding: 0;
  color: ${theme.primary[500]};
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
  box-shadow: 0px 2px 8px rgba(0, 0, 0, 0.2);
  top: 8px;
  right: 8px;

  &:active {
    opacity: 0.7;
  }

  ${mobileOnly}
`;

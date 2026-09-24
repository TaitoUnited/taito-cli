import { useState } from 'react';
import styled from '@emotion/styled';
import { FiMenu, FiBookOpen } from 'react-icons/fi';
import { theme } from '../../theme';
import { withBase } from '../../utils/withBase';
import { BREAKPOINTS } from '../../constants/site';

const MENU_WIDTH = 'min(360px, 80vw)';
const MENU_CLOSE_MS = 400;
const ELEVATIONS = { menu: 3, backdrop: 2, button: 1 };

export interface DrawerItemData {
  to: string;
  label: string;
  active?: boolean;
}

const ICONS = { menu: FiMenu, book: FiBookOpen };

interface Props {
  items: DrawerItemData[];
  buttonPosition?: 'top-right' | 'bottom-right';
  buttonIcon?: keyof typeof ICONS;
}

export default function Drawer({
  items,
  buttonPosition = 'top-right',
  buttonIcon = 'menu',
}: Props) {
  const [isOpen, setIsOpen] = useState(false);
  const Icon = ICONS[buttonIcon];

  return (
    <>
      <MenuButton
        position={buttonPosition}
        onClick={() => setIsOpen(true)}
        aria-label="Open menu"
      >
        <Icon />
      </MenuButton>

      <Backdrop isVisible={isOpen} onClick={() => setIsOpen(false)} />

      <Menu isOpen={isOpen}>
        {items.map((item) => (
          <MenuItem
            key={item.to}
            href={withBase(item.to)}
            isActive={!!item.active}
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
  width: ${MENU_WIDTH};
  display: flex;
  flex-direction: column;
  box-shadow: 0px 0px 12px rgba(0, 0, 0, 0.5);
  will-change: transform;
  transform: translateX(
    ${(props) => (props.isOpen ? '0' : 'calc(-100% - 10px)')}
  );
  transition: transform ${MENU_CLOSE_MS}ms cubic-bezier(0.2, 0.71, 0.14, 0.91);
  background-color: #fff;
  ${mobileOnly}
`;

const MenuItem = styled.a<{ isActive: boolean }>`
  padding: 16px;
  position: relative;
  color: inherit;
  text-decoration: none;

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

const MenuButton = styled.button<{ position: 'top-right' | 'bottom-right' }>`
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
  ${(props) =>
    props.position === 'bottom-right'
      ? 'bottom: 24px; right: 8px;'
      : 'top: 8px; right: 8px;'}

  &:active {
    opacity: 0.7;
  }

  ${mobileOnly}
`;

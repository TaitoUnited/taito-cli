import { Link } from 'gatsby';
import styled from '@emotion/styled';
import { desktopOnly } from '../utils';

const Sidemenu = styled.div`
  width: 320px;
  height: 100%;
  border-right: 1px solid ${props => props.theme.grey[300]};
  display: flex;
  flex-direction: column;
  padding: 16px 0px 16px 24px;
  flex: none;
  ${desktopOnly}
`;

const SidemenuItem = styled(Link)`
  margin-left: -24px;
  padding: 8px 16px 8px 24px;
  text-decoration: none;
  color: #222;
  position: relative;

  &::before {
    content: '';
    display: ${props => (props.isActive ? 'block' : 'none')};
    position: absolute;
    left: -5px;
    top: 50%;
    transform: translateY(-50%);
    width: 20px;
    height: 8px;
    background-color: ${props => props.theme.primary[500]};
    border-radius: 99px;
  }

  &::after {
    display: ${props => (!props.isActive ? 'block' : 'none')};
    font-size: 16px;
    color: ${props => props.theme.primary[500]};
    position: absolute;
    right: 12px;
    top: 50%;
    transform: translateY(-50%);
  }

  &:hover {
    background-color: ${props => props.theme.primary[100]};
    color: ${props => props.theme.primary[700]};

    &::after {
      content: '›';
    }
  }

  ${desktopOnly}
`;

Sidemenu.Item = SidemenuItem;

export default Sidemenu;

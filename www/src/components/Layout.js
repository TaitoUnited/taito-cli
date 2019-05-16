import styled from '@emotion/styled';
import { responsivify } from '../utils';

const Box = styled.div`
  flex: 1;
  ${responsivify('flex', 'flex')}
`;

const Layout = styled.div`
  display: flex;
  width: 100%;
  ${responsivify('dir', 'flex-direction', { col: 'column', row: 'row' })}
`;

Layout.Box = Box;

export default Layout;
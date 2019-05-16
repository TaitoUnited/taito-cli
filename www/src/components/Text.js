import styled from '@emotion/styled';
import { responsivify } from '../utils';

const Text = styled.span`
  margin: 0;
  padding: 0;
  font-family: 'Raleway', sans-serif;
  font-size: ${props => props.size || 16}px;
  font-weight: ${props => props.weight || 400};
  color: ${props => props.color || props.theme.black};
  line-height: ${props => props.lineh || 1.5};
  ${responsivify('size', 'font-size')}
`;

export default Text;

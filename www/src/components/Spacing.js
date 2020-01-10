import styled from '@emotion/styled';
import { media } from '../utils';

const DEFAULT_PAD = 16;

const getWidthOrHeight = dir => {
  switch (dir) {
    case 'x':
      return 'width';
    case 'y':
      return 'height';
    default:
      return 'width';
  }
};

const getDim = props => {
  const amount = props.amount || DEFAULT_PAD;
  return `${getWidthOrHeight(props.dir)}: ${amount}px;`;
};

const getMediaDim = (props, { dir, amount: mAmount }) => {
  const amount = mAmount || props.amount || DEFAULT_PAD;
  return `${getWidthOrHeight(dir || props.dir)}: ${amount}px;`;
};

const Spacing = styled.div`
  height: 0px;
  ${props => getDim(props)}
  ${props => props.sm && media.sm`${getMediaDim(props, props.sm)}`}
  ${props => props.md && media.md`${getMediaDim(props, props.md)}`}
  ${props => props.lg && media.lg`${getMediaDim(props, props.lg)}`}
`;

export default Spacing;

import styled from '@emotion/styled';

const sizes = { h1: 48, h2: 32, h3: 24, h4: 18 };
const weights = { h1: 900, h2: 900, h3: 400, h4: 400 };

const Heading = styled.h1`
  font-size: ${props => sizes[props.as] || sizes.h1}px;
  font-family: 'Raleway', sans-serif;
  font-weight: ${props => weights[props.weight] || 900};
  margin: 0;
  text-align: ${props => props.align || 'left'};
  color: ${props => props.color || props.theme.black};
`;

export default Heading;

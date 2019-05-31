import React from 'react';
import styled from '@emotion/styled';
import { useTrail, animated } from 'react-spring';

import taitoCharacterImg from '../images/taito_char_white.png';
import { useOnScreen } from '../hooks';
import { media } from '../utils';

const trailConfig = {
  mass: 5,
  tension: 3000,
  friction: 500,
};

const Terminal = ({ lines }) => {
  const ref = React.useRef();
  const [shouldAnimate, setShouldAnimate] = React.useState(false);
  const isOnScreen = useOnScreen(ref, '-100px');

  const trail = useTrail(lines.length, {
    config: trailConfig,
    delay: 500,
    opacity: shouldAnimate ? 1 : 0,
    x: shouldAnimate ? 0 : -20,
    from: { opacity: 0, x: -20 },
  });

  // Animate terminal lines when comp is inside viewport
  React.useEffect(() => {
    if (isOnScreen && !shouldAnimate) {
      setShouldAnimate(true);
    }
  }, [isOnScreen, shouldAnimate]);

  return (
    <Wrapper ref={ref}>
      <Header>
        <HeaderLogo>
          <Logo src={taitoCharacterImg} />
        </HeaderLogo>

        <HeaderButtons>
          <HeaderButton color="#ff5f56" />
          <HeaderButton color="#ffbd2e" />
          <HeaderButton color="#27c93f" />
        </HeaderButtons>
      </Header>

      <Content>
        {trail.map(({ x, ...rest }, index) => (
          <LineWrapper key={index}>
            <LineSymbol style={{ ...rest }} />
            <Line
              style={{
                ...rest,
                transform: x.interpolate(x => `translate3d(${x}px,0,0)`),
              }}
            >
              {lines[index]}
            </Line>
          </LineWrapper>
        ))}
      </Content>
    </Wrapper>
  );
};

const Wrapper = styled.div`
  background-color: ${props => props.theme.black};
  border-radius: 8px;
  width: 500px;
  min-height: 320px;
  display: flex;
  flex-direction: column;

  ${media.sm`
    width: 100%;
    min-height: 250px;
  `}
`;

const Header = styled.div`
  position: relative;
  height: 40px;
  display: flex;
  align-items: center;
`;

const HeaderButtons = styled.div`
  display: flex;
  align-items: center;
  padding: 0px 16px;
`;

const HeaderButton = styled.div`
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background-color: ${props => props.color};
  margin-right: 8px;
`;

const HeaderLogo = styled.div`
  position: absolute;
  left: 0;
  right: 0;
  top: 0;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
`;

const Logo = styled.img`
  height: 18px;
  width: auto;
`;

const Content = styled.div`
  flex: 1;
  padding: 16px;
  overflow-y: auto;
`;

const LineWrapper = styled.div`
  display: flex;
  flex-direction: row;
  align-items: baseline;
  width: 100%;
  margin-bottom: 16px;
`;

const Line = styled(animated.div)`
  flex: 1;
  color: #fff;
  will-change: transform, opacity;

  ${media.sm`
    font-size: 14px;
  `}
`;

const LineSymbol = styled(animated.div)`
  width: 0;
  height: 0;
  border-style: solid;
  border-width: 4px 0 4px 8px;
  border-color: transparent transparent transparent
    ${props => props.theme.grey[700]};
  margin-right: 12px;
`;

const TerminalLinePrefix = styled.span`
  font-weight: 700;
  margin-right: 6px;
  color: ${props => props.color || props.theme.primary[400]};
`;

const TerminalLineSuffix = styled.span`
  color: ${props => props.theme.grey[200]};
`;

Terminal.LinePrefix = TerminalLinePrefix;
Terminal.LineSuffix = TerminalLineSuffix;

export default Terminal;

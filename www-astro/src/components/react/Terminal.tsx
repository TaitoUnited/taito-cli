import { useEffect, useRef, useState } from 'react';
import styled from '@emotion/styled';
import { animated, useTrail } from '@react-spring/web';
import taitoCharacterImg from '../../assets/taito_char_white.png';
import { useOnScreen } from '../../hooks/useOnScreen';
import { theme } from '../../theme';

const trailConfig = {
  mass: 5,
  tension: 3000,
  friction: 500,
};

export type TerminalLine =
  { prefix: string; prefixColor?: string; suffix?: string } | { text: string };

interface Props {
  lines: TerminalLine[];
}

const lineKey = (line: TerminalLine) =>
  'prefix' in line ? `${line.prefix}:${line.suffix ?? ''}` : line.text;

export default function Terminal({ lines }: Props) {
  const ref = useRef<HTMLDivElement>(null);
  const [shouldAnimate, setShouldAnimate] = useState(false);
  const isOnScreen = useOnScreen(ref, '-100px');

  const trail = useTrail(lines.length, {
    config: trailConfig,
    delay: 500,
    opacity: shouldAnimate ? 1 : 0,
    x: shouldAnimate ? 0 : -20,
    from: { opacity: 0, x: -20 },
  });

  useEffect(() => {
    if (isOnScreen && !shouldAnimate) {
      setShouldAnimate(true);
    }
  }, [isOnScreen, shouldAnimate]);

  return (
    <Wrapper ref={ref}>
      <Header>
        <HeaderLogo>
          <Logo src={taitoCharacterImg.src} alt="" />
        </HeaderLogo>

        <HeaderButtons>
          <HeaderButton color="#ff5f56" />
          <HeaderButton color="#ffbd2e" />
          <HeaderButton color="#27c93f" />
        </HeaderButtons>
      </Header>

      <Content>
        {trail.map(({ x, ...rest }, index) => {
          const line = lines[index];
          return (
            <LineWrapper key={lineKey(line)}>
              <LineSymbol style={{ ...rest }} />
              <Line
                style={{
                  ...rest,
                  transform: x.to((v) => `translate3d(${v}px,0,0)`),
                }}
              >
                {'prefix' in line ? (
                  <>
                    <LinePrefix color={line.prefixColor}>
                      {line.prefix}
                    </LinePrefix>
                    {line.suffix !== undefined && (
                      <LineSuffix>{line.suffix}</LineSuffix>
                    )}
                  </>
                ) : (
                  <span>{line.text}</span>
                )}
              </Line>
            </LineWrapper>
          );
        })}
      </Content>
    </Wrapper>
  );
}

const Wrapper = styled.div`
  background-color: ${theme.black};
  border-radius: 8px;
  width: 500px;
  min-height: 320px;
  display: flex;
  flex-direction: column;

  @media (max-width: 820px) {
    width: 100%;
    min-height: 250px;
  }
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

const HeaderButton = styled.div<{ color: string }>`
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background-color: ${(props) => props.color};
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

  @media (max-width: 820px) {
    font-size: 14px;
  }
`;

const LineSymbol = styled(animated.div)`
  width: 0;
  height: 0;
  border-style: solid;
  border-width: 4px 0 4px 8px;
  border-color: transparent transparent transparent ${theme.grey[700]};
  margin-right: 12px;
`;

const LinePrefix = styled.span<{ color?: string }>`
  font-weight: 700;
  margin-right: 6px;
  color: ${(props) => props.color || theme.primary[400]};
`;

const LineSuffix = styled.span`
  color: ${theme.grey[200]};
`;

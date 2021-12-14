import { css } from '@emotion/react';
import { media } from '../utils';
import theme from '../theme';

const typographyStyles = css`
  p {
    word-wrap: break-word;
  }

  h1 {
    font-size: 56px;
    margin-top: 0px;
    margin-bottom: 24px;
  }

  h2 {
    font-size: 32px;
  }

  h3 {
    font-size: 24px;
  }

  h4 {
    font-size: 18px;
  }

  h5 {
    font-size: 16px;
  }

  h1 + p {
    font-size: 24px;
    font-weight: 300;
    color: ${theme.grey[600]};
  }

  ${media.sm`
    h1 {
      font-size: 40px;
    }

    h2 {
      font-size: 28px;
    }

    h3 {
      font-size: 22px;
    }
  `}
`;

export default typographyStyles;

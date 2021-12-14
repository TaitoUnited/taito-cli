import React from 'react';
import { Global, css } from '@emotion/react';
import typographyStyles from './typography';

const GlobalStyles = () => (
  <Global
    styles={css`
      ${typographyStyles}
    `}
  />
);

export default GlobalStyles;

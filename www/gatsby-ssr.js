import 'prism-themes/themes/prism-base16-ateliersulphurpool.light.css';
import './src/index.css';

import React from 'react';
import { ThemeProvider } from '@emotion/react';

import theme from './src/theme';
import GlobalStyles from './src/styles';

export const wrapRootElement = ({ element }) => {
  return (
    <ThemeProvider theme={theme}>
      <GlobalStyles />
      {element}
    </ThemeProvider>
  );
};

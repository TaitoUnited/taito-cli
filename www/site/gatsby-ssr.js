import './src/index.css';

import React from 'react';
import { ThemeProvider } from 'emotion-theming';
import theme from './src/theme';

export const wrapRootElement = ({ element }) => {
  return <ThemeProvider theme={theme}>{element}</ThemeProvider>;
};

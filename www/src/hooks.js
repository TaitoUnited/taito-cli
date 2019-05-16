import React from 'react';
import { navigate } from 'gatsby';
import { IS_BROWSER } from './constants';

export const useForceTrailingSlash = () => {
  React.useEffect(() => {
    if (IS_BROWSER) {
      const lastIndex = window.location.pathname.length - 1;
      if (window.location.pathname[lastIndex] !== '/') {
        navigate(`${window.location.pathname}/`);
      }
    }
  }, []);
};

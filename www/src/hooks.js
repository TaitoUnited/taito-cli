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

// https://usehooks.com/useOnScreen/
export const useOnScreen = (ref, rootMargin = '0px') => {
  const [isIntersecting, setIntersecting] = React.useState(false);

  React.useEffect(() => {
    const el = ref.current;
    const observer = new IntersectionObserver(
      ([entry]) => {
        setIntersecting(entry.isIntersecting);
      },
      {
        rootMargin,
      }
    );

    if (el) observer.observe(el);

    return () => {
      observer.unobserve(el);
    };
  }, [ref, rootMargin]);

  return isIntersecting;
};

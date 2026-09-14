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

const COPY_RESET_DELAY = 2000;

// Code blocks come from Markdown as raw HTML, so the button has to be injected
// into the DOM instead of rendered by React.
export const useCodeBlockCopyButtons = (ref, html) => {
  React.useEffect(() => {
    const container = ref.current;
    if (!container) return undefined;

    const blocks = Array.from(
      container.querySelectorAll('pre[class*="language-"]')
    ).map(pre => {
      // Read before appending so that the button label cannot end up in the copy
      const code = pre.textContent.replace(/\n+$/, '');
      let resetTimeout;

      const button = document.createElement('button');
      button.type = 'button';
      button.className = 'code-copy-button';
      button.textContent = 'Copy';
      button.setAttribute('aria-label', 'Copy code to clipboard');

      const onClick = () => {
        const copied = navigator.clipboard
          ? navigator.clipboard.writeText(code)
          : Promise.reject(new Error('Clipboard API is not available'));

        copied.then(
          () => {
            button.textContent = 'Copied!';
          },
          () => {
            button.textContent = 'Copy failed';
          }
        );

        clearTimeout(resetTimeout);
        resetTimeout = setTimeout(() => {
          button.textContent = 'Copy';
        }, COPY_RESET_DELAY);
      };

      button.addEventListener('click', onClick);

      // The button is a sibling of the pre so that it does not scroll with long lines
      const wrapper = document.createElement('div');
      wrapper.className = 'code-block-wrapper';
      pre.parentNode.insertBefore(wrapper, pre);
      wrapper.appendChild(pre);
      wrapper.appendChild(button);

      return {
        wrapper,
        pre,
        button,
        onClick,
        clearReset: () => clearTimeout(resetTimeout),
      };
    });

    return () => {
      blocks.forEach(({ wrapper, pre, button, onClick, clearReset }) => {
        clearReset();
        button.removeEventListener('click', onClick);
        if (wrapper.parentNode) {
          wrapper.parentNode.insertBefore(pre, wrapper);
          wrapper.parentNode.removeChild(wrapper);
        }
      });
    };
  }, [ref, html]);
};

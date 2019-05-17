import { css } from '@emotion/core';
import { BREAKPOINTS } from './constants';

export const flattenListData = (data, key = 'allMarkdownRemark') => {
  return data[key].edges.map(
    ({ node: { fields = {}, frontmatter = {}, ...rest } }) => ({
      ...rest,
      ...fields,
      ...frontmatter,
    })
  );
};

export const flattenData = (data, key = 'markdownRemark') => {
  const { fields = {}, frontmatter = {}, ...rest } = data[key];
  return {
    ...rest,
    ...fields,
    ...frontmatter,
  };
};

export const mobileOnly = css`
  @media screen and (min-width: ${BREAKPOINTS.sm}px) {
    display: none;
  }
`;

export const desktopOnly = css`
  @media screen and (max-width: ${BREAKPOINTS.sm}px) {
    display: none;
  }
`;

export const media = {
  sm: (first, ...args) => css`
    @media screen and (max-width: ${BREAKPOINTS.sm}px) {
      ${css(first, ...args)}
    }
  `,
  md: (first, ...args) => css`
    @media screen and (min-width: ${BREAKPOINTS.sm +
        1}px) and (max-width: ${BREAKPOINTS.lg - 1}px) {
      ${css(first, ...args)}
    }
  `,
  lg: (first, ...args) => css`
    @media screen and (min-width: ${BREAKPOINTS.lg}px) {
      ${css(first, ...args)}
    }
  `,
};

const hasSizeProp = (obj, p, size) => !!(obj[p] && obj[p][size] !== undefined);

export const responsivify = (prop, cssProp, valueMap) => props => {
  const getValue = v => (valueMap ? valueMap[v] : v);

  if (typeof props[prop] === 'string') {
    return `${cssProp}: ${getValue(props[prop])};`;
  }

  return css`
    ${hasSizeProp(props, prop, 'lg') &&
      media.lg`${cssProp}: ${getValue(props[prop].lg)}`}
    ${hasSizeProp(props, prop, 'md') &&
      media.md`${cssProp}: ${getValue(props[prop].md)}`}
    ${hasSizeProp(props, prop, 'sm') &&
      media.sm`${cssProp}: ${getValue(props[prop].sm)}`}
  `;
};

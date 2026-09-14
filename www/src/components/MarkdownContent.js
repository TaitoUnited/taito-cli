import React from 'react';
import styled from '@emotion/styled';

import { useCodeBlockCopyButtons } from '../hooks';

const MarkdownContent = ({ html }) => {
  const ref = React.useRef();

  useCodeBlockCopyButtons(ref, html);

  return <Wrapper ref={ref} dangerouslySetInnerHTML={{ __html: html }} />;
};

// The copy button is injected into the Markdown HTML, so it is styled here
const Wrapper = styled.div`
  .code-block-wrapper {
    position: relative;
  }

  .code-block-wrapper:hover .code-copy-button,
  .code-copy-button:focus {
    opacity: 1;
  }

  .code-copy-button {
    position: absolute;
    top: 8px;
    right: 8px;
    padding: 4px 10px;
    min-width: 80px;
    border: 1px solid ${props => props.theme.grey[300]};
    border-radius: 2px;
    background-color: ${props => props.theme.white};
    color: ${props => props.theme.grey[700]};
    font-family: inherit;
    font-size: 12px;
    line-height: 1.5;
    cursor: pointer;
    user-select: none;
    opacity: 0;
    transition: opacity 0.15s ease, color 0.15s ease,
      border-color 0.15s ease;

    &:hover {
      border-color: ${props => props.theme.primary[500]};
      color: ${props => props.theme.primary[500]};
    }
  }

  /* Keep the button visible on touch devices, where there is no hover */
  @media (hover: none) {
    .code-copy-button {
      opacity: 1;
    }
  }
`;

export default MarkdownContent;

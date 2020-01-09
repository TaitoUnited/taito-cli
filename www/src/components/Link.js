import React from 'react';
import styled from '@emotion/styled';

const Link = ({ url, text, content, ...rest }) => (
  <Wrapper {...rest}>
    {content}
    <a href={url} alt={url}>
      {text}
    </a>
  </Wrapper>
);

const Wrapper = styled.div`
  padding-top: 10px;
`;

export default Link;

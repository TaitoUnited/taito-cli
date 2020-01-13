import React from 'react';
import { MdModeEdit } from 'react-icons/md';
import styled from '@emotion/styled';

import { IS_BROWSER } from '../constants';

const GitHubEditLink = ({ path }) => {
  const pathname = IS_BROWSER && window.location.pathname.replace(/\/+$/, '');

  const filename = path ? path : pathname;

  const url = `https://github.com/TaitoUnited/taito-cli/edit/dev/docs${filename}.md`;

  return (
    <Wrapper>
      <MdModeEdit />
      <a href={url} alt={url}>
        Edit this page on GitHub
      </a>
    </Wrapper>
  );
};

const Wrapper = styled.div`
  display: flex;
`;

export default GitHubEditLink;

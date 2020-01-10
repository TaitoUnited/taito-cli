import React from 'react';
import { MdModeEdit } from 'react-icons/md';
import styled from '@emotion/styled';

const GitHubEditLink = ({
  path = window.location.pathname.replace(/\/+$/, ''),
}) => {
  const url = `https://github.com/TaitoUnited/taito-cli/edit/dev/docs${path}.md`;

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

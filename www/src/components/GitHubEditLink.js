import React from 'react';
import { MdModeEdit } from 'react-icons/md';

const GitHubEditLink = ({
  path = window.location.pathname.replace(/\/+$/, ''),
}) => {
  const url = `https://github.com/TaitoUnited/taito-cli/edit/dev/docs/${path}.md`;

  return (
    <>
      <MdModeEdit />
      <a href={url} alt={url}>
        Edit this page on GitHub
      </a>
    </>
  );
};

export default GitHubEditLink;

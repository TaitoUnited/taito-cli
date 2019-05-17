import React from 'react';
import PropTypes from 'prop-types';
import styled from '@emotion/styled';
import { Highlight } from 'react-instantsearch-dom';
import { Link } from 'gatsby';
import { slugify } from '../../utils';

const urlWithAnchor = (slug, heading) => {
  const last = slug.length - 1;
  const url = slug[last] === '/' ? slug.substr(0, last) : slug;
  return `${url}#${slugify(heading)}`;
};

const SearchHit = ({ hit }) => {
  const { objectID, slug, pageHeading, parentHeading } = hit;
  const to = parentHeading ? urlWithAnchor(slug, parentHeading) : slug;

  return (
    <HitLink to={to} key={objectID}>
      <HitHeading>{pageHeading}</HitHeading>
      <Highlight hit={hit} attribute="content" tagName="mark" />
    </HitLink>
  );
};

const HitLink = styled(Link)`
  text-decoration: none;
  color: #222;
  display: flex;
  flex-direction: column;
  border-bottom: 1px solid ${props => props.theme.grey[300]};
  padding-bottom: 8px;

  &:hover {
    background-color: ${props => props.theme.primary[100]};
  }
`;

const HitHeading = styled.div`
  padding: 3px 6px;
  background-color: ${props => props.theme.primary[500]};
  color: #fff;
  font-weight: 700;
  font-size: 14px;
  width: fit-content;
  border-radius: 4px;
  margin-bottom: 4px;
`;

SearchHit.propTypes = {
  content: PropTypes.string.isRequired,
  objectID: PropTypes.string.isRequired,
  slug: PropTypes.string.isRequired,
  pageHeading: PropTypes.string,
  parentHeading: PropTypes.string,
};

export default SearchHit;

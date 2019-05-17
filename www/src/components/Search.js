import React from 'react';
import PropTypes from 'prop-types';
import styled from '@emotion/styled';
import algoliasearch from 'algoliasearch/lite';
import { FaAlgolia } from 'react-icons/fa';
import { Link } from 'gatsby';

import {
  InstantSearch,
  SearchBox,
  Hits,
  Highlight,
} from 'react-instantsearch-dom';

import { slugify } from '../utils';

const searchClient = algoliasearch(
  process.env.GATSBY_ALGOLIA_APP_ID,
  process.env.GATSBY_ALGOLIA_SEARCH_KEY
);

const Search = () => {
  const wrapperRef = React.useRef();
  const [hitsVisible, setHitsVisible] = React.useState(false);

  React.useEffect(() => {
    function handleClickOutside(event) {
      if (wrapperRef.current && !wrapperRef.current.contains(event.target)) {
        setHitsVisible(false);
      }
    }

    document.addEventListener('mousedown', handleClickOutside);
    document.addEventListener('touchstart', handleClickOutside);

    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
      document.removeEventListener('touchstart', handleClickOutside);
    };
  }, [wrapperRef]);

  function onUpdateState() {
    if (!hitsVisible) {
      setHitsVisible(true);
    }
  }

  return (
    <InstantSearch
      searchClient={searchClient}
      indexName="taitocli"
      root={{ Root: SearchWrapper, props: { ref: wrapperRef } }}
      onSearchStateChange={onUpdateState}
    >
      <SearchBox />
      {hitsVisible && (
        <HitWrapper>
          <Hits hitComponent={SearchHit} />
          <By>
            Powered by{' '}
            <a href="https://www.algolia.com">
              <FaAlgolia size={16} /> Algolia
            </a>
          </By>
        </HitWrapper>
      )}
    </InstantSearch>
  );
};



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

const SearchWrapper = styled.div`
  position: relative;
`;

const HitWrapper = styled.div`
  position: absolute;
  top: 40px;
  right: 0px;
  width: 400px;
  max-height: 400px;
  overflow-y: auto;
  background-color: #fff;
  border-radius: 4px;
  box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.2);

  ul {
    list-style: none !important;
    padding: 0 !important;
    margin: 0 !important;

    li {
      margin-bottom: 8px;
    }
  }
`;

const HitHeading = styled.div`
  padding: 4px;
  background-color: #222;
  color: #fff;
  font-weight: 500;
  font-size: 14px;
  margin: 0px -16px 4px -16px;
`;

const HitLink = styled(Link)`
  text-decoration: none;
  color: #222;
  padding: 0px 16px;
  display: block;
`;

const By = styled.div`
  font-size: 12px;
  color: #222;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  width: 100%;
`;

SearchHit.propTypes = {
  content: PropTypes.string.isRequired,
  objectID: PropTypes.string.isRequired,
  slug: PropTypes.string.isRequired,
  pageHeading: PropTypes.string,
  parentHeading: PropTypes.string,
};

export default Search;

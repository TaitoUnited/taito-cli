import React from 'react';
import styled from '@emotion/styled';
import algoliasearch from 'algoliasearch/lite';
import { FaAlgolia } from 'react-icons/fa';

import {
  InstantSearch,
  Hits,
  connectStateResults,
} from 'react-instantsearch-dom';

import { media } from '../../utils';
import Spacing from '../Spacing';
import SearchInput from './SearchInput';
import SearchHit from './SearchHit';

const searchClient = algoliasearch(
  process.env.GATSBY_ALGOLIA_APP_ID,
  process.env.GATSBY_ALGOLIA_SEARCH_KEY
);

const Search = () => {
  const wrapperRef = React.useRef();
  const [focused, setFocused] = React.useState(false);
  const [query, setQuery] = React.useState('');

  React.useEffect(() => {
    function handleClickOutside(event) {
      if (wrapperRef.current && !wrapperRef.current.contains(event.target)) {
        setFocused(false);
      }
    }

    document.addEventListener('mousedown', handleClickOutside);
    document.addEventListener('touchstart', handleClickOutside);

    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
      document.removeEventListener('touchstart', handleClickOutside);
    };
  }, [wrapperRef]);

  return (
    <InstantSearch
      searchClient={searchClient}
      indexName="taitocli"
      root={{ Root: SearchWrapper, props: { ref: wrapperRef } }}
      onSearchStateChange={({ query }) => setQuery(query)}
    >
      <SearchInput onFocus={() => setFocused(true)} />

      {focused && !!query && (
        <HitWrapper>
          <HitResults>
            <Hits hitComponent={SearchHit} />
          </HitResults>

          <PoweredBy>
            Powered by
            <Spacing amount={4} />
            <FaAlgolia size={16} />
            <Spacing amount={4} />
            <a href="https://www.algolia.com">Algolia</a>
          </PoweredBy>
        </HitWrapper>
      )}
    </InstantSearch>
  );
};

const HitResults = connectStateResults(
  ({ searchState: state, searchResults: res, children }) =>
    res && res.nbHits ? children : `No results for ${state.query}`
);

const SearchWrapper = styled.div`
  position: relative;
  display: flex;
  align-items: center;

  ${media.sm`
    width: 100%;
  `}
`;

const HitWrapper = styled.div`
  position: absolute;
  top: 36px;
  right: 0px;
  width: 400px;
  max-height: 400px;
  overflow-y: auto;
  background-color: #fff;
  border-radius: 4px;
  padding: 12px;
  border: 4px solid #fff;
  box-shadow: 0px 4px 24px rgba(0, 0, 0, 0.4);

  ${media.sm`
    top: 48px;
    width: 100%;
    max-height: calc(80vh - 56px);
  `}

  ul {
    list-style: none !important;
    padding: 0 !important;
    margin: 0 !important;

    li {
      margin-bottom: 8px;
    }
  }
`;

const PoweredBy = styled.div`
  font-size: 12px;
  color: #222;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  width: 100%;
`;

export default Search;

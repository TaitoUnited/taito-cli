import React from 'react';
import styled from '@emotion/styled';
import { connectSearchBox } from 'react-instantsearch-dom';
import { FiSearch } from 'react-icons/fi';

const SearchInput = ({ refine, ...rest }) => {
  return (
    <Form>
      <FiSearch />
      <Input
        type="text"
        placeholder="Search"
        aria-label="Search"
        onChange={e => refine(e.target.value)}
        {...rest}
      />
    </Form>
  );
};

const Form = styled.form`
  display: flex;
  align-items: center;
  color: #fff;
  padding: 6px 8px;
  border-radius: 4px;
  background-color: rgba(0, 0, 0, 0.2);
`;

const Input = styled.input`
  margin-left: 8px;
  background: transparent;
  border: none;
  outline: none;
  font-size: 14px;
  color: #fff;

  &::placeholder {
    color: #ccc;
  }
`;

export default connectSearchBox(SearchInput);

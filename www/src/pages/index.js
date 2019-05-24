import React from 'react';
import styled from '@emotion/styled';
import { css } from '@emotion/core';
import { Link } from 'gatsby';

import { media } from '../utils';
import SEO from '../components/SEO';
import Gutter from '../components/Gutter';
import Navigation from '../components/Navigation';

export default () => (
  <Wrapper>
    <SEO />

    <Navigation isHome />

    <Hero>
      <Title>
        <strong>Taito</strong>
        &nbsp;CLI
      </Title>

      <Gutter dir="vertical" />
      <Slogan>An extensible toolkit for DevOps and NoOps.</Slogan>
      <Gutter dir="vertical" amount={24} />

      <Actions>
        <Button to="/docs">Get started</Button>
        <Gutter amount={32} sm={{ amount: 16 }} />
        <Button to="/tutorial" variant="light">
          See the tutorial
        </Button>
      </Actions>
    </Hero>

    <Content>
      <Section>
        <SectionTitle>Standard command set</SectionTitle>
        <p>
          Use the same simple command set from project to project no matter the
          technology or infrastructure. Easily manage your containers,
          functions, databases, object storages, and legacy applications
          wherever they are deployed. Just add a taito configuration file to
          your project, and you’re good to go.
        </p>
      </Section>

      <Divider />

      <Section>
        <SectionTitle>Preconfigured templates</SectionTitle>
        <p>
          Use preconfigured templates to set up your infrastructure and to
          deploy new projects on top of it. Everything works out-of-the-box with
          minimal configuration.
        </p>
      </Section>

      <Divider />

      <Section>
        <SectionTitle>Simple to use</SectionTitle>
        <p>To connect to the test database, you write this:</p>
      </Section>

      <Divider />

      <Section>
        <SectionTitle>Modern CI/CD</SectionTitle>
        <p>
          Taito CLI is shipped as a Docker container, and it is a good fit with
          modern container-based CI/CD pipelines.
        </p>
      </Section>

      <Divider />

      <Section>
        <SectionTitle>No lock-in</SectionTitle>
        <p>
          Taito CLI is a lightweight wrapper that reduces technology and vendor
          lock-in by providing a standard command set on top of various tools.
          However, you can use those tools also directly without Taito CLI, and
          therefore you can stop using Taito CLI at any time, if you like.
        </p>
      </Section>

      <Divider />

      <Section>
        <SectionTitle>All tools included</SectionTitle>
        <p>
          Working with modern hybrid cloud environments requires lots of tools.
          Taito CLI Docker container image contains all the tools you need, and
          you can upgrade it anytime by running:
        </p>
        <div>CODE HERE</div>
        <p>
          And if you need something special, it is very easy to customize the
          Taito CLI image with your own requirements.
        </p>
      </Section>
    </Content>
  </Wrapper>
);

const Wrapper = styled.div`
  width: 100%;
  height: 100%;

  & p {
    line-height: 1.5;
  }
`;

const Hero = styled.div`
  padding-top: 50px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  height: 400px;
  background-color: ${props => props.theme.primary[500]};

  ${media.sm`
    height: auto;
    padding: 88px 16px 32px 16px;
    justify-content: flex-end;
    text-align: center;
  `}
`;

const Title = styled.h1`
  font-size: 48px;
  font-weight: 200;
  color: #fff;
  margin: 0px;

  ${media.sm`
    font-size: 32px;
  `}
`;

const Slogan = styled.h2`
  font-size: 20px;
  font-weight: 400;
  color: #fff;
  margin: 0;

  ${media.sm`
    font-size: 18px;
  `}
`;

const Actions = styled.div`
  display: flex;
  flex-direction: row;
`;

const Button = styled(Link)`
  padding: 8px 24px;
  background-color: ${props => props.theme.primary[300]};
  color: ${props => props.theme.primary[900]};
  text-align: center;
  text-decoration: none;
  border: none;
  border-radius: 99px;
  font-weight: 500;
  box-shadow: 0px 2px 12px rgba(0, 0, 0, 0.2);

  ${props =>
    props.variant === 'light' &&
    css`
      background-color: #fff;
      color: ${props => props.theme.primary[500]};
    `}
`;

const Content = styled.div`
  max-width: 900px;
  background-color: #fff;
  border-radius: 8px;
  padding: 23px;
  min-height: 100vh;
  box-shadow: 0px 2px 12px rgba(0, 0, 0, 0.2);
  margin-top: -48px;
  margin-bottom: 32px;
  margin-right: auto;
  margin-left: auto;

  ${media.sm`
    padding: 16px;
    margin-top: 0px;
    box-shadow: none;
  `}
`;

const Section = styled.section`
  display: flex;
  flex-direction: column;
`;

const Divider = styled.div`
  background-color: ${props => props.theme.grey[200]};
  height: 1px;
  width: 100%;
  margin: 56px 0px;

  ${media.sm`
    margin: 32px 0px;
  `}
`;

const SectionTitle = styled.h3`
  font-size: 18px;
  color: ${props => props.theme.black};
`;

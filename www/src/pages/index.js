import React from 'react';
import styled from '@emotion/styled';
import { css } from '@emotion/core';
import { Link } from 'gatsby';

import theme from '../theme';
import { media } from '../utils';
import SEO from '../components/SEO';
import Gutter from '../components/Gutter';
import Navigation from '../components/Navigation';
import Terminal from '../components/Terminal';

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
        <SectionText>
          <SectionTitle>Standard command set</SectionTitle>
          <p>
            Use the same simple command set from project to project no matter
            the technology or infrastructure. Easily manage your containers,
            functions, databases, object storages, and legacy applications
            wherever they are deployed. Just add a taito configuration file to
            your project, and you’re good to go.
          </p>
        </SectionText>

        <Gutter amount={24} sm={{ dir: 'vertical', amount: 32 }} />

        <Terminal
          lines={[
            [
              <Terminal.LinePrefix>taito</Terminal.LinePrefix>,
              <Terminal.LineSuffix>status:test</Terminal.LineSuffix>,
            ],
            [
              <Terminal.LinePrefix>taito</Terminal.LinePrefix>,
              <Terminal.LineSuffix>open client:test</Terminal.LineSuffix>,
            ],
            [
              <Terminal.LinePrefix>taito</Terminal.LinePrefix>,
              <Terminal.LineSuffix>logs:server:test</Terminal.LineSuffix>,
            ],
            [
              <Terminal.LinePrefix>taito</Terminal.LinePrefix>,
              <Terminal.LineSuffix>db copy:dev test</Terminal.LineSuffix>,
            ],
            [
              <Terminal.LinePrefix>taito</Terminal.LinePrefix>,
              <Terminal.LineSuffix>db connect:test</Terminal.LineSuffix>,
            ],
          ]}
        />
      </Section>

      <Divider />

      <Section>
        <SectionText>
          <SectionTitle>Multicloud, on any platform</SectionTitle>
          <p>
            Deploy your applications to multiple platforms without any extra
            hassle. Leverage public cloud for fluent collaboration between
            in-house and external personnel during development. Deploy to
            on-premises to meet the extra security requirements of a production
            environment.
          </p>
        </SectionText>

        <Gutter amount={24} sm={{ dir: 'vertical', amount: 32 }} />

        <Terminal
          lines={[
            [
              <Terminal.LinePrefix>taito</Terminal.LinePrefix>,
              <Terminal.LineSuffix>zone create: gcp</Terminal.LineSuffix>,
            ],
            [
              <Terminal.LinePrefix>taito</Terminal.LinePrefix>,
              <Terminal.LineSuffix>zone create: vmware</Terminal.LineSuffix>,
            ],
            [
              <Terminal.LinePrefix>taito</Terminal.LinePrefix>,
              <Terminal.LineSuffix>
                project create: full-stack
              </Terminal.LineSuffix>,
            ],
            [
              <Terminal.LinePrefix>taito</Terminal.LinePrefix>,
              <Terminal.LineSuffix>env apply:dev</Terminal.LineSuffix>,
            ],
            [
              <Terminal.LinePrefix>taito</Terminal.LinePrefix>,
              <Terminal.LineSuffix>env apply:canary</Terminal.LineSuffix>,
            ],
            [
              <Terminal.LinePrefix>taito</Terminal.LinePrefix>,
              <Terminal.LineSuffix>env apply:prod</Terminal.LineSuffix>,
            ],
          ]}
        />
      </Section>

      <Divider />

      <Section>
        <SectionText>
          <SectionTitle>Simple to use</SectionTitle>
          <p>
            Many daily tasks, such as connecting to a database, can be extremely
            tedious. Before actually connecting to the database, you have to
            locate the correct database cluster and the correct database in it.
            You may also have to start a proxy for establishing a secure
            connection, and to retrieve credentials from somewhere for database
            access.
          </p>
          <p>
            With Taito CLI you achieve all this with a one simple command.
          </p>
        </SectionText>

        <Gutter amount={24} sm={{ dir: 'vertical', amount: 32 }} />

        <Terminal
          lines={[
            [
              <Terminal.LinePrefix>taito</Terminal.LinePrefix>,
              <Terminal.LineSuffix>db connect:test</Terminal.LineSuffix>,
            ],
            [
              <Terminal.LinePrefix color={theme.grey[500]}>
                #
              </Terminal.LinePrefix>,
              <Terminal.LineSuffix>
                Without Taito CLI:
              </Terminal.LineSuffix>,
            ],
            [
              <Terminal.LinePrefix color={theme.info}>
                cloud_sql_proxy
              </Terminal.LinePrefix>,
              <Terminal.LineSuffix>
                -instances=acme-zone:europe-west1:acme-postgres=tcp:0.0.0.0:5001
              </Terminal.LineSuffix>,
            ],
            [
              <Terminal.LinePrefix color={theme.info}>
                psql
              </Terminal.LinePrefix>,
              <Terminal.LineSuffix>
                psql -h 127.0.0.1 -p 5001 -d acme_chat_test -U acme_chat_test
              </Terminal.LineSuffix>,
            ],
            [
              <Terminal.LinePrefix color={theme.info}>
                output: Password:
              </Terminal.LinePrefix>,
              <Terminal.LineSuffix>
                ******************
              </Terminal.LineSuffix>,
            ],
          ]}
        />
      </Section>

      <Divider />

      <Section>
        <SectionText>
          <SectionTitle>No lock-in</SectionTitle>
          <p>
            Taito CLI is a lightweight wrapper that reduces technology and
            vendor lock-in by providing a standard command set on top of various
            platform specific tools. You just run a simple taito command, and
            Taito CLI runs a number of not-so-simple commands under the hood
            based on your configuration.
          </p>
          <p>
            However, you can use all those tools also directly without Taito
            CLI, and therefore you can stop using Taito CLI at any time, if you
            like. There is no lock-in with Taito CLI.
          </p>
        </SectionText>

        <Gutter amount={24} sm={{ dir: 'vertical', amount: 32 }} />

        <Terminal
          lines={[
            [
              <Terminal.LinePrefix>taito</Terminal.LinePrefix>,
              <Terminal.LineSuffix>--verbose status:dev</Terminal.LineSuffix>,
            ],
            [
              <Terminal.LinePrefix color={theme.info}>
                output: kubectl
              </Terminal.LinePrefix>,
              <Terminal.LineSuffix>
                config use-context acme-chat-dev
              </Terminal.LineSuffix>,
            ],
            [
              <Terminal.LinePrefix color={theme.info}>
                output: kubectl
              </Terminal.LinePrefix>,
              <Terminal.LineSuffix>get cronjobs</Terminal.LineSuffix>,
            ],
            [
              <Terminal.LinePrefix color={theme.info}>
                output: kubectl
              </Terminal.LinePrefix>,
              <Terminal.LineSuffix>get pods</Terminal.LineSuffix>,
            ],
            [
              <Terminal.LinePrefix color={theme.info}>
                output: kubectl
              </Terminal.LinePrefix>,
              <Terminal.LineSuffix>top pod</Terminal.LineSuffix>,
            ],
            [
              <Terminal.LinePrefix color={theme.info}>
                output: helm
              </Terminal.LinePrefix>,
              <Terminal.LineSuffix>
                list --namespace acme-chat-dev
              </Terminal.LineSuffix>,
            ],
          ]}
        />
      </Section>

      <Divider />

      <Section>
        <SectionText>
          <SectionTitle>All tools included</SectionTitle>
          <p>
            Working with modern hybrid cloud environments requires lots of
            tools. Taito CLI Docker container image contains all the tools you
            need, and you can upgrade it anytime by running:
          </p>
          <InlineCode>taito upgrade</InlineCode>
          <p>
            And if you need something special, it is very easy to customize the
            Taito CLI image with your own requirements.
          </p>
        </SectionText>

        <Gutter amount={24} sm={{ dir: 'vertical', amount: 32 }} />

        <Terminal
          lines={[
            [
              <Terminal.LinePrefix>taito</Terminal.LinePrefix>,
              <Terminal.LineSuffix>-- terraform apply</Terminal.LineSuffix>,
            ],
            [
              <Terminal.LinePrefix>taito</Terminal.LinePrefix>,
              <Terminal.LineSuffix>
                -- kubectl get pods --namespace acme-chat-dev
              </Terminal.LineSuffix>,
            ],
            [
              <Terminal.LinePrefix>taito</Terminal.LinePrefix>,
              <Terminal.LineSuffix>
                -- gcloud dns managed-zones list
              </Terminal.LineSuffix>,
            ],
            [
              <Terminal.LinePrefix>taito</Terminal.LinePrefix>,
              <Terminal.LineSuffix>
                -- aws ec2 describe-instances
              </Terminal.LineSuffix>,
            ],
          ]}
        />
      </Section>

      <Divider />

      <Section>
        <SectionText>
          <SectionTitle>Extensible</SectionTitle>
          <p>
            Add Taito CLI support for any technology by implementing a Taito CLI
            plugin. Create custom commands and share them with your colleagues
            as Taito CLI extensions. Implement project specific Taito CLI
            commands with npm or make.
          </p>
        </SectionText>

        <Gutter amount={24} sm={{ dir: 'vertical', amount: 32 }} />

        <Terminal
          lines={[
            [
              <Terminal.LinePrefix>taito</Terminal.LinePrefix>,
              <Terminal.LineSuffix>
                order pizza: quattro stagioni
              </Terminal.LineSuffix>,
            ],
            [
              <Terminal.LinePrefix>taito</Terminal.LinePrefix>,
              <Terminal.LineSuffix>hours add: 6.5</Terminal.LineSuffix>,
            ],
          ]}
        />
      </Section>

      <Divider />

      <Section>
        <SectionText>
          <SectionTitle>Uniform conventions</SectionTitle>
          <p>
            Maintain good and uniform conventions by providing reusable
            infrastructure and project templates.
          </p>
          <p>
            Customize software development workflows for your organization with
            custom Taito CLI extensions.
          </p>
        </SectionText>

        <Gutter amount={24} sm={{ dir: 'vertical', amount: 32 }} />

        <Terminal
          lines={[
            [
              <Terminal.LinePrefix color={theme.info}>
                nano
              </Terminal.LinePrefix>,
              <Terminal.LineSuffix>
                ~/.taito/taito-config.sh
              </Terminal.LineSuffix>,
            ],
            <span>
              output: taito_global_extensions="git@github.com:MyOrg/myorg-extension.git"
            </span>,
            <span>output: taito_global_plugins="myorg-git-global ..."</span>,
          ]}
        />
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
  max-width: 1100px;
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
  flex-direction: row;

  ${media.sm`
    flex-direction: column;
    align-items: center;
  `}
`;

const Divider = styled.div`
  background-color: ${props => props.theme.grey[200]};
  height: 1px;
  width: 100%;
  margin: 64px 0px;

  ${media.sm`
    margin: 32px 0px;
  `}
`;

const SectionTitle = styled.h3`
  font-size: 24px;
  margin-top: 0px;
  margin-bottom: 16px;
  color: ${props => props.theme.black};
`;

const SectionText = styled.div`
  flex: 1;
`;

const InlineCode = styled.div`
  border-radius: 6px;
  background-color: ${props => props.theme.grey[200]};
  color: ${props => props.theme.grey[700]};
  padding: 8px 12px;
  font-family: Consolas, Menlo, Monaco, 'Andale Mono WT', 'Andale Mono',
    'Lucida Console', 'Lucida Sans Typewriter', 'DejaVu Sans Mono',
    'Bitstream Vera Sans Mono', 'Liberation Mono', 'Nimbus Mono L',
    'Courier New', Courier, monospace;
  font-size: 14px;
`;

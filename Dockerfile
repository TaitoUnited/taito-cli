FROM ghcr.io/taitounited/taito-cli-deps:ci
MAINTAINER Taito United <support@taitounited.fi>
LABEL fi.taitounited.taito-cli="true"

USER root

COPY . /taito-cli
WORKDIR /taito-cli
RUN ln -s /taito-cli/src/execute-command /usr/local/bin/taito
# RUN npm run verify

# NOTE: Using root user as docker.sock access is often required on CI/CD
ENTRYPOINT ["taito"]

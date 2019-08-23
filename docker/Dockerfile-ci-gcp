FROM taitounited/taito-cli-deps:ci-gcp
MAINTAINER Taito United <support@taitounited.fi>
LABEL fi.taitounited.taito-cli="true"

USER root

COPY . /taito-cli
WORKDIR /taito-cli
RUN ln -s /taito-cli/src/execute-command /usr/local/bin/taito
# RUN npm run verify

ENTRYPOINT ["taito"]

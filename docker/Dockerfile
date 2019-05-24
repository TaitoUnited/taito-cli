FROM taitounited/taito-cli-deps:latest
MAINTAINER Taito United <support@taitounited.fi>
LABEL fi.taitounited.taito-cli="true"

USER root

COPY . /taito-cli
WORKDIR /taito-cli
RUN ln -s /taito-cli/src/taito.sh /usr/local/bin/taito
# RUN npm run verify

EXPOSE 5000-6000
ENTRYPOINT ["taito"]

FROM taitounited/taito-cli-deps:latest
MAINTAINER Taito United <support@taitounited.fi>
LABEL fi.taitounited.taito-cli="true"

USER root
COPY . /taito-cli
WORKDIR /taito-cli
RUN ln -s /taito-cli/taito_impl.sh /usr/local/bin/taito

RUN npm run lint && \
    npm run compile && \
    npm run unit

EXPOSE 5000-6000
# USER taito
ENTRYPOINT ["taito"]

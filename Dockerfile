FROM taitounited/taito-cli-deps:latest
MAINTAINER Taito United <support@taitounited.fi>
LABEL fi.taitounited.taito-cli="true"

USER root
COPY . /taito-cli
WORKDIR /taito-cli
RUN ln -s /taito-cli/taito_impl.sh /usr/local/bin/taito

EXPOSE 1000-9999
# USER taito
ENTRYPOINT ["taito"]

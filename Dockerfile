FROM taitounited/taito-cli-deps:latest

COPY . /taito-cli
WORKDIR /taito-cli
RUN ln -s /taito-cli/taito_impl.sh /usr/local/bin/taito

EXPOSE 5000-6000
ENTRYPOINT ["taito"]

# TODO use fixed version of sqitch container
FROM docteurklein/sqitch:pgsql
MAINTAINER Taito United <support@taitounited.fi>

RUN apt-get clean

# Install docker (required for executing CI/CD builds on container)
# TODO replace with the docker version used by google? or even older version
# used by kubernetes?
# - https://github.com/GoogleCloudPlatform/cloud-builders/blob/master/docker/Dockerfile
# - https://stackoverflow.com/questions/44657320/which-docker-versions-will-k8s-1-7-support
# TODO later replace with a moby based docker alternative or rkt?
RUN apt-get -y update && \
    apt-get -y install apt-transport-https ca-certificates curl gnupg2 \
    software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
    $(lsb_release -cs) \
    stable"
RUN apt-get -y update && \
    apt-get -y install docker-ce

# Install docker-compose for local api/e2e testing
# TODO replace with minikube?
RUN curl -L https://github.com/docker/compose/releases/download/1.15.0/docker-compose-`uname -s`-`uname -m` \
  -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# # Install openjdk (required by sonarqube, useful for java projects also)
# # TODO install sonarqube on kubernetes cluster instead? jre is shipped with
# # sonarqube scanner so jdk is required only for developing java projects.
# RUN echo "deb http://http.debian.net/debian jessie-backports main" >> \
#   /etc/apt/sources.list
# RUN apt-get -y update && apt-get -y install -t jessie-backports openjdk-8-jdk
#
# # Install sonarqube
# # https://github.com/SonarSource/docker-sonarqube/
# # TODO install sonarqube server on kubernetes cluster instead?
# RUN apt-get -y update && \
#     apt-get -y install unzip
# ENV SONAR_VERSION=6.5 \
#     SONARQUBE_HOME=/opt/sonarqube \
#     # Database configuration
#     # Defaults to using H2
#     SONARQUBE_JDBC_USERNAME=sonar \
#     SONARQUBE_JDBC_PASSWORD=sonar \
#     SONARQUBE_JDBC_URL=
# # Http port
# EXPOSE 9000
# RUN set -x \
#     # pub   2048R/D26468DE 2015-05-25
#     #       Key fingerprint = F118 2E81 C792 9289 21DB  CAB4 CFCA 4A29 D264 68DE
#     # uid                  sonarsource_deployer (Sonarsource Deployer) <infra@sonarsource.com>
#     # sub   2048R/06855C1D 2015-05-25
#     && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys F1182E81C792928921DBCAB4CFCA4A29D26468DE \
#
#     && cd /opt \
#     && curl -o sonarqube.zip -fSL https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
#     && curl -o sonarqube.zip.asc -fSL https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip.asc \
#     && gpg --batch --verify sonarqube.zip.asc sonarqube.zip \
#     && unzip sonarqube.zip \
#     && mv sonarqube-$SONAR_VERSION sonarqube \
#     && rm sonarqube.zip*
#     # && rm -rf $SONARQUBE_HOME/bin/*
# VOLUME "$SONARQUBE_HOME/data"
# WORKDIR $SONARQUBE_HOME
# # COPY run.sh $SONARQUBE_HOME/bin/
# # ENTRYPOINT ["./bin/run.sh"]
# # RUN ln -s $SONARQUBE_HOME/bin/run.sh /usr/local/bin/sonar_run.sh
# RUN ln -s $SONARQUBE_HOME/bin/sonar.sh /usr/local/bin/sonar.sh
#
# # Install some sonarqube plugins
# # TODO install sonarqube server on kubernetes cluster instead?
# # TODO verify downloaded packages?
# RUN set -x && \
#     curl -o $SONARQUBE_HOME/extensions/plugins/sonar-javascript.jar -fSL \
#       https://sonarsource.bintray.com/Distribution/sonar-javascript-plugin/sonar-javascript-plugin-3.1.1.5128.jar
#
# # Install sonarqube scanner
# # TODO verify downloaded packages?
# ENV SONAR_SCANNER_VERSION=3.0.3.778
# RUN set -x && \
#     cd /opt && \
#     curl -o sonar-scanner.zip -fSL https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.0.3.778-linux.zip && \
#     unzip sonar-scanner.zip && \
#     mv sonar-scanner-$SONAR_SCANNER_VERSION-linux /sonar-scanner && \
#     echo "sonar.host.url=http://localhost:9000" >> \
#       /sonar-scanner/conf/sonar-scanner.properties && \
#     echo "sonar.sourceEncoding=UTF-8" >> \
#       /sonar-scanner/conf/sonar-scanner.properties
# ENV PATH=/sonar-scanner/bin/:$PATH

# Install gcloud: gcr.io/cloud-builders/gcloud --> modified for jessie
RUN mkdir /builder
WORKDIR /builder
RUN apt-get -y update && \
    apt-get -y install gcc python2.7 python-dev python-setuptools wget ca-certificates \
    # These are necessary for add-apt-respository
    software-properties-common python-software-properties && \

    # Install Git >2.0.1
    echo "deb http://ftp.us.debian.org/debian testing main contrib non-free" >> /etc/apt/sources.list \
      && apt-get update \
      && apt-get install -y git \
      && apt-get clean all \

    # Setup Google Cloud SDK (latest)
    curl https://dl.google.com/dl/ && \
    curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz | tar zxv -C /builder && \
    CLOUDSDK_PYTHON="python2.7" /builder/google-cloud-sdk/install.sh --usage-reporting=false \
        --bash-completion=false \
        --disable-installation-options && \

    # Install additional components
    /builder/google-cloud-sdk/bin/gcloud -q components install \
        alpha beta kubectl && \
    /builder/google-cloud-sdk/bin/gcloud -q components update && \

    # install crcmod:
    # https://cloud.google.com/storage/docs/gsutil/addlhelp/CRC32CandInstallingcrcmod
    easy_install -U pip && \
    pip install -U crcmod && \

    # TODO(jasonhall): These lines pin gcloud to a particular version.
    # /builder/google-cloud-sdk/bin/gcloud components update --version 137.0.0 && \
    # /builder/google-cloud-sdk/bin/gcloud config set component_manager/disable_update_check 1 && \
    # /builder/google-cloud-sdk/bin/gcloud -q components update && \

    # Clean up
    apt-get -y remove gcc python-dev python-setuptools wget && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf ~/.config/gcloud
ENV PATH=/builder/google-cloud-sdk/bin/:$PATH

# Install kubectl: gcr.io/cloud-builders/kubectl
COPY vendor/kubectl.bash /builder/kubectl.bash

# Install node.js
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get -y update && apt-get -y install nodejs build-essential

# Install helm
RUN curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get \
  > get_helm.sh
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh

# Install gcloud sql proxy
RUN curl https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 \
  > cloud_sql_proxy
RUN chmod +x cloud_sql_proxy
RUN mv cloud_sql_proxy /usr/local/bin

# Install docker gc
# RUN apt-get -y update && apt-get -y install git devscripts debhelper build-essential dh-make
# RUN git clone https://github.com/spotify/docker-gc.git
# RUN cd docker-gc
# RUN debuild --no-lintian -us -uc -b
# RUN dpkg -i ../docker-gc_0.1.0_all.deb
RUN git clone https://github.com/spotify/docker-gc.git /docker-gc
RUN echo "taitounited/taito-cli:latest" >> /etc/docker-gc-exclude
RUN echo "taitounited/taito-cli:latestsave" >> /etc/docker-gc-exclude
VOLUME /var/lib/docker-gc

# Install some misc stuff required by plugins
RUN apt-get clean
RUN apt-get -y update && apt-get -y install less telnet jq apache2-utils

# Install taito-cli
COPY . /taito-cli
WORKDIR /taito-cli
RUN ln -s /taito-cli/taito_impl.sh /usr/local/bin/taito

# Finish
EXPOSE 5000-6000
ENTRYPOINT ["taito"]

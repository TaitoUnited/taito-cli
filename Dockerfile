# TODO use fixed version of sqitch container
FROM docteurklein/sqitch:pgsql
MAINTAINER Taito United <support@taitounited.fi>

# Install docker (required for executing CI/CD builds on container)
# TODO replace with the docker version used by google? or even older version
# used by kubernetes?
# - https://github.com/GoogleCloudPlatform/cloud-builders/blob/master/docker/Dockerfile
# - https://stackoverflow.com/questions/44657320/which-docker-versions-will-k8s-1-7-support
# TODO later replace with a moby based docker alternative?
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

# Install sql proxy
RUN curl https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 \
  > cloud_sql_proxy
RUN chmod +x cloud_sql_proxy
RUN mv cloud_sql_proxy /usr/local/bin

# Install some misc stuff required by plugins
RUN apt-get -y update && apt-get -y install less telnet jq

# Install taito-cli
COPY . /taito-cli
WORKDIR /taito-cli
RUN ln -s /taito-cli/taito_impl.sh /usr/local/bin/taito

EXPOSE 5000-6000

ENTRYPOINT ["taito"]

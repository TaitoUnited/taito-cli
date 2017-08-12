# TODO use fixed version of sqitch container
FROM docteurklein/sqitch:pgsql
MAINTAINER Taito United <support@taitounited.fi>

# 1. Install docker (required for executing CI/CD builds on container)

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


# 2. Install gcloud: gcr.io/cloud-builders/gcloud --> modified for jessie

RUN mkdir /builder
WORKDIR /builder

RUN apt-get -y update && \
    apt-get -y install gcc python2.7 python-dev python-setuptools wget ca-certificates \
       # These are necessary for add-apt-respository
       software-properties-common python-software-properties && \

    # Install Git >2.0.1
    # add-apt-repository ppa:git-core/ppa && \
    # apt-get -y update && \
    # apt-get -y install git && \
    # NOTE: for jessie
    echo "deb http://ftp.us.debian.org/debian testing main contrib non-free" >> /etc/apt/sources.list \
      && apt-get update \
      && apt-get install -y git \
      && apt-get clean all \

    # Setup Google Cloud SDK (latest)
    # mkdir -p /builder && \
    # wget -qO- https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz | tar zxv -C /builder && \
    curl https://dl.google.com/dl/ && \
    curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz | tar zxv -C /builder && \
    CLOUDSDK_PYTHON="python2.7" /builder/google-cloud-sdk/install.sh --usage-reporting=false \
        --bash-completion=false \
        --disable-installation-options && \

    # Install additional components
    /builder/google-cloud-sdk/bin/gcloud -q components install \
        alpha beta kubectl && \
    /builder/google-cloud-sdk/bin/gcloud -q components update && \

    # install crcmod: https://cloud.google.com/storage/docs/gsutil/addlhelp/CRC32CandInstallingcrcmod
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

# 3. Install kubectl: gcr.io/cloud-builders/kubectl

COPY vendor/kubectl.bash /builder/kubectl.bash

# 4. Install node.js
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get -y update && apt-get -y install nodejs build-essential

# 5. Install helm
RUN curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get \
  > get_helm.sh
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh

# 6. Install sql proxy
RUN curl https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 \
  > cloud_sql_proxy
RUN chmod +x cloud_sql_proxy
RUN mv cloud_sql_proxy /usr/local/bin

# 7. Install some misc stuff required by plugins
RUN apt-get -y update && apt-get -y install less telnet jq

# 8. Install taito-cli
COPY . /taito-cli
WORKDIR /taito-cli
RUN ln -s /taito-cli/taito_impl.sh /usr/local/bin/taito

EXPOSE 5000-6000

ENTRYPOINT ["taito"]

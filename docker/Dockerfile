FROM --platform=linux/amd64 ubuntu:20.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

# Define ENVs for Localization/Globalization
ENV LANG=en_US.UTF-8

# Install tooling
RUN apt-get update && apt-get install -y \
    less \
    npm \
    wget \
    nodejs \
    locales \
    gss-ntlmssp \
    openssh-client \
    curl \
    jq \
    git \
    netcat \
    apt-transport-https \
    lsb-release \
    gnupg \
    build-essential \
    python-all \
    rlwrap  \
    vim  \
    nano \
    zip \
    unzip \
    iputils-ping \
    software-properties-common \
    libcurl4 \
    libunwind8 \
    netcat \
    libssl1.0 \
    liblttng-ust0 \
    liblog4j2-java \
    g++ \
    apache2-utils \
    ruby-full \
    zlib1g-dev \
    awscli \
    libnl-utils \
    libnl-genl-3-200 \
    libmagickwand-dev \
    libfontconfig \
    imagemagick \
    sudo \
    libssl-dev \
    libreadline-dev \
    tree \
# Install kubectl
  && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
  && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
# Install GH CLI
  && sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0 \
  && sudo apt-add-repository https://cli.github.com/packages \
  && sudo apt update \
  && sudo apt install gh \
  && apt-get clean

# Install latest terraform version
RUN TF_LATEST_VER=$(curl --silent "https://api.github.com/repos/hashicorp/terraform/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/') \
    && wget https://releases.hashicorp.com/terraform/${TF_LATEST_VER}/terraform_${TF_LATEST_VER}_linux_amd64.zip \
    && unzip terraform_${TF_LATEST_VER}_linux_amd64.zip \
    && sudo mv terraform /usr/bin/ \
    && sudo rm -rf /usr/local/bin/terraform

# copy over the start.sh script
COPY start.sh start.sh

# make the script executable
RUN chmod +x start.sh

# Updates and cleanup
RUN apt-get update -yq \
    && apt-get upgrade -yq \
    && rm -rf /var/lib/apt/lists/*

# set the entrypoint to the start.sh script
ENTRYPOINT ["./start.sh"]

FROM debian:stable-slim

# Conf Apt
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV DEBIAN_FRONTEND=noninteractive

# Install base
RUN apt-get update && \
    apt-get install -y apt-utils apt-transport-https \
    ssh openssh-server git vim locales wget unzip \
    sudo curl jq progress git vim \
    locales gnupg dnsutils tree psmisc groff \
    mariadb-client \
    python-apt python-pip python-dnspython python-botocore python-boto3 python-boto \
    ruby && \
    apt-get upgrade -y

# Install Goss
# https://github.com/aelsabbahy/goss
RUN curl -fsSL https://goss.rocks/install | sh

# Install APT repository for kubectl
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list

RUN apt-get update && \
    apt-get install -y kubectl

# Install Helm 2.14.4
RUN wget https://get.helm.sh/helm-v2.14.3-linux-amd64.tar.gz --output-document=/tmp/helm-v2.14.3-linux-amd64.tar.gz && \
    tar -zxvf /tmp/helm-v2.14.3-linux-amd64.tar.gz -C /tmp && \
    mv /tmp/linux-amd64/helm /usr/local/bin/helm && \
    rm -r tmp/linux-amd64/

# Locales config
RUN echo "en_US.UTF-8 UTF-8\nfr_FR.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

# install tfswitch && fix the version of terraform
RUN curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash && tfswitch 0.12.24

# terraforming Export existing AWS resources to Terraform style (tf, tfstate)
# https://github.com/dtan4/terraforming
RUN gem install terraforming

# Installing dependencies for hashivault ansible plugin
RUN pip install \
    awscli \
    ansible==2.8.7 \
    PyMySQL \
    ansible-modules-hashivault \
    requests

# Some directory configuration
RUN mkdir -p /usr/lib/python2.7/dist-packages/ansible/modules && \
    mkdir -p /usr/lib/python2.7/dist-packages/ansible/module_utils && \
    mkdir -p /root/.aws && \
    mkdir -p /etc/terraform && \
    mkdir -p /etc/ansible && \
    mkdir -p /var/run/sshd && \
    mkdir -p /root/.ssh && \
    ln -s /usr/local/lib/python2.7/dist-packages/ansible/modules/hashivault /usr/lib/python2.7/dist-packages/ansible/modules/hashivault && \
    ln -s /usr/local/lib/python2.7/dist-packages/ansible/module_utils/hashivault.py /usr/lib/python2.7/dist-packages/ansible/module_utils/hashivault.py

# Clean & autoremove apt
RUN apt-get autoremove --purge -y && apt-get clean

# VIM config
RUN sed -i 's/\"syntax on/syntax on/g' /etc/vim/vimrc

# SSHD config
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile
# SSH login fix. Otherwise user is kicked off after login
ENV NOTVISIBLE "in users profile"

# Root account config
COPY id_rsa.pub /root/.ssh/id_rsa.pub
COPY bashrc /root/.bashrc
COPY motd /etc/motd

RUN echo 'root:screencast' | chpasswd && \
    chmod 600 /root/.ssh && \
    touch /root/.ssh/known_hosts && \
    chmod 600 /root/.bashrc && \
    cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys

# Set TimeZone
RUN rm /etc/localtime && \
    ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime && \
    echo "Europe/Paris" > /etc/timezone

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]


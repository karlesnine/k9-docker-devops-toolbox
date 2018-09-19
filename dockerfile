FROM debian:latest

ENV DEBIAN_FRONTEND=noninteractive

# Install basic
RUN apt-get update && apt-get install -y ssh progress git vim locales python-apt python-pip python-dnspython dnsutils tree psmisc python-boto3
RUN apt-get upgrade -y

# Apt config for ansible
RUN echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" > /etc/apt/sources.list.d/ansible.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
RUN apt-get update && apt-get install -y ansible

# Locales config
RUN echo "en_US.UTF-8 UTF-8\nfr_FR.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen

# VIM config
RUN sed -i 's/\"syntax on/syntax on/g' /etc/vim/vimrc

# Git Config
RUN git config --global user.email "noway@karlesnine.com"
RUN git config --global user.name "Karles"

# SSHD config
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Root account config
RUN echo 'root:screencast' | chpasswd
RUN mkdir /root/.ssh
RUN chmod 600 /root/.ssh
RUN touch /root/.ssh/known_hosts
COPY id_rsa.pub /root/.ssh/id_rsa.pub
COPY bashrc /root/.bashrc
RUN chmod 600 /root/.bashrc
RUN cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

VOLUME /etc/ansible

# WRAPPER Init.d
RUN echo "#!/bin/bash" > /run.sh
RUN echo "/etc/init.d/ssh start" >> /run.sh
RUN echo "/etc/init.d/dbus start" >> /run.sh
RUN echo "while sleep 60; do echo hello > /dev/null; done" >> /run.sh
RUN chmod a+x /run.sh

EXPOSE 22
CMD ["/run.sh"]
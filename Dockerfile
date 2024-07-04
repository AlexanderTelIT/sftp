FROM debian:bullseye
MAINTAINER Adrian Dvergsdal [atmoz.net]
USER root
# Steps done in one RUN layer:
# - Install packages
# - OpenSSH needs /var/run/sshd to run
# - Remove generic host keys, entrypoint generates unique keys

RUN apt-get update && \
    apt-get -y install openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/sshd && \
    rm -f /etc/ssh/ssh_host_*key*

RUN chmod -R 7777 /usr/
RUN chmod -R 7777  /var/run/
RUN chmod -R 7777  /etc

COPY files/sshd_config /etc/ssh/sshd_config
COPY files/create-sftp-user /usr/local/bin/
COPY files/entrypoint/ /
COPY files/user.conf /etc/sftp/users.conf


EXPOSE 22
USER root
CMD /entrypoint

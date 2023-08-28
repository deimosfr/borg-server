FROM debian:12-slim
MAINTAINER deimosfr

RUN apt-get update && apt-get -y install openssh-server sshfs supervisor cron borgbackup && apt-get clean

RUN useradd -m borg && \
    ssh-keygen -A && \
    mkdir /backup /run/sshd && \
    chown borg. /backup && \
    sed -i \
        -e 's/^#PasswordAuthentication yes$/PasswordAuthentication no/g' \
        -e 's/^PermitRootLogin without-password$/PermitRootLogin no/g' \
        /etc/ssh/sshd_config

COPY supervisord.conf /etc/supervisor/supervisord.conf

EXPOSE 22
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

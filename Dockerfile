FROM alpine:edge
MAINTAINER teissler
RUN apk add openssh sshfs borgbackup supervisor dcron --no-cache
RUN adduser -D -u 1000 borg && \
    adduser borg wheel && \
    ssh-keygen -A && \
    mkdir /backup && \
    chown borg.borg /backup && \
    sed -i \
        -e 's/^#PasswordAuthentication yes$/PasswordAuthentication no/g' \
        -e 's/^PermitRootLogin without-password$/PermitRootLogin no/g' \
        /etc/ssh/sshd_config
COPY supervisord.conf /etc/supervisord.conf
RUN passwd -u borg
EXPOSE 22
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

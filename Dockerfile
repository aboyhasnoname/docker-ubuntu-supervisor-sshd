FROM ubuntu:16.04

MAINTAINER AzureSkyline <rg.zhu@icloud.com>

RUN apt-get update -y && \
    apt-get install -y supervisor && \
    apt-get install -y openssh-server && \
    apt-get install -y tzdata && \
    apt-get install -y cron && \
    apt-get autoclean && apt-get autoremove && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone

COPY supervisord.conf /etc/supervisor/supervisord.conf

RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/^#?Port 22/Port 43000/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

CMD ["/usr/bin/supervisord","-n", "-c", "/etc/supervisor/supervisord.conf"]

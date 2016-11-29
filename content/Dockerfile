FROM centos:centos7

USER root

ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8

RUN yum install -y epel-release \
    && yum install -y lighttpd \
    && yum clean all -y \
    && sed -i -e 's/server.port = 80/server.port = 1080/g' /etc/lighttpd/lighttpd.conf \
    && chmod -R 1777 /var/www/lighttpd

# tini setup

ENV TINI_VERSION v0.9.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc /tini.asc
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 0527A9B7 && gpg --verify /tini.asc
RUN chmod +x /tini

ENTRYPOINT ["/tini", "--"]

EXPOSE 1080

CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
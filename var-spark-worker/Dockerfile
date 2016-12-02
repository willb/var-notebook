FROM radanalyticsio/openshift-spark

USER root

RUN yum install -y centos-release-scl epel-release gcc \
    && yum-config-manager --enable rhel-server-rhscl-7-rpms \
    && yum install -y rh-python35 && yum clean all -y

RUN mkdir -p /data
ADD wikieod.parquet /data/wikieod.parquet
RUN chmod -R 1777 /data

USER 185

CMD ["scl", "enable", "rh-python35", "/opt/spark/bin/launch.sh"]
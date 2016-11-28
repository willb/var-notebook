FROM willb/var-notebook:base

ENV NB_USER=nbuser
ENV NB_UID=1011

EXPOSE 8888

ADD var.ipynb /notebooks/var.ipynb
ADD wikieod.parquet /home/$NB_USER/wikieod.parquet

USER root

RUN chown $NB_USER:root /notebooks/var.ipynb

USER $NB_UID
ENV HOME /home/$NB_USER

LABEL io.k8s.description="PySpark Jupyter Notebook with VaR calculation." \
      io.k8s.display-name="PySpark Jupyter Notebook with VaR calculation." \
      io.openshift.expose-services="8888:http"

CMD ["/start.sh"]

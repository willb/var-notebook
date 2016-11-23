FROM willb/var-notebook:base

ENV NB_USER=nbuser
ENV NB_UID=1011

EXPOSE 8888

ADD var.ipynb /notebooks/var.ipynb
ADD wikieod.parquet /wikieod.parquet

ENV HOME /home/$NB_USER

USER $NB_UID

LABEL io.k8s.description="PySpark Jupyter Notebook with VaR calculation." \
      io.k8s.display-name="PySpark Jupyter Notebook with VaR calculation." \
      io.openshift.expose-services="8888:http"

CMD ["/start.sh"]

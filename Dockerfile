# (ideally) minimal pyspark/jupyter notebook

FROM centos:centos7

## taken/adapted from jupyter dockerfiles

# Not essential, but wise to set the lang
# Note: Users with other languages should set this in their derivative image
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV PYTHONIOENCODING UTF-8
ENV CONDA_DIR /opt/conda

# Python binary and source dependencies
RUN yum install -y curl wget java-headless bzip2 gnupg2 sqlite3 \
    && yum install -y epel-release \
    && yum install -y jq \
    && yum clean all -y \
    && cd /tmp \
    && wget -q https://repo.continuum.io/miniconda/Miniconda2-4.0.5-Linux-x86_64.sh \
    && echo 42dac45eee5e58f05f37399adda45e85 Miniconda2-4.0.5-Linux-x86_64.sh | md5sum -c - \
    && bash Miniconda2-4.0.5-Linux-x86_64.sh -b -p $CONDA_DIR \
    && rm Miniconda2-4.0.5-Linux-x86_64.sh \
    && export PATH=/opt/conda/bin:$PATH \
    && yum install -y gcc gcc-c++ glibc-devel && /opt/conda/bin/conda create --quiet --yes -p $CONDA_DIR/envs/python2 ipywidgets matplotlib notebook jupyter && source /opt/conda/bin/activate /opt/conda/envs/python2 && pip install widgetsnbextension && yum erase -y gcc gcc-c++ glibc-devel && yum clean all -y && rm -rf /root/.npm && \
    rm -rf /root/.cache && \
    rm -rf /root/.config && \
    rm -rf /root/.local && \
    rm -rf /root/tmp && \
    conda remove --quiet --yes --force qt pyqt && \
    conda clean -tipsy

ENV PATH /opt/conda/bin:$PATH

# Move notebook contents into place.
# ADD . /usr/src/jupyter-notebook

ENV APACHE_SPARK_VERSION 2.0.1
RUN cd /tmp && \
        wget -q http://d3kbcqa49mib13.cloudfront.net/spark-${APACHE_SPARK_VERSION}-bin-hadoop2.7.tgz && \
        echo "43aa7c28b9670e65cb4f395000838860 *spark-${APACHE_SPARK_VERSION}-bin-hadoop2.7.tgz" | md5sum -c - && \
        tar xzf spark-${APACHE_SPARK_VERSION}-bin-hadoop2.7.tgz -C /usr/local && \
        rm spark-${APACHE_SPARK_VERSION}-bin-hadoop2.7.tgz && \
	cd /usr/local && ln -s spark-${APACHE_SPARK_VERSION}-bin-hadoop2.7 spark

ENV SPARK_HOME /usr/local/spark
ENV PYTHONPATH $SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.1-src.zip
ENV SPARK_OPTS --driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info

# Add a notebook profile.
RUN mkdir -p -m 700 /root/.jupyter/ && \
    echo "c.NotebookApp.ip = '*'" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.open_browser = False" >> /root/.jupyter/jupyter_notebook_config.py

VOLUME /notebooks
WORKDIR /notebooks

# tini setup

ENV TINI_VERSION v0.9.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc /tini.asc
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 0527A9B7 && gpg --verify /tini.asc
RUN chmod +x /tini

ENTRYPOINT ["/tini", "--"]

EXPOSE 8888

ADD start.sh /start.sh
ADD var.ipynb /notebooks/var.ipynb
# ADD wikieod.parquet /wikieod.parquet

# RUN jq --arg v "$CONDA_DIR/envs/python2/bin/python" \
#        '.["env"]["PYSPARK_PYTHON"]=$v' \
#        $CONDA_DIR/share/jupyter/kernels/python2/kernel.json > /tmp/kernel.json && \
#        mv /tmp/kernel.json $CONDA_DIR/share/jupyter/kernels/python2/kernel.json

CMD ["/start.sh"]
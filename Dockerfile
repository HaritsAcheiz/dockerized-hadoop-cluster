FROM apache/hadoop:3.4

USER root

# Set environment variables
ENV SPARK_VERSION=3.4.3
ENV JUPYTER_VERSION=4.2.5

# Download and install Spark
RUN wget https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz \
    && tar -xvzf spark-${SPARK_VERSION}-bin-hadoop3.tgz \
    && mv spark-${SPARK_VERSION}-bin-hadoop3 /opt/spark \
    && rm spark-${SPARK_VERSION}-bin-hadoop3.tgz

# Set Spark environment variables
ENV SPARK_HOME=/opt/spark
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/hadoop/bin:$SPARK_HOME/bin:$SPARK_HOME/sbin

RUN wget https://www.python.org/ftp/python/3.11.10/Python-3.11.10.tgz && \
    tar -xzf Python-3.11.10.tgz \

RUN cd /Python-3.11.10 && \
    ./configure --enable-optimizations && \
    make altinstall

# Install JupyterLab
RUN pip3 install -y jupyter

# Install PySpark
RUN pip3 -y install pyspark==${SPARK_VERSION}

# Expose JupyterLab port
EXPOSE 8888

# Set working directory
WORKDIR /notebooks

# Start JupyterLab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
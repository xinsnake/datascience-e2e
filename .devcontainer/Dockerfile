FROM continuumio/miniconda3:latest

# apt stuff
RUN echo 'deb http://deb.debian.org/debian/ sid main' >> /etc/apt/sources.list \
    && apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    # install missing packages
    && mkdir -p /usr/share/man/man1 \
    && apt-get install -y git curl make procps lsb-release vim libicu[0-9][0-9] openjdk-8-jdk \
    # install azure-cli
    && curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
    # Need this to use environment variables for databricks-connect setting
    # https://forums.databricks.com/questions/21536/databricks-connect-configuration-not-possible-with.html
    && echo '{}' > ~/.databricks-connect

# install openjdk 1.8
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64

# copy requirements
COPY ./requirements-base.txt /
COPY ./requirements-localspark.txt /
COPY ./requirements-databricks.txt /
COPY ./requirements-db-jlab.txt /

# update conda in base
RUN conda update -n base -c defaults conda -y
RUN /bin/bash -c 'source /root/.bashrc \
    && conda activate base \
    && pip install -r /requirements-base.txt'

# create environment localspark
RUN conda create -n localspark python=3.7.3 -y
RUN /bin/bash -c 'source /root/.bashrc \
    && conda activate localspark \
    && pip install -r /requirements-localspark.txt'

# create environment databricks
RUN conda create -n databricks python=3.7.3 -y
RUN /bin/bash -c 'source /root/.bashrc \
    && conda activate databricks \
    && pip install -r /requirements-databricks.txt'

# create conda environments in jupyter
RUN /bin/bash -c 'source /root/.bashrc \
    && conda activate localspark \
    && python -m ipykernel install --user --name=LocalPyspark \
    && conda activate databricks \
    && python -m ipykernel install --user --name=DataBricksConnect'

# create environment db-jlab and install extensions
COPY ./labextensions.txt /
RUN conda create -n db-jlab python=3.7 -y
RUN /bin/bash -c 'source /root/.bashrc \
    && conda activate db-jlab \
    && pip install -r /requirements-db-jlab.txt \
    && dj -b \
    && while read line; do jupyter labextension install --no-build $line; done < labextensions.txt \
    && jupyter lab build \
    && jupyter serverextension enable --py jupyterlab_code_formatter'

# update jupyter logos
COPY ./logos/databricks-logo-32x32.png /root/.local/share/jupyter/kernels/databricksconnect/logo-32x32.png
COPY ./logos/databricks-logo-64x64.png /root/.local/share/jupyter/kernels/databricksconnect/logo-64x64.png
COPY ./logos/localspark-logo-32x32.png /root/.local/share/jupyter/kernels/localpyspark/logo-32x32.png
COPY ./logos/localspark-logo-64x64.png /root/.local/share/jupyter/kernels/localpyspark/logo-64x64.png

CMD [ "sleep", "infinity" ]
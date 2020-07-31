FROM continuumio/miniconda3:latest

ARG USERNAME=alex
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

# apt stuff
RUN echo 'deb http://deb.debian.org/debian/ sid main' >> /etc/apt/sources.list \
    && apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    # install missing packages
    && mkdir -p /usr/share/man/man1 \
    && apt-get install -y sudo git curl make procps lsb-release vim libicu[0-9][0-9] openjdk-8-jdk \
    # add sudo support
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    # install azure-cli
    && curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
    # Need this to use environment variables for databricks-connect setting
    # https://forums.databricks.com/questions/21536/databricks-connect-configuration-not-possible-with.html
    && echo '{}' > /home/$USERNAME/.databricks-connect

# install openjdk 1.8
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64

# change conda to be owned by the user
RUN chown -R $USERNAME:$USERNAME /opt/conda

# now everything from here uses the normal user
USER $USERNAME

# copy requirements
COPY ./requirements-*.txt ./labextensions.txt /home/$USERNAME/

# init conda and create all conda environments
RUN conda init bash \
    && conda create -n localspark python=3.7.3 -y \
    && conda create -n databricks python=3.7.3 -y \
    && conda create -n db-jlab    python=3.7   -y

# configure environment db-jlab and install extensions
SHELL ["conda", "run", "-n", "db-jlab", "/bin/bash", "-c"]
RUN pip install -r /home/$USERNAME/requirements-shared.txt \
    && pip install -r /home/$USERNAME/requirements-db-jlab.txt \
    && dj -b \
    && cat /home/$USERNAME/labextensions.txt | xargs -I {} jupyter labextension install --no-build {} \
    && jupyter lab build \
    && jupyter serverextension enable --py jupyterlab_code_formatter

# configure environment localspark
SHELL ["conda", "run", "-n", "localspark", "/bin/bash", "-c"]
RUN pip install -r /home/$USERNAME/requirements-shared.txt \
    && pip install -r /home/$USERNAME/requirements-localspark.txt \
    && python -m ipykernel install --user --name=LocalPyspark

# configure environment databricks
SHELL ["conda", "run", "-n", "databricks", "/bin/bash", "-c"]
RUN pip install -r /home/$USERNAME/requirements-shared.txt \
    && pip install -r /home/$USERNAME/requirements-databricks.txt \
    && python -m ipykernel install --user --name=DataBricksConnect

# back to default shell
SHELL ["/bin/sh", "-c"]

# update jupyter logos
COPY ./logos/databricks-logo-32x32.png /home/$USERNAME/.local/share/jupyter/kernels/databricksconnect/logo-32x32.png
COPY ./logos/databricks-logo-64x64.png /home/$USERNAME/.local/share/jupyter/kernels/databricksconnect/logo-64x64.png
COPY ./logos/localspark-logo-32x32.png /home/$USERNAME/.local/share/jupyter/kernels/localpyspark/logo-32x32.png
COPY ./logos/localspark-logo-64x64.png /home/$USERNAME/.local/share/jupyter/kernels/localpyspark/logo-64x64.png

CMD [ "sleep", "infinity" ]
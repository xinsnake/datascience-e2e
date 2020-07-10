# This image tries to build an environment similar to DataBricks Runtime 6.6
# https://docs.databricks.com/release-notes/runtime/6.6.html
FROM python:3.7.3-stretch

# set JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64

# install missing packages
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    # install missing packages
    && apt-get install -y git procps lsb-release vim libicu[0-9][0-9] openjdk-8-jdk \
    # install azure-cli
    && curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# install python related stuff with pipx
ARG DEFAULT_UTILS="\
    pylint \
    flake8 \
    autopep8 \
    black \
    yapf \
    mypy \
    pydocstyle \
    pycodestyle \
    bandit \
    cookiecutter \
    databricks-cli"

RUN python3 -m pip install --user pipx \
    && python3 -m pipx ensurepath \
    # install python dependencies
    && echo "${DEFAULT_UTILS}" | xargs -n 1 /root/.local/bin/pipx install

# create the virtual envs
RUN mkdir -p /.envs \
    #   localspark
    && python3 -m venv /.envs/localspark \
    && /.envs/localspark/bin/pip install --upgrade pip setuptools wheel \
    && /.envs/localspark/bin/pip install pyspark==2.4.5 \
    #   databricks
    && python3 -m venv /.envs/databricks \
    && /.envs/databricks/bin/pip install --upgrade pip setuptools wheel \
    && /.envs/databricks/bin/pip install databricks-connect==6.6.0 \
    # Need this to use environment variables for databricks-connect setting
    # https://forums.databricks.com/questions/21536/databricks-connect-configuration-not-possible-with.html
    && echo '{}' > ~/.databricks-connect
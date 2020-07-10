FROM mcr.microsoft.com/vscode/devcontainers/python:3

# install missing packages
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    # install azure-cli
    && curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash \
    # install cookiecutter
    && pipx install cookiecutter \
    # install databricks-cli
    && pipx install databricks-cli

# create the virtual envs
RUN mkdir -p /.envs \
    #   localspark
    && python3 -m venv /.envs/localspark \
    && /.envs/localspark/bin/pip install --upgrade pip \
    && /.envs/localspark/bin/pip install pyspark \
    #   databricks
    && python3 -m venv /.envs/databricks \
    && /.envs/databricks/bin/pip install --upgrade pip \
    && /.envs/databricks/bin/pip install databricks-connect \
    # Need this to use environment variables for databricks-connect setting
    # https://forums.databricks.com/questions/21536/databricks-connect-configuration-not-possible-with.html
    && echo '{}' > ~/.databricks-connect
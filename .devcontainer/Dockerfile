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

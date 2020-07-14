# An end-to-end Environment for Azure DataBricks Development

## Features

- Run Python code on local PySpark or Azure DataBricks
- Run Jupyter Notebook on local PySpark or Azure DataBricks
- Cookiecutter template using cookiecutter-data-science
- nbstripout to filter notebook output when committing

## Requirements

- Operation System
  - Windows WSL2
  - Linux
  - macOS
- Docker
- Visual Studio Code
  - Remote Development plugins
- Azure DataBricks
  - A VNet enabled DataBricks workspace
  - A DataBricks cluster with SSH access enabled
  - Allow NSG port 2200 to be accessible from your workstation

## Configuration

There are few things you need to configure:

- `.databrickscfg`
- `.env`
- SSH key for DataBricks

### `.databrickscfg`

This file needs to be created from the `.databrickscfg.example` file
and filled up with your DataBricks details.

`PROFILE_NAME` is the name of your SSH key where the file name follows
`id_${PROFILE_NAME}`.

You can generate the token in the DataBricks Workspace.

### `.env`

This file needs to be created from the `.env.example` file and filled
up with your DataBricks details.

You can find more information about how to configure the CLI [here]
(https://docs.microsoft.com/en-us/azure/databricks/dev-tools/cli/#set-up-the-cli)

### Configure SSH access for your DataBricks cluster

To configure the workspace for SSH access:
- For Azure Databricks you need to have an Azure Databricks cluster that
is deployed into your own Azure Virtual Network.
- Open port 2200 in the Network Security Group of your workspace.
- When creating a cluster for access, add the public key into the
cluster.
  - Copy the entire contents of the public key file.
  - On the cluster configuration page, click the Advanced Options toggle.
  - At the bottom of the page, click the SSH tab.
  - Paste the key you copied into the SSH Public Key field.

## Use Python

Different Python environments are set up using Python's venv module.
You can switch between local PySpark or DataBricks via DataBricks
Connect by changing which venv your shell/VSCode is using.

To change the venv on VSCode, open the workspace in the conatiner
and press `Ctrl-Shift-P`, and in the command pop-up choose
`Python: Select Interpreter`. Then you can pick either `localspark`
or `databricks` from the list.

After you select the interpreter, you can open a new terminal in
VSCode and you will see the opened terminal automatically selected
the correct virtual environment.

## Use Jupyter Notebook

Set up and running of Jupyter Labs is not fully yet. There are few
commands you need to run interactively in order to set up the
Jupyter kernel and connect to the remote DataBricks cluster.

After you finish the configurations needed, execute the following
commands in the jupyter container:

``` bash
# First find out the container
$ JP_CONTAINER=$(docker ps --filter "name=datascience-e2e_devcontainer_jupyter" --quiet)
$ docker exec -i -t $JP_CONTAINER /bin/bash

# The below commands are inside the container
(base)    $ conda activate db-jlab       # activate the environment
(db-jlab) $ dj $PROFILE_NAME -k -o $OID  # set up the kernel
(db-jlab) $ dj $PROFILE_NAME -l          # launch jupyterlabs
```

Here `$PROFILE_NAME` should match the file name inside the `~/.ssh`
directory, i.e. you should have a file `id_${PROFILE_NAME}` and the
public key which you have copied into the cluster you created in
DataBricks. `$OID` is the organisation ID which you have put in the
`.evn` file.

After this configuration, you should be able to visit
[http://localhost:8888](http://localhost:8888) and see the Jupyter
interface.

## How it works

TBA

## Help Needed

- Test on macOS
- Run different interaction/visualisation on Jupyter Notebooks
and see if all features are supported
- If it is possible to have only 1 container
- Test if this setup also works on AWS

## Acknologements

- Thanks @fujikosu for getting Python code to run on local PySpark
or Azure DataBricks.
- [databrickslabs/jupyterlab-integration]
(https://github.com/databrickslabs/jupyterlab-integration) for the
integration between Jupyter Labs and DataBricks.
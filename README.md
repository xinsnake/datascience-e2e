# An end-to-end Environment for Azure DataBricks Development

## Features

- Use VSCode to write Python with set up for
  - PySpark
  - DataBricks via DataBricks-Connect
    ![vscode](.devcontainer/docs/vscode.png)

- Use JupyterLab to experiment with set up for
  - PySpark
  - DataBricks via DataBricks-Connect
  - DataBricks via DataBricks-JupyterLabsIntegration
    ![jupyterlab](.devcontainer/docs/jupyterlab.png)

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
- DataBricks Workspace
  - A Personal Access Token
  - A VNet enabled DataBricks workspace
  - A DataBricks cluster with SSH access enabled
  - Allow NSG port 2200 to be accessible from your workstation

## Configuration

There are few things you need to configure:

- `/configs/.env`.
- `/configs/.databrickscfg`.
- SSH key for DataBricks, you should have your SSH key in `~/.ssh` folder on your host.

### Create `.env`

This file needs to be created from the `/configs/.env.example` file and filled
up with your DataBricks details.

You can find more information about how to configure the CLI [here]
(https://docs.microsoft.com/en-us/azure/databricks/dev-tools/cli/#set-up-the-cli)

### Create `.databrickscfg`

This file needs to be created from the `/configs/.databrickscfg.example` file
and filled up with your DataBricks details.

`SSH_PROFILE` is the name of your SSH key where the file name follows
`id_${SSH_PROFILE}`.

You can generate the token in the DataBricks Workspace.

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

### If you are using WSL2, it is recommended to change your `/etc/wsl.conf` file

The default WSL2 configuration does not enable NTFS metadata. It results to the fact that
your files mounted in WSL2 does not have the correct UNIX compatible permission.

Create the file `/etc/wsl.conf` if it doesn't exist with the following content:

```
[automount]
enabled = true
options = "metadata,umask=22,fmask=11,case=dir"
```

And then restart the WSL2 system `wsl --terminate YOUR_DISTRIBUTION`, you will see the files
are now with the correct permission:

```
$ ls -l ~/.ssh
total 28
-rw-r--r-- 1 jazhou jazhou   191 Aug  5 11:47 config
-rw------- 1 jazhou jazhou  2610 Jul 10 10:55 id_rsa
-rw-r--r-- 1 jazhou jazhou   576 Jul 10 10:55 id_rsa.pub
-rw------- 1 jazhou jazhou 10520 Aug  5 11:39 known_hosts
-rw------- 1 jazhou jazhou  9635 Jul 31 22:05 known_hosts.old
```

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

### Use cookiecutter

To create a new cookiecutter-data-science project, run `make new`
on the root directory of the workspace.

You can also just use `cookiecutter` by itself with any other
template as you wish.

## Use JupyterLab

There are few commands you need to run interactively in order to
start JupyterLab and connect to the remote DataBricks cluster.

After you finish the configurations needed, execute the following
commands in the jupyter container:

``` bash
# The below commands are inside the container
(base)    $ conda activate db-jlab                    # activate the environment
(db-jlab) $ dj $SSH_PROFILE -k -o $DATABRICKS_ORG_ID  # set up the kernel
(db-jlab) $ dj $SSH_PROFILE -l                        # launch jupyterlabs
```

Here `$SSH_PROFILE` should match the file name inside the `~/.ssh`
directory, i.e. you should have a file `id_${SSH_PROFILE}` and the
public key which you have copied into the cluster you created in
DataBricks. `$DATABRICKS_ORG_ID` is the organisation ID which you have
put in the `/configs/.env` file.

After this configuration, you should be able to visit
[http://localhost:8888](http://localhost:8888) and see the Jupyter
interface.

<details>
<summary>Example output of this step Click Here</summary>
<p>

``` bash
$ docker ps --filter "name=datascience-e2e_devcontainer_jupyter" --quiet

e78b3d01449a

$ docker exec -i -t e78b /bin/bash

(base) root@e78b3d01449a:/# conda activate db-jlab

(db-jlab) root@e78b3d01449a:/# ls ~/.ssh
config  id_rsa  id_rsa.pub  known_hosts  known_hosts.old

(db-jlab) root@e78b3d01449a:/# SSH_PROFILE=rsa

(db-jlab) root@e78b3d01449a:/# OID=8709416564172131

(db-jlab) root@e78b3d01449a:/# dj $SSH_PROFILE -k -o $OID

Valid version of conda detected: 4.8.3

* Getting host and token from .databrickscfg

* Select remote cluster

? Which cluster to connect to?  0: 'MyCluster' (id: 0713-025441-scoop239, state: TERMINATED, workers: 1)
   => Starting cluster 0713-025441-scoop239
   => Waiting for cluster 0713-025441-scoop239 being started (this can take up to 5 min)
   ........................................
   => OK

   => Waiting for libraries on cluster 0713-025441-scoop239 being installed (this can take some time)

   => OK

   => Selected cluster: MyCluster (52.156.HIDDEN)

* Configuring ssh config for remote cluster
   => ~/.ssh/config will be changed
   => A backup of the current ~/.ssh/config has been created
   => at ~/.databrickslabs_jupyterlab/ssh_config_backup/config.2020-07-14_02-17-41
   => Added ssh config entry or modified IP address:

      Host 0713-025441-scoop239
          HostName 52.156.HIDDEN
          User ubuntu
          Port 2200
          IdentityFile ~/.ssh/id_rsa
          ServerAliveInterval 30
          ConnectTimeout 5
          ServerAliveCountMax 5760

   => Known hosts fingerprint added for 52.156.HIDDEN

   => Testing whether cluster can be reached
   => OK

* Installing driver libraries
   => Installing  ipywidgets==7.5.1 ipykernel==5.2.1 databrickslabs-jupyterlab==2.0.0
   => OK
False

* Creating remote kernel spec
   => Creating kernel specification for profile 'rsa'
   => Kernel specification 'SSH 0713-025441-scoop239 SSH 0713-025441-scoop239 rsa:MyCluster (db-jlab/Spark)' created or updated
   => OK

* Setting global config of jupyter lab (autorestart, timeout)
   => OK

(db-jlab) root@e78b3d01449a:/# dj $SSH_PROFILE -l
Valid version of conda detected: 4.8.3

* Getting host and token from .databrickscfg

* Select remote cluster

? Which cluster to connect to?  0: 'MyCluster' (id: 0713-025441-scoop239, state: RUNNING, workers: 1)
   => Selected cluster: MyCluster (52.156.HIDDEN)

* Configuring ssh config for remote cluster
   => ~/.ssh/config will be changed
   => A backup of the current ~/.ssh/config has been created
   => at ~/.databrickslabs_jupyterlab/ssh_config_backup/config.2020-07-14_02-18-32
   => Added ssh config entry or modified IP address:

      Host 0713-025441-scoop239
          HostName 52.156.HIDDEN
          User ubuntu
          Port 2200
          IdentityFile ~/.ssh/id_rsa
          ServerAliveInterval 30
          ConnectTimeout 5
          ServerAliveCountMax 5760

   => Known hosts fingerprint added for 52.156.HIDDEN

   => Testing whether cluster can be reached
   => OK

* Installing driver libraries
   => Installing  ipywidgets==7.5.1 ipykernel==5.2.1 databrickslabs-jupyterlab==2.0.0
   => OK
[I 02:18:35.328 LabApp] Writing notebook server cookie secret to /root/.local/share/jupyter/runtime/notebook_cookie_secret
[W 02:18:35.437 LabApp] All authentication is disabled.  Anyone who can connect to this server will be able to run code.
[I 02:18:35.936 LabApp] JupyterLab extension loaded from /opt/conda/envs/db-jlab/lib/python3.7/site-packages/jupyterlab
[I 02:18:35.936 LabApp] JupyterLab application directory is /opt/conda/envs/db-jlab/share/jupyter/lab
[I 02:18:35.938 LabApp] Serving notebooks from local directory: /workspace
[I 02:18:35.938 LabApp] The Jupyter Notebook is running at:
[I 02:18:35.938 LabApp] http://e78b3d01449a:8888/
[I 02:18:35.938 LabApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[W 02:18:35.944 LabApp] No web browser found: could not locate runnable browser.
```

</p>
</details>

### Install nbstripout

You may also want to have npstripout filter enabled so you don't
commit notebook data/output into the repository.

Run `make init` in the root of the workspace to install it.

## How it works

![howitworks.png](.devcontainer/docs/howitworks.png)

Explaination TBA.

## Help Needed

- Test on macOS
- ~~Run different interaction/visualisation on Jupyter Notebooks and see if all features are supported~~
- ~~If it is possible to have only 1 container~~
- Test if this setup also works on AWS

## Acknologements

- Thanks [@fujikosu](https://github.com/fujikosu) to start the foundation
investigation, and multiple contributions on Jupyter Extensions, Python
utilities and overall setup.
- [databrickslabs/jupyterlab-integration]
(https://github.com/databrickslabs/jupyterlab-integration) for the
integration between Jupyter Labs and DataBricks.
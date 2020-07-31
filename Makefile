SHELL=/bin/bash

init:
	nbstripout --install
	nbstripout --install --attributes .gitattributes
	nbstripout --status

new:
	cookiecutter https://github.com/drivendata/cookiecutter-data-science

jupyter:
	fuser -k 8888/tcp || :
	dj ${SSH_PROFILE} -k -o ${DATABRICKS_ORG_ID}
	dj ${SSH_PROFILE} -l

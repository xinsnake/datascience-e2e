SHELL=/bin/bash

init:
	nbstripout --install
	nbstripout --install --attributes .gitattributes
	nbstripout --status

new:
	cookiecutter https://github.com/drivendata/cookiecutter-data-science

jupyter:
	dj ${SSH_PROFILE} -k -o ${DATABRICKS_ORG_ID}
	dj ${SSH_PROFILE} -l

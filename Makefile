init:
	nbstripout --install
	nbstripout --install --attributes .gitattributes
	nbstripout --status

new:
	cookiecutter https://github.com/drivendata/cookiecutter-data-science

#!/bin/bash

export PATH=$CONDA_DIR/bin:$PATH
export PYTHONPATH=$SPARK_HOME/python:$(echo $SPARK_HOME/python/lib/py4j-*-src.zip)

if [[ "x$JUPYTER_NOTEBOOK_PASSWORD" != "x" ]]; then
    HASH=$(python -c "from notebook.auth import passwd; print(passwd('$JUPYTER_NOTEBOOK_PASSWORD'))")
    echo "c.NotebookApp.password = u'$HASH'" >> /home/$NB_USER/.jupyter/jupyter_notebook_config.py
fi

if [[ -n "$JUPYTER_NOTEBOOK_X_INCLUDE" ]]; then
    curl -O $JUPYTER_NOTEBOOK_X_INCLUDE
fi

# The below will be replace by s2i in the future
# this is just a temp hack while I wait on https://github.com/sherl0cks/jupyter-notebook-py3.5.git
if [[ -n "$JUPYTER_NOTEBOOK_PIP_PACKAGES" ]]; then
    pip install --user --upgrade $JUPYTER_NOTEBOOK_PIP_PACKAGES
fi

# only supports 1 extension right now
if [[ -n "$JUPYTER_NOTEBOOK_EXTENSION" ]]; then
    jupyter nbextension enable --py $JUPYTER_NOTEBOOK_EXTENSION
fi


jt -t oceans16
curl -O https://raw.githubusercontent.com/sherl0cks/labs-big-data/master/notebooks/plot_cryptocurrencies.ipynb
curl -O https://raw.githubusercontent.com/sherl0cks/labs-big-data/master/notebooks/residency_mapping.ipynb


if [[ "$JUPYTERLAB" == true ]]; then
	echo "jupyter lab...."
    exec jupyter lab
else
	echo "jupyter notebook...."
	exec jupyter notebook
fi


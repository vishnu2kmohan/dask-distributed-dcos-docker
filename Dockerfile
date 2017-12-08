FROM vishnumohan/miniconda3:4.3.30-3.6.3

MAINTAINER Vishnu Mohan <vishnu@mesosphere.com>

COPY --chown="1000:100" dask-distributed-conda-env.yml "${CONDA_USER_HOME}/work"

RUN ${HOME}/conda/bin/conda env create --json -q -f dask-distributed-conda-env.yml \
    && ${HOME}/conda/bin/conda clean --json -tipsy \
    && mkdir -p "${HOME}/.dask" \
    && bash -c 'source activate dask-distributed \
    && jupyter labextension install @jupyter-widgets/jupyterlab-manager \
    && source deactivate'

EXPOSE 8888 8786 8787 8789
CMD ["notebook.sh"]

COPY --chown="1000:100" jupyter_notebook_config.py "${HOME}/.jupyter/"
COPY notebook.sh /usr/local/bin/
COPY start-dask-scheduler.sh /usr/local/bin/
COPY start-dask-worker.sh /usr/local/bin

FROM vishnumohan/miniconda3:4.2.12

MAINTAINER Vishnu Mohan <vishnu@mesosphere.com>

RUN $CONDA_USER_HOME/conda/bin/conda create -yq -n dask-distributed python=3.5\
    && bash --login -c "source activate dask-distributed \
    && conda install -yq -c conda-forge \
       altair \
       bcolz \
       blosc \
       bokeh \
       boost \
       chest \
       cloudpickle \
       coverage \
       cython \
       cytoolz \
       dask \
       dill \
       distributed \
       fastparquet \
       feather-format \
       flake8 \
       futures \
       graphviz \
       h5py \
       hdfs3 \
       ipykernel \
       ipyleaflet \
       ipython \
       ipywidgets \
       joblib \
       jupyter_client \
       jupyter_dashboards \
       jupyterlab \
       krb5 \
       libgsasl \
       libhdfs3 \
       libntlm \
       libxml2 \
       mock \
       netcdf4 \
       numba \
       numpy \
       partd \
       psutil \
       pytables \
       pytest \
       pytest-timeout \
       pytest-xdist \
       python-lmdb \
       requests \
       s3fs \
       scikit-learn \
       scipy \
       toolz \
       tornado \
       zict \
    && conda clean --yes --tarballs --packages \
    && pip install git+https://github.com/mrocklin/cachey --upgrade \
    && jupyter nbextension enable jupyter_dashboards --py --sys-prefix \
    && jupyter nbextension enable vega --py --sys-prefix \
    && pip install jupyter_declarativewidgets \
    && jupyter declarativewidgets quick-setup --sys-prefix \
    && pip install dask-labextension \
    && jupyter labextension install --py --sys-prefix dask_labextension \
    && jupyter labextension enable --py --sys-prefix dask_labextension \
    && source deactivate"

EXPOSE 8888 8786 8787 9786
CMD ["notebook.sh"]

COPY jupyter_notebook_config.py "$CONDA_USER_HOME/.jupyter/"
COPY notebook-home.sh "/usr/local/bin/notebook.sh"
COPY start-dask-scheduler.sh /usr/local/bin/
COPY start-dask-worker.sh /usr/local/bin

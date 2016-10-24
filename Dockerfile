FROM vishnumohan/miniconda3:4.1.11

MAINTAINER Vishnu Mohan <vishnu@mesosphere.com>

RUN $CONDA_USER_HOME/conda/bin/conda create -yq -n dask-distributed python=3.5\
    && bash --login -c "source activate dask-distributed \
    && conda install -yq -c conda-forge \
       bcolz \
       blosc \
       bokeh \
       chest \
       cloudpickle \
       coverage \
       cython \
       cytoolz \
       dask \
       dill \
       distributed \
       flake8 \
       futures \
       graphviz \
       h5py \
       ipykernel \
       ipython \
       ipywidgets \
       joblib \
       jupyter_client \
       mock \
       numpy \
       partd \
       psutil \
       pytables \
       pytest \
       pytest-xdist \
       requests \
       scikit-learn \
       scipy \
       toolz \
       tornado \
    && conda clean --yes --tarballs --packages \
    && source deactivate"

EXPOSE 8888 8786 8787 9786
CMD ["notebook.sh"]

COPY jupyter_notebook_config.py "$CONDA_USER_HOME/.jupyter/"                    
COPY notebook-home.sh "/usr/local/bin/notebook.sh"
COPY start-dask-scheduler.sh /usr/local/bin/
COPY start-dask-worker.sh /usr/local/bin

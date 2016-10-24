#!/bin/bash

source "$HOME/.bash_profile"
source activate dask-distributed
jupyter notebook "$@"

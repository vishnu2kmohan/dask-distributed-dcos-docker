#!/bin/bash

source activate dask-distributed
jupyter notebook "$@"

#!/bin/bash

source activate dask-distributed
jupyter lab "$@"

#!/usr/bin/env bash

set -o errexit -o pipefail

source "$HOME/.bash_profile"
source activate dask-distributed

if [ \( -n "${MARATHON_APP_ID-}" \) -a \( -n "${MARATHON_APP_RESOURCE_CPUS-}" \) \
    -a \( -n "${MESOS_TASK_ID-}" \) -a \( -n "${LIBPROCESS_IP-}" \) \
    -a \( -n "${PORT1-}" \) -a \( -n "${PORT2-}" \) -a \( -n "${PORT3-}" \) ]
then
    SCHEDULER_APP_PREFIX=$(python -c \
        "import os; print('-'.join(os.environ['MARATHON_APP_ID'].split('/')[:-1]))")
    dask-scheduler \
    --port "${PORT1}" \
    --http-port "${PORT2}" \
    --bokeh-port "${PORT3}" \
    --host "${LIBPROCESS_IP}"
    --prefix "${SCHEDULER_APP_PREFIX}"
else
    dask-scheduler "$@"
fi

#!/usr/bin/env bash

set -o errexit -o pipefail

source "$HOME/.bash_profile"
source activate dask-distributed

if [ \( -n "${MARATHON_APP_ID-}" \) -a \( -n "${MARATHON_APP_RESOURCE_CPUS-}" \) \
    -a \( -n "${MESOS_TASK_ID-}" \) -a \( -n "${LIBPROCESS_IP-}" \) \
    -a \( -n "${PORT1-}" \) -a \( -n "${PORT2-}" \) -a \( -n "${PORT3-}" \) ]
then
    VIP_PREFIX=$(python -c \
        "import os; print(''.join(os.environ['MARATHON_APP_ID'].split('/')[:-1]))")
    dask-worker \
    --worker-port "${PORT1}" \
    --http-port "${PORT2}" \
    --nanny-port "${PORT3}" \
    --host "${LIBPROCESS_IP}" \
    --nthreads 1 \
    --nprocs $(python -c \
        "import os,math; print(math.ceil(os.environ['MARATHON_APP_RESOURCE_CPUS'])") \
    --name "${MESOS_TASK_ID}" \
        "${VIP_PREFIX}dask-scheduler.marathon.l4lb.thisdcos.directory:8786"
else
    dask-worker "$@"
fi

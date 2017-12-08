#!/usr/bin/env bash

set -o errexit -o pipefail

source "${HOME}/.bash_profile"
source activate dask-distributed

if [ \( -n "${MARATHON_APP_ID-}" \) -a \( -n "${HOST-}" \) \
    -a \( -n "${PORT_SCHEDULER-}" \) -a \( -n "${PORT_BOKEH-}" \) ]
then
    BOKEH_WHITELIST="*"
    BOKEH_APP_PREFIX=""

    if [ -n "${MARATHON_APP_LABEL_HAPROXY_1_VHOST-}" ]
    then
        BOKEH_WHITELIST="${MARATHON_APP_LABEL_HAPROXY_1_VHOST}"
    fi

    if [ -n "${MARATHON_APP_LABEL_HAPROXY_1_PATH-}" ]
    then
        BOKEH_APP_PREFIX="${MARATHON_APP_LABEL_HAPROXY_1_PATH}"
    fi

    dask-scheduler \
        --host "${HOST}" \
        --port "${PORT_SCHEDULER}" \
        --tls-ca-file "${MESOS_SANDBOX}/.ssl/ca-bundle.crt" \
        --tls-cert "${MESOS_SANDBOX}/.ssl/scheduler.crt" \
        --tls-key "${MESOS_SANDBOX}/.ssl/scheduler.key" \
        --bokeh-port "${PORT_BOKEH}" \
        --bokeh-whitelist "${BOKEH_WHITELIST}" \
        --bokeh-prefix "${BOKEH_APP_PREFIX}" \
        --use-xheaders "True" \
        --scheduler-file "dask-scheduler-connection" \
        --local-directory "${MESOS_SANDBOX}"
else
    dask-scheduler "$@"
fi

#!/usr/bin/env bash

set -o errexit -o pipefail

source "$HOME/.bash_profile"
source activate dask-distributed

if [ \( -n "${MARATHON_APP_ID-}" \) -a \( -n "${HOST-}" \) \
    -a \( -n "${PORT1-}" \) -a \( -n "${PORT2-}" \) \
    -a \( -n "${PORT3-}" \) -a \( -n "${PORT4-}" \) ]
then
    BOKEH_WHITELIST="*"

    if [ -n "${MARATHON_APP_LABEL_HAPROXY_VHOST-}" ]
    then
        BOKEH_WHITELIST="${MARATHON_APP_LABEL_HAPROXY_VHOST}"
    fi

    dask-scheduler \
        --host "*" \
        --bokeh-whitelist "${BOKEH_WHITELIST}" \
        --use-xheaders "True" \
        --port "${PORT1}" \
        --http-port "${PORT2}" \
        --bokeh-port "${PORT3}" \
        --bokeh-internal-port "${PORT4}"
else
    dask-scheduler "$@"
fi

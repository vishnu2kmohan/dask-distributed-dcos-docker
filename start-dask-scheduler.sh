#!/usr/bin/env bash

set -o errexit -o pipefail

source "$HOME/.bash_profile"
source activate dask-distributed

if [ \( -n "${MARATHON_APP_ID-}" \) -a \( -n "${HOST-}" \) \
    -a \( -n "${PORT1-}" \) -a \( -n "${PORT2-}" \) \
    -a \( -n "${PORT3-}" \) -a \( -n "${PORT4-}" \) ]
then
    BOKEH_WHITELIST="*"
    BOKEH_APP_PREFIX=""

    if [ -n "${MARATHON_APP_LABEL_HAPROXY_3_VHOST-}" ]
    then
        BOKEH_WHITELIST="${MARATHON_APP_LABEL_HAPROXY_3_VHOST}"
    fi

    if [ -n "${MARATHON_APP_LABEL_HAPROXY_3_PATH-}" ]
    then
        BOKEH_APP_PREFIX="${MARATHON_APP_LABEL_HAPROXY_3_PATH}"
    fi

    dask-scheduler \
        --bokeh-whitelist "${BOKEH_WHITELIST}" \
        --use-xheaders "True" \
        --port "${PORT1}" \
        --http-port "${PORT2}" \
        --bokeh-port "${PORT3}" \
        --bokeh-internal-port "${PORT4}" \
        --prefix "{BOKEH_APP_PREFIX}"
else
    dask-scheduler "$@"
fi

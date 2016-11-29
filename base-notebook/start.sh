#!/bin/bash

set -x

set -eo pipefail

NSS_USER_ID=$(id -u)

echo NSS_USER_ID is $NSS_USER_ID

NSS_WRAPPER_PASSWD=${HOME}/passwd
NSS_WRAPPER_GROUP=/etc/group

NSS_WRAPPER_LIBRARY=

if [ -f /usr/lib64/libnss_wrapper.so ]; then
    NSS_WRAPPER_LIBRARY=/usr/lib64/libnss_wrapper.so
fi

if [ "${NSS_WRAPPER_LIBRARY}" != "" ]; then
    if [ x"${NSS_USER_ID}" != x"0" -a x"${NSS_USER_ID}" != x"1011" ]; then
        if [ ! -f ${NSS_WRAPPER_PASSWD} ]; then
            cat /etc/passwd | sed -e 's/^nbuser:/builder:/' > ${NSS_WRAPPER_PASSWD}

            echo "nbuser:x:${NSS_USER_ID}:0::${HOME}:/bin/bash" >> ${NSS_WRAPPER_PASSWD}
        fi

        export NSS_WRAPPER_PASSWD=${NSS_WRAPPER_PASSWD}
        export NSS_WRAPPER_GROUP=${NSS_WRAPPER_GROUP}

        export LD_PRELOAD=${NSS_WRAPPER_LIBRARY}
    fi
fi

export PYTHONPATH=$SPARK_HOME/python:$(echo $SPARK_HOME/python/lib/py4j-*-src.zip)

exec jupyter notebook

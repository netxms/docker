#!/bin/sh

nxdbmgr -q get DBLockStatus
exitcode=$?
if [ "$exitcode" -eq 5 ]; then
    driver=$(grep -im1 '^DBDriver' /etc/netxmsd.conf | cut -d= -f2 | tr -d '[:space:]' | sed 's/\.ddr$//' | tr '[:upper:]' '[:lower:]')
    if [ "$driver" = "pgsql" ]; then
        nxdbmgr init "${NETXMS_PG_TYPE:-pgsql}"
    else
        nxdbmgr init
    fi
else
    exit $exitcode
fi

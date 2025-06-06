#!/bin/sh

nxdbmgr -q get DBLockStatus
exitcode=$?
if [ "$exitcode" -eq 5 ]; then
    nxdbmgr init pgsql
else
    exit $exitcode
fi

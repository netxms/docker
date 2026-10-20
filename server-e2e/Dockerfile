FROM debian:13-slim

RUN apt-get update && apt-get install -y ca-certificates curl

COPY --chown=root:root files/netxms.list /etc/apt/sources.list.d/
COPY --chown=root:root files/netxms-keyring.gpg /etc/apt/trusted.gpg.d/

ARG NETXMS_PACKAGE_VERSION
COPY --chown=root:root files/netxms-pin /etc/apt/preferences.d/netxms-pin

RUN apt-get update && apt-get install -y netxms-server=${NETXMS_PACKAGE_VERSION} && apt-get clean

VOLUME [ "/etc/netxms" ]
VOLUME [ "/var/lib/netxms" ]

EXPOSE 4701/tcp
EXPOSE 8000/tcp

COPY files/db.sqlite3 /tmp/db.sqlite3
COPY files/netxmsd.conf /etc/netxmsd.conf

RUN set -eu; \
    nxdbmgr -c /etc/netxmsd.conf upgrade; \
    upgrade_output="$(nxdbmgr -c /etc/netxmsd.conf upgrade 2>&1)"; \
    printf '%s\n' "$upgrade_output"; \
    printf '%s\n' "$upgrade_output" | grep -Fx 'Core database schema is up to date'; \
    printf '%s\n' "$upgrade_output" | grep -Fx 'Database upgrade succeeded'; \
    nxdbmgr -c /etc/netxmsd.conf background-upgrade; \
    background_output="$(nxdbmgr -c /etc/netxmsd.conf background-upgrade 2>&1)"; \
    printf '%s\n' "$background_output"; \
    printf '%s\n' "$background_output" | grep -Fx 'No pending background upgrades'

ENTRYPOINT [ "/usr/bin/netxmsd", "-c", "/etc/netxmsd.conf", "-q"]

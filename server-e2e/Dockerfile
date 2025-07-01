FROM debian:12

RUN apt-get update && apt-get install -y ca-certificates

COPY --chown=root:root files/netxms.list /etc/apt/sources.list.d/
COPY --chown=root:root files/netxms-keyring.gpg /etc/apt/trusted.gpg.d/

ARG NETXMS_PACKAGE_VERSION
COPY --chown=root:root files/netxms-pin /etc/apt/preferences.d/netxms-pin

RUN apt-get update && apt-get install -y netxms-server && apt-get clean

VOLUME [ "/etc/netxms" ]
VOLUME [ "/var/lib/netxms" ]

EXPOSE 4701/tcp
EXPOSE 8000/tcp

COPY files/db.sqlite3 /tmp/db.sqlite3
COPY files/netxmsd.conf /etc/netxmsd.conf

ENTRYPOINT [ "/usr/bin/netxmsd", "-c", "/etc/netxmsd.conf", "-q"]

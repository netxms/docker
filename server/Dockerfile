FROM debian:12

RUN apt-get update && apt-get install -y ca-certificates

COPY --chown=root:root files/netxms.list /etc/apt/sources.list.d/
COPY --chown=root:root files/netxms-keyring.gpg /etc/apt/trusted.gpg.d/

ARG NETXMS_PACKAGE_VERSION
COPY --chown=root:root files/netxms-pin /etc/apt/preferences.d/netxms-pin

RUN apt-get update && apt-get install -y netxms-server netxms-dbdrv-pgsql && apt-get clean

COPY files/dbinit.sh /

VOLUME [ "/etc/netxms" ]
VOLUME [ "/var/lib/netxms" ]

EXPOSE 4701/tcp
EXPOSE 4703/tcp

ENTRYPOINT [ "/usr/bin/netxmsd", "-c", "/etc/netxmsd.conf", "-q"]

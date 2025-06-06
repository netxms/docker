FROM debian:12

RUN apt-get update && apt-get install -y ca-certificates

COPY --chown=root:root files/netxms.list /etc/apt/sources.list.d/
COPY --chown=root:root files/netxms-keyring.gpg /etc/apt/trusted.gpg.d/

ARG NETXMS_PACKAGE_VERSION
COPY --chown=root:root files/netxms-pin /etc/apt/preferences.d/netxms-pin

RUN apt-get update && apt-get install -y netxms-agent && apt-get clean

VOLUME [ "/var/lib/netxms" ]

EXPOSE 4700/tcp
EXPOSE 162/udp
EXPOSE 514/udp

ENTRYPOINT [ "/usr/bin/nxagentd", "-c", "/etc/nxagentd.conf", "-f" ]

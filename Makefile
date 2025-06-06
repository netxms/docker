.PHONY: all agent server web clean-pin

V=$(shell grep '^NETXMS_VERSION=' build.properties | cut -d= -f2)
PV=$(shell grep '^NETXMS_PACKAGE_VERSION=' build.properties | cut -d= -f2)

all: agent server web

agent:
	./pin-package-version agent/files/netxms-pin $(PV)
	docker build --progress=plain --platform linux/amd64 --build-arg NETXMS_PACKAGE_VERSION=$(PV) -t ghcr.io/netxms/agent:$(V) agent
	@rm agent/files/netxms-pin

server:
	./pin-package-version server/files/netxms-pin $(PV)
	docker build --progress=plain --platform linux/amd64 --build-arg NETXMS_PACKAGE_VERSION=$(PV) -t ghcr.io/netxms/server:$(V) server
	@rm server/files/netxms-pin

web:
	@if [ ! -f web/nxmc-$(V).war ]; then \
		curl -L -o web/nxmc-$(V).war https://netxms.org/download/releases/$(shell echo $(V) | cut -d. -f1-2)/nxmc-$(V).war; \
	fi
	docker build --progress=plain --build-arg NETXMS_VERSION=$(V) -t ghcr.io/netxms/web:$(V) web

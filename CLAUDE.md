# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Important: do not write comments. Do not explain what are you doing. Do NOT comment what's changed.

## Project Overview

This repository contains Docker containerization for NetXMS (Network Management System), providing three main components:

- **Server**: NetXMS monitoring server with PostgreSQL database support
- **Agent**: NetXMS monitoring agent for collecting system metrics
- **Web**: Jetty-based web interface for NetXMS management console

## Build Commands

Build all components:

```sh
make all
```

Build individual components:

```sh
make agent    # Build NetXMS agent container
make server   # Build NetXMS server container
make web      # Build NetXMS web interface container
```

Clean pinned package versions:

```sh
make clean-pin
```

## Docker Architecture

### Component Structure

- Each component (agent, server, web) has its own Dockerfile and supporting files
- All containers use Debian 12 base (except web which uses Jetty Alpine)
- NetXMS packages are pinned to specific versions via `pin-package-version` script
- Version configuration is centralized in `build.properties`

### Container Images

- Built for `linux/amd64` platform
- Tagged as `ghcr.io/netxms/{component}:{version}`
- Server and agent use NetXMS APT repository with GPG verification

### Database Initialization

- Server container includes `dbinit.sh` for initial schema setup if it's empty
- Database management utilities available via `nxdbmgr` commands

## Configuration System

### Version Management

- `build.properties`: Central version configuration
- `NETXMS_VERSION`: Product version (e.g., 5.2.3)
- `NETXMS_PACKAGE_VERSION`: Debian package version (e.g., 5.2.3-1+bookworm)

### Package Pinning

- `pin-package-version` script creates APT pin files
- Ensures consistent NetXMS package versions across builds
- Pin files are temporary and cleaned after build

### SSL/TLS Configuration

- Web container includes keystore management for HTTPS
- SNI configuration automatically disabled for bundled certificates
- Default keystore password is "changeit"

## Deployment Example

The `deployment-example/` directory contains a complete Docker Compose setup:

- PostgreSQL database with health checks
- NetXMS server with dependency management
- NetXMS agent for local monitoring
- Web interface with SSL support
- Database initialization and management services

Service dependencies are properly configured with health checks and completion conditions.

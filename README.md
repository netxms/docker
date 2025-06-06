# NetXMS Docker

Docker containerization for NetXMS (Network Management and Monitoring System), providing a complete monitoring solution with server, agent, and web interface components.

## Overview

NetXMS is an enterprise-grade network monitoring and management system. This project provides Docker containers for:

- **NetXMS Server**: Core monitoring engine
- **NetXMS Agent**: Monitoring agent for collecting system metrics, also used by the server for querying web services, ssh checks, etc.
- **NetXMS Web**: Management console accessible via web browser

## Quick Start

1. Clone this repository
2. Navigate to the `deployment-example` directory
3. Copy `.env.example` to `.env` and configure your settings
4. Adjust `conf/server/netxmsd.conf` if DB credentials were changed in the `.env` file
5. Run the deployment:

```sh
cd deployment-example
docker compose up -d
```

This will start:

- PostgreSQL database
- NetXMS server
- NetXMS agent (for monitoring the server itself)
- Web interface

Access the web interface at <https://localhost:8443>

## Pre-built Images

Pre-built Docker images are automatically published to GitHub Container Registry:

- `ghcr.io/netxms/agent:latest` - NetXMS monitoring agent
- `ghcr.io/netxms/server:latest` - NetXMS monitoring server
- `ghcr.io/netxms/web:latest` - NetXMS web interface

Images are also tagged with specific NetXMS versions (e.g., `5.2.3`).

**Platform Support**: Currently, only `linux/amd64` platform is supported. ARM builds are in development but depend on official ARM packages being released for Debian, as these Docker images are based on Debian packages from the NetXMS repository.

Note: **NEVER** use `:latest` in the production, always pin specific release.

## Deployment

### Environment Setup

Create a `.env` file in the `deployment-example` directory:

```sh
# NetXMS version
NETXMS_VERSION=5.2.3

# Database configuration - these are specific for PostgreSQL official image.
POSTGRES_DB=netxms
POSTGRES_USER=netxms
POSTGRES_PASSWORD=your_secure_password

# Optional: Java options for web interface
JAVA_OPTIONS=-Xmx1g
```

Modify `compose.yaml` to your liking - change database engine, for example.

### Configuration

#### Server Configuration

Edit `conf/server/netxmsd.conf` to customize server settings.

Reference: [netxmsd.conf](https://netxms.org/documentation/adminguide/appendix.html#server-configuration-file-netxmsd-conf).

Minimal required configuration:

- Database driver and connection parameters
- Logging configuration
- Parameter `ManagementAgentAddress` should point to any agent instance, it will be used as a default for web services, ssh, etc.

#### Agent Configuration

Edit `conf/agent/nxagentd.conf` to configure the monitoring agent.

Reference: [netxmsd.conf](https://netxms.org/documentation/adminguide/appendix.html#agent-configuration-file-nxagentd-conf).

Minimal required configuration:

- Server connection settings

#### Web Interface

The web interface runs on port 8443 (HTTPS) by default, 8080 (HTTP) is also available, but not exposed in the provided compose.

To use custom SSL certificates, mount your keystore to `/var/lib/jetty/etc/keystore.p12` and set the `KEYSTORE_PASSWORD` environment variable:

```yaml
services:
  web:
    volumes:
      - /path/to/your/keystore.p12:/var/lib/jetty/etc/keystore.p12
    environment:
      - KEYSTORE_PASSWORD=your_keystore_password
```

## Database Operations

```sh
# Initialize database (done automatically)
docker compose run --rm init

# Check database status
docker compose run --rm check

# Upgrade database schema
docker compose run --rm upgrade

# Unlock database (if locked)
docker compose run --rm unlock
```

## Development

### Building Images

#### Local Development Builds

Build all components locally:

```sh
make all
```

Build individual components:

```sh
make agent
make server
make web
```

#### Automated Builds

Docker images are automatically built and published via GitHub Actions:

- **On push to master/main**: Images are built and pushed with both `latest` and version tag
- **On tag**: Images are built and tagged with the version number
- **On pull requests**: Images are built for testing (not published)

The workflow builds server and agent images for linux/amd64, and web images for both linux/amd64 and linux/arm64 platforms.

### Project Structure

```text
├── agent/                 # NetXMS agent container
│   ├── Dockerfile
│   └── files/
├── server/                # NetXMS server container
│   ├── Dockerfile
│   └── files/
├── web/                   # Web interface container
│   ├── Dockerfile
│   └── start.sh
├── deployment-example/    # Complete deployment example
│   ├── compose.yaml
│   └── conf/
├── build.properties       # Version configuration
└── Makefile               # Build automation
```

### Version Management

Versions are managed in `build.properties`:

- `NETXMS_VERSION`: Product version (e.g., `5.2.3`)
- `NETXMS_PACKAGE_VERSION`: Full Debian package version (e.g. `5.2.3-1+bookworm`)

To update versions:

1. Edit `build.properties`
2. Rebuild containers: `make all` and test
3. Push and tag with "release-" prefix: `release-5.2.3`

### Package Pinning

The build system uses APT package pinning to ensure version consistency:

- `pin-package-version` script generates pin files
- Pins are applied during container build
- Temporary pin files are cleaned after build

### Development Workflow

1. Make changes to Dockerfiles or configuration
2. Build affected components: `make <component>`
3. Test with deployment example: `cd deployment-example && docker compose up`
4. Verify functionality through web interface or API

### Troubleshooting

**Database connection issues:**

- Check PostgreSQL service health: `docker compose logs db`
- Verify database credentials in server configuration

**Web interface not accessible:**

- Check if port 8443 is available
- Review web container logs: `docker compose logs web`
- Verify SSL certificate configuration

**Agent connection problems:**

- Check network connectivity between agent and server
- Review agent logs for connection errors
- Verify server address in agent configuration

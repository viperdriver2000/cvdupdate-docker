# cvdupdate-docker

Local ClamAV signature mirror using [cvdupdate](https://github.com/Cisco-Talos/cvdupdate). Keeps virus definitions up to date and serves them via HTTP so your ClamAV instances can pull updates from your own network instead of hitting Cisco's CDN.

## Quick Start

```bash
docker run -d \
  --name cvdupdate \
  -p 8880:80 \
  -v cvdupdate-data:/var/www/clamav \
  ghcr.io/viperdriver2000/cvdupdate-docker
```

## Build

```bash
docker build -t cvdupdate-docker .
```

## Configuration

| Variable | Default | Description |
|---|---|---|
| `CVDUPDATE_DBDIR` | `/var/www/clamav` | Directory for ClamAV database files |
| `CRON_SCHEDULE` | `0 */4 * * *` | Update interval (default: every 4 hours) |

## Docker Compose

```yaml
services:
  cvdupdate:
    build: .
    container_name: cvdupdate
    ports:
      - "8880:80"
    volumes:
      - cvdupdate-data:/var/www/clamav
    environment:
      - CRON_SCHEDULE=0 */4 * * *
    restart: unless-stopped

volumes:
  cvdupdate-data:
```

## ClamAV Client Config

Point your ClamAV instances to the mirror by editing `freshclam.conf`:

```
DatabaseMirror http://<docker-host>:8880/clamav
```

## Endpoints

| Path | Description |
|---|---|
| `/clamav/` | Database files (directory listing) |
| `/healthz` | Health check |

## How It Works

1. On startup, `cvd update` downloads the latest ClamAV signatures
2. A cron job keeps the database current (default: every 4 hours)
3. nginx serves the files over HTTP for your ClamAV clients

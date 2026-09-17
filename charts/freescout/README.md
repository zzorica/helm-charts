# freescout helm chart

Helm chart for [Freescout](https://freescout.net/) - an opensource Helpdesk web app.

Chart is using the `nfrastack/freescout` container image - https://github.com/nfrastack/container-freescout
(successor of `tiredofit/freescout`, which has been removed from Docker Hub).

## Usage

```
helm repo add soultrace https://charts.soultrace.net
helm repo update
helm install freescout soultrace/freescout --set freescout.app_url=https://freescout.example.com
```

`freescout.app_url` is required by the image. When `ingress.enabled` is true and it is left
empty, the URL is derived from the first ingress host.

FreeScout `.env` settings can be passed through `freescoutConfig`, e.g.

```yaml
freescoutConfig:
  MAIL_DRIVER: smtp
  MAIL_HOST: postfix-relay
  MAIL_PORT: "25"
```

## Upgrading to chart 1.x (image 2.x)

Chart 1.0.0 switches from `tiredofit/freescout` 1.x to `nfrastack/freescout` 2.x. Back up the
database and the data volume first. See the image's
[upgrade notes](https://github.com/nfrastack/container-freescout#upgrading-from-1x).

- `freescout.site_url` is deprecated in favour of `freescout.app_url` (still accepted).
- `freescout.enable_ssl_proxy` was removed. Https is detected from `app_url`; proxies are trusted
  via `freescout.trusted_proxies` (default `**`).
- `freescout.enable_auto_update` now defaults to `true`. The application code lives in the image,
  so database migrations only run on image upgrades when this is enabled.
- The config file on the `/data` volume moves from `/data/config` to `/data/config/config`.
  The container migrates it automatically on first boot.
- Container logs are now written to `/logs` (mounted as an emptyDir).
- Chart 1.0.1 adds a startup probe (15 minutes by default, see `startupProbe`). Without it the
  liveness probe kills the container before the first-boot migrations finish and the pod crash
  loops. Liveness and readiness probes are configurable via `livenessProbe` / `readinessProbe`.

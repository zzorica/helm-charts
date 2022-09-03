# freescout helm chart

Helm chart for [Freescout](https://freescout.net/) - an opensource Helpdesk web app.

Chart is using `tiredofit/freescout` container image -  https://github.com/tiredofit/docker-freescout.

## Usage

```
helm repo add soultrace https://charts.soultrace.net
helm repo update
helm install freescout soultrace/freescout
```

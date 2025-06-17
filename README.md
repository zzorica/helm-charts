# Kubernetes Helm Charts

[![License](https://img.shields.io/github/license/zzorica/helm-charts?style=plastic)](https://opensource.org/licenses/MIT)

The code is provided as-is with no warranties.

## Usage

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```console
helm repo add soultrace https://charts.soultrace.net
```

You can then run `helm search repo soultrace` to see the charts.

## Available Charts

- [**Freescout Helm Chart**](charts/freescout): Easily deploy [Freescout](https://freescout.net) on your Kubernetes cluster.

- [**Vaultwarden Helm Chart**](charts/vaultwarden): Deploy [Vaultwarden](https://vaultwarden.dev/), a Bitwarden-compatible password management server, using Helm.

## License

[MIT License](https://github.com/zzorica/helm-charts/blob/main/LICENSE).

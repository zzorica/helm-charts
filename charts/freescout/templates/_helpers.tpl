{{/*
Expand the name of the chart.
*/}}
{{- define "freescout.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "freescout.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "freescout.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "freescout.labels" -}}
helm.sh/chart: {{ include "freescout.chart" . }}
{{ include "freescout.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "freescout.selectorLabels" -}}
app.kubernetes.io/name: {{ include "freescout.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "freescout.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "freescout.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Adjust ingress apiVersion depending on k8s version
*/}}
{{- define "freescout.ingress.apiVersion" -}}
{{- if semverCompare "<1.14-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "extensions/v1beta1" -}}
{{- else if semverCompare "<1.19-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "networking.k8s.io/v1beta1" -}}
{{- else -}}
{{- print "networking.k8s.io/v1" -}}
{{- end }}
{{- end -}}

{{/*
Resolve the external application URL (APP_URL). Order: freescout.app_url, deprecated
freescout.site_url, first ingress host. The image refuses to start without it.
*/}}
{{- define "freescout.appUrl" -}}
{{- if .Values.freescout.app_url -}}
{{- .Values.freescout.app_url -}}
{{- else if .Values.freescout.site_url -}}
{{- .Values.freescout.site_url -}}
{{- else if and .Values.ingress.enabled .Values.ingress.hosts -}}
{{- printf "http%s://%s" (ternary "s" "" (not (empty .Values.ingress.tls))) (index .Values.ingress.hosts 0).host -}}
{{- else -}}
{{- required "freescout.app_url must be set to the external URL of the site (e.g. https://freescout.example.com)" .Values.freescout.app_url -}}
{{- end -}}
{{- end -}}

{{/*
Hostname part of the application URL, used as Host header for probes since the image only
trusts requests for that host.
*/}}
{{- define "freescout.appHost" -}}
{{- (urlParse (include "freescout.appUrl" .)).host -}}
{{- end -}}

{{/*
httpGet block shared by the startup, liveness and readiness probes. The image only serves
requests for the configured host and redirects http to https when APP_URL is https.
*/}}
{{- define "freescout.probeHttpGet" -}}
path: /login
port: http
httpHeaders:
  - name: Host
    value: {{ include "freescout.appHost" . | quote }}
  {{- if hasPrefix "https://" (include "freescout.appUrl" .) }}
  - name: X-Forwarded-Proto
    value: https
  {{- end }}
{{- end -}}

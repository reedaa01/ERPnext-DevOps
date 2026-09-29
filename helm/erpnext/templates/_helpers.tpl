{{- define "erpnext.labels" -}}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: erpnext
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{- end }}

{{- define "erpnext.image" -}}
{{ printf "%s:%s" .Values.global.image.repository .Values.global.image.tag }}
{{- end }}

{{- define "erpnext.sitesMountPath" -}}
/home/frappe/frappe-bench/sites
{{- end }}

{{- /* Stops the script when gh has no login. The rendered text changes after login, so chezmoi runs the script again. */ -}}
{{- if not (and (lookPath "gh") (eq (output "sh" "-c" "gh auth token >/dev/null 2>&1 && echo yes || echo no" | trim) "yes")) }}
echo "Skipping: gh is not authenticated. Run 'gh auth login' and 'chezmoi apply' again." >&2
exit 0
{{- end -}}

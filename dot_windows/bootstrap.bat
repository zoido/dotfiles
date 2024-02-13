winget install --accept-package-agreements --accept-source-agreements twpayne.chezmoi
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
chezmoi init --apply zoido

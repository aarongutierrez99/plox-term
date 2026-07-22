# plox-term · fonts/install.ps1 — instala JetBrains Mono Nerd Font en Windows
# (por usuario, sin admin). Ejecutar:  powershell -ExecutionPolicy Bypass -File install.ps1
$ErrorActionPreference = "Stop"
$url  = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
$tmp  = Join-Path $env:TEMP ("JBMNerd_" + [guid]::NewGuid())
$zip  = "$tmp.zip"
$dest = Join-Path $env:LOCALAPPDATA "Microsoft\Windows\Fonts"

Write-Host ":: Descargando JetBrains Mono Nerd Font..."
Invoke-WebRequest -Uri $url -OutFile $zip
Expand-Archive -Path $zip -DestinationPath $tmp -Force
New-Item -ItemType Directory -Force -Path $dest | Out-Null

$reg = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"
Get-ChildItem "$tmp\*.ttf" | ForEach-Object {
  Copy-Item $_.FullName $dest -Force
  New-ItemProperty -Path $reg -Name ($_.BaseName + " (TrueType)") -Value $_.Name -PropertyType String -Force | Out-Null
}
Remove-Item $zip, $tmp -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "ok  JetBrains Mono Nerd Font instalada (reiniciá WezTerm)."

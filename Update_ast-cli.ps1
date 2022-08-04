#Set the repo for the AST CLI
$repo = "Checkmarx/ast-cli"

#Set location of cx.exe
$home_dir = ""
Set-Location -Path $home_dir

#Get the current version of the cli
$current_version = .\cx version

#Get the latest version of the release
$releases = "https://api.github.com/repos/$repo/releases/latest"
$tag = (Invoke-WebRequest $releases | ConvertFrom-Json)[0].tag_name

#Determine if new version available and exit if not
$newer = [version]$tag -gt [version] $current_version
if (!$newer) { return }

#Downlaod latest version
$file = "ast-cli_${tag}_windows_x64.zip"
$download = "https://github.com/$repo/releases/download/$tag/$file"
Invoke-WebRequest $download -OutFile "$home_dir\$file"

Write-Host Extracting release files
Expand-Archive $file -DestinationPath $home_dir -Force

#Delete downloaded zip
Remove-Item $file -Recurse -Force -ErrorAction SilentlyContinue

#log changes
$datetime = Get-Date -Format G
"$datetime`t`tcx.exe updated to version $tag" | Out-File -FilePath "$home_dir\update_log.txt" -append
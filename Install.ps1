$powershell_modules_path = $Env:PSModulePath -split ";" | Select-Object -First 1

$is_path_valid = Test-Path $powershell_modules_path

if (-not $is_path_valid) {
    Write-Host "PowerShell modules path is not valid, exiting ..."

    Exit 1
}


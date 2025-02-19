$Language = "en"

function Get-LocalizedText {
    param(
        [string]$Key
    )

    $Translations = @{
        en = @{
            SelectLanguage                      = "Select language (en/sl)"
            Hello                               = "Hello!"
            DockerCheck                         = "⌛ Checking if Docker is installed..."
            DockerInstalled                     = "✅ Docker is installed."
            DockerNotInstalled                  = "❌ Docker is not installed or not running."
            DockerInstallPrompt                 = "⚠️ Please install Docker and run this script again."
            BCContainerHelperCheck              = "⌛ Checking if BCContainerHelper is installed..."
            BCContainerHelperNotInstalled       = "❌ BCContainerHelper is not installed."
            BCContainerHelperInstalling         = "⌛ Installing BCContainerHelper..."
            BCContainerHelperInstalled          = "✅ BCContainerHelper is installed."
            BCContainerHelperInstallationFailed = "❌ BCContainerHelper installation failed."
            CheckingPermissions                 = "⌛ Checking permissions..."
            CheckingPermissionsSuccess          = "✅ Permissions are set correctly."
            CheckingPermissionsFailed           = "❌ Checking permissions failed."
            ContainerName                       = "Enter container name"
            LicenseFile                         = "Enter license file path"
            LicenseFileInvalidPath              = "❌ License file path is invalid. Please enter a valid path."
            Version                             = "Enter the version of BC. The version must match the version of the database back-up. The pattern is XX.YY (e.g. 12.1)"
            AuthenticationType                  = "Select the authentication type. The authentication can be password or windows. Enter (pwd/win)"
            UsernamePassword                    = "Enter a username and password"
            DatabaseType                        = "Select the database type. The database type can be a bak file or SQL Server. Enter (bak/sqls)"
            BakPath                             = "Enter a path for the .bak file"
            BakInvalidPath                      = "❌ Bak path is invalid. Please enter a valid path."
            DatabaseServer                      = "Enter the database server"
            DatabaseInstance                    = "Enter the database instance"
            DatabaseName                        = "Enter the database name"
            DatabaseCredential                  = "Enter the database credential"
            ShouldExposePorts                   = "Should the ports be exposed? By enabling this, BC will be accessible from outside the container. For example, you can share the container with your colleagues. Select (y/n)"
            ShouldIncludeTestToolKit            = "Should the Test Tool Kit be included? By enabling this, the Test Tool Kit will be installed. Select (y/n)"
            RemoveExisitingBCContainer          = "Remove existing BC container? Select (y/n)"
            RemovingExistingContainer           = "⌛ Removing existing container..."
            RemovingExistingContainerSuccess    = "✅ Existing container removed."
            RemovingExistingContainerFailed     = "❌ Failed to remove existing container."
        }
        sl = @{
            Hello                               = "Pozdravljeni!"
            DockerCheck                         = "⌛ Preverjamo, ali je Docker nameščen ..."
            DockerInstalled                     = "✅ Docker je nameščen."
            DockerNotInstalled                  = "❌ Docker ni nameščen ali ne deluje."
            DockerInstallPrompt                 = "⚠️ Prosimo, namestite Docker in ponovno zaženite ta skript."
            BCContainerHelperCheck              = "⌛ Preverjamo, ali je BCContainerHelper nameščen ..."
            BCContainerHelperNotInstalled       = "❌ BCContainerHelper ni nameščen."
            BCContainerHelperInstalling         = "⌛ Nameščam BCContainerHelper ..."
            BCContainerHelperInstalled          = "✅ BCContainerHelper je nameščen."
            BCContainerHelperInstallationFailed = "❌ Prišlo je do napake pri namestitvi BCContainerHelper."
            CheckingPermissions                 = "⌛ Preverjamo dovoljenja ..."
            CheckingPermissionsSuccess          = "✅ Dovoljenja so nameščena pravilno."
            CheckingPermissionsFailed           = "❌ Prišlo je do napake pri preverjanju dovoljenj."
            ContainerName                       = "Vnesite ime kontejnera"
            LicenseFile                         = "Vnesite pot do licence"
            LicenseFileInvalidPath              = "❌ Pot do licence ni veljavna. Vnesite veljavno pot."
            Version                             = "Vnesite različico BC. Različica se mora ujemati z različico iz backup-a podatkovne baze. Oblika je XX.YY (npr. 12.1)"
            AuthenticationType                  = "Izberite vrsto avtentikacije. Avtentikacija lahko je geslo ali windows. Vnesite (pwd/win)"
            UsernamePassword                    = "Vnesite uporabniško ime in geslo"
            DatabaseType                        = "Izberite vrsto podatkovne baze. Podatkovna baza lahko je datoteka .bak ali SQL Server. Vnesite (bak/sqls)"
            BakPath                             = "Vnesite pot do .bak datoteke"
            BakInvalidPath                      = "❌ Pot do .bak datoteke ni veljavna. Vnesite veljavno pot."
            DatabaseServer                      = "Vnesite ime strežnika podatkovne baze"
            DatabaseInstance                    = "Vnesite ime instance podatkovne baze"
            DatabaseName                        = "Vnesite ime podatkovne baze"
            DatabaseCredential                  = "Vnesite uporabniško ime in geslo za podatkovno bazo"
            ShouldExposePorts                   = "Naj so porti odprti? Če so odprti, bo BC dostopen na lokalnem omrežju. Na primer, lahko delite kontejner z vašimi kolegi. Izberite (y/n)"
            ShouldIncludeTestToolKit            = "Naj je Test Tool Kit vključen? Če je vključen, bo Test Tool Kit nameščen. Izberite (y/n)"
            RemoveExisitingBCContainer          = "Izbrišemo obstoječi BC kontejner? Izberite (y/n)"
            RemovingExistingContainer           = "⌛ Odstranjevanje obstoječega kontejnera..."
            RemovingExistingContainerSuccess    = "✅ Obstoječi kontejner odstranjen."
            RemovingExistingContainerFailed     = "❌ Odstranitev obstoječega kontejnera ni uspela."
        }
    }

    if ($Translations.ContainsKey($Language) -and $Translations[$Language].ContainsKey($Key)) {
        return $Translations[$Language][$Key]
    }
    else {
        return $Translations.en[$Key]
    }
}

function Get-ParsedInput {
    param(
        [string]$prompt
    )

    $user_input = Read-Host -Prompt $prompt

    while ($user_input -eq "") {
        $user_input = Read-Host -Prompt $prompt
    }

    return $user_input
}

function Get-ParsedInputWithPattern {
    param(
        [string]$prompt,
        [string]$pattern
    )

    $user_input = Read-Host -Prompt $prompt

    while (-not ($user_input -match $pattern)) {
        $user_input = Read-Host -Prompt $prompt
    }

    return $user_input
}

function Get-ParsedInputWithOptions {
    param(
        [string]$prompt,
        [string[]]$options
    )

    $user_input = Read-Host -Prompt ($prompt)

    while (-not ($user_input -in $options)) {
        $user_input = Read-Host -Prompt ($prompt)
    }

    return $user_input
}

function Get-ValidatedPath {
    param(
        [string]$prompt,
        [string]$path_not_found
    )
    
    $path = Read-Host -Prompt $prompt

    while (-not (Test-Path $path)) { 
        Write-Host $path_not_found -ForegroundColor Red

        $path = Read-Host -Prompt $prompt
    }

    return $path
}

if ($null -eq $Env:BSLLanguage) {
    $Language = Get-ParsedInputWithOptions -prompt (Get-LocalizedText -Key "SelectLanguage") -options ("en", "sl")

    $Env:BSLLanguage = $Language
}
else {
    $Language = $Env:BSLLanguage
}

Write-Host (Get-LocalizedText -Key "Hello") -ForegroundColor White

Write-Host (Get-LocalizedText -Key "DockerCheck") -ForegroundColor White

try {
    docker info | Out-Null
    $dockerInstalled = $true
}
catch {
    $dockerInstalled = $false
}

if (-not $dockerInstalled) {
    Write-Host (Get-LocalizedText -Key "DockerNotInstalled") -ForegroundColor Red
    Write-Host (Get-LocalizedText -Key "DockerInstallPrompt") -ForegroundColor Red
    Exit 1
}

Write-Host (Get-LocalizedText -Key "DockerInstalled") -ForegroundColor Green

Write-Host (Get-LocalizedText -Key "BCContainerHelperCheck") -ForegroundColor White

$bc_container_helper = Get-InstalledModule -Name "BCContainerHelper"

if ($null -eq $bc_container_helper) {
    Write-Host (Get-LocalizedText -Key "BCContainerHelperNotInstalled") -ForegroundColor White

    try {
        Write-Host (Get-LocalizedText -Key "BCContainerHelperInstalling") -ForegroundColor White
    
        Install-PackageProvider -Name NuGet -Force
        Install-Module BcContainerHelper -Force
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
    
        Write-Host (Get-LocalizedText -Key "BCContainerHelperInstalled") -ForegroundColor White
    }
    catch {
        Write-Host (Get-LocalizedText -Key "BCContainerHelperInstallationFailed") -ForegroundColor Red
        Exit 1
    }
}
else {
    Write-Host (Get-LocalizedText -Key "BCContainerHelperInstalled") -ForegroundColor Green
}

try {
    Write-Host (Get-LocalizedText -Key "CheckingPermissions") -ForegroundColor White

    Check-BcContainerHelperPermissions -Fix

    Write-Host (Get-LocalizedText -Key "CheckingPermissionsSuccess") -ForegroundColor Green
}
catch {
    Write-Host (Get-LocalizedText -Key "CheckingPermissionsFailed") -ForegroundColor Red

    Write-Host $_.Exception.Message -ForegroundColor Red

    Exit 1
}

$container_name = Get-ParsedInput -prompt (Get-LocalizedText -Key "ContainerName")

$license_file = Get-ValidatedPath -prompt (Get-LocalizedText -Key "LicenseFile") -path_not_found (Get-LocalizedText -Key "LicenseFileInvalidPath")

$version = Get-ParsedInputWithPattern -prompt (Get-LocalizedText -Key "Version") -pattern "^\d+\.\d+$"

$authentication_type = Get-ParsedInputWithOptions -prompt (Get-LocalizedText -Key "AuthenticationType") -options ("pwd", "win")

if ($authentication_type -eq "win") {
    $auth = "Windows"
}
else {
    try {
        Write-Host (Get-LocalizedText -Key "UsernamePassword")

        $credential = Get-Credential -Message (Get-LocalizedText -Key "UsernamePassword")
    
        $auth = "UserPassword"
    }
    catch {
        Write-Host $_.Exception.Message -ForegroundColor Red
        Exit 1
    }
}

$database_type = Get-ParsedInputWithOptions -prompt (Get-LocalizedText -Key "DatabaseType") -options ("bak", "sqls")

if ($database_type -eq "bak") {
    $backup_file = Get-ValidatedPath -prompt (Get-LocalizedText -Key "BakPath") -path_not_found (Get-LocalizedText -Key "BakInvalidPath")
}
else {
    $database_server = Get-ParsedInput -prompt (Get-LocalizedText -Key "DatabaseServer")

    $database_instance = Get-ParsedInput -prompt (Get-LocalizedText -Key "DatabaseInstance")

    $database_name = Get-ParsedInput -prompt (Get-LocalizedText -Key "DatabaseName")

    $database_credential = Get-Credential -Message (Get-LocalizedText -Key "DatabaseCredential")
}

$should_expose_ports = Get-ParsedInputWithOptions -prompt (Get-LocalizedText -Key "ShouldExposePorts") -options ("y", "n")

$should_include_test_tool_kit = Get-ParsedInputWithOptions -prompt (Get-LocalizedText -Key "ShouldIncludeTestToolKit") -options ("y", "n")

try {
    docker inspect $container_name 2>$null | Out-Null

    $does_container_exist = $True
}
catch {
    $does_container_exist = $False
}

if ($does_container_exist) {
    $should_remove_existing_container = Get-ParsedInputWithOptions -prompt (Get-LocalizedText -Key "RemoveExisitingBCContainer") -options ("y", "n")

    if ($should_remove_existing_container -eq "y") {
        try {
            Write-Host (Get-LocalizedText -Key "RemovingExistingContainer") -ForegroundColor White
    
            Remove-BcContainer $container_name
        
            Write-Host (Get-LocalizedText -Key "RemovingExistingContainerSuccess") -ForegroundColor Green
        }
        catch {
            Write-Host (Get-LocalizedText -Key "RemovingExistingContainerFailed") -ForegroundColor Red

            Write-Host $_.Exception.Message -ForegroundColor Red

            Exit 1
        }
    }
}

$artifact_url = Get-BCArtifactUrl -select Latest -type OnPrem -country w1 -version $version

if ($database_type -eq "bak") {
    New-BCContainer `
        -accept_eula `
        -accept_outdated `
        -isolation process `
        -containerName $container_name `
        -imageName $container_name.ToLower() `
        -enableTaskScheduler `
        -artifactUrl $artifact_url `
        -credential $credential `
        -auth $auth `
        -updateHosts `
        -licenseFile $license_file `
        -bakFile $backup_file `

}
else {
    New-BcContainer `
        -accept_eula `
        -accept_outdated `
        -isolation process `
        -containerName $container_name `
        -imageName $container_name.ToLower() `
        -enableTaskScheduler `
        -artifactUrl $artifact_url `
        -credential $credential `
        -auth $auth `
        -updateHosts `
        -licenseFile $license_file `
        -databaseServer $database_server -databaseInstance $database_instance -databaseName $database_name `
        -databaseCredential $database_credential `

}

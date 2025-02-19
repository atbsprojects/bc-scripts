$Language = "en"
function Get-LocalizedText {
    param(
        [string]$Key
    )

    $Translations = @{
        en = @{
            Hello                               = "Hello!"
            DockerCheck                         = "Checking if Docker is installed..."
            DockerNotInstalled                  = "Docker is not installed or not running."
            DockerInstallPrompt                 = "Please install Docker and run this script again."
            BCContainerHelperCheck              = "Checking if BCContainerHelper is installed..."
            BCContainerHelperNotInstalled       = "BCContainerHelper is not installed. Installing..."
            BCContainerHelperInstalling         = "Installing BCContainerHelper..."
            BCContainerHelperInstalled          = "BCContainerHelper is installed."
            BCContainerHelperInstallationFailed = "BCContainerHelper installation failed."
            CheckingPermissions                 = "Checking permissions..."
            CheckingPermissionsFailed           = "Checking permissions failed."
            ContainerName                       = "Enter container name"
            LicenseFile                         = "Enter license file path"
            Version                             = "Enter the version of BC. The version must match the version of the database back-up"
            AuthenticationType                  = "Select the authentication type. The authentication can be password or windows. Enter (pwd/win)"
            UsernamePassword                    = "Enter a username and password"
            DatabaseType                        = "Select the database type. The database type can be a bak file or SQL Server. Enter (bak/sqls)"
            BakPath                             = "Enter a path for the .bak file"
            DatabaseServer                      = "Enter the database server"
            DatabaseInstance                    = "Enter the database instance"
            DatabaseName                        = "Enter the database name"
            DatabaseCredential                  = "Enter the database credential"
            ShouldExposePorts                   = "Should the ports be exposed? By enabling this, BC will be accessible from outside the container. For example, you can share the container with your colleagues. Select (Y/N)"
            ShouldIncludeTestToolKit            = "Should the Test Tool Kit be included? By enabling this, the Test Tool Kit will be installed. Select (Y/N)"
            RemoveExisitingBCContainer          = "Remove existing BC container? Select (Y/N)"
        }
        sl = @{
            Hello                               = "Pozdravljen!"
            DockerCheck                         = "Preverjam, ali je Docker nameščen..."
            DockerNotInstalled                  = "Docker ni nameščen ali ne deluje."
            DockerInstallPrompt                 = "Prosim, namestite Docker in ponovno zaženite ta skript."
            BCContainerHelperCheck              = "Preverjam, ali je BCContainerHelper nameščen..."
            BCContainerHelperNotInstalled       = "BCContainerHelper ni nameščen. Nameščam..."
            BCContainerHelperInstalling         = "Nameščam BCContainerHelper..."
            BCContainerHelperInstalled          = "BCContainerHelper je nameščen."
            BCContainerHelperInstallationFailed = "Prišlo je do napake pri namestitvi BCContainerHelper."
            CheckingPermissions                 = "Preverjam dovoljenja..."
            CheckingPermissionsFailed           = "Prišlo je do napake pri preverjanju dovoljenj."
            ContainerName                       = "Vnesite ime kontejnera"
            LicenseFile                         = "Vnesite pot do licence"
            Version                             = "Vnesite različico BC. Različica se mora ujemati z različico iz backup-a podatkovne baze"
            AuthenticationType                  = "Izberite vrsto avtentikacije. Avtentikacija lahko je geslo ali windows. Vnesite (pwd/win)"
            UsernamePassword                    = "Vnesite uporabniško ime in geslo"
            DatabaseType                        = "Izberite vrsto podatkovne baze. Podatkovna baza lahko je datoteka .bak ali SQL Server. Vnesite (bak/sqls)"
            BakPath                             = "Vnesite pot do .bak datoteke"
            DatabaseServer                      = "Vnesite ime strežnika podatkovne baze"
            DatabaseInstance                    = "Vnesite ime instance podatkovne baze"
            DatabaseName                        = "Vnesite ime podatkovne baze"
            DatabaseCredential                  = "Vnesite uporabniško ime in geslo za podatkovno bazo"
            ShouldExposePorts                   = "Naj so porti odprti? Če so odprti, bo BC dostopen na lokalnem omrežju. Na primer, lahko delite kontejner z vašimi kolegi. Izberite (Y/N)"
            ShouldIncludeTestToolKit            = "Naj bo Test Tool Kit vključen? Če je vključen, bo Test Tool Kit nameščen. Izberite (Y/N)"
            RemoveExisitingBCContainer          = "Remove existing BC container? Select (Y/N)"
        }
    }

    if ($Translations.ContainsKey($Language) -and $Translations[$Language].ContainsKey($Key)) {
        return $Translations[$Language][$Key]
    }
    else {
        return $Translations.en[$Key]
    }
}

$LanguageChoice = Read-Host "Select language (en/sl)"
if ($LanguageChoice -in ("en", "sl")) {
    $Language = $LanguageChoice
}
else {
    Write-Warning "Invalid language choice. Using default (English)."
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

Write-Host (Get-LocalizedText -Key "CheckingPermissions") -ForegroundColor White

try {
    Write-Host (Get-LocalizedText -Key "CheckingPermissions") -ForegroundColor White

    Check-BcContainerHelperPermissions -Fix
}
catch {
    Write-Host (Get-LocalizedText -Key "CheckingPermissionsFailed") -ForegroundColor Red

    Write-Host $_.Exception.Message -ForegroundColor Red
}

$container_name = Read-Host -Prompt (Get-LocalizedText -Key "ContainerName")

while ($container_name -eq "") {
    $container_name = Read-Host -Prompt (Get-LocalizedText -Key "ContainerName")
}

$license_file = Read-Host -Prompt (Get-LocalizedText -Key "LicenseFile")

while ($license_file -eq "") {
    $license_file = Read-Host -Prompt (Get-LocalizedText -Key "LicenseFile")

    # check if path is valid, if file exists, if file is .bclicense actually
}

$version = Read-Host -Prompt (Get-LocalizedText -Key "Version")

while ($version -eq "") {
    $version = Read-Host -Prompt (Get-LocalizedText -Key "Version")
}

$authentication_type = Read-Host -Prompt (Get-LocalizedText -Key "AuthenticationType")

while (-not ($authentication_type -in @("pwd", "win"))) {
    $authentication_type = Read-Host -Prompt (Get-LocalizedText -Key "AuthenticationType")
}

if ($authentication_type -eq "win") {
    $auth = "Windows"
}
else {
    Write-Host (Get-LocalizedText -Key "UsernamePassword")

    $credential = Get-Credential -Message (Get-LocalizedText -Key "UsernamePassword")

    $auth = "UserPassword"
}

$database_type = Read-Host -Prompt (Get-LocalizedText -Key "DatabaseType")

while (-not ($database_type -in @("bak", "sqls"))) {
    $database_type = Read-Host -Prompt (Get-LocalizedText -Key "DatabaseType")
}

if ($database_type -eq "bak") {
    $backup_file = Read-Host -Prompt (Get-LocalizedText -Key "BakPath")

    while ($backup_file -eq "") {
        $backup_file = Read-Host -Prompt (Get-LocalizedText -Key "BakPath")   
    }
}
else {
    $database_server = Read-Host -Prompt (Get-LocalizedText -Key "DatabaseServer")

    while ($database_server -eq "") {
        $database_server = Read-Host -Prompt (Get-LocalizedText -Key "DatabaseServer")   
    }

    $database_instance = Read-Host -Prompt (Get-LocalizedText -Key "DatabaseInstance")

    while ($database_instance -eq "") {
        $database_instance = Read-Host -Prompt (Get-LocalizedText -Key "DatabaseInstance")   
    }

    $database_name = Read-Host -Prompt (Get-LocalizedText -Key "DatabaseName")

    while ($database_name -eq "") {
        $database_name = Read-Host -Prompt (Get-LocalizedText -Key "DatabaseName")   
    }

    $database_credential = Get-Credential -Message (Get-LocalizedText -Key "DatabaseCredential")
}

$should_expose_ports = Read-Host -Prompt (Get-LocalizedText -Key "ShouldExposePorts")

while ($should_expose_ports -eq "" -or $should_expose_ports -ne "Y" -and $should_expose_ports -ne "N") {
    $should_expose_ports = Read-Host -Prompt (Get-LocalizedText -Key "ShouldExposePorts")
}

$should_include_test_tool_kit = Read-Host -Prompt (Get-LocalizedText -Key "ShouldIncludeTestToolKit")

while ($should_include_test_tool_kit -eq "" -or $should_include_test_tool_kit -ne "Y" -and $should_include_test_tool_kit -ne "N") {
    $should_include_test_tool_kit = Read-Host -Prompt (Get-LocalizedText -Key "ShouldIncludeTestToolKit")
}

# check if container exists

$should_remove_existing_container = Read-Host -Prompt (Get-LocalizedText -Key "RemoveExisitingBCContainer")

while ($should_remove_existing_container -eq "" -or $should_remove_existing_container -ne "Y" -and $should_remove_existing_container -ne "N") {
    $should_remove_existing_container = Read-Host -Prompt (Get-LocalizedText -Key "RemoveExisitingBCContainer")
}

if ($should_remove_existing_container -eq "Y") {
    Remove-BcContainer $container_name
}

$artifact_url = Get-BCArtifactUrl -select Latest -type OnPrem -country w1 -version $version

Remove-BcContainer $container_name

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
        -additionalParameters $additionalParameters
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

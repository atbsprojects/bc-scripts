$ModulesPath = Split-Path -parent $MyInvocation.MyCommand.Definition

Import-Module "$ModulesPath\InputHelpers.psm1"

$Script:Language = "en"

$Script:Translations = @{
    en = @{
        SelectLanguage                      = "Select language (en/sl)"
        Hello                               = "Hello!"
        DockerCheck                         = "⌛ Checking if Docker is installed..."
        DockerInstalled                     = "✅ Docker is installed."
        DockerNotInstalled                  = "❌ Docker is not installed or not running."
        DockerInstallPrompt                 = "⚠️ Please install or start Docker and run this script again."
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
        IPAddressGetFailed                  = "We were not able to get the IP address."
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
        DockerInstallPrompt                 = "⚠️ Prosimo, namestite ali zaženite Docker in ponovno zaženite ta skript."
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
        IPAddressGetFailed                  = "❌ Pridobivanje IP naslova ni uspelo. Preverite, ali je strežnik omrežja zagotovljen."
        ShouldIncludeTestToolKit            = "Naj je Test Tool Kit vključen? Če je vključen, bo Test Tool Kit nameščen. Izberite (y/n)"
        RemoveExisitingBCContainer          = "Izbrišemo obstoječi BC kontejner? Izberite (y/n)"
        RemovingExistingContainer           = "⌛ Odstranjevanje obstoječega kontejnera..."
        RemovingExistingContainerSuccess    = "✅ Obstoječi kontejner odstranjen."
        RemovingExistingContainerFailed     = "❌ Odstranitev obstoječega kontejnera ni uspela."
    }
}
function Set-Language {
    param(
        [ValidateSet("en", "sl")]
        [string]$LanguageCode
    )
        
    $Script:Language = $LanguageCode
    $Env:BSLLanguage = $LanguageCode
}
function Get-CurrentLanguage {
    return $Script:Language
}
function Get-LocalizedText {
    param(
        [string]$Key
    )
    
    if ($Script:Translations.ContainsKey($Script:Language) -and $Script:Translations[$Script:Language].ContainsKey($Key)) {
        return $Script:Translations[$Script:Language][$Key]
    }
    else {
        return $Script:Translations.en[$Key]
    }
}
function Initialize-Language {
    if ([string]::IsNullOrWhiteSpace($Env:BSLLanguage)) {
        $SelectedLanguage = Get-ParsedInputWithOptions -prompt (Get-LocalizedText -Key "SelectLanguage") -options ("en", "sl")
        Set-Language -LanguageCode $SelectedLanguage
    }
    else {
        Set-Language -LanguageCode $Env:BSLLanguage
    }
}
    
Export-ModuleMember -Function Set-Language, Get-CurrentLanguage, Get-LocalizedText, Initialize-Language
function New-BSLBCContainer {    
    Initialize-Language
    
    $container_parameters = @{
        accept_eula          = $True
        accept_outdated      = $True
        containerName        = ""
        imageName            = ""
        enableTaskScheduler  = $True
        updateHosts          = $True
        licenseFile          = ""
        bakFile              = ""
        additionalParameters = @()
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
    
    $container_parameters.containerName = $container_name
    
    $license_file = Get-ValidatedPath -prompt (Get-LocalizedText -Key "LicenseFile") -path_not_found (Get-LocalizedText -Key "LicenseFileInvalidPath")
    
    $container_parameters.licenseFile = $license_file
    
    $version = Get-ParsedInputWithPattern -prompt (Get-LocalizedText -Key "Version") -pattern "^\d+\.\d+$"
    
    $authentication_type = Get-ParsedInputWithOptions -prompt (Get-LocalizedText -Key "AuthenticationType") -options ("pwd", "win")
    
    if ($authentication_type -eq "win") {
        $container_parameters.auth = "Windows"
    }
    else {
        try {
            Write-Host (Get-LocalizedText -Key "UsernamePassword")
    
            $credential = Get-Credential -Message (Get-LocalizedText -Key "UsernamePassword")
    
            while ($credential -eq [System.Management.Automation.PSCredential]::Empty) {
                $credential = Get-Credential -Message (Get-LocalizedText -Key "UsernamePassword")
            }
            
            $container_parameters.auth = "UserPassword"
            $container_parameters.credential = $credential
        }
        catch {
            Write-Host $_.Exception.Message -ForegroundColor Red
            Exit 1
        }
    }
    
    $database_type = Get-ParsedInputWithOptions -prompt (Get-LocalizedText -Key "DatabaseType") -options ("bak", "sqls")
    
    if ($database_type -eq "bak") {
        $backup_file = Get-ValidatedPath -prompt (Get-LocalizedText -Key "BakPath") -path_not_found (Get-LocalizedText -Key "BakInvalidPath")
    
        $container_parameters.bakFile = $backup_file
    }
    else {
        $database_server = Get-ParsedInput -prompt (Get-LocalizedText -Key "DatabaseServer")
    
        $database_instance = Get-ParsedInput -prompt (Get-LocalizedText -Key "DatabaseInstance")
    
        $database_name = Get-ParsedInput -prompt (Get-LocalizedText -Key "DatabaseName")
    
        $database_credential = Get-Credential -Message (Get-LocalizedText -Key "DatabaseCredential")
    
        while ($database_credential -eq [System.Management.Automation.PSCredential]::Empty) {
            $credential = Get-Credential -Message (Get-LocalizedText -Key "DatabaseCredential")
        }
    
        $container_parameters.databaseServer = $database_server
        $container_parameters.databaseInstance = $database_instance
        $container_parameters.databaseName = $database_name
        $container_parameters.databaseCredential = $database_credential
    }
    
    $should_expose_ports = Get-ParsedInputWithOptions -prompt (Get-LocalizedText -Key "ShouldExposePorts") -options ("y", "n")
    
    if ($should_expose_ports -eq "y") {
        $ipAddress = Get-IpAddress
    
        if ($ipAddress -eq 0) {
            Write-Host (Get-LocalizedText -Key "IPAddressGetFailed") -ForegroundColor Red
    
            Exit 1
        }
        
        $port = 4320
    
        while (-not (Test-NetConnection -ComputerName $ipAddress -Port $port)) {
            Write-Host "Port $port is not available, trying next port ..."
    
            $port++
        }
    
        $container_parameters.additionalParameters += "--publish $port" + ":80"
    }
    
    $should_include_test_tool_kit = Get-ParsedInputWithOptions -prompt (Get-LocalizedText -Key "ShouldIncludeTestToolKit") -options ("y", "n")
    
    if ($should_include_test_tool_kit) {
        $container_parameters.includeTestToolkit = $True
    }
    
    $artifact_url = Get-BCArtifactUrl -select Latest -type OnPrem -country w1 -version $version
    
    $container_parameters.artifactUrl = $artifact_url
    
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
    
    New-BCContainer @container_parameters
}

Export-ModuleMember -Function New-BSLBCContainer
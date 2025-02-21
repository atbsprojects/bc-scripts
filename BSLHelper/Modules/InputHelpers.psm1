function Get-ParsedInput {
    param(
        [string]$prompt
    )

    $user_input = Read-Host -Prompt $prompt

    while ([string]::IsNullOrWhiteSpace($user_input)) {
        $user_input = Read-Host -Prompt $prompt
    }

    return $user_input
}

function Get-ParsedInputWithOptions {
    param(
        [string]$prompt,
        [string[]]$options
    )

    $user_input = Read-Host -Prompt $prompt

    while ([string]::IsNullOrWhiteSpace($user_input) -or -not ($options -contains $user_input.ToLower())) {
        $user_input = Read-Host -Prompt $prompt
    }

    return $user_input.ToLower()
}

function Get-ParsedInputWithPattern {
    param(
        [string]$prompt,
        [string]$pattern
    )

    $user_input = Read-Host -Prompt $prompt

    while ([string]::IsNullOrWhiteSpace($user_input) -or -not ($user_input -match $pattern)) {
        $user_input = Read-Host -Prompt $prompt
    }

    return $user_input
}

function Get-ValidatedPath {
    param(
        [string]$prompt,
        [string]$path_not_found
    )

    $path = Read-Host -Prompt $prompt

    while ([string]::IsNullOrWhiteSpace($path) -or -not (Test-Path $path)) {
        Write-Host $path_not_found -ForegroundColor Red
        $path = Read-Host -Prompt $prompt
    }

    return $path
}

Export-ModuleMember -Function Get-ParsedInput, Get-ParsedInputWithOptions, Get-ParsedInputWithPattern, Get-ValidatedPath
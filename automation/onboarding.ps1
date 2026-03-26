param(
    [Parameter(Mandatory = $true)]
    [string]$FirstName,

    [Parameter(Mandatory = $true)]
    [string]$LastName,

    [Parameter(Mandatory = $true)]
    [string]$JobTitle
)

Import-Module ActiveDirectory

# ==========================
# Logging setup
# =========================

$LogFolder = "C:\Logs"

if (-not (Test-Path $LogFolder)) {
    New-Item -Path $LogFolder -ItemType Directory -Force | Out-Null
}

$TimeStamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$LogFile = Join-Path $LogFolder "onboarding_$TimeStamp $FirstName $LastName.txt"

function Write-Log {
    param(
        [string]$Message,
        [ValidateSet("INFO","SUCCESS","WARNING","ERROR")]
        [string]$Level = "INFO"
    )

    $Line = "{0} [{1}] {2}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Level, $Message
    Add-Content -Path $LogFile -Value $Line

    switch ($Level) {
        "INFO"    { Write-Host $Line -ForegroundColor Cyan }
        "SUCCESS" { Write-Host $Line -ForegroundColor Green }
        "WARNING" { Write-Host $Line -ForegroundColor Yellow }
        "ERROR"   { Write-Host $Line -ForegroundColor Red }
    }
}

Write-Log "========== SCRIPT START =========="
Write-Log "Input received - FirstName: $FirstName | LastName: $LastName | JobTitle: $JobTitle"

# ========================
# the helper functions
# =========================

function New-UniqueSamAccountName {
    param(
        [Parameter(Mandatory = $true)]
        [string]$GivenName,

        [Parameter(Mandatory = $true)]
        [string]$Surname
    )

    $baseSam = ($GivenName.Substring(0,1) + $Surname).ToLower()
    $baseSam = $baseSam -replace "[^a-z0-9.-]", ""

    $sam = $baseSam
    $counter = 1

    while (Get-ADUser -Filter "SamAccountName -eq '$sam'" -ErrorAction SilentlyContinue) {
        Write-Log "SamAccountName '$sam' already exists, trying another value" "WARNING"
        $sam = "$baseSam$counter"
        $counter++
    }

    Write-Log "Generated unique SamAccountName: $sam" "SUCCESS"
    return $sam
}

function New-TemporaryPassword {
    param(
        [int]$Length = 14
    )

    Add-Type -AssemblyName System.Web
    $password = [System.Web.Security.Membership]::GeneratePassword($Length, 3)
    Write-Log "Temporary password generated successfully" "SUCCESS"
    return $password
}

function Copy-TemplateGroups {
    param(
        [Parameter(Mandatory = $true)]
        [string]$TemplateSam,

        [Parameter(Mandatory = $true)]
        [string]$NewUserSam
    )

    Write-Log "Starting group copy from template '$TemplateSam' to user '$NewUserSam'"

    try {
        $templateGroups = Get-ADPrincipalGroupMembership -Identity $TemplateSam -ErrorAction Stop |
            Where-Object { $_.Name -ne "Domain Users" }

        if (-not $templateGroups) {
            Write-Log "No groups found to copy from template '$TemplateSam' (excluding Domain Users)" "WARNING"
            return
        }

        foreach ($group in $templateGroups) {
            try {
                Add-ADGroupMember -Identity $group -Members $NewUserSam -ErrorAction Stop
                Write-Log "Added '$NewUserSam' to group '$($group.Name)'" "SUCCESS"
            }
            catch {
                Write-Log "Failed to add '$NewUserSam' to group '$($group.Name)': $($_.Exception.Message)" "ERROR"
            }
        }
    }
    catch {
        Write-Log "Could not retrieve groups from template '$TemplateSam': $($_.Exception.Message)" "ERROR"
        throw
    }
}

function Get-DepartmentFromTemplateDN {
    param(
        [Parameter(Mandatory = $true)]
        [string]$DistinguishedName
    )

    if ($DistinguishedName -match 'CN=.*?,OU=([^,]+),OU=Templates,') {
        $department = $matches[1]
        Write-Log "Department '$department' derived from template DN" "SUCCESS"
        return $department
    }

    throw "Could not determine department from template DN: $DistinguishedName"
}

# =========================
# Discover current domain
# =========================

try {
    $currentDomain = Get-ADDomain -ErrorAction Stop
    $dnsRoot = $currentDomain.DNSRoot
    $domainDN = $currentDomain.DistinguishedName

    Write-Log "Detected domain DNS root: $dnsRoot" "SUCCESS"
    Write-Log "Detected domain DN: $domainDN" "SUCCESS"
}
catch {
    Write-Log "Could not discover the current Active Directory domain: $($_.Exception.Message)" "ERROR"
    exit 1
}

# ==========================
# JobTitle Template mapping
# =========================

$TemplateMap = @{
    "HR Advisor"  = "tpl.hr.advisor"
    "HR Director" = "tpl.hr.director"
}

if (-not $TemplateMap.ContainsKey($JobTitle)) {
    Write-Log "Job title '$JobTitle' is not defined in TemplateMap" "ERROR"
    Write-Log "Available values: $($TemplateMap.Keys -join ', ')" "INFO"
    exit 1
}

$templateSam = $TemplateMap[$JobTitle]
Write-Log "JobTitle '$JobTitle' mapped to template '$templateSam'" "SUCCESS"

# =========================
# Find template user
# =========================

try {
    $templateUser = Get-ADUser -Identity $templateSam -Properties DistinguishedName, DisplayName, MemberOf -ErrorAction Stop
    $templateDN = $templateUser.DistinguishedName

    Write-Log "Template user '$templateSam' found successfully" "SUCCESS"
    Write-Log "Template DisplayName: $($templateUser.DisplayName)" "INFO"
    Write-Log "Template DN: $templateDN" "INFO"
}
catch {
    Write-Log "Template user '$templateSam' was not found: $($_.Exception.Message)" "ERROR"
    exit 1
}

# =========================
# Derive department + target OU
# ===========================

try {
    $department = Get-DepartmentFromTemplateDN -DistinguishedName $templateDN
    $targetOU = "OU=$department,OU=Staff,$domainDN"

    Write-Log "Target OU calculated as: $targetOU" "SUCCESS"
}
catch {
    Write-Log $_.Exception.Message "ERROR"
    exit 1
}

try {
    Get-ADOrganizationalUnit -Identity $targetOU -ErrorAction Stop | Out-Null
    Write-Log "Verified target OU exists: $targetOU" "SUCCESS"
}
catch {
    Write-Log "Target OU does not exist: $targetOU" "ERROR"
    exit 1
}

$templateOU = ($templateDN -split ",", 2)[1]
Write-Log "Initial creation OU (same as template OU): $templateOU" "INFO"

# ===========================
# Generate new user details
# =========================

try {
    $displayName = "$FirstName $LastName"
    $samAccountName = New-UniqueSamAccountName -GivenName $FirstName -Surname $LastName
    $userPrincipalName = "$samAccountName@$dnsRoot"
    $tempPassword = New-TemporaryPassword
    $securePassword = ConvertTo-SecureString $tempPassword -AsPlainText -Force

    Write-Log "DisplayName set to: $displayName" "SUCCESS"
    Write-Log "UserPrincipalName set to: $userPrincipalName" "SUCCESS"
}
catch {
    Write-Log "Failed while preparing user details: $($_.Exception.Message)" "ERROR"
    exit 1
}

# =========================
# Create user in AD
# =========================

try {
    New-ADUser `
        -Name $displayName `
        -GivenName $FirstName `
        -Surname $LastName `
        -DisplayName $displayName `
        -SamAccountName $samAccountName `
        -UserPrincipalName $userPrincipalName `
        -Path $templateOU `
        -AccountPassword $securePassword `
        -Enabled $true `
        -ChangePasswordAtLogon $true `
        -Title $JobTitle `
        -Department $department `
        -Description "$JobTitle" `
        -ErrorAction Stop

    Write-Log "User '$displayName' created successfully in OU '$templateOU'" "SUCCESS"
}
catch {
    Write-Log "Failed to create user '$displayName': $($_.Exception.Message)" "ERROR"
    exit 1
}

# ========================================================
# Copy groups from template that you have already created
# ========================================================

try {
    Copy-TemplateGroups -TemplateSam $templateSam -NewUserSam $samAccountName
    Write-Log "Group copy step completed" "SUCCESS"
}
catch {
    Write-Log "Group copy step failed: $($_.Exception.Message)" "ERROR"
    exit 1
}

# =========================
# Move user to final OU
# =========================

try {
    $newUser = Get-ADUser -Identity $samAccountName -ErrorAction Stop
    Write-Log "Retrieved newly created user '$samAccountName' for OU move" "SUCCESS"

    Move-ADObject `
        -Identity $newUser.DistinguishedName `
        -TargetPath $targetOU `
        -ErrorAction Stop

    Write-Log "User '$samAccountName' moved successfully to '$targetOU'" "SUCCESS"
}
catch {
    Write-Log "Failed to move user '$samAccountName' to target OU: $($_.Exception.Message)" "ERROR"
    exit 1
}

# ================================================
# Final summary displayed in powershell window
# =================================================

Write-Log "========== ONBOARDING COMPLETE ==========" "SUCCESS"
Write-Log "Name              : $displayName" "INFO"
Write-Log "Username          : $samAccountName" "INFO"
Write-Log "UPN               : $userPrincipalName" "INFO"
Write-Log "Job Title         : $JobTitle" "INFO"
Write-Log "Department        : $department" "INFO"
Write-Log "Template Used     : $templateSam" "INFO"
Write-Log "Target OU         : $targetOU" "INFO"
Write-Log "Temporary Password: $tempPassword" "INFO"
Write-Log "Password Policy   : Must change at first logon" "INFO"
Write-Log "Reminder: communicate the temporary password through a secure channel." "WARNING"
Write-Log "Log file saved to: $LogFile" "SUCCESS"

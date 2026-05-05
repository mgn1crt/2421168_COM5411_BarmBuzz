# README.md 

BarmBuzz (2421168 - Mark Naylor)  
COM5411 | Enterprise Operating Systems (Bren Tighe)  
Submission: Wednesday 18th March 2026  

Repository link is: https://github.com/mgn1crt/2421168_COM5411_BarmBuzz  
ZIP per repository "" as of TBC TBC.

## 1. Solution overview

A single domain solution is implemented consisting of:

- Root domain: 'bolton.local'.

Software configuration is:

- Domain controller: Windows Server 2022.
- Windows client: Windows 11 Professional.
- Linux client: Ubuntu desktop.

DSC v3 is the primary control plane.

## 2. Architectural scope and boundaries

Text pending...

## 3. Automation strategy

DSC (Desired State Configuration) is planend for repeat-build automation.

## 4. Repository structure

```
+---Documentation
+---DSC
|   +---Configurations
|   +---Data
|   \---Outputs
+---Evidence
|   +---AD
|   +---AI_LOG
|   +---DSC
|   +---Git
|   |   \---Reflog
|   +---GPOBackups
|   +---HealthChecks
|   +---Network
|   +---Pester
|   \---Screenshots
+---Scripts
|   +---Helpers
|   \---Prereqs
\---Tests
    \---Pester
```

All paths are relative to ensure portability.

## 5. Execution order (Run Book)

- All commands to be executed in Powershell unless specified otherwise.
- Use an elevated terminal.
- Copy or type the code as specfied.

> Some sections apply only to specific machines, apply as noted.

#### Time configuration

Incorrect/mismatched time zone configuration can induce authorisation failiure due to Kerberos security restrictions.

> This section applies to all Windows machines.

1. **Time zone**

    Check the **Timezone**:

    ```Powershell
    Get-TimeZone
    ```

    Correct result (including daylight saving time setting) is:

    ```Powershell
    Id                         : GMT Standard Time
    DisplayName                : (UTC+00:00) Dublin, Edinburgh, Lisbon, London
    StandardName               : GMT Standard Time
    DaylightName               : GMT Summer Time
    BaseUtcOffset              : 00:00:00
    SupportsDaylightSavingTime : True
    ```

    If another result is displayed, correct it:

    ```Powershell
    Set-TimeZone -Name 'GMT Standard Time'
    ```
    Check the Timezone again:

    ```Powershell
    Get-TimeZone
    ```

#### Networking

> Apply to domain controller DC-BOLTON on the Windows Server 2025 machine only.

Required configuration for networking on DC-BOLTON:

| Hostname | Network adaptor | IPv4 Address & Subnet | IPv6 Address & Subnet | Note |
|----------|-----------------|-----------------------|-----------------------|------|
| BB-DC01 | Ethernet | Assigned via DHCP | Not used | NATed interface; no DNS registration
| | Ethernet 2 | 192.168.1.10 255.255.255.0 | Not used | Host only

1. **System hostname**

    Set the **Hostname**:

    ```Powershell
    Rename-Computer -NewName "BARM-DC-01" -Restart
    ```

2. **First network adaptor**

    IP addressing handled via DHCP.

    Prevent **DNS registration**:

    ```Powershell
    Set-DnsClient -InterfaceAlias "Ethernet" -RegisterThisConnectionsAddress $false
    ```

3. **Second network adaptor**:

    Configure **IP addressing** and **Default gateway**:

    ```Powershell
    New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress 192.168.1.10 -PrefixLength 24 -DefaultGateway 192.168.1.1
    ```

4. Set the **DNS server**:

    ```Powershell
    Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses 192.168.1.10
    ```

#### Update Windows

> This section applies to all Windows machines.

Apply Windows updates using the GUI.

#### Install PowerShell 7

> This section applies to all Windows machines.

Windows 11 and Windows Server 2025 include PowerShell 5.1; it is necessary to install PowerShell 7.x manually as both versions are required.

Install PowerShell 7.x using winget:

```Powershell
winget install -e --id Microsoft.PowerShell -s winget
```
> Powershell 7.x can be launched from within Windows using the command **pwsh**.

Verify installation in a Powershell 7 terminal:

```Powershell
$PSVersionTable
```

#### Desired State Configuration 3

> This section applies to all Windows machines.

1. Install DSC 3 using winget:

    ```Powershell
    winget install -e --id Microsoft.DSC -s winget
    ```

2. Verify installation:

    ```Powershell
    dsc --help
    ```
3. Modules:

    As platform neutrality is required, the PSResourceGet module must be installed.

    Verify availability of module PSResourceGet:

    ```Powershell
    Get-Module Microsoft.PowerShell.PSResourceGet -ListAvailable
    ```

    Add modules directory as destination of Windows PowerShell global module directory variable into shell:

    ```Powershell
    Get-Module Microsoft.PowerShell.PSResourceGet -ListAvailable
    ```

    Download required administrative DSC and Pester modules:

     ```Powershell
    Save-PSResource -Name ActiveDirectoryDsc -Version 6.6.0 -Repository PSGallery -Path $dest -TrustRepository
    Save-PSResource -Name GroupPolicyDsc -Version 1.0.3 -Repository PSGallery -Path $dest -TrustRepository
    Save-PSResource -Name PSDesiredStateConfiguration -Version 2.0.7 -Repository PSGallery -Path $dest -TrustRepository
    Save-PSResource -Name Pester -Version 5.7.1 -Repository PSGallery -Path $dest -TrustRepository
    Save-PSResource -Name ComputerManagementDsc -Repository PSGallery -Path $dest -TrustRepository
    ```

    Verify cross-version compatibility using a PowerShell 5.1 terminal:

     ```Powershell
    Get-Module ActiveDirectoryDsc,GroupPolicyDsc,PSDesiredStateConfiguration,Pester,ComputerManagementDsc -ListAvailable
    ```

    Install RSAT tools using a PowerShell 5.1 terminal:

    ```Powershell
    # On Windows Server 2025:
    Install-WindowsFeature -Name RSAT-AD-PowerShell -IncludeAllSubFeature
    Install-WindowsFeature -Name GPMC

    # On Windows 11:
    Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0
    Add-WindowsCapability -Online -Name Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0
    ``` 


## 6. Idempotence and re-run behaviour

Text pending...

## 7. Validation and testing model

Text pending...

## 8. Security considerations

Text pending...

## 9. Evidence mapping

Text pending...

## 10. Known limitations and reflections

Text pending...

## Bibliography:

- Microsoft (2026). Get-TimeZone (Microsoft.PowerShell.Management) - PowerShell. [online] Microsoft.com. Available at: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-timezone?view=powershell-7.5#:~:text=The%20Get%2DTimeZone%20cmdlet%20gets,list%20of%20available%20time%20zones. [Accessed 17 Mar. 2026].
- Microsoft (2026). Set-TimeZone (Microsoft.PowerShell.Management) - PowerShell. [online] Microsoft.com. Available at: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/set-timezone?view=powershell-7.5 [Accessed 17 Mar. 2026].

‌
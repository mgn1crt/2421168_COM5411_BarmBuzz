# NEW README.md

BarmBuzz (2421168 - Mark Naylor)  
COM5411 | Enterprise Operating Systems (Bren Tighe)  
Submission: Wednesday 18th March 2026  

Repository link is: https://github.com/mgn1crt/2421168_COM5411_BarmBuzz  
ZIP per repository "" as of TBC TBC.

# 1. Solution overview

A single domain solution is implemented consisting of:

- Root domain: 'bolton.local'.

Software configuration is:

- Domain controller: Windows Server 2022.
- Windows client: Windows 11 Professional.
- Linux client: Ubuntu desktop.

DSC v3 is the primary control plane.

# 2. Architectural scope and boundaries

- OUs (Operation units) are establsihed as 'Derby' and 'Nottingham' within the Bolton ('bolton.lcoal') domain.
- The domain is the security boundary, OUs exist for policy application based on localised requirements.

# 3. Automation strategy

DSC (Desired State Configuration) is planend for repeat-build automation encompassing the domain controller, users, groups, GPOs (Group Policy Objects), and OUs based on an initial framework.

# 4. Repository structure

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

# 5. Execution order (Run Book)

- All commands to be executed in Powershell unless specified otherwise.
- Use an elevated terminal.
- Copy or type the code as specfied.

## Bolton domain controller configuration.

1. **Time zone**

    Incorrect/mismatched time zone configuration can induce authorisation failiure due to Kerberos security restrictions.

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

    > Temp: Apply on Windows client too. !TEMP-NOTE-TO-SELF-REMOVE-LATER!

2. **Networking**

> The external/internal network adaptors shoudld match the names as specified below; if otherwise named correct these first to avoid confusion/misconfiguration.

Required configuration for networking on DC01:

| Hostname | Network adaptor | IPv4 Address & Subnet | IPv6 Address & Subnet | Note |
|----------|-----------------|-----------------------|-----------------------|------|
| DC01 | Ethernet | Assigned via DHCP | Not used | NATed interface; no DNS registration. Used for external internet access.
| | Ethernet 2 | 192.168.1.10 255.255.255.0 | Not used | Host only, used for AD purposes.

- Set the hostname:

    ```Powershell  
    Rename-Computer -NewName "DC-01" -Restart  
    ```

- Verify **Hostname**:

    ```Powershell
    hostname
    ```
- Prevent DNS registration on ***first*** network adaptor.

    ```Powershell
    Set-DnsClient -InterfaceAlias "Ethernet" -RegisterThisConnectionsAddress $false 
    ```

- Configure IP addressing and default gateway on ***second*** network adaptor:

    ```Powershell
    New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress 192.168.1.10 -PrefixLength 24 -DefaultGateway 192.168.1.1
    ```

- Set the DNS server on ***second*** network adaptor (to itself):

    ```Powershell
    Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses 192.168.1.10
    ```

3. **Windows Update**

- Apply Windows updates using the system GUI.

4. **Install PowerShell 7**

Windows 11 and Windows Server 2025 include PowerShell 5.1; it is necessary to install PowerShell 7.x manually as both versions are required.

- Install PowerShell 7.x using winget:

    ```Powershell
    winget install -e --id Microsoft.PowerShell -s winget
    ```

- Verify installation in a Powershell 7 terminal:

    ```Powershell
    $PSVersionTable
    ```

> Powershell 7.x can be launched from within Windows using the command **pwsh**.

5. **Install Desired State Configuration (DSC)**

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
 
    ```Powershell
    Install-Module Microsoft.PowerShell.PSResourceGet  
    ```

    Verify availability of module PSResourceGet:

    ```Powershell
    Get-Module Microsoft.PowerShell.PSResourceGet -ListAvailable
    ```

    Specify destination path:

    ```Powershell
    $dest = "C:\Program Files\WindowsPowerShell\Modules"
    ```

    Download required administrative DSC and Pester modules:

     ```Powershell
    Save-PSResource -Name ActiveDirectoryDsc -Version 6.6.0 -Repository PSGallery -Path $dest -TrustRepository
    Save-PSResource -Name GroupPolicyDsc -Version 1.0.3 -Repository PSGallery -Path $dest -TrustRepository
    Save-PSResource -Name xPSDesiredStateConfiguration -Version 9.2.1 -Repository PSGallery -Path $dest -TrustRepositor
    Save-PSResource -Name Pester -Version 5.7.1 -Repository PSGallery -Path $dest -TrustRepository
    Save-PSResource -Name ComputerManagementDsc -Repository PSGallery -Path $dest -TrustRepository
    Save-PSResource -Name NetworkingDsc -Repository PSGallery -Path $dest -TrustRepository
    ```

    Verify cross-version compatibility using a PowerShell 5.1 terminal:

     ```Powershell
    Get-Module ActiveDirectoryDsc,GroupPolicyDsc,PSDesiredStateConfiguration,Pester,ComputerManagementDsc -ListAvailable
    ```

    Install RSAT tools using a PowerShell 5.1 terminal:

    ```Powershell
    Get-Module Install-WindowsFeature -Name RSAT-AD-PowerShell -IncludeAllSubFeature
    ```

    Install Group Policy Management Console (for GPO management):

    ```Powershell
    Install-WindowsFeature -Name GPMC
    ```

    Return to a Powershell 7 terminal.
    Re-set destination path:

    ```Powershell
    $dest = "C:\Program Files\WindowsPowerShell\Modules"
    ```

    Pin ActiveDirectoryDsc module to version 6.6.0 for consistency:

    ```Powershell
    Save-PSResource -Name ActiveDirectoryDsc -version 6.6.0 -Repository PSGallery -Path $Dest -TrustRepository
    ```

    Verify ActiveDirectorySync using a Powershell 5.1 terminal:
    ```Powershell
    Get-Module -ListAvailable -Name ActiveDirectoryDsc
    ```

    Return to a PowerShell 7 terminal.
    Re-set destination path:

    ```Powershell
    $dest = "C:\Program Files\WindowsPowerShell\Modules"
    ```

    Install GroupPolicyDsc module for GPO management:
    
    ```Powershell
    Save-PSResource -Name GroupPolicyDsc -version 1.0.3 -Repository PSGallery -Path $Dest -TrustRepository
    ```

    Using a PowerShell 5.1 terminal, verify GroupPolicyDsc installation:

    ```Powershell
    Get-Module -ListAvailable -Name GroupPolicyDsc
    ``` 

    Re-set destination path:

    ```Powershell
    $dest = "C:\Program Files\WindowsPowerShell\Modules"
    ```

    Install Pester as a testing framework:

    ```Powershell
    Save-PSResource -Name Pester -RequiredVersion 5.7.1 -Repository PSGallery -Path $Dest -TrustRepository
    ```  

    ```Powershell
    # On Windows 11:
    Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0
    Add-WindowsCapability -Online -Name Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0
    ``` 

# Old Readme

### Bolton domain controller configuration

#### Update Windows

> This section applies to all Windows machines.

#### Install PowerShell 7

> This section applies to all Windows machines.

#### Desired State Configuration 3

> This section applies to all Windows machines.



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
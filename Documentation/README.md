# README.md 
# BarmBuzz (2421168 - Mark Naylor)
# COM5411 | Enterprise Operating Systems (Bren Tighe)
# Submission: Wednesday 18th March 2026

## Repository link is: https://github.com/mgn1crt/2421168_COM5411_BarmBuzz

## 1. Solution overview

Text pending...

## 2. Architectural scope and boundaries

Text pending...

## 3. Automation strategy

Text pending...

## 4. Repository structure

Text pending...

## 5. Execution order (Run Book)

Some intro text TBC...

- All commands to be executed in Powershell 7 unless specified otherwise.
- Use an elevated terminal.
- Copy or type the code as specfied in the fenced boxes.

All commands to be executed in Powershell 7 unless specified otherwisd
### Domain Controller BOLTON configuration

#### Time configuration

Incorrect/mismatched time zone configuration can induce authorisation failiure due to Kerberos security restrictions.

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
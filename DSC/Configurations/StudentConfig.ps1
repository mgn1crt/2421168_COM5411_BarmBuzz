<#
STUDENT TASK:
- Define Configuration StudentBaseline
- Use ConfigurationData (AllNodes.psd1)
- DO NOT hardcode passwords here.

CYBERSECURITY NOTES:
This is a Security module. Credential handling matters even in labs.

WHY NO HARDCODED CREDENTIALS?
1. Security Hygiene: Hardcoded credentials in code = security breach waiting to happen
2. Git History: Once committed, credentials are in your Git history FOREVER (even if you delete them later)
3. Professional Practice: Real environments use credential vaults (Azure KeyVault, HashiCorp Vault, etc.)
4. Audit Trail: Your Git commits may be reviewed by employers, peers, or examiners

HOW CREDENTIALS WILL WORK (Later weeks):
- The orchestrator (Run_BuildMain.ps1) will handle credential creation securely
- Your configuration receives them as PSCredential objects via parameters
- Example: Configuration StudentBaseline { param([PSCredential]$DomainCredential) }
- You reference them in DSC resources without seeing the plaintext password
- MOFs can be encrypted with certificates (production best practice)

FOR NOW (Week 1):
- Lab uses FIXED credentials documented in StudentRepoInit.ps1
- Administrator password: superw1n_user (Windows local admin)
- User accounts password: notlob2k26 (domain users you create)
- You may need these for MANUAL tasks, but NEVER put them in this file

THREAT MODEL AWARENESS:
Even in a lab, practice defense-in-depth:
- Assume your repo will be cloned by others (it will - it's Git!)
- Assume your transcripts/logs will be read (they're in Evidence/)
- Assume your build artifacts will be inspected (they're committed)
- NEVER commit: passwords, API keys, personal data, PII

If you accidentally commit a secret:
1. Rotating the secret is the ONLY fix (changing the password)
2. Deleting the file or "fixing" the commit does NOT remove it from Git history
3. Tools like git-secrets, TruffleHog, and GitGuardian scan for exposed secrets

This is not paranoia - this is professional discipline.
#>

Configuration StudentBaseline
{

    # Mandatory configuration parameters.
    param(
       # This section caused the key already used error and is therefore commented out.
       # [Parameter(Mandatory)]
       # [hashtable]$ConfigurationData

       [Parameter(Mandatory)]
       [PSCredential]$DomainAdminCredential,

       [Parameter(Mandatory)]
       [PSCredential]$DsrmCredential,

       [Parameter(Mandatory)]
       [PSCredential]$UserCredential
    )

    # Import modules.
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName ComputerManagementDSC
   # Import-DscResource -ModuleName ActivedirectoryDSC
    Import-DscResource -ModuleName NetworkingDsc -ModuleVersion 9.1.0

    # Import-DscResource = '@{ModuleName="NetworkingDsc"; RequiredVersion="9.1.0"}'.PowerSHell

    $nodes = $ConfigurationData.AllNodes

    Node localhost {
        # Pull the node object so every resource reads from the data plane.
        $node = $ConfigurationData.AllNodes | Where-Object { $_.NodeName -eq $Node.NodeName }

        # Baseline control 1: Computer identity.
        # Renaming is pre-requisite for stable AD DS identity.
        Computer SetComputerName
        {
            Name = $Node.ComputerName
        }

        # Baselien control 2: Time zone.
        # Kerberos and log forensics dependent on consistent time interpretation.
        TimeZone SetTimeZone
        {
            IsSingleInstance = 'Yes'
            TimeZone = $node.TimeZone
        }

        # Ensure C:\TEST exists
        File TestFolder {
            DestinationPath = 'C:\TEST'
            Type            = 'Directory'
            Ensure          = 'Present'
        }

        # Ensure C:\TEST\test.txt exists with content
        File TestFile {
            DestinationPath = 'C:\TEST\test.txt'
            Type            = 'File'
            Ensure          = 'Present'
            Contents        = 'Proof-of-life: DSC created this file.'
            DependsOn       = '[File]TestFolder'
        }            
    }

    # Baseline feature readiness.
    # Foreach utilised as WindowsFeature is a separate resource instance per feature name.
    foreach ($featureName in $Node.Features.Add)
    {
        WindowsFeature "Feature_$featureName"
        {
            Name = $featureName
            Ensure = 'Present'
        }
    }

    # Baseline network resources.
    # InterfaceAlias is necessary within lab environment to avoid multiple NIC confusion; explicit AddressFamily to avoid silent IPV6 selection.
    IPAddress StaticIPv4
    {
        IPAddress      = "$($node.Network.IPAddress)/$($node.Network.PrefixLength)"
        InterfaceAlias = $node.Network.InterfaceAlias
        AddressFamily  = [String]$node.Network.AddressFamily
        
        # Commented out as not valid.
        # PrefixLength   = $node.Network.PrefixLength
    }

    # Default gateway bound after IP presence to prevent incorrect application.
    DefaultGatewayAddress DefaultGateway
    {
        Address        = $node.Network.DefaultGateway
        InterfaceAlias = $node.Network.InterfaceAlias
        AddressFamily  = [String]$node.Network.AddressFamily
        DependsOn      = '[IPAddress]StaticIPv4'
    
    }

    # DNS client server address must bind to same intended interface and address family; key dependency for AD as DNS underpins domain discovery and record registration.
    DnsServerAddress DnsClientServers
    {
        Address        = $node.Network.DnsServers
        InterfaceAlias = $node.Network.InterfaceAlias
        AddressFamily  = [String]$node.Network.AddressFamily
        DependsOn      = '[IPAddress]StaticIPv4'
    }
}

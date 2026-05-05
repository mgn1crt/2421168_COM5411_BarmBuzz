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

Configuration StudentBaseline {

    # Mandatory configuration parameters.
    param(
       [Parameter(Mandatory)]
       [hashtable]$ConfigurationData,

       [Parameter(Mandatory)]
       [hashtable]$DomainAdminCredential,

       [Parameter(Mandatory)]
       [hashtable]$DsrmCredential,

       [Parameter(Mandatory)]
       [hashtable]$UserCredential
    )

    # Import modules.
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName ComputerManagementDSC
    #Import-DscResource -ModuleName ActivedirectoryDSC


    Node $AllNodes.NodeName {
        # Pull the node object so every resource reads from the data plane.
        $node = $ConfigurationData.AllNodes | Where-Object NodeName -eq $Node.NodeName

        # Baseline control 1: Computer identity.
        # Renaming is pre-requisite for stable AD DS identity.
        Computer SetComputerName
        {
            Name = $node.ComputerName
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
   
}

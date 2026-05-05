# Runbook (2421168 - Mark Naylor)

## Repository link is: https://github.com/mgn1crt/2421168_COM5411_BarmBuzz

## 06/03/2026 Imported template and updated Runbook.md:
1. Imported student template for git repository (as "Initial commit") from https://github.com/beeteetoo/Student_COM5411_Barmbuzz.

> Evidence: Documentation\Runbook.md per "Initial commit" of 06/03/2026 at 

2. Removed superfluous information (that being references to items outside of this repository) from this (Runbook.md) file.

> Evidence: Documentation\Runbook.md per "Initial template commit" of 06/03/2026.

3. Noted that procedure to resolve inability to commit was not fully resolved as expected:
    1. Initiai failiure to commit caused by apparent non-existence of keys was actually due to syntax error in GPG configuration.
    2. git config --global gpg.program "C:/Program Files/GunPG/bin/gpg.exe" was incorrectly entered without a forward-slash after C:.
    3. Commit was still subsequently blocked due to email privacy settings; this was resolved through use of the Github specified noreply email address.
    4. However, this resulted in a commit of the previous commit of Runbook.md shown as Unverified as the noreply address did not match the commiter email.
    5. This should be resolved through adding this additional email address to the key via *gpg --edit-key*.

> Evidence: Documentation\Runbook.md per "Updated Runbook.md" of 06/03/2026.

## 17/03/2026 0712 Updated Runbook.md:

1. Applied consistent improved format to Runbook and removed logging guidance from initial template (as of 06/03/2026 /1 above).
2. Provided single prioritised link (at start of document) to repository and removed duplicitous references to this per evidence detail (all commits inherently sit within the repository as specified in that URL).

> Evidence: Documentation\Runbook.md per "Updated Runbook.md" of 17/03/2026.

## 17/03/2026 0834 Updated Runbook.md/README.md skeleton upload:

1. Clarified updated file locations per evidence statements in Runbook.
2. Created skeleton for README.md.

> Evidence: Documentation\Runbook.md and Documentation\README.md per "Updated Runbook.md & README.md skeleton" of 17/03/2026.

## 05/05/2026 1116 Began ascertaining/confirming current status via Hello.Tests.ps1 pester test.

1. Ran Hello.Tests.ps1 pester test.
2. Received RuNtimeException: '-Be' is not a valid Should operator error; research indicates outdated Pester module currently installed.
3. Erroneously tried 'Import-Module Pester -RequiredVersion 5.7.1 -Force'.
4. Received 'Import-Module: The specified module 'Pester' with version '5.7.1' was not loaded because no valid module file was found in any module directory.
5. Resolved by updating using 'Install-Module -Name Pester -Force -SkipPublisherCheck'; completed successfully.
6. Attempted Hello.Tests.ps1 pester test again.
7. Received same error as per 2 above.
8. Listed current Pester module status via 'Get-Module Pester -ListAvailable'.
9. Noted two Pester versions, 3.4.0 and 5.7.1 installed.
10. Forced use of later version using 'Import-Module Pester -RequiredVersion 5.7.1 -Force'.
11. Attempted Hello.Tests.ps1 pester test again.
12. Test passed.

## 05/05/2026 1124 Continued ascertaining/confirming current status via Baseline.Tests.ps1 pester test.

1. Ran Baseline.Tests.ps1 pester test.
2. Realised scope of current work remaining and gained insight into this; this has been delayed by my current health.
3. Was using the Readme.md as a reference point (pre-constructing this file), rewriting this.
4. Applied DC-01 hostname to DC-TEST VM.

## 05/05/2026 1147 Verified hostname rename.

1. Ran 'hostname' command.
2. Updated Readme.md to specify this action to confirm rename.

> Evidence: Readme.md.

## 05/05/2026 1154 Ran Baseline.ps1 pester test.
1. Realised hostname was set incorrectly.
2. Corrected, repeating previous rename step to remove erroneous hyphen (i.e. DC-01 to DC01).

## 05/05/2026 1157 Verified hostname.
1. Verified hostname correct (as 'DC01').

## 05/05/2026 1159 Ran Baseline.ps1 pester test.

- Completed successfully.

## 05/05/2026 1215 Ran Preflight-Environment.Tests.ps1 pester test.

- Realised scope required in StudentConfig.ps1.
- Further updating Readme.md.
- Removed hostname function from StudentCOnfig.ps1 - this shouldn't be there.
- Readme.md currently split between New/Old layout internally while I work through correcting/updating it.

> Evidence: Readme.md.

## 05/05/2026 1344 Running initial commands on DC01 (in test/development VM):

- Get-TimeZone showed timezone is correctly set as 'GMT Standard Time'.
- hostname shows hostname correctly set as 'DC91'.
- Prevented DNS registration on 'Ethernet'.
- Set IP address and default gateway on 'Ethernet 2'.
- Set DNS server address to 'Ethernet 2' (as in, to itself).
- Checked and installed Windows updates.
- Installed [updated] PowerShell 7.
- Installed and verified installation of DSC.
- Checked for presence of PS module PSResourceGet; not found so installed.
- Corrected erroneous PSResourceGet installation and verification commands in Readme.md.
- Added required path destination to Readme.md.

> Evidence: Screenshots: '2026-05-05 1406 Switch configuration.png', '2026-05-05 1407 Ethernet 1 (External access) connection.png', '2026-05-05 1407 Ethernet 2 (Internal only) connection.png', '2026-05-05 1447 TimeZone.png', '2026-05-05 1450 Hostname shows correctly.png', '2026 05 05 1450 Ethernets configuration.png', '2026-05-05 1450 Ethernet configuration, PShell 7 install.png', '2026-05-05 1452 DSC installation.png', '2026-05-05 1506 PSResourceGet installation verified.png', '2026-05-05 1503 PSResourceGet installation.png'. '2026-05-05 1506 PSResourceGet installation verified.png', and '2026-05-05 1515 Required DSC and Pester module installation.png'.

# 05/05/2026 1527 PSDesiredStateConfiguration/RSAT:

- Experienced issues with assuring cross PowerShell (i.e. with PowerShell 5.1 too) compatibility.
- Noted was relying on guidance issued to run 'Save-PSResource -Name PSDesiredStateConfiguration -Version 2.0.7 -Repository PSGallery -Path $dest -TrustRepository'.
- Whereas verification command advised to run 'Get-Module ActiveDirectoryDsc,GroupPolicyDsc,xPSDesiredStateConfiguration,Pester,ComputerManagementDsc -ListAvailable'.
- PSDesiredStateConfiguration 2.0.7 does not equal xPSDesiredStateConfiguration 9.2.1 as shown in a subsequent expected result screenshot.
- Tried installing XPSDesiredStateConfiguration 9.2.1 using command 'Save-PSResource -Name xPSDesiredStateConfiguration -Version 9.2.1 -Repository PSGallery -Path $dest -TrustRepository'.
- This was successful and produced the expected result; accordingly Readme.md updated.
- Restart necessary for RSAT installation undertaken subsequently, so commit actioned first.

> Evidence: Screenshots: '2026-05-05 1533 XPSDC installation.png', and '2026-05-05 1533 Module installation verified.png'; Readme.md, and "PS module installation progress 1" commit.

# 05/05/2026 1558 Continued installations:
- Installed ActiveDirectoryDsc succesfully.
- Verified installations sucessfully.
- Pinned ActiveDirectoryDsc module to version 6.6.0, with Readme.md udpated to reflect this.
- Installed and verified GroupPolicyDsc module with Readme.md updated.
- Attempted installation of Pester; incorrect syntax corrected.
- Re-attempted Pester installation, verified successfully with Readme.md updated to reflect this.

> Evidence: Screenshots: '2026-05-05 1558 GPMC installation.png', '2026-05-05 1621 Module installation verified.png', and '2025-05-05 1627 Pester installation.png'; and "PS module installation progress 2" commit.

# 05/05/2026 1857 Screenshots
- Uploaded current screenshot files.
- Updated Readme.md with screenshot file names.

> Evidence: Screenshots as specified, Runbook.md, "Screenshot upload 1" commit.

# 05/05/2026 AllNodes.psd1
- Populated AllNodes.psd1 with baseline configuration items.

> Evidence: "Wk2S1 baseline data AllNodes naming time network features" commit.

# 05/05/2026 StudentConfig.ps1
- Populated StudentConfig.ps1 with baseline configuration items.

> Evidence: "Wk2S1 baseline enforce computer name and timezone" commit.

# 05/05/2026 Commenced Run_BuildMain.psl testing.
- Ran script initially incorrectly in PowerShell 5.1 terminal.
- Subsequently successfuly commenced execution in PowerShell 7 terminal.
- Then, parameter for DomainAdminCredential lacking, and computer name unspecified, and configuration directory does not have any files errors shown.
- Lack of configuration files was anticipated and will be corrected.
- Added mandatory parameters to StudentConfig.ps1.

> Evidence: DSC\Outputs, DSC\Evidence, StudentConfig.ps1, and "Updated StudentCOnfig.psl" commit.

# 05/05/2026 Repeated Run_BuildMain.psl testing.
- Ran script, apparent invalid character and unrecognised StudentBasline configuration object.
- Corrected three parameter types from incorrect Hashtable to PSCredential types.

> Evidence: DSC\Outputs, DSC\Evidence, StudentConfig.psl, and "Updated StudentConfig.psl" commit.

# 05/05/2026 2034 Repeated Run_BuildMain.psl testing.
- Ran script, same errors repeated.
- Multiple configuration changes tried as unable to establish.
- Finally fixed key already used error, was a hashtable reference; remains but commented out for identification.

> Evidence: DSC\Outputs, DSC\Evidence, StudentConfig.psl, and "Attempted StudentConfig.psl correction" commits.


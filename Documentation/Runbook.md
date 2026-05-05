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

> Evidence: **Screenshot filename pending** and "Intermittent commit - hostname" of 1134 05/05/2026.



